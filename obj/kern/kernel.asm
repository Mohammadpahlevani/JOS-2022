
obj/kern/kernel:     file format elf64-x86-64


Disassembly of section .bootstrap:

0000000000100000 <_head64>:
.globl _head64
_head64:

# Save multiboot_info addr passed by bootloader
	
    movl $multiboot_info, %eax
  100000:	b8 00 70 10 00       	mov    $0x107000,%eax
    movl %ebx, (%eax)
  100005:	89 18                	mov    %ebx,(%rax)

    movw $0x1234,0x472			# warm boot	
  100007:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472(%rip)        # 100482 <verify_cpu_no_longmode+0x36f>
  10000e:	34 12 
	
# Reset the stack pointer in case we didn't come from the loader
    movl $0x7c00,%esp
  100010:	bc 00 7c 00 00       	mov    $0x7c00,%esp

    call verify_cpu   #check if CPU supports long mode
  100015:	e8 cc 00 00 00       	callq  1000e6 <verify_cpu>
    movl $CR4_PAE,%eax	
  10001a:	b8 20 00 00 00       	mov    $0x20,%eax
    movl %eax,%cr4
  10001f:	0f 22 e0             	mov    %rax,%cr4

# build an early boot pml4 at physical address pml4phys 

    #initializing the page tables
    movl $pml4,%edi
  100022:	bf 00 20 10 00       	mov    $0x102000,%edi
    xorl %eax,%eax
  100027:	31 c0                	xor    %eax,%eax
    movl $((4096/4)*5),%ecx  # moving these many words to the 6 pages with 4 second level pages + 1 3rd level + 1 4th level pages 
  100029:	b9 00 14 00 00       	mov    $0x1400,%ecx
    rep stosl
  10002e:	f3 ab                	rep stos %eax,%es:(%rdi)
    # creating a 4G boot page table
    # setting the 4th level page table only the second entry needed (PML4)
    movl $pml4,%eax
  100030:	b8 00 20 10 00       	mov    $0x102000,%eax
    movl $pdpt1, %ebx
  100035:	bb 00 30 10 00       	mov    $0x103000,%ebx
    orl $PTE_P,%ebx
  10003a:	83 cb 01             	or     $0x1,%ebx
    orl $PTE_W,%ebx
  10003d:	83 cb 02             	or     $0x2,%ebx
    movl %ebx,(%eax)
  100040:	89 18                	mov    %ebx,(%rax)

    movl $pdpt2, %ebx
  100042:	bb 00 40 10 00       	mov    $0x104000,%ebx
    orl $PTE_P,%ebx
  100047:	83 cb 01             	or     $0x1,%ebx
    orl $PTE_W,%ebx
  10004a:	83 cb 02             	or     $0x2,%ebx
    movl %ebx,0x8(%eax)
  10004d:	89 58 08             	mov    %ebx,0x8(%rax)

    # setting the 3rd level page table (PDPE)
    # 4 entries (counter in ecx), point to the next four physical pages (pgdirs)
    # pgdirs in 0xa0000--0xd000
    movl $pdpt1,%edi
  100050:	bf 00 30 10 00       	mov    $0x103000,%edi
    movl $pde1,%ebx
  100055:	bb 00 50 10 00       	mov    $0x105000,%ebx
    orl $PTE_P,%ebx
  10005a:	83 cb 01             	or     $0x1,%ebx
    orl $PTE_W,%ebx
  10005d:	83 cb 02             	or     $0x2,%ebx
    movl %ebx,(%edi)
  100060:	89 1f                	mov    %ebx,(%rdi)

    movl $pdpt2,%edi
  100062:	bf 00 40 10 00       	mov    $0x104000,%edi
    movl $pde2,%ebx
  100067:	bb 00 60 10 00       	mov    $0x106000,%ebx
    orl $PTE_P,%ebx
  10006c:	83 cb 01             	or     $0x1,%ebx
    orl $PTE_W,%ebx
  10006f:	83 cb 02             	or     $0x2,%ebx
    movl %ebx,(%edi)
  100072:	89 1f                	mov    %ebx,(%rdi)
    
    # setting the pgdir so that the LA=PA
    # mapping first 1G of mem at KERNBASE
    movl $128,%ecx
  100074:	b9 80 00 00 00       	mov    $0x80,%ecx
    # Start at the end and work backwards
    #leal (pml4 + 5*0x1000 - 0x8),%edi
    movl $pde1,%edi
  100079:	bf 00 50 10 00       	mov    $0x105000,%edi
    movl $pde2,%ebx
  10007e:	bb 00 60 10 00       	mov    $0x106000,%ebx
    #64th entry - 0x8004000000
    addl $256,%ebx 
  100083:	81 c3 00 01 00 00    	add    $0x100,%ebx
    # PTE_P|PTE_W|PTE_MBZ
    movl $0x00000183,%eax
  100089:	b8 83 01 00 00       	mov    $0x183,%eax
  1:
     movl %eax,(%edi)
  10008e:	89 07                	mov    %eax,(%rdi)
     movl %eax,(%ebx)
  100090:	89 03                	mov    %eax,(%rbx)
     addl $0x8,%edi
  100092:	83 c7 08             	add    $0x8,%edi
     addl $0x8,%ebx
  100095:	83 c3 08             	add    $0x8,%ebx
     addl $0x00200000,%eax
  100098:	05 00 00 20 00       	add    $0x200000,%eax
     subl $1,%ecx
  10009d:	83 e9 01             	sub    $0x1,%ecx
     cmp $0x0,%ecx
  1000a0:	83 f9 00             	cmp    $0x0,%ecx
     jne 1b
  1000a3:	75 e9                	jne    10008e <_head64+0x8e>
 /*    subl $1,%ecx */
 /*    cmp $0x0,%ecx */
 /*    jne 1b */

    # set the cr3 register
    movl $pml4,%eax
  1000a5:	b8 00 20 10 00       	mov    $0x102000,%eax
    movl %eax, %cr3
  1000aa:	0f 22 d8             	mov    %rax,%cr3

	
    # enable the long mode in MSR
    movl $EFER_MSR,%ecx
  1000ad:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
    rdmsr
  1000b2:	0f 32                	rdmsr  
    btsl $EFER_LME,%eax
  1000b4:	0f ba e8 08          	bts    $0x8,%eax
    wrmsr
  1000b8:	0f 30                	wrmsr  
    
    # enable paging 
    movl %cr0,%eax
  1000ba:	0f 20 c0             	mov    %cr0,%rax
    orl $CR0_PE,%eax
  1000bd:	83 c8 01             	or     $0x1,%eax
    orl $CR0_PG,%eax
  1000c0:	0d 00 00 00 80       	or     $0x80000000,%eax
    orl $CR0_AM,%eax
  1000c5:	0d 00 00 04 00       	or     $0x40000,%eax
    orl $CR0_WP,%eax
  1000ca:	0d 00 00 01 00       	or     $0x10000,%eax
    orl $CR0_MP,%eax
  1000cf:	83 c8 02             	or     $0x2,%eax
    movl %eax,%cr0
  1000d2:	0f 22 c0             	mov    %rax,%cr0
    #jump to long mode with CS=0 and

    movl $gdtdesc_64,%eax
  1000d5:	b8 18 10 10 00       	mov    $0x101018,%eax
    lgdt (%eax)
  1000da:	0f 01 10             	lgdt   (%rax)
    pushl $0x8
  1000dd:	6a 08                	pushq  $0x8
    movl $_start,%eax
  1000df:	b8 0c 00 20 00       	mov    $0x20000c,%eax
    pushl %eax
  1000e4:	50                   	push   %rax

00000000001000e5 <jumpto_longmode>:
    
    .globl jumpto_longmode
    .type jumpto_longmode,@function
jumpto_longmode:
    lret
  1000e5:	cb                   	lret   

00000000001000e6 <verify_cpu>:
/*     movabs $_back_from_head64, %rax */
/*     pushq %rax */
/*     lretq */

verify_cpu:
    pushfl                   # get eflags in eax -- standardard way to check for cpuid
  1000e6:	9c                   	pushfq 
    popl %eax
  1000e7:	58                   	pop    %rax
    movl %eax,%ecx
  1000e8:	89 c1                	mov    %eax,%ecx
    xorl $0x200000, %eax
  1000ea:	35 00 00 20 00       	xor    $0x200000,%eax
    pushl %eax
  1000ef:	50                   	push   %rax
    popfl
  1000f0:	9d                   	popfq  
    pushfl
  1000f1:	9c                   	pushfq 
    popl %eax
  1000f2:	58                   	pop    %rax
    cmpl %eax,%ebx
  1000f3:	39 c3                	cmp    %eax,%ebx
    jz verify_cpu_no_longmode   # no cpuid -- no long mode
  1000f5:	74 1c                	je     100113 <verify_cpu_no_longmode>

    movl $0x0,%eax              # see if cpuid 1 is implemented
  1000f7:	b8 00 00 00 00       	mov    $0x0,%eax
    cpuid
  1000fc:	0f a2                	cpuid  
    cmpl $0x1,%eax
  1000fe:	83 f8 01             	cmp    $0x1,%eax
    jb verify_cpu_no_longmode    # cpuid 1 is not implemented
  100101:	72 10                	jb     100113 <verify_cpu_no_longmode>


    mov $0x80000001, %eax
  100103:	b8 01 00 00 80       	mov    $0x80000001,%eax
    cpuid                 
  100108:	0f a2                	cpuid  
    test $(1 << 29),%edx                 #Test if the LM-bit, is set or not.
  10010a:	f7 c2 00 00 00 20    	test   $0x20000000,%edx
    jz verify_cpu_no_longmode
  100110:	74 01                	je     100113 <verify_cpu_no_longmode>

    ret
  100112:	c3                   	retq   

0000000000100113 <verify_cpu_no_longmode>:

verify_cpu_no_longmode:
    jmp verify_cpu_no_longmode
  100113:	eb fe                	jmp    100113 <verify_cpu_no_longmode>
  100115:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10011c:	00 00 00 
  10011f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100126:	00 00 00 
  100129:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100130:	00 00 00 
  100133:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10013a:	00 00 00 
  10013d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100144:	00 00 00 
  100147:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10014e:	00 00 00 
  100151:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100158:	00 00 00 
  10015b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100162:	00 00 00 
  100165:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10016c:	00 00 00 
  10016f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100176:	00 00 00 
  100179:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100180:	00 00 00 
  100183:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10018a:	00 00 00 
  10018d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100194:	00 00 00 
  100197:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10019e:	00 00 00 
  1001a1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001a8:	00 00 00 
  1001ab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001b2:	00 00 00 
  1001b5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001bc:	00 00 00 
  1001bf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001c6:	00 00 00 
  1001c9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001d0:	00 00 00 
  1001d3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001da:	00 00 00 
  1001dd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001e4:	00 00 00 
  1001e7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001ee:	00 00 00 
  1001f1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1001f8:	00 00 00 
  1001fb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100202:	00 00 00 
  100205:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10020c:	00 00 00 
  10020f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100216:	00 00 00 
  100219:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100220:	00 00 00 
  100223:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10022a:	00 00 00 
  10022d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100234:	00 00 00 
  100237:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10023e:	00 00 00 
  100241:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100248:	00 00 00 
  10024b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100252:	00 00 00 
  100255:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10025c:	00 00 00 
  10025f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100266:	00 00 00 
  100269:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100270:	00 00 00 
  100273:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10027a:	00 00 00 
  10027d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100284:	00 00 00 
  100287:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10028e:	00 00 00 
  100291:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100298:	00 00 00 
  10029b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002a2:	00 00 00 
  1002a5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002ac:	00 00 00 
  1002af:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002b6:	00 00 00 
  1002b9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002c0:	00 00 00 
  1002c3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002ca:	00 00 00 
  1002cd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002d4:	00 00 00 
  1002d7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002de:	00 00 00 
  1002e1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002e8:	00 00 00 
  1002eb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002f2:	00 00 00 
  1002f5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1002fc:	00 00 00 
  1002ff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100306:	00 00 00 
  100309:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100310:	00 00 00 
  100313:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10031a:	00 00 00 
  10031d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100324:	00 00 00 
  100327:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10032e:	00 00 00 
  100331:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100338:	00 00 00 
  10033b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100342:	00 00 00 
  100345:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10034c:	00 00 00 
  10034f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100356:	00 00 00 
  100359:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100360:	00 00 00 
  100363:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10036a:	00 00 00 
  10036d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100374:	00 00 00 
  100377:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10037e:	00 00 00 
  100381:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100388:	00 00 00 
  10038b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100392:	00 00 00 
  100395:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10039c:	00 00 00 
  10039f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003a6:	00 00 00 
  1003a9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003b0:	00 00 00 
  1003b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003ba:	00 00 00 
  1003bd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003c4:	00 00 00 
  1003c7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003ce:	00 00 00 
  1003d1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003d8:	00 00 00 
  1003db:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003e2:	00 00 00 
  1003e5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003ec:	00 00 00 
  1003ef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1003f6:	00 00 00 
  1003f9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100400:	00 00 00 
  100403:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10040a:	00 00 00 
  10040d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100414:	00 00 00 
  100417:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10041e:	00 00 00 
  100421:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100428:	00 00 00 
  10042b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100432:	00 00 00 
  100435:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10043c:	00 00 00 
  10043f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100446:	00 00 00 
  100449:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100450:	00 00 00 
  100453:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10045a:	00 00 00 
  10045d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100464:	00 00 00 
  100467:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10046e:	00 00 00 
  100471:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100478:	00 00 00 
  10047b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100482:	00 00 00 
  100485:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10048c:	00 00 00 
  10048f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100496:	00 00 00 
  100499:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004a0:	00 00 00 
  1004a3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004aa:	00 00 00 
  1004ad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004b4:	00 00 00 
  1004b7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004be:	00 00 00 
  1004c1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004c8:	00 00 00 
  1004cb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004d2:	00 00 00 
  1004d5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004dc:	00 00 00 
  1004df:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004e6:	00 00 00 
  1004e9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004f0:	00 00 00 
  1004f3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1004fa:	00 00 00 
  1004fd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100504:	00 00 00 
  100507:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10050e:	00 00 00 
  100511:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100518:	00 00 00 
  10051b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100522:	00 00 00 
  100525:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10052c:	00 00 00 
  10052f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100536:	00 00 00 
  100539:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100540:	00 00 00 
  100543:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10054a:	00 00 00 
  10054d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100554:	00 00 00 
  100557:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10055e:	00 00 00 
  100561:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100568:	00 00 00 
  10056b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100572:	00 00 00 
  100575:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10057c:	00 00 00 
  10057f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100586:	00 00 00 
  100589:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100590:	00 00 00 
  100593:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10059a:	00 00 00 
  10059d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005a4:	00 00 00 
  1005a7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005ae:	00 00 00 
  1005b1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005b8:	00 00 00 
  1005bb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005c2:	00 00 00 
  1005c5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005cc:	00 00 00 
  1005cf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005d6:	00 00 00 
  1005d9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005e0:	00 00 00 
  1005e3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005ea:	00 00 00 
  1005ed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005f4:	00 00 00 
  1005f7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1005fe:	00 00 00 
  100601:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100608:	00 00 00 
  10060b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100612:	00 00 00 
  100615:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10061c:	00 00 00 
  10061f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100626:	00 00 00 
  100629:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100630:	00 00 00 
  100633:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10063a:	00 00 00 
  10063d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100644:	00 00 00 
  100647:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10064e:	00 00 00 
  100651:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100658:	00 00 00 
  10065b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100662:	00 00 00 
  100665:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10066c:	00 00 00 
  10066f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100676:	00 00 00 
  100679:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100680:	00 00 00 
  100683:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10068a:	00 00 00 
  10068d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100694:	00 00 00 
  100697:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10069e:	00 00 00 
  1006a1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006a8:	00 00 00 
  1006ab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006b2:	00 00 00 
  1006b5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006bc:	00 00 00 
  1006bf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006c6:	00 00 00 
  1006c9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006d0:	00 00 00 
  1006d3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006da:	00 00 00 
  1006dd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006e4:	00 00 00 
  1006e7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006ee:	00 00 00 
  1006f1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1006f8:	00 00 00 
  1006fb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100702:	00 00 00 
  100705:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10070c:	00 00 00 
  10070f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100716:	00 00 00 
  100719:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100720:	00 00 00 
  100723:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10072a:	00 00 00 
  10072d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100734:	00 00 00 
  100737:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10073e:	00 00 00 
  100741:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100748:	00 00 00 
  10074b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100752:	00 00 00 
  100755:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10075c:	00 00 00 
  10075f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100766:	00 00 00 
  100769:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100770:	00 00 00 
  100773:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10077a:	00 00 00 
  10077d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100784:	00 00 00 
  100787:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10078e:	00 00 00 
  100791:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100798:	00 00 00 
  10079b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007a2:	00 00 00 
  1007a5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007ac:	00 00 00 
  1007af:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007b6:	00 00 00 
  1007b9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007c0:	00 00 00 
  1007c3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007ca:	00 00 00 
  1007cd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007d4:	00 00 00 
  1007d7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007de:	00 00 00 
  1007e1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007e8:	00 00 00 
  1007eb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007f2:	00 00 00 
  1007f5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1007fc:	00 00 00 
  1007ff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100806:	00 00 00 
  100809:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100810:	00 00 00 
  100813:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10081a:	00 00 00 
  10081d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100824:	00 00 00 
  100827:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10082e:	00 00 00 
  100831:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100838:	00 00 00 
  10083b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100842:	00 00 00 
  100845:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10084c:	00 00 00 
  10084f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100856:	00 00 00 
  100859:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100860:	00 00 00 
  100863:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10086a:	00 00 00 
  10086d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100874:	00 00 00 
  100877:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10087e:	00 00 00 
  100881:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100888:	00 00 00 
  10088b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100892:	00 00 00 
  100895:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10089c:	00 00 00 
  10089f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008a6:	00 00 00 
  1008a9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008b0:	00 00 00 
  1008b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008ba:	00 00 00 
  1008bd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008c4:	00 00 00 
  1008c7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008ce:	00 00 00 
  1008d1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008d8:	00 00 00 
  1008db:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008e2:	00 00 00 
  1008e5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008ec:	00 00 00 
  1008ef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1008f6:	00 00 00 
  1008f9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100900:	00 00 00 
  100903:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10090a:	00 00 00 
  10090d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100914:	00 00 00 
  100917:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10091e:	00 00 00 
  100921:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100928:	00 00 00 
  10092b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100932:	00 00 00 
  100935:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10093c:	00 00 00 
  10093f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100946:	00 00 00 
  100949:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100950:	00 00 00 
  100953:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10095a:	00 00 00 
  10095d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100964:	00 00 00 
  100967:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10096e:	00 00 00 
  100971:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100978:	00 00 00 
  10097b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100982:	00 00 00 
  100985:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  10098c:	00 00 00 
  10098f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100996:	00 00 00 
  100999:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009a0:	00 00 00 
  1009a3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009aa:	00 00 00 
  1009ad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009b4:	00 00 00 
  1009b7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009be:	00 00 00 
  1009c1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009c8:	00 00 00 
  1009cb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009d2:	00 00 00 
  1009d5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009dc:	00 00 00 
  1009df:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009e6:	00 00 00 
  1009e9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009f0:	00 00 00 
  1009f3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1009fa:	00 00 00 
  1009fd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a04:	00 00 00 
  100a07:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a0e:	00 00 00 
  100a11:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a18:	00 00 00 
  100a1b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a22:	00 00 00 
  100a25:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a2c:	00 00 00 
  100a2f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a36:	00 00 00 
  100a39:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a40:	00 00 00 
  100a43:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a4a:	00 00 00 
  100a4d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a54:	00 00 00 
  100a57:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a5e:	00 00 00 
  100a61:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a68:	00 00 00 
  100a6b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a72:	00 00 00 
  100a75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a7c:	00 00 00 
  100a7f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a86:	00 00 00 
  100a89:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a90:	00 00 00 
  100a93:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100a9a:	00 00 00 
  100a9d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100aa4:	00 00 00 
  100aa7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100aae:	00 00 00 
  100ab1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ab8:	00 00 00 
  100abb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ac2:	00 00 00 
  100ac5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100acc:	00 00 00 
  100acf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ad6:	00 00 00 
  100ad9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ae0:	00 00 00 
  100ae3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100aea:	00 00 00 
  100aed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100af4:	00 00 00 
  100af7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100afe:	00 00 00 
  100b01:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b08:	00 00 00 
  100b0b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b12:	00 00 00 
  100b15:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b1c:	00 00 00 
  100b1f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b26:	00 00 00 
  100b29:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b30:	00 00 00 
  100b33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b3a:	00 00 00 
  100b3d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b44:	00 00 00 
  100b47:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b4e:	00 00 00 
  100b51:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b58:	00 00 00 
  100b5b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b62:	00 00 00 
  100b65:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b6c:	00 00 00 
  100b6f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b76:	00 00 00 
  100b79:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b80:	00 00 00 
  100b83:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b8a:	00 00 00 
  100b8d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b94:	00 00 00 
  100b97:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100b9e:	00 00 00 
  100ba1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ba8:	00 00 00 
  100bab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bb2:	00 00 00 
  100bb5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bbc:	00 00 00 
  100bbf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bc6:	00 00 00 
  100bc9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bd0:	00 00 00 
  100bd3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bda:	00 00 00 
  100bdd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100be4:	00 00 00 
  100be7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bee:	00 00 00 
  100bf1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100bf8:	00 00 00 
  100bfb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c02:	00 00 00 
  100c05:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c0c:	00 00 00 
  100c0f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c16:	00 00 00 
  100c19:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c20:	00 00 00 
  100c23:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c2a:	00 00 00 
  100c2d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c34:	00 00 00 
  100c37:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c3e:	00 00 00 
  100c41:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c48:	00 00 00 
  100c4b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c52:	00 00 00 
  100c55:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c5c:	00 00 00 
  100c5f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c66:	00 00 00 
  100c69:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c70:	00 00 00 
  100c73:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c7a:	00 00 00 
  100c7d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c84:	00 00 00 
  100c87:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c8e:	00 00 00 
  100c91:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100c98:	00 00 00 
  100c9b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ca2:	00 00 00 
  100ca5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cac:	00 00 00 
  100caf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cb6:	00 00 00 
  100cb9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cc0:	00 00 00 
  100cc3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cca:	00 00 00 
  100ccd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cd4:	00 00 00 
  100cd7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cde:	00 00 00 
  100ce1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ce8:	00 00 00 
  100ceb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cf2:	00 00 00 
  100cf5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100cfc:	00 00 00 
  100cff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d06:	00 00 00 
  100d09:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d10:	00 00 00 
  100d13:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d1a:	00 00 00 
  100d1d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d24:	00 00 00 
  100d27:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d2e:	00 00 00 
  100d31:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d38:	00 00 00 
  100d3b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d42:	00 00 00 
  100d45:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d4c:	00 00 00 
  100d4f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d56:	00 00 00 
  100d59:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d60:	00 00 00 
  100d63:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d6a:	00 00 00 
  100d6d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d74:	00 00 00 
  100d77:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d7e:	00 00 00 
  100d81:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d88:	00 00 00 
  100d8b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d92:	00 00 00 
  100d95:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100d9c:	00 00 00 
  100d9f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100da6:	00 00 00 
  100da9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100db0:	00 00 00 
  100db3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100dba:	00 00 00 
  100dbd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100dc4:	00 00 00 
  100dc7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100dce:	00 00 00 
  100dd1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100dd8:	00 00 00 
  100ddb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100de2:	00 00 00 
  100de5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100dec:	00 00 00 
  100def:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100df6:	00 00 00 
  100df9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e00:	00 00 00 
  100e03:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e0a:	00 00 00 
  100e0d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e14:	00 00 00 
  100e17:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e1e:	00 00 00 
  100e21:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e28:	00 00 00 
  100e2b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e32:	00 00 00 
  100e35:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e3c:	00 00 00 
  100e3f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e46:	00 00 00 
  100e49:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e50:	00 00 00 
  100e53:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e5a:	00 00 00 
  100e5d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e64:	00 00 00 
  100e67:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e6e:	00 00 00 
  100e71:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e78:	00 00 00 
  100e7b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e82:	00 00 00 
  100e85:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e8c:	00 00 00 
  100e8f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100e96:	00 00 00 
  100e99:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ea0:	00 00 00 
  100ea3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100eaa:	00 00 00 
  100ead:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100eb4:	00 00 00 
  100eb7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ebe:	00 00 00 
  100ec1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ec8:	00 00 00 
  100ecb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ed2:	00 00 00 
  100ed5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100edc:	00 00 00 
  100edf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ee6:	00 00 00 
  100ee9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ef0:	00 00 00 
  100ef3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100efa:	00 00 00 
  100efd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f04:	00 00 00 
  100f07:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f0e:	00 00 00 
  100f11:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f18:	00 00 00 
  100f1b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f22:	00 00 00 
  100f25:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f2c:	00 00 00 
  100f2f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f36:	00 00 00 
  100f39:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f40:	00 00 00 
  100f43:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f4a:	00 00 00 
  100f4d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f54:	00 00 00 
  100f57:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f5e:	00 00 00 
  100f61:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f68:	00 00 00 
  100f6b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f72:	00 00 00 
  100f75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f7c:	00 00 00 
  100f7f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f86:	00 00 00 
  100f89:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f90:	00 00 00 
  100f93:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100f9a:	00 00 00 
  100f9d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fa4:	00 00 00 
  100fa7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fae:	00 00 00 
  100fb1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fb8:	00 00 00 
  100fbb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fc2:	00 00 00 
  100fc5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fcc:	00 00 00 
  100fcf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fd6:	00 00 00 
  100fd9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fe0:	00 00 00 
  100fe3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100fea:	00 00 00 
  100fed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  100ff4:	00 00 00 
  100ff7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  100ffe:	00 00 

0000000000101000 <gdt_64>:
	...
  101008:	ff                   	(bad)  
  101009:	ff 00                	incl   (%rax)
  10100b:	00 00                	add    %al,(%rax)
  10100d:	9a                   	(bad)  
  10100e:	af                   	scas   %es:(%rdi),%eax
  10100f:	00 ff                	add    %bh,%bh
  101011:	ff 00                	incl   (%rax)
  101013:	00 00                	add    %al,(%rax)
  101015:	92                   	xchg   %eax,%edx
  101016:	cf                   	iret   
	...

0000000000101018 <gdtdesc_64>:
  101018:	17                   	(bad)  
  101019:	00 00                	add    %al,(%rax)
  10101b:	10 10                	adc    %dl,(%rax)
	...

0000000000102000 <pml4phys>:
	...

0000000000103000 <pdpt1>:
	...

0000000000104000 <pdpt2>:
	...

0000000000105000 <pde1>:
	...

0000000000106000 <pde2>:
	...

0000000000107000 <multiboot_info>:
  107000:	00 00                	add    %al,(%rax)
	...

Disassembly of section .text:

0000008004200000 <_start+0x8003fffff4>:
  8004200000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
  8004200006:	00 00                	add    %al,(%rax)
  8004200008:	fe 4f 52             	decb   0x52(%rdi)
  800420000b:	e4 48                	in     $0x48,%al

000000800420000c <entry>:
entry:

/* .globl _back_from_head64 */
/* _back_from_head64: */

    movabs   $gdtdesc_64,%rax
  800420000c:	48 b8 38 c0 21 04 80 	movabs $0x800421c038,%rax
  8004200013:	00 00 00 
    lgdt     (%rax)
  8004200016:	0f 01 10             	lgdt   (%rax)
    movw    $DATA_SEL,%ax
  8004200019:	66 b8 10 00          	mov    $0x10,%ax
    movw    %ax,%ds
  800420001d:	8e d8                	mov    %eax,%ds
    movw    %ax,%ss
  800420001f:	8e d0                	mov    %eax,%ss
    movw    %ax,%fs
  8004200021:	8e e0                	mov    %eax,%fs
    movw    %ax,%gs
  8004200023:	8e e8                	mov    %eax,%gs
    movw    %ax,%es
  8004200025:	8e c0                	mov    %eax,%es
    pushq   $CODE_SEL
  8004200027:	6a 08                	pushq  $0x8
    movabs  $relocated,%rax
  8004200029:	48 b8 36 00 20 04 80 	movabs $0x8004200036,%rax
  8004200030:	00 00 00 
    pushq   %rax
  8004200033:	50                   	push   %rax
    lretq
  8004200034:	48 cb                	lretq  

0000008004200036 <relocated>:
relocated:

	# Clear the frame pointer register (RBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movq	$0x0,%rbp			# nuke frame pointer
  8004200036:	48 c7 c5 00 00 00 00 	mov    $0x0,%rbp

	# Set the stack pointer
	movabs	$(bootstacktop),%rax
  800420003d:	48 b8 00 c0 21 04 80 	movabs $0x800421c000,%rax
  8004200044:	00 00 00 
	movq  %rax,%rsp
  8004200047:	48 89 c4             	mov    %rax,%rsp

	# now to C code
    movabs $i386_init, %rax
  800420004a:	48 b8 dc 00 20 04 80 	movabs $0x80042000dc,%rax
  8004200051:	00 00 00 
	call *%rax
  8004200054:	ff d0                	callq  *%rax

0000008004200056 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
  8004200056:	eb fe                	jmp    8004200056 <spin>

0000008004200058 <test_backtrace>:


// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
  8004200058:	55                   	push   %rbp
  8004200059:	48 89 e5             	mov    %rsp,%rbp
  800420005c:	48 83 ec 10          	sub    $0x10,%rsp
  8004200060:	89 7d fc             	mov    %edi,-0x4(%rbp)
	cprintf("entering test_backtrace %d\n", x);
  8004200063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200066:	89 c6                	mov    %eax,%esi
  8004200068:	48 bf 40 93 20 04 80 	movabs $0x8004209340,%rdi
  800420006f:	00 00 00 
  8004200072:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200077:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  800420007e:	00 00 00 
  8004200081:	ff d2                	callq  *%rdx
	if (x > 0)
  8004200083:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004200087:	7e 16                	jle    800420009f <test_backtrace+0x47>
		test_backtrace(x-1);
  8004200089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420008c:	83 e8 01             	sub    $0x1,%eax
  800420008f:	89 c7                	mov    %eax,%edi
  8004200091:	48 b8 58 00 20 04 80 	movabs $0x8004200058,%rax
  8004200098:	00 00 00 
  800420009b:	ff d0                	callq  *%rax
  800420009d:	eb 1b                	jmp    80042000ba <test_backtrace+0x62>
	else
		mon_backtrace(0, 0, 0);
  800420009f:	ba 00 00 00 00       	mov    $0x0,%edx
  80042000a4:	be 00 00 00 00       	mov    $0x0,%esi
  80042000a9:	bf 00 00 00 00       	mov    $0x0,%edi
  80042000ae:	48 b8 ca 10 20 04 80 	movabs $0x80042010ca,%rax
  80042000b5:	00 00 00 
  80042000b8:	ff d0                	callq  *%rax
	cprintf("leaving test_backtrace %d\n", x);
  80042000ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042000bd:	89 c6                	mov    %eax,%esi
  80042000bf:	48 bf 5c 93 20 04 80 	movabs $0x800420935c,%rdi
  80042000c6:	00 00 00 
  80042000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042000ce:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042000d5:	00 00 00 
  80042000d8:	ff d2                	callq  *%rdx
}
  80042000da:	c9                   	leaveq 
  80042000db:	c3                   	retq   

00000080042000dc <i386_init>:

void
i386_init(void)
{
  80042000dc:	55                   	push   %rbp
  80042000dd:	48 89 e5             	mov    %rsp,%rbp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
  80042000e0:	48 ba 40 dd 21 04 80 	movabs $0x800421dd40,%rdx
  80042000e7:	00 00 00 
  80042000ea:	48 b8 a0 c6 21 04 80 	movabs $0x800421c6a0,%rax
  80042000f1:	00 00 00 
  80042000f4:	48 29 c2             	sub    %rax,%rdx
  80042000f7:	48 89 d0             	mov    %rdx,%rax
  80042000fa:	48 89 c2             	mov    %rax,%rdx
  80042000fd:	be 00 00 00 00       	mov    $0x0,%esi
  8004200102:	48 bf a0 c6 21 04 80 	movabs $0x800421c6a0,%rdi
  8004200109:	00 00 00 
  800420010c:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  8004200113:	00 00 00 
  8004200116:	ff d0                	callq  *%rax

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
  8004200118:	48 b8 fa 0d 20 04 80 	movabs $0x8004200dfa,%rax
  800420011f:	00 00 00 
  8004200122:	ff d0                	callq  *%rax

	cprintf("6828 decimal is %o octal!\n", 6828);
  8004200124:	be ac 1a 00 00       	mov    $0x1aac,%esi
  8004200129:	48 bf 77 93 20 04 80 	movabs $0x8004209377,%rdi
  8004200130:	00 00 00 
  8004200133:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200138:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  800420013f:	00 00 00 
  8004200142:	ff d2                	callq  *%rdx

	extern char end[];
	end_debug = read_section_headers((0x10000+KERNBASE), (uintptr_t)end);
  8004200144:	48 b8 40 dd 21 04 80 	movabs $0x800421dd40,%rax
  800420014b:	00 00 00 
  800420014e:	48 89 c6             	mov    %rax,%rsi
  8004200151:	48 bf 00 00 01 04 80 	movabs $0x8004010000,%rdi
  8004200158:	00 00 00 
  800420015b:	48 b8 66 89 20 04 80 	movabs $0x8004208966,%rax
  8004200162:	00 00 00 
  8004200165:	ff d0                	callq  *%rax
  8004200167:	48 ba 48 cd 21 04 80 	movabs $0x800421cd48,%rdx
  800420016e:	00 00 00 
  8004200171:	48 89 02             	mov    %rax,(%rdx)




	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
  8004200174:	bf 05 00 00 00       	mov    $0x5,%edi
  8004200179:	48 b8 58 00 20 04 80 	movabs $0x8004200058,%rax
  8004200180:	00 00 00 
  8004200183:	ff d0                	callq  *%rax

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
  8004200185:	bf 00 00 00 00       	mov    $0x0,%edi
  800420018a:	48 b8 f5 12 20 04 80 	movabs $0x80042012f5,%rax
  8004200191:	00 00 00 
  8004200194:	ff d0                	callq  *%rax
  8004200196:	eb ed                	jmp    8004200185 <i386_init+0xa9>

0000008004200198 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004200198:	55                   	push   %rbp
  8004200199:	48 89 e5             	mov    %rsp,%rbp
  800420019c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80042001a3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80042001aa:	89 b5 24 ff ff ff    	mov    %esi,-0xdc(%rbp)
  80042001b0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80042001b7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80042001be:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80042001c5:	84 c0                	test   %al,%al
  80042001c7:	74 20                	je     80042001e9 <_panic+0x51>
  80042001c9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80042001cd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80042001d1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80042001d5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042001d9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80042001dd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80042001e1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80042001e5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80042001e9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	if (panicstr)
  80042001f0:	48 b8 50 cd 21 04 80 	movabs $0x800421cd50,%rax
  80042001f7:	00 00 00 
  80042001fa:	48 8b 00             	mov    (%rax),%rax
  80042001fd:	48 85 c0             	test   %rax,%rax
  8004200200:	74 05                	je     8004200207 <_panic+0x6f>
		goto dead;
  8004200202:	e9 a9 00 00 00       	jmpq   80042002b0 <_panic+0x118>
	panicstr = fmt;
  8004200207:	48 b8 50 cd 21 04 80 	movabs $0x800421cd50,%rax
  800420020e:	00 00 00 
  8004200211:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004200218:	48 89 10             	mov    %rdx,(%rax)

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
  800420021b:	fa                   	cli    
  800420021c:	fc                   	cld    

	va_start(ap, fmt);
  800420021d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8004200224:	00 00 00 
  8004200227:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800420022e:	00 00 00 
  8004200231:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004200235:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800420023c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004200243:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	cprintf("kernel panic at %s:%d: ", file, line);
  800420024a:	8b 95 24 ff ff ff    	mov    -0xdc(%rbp),%edx
  8004200250:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004200257:	48 89 c6             	mov    %rax,%rsi
  800420025a:	48 bf 92 93 20 04 80 	movabs $0x8004209392,%rdi
  8004200261:	00 00 00 
  8004200264:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200269:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004200270:	00 00 00 
  8004200273:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  8004200275:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  800420027c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004200283:	48 89 d6             	mov    %rdx,%rsi
  8004200286:	48 89 c7             	mov    %rax,%rdi
  8004200289:	48 b8 aa 13 20 04 80 	movabs $0x80042013aa,%rax
  8004200290:	00 00 00 
  8004200293:	ff d0                	callq  *%rax
	cprintf("\n");
  8004200295:	48 bf aa 93 20 04 80 	movabs $0x80042093aa,%rdi
  800420029c:	00 00 00 
  800420029f:	b8 00 00 00 00       	mov    $0x0,%eax
  80042002a4:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042002ab:	00 00 00 
  80042002ae:	ff d2                	callq  *%rdx
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
  80042002b0:	bf 00 00 00 00       	mov    $0x0,%edi
  80042002b5:	48 b8 f5 12 20 04 80 	movabs $0x80042012f5,%rax
  80042002bc:	00 00 00 
  80042002bf:	ff d0                	callq  *%rax
  80042002c1:	eb ed                	jmp    80042002b0 <_panic+0x118>

00000080042002c3 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
  80042002c3:	55                   	push   %rbp
  80042002c4:	48 89 e5             	mov    %rsp,%rbp
  80042002c7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80042002ce:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80042002d5:	89 b5 24 ff ff ff    	mov    %esi,-0xdc(%rbp)
  80042002db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80042002e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80042002e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80042002f0:	84 c0                	test   %al,%al
  80042002f2:	74 20                	je     8004200314 <_warn+0x51>
  80042002f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80042002f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80042002fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004200300:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004200304:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004200308:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800420030c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004200310:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004200314:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800420031b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8004200322:	00 00 00 
  8004200325:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800420032c:	00 00 00 
  800420032f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004200333:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800420033a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004200341:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	cprintf("kernel warning at %s:%d: ", file, line);
  8004200348:	8b 95 24 ff ff ff    	mov    -0xdc(%rbp),%edx
  800420034e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004200355:	48 89 c6             	mov    %rax,%rsi
  8004200358:	48 bf ac 93 20 04 80 	movabs $0x80042093ac,%rdi
  800420035f:	00 00 00 
  8004200362:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200367:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  800420036e:	00 00 00 
  8004200371:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  8004200373:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  800420037a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004200381:	48 89 d6             	mov    %rdx,%rsi
  8004200384:	48 89 c7             	mov    %rax,%rdi
  8004200387:	48 b8 aa 13 20 04 80 	movabs $0x80042013aa,%rax
  800420038e:	00 00 00 
  8004200391:	ff d0                	callq  *%rax
	cprintf("\n");
  8004200393:	48 bf aa 93 20 04 80 	movabs $0x80042093aa,%rdi
  800420039a:	00 00 00 
  800420039d:	b8 00 00 00 00       	mov    $0x0,%eax
  80042003a2:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042003a9:	00 00 00 
  80042003ac:	ff d2                	callq  *%rdx
	va_end(ap);
}
  80042003ae:	c9                   	leaveq 
  80042003af:	c3                   	retq   

00000080042003b0 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
  80042003b0:	55                   	push   %rbp
  80042003b1:	48 89 e5             	mov    %rsp,%rbp
  80042003b4:	48 83 ec 20          	sub    $0x20,%rsp
  80042003b8:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042003c2:	89 c2                	mov    %eax,%edx
  80042003c4:	ec                   	in     (%dx),%al
  80042003c5:	88 45 fb             	mov    %al,-0x5(%rbp)
  80042003c8:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
  80042003cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042003d2:	89 c2                	mov    %eax,%edx
  80042003d4:	ec                   	in     (%dx),%al
  80042003d5:	88 45 f3             	mov    %al,-0xd(%rbp)
  80042003d8:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
  80042003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042003e2:	89 c2                	mov    %eax,%edx
  80042003e4:	ec                   	in     (%dx),%al
  80042003e5:	88 45 eb             	mov    %al,-0x15(%rbp)
  80042003e8:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
  80042003ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042003f2:	89 c2                	mov    %eax,%edx
  80042003f4:	ec                   	in     (%dx),%al
  80042003f5:	88 45 e3             	mov    %al,-0x1d(%rbp)
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
  80042003f8:	c9                   	leaveq 
  80042003f9:	c3                   	retq   

00000080042003fa <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
  80042003fa:	55                   	push   %rbp
  80042003fb:	48 89 e5             	mov    %rsp,%rbp
  80042003fe:	48 83 ec 10          	sub    $0x10,%rsp
  8004200402:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%rbp)
  8004200409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420040c:	89 c2                	mov    %eax,%edx
  800420040e:	ec                   	in     (%dx),%al
  800420040f:	88 45 fb             	mov    %al,-0x5(%rbp)
	return data;
  8004200412:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  8004200416:	0f b6 c0             	movzbl %al,%eax
  8004200419:	83 e0 01             	and    $0x1,%eax
  800420041c:	85 c0                	test   %eax,%eax
  800420041e:	75 07                	jne    8004200427 <serial_proc_data+0x2d>
		return -1;
  8004200420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004200425:	eb 17                	jmp    800420043e <serial_proc_data+0x44>
  8004200427:	c7 45 f4 f8 03 00 00 	movl   $0x3f8,-0xc(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800420042e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004200431:	89 c2                	mov    %eax,%edx
  8004200433:	ec                   	in     (%dx),%al
  8004200434:	88 45 f3             	mov    %al,-0xd(%rbp)
	return data;
  8004200437:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
	return inb(COM1+COM_RX);
  800420043b:	0f b6 c0             	movzbl %al,%eax
}
  800420043e:	c9                   	leaveq 
  800420043f:	c3                   	retq   

0000008004200440 <serial_intr>:

void
serial_intr(void)
{
  8004200440:	55                   	push   %rbp
  8004200441:	48 89 e5             	mov    %rsp,%rbp
	if (serial_exists)
  8004200444:	48 b8 a0 c6 21 04 80 	movabs $0x800421c6a0,%rax
  800420044b:	00 00 00 
  800420044e:	0f b6 00             	movzbl (%rax),%eax
  8004200451:	84 c0                	test   %al,%al
  8004200453:	74 16                	je     800420046b <serial_intr+0x2b>
		cons_intr(serial_proc_data);
  8004200455:	48 bf fa 03 20 04 80 	movabs $0x80042003fa,%rdi
  800420045c:	00 00 00 
  800420045f:	48 b8 7d 0c 20 04 80 	movabs $0x8004200c7d,%rax
  8004200466:	00 00 00 
  8004200469:	ff d0                	callq  *%rax
}
  800420046b:	5d                   	pop    %rbp
  800420046c:	c3                   	retq   

000000800420046d <serial_putc>:

static void
serial_putc(int c)
{
  800420046d:	55                   	push   %rbp
  800420046e:	48 89 e5             	mov    %rsp,%rbp
  8004200471:	48 83 ec 28          	sub    $0x28,%rsp
  8004200475:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i;

	for (i = 0;
  8004200478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800420047f:	eb 10                	jmp    8004200491 <serial_putc+0x24>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
  8004200481:	48 b8 b0 03 20 04 80 	movabs $0x80042003b0,%rax
  8004200488:	00 00 00 
  800420048b:	ff d0                	callq  *%rax
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
  800420048d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004200491:	c7 45 f8 fd 03 00 00 	movl   $0x3fd,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200498:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800420049b:	89 c2                	mov    %eax,%edx
  800420049d:	ec                   	in     (%dx),%al
  800420049e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  80042004a1:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
serial_putc(int c)
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  80042004a5:	0f b6 c0             	movzbl %al,%eax
  80042004a8:	83 e0 20             	and    $0x20,%eax
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
  80042004ab:	85 c0                	test   %eax,%eax
  80042004ad:	75 09                	jne    80042004b8 <serial_putc+0x4b>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  80042004af:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
  80042004b6:	7e c9                	jle    8004200481 <serial_putc+0x14>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
  80042004b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042004bb:	0f b6 c0             	movzbl %al,%eax
  80042004be:	c7 45 f0 f8 03 00 00 	movl   $0x3f8,-0x10(%rbp)
  80042004c5:	88 45 ef             	mov    %al,-0x11(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80042004c8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80042004cc:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80042004cf:	ee                   	out    %al,(%dx)
}
  80042004d0:	c9                   	leaveq 
  80042004d1:	c3                   	retq   

00000080042004d2 <serial_init>:

static void
serial_init(void)
{
  80042004d2:	55                   	push   %rbp
  80042004d3:	48 89 e5             	mov    %rsp,%rbp
  80042004d6:	48 83 ec 50          	sub    $0x50,%rsp
  80042004da:	c7 45 fc fa 03 00 00 	movl   $0x3fa,-0x4(%rbp)
  80042004e1:	c6 45 fb 00          	movb   $0x0,-0x5(%rbp)
  80042004e5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80042004e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042004ec:	ee                   	out    %al,(%dx)
  80042004ed:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%rbp)
  80042004f4:	c6 45 f3 80          	movb   $0x80,-0xd(%rbp)
  80042004f8:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80042004fc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042004ff:	ee                   	out    %al,(%dx)
  8004200500:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%rbp)
  8004200507:	c6 45 eb 0c          	movb   $0xc,-0x15(%rbp)
  800420050b:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  800420050f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004200512:	ee                   	out    %al,(%dx)
  8004200513:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%rbp)
  800420051a:	c6 45 e3 00          	movb   $0x0,-0x1d(%rbp)
  800420051e:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8004200522:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004200525:	ee                   	out    %al,(%dx)
  8004200526:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%rbp)
  800420052d:	c6 45 db 03          	movb   $0x3,-0x25(%rbp)
  8004200531:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  8004200535:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004200538:	ee                   	out    %al,(%dx)
  8004200539:	c7 45 d4 fc 03 00 00 	movl   $0x3fc,-0x2c(%rbp)
  8004200540:	c6 45 d3 00          	movb   $0x0,-0x2d(%rbp)
  8004200544:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  8004200548:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800420054b:	ee                   	out    %al,(%dx)
  800420054c:	c7 45 cc f9 03 00 00 	movl   $0x3f9,-0x34(%rbp)
  8004200553:	c6 45 cb 01          	movb   $0x1,-0x35(%rbp)
  8004200557:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
  800420055b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420055e:	ee                   	out    %al,(%dx)
  800420055f:	c7 45 c4 fd 03 00 00 	movl   $0x3fd,-0x3c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200566:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8004200569:	89 c2                	mov    %eax,%edx
  800420056b:	ec                   	in     (%dx),%al
  800420056c:	88 45 c3             	mov    %al,-0x3d(%rbp)
	return data;
  800420056f:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  8004200573:	3c ff                	cmp    $0xff,%al
  8004200575:	0f 95 c2             	setne  %dl
  8004200578:	48 b8 a0 c6 21 04 80 	movabs $0x800421c6a0,%rax
  800420057f:	00 00 00 
  8004200582:	88 10                	mov    %dl,(%rax)
  8004200584:	c7 45 bc fa 03 00 00 	movl   $0x3fa,-0x44(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800420058b:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800420058e:	89 c2                	mov    %eax,%edx
  8004200590:	ec                   	in     (%dx),%al
  8004200591:	88 45 bb             	mov    %al,-0x45(%rbp)
  8004200594:	c7 45 b4 f8 03 00 00 	movl   $0x3f8,-0x4c(%rbp)
  800420059b:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  800420059e:	89 c2                	mov    %eax,%edx
  80042005a0:	ec                   	in     (%dx),%al
  80042005a1:	88 45 b3             	mov    %al,-0x4d(%rbp)
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

}
  80042005a4:	c9                   	leaveq 
  80042005a5:	c3                   	retq   

00000080042005a6 <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
  80042005a6:	55                   	push   %rbp
  80042005a7:	48 89 e5             	mov    %rsp,%rbp
  80042005aa:	48 83 ec 38          	sub    $0x38,%rsp
  80042005ae:	89 7d cc             	mov    %edi,-0x34(%rbp)
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  80042005b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80042005b8:	eb 10                	jmp    80042005ca <lpt_putc+0x24>
		delay();
  80042005ba:	48 b8 b0 03 20 04 80 	movabs $0x80042003b0,%rax
  80042005c1:	00 00 00 
  80042005c4:	ff d0                	callq  *%rax
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  80042005c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80042005ca:	c7 45 f8 79 03 00 00 	movl   $0x379,-0x8(%rbp)
  80042005d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042005d4:	89 c2                	mov    %eax,%edx
  80042005d6:	ec                   	in     (%dx),%al
  80042005d7:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  80042005da:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  80042005de:	84 c0                	test   %al,%al
  80042005e0:	78 09                	js     80042005eb <lpt_putc+0x45>
  80042005e2:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
  80042005e9:	7e cf                	jle    80042005ba <lpt_putc+0x14>
		delay();
	outb(0x378+0, c);
  80042005eb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042005ee:	0f b6 c0             	movzbl %al,%eax
  80042005f1:	c7 45 f0 78 03 00 00 	movl   $0x378,-0x10(%rbp)
  80042005f8:	88 45 ef             	mov    %al,-0x11(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80042005fb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80042005ff:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8004200602:	ee                   	out    %al,(%dx)
  8004200603:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
  800420060a:	c6 45 e7 0d          	movb   $0xd,-0x19(%rbp)
  800420060e:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004200612:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8004200615:	ee                   	out    %al,(%dx)
  8004200616:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
  800420061d:	c6 45 df 08          	movb   $0x8,-0x21(%rbp)
  8004200621:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8004200625:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8004200628:	ee                   	out    %al,(%dx)
	outb(0x378+2, 0x08|0x04|0x01);
	outb(0x378+2, 0x08);
}
  8004200629:	c9                   	leaveq 
  800420062a:	c3                   	retq   

000000800420062b <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
  800420062b:	55                   	push   %rbp
  800420062c:	48 89 e5             	mov    %rsp,%rbp
  800420062f:	48 83 ec 30          	sub    $0x30,%rsp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
  8004200633:	48 b8 00 80 0b 04 80 	movabs $0x80040b8000,%rax
  800420063a:	00 00 00 
  800420063d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	was = *cp;
  8004200641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004200645:	0f b7 00             	movzwl (%rax),%eax
  8004200648:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
	*cp = (uint16_t) 0xA55A;
  800420064c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004200650:	66 c7 00 5a a5       	movw   $0xa55a,(%rax)
	if (*cp != 0xA55A) {
  8004200655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004200659:	0f b7 00             	movzwl (%rax),%eax
  800420065c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  8004200660:	74 20                	je     8004200682 <cga_init+0x57>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
  8004200662:	48 b8 00 00 0b 04 80 	movabs $0x80040b0000,%rax
  8004200669:	00 00 00 
  800420066c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		addr_6845 = MONO_BASE;
  8004200670:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  8004200677:	00 00 00 
  800420067a:	c7 00 b4 03 00 00    	movl   $0x3b4,(%rax)
  8004200680:	eb 1b                	jmp    800420069d <cga_init+0x72>
	} else {
		*cp = was;
  8004200682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004200686:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
  800420068a:	66 89 10             	mov    %dx,(%rax)
		addr_6845 = CGA_BASE;
  800420068d:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  8004200694:	00 00 00 
  8004200697:	c7 00 d4 03 00 00    	movl   $0x3d4,(%rax)
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
  800420069d:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  80042006a4:	00 00 00 
  80042006a7:	8b 00                	mov    (%rax),%eax
  80042006a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80042006ac:	c6 45 eb 0e          	movb   $0xe,-0x15(%rbp)
  80042006b0:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  80042006b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80042006b7:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
  80042006b8:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  80042006bf:	00 00 00 
  80042006c2:	8b 00                	mov    (%rax),%eax
  80042006c4:	83 c0 01             	add    $0x1,%eax
  80042006c7:	89 45 e4             	mov    %eax,-0x1c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042006ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042006cd:	89 c2                	mov    %eax,%edx
  80042006cf:	ec                   	in     (%dx),%al
  80042006d0:	88 45 e3             	mov    %al,-0x1d(%rbp)
	return data;
  80042006d3:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80042006d7:	0f b6 c0             	movzbl %al,%eax
  80042006da:	c1 e0 08             	shl    $0x8,%eax
  80042006dd:	89 45 f0             	mov    %eax,-0x10(%rbp)
	outb(addr_6845, 15);
  80042006e0:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  80042006e7:	00 00 00 
  80042006ea:	8b 00                	mov    (%rax),%eax
  80042006ec:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80042006ef:	c6 45 db 0f          	movb   $0xf,-0x25(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80042006f3:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  80042006f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80042006fa:	ee                   	out    %al,(%dx)
	pos |= inb(addr_6845 + 1);
  80042006fb:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  8004200702:	00 00 00 
  8004200705:	8b 00                	mov    (%rax),%eax
  8004200707:	83 c0 01             	add    $0x1,%eax
  800420070a:	89 45 d4             	mov    %eax,-0x2c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800420070d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004200710:	89 c2                	mov    %eax,%edx
  8004200712:	ec                   	in     (%dx),%al
  8004200713:	88 45 d3             	mov    %al,-0x2d(%rbp)
	return data;
  8004200716:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  800420071a:	0f b6 c0             	movzbl %al,%eax
  800420071d:	09 45 f0             	or     %eax,-0x10(%rbp)

	crt_buf = (uint16_t*) cp;
  8004200720:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  8004200727:	00 00 00 
  800420072a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420072e:	48 89 10             	mov    %rdx,(%rax)
	crt_pos = pos;
  8004200731:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8004200734:	89 c2                	mov    %eax,%edx
  8004200736:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  800420073d:	00 00 00 
  8004200740:	66 89 10             	mov    %dx,(%rax)
}
  8004200743:	c9                   	leaveq 
  8004200744:	c3                   	retq   

0000008004200745 <cga_putc>:



static void
cga_putc(int c)
{
  8004200745:	55                   	push   %rbp
  8004200746:	48 89 e5             	mov    %rsp,%rbp
  8004200749:	48 83 ec 40          	sub    $0x40,%rsp
  800420074d:	89 7d cc             	mov    %edi,-0x34(%rbp)
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
  8004200750:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004200753:	b0 00                	mov    $0x0,%al
  8004200755:	85 c0                	test   %eax,%eax
  8004200757:	75 07                	jne    8004200760 <cga_putc+0x1b>
		c |= 0x0700;
  8004200759:	81 4d cc 00 07 00 00 	orl    $0x700,-0x34(%rbp)

	switch (c & 0xff) {
  8004200760:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004200763:	0f b6 c0             	movzbl %al,%eax
  8004200766:	83 f8 09             	cmp    $0x9,%eax
  8004200769:	0f 84 f6 00 00 00    	je     8004200865 <cga_putc+0x120>
  800420076f:	83 f8 09             	cmp    $0x9,%eax
  8004200772:	7f 0a                	jg     800420077e <cga_putc+0x39>
  8004200774:	83 f8 08             	cmp    $0x8,%eax
  8004200777:	74 18                	je     8004200791 <cga_putc+0x4c>
  8004200779:	e9 3e 01 00 00       	jmpq   80042008bc <cga_putc+0x177>
  800420077e:	83 f8 0a             	cmp    $0xa,%eax
  8004200781:	74 75                	je     80042007f8 <cga_putc+0xb3>
  8004200783:	83 f8 0d             	cmp    $0xd,%eax
  8004200786:	0f 84 89 00 00 00    	je     8004200815 <cga_putc+0xd0>
  800420078c:	e9 2b 01 00 00       	jmpq   80042008bc <cga_putc+0x177>
	case '\b':
		if (crt_pos > 0) {
  8004200791:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  8004200798:	00 00 00 
  800420079b:	0f b7 00             	movzwl (%rax),%eax
  800420079e:	66 85 c0             	test   %ax,%ax
  80042007a1:	74 50                	je     80042007f3 <cga_putc+0xae>
			crt_pos--;
  80042007a3:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042007aa:	00 00 00 
  80042007ad:	0f b7 00             	movzwl (%rax),%eax
  80042007b0:	8d 50 ff             	lea    -0x1(%rax),%edx
  80042007b3:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042007ba:	00 00 00 
  80042007bd:	66 89 10             	mov    %dx,(%rax)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
  80042007c0:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  80042007c7:	00 00 00 
  80042007ca:	48 8b 10             	mov    (%rax),%rdx
  80042007cd:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042007d4:	00 00 00 
  80042007d7:	0f b7 00             	movzwl (%rax),%eax
  80042007da:	0f b7 c0             	movzwl %ax,%eax
  80042007dd:	48 01 c0             	add    %rax,%rax
  80042007e0:	48 01 c2             	add    %rax,%rdx
  80042007e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042007e6:	b0 00                	mov    $0x0,%al
  80042007e8:	83 c8 20             	or     $0x20,%eax
  80042007eb:	66 89 02             	mov    %ax,(%rdx)
		}
		break;
  80042007ee:	e9 04 01 00 00       	jmpq   80042008f7 <cga_putc+0x1b2>
  80042007f3:	e9 ff 00 00 00       	jmpq   80042008f7 <cga_putc+0x1b2>
	case '\n':
		crt_pos += CRT_COLS;
  80042007f8:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042007ff:	00 00 00 
  8004200802:	0f b7 00             	movzwl (%rax),%eax
  8004200805:	8d 50 50             	lea    0x50(%rax),%edx
  8004200808:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  800420080f:	00 00 00 
  8004200812:	66 89 10             	mov    %dx,(%rax)
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
  8004200815:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  800420081c:	00 00 00 
  800420081f:	0f b7 30             	movzwl (%rax),%esi
  8004200822:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  8004200829:	00 00 00 
  800420082c:	0f b7 08             	movzwl (%rax),%ecx
  800420082f:	0f b7 c1             	movzwl %cx,%eax
  8004200832:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  8004200838:	c1 e8 10             	shr    $0x10,%eax
  800420083b:	89 c2                	mov    %eax,%edx
  800420083d:	66 c1 ea 06          	shr    $0x6,%dx
  8004200841:	89 d0                	mov    %edx,%eax
  8004200843:	c1 e0 02             	shl    $0x2,%eax
  8004200846:	01 d0                	add    %edx,%eax
  8004200848:	c1 e0 04             	shl    $0x4,%eax
  800420084b:	29 c1                	sub    %eax,%ecx
  800420084d:	89 ca                	mov    %ecx,%edx
  800420084f:	29 d6                	sub    %edx,%esi
  8004200851:	89 f2                	mov    %esi,%edx
  8004200853:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  800420085a:	00 00 00 
  800420085d:	66 89 10             	mov    %dx,(%rax)
		break;
  8004200860:	e9 92 00 00 00       	jmpq   80042008f7 <cga_putc+0x1b2>
	case '\t':
		cons_putc(' ');
  8004200865:	bf 20 00 00 00       	mov    $0x20,%edi
  800420086a:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  8004200871:	00 00 00 
  8004200874:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200876:	bf 20 00 00 00       	mov    $0x20,%edi
  800420087b:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  8004200882:	00 00 00 
  8004200885:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200887:	bf 20 00 00 00       	mov    $0x20,%edi
  800420088c:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  8004200893:	00 00 00 
  8004200896:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200898:	bf 20 00 00 00       	mov    $0x20,%edi
  800420089d:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  80042008a4:	00 00 00 
  80042008a7:	ff d0                	callq  *%rax
		cons_putc(' ');
  80042008a9:	bf 20 00 00 00       	mov    $0x20,%edi
  80042008ae:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  80042008b5:	00 00 00 
  80042008b8:	ff d0                	callq  *%rax
		break;
  80042008ba:	eb 3b                	jmp    80042008f7 <cga_putc+0x1b2>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
  80042008bc:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  80042008c3:	00 00 00 
  80042008c6:	48 8b 30             	mov    (%rax),%rsi
  80042008c9:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042008d0:	00 00 00 
  80042008d3:	0f b7 00             	movzwl (%rax),%eax
  80042008d6:	8d 48 01             	lea    0x1(%rax),%ecx
  80042008d9:	48 ba b0 c6 21 04 80 	movabs $0x800421c6b0,%rdx
  80042008e0:	00 00 00 
  80042008e3:	66 89 0a             	mov    %cx,(%rdx)
  80042008e6:	0f b7 c0             	movzwl %ax,%eax
  80042008e9:	48 01 c0             	add    %rax,%rax
  80042008ec:	48 8d 14 06          	lea    (%rsi,%rax,1),%rdx
  80042008f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042008f3:	66 89 02             	mov    %ax,(%rdx)
		break;
  80042008f6:	90                   	nop
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
  80042008f7:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042008fe:	00 00 00 
  8004200901:	0f b7 00             	movzwl (%rax),%eax
  8004200904:	66 3d cf 07          	cmp    $0x7cf,%ax
  8004200908:	0f 86 89 00 00 00    	jbe    8004200997 <cga_putc+0x252>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  800420090e:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  8004200915:	00 00 00 
  8004200918:	48 8b 00             	mov    (%rax),%rax
  800420091b:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
  8004200922:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  8004200929:	00 00 00 
  800420092c:	48 8b 00             	mov    (%rax),%rax
  800420092f:	ba 00 0f 00 00       	mov    $0xf00,%edx
  8004200934:	48 89 ce             	mov    %rcx,%rsi
  8004200937:	48 89 c7             	mov    %rax,%rdi
  800420093a:	48 b8 d1 2f 20 04 80 	movabs $0x8004202fd1,%rax
  8004200941:	00 00 00 
  8004200944:	ff d0                	callq  *%rax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  8004200946:	c7 45 fc 80 07 00 00 	movl   $0x780,-0x4(%rbp)
  800420094d:	eb 22                	jmp    8004200971 <cga_putc+0x22c>
			crt_buf[i] = 0x0700 | ' ';
  800420094f:	48 b8 a8 c6 21 04 80 	movabs $0x800421c6a8,%rax
  8004200956:	00 00 00 
  8004200959:	48 8b 00             	mov    (%rax),%rax
  800420095c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800420095f:	48 63 d2             	movslq %edx,%rdx
  8004200962:	48 01 d2             	add    %rdx,%rdx
  8004200965:	48 01 d0             	add    %rdx,%rax
  8004200968:	66 c7 00 20 07       	movw   $0x720,(%rax)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  800420096d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004200971:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  8004200978:	7e d5                	jle    800420094f <cga_putc+0x20a>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
  800420097a:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  8004200981:	00 00 00 
  8004200984:	0f b7 00             	movzwl (%rax),%eax
  8004200987:	8d 50 b0             	lea    -0x50(%rax),%edx
  800420098a:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  8004200991:	00 00 00 
  8004200994:	66 89 10             	mov    %dx,(%rax)
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
  8004200997:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  800420099e:	00 00 00 
  80042009a1:	8b 00                	mov    (%rax),%eax
  80042009a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80042009a6:	c6 45 f7 0e          	movb   $0xe,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80042009aa:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  80042009ae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80042009b1:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
  80042009b2:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  80042009b9:	00 00 00 
  80042009bc:	0f b7 00             	movzwl (%rax),%eax
  80042009bf:	66 c1 e8 08          	shr    $0x8,%ax
  80042009c3:	0f b6 c0             	movzbl %al,%eax
  80042009c6:	48 ba a4 c6 21 04 80 	movabs $0x800421c6a4,%rdx
  80042009cd:	00 00 00 
  80042009d0:	8b 12                	mov    (%rdx),%edx
  80042009d2:	83 c2 01             	add    $0x1,%edx
  80042009d5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  80042009d8:	88 45 ef             	mov    %al,-0x11(%rbp)
  80042009db:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80042009df:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80042009e2:	ee                   	out    %al,(%dx)
	outb(addr_6845, 15);
  80042009e3:	48 b8 a4 c6 21 04 80 	movabs $0x800421c6a4,%rax
  80042009ea:	00 00 00 
  80042009ed:	8b 00                	mov    (%rax),%eax
  80042009ef:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80042009f2:	c6 45 e7 0f          	movb   $0xf,-0x19(%rbp)
  80042009f6:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  80042009fa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80042009fd:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos);
  80042009fe:	48 b8 b0 c6 21 04 80 	movabs $0x800421c6b0,%rax
  8004200a05:	00 00 00 
  8004200a08:	0f b7 00             	movzwl (%rax),%eax
  8004200a0b:	0f b6 c0             	movzbl %al,%eax
  8004200a0e:	48 ba a4 c6 21 04 80 	movabs $0x800421c6a4,%rdx
  8004200a15:	00 00 00 
  8004200a18:	8b 12                	mov    (%rdx),%edx
  8004200a1a:	83 c2 01             	add    $0x1,%edx
  8004200a1d:	89 55 e0             	mov    %edx,-0x20(%rbp)
  8004200a20:	88 45 df             	mov    %al,-0x21(%rbp)
  8004200a23:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8004200a27:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8004200a2a:	ee                   	out    %al,(%dx)
}
  8004200a2b:	c9                   	leaveq 
  8004200a2c:	c3                   	retq   

0000008004200a2d <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  8004200a2d:	55                   	push   %rbp
  8004200a2e:	48 89 e5             	mov    %rsp,%rbp
  8004200a31:	48 83 ec 20          	sub    $0x20,%rsp
  8004200a35:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200a3c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004200a3f:	89 c2                	mov    %eax,%edx
  8004200a41:	ec                   	in     (%dx),%al
  8004200a42:	88 45 f3             	mov    %al,-0xd(%rbp)
	return data;
  8004200a45:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
	int c;
	uint8_t data;
	static uint32_t shift;
	int r;
	if ((inb(KBSTATP) & KBS_DIB) == 0)
  8004200a49:	0f b6 c0             	movzbl %al,%eax
  8004200a4c:	83 e0 01             	and    $0x1,%eax
  8004200a4f:	85 c0                	test   %eax,%eax
  8004200a51:	75 0a                	jne    8004200a5d <kbd_proc_data+0x30>
		return -1;
  8004200a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004200a58:	e9 fc 01 00 00       	jmpq   8004200c59 <kbd_proc_data+0x22c>
  8004200a5d:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200a64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004200a67:	89 c2                	mov    %eax,%edx
  8004200a69:	ec                   	in     (%dx),%al
  8004200a6a:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8004200a6d:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax

	data = inb(KBDATAP);
  8004200a71:	88 45 fb             	mov    %al,-0x5(%rbp)

	if (data == 0xE0) {
  8004200a74:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
  8004200a78:	75 27                	jne    8004200aa1 <kbd_proc_data+0x74>
		// E0 escape character
		shift |= E0ESC;
  8004200a7a:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200a81:	00 00 00 
  8004200a84:	8b 00                	mov    (%rax),%eax
  8004200a86:	83 c8 40             	or     $0x40,%eax
  8004200a89:	89 c2                	mov    %eax,%edx
  8004200a8b:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200a92:	00 00 00 
  8004200a95:	89 10                	mov    %edx,(%rax)
		return 0;
  8004200a97:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200a9c:	e9 b8 01 00 00       	jmpq   8004200c59 <kbd_proc_data+0x22c>
	} else if (data & 0x80) {
  8004200aa1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200aa5:	84 c0                	test   %al,%al
  8004200aa7:	79 65                	jns    8004200b0e <kbd_proc_data+0xe1>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
  8004200aa9:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200ab0:	00 00 00 
  8004200ab3:	8b 00                	mov    (%rax),%eax
  8004200ab5:	83 e0 40             	and    $0x40,%eax
  8004200ab8:	85 c0                	test   %eax,%eax
  8004200aba:	75 09                	jne    8004200ac5 <kbd_proc_data+0x98>
  8004200abc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200ac0:	83 e0 7f             	and    $0x7f,%eax
  8004200ac3:	eb 04                	jmp    8004200ac9 <kbd_proc_data+0x9c>
  8004200ac5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200ac9:	88 45 fb             	mov    %al,-0x5(%rbp)
		shift &= ~(shiftcode[data] | E0ESC);
  8004200acc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200ad0:	48 ba 60 c0 21 04 80 	movabs $0x800421c060,%rdx
  8004200ad7:	00 00 00 
  8004200ada:	48 98                	cltq   
  8004200adc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200ae0:	83 c8 40             	or     $0x40,%eax
  8004200ae3:	0f b6 c0             	movzbl %al,%eax
  8004200ae6:	f7 d0                	not    %eax
  8004200ae8:	89 c2                	mov    %eax,%edx
  8004200aea:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200af1:	00 00 00 
  8004200af4:	8b 00                	mov    (%rax),%eax
  8004200af6:	21 c2                	and    %eax,%edx
  8004200af8:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200aff:	00 00 00 
  8004200b02:	89 10                	mov    %edx,(%rax)
		return 0;
  8004200b04:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200b09:	e9 4b 01 00 00       	jmpq   8004200c59 <kbd_proc_data+0x22c>
	} else if (shift & E0ESC) {
  8004200b0e:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b15:	00 00 00 
  8004200b18:	8b 00                	mov    (%rax),%eax
  8004200b1a:	83 e0 40             	and    $0x40,%eax
  8004200b1d:	85 c0                	test   %eax,%eax
  8004200b1f:	74 21                	je     8004200b42 <kbd_proc_data+0x115>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
  8004200b21:	80 4d fb 80          	orb    $0x80,-0x5(%rbp)
		shift &= ~E0ESC;
  8004200b25:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b2c:	00 00 00 
  8004200b2f:	8b 00                	mov    (%rax),%eax
  8004200b31:	83 e0 bf             	and    $0xffffffbf,%eax
  8004200b34:	89 c2                	mov    %eax,%edx
  8004200b36:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b3d:	00 00 00 
  8004200b40:	89 10                	mov    %edx,(%rax)
	}

	shift |= shiftcode[data];
  8004200b42:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200b46:	48 ba 60 c0 21 04 80 	movabs $0x800421c060,%rdx
  8004200b4d:	00 00 00 
  8004200b50:	48 98                	cltq   
  8004200b52:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200b56:	0f b6 d0             	movzbl %al,%edx
  8004200b59:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b60:	00 00 00 
  8004200b63:	8b 00                	mov    (%rax),%eax
  8004200b65:	09 c2                	or     %eax,%edx
  8004200b67:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b6e:	00 00 00 
  8004200b71:	89 10                	mov    %edx,(%rax)
	shift ^= togglecode[data];
  8004200b73:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200b77:	48 ba 60 c1 21 04 80 	movabs $0x800421c160,%rdx
  8004200b7e:	00 00 00 
  8004200b81:	48 98                	cltq   
  8004200b83:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200b87:	0f b6 d0             	movzbl %al,%edx
  8004200b8a:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b91:	00 00 00 
  8004200b94:	8b 00                	mov    (%rax),%eax
  8004200b96:	31 c2                	xor    %eax,%edx
  8004200b98:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200b9f:	00 00 00 
  8004200ba2:	89 10                	mov    %edx,(%rax)

	c = charcode[shift & (CTL | SHIFT)][data];
  8004200ba4:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200bab:	00 00 00 
  8004200bae:	8b 00                	mov    (%rax),%eax
  8004200bb0:	83 e0 03             	and    $0x3,%eax
  8004200bb3:	89 c2                	mov    %eax,%edx
  8004200bb5:	48 b8 60 c5 21 04 80 	movabs $0x800421c560,%rax
  8004200bbc:	00 00 00 
  8004200bbf:	89 d2                	mov    %edx,%edx
  8004200bc1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004200bc5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200bc9:	48 01 d0             	add    %rdx,%rax
  8004200bcc:	0f b6 00             	movzbl (%rax),%eax
  8004200bcf:	0f b6 c0             	movzbl %al,%eax
  8004200bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (shift & CAPSLOCK) {
  8004200bd5:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200bdc:	00 00 00 
  8004200bdf:	8b 00                	mov    (%rax),%eax
  8004200be1:	83 e0 08             	and    $0x8,%eax
  8004200be4:	85 c0                	test   %eax,%eax
  8004200be6:	74 22                	je     8004200c0a <kbd_proc_data+0x1dd>
		if ('a' <= c && c <= 'z')
  8004200be8:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
  8004200bec:	7e 0c                	jle    8004200bfa <kbd_proc_data+0x1cd>
  8004200bee:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
  8004200bf2:	7f 06                	jg     8004200bfa <kbd_proc_data+0x1cd>
			c += 'A' - 'a';
  8004200bf4:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
  8004200bf8:	eb 10                	jmp    8004200c0a <kbd_proc_data+0x1dd>
		else if ('A' <= c && c <= 'Z')
  8004200bfa:	83 7d fc 40          	cmpl   $0x40,-0x4(%rbp)
  8004200bfe:	7e 0a                	jle    8004200c0a <kbd_proc_data+0x1dd>
  8004200c00:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%rbp)
  8004200c04:	7f 04                	jg     8004200c0a <kbd_proc_data+0x1dd>
			c += 'a' - 'A';
  8004200c06:	83 45 fc 20          	addl   $0x20,-0x4(%rbp)
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  8004200c0a:	48 b8 c8 c8 21 04 80 	movabs $0x800421c8c8,%rax
  8004200c11:	00 00 00 
  8004200c14:	8b 00                	mov    (%rax),%eax
  8004200c16:	f7 d0                	not    %eax
  8004200c18:	83 e0 06             	and    $0x6,%eax
  8004200c1b:	85 c0                	test   %eax,%eax
  8004200c1d:	75 37                	jne    8004200c56 <kbd_proc_data+0x229>
  8004200c1f:	81 7d fc e9 00 00 00 	cmpl   $0xe9,-0x4(%rbp)
  8004200c26:	75 2e                	jne    8004200c56 <kbd_proc_data+0x229>
		cprintf("Rebooting!\n");
  8004200c28:	48 bf c6 93 20 04 80 	movabs $0x80042093c6,%rdi
  8004200c2f:	00 00 00 
  8004200c32:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200c37:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004200c3e:	00 00 00 
  8004200c41:	ff d2                	callq  *%rdx
  8004200c43:	c7 45 e4 92 00 00 00 	movl   $0x92,-0x1c(%rbp)
  8004200c4a:	c6 45 e3 03          	movb   $0x3,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004200c4e:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8004200c52:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004200c55:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}
	return c;
  8004200c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004200c59:	c9                   	leaveq 
  8004200c5a:	c3                   	retq   

0000008004200c5b <kbd_intr>:

void
kbd_intr(void)
{
  8004200c5b:	55                   	push   %rbp
  8004200c5c:	48 89 e5             	mov    %rsp,%rbp
	cons_intr(kbd_proc_data);
  8004200c5f:	48 bf 2d 0a 20 04 80 	movabs $0x8004200a2d,%rdi
  8004200c66:	00 00 00 
  8004200c69:	48 b8 7d 0c 20 04 80 	movabs $0x8004200c7d,%rax
  8004200c70:	00 00 00 
  8004200c73:	ff d0                	callq  *%rax
}
  8004200c75:	5d                   	pop    %rbp
  8004200c76:	c3                   	retq   

0000008004200c77 <kbd_init>:

static void
kbd_init(void)
{
  8004200c77:	55                   	push   %rbp
  8004200c78:	48 89 e5             	mov    %rsp,%rbp
}
  8004200c7b:	5d                   	pop    %rbp
  8004200c7c:	c3                   	retq   

0000008004200c7d <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
  8004200c7d:	55                   	push   %rbp
  8004200c7e:	48 89 e5             	mov    %rsp,%rbp
  8004200c81:	48 83 ec 20          	sub    $0x20,%rsp
  8004200c85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int c;

	while ((c = (*proc)()) != -1) {
  8004200c89:	eb 6a                	jmp    8004200cf5 <cons_intr+0x78>
		if (c == 0)
  8004200c8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004200c8f:	75 02                	jne    8004200c93 <cons_intr+0x16>
			continue;
  8004200c91:	eb 62                	jmp    8004200cf5 <cons_intr+0x78>
		cons.buf[cons.wpos++] = c;
  8004200c93:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200c9a:	00 00 00 
  8004200c9d:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200ca3:	8d 48 01             	lea    0x1(%rax),%ecx
  8004200ca6:	48 ba c0 c6 21 04 80 	movabs $0x800421c6c0,%rdx
  8004200cad:	00 00 00 
  8004200cb0:	89 8a 04 02 00 00    	mov    %ecx,0x204(%rdx)
  8004200cb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004200cb9:	89 d1                	mov    %edx,%ecx
  8004200cbb:	48 ba c0 c6 21 04 80 	movabs $0x800421c6c0,%rdx
  8004200cc2:	00 00 00 
  8004200cc5:	89 c0                	mov    %eax,%eax
  8004200cc7:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
		if (cons.wpos == CONSBUFSIZE)
  8004200cca:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200cd1:	00 00 00 
  8004200cd4:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200cda:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004200cdf:	75 14                	jne    8004200cf5 <cons_intr+0x78>
			cons.wpos = 0;
  8004200ce1:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200ce8:	00 00 00 
  8004200ceb:	c7 80 04 02 00 00 00 	movl   $0x0,0x204(%rax)
  8004200cf2:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  8004200cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004200cf9:	ff d0                	callq  *%rax
  8004200cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004200cfe:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  8004200d02:	75 87                	jne    8004200c8b <cons_intr+0xe>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
  8004200d04:	c9                   	leaveq 
  8004200d05:	c3                   	retq   

0000008004200d06 <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
  8004200d06:	55                   	push   %rbp
  8004200d07:	48 89 e5             	mov    %rsp,%rbp
  8004200d0a:	48 83 ec 10          	sub    $0x10,%rsp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
  8004200d0e:	48 b8 40 04 20 04 80 	movabs $0x8004200440,%rax
  8004200d15:	00 00 00 
  8004200d18:	ff d0                	callq  *%rax
	kbd_intr();
  8004200d1a:	48 b8 5b 0c 20 04 80 	movabs $0x8004200c5b,%rax
  8004200d21:	00 00 00 
  8004200d24:	ff d0                	callq  *%rax

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  8004200d26:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200d2d:	00 00 00 
  8004200d30:	8b 90 00 02 00 00    	mov    0x200(%rax),%edx
  8004200d36:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200d3d:	00 00 00 
  8004200d40:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200d46:	39 c2                	cmp    %eax,%edx
  8004200d48:	74 69                	je     8004200db3 <cons_getc+0xad>
		c = cons.buf[cons.rpos++];
  8004200d4a:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200d51:	00 00 00 
  8004200d54:	8b 80 00 02 00 00    	mov    0x200(%rax),%eax
  8004200d5a:	8d 48 01             	lea    0x1(%rax),%ecx
  8004200d5d:	48 ba c0 c6 21 04 80 	movabs $0x800421c6c0,%rdx
  8004200d64:	00 00 00 
  8004200d67:	89 8a 00 02 00 00    	mov    %ecx,0x200(%rdx)
  8004200d6d:	48 ba c0 c6 21 04 80 	movabs $0x800421c6c0,%rdx
  8004200d74:	00 00 00 
  8004200d77:	89 c0                	mov    %eax,%eax
  8004200d79:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200d7d:	0f b6 c0             	movzbl %al,%eax
  8004200d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (cons.rpos == CONSBUFSIZE)
  8004200d83:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200d8a:	00 00 00 
  8004200d8d:	8b 80 00 02 00 00    	mov    0x200(%rax),%eax
  8004200d93:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004200d98:	75 14                	jne    8004200dae <cons_getc+0xa8>
			cons.rpos = 0;
  8004200d9a:	48 b8 c0 c6 21 04 80 	movabs $0x800421c6c0,%rax
  8004200da1:	00 00 00 
  8004200da4:	c7 80 00 02 00 00 00 	movl   $0x0,0x200(%rax)
  8004200dab:	00 00 00 
		return c;
  8004200dae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200db1:	eb 05                	jmp    8004200db8 <cons_getc+0xb2>
	}
	return 0;
  8004200db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004200db8:	c9                   	leaveq 
  8004200db9:	c3                   	retq   

0000008004200dba <cons_putc>:

// output a character to the console
static void
cons_putc(int c)
{
  8004200dba:	55                   	push   %rbp
  8004200dbb:	48 89 e5             	mov    %rsp,%rbp
  8004200dbe:	48 83 ec 10          	sub    $0x10,%rsp
  8004200dc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	serial_putc(c);
  8004200dc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200dc8:	89 c7                	mov    %eax,%edi
  8004200dca:	48 b8 6d 04 20 04 80 	movabs $0x800420046d,%rax
  8004200dd1:	00 00 00 
  8004200dd4:	ff d0                	callq  *%rax
	lpt_putc(c);
  8004200dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200dd9:	89 c7                	mov    %eax,%edi
  8004200ddb:	48 b8 a6 05 20 04 80 	movabs $0x80042005a6,%rax
  8004200de2:	00 00 00 
  8004200de5:	ff d0                	callq  *%rax
	cga_putc(c);
  8004200de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200dea:	89 c7                	mov    %eax,%edi
  8004200dec:	48 b8 45 07 20 04 80 	movabs $0x8004200745,%rax
  8004200df3:	00 00 00 
  8004200df6:	ff d0                	callq  *%rax
}
  8004200df8:	c9                   	leaveq 
  8004200df9:	c3                   	retq   

0000008004200dfa <cons_init>:

// initialize the console devices
void
cons_init(void)
{
  8004200dfa:	55                   	push   %rbp
  8004200dfb:	48 89 e5             	mov    %rsp,%rbp
	cga_init();
  8004200dfe:	48 b8 2b 06 20 04 80 	movabs $0x800420062b,%rax
  8004200e05:	00 00 00 
  8004200e08:	ff d0                	callq  *%rax
	kbd_init();
  8004200e0a:	48 b8 77 0c 20 04 80 	movabs $0x8004200c77,%rax
  8004200e11:	00 00 00 
  8004200e14:	ff d0                	callq  *%rax
	serial_init();
  8004200e16:	48 b8 d2 04 20 04 80 	movabs $0x80042004d2,%rax
  8004200e1d:	00 00 00 
  8004200e20:	ff d0                	callq  *%rax

	if (!serial_exists)
  8004200e22:	48 b8 a0 c6 21 04 80 	movabs $0x800421c6a0,%rax
  8004200e29:	00 00 00 
  8004200e2c:	0f b6 00             	movzbl (%rax),%eax
  8004200e2f:	83 f0 01             	xor    $0x1,%eax
  8004200e32:	84 c0                	test   %al,%al
  8004200e34:	74 1b                	je     8004200e51 <cons_init+0x57>
		cprintf("Serial port does not exist!\n");
  8004200e36:	48 bf d2 93 20 04 80 	movabs $0x80042093d2,%rdi
  8004200e3d:	00 00 00 
  8004200e40:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200e45:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004200e4c:	00 00 00 
  8004200e4f:	ff d2                	callq  *%rdx
}
  8004200e51:	5d                   	pop    %rbp
  8004200e52:	c3                   	retq   

0000008004200e53 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
  8004200e53:	55                   	push   %rbp
  8004200e54:	48 89 e5             	mov    %rsp,%rbp
  8004200e57:	48 83 ec 10          	sub    $0x10,%rsp
  8004200e5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	cons_putc(c);
  8004200e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200e61:	89 c7                	mov    %eax,%edi
  8004200e63:	48 b8 ba 0d 20 04 80 	movabs $0x8004200dba,%rax
  8004200e6a:	00 00 00 
  8004200e6d:	ff d0                	callq  *%rax
}
  8004200e6f:	c9                   	leaveq 
  8004200e70:	c3                   	retq   

0000008004200e71 <getchar>:

int
getchar(void)
{
  8004200e71:	55                   	push   %rbp
  8004200e72:	48 89 e5             	mov    %rsp,%rbp
  8004200e75:	48 83 ec 10          	sub    $0x10,%rsp
	int c;

	while ((c = cons_getc()) == 0)
  8004200e79:	48 b8 06 0d 20 04 80 	movabs $0x8004200d06,%rax
  8004200e80:	00 00 00 
  8004200e83:	ff d0                	callq  *%rax
  8004200e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004200e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004200e8c:	74 eb                	je     8004200e79 <getchar+0x8>
		/* do nothing */;
	return c;
  8004200e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004200e91:	c9                   	leaveq 
  8004200e92:	c3                   	retq   

0000008004200e93 <iscons>:

int
iscons(int fdnum)
{
  8004200e93:	55                   	push   %rbp
  8004200e94:	48 89 e5             	mov    %rsp,%rbp
  8004200e97:	48 83 ec 04          	sub    $0x4,%rsp
  8004200e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// used by readline
	return 1;
  8004200e9e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004200ea3:	c9                   	leaveq 
  8004200ea4:	c3                   	retq   

0000008004200ea5 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
  8004200ea5:	55                   	push   %rbp
  8004200ea6:	48 89 e5             	mov    %rsp,%rbp
  8004200ea9:	48 83 ec 30          	sub    $0x30,%rsp
  8004200ead:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8004200eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004200eb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  8004200eb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004200ebf:	eb 6c                	jmp    8004200f2d <mon_help+0x88>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  8004200ec1:	48 b9 80 c5 21 04 80 	movabs $0x800421c580,%rcx
  8004200ec8:	00 00 00 
  8004200ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200ece:	48 63 d0             	movslq %eax,%rdx
  8004200ed1:	48 89 d0             	mov    %rdx,%rax
  8004200ed4:	48 01 c0             	add    %rax,%rax
  8004200ed7:	48 01 d0             	add    %rdx,%rax
  8004200eda:	48 c1 e0 03          	shl    $0x3,%rax
  8004200ede:	48 01 c8             	add    %rcx,%rax
  8004200ee1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8004200ee5:	48 be 80 c5 21 04 80 	movabs $0x800421c580,%rsi
  8004200eec:	00 00 00 
  8004200eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200ef2:	48 63 d0             	movslq %eax,%rdx
  8004200ef5:	48 89 d0             	mov    %rdx,%rax
  8004200ef8:	48 01 c0             	add    %rax,%rax
  8004200efb:	48 01 d0             	add    %rdx,%rax
  8004200efe:	48 c1 e0 03          	shl    $0x3,%rax
  8004200f02:	48 01 f0             	add    %rsi,%rax
  8004200f05:	48 8b 00             	mov    (%rax),%rax
  8004200f08:	48 89 ca             	mov    %rcx,%rdx
  8004200f0b:	48 89 c6             	mov    %rax,%rsi
  8004200f0e:	48 bf 45 94 20 04 80 	movabs $0x8004209445,%rdi
  8004200f15:	00 00 00 
  8004200f18:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f1d:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004200f24:	00 00 00 
  8004200f27:	ff d1                	callq  *%rcx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  8004200f29:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004200f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200f30:	83 f8 01             	cmp    $0x1,%eax
  8004200f33:	76 8c                	jbe    8004200ec1 <mon_help+0x1c>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
  8004200f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004200f3a:	c9                   	leaveq 
  8004200f3b:	c3                   	retq   

0000008004200f3c <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  8004200f3c:	55                   	push   %rbp
  8004200f3d:	48 89 e5             	mov    %rsp,%rbp
  8004200f40:	48 83 ec 30          	sub    $0x30,%rsp
  8004200f44:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8004200f47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004200f4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
  8004200f4f:	48 bf 4e 94 20 04 80 	movabs $0x800420944e,%rdi
  8004200f56:	00 00 00 
  8004200f59:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f5e:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004200f65:	00 00 00 
  8004200f68:	ff d2                	callq  *%rdx
	cprintf("  _start                  %08x (phys)\n", _start);
  8004200f6a:	48 be 0c 00 20 00 00 	movabs $0x20000c,%rsi
  8004200f71:	00 00 00 
  8004200f74:	48 bf 68 94 20 04 80 	movabs $0x8004209468,%rdi
  8004200f7b:	00 00 00 
  8004200f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f83:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004200f8a:	00 00 00 
  8004200f8d:	ff d2                	callq  *%rdx
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
  8004200f8f:	48 ba 0c 00 20 00 00 	movabs $0x20000c,%rdx
  8004200f96:	00 00 00 
  8004200f99:	48 be 0c 00 20 04 80 	movabs $0x800420000c,%rsi
  8004200fa0:	00 00 00 
  8004200fa3:	48 bf 90 94 20 04 80 	movabs $0x8004209490,%rdi
  8004200faa:	00 00 00 
  8004200fad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200fb2:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004200fb9:	00 00 00 
  8004200fbc:	ff d1                	callq  *%rcx
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
  8004200fbe:	48 ba 2f 93 20 00 00 	movabs $0x20932f,%rdx
  8004200fc5:	00 00 00 
  8004200fc8:	48 be 2f 93 20 04 80 	movabs $0x800420932f,%rsi
  8004200fcf:	00 00 00 
  8004200fd2:	48 bf b8 94 20 04 80 	movabs $0x80042094b8,%rdi
  8004200fd9:	00 00 00 
  8004200fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200fe1:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004200fe8:	00 00 00 
  8004200feb:	ff d1                	callq  *%rcx
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
  8004200fed:	48 ba a0 c6 21 00 00 	movabs $0x21c6a0,%rdx
  8004200ff4:	00 00 00 
  8004200ff7:	48 be a0 c6 21 04 80 	movabs $0x800421c6a0,%rsi
  8004200ffe:	00 00 00 
  8004201001:	48 bf e0 94 20 04 80 	movabs $0x80042094e0,%rdi
  8004201008:	00 00 00 
  800420100b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201010:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004201017:	00 00 00 
  800420101a:	ff d1                	callq  *%rcx
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
  800420101c:	48 ba 40 dd 21 00 00 	movabs $0x21dd40,%rdx
  8004201023:	00 00 00 
  8004201026:	48 be 40 dd 21 04 80 	movabs $0x800421dd40,%rsi
  800420102d:	00 00 00 
  8004201030:	48 bf 08 95 20 04 80 	movabs $0x8004209508,%rdi
  8004201037:	00 00 00 
  800420103a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420103f:	48 b9 09 14 20 04 80 	movabs $0x8004201409,%rcx
  8004201046:	00 00 00 
  8004201049:	ff d1                	callq  *%rcx
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
  800420104b:	48 c7 45 f8 00 04 00 	movq   $0x400,-0x8(%rbp)
  8004201052:	00 
  8004201053:	48 b8 0c 00 20 04 80 	movabs $0x800420000c,%rax
  800420105a:	00 00 00 
  800420105d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004201061:	48 29 c2             	sub    %rax,%rdx
  8004201064:	48 b8 40 dd 21 04 80 	movabs $0x800421dd40,%rax
  800420106b:	00 00 00 
  800420106e:	48 83 e8 01          	sub    $0x1,%rax
  8004201072:	48 01 d0             	add    %rdx,%rax
  8004201075:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004201079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420107d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004201082:	48 f7 75 f8          	divq   -0x8(%rbp)
  8004201086:	48 89 d0             	mov    %rdx,%rax
  8004201089:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420108d:	48 29 c2             	sub    %rax,%rdx
  8004201090:	48 89 d0             	mov    %rdx,%rax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
  8004201093:	48 8d 90 ff 03 00 00 	lea    0x3ff(%rax),%rdx
  800420109a:	48 85 c0             	test   %rax,%rax
  800420109d:	48 0f 48 c2          	cmovs  %rdx,%rax
  80042010a1:	48 c1 f8 0a          	sar    $0xa,%rax
  80042010a5:	48 89 c6             	mov    %rax,%rsi
  80042010a8:	48 bf 30 95 20 04 80 	movabs $0x8004209530,%rdi
  80042010af:	00 00 00 
  80042010b2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042010b7:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042010be:	00 00 00 
  80042010c1:	ff d2                	callq  *%rdx
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
  80042010c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042010c8:	c9                   	leaveq 
  80042010c9:	c3                   	retq   

00000080042010ca <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
  80042010ca:	55                   	push   %rbp
  80042010cb:	48 89 e5             	mov    %rsp,%rbp
  80042010ce:	48 83 ec 18          	sub    $0x18,%rsp
  80042010d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042010d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80042010d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Your code here.
	return 0;
  80042010dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042010e2:	c9                   	leaveq 
  80042010e3:	c3                   	retq   

00000080042010e4 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
  80042010e4:	55                   	push   %rbp
  80042010e5:	48 89 e5             	mov    %rsp,%rbp
  80042010e8:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  80042010ef:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80042010f6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  80042010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	argv[argc] = 0;
  8004201104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201107:	48 98                	cltq   
  8004201109:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  8004201110:	ff 00 00 00 00 
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  8004201115:	eb 15                	jmp    800420112c <runcmd+0x48>
			*buf++ = 0;
  8004201117:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420111e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004201122:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  8004201129:	c6 00 00             	movb   $0x0,(%rax)
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  800420112c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004201133:	0f b6 00             	movzbl (%rax),%eax
  8004201136:	84 c0                	test   %al,%al
  8004201138:	74 2a                	je     8004201164 <runcmd+0x80>
  800420113a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004201141:	0f b6 00             	movzbl (%rax),%eax
  8004201144:	0f be c0             	movsbl %al,%eax
  8004201147:	89 c6                	mov    %eax,%esi
  8004201149:	48 bf 5a 95 20 04 80 	movabs $0x800420955a,%rdi
  8004201150:	00 00 00 
  8004201153:	48 b8 d3 2e 20 04 80 	movabs $0x8004202ed3,%rax
  800420115a:	00 00 00 
  800420115d:	ff d0                	callq  *%rax
  800420115f:	48 85 c0             	test   %rax,%rax
  8004201162:	75 b3                	jne    8004201117 <runcmd+0x33>
			*buf++ = 0;
		if (*buf == 0)
  8004201164:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420116b:	0f b6 00             	movzbl (%rax),%eax
  800420116e:	84 c0                	test   %al,%al
  8004201170:	75 21                	jne    8004201193 <runcmd+0xaf>
			break;
  8004201172:	90                   	nop
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  8004201173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201176:	48 98                	cltq   
  8004201178:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  800420117f:	ff 00 00 00 00 

	// Lookup and invoke the command
	if (argc == 0)
  8004201184:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004201188:	0f 85 a1 00 00 00    	jne    800420122f <runcmd+0x14b>
  800420118e:	e9 92 00 00 00       	jmpq   8004201225 <runcmd+0x141>
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  8004201193:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
  8004201197:	75 2a                	jne    80042011c3 <runcmd+0xdf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  8004201199:	be 10 00 00 00       	mov    $0x10,%esi
  800420119e:	48 bf 5f 95 20 04 80 	movabs $0x800420955f,%rdi
  80042011a5:	00 00 00 
  80042011a8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042011ad:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042011b4:	00 00 00 
  80042011b7:	ff d2                	callq  *%rdx
			return 0;
  80042011b9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042011be:	e9 30 01 00 00       	jmpq   80042012f3 <runcmd+0x20f>
		}
		argv[argc++] = buf;
  80042011c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042011c6:	8d 50 01             	lea    0x1(%rax),%edx
  80042011c9:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80042011cc:	48 98                	cltq   
  80042011ce:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
  80042011d5:	48 89 94 c5 70 ff ff 	mov    %rdx,-0x90(%rbp,%rax,8)
  80042011dc:	ff 
		while (*buf && !strchr(WHITESPACE, *buf))
  80042011dd:	eb 08                	jmp    80042011e7 <runcmd+0x103>
			buf++;
  80042011df:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  80042011e6:	01 
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  80042011e7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042011ee:	0f b6 00             	movzbl (%rax),%eax
  80042011f1:	84 c0                	test   %al,%al
  80042011f3:	74 2a                	je     800420121f <runcmd+0x13b>
  80042011f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042011fc:	0f b6 00             	movzbl (%rax),%eax
  80042011ff:	0f be c0             	movsbl %al,%eax
  8004201202:	89 c6                	mov    %eax,%esi
  8004201204:	48 bf 5a 95 20 04 80 	movabs $0x800420955a,%rdi
  800420120b:	00 00 00 
  800420120e:	48 b8 d3 2e 20 04 80 	movabs $0x8004202ed3,%rax
  8004201215:	00 00 00 
  8004201218:	ff d0                	callq  *%rax
  800420121a:	48 85 c0             	test   %rax,%rax
  800420121d:	74 c0                	je     80042011df <runcmd+0xfb>
			buf++;
	}
  800420121f:	90                   	nop
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  8004201220:	e9 07 ff ff ff       	jmpq   800420112c <runcmd+0x48>
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
  8004201225:	b8 00 00 00 00       	mov    $0x0,%eax
  800420122a:	e9 c4 00 00 00       	jmpq   80042012f3 <runcmd+0x20f>
	for (i = 0; i < NCOMMANDS; i++) {
  800420122f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004201236:	e9 82 00 00 00       	jmpq   80042012bd <runcmd+0x1d9>
		if (strcmp(argv[0], commands[i].name) == 0)
  800420123b:	48 b9 80 c5 21 04 80 	movabs $0x800421c580,%rcx
  8004201242:	00 00 00 
  8004201245:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004201248:	48 63 d0             	movslq %eax,%rdx
  800420124b:	48 89 d0             	mov    %rdx,%rax
  800420124e:	48 01 c0             	add    %rax,%rax
  8004201251:	48 01 d0             	add    %rdx,%rax
  8004201254:	48 c1 e0 03          	shl    $0x3,%rax
  8004201258:	48 01 c8             	add    %rcx,%rax
  800420125b:	48 8b 10             	mov    (%rax),%rdx
  800420125e:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004201265:	48 89 d6             	mov    %rdx,%rsi
  8004201268:	48 89 c7             	mov    %rax,%rdi
  800420126b:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004201272:	00 00 00 
  8004201275:	ff d0                	callq  *%rax
  8004201277:	85 c0                	test   %eax,%eax
  8004201279:	75 3e                	jne    80042012b9 <runcmd+0x1d5>
			return commands[i].func(argc, argv, tf);
  800420127b:	48 b9 80 c5 21 04 80 	movabs $0x800421c580,%rcx
  8004201282:	00 00 00 
  8004201285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004201288:	48 63 d0             	movslq %eax,%rdx
  800420128b:	48 89 d0             	mov    %rdx,%rax
  800420128e:	48 01 c0             	add    %rax,%rax
  8004201291:	48 01 d0             	add    %rdx,%rax
  8004201294:	48 c1 e0 03          	shl    $0x3,%rax
  8004201298:	48 01 c8             	add    %rcx,%rax
  800420129b:	48 83 c0 10          	add    $0x10,%rax
  800420129f:	48 8b 00             	mov    (%rax),%rax
  80042012a2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042012a9:	48 8d b5 70 ff ff ff 	lea    -0x90(%rbp),%rsi
  80042012b0:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80042012b3:	89 cf                	mov    %ecx,%edi
  80042012b5:	ff d0                	callq  *%rax
  80042012b7:	eb 3a                	jmp    80042012f3 <runcmd+0x20f>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  80042012b9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80042012bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042012c0:	83 f8 01             	cmp    $0x1,%eax
  80042012c3:	0f 86 72 ff ff ff    	jbe    800420123b <runcmd+0x157>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  80042012c9:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  80042012d0:	48 89 c6             	mov    %rax,%rsi
  80042012d3:	48 bf 7c 95 20 04 80 	movabs $0x800420957c,%rdi
  80042012da:	00 00 00 
  80042012dd:	b8 00 00 00 00       	mov    $0x0,%eax
  80042012e2:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  80042012e9:	00 00 00 
  80042012ec:	ff d2                	callq  *%rdx
	return 0;
  80042012ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042012f3:	c9                   	leaveq 
  80042012f4:	c3                   	retq   

00000080042012f5 <monitor>:

void
monitor(struct Trapframe *tf)
{
  80042012f5:	55                   	push   %rbp
  80042012f6:	48 89 e5             	mov    %rsp,%rbp
  80042012f9:	48 83 ec 20          	sub    $0x20,%rsp
  80042012fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
  8004201301:	48 bf 98 95 20 04 80 	movabs $0x8004209598,%rdi
  8004201308:	00 00 00 
  800420130b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201310:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004201317:	00 00 00 
  800420131a:	ff d2                	callq  *%rdx
	cprintf("Type 'help' for a list of commands.\n");
  800420131c:	48 bf c0 95 20 04 80 	movabs $0x80042095c0,%rdi
  8004201323:	00 00 00 
  8004201326:	b8 00 00 00 00       	mov    $0x0,%eax
  800420132b:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004201332:	00 00 00 
  8004201335:	ff d2                	callq  *%rdx


	while (1) {
		buf = readline("K> ");
  8004201337:	48 bf e5 95 20 04 80 	movabs $0x80042095e5,%rdi
  800420133e:	00 00 00 
  8004201341:	48 b8 f2 2a 20 04 80 	movabs $0x8004202af2,%rax
  8004201348:	00 00 00 
  800420134b:	ff d0                	callq  *%rax
  800420134d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (buf != NULL)
  8004201351:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004201356:	74 20                	je     8004201378 <monitor+0x83>
			if (runcmd(buf, tf) < 0)
  8004201358:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201360:	48 89 d6             	mov    %rdx,%rsi
  8004201363:	48 89 c7             	mov    %rax,%rdi
  8004201366:	48 b8 e4 10 20 04 80 	movabs $0x80042010e4,%rax
  800420136d:	00 00 00 
  8004201370:	ff d0                	callq  *%rax
  8004201372:	85 c0                	test   %eax,%eax
  8004201374:	79 02                	jns    8004201378 <monitor+0x83>
				break;
  8004201376:	eb 02                	jmp    800420137a <monitor+0x85>
	}
  8004201378:	eb bd                	jmp    8004201337 <monitor+0x42>
}
  800420137a:	c9                   	leaveq 
  800420137b:	c3                   	retq   

000000800420137c <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
  800420137c:	55                   	push   %rbp
  800420137d:	48 89 e5             	mov    %rsp,%rbp
  8004201380:	48 83 ec 10          	sub    $0x10,%rsp
  8004201384:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004201387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cputchar(ch);
  800420138b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420138e:	89 c7                	mov    %eax,%edi
  8004201390:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004201397:	00 00 00 
  800420139a:	ff d0                	callq  *%rax
	*cnt++;
  800420139c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042013a0:	48 83 c0 04          	add    $0x4,%rax
  80042013a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
}
  80042013a8:	c9                   	leaveq 
  80042013a9:	c3                   	retq   

00000080042013aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80042013aa:	55                   	push   %rbp
  80042013ab:	48 89 e5             	mov    %rsp,%rbp
  80042013ae:	48 83 ec 30          	sub    $0x30,%rsp
  80042013b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042013b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int cnt = 0;
  80042013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80042013c1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  80042013c5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042013c9:	48 8b 0a             	mov    (%rdx),%rcx
  80042013cc:	48 89 08             	mov    %rcx,(%rax)
  80042013cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042013d3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042013d7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042013db:	48 89 50 10          	mov    %rdx,0x10(%rax)
	vprintfmt((void*)putch, &cnt, fmt, aq);
  80042013df:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  80042013e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042013e7:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  80042013eb:	48 89 c6             	mov    %rax,%rsi
  80042013ee:	48 bf 7c 13 20 04 80 	movabs $0x800420137c,%rdi
  80042013f5:	00 00 00 
  80042013f8:	48 b8 5c 23 20 04 80 	movabs $0x800420235c,%rax
  80042013ff:	00 00 00 
  8004201402:	ff d0                	callq  *%rax
	va_end(aq);
	return cnt;
  8004201404:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8004201407:	c9                   	leaveq 
  8004201408:	c3                   	retq   

0000008004201409 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004201409:	55                   	push   %rbp
  800420140a:	48 89 e5             	mov    %rsp,%rbp
  800420140d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004201414:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800420141b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004201422:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004201429:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004201430:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004201437:	84 c0                	test   %al,%al
  8004201439:	74 20                	je     800420145b <cprintf+0x52>
  800420143b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800420143f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004201443:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004201447:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800420144b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800420144f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004201453:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004201457:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800420145b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_start(ap, fmt);
  8004201462:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004201469:	00 00 00 
  800420146c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004201473:	00 00 00 
  8004201476:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800420147a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004201481:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004201488:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800420148f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004201496:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800420149d:	48 8b 0a             	mov    (%rdx),%rcx
  80042014a0:	48 89 08             	mov    %rcx,(%rax)
  80042014a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042014a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042014ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042014af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80042014b3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80042014ba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80042014c1:	48 89 d6             	mov    %rdx,%rsi
  80042014c4:	48 89 c7             	mov    %rax,%rdi
  80042014c7:	48 b8 aa 13 20 04 80 	movabs $0x80042013aa,%rax
  80042014ce:	00 00 00 
  80042014d1:	ff d0                	callq  *%rax
  80042014d3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80042014d9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80042014df:	c9                   	leaveq 
  80042014e0:	c3                   	retq   

00000080042014e1 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int64_t
syscall(uint64_t syscallno, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80042014e1:	55                   	push   %rbp
  80042014e2:	48 89 e5             	mov    %rsp,%rbp
  80042014e5:	48 83 ec 30          	sub    $0x30,%rsp
  80042014e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042014ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80042014f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80042014f5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80042014f9:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
  80042014fd:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	panic("syscall not implemented");
  8004201501:	48 ba e9 95 20 04 80 	movabs $0x80042095e9,%rdx
  8004201508:	00 00 00 
  800420150b:	be 0e 00 00 00       	mov    $0xe,%esi
  8004201510:	48 bf 01 96 20 04 80 	movabs $0x8004209601,%rdi
  8004201517:	00 00 00 
  800420151a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420151f:	48 b9 98 01 20 04 80 	movabs $0x8004200198,%rcx
  8004201526:	00 00 00 
  8004201529:	ff d1                	callq  *%rcx

000000800420152b <list_func_die>:

#endif


int list_func_die(struct Ripdebuginfo *info, Dwarf_Die *die, uint64_t addr)
{
  800420152b:	55                   	push   %rbp
  800420152c:	48 89 e5             	mov    %rsp,%rbp
  800420152f:	48 81 ec f0 61 00 00 	sub    $0x61f0,%rsp
  8004201536:	48 89 bd 58 9e ff ff 	mov    %rdi,-0x61a8(%rbp)
  800420153d:	48 89 b5 50 9e ff ff 	mov    %rsi,-0x61b0(%rbp)
  8004201544:	48 89 95 48 9e ff ff 	mov    %rdx,-0x61b8(%rbp)
	_Dwarf_Line ln;
	Dwarf_Attribute *low;
	Dwarf_Attribute *high;
	Dwarf_CU *cu = die->cu_header;
  800420154b:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201552:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  8004201559:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Dwarf_Die *cudie = die->cu_die; 
  800420155d:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201564:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  800420156b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	Dwarf_Die ret, sib=*die; 
  800420156f:	48 8b 95 50 9e ff ff 	mov    -0x61b0(%rbp),%rdx
  8004201576:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  800420157d:	48 89 d1             	mov    %rdx,%rcx
  8004201580:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201585:	48 89 ce             	mov    %rcx,%rsi
  8004201588:	48 89 c7             	mov    %rax,%rdi
  800420158b:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004201592:	00 00 00 
  8004201595:	ff d0                	callq  *%rax
	Dwarf_Attribute *attr;
	uint64_t offset;
	uint64_t ret_val=8;
  8004201597:	48 c7 45 f8 08 00 00 	movq   $0x8,-0x8(%rbp)
  800420159e:	00 
	uint64_t ret_offset=0;
  800420159f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80042015a6:	00 

	if(die->die_tag != DW_TAG_subprogram)
  80042015a7:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042015ae:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042015b2:	48 83 f8 2e          	cmp    $0x2e,%rax
  80042015b6:	74 0a                	je     80042015c2 <list_func_die+0x97>
		return 0;
  80042015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042015bd:	e9 cd 06 00 00       	jmpq   8004201c8f <list_func_die+0x764>

	memset(&ln, 0, sizeof(_Dwarf_Line));
  80042015c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042015c9:	ba 38 00 00 00       	mov    $0x38,%edx
  80042015ce:	be 00 00 00 00       	mov    $0x0,%esi
  80042015d3:	48 89 c7             	mov    %rax,%rdi
  80042015d6:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  80042015dd:	00 00 00 
  80042015e0:	ff d0                	callq  *%rax

	low  = _dwarf_attr_find(die, DW_AT_low_pc);
  80042015e2:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042015e9:	be 11 00 00 00       	mov    $0x11,%esi
  80042015ee:	48 89 c7             	mov    %rax,%rdi
  80042015f1:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  80042015f8:	00 00 00 
  80042015fb:	ff d0                	callq  *%rax
  80042015fd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	high = _dwarf_attr_find(die, DW_AT_high_pc);
  8004201601:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201608:	be 12 00 00 00       	mov    $0x12,%esi
  800420160d:	48 89 c7             	mov    %rax,%rdi
  8004201610:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  8004201617:	00 00 00 
  800420161a:	ff d0                	callq  *%rax
  800420161c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

	if((low && (low->u[0].u64 < addr)) && (high && (high->u[0].u64 > addr)))
  8004201620:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004201625:	0f 84 5f 06 00 00    	je     8004201c8a <list_func_die+0x75f>
  800420162b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420162f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201633:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  800420163a:	0f 83 4a 06 00 00    	jae    8004201c8a <list_func_die+0x75f>
  8004201640:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004201645:	0f 84 3f 06 00 00    	je     8004201c8a <list_func_die+0x75f>
  800420164b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420164f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201653:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  800420165a:	0f 86 2a 06 00 00    	jbe    8004201c8a <list_func_die+0x75f>
	{
		info->rip_file = die->cu_die->die_name;
  8004201660:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201667:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  800420166e:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  8004201675:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  800420167c:	48 89 10             	mov    %rdx,(%rax)

		info->rip_fn_name = die->die_name;
  800420167f:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201686:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  800420168d:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201694:	48 89 50 10          	mov    %rdx,0x10(%rax)
		info->rip_fn_namelen = strlen(die->die_name);
  8004201698:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  800420169f:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  80042016a6:	48 89 c7             	mov    %rax,%rdi
  80042016a9:	48 b8 41 2c 20 04 80 	movabs $0x8004202c41,%rax
  80042016b0:	00 00 00 
  80042016b3:	ff d0                	callq  *%rax
  80042016b5:	48 8b 95 58 9e ff ff 	mov    -0x61a8(%rbp),%rdx
  80042016bc:	89 42 18             	mov    %eax,0x18(%rdx)

		info->rip_fn_addr = (uintptr_t)low->u[0].u64;
  80042016bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042016c3:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042016c7:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042016ce:	48 89 50 20          	mov    %rdx,0x20(%rax)

		assert(die->cu_die);	
  80042016d2:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042016d9:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  80042016e0:	48 85 c0             	test   %rax,%rax
  80042016e3:	75 35                	jne    800420171a <list_func_die+0x1ef>
  80042016e5:	48 b9 40 99 20 04 80 	movabs $0x8004209940,%rcx
  80042016ec:	00 00 00 
  80042016ef:	48 ba 4c 99 20 04 80 	movabs $0x800420994c,%rdx
  80042016f6:	00 00 00 
  80042016f9:	be 88 00 00 00       	mov    $0x88,%esi
  80042016fe:	48 bf 61 99 20 04 80 	movabs $0x8004209961,%rdi
  8004201705:	00 00 00 
  8004201708:	b8 00 00 00 00       	mov    $0x0,%eax
  800420170d:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004201714:	00 00 00 
  8004201717:	41 ff d0             	callq  *%r8
		dwarf_srclines(die->cu_die, &ln, addr, NULL); 
  800420171a:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201721:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  8004201728:	48 8b 95 48 9e ff ff 	mov    -0x61b8(%rbp),%rdx
  800420172f:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8004201736:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420173b:	48 89 c7             	mov    %rax,%rdi
  800420173e:	48 b8 a2 84 20 04 80 	movabs $0x80042084a2,%rax
  8004201745:	00 00 00 
  8004201748:	ff d0                	callq  *%rax

		info->rip_line = ln.ln_lineno;
  800420174a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004201751:	89 c2                	mov    %eax,%edx
  8004201753:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  800420175a:	89 50 08             	mov    %edx,0x8(%rax)
		info->rip_fn_narg = 0;
  800420175d:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201764:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)

		Dwarf_Attribute* attr;

		if(dwarf_child(dbg, cu, &sib, &ret) != DW_DLE_NO_ENTRY)
  800420176b:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201772:	00 00 00 
  8004201775:	48 8b 00             	mov    (%rax),%rax
  8004201778:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  800420177f:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004201786:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800420178a:	48 89 c7             	mov    %rax,%rdi
  800420178d:	48 b8 52 51 20 04 80 	movabs $0x8004205152,%rax
  8004201794:	00 00 00 
  8004201797:	ff d0                	callq  *%rax
  8004201799:	83 f8 04             	cmp    $0x4,%eax
  800420179c:	0f 84 e1 04 00 00    	je     8004201c83 <list_func_die+0x758>
		{
			if(ret.die_tag != DW_TAG_formal_parameter)
  80042017a2:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  80042017a9:	48 83 f8 05          	cmp    $0x5,%rax
  80042017ad:	74 05                	je     80042017b4 <list_func_die+0x289>
				goto last;
  80042017af:	e9 cf 04 00 00       	jmpq   8004201c83 <list_func_die+0x758>

			attr = _dwarf_attr_find(&ret, DW_AT_type);
  80042017b4:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  80042017bb:	be 49 00 00 00       	mov    $0x49,%esi
  80042017c0:	48 89 c7             	mov    %rax,%rdi
  80042017c3:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  80042017ca:	00 00 00 
  80042017cd:	ff d0                	callq  *%rax
  80042017cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	
		try_again:
			if(attr != NULL)
  80042017d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042017d8:	0f 84 d7 00 00 00    	je     80042018b5 <list_func_die+0x38a>
			{
				offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  80042017de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042017e2:	48 8b 50 30          	mov    0x30(%rax),%rdx
  80042017e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042017ea:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042017ee:	48 01 d0             	add    %rdx,%rax
  80042017f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
				dwarf_offdie(dbg, offset, &sib, *cu);
  80042017f5:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042017fc:	00 00 00 
  80042017ff:	48 8b 08             	mov    (%rax),%rcx
  8004201802:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004201809:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800420180d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201811:	48 8b 38             	mov    (%rax),%rdi
  8004201814:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004201818:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800420181c:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004201821:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004201825:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420182a:	48 8b 78 18          	mov    0x18(%rax),%rdi
  800420182e:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004201833:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8004201837:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  800420183c:	48 8b 78 28          	mov    0x28(%rax),%rdi
  8004201840:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004201845:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004201849:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  800420184e:	48 89 cf             	mov    %rcx,%rdi
  8004201851:	48 b8 78 4d 20 04 80 	movabs $0x8004204d78,%rax
  8004201858:	00 00 00 
  800420185b:	ff d0                	callq  *%rax
				attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  800420185d:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201864:	be 0b 00 00 00       	mov    $0xb,%esi
  8004201869:	48 89 c7             	mov    %rax,%rdi
  800420186c:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  8004201873:	00 00 00 
  8004201876:	ff d0                	callq  *%rax
  8004201878:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		
				if(attr != NULL)
  800420187c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201881:	74 0e                	je     8004201891 <list_func_die+0x366>
				{
					ret_val = attr->u[0].u64;
  8004201883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201887:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420188b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420188f:	eb 24                	jmp    80042018b5 <list_func_die+0x38a>
				}
				else
				{
					attr = _dwarf_attr_find(&sib, DW_AT_type);
  8004201891:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201898:	be 49 00 00 00       	mov    $0x49,%esi
  800420189d:	48 89 c7             	mov    %rax,%rdi
  80042018a0:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  80042018a7:	00 00 00 
  80042018aa:	ff d0                	callq  *%rax
  80042018ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					goto try_again;
  80042018b0:	e9 1e ff ff ff       	jmpq   80042017d3 <list_func_die+0x2a8>
				}
			}

			ret_offset = 0;
  80042018b5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80042018bc:	00 
			attr = _dwarf_attr_find(&ret, DW_AT_location);
  80042018bd:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  80042018c4:	be 02 00 00 00       	mov    $0x2,%esi
  80042018c9:	48 89 c7             	mov    %rax,%rdi
  80042018cc:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  80042018d3:	00 00 00 
  80042018d6:	ff d0                	callq  *%rax
  80042018d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if (attr != NULL)
  80042018dc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042018e1:	0f 84 a2 00 00 00    	je     8004201989 <list_func_die+0x45e>
			{
				Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  80042018e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042018eb:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042018ef:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
				Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  80042018f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042018f7:	48 8b 40 40          	mov    0x40(%rax),%rax
  80042018fb:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
				Dwarf_Small atom;
				Dwarf_Unsigned op1, op2;

				switch(attr->at_form) {
  80042018ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201903:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004201907:	48 83 f8 03          	cmp    $0x3,%rax
  800420190b:	72 7c                	jb     8004201989 <list_func_die+0x45e>
  800420190d:	48 83 f8 04          	cmp    $0x4,%rax
  8004201911:	76 06                	jbe    8004201919 <list_func_die+0x3ee>
  8004201913:	48 83 f8 0a          	cmp    $0xa,%rax
  8004201917:	75 70                	jne    8004201989 <list_func_die+0x45e>
					case DW_FORM_block1:
					case DW_FORM_block2:
					case DW_FORM_block4:
						offset = 0;
  8004201919:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004201920:	00 
						atom = *(loc_ptr++);
  8004201921:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201925:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004201929:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
  800420192d:	0f b6 00             	movzbl (%rax),%eax
  8004201930:	88 45 af             	mov    %al,-0x51(%rbp)
						offset++;
  8004201933:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
						if (atom == DW_OP_fbreg) {
  8004201938:	80 7d af 91          	cmpb   $0x91,-0x51(%rbp)
  800420193c:	75 4a                	jne    8004201988 <list_func_die+0x45d>
							uint8_t *p = loc_ptr;
  800420193e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201942:	48 89 85 68 9e ff ff 	mov    %rax,-0x6198(%rbp)
							ret_offset = _dwarf_decode_sleb128(&p);
  8004201949:	48 8d 85 68 9e ff ff 	lea    -0x6198(%rbp),%rax
  8004201950:	48 89 c7             	mov    %rax,%rdi
  8004201953:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  800420195a:	00 00 00 
  800420195d:	ff d0                	callq  *%rax
  800420195f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
							offset += p - loc_ptr;
  8004201963:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  800420196a:	48 89 c2             	mov    %rax,%rdx
  800420196d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201971:	48 29 c2             	sub    %rax,%rdx
  8004201974:	48 89 d0             	mov    %rdx,%rax
  8004201977:	48 01 45 c0          	add    %rax,-0x40(%rbp)
							loc_ptr = p;
  800420197b:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  8004201982:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
						}
						break;
  8004201986:	eb 00                	jmp    8004201988 <list_func_die+0x45d>
  8004201988:	90                   	nop
				}
			}

			info->size_fn_arg[info->rip_fn_narg] = ret_val;
  8004201989:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201990:	8b 48 28             	mov    0x28(%rax),%ecx
  8004201993:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201997:	89 c2                	mov    %eax,%edx
  8004201999:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042019a0:	48 63 c9             	movslq %ecx,%rcx
  80042019a3:	48 83 c1 08          	add    $0x8,%rcx
  80042019a7:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
  80042019ab:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042019b2:	8b 50 28             	mov    0x28(%rax),%edx
  80042019b5:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042019bc:	48 63 d2             	movslq %edx,%rdx
  80042019bf:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  80042019c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042019c7:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
			info->rip_fn_narg++;
  80042019cc:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042019d3:	8b 40 28             	mov    0x28(%rax),%eax
  80042019d6:	8d 50 01             	lea    0x1(%rax),%edx
  80042019d9:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042019e0:	89 50 28             	mov    %edx,0x28(%rax)
			sib = ret; 
  80042019e3:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  80042019ea:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  80042019f1:	ba 70 30 00 00       	mov    $0x3070,%edx
  80042019f6:	48 89 ce             	mov    %rcx,%rsi
  80042019f9:	48 89 c7             	mov    %rax,%rdi
  80042019fc:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004201a03:	00 00 00 
  8004201a06:	ff d0                	callq  *%rax

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004201a08:	e9 40 02 00 00       	jmpq   8004201c4d <list_func_die+0x722>
			{
				if(ret.die_tag != DW_TAG_formal_parameter)
  8004201a0d:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  8004201a14:	48 83 f8 05          	cmp    $0x5,%rax
  8004201a18:	74 05                	je     8004201a1f <list_func_die+0x4f4>
					break;
  8004201a1a:	e9 64 02 00 00       	jmpq   8004201c83 <list_func_die+0x758>

				attr = _dwarf_attr_find(&ret, DW_AT_type);
  8004201a1f:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201a26:	be 49 00 00 00       	mov    $0x49,%esi
  8004201a2b:	48 89 c7             	mov    %rax,%rdi
  8004201a2e:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  8004201a35:	00 00 00 
  8004201a38:	ff d0                	callq  *%rax
  8004201a3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    
				if(attr != NULL)
  8004201a3e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201a43:	0f 84 b1 00 00 00    	je     8004201afa <list_func_die+0x5cf>
				{	   
					offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  8004201a49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201a4d:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004201a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201a55:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201a59:	48 01 d0             	add    %rdx,%rax
  8004201a5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
					dwarf_offdie(dbg, offset, &sib, *cu);
  8004201a60:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201a67:	00 00 00 
  8004201a6a:	48 8b 08             	mov    (%rax),%rcx
  8004201a6d:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004201a74:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004201a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201a7c:	48 8b 38             	mov    (%rax),%rdi
  8004201a7f:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004201a83:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8004201a87:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004201a8c:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004201a90:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  8004201a95:	48 8b 78 18          	mov    0x18(%rax),%rdi
  8004201a99:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004201a9e:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8004201aa2:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004201aa7:	48 8b 78 28          	mov    0x28(%rax),%rdi
  8004201aab:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004201ab0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004201ab4:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8004201ab9:	48 89 cf             	mov    %rcx,%rdi
  8004201abc:	48 b8 78 4d 20 04 80 	movabs $0x8004204d78,%rax
  8004201ac3:	00 00 00 
  8004201ac6:	ff d0                	callq  *%rax
					attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  8004201ac8:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201acf:	be 0b 00 00 00       	mov    $0xb,%esi
  8004201ad4:	48 89 c7             	mov    %rax,%rdi
  8004201ad7:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  8004201ade:	00 00 00 
  8004201ae1:	ff d0                	callq  *%rax
  8004201ae3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        
					if(attr != NULL)
  8004201ae7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201aec:	74 0c                	je     8004201afa <list_func_die+0x5cf>
					{
						ret_val = attr->u[0].u64;
  8004201aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201af2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201af6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
					}
				}
	
				ret_offset = 0;
  8004201afa:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004201b01:	00 
				attr = _dwarf_attr_find(&ret, DW_AT_location);
  8004201b02:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201b09:	be 02 00 00 00       	mov    $0x2,%esi
  8004201b0e:	48 89 c7             	mov    %rax,%rdi
  8004201b11:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  8004201b18:	00 00 00 
  8004201b1b:	ff d0                	callq  *%rax
  8004201b1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				if (attr != NULL)
  8004201b21:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201b26:	0f 84 a2 00 00 00    	je     8004201bce <list_func_die+0x6a3>
				{
					Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  8004201b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201b30:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004201b34:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
					Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  8004201b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201b3c:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004201b40:	48 89 45 98          	mov    %rax,-0x68(%rbp)
					Dwarf_Small atom;
					Dwarf_Unsigned op1, op2;

					switch(attr->at_form) {
  8004201b44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201b48:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004201b4c:	48 83 f8 03          	cmp    $0x3,%rax
  8004201b50:	72 7c                	jb     8004201bce <list_func_die+0x6a3>
  8004201b52:	48 83 f8 04          	cmp    $0x4,%rax
  8004201b56:	76 06                	jbe    8004201b5e <list_func_die+0x633>
  8004201b58:	48 83 f8 0a          	cmp    $0xa,%rax
  8004201b5c:	75 70                	jne    8004201bce <list_func_die+0x6a3>
						case DW_FORM_block1:
						case DW_FORM_block2:
						case DW_FORM_block4:
							offset = 0;
  8004201b5e:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004201b65:	00 
							atom = *(loc_ptr++);
  8004201b66:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201b6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004201b6e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004201b72:	0f b6 00             	movzbl (%rax),%eax
  8004201b75:	88 45 97             	mov    %al,-0x69(%rbp)
							offset++;
  8004201b78:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
							if (atom == DW_OP_fbreg) {
  8004201b7d:	80 7d 97 91          	cmpb   $0x91,-0x69(%rbp)
  8004201b81:	75 4a                	jne    8004201bcd <list_func_die+0x6a2>
								uint8_t *p = loc_ptr;
  8004201b83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201b87:	48 89 85 60 9e ff ff 	mov    %rax,-0x61a0(%rbp)
								ret_offset = _dwarf_decode_sleb128(&p);
  8004201b8e:	48 8d 85 60 9e ff ff 	lea    -0x61a0(%rbp),%rax
  8004201b95:	48 89 c7             	mov    %rax,%rdi
  8004201b98:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  8004201b9f:	00 00 00 
  8004201ba2:	ff d0                	callq  *%rax
  8004201ba4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
								offset += p - loc_ptr;
  8004201ba8:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004201baf:	48 89 c2             	mov    %rax,%rdx
  8004201bb2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201bb6:	48 29 c2             	sub    %rax,%rdx
  8004201bb9:	48 89 d0             	mov    %rdx,%rax
  8004201bbc:	48 01 45 c0          	add    %rax,-0x40(%rbp)
								loc_ptr = p;
  8004201bc0:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004201bc7:	48 89 45 98          	mov    %rax,-0x68(%rbp)
							}
							break;
  8004201bcb:	eb 00                	jmp    8004201bcd <list_func_die+0x6a2>
  8004201bcd:	90                   	nop
					}
				}

				info->size_fn_arg[info->rip_fn_narg]=ret_val;// _get_arg_size(ret);
  8004201bce:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201bd5:	8b 48 28             	mov    0x28(%rax),%ecx
  8004201bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201bdc:	89 c2                	mov    %eax,%edx
  8004201bde:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201be5:	48 63 c9             	movslq %ecx,%rcx
  8004201be8:	48 83 c1 08          	add    $0x8,%rcx
  8004201bec:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
				info->offset_fn_arg[info->rip_fn_narg]=ret_offset;
  8004201bf0:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201bf7:	8b 50 28             	mov    0x28(%rax),%edx
  8004201bfa:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201c01:	48 63 d2             	movslq %edx,%rdx
  8004201c04:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  8004201c08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201c0c:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
				info->rip_fn_narg++;
  8004201c11:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201c18:	8b 40 28             	mov    0x28(%rax),%eax
  8004201c1b:	8d 50 01             	lea    0x1(%rax),%edx
  8004201c1e:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201c25:	89 50 28             	mov    %edx,0x28(%rax)
				sib = ret; 
  8004201c28:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201c2f:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  8004201c36:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201c3b:	48 89 ce             	mov    %rcx,%rsi
  8004201c3e:	48 89 c7             	mov    %rax,%rdi
  8004201c41:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004201c48:	00 00 00 
  8004201c4b:	ff d0                	callq  *%rax
			info->size_fn_arg[info->rip_fn_narg] = ret_val;
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
			info->rip_fn_narg++;
			sib = ret; 

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004201c4d:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201c54:	00 00 00 
  8004201c57:	48 8b 00             	mov    (%rax),%rax
  8004201c5a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004201c5e:	48 8d 95 e0 ce ff ff 	lea    -0x3120(%rbp),%rdx
  8004201c65:	48 8d b5 70 9e ff ff 	lea    -0x6190(%rbp),%rsi
  8004201c6c:	48 89 c7             	mov    %rax,%rdi
  8004201c6f:	48 b8 0e 4f 20 04 80 	movabs $0x8004204f0e,%rax
  8004201c76:	00 00 00 
  8004201c79:	ff d0                	callq  *%rax
  8004201c7b:	85 c0                	test   %eax,%eax
  8004201c7d:	0f 84 8a fd ff ff    	je     8004201a0d <list_func_die+0x4e2>
				info->rip_fn_narg++;
				sib = ret; 
			}
		}
	last:	
		return 1;
  8004201c83:	b8 01 00 00 00       	mov    $0x1,%eax
  8004201c88:	eb 05                	jmp    8004201c8f <list_func_die+0x764>
	}

	return 0;
  8004201c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004201c8f:	c9                   	leaveq 
  8004201c90:	c3                   	retq   

0000008004201c91 <debuginfo_rip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info)
{
  8004201c91:	55                   	push   %rbp
  8004201c92:	48 89 e5             	mov    %rsp,%rbp
  8004201c95:	53                   	push   %rbx
  8004201c96:	48 81 ec c8 91 00 00 	sub    $0x91c8,%rsp
  8004201c9d:	48 89 bd 38 6e ff ff 	mov    %rdi,-0x91c8(%rbp)
  8004201ca4:	48 89 b5 30 6e ff ff 	mov    %rsi,-0x91d0(%rbp)
	static struct Env* lastenv = NULL;
	void* elf;    
	Dwarf_Section *sect;
	Dwarf_CU cu;
	Dwarf_Die die, cudie, die2;
	Dwarf_Regtable *rt = NULL;
  8004201cab:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004201cb2:	00 
	//Set up initial pc
	uint64_t pc  = (uintptr_t)addr;
  8004201cb3:	48 8b 85 38 6e ff ff 	mov    -0x91c8(%rbp),%rax
  8004201cba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

    
	// Initialize *info
	info->rip_file = "<unknown>";
  8004201cbe:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201cc5:	48 bb 6f 99 20 04 80 	movabs $0x800420996f,%rbx
  8004201ccc:	00 00 00 
  8004201ccf:	48 89 18             	mov    %rbx,(%rax)
	info->rip_line = 0;
  8004201cd2:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201cd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	info->rip_fn_name = "<unknown>";
  8004201ce0:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201ce7:	48 bb 6f 99 20 04 80 	movabs $0x800420996f,%rbx
  8004201cee:	00 00 00 
  8004201cf1:	48 89 58 10          	mov    %rbx,0x10(%rax)
	info->rip_fn_namelen = 9;
  8004201cf5:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201cfc:	c7 40 18 09 00 00 00 	movl   $0x9,0x18(%rax)
	info->rip_fn_addr = addr;
  8004201d03:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201d0a:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004201d11:	48 89 50 20          	mov    %rdx,0x20(%rax)
	info->rip_fn_narg = 0;
  8004201d15:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201d1c:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)
    
	// Find the relevant set of stabs
	if (addr >= ULIM) {
  8004201d23:	48 b8 ff ff bf 03 80 	movabs $0x8003bfffff,%rax
  8004201d2a:	00 00 00 
  8004201d2d:	48 39 85 38 6e ff ff 	cmp    %rax,-0x91c8(%rbp)
  8004201d34:	0f 86 95 00 00 00    	jbe    8004201dcf <debuginfo_rip+0x13e>
		elf = (void *)0x10000 + KERNBASE;
  8004201d3a:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  8004201d41:	00 00 00 
  8004201d44:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
	}
	_dwarf_init(dbg, elf);
  8004201d48:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201d4f:	00 00 00 
  8004201d52:	48 8b 00             	mov    (%rax),%rax
  8004201d55:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004201d59:	48 89 d6             	mov    %rdx,%rsi
  8004201d5c:	48 89 c7             	mov    %rax,%rdi
  8004201d5f:	48 b8 86 3d 20 04 80 	movabs $0x8004203d86,%rax
  8004201d66:	00 00 00 
  8004201d69:	ff d0                	callq  *%rax

	sect = _dwarf_find_section(".debug_info");	
  8004201d6b:	48 bf 86 99 20 04 80 	movabs $0x8004209986,%rdi
  8004201d72:	00 00 00 
  8004201d75:	48 b8 1d 86 20 04 80 	movabs $0x800420861d,%rax
  8004201d7c:	00 00 00 
  8004201d7f:	ff d0                	callq  *%rax
  8004201d81:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
  8004201d85:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201d8c:	00 00 00 
  8004201d8f:	48 8b 00             	mov    (%rax),%rax
  8004201d92:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201d96:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004201d9a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	dbg->dbg_info_size = sect->ds_size;
  8004201d9e:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201da5:	00 00 00 
  8004201da8:	48 8b 00             	mov    (%rax),%rax
  8004201dab:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201daf:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8004201db3:	48 89 50 10          	mov    %rdx,0x10(%rax)

	assert(dbg->dbg_info_size);
  8004201db7:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201dbe:	00 00 00 
  8004201dc1:	48 8b 00             	mov    (%rax),%rax
  8004201dc4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004201dc8:	48 85 c0             	test   %rax,%rax
  8004201dcb:	75 61                	jne    8004201e2e <debuginfo_rip+0x19d>
  8004201dcd:	eb 2a                	jmp    8004201df9 <debuginfo_rip+0x168>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		elf = (void *)0x10000 + KERNBASE;
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
  8004201dcf:	48 ba 79 99 20 04 80 	movabs $0x8004209979,%rdx
  8004201dd6:	00 00 00 
  8004201dd9:	be 23 01 00 00       	mov    $0x123,%esi
  8004201dde:	48 bf 61 99 20 04 80 	movabs $0x8004209961,%rdi
  8004201de5:	00 00 00 
  8004201de8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201ded:	48 b9 98 01 20 04 80 	movabs $0x8004200198,%rcx
  8004201df4:	00 00 00 
  8004201df7:	ff d1                	callq  *%rcx

	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
  8004201df9:	48 b9 92 99 20 04 80 	movabs $0x8004209992,%rcx
  8004201e00:	00 00 00 
  8004201e03:	48 ba 4c 99 20 04 80 	movabs $0x800420994c,%rdx
  8004201e0a:	00 00 00 
  8004201e0d:	be 2b 01 00 00       	mov    $0x12b,%esi
  8004201e12:	48 bf 61 99 20 04 80 	movabs $0x8004209961,%rdi
  8004201e19:	00 00 00 
  8004201e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201e21:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004201e28:	00 00 00 
  8004201e2b:	41 ff d0             	callq  *%r8
	while(_get_next_cu(dbg, &cu) == 0)
  8004201e2e:	e9 6f 01 00 00       	jmpq   8004201fa2 <debuginfo_rip+0x311>
	{
		if(dwarf_siblingof(dbg, NULL, &cudie, &cu) == DW_DLE_NO_ENTRY)
  8004201e33:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201e3a:	00 00 00 
  8004201e3d:	48 8b 00             	mov    (%rax),%rax
  8004201e40:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004201e44:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004201e4b:	be 00 00 00 00       	mov    $0x0,%esi
  8004201e50:	48 89 c7             	mov    %rax,%rdi
  8004201e53:	48 b8 0e 4f 20 04 80 	movabs $0x8004204f0e,%rax
  8004201e5a:	00 00 00 
  8004201e5d:	ff d0                	callq  *%rax
  8004201e5f:	83 f8 04             	cmp    $0x4,%eax
  8004201e62:	75 05                	jne    8004201e69 <debuginfo_rip+0x1d8>
			continue;
  8004201e64:	e9 39 01 00 00       	jmpq   8004201fa2 <debuginfo_rip+0x311>

		cudie.cu_header = &cu;
  8004201e69:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004201e6d:	48 89 85 10 a2 ff ff 	mov    %rax,-0x5df0(%rbp)
		cudie.cu_die = NULL;
  8004201e74:	48 c7 85 18 a2 ff ff 	movq   $0x0,-0x5de8(%rbp)
  8004201e7b:	00 00 00 00 

		if(dwarf_child(dbg, &cu, &cudie, &die) == DW_DLE_NO_ENTRY)
  8004201e7f:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201e86:	00 00 00 
  8004201e89:	48 8b 00             	mov    (%rax),%rax
  8004201e8c:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  8004201e93:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004201e9a:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  8004201e9e:	48 89 c7             	mov    %rax,%rdi
  8004201ea1:	48 b8 52 51 20 04 80 	movabs $0x8004205152,%rax
  8004201ea8:	00 00 00 
  8004201eab:	ff d0                	callq  *%rax
  8004201ead:	83 f8 04             	cmp    $0x4,%eax
  8004201eb0:	75 05                	jne    8004201eb7 <debuginfo_rip+0x226>
			continue;
  8004201eb2:	e9 eb 00 00 00       	jmpq   8004201fa2 <debuginfo_rip+0x311>

		die.cu_header = &cu;
  8004201eb7:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004201ebb:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
		die.cu_die = &cudie;
  8004201ec2:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004201ec9:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		while(1)
		{
			if(list_func_die(info, &die, addr))
  8004201ed0:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004201ed7:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  8004201ede:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201ee5:	48 89 ce             	mov    %rcx,%rsi
  8004201ee8:	48 89 c7             	mov    %rax,%rdi
  8004201eeb:	48 b8 2b 15 20 04 80 	movabs $0x800420152b,%rax
  8004201ef2:	00 00 00 
  8004201ef5:	ff d0                	callq  *%rax
  8004201ef7:	85 c0                	test   %eax,%eax
  8004201ef9:	74 30                	je     8004201f2b <debuginfo_rip+0x29a>
				goto find_done;
  8004201efb:	90                   	nop

	return -1;

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
  8004201efc:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201f03:	00 00 00 
  8004201f06:	48 8b 00             	mov    (%rax),%rax
  8004201f09:	be 00 00 00 00       	mov    $0x0,%esi
  8004201f0e:	48 89 c7             	mov    %rax,%rdi
  8004201f11:	48 b8 2a 78 20 04 80 	movabs $0x800420782a,%rax
  8004201f18:	00 00 00 
  8004201f1b:	ff d0                	callq  *%rax
  8004201f1d:	83 f8 01             	cmp    $0x1,%eax
  8004201f20:	0f 85 bb 00 00 00    	jne    8004201fe1 <debuginfo_rip+0x350>
  8004201f26:	e9 ac 00 00 00       	jmpq   8004201fd7 <debuginfo_rip+0x346>
		die.cu_die = &cudie;
		while(1)
		{
			if(list_func_die(info, &die, addr))
				goto find_done;
			if(dwarf_siblingof(dbg, &die, &die2, &cu) < 0)
  8004201f2b:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201f32:	00 00 00 
  8004201f35:	48 8b 00             	mov    (%rax),%rax
  8004201f38:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004201f3c:	48 8d 95 40 6e ff ff 	lea    -0x91c0(%rbp),%rdx
  8004201f43:	48 8d b5 20 cf ff ff 	lea    -0x30e0(%rbp),%rsi
  8004201f4a:	48 89 c7             	mov    %rax,%rdi
  8004201f4d:	48 b8 0e 4f 20 04 80 	movabs $0x8004204f0e,%rax
  8004201f54:	00 00 00 
  8004201f57:	ff d0                	callq  *%rax
  8004201f59:	85 c0                	test   %eax,%eax
  8004201f5b:	79 02                	jns    8004201f5f <debuginfo_rip+0x2ce>
				break; 
  8004201f5d:	eb 43                	jmp    8004201fa2 <debuginfo_rip+0x311>
			die = die2;
  8004201f5f:	48 8d 85 20 cf ff ff 	lea    -0x30e0(%rbp),%rax
  8004201f66:	48 8d 8d 40 6e ff ff 	lea    -0x91c0(%rbp),%rcx
  8004201f6d:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201f72:	48 89 ce             	mov    %rcx,%rsi
  8004201f75:	48 89 c7             	mov    %rax,%rdi
  8004201f78:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004201f7f:	00 00 00 
  8004201f82:	ff d0                	callq  *%rax
			die.cu_header = &cu;
  8004201f84:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004201f88:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
			die.cu_die = &cudie;
  8004201f8f:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004201f96:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		}
  8004201f9d:	e9 2e ff ff ff       	jmpq   8004201ed0 <debuginfo_rip+0x23f>
	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
	while(_get_next_cu(dbg, &cu) == 0)
  8004201fa2:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201fa9:	00 00 00 
  8004201fac:	48 8b 00             	mov    (%rax),%rax
  8004201faf:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  8004201fb3:	48 89 d6             	mov    %rdx,%rsi
  8004201fb6:	48 89 c7             	mov    %rax,%rdi
  8004201fb9:	48 b8 68 3e 20 04 80 	movabs $0x8004203e68,%rax
  8004201fc0:	00 00 00 
  8004201fc3:	ff d0                	callq  *%rax
  8004201fc5:	85 c0                	test   %eax,%eax
  8004201fc7:	0f 84 66 fe ff ff    	je     8004201e33 <debuginfo_rip+0x1a2>
			die.cu_header = &cu;
			die.cu_die = &cudie;
		}
	}

	return -1;
  8004201fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004201fd2:	e9 a0 00 00 00       	jmpq   8004202077 <debuginfo_rip+0x3e6>

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
		return -1;
  8004201fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004201fdc:	e9 96 00 00 00       	jmpq   8004202077 <debuginfo_rip+0x3e6>

	if (dwarf_get_fde_at_pc(dbg, addr, fde, cie, NULL) == DW_DLV_OK) {
  8004201fe1:	48 b8 b8 c5 21 04 80 	movabs $0x800421c5b8,%rax
  8004201fe8:	00 00 00 
  8004201feb:	48 8b 08             	mov    (%rax),%rcx
  8004201fee:	48 b8 b0 c5 21 04 80 	movabs $0x800421c5b0,%rax
  8004201ff5:	00 00 00 
  8004201ff8:	48 8b 10             	mov    (%rax),%rdx
  8004201ffb:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004202002:	00 00 00 
  8004202005:	48 8b 00             	mov    (%rax),%rax
  8004202008:	48 8b b5 38 6e ff ff 	mov    -0x91c8(%rbp),%rsi
  800420200f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004202015:	48 89 c7             	mov    %rax,%rdi
  8004202018:	48 b8 93 53 20 04 80 	movabs $0x8004205393,%rax
  800420201f:	00 00 00 
  8004202022:	ff d0                	callq  *%rax
  8004202024:	85 c0                	test   %eax,%eax
  8004202026:	75 4a                	jne    8004202072 <debuginfo_rip+0x3e1>
		dwarf_get_fde_info_for_all_regs(dbg, fde, addr,
  8004202028:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  800420202f:	48 8d 88 a8 00 00 00 	lea    0xa8(%rax),%rcx
  8004202036:	48 b8 b0 c5 21 04 80 	movabs $0x800421c5b0,%rax
  800420203d:	00 00 00 
  8004202040:	48 8b 30             	mov    (%rax),%rsi
  8004202043:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420204a:	00 00 00 
  800420204d:	48 8b 00             	mov    (%rax),%rax
  8004202050:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004202057:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420205d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004202063:	48 89 c7             	mov    %rax,%rdi
  8004202066:	48 b8 9f 66 20 04 80 	movabs $0x800420669f,%rax
  800420206d:	00 00 00 
  8004202070:	ff d0                	callq  *%rax
					break;
			}
		}
#endif
	}
	return 0;
  8004202072:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202077:	48 81 c4 c8 91 00 00 	add    $0x91c8,%rsp
  800420207e:	5b                   	pop    %rbx
  800420207f:	5d                   	pop    %rbp
  8004202080:	c3                   	retq   

0000008004202081 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004202081:	55                   	push   %rbp
  8004202082:	48 89 e5             	mov    %rsp,%rbp
  8004202085:	53                   	push   %rbx
  8004202086:	48 83 ec 38          	sub    $0x38,%rsp
  800420208a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420208e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202092:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004202096:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004202099:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800420209d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042020a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80042020a4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80042020a8:	77 3b                	ja     80042020e5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80042020aa:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80042020ad:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80042020b1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042020b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042020b8:	ba 00 00 00 00       	mov    $0x0,%edx
  80042020bd:	48 f7 f3             	div    %rbx
  80042020c0:	48 89 c2             	mov    %rax,%rdx
  80042020c3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80042020c6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80042020c9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80042020cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042020d1:	41 89 f9             	mov    %edi,%r9d
  80042020d4:	48 89 c7             	mov    %rax,%rdi
  80042020d7:	48 b8 81 20 20 04 80 	movabs $0x8004202081,%rax
  80042020de:	00 00 00 
  80042020e1:	ff d0                	callq  *%rax
  80042020e3:	eb 1e                	jmp    8004202103 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042020e5:	eb 12                	jmp    80042020f9 <printnum+0x78>
			putch(padc, putdat);
  80042020e7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80042020eb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80042020ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042020f2:	48 89 ce             	mov    %rcx,%rsi
  80042020f5:	89 d7                	mov    %edx,%edi
  80042020f7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042020f9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80042020fd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004202101:	7f e4                	jg     80042020e7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004202103:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004202106:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420210a:	ba 00 00 00 00       	mov    $0x0,%edx
  800420210f:	48 f7 f1             	div    %rcx
  8004202112:	48 89 d0             	mov    %rdx,%rax
  8004202115:	48 ba f0 9a 20 04 80 	movabs $0x8004209af0,%rdx
  800420211c:	00 00 00 
  800420211f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004202123:	0f be d0             	movsbl %al,%edx
  8004202126:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800420212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420212e:	48 89 ce             	mov    %rcx,%rsi
  8004202131:	89 d7                	mov    %edx,%edi
  8004202133:	ff d0                	callq  *%rax
}
  8004202135:	48 83 c4 38          	add    $0x38,%rsp
  8004202139:	5b                   	pop    %rbx
  800420213a:	5d                   	pop    %rbp
  800420213b:	c3                   	retq   

000000800420213c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800420213c:	55                   	push   %rbp
  800420213d:	48 89 e5             	mov    %rsp,%rbp
  8004202140:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004202144:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202148:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800420214b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800420214f:	7e 52                	jle    80042021a3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004202151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202155:	8b 00                	mov    (%rax),%eax
  8004202157:	83 f8 30             	cmp    $0x30,%eax
  800420215a:	73 24                	jae    8004202180 <getuint+0x44>
  800420215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202160:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202168:	8b 00                	mov    (%rax),%eax
  800420216a:	89 c0                	mov    %eax,%eax
  800420216c:	48 01 d0             	add    %rdx,%rax
  800420216f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202173:	8b 12                	mov    (%rdx),%edx
  8004202175:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004202178:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420217c:	89 0a                	mov    %ecx,(%rdx)
  800420217e:	eb 17                	jmp    8004202197 <getuint+0x5b>
  8004202180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202184:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004202188:	48 89 d0             	mov    %rdx,%rax
  800420218b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800420218f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202193:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004202197:	48 8b 00             	mov    (%rax),%rax
  800420219a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420219e:	e9 a3 00 00 00       	jmpq   8004202246 <getuint+0x10a>
	else if (lflag)
  80042021a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042021a7:	74 4f                	je     80042021f8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80042021a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042021ad:	8b 00                	mov    (%rax),%eax
  80042021af:	83 f8 30             	cmp    $0x30,%eax
  80042021b2:	73 24                	jae    80042021d8 <getuint+0x9c>
  80042021b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042021b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042021bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042021c0:	8b 00                	mov    (%rax),%eax
  80042021c2:	89 c0                	mov    %eax,%eax
  80042021c4:	48 01 d0             	add    %rdx,%rax
  80042021c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042021cb:	8b 12                	mov    (%rdx),%edx
  80042021cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042021d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042021d4:	89 0a                	mov    %ecx,(%rdx)
  80042021d6:	eb 17                	jmp    80042021ef <getuint+0xb3>
  80042021d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042021dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042021e0:	48 89 d0             	mov    %rdx,%rax
  80042021e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042021e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042021eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042021ef:	48 8b 00             	mov    (%rax),%rax
  80042021f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042021f6:	eb 4e                	jmp    8004202246 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80042021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042021fc:	8b 00                	mov    (%rax),%eax
  80042021fe:	83 f8 30             	cmp    $0x30,%eax
  8004202201:	73 24                	jae    8004202227 <getuint+0xeb>
  8004202203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202207:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420220b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420220f:	8b 00                	mov    (%rax),%eax
  8004202211:	89 c0                	mov    %eax,%eax
  8004202213:	48 01 d0             	add    %rdx,%rax
  8004202216:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420221a:	8b 12                	mov    (%rdx),%edx
  800420221c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420221f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202223:	89 0a                	mov    %ecx,(%rdx)
  8004202225:	eb 17                	jmp    800420223e <getuint+0x102>
  8004202227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420222b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420222f:	48 89 d0             	mov    %rdx,%rax
  8004202232:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004202236:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420223a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420223e:	8b 00                	mov    (%rax),%eax
  8004202240:	89 c0                	mov    %eax,%eax
  8004202242:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004202246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420224a:	c9                   	leaveq 
  800420224b:	c3                   	retq   

000000800420224c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800420224c:	55                   	push   %rbp
  800420224d:	48 89 e5             	mov    %rsp,%rbp
  8004202250:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004202254:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202258:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800420225b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800420225f:	7e 52                	jle    80042022b3 <getint+0x67>
		x=va_arg(*ap, long long);
  8004202261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202265:	8b 00                	mov    (%rax),%eax
  8004202267:	83 f8 30             	cmp    $0x30,%eax
  800420226a:	73 24                	jae    8004202290 <getint+0x44>
  800420226c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202270:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202278:	8b 00                	mov    (%rax),%eax
  800420227a:	89 c0                	mov    %eax,%eax
  800420227c:	48 01 d0             	add    %rdx,%rax
  800420227f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202283:	8b 12                	mov    (%rdx),%edx
  8004202285:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004202288:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420228c:	89 0a                	mov    %ecx,(%rdx)
  800420228e:	eb 17                	jmp    80042022a7 <getint+0x5b>
  8004202290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202294:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004202298:	48 89 d0             	mov    %rdx,%rax
  800420229b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800420229f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042022a7:	48 8b 00             	mov    (%rax),%rax
  80042022aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042022ae:	e9 a3 00 00 00       	jmpq   8004202356 <getint+0x10a>
	else if (lflag)
  80042022b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042022b7:	74 4f                	je     8004202308 <getint+0xbc>
		x=va_arg(*ap, long);
  80042022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042022bd:	8b 00                	mov    (%rax),%eax
  80042022bf:	83 f8 30             	cmp    $0x30,%eax
  80042022c2:	73 24                	jae    80042022e8 <getint+0x9c>
  80042022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042022c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042022cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042022d0:	8b 00                	mov    (%rax),%eax
  80042022d2:	89 c0                	mov    %eax,%eax
  80042022d4:	48 01 d0             	add    %rdx,%rax
  80042022d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022db:	8b 12                	mov    (%rdx),%edx
  80042022dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042022e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022e4:	89 0a                	mov    %ecx,(%rdx)
  80042022e6:	eb 17                	jmp    80042022ff <getint+0xb3>
  80042022e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042022ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042022f0:	48 89 d0             	mov    %rdx,%rax
  80042022f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042022f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042022ff:	48 8b 00             	mov    (%rax),%rax
  8004202302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004202306:	eb 4e                	jmp    8004202356 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8004202308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420230c:	8b 00                	mov    (%rax),%eax
  800420230e:	83 f8 30             	cmp    $0x30,%eax
  8004202311:	73 24                	jae    8004202337 <getint+0xeb>
  8004202313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202317:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420231b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420231f:	8b 00                	mov    (%rax),%eax
  8004202321:	89 c0                	mov    %eax,%eax
  8004202323:	48 01 d0             	add    %rdx,%rax
  8004202326:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420232a:	8b 12                	mov    (%rdx),%edx
  800420232c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420232f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202333:	89 0a                	mov    %ecx,(%rdx)
  8004202335:	eb 17                	jmp    800420234e <getint+0x102>
  8004202337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420233b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420233f:	48 89 d0             	mov    %rdx,%rax
  8004202342:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004202346:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420234a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420234e:	8b 00                	mov    (%rax),%eax
  8004202350:	48 98                	cltq   
  8004202352:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004202356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420235a:	c9                   	leaveq 
  800420235b:	c3                   	retq   

000000800420235c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800420235c:	55                   	push   %rbp
  800420235d:	48 89 e5             	mov    %rsp,%rbp
  8004202360:	41 54                	push   %r12
  8004202362:	53                   	push   %rbx
  8004202363:	48 83 ec 60          	sub    $0x60,%rsp
  8004202367:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800420236b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800420236f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004202373:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8004202377:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800420237b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800420237f:	48 8b 0a             	mov    (%rdx),%rcx
  8004202382:	48 89 08             	mov    %rcx,(%rax)
  8004202385:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004202389:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800420238d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004202391:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004202395:	eb 17                	jmp    80042023ae <vprintfmt+0x52>
			if (ch == '\0')
  8004202397:	85 db                	test   %ebx,%ebx
  8004202399:	0f 84 cc 04 00 00    	je     800420286b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800420239f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042023a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042023a7:	48 89 d6             	mov    %rdx,%rsi
  80042023aa:	89 df                	mov    %ebx,%edi
  80042023ac:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042023ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042023b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042023b6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80042023ba:	0f b6 00             	movzbl (%rax),%eax
  80042023bd:	0f b6 d8             	movzbl %al,%ebx
  80042023c0:	83 fb 25             	cmp    $0x25,%ebx
  80042023c3:	75 d2                	jne    8004202397 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80042023c5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80042023c9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80042023d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80042023d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80042023de:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042023e5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042023e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042023ed:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80042023f1:	0f b6 00             	movzbl (%rax),%eax
  80042023f4:	0f b6 d8             	movzbl %al,%ebx
  80042023f7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80042023fa:	83 f8 55             	cmp    $0x55,%eax
  80042023fd:	0f 87 34 04 00 00    	ja     8004202837 <vprintfmt+0x4db>
  8004202403:	89 c0                	mov    %eax,%eax
  8004202405:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420240c:	00 
  800420240d:	48 b8 18 9b 20 04 80 	movabs $0x8004209b18,%rax
  8004202414:	00 00 00 
  8004202417:	48 01 d0             	add    %rdx,%rax
  800420241a:	48 8b 00             	mov    (%rax),%rax
  800420241d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800420241f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8004202423:	eb c0                	jmp    80042023e5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004202425:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8004202429:	eb ba                	jmp    80042023e5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800420242b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8004202432:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8004202435:	89 d0                	mov    %edx,%eax
  8004202437:	c1 e0 02             	shl    $0x2,%eax
  800420243a:	01 d0                	add    %edx,%eax
  800420243c:	01 c0                	add    %eax,%eax
  800420243e:	01 d8                	add    %ebx,%eax
  8004202440:	83 e8 30             	sub    $0x30,%eax
  8004202443:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8004202446:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420244a:	0f b6 00             	movzbl (%rax),%eax
  800420244d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004202450:	83 fb 2f             	cmp    $0x2f,%ebx
  8004202453:	7e 0c                	jle    8004202461 <vprintfmt+0x105>
  8004202455:	83 fb 39             	cmp    $0x39,%ebx
  8004202458:	7f 07                	jg     8004202461 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800420245a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800420245f:	eb d1                	jmp    8004202432 <vprintfmt+0xd6>
			goto process_precision;
  8004202461:	eb 58                	jmp    80042024bb <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8004202463:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202466:	83 f8 30             	cmp    $0x30,%eax
  8004202469:	73 17                	jae    8004202482 <vprintfmt+0x126>
  800420246b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420246f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202472:	89 c0                	mov    %eax,%eax
  8004202474:	48 01 d0             	add    %rdx,%rax
  8004202477:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800420247a:	83 c2 08             	add    $0x8,%edx
  800420247d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8004202480:	eb 0f                	jmp    8004202491 <vprintfmt+0x135>
  8004202482:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202486:	48 89 d0             	mov    %rdx,%rax
  8004202489:	48 83 c2 08          	add    $0x8,%rdx
  800420248d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004202491:	8b 00                	mov    (%rax),%eax
  8004202493:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8004202496:	eb 23                	jmp    80042024bb <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8004202498:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420249c:	79 0c                	jns    80042024aa <vprintfmt+0x14e>
				width = 0;
  800420249e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80042024a5:	e9 3b ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>
  80042024aa:	e9 36 ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80042024af:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80042024b6:	e9 2a ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80042024bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042024bf:	79 12                	jns    80042024d3 <vprintfmt+0x177>
				width = precision, precision = -1;
  80042024c1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80042024c4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80042024c7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80042024ce:	e9 12 ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>
  80042024d3:	e9 0d ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80042024d8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80042024dc:	e9 04 ff ff ff       	jmpq   80042023e5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80042024e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042024e4:	83 f8 30             	cmp    $0x30,%eax
  80042024e7:	73 17                	jae    8004202500 <vprintfmt+0x1a4>
  80042024e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042024ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042024f0:	89 c0                	mov    %eax,%eax
  80042024f2:	48 01 d0             	add    %rdx,%rax
  80042024f5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042024f8:	83 c2 08             	add    $0x8,%edx
  80042024fb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80042024fe:	eb 0f                	jmp    800420250f <vprintfmt+0x1b3>
  8004202500:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202504:	48 89 d0             	mov    %rdx,%rax
  8004202507:	48 83 c2 08          	add    $0x8,%rdx
  800420250b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800420250f:	8b 10                	mov    (%rax),%edx
  8004202511:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004202515:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202519:	48 89 ce             	mov    %rcx,%rsi
  800420251c:	89 d7                	mov    %edx,%edi
  800420251e:	ff d0                	callq  *%rax
			break;
  8004202520:	e9 40 03 00 00       	jmpq   8004202865 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8004202525:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202528:	83 f8 30             	cmp    $0x30,%eax
  800420252b:	73 17                	jae    8004202544 <vprintfmt+0x1e8>
  800420252d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004202531:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202534:	89 c0                	mov    %eax,%eax
  8004202536:	48 01 d0             	add    %rdx,%rax
  8004202539:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800420253c:	83 c2 08             	add    $0x8,%edx
  800420253f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8004202542:	eb 0f                	jmp    8004202553 <vprintfmt+0x1f7>
  8004202544:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202548:	48 89 d0             	mov    %rdx,%rax
  800420254b:	48 83 c2 08          	add    $0x8,%rdx
  800420254f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004202553:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8004202555:	85 db                	test   %ebx,%ebx
  8004202557:	79 02                	jns    800420255b <vprintfmt+0x1ff>
				err = -err;
  8004202559:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800420255b:	83 fb 15             	cmp    $0x15,%ebx
  800420255e:	7f 16                	jg     8004202576 <vprintfmt+0x21a>
  8004202560:	48 b8 40 9a 20 04 80 	movabs $0x8004209a40,%rax
  8004202567:	00 00 00 
  800420256a:	48 63 d3             	movslq %ebx,%rdx
  800420256d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8004202571:	4d 85 e4             	test   %r12,%r12
  8004202574:	75 2e                	jne    80042025a4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8004202576:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800420257a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420257e:	89 d9                	mov    %ebx,%ecx
  8004202580:	48 ba 01 9b 20 04 80 	movabs $0x8004209b01,%rdx
  8004202587:	00 00 00 
  800420258a:	48 89 c7             	mov    %rax,%rdi
  800420258d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202592:	49 b8 74 28 20 04 80 	movabs $0x8004202874,%r8
  8004202599:	00 00 00 
  800420259c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800420259f:	e9 c1 02 00 00       	jmpq   8004202865 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80042025a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80042025a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042025ac:	4c 89 e1             	mov    %r12,%rcx
  80042025af:	48 ba 0a 9b 20 04 80 	movabs $0x8004209b0a,%rdx
  80042025b6:	00 00 00 
  80042025b9:	48 89 c7             	mov    %rax,%rdi
  80042025bc:	b8 00 00 00 00       	mov    $0x0,%eax
  80042025c1:	49 b8 74 28 20 04 80 	movabs $0x8004202874,%r8
  80042025c8:	00 00 00 
  80042025cb:	41 ff d0             	callq  *%r8
			break;
  80042025ce:	e9 92 02 00 00       	jmpq   8004202865 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80042025d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042025d6:	83 f8 30             	cmp    $0x30,%eax
  80042025d9:	73 17                	jae    80042025f2 <vprintfmt+0x296>
  80042025db:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042025df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042025e2:	89 c0                	mov    %eax,%eax
  80042025e4:	48 01 d0             	add    %rdx,%rax
  80042025e7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042025ea:	83 c2 08             	add    $0x8,%edx
  80042025ed:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80042025f0:	eb 0f                	jmp    8004202601 <vprintfmt+0x2a5>
  80042025f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042025f6:	48 89 d0             	mov    %rdx,%rax
  80042025f9:	48 83 c2 08          	add    $0x8,%rdx
  80042025fd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004202601:	4c 8b 20             	mov    (%rax),%r12
  8004202604:	4d 85 e4             	test   %r12,%r12
  8004202607:	75 0a                	jne    8004202613 <vprintfmt+0x2b7>
				p = "(null)";
  8004202609:	49 bc 0d 9b 20 04 80 	movabs $0x8004209b0d,%r12
  8004202610:	00 00 00 
			if (width > 0 && padc != '-')
  8004202613:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004202617:	7e 3f                	jle    8004202658 <vprintfmt+0x2fc>
  8004202619:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800420261d:	74 39                	je     8004202658 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800420261f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8004202622:	48 98                	cltq   
  8004202624:	48 89 c6             	mov    %rax,%rsi
  8004202627:	4c 89 e7             	mov    %r12,%rdi
  800420262a:	48 b8 6f 2c 20 04 80 	movabs $0x8004202c6f,%rax
  8004202631:	00 00 00 
  8004202634:	ff d0                	callq  *%rax
  8004202636:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8004202639:	eb 17                	jmp    8004202652 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800420263b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800420263f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004202643:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202647:	48 89 ce             	mov    %rcx,%rsi
  800420264a:	89 d7                	mov    %edx,%edi
  800420264c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800420264e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8004202652:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004202656:	7f e3                	jg     800420263b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004202658:	eb 37                	jmp    8004202691 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800420265a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800420265e:	74 1e                	je     800420267e <vprintfmt+0x322>
  8004202660:	83 fb 1f             	cmp    $0x1f,%ebx
  8004202663:	7e 05                	jle    800420266a <vprintfmt+0x30e>
  8004202665:	83 fb 7e             	cmp    $0x7e,%ebx
  8004202668:	7e 14                	jle    800420267e <vprintfmt+0x322>
					putch('?', putdat);
  800420266a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420266e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202672:	48 89 d6             	mov    %rdx,%rsi
  8004202675:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800420267a:	ff d0                	callq  *%rax
  800420267c:	eb 0f                	jmp    800420268d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800420267e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202682:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202686:	48 89 d6             	mov    %rdx,%rsi
  8004202689:	89 df                	mov    %ebx,%edi
  800420268b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800420268d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8004202691:	4c 89 e0             	mov    %r12,%rax
  8004202694:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8004202698:	0f b6 00             	movzbl (%rax),%eax
  800420269b:	0f be d8             	movsbl %al,%ebx
  800420269e:	85 db                	test   %ebx,%ebx
  80042026a0:	74 10                	je     80042026b2 <vprintfmt+0x356>
  80042026a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80042026a6:	78 b2                	js     800420265a <vprintfmt+0x2fe>
  80042026a8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80042026ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80042026b0:	79 a8                	jns    800420265a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80042026b2:	eb 16                	jmp    80042026ca <vprintfmt+0x36e>
				putch(' ', putdat);
  80042026b4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042026b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042026bc:	48 89 d6             	mov    %rdx,%rsi
  80042026bf:	bf 20 00 00 00       	mov    $0x20,%edi
  80042026c4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80042026c6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80042026ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042026ce:	7f e4                	jg     80042026b4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80042026d0:	e9 90 01 00 00       	jmpq   8004202865 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80042026d5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80042026d9:	be 03 00 00 00       	mov    $0x3,%esi
  80042026de:	48 89 c7             	mov    %rax,%rdi
  80042026e1:	48 b8 4c 22 20 04 80 	movabs $0x800420224c,%rax
  80042026e8:	00 00 00 
  80042026eb:	ff d0                	callq  *%rax
  80042026ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80042026f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042026f5:	48 85 c0             	test   %rax,%rax
  80042026f8:	79 1d                	jns    8004202717 <vprintfmt+0x3bb>
				putch('-', putdat);
  80042026fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042026fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202702:	48 89 d6             	mov    %rdx,%rsi
  8004202705:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800420270a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800420270c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202710:	48 f7 d8             	neg    %rax
  8004202713:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8004202717:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800420271e:	e9 d5 00 00 00       	jmpq   80042027f8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8004202723:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004202727:	be 03 00 00 00       	mov    $0x3,%esi
  800420272c:	48 89 c7             	mov    %rax,%rdi
  800420272f:	48 b8 3c 21 20 04 80 	movabs $0x800420213c,%rax
  8004202736:	00 00 00 
  8004202739:	ff d0                	callq  *%rax
  800420273b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800420273f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8004202746:	e9 ad 00 00 00       	jmpq   80042027f8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800420274b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800420274f:	be 03 00 00 00       	mov    $0x3,%esi
  8004202754:	48 89 c7             	mov    %rax,%rdi
  8004202757:	48 b8 3c 21 20 04 80 	movabs $0x800420213c,%rax
  800420275e:	00 00 00 
  8004202761:	ff d0                	callq  *%rax
  8004202763:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8004202767:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800420276e:	e9 85 00 00 00       	jmpq   80042027f8 <vprintfmt+0x49c>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  8004202773:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202777:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420277b:	48 89 d6             	mov    %rdx,%rsi
  800420277e:	bf 30 00 00 00       	mov    $0x30,%edi
  8004202783:	ff d0                	callq  *%rax
			putch('x', putdat);
  8004202785:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202789:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420278d:	48 89 d6             	mov    %rdx,%rsi
  8004202790:	bf 78 00 00 00       	mov    $0x78,%edi
  8004202795:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8004202797:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420279a:	83 f8 30             	cmp    $0x30,%eax
  800420279d:	73 17                	jae    80042027b6 <vprintfmt+0x45a>
  800420279f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042027a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042027a6:	89 c0                	mov    %eax,%eax
  80042027a8:	48 01 d0             	add    %rdx,%rax
  80042027ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042027ae:	83 c2 08             	add    $0x8,%edx
  80042027b1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80042027b4:	eb 0f                	jmp    80042027c5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80042027b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042027ba:	48 89 d0             	mov    %rdx,%rax
  80042027bd:	48 83 c2 08          	add    $0x8,%rdx
  80042027c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80042027c5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80042027c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80042027cc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80042027d3:	eb 23                	jmp    80042027f8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80042027d5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80042027d9:	be 03 00 00 00       	mov    $0x3,%esi
  80042027de:	48 89 c7             	mov    %rax,%rdi
  80042027e1:	48 b8 3c 21 20 04 80 	movabs $0x800420213c,%rax
  80042027e8:	00 00 00 
  80042027eb:	ff d0                	callq  *%rax
  80042027ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80042027f1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80042027f8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80042027fd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004202800:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8004202803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202807:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800420280b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420280f:	45 89 c1             	mov    %r8d,%r9d
  8004202812:	41 89 f8             	mov    %edi,%r8d
  8004202815:	48 89 c7             	mov    %rax,%rdi
  8004202818:	48 b8 81 20 20 04 80 	movabs $0x8004202081,%rax
  800420281f:	00 00 00 
  8004202822:	ff d0                	callq  *%rax
			break;
  8004202824:	eb 3f                	jmp    8004202865 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8004202826:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420282a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420282e:	48 89 d6             	mov    %rdx,%rsi
  8004202831:	89 df                	mov    %ebx,%edi
  8004202833:	ff d0                	callq  *%rax
			break;
  8004202835:	eb 2e                	jmp    8004202865 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8004202837:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420283b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420283f:	48 89 d6             	mov    %rdx,%rsi
  8004202842:	bf 25 00 00 00       	mov    $0x25,%edi
  8004202847:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8004202849:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800420284e:	eb 05                	jmp    8004202855 <vprintfmt+0x4f9>
  8004202850:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8004202855:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004202859:	48 83 e8 01          	sub    $0x1,%rax
  800420285d:	0f b6 00             	movzbl (%rax),%eax
  8004202860:	3c 25                	cmp    $0x25,%al
  8004202862:	75 ec                	jne    8004202850 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8004202864:	90                   	nop
		}
	}
  8004202865:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004202866:	e9 43 fb ff ff       	jmpq   80042023ae <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800420286b:	48 83 c4 60          	add    $0x60,%rsp
  800420286f:	5b                   	pop    %rbx
  8004202870:	41 5c                	pop    %r12
  8004202872:	5d                   	pop    %rbp
  8004202873:	c3                   	retq   

0000008004202874 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004202874:	55                   	push   %rbp
  8004202875:	48 89 e5             	mov    %rsp,%rbp
  8004202878:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800420287f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8004202886:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800420288d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004202894:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800420289b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80042028a2:	84 c0                	test   %al,%al
  80042028a4:	74 20                	je     80042028c6 <printfmt+0x52>
  80042028a6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80042028aa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80042028ae:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80042028b2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042028b6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80042028ba:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80042028be:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80042028c2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80042028c6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80042028cd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80042028d4:	00 00 00 
  80042028d7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80042028de:	00 00 00 
  80042028e1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80042028e5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80042028ec:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042028f3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80042028fa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8004202901:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004202908:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800420290f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004202916:	48 89 c7             	mov    %rax,%rdi
  8004202919:	48 b8 5c 23 20 04 80 	movabs $0x800420235c,%rax
  8004202920:	00 00 00 
  8004202923:	ff d0                	callq  *%rax
	va_end(ap);
}
  8004202925:	c9                   	leaveq 
  8004202926:	c3                   	retq   

0000008004202927 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004202927:	55                   	push   %rbp
  8004202928:	48 89 e5             	mov    %rsp,%rbp
  800420292b:	48 83 ec 10          	sub    $0x10,%rsp
  800420292f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004202932:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8004202936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420293a:	8b 40 10             	mov    0x10(%rax),%eax
  800420293d:	8d 50 01             	lea    0x1(%rax),%edx
  8004202940:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202944:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8004202947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420294b:	48 8b 10             	mov    (%rax),%rdx
  800420294e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202952:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004202956:	48 39 c2             	cmp    %rax,%rdx
  8004202959:	73 17                	jae    8004202972 <sprintputch+0x4b>
		*b->buf++ = ch;
  800420295b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420295f:	48 8b 00             	mov    (%rax),%rax
  8004202962:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8004202966:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420296a:	48 89 0a             	mov    %rcx,(%rdx)
  800420296d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004202970:	88 10                	mov    %dl,(%rax)
}
  8004202972:	c9                   	leaveq 
  8004202973:	c3                   	retq   

0000008004202974 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8004202974:	55                   	push   %rbp
  8004202975:	48 89 e5             	mov    %rsp,%rbp
  8004202978:	48 83 ec 50          	sub    $0x50,%rsp
  800420297c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004202980:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8004202983:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004202987:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800420298b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800420298f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004202993:	48 8b 0a             	mov    (%rdx),%rcx
  8004202996:	48 89 08             	mov    %rcx,(%rax)
  8004202999:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420299d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042029a1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042029a5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80042029a9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042029ad:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80042029b1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80042029b4:	48 98                	cltq   
  80042029b6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80042029ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042029be:	48 01 d0             	add    %rdx,%rax
  80042029c1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80042029c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80042029cc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042029d1:	74 06                	je     80042029d9 <vsnprintf+0x65>
  80042029d3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80042029d7:	7f 07                	jg     80042029e0 <vsnprintf+0x6c>
		return -E_INVAL;
  80042029d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042029de:	eb 2f                	jmp    8004202a0f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80042029e0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80042029e4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80042029e8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80042029ec:	48 89 c6             	mov    %rax,%rsi
  80042029ef:	48 bf 27 29 20 04 80 	movabs $0x8004202927,%rdi
  80042029f6:	00 00 00 
  80042029f9:	48 b8 5c 23 20 04 80 	movabs $0x800420235c,%rax
  8004202a00:	00 00 00 
  8004202a03:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8004202a05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202a09:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8004202a0c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8004202a0f:	c9                   	leaveq 
  8004202a10:	c3                   	retq   

0000008004202a11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8004202a11:	55                   	push   %rbp
  8004202a12:	48 89 e5             	mov    %rsp,%rbp
  8004202a15:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004202a1c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004202a23:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8004202a29:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004202a30:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004202a37:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004202a3e:	84 c0                	test   %al,%al
  8004202a40:	74 20                	je     8004202a62 <snprintf+0x51>
  8004202a42:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004202a46:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004202a4a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004202a4e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004202a52:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004202a56:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004202a5a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004202a5e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004202a62:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8004202a69:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8004202a70:	00 00 00 
  8004202a73:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004202a7a:	00 00 00 
  8004202a7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004202a81:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004202a88:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004202a8f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004202a96:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004202a9d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004202aa4:	48 8b 0a             	mov    (%rdx),%rcx
  8004202aa7:	48 89 08             	mov    %rcx,(%rax)
  8004202aaa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004202aae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004202ab2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004202ab6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8004202aba:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8004202ac1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8004202ac8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8004202ace:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004202ad5:	48 89 c7             	mov    %rax,%rdi
  8004202ad8:	48 b8 74 29 20 04 80 	movabs $0x8004202974,%rax
  8004202adf:	00 00 00 
  8004202ae2:	ff d0                	callq  *%rax
  8004202ae4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8004202aea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004202af0:	c9                   	leaveq 
  8004202af1:	c3                   	retq   

0000008004202af2 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8004202af2:	55                   	push   %rbp
  8004202af3:	48 89 e5             	mov    %rsp,%rbp
  8004202af6:	48 83 ec 20          	sub    $0x20,%rsp
  8004202afa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, c, echoing;

	if (prompt != NULL)
  8004202afe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202b03:	74 22                	je     8004202b27 <readline+0x35>
		cprintf("%s", prompt);
  8004202b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202b09:	48 89 c6             	mov    %rax,%rsi
  8004202b0c:	48 bf c8 9d 20 04 80 	movabs $0x8004209dc8,%rdi
  8004202b13:	00 00 00 
  8004202b16:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202b1b:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004202b22:	00 00 00 
  8004202b25:	ff d2                	callq  *%rdx

	i = 0;
  8004202b27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8004202b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  8004202b33:	48 b8 93 0e 20 04 80 	movabs $0x8004200e93,%rax
  8004202b3a:	00 00 00 
  8004202b3d:	ff d0                	callq  *%rax
  8004202b3f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8004202b42:	48 b8 71 0e 20 04 80 	movabs $0x8004200e71,%rax
  8004202b49:	00 00 00 
  8004202b4c:	ff d0                	callq  *%rax
  8004202b4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8004202b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004202b55:	79 2a                	jns    8004202b81 <readline+0x8f>
			cprintf("read error: %e\n", c);
  8004202b57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202b5a:	89 c6                	mov    %eax,%esi
  8004202b5c:	48 bf cb 9d 20 04 80 	movabs $0x8004209dcb,%rdi
  8004202b63:	00 00 00 
  8004202b66:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202b6b:	48 ba 09 14 20 04 80 	movabs $0x8004201409,%rdx
  8004202b72:	00 00 00 
  8004202b75:	ff d2                	callq  *%rdx
			return NULL;
  8004202b77:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202b7c:	e9 be 00 00 00       	jmpq   8004202c3f <readline+0x14d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8004202b81:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  8004202b85:	74 06                	je     8004202b8d <readline+0x9b>
  8004202b87:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8004202b8b:	75 26                	jne    8004202bb3 <readline+0xc1>
  8004202b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004202b91:	7e 20                	jle    8004202bb3 <readline+0xc1>
			if (echoing)
  8004202b93:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202b97:	74 11                	je     8004202baa <readline+0xb8>
				cputchar('\b');
  8004202b99:	bf 08 00 00 00       	mov    $0x8,%edi
  8004202b9e:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202ba5:	00 00 00 
  8004202ba8:	ff d0                	callq  *%rax
			i--;
  8004202baa:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  8004202bae:	e9 87 00 00 00       	jmpq   8004202c3a <readline+0x148>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8004202bb3:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004202bb7:	7e 3f                	jle    8004202bf8 <readline+0x106>
  8004202bb9:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8004202bc0:	7f 36                	jg     8004202bf8 <readline+0x106>
			if (echoing)
  8004202bc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202bc6:	74 11                	je     8004202bd9 <readline+0xe7>
				cputchar(c);
  8004202bc8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202bcb:	89 c7                	mov    %eax,%edi
  8004202bcd:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202bd4:	00 00 00 
  8004202bd7:	ff d0                	callq  *%rax
			buf[i++] = c;
  8004202bd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202bdc:	8d 50 01             	lea    0x1(%rax),%edx
  8004202bdf:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8004202be2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004202be5:	89 d1                	mov    %edx,%ecx
  8004202be7:	48 ba e0 c8 21 04 80 	movabs $0x800421c8e0,%rdx
  8004202bee:	00 00 00 
  8004202bf1:	48 98                	cltq   
  8004202bf3:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8004202bf6:	eb 42                	jmp    8004202c3a <readline+0x148>
		} else if (c == '\n' || c == '\r') {
  8004202bf8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8004202bfc:	74 06                	je     8004202c04 <readline+0x112>
  8004202bfe:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8004202c02:	75 36                	jne    8004202c3a <readline+0x148>
			if (echoing)
  8004202c04:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202c08:	74 11                	je     8004202c1b <readline+0x129>
				cputchar('\n');
  8004202c0a:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004202c0f:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202c16:	00 00 00 
  8004202c19:	ff d0                	callq  *%rax
			buf[i] = 0;
  8004202c1b:	48 ba e0 c8 21 04 80 	movabs $0x800421c8e0,%rdx
  8004202c22:	00 00 00 
  8004202c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202c28:	48 98                	cltq   
  8004202c2a:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8004202c2e:	48 b8 e0 c8 21 04 80 	movabs $0x800421c8e0,%rax
  8004202c35:	00 00 00 
  8004202c38:	eb 05                	jmp    8004202c3f <readline+0x14d>
		}
	}
  8004202c3a:	e9 03 ff ff ff       	jmpq   8004202b42 <readline+0x50>
}
  8004202c3f:	c9                   	leaveq 
  8004202c40:	c3                   	retq   

0000008004202c41 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8004202c41:	55                   	push   %rbp
  8004202c42:	48 89 e5             	mov    %rsp,%rbp
  8004202c45:	48 83 ec 18          	sub    $0x18,%rsp
  8004202c49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8004202c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004202c54:	eb 09                	jmp    8004202c5f <strlen+0x1e>
		n++;
  8004202c56:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8004202c5a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004202c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202c63:	0f b6 00             	movzbl (%rax),%eax
  8004202c66:	84 c0                	test   %al,%al
  8004202c68:	75 ec                	jne    8004202c56 <strlen+0x15>
		n++;
	return n;
  8004202c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004202c6d:	c9                   	leaveq 
  8004202c6e:	c3                   	retq   

0000008004202c6f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8004202c6f:	55                   	push   %rbp
  8004202c70:	48 89 e5             	mov    %rsp,%rbp
  8004202c73:	48 83 ec 20          	sub    $0x20,%rsp
  8004202c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202c7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004202c7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004202c86:	eb 0e                	jmp    8004202c96 <strnlen+0x27>
		n++;
  8004202c88:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004202c8c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004202c91:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8004202c96:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004202c9b:	74 0b                	je     8004202ca8 <strnlen+0x39>
  8004202c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ca1:	0f b6 00             	movzbl (%rax),%eax
  8004202ca4:	84 c0                	test   %al,%al
  8004202ca6:	75 e0                	jne    8004202c88 <strnlen+0x19>
		n++;
	return n;
  8004202ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004202cab:	c9                   	leaveq 
  8004202cac:	c3                   	retq   

0000008004202cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8004202cad:	55                   	push   %rbp
  8004202cae:	48 89 e5             	mov    %rsp,%rbp
  8004202cb1:	48 83 ec 20          	sub    $0x20,%rsp
  8004202cb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202cb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8004202cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202cc1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8004202cc5:	90                   	nop
  8004202cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202cca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202cce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202cd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202cd6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004202cda:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004202cde:	0f b6 12             	movzbl (%rdx),%edx
  8004202ce1:	88 10                	mov    %dl,(%rax)
  8004202ce3:	0f b6 00             	movzbl (%rax),%eax
  8004202ce6:	84 c0                	test   %al,%al
  8004202ce8:	75 dc                	jne    8004202cc6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8004202cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004202cee:	c9                   	leaveq 
  8004202cef:	c3                   	retq   

0000008004202cf0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8004202cf0:	55                   	push   %rbp
  8004202cf1:	48 89 e5             	mov    %rsp,%rbp
  8004202cf4:	48 83 ec 20          	sub    $0x20,%rsp
  8004202cf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202cfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8004202d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d04:	48 89 c7             	mov    %rax,%rdi
  8004202d07:	48 b8 41 2c 20 04 80 	movabs $0x8004202c41,%rax
  8004202d0e:	00 00 00 
  8004202d11:	ff d0                	callq  *%rax
  8004202d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8004202d16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202d19:	48 63 d0             	movslq %eax,%rdx
  8004202d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d20:	48 01 c2             	add    %rax,%rdx
  8004202d23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202d27:	48 89 c6             	mov    %rax,%rsi
  8004202d2a:	48 89 d7             	mov    %rdx,%rdi
  8004202d2d:	48 b8 ad 2c 20 04 80 	movabs $0x8004202cad,%rax
  8004202d34:	00 00 00 
  8004202d37:	ff d0                	callq  *%rax
	return dst;
  8004202d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004202d3d:	c9                   	leaveq 
  8004202d3e:	c3                   	retq   

0000008004202d3f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8004202d3f:	55                   	push   %rbp
  8004202d40:	48 89 e5             	mov    %rsp,%rbp
  8004202d43:	48 83 ec 28          	sub    $0x28,%rsp
  8004202d47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202d4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202d4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8004202d53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8004202d5b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004202d62:	00 
  8004202d63:	eb 2a                	jmp    8004202d8f <strncpy+0x50>
		*dst++ = *src;
  8004202d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d69:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202d6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202d71:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202d75:	0f b6 12             	movzbl (%rdx),%edx
  8004202d78:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8004202d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202d7e:	0f b6 00             	movzbl (%rax),%eax
  8004202d81:	84 c0                	test   %al,%al
  8004202d83:	74 05                	je     8004202d8a <strncpy+0x4b>
			src++;
  8004202d85:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8004202d8a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202d93:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004202d97:	72 cc                	jb     8004202d65 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8004202d99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004202d9d:	c9                   	leaveq 
  8004202d9e:	c3                   	retq   

0000008004202d9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8004202d9f:	55                   	push   %rbp
  8004202da0:	48 89 e5             	mov    %rsp,%rbp
  8004202da3:	48 83 ec 28          	sub    $0x28,%rsp
  8004202da7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202dab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202daf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8004202db3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202db7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8004202dbb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004202dc0:	74 3d                	je     8004202dff <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8004202dc2:	eb 1d                	jmp    8004202de1 <strlcpy+0x42>
			*dst++ = *src++;
  8004202dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202dc8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202dcc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202dd0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202dd4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004202dd8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004202ddc:	0f b6 12             	movzbl (%rdx),%edx
  8004202ddf:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8004202de1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8004202de6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004202deb:	74 0b                	je     8004202df8 <strlcpy+0x59>
  8004202ded:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202df1:	0f b6 00             	movzbl (%rax),%eax
  8004202df4:	84 c0                	test   %al,%al
  8004202df6:	75 cc                	jne    8004202dc4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8004202df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202dfc:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8004202dff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e07:	48 29 c2             	sub    %rax,%rdx
  8004202e0a:	48 89 d0             	mov    %rdx,%rax
}
  8004202e0d:	c9                   	leaveq 
  8004202e0e:	c3                   	retq   

0000008004202e0f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8004202e0f:	55                   	push   %rbp
  8004202e10:	48 89 e5             	mov    %rsp,%rbp
  8004202e13:	48 83 ec 10          	sub    $0x10,%rsp
  8004202e17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202e1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8004202e1f:	eb 0a                	jmp    8004202e2b <strcmp+0x1c>
		p++, q++;
  8004202e21:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202e26:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8004202e2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e2f:	0f b6 00             	movzbl (%rax),%eax
  8004202e32:	84 c0                	test   %al,%al
  8004202e34:	74 12                	je     8004202e48 <strcmp+0x39>
  8004202e36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e3a:	0f b6 10             	movzbl (%rax),%edx
  8004202e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202e41:	0f b6 00             	movzbl (%rax),%eax
  8004202e44:	38 c2                	cmp    %al,%dl
  8004202e46:	74 d9                	je     8004202e21 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8004202e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e4c:	0f b6 00             	movzbl (%rax),%eax
  8004202e4f:	0f b6 d0             	movzbl %al,%edx
  8004202e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202e56:	0f b6 00             	movzbl (%rax),%eax
  8004202e59:	0f b6 c0             	movzbl %al,%eax
  8004202e5c:	29 c2                	sub    %eax,%edx
  8004202e5e:	89 d0                	mov    %edx,%eax
}
  8004202e60:	c9                   	leaveq 
  8004202e61:	c3                   	retq   

0000008004202e62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8004202e62:	55                   	push   %rbp
  8004202e63:	48 89 e5             	mov    %rsp,%rbp
  8004202e66:	48 83 ec 18          	sub    $0x18,%rsp
  8004202e6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202e6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004202e72:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8004202e76:	eb 0f                	jmp    8004202e87 <strncmp+0x25>
		n--, p++, q++;
  8004202e78:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8004202e7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202e82:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8004202e87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202e8c:	74 1d                	je     8004202eab <strncmp+0x49>
  8004202e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e92:	0f b6 00             	movzbl (%rax),%eax
  8004202e95:	84 c0                	test   %al,%al
  8004202e97:	74 12                	je     8004202eab <strncmp+0x49>
  8004202e99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e9d:	0f b6 10             	movzbl (%rax),%edx
  8004202ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202ea4:	0f b6 00             	movzbl (%rax),%eax
  8004202ea7:	38 c2                	cmp    %al,%dl
  8004202ea9:	74 cd                	je     8004202e78 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8004202eab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202eb0:	75 07                	jne    8004202eb9 <strncmp+0x57>
		return 0;
  8004202eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202eb7:	eb 18                	jmp    8004202ed1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8004202eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202ebd:	0f b6 00             	movzbl (%rax),%eax
  8004202ec0:	0f b6 d0             	movzbl %al,%edx
  8004202ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202ec7:	0f b6 00             	movzbl (%rax),%eax
  8004202eca:	0f b6 c0             	movzbl %al,%eax
  8004202ecd:	29 c2                	sub    %eax,%edx
  8004202ecf:	89 d0                	mov    %edx,%eax
}
  8004202ed1:	c9                   	leaveq 
  8004202ed2:	c3                   	retq   

0000008004202ed3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8004202ed3:	55                   	push   %rbp
  8004202ed4:	48 89 e5             	mov    %rsp,%rbp
  8004202ed7:	48 83 ec 0c          	sub    $0xc,%rsp
  8004202edb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202edf:	89 f0                	mov    %esi,%eax
  8004202ee1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004202ee4:	eb 17                	jmp    8004202efd <strchr+0x2a>
		if (*s == c)
  8004202ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202eea:	0f b6 00             	movzbl (%rax),%eax
  8004202eed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004202ef0:	75 06                	jne    8004202ef8 <strchr+0x25>
			return (char *) s;
  8004202ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202ef6:	eb 15                	jmp    8004202f0d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004202ef8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f01:	0f b6 00             	movzbl (%rax),%eax
  8004202f04:	84 c0                	test   %al,%al
  8004202f06:	75 de                	jne    8004202ee6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004202f08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202f0d:	c9                   	leaveq 
  8004202f0e:	c3                   	retq   

0000008004202f0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004202f0f:	55                   	push   %rbp
  8004202f10:	48 89 e5             	mov    %rsp,%rbp
  8004202f13:	48 83 ec 0c          	sub    $0xc,%rsp
  8004202f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202f1b:	89 f0                	mov    %esi,%eax
  8004202f1d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004202f20:	eb 13                	jmp    8004202f35 <strfind+0x26>
		if (*s == c)
  8004202f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f26:	0f b6 00             	movzbl (%rax),%eax
  8004202f29:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004202f2c:	75 02                	jne    8004202f30 <strfind+0x21>
			break;
  8004202f2e:	eb 10                	jmp    8004202f40 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004202f30:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f39:	0f b6 00             	movzbl (%rax),%eax
  8004202f3c:	84 c0                	test   %al,%al
  8004202f3e:	75 e2                	jne    8004202f22 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004202f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004202f44:	c9                   	leaveq 
  8004202f45:	c3                   	retq   

0000008004202f46 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004202f46:	55                   	push   %rbp
  8004202f47:	48 89 e5             	mov    %rsp,%rbp
  8004202f4a:	48 83 ec 18          	sub    $0x18,%rsp
  8004202f4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202f52:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8004202f55:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8004202f59:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202f5e:	75 06                	jne    8004202f66 <memset+0x20>
		return v;
  8004202f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f64:	eb 69                	jmp    8004202fcf <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8004202f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f6a:	83 e0 03             	and    $0x3,%eax
  8004202f6d:	48 85 c0             	test   %rax,%rax
  8004202f70:	75 48                	jne    8004202fba <memset+0x74>
  8004202f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f76:	83 e0 03             	and    $0x3,%eax
  8004202f79:	48 85 c0             	test   %rax,%rax
  8004202f7c:	75 3c                	jne    8004202fba <memset+0x74>
		c &= 0xFF;
  8004202f7e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8004202f85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202f88:	c1 e0 18             	shl    $0x18,%eax
  8004202f8b:	89 c2                	mov    %eax,%edx
  8004202f8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202f90:	c1 e0 10             	shl    $0x10,%eax
  8004202f93:	09 c2                	or     %eax,%edx
  8004202f95:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202f98:	c1 e0 08             	shl    $0x8,%eax
  8004202f9b:	09 d0                	or     %edx,%eax
  8004202f9d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8004202fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202fa4:	48 c1 e8 02          	shr    $0x2,%rax
  8004202fa8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8004202fab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004202faf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202fb2:	48 89 d7             	mov    %rdx,%rdi
  8004202fb5:	fc                   	cld    
  8004202fb6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8004202fb8:	eb 11                	jmp    8004202fcb <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8004202fba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004202fbe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202fc1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004202fc5:	48 89 d7             	mov    %rdx,%rdi
  8004202fc8:	fc                   	cld    
  8004202fc9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8004202fcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004202fcf:	c9                   	leaveq 
  8004202fd0:	c3                   	retq   

0000008004202fd1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8004202fd1:	55                   	push   %rbp
  8004202fd2:	48 89 e5             	mov    %rsp,%rbp
  8004202fd5:	48 83 ec 28          	sub    $0x28,%rsp
  8004202fd9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202fdd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202fe1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8004202fe5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202fe9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8004202fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ff1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8004202ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202ff9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8004202ffd:	0f 83 88 00 00 00    	jae    800420308b <memmove+0xba>
  8004203003:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203007:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420300b:	48 01 d0             	add    %rdx,%rax
  800420300e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8004203012:	76 77                	jbe    800420308b <memmove+0xba>
		s += n;
  8004203014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203018:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  800420301c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203020:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8004203024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203028:	83 e0 03             	and    $0x3,%eax
  800420302b:	48 85 c0             	test   %rax,%rax
  800420302e:	75 3b                	jne    800420306b <memmove+0x9a>
  8004203030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203034:	83 e0 03             	and    $0x3,%eax
  8004203037:	48 85 c0             	test   %rax,%rax
  800420303a:	75 2f                	jne    800420306b <memmove+0x9a>
  800420303c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203040:	83 e0 03             	and    $0x3,%eax
  8004203043:	48 85 c0             	test   %rax,%rax
  8004203046:	75 23                	jne    800420306b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8004203048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420304c:	48 83 e8 04          	sub    $0x4,%rax
  8004203050:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004203054:	48 83 ea 04          	sub    $0x4,%rdx
  8004203058:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420305c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8004203060:	48 89 c7             	mov    %rax,%rdi
  8004203063:	48 89 d6             	mov    %rdx,%rsi
  8004203066:	fd                   	std    
  8004203067:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8004203069:	eb 1d                	jmp    8004203088 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800420306b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420306f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004203073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203077:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800420307b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420307f:	48 89 d7             	mov    %rdx,%rdi
  8004203082:	48 89 c1             	mov    %rax,%rcx
  8004203085:	fd                   	std    
  8004203086:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8004203088:	fc                   	cld    
  8004203089:	eb 57                	jmp    80042030e2 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800420308b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420308f:	83 e0 03             	and    $0x3,%eax
  8004203092:	48 85 c0             	test   %rax,%rax
  8004203095:	75 36                	jne    80042030cd <memmove+0xfc>
  8004203097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420309b:	83 e0 03             	and    $0x3,%eax
  800420309e:	48 85 c0             	test   %rax,%rax
  80042030a1:	75 2a                	jne    80042030cd <memmove+0xfc>
  80042030a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042030a7:	83 e0 03             	and    $0x3,%eax
  80042030aa:	48 85 c0             	test   %rax,%rax
  80042030ad:	75 1e                	jne    80042030cd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80042030af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042030b3:	48 c1 e8 02          	shr    $0x2,%rax
  80042030b7:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80042030ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042030be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042030c2:	48 89 c7             	mov    %rax,%rdi
  80042030c5:	48 89 d6             	mov    %rdx,%rsi
  80042030c8:	fc                   	cld    
  80042030c9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80042030cb:	eb 15                	jmp    80042030e2 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80042030cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042030d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042030d5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80042030d9:	48 89 c7             	mov    %rax,%rdi
  80042030dc:	48 89 d6             	mov    %rdx,%rsi
  80042030df:	fc                   	cld    
  80042030e0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80042030e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80042030e6:	c9                   	leaveq 
  80042030e7:	c3                   	retq   

00000080042030e8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80042030e8:	55                   	push   %rbp
  80042030e9:	48 89 e5             	mov    %rsp,%rbp
  80042030ec:	48 83 ec 18          	sub    $0x18,%rsp
  80042030f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042030f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80042030f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80042030fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203100:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004203104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203108:	48 89 ce             	mov    %rcx,%rsi
  800420310b:	48 89 c7             	mov    %rax,%rdi
  800420310e:	48 b8 d1 2f 20 04 80 	movabs $0x8004202fd1,%rax
  8004203115:	00 00 00 
  8004203118:	ff d0                	callq  *%rax
}
  800420311a:	c9                   	leaveq 
  800420311b:	c3                   	retq   

000000800420311c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800420311c:	55                   	push   %rbp
  800420311d:	48 89 e5             	mov    %rsp,%rbp
  8004203120:	48 83 ec 28          	sub    $0x28,%rsp
  8004203124:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203128:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420312c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8004203130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203134:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8004203138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420313c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8004203140:	eb 36                	jmp    8004203178 <memcmp+0x5c>
		if (*s1 != *s2)
  8004203142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203146:	0f b6 10             	movzbl (%rax),%edx
  8004203149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420314d:	0f b6 00             	movzbl (%rax),%eax
  8004203150:	38 c2                	cmp    %al,%dl
  8004203152:	74 1a                	je     800420316e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8004203154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203158:	0f b6 00             	movzbl (%rax),%eax
  800420315b:	0f b6 d0             	movzbl %al,%edx
  800420315e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203162:	0f b6 00             	movzbl (%rax),%eax
  8004203165:	0f b6 c0             	movzbl %al,%eax
  8004203168:	29 c2                	sub    %eax,%edx
  800420316a:	89 d0                	mov    %edx,%eax
  800420316c:	eb 20                	jmp    800420318e <memcmp+0x72>
		s1++, s2++;
  800420316e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004203173:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8004203178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420317c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004203180:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004203184:	48 85 c0             	test   %rax,%rax
  8004203187:	75 b9                	jne    8004203142 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8004203189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420318e:	c9                   	leaveq 
  800420318f:	c3                   	retq   

0000008004203190 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8004203190:	55                   	push   %rbp
  8004203191:	48 89 e5             	mov    %rsp,%rbp
  8004203194:	48 83 ec 28          	sub    $0x28,%rsp
  8004203198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420319c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800420319f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80042031a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042031a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042031ab:	48 01 d0             	add    %rdx,%rax
  80042031ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80042031b2:	eb 15                	jmp    80042031c9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80042031b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042031b8:	0f b6 10             	movzbl (%rax),%edx
  80042031bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042031be:	38 c2                	cmp    %al,%dl
  80042031c0:	75 02                	jne    80042031c4 <memfind+0x34>
			break;
  80042031c2:	eb 0f                	jmp    80042031d3 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80042031c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80042031c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042031cd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80042031d1:	72 e1                	jb     80042031b4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80042031d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80042031d7:	c9                   	leaveq 
  80042031d8:	c3                   	retq   

00000080042031d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80042031d9:	55                   	push   %rbp
  80042031da:	48 89 e5             	mov    %rsp,%rbp
  80042031dd:	48 83 ec 34          	sub    $0x34,%rsp
  80042031e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042031e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80042031e9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80042031ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80042031f3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80042031fa:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80042031fb:	eb 05                	jmp    8004203202 <strtol+0x29>
		s++;
  80042031fd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004203202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203206:	0f b6 00             	movzbl (%rax),%eax
  8004203209:	3c 20                	cmp    $0x20,%al
  800420320b:	74 f0                	je     80042031fd <strtol+0x24>
  800420320d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203211:	0f b6 00             	movzbl (%rax),%eax
  8004203214:	3c 09                	cmp    $0x9,%al
  8004203216:	74 e5                	je     80042031fd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8004203218:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420321c:	0f b6 00             	movzbl (%rax),%eax
  800420321f:	3c 2b                	cmp    $0x2b,%al
  8004203221:	75 07                	jne    800420322a <strtol+0x51>
		s++;
  8004203223:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8004203228:	eb 17                	jmp    8004203241 <strtol+0x68>
	else if (*s == '-')
  800420322a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420322e:	0f b6 00             	movzbl (%rax),%eax
  8004203231:	3c 2d                	cmp    $0x2d,%al
  8004203233:	75 0c                	jne    8004203241 <strtol+0x68>
		s++, neg = 1;
  8004203235:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800420323a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8004203241:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004203245:	74 06                	je     800420324d <strtol+0x74>
  8004203247:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  800420324b:	75 28                	jne    8004203275 <strtol+0x9c>
  800420324d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203251:	0f b6 00             	movzbl (%rax),%eax
  8004203254:	3c 30                	cmp    $0x30,%al
  8004203256:	75 1d                	jne    8004203275 <strtol+0x9c>
  8004203258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420325c:	48 83 c0 01          	add    $0x1,%rax
  8004203260:	0f b6 00             	movzbl (%rax),%eax
  8004203263:	3c 78                	cmp    $0x78,%al
  8004203265:	75 0e                	jne    8004203275 <strtol+0x9c>
		s += 2, base = 16;
  8004203267:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800420326c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8004203273:	eb 2c                	jmp    80042032a1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8004203275:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004203279:	75 19                	jne    8004203294 <strtol+0xbb>
  800420327b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420327f:	0f b6 00             	movzbl (%rax),%eax
  8004203282:	3c 30                	cmp    $0x30,%al
  8004203284:	75 0e                	jne    8004203294 <strtol+0xbb>
		s++, base = 8;
  8004203286:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800420328b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8004203292:	eb 0d                	jmp    80042032a1 <strtol+0xc8>
	else if (base == 0)
  8004203294:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004203298:	75 07                	jne    80042032a1 <strtol+0xc8>
		base = 10;
  800420329a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80042032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032a5:	0f b6 00             	movzbl (%rax),%eax
  80042032a8:	3c 2f                	cmp    $0x2f,%al
  80042032aa:	7e 1d                	jle    80042032c9 <strtol+0xf0>
  80042032ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032b0:	0f b6 00             	movzbl (%rax),%eax
  80042032b3:	3c 39                	cmp    $0x39,%al
  80042032b5:	7f 12                	jg     80042032c9 <strtol+0xf0>
			dig = *s - '0';
  80042032b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032bb:	0f b6 00             	movzbl (%rax),%eax
  80042032be:	0f be c0             	movsbl %al,%eax
  80042032c1:	83 e8 30             	sub    $0x30,%eax
  80042032c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80042032c7:	eb 4e                	jmp    8004203317 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80042032c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032cd:	0f b6 00             	movzbl (%rax),%eax
  80042032d0:	3c 60                	cmp    $0x60,%al
  80042032d2:	7e 1d                	jle    80042032f1 <strtol+0x118>
  80042032d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032d8:	0f b6 00             	movzbl (%rax),%eax
  80042032db:	3c 7a                	cmp    $0x7a,%al
  80042032dd:	7f 12                	jg     80042032f1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80042032df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032e3:	0f b6 00             	movzbl (%rax),%eax
  80042032e6:	0f be c0             	movsbl %al,%eax
  80042032e9:	83 e8 57             	sub    $0x57,%eax
  80042032ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80042032ef:	eb 26                	jmp    8004203317 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80042032f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042032f5:	0f b6 00             	movzbl (%rax),%eax
  80042032f8:	3c 40                	cmp    $0x40,%al
  80042032fa:	7e 48                	jle    8004203344 <strtol+0x16b>
  80042032fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203300:	0f b6 00             	movzbl (%rax),%eax
  8004203303:	3c 5a                	cmp    $0x5a,%al
  8004203305:	7f 3d                	jg     8004203344 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8004203307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420330b:	0f b6 00             	movzbl (%rax),%eax
  800420330e:	0f be c0             	movsbl %al,%eax
  8004203311:	83 e8 37             	sub    $0x37,%eax
  8004203314:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8004203317:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420331a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  800420331d:	7c 02                	jl     8004203321 <strtol+0x148>
			break;
  800420331f:	eb 23                	jmp    8004203344 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8004203321:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8004203326:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004203329:	48 98                	cltq   
  800420332b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8004203330:	48 89 c2             	mov    %rax,%rdx
  8004203333:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004203336:	48 98                	cltq   
  8004203338:	48 01 d0             	add    %rdx,%rax
  800420333b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  800420333f:	e9 5d ff ff ff       	jmpq   80042032a1 <strtol+0xc8>

	if (endptr)
  8004203344:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004203349:	74 0b                	je     8004203356 <strtol+0x17d>
		*endptr = (char *) s;
  800420334b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420334f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004203353:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8004203356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800420335a:	74 09                	je     8004203365 <strtol+0x18c>
  800420335c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203360:	48 f7 d8             	neg    %rax
  8004203363:	eb 04                	jmp    8004203369 <strtol+0x190>
  8004203365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203369:	c9                   	leaveq 
  800420336a:	c3                   	retq   

000000800420336b <strstr>:

char * strstr(const char *in, const char *str)
{
  800420336b:	55                   	push   %rbp
  800420336c:	48 89 e5             	mov    %rsp,%rbp
  800420336f:	48 83 ec 30          	sub    $0x30,%rsp
  8004203373:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203377:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  800420337b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420337f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203383:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004203387:	0f b6 00             	movzbl (%rax),%eax
  800420338a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800420338d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8004203391:	75 06                	jne    8004203399 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8004203393:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203397:	eb 6b                	jmp    8004203404 <strstr+0x99>

	len = strlen(str);
  8004203399:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420339d:	48 89 c7             	mov    %rax,%rdi
  80042033a0:	48 b8 41 2c 20 04 80 	movabs $0x8004202c41,%rax
  80042033a7:	00 00 00 
  80042033aa:	ff d0                	callq  *%rax
  80042033ac:	48 98                	cltq   
  80042033ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80042033b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042033ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042033be:	0f b6 00             	movzbl (%rax),%eax
  80042033c1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80042033c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80042033c8:	75 07                	jne    80042033d1 <strstr+0x66>
				return (char *) 0;
  80042033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  80042033cf:	eb 33                	jmp    8004203404 <strstr+0x99>
		} while (sc != c);
  80042033d1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80042033d5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80042033d8:	75 d8                	jne    80042033b2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80042033da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042033de:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80042033e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033e6:	48 89 ce             	mov    %rcx,%rsi
  80042033e9:	48 89 c7             	mov    %rax,%rdi
  80042033ec:	48 b8 62 2e 20 04 80 	movabs $0x8004202e62,%rax
  80042033f3:	00 00 00 
  80042033f6:	ff d0                	callq  *%rax
  80042033f8:	85 c0                	test   %eax,%eax
  80042033fa:	75 b6                	jne    80042033b2 <strstr+0x47>

	return (char *) (in - 1);
  80042033fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203400:	48 83 e8 01          	sub    $0x1,%rax
}
  8004203404:	c9                   	leaveq 
  8004203405:	c3                   	retq   

0000008004203406 <_dwarf_read_lsb>:
Dwarf_Section *
_dwarf_find_section(const char *name);

uint64_t
_dwarf_read_lsb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  8004203406:	55                   	push   %rbp
  8004203407:	48 89 e5             	mov    %rsp,%rbp
  800420340a:	48 83 ec 24          	sub    $0x24,%rsp
  800420340e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203412:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203416:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  8004203419:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420341d:	48 8b 10             	mov    (%rax),%rdx
  8004203420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203424:	48 01 d0             	add    %rdx,%rax
  8004203427:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  800420342b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203432:	00 
	switch (bytes_to_read) {
  8004203433:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004203436:	83 f8 02             	cmp    $0x2,%eax
  8004203439:	0f 84 ab 00 00 00    	je     80042034ea <_dwarf_read_lsb+0xe4>
  800420343f:	83 f8 02             	cmp    $0x2,%eax
  8004203442:	7f 0e                	jg     8004203452 <_dwarf_read_lsb+0x4c>
  8004203444:	83 f8 01             	cmp    $0x1,%eax
  8004203447:	0f 84 b3 00 00 00    	je     8004203500 <_dwarf_read_lsb+0xfa>
  800420344d:	e9 d9 00 00 00       	jmpq   800420352b <_dwarf_read_lsb+0x125>
  8004203452:	83 f8 04             	cmp    $0x4,%eax
  8004203455:	74 65                	je     80042034bc <_dwarf_read_lsb+0xb6>
  8004203457:	83 f8 08             	cmp    $0x8,%eax
  800420345a:	0f 85 cb 00 00 00    	jne    800420352b <_dwarf_read_lsb+0x125>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  8004203460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203464:	48 83 c0 04          	add    $0x4,%rax
  8004203468:	0f b6 00             	movzbl (%rax),%eax
  800420346b:	0f b6 c0             	movzbl %al,%eax
  800420346e:	48 c1 e0 20          	shl    $0x20,%rax
  8004203472:	48 89 c2             	mov    %rax,%rdx
  8004203475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203479:	48 83 c0 05          	add    $0x5,%rax
  800420347d:	0f b6 00             	movzbl (%rax),%eax
  8004203480:	0f b6 c0             	movzbl %al,%eax
  8004203483:	48 c1 e0 28          	shl    $0x28,%rax
  8004203487:	48 09 d0             	or     %rdx,%rax
  800420348a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  800420348e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203492:	48 83 c0 06          	add    $0x6,%rax
  8004203496:	0f b6 00             	movzbl (%rax),%eax
  8004203499:	0f b6 c0             	movzbl %al,%eax
  800420349c:	48 c1 e0 30          	shl    $0x30,%rax
  80042034a0:	48 89 c2             	mov    %rax,%rdx
  80042034a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042034a7:	48 83 c0 07          	add    $0x7,%rax
  80042034ab:	0f b6 00             	movzbl (%rax),%eax
  80042034ae:	0f b6 c0             	movzbl %al,%eax
  80042034b1:	48 c1 e0 38          	shl    $0x38,%rax
  80042034b5:	48 09 d0             	or     %rdx,%rax
  80042034b8:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  80042034bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042034c0:	48 83 c0 02          	add    $0x2,%rax
  80042034c4:	0f b6 00             	movzbl (%rax),%eax
  80042034c7:	0f b6 c0             	movzbl %al,%eax
  80042034ca:	48 c1 e0 10          	shl    $0x10,%rax
  80042034ce:	48 89 c2             	mov    %rax,%rdx
  80042034d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042034d5:	48 83 c0 03          	add    $0x3,%rax
  80042034d9:	0f b6 00             	movzbl (%rax),%eax
  80042034dc:	0f b6 c0             	movzbl %al,%eax
  80042034df:	48 c1 e0 18          	shl    $0x18,%rax
  80042034e3:	48 09 d0             	or     %rdx,%rax
  80042034e6:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  80042034ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042034ee:	48 83 c0 01          	add    $0x1,%rax
  80042034f2:	0f b6 00             	movzbl (%rax),%eax
  80042034f5:	0f b6 c0             	movzbl %al,%eax
  80042034f8:	48 c1 e0 08          	shl    $0x8,%rax
  80042034fc:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  8004203500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203504:	0f b6 00             	movzbl (%rax),%eax
  8004203507:	0f b6 c0             	movzbl %al,%eax
  800420350a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420350e:	90                   	nop
	default:
		return (0);
	}

	*offsetp += bytes_to_read;
  800420350f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203513:	48 8b 10             	mov    (%rax),%rdx
  8004203516:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004203519:	48 98                	cltq   
  800420351b:	48 01 c2             	add    %rax,%rdx
  800420351e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203522:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203529:	eb 05                	jmp    8004203530 <_dwarf_read_lsb+0x12a>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  800420352b:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*offsetp += bytes_to_read;

	return (ret);
}
  8004203530:	c9                   	leaveq 
  8004203531:	c3                   	retq   

0000008004203532 <_dwarf_decode_lsb>:

uint64_t
_dwarf_decode_lsb(uint8_t **data, int bytes_to_read)
{
  8004203532:	55                   	push   %rbp
  8004203533:	48 89 e5             	mov    %rsp,%rbp
  8004203536:	48 83 ec 1c          	sub    $0x1c,%rsp
  800420353a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420353e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  8004203541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203545:	48 8b 00             	mov    (%rax),%rax
  8004203548:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  800420354c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203553:	00 
	switch (bytes_to_read) {
  8004203554:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004203557:	83 f8 02             	cmp    $0x2,%eax
  800420355a:	0f 84 ab 00 00 00    	je     800420360b <_dwarf_decode_lsb+0xd9>
  8004203560:	83 f8 02             	cmp    $0x2,%eax
  8004203563:	7f 0e                	jg     8004203573 <_dwarf_decode_lsb+0x41>
  8004203565:	83 f8 01             	cmp    $0x1,%eax
  8004203568:	0f 84 b3 00 00 00    	je     8004203621 <_dwarf_decode_lsb+0xef>
  800420356e:	e9 d9 00 00 00       	jmpq   800420364c <_dwarf_decode_lsb+0x11a>
  8004203573:	83 f8 04             	cmp    $0x4,%eax
  8004203576:	74 65                	je     80042035dd <_dwarf_decode_lsb+0xab>
  8004203578:	83 f8 08             	cmp    $0x8,%eax
  800420357b:	0f 85 cb 00 00 00    	jne    800420364c <_dwarf_decode_lsb+0x11a>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  8004203581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203585:	48 83 c0 04          	add    $0x4,%rax
  8004203589:	0f b6 00             	movzbl (%rax),%eax
  800420358c:	0f b6 c0             	movzbl %al,%eax
  800420358f:	48 c1 e0 20          	shl    $0x20,%rax
  8004203593:	48 89 c2             	mov    %rax,%rdx
  8004203596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420359a:	48 83 c0 05          	add    $0x5,%rax
  800420359e:	0f b6 00             	movzbl (%rax),%eax
  80042035a1:	0f b6 c0             	movzbl %al,%eax
  80042035a4:	48 c1 e0 28          	shl    $0x28,%rax
  80042035a8:	48 09 d0             	or     %rdx,%rax
  80042035ab:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  80042035af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042035b3:	48 83 c0 06          	add    $0x6,%rax
  80042035b7:	0f b6 00             	movzbl (%rax),%eax
  80042035ba:	0f b6 c0             	movzbl %al,%eax
  80042035bd:	48 c1 e0 30          	shl    $0x30,%rax
  80042035c1:	48 89 c2             	mov    %rax,%rdx
  80042035c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042035c8:	48 83 c0 07          	add    $0x7,%rax
  80042035cc:	0f b6 00             	movzbl (%rax),%eax
  80042035cf:	0f b6 c0             	movzbl %al,%eax
  80042035d2:	48 c1 e0 38          	shl    $0x38,%rax
  80042035d6:	48 09 d0             	or     %rdx,%rax
  80042035d9:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  80042035dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042035e1:	48 83 c0 02          	add    $0x2,%rax
  80042035e5:	0f b6 00             	movzbl (%rax),%eax
  80042035e8:	0f b6 c0             	movzbl %al,%eax
  80042035eb:	48 c1 e0 10          	shl    $0x10,%rax
  80042035ef:	48 89 c2             	mov    %rax,%rdx
  80042035f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042035f6:	48 83 c0 03          	add    $0x3,%rax
  80042035fa:	0f b6 00             	movzbl (%rax),%eax
  80042035fd:	0f b6 c0             	movzbl %al,%eax
  8004203600:	48 c1 e0 18          	shl    $0x18,%rax
  8004203604:	48 09 d0             	or     %rdx,%rax
  8004203607:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  800420360b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420360f:	48 83 c0 01          	add    $0x1,%rax
  8004203613:	0f b6 00             	movzbl (%rax),%eax
  8004203616:	0f b6 c0             	movzbl %al,%eax
  8004203619:	48 c1 e0 08          	shl    $0x8,%rax
  800420361d:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  8004203621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203625:	0f b6 00             	movzbl (%rax),%eax
  8004203628:	0f b6 c0             	movzbl %al,%eax
  800420362b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420362f:	90                   	nop
	default:
		return (0);
	}

	*data += bytes_to_read;
  8004203630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203634:	48 8b 10             	mov    (%rax),%rdx
  8004203637:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420363a:	48 98                	cltq   
  800420363c:	48 01 c2             	add    %rax,%rdx
  800420363f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203643:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420364a:	eb 05                	jmp    8004203651 <_dwarf_decode_lsb+0x11f>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  800420364c:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*data += bytes_to_read;

	return (ret);
}
  8004203651:	c9                   	leaveq 
  8004203652:	c3                   	retq   

0000008004203653 <_dwarf_read_msb>:

uint64_t
_dwarf_read_msb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  8004203653:	55                   	push   %rbp
  8004203654:	48 89 e5             	mov    %rsp,%rbp
  8004203657:	48 83 ec 24          	sub    $0x24,%rsp
  800420365b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420365f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203663:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  8004203666:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420366a:	48 8b 10             	mov    (%rax),%rdx
  800420366d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203671:	48 01 d0             	add    %rdx,%rax
  8004203674:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	switch (bytes_to_read) {
  8004203678:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420367b:	83 f8 02             	cmp    $0x2,%eax
  800420367e:	74 35                	je     80042036b5 <_dwarf_read_msb+0x62>
  8004203680:	83 f8 02             	cmp    $0x2,%eax
  8004203683:	7f 0a                	jg     800420368f <_dwarf_read_msb+0x3c>
  8004203685:	83 f8 01             	cmp    $0x1,%eax
  8004203688:	74 18                	je     80042036a2 <_dwarf_read_msb+0x4f>
  800420368a:	e9 53 01 00 00       	jmpq   80042037e2 <_dwarf_read_msb+0x18f>
  800420368f:	83 f8 04             	cmp    $0x4,%eax
  8004203692:	74 49                	je     80042036dd <_dwarf_read_msb+0x8a>
  8004203694:	83 f8 08             	cmp    $0x8,%eax
  8004203697:	0f 84 96 00 00 00    	je     8004203733 <_dwarf_read_msb+0xe0>
  800420369d:	e9 40 01 00 00       	jmpq   80042037e2 <_dwarf_read_msb+0x18f>
	case 1:
		ret = src[0];
  80042036a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042036a6:	0f b6 00             	movzbl (%rax),%eax
  80042036a9:	0f b6 c0             	movzbl %al,%eax
  80042036ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  80042036b0:	e9 34 01 00 00       	jmpq   80042037e9 <_dwarf_read_msb+0x196>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  80042036b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042036b9:	48 83 c0 01          	add    $0x1,%rax
  80042036bd:	0f b6 00             	movzbl (%rax),%eax
  80042036c0:	0f b6 d0             	movzbl %al,%edx
  80042036c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042036c7:	0f b6 00             	movzbl (%rax),%eax
  80042036ca:	0f b6 c0             	movzbl %al,%eax
  80042036cd:	48 c1 e0 08          	shl    $0x8,%rax
  80042036d1:	48 09 d0             	or     %rdx,%rax
  80042036d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  80042036d8:	e9 0c 01 00 00       	jmpq   80042037e9 <_dwarf_read_msb+0x196>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  80042036dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042036e1:	48 83 c0 03          	add    $0x3,%rax
  80042036e5:	0f b6 00             	movzbl (%rax),%eax
  80042036e8:	0f b6 c0             	movzbl %al,%eax
  80042036eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042036ef:	48 83 c2 02          	add    $0x2,%rdx
  80042036f3:	0f b6 12             	movzbl (%rdx),%edx
  80042036f6:	0f b6 d2             	movzbl %dl,%edx
  80042036f9:	48 c1 e2 08          	shl    $0x8,%rdx
  80042036fd:	48 09 d0             	or     %rdx,%rax
  8004203700:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  8004203704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203708:	48 83 c0 01          	add    $0x1,%rax
  800420370c:	0f b6 00             	movzbl (%rax),%eax
  800420370f:	0f b6 c0             	movzbl %al,%eax
  8004203712:	48 c1 e0 10          	shl    $0x10,%rax
  8004203716:	48 89 c2             	mov    %rax,%rdx
  8004203719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420371d:	0f b6 00             	movzbl (%rax),%eax
  8004203720:	0f b6 c0             	movzbl %al,%eax
  8004203723:	48 c1 e0 18          	shl    $0x18,%rax
  8004203727:	48 09 d0             	or     %rdx,%rax
  800420372a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420372e:	e9 b6 00 00 00       	jmpq   80042037e9 <_dwarf_read_msb+0x196>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  8004203733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203737:	48 83 c0 07          	add    $0x7,%rax
  800420373b:	0f b6 00             	movzbl (%rax),%eax
  800420373e:	0f b6 c0             	movzbl %al,%eax
  8004203741:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004203745:	48 83 c2 06          	add    $0x6,%rdx
  8004203749:	0f b6 12             	movzbl (%rdx),%edx
  800420374c:	0f b6 d2             	movzbl %dl,%edx
  800420374f:	48 c1 e2 08          	shl    $0x8,%rdx
  8004203753:	48 09 d0             	or     %rdx,%rax
  8004203756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  800420375a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420375e:	48 83 c0 05          	add    $0x5,%rax
  8004203762:	0f b6 00             	movzbl (%rax),%eax
  8004203765:	0f b6 c0             	movzbl %al,%eax
  8004203768:	48 c1 e0 10          	shl    $0x10,%rax
  800420376c:	48 89 c2             	mov    %rax,%rdx
  800420376f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203773:	48 83 c0 04          	add    $0x4,%rax
  8004203777:	0f b6 00             	movzbl (%rax),%eax
  800420377a:	0f b6 c0             	movzbl %al,%eax
  800420377d:	48 c1 e0 18          	shl    $0x18,%rax
  8004203781:	48 09 d0             	or     %rdx,%rax
  8004203784:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  8004203788:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420378c:	48 83 c0 03          	add    $0x3,%rax
  8004203790:	0f b6 00             	movzbl (%rax),%eax
  8004203793:	0f b6 c0             	movzbl %al,%eax
  8004203796:	48 c1 e0 20          	shl    $0x20,%rax
  800420379a:	48 89 c2             	mov    %rax,%rdx
  800420379d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037a1:	48 83 c0 02          	add    $0x2,%rax
  80042037a5:	0f b6 00             	movzbl (%rax),%eax
  80042037a8:	0f b6 c0             	movzbl %al,%eax
  80042037ab:	48 c1 e0 28          	shl    $0x28,%rax
  80042037af:	48 09 d0             	or     %rdx,%rax
  80042037b2:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  80042037b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037ba:	48 83 c0 01          	add    $0x1,%rax
  80042037be:	0f b6 00             	movzbl (%rax),%eax
  80042037c1:	0f b6 c0             	movzbl %al,%eax
  80042037c4:	48 c1 e0 30          	shl    $0x30,%rax
  80042037c8:	48 89 c2             	mov    %rax,%rdx
  80042037cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037cf:	0f b6 00             	movzbl (%rax),%eax
  80042037d2:	0f b6 c0             	movzbl %al,%eax
  80042037d5:	48 c1 e0 38          	shl    $0x38,%rax
  80042037d9:	48 09 d0             	or     %rdx,%rax
  80042037dc:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042037e0:	eb 07                	jmp    80042037e9 <_dwarf_read_msb+0x196>
	default:
		return (0);
  80042037e2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042037e7:	eb 1a                	jmp    8004203803 <_dwarf_read_msb+0x1b0>
	}

	*offsetp += bytes_to_read;
  80042037e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042037ed:	48 8b 10             	mov    (%rax),%rdx
  80042037f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042037f3:	48 98                	cltq   
  80042037f5:	48 01 c2             	add    %rax,%rdx
  80042037f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042037fc:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042037ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203803:	c9                   	leaveq 
  8004203804:	c3                   	retq   

0000008004203805 <_dwarf_decode_msb>:

uint64_t
_dwarf_decode_msb(uint8_t **data, int bytes_to_read)
{
  8004203805:	55                   	push   %rbp
  8004203806:	48 89 e5             	mov    %rsp,%rbp
  8004203809:	48 83 ec 1c          	sub    $0x1c,%rsp
  800420380d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203811:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  8004203814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203818:	48 8b 00             	mov    (%rax),%rax
  800420381b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  800420381f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203826:	00 
	switch (bytes_to_read) {
  8004203827:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420382a:	83 f8 02             	cmp    $0x2,%eax
  800420382d:	74 35                	je     8004203864 <_dwarf_decode_msb+0x5f>
  800420382f:	83 f8 02             	cmp    $0x2,%eax
  8004203832:	7f 0a                	jg     800420383e <_dwarf_decode_msb+0x39>
  8004203834:	83 f8 01             	cmp    $0x1,%eax
  8004203837:	74 18                	je     8004203851 <_dwarf_decode_msb+0x4c>
  8004203839:	e9 53 01 00 00       	jmpq   8004203991 <_dwarf_decode_msb+0x18c>
  800420383e:	83 f8 04             	cmp    $0x4,%eax
  8004203841:	74 49                	je     800420388c <_dwarf_decode_msb+0x87>
  8004203843:	83 f8 08             	cmp    $0x8,%eax
  8004203846:	0f 84 96 00 00 00    	je     80042038e2 <_dwarf_decode_msb+0xdd>
  800420384c:	e9 40 01 00 00       	jmpq   8004203991 <_dwarf_decode_msb+0x18c>
	case 1:
		ret = src[0];
  8004203851:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203855:	0f b6 00             	movzbl (%rax),%eax
  8004203858:	0f b6 c0             	movzbl %al,%eax
  800420385b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  800420385f:	e9 34 01 00 00       	jmpq   8004203998 <_dwarf_decode_msb+0x193>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  8004203864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203868:	48 83 c0 01          	add    $0x1,%rax
  800420386c:	0f b6 00             	movzbl (%rax),%eax
  800420386f:	0f b6 d0             	movzbl %al,%edx
  8004203872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203876:	0f b6 00             	movzbl (%rax),%eax
  8004203879:	0f b6 c0             	movzbl %al,%eax
  800420387c:	48 c1 e0 08          	shl    $0x8,%rax
  8004203880:	48 09 d0             	or     %rdx,%rax
  8004203883:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004203887:	e9 0c 01 00 00       	jmpq   8004203998 <_dwarf_decode_msb+0x193>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  800420388c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203890:	48 83 c0 03          	add    $0x3,%rax
  8004203894:	0f b6 00             	movzbl (%rax),%eax
  8004203897:	0f b6 c0             	movzbl %al,%eax
  800420389a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420389e:	48 83 c2 02          	add    $0x2,%rdx
  80042038a2:	0f b6 12             	movzbl (%rdx),%edx
  80042038a5:	0f b6 d2             	movzbl %dl,%edx
  80042038a8:	48 c1 e2 08          	shl    $0x8,%rdx
  80042038ac:	48 09 d0             	or     %rdx,%rax
  80042038af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  80042038b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038b7:	48 83 c0 01          	add    $0x1,%rax
  80042038bb:	0f b6 00             	movzbl (%rax),%eax
  80042038be:	0f b6 c0             	movzbl %al,%eax
  80042038c1:	48 c1 e0 10          	shl    $0x10,%rax
  80042038c5:	48 89 c2             	mov    %rax,%rdx
  80042038c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038cc:	0f b6 00             	movzbl (%rax),%eax
  80042038cf:	0f b6 c0             	movzbl %al,%eax
  80042038d2:	48 c1 e0 18          	shl    $0x18,%rax
  80042038d6:	48 09 d0             	or     %rdx,%rax
  80042038d9:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042038dd:	e9 b6 00 00 00       	jmpq   8004203998 <_dwarf_decode_msb+0x193>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  80042038e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038e6:	48 83 c0 07          	add    $0x7,%rax
  80042038ea:	0f b6 00             	movzbl (%rax),%eax
  80042038ed:	0f b6 c0             	movzbl %al,%eax
  80042038f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042038f4:	48 83 c2 06          	add    $0x6,%rdx
  80042038f8:	0f b6 12             	movzbl (%rdx),%edx
  80042038fb:	0f b6 d2             	movzbl %dl,%edx
  80042038fe:	48 c1 e2 08          	shl    $0x8,%rdx
  8004203902:	48 09 d0             	or     %rdx,%rax
  8004203905:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  8004203909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420390d:	48 83 c0 05          	add    $0x5,%rax
  8004203911:	0f b6 00             	movzbl (%rax),%eax
  8004203914:	0f b6 c0             	movzbl %al,%eax
  8004203917:	48 c1 e0 10          	shl    $0x10,%rax
  800420391b:	48 89 c2             	mov    %rax,%rdx
  800420391e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203922:	48 83 c0 04          	add    $0x4,%rax
  8004203926:	0f b6 00             	movzbl (%rax),%eax
  8004203929:	0f b6 c0             	movzbl %al,%eax
  800420392c:	48 c1 e0 18          	shl    $0x18,%rax
  8004203930:	48 09 d0             	or     %rdx,%rax
  8004203933:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  8004203937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420393b:	48 83 c0 03          	add    $0x3,%rax
  800420393f:	0f b6 00             	movzbl (%rax),%eax
  8004203942:	0f b6 c0             	movzbl %al,%eax
  8004203945:	48 c1 e0 20          	shl    $0x20,%rax
  8004203949:	48 89 c2             	mov    %rax,%rdx
  800420394c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203950:	48 83 c0 02          	add    $0x2,%rax
  8004203954:	0f b6 00             	movzbl (%rax),%eax
  8004203957:	0f b6 c0             	movzbl %al,%eax
  800420395a:	48 c1 e0 28          	shl    $0x28,%rax
  800420395e:	48 09 d0             	or     %rdx,%rax
  8004203961:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  8004203965:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203969:	48 83 c0 01          	add    $0x1,%rax
  800420396d:	0f b6 00             	movzbl (%rax),%eax
  8004203970:	0f b6 c0             	movzbl %al,%eax
  8004203973:	48 c1 e0 30          	shl    $0x30,%rax
  8004203977:	48 89 c2             	mov    %rax,%rdx
  800420397a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420397e:	0f b6 00             	movzbl (%rax),%eax
  8004203981:	0f b6 c0             	movzbl %al,%eax
  8004203984:	48 c1 e0 38          	shl    $0x38,%rax
  8004203988:	48 09 d0             	or     %rdx,%rax
  800420398b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420398f:	eb 07                	jmp    8004203998 <_dwarf_decode_msb+0x193>
	default:
		return (0);
  8004203991:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203996:	eb 1a                	jmp    80042039b2 <_dwarf_decode_msb+0x1ad>
		break;
	}

	*data += bytes_to_read;
  8004203998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420399c:	48 8b 10             	mov    (%rax),%rdx
  800420399f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042039a2:	48 98                	cltq   
  80042039a4:	48 01 c2             	add    %rax,%rdx
  80042039a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042039ab:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042039ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042039b2:	c9                   	leaveq 
  80042039b3:	c3                   	retq   

00000080042039b4 <_dwarf_read_sleb128>:

int64_t
_dwarf_read_sleb128(uint8_t *data, uint64_t *offsetp)
{
  80042039b4:	55                   	push   %rbp
  80042039b5:	48 89 e5             	mov    %rsp,%rbp
  80042039b8:	48 83 ec 30          	sub    $0x30,%rsp
  80042039bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042039c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int64_t ret = 0;
  80042039c4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042039cb:	00 
	uint8_t b;
	int shift = 0;
  80042039cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  80042039d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042039d7:	48 8b 10             	mov    (%rax),%rdx
  80042039da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042039de:	48 01 d0             	add    %rdx,%rax
  80042039e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  80042039e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042039e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042039ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80042039f1:	0f b6 00             	movzbl (%rax),%eax
  80042039f4:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  80042039f7:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  80042039fb:	83 e0 7f             	and    $0x7f,%eax
  80042039fe:	89 c2                	mov    %eax,%edx
  8004203a00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203a03:	89 c1                	mov    %eax,%ecx
  8004203a05:	d3 e2                	shl    %cl,%edx
  8004203a07:	89 d0                	mov    %edx,%eax
  8004203a09:	48 98                	cltq   
  8004203a0b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004203a0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203a13:	48 8b 00             	mov    (%rax),%rax
  8004203a16:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203a1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203a1e:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004203a21:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203a25:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203a29:	84 c0                	test   %al,%al
  8004203a2b:	78 b8                	js     80042039e5 <_dwarf_read_sleb128+0x31>

	if (shift < 32 && (b & 0x40) != 0)
  8004203a2d:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004203a31:	7f 1f                	jg     8004203a52 <_dwarf_read_sleb128+0x9e>
  8004203a33:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203a37:	83 e0 40             	and    $0x40,%eax
  8004203a3a:	85 c0                	test   %eax,%eax
  8004203a3c:	74 14                	je     8004203a52 <_dwarf_read_sleb128+0x9e>
		ret |= (-1 << shift);
  8004203a3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203a41:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004203a46:	89 c1                	mov    %eax,%ecx
  8004203a48:	d3 e2                	shl    %cl,%edx
  8004203a4a:	89 d0                	mov    %edx,%eax
  8004203a4c:	48 98                	cltq   
  8004203a4e:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	return (ret);
  8004203a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203a56:	c9                   	leaveq 
  8004203a57:	c3                   	retq   

0000008004203a58 <_dwarf_read_uleb128>:

uint64_t
_dwarf_read_uleb128(uint8_t *data, uint64_t *offsetp)
{
  8004203a58:	55                   	push   %rbp
  8004203a59:	48 89 e5             	mov    %rsp,%rbp
  8004203a5c:	48 83 ec 30          	sub    $0x30,%rsp
  8004203a60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203a64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	uint64_t ret = 0;
  8004203a68:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203a6f:	00 
	uint8_t b;
	int shift = 0;
  8004203a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  8004203a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203a7b:	48 8b 10             	mov    (%rax),%rdx
  8004203a7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203a82:	48 01 d0             	add    %rdx,%rax
  8004203a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203a8d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203a91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203a95:	0f b6 00             	movzbl (%rax),%eax
  8004203a98:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203a9b:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203a9f:	83 e0 7f             	and    $0x7f,%eax
  8004203aa2:	89 c2                	mov    %eax,%edx
  8004203aa4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203aa7:	89 c1                	mov    %eax,%ecx
  8004203aa9:	d3 e2                	shl    %cl,%edx
  8004203aab:	89 d0                	mov    %edx,%eax
  8004203aad:	48 98                	cltq   
  8004203aaf:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004203ab3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203ab7:	48 8b 00             	mov    (%rax),%rax
  8004203aba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203ac2:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004203ac5:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203ac9:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203acd:	84 c0                	test   %al,%al
  8004203acf:	78 b8                	js     8004203a89 <_dwarf_read_uleb128+0x31>

	return (ret);
  8004203ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203ad5:	c9                   	leaveq 
  8004203ad6:	c3                   	retq   

0000008004203ad7 <_dwarf_decode_sleb128>:

int64_t
_dwarf_decode_sleb128(uint8_t **dp)
{
  8004203ad7:	55                   	push   %rbp
  8004203ad8:	48 89 e5             	mov    %rsp,%rbp
  8004203adb:	48 83 ec 28          	sub    $0x28,%rsp
  8004203adf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int64_t ret = 0;
  8004203ae3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203aea:	00 
	uint8_t b;
	int shift = 0;
  8004203aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004203af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203af6:	48 8b 00             	mov    (%rax),%rax
  8004203af9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203b01:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203b05:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203b09:	0f b6 00             	movzbl (%rax),%eax
  8004203b0c:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203b0f:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203b13:	83 e0 7f             	and    $0x7f,%eax
  8004203b16:	89 c2                	mov    %eax,%edx
  8004203b18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203b1b:	89 c1                	mov    %eax,%ecx
  8004203b1d:	d3 e2                	shl    %cl,%edx
  8004203b1f:	89 d0                	mov    %edx,%eax
  8004203b21:	48 98                	cltq   
  8004203b23:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004203b27:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203b2b:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203b2f:	84 c0                	test   %al,%al
  8004203b31:	78 ca                	js     8004203afd <_dwarf_decode_sleb128+0x26>

	if (shift < 32 && (b & 0x40) != 0)
  8004203b33:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004203b37:	7f 1f                	jg     8004203b58 <_dwarf_decode_sleb128+0x81>
  8004203b39:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203b3d:	83 e0 40             	and    $0x40,%eax
  8004203b40:	85 c0                	test   %eax,%eax
  8004203b42:	74 14                	je     8004203b58 <_dwarf_decode_sleb128+0x81>
		ret |= (-1 << shift);
  8004203b44:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203b47:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004203b4c:	89 c1                	mov    %eax,%ecx
  8004203b4e:	d3 e2                	shl    %cl,%edx
  8004203b50:	89 d0                	mov    %edx,%eax
  8004203b52:	48 98                	cltq   
  8004203b54:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	*dp = src;
  8004203b58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203b5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203b60:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203b67:	c9                   	leaveq 
  8004203b68:	c3                   	retq   

0000008004203b69 <_dwarf_decode_uleb128>:

uint64_t
_dwarf_decode_uleb128(uint8_t **dp)
{
  8004203b69:	55                   	push   %rbp
  8004203b6a:	48 89 e5             	mov    %rsp,%rbp
  8004203b6d:	48 83 ec 28          	sub    $0x28,%rsp
  8004203b71:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t ret = 0;
  8004203b75:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203b7c:	00 
	uint8_t b;
	int shift = 0;
  8004203b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004203b84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203b88:	48 8b 00             	mov    (%rax),%rax
  8004203b8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203b93:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203b97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203b9b:	0f b6 00             	movzbl (%rax),%eax
  8004203b9e:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203ba1:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203ba5:	83 e0 7f             	and    $0x7f,%eax
  8004203ba8:	89 c2                	mov    %eax,%edx
  8004203baa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203bad:	89 c1                	mov    %eax,%ecx
  8004203baf:	d3 e2                	shl    %cl,%edx
  8004203bb1:	89 d0                	mov    %edx,%eax
  8004203bb3:	48 98                	cltq   
  8004203bb5:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004203bb9:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203bbd:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203bc1:	84 c0                	test   %al,%al
  8004203bc3:	78 ca                	js     8004203b8f <_dwarf_decode_uleb128+0x26>

	*dp = src;
  8004203bc5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203bc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203bcd:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203bd4:	c9                   	leaveq 
  8004203bd5:	c3                   	retq   

0000008004203bd6 <_dwarf_read_string>:

#define Dwarf_Unsigned uint64_t

char *
_dwarf_read_string(void *data, Dwarf_Unsigned size, uint64_t *offsetp)
{
  8004203bd6:	55                   	push   %rbp
  8004203bd7:	48 89 e5             	mov    %rsp,%rbp
  8004203bda:	48 83 ec 28          	sub    $0x28,%rsp
  8004203bde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203be2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203be6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *ret, *src;

	ret = src = (char *) data + *offsetp;
  8004203bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203bee:	48 8b 10             	mov    (%rax),%rdx
  8004203bf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203bf5:	48 01 d0             	add    %rdx,%rax
  8004203bf8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (*src != '\0' && *offsetp < size) {
  8004203c04:	eb 17                	jmp    8004203c1d <_dwarf_read_string+0x47>
		src++;
  8004203c06:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
		(*offsetp)++;
  8004203c0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c0f:	48 8b 00             	mov    (%rax),%rax
  8004203c12:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203c16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c1a:	48 89 10             	mov    %rdx,(%rax)
{
	char *ret, *src;

	ret = src = (char *) data + *offsetp;

	while (*src != '\0' && *offsetp < size) {
  8004203c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c21:	0f b6 00             	movzbl (%rax),%eax
  8004203c24:	84 c0                	test   %al,%al
  8004203c26:	74 0d                	je     8004203c35 <_dwarf_read_string+0x5f>
  8004203c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c2c:	48 8b 00             	mov    (%rax),%rax
  8004203c2f:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203c33:	72 d1                	jb     8004203c06 <_dwarf_read_string+0x30>
		src++;
		(*offsetp)++;
	}

	if (*src == '\0' && *offsetp < size)
  8004203c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c39:	0f b6 00             	movzbl (%rax),%eax
  8004203c3c:	84 c0                	test   %al,%al
  8004203c3e:	75 1f                	jne    8004203c5f <_dwarf_read_string+0x89>
  8004203c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c44:	48 8b 00             	mov    (%rax),%rax
  8004203c47:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203c4b:	73 12                	jae    8004203c5f <_dwarf_read_string+0x89>
		(*offsetp)++;
  8004203c4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c51:	48 8b 00             	mov    (%rax),%rax
  8004203c54:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c5c:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203c63:	c9                   	leaveq 
  8004203c64:	c3                   	retq   

0000008004203c65 <_dwarf_read_block>:

uint8_t *
_dwarf_read_block(void *data, uint64_t *offsetp, uint64_t length)
{
  8004203c65:	55                   	push   %rbp
  8004203c66:	48 89 e5             	mov    %rsp,%rbp
  8004203c69:	48 83 ec 28          	sub    $0x28,%rsp
  8004203c6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203c71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203c75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	uint8_t *ret, *src;

	ret = src = (uint8_t *) data + *offsetp;
  8004203c79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203c7d:	48 8b 10             	mov    (%rax),%rdx
  8004203c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203c84:	48 01 d0             	add    %rdx,%rax
  8004203c87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	(*offsetp) += length;
  8004203c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203c97:	48 8b 10             	mov    (%rax),%rdx
  8004203c9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c9e:	48 01 c2             	add    %rax,%rdx
  8004203ca1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203ca5:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203cac:	c9                   	leaveq 
  8004203cad:	c3                   	retq   

0000008004203cae <_dwarf_elf_get_byte_order>:

Dwarf_Endianness
_dwarf_elf_get_byte_order(void *obj)
{
  8004203cae:	55                   	push   %rbp
  8004203caf:	48 89 e5             	mov    %rsp,%rbp
  8004203cb2:	48 83 ec 20          	sub    $0x20,%rsp
  8004203cb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *)obj;
  8004203cba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203cbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004203cc2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203cc7:	75 35                	jne    8004203cfe <_dwarf_elf_get_byte_order+0x50>
  8004203cc9:	48 b9 e0 9d 20 04 80 	movabs $0x8004209de0,%rcx
  8004203cd0:	00 00 00 
  8004203cd3:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004203cda:	00 00 00 
  8004203cdd:	be 29 01 00 00       	mov    $0x129,%esi
  8004203ce2:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004203ce9:	00 00 00 
  8004203cec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203cf1:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004203cf8:	00 00 00 
  8004203cfb:	41 ff d0             	callq  *%r8

//TODO: Need to check for 64bit here. Because currently Elf header for
//      64bit doesn't have any memeber e_ident. But need to see what is
//      similar in 64bit.
	switch (e->e_ident[EI_DATA]) {
  8004203cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203d02:	0f b6 40 05          	movzbl 0x5(%rax),%eax
  8004203d06:	0f b6 c0             	movzbl %al,%eax
  8004203d09:	83 f8 02             	cmp    $0x2,%eax
  8004203d0c:	75 07                	jne    8004203d15 <_dwarf_elf_get_byte_order+0x67>
	case ELFDATA2MSB:
		return (DW_OBJECT_MSB);
  8004203d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203d13:	eb 05                	jmp    8004203d1a <_dwarf_elf_get_byte_order+0x6c>

	case ELFDATA2LSB:
	case ELFDATANONE:
	default:
		return (DW_OBJECT_LSB);
  8004203d15:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
  8004203d1a:	c9                   	leaveq 
  8004203d1b:	c3                   	retq   

0000008004203d1c <_dwarf_elf_get_pointer_size>:

Dwarf_Small
_dwarf_elf_get_pointer_size(void *obj)
{
  8004203d1c:	55                   	push   %rbp
  8004203d1d:	48 89 e5             	mov    %rsp,%rbp
  8004203d20:	48 83 ec 20          	sub    $0x20,%rsp
  8004203d24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *) obj;
  8004203d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203d2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004203d30:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203d35:	75 35                	jne    8004203d6c <_dwarf_elf_get_pointer_size+0x50>
  8004203d37:	48 b9 e0 9d 20 04 80 	movabs $0x8004209de0,%rcx
  8004203d3e:	00 00 00 
  8004203d41:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004203d48:	00 00 00 
  8004203d4b:	be 3f 01 00 00       	mov    $0x13f,%esi
  8004203d50:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004203d57:	00 00 00 
  8004203d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203d5f:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004203d66:	00 00 00 
  8004203d69:	41 ff d0             	callq  *%r8

	if (e->e_ident[4] == ELFCLASS32)
  8004203d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203d70:	0f b6 40 04          	movzbl 0x4(%rax),%eax
  8004203d74:	3c 01                	cmp    $0x1,%al
  8004203d76:	75 07                	jne    8004203d7f <_dwarf_elf_get_pointer_size+0x63>
		return (4);
  8004203d78:	b8 04 00 00 00       	mov    $0x4,%eax
  8004203d7d:	eb 05                	jmp    8004203d84 <_dwarf_elf_get_pointer_size+0x68>
	else
		return (8);
  8004203d7f:	b8 08 00 00 00       	mov    $0x8,%eax
}
  8004203d84:	c9                   	leaveq 
  8004203d85:	c3                   	retq   

0000008004203d86 <_dwarf_init>:

//Return 0 on success
int _dwarf_init(Dwarf_Debug dbg, void *obj)
{
  8004203d86:	55                   	push   %rbp
  8004203d87:	48 89 e5             	mov    %rsp,%rbp
  8004203d8a:	53                   	push   %rbx
  8004203d8b:	48 83 ec 18          	sub    $0x18,%rsp
  8004203d8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203d93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	memset(dbg, 0, sizeof(struct _Dwarf_Debug));
  8004203d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203d9b:	ba 60 00 00 00       	mov    $0x60,%edx
  8004203da0:	be 00 00 00 00       	mov    $0x0,%esi
  8004203da5:	48 89 c7             	mov    %rax,%rdi
  8004203da8:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  8004203daf:	00 00 00 
  8004203db2:	ff d0                	callq  *%rax
	dbg->curr_off_dbginfo = 0;
  8004203db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203db8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	dbg->dbg_info_size = 0;
  8004203dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203dc3:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8004203dca:	00 
	dbg->dbg_pointer_size = _dwarf_elf_get_pointer_size(obj); 
  8004203dcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203dcf:	48 89 c7             	mov    %rax,%rdi
  8004203dd2:	48 b8 1c 3d 20 04 80 	movabs $0x8004203d1c,%rax
  8004203dd9:	00 00 00 
  8004203ddc:	ff d0                	callq  *%rax
  8004203dde:	0f b6 d0             	movzbl %al,%edx
  8004203de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203de5:	89 50 28             	mov    %edx,0x28(%rax)

	if (_dwarf_elf_get_byte_order(obj) == DW_OBJECT_MSB) {
  8004203de8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203dec:	48 89 c7             	mov    %rax,%rdi
  8004203def:	48 b8 ae 3c 20 04 80 	movabs $0x8004203cae,%rax
  8004203df6:	00 00 00 
  8004203df9:	ff d0                	callq  *%rax
  8004203dfb:	85 c0                	test   %eax,%eax
  8004203dfd:	75 26                	jne    8004203e25 <_dwarf_init+0x9f>
		dbg->read = _dwarf_read_msb;
  8004203dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e03:	48 b9 53 36 20 04 80 	movabs $0x8004203653,%rcx
  8004203e0a:	00 00 00 
  8004203e0d:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_msb;
  8004203e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e15:	48 bb 05 38 20 04 80 	movabs $0x8004203805,%rbx
  8004203e1c:	00 00 00 
  8004203e1f:	48 89 58 20          	mov    %rbx,0x20(%rax)
  8004203e23:	eb 24                	jmp    8004203e49 <_dwarf_init+0xc3>
	} else {
		dbg->read = _dwarf_read_lsb;
  8004203e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e29:	48 b9 06 34 20 04 80 	movabs $0x8004203406,%rcx
  8004203e30:	00 00 00 
  8004203e33:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_lsb;
  8004203e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e3b:	48 be 32 35 20 04 80 	movabs $0x8004203532,%rsi
  8004203e42:	00 00 00 
  8004203e45:	48 89 70 20          	mov    %rsi,0x20(%rax)
	}
	_dwarf_frame_params_init(dbg);
  8004203e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e4d:	48 89 c7             	mov    %rax,%rdi
  8004203e50:	48 b8 53 53 20 04 80 	movabs $0x8004205353,%rax
  8004203e57:	00 00 00 
  8004203e5a:	ff d0                	callq  *%rax
	return 0;
  8004203e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004203e61:	48 83 c4 18          	add    $0x18,%rsp
  8004203e65:	5b                   	pop    %rbx
  8004203e66:	5d                   	pop    %rbp
  8004203e67:	c3                   	retq   

0000008004203e68 <_get_next_cu>:

//Return 0 on success
int _get_next_cu(Dwarf_Debug dbg, Dwarf_CU *cu)
{
  8004203e68:	55                   	push   %rbp
  8004203e69:	48 89 e5             	mov    %rsp,%rbp
  8004203e6c:	48 83 ec 20          	sub    $0x20,%rsp
  8004203e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uint32_t length;
	uint64_t offset;
	uint8_t dwarf_size;

	if(dbg->curr_off_dbginfo > dbg->dbg_info_size)
  8004203e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e7c:	48 8b 10             	mov    (%rax),%rdx
  8004203e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e83:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004203e87:	48 39 c2             	cmp    %rax,%rdx
  8004203e8a:	76 0a                	jbe    8004203e96 <_get_next_cu+0x2e>
		return -1;
  8004203e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004203e91:	e9 6b 01 00 00       	jmpq   8004204001 <_get_next_cu+0x199>

	offset = dbg->curr_off_dbginfo;
  8004203e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e9a:	48 8b 00             	mov    (%rax),%rax
  8004203e9d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	cu->cu_offset = offset;
  8004203ea1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004203ea5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203ea9:	48 89 50 30          	mov    %rdx,0x30(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset,4);
  8004203ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203eb1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004203eb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203eb9:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004203ebd:	48 89 d1             	mov    %rdx,%rcx
  8004203ec0:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004203ec4:	ba 04 00 00 00       	mov    $0x4,%edx
  8004203ec9:	48 89 cf             	mov    %rcx,%rdi
  8004203ecc:	ff d0                	callq  *%rax
  8004203ece:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (length == 0xffffffff) {
  8004203ed1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  8004203ed5:	75 2a                	jne    8004203f01 <_get_next_cu+0x99>
		length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 8);
  8004203ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203edb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004203edf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203ee3:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004203ee7:	48 89 d1             	mov    %rdx,%rcx
  8004203eea:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004203eee:	ba 08 00 00 00       	mov    $0x8,%edx
  8004203ef3:	48 89 cf             	mov    %rcx,%rdi
  8004203ef6:	ff d0                	callq  *%rax
  8004203ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		dwarf_size = 8;
  8004203efb:	c6 45 fb 08          	movb   $0x8,-0x5(%rbp)
  8004203eff:	eb 04                	jmp    8004203f05 <_get_next_cu+0x9d>
	} else {
		dwarf_size = 4;
  8004203f01:	c6 45 fb 04          	movb   $0x4,-0x5(%rbp)
	}

	cu->cu_dwarf_size = dwarf_size;
  8004203f05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f09:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  8004203f0d:	88 50 19             	mov    %dl,0x19(%rax)
	 if (length > ds->ds_size - offset) {
	 return (DW_DLE_CU_LENGTH_ERROR);
	 }*/

	/* Compute the offset to the next compilation unit: */
	dbg->curr_off_dbginfo = offset + length;
  8004203f10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004203f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203f17:	48 01 c2             	add    %rax,%rdx
  8004203f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f1e:	48 89 10             	mov    %rdx,(%rax)
	cu->cu_next_offset   = dbg->curr_off_dbginfo;
  8004203f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f25:	48 8b 10             	mov    (%rax),%rdx
  8004203f28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f2c:	48 89 50 20          	mov    %rdx,0x20(%rax)

	/* Initialise the compilation unit. */
	cu->cu_length = (uint64_t)length;
  8004203f30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004203f33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f37:	48 89 10             	mov    %rdx,(%rax)

	cu->cu_length_size   = (dwarf_size == 4 ? 4 : 12);
  8004203f3a:	80 7d fb 04          	cmpb   $0x4,-0x5(%rbp)
  8004203f3e:	75 07                	jne    8004203f47 <_get_next_cu+0xdf>
  8004203f40:	b8 04 00 00 00       	mov    $0x4,%eax
  8004203f45:	eb 05                	jmp    8004203f4c <_get_next_cu+0xe4>
  8004203f47:	b8 0c 00 00 00       	mov    $0xc,%eax
  8004203f4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004203f50:	88 42 18             	mov    %al,0x18(%rdx)
	cu->version              = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 2);
  8004203f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f57:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004203f5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203f5f:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004203f63:	48 89 d1             	mov    %rdx,%rcx
  8004203f66:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004203f6a:	ba 02 00 00 00       	mov    $0x2,%edx
  8004203f6f:	48 89 cf             	mov    %rcx,%rdi
  8004203f72:	ff d0                	callq  *%rax
  8004203f74:	89 c2                	mov    %eax,%edx
  8004203f76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f7a:	66 89 50 08          	mov    %dx,0x8(%rax)
	cu->debug_abbrev_offset  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, dwarf_size);
  8004203f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f82:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004203f86:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  8004203f8a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004203f8e:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8004203f92:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004203f96:	48 89 cf             	mov    %rcx,%rdi
  8004203f99:	ff d0                	callq  *%rax
  8004203f9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004203f9f:	48 89 42 10          	mov    %rax,0x10(%rdx)
	//cu->cu_abbrev_offset_cur = cu->cu_abbrev_offset;
	cu->addr_size  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 1);
  8004203fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203fa7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004203fab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203faf:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004203fb3:	48 89 d1             	mov    %rdx,%rcx
  8004203fb6:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004203fba:	ba 01 00 00 00       	mov    $0x1,%edx
  8004203fbf:	48 89 cf             	mov    %rcx,%rdi
  8004203fc2:	ff d0                	callq  *%rax
  8004203fc4:	89 c2                	mov    %eax,%edx
  8004203fc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203fca:	88 50 0a             	mov    %dl,0xa(%rax)

	if (cu->version < 2 || cu->version > 4) {
  8004203fcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203fd1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004203fd5:	66 83 f8 01          	cmp    $0x1,%ax
  8004203fd9:	76 0e                	jbe    8004203fe9 <_get_next_cu+0x181>
  8004203fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203fdf:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004203fe3:	66 83 f8 04          	cmp    $0x4,%ax
  8004203fe7:	76 07                	jbe    8004203ff0 <_get_next_cu+0x188>
		return -1;
  8004203fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004203fee:	eb 11                	jmp    8004204001 <_get_next_cu+0x199>
	}

	cu->cu_die_offset = offset;
  8004203ff0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004203ff4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203ff8:	48 89 50 28          	mov    %rdx,0x28(%rax)

	return 0;
  8004203ffc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004204001:	c9                   	leaveq 
  8004204002:	c3                   	retq   

0000008004204003 <print_cu>:

void print_cu(Dwarf_CU cu)
{
  8004204003:	55                   	push   %rbp
  8004204004:	48 89 e5             	mov    %rsp,%rbp
	cprintf("%ld---%du--%d\n",cu.cu_length,cu.version,cu.addr_size);
  8004204007:	0f b6 45 1a          	movzbl 0x1a(%rbp),%eax
  800420400b:	0f b6 c8             	movzbl %al,%ecx
  800420400e:	0f b7 45 18          	movzwl 0x18(%rbp),%eax
  8004204012:	0f b7 d0             	movzwl %ax,%edx
  8004204015:	48 8b 45 10          	mov    0x10(%rbp),%rax
  8004204019:	48 89 c6             	mov    %rax,%rsi
  800420401c:	48 bf 12 9e 20 04 80 	movabs $0x8004209e12,%rdi
  8004204023:	00 00 00 
  8004204026:	b8 00 00 00 00       	mov    $0x0,%eax
  800420402b:	49 b8 09 14 20 04 80 	movabs $0x8004201409,%r8
  8004204032:	00 00 00 
  8004204035:	41 ff d0             	callq  *%r8
}
  8004204038:	5d                   	pop    %rbp
  8004204039:	c3                   	retq   

000000800420403a <_dwarf_abbrev_parse>:

//Return 0 on success
int
_dwarf_abbrev_parse(Dwarf_Debug dbg, Dwarf_CU cu, Dwarf_Unsigned *offset,
		    Dwarf_Abbrev *abp, Dwarf_Section *ds)
{
  800420403a:	55                   	push   %rbp
  800420403b:	48 89 e5             	mov    %rsp,%rbp
  800420403e:	48 83 ec 60          	sub    $0x60,%rsp
  8004204042:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8004204046:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  800420404a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  800420404e:	48 89 4d a0          	mov    %rcx,-0x60(%rbp)
	uint64_t tag;
	uint8_t children;
	uint64_t abbr_addr;
	int ret;

	assert(abp != NULL);
  8004204052:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8004204057:	75 35                	jne    800420408e <_dwarf_abbrev_parse+0x54>
  8004204059:	48 b9 21 9e 20 04 80 	movabs $0x8004209e21,%rcx
  8004204060:	00 00 00 
  8004204063:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  800420406a:	00 00 00 
  800420406d:	be a4 01 00 00       	mov    $0x1a4,%esi
  8004204072:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204079:	00 00 00 
  800420407c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204081:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204088:	00 00 00 
  800420408b:	41 ff d0             	callq  *%r8
	assert(ds != NULL);
  800420408e:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
  8004204093:	75 35                	jne    80042040ca <_dwarf_abbrev_parse+0x90>
  8004204095:	48 b9 2d 9e 20 04 80 	movabs $0x8004209e2d,%rcx
  800420409c:	00 00 00 
  800420409f:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  80042040a6:	00 00 00 
  80042040a9:	be a5 01 00 00       	mov    $0x1a5,%esi
  80042040ae:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  80042040b5:	00 00 00 
  80042040b8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042040bd:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042040c4:	00 00 00 
  80042040c7:	41 ff d0             	callq  *%r8

	if (*offset >= ds->ds_size)
  80042040ca:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042040ce:	48 8b 10             	mov    (%rax),%rdx
  80042040d1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042040d5:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042040d9:	48 39 c2             	cmp    %rax,%rdx
  80042040dc:	72 0a                	jb     80042040e8 <_dwarf_abbrev_parse+0xae>
        	return (DW_DLE_NO_ENTRY);
  80042040de:	b8 04 00 00 00       	mov    $0x4,%eax
  80042040e3:	e9 d3 01 00 00       	jmpq   80042042bb <_dwarf_abbrev_parse+0x281>

	aboff = *offset;
  80042040e8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042040ec:	48 8b 00             	mov    (%rax),%rax
  80042040ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	abbr_addr = (uint64_t)ds->ds_data; //(uint64_t)((uint8_t *)elf_base_ptr + ds->sh_offset);
  80042040f3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042040f7:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042040fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	entry = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042040ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204103:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004204107:	48 89 d6             	mov    %rdx,%rsi
  800420410a:	48 89 c7             	mov    %rax,%rdi
  800420410d:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004204114:	00 00 00 
  8004204117:	ff d0                	callq  *%rax
  8004204119:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	if (entry == 0) {
  800420411d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004204122:	75 15                	jne    8004204139 <_dwarf_abbrev_parse+0xff>
		/* Last entry. */
		//Need to make connection from below function
		abp->ab_entry = 0;
  8004204124:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204128:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		return DW_DLE_NONE;
  800420412f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204134:	e9 82 01 00 00       	jmpq   80042042bb <_dwarf_abbrev_parse+0x281>
	}

	tag = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  8004204139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420413d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004204141:	48 89 d6             	mov    %rdx,%rsi
  8004204144:	48 89 c7             	mov    %rax,%rdi
  8004204147:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  800420414e:	00 00 00 
  8004204151:	ff d0                	callq  *%rax
  8004204153:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	children = dbg->read((uint8_t *)abbr_addr, offset, 1);
  8004204157:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420415b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420415f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004204163:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004204167:	ba 01 00 00 00       	mov    $0x1,%edx
  800420416c:	48 89 cf             	mov    %rcx,%rdi
  800420416f:	ff d0                	callq  *%rax
  8004204171:	88 45 df             	mov    %al,-0x21(%rbp)

	abp->ab_entry    = entry;
  8004204174:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204178:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420417c:	48 89 10             	mov    %rdx,(%rax)
	abp->ab_tag      = tag;
  800420417f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204183:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004204187:	48 89 50 08          	mov    %rdx,0x8(%rax)
	abp->ab_children = children;
  800420418b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420418f:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8004204193:	88 50 10             	mov    %dl,0x10(%rax)
	abp->ab_offset   = aboff;
  8004204196:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420419a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420419e:	48 89 50 18          	mov    %rdx,0x18(%rax)
	abp->ab_length   = 0;    /* fill in later. */
  80042041a2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042041a6:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
  80042041ad:	00 
	abp->ab_atnum    = 0;
  80042041ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042041b2:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  80042041b9:	00 

	/* Parse attribute definitions. */
	do {
		adoff = *offset;
  80042041ba:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042041be:	48 8b 00             	mov    (%rax),%rax
  80042041c1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		attr = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042041c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042041c9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80042041cd:	48 89 d6             	mov    %rdx,%rsi
  80042041d0:	48 89 c7             	mov    %rax,%rdi
  80042041d3:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  80042041da:	00 00 00 
  80042041dd:	ff d0                	callq  *%rax
  80042041df:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
		form = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042041e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042041e7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80042041eb:	48 89 d6             	mov    %rdx,%rsi
  80042041ee:	48 89 c7             	mov    %rax,%rdi
  80042041f1:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  80042041f8:	00 00 00 
  80042041fb:	ff d0                	callq  *%rax
  80042041fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if (attr != 0)
  8004204201:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004204206:	0f 84 89 00 00 00    	je     8004204295 <_dwarf_abbrev_parse+0x25b>
		{
			/* Initialise the attribute definition structure. */
			abp->ab_attrdef[abp->ab_atnum].ad_attrib = attr;
  800420420c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204210:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004204214:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8004204218:	48 89 d0             	mov    %rdx,%rax
  800420421b:	48 01 c0             	add    %rax,%rax
  800420421e:	48 01 d0             	add    %rdx,%rax
  8004204221:	48 c1 e0 03          	shl    $0x3,%rax
  8004204225:	48 01 c8             	add    %rcx,%rax
  8004204228:	48 8d 50 30          	lea    0x30(%rax),%rdx
  800420422c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204230:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_form   = form;
  8004204233:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204237:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420423b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800420423f:	48 89 d0             	mov    %rdx,%rax
  8004204242:	48 01 c0             	add    %rax,%rax
  8004204245:	48 01 d0             	add    %rdx,%rax
  8004204248:	48 c1 e0 03          	shl    $0x3,%rax
  800420424c:	48 01 c8             	add    %rcx,%rax
  800420424f:	48 8d 50 38          	lea    0x38(%rax),%rdx
  8004204253:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204257:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_offset = adoff;
  800420425a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420425e:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004204262:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8004204266:	48 89 d0             	mov    %rdx,%rax
  8004204269:	48 01 c0             	add    %rax,%rax
  800420426c:	48 01 d0             	add    %rdx,%rax
  800420426f:	48 c1 e0 03          	shl    $0x3,%rax
  8004204273:	48 01 c8             	add    %rcx,%rax
  8004204276:	48 8d 50 40          	lea    0x40(%rax),%rdx
  800420427a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420427e:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_atnum++;
  8004204281:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204285:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004204289:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420428d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204291:	48 89 50 28          	mov    %rdx,0x28(%rax)
		}
	} while (attr != 0);
  8004204295:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420429a:	0f 85 1a ff ff ff    	jne    80042041ba <_dwarf_abbrev_parse+0x180>

	//(*abp)->ab_length = *offset - aboff;
	abp->ab_length = (uint64_t)(*offset - aboff);
  80042042a0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042042a4:	48 8b 00             	mov    (%rax),%rax
  80042042a7:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
  80042042ab:	48 89 c2             	mov    %rax,%rdx
  80042042ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042042b2:	48 89 50 20          	mov    %rdx,0x20(%rax)

	return DW_DLV_OK;
  80042042b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042042bb:	c9                   	leaveq 
  80042042bc:	c3                   	retq   

00000080042042bd <_dwarf_abbrev_find>:

//Return 0 on success
int
_dwarf_abbrev_find(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t entry, Dwarf_Abbrev *abp)
{
  80042042bd:	55                   	push   %rbp
  80042042be:	48 89 e5             	mov    %rsp,%rbp
  80042042c1:	48 83 ec 70          	sub    $0x70,%rsp
  80042042c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042042c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80042042cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	Dwarf_Section *ds;
	uint64_t offset;
	int ret;

	if (entry == 0)
  80042042d1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042042d6:	75 0a                	jne    80042042e2 <_dwarf_abbrev_find+0x25>
	{
		return (DW_DLE_NO_ENTRY);
  80042042d8:	b8 04 00 00 00       	mov    $0x4,%eax
  80042042dd:	e9 0a 01 00 00       	jmpq   80042043ec <_dwarf_abbrev_find+0x12f>
	}

	/* Load and search the abbrev table. */
	ds = _dwarf_find_section(".debug_abbrev");
  80042042e2:	48 bf 38 9e 20 04 80 	movabs $0x8004209e38,%rdi
  80042042e9:	00 00 00 
  80042042ec:	48 b8 1d 86 20 04 80 	movabs $0x800420861d,%rax
  80042042f3:	00 00 00 
  80042042f6:	ff d0                	callq  *%rax
  80042042f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(ds != NULL);
  80042042fc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004204301:	75 35                	jne    8004204338 <_dwarf_abbrev_find+0x7b>
  8004204303:	48 b9 2d 9e 20 04 80 	movabs $0x8004209e2d,%rcx
  800420430a:	00 00 00 
  800420430d:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204314:	00 00 00 
  8004204317:	be e5 01 00 00       	mov    $0x1e5,%esi
  800420431c:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204323:	00 00 00 
  8004204326:	b8 00 00 00 00       	mov    $0x0,%eax
  800420432b:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204332:	00 00 00 
  8004204335:	41 ff d0             	callq  *%r8

	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
  8004204338:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420433c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (offset < ds->ds_size) {
  8004204340:	e9 8d 00 00 00       	jmpq   80042043d2 <_dwarf_abbrev_find+0x115>
		ret = _dwarf_abbrev_parse(dbg, cu, &offset, abp, ds);
  8004204345:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004204349:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420434d:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8004204351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004204355:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8004204359:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420435d:	48 8b 7d 18          	mov    0x18(%rbp),%rdi
  8004204361:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004204366:	48 8b 7d 20          	mov    0x20(%rbp),%rdi
  800420436a:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420436f:	48 8b 7d 28          	mov    0x28(%rbp),%rdi
  8004204373:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004204378:	48 8b 7d 30          	mov    0x30(%rbp),%rdi
  800420437c:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004204381:	48 8b 7d 38          	mov    0x38(%rbp),%rdi
  8004204385:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  800420438a:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  800420438e:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  8004204393:	48 89 c7             	mov    %rax,%rdi
  8004204396:	48 b8 3a 40 20 04 80 	movabs $0x800420403a,%rax
  800420439d:	00 00 00 
  80042043a0:	ff d0                	callq  *%rax
  80042043a2:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (ret != DW_DLE_NONE)
  80042043a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80042043a9:	74 05                	je     80042043b0 <_dwarf_abbrev_find+0xf3>
			return (ret);
  80042043ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042043ae:	eb 3c                	jmp    80042043ec <_dwarf_abbrev_find+0x12f>
		if (abp->ab_entry == entry) {
  80042043b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042043b4:	48 8b 00             	mov    (%rax),%rax
  80042043b7:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80042043bb:	75 07                	jne    80042043c4 <_dwarf_abbrev_find+0x107>
			//cu->cu_abbrev_offset_cur = offset;
			return DW_DLE_NONE;
  80042043bd:	b8 00 00 00 00       	mov    $0x0,%eax
  80042043c2:	eb 28                	jmp    80042043ec <_dwarf_abbrev_find+0x12f>
		}
		if (abp->ab_entry == 0) {
  80042043c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042043c8:	48 8b 00             	mov    (%rax),%rax
  80042043cb:	48 85 c0             	test   %rax,%rax
  80042043ce:	75 02                	jne    80042043d2 <_dwarf_abbrev_find+0x115>
			//cu->cu_abbrev_offset_cur = offset;
			//cu->cu_abbrev_loaded = 1;
			break;
  80042043d0:	eb 15                	jmp    80042043e7 <_dwarf_abbrev_find+0x12a>
	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
	while (offset < ds->ds_size) {
  80042043d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042043d6:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042043da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042043de:	48 39 c2             	cmp    %rax,%rdx
  80042043e1:	0f 87 5e ff ff ff    	ja     8004204345 <_dwarf_abbrev_find+0x88>
			//cu->cu_abbrev_loaded = 1;
			break;
		}
	}

	return DW_DLE_NO_ENTRY;
  80042043e7:	b8 04 00 00 00       	mov    $0x4,%eax
}
  80042043ec:	c9                   	leaveq 
  80042043ed:	c3                   	retq   

00000080042043ee <_dwarf_attr_init>:

//Return 0 on success
int
_dwarf_attr_init(Dwarf_Debug dbg, uint64_t *offsetp, Dwarf_CU *cu, Dwarf_Die *ret_die, Dwarf_AttrDef *ad,
		 uint64_t form, int indirect)
{
  80042043ee:	55                   	push   %rbp
  80042043ef:	48 89 e5             	mov    %rsp,%rbp
  80042043f2:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80042043f9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8004204400:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8004204407:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  800420440e:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
  8004204415:	4c 89 85 48 ff ff ff 	mov    %r8,-0xb8(%rbp)
  800420441c:	4c 89 8d 40 ff ff ff 	mov    %r9,-0xc0(%rbp)
	struct _Dwarf_Attribute atref;
	Dwarf_Section *str;
	int ret;
	Dwarf_Section *ds = _dwarf_find_section(".debug_info");
  8004204423:	48 bf 46 9e 20 04 80 	movabs $0x8004209e46,%rdi
  800420442a:	00 00 00 
  800420442d:	48 b8 1d 86 20 04 80 	movabs $0x800420861d,%rax
  8004204434:	00 00 00 
  8004204437:	ff d0                	callq  *%rax
  8004204439:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	uint8_t *ds_data = (uint8_t *)ds->ds_data; //(uint8_t *)dbg->dbg_info_offset_elf;
  800420443d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204441:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004204445:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint8_t dwarf_size = cu->cu_dwarf_size;
  8004204449:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004204450:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004204454:	88 45 e7             	mov    %al,-0x19(%rbp)

	ret = DW_DLE_NONE;
  8004204457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	memset(&atref, 0, sizeof(atref));
  800420445e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8004204465:	ba 60 00 00 00       	mov    $0x60,%edx
  800420446a:	be 00 00 00 00       	mov    $0x0,%esi
  800420446f:	48 89 c7             	mov    %rax,%rdi
  8004204472:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  8004204479:	00 00 00 
  800420447c:	ff d0                	callq  *%rax
	atref.at_die = ret_die;
  800420447e:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004204485:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
	atref.at_attrib = ad->ad_attrib;
  800420448c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004204493:	48 8b 00             	mov    (%rax),%rax
  8004204496:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	atref.at_form = ad->ad_form;
  800420449a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80042044a1:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042044a5:	48 89 45 88          	mov    %rax,-0x78(%rbp)
	atref.at_indirect = indirect;
  80042044a9:	8b 45 10             	mov    0x10(%rbp),%eax
  80042044ac:	89 45 90             	mov    %eax,-0x70(%rbp)
	atref.at_ld = NULL;
  80042044af:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  80042044b6:	00 

	switch (form) {
  80042044b7:	48 83 bd 40 ff ff ff 	cmpq   $0x20,-0xc0(%rbp)
  80042044be:	20 
  80042044bf:	0f 87 82 04 00 00    	ja     8004204947 <_dwarf_attr_init+0x559>
  80042044c5:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80042044cc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042044d3:	00 
  80042044d4:	48 b8 70 9e 20 04 80 	movabs $0x8004209e70,%rax
  80042044db:	00 00 00 
  80042044de:	48 01 d0             	add    %rdx,%rax
  80042044e1:	48 8b 00             	mov    (%rax),%rax
  80042044e4:	ff e0                	jmpq   *%rax
	case DW_FORM_addr:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  80042044e6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042044ed:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042044f1:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80042044f8:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  80042044fc:	0f b6 d2             	movzbl %dl,%edx
  80042044ff:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204506:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420450a:	48 89 cf             	mov    %rcx,%rdi
  800420450d:	ff d0                	callq  *%rax
  800420450f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204513:	e9 37 04 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_block:
	case DW_FORM_exprloc:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  8004204518:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800420451f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204523:	48 89 d6             	mov    %rdx,%rsi
  8004204526:	48 89 c7             	mov    %rax,%rdi
  8004204529:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004204530:	00 00 00 
  8004204533:	ff d0                	callq  *%rax
  8004204535:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004204539:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800420453d:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004204544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204548:	48 89 ce             	mov    %rcx,%rsi
  800420454b:	48 89 c7             	mov    %rax,%rdi
  800420454e:	48 b8 65 3c 20 04 80 	movabs $0x8004203c65,%rax
  8004204555:	00 00 00 
  8004204558:	ff d0                	callq  *%rax
  800420455a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420455e:	e9 ec 03 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_block1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  8004204563:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420456a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420456e:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204575:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204579:	ba 01 00 00 00       	mov    $0x1,%edx
  800420457e:	48 89 cf             	mov    %rcx,%rdi
  8004204581:	ff d0                	callq  *%rax
  8004204583:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004204587:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800420458b:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004204592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204596:	48 89 ce             	mov    %rcx,%rsi
  8004204599:	48 89 c7             	mov    %rax,%rdi
  800420459c:	48 b8 65 3c 20 04 80 	movabs $0x8004203c65,%rax
  80042045a3:	00 00 00 
  80042045a6:	ff d0                	callq  *%rax
  80042045a8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042045ac:	e9 9e 03 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_block2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  80042045b1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042045b8:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042045bc:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042045c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042045c7:	ba 02 00 00 00       	mov    $0x2,%edx
  80042045cc:	48 89 cf             	mov    %rcx,%rdi
  80042045cf:	ff d0                	callq  *%rax
  80042045d1:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  80042045d5:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042045d9:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  80042045e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042045e4:	48 89 ce             	mov    %rcx,%rsi
  80042045e7:	48 89 c7             	mov    %rax,%rdi
  80042045ea:	48 b8 65 3c 20 04 80 	movabs $0x8004203c65,%rax
  80042045f1:	00 00 00 
  80042045f4:	ff d0                	callq  *%rax
  80042045f6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042045fa:	e9 50 03 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_block4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  80042045ff:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204606:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420460a:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204611:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204615:	ba 04 00 00 00       	mov    $0x4,%edx
  800420461a:	48 89 cf             	mov    %rcx,%rdi
  800420461d:	ff d0                	callq  *%rax
  800420461f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004204623:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204627:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  800420462e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204632:	48 89 ce             	mov    %rcx,%rsi
  8004204635:	48 89 c7             	mov    %rax,%rdi
  8004204638:	48 b8 65 3c 20 04 80 	movabs $0x8004203c65,%rax
  800420463f:	00 00 00 
  8004204642:	ff d0                	callq  *%rax
  8004204644:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  8004204648:	e9 02 03 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_data1:
	case DW_FORM_flag:
	case DW_FORM_ref1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  800420464d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204654:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204658:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800420465f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204663:	ba 01 00 00 00       	mov    $0x1,%edx
  8004204668:	48 89 cf             	mov    %rcx,%rdi
  800420466b:	ff d0                	callq  *%rax
  800420466d:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204671:	e9 d9 02 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_data2:
	case DW_FORM_ref2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  8004204676:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420467d:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204681:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204688:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420468c:	ba 02 00 00 00       	mov    $0x2,%edx
  8004204691:	48 89 cf             	mov    %rcx,%rdi
  8004204694:	ff d0                	callq  *%rax
  8004204696:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420469a:	e9 b0 02 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_data4:
	case DW_FORM_ref4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  800420469f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042046a6:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042046aa:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042046b1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042046b5:	ba 04 00 00 00       	mov    $0x4,%edx
  80042046ba:	48 89 cf             	mov    %rcx,%rdi
  80042046bd:	ff d0                	callq  *%rax
  80042046bf:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042046c3:	e9 87 02 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_data8:
	case DW_FORM_ref8:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 8);
  80042046c8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042046cf:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042046d3:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042046da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042046de:	ba 08 00 00 00       	mov    $0x8,%edx
  80042046e3:	48 89 cf             	mov    %rcx,%rdi
  80042046e6:	ff d0                	callq  *%rax
  80042046e8:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042046ec:	e9 5e 02 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_indirect:
		form = _dwarf_read_uleb128(ds_data, offsetp);
  80042046f1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042046f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042046fc:	48 89 d6             	mov    %rdx,%rsi
  80042046ff:	48 89 c7             	mov    %rax,%rdi
  8004204702:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004204709:	00 00 00 
  800420470c:	ff d0                	callq  *%rax
  800420470e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
		return (_dwarf_attr_init(dbg, offsetp, cu, ret_die, ad, form, 1));
  8004204715:	4c 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%r8
  800420471c:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  8004204723:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  800420472a:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8004204731:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204738:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420473f:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  8004204746:	4d 89 c1             	mov    %r8,%r9
  8004204749:	49 89 f8             	mov    %rdi,%r8
  800420474c:	48 89 c7             	mov    %rax,%rdi
  800420474f:	48 b8 ee 43 20 04 80 	movabs $0x80042043ee,%rax
  8004204756:	00 00 00 
  8004204759:	ff d0                	callq  *%rax
  800420475b:	e9 1d 03 00 00       	jmpq   8004204a7d <_dwarf_attr_init+0x68f>
	case DW_FORM_ref_addr:
		if (cu->version == 2)
  8004204760:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004204767:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420476b:	66 83 f8 02          	cmp    $0x2,%ax
  800420476f:	75 2f                	jne    80042047a0 <_dwarf_attr_init+0x3b2>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  8004204771:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204778:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420477c:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8004204783:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  8004204787:	0f b6 d2             	movzbl %dl,%edx
  800420478a:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204791:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204795:	48 89 cf             	mov    %rcx,%rdi
  8004204798:	ff d0                	callq  *%rax
  800420479a:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  800420479e:	eb 39                	jmp    80042047d9 <_dwarf_attr_init+0x3eb>
		else if (cu->version == 3)
  80042047a0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80042047a7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042047ab:	66 83 f8 03          	cmp    $0x3,%ax
  80042047af:	75 28                	jne    80042047d9 <_dwarf_attr_init+0x3eb>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  80042047b1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042047b8:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042047bc:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  80042047c0:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042047c7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042047cb:	48 89 cf             	mov    %rcx,%rdi
  80042047ce:	ff d0                	callq  *%rax
  80042047d0:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042047d4:	e9 76 01 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
  80042047d9:	e9 71 01 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_ref_udata:
	case DW_FORM_udata:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  80042047de:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042047e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042047e9:	48 89 d6             	mov    %rdx,%rsi
  80042047ec:	48 89 c7             	mov    %rax,%rdi
  80042047ef:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  80042047f6:	00 00 00 
  80042047f9:	ff d0                	callq  *%rax
  80042047fb:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042047ff:	e9 4b 01 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_sdata:
		atref.u[0].s64 = _dwarf_read_sleb128(ds_data, offsetp);
  8004204804:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800420480b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420480f:	48 89 d6             	mov    %rdx,%rsi
  8004204812:	48 89 c7             	mov    %rax,%rdi
  8004204815:	48 b8 b4 39 20 04 80 	movabs $0x80042039b4,%rax
  800420481c:	00 00 00 
  800420481f:	ff d0                	callq  *%rax
  8004204821:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204825:	e9 25 01 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_sec_offset:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  800420482a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204831:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204835:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  8004204839:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204840:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204844:	48 89 cf             	mov    %rcx,%rdi
  8004204847:	ff d0                	callq  *%rax
  8004204849:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420484d:	e9 fd 00 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_string:
		atref.u[0].s =(char*) _dwarf_read_string(ds_data, (uint64_t)ds->ds_size, offsetp);
  8004204852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204856:	48 8b 48 18          	mov    0x18(%rax),%rcx
  800420485a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004204861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204865:	48 89 ce             	mov    %rcx,%rsi
  8004204868:	48 89 c7             	mov    %rax,%rdi
  800420486b:	48 b8 d6 3b 20 04 80 	movabs $0x8004203bd6,%rax
  8004204872:	00 00 00 
  8004204875:	ff d0                	callq  *%rax
  8004204877:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420487b:	e9 cf 00 00 00       	jmpq   800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_strp:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  8004204880:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204887:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420488b:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  800420488f:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204896:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420489a:	48 89 cf             	mov    %rcx,%rdi
  800420489d:	ff d0                	callq  *%rax
  800420489f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		str = _dwarf_find_section(".debug_str");
  80042048a3:	48 bf 52 9e 20 04 80 	movabs $0x8004209e52,%rdi
  80042048aa:	00 00 00 
  80042048ad:	48 b8 1d 86 20 04 80 	movabs $0x800420861d,%rax
  80042048b4:	00 00 00 
  80042048b7:	ff d0                	callq  *%rax
  80042048b9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		assert(str != NULL);
  80042048bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80042048c2:	75 35                	jne    80042048f9 <_dwarf_attr_init+0x50b>
  80042048c4:	48 b9 5d 9e 20 04 80 	movabs $0x8004209e5d,%rcx
  80042048cb:	00 00 00 
  80042048ce:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  80042048d5:	00 00 00 
  80042048d8:	be 51 02 00 00       	mov    $0x251,%esi
  80042048dd:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  80042048e4:	00 00 00 
  80042048e7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042048ec:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042048f3:	00 00 00 
  80042048f6:	41 ff d0             	callq  *%r8
		//atref.u[1].s = (char *)(elf_base_ptr + str->sh_offset) + atref.u[0].u64;
		atref.u[1].s = (char *)str->ds_data + atref.u[0].u64;
  80042048f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042048fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004204901:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004204905:	48 01 d0             	add    %rdx,%rax
  8004204908:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420490c:	eb 41                	jmp    800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_ref_sig8:
		atref.u[0].u64 = 8;
  800420490e:	48 c7 45 98 08 00 00 	movq   $0x8,-0x68(%rbp)
  8004204915:	00 
		atref.u[1].u8p = (uint8_t*)(_dwarf_read_block(ds_data, offsetp, atref.u[0].u64));
  8004204916:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800420491a:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004204921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204925:	48 89 ce             	mov    %rcx,%rsi
  8004204928:	48 89 c7             	mov    %rax,%rdi
  800420492b:	48 b8 65 3c 20 04 80 	movabs $0x8004203c65,%rax
  8004204932:	00 00 00 
  8004204935:	ff d0                	callq  *%rax
  8004204937:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420493b:	eb 12                	jmp    800420494f <_dwarf_attr_init+0x561>
	case DW_FORM_flag_present:
		/* This form has no value encoded in the DIE. */
		atref.u[0].u64 = 1;
  800420493d:	48 c7 45 98 01 00 00 	movq   $0x1,-0x68(%rbp)
  8004204944:	00 
		break;
  8004204945:	eb 08                	jmp    800420494f <_dwarf_attr_init+0x561>
	default:
		//DWARF_SET_ERROR(dbg, error, DW_DLE_ATTR_FORM_BAD);
		ret = DW_DLE_ATTR_FORM_BAD;
  8004204947:	c7 45 fc 0e 00 00 00 	movl   $0xe,-0x4(%rbp)
		break;
  800420494e:	90                   	nop
	}

	if (ret == DW_DLE_NONE) {
  800420494f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204953:	0f 85 21 01 00 00    	jne    8004204a7a <_dwarf_attr_init+0x68c>
		if (form == DW_FORM_block || form == DW_FORM_block1 ||
  8004204959:	48 83 bd 40 ff ff ff 	cmpq   $0x9,-0xc0(%rbp)
  8004204960:	09 
  8004204961:	74 1e                	je     8004204981 <_dwarf_attr_init+0x593>
  8004204963:	48 83 bd 40 ff ff ff 	cmpq   $0xa,-0xc0(%rbp)
  800420496a:	0a 
  800420496b:	74 14                	je     8004204981 <_dwarf_attr_init+0x593>
  800420496d:	48 83 bd 40 ff ff ff 	cmpq   $0x3,-0xc0(%rbp)
  8004204974:	03 
  8004204975:	74 0a                	je     8004204981 <_dwarf_attr_init+0x593>
		    form == DW_FORM_block2 || form == DW_FORM_block4) {
  8004204977:	48 83 bd 40 ff ff ff 	cmpq   $0x4,-0xc0(%rbp)
  800420497e:	04 
  800420497f:	75 10                	jne    8004204991 <_dwarf_attr_init+0x5a3>
			atref.at_block.bl_len = atref.u[0].u64;
  8004204981:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004204985:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			atref.at_block.bl_data = atref.u[1].u8p;
  8004204989:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420498d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
  8004204991:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004204995:	48 83 f8 03          	cmp    $0x3,%rax
  8004204999:	75 39                	jne    80042049d4 <_dwarf_attr_init+0x5e6>
			switch (atref.at_form) {
  800420499b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420499f:	48 83 f8 08          	cmp    $0x8,%rax
  80042049a3:	74 1c                	je     80042049c1 <_dwarf_attr_init+0x5d3>
  80042049a5:	48 83 f8 0e          	cmp    $0xe,%rax
  80042049a9:	74 02                	je     80042049ad <_dwarf_attr_init+0x5bf>
				break;
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
				break;
			default:
				break;
  80042049ab:	eb 27                	jmp    80042049d4 <_dwarf_attr_init+0x5e6>
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
			switch (atref.at_form) {
			case DW_FORM_strp:
				ret_die->die_name = atref.u[1].s;
  80042049ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042049b1:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80042049b8:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  80042049bf:	eb 13                	jmp    80042049d4 <_dwarf_attr_init+0x5e6>
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
  80042049c1:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042049c5:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80042049cc:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  80042049d3:	90                   	nop
			default:
				break;
			}
		}
		ret_die->die_attr[ret_die->die_attr_count++] = atref;
  80042049d4:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80042049db:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  80042049e2:	8d 48 01             	lea    0x1(%rax),%ecx
  80042049e5:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  80042049ec:	88 8a 58 03 00 00    	mov    %cl,0x358(%rdx)
  80042049f2:	0f b6 c0             	movzbl %al,%eax
  80042049f5:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  80042049fc:	48 63 d0             	movslq %eax,%rdx
  80042049ff:	48 89 d0             	mov    %rdx,%rax
  8004204a02:	48 01 c0             	add    %rax,%rax
  8004204a05:	48 01 d0             	add    %rdx,%rax
  8004204a08:	48 c1 e0 05          	shl    $0x5,%rax
  8004204a0c:	48 01 c8             	add    %rcx,%rax
  8004204a0f:	48 05 70 03 00 00    	add    $0x370,%rax
  8004204a15:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  8004204a1c:	48 89 10             	mov    %rdx,(%rax)
  8004204a1f:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004204a26:	48 89 50 08          	mov    %rdx,0x8(%rax)
  8004204a2a:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004204a2e:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004204a32:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  8004204a36:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004204a3a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004204a3e:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004204a42:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204a46:	48 89 50 28          	mov    %rdx,0x28(%rax)
  8004204a4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004204a4e:	48 89 50 30          	mov    %rdx,0x30(%rax)
  8004204a52:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004204a56:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004204a5a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004204a5e:	48 89 50 40          	mov    %rdx,0x40(%rax)
  8004204a62:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004204a66:	48 89 50 48          	mov    %rdx,0x48(%rax)
  8004204a6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004204a6e:	48 89 50 50          	mov    %rdx,0x50(%rax)
  8004204a72:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004204a76:	48 89 50 58          	mov    %rdx,0x58(%rax)
	}

	return (ret);
  8004204a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004204a7d:	c9                   	leaveq 
  8004204a7e:	c3                   	retq   

0000008004204a7f <dwarf_search_die_within_cu>:

int
dwarf_search_die_within_cu(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t offset, Dwarf_Die *ret_die, int search_sibling)
{
  8004204a7f:	55                   	push   %rbp
  8004204a80:	48 89 e5             	mov    %rsp,%rbp
  8004204a83:	48 81 ec d0 03 00 00 	sub    $0x3d0,%rsp
  8004204a8a:	48 89 bd 88 fc ff ff 	mov    %rdi,-0x378(%rbp)
  8004204a91:	48 89 b5 80 fc ff ff 	mov    %rsi,-0x380(%rbp)
  8004204a98:	48 89 95 78 fc ff ff 	mov    %rdx,-0x388(%rbp)
  8004204a9f:	89 8d 74 fc ff ff    	mov    %ecx,-0x38c(%rbp)
	uint64_t abnum;
	uint64_t die_offset;
	int ret, level;
	int i;

	assert(dbg);
  8004204aa5:	48 83 bd 88 fc ff ff 	cmpq   $0x0,-0x378(%rbp)
  8004204aac:	00 
  8004204aad:	75 35                	jne    8004204ae4 <dwarf_search_die_within_cu+0x65>
  8004204aaf:	48 b9 78 9f 20 04 80 	movabs $0x8004209f78,%rcx
  8004204ab6:	00 00 00 
  8004204ab9:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204ac0:	00 00 00 
  8004204ac3:	be 86 02 00 00       	mov    $0x286,%esi
  8004204ac8:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204acf:	00 00 00 
  8004204ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204ad7:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204ade:	00 00 00 
  8004204ae1:	41 ff d0             	callq  *%r8
	//assert(cu);
	assert(ret_die);
  8004204ae4:	48 83 bd 78 fc ff ff 	cmpq   $0x0,-0x388(%rbp)
  8004204aeb:	00 
  8004204aec:	75 35                	jne    8004204b23 <dwarf_search_die_within_cu+0xa4>
  8004204aee:	48 b9 7c 9f 20 04 80 	movabs $0x8004209f7c,%rcx
  8004204af5:	00 00 00 
  8004204af8:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204aff:	00 00 00 
  8004204b02:	be 88 02 00 00       	mov    $0x288,%esi
  8004204b07:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204b0e:	00 00 00 
  8004204b11:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204b16:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204b1d:	00 00 00 
  8004204b20:	41 ff d0             	callq  *%r8

	level = 1;
  8004204b23:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004204b2a:	e9 17 02 00 00       	jmpq   8004204d46 <dwarf_search_die_within_cu+0x2c7>

		die_offset = offset;
  8004204b2f:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204b36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		abnum = _dwarf_read_uleb128((uint8_t *)dbg->dbg_info_offset_elf, &offset);
  8004204b3a:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204b41:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004204b45:	48 8d 95 80 fc ff ff 	lea    -0x380(%rbp),%rdx
  8004204b4c:	48 89 d6             	mov    %rdx,%rsi
  8004204b4f:	48 89 c7             	mov    %rax,%rdi
  8004204b52:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004204b59:	00 00 00 
  8004204b5c:	ff d0                	callq  *%rax
  8004204b5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

		if (abnum == 0) {
  8004204b62:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004204b67:	75 22                	jne    8004204b8b <dwarf_search_die_within_cu+0x10c>
			if (level == 0 || !search_sibling) {
  8004204b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204b6d:	74 09                	je     8004204b78 <dwarf_search_die_within_cu+0xf9>
  8004204b6f:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004204b76:	75 0a                	jne    8004204b82 <dwarf_search_die_within_cu+0x103>
				//No more entry
				return (DW_DLE_NO_ENTRY);
  8004204b78:	b8 04 00 00 00       	mov    $0x4,%eax
  8004204b7d:	e9 f4 01 00 00       	jmpq   8004204d76 <dwarf_search_die_within_cu+0x2f7>
			}
			/*
			 * Return to previous DIE level.
			 */
			level--;
  8004204b82:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
			continue;
  8004204b86:	e9 bb 01 00 00       	jmpq   8004204d46 <dwarf_search_die_within_cu+0x2c7>
		}

		if ((ret = _dwarf_abbrev_find(dbg, cu, abnum, &ab)) != DW_DLE_NONE)
  8004204b8b:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004204b92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204b96:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204b9d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8004204ba1:	48 89 34 24          	mov    %rsi,(%rsp)
  8004204ba5:	48 8b 75 18          	mov    0x18(%rbp),%rsi
  8004204ba9:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8004204bae:	48 8b 75 20          	mov    0x20(%rbp),%rsi
  8004204bb2:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8004204bb7:	48 8b 75 28          	mov    0x28(%rbp),%rsi
  8004204bbb:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  8004204bc0:	48 8b 75 30          	mov    0x30(%rbp),%rsi
  8004204bc4:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8004204bc9:	48 8b 75 38          	mov    0x38(%rbp),%rsi
  8004204bcd:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  8004204bd2:	48 8b 75 40          	mov    0x40(%rbp),%rsi
  8004204bd6:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8004204bdb:	48 89 ce             	mov    %rcx,%rsi
  8004204bde:	48 89 c7             	mov    %rax,%rdi
  8004204be1:	48 b8 bd 42 20 04 80 	movabs $0x80042042bd,%rax
  8004204be8:	00 00 00 
  8004204beb:	ff d0                	callq  *%rax
  8004204bed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004204bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004204bf4:	74 08                	je     8004204bfe <dwarf_search_die_within_cu+0x17f>
			return (ret);
  8004204bf6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004204bf9:	e9 78 01 00 00       	jmpq   8004204d76 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_offset = die_offset;
  8004204bfe:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004204c09:	48 89 10             	mov    %rdx,(%rax)
		ret_die->die_abnum  = abnum;
  8004204c0c:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204c13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204c17:	48 89 50 10          	mov    %rdx,0x10(%rax)
		ret_die->die_ab  = ab;
  8004204c1b:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204c22:	48 8d 78 20          	lea    0x20(%rax),%rdi
  8004204c26:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004204c2d:	b8 66 00 00 00       	mov    $0x66,%eax
  8004204c32:	48 89 d6             	mov    %rdx,%rsi
  8004204c35:	48 89 c1             	mov    %rax,%rcx
  8004204c38:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
		ret_die->die_attr_count = 0;
  8004204c3b:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204c42:	c6 80 58 03 00 00 00 	movb   $0x0,0x358(%rax)
		ret_die->die_tag = ab.ab_tag;
  8004204c49:	48 8b 95 b8 fc ff ff 	mov    -0x348(%rbp),%rdx
  8004204c50:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204c57:	48 89 50 18          	mov    %rdx,0x18(%rax)
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004204c5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004204c62:	e9 8e 00 00 00       	jmpq   8004204cf5 <dwarf_search_die_within_cu+0x276>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
  8004204c67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204c6a:	48 63 d0             	movslq %eax,%rdx
  8004204c6d:	48 89 d0             	mov    %rdx,%rax
  8004204c70:	48 01 c0             	add    %rax,%rax
  8004204c73:	48 01 d0             	add    %rdx,%rax
  8004204c76:	48 c1 e0 03          	shl    $0x3,%rax
  8004204c7a:	48 01 e8             	add    %rbp,%rax
  8004204c7d:	48 2d 18 03 00 00    	sub    $0x318,%rax
  8004204c83:	48 8b 08             	mov    (%rax),%rcx
  8004204c86:	48 8d b5 b0 fc ff ff 	lea    -0x350(%rbp),%rsi
  8004204c8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204c90:	48 63 d0             	movslq %eax,%rdx
  8004204c93:	48 89 d0             	mov    %rdx,%rax
  8004204c96:	48 01 c0             	add    %rax,%rax
  8004204c99:	48 01 d0             	add    %rdx,%rax
  8004204c9c:	48 c1 e0 03          	shl    $0x3,%rax
  8004204ca0:	48 83 c0 30          	add    $0x30,%rax
  8004204ca4:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8004204ca8:	48 8b 95 78 fc ff ff 	mov    -0x388(%rbp),%rdx
  8004204caf:	48 8d b5 80 fc ff ff 	lea    -0x380(%rbp),%rsi
  8004204cb6:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204cbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  8004204cc4:	49 89 c9             	mov    %rcx,%r9
  8004204cc7:	49 89 f8             	mov    %rdi,%r8
  8004204cca:	48 89 d1             	mov    %rdx,%rcx
  8004204ccd:	48 8d 55 10          	lea    0x10(%rbp),%rdx
  8004204cd1:	48 89 c7             	mov    %rax,%rdi
  8004204cd4:	48 b8 ee 43 20 04 80 	movabs $0x80042043ee,%rax
  8004204cdb:	00 00 00 
  8004204cde:	ff d0                	callq  *%rax
  8004204ce0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004204ce3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004204ce7:	74 08                	je     8004204cf1 <dwarf_search_die_within_cu+0x272>
				return (ret);
  8004204ce9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004204cec:	e9 85 00 00 00       	jmpq   8004204d76 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_attr_count = 0;
		ret_die->die_tag = ab.ab_tag;
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004204cf1:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8004204cf5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204cf8:	48 63 d0             	movslq %eax,%rdx
  8004204cfb:	48 8b 85 d8 fc ff ff 	mov    -0x328(%rbp),%rax
  8004204d02:	48 39 c2             	cmp    %rax,%rdx
  8004204d05:	0f 82 5c ff ff ff    	jb     8004204c67 <dwarf_search_die_within_cu+0x1e8>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
				return (ret);
		}

		ret_die->die_next_off = offset;
  8004204d0b:	48 8b 95 80 fc ff ff 	mov    -0x380(%rbp),%rdx
  8004204d12:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204d19:	48 89 50 08          	mov    %rdx,0x8(%rax)
		if (search_sibling && level > 0) {
  8004204d1d:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004204d24:	74 19                	je     8004204d3f <dwarf_search_die_within_cu+0x2c0>
  8004204d26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204d2a:	7e 13                	jle    8004204d3f <dwarf_search_die_within_cu+0x2c0>
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004204d2c:	0f b6 85 c0 fc ff ff 	movzbl -0x340(%rbp),%eax
  8004204d33:	3c 01                	cmp    $0x1,%al
  8004204d35:	75 06                	jne    8004204d3d <dwarf_search_die_within_cu+0x2be>
				/* Advance to next DIE level. */
				level++;
  8004204d37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		}

		ret_die->die_next_off = offset;
		if (search_sibling && level > 0) {
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004204d3b:	eb 09                	jmp    8004204d46 <dwarf_search_die_within_cu+0x2c7>
  8004204d3d:	eb 07                	jmp    8004204d46 <dwarf_search_die_within_cu+0x2c7>
				/* Advance to next DIE level. */
				level++;
			}
		} else {
			//*ret_die = die;
			return (DW_DLE_NONE);
  8004204d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204d44:	eb 30                	jmp    8004204d76 <dwarf_search_die_within_cu+0x2f7>
	//assert(cu);
	assert(ret_die);

	level = 1;

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004204d46:	48 8b 55 30          	mov    0x30(%rbp),%rdx
  8004204d4a:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204d51:	48 39 c2             	cmp    %rax,%rdx
  8004204d54:	76 1b                	jbe    8004204d71 <dwarf_search_die_within_cu+0x2f2>
  8004204d56:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204d5d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004204d61:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204d68:	48 39 c2             	cmp    %rax,%rdx
  8004204d6b:	0f 87 be fd ff ff    	ja     8004204b2f <dwarf_search_die_within_cu+0xb0>
			//*ret_die = die;
			return (DW_DLE_NONE);
		}
	}

	return (DW_DLE_NO_ENTRY);
  8004204d71:	b8 04 00 00 00       	mov    $0x4,%eax
}
  8004204d76:	c9                   	leaveq 
  8004204d77:	c3                   	retq   

0000008004204d78 <dwarf_offdie>:

//Return 0 on success
int
dwarf_offdie(Dwarf_Debug dbg, uint64_t offset, Dwarf_Die *ret_die, Dwarf_CU cu)
{
  8004204d78:	55                   	push   %rbp
  8004204d79:	48 89 e5             	mov    %rsp,%rbp
  8004204d7c:	48 83 ec 60          	sub    $0x60,%rsp
  8004204d80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004204d84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004204d88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int ret;

	assert(dbg);
  8004204d8c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004204d91:	75 35                	jne    8004204dc8 <dwarf_offdie+0x50>
  8004204d93:	48 b9 78 9f 20 04 80 	movabs $0x8004209f78,%rcx
  8004204d9a:	00 00 00 
  8004204d9d:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204da4:	00 00 00 
  8004204da7:	be c4 02 00 00       	mov    $0x2c4,%esi
  8004204dac:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204db3:	00 00 00 
  8004204db6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204dbb:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204dc2:	00 00 00 
  8004204dc5:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004204dc8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004204dcd:	75 35                	jne    8004204e04 <dwarf_offdie+0x8c>
  8004204dcf:	48 b9 7c 9f 20 04 80 	movabs $0x8004209f7c,%rcx
  8004204dd6:	00 00 00 
  8004204dd9:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204de0:	00 00 00 
  8004204de3:	be c5 02 00 00       	mov    $0x2c5,%esi
  8004204de8:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204def:	00 00 00 
  8004204df2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204df7:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204dfe:	00 00 00 
  8004204e01:	41 ff d0             	callq  *%r8

	/* First search the current CU. */
	if (offset < cu.cu_next_offset) {
  8004204e04:	48 8b 45 30          	mov    0x30(%rbp),%rax
  8004204e08:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004204e0c:	76 66                	jbe    8004204e74 <dwarf_offdie+0xfc>
		ret = dwarf_search_die_within_cu(dbg, cu, offset, ret_die, 0);
  8004204e0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004204e12:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004204e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204e1a:	48 8b 4d 10          	mov    0x10(%rbp),%rcx
  8004204e1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  8004204e22:	48 8b 4d 18          	mov    0x18(%rbp),%rcx
  8004204e26:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8004204e2b:	48 8b 4d 20          	mov    0x20(%rbp),%rcx
  8004204e2f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8004204e34:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004204e38:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8004204e3d:	48 8b 4d 30          	mov    0x30(%rbp),%rcx
  8004204e41:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8004204e46:	48 8b 4d 38          	mov    0x38(%rbp),%rcx
  8004204e4a:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8004204e4f:	48 8b 4d 40          	mov    0x40(%rbp),%rcx
  8004204e53:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  8004204e58:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004204e5d:	48 89 c7             	mov    %rax,%rdi
  8004204e60:	48 b8 7f 4a 20 04 80 	movabs $0x8004204a7f,%rax
  8004204e67:	00 00 00 
  8004204e6a:	ff d0                	callq  *%rax
  8004204e6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		return ret;
  8004204e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004204e72:	eb 05                	jmp    8004204e79 <dwarf_offdie+0x101>
	}

	/*TODO: Search other CU*/
	return DW_DLV_OK;
  8004204e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004204e79:	c9                   	leaveq 
  8004204e7a:	c3                   	retq   

0000008004204e7b <_dwarf_attr_find>:

Dwarf_Attribute*
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
  8004204e7b:	55                   	push   %rbp
  8004204e7c:	48 89 e5             	mov    %rsp,%rbp
  8004204e7f:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004204e83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004204e87:	89 f0                	mov    %esi,%eax
  8004204e89:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Attribute *myat = NULL;
  8004204e8d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004204e94:	00 
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  8004204e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004204e9c:	eb 57                	jmp    8004204ef5 <_dwarf_attr_find+0x7a>
	{
		if (die->die_attr[i].at_attrib == attr)
  8004204e9e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204ea2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004204ea5:	48 63 d0             	movslq %eax,%rdx
  8004204ea8:	48 89 d0             	mov    %rdx,%rax
  8004204eab:	48 01 c0             	add    %rax,%rax
  8004204eae:	48 01 d0             	add    %rdx,%rax
  8004204eb1:	48 c1 e0 05          	shl    $0x5,%rax
  8004204eb5:	48 01 c8             	add    %rcx,%rax
  8004204eb8:	48 05 80 03 00 00    	add    $0x380,%rax
  8004204ebe:	48 8b 10             	mov    (%rax),%rdx
  8004204ec1:	0f b7 45 e4          	movzwl -0x1c(%rbp),%eax
  8004204ec5:	48 39 c2             	cmp    %rax,%rdx
  8004204ec8:	75 27                	jne    8004204ef1 <_dwarf_attr_find+0x76>
		{
			myat = &(die->die_attr[i]);
  8004204eca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004204ecd:	48 63 d0             	movslq %eax,%rdx
  8004204ed0:	48 89 d0             	mov    %rdx,%rax
  8004204ed3:	48 01 c0             	add    %rax,%rax
  8004204ed6:	48 01 d0             	add    %rdx,%rax
  8004204ed9:	48 c1 e0 05          	shl    $0x5,%rax
  8004204edd:	48 8d 90 70 03 00 00 	lea    0x370(%rax),%rdx
  8004204ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204ee8:	48 01 d0             	add    %rdx,%rax
  8004204eeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  8004204eef:	eb 17                	jmp    8004204f08 <_dwarf_attr_find+0x8d>
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
	Dwarf_Attribute *myat = NULL;
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  8004204ef1:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004204ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204ef9:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  8004204f00:	0f b6 c0             	movzbl %al,%eax
  8004204f03:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8004204f06:	7f 96                	jg     8004204e9e <_dwarf_attr_find+0x23>
			myat = &(die->die_attr[i]);
			break;
		}
	}

	return myat;
  8004204f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004204f0c:	c9                   	leaveq 
  8004204f0d:	c3                   	retq   

0000008004204f0e <dwarf_siblingof>:

//Return 0 on success
int
dwarf_siblingof(Dwarf_Debug dbg, Dwarf_Die *die, Dwarf_Die *ret_die,
		Dwarf_CU *cu)
{
  8004204f0e:	55                   	push   %rbp
  8004204f0f:	48 89 e5             	mov    %rsp,%rbp
  8004204f12:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  8004204f16:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004204f1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004204f1e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004204f22:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	Dwarf_Attribute *at;
	uint64_t offset;
	int ret, search_sibling;

	assert(dbg);
  8004204f26:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004204f2b:	75 35                	jne    8004204f62 <dwarf_siblingof+0x54>
  8004204f2d:	48 b9 78 9f 20 04 80 	movabs $0x8004209f78,%rcx
  8004204f34:	00 00 00 
  8004204f37:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204f3e:	00 00 00 
  8004204f41:	be ec 02 00 00       	mov    $0x2ec,%esi
  8004204f46:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204f4d:	00 00 00 
  8004204f50:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204f55:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204f5c:	00 00 00 
  8004204f5f:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004204f62:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004204f67:	75 35                	jne    8004204f9e <dwarf_siblingof+0x90>
  8004204f69:	48 b9 7c 9f 20 04 80 	movabs $0x8004209f7c,%rcx
  8004204f70:	00 00 00 
  8004204f73:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204f7a:	00 00 00 
  8004204f7d:	be ed 02 00 00       	mov    $0x2ed,%esi
  8004204f82:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204f89:	00 00 00 
  8004204f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204f91:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204f98:	00 00 00 
  8004204f9b:	41 ff d0             	callq  *%r8
	assert(cu);
  8004204f9e:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8004204fa3:	75 35                	jne    8004204fda <dwarf_siblingof+0xcc>
  8004204fa5:	48 b9 84 9f 20 04 80 	movabs $0x8004209f84,%rcx
  8004204fac:	00 00 00 
  8004204faf:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004204fb6:	00 00 00 
  8004204fb9:	be ee 02 00 00       	mov    $0x2ee,%esi
  8004204fbe:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004204fc5:	00 00 00 
  8004204fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204fcd:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204fd4:	00 00 00 
  8004204fd7:	41 ff d0             	callq  *%r8

	/* Application requests the first DIE in this CU. */
	if (die == NULL)
  8004204fda:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004204fdf:	75 65                	jne    8004205046 <dwarf_siblingof+0x138>
		return (dwarf_offdie(dbg, cu->cu_die_offset, ret_die, *cu));
  8004204fe1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204fe5:	48 8b 70 28          	mov    0x28(%rax),%rsi
  8004204fe9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004204fed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004204ff1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204ff5:	48 8b 38             	mov    (%rax),%rdi
  8004204ff8:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004204ffc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8004205000:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004205005:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004205009:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420500e:	48 8b 78 18          	mov    0x18(%rax),%rdi
  8004205012:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004205017:	48 8b 78 20          	mov    0x20(%rax),%rdi
  800420501b:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004205020:	48 8b 78 28          	mov    0x28(%rax),%rdi
  8004205024:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004205029:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420502d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8004205032:	48 89 cf             	mov    %rcx,%rdi
  8004205035:	48 b8 78 4d 20 04 80 	movabs $0x8004204d78,%rax
  800420503c:	00 00 00 
  800420503f:	ff d0                	callq  *%rax
  8004205041:	e9 0a 01 00 00       	jmpq   8004205150 <dwarf_siblingof+0x242>

	/*
	 * If the DIE doesn't have any children, its sibling sits next
	 * right to it.
	 */
	search_sibling = 0;
  8004205046:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	if (die->die_ab.ab_children == DW_CHILDREN_no)
  800420504d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205051:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  8004205055:	84 c0                	test   %al,%al
  8004205057:	75 0e                	jne    8004205067 <dwarf_siblingof+0x159>
		offset = die->die_next_off;
  8004205059:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420505d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004205061:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004205065:	eb 6b                	jmp    80042050d2 <dwarf_siblingof+0x1c4>
	else {
		/*
		 * Look for DW_AT_sibling attribute for the offset of
		 * its sibling.
		 */
		if ((at = _dwarf_attr_find(die, DW_AT_sibling)) != NULL) {
  8004205067:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420506b:	be 01 00 00 00       	mov    $0x1,%esi
  8004205070:	48 89 c7             	mov    %rax,%rdi
  8004205073:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  800420507a:	00 00 00 
  800420507d:	ff d0                	callq  *%rax
  800420507f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8004205083:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004205088:	74 35                	je     80042050bf <dwarf_siblingof+0x1b1>
			if (at->at_form != DW_FORM_ref_addr)
  800420508a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420508e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004205092:	48 83 f8 10          	cmp    $0x10,%rax
  8004205096:	74 19                	je     80042050b1 <dwarf_siblingof+0x1a3>
				offset = at->u[0].u64 + cu->cu_offset;
  8004205098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420509c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042050a0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042050a4:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042050a8:	48 01 d0             	add    %rdx,%rax
  80042050ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042050af:	eb 21                	jmp    80042050d2 <dwarf_siblingof+0x1c4>
			else
				offset = at->u[0].u64;
  80042050b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042050b5:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042050b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042050bd:	eb 13                	jmp    80042050d2 <dwarf_siblingof+0x1c4>
		} else {
			offset = die->die_next_off;
  80042050bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042050c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042050c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			search_sibling = 1;
  80042050cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
		}
	}

	ret = dwarf_search_die_within_cu(dbg, *cu, offset, ret_die, search_sibling);
  80042050d2:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80042050d5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042050d9:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80042050dd:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80042050e1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042050e5:	4c 8b 00             	mov    (%rax),%r8
  80042050e8:	4c 89 04 24          	mov    %r8,(%rsp)
  80042050ec:	4c 8b 40 08          	mov    0x8(%rax),%r8
  80042050f0:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  80042050f5:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80042050f9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  80042050fe:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8004205102:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  8004205107:	4c 8b 40 20          	mov    0x20(%rax),%r8
  800420510b:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  8004205110:	4c 8b 40 28          	mov    0x28(%rax),%r8
  8004205114:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  8004205119:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420511d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8004205122:	48 b8 7f 4a 20 04 80 	movabs $0x8004204a7f,%rax
  8004205129:	00 00 00 
  800420512c:	ff d0                	callq  *%rax
  800420512e:	89 45 e4             	mov    %eax,-0x1c(%rbp)


	if (ret == DW_DLE_NO_ENTRY) {
  8004205131:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8004205135:	75 07                	jne    800420513e <dwarf_siblingof+0x230>
		return (DW_DLV_NO_ENTRY);
  8004205137:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420513c:	eb 12                	jmp    8004205150 <dwarf_siblingof+0x242>
	} else if (ret != DW_DLE_NONE)
  800420513e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004205142:	74 07                	je     800420514b <dwarf_siblingof+0x23d>
		return (DW_DLV_ERROR);
  8004205144:	b8 01 00 00 00       	mov    $0x1,%eax
  8004205149:	eb 05                	jmp    8004205150 <dwarf_siblingof+0x242>


	return (DW_DLV_OK);
  800420514b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004205150:	c9                   	leaveq 
  8004205151:	c3                   	retq   

0000008004205152 <dwarf_child>:

int
dwarf_child(Dwarf_Debug dbg, Dwarf_CU *cu, Dwarf_Die *die, Dwarf_Die *ret_die)
{
  8004205152:	55                   	push   %rbp
  8004205153:	48 89 e5             	mov    %rsp,%rbp
  8004205156:	48 83 ec 70          	sub    $0x70,%rsp
  800420515a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420515e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004205162:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004205166:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	int ret;

	assert(die);
  800420516a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800420516f:	75 35                	jne    80042051a6 <dwarf_child+0x54>
  8004205171:	48 b9 87 9f 20 04 80 	movabs $0x8004209f87,%rcx
  8004205178:	00 00 00 
  800420517b:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004205182:	00 00 00 
  8004205185:	be 1c 03 00 00       	mov    $0x31c,%esi
  800420518a:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004205191:	00 00 00 
  8004205194:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205199:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042051a0:	00 00 00 
  80042051a3:	41 ff d0             	callq  *%r8
	assert(ret_die);
  80042051a6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042051ab:	75 35                	jne    80042051e2 <dwarf_child+0x90>
  80042051ad:	48 b9 7c 9f 20 04 80 	movabs $0x8004209f7c,%rcx
  80042051b4:	00 00 00 
  80042051b7:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  80042051be:	00 00 00 
  80042051c1:	be 1d 03 00 00       	mov    $0x31d,%esi
  80042051c6:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  80042051cd:	00 00 00 
  80042051d0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042051d5:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042051dc:	00 00 00 
  80042051df:	41 ff d0             	callq  *%r8
	assert(dbg);
  80042051e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042051e7:	75 35                	jne    800420521e <dwarf_child+0xcc>
  80042051e9:	48 b9 78 9f 20 04 80 	movabs $0x8004209f78,%rcx
  80042051f0:	00 00 00 
  80042051f3:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  80042051fa:	00 00 00 
  80042051fd:	be 1e 03 00 00       	mov    $0x31e,%esi
  8004205202:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004205209:	00 00 00 
  800420520c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205211:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205218:	00 00 00 
  800420521b:	41 ff d0             	callq  *%r8
	assert(cu);
  800420521e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004205223:	75 35                	jne    800420525a <dwarf_child+0x108>
  8004205225:	48 b9 84 9f 20 04 80 	movabs $0x8004209f84,%rcx
  800420522c:	00 00 00 
  800420522f:	48 ba ea 9d 20 04 80 	movabs $0x8004209dea,%rdx
  8004205236:	00 00 00 
  8004205239:	be 1f 03 00 00       	mov    $0x31f,%esi
  800420523e:	48 bf ff 9d 20 04 80 	movabs $0x8004209dff,%rdi
  8004205245:	00 00 00 
  8004205248:	b8 00 00 00 00       	mov    $0x0,%eax
  800420524d:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205254:	00 00 00 
  8004205257:	41 ff d0             	callq  *%r8

	if (die->die_ab.ab_children == DW_CHILDREN_no)
  800420525a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420525e:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  8004205262:	84 c0                	test   %al,%al
  8004205264:	75 0a                	jne    8004205270 <dwarf_child+0x11e>
		return (DW_DLE_NO_ENTRY);
  8004205266:	b8 04 00 00 00       	mov    $0x4,%eax
  800420526b:	e9 84 00 00 00       	jmpq   80042052f4 <dwarf_child+0x1a2>

	ret = dwarf_search_die_within_cu(dbg, *cu, die->die_next_off, ret_die, 0);
  8004205270:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004205274:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8004205278:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420527c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8004205280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004205284:	48 8b 08             	mov    (%rax),%rcx
  8004205287:	48 89 0c 24          	mov    %rcx,(%rsp)
  800420528b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420528f:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8004205294:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8004205298:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  800420529d:	48 8b 48 18          	mov    0x18(%rax),%rcx
  80042052a1:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  80042052a6:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042052aa:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  80042052af:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80042052b3:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  80042052b8:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042052bc:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80042052c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  80042052c6:	48 b8 7f 4a 20 04 80 	movabs $0x8004204a7f,%rax
  80042052cd:	00 00 00 
  80042052d0:	ff d0                	callq  *%rax
  80042052d2:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (ret == DW_DLE_NO_ENTRY) {
  80042052d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80042052d9:	75 07                	jne    80042052e2 <dwarf_child+0x190>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  80042052db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042052e0:	eb 12                	jmp    80042052f4 <dwarf_child+0x1a2>
	} else if (ret != DW_DLE_NONE)
  80042052e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80042052e6:	74 07                	je     80042052ef <dwarf_child+0x19d>
		return (DW_DLV_ERROR);
  80042052e8:	b8 01 00 00 00       	mov    $0x1,%eax
  80042052ed:	eb 05                	jmp    80042052f4 <dwarf_child+0x1a2>

	return (DW_DLV_OK);
  80042052ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042052f4:	c9                   	leaveq 
  80042052f5:	c3                   	retq   

00000080042052f6 <_dwarf_find_section_enhanced>:


int  _dwarf_find_section_enhanced(Dwarf_Section *ds)
{
  80042052f6:	55                   	push   %rbp
  80042052f7:	48 89 e5             	mov    %rsp,%rbp
  80042052fa:	48 83 ec 20          	sub    $0x20,%rsp
  80042052fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *secthdr = _dwarf_find_section(ds->ds_name);
  8004205302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205306:	48 8b 00             	mov    (%rax),%rax
  8004205309:	48 89 c7             	mov    %rax,%rdi
  800420530c:	48 b8 1d 86 20 04 80 	movabs $0x800420861d,%rax
  8004205313:	00 00 00 
  8004205316:	ff d0                	callq  *%rax
  8004205318:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	ds->ds_data = secthdr->ds_data;//(Dwarf_Small*)((uint8_t *)elf_base_ptr + secthdr->sh_offset);
  800420531c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205320:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004205324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205328:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ds->ds_addr = secthdr->ds_addr;
  800420532c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205330:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004205334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205338:	48 89 50 10          	mov    %rdx,0x10(%rax)
	ds->ds_size = secthdr->ds_size;
  800420533c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205340:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004205344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205348:	48 89 50 18          	mov    %rdx,0x18(%rax)
	return 0;
  800420534c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004205351:	c9                   	leaveq 
  8004205352:	c3                   	retq   

0000008004205353 <_dwarf_frame_params_init>:

extern int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

void
_dwarf_frame_params_init(Dwarf_Debug dbg)
{
  8004205353:	55                   	push   %rbp
  8004205354:	48 89 e5             	mov    %rsp,%rbp
  8004205357:	48 83 ec 08          	sub    $0x8,%rsp
  800420535b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	/* Initialise call frame related parameters. */
	dbg->dbg_frame_rule_table_size = DW_FRAME_LAST_REG_NUM;
  800420535f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205363:	66 c7 40 48 42 00    	movw   $0x42,0x48(%rax)
	dbg->dbg_frame_rule_initial_value = DW_FRAME_REG_INITIAL_VALUE;
  8004205369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420536d:	66 c7 40 4a 0b 04    	movw   $0x40b,0x4a(%rax)
	dbg->dbg_frame_cfa_value = DW_FRAME_CFA_COL3;
  8004205373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205377:	66 c7 40 4c 9c 05    	movw   $0x59c,0x4c(%rax)
	dbg->dbg_frame_same_value = DW_FRAME_SAME_VAL;
  800420537d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205381:	66 c7 40 4e 0b 04    	movw   $0x40b,0x4e(%rax)
	dbg->dbg_frame_undefined_value = DW_FRAME_UNDEFINED_VAL;
  8004205387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420538b:	66 c7 40 50 0a 04    	movw   $0x40a,0x50(%rax)
}
  8004205391:	c9                   	leaveq 
  8004205392:	c3                   	retq   

0000008004205393 <dwarf_get_fde_at_pc>:

int
dwarf_get_fde_at_pc(Dwarf_Debug dbg, Dwarf_Addr pc,
		    struct _Dwarf_Fde *ret_fde, Dwarf_Cie cie,
		    Dwarf_Error *error)
{
  8004205393:	55                   	push   %rbp
  8004205394:	48 89 e5             	mov    %rsp,%rbp
  8004205397:	48 83 ec 40          	sub    $0x40,%rsp
  800420539b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420539f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042053a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042053a7:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80042053ab:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	Dwarf_Fde fde = ret_fde;
  80042053af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042053b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memset(fde, 0, sizeof(struct _Dwarf_Fde));
  80042053b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042053bb:	ba 80 00 00 00       	mov    $0x80,%edx
  80042053c0:	be 00 00 00 00       	mov    $0x0,%esi
  80042053c5:	48 89 c7             	mov    %rax,%rdi
  80042053c8:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  80042053cf:	00 00 00 
  80042053d2:	ff d0                	callq  *%rax
	fde->fde_cie = cie;
  80042053d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042053d8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042053dc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if (ret_fde == NULL)
  80042053e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80042053e5:	75 07                	jne    80042053ee <dwarf_get_fde_at_pc+0x5b>
		return (DW_DLV_ERROR);
  80042053e7:	b8 01 00 00 00       	mov    $0x1,%eax
  80042053ec:	eb 75                	jmp    8004205463 <dwarf_get_fde_at_pc+0xd0>

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  80042053ee:	eb 59                	jmp    8004205449 <dwarf_get_fde_at_pc+0xb6>
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
  80042053f0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80042053f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042053f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042053fc:	be 01 00 00 00       	mov    $0x1,%esi
  8004205401:	48 89 c7             	mov    %rax,%rdi
  8004205404:	48 b8 a8 75 20 04 80 	movabs $0x80042075a8,%rax
  800420540b:	00 00 00 
  800420540e:	ff d0                	callq  *%rax
  8004205410:	85 c0                	test   %eax,%eax
  8004205412:	79 07                	jns    800420541b <dwarf_get_fde_at_pc+0x88>
		{
			return DW_DLV_NO_ENTRY;
  8004205414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004205419:	eb 48                	jmp    8004205463 <dwarf_get_fde_at_pc+0xd0>
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  800420541b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420541f:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004205423:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004205427:	77 20                	ja     8004205449 <dwarf_get_fde_at_pc+0xb6>
  8004205429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420542d:	48 8b 50 30          	mov    0x30(%rax),%rdx
		    fde->fde_adrange)
  8004205431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205435:	48 8b 40 38          	mov    0x38(%rax),%rax
	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
		{
			return DW_DLV_NO_ENTRY;
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  8004205439:	48 01 d0             	add    %rdx,%rax
  800420543c:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004205440:	76 07                	jbe    8004205449 <dwarf_get_fde_at_pc+0xb6>
		    fde->fde_adrange)
			return (DW_DLV_OK);
  8004205442:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205447:	eb 1a                	jmp    8004205463 <dwarf_get_fde_at_pc+0xd0>
	fde->fde_cie = cie;
	
	if (ret_fde == NULL)
		return (DW_DLV_ERROR);

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  8004205449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420544d:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004205451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205455:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004205459:	48 39 c2             	cmp    %rax,%rdx
  800420545c:	72 92                	jb     80042053f0 <dwarf_get_fde_at_pc+0x5d>
		    fde->fde_adrange)
			return (DW_DLV_OK);
	}

	DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
	return (DW_DLV_NO_ENTRY);
  800420545e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8004205463:	c9                   	leaveq 
  8004205464:	c3                   	retq   

0000008004205465 <_dwarf_frame_regtable_copy>:

int
_dwarf_frame_regtable_copy(Dwarf_Debug dbg, Dwarf_Regtable3 **dest,
			   Dwarf_Regtable3 *src, Dwarf_Error *error)
{
  8004205465:	55                   	push   %rbp
  8004205466:	48 89 e5             	mov    %rsp,%rbp
  8004205469:	53                   	push   %rbx
  800420546a:	48 83 ec 38          	sub    $0x38,%rsp
  800420546e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004205472:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004205476:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800420547a:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	int i;

	assert(dest != NULL);
  800420547e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004205483:	75 35                	jne    80042054ba <_dwarf_frame_regtable_copy+0x55>
  8004205485:	48 b9 9a 9f 20 04 80 	movabs $0x8004209f9a,%rcx
  800420548c:	00 00 00 
  800420548f:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  8004205496:	00 00 00 
  8004205499:	be 57 00 00 00       	mov    $0x57,%esi
  800420549e:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  80042054a5:	00 00 00 
  80042054a8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042054ad:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042054b4:	00 00 00 
  80042054b7:	41 ff d0             	callq  *%r8
	assert(src != NULL);
  80042054ba:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042054bf:	75 35                	jne    80042054f6 <_dwarf_frame_regtable_copy+0x91>
  80042054c1:	48 b9 d2 9f 20 04 80 	movabs $0x8004209fd2,%rcx
  80042054c8:	00 00 00 
  80042054cb:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  80042054d2:	00 00 00 
  80042054d5:	be 58 00 00 00       	mov    $0x58,%esi
  80042054da:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  80042054e1:	00 00 00 
  80042054e4:	b8 00 00 00 00       	mov    $0x0,%eax
  80042054e9:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042054f0:	00 00 00 
  80042054f3:	41 ff d0             	callq  *%r8

	if (*dest == NULL) {
  80042054f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042054fa:	48 8b 00             	mov    (%rax),%rax
  80042054fd:	48 85 c0             	test   %rax,%rax
  8004205500:	75 39                	jne    800420553b <_dwarf_frame_regtable_copy+0xd6>
		*dest = &global_rt_table_shadow;
  8004205502:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205506:	48 bb 20 cd 21 04 80 	movabs $0x800421cd20,%rbx
  800420550d:	00 00 00 
  8004205510:	48 89 18             	mov    %rbx,(%rax)
		(*dest)->rt3_reg_table_size = src->rt3_reg_table_size;
  8004205513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205517:	48 8b 00             	mov    (%rax),%rax
  800420551a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420551e:	0f b7 52 18          	movzwl 0x18(%rdx),%edx
  8004205522:	66 89 50 18          	mov    %dx,0x18(%rax)
		(*dest)->rt3_rules = global_rules_shadow;
  8004205526:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420552a:	48 8b 00             	mov    (%rax),%rax
  800420552d:	48 bb c0 ce 21 04 80 	movabs $0x800421cec0,%rbx
  8004205534:	00 00 00 
  8004205537:	48 89 58 20          	mov    %rbx,0x20(%rax)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
  800420553b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420553f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205543:	48 8b 00             	mov    (%rax),%rax
  8004205546:	ba 18 00 00 00       	mov    $0x18,%edx
  800420554b:	48 89 ce             	mov    %rcx,%rsi
  800420554e:	48 89 c7             	mov    %rax,%rdi
  8004205551:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004205558:	00 00 00 
  800420555b:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420555d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8004205564:	eb 5a                	jmp    80042055c0 <_dwarf_frame_regtable_copy+0x15b>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
  8004205566:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420556a:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420556e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004205571:	48 63 d0             	movslq %eax,%rdx
  8004205574:	48 89 d0             	mov    %rdx,%rax
  8004205577:	48 01 c0             	add    %rax,%rax
  800420557a:	48 01 d0             	add    %rdx,%rax
  800420557d:	48 c1 e0 03          	shl    $0x3,%rax
  8004205581:	48 01 c1             	add    %rax,%rcx
  8004205584:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205588:	48 8b 00             	mov    (%rax),%rax
  800420558b:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420558f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004205592:	48 63 d0             	movslq %eax,%rdx
  8004205595:	48 89 d0             	mov    %rdx,%rax
  8004205598:	48 01 c0             	add    %rax,%rax
  800420559b:	48 01 d0             	add    %rdx,%rax
  800420559e:	48 c1 e0 03          	shl    $0x3,%rax
  80042055a2:	48 01 f0             	add    %rsi,%rax
  80042055a5:	ba 18 00 00 00       	mov    $0x18,%edx
  80042055aa:	48 89 ce             	mov    %rcx,%rsi
  80042055ad:	48 89 c7             	mov    %rax,%rdi
  80042055b0:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  80042055b7:	00 00 00 
  80042055ba:	ff d0                	callq  *%rax

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
  80042055bc:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  80042055c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042055c4:	48 8b 00             	mov    (%rax),%rax
  80042055c7:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042055cb:	0f b7 c0             	movzwl %ax,%eax
  80042055ce:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80042055d1:	7e 10                	jle    80042055e3 <_dwarf_frame_regtable_copy+0x17e>
		     i < src->rt3_reg_table_size; i++)
  80042055d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042055d7:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042055db:	0f b7 c0             	movzwl %ax,%eax
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  80042055de:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80042055e1:	7f 83                	jg     8004205566 <_dwarf_frame_regtable_copy+0x101>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  80042055e3:	eb 32                	jmp    8004205617 <_dwarf_frame_regtable_copy+0x1b2>
		(*dest)->rt3_rules[i].dw_regnum =
  80042055e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042055e9:	48 8b 00             	mov    (%rax),%rax
  80042055ec:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042055f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042055f3:	48 63 d0             	movslq %eax,%rdx
  80042055f6:	48 89 d0             	mov    %rdx,%rax
  80042055f9:	48 01 c0             	add    %rax,%rax
  80042055fc:	48 01 d0             	add    %rdx,%rax
  80042055ff:	48 c1 e0 03          	shl    $0x3,%rax
  8004205603:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
			dbg->dbg_frame_undefined_value;
  8004205607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420560b:	0f b7 40 50          	movzwl 0x50(%rax),%eax
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
		(*dest)->rt3_rules[i].dw_regnum =
  800420560f:	66 89 42 02          	mov    %ax,0x2(%rdx)
	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  8004205613:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8004205617:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420561b:	48 8b 00             	mov    (%rax),%rax
  800420561e:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205622:	0f b7 c0             	movzwl %ax,%eax
  8004205625:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8004205628:	7f bb                	jg     80042055e5 <_dwarf_frame_regtable_copy+0x180>
		(*dest)->rt3_rules[i].dw_regnum =
			dbg->dbg_frame_undefined_value;

	return (DW_DLE_NONE);
  800420562a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420562f:	48 83 c4 38          	add    $0x38,%rsp
  8004205633:	5b                   	pop    %rbx
  8004205634:	5d                   	pop    %rbp
  8004205635:	c3                   	retq   

0000008004205636 <_dwarf_frame_run_inst>:

static int
_dwarf_frame_run_inst(Dwarf_Debug dbg, Dwarf_Regtable3 *rt, uint8_t *insts,
		      Dwarf_Unsigned len, Dwarf_Unsigned caf, Dwarf_Signed daf, Dwarf_Addr pc,
		      Dwarf_Addr pc_req, Dwarf_Addr *row_pc, Dwarf_Error *error)
{
  8004205636:	55                   	push   %rbp
  8004205637:	48 89 e5             	mov    %rsp,%rbp
  800420563a:	53                   	push   %rbx
  800420563b:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  8004205642:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  8004205646:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  800420564a:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
  800420564e:	48 89 4d 80          	mov    %rcx,-0x80(%rbp)
  8004205652:	4c 89 85 78 ff ff ff 	mov    %r8,-0x88(%rbp)
  8004205659:	4c 89 8d 70 ff ff ff 	mov    %r9,-0x90(%rbp)
			ret = DW_DLE_DF_REG_NUM_TOO_HIGH;               \
			goto program_done;                              \
		}                                                       \
	} while(0)

	ret = DW_DLE_NONE;
  8004205660:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	init_rt = saved_rt = NULL;
  8004205667:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  800420566e:	00 
  800420566f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004205673:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	*row_pc = pc;
  8004205677:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420567b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420567f:	48 89 10             	mov    %rdx,(%rax)

	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
  8004205682:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004205686:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  800420568a:	48 8d 75 b0          	lea    -0x50(%rbp),%rsi
  800420568e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205692:	48 89 c7             	mov    %rax,%rdi
  8004205695:	48 b8 65 54 20 04 80 	movabs $0x8004205465,%rax
  800420569c:	00 00 00 
  800420569f:	ff d0                	callq  *%rax
	p = insts;
  80042056a1:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80042056a5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	pe = p + len;
  80042056a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042056ad:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  80042056b1:	48 01 d0             	add    %rdx,%rax
  80042056b4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	while (p < pe) {
  80042056b8:	e9 3a 0d 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		if (*p == DW_CFA_nop) {
  80042056bd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042056c1:	0f b6 00             	movzbl (%rax),%eax
  80042056c4:	84 c0                	test   %al,%al
  80042056c6:	75 11                	jne    80042056d9 <_dwarf_frame_run_inst+0xa3>
			p++;
  80042056c8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042056cc:	48 83 c0 01          	add    $0x1,%rax
  80042056d0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			continue;
  80042056d4:	e9 1e 0d 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		}

		high2 = *p & 0xc0;
  80042056d9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042056dd:	0f b6 00             	movzbl (%rax),%eax
  80042056e0:	83 e0 c0             	and    $0xffffffc0,%eax
  80042056e3:	88 45 df             	mov    %al,-0x21(%rbp)
		low6 = *p & 0x3f;
  80042056e6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042056ea:	0f b6 00             	movzbl (%rax),%eax
  80042056ed:	83 e0 3f             	and    $0x3f,%eax
  80042056f0:	88 45 de             	mov    %al,-0x22(%rbp)
		p++;
  80042056f3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042056f7:	48 83 c0 01          	add    $0x1,%rax
  80042056fb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)

		if (high2 > 0) {
  80042056ff:	80 7d df 00          	cmpb   $0x0,-0x21(%rbp)
  8004205703:	0f 84 a1 01 00 00    	je     80042058aa <_dwarf_frame_run_inst+0x274>
			switch (high2) {
  8004205709:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800420570d:	3d 80 00 00 00       	cmp    $0x80,%eax
  8004205712:	74 38                	je     800420574c <_dwarf_frame_run_inst+0x116>
  8004205714:	3d c0 00 00 00       	cmp    $0xc0,%eax
  8004205719:	0f 84 01 01 00 00    	je     8004205820 <_dwarf_frame_run_inst+0x1ea>
  800420571f:	83 f8 40             	cmp    $0x40,%eax
  8004205722:	0f 85 71 01 00 00    	jne    8004205899 <_dwarf_frame_run_inst+0x263>
			case DW_CFA_advance_loc:
			        pc += low6 * caf;
  8004205728:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  800420572c:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205733:	ff 
  8004205734:	48 01 45 10          	add    %rax,0x10(%rbp)
			        if (pc_req < pc)
  8004205738:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420573c:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205740:	73 05                	jae    8004205747 <_dwarf_frame_run_inst+0x111>
			                goto program_done;
  8004205742:	e9 be 0c 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			        break;
  8004205747:	e9 59 01 00 00       	jmpq   80042058a5 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_offset:
			        *row_pc = pc;
  800420574c:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205750:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205754:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  8004205757:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420575b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420575f:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205763:	66 39 c2             	cmp    %ax,%dx
  8004205766:	72 0c                	jb     8004205774 <_dwarf_frame_run_inst+0x13e>
  8004205768:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420576f:	e9 91 0c 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			        RL[low6].dw_offset_relevant = 1;
  8004205774:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205778:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420577c:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205780:	48 89 d0             	mov    %rdx,%rax
  8004205783:	48 01 c0             	add    %rax,%rax
  8004205786:	48 01 d0             	add    %rdx,%rax
  8004205789:	48 c1 e0 03          	shl    $0x3,%rax
  800420578d:	48 01 c8             	add    %rcx,%rax
  8004205790:	c6 00 01             	movb   $0x1,(%rax)
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
  8004205793:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205797:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420579b:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420579f:	48 89 d0             	mov    %rdx,%rax
  80042057a2:	48 01 c0             	add    %rax,%rax
  80042057a5:	48 01 d0             	add    %rdx,%rax
  80042057a8:	48 c1 e0 03          	shl    $0x3,%rax
  80042057ac:	48 01 c8             	add    %rcx,%rax
  80042057af:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
  80042057b3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042057b7:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042057bb:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  80042057bf:	48 89 d0             	mov    %rdx,%rax
  80042057c2:	48 01 c0             	add    %rax,%rax
  80042057c5:	48 01 d0             	add    %rdx,%rax
  80042057c8:	48 c1 e0 03          	shl    $0x3,%rax
  80042057cc:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042057d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042057d4:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  80042057d8:	66 89 42 02          	mov    %ax,0x2(%rdx)
			        RL[low6].dw_offset_or_block_len =
  80042057dc:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042057e0:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042057e4:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  80042057e8:	48 89 d0             	mov    %rdx,%rax
  80042057eb:	48 01 c0             	add    %rax,%rax
  80042057ee:	48 01 d0             	add    %rdx,%rax
  80042057f1:	48 c1 e0 03          	shl    $0x3,%rax
  80042057f5:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
					_dwarf_decode_uleb128(&p) * daf;
  80042057f9:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042057fd:	48 89 c7             	mov    %rax,%rdi
  8004205800:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205807:	00 00 00 
  800420580a:	ff d0                	callq  *%rax
  800420580c:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  8004205813:	48 0f af c2          	imul   %rdx,%rax
			        *row_pc = pc;
			        CHECK_TABLE_SIZE(low6);
			        RL[low6].dw_offset_relevant = 1;
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
			        RL[low6].dw_offset_or_block_len =
  8004205817:	48 89 43 08          	mov    %rax,0x8(%rbx)
					_dwarf_decode_uleb128(&p) * daf;
			        break;
  800420581b:	e9 85 00 00 00       	jmpq   80042058a5 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_restore:
			        *row_pc = pc;
  8004205820:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205824:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205828:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  800420582b:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420582f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205833:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205837:	66 39 c2             	cmp    %ax,%dx
  800420583a:	72 0c                	jb     8004205848 <_dwarf_frame_run_inst+0x212>
  800420583c:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205843:	e9 bd 0b 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			        memcpy(&RL[low6], &INITRL[low6],
  8004205848:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420584c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205850:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205854:	48 89 d0             	mov    %rdx,%rax
  8004205857:	48 01 c0             	add    %rax,%rax
  800420585a:	48 01 d0             	add    %rdx,%rax
  800420585d:	48 c1 e0 03          	shl    $0x3,%rax
  8004205861:	48 01 c1             	add    %rax,%rcx
  8004205864:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205868:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420586c:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205870:	48 89 d0             	mov    %rdx,%rax
  8004205873:	48 01 c0             	add    %rax,%rax
  8004205876:	48 01 d0             	add    %rdx,%rax
  8004205879:	48 c1 e0 03          	shl    $0x3,%rax
  800420587d:	48 01 f0             	add    %rsi,%rax
  8004205880:	ba 18 00 00 00       	mov    $0x18,%edx
  8004205885:	48 89 ce             	mov    %rcx,%rsi
  8004205888:	48 89 c7             	mov    %rax,%rdi
  800420588b:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004205892:	00 00 00 
  8004205895:	ff d0                	callq  *%rax
				       sizeof(Dwarf_Regtable_Entry3));
			        break;
  8004205897:	eb 0c                	jmp    80042058a5 <_dwarf_frame_run_inst+0x26f>
			default:
			        DWARF_SET_ERROR(dbg, error,
						DW_DLE_FRAME_INSTR_EXEC_ERROR);
			        ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  8004205899:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			        goto program_done;
  80042058a0:	e9 60 0b 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			}

			continue;
  80042058a5:	e9 4d 0b 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		}

		switch (low6) {
  80042058aa:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  80042058ae:	83 f8 16             	cmp    $0x16,%eax
  80042058b1:	0f 87 37 0b 00 00    	ja     80042063ee <_dwarf_frame_run_inst+0xdb8>
  80042058b7:	89 c0                	mov    %eax,%eax
  80042058b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042058c0:	00 
  80042058c1:	48 b8 e0 9f 20 04 80 	movabs $0x8004209fe0,%rax
  80042058c8:	00 00 00 
  80042058cb:	48 01 d0             	add    %rdx,%rax
  80042058ce:	48 8b 00             	mov    (%rax),%rax
  80042058d1:	ff e0                	jmpq   *%rax
		case DW_CFA_set_loc:
			pc = dbg->decode(&p, dbg->dbg_pointer_size);
  80042058d3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042058d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042058db:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042058df:	8b 4a 28             	mov    0x28(%rdx),%ecx
  80042058e2:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  80042058e6:	89 ce                	mov    %ecx,%esi
  80042058e8:	48 89 d7             	mov    %rdx,%rdi
  80042058eb:	ff d0                	callq  *%rax
  80042058ed:	48 89 45 10          	mov    %rax,0x10(%rbp)
			if (pc_req < pc)
  80042058f1:	48 8b 45 18          	mov    0x18(%rbp),%rax
  80042058f5:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  80042058f9:	73 05                	jae    8004205900 <_dwarf_frame_run_inst+0x2ca>
			        goto program_done;
  80042058fb:	e9 05 0b 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205900:	e9 f2 0a 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc1:
			pc += dbg->decode(&p, 1) * caf;
  8004205905:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205909:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420590d:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205911:	be 01 00 00 00       	mov    $0x1,%esi
  8004205916:	48 89 d7             	mov    %rdx,%rdi
  8004205919:	ff d0                	callq  *%rax
  800420591b:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205922:	ff 
  8004205923:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205927:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420592b:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420592f:	73 05                	jae    8004205936 <_dwarf_frame_run_inst+0x300>
			        goto program_done;
  8004205931:	e9 cf 0a 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205936:	e9 bc 0a 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc2:
			pc += dbg->decode(&p, 2) * caf;
  800420593b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420593f:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205943:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205947:	be 02 00 00 00       	mov    $0x2,%esi
  800420594c:	48 89 d7             	mov    %rdx,%rdi
  800420594f:	ff d0                	callq  *%rax
  8004205951:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205958:	ff 
  8004205959:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  800420595d:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205961:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205965:	73 05                	jae    800420596c <_dwarf_frame_run_inst+0x336>
			        goto program_done;
  8004205967:	e9 99 0a 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			break;
  800420596c:	e9 86 0a 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc4:
			pc += dbg->decode(&p, 4) * caf;
  8004205971:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205975:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205979:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  800420597d:	be 04 00 00 00       	mov    $0x4,%esi
  8004205982:	48 89 d7             	mov    %rdx,%rdi
  8004205985:	ff d0                	callq  *%rax
  8004205987:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  800420598e:	ff 
  800420598f:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205993:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205997:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420599b:	73 05                	jae    80042059a2 <_dwarf_frame_run_inst+0x36c>
			        goto program_done;
  800420599d:	e9 63 0a 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			break;
  80042059a2:	e9 50 0a 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended:
			*row_pc = pc;
  80042059a7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042059ab:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042059af:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  80042059b2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042059b6:	48 89 c7             	mov    %rax,%rdi
  80042059b9:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  80042059c0:	00 00 00 
  80042059c3:	ff d0                	callq  *%rax
  80042059c5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  80042059c9:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042059cd:	48 89 c7             	mov    %rax,%rdi
  80042059d0:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  80042059d7:	00 00 00 
  80042059da:	ff d0                	callq  *%rax
  80042059dc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  80042059e0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042059e4:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042059e8:	0f b7 c0             	movzwl %ax,%eax
  80042059eb:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80042059ef:	77 0c                	ja     80042059fd <_dwarf_frame_run_inst+0x3c7>
  80042059f1:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  80042059f8:	e9 08 0a 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  80042059fd:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205a01:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205a05:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205a09:	48 89 d0             	mov    %rdx,%rax
  8004205a0c:	48 01 c0             	add    %rax,%rax
  8004205a0f:	48 01 d0             	add    %rdx,%rax
  8004205a12:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a16:	48 01 c8             	add    %rcx,%rax
  8004205a19:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  8004205a1c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205a20:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205a24:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205a28:	48 89 d0             	mov    %rdx,%rax
  8004205a2b:	48 01 c0             	add    %rax,%rax
  8004205a2e:	48 01 d0             	add    %rdx,%rax
  8004205a31:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a35:	48 01 c8             	add    %rcx,%rax
  8004205a38:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  8004205a3c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205a40:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205a44:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205a48:	48 89 d0             	mov    %rdx,%rax
  8004205a4b:	48 01 c0             	add    %rax,%rax
  8004205a4e:	48 01 d0             	add    %rdx,%rax
  8004205a51:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a55:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205a59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205a5d:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004205a61:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  8004205a65:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205a69:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205a6d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205a71:	48 89 d0             	mov    %rdx,%rax
  8004205a74:	48 01 c0             	add    %rax,%rax
  8004205a77:	48 01 d0             	add    %rdx,%rax
  8004205a7a:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a7e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205a82:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004205a89:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  8004205a8e:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  8004205a92:	e9 60 09 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_extended:
			*row_pc = pc;
  8004205a97:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205a9b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205a9f:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205aa2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205aa6:	48 89 c7             	mov    %rax,%rdi
  8004205aa9:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205ab0:	00 00 00 
  8004205ab3:	ff d0                	callq  *%rax
  8004205ab5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205ab9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205abd:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205ac1:	0f b7 c0             	movzwl %ax,%eax
  8004205ac4:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205ac8:	77 0c                	ja     8004205ad6 <_dwarf_frame_run_inst+0x4a0>
  8004205aca:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205ad1:	e9 2f 09 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			memcpy(&RL[reg], &INITRL[reg],
  8004205ad6:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004205ada:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205ade:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205ae2:	48 89 d0             	mov    %rdx,%rax
  8004205ae5:	48 01 c0             	add    %rax,%rax
  8004205ae8:	48 01 d0             	add    %rdx,%rax
  8004205aeb:	48 c1 e0 03          	shl    $0x3,%rax
  8004205aef:	48 01 c1             	add    %rax,%rcx
  8004205af2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205af6:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004205afa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205afe:	48 89 d0             	mov    %rdx,%rax
  8004205b01:	48 01 c0             	add    %rax,%rax
  8004205b04:	48 01 d0             	add    %rdx,%rax
  8004205b07:	48 c1 e0 03          	shl    $0x3,%rax
  8004205b0b:	48 01 f0             	add    %rsi,%rax
  8004205b0e:	ba 18 00 00 00       	mov    $0x18,%edx
  8004205b13:	48 89 ce             	mov    %rcx,%rsi
  8004205b16:	48 89 c7             	mov    %rax,%rdi
  8004205b19:	48 b8 e8 30 20 04 80 	movabs $0x80042030e8,%rax
  8004205b20:	00 00 00 
  8004205b23:	ff d0                	callq  *%rax
			       sizeof(Dwarf_Regtable_Entry3));
			break;
  8004205b25:	e9 cd 08 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_undefined:
			*row_pc = pc;
  8004205b2a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205b2e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205b32:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205b35:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205b39:	48 89 c7             	mov    %rax,%rdi
  8004205b3c:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205b43:	00 00 00 
  8004205b46:	ff d0                	callq  *%rax
  8004205b48:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205b4c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205b50:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205b54:	0f b7 c0             	movzwl %ax,%eax
  8004205b57:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205b5b:	77 0c                	ja     8004205b69 <_dwarf_frame_run_inst+0x533>
  8004205b5d:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205b64:	e9 9c 08 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205b69:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205b6d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205b71:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205b75:	48 89 d0             	mov    %rdx,%rax
  8004205b78:	48 01 c0             	add    %rax,%rax
  8004205b7b:	48 01 d0             	add    %rdx,%rax
  8004205b7e:	48 c1 e0 03          	shl    $0x3,%rax
  8004205b82:	48 01 c8             	add    %rcx,%rax
  8004205b85:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_undefined_value;
  8004205b88:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205b8c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205b90:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205b94:	48 89 d0             	mov    %rdx,%rax
  8004205b97:	48 01 c0             	add    %rax,%rax
  8004205b9a:	48 01 d0             	add    %rdx,%rax
  8004205b9d:	48 c1 e0 03          	shl    $0x3,%rax
  8004205ba1:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205ba5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205ba9:	0f b7 40 50          	movzwl 0x50(%rax),%eax
  8004205bad:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205bb1:	e9 41 08 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_same_value:
			reg = _dwarf_decode_uleb128(&p);
  8004205bb6:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205bba:	48 89 c7             	mov    %rax,%rdi
  8004205bbd:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205bc4:	00 00 00 
  8004205bc7:	ff d0                	callq  *%rax
  8004205bc9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205bcd:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205bd1:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205bd5:	0f b7 c0             	movzwl %ax,%eax
  8004205bd8:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205bdc:	77 0c                	ja     8004205bea <_dwarf_frame_run_inst+0x5b4>
  8004205bde:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205be5:	e9 1b 08 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205bea:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205bee:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205bf2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205bf6:	48 89 d0             	mov    %rdx,%rax
  8004205bf9:	48 01 c0             	add    %rax,%rax
  8004205bfc:	48 01 d0             	add    %rdx,%rax
  8004205bff:	48 c1 e0 03          	shl    $0x3,%rax
  8004205c03:	48 01 c8             	add    %rcx,%rax
  8004205c06:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_same_value;
  8004205c09:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205c0d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205c11:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205c15:	48 89 d0             	mov    %rdx,%rax
  8004205c18:	48 01 c0             	add    %rax,%rax
  8004205c1b:	48 01 d0             	add    %rdx,%rax
  8004205c1e:	48 c1 e0 03          	shl    $0x3,%rax
  8004205c22:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205c26:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205c2a:	0f b7 40 4e          	movzwl 0x4e(%rax),%eax
  8004205c2e:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205c32:	e9 c0 07 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_register:
			*row_pc = pc;
  8004205c37:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205c3b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205c3f:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205c42:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205c46:	48 89 c7             	mov    %rax,%rdi
  8004205c49:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205c50:	00 00 00 
  8004205c53:	ff d0                	callq  *%rax
  8004205c55:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			reg2 = _dwarf_decode_uleb128(&p);
  8004205c59:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205c5d:	48 89 c7             	mov    %rax,%rdi
  8004205c60:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205c67:	00 00 00 
  8004205c6a:	ff d0                	callq  *%rax
  8004205c6c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205c70:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205c74:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205c78:	0f b7 c0             	movzwl %ax,%eax
  8004205c7b:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205c7f:	77 0c                	ja     8004205c8d <_dwarf_frame_run_inst+0x657>
  8004205c81:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205c88:	e9 78 07 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205c8d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205c91:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205c95:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205c99:	48 89 d0             	mov    %rdx,%rax
  8004205c9c:	48 01 c0             	add    %rax,%rax
  8004205c9f:	48 01 d0             	add    %rdx,%rax
  8004205ca2:	48 c1 e0 03          	shl    $0x3,%rax
  8004205ca6:	48 01 c8             	add    %rcx,%rax
  8004205ca9:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = reg2;
  8004205cac:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205cb0:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205cb4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205cb8:	48 89 d0             	mov    %rdx,%rax
  8004205cbb:	48 01 c0             	add    %rax,%rax
  8004205cbe:	48 01 d0             	add    %rdx,%rax
  8004205cc1:	48 c1 e0 03          	shl    $0x3,%rax
  8004205cc5:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205cc9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205ccd:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205cd1:	e9 21 07 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_remember_state:
			_dwarf_frame_regtable_copy(dbg, &saved_rt, rt, error);
  8004205cd6:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004205cda:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004205cde:	48 8d 75 a8          	lea    -0x58(%rbp),%rsi
  8004205ce2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205ce6:	48 89 c7             	mov    %rax,%rdi
  8004205ce9:	48 b8 65 54 20 04 80 	movabs $0x8004205465,%rax
  8004205cf0:	00 00 00 
  8004205cf3:	ff d0                	callq  *%rax
			break;
  8004205cf5:	e9 fd 06 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_state:
			*row_pc = pc;
  8004205cfa:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205cfe:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205d02:	48 89 10             	mov    %rdx,(%rax)
			_dwarf_frame_regtable_copy(dbg, &rt, saved_rt, error);
  8004205d05:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004205d09:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004205d0d:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  8004205d11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205d15:	48 89 c7             	mov    %rax,%rdi
  8004205d18:	48 b8 65 54 20 04 80 	movabs $0x8004205465,%rax
  8004205d1f:	00 00 00 
  8004205d22:	ff d0                	callq  *%rax
			break;
  8004205d24:	e9 ce 06 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa:
			*row_pc = pc;
  8004205d29:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205d2d:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205d31:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205d34:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205d38:	48 89 c7             	mov    %rax,%rdi
  8004205d3b:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205d42:	00 00 00 
  8004205d45:	ff d0                	callq  *%rax
  8004205d47:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  8004205d4b:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205d4f:	48 89 c7             	mov    %rax,%rdi
  8004205d52:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205d59:	00 00 00 
  8004205d5c:	ff d0                	callq  *%rax
  8004205d5e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  8004205d62:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d66:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004205d69:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d6d:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  8004205d71:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d75:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205d79:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = uoff;
  8004205d7d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004205d85:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004205d89:	e9 69 06 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_register:
			*row_pc = pc;
  8004205d8e:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205d92:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205d96:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205d99:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205d9d:	48 89 c7             	mov    %rax,%rdi
  8004205da0:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205da7:	00 00 00 
  8004205daa:	ff d0                	callq  *%rax
  8004205dac:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CFA.dw_regnum = reg;
  8004205db0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205db4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205db8:	66 89 50 02          	mov    %dx,0x2(%rax)
			 * Note that DW_CFA_def_cfa_register change the CFA
			 * rule register while keep the old offset. So we
			 * should not touch the CFA.dw_offset_relevant flag
			 * here.
			 */
			break;
  8004205dbc:	e9 36 06 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset:
			*row_pc = pc;
  8004205dc1:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205dc5:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205dc9:	48 89 10             	mov    %rdx,(%rax)
			uoff = _dwarf_decode_uleb128(&p);
  8004205dcc:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205dd0:	48 89 c7             	mov    %rax,%rdi
  8004205dd3:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205dda:	00 00 00 
  8004205ddd:	ff d0                	callq  *%rax
  8004205ddf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  8004205de3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205de7:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004205dea:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205dee:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = uoff;
  8004205df2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205df6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004205dfa:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004205dfe:	e9 f4 05 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_expression:
			*row_pc = pc;
  8004205e03:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205e07:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205e0b:	48 89 10             	mov    %rdx,(%rax)
			CFA.dw_offset_relevant = 0;
  8004205e0e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e12:	c6 00 00             	movb   $0x0,(%rax)
			CFA.dw_value_type = DW_EXPR_EXPRESSION;
  8004205e15:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e19:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			CFA.dw_offset_or_block_len = _dwarf_decode_uleb128(&p);
  8004205e1d:	48 8b 5d 90          	mov    -0x70(%rbp),%rbx
  8004205e21:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205e25:	48 89 c7             	mov    %rax,%rdi
  8004205e28:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205e2f:	00 00 00 
  8004205e32:	ff d0                	callq  *%rax
  8004205e34:	48 89 43 08          	mov    %rax,0x8(%rbx)
			CFA.dw_block_ptr = p;
  8004205e38:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004205e40:	48 89 50 10          	mov    %rdx,0x10(%rax)
			p += CFA.dw_offset_or_block_len;
  8004205e44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004205e48:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e4c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004205e50:	48 01 d0             	add    %rdx,%rax
  8004205e53:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  8004205e57:	e9 9b 05 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_expression:
			*row_pc = pc;
  8004205e5c:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205e60:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205e64:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205e67:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205e6b:	48 89 c7             	mov    %rax,%rdi
  8004205e6e:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205e75:	00 00 00 
  8004205e78:	ff d0                	callq  *%rax
  8004205e7a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205e7e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e82:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205e86:	0f b7 c0             	movzwl %ax,%eax
  8004205e89:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205e8d:	77 0c                	ja     8004205e9b <_dwarf_frame_run_inst+0x865>
  8004205e8f:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205e96:	e9 6a 05 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205e9b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e9f:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205ea3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205ea7:	48 89 d0             	mov    %rdx,%rax
  8004205eaa:	48 01 c0             	add    %rax,%rax
  8004205ead:	48 01 d0             	add    %rdx,%rax
  8004205eb0:	48 c1 e0 03          	shl    $0x3,%rax
  8004205eb4:	48 01 c8             	add    %rcx,%rax
  8004205eb7:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
  8004205eba:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205ebe:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205ec2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205ec6:	48 89 d0             	mov    %rdx,%rax
  8004205ec9:	48 01 c0             	add    %rax,%rax
  8004205ecc:	48 01 d0             	add    %rdx,%rax
  8004205ecf:	48 c1 e0 03          	shl    $0x3,%rax
  8004205ed3:	48 01 c8             	add    %rcx,%rax
  8004205ed6:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  8004205eda:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205ede:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205ee2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205ee6:	48 89 d0             	mov    %rdx,%rax
  8004205ee9:	48 01 c0             	add    %rax,%rax
  8004205eec:	48 01 d0             	add    %rdx,%rax
  8004205eef:	48 c1 e0 03          	shl    $0x3,%rax
  8004205ef3:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  8004205ef7:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205efb:	48 89 c7             	mov    %rax,%rdi
  8004205efe:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205f05:	00 00 00 
  8004205f08:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  8004205f0a:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  8004205f0e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f12:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205f16:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205f1a:	48 89 d0             	mov    %rdx,%rax
  8004205f1d:	48 01 c0             	add    %rax,%rax
  8004205f20:	48 01 d0             	add    %rdx,%rax
  8004205f23:	48 c1 e0 03          	shl    $0x3,%rax
  8004205f27:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205f2b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004205f2f:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  8004205f33:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004205f37:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f3b:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004205f3f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205f43:	48 89 d0             	mov    %rdx,%rax
  8004205f46:	48 01 c0             	add    %rax,%rax
  8004205f49:	48 01 d0             	add    %rdx,%rax
  8004205f4c:	48 c1 e0 03          	shl    $0x3,%rax
  8004205f50:	48 01 f0             	add    %rsi,%rax
  8004205f53:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004205f57:	48 01 c8             	add    %rcx,%rax
  8004205f5a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  8004205f5e:	e9 94 04 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended_sf:
			*row_pc = pc;
  8004205f63:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205f67:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205f6b:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205f6e:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205f72:	48 89 c7             	mov    %rax,%rdi
  8004205f75:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004205f7c:	00 00 00 
  8004205f7f:	ff d0                	callq  *%rax
  8004205f81:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  8004205f85:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205f89:	48 89 c7             	mov    %rax,%rdi
  8004205f8c:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  8004205f93:	00 00 00 
  8004205f96:	ff d0                	callq  *%rax
  8004205f98:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205f9c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fa0:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205fa4:	0f b7 c0             	movzwl %ax,%eax
  8004205fa7:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205fab:	77 0c                	ja     8004205fb9 <_dwarf_frame_run_inst+0x983>
  8004205fad:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205fb4:	e9 4c 04 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  8004205fb9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fbd:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205fc1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205fc5:	48 89 d0             	mov    %rdx,%rax
  8004205fc8:	48 01 c0             	add    %rax,%rax
  8004205fcb:	48 01 d0             	add    %rdx,%rax
  8004205fce:	48 c1 e0 03          	shl    $0x3,%rax
  8004205fd2:	48 01 c8             	add    %rcx,%rax
  8004205fd5:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  8004205fd8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fdc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205fe0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205fe4:	48 89 d0             	mov    %rdx,%rax
  8004205fe7:	48 01 c0             	add    %rax,%rax
  8004205fea:	48 01 d0             	add    %rdx,%rax
  8004205fed:	48 c1 e0 03          	shl    $0x3,%rax
  8004205ff1:	48 01 c8             	add    %rcx,%rax
  8004205ff4:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  8004205ff8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205ffc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206000:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206004:	48 89 d0             	mov    %rdx,%rax
  8004206007:	48 01 c0             	add    %rax,%rax
  800420600a:	48 01 d0             	add    %rdx,%rax
  800420600d:	48 c1 e0 03          	shl    $0x3,%rax
  8004206011:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206015:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004206019:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420601d:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  8004206021:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206025:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206029:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420602d:	48 89 d0             	mov    %rdx,%rax
  8004206030:	48 01 c0             	add    %rax,%rax
  8004206033:	48 01 d0             	add    %rdx,%rax
  8004206036:	48 c1 e0 03          	shl    $0x3,%rax
  800420603a:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420603e:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004206045:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  800420604a:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  800420604e:	e9 a4 03 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_sf:
			*row_pc = pc;
  8004206053:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004206057:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420605b:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420605e:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206062:	48 89 c7             	mov    %rax,%rdi
  8004206065:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  800420606c:	00 00 00 
  800420606f:	ff d0                	callq  *%rax
  8004206071:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  8004206075:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206079:	48 89 c7             	mov    %rax,%rdi
  800420607c:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  8004206083:	00 00 00 
  8004206086:	ff d0                	callq  *%rax
  8004206088:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  800420608c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206090:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004206093:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206097:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  800420609b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420609f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042060a3:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  80042060a7:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060ab:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  80042060b2:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  80042060b7:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  80042060bb:	e9 37 03 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset_sf:
			*row_pc = pc;
  80042060c0:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042060c4:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042060c8:	48 89 10             	mov    %rdx,(%rax)
			soff = _dwarf_decode_sleb128(&p);
  80042060cb:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042060cf:	48 89 c7             	mov    %rax,%rdi
  80042060d2:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  80042060d9:	00 00 00 
  80042060dc:	ff d0                	callq  *%rax
  80042060de:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  80042060e2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060e6:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  80042060e9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060ed:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  80042060f1:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060f5:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  80042060fc:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  8004206101:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004206105:	e9 ed 02 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset:
			*row_pc = pc;
  800420610a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420610e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206112:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004206115:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206119:	48 89 c7             	mov    %rax,%rdi
  800420611c:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004206123:	00 00 00 
  8004206126:	ff d0                	callq  *%rax
  8004206128:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  800420612c:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206130:	48 89 c7             	mov    %rax,%rdi
  8004206133:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  800420613a:	00 00 00 
  800420613d:	ff d0                	callq  *%rax
  800420613f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004206143:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206147:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420614b:	0f b7 c0             	movzwl %ax,%eax
  800420614e:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004206152:	77 0c                	ja     8004206160 <_dwarf_frame_run_inst+0xb2a>
  8004206154:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420615b:	e9 a5 02 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  8004206160:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206164:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206168:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420616c:	48 89 d0             	mov    %rdx,%rax
  800420616f:	48 01 c0             	add    %rax,%rax
  8004206172:	48 01 d0             	add    %rdx,%rax
  8004206175:	48 c1 e0 03          	shl    $0x3,%rax
  8004206179:	48 01 c8             	add    %rcx,%rax
  800420617c:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420617f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206183:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206187:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420618b:	48 89 d0             	mov    %rdx,%rax
  800420618e:	48 01 c0             	add    %rax,%rax
  8004206191:	48 01 d0             	add    %rdx,%rax
  8004206194:	48 c1 e0 03          	shl    $0x3,%rax
  8004206198:	48 01 c8             	add    %rcx,%rax
  800420619b:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420619f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042061a3:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042061a7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042061ab:	48 89 d0             	mov    %rdx,%rax
  80042061ae:	48 01 c0             	add    %rax,%rax
  80042061b1:	48 01 d0             	add    %rdx,%rax
  80042061b4:	48 c1 e0 03          	shl    $0x3,%rax
  80042061b8:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042061bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042061c0:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  80042061c4:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  80042061c8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042061cc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042061d0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042061d4:	48 89 d0             	mov    %rdx,%rax
  80042061d7:	48 01 c0             	add    %rax,%rax
  80042061da:	48 01 d0             	add    %rdx,%rax
  80042061dd:	48 c1 e0 03          	shl    $0x3,%rax
  80042061e1:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042061e5:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  80042061ec:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  80042061f1:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  80042061f5:	e9 fd 01 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset_sf:
			*row_pc = pc;
  80042061fa:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042061fe:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206202:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004206205:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206209:	48 89 c7             	mov    %rax,%rdi
  800420620c:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004206213:	00 00 00 
  8004206216:	ff d0                	callq  *%rax
  8004206218:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  800420621c:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206220:	48 89 c7             	mov    %rax,%rdi
  8004206223:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  800420622a:	00 00 00 
  800420622d:	ff d0                	callq  *%rax
  800420622f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004206233:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206237:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420623b:	0f b7 c0             	movzwl %ax,%eax
  800420623e:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004206242:	77 0c                	ja     8004206250 <_dwarf_frame_run_inst+0xc1a>
  8004206244:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420624b:	e9 b5 01 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  8004206250:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206254:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206258:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420625c:	48 89 d0             	mov    %rdx,%rax
  800420625f:	48 01 c0             	add    %rax,%rax
  8004206262:	48 01 d0             	add    %rdx,%rax
  8004206265:	48 c1 e0 03          	shl    $0x3,%rax
  8004206269:	48 01 c8             	add    %rcx,%rax
  800420626c:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420626f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206273:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206277:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420627b:	48 89 d0             	mov    %rdx,%rax
  800420627e:	48 01 c0             	add    %rax,%rax
  8004206281:	48 01 d0             	add    %rdx,%rax
  8004206284:	48 c1 e0 03          	shl    $0x3,%rax
  8004206288:	48 01 c8             	add    %rcx,%rax
  800420628b:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420628f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206293:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206297:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420629b:	48 89 d0             	mov    %rdx,%rax
  800420629e:	48 01 c0             	add    %rax,%rax
  80042062a1:	48 01 d0             	add    %rdx,%rax
  80042062a4:	48 c1 e0 03          	shl    $0x3,%rax
  80042062a8:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042062ac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042062b0:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  80042062b4:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  80042062b8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042062bc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042062c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042062c4:	48 89 d0             	mov    %rdx,%rax
  80042062c7:	48 01 c0             	add    %rax,%rax
  80042062ca:	48 01 d0             	add    %rdx,%rax
  80042062cd:	48 c1 e0 03          	shl    $0x3,%rax
  80042062d1:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042062d5:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  80042062dc:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  80042062e1:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  80042062e5:	e9 0d 01 00 00       	jmpq   80042063f7 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_expression:
			*row_pc = pc;
  80042062ea:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042062ee:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042062f2:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  80042062f5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042062f9:	48 89 c7             	mov    %rax,%rdi
  80042062fc:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004206303:	00 00 00 
  8004206306:	ff d0                	callq  *%rax
  8004206308:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420630c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206310:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004206314:	0f b7 c0             	movzwl %ax,%eax
  8004206317:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420631b:	77 0c                	ja     8004206329 <_dwarf_frame_run_inst+0xcf3>
  800420631d:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004206324:	e9 dc 00 00 00       	jmpq   8004206405 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004206329:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420632d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206331:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206335:	48 89 d0             	mov    %rdx,%rax
  8004206338:	48 01 c0             	add    %rax,%rax
  800420633b:	48 01 d0             	add    %rdx,%rax
  800420633e:	48 c1 e0 03          	shl    $0x3,%rax
  8004206342:	48 01 c8             	add    %rcx,%rax
  8004206345:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
  8004206348:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420634c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206350:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206354:	48 89 d0             	mov    %rdx,%rax
  8004206357:	48 01 c0             	add    %rax,%rax
  800420635a:	48 01 d0             	add    %rdx,%rax
  800420635d:	48 c1 e0 03          	shl    $0x3,%rax
  8004206361:	48 01 c8             	add    %rcx,%rax
  8004206364:	c6 40 01 03          	movb   $0x3,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  8004206368:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420636c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206370:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206374:	48 89 d0             	mov    %rdx,%rax
  8004206377:	48 01 c0             	add    %rax,%rax
  800420637a:	48 01 d0             	add    %rdx,%rax
  800420637d:	48 c1 e0 03          	shl    $0x3,%rax
  8004206381:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  8004206385:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206389:	48 89 c7             	mov    %rax,%rdi
  800420638c:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004206393:	00 00 00 
  8004206396:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  8004206398:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  800420639c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042063a0:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042063a4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042063a8:	48 89 d0             	mov    %rdx,%rax
  80042063ab:	48 01 c0             	add    %rax,%rax
  80042063ae:	48 01 d0             	add    %rdx,%rax
  80042063b1:	48 c1 e0 03          	shl    $0x3,%rax
  80042063b5:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042063b9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042063bd:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  80042063c1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042063c5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042063c9:	48 8b 70 20          	mov    0x20(%rax),%rsi
  80042063cd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042063d1:	48 89 d0             	mov    %rdx,%rax
  80042063d4:	48 01 c0             	add    %rax,%rax
  80042063d7:	48 01 d0             	add    %rdx,%rax
  80042063da:	48 c1 e0 03          	shl    $0x3,%rax
  80042063de:	48 01 f0             	add    %rsi,%rax
  80042063e1:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042063e5:	48 01 c8             	add    %rcx,%rax
  80042063e8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  80042063ec:	eb 09                	jmp    80042063f7 <_dwarf_frame_run_inst+0xdc1>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_INSTR_EXEC_ERROR);
			ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  80042063ee:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			goto program_done;
  80042063f5:	eb 0e                	jmp    8004206405 <_dwarf_frame_run_inst+0xdcf>
	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
	p = insts;
	pe = p + len;

	while (p < pe) {
  80042063f7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042063fb:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042063ff:	0f 82 b8 f2 ff ff    	jb     80042056bd <_dwarf_frame_run_inst+0x87>
			goto program_done;
		}
	}

program_done:
	return (ret);
  8004206405:	8b 45 ec             	mov    -0x14(%rbp),%eax
#undef  CFA
#undef  INITCFA
#undef  RL
#undef  INITRL
#undef  CHECK_TABLE_SIZE
}
  8004206408:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  800420640f:	5b                   	pop    %rbx
  8004206410:	5d                   	pop    %rbp
  8004206411:	c3                   	retq   

0000008004206412 <_dwarf_frame_get_internal_table>:
int
_dwarf_frame_get_internal_table(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_req, Dwarf_Regtable3 **ret_rt,
				Dwarf_Addr *ret_row_pc,
				Dwarf_Error *error)
{
  8004206412:	55                   	push   %rbp
  8004206413:	48 89 e5             	mov    %rsp,%rbp
  8004206416:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  800420641a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420641e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004206422:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004206426:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  800420642a:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
  800420642e:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Cie cie;
	Dwarf_Regtable3 *rt;
	Dwarf_Addr row_pc;
	int i, ret;

	assert(ret_rt != NULL);
  8004206432:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  8004206437:	75 35                	jne    800420646e <_dwarf_frame_get_internal_table+0x5c>
  8004206439:	48 b9 98 a0 20 04 80 	movabs $0x800420a098,%rcx
  8004206440:	00 00 00 
  8004206443:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  800420644a:	00 00 00 
  800420644d:	be 83 01 00 00       	mov    $0x183,%esi
  8004206452:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  8004206459:	00 00 00 
  800420645c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206461:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206468:	00 00 00 
  800420646b:	41 ff d0             	callq  *%r8

	//dbg = fde->fde_dbg;
	assert(dbg != NULL);
  800420646e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004206473:	75 35                	jne    80042064aa <_dwarf_frame_get_internal_table+0x98>
  8004206475:	48 b9 a7 a0 20 04 80 	movabs $0x800420a0a7,%rcx
  800420647c:	00 00 00 
  800420647f:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  8004206486:	00 00 00 
  8004206489:	be 86 01 00 00       	mov    $0x186,%esi
  800420648e:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  8004206495:	00 00 00 
  8004206498:	b8 00 00 00 00       	mov    $0x0,%eax
  800420649d:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042064a4:	00 00 00 
  80042064a7:	41 ff d0             	callq  *%r8

	rt = dbg->dbg_internal_reg_table;
  80042064aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042064ae:	48 8b 40 58          	mov    0x58(%rax),%rax
  80042064b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	/* Clear the content of regtable from previous run. */
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
  80042064b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042064ba:	ba 18 00 00 00       	mov    $0x18,%edx
  80042064bf:	be 00 00 00 00       	mov    $0x0,%esi
  80042064c4:	48 89 c7             	mov    %rax,%rdi
  80042064c7:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  80042064ce:	00 00 00 
  80042064d1:	ff d0                	callq  *%rax
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
  80042064d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042064d7:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042064db:	0f b7 d0             	movzwl %ax,%edx
  80042064de:	48 89 d0             	mov    %rdx,%rax
  80042064e1:	48 01 c0             	add    %rax,%rax
  80042064e4:	48 01 d0             	add    %rdx,%rax
  80042064e7:	48 c1 e0 03          	shl    $0x3,%rax
  80042064eb:	48 89 c2             	mov    %rax,%rdx
  80042064ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042064f2:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042064f6:	be 00 00 00 00       	mov    $0x0,%esi
  80042064fb:	48 89 c7             	mov    %rax,%rdi
  80042064fe:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  8004206505:	00 00 00 
  8004206508:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  800420650a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004206511:	eb 2f                	jmp    8004206542 <_dwarf_frame_get_internal_table+0x130>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;
  8004206513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206517:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420651b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420651e:	48 63 d0             	movslq %eax,%rdx
  8004206521:	48 89 d0             	mov    %rdx,%rax
  8004206524:	48 01 c0             	add    %rax,%rax
  8004206527:	48 01 d0             	add    %rdx,%rax
  800420652a:	48 c1 e0 03          	shl    $0x3,%rax
  800420652e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206532:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206536:	0f b7 40 4a          	movzwl 0x4a(%rax),%eax
  800420653a:	66 89 42 02          	mov    %ax,0x2(%rdx)
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  800420653e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004206542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206546:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420654a:	0f b7 c0             	movzwl %ax,%eax
  800420654d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8004206550:	7f c1                	jg     8004206513 <_dwarf_frame_get_internal_table+0x101>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;

	/* Run initial instructions in CIE. */
	cie = fde->fde_cie;
  8004206552:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206556:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420655a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	assert(cie != NULL);
  800420655e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206563:	75 35                	jne    800420659a <_dwarf_frame_get_internal_table+0x188>
  8004206565:	48 b9 b3 a0 20 04 80 	movabs $0x800420a0b3,%rcx
  800420656c:	00 00 00 
  800420656f:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  8004206576:	00 00 00 
  8004206579:	be 95 01 00 00       	mov    $0x195,%esi
  800420657e:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  8004206585:	00 00 00 
  8004206588:	b8 00 00 00 00       	mov    $0x0,%eax
  800420658d:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206594:	00 00 00 
  8004206597:	41 ff d0             	callq  *%r8
	ret = _dwarf_frame_run_inst(dbg, rt, cie->cie_initinst,
  800420659a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420659e:	4c 8b 48 40          	mov    0x40(%rax),%r9
  80042065a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042065a6:	4c 8b 40 38          	mov    0x38(%rax),%r8
  80042065aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042065ae:	48 8b 48 70          	mov    0x70(%rax),%rcx
  80042065b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042065b6:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80042065ba:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80042065be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042065c2:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80042065c6:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  80042065cb:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80042065cf:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  80042065d4:	48 c7 44 24 08 ff ff 	movq   $0xffffffffffffffff,0x8(%rsp)
  80042065db:	ff ff 
  80042065dd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80042065e4:	00 
  80042065e5:	48 89 c7             	mov    %rax,%rdi
  80042065e8:	48 b8 36 56 20 04 80 	movabs $0x8004205636,%rax
  80042065ef:	00 00 00 
  80042065f2:	ff d0                	callq  *%rax
  80042065f4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
				    cie->cie_instlen, cie->cie_caf,
				    cie->cie_daf, 0, ~0ULL,
				    &row_pc, error);
	if (ret != DW_DLE_NONE)
  80042065f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042065fb:	74 08                	je     8004206605 <_dwarf_frame_get_internal_table+0x1f3>
		return (ret);
  80042065fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004206600:	e9 98 00 00 00       	jmpq   800420669d <_dwarf_frame_get_internal_table+0x28b>
	/* Run instructions in FDE. */
	if (pc_req >= fde->fde_initloc) {
  8004206605:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206609:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420660d:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  8004206611:	77 6f                	ja     8004206682 <_dwarf_frame_get_internal_table+0x270>
		ret = _dwarf_frame_run_inst(dbg, rt, fde->fde_inst,
  8004206613:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206617:	48 8b 78 30          	mov    0x30(%rax),%rdi
  800420661b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420661f:	4c 8b 48 40          	mov    0x40(%rax),%r9
  8004206623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206627:	4c 8b 50 38          	mov    0x38(%rax),%r10
  800420662b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420662f:	48 8b 48 58          	mov    0x58(%rax),%rcx
  8004206633:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206637:	48 8b 50 50          	mov    0x50(%rax),%rdx
  800420663b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800420663f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206643:	4c 8b 45 a0          	mov    -0x60(%rbp),%r8
  8004206647:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  800420664c:	4c 8d 45 d8          	lea    -0x28(%rbp),%r8
  8004206650:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8004206655:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
  8004206659:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  800420665e:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004206662:	4d 89 d0             	mov    %r10,%r8
  8004206665:	48 89 c7             	mov    %rax,%rdi
  8004206668:	48 b8 36 56 20 04 80 	movabs $0x8004205636,%rax
  800420666f:	00 00 00 
  8004206672:	ff d0                	callq  *%rax
  8004206674:	89 45 e4             	mov    %eax,-0x1c(%rbp)
					    fde->fde_instlen, cie->cie_caf,
					    cie->cie_daf,
					    fde->fde_initloc, pc_req,
					    &row_pc, error);
		if (ret != DW_DLE_NONE)
  8004206677:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800420667b:	74 05                	je     8004206682 <_dwarf_frame_get_internal_table+0x270>
			return (ret);
  800420667d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004206680:	eb 1b                	jmp    800420669d <_dwarf_frame_get_internal_table+0x28b>
	}

	*ret_rt = rt;
  8004206682:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004206686:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420668a:	48 89 10             	mov    %rdx,(%rax)
	*ret_row_pc = row_pc;
  800420668d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004206691:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004206695:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  8004206698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420669d:	c9                   	leaveq 
  800420669e:	c3                   	retq   

000000800420669f <dwarf_get_fde_info_for_all_regs>:
int
dwarf_get_fde_info_for_all_regs(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_requested,
				Dwarf_Regtable *reg_table, Dwarf_Addr *row_pc,
				Dwarf_Error *error)
{
  800420669f:	55                   	push   %rbp
  80042066a0:	48 89 e5             	mov    %rsp,%rbp
  80042066a3:	48 83 ec 50          	sub    $0x50,%rsp
  80042066a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042066ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80042066af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80042066b3:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  80042066b7:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
  80042066bb:	4c 89 4d b0          	mov    %r9,-0x50(%rbp)
	Dwarf_Regtable3 *rt;
	Dwarf_Addr pc;
	Dwarf_Half cfa;
	int i, ret;

	if (fde == NULL || reg_table == NULL) {
  80042066bf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042066c4:	74 07                	je     80042066cd <dwarf_get_fde_info_for_all_regs+0x2e>
  80042066c6:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  80042066cb:	75 0a                	jne    80042066d7 <dwarf_get_fde_info_for_all_regs+0x38>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  80042066cd:	b8 01 00 00 00       	mov    $0x1,%eax
  80042066d2:	e9 eb 02 00 00       	jmpq   80042069c2 <dwarf_get_fde_info_for_all_regs+0x323>
	}

	assert(dbg != NULL);
  80042066d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80042066dc:	75 35                	jne    8004206713 <dwarf_get_fde_info_for_all_regs+0x74>
  80042066de:	48 b9 a7 a0 20 04 80 	movabs $0x800420a0a7,%rcx
  80042066e5:	00 00 00 
  80042066e8:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  80042066ef:	00 00 00 
  80042066f2:	be bf 01 00 00       	mov    $0x1bf,%esi
  80042066f7:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  80042066fe:	00 00 00 
  8004206701:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206706:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  800420670d:	00 00 00 
  8004206710:	41 ff d0             	callq  *%r8

	if (pc_requested < fde->fde_initloc ||
  8004206713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004206717:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420671b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  800420671f:	77 19                	ja     800420673a <dwarf_get_fde_info_for_all_regs+0x9b>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
  8004206721:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004206725:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004206729:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420672d:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206731:	48 01 d0             	add    %rdx,%rax
		return (DW_DLV_ERROR);
	}

	assert(dbg != NULL);

	if (pc_requested < fde->fde_initloc ||
  8004206734:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004206738:	77 0a                	ja     8004206744 <dwarf_get_fde_info_for_all_regs+0xa5>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_PC_NOT_IN_FDE_RANGE);
		return (DW_DLV_ERROR);
  800420673a:	b8 01 00 00 00       	mov    $0x1,%eax
  800420673f:	e9 7e 02 00 00       	jmpq   80042069c2 <dwarf_get_fde_info_for_all_regs+0x323>
	}

	ret = _dwarf_frame_get_internal_table(dbg, fde, pc_requested, &rt, &pc,
  8004206744:	4c 8b 45 b0          	mov    -0x50(%rbp),%r8
  8004206748:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  800420674c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8004206750:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206754:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420675c:	4d 89 c1             	mov    %r8,%r9
  800420675f:	49 89 f8             	mov    %rdi,%r8
  8004206762:	48 89 c7             	mov    %rax,%rdi
  8004206765:	48 b8 12 64 20 04 80 	movabs $0x8004206412,%rax
  800420676c:	00 00 00 
  800420676f:	ff d0                	callq  *%rax
  8004206771:	89 45 f8             	mov    %eax,-0x8(%rbp)
					      error);
	if (ret != DW_DLE_NONE)
  8004206774:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004206778:	74 0a                	je     8004206784 <dwarf_get_fde_info_for_all_regs+0xe5>
		return (DW_DLV_ERROR);
  800420677a:	b8 01 00 00 00       	mov    $0x1,%eax
  800420677f:	e9 3e 02 00 00       	jmpq   80042069c2 <dwarf_get_fde_info_for_all_regs+0x323>
	/*
	 * Copy the CFA rule to the column intended for holding the CFA,
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
  8004206784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206788:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420678c:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
	if (cfa < DW_REG_TABLE_SIZE) {
  8004206790:	66 83 7d f6 41       	cmpw   $0x41,-0xa(%rbp)
  8004206795:	0f 87 b1 00 00 00    	ja     800420684c <dwarf_get_fde_info_for_all_regs+0x1ad>
		reg_table->rules[cfa].dw_offset_relevant =
  800420679b:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
			CFA.dw_offset_relevant;
  800420679f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042067a3:	0f b6 00             	movzbl (%rax),%eax
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
	if (cfa < DW_REG_TABLE_SIZE) {
		reg_table->rules[cfa].dw_offset_relevant =
  80042067a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042067aa:	48 63 c9             	movslq %ecx,%rcx
  80042067ad:	48 83 c1 01          	add    $0x1,%rcx
  80042067b1:	48 c1 e1 04          	shl    $0x4,%rcx
  80042067b5:	48 01 ca             	add    %rcx,%rdx
  80042067b8:	88 02                	mov    %al,(%rdx)
			CFA.dw_offset_relevant;
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
  80042067ba:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  80042067be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042067c2:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  80042067c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042067ca:	48 63 c9             	movslq %ecx,%rcx
  80042067cd:	48 83 c1 01          	add    $0x1,%rcx
  80042067d1:	48 c1 e1 04          	shl    $0x4,%rcx
  80042067d5:	48 01 ca             	add    %rcx,%rdx
  80042067d8:	88 42 01             	mov    %al,0x1(%rdx)
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
  80042067db:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  80042067df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042067e3:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  80042067e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042067eb:	48 63 c9             	movslq %ecx,%rcx
  80042067ee:	48 83 c1 01          	add    $0x1,%rcx
  80042067f2:	48 c1 e1 04          	shl    $0x4,%rcx
  80042067f6:	48 01 ca             	add    %rcx,%rdx
  80042067f9:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
  80042067fd:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  8004206801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206805:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004206809:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420680d:	48 63 c9             	movslq %ecx,%rcx
  8004206810:	48 83 c1 01          	add    $0x1,%rcx
  8004206814:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206818:	48 01 ca             	add    %rcx,%rdx
  800420681b:	48 83 c2 08          	add    $0x8,%rdx
  800420681f:	48 89 02             	mov    %rax,(%rdx)
		reg_table->cfa_rule = reg_table->rules[cfa];
  8004206822:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
  8004206826:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800420682a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420682e:	48 63 d2             	movslq %edx,%rdx
  8004206831:	48 83 c2 01          	add    $0x1,%rdx
  8004206835:	48 c1 e2 04          	shl    $0x4,%rdx
  8004206839:	48 01 d0             	add    %rdx,%rax
  800420683c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004206840:	48 8b 00             	mov    (%rax),%rax
  8004206843:	48 89 01             	mov    %rax,(%rcx)
  8004206846:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  800420684a:	eb 3c                	jmp    8004206888 <dwarf_get_fde_info_for_all_regs+0x1e9>
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
		    CFA.dw_offset_relevant;
  800420684c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206850:	0f b6 10             	movzbl (%rax),%edx
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
		reg_table->cfa_rule = reg_table->rules[cfa];
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
  8004206853:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206857:	88 10                	mov    %dl,(%rax)
		    CFA.dw_offset_relevant;
		reg_table->cfa_rule.dw_value_type = CFA.dw_value_type;
  8004206859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420685d:	0f b6 50 01          	movzbl 0x1(%rax),%edx
  8004206861:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206865:	88 50 01             	mov    %dl,0x1(%rax)
		reg_table->cfa_rule.dw_regnum = CFA.dw_regnum;
  8004206868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420686c:	0f b7 50 02          	movzwl 0x2(%rax),%edx
  8004206870:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206874:	66 89 50 02          	mov    %dx,0x2(%rax)
		reg_table->cfa_rule.dw_offset = CFA.dw_offset_or_block_len;
  8004206878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420687c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004206880:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206884:	48 89 50 08          	mov    %rdx,0x8(%rax)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  8004206888:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800420688f:	e9 fd 00 00 00       	jmpq   8004206991 <dwarf_get_fde_info_for_all_regs+0x2f2>
	     i++) {

		/* Do not overwrite CFA column */
		if (i == cfa)
  8004206894:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
  8004206898:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800420689b:	75 05                	jne    80042068a2 <dwarf_get_fde_info_for_all_regs+0x203>
			continue;
  800420689d:	e9 eb 00 00 00       	jmpq   800420698d <dwarf_get_fde_info_for_all_regs+0x2ee>

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
  80042068a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042068a6:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042068aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042068ad:	48 63 d0             	movslq %eax,%rdx
  80042068b0:	48 89 d0             	mov    %rdx,%rax
  80042068b3:	48 01 c0             	add    %rax,%rax
  80042068b6:	48 01 d0             	add    %rdx,%rax
  80042068b9:	48 c1 e0 03          	shl    $0x3,%rax
  80042068bd:	48 01 c8             	add    %rcx,%rax
  80042068c0:	0f b6 00             	movzbl (%rax),%eax

		/* Do not overwrite CFA column */
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
  80042068c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042068c7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80042068ca:	48 63 c9             	movslq %ecx,%rcx
  80042068cd:	48 83 c1 01          	add    $0x1,%rcx
  80042068d1:	48 c1 e1 04          	shl    $0x4,%rcx
  80042068d5:	48 01 ca             	add    %rcx,%rdx
  80042068d8:	88 02                	mov    %al,(%rdx)
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
  80042068da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042068de:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042068e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042068e5:	48 63 d0             	movslq %eax,%rdx
  80042068e8:	48 89 d0             	mov    %rdx,%rax
  80042068eb:	48 01 c0             	add    %rax,%rax
  80042068ee:	48 01 d0             	add    %rdx,%rax
  80042068f1:	48 c1 e0 03          	shl    $0x3,%rax
  80042068f5:	48 01 c8             	add    %rcx,%rax
  80042068f8:	0f b6 40 01          	movzbl 0x1(%rax),%eax
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
  80042068fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206900:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206903:	48 63 c9             	movslq %ecx,%rcx
  8004206906:	48 83 c1 01          	add    $0x1,%rcx
  800420690a:	48 c1 e1 04          	shl    $0x4,%rcx
  800420690e:	48 01 ca             	add    %rcx,%rdx
  8004206911:	88 42 01             	mov    %al,0x1(%rdx)
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
  8004206914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206918:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420691c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420691f:	48 63 d0             	movslq %eax,%rdx
  8004206922:	48 89 d0             	mov    %rdx,%rax
  8004206925:	48 01 c0             	add    %rax,%rax
  8004206928:	48 01 d0             	add    %rdx,%rax
  800420692b:	48 c1 e0 03          	shl    $0x3,%rax
  800420692f:	48 01 c8             	add    %rcx,%rax
  8004206932:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  8004206936:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420693a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420693d:	48 63 c9             	movslq %ecx,%rcx
  8004206940:	48 83 c1 01          	add    $0x1,%rcx
  8004206944:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206948:	48 01 ca             	add    %rcx,%rdx
  800420694b:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
  800420694f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206953:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420695a:	48 63 d0             	movslq %eax,%rdx
  800420695d:	48 89 d0             	mov    %rdx,%rax
  8004206960:	48 01 c0             	add    %rax,%rax
  8004206963:	48 01 d0             	add    %rdx,%rax
  8004206966:	48 c1 e0 03          	shl    $0x3,%rax
  800420696a:	48 01 c8             	add    %rcx,%rax
  800420696d:	48 8b 40 08          	mov    0x8(%rax),%rax
		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
  8004206971:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206975:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206978:	48 63 c9             	movslq %ecx,%rcx
  800420697b:	48 83 c1 01          	add    $0x1,%rcx
  800420697f:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206983:	48 01 ca             	add    %rcx,%rdx
  8004206986:	48 83 c2 08          	add    $0x8,%rdx
  800420698a:	48 89 02             	mov    %rax,(%rdx)

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
	     i++) {
  800420698d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  8004206991:	83 7d fc 41          	cmpl   $0x41,-0x4(%rbp)
  8004206995:	7f 14                	jg     80042069ab <dwarf_get_fde_info_for_all_regs+0x30c>
  8004206997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420699b:	0f b7 40 48          	movzwl 0x48(%rax),%eax
  800420699f:	0f b7 c0             	movzwl %ax,%eax
  80042069a2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80042069a5:	0f 8f e9 fe ff ff    	jg     8004206894 <dwarf_get_fde_info_for_all_regs+0x1f5>
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
	}

	if (row_pc) *row_pc = pc;
  80042069ab:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  80042069b0:	74 0b                	je     80042069bd <dwarf_get_fde_info_for_all_regs+0x31e>
  80042069b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042069b6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042069ba:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLV_OK);
  80042069bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042069c2:	c9                   	leaveq 
  80042069c3:	c3                   	retq   

00000080042069c4 <_dwarf_frame_read_lsb_encoded>:

static int
_dwarf_frame_read_lsb_encoded(Dwarf_Debug dbg, uint64_t *val, uint8_t *data,
			      uint64_t *offsetp, uint8_t encode, Dwarf_Addr pc, Dwarf_Error *error)
{
  80042069c4:	55                   	push   %rbp
  80042069c5:	48 89 e5             	mov    %rsp,%rbp
  80042069c8:	48 83 ec 40          	sub    $0x40,%rsp
  80042069cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042069d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042069d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042069d8:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80042069dc:	44 89 c0             	mov    %r8d,%eax
  80042069df:	4c 89 4d c0          	mov    %r9,-0x40(%rbp)
  80042069e3:	88 45 cc             	mov    %al,-0x34(%rbp)
	uint8_t application;

	if (encode == DW_EH_PE_omit)
  80042069e6:	80 7d cc ff          	cmpb   $0xff,-0x34(%rbp)
  80042069ea:	75 0a                	jne    80042069f6 <_dwarf_frame_read_lsb_encoded+0x32>
		return (DW_DLE_NONE);
  80042069ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80042069f1:	e9 e6 01 00 00       	jmpq   8004206bdc <_dwarf_frame_read_lsb_encoded+0x218>

	application = encode & 0xf0;
  80042069f6:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  80042069fa:	83 e0 f0             	and    $0xfffffff0,%eax
  80042069fd:	88 45 ff             	mov    %al,-0x1(%rbp)
	encode &= 0x0f;
  8004206a00:	80 65 cc 0f          	andb   $0xf,-0x34(%rbp)

	switch (encode) {
  8004206a04:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  8004206a08:	83 f8 0c             	cmp    $0xc,%eax
  8004206a0b:	0f 87 72 01 00 00    	ja     8004206b83 <_dwarf_frame_read_lsb_encoded+0x1bf>
  8004206a11:	89 c0                	mov    %eax,%eax
  8004206a13:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004206a1a:	00 
  8004206a1b:	48 b8 c0 a0 20 04 80 	movabs $0x800420a0c0,%rax
  8004206a22:	00 00 00 
  8004206a25:	48 01 d0             	add    %rdx,%rax
  8004206a28:	48 8b 00             	mov    (%rax),%rax
  8004206a2b:	ff e0                	jmpq   *%rax
	case DW_EH_PE_absptr:
		*val = dbg->read(data, offsetp, dbg->dbg_pointer_size);
  8004206a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a31:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206a35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004206a39:	8b 52 28             	mov    0x28(%rdx),%edx
  8004206a3c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206a40:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206a44:	48 89 cf             	mov    %rcx,%rdi
  8004206a47:	ff d0                	callq  *%rax
  8004206a49:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206a4d:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206a50:	e9 35 01 00 00       	jmpq   8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_uleb128:
		*val = _dwarf_read_uleb128(data, offsetp);
  8004206a55:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206a5d:	48 89 d6             	mov    %rdx,%rsi
  8004206a60:	48 89 c7             	mov    %rax,%rdi
  8004206a63:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004206a6a:	00 00 00 
  8004206a6d:	ff d0                	callq  *%rax
  8004206a6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206a73:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206a76:	e9 0f 01 00 00       	jmpq   8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata2:
		*val = dbg->read(data, offsetp, 2);
  8004206a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a7f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206a83:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206a87:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206a8b:	ba 02 00 00 00       	mov    $0x2,%edx
  8004206a90:	48 89 cf             	mov    %rcx,%rdi
  8004206a93:	ff d0                	callq  *%rax
  8004206a95:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206a99:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206a9c:	e9 e9 00 00 00       	jmpq   8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata4:
		*val = dbg->read(data, offsetp, 4);
  8004206aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206aa5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206aa9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206aad:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206ab1:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206ab6:	48 89 cf             	mov    %rcx,%rdi
  8004206ab9:	ff d0                	callq  *%rax
  8004206abb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206abf:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206ac2:	e9 c3 00 00 00       	jmpq   8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata8:
		*val = dbg->read(data, offsetp, 8);
  8004206ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206acb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206acf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206ad3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206ad7:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206adc:	48 89 cf             	mov    %rcx,%rdi
  8004206adf:	ff d0                	callq  *%rax
  8004206ae1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206ae5:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206ae8:	e9 9d 00 00 00       	jmpq   8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sleb128:
		*val = _dwarf_read_sleb128(data, offsetp);
  8004206aed:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206af1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206af5:	48 89 d6             	mov    %rdx,%rsi
  8004206af8:	48 89 c7             	mov    %rax,%rdi
  8004206afb:	48 b8 b4 39 20 04 80 	movabs $0x80042039b4,%rax
  8004206b02:	00 00 00 
  8004206b05:	ff d0                	callq  *%rax
  8004206b07:	48 89 c2             	mov    %rax,%rdx
  8004206b0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206b0e:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206b11:	eb 77                	jmp    8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata2:
		*val = (int16_t) dbg->read(data, offsetp, 2);
  8004206b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b17:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206b1b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206b1f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206b23:	ba 02 00 00 00       	mov    $0x2,%edx
  8004206b28:	48 89 cf             	mov    %rcx,%rdi
  8004206b2b:	ff d0                	callq  *%rax
  8004206b2d:	48 0f bf d0          	movswq %ax,%rdx
  8004206b31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206b35:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206b38:	eb 50                	jmp    8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata4:
		*val = (int32_t) dbg->read(data, offsetp, 4);
  8004206b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b3e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206b42:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206b46:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206b4a:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206b4f:	48 89 cf             	mov    %rcx,%rdi
  8004206b52:	ff d0                	callq  *%rax
  8004206b54:	48 63 d0             	movslq %eax,%rdx
  8004206b57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206b5b:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206b5e:	eb 2a                	jmp    8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata8:
		*val = dbg->read(data, offsetp, 8);
  8004206b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b64:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206b68:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206b6c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206b70:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206b75:	48 89 cf             	mov    %rcx,%rdi
  8004206b78:	ff d0                	callq  *%rax
  8004206b7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206b7e:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206b81:	eb 07                	jmp    8004206b8a <_dwarf_frame_read_lsb_encoded+0x1c6>
	default:
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  8004206b83:	b8 14 00 00 00       	mov    $0x14,%eax
  8004206b88:	eb 52                	jmp    8004206bdc <_dwarf_frame_read_lsb_encoded+0x218>
	}

	if (application == DW_EH_PE_pcrel) {
  8004206b8a:	80 7d ff 10          	cmpb   $0x10,-0x1(%rbp)
  8004206b8e:	75 47                	jne    8004206bd7 <_dwarf_frame_read_lsb_encoded+0x213>
		/*
		 * Value is relative to .eh_frame section virtual addr.
		 */
		switch (encode) {
  8004206b90:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  8004206b94:	83 f8 01             	cmp    $0x1,%eax
  8004206b97:	7c 3d                	jl     8004206bd6 <_dwarf_frame_read_lsb_encoded+0x212>
  8004206b99:	83 f8 04             	cmp    $0x4,%eax
  8004206b9c:	7e 0a                	jle    8004206ba8 <_dwarf_frame_read_lsb_encoded+0x1e4>
  8004206b9e:	83 e8 09             	sub    $0x9,%eax
  8004206ba1:	83 f8 03             	cmp    $0x3,%eax
  8004206ba4:	77 30                	ja     8004206bd6 <_dwarf_frame_read_lsb_encoded+0x212>
  8004206ba6:	eb 17                	jmp    8004206bbf <_dwarf_frame_read_lsb_encoded+0x1fb>
		case DW_EH_PE_uleb128:
		case DW_EH_PE_udata2:
		case DW_EH_PE_udata4:
		case DW_EH_PE_udata8:
			*val += pc;
  8004206ba8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206bac:	48 8b 10             	mov    (%rax),%rdx
  8004206baf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206bb3:	48 01 c2             	add    %rax,%rdx
  8004206bb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206bba:	48 89 10             	mov    %rdx,(%rax)
			break;
  8004206bbd:	eb 18                	jmp    8004206bd7 <_dwarf_frame_read_lsb_encoded+0x213>
		case DW_EH_PE_sleb128:
		case DW_EH_PE_sdata2:
		case DW_EH_PE_sdata4:
		case DW_EH_PE_sdata8:
			*val = pc + (int64_t) *val;
  8004206bbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206bc3:	48 8b 10             	mov    (%rax),%rdx
  8004206bc6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206bca:	48 01 c2             	add    %rax,%rdx
  8004206bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206bd1:	48 89 10             	mov    %rdx,(%rax)
			break;
  8004206bd4:	eb 01                	jmp    8004206bd7 <_dwarf_frame_read_lsb_encoded+0x213>
		default:
			/* DW_EH_PE_absptr is absolute value. */
			break;
  8004206bd6:	90                   	nop
		}
	}

	/* XXX Applications other than DW_EH_PE_pcrel are not handled. */

	return (DW_DLE_NONE);
  8004206bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206bdc:	c9                   	leaveq 
  8004206bdd:	c3                   	retq   

0000008004206bde <_dwarf_frame_parse_lsb_cie_augment>:

static int
_dwarf_frame_parse_lsb_cie_augment(Dwarf_Debug dbg, Dwarf_Cie cie,
				   Dwarf_Error *error)
{
  8004206bde:	55                   	push   %rbp
  8004206bdf:	48 89 e5             	mov    %rsp,%rbp
  8004206be2:	48 83 ec 50          	sub    $0x50,%rsp
  8004206be6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004206bea:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004206bee:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	uint8_t *aug_p, *augdata_p;
	uint64_t val, offset;
	uint8_t encode;
	int ret;

	assert(cie->cie_augment != NULL && *cie->cie_augment == 'z');
  8004206bf2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206bf6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206bfa:	48 85 c0             	test   %rax,%rax
  8004206bfd:	74 0f                	je     8004206c0e <_dwarf_frame_parse_lsb_cie_augment+0x30>
  8004206bff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206c03:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206c07:	0f b6 00             	movzbl (%rax),%eax
  8004206c0a:	3c 7a                	cmp    $0x7a,%al
  8004206c0c:	74 35                	je     8004206c43 <_dwarf_frame_parse_lsb_cie_augment+0x65>
  8004206c0e:	48 b9 28 a1 20 04 80 	movabs $0x800420a128,%rcx
  8004206c15:	00 00 00 
  8004206c18:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  8004206c1f:	00 00 00 
  8004206c22:	be 4a 02 00 00       	mov    $0x24a,%esi
  8004206c27:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  8004206c2e:	00 00 00 
  8004206c31:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206c36:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206c3d:	00 00 00 
  8004206c40:	41 ff d0             	callq  *%r8
	/*
	 * Here we're only interested in the presence of augment 'R'
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
  8004206c43:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206c47:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206c4b:	48 83 c0 01          	add    $0x1,%rax
  8004206c4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	augdata_p = cie->cie_augdata;
  8004206c53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206c57:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004206c5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (*aug_p != '\0') {
  8004206c5f:	e9 af 00 00 00       	jmpq   8004206d13 <_dwarf_frame_parse_lsb_cie_augment+0x135>
		switch (*aug_p) {
  8004206c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004206c68:	0f b6 00             	movzbl (%rax),%eax
  8004206c6b:	0f b6 c0             	movzbl %al,%eax
  8004206c6e:	83 f8 50             	cmp    $0x50,%eax
  8004206c71:	74 18                	je     8004206c8b <_dwarf_frame_parse_lsb_cie_augment+0xad>
  8004206c73:	83 f8 52             	cmp    $0x52,%eax
  8004206c76:	74 77                	je     8004206cef <_dwarf_frame_parse_lsb_cie_augment+0x111>
  8004206c78:	83 f8 4c             	cmp    $0x4c,%eax
  8004206c7b:	0f 85 86 00 00 00    	jne    8004206d07 <_dwarf_frame_parse_lsb_cie_augment+0x129>
		case 'L':
			/* Skip one augment in augment data. */
			augdata_p++;
  8004206c81:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
			break;
  8004206c86:	e9 83 00 00 00       	jmpq   8004206d0e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'P':
			/* Skip two augments in augment data. */
			encode = *augdata_p++;
  8004206c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206c8f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206c93:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8004206c97:	0f b6 00             	movzbl (%rax),%eax
  8004206c9a:	88 45 ef             	mov    %al,-0x11(%rbp)
			offset = 0;
  8004206c9d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8004206ca4:	00 
			ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004206ca5:	44 0f b6 45 ef       	movzbl -0x11(%rbp),%r8d
  8004206caa:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  8004206cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004206cb2:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8004206cb6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206cba:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004206cbe:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004206cc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004206cc8:	48 89 c7             	mov    %rax,%rdi
  8004206ccb:	48 b8 c4 69 20 04 80 	movabs $0x80042069c4,%rax
  8004206cd2:	00 00 00 
  8004206cd5:	ff d0                	callq  *%rax
  8004206cd7:	89 45 e8             	mov    %eax,-0x18(%rbp)
							    augdata_p, &offset, encode, 0, error);
			if (ret != DW_DLE_NONE)
  8004206cda:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8004206cde:	74 05                	je     8004206ce5 <_dwarf_frame_parse_lsb_cie_augment+0x107>
				return (ret);
  8004206ce0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8004206ce3:	eb 42                	jmp    8004206d27 <_dwarf_frame_parse_lsb_cie_augment+0x149>
			augdata_p += offset;
  8004206ce5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206ce9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
			break;
  8004206ced:	eb 1f                	jmp    8004206d0e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'R':
			cie->cie_fde_encode = *augdata_p++;
  8004206cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206cf3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206cf7:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8004206cfb:	0f b6 10             	movzbl (%rax),%edx
  8004206cfe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206d02:	88 50 60             	mov    %dl,0x60(%rax)
			break;
  8004206d05:	eb 07                	jmp    8004206d0e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  8004206d07:	b8 14 00 00 00       	mov    $0x14,%eax
  8004206d0c:	eb 19                	jmp    8004206d27 <_dwarf_frame_parse_lsb_cie_augment+0x149>
		}
		aug_p++;
  8004206d0e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
	augdata_p = cie->cie_augdata;
	while (*aug_p != '\0') {
  8004206d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004206d17:	0f b6 00             	movzbl (%rax),%eax
  8004206d1a:	84 c0                	test   %al,%al
  8004206d1c:	0f 85 42 ff ff ff    	jne    8004206c64 <_dwarf_frame_parse_lsb_cie_augment+0x86>
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		}
		aug_p++;
	}

	return (DW_DLE_NONE);
  8004206d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206d27:	c9                   	leaveq 
  8004206d28:	c3                   	retq   

0000008004206d29 <_dwarf_frame_set_cie>:


static int
_dwarf_frame_set_cie(Dwarf_Debug dbg, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, Dwarf_Cie ret_cie, Dwarf_Error *error)
{
  8004206d29:	55                   	push   %rbp
  8004206d2a:	48 89 e5             	mov    %rsp,%rbp
  8004206d2d:	48 83 ec 60          	sub    $0x60,%rsp
  8004206d31:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004206d35:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004206d39:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004206d3d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  8004206d41:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
	Dwarf_Cie cie;
	uint64_t length;
	int dwarf_size, ret;
	char *p;

	assert(ret_cie);
  8004206d45:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  8004206d4a:	75 35                	jne    8004206d81 <_dwarf_frame_set_cie+0x58>
  8004206d4c:	48 b9 5d a1 20 04 80 	movabs $0x800420a15d,%rcx
  8004206d53:	00 00 00 
  8004206d56:	48 ba a7 9f 20 04 80 	movabs $0x8004209fa7,%rdx
  8004206d5d:	00 00 00 
  8004206d60:	be 7b 02 00 00       	mov    $0x27b,%esi
  8004206d65:	48 bf bc 9f 20 04 80 	movabs $0x8004209fbc,%rdi
  8004206d6c:	00 00 00 
  8004206d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206d74:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206d7b:	00 00 00 
  8004206d7e:	41 ff d0             	callq  *%r8
	cie = ret_cie;
  8004206d81:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004206d85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cie->cie_dbg = dbg;
  8004206d89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206d8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206d91:	48 89 10             	mov    %rdx,(%rax)
	cie->cie_offset = *off;
  8004206d94:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206d98:	48 8b 10             	mov    (%rax),%rdx
  8004206d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206d9f:	48 89 50 10          	mov    %rdx,0x10(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  8004206da3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206da7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206dab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206daf:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206db3:	48 89 d1             	mov    %rdx,%rcx
  8004206db6:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206dba:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206dbf:	48 89 cf             	mov    %rcx,%rdi
  8004206dc2:	ff d0                	callq  *%rax
  8004206dc4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  8004206dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004206dcd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8004206dd1:	75 2e                	jne    8004206e01 <_dwarf_frame_set_cie+0xd8>
		dwarf_size = 8;
  8004206dd3:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  8004206dda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206dde:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206de2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206de6:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206dea:	48 89 d1             	mov    %rdx,%rcx
  8004206ded:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206df1:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206df6:	48 89 cf             	mov    %rcx,%rdi
  8004206df9:	ff d0                	callq  *%rax
  8004206dfb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004206dff:	eb 07                	jmp    8004206e08 <_dwarf_frame_set_cie+0xdf>
	} else
		dwarf_size = 4;
  8004206e01:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  8004206e08:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206e0c:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004206e10:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206e14:	48 8b 00             	mov    (%rax),%rax
  8004206e17:	48 29 c2             	sub    %rax,%rdx
  8004206e1a:	48 89 d0             	mov    %rdx,%rax
  8004206e1d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004206e21:	73 0a                	jae    8004206e2d <_dwarf_frame_set_cie+0x104>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  8004206e23:	b8 12 00 00 00       	mov    $0x12,%eax
  8004206e28:	e9 5d 03 00 00       	jmpq   800420718a <_dwarf_frame_set_cie+0x461>
	}

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
  8004206e2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206e31:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206e35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206e39:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206e3d:	48 89 d1             	mov    %rdx,%rcx
  8004206e40:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004206e43:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206e47:	48 89 cf             	mov    %rcx,%rdi
  8004206e4a:	ff d0                	callq  *%rax
	cie->cie_length = length;
  8004206e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206e50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004206e54:	48 89 50 18          	mov    %rdx,0x18(%rax)

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  8004206e58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206e5c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206e60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206e64:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206e68:	48 89 d1             	mov    %rdx,%rcx
  8004206e6b:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206e6f:	ba 01 00 00 00       	mov    $0x1,%edx
  8004206e74:	48 89 cf             	mov    %rcx,%rdi
  8004206e77:	ff d0                	callq  *%rax
  8004206e79:	89 c2                	mov    %eax,%edx
  8004206e7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206e7f:	66 89 50 20          	mov    %dx,0x20(%rax)
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  8004206e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206e87:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  8004206e8b:	66 83 f8 01          	cmp    $0x1,%ax
  8004206e8f:	74 26                	je     8004206eb7 <_dwarf_frame_set_cie+0x18e>
  8004206e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206e95:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  8004206e99:	66 83 f8 03          	cmp    $0x3,%ax
  8004206e9d:	74 18                	je     8004206eb7 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
  8004206e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ea3:	0f b7 40 20          	movzwl 0x20(%rax),%eax

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
	cie->cie_length = length;

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  8004206ea7:	66 83 f8 04          	cmp    $0x4,%ax
  8004206eab:	74 0a                	je     8004206eb7 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_VERSION_BAD);
		return (DW_DLE_FRAME_VERSION_BAD);
  8004206ead:	b8 16 00 00 00       	mov    $0x16,%eax
  8004206eb2:	e9 d3 02 00 00       	jmpq   800420718a <_dwarf_frame_set_cie+0x461>
	}

	cie->cie_augment = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004206eb7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206ebb:	48 8b 10             	mov    (%rax),%rdx
  8004206ebe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206ec2:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206ec6:	48 01 d0             	add    %rdx,%rax
  8004206ec9:	48 89 c2             	mov    %rax,%rdx
  8004206ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ed0:	48 89 50 28          	mov    %rdx,0x28(%rax)
	p = (char *)dbg->dbg_eh_offset;
  8004206ed4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206ed8:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206edc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while (p[(*off)++] != '\0')
  8004206ee0:	90                   	nop
  8004206ee1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206ee5:	48 8b 00             	mov    (%rax),%rax
  8004206ee8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8004206eec:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004206ef0:	48 89 0a             	mov    %rcx,(%rdx)
  8004206ef3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206ef7:	48 01 d0             	add    %rdx,%rax
  8004206efa:	0f b6 00             	movzbl (%rax),%eax
  8004206efd:	84 c0                	test   %al,%al
  8004206eff:	75 e0                	jne    8004206ee1 <_dwarf_frame_set_cie+0x1b8>
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
  8004206f01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f05:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206f09:	0f b6 00             	movzbl (%rax),%eax
  8004206f0c:	84 c0                	test   %al,%al
  8004206f0e:	74 48                	je     8004206f58 <_dwarf_frame_set_cie+0x22f>
  8004206f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f14:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206f18:	0f b6 00             	movzbl (%rax),%eax
  8004206f1b:	3c 7a                	cmp    $0x7a,%al
  8004206f1d:	74 39                	je     8004206f58 <_dwarf_frame_set_cie+0x22f>
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  8004206f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f23:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004206f27:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  8004206f2b:	75 07                	jne    8004206f34 <_dwarf_frame_set_cie+0x20b>
  8004206f2d:	b8 04 00 00 00       	mov    $0x4,%eax
  8004206f32:	eb 05                	jmp    8004206f39 <_dwarf_frame_set_cie+0x210>
  8004206f34:	b8 0c 00 00 00       	mov    $0xc,%eax
  8004206f39:	48 01 c2             	add    %rax,%rdx
			cie->cie_length;
  8004206f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f40:	48 8b 40 18          	mov    0x18(%rax),%rax
	while (p[(*off)++] != '\0')
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  8004206f44:	48 01 c2             	add    %rax,%rdx
  8004206f47:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206f4b:	48 89 10             	mov    %rdx,(%rax)
			cie->cie_length;
		return (DW_DLE_NONE);
  8004206f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206f53:	e9 32 02 00 00       	jmpq   800420718a <_dwarf_frame_set_cie+0x461>
	}

	/* Optional EH Data field for .eh_frame section. */
	if (strstr((char *)cie->cie_augment, "eh") != NULL)
  8004206f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f5c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206f60:	48 be 65 a1 20 04 80 	movabs $0x800420a165,%rsi
  8004206f67:	00 00 00 
  8004206f6a:	48 89 c7             	mov    %rax,%rdi
  8004206f6d:	48 b8 6b 33 20 04 80 	movabs $0x800420336b,%rax
  8004206f74:	00 00 00 
  8004206f77:	ff d0                	callq  *%rax
  8004206f79:	48 85 c0             	test   %rax,%rax
  8004206f7c:	74 28                	je     8004206fa6 <_dwarf_frame_set_cie+0x27d>
		cie->cie_ehdata = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  8004206f7e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206f82:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206f86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206f8a:	8b 52 28             	mov    0x28(%rdx),%edx
  8004206f8d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8004206f91:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  8004206f95:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206f99:	48 89 cf             	mov    %rcx,%rdi
  8004206f9c:	ff d0                	callq  *%rax
  8004206f9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004206fa2:	48 89 42 30          	mov    %rax,0x30(%rdx)
					    dbg->dbg_pointer_size);

	cie->cie_caf = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004206fa6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206faa:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206fae:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004206fb2:	48 89 d6             	mov    %rdx,%rsi
  8004206fb5:	48 89 c7             	mov    %rax,%rdi
  8004206fb8:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004206fbf:	00 00 00 
  8004206fc2:	ff d0                	callq  *%rax
  8004206fc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004206fc8:	48 89 42 38          	mov    %rax,0x38(%rdx)
	cie->cie_daf = _dwarf_read_sleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004206fcc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206fd0:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206fd4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004206fd8:	48 89 d6             	mov    %rdx,%rsi
  8004206fdb:	48 89 c7             	mov    %rax,%rdi
  8004206fde:	48 b8 b4 39 20 04 80 	movabs $0x80042039b4,%rax
  8004206fe5:	00 00 00 
  8004206fe8:	ff d0                	callq  *%rax
  8004206fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004206fee:	48 89 42 40          	mov    %rax,0x40(%rdx)

	/* Return address register. */
	if (cie->cie_version == 1)
  8004206ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ff6:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  8004206ffa:	66 83 f8 01          	cmp    $0x1,%ax
  8004206ffe:	75 2b                	jne    800420702b <_dwarf_frame_set_cie+0x302>
		cie->cie_ra = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  8004207000:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207004:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004207008:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420700c:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207010:	48 89 d1             	mov    %rdx,%rcx
  8004207013:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004207017:	ba 01 00 00 00       	mov    $0x1,%edx
  800420701c:	48 89 cf             	mov    %rcx,%rdi
  800420701f:	ff d0                	callq  *%rax
  8004207021:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207025:	48 89 42 48          	mov    %rax,0x48(%rdx)
  8004207029:	eb 26                	jmp    8004207051 <_dwarf_frame_set_cie+0x328>
	else
		cie->cie_ra = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420702b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420702f:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207033:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004207037:	48 89 d6             	mov    %rdx,%rsi
  800420703a:	48 89 c7             	mov    %rax,%rdi
  800420703d:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004207044:	00 00 00 
  8004207047:	ff d0                	callq  *%rax
  8004207049:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420704d:	48 89 42 48          	mov    %rax,0x48(%rdx)

	/* Optional CIE augmentation data for .eh_frame section. */
	if (*cie->cie_augment == 'z') {
  8004207051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207055:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004207059:	0f b6 00             	movzbl (%rax),%eax
  800420705c:	3c 7a                	cmp    $0x7a,%al
  800420705e:	0f 85 93 00 00 00    	jne    80042070f7 <_dwarf_frame_set_cie+0x3ce>
		cie->cie_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004207064:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207068:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420706c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004207070:	48 89 d6             	mov    %rdx,%rsi
  8004207073:	48 89 c7             	mov    %rax,%rdi
  8004207076:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  800420707d:	00 00 00 
  8004207080:	ff d0                	callq  *%rax
  8004207082:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207086:	48 89 42 50          	mov    %rax,0x50(%rdx)
		cie->cie_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420708a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420708e:	48 8b 10             	mov    (%rax),%rdx
  8004207091:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207095:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207099:	48 01 d0             	add    %rdx,%rax
  800420709c:	48 89 c2             	mov    %rax,%rdx
  800420709f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070a3:	48 89 50 58          	mov    %rdx,0x58(%rax)
		*off += cie->cie_auglen;
  80042070a7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042070ab:	48 8b 10             	mov    (%rax),%rdx
  80042070ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070b2:	48 8b 40 50          	mov    0x50(%rax),%rax
  80042070b6:	48 01 c2             	add    %rax,%rdx
  80042070b9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042070bd:	48 89 10             	mov    %rdx,(%rax)
		/*
		 * XXX Use DW_EH_PE_absptr for default FDE PC start/range,
		 * in case _dwarf_frame_parse_lsb_cie_augment fails to
		 * find out the real encode.
		 */
		cie->cie_fde_encode = DW_EH_PE_absptr;
  80042070c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070c4:	c6 40 60 00          	movb   $0x0,0x60(%rax)
		ret = _dwarf_frame_parse_lsb_cie_augment(dbg, cie, error);
  80042070c8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80042070cc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042070d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042070d4:	48 89 ce             	mov    %rcx,%rsi
  80042070d7:	48 89 c7             	mov    %rax,%rdi
  80042070da:	48 b8 de 6b 20 04 80 	movabs $0x8004206bde,%rax
  80042070e1:	00 00 00 
  80042070e4:	ff d0                	callq  *%rax
  80042070e6:	89 45 dc             	mov    %eax,-0x24(%rbp)
		if (ret != DW_DLE_NONE)
  80042070e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042070ed:	74 08                	je     80042070f7 <_dwarf_frame_set_cie+0x3ce>
			return (ret);
  80042070ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042070f2:	e9 93 00 00 00       	jmpq   800420718a <_dwarf_frame_set_cie+0x461>
	}

	/* CIE Initial instructions. */
	cie->cie_initinst = (uint8_t *)dbg->dbg_eh_offset + *off;
  80042070f7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042070fb:	48 8b 10             	mov    (%rax),%rdx
  80042070fe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207102:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207106:	48 01 d0             	add    %rdx,%rax
  8004207109:	48 89 c2             	mov    %rax,%rdx
  800420710c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207110:	48 89 50 68          	mov    %rdx,0x68(%rax)
	if (dwarf_size == 4)
  8004207114:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  8004207118:	75 2a                	jne    8004207144 <_dwarf_frame_set_cie+0x41b>
		cie->cie_instlen = cie->cie_offset + 4 + length - *off;
  800420711a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420711e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207126:	48 01 c2             	add    %rax,%rdx
  8004207129:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420712d:	48 8b 00             	mov    (%rax),%rax
  8004207130:	48 29 c2             	sub    %rax,%rdx
  8004207133:	48 89 d0             	mov    %rdx,%rax
  8004207136:	48 8d 50 04          	lea    0x4(%rax),%rdx
  800420713a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420713e:	48 89 50 70          	mov    %rdx,0x70(%rax)
  8004207142:	eb 28                	jmp    800420716c <_dwarf_frame_set_cie+0x443>
	else
		cie->cie_instlen = cie->cie_offset + 12 + length - *off;
  8004207144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207148:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420714c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207150:	48 01 c2             	add    %rax,%rdx
  8004207153:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207157:	48 8b 00             	mov    (%rax),%rax
  800420715a:	48 29 c2             	sub    %rax,%rdx
  800420715d:	48 89 d0             	mov    %rdx,%rax
  8004207160:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  8004207164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207168:	48 89 50 70          	mov    %rdx,0x70(%rax)

	*off += cie->cie_instlen;
  800420716c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207170:	48 8b 10             	mov    (%rax),%rdx
  8004207173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207177:	48 8b 40 70          	mov    0x70(%rax),%rax
  800420717b:	48 01 c2             	add    %rax,%rdx
  800420717e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207182:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  8004207185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420718a:	c9                   	leaveq 
  800420718b:	c3                   	retq   

000000800420718c <_dwarf_frame_set_fde>:

static int
_dwarf_frame_set_fde(Dwarf_Debug dbg, Dwarf_Fde ret_fde, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, int eh_frame, Dwarf_Cie cie, Dwarf_Error *error)
{
  800420718c:	55                   	push   %rbp
  800420718d:	48 89 e5             	mov    %rsp,%rbp
  8004207190:	48 83 ec 70          	sub    $0x70,%rsp
  8004207194:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004207198:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420719c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80042071a0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  80042071a4:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
  80042071a8:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Fde fde;
	Dwarf_Unsigned cieoff;
	uint64_t length, val;
	int dwarf_size, ret;

	fde = ret_fde;
  80042071ac:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042071b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	fde->fde_dbg = dbg;
  80042071b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042071bc:	48 89 10             	mov    %rdx,(%rax)
	fde->fde_addr = (uint8_t *)dbg->dbg_eh_offset + *off;
  80042071bf:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042071c3:	48 8b 10             	mov    (%rax),%rdx
  80042071c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042071ca:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042071ce:	48 01 d0             	add    %rdx,%rax
  80042071d1:	48 89 c2             	mov    %rax,%rdx
  80042071d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071d8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	fde->fde_offset = *off;
  80042071dc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042071e0:	48 8b 10             	mov    (%rax),%rdx
  80042071e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071e7:	48 89 50 18          	mov    %rdx,0x18(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  80042071eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042071ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042071f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042071f7:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042071fb:	48 89 d1             	mov    %rdx,%rcx
  80042071fe:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004207202:	ba 04 00 00 00       	mov    $0x4,%edx
  8004207207:	48 89 cf             	mov    %rcx,%rdi
  800420720a:	ff d0                	callq  *%rax
  800420720c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  8004207210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207215:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8004207219:	75 2e                	jne    8004207249 <_dwarf_frame_set_fde+0xbd>
		dwarf_size = 8;
  800420721b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  8004207222:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207226:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420722a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420722e:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207232:	48 89 d1             	mov    %rdx,%rcx
  8004207235:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004207239:	ba 08 00 00 00       	mov    $0x8,%edx
  800420723e:	48 89 cf             	mov    %rcx,%rdi
  8004207241:	ff d0                	callq  *%rax
  8004207243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004207247:	eb 07                	jmp    8004207250 <_dwarf_frame_set_fde+0xc4>
	} else
		dwarf_size = 4;
  8004207249:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  8004207250:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207254:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004207258:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420725c:	48 8b 00             	mov    (%rax),%rax
  800420725f:	48 29 c2             	sub    %rax,%rdx
  8004207262:	48 89 d0             	mov    %rdx,%rax
  8004207265:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004207269:	73 0a                	jae    8004207275 <_dwarf_frame_set_fde+0xe9>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  800420726b:	b8 12 00 00 00       	mov    $0x12,%eax
  8004207270:	e9 ca 02 00 00       	jmpq   800420753f <_dwarf_frame_set_fde+0x3b3>
	}

	fde->fde_length = length;
  8004207275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207279:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420727d:	48 89 50 20          	mov    %rdx,0x20(%rax)

	if (eh_frame) {
  8004207281:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004207285:	74 5e                	je     80042072e5 <_dwarf_frame_set_fde+0x159>
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  8004207287:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420728b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420728f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207293:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207297:	48 89 d1             	mov    %rdx,%rcx
  800420729a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420729e:	ba 04 00 00 00       	mov    $0x4,%edx
  80042072a3:	48 89 cf             	mov    %rcx,%rdi
  80042072a6:	ff d0                	callq  *%rax
  80042072a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042072ac:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = *off - (4 + fde->fde_cieoff);
  80042072b0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042072b4:	48 8b 10             	mov    (%rax),%rdx
  80042072b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072bb:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042072bf:	48 29 c2             	sub    %rax,%rdx
  80042072c2:	48 89 d0             	mov    %rdx,%rax
  80042072c5:	48 83 e8 04          	sub    $0x4,%rax
  80042072c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		/* This delta should never be 0. */
		if (cieoff == fde->fde_offset) {
  80042072cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042072d5:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042072d9:	75 3d                	jne    8004207318 <_dwarf_frame_set_fde+0x18c>
			DWARF_SET_ERROR(dbg, error, DW_DLE_NO_CIE_FOR_FDE);
			return (DW_DLE_NO_CIE_FOR_FDE);
  80042072db:	b8 13 00 00 00       	mov    $0x13,%eax
  80042072e0:	e9 5a 02 00 00       	jmpq   800420753f <_dwarf_frame_set_fde+0x3b3>
		}
	} else {
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size);
  80042072e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042072e9:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042072ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042072f1:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042072f5:	48 89 d1             	mov    %rdx,%rcx
  80042072f8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042072fb:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042072ff:	48 89 cf             	mov    %rcx,%rdi
  8004207302:	ff d0                	callq  *%rax
  8004207304:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207308:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = fde->fde_cieoff;
  800420730c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207310:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004207314:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	}

	if (eh_frame) {
  8004207318:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420731c:	0f 84 c9 00 00 00    	je     80042073eb <_dwarf_frame_set_fde+0x25f>
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  8004207322:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207326:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420732a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420732e:	48 8b 00             	mov    (%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004207331:	4c 8d 0c 02          	lea    (%rdx,%rax,1),%r9
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  8004207335:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004207339:	0f b6 40 60          	movzbl 0x60(%rax),%eax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420733d:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  8004207341:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207345:	48 8b 40 38          	mov    0x38(%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004207349:	48 89 c2             	mov    %rax,%rdx
  800420734c:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  8004207350:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8004207354:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207358:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  800420735c:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004207360:	48 89 c7             	mov    %rax,%rdi
  8004207363:	48 b8 c4 69 20 04 80 	movabs $0x80042069c4,%rax
  800420736a:	00 00 00 
  800420736d:	ff d0                	callq  *%rax
  800420736f:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
		if (ret != DW_DLE_NONE)
  8004207372:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004207376:	74 08                	je     8004207380 <_dwarf_frame_set_fde+0x1f4>
			return (ret);
  8004207378:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420737b:	e9 bf 01 00 00       	jmpq   800420753f <_dwarf_frame_set_fde+0x3b3>
		fde->fde_initloc = val;
  8004207380:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207388:	48 89 50 30          	mov    %rdx,0x30(%rax)
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
  800420738c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004207390:	0f b6 40 60          	movzbl 0x60(%rax),%eax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004207394:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  8004207398:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420739c:	48 8b 40 38          	mov    0x38(%rax),%rax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  80042073a0:	48 89 c2             	mov    %rax,%rdx
  80042073a3:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  80042073a7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80042073ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042073af:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  80042073b3:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042073b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80042073bd:	48 89 c7             	mov    %rax,%rdi
  80042073c0:	48 b8 c4 69 20 04 80 	movabs $0x80042069c4,%rax
  80042073c7:	00 00 00 
  80042073ca:	ff d0                	callq  *%rax
  80042073cc:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
		if (ret != DW_DLE_NONE)
  80042073cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042073d3:	74 08                	je     80042073dd <_dwarf_frame_set_fde+0x251>
			return (ret);
  80042073d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042073d8:	e9 62 01 00 00       	jmpq   800420753f <_dwarf_frame_set_fde+0x3b3>
		fde->fde_adrange = val;
  80042073dd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042073e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042073e5:	48 89 50 38          	mov    %rdx,0x38(%rax)
  80042073e9:	eb 50                	jmp    800420743b <_dwarf_frame_set_fde+0x2af>
	} else {
		fde->fde_initloc = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  80042073eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042073ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042073f3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042073f7:	8b 52 28             	mov    0x28(%rdx),%edx
  80042073fa:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80042073fe:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  8004207402:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004207406:	48 89 cf             	mov    %rcx,%rdi
  8004207409:	ff d0                	callq  *%rax
  800420740b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420740f:	48 89 42 30          	mov    %rax,0x30(%rdx)
					     dbg->dbg_pointer_size);
		fde->fde_adrange = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  8004207413:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207417:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420741b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420741f:	8b 52 28             	mov    0x28(%rdx),%edx
  8004207422:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8004207426:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  800420742a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420742e:	48 89 cf             	mov    %rcx,%rdi
  8004207431:	ff d0                	callq  *%rax
  8004207433:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207437:	48 89 42 38          	mov    %rax,0x38(%rdx)
					     dbg->dbg_pointer_size);
	}

	/* Optional FDE augmentation data for .eh_frame section. (ignored) */
	if (eh_frame && *cie->cie_augment == 'z') {
  800420743b:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420743f:	74 6b                	je     80042074ac <_dwarf_frame_set_fde+0x320>
  8004207441:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004207445:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004207449:	0f b6 00             	movzbl (%rax),%eax
  800420744c:	3c 7a                	cmp    $0x7a,%al
  800420744e:	75 5c                	jne    80042074ac <_dwarf_frame_set_fde+0x320>
		fde->fde_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004207450:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207454:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207458:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800420745c:	48 89 d6             	mov    %rdx,%rsi
  800420745f:	48 89 c7             	mov    %rax,%rdi
  8004207462:	48 b8 58 3a 20 04 80 	movabs $0x8004203a58,%rax
  8004207469:	00 00 00 
  800420746c:	ff d0                	callq  *%rax
  800420746e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207472:	48 89 42 40          	mov    %rax,0x40(%rdx)
		fde->fde_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004207476:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420747a:	48 8b 10             	mov    (%rax),%rdx
  800420747d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207481:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207485:	48 01 d0             	add    %rdx,%rax
  8004207488:	48 89 c2             	mov    %rax,%rdx
  800420748b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420748f:	48 89 50 48          	mov    %rdx,0x48(%rax)
		*off += fde->fde_auglen;
  8004207493:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207497:	48 8b 10             	mov    (%rax),%rdx
  800420749a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420749e:	48 8b 40 40          	mov    0x40(%rax),%rax
  80042074a2:	48 01 c2             	add    %rax,%rdx
  80042074a5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042074a9:	48 89 10             	mov    %rdx,(%rax)
	}

	fde->fde_inst = (uint8_t *)dbg->dbg_eh_offset + *off;
  80042074ac:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042074b0:	48 8b 10             	mov    (%rax),%rdx
  80042074b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042074b7:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042074bb:	48 01 d0             	add    %rdx,%rax
  80042074be:	48 89 c2             	mov    %rax,%rdx
  80042074c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042074c5:	48 89 50 50          	mov    %rdx,0x50(%rax)
	if (dwarf_size == 4)
  80042074c9:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  80042074cd:	75 2a                	jne    80042074f9 <_dwarf_frame_set_fde+0x36d>
		fde->fde_instlen = fde->fde_offset + 4 + length - *off;
  80042074cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042074d3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042074d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042074db:	48 01 c2             	add    %rax,%rdx
  80042074de:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042074e2:	48 8b 00             	mov    (%rax),%rax
  80042074e5:	48 29 c2             	sub    %rax,%rdx
  80042074e8:	48 89 d0             	mov    %rdx,%rax
  80042074eb:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80042074ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042074f3:	48 89 50 58          	mov    %rdx,0x58(%rax)
  80042074f7:	eb 28                	jmp    8004207521 <_dwarf_frame_set_fde+0x395>
	else
		fde->fde_instlen = fde->fde_offset + 12 + length - *off;
  80042074f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042074fd:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004207501:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207505:	48 01 c2             	add    %rax,%rdx
  8004207508:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420750c:	48 8b 00             	mov    (%rax),%rax
  800420750f:	48 29 c2             	sub    %rax,%rdx
  8004207512:	48 89 d0             	mov    %rdx,%rax
  8004207515:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  8004207519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420751d:	48 89 50 58          	mov    %rdx,0x58(%rax)

	*off += fde->fde_instlen;
  8004207521:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207525:	48 8b 10             	mov    (%rax),%rdx
  8004207528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420752c:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004207530:	48 01 c2             	add    %rax,%rdx
  8004207533:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207537:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  800420753a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420753f:	c9                   	leaveq 
  8004207540:	c3                   	retq   

0000008004207541 <_dwarf_frame_interal_table_init>:


int
_dwarf_frame_interal_table_init(Dwarf_Debug dbg, Dwarf_Error *error)
{
  8004207541:	55                   	push   %rbp
  8004207542:	48 89 e5             	mov    %rsp,%rbp
  8004207545:	48 83 ec 20          	sub    $0x20,%rsp
  8004207549:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420754d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	Dwarf_Regtable3 *rt = &global_rt_table;
  8004207551:	48 b8 e0 cc 21 04 80 	movabs $0x800421cce0,%rax
  8004207558:	00 00 00 
  800420755b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (dbg->dbg_internal_reg_table != NULL)
  800420755f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207563:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004207567:	48 85 c0             	test   %rax,%rax
  800420756a:	74 07                	je     8004207573 <_dwarf_frame_interal_table_init+0x32>
		return (DW_DLE_NONE);
  800420756c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207571:	eb 33                	jmp    80042075a6 <_dwarf_frame_interal_table_init+0x65>

	rt->rt3_reg_table_size = dbg->dbg_frame_rule_table_size;
  8004207573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207577:	0f b7 50 48          	movzwl 0x48(%rax),%edx
  800420757b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420757f:	66 89 50 18          	mov    %dx,0x18(%rax)
	rt->rt3_rules = global_rules;
  8004207583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207587:	48 b9 00 d5 21 04 80 	movabs $0x800421d500,%rcx
  800420758e:	00 00 00 
  8004207591:	48 89 48 20          	mov    %rcx,0x20(%rax)

	dbg->dbg_internal_reg_table = rt;
  8004207595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207599:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420759d:	48 89 50 58          	mov    %rdx,0x58(%rax)

	return (DW_DLE_NONE);
  80042075a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042075a6:	c9                   	leaveq 
  80042075a7:	c3                   	retq   

00000080042075a8 <_dwarf_get_next_fde>:

static int
_dwarf_get_next_fde(Dwarf_Debug dbg,
		    int eh_frame, Dwarf_Error *error, Dwarf_Fde ret_fde)
{
  80042075a8:	55                   	push   %rbp
  80042075a9:	48 89 e5             	mov    %rsp,%rbp
  80042075ac:	48 83 ec 60          	sub    $0x60,%rsp
  80042075b0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80042075b4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80042075b7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80042075bb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	Dwarf_Section *ds = &debug_frame_sec; 
  80042075bf:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  80042075c6:	00 00 00 
  80042075c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint64_t length, offset, cie_id, entry_off;
	int dwarf_size, i, ret=-1;
  80042075cd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%rbp)

	offset = dbg->curr_off_eh;
  80042075d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042075d8:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042075dc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (offset < dbg->dbg_eh_size) {
  80042075e0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042075e4:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80042075e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042075ec:	48 39 c2             	cmp    %rax,%rdx
  80042075ef:	0f 86 fe 01 00 00    	jbe    80042077f3 <_dwarf_get_next_fde+0x24b>
		entry_off = offset;
  80042075f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042075f9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 4);
  80042075fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207601:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004207605:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207609:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420760d:	48 89 d1             	mov    %rdx,%rcx
  8004207610:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8004207614:	ba 04 00 00 00       	mov    $0x4,%edx
  8004207619:	48 89 cf             	mov    %rcx,%rdi
  800420761c:	ff d0                	callq  *%rax
  800420761e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (length == 0xffffffff) {
  8004207622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207627:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800420762b:	75 2e                	jne    800420765b <_dwarf_get_next_fde+0xb3>
			dwarf_size = 8;
  800420762d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
			length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 8);
  8004207634:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207638:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420763c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207640:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207644:	48 89 d1             	mov    %rdx,%rcx
  8004207647:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800420764b:	ba 08 00 00 00       	mov    $0x8,%edx
  8004207650:	48 89 cf             	mov    %rcx,%rdi
  8004207653:	ff d0                	callq  *%rax
  8004207655:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004207659:	eb 07                	jmp    8004207662 <_dwarf_get_next_fde+0xba>
		} else
			dwarf_size = 4;
  800420765b:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

		if (length > dbg->dbg_eh_size - offset || (length == 0 && !eh_frame)) {
  8004207662:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207666:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800420766a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420766e:	48 29 c2             	sub    %rax,%rdx
  8004207671:	48 89 d0             	mov    %rdx,%rax
  8004207674:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004207678:	72 0d                	jb     8004207687 <_dwarf_get_next_fde+0xdf>
  800420767a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420767f:	75 10                	jne    8004207691 <_dwarf_get_next_fde+0xe9>
  8004207681:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004207685:	75 0a                	jne    8004207691 <_dwarf_get_next_fde+0xe9>
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_DEBUG_FRAME_LENGTH_BAD);
			return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  8004207687:	b8 12 00 00 00       	mov    $0x12,%eax
  800420768c:	e9 67 01 00 00       	jmpq   80042077f8 <_dwarf_get_next_fde+0x250>
		}

		/* Check terminator for .eh_frame */
		if (eh_frame && length == 0)
  8004207691:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004207695:	74 11                	je     80042076a8 <_dwarf_get_next_fde+0x100>
  8004207697:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420769c:	75 0a                	jne    80042076a8 <_dwarf_get_next_fde+0x100>
			return(-1);
  800420769e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042076a3:	e9 50 01 00 00       	jmpq   80042077f8 <_dwarf_get_next_fde+0x250>

		cie_id = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, dwarf_size);
  80042076a8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042076ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042076b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042076b4:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042076b8:	48 89 d1             	mov    %rdx,%rcx
  80042076bb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042076be:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80042076c2:	48 89 cf             	mov    %rcx,%rdi
  80042076c5:	ff d0                	callq  *%rax
  80042076c7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

		if (eh_frame) {
  80042076cb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80042076cf:	74 79                	je     800420774a <_dwarf_get_next_fde+0x1a2>
			/* GNU .eh_frame use CIE id 0. */
			if (cie_id == 0)
  80042076d1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80042076d6:	75 32                	jne    800420770a <_dwarf_get_next_fde+0x162>
				ret = _dwarf_frame_set_cie(dbg, ds,
  80042076d8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042076dc:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80042076e0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80042076e4:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80042076e8:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  80042076ec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042076f0:	49 89 f8             	mov    %rdi,%r8
  80042076f3:	48 89 c7             	mov    %rax,%rdi
  80042076f6:	48 b8 29 6d 20 04 80 	movabs $0x8004206d29,%rax
  80042076fd:	00 00 00 
  8004207700:	ff d0                	callq  *%rax
  8004207702:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8004207705:	e9 c8 00 00 00       	jmpq   80042077d2 <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg,ret_fde, ds,
  800420770a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420770e:	4c 8b 40 08          	mov    0x8(%rax),%r8
  8004207712:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8004207716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420771a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420771e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207722:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004207726:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420772a:	4d 89 c1             	mov    %r8,%r9
  800420772d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8004207733:	48 89 c7             	mov    %rax,%rdi
  8004207736:	48 b8 8c 71 20 04 80 	movabs $0x800420718c,%rax
  800420773d:	00 00 00 
  8004207740:	ff d0                	callq  *%rax
  8004207742:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8004207745:	e9 88 00 00 00       	jmpq   80042077d2 <_dwarf_get_next_fde+0x22a>
							   &entry_off, 1, ret_fde->fde_cie, error);
		} else {
			/* .dwarf_frame use CIE id ~0 */
			if ((dwarf_size == 4 && cie_id == ~0U) ||
  800420774a:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420774e:	75 0b                	jne    800420775b <_dwarf_get_next_fde+0x1b3>
  8004207750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207755:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8004207759:	74 0d                	je     8004207768 <_dwarf_get_next_fde+0x1c0>
  800420775b:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  800420775f:	75 36                	jne    8004207797 <_dwarf_get_next_fde+0x1ef>
			    (dwarf_size == 8 && cie_id == ~0ULL))
  8004207761:	48 83 7d e0 ff       	cmpq   $0xffffffffffffffff,-0x20(%rbp)
  8004207766:	75 2f                	jne    8004207797 <_dwarf_get_next_fde+0x1ef>
				ret = _dwarf_frame_set_cie(dbg, ds,
  8004207768:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420776c:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8004207770:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004207774:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8004207778:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  800420777c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207780:	49 89 f8             	mov    %rdi,%r8
  8004207783:	48 89 c7             	mov    %rax,%rdi
  8004207786:	48 b8 29 6d 20 04 80 	movabs $0x8004206d29,%rax
  800420778d:	00 00 00 
  8004207790:	ff d0                	callq  *%rax
  8004207792:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8004207795:	eb 3b                	jmp    80042077d2 <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg, ret_fde, ds,
  8004207797:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420779b:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420779f:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80042077a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042077a7:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042077ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042077af:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80042077b3:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042077b7:	4d 89 c1             	mov    %r8,%r9
  80042077ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80042077c0:	48 89 c7             	mov    %rax,%rdi
  80042077c3:	48 b8 8c 71 20 04 80 	movabs $0x800420718c,%rax
  80042077ca:	00 00 00 
  80042077cd:	ff d0                	callq  *%rax
  80042077cf:	89 45 f0             	mov    %eax,-0x10(%rbp)
							   &entry_off, 0, ret_fde->fde_cie, error);
		}

		if (ret != DW_DLE_NONE)
  80042077d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80042077d6:	74 07                	je     80042077df <_dwarf_get_next_fde+0x237>
			return(-1);
  80042077d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042077dd:	eb 19                	jmp    80042077f8 <_dwarf_get_next_fde+0x250>

		offset = entry_off;
  80042077df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042077e3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		dbg->curr_off_eh = offset;
  80042077e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042077eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042077ef:	48 89 50 30          	mov    %rdx,0x30(%rax)
	}

	return (0);
  80042077f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042077f8:	c9                   	leaveq 
  80042077f9:	c3                   	retq   

00000080042077fa <dwarf_set_frame_cfa_value>:

Dwarf_Half
dwarf_set_frame_cfa_value(Dwarf_Debug dbg, Dwarf_Half value)
{
  80042077fa:	55                   	push   %rbp
  80042077fb:	48 89 e5             	mov    %rsp,%rbp
  80042077fe:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004207802:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207806:	89 f0                	mov    %esi,%eax
  8004207808:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Half old_value;

	old_value = dbg->dbg_frame_cfa_value;
  800420780c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207810:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004207814:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
	dbg->dbg_frame_cfa_value = value;
  8004207818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420781c:	0f b7 55 e4          	movzwl -0x1c(%rbp),%edx
  8004207820:	66 89 50 4c          	mov    %dx,0x4c(%rax)

	return (old_value);
  8004207824:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
}
  8004207828:	c9                   	leaveq 
  8004207829:	c3                   	retq   

000000800420782a <dwarf_init_eh_section>:

int dwarf_init_eh_section(Dwarf_Debug dbg, Dwarf_Error *error)
{
  800420782a:	55                   	push   %rbp
  800420782b:	48 89 e5             	mov    %rsp,%rbp
  800420782e:	48 83 ec 10          	sub    $0x10,%rsp
  8004207832:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207836:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	Dwarf_Section *section;

	if (dbg == NULL) {
  800420783a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420783f:	75 0a                	jne    800420784b <dwarf_init_eh_section+0x21>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  8004207841:	b8 01 00 00 00       	mov    $0x1,%eax
  8004207846:	e9 85 00 00 00       	jmpq   80042078d0 <dwarf_init_eh_section+0xa6>
	}

	if (dbg->dbg_internal_reg_table == NULL) {
  800420784b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420784f:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004207853:	48 85 c0             	test   %rax,%rax
  8004207856:	75 25                	jne    800420787d <dwarf_init_eh_section+0x53>
		if (_dwarf_frame_interal_table_init(dbg, error) != DW_DLE_NONE)
  8004207858:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420785c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207860:	48 89 d6             	mov    %rdx,%rsi
  8004207863:	48 89 c7             	mov    %rax,%rdi
  8004207866:	48 b8 41 75 20 04 80 	movabs $0x8004207541,%rax
  800420786d:	00 00 00 
  8004207870:	ff d0                	callq  *%rax
  8004207872:	85 c0                	test   %eax,%eax
  8004207874:	74 07                	je     800420787d <dwarf_init_eh_section+0x53>
			return (DW_DLV_ERROR);
  8004207876:	b8 01 00 00 00       	mov    $0x1,%eax
  800420787b:	eb 53                	jmp    80042078d0 <dwarf_init_eh_section+0xa6>
	}

	_dwarf_find_section_enhanced(&debug_frame_sec);
  800420787d:	48 bf e0 c5 21 04 80 	movabs $0x800421c5e0,%rdi
  8004207884:	00 00 00 
  8004207887:	48 b8 f6 52 20 04 80 	movabs $0x80042052f6,%rax
  800420788e:	00 00 00 
  8004207891:	ff d0                	callq  *%rax

	dbg->curr_off_eh = 0;
  8004207893:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207897:	48 c7 40 30 00 00 00 	movq   $0x0,0x30(%rax)
  800420789e:	00 
	dbg->dbg_eh_offset = debug_frame_sec.ds_addr;
  800420789f:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  80042078a6:	00 00 00 
  80042078a9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042078ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042078b1:	48 89 50 38          	mov    %rdx,0x38(%rax)
	dbg->dbg_eh_size = debug_frame_sec.ds_size;
  80042078b5:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  80042078bc:	00 00 00 
  80042078bf:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042078c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042078c7:	48 89 50 40          	mov    %rdx,0x40(%rax)

	return (DW_DLV_OK);
  80042078cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042078d0:	c9                   	leaveq 
  80042078d1:	c3                   	retq   

00000080042078d2 <_dwarf_lineno_run_program>:
int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

static int
_dwarf_lineno_run_program(Dwarf_CU *cu, Dwarf_LineInfo li, uint8_t *p,
			  uint8_t *pe, Dwarf_Addr pc, Dwarf_Error *error)
{
  80042078d2:	55                   	push   %rbp
  80042078d3:	48 89 e5             	mov    %rsp,%rbp
  80042078d6:	53                   	push   %rbx
  80042078d7:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80042078de:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  80042078e2:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  80042078e6:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  80042078ed:	48 89 8d 70 ff ff ff 	mov    %rcx,-0x90(%rbp)
  80042078f4:	4c 89 85 68 ff ff ff 	mov    %r8,-0x98(%rbp)
  80042078fb:	4c 89 8d 60 ff ff ff 	mov    %r9,-0xa0(%rbp)
	uint64_t address, file, line, column, isa, opsize;
	int is_stmt, basic_block, end_sequence;
	int prologue_end, epilogue_begin;
	int ret;

	ln = &li->li_line;
  8004207902:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207906:	48 83 c0 48          	add    $0x48,%rax
  800420790a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	/*
	 *   ln->ln_li     = li;             \
	 * Set registers to their default values.
	 */
	RESET_REGISTERS;
  800420790e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004207915:	00 
  8004207916:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  800420791d:	00 
  800420791e:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  8004207925:	00 
  8004207926:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  800420792d:	00 
  800420792e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207932:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004207936:	0f b6 c0             	movzbl %al,%eax
  8004207939:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800420793c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  8004207943:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  800420794a:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  8004207951:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  8004207958:	e9 0a 05 00 00       	jmpq   8004207e67 <_dwarf_lineno_run_program+0x595>
		if (*p == 0) {
  800420795d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207964:	0f b6 00             	movzbl (%rax),%eax
  8004207967:	84 c0                	test   %al,%al
  8004207969:	0f 85 78 01 00 00    	jne    8004207ae7 <_dwarf_lineno_run_program+0x215>

			/*
			 * Extended Opcodes.
			 */

			p++;
  800420796f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207976:	48 83 c0 01          	add    $0x1,%rax
  800420797a:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
			opsize = _dwarf_decode_uleb128(&p);
  8004207981:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207988:	48 89 c7             	mov    %rax,%rdi
  800420798b:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207992:	00 00 00 
  8004207995:	ff d0                	callq  *%rax
  8004207997:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			switch (*p) {
  800420799b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  80042079a2:	0f b6 00             	movzbl (%rax),%eax
  80042079a5:	0f b6 c0             	movzbl %al,%eax
  80042079a8:	83 f8 02             	cmp    $0x2,%eax
  80042079ab:	74 7a                	je     8004207a27 <_dwarf_lineno_run_program+0x155>
  80042079ad:	83 f8 03             	cmp    $0x3,%eax
  80042079b0:	0f 84 b3 00 00 00    	je     8004207a69 <_dwarf_lineno_run_program+0x197>
  80042079b6:	83 f8 01             	cmp    $0x1,%eax
  80042079b9:	0f 85 09 01 00 00    	jne    8004207ac8 <_dwarf_lineno_run_program+0x1f6>
			case DW_LNE_end_sequence:
				p++;
  80042079bf:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  80042079c6:	48 83 c0 01          	add    $0x1,%rax
  80042079ca:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				end_sequence = 1;
  80042079d1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
				RESET_REGISTERS;
  80042079d8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80042079df:	00 
  80042079e0:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  80042079e7:	00 
  80042079e8:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  80042079ef:	00 
  80042079f0:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80042079f7:	00 
  80042079f8:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  80042079fc:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004207a00:	0f b6 c0             	movzbl %al,%eax
  8004207a03:	89 45 cc             	mov    %eax,-0x34(%rbp)
  8004207a06:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  8004207a0d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  8004207a14:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  8004207a1b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  8004207a22:	e9 bb 00 00 00       	jmpq   8004207ae2 <_dwarf_lineno_run_program+0x210>
			case DW_LNE_set_address:
				p++;
  8004207a27:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207a2e:	48 83 c0 01          	add    $0x1,%rax
  8004207a32:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				address = dbg->decode(&p, cu->addr_size);
  8004207a39:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207a40:	00 00 00 
  8004207a43:	48 8b 00             	mov    (%rax),%rax
  8004207a46:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004207a4a:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  8004207a4e:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  8004207a52:	0f b6 ca             	movzbl %dl,%ecx
  8004207a55:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  8004207a5c:	89 ce                	mov    %ecx,%esi
  8004207a5e:	48 89 d7             	mov    %rdx,%rdi
  8004207a61:	ff d0                	callq  *%rax
  8004207a63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				break;
  8004207a67:	eb 79                	jmp    8004207ae2 <_dwarf_lineno_run_program+0x210>
			case DW_LNE_define_file:
				p++;
  8004207a69:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207a70:	48 83 c0 01          	add    $0x1,%rax
  8004207a74:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				ret = _dwarf_lineno_add_file(li, &p, NULL,
  8004207a7b:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207a82:	00 00 00 
  8004207a85:	48 8b 08             	mov    (%rax),%rcx
  8004207a88:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004207a8f:	48 8d b5 78 ff ff ff 	lea    -0x88(%rbp),%rsi
  8004207a96:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207a9a:	49 89 c8             	mov    %rcx,%r8
  8004207a9d:	48 89 d1             	mov    %rdx,%rcx
  8004207aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004207aa5:	48 89 c7             	mov    %rax,%rdi
  8004207aa8:	48 b8 8a 7e 20 04 80 	movabs $0x8004207e8a,%rax
  8004207aaf:	00 00 00 
  8004207ab2:	ff d0                	callq  *%rax
  8004207ab4:	89 45 a4             	mov    %eax,-0x5c(%rbp)
							     error, dbg);
				if (ret != DW_DLE_NONE)
  8004207ab7:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  8004207abb:	74 09                	je     8004207ac6 <_dwarf_lineno_run_program+0x1f4>
					goto prog_fail;
  8004207abd:	90                   	nop

	return (DW_DLE_NONE);

prog_fail:

	return (ret);
  8004207abe:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8004207ac1:	e9 ba 03 00 00       	jmpq   8004207e80 <_dwarf_lineno_run_program+0x5ae>
				p++;
				ret = _dwarf_lineno_add_file(li, &p, NULL,
							     error, dbg);
				if (ret != DW_DLE_NONE)
					goto prog_fail;
				break;
  8004207ac6:	eb 1a                	jmp    8004207ae2 <_dwarf_lineno_run_program+0x210>
			default:
				/* Unrecognized extened opcodes. */
				p += opsize;
  8004207ac8:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004207acf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207ad3:	48 01 d0             	add    %rdx,%rax
  8004207ad6:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  8004207add:	e9 85 03 00 00       	jmpq   8004207e67 <_dwarf_lineno_run_program+0x595>
  8004207ae2:	e9 80 03 00 00       	jmpq   8004207e67 <_dwarf_lineno_run_program+0x595>
			}

		} else if (*p > 0 && *p < li->li_opbase) {
  8004207ae7:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207aee:	0f b6 00             	movzbl (%rax),%eax
  8004207af1:	84 c0                	test   %al,%al
  8004207af3:	0f 84 3c 02 00 00    	je     8004207d35 <_dwarf_lineno_run_program+0x463>
  8004207af9:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b00:	0f b6 10             	movzbl (%rax),%edx
  8004207b03:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207b07:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207b0b:	38 c2                	cmp    %al,%dl
  8004207b0d:	0f 83 22 02 00 00    	jae    8004207d35 <_dwarf_lineno_run_program+0x463>

			/*
			 * Standard Opcodes.
			 */

			switch (*p++) {
  8004207b13:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b1a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207b1e:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  8004207b25:	0f b6 00             	movzbl (%rax),%eax
  8004207b28:	0f b6 c0             	movzbl %al,%eax
  8004207b2b:	83 f8 0c             	cmp    $0xc,%eax
  8004207b2e:	0f 87 fb 01 00 00    	ja     8004207d2f <_dwarf_lineno_run_program+0x45d>
  8004207b34:	89 c0                	mov    %eax,%eax
  8004207b36:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004207b3d:	00 
  8004207b3e:	48 b8 68 a1 20 04 80 	movabs $0x800420a168,%rax
  8004207b45:	00 00 00 
  8004207b48:	48 01 d0             	add    %rdx,%rax
  8004207b4b:	48 8b 00             	mov    (%rax),%rax
  8004207b4e:	ff e0                	jmpq   *%rax
			case DW_LNS_copy:
				APPEND_ROW;
  8004207b50:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004207b57:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004207b5b:	73 0a                	jae    8004207b67 <_dwarf_lineno_run_program+0x295>
  8004207b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207b62:	e9 19 03 00 00       	jmpq   8004207e80 <_dwarf_lineno_run_program+0x5ae>
  8004207b67:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207b6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207b6f:	48 89 10             	mov    %rdx,(%rax)
  8004207b72:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207b76:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  8004207b7d:	00 
  8004207b7e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207b82:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207b86:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004207b8a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207b8e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004207b92:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004207b96:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207b9a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207b9e:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004207ba2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207ba6:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8004207ba9:	89 50 28             	mov    %edx,0x28(%rax)
  8004207bac:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207bb0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004207bb3:	89 50 2c             	mov    %edx,0x2c(%rax)
  8004207bb6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207bba:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004207bbd:	89 50 30             	mov    %edx,0x30(%rax)
  8004207bc0:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207bc4:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8004207bcb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207bcf:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207bd3:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
				basic_block = 0;
  8004207bda:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
				prologue_end = 0;
  8004207be1:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
				epilogue_begin = 0;
  8004207be8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  8004207bef:	e9 3c 01 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  8004207bf4:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207bfb:	48 89 c7             	mov    %rax,%rdi
  8004207bfe:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207c05:	00 00 00 
  8004207c08:	ff d0                	callq  *%rax
					li->li_minlen;
  8004207c0a:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004207c0e:	0f b6 52 18          	movzbl 0x18(%rdx),%edx
				basic_block = 0;
				prologue_end = 0;
				epilogue_begin = 0;
				break;
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  8004207c12:	0f b6 d2             	movzbl %dl,%edx
  8004207c15:	48 0f af c2          	imul   %rdx,%rax
  8004207c19:	48 01 45 e8          	add    %rax,-0x18(%rbp)
					li->li_minlen;
				break;
  8004207c1d:	e9 0e 01 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_line:
				line += _dwarf_decode_sleb128(&p);
  8004207c22:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207c29:	48 89 c7             	mov    %rax,%rdi
  8004207c2c:	48 b8 d7 3a 20 04 80 	movabs $0x8004203ad7,%rax
  8004207c33:	00 00 00 
  8004207c36:	ff d0                	callq  *%rax
  8004207c38:	48 01 45 d8          	add    %rax,-0x28(%rbp)
				break;
  8004207c3c:	e9 ef 00 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_file:
				file = _dwarf_decode_uleb128(&p);
  8004207c41:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207c48:	48 89 c7             	mov    %rax,%rdi
  8004207c4b:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207c52:	00 00 00 
  8004207c55:	ff d0                	callq  *%rax
  8004207c57:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
				break;
  8004207c5b:	e9 d0 00 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_column:
				column = _dwarf_decode_uleb128(&p);
  8004207c60:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207c67:	48 89 c7             	mov    %rax,%rdi
  8004207c6a:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207c71:	00 00 00 
  8004207c74:	ff d0                	callq  *%rax
  8004207c76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
				break;
  8004207c7a:	e9 b1 00 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_negate_stmt:
				is_stmt = !is_stmt;
  8004207c7f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004207c83:	0f 94 c0             	sete   %al
  8004207c86:	0f b6 c0             	movzbl %al,%eax
  8004207c89:	89 45 cc             	mov    %eax,-0x34(%rbp)
				break;
  8004207c8c:	e9 9f 00 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_basic_block:
				basic_block = 1;
  8004207c91:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%rbp)
				break;
  8004207c98:	e9 93 00 00 00       	jmpq   8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_const_add_pc:
				address += ADDRESS(255);
  8004207c9d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207ca1:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207ca5:	0f b6 c0             	movzbl %al,%eax
  8004207ca8:	ba ff 00 00 00       	mov    $0xff,%edx
  8004207cad:	89 d1                	mov    %edx,%ecx
  8004207caf:	29 c1                	sub    %eax,%ecx
  8004207cb1:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207cb5:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207cb9:	0f b6 d8             	movzbl %al,%ebx
  8004207cbc:	89 c8                	mov    %ecx,%eax
  8004207cbe:	99                   	cltd   
  8004207cbf:	f7 fb                	idiv   %ebx
  8004207cc1:	89 c2                	mov    %eax,%edx
  8004207cc3:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207cc7:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  8004207ccb:	0f b6 c0             	movzbl %al,%eax
  8004207cce:	0f af c2             	imul   %edx,%eax
  8004207cd1:	48 98                	cltq   
  8004207cd3:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  8004207cd7:	eb 57                	jmp    8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_fixed_advance_pc:
				address += dbg->decode(&p, 2);
  8004207cd9:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207ce0:	00 00 00 
  8004207ce3:	48 8b 00             	mov    (%rax),%rax
  8004207ce6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004207cea:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  8004207cf1:	be 02 00 00 00       	mov    $0x2,%esi
  8004207cf6:	48 89 d7             	mov    %rdx,%rdi
  8004207cf9:	ff d0                	callq  *%rax
  8004207cfb:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  8004207cff:	eb 2f                	jmp    8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_prologue_end:
				prologue_end = 1;
  8004207d01:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%rbp)
				break;
  8004207d08:	eb 26                	jmp    8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_epilogue_begin:
				epilogue_begin = 1;
  8004207d0a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%rbp)
				break;
  8004207d11:	eb 1d                	jmp    8004207d30 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_isa:
				isa = _dwarf_decode_uleb128(&p);
  8004207d13:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207d1a:	48 89 c7             	mov    %rax,%rdi
  8004207d1d:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207d24:	00 00 00 
  8004207d27:	ff d0                	callq  *%rax
  8004207d29:	48 89 45 98          	mov    %rax,-0x68(%rbp)
				break;
  8004207d2d:	eb 01                	jmp    8004207d30 <_dwarf_lineno_run_program+0x45e>
			default:
				/* Unrecognized extened opcodes. What to do? */
				break;
  8004207d2f:	90                   	nop
			}

		} else {
  8004207d30:	e9 32 01 00 00       	jmpq   8004207e67 <_dwarf_lineno_run_program+0x595>

			/*
			 * Special Opcodes.
			 */

			line += LINE(*p);
  8004207d35:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d39:	0f b6 40 1a          	movzbl 0x1a(%rax),%eax
  8004207d3d:	0f be c8             	movsbl %al,%ecx
  8004207d40:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207d47:	0f b6 00             	movzbl (%rax),%eax
  8004207d4a:	0f b6 d0             	movzbl %al,%edx
  8004207d4d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d51:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207d55:	0f b6 c0             	movzbl %al,%eax
  8004207d58:	29 c2                	sub    %eax,%edx
  8004207d5a:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d5e:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207d62:	0f b6 f0             	movzbl %al,%esi
  8004207d65:	89 d0                	mov    %edx,%eax
  8004207d67:	99                   	cltd   
  8004207d68:	f7 fe                	idiv   %esi
  8004207d6a:	89 d0                	mov    %edx,%eax
  8004207d6c:	01 c8                	add    %ecx,%eax
  8004207d6e:	48 98                	cltq   
  8004207d70:	48 01 45 d8          	add    %rax,-0x28(%rbp)
			address += ADDRESS(*p);
  8004207d74:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207d7b:	0f b6 00             	movzbl (%rax),%eax
  8004207d7e:	0f b6 d0             	movzbl %al,%edx
  8004207d81:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d85:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207d89:	0f b6 c0             	movzbl %al,%eax
  8004207d8c:	89 d1                	mov    %edx,%ecx
  8004207d8e:	29 c1                	sub    %eax,%ecx
  8004207d90:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d94:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207d98:	0f b6 d8             	movzbl %al,%ebx
  8004207d9b:	89 c8                	mov    %ecx,%eax
  8004207d9d:	99                   	cltd   
  8004207d9e:	f7 fb                	idiv   %ebx
  8004207da0:	89 c2                	mov    %eax,%edx
  8004207da2:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207da6:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  8004207daa:	0f b6 c0             	movzbl %al,%eax
  8004207dad:	0f af c2             	imul   %edx,%eax
  8004207db0:	48 98                	cltq   
  8004207db2:	48 01 45 e8          	add    %rax,-0x18(%rbp)
			APPEND_ROW;
  8004207db6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004207dbd:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004207dc1:	73 0a                	jae    8004207dcd <_dwarf_lineno_run_program+0x4fb>
  8004207dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207dc8:	e9 b3 00 00 00       	jmpq   8004207e80 <_dwarf_lineno_run_program+0x5ae>
  8004207dcd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207dd1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207dd5:	48 89 10             	mov    %rdx,(%rax)
  8004207dd8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207ddc:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  8004207de3:	00 
  8004207de4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207de8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207dec:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004207df0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207df4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004207df8:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004207dfc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207e00:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207e04:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004207e08:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207e0c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8004207e0f:	89 50 28             	mov    %edx,0x28(%rax)
  8004207e12:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207e16:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004207e19:	89 50 2c             	mov    %edx,0x2c(%rax)
  8004207e1c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207e20:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004207e23:	89 50 30             	mov    %edx,0x30(%rax)
  8004207e26:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207e2a:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8004207e31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207e35:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207e39:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
			basic_block = 0;
  8004207e40:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
			prologue_end = 0;
  8004207e47:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
			epilogue_begin = 0;
  8004207e4e:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
			p++;
  8004207e55:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207e5c:	48 83 c0 01          	add    $0x1,%rax
  8004207e60:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
	RESET_REGISTERS;

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  8004207e67:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207e6e:	48 3b 85 70 ff ff ff 	cmp    -0x90(%rbp),%rax
  8004207e75:	0f 82 e2 fa ff ff    	jb     800420795d <_dwarf_lineno_run_program+0x8b>
			epilogue_begin = 0;
			p++;
		}
	}

	return (DW_DLE_NONE);
  8004207e7b:	b8 00 00 00 00       	mov    $0x0,%eax

#undef  RESET_REGISTERS
#undef  APPEND_ROW
#undef  LINE
#undef  ADDRESS
}
  8004207e80:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8004207e87:	5b                   	pop    %rbx
  8004207e88:	5d                   	pop    %rbp
  8004207e89:	c3                   	retq   

0000008004207e8a <_dwarf_lineno_add_file>:

static int
_dwarf_lineno_add_file(Dwarf_LineInfo li, uint8_t **p, const char *compdir,
		       Dwarf_Error *error, Dwarf_Debug dbg)
{
  8004207e8a:	55                   	push   %rbp
  8004207e8b:	48 89 e5             	mov    %rsp,%rbp
  8004207e8e:	53                   	push   %rbx
  8004207e8f:	48 83 ec 48          	sub    $0x48,%rsp
  8004207e93:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004207e97:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004207e9b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004207e9f:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  8004207ea3:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
	char *fname;
	//const char *dirname;
	uint8_t *src;
	int slen;

	src = *p;
  8004207ea7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004207eab:	48 8b 00             	mov    (%rax),%rax
  8004207eae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  DWARF_SET_ERROR(dbg, error, DW_DLE_MEMORY);
  return (DW_DLE_MEMORY);
  }
*/  
	//lf->lf_fullpath = NULL;
	fname = (char *) src;
  8004207eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004207eb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	src += strlen(fname) + 1;
  8004207eba:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
  8004207ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207ec2:	48 89 c7             	mov    %rax,%rdi
  8004207ec5:	48 b8 41 2c 20 04 80 	movabs $0x8004202c41,%rax
  8004207ecc:	00 00 00 
  8004207ecf:	ff d0                	callq  *%rax
  8004207ed1:	48 98                	cltq   
  8004207ed3:	48 83 c0 01          	add    $0x1,%rax
  8004207ed7:	48 01 d8             	add    %rbx,%rax
  8004207eda:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	_dwarf_decode_uleb128(&src);
  8004207ede:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8004207ee2:	48 89 c7             	mov    %rax,%rdi
  8004207ee5:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207eec:	00 00 00 
  8004207eef:	ff d0                	callq  *%rax
	   snprintf(lf->lf_fullpath, slen, "%s/%s", dirname,
	   lf->lf_fname);
	   }
	   }
	*/
	_dwarf_decode_uleb128(&src);
  8004207ef1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8004207ef5:	48 89 c7             	mov    %rax,%rdi
  8004207ef8:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207eff:	00 00 00 
  8004207f02:	ff d0                	callq  *%rax
	_dwarf_decode_uleb128(&src);
  8004207f04:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8004207f08:	48 89 c7             	mov    %rax,%rdi
  8004207f0b:	48 b8 69 3b 20 04 80 	movabs $0x8004203b69,%rax
  8004207f12:	00 00 00 
  8004207f15:	ff d0                	callq  *%rax
	//STAILQ_INSERT_TAIL(&li->li_lflist, lf, lf_next);
	//li->li_lflen++;

	*p = src;
  8004207f17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207f1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004207f1f:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  8004207f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004207f27:	48 83 c4 48          	add    $0x48,%rsp
  8004207f2b:	5b                   	pop    %rbx
  8004207f2c:	5d                   	pop    %rbp
  8004207f2d:	c3                   	retq   

0000008004207f2e <_dwarf_lineno_init>:

int     
_dwarf_lineno_init(Dwarf_Die *die, uint64_t offset, Dwarf_LineInfo linfo, Dwarf_Addr pc, Dwarf_Error *error)
{   
  8004207f2e:	55                   	push   %rbp
  8004207f2f:	48 89 e5             	mov    %rsp,%rbp
  8004207f32:	53                   	push   %rbx
  8004207f33:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  8004207f3a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004207f41:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
  8004207f48:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8004207f4f:	48 89 8d 00 ff ff ff 	mov    %rcx,-0x100(%rbp)
  8004207f56:	4c 89 85 f8 fe ff ff 	mov    %r8,-0x108(%rbp)
	Dwarf_Section myds = {.ds_name = ".debug_line"};
  8004207f5d:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
  8004207f64:	00 
  8004207f65:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
  8004207f6c:	00 
  8004207f6d:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
  8004207f74:	00 
  8004207f75:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  8004207f7c:	00 
  8004207f7d:	48 b8 d0 a1 20 04 80 	movabs $0x800420a1d0,%rax
  8004207f84:	00 00 00 
  8004207f87:	48 89 45 90          	mov    %rax,-0x70(%rbp)
	Dwarf_Section *ds = &myds;
  8004207f8b:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004207f8f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	//Dwarf_LineFile lf, tlf;
	uint64_t length, hdroff, endoff;
	uint8_t *p;
	int dwarf_size, i, ret;
            
	cu = die->cu_header;
  8004207f93:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004207f9a:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  8004207fa1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	assert(cu != NULL); 
  8004207fa5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004207faa:	75 35                	jne    8004207fe1 <_dwarf_lineno_init+0xb3>
  8004207fac:	48 b9 dc a1 20 04 80 	movabs $0x800420a1dc,%rcx
  8004207fb3:	00 00 00 
  8004207fb6:	48 ba e7 a1 20 04 80 	movabs $0x800420a1e7,%rdx
  8004207fbd:	00 00 00 
  8004207fc0:	be 13 01 00 00       	mov    $0x113,%esi
  8004207fc5:	48 bf fc a1 20 04 80 	movabs $0x800420a1fc,%rdi
  8004207fcc:	00 00 00 
  8004207fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207fd4:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004207fdb:	00 00 00 
  8004207fde:	41 ff d0             	callq  *%r8
	assert(dbg != NULL);
  8004207fe1:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207fe8:	00 00 00 
  8004207feb:	48 8b 00             	mov    (%rax),%rax
  8004207fee:	48 85 c0             	test   %rax,%rax
  8004207ff1:	75 35                	jne    8004208028 <_dwarf_lineno_init+0xfa>
  8004207ff3:	48 b9 13 a2 20 04 80 	movabs $0x800420a213,%rcx
  8004207ffa:	00 00 00 
  8004207ffd:	48 ba e7 a1 20 04 80 	movabs $0x800420a1e7,%rdx
  8004208004:	00 00 00 
  8004208007:	be 14 01 00 00       	mov    $0x114,%esi
  800420800c:	48 bf fc a1 20 04 80 	movabs $0x800420a1fc,%rdi
  8004208013:	00 00 00 
  8004208016:	b8 00 00 00 00       	mov    $0x0,%eax
  800420801b:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208022:	00 00 00 
  8004208025:	41 ff d0             	callq  *%r8

	if ((_dwarf_find_section_enhanced(ds)) != 0)
  8004208028:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420802c:	48 89 c7             	mov    %rax,%rdi
  800420802f:	48 b8 f6 52 20 04 80 	movabs $0x80042052f6,%rax
  8004208036:	00 00 00 
  8004208039:	ff d0                	callq  *%rax
  800420803b:	85 c0                	test   %eax,%eax
  800420803d:	74 0a                	je     8004208049 <_dwarf_lineno_init+0x11b>
		return (DW_DLE_NONE);
  800420803f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208044:	e9 4f 04 00 00       	jmpq   8004208498 <_dwarf_lineno_init+0x56a>

	li = linfo;
  8004208049:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004208050:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	 break;
	 }
	 }
	*/

	length = dbg->read(ds->ds_data, &offset, 4);
  8004208054:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420805b:	00 00 00 
  800420805e:	48 8b 00             	mov    (%rax),%rax
  8004208061:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208065:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208069:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420806d:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208074:	ba 04 00 00 00       	mov    $0x4,%edx
  8004208079:	48 89 cf             	mov    %rcx,%rdi
  800420807c:	ff d0                	callq  *%rax
  800420807e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (length == 0xffffffff) {
  8004208082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004208087:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  800420808b:	75 37                	jne    80042080c4 <_dwarf_lineno_init+0x196>
		dwarf_size = 8;
  800420808d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
		length = dbg->read(ds->ds_data, &offset, 8);
  8004208094:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420809b:	00 00 00 
  800420809e:	48 8b 00             	mov    (%rax),%rax
  80042080a1:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042080a5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042080a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042080ad:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042080b4:	ba 08 00 00 00       	mov    $0x8,%edx
  80042080b9:	48 89 cf             	mov    %rcx,%rdi
  80042080bc:	ff d0                	callq  *%rax
  80042080be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80042080c2:	eb 07                	jmp    80042080cb <_dwarf_lineno_init+0x19d>
	} else
		dwarf_size = 4;
  80042080c4:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%rbp)

	if (length > ds->ds_size - offset) {
  80042080cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042080cf:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042080d3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80042080da:	48 29 c2             	sub    %rax,%rdx
  80042080dd:	48 89 d0             	mov    %rdx,%rax
  80042080e0:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80042080e4:	73 0a                	jae    80042080f0 <_dwarf_lineno_init+0x1c2>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_LINE_LENGTH_BAD);
		return (DW_DLE_DEBUG_LINE_LENGTH_BAD);
  80042080e6:	b8 0f 00 00 00       	mov    $0xf,%eax
  80042080eb:	e9 a8 03 00 00       	jmpq   8004208498 <_dwarf_lineno_init+0x56a>
	}
	/*
	 * Read in line number program header.
	 */
	li->li_length = length;
  80042080f0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042080f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042080f8:	48 89 10             	mov    %rdx,(%rax)
	endoff = offset + length;
  80042080fb:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8004208102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208106:	48 01 d0             	add    %rdx,%rax
  8004208109:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	li->li_version = dbg->read(ds->ds_data, &offset, 2); /* FIXME: verify version */
  800420810d:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208114:	00 00 00 
  8004208117:	48 8b 00             	mov    (%rax),%rax
  800420811a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420811e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208122:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208126:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420812d:	ba 02 00 00 00       	mov    $0x2,%edx
  8004208132:	48 89 cf             	mov    %rcx,%rdi
  8004208135:	ff d0                	callq  *%rax
  8004208137:	89 c2                	mov    %eax,%edx
  8004208139:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420813d:	66 89 50 08          	mov    %dx,0x8(%rax)
	li->li_hdrlen = dbg->read(ds->ds_data, &offset, dwarf_size);
  8004208141:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208148:	00 00 00 
  800420814b:	48 8b 00             	mov    (%rax),%rax
  800420814e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208152:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208156:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420815a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800420815d:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208164:	48 89 cf             	mov    %rcx,%rdi
  8004208167:	ff d0                	callq  *%rax
  8004208169:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420816d:	48 89 42 10          	mov    %rax,0x10(%rdx)
	hdroff = offset;
  8004208171:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004208178:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	li->li_minlen = dbg->read(ds->ds_data, &offset, 1);
  800420817c:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208183:	00 00 00 
  8004208186:	48 8b 00             	mov    (%rax),%rax
  8004208189:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420818d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208191:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208195:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420819c:	ba 01 00 00 00       	mov    $0x1,%edx
  80042081a1:	48 89 cf             	mov    %rcx,%rdi
  80042081a4:	ff d0                	callq  *%rax
  80042081a6:	89 c2                	mov    %eax,%edx
  80042081a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042081ac:	88 50 18             	mov    %dl,0x18(%rax)
	li->li_defstmt = dbg->read(ds->ds_data, &offset, 1);
  80042081af:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042081b6:	00 00 00 
  80042081b9:	48 8b 00             	mov    (%rax),%rax
  80042081bc:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042081c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042081c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042081c8:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042081cf:	ba 01 00 00 00       	mov    $0x1,%edx
  80042081d4:	48 89 cf             	mov    %rcx,%rdi
  80042081d7:	ff d0                	callq  *%rax
  80042081d9:	89 c2                	mov    %eax,%edx
  80042081db:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042081df:	88 50 19             	mov    %dl,0x19(%rax)
	li->li_lbase = dbg->read(ds->ds_data, &offset, 1);
  80042081e2:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042081e9:	00 00 00 
  80042081ec:	48 8b 00             	mov    (%rax),%rax
  80042081ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042081f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042081f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042081fb:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208202:	ba 01 00 00 00       	mov    $0x1,%edx
  8004208207:	48 89 cf             	mov    %rcx,%rdi
  800420820a:	ff d0                	callq  *%rax
  800420820c:	89 c2                	mov    %eax,%edx
  800420820e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208212:	88 50 1a             	mov    %dl,0x1a(%rax)
	li->li_lrange = dbg->read(ds->ds_data, &offset, 1);
  8004208215:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420821c:	00 00 00 
  800420821f:	48 8b 00             	mov    (%rax),%rax
  8004208222:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208226:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420822a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420822e:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208235:	ba 01 00 00 00       	mov    $0x1,%edx
  800420823a:	48 89 cf             	mov    %rcx,%rdi
  800420823d:	ff d0                	callq  *%rax
  800420823f:	89 c2                	mov    %eax,%edx
  8004208241:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208245:	88 50 1b             	mov    %dl,0x1b(%rax)
	li->li_opbase = dbg->read(ds->ds_data, &offset, 1);
  8004208248:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420824f:	00 00 00 
  8004208252:	48 8b 00             	mov    (%rax),%rax
  8004208255:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208259:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420825d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208261:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208268:	ba 01 00 00 00       	mov    $0x1,%edx
  800420826d:	48 89 cf             	mov    %rcx,%rdi
  8004208270:	ff d0                	callq  *%rax
  8004208272:	89 c2                	mov    %eax,%edx
  8004208274:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208278:	88 50 1c             	mov    %dl,0x1c(%rax)
	//STAILQ_INIT(&li->li_lflist);
	//STAILQ_INIT(&li->li_lnlist);

	if ((int)li->li_hdrlen - 5 < li->li_opbase - 1) {
  800420827b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420827f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208283:	8d 50 fb             	lea    -0x5(%rax),%edx
  8004208286:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420828a:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420828e:	0f b6 c0             	movzbl %al,%eax
  8004208291:	83 e8 01             	sub    $0x1,%eax
  8004208294:	39 c2                	cmp    %eax,%edx
  8004208296:	7d 0c                	jge    80042082a4 <_dwarf_lineno_init+0x376>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  8004208298:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420829f:	e9 f1 01 00 00       	jmpq   8004208495 <_dwarf_lineno_init+0x567>
	}

	li->li_oplen = global_std_op;
  80042082a4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042082a8:	48 bb 40 db 21 04 80 	movabs $0x800421db40,%rbx
  80042082af:	00 00 00 
  80042082b2:	48 89 58 20          	mov    %rbx,0x20(%rax)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  80042082b6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%rbp)
  80042082bd:	eb 41                	jmp    8004208300 <_dwarf_lineno_init+0x3d2>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);
  80042082bf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042082c3:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80042082c7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80042082ca:	48 98                	cltq   
  80042082cc:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  80042082d0:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042082d7:	00 00 00 
  80042082da:	48 8b 00             	mov    (%rax),%rax
  80042082dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042082e1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042082e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042082e9:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042082f0:	ba 01 00 00 00       	mov    $0x1,%edx
  80042082f5:	48 89 cf             	mov    %rcx,%rdi
  80042082f8:	ff d0                	callq  *%rax
  80042082fa:	88 03                	mov    %al,(%rbx)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  80042082fc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8004208300:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208304:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004208308:	0f b6 c0             	movzbl %al,%eax
  800420830b:	3b 45 e0             	cmp    -0x20(%rbp),%eax
  800420830e:	7f af                	jg     80042082bf <_dwarf_lineno_init+0x391>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);

	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
  8004208310:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004208317:	00 
	p = ds->ds_data + offset;
  8004208318:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420831c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004208320:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004208327:	48 01 d0             	add    %rdx,%rax
  800420832a:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	while (*p != '\0') {
  8004208331:	eb 1f                	jmp    8004208352 <_dwarf_lineno_init+0x424>
		while (*p++ != '\0')
  8004208333:	90                   	nop
  8004208334:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420833b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420833f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
  8004208346:	0f b6 00             	movzbl (%rax),%eax
  8004208349:	84 c0                	test   %al,%al
  800420834b:	75 e7                	jne    8004208334 <_dwarf_lineno_init+0x406>
			;
		length++;
  800420834d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
	p = ds->ds_data + offset;
	while (*p != '\0') {
  8004208352:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208359:	0f b6 00             	movzbl (%rax),%eax
  800420835c:	84 c0                	test   %al,%al
  800420835e:	75 d3                	jne    8004208333 <_dwarf_lineno_init+0x405>
		while (*p++ != '\0')
			;
		length++;
	}
	li->li_inclen = length;
  8004208360:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208364:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208368:	48 89 50 30          	mov    %rdx,0x30(%rax)

	/* Sanity check. */
	if (p - ds->ds_data > (int) ds->ds_size) {
  800420836c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208373:	48 89 c2             	mov    %rax,%rdx
  8004208376:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420837a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420837e:	48 29 c2             	sub    %rax,%rdx
  8004208381:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208385:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208389:	48 98                	cltq   
  800420838b:	48 39 c2             	cmp    %rax,%rdx
  800420838e:	7e 0c                	jle    800420839c <_dwarf_lineno_init+0x46e>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  8004208390:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  8004208397:	e9 f9 00 00 00       	jmpq   8004208495 <_dwarf_lineno_init+0x567>
	}
	p++;
  800420839c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042083a3:	48 83 c0 01          	add    $0x1,%rax
  80042083a7:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  80042083ae:	eb 3c                	jmp    80042083ec <_dwarf_lineno_init+0x4be>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
  80042083b0:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042083b7:	00 00 00 
  80042083ba:	48 8b 08             	mov    (%rax),%rcx
  80042083bd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80042083c4:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  80042083cb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042083cf:	49 89 c8             	mov    %rcx,%r8
  80042083d2:	48 89 d1             	mov    %rdx,%rcx
  80042083d5:	ba 00 00 00 00       	mov    $0x0,%edx
  80042083da:	48 89 c7             	mov    %rax,%rdi
  80042083dd:	48 b8 8a 7e 20 04 80 	movabs $0x8004207e8a,%rax
  80042083e4:	00 00 00 
  80042083e7:	ff d0                	callq  *%rax
  80042083e9:	89 45 dc             	mov    %eax,-0x24(%rbp)
	p++;

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  80042083ec:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042083f3:	0f b6 00             	movzbl (%rax),%eax
  80042083f6:	84 c0                	test   %al,%al
  80042083f8:	75 b6                	jne    80042083b0 <_dwarf_lineno_init+0x482>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
		//p++;
	}

	p++;
  80042083fa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208401:	48 83 c0 01          	add    $0x1,%rax
  8004208405:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	/* Sanity check. */
	if (p - ds->ds_data - hdroff != li->li_hdrlen) {
  800420840c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208413:	48 89 c2             	mov    %rax,%rdx
  8004208416:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420841a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420841e:	48 29 c2             	sub    %rax,%rdx
  8004208421:	48 89 d0             	mov    %rdx,%rax
  8004208424:	48 2b 45 b0          	sub    -0x50(%rbp),%rax
  8004208428:	48 89 c2             	mov    %rax,%rdx
  800420842b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420842f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208433:	48 39 c2             	cmp    %rax,%rdx
  8004208436:	74 09                	je     8004208441 <_dwarf_lineno_init+0x513>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  8004208438:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420843f:	eb 54                	jmp    8004208495 <_dwarf_lineno_init+0x567>
	}

	/*
	 * Process line number program.
	 */
	ret = _dwarf_lineno_run_program(cu, li, p, ds->ds_data + endoff, pc,
  8004208441:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208445:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004208449:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420844d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8004208451:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  8004208458:	4c 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%r8
  800420845f:	48 8b bd 00 ff ff ff 	mov    -0x100(%rbp),%rdi
  8004208466:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800420846a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420846e:	4d 89 c1             	mov    %r8,%r9
  8004208471:	49 89 f8             	mov    %rdi,%r8
  8004208474:	48 89 c7             	mov    %rax,%rdi
  8004208477:	48 b8 d2 78 20 04 80 	movabs $0x80042078d2,%rax
  800420847e:	00 00 00 
  8004208481:	ff d0                	callq  *%rax
  8004208483:	89 45 dc             	mov    %eax,-0x24(%rbp)
					error);
	if (ret != DW_DLE_NONE)
  8004208486:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420848a:	74 02                	je     800420848e <_dwarf_lineno_init+0x560>
		goto fail_cleanup;
  800420848c:	eb 07                	jmp    8004208495 <_dwarf_lineno_init+0x567>

	//cu->cu_lineinfo = li;

	return (DW_DLE_NONE);
  800420848e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208493:	eb 03                	jmp    8004208498 <_dwarf_lineno_init+0x56a>
fail_cleanup:

	/*if (li->li_oplen)
	  free(li->li_oplen);*/

	return (ret);
  8004208495:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
  8004208498:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  800420849f:	5b                   	pop    %rbx
  80042084a0:	5d                   	pop    %rbp
  80042084a1:	c3                   	retq   

00000080042084a2 <dwarf_srclines>:

int
dwarf_srclines(Dwarf_Die *die, Dwarf_Line linebuf, Dwarf_Addr pc, Dwarf_Error *error)
{
  80042084a2:	55                   	push   %rbp
  80042084a3:	48 89 e5             	mov    %rsp,%rbp
  80042084a6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80042084ad:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80042084b4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80042084bb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  80042084c2:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
	_Dwarf_LineInfo li;
	Dwarf_Attribute *at;

	assert(die);
  80042084c9:	48 83 bd 68 ff ff ff 	cmpq   $0x0,-0x98(%rbp)
  80042084d0:	00 
  80042084d1:	75 35                	jne    8004208508 <dwarf_srclines+0x66>
  80042084d3:	48 b9 1f a2 20 04 80 	movabs $0x800420a21f,%rcx
  80042084da:	00 00 00 
  80042084dd:	48 ba e7 a1 20 04 80 	movabs $0x800420a1e7,%rdx
  80042084e4:	00 00 00 
  80042084e7:	be 9a 01 00 00       	mov    $0x19a,%esi
  80042084ec:	48 bf fc a1 20 04 80 	movabs $0x800420a1fc,%rdi
  80042084f3:	00 00 00 
  80042084f6:	b8 00 00 00 00       	mov    $0x0,%eax
  80042084fb:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208502:	00 00 00 
  8004208505:	41 ff d0             	callq  *%r8
	assert(linebuf);
  8004208508:	48 83 bd 60 ff ff ff 	cmpq   $0x0,-0xa0(%rbp)
  800420850f:	00 
  8004208510:	75 35                	jne    8004208547 <dwarf_srclines+0xa5>
  8004208512:	48 b9 23 a2 20 04 80 	movabs $0x800420a223,%rcx
  8004208519:	00 00 00 
  800420851c:	48 ba e7 a1 20 04 80 	movabs $0x800420a1e7,%rdx
  8004208523:	00 00 00 
  8004208526:	be 9b 01 00 00       	mov    $0x19b,%esi
  800420852b:	48 bf fc a1 20 04 80 	movabs $0x800420a1fc,%rdi
  8004208532:	00 00 00 
  8004208535:	b8 00 00 00 00       	mov    $0x0,%eax
  800420853a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208541:	00 00 00 
  8004208544:	41 ff d0             	callq  *%r8

	memset(&li, 0, sizeof(_Dwarf_LineInfo));
  8004208547:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800420854e:	ba 88 00 00 00       	mov    $0x88,%edx
  8004208553:	be 00 00 00 00       	mov    $0x0,%esi
  8004208558:	48 89 c7             	mov    %rax,%rdi
  800420855b:	48 b8 46 2f 20 04 80 	movabs $0x8004202f46,%rax
  8004208562:	00 00 00 
  8004208565:	ff d0                	callq  *%rax

	if ((at = _dwarf_attr_find(die, DW_AT_stmt_list)) == NULL) {
  8004208567:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420856e:	be 10 00 00 00       	mov    $0x10,%esi
  8004208573:	48 89 c7             	mov    %rax,%rdi
  8004208576:	48 b8 7b 4e 20 04 80 	movabs $0x8004204e7b,%rax
  800420857d:	00 00 00 
  8004208580:	ff d0                	callq  *%rax
  8004208582:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208586:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420858b:	75 0a                	jne    8004208597 <dwarf_srclines+0xf5>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  800420858d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004208592:	e9 84 00 00 00       	jmpq   800420861b <dwarf_srclines+0x179>
	}

	if (_dwarf_lineno_init(die, at->u[0].u64, &li, pc, error) !=
  8004208597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420859b:	48 8b 70 28          	mov    0x28(%rax),%rsi
  800420859f:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  80042085a6:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  80042085ad:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  80042085b4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042085bb:	49 89 f8             	mov    %rdi,%r8
  80042085be:	48 89 c7             	mov    %rax,%rdi
  80042085c1:	48 b8 2e 7f 20 04 80 	movabs $0x8004207f2e,%rax
  80042085c8:	00 00 00 
  80042085cb:	ff d0                	callq  *%rax
  80042085cd:	85 c0                	test   %eax,%eax
  80042085cf:	74 07                	je     80042085d8 <dwarf_srclines+0x136>
	    DW_DLE_NONE)
	{
		return (DW_DLV_ERROR);
  80042085d1:	b8 01 00 00 00       	mov    $0x1,%eax
  80042085d6:	eb 43                	jmp    800420861b <dwarf_srclines+0x179>
	}
	*linebuf = li.li_line;
  80042085d8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80042085df:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80042085e3:	48 89 10             	mov    %rdx,(%rax)
  80042085e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042085ea:	48 89 50 08          	mov    %rdx,0x8(%rax)
  80042085ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042085f2:	48 89 50 10          	mov    %rdx,0x10(%rax)
  80042085f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042085fa:	48 89 50 18          	mov    %rdx,0x18(%rax)
  80042085fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004208602:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004208606:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420860a:	48 89 50 28          	mov    %rdx,0x28(%rax)
  800420860e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208612:	48 89 50 30          	mov    %rdx,0x30(%rax)

	return (DW_DLV_OK);
  8004208616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420861b:	c9                   	leaveq 
  800420861c:	c3                   	retq   

000000800420861d <_dwarf_find_section>:
uintptr_t
read_section_headers(uintptr_t, uintptr_t);

Dwarf_Section *
_dwarf_find_section(const char *name)
{
  800420861d:	55                   	push   %rbp
  800420861e:	48 89 e5             	mov    %rsp,%rbp
  8004208621:	48 83 ec 20          	sub    $0x20,%rsp
  8004208625:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *ret=NULL;
  8004208629:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208630:	00 
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  8004208631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004208638:	eb 57                	jmp    8004208691 <_dwarf_find_section+0x74>
		if(!strcmp(section_info[i].ds_name, name)) {
  800420863a:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208641:	00 00 00 
  8004208644:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004208647:	48 63 d2             	movslq %edx,%rdx
  800420864a:	48 c1 e2 05          	shl    $0x5,%rdx
  800420864e:	48 01 d0             	add    %rdx,%rax
  8004208651:	48 8b 00             	mov    (%rax),%rax
  8004208654:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208658:	48 89 d6             	mov    %rdx,%rsi
  800420865b:	48 89 c7             	mov    %rax,%rdi
  800420865e:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208665:	00 00 00 
  8004208668:	ff d0                	callq  *%rax
  800420866a:	85 c0                	test   %eax,%eax
  800420866c:	75 1f                	jne    800420868d <_dwarf_find_section+0x70>
			ret = (section_info + i);
  800420866e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208671:	48 98                	cltq   
  8004208673:	48 c1 e0 05          	shl    $0x5,%rax
  8004208677:	48 89 c2             	mov    %rax,%rdx
  800420867a:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208681:	00 00 00 
  8004208684:	48 01 d0             	add    %rdx,%rax
  8004208687:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  800420868b:	eb 0a                	jmp    8004208697 <_dwarf_find_section+0x7a>
_dwarf_find_section(const char *name)
{
	Dwarf_Section *ret=NULL;
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  800420868d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004208691:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  8004208695:	7e a3                	jle    800420863a <_dwarf_find_section+0x1d>
			ret = (section_info + i);
			break;
		}
	}

	return ret;
  8004208697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420869b:	c9                   	leaveq 
  800420869c:	c3                   	retq   

000000800420869d <find_debug_sections>:

void find_debug_sections(uintptr_t elf) 
{
  800420869d:	55                   	push   %rbp
  800420869e:	48 89 e5             	mov    %rsp,%rbp
  80042086a1:	48 83 ec 40          	sub    $0x40,%rsp
  80042086a5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	Elf *ehdr = (Elf *)elf;
  80042086a9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042086ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uintptr_t debug_address = USTABDATA;
  80042086b1:	48 c7 45 f8 00 00 20 	movq   $0x200000,-0x8(%rbp)
  80042086b8:	00 
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
  80042086b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086bd:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042086c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086c5:	48 01 d0             	add    %rdx,%rax
  80042086c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
  80042086cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086d0:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  80042086d4:	0f b7 c0             	movzwl %ax,%eax
  80042086d7:	48 c1 e0 06          	shl    $0x6,%rax
  80042086db:	48 89 c2             	mov    %rax,%rdx
  80042086de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042086e2:	48 01 d0             	add    %rdx,%rax
  80042086e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Secthdr* esh = sh + ehdr->e_shnum;
  80042086e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086ed:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  80042086f1:	0f b7 c0             	movzwl %ax,%eax
  80042086f4:	48 c1 e0 06          	shl    $0x6,%rax
  80042086f8:	48 89 c2             	mov    %rax,%rdx
  80042086fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042086ff:	48 01 d0             	add    %rdx,%rax
  8004208702:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	for(;sh < esh; sh++) {
  8004208706:	e9 4b 02 00 00       	jmpq   8004208956 <find_debug_sections+0x2b9>
		char* name = (char*)((uint8_t*)elf + shstr_tab->sh_offset) + sh->sh_name;
  800420870b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420870f:	8b 00                	mov    (%rax),%eax
  8004208711:	89 c2                	mov    %eax,%edx
  8004208713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208717:	48 8b 48 18          	mov    0x18(%rax),%rcx
  800420871b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420871f:	48 01 c8             	add    %rcx,%rax
  8004208722:	48 01 d0             	add    %rdx,%rax
  8004208725:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if(!strcmp(name, ".debug_info")) {
  8004208729:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420872d:	48 be 2b a2 20 04 80 	movabs $0x800420a22b,%rsi
  8004208734:	00 00 00 
  8004208737:	48 89 c7             	mov    %rax,%rdi
  800420873a:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208741:	00 00 00 
  8004208744:	ff d0                	callq  *%rax
  8004208746:	85 c0                	test   %eax,%eax
  8004208748:	75 4b                	jne    8004208795 <find_debug_sections+0xf8>
			section_info[DEBUG_INFO].ds_data = (uint8_t*)debug_address;
  800420874a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420874e:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208755:	00 00 00 
  8004208758:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = debug_address;
  800420875c:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208763:	00 00 00 
  8004208766:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420876a:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = sh->sh_size;
  800420876e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208772:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208776:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420877d:	00 00 00 
  8004208780:	48 89 50 18          	mov    %rdx,0x18(%rax)
			debug_address += sh->sh_size;
  8004208784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208788:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420878c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  8004208790:	e9 bc 01 00 00       	jmpq   8004208951 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_abbrev")) {
  8004208795:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208799:	48 be 37 a2 20 04 80 	movabs $0x800420a237,%rsi
  80042087a0:	00 00 00 
  80042087a3:	48 89 c7             	mov    %rax,%rdi
  80042087a6:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  80042087ad:	00 00 00 
  80042087b0:	ff d0                	callq  *%rax
  80042087b2:	85 c0                	test   %eax,%eax
  80042087b4:	75 4b                	jne    8004208801 <find_debug_sections+0x164>
			section_info[DEBUG_ABBREV].ds_data = (uint8_t*)debug_address;
  80042087b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042087ba:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042087c1:	00 00 00 
  80042087c4:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = debug_address;
  80042087c8:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042087cf:	00 00 00 
  80042087d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042087d6:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = sh->sh_size;
  80042087da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087de:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80042087e2:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042087e9:	00 00 00 
  80042087ec:	48 89 50 38          	mov    %rdx,0x38(%rax)
			debug_address += sh->sh_size;
  80042087f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087f4:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042087f8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  80042087fc:	e9 50 01 00 00       	jmpq   8004208951 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_line")){
  8004208801:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208805:	48 be 4f a2 20 04 80 	movabs $0x800420a24f,%rsi
  800420880c:	00 00 00 
  800420880f:	48 89 c7             	mov    %rax,%rdi
  8004208812:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208819:	00 00 00 
  800420881c:	ff d0                	callq  *%rax
  800420881e:	85 c0                	test   %eax,%eax
  8004208820:	75 4b                	jne    800420886d <find_debug_sections+0x1d0>
			section_info[DEBUG_LINE].ds_data = (uint8_t*)debug_address;
  8004208822:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208826:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420882d:	00 00 00 
  8004208830:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = debug_address;
  8004208834:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420883b:	00 00 00 
  800420883e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208842:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = sh->sh_size;
  8004208846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420884a:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420884e:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208855:	00 00 00 
  8004208858:	48 89 50 78          	mov    %rdx,0x78(%rax)
			debug_address += sh->sh_size;
  800420885c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208860:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004208864:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  8004208868:	e9 e4 00 00 00       	jmpq   8004208951 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".eh_frame")){
  800420886d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208871:	48 be 45 a2 20 04 80 	movabs $0x800420a245,%rsi
  8004208878:	00 00 00 
  800420887b:	48 89 c7             	mov    %rax,%rdi
  800420887e:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208885:	00 00 00 
  8004208888:	ff d0                	callq  *%rax
  800420888a:	85 c0                	test   %eax,%eax
  800420888c:	75 53                	jne    80042088e1 <find_debug_sections+0x244>
			section_info[DEBUG_FRAME].ds_data = (uint8_t*)sh->sh_addr;
  800420888e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208892:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208896:	48 89 c2             	mov    %rax,%rdx
  8004208899:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042088a0:	00 00 00 
  80042088a3:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = sh->sh_addr;
  80042088a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042088af:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042088b6:	00 00 00 
  80042088b9:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = sh->sh_size;
  80042088bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088c1:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80042088c5:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042088cc:	00 00 00 
  80042088cf:	48 89 50 58          	mov    %rdx,0x58(%rax)
			debug_address += sh->sh_size;
  80042088d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042088db:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  80042088df:	eb 70                	jmp    8004208951 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_str")) {
  80042088e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042088e5:	48 be 5b a2 20 04 80 	movabs $0x800420a25b,%rsi
  80042088ec:	00 00 00 
  80042088ef:	48 89 c7             	mov    %rax,%rdi
  80042088f2:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  80042088f9:	00 00 00 
  80042088fc:	ff d0                	callq  *%rax
  80042088fe:	85 c0                	test   %eax,%eax
  8004208900:	75 4f                	jne    8004208951 <find_debug_sections+0x2b4>
			section_info[DEBUG_STR].ds_data = (uint8_t*)debug_address;
  8004208902:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208906:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420890d:	00 00 00 
  8004208910:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = debug_address;
  8004208917:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420891e:	00 00 00 
  8004208921:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208925:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = sh->sh_size;
  800420892c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208930:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208934:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420893b:	00 00 00 
  800420893e:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
			debug_address += sh->sh_size;
  8004208945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208949:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420894d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	Elf *ehdr = (Elf *)elf;
	uintptr_t debug_address = USTABDATA;
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
	Secthdr* esh = sh + ehdr->e_shnum;
	for(;sh < esh; sh++) {
  8004208951:	48 83 45 f0 40       	addq   $0x40,-0x10(%rbp)
  8004208956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420895a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800420895e:	0f 82 a7 fd ff ff    	jb     800420870b <find_debug_sections+0x6e>
			section_info[DEBUG_STR].ds_size = sh->sh_size;
			debug_address += sh->sh_size;
		}
	}

}
  8004208964:	c9                   	leaveq 
  8004208965:	c3                   	retq   

0000008004208966 <read_section_headers>:

uint64_t
read_section_headers(uintptr_t elfhdr, uintptr_t to_va)
{
  8004208966:	55                   	push   %rbp
  8004208967:	48 89 e5             	mov    %rsp,%rbp
  800420896a:	48 81 ec 60 01 00 00 	sub    $0x160,%rsp
  8004208971:	48 89 bd a8 fe ff ff 	mov    %rdi,-0x158(%rbp)
  8004208978:	48 89 b5 a0 fe ff ff 	mov    %rsi,-0x160(%rbp)
	Secthdr* secthdr_ptr[20] = {0};
  800420897f:	48 8d b5 c0 fe ff ff 	lea    -0x140(%rbp),%rsi
  8004208986:	b8 00 00 00 00       	mov    $0x0,%eax
  800420898b:	ba 14 00 00 00       	mov    $0x14,%edx
  8004208990:	48 89 f7             	mov    %rsi,%rdi
  8004208993:	48 89 d1             	mov    %rdx,%rcx
  8004208996:	f3 48 ab             	rep stos %rax,%es:(%rdi)
	char* kvbase = ROUNDUP((char*)to_va, SECTSIZE);
  8004208999:	48 c7 45 e8 00 02 00 	movq   $0x200,-0x18(%rbp)
  80042089a0:	00 
  80042089a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042089a5:	48 8b 95 a0 fe ff ff 	mov    -0x160(%rbp),%rdx
  80042089ac:	48 01 d0             	add    %rdx,%rax
  80042089af:	48 83 e8 01          	sub    $0x1,%rax
  80042089b3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80042089b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042089bb:	ba 00 00 00 00       	mov    $0x0,%edx
  80042089c0:	48 f7 75 e8          	divq   -0x18(%rbp)
  80042089c4:	48 89 d0             	mov    %rdx,%rax
  80042089c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042089cb:	48 29 c2             	sub    %rax,%rdx
  80042089ce:	48 89 d0             	mov    %rdx,%rax
  80042089d1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	uint64_t kvoffset = 0;
  80042089d5:	48 c7 85 b8 fe ff ff 	movq   $0x0,-0x148(%rbp)
  80042089dc:	00 00 00 00 
	char *orig_secthdr = (char*)kvbase;
  80042089e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042089e4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	char * secthdr = NULL;
  80042089e8:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80042089ef:	00 
	uint64_t offset;
	if(elfhdr == KELFHDR)
  80042089f0:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  80042089f7:	00 00 00 
  80042089fa:	48 39 85 a8 fe ff ff 	cmp    %rax,-0x158(%rbp)
  8004208a01:	75 11                	jne    8004208a14 <read_section_headers+0xae>
		offset = ((Elf*)elfhdr)->e_shoff;
  8004208a03:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a0a:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004208a0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208a12:	eb 26                	jmp    8004208a3a <read_section_headers+0xd4>
	else
		offset = ((Elf*)elfhdr)->e_shoff + (elfhdr - KERNBASE);
  8004208a14:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a1b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004208a1f:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a26:	48 01 c2             	add    %rax,%rdx
  8004208a29:	48 b8 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rax
  8004208a30:	ff ff ff 
  8004208a33:	48 01 d0             	add    %rdx,%rax
  8004208a36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	int numSectionHeaders = ((Elf*)elfhdr)->e_shnum;
  8004208a3a:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a41:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  8004208a45:	0f b7 c0             	movzwl %ax,%eax
  8004208a48:	89 45 c4             	mov    %eax,-0x3c(%rbp)
	int sizeSections = ((Elf*)elfhdr)->e_shentsize;
  8004208a4b:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a52:	0f b7 40 3a          	movzwl 0x3a(%rax),%eax
  8004208a56:	0f b7 c0             	movzwl %ax,%eax
  8004208a59:	89 45 c0             	mov    %eax,-0x40(%rbp)
	char *nametab;
	int i;
	uint64_t temp;
	char *name;

	Elf *ehdr = (Elf *)elfhdr;
  8004208a5c:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208a63:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
  8004208a67:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8004208a6a:	0f af 45 c0          	imul   -0x40(%rbp),%eax
  8004208a6e:	48 63 f0             	movslq %eax,%rsi
  8004208a71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a75:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208a7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208a80:	48 89 c7             	mov    %rax,%rdi
  8004208a83:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208a8a:	00 00 00 
  8004208a8d:	ff d0                	callq  *%rax
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
  8004208a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208a93:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8004208a97:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004208a9b:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208aa1:	48 89 c2             	mov    %rax,%rdx
  8004208aa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208aa8:	48 29 d0             	sub    %rdx,%rax
  8004208aab:	48 89 c2             	mov    %rax,%rdx
  8004208aae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208ab2:	48 01 d0             	add    %rdx,%rax
  8004208ab5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	for (i = 0; i < numSectionHeaders; i++)
  8004208ab9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004208ac0:	eb 24                	jmp    8004208ae6 <read_section_headers+0x180>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
  8004208ac2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ac5:	48 98                	cltq   
  8004208ac7:	48 c1 e0 06          	shl    $0x6,%rax
  8004208acb:	48 89 c2             	mov    %rax,%rdx
  8004208ace:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004208ad2:	48 01 c2             	add    %rax,%rdx
  8004208ad5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ad8:	48 98                	cltq   
  8004208ada:	48 89 94 c5 c0 fe ff 	mov    %rdx,-0x140(%rbp,%rax,8)
  8004208ae1:	ff 
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
	for (i = 0; i < numSectionHeaders; i++)
  8004208ae2:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004208ae6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ae9:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  8004208aec:	7c d4                	jl     8004208ac2 <read_section_headers+0x15c>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
	}
	
	sec_name = secthdr_ptr[ehdr->e_shstrndx]; 
  8004208aee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004208af2:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  8004208af6:	0f b7 c0             	movzwl %ax,%eax
  8004208af9:	48 98                	cltq   
  8004208afb:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208b02:	ff 
  8004208b03:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	temp = kvoffset;
  8004208b07:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208b0e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
  8004208b12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208b16:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208b1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208b1e:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208b22:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208b29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208b2d:	48 01 c8             	add    %rcx,%rax
  8004208b30:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208b37:	48 89 c7             	mov    %rax,%rdi
  8004208b3a:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208b41:	00 00 00 
  8004208b44:	ff d0                	callq  *%rax
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	
  8004208b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208b4a:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208b52:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208b56:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  8004208b5a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004208b5e:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208b64:	48 29 c2             	sub    %rax,%rdx
  8004208b67:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208b6b:	48 01 c2             	add    %rax,%rdx
  8004208b6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208b72:	48 01 d0             	add    %rdx,%rax
  8004208b75:	48 89 45 90          	mov    %rax,-0x70(%rbp)

	for (i = 0; i < numSectionHeaders; i++)
  8004208b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004208b80:	e9 04 05 00 00       	jmpq   8004209089 <read_section_headers+0x723>
	{
		name = (char *)(nametab + secthdr_ptr[i]->sh_name);
  8004208b85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208b88:	48 98                	cltq   
  8004208b8a:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208b91:	ff 
  8004208b92:	8b 00                	mov    (%rax),%eax
  8004208b94:	89 c2                	mov    %eax,%edx
  8004208b96:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004208b9a:	48 01 d0             	add    %rdx,%rax
  8004208b9d:	48 89 45 88          	mov    %rax,-0x78(%rbp)
		assert(kvoffset % SECTSIZE == 0);
  8004208ba1:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208ba8:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004208bad:	48 85 c0             	test   %rax,%rax
  8004208bb0:	74 35                	je     8004208be7 <read_section_headers+0x281>
  8004208bb2:	48 b9 66 a2 20 04 80 	movabs $0x800420a266,%rcx
  8004208bb9:	00 00 00 
  8004208bbc:	48 ba 7f a2 20 04 80 	movabs $0x800420a27f,%rdx
  8004208bc3:	00 00 00 
  8004208bc6:	be 86 00 00 00       	mov    $0x86,%esi
  8004208bcb:	48 bf 94 a2 20 04 80 	movabs $0x800420a294,%rdi
  8004208bd2:	00 00 00 
  8004208bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208bda:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208be1:	00 00 00 
  8004208be4:	41 ff d0             	callq  *%r8
		temp = kvoffset;
  8004208be7:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208bee:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
  8004208bf2:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208bf6:	48 be 2b a2 20 04 80 	movabs $0x800420a22b,%rsi
  8004208bfd:	00 00 00 
  8004208c00:	48 89 c7             	mov    %rax,%rdi
  8004208c03:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208c0a:	00 00 00 
  8004208c0d:	ff d0                	callq  *%rax
  8004208c0f:	85 c0                	test   %eax,%eax
  8004208c11:	0f 85 d8 00 00 00    	jne    8004208cef <read_section_headers+0x389>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208c17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c1a:	48 98                	cltq   
  8004208c1c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208c23:	ff 
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208c24:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208c28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c2b:	48 98                	cltq   
  8004208c2d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208c34:	ff 
  8004208c35:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208c39:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c44:	48 01 c8             	add    %rcx,%rax
  8004208c47:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208c4e:	48 89 c7             	mov    %rax,%rdi
  8004208c51:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208c58:	00 00 00 
  8004208c5b:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_INFO].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208c5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c60:	48 98                	cltq   
  8004208c62:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208c69:	ff 
  8004208c6a:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208c6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c71:	48 98                	cltq   
  8004208c73:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208c7a:	ff 
  8004208c7b:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208c7f:	48 89 45 80          	mov    %rax,-0x80(%rbp)
  8004208c83:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004208c87:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208c8d:	48 29 c2             	sub    %rax,%rdx
  8004208c90:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208c94:	48 01 c2             	add    %rax,%rdx
  8004208c97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c9b:	48 01 c2             	add    %rax,%rdx
  8004208c9e:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208ca5:	00 00 00 
  8004208ca8:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
  8004208cac:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208cb3:	00 00 00 
  8004208cb6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004208cba:	48 89 c2             	mov    %rax,%rdx
  8004208cbd:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208cc4:	00 00 00 
  8004208cc7:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
  8004208ccb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208cce:	48 98                	cltq   
  8004208cd0:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208cd7:	ff 
  8004208cd8:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208cdc:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208ce3:	00 00 00 
  8004208ce6:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004208cea:	e9 96 03 00 00       	jmpq   8004209085 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_abbrev"))
  8004208cef:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208cf3:	48 be 37 a2 20 04 80 	movabs $0x800420a237,%rsi
  8004208cfa:	00 00 00 
  8004208cfd:	48 89 c7             	mov    %rax,%rdi
  8004208d00:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208d07:	00 00 00 
  8004208d0a:	ff d0                	callq  *%rax
  8004208d0c:	85 c0                	test   %eax,%eax
  8004208d0e:	0f 85 de 00 00 00    	jne    8004208df2 <read_section_headers+0x48c>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208d14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208d17:	48 98                	cltq   
  8004208d19:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208d20:	ff 
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_abbrev"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208d21:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208d25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208d28:	48 98                	cltq   
  8004208d2a:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208d31:	ff 
  8004208d32:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208d36:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208d3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208d41:	48 01 c8             	add    %rcx,%rax
  8004208d44:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208d4b:	48 89 c7             	mov    %rax,%rdi
  8004208d4e:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208d55:	00 00 00 
  8004208d58:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_ABBREV].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208d5a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208d5d:	48 98                	cltq   
  8004208d5f:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208d66:	ff 
  8004208d67:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208d6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208d6e:	48 98                	cltq   
  8004208d70:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208d77:	ff 
  8004208d78:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208d7c:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  8004208d83:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004208d8a:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208d90:	48 29 c2             	sub    %rax,%rdx
  8004208d93:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208d97:	48 01 c2             	add    %rax,%rdx
  8004208d9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208d9e:	48 01 c2             	add    %rax,%rdx
  8004208da1:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208da8:	00 00 00 
  8004208dab:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
  8004208daf:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208db6:	00 00 00 
  8004208db9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004208dbd:	48 89 c2             	mov    %rax,%rdx
  8004208dc0:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208dc7:	00 00 00 
  8004208dca:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
  8004208dce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208dd1:	48 98                	cltq   
  8004208dd3:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208dda:	ff 
  8004208ddb:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208ddf:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208de6:	00 00 00 
  8004208de9:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004208ded:	e9 93 02 00 00       	jmpq   8004209085 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_line"))
  8004208df2:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208df6:	48 be 4f a2 20 04 80 	movabs $0x800420a24f,%rsi
  8004208dfd:	00 00 00 
  8004208e00:	48 89 c7             	mov    %rax,%rdi
  8004208e03:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208e0a:	00 00 00 
  8004208e0d:	ff d0                	callq  *%rax
  8004208e0f:	85 c0                	test   %eax,%eax
  8004208e11:	0f 85 de 00 00 00    	jne    8004208ef5 <read_section_headers+0x58f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208e17:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e1a:	48 98                	cltq   
  8004208e1c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e23:	ff 
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_line"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208e24:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208e28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e2b:	48 98                	cltq   
  8004208e2d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e34:	ff 
  8004208e35:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208e39:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208e40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208e44:	48 01 c8             	add    %rcx,%rax
  8004208e47:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208e4e:	48 89 c7             	mov    %rax,%rdi
  8004208e51:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208e58:	00 00 00 
  8004208e5b:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_LINE].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208e5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e60:	48 98                	cltq   
  8004208e62:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e69:	ff 
  8004208e6a:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208e6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e71:	48 98                	cltq   
  8004208e73:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e7a:	ff 
  8004208e7b:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208e7f:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
  8004208e86:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004208e8d:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208e93:	48 29 c2             	sub    %rax,%rdx
  8004208e96:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208e9a:	48 01 c2             	add    %rax,%rdx
  8004208e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208ea1:	48 01 c2             	add    %rax,%rdx
  8004208ea4:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208eab:	00 00 00 
  8004208eae:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = (uintptr_t)section_info[DEBUG_LINE].ds_data;
  8004208eb2:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208eb9:	00 00 00 
  8004208ebc:	48 8b 40 68          	mov    0x68(%rax),%rax
  8004208ec0:	48 89 c2             	mov    %rax,%rdx
  8004208ec3:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208eca:	00 00 00 
  8004208ecd:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = secthdr_ptr[i]->sh_size;
  8004208ed1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ed4:	48 98                	cltq   
  8004208ed6:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208edd:	ff 
  8004208ede:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208ee2:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208ee9:	00 00 00 
  8004208eec:	48 89 50 78          	mov    %rdx,0x78(%rax)
  8004208ef0:	e9 90 01 00 00       	jmpq   8004209085 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".eh_frame"))
  8004208ef5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208ef9:	48 be 45 a2 20 04 80 	movabs $0x800420a245,%rsi
  8004208f00:	00 00 00 
  8004208f03:	48 89 c7             	mov    %rax,%rdi
  8004208f06:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208f0d:	00 00 00 
  8004208f10:	ff d0                	callq  *%rax
  8004208f12:	85 c0                	test   %eax,%eax
  8004208f14:	75 65                	jne    8004208f7b <read_section_headers+0x615>
		{
			section_info[DEBUG_FRAME].ds_data = (uint8_t *)secthdr_ptr[i]->sh_addr;
  8004208f16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208f19:	48 98                	cltq   
  8004208f1b:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208f22:	ff 
  8004208f23:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208f27:	48 89 c2             	mov    %rax,%rdx
  8004208f2a:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f31:	00 00 00 
  8004208f34:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
  8004208f38:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f3f:	00 00 00 
  8004208f42:	48 8b 40 48          	mov    0x48(%rax),%rax
  8004208f46:	48 89 c2             	mov    %rax,%rdx
  8004208f49:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f50:	00 00 00 
  8004208f53:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
  8004208f57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208f5a:	48 98                	cltq   
  8004208f5c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208f63:	ff 
  8004208f64:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208f68:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f6f:	00 00 00 
  8004208f72:	48 89 50 58          	mov    %rdx,0x58(%rax)
  8004208f76:	e9 0a 01 00 00       	jmpq   8004209085 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_str"))
  8004208f7b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208f7f:	48 be 5b a2 20 04 80 	movabs $0x800420a25b,%rsi
  8004208f86:	00 00 00 
  8004208f89:	48 89 c7             	mov    %rax,%rdi
  8004208f8c:	48 b8 0f 2e 20 04 80 	movabs $0x8004202e0f,%rax
  8004208f93:	00 00 00 
  8004208f96:	ff d0                	callq  *%rax
  8004208f98:	85 c0                	test   %eax,%eax
  8004208f9a:	0f 85 e5 00 00 00    	jne    8004209085 <read_section_headers+0x71f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208fa0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208fa3:	48 98                	cltq   
  8004208fa5:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208fac:	ff 
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_str"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208fad:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208fb1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208fb4:	48 98                	cltq   
  8004208fb6:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208fbd:	ff 
  8004208fbe:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208fc2:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208fcd:	48 01 c8             	add    %rcx,%rax
  8004208fd0:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208fd7:	48 89 c7             	mov    %rax,%rdi
  8004208fda:	48 b8 a5 90 20 04 80 	movabs $0x80042090a5,%rax
  8004208fe1:	00 00 00 
  8004208fe4:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_STR].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208fe6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208fe9:	48 98                	cltq   
  8004208feb:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208ff2:	ff 
  8004208ff3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208ff7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ffa:	48 98                	cltq   
  8004208ffc:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004209003:	ff 
  8004209004:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004209008:	48 89 85 68 ff ff ff 	mov    %rax,-0x98(%rbp)
  800420900f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004209016:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420901c:	48 29 c2             	sub    %rax,%rdx
  800420901f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209023:	48 01 c2             	add    %rax,%rdx
  8004209026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420902a:	48 01 c2             	add    %rax,%rdx
  800420902d:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209034:	00 00 00 
  8004209037:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
  800420903e:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209045:	00 00 00 
  8004209048:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800420904f:	48 89 c2             	mov    %rax,%rdx
  8004209052:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209059:	00 00 00 
  800420905c:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
  8004209063:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209066:	48 98                	cltq   
  8004209068:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420906f:	ff 
  8004209070:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004209074:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420907b:	00 00 00 
  800420907e:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
	temp = kvoffset;
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	

	for (i = 0; i < numSectionHeaders; i++)
  8004209085:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004209089:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420908c:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  800420908f:	0f 8c f0 fa ff ff    	jl     8004208b85 <read_section_headers+0x21f>
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
		}
	}
	
	return ((uintptr_t)kvbase + kvoffset);
  8004209095:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004209099:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  80042090a0:	48 01 d0             	add    %rdx,%rax
}
  80042090a3:	c9                   	leaveq 
  80042090a4:	c3                   	retq   

00000080042090a5 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
void
readseg(uint64_t pa, uint64_t count, uint64_t offset, uint64_t* kvoffset)
{
  80042090a5:	55                   	push   %rbp
  80042090a6:	48 89 e5             	mov    %rsp,%rbp
  80042090a9:	48 83 ec 30          	sub    $0x30,%rsp
  80042090ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042090b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042090b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042090b9:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	uint64_t end_pa;
	uint64_t orgoff = offset;
  80042090bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042090c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	end_pa = pa + count;
  80042090c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042090c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042090cd:	48 01 d0             	add    %rdx,%rax
  80042090d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	assert(pa % SECTSIZE == 0);	
  80042090d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042090d8:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042090dd:	48 85 c0             	test   %rax,%rax
  80042090e0:	74 35                	je     8004209117 <readseg+0x72>
  80042090e2:	48 b9 a2 a2 20 04 80 	movabs $0x800420a2a2,%rcx
  80042090e9:	00 00 00 
  80042090ec:	48 ba 7f a2 20 04 80 	movabs $0x800420a27f,%rdx
  80042090f3:	00 00 00 
  80042090f6:	be c0 00 00 00       	mov    $0xc0,%esi
  80042090fb:	48 bf 94 a2 20 04 80 	movabs $0x800420a294,%rdi
  8004209102:	00 00 00 
  8004209105:	b8 00 00 00 00       	mov    $0x0,%eax
  800420910a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004209111:	00 00 00 
  8004209114:	41 ff d0             	callq  *%r8
	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
  8004209117:	48 81 65 e8 00 fe ff 	andq   $0xfffffffffffffe00,-0x18(%rbp)
  800420911e:	ff 

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
  800420911f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004209123:	48 c1 e8 09          	shr    $0x9,%rax
  8004209127:	48 83 c0 01          	add    $0x1,%rax
  800420912b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  800420912f:	eb 3c                	jmp    800420916d <readseg+0xc8>
		readsect((uint8_t*) pa, offset);
  8004209131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209135:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004209139:	48 89 d6             	mov    %rdx,%rsi
  800420913c:	48 89 c7             	mov    %rax,%rdi
  800420913f:	48 b8 35 92 20 04 80 	movabs $0x8004209235,%rax
  8004209146:	00 00 00 
  8004209149:	ff d0                	callq  *%rax
		pa += SECTSIZE;
  800420914b:	48 81 45 e8 00 02 00 	addq   $0x200,-0x18(%rbp)
  8004209152:	00 
		*kvoffset += SECTSIZE;
  8004209153:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004209157:	48 8b 00             	mov    (%rax),%rax
  800420915a:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  8004209161:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004209165:	48 89 10             	mov    %rdx,(%rax)
		offset++;
  8004209168:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  800420916d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209171:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8004209175:	72 ba                	jb     8004209131 <readseg+0x8c>
		pa += SECTSIZE;
		*kvoffset += SECTSIZE;
		offset++;
	}

	if(((orgoff % SECTSIZE) + count) > SECTSIZE)
  8004209177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420917b:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004209180:	48 89 c2             	mov    %rax,%rdx
  8004209183:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004209187:	48 01 d0             	add    %rdx,%rax
  800420918a:	48 3d 00 02 00 00    	cmp    $0x200,%rax
  8004209190:	76 2f                	jbe    80042091c1 <readseg+0x11c>
	{
		readsect((uint8_t*) pa, offset);
  8004209192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209196:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420919a:	48 89 d6             	mov    %rdx,%rsi
  800420919d:	48 89 c7             	mov    %rax,%rdi
  80042091a0:	48 b8 35 92 20 04 80 	movabs $0x8004209235,%rax
  80042091a7:	00 00 00 
  80042091aa:	ff d0                	callq  *%rax
		*kvoffset += SECTSIZE;
  80042091ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042091b0:	48 8b 00             	mov    (%rax),%rax
  80042091b3:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  80042091ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042091be:	48 89 10             	mov    %rdx,(%rax)
	}
	assert(*kvoffset % SECTSIZE == 0);
  80042091c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042091c5:	48 8b 00             	mov    (%rax),%rax
  80042091c8:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042091cd:	48 85 c0             	test   %rax,%rax
  80042091d0:	74 35                	je     8004209207 <readseg+0x162>
  80042091d2:	48 b9 b5 a2 20 04 80 	movabs $0x800420a2b5,%rcx
  80042091d9:	00 00 00 
  80042091dc:	48 ba 7f a2 20 04 80 	movabs $0x800420a27f,%rdx
  80042091e3:	00 00 00 
  80042091e6:	be d6 00 00 00       	mov    $0xd6,%esi
  80042091eb:	48 bf 94 a2 20 04 80 	movabs $0x800420a294,%rdi
  80042091f2:	00 00 00 
  80042091f5:	b8 00 00 00 00       	mov    $0x0,%eax
  80042091fa:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004209201:	00 00 00 
  8004209204:	41 ff d0             	callq  *%r8
}
  8004209207:	c9                   	leaveq 
  8004209208:	c3                   	retq   

0000008004209209 <waitdisk>:

void
waitdisk(void)
{
  8004209209:	55                   	push   %rbp
  800420920a:	48 89 e5             	mov    %rsp,%rbp
  800420920d:	48 83 ec 10          	sub    $0x10,%rsp
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
  8004209211:	90                   	nop
  8004209212:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004209219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420921c:	89 c2                	mov    %eax,%edx
  800420921e:	ec                   	in     (%dx),%al
  800420921f:	88 45 fb             	mov    %al,-0x5(%rbp)
	return data;
  8004209222:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004209226:	0f b6 c0             	movzbl %al,%eax
  8004209229:	25 c0 00 00 00       	and    $0xc0,%eax
  800420922e:	83 f8 40             	cmp    $0x40,%eax
  8004209231:	75 df                	jne    8004209212 <waitdisk+0x9>
		/* do nothing */;
}
  8004209233:	c9                   	leaveq 
  8004209234:	c3                   	retq   

0000008004209235 <readsect>:

void
readsect(void *dst, uint64_t offset)
{
  8004209235:	55                   	push   %rbp
  8004209236:	48 89 e5             	mov    %rsp,%rbp
  8004209239:	48 83 ec 60          	sub    $0x60,%rsp
  800420923d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8004209241:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	// wait for disk to be ready
	waitdisk();
  8004209245:	48 b8 09 92 20 04 80 	movabs $0x8004209209,%rax
  800420924c:	00 00 00 
  800420924f:	ff d0                	callq  *%rax
  8004209251:	c7 45 fc f2 01 00 00 	movl   $0x1f2,-0x4(%rbp)
  8004209258:	c6 45 fb 01          	movb   $0x1,-0x5(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800420925c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004209260:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004209263:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
  8004209264:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209268:	0f b6 c0             	movzbl %al,%eax
  800420926b:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%rbp)
  8004209272:	88 45 f3             	mov    %al,-0xd(%rbp)
  8004209275:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8004209279:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420927c:	ee                   	out    %al,(%dx)
	outb(0x1F4, offset >> 8);
  800420927d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209281:	48 c1 e8 08          	shr    $0x8,%rax
  8004209285:	0f b6 c0             	movzbl %al,%eax
  8004209288:	c7 45 ec f4 01 00 00 	movl   $0x1f4,-0x14(%rbp)
  800420928f:	88 45 eb             	mov    %al,-0x15(%rbp)
  8004209292:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  8004209296:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004209299:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
  800420929a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420929e:	48 c1 e8 10          	shr    $0x10,%rax
  80042092a2:	0f b6 c0             	movzbl %al,%eax
  80042092a5:	c7 45 e4 f5 01 00 00 	movl   $0x1f5,-0x1c(%rbp)
  80042092ac:	88 45 e3             	mov    %al,-0x1d(%rbp)
  80042092af:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80042092b3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80042092b6:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
  80042092b7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042092bb:	48 c1 e8 18          	shr    $0x18,%rax
  80042092bf:	83 c8 e0             	or     $0xffffffe0,%eax
  80042092c2:	0f b6 c0             	movzbl %al,%eax
  80042092c5:	c7 45 dc f6 01 00 00 	movl   $0x1f6,-0x24(%rbp)
  80042092cc:	88 45 db             	mov    %al,-0x25(%rbp)
  80042092cf:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  80042092d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80042092d6:	ee                   	out    %al,(%dx)
  80042092d7:	c7 45 d4 f7 01 00 00 	movl   $0x1f7,-0x2c(%rbp)
  80042092de:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
  80042092e2:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  80042092e6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80042092e9:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
  80042092ea:	48 b8 09 92 20 04 80 	movabs $0x8004209209,%rax
  80042092f1:	00 00 00 
  80042092f4:	ff d0                	callq  *%rax
  80042092f6:	c7 45 cc f0 01 00 00 	movl   $0x1f0,-0x34(%rbp)
  80042092fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209301:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004209305:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800420930c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420930f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8004209313:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8004209316:	48 89 ce             	mov    %rcx,%rsi
  8004209319:	48 89 f7             	mov    %rsi,%rdi
  800420931c:	89 c1                	mov    %eax,%ecx
  800420931e:	fc                   	cld    
  800420931f:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  8004209321:	89 c8                	mov    %ecx,%eax
  8004209323:	48 89 fe             	mov    %rdi,%rsi
  8004209326:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420932a:	89 45 bc             	mov    %eax,-0x44(%rbp)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
  800420932d:	c9                   	leaveq 
  800420932e:	c3                   	retq   
