
obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 35 11 00 00       	callq  801176 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf 88 5d 80 00 00 	movabs $0x805d88,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf a0 5d 80 00 00 	movabs $0x805da0,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf c6 5d 80 00 00 	movabs $0x805dc6,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf e0 5d 80 00 00 	movabs $0x805de0,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 06 5e 80 00 00 	movabs $0x805e06,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 84 53 80 00 00 	movabs $0x805384,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 1c 5e 80 00 00 	movabs $0x805e1c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 25 5e 80 00 00 	movabs $0x805e25,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 60 2f 80 00 00 	movabs $0x802f60,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 32 5e 80 00 00 	movabs $0x805e32,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 ac 38 80 00 00 	movabs $0x8038ac,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba 3b 5e 80 00 00 	movabs $0x805e3b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf 57 5e 80 00 00 	movabs $0x805e57,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf 61 5e 80 00 00 	movabs $0x805e61,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 b4 21 80 00 00 	movabs $0x8021b4,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 3d 3e 80 00 00 	movabs $0x803e3d,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf 70 5e 80 00 00 	movabs $0x805e70,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf 7e 5e 80 00 00 	movabs $0x805e7e,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf 82 5e 80 00 00 	movabs $0x805e82,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 92 47 80 00 00 	movabs $0x804792,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf 84 5e 80 00 00 	movabs $0x805e84,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 7e 38 80 00 00 	movabs $0x80387e,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf 92 5e 80 00 00 	movabs $0x805e92,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 62 14 80 00 00 	movabs $0x801462,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 4d 59 80 00 00 	movabs $0x80594d,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf a7 5e 80 00 00 	movabs $0x805ea7,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf bd 5e 80 00 00 	movabs $0x805ebd,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 4d 59 80 00 00 	movabs $0x80594d,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf a7 5e 80 00 00 	movabs $0x805ea7,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf da 5e 80 00 00 	movabs $0x805eda,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf e9 5e 80 00 00 	movabs $0x805ee9,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf f7 5e 80 00 00 	movabs $0x805ef7,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf fc 5e 80 00 00 	movabs $0x805efc,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 01 5f 80 00 00 	movabs $0x805f01,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 09 5f 80 00 00 	movabs $0x805f09,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 11 5f 80 00 00 	movabs $0x805f11,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 1d 5f 80 00 00 	movabs $0x805f1d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf 28 5f 80 00 00 	movabs $0x805f28,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
  800b5e:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6c:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b70:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b74:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b78:	48 89 ce             	mov    %rcx,%rsi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 58 32 80 00 00 	movabs $0x803258,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8a:	eb 4d                	jmp    800bd9 <umain+0x8a>
		switch (r) {
  800b8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8f:	83 f8 69             	cmp    $0x69,%eax
  800b92:	74 27                	je     800bbb <umain+0x6c>
  800b94:	83 f8 78             	cmp    $0x78,%eax
  800b97:	74 2b                	je     800bc4 <umain+0x75>
  800b99:	83 f8 64             	cmp    $0x64,%eax
  800b9c:	75 2f                	jne    800bcd <umain+0x7e>
		case 'd':
			debug++;
  800b9e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bb4:	00 00 00 
  800bb7:	89 10                	mov    %edx,(%rax)
			break;
  800bb9:	eb 1e                	jmp    800bd9 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc2:	eb 15                	jmp    800bd9 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcb:	eb 0c                	jmp    800bd9 <umain+0x8a>
		default:
			usage();
  800bcd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 bc 32 80 00 00 	movabs $0x8032bc,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
			echocmds = 1;
			break;
		default:
			usage();
		}
	if (argc > 2)
  800bf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf8:	83 f8 02             	cmp    $0x2,%eax
  800bfb:	7e 0c                	jle    800c09 <umain+0xba>
		usage();
  800bfd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c09:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0c:	83 f8 02             	cmp    $0x2,%eax
  800c0f:	0f 85 b3 00 00 00    	jne    800cc8 <umain+0x179>
		close(0);
  800c15:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1a:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
  800c45:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4c:	79 3f                	jns    800c8d <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c52:	48 83 c0 08          	add    $0x8,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5c:	41 89 d0             	mov    %edx,%r8d
  800c5f:	48 89 c1             	mov    %rax,%rcx
  800c62:	48 ba 49 5f 80 00 00 	movabs $0x805f49,%rdx
  800c69:	00 00 00 
  800c6c:	be 29 01 00 00       	mov    $0x129,%esi
  800c71:	48 bf 57 5e 80 00 00 	movabs $0x805e57,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 29 12 80 00 00 	movabs $0x801229,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 55 5f 80 00 00 	movabs $0x805f55,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba 5c 5f 80 00 00 	movabs $0x805f5c,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2a 01 00 00       	mov    $0x12a,%esi
  800cac:	48 bf 57 5e 80 00 00 	movabs $0x805e57,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;
		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 71 5f 80 00 00 	movabs $0x805f71,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf 74 5f 80 00 00 	movabs $0x805f74,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if(strcmp(buf, "quit")==0)
  800d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4e:	48 be 7d 5f 80 00 00 	movabs $0x805f7d,%rsi
  800d55:	00 00 00 
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	85 c0                	test   %eax,%eax
  800d69:	75 0c                	jne    800d77 <umain+0x228>
			exit();
  800d6b:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
		if (debug)
  800d77:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d7e:	00 00 00 
  800d81:	8b 00                	mov    (%rax),%eax
  800d83:	85 c0                	test   %eax,%eax
  800d85:	74 22                	je     800da9 <umain+0x25a>
			cprintf("LINE: %s\n", buf);
  800d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8b:	48 89 c6             	mov    %rax,%rsi
  800d8e:	48 bf 82 5f 80 00 00 	movabs $0x805f82,%rdi
  800d95:	00 00 00 
  800d98:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9d:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800da4:	00 00 00 
  800da7:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dad:	0f b6 00             	movzbl (%rax),%eax
  800db0:	3c 23                	cmp    $0x23,%al
  800db2:	75 05                	jne    800db9 <umain+0x26a>
			continue;
  800db4:	e9 05 01 00 00       	jmpq   800ebe <umain+0x36f>
		if (echocmds)
  800db9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800dbd:	74 22                	je     800de1 <umain+0x292>
			printf("# %s\n", buf);
  800dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc3:	48 89 c6             	mov    %rax,%rsi
  800dc6:	48 bf 8c 5f 80 00 00 	movabs $0x805f8c,%rdi
  800dcd:	00 00 00 
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	48 ba dc 46 80 00 00 	movabs $0x8046dc,%rdx
  800ddc:	00 00 00 
  800ddf:	ff d2                	callq  *%rdx
		if (debug)
  800de1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800de8:	00 00 00 
  800deb:	8b 00                	mov    (%rax),%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	74 1b                	je     800e0c <umain+0x2bd>
			cprintf("BEFORE FORK\n");
  800df1:	48 bf 92 5f 80 00 00 	movabs $0x805f92,%rdi
  800df8:	00 00 00 
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800e07:	00 00 00 
  800e0a:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800e0c:	48 b8 60 2f 80 00 00 	movabs $0x802f60,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e1f:	79 30                	jns    800e51 <umain+0x302>
			panic("fork: %e", r);
  800e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e24:	89 c1                	mov    %eax,%ecx
  800e26:	48 ba 32 5e 80 00 00 	movabs $0x805e32,%rdx
  800e2d:	00 00 00 
  800e30:	be 42 01 00 00       	mov    $0x142,%esi
  800e35:	48 bf 57 5e 80 00 00 	movabs $0x805e57,%rdi
  800e3c:	00 00 00 
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  800e4b:	00 00 00 
  800e4e:	41 ff d0             	callq  *%r8
		if (debug)
  800e51:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e58:	00 00 00 
  800e5b:	8b 00                	mov    (%rax),%eax
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	74 20                	je     800e81 <umain+0x332>
			cprintf("FORK: %d\n", r);
  800e61:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e64:	89 c6                	mov    %eax,%esi
  800e66:	48 bf 9f 5f 80 00 00 	movabs $0x805f9f,%rdi
  800e6d:	00 00 00 
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  800e7c:	00 00 00 
  800e7f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e85:	75 21                	jne    800ea8 <umain+0x359>
			runcmd(buf);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
			exit();
  800e9a:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	eb 16                	jmp    800ebe <umain+0x36f>
		} else {
			wait(r);
  800ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 4d 59 80 00 00 	movabs $0x80594d,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
		}
	}
  800eb9:	e9 24 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800ebe:	e9 1f fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800ec3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 83 ec 20          	sub    $0x20,%rsp
  800ecb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ed1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ed4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ed8:	be 01 00 00 00       	mov    $0x1,%esi
  800edd:	48 89 c7             	mov    %rax,%rdi
  800ee0:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	callq  *%rax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <getchar>:

int
getchar(void)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ef6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800efa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eff:	48 89 c6             	mov    %rax,%rsi
  800f02:	bf 00 00 00 00       	mov    $0x0,%edi
  800f07:	48 b8 55 3a 80 00 00 	movabs $0x803a55,%rax
  800f0e:	00 00 00 
  800f11:	ff d0                	callq  *%rax
  800f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f1a:	79 05                	jns    800f21 <getchar+0x33>
		return r;
  800f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1f:	eb 14                	jmp    800f35 <getchar+0x47>
	if (r < 1)
  800f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f25:	7f 07                	jg     800f2e <getchar+0x40>
		return -E_EOF;
  800f27:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f2c:	eb 07                	jmp    800f35 <getchar+0x47>
	return c;
  800f2e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
}
  800f35:	c9                   	leaveq 
  800f36:	c3                   	retq   

0000000000800f37 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f37:	55                   	push   %rbp
  800f38:	48 89 e5             	mov    %rsp,%rbp
  800f3b:	48 83 ec 20          	sub    $0x20,%rsp
  800f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f49:	48 89 d6             	mov    %rdx,%rsi
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f61:	79 05                	jns    800f68 <iscons+0x31>
		return r;
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	eb 1a                	jmp    800f82 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6c:	8b 10                	mov    (%rax),%edx
  800f6e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800f75:	00 00 00 
  800f78:	8b 00                	mov    (%rax),%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	0f 94 c0             	sete   %al
  800f7f:	0f b6 c0             	movzbl %al,%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <opencons>:

int
opencons(void)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa6:	79 05                	jns    800fad <opencons+0x29>
		return r;
  800fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fab:	eb 5b                	jmp    801008 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb1:	ba 07 04 00 00       	mov    $0x407,%edx
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  800fc5:	00 00 00 
  800fc8:	ff d0                	callq  *%rax
  800fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd1:	79 05                	jns    800fd8 <opencons+0x54>
		return r;
  800fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd6:	eb 30                	jmp    801008 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  800fe3:	00 00 00 
  800fe6:	8b 12                	mov    (%rdx),%edx
  800fe8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
}
  801008:	c9                   	leaveq 
  801009:	c3                   	retq   

000000000080100a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 30          	sub    $0x30,%rsp
  801012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80101e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801023:	75 07                	jne    80102c <devcons_read+0x22>
		return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 4b                	jmp    801077 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80102c:	eb 0c                	jmp    80103a <devcons_read+0x30>
		sys_yield();
  80102e:	48 b8 62 2a 80 00 00 	movabs $0x802a62,%rax
  801035:	00 00 00 
  801038:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80103a:	48 b8 a2 29 80 00 00 	movabs $0x8029a2,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80104d:	74 df                	je     80102e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80104f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801053:	79 05                	jns    80105a <devcons_read+0x50>
		return c;
  801055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801058:	eb 1d                	jmp    801077 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80105a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80105e:	75 07                	jne    801067 <devcons_read+0x5d>
		return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 10                	jmp    801077 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801070:	88 10                	mov    %dl,(%rax)
	return 1;
  801072:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801084:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80108b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801092:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a0:	eb 76                	jmp    801118 <devcons_write+0x9f>
		m = n - tot;
  8010a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8010b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010b8:	83 f8 7f             	cmp    $0x7f,%eax
  8010bb:	76 07                	jbe    8010c4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8010bd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8010c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c7:	48 63 d0             	movslq %eax,%rdx
  8010ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cd:	48 63 c8             	movslq %eax,%rcx
  8010d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010d7:	48 01 c1             	add    %rax,%rcx
  8010da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010e1:	48 89 ce             	mov    %rcx,%rsi
  8010e4:	48 89 c7             	mov    %rax,%rdi
  8010e7:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010f6:	48 63 d0             	movslq %eax,%rdx
  8010f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801115:	01 45 fc             	add    %eax,-0x4(%rbp)
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 98                	cltq   
  80111d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801124:	0f 82 78 ff ff ff    	jb     8010a2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 08          	sub    $0x8,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801156:	48 be ae 5f 80 00 00 	movabs $0x805fae,%rsi
  80115d:	00 00 00 
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 10          	sub    $0x10,%rsp
  80117e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  801185:	48 b8 24 2a 80 00 00 	movabs $0x802a24,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	48 98                	cltq   
  801193:	25 ff 03 00 00       	and    $0x3ff,%eax
  801198:	48 89 c2             	mov    %rax,%rdx
  80119b:	48 89 d0             	mov    %rdx,%rax
  80119e:	48 c1 e0 03          	shl    $0x3,%rax
  8011a2:	48 01 d0             	add    %rdx,%rax
  8011a5:	48 c1 e0 05          	shl    $0x5,%rax
  8011a9:	48 89 c2             	mov    %rax,%rdx
  8011ac:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8011b3:	00 00 00 
  8011b6:	48 01 c2             	add    %rax,%rdx
  8011b9:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8011c0:	00 00 00 
  8011c3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011ca:	7e 14                	jle    8011e0 <libmain+0x6a>
		binaryname = argv[0];
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	48 8b 10             	mov    (%rax),%rdx
  8011d3:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8011da:	00 00 00 
  8011dd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e7:	48 89 d6             	mov    %rdx,%rsi
  8011ea:	89 c7                	mov    %eax,%edi
  8011ec:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011f3:	00 00 00 
  8011f6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8011f8:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  8011ff:	00 00 00 
  801202:	ff d0                	callq  *%rax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80120a:	48 b8 7e 38 80 00 00 	movabs $0x80387e,%rax
  801211:	00 00 00 
  801214:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801216:	bf 00 00 00 00       	mov    $0x0,%edi
  80121b:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  801222:	00 00 00 
  801225:	ff d0                	callq  *%rax
}
  801227:	5d                   	pop    %rbp
  801228:	c3                   	retq   

0000000000801229 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	53                   	push   %rbx
  80122e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801235:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80123c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801242:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801249:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801250:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801257:	84 c0                	test   %al,%al
  801259:	74 23                	je     80127e <_panic+0x55>
  80125b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801262:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801266:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80126a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80126e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801272:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801276:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80127a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80127e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801285:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80128c:	00 00 00 
  80128f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801296:	00 00 00 
  801299:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80129d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8012a4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8012ab:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012b2:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8012b9:	00 00 00 
  8012bc:	48 8b 18             	mov    (%rax),%rbx
  8012bf:	48 b8 24 2a 80 00 00 	movabs $0x802a24,%rax
  8012c6:	00 00 00 
  8012c9:	ff d0                	callq  *%rax
  8012cb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012d8:	41 89 c8             	mov    %ecx,%r8d
  8012db:	48 89 d1             	mov    %rdx,%rcx
  8012de:	48 89 da             	mov    %rbx,%rdx
  8012e1:	89 c6                	mov    %eax,%esi
  8012e3:	48 bf c0 5f 80 00 00 	movabs $0x805fc0,%rdi
  8012ea:	00 00 00 
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	49 b9 62 14 80 00 00 	movabs $0x801462,%r9
  8012f9:	00 00 00 
  8012fc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012ff:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801306:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80130d:	48 89 d6             	mov    %rdx,%rsi
  801310:	48 89 c7             	mov    %rax,%rdi
  801313:	48 b8 b6 13 80 00 00 	movabs $0x8013b6,%rax
  80131a:	00 00 00 
  80131d:	ff d0                	callq  *%rax
	cprintf("\n");
  80131f:	48 bf e3 5f 80 00 00 	movabs $0x805fe3,%rdi
  801326:	00 00 00 
  801329:	b8 00 00 00 00       	mov    $0x0,%eax
  80132e:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  801335:	00 00 00 
  801338:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80133a:	cc                   	int3   
  80133b:	eb fd                	jmp    80133a <_panic+0x111>

000000000080133d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	48 83 ec 10          	sub    $0x10,%rsp
  801345:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801348:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80134c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801350:	8b 00                	mov    (%rax),%eax
  801352:	8d 48 01             	lea    0x1(%rax),%ecx
  801355:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801359:	89 0a                	mov    %ecx,(%rdx)
  80135b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80135e:	89 d1                	mov    %edx,%ecx
  801360:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801364:	48 98                	cltq   
  801366:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80136a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136e:	8b 00                	mov    (%rax),%eax
  801370:	3d ff 00 00 00       	cmp    $0xff,%eax
  801375:	75 2c                	jne    8013a3 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137b:	8b 00                	mov    (%rax),%eax
  80137d:	48 98                	cltq   
  80137f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801383:	48 83 c2 08          	add    $0x8,%rdx
  801387:	48 89 c6             	mov    %rax,%rsi
  80138a:	48 89 d7             	mov    %rdx,%rdi
  80138d:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  801394:	00 00 00 
  801397:	ff d0                	callq  *%rax
        b->idx = 0;
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	8b 40 04             	mov    0x4(%rax),%eax
  8013aa:	8d 50 01             	lea    0x1(%rax),%edx
  8013ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013b4:	c9                   	leaveq 
  8013b5:	c3                   	retq   

00000000008013b6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8013b6:	55                   	push   %rbp
  8013b7:	48 89 e5             	mov    %rsp,%rbp
  8013ba:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013c1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013c8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8013cf:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013d6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013dd:	48 8b 0a             	mov    (%rdx),%rcx
  8013e0:	48 89 08             	mov    %rcx,(%rax)
  8013e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8013f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013fa:	00 00 00 
    b.cnt = 0;
  8013fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801404:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801407:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80140e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801415:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80141c:	48 89 c6             	mov    %rax,%rsi
  80141f:	48 bf 3d 13 80 00 00 	movabs $0x80133d,%rdi
  801426:	00 00 00 
  801429:	48 b8 15 18 80 00 00 	movabs $0x801815,%rax
  801430:	00 00 00 
  801433:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801435:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80143b:	48 98                	cltq   
  80143d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801444:	48 83 c2 08          	add    $0x8,%rdx
  801448:	48 89 c6             	mov    %rax,%rsi
  80144b:	48 89 d7             	mov    %rdx,%rdi
  80144e:	48 b8 58 29 80 00 00 	movabs $0x802958,%rax
  801455:	00 00 00 
  801458:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80145a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80146d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801474:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80147b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801482:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801489:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801490:	84 c0                	test   %al,%al
  801492:	74 20                	je     8014b4 <cprintf+0x52>
  801494:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801498:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80149c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014a0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014a4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014a8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014ac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014b0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014b4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8014bb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014c2:	00 00 00 
  8014c5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014cc:	00 00 00 
  8014cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014d3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014da:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014e1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8014e8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014ef:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014f6:	48 8b 0a             	mov    (%rdx),%rcx
  8014f9:	48 89 08             	mov    %rcx,(%rax)
  8014fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801500:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801504:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801508:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80150c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801513:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80151a:	48 89 d6             	mov    %rdx,%rsi
  80151d:	48 89 c7             	mov    %rax,%rdi
  801520:	48 b8 b6 13 80 00 00 	movabs $0x8013b6,%rax
  801527:	00 00 00 
  80152a:	ff d0                	callq  *%rax
  80152c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801532:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	53                   	push   %rbx
  80153f:	48 83 ec 38          	sub    $0x38,%rsp
  801543:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801547:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801552:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801556:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80155a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80155d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801561:	77 3b                	ja     80159e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801563:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801566:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80156a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	48 f7 f3             	div    %rbx
  801579:	48 89 c2             	mov    %rax,%rdx
  80157c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80157f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801582:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	41 89 f9             	mov    %edi,%r9d
  80158d:	48 89 c7             	mov    %rax,%rdi
  801590:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801597:	00 00 00 
  80159a:	ff d0                	callq  *%rax
  80159c:	eb 1e                	jmp    8015bc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80159e:	eb 12                	jmp    8015b2 <printnum+0x78>
			putch(padc, putdat);
  8015a0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015a4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8015a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ab:	48 89 ce             	mov    %rcx,%rsi
  8015ae:	89 d7                	mov    %edx,%edi
  8015b0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015b2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8015b6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8015ba:	7f e4                	jg     8015a0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015bc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	48 f7 f1             	div    %rcx
  8015cb:	48 89 d0             	mov    %rdx,%rax
  8015ce:	48 ba f0 61 80 00 00 	movabs $0x8061f0,%rdx
  8015d5:	00 00 00 
  8015d8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015dc:	0f be d0             	movsbl %al,%edx
  8015df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e7:	48 89 ce             	mov    %rcx,%rsi
  8015ea:	89 d7                	mov    %edx,%edi
  8015ec:	ff d0                	callq  *%rax
}
  8015ee:	48 83 c4 38          	add    $0x38,%rsp
  8015f2:	5b                   	pop    %rbx
  8015f3:	5d                   	pop    %rbp
  8015f4:	c3                   	retq   

00000000008015f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015f5:	55                   	push   %rbp
  8015f6:	48 89 e5             	mov    %rsp,%rbp
  8015f9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801601:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801604:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801608:	7e 52                	jle    80165c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80160a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160e:	8b 00                	mov    (%rax),%eax
  801610:	83 f8 30             	cmp    $0x30,%eax
  801613:	73 24                	jae    801639 <getuint+0x44>
  801615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801619:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80161d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801621:	8b 00                	mov    (%rax),%eax
  801623:	89 c0                	mov    %eax,%eax
  801625:	48 01 d0             	add    %rdx,%rax
  801628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80162c:	8b 12                	mov    (%rdx),%edx
  80162e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801631:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801635:	89 0a                	mov    %ecx,(%rdx)
  801637:	eb 17                	jmp    801650 <getuint+0x5b>
  801639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801641:	48 89 d0             	mov    %rdx,%rax
  801644:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801650:	48 8b 00             	mov    (%rax),%rax
  801653:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801657:	e9 a3 00 00 00       	jmpq   8016ff <getuint+0x10a>
	else if (lflag)
  80165c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801660:	74 4f                	je     8016b1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801666:	8b 00                	mov    (%rax),%eax
  801668:	83 f8 30             	cmp    $0x30,%eax
  80166b:	73 24                	jae    801691 <getuint+0x9c>
  80166d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801671:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801679:	8b 00                	mov    (%rax),%eax
  80167b:	89 c0                	mov    %eax,%eax
  80167d:	48 01 d0             	add    %rdx,%rax
  801680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801684:	8b 12                	mov    (%rdx),%edx
  801686:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801689:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168d:	89 0a                	mov    %ecx,(%rdx)
  80168f:	eb 17                	jmp    8016a8 <getuint+0xb3>
  801691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801695:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801699:	48 89 d0             	mov    %rdx,%rax
  80169c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016a8:	48 8b 00             	mov    (%rax),%rax
  8016ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8016af:	eb 4e                	jmp    8016ff <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8016b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b5:	8b 00                	mov    (%rax),%eax
  8016b7:	83 f8 30             	cmp    $0x30,%eax
  8016ba:	73 24                	jae    8016e0 <getuint+0xeb>
  8016bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c8:	8b 00                	mov    (%rax),%eax
  8016ca:	89 c0                	mov    %eax,%eax
  8016cc:	48 01 d0             	add    %rdx,%rax
  8016cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d3:	8b 12                	mov    (%rdx),%edx
  8016d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016dc:	89 0a                	mov    %ecx,(%rdx)
  8016de:	eb 17                	jmp    8016f7 <getuint+0x102>
  8016e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016e8:	48 89 d0             	mov    %rdx,%rax
  8016eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016f7:	8b 00                	mov    (%rax),%eax
  8016f9:	89 c0                	mov    %eax,%eax
  8016fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801703:	c9                   	leaveq 
  801704:	c3                   	retq   

0000000000801705 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801705:	55                   	push   %rbp
  801706:	48 89 e5             	mov    %rsp,%rbp
  801709:	48 83 ec 1c          	sub    $0x1c,%rsp
  80170d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801711:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801714:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801718:	7e 52                	jle    80176c <getint+0x67>
		x=va_arg(*ap, long long);
  80171a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171e:	8b 00                	mov    (%rax),%eax
  801720:	83 f8 30             	cmp    $0x30,%eax
  801723:	73 24                	jae    801749 <getint+0x44>
  801725:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801729:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80172d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801731:	8b 00                	mov    (%rax),%eax
  801733:	89 c0                	mov    %eax,%eax
  801735:	48 01 d0             	add    %rdx,%rax
  801738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80173c:	8b 12                	mov    (%rdx),%edx
  80173e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801741:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801745:	89 0a                	mov    %ecx,(%rdx)
  801747:	eb 17                	jmp    801760 <getint+0x5b>
  801749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801751:	48 89 d0             	mov    %rdx,%rax
  801754:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801758:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801760:	48 8b 00             	mov    (%rax),%rax
  801763:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801767:	e9 a3 00 00 00       	jmpq   80180f <getint+0x10a>
	else if (lflag)
  80176c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801770:	74 4f                	je     8017c1 <getint+0xbc>
		x=va_arg(*ap, long);
  801772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801776:	8b 00                	mov    (%rax),%eax
  801778:	83 f8 30             	cmp    $0x30,%eax
  80177b:	73 24                	jae    8017a1 <getint+0x9c>
  80177d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801781:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801789:	8b 00                	mov    (%rax),%eax
  80178b:	89 c0                	mov    %eax,%eax
  80178d:	48 01 d0             	add    %rdx,%rax
  801790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801794:	8b 12                	mov    (%rdx),%edx
  801796:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801799:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179d:	89 0a                	mov    %ecx,(%rdx)
  80179f:	eb 17                	jmp    8017b8 <getint+0xb3>
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017a9:	48 89 d0             	mov    %rdx,%rax
  8017ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017b8:	48 8b 00             	mov    (%rax),%rax
  8017bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017bf:	eb 4e                	jmp    80180f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c5:	8b 00                	mov    (%rax),%eax
  8017c7:	83 f8 30             	cmp    $0x30,%eax
  8017ca:	73 24                	jae    8017f0 <getint+0xeb>
  8017cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d8:	8b 00                	mov    (%rax),%eax
  8017da:	89 c0                	mov    %eax,%eax
  8017dc:	48 01 d0             	add    %rdx,%rax
  8017df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e3:	8b 12                	mov    (%rdx),%edx
  8017e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ec:	89 0a                	mov    %ecx,(%rdx)
  8017ee:	eb 17                	jmp    801807 <getint+0x102>
  8017f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017f8:	48 89 d0             	mov    %rdx,%rax
  8017fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801803:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801807:	8b 00                	mov    (%rax),%eax
  801809:	48 98                	cltq   
  80180b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80180f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801813:	c9                   	leaveq 
  801814:	c3                   	retq   

0000000000801815 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801815:	55                   	push   %rbp
  801816:	48 89 e5             	mov    %rsp,%rbp
  801819:	41 54                	push   %r12
  80181b:	53                   	push   %rbx
  80181c:	48 83 ec 60          	sub    $0x60,%rsp
  801820:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801824:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801828:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80182c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801830:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801834:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801838:	48 8b 0a             	mov    (%rdx),%rcx
  80183b:	48 89 08             	mov    %rcx,(%rax)
  80183e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801842:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801846:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80184a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80184e:	eb 17                	jmp    801867 <vprintfmt+0x52>
			if (ch == '\0')
  801850:	85 db                	test   %ebx,%ebx
  801852:	0f 84 cc 04 00 00    	je     801d24 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801858:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80185c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801860:	48 89 d6             	mov    %rdx,%rsi
  801863:	89 df                	mov    %ebx,%edi
  801865:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801867:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80186b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80186f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	0f b6 d8             	movzbl %al,%ebx
  801879:	83 fb 25             	cmp    $0x25,%ebx
  80187c:	75 d2                	jne    801850 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80187e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801882:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801889:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801890:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801897:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80189e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	0f b6 d8             	movzbl %al,%ebx
  8018b0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8018b3:	83 f8 55             	cmp    $0x55,%eax
  8018b6:	0f 87 34 04 00 00    	ja     801cf0 <vprintfmt+0x4db>
  8018bc:	89 c0                	mov    %eax,%eax
  8018be:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018c5:	00 
  8018c6:	48 b8 18 62 80 00 00 	movabs $0x806218,%rax
  8018cd:	00 00 00 
  8018d0:	48 01 d0             	add    %rdx,%rax
  8018d3:	48 8b 00             	mov    (%rax),%rax
  8018d6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8018d8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018dc:	eb c0                	jmp    80189e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018de:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018e2:	eb ba                	jmp    80189e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018e4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018eb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	c1 e0 02             	shl    $0x2,%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	01 c0                	add    %eax,%eax
  8018f7:	01 d8                	add    %ebx,%eax
  8018f9:	83 e8 30             	sub    $0x30,%eax
  8018fc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8018ff:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801909:	83 fb 2f             	cmp    $0x2f,%ebx
  80190c:	7e 0c                	jle    80191a <vprintfmt+0x105>
  80190e:	83 fb 39             	cmp    $0x39,%ebx
  801911:	7f 07                	jg     80191a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801913:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801918:	eb d1                	jmp    8018eb <vprintfmt+0xd6>
			goto process_precision;
  80191a:	eb 58                	jmp    801974 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80191c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80191f:	83 f8 30             	cmp    $0x30,%eax
  801922:	73 17                	jae    80193b <vprintfmt+0x126>
  801924:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801928:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80192b:	89 c0                	mov    %eax,%eax
  80192d:	48 01 d0             	add    %rdx,%rax
  801930:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801933:	83 c2 08             	add    $0x8,%edx
  801936:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801939:	eb 0f                	jmp    80194a <vprintfmt+0x135>
  80193b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80193f:	48 89 d0             	mov    %rdx,%rax
  801942:	48 83 c2 08          	add    $0x8,%rdx
  801946:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80194a:	8b 00                	mov    (%rax),%eax
  80194c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80194f:	eb 23                	jmp    801974 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801951:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801955:	79 0c                	jns    801963 <vprintfmt+0x14e>
				width = 0;
  801957:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80195e:	e9 3b ff ff ff       	jmpq   80189e <vprintfmt+0x89>
  801963:	e9 36 ff ff ff       	jmpq   80189e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801968:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80196f:	e9 2a ff ff ff       	jmpq   80189e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801974:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801978:	79 12                	jns    80198c <vprintfmt+0x177>
				width = precision, precision = -1;
  80197a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80197d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801980:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801987:	e9 12 ff ff ff       	jmpq   80189e <vprintfmt+0x89>
  80198c:	e9 0d ff ff ff       	jmpq   80189e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801991:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801995:	e9 04 ff ff ff       	jmpq   80189e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80199a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80199d:	83 f8 30             	cmp    $0x30,%eax
  8019a0:	73 17                	jae    8019b9 <vprintfmt+0x1a4>
  8019a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019a9:	89 c0                	mov    %eax,%eax
  8019ab:	48 01 d0             	add    %rdx,%rax
  8019ae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019b1:	83 c2 08             	add    $0x8,%edx
  8019b4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019b7:	eb 0f                	jmp    8019c8 <vprintfmt+0x1b3>
  8019b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019bd:	48 89 d0             	mov    %rdx,%rax
  8019c0:	48 83 c2 08          	add    $0x8,%rdx
  8019c4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019c8:	8b 10                	mov    (%rax),%edx
  8019ca:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8019ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019d2:	48 89 ce             	mov    %rcx,%rsi
  8019d5:	89 d7                	mov    %edx,%edi
  8019d7:	ff d0                	callq  *%rax
			break;
  8019d9:	e9 40 03 00 00       	jmpq   801d1e <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8019de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019e1:	83 f8 30             	cmp    $0x30,%eax
  8019e4:	73 17                	jae    8019fd <vprintfmt+0x1e8>
  8019e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019ea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019ed:	89 c0                	mov    %eax,%eax
  8019ef:	48 01 d0             	add    %rdx,%rax
  8019f2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019f5:	83 c2 08             	add    $0x8,%edx
  8019f8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019fb:	eb 0f                	jmp    801a0c <vprintfmt+0x1f7>
  8019fd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801a01:	48 89 d0             	mov    %rdx,%rax
  801a04:	48 83 c2 08          	add    $0x8,%rdx
  801a08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a0c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801a0e:	85 db                	test   %ebx,%ebx
  801a10:	79 02                	jns    801a14 <vprintfmt+0x1ff>
				err = -err;
  801a12:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a14:	83 fb 15             	cmp    $0x15,%ebx
  801a17:	7f 16                	jg     801a2f <vprintfmt+0x21a>
  801a19:	48 b8 40 61 80 00 00 	movabs $0x806140,%rax
  801a20:	00 00 00 
  801a23:	48 63 d3             	movslq %ebx,%rdx
  801a26:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a2a:	4d 85 e4             	test   %r12,%r12
  801a2d:	75 2e                	jne    801a5d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801a2f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a37:	89 d9                	mov    %ebx,%ecx
  801a39:	48 ba 01 62 80 00 00 	movabs $0x806201,%rdx
  801a40:	00 00 00 
  801a43:	48 89 c7             	mov    %rax,%rdi
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4b:	49 b8 2d 1d 80 00 00 	movabs $0x801d2d,%r8
  801a52:	00 00 00 
  801a55:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a58:	e9 c1 02 00 00       	jmpq   801d1e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a5d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a65:	4c 89 e1             	mov    %r12,%rcx
  801a68:	48 ba 0a 62 80 00 00 	movabs $0x80620a,%rdx
  801a6f:	00 00 00 
  801a72:	48 89 c7             	mov    %rax,%rdi
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7a:	49 b8 2d 1d 80 00 00 	movabs $0x801d2d,%r8
  801a81:	00 00 00 
  801a84:	41 ff d0             	callq  *%r8
			break;
  801a87:	e9 92 02 00 00       	jmpq   801d1e <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a8f:	83 f8 30             	cmp    $0x30,%eax
  801a92:	73 17                	jae    801aab <vprintfmt+0x296>
  801a94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a9b:	89 c0                	mov    %eax,%eax
  801a9d:	48 01 d0             	add    %rdx,%rax
  801aa0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801aa3:	83 c2 08             	add    $0x8,%edx
  801aa6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801aa9:	eb 0f                	jmp    801aba <vprintfmt+0x2a5>
  801aab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801aaf:	48 89 d0             	mov    %rdx,%rax
  801ab2:	48 83 c2 08          	add    $0x8,%rdx
  801ab6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aba:	4c 8b 20             	mov    (%rax),%r12
  801abd:	4d 85 e4             	test   %r12,%r12
  801ac0:	75 0a                	jne    801acc <vprintfmt+0x2b7>
				p = "(null)";
  801ac2:	49 bc 0d 62 80 00 00 	movabs $0x80620d,%r12
  801ac9:	00 00 00 
			if (width > 0 && padc != '-')
  801acc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801ad0:	7e 3f                	jle    801b11 <vprintfmt+0x2fc>
  801ad2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801ad6:	74 39                	je     801b11 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ad8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 89 c6             	mov    %rax,%rsi
  801ae0:	4c 89 e7             	mov    %r12,%rdi
  801ae3:	48 b8 33 21 80 00 00 	movabs $0x802133,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	callq  *%rax
  801aef:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801af2:	eb 17                	jmp    801b0b <vprintfmt+0x2f6>
					putch(padc, putdat);
  801af4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801af8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801afc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b00:	48 89 ce             	mov    %rcx,%rsi
  801b03:	89 d7                	mov    %edx,%edi
  801b05:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b07:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b0f:	7f e3                	jg     801af4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b11:	eb 37                	jmp    801b4a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801b13:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b17:	74 1e                	je     801b37 <vprintfmt+0x322>
  801b19:	83 fb 1f             	cmp    $0x1f,%ebx
  801b1c:	7e 05                	jle    801b23 <vprintfmt+0x30e>
  801b1e:	83 fb 7e             	cmp    $0x7e,%ebx
  801b21:	7e 14                	jle    801b37 <vprintfmt+0x322>
					putch('?', putdat);
  801b23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b2b:	48 89 d6             	mov    %rdx,%rsi
  801b2e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b33:	ff d0                	callq  *%rax
  801b35:	eb 0f                	jmp    801b46 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801b37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b3f:	48 89 d6             	mov    %rdx,%rsi
  801b42:	89 df                	mov    %ebx,%edi
  801b44:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b4a:	4c 89 e0             	mov    %r12,%rax
  801b4d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801b51:	0f b6 00             	movzbl (%rax),%eax
  801b54:	0f be d8             	movsbl %al,%ebx
  801b57:	85 db                	test   %ebx,%ebx
  801b59:	74 10                	je     801b6b <vprintfmt+0x356>
  801b5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b5f:	78 b2                	js     801b13 <vprintfmt+0x2fe>
  801b61:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b69:	79 a8                	jns    801b13 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b6b:	eb 16                	jmp    801b83 <vprintfmt+0x36e>
				putch(' ', putdat);
  801b6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b75:	48 89 d6             	mov    %rdx,%rsi
  801b78:	bf 20 00 00 00       	mov    $0x20,%edi
  801b7d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b7f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b87:	7f e4                	jg     801b6d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801b89:	e9 90 01 00 00       	jmpq   801d1e <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b92:	be 03 00 00 00       	mov    $0x3,%esi
  801b97:	48 89 c7             	mov    %rax,%rdi
  801b9a:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
  801ba6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801baa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bae:	48 85 c0             	test   %rax,%rax
  801bb1:	79 1d                	jns    801bd0 <vprintfmt+0x3bb>
				putch('-', putdat);
  801bb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bbb:	48 89 d6             	mov    %rdx,%rsi
  801bbe:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801bc3:	ff d0                	callq  *%rax
				num = -(long long) num;
  801bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc9:	48 f7 d8             	neg    %rax
  801bcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bd0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bd7:	e9 d5 00 00 00       	jmpq   801cb1 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801bdc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801be0:	be 03 00 00 00       	mov    $0x3,%esi
  801be5:	48 89 c7             	mov    %rax,%rdi
  801be8:	48 b8 f5 15 80 00 00 	movabs $0x8015f5,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
  801bf4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bf8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bff:	e9 ad 00 00 00       	jmpq   801cb1 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  801c04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c08:	be 03 00 00 00       	mov    $0x3,%esi
  801c0d:	48 89 c7             	mov    %rax,%rdi
  801c10:	48 b8 f5 15 80 00 00 	movabs $0x8015f5,%rax
  801c17:	00 00 00 
  801c1a:	ff d0                	callq  *%rax
  801c1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  801c20:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  801c27:	e9 85 00 00 00       	jmpq   801cb1 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  801c2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c34:	48 89 d6             	mov    %rdx,%rsi
  801c37:	bf 30 00 00 00       	mov    $0x30,%edi
  801c3c:	ff d0                	callq  *%rax
			putch('x', putdat);
  801c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c46:	48 89 d6             	mov    %rdx,%rsi
  801c49:	bf 78 00 00 00       	mov    $0x78,%edi
  801c4e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c53:	83 f8 30             	cmp    $0x30,%eax
  801c56:	73 17                	jae    801c6f <vprintfmt+0x45a>
  801c58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c5f:	89 c0                	mov    %eax,%eax
  801c61:	48 01 d0             	add    %rdx,%rax
  801c64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c67:	83 c2 08             	add    $0x8,%edx
  801c6a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c6d:	eb 0f                	jmp    801c7e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801c6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c73:	48 89 d0             	mov    %rdx,%rax
  801c76:	48 83 c2 08          	add    $0x8,%rdx
  801c7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c7e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801c8c:	eb 23                	jmp    801cb1 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801c8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c92:	be 03 00 00 00       	mov    $0x3,%esi
  801c97:	48 89 c7             	mov    %rax,%rdi
  801c9a:	48 b8 f5 15 80 00 00 	movabs $0x8015f5,%rax
  801ca1:	00 00 00 
  801ca4:	ff d0                	callq  *%rax
  801ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801caa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cb1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cb6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801cb9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc8:	45 89 c1             	mov    %r8d,%r9d
  801ccb:	41 89 f8             	mov    %edi,%r8d
  801cce:	48 89 c7             	mov    %rax,%rdi
  801cd1:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	callq  *%rax
			break;
  801cdd:	eb 3f                	jmp    801d1e <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801ce3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ce7:	48 89 d6             	mov    %rdx,%rsi
  801cea:	89 df                	mov    %ebx,%edi
  801cec:	ff d0                	callq  *%rax
			break;
  801cee:	eb 2e                	jmp    801d1e <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801cf0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cf4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cf8:	48 89 d6             	mov    %rdx,%rsi
  801cfb:	bf 25 00 00 00       	mov    $0x25,%edi
  801d00:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d02:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d07:	eb 05                	jmp    801d0e <vprintfmt+0x4f9>
  801d09:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d12:	48 83 e8 01          	sub    $0x1,%rax
  801d16:	0f b6 00             	movzbl (%rax),%eax
  801d19:	3c 25                	cmp    $0x25,%al
  801d1b:	75 ec                	jne    801d09 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801d1d:	90                   	nop
		}
	}
  801d1e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d1f:	e9 43 fb ff ff       	jmpq   801867 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801d24:	48 83 c4 60          	add    $0x60,%rsp
  801d28:	5b                   	pop    %rbx
  801d29:	41 5c                	pop    %r12
  801d2b:	5d                   	pop    %rbp
  801d2c:	c3                   	retq   

0000000000801d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d2d:	55                   	push   %rbp
  801d2e:	48 89 e5             	mov    %rsp,%rbp
  801d31:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d38:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d3f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d46:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d4d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d54:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d5b:	84 c0                	test   %al,%al
  801d5d:	74 20                	je     801d7f <printfmt+0x52>
  801d5f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d63:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d67:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d6b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d6f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d73:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d77:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d7b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d7f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d86:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801d8d:	00 00 00 
  801d90:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801d97:	00 00 00 
  801d9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d9e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801da5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801dac:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801db3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801dba:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801dc1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801dc8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801dcf:	48 89 c7             	mov    %rax,%rdi
  801dd2:	48 b8 15 18 80 00 00 	movabs $0x801815,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
	va_end(ap);
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 10          	sub    $0x10,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df3:	8b 40 10             	mov    0x10(%rax),%eax
  801df6:	8d 50 01             	lea    0x1(%rax),%edx
  801df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e04:	48 8b 10             	mov    (%rax),%rdx
  801e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0f:	48 39 c2             	cmp    %rax,%rdx
  801e12:	73 17                	jae    801e2b <sprintputch+0x4b>
		*b->buf++ = ch;
  801e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e18:	48 8b 00             	mov    (%rax),%rax
  801e1b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801e1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e23:	48 89 0a             	mov    %rcx,(%rdx)
  801e26:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e29:	88 10                	mov    %dl,(%rax)
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 50          	sub    $0x50,%rsp
  801e35:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e39:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e3c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e40:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e44:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e48:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e4c:	48 8b 0a             	mov    (%rdx),%rcx
  801e4f:	48 89 08             	mov    %rcx,(%rax)
  801e52:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e56:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e5a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e5e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e66:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e6a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e6d:	48 98                	cltq   
  801e6f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e77:	48 01 d0             	add    %rdx,%rax
  801e7a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e85:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e8a:	74 06                	je     801e92 <vsnprintf+0x65>
  801e8c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801e90:	7f 07                	jg     801e99 <vsnprintf+0x6c>
		return -E_INVAL;
  801e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e97:	eb 2f                	jmp    801ec8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801e99:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801e9d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801ea1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ea5:	48 89 c6             	mov    %rax,%rsi
  801ea8:	48 bf e0 1d 80 00 00 	movabs $0x801de0,%rdi
  801eaf:	00 00 00 
  801eb2:	48 b8 15 18 80 00 00 	movabs $0x801815,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801ebe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ec2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801ec5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801ec8:	c9                   	leaveq 
  801ec9:	c3                   	retq   

0000000000801eca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ed5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801edc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801ee2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ee9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ef0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801ef7:	84 c0                	test   %al,%al
  801ef9:	74 20                	je     801f1b <snprintf+0x51>
  801efb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801eff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801f03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f1b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f22:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f29:	00 00 00 
  801f2c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f33:	00 00 00 
  801f36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f3a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f41:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f48:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f4f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f56:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f5d:	48 8b 0a             	mov    (%rdx),%rcx
  801f60:	48 89 08             	mov    %rcx,(%rax)
  801f63:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f67:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f6b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f6f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f73:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f7a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f81:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f87:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f8e:	48 89 c7             	mov    %rax,%rdi
  801f91:	48 b8 2d 1e 80 00 00 	movabs $0x801e2d,%rax
  801f98:	00 00 00 
  801f9b:	ff d0                	callq  *%rax
  801f9d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801fa3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fa9:	c9                   	leaveq 
  801faa:	c3                   	retq   

0000000000801fab <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
  801faf:	48 83 ec 20          	sub    $0x20,%rsp
  801fb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801fb7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fbc:	74 27                	je     801fe5 <readline+0x3a>
		fprintf(1, "%s", prompt);
  801fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc2:	48 89 c2             	mov    %rax,%rdx
  801fc5:	48 be c8 64 80 00 00 	movabs $0x8064c8,%rsi
  801fcc:	00 00 00 
  801fcf:	bf 01 00 00 00       	mov    $0x1,%edi
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	48 b9 24 46 80 00 00 	movabs $0x804624,%rcx
  801fe0:	00 00 00 
  801fe3:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801fe5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801fec:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff1:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
  801ffd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  802000:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802007:	00 00 00 
  80200a:	ff d0                	callq  *%rax
  80200c:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  80200f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802013:	79 30                	jns    802045 <readline+0x9a>
			if (c != -E_EOF)
  802015:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802019:	74 20                	je     80203b <readline+0x90>
				cprintf("read error: %e\n", c);
  80201b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80201e:	89 c6                	mov    %eax,%esi
  802020:	48 bf cb 64 80 00 00 	movabs $0x8064cb,%rdi
  802027:	00 00 00 
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
  80202f:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  802036:	00 00 00 
  802039:	ff d2                	callq  *%rdx
			return NULL;
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	e9 be 00 00 00       	jmpq   802103 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802045:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802049:	74 06                	je     802051 <readline+0xa6>
  80204b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80204f:	75 26                	jne    802077 <readline+0xcc>
  802051:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802055:	7e 20                	jle    802077 <readline+0xcc>
			if (echoing)
  802057:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80205b:	74 11                	je     80206e <readline+0xc3>
				cputchar('\b');
  80205d:	bf 08 00 00 00       	mov    $0x8,%edi
  802062:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802069:	00 00 00 
  80206c:	ff d0                	callq  *%rax
			i--;
  80206e:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802072:	e9 87 00 00 00       	jmpq   8020fe <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802077:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  80207b:	7e 3f                	jle    8020bc <readline+0x111>
  80207d:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802084:	7f 36                	jg     8020bc <readline+0x111>
			if (echoing)
  802086:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80208a:	74 11                	je     80209d <readline+0xf2>
				cputchar(c);
  80208c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80208f:	89 c7                	mov    %eax,%edi
  802091:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802098:	00 00 00 
  80209b:	ff d0                	callq  *%rax
			buf[i++] = c;
  80209d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a0:	8d 50 01             	lea    0x1(%rax),%edx
  8020a3:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8020a6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8020a9:	89 d1                	mov    %edx,%ecx
  8020ab:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8020b2:	00 00 00 
  8020b5:	48 98                	cltq   
  8020b7:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020ba:	eb 42                	jmp    8020fe <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8020bc:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020c0:	74 06                	je     8020c8 <readline+0x11d>
  8020c2:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8020c6:	75 36                	jne    8020fe <readline+0x153>
			if (echoing)
  8020c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020cc:	74 11                	je     8020df <readline+0x134>
				cputchar('\n');
  8020ce:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020d3:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020df:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8020e6:	00 00 00 
  8020e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ec:	48 98                	cltq   
  8020ee:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8020f2:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020f9:	00 00 00 
  8020fc:	eb 05                	jmp    802103 <readline+0x158>
		}
	}
  8020fe:	e9 fd fe ff ff       	jmpq   802000 <readline+0x55>
}
  802103:	c9                   	leaveq 
  802104:	c3                   	retq   

0000000000802105 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802105:	55                   	push   %rbp
  802106:	48 89 e5             	mov    %rsp,%rbp
  802109:	48 83 ec 18          	sub    $0x18,%rsp
  80210d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802118:	eb 09                	jmp    802123 <strlen+0x1e>
		n++;
  80211a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80211e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802127:	0f b6 00             	movzbl (%rax),%eax
  80212a:	84 c0                	test   %al,%al
  80212c:	75 ec                	jne    80211a <strlen+0x15>
		n++;
	return n;
  80212e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802131:	c9                   	leaveq 
  802132:	c3                   	retq   

0000000000802133 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802133:	55                   	push   %rbp
  802134:	48 89 e5             	mov    %rsp,%rbp
  802137:	48 83 ec 20          	sub    $0x20,%rsp
  80213b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80213f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80214a:	eb 0e                	jmp    80215a <strnlen+0x27>
		n++;
  80214c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802150:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802155:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80215a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80215f:	74 0b                	je     80216c <strnlen+0x39>
  802161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802165:	0f b6 00             	movzbl (%rax),%eax
  802168:	84 c0                	test   %al,%al
  80216a:	75 e0                	jne    80214c <strnlen+0x19>
		n++;
	return n;
  80216c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 20          	sub    $0x20,%rsp
  802179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80217d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802185:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802189:	90                   	nop
  80218a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802192:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802196:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80219a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80219e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8021a2:	0f b6 12             	movzbl (%rdx),%edx
  8021a5:	88 10                	mov    %dl,(%rax)
  8021a7:	0f b6 00             	movzbl (%rax),%eax
  8021aa:	84 c0                	test   %al,%al
  8021ac:	75 dc                	jne    80218a <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021b2:	c9                   	leaveq 
  8021b3:	c3                   	retq   

00000000008021b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021b4:	55                   	push   %rbp
  8021b5:	48 89 e5             	mov    %rsp,%rbp
  8021b8:	48 83 ec 20          	sub    $0x20,%rsp
  8021bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8021c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c8:	48 89 c7             	mov    %rax,%rdi
  8021cb:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	callq  *%rax
  8021d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021dd:	48 63 d0             	movslq %eax,%rdx
  8021e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e4:	48 01 c2             	add    %rax,%rdx
  8021e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021eb:	48 89 c6             	mov    %rax,%rsi
  8021ee:	48 89 d7             	mov    %rdx,%rdi
  8021f1:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
	return dst;
  8021fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
  802207:	48 83 ec 28          	sub    $0x28,%rsp
  80220b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80220f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802213:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80221f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802226:	00 
  802227:	eb 2a                	jmp    802253 <strncpy+0x50>
		*dst++ = *src;
  802229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802231:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802235:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802239:	0f b6 12             	movzbl (%rdx),%edx
  80223c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80223e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802242:	0f b6 00             	movzbl (%rax),%eax
  802245:	84 c0                	test   %al,%al
  802247:	74 05                	je     80224e <strncpy+0x4b>
			src++;
  802249:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80224e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802257:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80225b:	72 cc                	jb     802229 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80225d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802261:	c9                   	leaveq 
  802262:	c3                   	retq   

0000000000802263 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802263:	55                   	push   %rbp
  802264:	48 89 e5             	mov    %rsp,%rbp
  802267:	48 83 ec 28          	sub    $0x28,%rsp
  80226b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80226f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802273:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80227f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802284:	74 3d                	je     8022c3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802286:	eb 1d                	jmp    8022a5 <strlcpy+0x42>
			*dst++ = *src++;
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802290:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802294:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802298:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80229c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8022a0:	0f b6 12             	movzbl (%rdx),%edx
  8022a3:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022a5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8022aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022af:	74 0b                	je     8022bc <strlcpy+0x59>
  8022b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b5:	0f b6 00             	movzbl (%rax),%eax
  8022b8:	84 c0                	test   %al,%al
  8022ba:	75 cc                	jne    802288 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cb:	48 29 c2             	sub    %rax,%rdx
  8022ce:	48 89 d0             	mov    %rdx,%rax
}
  8022d1:	c9                   	leaveq 
  8022d2:	c3                   	retq   

00000000008022d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022d3:	55                   	push   %rbp
  8022d4:	48 89 e5             	mov    %rsp,%rbp
  8022d7:	48 83 ec 10          	sub    $0x10,%rsp
  8022db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022e3:	eb 0a                	jmp    8022ef <strcmp+0x1c>
		p++, q++;
  8022e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f3:	0f b6 00             	movzbl (%rax),%eax
  8022f6:	84 c0                	test   %al,%al
  8022f8:	74 12                	je     80230c <strcmp+0x39>
  8022fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fe:	0f b6 10             	movzbl (%rax),%edx
  802301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802305:	0f b6 00             	movzbl (%rax),%eax
  802308:	38 c2                	cmp    %al,%dl
  80230a:	74 d9                	je     8022e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80230c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802310:	0f b6 00             	movzbl (%rax),%eax
  802313:	0f b6 d0             	movzbl %al,%edx
  802316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231a:	0f b6 00             	movzbl (%rax),%eax
  80231d:	0f b6 c0             	movzbl %al,%eax
  802320:	29 c2                	sub    %eax,%edx
  802322:	89 d0                	mov    %edx,%eax
}
  802324:	c9                   	leaveq 
  802325:	c3                   	retq   

0000000000802326 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802326:	55                   	push   %rbp
  802327:	48 89 e5             	mov    %rsp,%rbp
  80232a:	48 83 ec 18          	sub    $0x18,%rsp
  80232e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802332:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802336:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80233a:	eb 0f                	jmp    80234b <strncmp+0x25>
		n--, p++, q++;
  80233c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802346:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80234b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802350:	74 1d                	je     80236f <strncmp+0x49>
  802352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802356:	0f b6 00             	movzbl (%rax),%eax
  802359:	84 c0                	test   %al,%al
  80235b:	74 12                	je     80236f <strncmp+0x49>
  80235d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802361:	0f b6 10             	movzbl (%rax),%edx
  802364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802368:	0f b6 00             	movzbl (%rax),%eax
  80236b:	38 c2                	cmp    %al,%dl
  80236d:	74 cd                	je     80233c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80236f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802374:	75 07                	jne    80237d <strncmp+0x57>
		return 0;
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	eb 18                	jmp    802395 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80237d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802381:	0f b6 00             	movzbl (%rax),%eax
  802384:	0f b6 d0             	movzbl %al,%edx
  802387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238b:	0f b6 00             	movzbl (%rax),%eax
  80238e:	0f b6 c0             	movzbl %al,%eax
  802391:	29 c2                	sub    %eax,%edx
  802393:	89 d0                	mov    %edx,%eax
}
  802395:	c9                   	leaveq 
  802396:	c3                   	retq   

0000000000802397 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802397:	55                   	push   %rbp
  802398:	48 89 e5             	mov    %rsp,%rbp
  80239b:	48 83 ec 0c          	sub    $0xc,%rsp
  80239f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023a3:	89 f0                	mov    %esi,%eax
  8023a5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023a8:	eb 17                	jmp    8023c1 <strchr+0x2a>
		if (*s == c)
  8023aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ae:	0f b6 00             	movzbl (%rax),%eax
  8023b1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023b4:	75 06                	jne    8023bc <strchr+0x25>
			return (char *) s;
  8023b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ba:	eb 15                	jmp    8023d1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c5:	0f b6 00             	movzbl (%rax),%eax
  8023c8:	84 c0                	test   %al,%al
  8023ca:	75 de                	jne    8023aa <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d1:	c9                   	leaveq 
  8023d2:	c3                   	retq   

00000000008023d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
  8023d7:	48 83 ec 0c          	sub    $0xc,%rsp
  8023db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023e4:	eb 13                	jmp    8023f9 <strfind+0x26>
		if (*s == c)
  8023e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ea:	0f b6 00             	movzbl (%rax),%eax
  8023ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023f0:	75 02                	jne    8023f4 <strfind+0x21>
			break;
  8023f2:	eb 10                	jmp    802404 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fd:	0f b6 00             	movzbl (%rax),%eax
  802400:	84 c0                	test   %al,%al
  802402:	75 e2                	jne    8023e6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802408:	c9                   	leaveq 
  802409:	c3                   	retq   

000000000080240a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80240a:	55                   	push   %rbp
  80240b:	48 89 e5             	mov    %rsp,%rbp
  80240e:	48 83 ec 18          	sub    $0x18,%rsp
  802412:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802416:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802419:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80241d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802422:	75 06                	jne    80242a <memset+0x20>
		return v;
  802424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802428:	eb 69                	jmp    802493 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80242a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242e:	83 e0 03             	and    $0x3,%eax
  802431:	48 85 c0             	test   %rax,%rax
  802434:	75 48                	jne    80247e <memset+0x74>
  802436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243a:	83 e0 03             	and    $0x3,%eax
  80243d:	48 85 c0             	test   %rax,%rax
  802440:	75 3c                	jne    80247e <memset+0x74>
		c &= 0xFF;
  802442:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802449:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244c:	c1 e0 18             	shl    $0x18,%eax
  80244f:	89 c2                	mov    %eax,%edx
  802451:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802454:	c1 e0 10             	shl    $0x10,%eax
  802457:	09 c2                	or     %eax,%edx
  802459:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80245c:	c1 e0 08             	shl    $0x8,%eax
  80245f:	09 d0                	or     %edx,%eax
  802461:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802468:	48 c1 e8 02          	shr    $0x2,%rax
  80246c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80246f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802473:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802476:	48 89 d7             	mov    %rdx,%rdi
  802479:	fc                   	cld    
  80247a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80247c:	eb 11                	jmp    80248f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80247e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802482:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802485:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802489:	48 89 d7             	mov    %rdx,%rdi
  80248c:	fc                   	cld    
  80248d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80248f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802493:	c9                   	leaveq 
  802494:	c3                   	retq   

0000000000802495 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
  802499:	48 83 ec 28          	sub    $0x28,%rsp
  80249d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024c1:	0f 83 88 00 00 00    	jae    80254f <memmove+0xba>
  8024c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024cf:	48 01 d0             	add    %rdx,%rax
  8024d2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024d6:	76 77                	jbe    80254f <memmove+0xba>
		s += n;
  8024d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024dc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ec:	83 e0 03             	and    $0x3,%eax
  8024ef:	48 85 c0             	test   %rax,%rax
  8024f2:	75 3b                	jne    80252f <memmove+0x9a>
  8024f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f8:	83 e0 03             	and    $0x3,%eax
  8024fb:	48 85 c0             	test   %rax,%rax
  8024fe:	75 2f                	jne    80252f <memmove+0x9a>
  802500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802504:	83 e0 03             	and    $0x3,%eax
  802507:	48 85 c0             	test   %rax,%rax
  80250a:	75 23                	jne    80252f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80250c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802510:	48 83 e8 04          	sub    $0x4,%rax
  802514:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802518:	48 83 ea 04          	sub    $0x4,%rdx
  80251c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802520:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802524:	48 89 c7             	mov    %rax,%rdi
  802527:	48 89 d6             	mov    %rdx,%rsi
  80252a:	fd                   	std    
  80252b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80252d:	eb 1d                	jmp    80254c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80252f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802533:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802537:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80253f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802543:	48 89 d7             	mov    %rdx,%rdi
  802546:	48 89 c1             	mov    %rax,%rcx
  802549:	fd                   	std    
  80254a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80254c:	fc                   	cld    
  80254d:	eb 57                	jmp    8025a6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80254f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802553:	83 e0 03             	and    $0x3,%eax
  802556:	48 85 c0             	test   %rax,%rax
  802559:	75 36                	jne    802591 <memmove+0xfc>
  80255b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255f:	83 e0 03             	and    $0x3,%eax
  802562:	48 85 c0             	test   %rax,%rax
  802565:	75 2a                	jne    802591 <memmove+0xfc>
  802567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80256b:	83 e0 03             	and    $0x3,%eax
  80256e:	48 85 c0             	test   %rax,%rax
  802571:	75 1e                	jne    802591 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802577:	48 c1 e8 02          	shr    $0x2,%rax
  80257b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80257e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802582:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802586:	48 89 c7             	mov    %rax,%rdi
  802589:	48 89 d6             	mov    %rdx,%rsi
  80258c:	fc                   	cld    
  80258d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80258f:	eb 15                	jmp    8025a6 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802599:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80259d:	48 89 c7             	mov    %rax,%rdi
  8025a0:	48 89 d6             	mov    %rdx,%rsi
  8025a3:	fc                   	cld    
  8025a4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8025a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025aa:	c9                   	leaveq 
  8025ab:	c3                   	retq   

00000000008025ac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025ac:	55                   	push   %rbp
  8025ad:	48 89 e5             	mov    %rsp,%rbp
  8025b0:	48 83 ec 18          	sub    $0x18,%rsp
  8025b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025c4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025cc:	48 89 ce             	mov    %rcx,%rsi
  8025cf:	48 89 c7             	mov    %rax,%rdi
  8025d2:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
}
  8025de:	c9                   	leaveq 
  8025df:	c3                   	retq   

00000000008025e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025e0:	55                   	push   %rbp
  8025e1:	48 89 e5             	mov    %rsp,%rbp
  8025e4:	48 83 ec 28          	sub    $0x28,%rsp
  8025e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8025f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8025fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802600:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802604:	eb 36                	jmp    80263c <memcmp+0x5c>
		if (*s1 != *s2)
  802606:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260a:	0f b6 10             	movzbl (%rax),%edx
  80260d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802611:	0f b6 00             	movzbl (%rax),%eax
  802614:	38 c2                	cmp    %al,%dl
  802616:	74 1a                	je     802632 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261c:	0f b6 00             	movzbl (%rax),%eax
  80261f:	0f b6 d0             	movzbl %al,%edx
  802622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802626:	0f b6 00             	movzbl (%rax),%eax
  802629:	0f b6 c0             	movzbl %al,%eax
  80262c:	29 c2                	sub    %eax,%edx
  80262e:	89 d0                	mov    %edx,%eax
  802630:	eb 20                	jmp    802652 <memcmp+0x72>
		s1++, s2++;
  802632:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802637:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80263c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802640:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802644:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802648:	48 85 c0             	test   %rax,%rax
  80264b:	75 b9                	jne    802606 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802652:	c9                   	leaveq 
  802653:	c3                   	retq   

0000000000802654 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 28          	sub    $0x28,%rsp
  80265c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802660:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802663:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80266f:	48 01 d0             	add    %rdx,%rax
  802672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802676:	eb 15                	jmp    80268d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267c:	0f b6 10             	movzbl (%rax),%edx
  80267f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802682:	38 c2                	cmp    %al,%dl
  802684:	75 02                	jne    802688 <memfind+0x34>
			break;
  802686:	eb 0f                	jmp    802697 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802688:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80268d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802691:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802695:	72 e1                	jb     802678 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80269b:	c9                   	leaveq 
  80269c:	c3                   	retq   

000000000080269d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
  8026a1:	48 83 ec 34          	sub    $0x34,%rsp
  8026a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026ad:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026b7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026be:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026bf:	eb 05                	jmp    8026c6 <strtol+0x29>
		s++;
  8026c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ca:	0f b6 00             	movzbl (%rax),%eax
  8026cd:	3c 20                	cmp    $0x20,%al
  8026cf:	74 f0                	je     8026c1 <strtol+0x24>
  8026d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d5:	0f b6 00             	movzbl (%rax),%eax
  8026d8:	3c 09                	cmp    $0x9,%al
  8026da:	74 e5                	je     8026c1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e0:	0f b6 00             	movzbl (%rax),%eax
  8026e3:	3c 2b                	cmp    $0x2b,%al
  8026e5:	75 07                	jne    8026ee <strtol+0x51>
		s++;
  8026e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026ec:	eb 17                	jmp    802705 <strtol+0x68>
	else if (*s == '-')
  8026ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f2:	0f b6 00             	movzbl (%rax),%eax
  8026f5:	3c 2d                	cmp    $0x2d,%al
  8026f7:	75 0c                	jne    802705 <strtol+0x68>
		s++, neg = 1;
  8026f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802705:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802709:	74 06                	je     802711 <strtol+0x74>
  80270b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80270f:	75 28                	jne    802739 <strtol+0x9c>
  802711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802715:	0f b6 00             	movzbl (%rax),%eax
  802718:	3c 30                	cmp    $0x30,%al
  80271a:	75 1d                	jne    802739 <strtol+0x9c>
  80271c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802720:	48 83 c0 01          	add    $0x1,%rax
  802724:	0f b6 00             	movzbl (%rax),%eax
  802727:	3c 78                	cmp    $0x78,%al
  802729:	75 0e                	jne    802739 <strtol+0x9c>
		s += 2, base = 16;
  80272b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802730:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802737:	eb 2c                	jmp    802765 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802739:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80273d:	75 19                	jne    802758 <strtol+0xbb>
  80273f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802743:	0f b6 00             	movzbl (%rax),%eax
  802746:	3c 30                	cmp    $0x30,%al
  802748:	75 0e                	jne    802758 <strtol+0xbb>
		s++, base = 8;
  80274a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80274f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802756:	eb 0d                	jmp    802765 <strtol+0xc8>
	else if (base == 0)
  802758:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80275c:	75 07                	jne    802765 <strtol+0xc8>
		base = 10;
  80275e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802769:	0f b6 00             	movzbl (%rax),%eax
  80276c:	3c 2f                	cmp    $0x2f,%al
  80276e:	7e 1d                	jle    80278d <strtol+0xf0>
  802770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802774:	0f b6 00             	movzbl (%rax),%eax
  802777:	3c 39                	cmp    $0x39,%al
  802779:	7f 12                	jg     80278d <strtol+0xf0>
			dig = *s - '0';
  80277b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277f:	0f b6 00             	movzbl (%rax),%eax
  802782:	0f be c0             	movsbl %al,%eax
  802785:	83 e8 30             	sub    $0x30,%eax
  802788:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80278b:	eb 4e                	jmp    8027db <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80278d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802791:	0f b6 00             	movzbl (%rax),%eax
  802794:	3c 60                	cmp    $0x60,%al
  802796:	7e 1d                	jle    8027b5 <strtol+0x118>
  802798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279c:	0f b6 00             	movzbl (%rax),%eax
  80279f:	3c 7a                	cmp    $0x7a,%al
  8027a1:	7f 12                	jg     8027b5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8027a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a7:	0f b6 00             	movzbl (%rax),%eax
  8027aa:	0f be c0             	movsbl %al,%eax
  8027ad:	83 e8 57             	sub    $0x57,%eax
  8027b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027b3:	eb 26                	jmp    8027db <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b9:	0f b6 00             	movzbl (%rax),%eax
  8027bc:	3c 40                	cmp    $0x40,%al
  8027be:	7e 48                	jle    802808 <strtol+0x16b>
  8027c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c4:	0f b6 00             	movzbl (%rax),%eax
  8027c7:	3c 5a                	cmp    $0x5a,%al
  8027c9:	7f 3d                	jg     802808 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8027cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027cf:	0f b6 00             	movzbl (%rax),%eax
  8027d2:	0f be c0             	movsbl %al,%eax
  8027d5:	83 e8 37             	sub    $0x37,%eax
  8027d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027de:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027e1:	7c 02                	jl     8027e5 <strtol+0x148>
			break;
  8027e3:	eb 23                	jmp    802808 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8027e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ed:	48 98                	cltq   
  8027ef:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8027f4:	48 89 c2             	mov    %rax,%rdx
  8027f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027fa:	48 98                	cltq   
  8027fc:	48 01 d0             	add    %rdx,%rax
  8027ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802803:	e9 5d ff ff ff       	jmpq   802765 <strtol+0xc8>

	if (endptr)
  802808:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80280d:	74 0b                	je     80281a <strtol+0x17d>
		*endptr = (char *) s;
  80280f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802813:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802817:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80281a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281e:	74 09                	je     802829 <strtol+0x18c>
  802820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802824:	48 f7 d8             	neg    %rax
  802827:	eb 04                	jmp    80282d <strtol+0x190>
  802829:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80282d:	c9                   	leaveq 
  80282e:	c3                   	retq   

000000000080282f <strstr>:

char * strstr(const char *in, const char *str)
{
  80282f:	55                   	push   %rbp
  802830:	48 89 e5             	mov    %rsp,%rbp
  802833:	48 83 ec 30          	sub    $0x30,%rsp
  802837:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80283b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80283f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802843:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802847:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80284b:	0f b6 00             	movzbl (%rax),%eax
  80284e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802851:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802855:	75 06                	jne    80285d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285b:	eb 6b                	jmp    8028c8 <strstr+0x99>

	len = strlen(str);
  80285d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802861:	48 89 c7             	mov    %rax,%rdi
  802864:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
  802870:	48 98                	cltq   
  802872:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80287e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802882:	0f b6 00             	movzbl (%rax),%eax
  802885:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802888:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80288c:	75 07                	jne    802895 <strstr+0x66>
				return (char *) 0;
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	eb 33                	jmp    8028c8 <strstr+0x99>
		} while (sc != c);
  802895:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802899:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80289c:	75 d8                	jne    802876 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80289e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028aa:	48 89 ce             	mov    %rcx,%rsi
  8028ad:	48 89 c7             	mov    %rax,%rdi
  8028b0:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	callq  *%rax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	75 b6                	jne    802876 <strstr+0x47>

	return (char *) (in - 1);
  8028c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c4:	48 83 e8 01          	sub    $0x1,%rax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	53                   	push   %rbx
  8028cf:	48 83 ec 48          	sub    $0x48,%rsp
  8028d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028dd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028e1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028e5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8028e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028f0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8028f4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8028f8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8028fc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802900:	4c 89 c3             	mov    %r8,%rbx
  802903:	cd 30                	int    $0x30
  802905:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  802909:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80290d:	74 3e                	je     80294d <syscall+0x83>
  80290f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802914:	7e 37                	jle    80294d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802916:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80291a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80291d:	49 89 d0             	mov    %rdx,%r8
  802920:	89 c1                	mov    %eax,%ecx
  802922:	48 ba db 64 80 00 00 	movabs $0x8064db,%rdx
  802929:	00 00 00 
  80292c:	be 4a 00 00 00       	mov    $0x4a,%esi
  802931:	48 bf f8 64 80 00 00 	movabs $0x8064f8,%rdi
  802938:	00 00 00 
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
  802940:	49 b9 29 12 80 00 00 	movabs $0x801229,%r9
  802947:	00 00 00 
  80294a:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  80294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802951:	48 83 c4 48          	add    $0x48,%rsp
  802955:	5b                   	pop    %rbx
  802956:	5d                   	pop    %rbp
  802957:	c3                   	retq   

0000000000802958 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802958:	55                   	push   %rbp
  802959:	48 89 e5             	mov    %rsp,%rbp
  80295c:	48 83 ec 20          	sub    $0x20,%rsp
  802960:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802964:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802968:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80296c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802970:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802977:	00 
  802978:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80297e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802984:	48 89 d1             	mov    %rdx,%rcx
  802987:	48 89 c2             	mov    %rax,%rdx
  80298a:	be 00 00 00 00       	mov    $0x0,%esi
  80298f:	bf 00 00 00 00       	mov    $0x0,%edi
  802994:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
}
  8029a0:	c9                   	leaveq 
  8029a1:	c3                   	retq   

00000000008029a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029b1:	00 
  8029b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c8:	be 00 00 00 00       	mov    $0x0,%esi
  8029cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8029d2:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
  8029e4:	48 83 ec 10          	sub    $0x10,%rsp
  8029e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ee:	48 98                	cltq   
  8029f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029f7:	00 
  8029f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a04:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a09:	48 89 c2             	mov    %rax,%rdx
  802a0c:	be 01 00 00 00       	mov    $0x1,%esi
  802a11:	bf 03 00 00 00       	mov    $0x3,%edi
  802a16:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802a1d:	00 00 00 
  802a20:	ff d0                	callq  *%rax
}
  802a22:	c9                   	leaveq 
  802a23:	c3                   	retq   

0000000000802a24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a24:	55                   	push   %rbp
  802a25:	48 89 e5             	mov    %rsp,%rbp
  802a28:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a33:	00 
  802a34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a40:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a45:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4a:	be 00 00 00 00       	mov    $0x0,%esi
  802a4f:	bf 02 00 00 00       	mov    $0x2,%edi
  802a54:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
}
  802a60:	c9                   	leaveq 
  802a61:	c3                   	retq   

0000000000802a62 <sys_yield>:

void
sys_yield(void)
{
  802a62:	55                   	push   %rbp
  802a63:	48 89 e5             	mov    %rsp,%rbp
  802a66:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a71:	00 
  802a72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a83:	ba 00 00 00 00       	mov    $0x0,%edx
  802a88:	be 00 00 00 00       	mov    $0x0,%esi
  802a8d:	bf 0b 00 00 00       	mov    $0xb,%edi
  802a92:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802a99:	00 00 00 
  802a9c:	ff d0                	callq  *%rax
}
  802a9e:	c9                   	leaveq 
  802a9f:	c3                   	retq   

0000000000802aa0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802aa0:	55                   	push   %rbp
  802aa1:	48 89 e5             	mov    %rsp,%rbp
  802aa4:	48 83 ec 20          	sub    $0x20,%rsp
  802aa8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802aaf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802ab2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab5:	48 63 c8             	movslq %eax,%rcx
  802ab8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abf:	48 98                	cltq   
  802ac1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ac8:	00 
  802ac9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802acf:	49 89 c8             	mov    %rcx,%r8
  802ad2:	48 89 d1             	mov    %rdx,%rcx
  802ad5:	48 89 c2             	mov    %rax,%rdx
  802ad8:	be 01 00 00 00       	mov    $0x1,%esi
  802add:	bf 04 00 00 00       	mov    $0x4,%edi
  802ae2:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
}
  802aee:	c9                   	leaveq 
  802aef:	c3                   	retq   

0000000000802af0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802af0:	55                   	push   %rbp
  802af1:	48 89 e5             	mov    %rsp,%rbp
  802af4:	48 83 ec 30          	sub    $0x30,%rsp
  802af8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802afb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802aff:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802b02:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b06:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b0a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b0d:	48 63 c8             	movslq %eax,%rcx
  802b10:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b17:	48 63 f0             	movslq %eax,%rsi
  802b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b21:	48 98                	cltq   
  802b23:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b27:	49 89 f9             	mov    %rdi,%r9
  802b2a:	49 89 f0             	mov    %rsi,%r8
  802b2d:	48 89 d1             	mov    %rdx,%rcx
  802b30:	48 89 c2             	mov    %rax,%rdx
  802b33:	be 01 00 00 00       	mov    $0x1,%esi
  802b38:	bf 05 00 00 00       	mov    $0x5,%edi
  802b3d:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
}
  802b49:	c9                   	leaveq 
  802b4a:	c3                   	retq   

0000000000802b4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b4b:	55                   	push   %rbp
  802b4c:	48 89 e5             	mov    %rsp,%rbp
  802b4f:	48 83 ec 20          	sub    $0x20,%rsp
  802b53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	48 98                	cltq   
  802b63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b6a:	00 
  802b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b77:	48 89 d1             	mov    %rdx,%rcx
  802b7a:	48 89 c2             	mov    %rax,%rdx
  802b7d:	be 01 00 00 00       	mov    $0x1,%esi
  802b82:	bf 06 00 00 00       	mov    $0x6,%edi
  802b87:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	callq  *%rax
}
  802b93:	c9                   	leaveq 
  802b94:	c3                   	retq   

0000000000802b95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b95:	55                   	push   %rbp
  802b96:	48 89 e5             	mov    %rsp,%rbp
  802b99:	48 83 ec 10          	sub    $0x10,%rsp
  802b9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ba0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802ba3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba6:	48 63 d0             	movslq %eax,%rdx
  802ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bac:	48 98                	cltq   
  802bae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bb5:	00 
  802bb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bc2:	48 89 d1             	mov    %rdx,%rcx
  802bc5:	48 89 c2             	mov    %rax,%rdx
  802bc8:	be 01 00 00 00       	mov    $0x1,%esi
  802bcd:	bf 08 00 00 00       	mov    $0x8,%edi
  802bd2:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	callq  *%rax
}
  802bde:	c9                   	leaveq 
  802bdf:	c3                   	retq   

0000000000802be0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802be0:	55                   	push   %rbp
  802be1:	48 89 e5             	mov    %rsp,%rbp
  802be4:	48 83 ec 20          	sub    $0x20,%rsp
  802be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf6:	48 98                	cltq   
  802bf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bff:	00 
  802c00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c0c:	48 89 d1             	mov    %rdx,%rcx
  802c0f:	48 89 c2             	mov    %rax,%rdx
  802c12:	be 01 00 00 00       	mov    $0x1,%esi
  802c17:	bf 09 00 00 00       	mov    $0x9,%edi
  802c1c:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802c23:	00 00 00 
  802c26:	ff d0                	callq  *%rax
}
  802c28:	c9                   	leaveq 
  802c29:	c3                   	retq   

0000000000802c2a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c2a:	55                   	push   %rbp
  802c2b:	48 89 e5             	mov    %rsp,%rbp
  802c2e:	48 83 ec 20          	sub    $0x20,%rsp
  802c32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c40:	48 98                	cltq   
  802c42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c49:	00 
  802c4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c56:	48 89 d1             	mov    %rdx,%rcx
  802c59:	48 89 c2             	mov    %rax,%rdx
  802c5c:	be 01 00 00 00       	mov    $0x1,%esi
  802c61:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c66:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
}
  802c72:	c9                   	leaveq 
  802c73:	c3                   	retq   

0000000000802c74 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c74:	55                   	push   %rbp
  802c75:	48 89 e5             	mov    %rsp,%rbp
  802c78:	48 83 ec 20          	sub    $0x20,%rsp
  802c7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c83:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c87:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8d:	48 63 f0             	movslq %eax,%rsi
  802c90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c97:	48 98                	cltq   
  802c99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ca4:	00 
  802ca5:	49 89 f1             	mov    %rsi,%r9
  802ca8:	49 89 c8             	mov    %rcx,%r8
  802cab:	48 89 d1             	mov    %rdx,%rcx
  802cae:	48 89 c2             	mov    %rax,%rdx
  802cb1:	be 00 00 00 00       	mov    $0x0,%esi
  802cb6:	bf 0c 00 00 00       	mov    $0xc,%edi
  802cbb:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 83 ec 10          	sub    $0x10,%rsp
  802cd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ce0:	00 
  802ce1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ce7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ced:	b9 00 00 00 00       	mov    $0x0,%ecx
  802cf2:	48 89 c2             	mov    %rax,%rdx
  802cf5:	be 01 00 00 00       	mov    $0x1,%esi
  802cfa:	bf 0d 00 00 00       	mov    $0xd,%edi
  802cff:	48 b8 ca 28 80 00 00 	movabs $0x8028ca,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
}
  802d0b:	c9                   	leaveq 
  802d0c:	c3                   	retq   

0000000000802d0d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802d0d:	55                   	push   %rbp
  802d0e:	48 89 e5             	mov    %rsp,%rbp
  802d11:	53                   	push   %rbx
  802d12:	48 83 ec 48          	sub    $0x48,%rsp
  802d16:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802d1a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802d1e:	48 8b 00             	mov    (%rax),%rax
  802d21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  802d25:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  802d29:	48 8b 40 08          	mov    0x8(%rax),%rax
  802d2d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  802d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d34:	48 c1 e8 0c          	shr    $0xc,%rax
  802d38:	48 89 c2             	mov    %rax,%rdx
  802d3b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d42:	01 00 00 
  802d45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d49:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  802d4d:	48 b8 24 2a 80 00 00 	movabs $0x802a24,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  802d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d60:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802d64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d68:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802d6e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  802d72:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d75:	83 e0 02             	and    $0x2,%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	0f 84 8d 00 00 00    	je     802e0d <pgfault+0x100>
  802d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d84:	25 00 08 00 00       	and    $0x800,%eax
  802d89:	48 85 c0             	test   %rax,%rax
  802d8c:	74 7f                	je     802e0d <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  802d8e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d91:	ba 07 00 00 00       	mov    $0x7,%edx
  802d96:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802d9b:	89 c7                	mov    %eax,%edi
  802d9d:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	75 60                	jne    802e0d <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  802dad:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802db1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802db6:	48 89 c6             	mov    %rax,%rsi
  802db9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802dbe:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  802dca:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802dce:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802dd1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dd4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802dda:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
  802ded:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  802def:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802df2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802df7:	89 c7                	mov    %eax,%edi
  802df9:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  802e05:	09 d8                	or     %ebx,%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	75 02                	jne    802e0d <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  802e0b:	eb 2a                	jmp    802e37 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  802e0d:	48 ba 06 65 80 00 00 	movabs $0x806506,%rdx
  802e14:	00 00 00 
  802e17:	be 26 00 00 00       	mov    $0x26,%esi
  802e1c:	48 bf 22 65 80 00 00 	movabs $0x806522,%rdi
  802e23:	00 00 00 
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2b:	48 b9 29 12 80 00 00 	movabs $0x801229,%rcx
  802e32:	00 00 00 
  802e35:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  802e37:	48 83 c4 48          	add    $0x48,%rsp
  802e3b:	5b                   	pop    %rbx
  802e3c:	5d                   	pop    %rbp
  802e3d:	c3                   	retq   

0000000000802e3e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802e3e:	55                   	push   %rbp
  802e3f:	48 89 e5             	mov    %rsp,%rbp
  802e42:	53                   	push   %rbx
  802e43:	48 83 ec 38          	sub    $0x38,%rsp
  802e47:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e4a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  802e4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e54:	01 00 00 
  802e57:	8b 55 c8             	mov    -0x38(%rbp),%edx
  802e5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e5e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  802e62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e66:	25 07 0e 00 00       	and    $0xe07,%eax
  802e6b:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  802e6e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e71:	48 c1 e0 0c          	shl    $0xc,%rax
  802e75:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  802e79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e7c:	25 00 04 00 00       	and    $0x400,%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 30                	je     802eb5 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  802e85:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802e88:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e8c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802e8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e93:	41 89 f0             	mov    %esi,%r8d
  802e96:	48 89 c6             	mov    %rax,%rsi
  802e99:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9e:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
  802eaa:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  802ead:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eb0:	e9 a4 00 00 00       	jmpq   802f59 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  802eb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eb8:	83 e0 02             	and    $0x2,%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	75 0c                	jne    802ecb <duppage+0x8d>
  802ebf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ec2:	25 00 08 00 00       	and    $0x800,%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 63                	je     802f2e <duppage+0xf0>
		perm &= ~PTE_W;
  802ecb:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  802ecf:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  802ed6:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802ed9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802edd:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802ee0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ee4:	41 89 f0             	mov    %esi,%r8d
  802ee7:	48 89 c6             	mov    %rax,%rsi
  802eea:	bf 00 00 00 00       	mov    $0x0,%edi
  802eef:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 c3                	mov    %eax,%ebx
  802efd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802f00:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f08:	41 89 c8             	mov    %ecx,%r8d
  802f0b:	48 89 d1             	mov    %rdx,%rcx
  802f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f13:	48 89 c6             	mov    %rax,%rsi
  802f16:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1b:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	callq  *%rax
  802f27:	09 d8                	or     %ebx,%eax
  802f29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f2c:	eb 28                	jmp    802f56 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  802f2e:	8b 75 dc             	mov    -0x24(%rbp),%esi
  802f31:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f35:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802f38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f3c:	41 89 f0             	mov    %esi,%r8d
  802f3f:	48 89 c6             	mov    %rax,%rsi
  802f42:	bf 00 00 00 00       	mov    $0x0,%edi
  802f47:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
  802f53:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  802f56:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802f59:	48 83 c4 38          	add    $0x38,%rsp
  802f5d:	5b                   	pop    %rbx
  802f5e:	5d                   	pop    %rbp
  802f5f:	c3                   	retq   

0000000000802f60 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  802f60:	55                   	push   %rbp
  802f61:	48 89 e5             	mov    %rsp,%rbp
  802f64:	53                   	push   %rbx
  802f65:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  802f69:	48 bf 0d 2d 80 00 00 	movabs $0x802d0d,%rdi
  802f70:	00 00 00 
  802f73:	48 b8 ea 59 80 00 00 	movabs $0x8059ea,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802f7f:	b8 07 00 00 00       	mov    $0x7,%eax
  802f84:	cd 30                	int    $0x30
  802f86:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802f89:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  802f8c:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  802f8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802f93:	79 30                	jns    802fc5 <fork+0x65>
  802f95:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802f98:	89 c1                	mov    %eax,%ecx
  802f9a:	48 ba 2d 65 80 00 00 	movabs $0x80652d,%rdx
  802fa1:	00 00 00 
  802fa4:	be 72 00 00 00       	mov    $0x72,%esi
  802fa9:	48 bf 22 65 80 00 00 	movabs $0x806522,%rdi
  802fb0:	00 00 00 
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  802fbf:	00 00 00 
  802fc2:	41 ff d0             	callq  *%r8
	if(cid == 0){
  802fc5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fc9:	75 46                	jne    803011 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  802fcb:	48 b8 24 2a 80 00 00 	movabs $0x802a24,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	25 ff 03 00 00       	and    $0x3ff,%eax
  802fdc:	48 63 d0             	movslq %eax,%rdx
  802fdf:	48 89 d0             	mov    %rdx,%rax
  802fe2:	48 c1 e0 03          	shl    $0x3,%rax
  802fe6:	48 01 d0             	add    %rdx,%rax
  802fe9:	48 c1 e0 05          	shl    $0x5,%rax
  802fed:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802ff4:	00 00 00 
  802ff7:	48 01 c2             	add    %rax,%rdx
  802ffa:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803001:	00 00 00 
  803004:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  803007:	b8 00 00 00 00       	mov    $0x0,%eax
  80300c:	e9 12 02 00 00       	jmpq   803223 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803011:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803014:	ba 07 00 00 00       	mov    $0x7,%edx
  803019:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80301e:	89 c7                	mov    %eax,%edi
  803020:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
  80302c:	89 45 c8             	mov    %eax,-0x38(%rbp)
  80302f:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  803033:	79 30                	jns    803065 <fork+0x105>
		panic("fork failed: %e\n", result);
  803035:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803038:	89 c1                	mov    %eax,%ecx
  80303a:	48 ba 2d 65 80 00 00 	movabs $0x80652d,%rdx
  803041:	00 00 00 
  803044:	be 79 00 00 00       	mov    $0x79,%esi
  803049:	48 bf 22 65 80 00 00 	movabs $0x806522,%rdi
  803050:	00 00 00 
  803053:	b8 00 00 00 00       	mov    $0x0,%eax
  803058:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  80305f:	00 00 00 
  803062:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803065:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80306c:	00 
  80306d:	e9 40 01 00 00       	jmpq   8031b2 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  803072:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803079:	01 00 00 
  80307c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803080:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803084:	83 e0 01             	and    $0x1,%eax
  803087:	48 85 c0             	test   %rax,%rax
  80308a:	0f 84 1d 01 00 00    	je     8031ad <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  803090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803094:	48 c1 e0 09          	shl    $0x9,%rax
  803098:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80309c:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8030a3:	00 
  8030a4:	e9 f6 00 00 00       	jmpq   80319f <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8030b1:	48 01 c2             	add    %rax,%rdx
  8030b4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8030bb:	01 00 00 
  8030be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030c2:	83 e0 01             	and    $0x1,%eax
  8030c5:	48 85 c0             	test   %rax,%rax
  8030c8:	0f 84 cc 00 00 00    	je     80319a <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  8030ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8030d6:	48 01 d0             	add    %rdx,%rax
  8030d9:	48 c1 e0 09          	shl    $0x9,%rax
  8030dd:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  8030e1:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8030e8:	00 
  8030e9:	e9 9e 00 00 00       	jmpq   80318c <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  8030ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8030f6:	48 01 c2             	add    %rax,%rdx
  8030f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803100:	01 00 00 
  803103:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803107:	83 e0 01             	and    $0x1,%eax
  80310a:	48 85 c0             	test   %rax,%rax
  80310d:	74 78                	je     803187 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  80310f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803113:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803117:	48 01 d0             	add    %rdx,%rax
  80311a:	48 c1 e0 09          	shl    $0x9,%rax
  80311e:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  803122:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803129:	00 
  80312a:	eb 51                	jmp    80317d <fork+0x21d>
								entry = base_pde + pte;
  80312c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803130:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803134:	48 01 d0             	add    %rdx,%rax
  803137:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  80313b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803142:	01 00 00 
  803145:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803149:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80314d:	83 e0 01             	and    $0x1,%eax
  803150:	48 85 c0             	test   %rax,%rax
  803153:	74 23                	je     803178 <fork+0x218>
  803155:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  80315c:	00 
  80315d:	74 19                	je     803178 <fork+0x218>
									duppage(cid, entry);
  80315f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803163:	89 c2                	mov    %eax,%edx
  803165:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803168:	89 d6                	mov    %edx,%esi
  80316a:	89 c7                	mov    %eax,%edi
  80316c:	48 b8 3e 2e 80 00 00 	movabs $0x802e3e,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  803178:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  80317d:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  803184:	00 
  803185:	76 a5                	jbe    80312c <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  803187:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80318c:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  803193:	00 
  803194:	0f 86 54 ff ff ff    	jbe    8030ee <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80319a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80319f:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8031a6:	00 
  8031a7:	0f 86 fc fe ff ff    	jbe    8030a9 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8031ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8031b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031b7:	0f 84 b5 fe ff ff    	je     803072 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  8031bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031c0:	48 be 7f 5a 80 00 00 	movabs $0x805a7f,%rsi
  8031c7:	00 00 00 
  8031ca:	89 c7                	mov    %eax,%edi
  8031cc:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
  8031d8:	89 c3                	mov    %eax,%ebx
  8031da:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031dd:	be 02 00 00 00       	mov    $0x2,%esi
  8031e2:	89 c7                	mov    %eax,%edi
  8031e4:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
  8031f0:	09 d8                	or     %ebx,%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	74 2a                	je     803220 <fork+0x2c0>
		panic("fork failed\n");
  8031f6:	48 ba 3e 65 80 00 00 	movabs $0x80653e,%rdx
  8031fd:	00 00 00 
  803200:	be 92 00 00 00       	mov    $0x92,%esi
  803205:	48 bf 22 65 80 00 00 	movabs $0x806522,%rdi
  80320c:	00 00 00 
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	48 b9 29 12 80 00 00 	movabs $0x801229,%rcx
  80321b:	00 00 00 
  80321e:	ff d1                	callq  *%rcx
	return cid;
  803220:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  803223:	48 83 c4 58          	add    $0x58,%rsp
  803227:	5b                   	pop    %rbx
  803228:	5d                   	pop    %rbp
  803229:	c3                   	retq   

000000000080322a <sfork>:


// Challenge!
int
sfork(void)
{
  80322a:	55                   	push   %rbp
  80322b:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80322e:	48 ba 4b 65 80 00 00 	movabs $0x80654b,%rdx
  803235:	00 00 00 
  803238:	be 9c 00 00 00       	mov    $0x9c,%esi
  80323d:	48 bf 22 65 80 00 00 	movabs $0x806522,%rdi
  803244:	00 00 00 
  803247:	b8 00 00 00 00       	mov    $0x0,%eax
  80324c:	48 b9 29 12 80 00 00 	movabs $0x801229,%rcx
  803253:	00 00 00 
  803256:	ff d1                	callq  *%rcx

0000000000803258 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  803258:	55                   	push   %rbp
  803259:	48 89 e5             	mov    %rsp,%rbp
  80325c:	48 83 ec 18          	sub    $0x18,%rsp
  803260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803264:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803268:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  80326c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803270:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803274:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  803277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80327f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803287:	8b 00                	mov    (%rax),%eax
  803289:	83 f8 01             	cmp    $0x1,%eax
  80328c:	7e 13                	jle    8032a1 <argstart+0x49>
  80328e:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  803293:	74 0c                	je     8032a1 <argstart+0x49>
  803295:	48 b8 61 65 80 00 00 	movabs $0x806561,%rax
  80329c:	00 00 00 
  80329f:	eb 05                	jmp    8032a6 <argstart+0x4e>
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032aa:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8032ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b2:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8032b9:	00 
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <argnext>:

int
argnext(struct Argstate *args)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 20          	sub    $0x20,%rsp
  8032c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8032c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cc:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8032d3:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8032d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8032dc:	48 85 c0             	test   %rax,%rax
  8032df:	75 0a                	jne    8032eb <argnext+0x2f>
		return -1;
  8032e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8032e6:	e9 25 01 00 00       	jmpq   803410 <argnext+0x154>

	if (!*args->curarg) {
  8032eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032ef:	48 8b 40 10          	mov    0x10(%rax),%rax
  8032f3:	0f b6 00             	movzbl (%rax),%eax
  8032f6:	84 c0                	test   %al,%al
  8032f8:	0f 85 d7 00 00 00    	jne    8033d5 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8032fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803302:	48 8b 00             	mov    (%rax),%rax
  803305:	8b 00                	mov    (%rax),%eax
  803307:	83 f8 01             	cmp    $0x1,%eax
  80330a:	0f 84 ef 00 00 00    	je     8033ff <argnext+0x143>
		    || args->argv[1][0] != '-'
  803310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803314:	48 8b 40 08          	mov    0x8(%rax),%rax
  803318:	48 83 c0 08          	add    $0x8,%rax
  80331c:	48 8b 00             	mov    (%rax),%rax
  80331f:	0f b6 00             	movzbl (%rax),%eax
  803322:	3c 2d                	cmp    $0x2d,%al
  803324:	0f 85 d5 00 00 00    	jne    8033ff <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80332a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803332:	48 83 c0 08          	add    $0x8,%rax
  803336:	48 8b 00             	mov    (%rax),%rax
  803339:	48 83 c0 01          	add    $0x1,%rax
  80333d:	0f b6 00             	movzbl (%rax),%eax
  803340:	84 c0                	test   %al,%al
  803342:	0f 84 b7 00 00 00    	je     8033ff <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803350:	48 83 c0 08          	add    $0x8,%rax
  803354:	48 8b 00             	mov    (%rax),%rax
  803357:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80335b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335f:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803367:	48 8b 00             	mov    (%rax),%rax
  80336a:	8b 00                	mov    (%rax),%eax
  80336c:	83 e8 01             	sub    $0x1,%eax
  80336f:	48 98                	cltq   
  803371:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803378:	00 
  803379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337d:	48 8b 40 08          	mov    0x8(%rax),%rax
  803381:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803389:	48 8b 40 08          	mov    0x8(%rax),%rax
  80338d:	48 83 c0 08          	add    $0x8,%rax
  803391:	48 89 ce             	mov    %rcx,%rsi
  803394:	48 89 c7             	mov    %rax,%rdi
  803397:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
		(*args->argc)--;
  8033a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a7:	48 8b 00             	mov    (%rax),%rax
  8033aa:	8b 10                	mov    (%rax),%edx
  8033ac:	83 ea 01             	sub    $0x1,%edx
  8033af:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8033b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033b9:	0f b6 00             	movzbl (%rax),%eax
  8033bc:	3c 2d                	cmp    $0x2d,%al
  8033be:	75 15                	jne    8033d5 <argnext+0x119>
  8033c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033c8:	48 83 c0 01          	add    $0x1,%rax
  8033cc:	0f b6 00             	movzbl (%rax),%eax
  8033cf:	84 c0                	test   %al,%al
  8033d1:	75 02                	jne    8033d5 <argnext+0x119>
			goto endofargs;
  8033d3:	eb 2a                	jmp    8033ff <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8033d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033dd:	0f b6 00             	movzbl (%rax),%eax
  8033e0:	0f b6 c0             	movzbl %al,%eax
  8033e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8033e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8033f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8033fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fd:	eb 11                	jmp    803410 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8033ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803403:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80340a:	00 
	return -1;
  80340b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803410:	c9                   	leaveq 
  803411:	c3                   	retq   

0000000000803412 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803412:	55                   	push   %rbp
  803413:	48 89 e5             	mov    %rsp,%rbp
  803416:	48 83 ec 10          	sub    $0x10,%rsp
  80341a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80341e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803422:	48 8b 40 18          	mov    0x18(%rax),%rax
  803426:	48 85 c0             	test   %rax,%rax
  803429:	74 0a                	je     803435 <argvalue+0x23>
  80342b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803433:	eb 13                	jmp    803448 <argvalue+0x36>
  803435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803439:	48 89 c7             	mov    %rax,%rdi
  80343c:	48 b8 4a 34 80 00 00 	movabs $0x80344a,%rax
  803443:	00 00 00 
  803446:	ff d0                	callq  *%rax
}
  803448:	c9                   	leaveq 
  803449:	c3                   	retq   

000000000080344a <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80344a:	55                   	push   %rbp
  80344b:	48 89 e5             	mov    %rsp,%rbp
  80344e:	53                   	push   %rbx
  80344f:	48 83 ec 18          	sub    $0x18,%rsp
  803453:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  803457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80345f:	48 85 c0             	test   %rax,%rax
  803462:	75 0a                	jne    80346e <argnextvalue+0x24>
		return 0;
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
  803469:	e9 c8 00 00 00       	jmpq   803536 <argnextvalue+0xec>
	if (*args->curarg) {
  80346e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803472:	48 8b 40 10          	mov    0x10(%rax),%rax
  803476:	0f b6 00             	movzbl (%rax),%eax
  803479:	84 c0                	test   %al,%al
  80347b:	74 27                	je     8034a4 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  80347d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803481:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803489:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  80348d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803491:	48 bb 61 65 80 00 00 	movabs $0x806561,%rbx
  803498:	00 00 00 
  80349b:	48 89 58 10          	mov    %rbx,0x10(%rax)
  80349f:	e9 8a 00 00 00       	jmpq   80352e <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8034a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a8:	48 8b 00             	mov    (%rax),%rax
  8034ab:	8b 00                	mov    (%rax),%eax
  8034ad:	83 f8 01             	cmp    $0x1,%eax
  8034b0:	7e 64                	jle    803516 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8034b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8034be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c2:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8034c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ca:	48 8b 00             	mov    (%rax),%rax
  8034cd:	8b 00                	mov    (%rax),%eax
  8034cf:	83 e8 01             	sub    $0x1,%eax
  8034d2:	48 98                	cltq   
  8034d4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034db:	00 
  8034dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034e4:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8034e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ec:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034f0:	48 83 c0 08          	add    $0x8,%rax
  8034f4:	48 89 ce             	mov    %rcx,%rsi
  8034f7:	48 89 c7             	mov    %rax,%rdi
  8034fa:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
		(*args->argc)--;
  803506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350a:	48 8b 00             	mov    (%rax),%rax
  80350d:	8b 10                	mov    (%rax),%edx
  80350f:	83 ea 01             	sub    $0x1,%edx
  803512:	89 10                	mov    %edx,(%rax)
  803514:	eb 18                	jmp    80352e <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  803516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803521:	00 
		args->curarg = 0;
  803522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803526:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80352d:	00 
	}
	return (char*) args->argvalue;
  80352e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803532:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803536:	48 83 c4 18          	add    $0x18,%rsp
  80353a:	5b                   	pop    %rbx
  80353b:	5d                   	pop    %rbp
  80353c:	c3                   	retq   

000000000080353d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80353d:	55                   	push   %rbp
  80353e:	48 89 e5             	mov    %rsp,%rbp
  803541:	48 83 ec 08          	sub    $0x8,%rsp
  803545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803549:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80354d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  803554:	ff ff ff 
  803557:	48 01 d0             	add    %rdx,%rax
  80355a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80355e:	c9                   	leaveq 
  80355f:	c3                   	retq   

0000000000803560 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803560:	55                   	push   %rbp
  803561:	48 89 e5             	mov    %rsp,%rbp
  803564:	48 83 ec 08          	sub    $0x8,%rsp
  803568:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80356c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803570:	48 89 c7             	mov    %rax,%rdi
  803573:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
  80357f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803585:	48 c1 e0 0c          	shl    $0xc,%rax
}
  803589:	c9                   	leaveq 
  80358a:	c3                   	retq   

000000000080358b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80358b:	55                   	push   %rbp
  80358c:	48 89 e5             	mov    %rsp,%rbp
  80358f:	48 83 ec 18          	sub    $0x18,%rsp
  803593:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80359e:	eb 6b                	jmp    80360b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8035a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a3:	48 98                	cltq   
  8035a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8035ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8035af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8035b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b7:	48 c1 e8 15          	shr    $0x15,%rax
  8035bb:	48 89 c2             	mov    %rax,%rdx
  8035be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035c5:	01 00 00 
  8035c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035cc:	83 e0 01             	and    $0x1,%eax
  8035cf:	48 85 c0             	test   %rax,%rax
  8035d2:	74 21                	je     8035f5 <fd_alloc+0x6a>
  8035d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8035dc:	48 89 c2             	mov    %rax,%rdx
  8035df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035e6:	01 00 00 
  8035e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ed:	83 e0 01             	and    $0x1,%eax
  8035f0:	48 85 c0             	test   %rax,%rax
  8035f3:	75 12                	jne    803607 <fd_alloc+0x7c>
			*fd_store = fd;
  8035f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035fd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803600:	b8 00 00 00 00       	mov    $0x0,%eax
  803605:	eb 1a                	jmp    803621 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803607:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80360b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80360f:	7e 8f                	jle    8035a0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803615:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80361c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803621:	c9                   	leaveq 
  803622:	c3                   	retq   

0000000000803623 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803623:	55                   	push   %rbp
  803624:	48 89 e5             	mov    %rsp,%rbp
  803627:	48 83 ec 20          	sub    $0x20,%rsp
  80362b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80362e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803632:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803636:	78 06                	js     80363e <fd_lookup+0x1b>
  803638:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80363c:	7e 07                	jle    803645 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80363e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803643:	eb 6c                	jmp    8036b1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803648:	48 98                	cltq   
  80364a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803650:	48 c1 e0 0c          	shl    $0xc,%rax
  803654:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365c:	48 c1 e8 15          	shr    $0x15,%rax
  803660:	48 89 c2             	mov    %rax,%rdx
  803663:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80366a:	01 00 00 
  80366d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803671:	83 e0 01             	and    $0x1,%eax
  803674:	48 85 c0             	test   %rax,%rax
  803677:	74 21                	je     80369a <fd_lookup+0x77>
  803679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367d:	48 c1 e8 0c          	shr    $0xc,%rax
  803681:	48 89 c2             	mov    %rax,%rdx
  803684:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80368b:	01 00 00 
  80368e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803692:	83 e0 01             	and    $0x1,%eax
  803695:	48 85 c0             	test   %rax,%rax
  803698:	75 07                	jne    8036a1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80369a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80369f:	eb 10                	jmp    8036b1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8036a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036a9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8036ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036b1:	c9                   	leaveq 
  8036b2:	c3                   	retq   

00000000008036b3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8036b3:	55                   	push   %rbp
  8036b4:	48 89 e5             	mov    %rsp,%rbp
  8036b7:	48 83 ec 30          	sub    $0x30,%rsp
  8036bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036bf:	89 f0                	mov    %esi,%eax
  8036c1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8036c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c8:	48 89 c7             	mov    %rax,%rdi
  8036cb:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
  8036d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036db:	48 89 d6             	mov    %rdx,%rsi
  8036de:	89 c7                	mov    %eax,%edi
  8036e0:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
  8036ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f3:	78 0a                	js     8036ff <fd_close+0x4c>
	    || fd != fd2)
  8036f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8036fd:	74 12                	je     803711 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8036ff:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803703:	74 05                	je     80370a <fd_close+0x57>
  803705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803708:	eb 05                	jmp    80370f <fd_close+0x5c>
  80370a:	b8 00 00 00 00       	mov    $0x0,%eax
  80370f:	eb 69                	jmp    80377a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803715:	8b 00                	mov    (%rax),%eax
  803717:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80371b:	48 89 d6             	mov    %rdx,%rsi
  80371e:	89 c7                	mov    %eax,%edi
  803720:	48 b8 7c 37 80 00 00 	movabs $0x80377c,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
  80372c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803733:	78 2a                	js     80375f <fd_close+0xac>
		if (dev->dev_close)
  803735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803739:	48 8b 40 20          	mov    0x20(%rax),%rax
  80373d:	48 85 c0             	test   %rax,%rax
  803740:	74 16                	je     803758 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803746:	48 8b 40 20          	mov    0x20(%rax),%rax
  80374a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80374e:	48 89 d7             	mov    %rdx,%rdi
  803751:	ff d0                	callq  *%rax
  803753:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803756:	eb 07                	jmp    80375f <fd_close+0xac>
		else
			r = 0;
  803758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80375f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803763:	48 89 c6             	mov    %rax,%rsi
  803766:	bf 00 00 00 00       	mov    $0x0,%edi
  80376b:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  803772:	00 00 00 
  803775:	ff d0                	callq  *%rax
	return r;
  803777:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80377a:	c9                   	leaveq 
  80377b:	c3                   	retq   

000000000080377c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80377c:	55                   	push   %rbp
  80377d:	48 89 e5             	mov    %rsp,%rbp
  803780:	48 83 ec 20          	sub    $0x20,%rsp
  803784:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80378b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803792:	eb 41                	jmp    8037d5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803794:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80379b:	00 00 00 
  80379e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a1:	48 63 d2             	movslq %edx,%rdx
  8037a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037a8:	8b 00                	mov    (%rax),%eax
  8037aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8037ad:	75 22                	jne    8037d1 <dev_lookup+0x55>
			*dev = devtab[i];
  8037af:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8037b6:	00 00 00 
  8037b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037bc:	48 63 d2             	movslq %edx,%rdx
  8037bf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8037c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8037ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cf:	eb 60                	jmp    803831 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8037d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8037d5:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8037dc:	00 00 00 
  8037df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e2:	48 63 d2             	movslq %edx,%rdx
  8037e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e9:	48 85 c0             	test   %rax,%rax
  8037ec:	75 a6                	jne    803794 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8037ee:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8037f5:	00 00 00 
  8037f8:	48 8b 00             	mov    (%rax),%rax
  8037fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803801:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803804:	89 c6                	mov    %eax,%esi
  803806:	48 bf 68 65 80 00 00 	movabs $0x806568,%rdi
  80380d:	00 00 00 
  803810:	b8 00 00 00 00       	mov    $0x0,%eax
  803815:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  80381c:	00 00 00 
  80381f:	ff d1                	callq  *%rcx
	*dev = 0;
  803821:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803825:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80382c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803831:	c9                   	leaveq 
  803832:	c3                   	retq   

0000000000803833 <close>:

int
close(int fdnum)
{
  803833:	55                   	push   %rbp
  803834:	48 89 e5             	mov    %rsp,%rbp
  803837:	48 83 ec 20          	sub    $0x20,%rsp
  80383b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80383e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803842:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803845:	48 89 d6             	mov    %rdx,%rsi
  803848:	89 c7                	mov    %eax,%edi
  80384a:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
  803856:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80385d:	79 05                	jns    803864 <close+0x31>
		return r;
  80385f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803862:	eb 18                	jmp    80387c <close+0x49>
	else
		return fd_close(fd, 1);
  803864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803868:	be 01 00 00 00       	mov    $0x1,%esi
  80386d:	48 89 c7             	mov    %rax,%rdi
  803870:	48 b8 b3 36 80 00 00 	movabs $0x8036b3,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
}
  80387c:	c9                   	leaveq 
  80387d:	c3                   	retq   

000000000080387e <close_all>:

void
close_all(void)
{
  80387e:	55                   	push   %rbp
  80387f:	48 89 e5             	mov    %rsp,%rbp
  803882:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803886:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80388d:	eb 15                	jmp    8038a4 <close_all+0x26>
		close(i);
  80388f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803892:	89 c7                	mov    %eax,%edi
  803894:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8038a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8038a4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8038a8:	7e e5                	jle    80388f <close_all+0x11>
		close(i);
}
  8038aa:	c9                   	leaveq 
  8038ab:	c3                   	retq   

00000000008038ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8038ac:	55                   	push   %rbp
  8038ad:	48 89 e5             	mov    %rsp,%rbp
  8038b0:	48 83 ec 40          	sub    $0x40,%rsp
  8038b4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8038b7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8038ba:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8038be:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8038c1:	48 89 d6             	mov    %rdx,%rsi
  8038c4:	89 c7                	mov    %eax,%edi
  8038c6:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
  8038d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d9:	79 08                	jns    8038e3 <dup+0x37>
		return r;
  8038db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038de:	e9 70 01 00 00       	jmpq   803a53 <dup+0x1a7>
	close(newfdnum);
  8038e3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8038e6:	89 c7                	mov    %eax,%edi
  8038e8:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8038f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8038f7:	48 98                	cltq   
  8038f9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8038ff:	48 c1 e0 0c          	shl    $0xc,%rax
  803903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390b:	48 89 c7             	mov    %rax,%rdi
  80390e:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  803915:	00 00 00 
  803918:	ff d0                	callq  *%rax
  80391a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80391e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803939:	48 c1 e8 15          	shr    $0x15,%rax
  80393d:	48 89 c2             	mov    %rax,%rdx
  803940:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803947:	01 00 00 
  80394a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80394e:	83 e0 01             	and    $0x1,%eax
  803951:	48 85 c0             	test   %rax,%rax
  803954:	74 73                	je     8039c9 <dup+0x11d>
  803956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395a:	48 c1 e8 0c          	shr    $0xc,%rax
  80395e:	48 89 c2             	mov    %rax,%rdx
  803961:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803968:	01 00 00 
  80396b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80396f:	83 e0 01             	and    $0x1,%eax
  803972:	48 85 c0             	test   %rax,%rax
  803975:	74 52                	je     8039c9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397b:	48 c1 e8 0c          	shr    $0xc,%rax
  80397f:	48 89 c2             	mov    %rax,%rdx
  803982:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803989:	01 00 00 
  80398c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803990:	25 07 0e 00 00       	and    $0xe07,%eax
  803995:	89 c1                	mov    %eax,%ecx
  803997:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80399b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399f:	41 89 c8             	mov    %ecx,%r8d
  8039a2:	48 89 d1             	mov    %rdx,%rcx
  8039a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8039aa:	48 89 c6             	mov    %rax,%rsi
  8039ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b2:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
  8039be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c5:	79 02                	jns    8039c9 <dup+0x11d>
			goto err;
  8039c7:	eb 57                	jmp    803a20 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8039c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8039d1:	48 89 c2             	mov    %rax,%rdx
  8039d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039db:	01 00 00 
  8039de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8039e7:	89 c1                	mov    %eax,%ecx
  8039e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f1:	41 89 c8             	mov    %ecx,%r8d
  8039f4:	48 89 d1             	mov    %rdx,%rcx
  8039f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8039fc:	48 89 c6             	mov    %rax,%rsi
  8039ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803a04:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  803a0b:	00 00 00 
  803a0e:	ff d0                	callq  *%rax
  803a10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a17:	79 02                	jns    803a1b <dup+0x16f>
		goto err;
  803a19:	eb 05                	jmp    803a20 <dup+0x174>

	return newfdnum;
  803a1b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803a1e:	eb 33                	jmp    803a53 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a24:	48 89 c6             	mov    %rax,%rsi
  803a27:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2c:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  803a33:	00 00 00 
  803a36:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803a38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3c:	48 89 c6             	mov    %rax,%rsi
  803a3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803a44:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
	return r;
  803a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a53:	c9                   	leaveq 
  803a54:	c3                   	retq   

0000000000803a55 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803a55:	55                   	push   %rbp
  803a56:	48 89 e5             	mov    %rsp,%rbp
  803a59:	48 83 ec 40          	sub    $0x40,%rsp
  803a5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803a60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803a68:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a6f:	48 89 d6             	mov    %rdx,%rsi
  803a72:	89 c7                	mov    %eax,%edi
  803a74:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
  803a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a87:	78 24                	js     803aad <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a8d:	8b 00                	mov    (%rax),%eax
  803a8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a93:	48 89 d6             	mov    %rdx,%rsi
  803a96:	89 c7                	mov    %eax,%edi
  803a98:	48 b8 7c 37 80 00 00 	movabs $0x80377c,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
  803aa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aab:	79 05                	jns    803ab2 <read+0x5d>
		return r;
  803aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab0:	eb 76                	jmp    803b28 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab6:	8b 40 08             	mov    0x8(%rax),%eax
  803ab9:	83 e0 03             	and    $0x3,%eax
  803abc:	83 f8 01             	cmp    $0x1,%eax
  803abf:	75 3a                	jne    803afb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803ac1:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803ac8:	00 00 00 
  803acb:	48 8b 00             	mov    (%rax),%rax
  803ace:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803ad4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ad7:	89 c6                	mov    %eax,%esi
  803ad9:	48 bf 87 65 80 00 00 	movabs $0x806587,%rdi
  803ae0:	00 00 00 
  803ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae8:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  803aef:	00 00 00 
  803af2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803af4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803af9:	eb 2d                	jmp    803b28 <read+0xd3>
	}
	if (!dev->dev_read)
  803afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aff:	48 8b 40 10          	mov    0x10(%rax),%rax
  803b03:	48 85 c0             	test   %rax,%rax
  803b06:	75 07                	jne    803b0f <read+0xba>
		return -E_NOT_SUPP;
  803b08:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b0d:	eb 19                	jmp    803b28 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803b0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b13:	48 8b 40 10          	mov    0x10(%rax),%rax
  803b17:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b1b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b1f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803b23:	48 89 cf             	mov    %rcx,%rdi
  803b26:	ff d0                	callq  *%rax
}
  803b28:	c9                   	leaveq 
  803b29:	c3                   	retq   

0000000000803b2a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803b2a:	55                   	push   %rbp
  803b2b:	48 89 e5             	mov    %rsp,%rbp
  803b2e:	48 83 ec 30          	sub    $0x30,%rsp
  803b32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803b3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b44:	eb 49                	jmp    803b8f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b49:	48 98                	cltq   
  803b4b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b4f:	48 29 c2             	sub    %rax,%rdx
  803b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b55:	48 63 c8             	movslq %eax,%rcx
  803b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5c:	48 01 c1             	add    %rax,%rcx
  803b5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b62:	48 89 ce             	mov    %rcx,%rsi
  803b65:	89 c7                	mov    %eax,%edi
  803b67:	48 b8 55 3a 80 00 00 	movabs $0x803a55,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
  803b73:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803b76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b7a:	79 05                	jns    803b81 <readn+0x57>
			return m;
  803b7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7f:	eb 1c                	jmp    803b9d <readn+0x73>
		if (m == 0)
  803b81:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b85:	75 02                	jne    803b89 <readn+0x5f>
			break;
  803b87:	eb 11                	jmp    803b9a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803b89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b8c:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b92:	48 98                	cltq   
  803b94:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803b98:	72 ac                	jb     803b46 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b9d:	c9                   	leaveq 
  803b9e:	c3                   	retq   

0000000000803b9f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803b9f:	55                   	push   %rbp
  803ba0:	48 89 e5             	mov    %rsp,%rbp
  803ba3:	48 83 ec 40          	sub    $0x40,%rsp
  803ba7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803baa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803bb2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bb6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bb9:	48 89 d6             	mov    %rdx,%rsi
  803bbc:	89 c7                	mov    %eax,%edi
  803bbe:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803bc5:	00 00 00 
  803bc8:	ff d0                	callq  *%rax
  803bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd1:	78 24                	js     803bf7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd7:	8b 00                	mov    (%rax),%eax
  803bd9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bdd:	48 89 d6             	mov    %rdx,%rsi
  803be0:	89 c7                	mov    %eax,%edi
  803be2:	48 b8 7c 37 80 00 00 	movabs $0x80377c,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
  803bee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf5:	79 05                	jns    803bfc <write+0x5d>
		return r;
  803bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfa:	eb 75                	jmp    803c71 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c00:	8b 40 08             	mov    0x8(%rax),%eax
  803c03:	83 e0 03             	and    $0x3,%eax
  803c06:	85 c0                	test   %eax,%eax
  803c08:	75 3a                	jne    803c44 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803c0a:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803c11:	00 00 00 
  803c14:	48 8b 00             	mov    (%rax),%rax
  803c17:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c1d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c20:	89 c6                	mov    %eax,%esi
  803c22:	48 bf a3 65 80 00 00 	movabs $0x8065a3,%rdi
  803c29:	00 00 00 
  803c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c31:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  803c38:	00 00 00 
  803c3b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803c3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803c42:	eb 2d                	jmp    803c71 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c48:	48 8b 40 18          	mov    0x18(%rax),%rax
  803c4c:	48 85 c0             	test   %rax,%rax
  803c4f:	75 07                	jne    803c58 <write+0xb9>
		return -E_NOT_SUPP;
  803c51:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803c56:	eb 19                	jmp    803c71 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803c58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803c60:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c64:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c68:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803c6c:	48 89 cf             	mov    %rcx,%rdi
  803c6f:	ff d0                	callq  *%rax
}
  803c71:	c9                   	leaveq 
  803c72:	c3                   	retq   

0000000000803c73 <seek>:

int
seek(int fdnum, off_t offset)
{
  803c73:	55                   	push   %rbp
  803c74:	48 89 e5             	mov    %rsp,%rbp
  803c77:	48 83 ec 18          	sub    $0x18,%rsp
  803c7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c7e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c88:	48 89 d6             	mov    %rdx,%rsi
  803c8b:	89 c7                	mov    %eax,%edi
  803c8d:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
  803c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca0:	79 05                	jns    803ca7 <seek+0x34>
		return r;
  803ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca5:	eb 0f                	jmp    803cb6 <seek+0x43>
	fd->fd_offset = offset;
  803ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cae:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cb6:	c9                   	leaveq 
  803cb7:	c3                   	retq   

0000000000803cb8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803cb8:	55                   	push   %rbp
  803cb9:	48 89 e5             	mov    %rsp,%rbp
  803cbc:	48 83 ec 30          	sub    $0x30,%rsp
  803cc0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cc3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803cc6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ccd:	48 89 d6             	mov    %rdx,%rsi
  803cd0:	89 c7                	mov    %eax,%edi
  803cd2:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803cd9:	00 00 00 
  803cdc:	ff d0                	callq  *%rax
  803cde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce5:	78 24                	js     803d0b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ceb:	8b 00                	mov    (%rax),%eax
  803ced:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cf1:	48 89 d6             	mov    %rdx,%rsi
  803cf4:	89 c7                	mov    %eax,%edi
  803cf6:	48 b8 7c 37 80 00 00 	movabs $0x80377c,%rax
  803cfd:	00 00 00 
  803d00:	ff d0                	callq  *%rax
  803d02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d09:	79 05                	jns    803d10 <ftruncate+0x58>
		return r;
  803d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0e:	eb 72                	jmp    803d82 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d14:	8b 40 08             	mov    0x8(%rax),%eax
  803d17:	83 e0 03             	and    $0x3,%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	75 3a                	jne    803d58 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803d1e:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  803d25:	00 00 00 
  803d28:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803d2b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d31:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d34:	89 c6                	mov    %eax,%esi
  803d36:	48 bf c0 65 80 00 00 	movabs $0x8065c0,%rdi
  803d3d:	00 00 00 
  803d40:	b8 00 00 00 00       	mov    $0x0,%eax
  803d45:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  803d4c:	00 00 00 
  803d4f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803d51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d56:	eb 2a                	jmp    803d82 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5c:	48 8b 40 30          	mov    0x30(%rax),%rax
  803d60:	48 85 c0             	test   %rax,%rax
  803d63:	75 07                	jne    803d6c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803d65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d6a:	eb 16                	jmp    803d82 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d70:	48 8b 40 30          	mov    0x30(%rax),%rax
  803d74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d78:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803d7b:	89 ce                	mov    %ecx,%esi
  803d7d:	48 89 d7             	mov    %rdx,%rdi
  803d80:	ff d0                	callq  *%rax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	48 83 ec 30          	sub    $0x30,%rsp
  803d8c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d8f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803d93:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d9a:	48 89 d6             	mov    %rdx,%rsi
  803d9d:	89 c7                	mov    %eax,%edi
  803d9f:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  803da6:	00 00 00 
  803da9:	ff d0                	callq  *%rax
  803dab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db2:	78 24                	js     803dd8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db8:	8b 00                	mov    (%rax),%eax
  803dba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dbe:	48 89 d6             	mov    %rdx,%rsi
  803dc1:	89 c7                	mov    %eax,%edi
  803dc3:	48 b8 7c 37 80 00 00 	movabs $0x80377c,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
  803dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd6:	79 05                	jns    803ddd <fstat+0x59>
		return r;
  803dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddb:	eb 5e                	jmp    803e3b <fstat+0xb7>
	if (!dev->dev_stat)
  803ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de1:	48 8b 40 28          	mov    0x28(%rax),%rax
  803de5:	48 85 c0             	test   %rax,%rax
  803de8:	75 07                	jne    803df1 <fstat+0x6d>
		return -E_NOT_SUPP;
  803dea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803def:	eb 4a                	jmp    803e3b <fstat+0xb7>
	stat->st_name[0] = 0;
  803df1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803df5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803df8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dfc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803e03:	00 00 00 
	stat->st_isdir = 0;
  803e06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e11:	00 00 00 
	stat->st_dev = dev;
  803e14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803e23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e27:	48 8b 40 28          	mov    0x28(%rax),%rax
  803e2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e2f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803e33:	48 89 ce             	mov    %rcx,%rsi
  803e36:	48 89 d7             	mov    %rdx,%rdi
  803e39:	ff d0                	callq  *%rax
}
  803e3b:	c9                   	leaveq 
  803e3c:	c3                   	retq   

0000000000803e3d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803e3d:	55                   	push   %rbp
  803e3e:	48 89 e5             	mov    %rsp,%rbp
  803e41:	48 83 ec 20          	sub    $0x20,%rsp
  803e45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e51:	be 00 00 00 00       	mov    $0x0,%esi
  803e56:	48 89 c7             	mov    %rax,%rdi
  803e59:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
  803e65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e6c:	79 05                	jns    803e73 <stat+0x36>
		return fd;
  803e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e71:	eb 2f                	jmp    803ea2 <stat+0x65>
	r = fstat(fd, stat);
  803e73:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7a:	48 89 d6             	mov    %rdx,%rsi
  803e7d:	89 c7                	mov    %eax,%edi
  803e7f:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
  803e8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e91:	89 c7                	mov    %eax,%edi
  803e93:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  803e9a:	00 00 00 
  803e9d:	ff d0                	callq  *%rax
	return r;
  803e9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803ea2:	c9                   	leaveq 
  803ea3:	c3                   	retq   

0000000000803ea4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803ea4:	55                   	push   %rbp
  803ea5:	48 89 e5             	mov    %rsp,%rbp
  803ea8:	48 83 ec 10          	sub    $0x10,%rsp
  803eac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803eb3:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  803eba:	00 00 00 
  803ebd:	8b 00                	mov    (%rax),%eax
  803ebf:	85 c0                	test   %eax,%eax
  803ec1:	75 1d                	jne    803ee0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803ec3:	bf 01 00 00 00       	mov    $0x1,%edi
  803ec8:	48 b8 6c 5c 80 00 00 	movabs $0x805c6c,%rax
  803ecf:	00 00 00 
  803ed2:	ff d0                	callq  *%rax
  803ed4:	48 ba 20 94 80 00 00 	movabs $0x809420,%rdx
  803edb:	00 00 00 
  803ede:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803ee0:	48 b8 20 94 80 00 00 	movabs $0x809420,%rax
  803ee7:	00 00 00 
  803eea:	8b 00                	mov    (%rax),%eax
  803eec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803eef:	b9 07 00 00 00       	mov    $0x7,%ecx
  803ef4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803efb:	00 00 00 
  803efe:	89 c7                	mov    %eax,%edi
  803f00:	48 b8 cf 5b 80 00 00 	movabs $0x805bcf,%rax
  803f07:	00 00 00 
  803f0a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f10:	ba 00 00 00 00       	mov    $0x0,%edx
  803f15:	48 89 c6             	mov    %rax,%rsi
  803f18:	bf 00 00 00 00       	mov    $0x0,%edi
  803f1d:	48 b8 09 5b 80 00 00 	movabs $0x805b09,%rax
  803f24:	00 00 00 
  803f27:	ff d0                	callq  *%rax
}
  803f29:	c9                   	leaveq 
  803f2a:	c3                   	retq   

0000000000803f2b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803f2b:	55                   	push   %rbp
  803f2c:	48 89 e5             	mov    %rsp,%rbp
  803f2f:	48 83 ec 20          	sub    $0x20,%rsp
  803f33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f37:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  803f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3e:	48 89 c7             	mov    %rax,%rdi
  803f41:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  803f48:	00 00 00 
  803f4b:	ff d0                	callq  *%rax
  803f4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803f52:	7e 0a                	jle    803f5e <open+0x33>
  803f54:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803f59:	e9 a5 00 00 00       	jmpq   804003 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  803f5e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f62:	48 89 c7             	mov    %rax,%rdi
  803f65:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  803f6c:	00 00 00 
  803f6f:	ff d0                	callq  *%rax
  803f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f78:	79 08                	jns    803f82 <open+0x57>
		return r;
  803f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7d:	e9 81 00 00 00       	jmpq   804003 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803f82:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803f89:	00 00 00 
  803f8c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803f8f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  803f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f99:	48 89 c6             	mov    %rax,%rsi
  803f9c:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803fa3:	00 00 00 
  803fa6:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  803fad:	00 00 00 
  803fb0:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  803fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb6:	48 89 c6             	mov    %rax,%rsi
  803fb9:	bf 01 00 00 00       	mov    $0x1,%edi
  803fbe:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  803fc5:	00 00 00 
  803fc8:	ff d0                	callq  *%rax
  803fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd1:	79 1d                	jns    803ff0 <open+0xc5>
		fd_close(fd, 0);
  803fd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd7:	be 00 00 00 00       	mov    $0x0,%esi
  803fdc:	48 89 c7             	mov    %rax,%rdi
  803fdf:	48 b8 b3 36 80 00 00 	movabs $0x8036b3,%rax
  803fe6:	00 00 00 
  803fe9:	ff d0                	callq  *%rax
		return r;
  803feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fee:	eb 13                	jmp    804003 <open+0xd8>
	}
	return fd2num(fd);
  803ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff4:	48 89 c7             	mov    %rax,%rdi
  803ff7:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  803ffe:	00 00 00 
  804001:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  804003:	c9                   	leaveq 
  804004:	c3                   	retq   

0000000000804005 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804005:	55                   	push   %rbp
  804006:	48 89 e5             	mov    %rsp,%rbp
  804009:	48 83 ec 10          	sub    $0x10,%rsp
  80400d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804015:	8b 50 0c             	mov    0xc(%rax),%edx
  804018:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80401f:	00 00 00 
  804022:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804024:	be 00 00 00 00       	mov    $0x0,%esi
  804029:	bf 06 00 00 00       	mov    $0x6,%edi
  80402e:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  804035:	00 00 00 
  804038:	ff d0                	callq  *%rax
}
  80403a:	c9                   	leaveq 
  80403b:	c3                   	retq   

000000000080403c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 83 ec 30          	sub    $0x30,%rsp
  804044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80404c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  804050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804054:	8b 50 0c             	mov    0xc(%rax),%edx
  804057:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80405e:	00 00 00 
  804061:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  804063:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80406a:	00 00 00 
  80406d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804071:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  804075:	be 00 00 00 00       	mov    $0x0,%esi
  80407a:	bf 03 00 00 00       	mov    $0x3,%edi
  80407f:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  804086:	00 00 00 
  804089:	ff d0                	callq  *%rax
  80408b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80408e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804092:	79 05                	jns    804099 <devfile_read+0x5d>
		return r;
  804094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804097:	eb 26                	jmp    8040bf <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  804099:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409c:	48 63 d0             	movslq %eax,%rdx
  80409f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040a3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8040aa:	00 00 00 
  8040ad:	48 89 c7             	mov    %rax,%rdi
  8040b0:	48 b8 ac 25 80 00 00 	movabs $0x8025ac,%rax
  8040b7:	00 00 00 
  8040ba:	ff d0                	callq  *%rax
	return r;
  8040bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8040bf:	c9                   	leaveq 
  8040c0:	c3                   	retq   

00000000008040c1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8040c1:	55                   	push   %rbp
  8040c2:	48 89 e5             	mov    %rsp,%rbp
  8040c5:	48 83 ec 30          	sub    $0x30,%rsp
  8040c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8040d5:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8040dc:	00 
	n = n > max ? max : n;
  8040dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8040e5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8040ea:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8040ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f2:	8b 50 0c             	mov    0xc(%rax),%edx
  8040f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8040fc:	00 00 00 
  8040ff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  804101:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804108:	00 00 00 
  80410b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80410f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  804113:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804117:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80411b:	48 89 c6             	mov    %rax,%rsi
  80411e:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  804125:	00 00 00 
  804128:	48 b8 ac 25 80 00 00 	movabs $0x8025ac,%rax
  80412f:	00 00 00 
  804132:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  804134:	be 00 00 00 00       	mov    $0x0,%esi
  804139:	bf 04 00 00 00       	mov    $0x4,%edi
  80413e:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  804145:	00 00 00 
  804148:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  80414a:	c9                   	leaveq 
  80414b:	c3                   	retq   

000000000080414c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80414c:	55                   	push   %rbp
  80414d:	48 89 e5             	mov    %rsp,%rbp
  804150:	48 83 ec 20          	sub    $0x20,%rsp
  804154:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804158:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80415c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804160:	8b 50 0c             	mov    0xc(%rax),%edx
  804163:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80416a:	00 00 00 
  80416d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80416f:	be 00 00 00 00       	mov    $0x0,%esi
  804174:	bf 05 00 00 00       	mov    $0x5,%edi
  804179:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
  804185:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80418c:	79 05                	jns    804193 <devfile_stat+0x47>
		return r;
  80418e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804191:	eb 56                	jmp    8041e9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  804193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804197:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80419e:	00 00 00 
  8041a1:	48 89 c7             	mov    %rax,%rdi
  8041a4:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8041ab:	00 00 00 
  8041ae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8041b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041b7:	00 00 00 
  8041ba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8041c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8041ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041d1:	00 00 00 
  8041d4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8041da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041de:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8041e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041e9:	c9                   	leaveq 
  8041ea:	c3                   	retq   

00000000008041eb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8041eb:	55                   	push   %rbp
  8041ec:	48 89 e5             	mov    %rsp,%rbp
  8041ef:	48 83 ec 10          	sub    $0x10,%rsp
  8041f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041f7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8041fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fe:	8b 50 0c             	mov    0xc(%rax),%edx
  804201:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804208:	00 00 00 
  80420b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80420d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804214:	00 00 00 
  804217:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80421a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80421d:	be 00 00 00 00       	mov    $0x0,%esi
  804222:	bf 02 00 00 00       	mov    $0x2,%edi
  804227:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  80422e:	00 00 00 
  804231:	ff d0                	callq  *%rax
}
  804233:	c9                   	leaveq 
  804234:	c3                   	retq   

0000000000804235 <remove>:

// Delete a file
int
remove(const char *path)
{
  804235:	55                   	push   %rbp
  804236:	48 89 e5             	mov    %rsp,%rbp
  804239:	48 83 ec 10          	sub    $0x10,%rsp
  80423d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  804241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804245:	48 89 c7             	mov    %rax,%rdi
  804248:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  80424f:	00 00 00 
  804252:	ff d0                	callq  *%rax
  804254:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804259:	7e 07                	jle    804262 <remove+0x2d>
		return -E_BAD_PATH;
  80425b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804260:	eb 33                	jmp    804295 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804266:	48 89 c6             	mov    %rax,%rsi
  804269:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  804270:	00 00 00 
  804273:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80427a:	00 00 00 
  80427d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80427f:	be 00 00 00 00       	mov    $0x0,%esi
  804284:	bf 07 00 00 00       	mov    $0x7,%edi
  804289:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  804290:	00 00 00 
  804293:	ff d0                	callq  *%rax
}
  804295:	c9                   	leaveq 
  804296:	c3                   	retq   

0000000000804297 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804297:	55                   	push   %rbp
  804298:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80429b:	be 00 00 00 00       	mov    $0x0,%esi
  8042a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8042a5:	48 b8 a4 3e 80 00 00 	movabs $0x803ea4,%rax
  8042ac:	00 00 00 
  8042af:	ff d0                	callq  *%rax
}
  8042b1:	5d                   	pop    %rbp
  8042b2:	c3                   	retq   

00000000008042b3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8042b3:	55                   	push   %rbp
  8042b4:	48 89 e5             	mov    %rsp,%rbp
  8042b7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8042be:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8042c5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8042cc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8042d3:	be 00 00 00 00       	mov    $0x0,%esi
  8042d8:	48 89 c7             	mov    %rax,%rdi
  8042db:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  8042e2:	00 00 00 
  8042e5:	ff d0                	callq  *%rax
  8042e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8042ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ee:	79 28                	jns    804318 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8042f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f3:	89 c6                	mov    %eax,%esi
  8042f5:	48 bf e6 65 80 00 00 	movabs $0x8065e6,%rdi
  8042fc:	00 00 00 
  8042ff:	b8 00 00 00 00       	mov    $0x0,%eax
  804304:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  80430b:	00 00 00 
  80430e:	ff d2                	callq  *%rdx
		return fd_src;
  804310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804313:	e9 74 01 00 00       	jmpq   80448c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  804318:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80431f:	be 01 01 00 00       	mov    $0x101,%esi
  804324:	48 89 c7             	mov    %rax,%rdi
  804327:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  80432e:	00 00 00 
  804331:	ff d0                	callq  *%rax
  804333:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  804336:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80433a:	79 39                	jns    804375 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80433c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80433f:	89 c6                	mov    %eax,%esi
  804341:	48 bf fc 65 80 00 00 	movabs $0x8065fc,%rdi
  804348:	00 00 00 
  80434b:	b8 00 00 00 00       	mov    $0x0,%eax
  804350:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  804357:	00 00 00 
  80435a:	ff d2                	callq  *%rdx
		close(fd_src);
  80435c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435f:	89 c7                	mov    %eax,%edi
  804361:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  804368:	00 00 00 
  80436b:	ff d0                	callq  *%rax
		return fd_dest;
  80436d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804370:	e9 17 01 00 00       	jmpq   80448c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804375:	eb 74                	jmp    8043eb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  804377:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80437a:	48 63 d0             	movslq %eax,%rdx
  80437d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  804384:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804387:	48 89 ce             	mov    %rcx,%rsi
  80438a:	89 c7                	mov    %eax,%edi
  80438c:	48 b8 9f 3b 80 00 00 	movabs $0x803b9f,%rax
  804393:	00 00 00 
  804396:	ff d0                	callq  *%rax
  804398:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80439b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80439f:	79 4a                	jns    8043eb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8043a1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043a4:	89 c6                	mov    %eax,%esi
  8043a6:	48 bf 16 66 80 00 00 	movabs $0x806616,%rdi
  8043ad:	00 00 00 
  8043b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8043b5:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  8043bc:	00 00 00 
  8043bf:	ff d2                	callq  *%rdx
			close(fd_src);
  8043c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c4:	89 c7                	mov    %eax,%edi
  8043c6:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8043cd:	00 00 00 
  8043d0:	ff d0                	callq  *%rax
			close(fd_dest);
  8043d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043d5:	89 c7                	mov    %eax,%edi
  8043d7:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8043de:	00 00 00 
  8043e1:	ff d0                	callq  *%rax
			return write_size;
  8043e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043e6:	e9 a1 00 00 00       	jmpq   80448c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8043eb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8043f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f5:	ba 00 02 00 00       	mov    $0x200,%edx
  8043fa:	48 89 ce             	mov    %rcx,%rsi
  8043fd:	89 c7                	mov    %eax,%edi
  8043ff:	48 b8 55 3a 80 00 00 	movabs $0x803a55,%rax
  804406:	00 00 00 
  804409:	ff d0                	callq  *%rax
  80440b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80440e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804412:	0f 8f 5f ff ff ff    	jg     804377 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  804418:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80441c:	79 47                	jns    804465 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80441e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804421:	89 c6                	mov    %eax,%esi
  804423:	48 bf 29 66 80 00 00 	movabs $0x806629,%rdi
  80442a:	00 00 00 
  80442d:	b8 00 00 00 00       	mov    $0x0,%eax
  804432:	48 ba 62 14 80 00 00 	movabs $0x801462,%rdx
  804439:	00 00 00 
  80443c:	ff d2                	callq  *%rdx
		close(fd_src);
  80443e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804441:	89 c7                	mov    %eax,%edi
  804443:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  80444a:	00 00 00 
  80444d:	ff d0                	callq  *%rax
		close(fd_dest);
  80444f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804452:	89 c7                	mov    %eax,%edi
  804454:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  80445b:	00 00 00 
  80445e:	ff d0                	callq  *%rax
		return read_size;
  804460:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804463:	eb 27                	jmp    80448c <copy+0x1d9>
	}
	close(fd_src);
  804465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804468:	89 c7                	mov    %eax,%edi
  80446a:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  804471:	00 00 00 
  804474:	ff d0                	callq  *%rax
	close(fd_dest);
  804476:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804479:	89 c7                	mov    %eax,%edi
  80447b:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  804482:	00 00 00 
  804485:	ff d0                	callq  *%rax
	return 0;
  804487:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80448c:	c9                   	leaveq 
  80448d:	c3                   	retq   

000000000080448e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80448e:	55                   	push   %rbp
  80448f:	48 89 e5             	mov    %rsp,%rbp
  804492:	48 83 ec 20          	sub    $0x20,%rsp
  804496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80449a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449e:	8b 40 0c             	mov    0xc(%rax),%eax
  8044a1:	85 c0                	test   %eax,%eax
  8044a3:	7e 67                	jle    80450c <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8044a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a9:	8b 40 04             	mov    0x4(%rax),%eax
  8044ac:	48 63 d0             	movslq %eax,%rdx
  8044af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b3:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8044b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bb:	8b 00                	mov    (%rax),%eax
  8044bd:	48 89 ce             	mov    %rcx,%rsi
  8044c0:	89 c7                	mov    %eax,%edi
  8044c2:	48 b8 9f 3b 80 00 00 	movabs $0x803b9f,%rax
  8044c9:	00 00 00 
  8044cc:	ff d0                	callq  *%rax
  8044ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8044d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044d5:	7e 13                	jle    8044ea <writebuf+0x5c>
			b->result += result;
  8044d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044db:	8b 50 08             	mov    0x8(%rax),%edx
  8044de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e1:	01 c2                	add    %eax,%edx
  8044e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044e7:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8044ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ee:	8b 40 04             	mov    0x4(%rax),%eax
  8044f1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8044f4:	74 16                	je     80450c <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8044f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ff:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  804503:	89 c2                	mov    %eax,%edx
  804505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804509:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80450c:	c9                   	leaveq 
  80450d:	c3                   	retq   

000000000080450e <putch>:

static void
putch(int ch, void *thunk)
{
  80450e:	55                   	push   %rbp
  80450f:	48 89 e5             	mov    %rsp,%rbp
  804512:	48 83 ec 20          	sub    $0x20,%rsp
  804516:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804519:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80451d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804521:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  804525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804529:	8b 40 04             	mov    0x4(%rax),%eax
  80452c:	8d 48 01             	lea    0x1(%rax),%ecx
  80452f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804533:	89 4a 04             	mov    %ecx,0x4(%rdx)
  804536:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804539:	89 d1                	mov    %edx,%ecx
  80453b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80453f:	48 98                	cltq   
  804541:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  804545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804549:	8b 40 04             	mov    0x4(%rax),%eax
  80454c:	3d 00 01 00 00       	cmp    $0x100,%eax
  804551:	75 1e                	jne    804571 <putch+0x63>
		writebuf(b);
  804553:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804557:	48 89 c7             	mov    %rax,%rdi
  80455a:	48 b8 8e 44 80 00 00 	movabs $0x80448e,%rax
  804561:	00 00 00 
  804564:	ff d0                	callq  *%rax
		b->idx = 0;
  804566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804571:	c9                   	leaveq 
  804572:	c3                   	retq   

0000000000804573 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804573:	55                   	push   %rbp
  804574:	48 89 e5             	mov    %rsp,%rbp
  804577:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80457e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804584:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  80458b:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804592:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804598:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80459e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8045a5:	00 00 00 
	b.result = 0;
  8045a8:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8045af:	00 00 00 
	b.error = 1;
  8045b2:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8045b9:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8045bc:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8045c3:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8045ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045d1:	48 89 c6             	mov    %rax,%rsi
  8045d4:	48 bf 0e 45 80 00 00 	movabs $0x80450e,%rdi
  8045db:	00 00 00 
  8045de:	48 b8 15 18 80 00 00 	movabs $0x801815,%rax
  8045e5:	00 00 00 
  8045e8:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8045ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8045f0:	85 c0                	test   %eax,%eax
  8045f2:	7e 16                	jle    80460a <vfprintf+0x97>
		writebuf(&b);
  8045f4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045fb:	48 89 c7             	mov    %rax,%rdi
  8045fe:	48 b8 8e 44 80 00 00 	movabs $0x80448e,%rax
  804605:	00 00 00 
  804608:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80460a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804610:	85 c0                	test   %eax,%eax
  804612:	74 08                	je     80461c <vfprintf+0xa9>
  804614:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80461a:	eb 06                	jmp    804622 <vfprintf+0xaf>
  80461c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804622:	c9                   	leaveq 
  804623:	c3                   	retq   

0000000000804624 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804624:	55                   	push   %rbp
  804625:	48 89 e5             	mov    %rsp,%rbp
  804628:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80462f:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804635:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80463c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804643:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80464a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804651:	84 c0                	test   %al,%al
  804653:	74 20                	je     804675 <fprintf+0x51>
  804655:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804659:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80465d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804661:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804665:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804669:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80466d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804671:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804675:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80467c:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804683:	00 00 00 
  804686:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80468d:	00 00 00 
  804690:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804694:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80469b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8046a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8046a9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8046b0:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8046b7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8046bd:	48 89 ce             	mov    %rcx,%rsi
  8046c0:	89 c7                	mov    %eax,%edi
  8046c2:	48 b8 73 45 80 00 00 	movabs $0x804573,%rax
  8046c9:	00 00 00 
  8046cc:	ff d0                	callq  *%rax
  8046ce:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8046d4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8046da:	c9                   	leaveq 
  8046db:	c3                   	retq   

00000000008046dc <printf>:

int
printf(const char *fmt, ...)
{
  8046dc:	55                   	push   %rbp
  8046dd:	48 89 e5             	mov    %rsp,%rbp
  8046e0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8046e7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8046ee:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8046f5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8046fc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804703:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80470a:	84 c0                	test   %al,%al
  80470c:	74 20                	je     80472e <printf+0x52>
  80470e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804712:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804716:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80471a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80471e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804722:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804726:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80472a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80472e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804735:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80473c:	00 00 00 
  80473f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804746:	00 00 00 
  804749:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80474d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804754:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80475b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804762:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804769:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804770:	48 89 c6             	mov    %rax,%rsi
  804773:	bf 01 00 00 00       	mov    $0x1,%edi
  804778:	48 b8 73 45 80 00 00 	movabs $0x804573,%rax
  80477f:	00 00 00 
  804782:	ff d0                	callq  *%rax
  804784:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80478a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804790:	c9                   	leaveq 
  804791:	c3                   	retq   

0000000000804792 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804792:	55                   	push   %rbp
  804793:	48 89 e5             	mov    %rsp,%rbp
  804796:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80479d:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8047a4:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8047ab:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8047b2:	be 00 00 00 00       	mov    $0x0,%esi
  8047b7:	48 89 c7             	mov    %rax,%rdi
  8047ba:	48 b8 2b 3f 80 00 00 	movabs $0x803f2b,%rax
  8047c1:	00 00 00 
  8047c4:	ff d0                	callq  *%rax
  8047c6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8047c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8047cd:	79 08                	jns    8047d7 <spawn+0x45>
		return r;
  8047cf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8047d2:	e9 14 03 00 00       	jmpq   804aeb <spawn+0x359>
	fd = r;
  8047d7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8047da:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8047dd:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8047e4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8047e8:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8047ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8047f2:	ba 00 02 00 00       	mov    $0x200,%edx
  8047f7:	48 89 ce             	mov    %rcx,%rsi
  8047fa:	89 c7                	mov    %eax,%edi
  8047fc:	48 b8 2a 3b 80 00 00 	movabs $0x803b2a,%rax
  804803:	00 00 00 
  804806:	ff d0                	callq  *%rax
  804808:	3d 00 02 00 00       	cmp    $0x200,%eax
  80480d:	75 0d                	jne    80481c <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80480f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804813:	8b 00                	mov    (%rax),%eax
  804815:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80481a:	74 43                	je     80485f <spawn+0xcd>
		close(fd);
  80481c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80481f:	89 c7                	mov    %eax,%edi
  804821:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  804828:	00 00 00 
  80482b:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80482d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804831:	8b 00                	mov    (%rax),%eax
  804833:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804838:	89 c6                	mov    %eax,%esi
  80483a:	48 bf 40 66 80 00 00 	movabs $0x806640,%rdi
  804841:	00 00 00 
  804844:	b8 00 00 00 00       	mov    $0x0,%eax
  804849:	48 b9 62 14 80 00 00 	movabs $0x801462,%rcx
  804850:	00 00 00 
  804853:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804855:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80485a:	e9 8c 02 00 00       	jmpq   804aeb <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80485f:	b8 07 00 00 00       	mov    $0x7,%eax
  804864:	cd 30                	int    $0x30
  804866:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804869:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80486c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80486f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804873:	79 08                	jns    80487d <spawn+0xeb>
		return r;
  804875:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804878:	e9 6e 02 00 00       	jmpq   804aeb <spawn+0x359>
	child = r;
  80487d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804880:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804883:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804886:	25 ff 03 00 00       	and    $0x3ff,%eax
  80488b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804892:	00 00 00 
  804895:	48 63 d0             	movslq %eax,%rdx
  804898:	48 89 d0             	mov    %rdx,%rax
  80489b:	48 c1 e0 03          	shl    $0x3,%rax
  80489f:	48 01 d0             	add    %rdx,%rax
  8048a2:	48 c1 e0 05          	shl    $0x5,%rax
  8048a6:	48 01 c8             	add    %rcx,%rax
  8048a9:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8048b0:	48 89 c6             	mov    %rax,%rsi
  8048b3:	b8 18 00 00 00       	mov    $0x18,%eax
  8048b8:	48 89 d7             	mov    %rdx,%rdi
  8048bb:	48 89 c1             	mov    %rax,%rcx
  8048be:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8048c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8048c9:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8048d0:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8048d7:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8048de:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8048e5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8048e8:	48 89 ce             	mov    %rcx,%rsi
  8048eb:	89 c7                	mov    %eax,%edi
  8048ed:	48 b8 55 4d 80 00 00 	movabs $0x804d55,%rax
  8048f4:	00 00 00 
  8048f7:	ff d0                	callq  *%rax
  8048f9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8048fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804900:	79 08                	jns    80490a <spawn+0x178>
		return r;
  804902:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804905:	e9 e1 01 00 00       	jmpq   804aeb <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80490a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490e:	48 8b 40 20          	mov    0x20(%rax),%rax
  804912:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804919:	48 01 d0             	add    %rdx,%rax
  80491c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804920:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804927:	e9 a3 00 00 00       	jmpq   8049cf <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  80492c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804930:	8b 00                	mov    (%rax),%eax
  804932:	83 f8 01             	cmp    $0x1,%eax
  804935:	74 05                	je     80493c <spawn+0x1aa>
			continue;
  804937:	e9 8a 00 00 00       	jmpq   8049c6 <spawn+0x234>
		perm = PTE_P | PTE_U;
  80493c:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804947:	8b 40 04             	mov    0x4(%rax),%eax
  80494a:	83 e0 02             	and    $0x2,%eax
  80494d:	85 c0                	test   %eax,%eax
  80494f:	74 04                	je     804955 <spawn+0x1c3>
			perm |= PTE_W;
  804951:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804959:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80495d:	41 89 c1             	mov    %eax,%r9d
  804960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804964:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804968:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80496c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804974:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804978:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80497b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80497e:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804981:	89 3c 24             	mov    %edi,(%rsp)
  804984:	89 c7                	mov    %eax,%edi
  804986:	48 b8 fe 4f 80 00 00 	movabs $0x804ffe,%rax
  80498d:	00 00 00 
  804990:	ff d0                	callq  *%rax
  804992:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804995:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804999:	79 2b                	jns    8049c6 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80499b:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80499c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80499f:	89 c7                	mov    %eax,%edi
  8049a1:	48 b8 e0 29 80 00 00 	movabs $0x8029e0,%rax
  8049a8:	00 00 00 
  8049ab:	ff d0                	callq  *%rax
	close(fd);
  8049ad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049b0:	89 c7                	mov    %eax,%edi
  8049b2:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8049b9:	00 00 00 
  8049bc:	ff d0                	callq  *%rax
	return r;
  8049be:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8049c1:	e9 25 01 00 00       	jmpq   804aeb <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8049c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049ca:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8049cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8049d7:	0f b7 c0             	movzwl %ax,%eax
  8049da:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8049dd:	0f 8f 49 ff ff ff    	jg     80492c <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8049e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049e6:	89 c7                	mov    %eax,%edi
  8049e8:	48 b8 33 38 80 00 00 	movabs $0x803833,%rax
  8049ef:	00 00 00 
  8049f2:	ff d0                	callq  *%rax
	fd = -1;
  8049f4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8049fb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049fe:	89 c7                	mov    %eax,%edi
  804a00:	48 b8 ea 51 80 00 00 	movabs $0x8051ea,%rax
  804a07:	00 00 00 
  804a0a:	ff d0                	callq  *%rax
  804a0c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a13:	79 30                	jns    804a45 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  804a15:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a18:	89 c1                	mov    %eax,%ecx
  804a1a:	48 ba 5a 66 80 00 00 	movabs $0x80665a,%rdx
  804a21:	00 00 00 
  804a24:	be 82 00 00 00       	mov    $0x82,%esi
  804a29:	48 bf 70 66 80 00 00 	movabs $0x806670,%rdi
  804a30:	00 00 00 
  804a33:	b8 00 00 00 00       	mov    $0x0,%eax
  804a38:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  804a3f:	00 00 00 
  804a42:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804a45:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804a4c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a4f:	48 89 d6             	mov    %rdx,%rsi
  804a52:	89 c7                	mov    %eax,%edi
  804a54:	48 b8 e0 2b 80 00 00 	movabs $0x802be0,%rax
  804a5b:	00 00 00 
  804a5e:	ff d0                	callq  *%rax
  804a60:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a63:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a67:	79 30                	jns    804a99 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804a69:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a6c:	89 c1                	mov    %eax,%ecx
  804a6e:	48 ba 7c 66 80 00 00 	movabs $0x80667c,%rdx
  804a75:	00 00 00 
  804a78:	be 85 00 00 00       	mov    $0x85,%esi
  804a7d:	48 bf 70 66 80 00 00 	movabs $0x806670,%rdi
  804a84:	00 00 00 
  804a87:	b8 00 00 00 00       	mov    $0x0,%eax
  804a8c:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  804a93:	00 00 00 
  804a96:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804a99:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a9c:	be 02 00 00 00       	mov    $0x2,%esi
  804aa1:	89 c7                	mov    %eax,%edi
  804aa3:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  804aaa:	00 00 00 
  804aad:	ff d0                	callq  *%rax
  804aaf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804ab6:	79 30                	jns    804ae8 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804ab8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804abb:	89 c1                	mov    %eax,%ecx
  804abd:	48 ba 96 66 80 00 00 	movabs $0x806696,%rdx
  804ac4:	00 00 00 
  804ac7:	be 88 00 00 00       	mov    $0x88,%esi
  804acc:	48 bf 70 66 80 00 00 	movabs $0x806670,%rdi
  804ad3:	00 00 00 
  804ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  804adb:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  804ae2:	00 00 00 
  804ae5:	41 ff d0             	callq  *%r8

	return child;
  804ae8:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804aeb:	c9                   	leaveq 
  804aec:	c3                   	retq   

0000000000804aed <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804aed:	55                   	push   %rbp
  804aee:	48 89 e5             	mov    %rsp,%rbp
  804af1:	41 55                	push   %r13
  804af3:	41 54                	push   %r12
  804af5:	53                   	push   %rbx
  804af6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804afd:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804b04:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804b0b:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804b12:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804b19:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804b20:	84 c0                	test   %al,%al
  804b22:	74 26                	je     804b4a <spawnl+0x5d>
  804b24:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804b2b:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804b32:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804b36:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804b3a:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804b3e:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804b42:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804b46:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804b4a:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804b51:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804b58:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804b5b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804b62:	00 00 00 
  804b65:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804b6c:	00 00 00 
  804b6f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b73:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804b7a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804b81:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804b88:	eb 07                	jmp    804b91 <spawnl+0xa4>
		argc++;
  804b8a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804b91:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804b97:	83 f8 30             	cmp    $0x30,%eax
  804b9a:	73 23                	jae    804bbf <spawnl+0xd2>
  804b9c:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804ba3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804ba9:	89 c0                	mov    %eax,%eax
  804bab:	48 01 d0             	add    %rdx,%rax
  804bae:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804bb4:	83 c2 08             	add    $0x8,%edx
  804bb7:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804bbd:	eb 15                	jmp    804bd4 <spawnl+0xe7>
  804bbf:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804bc6:	48 89 d0             	mov    %rdx,%rax
  804bc9:	48 83 c2 08          	add    $0x8,%rdx
  804bcd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804bd4:	48 8b 00             	mov    (%rax),%rax
  804bd7:	48 85 c0             	test   %rax,%rax
  804bda:	75 ae                	jne    804b8a <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804bdc:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804be2:	83 c0 02             	add    $0x2,%eax
  804be5:	48 89 e2             	mov    %rsp,%rdx
  804be8:	48 89 d3             	mov    %rdx,%rbx
  804beb:	48 63 d0             	movslq %eax,%rdx
  804bee:	48 83 ea 01          	sub    $0x1,%rdx
  804bf2:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804bf9:	48 63 d0             	movslq %eax,%rdx
  804bfc:	49 89 d4             	mov    %rdx,%r12
  804bff:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804c05:	48 63 d0             	movslq %eax,%rdx
  804c08:	49 89 d2             	mov    %rdx,%r10
  804c0b:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804c11:	48 98                	cltq   
  804c13:	48 c1 e0 03          	shl    $0x3,%rax
  804c17:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804c1b:	b8 10 00 00 00       	mov    $0x10,%eax
  804c20:	48 83 e8 01          	sub    $0x1,%rax
  804c24:	48 01 d0             	add    %rdx,%rax
  804c27:	bf 10 00 00 00       	mov    $0x10,%edi
  804c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  804c31:	48 f7 f7             	div    %rdi
  804c34:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804c38:	48 29 c4             	sub    %rax,%rsp
  804c3b:	48 89 e0             	mov    %rsp,%rax
  804c3e:	48 83 c0 07          	add    $0x7,%rax
  804c42:	48 c1 e8 03          	shr    $0x3,%rax
  804c46:	48 c1 e0 03          	shl    $0x3,%rax
  804c4a:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804c51:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c58:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804c5f:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804c62:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804c68:	8d 50 01             	lea    0x1(%rax),%edx
  804c6b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c72:	48 63 d2             	movslq %edx,%rdx
  804c75:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804c7c:	00 

	va_start(vl, arg0);
  804c7d:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804c84:	00 00 00 
  804c87:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804c8e:	00 00 00 
  804c91:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804c95:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804c9c:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804ca3:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804caa:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804cb1:	00 00 00 
  804cb4:	eb 63                	jmp    804d19 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804cb6:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804cbc:	8d 70 01             	lea    0x1(%rax),%esi
  804cbf:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804cc5:	83 f8 30             	cmp    $0x30,%eax
  804cc8:	73 23                	jae    804ced <spawnl+0x200>
  804cca:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804cd1:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804cd7:	89 c0                	mov    %eax,%eax
  804cd9:	48 01 d0             	add    %rdx,%rax
  804cdc:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804ce2:	83 c2 08             	add    $0x8,%edx
  804ce5:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804ceb:	eb 15                	jmp    804d02 <spawnl+0x215>
  804ced:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804cf4:	48 89 d0             	mov    %rdx,%rax
  804cf7:	48 83 c2 08          	add    $0x8,%rdx
  804cfb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804d02:	48 8b 08             	mov    (%rax),%rcx
  804d05:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804d0c:	89 f2                	mov    %esi,%edx
  804d0e:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804d12:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804d19:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804d1f:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804d25:	77 8f                	ja     804cb6 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804d27:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804d2e:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804d35:	48 89 d6             	mov    %rdx,%rsi
  804d38:	48 89 c7             	mov    %rax,%rdi
  804d3b:	48 b8 92 47 80 00 00 	movabs $0x804792,%rax
  804d42:	00 00 00 
  804d45:	ff d0                	callq  *%rax
  804d47:	48 89 dc             	mov    %rbx,%rsp
}
  804d4a:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804d4e:	5b                   	pop    %rbx
  804d4f:	41 5c                	pop    %r12
  804d51:	41 5d                	pop    %r13
  804d53:	5d                   	pop    %rbp
  804d54:	c3                   	retq   

0000000000804d55 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804d55:	55                   	push   %rbp
  804d56:	48 89 e5             	mov    %rsp,%rbp
  804d59:	48 83 ec 50          	sub    $0x50,%rsp
  804d5d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804d60:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804d64:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804d68:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d6f:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804d70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804d77:	eb 33                	jmp    804dac <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804d79:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d7c:	48 98                	cltq   
  804d7e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804d85:	00 
  804d86:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804d8a:	48 01 d0             	add    %rdx,%rax
  804d8d:	48 8b 00             	mov    (%rax),%rax
  804d90:	48 89 c7             	mov    %rax,%rdi
  804d93:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  804d9a:	00 00 00 
  804d9d:	ff d0                	callq  *%rax
  804d9f:	83 c0 01             	add    $0x1,%eax
  804da2:	48 98                	cltq   
  804da4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804da8:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804dac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804daf:	48 98                	cltq   
  804db1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804db8:	00 
  804db9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804dbd:	48 01 d0             	add    %rdx,%rax
  804dc0:	48 8b 00             	mov    (%rax),%rax
  804dc3:	48 85 c0             	test   %rax,%rax
  804dc6:	75 b1                	jne    804d79 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804dc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804dcc:	48 f7 d8             	neg    %rax
  804dcf:	48 05 00 10 40 00    	add    $0x401000,%rax
  804dd5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ddd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804de5:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804de9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804dec:	83 c2 01             	add    $0x1,%edx
  804def:	c1 e2 03             	shl    $0x3,%edx
  804df2:	48 63 d2             	movslq %edx,%rdx
  804df5:	48 f7 da             	neg    %rdx
  804df8:	48 01 d0             	add    %rdx,%rax
  804dfb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804dff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e03:	48 83 e8 10          	sub    $0x10,%rax
  804e07:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804e0d:	77 0a                	ja     804e19 <init_stack+0xc4>
		return -E_NO_MEM;
  804e0f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804e14:	e9 e3 01 00 00       	jmpq   804ffc <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804e19:	ba 07 00 00 00       	mov    $0x7,%edx
  804e1e:	be 00 00 40 00       	mov    $0x400000,%esi
  804e23:	bf 00 00 00 00       	mov    $0x0,%edi
  804e28:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  804e2f:	00 00 00 
  804e32:	ff d0                	callq  *%rax
  804e34:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804e37:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804e3b:	79 08                	jns    804e45 <init_stack+0xf0>
		return r;
  804e3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e40:	e9 b7 01 00 00       	jmpq   804ffc <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804e45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804e4c:	e9 8a 00 00 00       	jmpq   804edb <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804e51:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e54:	48 98                	cltq   
  804e56:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e5d:	00 
  804e5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e62:	48 01 c2             	add    %rax,%rdx
  804e65:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804e6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e6e:	48 01 c8             	add    %rcx,%rax
  804e71:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804e77:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  804e7a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e7d:	48 98                	cltq   
  804e7f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e86:	00 
  804e87:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804e8b:	48 01 d0             	add    %rdx,%rax
  804e8e:	48 8b 10             	mov    (%rax),%rdx
  804e91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e95:	48 89 d6             	mov    %rdx,%rsi
  804e98:	48 89 c7             	mov    %rax,%rdi
  804e9b:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  804ea2:	00 00 00 
  804ea5:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804ea7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804eaa:	48 98                	cltq   
  804eac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804eb3:	00 
  804eb4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804eb8:	48 01 d0             	add    %rdx,%rax
  804ebb:	48 8b 00             	mov    (%rax),%rax
  804ebe:	48 89 c7             	mov    %rax,%rdi
  804ec1:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  804ec8:	00 00 00 
  804ecb:	ff d0                	callq  *%rax
  804ecd:	48 98                	cltq   
  804ecf:	48 83 c0 01          	add    $0x1,%rax
  804ed3:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804ed7:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804edb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804ede:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804ee1:	0f 8c 6a ff ff ff    	jl     804e51 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804ee7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804eea:	48 98                	cltq   
  804eec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ef3:	00 
  804ef4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef8:	48 01 d0             	add    %rdx,%rax
  804efb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804f02:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804f09:	00 
  804f0a:	74 35                	je     804f41 <init_stack+0x1ec>
  804f0c:	48 b9 b0 66 80 00 00 	movabs $0x8066b0,%rcx
  804f13:	00 00 00 
  804f16:	48 ba d6 66 80 00 00 	movabs $0x8066d6,%rdx
  804f1d:	00 00 00 
  804f20:	be f1 00 00 00       	mov    $0xf1,%esi
  804f25:	48 bf 70 66 80 00 00 	movabs $0x806670,%rdi
  804f2c:	00 00 00 
  804f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  804f34:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  804f3b:	00 00 00 
  804f3e:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804f41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f45:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804f49:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f52:	48 01 c8             	add    %rcx,%rax
  804f55:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f5b:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804f5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f62:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804f66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f69:	48 98                	cltq   
  804f6b:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804f6e:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f77:	48 01 d0             	add    %rdx,%rax
  804f7a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f80:	48 89 c2             	mov    %rax,%rdx
  804f83:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f87:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804f8a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f8d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804f93:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f98:	89 c2                	mov    %eax,%edx
  804f9a:	be 00 00 40 00       	mov    $0x400000,%esi
  804f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  804fa4:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  804fab:	00 00 00 
  804fae:	ff d0                	callq  *%rax
  804fb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fb7:	79 02                	jns    804fbb <init_stack+0x266>
		goto error;
  804fb9:	eb 28                	jmp    804fe3 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804fbb:	be 00 00 40 00       	mov    $0x400000,%esi
  804fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  804fc5:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  804fcc:	00 00 00 
  804fcf:	ff d0                	callq  *%rax
  804fd1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fd8:	79 02                	jns    804fdc <init_stack+0x287>
		goto error;
  804fda:	eb 07                	jmp    804fe3 <init_stack+0x28e>

	return 0;
  804fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  804fe1:	eb 19                	jmp    804ffc <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804fe3:	be 00 00 40 00       	mov    $0x400000,%esi
  804fe8:	bf 00 00 00 00       	mov    $0x0,%edi
  804fed:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  804ff4:	00 00 00 
  804ff7:	ff d0                	callq  *%rax
	return r;
  804ff9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804ffc:	c9                   	leaveq 
  804ffd:	c3                   	retq   

0000000000804ffe <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  804ffe:	55                   	push   %rbp
  804fff:	48 89 e5             	mov    %rsp,%rbp
  805002:	48 83 ec 50          	sub    $0x50,%rsp
  805006:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805009:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80500d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  805011:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  805014:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  805018:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80501c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805020:	25 ff 0f 00 00       	and    $0xfff,%eax
  805025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80502c:	74 21                	je     80504f <map_segment+0x51>
		va -= i;
  80502e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805031:	48 98                	cltq   
  805033:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  805037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80503a:	48 98                	cltq   
  80503c:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805043:	48 98                	cltq   
  805045:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  805049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80504c:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80504f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805056:	e9 79 01 00 00       	jmpq   8051d4 <map_segment+0x1d6>
		if (i >= filesz) {
  80505b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80505e:	48 98                	cltq   
  805060:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805064:	72 3c                	jb     8050a2 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  805066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805069:	48 63 d0             	movslq %eax,%rdx
  80506c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805070:	48 01 d0             	add    %rdx,%rax
  805073:	48 89 c1             	mov    %rax,%rcx
  805076:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805079:	8b 55 10             	mov    0x10(%rbp),%edx
  80507c:	48 89 ce             	mov    %rcx,%rsi
  80507f:	89 c7                	mov    %eax,%edi
  805081:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  805088:	00 00 00 
  80508b:	ff d0                	callq  *%rax
  80508d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805090:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805094:	0f 89 33 01 00 00    	jns    8051cd <map_segment+0x1cf>
				return r;
  80509a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80509d:	e9 46 01 00 00       	jmpq   8051e8 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8050a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8050a7:	be 00 00 40 00       	mov    $0x400000,%esi
  8050ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8050b1:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  8050b8:	00 00 00 
  8050bb:	ff d0                	callq  *%rax
  8050bd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050c0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050c4:	79 08                	jns    8050ce <map_segment+0xd0>
				return r;
  8050c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050c9:	e9 1a 01 00 00       	jmpq   8051e8 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8050ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050d1:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8050d4:	01 c2                	add    %eax,%edx
  8050d6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8050d9:	89 d6                	mov    %edx,%esi
  8050db:	89 c7                	mov    %eax,%edi
  8050dd:	48 b8 73 3c 80 00 00 	movabs $0x803c73,%rax
  8050e4:	00 00 00 
  8050e7:	ff d0                	callq  *%rax
  8050e9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050f0:	79 08                	jns    8050fa <map_segment+0xfc>
				return r;
  8050f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050f5:	e9 ee 00 00 00       	jmpq   8051e8 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8050fa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  805101:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805104:	48 98                	cltq   
  805106:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80510a:	48 29 c2             	sub    %rax,%rdx
  80510d:	48 89 d0             	mov    %rdx,%rax
  805110:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  805114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805117:	48 63 d0             	movslq %eax,%rdx
  80511a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80511e:	48 39 c2             	cmp    %rax,%rdx
  805121:	48 0f 47 d0          	cmova  %rax,%rdx
  805125:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805128:	be 00 00 40 00       	mov    $0x400000,%esi
  80512d:	89 c7                	mov    %eax,%edi
  80512f:	48 b8 2a 3b 80 00 00 	movabs $0x803b2a,%rax
  805136:	00 00 00 
  805139:	ff d0                	callq  *%rax
  80513b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80513e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805142:	79 08                	jns    80514c <map_segment+0x14e>
				return r;
  805144:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805147:	e9 9c 00 00 00       	jmpq   8051e8 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80514c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80514f:	48 63 d0             	movslq %eax,%rdx
  805152:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805156:	48 01 d0             	add    %rdx,%rax
  805159:	48 89 c2             	mov    %rax,%rdx
  80515c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80515f:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805163:	48 89 d1             	mov    %rdx,%rcx
  805166:	89 c2                	mov    %eax,%edx
  805168:	be 00 00 40 00       	mov    $0x400000,%esi
  80516d:	bf 00 00 00 00       	mov    $0x0,%edi
  805172:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  805179:	00 00 00 
  80517c:	ff d0                	callq  *%rax
  80517e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805181:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805185:	79 30                	jns    8051b7 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  805187:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80518a:	89 c1                	mov    %eax,%ecx
  80518c:	48 ba eb 66 80 00 00 	movabs $0x8066eb,%rdx
  805193:	00 00 00 
  805196:	be 24 01 00 00       	mov    $0x124,%esi
  80519b:	48 bf 70 66 80 00 00 	movabs $0x806670,%rdi
  8051a2:	00 00 00 
  8051a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8051aa:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  8051b1:	00 00 00 
  8051b4:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8051b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8051bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8051c1:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  8051c8:	00 00 00 
  8051cb:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8051cd:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8051d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051d7:	48 98                	cltq   
  8051d9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8051dd:	0f 82 78 fe ff ff    	jb     80505b <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8051e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8051e8:	c9                   	leaveq 
  8051e9:	c3                   	retq   

00000000008051ea <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8051ea:	55                   	push   %rbp
  8051eb:	48 89 e5             	mov    %rsp,%rbp
  8051ee:	48 83 ec 70          	sub    $0x70,%rsp
  8051f2:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8051f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051fc:	00 
  8051fd:	e9 70 01 00 00       	jmpq   805372 <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  805202:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  805209:	01 00 00 
  80520c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805210:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805214:	83 e0 01             	and    $0x1,%eax
  805217:	48 85 c0             	test   %rax,%rax
  80521a:	0f 84 4d 01 00 00    	je     80536d <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  805220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805224:	48 c1 e0 09          	shl    $0x9,%rax
  805228:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80522c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  805233:	00 
  805234:	e9 26 01 00 00       	jmpq   80535f <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  805239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80523d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805241:	48 01 c2             	add    %rax,%rdx
  805244:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80524b:	01 00 00 
  80524e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805252:	83 e0 01             	and    $0x1,%eax
  805255:	48 85 c0             	test   %rax,%rax
  805258:	0f 84 fc 00 00 00    	je     80535a <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  80525e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805262:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805266:	48 01 d0             	add    %rdx,%rax
  805269:	48 c1 e0 09          	shl    $0x9,%rax
  80526d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  805271:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805278:	00 
  805279:	e9 ce 00 00 00       	jmpq   80534c <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  80527e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805282:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805286:	48 01 c2             	add    %rax,%rdx
  805289:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805290:	01 00 00 
  805293:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805297:	83 e0 01             	and    $0x1,%eax
  80529a:	48 85 c0             	test   %rax,%rax
  80529d:	0f 84 a4 00 00 00    	je     805347 <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  8052a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052a7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8052ab:	48 01 d0             	add    %rdx,%rax
  8052ae:	48 c1 e0 09          	shl    $0x9,%rax
  8052b2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  8052b6:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8052bd:	00 
  8052be:	eb 79                	jmp    805339 <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  8052c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052c4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8052c8:	48 01 d0             	add    %rdx,%rax
  8052cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  8052cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052d6:	01 00 00 
  8052d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8052dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8052e6:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  8052e9:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8052ec:	25 00 04 00 00       	and    $0x400,%eax
  8052f1:	85 c0                	test   %eax,%eax
  8052f3:	74 3f                	je     805334 <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  8052f5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8052f9:	48 c1 e0 0c          	shl    $0xc,%rax
  8052fd:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  805301:	8b 75 bc             	mov    -0x44(%rbp),%esi
  805304:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  805308:	8b 55 9c             	mov    -0x64(%rbp),%edx
  80530b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80530f:	41 89 f0             	mov    %esi,%r8d
  805312:	48 89 c6             	mov    %rax,%rsi
  805315:	bf 00 00 00 00       	mov    $0x0,%edi
  80531a:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  805321:	00 00 00 
  805324:	ff d0                	callq  *%rax
  805326:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  805329:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80532d:	79 05                	jns    805334 <copy_shared_pages+0x14a>
  80532f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  805332:	eb 4e                	jmp    805382 <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  805334:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  805339:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  805340:	00 
  805341:	0f 86 79 ff ff ff    	jbe    8052c0 <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  805347:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80534c:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  805353:	00 
  805354:	0f 86 24 ff ff ff    	jbe    80527e <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80535a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  80535f:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  805366:	00 
  805367:	0f 86 cc fe ff ff    	jbe    805239 <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  80536d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805372:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805377:	0f 84 85 fe ff ff    	je     805202 <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  80537d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805382:	c9                   	leaveq 
  805383:	c3                   	retq   

0000000000805384 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805384:	55                   	push   %rbp
  805385:	48 89 e5             	mov    %rsp,%rbp
  805388:	53                   	push   %rbx
  805389:	48 83 ec 38          	sub    $0x38,%rsp
  80538d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805391:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805395:	48 89 c7             	mov    %rax,%rdi
  805398:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  80539f:	00 00 00 
  8053a2:	ff d0                	callq  *%rax
  8053a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053ab:	0f 88 bf 01 00 00    	js     805570 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053b5:	ba 07 04 00 00       	mov    $0x407,%edx
  8053ba:	48 89 c6             	mov    %rax,%rsi
  8053bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8053c2:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  8053c9:	00 00 00 
  8053cc:	ff d0                	callq  *%rax
  8053ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053d5:	0f 88 95 01 00 00    	js     805570 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8053db:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8053df:	48 89 c7             	mov    %rax,%rdi
  8053e2:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  8053e9:	00 00 00 
  8053ec:	ff d0                	callq  *%rax
  8053ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053f5:	0f 88 5d 01 00 00    	js     805558 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053ff:	ba 07 04 00 00       	mov    $0x407,%edx
  805404:	48 89 c6             	mov    %rax,%rsi
  805407:	bf 00 00 00 00       	mov    $0x0,%edi
  80540c:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  805413:	00 00 00 
  805416:	ff d0                	callq  *%rax
  805418:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80541b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80541f:	0f 88 33 01 00 00    	js     805558 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805429:	48 89 c7             	mov    %rax,%rdi
  80542c:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  805433:	00 00 00 
  805436:	ff d0                	callq  *%rax
  805438:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80543c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805440:	ba 07 04 00 00       	mov    $0x407,%edx
  805445:	48 89 c6             	mov    %rax,%rsi
  805448:	bf 00 00 00 00       	mov    $0x0,%edi
  80544d:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  805454:	00 00 00 
  805457:	ff d0                	callq  *%rax
  805459:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80545c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805460:	79 05                	jns    805467 <pipe+0xe3>
		goto err2;
  805462:	e9 d9 00 00 00       	jmpq   805540 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805467:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80546b:	48 89 c7             	mov    %rax,%rdi
  80546e:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  805475:	00 00 00 
  805478:	ff d0                	callq  *%rax
  80547a:	48 89 c2             	mov    %rax,%rdx
  80547d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805481:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805487:	48 89 d1             	mov    %rdx,%rcx
  80548a:	ba 00 00 00 00       	mov    $0x0,%edx
  80548f:	48 89 c6             	mov    %rax,%rsi
  805492:	bf 00 00 00 00       	mov    $0x0,%edi
  805497:	48 b8 f0 2a 80 00 00 	movabs $0x802af0,%rax
  80549e:	00 00 00 
  8054a1:	ff d0                	callq  *%rax
  8054a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8054a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054aa:	79 1b                	jns    8054c7 <pipe+0x143>
		goto err3;
  8054ac:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8054ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054b1:	48 89 c6             	mov    %rax,%rsi
  8054b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8054b9:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  8054c0:	00 00 00 
  8054c3:	ff d0                	callq  *%rax
  8054c5:	eb 79                	jmp    805540 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8054c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054cb:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  8054d2:	00 00 00 
  8054d5:	8b 12                	mov    (%rdx),%edx
  8054d7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8054d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8054e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054e8:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  8054ef:	00 00 00 
  8054f2:	8b 12                	mov    (%rdx),%edx
  8054f4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8054f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054fa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805505:	48 89 c7             	mov    %rax,%rdi
  805508:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  80550f:	00 00 00 
  805512:	ff d0                	callq  *%rax
  805514:	89 c2                	mov    %eax,%edx
  805516:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80551a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80551c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805520:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805524:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805528:	48 89 c7             	mov    %rax,%rdi
  80552b:	48 b8 3d 35 80 00 00 	movabs $0x80353d,%rax
  805532:	00 00 00 
  805535:	ff d0                	callq  *%rax
  805537:	89 03                	mov    %eax,(%rbx)
	return 0;
  805539:	b8 00 00 00 00       	mov    $0x0,%eax
  80553e:	eb 33                	jmp    805573 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805540:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805544:	48 89 c6             	mov    %rax,%rsi
  805547:	bf 00 00 00 00       	mov    $0x0,%edi
  80554c:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  805553:	00 00 00 
  805556:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80555c:	48 89 c6             	mov    %rax,%rsi
  80555f:	bf 00 00 00 00       	mov    $0x0,%edi
  805564:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  80556b:	00 00 00 
  80556e:	ff d0                	callq  *%rax
err:
	return r;
  805570:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805573:	48 83 c4 38          	add    $0x38,%rsp
  805577:	5b                   	pop    %rbx
  805578:	5d                   	pop    %rbp
  805579:	c3                   	retq   

000000000080557a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80557a:	55                   	push   %rbp
  80557b:	48 89 e5             	mov    %rsp,%rbp
  80557e:	53                   	push   %rbx
  80557f:	48 83 ec 28          	sub    $0x28,%rsp
  805583:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805587:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80558b:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805592:	00 00 00 
  805595:	48 8b 00             	mov    (%rax),%rax
  805598:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80559e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8055a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8055a5:	48 89 c7             	mov    %rax,%rdi
  8055a8:	48 b8 ee 5c 80 00 00 	movabs $0x805cee,%rax
  8055af:	00 00 00 
  8055b2:	ff d0                	callq  *%rax
  8055b4:	89 c3                	mov    %eax,%ebx
  8055b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8055ba:	48 89 c7             	mov    %rax,%rdi
  8055bd:	48 b8 ee 5c 80 00 00 	movabs $0x805cee,%rax
  8055c4:	00 00 00 
  8055c7:	ff d0                	callq  *%rax
  8055c9:	39 c3                	cmp    %eax,%ebx
  8055cb:	0f 94 c0             	sete   %al
  8055ce:	0f b6 c0             	movzbl %al,%eax
  8055d1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8055d4:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  8055db:	00 00 00 
  8055de:	48 8b 00             	mov    (%rax),%rax
  8055e1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8055e7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8055ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055ed:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8055f0:	75 05                	jne    8055f7 <_pipeisclosed+0x7d>
			return ret;
  8055f2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8055f5:	eb 4f                	jmp    805646 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8055f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055fa:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8055fd:	74 42                	je     805641 <_pipeisclosed+0xc7>
  8055ff:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  805603:	75 3c                	jne    805641 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  805605:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  80560c:	00 00 00 
  80560f:	48 8b 00             	mov    (%rax),%rax
  805612:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  805618:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80561b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80561e:	89 c6                	mov    %eax,%esi
  805620:	48 bf 0d 67 80 00 00 	movabs $0x80670d,%rdi
  805627:	00 00 00 
  80562a:	b8 00 00 00 00       	mov    $0x0,%eax
  80562f:	49 b8 62 14 80 00 00 	movabs $0x801462,%r8
  805636:	00 00 00 
  805639:	41 ff d0             	callq  *%r8
	}
  80563c:	e9 4a ff ff ff       	jmpq   80558b <_pipeisclosed+0x11>
  805641:	e9 45 ff ff ff       	jmpq   80558b <_pipeisclosed+0x11>
}
  805646:	48 83 c4 28          	add    $0x28,%rsp
  80564a:	5b                   	pop    %rbx
  80564b:	5d                   	pop    %rbp
  80564c:	c3                   	retq   

000000000080564d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80564d:	55                   	push   %rbp
  80564e:	48 89 e5             	mov    %rsp,%rbp
  805651:	48 83 ec 30          	sub    $0x30,%rsp
  805655:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805658:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80565c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80565f:	48 89 d6             	mov    %rdx,%rsi
  805662:	89 c7                	mov    %eax,%edi
  805664:	48 b8 23 36 80 00 00 	movabs $0x803623,%rax
  80566b:	00 00 00 
  80566e:	ff d0                	callq  *%rax
  805670:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805673:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805677:	79 05                	jns    80567e <pipeisclosed+0x31>
		return r;
  805679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80567c:	eb 31                	jmp    8056af <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80567e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805682:	48 89 c7             	mov    %rax,%rdi
  805685:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  80568c:	00 00 00 
  80568f:	ff d0                	callq  *%rax
  805691:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  805695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805699:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80569d:	48 89 d6             	mov    %rdx,%rsi
  8056a0:	48 89 c7             	mov    %rax,%rdi
  8056a3:	48 b8 7a 55 80 00 00 	movabs $0x80557a,%rax
  8056aa:	00 00 00 
  8056ad:	ff d0                	callq  *%rax
}
  8056af:	c9                   	leaveq 
  8056b0:	c3                   	retq   

00000000008056b1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8056b1:	55                   	push   %rbp
  8056b2:	48 89 e5             	mov    %rsp,%rbp
  8056b5:	48 83 ec 40          	sub    $0x40,%rsp
  8056b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8056bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8056c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8056c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056c9:	48 89 c7             	mov    %rax,%rdi
  8056cc:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  8056d3:	00 00 00 
  8056d6:	ff d0                	callq  *%rax
  8056d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8056dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8056e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8056e4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8056eb:	00 
  8056ec:	e9 92 00 00 00       	jmpq   805783 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8056f1:	eb 41                	jmp    805734 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8056f3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8056f8:	74 09                	je     805703 <devpipe_read+0x52>
				return i;
  8056fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056fe:	e9 92 00 00 00       	jmpq   805795 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  805703:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80570b:	48 89 d6             	mov    %rdx,%rsi
  80570e:	48 89 c7             	mov    %rax,%rdi
  805711:	48 b8 7a 55 80 00 00 	movabs $0x80557a,%rax
  805718:	00 00 00 
  80571b:	ff d0                	callq  *%rax
  80571d:	85 c0                	test   %eax,%eax
  80571f:	74 07                	je     805728 <devpipe_read+0x77>
				return 0;
  805721:	b8 00 00 00 00       	mov    $0x0,%eax
  805726:	eb 6d                	jmp    805795 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  805728:	48 b8 62 2a 80 00 00 	movabs $0x802a62,%rax
  80572f:	00 00 00 
  805732:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  805734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805738:	8b 10                	mov    (%rax),%edx
  80573a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80573e:	8b 40 04             	mov    0x4(%rax),%eax
  805741:	39 c2                	cmp    %eax,%edx
  805743:	74 ae                	je     8056f3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  805745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805749:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80574d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  805751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805755:	8b 00                	mov    (%rax),%eax
  805757:	99                   	cltd   
  805758:	c1 ea 1b             	shr    $0x1b,%edx
  80575b:	01 d0                	add    %edx,%eax
  80575d:	83 e0 1f             	and    $0x1f,%eax
  805760:	29 d0                	sub    %edx,%eax
  805762:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805766:	48 98                	cltq   
  805768:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80576d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80576f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805773:	8b 00                	mov    (%rax),%eax
  805775:	8d 50 01             	lea    0x1(%rax),%edx
  805778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80577c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80577e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805787:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80578b:	0f 82 60 ff ff ff    	jb     8056f1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805795:	c9                   	leaveq 
  805796:	c3                   	retq   

0000000000805797 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  805797:	55                   	push   %rbp
  805798:	48 89 e5             	mov    %rsp,%rbp
  80579b:	48 83 ec 40          	sub    $0x40,%rsp
  80579f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8057a3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8057a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8057ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057af:	48 89 c7             	mov    %rax,%rdi
  8057b2:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  8057b9:	00 00 00 
  8057bc:	ff d0                	callq  *%rax
  8057be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8057c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8057ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8057d1:	00 
  8057d2:	e9 8e 00 00 00       	jmpq   805865 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8057d7:	eb 31                	jmp    80580a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8057d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057e1:	48 89 d6             	mov    %rdx,%rsi
  8057e4:	48 89 c7             	mov    %rax,%rdi
  8057e7:	48 b8 7a 55 80 00 00 	movabs $0x80557a,%rax
  8057ee:	00 00 00 
  8057f1:	ff d0                	callq  *%rax
  8057f3:	85 c0                	test   %eax,%eax
  8057f5:	74 07                	je     8057fe <devpipe_write+0x67>
				return 0;
  8057f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8057fc:	eb 79                	jmp    805877 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8057fe:	48 b8 62 2a 80 00 00 	movabs $0x802a62,%rax
  805805:	00 00 00 
  805808:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80580a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80580e:	8b 40 04             	mov    0x4(%rax),%eax
  805811:	48 63 d0             	movslq %eax,%rdx
  805814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805818:	8b 00                	mov    (%rax),%eax
  80581a:	48 98                	cltq   
  80581c:	48 83 c0 20          	add    $0x20,%rax
  805820:	48 39 c2             	cmp    %rax,%rdx
  805823:	73 b4                	jae    8057d9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  805825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805829:	8b 40 04             	mov    0x4(%rax),%eax
  80582c:	99                   	cltd   
  80582d:	c1 ea 1b             	shr    $0x1b,%edx
  805830:	01 d0                	add    %edx,%eax
  805832:	83 e0 1f             	and    $0x1f,%eax
  805835:	29 d0                	sub    %edx,%eax
  805837:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80583b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80583f:	48 01 ca             	add    %rcx,%rdx
  805842:	0f b6 0a             	movzbl (%rdx),%ecx
  805845:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805849:	48 98                	cltq   
  80584b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80584f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805853:	8b 40 04             	mov    0x4(%rax),%eax
  805856:	8d 50 01             	lea    0x1(%rax),%edx
  805859:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80585d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805860:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805869:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80586d:	0f 82 64 ff ff ff    	jb     8057d7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805873:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805877:	c9                   	leaveq 
  805878:	c3                   	retq   

0000000000805879 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805879:	55                   	push   %rbp
  80587a:	48 89 e5             	mov    %rsp,%rbp
  80587d:	48 83 ec 20          	sub    $0x20,%rsp
  805881:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805885:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80588d:	48 89 c7             	mov    %rax,%rdi
  805890:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  805897:	00 00 00 
  80589a:	ff d0                	callq  *%rax
  80589c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8058a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058a4:	48 be 20 67 80 00 00 	movabs $0x806720,%rsi
  8058ab:	00 00 00 
  8058ae:	48 89 c7             	mov    %rax,%rdi
  8058b1:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8058b8:	00 00 00 
  8058bb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8058bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058c1:	8b 50 04             	mov    0x4(%rax),%edx
  8058c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058c8:	8b 00                	mov    (%rax),%eax
  8058ca:	29 c2                	sub    %eax,%edx
  8058cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058d0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8058d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058da:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8058e1:	00 00 00 
	stat->st_dev = &devpipe;
  8058e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8058e8:	48 b9 c0 80 80 00 00 	movabs $0x8080c0,%rcx
  8058ef:	00 00 00 
  8058f2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8058f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8058fe:	c9                   	leaveq 
  8058ff:	c3                   	retq   

0000000000805900 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  805900:	55                   	push   %rbp
  805901:	48 89 e5             	mov    %rsp,%rbp
  805904:	48 83 ec 10          	sub    $0x10,%rsp
  805908:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80590c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805910:	48 89 c6             	mov    %rax,%rsi
  805913:	bf 00 00 00 00       	mov    $0x0,%edi
  805918:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  80591f:	00 00 00 
  805922:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  805924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805928:	48 89 c7             	mov    %rax,%rdi
  80592b:	48 b8 60 35 80 00 00 	movabs $0x803560,%rax
  805932:	00 00 00 
  805935:	ff d0                	callq  *%rax
  805937:	48 89 c6             	mov    %rax,%rsi
  80593a:	bf 00 00 00 00       	mov    $0x0,%edi
  80593f:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  805946:	00 00 00 
  805949:	ff d0                	callq  *%rax
}
  80594b:	c9                   	leaveq 
  80594c:	c3                   	retq   

000000000080594d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80594d:	55                   	push   %rbp
  80594e:	48 89 e5             	mov    %rsp,%rbp
  805951:	48 83 ec 20          	sub    $0x20,%rsp
  805955:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805958:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80595c:	75 35                	jne    805993 <wait+0x46>
  80595e:	48 b9 27 67 80 00 00 	movabs $0x806727,%rcx
  805965:	00 00 00 
  805968:	48 ba 32 67 80 00 00 	movabs $0x806732,%rdx
  80596f:	00 00 00 
  805972:	be 09 00 00 00       	mov    $0x9,%esi
  805977:	48 bf 47 67 80 00 00 	movabs $0x806747,%rdi
  80597e:	00 00 00 
  805981:	b8 00 00 00 00       	mov    $0x0,%eax
  805986:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  80598d:	00 00 00 
  805990:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805993:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805996:	25 ff 03 00 00       	and    $0x3ff,%eax
  80599b:	48 63 d0             	movslq %eax,%rdx
  80599e:	48 89 d0             	mov    %rdx,%rax
  8059a1:	48 c1 e0 03          	shl    $0x3,%rax
  8059a5:	48 01 d0             	add    %rdx,%rax
  8059a8:	48 c1 e0 05          	shl    $0x5,%rax
  8059ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8059b3:	00 00 00 
  8059b6:	48 01 d0             	add    %rdx,%rax
  8059b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8059bd:	eb 0c                	jmp    8059cb <wait+0x7e>
		sys_yield();
  8059bf:	48 b8 62 2a 80 00 00 	movabs $0x802a62,%rax
  8059c6:	00 00 00 
  8059c9:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8059cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8059cf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8059d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8059d8:	75 0e                	jne    8059e8 <wait+0x9b>
  8059da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8059de:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8059e4:	85 c0                	test   %eax,%eax
  8059e6:	75 d7                	jne    8059bf <wait+0x72>
		sys_yield();
}
  8059e8:	c9                   	leaveq 
  8059e9:	c3                   	retq   

00000000008059ea <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8059ea:	55                   	push   %rbp
  8059eb:	48 89 e5             	mov    %rsp,%rbp
  8059ee:	48 83 ec 10          	sub    $0x10,%rsp
  8059f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8059f6:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  8059fd:	00 00 00 
  805a00:	48 8b 00             	mov    (%rax),%rax
  805a03:	48 85 c0             	test   %rax,%rax
  805a06:	75 64                	jne    805a6c <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  805a08:	ba 07 00 00 00       	mov    $0x7,%edx
  805a0d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805a12:	bf 00 00 00 00       	mov    $0x0,%edi
  805a17:	48 b8 a0 2a 80 00 00 	movabs $0x802aa0,%rax
  805a1e:	00 00 00 
  805a21:	ff d0                	callq  *%rax
  805a23:	85 c0                	test   %eax,%eax
  805a25:	74 2a                	je     805a51 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  805a27:	48 ba 58 67 80 00 00 	movabs $0x806758,%rdx
  805a2e:	00 00 00 
  805a31:	be 22 00 00 00       	mov    $0x22,%esi
  805a36:	48 bf 80 67 80 00 00 	movabs $0x806780,%rdi
  805a3d:	00 00 00 
  805a40:	b8 00 00 00 00       	mov    $0x0,%eax
  805a45:	48 b9 29 12 80 00 00 	movabs $0x801229,%rcx
  805a4c:	00 00 00 
  805a4f:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  805a51:	48 be 7f 5a 80 00 00 	movabs $0x805a7f,%rsi
  805a58:	00 00 00 
  805a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  805a60:	48 b8 2a 2c 80 00 00 	movabs $0x802c2a,%rax
  805a67:	00 00 00 
  805a6a:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805a6c:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  805a73:	00 00 00 
  805a76:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805a7a:	48 89 10             	mov    %rdx,(%rax)
}
  805a7d:	c9                   	leaveq 
  805a7e:	c3                   	retq   

0000000000805a7f <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  805a7f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  805a82:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805a89:	00 00 00 
call *%rax
  805a8c:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  805a8e:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  805a95:	00 
mov 136(%rsp), %r9
  805a96:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  805a9d:	00 
sub $8, %r8
  805a9e:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  805aa2:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  805aa5:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  805aac:	00 
add $16, %rsp
  805aad:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  805ab1:	4c 8b 3c 24          	mov    (%rsp),%r15
  805ab5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805aba:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805abf:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805ac4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805ac9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805ace:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805ad3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805ad8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805add:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805ae2:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805ae7:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805aec:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805af1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805af6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805afb:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  805aff:	48 83 c4 08          	add    $0x8,%rsp
popf
  805b03:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  805b04:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  805b08:	c3                   	retq   

0000000000805b09 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805b09:	55                   	push   %rbp
  805b0a:	48 89 e5             	mov    %rsp,%rbp
  805b0d:	48 83 ec 30          	sub    $0x30,%rsp
  805b11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  805b1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805b22:	74 18                	je     805b3c <ipc_recv+0x33>
  805b24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b28:	48 89 c7             	mov    %rax,%rdi
  805b2b:	48 b8 c9 2c 80 00 00 	movabs $0x802cc9,%rax
  805b32:	00 00 00 
  805b35:	ff d0                	callq  *%rax
  805b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b3a:	eb 19                	jmp    805b55 <ipc_recv+0x4c>
  805b3c:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  805b43:	00 00 00 
  805b46:	48 b8 c9 2c 80 00 00 	movabs $0x802cc9,%rax
  805b4d:	00 00 00 
  805b50:	ff d0                	callq  *%rax
  805b52:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  805b55:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805b5a:	74 26                	je     805b82 <ipc_recv+0x79>
  805b5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b60:	75 15                	jne    805b77 <ipc_recv+0x6e>
  805b62:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805b69:	00 00 00 
  805b6c:	48 8b 00             	mov    (%rax),%rax
  805b6f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  805b75:	eb 05                	jmp    805b7c <ipc_recv+0x73>
  805b77:	b8 00 00 00 00       	mov    $0x0,%eax
  805b7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805b80:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  805b82:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805b87:	74 26                	je     805baf <ipc_recv+0xa6>
  805b89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b8d:	75 15                	jne    805ba4 <ipc_recv+0x9b>
  805b8f:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805b96:	00 00 00 
  805b99:	48 8b 00             	mov    (%rax),%rax
  805b9c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  805ba2:	eb 05                	jmp    805ba9 <ipc_recv+0xa0>
  805ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  805ba9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805bad:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  805baf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bb3:	75 15                	jne    805bca <ipc_recv+0xc1>
  805bb5:	48 b8 28 94 80 00 00 	movabs $0x809428,%rax
  805bbc:	00 00 00 
  805bbf:	48 8b 00             	mov    (%rax),%rax
  805bc2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  805bc8:	eb 03                	jmp    805bcd <ipc_recv+0xc4>
  805bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805bcd:	c9                   	leaveq 
  805bce:	c3                   	retq   

0000000000805bcf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805bcf:	55                   	push   %rbp
  805bd0:	48 89 e5             	mov    %rsp,%rbp
  805bd3:	48 83 ec 30          	sub    $0x30,%rsp
  805bd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805bda:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805bdd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805be1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  805be4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  805beb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805bf0:	75 10                	jne    805c02 <ipc_send+0x33>
  805bf2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805bf9:	00 00 00 
  805bfc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  805c00:	eb 62                	jmp    805c64 <ipc_send+0x95>
  805c02:	eb 60                	jmp    805c64 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  805c04:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805c08:	74 30                	je     805c3a <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  805c0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c0d:	89 c1                	mov    %eax,%ecx
  805c0f:	48 ba 8e 67 80 00 00 	movabs $0x80678e,%rdx
  805c16:	00 00 00 
  805c19:	be 33 00 00 00       	mov    $0x33,%esi
  805c1e:	48 bf aa 67 80 00 00 	movabs $0x8067aa,%rdi
  805c25:	00 00 00 
  805c28:	b8 00 00 00 00       	mov    $0x0,%eax
  805c2d:	49 b8 29 12 80 00 00 	movabs $0x801229,%r8
  805c34:	00 00 00 
  805c37:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  805c3a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805c3d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805c40:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805c44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c47:	89 c7                	mov    %eax,%edi
  805c49:	48 b8 74 2c 80 00 00 	movabs $0x802c74,%rax
  805c50:	00 00 00 
  805c53:	ff d0                	callq  *%rax
  805c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  805c58:	48 b8 62 2a 80 00 00 	movabs $0x802a62,%rax
  805c5f:	00 00 00 
  805c62:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  805c64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c68:	75 9a                	jne    805c04 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  805c6a:	c9                   	leaveq 
  805c6b:	c3                   	retq   

0000000000805c6c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805c6c:	55                   	push   %rbp
  805c6d:	48 89 e5             	mov    %rsp,%rbp
  805c70:	48 83 ec 14          	sub    $0x14,%rsp
  805c74:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805c77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805c7e:	eb 5e                	jmp    805cde <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  805c80:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805c87:	00 00 00 
  805c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c8d:	48 63 d0             	movslq %eax,%rdx
  805c90:	48 89 d0             	mov    %rdx,%rax
  805c93:	48 c1 e0 03          	shl    $0x3,%rax
  805c97:	48 01 d0             	add    %rdx,%rax
  805c9a:	48 c1 e0 05          	shl    $0x5,%rax
  805c9e:	48 01 c8             	add    %rcx,%rax
  805ca1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805ca7:	8b 00                	mov    (%rax),%eax
  805ca9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805cac:	75 2c                	jne    805cda <ipc_find_env+0x6e>
			return envs[i].env_id;
  805cae:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805cb5:	00 00 00 
  805cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cbb:	48 63 d0             	movslq %eax,%rdx
  805cbe:	48 89 d0             	mov    %rdx,%rax
  805cc1:	48 c1 e0 03          	shl    $0x3,%rax
  805cc5:	48 01 d0             	add    %rdx,%rax
  805cc8:	48 c1 e0 05          	shl    $0x5,%rax
  805ccc:	48 01 c8             	add    %rcx,%rax
  805ccf:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805cd5:	8b 40 08             	mov    0x8(%rax),%eax
  805cd8:	eb 12                	jmp    805cec <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805cda:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805cde:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805ce5:	7e 99                	jle    805c80 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805cec:	c9                   	leaveq 
  805ced:	c3                   	retq   

0000000000805cee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805cee:	55                   	push   %rbp
  805cef:	48 89 e5             	mov    %rsp,%rbp
  805cf2:	48 83 ec 18          	sub    $0x18,%rsp
  805cf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805cfe:	48 c1 e8 15          	shr    $0x15,%rax
  805d02:	48 89 c2             	mov    %rax,%rdx
  805d05:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805d0c:	01 00 00 
  805d0f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d13:	83 e0 01             	and    $0x1,%eax
  805d16:	48 85 c0             	test   %rax,%rax
  805d19:	75 07                	jne    805d22 <pageref+0x34>
		return 0;
  805d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  805d20:	eb 53                	jmp    805d75 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d26:	48 c1 e8 0c          	shr    $0xc,%rax
  805d2a:	48 89 c2             	mov    %rax,%rdx
  805d2d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805d34:	01 00 00 
  805d37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d43:	83 e0 01             	and    $0x1,%eax
  805d46:	48 85 c0             	test   %rax,%rax
  805d49:	75 07                	jne    805d52 <pageref+0x64>
		return 0;
  805d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  805d50:	eb 23                	jmp    805d75 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d56:	48 c1 e8 0c          	shr    $0xc,%rax
  805d5a:	48 89 c2             	mov    %rax,%rdx
  805d5d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805d64:	00 00 00 
  805d67:	48 c1 e2 04          	shl    $0x4,%rdx
  805d6b:	48 01 d0             	add    %rdx,%rax
  805d6e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805d72:	0f b7 c0             	movzwl %ax,%eax
}
  805d75:	c9                   	leaveq 
  805d76:	c3                   	retq   
