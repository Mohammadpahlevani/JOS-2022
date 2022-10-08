
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

.globl multiboot_info
.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

00007c1e <do_e820>:

  # get the E820 memory map from the BIOS
do_e820:
  movl $0xe820, %eax
    7c1e:	66 b8 20 e8          	mov    $0xe820,%ax
    7c22:	00 00                	add    %al,(%eax)
  movl $e820_map4, %edi
    7c24:	66 bf 38 70          	mov    $0x7038,%di
    7c28:	00 00                	add    %al,(%eax)
  xorl %ebx, %ebx
    7c2a:	66 31 db             	xor    %bx,%bx
  movl $0x534D4150, %edx
    7c2d:	66 ba 50 41          	mov    $0x4150,%dx
    7c31:	4d                   	dec    %ebp
    7c32:	53                   	push   %ebx
  movl $24, %ecx
    7c33:	66 b9 18 00          	mov    $0x18,%cx
    7c37:	00 00                	add    %al,(%eax)
  int $0x15
    7c39:	cd 15                	int    $0x15
  jc failed
    7c3b:	72 4b                	jb     7c88 <failed>
  cmpl %eax, %edx
    7c3d:	66 39 c2             	cmp    %ax,%dx
  jne failed
    7c40:	75 46                	jne    7c88 <failed>
  testl %ebx, %ebx
    7c42:	66 85 db             	test   %bx,%bx
  je failed
    7c45:	74 41                	je     7c88 <failed>
  movl $24, %ebp
    7c47:	66 bd 18 00          	mov    $0x18,%bp
	...

00007c4d <next_entry>:

next_entry:
  #increment di
  movl %ecx, -4(%edi)
    7c4d:	67 66 89 4f fc       	mov    %cx,-0x4(%bx)
  addl $24, %edi
    7c52:	66 83 c7 18          	add    $0x18,%di
  movl $0xe820, %eax
    7c56:	66 b8 20 e8          	mov    $0xe820,%ax
    7c5a:	00 00                	add    %al,(%eax)
  movl $24, %ecx
    7c5c:	66 b9 18 00          	mov    $0x18,%cx
    7c60:	00 00                	add    %al,(%eax)
  int $0x15
    7c62:	cd 15                	int    $0x15
  jc done
    7c64:	72 09                	jb     7c6f <done>
  addl $24, %ebp
    7c66:	66 83 c5 18          	add    $0x18,%bp
  testl %ebx, %ebx
    7c6a:	66 85 db             	test   %bx,%bx
  jne next_entry
    7c6d:	75 de                	jne    7c4d <next_entry>

00007c6f <done>:

done:
  movl %ecx, -4(%edi)
    7c6f:	67 66 89 4f fc       	mov    %cx,-0x4(%bx)
  movw $0x40, (MB_flag) #multiboot info flags
    7c74:	c7 06 00 70 40 00    	movl   $0x407000,(%esi)
  movl $e820_map, (MB_mmap_addr)
    7c7a:	66 c7 06 30 70       	movw   $0x7030,(%esi)
    7c7f:	34 70                	xor    $0x70,%al
    7c81:	00 00                	add    %al,(%eax)
  movl %ebp, (MB_mmap_len)
    7c83:	66 89 2e             	mov    %bp,(%esi)
    7c86:	2c 70                	sub    $0x70,%al

00007c88 <failed>:
 
  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c88:	0f 01 16             	lgdtl  (%esi)
    7c8b:	d4 7c                	aam    $0x7c
  movl    %cr0, %eax
    7c8d:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE_ON, %eax
    7c90:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c94:	0f 22 c0             	mov    %eax,%cr0
 
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c97:	ea 9c 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c9c

00007c9c <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c9c:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7ca0:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7ca2:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7ca4:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7ca6:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7ca8:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7caa:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  movl $multiboot_info, %ebx
    7caf:	bb 00 70 00 00       	mov    $0x7000,%ebx
 # call bootmain
   call bootmain
    7cb4:	e8 c1 00 00 00       	call   7d7a <bootmain>

00007cb9 <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7cb9:	eb fe                	jmp    7cb9 <spin>
    7cbb:	90                   	nop

00007cbc <gdt>:
	...
    7cc4:	ff                   	(bad)  
    7cc5:	ff 00                	incl   (%eax)
    7cc7:	00 00                	add    %al,(%eax)
    7cc9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7cd0:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007cd4 <gdtdesc>:
    7cd4:	17                   	pop    %ss
    7cd5:	00 bc 7c 00 00 55 ba 	add    %bh,-0x45ab0000(%esp,%edi,2)

00007cda <waitdisk>:
    }
}

    void
waitdisk(void)
{
    7cda:	55                   	push   %ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7cdb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ce0:	89 e5                	mov    %esp,%ebp
    7ce2:	ec                   	in     (%dx),%al
    // wait for disk reaady
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ce3:	83 e0 c0             	and    $0xffffffc0,%eax
    7ce6:	3c 40                	cmp    $0x40,%al
    7ce8:	75 f8                	jne    7ce2 <waitdisk+0x8>
        /* do nothing */;
}
    7cea:	5d                   	pop    %ebp
    7ceb:	c3                   	ret    

00007cec <readsect>:

    void
readsect(void *dst, uint32_t offset)
{
    7cec:	55                   	push   %ebp
    7ced:	89 e5                	mov    %esp,%ebp
    7cef:	57                   	push   %edi
    7cf0:	53                   	push   %ebx
    7cf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    // wait for disk to be ready
    waitdisk();
    7cf4:	e8 e1 ff ff ff       	call   7cda <waitdisk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cf9:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cfe:	b0 01                	mov    $0x1,%al
    7d00:	ee                   	out    %al,(%dx)
    7d01:	0f b6 c3             	movzbl %bl,%eax
    7d04:	b2 f3                	mov    $0xf3,%dl
    7d06:	ee                   	out    %al,(%dx)
    7d07:	0f b6 c7             	movzbl %bh,%eax
    7d0a:	b2 f4                	mov    $0xf4,%dl
    7d0c:	ee                   	out    %al,(%dx)

    outb(0x1F2, 1);		// count = 1
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    7d0d:	89 d8                	mov    %ebx,%eax
    7d0f:	b2 f5                	mov    $0xf5,%dl
    7d11:	c1 e8 10             	shr    $0x10,%eax
    7d14:	0f b6 c0             	movzbl %al,%eax
    7d17:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
    7d18:	c1 eb 18             	shr    $0x18,%ebx
    7d1b:	b2 f6                	mov    $0xf6,%dl
    7d1d:	88 d8                	mov    %bl,%al
    7d1f:	83 c8 e0             	or     $0xffffffe0,%eax
    7d22:	ee                   	out    %al,(%dx)
    7d23:	b0 20                	mov    $0x20,%al
    7d25:	b2 f7                	mov    $0xf7,%dl
    7d27:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();
    7d28:	e8 ad ff ff ff       	call   7cda <waitdisk>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    7d2d:	8b 7d 08             	mov    0x8(%ebp),%edi
    7d30:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d35:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d3a:	fc                   	cld    
    7d3b:	f2 6d                	repnz insl (%dx),%es:(%edi)

    // read a sector
    insl(0x1F0, dst, SECTSIZE/4);
}
    7d3d:	5b                   	pop    %ebx
    7d3e:	5f                   	pop    %edi
    7d3f:	5d                   	pop    %ebp
    7d40:	c3                   	ret    

00007d41 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7d41:	55                   	push   %ebp
    7d42:	89 e5                	mov    %esp,%ebp
    7d44:	57                   	push   %edi
    uint32_t end_pa;

    end_pa = pa + count;
    7d45:	8b 7d 0c             	mov    0xc(%ebp),%edi

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7d48:	56                   	push   %esi
    7d49:	8b 75 10             	mov    0x10(%ebp),%esi
    7d4c:	53                   	push   %ebx
    7d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 3
    offset = (offset / SECTSIZE) + 1;
    7d50:	c1 ee 09             	shr    $0x9,%esi
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    uint32_t end_pa;

    end_pa = pa + count;
    7d53:	01 df                	add    %ebx,%edi

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 3
    offset = (offset / SECTSIZE) + 1;
    7d55:	46                   	inc    %esi

    end_pa = pa + count;
    uint32_t orgoff = offset;

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);
    7d56:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
    offset = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
    7d5c:	39 fb                	cmp    %edi,%ebx
    7d5e:	73 12                	jae    7d72 <readseg+0x31>
        readsect((uint8_t*) pa, offset);
    7d60:	56                   	push   %esi
        pa += SECTSIZE;
        offset++;
    7d61:	46                   	inc    %esi

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
        readsect((uint8_t*) pa, offset);
    7d62:	53                   	push   %ebx
        pa += SECTSIZE;
    7d63:	81 c3 00 02 00 00    	add    $0x200,%ebx

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
        readsect((uint8_t*) pa, offset);
    7d69:	e8 7e ff ff ff       	call   7cec <readsect>
        pa += SECTSIZE;
        offset++;
    7d6e:	58                   	pop    %eax
    7d6f:	5a                   	pop    %edx
    7d70:	eb ea                	jmp    7d5c <readseg+0x1b>
    }
}
    7d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d75:	5b                   	pop    %ebx
    7d76:	5e                   	pop    %esi
    7d77:	5f                   	pop    %edi
    7d78:	5d                   	pop    %ebp
    7d79:	c3                   	ret    

00007d7a <bootmain>:
void readseg(uint32_t, uint32_t, uint32_t);


    void
bootmain(void)
{
    7d7a:	55                   	push   %ebp
    7d7b:	89 e5                	mov    %esp,%ebp
    7d7d:	56                   	push   %esi
    7d7e:	53                   	push   %ebx
    /* __asm __volatile("movl %%ebx, %0": "=r" (multiboot_info)); */
    struct Proghdr *ph, *eph;

    extern char multiboot_info[];
    // read 1st 2 pages off disk
    readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d7f:	6a 00                	push   $0x0
    7d81:	68 00 10 00 00       	push   $0x1000
    7d86:	68 00 00 01 00       	push   $0x10000
    7d8b:	e8 b1 ff ff ff       	call   7d41 <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    7d90:	83 c4 0c             	add    $0xc,%esp
    7d93:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d9a:	45 4c 46 
    7d9d:	75 3e                	jne    7ddd <bootmain+0x63>
        goto bad;

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    7d9f:	0f b7 35 38 00 01 00 	movzwl 0x10038,%esi
    if (ELFHDR->e_magic != ELF_MAGIC)
        goto bad;

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7da6:	a1 20 00 01 00       	mov    0x10020,%eax
    eph = ph + ELFHDR->e_phnum;
    7dab:	6b f6 38             	imul   $0x38,%esi,%esi
    if (ELFHDR->e_magic != ELF_MAGIC)
        goto bad;

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7dae:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7db4:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph++)
    7db6:	39 f3                	cmp    %esi,%ebx
    7db8:	73 16                	jae    7dd0 <bootmain+0x56>
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7dba:	ff 73 08             	pushl  0x8(%ebx)

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph++)
    7dbd:	83 c3 38             	add    $0x38,%ebx
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7dc0:	ff 73 f0             	pushl  -0x10(%ebx)
    7dc3:	ff 73 e0             	pushl  -0x20(%ebx)
    7dc6:	e8 76 ff ff ff       	call   7d41 <readseg>

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph++)
    7dcb:	83 c4 0c             	add    $0xc,%esp
    7dce:	eb e6                	jmp    7db6 <bootmain+0x3c>
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);

    // call the entry point from the ELF header
    // note: does not return!

    __asm __volatile("movl %0, %%ebx": : "r" (multiboot_info));
    7dd0:	b8 00 70 00 00       	mov    $0x7000,%eax
    7dd5:	89 c3                	mov    %eax,%ebx
    ((void (*)(void)) ((uint32_t)(ELFHDR->e_entry)))();
    7dd7:	ff 15 18 00 01 00    	call   *0x10018
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7ddd:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7de2:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7de7:	66 ef                	out    %ax,(%dx)
    7de9:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7dee:	66 ef                	out    %ax,(%dx)
    7df0:	eb fe                	jmp    7df0 <bootmain+0x76>
