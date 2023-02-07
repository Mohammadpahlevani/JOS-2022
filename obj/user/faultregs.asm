
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
  80003c:	e8 09 0a 00 00       	callq  800a4a <libmain>
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
  800074:	48 be c0 25 80 00 00 	movabs $0x8025c0,%rsi
  80007b:	00 00 00 
  80007e:	48 bf c1 25 80 00 00 	movabs $0x8025c1,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
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
  8000b0:	48 be d1 25 80 00 00 	movabs $0x8025d1,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  800140:	48 be f3 25 80 00 00 	movabs $0x8025f3,%rsi
  800147:	00 00 00 
  80014a:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  8001d0:	48 be f7 25 80 00 00 	movabs $0x8025f7,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  800260:	48 be fb 25 80 00 00 	movabs $0x8025fb,%rsi
  800267:	00 00 00 
  80026a:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  8002f0:	48 be ff 25 80 00 00 	movabs $0x8025ff,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  800380:	48 be 03 26 80 00 00 	movabs $0x802603,%rsi
  800387:	00 00 00 
  80038a:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  800410:	48 be 07 26 80 00 00 	movabs $0x802607,%rsi
  800417:	00 00 00 
  80041a:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  8004a0:	48 be 0b 26 80 00 00 	movabs $0x80260b,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  800536:	48 be 0f 26 80 00 00 	movabs $0x80260f,%rsi
  80053d:	00 00 00 
  800540:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
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
  8005d2:	48 be 16 26 80 00 00 	movabs $0x802616,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf d5 25 80 00 00 	movabs $0x8025d5,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 3e 0d 80 00 00 	movabs $0x800d3e,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK

	cprintf("Registers %s ", testname);
  800652:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800656:	48 89 c6             	mov    %rax,%rsi
  800659:	48 bf 1a 26 80 00 00 	movabs $0x80261a,%rdi
  800660:	00 00 00 
  800663:	b8 00 00 00 00       	mov    $0x0,%eax
  800668:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  80066f:	00 00 00 
  800672:	ff d2                	callq  *%rdx
	if (!mismatch)
  800674:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800678:	75 1d                	jne    800697 <check_regs+0x654>
		cprintf("OK\n");
  80067a:	48 bf e5 25 80 00 00 	movabs $0x8025e5,%rdi
  800681:	00 00 00 
  800684:	b8 00 00 00 00       	mov    $0x0,%eax
  800689:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800690:	00 00 00 
  800693:	ff d2                	callq  *%rdx
  800695:	eb 1b                	jmp    8006b2 <check_regs+0x66f>
	else
		cprintf("MISMATCH\n");
  800697:	48 bf e9 25 80 00 00 	movabs $0x8025e9,%rdi
  80069e:	00 00 00 
  8006a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a6:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  8006ad:	00 00 00 
  8006b0:	ff d2                	callq  *%rdx
}
  8006b2:	c9                   	leaveq 
  8006b3:	c3                   	retq   

00000000008006b4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006b4:	55                   	push   %rbp
  8006b5:	48 89 e5             	mov    %rsp,%rbp
  8006b8:	48 83 ec 20          	sub    $0x20,%rsp
  8006bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 00             	mov    (%rax),%rax
  8006c7:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006cd:	74 43                	je     800712 <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	48 8b 00             	mov    (%rax),%rax
  8006e1:	49 89 d0             	mov    %rdx,%r8
  8006e4:	48 89 c1             	mov    %rax,%rcx
  8006e7:	48 ba 28 26 80 00 00 	movabs $0x802628,%rdx
  8006ee:	00 00 00 
  8006f1:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006f6:	48 bf 59 26 80 00 00 	movabs $0x802659,%rdi
  8006fd:	00 00 00 
  800700:	b8 00 00 00 00       	mov    $0x0,%eax
  800705:	49 b9 05 0b 80 00 00 	movabs $0x800b05,%r9
  80070c:	00 00 00 
  80070f:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  800712:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  800719:	00 00 00 
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800724:	48 89 08             	mov    %rcx,(%rax)
  800727:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  80072b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80072f:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  800733:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800737:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  80073b:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80073f:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  800743:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800747:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  80074b:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80074f:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  800753:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800757:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  80075b:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80075f:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  800763:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800767:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  80076b:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80076f:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  800773:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800777:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  80077b:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80077f:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  800783:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800787:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  80078b:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80078f:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800796:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8007a5:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007ac:	00 00 00 
  8007af:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007be:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007c3:	48 89 c2             	mov    %rax,%rdx
  8007c6:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007cd:	00 00 00 
  8007d0:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007e2:	48 b8 c0 40 80 00 00 	movabs $0x8040c0,%rax
  8007e9:	00 00 00 
  8007ec:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007f3:	49 b8 6a 26 80 00 00 	movabs $0x80266a,%r8
  8007fa:	00 00 00 
  8007fd:	48 b9 78 26 80 00 00 	movabs $0x802678,%rcx
  800804:	00 00 00 
  800807:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  80080e:	00 00 00 
  800811:	48 be 7f 26 80 00 00 	movabs $0x80267f,%rsi
  800818:	00 00 00 
  80081b:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  800822:	00 00 00 
  800825:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80082c:	00 00 00 
  80082f:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800831:	ba 07 00 00 00       	mov    $0x7,%edx
  800836:	be 00 00 40 00       	mov    $0x400000,%esi
  80083b:	bf 00 00 00 00       	mov    $0x0,%edi
  800840:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  800847:	00 00 00 
  80084a:	ff d0                	callq  *%rax
  80084c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80084f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800853:	79 30                	jns    800885 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800858:	89 c1                	mov    %eax,%ecx
  80085a:	48 ba 86 26 80 00 00 	movabs $0x802686,%rdx
  800861:	00 00 00 
  800864:	be 6a 00 00 00       	mov    $0x6a,%esi
  800869:	48 bf 59 26 80 00 00 	movabs $0x802659,%rdi
  800870:	00 00 00 
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	49 b8 05 0b 80 00 00 	movabs $0x800b05,%r8
  80087f:	00 00 00 
  800882:	41 ff d0             	callq  *%r8
}
  800885:	c9                   	leaveq 
  800886:	c3                   	retq   

0000000000800887 <umain>:

void
umain(int argc, char **argv)
{
  800887:	55                   	push   %rbp
  800888:	48 89 e5             	mov    %rsp,%rbp
  80088b:	48 83 ec 10          	sub    $0x10,%rsp
  80088f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800892:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800896:	48 bf b4 06 80 00 00 	movabs $0x8006b4,%rdi
  80089d:	00 00 00 
  8008a0:	48 b8 45 24 80 00 00 	movabs $0x802445,%rax
  8008a7:	00 00 00 
  8008aa:	ff d0                	callq  *%rax

	__asm __volatile(
  8008ac:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8008b3:	00 00 00 
  8008b6:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  8008bd:	00 00 00 
  8008c0:	50                   	push   %rax
  8008c1:	52                   	push   %rdx
  8008c2:	50                   	push   %rax
  8008c3:	9c                   	pushfq 
  8008c4:	58                   	pop    %rax
  8008c5:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008cb:	50                   	push   %rax
  8008cc:	9d                   	popfq  
  8008cd:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008d2:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008d9:	48 8d 04 25 25 09 80 	lea    0x800925,%rax
  8008e0:	00 
  8008e1:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008e5:	58                   	pop    %rax
  8008e6:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008ea:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008ee:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008f2:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008f6:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008fa:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008fe:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800902:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800906:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  80090a:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  80090e:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800912:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800916:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  80091a:	49 89 47 70          	mov    %rax,0x70(%r15)
  80091e:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800925:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  80092c:	2a 00 00 00 
  800930:	4c 8b 3c 24          	mov    (%rsp),%r15
  800934:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800938:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  80093c:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800940:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800944:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800948:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  80094c:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800950:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800954:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800958:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  80095c:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800960:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800964:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800968:	49 89 47 70          	mov    %rax,0x70(%r15)
  80096c:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800973:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800978:	4d 8b 77 08          	mov    0x8(%r15),%r14
  80097c:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  800980:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800984:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800988:	4d 8b 57 28          	mov    0x28(%r15),%r10
  80098c:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  800990:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800994:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800998:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  80099c:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  8009a0:	49 8b 57 58          	mov    0x58(%r15),%rdx
  8009a4:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  8009a8:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  8009ac:	49 8b 47 70          	mov    0x70(%r15),%rax
  8009b0:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009b7:	50                   	push   %rax
  8009b8:	9c                   	pushfq 
  8009b9:	58                   	pop    %rax
  8009ba:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009bf:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009c6:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009c7:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	83 f8 2a             	cmp    $0x2a,%eax
  8009d1:	74 1b                	je     8009ee <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009d3:	48 bf a0 26 80 00 00 	movabs $0x8026a0,%rdi
  8009da:	00 00 00 
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e2:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  8009e9:	00 00 00 
  8009ec:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009ee:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  8009f5:	00 00 00 
  8009f8:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009fc:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  800a03:	00 00 00 
  800a06:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  800a0a:	49 b8 bf 26 80 00 00 	movabs $0x8026bf,%r8
  800a11:	00 00 00 
  800a14:	48 b9 d0 26 80 00 00 	movabs $0x8026d0,%rcx
  800a1b:	00 00 00 
  800a1e:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800a25:	00 00 00 
  800a28:	48 be 7f 26 80 00 00 	movabs $0x80267f,%rsi
  800a2f:	00 00 00 
  800a32:	48 bf 20 40 80 00 00 	movabs $0x804020,%rdi
  800a39:	00 00 00 
  800a3c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	callq  *%rax
}
  800a48:	c9                   	leaveq 
  800a49:	c3                   	retq   

0000000000800a4a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a4a:	55                   	push   %rbp
  800a4b:	48 89 e5             	mov    %rsp,%rbp
  800a4e:	48 83 ec 20          	sub    $0x20,%rsp
  800a52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800a55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800a59:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  800a60:	00 00 00 
  800a63:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800a6a:	48 b8 a6 21 80 00 00 	movabs $0x8021a6,%rax
  800a71:	00 00 00 
  800a74:	ff d0                	callq  *%rax
  800a76:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800a79:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  800a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a83:	48 63 d0             	movslq %eax,%rdx
  800a86:	48 89 d0             	mov    %rdx,%rax
  800a89:	48 c1 e0 03          	shl    $0x3,%rax
  800a8d:	48 01 d0             	add    %rdx,%rax
  800a90:	48 c1 e0 05          	shl    $0x5,%rax
  800a94:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800a9b:	00 00 00 
  800a9e:	48 01 c2             	add    %rax,%rdx
  800aa1:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  800aa8:	00 00 00 
  800aab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800ab2:	7e 14                	jle    800ac8 <libmain+0x7e>
		binaryname = argv[0];
  800ab4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ab8:	48 8b 10             	mov    (%rax),%rdx
  800abb:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800ac2:	00 00 00 
  800ac5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ac8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800acc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800acf:	48 89 d6             	mov    %rdx,%rsi
  800ad2:	89 c7                	mov    %eax,%edi
  800ad4:	48 b8 87 08 80 00 00 	movabs $0x800887,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800ae0:	48 b8 ee 0a 80 00 00 	movabs $0x800aee,%rax
  800ae7:	00 00 00 
  800aea:	ff d0                	callq  *%rax
}
  800aec:	c9                   	leaveq 
  800aed:	c3                   	retq   

0000000000800aee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800aee:	55                   	push   %rbp
  800aef:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800af2:	bf 00 00 00 00       	mov    $0x0,%edi
  800af7:	48 b8 62 21 80 00 00 	movabs $0x802162,%rax
  800afe:	00 00 00 
  800b01:	ff d0                	callq  *%rax
}
  800b03:	5d                   	pop    %rbp
  800b04:	c3                   	retq   

0000000000800b05 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b05:	55                   	push   %rbp
  800b06:	48 89 e5             	mov    %rsp,%rbp
  800b09:	53                   	push   %rbx
  800b0a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b11:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b18:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b1e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b25:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b2c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b33:	84 c0                	test   %al,%al
  800b35:	74 23                	je     800b5a <_panic+0x55>
  800b37:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b3e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b42:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b46:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b4a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b4e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b52:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b56:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b5a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b61:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b68:	00 00 00 
  800b6b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b72:	00 00 00 
  800b75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b79:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b80:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b87:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b8e:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800b95:	00 00 00 
  800b98:	48 8b 18             	mov    (%rax),%rbx
  800b9b:	48 b8 a6 21 80 00 00 	movabs $0x8021a6,%rax
  800ba2:	00 00 00 
  800ba5:	ff d0                	callq  *%rax
  800ba7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800bad:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bb4:	41 89 c8             	mov    %ecx,%r8d
  800bb7:	48 89 d1             	mov    %rdx,%rcx
  800bba:	48 89 da             	mov    %rbx,%rdx
  800bbd:	89 c6                	mov    %eax,%esi
  800bbf:	48 bf e0 26 80 00 00 	movabs $0x8026e0,%rdi
  800bc6:	00 00 00 
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	49 b9 3e 0d 80 00 00 	movabs $0x800d3e,%r9
  800bd5:	00 00 00 
  800bd8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bdb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800be2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	48 89 c7             	mov    %rax,%rdi
  800bef:	48 b8 92 0c 80 00 00 	movabs $0x800c92,%rax
  800bf6:	00 00 00 
  800bf9:	ff d0                	callq  *%rax
	cprintf("\n");
  800bfb:	48 bf 03 27 80 00 00 	movabs $0x802703,%rdi
  800c02:	00 00 00 
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	48 ba 3e 0d 80 00 00 	movabs $0x800d3e,%rdx
  800c11:	00 00 00 
  800c14:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c16:	cc                   	int3   
  800c17:	eb fd                	jmp    800c16 <_panic+0x111>

0000000000800c19 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800c19:	55                   	push   %rbp
  800c1a:	48 89 e5             	mov    %rsp,%rbp
  800c1d:	48 83 ec 10          	sub    $0x10,%rsp
  800c21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2c:	8b 00                	mov    (%rax),%eax
  800c2e:	8d 48 01             	lea    0x1(%rax),%ecx
  800c31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c35:	89 0a                	mov    %ecx,(%rdx)
  800c37:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c3a:	89 d1                	mov    %edx,%ecx
  800c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c40:	48 98                	cltq   
  800c42:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4a:	8b 00                	mov    (%rax),%eax
  800c4c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c51:	75 2c                	jne    800c7f <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c57:	8b 00                	mov    (%rax),%eax
  800c59:	48 98                	cltq   
  800c5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c5f:	48 83 c2 08          	add    $0x8,%rdx
  800c63:	48 89 c6             	mov    %rax,%rsi
  800c66:	48 89 d7             	mov    %rdx,%rdi
  800c69:	48 b8 da 20 80 00 00 	movabs $0x8020da,%rax
  800c70:	00 00 00 
  800c73:	ff d0                	callq  *%rax
		b->idx = 0;
  800c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c79:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c83:	8b 40 04             	mov    0x4(%rax),%eax
  800c86:	8d 50 01             	lea    0x1(%rax),%edx
  800c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c90:	c9                   	leaveq 
  800c91:	c3                   	retq   

0000000000800c92 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800c92:	55                   	push   %rbp
  800c93:	48 89 e5             	mov    %rsp,%rbp
  800c96:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c9d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ca4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800cab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800cb2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800cb9:	48 8b 0a             	mov    (%rdx),%rcx
  800cbc:	48 89 08             	mov    %rcx,(%rax)
  800cbf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cc3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cc7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ccb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ccf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cd6:	00 00 00 
	b.cnt = 0;
  800cd9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ce0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800ce3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cf1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cf8:	48 89 c6             	mov    %rax,%rsi
  800cfb:	48 bf 19 0c 80 00 00 	movabs $0x800c19,%rdi
  800d02:	00 00 00 
  800d05:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800d11:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d17:	48 98                	cltq   
  800d19:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d20:	48 83 c2 08          	add    $0x8,%rdx
  800d24:	48 89 c6             	mov    %rax,%rsi
  800d27:	48 89 d7             	mov    %rdx,%rdi
  800d2a:	48 b8 da 20 80 00 00 	movabs $0x8020da,%rax
  800d31:	00 00 00 
  800d34:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800d36:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d3c:	c9                   	leaveq 
  800d3d:	c3                   	retq   

0000000000800d3e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d3e:	55                   	push   %rbp
  800d3f:	48 89 e5             	mov    %rsp,%rbp
  800d42:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d49:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d50:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d57:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d65:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6c:	84 c0                	test   %al,%al
  800d6e:	74 20                	je     800d90 <cprintf+0x52>
  800d70:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d74:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d78:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d80:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d84:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d88:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d90:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800d97:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d9e:	00 00 00 
  800da1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800da8:	00 00 00 
  800dab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800daf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800db6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dc4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dcb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dd2:	48 8b 0a             	mov    (%rdx),%rcx
  800dd5:	48 89 08             	mov    %rcx,(%rax)
  800dd8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ddc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800de0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800de8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800def:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800df6:	48 89 d6             	mov    %rdx,%rsi
  800df9:	48 89 c7             	mov    %rax,%rdi
  800dfc:	48 b8 92 0c 80 00 00 	movabs $0x800c92,%rax
  800e03:	00 00 00 
  800e06:	ff d0                	callq  *%rax
  800e08:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800e0e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e14:	c9                   	leaveq 
  800e15:	c3                   	retq   

0000000000800e16 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e16:	55                   	push   %rbp
  800e17:	48 89 e5             	mov    %rsp,%rbp
  800e1a:	53                   	push   %rbx
  800e1b:	48 83 ec 38          	sub    $0x38,%rsp
  800e1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e27:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e2b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e2e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e32:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e36:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e39:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e3d:	77 3b                	ja     800e7a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e3f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e42:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e46:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e52:	48 f7 f3             	div    %rbx
  800e55:	48 89 c2             	mov    %rax,%rdx
  800e58:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e5b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e5e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	41 89 f9             	mov    %edi,%r9d
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 16 0e 80 00 00 	movabs $0x800e16,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	eb 1e                	jmp    800e98 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e7a:	eb 12                	jmp    800e8e <printnum+0x78>
			putch(padc, putdat);
  800e7c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e80:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e87:	48 89 ce             	mov    %rcx,%rsi
  800e8a:	89 d7                	mov    %edx,%edi
  800e8c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e8e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e92:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e96:	7f e4                	jg     800e7c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e98:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea4:	48 f7 f1             	div    %rcx
  800ea7:	48 89 d0             	mov    %rdx,%rax
  800eaa:	48 ba 10 28 80 00 00 	movabs $0x802810,%rdx
  800eb1:	00 00 00 
  800eb4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800eb8:	0f be d0             	movsbl %al,%edx
  800ebb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 89 ce             	mov    %rcx,%rsi
  800ec6:	89 d7                	mov    %edx,%edi
  800ec8:	ff d0                	callq  *%rax
}
  800eca:	48 83 c4 38          	add    $0x38,%rsp
  800ece:	5b                   	pop    %rbx
  800ecf:	5d                   	pop    %rbp
  800ed0:	c3                   	retq   

0000000000800ed1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ed1:	55                   	push   %rbp
  800ed2:	48 89 e5             	mov    %rsp,%rbp
  800ed5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ee0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ee4:	7e 52                	jle    800f38 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eea:	8b 00                	mov    (%rax),%eax
  800eec:	83 f8 30             	cmp    $0x30,%eax
  800eef:	73 24                	jae    800f15 <getuint+0x44>
  800ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	8b 00                	mov    (%rax),%eax
  800eff:	89 c0                	mov    %eax,%eax
  800f01:	48 01 d0             	add    %rdx,%rax
  800f04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f08:	8b 12                	mov    (%rdx),%edx
  800f0a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f0d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f11:	89 0a                	mov    %ecx,(%rdx)
  800f13:	eb 17                	jmp    800f2c <getuint+0x5b>
  800f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f19:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f1d:	48 89 d0             	mov    %rdx,%rax
  800f20:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f28:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f2c:	48 8b 00             	mov    (%rax),%rax
  800f2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f33:	e9 a3 00 00 00       	jmpq   800fdb <getuint+0x10a>
	else if (lflag)
  800f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f3c:	74 4f                	je     800f8d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	8b 00                	mov    (%rax),%eax
  800f44:	83 f8 30             	cmp    $0x30,%eax
  800f47:	73 24                	jae    800f6d <getuint+0x9c>
  800f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	8b 00                	mov    (%rax),%eax
  800f57:	89 c0                	mov    %eax,%eax
  800f59:	48 01 d0             	add    %rdx,%rax
  800f5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f60:	8b 12                	mov    (%rdx),%edx
  800f62:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f69:	89 0a                	mov    %ecx,(%rdx)
  800f6b:	eb 17                	jmp    800f84 <getuint+0xb3>
  800f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f71:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f75:	48 89 d0             	mov    %rdx,%rax
  800f78:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f80:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f84:	48 8b 00             	mov    (%rax),%rax
  800f87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f8b:	eb 4e                	jmp    800fdb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f91:	8b 00                	mov    (%rax),%eax
  800f93:	83 f8 30             	cmp    $0x30,%eax
  800f96:	73 24                	jae    800fbc <getuint+0xeb>
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	8b 00                	mov    (%rax),%eax
  800fa6:	89 c0                	mov    %eax,%eax
  800fa8:	48 01 d0             	add    %rdx,%rax
  800fab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800faf:	8b 12                	mov    (%rdx),%edx
  800fb1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb8:	89 0a                	mov    %ecx,(%rdx)
  800fba:	eb 17                	jmp    800fd3 <getuint+0x102>
  800fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fc4:	48 89 d0             	mov    %rdx,%rax
  800fc7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fcb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fcf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fd3:	8b 00                	mov    (%rax),%eax
  800fd5:	89 c0                	mov    %eax,%eax
  800fd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fe9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ff0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ff4:	7e 52                	jle    801048 <getint+0x67>
		x=va_arg(*ap, long long);
  800ff6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffa:	8b 00                	mov    (%rax),%eax
  800ffc:	83 f8 30             	cmp    $0x30,%eax
  800fff:	73 24                	jae    801025 <getint+0x44>
  801001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801005:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	8b 00                	mov    (%rax),%eax
  80100f:	89 c0                	mov    %eax,%eax
  801011:	48 01 d0             	add    %rdx,%rax
  801014:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801018:	8b 12                	mov    (%rdx),%edx
  80101a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80101d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801021:	89 0a                	mov    %ecx,(%rdx)
  801023:	eb 17                	jmp    80103c <getint+0x5b>
  801025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801029:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80102d:	48 89 d0             	mov    %rdx,%rax
  801030:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801034:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801038:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80103c:	48 8b 00             	mov    (%rax),%rax
  80103f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801043:	e9 a3 00 00 00       	jmpq   8010eb <getint+0x10a>
	else if (lflag)
  801048:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80104c:	74 4f                	je     80109d <getint+0xbc>
		x=va_arg(*ap, long);
  80104e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801052:	8b 00                	mov    (%rax),%eax
  801054:	83 f8 30             	cmp    $0x30,%eax
  801057:	73 24                	jae    80107d <getint+0x9c>
  801059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	8b 00                	mov    (%rax),%eax
  801067:	89 c0                	mov    %eax,%eax
  801069:	48 01 d0             	add    %rdx,%rax
  80106c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801070:	8b 12                	mov    (%rdx),%edx
  801072:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801075:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801079:	89 0a                	mov    %ecx,(%rdx)
  80107b:	eb 17                	jmp    801094 <getint+0xb3>
  80107d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801081:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801085:	48 89 d0             	mov    %rdx,%rax
  801088:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80108c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801090:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801094:	48 8b 00             	mov    (%rax),%rax
  801097:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80109b:	eb 4e                	jmp    8010eb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80109d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a1:	8b 00                	mov    (%rax),%eax
  8010a3:	83 f8 30             	cmp    $0x30,%eax
  8010a6:	73 24                	jae    8010cc <getint+0xeb>
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	8b 00                	mov    (%rax),%eax
  8010b6:	89 c0                	mov    %eax,%eax
  8010b8:	48 01 d0             	add    %rdx,%rax
  8010bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010bf:	8b 12                	mov    (%rdx),%edx
  8010c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c8:	89 0a                	mov    %ecx,(%rdx)
  8010ca:	eb 17                	jmp    8010e3 <getint+0x102>
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010d4:	48 89 d0             	mov    %rdx,%rax
  8010d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010e3:	8b 00                	mov    (%rax),%eax
  8010e5:	48 98                	cltq   
  8010e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	41 54                	push   %r12
  8010f7:	53                   	push   %rbx
  8010f8:	48 83 ec 60          	sub    $0x60,%rsp
  8010fc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801100:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801104:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801108:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80110c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801110:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801114:	48 8b 0a             	mov    (%rdx),%rcx
  801117:	48 89 08             	mov    %rcx,(%rax)
  80111a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801122:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801126:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112a:	eb 17                	jmp    801143 <vprintfmt+0x52>
			if (ch == '\0')
  80112c:	85 db                	test   %ebx,%ebx
  80112e:	0f 84 cc 04 00 00    	je     801600 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  801134:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801138:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80113c:	48 89 d6             	mov    %rdx,%rsi
  80113f:	89 df                	mov    %ebx,%edi
  801141:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801143:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801147:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80114b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80114f:	0f b6 00             	movzbl (%rax),%eax
  801152:	0f b6 d8             	movzbl %al,%ebx
  801155:	83 fb 25             	cmp    $0x25,%ebx
  801158:	75 d2                	jne    80112c <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  80115a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80115e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801165:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80116c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801173:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80117a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80117e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801182:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801186:	0f b6 00             	movzbl (%rax),%eax
  801189:	0f b6 d8             	movzbl %al,%ebx
  80118c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80118f:	83 f8 55             	cmp    $0x55,%eax
  801192:	0f 87 34 04 00 00    	ja     8015cc <vprintfmt+0x4db>
  801198:	89 c0                	mov    %eax,%eax
  80119a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8011a1:	00 
  8011a2:	48 b8 38 28 80 00 00 	movabs $0x802838,%rax
  8011a9:	00 00 00 
  8011ac:	48 01 d0             	add    %rdx,%rax
  8011af:	48 8b 00             	mov    (%rax),%rax
  8011b2:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011b4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011b8:	eb c0                	jmp    80117a <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011ba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011be:	eb ba                	jmp    80117a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011c7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	01 d8                	add    %ebx,%eax
  8011d5:	83 e8 30             	sub    $0x30,%eax
  8011d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011df:	0f b6 00             	movzbl (%rax),%eax
  8011e2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011e5:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e8:	7e 0c                	jle    8011f6 <vprintfmt+0x105>
  8011ea:	83 fb 39             	cmp    $0x39,%ebx
  8011ed:	7f 07                	jg     8011f6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011f4:	eb d1                	jmp    8011c7 <vprintfmt+0xd6>
			goto process_precision;
  8011f6:	eb 58                	jmp    801250 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011fb:	83 f8 30             	cmp    $0x30,%eax
  8011fe:	73 17                	jae    801217 <vprintfmt+0x126>
  801200:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801204:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801207:	89 c0                	mov    %eax,%eax
  801209:	48 01 d0             	add    %rdx,%rax
  80120c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80120f:	83 c2 08             	add    $0x8,%edx
  801212:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801215:	eb 0f                	jmp    801226 <vprintfmt+0x135>
  801217:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80121b:	48 89 d0             	mov    %rdx,%rax
  80121e:	48 83 c2 08          	add    $0x8,%rdx
  801222:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801226:	8b 00                	mov    (%rax),%eax
  801228:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80122b:	eb 23                	jmp    801250 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80122d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801231:	79 0c                	jns    80123f <vprintfmt+0x14e>
				width = 0;
  801233:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80123a:	e9 3b ff ff ff       	jmpq   80117a <vprintfmt+0x89>
  80123f:	e9 36 ff ff ff       	jmpq   80117a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801244:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80124b:	e9 2a ff ff ff       	jmpq   80117a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801250:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801254:	79 12                	jns    801268 <vprintfmt+0x177>
				width = precision, precision = -1;
  801256:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801259:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80125c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801263:	e9 12 ff ff ff       	jmpq   80117a <vprintfmt+0x89>
  801268:	e9 0d ff ff ff       	jmpq   80117a <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80126d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801271:	e9 04 ff ff ff       	jmpq   80117a <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  801276:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801279:	83 f8 30             	cmp    $0x30,%eax
  80127c:	73 17                	jae    801295 <vprintfmt+0x1a4>
  80127e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801282:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801285:	89 c0                	mov    %eax,%eax
  801287:	48 01 d0             	add    %rdx,%rax
  80128a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80128d:	83 c2 08             	add    $0x8,%edx
  801290:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801293:	eb 0f                	jmp    8012a4 <vprintfmt+0x1b3>
  801295:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801299:	48 89 d0             	mov    %rdx,%rax
  80129c:	48 83 c2 08          	add    $0x8,%rdx
  8012a0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012a4:	8b 10                	mov    (%rax),%edx
  8012a6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8012aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ae:	48 89 ce             	mov    %rcx,%rsi
  8012b1:	89 d7                	mov    %edx,%edi
  8012b3:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8012b5:	e9 40 03 00 00       	jmpq   8015fa <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8012ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012bd:	83 f8 30             	cmp    $0x30,%eax
  8012c0:	73 17                	jae    8012d9 <vprintfmt+0x1e8>
  8012c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012c9:	89 c0                	mov    %eax,%eax
  8012cb:	48 01 d0             	add    %rdx,%rax
  8012ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012d1:	83 c2 08             	add    $0x8,%edx
  8012d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x1f7>
  8012d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012dd:	48 89 d0             	mov    %rdx,%rax
  8012e0:	48 83 c2 08          	add    $0x8,%rdx
  8012e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012e8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012ea:	85 db                	test   %ebx,%ebx
  8012ec:	79 02                	jns    8012f0 <vprintfmt+0x1ff>
				err = -err;
  8012ee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012f0:	83 fb 09             	cmp    $0x9,%ebx
  8012f3:	7f 16                	jg     80130b <vprintfmt+0x21a>
  8012f5:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  8012fc:	00 00 00 
  8012ff:	48 63 d3             	movslq %ebx,%rdx
  801302:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801306:	4d 85 e4             	test   %r12,%r12
  801309:	75 2e                	jne    801339 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80130b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80130f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801313:	89 d9                	mov    %ebx,%ecx
  801315:	48 ba 21 28 80 00 00 	movabs $0x802821,%rdx
  80131c:	00 00 00 
  80131f:	48 89 c7             	mov    %rax,%rdi
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
  801327:	49 b8 09 16 80 00 00 	movabs $0x801609,%r8
  80132e:	00 00 00 
  801331:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801334:	e9 c1 02 00 00       	jmpq   8015fa <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801339:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80133d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801341:	4c 89 e1             	mov    %r12,%rcx
  801344:	48 ba 2a 28 80 00 00 	movabs $0x80282a,%rdx
  80134b:	00 00 00 
  80134e:	48 89 c7             	mov    %rax,%rdi
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
  801356:	49 b8 09 16 80 00 00 	movabs $0x801609,%r8
  80135d:	00 00 00 
  801360:	41 ff d0             	callq  *%r8
			break;
  801363:	e9 92 02 00 00       	jmpq   8015fa <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  801368:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80136b:	83 f8 30             	cmp    $0x30,%eax
  80136e:	73 17                	jae    801387 <vprintfmt+0x296>
  801370:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801374:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801377:	89 c0                	mov    %eax,%eax
  801379:	48 01 d0             	add    %rdx,%rax
  80137c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80137f:	83 c2 08             	add    $0x8,%edx
  801382:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801385:	eb 0f                	jmp    801396 <vprintfmt+0x2a5>
  801387:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80138b:	48 89 d0             	mov    %rdx,%rax
  80138e:	48 83 c2 08          	add    $0x8,%rdx
  801392:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801396:	4c 8b 20             	mov    (%rax),%r12
  801399:	4d 85 e4             	test   %r12,%r12
  80139c:	75 0a                	jne    8013a8 <vprintfmt+0x2b7>
				p = "(null)";
  80139e:	49 bc 2d 28 80 00 00 	movabs $0x80282d,%r12
  8013a5:	00 00 00 
			if (width > 0 && padc != '-')
  8013a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013ac:	7e 3f                	jle    8013ed <vprintfmt+0x2fc>
  8013ae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8013b2:	74 39                	je     8013ed <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8013b7:	48 98                	cltq   
  8013b9:	48 89 c6             	mov    %rax,%rsi
  8013bc:	4c 89 e7             	mov    %r12,%rdi
  8013bf:	48 b8 b5 18 80 00 00 	movabs $0x8018b5,%rax
  8013c6:	00 00 00 
  8013c9:	ff d0                	callq  *%rax
  8013cb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013ce:	eb 17                	jmp    8013e7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013d0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013dc:	48 89 ce             	mov    %rcx,%rsi
  8013df:	89 d7                	mov    %edx,%edi
  8013e1:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013eb:	7f e3                	jg     8013d0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013ed:	eb 37                	jmp    801426 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013f3:	74 1e                	je     801413 <vprintfmt+0x322>
  8013f5:	83 fb 1f             	cmp    $0x1f,%ebx
  8013f8:	7e 05                	jle    8013ff <vprintfmt+0x30e>
  8013fa:	83 fb 7e             	cmp    $0x7e,%ebx
  8013fd:	7e 14                	jle    801413 <vprintfmt+0x322>
					putch('?', putdat);
  8013ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801403:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80140f:	ff d0                	callq  *%rax
  801411:	eb 0f                	jmp    801422 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801413:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801417:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80141b:	48 89 d6             	mov    %rdx,%rsi
  80141e:	89 df                	mov    %ebx,%edi
  801420:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801422:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801426:	4c 89 e0             	mov    %r12,%rax
  801429:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	0f be d8             	movsbl %al,%ebx
  801433:	85 db                	test   %ebx,%ebx
  801435:	74 10                	je     801447 <vprintfmt+0x356>
  801437:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80143b:	78 b2                	js     8013ef <vprintfmt+0x2fe>
  80143d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801441:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801445:	79 a8                	jns    8013ef <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801447:	eb 16                	jmp    80145f <vprintfmt+0x36e>
				putch(' ', putdat);
  801449:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80144d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801451:	48 89 d6             	mov    %rdx,%rsi
  801454:	bf 20 00 00 00       	mov    $0x20,%edi
  801459:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80145b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80145f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801463:	7f e4                	jg     801449 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  801465:	e9 90 01 00 00       	jmpq   8015fa <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  80146a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80146e:	be 03 00 00 00       	mov    $0x3,%esi
  801473:	48 89 c7             	mov    %rax,%rdi
  801476:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  80147d:	00 00 00 
  801480:	ff d0                	callq  *%rax
  801482:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 85 c0             	test   %rax,%rax
  80148d:	79 1d                	jns    8014ac <vprintfmt+0x3bb>
				putch('-', putdat);
  80148f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801493:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801497:	48 89 d6             	mov    %rdx,%rsi
  80149a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80149f:	ff d0                	callq  *%rax
				num = -(long long) num;
  8014a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a5:	48 f7 d8             	neg    %rax
  8014a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8014ac:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014b3:	e9 d5 00 00 00       	jmpq   80158d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  8014b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014bc:	be 03 00 00 00       	mov    $0x3,%esi
  8014c1:	48 89 c7             	mov    %rax,%rdi
  8014c4:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  8014cb:	00 00 00 
  8014ce:	ff d0                	callq  *%rax
  8014d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014d4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014db:	e9 ad 00 00 00       	jmpq   80158d <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  8014e0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014e4:	be 03 00 00 00       	mov    $0x3,%esi
  8014e9:	48 89 c7             	mov    %rax,%rdi
  8014ec:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  8014f3:	00 00 00 
  8014f6:	ff d0                	callq  *%rax
  8014f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014fc:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801503:	e9 85 00 00 00       	jmpq   80158d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  801508:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80150c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801510:	48 89 d6             	mov    %rdx,%rsi
  801513:	bf 30 00 00 00       	mov    $0x30,%edi
  801518:	ff d0                	callq  *%rax
			putch('x', putdat);
  80151a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80151e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801522:	48 89 d6             	mov    %rdx,%rsi
  801525:	bf 78 00 00 00       	mov    $0x78,%edi
  80152a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80152c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80152f:	83 f8 30             	cmp    $0x30,%eax
  801532:	73 17                	jae    80154b <vprintfmt+0x45a>
  801534:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801538:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80153b:	89 c0                	mov    %eax,%eax
  80153d:	48 01 d0             	add    %rdx,%rax
  801540:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801543:	83 c2 08             	add    $0x8,%edx
  801546:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801549:	eb 0f                	jmp    80155a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80154b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80154f:	48 89 d0             	mov    %rdx,%rax
  801552:	48 83 c2 08          	add    $0x8,%rdx
  801556:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80155a:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80155d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801561:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801568:	eb 23                	jmp    80158d <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  80156a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80156e:	be 03 00 00 00       	mov    $0x3,%esi
  801573:	48 89 c7             	mov    %rax,%rdi
  801576:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  80157d:	00 00 00 
  801580:	ff d0                	callq  *%rax
  801582:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801586:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  80158d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801592:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801595:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80159c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8015a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015a4:	45 89 c1             	mov    %r8d,%r9d
  8015a7:	41 89 f8             	mov    %edi,%r8d
  8015aa:	48 89 c7             	mov    %rax,%rdi
  8015ad:	48 b8 16 0e 80 00 00 	movabs $0x800e16,%rax
  8015b4:	00 00 00 
  8015b7:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  8015b9:	eb 3f                	jmp    8015fa <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015c3:	48 89 d6             	mov    %rdx,%rsi
  8015c6:	89 df                	mov    %ebx,%edi
  8015c8:	ff d0                	callq  *%rax
			break;
  8015ca:	eb 2e                	jmp    8015fa <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015d4:	48 89 d6             	mov    %rdx,%rsi
  8015d7:	bf 25 00 00 00       	mov    $0x25,%edi
  8015dc:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  8015de:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015e3:	eb 05                	jmp    8015ea <vprintfmt+0x4f9>
  8015e5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015ea:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015ee:	48 83 e8 01          	sub    $0x1,%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	3c 25                	cmp    $0x25,%al
  8015f7:	75 ec                	jne    8015e5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8015f9:	90                   	nop
		}
	}
  8015fa:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015fb:	e9 43 fb ff ff       	jmpq   801143 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801600:	48 83 c4 60          	add    $0x60,%rsp
  801604:	5b                   	pop    %rbx
  801605:	41 5c                	pop    %r12
  801607:	5d                   	pop    %rbp
  801608:	c3                   	retq   

0000000000801609 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801609:	55                   	push   %rbp
  80160a:	48 89 e5             	mov    %rsp,%rbp
  80160d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801614:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80161b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801622:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801629:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801630:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801637:	84 c0                	test   %al,%al
  801639:	74 20                	je     80165b <printfmt+0x52>
  80163b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80163f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801643:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801647:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80164b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80164f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801653:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801657:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80165b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801662:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801669:	00 00 00 
  80166c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801673:	00 00 00 
  801676:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80167a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801681:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801688:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80168f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801696:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80169d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8016a4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016ab:	48 89 c7             	mov    %rax,%rdi
  8016ae:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  8016b5:	00 00 00 
  8016b8:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016ba:	c9                   	leaveq 
  8016bb:	c3                   	retq   

00000000008016bc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016bc:	55                   	push   %rbp
  8016bd:	48 89 e5             	mov    %rsp,%rbp
  8016c0:	48 83 ec 10          	sub    $0x10,%rsp
  8016c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cf:	8b 40 10             	mov    0x10(%rax),%eax
  8016d2:	8d 50 01             	lea    0x1(%rax),%edx
  8016d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e0:	48 8b 10             	mov    (%rax),%rdx
  8016e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016eb:	48 39 c2             	cmp    %rax,%rdx
  8016ee:	73 17                	jae    801707 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 8b 00             	mov    (%rax),%rax
  8016f7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ff:	48 89 0a             	mov    %rcx,(%rdx)
  801702:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801705:	88 10                	mov    %dl,(%rax)
}
  801707:	c9                   	leaveq 
  801708:	c3                   	retq   

0000000000801709 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801709:	55                   	push   %rbp
  80170a:	48 89 e5             	mov    %rsp,%rbp
  80170d:	48 83 ec 50          	sub    $0x50,%rsp
  801711:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801715:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801718:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80171c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801720:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801724:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801728:	48 8b 0a             	mov    (%rdx),%rcx
  80172b:	48 89 08             	mov    %rcx,(%rax)
  80172e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801732:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801736:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80173a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80173e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801742:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801746:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801749:	48 98                	cltq   
  80174b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80174f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801753:	48 01 d0             	add    %rdx,%rax
  801756:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80175a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801761:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801766:	74 06                	je     80176e <vsnprintf+0x65>
  801768:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80176c:	7f 07                	jg     801775 <vsnprintf+0x6c>
		return -E_INVAL;
  80176e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801773:	eb 2f                	jmp    8017a4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801775:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801779:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80177d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801781:	48 89 c6             	mov    %rax,%rsi
  801784:	48 bf bc 16 80 00 00 	movabs $0x8016bc,%rdi
  80178b:	00 00 00 
  80178e:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  801795:	00 00 00 
  801798:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80179a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8017a1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8017b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017b8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017be:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017c5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017cc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017d3:	84 c0                	test   %al,%al
  8017d5:	74 20                	je     8017f7 <snprintf+0x51>
  8017d7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017db:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017df:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017e3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017e7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017eb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017ef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017f3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017f7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017fe:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801805:	00 00 00 
  801808:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80180f:	00 00 00 
  801812:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801816:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80181d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801824:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80182b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801832:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801839:	48 8b 0a             	mov    (%rdx),%rcx
  80183c:	48 89 08             	mov    %rcx,(%rax)
  80183f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801843:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801847:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80184b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80184f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801856:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80185d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801863:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80186a:	48 89 c7             	mov    %rax,%rdi
  80186d:	48 b8 09 17 80 00 00 	movabs $0x801709,%rax
  801874:	00 00 00 
  801877:	ff d0                	callq  *%rax
  801879:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80187f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 18          	sub    $0x18,%rsp
  80188f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80189a:	eb 09                	jmp    8018a5 <strlen+0x1e>
		n++;
  80189c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a9:	0f b6 00             	movzbl (%rax),%eax
  8018ac:	84 c0                	test   %al,%al
  8018ae:	75 ec                	jne    80189c <strlen+0x15>
		n++;
	return n;
  8018b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018b3:	c9                   	leaveq 
  8018b4:	c3                   	retq   

00000000008018b5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018b5:	55                   	push   %rbp
  8018b6:	48 89 e5             	mov    %rsp,%rbp
  8018b9:	48 83 ec 20          	sub    $0x20,%rsp
  8018bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018cc:	eb 0e                	jmp    8018dc <strnlen+0x27>
		n++;
  8018ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018d7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018dc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018e1:	74 0b                	je     8018ee <strnlen+0x39>
  8018e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e7:	0f b6 00             	movzbl (%rax),%eax
  8018ea:	84 c0                	test   %al,%al
  8018ec:	75 e0                	jne    8018ce <strnlen+0x19>
		n++;
	return n;
  8018ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018f1:	c9                   	leaveq 
  8018f2:	c3                   	retq   

00000000008018f3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
  8018f7:	48 83 ec 20          	sub    $0x20,%rsp
  8018fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801907:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80190b:	90                   	nop
  80190c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801910:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801914:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801918:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80191c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801920:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801924:	0f b6 12             	movzbl (%rdx),%edx
  801927:	88 10                	mov    %dl,(%rax)
  801929:	0f b6 00             	movzbl (%rax),%eax
  80192c:	84 c0                	test   %al,%al
  80192e:	75 dc                	jne    80190c <strcpy+0x19>
		/* do nothing */;
	return ret;
  801930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801934:	c9                   	leaveq 
  801935:	c3                   	retq   

0000000000801936 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801936:	55                   	push   %rbp
  801937:	48 89 e5             	mov    %rsp,%rbp
  80193a:	48 83 ec 20          	sub    $0x20,%rsp
  80193e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801942:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80194a:	48 89 c7             	mov    %rax,%rdi
  80194d:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801954:	00 00 00 
  801957:	ff d0                	callq  *%rax
  801959:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80195c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195f:	48 63 d0             	movslq %eax,%rdx
  801962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801966:	48 01 c2             	add    %rax,%rdx
  801969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80196d:	48 89 c6             	mov    %rax,%rsi
  801970:	48 89 d7             	mov    %rdx,%rdi
  801973:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  80197a:	00 00 00 
  80197d:	ff d0                	callq  *%rax
	return dst;
  80197f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 28          	sub    $0x28,%rsp
  80198d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801991:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801995:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8019a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019a8:	00 
  8019a9:	eb 2a                	jmp    8019d5 <strncpy+0x50>
		*dst++ = *src;
  8019ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019bb:	0f b6 12             	movzbl (%rdx),%edx
  8019be:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019c4:	0f b6 00             	movzbl (%rax),%eax
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 05                	je     8019d0 <strncpy+0x4b>
			src++;
  8019cb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019d0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019dd:	72 cc                	jb     8019ab <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019e3:	c9                   	leaveq 
  8019e4:	c3                   	retq   

00000000008019e5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019e5:	55                   	push   %rbp
  8019e6:	48 89 e5             	mov    %rsp,%rbp
  8019e9:	48 83 ec 28          	sub    $0x28,%rsp
  8019ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801a01:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a06:	74 3d                	je     801a45 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801a08:	eb 1d                	jmp    801a27 <strlcpy+0x42>
			*dst++ = *src++;
  801a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a0e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a12:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a1a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a1e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a22:	0f b6 12             	movzbl (%rdx),%edx
  801a25:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a27:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a2c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a31:	74 0b                	je     801a3e <strlcpy+0x59>
  801a33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a37:	0f b6 00             	movzbl (%rax),%eax
  801a3a:	84 c0                	test   %al,%al
  801a3c:	75 cc                	jne    801a0a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a42:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	48 29 c2             	sub    %rax,%rdx
  801a50:	48 89 d0             	mov    %rdx,%rax
}
  801a53:	c9                   	leaveq 
  801a54:	c3                   	retq   

0000000000801a55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a55:	55                   	push   %rbp
  801a56:	48 89 e5             	mov    %rsp,%rbp
  801a59:	48 83 ec 10          	sub    $0x10,%rsp
  801a5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a65:	eb 0a                	jmp    801a71 <strcmp+0x1c>
		p++, q++;
  801a67:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a6c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a75:	0f b6 00             	movzbl (%rax),%eax
  801a78:	84 c0                	test   %al,%al
  801a7a:	74 12                	je     801a8e <strcmp+0x39>
  801a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a80:	0f b6 10             	movzbl (%rax),%edx
  801a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a87:	0f b6 00             	movzbl (%rax),%eax
  801a8a:	38 c2                	cmp    %al,%dl
  801a8c:	74 d9                	je     801a67 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a92:	0f b6 00             	movzbl (%rax),%eax
  801a95:	0f b6 d0             	movzbl %al,%edx
  801a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9c:	0f b6 00             	movzbl (%rax),%eax
  801a9f:	0f b6 c0             	movzbl %al,%eax
  801aa2:	29 c2                	sub    %eax,%edx
  801aa4:	89 d0                	mov    %edx,%eax
}
  801aa6:	c9                   	leaveq 
  801aa7:	c3                   	retq   

0000000000801aa8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801aa8:	55                   	push   %rbp
  801aa9:	48 89 e5             	mov    %rsp,%rbp
  801aac:	48 83 ec 18          	sub    $0x18,%rsp
  801ab0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ab4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801abc:	eb 0f                	jmp    801acd <strncmp+0x25>
		n--, p++, q++;
  801abe:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ac3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ac8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801acd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ad2:	74 1d                	je     801af1 <strncmp+0x49>
  801ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad8:	0f b6 00             	movzbl (%rax),%eax
  801adb:	84 c0                	test   %al,%al
  801add:	74 12                	je     801af1 <strncmp+0x49>
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	0f b6 10             	movzbl (%rax),%edx
  801ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aea:	0f b6 00             	movzbl (%rax),%eax
  801aed:	38 c2                	cmp    %al,%dl
  801aef:	74 cd                	je     801abe <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801af1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801af6:	75 07                	jne    801aff <strncmp+0x57>
		return 0;
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
  801afd:	eb 18                	jmp    801b17 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b03:	0f b6 00             	movzbl (%rax),%eax
  801b06:	0f b6 d0             	movzbl %al,%edx
  801b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0d:	0f b6 00             	movzbl (%rax),%eax
  801b10:	0f b6 c0             	movzbl %al,%eax
  801b13:	29 c2                	sub    %eax,%edx
  801b15:	89 d0                	mov    %edx,%eax
}
  801b17:	c9                   	leaveq 
  801b18:	c3                   	retq   

0000000000801b19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b19:	55                   	push   %rbp
  801b1a:	48 89 e5             	mov    %rsp,%rbp
  801b1d:	48 83 ec 0c          	sub    $0xc,%rsp
  801b21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b25:	89 f0                	mov    %esi,%eax
  801b27:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b2a:	eb 17                	jmp    801b43 <strchr+0x2a>
		if (*s == c)
  801b2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b30:	0f b6 00             	movzbl (%rax),%eax
  801b33:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b36:	75 06                	jne    801b3e <strchr+0x25>
			return (char *) s;
  801b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3c:	eb 15                	jmp    801b53 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b47:	0f b6 00             	movzbl (%rax),%eax
  801b4a:	84 c0                	test   %al,%al
  801b4c:	75 de                	jne    801b2c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b53:	c9                   	leaveq 
  801b54:	c3                   	retq   

0000000000801b55 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 0c          	sub    $0xc,%rsp
  801b5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b61:	89 f0                	mov    %esi,%eax
  801b63:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b66:	eb 13                	jmp    801b7b <strfind+0x26>
		if (*s == c)
  801b68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6c:	0f b6 00             	movzbl (%rax),%eax
  801b6f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b72:	75 02                	jne    801b76 <strfind+0x21>
			break;
  801b74:	eb 10                	jmp    801b86 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b76:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7f:	0f b6 00             	movzbl (%rax),%eax
  801b82:	84 c0                	test   %al,%al
  801b84:	75 e2                	jne    801b68 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b8a:	c9                   	leaveq 
  801b8b:	c3                   	retq   

0000000000801b8c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	48 83 ec 18          	sub    $0x18,%rsp
  801b94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b98:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b9b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b9f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ba4:	75 06                	jne    801bac <memset+0x20>
		return v;
  801ba6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801baa:	eb 69                	jmp    801c15 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb0:	83 e0 03             	and    $0x3,%eax
  801bb3:	48 85 c0             	test   %rax,%rax
  801bb6:	75 48                	jne    801c00 <memset+0x74>
  801bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbc:	83 e0 03             	and    $0x3,%eax
  801bbf:	48 85 c0             	test   %rax,%rax
  801bc2:	75 3c                	jne    801c00 <memset+0x74>
		c &= 0xFF;
  801bc4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bcb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bce:	c1 e0 18             	shl    $0x18,%eax
  801bd1:	89 c2                	mov    %eax,%edx
  801bd3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd6:	c1 e0 10             	shl    $0x10,%eax
  801bd9:	09 c2                	or     %eax,%edx
  801bdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bde:	c1 e0 08             	shl    $0x8,%eax
  801be1:	09 d0                	or     %edx,%eax
  801be3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bea:	48 c1 e8 02          	shr    $0x2,%rax
  801bee:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bf1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf8:	48 89 d7             	mov    %rdx,%rdi
  801bfb:	fc                   	cld    
  801bfc:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bfe:	eb 11                	jmp    801c11 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801c00:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c04:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c07:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c0b:	48 89 d7             	mov    %rdx,%rdi
  801c0e:	fc                   	cld    
  801c0f:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c15:	c9                   	leaveq 
  801c16:	c3                   	retq   

0000000000801c17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c17:	55                   	push   %rbp
  801c18:	48 89 e5             	mov    %rsp,%rbp
  801c1b:	48 83 ec 28          	sub    $0x28,%rsp
  801c1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c27:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c43:	0f 83 88 00 00 00    	jae    801cd1 <memmove+0xba>
  801c49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c51:	48 01 d0             	add    %rdx,%rax
  801c54:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c58:	76 77                	jbe    801cd1 <memmove+0xba>
		s += n;
  801c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c66:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6e:	83 e0 03             	and    $0x3,%eax
  801c71:	48 85 c0             	test   %rax,%rax
  801c74:	75 3b                	jne    801cb1 <memmove+0x9a>
  801c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7a:	83 e0 03             	and    $0x3,%eax
  801c7d:	48 85 c0             	test   %rax,%rax
  801c80:	75 2f                	jne    801cb1 <memmove+0x9a>
  801c82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c86:	83 e0 03             	and    $0x3,%eax
  801c89:	48 85 c0             	test   %rax,%rax
  801c8c:	75 23                	jne    801cb1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c92:	48 83 e8 04          	sub    $0x4,%rax
  801c96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c9a:	48 83 ea 04          	sub    $0x4,%rdx
  801c9e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ca2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ca6:	48 89 c7             	mov    %rax,%rdi
  801ca9:	48 89 d6             	mov    %rdx,%rsi
  801cac:	fd                   	std    
  801cad:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801caf:	eb 1d                	jmp    801cce <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc5:	48 89 d7             	mov    %rdx,%rdi
  801cc8:	48 89 c1             	mov    %rax,%rcx
  801ccb:	fd                   	std    
  801ccc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cce:	fc                   	cld    
  801ccf:	eb 57                	jmp    801d28 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd5:	83 e0 03             	and    $0x3,%eax
  801cd8:	48 85 c0             	test   %rax,%rax
  801cdb:	75 36                	jne    801d13 <memmove+0xfc>
  801cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce1:	83 e0 03             	and    $0x3,%eax
  801ce4:	48 85 c0             	test   %rax,%rax
  801ce7:	75 2a                	jne    801d13 <memmove+0xfc>
  801ce9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ced:	83 e0 03             	and    $0x3,%eax
  801cf0:	48 85 c0             	test   %rax,%rax
  801cf3:	75 1e                	jne    801d13 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf9:	48 c1 e8 02          	shr    $0x2,%rax
  801cfd:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d08:	48 89 c7             	mov    %rax,%rdi
  801d0b:	48 89 d6             	mov    %rdx,%rsi
  801d0e:	fc                   	cld    
  801d0f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d11:	eb 15                	jmp    801d28 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d17:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d1b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d1f:	48 89 c7             	mov    %rax,%rdi
  801d22:	48 89 d6             	mov    %rdx,%rsi
  801d25:	fc                   	cld    
  801d26:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d2c:	c9                   	leaveq 
  801d2d:	c3                   	retq   

0000000000801d2e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 83 ec 18          	sub    $0x18,%rsp
  801d36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d3a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d46:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4e:	48 89 ce             	mov    %rcx,%rsi
  801d51:	48 89 c7             	mov    %rax,%rdi
  801d54:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  801d5b:	00 00 00 
  801d5e:	ff d0                	callq  *%rax
}
  801d60:	c9                   	leaveq 
  801d61:	c3                   	retq   

0000000000801d62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d62:	55                   	push   %rbp
  801d63:	48 89 e5             	mov    %rsp,%rbp
  801d66:	48 83 ec 28          	sub    $0x28,%rsp
  801d6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d86:	eb 36                	jmp    801dbe <memcmp+0x5c>
		if (*s1 != *s2)
  801d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8c:	0f b6 10             	movzbl (%rax),%edx
  801d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d93:	0f b6 00             	movzbl (%rax),%eax
  801d96:	38 c2                	cmp    %al,%dl
  801d98:	74 1a                	je     801db4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9e:	0f b6 00             	movzbl (%rax),%eax
  801da1:	0f b6 d0             	movzbl %al,%edx
  801da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da8:	0f b6 00             	movzbl (%rax),%eax
  801dab:	0f b6 c0             	movzbl %al,%eax
  801dae:	29 c2                	sub    %eax,%edx
  801db0:	89 d0                	mov    %edx,%eax
  801db2:	eb 20                	jmp    801dd4 <memcmp+0x72>
		s1++, s2++;
  801db4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801db9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801dc6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801dca:	48 85 c0             	test   %rax,%rax
  801dcd:	75 b9                	jne    801d88 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leaveq 
  801dd5:	c3                   	retq   

0000000000801dd6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dd6:	55                   	push   %rbp
  801dd7:	48 89 e5             	mov    %rsp,%rbp
  801dda:	48 83 ec 28          	sub    $0x28,%rsp
  801dde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801de2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801de5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801de9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ded:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801df1:	48 01 d0             	add    %rdx,%rax
  801df4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801df8:	eb 15                	jmp    801e0f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfe:	0f b6 10             	movzbl (%rax),%edx
  801e01:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e04:	38 c2                	cmp    %al,%dl
  801e06:	75 02                	jne    801e0a <memfind+0x34>
			break;
  801e08:	eb 0f                	jmp    801e19 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e0a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e13:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e17:	72 e1                	jb     801dfa <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e1d:	c9                   	leaveq 
  801e1e:	c3                   	retq   

0000000000801e1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e1f:	55                   	push   %rbp
  801e20:	48 89 e5             	mov    %rsp,%rbp
  801e23:	48 83 ec 34          	sub    $0x34,%rsp
  801e27:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e2f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e39:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e40:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e41:	eb 05                	jmp    801e48 <strtol+0x29>
		s++;
  801e43:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4c:	0f b6 00             	movzbl (%rax),%eax
  801e4f:	3c 20                	cmp    $0x20,%al
  801e51:	74 f0                	je     801e43 <strtol+0x24>
  801e53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e57:	0f b6 00             	movzbl (%rax),%eax
  801e5a:	3c 09                	cmp    $0x9,%al
  801e5c:	74 e5                	je     801e43 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e62:	0f b6 00             	movzbl (%rax),%eax
  801e65:	3c 2b                	cmp    $0x2b,%al
  801e67:	75 07                	jne    801e70 <strtol+0x51>
		s++;
  801e69:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e6e:	eb 17                	jmp    801e87 <strtol+0x68>
	else if (*s == '-')
  801e70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e74:	0f b6 00             	movzbl (%rax),%eax
  801e77:	3c 2d                	cmp    $0x2d,%al
  801e79:	75 0c                	jne    801e87 <strtol+0x68>
		s++, neg = 1;
  801e7b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e80:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e87:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e8b:	74 06                	je     801e93 <strtol+0x74>
  801e8d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e91:	75 28                	jne    801ebb <strtol+0x9c>
  801e93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e97:	0f b6 00             	movzbl (%rax),%eax
  801e9a:	3c 30                	cmp    $0x30,%al
  801e9c:	75 1d                	jne    801ebb <strtol+0x9c>
  801e9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea2:	48 83 c0 01          	add    $0x1,%rax
  801ea6:	0f b6 00             	movzbl (%rax),%eax
  801ea9:	3c 78                	cmp    $0x78,%al
  801eab:	75 0e                	jne    801ebb <strtol+0x9c>
		s += 2, base = 16;
  801ead:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801eb2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801eb9:	eb 2c                	jmp    801ee7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801ebb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ebf:	75 19                	jne    801eda <strtol+0xbb>
  801ec1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec5:	0f b6 00             	movzbl (%rax),%eax
  801ec8:	3c 30                	cmp    $0x30,%al
  801eca:	75 0e                	jne    801eda <strtol+0xbb>
		s++, base = 8;
  801ecc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ed1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ed8:	eb 0d                	jmp    801ee7 <strtol+0xc8>
	else if (base == 0)
  801eda:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ede:	75 07                	jne    801ee7 <strtol+0xc8>
		base = 10;
  801ee0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ee7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eeb:	0f b6 00             	movzbl (%rax),%eax
  801eee:	3c 2f                	cmp    $0x2f,%al
  801ef0:	7e 1d                	jle    801f0f <strtol+0xf0>
  801ef2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef6:	0f b6 00             	movzbl (%rax),%eax
  801ef9:	3c 39                	cmp    $0x39,%al
  801efb:	7f 12                	jg     801f0f <strtol+0xf0>
			dig = *s - '0';
  801efd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f01:	0f b6 00             	movzbl (%rax),%eax
  801f04:	0f be c0             	movsbl %al,%eax
  801f07:	83 e8 30             	sub    $0x30,%eax
  801f0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f0d:	eb 4e                	jmp    801f5d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f13:	0f b6 00             	movzbl (%rax),%eax
  801f16:	3c 60                	cmp    $0x60,%al
  801f18:	7e 1d                	jle    801f37 <strtol+0x118>
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	0f b6 00             	movzbl (%rax),%eax
  801f21:	3c 7a                	cmp    $0x7a,%al
  801f23:	7f 12                	jg     801f37 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f29:	0f b6 00             	movzbl (%rax),%eax
  801f2c:	0f be c0             	movsbl %al,%eax
  801f2f:	83 e8 57             	sub    $0x57,%eax
  801f32:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f35:	eb 26                	jmp    801f5d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3b:	0f b6 00             	movzbl (%rax),%eax
  801f3e:	3c 40                	cmp    $0x40,%al
  801f40:	7e 48                	jle    801f8a <strtol+0x16b>
  801f42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f46:	0f b6 00             	movzbl (%rax),%eax
  801f49:	3c 5a                	cmp    $0x5a,%al
  801f4b:	7f 3d                	jg     801f8a <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f51:	0f b6 00             	movzbl (%rax),%eax
  801f54:	0f be c0             	movsbl %al,%eax
  801f57:	83 e8 37             	sub    $0x37,%eax
  801f5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f60:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f63:	7c 02                	jl     801f67 <strtol+0x148>
			break;
  801f65:	eb 23                	jmp    801f8a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f67:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f6c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f6f:	48 98                	cltq   
  801f71:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f76:	48 89 c2             	mov    %rax,%rdx
  801f79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7c:	48 98                	cltq   
  801f7e:	48 01 d0             	add    %rdx,%rax
  801f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f85:	e9 5d ff ff ff       	jmpq   801ee7 <strtol+0xc8>

	if (endptr)
  801f8a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f8f:	74 0b                	je     801f9c <strtol+0x17d>
		*endptr = (char *) s;
  801f91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f95:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f99:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa0:	74 09                	je     801fab <strtol+0x18c>
  801fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa6:	48 f7 d8             	neg    %rax
  801fa9:	eb 04                	jmp    801faf <strtol+0x190>
  801fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801faf:	c9                   	leaveq 
  801fb0:	c3                   	retq   

0000000000801fb1 <strstr>:

char * strstr(const char *in, const char *str)
{
  801fb1:	55                   	push   %rbp
  801fb2:	48 89 e5             	mov    %rsp,%rbp
  801fb5:	48 83 ec 30          	sub    $0x30,%rsp
  801fb9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fbd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801fc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fc9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fcd:	0f b6 00             	movzbl (%rax),%eax
  801fd0:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801fd3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fd7:	75 06                	jne    801fdf <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdd:	eb 6b                	jmp    80204a <strstr+0x99>

    len = strlen(str);
  801fdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fe3:	48 89 c7             	mov    %rax,%rdi
  801fe6:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	48 98                	cltq   
  801ff4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801ff8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802000:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802004:	0f b6 00             	movzbl (%rax),%eax
  802007:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80200a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80200e:	75 07                	jne    802017 <strstr+0x66>
                return (char *) 0;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	eb 33                	jmp    80204a <strstr+0x99>
        } while (sc != c);
  802017:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80201b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80201e:	75 d8                	jne    801ff8 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  802020:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802024:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202c:	48 89 ce             	mov    %rcx,%rsi
  80202f:	48 89 c7             	mov    %rax,%rdi
  802032:	48 b8 a8 1a 80 00 00 	movabs $0x801aa8,%rax
  802039:	00 00 00 
  80203c:	ff d0                	callq  *%rax
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 b6                	jne    801ff8 <strstr+0x47>

    return (char *) (in - 1);
  802042:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802046:	48 83 e8 01          	sub    $0x1,%rax
}
  80204a:	c9                   	leaveq 
  80204b:	c3                   	retq   

000000000080204c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80204c:	55                   	push   %rbp
  80204d:	48 89 e5             	mov    %rsp,%rbp
  802050:	53                   	push   %rbx
  802051:	48 83 ec 48          	sub    $0x48,%rsp
  802055:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802058:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80205b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80205f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802063:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802067:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80206b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80206e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802072:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802076:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80207a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80207e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802082:	4c 89 c3             	mov    %r8,%rbx
  802085:	cd 30                	int    $0x30
  802087:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80208b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80208f:	74 3e                	je     8020cf <syscall+0x83>
  802091:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802096:	7e 37                	jle    8020cf <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802098:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80209c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80209f:	49 89 d0             	mov    %rdx,%r8
  8020a2:	89 c1                	mov    %eax,%ecx
  8020a4:	48 ba e8 2a 80 00 00 	movabs $0x802ae8,%rdx
  8020ab:	00 00 00 
  8020ae:	be 23 00 00 00       	mov    $0x23,%esi
  8020b3:	48 bf 05 2b 80 00 00 	movabs $0x802b05,%rdi
  8020ba:	00 00 00 
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	49 b9 05 0b 80 00 00 	movabs $0x800b05,%r9
  8020c9:	00 00 00 
  8020cc:	41 ff d1             	callq  *%r9

	return ret;
  8020cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020d3:	48 83 c4 48          	add    $0x48,%rsp
  8020d7:	5b                   	pop    %rbx
  8020d8:	5d                   	pop    %rbp
  8020d9:	c3                   	retq   

00000000008020da <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020da:	55                   	push   %rbp
  8020db:	48 89 e5             	mov    %rsp,%rbp
  8020de:	48 83 ec 20          	sub    $0x20,%rsp
  8020e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020f9:	00 
  8020fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802100:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802106:	48 89 d1             	mov    %rdx,%rcx
  802109:	48 89 c2             	mov    %rax,%rdx
  80210c:	be 00 00 00 00       	mov    $0x0,%esi
  802111:	bf 00 00 00 00       	mov    $0x0,%edi
  802116:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80211d:	00 00 00 
  802120:	ff d0                	callq  *%rax
}
  802122:	c9                   	leaveq 
  802123:	c3                   	retq   

0000000000802124 <sys_cgetc>:

int
sys_cgetc(void)
{
  802124:	55                   	push   %rbp
  802125:	48 89 e5             	mov    %rsp,%rbp
  802128:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80212c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802133:	00 
  802134:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80213a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802140:	b9 00 00 00 00       	mov    $0x0,%ecx
  802145:	ba 00 00 00 00       	mov    $0x0,%edx
  80214a:	be 00 00 00 00       	mov    $0x0,%esi
  80214f:	bf 01 00 00 00       	mov    $0x1,%edi
  802154:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
}
  802160:	c9                   	leaveq 
  802161:	c3                   	retq   

0000000000802162 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802162:	55                   	push   %rbp
  802163:	48 89 e5             	mov    %rsp,%rbp
  802166:	48 83 ec 10          	sub    $0x10,%rsp
  80216a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802170:	48 98                	cltq   
  802172:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802179:	00 
  80217a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802180:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802186:	b9 00 00 00 00       	mov    $0x0,%ecx
  80218b:	48 89 c2             	mov    %rax,%rdx
  80218e:	be 01 00 00 00       	mov    $0x1,%esi
  802193:	bf 03 00 00 00       	mov    $0x3,%edi
  802198:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	callq  *%rax
}
  8021a4:	c9                   	leaveq 
  8021a5:	c3                   	retq   

00000000008021a6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8021a6:	55                   	push   %rbp
  8021a7:	48 89 e5             	mov    %rsp,%rbp
  8021aa:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021b5:	00 
  8021b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cc:	be 00 00 00 00       	mov    $0x0,%esi
  8021d1:	bf 02 00 00 00       	mov    $0x2,%edi
  8021d6:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
}
  8021e2:	c9                   	leaveq 
  8021e3:	c3                   	retq   

00000000008021e4 <sys_yield>:

void
sys_yield(void)
{
  8021e4:	55                   	push   %rbp
  8021e5:	48 89 e5             	mov    %rsp,%rbp
  8021e8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021f3:	00 
  8021f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802200:	b9 00 00 00 00       	mov    $0x0,%ecx
  802205:	ba 00 00 00 00       	mov    $0x0,%edx
  80220a:	be 00 00 00 00       	mov    $0x0,%esi
  80220f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802214:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
}
  802220:	c9                   	leaveq 
  802221:	c3                   	retq   

0000000000802222 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802222:	55                   	push   %rbp
  802223:	48 89 e5             	mov    %rsp,%rbp
  802226:	48 83 ec 20          	sub    $0x20,%rsp
  80222a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80222d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802231:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802234:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802237:	48 63 c8             	movslq %eax,%rcx
  80223a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802241:	48 98                	cltq   
  802243:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80224a:	00 
  80224b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802251:	49 89 c8             	mov    %rcx,%r8
  802254:	48 89 d1             	mov    %rdx,%rcx
  802257:	48 89 c2             	mov    %rax,%rdx
  80225a:	be 01 00 00 00       	mov    $0x1,%esi
  80225f:	bf 04 00 00 00       	mov    $0x4,%edi
  802264:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	callq  *%rax
}
  802270:	c9                   	leaveq 
  802271:	c3                   	retq   

0000000000802272 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802272:	55                   	push   %rbp
  802273:	48 89 e5             	mov    %rsp,%rbp
  802276:	48 83 ec 30          	sub    $0x30,%rsp
  80227a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80227d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802281:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802284:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802288:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80228c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80228f:	48 63 c8             	movslq %eax,%rcx
  802292:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802296:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802299:	48 63 f0             	movslq %eax,%rsi
  80229c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a3:	48 98                	cltq   
  8022a5:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022a9:	49 89 f9             	mov    %rdi,%r9
  8022ac:	49 89 f0             	mov    %rsi,%r8
  8022af:	48 89 d1             	mov    %rdx,%rcx
  8022b2:	48 89 c2             	mov    %rax,%rdx
  8022b5:	be 01 00 00 00       	mov    $0x1,%esi
  8022ba:	bf 05 00 00 00       	mov    $0x5,%edi
  8022bf:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
}
  8022cb:	c9                   	leaveq 
  8022cc:	c3                   	retq   

00000000008022cd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022cd:	55                   	push   %rbp
  8022ce:	48 89 e5             	mov    %rsp,%rbp
  8022d1:	48 83 ec 20          	sub    $0x20,%rsp
  8022d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e3:	48 98                	cltq   
  8022e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022ec:	00 
  8022ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022f9:	48 89 d1             	mov    %rdx,%rcx
  8022fc:	48 89 c2             	mov    %rax,%rdx
  8022ff:	be 01 00 00 00       	mov    $0x1,%esi
  802304:	bf 06 00 00 00       	mov    $0x6,%edi
  802309:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 10          	sub    $0x10,%rsp
  80231f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802322:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802325:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802328:	48 63 d0             	movslq %eax,%rdx
  80232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232e:	48 98                	cltq   
  802330:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802337:	00 
  802338:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80233e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802344:	48 89 d1             	mov    %rdx,%rcx
  802347:	48 89 c2             	mov    %rax,%rdx
  80234a:	be 01 00 00 00       	mov    $0x1,%esi
  80234f:	bf 08 00 00 00       	mov    $0x8,%edi
  802354:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80235b:	00 00 00 
  80235e:	ff d0                	callq  *%rax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   

0000000000802362 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	48 83 ec 20          	sub    $0x20,%rsp
  80236a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80236d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802371:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802378:	48 98                	cltq   
  80237a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802381:	00 
  802382:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802388:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80238e:	48 89 d1             	mov    %rdx,%rcx
  802391:	48 89 c2             	mov    %rax,%rdx
  802394:	be 01 00 00 00       	mov    $0x1,%esi
  802399:	bf 09 00 00 00       	mov    $0x9,%edi
  80239e:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8023a5:	00 00 00 
  8023a8:	ff d0                	callq  *%rax
}
  8023aa:	c9                   	leaveq 
  8023ab:	c3                   	retq   

00000000008023ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023ac:	55                   	push   %rbp
  8023ad:	48 89 e5             	mov    %rsp,%rbp
  8023b0:	48 83 ec 20          	sub    $0x20,%rsp
  8023b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023bf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c5:	48 63 f0             	movslq %eax,%rsi
  8023c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cf:	48 98                	cltq   
  8023d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023dc:	00 
  8023dd:	49 89 f1             	mov    %rsi,%r9
  8023e0:	49 89 c8             	mov    %rcx,%r8
  8023e3:	48 89 d1             	mov    %rdx,%rcx
  8023e6:	48 89 c2             	mov    %rax,%rdx
  8023e9:	be 00 00 00 00       	mov    $0x0,%esi
  8023ee:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023f3:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  8023fa:	00 00 00 
  8023fd:	ff d0                	callq  *%rax
}
  8023ff:	c9                   	leaveq 
  802400:	c3                   	retq   

0000000000802401 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802401:	55                   	push   %rbp
  802402:	48 89 e5             	mov    %rsp,%rbp
  802405:	48 83 ec 10          	sub    $0x10,%rsp
  802409:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80240d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802411:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802418:	00 
  802419:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80241f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802425:	b9 00 00 00 00       	mov    $0x0,%ecx
  80242a:	48 89 c2             	mov    %rax,%rdx
  80242d:	be 01 00 00 00       	mov    $0x1,%esi
  802432:	bf 0c 00 00 00       	mov    $0xc,%edi
  802437:	48 b8 4c 20 80 00 00 	movabs $0x80204c,%rax
  80243e:	00 00 00 
  802441:	ff d0                	callq  *%rax
}
  802443:	c9                   	leaveq 
  802444:	c3                   	retq   

0000000000802445 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802445:	55                   	push   %rbp
  802446:	48 89 e5             	mov    %rsp,%rbp
  802449:	48 83 ec 10          	sub    $0x10,%rsp
  80244d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  802451:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  802458:	00 00 00 
  80245b:	48 8b 00             	mov    (%rax),%rax
  80245e:	48 85 c0             	test   %rax,%rax
  802461:	0f 85 b2 00 00 00    	jne    802519 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  802467:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  80246e:	00 00 00 
  802471:	48 8b 00             	mov    (%rax),%rax
  802474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247a:	ba 07 00 00 00       	mov    $0x7,%edx
  80247f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802484:	89 c7                	mov    %eax,%edi
  802486:	48 b8 22 22 80 00 00 	movabs $0x802222,%rax
  80248d:	00 00 00 
  802490:	ff d0                	callq  *%rax
  802492:	85 c0                	test   %eax,%eax
  802494:	74 2a                	je     8024c0 <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  802496:	48 ba 18 2b 80 00 00 	movabs $0x802b18,%rdx
  80249d:	00 00 00 
  8024a0:	be 22 00 00 00       	mov    $0x22,%esi
  8024a5:	48 bf 43 2b 80 00 00 	movabs $0x802b43,%rdi
  8024ac:	00 00 00 
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	48 b9 05 0b 80 00 00 	movabs $0x800b05,%rcx
  8024bb:	00 00 00 
  8024be:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  8024c0:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  8024c7:	00 00 00 
  8024ca:	48 8b 00             	mov    (%rax),%rax
  8024cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024d3:	48 be 2c 25 80 00 00 	movabs $0x80252c,%rsi
  8024da:	00 00 00 
  8024dd:	89 c7                	mov    %eax,%edi
  8024df:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 2a                	je     802519 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  8024ef:	48 ba 58 2b 80 00 00 	movabs $0x802b58,%rdx
  8024f6:	00 00 00 
  8024f9:	be 25 00 00 00       	mov    $0x25,%esi
  8024fe:	48 bf 43 2b 80 00 00 	movabs $0x802b43,%rdi
  802505:	00 00 00 
  802508:	b8 00 00 00 00       	mov    $0x0,%eax
  80250d:	48 b9 05 0b 80 00 00 	movabs $0x800b05,%rcx
  802514:	00 00 00 
  802517:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802519:	48 b8 f8 41 80 00 00 	movabs $0x8041f8,%rax
  802520:	00 00 00 
  802523:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802527:	48 89 10             	mov    %rdx,(%rax)
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80252c:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80252f:	48 a1 f8 41 80 00 00 	movabs 0x8041f8,%rax
  802536:	00 00 00 
	call *%rax
  802539:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  80253b:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  80253e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802545:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  802546:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80254d:	00 
	pushq %rbx;
  80254e:	53                   	push   %rbx
	movq %rsp, %rbx;	
  80254f:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  802552:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  802555:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80255c:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80255d:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  802561:	4c 8b 3c 24          	mov    (%rsp),%r15
  802565:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80256a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80256f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802574:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802579:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80257e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802583:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802588:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80258d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802592:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802597:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80259c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8025a1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8025a6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8025ab:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  8025af:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8025b3:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8025b4:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8025b5:	c3                   	retq   
