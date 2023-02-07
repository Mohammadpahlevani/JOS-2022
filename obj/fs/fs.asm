
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 39 31 00 00       	callq  80317a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 20 67 80 00 00 	movabs $0x806720,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 37 67 80 00 00 	movabs $0x806737,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf 47 67 80 00 00 	movabs $0x806747,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 50 67 80 00 00 	movabs $0x806750,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 5d 67 80 00 00 	movabs $0x80675d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf 47 67 80 00 00 	movabs $0x806747,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 50 67 80 00 00 	movabs $0x806750,%rcx
  800345:	00 00 00 
  800348:	48 ba 5d 67 80 00 00 	movabs $0x80675d,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf 47 67 80 00 00 	movabs $0x806747,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba 78 67 80 00 00 	movabs $0x806778,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 30          	sub    $0x30,%rsp
  8005fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba a8 67 80 00 00 	movabs $0x8067a8,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba 2d 32 80 00 00 	movabs $0x80322d,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba d8 67 80 00 00 	movabs $0x8067d8,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0)
  8006ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f7:	48 89 c6             	mov    %rax,%rsi
  8006fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ff:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80070e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800712:	79 30                	jns    800744 <bc_pgfault+0x151>
		panic("in bc_pgfault, sys_page_alloc: %e",r);
  800714:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800717:	89 c1                	mov    %eax,%ecx
  800719:	48 ba 00 68 80 00 00 	movabs $0x806800,%rdx
  800720:	00 00 00 
  800723:	be 35 00 00 00       	mov    $0x35,%esi
  800728:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  80072f:	00 00 00 
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80073e:	00 00 00 
  800741:	41 ff d0             	callq  *%r8


	// LAB 5: Your code here
	if((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800748:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80074f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800753:	ba 08 00 00 00       	mov    $0x8,%edx
  800758:	48 89 c6             	mov    %rax,%rsi
  80075b:	89 cf                	mov    %ecx,%edi
  80075d:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  800764:	00 00 00 
  800767:	ff d0                	callq  *%rax
  800769:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80076c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800770:	79 30                	jns    8007a2 <bc_pgfault+0x1af>
		panic("in bc_pgfault, ide_read: %e", r);
  800772:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800775:	89 c1                	mov    %eax,%ecx
  800777:	48 ba 22 68 80 00 00 	movabs $0x806822,%rdx
  80077e:	00 00 00 
  800781:	be 3a 00 00 00       	mov    $0x3a,%esi
  800786:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  80078d:	00 00 00 
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80079c:	00 00 00 
  80079f:	41 ff d0             	callq  *%r8

	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8007a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8007aa:	48 89 c2             	mov    %rax,%rdx
  8007ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007b4:	01 00 00 
  8007b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8007c0:	89 c1                	mov    %eax,%ecx
  8007c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007ca:	41 89 c8             	mov    %ecx,%r8d
  8007cd:	48 89 d1             	mov    %rdx,%rcx
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	48 89 c6             	mov    %rax,%rsi
  8007d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8007dd:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f0:	79 30                	jns    800822 <bc_pgfault+0x22f>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f5:	89 c1                	mov    %eax,%ecx
  8007f7:	48 ba 40 68 80 00 00 	movabs $0x806840,%rdx
  8007fe:	00 00 00 
  800801:	be 3d 00 00 00       	mov    $0x3d,%esi
  800806:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  80080d:	00 00 00 
  800810:	b8 00 00 00 00       	mov    $0x0,%eax
  800815:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80081c:	00 00 00 
  80081f:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800822:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800829:	00 00 00 
  80082c:	48 8b 00             	mov    (%rax),%rax
  80082f:	48 85 c0             	test   %rax,%rax
  800832:	74 48                	je     80087c <bc_pgfault+0x289>
  800834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800838:	89 c7                	mov    %eax,%edi
  80083a:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  800841:	00 00 00 
  800844:	ff d0                	callq  *%rax
  800846:	84 c0                	test   %al,%al
  800848:	74 32                	je     80087c <bc_pgfault+0x289>
		panic("reading free block %08x\n", blockno);
  80084a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80084e:	48 89 c1             	mov    %rax,%rcx
  800851:	48 ba 60 68 80 00 00 	movabs $0x806860,%rdx
  800858:	00 00 00 
  80085b:	be 43 00 00 00       	mov    $0x43,%esi
  800860:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800867:	00 00 00 
  80086a:	b8 00 00 00 00       	mov    $0x0,%eax
  80086f:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800876:	00 00 00 
  800879:	41 ff d0             	callq  *%r8
}
  80087c:	c9                   	leaveq 
  80087d:	c3                   	retq   

000000000080087e <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80087e:	55                   	push   %rbp
  80087f:	48 89 e5             	mov    %rsp,%rbp
  800882:	48 83 ec 30          	sub    $0x30,%rsp
  800886:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80088a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800894:	48 c1 e8 0c          	shr    $0xc,%rax
  800898:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80089c:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  8008a3:	0f 
  8008a4:	76 0b                	jbe    8008b1 <flush_block+0x33>
  8008a6:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  8008ab:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8008af:	76 32                	jbe    8008e3 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  8008b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b5:	48 89 c1             	mov    %rax,%rcx
  8008b8:	48 ba 79 68 80 00 00 	movabs $0x806879,%rdx
  8008bf:	00 00 00 
  8008c2:	be 53 00 00 00       	mov    $0x53,%esi
  8008c7:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  8008ce:	00 00 00 
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  8008dd:	00 00 00 
  8008e0:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.
  // panic("flush_block not implemented");
	addr = ROUNDDOWN(addr, PGSIZE);
  8008e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8008eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ef:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8008f5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if(!va_is_mapped(addr) || !va_is_dirty(addr)) return;
  8008f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008fd:	48 89 c7             	mov    %rax,%rdi
  800900:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800907:	00 00 00 
  80090a:	ff d0                	callq  *%rax
  80090c:	83 f0 01             	xor    $0x1,%eax
  80090f:	84 c0                	test   %al,%al
  800911:	75 1a                	jne    80092d <flush_block+0xaf>
  800913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800917:	48 89 c7             	mov    %rax,%rdi
  80091a:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800921:	00 00 00 
  800924:	ff d0                	callq  *%rax
  800926:	83 f0 01             	xor    $0x1,%eax
  800929:	84 c0                	test   %al,%al
  80092b:	74 05                	je     800932 <flush_block+0xb4>
  80092d:	e9 de 00 00 00       	jmpq   800a10 <flush_block+0x192>
	int r;
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800936:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80093d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800941:	ba 08 00 00 00       	mov    $0x8,%edx
  800946:	48 89 c6             	mov    %rax,%rsi
  800949:	89 cf                	mov    %ecx,%edi
  80094b:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  800952:	00 00 00 
  800955:	ff d0                	callq  *%rax
  800957:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80095a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80095e:	79 30                	jns    800990 <flush_block+0x112>
		panic("in flush_block, ide_write: %e", r);
  800960:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800963:	89 c1                	mov    %eax,%ecx
  800965:	48 ba 94 68 80 00 00 	movabs $0x806894,%rdx
  80096c:	00 00 00 
  80096f:	be 5b 00 00 00       	mov    $0x5b,%esi
  800974:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  80097b:	00 00 00 
  80097e:	b8 00 00 00 00       	mov    $0x0,%eax
  800983:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80098a:	00 00 00 
  80098d:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800994:	48 c1 e8 0c          	shr    $0xc,%rax
  800998:	48 89 c2             	mov    %rax,%rdx
  80099b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009a2:	01 00 00 
  8009a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8009ae:	89 c1                	mov    %eax,%ecx
  8009b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8009b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009b8:	41 89 c8             	mov    %ecx,%r8d
  8009bb:	48 89 d1             	mov    %rdx,%rcx
  8009be:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c3:	48 89 c6             	mov    %rax,%rsi
  8009c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009cb:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8009da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009de:	79 30                	jns    800a10 <flush_block+0x192>
		panic("in flush_block, sys_page_map: %e", r);
  8009e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009e3:	89 c1                	mov    %eax,%ecx
  8009e5:	48 ba b8 68 80 00 00 	movabs $0x8068b8,%rdx
  8009ec:	00 00 00 
  8009ef:	be 5d 00 00 00       	mov    $0x5d,%esi
  8009f4:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  8009fb:	00 00 00 
  8009fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800a03:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800a0a:	00 00 00 
  800a0d:	41 ff d0             	callq  *%r8
}
  800a10:	c9                   	leaveq 
  800a11:	c3                   	retq   

0000000000800a12 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800a12:	55                   	push   %rbp
  800a13:	48 89 e5             	mov    %rsp,%rbp
  800a16:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800a1d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a22:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a29:	00 00 00 
  800a2c:	ff d0                	callq  *%rax
  800a2e:	48 89 c1             	mov    %rax,%rcx
  800a31:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800a38:	ba 08 01 00 00       	mov    $0x108,%edx
  800a3d:	48 89 ce             	mov    %rcx,%rsi
  800a40:	48 89 c7             	mov    %rax,%rdi
  800a43:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  800a4a:	00 00 00 
  800a4d:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a4f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a54:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
  800a60:	48 be d9 68 80 00 00 	movabs $0x8068d9,%rsi
  800a67:	00 00 00 
  800a6a:	48 89 c7             	mov    %rax,%rdi
  800a6d:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  800a74:	00 00 00 
  800a77:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a79:	bf 01 00 00 00       	mov    $0x1,%edi
  800a7e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a85:	00 00 00 
  800a88:	ff d0                	callq  *%rax
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a99:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800aa5:	00 00 00 
  800aa8:	ff d0                	callq  *%rax
  800aaa:	48 89 c7             	mov    %rax,%rdi
  800aad:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax
  800ab9:	83 f0 01             	xor    $0x1,%eax
  800abc:	84 c0                	test   %al,%al
  800abe:	74 35                	je     800af5 <check_bc+0xe3>
  800ac0:	48 b9 e0 68 80 00 00 	movabs $0x8068e0,%rcx
  800ac7:	00 00 00 
  800aca:	48 ba fa 68 80 00 00 	movabs $0x8068fa,%rdx
  800ad1:	00 00 00 
  800ad4:	be 6d 00 00 00       	mov    $0x6d,%esi
  800ad9:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800ae0:	00 00 00 
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae8:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800aef:	00 00 00 
  800af2:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800af5:	bf 01 00 00 00       	mov    $0x1,%edi
  800afa:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b01:	00 00 00 
  800b04:	ff d0                	callq  *%rax
  800b06:	48 89 c7             	mov    %rax,%rdi
  800b09:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800b10:	00 00 00 
  800b13:	ff d0                	callq  *%rax
  800b15:	84 c0                	test   %al,%al
  800b17:	74 35                	je     800b4e <check_bc+0x13c>
  800b19:	48 b9 0f 69 80 00 00 	movabs $0x80690f,%rcx
  800b20:	00 00 00 
  800b23:	48 ba fa 68 80 00 00 	movabs $0x8068fa,%rdx
  800b2a:	00 00 00 
  800b2d:	be 6e 00 00 00       	mov    $0x6e,%esi
  800b32:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800b39:	00 00 00 
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800b48:	00 00 00 
  800b4b:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800b4e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b53:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	callq  *%rax
  800b5f:	48 89 c6             	mov    %rax,%rsi
  800b62:	bf 00 00 00 00       	mov    $0x0,%edi
  800b67:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b73:	bf 01 00 00 00       	mov    $0x1,%edi
  800b78:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	callq  *%rax
  800b84:	48 89 c7             	mov    %rax,%rdi
  800b87:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	callq  *%rax
  800b93:	84 c0                	test   %al,%al
  800b95:	74 35                	je     800bcc <check_bc+0x1ba>
  800b97:	48 b9 29 69 80 00 00 	movabs $0x806929,%rcx
  800b9e:	00 00 00 
  800ba1:	48 ba fa 68 80 00 00 	movabs $0x8068fa,%rdx
  800ba8:	00 00 00 
  800bab:	be 72 00 00 00       	mov    $0x72,%esi
  800bb0:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800bb7:	00 00 00 
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbf:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800bc6:	00 00 00 
  800bc9:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800bcc:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd1:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bd8:	00 00 00 
  800bdb:	ff d0                	callq  *%rax
  800bdd:	48 be d9 68 80 00 00 	movabs $0x8068d9,%rsi
  800be4:	00 00 00 
  800be7:	48 89 c7             	mov    %rax,%rdi
  800bea:	48 b8 7d 41 80 00 00 	movabs $0x80417d,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	callq  *%rax
  800bf6:	85 c0                	test   %eax,%eax
  800bf8:	74 35                	je     800c2f <check_bc+0x21d>
  800bfa:	48 b9 48 69 80 00 00 	movabs $0x806948,%rcx
  800c01:	00 00 00 
  800c04:	48 ba fa 68 80 00 00 	movabs $0x8068fa,%rdx
  800c0b:	00 00 00 
  800c0e:	be 75 00 00 00       	mov    $0x75,%esi
  800c13:	48 bf 9a 67 80 00 00 	movabs $0x80679a,%rdi
  800c1a:	00 00 00 
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800c29:	00 00 00 
  800c2c:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800c2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c34:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c3b:	00 00 00 
  800c3e:	ff d0                	callq  *%rax
  800c40:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800c47:	ba 08 01 00 00       	mov    $0x108,%edx
  800c4c:	48 89 ce             	mov    %rcx,%rsi
  800c4f:	48 89 c7             	mov    %rax,%rdi
  800c52:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  800c59:	00 00 00 
  800c5c:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800c5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c63:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c6a:	00 00 00 
  800c6d:	ff d0                	callq  *%rax
  800c6f:	48 89 c7             	mov    %rax,%rdi
  800c72:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c7e:	48 bf 6c 69 80 00 00 	movabs $0x80696c,%rdi
  800c85:	00 00 00 
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8d:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  800c94:	00 00 00 
  800c97:	ff d2                	callq  *%rdx
}
  800c99:	c9                   	leaveq 
  800c9a:	c3                   	retq   

0000000000800c9b <bc_init>:

void
bc_init(void)
{
  800c9b:	55                   	push   %rbp
  800c9c:	48 89 e5             	mov    %rsp,%rbp
  800c9f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800ca6:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800cad:	00 00 00 
  800cb0:	48 b8 b7 4b 80 00 00 	movabs $0x804bb7,%rax
  800cb7:	00 00 00 
  800cba:	ff d0                	callq  *%rax
	check_bc();
  800cbc:	48 b8 12 0a 80 00 00 	movabs $0x800a12,%rax
  800cc3:	00 00 00 
  800cc6:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800cc8:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccd:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800cd4:	00 00 00 
  800cd7:	ff d0                	callq  *%rax
  800cd9:	48 89 c1             	mov    %rax,%rcx
  800cdc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ce3:	ba 08 01 00 00       	mov    $0x108,%edx
  800ce8:	48 89 ce             	mov    %rcx,%rsi
  800ceb:	48 89 c7             	mov    %rax,%rdi
  800cee:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  800cf5:	00 00 00 
  800cf8:	ff d0                	callq  *%rax
}
  800cfa:	c9                   	leaveq 
  800cfb:	c3                   	retq   

0000000000800cfc <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800cfc:	55                   	push   %rbp
  800cfd:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800d00:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d07:	00 00 00 
  800d0a:	48 8b 00             	mov    (%rax),%rax
  800d0d:	8b 00                	mov    (%rax),%eax
  800d0f:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800d14:	74 2a                	je     800d40 <check_super+0x44>
		panic("bad file system magic number");
  800d16:	48 ba 81 69 80 00 00 	movabs $0x806981,%rdx
  800d1d:	00 00 00 
  800d20:	be 0e 00 00 00       	mov    $0xe,%esi
  800d25:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  800d2c:	00 00 00 
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  800d3b:	00 00 00 
  800d3e:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d40:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d47:	00 00 00 
  800d4a:	48 8b 00             	mov    (%rax),%rax
  800d4d:	8b 40 04             	mov    0x4(%rax),%eax
  800d50:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d55:	76 2a                	jbe    800d81 <check_super+0x85>
		panic("file system is too large");
  800d57:	48 ba a6 69 80 00 00 	movabs $0x8069a6,%rdx
  800d5e:	00 00 00 
  800d61:	be 11 00 00 00       	mov    $0x11,%esi
  800d66:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  800d6d:	00 00 00 
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
  800d75:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  800d7c:	00 00 00 
  800d7f:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d81:	48 bf bf 69 80 00 00 	movabs $0x8069bf,%rdi
  800d88:	00 00 00 
  800d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d90:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  800d97:	00 00 00 
  800d9a:	ff d2                	callq  *%rdx
}
  800d9c:	5d                   	pop    %rbp
  800d9d:	c3                   	retq   

0000000000800d9e <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d9e:	55                   	push   %rbp
  800d9f:	48 89 e5             	mov    %rsp,%rbp
  800da2:	48 83 ec 04          	sub    $0x4,%rsp
  800da6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800da9:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800db0:	00 00 00 
  800db3:	48 8b 00             	mov    (%rax),%rax
  800db6:	48 85 c0             	test   %rax,%rax
  800db9:	74 15                	je     800dd0 <block_is_free+0x32>
  800dbb:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800dc2:	00 00 00 
  800dc5:	48 8b 00             	mov    (%rax),%rax
  800dc8:	8b 40 04             	mov    0x4(%rax),%eax
  800dcb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800dce:	77 07                	ja     800dd7 <block_is_free+0x39>
		return 0;
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	eb 41                	jmp    800e18 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800dd7:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800dde:	00 00 00 
  800de1:	48 8b 00             	mov    (%rax),%rax
  800de4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800de7:	c1 ea 05             	shr    $0x5,%edx
  800dea:	89 d2                	mov    %edx,%edx
  800dec:	48 c1 e2 02          	shl    $0x2,%rdx
  800df0:	48 01 d0             	add    %rdx,%rax
  800df3:	8b 10                	mov    (%rax),%edx
  800df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df8:	83 e0 1f             	and    $0x1f,%eax
  800dfb:	be 01 00 00 00       	mov    $0x1,%esi
  800e00:	89 c1                	mov    %eax,%ecx
  800e02:	d3 e6                	shl    %cl,%esi
  800e04:	89 f0                	mov    %esi,%eax
  800e06:	21 d0                	and    %edx,%eax
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	74 07                	je     800e13 <block_is_free+0x75>
		return 1;
  800e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  800e11:	eb 05                	jmp    800e18 <block_is_free+0x7a>
	return 0;
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e18:	c9                   	leaveq 
  800e19:	c3                   	retq   

0000000000800e1a <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800e1a:	55                   	push   %rbp
  800e1b:	48 89 e5             	mov    %rsp,%rbp
  800e1e:	48 83 ec 10          	sub    $0x10,%rsp
  800e22:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e29:	75 2a                	jne    800e55 <free_block+0x3b>
		panic("attempt to free zero block");
  800e2b:	48 ba d3 69 80 00 00 	movabs $0x8069d3,%rdx
  800e32:	00 00 00 
  800e35:	be 2c 00 00 00       	mov    $0x2c,%esi
  800e3a:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  800e41:	00 00 00 
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
  800e49:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  800e50:	00 00 00 
  800e53:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e55:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e5c:	00 00 00 
  800e5f:	48 8b 10             	mov    (%rax),%rdx
  800e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e65:	c1 e8 05             	shr    $0x5,%eax
  800e68:	89 c1                	mov    %eax,%ecx
  800e6a:	48 c1 e1 02          	shl    $0x2,%rcx
  800e6e:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e72:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800e79:	00 00 00 
  800e7c:	48 8b 12             	mov    (%rdx),%rdx
  800e7f:	89 c0                	mov    %eax,%eax
  800e81:	48 c1 e0 02          	shl    $0x2,%rax
  800e85:	48 01 d0             	add    %rdx,%rax
  800e88:	8b 10                	mov    (%rax),%edx
  800e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8d:	83 e0 1f             	and    $0x1f,%eax
  800e90:	bf 01 00 00 00       	mov    $0x1,%edi
  800e95:	89 c1                	mov    %eax,%ecx
  800e97:	d3 e7                	shl    %cl,%edi
  800e99:	89 f8                	mov    %edi,%eax
  800e9b:	09 d0                	or     %edx,%eax
  800e9d:	89 06                	mov    %eax,(%rsi)
}
  800e9f:	c9                   	leaveq 
  800ea0:	c3                   	retq   

0000000000800ea1 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800ea1:	55                   	push   %rbp
  800ea2:	48 89 e5             	mov    %rsp,%rbp
  800ea5:	48 83 ec 10          	sub    $0x10,%rsp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.

	if(super){
  800ea9:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800eb0:	00 00 00 
  800eb3:	48 8b 00             	mov    (%rax),%rax
  800eb6:	48 85 c0             	test   %rax,%rax
  800eb9:	0f 84 af 00 00 00    	je     800f6e <alloc_block+0xcd>
		uint32_t i;
		for(i = 2; i < super->s_nblocks;i++){
  800ebf:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
  800ec6:	e9 8a 00 00 00       	jmpq   800f55 <alloc_block+0xb4>
			if(block_is_free(i)){
  800ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ece:	89 c7                	mov    %eax,%edi
  800ed0:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  800ed7:	00 00 00 
  800eda:	ff d0                	callq  *%rax
  800edc:	84 c0                	test   %al,%al
  800ede:	74 71                	je     800f51 <alloc_block+0xb0>
				bitmap[i / 32] &= ~(1 << (i % 32));
  800ee0:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800ee7:	00 00 00 
  800eea:	48 8b 10             	mov    (%rax),%rdx
  800eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ef0:	c1 e8 05             	shr    $0x5,%eax
  800ef3:	89 c1                	mov    %eax,%ecx
  800ef5:	48 c1 e1 02          	shl    $0x2,%rcx
  800ef9:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800efd:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800f04:	00 00 00 
  800f07:	48 8b 12             	mov    (%rdx),%rdx
  800f0a:	89 c0                	mov    %eax,%eax
  800f0c:	48 c1 e0 02          	shl    $0x2,%rax
  800f10:	48 01 d0             	add    %rdx,%rax
  800f13:	8b 10                	mov    (%rax),%edx
  800f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f18:	83 e0 1f             	and    $0x1f,%eax
  800f1b:	bf 01 00 00 00       	mov    $0x1,%edi
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	d3 e7                	shl    %cl,%edi
  800f24:	89 f8                	mov    %edi,%eax
  800f26:	f7 d0                	not    %eax
  800f28:	21 d0                	and    %edx,%eax
  800f2a:	89 06                	mov    %eax,(%rsi)
				flush_block(diskaddr(1));
  800f2c:	bf 01 00 00 00       	mov    $0x1,%edi
  800f31:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800f38:	00 00 00 
  800f3b:	ff d0                	callq  *%rax
  800f3d:	48 89 c7             	mov    %rax,%rdi
  800f40:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	callq  *%rax
				return i;
  800f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4f:	eb 22                	jmp    800f73 <alloc_block+0xd2>

	// LAB 5: Your code here.

	if(super){
		uint32_t i;
		for(i = 2; i < super->s_nblocks;i++){
  800f51:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f55:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800f5c:	00 00 00 
  800f5f:	48 8b 00             	mov    (%rax),%rax
  800f62:	8b 40 04             	mov    0x4(%rax),%eax
  800f65:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800f68:	0f 87 5d ff ff ff    	ja     800ecb <alloc_block+0x2a>
				return i;
			}
		}
	}
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
  800f6e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f73:	c9                   	leaveq 
  800f74:	c3                   	retq   

0000000000800f75 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f75:	55                   	push   %rbp
  800f76:	48 89 e5             	mov    %rsp,%rbp
  800f79:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f84:	eb 51                	jmp    800fd7 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f89:	83 c0 02             	add    $0x2,%eax
  800f8c:	89 c7                	mov    %eax,%edi
  800f8e:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  800f95:	00 00 00 
  800f98:	ff d0                	callq  *%rax
  800f9a:	84 c0                	test   %al,%al
  800f9c:	74 35                	je     800fd3 <check_bitmap+0x5e>
  800f9e:	48 b9 ee 69 80 00 00 	movabs $0x8069ee,%rcx
  800fa5:	00 00 00 
  800fa8:	48 ba 02 6a 80 00 00 	movabs $0x806a02,%rdx
  800faf:	00 00 00 
  800fb2:	be 5a 00 00 00       	mov    $0x5a,%esi
  800fb7:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  800fbe:	00 00 00 
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc6:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  800fcd:	00 00 00 
  800fd0:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800fd3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fda:	c1 e0 0f             	shl    $0xf,%eax
  800fdd:	89 c2                	mov    %eax,%edx
  800fdf:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800fe6:	00 00 00 
  800fe9:	48 8b 00             	mov    (%rax),%rax
  800fec:	8b 40 04             	mov    0x4(%rax),%eax
  800fef:	39 c2                	cmp    %eax,%edx
  800ff1:	72 93                	jb     800f86 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff8:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  800fff:	00 00 00 
  801002:	ff d0                	callq  *%rax
  801004:	84 c0                	test   %al,%al
  801006:	74 35                	je     80103d <check_bitmap+0xc8>
  801008:	48 b9 17 6a 80 00 00 	movabs $0x806a17,%rcx
  80100f:	00 00 00 
  801012:	48 ba 02 6a 80 00 00 	movabs $0x806a02,%rdx
  801019:	00 00 00 
  80101c:	be 5d 00 00 00       	mov    $0x5d,%esi
  801021:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  801028:	00 00 00 
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
  801030:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  801037:	00 00 00 
  80103a:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  80103d:	bf 01 00 00 00       	mov    $0x1,%edi
  801042:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  801049:	00 00 00 
  80104c:	ff d0                	callq  *%rax
  80104e:	84 c0                	test   %al,%al
  801050:	74 35                	je     801087 <check_bitmap+0x112>
  801052:	48 b9 29 6a 80 00 00 	movabs $0x806a29,%rcx
  801059:	00 00 00 
  80105c:	48 ba 02 6a 80 00 00 	movabs $0x806a02,%rdx
  801063:	00 00 00 
  801066:	be 5e 00 00 00       	mov    $0x5e,%esi
  80106b:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  801072:	00 00 00 
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  801081:	00 00 00 
  801084:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801087:	48 bf 3b 6a 80 00 00 	movabs $0x806a3b,%rdi
  80108e:	00 00 00 
  801091:	b8 00 00 00 00       	mov    $0x0,%eax
  801096:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  80109d:	00 00 00 
  8010a0:	ff d2                	callq  *%rdx
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);


	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  8010a8:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	callq  *%rax
  8010b4:	84 c0                	test   %al,%al
  8010b6:	74 13                	je     8010cb <fs_init+0x27>
		ide_set_disk(1);
  8010b8:	bf 01 00 00 00       	mov    $0x1,%edi
  8010bd:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010c4:	00 00 00 
  8010c7:	ff d0                	callq  *%rax
  8010c9:	eb 11                	jmp    8010dc <fs_init+0x38>
	else
		ide_set_disk(0);
  8010cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8010d0:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010d7:	00 00 00 
  8010da:	ff d0                	callq  *%rax


	bc_init();
  8010dc:	48 b8 9b 0c 80 00 00 	movabs $0x800c9b,%rax
  8010e3:	00 00 00 
  8010e6:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8010ed:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	callq  *%rax
  8010f9:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  801100:	00 00 00 
  801103:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  801106:	48 b8 fc 0c 80 00 00 	movabs $0x800cfc,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  801112:	bf 02 00 00 00       	mov    $0x2,%edi
  801117:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80111e:	00 00 00 
  801121:	ff d0                	callq  *%rax
  801123:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  80112a:	00 00 00 
  80112d:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  801130:	48 b8 75 0f 80 00 00 	movabs $0x800f75,%rax
  801137:	00 00 00 
  80113a:	ff d0                	callq  *%rax
}
  80113c:	5d                   	pop    %rbp
  80113d:	c3                   	retq   

000000000080113e <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	48 83 ec 40          	sub    $0x40,%rsp
  801146:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80114a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  80114d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  801151:	89 c8                	mov    %ecx,%eax
  801153:	88 45 d0             	mov    %al,-0x30(%rbp)
  // LAB 5: Your code here.
	if(filebno >= NDIRECT + NINDIRECT || filebno > f->f_size / BLKSIZE) return -E_INVAL;
  801156:	81 7d d4 09 04 00 00 	cmpl   $0x409,-0x2c(%rbp)
  80115d:	77 1d                	ja     80117c <file_block_walk+0x3e>
  80115f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801163:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801169:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80116f:	85 c0                	test   %eax,%eax
  801171:	0f 48 c2             	cmovs  %edx,%eax
  801174:	c1 f8 0c             	sar    $0xc,%eax
  801177:	3b 45 d4             	cmp    -0x2c(%rbp),%eax
  80117a:	73 0a                	jae    801186 <file_block_walk+0x48>
  80117c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801181:	e9 04 02 00 00       	jmpq   80138a <file_block_walk+0x24c>
	//uint32_t end = f->f_size / BLKSIZE;
	//if(filebno > end) return -E_NOT_FOUND;
	//cprintf("blockno = %d, size = %d\n", filebno, f->f_size / BLKSIZE);
	int r;
	if(filebno < NDIRECT) {
  801186:	83 7d d4 09          	cmpl   $0x9,-0x2c(%rbp)
  80118a:	77 7b                	ja     801207 <file_block_walk+0xc9>
		if(!f->f_direct[filebno]){
  80118c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801190:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801193:	48 83 c2 20          	add    $0x20,%rdx
  801197:	8b 44 90 08          	mov    0x8(%rax,%rdx,4),%eax
  80119b:	85 c0                	test   %eax,%eax
  80119d:	75 42                	jne    8011e1 <file_block_walk+0xa3>
			r = alloc_block();
  80119f:	48 b8 a1 0e 80 00 00 	movabs $0x800ea1,%rax
  8011a6:	00 00 00 
  8011a9:	ff d0                	callq  *%rax
  8011ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
			if(r < 0) return r;
  8011ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011b2:	79 08                	jns    8011bc <file_block_walk+0x7e>
  8011b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b7:	e9 ce 01 00 00       	jmpq   80138a <file_block_walk+0x24c>
			f->f_direct[filebno] = r;
  8011bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8011c6:	48 83 c1 20          	add    $0x20,%rcx
  8011ca:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
			flush_block(f);
  8011ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d2:	48 89 c7             	mov    %rax,%rdi
  8011d5:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  8011dc:	00 00 00 
  8011df:	ff d0                	callq  *%rax
		}
		*ppdiskbno = &(f->f_direct[filebno]);
  8011e1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8011e4:	48 83 c0 20          	add    $0x20,%rax
  8011e8:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8011ef:	00 
  8011f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f4:	48 01 d0             	add    %rdx,%rax
  8011f7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8011fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011ff:	48 89 10             	mov    %rdx,(%rax)
  801202:	e9 7e 01 00 00       	jmpq   801385 <file_block_walk+0x247>
	} else{
		bool need_alloc = f->f_indirect == 0;
  801207:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801211:	85 c0                	test   %eax,%eax
  801213:	0f 94 c0             	sete   %al
  801216:	88 45 fb             	mov    %al,-0x5(%rbp)
		if(need_alloc){
  801219:	80 7d fb 00          	cmpb   $0x0,-0x5(%rbp)
  80121d:	74 52                	je     801271 <file_block_walk+0x133>
			if(!alloc) return -E_NOT_FOUND;
  80121f:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
  801223:	83 f0 01             	xor    $0x1,%eax
  801226:	84 c0                	test   %al,%al
  801228:	74 0a                	je     801234 <file_block_walk+0xf6>
  80122a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80122f:	e9 56 01 00 00       	jmpq   80138a <file_block_walk+0x24c>
			r = alloc_block();
  801234:	48 b8 a1 0e 80 00 00 	movabs $0x800ea1,%rax
  80123b:	00 00 00 
  80123e:	ff d0                	callq  *%rax
  801240:	89 45 fc             	mov    %eax,-0x4(%rbp)
			if(r < 0) return r;
  801243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801247:	79 08                	jns    801251 <file_block_walk+0x113>
  801249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80124c:	e9 39 01 00 00       	jmpq   80138a <file_block_walk+0x24c>
			f->f_indirect = r;
  801251:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801258:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
			flush_block(f);
  80125e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801262:	48 89 c7             	mov    %rax,%rdi
  801265:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  80126c:	00 00 00 
  80126f:	ff d0                	callq  *%rax
		}
		//cprintf("")
		uint32_t* indirect = (uint32_t*)diskaddr(f->f_indirect);
  801271:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801275:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80127b:	89 c0                	mov    %eax,%eax
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801287:	00 00 00 
  80128a:	ff d0                	callq  *%rax
  80128c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		uint32_t block = indirect[filebno - NDIRECT];
  801290:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801293:	83 e8 0a             	sub    $0xa,%eax
  801296:	89 c0                	mov    %eax,%eax
  801298:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80129f:	00 
  8012a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a4:	48 01 d0             	add    %rdx,%rax
  8012a7:	8b 00                	mov    (%rax),%eax
  8012a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if(block == 0){
  8012ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	0f 85 c3 00 00 00    	jne    80137a <file_block_walk+0x23c>
			if(!alloc) return -E_NOT_FOUND;
  8012b7:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
  8012bb:	83 f0 01             	xor    $0x1,%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	74 0a                	je     8012cc <file_block_walk+0x18e>
  8012c2:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8012c7:	e9 be 00 00 00       	jmpq   80138a <file_block_walk+0x24c>
			r = alloc_block();
  8012cc:	48 b8 a1 0e 80 00 00 	movabs $0x800ea1,%rax
  8012d3:	00 00 00 
  8012d6:	ff d0                	callq  *%rax
  8012d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
			if(r < 0){
  8012db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012df:	79 51                	jns    801332 <file_block_walk+0x1f4>
				if(need_alloc){
  8012e1:	80 7d fb 00          	cmpb   $0x0,-0x5(%rbp)
  8012e5:	74 46                	je     80132d <file_block_walk+0x1ef>
					free_block(f->f_indirect);
  8012e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012eb:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8012f1:	89 c7                	mov    %eax,%edi
  8012f3:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  8012fa:	00 00 00 
  8012fd:	ff d0                	callq  *%rax
					flush_block(diskaddr(1));
  8012ff:	bf 01 00 00 00       	mov    $0x1,%edi
  801304:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80130b:	00 00 00 
  80130e:	ff d0                	callq  *%rax
  801310:	48 89 c7             	mov    %rax,%rdi
  801313:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  80131a:	00 00 00 
  80131d:	ff d0                	callq  *%rax
					f->f_indirect = 0;
  80131f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801323:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  80132a:	00 00 00 
				}
				return r;
  80132d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801330:	eb 58                	jmp    80138a <file_block_walk+0x24c>
			}
			block = (uint32_t) r;
  801332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801335:	89 45 ec             	mov    %eax,-0x14(%rbp)
			indirect[filebno - NDIRECT] = block;
  801338:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80133b:	83 e8 0a             	sub    $0xa,%eax
  80133e:	89 c0                	mov    %eax,%eax
  801340:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801347:	00 
  801348:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134c:	48 01 c2             	add    %rax,%rdx
  80134f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801352:	89 02                	mov    %eax,(%rdx)
			flush_block(indirect);
  801354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801358:	48 89 c7             	mov    %rax,%rdi
  80135b:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801362:	00 00 00 
  801365:	ff d0                	callq  *%rax
			flush_block(f);
  801367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136b:	48 89 c7             	mov    %rax,%rdi
  80136e:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801375:	00 00 00 
  801378:	ff d0                	callq  *%rax
		}
 		*ppdiskbno = &block;
  80137a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80137e:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
  801382:	48 89 10             	mov    %rdx,(%rax)
	}
	return 0;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
  //panic("file_block_walk not implemented");
}
  80138a:	c9                   	leaveq 
  80138b:	c3                   	retq   

000000000080138c <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  80138c:	55                   	push   %rbp
  80138d:	48 89 e5             	mov    %rsp,%rbp
  801390:	48 83 ec 30          	sub    $0x30,%rsp
  801394:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801398:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80139b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	uint32_t *diskbno;
	int r = file_block_walk(f, filebno, &diskbno, 1);
  80139f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8013a3:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8013af:	48 89 c7             	mov    %rax,%rdi
  8013b2:	48 b8 3e 11 80 00 00 	movabs $0x80113e,%rax
  8013b9:	00 00 00 
  8013bc:	ff d0                	callq  *%rax
  8013be:	89 45 fc             	mov    %eax,-0x4(%rbp)
	//panic("file_block_walk not implemented");
	if(r < 0) return r;
  8013c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013c5:	79 05                	jns    8013cc <file_get_block+0x40>
  8013c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013ca:	eb 23                	jmp    8013ef <file_get_block+0x63>
	//if(!*diskbno) return -E_NO_DISK;
	*blk = diskaddr(*diskbno);
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	8b 00                	mov    (%rax),%eax
  8013d2:	89 c0                	mov    %eax,%eax
  8013d4:	48 89 c7             	mov    %rax,%rdi
  8013d7:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	callq  *%rax
  8013e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8013e7:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 83 ec 40          	sub    $0x40,%rsp
  8013f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801401:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80140f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 35                	je     80144d <dir_lookup+0x5c>
  801418:	48 b9 4b 6a 80 00 00 	movabs $0x806a4b,%rcx
  80141f:	00 00 00 
  801422:	48 ba 02 6a 80 00 00 	movabs $0x806a02,%rdx
  801429:	00 00 00 
  80142c:	be ea 00 00 00       	mov    $0xea,%esi
  801431:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  801438:	00 00 00 
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
  801440:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  801447:	00 00 00 
  80144a:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801457:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80145d:	85 c0                	test   %eax,%eax
  80145f:	0f 48 c2             	cmovs  %edx,%eax
  801462:	c1 f8 0c             	sar    $0xc,%eax
  801465:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80146f:	e9 93 00 00 00       	jmpq   801507 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801474:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801478:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	89 ce                	mov    %ecx,%esi
  801481:	48 89 c7             	mov    %rax,%rdi
  801484:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  80148b:	00 00 00 
  80148e:	ff d0                	callq  *%rax
  801490:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801493:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801497:	79 05                	jns    80149e <dir_lookup+0xad>
			return r;
  801499:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80149c:	eb 7a                	jmp    801518 <dir_lookup+0x127>
		f = (struct File*) blk;
  80149e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8014a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8014ad:	eb 4e                	jmp    8014fd <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  8014af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b2:	48 c1 e0 08          	shl    $0x8,%rax
  8014b6:	48 89 c2             	mov    %rax,%rdx
  8014b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bd:	48 01 d0             	add    %rdx,%rax
  8014c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8014c4:	48 89 d6             	mov    %rdx,%rsi
  8014c7:	48 89 c7             	mov    %rax,%rdi
  8014ca:	48 b8 7d 41 80 00 00 	movabs $0x80417d,%rax
  8014d1:	00 00 00 
  8014d4:	ff d0                	callq  *%rax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 1f                	jne    8014f9 <dir_lookup+0x108>
				*file = &f[j];
  8014da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014dd:	48 c1 e0 08          	shl    $0x8,%rax
  8014e1:	48 89 c2             	mov    %rax,%rdx
  8014e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e8:	48 01 c2             	add    %rax,%rdx
  8014eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014ef:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f7:	eb 1f                	jmp    801518 <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014f9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014fd:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801501:	76 ac                	jbe    8014af <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801503:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80150d:	0f 82 61 ff ff ff    	jb     801474 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801513:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  801518:	c9                   	leaveq 
  801519:	c3                   	retq   

000000000080151a <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  80151a:	55                   	push   %rbp
  80151b:	48 89 e5             	mov    %rsp,%rbp
  80151e:	48 83 ec 30          	sub    $0x30,%rsp
  801522:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801526:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801534:	25 ff 0f 00 00       	and    $0xfff,%eax
  801539:	85 c0                	test   %eax,%eax
  80153b:	74 35                	je     801572 <dir_alloc_file+0x58>
  80153d:	48 b9 4b 6a 80 00 00 	movabs $0x806a4b,%rcx
  801544:	00 00 00 
  801547:	48 ba 02 6a 80 00 00 	movabs $0x806a02,%rdx
  80154e:	00 00 00 
  801551:	be 03 01 00 00       	mov    $0x103,%esi
  801556:	48 bf 9e 69 80 00 00 	movabs $0x80699e,%rdi
  80155d:	00 00 00 
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80156c:	00 00 00 
  80156f:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80157c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801582:	85 c0                	test   %eax,%eax
  801584:	0f 48 c2             	cmovs  %edx,%eax
  801587:	c1 f8 0c             	sar    $0xc,%eax
  80158a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80158d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801594:	e9 83 00 00 00       	jmpq   80161c <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801599:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80159d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8015a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a4:	89 ce                	mov    %ecx,%esi
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8015b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015bc:	79 08                	jns    8015c6 <dir_alloc_file+0xac>
			return r;
  8015be:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015c1:	e9 be 00 00 00       	jmpq   801684 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  8015c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8015ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8015d5:	eb 3b                	jmp    801612 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8015d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015da:	48 c1 e0 08          	shl    $0x8,%rax
  8015de:	48 89 c2             	mov    %rax,%rdx
  8015e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e5:	48 01 d0             	add    %rdx,%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	84 c0                	test   %al,%al
  8015ed:	75 1f                	jne    80160e <dir_alloc_file+0xf4>
				*file = &f[j];
  8015ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015f2:	48 c1 e0 08          	shl    $0x8,%rax
  8015f6:	48 89 c2             	mov    %rax,%rdx
  8015f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fd:	48 01 c2             	add    %rax,%rdx
  801600:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801604:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
  80160c:	eb 76                	jmp    801684 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80160e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801612:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801616:	76 bf                	jbe    8015d7 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801618:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80161c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80161f:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801622:	0f 82 71 ff ff ff    	jb     801599 <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801632:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801642:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801646:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	89 ce                	mov    %ecx,%esi
  80164f:	48 89 c7             	mov    %rax,%rdi
  801652:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  801659:	00 00 00 
  80165c:	ff d0                	callq  *%rax
  80165e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801661:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801665:	79 05                	jns    80166c <dir_alloc_file+0x152>
		return r;
  801667:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80166a:	eb 18                	jmp    801684 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  80166c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801670:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801684:	c9                   	leaveq 
  801685:	c3                   	retq   

0000000000801686 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801686:	55                   	push   %rbp
  801687:	48 89 e5             	mov    %rsp,%rbp
  80168a:	48 83 ec 08          	sub    $0x8,%rsp
  80168e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801692:	eb 05                	jmp    801699 <skip_slash+0x13>
		p++;
  801694:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	3c 2f                	cmp    $0x2f,%al
  8016a2:	74 f0                	je     801694 <skip_slash+0xe>
		p++;
	return p;
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016a8:	c9                   	leaveq 
  8016a9:	c3                   	retq   

00000000008016aa <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8016aa:	55                   	push   %rbp
  8016ab:	48 89 e5             	mov    %rsp,%rbp
  8016ae:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8016b5:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  8016bc:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8016c3:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8016ca:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8016d1:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016d8:	48 89 c7             	mov    %rax,%rdi
  8016db:	48 b8 86 16 80 00 00 	movabs $0x801686,%rax
  8016e2:	00 00 00 
  8016e5:	ff d0                	callq  *%rax
  8016e7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8016ee:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8016f5:	00 00 00 
  8016f8:	48 8b 00             	mov    (%rax),%rax
  8016fb:	48 83 c0 08          	add    $0x8,%rax
  8016ff:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  801706:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80170d:	00 
	name[0] = 0;
  80170e:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  801715:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80171c:	00 
  80171d:	74 0e                	je     80172d <walk_path+0x83>
		*pdir = 0;
  80171f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801726:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  80172d:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801734:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  80173b:	e9 73 01 00 00       	jmpq   8018b3 <walk_path+0x209>
		dir = f;
  801740:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801747:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  80174b:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  801756:	eb 08                	jmp    801760 <walk_path+0xb6>
			path++;
  801758:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  80175f:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801760:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	3c 2f                	cmp    $0x2f,%al
  80176c:	74 0e                	je     80177c <walk_path+0xd2>
  80176e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801775:	0f b6 00             	movzbl (%rax),%eax
  801778:	84 c0                	test   %al,%al
  80177a:	75 dc                	jne    801758 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  80177c:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801783:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801787:	48 29 c2             	sub    %rax,%rdx
  80178a:	48 89 d0             	mov    %rdx,%rax
  80178d:	48 83 f8 7f          	cmp    $0x7f,%rax
  801791:	7e 0a                	jle    80179d <walk_path+0xf3>
			return -E_BAD_PATH;
  801793:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801798:	e9 56 01 00 00       	jmpq   8018f3 <walk_path+0x249>
		memmove(name, p, path - p);
  80179d:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8017a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a8:	48 29 c2             	sub    %rax,%rdx
  8017ab:	48 89 d0             	mov    %rdx,%rax
  8017ae:	48 89 c2             	mov    %rax,%rdx
  8017b1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017b5:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  8017bc:	48 89 ce             	mov    %rcx,%rsi
  8017bf:	48 89 c7             	mov    %rax,%rdi
  8017c2:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  8017c9:	00 00 00 
  8017cc:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8017ce:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8017d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d9:	48 29 c2             	sub    %rax,%rdx
  8017dc:	48 89 d0             	mov    %rdx,%rax
  8017df:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8017e6:	00 
		path = skip_slash(path);
  8017e7:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017ee:	48 89 c7             	mov    %rax,%rdi
  8017f1:	48 b8 86 16 80 00 00 	movabs $0x801686,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
  8017fd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  801804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801808:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  80180e:	83 f8 01             	cmp    $0x1,%eax
  801811:	74 0a                	je     80181d <walk_path+0x173>
			return -E_NOT_FOUND;
  801813:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801818:	e9 d6 00 00 00       	jmpq   8018f3 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  80181d:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801824:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  80182b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182f:	48 89 ce             	mov    %rcx,%rsi
  801832:	48 89 c7             	mov    %rax,%rdi
  801835:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  80183c:	00 00 00 
  80183f:	ff d0                	callq  *%rax
  801841:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801844:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801848:	79 69                	jns    8018b3 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  80184a:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  80184e:	75 5e                	jne    8018ae <walk_path+0x204>
  801850:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	84 c0                	test   %al,%al
  80185c:	75 50                	jne    8018ae <walk_path+0x204>
				if (pdir)
  80185e:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801865:	00 
  801866:	74 0e                	je     801876 <walk_path+0x1cc>
					*pdir = dir;
  801868:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80186f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801873:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801876:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  80187d:	00 
  80187e:	74 20                	je     8018a0 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801880:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801887:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  80188e:	48 89 d6             	mov    %rdx,%rsi
  801891:	48 89 c7             	mov    %rax,%rdi
  801894:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	callq  *%rax
				*pf = 0;
  8018a0:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8018a7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  8018ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b1:	eb 40                	jmp    8018f3 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8018b3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8018ba:	0f b6 00             	movzbl (%rax),%eax
  8018bd:	84 c0                	test   %al,%al
  8018bf:	0f 85 7b fe ff ff    	jne    801740 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8018c5:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8018cc:	00 
  8018cd:	74 0e                	je     8018dd <walk_path+0x233>
		*pdir = dir;
  8018cf:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8018d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018da:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8018dd:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8018e4:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8018eb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f3:	c9                   	leaveq 
  8018f4:	c3                   	retq   

00000000008018f5 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8018f5:	55                   	push   %rbp
  8018f6:	48 89 e5             	mov    %rsp,%rbp
  8018f9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801900:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801907:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  80190e:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801915:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80191c:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801923:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80192a:	48 89 c7             	mov    %rax,%rdi
  80192d:	48 b8 aa 16 80 00 00 	movabs $0x8016aa,%rax
  801934:	00 00 00 
  801937:	ff d0                	callq  *%rax
  801939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801940:	75 0a                	jne    80194c <file_create+0x57>
		return -E_FILE_EXISTS;
  801942:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801947:	e9 91 00 00 00       	jmpq   8019dd <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  80194c:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801950:	75 0c                	jne    80195e <file_create+0x69>
  801952:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801959:	48 85 c0             	test   %rax,%rax
  80195c:	75 05                	jne    801963 <file_create+0x6e>
		return r;
  80195e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801961:	eb 7a                	jmp    8019dd <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801963:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80196a:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801971:	48 89 d6             	mov    %rdx,%rsi
  801974:	48 89 c7             	mov    %rax,%rdi
  801977:	48 b8 1a 15 80 00 00 	movabs $0x80151a,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
  801983:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198a:	79 05                	jns    801991 <file_create+0x9c>
		return r;
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198f:	eb 4c                	jmp    8019dd <file_create+0xe8>
	strcpy(f->f_name, name);
  801991:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801998:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  80199f:	48 89 d6             	mov    %rdx,%rsi
  8019a2:	48 89 c7             	mov    %rax,%rdi
  8019a5:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  8019ac:	00 00 00 
  8019af:	ff d0                	callq  *%rax
	*pf = f;
  8019b1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8019b8:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8019bf:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  8019c2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8019c9:	48 89 c7             	mov    %rax,%rdi
  8019cc:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8019d3:	00 00 00 
  8019d6:	ff d0                	callq  *%rax
	return 0;
  8019d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019dd:	c9                   	leaveq 
  8019de:	c3                   	retq   

00000000008019df <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8019df:	55                   	push   %rbp
  8019e0:	48 89 e5             	mov    %rsp,%rbp
  8019e3:	48 83 ec 10          	sub    $0x10,%rsp
  8019e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8019ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 aa 16 80 00 00 	movabs $0x8016aa,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
}
  801a10:	c9                   	leaveq 
  801a11:	c3                   	retq   

0000000000801a12 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801a12:	55                   	push   %rbp
  801a13:	48 89 e5             	mov    %rsp,%rbp
  801a16:	48 83 ec 60          	sub    $0x60,%rsp
  801a1a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801a1e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801a22:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801a26:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801a29:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a2d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a33:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801a36:	7f 0a                	jg     801a42 <file_read+0x30>
		return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3d:	e9 24 01 00 00       	jmpq   801b66 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  801a42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801a4a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a4e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a54:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801a57:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a5d:	48 63 d0             	movslq %eax,%rdx
  801a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a64:	48 39 c2             	cmp    %rax,%rdx
  801a67:	48 0f 46 c2          	cmovbe %rdx,%rax
  801a6b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801a6f:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801a72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a75:	e9 cd 00 00 00       	jmpq   801b47 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a83:	85 c0                	test   %eax,%eax
  801a85:	0f 48 c2             	cmovs  %edx,%eax
  801a88:	c1 f8 0c             	sar    $0xc,%eax
  801a8b:	89 c1                	mov    %eax,%ecx
  801a8d:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801a91:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a95:	89 ce                	mov    %ecx,%esi
  801a97:	48 89 c7             	mov    %rax,%rdi
  801a9a:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	callq  *%rax
  801aa6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801aa9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801aad:	79 08                	jns    801ab7 <file_read+0xa5>
			return r;
  801aaf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ab2:	e9 af 00 00 00       	jmpq   801b66 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	99                   	cltd   
  801abb:	c1 ea 14             	shr    $0x14,%edx
  801abe:	01 d0                	add    %edx,%eax
  801ac0:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ac5:	29 d0                	sub    %edx,%eax
  801ac7:	ba 00 10 00 00       	mov    $0x1000,%edx
  801acc:	29 c2                	sub    %eax,%edx
  801ace:	89 d0                	mov    %edx,%eax
  801ad0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801ad3:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801ad6:	48 63 d0             	movslq %eax,%rdx
  801ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801add:	48 01 c2             	add    %rax,%rdx
  801ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae3:	48 98                	cltq   
  801ae5:	48 29 c2             	sub    %rax,%rdx
  801ae8:	48 89 d0             	mov    %rdx,%rax
  801aeb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801aef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801af2:	48 63 d0             	movslq %eax,%rdx
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	48 39 c2             	cmp    %rax,%rdx
  801afc:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b00:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801b03:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b06:	48 63 c8             	movslq %eax,%rcx
  801b09:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801b0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b10:	99                   	cltd   
  801b11:	c1 ea 14             	shr    $0x14,%edx
  801b14:	01 d0                	add    %edx,%eax
  801b16:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b1b:	29 d0                	sub    %edx,%eax
  801b1d:	48 98                	cltq   
  801b1f:	48 01 c6             	add    %rax,%rsi
  801b22:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801b26:	48 89 ca             	mov    %rcx,%rdx
  801b29:	48 89 c7             	mov    %rax,%rdi
  801b2c:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  801b33:	00 00 00 
  801b36:	ff d0                	callq  *%rax
		pos += bn;
  801b38:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b3b:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b3e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b41:	48 98                	cltq   
  801b43:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4a:	48 98                	cltq   
  801b4c:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801b4f:	48 63 ca             	movslq %edx,%rcx
  801b52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801b56:	48 01 ca             	add    %rcx,%rdx
  801b59:	48 39 d0             	cmp    %rdx,%rax
  801b5c:	0f 82 18 ff ff ff    	jb     801a7a <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 50          	sub    $0x50,%rsp
  801b70:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801b74:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801b78:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801b7c:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801b7f:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b82:	48 63 d0             	movslq %eax,%rdx
  801b85:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b89:	48 01 c2             	add    %rax,%rdx
  801b8c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b90:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b96:	48 98                	cltq   
  801b98:	48 39 c2             	cmp    %rax,%rdx
  801b9b:	76 33                	jbe    801bd0 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801b9d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801ba1:	89 c2                	mov    %eax,%edx
  801ba3:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bae:	89 d6                	mov    %edx,%esi
  801bb0:	48 89 c7             	mov    %rax,%rdi
  801bb3:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	callq  *%rax
  801bbf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801bc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801bc6:	79 08                	jns    801bd0 <file_write+0x68>
			return r;
  801bc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcb:	e9 f8 00 00 00       	jmpq   801cc8 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801bd0:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801bd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bd6:	e9 ce 00 00 00       	jmpq   801ca9 <file_write+0x141>
		//cprintf("pos = %d\n", pos);
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bde:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801be4:	85 c0                	test   %eax,%eax
  801be6:	0f 48 c2             	cmovs  %edx,%eax
  801be9:	c1 f8 0c             	sar    $0xc,%eax
  801bec:	89 c1                	mov    %eax,%ecx
  801bee:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801bf2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801bf6:	89 ce                	mov    %ecx,%esi
  801bf8:	48 89 c7             	mov    %rax,%rdi
  801bfb:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  801c02:	00 00 00 
  801c05:	ff d0                	callq  *%rax
  801c07:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c0e:	79 08                	jns    801c18 <file_write+0xb0>
			return r;
  801c10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c13:	e9 b0 00 00 00       	jmpq   801cc8 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1b:	99                   	cltd   
  801c1c:	c1 ea 14             	shr    $0x14,%edx
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c26:	29 d0                	sub    %edx,%eax
  801c28:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c2d:	29 c2                	sub    %eax,%edx
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801c34:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801c37:	48 63 d0             	movslq %eax,%rdx
  801c3a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c3e:	48 01 c2             	add    %rax,%rdx
  801c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c44:	48 98                	cltq   
  801c46:	48 29 c2             	sub    %rax,%rdx
  801c49:	48 89 d0             	mov    %rdx,%rax
  801c4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c50:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c53:	48 63 d0             	movslq %eax,%rdx
  801c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5a:	48 39 c2             	cmp    %rax,%rdx
  801c5d:	48 0f 46 c2          	cmovbe %rdx,%rax
  801c61:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801c64:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c67:	48 63 c8             	movslq %eax,%rcx
  801c6a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c71:	99                   	cltd   
  801c72:	c1 ea 14             	shr    $0x14,%edx
  801c75:	01 d0                	add    %edx,%eax
  801c77:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c7c:	29 d0                	sub    %edx,%eax
  801c7e:	48 98                	cltq   
  801c80:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801c84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c88:	48 89 ca             	mov    %rcx,%rdx
  801c8b:	48 89 c6             	mov    %rax,%rsi
  801c8e:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
		pos += bn;
  801c9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c9d:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801ca0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ca3:	48 98                	cltq   
  801ca5:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cac:	48 98                	cltq   
  801cae:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801cb1:	48 63 ca             	movslq %edx,%rcx
  801cb4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801cb8:	48 01 ca             	add    %rcx,%rdx
  801cbb:	48 39 d0             	cmp    %rdx,%rax
  801cbe:	0f 82 17 ff ff ff    	jb     801bdb <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801cc4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 83 ec 20          	sub    $0x20,%rsp
  801cd2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cd6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801cd9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cdd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce9:	48 89 c7             	mov    %rax,%rdi
  801cec:	48 b8 3e 11 80 00 00 	movabs $0x80113e,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax
  801cf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cff:	79 05                	jns    801d06 <file_free_block+0x3c>
		return r;
  801d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d04:	eb 2d                	jmp    801d33 <file_free_block+0x69>
	if (*ptr) {
  801d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0a:	8b 00                	mov    (%rax),%eax
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	74 1e                	je     801d2e <file_free_block+0x64>
		free_block(*ptr);
  801d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d14:	8b 00                	mov    (%rax),%eax
  801d16:	89 c7                	mov    %eax,%edi
  801d18:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	callq  *%rax
		*ptr = 0;
  801d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d28:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d33:	c9                   	leaveq 
  801d34:	c3                   	retq   

0000000000801d35 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801d35:	55                   	push   %rbp
  801d36:	48 89 e5             	mov    %rsp,%rbp
  801d39:	48 83 ec 20          	sub    $0x20,%rsp
  801d3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d41:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d48:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d4e:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d53:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	0f 48 c2             	cmovs  %edx,%eax
  801d5e:	c1 f8 0c             	sar    $0xc,%eax
  801d61:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801d64:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d67:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d6c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d72:	85 c0                	test   %eax,%eax
  801d74:	0f 48 c2             	cmovs  %edx,%eax
  801d77:	c1 f8 0c             	sar    $0xc,%eax
  801d7a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801d7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d83:	eb 45                	jmp    801dca <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801d85:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8c:	89 d6                	mov    %edx,%esi
  801d8e:	48 89 c7             	mov    %rax,%rdi
  801d91:	48 b8 ca 1c 80 00 00 	movabs $0x801cca,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
  801d9d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801da0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801da4:	79 20                	jns    801dc6 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801da6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801da9:	89 c6                	mov    %eax,%esi
  801dab:	48 bf 68 6a 80 00 00 	movabs $0x806a68,%rdi
  801db2:	00 00 00 
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  801dc1:	00 00 00 
  801dc4:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801dc6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcd:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801dd0:	72 b3                	jb     801d85 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801dd2:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801dd6:	77 34                	ja     801e0c <file_truncate_blocks+0xd7>
  801dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddc:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	74 26                	je     801e0c <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dea:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801df0:	89 c7                	mov    %eax,%edi
  801df2:	48 b8 1a 0e 80 00 00 	movabs $0x800e1a,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801dfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e02:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801e09:	00 00 00 
	}
}
  801e0c:	c9                   	leaveq 
  801e0d:	c3                   	retq   

0000000000801e0e <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801e0e:	55                   	push   %rbp
  801e0f:	48 89 e5             	mov    %rsp,%rbp
  801e12:	48 83 ec 10          	sub    $0x10,%rsp
  801e16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e1a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801e1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e21:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801e27:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801e2a:	7e 18                	jle    801e44 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801e2c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e33:	89 d6                	mov    %edx,%esi
  801e35:	48 89 c7             	mov    %rax,%rdi
  801e38:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  801e3f:	00 00 00 
  801e42:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e48:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e4b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801e51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e55:	48 89 c7             	mov    %rax,%rdi
  801e58:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
	return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 20          	sub    $0x20,%rsp
  801e73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801e77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e7e:	eb 62                	jmp    801ee2 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801e80:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e83:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e90:	48 89 c7             	mov    %rax,%rdi
  801e93:	48 b8 3e 11 80 00 00 	movabs $0x80113e,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	callq  *%rax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 13                	js     801eb6 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801ea7:	48 85 c0             	test   %rax,%rax
  801eaa:	74 0a                	je     801eb6 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb0:	8b 00                	mov    (%rax),%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	75 02                	jne    801eb8 <file_flush+0x4d>
			continue;
  801eb6:	eb 26                	jmp    801ede <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801eb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ebc:	8b 00                	mov    (%rax),%eax
  801ebe:	89 c0                	mov    %eax,%eax
  801ec0:	48 89 c7             	mov    %rax,%rdi
  801ec3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801eca:	00 00 00 
  801ecd:	ff d0                	callq  *%rax
  801ecf:	48 89 c7             	mov    %rax,%rdi
  801ed2:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801ed9:	00 00 00 
  801edc:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ede:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee6:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801eec:	05 ff 0f 00 00       	add    $0xfff,%eax
  801ef1:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	0f 48 c2             	cmovs  %edx,%eax
  801efc:	c1 f8 0c             	sar    $0xc,%eax
  801eff:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801f02:	0f 8f 78 ff ff ff    	jg     801e80 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0c:	48 89 c7             	mov    %rax,%rdi
  801f0f:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801f16:	00 00 00 
  801f19:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1f:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f25:	85 c0                	test   %eax,%eax
  801f27:	74 2a                	je     801f53 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801f29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2d:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801f33:	89 c0                	mov    %eax,%eax
  801f35:	48 89 c7             	mov    %rax,%rdi
  801f38:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	callq  *%rax
  801f44:	48 89 c7             	mov    %rax,%rdi
  801f47:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax
}
  801f53:	c9                   	leaveq 
  801f54:	c3                   	retq   

0000000000801f55 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801f55:	55                   	push   %rbp
  801f56:	48 89 e5             	mov    %rsp,%rbp
  801f59:	48 83 ec 20          	sub    $0x20,%rsp
  801f5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801f61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6e:	be 00 00 00 00       	mov    $0x0,%esi
  801f73:	48 89 c7             	mov    %rax,%rdi
  801f76:	48 b8 aa 16 80 00 00 	movabs $0x8016aa,%rax
  801f7d:	00 00 00 
  801f80:	ff d0                	callq  *%rax
  801f82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f89:	79 05                	jns    801f90 <file_remove+0x3b>
		return r;
  801f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8e:	eb 45                	jmp    801fd5 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801f90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f94:	be 00 00 00 00       	mov    $0x0,%esi
  801f99:	48 89 c7             	mov    %rax,%rdi
  801f9c:	48 b8 35 1d 80 00 00 	movabs $0x801d35,%rax
  801fa3:	00 00 00 
  801fa6:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fac:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801fba:	00 00 00 
	flush_block(f);
  801fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc1:	48 89 c7             	mov    %rax,%rdi
  801fc4:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  801fcb:	00 00 00 
  801fce:	ff d0                	callq  *%rax

	return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd5:	c9                   	leaveq 
  801fd6:	c3                   	retq   

0000000000801fd7 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801fd7:	55                   	push   %rbp
  801fd8:	48 89 e5             	mov    %rsp,%rbp
  801fdb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801fdf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801fe6:	eb 27                	jmp    80200f <fs_sync+0x38>
		flush_block(diskaddr(i));
  801fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801feb:	48 98                	cltq   
  801fed:	48 89 c7             	mov    %rax,%rdi
  801ff0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
  801ffc:	48 89 c7             	mov    %rax,%rdi
  801fff:	48 b8 7e 08 80 00 00 	movabs $0x80087e,%rax
  802006:	00 00 00 
  802009:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80200b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80200f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802012:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  802019:	00 00 00 
  80201c:	48 8b 00             	mov    (%rax),%rax
  80201f:	8b 40 04             	mov    0x4(%rax),%eax
  802022:	39 c2                	cmp    %eax,%edx
  802024:	72 c2                	jb     801fe8 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  802026:	c9                   	leaveq 
  802027:	c3                   	retq   

0000000000802028 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  802028:	55                   	push   %rbp
  802029:	48 89 e5             	mov    %rsp,%rbp
  80202c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  802030:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  802035:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  802039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802040:	eb 4b                	jmp    80208d <serve_init+0x65>
		opentab[i].o_fileid = i;
  802042:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802045:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  80204c:	00 00 00 
  80204f:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802052:	48 63 c9             	movslq %ecx,%rcx
  802055:	48 c1 e1 05          	shl    $0x5,%rcx
  802059:	48 01 ca             	add    %rcx,%rdx
  80205c:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  80205e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802062:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  802069:	00 00 00 
  80206c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80206f:	48 63 c9             	movslq %ecx,%rcx
  802072:	48 c1 e1 05          	shl    $0x5,%rcx
  802076:	48 01 ca             	add    %rcx,%rdx
  802079:	48 83 c2 10          	add    $0x10,%rdx
  80207d:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  802081:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  802088:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  802089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80208d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802094:	7e ac                	jle    802042 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  802096:	c9                   	leaveq 
  802097:	c3                   	retq   

0000000000802098 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
  80209c:	48 83 ec 20          	sub    $0x20,%rsp
  8020a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8020a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ab:	e9 24 01 00 00       	jmpq   8021d4 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  8020b0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020b7:	00 00 00 
  8020ba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020bd:	48 63 d2             	movslq %edx,%rdx
  8020c0:	48 c1 e2 05          	shl    $0x5,%rdx
  8020c4:	48 01 d0             	add    %rdx,%rax
  8020c7:	48 83 c0 10          	add    $0x10,%rax
  8020cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020cf:	48 89 c7             	mov    %rax,%rdi
  8020d2:	48 b8 0c 5e 80 00 00 	movabs $0x805e0c,%rax
  8020d9:	00 00 00 
  8020dc:	ff d0                	callq  *%rax
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 0a                	je     8020ec <openfile_alloc+0x54>
  8020e2:	83 f8 01             	cmp    $0x1,%eax
  8020e5:	74 4e                	je     802135 <openfile_alloc+0x9d>
  8020e7:	e9 e4 00 00 00       	jmpq   8021d0 <openfile_alloc+0x138>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8020ec:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020f3:	00 00 00 
  8020f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f9:	48 63 d2             	movslq %edx,%rdx
  8020fc:	48 c1 e2 05          	shl    $0x5,%rdx
  802100:	48 01 d0             	add    %rdx,%rax
  802103:	48 83 c0 10          	add    $0x10,%rax
  802107:	48 8b 40 08          	mov    0x8(%rax),%rax
  80210b:	ba 07 00 00 00       	mov    $0x7,%edx
  802110:	48 89 c6             	mov    %rax,%rsi
  802113:	bf 00 00 00 00       	mov    $0x0,%edi
  802118:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
  802124:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802127:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80212b:	79 08                	jns    802135 <openfile_alloc+0x9d>
				return r;
  80212d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802130:	e9 b1 00 00 00       	jmpq   8021e6 <openfile_alloc+0x14e>
			/* fall through */
		case 1:

			opentab[i].o_fileid += MAXOPEN;
  802135:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80213c:	00 00 00 
  80213f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802142:	48 63 d2             	movslq %edx,%rdx
  802145:	48 c1 e2 05          	shl    $0x5,%rdx
  802149:	48 01 d0             	add    %rdx,%rax
  80214c:	8b 00                	mov    (%rax),%eax
  80214e:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802154:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80215b:	00 00 00 
  80215e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802161:	48 63 c9             	movslq %ecx,%rcx
  802164:	48 c1 e1 05          	shl    $0x5,%rcx
  802168:	48 01 c8             	add    %rcx,%rax
  80216b:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802170:	48 98                	cltq   
  802172:	48 c1 e0 05          	shl    $0x5,%rax
  802176:	48 89 c2             	mov    %rax,%rdx
  802179:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802180:	00 00 00 
  802183:	48 01 c2             	add    %rax,%rdx
  802186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218a:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80218d:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802194:	00 00 00 
  802197:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80219a:	48 63 d2             	movslq %edx,%rdx
  80219d:	48 c1 e2 05          	shl    $0x5,%rdx
  8021a1:	48 01 d0             	add    %rdx,%rax
  8021a4:	48 83 c0 10          	add    $0x10,%rax
  8021a8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ac:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021b1:	be 00 00 00 00       	mov    $0x0,%esi
  8021b6:	48 89 c7             	mov    %rax,%rdi
  8021b9:	48 b8 b4 42 80 00 00 	movabs $0x8042b4,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	48 8b 00             	mov    (%rax),%rax
  8021cc:	8b 00                	mov    (%rax),%eax
  8021ce:	eb 16                	jmp    8021e6 <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8021d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021d4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8021db:	0f 8e cf fe ff ff    	jle    8020b0 <openfile_alloc+0x18>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
	         }
        }
	return -E_MAX_OPEN;
  8021e1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
  8021ec:	48 83 ec 20          	sub    $0x20,%rsp
  8021f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021f6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8021fa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  802202:	89 c0                	mov    %eax,%eax
  802204:	48 c1 e0 05          	shl    $0x5,%rax
  802208:	48 89 c2             	mov    %rax,%rdx
  80220b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802212:	00 00 00 
  802215:	48 01 d0             	add    %rdx,%rax
  802218:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80221c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802220:	48 8b 40 18          	mov    0x18(%rax),%rax
  802224:	48 89 c7             	mov    %rax,%rdi
  802227:	48 b8 0c 5e 80 00 00 	movabs $0x805e0c,%rax
  80222e:	00 00 00 
  802231:	ff d0                	callq  *%rax
  802233:	83 f8 01             	cmp    $0x1,%eax
  802236:	74 0b                	je     802243 <openfile_lookup+0x5b>
  802238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223c:	8b 00                	mov    (%rax),%eax
  80223e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802241:	74 07                	je     80224a <openfile_lookup+0x62>
		return -E_INVAL;
  802243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802248:	eb 10                	jmp    80225a <openfile_lookup+0x72>
	*po = o;
  80224a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802252:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225a:	c9                   	leaveq 
  80225b:	c3                   	retq   

000000000080225c <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80225c:	55                   	push   %rbp
  80225d:	48 89 e5             	mov    %rsp,%rbp
  802260:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  802267:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  80226d:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802274:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  80227b:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802282:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  802289:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802290:	ba 00 04 00 00       	mov    $0x400,%edx
  802295:	48 89 ce             	mov    %rcx,%rsi
  802298:	48 89 c7             	mov    %rax,%rdi
  80229b:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8022a7:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8022ab:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8022b2:	48 89 c7             	mov    %rax,%rdi
  8022b5:	48 b8 98 20 80 00 00 	movabs $0x802098,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
  8022c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c8:	79 08                	jns    8022d2 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  8022ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cd:	e9 7c 01 00 00       	jmpq   80244e <serve_open+0x1f2>
	}
	fileid = r;
  8022d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d5:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  8022d8:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022df:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022e5:	25 00 01 00 00       	and    $0x100,%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 4f                	je     80233d <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  8022ee:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8022f5:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8022fc:	48 89 d6             	mov    %rdx,%rsi
  8022ff:	48 89 c7             	mov    %rax,%rdi
  802302:	48 b8 f5 18 80 00 00 	movabs $0x8018f5,%rax
  802309:	00 00 00 
  80230c:	ff d0                	callq  *%rax
  80230e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802315:	79 57                	jns    80236e <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  802317:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80231e:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802324:	25 00 04 00 00       	and    $0x400,%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	75 08                	jne    802335 <serve_open+0xd9>
  80232d:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  802331:	75 02                	jne    802335 <serve_open+0xd9>
				goto try_open;
  802333:	eb 08                	jmp    80233d <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  802335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802338:	e9 11 01 00 00       	jmpq   80244e <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80233d:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802344:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80234b:	48 89 d6             	mov    %rdx,%rsi
  80234e:	48 89 c7             	mov    %rax,%rdi
  802351:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  802358:	00 00 00 
  80235b:	ff d0                	callq  *%rax
  80235d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802360:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802364:	79 08                	jns    80236e <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  802366:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802369:	e9 e0 00 00 00       	jmpq   80244e <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80236e:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802375:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80237b:	25 00 02 00 00       	and    $0x200,%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	74 2c                	je     8023b0 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802384:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80238b:	be 00 00 00 00       	mov    $0x0,%esi
  802390:	48 89 c7             	mov    %rax,%rdi
  802393:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	callq  *%rax
  80239f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a6:	79 08                	jns    8023b0 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8023a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ab:	e9 9e 00 00 00       	jmpq   80244e <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  8023b0:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023b7:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  8023be:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8023c2:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023c9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023cd:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  8023d4:	8b 12                	mov    (%rdx),%edx
  8023d6:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8023d9:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023e0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023e4:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8023eb:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023f1:	83 e2 03             	and    $0x3,%edx
  8023f4:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8023f7:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023fe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802402:	48 ba c0 10 81 00 00 	movabs $0x8110c0,%rdx
  802409:	00 00 00 
  80240c:	8b 12                	mov    (%rdx),%edx
  80240e:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802410:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802417:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80241e:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802424:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  802427:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80242e:	48 8b 50 18          	mov    0x18(%rax),%rdx
  802432:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  802439:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  80243c:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802443:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244e:	c9                   	leaveq 
  80244f:	c3                   	retq   

0000000000802450 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802450:	55                   	push   %rbp
  802451:	48 89 e5             	mov    %rsp,%rbp
  802454:	48 83 ec 20          	sub    $0x20,%rsp
  802458:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80245f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802463:	8b 00                	mov    (%rax),%eax
  802465:	89 c1                	mov    %eax,%ecx
  802467:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246e:	89 ce                	mov    %ecx,%esi
  802470:	89 c7                	mov    %eax,%edi
  802472:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  802479:	00 00 00 
  80247c:	ff d0                	callq  *%rax
  80247e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802481:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802485:	79 05                	jns    80248c <serve_set_size+0x3c>
		return r;
  802487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248a:	eb 20                	jmp    8024ac <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80248c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802490:	8b 50 04             	mov    0x4(%rax),%edx
  802493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802497:	48 8b 40 08          	mov    0x8(%rax),%rax
  80249b:	89 d6                	mov    %edx,%esi
  80249d:	48 89 c7             	mov    %rax,%rdi
  8024a0:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
}
  8024ac:	c9                   	leaveq 
  8024ad:	c3                   	retq   

00000000008024ae <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8024ae:	55                   	push   %rbp
  8024af:	48 89 e5             	mov    %rsp,%rbp
  8024b2:	48 83 ec 40          	sub    $0x40,%rsp
  8024b6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024b9:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  8024bd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  8024c5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct OpenFile *o;
	int r;
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8024cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d1:	8b 00                	mov    (%rax),%eax
  8024d3:	89 c1                	mov    %eax,%ecx
  8024d5:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8024d9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024dc:	89 ce                	mov    %ecx,%esi
  8024de:	89 c7                	mov    %eax,%edi
  8024e0:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024f3:	79 05                	jns    8024fa <serve_read+0x4c>
		return r;
  8024f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f8:	eb 78                	jmp    802572 <serve_read+0xc4>
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	size_t count = req->req_n;
  8024fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fe:	48 8b 40 08          	mov    0x8(%rax),%rax
  802502:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	count = count > PGSIZE ? PGSIZE : count;
  802506:	b8 00 10 00 00       	mov    $0x1000,%eax
  80250b:	48 81 7d e0 00 10 00 	cmpq   $0x1000,-0x20(%rbp)
  802512:	00 
  802513:	48 0f 46 45 e0       	cmovbe -0x20(%rbp),%rax
  802518:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	ssize_t nret = file_read(o->o_file, ret->ret_buf, count, o->o_fd->fd_offset);
  80251c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802520:	48 8b 40 18          	mov    0x18(%rax),%rax
  802524:	8b 48 04             	mov    0x4(%rax),%ecx
  802527:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80252b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80252f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802533:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802537:	48 89 c7             	mov    %rax,%rdi
  80253a:	48 b8 12 1a 80 00 00 	movabs $0x801a12,%rax
  802541:	00 00 00 
  802544:	ff d0                	callq  *%rax
  802546:	89 45 dc             	mov    %eax,-0x24(%rbp)
	if(nret < 0) return nret;
  802549:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80254d:	79 05                	jns    802554 <serve_read+0xa6>
  80254f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802552:	eb 1e                	jmp    802572 <serve_read+0xc4>
	o->o_fd->fd_offset += nret;
  802554:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802558:	48 8b 40 18          	mov    0x18(%rax),%rax
  80255c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802560:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802564:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802567:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80256a:	01 ca                	add    %ecx,%edx
  80256c:	89 50 04             	mov    %edx,0x4(%rax)
	return nret;
  80256f:	8b 45 dc             	mov    -0x24(%rbp),%eax

	//panic("serve_read not implemented");
}
  802572:	c9                   	leaveq 
  802573:	c3                   	retq   

0000000000802574 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  802574:	55                   	push   %rbp
  802575:	48 89 e5             	mov    %rsp,%rbp
  802578:	48 83 ec 20          	sub    $0x20,%rsp
  80257c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80257f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	struct OpenFile *o;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802583:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802587:	8b 00                	mov    (%rax),%eax
  802589:	89 c1                	mov    %eax,%ecx
  80258b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80258f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802592:	89 ce                	mov    %ecx,%esi
  802594:	89 c7                	mov    %eax,%edi
  802596:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  80259d:	00 00 00 
  8025a0:	ff d0                	callq  *%rax
  8025a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a9:	79 05                	jns    8025b0 <serve_write+0x3c>
		return r;
  8025ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ae:	eb 5e                	jmp    80260e <serve_write+0x9a>
	// LAB 5: Your code here.
	ssize_t nret = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset);
  8025b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025b8:	8b 48 04             	mov    0x4(%rax),%ecx
  8025bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8025c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c7:	48 8d 70 10          	lea    0x10(%rax),%rsi
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025d3:	48 89 c7             	mov    %rax,%rdi
  8025d6:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
  8025e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if(nret < 0) return nret;
  8025e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025e9:	79 05                	jns    8025f0 <serve_write+0x7c>
  8025eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025ee:	eb 1e                	jmp    80260e <serve_write+0x9a>
	o->o_fd->fd_offset += nret;
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025fc:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802600:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802603:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802606:	01 ca                	add    %ecx,%edx
  802608:	89 50 04             	mov    %edx,0x4(%rax)
	return nret;
  80260b:	8b 45 f8             	mov    -0x8(%rbp),%eax
	//panic("serve_write not implemented");
}
  80260e:	c9                   	leaveq 
  80260f:	c3                   	retq   

0000000000802610 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  802610:	55                   	push   %rbp
  802611:	48 89 e5             	mov    %rsp,%rbp
  802614:	48 83 ec 30          	sub    $0x30,%rsp
  802618:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80261b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  80261f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802623:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  802627:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80262f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802633:	8b 00                	mov    (%rax),%eax
  802635:	89 c1                	mov    %eax,%ecx
  802637:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80263b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80263e:	89 ce                	mov    %ecx,%esi
  802640:	89 c7                	mov    %eax,%edi
  802642:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
  80264e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802651:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802655:	79 05                	jns    80265c <serve_stat+0x4c>
		return r;
  802657:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80265a:	eb 5f                	jmp    8026bb <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  80265c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802660:	48 8b 40 08          	mov    0x8(%rax),%rax
  802664:	48 89 c2             	mov    %rax,%rdx
  802667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266b:	48 89 d6             	mov    %rdx,%rsi
  80266e:	48 89 c7             	mov    %rax,%rdi
  802671:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  802678:	00 00 00 
  80267b:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  80267d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802681:	48 8b 40 08          	mov    0x8(%rax),%rax
  802685:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80268b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  802695:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802699:	48 8b 40 08          	mov    0x8(%rax),%rax
  80269d:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8026a3:	83 f8 01             	cmp    $0x1,%eax
  8026a6:	0f 94 c0             	sete   %al
  8026a9:	0f b6 d0             	movzbl %al,%edx
  8026ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bb:	c9                   	leaveq 
  8026bc:	c3                   	retq   

00000000008026bd <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8026bd:	55                   	push   %rbp
  8026be:	48 89 e5             	mov    %rsp,%rbp
  8026c1:	48 83 ec 20          	sub    $0x20,%rsp
  8026c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	8b 00                	mov    (%rax),%eax
  8026d2:	89 c1                	mov    %eax,%ecx
  8026d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026db:	89 ce                	mov    %ecx,%esi
  8026dd:	89 c7                	mov    %eax,%edi
  8026df:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  8026e6:	00 00 00 
  8026e9:	ff d0                	callq  *%rax
  8026eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f2:	79 05                	jns    8026f9 <serve_flush+0x3c>
		return r;
  8026f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f7:	eb 1c                	jmp    802715 <serve_flush+0x58>
	file_flush(o->o_file);
  8026f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fd:	48 8b 40 08          	mov    0x8(%rax),%rax
  802701:	48 89 c7             	mov    %rax,%rdi
  802704:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
	return 0;
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802715:	c9                   	leaveq 
  802716:	c3                   	retq   

0000000000802717 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  802717:	55                   	push   %rbp
  802718:	48 89 e5             	mov    %rsp,%rbp
  80271b:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  802722:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  802728:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80272f:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802736:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  80273d:	ba 00 04 00 00       	mov    $0x400,%edx
  802742:	48 89 ce             	mov    %rcx,%rsi
  802745:	48 89 c7             	mov    %rax,%rdi
  802748:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802754:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802758:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  80275f:	48 89 c7             	mov    %rax,%rdi
  802762:	48 b8 55 1f 80 00 00 	movabs $0x801f55,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
}
  80276e:	c9                   	leaveq 
  80276f:	c3                   	retq   

0000000000802770 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802770:	55                   	push   %rbp
  802771:	48 89 e5             	mov    %rsp,%rbp
  802774:	48 83 ec 10          	sub    $0x10,%rsp
  802778:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80277b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  80277f:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
	return 0;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802790:	c9                   	leaveq 
  802791:	c3                   	retq   

0000000000802792 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  802792:	55                   	push   %rbp
  802793:	48 89 e5             	mov    %rsp,%rbp
  802796:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  80279a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8027a1:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8027a8:	00 00 00 
  8027ab:	48 8b 08             	mov    (%rax),%rcx
  8027ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027b2:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8027b6:	48 89 ce             	mov    %rcx,%rsi
  8027b9:	48 89 c7             	mov    %rax,%rdi
  8027bc:	48 b8 d6 4c 80 00 00 	movabs $0x804cd6,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	callq  *%rax
  8027c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8027cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027ce:	83 e0 01             	and    $0x1,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	75 23                	jne    8027f8 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  8027d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027d8:	89 c6                	mov    %eax,%esi
  8027da:	48 bf 88 6a 80 00 00 	movabs $0x806a88,%rdi
  8027e1:	00 00 00 
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e9:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  8027f0:	00 00 00 
  8027f3:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  8027f5:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  8027f6:	eb a2                	jmp    80279a <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8027f8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027ff:	00 
		if (req == FSREQ_OPEN) {
  802800:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  802804:	75 2b                	jne    802831 <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  802806:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80280d:	00 00 00 
  802810:	48 8b 30             	mov    (%rax),%rsi
  802813:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802816:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  80281a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80281e:	89 c7                	mov    %eax,%edi
  802820:	48 b8 5c 22 80 00 00 	movabs $0x80225c,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
  80282c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282f:	eb 73                	jmp    8028a4 <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  802831:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  802835:	77 43                	ja     80287a <serve+0xe8>
  802837:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  80283e:	00 00 00 
  802841:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802848:	48 85 c0             	test   %rax,%rax
  80284b:	74 2d                	je     80287a <serve+0xe8>
			r = handlers[req](whom, fsreq);
  80284d:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802854:	00 00 00 
  802857:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80285a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80285e:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  802865:	00 00 00 
  802868:	48 8b 0a             	mov    (%rdx),%rcx
  80286b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80286e:	48 89 ce             	mov    %rcx,%rsi
  802871:	89 d7                	mov    %edx,%edi
  802873:	ff d0                	callq  *%rax
  802875:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802878:	eb 2a                	jmp    8028a4 <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80287a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80287d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802880:	89 c6                	mov    %eax,%esi
  802882:	48 bf b8 6a 80 00 00 	movabs $0x806ab8,%rdi
  802889:	00 00 00 
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	48 b9 66 34 80 00 00 	movabs $0x803466,%rcx
  802898:	00 00 00 
  80289b:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  80289d:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  8028a4:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8028a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ab:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028b1:	89 c7                	mov    %eax,%edi
  8028b3:	48 b8 9c 4d 80 00 00 	movabs $0x804d9c,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  8028bf:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8028c6:	00 00 00 
  8028c9:	48 8b 00             	mov    (%rax),%rax
  8028cc:	48 89 c6             	mov    %rax,%rsi
  8028cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d4:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
	}
  8028e0:	e9 b5 fe ff ff       	jmpq   80279a <serve+0x8>

00000000008028e5 <umain>:
}

void
umain(int argc, char **argv)
{
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 20          	sub    $0x20,%rsp
  8028ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8028f4:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8028fb:	00 00 00 
  8028fe:	48 b9 db 6a 80 00 00 	movabs $0x806adb,%rcx
  802905:	00 00 00 
  802908:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  80290b:	48 bf de 6a 80 00 00 	movabs $0x806ade,%rdi
  802912:	00 00 00 
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802921:	00 00 00 
  802924:	ff d2                	callq  *%rdx
  802926:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  80292d:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  802933:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802937:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80293a:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  80293c:	48 bf ed 6a 80 00 00 	movabs $0x806aed,%rdi
  802943:	00 00 00 
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802952:	00 00 00 
  802955:	ff d2                	callq  *%rdx

	serve_init();
  802957:	48 b8 28 20 80 00 00 	movabs $0x802028,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax
	fs_init();
  802963:	48 b8 a4 10 80 00 00 	movabs $0x8010a4,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	callq  *%rax
	fs_test();
  80296f:	48 b8 89 29 80 00 00 	movabs $0x802989,%rax
  802976:	00 00 00 
  802979:	ff d0                	callq  *%rax
	serve();
  80297b:	48 b8 92 27 80 00 00 	movabs $0x802792,%rax
  802982:	00 00 00 
  802985:	ff d0                	callq  *%rax
}
  802987:	c9                   	leaveq 
  802988:	c3                   	retq   

0000000000802989 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802989:	55                   	push   %rbp
  80298a:	48 89 e5             	mov    %rsp,%rbp
  80298d:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802991:	ba 07 00 00 00       	mov    $0x7,%edx
  802996:	be 00 10 00 00       	mov    $0x1000,%esi
  80299b:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a0:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	79 30                	jns    8029e5 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b8:	89 c1                	mov    %eax,%ecx
  8029ba:	48 ba 26 6b 80 00 00 	movabs $0x806b26,%rdx
  8029c1:	00 00 00 
  8029c4:	be 13 00 00 00       	mov    $0x13,%esi
  8029c9:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  8029d0:	00 00 00 
  8029d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d8:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  8029df:	00 00 00 
  8029e2:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  8029e5:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  8029ec:	00 
	memmove(bits, bitmap, PGSIZE);
  8029ed:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  8029f4:	00 00 00 
  8029f7:	48 8b 08             	mov    (%rax),%rcx
  8029fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a03:	48 89 ce             	mov    %rcx,%rsi
  802a06:	48 89 c7             	mov    %rax,%rdi
  802a09:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  802a10:	00 00 00 
  802a13:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802a15:	48 b8 a1 0e 80 00 00 	movabs $0x800ea1,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a28:	79 30                	jns    802a5a <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2d:	89 c1                	mov    %eax,%ecx
  802a2f:	48 ba 43 6b 80 00 00 	movabs $0x806b43,%rdx
  802a36:	00 00 00 
  802a39:	be 18 00 00 00       	mov    $0x18,%esi
  802a3e:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802a45:	00 00 00 
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4d:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802a54:	00 00 00 
  802a57:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5d:	8d 50 1f             	lea    0x1f(%rax),%edx
  802a60:	85 c0                	test   %eax,%eax
  802a62:	0f 48 c2             	cmovs  %edx,%eax
  802a65:	c1 f8 05             	sar    $0x5,%eax
  802a68:	48 98                	cltq   
  802a6a:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802a71:	00 
  802a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a76:	48 01 d0             	add    %rdx,%rax
  802a79:	8b 30                	mov    (%rax),%esi
  802a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7e:	99                   	cltd   
  802a7f:	c1 ea 1b             	shr    $0x1b,%edx
  802a82:	01 d0                	add    %edx,%eax
  802a84:	83 e0 1f             	and    $0x1f,%eax
  802a87:	29 d0                	sub    %edx,%eax
  802a89:	ba 01 00 00 00       	mov    $0x1,%edx
  802a8e:	89 c1                	mov    %eax,%ecx
  802a90:	d3 e2                	shl    %cl,%edx
  802a92:	89 d0                	mov    %edx,%eax
  802a94:	21 f0                	and    %esi,%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	75 35                	jne    802acf <fs_test+0x146>
  802a9a:	48 b9 53 6b 80 00 00 	movabs $0x806b53,%rcx
  802aa1:	00 00 00 
  802aa4:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802aab:	00 00 00 
  802aae:	be 1a 00 00 00       	mov    $0x1a,%esi
  802ab3:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802aba:	00 00 00 
  802abd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac2:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802ac9:	00 00 00 
  802acc:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802acf:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802ad6:	00 00 00 
  802ad9:	48 8b 10             	mov    (%rax),%rdx
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adf:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	0f 48 c1             	cmovs  %ecx,%eax
  802ae7:	c1 f8 05             	sar    $0x5,%eax
  802aea:	48 98                	cltq   
  802aec:	48 c1 e0 02          	shl    $0x2,%rax
  802af0:	48 01 d0             	add    %rdx,%rax
  802af3:	8b 30                	mov    (%rax),%esi
  802af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af8:	99                   	cltd   
  802af9:	c1 ea 1b             	shr    $0x1b,%edx
  802afc:	01 d0                	add    %edx,%eax
  802afe:	83 e0 1f             	and    $0x1f,%eax
  802b01:	29 d0                	sub    %edx,%eax
  802b03:	ba 01 00 00 00       	mov    $0x1,%edx
  802b08:	89 c1                	mov    %eax,%ecx
  802b0a:	d3 e2                	shl    %cl,%edx
  802b0c:	89 d0                	mov    %edx,%eax
  802b0e:	21 f0                	and    %esi,%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 35                	je     802b49 <fs_test+0x1c0>
  802b14:	48 b9 88 6b 80 00 00 	movabs $0x806b88,%rcx
  802b1b:	00 00 00 
  802b1e:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802b25:	00 00 00 
  802b28:	be 1c 00 00 00       	mov    $0x1c,%esi
  802b2d:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802b34:	00 00 00 
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3c:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802b43:	00 00 00 
  802b46:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802b49:	48 bf a8 6b 80 00 00 	movabs $0x806ba8,%rdi
  802b50:	00 00 00 
  802b53:	b8 00 00 00 00       	mov    $0x0,%eax
  802b58:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802b5f:	00 00 00 
  802b62:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802b64:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b68:	48 89 c6             	mov    %rax,%rsi
  802b6b:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  802b72:	00 00 00 
  802b75:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b88:	79 36                	jns    802bc0 <fs_test+0x237>
  802b8a:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802b8e:	74 30                	je     802bc0 <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802b90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b93:	89 c1                	mov    %eax,%ecx
  802b95:	48 ba c8 6b 80 00 00 	movabs $0x806bc8,%rdx
  802b9c:	00 00 00 
  802b9f:	be 20 00 00 00       	mov    $0x20,%esi
  802ba4:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802bab:	00 00 00 
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb3:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802bba:	00 00 00 
  802bbd:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc4:	75 2a                	jne    802bf0 <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802bc6:	48 ba e8 6b 80 00 00 	movabs $0x806be8,%rdx
  802bcd:	00 00 00 
  802bd0:	be 22 00 00 00       	mov    $0x22,%esi
  802bd5:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802bdc:	00 00 00 
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802be4:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  802beb:	00 00 00 
  802bee:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802bf0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802bf4:	48 89 c6             	mov    %rax,%rsi
  802bf7:	48 bf 08 6c 80 00 00 	movabs $0x806c08,%rdi
  802bfe:	00 00 00 
  802c01:	48 b8 df 19 80 00 00 	movabs $0x8019df,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	79 30                	jns    802c46 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c19:	89 c1                	mov    %eax,%ecx
  802c1b:	48 ba 11 6c 80 00 00 	movabs $0x806c11,%rdx
  802c22:	00 00 00 
  802c25:	be 24 00 00 00       	mov    $0x24,%esi
  802c2a:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802c31:	00 00 00 
  802c34:	b8 00 00 00 00       	mov    $0x0,%eax
  802c39:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802c40:	00 00 00 
  802c43:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802c46:	48 bf 28 6c 80 00 00 	movabs $0x806c28,%rdi
  802c4d:	00 00 00 
  802c50:	b8 00 00 00 00       	mov    $0x0,%eax
  802c55:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802c5c:	00 00 00 
  802c5f:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802c69:	be 00 00 00 00       	mov    $0x0,%esi
  802c6e:	48 89 c7             	mov    %rax,%rdi
  802c71:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  802c78:	00 00 00 
  802c7b:	ff d0                	callq  *%rax
  802c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c84:	79 30                	jns    802cb6 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c89:	89 c1                	mov    %eax,%ecx
  802c8b:	48 ba 3b 6c 80 00 00 	movabs $0x806c3b,%rdx
  802c92:	00 00 00 
  802c95:	be 28 00 00 00       	mov    $0x28,%esi
  802c9a:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802ca1:	00 00 00 
  802ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca9:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802cb0:	00 00 00 
  802cb3:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802cb6:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802cbd:	00 00 00 
  802cc0:	48 8b 10             	mov    (%rax),%rdx
  802cc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc7:	48 89 d6             	mov    %rdx,%rsi
  802cca:	48 89 c7             	mov    %rax,%rdi
  802ccd:	48 b8 7d 41 80 00 00 	movabs $0x80417d,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 2a                	je     802d07 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802cdd:	48 ba 50 6c 80 00 00 	movabs $0x806c50,%rdx
  802ce4:	00 00 00 
  802ce7:	be 2a 00 00 00       	mov    $0x2a,%esi
  802cec:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802cf3:	00 00 00 
  802cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfb:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  802d02:	00 00 00 
  802d05:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802d07:	48 bf 73 6c 80 00 00 	movabs $0x806c73,%rdi
  802d0e:	00 00 00 
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
  802d16:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802d1d:	00 00 00 
  802d20:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802d22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d26:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d2a:	0f b6 12             	movzbl (%rdx),%edx
  802d2d:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802d2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d33:	48 c1 e8 0c          	shr    $0xc,%rax
  802d37:	48 89 c2             	mov    %rax,%rdx
  802d3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d41:	01 00 00 
  802d44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d48:	83 e0 40             	and    $0x40,%eax
  802d4b:	48 85 c0             	test   %rax,%rax
  802d4e:	75 35                	jne    802d85 <fs_test+0x3fc>
  802d50:	48 b9 8b 6c 80 00 00 	movabs $0x806c8b,%rcx
  802d57:	00 00 00 
  802d5a:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802d61:	00 00 00 
  802d64:	be 2e 00 00 00       	mov    $0x2e,%esi
  802d69:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802d70:	00 00 00 
  802d73:	b8 00 00 00 00       	mov    $0x0,%eax
  802d78:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802d7f:	00 00 00 
  802d82:	41 ff d0             	callq  *%r8
	file_flush(f);
  802d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d89:	48 89 c7             	mov    %rax,%rdi
  802d8c:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802d98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9c:	48 c1 e8 0c          	shr    $0xc,%rax
  802da0:	48 89 c2             	mov    %rax,%rdx
  802da3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802daa:	01 00 00 
  802dad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802db1:	83 e0 40             	and    $0x40,%eax
  802db4:	48 85 c0             	test   %rax,%rax
  802db7:	74 35                	je     802dee <fs_test+0x465>
  802db9:	48 b9 a6 6c 80 00 00 	movabs $0x806ca6,%rcx
  802dc0:	00 00 00 
  802dc3:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802dca:	00 00 00 
  802dcd:	be 30 00 00 00       	mov    $0x30,%esi
  802dd2:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802dd9:	00 00 00 
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802de8:	00 00 00 
  802deb:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802dee:	48 bf c2 6c 80 00 00 	movabs $0x806cc2,%rdi
  802df5:	00 00 00 
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802e04:	00 00 00 
  802e07:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0d:	be 00 00 00 00       	mov    $0x0,%esi
  802e12:	48 89 c7             	mov    %rax,%rdi
  802e15:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	callq  *%rax
  802e21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e28:	79 30                	jns    802e5a <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2d:	89 c1                	mov    %eax,%ecx
  802e2f:	48 ba d6 6c 80 00 00 	movabs $0x806cd6,%rdx
  802e36:	00 00 00 
  802e39:	be 34 00 00 00       	mov    $0x34,%esi
  802e3e:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802e45:	00 00 00 
  802e48:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4d:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802e54:	00 00 00 
  802e57:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802e5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5e:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 35                	je     802e9d <fs_test+0x514>
  802e68:	48 b9 e8 6c 80 00 00 	movabs $0x806ce8,%rcx
  802e6f:	00 00 00 
  802e72:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802e79:	00 00 00 
  802e7c:	be 35 00 00 00       	mov    $0x35,%esi
  802e81:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802e88:	00 00 00 
  802e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e90:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802e97:	00 00 00 
  802e9a:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea1:	48 c1 e8 0c          	shr    $0xc,%rax
  802ea5:	48 89 c2             	mov    %rax,%rdx
  802ea8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eaf:	01 00 00 
  802eb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eb6:	83 e0 40             	and    $0x40,%eax
  802eb9:	48 85 c0             	test   %rax,%rax
  802ebc:	74 35                	je     802ef3 <fs_test+0x56a>
  802ebe:	48 b9 fc 6c 80 00 00 	movabs $0x806cfc,%rcx
  802ec5:	00 00 00 
  802ec8:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802ecf:	00 00 00 
  802ed2:	be 36 00 00 00       	mov    $0x36,%esi
  802ed7:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802ede:	00 00 00 
  802ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee6:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802eed:	00 00 00 
  802ef0:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802ef3:	48 bf 16 6d 80 00 00 	movabs $0x806d16,%rdi
  802efa:	00 00 00 
  802efd:	b8 00 00 00 00       	mov    $0x0,%eax
  802f02:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  802f09:	00 00 00 
  802f0c:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802f0e:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802f15:	00 00 00 
  802f18:	48 8b 00             	mov    (%rax),%rax
  802f1b:	48 89 c7             	mov    %rax,%rdi
  802f1e:	48 b8 af 3f 80 00 00 	movabs $0x803faf,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	89 c2                	mov    %eax,%edx
  802f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f30:	89 d6                	mov    %edx,%esi
  802f32:	48 89 c7             	mov    %rax,%rdi
  802f35:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
  802f41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f48:	79 30                	jns    802f7a <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4d:	89 c1                	mov    %eax,%ecx
  802f4f:	48 ba 2d 6d 80 00 00 	movabs $0x806d2d,%rdx
  802f56:	00 00 00 
  802f59:	be 3a 00 00 00       	mov    $0x3a,%esi
  802f5e:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802f65:	00 00 00 
  802f68:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6d:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802f74:	00 00 00 
  802f77:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7e:	48 c1 e8 0c          	shr    $0xc,%rax
  802f82:	48 89 c2             	mov    %rax,%rdx
  802f85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f8c:	01 00 00 
  802f8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f93:	83 e0 40             	and    $0x40,%eax
  802f96:	48 85 c0             	test   %rax,%rax
  802f99:	74 35                	je     802fd0 <fs_test+0x647>
  802f9b:	48 b9 fc 6c 80 00 00 	movabs $0x806cfc,%rcx
  802fa2:	00 00 00 
  802fa5:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  802fac:	00 00 00 
  802faf:	be 3b 00 00 00       	mov    $0x3b,%esi
  802fb4:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  802fbb:	00 00 00 
  802fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc3:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  802fca:	00 00 00 
  802fcd:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802fd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd4:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802fd8:	be 00 00 00 00       	mov    $0x0,%esi
  802fdd:	48 89 c7             	mov    %rax,%rdi
  802fe0:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
  802fec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff3:	79 30                	jns    803025 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff8:	89 c1                	mov    %eax,%ecx
  802ffa:	48 ba 41 6d 80 00 00 	movabs $0x806d41,%rdx
  803001:	00 00 00 
  803004:	be 3d 00 00 00       	mov    $0x3d,%esi
  803009:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  803010:	00 00 00 
  803013:	b8 00 00 00 00       	mov    $0x0,%eax
  803018:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  80301f:	00 00 00 
  803022:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  803025:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  80302c:	00 00 00 
  80302f:	48 8b 10             	mov    (%rax),%rdx
  803032:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803036:	48 89 d6             	mov    %rdx,%rsi
  803039:	48 89 c7             	mov    %rax,%rdi
  80303c:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  803048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304c:	48 c1 e8 0c          	shr    $0xc,%rax
  803050:	48 89 c2             	mov    %rax,%rdx
  803053:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80305a:	01 00 00 
  80305d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803061:	83 e0 40             	and    $0x40,%eax
  803064:	48 85 c0             	test   %rax,%rax
  803067:	75 35                	jne    80309e <fs_test+0x715>
  803069:	48 b9 8b 6c 80 00 00 	movabs $0x806c8b,%rcx
  803070:	00 00 00 
  803073:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  80307a:	00 00 00 
  80307d:	be 3f 00 00 00       	mov    $0x3f,%esi
  803082:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  803089:	00 00 00 
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
  803091:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  803098:	00 00 00 
  80309b:	41 ff d0             	callq  *%r8
	file_flush(f);
  80309e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a2:	48 89 c7             	mov    %rax,%rdi
  8030a5:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8030b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8030b9:	48 89 c2             	mov    %rax,%rdx
  8030bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030c3:	01 00 00 
  8030c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030ca:	83 e0 40             	and    $0x40,%eax
  8030cd:	48 85 c0             	test   %rax,%rax
  8030d0:	74 35                	je     803107 <fs_test+0x77e>
  8030d2:	48 b9 a6 6c 80 00 00 	movabs $0x806ca6,%rcx
  8030d9:	00 00 00 
  8030dc:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  8030e3:	00 00 00 
  8030e6:	be 41 00 00 00       	mov    $0x41,%esi
  8030eb:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  8030f2:	00 00 00 
  8030f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fa:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  803101:	00 00 00 
  803104:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310b:	48 c1 e8 0c          	shr    $0xc,%rax
  80310f:	48 89 c2             	mov    %rax,%rdx
  803112:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803119:	01 00 00 
  80311c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803120:	83 e0 40             	and    $0x40,%eax
  803123:	48 85 c0             	test   %rax,%rax
  803126:	74 35                	je     80315d <fs_test+0x7d4>
  803128:	48 b9 fc 6c 80 00 00 	movabs $0x806cfc,%rcx
  80312f:	00 00 00 
  803132:	48 ba 6e 6b 80 00 00 	movabs $0x806b6e,%rdx
  803139:	00 00 00 
  80313c:	be 42 00 00 00       	mov    $0x42,%esi
  803141:	48 bf 39 6b 80 00 00 	movabs $0x806b39,%rdi
  803148:	00 00 00 
  80314b:	b8 00 00 00 00       	mov    $0x0,%eax
  803150:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  803157:	00 00 00 
  80315a:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  80315d:	48 bf 56 6d 80 00 00 	movabs $0x806d56,%rdi
  803164:	00 00 00 
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  803173:	00 00 00 
  803176:	ff d2                	callq  *%rdx
}
  803178:	c9                   	leaveq 
  803179:	c3                   	retq   

000000000080317a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80317a:	55                   	push   %rbp
  80317b:	48 89 e5             	mov    %rsp,%rbp
  80317e:	48 83 ec 10          	sub    $0x10,%rsp
  803182:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803185:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  803189:	48 b8 ce 48 80 00 00 	movabs $0x8048ce,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
  803195:	48 98                	cltq   
  803197:	25 ff 03 00 00       	and    $0x3ff,%eax
  80319c:	48 89 c2             	mov    %rax,%rdx
  80319f:	48 89 d0             	mov    %rdx,%rax
  8031a2:	48 c1 e0 03          	shl    $0x3,%rax
  8031a6:	48 01 d0             	add    %rdx,%rax
  8031a9:	48 c1 e0 05          	shl    $0x5,%rax
  8031ad:	48 89 c2             	mov    %rax,%rdx
  8031b0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8031b7:	00 00 00 
  8031ba:	48 01 c2             	add    %rax,%rdx
  8031bd:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8031c4:	00 00 00 
  8031c7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8031ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ce:	7e 14                	jle    8031e4 <libmain+0x6a>
		binaryname = argv[0];
  8031d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d4:	48 8b 10             	mov    (%rax),%rdx
  8031d7:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8031de:	00 00 00 
  8031e1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8031e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031eb:	48 89 d6             	mov    %rdx,%rsi
  8031ee:	89 c7                	mov    %eax,%edi
  8031f0:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8031fc:	48 b8 0a 32 80 00 00 	movabs $0x80320a,%rax
  803203:	00 00 00 
  803206:	ff d0                	callq  *%rax
}
  803208:	c9                   	leaveq 
  803209:	c3                   	retq   

000000000080320a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80320a:	55                   	push   %rbp
  80320b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80320e:	48 b8 fc 51 80 00 00 	movabs $0x8051fc,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80321a:	bf 00 00 00 00       	mov    $0x0,%edi
  80321f:	48 b8 8a 48 80 00 00 	movabs $0x80488a,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
}
  80322b:	5d                   	pop    %rbp
  80322c:	c3                   	retq   

000000000080322d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80322d:	55                   	push   %rbp
  80322e:	48 89 e5             	mov    %rsp,%rbp
  803231:	53                   	push   %rbx
  803232:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803239:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803240:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803246:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80324d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803254:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80325b:	84 c0                	test   %al,%al
  80325d:	74 23                	je     803282 <_panic+0x55>
  80325f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803266:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80326a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80326e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803272:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803276:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80327a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80327e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803282:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803289:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803290:	00 00 00 
  803293:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80329a:	00 00 00 
  80329d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032a1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8032a8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8032af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8032b6:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8032bd:	00 00 00 
  8032c0:	48 8b 18             	mov    (%rax),%rbx
  8032c3:	48 b8 ce 48 80 00 00 	movabs $0x8048ce,%rax
  8032ca:	00 00 00 
  8032cd:	ff d0                	callq  *%rax
  8032cf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8032d5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032dc:	41 89 c8             	mov    %ecx,%r8d
  8032df:	48 89 d1             	mov    %rdx,%rcx
  8032e2:	48 89 da             	mov    %rbx,%rdx
  8032e5:	89 c6                	mov    %eax,%esi
  8032e7:	48 bf 78 6d 80 00 00 	movabs $0x806d78,%rdi
  8032ee:	00 00 00 
  8032f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f6:	49 b9 66 34 80 00 00 	movabs $0x803466,%r9
  8032fd:	00 00 00 
  803300:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803303:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80330a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803311:	48 89 d6             	mov    %rdx,%rsi
  803314:	48 89 c7             	mov    %rax,%rdi
  803317:	48 b8 ba 33 80 00 00 	movabs $0x8033ba,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
	cprintf("\n");
  803323:	48 bf 9b 6d 80 00 00 	movabs $0x806d9b,%rdi
  80332a:	00 00 00 
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  803339:	00 00 00 
  80333c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80333e:	cc                   	int3   
  80333f:	eb fd                	jmp    80333e <_panic+0x111>

0000000000803341 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803341:	55                   	push   %rbp
  803342:	48 89 e5             	mov    %rsp,%rbp
  803345:	48 83 ec 10          	sub    $0x10,%rsp
  803349:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80334c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803350:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803354:	8b 00                	mov    (%rax),%eax
  803356:	8d 48 01             	lea    0x1(%rax),%ecx
  803359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80335d:	89 0a                	mov    %ecx,(%rdx)
  80335f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803362:	89 d1                	mov    %edx,%ecx
  803364:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803368:	48 98                	cltq   
  80336a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80336e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803372:	8b 00                	mov    (%rax),%eax
  803374:	3d ff 00 00 00       	cmp    $0xff,%eax
  803379:	75 2c                	jne    8033a7 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80337b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337f:	8b 00                	mov    (%rax),%eax
  803381:	48 98                	cltq   
  803383:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803387:	48 83 c2 08          	add    $0x8,%rdx
  80338b:	48 89 c6             	mov    %rax,%rsi
  80338e:	48 89 d7             	mov    %rdx,%rdi
  803391:	48 b8 02 48 80 00 00 	movabs $0x804802,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
        b->idx = 0;
  80339d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8033a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ab:	8b 40 04             	mov    0x4(%rax),%eax
  8033ae:	8d 50 01             	lea    0x1(%rax),%edx
  8033b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b5:	89 50 04             	mov    %edx,0x4(%rax)
}
  8033b8:	c9                   	leaveq 
  8033b9:	c3                   	retq   

00000000008033ba <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8033ba:	55                   	push   %rbp
  8033bb:	48 89 e5             	mov    %rsp,%rbp
  8033be:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8033c5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8033cc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8033d3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8033da:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8033e1:	48 8b 0a             	mov    (%rdx),%rcx
  8033e4:	48 89 08             	mov    %rcx,(%rax)
  8033e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8033eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8033ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8033f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8033f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8033fe:	00 00 00 
    b.cnt = 0;
  803401:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803408:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80340b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803412:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803419:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803420:	48 89 c6             	mov    %rax,%rsi
  803423:	48 bf 41 33 80 00 00 	movabs $0x803341,%rdi
  80342a:	00 00 00 
  80342d:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803439:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80343f:	48 98                	cltq   
  803441:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803448:	48 83 c2 08          	add    $0x8,%rdx
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	48 89 d7             	mov    %rdx,%rdi
  803452:	48 b8 02 48 80 00 00 	movabs $0x804802,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80345e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803464:	c9                   	leaveq 
  803465:	c3                   	retq   

0000000000803466 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  803466:	55                   	push   %rbp
  803467:	48 89 e5             	mov    %rsp,%rbp
  80346a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803471:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803478:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80347f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803486:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80348d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803494:	84 c0                	test   %al,%al
  803496:	74 20                	je     8034b8 <cprintf+0x52>
  803498:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80349c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8034a0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8034a4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8034a8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8034ac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8034b0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8034b4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8034b8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8034bf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8034c6:	00 00 00 
  8034c9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8034d0:	00 00 00 
  8034d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034d7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8034de:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8034e5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8034ec:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8034f3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8034fa:	48 8b 0a             	mov    (%rdx),%rcx
  8034fd:	48 89 08             	mov    %rcx,(%rax)
  803500:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803504:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803508:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80350c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803510:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803517:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80351e:	48 89 d6             	mov    %rdx,%rsi
  803521:	48 89 c7             	mov    %rax,%rdi
  803524:	48 b8 ba 33 80 00 00 	movabs $0x8033ba,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803536:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80353c:	c9                   	leaveq 
  80353d:	c3                   	retq   

000000000080353e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80353e:	55                   	push   %rbp
  80353f:	48 89 e5             	mov    %rsp,%rbp
  803542:	53                   	push   %rbx
  803543:	48 83 ec 38          	sub    $0x38,%rsp
  803547:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80354b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80354f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803553:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803556:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80355a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80355e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803561:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803565:	77 3b                	ja     8035a2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803567:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80356a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80356e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  803571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803575:	ba 00 00 00 00       	mov    $0x0,%edx
  80357a:	48 f7 f3             	div    %rbx
  80357d:	48 89 c2             	mov    %rax,%rdx
  803580:	8b 7d cc             	mov    -0x34(%rbp),%edi
  803583:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  803586:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80358a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358e:	41 89 f9             	mov    %edi,%r9d
  803591:	48 89 c7             	mov    %rax,%rdi
  803594:	48 b8 3e 35 80 00 00 	movabs $0x80353e,%rax
  80359b:	00 00 00 
  80359e:	ff d0                	callq  *%rax
  8035a0:	eb 1e                	jmp    8035c0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8035a2:	eb 12                	jmp    8035b6 <printnum+0x78>
			putch(padc, putdat);
  8035a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035a8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8035ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035af:	48 89 ce             	mov    %rcx,%rsi
  8035b2:	89 d7                	mov    %edx,%edi
  8035b4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8035b6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8035ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8035be:	7f e4                	jg     8035a4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8035c0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8035c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8035cc:	48 f7 f1             	div    %rcx
  8035cf:	48 89 d0             	mov    %rdx,%rax
  8035d2:	48 ba 90 6f 80 00 00 	movabs $0x806f90,%rdx
  8035d9:	00 00 00 
  8035dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8035e0:	0f be d0             	movsbl %al,%edx
  8035e3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035eb:	48 89 ce             	mov    %rcx,%rsi
  8035ee:	89 d7                	mov    %edx,%edi
  8035f0:	ff d0                	callq  *%rax
}
  8035f2:	48 83 c4 38          	add    $0x38,%rsp
  8035f6:	5b                   	pop    %rbx
  8035f7:	5d                   	pop    %rbp
  8035f8:	c3                   	retq   

00000000008035f9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  803601:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803605:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803608:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80360c:	7e 52                	jle    803660 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80360e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803612:	8b 00                	mov    (%rax),%eax
  803614:	83 f8 30             	cmp    $0x30,%eax
  803617:	73 24                	jae    80363d <getuint+0x44>
  803619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803625:	8b 00                	mov    (%rax),%eax
  803627:	89 c0                	mov    %eax,%eax
  803629:	48 01 d0             	add    %rdx,%rax
  80362c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803630:	8b 12                	mov    (%rdx),%edx
  803632:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803635:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803639:	89 0a                	mov    %ecx,(%rdx)
  80363b:	eb 17                	jmp    803654 <getuint+0x5b>
  80363d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803641:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803645:	48 89 d0             	mov    %rdx,%rax
  803648:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80364c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803650:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803654:	48 8b 00             	mov    (%rax),%rax
  803657:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80365b:	e9 a3 00 00 00       	jmpq   803703 <getuint+0x10a>
	else if (lflag)
  803660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803664:	74 4f                	je     8036b5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366a:	8b 00                	mov    (%rax),%eax
  80366c:	83 f8 30             	cmp    $0x30,%eax
  80366f:	73 24                	jae    803695 <getuint+0x9c>
  803671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803675:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367d:	8b 00                	mov    (%rax),%eax
  80367f:	89 c0                	mov    %eax,%eax
  803681:	48 01 d0             	add    %rdx,%rax
  803684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803688:	8b 12                	mov    (%rdx),%edx
  80368a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80368d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803691:	89 0a                	mov    %ecx,(%rdx)
  803693:	eb 17                	jmp    8036ac <getuint+0xb3>
  803695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803699:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80369d:	48 89 d0             	mov    %rdx,%rax
  8036a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036ac:	48 8b 00             	mov    (%rax),%rax
  8036af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036b3:	eb 4e                	jmp    803703 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8036b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b9:	8b 00                	mov    (%rax),%eax
  8036bb:	83 f8 30             	cmp    $0x30,%eax
  8036be:	73 24                	jae    8036e4 <getuint+0xeb>
  8036c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cc:	8b 00                	mov    (%rax),%eax
  8036ce:	89 c0                	mov    %eax,%eax
  8036d0:	48 01 d0             	add    %rdx,%rax
  8036d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d7:	8b 12                	mov    (%rdx),%edx
  8036d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036e0:	89 0a                	mov    %ecx,(%rdx)
  8036e2:	eb 17                	jmp    8036fb <getuint+0x102>
  8036e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036ec:	48 89 d0             	mov    %rdx,%rax
  8036ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036fb:	8b 00                	mov    (%rax),%eax
  8036fd:	89 c0                	mov    %eax,%eax
  8036ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	48 83 ec 1c          	sub    $0x1c,%rsp
  803711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803715:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803718:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80371c:	7e 52                	jle    803770 <getint+0x67>
		x=va_arg(*ap, long long);
  80371e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803722:	8b 00                	mov    (%rax),%eax
  803724:	83 f8 30             	cmp    $0x30,%eax
  803727:	73 24                	jae    80374d <getint+0x44>
  803729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803735:	8b 00                	mov    (%rax),%eax
  803737:	89 c0                	mov    %eax,%eax
  803739:	48 01 d0             	add    %rdx,%rax
  80373c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803740:	8b 12                	mov    (%rdx),%edx
  803742:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803749:	89 0a                	mov    %ecx,(%rdx)
  80374b:	eb 17                	jmp    803764 <getint+0x5b>
  80374d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803751:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803755:	48 89 d0             	mov    %rdx,%rax
  803758:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80375c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803760:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803764:	48 8b 00             	mov    (%rax),%rax
  803767:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80376b:	e9 a3 00 00 00       	jmpq   803813 <getint+0x10a>
	else if (lflag)
  803770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803774:	74 4f                	je     8037c5 <getint+0xbc>
		x=va_arg(*ap, long);
  803776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377a:	8b 00                	mov    (%rax),%eax
  80377c:	83 f8 30             	cmp    $0x30,%eax
  80377f:	73 24                	jae    8037a5 <getint+0x9c>
  803781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803785:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378d:	8b 00                	mov    (%rax),%eax
  80378f:	89 c0                	mov    %eax,%eax
  803791:	48 01 d0             	add    %rdx,%rax
  803794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803798:	8b 12                	mov    (%rdx),%edx
  80379a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80379d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037a1:	89 0a                	mov    %ecx,(%rdx)
  8037a3:	eb 17                	jmp    8037bc <getint+0xb3>
  8037a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037ad:	48 89 d0             	mov    %rdx,%rax
  8037b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8037b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8037bc:	48 8b 00             	mov    (%rax),%rax
  8037bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8037c3:	eb 4e                	jmp    803813 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8037c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c9:	8b 00                	mov    (%rax),%eax
  8037cb:	83 f8 30             	cmp    $0x30,%eax
  8037ce:	73 24                	jae    8037f4 <getint+0xeb>
  8037d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037dc:	8b 00                	mov    (%rax),%eax
  8037de:	89 c0                	mov    %eax,%eax
  8037e0:	48 01 d0             	add    %rdx,%rax
  8037e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037e7:	8b 12                	mov    (%rdx),%edx
  8037e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8037ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037f0:	89 0a                	mov    %ecx,(%rdx)
  8037f2:	eb 17                	jmp    80380b <getint+0x102>
  8037f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037fc:	48 89 d0             	mov    %rdx,%rax
  8037ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803807:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80380b:	8b 00                	mov    (%rax),%eax
  80380d:	48 98                	cltq   
  80380f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803817:	c9                   	leaveq 
  803818:	c3                   	retq   

0000000000803819 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803819:	55                   	push   %rbp
  80381a:	48 89 e5             	mov    %rsp,%rbp
  80381d:	41 54                	push   %r12
  80381f:	53                   	push   %rbx
  803820:	48 83 ec 60          	sub    $0x60,%rsp
  803824:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803828:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80382c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803830:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803834:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803838:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80383c:	48 8b 0a             	mov    (%rdx),%rcx
  80383f:	48 89 08             	mov    %rcx,(%rax)
  803842:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803846:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80384a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80384e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803852:	eb 17                	jmp    80386b <vprintfmt+0x52>
			if (ch == '\0')
  803854:	85 db                	test   %ebx,%ebx
  803856:	0f 84 cc 04 00 00    	je     803d28 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80385c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803860:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803864:	48 89 d6             	mov    %rdx,%rsi
  803867:	89 df                	mov    %ebx,%edi
  803869:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80386b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80386f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803873:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803877:	0f b6 00             	movzbl (%rax),%eax
  80387a:	0f b6 d8             	movzbl %al,%ebx
  80387d:	83 fb 25             	cmp    $0x25,%ebx
  803880:	75 d2                	jne    803854 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803882:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803886:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80388d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803894:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80389b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8038a2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8038a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8038aa:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8038ae:	0f b6 00             	movzbl (%rax),%eax
  8038b1:	0f b6 d8             	movzbl %al,%ebx
  8038b4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8038b7:	83 f8 55             	cmp    $0x55,%eax
  8038ba:	0f 87 34 04 00 00    	ja     803cf4 <vprintfmt+0x4db>
  8038c0:	89 c0                	mov    %eax,%eax
  8038c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038c9:	00 
  8038ca:	48 b8 b8 6f 80 00 00 	movabs $0x806fb8,%rax
  8038d1:	00 00 00 
  8038d4:	48 01 d0             	add    %rdx,%rax
  8038d7:	48 8b 00             	mov    (%rax),%rax
  8038da:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8038dc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8038e0:	eb c0                	jmp    8038a2 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8038e2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8038e6:	eb ba                	jmp    8038a2 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8038e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8038ef:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8038f2:	89 d0                	mov    %edx,%eax
  8038f4:	c1 e0 02             	shl    $0x2,%eax
  8038f7:	01 d0                	add    %edx,%eax
  8038f9:	01 c0                	add    %eax,%eax
  8038fb:	01 d8                	add    %ebx,%eax
  8038fd:	83 e8 30             	sub    $0x30,%eax
  803900:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803903:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803907:	0f b6 00             	movzbl (%rax),%eax
  80390a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80390d:	83 fb 2f             	cmp    $0x2f,%ebx
  803910:	7e 0c                	jle    80391e <vprintfmt+0x105>
  803912:	83 fb 39             	cmp    $0x39,%ebx
  803915:	7f 07                	jg     80391e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803917:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80391c:	eb d1                	jmp    8038ef <vprintfmt+0xd6>
			goto process_precision;
  80391e:	eb 58                	jmp    803978 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803920:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803923:	83 f8 30             	cmp    $0x30,%eax
  803926:	73 17                	jae    80393f <vprintfmt+0x126>
  803928:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80392c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80392f:	89 c0                	mov    %eax,%eax
  803931:	48 01 d0             	add    %rdx,%rax
  803934:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803937:	83 c2 08             	add    $0x8,%edx
  80393a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80393d:	eb 0f                	jmp    80394e <vprintfmt+0x135>
  80393f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803943:	48 89 d0             	mov    %rdx,%rax
  803946:	48 83 c2 08          	add    $0x8,%rdx
  80394a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80394e:	8b 00                	mov    (%rax),%eax
  803950:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803953:	eb 23                	jmp    803978 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803955:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803959:	79 0c                	jns    803967 <vprintfmt+0x14e>
				width = 0;
  80395b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803962:	e9 3b ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>
  803967:	e9 36 ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80396c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803973:	e9 2a ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803978:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80397c:	79 12                	jns    803990 <vprintfmt+0x177>
				width = precision, precision = -1;
  80397e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803981:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803984:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80398b:	e9 12 ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>
  803990:	e9 0d ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803995:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803999:	e9 04 ff ff ff       	jmpq   8038a2 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80399e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039a1:	83 f8 30             	cmp    $0x30,%eax
  8039a4:	73 17                	jae    8039bd <vprintfmt+0x1a4>
  8039a6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039ad:	89 c0                	mov    %eax,%eax
  8039af:	48 01 d0             	add    %rdx,%rax
  8039b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039b5:	83 c2 08             	add    $0x8,%edx
  8039b8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039bb:	eb 0f                	jmp    8039cc <vprintfmt+0x1b3>
  8039bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039c1:	48 89 d0             	mov    %rdx,%rax
  8039c4:	48 83 c2 08          	add    $0x8,%rdx
  8039c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039cc:	8b 10                	mov    (%rax),%edx
  8039ce:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8039d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039d6:	48 89 ce             	mov    %rcx,%rsi
  8039d9:	89 d7                	mov    %edx,%edi
  8039db:	ff d0                	callq  *%rax
			break;
  8039dd:	e9 40 03 00 00       	jmpq   803d22 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8039e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039e5:	83 f8 30             	cmp    $0x30,%eax
  8039e8:	73 17                	jae    803a01 <vprintfmt+0x1e8>
  8039ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8039ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039f1:	89 c0                	mov    %eax,%eax
  8039f3:	48 01 d0             	add    %rdx,%rax
  8039f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039f9:	83 c2 08             	add    $0x8,%edx
  8039fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039ff:	eb 0f                	jmp    803a10 <vprintfmt+0x1f7>
  803a01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803a05:	48 89 d0             	mov    %rdx,%rax
  803a08:	48 83 c2 08          	add    $0x8,%rdx
  803a0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a10:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803a12:	85 db                	test   %ebx,%ebx
  803a14:	79 02                	jns    803a18 <vprintfmt+0x1ff>
				err = -err;
  803a16:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803a18:	83 fb 15             	cmp    $0x15,%ebx
  803a1b:	7f 16                	jg     803a33 <vprintfmt+0x21a>
  803a1d:	48 b8 e0 6e 80 00 00 	movabs $0x806ee0,%rax
  803a24:	00 00 00 
  803a27:	48 63 d3             	movslq %ebx,%rdx
  803a2a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803a2e:	4d 85 e4             	test   %r12,%r12
  803a31:	75 2e                	jne    803a61 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803a33:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803a37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a3b:	89 d9                	mov    %ebx,%ecx
  803a3d:	48 ba a1 6f 80 00 00 	movabs $0x806fa1,%rdx
  803a44:	00 00 00 
  803a47:	48 89 c7             	mov    %rax,%rdi
  803a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4f:	49 b8 31 3d 80 00 00 	movabs $0x803d31,%r8
  803a56:	00 00 00 
  803a59:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803a5c:	e9 c1 02 00 00       	jmpq   803d22 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803a61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803a65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a69:	4c 89 e1             	mov    %r12,%rcx
  803a6c:	48 ba aa 6f 80 00 00 	movabs $0x806faa,%rdx
  803a73:	00 00 00 
  803a76:	48 89 c7             	mov    %rax,%rdi
  803a79:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7e:	49 b8 31 3d 80 00 00 	movabs $0x803d31,%r8
  803a85:	00 00 00 
  803a88:	41 ff d0             	callq  *%r8
			break;
  803a8b:	e9 92 02 00 00       	jmpq   803d22 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803a90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a93:	83 f8 30             	cmp    $0x30,%eax
  803a96:	73 17                	jae    803aaf <vprintfmt+0x296>
  803a98:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a9f:	89 c0                	mov    %eax,%eax
  803aa1:	48 01 d0             	add    %rdx,%rax
  803aa4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803aa7:	83 c2 08             	add    $0x8,%edx
  803aaa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803aad:	eb 0f                	jmp    803abe <vprintfmt+0x2a5>
  803aaf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ab3:	48 89 d0             	mov    %rdx,%rax
  803ab6:	48 83 c2 08          	add    $0x8,%rdx
  803aba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803abe:	4c 8b 20             	mov    (%rax),%r12
  803ac1:	4d 85 e4             	test   %r12,%r12
  803ac4:	75 0a                	jne    803ad0 <vprintfmt+0x2b7>
				p = "(null)";
  803ac6:	49 bc ad 6f 80 00 00 	movabs $0x806fad,%r12
  803acd:	00 00 00 
			if (width > 0 && padc != '-')
  803ad0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ad4:	7e 3f                	jle    803b15 <vprintfmt+0x2fc>
  803ad6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803ada:	74 39                	je     803b15 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  803adc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803adf:	48 98                	cltq   
  803ae1:	48 89 c6             	mov    %rax,%rsi
  803ae4:	4c 89 e7             	mov    %r12,%rdi
  803ae7:	48 b8 dd 3f 80 00 00 	movabs $0x803fdd,%rax
  803aee:	00 00 00 
  803af1:	ff d0                	callq  *%rax
  803af3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803af6:	eb 17                	jmp    803b0f <vprintfmt+0x2f6>
					putch(padc, putdat);
  803af8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803afc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b04:	48 89 ce             	mov    %rcx,%rsi
  803b07:	89 d7                	mov    %edx,%edi
  803b09:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803b0b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b13:	7f e3                	jg     803af8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803b15:	eb 37                	jmp    803b4e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803b17:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803b1b:	74 1e                	je     803b3b <vprintfmt+0x322>
  803b1d:	83 fb 1f             	cmp    $0x1f,%ebx
  803b20:	7e 05                	jle    803b27 <vprintfmt+0x30e>
  803b22:	83 fb 7e             	cmp    $0x7e,%ebx
  803b25:	7e 14                	jle    803b3b <vprintfmt+0x322>
					putch('?', putdat);
  803b27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b2f:	48 89 d6             	mov    %rdx,%rsi
  803b32:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803b37:	ff d0                	callq  *%rax
  803b39:	eb 0f                	jmp    803b4a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803b3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b43:	48 89 d6             	mov    %rdx,%rsi
  803b46:	89 df                	mov    %ebx,%edi
  803b48:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803b4a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b4e:	4c 89 e0             	mov    %r12,%rax
  803b51:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803b55:	0f b6 00             	movzbl (%rax),%eax
  803b58:	0f be d8             	movsbl %al,%ebx
  803b5b:	85 db                	test   %ebx,%ebx
  803b5d:	74 10                	je     803b6f <vprintfmt+0x356>
  803b5f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803b63:	78 b2                	js     803b17 <vprintfmt+0x2fe>
  803b65:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803b69:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803b6d:	79 a8                	jns    803b17 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803b6f:	eb 16                	jmp    803b87 <vprintfmt+0x36e>
				putch(' ', putdat);
  803b71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b79:	48 89 d6             	mov    %rdx,%rsi
  803b7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b81:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803b83:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b87:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b8b:	7f e4                	jg     803b71 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803b8d:	e9 90 01 00 00       	jmpq   803d22 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803b92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b96:	be 03 00 00 00       	mov    $0x3,%esi
  803b9b:	48 89 c7             	mov    %rax,%rdi
  803b9e:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
  803baa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb2:	48 85 c0             	test   %rax,%rax
  803bb5:	79 1d                	jns    803bd4 <vprintfmt+0x3bb>
				putch('-', putdat);
  803bb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bbf:	48 89 d6             	mov    %rdx,%rsi
  803bc2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803bc7:	ff d0                	callq  *%rax
				num = -(long long) num;
  803bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcd:	48 f7 d8             	neg    %rax
  803bd0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803bd4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803bdb:	e9 d5 00 00 00       	jmpq   803cb5 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803be0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803be4:	be 03 00 00 00       	mov    $0x3,%esi
  803be9:	48 89 c7             	mov    %rax,%rdi
  803bec:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  803bf3:	00 00 00 
  803bf6:	ff d0                	callq  *%rax
  803bf8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803bfc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803c03:	e9 ad 00 00 00       	jmpq   803cb5 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  803c08:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c0c:	be 03 00 00 00       	mov    $0x3,%esi
  803c11:	48 89 c7             	mov    %rax,%rdi
  803c14:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
  803c20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  803c24:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  803c2b:	e9 85 00 00 00       	jmpq   803cb5 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  803c30:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c38:	48 89 d6             	mov    %rdx,%rsi
  803c3b:	bf 30 00 00 00       	mov    $0x30,%edi
  803c40:	ff d0                	callq  *%rax
			putch('x', putdat);
  803c42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c4a:	48 89 d6             	mov    %rdx,%rsi
  803c4d:	bf 78 00 00 00       	mov    $0x78,%edi
  803c52:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803c54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c57:	83 f8 30             	cmp    $0x30,%eax
  803c5a:	73 17                	jae    803c73 <vprintfmt+0x45a>
  803c5c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c63:	89 c0                	mov    %eax,%eax
  803c65:	48 01 d0             	add    %rdx,%rax
  803c68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c6b:	83 c2 08             	add    $0x8,%edx
  803c6e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803c71:	eb 0f                	jmp    803c82 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803c73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c77:	48 89 d0             	mov    %rdx,%rax
  803c7a:	48 83 c2 08          	add    $0x8,%rdx
  803c7e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c82:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803c85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803c89:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803c90:	eb 23                	jmp    803cb5 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803c92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c96:	be 03 00 00 00       	mov    $0x3,%esi
  803c9b:	48 89 c7             	mov    %rax,%rdi
  803c9e:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  803ca5:	00 00 00 
  803ca8:	ff d0                	callq  *%rax
  803caa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803cae:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803cb5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803cba:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803cbd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803cc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803cc4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ccc:	45 89 c1             	mov    %r8d,%r9d
  803ccf:	41 89 f8             	mov    %edi,%r8d
  803cd2:	48 89 c7             	mov    %rax,%rdi
  803cd5:	48 b8 3e 35 80 00 00 	movabs $0x80353e,%rax
  803cdc:	00 00 00 
  803cdf:	ff d0                	callq  *%rax
			break;
  803ce1:	eb 3f                	jmp    803d22 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803ce3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ceb:	48 89 d6             	mov    %rdx,%rsi
  803cee:	89 df                	mov    %ebx,%edi
  803cf0:	ff d0                	callq  *%rax
			break;
  803cf2:	eb 2e                	jmp    803d22 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803cf4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cf8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cfc:	48 89 d6             	mov    %rdx,%rsi
  803cff:	bf 25 00 00 00       	mov    $0x25,%edi
  803d04:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803d06:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803d0b:	eb 05                	jmp    803d12 <vprintfmt+0x4f9>
  803d0d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803d12:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803d16:	48 83 e8 01          	sub    $0x1,%rax
  803d1a:	0f b6 00             	movzbl (%rax),%eax
  803d1d:	3c 25                	cmp    $0x25,%al
  803d1f:	75 ec                	jne    803d0d <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803d21:	90                   	nop
		}
	}
  803d22:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803d23:	e9 43 fb ff ff       	jmpq   80386b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803d28:	48 83 c4 60          	add    $0x60,%rsp
  803d2c:	5b                   	pop    %rbx
  803d2d:	41 5c                	pop    %r12
  803d2f:	5d                   	pop    %rbp
  803d30:	c3                   	retq   

0000000000803d31 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803d31:	55                   	push   %rbp
  803d32:	48 89 e5             	mov    %rsp,%rbp
  803d35:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803d3c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803d43:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803d4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803d51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803d58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803d5f:	84 c0                	test   %al,%al
  803d61:	74 20                	je     803d83 <printfmt+0x52>
  803d63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803d67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803d6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803d6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803d73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803d77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803d7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803d7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803d83:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803d8a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803d91:	00 00 00 
  803d94:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803d9b:	00 00 00 
  803d9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803da2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803da9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803db0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803db7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803dbe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803dc5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803dcc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803dd3:	48 89 c7             	mov    %rax,%rdi
  803dd6:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  803ddd:	00 00 00 
  803de0:	ff d0                	callq  *%rax
	va_end(ap);
}
  803de2:	c9                   	leaveq 
  803de3:	c3                   	retq   

0000000000803de4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803de4:	55                   	push   %rbp
  803de5:	48 89 e5             	mov    %rsp,%rbp
  803de8:	48 83 ec 10          	sub    $0x10,%rsp
  803dec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803def:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803df3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df7:	8b 40 10             	mov    0x10(%rax),%eax
  803dfa:	8d 50 01             	lea    0x1(%rax),%edx
  803dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e01:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803e04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e08:	48 8b 10             	mov    (%rax),%rdx
  803e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0f:	48 8b 40 08          	mov    0x8(%rax),%rax
  803e13:	48 39 c2             	cmp    %rax,%rdx
  803e16:	73 17                	jae    803e2f <sprintputch+0x4b>
		*b->buf++ = ch;
  803e18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1c:	48 8b 00             	mov    (%rax),%rax
  803e1f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803e23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e27:	48 89 0a             	mov    %rcx,(%rdx)
  803e2a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e2d:	88 10                	mov    %dl,(%rax)
}
  803e2f:	c9                   	leaveq 
  803e30:	c3                   	retq   

0000000000803e31 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803e31:	55                   	push   %rbp
  803e32:	48 89 e5             	mov    %rsp,%rbp
  803e35:	48 83 ec 50          	sub    $0x50,%rsp
  803e39:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803e3d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803e40:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803e44:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803e48:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803e4c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803e50:	48 8b 0a             	mov    (%rdx),%rcx
  803e53:	48 89 08             	mov    %rcx,(%rax)
  803e56:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803e5a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803e5e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803e62:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803e66:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e6a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803e6e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803e71:	48 98                	cltq   
  803e73:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803e77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e7b:	48 01 d0             	add    %rdx,%rax
  803e7e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803e82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803e89:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803e8e:	74 06                	je     803e96 <vsnprintf+0x65>
  803e90:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803e94:	7f 07                	jg     803e9d <vsnprintf+0x6c>
		return -E_INVAL;
  803e96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e9b:	eb 2f                	jmp    803ecc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803e9d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803ea1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803ea5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ea9:	48 89 c6             	mov    %rax,%rsi
  803eac:	48 bf e4 3d 80 00 00 	movabs $0x803de4,%rdi
  803eb3:	00 00 00 
  803eb6:	48 b8 19 38 80 00 00 	movabs $0x803819,%rax
  803ebd:	00 00 00 
  803ec0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803ec2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803ec9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803ecc:	c9                   	leaveq 
  803ecd:	c3                   	retq   

0000000000803ece <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803ece:	55                   	push   %rbp
  803ecf:	48 89 e5             	mov    %rsp,%rbp
  803ed2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803ed9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803ee0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803ee6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803eed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803ef4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803efb:	84 c0                	test   %al,%al
  803efd:	74 20                	je     803f1f <snprintf+0x51>
  803eff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803f03:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803f07:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803f0b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803f0f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803f13:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803f17:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803f1b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803f1f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803f26:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803f2d:	00 00 00 
  803f30:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803f37:	00 00 00 
  803f3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f3e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803f45:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803f4c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803f53:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803f5a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803f61:	48 8b 0a             	mov    (%rdx),%rcx
  803f64:	48 89 08             	mov    %rcx,(%rax)
  803f67:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803f6b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803f6f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803f73:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803f77:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803f7e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803f85:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803f8b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f92:	48 89 c7             	mov    %rax,%rdi
  803f95:	48 b8 31 3e 80 00 00 	movabs $0x803e31,%rax
  803f9c:	00 00 00 
  803f9f:	ff d0                	callq  *%rax
  803fa1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803fa7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803fad:	c9                   	leaveq 
  803fae:	c3                   	retq   

0000000000803faf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803faf:	55                   	push   %rbp
  803fb0:	48 89 e5             	mov    %rsp,%rbp
  803fb3:	48 83 ec 18          	sub    $0x18,%rsp
  803fb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803fbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fc2:	eb 09                	jmp    803fcd <strlen+0x1e>
		n++;
  803fc4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803fc8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fd1:	0f b6 00             	movzbl (%rax),%eax
  803fd4:	84 c0                	test   %al,%al
  803fd6:	75 ec                	jne    803fc4 <strlen+0x15>
		n++;
	return n;
  803fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fdb:	c9                   	leaveq 
  803fdc:	c3                   	retq   

0000000000803fdd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803fdd:	55                   	push   %rbp
  803fde:	48 89 e5             	mov    %rsp,%rbp
  803fe1:	48 83 ec 20          	sub    $0x20,%rsp
  803fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fe9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ff4:	eb 0e                	jmp    804004 <strnlen+0x27>
		n++;
  803ff6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803ffa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803fff:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  804004:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804009:	74 0b                	je     804016 <strnlen+0x39>
  80400b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400f:	0f b6 00             	movzbl (%rax),%eax
  804012:	84 c0                	test   %al,%al
  804014:	75 e0                	jne    803ff6 <strnlen+0x19>
		n++;
	return n;
  804016:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804019:	c9                   	leaveq 
  80401a:	c3                   	retq   

000000000080401b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80401b:	55                   	push   %rbp
  80401c:	48 89 e5             	mov    %rsp,%rbp
  80401f:	48 83 ec 20          	sub    $0x20,%rsp
  804023:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804027:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80402b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80402f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  804033:	90                   	nop
  804034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804038:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80403c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804040:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804044:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804048:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80404c:	0f b6 12             	movzbl (%rdx),%edx
  80404f:	88 10                	mov    %dl,(%rax)
  804051:	0f b6 00             	movzbl (%rax),%eax
  804054:	84 c0                	test   %al,%al
  804056:	75 dc                	jne    804034 <strcpy+0x19>
		/* do nothing */;
	return ret;
  804058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80405c:	c9                   	leaveq 
  80405d:	c3                   	retq   

000000000080405e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80405e:	55                   	push   %rbp
  80405f:	48 89 e5             	mov    %rsp,%rbp
  804062:	48 83 ec 20          	sub    $0x20,%rsp
  804066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80406a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80406e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804072:	48 89 c7             	mov    %rax,%rdi
  804075:	48 b8 af 3f 80 00 00 	movabs $0x803faf,%rax
  80407c:	00 00 00 
  80407f:	ff d0                	callq  *%rax
  804081:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  804084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804087:	48 63 d0             	movslq %eax,%rdx
  80408a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80408e:	48 01 c2             	add    %rax,%rdx
  804091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804095:	48 89 c6             	mov    %rax,%rsi
  804098:	48 89 d7             	mov    %rdx,%rdi
  80409b:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
	return dst;
  8040a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8040ab:	c9                   	leaveq 
  8040ac:	c3                   	retq   

00000000008040ad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8040ad:	55                   	push   %rbp
  8040ae:	48 89 e5             	mov    %rsp,%rbp
  8040b1:	48 83 ec 28          	sub    $0x28,%rsp
  8040b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8040c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8040c9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040d0:	00 
  8040d1:	eb 2a                	jmp    8040fd <strncpy+0x50>
		*dst++ = *src;
  8040d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8040db:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8040df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040e3:	0f b6 12             	movzbl (%rdx),%edx
  8040e6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8040e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040ec:	0f b6 00             	movzbl (%rax),%eax
  8040ef:	84 c0                	test   %al,%al
  8040f1:	74 05                	je     8040f8 <strncpy+0x4b>
			src++;
  8040f3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8040f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804101:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804105:	72 cc                	jb     8040d3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80410b:	c9                   	leaveq 
  80410c:	c3                   	retq   

000000000080410d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80410d:	55                   	push   %rbp
  80410e:	48 89 e5             	mov    %rsp,%rbp
  804111:	48 83 ec 28          	sub    $0x28,%rsp
  804115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804119:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  804121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804125:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804129:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80412e:	74 3d                	je     80416d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  804130:	eb 1d                	jmp    80414f <strlcpy+0x42>
			*dst++ = *src++;
  804132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804136:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80413a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80413e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804142:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804146:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80414a:	0f b6 12             	movzbl (%rdx),%edx
  80414d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80414f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804154:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804159:	74 0b                	je     804166 <strlcpy+0x59>
  80415b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80415f:	0f b6 00             	movzbl (%rax),%eax
  804162:	84 c0                	test   %al,%al
  804164:	75 cc                	jne    804132 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80416d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804171:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804175:	48 29 c2             	sub    %rax,%rdx
  804178:	48 89 d0             	mov    %rdx,%rax
}
  80417b:	c9                   	leaveq 
  80417c:	c3                   	retq   

000000000080417d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80417d:	55                   	push   %rbp
  80417e:	48 89 e5             	mov    %rsp,%rbp
  804181:	48 83 ec 10          	sub    $0x10,%rsp
  804185:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804189:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80418d:	eb 0a                	jmp    804199 <strcmp+0x1c>
		p++, q++;
  80418f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804194:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804199:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80419d:	0f b6 00             	movzbl (%rax),%eax
  8041a0:	84 c0                	test   %al,%al
  8041a2:	74 12                	je     8041b6 <strcmp+0x39>
  8041a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a8:	0f b6 10             	movzbl (%rax),%edx
  8041ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041af:	0f b6 00             	movzbl (%rax),%eax
  8041b2:	38 c2                	cmp    %al,%dl
  8041b4:	74 d9                	je     80418f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8041b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ba:	0f b6 00             	movzbl (%rax),%eax
  8041bd:	0f b6 d0             	movzbl %al,%edx
  8041c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c4:	0f b6 00             	movzbl (%rax),%eax
  8041c7:	0f b6 c0             	movzbl %al,%eax
  8041ca:	29 c2                	sub    %eax,%edx
  8041cc:	89 d0                	mov    %edx,%eax
}
  8041ce:	c9                   	leaveq 
  8041cf:	c3                   	retq   

00000000008041d0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8041d0:	55                   	push   %rbp
  8041d1:	48 89 e5             	mov    %rsp,%rbp
  8041d4:	48 83 ec 18          	sub    $0x18,%rsp
  8041d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8041e4:	eb 0f                	jmp    8041f5 <strncmp+0x25>
		n--, p++, q++;
  8041e6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8041eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8041f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041fa:	74 1d                	je     804219 <strncmp+0x49>
  8041fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804200:	0f b6 00             	movzbl (%rax),%eax
  804203:	84 c0                	test   %al,%al
  804205:	74 12                	je     804219 <strncmp+0x49>
  804207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420b:	0f b6 10             	movzbl (%rax),%edx
  80420e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804212:	0f b6 00             	movzbl (%rax),%eax
  804215:	38 c2                	cmp    %al,%dl
  804217:	74 cd                	je     8041e6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804219:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80421e:	75 07                	jne    804227 <strncmp+0x57>
		return 0;
  804220:	b8 00 00 00 00       	mov    $0x0,%eax
  804225:	eb 18                	jmp    80423f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422b:	0f b6 00             	movzbl (%rax),%eax
  80422e:	0f b6 d0             	movzbl %al,%edx
  804231:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804235:	0f b6 00             	movzbl (%rax),%eax
  804238:	0f b6 c0             	movzbl %al,%eax
  80423b:	29 c2                	sub    %eax,%edx
  80423d:	89 d0                	mov    %edx,%eax
}
  80423f:	c9                   	leaveq 
  804240:	c3                   	retq   

0000000000804241 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  804241:	55                   	push   %rbp
  804242:	48 89 e5             	mov    %rsp,%rbp
  804245:	48 83 ec 0c          	sub    $0xc,%rsp
  804249:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80424d:	89 f0                	mov    %esi,%eax
  80424f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804252:	eb 17                	jmp    80426b <strchr+0x2a>
		if (*s == c)
  804254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804258:	0f b6 00             	movzbl (%rax),%eax
  80425b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80425e:	75 06                	jne    804266 <strchr+0x25>
			return (char *) s;
  804260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804264:	eb 15                	jmp    80427b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804266:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80426b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80426f:	0f b6 00             	movzbl (%rax),%eax
  804272:	84 c0                	test   %al,%al
  804274:	75 de                	jne    804254 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80427b:	c9                   	leaveq 
  80427c:	c3                   	retq   

000000000080427d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80427d:	55                   	push   %rbp
  80427e:	48 89 e5             	mov    %rsp,%rbp
  804281:	48 83 ec 0c          	sub    $0xc,%rsp
  804285:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804289:	89 f0                	mov    %esi,%eax
  80428b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80428e:	eb 13                	jmp    8042a3 <strfind+0x26>
		if (*s == c)
  804290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804294:	0f b6 00             	movzbl (%rax),%eax
  804297:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80429a:	75 02                	jne    80429e <strfind+0x21>
			break;
  80429c:	eb 10                	jmp    8042ae <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80429e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a7:	0f b6 00             	movzbl (%rax),%eax
  8042aa:	84 c0                	test   %al,%al
  8042ac:	75 e2                	jne    804290 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8042ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042b2:	c9                   	leaveq 
  8042b3:	c3                   	retq   

00000000008042b4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8042b4:	55                   	push   %rbp
  8042b5:	48 89 e5             	mov    %rsp,%rbp
  8042b8:	48 83 ec 18          	sub    $0x18,%rsp
  8042bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8042c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8042c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042cc:	75 06                	jne    8042d4 <memset+0x20>
		return v;
  8042ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d2:	eb 69                	jmp    80433d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8042d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d8:	83 e0 03             	and    $0x3,%eax
  8042db:	48 85 c0             	test   %rax,%rax
  8042de:	75 48                	jne    804328 <memset+0x74>
  8042e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e4:	83 e0 03             	and    $0x3,%eax
  8042e7:	48 85 c0             	test   %rax,%rax
  8042ea:	75 3c                	jne    804328 <memset+0x74>
		c &= 0xFF;
  8042ec:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8042f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042f6:	c1 e0 18             	shl    $0x18,%eax
  8042f9:	89 c2                	mov    %eax,%edx
  8042fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042fe:	c1 e0 10             	shl    $0x10,%eax
  804301:	09 c2                	or     %eax,%edx
  804303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804306:	c1 e0 08             	shl    $0x8,%eax
  804309:	09 d0                	or     %edx,%eax
  80430b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80430e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804312:	48 c1 e8 02          	shr    $0x2,%rax
  804316:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804319:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80431d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804320:	48 89 d7             	mov    %rdx,%rdi
  804323:	fc                   	cld    
  804324:	f3 ab                	rep stos %eax,%es:(%rdi)
  804326:	eb 11                	jmp    804339 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804328:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80432c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80432f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804333:	48 89 d7             	mov    %rdx,%rdi
  804336:	fc                   	cld    
  804337:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80433d:	c9                   	leaveq 
  80433e:	c3                   	retq   

000000000080433f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80433f:	55                   	push   %rbp
  804340:	48 89 e5             	mov    %rsp,%rbp
  804343:	48 83 ec 28          	sub    $0x28,%rsp
  804347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80434b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80434f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  804353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804357:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80435b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80435f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804367:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80436b:	0f 83 88 00 00 00    	jae    8043f9 <memmove+0xba>
  804371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804375:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804379:	48 01 d0             	add    %rdx,%rax
  80437c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804380:	76 77                	jbe    8043f9 <memmove+0xba>
		s += n;
  804382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804386:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80438a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80438e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804396:	83 e0 03             	and    $0x3,%eax
  804399:	48 85 c0             	test   %rax,%rax
  80439c:	75 3b                	jne    8043d9 <memmove+0x9a>
  80439e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a2:	83 e0 03             	and    $0x3,%eax
  8043a5:	48 85 c0             	test   %rax,%rax
  8043a8:	75 2f                	jne    8043d9 <memmove+0x9a>
  8043aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ae:	83 e0 03             	and    $0x3,%eax
  8043b1:	48 85 c0             	test   %rax,%rax
  8043b4:	75 23                	jne    8043d9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8043b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ba:	48 83 e8 04          	sub    $0x4,%rax
  8043be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043c2:	48 83 ea 04          	sub    $0x4,%rdx
  8043c6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8043ca:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8043ce:	48 89 c7             	mov    %rax,%rdi
  8043d1:	48 89 d6             	mov    %rdx,%rsi
  8043d4:	fd                   	std    
  8043d5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8043d7:	eb 1d                	jmp    8043f6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8043d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043dd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8043e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8043e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ed:	48 89 d7             	mov    %rdx,%rdi
  8043f0:	48 89 c1             	mov    %rax,%rcx
  8043f3:	fd                   	std    
  8043f4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8043f6:	fc                   	cld    
  8043f7:	eb 57                	jmp    804450 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8043f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043fd:	83 e0 03             	and    $0x3,%eax
  804400:	48 85 c0             	test   %rax,%rax
  804403:	75 36                	jne    80443b <memmove+0xfc>
  804405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804409:	83 e0 03             	and    $0x3,%eax
  80440c:	48 85 c0             	test   %rax,%rax
  80440f:	75 2a                	jne    80443b <memmove+0xfc>
  804411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804415:	83 e0 03             	and    $0x3,%eax
  804418:	48 85 c0             	test   %rax,%rax
  80441b:	75 1e                	jne    80443b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80441d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804421:	48 c1 e8 02          	shr    $0x2,%rax
  804425:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804430:	48 89 c7             	mov    %rax,%rdi
  804433:	48 89 d6             	mov    %rdx,%rsi
  804436:	fc                   	cld    
  804437:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804439:	eb 15                	jmp    804450 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80443b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804443:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804447:	48 89 c7             	mov    %rax,%rdi
  80444a:	48 89 d6             	mov    %rdx,%rsi
  80444d:	fc                   	cld    
  80444e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  804450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804454:	c9                   	leaveq 
  804455:	c3                   	retq   

0000000000804456 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804456:	55                   	push   %rbp
  804457:	48 89 e5             	mov    %rsp,%rbp
  80445a:	48 83 ec 18          	sub    $0x18,%rsp
  80445e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804462:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804466:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80446a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80446e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804476:	48 89 ce             	mov    %rcx,%rsi
  804479:	48 89 c7             	mov    %rax,%rdi
  80447c:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  804483:	00 00 00 
  804486:	ff d0                	callq  *%rax
}
  804488:	c9                   	leaveq 
  804489:	c3                   	retq   

000000000080448a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80448a:	55                   	push   %rbp
  80448b:	48 89 e5             	mov    %rsp,%rbp
  80448e:	48 83 ec 28          	sub    $0x28,%rsp
  804492:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804496:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80449a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80449e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8044a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8044ae:	eb 36                	jmp    8044e6 <memcmp+0x5c>
		if (*s1 != *s2)
  8044b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b4:	0f b6 10             	movzbl (%rax),%edx
  8044b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bb:	0f b6 00             	movzbl (%rax),%eax
  8044be:	38 c2                	cmp    %al,%dl
  8044c0:	74 1a                	je     8044dc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8044c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c6:	0f b6 00             	movzbl (%rax),%eax
  8044c9:	0f b6 d0             	movzbl %al,%edx
  8044cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d0:	0f b6 00             	movzbl (%rax),%eax
  8044d3:	0f b6 c0             	movzbl %al,%eax
  8044d6:	29 c2                	sub    %eax,%edx
  8044d8:	89 d0                	mov    %edx,%eax
  8044da:	eb 20                	jmp    8044fc <memcmp+0x72>
		s1++, s2++;
  8044dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044e1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8044e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ea:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8044ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8044f2:	48 85 c0             	test   %rax,%rax
  8044f5:	75 b9                	jne    8044b0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8044f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044fc:	c9                   	leaveq 
  8044fd:	c3                   	retq   

00000000008044fe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8044fe:	55                   	push   %rbp
  8044ff:	48 89 e5             	mov    %rsp,%rbp
  804502:	48 83 ec 28          	sub    $0x28,%rsp
  804506:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80450a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80450d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  804511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804515:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804519:	48 01 d0             	add    %rdx,%rax
  80451c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  804520:	eb 15                	jmp    804537 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  804522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804526:	0f b6 10             	movzbl (%rax),%edx
  804529:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80452c:	38 c2                	cmp    %al,%dl
  80452e:	75 02                	jne    804532 <memfind+0x34>
			break;
  804530:	eb 0f                	jmp    804541 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804532:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80453b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80453f:	72 e1                	jb     804522 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  804541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804545:	c9                   	leaveq 
  804546:	c3                   	retq   

0000000000804547 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804547:	55                   	push   %rbp
  804548:	48 89 e5             	mov    %rsp,%rbp
  80454b:	48 83 ec 34          	sub    $0x34,%rsp
  80454f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804553:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804557:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80455a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804561:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804568:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804569:	eb 05                	jmp    804570 <strtol+0x29>
		s++;
  80456b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804574:	0f b6 00             	movzbl (%rax),%eax
  804577:	3c 20                	cmp    $0x20,%al
  804579:	74 f0                	je     80456b <strtol+0x24>
  80457b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80457f:	0f b6 00             	movzbl (%rax),%eax
  804582:	3c 09                	cmp    $0x9,%al
  804584:	74 e5                	je     80456b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  804586:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80458a:	0f b6 00             	movzbl (%rax),%eax
  80458d:	3c 2b                	cmp    $0x2b,%al
  80458f:	75 07                	jne    804598 <strtol+0x51>
		s++;
  804591:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804596:	eb 17                	jmp    8045af <strtol+0x68>
	else if (*s == '-')
  804598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80459c:	0f b6 00             	movzbl (%rax),%eax
  80459f:	3c 2d                	cmp    $0x2d,%al
  8045a1:	75 0c                	jne    8045af <strtol+0x68>
		s++, neg = 1;
  8045a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8045a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8045af:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8045b3:	74 06                	je     8045bb <strtol+0x74>
  8045b5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8045b9:	75 28                	jne    8045e3 <strtol+0x9c>
  8045bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045bf:	0f b6 00             	movzbl (%rax),%eax
  8045c2:	3c 30                	cmp    $0x30,%al
  8045c4:	75 1d                	jne    8045e3 <strtol+0x9c>
  8045c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ca:	48 83 c0 01          	add    $0x1,%rax
  8045ce:	0f b6 00             	movzbl (%rax),%eax
  8045d1:	3c 78                	cmp    $0x78,%al
  8045d3:	75 0e                	jne    8045e3 <strtol+0x9c>
		s += 2, base = 16;
  8045d5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8045da:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8045e1:	eb 2c                	jmp    80460f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8045e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8045e7:	75 19                	jne    804602 <strtol+0xbb>
  8045e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ed:	0f b6 00             	movzbl (%rax),%eax
  8045f0:	3c 30                	cmp    $0x30,%al
  8045f2:	75 0e                	jne    804602 <strtol+0xbb>
		s++, base = 8;
  8045f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8045f9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  804600:	eb 0d                	jmp    80460f <strtol+0xc8>
	else if (base == 0)
  804602:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804606:	75 07                	jne    80460f <strtol+0xc8>
		base = 10;
  804608:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80460f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804613:	0f b6 00             	movzbl (%rax),%eax
  804616:	3c 2f                	cmp    $0x2f,%al
  804618:	7e 1d                	jle    804637 <strtol+0xf0>
  80461a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461e:	0f b6 00             	movzbl (%rax),%eax
  804621:	3c 39                	cmp    $0x39,%al
  804623:	7f 12                	jg     804637 <strtol+0xf0>
			dig = *s - '0';
  804625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804629:	0f b6 00             	movzbl (%rax),%eax
  80462c:	0f be c0             	movsbl %al,%eax
  80462f:	83 e8 30             	sub    $0x30,%eax
  804632:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804635:	eb 4e                	jmp    804685 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80463b:	0f b6 00             	movzbl (%rax),%eax
  80463e:	3c 60                	cmp    $0x60,%al
  804640:	7e 1d                	jle    80465f <strtol+0x118>
  804642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804646:	0f b6 00             	movzbl (%rax),%eax
  804649:	3c 7a                	cmp    $0x7a,%al
  80464b:	7f 12                	jg     80465f <strtol+0x118>
			dig = *s - 'a' + 10;
  80464d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804651:	0f b6 00             	movzbl (%rax),%eax
  804654:	0f be c0             	movsbl %al,%eax
  804657:	83 e8 57             	sub    $0x57,%eax
  80465a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80465d:	eb 26                	jmp    804685 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80465f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804663:	0f b6 00             	movzbl (%rax),%eax
  804666:	3c 40                	cmp    $0x40,%al
  804668:	7e 48                	jle    8046b2 <strtol+0x16b>
  80466a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80466e:	0f b6 00             	movzbl (%rax),%eax
  804671:	3c 5a                	cmp    $0x5a,%al
  804673:	7f 3d                	jg     8046b2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  804675:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804679:	0f b6 00             	movzbl (%rax),%eax
  80467c:	0f be c0             	movsbl %al,%eax
  80467f:	83 e8 37             	sub    $0x37,%eax
  804682:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804685:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804688:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80468b:	7c 02                	jl     80468f <strtol+0x148>
			break;
  80468d:	eb 23                	jmp    8046b2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80468f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804694:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804697:	48 98                	cltq   
  804699:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80469e:	48 89 c2             	mov    %rax,%rdx
  8046a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046a4:	48 98                	cltq   
  8046a6:	48 01 d0             	add    %rdx,%rax
  8046a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8046ad:	e9 5d ff ff ff       	jmpq   80460f <strtol+0xc8>

	if (endptr)
  8046b2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8046b7:	74 0b                	je     8046c4 <strtol+0x17d>
		*endptr = (char *) s;
  8046b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8046c1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8046c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046c8:	74 09                	je     8046d3 <strtol+0x18c>
  8046ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ce:	48 f7 d8             	neg    %rax
  8046d1:	eb 04                	jmp    8046d7 <strtol+0x190>
  8046d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8046d7:	c9                   	leaveq 
  8046d8:	c3                   	retq   

00000000008046d9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8046d9:	55                   	push   %rbp
  8046da:	48 89 e5             	mov    %rsp,%rbp
  8046dd:	48 83 ec 30          	sub    $0x30,%rsp
  8046e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8046e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046f1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8046f5:	0f b6 00             	movzbl (%rax),%eax
  8046f8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8046fb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8046ff:	75 06                	jne    804707 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  804701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804705:	eb 6b                	jmp    804772 <strstr+0x99>

	len = strlen(str);
  804707:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80470b:	48 89 c7             	mov    %rax,%rdi
  80470e:	48 b8 af 3f 80 00 00 	movabs $0x803faf,%rax
  804715:	00 00 00 
  804718:	ff d0                	callq  *%rax
  80471a:	48 98                	cltq   
  80471c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804724:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804728:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80472c:	0f b6 00             	movzbl (%rax),%eax
  80472f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804732:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804736:	75 07                	jne    80473f <strstr+0x66>
				return (char *) 0;
  804738:	b8 00 00 00 00       	mov    $0x0,%eax
  80473d:	eb 33                	jmp    804772 <strstr+0x99>
		} while (sc != c);
  80473f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804743:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804746:	75 d8                	jne    804720 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80474c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804754:	48 89 ce             	mov    %rcx,%rsi
  804757:	48 89 c7             	mov    %rax,%rdi
  80475a:	48 b8 d0 41 80 00 00 	movabs $0x8041d0,%rax
  804761:	00 00 00 
  804764:	ff d0                	callq  *%rax
  804766:	85 c0                	test   %eax,%eax
  804768:	75 b6                	jne    804720 <strstr+0x47>

	return (char *) (in - 1);
  80476a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80476e:	48 83 e8 01          	sub    $0x1,%rax
}
  804772:	c9                   	leaveq 
  804773:	c3                   	retq   

0000000000804774 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804774:	55                   	push   %rbp
  804775:	48 89 e5             	mov    %rsp,%rbp
  804778:	53                   	push   %rbx
  804779:	48 83 ec 48          	sub    $0x48,%rsp
  80477d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804780:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804783:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804787:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80478b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80478f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  804793:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804796:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80479a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80479e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8047a2:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8047a6:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8047aa:	4c 89 c3             	mov    %r8,%rbx
  8047ad:	cd 30                	int    $0x30
  8047af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8047b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8047b7:	74 3e                	je     8047f7 <syscall+0x83>
  8047b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047be:	7e 37                	jle    8047f7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8047c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047c4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8047c7:	49 89 d0             	mov    %rdx,%r8
  8047ca:	89 c1                	mov    %eax,%ecx
  8047cc:	48 ba 68 72 80 00 00 	movabs $0x807268,%rdx
  8047d3:	00 00 00 
  8047d6:	be 4a 00 00 00       	mov    $0x4a,%esi
  8047db:	48 bf 85 72 80 00 00 	movabs $0x807285,%rdi
  8047e2:	00 00 00 
  8047e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ea:	49 b9 2d 32 80 00 00 	movabs $0x80322d,%r9
  8047f1:	00 00 00 
  8047f4:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8047f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8047fb:	48 83 c4 48          	add    $0x48,%rsp
  8047ff:	5b                   	pop    %rbx
  804800:	5d                   	pop    %rbp
  804801:	c3                   	retq   

0000000000804802 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804802:	55                   	push   %rbp
  804803:	48 89 e5             	mov    %rsp,%rbp
  804806:	48 83 ec 20          	sub    $0x20,%rsp
  80480a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80480e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804816:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80481a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804821:	00 
  804822:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804828:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80482e:	48 89 d1             	mov    %rdx,%rcx
  804831:	48 89 c2             	mov    %rax,%rdx
  804834:	be 00 00 00 00       	mov    $0x0,%esi
  804839:	bf 00 00 00 00       	mov    $0x0,%edi
  80483e:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804845:	00 00 00 
  804848:	ff d0                	callq  *%rax
}
  80484a:	c9                   	leaveq 
  80484b:	c3                   	retq   

000000000080484c <sys_cgetc>:

int
sys_cgetc(void)
{
  80484c:	55                   	push   %rbp
  80484d:	48 89 e5             	mov    %rsp,%rbp
  804850:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804854:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80485b:	00 
  80485c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804862:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804868:	b9 00 00 00 00       	mov    $0x0,%ecx
  80486d:	ba 00 00 00 00       	mov    $0x0,%edx
  804872:	be 00 00 00 00       	mov    $0x0,%esi
  804877:	bf 01 00 00 00       	mov    $0x1,%edi
  80487c:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804883:	00 00 00 
  804886:	ff d0                	callq  *%rax
}
  804888:	c9                   	leaveq 
  804889:	c3                   	retq   

000000000080488a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80488a:	55                   	push   %rbp
  80488b:	48 89 e5             	mov    %rsp,%rbp
  80488e:	48 83 ec 10          	sub    $0x10,%rsp
  804892:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804898:	48 98                	cltq   
  80489a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048a1:	00 
  8048a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048b3:	48 89 c2             	mov    %rax,%rdx
  8048b6:	be 01 00 00 00       	mov    $0x1,%esi
  8048bb:	bf 03 00 00 00       	mov    $0x3,%edi
  8048c0:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  8048c7:	00 00 00 
  8048ca:	ff d0                	callq  *%rax
}
  8048cc:	c9                   	leaveq 
  8048cd:	c3                   	retq   

00000000008048ce <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8048ce:	55                   	push   %rbp
  8048cf:	48 89 e5             	mov    %rsp,%rbp
  8048d2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8048d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8048dd:	00 
  8048de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8048f4:	be 00 00 00 00       	mov    $0x0,%esi
  8048f9:	bf 02 00 00 00       	mov    $0x2,%edi
  8048fe:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804905:	00 00 00 
  804908:	ff d0                	callq  *%rax
}
  80490a:	c9                   	leaveq 
  80490b:	c3                   	retq   

000000000080490c <sys_yield>:

void
sys_yield(void)
{
  80490c:	55                   	push   %rbp
  80490d:	48 89 e5             	mov    %rsp,%rbp
  804910:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804914:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80491b:	00 
  80491c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804922:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804928:	b9 00 00 00 00       	mov    $0x0,%ecx
  80492d:	ba 00 00 00 00       	mov    $0x0,%edx
  804932:	be 00 00 00 00       	mov    $0x0,%esi
  804937:	bf 0b 00 00 00       	mov    $0xb,%edi
  80493c:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804943:	00 00 00 
  804946:	ff d0                	callq  *%rax
}
  804948:	c9                   	leaveq 
  804949:	c3                   	retq   

000000000080494a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80494a:	55                   	push   %rbp
  80494b:	48 89 e5             	mov    %rsp,%rbp
  80494e:	48 83 ec 20          	sub    $0x20,%rsp
  804952:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804955:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804959:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80495c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80495f:	48 63 c8             	movslq %eax,%rcx
  804962:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804966:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804969:	48 98                	cltq   
  80496b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804972:	00 
  804973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804979:	49 89 c8             	mov    %rcx,%r8
  80497c:	48 89 d1             	mov    %rdx,%rcx
  80497f:	48 89 c2             	mov    %rax,%rdx
  804982:	be 01 00 00 00       	mov    $0x1,%esi
  804987:	bf 04 00 00 00       	mov    $0x4,%edi
  80498c:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804993:	00 00 00 
  804996:	ff d0                	callq  *%rax
}
  804998:	c9                   	leaveq 
  804999:	c3                   	retq   

000000000080499a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80499a:	55                   	push   %rbp
  80499b:	48 89 e5             	mov    %rsp,%rbp
  80499e:	48 83 ec 30          	sub    $0x30,%rsp
  8049a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8049a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8049ac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8049b0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8049b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8049b7:	48 63 c8             	movslq %eax,%rcx
  8049ba:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8049be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049c1:	48 63 f0             	movslq %eax,%rsi
  8049c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049cb:	48 98                	cltq   
  8049cd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8049d1:	49 89 f9             	mov    %rdi,%r9
  8049d4:	49 89 f0             	mov    %rsi,%r8
  8049d7:	48 89 d1             	mov    %rdx,%rcx
  8049da:	48 89 c2             	mov    %rax,%rdx
  8049dd:	be 01 00 00 00       	mov    $0x1,%esi
  8049e2:	bf 05 00 00 00       	mov    $0x5,%edi
  8049e7:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  8049ee:	00 00 00 
  8049f1:	ff d0                	callq  *%rax
}
  8049f3:	c9                   	leaveq 
  8049f4:	c3                   	retq   

00000000008049f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8049f5:	55                   	push   %rbp
  8049f6:	48 89 e5             	mov    %rsp,%rbp
  8049f9:	48 83 ec 20          	sub    $0x20,%rsp
  8049fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804a04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a0b:	48 98                	cltq   
  804a0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a14:	00 
  804a15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a21:	48 89 d1             	mov    %rdx,%rcx
  804a24:	48 89 c2             	mov    %rax,%rdx
  804a27:	be 01 00 00 00       	mov    $0x1,%esi
  804a2c:	bf 06 00 00 00       	mov    $0x6,%edi
  804a31:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804a38:	00 00 00 
  804a3b:	ff d0                	callq  *%rax
}
  804a3d:	c9                   	leaveq 
  804a3e:	c3                   	retq   

0000000000804a3f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804a3f:	55                   	push   %rbp
  804a40:	48 89 e5             	mov    %rsp,%rbp
  804a43:	48 83 ec 10          	sub    $0x10,%rsp
  804a47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a4a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804a4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a50:	48 63 d0             	movslq %eax,%rdx
  804a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a56:	48 98                	cltq   
  804a58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a5f:	00 
  804a60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a6c:	48 89 d1             	mov    %rdx,%rcx
  804a6f:	48 89 c2             	mov    %rax,%rdx
  804a72:	be 01 00 00 00       	mov    $0x1,%esi
  804a77:	bf 08 00 00 00       	mov    $0x8,%edi
  804a7c:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804a83:	00 00 00 
  804a86:	ff d0                	callq  *%rax
}
  804a88:	c9                   	leaveq 
  804a89:	c3                   	retq   

0000000000804a8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804a8a:	55                   	push   %rbp
  804a8b:	48 89 e5             	mov    %rsp,%rbp
  804a8e:	48 83 ec 20          	sub    $0x20,%rsp
  804a92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804a99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aa0:	48 98                	cltq   
  804aa2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804aa9:	00 
  804aaa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ab0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ab6:	48 89 d1             	mov    %rdx,%rcx
  804ab9:	48 89 c2             	mov    %rax,%rdx
  804abc:	be 01 00 00 00       	mov    $0x1,%esi
  804ac1:	bf 09 00 00 00       	mov    $0x9,%edi
  804ac6:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804acd:	00 00 00 
  804ad0:	ff d0                	callq  *%rax
}
  804ad2:	c9                   	leaveq 
  804ad3:	c3                   	retq   

0000000000804ad4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804ad4:	55                   	push   %rbp
  804ad5:	48 89 e5             	mov    %rsp,%rbp
  804ad8:	48 83 ec 20          	sub    $0x20,%rsp
  804adc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804adf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804ae3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aea:	48 98                	cltq   
  804aec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804af3:	00 
  804af4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804afa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b00:	48 89 d1             	mov    %rdx,%rcx
  804b03:	48 89 c2             	mov    %rax,%rdx
  804b06:	be 01 00 00 00       	mov    $0x1,%esi
  804b0b:	bf 0a 00 00 00       	mov    $0xa,%edi
  804b10:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804b17:	00 00 00 
  804b1a:	ff d0                	callq  *%rax
}
  804b1c:	c9                   	leaveq 
  804b1d:	c3                   	retq   

0000000000804b1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804b1e:	55                   	push   %rbp
  804b1f:	48 89 e5             	mov    %rsp,%rbp
  804b22:	48 83 ec 20          	sub    $0x20,%rsp
  804b26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804b31:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b37:	48 63 f0             	movslq %eax,%rsi
  804b3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b41:	48 98                	cltq   
  804b43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b4e:	00 
  804b4f:	49 89 f1             	mov    %rsi,%r9
  804b52:	49 89 c8             	mov    %rcx,%r8
  804b55:	48 89 d1             	mov    %rdx,%rcx
  804b58:	48 89 c2             	mov    %rax,%rdx
  804b5b:	be 00 00 00 00       	mov    $0x0,%esi
  804b60:	bf 0c 00 00 00       	mov    $0xc,%edi
  804b65:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804b6c:	00 00 00 
  804b6f:	ff d0                	callq  *%rax
}
  804b71:	c9                   	leaveq 
  804b72:	c3                   	retq   

0000000000804b73 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804b73:	55                   	push   %rbp
  804b74:	48 89 e5             	mov    %rsp,%rbp
  804b77:	48 83 ec 10          	sub    $0x10,%rsp
  804b7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b83:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b8a:	00 
  804b8b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b9c:	48 89 c2             	mov    %rax,%rdx
  804b9f:	be 01 00 00 00       	mov    $0x1,%esi
  804ba4:	bf 0d 00 00 00       	mov    $0xd,%edi
  804ba9:	48 b8 74 47 80 00 00 	movabs $0x804774,%rax
  804bb0:	00 00 00 
  804bb3:	ff d0                	callq  *%rax
}
  804bb5:	c9                   	leaveq 
  804bb6:	c3                   	retq   

0000000000804bb7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804bb7:	55                   	push   %rbp
  804bb8:	48 89 e5             	mov    %rsp,%rbp
  804bbb:	48 83 ec 10          	sub    $0x10,%rsp
  804bbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804bc3:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804bca:	00 00 00 
  804bcd:	48 8b 00             	mov    (%rax),%rax
  804bd0:	48 85 c0             	test   %rax,%rax
  804bd3:	75 64                	jne    804c39 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  804bd5:	ba 07 00 00 00       	mov    $0x7,%edx
  804bda:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  804be4:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  804beb:	00 00 00 
  804bee:	ff d0                	callq  *%rax
  804bf0:	85 c0                	test   %eax,%eax
  804bf2:	74 2a                	je     804c1e <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  804bf4:	48 ba 98 72 80 00 00 	movabs $0x807298,%rdx
  804bfb:	00 00 00 
  804bfe:	be 22 00 00 00       	mov    $0x22,%esi
  804c03:	48 bf c0 72 80 00 00 	movabs $0x8072c0,%rdi
  804c0a:	00 00 00 
  804c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  804c12:	48 b9 2d 32 80 00 00 	movabs $0x80322d,%rcx
  804c19:	00 00 00 
  804c1c:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804c1e:	48 be 4c 4c 80 00 00 	movabs $0x804c4c,%rsi
  804c25:	00 00 00 
  804c28:	bf 00 00 00 00       	mov    $0x0,%edi
  804c2d:	48 b8 d4 4a 80 00 00 	movabs $0x804ad4,%rax
  804c34:	00 00 00 
  804c37:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804c39:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804c40:	00 00 00 
  804c43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c47:	48 89 10             	mov    %rdx,(%rax)
}
  804c4a:	c9                   	leaveq 
  804c4b:	c3                   	retq   

0000000000804c4c <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  804c4c:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804c4f:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804c56:	00 00 00 
call *%rax
  804c59:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  804c5b:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  804c62:	00 
mov 136(%rsp), %r9
  804c63:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  804c6a:	00 
sub $8, %r8
  804c6b:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  804c6f:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  804c72:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  804c79:	00 
add $16, %rsp
  804c7a:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  804c7e:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c82:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c87:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c8c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c91:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c96:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c9b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804ca0:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804ca5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804caa:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804caf:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804cb4:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804cb9:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804cbe:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804cc3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804cc8:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  804ccc:	48 83 c4 08          	add    $0x8,%rsp
popf
  804cd0:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  804cd1:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  804cd5:	c3                   	retq   

0000000000804cd6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804cd6:	55                   	push   %rbp
  804cd7:	48 89 e5             	mov    %rsp,%rbp
  804cda:	48 83 ec 30          	sub    $0x30,%rsp
  804cde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ce2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ce6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  804cea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804cef:	74 18                	je     804d09 <ipc_recv+0x33>
  804cf1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cf5:	48 89 c7             	mov    %rax,%rdi
  804cf8:	48 b8 73 4b 80 00 00 	movabs $0x804b73,%rax
  804cff:	00 00 00 
  804d02:	ff d0                	callq  *%rax
  804d04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d07:	eb 19                	jmp    804d22 <ipc_recv+0x4c>
  804d09:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804d10:	00 00 00 
  804d13:	48 b8 73 4b 80 00 00 	movabs $0x804b73,%rax
  804d1a:	00 00 00 
  804d1d:	ff d0                	callq  *%rax
  804d1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  804d22:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804d27:	74 26                	je     804d4f <ipc_recv+0x79>
  804d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d2d:	75 15                	jne    804d44 <ipc_recv+0x6e>
  804d2f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d36:	00 00 00 
  804d39:	48 8b 00             	mov    (%rax),%rax
  804d3c:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804d42:	eb 05                	jmp    804d49 <ipc_recv+0x73>
  804d44:	b8 00 00 00 00       	mov    $0x0,%eax
  804d49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804d4d:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  804d4f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d54:	74 26                	je     804d7c <ipc_recv+0xa6>
  804d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d5a:	75 15                	jne    804d71 <ipc_recv+0x9b>
  804d5c:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d63:	00 00 00 
  804d66:	48 8b 00             	mov    (%rax),%rax
  804d69:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804d6f:	eb 05                	jmp    804d76 <ipc_recv+0xa0>
  804d71:	b8 00 00 00 00       	mov    $0x0,%eax
  804d76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804d7a:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  804d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d80:	75 15                	jne    804d97 <ipc_recv+0xc1>
  804d82:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804d89:	00 00 00 
  804d8c:	48 8b 00             	mov    (%rax),%rax
  804d8f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804d95:	eb 03                	jmp    804d9a <ipc_recv+0xc4>
  804d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804d9a:	c9                   	leaveq 
  804d9b:	c3                   	retq   

0000000000804d9c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d9c:	55                   	push   %rbp
  804d9d:	48 89 e5             	mov    %rsp,%rbp
  804da0:	48 83 ec 30          	sub    $0x30,%rsp
  804da4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804da7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804daa:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804dae:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  804db1:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  804db8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804dbd:	75 10                	jne    804dcf <ipc_send+0x33>
  804dbf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804dc6:	00 00 00 
  804dc9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  804dcd:	eb 62                	jmp    804e31 <ipc_send+0x95>
  804dcf:	eb 60                	jmp    804e31 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  804dd1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804dd5:	74 30                	je     804e07 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  804dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dda:	89 c1                	mov    %eax,%ecx
  804ddc:	48 ba ce 72 80 00 00 	movabs $0x8072ce,%rdx
  804de3:	00 00 00 
  804de6:	be 33 00 00 00       	mov    $0x33,%esi
  804deb:	48 bf ea 72 80 00 00 	movabs $0x8072ea,%rdi
  804df2:	00 00 00 
  804df5:	b8 00 00 00 00       	mov    $0x0,%eax
  804dfa:	49 b8 2d 32 80 00 00 	movabs $0x80322d,%r8
  804e01:	00 00 00 
  804e04:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  804e07:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804e0a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804e0d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804e11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e14:	89 c7                	mov    %eax,%edi
  804e16:	48 b8 1e 4b 80 00 00 	movabs $0x804b1e,%rax
  804e1d:	00 00 00 
  804e20:	ff d0                	callq  *%rax
  804e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  804e25:	48 b8 0c 49 80 00 00 	movabs $0x80490c,%rax
  804e2c:	00 00 00 
  804e2f:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  804e31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e35:	75 9a                	jne    804dd1 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  804e37:	c9                   	leaveq 
  804e38:	c3                   	retq   

0000000000804e39 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804e39:	55                   	push   %rbp
  804e3a:	48 89 e5             	mov    %rsp,%rbp
  804e3d:	48 83 ec 14          	sub    $0x14,%rsp
  804e41:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804e44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e4b:	eb 5e                	jmp    804eab <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804e4d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e54:	00 00 00 
  804e57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e5a:	48 63 d0             	movslq %eax,%rdx
  804e5d:	48 89 d0             	mov    %rdx,%rax
  804e60:	48 c1 e0 03          	shl    $0x3,%rax
  804e64:	48 01 d0             	add    %rdx,%rax
  804e67:	48 c1 e0 05          	shl    $0x5,%rax
  804e6b:	48 01 c8             	add    %rcx,%rax
  804e6e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804e74:	8b 00                	mov    (%rax),%eax
  804e76:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804e79:	75 2c                	jne    804ea7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804e7b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804e82:	00 00 00 
  804e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e88:	48 63 d0             	movslq %eax,%rdx
  804e8b:	48 89 d0             	mov    %rdx,%rax
  804e8e:	48 c1 e0 03          	shl    $0x3,%rax
  804e92:	48 01 d0             	add    %rdx,%rax
  804e95:	48 c1 e0 05          	shl    $0x5,%rax
  804e99:	48 01 c8             	add    %rcx,%rax
  804e9c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804ea2:	8b 40 08             	mov    0x8(%rax),%eax
  804ea5:	eb 12                	jmp    804eb9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804eab:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804eb2:	7e 99                	jle    804e4d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804eb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804eb9:	c9                   	leaveq 
  804eba:	c3                   	retq   

0000000000804ebb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804ebb:	55                   	push   %rbp
  804ebc:	48 89 e5             	mov    %rsp,%rbp
  804ebf:	48 83 ec 08          	sub    $0x8,%rsp
  804ec3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804ec7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804ecb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804ed2:	ff ff ff 
  804ed5:	48 01 d0             	add    %rdx,%rax
  804ed8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804edc:	c9                   	leaveq 
  804edd:	c3                   	retq   

0000000000804ede <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804ede:	55                   	push   %rbp
  804edf:	48 89 e5             	mov    %rsp,%rbp
  804ee2:	48 83 ec 08          	sub    $0x8,%rsp
  804ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804eea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804eee:	48 89 c7             	mov    %rax,%rdi
  804ef1:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  804ef8:	00 00 00 
  804efb:	ff d0                	callq  *%rax
  804efd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804f03:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804f07:	c9                   	leaveq 
  804f08:	c3                   	retq   

0000000000804f09 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804f09:	55                   	push   %rbp
  804f0a:	48 89 e5             	mov    %rsp,%rbp
  804f0d:	48 83 ec 18          	sub    $0x18,%rsp
  804f11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804f15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f1c:	eb 6b                	jmp    804f89 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  804f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f21:	48 98                	cltq   
  804f23:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804f29:	48 c1 e0 0c          	shl    $0xc,%rax
  804f2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  804f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f35:	48 c1 e8 15          	shr    $0x15,%rax
  804f39:	48 89 c2             	mov    %rax,%rdx
  804f3c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f43:	01 00 00 
  804f46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f4a:	83 e0 01             	and    $0x1,%eax
  804f4d:	48 85 c0             	test   %rax,%rax
  804f50:	74 21                	je     804f73 <fd_alloc+0x6a>
  804f52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f56:	48 c1 e8 0c          	shr    $0xc,%rax
  804f5a:	48 89 c2             	mov    %rax,%rdx
  804f5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804f64:	01 00 00 
  804f67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804f6b:	83 e0 01             	and    $0x1,%eax
  804f6e:	48 85 c0             	test   %rax,%rax
  804f71:	75 12                	jne    804f85 <fd_alloc+0x7c>
			*fd_store = fd;
  804f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f7b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  804f83:	eb 1a                	jmp    804f9f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804f85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f89:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804f8d:	7e 8f                	jle    804f1e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  804f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804f93:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  804f9a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  804f9f:	c9                   	leaveq 
  804fa0:	c3                   	retq   

0000000000804fa1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  804fa1:	55                   	push   %rbp
  804fa2:	48 89 e5             	mov    %rsp,%rbp
  804fa5:	48 83 ec 20          	sub    $0x20,%rsp
  804fa9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804fac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  804fb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804fb4:	78 06                	js     804fbc <fd_lookup+0x1b>
  804fb6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  804fba:	7e 07                	jle    804fc3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  804fbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804fc1:	eb 6c                	jmp    80502f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  804fc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804fc6:	48 98                	cltq   
  804fc8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804fce:	48 c1 e0 0c          	shl    $0xc,%rax
  804fd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  804fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fda:	48 c1 e8 15          	shr    $0x15,%rax
  804fde:	48 89 c2             	mov    %rax,%rdx
  804fe1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804fe8:	01 00 00 
  804feb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fef:	83 e0 01             	and    $0x1,%eax
  804ff2:	48 85 c0             	test   %rax,%rax
  804ff5:	74 21                	je     805018 <fd_lookup+0x77>
  804ff7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ffb:	48 c1 e8 0c          	shr    $0xc,%rax
  804fff:	48 89 c2             	mov    %rax,%rdx
  805002:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805009:	01 00 00 
  80500c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805010:	83 e0 01             	and    $0x1,%eax
  805013:	48 85 c0             	test   %rax,%rax
  805016:	75 07                	jne    80501f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805018:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80501d:	eb 10                	jmp    80502f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80501f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805023:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805027:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80502a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80502f:	c9                   	leaveq 
  805030:	c3                   	retq   

0000000000805031 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805031:	55                   	push   %rbp
  805032:	48 89 e5             	mov    %rsp,%rbp
  805035:	48 83 ec 30          	sub    $0x30,%rsp
  805039:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80503d:	89 f0                	mov    %esi,%eax
  80503f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805042:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805046:	48 89 c7             	mov    %rax,%rdi
  805049:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  805050:	00 00 00 
  805053:	ff d0                	callq  *%rax
  805055:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805059:	48 89 d6             	mov    %rdx,%rsi
  80505c:	89 c7                	mov    %eax,%edi
  80505e:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  805065:	00 00 00 
  805068:	ff d0                	callq  *%rax
  80506a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80506d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805071:	78 0a                	js     80507d <fd_close+0x4c>
	    || fd != fd2)
  805073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805077:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80507b:	74 12                	je     80508f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80507d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805081:	74 05                	je     805088 <fd_close+0x57>
  805083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805086:	eb 05                	jmp    80508d <fd_close+0x5c>
  805088:	b8 00 00 00 00       	mov    $0x0,%eax
  80508d:	eb 69                	jmp    8050f8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80508f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805093:	8b 00                	mov    (%rax),%eax
  805095:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805099:	48 89 d6             	mov    %rdx,%rsi
  80509c:	89 c7                	mov    %eax,%edi
  80509e:	48 b8 fa 50 80 00 00 	movabs $0x8050fa,%rax
  8050a5:	00 00 00 
  8050a8:	ff d0                	callq  *%rax
  8050aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050b1:	78 2a                	js     8050dd <fd_close+0xac>
		if (dev->dev_close)
  8050b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050b7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8050bb:	48 85 c0             	test   %rax,%rax
  8050be:	74 16                	je     8050d6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8050c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050c4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8050c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8050cc:	48 89 d7             	mov    %rdx,%rdi
  8050cf:	ff d0                	callq  *%rax
  8050d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050d4:	eb 07                	jmp    8050dd <fd_close+0xac>
		else
			r = 0;
  8050d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8050dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050e1:	48 89 c6             	mov    %rax,%rsi
  8050e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8050e9:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  8050f0:	00 00 00 
  8050f3:	ff d0                	callq  *%rax
	return r;
  8050f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8050f8:	c9                   	leaveq 
  8050f9:	c3                   	retq   

00000000008050fa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8050fa:	55                   	push   %rbp
  8050fb:	48 89 e5             	mov    %rsp,%rbp
  8050fe:	48 83 ec 20          	sub    $0x20,%rsp
  805102:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  805109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805110:	eb 41                	jmp    805153 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805112:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805119:	00 00 00 
  80511c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80511f:	48 63 d2             	movslq %edx,%rdx
  805122:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805126:	8b 00                	mov    (%rax),%eax
  805128:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80512b:	75 22                	jne    80514f <dev_lookup+0x55>
			*dev = devtab[i];
  80512d:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805134:	00 00 00 
  805137:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80513a:	48 63 d2             	movslq %edx,%rdx
  80513d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805141:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805145:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805148:	b8 00 00 00 00       	mov    $0x0,%eax
  80514d:	eb 60                	jmp    8051af <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80514f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805153:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  80515a:	00 00 00 
  80515d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805160:	48 63 d2             	movslq %edx,%rdx
  805163:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805167:	48 85 c0             	test   %rax,%rax
  80516a:	75 a6                	jne    805112 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80516c:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805173:	00 00 00 
  805176:	48 8b 00             	mov    (%rax),%rax
  805179:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80517f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805182:	89 c6                	mov    %eax,%esi
  805184:	48 bf f8 72 80 00 00 	movabs $0x8072f8,%rdi
  80518b:	00 00 00 
  80518e:	b8 00 00 00 00       	mov    $0x0,%eax
  805193:	48 b9 66 34 80 00 00 	movabs $0x803466,%rcx
  80519a:	00 00 00 
  80519d:	ff d1                	callq  *%rcx
	*dev = 0;
  80519f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051a3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8051aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8051af:	c9                   	leaveq 
  8051b0:	c3                   	retq   

00000000008051b1 <close>:

int
close(int fdnum)
{
  8051b1:	55                   	push   %rbp
  8051b2:	48 89 e5             	mov    %rsp,%rbp
  8051b5:	48 83 ec 20          	sub    $0x20,%rsp
  8051b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8051bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8051c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8051c3:	48 89 d6             	mov    %rdx,%rsi
  8051c6:	89 c7                	mov    %eax,%edi
  8051c8:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  8051cf:	00 00 00 
  8051d2:	ff d0                	callq  *%rax
  8051d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051db:	79 05                	jns    8051e2 <close+0x31>
		return r;
  8051dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051e0:	eb 18                	jmp    8051fa <close+0x49>
	else
		return fd_close(fd, 1);
  8051e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051e6:	be 01 00 00 00       	mov    $0x1,%esi
  8051eb:	48 89 c7             	mov    %rax,%rdi
  8051ee:	48 b8 31 50 80 00 00 	movabs $0x805031,%rax
  8051f5:	00 00 00 
  8051f8:	ff d0                	callq  *%rax
}
  8051fa:	c9                   	leaveq 
  8051fb:	c3                   	retq   

00000000008051fc <close_all>:

void
close_all(void)
{
  8051fc:	55                   	push   %rbp
  8051fd:	48 89 e5             	mov    %rsp,%rbp
  805200:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80520b:	eb 15                	jmp    805222 <close_all+0x26>
		close(i);
  80520d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805210:	89 c7                	mov    %eax,%edi
  805212:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805219:	00 00 00 
  80521c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80521e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805222:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805226:	7e e5                	jle    80520d <close_all+0x11>
		close(i);
}
  805228:	c9                   	leaveq 
  805229:	c3                   	retq   

000000000080522a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80522a:	55                   	push   %rbp
  80522b:	48 89 e5             	mov    %rsp,%rbp
  80522e:	48 83 ec 40          	sub    $0x40,%rsp
  805232:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805235:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805238:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80523c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80523f:	48 89 d6             	mov    %rdx,%rsi
  805242:	89 c7                	mov    %eax,%edi
  805244:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  80524b:	00 00 00 
  80524e:	ff d0                	callq  *%rax
  805250:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805257:	79 08                	jns    805261 <dup+0x37>
		return r;
  805259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80525c:	e9 70 01 00 00       	jmpq   8053d1 <dup+0x1a7>
	close(newfdnum);
  805261:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805264:	89 c7                	mov    %eax,%edi
  805266:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  80526d:	00 00 00 
  805270:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805272:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805275:	48 98                	cltq   
  805277:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80527d:	48 c1 e0 0c          	shl    $0xc,%rax
  805281:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  805285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805289:	48 89 c7             	mov    %rax,%rdi
  80528c:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  805293:	00 00 00 
  805296:	ff d0                	callq  *%rax
  805298:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80529c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052a0:	48 89 c7             	mov    %rax,%rdi
  8052a3:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  8052aa:	00 00 00 
  8052ad:	ff d0                	callq  *%rax
  8052af:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8052b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052b7:	48 c1 e8 15          	shr    $0x15,%rax
  8052bb:	48 89 c2             	mov    %rax,%rdx
  8052be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8052c5:	01 00 00 
  8052c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052cc:	83 e0 01             	and    $0x1,%eax
  8052cf:	48 85 c0             	test   %rax,%rax
  8052d2:	74 73                	je     805347 <dup+0x11d>
  8052d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8052dc:	48 89 c2             	mov    %rax,%rdx
  8052df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8052e6:	01 00 00 
  8052e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052ed:	83 e0 01             	and    $0x1,%eax
  8052f0:	48 85 c0             	test   %rax,%rax
  8052f3:	74 52                	je     805347 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8052f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8052fd:	48 89 c2             	mov    %rax,%rdx
  805300:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805307:	01 00 00 
  80530a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80530e:	25 07 0e 00 00       	and    $0xe07,%eax
  805313:	89 c1                	mov    %eax,%ecx
  805315:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80531d:	41 89 c8             	mov    %ecx,%r8d
  805320:	48 89 d1             	mov    %rdx,%rcx
  805323:	ba 00 00 00 00       	mov    $0x0,%edx
  805328:	48 89 c6             	mov    %rax,%rsi
  80532b:	bf 00 00 00 00       	mov    $0x0,%edi
  805330:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  805337:	00 00 00 
  80533a:	ff d0                	callq  *%rax
  80533c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80533f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805343:	79 02                	jns    805347 <dup+0x11d>
			goto err;
  805345:	eb 57                	jmp    80539e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  805347:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80534b:	48 c1 e8 0c          	shr    $0xc,%rax
  80534f:	48 89 c2             	mov    %rax,%rdx
  805352:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805359:	01 00 00 
  80535c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805360:	25 07 0e 00 00       	and    $0xe07,%eax
  805365:	89 c1                	mov    %eax,%ecx
  805367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80536b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80536f:	41 89 c8             	mov    %ecx,%r8d
  805372:	48 89 d1             	mov    %rdx,%rcx
  805375:	ba 00 00 00 00       	mov    $0x0,%edx
  80537a:	48 89 c6             	mov    %rax,%rsi
  80537d:	bf 00 00 00 00       	mov    $0x0,%edi
  805382:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  805389:	00 00 00 
  80538c:	ff d0                	callq  *%rax
  80538e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805391:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805395:	79 02                	jns    805399 <dup+0x16f>
		goto err;
  805397:	eb 05                	jmp    80539e <dup+0x174>

	return newfdnum;
  805399:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80539c:	eb 33                	jmp    8053d1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80539e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053a2:	48 89 c6             	mov    %rax,%rsi
  8053a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8053aa:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  8053b1:	00 00 00 
  8053b4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8053b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053ba:	48 89 c6             	mov    %rax,%rsi
  8053bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8053c2:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  8053c9:	00 00 00 
  8053cc:	ff d0                	callq  *%rax
	return r;
  8053ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8053d1:	c9                   	leaveq 
  8053d2:	c3                   	retq   

00000000008053d3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8053d3:	55                   	push   %rbp
  8053d4:	48 89 e5             	mov    %rsp,%rbp
  8053d7:	48 83 ec 40          	sub    $0x40,%rsp
  8053db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8053de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8053e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8053e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8053ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8053ed:	48 89 d6             	mov    %rdx,%rsi
  8053f0:	89 c7                	mov    %eax,%edi
  8053f2:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  8053f9:	00 00 00 
  8053fc:	ff d0                	callq  *%rax
  8053fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805401:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805405:	78 24                	js     80542b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80540b:	8b 00                	mov    (%rax),%eax
  80540d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805411:	48 89 d6             	mov    %rdx,%rsi
  805414:	89 c7                	mov    %eax,%edi
  805416:	48 b8 fa 50 80 00 00 	movabs $0x8050fa,%rax
  80541d:	00 00 00 
  805420:	ff d0                	callq  *%rax
  805422:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805425:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805429:	79 05                	jns    805430 <read+0x5d>
		return r;
  80542b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80542e:	eb 76                	jmp    8054a6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805434:	8b 40 08             	mov    0x8(%rax),%eax
  805437:	83 e0 03             	and    $0x3,%eax
  80543a:	83 f8 01             	cmp    $0x1,%eax
  80543d:	75 3a                	jne    805479 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80543f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805446:	00 00 00 
  805449:	48 8b 00             	mov    (%rax),%rax
  80544c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805452:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805455:	89 c6                	mov    %eax,%esi
  805457:	48 bf 17 73 80 00 00 	movabs $0x807317,%rdi
  80545e:	00 00 00 
  805461:	b8 00 00 00 00       	mov    $0x0,%eax
  805466:	48 b9 66 34 80 00 00 	movabs $0x803466,%rcx
  80546d:	00 00 00 
  805470:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805472:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805477:	eb 2d                	jmp    8054a6 <read+0xd3>
	}
	if (!dev->dev_read)
  805479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80547d:	48 8b 40 10          	mov    0x10(%rax),%rax
  805481:	48 85 c0             	test   %rax,%rax
  805484:	75 07                	jne    80548d <read+0xba>
		return -E_NOT_SUPP;
  805486:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80548b:	eb 19                	jmp    8054a6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80548d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805491:	48 8b 40 10          	mov    0x10(%rax),%rax
  805495:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805499:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80549d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8054a1:	48 89 cf             	mov    %rcx,%rdi
  8054a4:	ff d0                	callq  *%rax
}
  8054a6:	c9                   	leaveq 
  8054a7:	c3                   	retq   

00000000008054a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8054a8:	55                   	push   %rbp
  8054a9:	48 89 e5             	mov    %rsp,%rbp
  8054ac:	48 83 ec 30          	sub    $0x30,%rsp
  8054b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8054b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8054b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8054bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054c2:	eb 49                	jmp    80550d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8054c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054c7:	48 98                	cltq   
  8054c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8054cd:	48 29 c2             	sub    %rax,%rdx
  8054d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054d3:	48 63 c8             	movslq %eax,%rcx
  8054d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8054da:	48 01 c1             	add    %rax,%rcx
  8054dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8054e0:	48 89 ce             	mov    %rcx,%rsi
  8054e3:	89 c7                	mov    %eax,%edi
  8054e5:	48 b8 d3 53 80 00 00 	movabs $0x8053d3,%rax
  8054ec:	00 00 00 
  8054ef:	ff d0                	callq  *%rax
  8054f1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8054f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054f8:	79 05                	jns    8054ff <readn+0x57>
			return m;
  8054fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054fd:	eb 1c                	jmp    80551b <readn+0x73>
		if (m == 0)
  8054ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805503:	75 02                	jne    805507 <readn+0x5f>
			break;
  805505:	eb 11                	jmp    805518 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80550a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80550d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805510:	48 98                	cltq   
  805512:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805516:	72 ac                	jb     8054c4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  805518:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80551b:	c9                   	leaveq 
  80551c:	c3                   	retq   

000000000080551d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80551d:	55                   	push   %rbp
  80551e:	48 89 e5             	mov    %rsp,%rbp
  805521:	48 83 ec 40          	sub    $0x40,%rsp
  805525:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805528:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80552c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805530:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805534:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805537:	48 89 d6             	mov    %rdx,%rsi
  80553a:	89 c7                	mov    %eax,%edi
  80553c:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  805543:	00 00 00 
  805546:	ff d0                	callq  *%rax
  805548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80554b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80554f:	78 24                	js     805575 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805555:	8b 00                	mov    (%rax),%eax
  805557:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80555b:	48 89 d6             	mov    %rdx,%rsi
  80555e:	89 c7                	mov    %eax,%edi
  805560:	48 b8 fa 50 80 00 00 	movabs $0x8050fa,%rax
  805567:	00 00 00 
  80556a:	ff d0                	callq  *%rax
  80556c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80556f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805573:	79 05                	jns    80557a <write+0x5d>
		return r;
  805575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805578:	eb 75                	jmp    8055ef <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80557a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80557e:	8b 40 08             	mov    0x8(%rax),%eax
  805581:	83 e0 03             	and    $0x3,%eax
  805584:	85 c0                	test   %eax,%eax
  805586:	75 3a                	jne    8055c2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  805588:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80558f:	00 00 00 
  805592:	48 8b 00             	mov    (%rax),%rax
  805595:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80559b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80559e:	89 c6                	mov    %eax,%esi
  8055a0:	48 bf 33 73 80 00 00 	movabs $0x807333,%rdi
  8055a7:	00 00 00 
  8055aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8055af:	48 b9 66 34 80 00 00 	movabs $0x803466,%rcx
  8055b6:	00 00 00 
  8055b9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8055bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8055c0:	eb 2d                	jmp    8055ef <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8055c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055c6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8055ca:	48 85 c0             	test   %rax,%rax
  8055cd:	75 07                	jne    8055d6 <write+0xb9>
		return -E_NOT_SUPP;
  8055cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8055d4:	eb 19                	jmp    8055ef <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8055d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055da:	48 8b 40 18          	mov    0x18(%rax),%rax
  8055de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8055e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8055e6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8055ea:	48 89 cf             	mov    %rcx,%rdi
  8055ed:	ff d0                	callq  *%rax
}
  8055ef:	c9                   	leaveq 
  8055f0:	c3                   	retq   

00000000008055f1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8055f1:	55                   	push   %rbp
  8055f2:	48 89 e5             	mov    %rsp,%rbp
  8055f5:	48 83 ec 18          	sub    $0x18,%rsp
  8055f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055fc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8055ff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805603:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805606:	48 89 d6             	mov    %rdx,%rsi
  805609:	89 c7                	mov    %eax,%edi
  80560b:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  805612:	00 00 00 
  805615:	ff d0                	callq  *%rax
  805617:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80561a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80561e:	79 05                	jns    805625 <seek+0x34>
		return r;
  805620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805623:	eb 0f                	jmp    805634 <seek+0x43>
	fd->fd_offset = offset;
  805625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805629:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80562c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80562f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805634:	c9                   	leaveq 
  805635:	c3                   	retq   

0000000000805636 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805636:	55                   	push   %rbp
  805637:	48 89 e5             	mov    %rsp,%rbp
  80563a:	48 83 ec 30          	sub    $0x30,%rsp
  80563e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805641:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805644:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805648:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80564b:	48 89 d6             	mov    %rdx,%rsi
  80564e:	89 c7                	mov    %eax,%edi
  805650:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  805657:	00 00 00 
  80565a:	ff d0                	callq  *%rax
  80565c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80565f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805663:	78 24                	js     805689 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805669:	8b 00                	mov    (%rax),%eax
  80566b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80566f:	48 89 d6             	mov    %rdx,%rsi
  805672:	89 c7                	mov    %eax,%edi
  805674:	48 b8 fa 50 80 00 00 	movabs $0x8050fa,%rax
  80567b:	00 00 00 
  80567e:	ff d0                	callq  *%rax
  805680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805687:	79 05                	jns    80568e <ftruncate+0x58>
		return r;
  805689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80568c:	eb 72                	jmp    805700 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80568e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805692:	8b 40 08             	mov    0x8(%rax),%eax
  805695:	83 e0 03             	and    $0x3,%eax
  805698:	85 c0                	test   %eax,%eax
  80569a:	75 3a                	jne    8056d6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80569c:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8056a3:	00 00 00 
  8056a6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8056a9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8056af:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8056b2:	89 c6                	mov    %eax,%esi
  8056b4:	48 bf 50 73 80 00 00 	movabs $0x807350,%rdi
  8056bb:	00 00 00 
  8056be:	b8 00 00 00 00       	mov    $0x0,%eax
  8056c3:	48 b9 66 34 80 00 00 	movabs $0x803466,%rcx
  8056ca:	00 00 00 
  8056cd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8056cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8056d4:	eb 2a                	jmp    805700 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8056d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056da:	48 8b 40 30          	mov    0x30(%rax),%rax
  8056de:	48 85 c0             	test   %rax,%rax
  8056e1:	75 07                	jne    8056ea <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8056e3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8056e8:	eb 16                	jmp    805700 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8056ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8056f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8056f6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8056f9:	89 ce                	mov    %ecx,%esi
  8056fb:	48 89 d7             	mov    %rdx,%rdi
  8056fe:	ff d0                	callq  *%rax
}
  805700:	c9                   	leaveq 
  805701:	c3                   	retq   

0000000000805702 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805702:	55                   	push   %rbp
  805703:	48 89 e5             	mov    %rsp,%rbp
  805706:	48 83 ec 30          	sub    $0x30,%rsp
  80570a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80570d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805711:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805715:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805718:	48 89 d6             	mov    %rdx,%rsi
  80571b:	89 c7                	mov    %eax,%edi
  80571d:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  805724:	00 00 00 
  805727:	ff d0                	callq  *%rax
  805729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80572c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805730:	78 24                	js     805756 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805736:	8b 00                	mov    (%rax),%eax
  805738:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80573c:	48 89 d6             	mov    %rdx,%rsi
  80573f:	89 c7                	mov    %eax,%edi
  805741:	48 b8 fa 50 80 00 00 	movabs $0x8050fa,%rax
  805748:	00 00 00 
  80574b:	ff d0                	callq  *%rax
  80574d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805750:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805754:	79 05                	jns    80575b <fstat+0x59>
		return r;
  805756:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805759:	eb 5e                	jmp    8057b9 <fstat+0xb7>
	if (!dev->dev_stat)
  80575b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80575f:	48 8b 40 28          	mov    0x28(%rax),%rax
  805763:	48 85 c0             	test   %rax,%rax
  805766:	75 07                	jne    80576f <fstat+0x6d>
		return -E_NOT_SUPP;
  805768:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80576d:	eb 4a                	jmp    8057b9 <fstat+0xb7>
	stat->st_name[0] = 0;
  80576f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805773:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805776:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80577a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805781:	00 00 00 
	stat->st_isdir = 0;
  805784:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805788:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80578f:	00 00 00 
	stat->st_dev = dev;
  805792:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805796:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80579a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8057a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057a5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8057a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8057ad:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8057b1:	48 89 ce             	mov    %rcx,%rsi
  8057b4:	48 89 d7             	mov    %rdx,%rdi
  8057b7:	ff d0                	callq  *%rax
}
  8057b9:	c9                   	leaveq 
  8057ba:	c3                   	retq   

00000000008057bb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8057bb:	55                   	push   %rbp
  8057bc:	48 89 e5             	mov    %rsp,%rbp
  8057bf:	48 83 ec 20          	sub    $0x20,%rsp
  8057c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8057c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8057cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057cf:	be 00 00 00 00       	mov    $0x0,%esi
  8057d4:	48 89 c7             	mov    %rax,%rdi
  8057d7:	48 b8 a9 58 80 00 00 	movabs $0x8058a9,%rax
  8057de:	00 00 00 
  8057e1:	ff d0                	callq  *%rax
  8057e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057ea:	79 05                	jns    8057f1 <stat+0x36>
		return fd;
  8057ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057ef:	eb 2f                	jmp    805820 <stat+0x65>
	r = fstat(fd, stat);
  8057f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8057f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057f8:	48 89 d6             	mov    %rdx,%rsi
  8057fb:	89 c7                	mov    %eax,%edi
  8057fd:	48 b8 02 57 80 00 00 	movabs $0x805702,%rax
  805804:	00 00 00 
  805807:	ff d0                	callq  *%rax
  805809:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80580c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80580f:	89 c7                	mov    %eax,%edi
  805811:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805818:	00 00 00 
  80581b:	ff d0                	callq  *%rax
	return r;
  80581d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805820:	c9                   	leaveq 
  805821:	c3                   	retq   

0000000000805822 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805822:	55                   	push   %rbp
  805823:	48 89 e5             	mov    %rsp,%rbp
  805826:	48 83 ec 10          	sub    $0x10,%rsp
  80582a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80582d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805831:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  805838:	00 00 00 
  80583b:	8b 00                	mov    (%rax),%eax
  80583d:	85 c0                	test   %eax,%eax
  80583f:	75 1d                	jne    80585e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805841:	bf 01 00 00 00       	mov    $0x1,%edi
  805846:	48 b8 39 4e 80 00 00 	movabs $0x804e39,%rax
  80584d:	00 00 00 
  805850:	ff d0                	callq  *%rax
  805852:	48 ba 00 20 81 00 00 	movabs $0x812000,%rdx
  805859:	00 00 00 
  80585c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80585e:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  805865:	00 00 00 
  805868:	8b 00                	mov    (%rax),%eax
  80586a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80586d:	b9 07 00 00 00       	mov    $0x7,%ecx
  805872:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  805879:	00 00 00 
  80587c:	89 c7                	mov    %eax,%edi
  80587e:	48 b8 9c 4d 80 00 00 	movabs $0x804d9c,%rax
  805885:	00 00 00 
  805888:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80588a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80588e:	ba 00 00 00 00       	mov    $0x0,%edx
  805893:	48 89 c6             	mov    %rax,%rsi
  805896:	bf 00 00 00 00       	mov    $0x0,%edi
  80589b:	48 b8 d6 4c 80 00 00 	movabs $0x804cd6,%rax
  8058a2:	00 00 00 
  8058a5:	ff d0                	callq  *%rax
}
  8058a7:	c9                   	leaveq 
  8058a8:	c3                   	retq   

00000000008058a9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8058a9:	55                   	push   %rbp
  8058aa:	48 89 e5             	mov    %rsp,%rbp
  8058ad:	48 83 ec 20          	sub    $0x20,%rsp
  8058b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8058b5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8058b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058bc:	48 89 c7             	mov    %rax,%rdi
  8058bf:	48 b8 af 3f 80 00 00 	movabs $0x803faf,%rax
  8058c6:	00 00 00 
  8058c9:	ff d0                	callq  *%rax
  8058cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8058d0:	7e 0a                	jle    8058dc <open+0x33>
  8058d2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8058d7:	e9 a5 00 00 00       	jmpq   805981 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8058dc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8058e0:	48 89 c7             	mov    %rax,%rdi
  8058e3:	48 b8 09 4f 80 00 00 	movabs $0x804f09,%rax
  8058ea:	00 00 00 
  8058ed:	ff d0                	callq  *%rax
  8058ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058f6:	79 08                	jns    805900 <open+0x57>
		return r;
  8058f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058fb:	e9 81 00 00 00       	jmpq   805981 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  805900:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805907:	00 00 00 
  80590a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80590d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  805913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805917:	48 89 c6             	mov    %rax,%rsi
  80591a:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805921:	00 00 00 
  805924:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  80592b:	00 00 00 
  80592e:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  805930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805934:	48 89 c6             	mov    %rax,%rsi
  805937:	bf 01 00 00 00       	mov    $0x1,%edi
  80593c:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805943:	00 00 00 
  805946:	ff d0                	callq  *%rax
  805948:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80594b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80594f:	79 1d                	jns    80596e <open+0xc5>
		fd_close(fd, 0);
  805951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805955:	be 00 00 00 00       	mov    $0x0,%esi
  80595a:	48 89 c7             	mov    %rax,%rdi
  80595d:	48 b8 31 50 80 00 00 	movabs $0x805031,%rax
  805964:	00 00 00 
  805967:	ff d0                	callq  *%rax
		return r;
  805969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80596c:	eb 13                	jmp    805981 <open+0xd8>
	}
	return fd2num(fd);
  80596e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805972:	48 89 c7             	mov    %rax,%rdi
  805975:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  80597c:	00 00 00 
  80597f:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  805981:	c9                   	leaveq 
  805982:	c3                   	retq   

0000000000805983 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805983:	55                   	push   %rbp
  805984:	48 89 e5             	mov    %rsp,%rbp
  805987:	48 83 ec 10          	sub    $0x10,%rsp
  80598b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80598f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805993:	8b 50 0c             	mov    0xc(%rax),%edx
  805996:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80599d:	00 00 00 
  8059a0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8059a2:	be 00 00 00 00       	mov    $0x0,%esi
  8059a7:	bf 06 00 00 00       	mov    $0x6,%edi
  8059ac:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  8059b3:	00 00 00 
  8059b6:	ff d0                	callq  *%rax
}
  8059b8:	c9                   	leaveq 
  8059b9:	c3                   	retq   

00000000008059ba <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8059ba:	55                   	push   %rbp
  8059bb:	48 89 e5             	mov    %rsp,%rbp
  8059be:	48 83 ec 30          	sub    $0x30,%rsp
  8059c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8059c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8059ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8059d5:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059dc:	00 00 00 
  8059df:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8059e1:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8059e8:	00 00 00 
  8059eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059ef:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8059f3:	be 00 00 00 00       	mov    $0x0,%esi
  8059f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8059fd:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805a04:	00 00 00 
  805a07:	ff d0                	callq  *%rax
  805a09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a10:	79 05                	jns    805a17 <devfile_read+0x5d>
		return r;
  805a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a15:	eb 26                	jmp    805a3d <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  805a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a1a:	48 63 d0             	movslq %eax,%rdx
  805a1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a21:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805a28:	00 00 00 
  805a2b:	48 89 c7             	mov    %rax,%rdi
  805a2e:	48 b8 56 44 80 00 00 	movabs $0x804456,%rax
  805a35:	00 00 00 
  805a38:	ff d0                	callq  *%rax
	return r;
  805a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  805a3d:	c9                   	leaveq 
  805a3e:	c3                   	retq   

0000000000805a3f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805a3f:	55                   	push   %rbp
  805a40:	48 89 e5             	mov    %rsp,%rbp
  805a43:	48 83 ec 30          	sub    $0x30,%rsp
  805a47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  805a53:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  805a5a:	00 
	n = n > max ? max : n;
  805a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a5f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  805a63:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  805a68:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a70:	8b 50 0c             	mov    0xc(%rax),%edx
  805a73:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a7a:	00 00 00 
  805a7d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  805a7f:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a86:	00 00 00 
  805a89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805a8d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  805a91:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805a95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a99:	48 89 c6             	mov    %rax,%rsi
  805a9c:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  805aa3:	00 00 00 
  805aa6:	48 b8 56 44 80 00 00 	movabs $0x804456,%rax
  805aad:	00 00 00 
  805ab0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  805ab2:	be 00 00 00 00       	mov    $0x0,%esi
  805ab7:	bf 04 00 00 00       	mov    $0x4,%edi
  805abc:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805ac3:	00 00 00 
  805ac6:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  805ac8:	c9                   	leaveq 
  805ac9:	c3                   	retq   

0000000000805aca <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805aca:	55                   	push   %rbp
  805acb:	48 89 e5             	mov    %rsp,%rbp
  805ace:	48 83 ec 20          	sub    $0x20,%rsp
  805ad2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805ad6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ade:	8b 50 0c             	mov    0xc(%rax),%edx
  805ae1:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805ae8:	00 00 00 
  805aeb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805aed:	be 00 00 00 00       	mov    $0x0,%esi
  805af2:	bf 05 00 00 00       	mov    $0x5,%edi
  805af7:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805afe:	00 00 00 
  805b01:	ff d0                	callq  *%rax
  805b03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b0a:	79 05                	jns    805b11 <devfile_stat+0x47>
		return r;
  805b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b0f:	eb 56                	jmp    805b67 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805b11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b15:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805b1c:	00 00 00 
  805b1f:	48 89 c7             	mov    %rax,%rdi
  805b22:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  805b29:	00 00 00 
  805b2c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805b2e:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b35:	00 00 00 
  805b38:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805b3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b42:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805b48:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b4f:	00 00 00 
  805b52:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b5c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805b67:	c9                   	leaveq 
  805b68:	c3                   	retq   

0000000000805b69 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805b69:	55                   	push   %rbp
  805b6a:	48 89 e5             	mov    %rsp,%rbp
  805b6d:	48 83 ec 10          	sub    $0x10,%rsp
  805b71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b75:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b7c:	8b 50 0c             	mov    0xc(%rax),%edx
  805b7f:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b86:	00 00 00 
  805b89:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805b8b:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b92:	00 00 00 
  805b95:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805b98:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805b9b:	be 00 00 00 00       	mov    $0x0,%esi
  805ba0:	bf 02 00 00 00       	mov    $0x2,%edi
  805ba5:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805bac:	00 00 00 
  805baf:	ff d0                	callq  *%rax
}
  805bb1:	c9                   	leaveq 
  805bb2:	c3                   	retq   

0000000000805bb3 <remove>:

// Delete a file
int
remove(const char *path)
{
  805bb3:	55                   	push   %rbp
  805bb4:	48 89 e5             	mov    %rsp,%rbp
  805bb7:	48 83 ec 10          	sub    $0x10,%rsp
  805bbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805bbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805bc3:	48 89 c7             	mov    %rax,%rdi
  805bc6:	48 b8 af 3f 80 00 00 	movabs $0x803faf,%rax
  805bcd:	00 00 00 
  805bd0:	ff d0                	callq  *%rax
  805bd2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805bd7:	7e 07                	jle    805be0 <remove+0x2d>
		return -E_BAD_PATH;
  805bd9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805bde:	eb 33                	jmp    805c13 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805be4:	48 89 c6             	mov    %rax,%rsi
  805be7:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805bee:	00 00 00 
  805bf1:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  805bf8:	00 00 00 
  805bfb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805bfd:	be 00 00 00 00       	mov    $0x0,%esi
  805c02:	bf 07 00 00 00       	mov    $0x7,%edi
  805c07:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805c0e:	00 00 00 
  805c11:	ff d0                	callq  *%rax
}
  805c13:	c9                   	leaveq 
  805c14:	c3                   	retq   

0000000000805c15 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805c15:	55                   	push   %rbp
  805c16:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805c19:	be 00 00 00 00       	mov    $0x0,%esi
  805c1e:	bf 08 00 00 00       	mov    $0x8,%edi
  805c23:	48 b8 22 58 80 00 00 	movabs $0x805822,%rax
  805c2a:	00 00 00 
  805c2d:	ff d0                	callq  *%rax
}
  805c2f:	5d                   	pop    %rbp
  805c30:	c3                   	retq   

0000000000805c31 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805c31:	55                   	push   %rbp
  805c32:	48 89 e5             	mov    %rsp,%rbp
  805c35:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805c3c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805c43:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805c4a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805c51:	be 00 00 00 00       	mov    $0x0,%esi
  805c56:	48 89 c7             	mov    %rax,%rdi
  805c59:	48 b8 a9 58 80 00 00 	movabs $0x8058a9,%rax
  805c60:	00 00 00 
  805c63:	ff d0                	callq  *%rax
  805c65:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c6c:	79 28                	jns    805c96 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c71:	89 c6                	mov    %eax,%esi
  805c73:	48 bf 76 73 80 00 00 	movabs $0x807376,%rdi
  805c7a:	00 00 00 
  805c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  805c82:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  805c89:	00 00 00 
  805c8c:	ff d2                	callq  *%rdx
		return fd_src;
  805c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c91:	e9 74 01 00 00       	jmpq   805e0a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805c96:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805c9d:	be 01 01 00 00       	mov    $0x101,%esi
  805ca2:	48 89 c7             	mov    %rax,%rdi
  805ca5:	48 b8 a9 58 80 00 00 	movabs $0x8058a9,%rax
  805cac:	00 00 00 
  805caf:	ff d0                	callq  *%rax
  805cb1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  805cb4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805cb8:	79 39                	jns    805cf3 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  805cba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805cbd:	89 c6                	mov    %eax,%esi
  805cbf:	48 bf 8c 73 80 00 00 	movabs $0x80738c,%rdi
  805cc6:	00 00 00 
  805cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  805cce:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  805cd5:	00 00 00 
  805cd8:	ff d2                	callq  *%rdx
		close(fd_src);
  805cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cdd:	89 c7                	mov    %eax,%edi
  805cdf:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805ce6:	00 00 00 
  805ce9:	ff d0                	callq  *%rax
		return fd_dest;
  805ceb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805cee:	e9 17 01 00 00       	jmpq   805e0a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805cf3:	eb 74                	jmp    805d69 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  805cf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805cf8:	48 63 d0             	movslq %eax,%rdx
  805cfb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805d02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d05:	48 89 ce             	mov    %rcx,%rsi
  805d08:	89 c7                	mov    %eax,%edi
  805d0a:	48 b8 1d 55 80 00 00 	movabs $0x80551d,%rax
  805d11:	00 00 00 
  805d14:	ff d0                	callq  *%rax
  805d16:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  805d19:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  805d1d:	79 4a                	jns    805d69 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  805d1f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805d22:	89 c6                	mov    %eax,%esi
  805d24:	48 bf a6 73 80 00 00 	movabs $0x8073a6,%rdi
  805d2b:	00 00 00 
  805d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  805d33:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  805d3a:	00 00 00 
  805d3d:	ff d2                	callq  *%rdx
			close(fd_src);
  805d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d42:	89 c7                	mov    %eax,%edi
  805d44:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805d4b:	00 00 00 
  805d4e:	ff d0                	callq  *%rax
			close(fd_dest);
  805d50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d53:	89 c7                	mov    %eax,%edi
  805d55:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805d5c:	00 00 00 
  805d5f:	ff d0                	callq  *%rax
			return write_size;
  805d61:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805d64:	e9 a1 00 00 00       	jmpq   805e0a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805d69:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d73:	ba 00 02 00 00       	mov    $0x200,%edx
  805d78:	48 89 ce             	mov    %rcx,%rsi
  805d7b:	89 c7                	mov    %eax,%edi
  805d7d:	48 b8 d3 53 80 00 00 	movabs $0x8053d3,%rax
  805d84:	00 00 00 
  805d87:	ff d0                	callq  *%rax
  805d89:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805d90:	0f 8f 5f ff ff ff    	jg     805cf5 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  805d96:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805d9a:	79 47                	jns    805de3 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  805d9c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805d9f:	89 c6                	mov    %eax,%esi
  805da1:	48 bf b9 73 80 00 00 	movabs $0x8073b9,%rdi
  805da8:	00 00 00 
  805dab:	b8 00 00 00 00       	mov    $0x0,%eax
  805db0:	48 ba 66 34 80 00 00 	movabs $0x803466,%rdx
  805db7:	00 00 00 
  805dba:	ff d2                	callq  *%rdx
		close(fd_src);
  805dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dbf:	89 c7                	mov    %eax,%edi
  805dc1:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805dc8:	00 00 00 
  805dcb:	ff d0                	callq  *%rax
		close(fd_dest);
  805dcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805dd0:	89 c7                	mov    %eax,%edi
  805dd2:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805dd9:	00 00 00 
  805ddc:	ff d0                	callq  *%rax
		return read_size;
  805dde:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805de1:	eb 27                	jmp    805e0a <copy+0x1d9>
	}
	close(fd_src);
  805de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805de6:	89 c7                	mov    %eax,%edi
  805de8:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805def:	00 00 00 
  805df2:	ff d0                	callq  *%rax
	close(fd_dest);
  805df4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805df7:	89 c7                	mov    %eax,%edi
  805df9:	48 b8 b1 51 80 00 00 	movabs $0x8051b1,%rax
  805e00:	00 00 00 
  805e03:	ff d0                	callq  *%rax
	return 0;
  805e05:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  805e0a:	c9                   	leaveq 
  805e0b:	c3                   	retq   

0000000000805e0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805e0c:	55                   	push   %rbp
  805e0d:	48 89 e5             	mov    %rsp,%rbp
  805e10:	48 83 ec 18          	sub    $0x18,%rsp
  805e14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e1c:	48 c1 e8 15          	shr    $0x15,%rax
  805e20:	48 89 c2             	mov    %rax,%rdx
  805e23:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805e2a:	01 00 00 
  805e2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805e31:	83 e0 01             	and    $0x1,%eax
  805e34:	48 85 c0             	test   %rax,%rax
  805e37:	75 07                	jne    805e40 <pageref+0x34>
		return 0;
  805e39:	b8 00 00 00 00       	mov    $0x0,%eax
  805e3e:	eb 53                	jmp    805e93 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e44:	48 c1 e8 0c          	shr    $0xc,%rax
  805e48:	48 89 c2             	mov    %rax,%rdx
  805e4b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805e52:	01 00 00 
  805e55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805e59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805e61:	83 e0 01             	and    $0x1,%eax
  805e64:	48 85 c0             	test   %rax,%rax
  805e67:	75 07                	jne    805e70 <pageref+0x64>
		return 0;
  805e69:	b8 00 00 00 00       	mov    $0x0,%eax
  805e6e:	eb 23                	jmp    805e93 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805e74:	48 c1 e8 0c          	shr    $0xc,%rax
  805e78:	48 89 c2             	mov    %rax,%rdx
  805e7b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805e82:	00 00 00 
  805e85:	48 c1 e2 04          	shl    $0x4,%rdx
  805e89:	48 01 d0             	add    %rdx,%rax
  805e8c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805e90:	0f b7 c0             	movzwl %ax,%eax
}
  805e93:	c9                   	leaveq 
  805e94:	c3                   	retq   

0000000000805e95 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805e95:	55                   	push   %rbp
  805e96:	48 89 e5             	mov    %rsp,%rbp
  805e99:	53                   	push   %rbx
  805e9a:	48 83 ec 38          	sub    $0x38,%rsp
  805e9e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805ea2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805ea6:	48 89 c7             	mov    %rax,%rdi
  805ea9:	48 b8 09 4f 80 00 00 	movabs $0x804f09,%rax
  805eb0:	00 00 00 
  805eb3:	ff d0                	callq  *%rax
  805eb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805eb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805ebc:	0f 88 bf 01 00 00    	js     806081 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805ec2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805ec6:	ba 07 04 00 00       	mov    $0x407,%edx
  805ecb:	48 89 c6             	mov    %rax,%rsi
  805ece:	bf 00 00 00 00       	mov    $0x0,%edi
  805ed3:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  805eda:	00 00 00 
  805edd:	ff d0                	callq  *%rax
  805edf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805ee2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805ee6:	0f 88 95 01 00 00    	js     806081 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805eec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805ef0:	48 89 c7             	mov    %rax,%rdi
  805ef3:	48 b8 09 4f 80 00 00 	movabs $0x804f09,%rax
  805efa:	00 00 00 
  805efd:	ff d0                	callq  *%rax
  805eff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f06:	0f 88 5d 01 00 00    	js     806069 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f10:	ba 07 04 00 00       	mov    $0x407,%edx
  805f15:	48 89 c6             	mov    %rax,%rsi
  805f18:	bf 00 00 00 00       	mov    $0x0,%edi
  805f1d:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  805f24:	00 00 00 
  805f27:	ff d0                	callq  *%rax
  805f29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f30:	0f 88 33 01 00 00    	js     806069 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805f36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f3a:	48 89 c7             	mov    %rax,%rdi
  805f3d:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  805f44:	00 00 00 
  805f47:	ff d0                	callq  *%rax
  805f49:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805f51:	ba 07 04 00 00       	mov    $0x407,%edx
  805f56:	48 89 c6             	mov    %rax,%rsi
  805f59:	bf 00 00 00 00       	mov    $0x0,%edi
  805f5e:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  805f65:	00 00 00 
  805f68:	ff d0                	callq  *%rax
  805f6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f71:	79 05                	jns    805f78 <pipe+0xe3>
		goto err2;
  805f73:	e9 d9 00 00 00       	jmpq   806051 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f7c:	48 89 c7             	mov    %rax,%rdi
  805f7f:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  805f86:	00 00 00 
  805f89:	ff d0                	callq  *%rax
  805f8b:	48 89 c2             	mov    %rax,%rdx
  805f8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805f92:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805f98:	48 89 d1             	mov    %rdx,%rcx
  805f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  805fa0:	48 89 c6             	mov    %rax,%rsi
  805fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  805fa8:	48 b8 9a 49 80 00 00 	movabs $0x80499a,%rax
  805faf:	00 00 00 
  805fb2:	ff d0                	callq  *%rax
  805fb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805fb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805fbb:	79 1b                	jns    805fd8 <pipe+0x143>
		goto err3;
  805fbd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  805fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fc2:	48 89 c6             	mov    %rax,%rsi
  805fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  805fca:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  805fd1:	00 00 00 
  805fd4:	ff d0                	callq  *%rax
  805fd6:	eb 79                	jmp    806051 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fdc:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  805fe3:	00 00 00 
  805fe6:	8b 12                	mov    (%rdx),%edx
  805fe8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805ff5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805ff9:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  806000:	00 00 00 
  806003:	8b 12                	mov    (%rdx),%edx
  806005:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806007:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80600b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806016:	48 89 c7             	mov    %rax,%rdi
  806019:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  806020:	00 00 00 
  806023:	ff d0                	callq  *%rax
  806025:	89 c2                	mov    %eax,%edx
  806027:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80602b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80602d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806031:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806035:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806039:	48 89 c7             	mov    %rax,%rdi
  80603c:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  806043:	00 00 00 
  806046:	ff d0                	callq  *%rax
  806048:	89 03                	mov    %eax,(%rbx)
	return 0;
  80604a:	b8 00 00 00 00       	mov    $0x0,%eax
  80604f:	eb 33                	jmp    806084 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806051:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806055:	48 89 c6             	mov    %rax,%rsi
  806058:	bf 00 00 00 00       	mov    $0x0,%edi
  80605d:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  806064:	00 00 00 
  806067:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806069:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80606d:	48 89 c6             	mov    %rax,%rsi
  806070:	bf 00 00 00 00       	mov    $0x0,%edi
  806075:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  80607c:	00 00 00 
  80607f:	ff d0                	callq  *%rax
err:
	return r;
  806081:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806084:	48 83 c4 38          	add    $0x38,%rsp
  806088:	5b                   	pop    %rbx
  806089:	5d                   	pop    %rbp
  80608a:	c3                   	retq   

000000000080608b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80608b:	55                   	push   %rbp
  80608c:	48 89 e5             	mov    %rsp,%rbp
  80608f:	53                   	push   %rbx
  806090:	48 83 ec 28          	sub    $0x28,%rsp
  806094:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806098:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80609c:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8060a3:	00 00 00 
  8060a6:	48 8b 00             	mov    (%rax),%rax
  8060a9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8060af:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8060b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060b6:	48 89 c7             	mov    %rax,%rdi
  8060b9:	48 b8 0c 5e 80 00 00 	movabs $0x805e0c,%rax
  8060c0:	00 00 00 
  8060c3:	ff d0                	callq  *%rax
  8060c5:	89 c3                	mov    %eax,%ebx
  8060c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060cb:	48 89 c7             	mov    %rax,%rdi
  8060ce:	48 b8 0c 5e 80 00 00 	movabs $0x805e0c,%rax
  8060d5:	00 00 00 
  8060d8:	ff d0                	callq  *%rax
  8060da:	39 c3                	cmp    %eax,%ebx
  8060dc:	0f 94 c0             	sete   %al
  8060df:	0f b6 c0             	movzbl %al,%eax
  8060e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8060e5:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8060ec:	00 00 00 
  8060ef:	48 8b 00             	mov    (%rax),%rax
  8060f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8060f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8060fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8060fe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806101:	75 05                	jne    806108 <_pipeisclosed+0x7d>
			return ret;
  806103:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806106:	eb 4f                	jmp    806157 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  806108:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80610b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80610e:	74 42                	je     806152 <_pipeisclosed+0xc7>
  806110:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806114:	75 3c                	jne    806152 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806116:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80611d:	00 00 00 
  806120:	48 8b 00             	mov    (%rax),%rax
  806123:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806129:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80612c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80612f:	89 c6                	mov    %eax,%esi
  806131:	48 bf d4 73 80 00 00 	movabs $0x8073d4,%rdi
  806138:	00 00 00 
  80613b:	b8 00 00 00 00       	mov    $0x0,%eax
  806140:	49 b8 66 34 80 00 00 	movabs $0x803466,%r8
  806147:	00 00 00 
  80614a:	41 ff d0             	callq  *%r8
	}
  80614d:	e9 4a ff ff ff       	jmpq   80609c <_pipeisclosed+0x11>
  806152:	e9 45 ff ff ff       	jmpq   80609c <_pipeisclosed+0x11>
}
  806157:	48 83 c4 28          	add    $0x28,%rsp
  80615b:	5b                   	pop    %rbx
  80615c:	5d                   	pop    %rbp
  80615d:	c3                   	retq   

000000000080615e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80615e:	55                   	push   %rbp
  80615f:	48 89 e5             	mov    %rsp,%rbp
  806162:	48 83 ec 30          	sub    $0x30,%rsp
  806166:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806169:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80616d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806170:	48 89 d6             	mov    %rdx,%rsi
  806173:	89 c7                	mov    %eax,%edi
  806175:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  80617c:	00 00 00 
  80617f:	ff d0                	callq  *%rax
  806181:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806184:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806188:	79 05                	jns    80618f <pipeisclosed+0x31>
		return r;
  80618a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80618d:	eb 31                	jmp    8061c0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80618f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806193:	48 89 c7             	mov    %rax,%rdi
  806196:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  80619d:	00 00 00 
  8061a0:	ff d0                	callq  *%rax
  8061a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8061a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8061aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8061ae:	48 89 d6             	mov    %rdx,%rsi
  8061b1:	48 89 c7             	mov    %rax,%rdi
  8061b4:	48 b8 8b 60 80 00 00 	movabs $0x80608b,%rax
  8061bb:	00 00 00 
  8061be:	ff d0                	callq  *%rax
}
  8061c0:	c9                   	leaveq 
  8061c1:	c3                   	retq   

00000000008061c2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8061c2:	55                   	push   %rbp
  8061c3:	48 89 e5             	mov    %rsp,%rbp
  8061c6:	48 83 ec 40          	sub    $0x40,%rsp
  8061ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8061ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8061d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8061d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061da:	48 89 c7             	mov    %rax,%rdi
  8061dd:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  8061e4:	00 00 00 
  8061e7:	ff d0                	callq  *%rax
  8061e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8061ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8061f5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8061fc:	00 
  8061fd:	e9 92 00 00 00       	jmpq   806294 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806202:	eb 41                	jmp    806245 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806204:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806209:	74 09                	je     806214 <devpipe_read+0x52>
				return i;
  80620b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80620f:	e9 92 00 00 00       	jmpq   8062a6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806218:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80621c:	48 89 d6             	mov    %rdx,%rsi
  80621f:	48 89 c7             	mov    %rax,%rdi
  806222:	48 b8 8b 60 80 00 00 	movabs $0x80608b,%rax
  806229:	00 00 00 
  80622c:	ff d0                	callq  *%rax
  80622e:	85 c0                	test   %eax,%eax
  806230:	74 07                	je     806239 <devpipe_read+0x77>
				return 0;
  806232:	b8 00 00 00 00       	mov    $0x0,%eax
  806237:	eb 6d                	jmp    8062a6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806239:	48 b8 0c 49 80 00 00 	movabs $0x80490c,%rax
  806240:	00 00 00 
  806243:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806249:	8b 10                	mov    (%rax),%edx
  80624b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80624f:	8b 40 04             	mov    0x4(%rax),%eax
  806252:	39 c2                	cmp    %eax,%edx
  806254:	74 ae                	je     806204 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80625a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80625e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806266:	8b 00                	mov    (%rax),%eax
  806268:	99                   	cltd   
  806269:	c1 ea 1b             	shr    $0x1b,%edx
  80626c:	01 d0                	add    %edx,%eax
  80626e:	83 e0 1f             	and    $0x1f,%eax
  806271:	29 d0                	sub    %edx,%eax
  806273:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806277:	48 98                	cltq   
  806279:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80627e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  806280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806284:	8b 00                	mov    (%rax),%eax
  806286:	8d 50 01             	lea    0x1(%rax),%edx
  806289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80628d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80628f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806298:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80629c:	0f 82 60 ff ff ff    	jb     806202 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8062a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8062a6:	c9                   	leaveq 
  8062a7:	c3                   	retq   

00000000008062a8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8062a8:	55                   	push   %rbp
  8062a9:	48 89 e5             	mov    %rsp,%rbp
  8062ac:	48 83 ec 40          	sub    $0x40,%rsp
  8062b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8062b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8062b8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8062bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062c0:	48 89 c7             	mov    %rax,%rdi
  8062c3:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  8062ca:	00 00 00 
  8062cd:	ff d0                	callq  *%rax
  8062cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8062d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8062d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8062db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8062e2:	00 
  8062e3:	e9 8e 00 00 00       	jmpq   806376 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8062e8:	eb 31                	jmp    80631b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8062ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8062ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062f2:	48 89 d6             	mov    %rdx,%rsi
  8062f5:	48 89 c7             	mov    %rax,%rdi
  8062f8:	48 b8 8b 60 80 00 00 	movabs $0x80608b,%rax
  8062ff:	00 00 00 
  806302:	ff d0                	callq  *%rax
  806304:	85 c0                	test   %eax,%eax
  806306:	74 07                	je     80630f <devpipe_write+0x67>
				return 0;
  806308:	b8 00 00 00 00       	mov    $0x0,%eax
  80630d:	eb 79                	jmp    806388 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80630f:	48 b8 0c 49 80 00 00 	movabs $0x80490c,%rax
  806316:	00 00 00 
  806319:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80631b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80631f:	8b 40 04             	mov    0x4(%rax),%eax
  806322:	48 63 d0             	movslq %eax,%rdx
  806325:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806329:	8b 00                	mov    (%rax),%eax
  80632b:	48 98                	cltq   
  80632d:	48 83 c0 20          	add    $0x20,%rax
  806331:	48 39 c2             	cmp    %rax,%rdx
  806334:	73 b4                	jae    8062ea <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80633a:	8b 40 04             	mov    0x4(%rax),%eax
  80633d:	99                   	cltd   
  80633e:	c1 ea 1b             	shr    $0x1b,%edx
  806341:	01 d0                	add    %edx,%eax
  806343:	83 e0 1f             	and    $0x1f,%eax
  806346:	29 d0                	sub    %edx,%eax
  806348:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80634c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806350:	48 01 ca             	add    %rcx,%rdx
  806353:	0f b6 0a             	movzbl (%rdx),%ecx
  806356:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80635a:	48 98                	cltq   
  80635c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806360:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806364:	8b 40 04             	mov    0x4(%rax),%eax
  806367:	8d 50 01             	lea    0x1(%rax),%edx
  80636a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80636e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806371:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80637a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80637e:	0f 82 64 ff ff ff    	jb     8062e8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806388:	c9                   	leaveq 
  806389:	c3                   	retq   

000000000080638a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80638a:	55                   	push   %rbp
  80638b:	48 89 e5             	mov    %rsp,%rbp
  80638e:	48 83 ec 20          	sub    $0x20,%rsp
  806392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80639a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80639e:	48 89 c7             	mov    %rax,%rdi
  8063a1:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  8063a8:	00 00 00 
  8063ab:	ff d0                	callq  *%rax
  8063ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8063b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8063b5:	48 be e7 73 80 00 00 	movabs $0x8073e7,%rsi
  8063bc:	00 00 00 
  8063bf:	48 89 c7             	mov    %rax,%rdi
  8063c2:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  8063c9:	00 00 00 
  8063cc:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8063ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063d2:	8b 50 04             	mov    0x4(%rax),%edx
  8063d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063d9:	8b 00                	mov    (%rax),%eax
  8063db:	29 c2                	sub    %eax,%edx
  8063dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8063e1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8063e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8063eb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8063f2:	00 00 00 
	stat->st_dev = &devpipe;
  8063f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8063f9:	48 b9 00 11 81 00 00 	movabs $0x811100,%rcx
  806400:	00 00 00 
  806403:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80640a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80640f:	c9                   	leaveq 
  806410:	c3                   	retq   

0000000000806411 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806411:	55                   	push   %rbp
  806412:	48 89 e5             	mov    %rsp,%rbp
  806415:	48 83 ec 10          	sub    $0x10,%rsp
  806419:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80641d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806421:	48 89 c6             	mov    %rax,%rsi
  806424:	bf 00 00 00 00       	mov    $0x0,%edi
  806429:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  806430:	00 00 00 
  806433:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806439:	48 89 c7             	mov    %rax,%rdi
  80643c:	48 b8 de 4e 80 00 00 	movabs $0x804ede,%rax
  806443:	00 00 00 
  806446:	ff d0                	callq  *%rax
  806448:	48 89 c6             	mov    %rax,%rsi
  80644b:	bf 00 00 00 00       	mov    $0x0,%edi
  806450:	48 b8 f5 49 80 00 00 	movabs $0x8049f5,%rax
  806457:	00 00 00 
  80645a:	ff d0                	callq  *%rax
}
  80645c:	c9                   	leaveq 
  80645d:	c3                   	retq   

000000000080645e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80645e:	55                   	push   %rbp
  80645f:	48 89 e5             	mov    %rsp,%rbp
  806462:	48 83 ec 20          	sub    $0x20,%rsp
  806466:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806469:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80646c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80646f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806473:	be 01 00 00 00       	mov    $0x1,%esi
  806478:	48 89 c7             	mov    %rax,%rdi
  80647b:	48 b8 02 48 80 00 00 	movabs $0x804802,%rax
  806482:	00 00 00 
  806485:	ff d0                	callq  *%rax
}
  806487:	c9                   	leaveq 
  806488:	c3                   	retq   

0000000000806489 <getchar>:

int
getchar(void)
{
  806489:	55                   	push   %rbp
  80648a:	48 89 e5             	mov    %rsp,%rbp
  80648d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806491:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806495:	ba 01 00 00 00       	mov    $0x1,%edx
  80649a:	48 89 c6             	mov    %rax,%rsi
  80649d:	bf 00 00 00 00       	mov    $0x0,%edi
  8064a2:	48 b8 d3 53 80 00 00 	movabs $0x8053d3,%rax
  8064a9:	00 00 00 
  8064ac:	ff d0                	callq  *%rax
  8064ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8064b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064b5:	79 05                	jns    8064bc <getchar+0x33>
		return r;
  8064b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064ba:	eb 14                	jmp    8064d0 <getchar+0x47>
	if (r < 1)
  8064bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064c0:	7f 07                	jg     8064c9 <getchar+0x40>
		return -E_EOF;
  8064c2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8064c7:	eb 07                	jmp    8064d0 <getchar+0x47>
	return c;
  8064c9:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8064cd:	0f b6 c0             	movzbl %al,%eax
}
  8064d0:	c9                   	leaveq 
  8064d1:	c3                   	retq   

00000000008064d2 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8064d2:	55                   	push   %rbp
  8064d3:	48 89 e5             	mov    %rsp,%rbp
  8064d6:	48 83 ec 20          	sub    $0x20,%rsp
  8064da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8064dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8064e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8064e4:	48 89 d6             	mov    %rdx,%rsi
  8064e7:	89 c7                	mov    %eax,%edi
  8064e9:	48 b8 a1 4f 80 00 00 	movabs $0x804fa1,%rax
  8064f0:	00 00 00 
  8064f3:	ff d0                	callq  *%rax
  8064f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8064f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064fc:	79 05                	jns    806503 <iscons+0x31>
		return r;
  8064fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806501:	eb 1a                	jmp    80651d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806507:	8b 10                	mov    (%rax),%edx
  806509:	48 b8 40 11 81 00 00 	movabs $0x811140,%rax
  806510:	00 00 00 
  806513:	8b 00                	mov    (%rax),%eax
  806515:	39 c2                	cmp    %eax,%edx
  806517:	0f 94 c0             	sete   %al
  80651a:	0f b6 c0             	movzbl %al,%eax
}
  80651d:	c9                   	leaveq 
  80651e:	c3                   	retq   

000000000080651f <opencons>:

int
opencons(void)
{
  80651f:	55                   	push   %rbp
  806520:	48 89 e5             	mov    %rsp,%rbp
  806523:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806527:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80652b:	48 89 c7             	mov    %rax,%rdi
  80652e:	48 b8 09 4f 80 00 00 	movabs $0x804f09,%rax
  806535:	00 00 00 
  806538:	ff d0                	callq  *%rax
  80653a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80653d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806541:	79 05                	jns    806548 <opencons+0x29>
		return r;
  806543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806546:	eb 5b                	jmp    8065a3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80654c:	ba 07 04 00 00       	mov    $0x407,%edx
  806551:	48 89 c6             	mov    %rax,%rsi
  806554:	bf 00 00 00 00       	mov    $0x0,%edi
  806559:	48 b8 4a 49 80 00 00 	movabs $0x80494a,%rax
  806560:	00 00 00 
  806563:	ff d0                	callq  *%rax
  806565:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80656c:	79 05                	jns    806573 <opencons+0x54>
		return r;
  80656e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806571:	eb 30                	jmp    8065a3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806577:	48 ba 40 11 81 00 00 	movabs $0x811140,%rdx
  80657e:	00 00 00 
  806581:	8b 12                	mov    (%rdx),%edx
  806583:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806589:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  806590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806594:	48 89 c7             	mov    %rax,%rdi
  806597:	48 b8 bb 4e 80 00 00 	movabs $0x804ebb,%rax
  80659e:	00 00 00 
  8065a1:	ff d0                	callq  *%rax
}
  8065a3:	c9                   	leaveq 
  8065a4:	c3                   	retq   

00000000008065a5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8065a5:	55                   	push   %rbp
  8065a6:	48 89 e5             	mov    %rsp,%rbp
  8065a9:	48 83 ec 30          	sub    $0x30,%rsp
  8065ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8065b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8065b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8065b9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8065be:	75 07                	jne    8065c7 <devcons_read+0x22>
		return 0;
  8065c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8065c5:	eb 4b                	jmp    806612 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8065c7:	eb 0c                	jmp    8065d5 <devcons_read+0x30>
		sys_yield();
  8065c9:	48 b8 0c 49 80 00 00 	movabs $0x80490c,%rax
  8065d0:	00 00 00 
  8065d3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8065d5:	48 b8 4c 48 80 00 00 	movabs $0x80484c,%rax
  8065dc:	00 00 00 
  8065df:	ff d0                	callq  *%rax
  8065e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065e8:	74 df                	je     8065c9 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8065ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065ee:	79 05                	jns    8065f5 <devcons_read+0x50>
		return c;
  8065f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065f3:	eb 1d                	jmp    806612 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8065f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8065f9:	75 07                	jne    806602 <devcons_read+0x5d>
		return 0;
  8065fb:	b8 00 00 00 00       	mov    $0x0,%eax
  806600:	eb 10                	jmp    806612 <devcons_read+0x6d>
	*(char*)vbuf = c;
  806602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806605:	89 c2                	mov    %eax,%edx
  806607:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80660b:	88 10                	mov    %dl,(%rax)
	return 1;
  80660d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  806612:	c9                   	leaveq 
  806613:	c3                   	retq   

0000000000806614 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806614:	55                   	push   %rbp
  806615:	48 89 e5             	mov    %rsp,%rbp
  806618:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80661f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806626:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80662d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806634:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80663b:	eb 76                	jmp    8066b3 <devcons_write+0x9f>
		m = n - tot;
  80663d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806644:	89 c2                	mov    %eax,%edx
  806646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806649:	29 c2                	sub    %eax,%edx
  80664b:	89 d0                	mov    %edx,%eax
  80664d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  806650:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806653:	83 f8 7f             	cmp    $0x7f,%eax
  806656:	76 07                	jbe    80665f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806658:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80665f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806662:	48 63 d0             	movslq %eax,%rdx
  806665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806668:	48 63 c8             	movslq %eax,%rcx
  80666b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806672:	48 01 c1             	add    %rax,%rcx
  806675:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80667c:	48 89 ce             	mov    %rcx,%rsi
  80667f:	48 89 c7             	mov    %rax,%rdi
  806682:	48 b8 3f 43 80 00 00 	movabs $0x80433f,%rax
  806689:	00 00 00 
  80668c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80668e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806691:	48 63 d0             	movslq %eax,%rdx
  806694:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80669b:	48 89 d6             	mov    %rdx,%rsi
  80669e:	48 89 c7             	mov    %rax,%rdi
  8066a1:	48 b8 02 48 80 00 00 	movabs $0x804802,%rax
  8066a8:	00 00 00 
  8066ab:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8066ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8066b0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8066b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066b6:	48 98                	cltq   
  8066b8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8066bf:	0f 82 78 ff ff ff    	jb     80663d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8066c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8066c8:	c9                   	leaveq 
  8066c9:	c3                   	retq   

00000000008066ca <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8066ca:	55                   	push   %rbp
  8066cb:	48 89 e5             	mov    %rsp,%rbp
  8066ce:	48 83 ec 08          	sub    $0x8,%rsp
  8066d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8066d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8066db:	c9                   	leaveq 
  8066dc:	c3                   	retq   

00000000008066dd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8066dd:	55                   	push   %rbp
  8066de:	48 89 e5             	mov    %rsp,%rbp
  8066e1:	48 83 ec 10          	sub    $0x10,%rsp
  8066e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8066e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8066ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066f1:	48 be f3 73 80 00 00 	movabs $0x8073f3,%rsi
  8066f8:	00 00 00 
  8066fb:	48 89 c7             	mov    %rax,%rdi
  8066fe:	48 b8 1b 40 80 00 00 	movabs $0x80401b,%rax
  806705:	00 00 00 
  806708:	ff d0                	callq  *%rax
	return 0;
  80670a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80670f:	c9                   	leaveq 
  806710:	c3                   	retq   
