
obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 7d 27 80 00 00 	movabs $0x80277d,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 26 41 80 00 00 	movabs $0x804126,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 31 41 80 00 00 	movabs $0x804131,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 81 41 80 00 00 	movabs $0x804181,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 8a 41 80 00 00 	movabs $0x80418a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba a8 41 80 00 00 	movabs $0x8041a8,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba e9 41 80 00 00 	movabs $0x8041e9,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba f8 41 80 00 00 	movabs $0x8041f8,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf 1e 42 80 00 00 	movabs $0x80421e,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 31 42 80 00 00 	movabs $0x804231,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba 3f 42 80 00 00 	movabs $0x80423f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 5d 42 80 00 00 	movabs $0x80425d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 7f 42 80 00 00 	movabs $0x80427f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba 98 42 80 00 00 	movabs $0x804298,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf cf 42 80 00 00 	movabs $0x8042cf,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf e5 42 80 00 00 	movabs $0x8042e5,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba ef 42 80 00 00 	movabs $0x8042ef,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf 08 43 80 00 00 	movabs $0x804308,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 66 0f 80 00 00 	movabs $0x800f66,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba 48 43 80 00 00 	movabs $0x804348,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf 57 43 80 00 00 	movabs $0x804357,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 7d 1c 80 00 00 	movabs $0x801c7d,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf f8 43 80 00 00 	movabs $0x8043f8,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf 26 41 80 00 00 	movabs $0x804126,%rdi
  800833:	00 00 00 
  800836:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba 1c 44 80 00 00 	movabs $0x80441c,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 81 41 80 00 00 	movabs $0x804181,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba 4b 44 80 00 00 	movabs $0x80444b,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 87 44 80 00 00 	movabs $0x804487,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 95 44 80 00 00 	movabs $0x804495,%rdi
  800997:	00 00 00 
  80099a:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 9a 44 80 00 00 	movabs $0x80449a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 fe 2e 80 00 00 	movabs $0x802efe,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba a9 44 80 00 00 	movabs $0x8044a9,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 95 44 80 00 00 	movabs $0x804495,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba bb 44 80 00 00 	movabs $0x8044bb,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 89 2e 80 00 00 	movabs $0x802e89,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba c9 44 80 00 00 	movabs $0x8044c9,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba e0 44 80 00 00 	movabs $0x8044e0,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 2d 0d 80 00 00 	movabs $0x800d2d,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba 10 45 80 00 00 	movabs $0x804510,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf 37 45 80 00 00 	movabs $0x804537,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800c89:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 98                	cltq   
  800c97:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9c:	48 89 c2             	mov    %rax,%rdx
  800c9f:	48 89 d0             	mov    %rdx,%rax
  800ca2:	48 c1 e0 03          	shl    $0x3,%rax
  800ca6:	48 01 d0             	add    %rdx,%rax
  800ca9:	48 c1 e0 05          	shl    $0x5,%rax
  800cad:	48 89 c2             	mov    %rax,%rdx
  800cb0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800cb7:	00 00 00 
  800cba:	48 01 c2             	add    %rax,%rdx
  800cbd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cc4:	00 00 00 
  800cc7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cce:	7e 14                	jle    800ce4 <libmain+0x6a>
		binaryname = argv[0];
  800cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd4:	48 8b 10             	mov    (%rax),%rdx
  800cd7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cde:	00 00 00 
  800ce1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	89 c7                	mov    %eax,%edi
  800cf0:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cfc:	48 b8 0a 0d 80 00 00 	movabs $0x800d0a,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
}
  800d08:	c9                   	leaveq 
  800d09:	c3                   	retq   

0000000000800d0a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d0a:	55                   	push   %rbp
  800d0b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d0e:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  800d15:	00 00 00 
  800d18:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1f:	48 b8 8a 23 80 00 00 	movabs $0x80238a,%rax
  800d26:	00 00 00 
  800d29:	ff d0                	callq  *%rax
}
  800d2b:	5d                   	pop    %rbp
  800d2c:	c3                   	retq   

0000000000800d2d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d2d:	55                   	push   %rbp
  800d2e:	48 89 e5             	mov    %rsp,%rbp
  800d31:	53                   	push   %rbx
  800d32:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d39:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d40:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d46:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d4d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d54:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 23                	je     800d82 <_panic+0x55>
  800d5f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d66:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d6a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d6e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d72:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d76:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d7a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d7e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d82:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d89:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d90:	00 00 00 
  800d93:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d9a:	00 00 00 
  800d9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800da8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800daf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800db6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800dbd:	00 00 00 
  800dc0:	48 8b 18             	mov    (%rax),%rbx
  800dc3:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  800dca:	00 00 00 
  800dcd:	ff d0                	callq  *%rax
  800dcf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dd5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ddc:	41 89 c8             	mov    %ecx,%r8d
  800ddf:	48 89 d1             	mov    %rdx,%rcx
  800de2:	48 89 da             	mov    %rbx,%rdx
  800de5:	89 c6                	mov    %eax,%esi
  800de7:	48 bf 58 45 80 00 00 	movabs $0x804558,%rdi
  800dee:	00 00 00 
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	49 b9 66 0f 80 00 00 	movabs $0x800f66,%r9
  800dfd:	00 00 00 
  800e00:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e03:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800e0a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e11:	48 89 d6             	mov    %rdx,%rsi
  800e14:	48 89 c7             	mov    %rax,%rdi
  800e17:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  800e1e:	00 00 00 
  800e21:	ff d0                	callq  *%rax
	cprintf("\n");
  800e23:	48 bf 7b 45 80 00 00 	movabs $0x80457b,%rdi
  800e2a:	00 00 00 
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e32:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800e39:	00 00 00 
  800e3c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e3e:	cc                   	int3   
  800e3f:	eb fd                	jmp    800e3e <_panic+0x111>

0000000000800e41 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 10          	sub    $0x10,%rsp
  800e49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e54:	8b 00                	mov    (%rax),%eax
  800e56:	8d 48 01             	lea    0x1(%rax),%ecx
  800e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5d:	89 0a                	mov    %ecx,(%rdx)
  800e5f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e68:	48 98                	cltq   
  800e6a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	8b 00                	mov    (%rax),%eax
  800e74:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e79:	75 2c                	jne    800ea7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	8b 00                	mov    (%rax),%eax
  800e81:	48 98                	cltq   
  800e83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e87:	48 83 c2 08          	add    $0x8,%rdx
  800e8b:	48 89 c6             	mov    %rax,%rsi
  800e8e:	48 89 d7             	mov    %rdx,%rdi
  800e91:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
        b->idx = 0;
  800e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eab:	8b 40 04             	mov    0x4(%rax),%eax
  800eae:	8d 50 01             	lea    0x1(%rax),%edx
  800eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb5:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ec5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ecc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ed3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800eda:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ee1:	48 8b 0a             	mov    (%rdx),%rcx
  800ee4:	48 89 08             	mov    %rcx,(%rax)
  800ee7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eeb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ef7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800efe:	00 00 00 
    b.cnt = 0;
  800f01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800f08:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800f0b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f12:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f19:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f20:	48 89 c6             	mov    %rax,%rsi
  800f23:	48 bf 41 0e 80 00 00 	movabs $0x800e41,%rdi
  800f2a:	00 00 00 
  800f2d:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f39:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f3f:	48 98                	cltq   
  800f41:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f48:	48 83 c2 08          	add    $0x8,%rdx
  800f4c:	48 89 c6             	mov    %rax,%rsi
  800f4f:	48 89 d7             	mov    %rdx,%rdi
  800f52:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  800f59:	00 00 00 
  800f5c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f64:	c9                   	leaveq 
  800f65:	c3                   	retq   

0000000000800f66 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f66:	55                   	push   %rbp
  800f67:	48 89 e5             	mov    %rsp,%rbp
  800f6a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f71:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f78:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f7f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f86:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f8d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f94:	84 c0                	test   %al,%al
  800f96:	74 20                	je     800fb8 <cprintf+0x52>
  800f98:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f9c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fa0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fa4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fb0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fb4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800fbf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fc6:	00 00 00 
  800fc9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fd0:	00 00 00 
  800fd3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fde:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fec:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ff3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ffa:	48 8b 0a             	mov    (%rdx),%rcx
  800ffd:	48 89 08             	mov    %rcx,(%rax)
  801000:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801004:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801008:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801010:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801017:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80101e:	48 89 d6             	mov    %rdx,%rsi
  801021:	48 89 c7             	mov    %rax,%rdi
  801024:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  80102b:	00 00 00 
  80102e:	ff d0                	callq  *%rax
  801030:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801036:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80103c:	c9                   	leaveq 
  80103d:	c3                   	retq   

000000000080103e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	53                   	push   %rbx
  801043:	48 83 ec 38          	sub    $0x38,%rsp
  801047:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80104f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801053:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801056:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80105a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80105e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801061:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801065:	77 3b                	ja     8010a2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801067:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80106a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80106e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801071:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801075:	ba 00 00 00 00       	mov    $0x0,%edx
  80107a:	48 f7 f3             	div    %rbx
  80107d:	48 89 c2             	mov    %rax,%rdx
  801080:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801083:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801086:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	41 89 f9             	mov    %edi,%r9d
  801091:	48 89 c7             	mov    %rax,%rdi
  801094:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
  8010a0:	eb 1e                	jmp    8010c0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a2:	eb 12                	jmp    8010b6 <printnum+0x78>
			putch(padc, putdat);
  8010a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010a8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 89 ce             	mov    %rcx,%rsi
  8010b2:	89 d7                	mov    %edx,%edi
  8010b4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010be:	7f e4                	jg     8010a4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010c0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cc:	48 f7 f1             	div    %rcx
  8010cf:	48 89 d0             	mov    %rdx,%rax
  8010d2:	48 ba 70 47 80 00 00 	movabs $0x804770,%rdx
  8010d9:	00 00 00 
  8010dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010e0:	0f be d0             	movsbl %al,%edx
  8010e3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 89 ce             	mov    %rcx,%rsi
  8010ee:	89 d7                	mov    %edx,%edi
  8010f0:	ff d0                	callq  *%rax
}
  8010f2:	48 83 c4 38          	add    $0x38,%rsp
  8010f6:	5b                   	pop    %rbx
  8010f7:	5d                   	pop    %rbp
  8010f8:	c3                   	retq   

00000000008010f9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  801101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801105:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801108:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80110c:	7e 52                	jle    801160 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	8b 00                	mov    (%rax),%eax
  801114:	83 f8 30             	cmp    $0x30,%eax
  801117:	73 24                	jae    80113d <getuint+0x44>
  801119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801125:	8b 00                	mov    (%rax),%eax
  801127:	89 c0                	mov    %eax,%eax
  801129:	48 01 d0             	add    %rdx,%rax
  80112c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801130:	8b 12                	mov    (%rdx),%edx
  801132:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801135:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801139:	89 0a                	mov    %ecx,(%rdx)
  80113b:	eb 17                	jmp    801154 <getuint+0x5b>
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801145:	48 89 d0             	mov    %rdx,%rax
  801148:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80114c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801150:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801154:	48 8b 00             	mov    (%rax),%rax
  801157:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80115b:	e9 a3 00 00 00       	jmpq   801203 <getuint+0x10a>
	else if (lflag)
  801160:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801164:	74 4f                	je     8011b5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116a:	8b 00                	mov    (%rax),%eax
  80116c:	83 f8 30             	cmp    $0x30,%eax
  80116f:	73 24                	jae    801195 <getuint+0x9c>
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	8b 00                	mov    (%rax),%eax
  80117f:	89 c0                	mov    %eax,%eax
  801181:	48 01 d0             	add    %rdx,%rax
  801184:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801188:	8b 12                	mov    (%rdx),%edx
  80118a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80118d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801191:	89 0a                	mov    %ecx,(%rdx)
  801193:	eb 17                	jmp    8011ac <getuint+0xb3>
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80119d:	48 89 d0             	mov    %rdx,%rax
  8011a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ac:	48 8b 00             	mov    (%rax),%rax
  8011af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011b3:	eb 4e                	jmp    801203 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	8b 00                	mov    (%rax),%eax
  8011bb:	83 f8 30             	cmp    $0x30,%eax
  8011be:	73 24                	jae    8011e4 <getuint+0xeb>
  8011c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cc:	8b 00                	mov    (%rax),%eax
  8011ce:	89 c0                	mov    %eax,%eax
  8011d0:	48 01 d0             	add    %rdx,%rax
  8011d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d7:	8b 12                	mov    (%rdx),%edx
  8011d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e0:	89 0a                	mov    %ecx,(%rdx)
  8011e2:	eb 17                	jmp    8011fb <getuint+0x102>
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011ec:	48 89 d0             	mov    %rdx,%rax
  8011ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011fb:	8b 00                	mov    (%rax),%eax
  8011fd:	89 c0                	mov    %eax,%eax
  8011ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 1c          	sub    $0x1c,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801218:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80121c:	7e 52                	jle    801270 <getint+0x67>
		x=va_arg(*ap, long long);
  80121e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801222:	8b 00                	mov    (%rax),%eax
  801224:	83 f8 30             	cmp    $0x30,%eax
  801227:	73 24                	jae    80124d <getint+0x44>
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	8b 00                	mov    (%rax),%eax
  801237:	89 c0                	mov    %eax,%eax
  801239:	48 01 d0             	add    %rdx,%rax
  80123c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801240:	8b 12                	mov    (%rdx),%edx
  801242:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801245:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801249:	89 0a                	mov    %ecx,(%rdx)
  80124b:	eb 17                	jmp    801264 <getint+0x5b>
  80124d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801251:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801255:	48 89 d0             	mov    %rdx,%rax
  801258:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80125c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801260:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801264:	48 8b 00             	mov    (%rax),%rax
  801267:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80126b:	e9 a3 00 00 00       	jmpq   801313 <getint+0x10a>
	else if (lflag)
  801270:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801274:	74 4f                	je     8012c5 <getint+0xbc>
		x=va_arg(*ap, long);
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127a:	8b 00                	mov    (%rax),%eax
  80127c:	83 f8 30             	cmp    $0x30,%eax
  80127f:	73 24                	jae    8012a5 <getint+0x9c>
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128d:	8b 00                	mov    (%rax),%eax
  80128f:	89 c0                	mov    %eax,%eax
  801291:	48 01 d0             	add    %rdx,%rax
  801294:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801298:	8b 12                	mov    (%rdx),%edx
  80129a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80129d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012a1:	89 0a                	mov    %ecx,(%rdx)
  8012a3:	eb 17                	jmp    8012bc <getint+0xb3>
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ad:	48 89 d0             	mov    %rdx,%rax
  8012b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012bc:	48 8b 00             	mov    (%rax),%rax
  8012bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012c3:	eb 4e                	jmp    801313 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c9:	8b 00                	mov    (%rax),%eax
  8012cb:	83 f8 30             	cmp    $0x30,%eax
  8012ce:	73 24                	jae    8012f4 <getint+0xeb>
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	8b 00                	mov    (%rax),%eax
  8012de:	89 c0                	mov    %eax,%eax
  8012e0:	48 01 d0             	add    %rdx,%rax
  8012e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e7:	8b 12                	mov    (%rdx),%edx
  8012e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f0:	89 0a                	mov    %ecx,(%rdx)
  8012f2:	eb 17                	jmp    80130b <getint+0x102>
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012fc:	48 89 d0             	mov    %rdx,%rax
  8012ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801303:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801307:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80130b:	8b 00                	mov    (%rax),%eax
  80130d:	48 98                	cltq   
  80130f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	41 54                	push   %r12
  80131f:	53                   	push   %rbx
  801320:	48 83 ec 60          	sub    $0x60,%rsp
  801324:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801328:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80132c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801330:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801334:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801338:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80133c:	48 8b 0a             	mov    (%rdx),%rcx
  80133f:	48 89 08             	mov    %rcx,(%rax)
  801342:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801346:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80134a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80134e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801352:	eb 17                	jmp    80136b <vprintfmt+0x52>
			if (ch == '\0')
  801354:	85 db                	test   %ebx,%ebx
  801356:	0f 84 cc 04 00 00    	je     801828 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80135c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801360:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801364:	48 89 d6             	mov    %rdx,%rsi
  801367:	89 df                	mov    %ebx,%edi
  801369:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80136b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80136f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801373:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	0f b6 d8             	movzbl %al,%ebx
  80137d:	83 fb 25             	cmp    $0x25,%ebx
  801380:	75 d2                	jne    801354 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801382:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801386:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80138d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80139b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013aa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	0f b6 d8             	movzbl %al,%ebx
  8013b4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013b7:	83 f8 55             	cmp    $0x55,%eax
  8013ba:	0f 87 34 04 00 00    	ja     8017f4 <vprintfmt+0x4db>
  8013c0:	89 c0                	mov    %eax,%eax
  8013c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013c9:	00 
  8013ca:	48 b8 98 47 80 00 00 	movabs $0x804798,%rax
  8013d1:	00 00 00 
  8013d4:	48 01 d0             	add    %rdx,%rax
  8013d7:	48 8b 00             	mov    (%rax),%rax
  8013da:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8013dc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013e0:	eb c0                	jmp    8013a2 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013e2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013e6:	eb ba                	jmp    8013a2 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013ef:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	c1 e0 02             	shl    $0x2,%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	01 c0                	add    %eax,%eax
  8013fb:	01 d8                	add    %ebx,%eax
  8013fd:	83 e8 30             	sub    $0x30,%eax
  801400:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801403:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80140d:	83 fb 2f             	cmp    $0x2f,%ebx
  801410:	7e 0c                	jle    80141e <vprintfmt+0x105>
  801412:	83 fb 39             	cmp    $0x39,%ebx
  801415:	7f 07                	jg     80141e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801417:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80141c:	eb d1                	jmp    8013ef <vprintfmt+0xd6>
			goto process_precision;
  80141e:	eb 58                	jmp    801478 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801420:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801423:	83 f8 30             	cmp    $0x30,%eax
  801426:	73 17                	jae    80143f <vprintfmt+0x126>
  801428:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80142c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142f:	89 c0                	mov    %eax,%eax
  801431:	48 01 d0             	add    %rdx,%rax
  801434:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801437:	83 c2 08             	add    $0x8,%edx
  80143a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80143d:	eb 0f                	jmp    80144e <vprintfmt+0x135>
  80143f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801443:	48 89 d0             	mov    %rdx,%rax
  801446:	48 83 c2 08          	add    $0x8,%rdx
  80144a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80144e:	8b 00                	mov    (%rax),%eax
  801450:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801453:	eb 23                	jmp    801478 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  801455:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801459:	79 0c                	jns    801467 <vprintfmt+0x14e>
				width = 0;
  80145b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801462:	e9 3b ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>
  801467:	e9 36 ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80146c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801473:	e9 2a ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  801478:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80147c:	79 12                	jns    801490 <vprintfmt+0x177>
				width = precision, precision = -1;
  80147e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801481:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801484:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80148b:	e9 12 ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>
  801490:	e9 0d ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801495:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801499:	e9 04 ff ff ff       	jmpq   8013a2 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80149e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a1:	83 f8 30             	cmp    $0x30,%eax
  8014a4:	73 17                	jae    8014bd <vprintfmt+0x1a4>
  8014a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014ad:	89 c0                	mov    %eax,%eax
  8014af:	48 01 d0             	add    %rdx,%rax
  8014b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b5:	83 c2 08             	add    $0x8,%edx
  8014b8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014bb:	eb 0f                	jmp    8014cc <vprintfmt+0x1b3>
  8014bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014c1:	48 89 d0             	mov    %rdx,%rax
  8014c4:	48 83 c2 08          	add    $0x8,%rdx
  8014c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014cc:	8b 10                	mov    (%rax),%edx
  8014ce:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d6:	48 89 ce             	mov    %rcx,%rsi
  8014d9:	89 d7                	mov    %edx,%edi
  8014db:	ff d0                	callq  *%rax
			break;
  8014dd:	e9 40 03 00 00       	jmpq   801822 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8014e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e5:	83 f8 30             	cmp    $0x30,%eax
  8014e8:	73 17                	jae    801501 <vprintfmt+0x1e8>
  8014ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014f1:	89 c0                	mov    %eax,%eax
  8014f3:	48 01 d0             	add    %rdx,%rax
  8014f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014f9:	83 c2 08             	add    $0x8,%edx
  8014fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014ff:	eb 0f                	jmp    801510 <vprintfmt+0x1f7>
  801501:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801505:	48 89 d0             	mov    %rdx,%rax
  801508:	48 83 c2 08          	add    $0x8,%rdx
  80150c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801510:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801512:	85 db                	test   %ebx,%ebx
  801514:	79 02                	jns    801518 <vprintfmt+0x1ff>
				err = -err;
  801516:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801518:	83 fb 15             	cmp    $0x15,%ebx
  80151b:	7f 16                	jg     801533 <vprintfmt+0x21a>
  80151d:	48 b8 c0 46 80 00 00 	movabs $0x8046c0,%rax
  801524:	00 00 00 
  801527:	48 63 d3             	movslq %ebx,%rdx
  80152a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80152e:	4d 85 e4             	test   %r12,%r12
  801531:	75 2e                	jne    801561 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801533:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801537:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80153b:	89 d9                	mov    %ebx,%ecx
  80153d:	48 ba 81 47 80 00 00 	movabs $0x804781,%rdx
  801544:	00 00 00 
  801547:	48 89 c7             	mov    %rax,%rdi
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	49 b8 31 18 80 00 00 	movabs $0x801831,%r8
  801556:	00 00 00 
  801559:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80155c:	e9 c1 02 00 00       	jmpq   801822 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801561:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801565:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801569:	4c 89 e1             	mov    %r12,%rcx
  80156c:	48 ba 8a 47 80 00 00 	movabs $0x80478a,%rdx
  801573:	00 00 00 
  801576:	48 89 c7             	mov    %rax,%rdi
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
  80157e:	49 b8 31 18 80 00 00 	movabs $0x801831,%r8
  801585:	00 00 00 
  801588:	41 ff d0             	callq  *%r8
			break;
  80158b:	e9 92 02 00 00       	jmpq   801822 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801590:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801593:	83 f8 30             	cmp    $0x30,%eax
  801596:	73 17                	jae    8015af <vprintfmt+0x296>
  801598:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80159c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80159f:	89 c0                	mov    %eax,%eax
  8015a1:	48 01 d0             	add    %rdx,%rax
  8015a4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8015a7:	83 c2 08             	add    $0x8,%edx
  8015aa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015ad:	eb 0f                	jmp    8015be <vprintfmt+0x2a5>
  8015af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015b3:	48 89 d0             	mov    %rdx,%rax
  8015b6:	48 83 c2 08          	add    $0x8,%rdx
  8015ba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015be:	4c 8b 20             	mov    (%rax),%r12
  8015c1:	4d 85 e4             	test   %r12,%r12
  8015c4:	75 0a                	jne    8015d0 <vprintfmt+0x2b7>
				p = "(null)";
  8015c6:	49 bc 8d 47 80 00 00 	movabs $0x80478d,%r12
  8015cd:	00 00 00 
			if (width > 0 && padc != '-')
  8015d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015d4:	7e 3f                	jle    801615 <vprintfmt+0x2fc>
  8015d6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015da:	74 39                	je     801615 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015dc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015df:	48 98                	cltq   
  8015e1:	48 89 c6             	mov    %rax,%rsi
  8015e4:	4c 89 e7             	mov    %r12,%rdi
  8015e7:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8015ee:	00 00 00 
  8015f1:	ff d0                	callq  *%rax
  8015f3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015f6:	eb 17                	jmp    80160f <vprintfmt+0x2f6>
					putch(padc, putdat);
  8015f8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8015fc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801600:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801604:	48 89 ce             	mov    %rcx,%rsi
  801607:	89 d7                	mov    %edx,%edi
  801609:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80160b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80160f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801613:	7f e3                	jg     8015f8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801615:	eb 37                	jmp    80164e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801617:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80161b:	74 1e                	je     80163b <vprintfmt+0x322>
  80161d:	83 fb 1f             	cmp    $0x1f,%ebx
  801620:	7e 05                	jle    801627 <vprintfmt+0x30e>
  801622:	83 fb 7e             	cmp    $0x7e,%ebx
  801625:	7e 14                	jle    80163b <vprintfmt+0x322>
					putch('?', putdat);
  801627:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80162b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80162f:	48 89 d6             	mov    %rdx,%rsi
  801632:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801637:	ff d0                	callq  *%rax
  801639:	eb 0f                	jmp    80164a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80163b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80163f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801643:	48 89 d6             	mov    %rdx,%rsi
  801646:	89 df                	mov    %ebx,%edi
  801648:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80164a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80164e:	4c 89 e0             	mov    %r12,%rax
  801651:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	0f be d8             	movsbl %al,%ebx
  80165b:	85 db                	test   %ebx,%ebx
  80165d:	74 10                	je     80166f <vprintfmt+0x356>
  80165f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801663:	78 b2                	js     801617 <vprintfmt+0x2fe>
  801665:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801669:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166d:	79 a8                	jns    801617 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80166f:	eb 16                	jmp    801687 <vprintfmt+0x36e>
				putch(' ', putdat);
  801671:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801675:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801679:	48 89 d6             	mov    %rdx,%rsi
  80167c:	bf 20 00 00 00       	mov    $0x20,%edi
  801681:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801683:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801687:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80168b:	7f e4                	jg     801671 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80168d:	e9 90 01 00 00       	jmpq   801822 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801692:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801696:	be 03 00 00 00       	mov    $0x3,%esi
  80169b:	48 89 c7             	mov    %rax,%rdi
  80169e:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
  8016aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b2:	48 85 c0             	test   %rax,%rax
  8016b5:	79 1d                	jns    8016d4 <vprintfmt+0x3bb>
				putch('-', putdat);
  8016b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016bf:	48 89 d6             	mov    %rdx,%rsi
  8016c2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016c7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cd:	48 f7 d8             	neg    %rax
  8016d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016d4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016db:	e9 d5 00 00 00       	jmpq   8017b5 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016e0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016e4:	be 03 00 00 00       	mov    $0x3,%esi
  8016e9:	48 89 c7             	mov    %rax,%rdi
  8016ec:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	callq  *%rax
  8016f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016fc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801703:	e9 ad 00 00 00       	jmpq   8017b5 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  801708:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80170c:	be 03 00 00 00       	mov    $0x3,%esi
  801711:	48 89 c7             	mov    %rax,%rdi
  801714:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  80171b:	00 00 00 
  80171e:	ff d0                	callq  *%rax
  801720:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  801724:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  80172b:	e9 85 00 00 00       	jmpq   8017b5 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  801730:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801734:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801738:	48 89 d6             	mov    %rdx,%rsi
  80173b:	bf 30 00 00 00       	mov    $0x30,%edi
  801740:	ff d0                	callq  *%rax
			putch('x', putdat);
  801742:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801746:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80174a:	48 89 d6             	mov    %rdx,%rsi
  80174d:	bf 78 00 00 00       	mov    $0x78,%edi
  801752:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801754:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801757:	83 f8 30             	cmp    $0x30,%eax
  80175a:	73 17                	jae    801773 <vprintfmt+0x45a>
  80175c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801760:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801763:	89 c0                	mov    %eax,%eax
  801765:	48 01 d0             	add    %rdx,%rax
  801768:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80176b:	83 c2 08             	add    $0x8,%edx
  80176e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801771:	eb 0f                	jmp    801782 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801773:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801777:	48 89 d0             	mov    %rdx,%rax
  80177a:	48 83 c2 08          	add    $0x8,%rdx
  80177e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801782:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801785:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801789:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801790:	eb 23                	jmp    8017b5 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801792:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801796:	be 03 00 00 00       	mov    $0x3,%esi
  80179b:	48 89 c7             	mov    %rax,%rdi
  80179e:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	callq  *%rax
  8017aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017ae:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017ba:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017bd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017cc:	45 89 c1             	mov    %r8d,%r9d
  8017cf:	41 89 f8             	mov    %edi,%r8d
  8017d2:	48 89 c7             	mov    %rax,%rdi
  8017d5:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8017dc:	00 00 00 
  8017df:	ff d0                	callq  *%rax
			break;
  8017e1:	eb 3f                	jmp    801822 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017eb:	48 89 d6             	mov    %rdx,%rsi
  8017ee:	89 df                	mov    %ebx,%edi
  8017f0:	ff d0                	callq  *%rax
			break;
  8017f2:	eb 2e                	jmp    801822 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017fc:	48 89 d6             	mov    %rdx,%rsi
  8017ff:	bf 25 00 00 00       	mov    $0x25,%edi
  801804:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801806:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80180b:	eb 05                	jmp    801812 <vprintfmt+0x4f9>
  80180d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801812:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801816:	48 83 e8 01          	sub    $0x1,%rax
  80181a:	0f b6 00             	movzbl (%rax),%eax
  80181d:	3c 25                	cmp    $0x25,%al
  80181f:	75 ec                	jne    80180d <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801821:	90                   	nop
		}
	}
  801822:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801823:	e9 43 fb ff ff       	jmpq   80136b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801828:	48 83 c4 60          	add    $0x60,%rsp
  80182c:	5b                   	pop    %rbx
  80182d:	41 5c                	pop    %r12
  80182f:	5d                   	pop    %rbp
  801830:	c3                   	retq   

0000000000801831 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80183c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801843:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80184a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801851:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801858:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80185f:	84 c0                	test   %al,%al
  801861:	74 20                	je     801883 <printfmt+0x52>
  801863:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801867:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80186b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80186f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801873:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801877:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80187b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80187f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801883:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80188a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801891:	00 00 00 
  801894:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80189b:	00 00 00 
  80189e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018a2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8018a9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018b0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018b7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018be:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018c5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018cc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018d3:	48 89 c7             	mov    %rax,%rdi
  8018d6:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  8018dd:	00 00 00 
  8018e0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018e2:	c9                   	leaveq 
  8018e3:	c3                   	retq   

00000000008018e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018e4:	55                   	push   %rbp
  8018e5:	48 89 e5             	mov    %rsp,%rbp
  8018e8:	48 83 ec 10          	sub    $0x10,%rsp
  8018ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f7:	8b 40 10             	mov    0x10(%rax),%eax
  8018fa:	8d 50 01             	lea    0x1(%rax),%edx
  8018fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801901:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801904:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801908:	48 8b 10             	mov    (%rax),%rdx
  80190b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801913:	48 39 c2             	cmp    %rax,%rdx
  801916:	73 17                	jae    80192f <sprintputch+0x4b>
		*b->buf++ = ch;
  801918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191c:	48 8b 00             	mov    (%rax),%rax
  80191f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801927:	48 89 0a             	mov    %rcx,(%rdx)
  80192a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80192d:	88 10                	mov    %dl,(%rax)
}
  80192f:	c9                   	leaveq 
  801930:	c3                   	retq   

0000000000801931 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801931:	55                   	push   %rbp
  801932:	48 89 e5             	mov    %rsp,%rbp
  801935:	48 83 ec 50          	sub    $0x50,%rsp
  801939:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80193d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801940:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801944:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801948:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80194c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801950:	48 8b 0a             	mov    (%rdx),%rcx
  801953:	48 89 08             	mov    %rcx,(%rax)
  801956:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80195a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80195e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801962:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801966:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80196a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80196e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801971:	48 98                	cltq   
  801973:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801977:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80197b:	48 01 d0             	add    %rdx,%rax
  80197e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801982:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801989:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80198e:	74 06                	je     801996 <vsnprintf+0x65>
  801990:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801994:	7f 07                	jg     80199d <vsnprintf+0x6c>
		return -E_INVAL;
  801996:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199b:	eb 2f                	jmp    8019cc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80199d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8019a1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8019a5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8019a9:	48 89 c6             	mov    %rax,%rsi
  8019ac:	48 bf e4 18 80 00 00 	movabs $0x8018e4,%rdi
  8019b3:	00 00 00 
  8019b6:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019c9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019e0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019e6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019ed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019f4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 20                	je     801a1f <snprintf+0x51>
  8019ff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801a03:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a07:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a0b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a0f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a13:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a17:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a1b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a1f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a26:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a2d:	00 00 00 
  801a30:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a37:	00 00 00 
  801a3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a3e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a45:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a4c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a53:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a5a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a61:	48 8b 0a             	mov    (%rdx),%rcx
  801a64:	48 89 08             	mov    %rcx,(%rax)
  801a67:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a6b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a6f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a73:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a77:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a7e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a85:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a8b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a92:	48 89 c7             	mov    %rax,%rdi
  801a95:	48 b8 31 19 80 00 00 	movabs $0x801931,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801aa7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801aad:	c9                   	leaveq 
  801aae:	c3                   	retq   

0000000000801aaf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801aaf:	55                   	push   %rbp
  801ab0:	48 89 e5             	mov    %rsp,%rbp
  801ab3:	48 83 ec 18          	sub    $0x18,%rsp
  801ab7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801abb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ac2:	eb 09                	jmp    801acd <strlen+0x1e>
		n++;
  801ac4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ac8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad1:	0f b6 00             	movzbl (%rax),%eax
  801ad4:	84 c0                	test   %al,%al
  801ad6:	75 ec                	jne    801ac4 <strlen+0x15>
		n++;
	return n;
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801adb:	c9                   	leaveq 
  801adc:	c3                   	retq   

0000000000801add <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801add:	55                   	push   %rbp
  801ade:	48 89 e5             	mov    %rsp,%rbp
  801ae1:	48 83 ec 20          	sub    $0x20,%rsp
  801ae5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ae9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801af4:	eb 0e                	jmp    801b04 <strnlen+0x27>
		n++;
  801af6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801afa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801aff:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801b04:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b09:	74 0b                	je     801b16 <strnlen+0x39>
  801b0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b0f:	0f b6 00             	movzbl (%rax),%eax
  801b12:	84 c0                	test   %al,%al
  801b14:	75 e0                	jne    801af6 <strnlen+0x19>
		n++;
	return n;
  801b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 20          	sub    $0x20,%rsp
  801b23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b33:	90                   	nop
  801b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b3c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b40:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b44:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b48:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b4c:	0f b6 12             	movzbl (%rdx),%edx
  801b4f:	88 10                	mov    %dl,(%rax)
  801b51:	0f b6 00             	movzbl (%rax),%eax
  801b54:	84 c0                	test   %al,%al
  801b56:	75 dc                	jne    801b34 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 20          	sub    $0x20,%rsp
  801b66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b72:	48 89 c7             	mov    %rax,%rdi
  801b75:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  801b7c:	00 00 00 
  801b7f:	ff d0                	callq  *%rax
  801b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b87:	48 63 d0             	movslq %eax,%rdx
  801b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b8e:	48 01 c2             	add    %rax,%rdx
  801b91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b95:	48 89 c6             	mov    %rax,%rsi
  801b98:	48 89 d7             	mov    %rdx,%rdi
  801b9b:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
	return dst;
  801ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 28          	sub    $0x28,%rsp
  801bb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bbd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bc9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801bd0:	00 
  801bd1:	eb 2a                	jmp    801bfd <strncpy+0x50>
		*dst++ = *src;
  801bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bdb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bdf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801be3:	0f b6 12             	movzbl (%rdx),%edx
  801be6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bec:	0f b6 00             	movzbl (%rax),%eax
  801bef:	84 c0                	test   %al,%al
  801bf1:	74 05                	je     801bf8 <strncpy+0x4b>
			src++;
  801bf3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bf8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c01:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c05:	72 cc                	jb     801bd3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c0b:	c9                   	leaveq 
  801c0c:	c3                   	retq   

0000000000801c0d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	48 83 ec 28          	sub    $0x28,%rsp
  801c15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c1d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c29:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c2e:	74 3d                	je     801c6d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c30:	eb 1d                	jmp    801c4f <strlcpy+0x42>
			*dst++ = *src++;
  801c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c36:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c3a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c3e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c42:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c46:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c4a:	0f b6 12             	movzbl (%rdx),%edx
  801c4d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c4f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c54:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c59:	74 0b                	je     801c66 <strlcpy+0x59>
  801c5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c5f:	0f b6 00             	movzbl (%rax),%eax
  801c62:	84 c0                	test   %al,%al
  801c64:	75 cc                	jne    801c32 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c6a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c75:	48 29 c2             	sub    %rax,%rdx
  801c78:	48 89 d0             	mov    %rdx,%rax
}
  801c7b:	c9                   	leaveq 
  801c7c:	c3                   	retq   

0000000000801c7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c7d:	55                   	push   %rbp
  801c7e:	48 89 e5             	mov    %rsp,%rbp
  801c81:	48 83 ec 10          	sub    $0x10,%rsp
  801c85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c8d:	eb 0a                	jmp    801c99 <strcmp+0x1c>
		p++, q++;
  801c8f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c94:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9d:	0f b6 00             	movzbl (%rax),%eax
  801ca0:	84 c0                	test   %al,%al
  801ca2:	74 12                	je     801cb6 <strcmp+0x39>
  801ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca8:	0f b6 10             	movzbl (%rax),%edx
  801cab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801caf:	0f b6 00             	movzbl (%rax),%eax
  801cb2:	38 c2                	cmp    %al,%dl
  801cb4:	74 d9                	je     801c8f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cba:	0f b6 00             	movzbl (%rax),%eax
  801cbd:	0f b6 d0             	movzbl %al,%edx
  801cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc4:	0f b6 00             	movzbl (%rax),%eax
  801cc7:	0f b6 c0             	movzbl %al,%eax
  801cca:	29 c2                	sub    %eax,%edx
  801ccc:	89 d0                	mov    %edx,%eax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 18          	sub    $0x18,%rsp
  801cd8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ce4:	eb 0f                	jmp    801cf5 <strncmp+0x25>
		n--, p++, q++;
  801ce6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ceb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801cf0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801cf5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cfa:	74 1d                	je     801d19 <strncmp+0x49>
  801cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d00:	0f b6 00             	movzbl (%rax),%eax
  801d03:	84 c0                	test   %al,%al
  801d05:	74 12                	je     801d19 <strncmp+0x49>
  801d07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0b:	0f b6 10             	movzbl (%rax),%edx
  801d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d12:	0f b6 00             	movzbl (%rax),%eax
  801d15:	38 c2                	cmp    %al,%dl
  801d17:	74 cd                	je     801ce6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d19:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d1e:	75 07                	jne    801d27 <strncmp+0x57>
		return 0;
  801d20:	b8 00 00 00 00       	mov    $0x0,%eax
  801d25:	eb 18                	jmp    801d3f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2b:	0f b6 00             	movzbl (%rax),%eax
  801d2e:	0f b6 d0             	movzbl %al,%edx
  801d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d35:	0f b6 00             	movzbl (%rax),%eax
  801d38:	0f b6 c0             	movzbl %al,%eax
  801d3b:	29 c2                	sub    %eax,%edx
  801d3d:	89 d0                	mov    %edx,%eax
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 0c          	sub    $0xc,%rsp
  801d49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d4d:	89 f0                	mov    %esi,%eax
  801d4f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d52:	eb 17                	jmp    801d6b <strchr+0x2a>
		if (*s == c)
  801d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d58:	0f b6 00             	movzbl (%rax),%eax
  801d5b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d5e:	75 06                	jne    801d66 <strchr+0x25>
			return (char *) s;
  801d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d64:	eb 15                	jmp    801d7b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d66:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6f:	0f b6 00             	movzbl (%rax),%eax
  801d72:	84 c0                	test   %al,%al
  801d74:	75 de                	jne    801d54 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7b:	c9                   	leaveq 
  801d7c:	c3                   	retq   

0000000000801d7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
  801d81:	48 83 ec 0c          	sub    $0xc,%rsp
  801d85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d89:	89 f0                	mov    %esi,%eax
  801d8b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d8e:	eb 13                	jmp    801da3 <strfind+0x26>
		if (*s == c)
  801d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d94:	0f b6 00             	movzbl (%rax),%eax
  801d97:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d9a:	75 02                	jne    801d9e <strfind+0x21>
			break;
  801d9c:	eb 10                	jmp    801dae <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d9e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da7:	0f b6 00             	movzbl (%rax),%eax
  801daa:	84 c0                	test   %al,%al
  801dac:	75 e2                	jne    801d90 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801dae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801db2:	c9                   	leaveq 
  801db3:	c3                   	retq   

0000000000801db4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801db4:	55                   	push   %rbp
  801db5:	48 89 e5             	mov    %rsp,%rbp
  801db8:	48 83 ec 18          	sub    $0x18,%rsp
  801dbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dc0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801dc3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dc7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dcc:	75 06                	jne    801dd4 <memset+0x20>
		return v;
  801dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd2:	eb 69                	jmp    801e3d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd8:	83 e0 03             	and    $0x3,%eax
  801ddb:	48 85 c0             	test   %rax,%rax
  801dde:	75 48                	jne    801e28 <memset+0x74>
  801de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de4:	83 e0 03             	and    $0x3,%eax
  801de7:	48 85 c0             	test   %rax,%rax
  801dea:	75 3c                	jne    801e28 <memset+0x74>
		c &= 0xFF;
  801dec:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801df3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df6:	c1 e0 18             	shl    $0x18,%eax
  801df9:	89 c2                	mov    %eax,%edx
  801dfb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dfe:	c1 e0 10             	shl    $0x10,%eax
  801e01:	09 c2                	or     %eax,%edx
  801e03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e06:	c1 e0 08             	shl    $0x8,%eax
  801e09:	09 d0                	or     %edx,%eax
  801e0b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801e0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e12:	48 c1 e8 02          	shr    $0x2,%rax
  801e16:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e20:	48 89 d7             	mov    %rdx,%rdi
  801e23:	fc                   	cld    
  801e24:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e26:	eb 11                	jmp    801e39 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e28:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e2c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e2f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e33:	48 89 d7             	mov    %rdx,%rdi
  801e36:	fc                   	cld    
  801e37:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 28          	sub    $0x28,%rsp
  801e47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e67:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e6b:	0f 83 88 00 00 00    	jae    801ef9 <memmove+0xba>
  801e71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e79:	48 01 d0             	add    %rdx,%rax
  801e7c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e80:	76 77                	jbe    801ef9 <memmove+0xba>
		s += n;
  801e82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e86:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e96:	83 e0 03             	and    $0x3,%eax
  801e99:	48 85 c0             	test   %rax,%rax
  801e9c:	75 3b                	jne    801ed9 <memmove+0x9a>
  801e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea2:	83 e0 03             	and    $0x3,%eax
  801ea5:	48 85 c0             	test   %rax,%rax
  801ea8:	75 2f                	jne    801ed9 <memmove+0x9a>
  801eaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eae:	83 e0 03             	and    $0x3,%eax
  801eb1:	48 85 c0             	test   %rax,%rax
  801eb4:	75 23                	jne    801ed9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eba:	48 83 e8 04          	sub    $0x4,%rax
  801ebe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ec2:	48 83 ea 04          	sub    $0x4,%rdx
  801ec6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801eca:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ece:	48 89 c7             	mov    %rax,%rdi
  801ed1:	48 89 d6             	mov    %rdx,%rsi
  801ed4:	fd                   	std    
  801ed5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ed7:	eb 1d                	jmp    801ef6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ee1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eed:	48 89 d7             	mov    %rdx,%rdi
  801ef0:	48 89 c1             	mov    %rax,%rcx
  801ef3:	fd                   	std    
  801ef4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ef6:	fc                   	cld    
  801ef7:	eb 57                	jmp    801f50 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ef9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efd:	83 e0 03             	and    $0x3,%eax
  801f00:	48 85 c0             	test   %rax,%rax
  801f03:	75 36                	jne    801f3b <memmove+0xfc>
  801f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f09:	83 e0 03             	and    $0x3,%eax
  801f0c:	48 85 c0             	test   %rax,%rax
  801f0f:	75 2a                	jne    801f3b <memmove+0xfc>
  801f11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f15:	83 e0 03             	and    $0x3,%eax
  801f18:	48 85 c0             	test   %rax,%rax
  801f1b:	75 1e                	jne    801f3b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f21:	48 c1 e8 02          	shr    $0x2,%rax
  801f25:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f30:	48 89 c7             	mov    %rax,%rdi
  801f33:	48 89 d6             	mov    %rdx,%rsi
  801f36:	fc                   	cld    
  801f37:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f39:	eb 15                	jmp    801f50 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f43:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f47:	48 89 c7             	mov    %rax,%rdi
  801f4a:	48 89 d6             	mov    %rdx,%rsi
  801f4d:	fc                   	cld    
  801f4e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f54:	c9                   	leaveq 
  801f55:	c3                   	retq   

0000000000801f56 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f56:	55                   	push   %rbp
  801f57:	48 89 e5             	mov    %rsp,%rbp
  801f5a:	48 83 ec 18          	sub    $0x18,%rsp
  801f5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f6e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f76:	48 89 ce             	mov    %rcx,%rsi
  801f79:	48 89 c7             	mov    %rax,%rdi
  801f7c:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  801f83:	00 00 00 
  801f86:	ff d0                	callq  *%rax
}
  801f88:	c9                   	leaveq 
  801f89:	c3                   	retq   

0000000000801f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f8a:	55                   	push   %rbp
  801f8b:	48 89 e5             	mov    %rsp,%rbp
  801f8e:	48 83 ec 28          	sub    $0x28,%rsp
  801f92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f9a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801fa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801faa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fae:	eb 36                	jmp    801fe6 <memcmp+0x5c>
		if (*s1 != *s2)
  801fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb4:	0f b6 10             	movzbl (%rax),%edx
  801fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbb:	0f b6 00             	movzbl (%rax),%eax
  801fbe:	38 c2                	cmp    %al,%dl
  801fc0:	74 1a                	je     801fdc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc6:	0f b6 00             	movzbl (%rax),%eax
  801fc9:	0f b6 d0             	movzbl %al,%edx
  801fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd0:	0f b6 00             	movzbl (%rax),%eax
  801fd3:	0f b6 c0             	movzbl %al,%eax
  801fd6:	29 c2                	sub    %eax,%edx
  801fd8:	89 d0                	mov    %edx,%eax
  801fda:	eb 20                	jmp    801ffc <memcmp+0x72>
		s1++, s2++;
  801fdc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801fe1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fe6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fea:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801fee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ff2:	48 85 c0             	test   %rax,%rax
  801ff5:	75 b9                	jne    801fb0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffc:	c9                   	leaveq 
  801ffd:	c3                   	retq   

0000000000801ffe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ffe:	55                   	push   %rbp
  801fff:	48 89 e5             	mov    %rsp,%rbp
  802002:	48 83 ec 28          	sub    $0x28,%rsp
  802006:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80200a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80200d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802015:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802019:	48 01 d0             	add    %rdx,%rax
  80201c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802020:	eb 15                	jmp    802037 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802026:	0f b6 10             	movzbl (%rax),%edx
  802029:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80202c:	38 c2                	cmp    %al,%dl
  80202e:	75 02                	jne    802032 <memfind+0x34>
			break;
  802030:	eb 0f                	jmp    802041 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802032:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80203f:	72 e1                	jb     802022 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802045:	c9                   	leaveq 
  802046:	c3                   	retq   

0000000000802047 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802047:	55                   	push   %rbp
  802048:	48 89 e5             	mov    %rsp,%rbp
  80204b:	48 83 ec 34          	sub    $0x34,%rsp
  80204f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802053:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802057:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80205a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802061:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802068:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802069:	eb 05                	jmp    802070 <strtol+0x29>
		s++;
  80206b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802070:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802074:	0f b6 00             	movzbl (%rax),%eax
  802077:	3c 20                	cmp    $0x20,%al
  802079:	74 f0                	je     80206b <strtol+0x24>
  80207b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207f:	0f b6 00             	movzbl (%rax),%eax
  802082:	3c 09                	cmp    $0x9,%al
  802084:	74 e5                	je     80206b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802086:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208a:	0f b6 00             	movzbl (%rax),%eax
  80208d:	3c 2b                	cmp    $0x2b,%al
  80208f:	75 07                	jne    802098 <strtol+0x51>
		s++;
  802091:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802096:	eb 17                	jmp    8020af <strtol+0x68>
	else if (*s == '-')
  802098:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209c:	0f b6 00             	movzbl (%rax),%eax
  80209f:	3c 2d                	cmp    $0x2d,%al
  8020a1:	75 0c                	jne    8020af <strtol+0x68>
		s++, neg = 1;
  8020a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020af:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020b3:	74 06                	je     8020bb <strtol+0x74>
  8020b5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020b9:	75 28                	jne    8020e3 <strtol+0x9c>
  8020bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bf:	0f b6 00             	movzbl (%rax),%eax
  8020c2:	3c 30                	cmp    $0x30,%al
  8020c4:	75 1d                	jne    8020e3 <strtol+0x9c>
  8020c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ca:	48 83 c0 01          	add    $0x1,%rax
  8020ce:	0f b6 00             	movzbl (%rax),%eax
  8020d1:	3c 78                	cmp    $0x78,%al
  8020d3:	75 0e                	jne    8020e3 <strtol+0x9c>
		s += 2, base = 16;
  8020d5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020da:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020e1:	eb 2c                	jmp    80210f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020e7:	75 19                	jne    802102 <strtol+0xbb>
  8020e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ed:	0f b6 00             	movzbl (%rax),%eax
  8020f0:	3c 30                	cmp    $0x30,%al
  8020f2:	75 0e                	jne    802102 <strtol+0xbb>
		s++, base = 8;
  8020f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020f9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802100:	eb 0d                	jmp    80210f <strtol+0xc8>
	else if (base == 0)
  802102:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802106:	75 07                	jne    80210f <strtol+0xc8>
		base = 10;
  802108:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80210f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802113:	0f b6 00             	movzbl (%rax),%eax
  802116:	3c 2f                	cmp    $0x2f,%al
  802118:	7e 1d                	jle    802137 <strtol+0xf0>
  80211a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211e:	0f b6 00             	movzbl (%rax),%eax
  802121:	3c 39                	cmp    $0x39,%al
  802123:	7f 12                	jg     802137 <strtol+0xf0>
			dig = *s - '0';
  802125:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802129:	0f b6 00             	movzbl (%rax),%eax
  80212c:	0f be c0             	movsbl %al,%eax
  80212f:	83 e8 30             	sub    $0x30,%eax
  802132:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802135:	eb 4e                	jmp    802185 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802137:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213b:	0f b6 00             	movzbl (%rax),%eax
  80213e:	3c 60                	cmp    $0x60,%al
  802140:	7e 1d                	jle    80215f <strtol+0x118>
  802142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802146:	0f b6 00             	movzbl (%rax),%eax
  802149:	3c 7a                	cmp    $0x7a,%al
  80214b:	7f 12                	jg     80215f <strtol+0x118>
			dig = *s - 'a' + 10;
  80214d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802151:	0f b6 00             	movzbl (%rax),%eax
  802154:	0f be c0             	movsbl %al,%eax
  802157:	83 e8 57             	sub    $0x57,%eax
  80215a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80215d:	eb 26                	jmp    802185 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80215f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802163:	0f b6 00             	movzbl (%rax),%eax
  802166:	3c 40                	cmp    $0x40,%al
  802168:	7e 48                	jle    8021b2 <strtol+0x16b>
  80216a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216e:	0f b6 00             	movzbl (%rax),%eax
  802171:	3c 5a                	cmp    $0x5a,%al
  802173:	7f 3d                	jg     8021b2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802179:	0f b6 00             	movzbl (%rax),%eax
  80217c:	0f be c0             	movsbl %al,%eax
  80217f:	83 e8 37             	sub    $0x37,%eax
  802182:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802185:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802188:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80218b:	7c 02                	jl     80218f <strtol+0x148>
			break;
  80218d:	eb 23                	jmp    8021b2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80218f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802194:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802197:	48 98                	cltq   
  802199:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80219e:	48 89 c2             	mov    %rax,%rdx
  8021a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021a4:	48 98                	cltq   
  8021a6:	48 01 d0             	add    %rdx,%rax
  8021a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021ad:	e9 5d ff ff ff       	jmpq   80210f <strtol+0xc8>

	if (endptr)
  8021b2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021b7:	74 0b                	je     8021c4 <strtol+0x17d>
		*endptr = (char *) s;
  8021b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021c1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c8:	74 09                	je     8021d3 <strtol+0x18c>
  8021ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ce:	48 f7 d8             	neg    %rax
  8021d1:	eb 04                	jmp    8021d7 <strtol+0x190>
  8021d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021d7:	c9                   	leaveq 
  8021d8:	c3                   	retq   

00000000008021d9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8021d9:	55                   	push   %rbp
  8021da:	48 89 e5             	mov    %rsp,%rbp
  8021dd:	48 83 ec 30          	sub    $0x30,%rsp
  8021e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8021e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021f1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021f5:	0f b6 00             	movzbl (%rax),%eax
  8021f8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8021fb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021ff:	75 06                	jne    802207 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802205:	eb 6b                	jmp    802272 <strstr+0x99>

	len = strlen(str);
  802207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80220b:	48 89 c7             	mov    %rax,%rdi
  80220e:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
  80221a:	48 98                	cltq   
  80221c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802224:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802228:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80222c:	0f b6 00             	movzbl (%rax),%eax
  80222f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802232:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802236:	75 07                	jne    80223f <strstr+0x66>
				return (char *) 0;
  802238:	b8 00 00 00 00       	mov    $0x0,%eax
  80223d:	eb 33                	jmp    802272 <strstr+0x99>
		} while (sc != c);
  80223f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802243:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802246:	75 d8                	jne    802220 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802248:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802254:	48 89 ce             	mov    %rcx,%rsi
  802257:	48 89 c7             	mov    %rax,%rdi
  80225a:	48 b8 d0 1c 80 00 00 	movabs $0x801cd0,%rax
  802261:	00 00 00 
  802264:	ff d0                	callq  *%rax
  802266:	85 c0                	test   %eax,%eax
  802268:	75 b6                	jne    802220 <strstr+0x47>

	return (char *) (in - 1);
  80226a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226e:	48 83 e8 01          	sub    $0x1,%rax
}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	53                   	push   %rbx
  802279:	48 83 ec 48          	sub    $0x48,%rsp
  80227d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802280:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802283:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802287:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80228b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80228f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  802293:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802296:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80229a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80229e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8022a2:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8022a6:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8022aa:	4c 89 c3             	mov    %r8,%rbx
  8022ad:	cd 30                	int    $0x30
  8022af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8022b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022b7:	74 3e                	je     8022f7 <syscall+0x83>
  8022b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022be:	7e 37                	jle    8022f7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c7:	49 89 d0             	mov    %rdx,%r8
  8022ca:	89 c1                	mov    %eax,%ecx
  8022cc:	48 ba 48 4a 80 00 00 	movabs $0x804a48,%rdx
  8022d3:	00 00 00 
  8022d6:	be 4a 00 00 00       	mov    $0x4a,%esi
  8022db:	48 bf 65 4a 80 00 00 	movabs $0x804a65,%rdi
  8022e2:	00 00 00 
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ea:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  8022f1:	00 00 00 
  8022f4:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8022f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022fb:	48 83 c4 48          	add    $0x48,%rsp
  8022ff:	5b                   	pop    %rbx
  802300:	5d                   	pop    %rbp
  802301:	c3                   	retq   

0000000000802302 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802302:	55                   	push   %rbp
  802303:	48 89 e5             	mov    %rsp,%rbp
  802306:	48 83 ec 20          	sub    $0x20,%rsp
  80230a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80230e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802316:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80231a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802321:	00 
  802322:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802328:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80232e:	48 89 d1             	mov    %rdx,%rcx
  802331:	48 89 c2             	mov    %rax,%rdx
  802334:	be 00 00 00 00       	mov    $0x0,%esi
  802339:	bf 00 00 00 00       	mov    $0x0,%edi
  80233e:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
}
  80234a:	c9                   	leaveq 
  80234b:	c3                   	retq   

000000000080234c <sys_cgetc>:

int
sys_cgetc(void)
{
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
  802350:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802354:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80235b:	00 
  80235c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802362:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802368:	b9 00 00 00 00       	mov    $0x0,%ecx
  80236d:	ba 00 00 00 00       	mov    $0x0,%edx
  802372:	be 00 00 00 00       	mov    $0x0,%esi
  802377:	bf 01 00 00 00       	mov    $0x1,%edi
  80237c:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
}
  802388:	c9                   	leaveq 
  802389:	c3                   	retq   

000000000080238a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80238a:	55                   	push   %rbp
  80238b:	48 89 e5             	mov    %rsp,%rbp
  80238e:	48 83 ec 10          	sub    $0x10,%rsp
  802392:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802398:	48 98                	cltq   
  80239a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023a1:	00 
  8023a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023b3:	48 89 c2             	mov    %rax,%rdx
  8023b6:	be 01 00 00 00       	mov    $0x1,%esi
  8023bb:	bf 03 00 00 00       	mov    $0x3,%edi
  8023c0:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8023c7:	00 00 00 
  8023ca:	ff d0                	callq  *%rax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023dd:	00 
  8023de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f4:	be 00 00 00 00       	mov    $0x0,%esi
  8023f9:	bf 02 00 00 00       	mov    $0x2,%edi
  8023fe:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802405:	00 00 00 
  802408:	ff d0                	callq  *%rax
}
  80240a:	c9                   	leaveq 
  80240b:	c3                   	retq   

000000000080240c <sys_yield>:

void
sys_yield(void)
{
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
  802410:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802414:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80241b:	00 
  80241c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802422:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802428:	b9 00 00 00 00       	mov    $0x0,%ecx
  80242d:	ba 00 00 00 00       	mov    $0x0,%edx
  802432:	be 00 00 00 00       	mov    $0x0,%esi
  802437:	bf 0b 00 00 00       	mov    $0xb,%edi
  80243c:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax
}
  802448:	c9                   	leaveq 
  802449:	c3                   	retq   

000000000080244a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80244a:	55                   	push   %rbp
  80244b:	48 89 e5             	mov    %rsp,%rbp
  80244e:	48 83 ec 20          	sub    $0x20,%rsp
  802452:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802455:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802459:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80245c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245f:	48 63 c8             	movslq %eax,%rcx
  802462:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802466:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802469:	48 98                	cltq   
  80246b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802472:	00 
  802473:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802479:	49 89 c8             	mov    %rcx,%r8
  80247c:	48 89 d1             	mov    %rdx,%rcx
  80247f:	48 89 c2             	mov    %rax,%rdx
  802482:	be 01 00 00 00       	mov    $0x1,%esi
  802487:	bf 04 00 00 00       	mov    $0x4,%edi
  80248c:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802493:	00 00 00 
  802496:	ff d0                	callq  *%rax
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	48 83 ec 30          	sub    $0x30,%rsp
  8024a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024ac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024b0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024b7:	48 63 c8             	movslq %eax,%rcx
  8024ba:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c1:	48 63 f0             	movslq %eax,%rsi
  8024c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cb:	48 98                	cltq   
  8024cd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024d1:	49 89 f9             	mov    %rdi,%r9
  8024d4:	49 89 f0             	mov    %rsi,%r8
  8024d7:	48 89 d1             	mov    %rdx,%rcx
  8024da:	48 89 c2             	mov    %rax,%rdx
  8024dd:	be 01 00 00 00       	mov    $0x1,%esi
  8024e2:	bf 05 00 00 00       	mov    $0x5,%edi
  8024e7:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	callq  *%rax
}
  8024f3:	c9                   	leaveq 
  8024f4:	c3                   	retq   

00000000008024f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024f5:	55                   	push   %rbp
  8024f6:	48 89 e5             	mov    %rsp,%rbp
  8024f9:	48 83 ec 20          	sub    $0x20,%rsp
  8024fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802500:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802504:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802508:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250b:	48 98                	cltq   
  80250d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802514:	00 
  802515:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80251b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802521:	48 89 d1             	mov    %rdx,%rcx
  802524:	48 89 c2             	mov    %rax,%rdx
  802527:	be 01 00 00 00       	mov    $0x1,%esi
  80252c:	bf 06 00 00 00       	mov    $0x6,%edi
  802531:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 10          	sub    $0x10,%rsp
  802547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80254a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80254d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802550:	48 63 d0             	movslq %eax,%rdx
  802553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802556:	48 98                	cltq   
  802558:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80255f:	00 
  802560:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802566:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80256c:	48 89 d1             	mov    %rdx,%rcx
  80256f:	48 89 c2             	mov    %rax,%rdx
  802572:	be 01 00 00 00       	mov    $0x1,%esi
  802577:	bf 08 00 00 00       	mov    $0x8,%edi
  80257c:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax
}
  802588:	c9                   	leaveq 
  802589:	c3                   	retq   

000000000080258a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	48 83 ec 20          	sub    $0x20,%rsp
  802592:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802595:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802599:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80259d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a0:	48 98                	cltq   
  8025a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025a9:	00 
  8025aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025b6:	48 89 d1             	mov    %rdx,%rcx
  8025b9:	48 89 c2             	mov    %rax,%rdx
  8025bc:	be 01 00 00 00       	mov    $0x1,%esi
  8025c1:	bf 09 00 00 00       	mov    $0x9,%edi
  8025c6:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
}
  8025d2:	c9                   	leaveq 
  8025d3:	c3                   	retq   

00000000008025d4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025d4:	55                   	push   %rbp
  8025d5:	48 89 e5             	mov    %rsp,%rbp
  8025d8:	48 83 ec 20          	sub    $0x20,%rsp
  8025dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ea:	48 98                	cltq   
  8025ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025f3:	00 
  8025f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802600:	48 89 d1             	mov    %rdx,%rcx
  802603:	48 89 c2             	mov    %rax,%rdx
  802606:	be 01 00 00 00       	mov    $0x1,%esi
  80260b:	bf 0a 00 00 00       	mov    $0xa,%edi
  802610:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
}
  80261c:	c9                   	leaveq 
  80261d:	c3                   	retq   

000000000080261e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 20          	sub    $0x20,%rsp
  802626:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802629:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80262d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802631:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802634:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802637:	48 63 f0             	movslq %eax,%rsi
  80263a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80263e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802641:	48 98                	cltq   
  802643:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802647:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80264e:	00 
  80264f:	49 89 f1             	mov    %rsi,%r9
  802652:	49 89 c8             	mov    %rcx,%r8
  802655:	48 89 d1             	mov    %rdx,%rcx
  802658:	48 89 c2             	mov    %rax,%rdx
  80265b:	be 00 00 00 00       	mov    $0x0,%esi
  802660:	bf 0c 00 00 00       	mov    $0xc,%edi
  802665:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
}
  802671:	c9                   	leaveq 
  802672:	c3                   	retq   

0000000000802673 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802673:	55                   	push   %rbp
  802674:	48 89 e5             	mov    %rsp,%rbp
  802677:	48 83 ec 10          	sub    $0x10,%rsp
  80267b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80267f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802683:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80268a:	00 
  80268b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802691:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80269c:	48 89 c2             	mov    %rax,%rdx
  80269f:	be 01 00 00 00       	mov    $0x1,%esi
  8026a4:	bf 0d 00 00 00       	mov    $0xd,%edi
  8026a9:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
}
  8026b5:	c9                   	leaveq 
  8026b6:	c3                   	retq   

00000000008026b7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026b7:	55                   	push   %rbp
  8026b8:	48 89 e5             	mov    %rsp,%rbp
  8026bb:	48 83 ec 30          	sub    $0x30,%rsp
  8026bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8026cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026d0:	74 18                	je     8026ea <ipc_recv+0x33>
  8026d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d6:	48 89 c7             	mov    %rax,%rdi
  8026d9:	48 b8 73 26 80 00 00 	movabs $0x802673,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e8:	eb 19                	jmp    802703 <ipc_recv+0x4c>
  8026ea:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8026f1:	00 00 00 
  8026f4:	48 b8 73 26 80 00 00 	movabs $0x802673,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
  802700:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  802703:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802708:	74 26                	je     802730 <ipc_recv+0x79>
  80270a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270e:	75 15                	jne    802725 <ipc_recv+0x6e>
  802710:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802717:	00 00 00 
  80271a:	48 8b 00             	mov    (%rax),%rax
  80271d:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  802723:	eb 05                	jmp    80272a <ipc_recv+0x73>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80272e:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  802730:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802735:	74 26                	je     80275d <ipc_recv+0xa6>
  802737:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273b:	75 15                	jne    802752 <ipc_recv+0x9b>
  80273d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802744:	00 00 00 
  802747:	48 8b 00             	mov    (%rax),%rax
  80274a:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  802750:	eb 05                	jmp    802757 <ipc_recv+0xa0>
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
  802757:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80275b:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  80275d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802761:	75 15                	jne    802778 <ipc_recv+0xc1>
  802763:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80276a:	00 00 00 
  80276d:	48 8b 00             	mov    (%rax),%rax
  802770:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  802776:	eb 03                	jmp    80277b <ipc_recv+0xc4>
  802778:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80277b:	c9                   	leaveq 
  80277c:	c3                   	retq   

000000000080277d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80277d:	55                   	push   %rbp
  80277e:	48 89 e5             	mov    %rsp,%rbp
  802781:	48 83 ec 30          	sub    $0x30,%rsp
  802785:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802788:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80278b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80278f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  802792:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  802799:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80279e:	75 10                	jne    8027b0 <ipc_send+0x33>
  8027a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027a7:	00 00 00 
  8027aa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8027ae:	eb 62                	jmp    802812 <ipc_send+0x95>
  8027b0:	eb 60                	jmp    802812 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8027b2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8027b6:	74 30                	je     8027e8 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8027b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bb:	89 c1                	mov    %eax,%ecx
  8027bd:	48 ba 73 4a 80 00 00 	movabs $0x804a73,%rdx
  8027c4:	00 00 00 
  8027c7:	be 33 00 00 00       	mov    $0x33,%esi
  8027cc:	48 bf 8f 4a 80 00 00 	movabs $0x804a8f,%rdi
  8027d3:	00 00 00 
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8027e2:	00 00 00 
  8027e5:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8027e8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8027eb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8027ee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f5:	89 c7                	mov    %eax,%edi
  8027f7:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
  802803:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  802806:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  802812:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802816:	75 9a                	jne    8027b2 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 14          	sub    $0x14,%rsp
  802822:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802825:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80282c:	eb 5e                	jmp    80288c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80282e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802835:	00 00 00 
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283b:	48 63 d0             	movslq %eax,%rdx
  80283e:	48 89 d0             	mov    %rdx,%rax
  802841:	48 c1 e0 03          	shl    $0x3,%rax
  802845:	48 01 d0             	add    %rdx,%rax
  802848:	48 c1 e0 05          	shl    $0x5,%rax
  80284c:	48 01 c8             	add    %rcx,%rax
  80284f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802855:	8b 00                	mov    (%rax),%eax
  802857:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80285a:	75 2c                	jne    802888 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80285c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802863:	00 00 00 
  802866:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802869:	48 63 d0             	movslq %eax,%rdx
  80286c:	48 89 d0             	mov    %rdx,%rax
  80286f:	48 c1 e0 03          	shl    $0x3,%rax
  802873:	48 01 d0             	add    %rdx,%rax
  802876:	48 c1 e0 05          	shl    $0x5,%rax
  80287a:	48 01 c8             	add    %rcx,%rax
  80287d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802883:	8b 40 08             	mov    0x8(%rax),%eax
  802886:	eb 12                	jmp    80289a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802888:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802893:	7e 99                	jle    80282e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289a:	c9                   	leaveq 
  80289b:	c3                   	retq   

000000000080289c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80289c:	55                   	push   %rbp
  80289d:	48 89 e5             	mov    %rsp,%rbp
  8028a0:	48 83 ec 08          	sub    $0x8,%rsp
  8028a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8028a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8028b3:	ff ff ff 
  8028b6:	48 01 d0             	add    %rdx,%rax
  8028b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8028bd:	c9                   	leaveq 
  8028be:	c3                   	retq   

00000000008028bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8028bf:	55                   	push   %rbp
  8028c0:	48 89 e5             	mov    %rsp,%rbp
  8028c3:	48 83 ec 08          	sub    $0x8,%rsp
  8028c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8028cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8028e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8028e8:	c9                   	leaveq 
  8028e9:	c3                   	retq   

00000000008028ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8028ea:	55                   	push   %rbp
  8028eb:	48 89 e5             	mov    %rsp,%rbp
  8028ee:	48 83 ec 18          	sub    $0x18,%rsp
  8028f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028fd:	eb 6b                	jmp    80296a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8028ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802902:	48 98                	cltq   
  802904:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80290a:	48 c1 e0 0c          	shl    $0xc,%rax
  80290e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802916:	48 c1 e8 15          	shr    $0x15,%rax
  80291a:	48 89 c2             	mov    %rax,%rdx
  80291d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802924:	01 00 00 
  802927:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292b:	83 e0 01             	and    $0x1,%eax
  80292e:	48 85 c0             	test   %rax,%rax
  802931:	74 21                	je     802954 <fd_alloc+0x6a>
  802933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802937:	48 c1 e8 0c          	shr    $0xc,%rax
  80293b:	48 89 c2             	mov    %rax,%rdx
  80293e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802945:	01 00 00 
  802948:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294c:	83 e0 01             	and    $0x1,%eax
  80294f:	48 85 c0             	test   %rax,%rax
  802952:	75 12                	jne    802966 <fd_alloc+0x7c>
			*fd_store = fd;
  802954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802958:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	eb 1a                	jmp    802980 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80296a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80296e:	7e 8f                	jle    8028ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802974:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80297b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802980:	c9                   	leaveq 
  802981:	c3                   	retq   

0000000000802982 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802982:	55                   	push   %rbp
  802983:	48 89 e5             	mov    %rsp,%rbp
  802986:	48 83 ec 20          	sub    $0x20,%rsp
  80298a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80298d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802991:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802995:	78 06                	js     80299d <fd_lookup+0x1b>
  802997:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80299b:	7e 07                	jle    8029a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80299d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a2:	eb 6c                	jmp    802a10 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8029a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a7:	48 98                	cltq   
  8029a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029af:	48 c1 e0 0c          	shl    $0xc,%rax
  8029b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029bb:	48 c1 e8 15          	shr    $0x15,%rax
  8029bf:	48 89 c2             	mov    %rax,%rdx
  8029c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029c9:	01 00 00 
  8029cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d0:	83 e0 01             	and    $0x1,%eax
  8029d3:	48 85 c0             	test   %rax,%rax
  8029d6:	74 21                	je     8029f9 <fd_lookup+0x77>
  8029d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8029e0:	48 89 c2             	mov    %rax,%rdx
  8029e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029ea:	01 00 00 
  8029ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f1:	83 e0 01             	and    $0x1,%eax
  8029f4:	48 85 c0             	test   %rax,%rax
  8029f7:	75 07                	jne    802a00 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029fe:	eb 10                	jmp    802a10 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802a00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a08:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 30          	sub    $0x30,%rsp
  802a1a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a1e:	89 f0                	mov    %esi,%eax
  802a20:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3a:	48 89 d6             	mov    %rdx,%rsi
  802a3d:	89 c7                	mov    %eax,%edi
  802a3f:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	78 0a                	js     802a5e <fd_close+0x4c>
	    || fd != fd2)
  802a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a58:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802a5c:	74 12                	je     802a70 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802a5e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802a62:	74 05                	je     802a69 <fd_close+0x57>
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	eb 05                	jmp    802a6e <fd_close+0x5c>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	eb 69                	jmp    802ad9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a74:	8b 00                	mov    (%rax),%eax
  802a76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7a:	48 89 d6             	mov    %rdx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a92:	78 2a                	js     802abe <fd_close+0xac>
		if (dev->dev_close)
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a9c:	48 85 c0             	test   %rax,%rax
  802a9f:	74 16                	je     802ab7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	48 8b 40 20          	mov    0x20(%rax),%rax
  802aa9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aad:	48 89 d7             	mov    %rdx,%rdi
  802ab0:	ff d0                	callq  *%rax
  802ab2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab5:	eb 07                	jmp    802abe <fd_close+0xac>
		else
			r = 0;
  802ab7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac2:	48 89 c6             	mov    %rax,%rsi
  802ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  802aca:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
	return r;
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ad9:	c9                   	leaveq 
  802ada:	c3                   	retq   

0000000000802adb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 20          	sub    $0x20,%rsp
  802ae3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802aea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af1:	eb 41                	jmp    802b34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802af3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802afa:	00 00 00 
  802afd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b00:	48 63 d2             	movslq %edx,%rdx
  802b03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b07:	8b 00                	mov    (%rax),%eax
  802b09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b0c:	75 22                	jne    802b30 <dev_lookup+0x55>
			*dev = devtab[i];
  802b0e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b15:	00 00 00 
  802b18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b1b:	48 63 d2             	movslq %edx,%rdx
  802b1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	eb 60                	jmp    802b90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802b30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b34:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802b3b:	00 00 00 
  802b3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b41:	48 63 d2             	movslq %edx,%rdx
  802b44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b48:	48 85 c0             	test   %rax,%rax
  802b4b:	75 a6                	jne    802af3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802b4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b54:	00 00 00 
  802b57:	48 8b 00             	mov    (%rax),%rax
  802b5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b63:	89 c6                	mov    %eax,%esi
  802b65:	48 bf a0 4a 80 00 00 	movabs $0x804aa0,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  802b7b:	00 00 00 
  802b7e:	ff d1                	callq  *%rcx
	*dev = 0;
  802b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <close>:

int
close(int fdnum)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 20          	sub    $0x20,%rsp
  802b9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	79 05                	jns    802bc3 <close+0x31>
		return r;
  802bbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc1:	eb 18                	jmp    802bdb <close+0x49>
	else
		return fd_close(fd, 1);
  802bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc7:	be 01 00 00 00       	mov    $0x1,%esi
  802bcc:	48 89 c7             	mov    %rax,%rdi
  802bcf:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <close_all>:

void
close_all(void)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802be5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bec:	eb 15                	jmp    802c03 <close_all+0x26>
		close(i);
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802bff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802c07:	7e e5                	jle    802bee <close_all+0x11>
		close(i);
}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 40          	sub    $0x40,%rsp
  802c13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802c16:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802c19:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802c1d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802c20:	48 89 d6             	mov    %rdx,%rsi
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c38:	79 08                	jns    802c42 <dup+0x37>
		return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	e9 70 01 00 00       	jmpq   802db2 <dup+0x1a7>
	close(newfdnum);
  802c42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c45:	89 c7                	mov    %eax,%edi
  802c47:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802c53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c56:	48 98                	cltq   
  802c58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802c5e:	48 c1 e0 0c          	shl    $0xc,%rax
  802c62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6a:	48 89 c7             	mov    %rax,%rdi
  802c6d:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c74:	00 00 00 
  802c77:	ff d0                	callq  *%rax
  802c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c81:	48 89 c7             	mov    %rax,%rdi
  802c84:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
  802c90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c98:	48 c1 e8 15          	shr    $0x15,%rax
  802c9c:	48 89 c2             	mov    %rax,%rdx
  802c9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ca6:	01 00 00 
  802ca9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cad:	83 e0 01             	and    $0x1,%eax
  802cb0:	48 85 c0             	test   %rax,%rax
  802cb3:	74 73                	je     802d28 <dup+0x11d>
  802cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb9:	48 c1 e8 0c          	shr    $0xc,%rax
  802cbd:	48 89 c2             	mov    %rax,%rdx
  802cc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc7:	01 00 00 
  802cca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cce:	83 e0 01             	and    $0x1,%eax
  802cd1:	48 85 c0             	test   %rax,%rax
  802cd4:	74 52                	je     802d28 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802cd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cda:	48 c1 e8 0c          	shr    $0xc,%rax
  802cde:	48 89 c2             	mov    %rax,%rdx
  802ce1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ce8:	01 00 00 
  802ceb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cef:	25 07 0e 00 00       	and    $0xe07,%eax
  802cf4:	89 c1                	mov    %eax,%ecx
  802cf6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cfe:	41 89 c8             	mov    %ecx,%r8d
  802d01:	48 89 d1             	mov    %rdx,%rcx
  802d04:	ba 00 00 00 00       	mov    $0x0,%edx
  802d09:	48 89 c6             	mov    %rax,%rsi
  802d0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d11:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d24:	79 02                	jns    802d28 <dup+0x11d>
			goto err;
  802d26:	eb 57                	jmp    802d7f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802d30:	48 89 c2             	mov    %rax,%rdx
  802d33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d3a:	01 00 00 
  802d3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d41:	25 07 0e 00 00       	and    $0xe07,%eax
  802d46:	89 c1                	mov    %eax,%ecx
  802d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d50:	41 89 c8             	mov    %ecx,%r8d
  802d53:	48 89 d1             	mov    %rdx,%rcx
  802d56:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5b:	48 89 c6             	mov    %rax,%rsi
  802d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802d63:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	79 02                	jns    802d7a <dup+0x16f>
		goto err;
  802d78:	eb 05                	jmp    802d7f <dup+0x174>

	return newfdnum;
  802d7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d7d:	eb 33                	jmp    802db2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d83:	48 89 c6             	mov    %rax,%rsi
  802d86:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8b:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9b:	48 89 c6             	mov    %rax,%rsi
  802d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802da3:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
	return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802db2:	c9                   	leaveq 
  802db3:	c3                   	retq   

0000000000802db4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802db4:	55                   	push   %rbp
  802db5:	48 89 e5             	mov    %rsp,%rbp
  802db8:	48 83 ec 40          	sub    $0x40,%rsp
  802dbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dc3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dc7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dcb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dce:	48 89 d6             	mov    %rdx,%rsi
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
  802ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de6:	78 24                	js     802e0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dec:	8b 00                	mov    (%rax),%eax
  802dee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802df2:	48 89 d6             	mov    %rdx,%rsi
  802df5:	89 c7                	mov    %eax,%edi
  802df7:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
  802e03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0a:	79 05                	jns    802e11 <read+0x5d>
		return r;
  802e0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0f:	eb 76                	jmp    802e87 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e15:	8b 40 08             	mov    0x8(%rax),%eax
  802e18:	83 e0 03             	and    $0x3,%eax
  802e1b:	83 f8 01             	cmp    $0x1,%eax
  802e1e:	75 3a                	jne    802e5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e20:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e27:	00 00 00 
  802e2a:	48 8b 00             	mov    (%rax),%rax
  802e2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e36:	89 c6                	mov    %eax,%esi
  802e38:	48 bf bf 4a 80 00 00 	movabs $0x804abf,%rdi
  802e3f:	00 00 00 
  802e42:	b8 00 00 00 00       	mov    $0x0,%eax
  802e47:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  802e4e:	00 00 00 
  802e51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e58:	eb 2d                	jmp    802e87 <read+0xd3>
	}
	if (!dev->dev_read)
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e62:	48 85 c0             	test   %rax,%rax
  802e65:	75 07                	jne    802e6e <read+0xba>
		return -E_NOT_SUPP;
  802e67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e6c:	eb 19                	jmp    802e87 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	48 8b 40 10          	mov    0x10(%rax),%rax
  802e76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e82:	48 89 cf             	mov    %rcx,%rdi
  802e85:	ff d0                	callq  *%rax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 30          	sub    $0x30,%rsp
  802e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e98:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ea3:	eb 49                	jmp    802eee <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	48 98                	cltq   
  802eaa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eae:	48 29 c2             	sub    %rax,%rdx
  802eb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb4:	48 63 c8             	movslq %eax,%rcx
  802eb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebb:	48 01 c1             	add    %rax,%rcx
  802ebe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec1:	48 89 ce             	mov    %rcx,%rsi
  802ec4:	89 c7                	mov    %eax,%edi
  802ec6:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
  802ed2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ed5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ed9:	79 05                	jns    802ee0 <readn+0x57>
			return m;
  802edb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ede:	eb 1c                	jmp    802efc <readn+0x73>
		if (m == 0)
  802ee0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ee4:	75 02                	jne    802ee8 <readn+0x5f>
			break;
  802ee6:	eb 11                	jmp    802ef9 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eeb:	01 45 fc             	add    %eax,-0x4(%rbp)
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef1:	48 98                	cltq   
  802ef3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ef7:	72 ac                	jb     802ea5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	48 83 ec 40          	sub    $0x40,%rsp
  802f06:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f18:	48 89 d6             	mov    %rdx,%rsi
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	78 24                	js     802f56 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f36:	8b 00                	mov    (%rax),%eax
  802f38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f3c:	48 89 d6             	mov    %rdx,%rsi
  802f3f:	89 c7                	mov    %eax,%edi
  802f41:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
  802f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f54:	79 05                	jns    802f5b <write+0x5d>
		return r;
  802f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f59:	eb 75                	jmp    802fd0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5f:	8b 40 08             	mov    0x8(%rax),%eax
  802f62:	83 e0 03             	and    $0x3,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	75 3a                	jne    802fa3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802f70:	00 00 00 
  802f73:	48 8b 00             	mov    (%rax),%rax
  802f76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f7f:	89 c6                	mov    %eax,%esi
  802f81:	48 bf db 4a 80 00 00 	movabs $0x804adb,%rdi
  802f88:	00 00 00 
  802f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f90:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  802f97:	00 00 00 
  802f9a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fa1:	eb 2d                	jmp    802fd0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fab:	48 85 c0             	test   %rax,%rax
  802fae:	75 07                	jne    802fb7 <write+0xb9>
		return -E_NOT_SUPP;
  802fb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fb5:	eb 19                	jmp    802fd0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802fbf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fc7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802fcb:	48 89 cf             	mov    %rcx,%rdi
  802fce:	ff d0                	callq  *%rax
}
  802fd0:	c9                   	leaveq 
  802fd1:	c3                   	retq   

0000000000802fd2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802fd2:	55                   	push   %rbp
  802fd3:	48 89 e5             	mov    %rsp,%rbp
  802fd6:	48 83 ec 18          	sub    $0x18,%rsp
  802fda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fdd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fe0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe7:	48 89 d6             	mov    %rdx,%rsi
  802fea:	89 c7                	mov    %eax,%edi
  802fec:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fff:	79 05                	jns    803006 <seek+0x34>
		return r;
  803001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803004:	eb 0f                	jmp    803015 <seek+0x43>
	fd->fd_offset = offset;
  803006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803015:	c9                   	leaveq 
  803016:	c3                   	retq   

0000000000803017 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803017:	55                   	push   %rbp
  803018:	48 89 e5             	mov    %rsp,%rbp
  80301b:	48 83 ec 30          	sub    $0x30,%rsp
  80301f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803022:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803025:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803029:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80302c:	48 89 d6             	mov    %rdx,%rsi
  80302f:	89 c7                	mov    %eax,%edi
  803031:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803044:	78 24                	js     80306a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304a:	8b 00                	mov    (%rax),%eax
  80304c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	89 c7                	mov    %eax,%edi
  803055:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803064:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803068:	79 05                	jns    80306f <ftruncate+0x58>
		return r;
  80306a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306d:	eb 72                	jmp    8030e1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80306f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803073:	8b 40 08             	mov    0x8(%rax),%eax
  803076:	83 e0 03             	and    $0x3,%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	75 3a                	jne    8030b7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80307d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803084:	00 00 00 
  803087:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80308a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803090:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803093:	89 c6                	mov    %eax,%esi
  803095:	48 bf f8 4a 80 00 00 	movabs $0x804af8,%rdi
  80309c:	00 00 00 
  80309f:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a4:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  8030ab:	00 00 00 
  8030ae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8030b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030b5:	eb 2a                	jmp    8030e1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8030b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030bf:	48 85 c0             	test   %rax,%rax
  8030c2:	75 07                	jne    8030cb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8030c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030c9:	eb 16                	jmp    8030e1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8030cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8030d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8030da:	89 ce                	mov    %ecx,%esi
  8030dc:	48 89 d7             	mov    %rdx,%rdi
  8030df:	ff d0                	callq  *%rax
}
  8030e1:	c9                   	leaveq 
  8030e2:	c3                   	retq   

00000000008030e3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8030e3:	55                   	push   %rbp
  8030e4:	48 89 e5             	mov    %rsp,%rbp
  8030e7:	48 83 ec 30          	sub    $0x30,%rsp
  8030eb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030f9:	48 89 d6             	mov    %rdx,%rsi
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803111:	78 24                	js     803137 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803117:	8b 00                	mov    (%rax),%eax
  803119:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80311d:	48 89 d6             	mov    %rdx,%rsi
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <fstat+0x59>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 5e                	jmp    80319a <fstat+0xb7>
	if (!dev->dev_stat)
  80313c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803140:	48 8b 40 28          	mov    0x28(%rax),%rax
  803144:	48 85 c0             	test   %rax,%rax
  803147:	75 07                	jne    803150 <fstat+0x6d>
		return -E_NOT_SUPP;
  803149:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80314e:	eb 4a                	jmp    80319a <fstat+0xb7>
	stat->st_name[0] = 0;
  803150:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803154:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803157:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80315b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803162:	00 00 00 
	stat->st_isdir = 0;
  803165:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803169:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803170:	00 00 00 
	stat->st_dev = dev;
  803173:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803177:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80317b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803186:	48 8b 40 28          	mov    0x28(%rax),%rax
  80318a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80318e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803192:	48 89 ce             	mov    %rcx,%rsi
  803195:	48 89 d7             	mov    %rdx,%rdi
  803198:	ff d0                	callq  *%rax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 20          	sub    $0x20,%rsp
  8031a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b0:	be 00 00 00 00       	mov    $0x0,%esi
  8031b5:	48 89 c7             	mov    %rax,%rdi
  8031b8:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
  8031c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cb:	79 05                	jns    8031d2 <stat+0x36>
		return fd;
  8031cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d0:	eb 2f                	jmp    803201 <stat+0x65>
	r = fstat(fd, stat);
  8031d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	48 89 d6             	mov    %rdx,%rsi
  8031dc:	89 c7                	mov    %eax,%edi
  8031de:	48 b8 e3 30 80 00 00 	movabs $0x8030e3,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
  8031ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8031ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f0:	89 c7                	mov    %eax,%edi
  8031f2:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
	return r;
  8031fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803201:	c9                   	leaveq 
  803202:	c3                   	retq   

0000000000803203 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803203:	55                   	push   %rbp
  803204:	48 89 e5             	mov    %rsp,%rbp
  803207:	48 83 ec 10          	sub    $0x10,%rsp
  80320b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80320e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803212:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803219:	00 00 00 
  80321c:	8b 00                	mov    (%rax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 1d                	jne    80323f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803222:	bf 01 00 00 00       	mov    $0x1,%edi
  803227:	48 b8 1a 28 80 00 00 	movabs $0x80281a,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80323a:	00 00 00 
  80323d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80323f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803246:	00 00 00 
  803249:	8b 00                	mov    (%rax),%eax
  80324b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80324e:	b9 07 00 00 00       	mov    $0x7,%ecx
  803253:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80325a:	00 00 00 
  80325d:	89 c7                	mov    %eax,%edi
  80325f:	48 b8 7d 27 80 00 00 	movabs $0x80277d,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	ba 00 00 00 00       	mov    $0x0,%edx
  803274:	48 89 c6             	mov    %rax,%rsi
  803277:	bf 00 00 00 00       	mov    $0x0,%edi
  80327c:	48 b8 b7 26 80 00 00 	movabs $0x8026b7,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
}
  803288:	c9                   	leaveq 
  803289:	c3                   	retq   

000000000080328a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80328a:	55                   	push   %rbp
  80328b:	48 89 e5             	mov    %rsp,%rbp
  80328e:	48 83 ec 20          	sub    $0x20,%rsp
  803292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803296:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  803299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
  8032ac:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032b1:	7e 0a                	jle    8032bd <open+0x33>
  8032b3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032b8:	e9 a5 00 00 00       	jmpq   803362 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8032bd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032c1:	48 89 c7             	mov    %rax,%rdi
  8032c4:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  8032cb:	00 00 00 
  8032ce:	ff d0                	callq  *%rax
  8032d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d7:	79 08                	jns    8032e1 <open+0x57>
		return r;
  8032d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dc:	e9 81 00 00 00       	jmpq   803362 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8032e1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032e8:	00 00 00 
  8032eb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032ee:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8032f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f8:	48 89 c6             	mov    %rax,%rsi
  8032fb:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803302:	00 00 00 
  803305:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  803311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803315:	48 89 c6             	mov    %rax,%rsi
  803318:	bf 01 00 00 00       	mov    $0x1,%edi
  80331d:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
  803329:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80332c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803330:	79 1d                	jns    80334f <open+0xc5>
		fd_close(fd, 0);
  803332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803336:	be 00 00 00 00       	mov    $0x0,%esi
  80333b:	48 89 c7             	mov    %rax,%rdi
  80333e:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
		return r;
  80334a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334d:	eb 13                	jmp    803362 <open+0xd8>
	}
	return fd2num(fd);
  80334f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803353:	48 89 c7             	mov    %rax,%rdi
  803356:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  80335d:	00 00 00 
  803360:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  803362:	c9                   	leaveq 
  803363:	c3                   	retq   

0000000000803364 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803364:	55                   	push   %rbp
  803365:	48 89 e5             	mov    %rsp,%rbp
  803368:	48 83 ec 10          	sub    $0x10,%rsp
  80336c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803374:	8b 50 0c             	mov    0xc(%rax),%edx
  803377:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80337e:	00 00 00 
  803381:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803383:	be 00 00 00 00       	mov    $0x0,%esi
  803388:	bf 06 00 00 00       	mov    $0x6,%edi
  80338d:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  803394:	00 00 00 
  803397:	ff d0                	callq  *%rax
}
  803399:	c9                   	leaveq 
  80339a:	c3                   	retq   

000000000080339b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80339b:	55                   	push   %rbp
  80339c:	48 89 e5             	mov    %rsp,%rbp
  80339f:	48 83 ec 30          	sub    $0x30,%rsp
  8033a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8033af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8033b6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033bd:	00 00 00 
  8033c0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8033c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033c9:	00 00 00 
  8033cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033d0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8033d4:	be 00 00 00 00       	mov    $0x0,%esi
  8033d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8033de:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f1:	79 05                	jns    8033f8 <devfile_read+0x5d>
		return r;
  8033f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f6:	eb 26                	jmp    80341e <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	48 63 d0             	movslq %eax,%rdx
  8033fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803402:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803409:	00 00 00 
  80340c:	48 89 c7             	mov    %rax,%rdi
  80340f:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
	return r;
  80341b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80341e:	c9                   	leaveq 
  80341f:	c3                   	retq   

0000000000803420 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803420:	55                   	push   %rbp
  803421:	48 89 e5             	mov    %rsp,%rbp
  803424:	48 83 ec 30          	sub    $0x30,%rsp
  803428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80342c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803430:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  803434:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80343b:	00 
	n = n > max ? max : n;
  80343c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803440:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803444:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  803449:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80344d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803451:	8b 50 0c             	mov    0xc(%rax),%edx
  803454:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80345b:	00 00 00 
  80345e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803460:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803467:	00 00 00 
  80346a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80346e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803472:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803476:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347a:	48 89 c6             	mov    %rax,%rsi
  80347d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803484:	00 00 00 
  803487:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  803493:	be 00 00 00 00       	mov    $0x0,%esi
  803498:	bf 04 00 00 00       	mov    $0x4,%edi
  80349d:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 20          	sub    $0x20,%rsp
  8034b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8034bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034c9:	00 00 00 
  8034cc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8034ce:	be 00 00 00 00       	mov    $0x0,%esi
  8034d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8034d8:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8034df:	00 00 00 
  8034e2:	ff d0                	callq  *%rax
  8034e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034eb:	79 05                	jns    8034f2 <devfile_stat+0x47>
		return r;
  8034ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f0:	eb 56                	jmp    803548 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8034fd:	00 00 00 
  803500:	48 89 c7             	mov    %rax,%rdi
  803503:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80350f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803516:	00 00 00 
  803519:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80351f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803523:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803529:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803530:	00 00 00 
  803533:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 10          	sub    $0x10,%rsp
  803552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803556:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	8b 50 0c             	mov    0xc(%rax),%edx
  803560:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803567:	00 00 00 
  80356a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80356c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803573:	00 00 00 
  803576:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803579:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80357c:	be 00 00 00 00       	mov    $0x0,%esi
  803581:	bf 02 00 00 00       	mov    $0x2,%edi
  803586:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
}
  803592:	c9                   	leaveq 
  803593:	c3                   	retq   

0000000000803594 <remove>:

// Delete a file
int
remove(const char *path)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 10          	sub    $0x10,%rsp
  80359c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8035a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a4:	48 89 c7             	mov    %rax,%rdi
  8035a7:	48 b8 af 1a 80 00 00 	movabs $0x801aaf,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035b8:	7e 07                	jle    8035c1 <remove+0x2d>
		return -E_BAD_PATH;
  8035ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8035bf:	eb 33                	jmp    8035f4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8035c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c5:	48 89 c6             	mov    %rax,%rsi
  8035c8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8035cf:	00 00 00 
  8035d2:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8035de:	be 00 00 00 00       	mov    $0x0,%esi
  8035e3:	bf 07 00 00 00       	mov    $0x7,%edi
  8035e8:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  8035ef:	00 00 00 
  8035f2:	ff d0                	callq  *%rax
}
  8035f4:	c9                   	leaveq 
  8035f5:	c3                   	retq   

00000000008035f6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8035f6:	55                   	push   %rbp
  8035f7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035fa:	be 00 00 00 00       	mov    $0x0,%esi
  8035ff:	bf 08 00 00 00       	mov    $0x8,%edi
  803604:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
}
  803610:	5d                   	pop    %rbp
  803611:	c3                   	retq   

0000000000803612 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803612:	55                   	push   %rbp
  803613:	48 89 e5             	mov    %rsp,%rbp
  803616:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80361d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803624:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80362b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803632:	be 00 00 00 00       	mov    $0x0,%esi
  803637:	48 89 c7             	mov    %rax,%rdi
  80363a:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
  803646:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364d:	79 28                	jns    803677 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80364f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803652:	89 c6                	mov    %eax,%esi
  803654:	48 bf 1e 4b 80 00 00 	movabs $0x804b1e,%rdi
  80365b:	00 00 00 
  80365e:	b8 00 00 00 00       	mov    $0x0,%eax
  803663:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80366a:	00 00 00 
  80366d:	ff d2                	callq  *%rdx
		return fd_src;
  80366f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803672:	e9 74 01 00 00       	jmpq   8037eb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803677:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80367e:	be 01 01 00 00       	mov    $0x101,%esi
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 8a 32 80 00 00 	movabs $0x80328a,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803695:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803699:	79 39                	jns    8036d4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80369b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80369e:	89 c6                	mov    %eax,%esi
  8036a0:	48 bf 34 4b 80 00 00 	movabs $0x804b34,%rdi
  8036a7:	00 00 00 
  8036aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8036af:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  8036b6:	00 00 00 
  8036b9:	ff d2                	callq  *%rdx
		close(fd_src);
  8036bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036be:	89 c7                	mov    %eax,%edi
  8036c0:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
		return fd_dest;
  8036cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036cf:	e9 17 01 00 00       	jmpq   8037eb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8036d4:	eb 74                	jmp    80374a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8036d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036d9:	48 63 d0             	movslq %eax,%rdx
  8036dc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036e6:	48 89 ce             	mov    %rcx,%rsi
  8036e9:	89 c7                	mov    %eax,%edi
  8036eb:	48 b8 fe 2e 80 00 00 	movabs $0x802efe,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
  8036f7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8036fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8036fe:	79 4a                	jns    80374a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803700:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803703:	89 c6                	mov    %eax,%esi
  803705:	48 bf 4e 4b 80 00 00 	movabs $0x804b4e,%rdi
  80370c:	00 00 00 
  80370f:	b8 00 00 00 00       	mov    $0x0,%eax
  803714:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80371b:	00 00 00 
  80371e:	ff d2                	callq  *%rdx
			close(fd_src);
  803720:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803723:	89 c7                	mov    %eax,%edi
  803725:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  80372c:	00 00 00 
  80372f:	ff d0                	callq  *%rax
			close(fd_dest);
  803731:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803734:	89 c7                	mov    %eax,%edi
  803736:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
			return write_size;
  803742:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803745:	e9 a1 00 00 00       	jmpq   8037eb <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80374a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803754:	ba 00 02 00 00       	mov    $0x200,%edx
  803759:	48 89 ce             	mov    %rcx,%rsi
  80375c:	89 c7                	mov    %eax,%edi
  80375e:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
  80376a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80376d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803771:	0f 8f 5f ff ff ff    	jg     8036d6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803777:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80377b:	79 47                	jns    8037c4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80377d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803780:	89 c6                	mov    %eax,%esi
  803782:	48 bf 61 4b 80 00 00 	movabs $0x804b61,%rdi
  803789:	00 00 00 
  80378c:	b8 00 00 00 00       	mov    $0x0,%eax
  803791:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  803798:	00 00 00 
  80379b:	ff d2                	callq  *%rdx
		close(fd_src);
  80379d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a0:	89 c7                	mov    %eax,%edi
  8037a2:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
		close(fd_dest);
  8037ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b1:	89 c7                	mov    %eax,%edi
  8037b3:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
		return read_size;
  8037bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c2:	eb 27                	jmp    8037eb <copy+0x1d9>
	}
	close(fd_src);
  8037c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c7:	89 c7                	mov    %eax,%edi
  8037c9:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	callq  *%rax
	close(fd_dest);
  8037d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037d8:	89 c7                	mov    %eax,%edi
  8037da:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
	return 0;
  8037e6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8037eb:	c9                   	leaveq 
  8037ec:	c3                   	retq   

00000000008037ed <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037ed:	55                   	push   %rbp
  8037ee:	48 89 e5             	mov    %rsp,%rbp
  8037f1:	53                   	push   %rbx
  8037f2:	48 83 ec 38          	sub    $0x38,%rsp
  8037f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037fa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037fe:	48 89 c7             	mov    %rax,%rdi
  803801:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803808:	00 00 00 
  80380b:	ff d0                	callq  *%rax
  80380d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803810:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803814:	0f 88 bf 01 00 00    	js     8039d9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80381a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381e:	ba 07 04 00 00       	mov    $0x407,%edx
  803823:	48 89 c6             	mov    %rax,%rsi
  803826:	bf 00 00 00 00       	mov    $0x0,%edi
  80382b:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
  803837:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80383a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80383e:	0f 88 95 01 00 00    	js     8039d9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803844:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803848:	48 89 c7             	mov    %rax,%rdi
  80384b:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80385a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80385e:	0f 88 5d 01 00 00    	js     8039c1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803864:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803868:	ba 07 04 00 00       	mov    $0x407,%edx
  80386d:	48 89 c6             	mov    %rax,%rsi
  803870:	bf 00 00 00 00       	mov    $0x0,%edi
  803875:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803884:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803888:	0f 88 33 01 00 00    	js     8039c1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80388e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803892:	48 89 c7             	mov    %rax,%rdi
  803895:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8038ae:	48 89 c6             	mov    %rax,%rsi
  8038b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b6:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038c9:	79 05                	jns    8038d0 <pipe+0xe3>
		goto err2;
  8038cb:	e9 d9 00 00 00       	jmpq   8039a9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d4:	48 89 c7             	mov    %rax,%rdi
  8038d7:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  8038de:	00 00 00 
  8038e1:	ff d0                	callq  *%rax
  8038e3:	48 89 c2             	mov    %rax,%rdx
  8038e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ea:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038f0:	48 89 d1             	mov    %rdx,%rcx
  8038f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8038f8:	48 89 c6             	mov    %rax,%rsi
  8038fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803900:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
  80390c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80390f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803913:	79 1b                	jns    803930 <pipe+0x143>
		goto err3;
  803915:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803916:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391a:	48 89 c6             	mov    %rax,%rsi
  80391d:	bf 00 00 00 00       	mov    $0x0,%edi
  803922:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	eb 79                	jmp    8039a9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803934:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80393b:	00 00 00 
  80393e:	8b 12                	mov    (%rdx),%edx
  803940:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803942:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803946:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80394d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803951:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803958:	00 00 00 
  80395b:	8b 12                	mov    (%rdx),%edx
  80395d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80395f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803963:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80396a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396e:	48 89 c7             	mov    %rax,%rdi
  803971:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803978:	00 00 00 
  80397b:	ff d0                	callq  *%rax
  80397d:	89 c2                	mov    %eax,%edx
  80397f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803983:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803985:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803989:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80398d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803991:	48 89 c7             	mov    %rax,%rdi
  803994:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a7:	eb 33                	jmp    8039dc <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8039a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ad:	48 89 c6             	mov    %rax,%rsi
  8039b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b5:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8039c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c5:	48 89 c6             	mov    %rax,%rsi
  8039c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039cd:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8039d4:	00 00 00 
  8039d7:	ff d0                	callq  *%rax
err:
	return r;
  8039d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039dc:	48 83 c4 38          	add    $0x38,%rsp
  8039e0:	5b                   	pop    %rbx
  8039e1:	5d                   	pop    %rbp
  8039e2:	c3                   	retq   

00000000008039e3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039e3:	55                   	push   %rbp
  8039e4:	48 89 e5             	mov    %rsp,%rbp
  8039e7:	53                   	push   %rbx
  8039e8:	48 83 ec 28          	sub    $0x28,%rsp
  8039ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039fb:	00 00 00 
  8039fe:	48 8b 00             	mov    (%rax),%rax
  803a01:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a07:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 69 40 80 00 00 	movabs $0x804069,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	89 c3                	mov    %eax,%ebx
  803a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a23:	48 89 c7             	mov    %rax,%rdi
  803a26:	48 b8 69 40 80 00 00 	movabs $0x804069,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
  803a32:	39 c3                	cmp    %eax,%ebx
  803a34:	0f 94 c0             	sete   %al
  803a37:	0f b6 c0             	movzbl %al,%eax
  803a3a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a3d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a44:	00 00 00 
  803a47:	48 8b 00             	mov    (%rax),%rax
  803a4a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a50:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a56:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a59:	75 05                	jne    803a60 <_pipeisclosed+0x7d>
			return ret;
  803a5b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a5e:	eb 4f                	jmp    803aaf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a63:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a66:	74 42                	je     803aaa <_pipeisclosed+0xc7>
  803a68:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a6c:	75 3c                	jne    803aaa <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a6e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a75:	00 00 00 
  803a78:	48 8b 00             	mov    (%rax),%rax
  803a7b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a81:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a87:	89 c6                	mov    %eax,%esi
  803a89:	48 bf 7c 4b 80 00 00 	movabs $0x804b7c,%rdi
  803a90:	00 00 00 
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
  803a98:	49 b8 66 0f 80 00 00 	movabs $0x800f66,%r8
  803a9f:	00 00 00 
  803aa2:	41 ff d0             	callq  *%r8
	}
  803aa5:	e9 4a ff ff ff       	jmpq   8039f4 <_pipeisclosed+0x11>
  803aaa:	e9 45 ff ff ff       	jmpq   8039f4 <_pipeisclosed+0x11>
}
  803aaf:	48 83 c4 28          	add    $0x28,%rsp
  803ab3:	5b                   	pop    %rbx
  803ab4:	5d                   	pop    %rbp
  803ab5:	c3                   	retq   

0000000000803ab6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ab6:	55                   	push   %rbp
  803ab7:	48 89 e5             	mov    %rsp,%rbp
  803aba:	48 83 ec 30          	sub    $0x30,%rsp
  803abe:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ac1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ac5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ac8:	48 89 d6             	mov    %rdx,%rsi
  803acb:	89 c7                	mov    %eax,%edi
  803acd:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803ad4:	00 00 00 
  803ad7:	ff d0                	callq  *%rax
  803ad9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803adc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae0:	79 05                	jns    803ae7 <pipeisclosed+0x31>
		return r;
  803ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae5:	eb 31                	jmp    803b18 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aeb:	48 89 c7             	mov    %rax,%rdi
  803aee:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
  803afa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b06:	48 89 d6             	mov    %rdx,%rsi
  803b09:	48 89 c7             	mov    %rax,%rdi
  803b0c:	48 b8 e3 39 80 00 00 	movabs $0x8039e3,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
}
  803b18:	c9                   	leaveq 
  803b19:	c3                   	retq   

0000000000803b1a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b1a:	55                   	push   %rbp
  803b1b:	48 89 e5             	mov    %rsp,%rbp
  803b1e:	48 83 ec 40          	sub    $0x40,%rsp
  803b22:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b26:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b2a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b32:	48 89 c7             	mov    %rax,%rdi
  803b35:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b4d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b54:	00 
  803b55:	e9 92 00 00 00       	jmpq   803bec <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b5a:	eb 41                	jmp    803b9d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b5c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b61:	74 09                	je     803b6c <devpipe_read+0x52>
				return i;
  803b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b67:	e9 92 00 00 00       	jmpq   803bfe <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b74:	48 89 d6             	mov    %rdx,%rsi
  803b77:	48 89 c7             	mov    %rax,%rdi
  803b7a:	48 b8 e3 39 80 00 00 	movabs $0x8039e3,%rax
  803b81:	00 00 00 
  803b84:	ff d0                	callq  *%rax
  803b86:	85 c0                	test   %eax,%eax
  803b88:	74 07                	je     803b91 <devpipe_read+0x77>
				return 0;
  803b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8f:	eb 6d                	jmp    803bfe <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b91:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  803b98:	00 00 00 
  803b9b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba1:	8b 10                	mov    (%rax),%edx
  803ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba7:	8b 40 04             	mov    0x4(%rax),%eax
  803baa:	39 c2                	cmp    %eax,%edx
  803bac:	74 ae                	je     803b5c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbe:	8b 00                	mov    (%rax),%eax
  803bc0:	99                   	cltd   
  803bc1:	c1 ea 1b             	shr    $0x1b,%edx
  803bc4:	01 d0                	add    %edx,%eax
  803bc6:	83 e0 1f             	and    $0x1f,%eax
  803bc9:	29 d0                	sub    %edx,%eax
  803bcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bcf:	48 98                	cltq   
  803bd1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bd6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdc:	8b 00                	mov    (%rax),%eax
  803bde:	8d 50 01             	lea    0x1(%rax),%edx
  803be1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803be7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bf4:	0f 82 60 ff ff ff    	jb     803b5a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803bfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bfe:	c9                   	leaveq 
  803bff:	c3                   	retq   

0000000000803c00 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c00:	55                   	push   %rbp
  803c01:	48 89 e5             	mov    %rsp,%rbp
  803c04:	48 83 ec 40          	sub    $0x40,%rsp
  803c08:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c18:	48 89 c7             	mov    %rax,%rdi
  803c1b:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c33:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c3a:	00 
  803c3b:	e9 8e 00 00 00       	jmpq   803cce <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c40:	eb 31                	jmp    803c73 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4a:	48 89 d6             	mov    %rdx,%rsi
  803c4d:	48 89 c7             	mov    %rax,%rdi
  803c50:	48 b8 e3 39 80 00 00 	movabs $0x8039e3,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
  803c5c:	85 c0                	test   %eax,%eax
  803c5e:	74 07                	je     803c67 <devpipe_write+0x67>
				return 0;
  803c60:	b8 00 00 00 00       	mov    $0x0,%eax
  803c65:	eb 79                	jmp    803ce0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c67:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c77:	8b 40 04             	mov    0x4(%rax),%eax
  803c7a:	48 63 d0             	movslq %eax,%rdx
  803c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c81:	8b 00                	mov    (%rax),%eax
  803c83:	48 98                	cltq   
  803c85:	48 83 c0 20          	add    $0x20,%rax
  803c89:	48 39 c2             	cmp    %rax,%rdx
  803c8c:	73 b4                	jae    803c42 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c92:	8b 40 04             	mov    0x4(%rax),%eax
  803c95:	99                   	cltd   
  803c96:	c1 ea 1b             	shr    $0x1b,%edx
  803c99:	01 d0                	add    %edx,%eax
  803c9b:	83 e0 1f             	and    $0x1f,%eax
  803c9e:	29 d0                	sub    %edx,%eax
  803ca0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ca4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ca8:	48 01 ca             	add    %rcx,%rdx
  803cab:	0f b6 0a             	movzbl (%rdx),%ecx
  803cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cb2:	48 98                	cltq   
  803cb4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbc:	8b 40 04             	mov    0x4(%rax),%eax
  803cbf:	8d 50 01             	lea    0x1(%rax),%edx
  803cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cc9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cd6:	0f 82 64 ff ff ff    	jb     803c40 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 20          	sub    $0x20,%rsp
  803cea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803cf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf6:	48 89 c7             	mov    %rax,%rdi
  803cf9:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803d00:	00 00 00 
  803d03:	ff d0                	callq  *%rax
  803d05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0d:	48 be 8f 4b 80 00 00 	movabs $0x804b8f,%rsi
  803d14:	00 00 00 
  803d17:	48 89 c7             	mov    %rax,%rdi
  803d1a:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  803d21:	00 00 00 
  803d24:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d2a:	8b 50 04             	mov    0x4(%rax),%edx
  803d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d31:	8b 00                	mov    (%rax),%eax
  803d33:	29 c2                	sub    %eax,%edx
  803d35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d39:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d43:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d4a:	00 00 00 
	stat->st_dev = &devpipe;
  803d4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d51:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803d58:	00 00 00 
  803d5b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d67:	c9                   	leaveq 
  803d68:	c3                   	retq   

0000000000803d69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d69:	55                   	push   %rbp
  803d6a:	48 89 e5             	mov    %rsp,%rbp
  803d6d:	48 83 ec 10          	sub    $0x10,%rsp
  803d71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d79:	48 89 c6             	mov    %rax,%rsi
  803d7c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d81:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  803d88:	00 00 00 
  803d8b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d91:	48 89 c7             	mov    %rax,%rdi
  803d94:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  803d9b:	00 00 00 
  803d9e:	ff d0                	callq  *%rax
  803da0:	48 89 c6             	mov    %rax,%rsi
  803da3:	bf 00 00 00 00       	mov    $0x0,%edi
  803da8:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  803daf:	00 00 00 
  803db2:	ff d0                	callq  *%rax
}
  803db4:	c9                   	leaveq 
  803db5:	c3                   	retq   

0000000000803db6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803db6:	55                   	push   %rbp
  803db7:	48 89 e5             	mov    %rsp,%rbp
  803dba:	48 83 ec 20          	sub    $0x20,%rsp
  803dbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dc4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803dc7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803dcb:	be 01 00 00 00       	mov    $0x1,%esi
  803dd0:	48 89 c7             	mov    %rax,%rdi
  803dd3:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
}
  803ddf:	c9                   	leaveq 
  803de0:	c3                   	retq   

0000000000803de1 <getchar>:

int
getchar(void)
{
  803de1:	55                   	push   %rbp
  803de2:	48 89 e5             	mov    %rsp,%rbp
  803de5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803de9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ded:	ba 01 00 00 00       	mov    $0x1,%edx
  803df2:	48 89 c6             	mov    %rax,%rsi
  803df5:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfa:	48 b8 b4 2d 80 00 00 	movabs $0x802db4,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
  803e06:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e0d:	79 05                	jns    803e14 <getchar+0x33>
		return r;
  803e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e12:	eb 14                	jmp    803e28 <getchar+0x47>
	if (r < 1)
  803e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e18:	7f 07                	jg     803e21 <getchar+0x40>
		return -E_EOF;
  803e1a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e1f:	eb 07                	jmp    803e28 <getchar+0x47>
	return c;
  803e21:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e25:	0f b6 c0             	movzbl %al,%eax
}
  803e28:	c9                   	leaveq 
  803e29:	c3                   	retq   

0000000000803e2a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e2a:	55                   	push   %rbp
  803e2b:	48 89 e5             	mov    %rsp,%rbp
  803e2e:	48 83 ec 20          	sub    $0x20,%rsp
  803e32:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e3c:	48 89 d6             	mov    %rdx,%rsi
  803e3f:	89 c7                	mov    %eax,%edi
  803e41:	48 b8 82 29 80 00 00 	movabs $0x802982,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
  803e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e54:	79 05                	jns    803e5b <iscons+0x31>
		return r;
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e59:	eb 1a                	jmp    803e75 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5f:	8b 10                	mov    (%rax),%edx
  803e61:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803e68:	00 00 00 
  803e6b:	8b 00                	mov    (%rax),%eax
  803e6d:	39 c2                	cmp    %eax,%edx
  803e6f:	0f 94 c0             	sete   %al
  803e72:	0f b6 c0             	movzbl %al,%eax
}
  803e75:	c9                   	leaveq 
  803e76:	c3                   	retq   

0000000000803e77 <opencons>:

int
opencons(void)
{
  803e77:	55                   	push   %rbp
  803e78:	48 89 e5             	mov    %rsp,%rbp
  803e7b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e7f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e83:	48 89 c7             	mov    %rax,%rdi
  803e86:	48 b8 ea 28 80 00 00 	movabs $0x8028ea,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
  803e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e99:	79 05                	jns    803ea0 <opencons+0x29>
		return r;
  803e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e9e:	eb 5b                	jmp    803efb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ea9:	48 89 c6             	mov    %rax,%rsi
  803eac:	bf 00 00 00 00       	mov    $0x0,%edi
  803eb1:	48 b8 4a 24 80 00 00 	movabs $0x80244a,%rax
  803eb8:	00 00 00 
  803ebb:	ff d0                	callq  *%rax
  803ebd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ec0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ec4:	79 05                	jns    803ecb <opencons+0x54>
		return r;
  803ec6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec9:	eb 30                	jmp    803efb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecf:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ed6:	00 00 00 
  803ed9:	8b 12                	mov    (%rdx),%edx
  803edb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803edd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eec:	48 89 c7             	mov    %rax,%rdi
  803eef:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  803ef6:	00 00 00 
  803ef9:	ff d0                	callq  *%rax
}
  803efb:	c9                   	leaveq 
  803efc:	c3                   	retq   

0000000000803efd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803efd:	55                   	push   %rbp
  803efe:	48 89 e5             	mov    %rsp,%rbp
  803f01:	48 83 ec 30          	sub    $0x30,%rsp
  803f05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f16:	75 07                	jne    803f1f <devcons_read+0x22>
		return 0;
  803f18:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1d:	eb 4b                	jmp    803f6a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f1f:	eb 0c                	jmp    803f2d <devcons_read+0x30>
		sys_yield();
  803f21:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  803f28:	00 00 00 
  803f2b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f2d:	48 b8 4c 23 80 00 00 	movabs $0x80234c,%rax
  803f34:	00 00 00 
  803f37:	ff d0                	callq  *%rax
  803f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f40:	74 df                	je     803f21 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f46:	79 05                	jns    803f4d <devcons_read+0x50>
		return c;
  803f48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f4b:	eb 1d                	jmp    803f6a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f51:	75 07                	jne    803f5a <devcons_read+0x5d>
		return 0;
  803f53:	b8 00 00 00 00       	mov    $0x0,%eax
  803f58:	eb 10                	jmp    803f6a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5d:	89 c2                	mov    %eax,%edx
  803f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f63:	88 10                	mov    %dl,(%rax)
	return 1;
  803f65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f6a:	c9                   	leaveq 
  803f6b:	c3                   	retq   

0000000000803f6c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f6c:	55                   	push   %rbp
  803f6d:	48 89 e5             	mov    %rsp,%rbp
  803f70:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f77:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f7e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f85:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f93:	eb 76                	jmp    80400b <devcons_write+0x9f>
		m = n - tot;
  803f95:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f9c:	89 c2                	mov    %eax,%edx
  803f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa1:	29 c2                	sub    %eax,%edx
  803fa3:	89 d0                	mov    %edx,%eax
  803fa5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803fa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fab:	83 f8 7f             	cmp    $0x7f,%eax
  803fae:	76 07                	jbe    803fb7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fb0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fba:	48 63 d0             	movslq %eax,%rdx
  803fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc0:	48 63 c8             	movslq %eax,%rcx
  803fc3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fca:	48 01 c1             	add    %rax,%rcx
  803fcd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fd4:	48 89 ce             	mov    %rcx,%rsi
  803fd7:	48 89 c7             	mov    %rax,%rdi
  803fda:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803fe6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fe9:	48 63 d0             	movslq %eax,%rdx
  803fec:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ff3:	48 89 d6             	mov    %rdx,%rsi
  803ff6:	48 89 c7             	mov    %rax,%rdi
  803ff9:	48 b8 02 23 80 00 00 	movabs $0x802302,%rax
  804000:	00 00 00 
  804003:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804005:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804008:	01 45 fc             	add    %eax,-0x4(%rbp)
  80400b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400e:	48 98                	cltq   
  804010:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804017:	0f 82 78 ff ff ff    	jb     803f95 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80401d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804020:	c9                   	leaveq 
  804021:	c3                   	retq   

0000000000804022 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804022:	55                   	push   %rbp
  804023:	48 89 e5             	mov    %rsp,%rbp
  804026:	48 83 ec 08          	sub    $0x8,%rsp
  80402a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80402e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804033:	c9                   	leaveq 
  804034:	c3                   	retq   

0000000000804035 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804035:	55                   	push   %rbp
  804036:	48 89 e5             	mov    %rsp,%rbp
  804039:	48 83 ec 10          	sub    $0x10,%rsp
  80403d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804041:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804045:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804049:	48 be 9b 4b 80 00 00 	movabs $0x804b9b,%rsi
  804050:	00 00 00 
  804053:	48 89 c7             	mov    %rax,%rdi
  804056:	48 b8 1b 1b 80 00 00 	movabs $0x801b1b,%rax
  80405d:	00 00 00 
  804060:	ff d0                	callq  *%rax
	return 0;
  804062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804067:	c9                   	leaveq 
  804068:	c3                   	retq   

0000000000804069 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804069:	55                   	push   %rbp
  80406a:	48 89 e5             	mov    %rsp,%rbp
  80406d:	48 83 ec 18          	sub    $0x18,%rsp
  804071:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804079:	48 c1 e8 15          	shr    $0x15,%rax
  80407d:	48 89 c2             	mov    %rax,%rdx
  804080:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804087:	01 00 00 
  80408a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80408e:	83 e0 01             	and    $0x1,%eax
  804091:	48 85 c0             	test   %rax,%rax
  804094:	75 07                	jne    80409d <pageref+0x34>
		return 0;
  804096:	b8 00 00 00 00       	mov    $0x0,%eax
  80409b:	eb 53                	jmp    8040f0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80409d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8040a5:	48 89 c2             	mov    %rax,%rdx
  8040a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040af:	01 00 00 
  8040b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040be:	83 e0 01             	and    $0x1,%eax
  8040c1:	48 85 c0             	test   %rax,%rax
  8040c4:	75 07                	jne    8040cd <pageref+0x64>
		return 0;
  8040c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040cb:	eb 23                	jmp    8040f0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8040d5:	48 89 c2             	mov    %rax,%rdx
  8040d8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040df:	00 00 00 
  8040e2:	48 c1 e2 04          	shl    $0x4,%rdx
  8040e6:	48 01 d0             	add    %rdx,%rax
  8040e9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040ed:	0f b7 c0             	movzwl %ax,%eax
}
  8040f0:	c9                   	leaveq 
  8040f1:	c3                   	retq   
