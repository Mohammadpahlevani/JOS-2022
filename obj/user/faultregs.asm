
obj/user/faultregs:     file format elf64-x86-64


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
  80003c:	e8 f5 09 00 00       	callq  800a36 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be e0 3f 80 00 00 	movabs $0x803fe0,%rsi
  80007b:	00 00 00 
  80007e:	48 bf e1 3f 80 00 00 	movabs $0x803fe1,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be f1 3f 80 00 00 	movabs $0x803ff1,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be 13 40 80 00 00 	movabs $0x804013,%rsi
  800147:	00 00 00 
  80014a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be 17 40 80 00 00 	movabs $0x804017,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be 1b 40 80 00 00 	movabs $0x80401b,%rsi
  800267:	00 00 00 
  80026a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be 1f 40 80 00 00 	movabs $0x80401f,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be 23 40 80 00 00 	movabs $0x804023,%rsi
  800387:	00 00 00 
  80038a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be 27 40 80 00 00 	movabs $0x804027,%rsi
  800417:	00 00 00 
  80041a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be 2b 40 80 00 00 	movabs $0x80402b,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be 2f 40 80 00 00 	movabs $0x80402f,%rsi
  80053d:	00 00 00 
  800540:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be 36 40 80 00 00 	movabs $0x804036,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK


	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf 3a 40 80 00 00 	movabs $0x80403a,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006b9:	74 43                	je     8006fe <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	49 89 d0             	mov    %rdx,%r8
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf 99 40 80 00 00 	movabs $0x804099,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 e9 0a 80 00 00 	movabs $0x800ae9,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800705:	00 00 00 
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  80071f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800723:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800727:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072b:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  80072f:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800733:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800737:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073b:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  80073f:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800743:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800747:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074b:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  80074f:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800753:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800757:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075b:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  80075f:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800763:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800767:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076b:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  80076f:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800773:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800777:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077b:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800782:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800791:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 aa 40 80 00 00 	movabs $0x8040aa,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 b8 40 80 00 00 	movabs $0x8040b8,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be bf 40 80 00 00 	movabs $0x8040bf,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba c6 40 80 00 00 	movabs $0x8040c6,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf 99 40 80 00 00 	movabs $0x804099,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 e9 0a 80 00 00 	movabs $0x800ae9,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <umain>:

void
umain(int argc, char **argv)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 10          	sub    $0x10,%rsp
  80087b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800882:	48 bf a0 06 80 00 00 	movabs $0x8006a0,%rdi
  800889:	00 00 00 
  80088c:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  8008a9:	00 00 00 
  8008ac:	50                   	push   %rax
  8008ad:	52                   	push   %rdx
  8008ae:	50                   	push   %rax
  8008af:	9c                   	pushfq 
  8008b0:	58                   	pop    %rax
  8008b1:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b7:	50                   	push   %rax
  8008b8:	9d                   	popfq  
  8008b9:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008be:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c5:	48 8d 04 25 11 09 80 	lea    0x800911,%rax
  8008cc:	00 
  8008cd:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d1:	58                   	pop    %rax
  8008d2:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d6:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008da:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008de:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e2:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e6:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ea:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008ee:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f2:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f6:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fa:	49 89 57 58          	mov    %rdx,0x58(%r15)
  8008fe:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800902:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800906:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800911:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800918:	2a 00 00 00 
  80091c:	4c 8b 3c 24          	mov    (%rsp),%r15
  800920:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800924:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800928:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092c:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800930:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800934:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800938:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093c:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800940:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800944:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800948:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094c:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800950:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800954:	49 89 47 70          	mov    %rax,0x70(%r15)
  800958:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  80095f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800964:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800968:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096c:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800970:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800974:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800978:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097c:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800980:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800984:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800988:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098c:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800990:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800994:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800998:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099c:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a3:	50                   	push   %rax
  8009a4:	9c                   	pushfq 
  8009a5:	58                   	pop    %rax
  8009a6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ab:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b2:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b3:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	83 f8 2a             	cmp    $0x2a,%eax
  8009bd:	74 1b                	je     8009da <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009bf:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 ff 40 80 00 00 	movabs $0x8040ff,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 10 41 80 00 00 	movabs $0x804110,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  800a11:	00 00 00 
  800a14:	48 be bf 40 80 00 00 	movabs $0x8040bf,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800a25:	00 00 00 
  800a28:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
}
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 10          	sub    $0x10,%rsp
  800a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800a45:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	48 98                	cltq   
  800a53:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a58:	48 89 c2             	mov    %rax,%rdx
  800a5b:	48 89 d0             	mov    %rdx,%rax
  800a5e:	48 c1 e0 03          	shl    $0x3,%rax
  800a62:	48 01 d0             	add    %rdx,%rax
  800a65:	48 c1 e0 05          	shl    $0x5,%rax
  800a69:	48 89 c2             	mov    %rax,%rdx
  800a6c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a73:	00 00 00 
  800a76:	48 01 c2             	add    %rax,%rdx
  800a79:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  800a80:	00 00 00 
  800a83:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a8a:	7e 14                	jle    800aa0 <libmain+0x6a>
		binaryname = argv[0];
  800a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a90:	48 8b 10             	mov    (%rax),%rdx
  800a93:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a9a:	00 00 00 
  800a9d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800aa0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa7:	48 89 d6             	mov    %rdx,%rsi
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ab8:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  800abf:	00 00 00 
  800ac2:	ff d0                	callq  *%rax
}
  800ac4:	c9                   	leaveq 
  800ac5:	c3                   	retq   

0000000000800ac6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac6:	55                   	push   %rbp
  800ac7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800aca:	48 b8 d3 28 80 00 00 	movabs $0x8028d3,%rax
  800ad1:	00 00 00 
  800ad4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ad6:	bf 00 00 00 00       	mov    $0x0,%edi
  800adb:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  800ae2:	00 00 00 
  800ae5:	ff d0                	callq  *%rax
}
  800ae7:	5d                   	pop    %rbp
  800ae8:	c3                   	retq   

0000000000800ae9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ae9:	55                   	push   %rbp
  800aea:	48 89 e5             	mov    %rsp,%rbp
  800aed:	53                   	push   %rbx
  800aee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800af5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800afc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b02:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b09:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b10:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b17:	84 c0                	test   %al,%al
  800b19:	74 23                	je     800b3e <_panic+0x55>
  800b1b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b22:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b26:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b2a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b2e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b32:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b36:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b3a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b3e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b45:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b4c:	00 00 00 
  800b4f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b56:	00 00 00 
  800b59:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b5d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b64:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b6b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b72:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800b79:	00 00 00 
  800b7c:	48 8b 18             	mov    (%rax),%rbx
  800b7f:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  800b86:	00 00 00 
  800b89:	ff d0                	callq  *%rax
  800b8b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b91:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b98:	41 89 c8             	mov    %ecx,%r8d
  800b9b:	48 89 d1             	mov    %rdx,%rcx
  800b9e:	48 89 da             	mov    %rbx,%rdx
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	48 bf 20 41 80 00 00 	movabs $0x804120,%rdi
  800baa:	00 00 00 
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	49 b9 22 0d 80 00 00 	movabs $0x800d22,%r9
  800bb9:	00 00 00 
  800bbc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bbf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bc6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
	cprintf("\n");
  800bdf:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  800be6:	00 00 00 
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800bf5:	00 00 00 
  800bf8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bfa:	cc                   	int3   
  800bfb:	eb fd                	jmp    800bfa <_panic+0x111>

0000000000800bfd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bfd:	55                   	push   %rbp
  800bfe:	48 89 e5             	mov    %rsp,%rbp
  800c01:	48 83 ec 10          	sub    $0x10,%rsp
  800c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	8b 00                	mov    (%rax),%eax
  800c12:	8d 48 01             	lea    0x1(%rax),%ecx
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	89 0a                	mov    %ecx,(%rdx)
  800c1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c24:	48 98                	cltq   
  800c26:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2e:	8b 00                	mov    (%rax),%eax
  800c30:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c35:	75 2c                	jne    800c63 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3b:	8b 00                	mov    (%rax),%eax
  800c3d:	48 98                	cltq   
  800c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c43:	48 83 c2 08          	add    $0x8,%rdx
  800c47:	48 89 c6             	mov    %rax,%rsi
  800c4a:	48 89 d7             	mov    %rdx,%rdi
  800c4d:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  800c54:	00 00 00 
  800c57:	ff d0                	callq  *%rax
        b->idx = 0;
  800c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c67:	8b 40 04             	mov    0x4(%rax),%eax
  800c6a:	8d 50 01             	lea    0x1(%rax),%edx
  800c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c71:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c74:	c9                   	leaveq 
  800c75:	c3                   	retq   

0000000000800c76 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c76:	55                   	push   %rbp
  800c77:	48 89 e5             	mov    %rsp,%rbp
  800c7a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c81:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c88:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c8f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c96:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c9d:	48 8b 0a             	mov    (%rdx),%rcx
  800ca0:	48 89 08             	mov    %rcx,(%rax)
  800ca3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800caf:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800cb3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cba:	00 00 00 
    b.cnt = 0;
  800cbd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cc4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cc7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cce:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cd5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cdc:	48 89 c6             	mov    %rax,%rsi
  800cdf:	48 bf fd 0b 80 00 00 	movabs $0x800bfd,%rdi
  800ce6:	00 00 00 
  800ce9:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cf5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cfb:	48 98                	cltq   
  800cfd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d04:	48 83 c2 08          	add    $0x8,%rdx
  800d08:	48 89 c6             	mov    %rax,%rsi
  800d0b:	48 89 d7             	mov    %rdx,%rdi
  800d0e:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  800d15:	00 00 00 
  800d18:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d1a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d20:	c9                   	leaveq 
  800d21:	c3                   	retq   

0000000000800d22 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d22:	55                   	push   %rbp
  800d23:	48 89 e5             	mov    %rsp,%rbp
  800d26:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d2d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d34:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d3b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d42:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d49:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d50:	84 c0                	test   %al,%al
  800d52:	74 20                	je     800d74 <cprintf+0x52>
  800d54:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d58:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d5c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d60:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d64:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d68:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d6c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d70:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d74:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d7b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d82:	00 00 00 
  800d85:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d8c:	00 00 00 
  800d8f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d9a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800da8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800daf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db6:	48 8b 0a             	mov    (%rdx),%rcx
  800db9:	48 89 08             	mov    %rcx,(%rax)
  800dbc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dcc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dd3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dda:	48 89 d6             	mov    %rdx,%rsi
  800ddd:	48 89 c7             	mov    %rax,%rdi
  800de0:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
  800dec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800df2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df8:	c9                   	leaveq 
  800df9:	c3                   	retq   

0000000000800dfa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dfa:	55                   	push   %rbp
  800dfb:	48 89 e5             	mov    %rsp,%rbp
  800dfe:	53                   	push   %rbx
  800dff:	48 83 ec 38          	sub    $0x38,%rsp
  800e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e0f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e12:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e16:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e1a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e1d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e21:	77 3b                	ja     800e5e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e23:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e26:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e2a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	48 f7 f3             	div    %rbx
  800e39:	48 89 c2             	mov    %rax,%rdx
  800e3c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e3f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e42:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	41 89 f9             	mov    %edi,%r9d
  800e4d:	48 89 c7             	mov    %rax,%rdi
  800e50:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800e57:	00 00 00 
  800e5a:	ff d0                	callq  *%rax
  800e5c:	eb 1e                	jmp    800e7c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e5e:	eb 12                	jmp    800e72 <printnum+0x78>
			putch(padc, putdat);
  800e60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e64:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6b:	48 89 ce             	mov    %rcx,%rsi
  800e6e:	89 d7                	mov    %edx,%edi
  800e70:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e72:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e76:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e7a:	7f e4                	jg     800e60 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e7c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e83:	ba 00 00 00 00       	mov    $0x0,%edx
  800e88:	48 f7 f1             	div    %rcx
  800e8b:	48 89 d0             	mov    %rdx,%rax
  800e8e:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  800e95:	00 00 00 
  800e98:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e9c:	0f be d0             	movsbl %al,%edx
  800e9f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 89 ce             	mov    %rcx,%rsi
  800eaa:	89 d7                	mov    %edx,%edi
  800eac:	ff d0                	callq  *%rax
}
  800eae:	48 83 c4 38          	add    $0x38,%rsp
  800eb2:	5b                   	pop    %rbx
  800eb3:	5d                   	pop    %rbp
  800eb4:	c3                   	retq   

0000000000800eb5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ec4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ec8:	7e 52                	jle    800f1c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	8b 00                	mov    (%rax),%eax
  800ed0:	83 f8 30             	cmp    $0x30,%eax
  800ed3:	73 24                	jae    800ef9 <getuint+0x44>
  800ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	8b 00                	mov    (%rax),%eax
  800ee3:	89 c0                	mov    %eax,%eax
  800ee5:	48 01 d0             	add    %rdx,%rax
  800ee8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eec:	8b 12                	mov    (%rdx),%edx
  800eee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ef1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef5:	89 0a                	mov    %ecx,(%rdx)
  800ef7:	eb 17                	jmp    800f10 <getuint+0x5b>
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f01:	48 89 d0             	mov    %rdx,%rax
  800f04:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f10:	48 8b 00             	mov    (%rax),%rax
  800f13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f17:	e9 a3 00 00 00       	jmpq   800fbf <getuint+0x10a>
	else if (lflag)
  800f1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f20:	74 4f                	je     800f71 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	8b 00                	mov    (%rax),%eax
  800f28:	83 f8 30             	cmp    $0x30,%eax
  800f2b:	73 24                	jae    800f51 <getuint+0x9c>
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	8b 00                	mov    (%rax),%eax
  800f3b:	89 c0                	mov    %eax,%eax
  800f3d:	48 01 d0             	add    %rdx,%rax
  800f40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f44:	8b 12                	mov    (%rdx),%edx
  800f46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4d:	89 0a                	mov    %ecx,(%rdx)
  800f4f:	eb 17                	jmp    800f68 <getuint+0xb3>
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f59:	48 89 d0             	mov    %rdx,%rax
  800f5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f68:	48 8b 00             	mov    (%rax),%rax
  800f6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f6f:	eb 4e                	jmp    800fbf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f75:	8b 00                	mov    (%rax),%eax
  800f77:	83 f8 30             	cmp    $0x30,%eax
  800f7a:	73 24                	jae    800fa0 <getuint+0xeb>
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	8b 00                	mov    (%rax),%eax
  800f8a:	89 c0                	mov    %eax,%eax
  800f8c:	48 01 d0             	add    %rdx,%rax
  800f8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f93:	8b 12                	mov    (%rdx),%edx
  800f95:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9c:	89 0a                	mov    %ecx,(%rdx)
  800f9e:	eb 17                	jmp    800fb7 <getuint+0x102>
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fa8:	48 89 d0             	mov    %rdx,%rax
  800fab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800faf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fb7:	8b 00                	mov    (%rax),%eax
  800fb9:	89 c0                	mov    %eax,%eax
  800fbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc3:	c9                   	leaveq 
  800fc4:	c3                   	retq   

0000000000800fc5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fc5:	55                   	push   %rbp
  800fc6:	48 89 e5             	mov    %rsp,%rbp
  800fc9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fd4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd8:	7e 52                	jle    80102c <getint+0x67>
		x=va_arg(*ap, long long);
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	8b 00                	mov    (%rax),%eax
  800fe0:	83 f8 30             	cmp    $0x30,%eax
  800fe3:	73 24                	jae    801009 <getint+0x44>
  800fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff1:	8b 00                	mov    (%rax),%eax
  800ff3:	89 c0                	mov    %eax,%eax
  800ff5:	48 01 d0             	add    %rdx,%rax
  800ff8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffc:	8b 12                	mov    (%rdx),%edx
  800ffe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801001:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801005:	89 0a                	mov    %ecx,(%rdx)
  801007:	eb 17                	jmp    801020 <getint+0x5b>
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801011:	48 89 d0             	mov    %rdx,%rax
  801014:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801018:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801020:	48 8b 00             	mov    (%rax),%rax
  801023:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801027:	e9 a3 00 00 00       	jmpq   8010cf <getint+0x10a>
	else if (lflag)
  80102c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801030:	74 4f                	je     801081 <getint+0xbc>
		x=va_arg(*ap, long);
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	8b 00                	mov    (%rax),%eax
  801038:	83 f8 30             	cmp    $0x30,%eax
  80103b:	73 24                	jae    801061 <getint+0x9c>
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	8b 00                	mov    (%rax),%eax
  80104b:	89 c0                	mov    %eax,%eax
  80104d:	48 01 d0             	add    %rdx,%rax
  801050:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801054:	8b 12                	mov    (%rdx),%edx
  801056:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801059:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105d:	89 0a                	mov    %ecx,(%rdx)
  80105f:	eb 17                	jmp    801078 <getint+0xb3>
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801069:	48 89 d0             	mov    %rdx,%rax
  80106c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801074:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801078:	48 8b 00             	mov    (%rax),%rax
  80107b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80107f:	eb 4e                	jmp    8010cf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	8b 00                	mov    (%rax),%eax
  801087:	83 f8 30             	cmp    $0x30,%eax
  80108a:	73 24                	jae    8010b0 <getint+0xeb>
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	8b 00                	mov    (%rax),%eax
  80109a:	89 c0                	mov    %eax,%eax
  80109c:	48 01 d0             	add    %rdx,%rax
  80109f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a3:	8b 12                	mov    (%rdx),%edx
  8010a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ac:	89 0a                	mov    %ecx,(%rdx)
  8010ae:	eb 17                	jmp    8010c7 <getint+0x102>
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010b8:	48 89 d0             	mov    %rdx,%rax
  8010bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010c7:	8b 00                	mov    (%rax),%eax
  8010c9:	48 98                	cltq   
  8010cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d3:	c9                   	leaveq 
  8010d4:	c3                   	retq   

00000000008010d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	41 54                	push   %r12
  8010db:	53                   	push   %rbx
  8010dc:	48 83 ec 60          	sub    $0x60,%rsp
  8010e0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010e4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010e8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010ec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010f4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010f8:	48 8b 0a             	mov    (%rdx),%rcx
  8010fb:	48 89 08             	mov    %rcx,(%rax)
  8010fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801102:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801106:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80110a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80110e:	eb 17                	jmp    801127 <vprintfmt+0x52>
			if (ch == '\0')
  801110:	85 db                	test   %ebx,%ebx
  801112:	0f 84 cc 04 00 00    	je     8015e4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801118:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80111c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801120:	48 89 d6             	mov    %rdx,%rsi
  801123:	89 df                	mov    %ebx,%edi
  801125:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801127:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80112b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801133:	0f b6 00             	movzbl (%rax),%eax
  801136:	0f b6 d8             	movzbl %al,%ebx
  801139:	83 fb 25             	cmp    $0x25,%ebx
  80113c:	75 d2                	jne    801110 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80113e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801142:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801149:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801150:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801157:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80115e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801162:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801166:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80116a:	0f b6 00             	movzbl (%rax),%eax
  80116d:	0f b6 d8             	movzbl %al,%ebx
  801170:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801173:	83 f8 55             	cmp    $0x55,%eax
  801176:	0f 87 34 04 00 00    	ja     8015b0 <vprintfmt+0x4db>
  80117c:	89 c0                	mov    %eax,%eax
  80117e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801185:	00 
  801186:	48 b8 78 43 80 00 00 	movabs $0x804378,%rax
  80118d:	00 00 00 
  801190:	48 01 d0             	add    %rdx,%rax
  801193:	48 8b 00             	mov    (%rax),%rax
  801196:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801198:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80119c:	eb c0                	jmp    80115e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80119e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011a2:	eb ba                	jmp    80115e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011ab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011ae:	89 d0                	mov    %edx,%eax
  8011b0:	c1 e0 02             	shl    $0x2,%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	01 c0                	add    %eax,%eax
  8011b7:	01 d8                	add    %ebx,%eax
  8011b9:	83 e8 30             	sub    $0x30,%eax
  8011bc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011c9:	83 fb 2f             	cmp    $0x2f,%ebx
  8011cc:	7e 0c                	jle    8011da <vprintfmt+0x105>
  8011ce:	83 fb 39             	cmp    $0x39,%ebx
  8011d1:	7f 07                	jg     8011da <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011d8:	eb d1                	jmp    8011ab <vprintfmt+0xd6>
			goto process_precision;
  8011da:	eb 58                	jmp    801234 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011dc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011df:	83 f8 30             	cmp    $0x30,%eax
  8011e2:	73 17                	jae    8011fb <vprintfmt+0x126>
  8011e4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011eb:	89 c0                	mov    %eax,%eax
  8011ed:	48 01 d0             	add    %rdx,%rax
  8011f0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011f3:	83 c2 08             	add    $0x8,%edx
  8011f6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011f9:	eb 0f                	jmp    80120a <vprintfmt+0x135>
  8011fb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011ff:	48 89 d0             	mov    %rdx,%rax
  801202:	48 83 c2 08          	add    $0x8,%rdx
  801206:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80120a:	8b 00                	mov    (%rax),%eax
  80120c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80120f:	eb 23                	jmp    801234 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801211:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801215:	79 0c                	jns    801223 <vprintfmt+0x14e>
				width = 0;
  801217:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80121e:	e9 3b ff ff ff       	jmpq   80115e <vprintfmt+0x89>
  801223:	e9 36 ff ff ff       	jmpq   80115e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801228:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80122f:	e9 2a ff ff ff       	jmpq   80115e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801234:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801238:	79 12                	jns    80124c <vprintfmt+0x177>
				width = precision, precision = -1;
  80123a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80123d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801240:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801247:	e9 12 ff ff ff       	jmpq   80115e <vprintfmt+0x89>
  80124c:	e9 0d ff ff ff       	jmpq   80115e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801251:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801255:	e9 04 ff ff ff       	jmpq   80115e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80125a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80125d:	83 f8 30             	cmp    $0x30,%eax
  801260:	73 17                	jae    801279 <vprintfmt+0x1a4>
  801262:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801266:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801269:	89 c0                	mov    %eax,%eax
  80126b:	48 01 d0             	add    %rdx,%rax
  80126e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801271:	83 c2 08             	add    $0x8,%edx
  801274:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801277:	eb 0f                	jmp    801288 <vprintfmt+0x1b3>
  801279:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80127d:	48 89 d0             	mov    %rdx,%rax
  801280:	48 83 c2 08          	add    $0x8,%rdx
  801284:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801288:	8b 10                	mov    (%rax),%edx
  80128a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80128e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801292:	48 89 ce             	mov    %rcx,%rsi
  801295:	89 d7                	mov    %edx,%edi
  801297:	ff d0                	callq  *%rax
			break;
  801299:	e9 40 03 00 00       	jmpq   8015de <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80129e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a1:	83 f8 30             	cmp    $0x30,%eax
  8012a4:	73 17                	jae    8012bd <vprintfmt+0x1e8>
  8012a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012ad:	89 c0                	mov    %eax,%eax
  8012af:	48 01 d0             	add    %rdx,%rax
  8012b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012b5:	83 c2 08             	add    $0x8,%edx
  8012b8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012bb:	eb 0f                	jmp    8012cc <vprintfmt+0x1f7>
  8012bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012c1:	48 89 d0             	mov    %rdx,%rax
  8012c4:	48 83 c2 08          	add    $0x8,%rdx
  8012c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012cc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012ce:	85 db                	test   %ebx,%ebx
  8012d0:	79 02                	jns    8012d4 <vprintfmt+0x1ff>
				err = -err;
  8012d2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012d4:	83 fb 15             	cmp    $0x15,%ebx
  8012d7:	7f 16                	jg     8012ef <vprintfmt+0x21a>
  8012d9:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  8012e0:	00 00 00 
  8012e3:	48 63 d3             	movslq %ebx,%rdx
  8012e6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012ea:	4d 85 e4             	test   %r12,%r12
  8012ed:	75 2e                	jne    80131d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012ef:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f7:	89 d9                	mov    %ebx,%ecx
  8012f9:	48 ba 61 43 80 00 00 	movabs $0x804361,%rdx
  801300:	00 00 00 
  801303:	48 89 c7             	mov    %rax,%rdi
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
  80130b:	49 b8 ed 15 80 00 00 	movabs $0x8015ed,%r8
  801312:	00 00 00 
  801315:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801318:	e9 c1 02 00 00       	jmpq   8015de <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80131d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801321:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801325:	4c 89 e1             	mov    %r12,%rcx
  801328:	48 ba 6a 43 80 00 00 	movabs $0x80436a,%rdx
  80132f:	00 00 00 
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
  80133a:	49 b8 ed 15 80 00 00 	movabs $0x8015ed,%r8
  801341:	00 00 00 
  801344:	41 ff d0             	callq  *%r8
			break;
  801347:	e9 92 02 00 00       	jmpq   8015de <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80134c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134f:	83 f8 30             	cmp    $0x30,%eax
  801352:	73 17                	jae    80136b <vprintfmt+0x296>
  801354:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801358:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80135b:	89 c0                	mov    %eax,%eax
  80135d:	48 01 d0             	add    %rdx,%rax
  801360:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801363:	83 c2 08             	add    $0x8,%edx
  801366:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801369:	eb 0f                	jmp    80137a <vprintfmt+0x2a5>
  80136b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80136f:	48 89 d0             	mov    %rdx,%rax
  801372:	48 83 c2 08          	add    $0x8,%rdx
  801376:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80137a:	4c 8b 20             	mov    (%rax),%r12
  80137d:	4d 85 e4             	test   %r12,%r12
  801380:	75 0a                	jne    80138c <vprintfmt+0x2b7>
				p = "(null)";
  801382:	49 bc 6d 43 80 00 00 	movabs $0x80436d,%r12
  801389:	00 00 00 
			if (width > 0 && padc != '-')
  80138c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801390:	7e 3f                	jle    8013d1 <vprintfmt+0x2fc>
  801392:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801396:	74 39                	je     8013d1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801398:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80139b:	48 98                	cltq   
  80139d:	48 89 c6             	mov    %rax,%rsi
  8013a0:	4c 89 e7             	mov    %r12,%rdi
  8013a3:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  8013aa:	00 00 00 
  8013ad:	ff d0                	callq  *%rax
  8013af:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013b2:	eb 17                	jmp    8013cb <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013b4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013b8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c0:	48 89 ce             	mov    %rcx,%rsi
  8013c3:	89 d7                	mov    %edx,%edi
  8013c5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013cf:	7f e3                	jg     8013b4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d1:	eb 37                	jmp    80140a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013d7:	74 1e                	je     8013f7 <vprintfmt+0x322>
  8013d9:	83 fb 1f             	cmp    $0x1f,%ebx
  8013dc:	7e 05                	jle    8013e3 <vprintfmt+0x30e>
  8013de:	83 fb 7e             	cmp    $0x7e,%ebx
  8013e1:	7e 14                	jle    8013f7 <vprintfmt+0x322>
					putch('?', putdat);
  8013e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013eb:	48 89 d6             	mov    %rdx,%rsi
  8013ee:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013f3:	ff d0                	callq  *%rax
  8013f5:	eb 0f                	jmp    801406 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ff:	48 89 d6             	mov    %rdx,%rsi
  801402:	89 df                	mov    %ebx,%edi
  801404:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801406:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80140a:	4c 89 e0             	mov    %r12,%rax
  80140d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	0f be d8             	movsbl %al,%ebx
  801417:	85 db                	test   %ebx,%ebx
  801419:	74 10                	je     80142b <vprintfmt+0x356>
  80141b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80141f:	78 b2                	js     8013d3 <vprintfmt+0x2fe>
  801421:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801425:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801429:	79 a8                	jns    8013d3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80142b:	eb 16                	jmp    801443 <vprintfmt+0x36e>
				putch(' ', putdat);
  80142d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801431:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801435:	48 89 d6             	mov    %rdx,%rsi
  801438:	bf 20 00 00 00       	mov    $0x20,%edi
  80143d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80143f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801443:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801447:	7f e4                	jg     80142d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801449:	e9 90 01 00 00       	jmpq   8015de <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80144e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801452:	be 03 00 00 00       	mov    $0x3,%esi
  801457:	48 89 c7             	mov    %rax,%rdi
  80145a:	48 b8 c5 0f 80 00 00 	movabs $0x800fc5,%rax
  801461:	00 00 00 
  801464:	ff d0                	callq  *%rax
  801466:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80146a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146e:	48 85 c0             	test   %rax,%rax
  801471:	79 1d                	jns    801490 <vprintfmt+0x3bb>
				putch('-', putdat);
  801473:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801477:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80147b:	48 89 d6             	mov    %rdx,%rsi
  80147e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801483:	ff d0                	callq  *%rax
				num = -(long long) num;
  801485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801489:	48 f7 d8             	neg    %rax
  80148c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801490:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801497:	e9 d5 00 00 00       	jmpq   801571 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80149c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014a0:	be 03 00 00 00       	mov    $0x3,%esi
  8014a5:	48 89 c7             	mov    %rax,%rdi
  8014a8:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  8014af:	00 00 00 
  8014b2:	ff d0                	callq  *%rax
  8014b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014b8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014bf:	e9 ad 00 00 00       	jmpq   801571 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  8014c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014c8:	be 03 00 00 00       	mov    $0x3,%esi
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  8014d7:	00 00 00 
  8014da:	ff d0                	callq  *%rax
  8014dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  8014e0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  8014e7:	e9 85 00 00 00       	jmpq   801571 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  8014ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f4:	48 89 d6             	mov    %rdx,%rsi
  8014f7:	bf 30 00 00 00       	mov    $0x30,%edi
  8014fc:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801502:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801506:	48 89 d6             	mov    %rdx,%rsi
  801509:	bf 78 00 00 00       	mov    $0x78,%edi
  80150e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801510:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801513:	83 f8 30             	cmp    $0x30,%eax
  801516:	73 17                	jae    80152f <vprintfmt+0x45a>
  801518:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80151c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151f:	89 c0                	mov    %eax,%eax
  801521:	48 01 d0             	add    %rdx,%rax
  801524:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801527:	83 c2 08             	add    $0x8,%edx
  80152a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80152d:	eb 0f                	jmp    80153e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80152f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801533:	48 89 d0             	mov    %rdx,%rax
  801536:	48 83 c2 08          	add    $0x8,%rdx
  80153a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80153e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801541:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801545:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80154c:	eb 23                	jmp    801571 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80154e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801552:	be 03 00 00 00       	mov    $0x3,%esi
  801557:	48 89 c7             	mov    %rax,%rdi
  80155a:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  801561:	00 00 00 
  801564:	ff d0                	callq  *%rax
  801566:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80156a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801571:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801576:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801579:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80157c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801580:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801584:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801588:	45 89 c1             	mov    %r8d,%r9d
  80158b:	41 89 f8             	mov    %edi,%r8d
  80158e:	48 89 c7             	mov    %rax,%rdi
  801591:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  801598:	00 00 00 
  80159b:	ff d0                	callq  *%rax
			break;
  80159d:	eb 3f                	jmp    8015de <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80159f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015a7:	48 89 d6             	mov    %rdx,%rsi
  8015aa:	89 df                	mov    %ebx,%edi
  8015ac:	ff d0                	callq  *%rax
			break;
  8015ae:	eb 2e                	jmp    8015de <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b8:	48 89 d6             	mov    %rdx,%rsi
  8015bb:	bf 25 00 00 00       	mov    $0x25,%edi
  8015c0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015c2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c7:	eb 05                	jmp    8015ce <vprintfmt+0x4f9>
  8015c9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015ce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015d2:	48 83 e8 01          	sub    $0x1,%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	3c 25                	cmp    $0x25,%al
  8015db:	75 ec                	jne    8015c9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8015dd:	90                   	nop
		}
	}
  8015de:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015df:	e9 43 fb ff ff       	jmpq   801127 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015e4:	48 83 c4 60          	add    $0x60,%rsp
  8015e8:	5b                   	pop    %rbx
  8015e9:	41 5c                	pop    %r12
  8015eb:	5d                   	pop    %rbp
  8015ec:	c3                   	retq   

00000000008015ed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015f8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015ff:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801606:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80160d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801614:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80161b:	84 c0                	test   %al,%al
  80161d:	74 20                	je     80163f <printfmt+0x52>
  80161f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801623:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801627:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80162b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80162f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801633:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801637:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80163b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80163f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801646:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80164d:	00 00 00 
  801650:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801657:	00 00 00 
  80165a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80165e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801665:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80166c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801673:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80167a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801681:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801688:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80168f:	48 89 c7             	mov    %rax,%rdi
  801692:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  801699:	00 00 00 
  80169c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80169e:	c9                   	leaveq 
  80169f:	c3                   	retq   

00000000008016a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016a0:	55                   	push   %rbp
  8016a1:	48 89 e5             	mov    %rsp,%rbp
  8016a4:	48 83 ec 10          	sub    $0x10,%rsp
  8016a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b3:	8b 40 10             	mov    0x10(%rax),%eax
  8016b6:	8d 50 01             	lea    0x1(%rax),%edx
  8016b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c4:	48 8b 10             	mov    (%rax),%rdx
  8016c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016cf:	48 39 c2             	cmp    %rax,%rdx
  8016d2:	73 17                	jae    8016eb <sprintputch+0x4b>
		*b->buf++ = ch;
  8016d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d8:	48 8b 00             	mov    (%rax),%rax
  8016db:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e3:	48 89 0a             	mov    %rcx,(%rdx)
  8016e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016e9:	88 10                	mov    %dl,(%rax)
}
  8016eb:	c9                   	leaveq 
  8016ec:	c3                   	retq   

00000000008016ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 50          	sub    $0x50,%rsp
  8016f5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016f9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016fc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801700:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801704:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801708:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80170c:	48 8b 0a             	mov    (%rdx),%rcx
  80170f:	48 89 08             	mov    %rcx,(%rax)
  801712:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801716:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80171a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80171e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801722:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801726:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80172a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80172d:	48 98                	cltq   
  80172f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801733:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801737:	48 01 d0             	add    %rdx,%rax
  80173a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80173e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801745:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80174a:	74 06                	je     801752 <vsnprintf+0x65>
  80174c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801750:	7f 07                	jg     801759 <vsnprintf+0x6c>
		return -E_INVAL;
  801752:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801757:	eb 2f                	jmp    801788 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801759:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80175d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801761:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801765:	48 89 c6             	mov    %rax,%rsi
  801768:	48 bf a0 16 80 00 00 	movabs $0x8016a0,%rdi
  80176f:	00 00 00 
  801772:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80177e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801782:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801785:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801788:	c9                   	leaveq 
  801789:	c3                   	retq   

000000000080178a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80178a:	55                   	push   %rbp
  80178b:	48 89 e5             	mov    %rsp,%rbp
  80178e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801795:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80179c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017b7:	84 c0                	test   %al,%al
  8017b9:	74 20                	je     8017db <snprintf+0x51>
  8017bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017db:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017e2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017e9:	00 00 00 
  8017ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017f3:	00 00 00 
  8017f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801801:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801808:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80180f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801816:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80181d:	48 8b 0a             	mov    (%rdx),%rcx
  801820:	48 89 08             	mov    %rcx,(%rax)
  801823:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801827:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80182b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80182f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801833:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80183a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801841:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801847:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80184e:	48 89 c7             	mov    %rax,%rdi
  801851:	48 b8 ed 16 80 00 00 	movabs $0x8016ed,%rax
  801858:	00 00 00 
  80185b:	ff d0                	callq  *%rax
  80185d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801863:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801869:	c9                   	leaveq 
  80186a:	c3                   	retq   

000000000080186b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80186b:	55                   	push   %rbp
  80186c:	48 89 e5             	mov    %rsp,%rbp
  80186f:	48 83 ec 18          	sub    $0x18,%rsp
  801873:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80187e:	eb 09                	jmp    801889 <strlen+0x1e>
		n++;
  801880:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801884:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	84 c0                	test   %al,%al
  801892:	75 ec                	jne    801880 <strlen+0x15>
		n++;
	return n;
  801894:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801897:	c9                   	leaveq 
  801898:	c3                   	retq   

0000000000801899 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 20          	sub    $0x20,%rsp
  8018a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018b0:	eb 0e                	jmp    8018c0 <strnlen+0x27>
		n++;
  8018b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018bb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018c5:	74 0b                	je     8018d2 <strnlen+0x39>
  8018c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018cb:	0f b6 00             	movzbl (%rax),%eax
  8018ce:	84 c0                	test   %al,%al
  8018d0:	75 e0                	jne    8018b2 <strnlen+0x19>
		n++;
	return n;
  8018d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 20          	sub    $0x20,%rsp
  8018df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018ef:	90                   	nop
  8018f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801900:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801904:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801908:	0f b6 12             	movzbl (%rdx),%edx
  80190b:	88 10                	mov    %dl,(%rax)
  80190d:	0f b6 00             	movzbl (%rax),%eax
  801910:	84 c0                	test   %al,%al
  801912:	75 dc                	jne    8018f0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
  80191e:	48 83 ec 20          	sub    $0x20,%rsp
  801922:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801926:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80192a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192e:	48 89 c7             	mov    %rax,%rdi
  801931:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
  80193d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801940:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801943:	48 63 d0             	movslq %eax,%rdx
  801946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80194a:	48 01 c2             	add    %rax,%rdx
  80194d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801951:	48 89 c6             	mov    %rax,%rsi
  801954:	48 89 d7             	mov    %rdx,%rdi
  801957:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  80195e:	00 00 00 
  801961:	ff d0                	callq  *%rax
	return dst;
  801963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	48 83 ec 28          	sub    $0x28,%rsp
  801971:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801975:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801979:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80197d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801981:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801985:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80198c:	00 
  80198d:	eb 2a                	jmp    8019b9 <strncpy+0x50>
		*dst++ = *src;
  80198f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801993:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801997:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80199b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80199f:	0f b6 12             	movzbl (%rdx),%edx
  8019a2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019a8:	0f b6 00             	movzbl (%rax),%eax
  8019ab:	84 c0                	test   %al,%al
  8019ad:	74 05                	je     8019b4 <strncpy+0x4b>
			src++;
  8019af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019c1:	72 cc                	jb     80198f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c7:	c9                   	leaveq 
  8019c8:	c3                   	retq   

00000000008019c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019c9:	55                   	push   %rbp
  8019ca:	48 89 e5             	mov    %rsp,%rbp
  8019cd:	48 83 ec 28          	sub    $0x28,%rsp
  8019d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019ea:	74 3d                	je     801a29 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019ec:	eb 1d                	jmp    801a0b <strlcpy+0x42>
			*dst++ = *src++;
  8019ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019fe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a02:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a06:	0f b6 12             	movzbl (%rdx),%edx
  801a09:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a0b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a10:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a15:	74 0b                	je     801a22 <strlcpy+0x59>
  801a17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a1b:	0f b6 00             	movzbl (%rax),%eax
  801a1e:	84 c0                	test   %al,%al
  801a20:	75 cc                	jne    8019ee <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a26:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a31:	48 29 c2             	sub    %rax,%rdx
  801a34:	48 89 d0             	mov    %rdx,%rax
}
  801a37:	c9                   	leaveq 
  801a38:	c3                   	retq   

0000000000801a39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a39:	55                   	push   %rbp
  801a3a:	48 89 e5             	mov    %rsp,%rbp
  801a3d:	48 83 ec 10          	sub    $0x10,%rsp
  801a41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a49:	eb 0a                	jmp    801a55 <strcmp+0x1c>
		p++, q++;
  801a4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a50:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	84 c0                	test   %al,%al
  801a5e:	74 12                	je     801a72 <strcmp+0x39>
  801a60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a64:	0f b6 10             	movzbl (%rax),%edx
  801a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6b:	0f b6 00             	movzbl (%rax),%eax
  801a6e:	38 c2                	cmp    %al,%dl
  801a70:	74 d9                	je     801a4b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a76:	0f b6 00             	movzbl (%rax),%eax
  801a79:	0f b6 d0             	movzbl %al,%edx
  801a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a80:	0f b6 00             	movzbl (%rax),%eax
  801a83:	0f b6 c0             	movzbl %al,%eax
  801a86:	29 c2                	sub    %eax,%edx
  801a88:	89 d0                	mov    %edx,%eax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 18          	sub    $0x18,%rsp
  801a94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a9c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801aa0:	eb 0f                	jmp    801ab1 <strncmp+0x25>
		n--, p++, q++;
  801aa2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801aa7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801aac:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ab1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ab6:	74 1d                	je     801ad5 <strncmp+0x49>
  801ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801abc:	0f b6 00             	movzbl (%rax),%eax
  801abf:	84 c0                	test   %al,%al
  801ac1:	74 12                	je     801ad5 <strncmp+0x49>
  801ac3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac7:	0f b6 10             	movzbl (%rax),%edx
  801aca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ace:	0f b6 00             	movzbl (%rax),%eax
  801ad1:	38 c2                	cmp    %al,%dl
  801ad3:	74 cd                	je     801aa2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ad5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ada:	75 07                	jne    801ae3 <strncmp+0x57>
		return 0;
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae1:	eb 18                	jmp    801afb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	0f b6 00             	movzbl (%rax),%eax
  801aea:	0f b6 d0             	movzbl %al,%edx
  801aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af1:	0f b6 00             	movzbl (%rax),%eax
  801af4:	0f b6 c0             	movzbl %al,%eax
  801af7:	29 c2                	sub    %eax,%edx
  801af9:	89 d0                	mov    %edx,%eax
}
  801afb:	c9                   	leaveq 
  801afc:	c3                   	retq   

0000000000801afd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801afd:	55                   	push   %rbp
  801afe:	48 89 e5             	mov    %rsp,%rbp
  801b01:	48 83 ec 0c          	sub    $0xc,%rsp
  801b05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b09:	89 f0                	mov    %esi,%eax
  801b0b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b0e:	eb 17                	jmp    801b27 <strchr+0x2a>
		if (*s == c)
  801b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b14:	0f b6 00             	movzbl (%rax),%eax
  801b17:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b1a:	75 06                	jne    801b22 <strchr+0x25>
			return (char *) s;
  801b1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b20:	eb 15                	jmp    801b37 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b22:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2b:	0f b6 00             	movzbl (%rax),%eax
  801b2e:	84 c0                	test   %al,%al
  801b30:	75 de                	jne    801b10 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leaveq 
  801b38:	c3                   	retq   

0000000000801b39 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	48 83 ec 0c          	sub    $0xc,%rsp
  801b41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b45:	89 f0                	mov    %esi,%eax
  801b47:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b4a:	eb 13                	jmp    801b5f <strfind+0x26>
		if (*s == c)
  801b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b50:	0f b6 00             	movzbl (%rax),%eax
  801b53:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b56:	75 02                	jne    801b5a <strfind+0x21>
			break;
  801b58:	eb 10                	jmp    801b6a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b5a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b63:	0f b6 00             	movzbl (%rax),%eax
  801b66:	84 c0                	test   %al,%al
  801b68:	75 e2                	jne    801b4c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b6e:	c9                   	leaveq 
  801b6f:	c3                   	retq   

0000000000801b70 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b70:	55                   	push   %rbp
  801b71:	48 89 e5             	mov    %rsp,%rbp
  801b74:	48 83 ec 18          	sub    $0x18,%rsp
  801b78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b7c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b83:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b88:	75 06                	jne    801b90 <memset+0x20>
		return v;
  801b8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8e:	eb 69                	jmp    801bf9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b94:	83 e0 03             	and    $0x3,%eax
  801b97:	48 85 c0             	test   %rax,%rax
  801b9a:	75 48                	jne    801be4 <memset+0x74>
  801b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba0:	83 e0 03             	and    $0x3,%eax
  801ba3:	48 85 c0             	test   %rax,%rax
  801ba6:	75 3c                	jne    801be4 <memset+0x74>
		c &= 0xFF;
  801ba8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801baf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb2:	c1 e0 18             	shl    $0x18,%eax
  801bb5:	89 c2                	mov    %eax,%edx
  801bb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bba:	c1 e0 10             	shl    $0x10,%eax
  801bbd:	09 c2                	or     %eax,%edx
  801bbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bc2:	c1 e0 08             	shl    $0x8,%eax
  801bc5:	09 d0                	or     %edx,%eax
  801bc7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bce:	48 c1 e8 02          	shr    $0x2,%rax
  801bd2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bdc:	48 89 d7             	mov    %rdx,%rdi
  801bdf:	fc                   	cld    
  801be0:	f3 ab                	rep stos %eax,%es:(%rdi)
  801be2:	eb 11                	jmp    801bf5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801be4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801beb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bef:	48 89 d7             	mov    %rdx,%rdi
  801bf2:	fc                   	cld    
  801bf3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bf9:	c9                   	leaveq 
  801bfa:	c3                   	retq   

0000000000801bfb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	48 83 ec 28          	sub    $0x28,%rsp
  801c03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c23:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c27:	0f 83 88 00 00 00    	jae    801cb5 <memmove+0xba>
  801c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c31:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c35:	48 01 d0             	add    %rdx,%rax
  801c38:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c3c:	76 77                	jbe    801cb5 <memmove+0xba>
		s += n;
  801c3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c42:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c52:	83 e0 03             	and    $0x3,%eax
  801c55:	48 85 c0             	test   %rax,%rax
  801c58:	75 3b                	jne    801c95 <memmove+0x9a>
  801c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5e:	83 e0 03             	and    $0x3,%eax
  801c61:	48 85 c0             	test   %rax,%rax
  801c64:	75 2f                	jne    801c95 <memmove+0x9a>
  801c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c6a:	83 e0 03             	and    $0x3,%eax
  801c6d:	48 85 c0             	test   %rax,%rax
  801c70:	75 23                	jne    801c95 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c76:	48 83 e8 04          	sub    $0x4,%rax
  801c7a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c7e:	48 83 ea 04          	sub    $0x4,%rdx
  801c82:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c86:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c8a:	48 89 c7             	mov    %rax,%rdi
  801c8d:	48 89 d6             	mov    %rdx,%rsi
  801c90:	fd                   	std    
  801c91:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c93:	eb 1d                	jmp    801cb2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ca5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca9:	48 89 d7             	mov    %rdx,%rdi
  801cac:	48 89 c1             	mov    %rax,%rcx
  801caf:	fd                   	std    
  801cb0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cb2:	fc                   	cld    
  801cb3:	eb 57                	jmp    801d0c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb9:	83 e0 03             	and    $0x3,%eax
  801cbc:	48 85 c0             	test   %rax,%rax
  801cbf:	75 36                	jne    801cf7 <memmove+0xfc>
  801cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc5:	83 e0 03             	and    $0x3,%eax
  801cc8:	48 85 c0             	test   %rax,%rax
  801ccb:	75 2a                	jne    801cf7 <memmove+0xfc>
  801ccd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd1:	83 e0 03             	and    $0x3,%eax
  801cd4:	48 85 c0             	test   %rax,%rax
  801cd7:	75 1e                	jne    801cf7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdd:	48 c1 e8 02          	shr    $0x2,%rax
  801ce1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cec:	48 89 c7             	mov    %rax,%rdi
  801cef:	48 89 d6             	mov    %rdx,%rsi
  801cf2:	fc                   	cld    
  801cf3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cf5:	eb 15                	jmp    801d0c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d03:	48 89 c7             	mov    %rax,%rdi
  801d06:	48 89 d6             	mov    %rdx,%rsi
  801d09:	fc                   	cld    
  801d0a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 18          	sub    $0x18,%rsp
  801d1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d2a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d32:	48 89 ce             	mov    %rcx,%rsi
  801d35:	48 89 c7             	mov    %rax,%rdi
  801d38:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 28          	sub    $0x28,%rsp
  801d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d6a:	eb 36                	jmp    801da2 <memcmp+0x5c>
		if (*s1 != *s2)
  801d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d70:	0f b6 10             	movzbl (%rax),%edx
  801d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d77:	0f b6 00             	movzbl (%rax),%eax
  801d7a:	38 c2                	cmp    %al,%dl
  801d7c:	74 1a                	je     801d98 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d82:	0f b6 00             	movzbl (%rax),%eax
  801d85:	0f b6 d0             	movzbl %al,%edx
  801d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8c:	0f b6 00             	movzbl (%rax),%eax
  801d8f:	0f b6 c0             	movzbl %al,%eax
  801d92:	29 c2                	sub    %eax,%edx
  801d94:	89 d0                	mov    %edx,%eax
  801d96:	eb 20                	jmp    801db8 <memcmp+0x72>
		s1++, s2++;
  801d98:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d9d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801daa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dae:	48 85 c0             	test   %rax,%rax
  801db1:	75 b9                	jne    801d6c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db8:	c9                   	leaveq 
  801db9:	c3                   	retq   

0000000000801dba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 28          	sub    $0x28,%rsp
  801dc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dc6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dc9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dd5:	48 01 d0             	add    %rdx,%rax
  801dd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801ddc:	eb 15                	jmp    801df3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de2:	0f b6 10             	movzbl (%rax),%edx
  801de5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de8:	38 c2                	cmp    %al,%dl
  801dea:	75 02                	jne    801dee <memfind+0x34>
			break;
  801dec:	eb 0f                	jmp    801dfd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801dee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801dfb:	72 e1                	jb     801dde <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e01:	c9                   	leaveq 
  801e02:	c3                   	retq   

0000000000801e03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e03:	55                   	push   %rbp
  801e04:	48 89 e5             	mov    %rsp,%rbp
  801e07:	48 83 ec 34          	sub    $0x34,%rsp
  801e0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e13:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e1d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e24:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e25:	eb 05                	jmp    801e2c <strtol+0x29>
		s++;
  801e27:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e30:	0f b6 00             	movzbl (%rax),%eax
  801e33:	3c 20                	cmp    $0x20,%al
  801e35:	74 f0                	je     801e27 <strtol+0x24>
  801e37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3b:	0f b6 00             	movzbl (%rax),%eax
  801e3e:	3c 09                	cmp    $0x9,%al
  801e40:	74 e5                	je     801e27 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e46:	0f b6 00             	movzbl (%rax),%eax
  801e49:	3c 2b                	cmp    $0x2b,%al
  801e4b:	75 07                	jne    801e54 <strtol+0x51>
		s++;
  801e4d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e52:	eb 17                	jmp    801e6b <strtol+0x68>
	else if (*s == '-')
  801e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e58:	0f b6 00             	movzbl (%rax),%eax
  801e5b:	3c 2d                	cmp    $0x2d,%al
  801e5d:	75 0c                	jne    801e6b <strtol+0x68>
		s++, neg = 1;
  801e5f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e64:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e6b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e6f:	74 06                	je     801e77 <strtol+0x74>
  801e71:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e75:	75 28                	jne    801e9f <strtol+0x9c>
  801e77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7b:	0f b6 00             	movzbl (%rax),%eax
  801e7e:	3c 30                	cmp    $0x30,%al
  801e80:	75 1d                	jne    801e9f <strtol+0x9c>
  801e82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e86:	48 83 c0 01          	add    $0x1,%rax
  801e8a:	0f b6 00             	movzbl (%rax),%eax
  801e8d:	3c 78                	cmp    $0x78,%al
  801e8f:	75 0e                	jne    801e9f <strtol+0x9c>
		s += 2, base = 16;
  801e91:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e96:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e9d:	eb 2c                	jmp    801ecb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ea3:	75 19                	jne    801ebe <strtol+0xbb>
  801ea5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea9:	0f b6 00             	movzbl (%rax),%eax
  801eac:	3c 30                	cmp    $0x30,%al
  801eae:	75 0e                	jne    801ebe <strtol+0xbb>
		s++, base = 8;
  801eb0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eb5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ebc:	eb 0d                	jmp    801ecb <strtol+0xc8>
	else if (base == 0)
  801ebe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ec2:	75 07                	jne    801ecb <strtol+0xc8>
		base = 10;
  801ec4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ecb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecf:	0f b6 00             	movzbl (%rax),%eax
  801ed2:	3c 2f                	cmp    $0x2f,%al
  801ed4:	7e 1d                	jle    801ef3 <strtol+0xf0>
  801ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eda:	0f b6 00             	movzbl (%rax),%eax
  801edd:	3c 39                	cmp    $0x39,%al
  801edf:	7f 12                	jg     801ef3 <strtol+0xf0>
			dig = *s - '0';
  801ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee5:	0f b6 00             	movzbl (%rax),%eax
  801ee8:	0f be c0             	movsbl %al,%eax
  801eeb:	83 e8 30             	sub    $0x30,%eax
  801eee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef1:	eb 4e                	jmp    801f41 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ef3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef7:	0f b6 00             	movzbl (%rax),%eax
  801efa:	3c 60                	cmp    $0x60,%al
  801efc:	7e 1d                	jle    801f1b <strtol+0x118>
  801efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f02:	0f b6 00             	movzbl (%rax),%eax
  801f05:	3c 7a                	cmp    $0x7a,%al
  801f07:	7f 12                	jg     801f1b <strtol+0x118>
			dig = *s - 'a' + 10;
  801f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0d:	0f b6 00             	movzbl (%rax),%eax
  801f10:	0f be c0             	movsbl %al,%eax
  801f13:	83 e8 57             	sub    $0x57,%eax
  801f16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f19:	eb 26                	jmp    801f41 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1f:	0f b6 00             	movzbl (%rax),%eax
  801f22:	3c 40                	cmp    $0x40,%al
  801f24:	7e 48                	jle    801f6e <strtol+0x16b>
  801f26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f2a:	0f b6 00             	movzbl (%rax),%eax
  801f2d:	3c 5a                	cmp    $0x5a,%al
  801f2f:	7f 3d                	jg     801f6e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f35:	0f b6 00             	movzbl (%rax),%eax
  801f38:	0f be c0             	movsbl %al,%eax
  801f3b:	83 e8 37             	sub    $0x37,%eax
  801f3e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f44:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f47:	7c 02                	jl     801f4b <strtol+0x148>
			break;
  801f49:	eb 23                	jmp    801f6e <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f4b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f50:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f53:	48 98                	cltq   
  801f55:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f5a:	48 89 c2             	mov    %rax,%rdx
  801f5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f60:	48 98                	cltq   
  801f62:	48 01 d0             	add    %rdx,%rax
  801f65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f69:	e9 5d ff ff ff       	jmpq   801ecb <strtol+0xc8>

	if (endptr)
  801f6e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f73:	74 0b                	je     801f80 <strtol+0x17d>
		*endptr = (char *) s;
  801f75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f7d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f84:	74 09                	je     801f8f <strtol+0x18c>
  801f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8a:	48 f7 d8             	neg    %rax
  801f8d:	eb 04                	jmp    801f93 <strtol+0x190>
  801f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <strstr>:

char * strstr(const char *in, const char *str)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 30          	sub    $0x30,%rsp
  801f9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fa1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fb1:	0f b6 00             	movzbl (%rax),%eax
  801fb4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fb7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fbb:	75 06                	jne    801fc3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc1:	eb 6b                	jmp    80202e <strstr+0x99>

	len = strlen(str);
  801fc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc7:	48 89 c7             	mov    %rax,%rdi
  801fca:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  801fd1:	00 00 00 
  801fd4:	ff d0                	callq  *%rax
  801fd6:	48 98                	cltq   
  801fd8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fdc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fe4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe8:	0f b6 00             	movzbl (%rax),%eax
  801feb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801fee:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ff2:	75 07                	jne    801ffb <strstr+0x66>
				return (char *) 0;
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff9:	eb 33                	jmp    80202e <strstr+0x99>
		} while (sc != c);
  801ffb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801fff:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802002:	75 d8                	jne    801fdc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802004:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802008:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80200c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802010:	48 89 ce             	mov    %rcx,%rsi
  802013:	48 89 c7             	mov    %rax,%rdi
  802016:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax
  802022:	85 c0                	test   %eax,%eax
  802024:	75 b6                	jne    801fdc <strstr+0x47>

	return (char *) (in - 1);
  802026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202a:	48 83 e8 01          	sub    $0x1,%rax
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	53                   	push   %rbx
  802035:	48 83 ec 48          	sub    $0x48,%rsp
  802039:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80203c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80203f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802043:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802047:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80204b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80204f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802052:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802056:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80205a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80205e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802062:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802066:	4c 89 c3             	mov    %r8,%rbx
  802069:	cd 30                	int    $0x30
  80206b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80206f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802073:	74 3e                	je     8020b3 <syscall+0x83>
  802075:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80207a:	7e 37                	jle    8020b3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80207c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802080:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802083:	49 89 d0             	mov    %rdx,%r8
  802086:	89 c1                	mov    %eax,%ecx
  802088:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  80208f:	00 00 00 
  802092:	be 4a 00 00 00       	mov    $0x4a,%esi
  802097:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  80209e:	00 00 00 
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a6:	49 b9 e9 0a 80 00 00 	movabs $0x800ae9,%r9
  8020ad:	00 00 00 
  8020b0:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8020b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020b7:	48 83 c4 48          	add    $0x48,%rsp
  8020bb:	5b                   	pop    %rbx
  8020bc:	5d                   	pop    %rbp
  8020bd:	c3                   	retq   

00000000008020be <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020be:	55                   	push   %rbp
  8020bf:	48 89 e5             	mov    %rsp,%rbp
  8020c2:	48 83 ec 20          	sub    $0x20,%rsp
  8020c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020dd:	00 
  8020de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020ea:	48 89 d1             	mov    %rdx,%rcx
  8020ed:	48 89 c2             	mov    %rax,%rdx
  8020f0:	be 00 00 00 00       	mov    $0x0,%esi
  8020f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fa:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
}
  802106:	c9                   	leaveq 
  802107:	c3                   	retq   

0000000000802108 <sys_cgetc>:

int
sys_cgetc(void)
{
  802108:	55                   	push   %rbp
  802109:	48 89 e5             	mov    %rsp,%rbp
  80210c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802110:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802117:	00 
  802118:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80211e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802124:	b9 00 00 00 00       	mov    $0x0,%ecx
  802129:	ba 00 00 00 00       	mov    $0x0,%edx
  80212e:	be 00 00 00 00       	mov    $0x0,%esi
  802133:	bf 01 00 00 00       	mov    $0x1,%edi
  802138:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
}
  802144:	c9                   	leaveq 
  802145:	c3                   	retq   

0000000000802146 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802146:	55                   	push   %rbp
  802147:	48 89 e5             	mov    %rsp,%rbp
  80214a:	48 83 ec 10          	sub    $0x10,%rsp
  80214e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802154:	48 98                	cltq   
  802156:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80215d:	00 
  80215e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802164:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80216a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80216f:	48 89 c2             	mov    %rax,%rdx
  802172:	be 01 00 00 00       	mov    $0x1,%esi
  802177:	bf 03 00 00 00       	mov    $0x3,%edi
  80217c:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
}
  802188:	c9                   	leaveq 
  802189:	c3                   	retq   

000000000080218a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80218a:	55                   	push   %rbp
  80218b:	48 89 e5             	mov    %rsp,%rbp
  80218e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802192:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802199:	00 
  80219a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	be 00 00 00 00       	mov    $0x0,%esi
  8021b5:	bf 02 00 00 00       	mov    $0x2,%edi
  8021ba:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
}
  8021c6:	c9                   	leaveq 
  8021c7:	c3                   	retq   

00000000008021c8 <sys_yield>:

void
sys_yield(void)
{
  8021c8:	55                   	push   %rbp
  8021c9:	48 89 e5             	mov    %rsp,%rbp
  8021cc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d7:	00 
  8021d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ee:	be 00 00 00 00       	mov    $0x0,%esi
  8021f3:	bf 0b 00 00 00       	mov    $0xb,%edi
  8021f8:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8021ff:	00 00 00 
  802202:	ff d0                	callq  *%rax
}
  802204:	c9                   	leaveq 
  802205:	c3                   	retq   

0000000000802206 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802206:	55                   	push   %rbp
  802207:	48 89 e5             	mov    %rsp,%rbp
  80220a:	48 83 ec 20          	sub    $0x20,%rsp
  80220e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802211:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802215:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802218:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80221b:	48 63 c8             	movslq %eax,%rcx
  80221e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802222:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802225:	48 98                	cltq   
  802227:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80222e:	00 
  80222f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802235:	49 89 c8             	mov    %rcx,%r8
  802238:	48 89 d1             	mov    %rdx,%rcx
  80223b:	48 89 c2             	mov    %rax,%rdx
  80223e:	be 01 00 00 00       	mov    $0x1,%esi
  802243:	bf 04 00 00 00       	mov    $0x4,%edi
  802248:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
}
  802254:	c9                   	leaveq 
  802255:	c3                   	retq   

0000000000802256 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802256:	55                   	push   %rbp
  802257:	48 89 e5             	mov    %rsp,%rbp
  80225a:	48 83 ec 30          	sub    $0x30,%rsp
  80225e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802261:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802265:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802268:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80226c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802270:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802273:	48 63 c8             	movslq %eax,%rcx
  802276:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80227a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80227d:	48 63 f0             	movslq %eax,%rsi
  802280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802284:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802287:	48 98                	cltq   
  802289:	48 89 0c 24          	mov    %rcx,(%rsp)
  80228d:	49 89 f9             	mov    %rdi,%r9
  802290:	49 89 f0             	mov    %rsi,%r8
  802293:	48 89 d1             	mov    %rdx,%rcx
  802296:	48 89 c2             	mov    %rax,%rdx
  802299:	be 01 00 00 00       	mov    $0x1,%esi
  80229e:	bf 05 00 00 00       	mov    $0x5,%edi
  8022a3:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	callq  *%rax
}
  8022af:	c9                   	leaveq 
  8022b0:	c3                   	retq   

00000000008022b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022b1:	55                   	push   %rbp
  8022b2:	48 89 e5             	mov    %rsp,%rbp
  8022b5:	48 83 ec 20          	sub    $0x20,%rsp
  8022b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c7:	48 98                	cltq   
  8022c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022d0:	00 
  8022d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022dd:	48 89 d1             	mov    %rdx,%rcx
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	be 01 00 00 00       	mov    $0x1,%esi
  8022e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8022ed:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
}
  8022f9:	c9                   	leaveq 
  8022fa:	c3                   	retq   

00000000008022fb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022fb:	55                   	push   %rbp
  8022fc:	48 89 e5             	mov    %rsp,%rbp
  8022ff:	48 83 ec 10          	sub    $0x10,%rsp
  802303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802306:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802309:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80230c:	48 63 d0             	movslq %eax,%rdx
  80230f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802312:	48 98                	cltq   
  802314:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80231b:	00 
  80231c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802322:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802328:	48 89 d1             	mov    %rdx,%rcx
  80232b:	48 89 c2             	mov    %rax,%rdx
  80232e:	be 01 00 00 00       	mov    $0x1,%esi
  802333:	bf 08 00 00 00       	mov    $0x8,%edi
  802338:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax
}
  802344:	c9                   	leaveq 
  802345:	c3                   	retq   

0000000000802346 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802346:	55                   	push   %rbp
  802347:	48 89 e5             	mov    %rsp,%rbp
  80234a:	48 83 ec 20          	sub    $0x20,%rsp
  80234e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802351:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802355:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802365:	00 
  802366:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80236c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802372:	48 89 d1             	mov    %rdx,%rcx
  802375:	48 89 c2             	mov    %rax,%rdx
  802378:	be 01 00 00 00       	mov    $0x1,%esi
  80237d:	bf 09 00 00 00       	mov    $0x9,%edi
  802382:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
}
  80238e:	c9                   	leaveq 
  80238f:	c3                   	retq   

0000000000802390 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802390:	55                   	push   %rbp
  802391:	48 89 e5             	mov    %rsp,%rbp
  802394:	48 83 ec 20          	sub    $0x20,%rsp
  802398:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80239b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80239f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a6:	48 98                	cltq   
  8023a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023af:	00 
  8023b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023bc:	48 89 d1             	mov    %rdx,%rcx
  8023bf:	48 89 c2             	mov    %rax,%rdx
  8023c2:	be 01 00 00 00       	mov    $0x1,%esi
  8023c7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023cc:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax
}
  8023d8:	c9                   	leaveq 
  8023d9:	c3                   	retq   

00000000008023da <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023da:	55                   	push   %rbp
  8023db:	48 89 e5             	mov    %rsp,%rbp
  8023de:	48 83 ec 20          	sub    $0x20,%rsp
  8023e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023ed:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023f3:	48 63 f0             	movslq %eax,%rsi
  8023f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	48 98                	cltq   
  8023ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802403:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80240a:	00 
  80240b:	49 89 f1             	mov    %rsi,%r9
  80240e:	49 89 c8             	mov    %rcx,%r8
  802411:	48 89 d1             	mov    %rdx,%rcx
  802414:	48 89 c2             	mov    %rax,%rdx
  802417:	be 00 00 00 00       	mov    $0x0,%esi
  80241c:	bf 0c 00 00 00       	mov    $0xc,%edi
  802421:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
}
  80242d:	c9                   	leaveq 
  80242e:	c3                   	retq   

000000000080242f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80242f:	55                   	push   %rbp
  802430:	48 89 e5             	mov    %rsp,%rbp
  802433:	48 83 ec 10          	sub    $0x10,%rsp
  802437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80243b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802446:	00 
  802447:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80244d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802453:	b9 00 00 00 00       	mov    $0x0,%ecx
  802458:	48 89 c2             	mov    %rax,%rdx
  80245b:	be 01 00 00 00       	mov    $0x1,%esi
  802460:	bf 0d 00 00 00       	mov    $0xd,%edi
  802465:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	callq  *%rax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 10          	sub    $0x10,%rsp
  80247b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80247f:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  802486:	00 00 00 
  802489:	48 8b 00             	mov    (%rax),%rax
  80248c:	48 85 c0             	test   %rax,%rax
  80248f:	75 64                	jne    8024f5 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  802491:	ba 07 00 00 00       	mov    $0x7,%edx
  802496:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80249b:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a0:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 2a                	je     8024da <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  8024b0:	48 ba 58 46 80 00 00 	movabs $0x804658,%rdx
  8024b7:	00 00 00 
  8024ba:	be 22 00 00 00       	mov    $0x22,%esi
  8024bf:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  8024c6:	00 00 00 
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	48 b9 e9 0a 80 00 00 	movabs $0x800ae9,%rcx
  8024d5:	00 00 00 
  8024d8:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8024da:	48 be 08 25 80 00 00 	movabs $0x802508,%rsi
  8024e1:	00 00 00 
  8024e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e9:	48 b8 90 23 80 00 00 	movabs $0x802390,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024f5:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  8024fc:	00 00 00 
  8024ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802503:	48 89 10             	mov    %rdx,(%rax)
}
  802506:	c9                   	leaveq 
  802507:	c3                   	retq   

0000000000802508 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  802508:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80250b:	48 a1 e0 71 80 00 00 	movabs 0x8071e0,%rax
  802512:	00 00 00 
call *%rax
  802515:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  802517:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  80251e:	00 
mov 136(%rsp), %r9
  80251f:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  802526:	00 
sub $8, %r8
  802527:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  80252b:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  80252e:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  802535:	00 
add $16, %rsp
  802536:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  80253a:	4c 8b 3c 24          	mov    (%rsp),%r15
  80253e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802543:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802548:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80254d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802552:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802557:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80255c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802561:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802566:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80256b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802570:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802575:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80257a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80257f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802584:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  802588:	48 83 c4 08          	add    $0x8,%rsp
popf
  80258c:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  80258d:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  802591:	c3                   	retq   

0000000000802592 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802592:	55                   	push   %rbp
  802593:	48 89 e5             	mov    %rsp,%rbp
  802596:	48 83 ec 08          	sub    $0x8,%rsp
  80259a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80259e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025a2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025a9:	ff ff ff 
  8025ac:	48 01 d0             	add    %rdx,%rax
  8025af:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025b3:	c9                   	leaveq 
  8025b4:	c3                   	retq   

00000000008025b5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025b5:	55                   	push   %rbp
  8025b6:	48 89 e5             	mov    %rsp,%rbp
  8025b9:	48 83 ec 08          	sub    $0x8,%rsp
  8025bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8025c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c5:	48 89 c7             	mov    %rax,%rdi
  8025c8:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
  8025d4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8025da:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8025de:	c9                   	leaveq 
  8025df:	c3                   	retq   

00000000008025e0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025e0:	55                   	push   %rbp
  8025e1:	48 89 e5             	mov    %rsp,%rbp
  8025e4:	48 83 ec 18          	sub    $0x18,%rsp
  8025e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f3:	eb 6b                	jmp    802660 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f8:	48 98                	cltq   
  8025fa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802600:	48 c1 e0 0c          	shl    $0xc,%rax
  802604:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260c:	48 c1 e8 15          	shr    $0x15,%rax
  802610:	48 89 c2             	mov    %rax,%rdx
  802613:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80261a:	01 00 00 
  80261d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802621:	83 e0 01             	and    $0x1,%eax
  802624:	48 85 c0             	test   %rax,%rax
  802627:	74 21                	je     80264a <fd_alloc+0x6a>
  802629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262d:	48 c1 e8 0c          	shr    $0xc,%rax
  802631:	48 89 c2             	mov    %rax,%rdx
  802634:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80263b:	01 00 00 
  80263e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802642:	83 e0 01             	and    $0x1,%eax
  802645:	48 85 c0             	test   %rax,%rax
  802648:	75 12                	jne    80265c <fd_alloc+0x7c>
			*fd_store = fd;
  80264a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802652:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
  80265a:	eb 1a                	jmp    802676 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80265c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802660:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802664:	7e 8f                	jle    8025f5 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802671:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802676:	c9                   	leaveq 
  802677:	c3                   	retq   

0000000000802678 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802678:	55                   	push   %rbp
  802679:	48 89 e5             	mov    %rsp,%rbp
  80267c:	48 83 ec 20          	sub    $0x20,%rsp
  802680:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802683:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802687:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80268b:	78 06                	js     802693 <fd_lookup+0x1b>
  80268d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802691:	7e 07                	jle    80269a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802693:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802698:	eb 6c                	jmp    802706 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80269a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80269d:	48 98                	cltq   
  80269f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026a5:	48 c1 e0 0c          	shl    $0xc,%rax
  8026a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b1:	48 c1 e8 15          	shr    $0x15,%rax
  8026b5:	48 89 c2             	mov    %rax,%rdx
  8026b8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026bf:	01 00 00 
  8026c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c6:	83 e0 01             	and    $0x1,%eax
  8026c9:	48 85 c0             	test   %rax,%rax
  8026cc:	74 21                	je     8026ef <fd_lookup+0x77>
  8026ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d2:	48 c1 e8 0c          	shr    $0xc,%rax
  8026d6:	48 89 c2             	mov    %rax,%rdx
  8026d9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026e0:	01 00 00 
  8026e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e7:	83 e0 01             	and    $0x1,%eax
  8026ea:	48 85 c0             	test   %rax,%rax
  8026ed:	75 07                	jne    8026f6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026f4:	eb 10                	jmp    802706 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026fe:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802706:	c9                   	leaveq 
  802707:	c3                   	retq   

0000000000802708 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802708:	55                   	push   %rbp
  802709:	48 89 e5             	mov    %rsp,%rbp
  80270c:	48 83 ec 30          	sub    $0x30,%rsp
  802710:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802714:	89 f0                	mov    %esi,%eax
  802716:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271d:	48 89 c7             	mov    %rax,%rdi
  802720:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802730:	48 89 d6             	mov    %rdx,%rsi
  802733:	89 c7                	mov    %eax,%edi
  802735:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802744:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802748:	78 0a                	js     802754 <fd_close+0x4c>
	    || fd != fd2)
  80274a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802752:	74 12                	je     802766 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802754:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802758:	74 05                	je     80275f <fd_close+0x57>
  80275a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275d:	eb 05                	jmp    802764 <fd_close+0x5c>
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	eb 69                	jmp    8027cf <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276a:	8b 00                	mov    (%rax),%eax
  80276c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802770:	48 89 d6             	mov    %rdx,%rsi
  802773:	89 c7                	mov    %eax,%edi
  802775:	48 b8 d1 27 80 00 00 	movabs $0x8027d1,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802788:	78 2a                	js     8027b4 <fd_close+0xac>
		if (dev->dev_close)
  80278a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802792:	48 85 c0             	test   %rax,%rax
  802795:	74 16                	je     8027ad <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80279f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027a3:	48 89 d7             	mov    %rdx,%rdi
  8027a6:	ff d0                	callq  *%rax
  8027a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ab:	eb 07                	jmp    8027b4 <fd_close+0xac>
		else
			r = 0;
  8027ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b8:	48 89 c6             	mov    %rax,%rsi
  8027bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c0:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	callq  *%rax
	return r;
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027cf:	c9                   	leaveq 
  8027d0:	c3                   	retq   

00000000008027d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8027d1:	55                   	push   %rbp
  8027d2:	48 89 e5             	mov    %rsp,%rbp
  8027d5:	48 83 ec 20          	sub    $0x20,%rsp
  8027d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8027e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027e7:	eb 41                	jmp    80282a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8027e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027f0:	00 00 00 
  8027f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027f6:	48 63 d2             	movslq %edx,%rdx
  8027f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027fd:	8b 00                	mov    (%rax),%eax
  8027ff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802802:	75 22                	jne    802826 <dev_lookup+0x55>
			*dev = devtab[i];
  802804:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80280b:	00 00 00 
  80280e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802811:	48 63 d2             	movslq %edx,%rdx
  802814:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802818:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	eb 60                	jmp    802886 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802826:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80282a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802831:	00 00 00 
  802834:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802837:	48 63 d2             	movslq %edx,%rdx
  80283a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80283e:	48 85 c0             	test   %rax,%rax
  802841:	75 a6                	jne    8027e9 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802843:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  80284a:	00 00 00 
  80284d:	48 8b 00             	mov    (%rax),%rax
  802850:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802856:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802859:	89 c6                	mov    %eax,%esi
  80285b:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  802862:	00 00 00 
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802871:	00 00 00 
  802874:	ff d1                	callq  *%rcx
	*dev = 0;
  802876:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802881:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802886:	c9                   	leaveq 
  802887:	c3                   	retq   

0000000000802888 <close>:

int
close(int fdnum)
{
  802888:	55                   	push   %rbp
  802889:	48 89 e5             	mov    %rsp,%rbp
  80288c:	48 83 ec 20          	sub    $0x20,%rsp
  802890:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802893:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802897:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80289a:	48 89 d6             	mov    %rdx,%rsi
  80289d:	89 c7                	mov    %eax,%edi
  80289f:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
  8028ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b2:	79 05                	jns    8028b9 <close+0x31>
		return r;
  8028b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b7:	eb 18                	jmp    8028d1 <close+0x49>
	else
		return fd_close(fd, 1);
  8028b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bd:	be 01 00 00 00       	mov    $0x1,%esi
  8028c2:	48 89 c7             	mov    %rax,%rdi
  8028c5:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  8028cc:	00 00 00 
  8028cf:	ff d0                	callq  *%rax
}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <close_all>:

void
close_all(void)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8028db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028e2:	eb 15                	jmp    8028f9 <close_all+0x26>
		close(i);
  8028e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028f9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028fd:	7e e5                	jle    8028e4 <close_all+0x11>
		close(i);
}
  8028ff:	c9                   	leaveq 
  802900:	c3                   	retq   

0000000000802901 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802901:	55                   	push   %rbp
  802902:	48 89 e5             	mov    %rsp,%rbp
  802905:	48 83 ec 40          	sub    $0x40,%rsp
  802909:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80290c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80290f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802913:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802916:	48 89 d6             	mov    %rdx,%rsi
  802919:	89 c7                	mov    %eax,%edi
  80291b:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
  802927:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292e:	79 08                	jns    802938 <dup+0x37>
		return r;
  802930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802933:	e9 70 01 00 00       	jmpq   802aa8 <dup+0x1a7>
	close(newfdnum);
  802938:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802949:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80294c:	48 98                	cltq   
  80294e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802954:	48 c1 e0 0c          	shl    $0xc,%rax
  802958:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80295c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802960:	48 89 c7             	mov    %rax,%rdi
  802963:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	callq  *%rax
  80296f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802977:	48 89 c7             	mov    %rax,%rdi
  80297a:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  802981:	00 00 00 
  802984:	ff d0                	callq  *%rax
  802986:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	48 c1 e8 15          	shr    $0x15,%rax
  802992:	48 89 c2             	mov    %rax,%rdx
  802995:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80299c:	01 00 00 
  80299f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a3:	83 e0 01             	and    $0x1,%eax
  8029a6:	48 85 c0             	test   %rax,%rax
  8029a9:	74 73                	je     802a1e <dup+0x11d>
  8029ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029af:	48 c1 e8 0c          	shr    $0xc,%rax
  8029b3:	48 89 c2             	mov    %rax,%rdx
  8029b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029bd:	01 00 00 
  8029c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c4:	83 e0 01             	and    $0x1,%eax
  8029c7:	48 85 c0             	test   %rax,%rax
  8029ca:	74 52                	je     802a1e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029d4:	48 89 c2             	mov    %rax,%rdx
  8029d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029de:	01 00 00 
  8029e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8029ea:	89 c1                	mov    %eax,%ecx
  8029ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f4:	41 89 c8             	mov    %ecx,%r8d
  8029f7:	48 89 d1             	mov    %rdx,%rcx
  8029fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ff:	48 89 c6             	mov    %rax,%rsi
  802a02:	bf 00 00 00 00       	mov    $0x0,%edi
  802a07:	48 b8 56 22 80 00 00 	movabs $0x802256,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
  802a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1a:	79 02                	jns    802a1e <dup+0x11d>
			goto err;
  802a1c:	eb 57                	jmp    802a75 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a22:	48 c1 e8 0c          	shr    $0xc,%rax
  802a26:	48 89 c2             	mov    %rax,%rdx
  802a29:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a30:	01 00 00 
  802a33:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a37:	25 07 0e 00 00       	and    $0xe07,%eax
  802a3c:	89 c1                	mov    %eax,%ecx
  802a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a46:	41 89 c8             	mov    %ecx,%r8d
  802a49:	48 89 d1             	mov    %rdx,%rcx
  802a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a51:	48 89 c6             	mov    %rax,%rsi
  802a54:	bf 00 00 00 00       	mov    $0x0,%edi
  802a59:	48 b8 56 22 80 00 00 	movabs $0x802256,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	callq  *%rax
  802a65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6c:	79 02                	jns    802a70 <dup+0x16f>
		goto err;
  802a6e:	eb 05                	jmp    802a75 <dup+0x174>

	return newfdnum;
  802a70:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a73:	eb 33                	jmp    802aa8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a79:	48 89 c6             	mov    %rax,%rsi
  802a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802a81:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  802a88:	00 00 00 
  802a8b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a91:	48 89 c6             	mov    %rax,%rsi
  802a94:	bf 00 00 00 00       	mov    $0x0,%edi
  802a99:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
	return r;
  802aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aa8:	c9                   	leaveq 
  802aa9:	c3                   	retq   

0000000000802aaa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802aaa:	55                   	push   %rbp
  802aab:	48 89 e5             	mov    %rsp,%rbp
  802aae:	48 83 ec 40          	sub    $0x40,%rsp
  802ab2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ab5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ab9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802abd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac4:	48 89 d6             	mov    %rdx,%rsi
  802ac7:	89 c7                	mov    %eax,%edi
  802ac9:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	callq  *%rax
  802ad5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adc:	78 24                	js     802b02 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ade:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae2:	8b 00                	mov    (%rax),%eax
  802ae4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae8:	48 89 d6             	mov    %rdx,%rsi
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 d1 27 80 00 00 	movabs $0x8027d1,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b00:	79 05                	jns    802b07 <read+0x5d>
		return r;
  802b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b05:	eb 76                	jmp    802b7d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0b:	8b 40 08             	mov    0x8(%rax),%eax
  802b0e:	83 e0 03             	and    $0x3,%eax
  802b11:	83 f8 01             	cmp    $0x1,%eax
  802b14:	75 3a                	jne    802b50 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b16:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802b1d:	00 00 00 
  802b20:	48 8b 00             	mov    (%rax),%rax
  802b23:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b29:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b2c:	89 c6                	mov    %eax,%esi
  802b2e:	48 bf af 46 80 00 00 	movabs $0x8046af,%rdi
  802b35:	00 00 00 
  802b38:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3d:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802b44:	00 00 00 
  802b47:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b4e:	eb 2d                	jmp    802b7d <read+0xd3>
	}
	if (!dev->dev_read)
  802b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b54:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b58:	48 85 c0             	test   %rax,%rax
  802b5b:	75 07                	jne    802b64 <read+0xba>
		return -E_NOT_SUPP;
  802b5d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b62:	eb 19                	jmp    802b7d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b68:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b74:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b78:	48 89 cf             	mov    %rcx,%rdi
  802b7b:	ff d0                	callq  *%rax
}
  802b7d:	c9                   	leaveq 
  802b7e:	c3                   	retq   

0000000000802b7f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b7f:	55                   	push   %rbp
  802b80:	48 89 e5             	mov    %rsp,%rbp
  802b83:	48 83 ec 30          	sub    $0x30,%rsp
  802b87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b8a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b8e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b99:	eb 49                	jmp    802be4 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9e:	48 98                	cltq   
  802ba0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ba4:	48 29 c2             	sub    %rax,%rdx
  802ba7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802baa:	48 63 c8             	movslq %eax,%rcx
  802bad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb1:	48 01 c1             	add    %rax,%rcx
  802bb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb7:	48 89 ce             	mov    %rcx,%rsi
  802bba:	89 c7                	mov    %eax,%edi
  802bbc:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  802bc3:	00 00 00 
  802bc6:	ff d0                	callq  *%rax
  802bc8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802bcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bcf:	79 05                	jns    802bd6 <readn+0x57>
			return m;
  802bd1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd4:	eb 1c                	jmp    802bf2 <readn+0x73>
		if (m == 0)
  802bd6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bda:	75 02                	jne    802bde <readn+0x5f>
			break;
  802bdc:	eb 11                	jmp    802bef <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bde:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802be1:	01 45 fc             	add    %eax,-0x4(%rbp)
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	48 98                	cltq   
  802be9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802bed:	72 ac                	jb     802b9b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bf2:	c9                   	leaveq 
  802bf3:	c3                   	retq   

0000000000802bf4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	48 83 ec 40          	sub    $0x40,%rsp
  802bfc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c03:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c07:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c0e:	48 89 d6             	mov    %rdx,%rsi
  802c11:	89 c7                	mov    %eax,%edi
  802c13:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802c1a:	00 00 00 
  802c1d:	ff d0                	callq  *%rax
  802c1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c26:	78 24                	js     802c4c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2c:	8b 00                	mov    (%rax),%eax
  802c2e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c32:	48 89 d6             	mov    %rdx,%rsi
  802c35:	89 c7                	mov    %eax,%edi
  802c37:	48 b8 d1 27 80 00 00 	movabs $0x8027d1,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
  802c43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4a:	79 05                	jns    802c51 <write+0x5d>
		return r;
  802c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4f:	eb 75                	jmp    802cc6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c55:	8b 40 08             	mov    0x8(%rax),%eax
  802c58:	83 e0 03             	and    $0x3,%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	75 3a                	jne    802c99 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c5f:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802c66:	00 00 00 
  802c69:	48 8b 00             	mov    (%rax),%rax
  802c6c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c72:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c75:	89 c6                	mov    %eax,%esi
  802c77:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802c8d:	00 00 00 
  802c90:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c97:	eb 2d                	jmp    802cc6 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ca1:	48 85 c0             	test   %rax,%rax
  802ca4:	75 07                	jne    802cad <write+0xb9>
		return -E_NOT_SUPP;
  802ca6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cab:	eb 19                	jmp    802cc6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cb5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cb9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cbd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cc1:	48 89 cf             	mov    %rcx,%rdi
  802cc4:	ff d0                	callq  *%rax
}
  802cc6:	c9                   	leaveq 
  802cc7:	c3                   	retq   

0000000000802cc8 <seek>:

int
seek(int fdnum, off_t offset)
{
  802cc8:	55                   	push   %rbp
  802cc9:	48 89 e5             	mov    %rsp,%rbp
  802ccc:	48 83 ec 18          	sub    $0x18,%rsp
  802cd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdd:	48 89 d6             	mov    %rdx,%rsi
  802ce0:	89 c7                	mov    %eax,%edi
  802ce2:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
  802cee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf5:	79 05                	jns    802cfc <seek+0x34>
		return r;
  802cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfa:	eb 0f                	jmp    802d0b <seek+0x43>
	fd->fd_offset = offset;
  802cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d00:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d0b:	c9                   	leaveq 
  802d0c:	c3                   	retq   

0000000000802d0d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d0d:	55                   	push   %rbp
  802d0e:	48 89 e5             	mov    %rsp,%rbp
  802d11:	48 83 ec 30          	sub    $0x30,%rsp
  802d15:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d18:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d22:	48 89 d6             	mov    %rdx,%rsi
  802d25:	89 c7                	mov    %eax,%edi
  802d27:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
  802d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3a:	78 24                	js     802d60 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d40:	8b 00                	mov    (%rax),%eax
  802d42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d46:	48 89 d6             	mov    %rdx,%rsi
  802d49:	89 c7                	mov    %eax,%edi
  802d4b:	48 b8 d1 27 80 00 00 	movabs $0x8027d1,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5e:	79 05                	jns    802d65 <ftruncate+0x58>
		return r;
  802d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d63:	eb 72                	jmp    802dd7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d69:	8b 40 08             	mov    0x8(%rax),%eax
  802d6c:	83 e0 03             	and    $0x3,%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	75 3a                	jne    802dad <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d73:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802d7a:	00 00 00 
  802d7d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d80:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d86:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d89:	89 c6                	mov    %eax,%esi
  802d8b:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  802d92:	00 00 00 
  802d95:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9a:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802da1:	00 00 00 
  802da4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802da6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dab:	eb 2a                	jmp    802dd7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802db5:	48 85 c0             	test   %rax,%rax
  802db8:	75 07                	jne    802dc1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802dba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dbf:	eb 16                	jmp    802dd7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dcd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802dd0:	89 ce                	mov    %ecx,%esi
  802dd2:	48 89 d7             	mov    %rdx,%rdi
  802dd5:	ff d0                	callq  *%rax
}
  802dd7:	c9                   	leaveq 
  802dd8:	c3                   	retq   

0000000000802dd9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dd9:	55                   	push   %rbp
  802dda:	48 89 e5             	mov    %rsp,%rbp
  802ddd:	48 83 ec 30          	sub    $0x30,%rsp
  802de1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802de4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802de8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802def:	48 89 d6             	mov    %rdx,%rsi
  802df2:	89 c7                	mov    %eax,%edi
  802df4:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
  802e00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e07:	78 24                	js     802e2d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0d:	8b 00                	mov    (%rax),%eax
  802e0f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e13:	48 89 d6             	mov    %rdx,%rsi
  802e16:	89 c7                	mov    %eax,%edi
  802e18:	48 b8 d1 27 80 00 00 	movabs $0x8027d1,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2b:	79 05                	jns    802e32 <fstat+0x59>
		return r;
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	eb 5e                	jmp    802e90 <fstat+0xb7>
	if (!dev->dev_stat)
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e3a:	48 85 c0             	test   %rax,%rax
  802e3d:	75 07                	jne    802e46 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e3f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e44:	eb 4a                	jmp    802e90 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e4a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e51:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e58:	00 00 00 
	stat->st_isdir = 0;
  802e5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e5f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e66:	00 00 00 
	stat->st_dev = dev;
  802e69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e71:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e84:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e88:	48 89 ce             	mov    %rcx,%rsi
  802e8b:	48 89 d7             	mov    %rdx,%rdi
  802e8e:	ff d0                	callq  *%rax
}
  802e90:	c9                   	leaveq 
  802e91:	c3                   	retq   

0000000000802e92 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e92:	55                   	push   %rbp
  802e93:	48 89 e5             	mov    %rsp,%rbp
  802e96:	48 83 ec 20          	sub    $0x20,%rsp
  802e9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea6:	be 00 00 00 00       	mov    $0x0,%esi
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 80 2f 80 00 00 	movabs $0x802f80,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec1:	79 05                	jns    802ec8 <stat+0x36>
		return fd;
  802ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec6:	eb 2f                	jmp    802ef7 <stat+0x65>
	r = fstat(fd, stat);
  802ec8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ecc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecf:	48 89 d6             	mov    %rdx,%rsi
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 d9 2d 80 00 00 	movabs $0x802dd9,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee6:	89 c7                	mov    %eax,%edi
  802ee8:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
	return r;
  802ef4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ef7:	c9                   	leaveq 
  802ef8:	c3                   	retq   

0000000000802ef9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ef9:	55                   	push   %rbp
  802efa:	48 89 e5             	mov    %rsp,%rbp
  802efd:	48 83 ec 10          	sub    $0x10,%rsp
  802f01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f08:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f0f:	00 00 00 
  802f12:	8b 00                	mov    (%rax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	75 1d                	jne    802f35 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f18:	bf 01 00 00 00       	mov    $0x1,%edi
  802f1d:	48 b8 c2 3e 80 00 00 	movabs $0x803ec2,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	48 ba d0 71 80 00 00 	movabs $0x8071d0,%rdx
  802f30:	00 00 00 
  802f33:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f35:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  802f3c:	00 00 00 
  802f3f:	8b 00                	mov    (%rax),%eax
  802f41:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f44:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f49:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f50:	00 00 00 
  802f53:	89 c7                	mov    %eax,%edi
  802f55:	48 b8 25 3e 80 00 00 	movabs $0x803e25,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	ba 00 00 00 00       	mov    $0x0,%edx
  802f6a:	48 89 c6             	mov    %rax,%rsi
  802f6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f72:	48 b8 5f 3d 80 00 00 	movabs $0x803d5f,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
}
  802f7e:	c9                   	leaveq 
  802f7f:	c3                   	retq   

0000000000802f80 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f80:	55                   	push   %rbp
  802f81:	48 89 e5             	mov    %rsp,%rbp
  802f84:	48 83 ec 20          	sub    $0x20,%rsp
  802f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f8c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f93:	48 89 c7             	mov    %rax,%rdi
  802f96:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
  802fa2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fa7:	7e 0a                	jle    802fb3 <open+0x33>
  802fa9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fae:	e9 a5 00 00 00       	jmpq   803058 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802fb3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fb7:	48 89 c7             	mov    %rax,%rdi
  802fba:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcd:	79 08                	jns    802fd7 <open+0x57>
		return r;
  802fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd2:	e9 81 00 00 00       	jmpq   803058 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802fd7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fde:	00 00 00 
  802fe1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fe4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fee:	48 89 c6             	mov    %rax,%rsi
  802ff1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ff8:	00 00 00 
  802ffb:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  803007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300b:	48 89 c6             	mov    %rax,%rsi
  80300e:	bf 01 00 00 00       	mov    $0x1,%edi
  803013:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803026:	79 1d                	jns    803045 <open+0xc5>
		fd_close(fd, 0);
  803028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302c:	be 00 00 00 00       	mov    $0x0,%esi
  803031:	48 89 c7             	mov    %rax,%rdi
  803034:	48 b8 08 27 80 00 00 	movabs $0x802708,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
		return r;
  803040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803043:	eb 13                	jmp    803058 <open+0xd8>
	}
	return fd2num(fd);
  803045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803049:	48 89 c7             	mov    %rax,%rdi
  80304c:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  803058:	c9                   	leaveq 
  803059:	c3                   	retq   

000000000080305a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80305a:	55                   	push   %rbp
  80305b:	48 89 e5             	mov    %rsp,%rbp
  80305e:	48 83 ec 10          	sub    $0x10,%rsp
  803062:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306a:	8b 50 0c             	mov    0xc(%rax),%edx
  80306d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803074:	00 00 00 
  803077:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803079:	be 00 00 00 00       	mov    $0x0,%esi
  80307e:	bf 06 00 00 00       	mov    $0x6,%edi
  803083:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 83 ec 30          	sub    $0x30,%rsp
  803099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b3:	00 00 00 
  8030b6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bf:	00 00 00 
  8030c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030c6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8030ca:	be 00 00 00 00       	mov    $0x0,%esi
  8030cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8030d4:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	callq  *%rax
  8030e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e7:	79 05                	jns    8030ee <devfile_read+0x5d>
		return r;
  8030e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ec:	eb 26                	jmp    803114 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8030ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f1:	48 63 d0             	movslq %eax,%rdx
  8030f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030ff:	00 00 00 
  803102:	48 89 c7             	mov    %rax,%rdi
  803105:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
	return r;
  803111:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803114:	c9                   	leaveq 
  803115:	c3                   	retq   

0000000000803116 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	48 83 ec 30          	sub    $0x30,%rsp
  80311e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803122:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803126:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80312a:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  803131:	00 
	n = n > max ? max : n;
  803132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803136:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80313a:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80313f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803147:	8b 50 0c             	mov    0xc(%rax),%edx
  80314a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803151:	00 00 00 
  803154:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803156:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80315d:	00 00 00 
  803160:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803164:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803168:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80316c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803170:	48 89 c6             	mov    %rax,%rsi
  803173:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80317a:	00 00 00 
  80317d:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  803189:	be 00 00 00 00       	mov    $0x0,%esi
  80318e:	bf 04 00 00 00       	mov    $0x4,%edi
  803193:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  80319a:	00 00 00 
  80319d:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 20          	sub    $0x20,%rsp
  8031a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031bf:	00 00 00 
  8031c2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031c4:	be 00 00 00 00       	mov    $0x0,%esi
  8031c9:	bf 05 00 00 00       	mov    $0x5,%edi
  8031ce:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
  8031da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e1:	79 05                	jns    8031e8 <devfile_stat+0x47>
		return r;
  8031e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e6:	eb 56                	jmp    80323e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ec:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031f3:	00 00 00 
  8031f6:	48 89 c7             	mov    %rax,%rdi
  8031f9:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  803200:	00 00 00 
  803203:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803205:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320c:	00 00 00 
  80320f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803215:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803219:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80321f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803226:	00 00 00 
  803229:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80322f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803233:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80323e:	c9                   	leaveq 
  80323f:	c3                   	retq   

0000000000803240 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
  803244:	48 83 ec 10          	sub    $0x10,%rsp
  803248:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80324c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80324f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803253:	8b 50 0c             	mov    0xc(%rax),%edx
  803256:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80325d:	00 00 00 
  803260:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803262:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803269:	00 00 00 
  80326c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803272:	be 00 00 00 00       	mov    $0x0,%esi
  803277:	bf 02 00 00 00       	mov    $0x2,%edi
  80327c:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
}
  803288:	c9                   	leaveq 
  803289:	c3                   	retq   

000000000080328a <remove>:

// Delete a file
int
remove(const char *path)
{
  80328a:	55                   	push   %rbp
  80328b:	48 89 e5             	mov    %rsp,%rbp
  80328e:	48 83 ec 10          	sub    $0x10,%rsp
  803292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80329a:	48 89 c7             	mov    %rax,%rdi
  80329d:	48 b8 6b 18 80 00 00 	movabs $0x80186b,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
  8032a9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032ae:	7e 07                	jle    8032b7 <remove+0x2d>
		return -E_BAD_PATH;
  8032b0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032b5:	eb 33                	jmp    8032ea <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032bb:	48 89 c6             	mov    %rax,%rsi
  8032be:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8032c5:	00 00 00 
  8032c8:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032d4:	be 00 00 00 00       	mov    $0x0,%esi
  8032d9:	bf 07 00 00 00       	mov    $0x7,%edi
  8032de:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  8032e5:	00 00 00 
  8032e8:	ff d0                	callq  *%rax
}
  8032ea:	c9                   	leaveq 
  8032eb:	c3                   	retq   

00000000008032ec <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032ec:	55                   	push   %rbp
  8032ed:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032f0:	be 00 00 00 00       	mov    $0x0,%esi
  8032f5:	bf 08 00 00 00       	mov    $0x8,%edi
  8032fa:	48 b8 f9 2e 80 00 00 	movabs $0x802ef9,%rax
  803301:	00 00 00 
  803304:	ff d0                	callq  *%rax
}
  803306:	5d                   	pop    %rbp
  803307:	c3                   	retq   

0000000000803308 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803308:	55                   	push   %rbp
  803309:	48 89 e5             	mov    %rsp,%rbp
  80330c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803313:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80331a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803321:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803328:	be 00 00 00 00       	mov    $0x0,%esi
  80332d:	48 89 c7             	mov    %rax,%rdi
  803330:	48 b8 80 2f 80 00 00 	movabs $0x802f80,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
  80333c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80333f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803343:	79 28                	jns    80336d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803348:	89 c6                	mov    %eax,%esi
  80334a:	48 bf 0e 47 80 00 00 	movabs $0x80470e,%rdi
  803351:	00 00 00 
  803354:	b8 00 00 00 00       	mov    $0x0,%eax
  803359:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  803360:	00 00 00 
  803363:	ff d2                	callq  *%rdx
		return fd_src;
  803365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803368:	e9 74 01 00 00       	jmpq   8034e1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80336d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803374:	be 01 01 00 00       	mov    $0x101,%esi
  803379:	48 89 c7             	mov    %rax,%rdi
  80337c:	48 b8 80 2f 80 00 00 	movabs $0x802f80,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
  803388:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80338b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80338f:	79 39                	jns    8033ca <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803391:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803394:	89 c6                	mov    %eax,%esi
  803396:	48 bf 24 47 80 00 00 	movabs $0x804724,%rdi
  80339d:	00 00 00 
  8033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a5:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8033ac:	00 00 00 
  8033af:	ff d2                	callq  *%rdx
		close(fd_src);
  8033b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
		return fd_dest;
  8033c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c5:	e9 17 01 00 00       	jmpq   8034e1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033ca:	eb 74                	jmp    803440 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8033cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033cf:	48 63 d0             	movslq %eax,%rdx
  8033d2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033dc:	48 89 ce             	mov    %rcx,%rsi
  8033df:	89 c7                	mov    %eax,%edi
  8033e1:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  8033e8:	00 00 00 
  8033eb:	ff d0                	callq  *%rax
  8033ed:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033f4:	79 4a                	jns    803440 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8033f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033f9:	89 c6                	mov    %eax,%esi
  8033fb:	48 bf 3e 47 80 00 00 	movabs $0x80473e,%rdi
  803402:	00 00 00 
  803405:	b8 00 00 00 00       	mov    $0x0,%eax
  80340a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  803411:	00 00 00 
  803414:	ff d2                	callq  *%rdx
			close(fd_src);
  803416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803419:	89 c7                	mov    %eax,%edi
  80341b:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
			close(fd_dest);
  803427:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80342a:	89 c7                	mov    %eax,%edi
  80342c:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
			return write_size;
  803438:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80343b:	e9 a1 00 00 00       	jmpq   8034e1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803440:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803447:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344a:	ba 00 02 00 00       	mov    $0x200,%edx
  80344f:	48 89 ce             	mov    %rcx,%rsi
  803452:	89 c7                	mov    %eax,%edi
  803454:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
  803460:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803463:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803467:	0f 8f 5f ff ff ff    	jg     8033cc <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803471:	79 47                	jns    8034ba <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803473:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803476:	89 c6                	mov    %eax,%esi
  803478:	48 bf 51 47 80 00 00 	movabs $0x804751,%rdi
  80347f:	00 00 00 
  803482:	b8 00 00 00 00       	mov    $0x0,%eax
  803487:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80348e:	00 00 00 
  803491:	ff d2                	callq  *%rdx
		close(fd_src);
  803493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803496:	89 c7                	mov    %eax,%edi
  803498:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
		close(fd_dest);
  8034a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a7:	89 c7                	mov    %eax,%edi
  8034a9:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
		return read_size;
  8034b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034b8:	eb 27                	jmp    8034e1 <copy+0x1d9>
	}
	close(fd_src);
  8034ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bd:	89 c7                	mov    %eax,%edi
  8034bf:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
	close(fd_dest);
  8034cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ce:	89 c7                	mov    %eax,%edi
  8034d0:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8034d7:	00 00 00 
  8034da:	ff d0                	callq  *%rax
	return 0;
  8034dc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034e1:	c9                   	leaveq 
  8034e2:	c3                   	retq   

00000000008034e3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034e3:	55                   	push   %rbp
  8034e4:	48 89 e5             	mov    %rsp,%rbp
  8034e7:	53                   	push   %rbx
  8034e8:	48 83 ec 38          	sub    $0x38,%rsp
  8034ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034f0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
  803503:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803506:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80350a:	0f 88 bf 01 00 00    	js     8036cf <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803514:	ba 07 04 00 00       	mov    $0x407,%edx
  803519:	48 89 c6             	mov    %rax,%rsi
  80351c:	bf 00 00 00 00       	mov    $0x0,%edi
  803521:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803530:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803534:	0f 88 95 01 00 00    	js     8036cf <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80353a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80353e:	48 89 c7             	mov    %rax,%rdi
  803541:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  803548:	00 00 00 
  80354b:	ff d0                	callq  *%rax
  80354d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803550:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803554:	0f 88 5d 01 00 00    	js     8036b7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80355a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80355e:	ba 07 04 00 00       	mov    $0x407,%edx
  803563:	48 89 c6             	mov    %rax,%rsi
  803566:	bf 00 00 00 00       	mov    $0x0,%edi
  80356b:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
  803577:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80357a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80357e:	0f 88 33 01 00 00    	js     8036b7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803588:	48 89 c7             	mov    %rax,%rdi
  80358b:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  803592:	00 00 00 
  803595:	ff d0                	callq  *%rax
  803597:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80359b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80359f:	ba 07 04 00 00       	mov    $0x407,%edx
  8035a4:	48 89 c6             	mov    %rax,%rsi
  8035a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ac:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
  8035b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035bf:	79 05                	jns    8035c6 <pipe+0xe3>
		goto err2;
  8035c1:	e9 d9 00 00 00       	jmpq   80369f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ca:	48 89 c7             	mov    %rax,%rdi
  8035cd:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	48 89 c2             	mov    %rax,%rdx
  8035dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035e6:	48 89 d1             	mov    %rdx,%rcx
  8035e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ee:	48 89 c6             	mov    %rax,%rsi
  8035f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f6:	48 b8 56 22 80 00 00 	movabs $0x802256,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
  803602:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803605:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803609:	79 1b                	jns    803626 <pipe+0x143>
		goto err3;
  80360b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80360c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803610:	48 89 c6             	mov    %rax,%rsi
  803613:	bf 00 00 00 00       	mov    $0x0,%edi
  803618:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
  803624:	eb 79                	jmp    80369f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362a:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803631:	00 00 00 
  803634:	8b 12                	mov    (%rdx),%edx
  803636:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803643:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803647:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80364e:	00 00 00 
  803651:	8b 12                	mov    (%rdx),%edx
  803653:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803659:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803664:	48 89 c7             	mov    %rax,%rdi
  803667:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  80366e:	00 00 00 
  803671:	ff d0                	callq  *%rax
  803673:	89 c2                	mov    %eax,%edx
  803675:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803679:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80367b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80367f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803683:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803687:	48 89 c7             	mov    %rax,%rdi
  80368a:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 03                	mov    %eax,(%rbx)
	return 0;
  803698:	b8 00 00 00 00       	mov    $0x0,%eax
  80369d:	eb 33                	jmp    8036d2 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80369f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a3:	48 89 c6             	mov    %rax,%rsi
  8036a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ab:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  8036b2:	00 00 00 
  8036b5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bb:	48 89 c6             	mov    %rax,%rsi
  8036be:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c3:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  8036ca:	00 00 00 
  8036cd:	ff d0                	callq  *%rax
err:
	return r;
  8036cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036d2:	48 83 c4 38          	add    $0x38,%rsp
  8036d6:	5b                   	pop    %rbx
  8036d7:	5d                   	pop    %rbp
  8036d8:	c3                   	retq   

00000000008036d9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036d9:	55                   	push   %rbp
  8036da:	48 89 e5             	mov    %rsp,%rbp
  8036dd:	53                   	push   %rbx
  8036de:	48 83 ec 28          	sub    $0x28,%rsp
  8036e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036ea:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  8036f1:	00 00 00 
  8036f4:	48 8b 00             	mov    (%rax),%rax
  8036f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803704:	48 89 c7             	mov    %rax,%rdi
  803707:	48 b8 44 3f 80 00 00 	movabs $0x803f44,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
  803713:	89 c3                	mov    %eax,%ebx
  803715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803719:	48 89 c7             	mov    %rax,%rdi
  80371c:	48 b8 44 3f 80 00 00 	movabs $0x803f44,%rax
  803723:	00 00 00 
  803726:	ff d0                	callq  *%rax
  803728:	39 c3                	cmp    %eax,%ebx
  80372a:	0f 94 c0             	sete   %al
  80372d:	0f b6 c0             	movzbl %al,%eax
  803730:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803733:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  80373a:	00 00 00 
  80373d:	48 8b 00             	mov    (%rax),%rax
  803740:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803746:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803749:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80374f:	75 05                	jne    803756 <_pipeisclosed+0x7d>
			return ret;
  803751:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803754:	eb 4f                	jmp    8037a5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803756:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803759:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80375c:	74 42                	je     8037a0 <_pipeisclosed+0xc7>
  80375e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803762:	75 3c                	jne    8037a0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803764:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  80376b:	00 00 00 
  80376e:	48 8b 00             	mov    (%rax),%rax
  803771:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803777:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80377a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377d:	89 c6                	mov    %eax,%esi
  80377f:	48 bf 6c 47 80 00 00 	movabs $0x80476c,%rdi
  803786:	00 00 00 
  803789:	b8 00 00 00 00       	mov    $0x0,%eax
  80378e:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  803795:	00 00 00 
  803798:	41 ff d0             	callq  *%r8
	}
  80379b:	e9 4a ff ff ff       	jmpq   8036ea <_pipeisclosed+0x11>
  8037a0:	e9 45 ff ff ff       	jmpq   8036ea <_pipeisclosed+0x11>
}
  8037a5:	48 83 c4 28          	add    $0x28,%rsp
  8037a9:	5b                   	pop    %rbx
  8037aa:	5d                   	pop    %rbp
  8037ab:	c3                   	retq   

00000000008037ac <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037ac:	55                   	push   %rbp
  8037ad:	48 89 e5             	mov    %rsp,%rbp
  8037b0:	48 83 ec 30          	sub    $0x30,%rsp
  8037b4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037be:	48 89 d6             	mov    %rdx,%rsi
  8037c1:	89 c7                	mov    %eax,%edi
  8037c3:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
  8037cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d6:	79 05                	jns    8037dd <pipeisclosed+0x31>
		return r;
  8037d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037db:	eb 31                	jmp    80380e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e1:	48 89 c7             	mov    %rax,%rdi
  8037e4:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
  8037f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037fc:	48 89 d6             	mov    %rdx,%rsi
  8037ff:	48 89 c7             	mov    %rax,%rdi
  803802:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
}
  80380e:	c9                   	leaveq 
  80380f:	c3                   	retq   

0000000000803810 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803810:	55                   	push   %rbp
  803811:	48 89 e5             	mov    %rsp,%rbp
  803814:	48 83 ec 40          	sub    $0x40,%rsp
  803818:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80381c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803820:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803828:	48 89 c7             	mov    %rax,%rdi
  80382b:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
  803837:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80383b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80383f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803843:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80384a:	00 
  80384b:	e9 92 00 00 00       	jmpq   8038e2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803850:	eb 41                	jmp    803893 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803852:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803857:	74 09                	je     803862 <devpipe_read+0x52>
				return i;
  803859:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385d:	e9 92 00 00 00       	jmpq   8038f4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803862:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80386a:	48 89 d6             	mov    %rdx,%rsi
  80386d:	48 89 c7             	mov    %rax,%rdi
  803870:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  803877:	00 00 00 
  80387a:	ff d0                	callq  *%rax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 07                	je     803887 <devpipe_read+0x77>
				return 0;
  803880:	b8 00 00 00 00       	mov    $0x0,%eax
  803885:	eb 6d                	jmp    8038f4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803887:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803897:	8b 10                	mov    (%rax),%edx
  803899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389d:	8b 40 04             	mov    0x4(%rax),%eax
  8038a0:	39 c2                	cmp    %eax,%edx
  8038a2:	74 ae                	je     803852 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038ac:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b4:	8b 00                	mov    (%rax),%eax
  8038b6:	99                   	cltd   
  8038b7:	c1 ea 1b             	shr    $0x1b,%edx
  8038ba:	01 d0                	add    %edx,%eax
  8038bc:	83 e0 1f             	and    $0x1f,%eax
  8038bf:	29 d0                	sub    %edx,%eax
  8038c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038c5:	48 98                	cltq   
  8038c7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038cc:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d2:	8b 00                	mov    (%rax),%eax
  8038d4:	8d 50 01             	lea    0x1(%rax),%edx
  8038d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038db:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038ea:	0f 82 60 ff ff ff    	jb     803850 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038f4:	c9                   	leaveq 
  8038f5:	c3                   	retq   

00000000008038f6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038f6:	55                   	push   %rbp
  8038f7:	48 89 e5             	mov    %rsp,%rbp
  8038fa:	48 83 ec 40          	sub    $0x40,%rsp
  8038fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803902:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803906:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80390a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803921:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803925:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803929:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803930:	00 
  803931:	e9 8e 00 00 00       	jmpq   8039c4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803936:	eb 31                	jmp    803969 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80393c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803940:	48 89 d6             	mov    %rdx,%rsi
  803943:	48 89 c7             	mov    %rax,%rdi
  803946:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
  803952:	85 c0                	test   %eax,%eax
  803954:	74 07                	je     80395d <devpipe_write+0x67>
				return 0;
  803956:	b8 00 00 00 00       	mov    $0x0,%eax
  80395b:	eb 79                	jmp    8039d6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80395d:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396d:	8b 40 04             	mov    0x4(%rax),%eax
  803970:	48 63 d0             	movslq %eax,%rdx
  803973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803977:	8b 00                	mov    (%rax),%eax
  803979:	48 98                	cltq   
  80397b:	48 83 c0 20          	add    $0x20,%rax
  80397f:	48 39 c2             	cmp    %rax,%rdx
  803982:	73 b4                	jae    803938 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803984:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803988:	8b 40 04             	mov    0x4(%rax),%eax
  80398b:	99                   	cltd   
  80398c:	c1 ea 1b             	shr    $0x1b,%edx
  80398f:	01 d0                	add    %edx,%eax
  803991:	83 e0 1f             	and    $0x1f,%eax
  803994:	29 d0                	sub    %edx,%eax
  803996:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80399a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80399e:	48 01 ca             	add    %rcx,%rdx
  8039a1:	0f b6 0a             	movzbl (%rdx),%ecx
  8039a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a8:	48 98                	cltq   
  8039aa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b2:	8b 40 04             	mov    0x4(%rax),%eax
  8039b5:	8d 50 01             	lea    0x1(%rax),%edx
  8039b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039cc:	0f 82 64 ff ff ff    	jb     803936 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039d6:	c9                   	leaveq 
  8039d7:	c3                   	retq   

00000000008039d8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039d8:	55                   	push   %rbp
  8039d9:	48 89 e5             	mov    %rsp,%rbp
  8039dc:	48 83 ec 20          	sub    $0x20,%rsp
  8039e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ec:	48 89 c7             	mov    %rax,%rdi
  8039ef:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  8039f6:	00 00 00 
  8039f9:	ff d0                	callq  *%rax
  8039fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a03:	48 be 7f 47 80 00 00 	movabs $0x80477f,%rsi
  803a0a:	00 00 00 
  803a0d:	48 89 c7             	mov    %rax,%rdi
  803a10:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  803a17:	00 00 00 
  803a1a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a20:	8b 50 04             	mov    0x4(%rax),%edx
  803a23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a27:	8b 00                	mov    (%rax),%eax
  803a29:	29 c2                	sub    %eax,%edx
  803a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a40:	00 00 00 
	stat->st_dev = &devpipe;
  803a43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a47:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a4e:	00 00 00 
  803a51:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a5d:	c9                   	leaveq 
  803a5e:	c3                   	retq   

0000000000803a5f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a5f:	55                   	push   %rbp
  803a60:	48 89 e5             	mov    %rsp,%rbp
  803a63:	48 83 ec 10          	sub    $0x10,%rsp
  803a67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6f:	48 89 c6             	mov    %rax,%rsi
  803a72:	bf 00 00 00 00       	mov    $0x0,%edi
  803a77:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a87:	48 89 c7             	mov    %rax,%rdi
  803a8a:	48 b8 b5 25 80 00 00 	movabs $0x8025b5,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	48 89 c6             	mov    %rax,%rsi
  803a99:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9e:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	callq  *%rax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 20          	sub    $0x20,%rsp
  803ab4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ab7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aba:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803abd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ac1:	be 01 00 00 00       	mov    $0x1,%esi
  803ac6:	48 89 c7             	mov    %rax,%rdi
  803ac9:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  803ad0:	00 00 00 
  803ad3:	ff d0                	callq  *%rax
}
  803ad5:	c9                   	leaveq 
  803ad6:	c3                   	retq   

0000000000803ad7 <getchar>:

int
getchar(void)
{
  803ad7:	55                   	push   %rbp
  803ad8:	48 89 e5             	mov    %rsp,%rbp
  803adb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803adf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ae3:	ba 01 00 00 00       	mov    $0x1,%edx
  803ae8:	48 89 c6             	mov    %rax,%rsi
  803aeb:	bf 00 00 00 00       	mov    $0x0,%edi
  803af0:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  803af7:	00 00 00 
  803afa:	ff d0                	callq  *%rax
  803afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b03:	79 05                	jns    803b0a <getchar+0x33>
		return r;
  803b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b08:	eb 14                	jmp    803b1e <getchar+0x47>
	if (r < 1)
  803b0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b0e:	7f 07                	jg     803b17 <getchar+0x40>
		return -E_EOF;
  803b10:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b15:	eb 07                	jmp    803b1e <getchar+0x47>
	return c;
  803b17:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b1b:	0f b6 c0             	movzbl %al,%eax
}
  803b1e:	c9                   	leaveq 
  803b1f:	c3                   	retq   

0000000000803b20 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b20:	55                   	push   %rbp
  803b21:	48 89 e5             	mov    %rsp,%rbp
  803b24:	48 83 ec 20          	sub    $0x20,%rsp
  803b28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b32:	48 89 d6             	mov    %rdx,%rsi
  803b35:	89 c7                	mov    %eax,%edi
  803b37:	48 b8 78 26 80 00 00 	movabs $0x802678,%rax
  803b3e:	00 00 00 
  803b41:	ff d0                	callq  *%rax
  803b43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b4a:	79 05                	jns    803b51 <iscons+0x31>
		return r;
  803b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4f:	eb 1a                	jmp    803b6b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b55:	8b 10                	mov    (%rax),%edx
  803b57:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b5e:	00 00 00 
  803b61:	8b 00                	mov    (%rax),%eax
  803b63:	39 c2                	cmp    %eax,%edx
  803b65:	0f 94 c0             	sete   %al
  803b68:	0f b6 c0             	movzbl %al,%eax
}
  803b6b:	c9                   	leaveq 
  803b6c:	c3                   	retq   

0000000000803b6d <opencons>:

int
opencons(void)
{
  803b6d:	55                   	push   %rbp
  803b6e:	48 89 e5             	mov    %rsp,%rbp
  803b71:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b75:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b79:	48 89 c7             	mov    %rax,%rdi
  803b7c:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
  803b88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8f:	79 05                	jns    803b96 <opencons+0x29>
		return r;
  803b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b94:	eb 5b                	jmp    803bf1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9a:	ba 07 04 00 00       	mov    $0x407,%edx
  803b9f:	48 89 c6             	mov    %rax,%rsi
  803ba2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba7:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
  803bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bba:	79 05                	jns    803bc1 <opencons+0x54>
		return r;
  803bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbf:	eb 30                	jmp    803bf1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc5:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803bcc:	00 00 00 
  803bcf:	8b 12                	mov    (%rdx),%edx
  803bd1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be2:	48 89 c7             	mov    %rax,%rdi
  803be5:	48 b8 92 25 80 00 00 	movabs $0x802592,%rax
  803bec:	00 00 00 
  803bef:	ff d0                	callq  *%rax
}
  803bf1:	c9                   	leaveq 
  803bf2:	c3                   	retq   

0000000000803bf3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bf3:	55                   	push   %rbp
  803bf4:	48 89 e5             	mov    %rsp,%rbp
  803bf7:	48 83 ec 30          	sub    $0x30,%rsp
  803bfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c0c:	75 07                	jne    803c15 <devcons_read+0x22>
		return 0;
  803c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c13:	eb 4b                	jmp    803c60 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c15:	eb 0c                	jmp    803c23 <devcons_read+0x30>
		sys_yield();
  803c17:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  803c1e:	00 00 00 
  803c21:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c23:	48 b8 08 21 80 00 00 	movabs $0x802108,%rax
  803c2a:	00 00 00 
  803c2d:	ff d0                	callq  *%rax
  803c2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c36:	74 df                	je     803c17 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c3c:	79 05                	jns    803c43 <devcons_read+0x50>
		return c;
  803c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c41:	eb 1d                	jmp    803c60 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c43:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c47:	75 07                	jne    803c50 <devcons_read+0x5d>
		return 0;
  803c49:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4e:	eb 10                	jmp    803c60 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c53:	89 c2                	mov    %eax,%edx
  803c55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c59:	88 10                	mov    %dl,(%rax)
	return 1;
  803c5b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c60:	c9                   	leaveq 
  803c61:	c3                   	retq   

0000000000803c62 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c62:	55                   	push   %rbp
  803c63:	48 89 e5             	mov    %rsp,%rbp
  803c66:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c6d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c74:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c7b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c89:	eb 76                	jmp    803d01 <devcons_write+0x9f>
		m = n - tot;
  803c8b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c92:	89 c2                	mov    %eax,%edx
  803c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c97:	29 c2                	sub    %eax,%edx
  803c99:	89 d0                	mov    %edx,%eax
  803c9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca1:	83 f8 7f             	cmp    $0x7f,%eax
  803ca4:	76 07                	jbe    803cad <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803ca6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803cad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb0:	48 63 d0             	movslq %eax,%rdx
  803cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb6:	48 63 c8             	movslq %eax,%rcx
  803cb9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cc0:	48 01 c1             	add    %rax,%rcx
  803cc3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cca:	48 89 ce             	mov    %rcx,%rsi
  803ccd:	48 89 c7             	mov    %rax,%rdi
  803cd0:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cdf:	48 63 d0             	movslq %eax,%rdx
  803ce2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ce9:	48 89 d6             	mov    %rdx,%rsi
  803cec:	48 89 c7             	mov    %rax,%rdi
  803cef:	48 b8 be 20 80 00 00 	movabs $0x8020be,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cfe:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d04:	48 98                	cltq   
  803d06:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d0d:	0f 82 78 ff ff ff    	jb     803c8b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d16:	c9                   	leaveq 
  803d17:	c3                   	retq   

0000000000803d18 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d18:	55                   	push   %rbp
  803d19:	48 89 e5             	mov    %rsp,%rbp
  803d1c:	48 83 ec 08          	sub    $0x8,%rsp
  803d20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d29:	c9                   	leaveq 
  803d2a:	c3                   	retq   

0000000000803d2b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d2b:	55                   	push   %rbp
  803d2c:	48 89 e5             	mov    %rsp,%rbp
  803d2f:	48 83 ec 10          	sub    $0x10,%rsp
  803d33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3f:	48 be 8b 47 80 00 00 	movabs $0x80478b,%rsi
  803d46:	00 00 00 
  803d49:	48 89 c7             	mov    %rax,%rdi
  803d4c:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  803d53:	00 00 00 
  803d56:	ff d0                	callq  *%rax
	return 0;
  803d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d5d:	c9                   	leaveq 
  803d5e:	c3                   	retq   

0000000000803d5f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d5f:	55                   	push   %rbp
  803d60:	48 89 e5             	mov    %rsp,%rbp
  803d63:	48 83 ec 30          	sub    $0x30,%rsp
  803d67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803d73:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d78:	74 18                	je     803d92 <ipc_recv+0x33>
  803d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d7e:	48 89 c7             	mov    %rax,%rdi
  803d81:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
  803d8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d90:	eb 19                	jmp    803dab <ipc_recv+0x4c>
  803d92:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803d99:	00 00 00 
  803d9c:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	callq  *%rax
  803da8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803dab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803db0:	74 26                	je     803dd8 <ipc_recv+0x79>
  803db2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db6:	75 15                	jne    803dcd <ipc_recv+0x6e>
  803db8:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803dbf:	00 00 00 
  803dc2:	48 8b 00             	mov    (%rax),%rax
  803dc5:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803dcb:	eb 05                	jmp    803dd2 <ipc_recv+0x73>
  803dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dd6:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803dd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ddd:	74 26                	je     803e05 <ipc_recv+0xa6>
  803ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de3:	75 15                	jne    803dfa <ipc_recv+0x9b>
  803de5:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803dec:	00 00 00 
  803def:	48 8b 00             	mov    (%rax),%rax
  803df2:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803df8:	eb 05                	jmp    803dff <ipc_recv+0xa0>
  803dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803dff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e03:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803e05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e09:	75 15                	jne    803e20 <ipc_recv+0xc1>
  803e0b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803e12:	00 00 00 
  803e15:	48 8b 00             	mov    (%rax),%rax
  803e18:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803e1e:	eb 03                	jmp    803e23 <ipc_recv+0xc4>
  803e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e23:	c9                   	leaveq 
  803e24:	c3                   	retq   

0000000000803e25 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e25:	55                   	push   %rbp
  803e26:	48 89 e5             	mov    %rsp,%rbp
  803e29:	48 83 ec 30          	sub    $0x30,%rsp
  803e2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e30:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e33:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e37:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803e3a:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803e41:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e46:	75 10                	jne    803e58 <ipc_send+0x33>
  803e48:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e4f:	00 00 00 
  803e52:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803e56:	eb 62                	jmp    803eba <ipc_send+0x95>
  803e58:	eb 60                	jmp    803eba <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803e5a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e5e:	74 30                	je     803e90 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e63:	89 c1                	mov    %eax,%ecx
  803e65:	48 ba 92 47 80 00 00 	movabs $0x804792,%rdx
  803e6c:	00 00 00 
  803e6f:	be 33 00 00 00       	mov    $0x33,%esi
  803e74:	48 bf ae 47 80 00 00 	movabs $0x8047ae,%rdi
  803e7b:	00 00 00 
  803e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e83:	49 b8 e9 0a 80 00 00 	movabs $0x800ae9,%r8
  803e8a:	00 00 00 
  803e8d:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803e90:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e93:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e96:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9d:	89 c7                	mov    %eax,%edi
  803e9f:	48 b8 da 23 80 00 00 	movabs $0x8023da,%rax
  803ea6:	00 00 00 
  803ea9:	ff d0                	callq  *%rax
  803eab:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803eae:	48 b8 c8 21 80 00 00 	movabs $0x8021c8,%rax
  803eb5:	00 00 00 
  803eb8:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebe:	75 9a                	jne    803e5a <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803ec0:	c9                   	leaveq 
  803ec1:	c3                   	retq   

0000000000803ec2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ec2:	55                   	push   %rbp
  803ec3:	48 89 e5             	mov    %rsp,%rbp
  803ec6:	48 83 ec 14          	sub    $0x14,%rsp
  803eca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ed4:	eb 5e                	jmp    803f34 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ed6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803edd:	00 00 00 
  803ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee3:	48 63 d0             	movslq %eax,%rdx
  803ee6:	48 89 d0             	mov    %rdx,%rax
  803ee9:	48 c1 e0 03          	shl    $0x3,%rax
  803eed:	48 01 d0             	add    %rdx,%rax
  803ef0:	48 c1 e0 05          	shl    $0x5,%rax
  803ef4:	48 01 c8             	add    %rcx,%rax
  803ef7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803efd:	8b 00                	mov    (%rax),%eax
  803eff:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f02:	75 2c                	jne    803f30 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803f04:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f0b:	00 00 00 
  803f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f11:	48 63 d0             	movslq %eax,%rdx
  803f14:	48 89 d0             	mov    %rdx,%rax
  803f17:	48 c1 e0 03          	shl    $0x3,%rax
  803f1b:	48 01 d0             	add    %rdx,%rax
  803f1e:	48 c1 e0 05          	shl    $0x5,%rax
  803f22:	48 01 c8             	add    %rcx,%rax
  803f25:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f2b:	8b 40 08             	mov    0x8(%rax),%eax
  803f2e:	eb 12                	jmp    803f42 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f34:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f3b:	7e 99                	jle    803ed6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f42:	c9                   	leaveq 
  803f43:	c3                   	retq   

0000000000803f44 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f44:	55                   	push   %rbp
  803f45:	48 89 e5             	mov    %rsp,%rbp
  803f48:	48 83 ec 18          	sub    $0x18,%rsp
  803f4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f54:	48 c1 e8 15          	shr    $0x15,%rax
  803f58:	48 89 c2             	mov    %rax,%rdx
  803f5b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f62:	01 00 00 
  803f65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f69:	83 e0 01             	and    $0x1,%eax
  803f6c:	48 85 c0             	test   %rax,%rax
  803f6f:	75 07                	jne    803f78 <pageref+0x34>
		return 0;
  803f71:	b8 00 00 00 00       	mov    $0x0,%eax
  803f76:	eb 53                	jmp    803fcb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7c:	48 c1 e8 0c          	shr    $0xc,%rax
  803f80:	48 89 c2             	mov    %rax,%rdx
  803f83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f8a:	01 00 00 
  803f8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f91:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f99:	83 e0 01             	and    $0x1,%eax
  803f9c:	48 85 c0             	test   %rax,%rax
  803f9f:	75 07                	jne    803fa8 <pageref+0x64>
		return 0;
  803fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa6:	eb 23                	jmp    803fcb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fac:	48 c1 e8 0c          	shr    $0xc,%rax
  803fb0:	48 89 c2             	mov    %rax,%rdx
  803fb3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fba:	00 00 00 
  803fbd:	48 c1 e2 04          	shl    $0x4,%rdx
  803fc1:	48 01 d0             	add    %rdx,%rax
  803fc4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fc8:	0f b7 c0             	movzwl %ax,%eax
}
  803fcb:	c9                   	leaveq 
  803fcc:	c3                   	retq   
