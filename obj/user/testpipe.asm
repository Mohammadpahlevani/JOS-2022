
obj/user/testpipe:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb 04 41 80 00 00 	movabs $0x804104,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 18 34 80 00 00 	movabs $0x803418,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba 10 41 80 00 00 	movabs $0x804110,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 cf 21 80 00 00 	movabs $0x8021cf,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba 29 41 80 00 00 	movabs $0x804129,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf 32 41 80 00 00 	movabs $0x804132,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 4f 41 80 00 00 	movabs $0x80414f,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 6c 41 80 00 00 	movabs $0x80416c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 42 15 80 00 00 	movabs $0x801542,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf 75 41 80 00 00 	movabs $0x804175,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf 91 41 80 00 00 	movabs $0x804191,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf 32 41 80 00 00 	movabs $0x804132,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf a4 41 80 00 00 	movabs $0x8041a4,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba c1 41 80 00 00 	movabs $0x8041c1,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb cb 41 80 00 00 	movabs $0x8041cb,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 18 34 80 00 00 	movabs $0x803418,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba 10 41 80 00 00 	movabs $0x804110,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 cf 21 80 00 00 	movabs $0x8021cf,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba 29 41 80 00 00 	movabs $0x804129,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf d8 41 80 00 00 	movabs $0x8041d8,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be da 41 80 00 00 	movabs $0x8041da,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf dc 41 80 00 00 	movabs $0x8041dc,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 e1 39 80 00 00 	movabs $0x8039e1,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf f9 41 80 00 00 	movabs $0x8041f9,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80054e:	48 b8 93 1c 80 00 00 	movabs $0x801c93,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	48 98                	cltq   
  80055c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800561:	48 89 c2             	mov    %rax,%rdx
  800564:	48 89 d0             	mov    %rdx,%rax
  800567:	48 c1 e0 03          	shl    $0x3,%rax
  80056b:	48 01 d0             	add    %rdx,%rax
  80056e:	48 c1 e0 05          	shl    $0x5,%rax
  800572:	48 89 c2             	mov    %rax,%rdx
  800575:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80057c:	00 00 00 
  80057f:	48 01 c2             	add    %rax,%rdx
  800582:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800589:	00 00 00 
  80058c:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800593:	7e 14                	jle    8005a9 <libmain+0x6a>
		binaryname = argv[0];
  800595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800599:	48 8b 10             	mov    (%rax),%rdx
  80059c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8005a3:	00 00 00 
  8005a6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005b0:	48 89 d6             	mov    %rdx,%rsi
  8005b3:	89 c7                	mov    %eax,%edi
  8005b5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005c1:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
}
  8005cd:	c9                   	leaveq 
  8005ce:	c3                   	retq   

00000000008005cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005d3:	48 b8 08 28 80 00 00 	movabs $0x802808,%rax
  8005da:	00 00 00 
  8005dd:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005df:	bf 00 00 00 00       	mov    $0x0,%edi
  8005e4:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  8005eb:	00 00 00 
  8005ee:	ff d0                	callq  *%rax
}
  8005f0:	5d                   	pop    %rbp
  8005f1:	c3                   	retq   

00000000008005f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f2:	55                   	push   %rbp
  8005f3:	48 89 e5             	mov    %rsp,%rbp
  8005f6:	53                   	push   %rbx
  8005f7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005fe:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800605:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80060b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800612:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800619:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800620:	84 c0                	test   %al,%al
  800622:	74 23                	je     800647 <_panic+0x55>
  800624:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80062b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80062f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800633:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800637:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80063b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80063f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800643:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800647:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80064e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800655:	00 00 00 
  800658:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80065f:	00 00 00 
  800662:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800666:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80066d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800674:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80067b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800682:	00 00 00 
  800685:	48 8b 18             	mov    (%rax),%rbx
  800688:	48 b8 93 1c 80 00 00 	movabs $0x801c93,%rax
  80068f:	00 00 00 
  800692:	ff d0                	callq  *%rax
  800694:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80069a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8006a1:	41 89 c8             	mov    %ecx,%r8d
  8006a4:	48 89 d1             	mov    %rdx,%rcx
  8006a7:	48 89 da             	mov    %rbx,%rdx
  8006aa:	89 c6                	mov    %eax,%esi
  8006ac:	48 bf 18 42 80 00 00 	movabs $0x804218,%rdi
  8006b3:	00 00 00 
  8006b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bb:	49 b9 2b 08 80 00 00 	movabs $0x80082b,%r9
  8006c2:	00 00 00 
  8006c5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d6:	48 89 d6             	mov    %rdx,%rsi
  8006d9:	48 89 c7             	mov    %rax,%rdi
  8006dc:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8006e3:	00 00 00 
  8006e6:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e8:	48 bf 3b 42 80 00 00 	movabs $0x80423b,%rdi
  8006ef:	00 00 00 
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8006fe:	00 00 00 
  800701:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800703:	cc                   	int3   
  800704:	eb fd                	jmp    800703 <_panic+0x111>

0000000000800706 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800706:	55                   	push   %rbp
  800707:	48 89 e5             	mov    %rsp,%rbp
  80070a:	48 83 ec 10          	sub    $0x10,%rsp
  80070e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800711:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800719:	8b 00                	mov    (%rax),%eax
  80071b:	8d 48 01             	lea    0x1(%rax),%ecx
  80071e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800722:	89 0a                	mov    %ecx,(%rdx)
  800724:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800727:	89 d1                	mov    %edx,%ecx
  800729:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80072d:	48 98                	cltq   
  80072f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073e:	75 2c                	jne    80076c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	48 98                	cltq   
  800748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074c:	48 83 c2 08          	add    $0x8,%rdx
  800750:	48 89 c6             	mov    %rax,%rsi
  800753:	48 89 d7             	mov    %rdx,%rdi
  800756:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
        b->idx = 0;
  800762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800766:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80076c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800770:	8b 40 04             	mov    0x4(%rax),%eax
  800773:	8d 50 01             	lea    0x1(%rax),%edx
  800776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80077d:	c9                   	leaveq 
  80077e:	c3                   	retq   

000000000080077f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80077f:	55                   	push   %rbp
  800780:	48 89 e5             	mov    %rsp,%rbp
  800783:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80078a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800791:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800798:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80079f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a6:	48 8b 0a             	mov    (%rdx),%rcx
  8007a9:	48 89 08             	mov    %rcx,(%rax)
  8007ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007c3:	00 00 00 
    b.cnt = 0;
  8007c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007cd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007d0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007de:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e5:	48 89 c6             	mov    %rax,%rsi
  8007e8:	48 bf 06 07 80 00 00 	movabs $0x800706,%rdi
  8007ef:	00 00 00 
  8007f2:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  8007f9:	00 00 00 
  8007fc:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007fe:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800804:	48 98                	cltq   
  800806:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80080d:	48 83 c2 08          	add    $0x8,%rdx
  800811:	48 89 c6             	mov    %rax,%rsi
  800814:	48 89 d7             	mov    %rdx,%rdi
  800817:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800823:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800829:	c9                   	leaveq 
  80082a:	c3                   	retq   

000000000080082b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800836:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80083d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800844:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80084b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800852:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800859:	84 c0                	test   %al,%al
  80085b:	74 20                	je     80087d <cprintf+0x52>
  80085d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800861:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800865:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800869:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80086d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800871:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800875:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800879:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80087d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800884:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80088b:	00 00 00 
  80088e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800895:	00 00 00 
  800898:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80089c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008bf:	48 8b 0a             	mov    (%rdx),%rcx
  8008c2:	48 89 08             	mov    %rcx,(%rax)
  8008c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008d5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008e3:	48 89 d6             	mov    %rdx,%rsi
  8008e6:	48 89 c7             	mov    %rax,%rdi
  8008e9:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8008f0:	00 00 00 
  8008f3:	ff d0                	callq  *%rax
  8008f5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008fb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800901:	c9                   	leaveq 
  800902:	c3                   	retq   

0000000000800903 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800903:	55                   	push   %rbp
  800904:	48 89 e5             	mov    %rsp,%rbp
  800907:	53                   	push   %rbx
  800908:	48 83 ec 38          	sub    $0x38,%rsp
  80090c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800914:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800918:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80091b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80091f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800923:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800926:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80092a:	77 3b                	ja     800967 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80092c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80092f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800933:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	48 f7 f3             	div    %rbx
  800942:	48 89 c2             	mov    %rax,%rdx
  800945:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800948:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80094b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	41 89 f9             	mov    %edi,%r9d
  800956:	48 89 c7             	mov    %rax,%rdi
  800959:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  800960:	00 00 00 
  800963:	ff d0                	callq  *%rax
  800965:	eb 1e                	jmp    800985 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800967:	eb 12                	jmp    80097b <printnum+0x78>
			putch(padc, putdat);
  800969:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80096d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800974:	48 89 ce             	mov    %rcx,%rsi
  800977:	89 d7                	mov    %edx,%edi
  800979:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80097b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80097f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800983:	7f e4                	jg     800969 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800985:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	48 f7 f1             	div    %rcx
  800994:	48 89 d0             	mov    %rdx,%rax
  800997:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  80099e:	00 00 00 
  8009a1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a5:	0f be d0             	movsbl %al,%edx
  8009a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	48 89 ce             	mov    %rcx,%rsi
  8009b3:	89 d7                	mov    %edx,%edi
  8009b5:	ff d0                	callq  *%rax
}
  8009b7:	48 83 c4 38          	add    $0x38,%rsp
  8009bb:	5b                   	pop    %rbx
  8009bc:	5d                   	pop    %rbp
  8009bd:	c3                   	retq   

00000000008009be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009be:	55                   	push   %rbp
  8009bf:	48 89 e5             	mov    %rsp,%rbp
  8009c2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009d1:	7e 52                	jle    800a25 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 24                	jae    800a02 <getuint+0x44>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	8b 12                	mov    (%rdx),%edx
  8009f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 0a                	mov    %ecx,(%rdx)
  800a00:	eb 17                	jmp    800a19 <getuint+0x5b>
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0a:	48 89 d0             	mov    %rdx,%rax
  800a0d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a19:	48 8b 00             	mov    (%rax),%rax
  800a1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a20:	e9 a3 00 00 00       	jmpq   800ac8 <getuint+0x10a>
	else if (lflag)
  800a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a29:	74 4f                	je     800a7a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2f:	8b 00                	mov    (%rax),%eax
  800a31:	83 f8 30             	cmp    $0x30,%eax
  800a34:	73 24                	jae    800a5a <getuint+0x9c>
  800a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a42:	8b 00                	mov    (%rax),%eax
  800a44:	89 c0                	mov    %eax,%eax
  800a46:	48 01 d0             	add    %rdx,%rax
  800a49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4d:	8b 12                	mov    (%rdx),%edx
  800a4f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a56:	89 0a                	mov    %ecx,(%rdx)
  800a58:	eb 17                	jmp    800a71 <getuint+0xb3>
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a62:	48 89 d0             	mov    %rdx,%rax
  800a65:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a71:	48 8b 00             	mov    (%rax),%rax
  800a74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a78:	eb 4e                	jmp    800ac8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	83 f8 30             	cmp    $0x30,%eax
  800a83:	73 24                	jae    800aa9 <getuint+0xeb>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	8b 00                	mov    (%rax),%eax
  800a93:	89 c0                	mov    %eax,%eax
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	8b 12                	mov    (%rdx),%edx
  800a9e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa5:	89 0a                	mov    %ecx,(%rdx)
  800aa7:	eb 17                	jmp    800ac0 <getuint+0x102>
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab1:	48 89 d0             	mov    %rdx,%rax
  800ab4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac0:	8b 00                	mov    (%rax),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800acc:	c9                   	leaveq 
  800acd:	c3                   	retq   

0000000000800ace <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ace:	55                   	push   %rbp
  800acf:	48 89 e5             	mov    %rsp,%rbp
  800ad2:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ad6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ada:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800add:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ae1:	7e 52                	jle    800b35 <getint+0x67>
		x=va_arg(*ap, long long);
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	8b 00                	mov    (%rax),%eax
  800ae9:	83 f8 30             	cmp    $0x30,%eax
  800aec:	73 24                	jae    800b12 <getint+0x44>
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	89 c0                	mov    %eax,%eax
  800afe:	48 01 d0             	add    %rdx,%rax
  800b01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b05:	8b 12                	mov    (%rdx),%edx
  800b07:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0e:	89 0a                	mov    %ecx,(%rdx)
  800b10:	eb 17                	jmp    800b29 <getint+0x5b>
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b1a:	48 89 d0             	mov    %rdx,%rax
  800b1d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b25:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b29:	48 8b 00             	mov    (%rax),%rax
  800b2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b30:	e9 a3 00 00 00       	jmpq   800bd8 <getint+0x10a>
	else if (lflag)
  800b35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b39:	74 4f                	je     800b8a <getint+0xbc>
		x=va_arg(*ap, long);
  800b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3f:	8b 00                	mov    (%rax),%eax
  800b41:	83 f8 30             	cmp    $0x30,%eax
  800b44:	73 24                	jae    800b6a <getint+0x9c>
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b52:	8b 00                	mov    (%rax),%eax
  800b54:	89 c0                	mov    %eax,%eax
  800b56:	48 01 d0             	add    %rdx,%rax
  800b59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5d:	8b 12                	mov    (%rdx),%edx
  800b5f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b66:	89 0a                	mov    %ecx,(%rdx)
  800b68:	eb 17                	jmp    800b81 <getint+0xb3>
  800b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b72:	48 89 d0             	mov    %rdx,%rax
  800b75:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b81:	48 8b 00             	mov    (%rax),%rax
  800b84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b88:	eb 4e                	jmp    800bd8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8e:	8b 00                	mov    (%rax),%eax
  800b90:	83 f8 30             	cmp    $0x30,%eax
  800b93:	73 24                	jae    800bb9 <getint+0xeb>
  800b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b99:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	8b 00                	mov    (%rax),%eax
  800ba3:	89 c0                	mov    %eax,%eax
  800ba5:	48 01 d0             	add    %rdx,%rax
  800ba8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bac:	8b 12                	mov    (%rdx),%edx
  800bae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb5:	89 0a                	mov    %ecx,(%rdx)
  800bb7:	eb 17                	jmp    800bd0 <getint+0x102>
  800bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc1:	48 89 d0             	mov    %rdx,%rax
  800bc4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bd0:	8b 00                	mov    (%rax),%eax
  800bd2:	48 98                	cltq   
  800bd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bdc:	c9                   	leaveq 
  800bdd:	c3                   	retq   

0000000000800bde <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bde:	55                   	push   %rbp
  800bdf:	48 89 e5             	mov    %rsp,%rbp
  800be2:	41 54                	push   %r12
  800be4:	53                   	push   %rbx
  800be5:	48 83 ec 60          	sub    $0x60,%rsp
  800be9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bed:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bf1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bf9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c01:	48 8b 0a             	mov    (%rdx),%rcx
  800c04:	48 89 08             	mov    %rcx,(%rax)
  800c07:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c0b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c0f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c13:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c17:	eb 17                	jmp    800c30 <vprintfmt+0x52>
			if (ch == '\0')
  800c19:	85 db                	test   %ebx,%ebx
  800c1b:	0f 84 cc 04 00 00    	je     8010ed <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800c21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c29:	48 89 d6             	mov    %rdx,%rsi
  800c2c:	89 df                	mov    %ebx,%edi
  800c2e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c30:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c38:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c3c:	0f b6 00             	movzbl (%rax),%eax
  800c3f:	0f b6 d8             	movzbl %al,%ebx
  800c42:	83 fb 25             	cmp    $0x25,%ebx
  800c45:	75 d2                	jne    800c19 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c47:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c4b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c52:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c60:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c67:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c6b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c6f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c73:	0f b6 00             	movzbl (%rax),%eax
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c7c:	83 f8 55             	cmp    $0x55,%eax
  800c7f:	0f 87 34 04 00 00    	ja     8010b9 <vprintfmt+0x4db>
  800c85:	89 c0                	mov    %eax,%eax
  800c87:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c8e:	00 
  800c8f:	48 b8 58 44 80 00 00 	movabs $0x804458,%rax
  800c96:	00 00 00 
  800c99:	48 01 d0             	add    %rdx,%rax
  800c9c:	48 8b 00             	mov    (%rax),%rax
  800c9f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ca1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ca5:	eb c0                	jmp    800c67 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cab:	eb ba                	jmp    800c67 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cb4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cb7:	89 d0                	mov    %edx,%eax
  800cb9:	c1 e0 02             	shl    $0x2,%eax
  800cbc:	01 d0                	add    %edx,%eax
  800cbe:	01 c0                	add    %eax,%eax
  800cc0:	01 d8                	add    %ebx,%eax
  800cc2:	83 e8 30             	sub    $0x30,%eax
  800cc5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cc8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ccc:	0f b6 00             	movzbl (%rax),%eax
  800ccf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd2:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd5:	7e 0c                	jle    800ce3 <vprintfmt+0x105>
  800cd7:	83 fb 39             	cmp    $0x39,%ebx
  800cda:	7f 07                	jg     800ce3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cdc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce1:	eb d1                	jmp    800cb4 <vprintfmt+0xd6>
			goto process_precision;
  800ce3:	eb 58                	jmp    800d3d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800ce5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce8:	83 f8 30             	cmp    $0x30,%eax
  800ceb:	73 17                	jae    800d04 <vprintfmt+0x126>
  800ced:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf4:	89 c0                	mov    %eax,%eax
  800cf6:	48 01 d0             	add    %rdx,%rax
  800cf9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfc:	83 c2 08             	add    $0x8,%edx
  800cff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d02:	eb 0f                	jmp    800d13 <vprintfmt+0x135>
  800d04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d08:	48 89 d0             	mov    %rdx,%rax
  800d0b:	48 83 c2 08          	add    $0x8,%rdx
  800d0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d13:	8b 00                	mov    (%rax),%eax
  800d15:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d18:	eb 23                	jmp    800d3d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800d1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1e:	79 0c                	jns    800d2c <vprintfmt+0x14e>
				width = 0;
  800d20:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d27:	e9 3b ff ff ff       	jmpq   800c67 <vprintfmt+0x89>
  800d2c:	e9 36 ff ff ff       	jmpq   800c67 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d31:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d38:	e9 2a ff ff ff       	jmpq   800c67 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d41:	79 12                	jns    800d55 <vprintfmt+0x177>
				width = precision, precision = -1;
  800d43:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d46:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d49:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d50:	e9 12 ff ff ff       	jmpq   800c67 <vprintfmt+0x89>
  800d55:	e9 0d ff ff ff       	jmpq   800c67 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d5a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d5e:	e9 04 ff ff ff       	jmpq   800c67 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d66:	83 f8 30             	cmp    $0x30,%eax
  800d69:	73 17                	jae    800d82 <vprintfmt+0x1a4>
  800d6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d72:	89 c0                	mov    %eax,%eax
  800d74:	48 01 d0             	add    %rdx,%rax
  800d77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7a:	83 c2 08             	add    $0x8,%edx
  800d7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d80:	eb 0f                	jmp    800d91 <vprintfmt+0x1b3>
  800d82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d86:	48 89 d0             	mov    %rdx,%rax
  800d89:	48 83 c2 08          	add    $0x8,%rdx
  800d8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d91:	8b 10                	mov    (%rax),%edx
  800d93:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 ce             	mov    %rcx,%rsi
  800d9e:	89 d7                	mov    %edx,%edi
  800da0:	ff d0                	callq  *%rax
			break;
  800da2:	e9 40 03 00 00       	jmpq   8010e7 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800da7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800daa:	83 f8 30             	cmp    $0x30,%eax
  800dad:	73 17                	jae    800dc6 <vprintfmt+0x1e8>
  800daf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db6:	89 c0                	mov    %eax,%eax
  800db8:	48 01 d0             	add    %rdx,%rax
  800dbb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbe:	83 c2 08             	add    $0x8,%edx
  800dc1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc4:	eb 0f                	jmp    800dd5 <vprintfmt+0x1f7>
  800dc6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dca:	48 89 d0             	mov    %rdx,%rax
  800dcd:	48 83 c2 08          	add    $0x8,%rdx
  800dd1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	79 02                	jns    800ddd <vprintfmt+0x1ff>
				err = -err;
  800ddb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ddd:	83 fb 15             	cmp    $0x15,%ebx
  800de0:	7f 16                	jg     800df8 <vprintfmt+0x21a>
  800de2:	48 b8 80 43 80 00 00 	movabs $0x804380,%rax
  800de9:	00 00 00 
  800dec:	48 63 d3             	movslq %ebx,%rdx
  800def:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df3:	4d 85 e4             	test   %r12,%r12
  800df6:	75 2e                	jne    800e26 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800df8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e00:	89 d9                	mov    %ebx,%ecx
  800e02:	48 ba 41 44 80 00 00 	movabs $0x804441,%rdx
  800e09:	00 00 00 
  800e0c:	48 89 c7             	mov    %rax,%rdi
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	49 b8 f6 10 80 00 00 	movabs $0x8010f6,%r8
  800e1b:	00 00 00 
  800e1e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e21:	e9 c1 02 00 00       	jmpq   8010e7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2e:	4c 89 e1             	mov    %r12,%rcx
  800e31:	48 ba 4a 44 80 00 00 	movabs $0x80444a,%rdx
  800e38:	00 00 00 
  800e3b:	48 89 c7             	mov    %rax,%rdi
  800e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e43:	49 b8 f6 10 80 00 00 	movabs $0x8010f6,%r8
  800e4a:	00 00 00 
  800e4d:	41 ff d0             	callq  *%r8
			break;
  800e50:	e9 92 02 00 00       	jmpq   8010e7 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e58:	83 f8 30             	cmp    $0x30,%eax
  800e5b:	73 17                	jae    800e74 <vprintfmt+0x296>
  800e5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e64:	89 c0                	mov    %eax,%eax
  800e66:	48 01 d0             	add    %rdx,%rax
  800e69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e6c:	83 c2 08             	add    $0x8,%edx
  800e6f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e72:	eb 0f                	jmp    800e83 <vprintfmt+0x2a5>
  800e74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e78:	48 89 d0             	mov    %rdx,%rax
  800e7b:	48 83 c2 08          	add    $0x8,%rdx
  800e7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e83:	4c 8b 20             	mov    (%rax),%r12
  800e86:	4d 85 e4             	test   %r12,%r12
  800e89:	75 0a                	jne    800e95 <vprintfmt+0x2b7>
				p = "(null)";
  800e8b:	49 bc 4d 44 80 00 00 	movabs $0x80444d,%r12
  800e92:	00 00 00 
			if (width > 0 && padc != '-')
  800e95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e99:	7e 3f                	jle    800eda <vprintfmt+0x2fc>
  800e9b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e9f:	74 39                	je     800eda <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea4:	48 98                	cltq   
  800ea6:	48 89 c6             	mov    %rax,%rsi
  800ea9:	4c 89 e7             	mov    %r12,%rdi
  800eac:	48 b8 a2 13 80 00 00 	movabs $0x8013a2,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
  800eb8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ebb:	eb 17                	jmp    800ed4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ebd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ec1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ec5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec9:	48 89 ce             	mov    %rcx,%rsi
  800ecc:	89 d7                	mov    %edx,%edi
  800ece:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ed8:	7f e3                	jg     800ebd <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eda:	eb 37                	jmp    800f13 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800edc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ee0:	74 1e                	je     800f00 <vprintfmt+0x322>
  800ee2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee5:	7e 05                	jle    800eec <vprintfmt+0x30e>
  800ee7:	83 fb 7e             	cmp    $0x7e,%ebx
  800eea:	7e 14                	jle    800f00 <vprintfmt+0x322>
					putch('?', putdat);
  800eec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef4:	48 89 d6             	mov    %rdx,%rsi
  800ef7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800efc:	ff d0                	callq  *%rax
  800efe:	eb 0f                	jmp    800f0f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800f00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f08:	48 89 d6             	mov    %rdx,%rsi
  800f0b:	89 df                	mov    %ebx,%edi
  800f0d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f13:	4c 89 e0             	mov    %r12,%rax
  800f16:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f1a:	0f b6 00             	movzbl (%rax),%eax
  800f1d:	0f be d8             	movsbl %al,%ebx
  800f20:	85 db                	test   %ebx,%ebx
  800f22:	74 10                	je     800f34 <vprintfmt+0x356>
  800f24:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f28:	78 b2                	js     800edc <vprintfmt+0x2fe>
  800f2a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f32:	79 a8                	jns    800edc <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f34:	eb 16                	jmp    800f4c <vprintfmt+0x36e>
				putch(' ', putdat);
  800f36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3e:	48 89 d6             	mov    %rdx,%rsi
  800f41:	bf 20 00 00 00       	mov    $0x20,%edi
  800f46:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f50:	7f e4                	jg     800f36 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f52:	e9 90 01 00 00       	jmpq   8010e7 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f5b:	be 03 00 00 00       	mov    $0x3,%esi
  800f60:	48 89 c7             	mov    %rax,%rdi
  800f63:	48 b8 ce 0a 80 00 00 	movabs $0x800ace,%rax
  800f6a:	00 00 00 
  800f6d:	ff d0                	callq  *%rax
  800f6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	48 85 c0             	test   %rax,%rax
  800f7a:	79 1d                	jns    800f99 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f84:	48 89 d6             	mov    %rdx,%rsi
  800f87:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f8c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	48 f7 d8             	neg    %rax
  800f95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa0:	e9 d5 00 00 00       	jmpq   80107a <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fa5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fa9:	be 03 00 00 00       	mov    $0x3,%esi
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	48 b8 be 09 80 00 00 	movabs $0x8009be,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
  800fbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fc1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fc8:	e9 ad 00 00 00       	jmpq   80107a <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800fcd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd1:	be 03 00 00 00       	mov    $0x3,%esi
  800fd6:	48 89 c7             	mov    %rax,%rdi
  800fd9:	48 b8 be 09 80 00 00 	movabs $0x8009be,%rax
  800fe0:	00 00 00 
  800fe3:	ff d0                	callq  *%rax
  800fe5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800fe9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800ff0:	e9 85 00 00 00       	jmpq   80107a <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ff5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ffd:	48 89 d6             	mov    %rdx,%rsi
  801000:	bf 30 00 00 00       	mov    $0x30,%edi
  801005:	ff d0                	callq  *%rax
			putch('x', putdat);
  801007:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80100b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80100f:	48 89 d6             	mov    %rdx,%rsi
  801012:	bf 78 00 00 00       	mov    $0x78,%edi
  801017:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801019:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80101c:	83 f8 30             	cmp    $0x30,%eax
  80101f:	73 17                	jae    801038 <vprintfmt+0x45a>
  801021:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801025:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801028:	89 c0                	mov    %eax,%eax
  80102a:	48 01 d0             	add    %rdx,%rax
  80102d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801030:	83 c2 08             	add    $0x8,%edx
  801033:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801036:	eb 0f                	jmp    801047 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801038:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80103c:	48 89 d0             	mov    %rdx,%rax
  80103f:	48 83 c2 08          	add    $0x8,%rdx
  801043:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801047:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80104e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801055:	eb 23                	jmp    80107a <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801057:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80105b:	be 03 00 00 00       	mov    $0x3,%esi
  801060:	48 89 c7             	mov    %rax,%rdi
  801063:	48 b8 be 09 80 00 00 	movabs $0x8009be,%rax
  80106a:	00 00 00 
  80106d:	ff d0                	callq  *%rax
  80106f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801073:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80107a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80107f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801082:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801085:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801089:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80108d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801091:	45 89 c1             	mov    %r8d,%r9d
  801094:	41 89 f8             	mov    %edi,%r8d
  801097:	48 89 c7             	mov    %rax,%rdi
  80109a:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  8010a1:	00 00 00 
  8010a4:	ff d0                	callq  *%rax
			break;
  8010a6:	eb 3f                	jmp    8010e7 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010a8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b0:	48 89 d6             	mov    %rdx,%rsi
  8010b3:	89 df                	mov    %ebx,%edi
  8010b5:	ff d0                	callq  *%rax
			break;
  8010b7:	eb 2e                	jmp    8010e7 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c1:	48 89 d6             	mov    %rdx,%rsi
  8010c4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010c9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010cb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d0:	eb 05                	jmp    8010d7 <vprintfmt+0x4f9>
  8010d2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010d7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010db:	48 83 e8 01          	sub    $0x1,%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 ec                	jne    8010d2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e8:	e9 43 fb ff ff       	jmpq   800c30 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010ed:	48 83 c4 60          	add    $0x60,%rsp
  8010f1:	5b                   	pop    %rbx
  8010f2:	41 5c                	pop    %r12
  8010f4:	5d                   	pop    %rbp
  8010f5:	c3                   	retq   

00000000008010f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801101:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801108:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80110f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801116:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80111d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801124:	84 c0                	test   %al,%al
  801126:	74 20                	je     801148 <printfmt+0x52>
  801128:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80112c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801130:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801134:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801138:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80113c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801140:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801144:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801148:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80114f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801156:	00 00 00 
  801159:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801160:	00 00 00 
  801163:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801167:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80116e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801175:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80117c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801183:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80118a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801191:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801198:	48 89 c7             	mov    %rax,%rdi
  80119b:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  8011a2:	00 00 00 
  8011a5:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 83 ec 10          	sub    $0x10,%rsp
  8011b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bc:	8b 40 10             	mov    0x10(%rax),%eax
  8011bf:	8d 50 01             	lea    0x1(%rax),%edx
  8011c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cd:	48 8b 10             	mov    (%rax),%rdx
  8011d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011d8:	48 39 c2             	cmp    %rax,%rdx
  8011db:	73 17                	jae    8011f4 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e1:	48 8b 00             	mov    (%rax),%rax
  8011e4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011ec:	48 89 0a             	mov    %rcx,(%rdx)
  8011ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011f2:	88 10                	mov    %dl,(%rax)
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 50          	sub    $0x50,%rsp
  8011fe:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801202:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801205:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801209:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80120d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801211:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801215:	48 8b 0a             	mov    (%rdx),%rcx
  801218:	48 89 08             	mov    %rcx,(%rax)
  80121b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80121f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801223:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801227:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80122b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80122f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801233:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801236:	48 98                	cltq   
  801238:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80123c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801240:	48 01 d0             	add    %rdx,%rax
  801243:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801247:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80124e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801253:	74 06                	je     80125b <vsnprintf+0x65>
  801255:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801259:	7f 07                	jg     801262 <vsnprintf+0x6c>
		return -E_INVAL;
  80125b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801260:	eb 2f                	jmp    801291 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801262:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801266:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80126a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80126e:	48 89 c6             	mov    %rax,%rsi
  801271:	48 bf a9 11 80 00 00 	movabs $0x8011a9,%rdi
  801278:	00 00 00 
  80127b:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  801282:	00 00 00 
  801285:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801287:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80128b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80128e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801291:	c9                   	leaveq 
  801292:	c3                   	retq   

0000000000801293 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801293:	55                   	push   %rbp
  801294:	48 89 e5             	mov    %rsp,%rbp
  801297:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80129e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012a5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012ab:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012b2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012b9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012c0:	84 c0                	test   %al,%al
  8012c2:	74 20                	je     8012e4 <snprintf+0x51>
  8012c4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012c8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012cc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012d0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012d4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012d8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012dc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012e0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012e4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012eb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012f2:	00 00 00 
  8012f5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012fc:	00 00 00 
  8012ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801303:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80130a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801311:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801318:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80131f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801326:	48 8b 0a             	mov    (%rdx),%rcx
  801329:	48 89 08             	mov    %rcx,(%rax)
  80132c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801330:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801334:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801338:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80133c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801343:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80134a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801350:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801357:	48 89 c7             	mov    %rax,%rdi
  80135a:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  801361:	00 00 00 
  801364:	ff d0                	callq  *%rax
  801366:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80136c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801372:	c9                   	leaveq 
  801373:	c3                   	retq   

0000000000801374 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	48 83 ec 18          	sub    $0x18,%rsp
  80137c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801387:	eb 09                	jmp    801392 <strlen+0x1e>
		n++;
  801389:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80138d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	84 c0                	test   %al,%al
  80139b:	75 ec                	jne    801389 <strlen+0x15>
		n++;
	return n;
  80139d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013a0:	c9                   	leaveq 
  8013a1:	c3                   	retq   

00000000008013a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 83 ec 20          	sub    $0x20,%rsp
  8013aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013b9:	eb 0e                	jmp    8013c9 <strnlen+0x27>
		n++;
  8013bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013c9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013ce:	74 0b                	je     8013db <strnlen+0x39>
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	84 c0                	test   %al,%al
  8013d9:	75 e0                	jne    8013bb <strnlen+0x19>
		n++;
	return n;
  8013db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013de:	c9                   	leaveq 
  8013df:	c3                   	retq   

00000000008013e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013e0:	55                   	push   %rbp
  8013e1:	48 89 e5             	mov    %rsp,%rbp
  8013e4:	48 83 ec 20          	sub    $0x20,%rsp
  8013e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013f8:	90                   	nop
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801401:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801405:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801409:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80140d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801411:	0f b6 12             	movzbl (%rdx),%edx
  801414:	88 10                	mov    %dl,(%rax)
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	84 c0                	test   %al,%al
  80141b:	75 dc                	jne    8013f9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801421:	c9                   	leaveq 
  801422:	c3                   	retq   

0000000000801423 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801423:	55                   	push   %rbp
  801424:	48 89 e5             	mov    %rsp,%rbp
  801427:	48 83 ec 20          	sub    $0x20,%rsp
  80142b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801437:	48 89 c7             	mov    %rax,%rdi
  80143a:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  801441:	00 00 00 
  801444:	ff d0                	callq  *%rax
  801446:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80144c:	48 63 d0             	movslq %eax,%rdx
  80144f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801453:	48 01 c2             	add    %rax,%rdx
  801456:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145a:	48 89 c6             	mov    %rax,%rsi
  80145d:	48 89 d7             	mov    %rdx,%rdi
  801460:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  801467:	00 00 00 
  80146a:	ff d0                	callq  *%rax
	return dst;
  80146c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 28          	sub    $0x28,%rsp
  80147a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801482:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80148e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801495:	00 
  801496:	eb 2a                	jmp    8014c2 <strncpy+0x50>
		*dst++ = *src;
  801498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014a8:	0f b6 12             	movzbl (%rdx),%edx
  8014ab:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b1:	0f b6 00             	movzbl (%rax),%eax
  8014b4:	84 c0                	test   %al,%al
  8014b6:	74 05                	je     8014bd <strncpy+0x4b>
			src++;
  8014b8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014ca:	72 cc                	jb     801498 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014d0:	c9                   	leaveq 
  8014d1:	c3                   	retq   

00000000008014d2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014d2:	55                   	push   %rbp
  8014d3:	48 89 e5             	mov    %rsp,%rbp
  8014d6:	48 83 ec 28          	sub    $0x28,%rsp
  8014da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014ee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014f3:	74 3d                	je     801532 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014f5:	eb 1d                	jmp    801514 <strlcpy+0x42>
			*dst++ = *src++;
  8014f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801503:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801507:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80150b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80150f:	0f b6 12             	movzbl (%rdx),%edx
  801512:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801514:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801519:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80151e:	74 0b                	je     80152b <strlcpy+0x59>
  801520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	84 c0                	test   %al,%al
  801529:	75 cc                	jne    8014f7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80152b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801532:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153a:	48 29 c2             	sub    %rax,%rdx
  80153d:	48 89 d0             	mov    %rdx,%rax
}
  801540:	c9                   	leaveq 
  801541:	c3                   	retq   

0000000000801542 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801542:	55                   	push   %rbp
  801543:	48 89 e5             	mov    %rsp,%rbp
  801546:	48 83 ec 10          	sub    $0x10,%rsp
  80154a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801552:	eb 0a                	jmp    80155e <strcmp+0x1c>
		p++, q++;
  801554:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801559:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80155e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801562:	0f b6 00             	movzbl (%rax),%eax
  801565:	84 c0                	test   %al,%al
  801567:	74 12                	je     80157b <strcmp+0x39>
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	0f b6 10             	movzbl (%rax),%edx
  801570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801574:	0f b6 00             	movzbl (%rax),%eax
  801577:	38 c2                	cmp    %al,%dl
  801579:	74 d9                	je     801554 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157f:	0f b6 00             	movzbl (%rax),%eax
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	0f b6 c0             	movzbl %al,%eax
  80158f:	29 c2                	sub    %eax,%edx
  801591:	89 d0                	mov    %edx,%eax
}
  801593:	c9                   	leaveq 
  801594:	c3                   	retq   

0000000000801595 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801595:	55                   	push   %rbp
  801596:	48 89 e5             	mov    %rsp,%rbp
  801599:	48 83 ec 18          	sub    $0x18,%rsp
  80159d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015a9:	eb 0f                	jmp    8015ba <strncmp+0x25>
		n--, p++, q++;
  8015ab:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015bf:	74 1d                	je     8015de <strncmp+0x49>
  8015c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c5:	0f b6 00             	movzbl (%rax),%eax
  8015c8:	84 c0                	test   %al,%al
  8015ca:	74 12                	je     8015de <strncmp+0x49>
  8015cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d0:	0f b6 10             	movzbl (%rax),%edx
  8015d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	38 c2                	cmp    %al,%dl
  8015dc:	74 cd                	je     8015ab <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015e3:	75 07                	jne    8015ec <strncmp+0x57>
		return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb 18                	jmp    801604 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	0f b6 d0             	movzbl %al,%edx
  8015f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	0f b6 c0             	movzbl %al,%eax
  801600:	29 c2                	sub    %eax,%edx
  801602:	89 d0                	mov    %edx,%eax
}
  801604:	c9                   	leaveq 
  801605:	c3                   	retq   

0000000000801606 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801606:	55                   	push   %rbp
  801607:	48 89 e5             	mov    %rsp,%rbp
  80160a:	48 83 ec 0c          	sub    $0xc,%rsp
  80160e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801612:	89 f0                	mov    %esi,%eax
  801614:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801617:	eb 17                	jmp    801630 <strchr+0x2a>
		if (*s == c)
  801619:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801623:	75 06                	jne    80162b <strchr+0x25>
			return (char *) s;
  801625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801629:	eb 15                	jmp    801640 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80162b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801634:	0f b6 00             	movzbl (%rax),%eax
  801637:	84 c0                	test   %al,%al
  801639:	75 de                	jne    801619 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801640:	c9                   	leaveq 
  801641:	c3                   	retq   

0000000000801642 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801642:	55                   	push   %rbp
  801643:	48 89 e5             	mov    %rsp,%rbp
  801646:	48 83 ec 0c          	sub    $0xc,%rsp
  80164a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164e:	89 f0                	mov    %esi,%eax
  801650:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801653:	eb 13                	jmp    801668 <strfind+0x26>
		if (*s == c)
  801655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80165f:	75 02                	jne    801663 <strfind+0x21>
			break;
  801661:	eb 10                	jmp    801673 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801663:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	84 c0                	test   %al,%al
  801671:	75 e2                	jne    801655 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801677:	c9                   	leaveq 
  801678:	c3                   	retq   

0000000000801679 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801679:	55                   	push   %rbp
  80167a:	48 89 e5             	mov    %rsp,%rbp
  80167d:	48 83 ec 18          	sub    $0x18,%rsp
  801681:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801685:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801688:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80168c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801691:	75 06                	jne    801699 <memset+0x20>
		return v;
  801693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801697:	eb 69                	jmp    801702 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	83 e0 03             	and    $0x3,%eax
  8016a0:	48 85 c0             	test   %rax,%rax
  8016a3:	75 48                	jne    8016ed <memset+0x74>
  8016a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a9:	83 e0 03             	and    $0x3,%eax
  8016ac:	48 85 c0             	test   %rax,%rax
  8016af:	75 3c                	jne    8016ed <memset+0x74>
		c &= 0xFF;
  8016b1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016bb:	c1 e0 18             	shl    $0x18,%eax
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c3:	c1 e0 10             	shl    $0x10,%eax
  8016c6:	09 c2                	or     %eax,%edx
  8016c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cb:	c1 e0 08             	shl    $0x8,%eax
  8016ce:	09 d0                	or     %edx,%eax
  8016d0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d7:	48 c1 e8 02          	shr    $0x2,%rax
  8016db:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e5:	48 89 d7             	mov    %rdx,%rdi
  8016e8:	fc                   	cld    
  8016e9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016eb:	eb 11                	jmp    8016fe <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016f8:	48 89 d7             	mov    %rdx,%rdi
  8016fb:	fc                   	cld    
  8016fc:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801702:	c9                   	leaveq 
  801703:	c3                   	retq   

0000000000801704 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
  801708:	48 83 ec 28          	sub    $0x28,%rsp
  80170c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801710:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801714:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801718:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80171c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801730:	0f 83 88 00 00 00    	jae    8017be <memmove+0xba>
  801736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173e:	48 01 d0             	add    %rdx,%rax
  801741:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801745:	76 77                	jbe    8017be <memmove+0xba>
		s += n;
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80174f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801753:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175b:	83 e0 03             	and    $0x3,%eax
  80175e:	48 85 c0             	test   %rax,%rax
  801761:	75 3b                	jne    80179e <memmove+0x9a>
  801763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801767:	83 e0 03             	and    $0x3,%eax
  80176a:	48 85 c0             	test   %rax,%rax
  80176d:	75 2f                	jne    80179e <memmove+0x9a>
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	83 e0 03             	and    $0x3,%eax
  801776:	48 85 c0             	test   %rax,%rax
  801779:	75 23                	jne    80179e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80177b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177f:	48 83 e8 04          	sub    $0x4,%rax
  801783:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801787:	48 83 ea 04          	sub    $0x4,%rdx
  80178b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80178f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801793:	48 89 c7             	mov    %rax,%rdi
  801796:	48 89 d6             	mov    %rdx,%rsi
  801799:	fd                   	std    
  80179a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80179c:	eb 1d                	jmp    8017bb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80179e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017aa:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b2:	48 89 d7             	mov    %rdx,%rdi
  8017b5:	48 89 c1             	mov    %rax,%rcx
  8017b8:	fd                   	std    
  8017b9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017bb:	fc                   	cld    
  8017bc:	eb 57                	jmp    801815 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c2:	83 e0 03             	and    $0x3,%eax
  8017c5:	48 85 c0             	test   %rax,%rax
  8017c8:	75 36                	jne    801800 <memmove+0xfc>
  8017ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ce:	83 e0 03             	and    $0x3,%eax
  8017d1:	48 85 c0             	test   %rax,%rax
  8017d4:	75 2a                	jne    801800 <memmove+0xfc>
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	83 e0 03             	and    $0x3,%eax
  8017dd:	48 85 c0             	test   %rax,%rax
  8017e0:	75 1e                	jne    801800 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	48 c1 e8 02          	shr    $0x2,%rax
  8017ea:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f5:	48 89 c7             	mov    %rax,%rdi
  8017f8:	48 89 d6             	mov    %rdx,%rsi
  8017fb:	fc                   	cld    
  8017fc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017fe:	eb 15                	jmp    801815 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801800:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801804:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801808:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80180c:	48 89 c7             	mov    %rax,%rdi
  80180f:	48 89 d6             	mov    %rdx,%rsi
  801812:	fc                   	cld    
  801813:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801819:	c9                   	leaveq 
  80181a:	c3                   	retq   

000000000080181b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
  80181f:	48 83 ec 18          	sub    $0x18,%rsp
  801823:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80182b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80182f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801833:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183b:	48 89 ce             	mov    %rcx,%rsi
  80183e:	48 89 c7             	mov    %rax,%rdi
  801841:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 28          	sub    $0x28,%rsp
  801857:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80185b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80185f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801867:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80186b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801873:	eb 36                	jmp    8018ab <memcmp+0x5c>
		if (*s1 != *s2)
  801875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801879:	0f b6 10             	movzbl (%rax),%edx
  80187c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	38 c2                	cmp    %al,%dl
  801885:	74 1a                	je     8018a1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801887:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188b:	0f b6 00             	movzbl (%rax),%eax
  80188e:	0f b6 d0             	movzbl %al,%edx
  801891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	0f b6 c0             	movzbl %al,%eax
  80189b:	29 c2                	sub    %eax,%edx
  80189d:	89 d0                	mov    %edx,%eax
  80189f:	eb 20                	jmp    8018c1 <memcmp+0x72>
		s1++, s2++;
  8018a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018af:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018b7:	48 85 c0             	test   %rax,%rax
  8018ba:	75 b9                	jne    801875 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	c9                   	leaveq 
  8018c2:	c3                   	retq   

00000000008018c3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018c3:	55                   	push   %rbp
  8018c4:	48 89 e5             	mov    %rsp,%rbp
  8018c7:	48 83 ec 28          	sub    $0x28,%rsp
  8018cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018de:	48 01 d0             	add    %rdx,%rax
  8018e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018e5:	eb 15                	jmp    8018fc <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018eb:	0f b6 10             	movzbl (%rax),%edx
  8018ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018f1:	38 c2                	cmp    %al,%dl
  8018f3:	75 02                	jne    8018f7 <memfind+0x34>
			break;
  8018f5:	eb 0f                	jmp    801906 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801900:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801904:	72 e1                	jb     8018e7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 34          	sub    $0x34,%rsp
  801914:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801918:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80191c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80191f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801926:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80192d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80192e:	eb 05                	jmp    801935 <strtol+0x29>
		s++;
  801930:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	3c 20                	cmp    $0x20,%al
  80193e:	74 f0                	je     801930 <strtol+0x24>
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	0f b6 00             	movzbl (%rax),%eax
  801947:	3c 09                	cmp    $0x9,%al
  801949:	74 e5                	je     801930 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80194b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194f:	0f b6 00             	movzbl (%rax),%eax
  801952:	3c 2b                	cmp    $0x2b,%al
  801954:	75 07                	jne    80195d <strtol+0x51>
		s++;
  801956:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195b:	eb 17                	jmp    801974 <strtol+0x68>
	else if (*s == '-')
  80195d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801961:	0f b6 00             	movzbl (%rax),%eax
  801964:	3c 2d                	cmp    $0x2d,%al
  801966:	75 0c                	jne    801974 <strtol+0x68>
		s++, neg = 1;
  801968:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801974:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801978:	74 06                	je     801980 <strtol+0x74>
  80197a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80197e:	75 28                	jne    8019a8 <strtol+0x9c>
  801980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801984:	0f b6 00             	movzbl (%rax),%eax
  801987:	3c 30                	cmp    $0x30,%al
  801989:	75 1d                	jne    8019a8 <strtol+0x9c>
  80198b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198f:	48 83 c0 01          	add    $0x1,%rax
  801993:	0f b6 00             	movzbl (%rax),%eax
  801996:	3c 78                	cmp    $0x78,%al
  801998:	75 0e                	jne    8019a8 <strtol+0x9c>
		s += 2, base = 16;
  80199a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80199f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019a6:	eb 2c                	jmp    8019d4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ac:	75 19                	jne    8019c7 <strtol+0xbb>
  8019ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	3c 30                	cmp    $0x30,%al
  8019b7:	75 0e                	jne    8019c7 <strtol+0xbb>
		s++, base = 8;
  8019b9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019be:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019c5:	eb 0d                	jmp    8019d4 <strtol+0xc8>
	else if (base == 0)
  8019c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019cb:	75 07                	jne    8019d4 <strtol+0xc8>
		base = 10;
  8019cd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d8:	0f b6 00             	movzbl (%rax),%eax
  8019db:	3c 2f                	cmp    $0x2f,%al
  8019dd:	7e 1d                	jle    8019fc <strtol+0xf0>
  8019df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e3:	0f b6 00             	movzbl (%rax),%eax
  8019e6:	3c 39                	cmp    $0x39,%al
  8019e8:	7f 12                	jg     8019fc <strtol+0xf0>
			dig = *s - '0';
  8019ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ee:	0f b6 00             	movzbl (%rax),%eax
  8019f1:	0f be c0             	movsbl %al,%eax
  8019f4:	83 e8 30             	sub    $0x30,%eax
  8019f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019fa:	eb 4e                	jmp    801a4a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a00:	0f b6 00             	movzbl (%rax),%eax
  801a03:	3c 60                	cmp    $0x60,%al
  801a05:	7e 1d                	jle    801a24 <strtol+0x118>
  801a07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0b:	0f b6 00             	movzbl (%rax),%eax
  801a0e:	3c 7a                	cmp    $0x7a,%al
  801a10:	7f 12                	jg     801a24 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a16:	0f b6 00             	movzbl (%rax),%eax
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a22:	eb 26                	jmp    801a4a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	3c 40                	cmp    $0x40,%al
  801a2d:	7e 48                	jle    801a77 <strtol+0x16b>
  801a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a33:	0f b6 00             	movzbl (%rax),%eax
  801a36:	3c 5a                	cmp    $0x5a,%al
  801a38:	7f 3d                	jg     801a77 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3e:	0f b6 00             	movzbl (%rax),%eax
  801a41:	0f be c0             	movsbl %al,%eax
  801a44:	83 e8 37             	sub    $0x37,%eax
  801a47:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a4d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a50:	7c 02                	jl     801a54 <strtol+0x148>
			break;
  801a52:	eb 23                	jmp    801a77 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a54:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a59:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a5c:	48 98                	cltq   
  801a5e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a63:	48 89 c2             	mov    %rax,%rdx
  801a66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a69:	48 98                	cltq   
  801a6b:	48 01 d0             	add    %rdx,%rax
  801a6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a72:	e9 5d ff ff ff       	jmpq   8019d4 <strtol+0xc8>

	if (endptr)
  801a77:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a7c:	74 0b                	je     801a89 <strtol+0x17d>
		*endptr = (char *) s;
  801a7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a86:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a8d:	74 09                	je     801a98 <strtol+0x18c>
  801a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a93:	48 f7 d8             	neg    %rax
  801a96:	eb 04                	jmp    801a9c <strtol+0x190>
  801a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <strstr>:

char * strstr(const char *in, const char *str)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 30          	sub    $0x30,%rsp
  801aa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aaa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801aae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ab2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ab6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aba:	0f b6 00             	movzbl (%rax),%eax
  801abd:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ac0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ac4:	75 06                	jne    801acc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ac6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aca:	eb 6b                	jmp    801b37 <strstr+0x99>

	len = strlen(str);
  801acc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ad0:	48 89 c7             	mov    %rax,%rdi
  801ad3:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
  801adf:	48 98                	cltq   
  801ae1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801af1:	0f b6 00             	movzbl (%rax),%eax
  801af4:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801af7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801afb:	75 07                	jne    801b04 <strstr+0x66>
				return (char *) 0;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	eb 33                	jmp    801b37 <strstr+0x99>
		} while (sc != c);
  801b04:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b08:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b0b:	75 d8                	jne    801ae5 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b11:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b19:	48 89 ce             	mov    %rcx,%rsi
  801b1c:	48 89 c7             	mov    %rax,%rdi
  801b1f:	48 b8 95 15 80 00 00 	movabs $0x801595,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	callq  *%rax
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	75 b6                	jne    801ae5 <strstr+0x47>

	return (char *) (in - 1);
  801b2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b33:	48 83 e8 01          	sub    $0x1,%rax
}
  801b37:	c9                   	leaveq 
  801b38:	c3                   	retq   

0000000000801b39 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	53                   	push   %rbx
  801b3e:	48 83 ec 48          	sub    $0x48,%rsp
  801b42:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b45:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b48:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b4c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b50:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b54:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801b58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b5b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b5f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b63:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b67:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b6b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b6f:	4c 89 c3             	mov    %r8,%rbx
  801b72:	cd 30                	int    $0x30
  801b74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801b78:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b7c:	74 3e                	je     801bbc <syscall+0x83>
  801b7e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b83:	7e 37                	jle    801bbc <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b89:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b8c:	49 89 d0             	mov    %rdx,%r8
  801b8f:	89 c1                	mov    %eax,%ecx
  801b91:	48 ba 08 47 80 00 00 	movabs $0x804708,%rdx
  801b98:	00 00 00 
  801b9b:	be 4a 00 00 00       	mov    $0x4a,%esi
  801ba0:	48 bf 25 47 80 00 00 	movabs $0x804725,%rdi
  801ba7:	00 00 00 
  801baa:	b8 00 00 00 00       	mov    $0x0,%eax
  801baf:	49 b9 f2 05 80 00 00 	movabs $0x8005f2,%r9
  801bb6:	00 00 00 
  801bb9:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bc0:	48 83 c4 48          	add    $0x48,%rsp
  801bc4:	5b                   	pop    %rbx
  801bc5:	5d                   	pop    %rbp
  801bc6:	c3                   	retq   

0000000000801bc7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bc7:	55                   	push   %rbp
  801bc8:	48 89 e5             	mov    %rsp,%rbp
  801bcb:	48 83 ec 20          	sub    $0x20,%rsp
  801bcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be6:	00 
  801be7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf3:	48 89 d1             	mov    %rdx,%rcx
  801bf6:	48 89 c2             	mov    %rax,%rdx
  801bf9:	be 00 00 00 00       	mov    $0x0,%esi
  801bfe:	bf 00 00 00 00       	mov    $0x0,%edi
  801c03:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c20:	00 
  801c21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	be 00 00 00 00       	mov    $0x0,%esi
  801c3c:	bf 01 00 00 00       	mov    $0x1,%edi
  801c41:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 10          	sub    $0x10,%rsp
  801c57:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5d:	48 98                	cltq   
  801c5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c66:	00 
  801c67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c78:	48 89 c2             	mov    %rax,%rdx
  801c7b:	be 01 00 00 00       	mov    $0x1,%esi
  801c80:	bf 03 00 00 00       	mov    $0x3,%edi
  801c85:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801c8c:	00 00 00 
  801c8f:	ff d0                	callq  *%rax
}
  801c91:	c9                   	leaveq 
  801c92:	c3                   	retq   

0000000000801c93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c93:	55                   	push   %rbp
  801c94:	48 89 e5             	mov    %rsp,%rbp
  801c97:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca2:	00 
  801ca3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801caf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb9:	be 00 00 00 00       	mov    $0x0,%esi
  801cbe:	bf 02 00 00 00       	mov    $0x2,%edi
  801cc3:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
}
  801ccf:	c9                   	leaveq 
  801cd0:	c3                   	retq   

0000000000801cd1 <sys_yield>:

void
sys_yield(void)
{
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cd9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce0:	00 
  801ce1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ced:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d01:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	48 83 ec 20          	sub    $0x20,%rsp
  801d17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d1e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d24:	48 63 c8             	movslq %eax,%rcx
  801d27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2e:	48 98                	cltq   
  801d30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d37:	00 
  801d38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3e:	49 89 c8             	mov    %rcx,%r8
  801d41:	48 89 d1             	mov    %rdx,%rcx
  801d44:	48 89 c2             	mov    %rax,%rdx
  801d47:	be 01 00 00 00       	mov    $0x1,%esi
  801d4c:	bf 04 00 00 00       	mov    $0x4,%edi
  801d51:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
}
  801d5d:	c9                   	leaveq 
  801d5e:	c3                   	retq   

0000000000801d5f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d5f:	55                   	push   %rbp
  801d60:	48 89 e5             	mov    %rsp,%rbp
  801d63:	48 83 ec 30          	sub    $0x30,%rsp
  801d67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d71:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d75:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d79:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d7c:	48 63 c8             	movslq %eax,%rcx
  801d7f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d86:	48 63 f0             	movslq %eax,%rsi
  801d89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d90:	48 98                	cltq   
  801d92:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d96:	49 89 f9             	mov    %rdi,%r9
  801d99:	49 89 f0             	mov    %rsi,%r8
  801d9c:	48 89 d1             	mov    %rdx,%rcx
  801d9f:	48 89 c2             	mov    %rax,%rdx
  801da2:	be 01 00 00 00       	mov    $0x1,%esi
  801da7:	bf 05 00 00 00       	mov    $0x5,%edi
  801dac:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801db3:	00 00 00 
  801db6:	ff d0                	callq  *%rax
}
  801db8:	c9                   	leaveq 
  801db9:	c3                   	retq   

0000000000801dba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 20          	sub    $0x20,%rsp
  801dc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	48 98                	cltq   
  801dd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd9:	00 
  801dda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de6:	48 89 d1             	mov    %rdx,%rcx
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	be 01 00 00 00       	mov    $0x1,%esi
  801df1:	bf 06 00 00 00       	mov    $0x6,%edi
  801df6:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
}
  801e02:	c9                   	leaveq 
  801e03:	c3                   	retq   

0000000000801e04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e04:	55                   	push   %rbp
  801e05:	48 89 e5             	mov    %rsp,%rbp
  801e08:	48 83 ec 10          	sub    $0x10,%rsp
  801e0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e0f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e15:	48 63 d0             	movslq %eax,%rdx
  801e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1b:	48 98                	cltq   
  801e1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e24:	00 
  801e25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e31:	48 89 d1             	mov    %rdx,%rcx
  801e34:	48 89 c2             	mov    %rax,%rdx
  801e37:	be 01 00 00 00       	mov    $0x1,%esi
  801e3c:	bf 08 00 00 00       	mov    $0x8,%edi
  801e41:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801e48:	00 00 00 
  801e4b:	ff d0                	callq  *%rax
}
  801e4d:	c9                   	leaveq 
  801e4e:	c3                   	retq   

0000000000801e4f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e4f:	55                   	push   %rbp
  801e50:	48 89 e5             	mov    %rsp,%rbp
  801e53:	48 83 ec 20          	sub    $0x20,%rsp
  801e57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	48 98                	cltq   
  801e67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6e:	00 
  801e6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7b:	48 89 d1             	mov    %rdx,%rcx
  801e7e:	48 89 c2             	mov    %rax,%rdx
  801e81:	be 01 00 00 00       	mov    $0x1,%esi
  801e86:	bf 09 00 00 00       	mov    $0x9,%edi
  801e8b:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	callq  *%rax
}
  801e97:	c9                   	leaveq 
  801e98:	c3                   	retq   

0000000000801e99 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e99:	55                   	push   %rbp
  801e9a:	48 89 e5             	mov    %rsp,%rbp
  801e9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ea1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ea4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ea8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eaf:	48 98                	cltq   
  801eb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eb8:	00 
  801eb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ebf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec5:	48 89 d1             	mov    %rdx,%rcx
  801ec8:	48 89 c2             	mov    %rax,%rdx
  801ecb:	be 01 00 00 00       	mov    $0x1,%esi
  801ed0:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ed5:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801edc:	00 00 00 
  801edf:	ff d0                	callq  *%rax
}
  801ee1:	c9                   	leaveq 
  801ee2:	c3                   	retq   

0000000000801ee3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ee3:	55                   	push   %rbp
  801ee4:	48 89 e5             	mov    %rsp,%rbp
  801ee7:	48 83 ec 20          	sub    $0x20,%rsp
  801eeb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ef2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ef6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ef9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801efc:	48 63 f0             	movslq %eax,%rsi
  801eff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f06:	48 98                	cltq   
  801f08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f13:	00 
  801f14:	49 89 f1             	mov    %rsi,%r9
  801f17:	49 89 c8             	mov    %rcx,%r8
  801f1a:	48 89 d1             	mov    %rdx,%rcx
  801f1d:	48 89 c2             	mov    %rax,%rdx
  801f20:	be 00 00 00 00       	mov    $0x0,%esi
  801f25:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f2a:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801f31:	00 00 00 
  801f34:	ff d0                	callq  *%rax
}
  801f36:	c9                   	leaveq 
  801f37:	c3                   	retq   

0000000000801f38 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f38:	55                   	push   %rbp
  801f39:	48 89 e5             	mov    %rsp,%rbp
  801f3c:	48 83 ec 10          	sub    $0x10,%rsp
  801f40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f4f:	00 
  801f50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f61:	48 89 c2             	mov    %rax,%rdx
  801f64:	be 01 00 00 00       	mov    $0x1,%esi
  801f69:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f6e:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	53                   	push   %rbx
  801f81:	48 83 ec 48          	sub    $0x48,%rsp
  801f85:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f89:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801f8d:	48 8b 00             	mov    (%rax),%rax
  801f90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801f94:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801f98:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f9c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa7:	48 89 c2             	mov    %rax,%rdx
  801faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb1:	01 00 00 
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801fbc:	48 b8 93 1c 80 00 00 	movabs $0x801c93,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801fd3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fd7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fdd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801fe1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fe4:	83 e0 02             	and    $0x2,%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	0f 84 8d 00 00 00    	je     80207c <pgfault+0x100>
  801fef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff3:	25 00 08 00 00       	and    $0x800,%eax
  801ff8:	48 85 c0             	test   %rax,%rax
  801ffb:	74 7f                	je     80207c <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801ffd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802000:	ba 07 00 00 00       	mov    $0x7,%edx
  802005:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80200a:	89 c7                	mov    %eax,%edi
  80200c:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  802013:	00 00 00 
  802016:	ff d0                	callq  *%rax
  802018:	85 c0                	test   %eax,%eax
  80201a:	75 60                	jne    80207c <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  80201c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802020:	ba 00 10 00 00       	mov    $0x1000,%edx
  802025:	48 89 c6             	mov    %rax,%rsi
  802028:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80202d:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  802039:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80203d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802040:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802043:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802049:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80204e:	89 c7                	mov    %eax,%edi
  802050:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
  80205c:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  80205e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802061:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802066:	89 c7                	mov    %eax,%edi
  802068:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  80206f:	00 00 00 
  802072:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  802074:	09 d8                	or     %ebx,%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	75 02                	jne    80207c <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  80207a:	eb 2a                	jmp    8020a6 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  80207c:	48 ba 33 47 80 00 00 	movabs $0x804733,%rdx
  802083:	00 00 00 
  802086:	be 26 00 00 00       	mov    $0x26,%esi
  80208b:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  802092:	00 00 00 
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  8020a1:	00 00 00 
  8020a4:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  8020a6:	48 83 c4 48          	add    $0x48,%rsp
  8020aa:	5b                   	pop    %rbx
  8020ab:	5d                   	pop    %rbp
  8020ac:	c3                   	retq   

00000000008020ad <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020ad:	55                   	push   %rbp
  8020ae:	48 89 e5             	mov    %rsp,%rbp
  8020b1:	53                   	push   %rbx
  8020b2:	48 83 ec 38          	sub    $0x38,%rsp
  8020b6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020b9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  8020bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c3:	01 00 00 
  8020c6:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8020c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  8020d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8020da:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  8020dd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020e0:	48 c1 e0 0c          	shl    $0xc,%rax
  8020e4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  8020e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020eb:	25 00 04 00 00       	and    $0x400,%eax
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	74 30                	je     802124 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  8020f4:	8b 75 dc             	mov    -0x24(%rbp),%esi
  8020f7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8020fb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8020fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802102:	41 89 f0             	mov    %esi,%r8d
  802105:	48 89 c6             	mov    %rax,%rsi
  802108:	bf 00 00 00 00       	mov    $0x0,%edi
  80210d:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802114:	00 00 00 
  802117:	ff d0                	callq  *%rax
  802119:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  80211c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80211f:	e9 a4 00 00 00       	jmpq   8021c8 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  802124:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802127:	83 e0 02             	and    $0x2,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 0c                	jne    80213a <duppage+0x8d>
  80212e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802131:	25 00 08 00 00       	and    $0x800,%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	74 63                	je     80219d <duppage+0xf0>
		perm &= ~PTE_W;
  80213a:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  80213e:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  802145:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802148:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80214c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80214f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802153:	41 89 f0             	mov    %esi,%r8d
  802156:	48 89 c6             	mov    %rax,%rsi
  802159:	bf 00 00 00 00       	mov    $0x0,%edi
  80215e:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
  80216a:	89 c3                	mov    %eax,%ebx
  80216c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80216f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802173:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802177:	41 89 c8             	mov    %ecx,%r8d
  80217a:	48 89 d1             	mov    %rdx,%rcx
  80217d:	ba 00 00 00 00       	mov    $0x0,%edx
  802182:	48 89 c6             	mov    %rax,%rsi
  802185:	bf 00 00 00 00       	mov    $0x0,%edi
  80218a:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	09 d8                	or     %ebx,%eax
  802198:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80219b:	eb 28                	jmp    8021c5 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  80219d:	8b 75 dc             	mov    -0x24(%rbp),%esi
  8021a0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8021a4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8021a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ab:	41 89 f0             	mov    %esi,%r8d
  8021ae:	48 89 c6             	mov    %rax,%rsi
  8021b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b6:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
  8021c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  8021c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8021c8:	48 83 c4 38          	add    $0x38,%rsp
  8021cc:	5b                   	pop    %rbx
  8021cd:	5d                   	pop    %rbp
  8021ce:	c3                   	retq   

00000000008021cf <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  8021cf:	55                   	push   %rbp
  8021d0:	48 89 e5             	mov    %rsp,%rbp
  8021d3:	53                   	push   %rbx
  8021d4:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  8021d8:	48 bf 7c 1f 80 00 00 	movabs $0x801f7c,%rdi
  8021df:	00 00 00 
  8021e2:	48 b8 31 3d 80 00 00 	movabs $0x803d31,%rax
  8021e9:	00 00 00 
  8021ec:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021ee:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f3:	cd 30                	int    $0x30
  8021f5:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021f8:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  8021fb:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  8021fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802202:	79 30                	jns    802234 <fork+0x65>
  802204:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802207:	89 c1                	mov    %eax,%ecx
  802209:	48 ba 5a 47 80 00 00 	movabs $0x80475a,%rdx
  802210:	00 00 00 
  802213:	be 72 00 00 00       	mov    $0x72,%esi
  802218:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  80221f:	00 00 00 
  802222:	b8 00 00 00 00       	mov    $0x0,%eax
  802227:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  80222e:	00 00 00 
  802231:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802234:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802238:	75 46                	jne    802280 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  80223a:	48 b8 93 1c 80 00 00 	movabs $0x801c93,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
  802246:	25 ff 03 00 00       	and    $0x3ff,%eax
  80224b:	48 63 d0             	movslq %eax,%rdx
  80224e:	48 89 d0             	mov    %rdx,%rax
  802251:	48 c1 e0 03          	shl    $0x3,%rax
  802255:	48 01 d0             	add    %rdx,%rax
  802258:	48 c1 e0 05          	shl    $0x5,%rax
  80225c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802263:	00 00 00 
  802266:	48 01 c2             	add    %rax,%rdx
  802269:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802270:	00 00 00 
  802273:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	e9 12 02 00 00       	jmpq   802492 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802280:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802283:	ba 07 00 00 00       	mov    $0x7,%edx
  802288:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80228d:	89 c7                	mov    %eax,%edi
  80228f:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
  80229b:	89 45 c8             	mov    %eax,-0x38(%rbp)
  80229e:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  8022a2:	79 30                	jns    8022d4 <fork+0x105>
		panic("fork failed: %e\n", result);
  8022a4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a7:	89 c1                	mov    %eax,%ecx
  8022a9:	48 ba 5a 47 80 00 00 	movabs $0x80475a,%rdx
  8022b0:	00 00 00 
  8022b3:	be 79 00 00 00       	mov    $0x79,%esi
  8022b8:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  8022bf:	00 00 00 
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c7:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8022ce:	00 00 00 
  8022d1:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8022d4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8022db:	00 
  8022dc:	e9 40 01 00 00       	jmpq   802421 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  8022e1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022e8:	01 00 00 
  8022eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f3:	83 e0 01             	and    $0x1,%eax
  8022f6:	48 85 c0             	test   %rax,%rax
  8022f9:	0f 84 1d 01 00 00    	je     80241c <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  8022ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802303:	48 c1 e0 09          	shl    $0x9,%rax
  802307:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80230b:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  802312:	00 
  802313:	e9 f6 00 00 00       	jmpq   80240e <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  802318:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80231c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802320:	48 01 c2             	add    %rax,%rdx
  802323:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80232a:	01 00 00 
  80232d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802331:	83 e0 01             	and    $0x1,%eax
  802334:	48 85 c0             	test   %rax,%rax
  802337:	0f 84 cc 00 00 00    	je     802409 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  80233d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802341:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802345:	48 01 d0             	add    %rdx,%rax
  802348:	48 c1 e0 09          	shl    $0x9,%rax
  80234c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  802350:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  802357:	00 
  802358:	e9 9e 00 00 00       	jmpq   8023fb <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  80235d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802361:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802365:	48 01 c2             	add    %rax,%rdx
  802368:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80236f:	01 00 00 
  802372:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802376:	83 e0 01             	and    $0x1,%eax
  802379:	48 85 c0             	test   %rax,%rax
  80237c:	74 78                	je     8023f6 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  80237e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802382:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802386:	48 01 d0             	add    %rdx,%rax
  802389:	48 c1 e0 09          	shl    $0x9,%rax
  80238d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  802391:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802398:	00 
  802399:	eb 51                	jmp    8023ec <fork+0x21d>
								entry = base_pde + pte;
  80239b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80239f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8023a3:	48 01 d0             	add    %rdx,%rax
  8023a6:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  8023aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b1:	01 00 00 
  8023b4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8023b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bc:	83 e0 01             	and    $0x1,%eax
  8023bf:	48 85 c0             	test   %rax,%rax
  8023c2:	74 23                	je     8023e7 <fork+0x218>
  8023c4:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  8023cb:	00 
  8023cc:	74 19                	je     8023e7 <fork+0x218>
									duppage(cid, entry);
  8023ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8023d2:	89 c2                	mov    %eax,%edx
  8023d4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8023d7:	89 d6                	mov    %edx,%esi
  8023d9:	89 c7                	mov    %eax,%edi
  8023db:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  8023e7:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8023ec:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  8023f3:	00 
  8023f4:	76 a5                	jbe    80239b <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  8023f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8023fb:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802402:	00 
  802403:	0f 86 54 ff ff ff    	jbe    80235d <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802409:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80240e:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  802415:	00 
  802416:	0f 86 fc fe ff ff    	jbe    802318 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  80241c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802421:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802426:	0f 84 b5 fe ff ff    	je     8022e1 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  80242c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80242f:	48 be c6 3d 80 00 00 	movabs $0x803dc6,%rsi
  802436:	00 00 00 
  802439:	89 c7                	mov    %eax,%edi
  80243b:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	89 c3                	mov    %eax,%ebx
  802449:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80244c:	be 02 00 00 00       	mov    $0x2,%esi
  802451:	89 c7                	mov    %eax,%edi
  802453:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	09 d8                	or     %ebx,%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 2a                	je     80248f <fork+0x2c0>
		panic("fork failed\n");
  802465:	48 ba 6b 47 80 00 00 	movabs $0x80476b,%rdx
  80246c:	00 00 00 
  80246f:	be 92 00 00 00       	mov    $0x92,%esi
  802474:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  80247b:	00 00 00 
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
  802483:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  80248a:	00 00 00 
  80248d:	ff d1                	callq  *%rcx
	return cid;
  80248f:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802492:	48 83 c4 58          	add    $0x58,%rsp
  802496:	5b                   	pop    %rbx
  802497:	5d                   	pop    %rbp
  802498:	c3                   	retq   

0000000000802499 <sfork>:


// Challenge!
int
sfork(void)
{
  802499:	55                   	push   %rbp
  80249a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80249d:	48 ba 78 47 80 00 00 	movabs $0x804778,%rdx
  8024a4:	00 00 00 
  8024a7:	be 9c 00 00 00       	mov    $0x9c,%esi
  8024ac:	48 bf 4f 47 80 00 00 	movabs $0x80474f,%rdi
  8024b3:	00 00 00 
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  8024c2:	00 00 00 
  8024c5:	ff d1                	callq  *%rcx

00000000008024c7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024c7:	55                   	push   %rbp
  8024c8:	48 89 e5             	mov    %rsp,%rbp
  8024cb:	48 83 ec 08          	sub    $0x8,%rsp
  8024cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024d7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024de:	ff ff ff 
  8024e1:	48 01 d0             	add    %rdx,%rax
  8024e4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024e8:	c9                   	leaveq 
  8024e9:	c3                   	retq   

00000000008024ea <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024ea:	55                   	push   %rbp
  8024eb:	48 89 e5             	mov    %rsp,%rbp
  8024ee:	48 83 ec 08          	sub    $0x8,%rsp
  8024f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fa:	48 89 c7             	mov    %rax,%rdi
  8024fd:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
  802509:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80250f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 18          	sub    $0x18,%rsp
  80251d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802521:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802528:	eb 6b                	jmp    802595 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80252a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252d:	48 98                	cltq   
  80252f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802535:	48 c1 e0 0c          	shl    $0xc,%rax
  802539:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80253d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802541:	48 c1 e8 15          	shr    $0x15,%rax
  802545:	48 89 c2             	mov    %rax,%rdx
  802548:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80254f:	01 00 00 
  802552:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802556:	83 e0 01             	and    $0x1,%eax
  802559:	48 85 c0             	test   %rax,%rax
  80255c:	74 21                	je     80257f <fd_alloc+0x6a>
  80255e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802562:	48 c1 e8 0c          	shr    $0xc,%rax
  802566:	48 89 c2             	mov    %rax,%rdx
  802569:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802570:	01 00 00 
  802573:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802577:	83 e0 01             	and    $0x1,%eax
  80257a:	48 85 c0             	test   %rax,%rax
  80257d:	75 12                	jne    802591 <fd_alloc+0x7c>
			*fd_store = fd;
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802587:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
  80258f:	eb 1a                	jmp    8025ab <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802591:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802595:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802599:	7e 8f                	jle    80252a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80259b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025a6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ab:	c9                   	leaveq 
  8025ac:	c3                   	retq   

00000000008025ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025ad:	55                   	push   %rbp
  8025ae:	48 89 e5             	mov    %rsp,%rbp
  8025b1:	48 83 ec 20          	sub    $0x20,%rsp
  8025b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025c0:	78 06                	js     8025c8 <fd_lookup+0x1b>
  8025c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025c6:	7e 07                	jle    8025cf <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cd:	eb 6c                	jmp    80263b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d2:	48 98                	cltq   
  8025d4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025da:	48 c1 e0 0c          	shl    $0xc,%rax
  8025de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e6:	48 c1 e8 15          	shr    $0x15,%rax
  8025ea:	48 89 c2             	mov    %rax,%rdx
  8025ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f4:	01 00 00 
  8025f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fb:	83 e0 01             	and    $0x1,%eax
  8025fe:	48 85 c0             	test   %rax,%rax
  802601:	74 21                	je     802624 <fd_lookup+0x77>
  802603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802607:	48 c1 e8 0c          	shr    $0xc,%rax
  80260b:	48 89 c2             	mov    %rax,%rdx
  80260e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802615:	01 00 00 
  802618:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261c:	83 e0 01             	and    $0x1,%eax
  80261f:	48 85 c0             	test   %rax,%rax
  802622:	75 07                	jne    80262b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802629:	eb 10                	jmp    80263b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80262b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802633:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leaveq 
  80263c:	c3                   	retq   

000000000080263d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80263d:	55                   	push   %rbp
  80263e:	48 89 e5             	mov    %rsp,%rbp
  802641:	48 83 ec 30          	sub    $0x30,%rsp
  802645:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802649:	89 f0                	mov    %esi,%eax
  80264b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80264e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802652:	48 89 c7             	mov    %rax,%rdi
  802655:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
  802661:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802665:	48 89 d6             	mov    %rdx,%rsi
  802668:	89 c7                	mov    %eax,%edi
  80266a:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
  802676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267d:	78 0a                	js     802689 <fd_close+0x4c>
	    || fd != fd2)
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802687:	74 12                	je     80269b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802689:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80268d:	74 05                	je     802694 <fd_close+0x57>
  80268f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802692:	eb 05                	jmp    802699 <fd_close+0x5c>
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
  802699:	eb 69                	jmp    802704 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80269b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80269f:	8b 00                	mov    (%rax),%eax
  8026a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026a5:	48 89 d6             	mov    %rdx,%rsi
  8026a8:	89 c7                	mov    %eax,%edi
  8026aa:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bd:	78 2a                	js     8026e9 <fd_close+0xac>
		if (dev->dev_close)
  8026bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026c7:	48 85 c0             	test   %rax,%rax
  8026ca:	74 16                	je     8026e2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026d8:	48 89 d7             	mov    %rdx,%rdi
  8026db:	ff d0                	callq  *%rax
  8026dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e0:	eb 07                	jmp    8026e9 <fd_close+0xac>
		else
			r = 0;
  8026e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	48 89 c6             	mov    %rax,%rsi
  8026f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f5:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
	return r;
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802704:	c9                   	leaveq 
  802705:	c3                   	retq   

0000000000802706 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802706:	55                   	push   %rbp
  802707:	48 89 e5             	mov    %rsp,%rbp
  80270a:	48 83 ec 20          	sub    $0x20,%rsp
  80270e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802711:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80271c:	eb 41                	jmp    80275f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80271e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802725:	00 00 00 
  802728:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80272b:	48 63 d2             	movslq %edx,%rdx
  80272e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802732:	8b 00                	mov    (%rax),%eax
  802734:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802737:	75 22                	jne    80275b <dev_lookup+0x55>
			*dev = devtab[i];
  802739:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802740:	00 00 00 
  802743:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802746:	48 63 d2             	movslq %edx,%rdx
  802749:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80274d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802751:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	eb 60                	jmp    8027bb <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80275b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80275f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802766:	00 00 00 
  802769:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276c:	48 63 d2             	movslq %edx,%rdx
  80276f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802773:	48 85 c0             	test   %rax,%rax
  802776:	75 a6                	jne    80271e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802778:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80277f:	00 00 00 
  802782:	48 8b 00             	mov    (%rax),%rax
  802785:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80278e:	89 c6                	mov    %eax,%esi
  802790:	48 bf 90 47 80 00 00 	movabs $0x804790,%rdi
  802797:	00 00 00 
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
  80279f:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  8027a6:	00 00 00 
  8027a9:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027af:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027bb:	c9                   	leaveq 
  8027bc:	c3                   	retq   

00000000008027bd <close>:

int
close(int fdnum)
{
  8027bd:	55                   	push   %rbp
  8027be:	48 89 e5             	mov    %rsp,%rbp
  8027c1:	48 83 ec 20          	sub    $0x20,%rsp
  8027c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027cf:	48 89 d6             	mov    %rdx,%rsi
  8027d2:	89 c7                	mov    %eax,%edi
  8027d4:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e7:	79 05                	jns    8027ee <close+0x31>
		return r;
  8027e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ec:	eb 18                	jmp    802806 <close+0x49>
	else
		return fd_close(fd, 1);
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	be 01 00 00 00       	mov    $0x1,%esi
  8027f7:	48 89 c7             	mov    %rax,%rdi
  8027fa:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <close_all>:

void
close_all(void)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802817:	eb 15                	jmp    80282e <close_all+0x26>
		close(i);
  802819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80281c:	89 c7                	mov    %eax,%edi
  80281e:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80282a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80282e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802832:	7e e5                	jle    802819 <close_all+0x11>
		close(i);
}
  802834:	c9                   	leaveq 
  802835:	c3                   	retq   

0000000000802836 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	48 83 ec 40          	sub    $0x40,%rsp
  80283e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802841:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802844:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802848:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80284b:	48 89 d6             	mov    %rdx,%rsi
  80284e:	89 c7                	mov    %eax,%edi
  802850:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
  80285c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802863:	79 08                	jns    80286d <dup+0x37>
		return r;
  802865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802868:	e9 70 01 00 00       	jmpq   8029dd <dup+0x1a7>
	close(newfdnum);
  80286d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802870:	89 c7                	mov    %eax,%edi
  802872:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80287e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802881:	48 98                	cltq   
  802883:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802889:	48 c1 e0 0c          	shl    $0xc,%rax
  80288d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802895:	48 89 c7             	mov    %rax,%rdi
  802898:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80289f:	00 00 00 
  8028a2:	ff d0                	callq  *%rax
  8028a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ac:	48 89 c7             	mov    %rax,%rdi
  8028af:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	callq  *%rax
  8028bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c3:	48 c1 e8 15          	shr    $0x15,%rax
  8028c7:	48 89 c2             	mov    %rax,%rdx
  8028ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028d1:	01 00 00 
  8028d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d8:	83 e0 01             	and    $0x1,%eax
  8028db:	48 85 c0             	test   %rax,%rax
  8028de:	74 73                	je     802953 <dup+0x11d>
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e8:	48 89 c2             	mov    %rax,%rdx
  8028eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f2:	01 00 00 
  8028f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f9:	83 e0 01             	and    $0x1,%eax
  8028fc:	48 85 c0             	test   %rax,%rax
  8028ff:	74 52                	je     802953 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802905:	48 c1 e8 0c          	shr    $0xc,%rax
  802909:	48 89 c2             	mov    %rax,%rdx
  80290c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802913:	01 00 00 
  802916:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291a:	25 07 0e 00 00       	and    $0xe07,%eax
  80291f:	89 c1                	mov    %eax,%ecx
  802921:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802929:	41 89 c8             	mov    %ecx,%r8d
  80292c:	48 89 d1             	mov    %rdx,%rcx
  80292f:	ba 00 00 00 00       	mov    $0x0,%edx
  802934:	48 89 c6             	mov    %rax,%rsi
  802937:	bf 00 00 00 00       	mov    $0x0,%edi
  80293c:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802943:	00 00 00 
  802946:	ff d0                	callq  *%rax
  802948:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294f:	79 02                	jns    802953 <dup+0x11d>
			goto err;
  802951:	eb 57                	jmp    8029aa <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802957:	48 c1 e8 0c          	shr    $0xc,%rax
  80295b:	48 89 c2             	mov    %rax,%rdx
  80295e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802965:	01 00 00 
  802968:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296c:	25 07 0e 00 00       	and    $0xe07,%eax
  802971:	89 c1                	mov    %eax,%ecx
  802973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802977:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80297b:	41 89 c8             	mov    %ecx,%r8d
  80297e:	48 89 d1             	mov    %rdx,%rcx
  802981:	ba 00 00 00 00       	mov    $0x0,%edx
  802986:	48 89 c6             	mov    %rax,%rsi
  802989:	bf 00 00 00 00       	mov    $0x0,%edi
  80298e:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a1:	79 02                	jns    8029a5 <dup+0x16f>
		goto err;
  8029a3:	eb 05                	jmp    8029aa <dup+0x174>

	return newfdnum;
  8029a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029a8:	eb 33                	jmp    8029dd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ae:	48 89 c6             	mov    %rax,%rsi
  8029b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b6:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 89 c6             	mov    %rax,%rsi
  8029c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ce:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
	return r;
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029dd:	c9                   	leaveq 
  8029de:	c3                   	retq   

00000000008029df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029df:	55                   	push   %rbp
  8029e0:	48 89 e5             	mov    %rsp,%rbp
  8029e3:	48 83 ec 40          	sub    $0x40,%rsp
  8029e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029ee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f9:	48 89 d6             	mov    %rdx,%rsi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
  802a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a11:	78 24                	js     802a37 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 00                	mov    (%rax),%eax
  802a19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1d:	48 89 d6             	mov    %rdx,%rsi
  802a20:	89 c7                	mov    %eax,%edi
  802a22:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <read+0x5d>
		return r;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 76                	jmp    802ab2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	8b 40 08             	mov    0x8(%rax),%eax
  802a43:	83 e0 03             	and    $0x3,%eax
  802a46:	83 f8 01             	cmp    $0x1,%eax
  802a49:	75 3a                	jne    802a85 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a4b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a52:	00 00 00 
  802a55:	48 8b 00             	mov    (%rax),%rax
  802a58:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a61:	89 c6                	mov    %eax,%esi
  802a63:	48 bf af 47 80 00 00 	movabs $0x8047af,%rdi
  802a6a:	00 00 00 
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a72:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802a79:	00 00 00 
  802a7c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a83:	eb 2d                	jmp    802ab2 <read+0xd3>
	}
	if (!dev->dev_read)
  802a85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a89:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a8d:	48 85 c0             	test   %rax,%rax
  802a90:	75 07                	jne    802a99 <read+0xba>
		return -E_NOT_SUPP;
  802a92:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a97:	eb 19                	jmp    802ab2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aa1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aa5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aa9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aad:	48 89 cf             	mov    %rcx,%rdi
  802ab0:	ff d0                	callq  *%rax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 30          	sub    $0x30,%rsp
  802abc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802abf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ac3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ac7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ace:	eb 49                	jmp    802b19 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	48 98                	cltq   
  802ad5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ad9:	48 29 c2             	sub    %rax,%rdx
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adf:	48 63 c8             	movslq %eax,%rcx
  802ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae6:	48 01 c1             	add    %rax,%rcx
  802ae9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aec:	48 89 ce             	mov    %rcx,%rsi
  802aef:	89 c7                	mov    %eax,%edi
  802af1:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
  802afd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b00:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b04:	79 05                	jns    802b0b <readn+0x57>
			return m;
  802b06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b09:	eb 1c                	jmp    802b27 <readn+0x73>
		if (m == 0)
  802b0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b0f:	75 02                	jne    802b13 <readn+0x5f>
			break;
  802b11:	eb 11                	jmp    802b24 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b16:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	48 98                	cltq   
  802b1e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b22:	72 ac                	jb     802ad0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b27:	c9                   	leaveq 
  802b28:	c3                   	retq   

0000000000802b29 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 40          	sub    $0x40,%rsp
  802b31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b43:	48 89 d6             	mov    %rdx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	78 24                	js     802b81 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b61:	8b 00                	mov    (%rax),%eax
  802b63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b67:	48 89 d6             	mov    %rdx,%rsi
  802b6a:	89 c7                	mov    %eax,%edi
  802b6c:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802b73:	00 00 00 
  802b76:	ff d0                	callq  *%rax
  802b78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7f:	79 05                	jns    802b86 <write+0x5d>
		return r;
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	eb 75                	jmp    802bfb <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8a:	8b 40 08             	mov    0x8(%rax),%eax
  802b8d:	83 e0 03             	and    $0x3,%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	75 3a                	jne    802bce <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b94:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b9b:	00 00 00 
  802b9e:	48 8b 00             	mov    (%rax),%rax
  802ba1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ba7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802baa:	89 c6                	mov    %eax,%esi
  802bac:	48 bf cb 47 80 00 00 	movabs $0x8047cb,%rdi
  802bb3:	00 00 00 
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802bc2:	00 00 00 
  802bc5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bcc:	eb 2d                	jmp    802bfb <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bd6:	48 85 c0             	test   %rax,%rax
  802bd9:	75 07                	jne    802be2 <write+0xb9>
		return -E_NOT_SUPP;
  802bdb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be0:	eb 19                	jmp    802bfb <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bea:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bf2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bf6:	48 89 cf             	mov    %rcx,%rdi
  802bf9:	ff d0                	callq  *%rax
}
  802bfb:	c9                   	leaveq 
  802bfc:	c3                   	retq   

0000000000802bfd <seek>:

int
seek(int fdnum, off_t offset)
{
  802bfd:	55                   	push   %rbp
  802bfe:	48 89 e5             	mov    %rsp,%rbp
  802c01:	48 83 ec 18          	sub    $0x18,%rsp
  802c05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c08:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c12:	48 89 d6             	mov    %rdx,%rsi
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2a:	79 05                	jns    802c31 <seek+0x34>
		return r;
  802c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2f:	eb 0f                	jmp    802c40 <seek+0x43>
	fd->fd_offset = offset;
  802c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c35:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 30          	sub    $0x30,%rsp
  802c4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c57:	48 89 d6             	mov    %rdx,%rsi
  802c5a:	89 c7                	mov    %eax,%edi
  802c5c:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802c63:	00 00 00 
  802c66:	ff d0                	callq  *%rax
  802c68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6f:	78 24                	js     802c95 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c75:	8b 00                	mov    (%rax),%eax
  802c77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7b:	48 89 d6             	mov    %rdx,%rsi
  802c7e:	89 c7                	mov    %eax,%edi
  802c80:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802c87:	00 00 00 
  802c8a:	ff d0                	callq  *%rax
  802c8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c93:	79 05                	jns    802c9a <ftruncate+0x58>
		return r;
  802c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c98:	eb 72                	jmp    802d0c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9e:	8b 40 08             	mov    0x8(%rax),%eax
  802ca1:	83 e0 03             	and    $0x3,%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	75 3a                	jne    802ce2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ca8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802caf:	00 00 00 
  802cb2:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cb5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cbb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cbe:	89 c6                	mov    %eax,%esi
  802cc0:	48 bf e8 47 80 00 00 	movabs $0x8047e8,%rdi
  802cc7:	00 00 00 
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccf:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802cd6:	00 00 00 
  802cd9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ce0:	eb 2a                	jmp    802d0c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cea:	48 85 c0             	test   %rax,%rax
  802ced:	75 07                	jne    802cf6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf4:	eb 16                	jmp    802d0c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d02:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d05:	89 ce                	mov    %ecx,%esi
  802d07:	48 89 d7             	mov    %rdx,%rdi
  802d0a:	ff d0                	callq  *%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 30          	sub    $0x30,%rsp
  802d16:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d19:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d21:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d24:	48 89 d6             	mov    %rdx,%rsi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	78 24                	js     802d62 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d42:	8b 00                	mov    (%rax),%eax
  802d44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d48:	48 89 d6             	mov    %rdx,%rsi
  802d4b:	89 c7                	mov    %eax,%edi
  802d4d:	48 b8 06 27 80 00 00 	movabs $0x802706,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d60:	79 05                	jns    802d67 <fstat+0x59>
		return r;
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	eb 5e                	jmp    802dc5 <fstat+0xb7>
	if (!dev->dev_stat)
  802d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d6f:	48 85 c0             	test   %rax,%rax
  802d72:	75 07                	jne    802d7b <fstat+0x6d>
		return -E_NOT_SUPP;
  802d74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d79:	eb 4a                	jmp    802dc5 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d86:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d8d:	00 00 00 
	stat->st_isdir = 0;
  802d90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d94:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d9b:	00 00 00 
	stat->st_dev = dev;
  802d9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802da2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db1:	48 8b 40 28          	mov    0x28(%rax),%rax
  802db5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802db9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dbd:	48 89 ce             	mov    %rcx,%rsi
  802dc0:	48 89 d7             	mov    %rdx,%rdi
  802dc3:	ff d0                	callq  *%rax
}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 20          	sub    $0x20,%rsp
  802dcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df6:	79 05                	jns    802dfd <stat+0x36>
		return fd;
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	eb 2f                	jmp    802e2c <stat+0x65>
	r = fstat(fd, stat);
  802dfd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	48 89 d6             	mov    %rdx,%rsi
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	48 b8 0e 2d 80 00 00 	movabs $0x802d0e,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	callq  *%rax
  802e15:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1b:	89 c7                	mov    %eax,%edi
  802e1d:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  802e24:	00 00 00 
  802e27:	ff d0                	callq  *%rax
	return r;
  802e29:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   

0000000000802e2e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e2e:	55                   	push   %rbp
  802e2f:	48 89 e5             	mov    %rsp,%rbp
  802e32:	48 83 ec 10          	sub    $0x10,%rsp
  802e36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e3d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e44:	00 00 00 
  802e47:	8b 00                	mov    (%rax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	75 1d                	jne    802e6a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e4d:	bf 01 00 00 00       	mov    $0x1,%edi
  802e52:	48 b8 b3 3f 80 00 00 	movabs $0x803fb3,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
  802e5e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e65:	00 00 00 
  802e68:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e6a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e71:	00 00 00 
  802e74:	8b 00                	mov    (%rax),%eax
  802e76:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e79:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e7e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e85:	00 00 00 
  802e88:	89 c7                	mov    %eax,%edi
  802e8a:	48 b8 16 3f 80 00 00 	movabs $0x803f16,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9f:	48 89 c6             	mov    %rax,%rsi
  802ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea7:	48 b8 50 3e 80 00 00 	movabs $0x803e50,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
}
  802eb3:	c9                   	leaveq 
  802eb4:	c3                   	retq   

0000000000802eb5 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802eb5:	55                   	push   %rbp
  802eb6:	48 89 e5             	mov    %rsp,%rbp
  802eb9:	48 83 ec 20          	sub    $0x20,%rsp
  802ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ec1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec8:	48 89 c7             	mov    %rax,%rdi
  802ecb:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  802ed2:	00 00 00 
  802ed5:	ff d0                	callq  *%rax
  802ed7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802edc:	7e 0a                	jle    802ee8 <open+0x33>
  802ede:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ee3:	e9 a5 00 00 00       	jmpq   802f8d <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802ee8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802eec:	48 89 c7             	mov    %rax,%rdi
  802eef:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f02:	79 08                	jns    802f0c <open+0x57>
		return r;
  802f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f07:	e9 81 00 00 00       	jmpq   802f8d <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802f0c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f13:	00 00 00 
  802f16:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f19:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f23:	48 89 c6             	mov    %rax,%rsi
  802f26:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f2d:	00 00 00 
  802f30:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  802f37:	00 00 00 
  802f3a:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f40:	48 89 c6             	mov    %rax,%rsi
  802f43:	bf 01 00 00 00       	mov    $0x1,%edi
  802f48:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
  802f54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5b:	79 1d                	jns    802f7a <open+0xc5>
		fd_close(fd, 0);
  802f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f61:	be 00 00 00 00       	mov    $0x0,%esi
  802f66:	48 89 c7             	mov    %rax,%rdi
  802f69:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  802f70:	00 00 00 
  802f73:	ff d0                	callq  *%rax
		return r;
  802f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f78:	eb 13                	jmp    802f8d <open+0xd8>
	}
	return fd2num(fd);
  802f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7e:	48 89 c7             	mov    %rax,%rdi
  802f81:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  802f88:	00 00 00 
  802f8b:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802f8d:	c9                   	leaveq 
  802f8e:	c3                   	retq   

0000000000802f8f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f8f:	55                   	push   %rbp
  802f90:	48 89 e5             	mov    %rsp,%rbp
  802f93:	48 83 ec 10          	sub    $0x10,%rsp
  802f97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9f:	8b 50 0c             	mov    0xc(%rax),%edx
  802fa2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa9:	00 00 00 
  802fac:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fae:	be 00 00 00 00       	mov    $0x0,%esi
  802fb3:	bf 06 00 00 00       	mov    $0x6,%edi
  802fb8:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  802fbf:	00 00 00 
  802fc2:	ff d0                	callq  *%rax
}
  802fc4:	c9                   	leaveq 
  802fc5:	c3                   	retq   

0000000000802fc6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fc6:	55                   	push   %rbp
  802fc7:	48 89 e5             	mov    %rsp,%rbp
  802fca:	48 83 ec 30          	sub    $0x30,%rsp
  802fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fde:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fe8:	00 00 00 
  802feb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff4:	00 00 00 
  802ff7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ffb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802fff:	be 00 00 00 00       	mov    $0x0,%esi
  803004:	bf 03 00 00 00       	mov    $0x3,%edi
  803009:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
  803015:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803018:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301c:	79 05                	jns    803023 <devfile_read+0x5d>
		return r;
  80301e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803021:	eb 26                	jmp    803049 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  803023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803026:	48 63 d0             	movslq %eax,%rdx
  803029:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80302d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803034:	00 00 00 
  803037:	48 89 c7             	mov    %rax,%rdi
  80303a:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  803041:	00 00 00 
  803044:	ff d0                	callq  *%rax
	return r;
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 30          	sub    $0x30,%rsp
  803053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80305b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80305f:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  803066:	00 
	n = n > max ? max : n;
  803067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80306f:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  803074:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307c:	8b 50 0c             	mov    0xc(%rax),%edx
  80307f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803086:	00 00 00 
  803089:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80308b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803092:	00 00 00 
  803095:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803099:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80309d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a5:	48 89 c6             	mov    %rax,%rsi
  8030a8:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030af:	00 00 00 
  8030b2:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8030be:	be 00 00 00 00       	mov    $0x0,%esi
  8030c3:	bf 04 00 00 00       	mov    $0x4,%edi
  8030c8:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8030d4:	c9                   	leaveq 
  8030d5:	c3                   	retq   

00000000008030d6 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030d6:	55                   	push   %rbp
  8030d7:	48 89 e5             	mov    %rsp,%rbp
  8030da:	48 83 ec 20          	sub    $0x20,%rsp
  8030de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ea:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f4:	00 00 00 
  8030f7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030f9:	be 00 00 00 00       	mov    $0x0,%esi
  8030fe:	bf 05 00 00 00       	mov    $0x5,%edi
  803103:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
  80310f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803112:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803116:	79 05                	jns    80311d <devfile_stat+0x47>
		return r;
  803118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311b:	eb 56                	jmp    803173 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80311d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803121:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803128:	00 00 00 
  80312b:	48 89 c7             	mov    %rax,%rdi
  80312e:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  803135:	00 00 00 
  803138:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80313a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803141:	00 00 00 
  803144:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80314a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803154:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80315b:	00 00 00 
  80315e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803164:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803168:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80316e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803173:	c9                   	leaveq 
  803174:	c3                   	retq   

0000000000803175 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803175:	55                   	push   %rbp
  803176:	48 89 e5             	mov    %rsp,%rbp
  803179:	48 83 ec 10          	sub    $0x10,%rsp
  80317d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803181:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803188:	8b 50 0c             	mov    0xc(%rax),%edx
  80318b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803192:	00 00 00 
  803195:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803197:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80319e:	00 00 00 
  8031a1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031a7:	be 00 00 00 00       	mov    $0x0,%esi
  8031ac:	bf 02 00 00 00       	mov    $0x2,%edi
  8031b1:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
}
  8031bd:	c9                   	leaveq 
  8031be:	c3                   	retq   

00000000008031bf <remove>:

// Delete a file
int
remove(const char *path)
{
  8031bf:	55                   	push   %rbp
  8031c0:	48 89 e5             	mov    %rsp,%rbp
  8031c3:	48 83 ec 10          	sub    $0x10,%rsp
  8031c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031cf:	48 89 c7             	mov    %rax,%rdi
  8031d2:	48 b8 74 13 80 00 00 	movabs $0x801374,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031e3:	7e 07                	jle    8031ec <remove+0x2d>
		return -E_BAD_PATH;
  8031e5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031ea:	eb 33                	jmp    80321f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f0:	48 89 c6             	mov    %rax,%rsi
  8031f3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031fa:	00 00 00 
  8031fd:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803209:	be 00 00 00 00       	mov    $0x0,%esi
  80320e:	bf 07 00 00 00       	mov    $0x7,%edi
  803213:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803225:	be 00 00 00 00       	mov    $0x0,%esi
  80322a:	bf 08 00 00 00       	mov    $0x8,%edi
  80322f:	48 b8 2e 2e 80 00 00 	movabs $0x802e2e,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
}
  80323b:	5d                   	pop    %rbp
  80323c:	c3                   	retq   

000000000080323d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80323d:	55                   	push   %rbp
  80323e:	48 89 e5             	mov    %rsp,%rbp
  803241:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803248:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80324f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803256:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80325d:	be 00 00 00 00       	mov    $0x0,%esi
  803262:	48 89 c7             	mov    %rax,%rdi
  803265:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
  803271:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803274:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803278:	79 28                	jns    8032a2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80327a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327d:	89 c6                	mov    %eax,%esi
  80327f:	48 bf 0e 48 80 00 00 	movabs $0x80480e,%rdi
  803286:	00 00 00 
  803289:	b8 00 00 00 00       	mov    $0x0,%eax
  80328e:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  803295:	00 00 00 
  803298:	ff d2                	callq  *%rdx
		return fd_src;
  80329a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329d:	e9 74 01 00 00       	jmpq   803416 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032a2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032a9:	be 01 01 00 00       	mov    $0x101,%esi
  8032ae:	48 89 c7             	mov    %rax,%rdi
  8032b1:	48 b8 b5 2e 80 00 00 	movabs $0x802eb5,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
  8032bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032c4:	79 39                	jns    8032ff <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032c9:	89 c6                	mov    %eax,%esi
  8032cb:	48 bf 24 48 80 00 00 	movabs $0x804824,%rdi
  8032d2:	00 00 00 
  8032d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032da:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8032e1:	00 00 00 
  8032e4:	ff d2                	callq  *%rdx
		close(fd_src);
  8032e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e9:	89 c7                	mov    %eax,%edi
  8032eb:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8032f2:	00 00 00 
  8032f5:	ff d0                	callq  *%rax
		return fd_dest;
  8032f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032fa:	e9 17 01 00 00       	jmpq   803416 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8032ff:	eb 74                	jmp    803375 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803304:	48 63 d0             	movslq %eax,%rdx
  803307:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80330e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803311:	48 89 ce             	mov    %rcx,%rsi
  803314:	89 c7                	mov    %eax,%edi
  803316:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803325:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803329:	79 4a                	jns    803375 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80332b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80332e:	89 c6                	mov    %eax,%esi
  803330:	48 bf 3e 48 80 00 00 	movabs $0x80483e,%rdi
  803337:	00 00 00 
  80333a:	b8 00 00 00 00       	mov    $0x0,%eax
  80333f:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  803346:	00 00 00 
  803349:	ff d2                	callq  *%rdx
			close(fd_src);
  80334b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334e:	89 c7                	mov    %eax,%edi
  803350:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
			close(fd_dest);
  80335c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80335f:	89 c7                	mov    %eax,%edi
  803361:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
			return write_size;
  80336d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803370:	e9 a1 00 00 00       	jmpq   803416 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803375:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80337c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337f:	ba 00 02 00 00       	mov    $0x200,%edx
  803384:	48 89 ce             	mov    %rcx,%rsi
  803387:	89 c7                	mov    %eax,%edi
  803389:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  803390:	00 00 00 
  803393:	ff d0                	callq  *%rax
  803395:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803398:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80339c:	0f 8f 5f ff ff ff    	jg     803301 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033a6:	79 47                	jns    8033ef <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ab:	89 c6                	mov    %eax,%esi
  8033ad:	48 bf 51 48 80 00 00 	movabs $0x804851,%rdi
  8033b4:	00 00 00 
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bc:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8033c3:	00 00 00 
  8033c6:	ff d2                	callq  *%rdx
		close(fd_src);
  8033c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cb:	89 c7                	mov    %eax,%edi
  8033cd:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
		close(fd_dest);
  8033d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
		return read_size;
  8033ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ed:	eb 27                	jmp    803416 <copy+0x1d9>
	}
	close(fd_src);
  8033ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f2:	89 c7                	mov    %eax,%edi
  8033f4:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
	close(fd_dest);
  803400:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803403:	89 c7                	mov    %eax,%edi
  803405:	48 b8 bd 27 80 00 00 	movabs $0x8027bd,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
	return 0;
  803411:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803416:	c9                   	leaveq 
  803417:	c3                   	retq   

0000000000803418 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803418:	55                   	push   %rbp
  803419:	48 89 e5             	mov    %rsp,%rbp
  80341c:	53                   	push   %rbx
  80341d:	48 83 ec 38          	sub    $0x38,%rsp
  803421:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803425:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803429:	48 89 c7             	mov    %rax,%rdi
  80342c:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80343f:	0f 88 bf 01 00 00    	js     803604 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803445:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803449:	ba 07 04 00 00       	mov    $0x407,%edx
  80344e:	48 89 c6             	mov    %rax,%rsi
  803451:	bf 00 00 00 00       	mov    $0x0,%edi
  803456:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  80345d:	00 00 00 
  803460:	ff d0                	callq  *%rax
  803462:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803465:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803469:	0f 88 95 01 00 00    	js     803604 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80346f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803473:	48 89 c7             	mov    %rax,%rdi
  803476:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
  803482:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803485:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803489:	0f 88 5d 01 00 00    	js     8035ec <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80348f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803493:	ba 07 04 00 00       	mov    $0x407,%edx
  803498:	48 89 c6             	mov    %rax,%rsi
  80349b:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a0:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b3:	0f 88 33 01 00 00    	js     8035ec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8034b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034bd:	48 89 c7             	mov    %rax,%rdi
  8034c0:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8034d9:	48 89 c6             	mov    %rax,%rsi
  8034dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e1:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034f4:	79 05                	jns    8034fb <pipe+0xe3>
		goto err2;
  8034f6:	e9 d9 00 00 00       	jmpq   8035d4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ff:	48 89 c7             	mov    %rax,%rdi
  803502:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
  80350e:	48 89 c2             	mov    %rax,%rdx
  803511:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803515:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80351b:	48 89 d1             	mov    %rdx,%rcx
  80351e:	ba 00 00 00 00       	mov    $0x0,%edx
  803523:	48 89 c6             	mov    %rax,%rsi
  803526:	bf 00 00 00 00       	mov    $0x0,%edi
  80352b:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
  803537:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80353a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80353e:	79 1b                	jns    80355b <pipe+0x143>
		goto err3;
  803540:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803541:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803545:	48 89 c6             	mov    %rax,%rsi
  803548:	bf 00 00 00 00       	mov    $0x0,%edi
  80354d:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  803554:	00 00 00 
  803557:	ff d0                	callq  *%rax
  803559:	eb 79                	jmp    8035d4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80355b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80355f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803566:	00 00 00 
  803569:	8b 12                	mov    (%rdx),%edx
  80356b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80356d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803571:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803578:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80357c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803583:	00 00 00 
  803586:	8b 12                	mov    (%rdx),%edx
  803588:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80358a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80358e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803599:	48 89 c7             	mov    %rax,%rdi
  80359c:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8035a3:	00 00 00 
  8035a6:	ff d0                	callq  *%rax
  8035a8:	89 c2                	mov    %eax,%edx
  8035aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035ae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8035b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8035b4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8035b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035bc:	48 89 c7             	mov    %rax,%rdi
  8035bf:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8035cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d2:	eb 33                	jmp    803607 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8035d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d8:	48 89 c6             	mov    %rax,%rsi
  8035db:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e0:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f0:	48 89 c6             	mov    %rax,%rsi
  8035f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f8:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
err:
	return r;
  803604:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803607:	48 83 c4 38          	add    $0x38,%rsp
  80360b:	5b                   	pop    %rbx
  80360c:	5d                   	pop    %rbp
  80360d:	c3                   	retq   

000000000080360e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	53                   	push   %rbx
  803613:	48 83 ec 28          	sub    $0x28,%rsp
  803617:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80361b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80361f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803626:	00 00 00 
  803629:	48 8b 00             	mov    (%rax),%rax
  80362c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803632:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803639:	48 89 c7             	mov    %rax,%rdi
  80363c:	48 b8 35 40 80 00 00 	movabs $0x804035,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 c3                	mov    %eax,%ebx
  80364a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80364e:	48 89 c7             	mov    %rax,%rdi
  803651:	48 b8 35 40 80 00 00 	movabs $0x804035,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
  80365d:	39 c3                	cmp    %eax,%ebx
  80365f:	0f 94 c0             	sete   %al
  803662:	0f b6 c0             	movzbl %al,%eax
  803665:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803668:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80366f:	00 00 00 
  803672:	48 8b 00             	mov    (%rax),%rax
  803675:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80367b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80367e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803681:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803684:	75 05                	jne    80368b <_pipeisclosed+0x7d>
			return ret;
  803686:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803689:	eb 4f                	jmp    8036da <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80368b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803691:	74 42                	je     8036d5 <_pipeisclosed+0xc7>
  803693:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803697:	75 3c                	jne    8036d5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803699:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036a0:	00 00 00 
  8036a3:	48 8b 00             	mov    (%rax),%rax
  8036a6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8036ac:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b2:	89 c6                	mov    %eax,%esi
  8036b4:	48 bf 6c 48 80 00 00 	movabs $0x80486c,%rdi
  8036bb:	00 00 00 
  8036be:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c3:	49 b8 2b 08 80 00 00 	movabs $0x80082b,%r8
  8036ca:	00 00 00 
  8036cd:	41 ff d0             	callq  *%r8
	}
  8036d0:	e9 4a ff ff ff       	jmpq   80361f <_pipeisclosed+0x11>
  8036d5:	e9 45 ff ff ff       	jmpq   80361f <_pipeisclosed+0x11>
}
  8036da:	48 83 c4 28          	add    $0x28,%rsp
  8036de:	5b                   	pop    %rbx
  8036df:	5d                   	pop    %rbp
  8036e0:	c3                   	retq   

00000000008036e1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036e1:	55                   	push   %rbp
  8036e2:	48 89 e5             	mov    %rsp,%rbp
  8036e5:	48 83 ec 30          	sub    $0x30,%rsp
  8036e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036f3:	48 89 d6             	mov    %rdx,%rsi
  8036f6:	89 c7                	mov    %eax,%edi
  8036f8:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
  803704:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803707:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370b:	79 05                	jns    803712 <pipeisclosed+0x31>
		return r;
  80370d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803710:	eb 31                	jmp    803743 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803716:	48 89 c7             	mov    %rax,%rdi
  803719:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
  803725:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803731:	48 89 d6             	mov    %rdx,%rsi
  803734:	48 89 c7             	mov    %rax,%rdi
  803737:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
}
  803743:	c9                   	leaveq 
  803744:	c3                   	retq   

0000000000803745 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 40          	sub    $0x40,%rsp
  80374d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803751:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803755:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375d:	48 89 c7             	mov    %rax,%rdi
  803760:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
  80376c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803774:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803778:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80377f:	00 
  803780:	e9 92 00 00 00       	jmpq   803817 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803785:	eb 41                	jmp    8037c8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803787:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80378c:	74 09                	je     803797 <devpipe_read+0x52>
				return i;
  80378e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803792:	e9 92 00 00 00       	jmpq   803829 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803797:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80379b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379f:	48 89 d6             	mov    %rdx,%rsi
  8037a2:	48 89 c7             	mov    %rax,%rdi
  8037a5:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  8037ac:	00 00 00 
  8037af:	ff d0                	callq  *%rax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	74 07                	je     8037bc <devpipe_read+0x77>
				return 0;
  8037b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ba:	eb 6d                	jmp    803829 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8037bc:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  8037c3:	00 00 00 
  8037c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cc:	8b 10                	mov    (%rax),%edx
  8037ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d2:	8b 40 04             	mov    0x4(%rax),%eax
  8037d5:	39 c2                	cmp    %eax,%edx
  8037d7:	74 ae                	je     803787 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037e1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e9:	8b 00                	mov    (%rax),%eax
  8037eb:	99                   	cltd   
  8037ec:	c1 ea 1b             	shr    $0x1b,%edx
  8037ef:	01 d0                	add    %edx,%eax
  8037f1:	83 e0 1f             	and    $0x1f,%eax
  8037f4:	29 d0                	sub    %edx,%eax
  8037f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037fa:	48 98                	cltq   
  8037fc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803801:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803807:	8b 00                	mov    (%rax),%eax
  803809:	8d 50 01             	lea    0x1(%rax),%edx
  80380c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803810:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803812:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80381f:	0f 82 60 ff ff ff    	jb     803785 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803829:	c9                   	leaveq 
  80382a:	c3                   	retq   

000000000080382b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80382b:	55                   	push   %rbp
  80382c:	48 89 e5             	mov    %rsp,%rbp
  80382f:	48 83 ec 40          	sub    $0x40,%rsp
  803833:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803837:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80383b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80383f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803843:	48 89 c7             	mov    %rax,%rdi
  803846:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
  803852:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803856:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80385a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80385e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803865:	00 
  803866:	e9 8e 00 00 00       	jmpq   8038f9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80386b:	eb 31                	jmp    80389e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80386d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803875:	48 89 d6             	mov    %rdx,%rsi
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 b8 0e 36 80 00 00 	movabs $0x80360e,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
  803887:	85 c0                	test   %eax,%eax
  803889:	74 07                	je     803892 <devpipe_write+0x67>
				return 0;
  80388b:	b8 00 00 00 00       	mov    $0x0,%eax
  803890:	eb 79                	jmp    80390b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803892:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  803899:	00 00 00 
  80389c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80389e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a2:	8b 40 04             	mov    0x4(%rax),%eax
  8038a5:	48 63 d0             	movslq %eax,%rdx
  8038a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ac:	8b 00                	mov    (%rax),%eax
  8038ae:	48 98                	cltq   
  8038b0:	48 83 c0 20          	add    $0x20,%rax
  8038b4:	48 39 c2             	cmp    %rax,%rdx
  8038b7:	73 b4                	jae    80386d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8038b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bd:	8b 40 04             	mov    0x4(%rax),%eax
  8038c0:	99                   	cltd   
  8038c1:	c1 ea 1b             	shr    $0x1b,%edx
  8038c4:	01 d0                	add    %edx,%eax
  8038c6:	83 e0 1f             	and    $0x1f,%eax
  8038c9:	29 d0                	sub    %edx,%eax
  8038cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038d3:	48 01 ca             	add    %rcx,%rdx
  8038d6:	0f b6 0a             	movzbl (%rdx),%ecx
  8038d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038dd:	48 98                	cltq   
  8038df:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e7:	8b 40 04             	mov    0x4(%rax),%eax
  8038ea:	8d 50 01             	lea    0x1(%rax),%edx
  8038ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803901:	0f 82 64 ff ff ff    	jb     80386b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80390b:	c9                   	leaveq 
  80390c:	c3                   	retq   

000000000080390d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80390d:	55                   	push   %rbp
  80390e:	48 89 e5             	mov    %rsp,%rbp
  803911:	48 83 ec 20          	sub    $0x20,%rsp
  803915:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803919:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80391d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803921:	48 89 c7             	mov    %rax,%rdi
  803924:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803934:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803938:	48 be 7f 48 80 00 00 	movabs $0x80487f,%rsi
  80393f:	00 00 00 
  803942:	48 89 c7             	mov    %rax,%rdi
  803945:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803951:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803955:	8b 50 04             	mov    0x4(%rax),%edx
  803958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395c:	8b 00                	mov    (%rax),%eax
  80395e:	29 c2                	sub    %eax,%edx
  803960:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803964:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80396a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80396e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803975:	00 00 00 
	stat->st_dev = &devpipe;
  803978:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80397c:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803983:	00 00 00 
  803986:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80398d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803992:	c9                   	leaveq 
  803993:	c3                   	retq   

0000000000803994 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	48 83 ec 10          	sub    $0x10,%rsp
  80399c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8039a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a4:	48 89 c6             	mov    %rax,%rsi
  8039a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ac:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8039b3:	00 00 00 
  8039b6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8039b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039bc:	48 89 c7             	mov    %rax,%rdi
  8039bf:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
  8039cb:	48 89 c6             	mov    %rax,%rsi
  8039ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d3:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  8039da:	00 00 00 
  8039dd:	ff d0                	callq  *%rax
}
  8039df:	c9                   	leaveq 
  8039e0:	c3                   	retq   

00000000008039e1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8039e1:	55                   	push   %rbp
  8039e2:	48 89 e5             	mov    %rsp,%rbp
  8039e5:	48 83 ec 20          	sub    $0x20,%rsp
  8039e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8039ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f0:	75 35                	jne    803a27 <wait+0x46>
  8039f2:	48 b9 86 48 80 00 00 	movabs $0x804886,%rcx
  8039f9:	00 00 00 
  8039fc:	48 ba 91 48 80 00 00 	movabs $0x804891,%rdx
  803a03:	00 00 00 
  803a06:	be 09 00 00 00       	mov    $0x9,%esi
  803a0b:	48 bf a6 48 80 00 00 	movabs $0x8048a6,%rdi
  803a12:	00 00 00 
  803a15:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1a:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  803a21:	00 00 00 
  803a24:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803a27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a2a:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a2f:	48 63 d0             	movslq %eax,%rdx
  803a32:	48 89 d0             	mov    %rdx,%rax
  803a35:	48 c1 e0 03          	shl    $0x3,%rax
  803a39:	48 01 d0             	add    %rdx,%rax
  803a3c:	48 c1 e0 05          	shl    $0x5,%rax
  803a40:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a47:	00 00 00 
  803a4a:	48 01 d0             	add    %rdx,%rax
  803a4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a51:	eb 0c                	jmp    803a5f <wait+0x7e>
		sys_yield();
  803a53:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a63:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a69:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a6c:	75 0e                	jne    803a7c <wait+0x9b>
  803a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a72:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a78:	85 c0                	test   %eax,%eax
  803a7a:	75 d7                	jne    803a53 <wait+0x72>
		sys_yield();
}
  803a7c:	c9                   	leaveq 
  803a7d:	c3                   	retq   

0000000000803a7e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a7e:	55                   	push   %rbp
  803a7f:	48 89 e5             	mov    %rsp,%rbp
  803a82:	48 83 ec 20          	sub    $0x20,%rsp
  803a86:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a89:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a8c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a8f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a93:	be 01 00 00 00       	mov    $0x1,%esi
  803a98:	48 89 c7             	mov    %rax,%rdi
  803a9b:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <getchar>:

int
getchar(void)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ab1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ab5:	ba 01 00 00 00       	mov    $0x1,%edx
  803aba:	48 89 c6             	mov    %rax,%rsi
  803abd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac2:	48 b8 df 29 80 00 00 	movabs $0x8029df,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
  803ace:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad5:	79 05                	jns    803adc <getchar+0x33>
		return r;
  803ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ada:	eb 14                	jmp    803af0 <getchar+0x47>
	if (r < 1)
  803adc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae0:	7f 07                	jg     803ae9 <getchar+0x40>
		return -E_EOF;
  803ae2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ae7:	eb 07                	jmp    803af0 <getchar+0x47>
	return c;
  803ae9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803aed:	0f b6 c0             	movzbl %al,%eax
}
  803af0:	c9                   	leaveq 
  803af1:	c3                   	retq   

0000000000803af2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803af2:	55                   	push   %rbp
  803af3:	48 89 e5             	mov    %rsp,%rbp
  803af6:	48 83 ec 20          	sub    $0x20,%rsp
  803afa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803afd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b04:	48 89 d6             	mov    %rdx,%rsi
  803b07:	89 c7                	mov    %eax,%edi
  803b09:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  803b10:	00 00 00 
  803b13:	ff d0                	callq  *%rax
  803b15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1c:	79 05                	jns    803b23 <iscons+0x31>
		return r;
  803b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b21:	eb 1a                	jmp    803b3d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b27:	8b 10                	mov    (%rax),%edx
  803b29:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b30:	00 00 00 
  803b33:	8b 00                	mov    (%rax),%eax
  803b35:	39 c2                	cmp    %eax,%edx
  803b37:	0f 94 c0             	sete   %al
  803b3a:	0f b6 c0             	movzbl %al,%eax
}
  803b3d:	c9                   	leaveq 
  803b3e:	c3                   	retq   

0000000000803b3f <opencons>:

int
opencons(void)
{
  803b3f:	55                   	push   %rbp
  803b40:	48 89 e5             	mov    %rsp,%rbp
  803b43:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b47:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b4b:	48 89 c7             	mov    %rax,%rdi
  803b4e:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  803b55:	00 00 00 
  803b58:	ff d0                	callq  *%rax
  803b5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b61:	79 05                	jns    803b68 <opencons+0x29>
		return r;
  803b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b66:	eb 5b                	jmp    803bc3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6c:	ba 07 04 00 00       	mov    $0x407,%edx
  803b71:	48 89 c6             	mov    %rax,%rsi
  803b74:	bf 00 00 00 00       	mov    $0x0,%edi
  803b79:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8c:	79 05                	jns    803b93 <opencons+0x54>
		return r;
  803b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b91:	eb 30                	jmp    803bc3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b97:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b9e:	00 00 00 
  803ba1:	8b 12                	mov    (%rdx),%edx
  803ba3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ba5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb4:	48 89 c7             	mov    %rax,%rdi
  803bb7:	48 b8 c7 24 80 00 00 	movabs $0x8024c7,%rax
  803bbe:	00 00 00 
  803bc1:	ff d0                	callq  *%rax
}
  803bc3:	c9                   	leaveq 
  803bc4:	c3                   	retq   

0000000000803bc5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bc5:	55                   	push   %rbp
  803bc6:	48 89 e5             	mov    %rsp,%rbp
  803bc9:	48 83 ec 30          	sub    $0x30,%rsp
  803bcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bd9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bde:	75 07                	jne    803be7 <devcons_read+0x22>
		return 0;
  803be0:	b8 00 00 00 00       	mov    $0x0,%eax
  803be5:	eb 4b                	jmp    803c32 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803be7:	eb 0c                	jmp    803bf5 <devcons_read+0x30>
		sys_yield();
  803be9:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  803bf0:	00 00 00 
  803bf3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bf5:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  803bfc:	00 00 00 
  803bff:	ff d0                	callq  *%rax
  803c01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c08:	74 df                	je     803be9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0e:	79 05                	jns    803c15 <devcons_read+0x50>
		return c;
  803c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c13:	eb 1d                	jmp    803c32 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c15:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c19:	75 07                	jne    803c22 <devcons_read+0x5d>
		return 0;
  803c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c20:	eb 10                	jmp    803c32 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c25:	89 c2                	mov    %eax,%edx
  803c27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2b:	88 10                	mov    %dl,(%rax)
	return 1;
  803c2d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c32:	c9                   	leaveq 
  803c33:	c3                   	retq   

0000000000803c34 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c34:	55                   	push   %rbp
  803c35:	48 89 e5             	mov    %rsp,%rbp
  803c38:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c3f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c46:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c4d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c5b:	eb 76                	jmp    803cd3 <devcons_write+0x9f>
		m = n - tot;
  803c5d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c69:	29 c2                	sub    %eax,%edx
  803c6b:	89 d0                	mov    %edx,%eax
  803c6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c73:	83 f8 7f             	cmp    $0x7f,%eax
  803c76:	76 07                	jbe    803c7f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c78:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c82:	48 63 d0             	movslq %eax,%rdx
  803c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c88:	48 63 c8             	movslq %eax,%rcx
  803c8b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c92:	48 01 c1             	add    %rax,%rcx
  803c95:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c9c:	48 89 ce             	mov    %rcx,%rsi
  803c9f:	48 89 c7             	mov    %rax,%rdi
  803ca2:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb1:	48 63 d0             	movslq %eax,%rdx
  803cb4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cbb:	48 89 d6             	mov    %rdx,%rsi
  803cbe:	48 89 c7             	mov    %rax,%rdi
  803cc1:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ccd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd0:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd6:	48 98                	cltq   
  803cd8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cdf:	0f 82 78 ff ff ff    	jb     803c5d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ce8:	c9                   	leaveq 
  803ce9:	c3                   	retq   

0000000000803cea <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cea:	55                   	push   %rbp
  803ceb:	48 89 e5             	mov    %rsp,%rbp
  803cee:	48 83 ec 08          	sub    $0x8,%rsp
  803cf2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cfb:	c9                   	leaveq 
  803cfc:	c3                   	retq   

0000000000803cfd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cfd:	55                   	push   %rbp
  803cfe:	48 89 e5             	mov    %rsp,%rbp
  803d01:	48 83 ec 10          	sub    $0x10,%rsp
  803d05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d11:	48 be b6 48 80 00 00 	movabs $0x8048b6,%rsi
  803d18:	00 00 00 
  803d1b:	48 89 c7             	mov    %rax,%rdi
  803d1e:	48 b8 e0 13 80 00 00 	movabs $0x8013e0,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
	return 0;
  803d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d2f:	c9                   	leaveq 
  803d30:	c3                   	retq   

0000000000803d31 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d31:	55                   	push   %rbp
  803d32:	48 89 e5             	mov    %rsp,%rbp
  803d35:	48 83 ec 10          	sub    $0x10,%rsp
  803d39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d3d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d44:	00 00 00 
  803d47:	48 8b 00             	mov    (%rax),%rax
  803d4a:	48 85 c0             	test   %rax,%rax
  803d4d:	75 64                	jne    803db3 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803d4f:	ba 07 00 00 00       	mov    $0x7,%edx
  803d54:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d59:	bf 00 00 00 00       	mov    $0x0,%edi
  803d5e:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  803d65:	00 00 00 
  803d68:	ff d0                	callq  *%rax
  803d6a:	85 c0                	test   %eax,%eax
  803d6c:	74 2a                	je     803d98 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803d6e:	48 ba c0 48 80 00 00 	movabs $0x8048c0,%rdx
  803d75:	00 00 00 
  803d78:	be 22 00 00 00       	mov    $0x22,%esi
  803d7d:	48 bf e8 48 80 00 00 	movabs $0x8048e8,%rdi
  803d84:	00 00 00 
  803d87:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8c:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  803d93:	00 00 00 
  803d96:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803d98:	48 be c6 3d 80 00 00 	movabs $0x803dc6,%rsi
  803d9f:	00 00 00 
  803da2:	bf 00 00 00 00       	mov    $0x0,%edi
  803da7:	48 b8 99 1e 80 00 00 	movabs $0x801e99,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803db3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803dba:	00 00 00 
  803dbd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803dc1:	48 89 10             	mov    %rdx,(%rax)
}
  803dc4:	c9                   	leaveq 
  803dc5:	c3                   	retq   

0000000000803dc6 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803dc6:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803dc9:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803dd0:	00 00 00 
call *%rax
  803dd3:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803dd5:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803ddc:	00 
mov 136(%rsp), %r9
  803ddd:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803de4:	00 
sub $8, %r8
  803de5:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803de9:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803dec:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803df3:	00 
add $16, %rsp
  803df4:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803df8:	4c 8b 3c 24          	mov    (%rsp),%r15
  803dfc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803e01:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803e06:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803e0b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803e10:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803e15:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803e1a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803e1f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803e24:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803e29:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803e2e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e33:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e38:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e3d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e42:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803e46:	48 83 c4 08          	add    $0x8,%rsp
popf
  803e4a:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803e4b:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803e4f:	c3                   	retq   

0000000000803e50 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e50:	55                   	push   %rbp
  803e51:	48 89 e5             	mov    %rsp,%rbp
  803e54:	48 83 ec 30          	sub    $0x30,%rsp
  803e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803e64:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e69:	74 18                	je     803e83 <ipc_recv+0x33>
  803e6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6f:	48 89 c7             	mov    %rax,%rdi
  803e72:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  803e79:	00 00 00 
  803e7c:	ff d0                	callq  *%rax
  803e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e81:	eb 19                	jmp    803e9c <ipc_recv+0x4c>
  803e83:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803e8a:	00 00 00 
  803e8d:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  803e94:	00 00 00 
  803e97:	ff d0                	callq  *%rax
  803e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803e9c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ea1:	74 26                	je     803ec9 <ipc_recv+0x79>
  803ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ea7:	75 15                	jne    803ebe <ipc_recv+0x6e>
  803ea9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eb0:	00 00 00 
  803eb3:	48 8b 00             	mov    (%rax),%rax
  803eb6:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803ebc:	eb 05                	jmp    803ec3 <ipc_recv+0x73>
  803ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ec7:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803ec9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ece:	74 26                	je     803ef6 <ipc_recv+0xa6>
  803ed0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed4:	75 15                	jne    803eeb <ipc_recv+0x9b>
  803ed6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803edd:	00 00 00 
  803ee0:	48 8b 00             	mov    (%rax),%rax
  803ee3:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803ee9:	eb 05                	jmp    803ef0 <ipc_recv+0xa0>
  803eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ef4:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803efa:	75 15                	jne    803f11 <ipc_recv+0xc1>
  803efc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f03:	00 00 00 
  803f06:	48 8b 00             	mov    (%rax),%rax
  803f09:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803f0f:	eb 03                	jmp    803f14 <ipc_recv+0xc4>
  803f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f14:	c9                   	leaveq 
  803f15:	c3                   	retq   

0000000000803f16 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f16:	55                   	push   %rbp
  803f17:	48 89 e5             	mov    %rsp,%rbp
  803f1a:	48 83 ec 30          	sub    $0x30,%rsp
  803f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f21:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f24:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f28:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803f2b:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803f32:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f37:	75 10                	jne    803f49 <ipc_send+0x33>
  803f39:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f40:	00 00 00 
  803f43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803f47:	eb 62                	jmp    803fab <ipc_send+0x95>
  803f49:	eb 60                	jmp    803fab <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803f4b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f4f:	74 30                	je     803f81 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f54:	89 c1                	mov    %eax,%ecx
  803f56:	48 ba f6 48 80 00 00 	movabs $0x8048f6,%rdx
  803f5d:	00 00 00 
  803f60:	be 33 00 00 00       	mov    $0x33,%esi
  803f65:	48 bf 12 49 80 00 00 	movabs $0x804912,%rdi
  803f6c:	00 00 00 
  803f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f74:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  803f7b:	00 00 00 
  803f7e:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803f81:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f84:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8e:	89 c7                	mov    %eax,%edi
  803f90:	48 b8 e3 1e 80 00 00 	movabs $0x801ee3,%rax
  803f97:	00 00 00 
  803f9a:	ff d0                	callq  *%rax
  803f9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803f9f:	48 b8 d1 1c 80 00 00 	movabs $0x801cd1,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803fab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803faf:	75 9a                	jne    803f4b <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803fb1:	c9                   	leaveq 
  803fb2:	c3                   	retq   

0000000000803fb3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fb3:	55                   	push   %rbp
  803fb4:	48 89 e5             	mov    %rsp,%rbp
  803fb7:	48 83 ec 14          	sub    $0x14,%rsp
  803fbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fc5:	eb 5e                	jmp    804025 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803fc7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fce:	00 00 00 
  803fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd4:	48 63 d0             	movslq %eax,%rdx
  803fd7:	48 89 d0             	mov    %rdx,%rax
  803fda:	48 c1 e0 03          	shl    $0x3,%rax
  803fde:	48 01 d0             	add    %rdx,%rax
  803fe1:	48 c1 e0 05          	shl    $0x5,%rax
  803fe5:	48 01 c8             	add    %rcx,%rax
  803fe8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fee:	8b 00                	mov    (%rax),%eax
  803ff0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ff3:	75 2c                	jne    804021 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ff5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ffc:	00 00 00 
  803fff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804002:	48 63 d0             	movslq %eax,%rdx
  804005:	48 89 d0             	mov    %rdx,%rax
  804008:	48 c1 e0 03          	shl    $0x3,%rax
  80400c:	48 01 d0             	add    %rdx,%rax
  80400f:	48 c1 e0 05          	shl    $0x5,%rax
  804013:	48 01 c8             	add    %rcx,%rax
  804016:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80401c:	8b 40 08             	mov    0x8(%rax),%eax
  80401f:	eb 12                	jmp    804033 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804021:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804025:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80402c:	7e 99                	jle    803fc7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80402e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804033:	c9                   	leaveq 
  804034:	c3                   	retq   

0000000000804035 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804035:	55                   	push   %rbp
  804036:	48 89 e5             	mov    %rsp,%rbp
  804039:	48 83 ec 18          	sub    $0x18,%rsp
  80403d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804045:	48 c1 e8 15          	shr    $0x15,%rax
  804049:	48 89 c2             	mov    %rax,%rdx
  80404c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804053:	01 00 00 
  804056:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80405a:	83 e0 01             	and    $0x1,%eax
  80405d:	48 85 c0             	test   %rax,%rax
  804060:	75 07                	jne    804069 <pageref+0x34>
		return 0;
  804062:	b8 00 00 00 00       	mov    $0x0,%eax
  804067:	eb 53                	jmp    8040bc <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80406d:	48 c1 e8 0c          	shr    $0xc,%rax
  804071:	48 89 c2             	mov    %rax,%rdx
  804074:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80407b:	01 00 00 
  80407e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804082:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408a:	83 e0 01             	and    $0x1,%eax
  80408d:	48 85 c0             	test   %rax,%rax
  804090:	75 07                	jne    804099 <pageref+0x64>
		return 0;
  804092:	b8 00 00 00 00       	mov    $0x0,%eax
  804097:	eb 23                	jmp    8040bc <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409d:	48 c1 e8 0c          	shr    $0xc,%rax
  8040a1:	48 89 c2             	mov    %rax,%rdx
  8040a4:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040ab:	00 00 00 
  8040ae:	48 c1 e2 04          	shl    $0x4,%rdx
  8040b2:	48 01 d0             	add    %rdx,%rax
  8040b5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040b9:	0f b7 c0             	movzwl %ax,%eax
}
  8040bc:	c9                   	leaveq 
  8040bd:	c3                   	retq   
