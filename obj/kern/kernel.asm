
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
  8004200068:	48 bf e0 94 20 04 80 	movabs $0x80042094e0,%rdi
  800420006f:	00 00 00 
  8004200072:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200077:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  80042000bf:	48 bf fc 94 20 04 80 	movabs $0x80042094fc,%rdi
  80042000c6:	00 00 00 
  80042000c9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042000ce:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  800420010c:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
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
  8004200129:	48 bf 17 95 20 04 80 	movabs $0x8004209517,%rdi
  8004200130:	00 00 00 
  8004200133:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200138:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  800420013f:	00 00 00 
  8004200142:	ff d2                	callq  *%rdx

	extern char end[];
	end_debug = read_section_headers((0x10000+KERNBASE), (uintptr_t)end);
  8004200144:	48 b8 40 dd 21 04 80 	movabs $0x800421dd40,%rax
  800420014b:	00 00 00 
  800420014e:	48 89 c6             	mov    %rax,%rsi
  8004200151:	48 bf 00 00 01 04 80 	movabs $0x8004010000,%rdi
  8004200158:	00 00 00 
  800420015b:	48 b8 13 8b 20 04 80 	movabs $0x8004208b13,%rax
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
  800420018a:	48 b8 a2 14 20 04 80 	movabs $0x80042014a2,%rax
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
  800420025a:	48 bf 32 95 20 04 80 	movabs $0x8004209532,%rdi
  8004200261:	00 00 00 
  8004200264:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200269:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  8004200270:	00 00 00 
  8004200273:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  8004200275:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  800420027c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004200283:	48 89 d6             	mov    %rdx,%rsi
  8004200286:	48 89 c7             	mov    %rax,%rdi
  8004200289:	48 b8 57 15 20 04 80 	movabs $0x8004201557,%rax
  8004200290:	00 00 00 
  8004200293:	ff d0                	callq  *%rax
	cprintf("\n");
  8004200295:	48 bf 4a 95 20 04 80 	movabs $0x800420954a,%rdi
  800420029c:	00 00 00 
  800420029f:	b8 00 00 00 00       	mov    $0x0,%eax
  80042002a4:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  80042002ab:	00 00 00 
  80042002ae:	ff d2                	callq  *%rdx
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
  80042002b0:	bf 00 00 00 00       	mov    $0x0,%edi
  80042002b5:	48 b8 a2 14 20 04 80 	movabs $0x80042014a2,%rax
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
  8004200358:	48 bf 4c 95 20 04 80 	movabs $0x800420954c,%rdi
  800420035f:	00 00 00 
  8004200362:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200367:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  800420036e:	00 00 00 
  8004200371:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  8004200373:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  800420037a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004200381:	48 89 d6             	mov    %rdx,%rsi
  8004200384:	48 89 c7             	mov    %rax,%rdi
  8004200387:	48 b8 57 15 20 04 80 	movabs $0x8004201557,%rax
  800420038e:	00 00 00 
  8004200391:	ff d0                	callq  *%rax
	cprintf("\n");
  8004200393:	48 bf 4a 95 20 04 80 	movabs $0x800420954a,%rdi
  800420039a:	00 00 00 
  800420039d:	b8 00 00 00 00       	mov    $0x0,%eax
  80042003a2:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  800420093a:	48 b8 7e 31 20 04 80 	movabs $0x800420317e,%rax
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
  8004200c28:	48 bf 66 95 20 04 80 	movabs $0x8004209566,%rdi
  8004200c2f:	00 00 00 
  8004200c32:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200c37:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  8004200e36:	48 bf 72 95 20 04 80 	movabs $0x8004209572,%rdi
  8004200e3d:	00 00 00 
  8004200e40:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200e45:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  8004200f0e:	48 bf e5 95 20 04 80 	movabs $0x80042095e5,%rdi
  8004200f15:	00 00 00 
  8004200f18:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f1d:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
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
  8004200f4f:	48 bf ee 95 20 04 80 	movabs $0x80042095ee,%rdi
  8004200f56:	00 00 00 
  8004200f59:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f5e:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004200f65:	00 00 00 
  8004200f68:	ff d2                	callq  *%rdx
	cprintf("  _start                  %08x (phys)\n", _start);
  8004200f6a:	48 be 0c 00 20 00 00 	movabs $0x20000c,%rsi
  8004200f71:	00 00 00 
  8004200f74:	48 bf 08 96 20 04 80 	movabs $0x8004209608,%rdi
  8004200f7b:	00 00 00 
  8004200f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f83:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004200f8a:	00 00 00 
  8004200f8d:	ff d2                	callq  *%rdx
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
  8004200f8f:	48 ba 0c 00 20 00 00 	movabs $0x20000c,%rdx
  8004200f96:	00 00 00 
  8004200f99:	48 be 0c 00 20 04 80 	movabs $0x800420000c,%rsi
  8004200fa0:	00 00 00 
  8004200fa3:	48 bf 30 96 20 04 80 	movabs $0x8004209630,%rdi
  8004200faa:	00 00 00 
  8004200fad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200fb2:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  8004200fb9:	00 00 00 
  8004200fbc:	ff d1                	callq  *%rcx
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
  8004200fbe:	48 ba dc 94 20 00 00 	movabs $0x2094dc,%rdx
  8004200fc5:	00 00 00 
  8004200fc8:	48 be dc 94 20 04 80 	movabs $0x80042094dc,%rsi
  8004200fcf:	00 00 00 
  8004200fd2:	48 bf 58 96 20 04 80 	movabs $0x8004209658,%rdi
  8004200fd9:	00 00 00 
  8004200fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200fe1:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  8004200fe8:	00 00 00 
  8004200feb:	ff d1                	callq  *%rcx
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
  8004200fed:	48 ba a0 c6 21 00 00 	movabs $0x21c6a0,%rdx
  8004200ff4:	00 00 00 
  8004200ff7:	48 be a0 c6 21 04 80 	movabs $0x800421c6a0,%rsi
  8004200ffe:	00 00 00 
  8004201001:	48 bf 80 96 20 04 80 	movabs $0x8004209680,%rdi
  8004201008:	00 00 00 
  800420100b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201010:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  8004201017:	00 00 00 
  800420101a:	ff d1                	callq  *%rcx
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
  800420101c:	48 ba 40 dd 21 00 00 	movabs $0x21dd40,%rdx
  8004201023:	00 00 00 
  8004201026:	48 be 40 dd 21 04 80 	movabs $0x800421dd40,%rsi
  800420102d:	00 00 00 
  8004201030:	48 bf a8 96 20 04 80 	movabs $0x80042096a8,%rdi
  8004201037:	00 00 00 
  800420103a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420103f:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
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
  80042010a8:	48 bf d0 96 20 04 80 	movabs $0x80042096d0,%rdi
  80042010af:	00 00 00 
  80042010b2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042010b7:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
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
  80042010ce:	48 81 ec 20 05 00 00 	sub    $0x520,%rsp
  80042010d5:	89 bd fc fa ff ff    	mov    %edi,-0x504(%rbp)
  80042010db:	48 89 b5 f0 fa ff ff 	mov    %rsi,-0x510(%rbp)
  80042010e2:	48 89 95 e8 fa ff ff 	mov    %rdx,-0x518(%rbp)

static __inline uint64_t
read_rbp(void)
{
	uint64_t rbp;
	__asm __volatile("movq %%rbp,%0" : "=r" (rbp)::"cc","memory");
  80042010e9:	48 89 e8             	mov    %rbp,%rax
  80042010ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	return rbp;
  80042010f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
	// Your code here.
	uint64_t rbp = read_rbp();
  80042010f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t rip = 0;
  80042010f8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80042010ff:	00 
	read_rip(rip);
  8004201100:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 4201107 <_start+0x40010fb>
  8004201107:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	
	struct Ripdebuginfo info;
	
	int i;
	cprintf("Stack backtrace 4001310(37,33):\n");
  800420110b:	48 bf 00 97 20 04 80 	movabs $0x8004209700,%rdi
  8004201112:	00 00 00 
  8004201115:	b8 00 00 00 00       	mov    $0x0,%eax
  800420111a:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201121:	00 00 00 
  8004201124:	ff d2                	callq  *%rdx
	
	while(rbp != 0)
  8004201126:	e9 54 01 00 00       	jmpq   800420127f <mon_backtrace+0x1b5>
	{
		i = debuginfo_rip(rip, &info);
  800420112b:	48 8d 95 00 fb ff ff 	lea    -0x500(%rbp),%rdx
  8004201132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004201136:	48 89 d6             	mov    %rdx,%rsi
  8004201139:	48 89 c7             	mov    %rax,%rdi
  800420113c:	48 b8 3e 1e 20 04 80 	movabs $0x8004201e3e,%rax
  8004201143:	00 00 00 
  8004201146:	ff d0                	callq  *%rax
  8004201148:	89 45 e8             	mov    %eax,-0x18(%rbp)
		int j = 1;
  800420114b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
		cprintf("  rbp %016x  rip %016x\n", rbp, rip);
  8004201152:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420115a:	48 89 c6             	mov    %rax,%rsi
  800420115d:	48 bf 21 97 20 04 80 	movabs $0x8004209721,%rdi
  8004201164:	00 00 00 
  8004201167:	b8 00 00 00 00       	mov    $0x0,%eax
  800420116c:	48 b9 b6 15 20 04 80 	movabs $0x80042015b6,%rcx
  8004201173:	00 00 00 
  8004201176:	ff d1                	callq  *%rcx
		if(i==0)
  8004201178:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800420117c:	0f 85 e3 00 00 00    	jne    8004201265 <mon_backtrace+0x19b>
		{
			cprintf("       %s:%d: %s+%016x  args:%d", info.rip_file, info.rip_line, 
  8004201182:	8b b5 28 fb ff ff    	mov    -0x4d8(%rbp),%esi
				info.rip_fn_name, (rip-info.rip_fn_addr), info.rip_fn_narg);
  8004201188:	48 8b 85 20 fb ff ff 	mov    -0x4e0(%rbp),%rax
		i = debuginfo_rip(rip, &info);
		int j = 1;
		cprintf("  rbp %016x  rip %016x\n", rbp, rip);
		if(i==0)
		{
			cprintf("       %s:%d: %s+%016x  args:%d", info.rip_file, info.rip_line, 
  800420118f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201193:	48 89 d7             	mov    %rdx,%rdi
  8004201196:	48 29 c7             	sub    %rax,%rdi
  8004201199:	48 8b 8d 10 fb ff ff 	mov    -0x4f0(%rbp),%rcx
  80042011a0:	8b 95 08 fb ff ff    	mov    -0x4f8(%rbp),%edx
  80042011a6:	48 8b 85 00 fb ff ff 	mov    -0x500(%rbp),%rax
  80042011ad:	41 89 f1             	mov    %esi,%r9d
  80042011b0:	49 89 f8             	mov    %rdi,%r8
  80042011b3:	48 89 c6             	mov    %rax,%rsi
  80042011b6:	48 bf 40 97 20 04 80 	movabs $0x8004209740,%rdi
  80042011bd:	00 00 00 
  80042011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042011c5:	49 ba b6 15 20 04 80 	movabs $0x80042015b6,%r10
  80042011cc:	00 00 00 
  80042011cf:	41 ff d2             	callq  *%r10
				info.rip_fn_name, (rip-info.rip_fn_addr), info.rip_fn_narg);
			for(j=1;j<=info.rip_fn_narg;j++)
  80042011d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  80042011d9:	eb 64                	jmp    800420123f <mon_backtrace+0x175>
			{
				if(j==1)
  80042011db:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80042011df:	75 29                	jne    800420120a <mon_backtrace+0x140>
					cprintf("  %016x", *(uint32_t *)(rbp-4));
  80042011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042011e5:	48 83 e8 04          	sub    $0x4,%rax
  80042011e9:	8b 00                	mov    (%rax),%eax
  80042011eb:	89 c6                	mov    %eax,%esi
  80042011ed:	48 bf 60 97 20 04 80 	movabs $0x8004209760,%rdi
  80042011f4:	00 00 00 
  80042011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042011fc:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201203:	00 00 00 
  8004201206:	ff d2                	callq  *%rdx
  8004201208:	eb 31                	jmp    800420123b <mon_backtrace+0x171>
				else
					cprintf("  %016x", *(uint32_t *)(rbp-j*8));
  800420120a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420120d:	c1 e0 03             	shl    $0x3,%eax
  8004201210:	48 98                	cltq   
  8004201212:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004201216:	48 29 c2             	sub    %rax,%rdx
  8004201219:	48 89 d0             	mov    %rdx,%rax
  800420121c:	8b 00                	mov    (%rax),%eax
  800420121e:	89 c6                	mov    %eax,%esi
  8004201220:	48 bf 60 97 20 04 80 	movabs $0x8004209760,%rdi
  8004201227:	00 00 00 
  800420122a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420122f:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201236:	00 00 00 
  8004201239:	ff d2                	callq  *%rdx
		cprintf("  rbp %016x  rip %016x\n", rbp, rip);
		if(i==0)
		{
			cprintf("       %s:%d: %s+%016x  args:%d", info.rip_file, info.rip_line, 
				info.rip_fn_name, (rip-info.rip_fn_addr), info.rip_fn_narg);
			for(j=1;j<=info.rip_fn_narg;j++)
  800420123b:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800420123f:	8b 85 28 fb ff ff    	mov    -0x4d8(%rbp),%eax
  8004201245:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8004201248:	7d 91                	jge    80042011db <mon_backtrace+0x111>
				if(j==1)
					cprintf("  %016x", *(uint32_t *)(rbp-4));
				else
					cprintf("  %016x", *(uint32_t *)(rbp-j*8));
			}
			cprintf("\n");
  800420124a:	48 bf 68 97 20 04 80 	movabs $0x8004209768,%rdi
  8004201251:	00 00 00 
  8004201254:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201259:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201260:	00 00 00 
  8004201263:	ff d2                	callq  *%rdx
		}
		rip = *(uint64_t *)(rbp + 8);
  8004201265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201269:	48 83 c0 08          	add    $0x8,%rax
  800420126d:	48 8b 00             	mov    (%rax),%rax
  8004201270:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		rbp = *(uint64_t *)(rbp);
  8004201274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201278:	48 8b 00             	mov    (%rax),%rax
  800420127b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Ripdebuginfo info;
	
	int i;
	cprintf("Stack backtrace 4001310(37,33):\n");
	
	while(rbp != 0)
  800420127f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004201284:	0f 85 a1 fe ff ff    	jne    800420112b <mon_backtrace+0x61>
			cprintf("\n");
		}
		rip = *(uint64_t *)(rbp + 8);
		rbp = *(uint64_t *)(rbp);
	}
	return 0;
  800420128a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420128f:	c9                   	leaveq 
  8004201290:	c3                   	retq   

0000008004201291 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
  8004201291:	55                   	push   %rbp
  8004201292:	48 89 e5             	mov    %rsp,%rbp
  8004201295:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800420129c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80042012a3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  80042012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	argv[argc] = 0;
  80042012b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042012b4:	48 98                	cltq   
  80042012b6:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  80042012bd:	ff 00 00 00 00 
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  80042012c2:	eb 15                	jmp    80042012d9 <runcmd+0x48>
			*buf++ = 0;
  80042012c4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042012cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042012cf:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  80042012d6:	c6 00 00             	movb   $0x0,(%rax)
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  80042012d9:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042012e0:	0f b6 00             	movzbl (%rax),%eax
  80042012e3:	84 c0                	test   %al,%al
  80042012e5:	74 2a                	je     8004201311 <runcmd+0x80>
  80042012e7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042012ee:	0f b6 00             	movzbl (%rax),%eax
  80042012f1:	0f be c0             	movsbl %al,%eax
  80042012f4:	89 c6                	mov    %eax,%esi
  80042012f6:	48 bf 6a 97 20 04 80 	movabs $0x800420976a,%rdi
  80042012fd:	00 00 00 
  8004201300:	48 b8 80 30 20 04 80 	movabs $0x8004203080,%rax
  8004201307:	00 00 00 
  800420130a:	ff d0                	callq  *%rax
  800420130c:	48 85 c0             	test   %rax,%rax
  800420130f:	75 b3                	jne    80042012c4 <runcmd+0x33>
			*buf++ = 0;
		if (*buf == 0)
  8004201311:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004201318:	0f b6 00             	movzbl (%rax),%eax
  800420131b:	84 c0                	test   %al,%al
  800420131d:	75 21                	jne    8004201340 <runcmd+0xaf>
			break;
  800420131f:	90                   	nop
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  8004201320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201323:	48 98                	cltq   
  8004201325:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  800420132c:	ff 00 00 00 00 

	// Lookup and invoke the command
	if (argc == 0)
  8004201331:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004201335:	0f 85 a1 00 00 00    	jne    80042013dc <runcmd+0x14b>
  800420133b:	e9 92 00 00 00       	jmpq   80042013d2 <runcmd+0x141>
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  8004201340:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
  8004201344:	75 2a                	jne    8004201370 <runcmd+0xdf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  8004201346:	be 10 00 00 00       	mov    $0x10,%esi
  800420134b:	48 bf 6f 97 20 04 80 	movabs $0x800420976f,%rdi
  8004201352:	00 00 00 
  8004201355:	b8 00 00 00 00       	mov    $0x0,%eax
  800420135a:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201361:	00 00 00 
  8004201364:	ff d2                	callq  *%rdx
			return 0;
  8004201366:	b8 00 00 00 00       	mov    $0x0,%eax
  800420136b:	e9 30 01 00 00       	jmpq   80042014a0 <runcmd+0x20f>
		}
		argv[argc++] = buf;
  8004201370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201373:	8d 50 01             	lea    0x1(%rax),%edx
  8004201376:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8004201379:	48 98                	cltq   
  800420137b:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
  8004201382:	48 89 94 c5 70 ff ff 	mov    %rdx,-0x90(%rbp,%rax,8)
  8004201389:	ff 
		while (*buf && !strchr(WHITESPACE, *buf))
  800420138a:	eb 08                	jmp    8004201394 <runcmd+0x103>
			buf++;
  800420138c:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  8004201393:	01 
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  8004201394:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420139b:	0f b6 00             	movzbl (%rax),%eax
  800420139e:	84 c0                	test   %al,%al
  80042013a0:	74 2a                	je     80042013cc <runcmd+0x13b>
  80042013a2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042013a9:	0f b6 00             	movzbl (%rax),%eax
  80042013ac:	0f be c0             	movsbl %al,%eax
  80042013af:	89 c6                	mov    %eax,%esi
  80042013b1:	48 bf 6a 97 20 04 80 	movabs $0x800420976a,%rdi
  80042013b8:	00 00 00 
  80042013bb:	48 b8 80 30 20 04 80 	movabs $0x8004203080,%rax
  80042013c2:	00 00 00 
  80042013c5:	ff d0                	callq  *%rax
  80042013c7:	48 85 c0             	test   %rax,%rax
  80042013ca:	74 c0                	je     800420138c <runcmd+0xfb>
			buf++;
	}
  80042013cc:	90                   	nop
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  80042013cd:	e9 07 ff ff ff       	jmpq   80042012d9 <runcmd+0x48>
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
  80042013d2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042013d7:	e9 c4 00 00 00       	jmpq   80042014a0 <runcmd+0x20f>
	for (i = 0; i < NCOMMANDS; i++) {
  80042013dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80042013e3:	e9 82 00 00 00       	jmpq   800420146a <runcmd+0x1d9>
		if (strcmp(argv[0], commands[i].name) == 0)
  80042013e8:	48 b9 80 c5 21 04 80 	movabs $0x800421c580,%rcx
  80042013ef:	00 00 00 
  80042013f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042013f5:	48 63 d0             	movslq %eax,%rdx
  80042013f8:	48 89 d0             	mov    %rdx,%rax
  80042013fb:	48 01 c0             	add    %rax,%rax
  80042013fe:	48 01 d0             	add    %rdx,%rax
  8004201401:	48 c1 e0 03          	shl    $0x3,%rax
  8004201405:	48 01 c8             	add    %rcx,%rax
  8004201408:	48 8b 10             	mov    (%rax),%rdx
  800420140b:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004201412:	48 89 d6             	mov    %rdx,%rsi
  8004201415:	48 89 c7             	mov    %rax,%rdi
  8004201418:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  800420141f:	00 00 00 
  8004201422:	ff d0                	callq  *%rax
  8004201424:	85 c0                	test   %eax,%eax
  8004201426:	75 3e                	jne    8004201466 <runcmd+0x1d5>
			return commands[i].func(argc, argv, tf);
  8004201428:	48 b9 80 c5 21 04 80 	movabs $0x800421c580,%rcx
  800420142f:	00 00 00 
  8004201432:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004201435:	48 63 d0             	movslq %eax,%rdx
  8004201438:	48 89 d0             	mov    %rdx,%rax
  800420143b:	48 01 c0             	add    %rax,%rax
  800420143e:	48 01 d0             	add    %rdx,%rax
  8004201441:	48 c1 e0 03          	shl    $0x3,%rax
  8004201445:	48 01 c8             	add    %rcx,%rax
  8004201448:	48 83 c0 10          	add    $0x10,%rax
  800420144c:	48 8b 00             	mov    (%rax),%rax
  800420144f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004201456:	48 8d b5 70 ff ff ff 	lea    -0x90(%rbp),%rsi
  800420145d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004201460:	89 cf                	mov    %ecx,%edi
  8004201462:	ff d0                	callq  *%rax
  8004201464:	eb 3a                	jmp    80042014a0 <runcmd+0x20f>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  8004201466:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800420146a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800420146d:	83 f8 01             	cmp    $0x1,%eax
  8004201470:	0f 86 72 ff ff ff    	jbe    80042013e8 <runcmd+0x157>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  8004201476:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420147d:	48 89 c6             	mov    %rax,%rsi
  8004201480:	48 bf 8c 97 20 04 80 	movabs $0x800420978c,%rdi
  8004201487:	00 00 00 
  800420148a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420148f:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004201496:	00 00 00 
  8004201499:	ff d2                	callq  *%rdx
	return 0;
  800420149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042014a0:	c9                   	leaveq 
  80042014a1:	c3                   	retq   

00000080042014a2 <monitor>:

void
monitor(struct Trapframe *tf)
{
  80042014a2:	55                   	push   %rbp
  80042014a3:	48 89 e5             	mov    %rsp,%rbp
  80042014a6:	48 83 ec 20          	sub    $0x20,%rsp
  80042014aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
  80042014ae:	48 bf a8 97 20 04 80 	movabs $0x80042097a8,%rdi
  80042014b5:	00 00 00 
  80042014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042014bd:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  80042014c4:	00 00 00 
  80042014c7:	ff d2                	callq  *%rdx
	cprintf("Type 'help' for a list of commands.\n");
  80042014c9:	48 bf d0 97 20 04 80 	movabs $0x80042097d0,%rdi
  80042014d0:	00 00 00 
  80042014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042014d8:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  80042014df:	00 00 00 
  80042014e2:	ff d2                	callq  *%rdx


	while (1) {
		buf = readline("K> ");
  80042014e4:	48 bf f5 97 20 04 80 	movabs $0x80042097f5,%rdi
  80042014eb:	00 00 00 
  80042014ee:	48 b8 9f 2c 20 04 80 	movabs $0x8004202c9f,%rax
  80042014f5:	00 00 00 
  80042014f8:	ff d0                	callq  *%rax
  80042014fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (buf != NULL)
  80042014fe:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004201503:	74 20                	je     8004201525 <monitor+0x83>
			if (runcmd(buf, tf) < 0)
  8004201505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004201509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420150d:	48 89 d6             	mov    %rdx,%rsi
  8004201510:	48 89 c7             	mov    %rax,%rdi
  8004201513:	48 b8 91 12 20 04 80 	movabs $0x8004201291,%rax
  800420151a:	00 00 00 
  800420151d:	ff d0                	callq  *%rax
  800420151f:	85 c0                	test   %eax,%eax
  8004201521:	79 02                	jns    8004201525 <monitor+0x83>
				break;
  8004201523:	eb 02                	jmp    8004201527 <monitor+0x85>
	}
  8004201525:	eb bd                	jmp    80042014e4 <monitor+0x42>
}
  8004201527:	c9                   	leaveq 
  8004201528:	c3                   	retq   

0000008004201529 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
  8004201529:	55                   	push   %rbp
  800420152a:	48 89 e5             	mov    %rsp,%rbp
  800420152d:	48 83 ec 10          	sub    $0x10,%rsp
  8004201531:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004201534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cputchar(ch);
  8004201538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420153b:	89 c7                	mov    %eax,%edi
  800420153d:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004201544:	00 00 00 
  8004201547:	ff d0                	callq  *%rax
	*cnt++;
  8004201549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420154d:	48 83 c0 04          	add    $0x4,%rax
  8004201551:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
}
  8004201555:	c9                   	leaveq 
  8004201556:	c3                   	retq   

0000008004201557 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004201557:	55                   	push   %rbp
  8004201558:	48 89 e5             	mov    %rsp,%rbp
  800420155b:	48 83 ec 30          	sub    $0x30,%rsp
  800420155f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004201563:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int cnt = 0;
  8004201567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800420156e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8004201572:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201576:	48 8b 0a             	mov    (%rdx),%rcx
  8004201579:	48 89 08             	mov    %rcx,(%rax)
  800420157c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004201580:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004201584:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004201588:	48 89 50 10          	mov    %rdx,0x10(%rax)
	vprintfmt((void*)putch, &cnt, fmt, aq);
  800420158c:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8004201590:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004201594:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  8004201598:	48 89 c6             	mov    %rax,%rsi
  800420159b:	48 bf 29 15 20 04 80 	movabs $0x8004201529,%rdi
  80042015a2:	00 00 00 
  80042015a5:	48 b8 09 25 20 04 80 	movabs $0x8004202509,%rax
  80042015ac:	00 00 00 
  80042015af:	ff d0                	callq  *%rax
	va_end(aq);
	return cnt;
  80042015b1:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80042015b4:	c9                   	leaveq 
  80042015b5:	c3                   	retq   

00000080042015b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042015b6:	55                   	push   %rbp
  80042015b7:	48 89 e5             	mov    %rsp,%rbp
  80042015ba:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80042015c1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80042015c8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80042015cf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80042015d6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80042015dd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80042015e4:	84 c0                	test   %al,%al
  80042015e6:	74 20                	je     8004201608 <cprintf+0x52>
  80042015e8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80042015ec:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80042015f0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80042015f4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042015f8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80042015fc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004201600:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004201604:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004201608:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_start(ap, fmt);
  800420160f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004201616:	00 00 00 
  8004201619:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004201620:	00 00 00 
  8004201623:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004201627:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800420162e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004201635:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800420163c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004201643:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800420164a:	48 8b 0a             	mov    (%rdx),%rcx
  800420164d:	48 89 08             	mov    %rcx,(%rax)
  8004201650:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004201654:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004201658:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800420165c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8004201660:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004201667:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800420166e:	48 89 d6             	mov    %rdx,%rsi
  8004201671:	48 89 c7             	mov    %rax,%rdi
  8004201674:	48 b8 57 15 20 04 80 	movabs $0x8004201557,%rax
  800420167b:	00 00 00 
  800420167e:	ff d0                	callq  *%rax
  8004201680:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004201686:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800420168c:	c9                   	leaveq 
  800420168d:	c3                   	retq   

000000800420168e <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int64_t
syscall(uint64_t syscallno, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800420168e:	55                   	push   %rbp
  800420168f:	48 89 e5             	mov    %rsp,%rbp
  8004201692:	48 83 ec 30          	sub    $0x30,%rsp
  8004201696:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420169a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800420169e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80042016a2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80042016a6:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
  80042016aa:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	panic("syscall not implemented");
  80042016ae:	48 ba f9 97 20 04 80 	movabs $0x80042097f9,%rdx
  80042016b5:	00 00 00 
  80042016b8:	be 0e 00 00 00       	mov    $0xe,%esi
  80042016bd:	48 bf 11 98 20 04 80 	movabs $0x8004209811,%rdi
  80042016c4:	00 00 00 
  80042016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042016cc:	48 b9 98 01 20 04 80 	movabs $0x8004200198,%rcx
  80042016d3:	00 00 00 
  80042016d6:	ff d1                	callq  *%rcx

00000080042016d8 <list_func_die>:

#endif


int list_func_die(struct Ripdebuginfo *info, Dwarf_Die *die, uint64_t addr)
{
  80042016d8:	55                   	push   %rbp
  80042016d9:	48 89 e5             	mov    %rsp,%rbp
  80042016dc:	48 81 ec f0 61 00 00 	sub    $0x61f0,%rsp
  80042016e3:	48 89 bd 58 9e ff ff 	mov    %rdi,-0x61a8(%rbp)
  80042016ea:	48 89 b5 50 9e ff ff 	mov    %rsi,-0x61b0(%rbp)
  80042016f1:	48 89 95 48 9e ff ff 	mov    %rdx,-0x61b8(%rbp)
	_Dwarf_Line ln;
	Dwarf_Attribute *low;
	Dwarf_Attribute *high;
	Dwarf_CU *cu = die->cu_header;
  80042016f8:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042016ff:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  8004201706:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Dwarf_Die *cudie = die->cu_die; 
  800420170a:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201711:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  8004201718:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	Dwarf_Die ret, sib=*die; 
  800420171c:	48 8b 95 50 9e ff ff 	mov    -0x61b0(%rbp),%rdx
  8004201723:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  800420172a:	48 89 d1             	mov    %rdx,%rcx
  800420172d:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201732:	48 89 ce             	mov    %rcx,%rsi
  8004201735:	48 89 c7             	mov    %rax,%rdi
  8004201738:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  800420173f:	00 00 00 
  8004201742:	ff d0                	callq  *%rax
	Dwarf_Attribute *attr;
	uint64_t offset;
	uint64_t ret_val=8;
  8004201744:	48 c7 45 f8 08 00 00 	movq   $0x8,-0x8(%rbp)
  800420174b:	00 
	uint64_t ret_offset=0;
  800420174c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004201753:	00 

	if(die->die_tag != DW_TAG_subprogram)
  8004201754:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  800420175b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420175f:	48 83 f8 2e          	cmp    $0x2e,%rax
  8004201763:	74 0a                	je     800420176f <list_func_die+0x97>
		return 0;
  8004201765:	b8 00 00 00 00       	mov    $0x0,%eax
  800420176a:	e9 cd 06 00 00       	jmpq   8004201e3c <list_func_die+0x764>

	memset(&ln, 0, sizeof(_Dwarf_Line));
  800420176f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004201776:	ba 38 00 00 00       	mov    $0x38,%edx
  800420177b:	be 00 00 00 00       	mov    $0x0,%esi
  8004201780:	48 89 c7             	mov    %rax,%rdi
  8004201783:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  800420178a:	00 00 00 
  800420178d:	ff d0                	callq  *%rax

	low  = _dwarf_attr_find(die, DW_AT_low_pc);
  800420178f:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201796:	be 11 00 00 00       	mov    $0x11,%esi
  800420179b:	48 89 c7             	mov    %rax,%rdi
  800420179e:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  80042017a5:	00 00 00 
  80042017a8:	ff d0                	callq  *%rax
  80042017aa:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	high = _dwarf_attr_find(die, DW_AT_high_pc);
  80042017ae:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042017b5:	be 12 00 00 00       	mov    $0x12,%esi
  80042017ba:	48 89 c7             	mov    %rax,%rdi
  80042017bd:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  80042017c4:	00 00 00 
  80042017c7:	ff d0                	callq  *%rax
  80042017c9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

	if((low && (low->u[0].u64 < addr)) && (high && (high->u[0].u64 > addr)))
  80042017cd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042017d2:	0f 84 5f 06 00 00    	je     8004201e37 <list_func_die+0x75f>
  80042017d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042017dc:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042017e0:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  80042017e7:	0f 83 4a 06 00 00    	jae    8004201e37 <list_func_die+0x75f>
  80042017ed:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042017f2:	0f 84 3f 06 00 00    	je     8004201e37 <list_func_die+0x75f>
  80042017f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042017fc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201800:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  8004201807:	0f 86 2a 06 00 00    	jbe    8004201e37 <list_func_die+0x75f>
	{
		info->rip_file = die->cu_die->die_name;
  800420180d:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201814:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  800420181b:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  8004201822:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201829:	48 89 10             	mov    %rdx,(%rax)

		info->rip_fn_name = die->die_name;
  800420182c:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201833:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  800420183a:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201841:	48 89 50 10          	mov    %rdx,0x10(%rax)
		info->rip_fn_namelen = strlen(die->die_name);
  8004201845:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  800420184c:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8004201853:	48 89 c7             	mov    %rax,%rdi
  8004201856:	48 b8 ee 2d 20 04 80 	movabs $0x8004202dee,%rax
  800420185d:	00 00 00 
  8004201860:	ff d0                	callq  *%rax
  8004201862:	48 8b 95 58 9e ff ff 	mov    -0x61a8(%rbp),%rdx
  8004201869:	89 42 18             	mov    %eax,0x18(%rdx)

		info->rip_fn_addr = (uintptr_t)low->u[0].u64;
  800420186c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004201870:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004201874:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  800420187b:	48 89 50 20          	mov    %rdx,0x20(%rax)

		assert(die->cu_die);	
  800420187f:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004201886:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  800420188d:	48 85 c0             	test   %rax,%rax
  8004201890:	75 35                	jne    80042018c7 <list_func_die+0x1ef>
  8004201892:	48 b9 40 9b 20 04 80 	movabs $0x8004209b40,%rcx
  8004201899:	00 00 00 
  800420189c:	48 ba 4c 9b 20 04 80 	movabs $0x8004209b4c,%rdx
  80042018a3:	00 00 00 
  80042018a6:	be 88 00 00 00       	mov    $0x88,%esi
  80042018ab:	48 bf 61 9b 20 04 80 	movabs $0x8004209b61,%rdi
  80042018b2:	00 00 00 
  80042018b5:	b8 00 00 00 00       	mov    $0x0,%eax
  80042018ba:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042018c1:	00 00 00 
  80042018c4:	41 ff d0             	callq  *%r8
		dwarf_srclines(die->cu_die, &ln, addr, NULL); 
  80042018c7:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042018ce:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  80042018d5:	48 8b 95 48 9e ff ff 	mov    -0x61b8(%rbp),%rdx
  80042018dc:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  80042018e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  80042018e8:	48 89 c7             	mov    %rax,%rdi
  80042018eb:	48 b8 4f 86 20 04 80 	movabs $0x800420864f,%rax
  80042018f2:	00 00 00 
  80042018f5:	ff d0                	callq  *%rax

		info->rip_line = ln.ln_lineno;
  80042018f7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042018fe:	89 c2                	mov    %eax,%edx
  8004201900:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201907:	89 50 08             	mov    %edx,0x8(%rax)
		info->rip_fn_narg = 0;
  800420190a:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201911:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)

		Dwarf_Attribute* attr;

		if(dwarf_child(dbg, cu, &sib, &ret) != DW_DLE_NO_ENTRY)
  8004201918:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  800420191f:	00 00 00 
  8004201922:	48 8b 00             	mov    (%rax),%rax
  8004201925:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  800420192c:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004201933:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004201937:	48 89 c7             	mov    %rax,%rdi
  800420193a:	48 b8 ff 52 20 04 80 	movabs $0x80042052ff,%rax
  8004201941:	00 00 00 
  8004201944:	ff d0                	callq  *%rax
  8004201946:	83 f8 04             	cmp    $0x4,%eax
  8004201949:	0f 84 e1 04 00 00    	je     8004201e30 <list_func_die+0x758>
		{
			if(ret.die_tag != DW_TAG_formal_parameter)
  800420194f:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  8004201956:	48 83 f8 05          	cmp    $0x5,%rax
  800420195a:	74 05                	je     8004201961 <list_func_die+0x289>
				goto last;
  800420195c:	e9 cf 04 00 00       	jmpq   8004201e30 <list_func_die+0x758>

			attr = _dwarf_attr_find(&ret, DW_AT_type);
  8004201961:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201968:	be 49 00 00 00       	mov    $0x49,%esi
  800420196d:	48 89 c7             	mov    %rax,%rdi
  8004201970:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201977:	00 00 00 
  800420197a:	ff d0                	callq  *%rax
  800420197c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	
		try_again:
			if(attr != NULL)
  8004201980:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201985:	0f 84 d7 00 00 00    	je     8004201a62 <list_func_die+0x38a>
			{
				offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  800420198b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420198f:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004201993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201997:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420199b:	48 01 d0             	add    %rdx,%rax
  800420199e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
				dwarf_offdie(dbg, offset, &sib, *cu);
  80042019a2:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042019a9:	00 00 00 
  80042019ac:	48 8b 08             	mov    (%rax),%rcx
  80042019af:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  80042019b6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80042019ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042019be:	48 8b 38             	mov    (%rax),%rdi
  80042019c1:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042019c5:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80042019c9:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  80042019ce:	48 8b 78 10          	mov    0x10(%rax),%rdi
  80042019d2:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  80042019d7:	48 8b 78 18          	mov    0x18(%rax),%rdi
  80042019db:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  80042019e0:	48 8b 78 20          	mov    0x20(%rax),%rdi
  80042019e4:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  80042019e9:	48 8b 78 28          	mov    0x28(%rax),%rdi
  80042019ed:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  80042019f2:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042019f6:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80042019fb:	48 89 cf             	mov    %rcx,%rdi
  80042019fe:	48 b8 25 4f 20 04 80 	movabs $0x8004204f25,%rax
  8004201a05:	00 00 00 
  8004201a08:	ff d0                	callq  *%rax
				attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  8004201a0a:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201a11:	be 0b 00 00 00       	mov    $0xb,%esi
  8004201a16:	48 89 c7             	mov    %rax,%rdi
  8004201a19:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201a20:	00 00 00 
  8004201a23:	ff d0                	callq  *%rax
  8004201a25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		
				if(attr != NULL)
  8004201a29:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201a2e:	74 0e                	je     8004201a3e <list_func_die+0x366>
				{
					ret_val = attr->u[0].u64;
  8004201a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201a34:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201a38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004201a3c:	eb 24                	jmp    8004201a62 <list_func_die+0x38a>
				}
				else
				{
					attr = _dwarf_attr_find(&sib, DW_AT_type);
  8004201a3e:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201a45:	be 49 00 00 00       	mov    $0x49,%esi
  8004201a4a:	48 89 c7             	mov    %rax,%rdi
  8004201a4d:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201a54:	00 00 00 
  8004201a57:	ff d0                	callq  *%rax
  8004201a59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					goto try_again;
  8004201a5d:	e9 1e ff ff ff       	jmpq   8004201980 <list_func_die+0x2a8>
				}
			}

			ret_offset = 0;
  8004201a62:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004201a69:	00 
			attr = _dwarf_attr_find(&ret, DW_AT_location);
  8004201a6a:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201a71:	be 02 00 00 00       	mov    $0x2,%esi
  8004201a76:	48 89 c7             	mov    %rax,%rdi
  8004201a79:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201a80:	00 00 00 
  8004201a83:	ff d0                	callq  *%rax
  8004201a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if (attr != NULL)
  8004201a89:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201a8e:	0f 84 a2 00 00 00    	je     8004201b36 <list_func_die+0x45e>
			{
				Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  8004201a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201a98:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004201a9c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
				Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  8004201aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201aa4:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004201aa8:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
				Dwarf_Small atom;
				Dwarf_Unsigned op1, op2;

				switch(attr->at_form) {
  8004201aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201ab0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004201ab4:	48 83 f8 03          	cmp    $0x3,%rax
  8004201ab8:	72 7c                	jb     8004201b36 <list_func_die+0x45e>
  8004201aba:	48 83 f8 04          	cmp    $0x4,%rax
  8004201abe:	76 06                	jbe    8004201ac6 <list_func_die+0x3ee>
  8004201ac0:	48 83 f8 0a          	cmp    $0xa,%rax
  8004201ac4:	75 70                	jne    8004201b36 <list_func_die+0x45e>
					case DW_FORM_block1:
					case DW_FORM_block2:
					case DW_FORM_block4:
						offset = 0;
  8004201ac6:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004201acd:	00 
						atom = *(loc_ptr++);
  8004201ace:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201ad2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004201ad6:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
  8004201ada:	0f b6 00             	movzbl (%rax),%eax
  8004201add:	88 45 af             	mov    %al,-0x51(%rbp)
						offset++;
  8004201ae0:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
						if (atom == DW_OP_fbreg) {
  8004201ae5:	80 7d af 91          	cmpb   $0x91,-0x51(%rbp)
  8004201ae9:	75 4a                	jne    8004201b35 <list_func_die+0x45d>
							uint8_t *p = loc_ptr;
  8004201aeb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201aef:	48 89 85 68 9e ff ff 	mov    %rax,-0x6198(%rbp)
							ret_offset = _dwarf_decode_sleb128(&p);
  8004201af6:	48 8d 85 68 9e ff ff 	lea    -0x6198(%rbp),%rax
  8004201afd:	48 89 c7             	mov    %rax,%rdi
  8004201b00:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004201b07:	00 00 00 
  8004201b0a:	ff d0                	callq  *%rax
  8004201b0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
							offset += p - loc_ptr;
  8004201b10:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  8004201b17:	48 89 c2             	mov    %rax,%rdx
  8004201b1a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004201b1e:	48 29 c2             	sub    %rax,%rdx
  8004201b21:	48 89 d0             	mov    %rdx,%rax
  8004201b24:	48 01 45 c0          	add    %rax,-0x40(%rbp)
							loc_ptr = p;
  8004201b28:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  8004201b2f:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
						}
						break;
  8004201b33:	eb 00                	jmp    8004201b35 <list_func_die+0x45d>
  8004201b35:	90                   	nop
				}
			}

			info->size_fn_arg[info->rip_fn_narg] = ret_val;
  8004201b36:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b3d:	8b 48 28             	mov    0x28(%rax),%ecx
  8004201b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201b44:	89 c2                	mov    %eax,%edx
  8004201b46:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b4d:	48 63 c9             	movslq %ecx,%rcx
  8004201b50:	48 83 c1 08          	add    $0x8,%rcx
  8004201b54:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
  8004201b58:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b5f:	8b 50 28             	mov    0x28(%rax),%edx
  8004201b62:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b69:	48 63 d2             	movslq %edx,%rdx
  8004201b6c:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  8004201b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201b74:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
			info->rip_fn_narg++;
  8004201b79:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b80:	8b 40 28             	mov    0x28(%rax),%eax
  8004201b83:	8d 50 01             	lea    0x1(%rax),%edx
  8004201b86:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201b8d:	89 50 28             	mov    %edx,0x28(%rax)
			sib = ret; 
  8004201b90:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201b97:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  8004201b9e:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201ba3:	48 89 ce             	mov    %rcx,%rsi
  8004201ba6:	48 89 c7             	mov    %rax,%rdi
  8004201ba9:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004201bb0:	00 00 00 
  8004201bb3:	ff d0                	callq  *%rax

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004201bb5:	e9 40 02 00 00       	jmpq   8004201dfa <list_func_die+0x722>
			{
				if(ret.die_tag != DW_TAG_formal_parameter)
  8004201bba:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  8004201bc1:	48 83 f8 05          	cmp    $0x5,%rax
  8004201bc5:	74 05                	je     8004201bcc <list_func_die+0x4f4>
					break;
  8004201bc7:	e9 64 02 00 00       	jmpq   8004201e30 <list_func_die+0x758>

				attr = _dwarf_attr_find(&ret, DW_AT_type);
  8004201bcc:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201bd3:	be 49 00 00 00       	mov    $0x49,%esi
  8004201bd8:	48 89 c7             	mov    %rax,%rdi
  8004201bdb:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201be2:	00 00 00 
  8004201be5:	ff d0                	callq  *%rax
  8004201be7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    
				if(attr != NULL)
  8004201beb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201bf0:	0f 84 b1 00 00 00    	je     8004201ca7 <list_func_die+0x5cf>
				{	   
					offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  8004201bf6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201bfa:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004201bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201c02:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201c06:	48 01 d0             	add    %rdx,%rax
  8004201c09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
					dwarf_offdie(dbg, offset, &sib, *cu);
  8004201c0d:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201c14:	00 00 00 
  8004201c17:	48 8b 08             	mov    (%rax),%rcx
  8004201c1a:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004201c21:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004201c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201c29:	48 8b 38             	mov    (%rax),%rdi
  8004201c2c:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004201c30:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8004201c34:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004201c39:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004201c3d:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  8004201c42:	48 8b 78 18          	mov    0x18(%rax),%rdi
  8004201c46:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004201c4b:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8004201c4f:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004201c54:	48 8b 78 28          	mov    0x28(%rax),%rdi
  8004201c58:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004201c5d:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004201c61:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8004201c66:	48 89 cf             	mov    %rcx,%rdi
  8004201c69:	48 b8 25 4f 20 04 80 	movabs $0x8004204f25,%rax
  8004201c70:	00 00 00 
  8004201c73:	ff d0                	callq  *%rax
					attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  8004201c75:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201c7c:	be 0b 00 00 00       	mov    $0xb,%esi
  8004201c81:	48 89 c7             	mov    %rax,%rdi
  8004201c84:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201c8b:	00 00 00 
  8004201c8e:	ff d0                	callq  *%rax
  8004201c90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        
					if(attr != NULL)
  8004201c94:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201c99:	74 0c                	je     8004201ca7 <list_func_die+0x5cf>
					{
						ret_val = attr->u[0].u64;
  8004201c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201c9f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004201ca3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
					}
				}
	
				ret_offset = 0;
  8004201ca7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004201cae:	00 
				attr = _dwarf_attr_find(&ret, DW_AT_location);
  8004201caf:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004201cb6:	be 02 00 00 00       	mov    $0x2,%esi
  8004201cbb:	48 89 c7             	mov    %rax,%rdi
  8004201cbe:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004201cc5:	00 00 00 
  8004201cc8:	ff d0                	callq  *%rax
  8004201cca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				if (attr != NULL)
  8004201cce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201cd3:	0f 84 a2 00 00 00    	je     8004201d7b <list_func_die+0x6a3>
				{
					Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  8004201cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201cdd:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004201ce1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
					Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  8004201ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201ce9:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004201ced:	48 89 45 98          	mov    %rax,-0x68(%rbp)
					Dwarf_Small atom;
					Dwarf_Unsigned op1, op2;

					switch(attr->at_form) {
  8004201cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201cf5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004201cf9:	48 83 f8 03          	cmp    $0x3,%rax
  8004201cfd:	72 7c                	jb     8004201d7b <list_func_die+0x6a3>
  8004201cff:	48 83 f8 04          	cmp    $0x4,%rax
  8004201d03:	76 06                	jbe    8004201d0b <list_func_die+0x633>
  8004201d05:	48 83 f8 0a          	cmp    $0xa,%rax
  8004201d09:	75 70                	jne    8004201d7b <list_func_die+0x6a3>
						case DW_FORM_block1:
						case DW_FORM_block2:
						case DW_FORM_block4:
							offset = 0;
  8004201d0b:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004201d12:	00 
							atom = *(loc_ptr++);
  8004201d13:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201d17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004201d1b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004201d1f:	0f b6 00             	movzbl (%rax),%eax
  8004201d22:	88 45 97             	mov    %al,-0x69(%rbp)
							offset++;
  8004201d25:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
							if (atom == DW_OP_fbreg) {
  8004201d2a:	80 7d 97 91          	cmpb   $0x91,-0x69(%rbp)
  8004201d2e:	75 4a                	jne    8004201d7a <list_func_die+0x6a2>
								uint8_t *p = loc_ptr;
  8004201d30:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201d34:	48 89 85 60 9e ff ff 	mov    %rax,-0x61a0(%rbp)
								ret_offset = _dwarf_decode_sleb128(&p);
  8004201d3b:	48 8d 85 60 9e ff ff 	lea    -0x61a0(%rbp),%rax
  8004201d42:	48 89 c7             	mov    %rax,%rdi
  8004201d45:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004201d4c:	00 00 00 
  8004201d4f:	ff d0                	callq  *%rax
  8004201d51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
								offset += p - loc_ptr;
  8004201d55:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004201d5c:	48 89 c2             	mov    %rax,%rdx
  8004201d5f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201d63:	48 29 c2             	sub    %rax,%rdx
  8004201d66:	48 89 d0             	mov    %rdx,%rax
  8004201d69:	48 01 45 c0          	add    %rax,-0x40(%rbp)
								loc_ptr = p;
  8004201d6d:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004201d74:	48 89 45 98          	mov    %rax,-0x68(%rbp)
							}
							break;
  8004201d78:	eb 00                	jmp    8004201d7a <list_func_die+0x6a2>
  8004201d7a:	90                   	nop
					}
				}

				info->size_fn_arg[info->rip_fn_narg]=ret_val;// _get_arg_size(ret);
  8004201d7b:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201d82:	8b 48 28             	mov    0x28(%rax),%ecx
  8004201d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201d89:	89 c2                	mov    %eax,%edx
  8004201d8b:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201d92:	48 63 c9             	movslq %ecx,%rcx
  8004201d95:	48 83 c1 08          	add    $0x8,%rcx
  8004201d99:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
				info->offset_fn_arg[info->rip_fn_narg]=ret_offset;
  8004201d9d:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201da4:	8b 50 28             	mov    0x28(%rax),%edx
  8004201da7:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201dae:	48 63 d2             	movslq %edx,%rdx
  8004201db1:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  8004201db5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201db9:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
				info->rip_fn_narg++;
  8004201dbe:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201dc5:	8b 40 28             	mov    0x28(%rax),%eax
  8004201dc8:	8d 50 01             	lea    0x1(%rax),%edx
  8004201dcb:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004201dd2:	89 50 28             	mov    %edx,0x28(%rax)
				sib = ret; 
  8004201dd5:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004201ddc:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  8004201de3:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004201de8:	48 89 ce             	mov    %rcx,%rsi
  8004201deb:	48 89 c7             	mov    %rax,%rdi
  8004201dee:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004201df5:	00 00 00 
  8004201df8:	ff d0                	callq  *%rax
			info->size_fn_arg[info->rip_fn_narg] = ret_val;
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
			info->rip_fn_narg++;
			sib = ret; 

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004201dfa:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201e01:	00 00 00 
  8004201e04:	48 8b 00             	mov    (%rax),%rax
  8004201e07:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004201e0b:	48 8d 95 e0 ce ff ff 	lea    -0x3120(%rbp),%rdx
  8004201e12:	48 8d b5 70 9e ff ff 	lea    -0x6190(%rbp),%rsi
  8004201e19:	48 89 c7             	mov    %rax,%rdi
  8004201e1c:	48 b8 bb 50 20 04 80 	movabs $0x80042050bb,%rax
  8004201e23:	00 00 00 
  8004201e26:	ff d0                	callq  *%rax
  8004201e28:	85 c0                	test   %eax,%eax
  8004201e2a:	0f 84 8a fd ff ff    	je     8004201bba <list_func_die+0x4e2>
				info->rip_fn_narg++;
				sib = ret; 
			}
		}
	last:	
		return 1;
  8004201e30:	b8 01 00 00 00       	mov    $0x1,%eax
  8004201e35:	eb 05                	jmp    8004201e3c <list_func_die+0x764>
	}

	return 0;
  8004201e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004201e3c:	c9                   	leaveq 
  8004201e3d:	c3                   	retq   

0000008004201e3e <debuginfo_rip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info)
{
  8004201e3e:	55                   	push   %rbp
  8004201e3f:	48 89 e5             	mov    %rsp,%rbp
  8004201e42:	53                   	push   %rbx
  8004201e43:	48 81 ec c8 91 00 00 	sub    $0x91c8,%rsp
  8004201e4a:	48 89 bd 38 6e ff ff 	mov    %rdi,-0x91c8(%rbp)
  8004201e51:	48 89 b5 30 6e ff ff 	mov    %rsi,-0x91d0(%rbp)
	static struct Env* lastenv = NULL;
	void* elf;    
	Dwarf_Section *sect;
	Dwarf_CU cu;
	Dwarf_Die die, cudie, die2;
	Dwarf_Regtable *rt = NULL;
  8004201e58:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004201e5f:	00 
	//Set up initial pc
	uint64_t pc  = (uintptr_t)addr;
  8004201e60:	48 8b 85 38 6e ff ff 	mov    -0x91c8(%rbp),%rax
  8004201e67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

    
	// Initialize *info
	info->rip_file = "<unknown>";
  8004201e6b:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201e72:	48 bb 6f 9b 20 04 80 	movabs $0x8004209b6f,%rbx
  8004201e79:	00 00 00 
  8004201e7c:	48 89 18             	mov    %rbx,(%rax)
	info->rip_line = 0;
  8004201e7f:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201e86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	info->rip_fn_name = "<unknown>";
  8004201e8d:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201e94:	48 bb 6f 9b 20 04 80 	movabs $0x8004209b6f,%rbx
  8004201e9b:	00 00 00 
  8004201e9e:	48 89 58 10          	mov    %rbx,0x10(%rax)
	info->rip_fn_namelen = 9;
  8004201ea2:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201ea9:	c7 40 18 09 00 00 00 	movl   $0x9,0x18(%rax)
	info->rip_fn_addr = addr;
  8004201eb0:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201eb7:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004201ebe:	48 89 50 20          	mov    %rdx,0x20(%rax)
	info->rip_fn_narg = 0;
  8004201ec2:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004201ec9:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)
    
	// Find the relevant set of stabs
	if (addr >= ULIM) {
  8004201ed0:	48 b8 ff ff bf 03 80 	movabs $0x8003bfffff,%rax
  8004201ed7:	00 00 00 
  8004201eda:	48 39 85 38 6e ff ff 	cmp    %rax,-0x91c8(%rbp)
  8004201ee1:	0f 86 95 00 00 00    	jbe    8004201f7c <debuginfo_rip+0x13e>
		elf = (void *)0x10000 + KERNBASE;
  8004201ee7:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  8004201eee:	00 00 00 
  8004201ef1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
	}
	_dwarf_init(dbg, elf);
  8004201ef5:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201efc:	00 00 00 
  8004201eff:	48 8b 00             	mov    (%rax),%rax
  8004201f02:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004201f06:	48 89 d6             	mov    %rdx,%rsi
  8004201f09:	48 89 c7             	mov    %rax,%rdi
  8004201f0c:	48 b8 33 3f 20 04 80 	movabs $0x8004203f33,%rax
  8004201f13:	00 00 00 
  8004201f16:	ff d0                	callq  *%rax

	sect = _dwarf_find_section(".debug_info");	
  8004201f18:	48 bf 86 9b 20 04 80 	movabs $0x8004209b86,%rdi
  8004201f1f:	00 00 00 
  8004201f22:	48 b8 ca 87 20 04 80 	movabs $0x80042087ca,%rax
  8004201f29:	00 00 00 
  8004201f2c:	ff d0                	callq  *%rax
  8004201f2e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
  8004201f32:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201f39:	00 00 00 
  8004201f3c:	48 8b 00             	mov    (%rax),%rax
  8004201f3f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201f43:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004201f47:	48 89 50 08          	mov    %rdx,0x8(%rax)
	dbg->dbg_info_size = sect->ds_size;
  8004201f4b:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201f52:	00 00 00 
  8004201f55:	48 8b 00             	mov    (%rax),%rax
  8004201f58:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201f5c:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8004201f60:	48 89 50 10          	mov    %rdx,0x10(%rax)

	assert(dbg->dbg_info_size);
  8004201f64:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201f6b:	00 00 00 
  8004201f6e:	48 8b 00             	mov    (%rax),%rax
  8004201f71:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004201f75:	48 85 c0             	test   %rax,%rax
  8004201f78:	75 61                	jne    8004201fdb <debuginfo_rip+0x19d>
  8004201f7a:	eb 2a                	jmp    8004201fa6 <debuginfo_rip+0x168>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		elf = (void *)0x10000 + KERNBASE;
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
  8004201f7c:	48 ba 79 9b 20 04 80 	movabs $0x8004209b79,%rdx
  8004201f83:	00 00 00 
  8004201f86:	be 23 01 00 00       	mov    $0x123,%esi
  8004201f8b:	48 bf 61 9b 20 04 80 	movabs $0x8004209b61,%rdi
  8004201f92:	00 00 00 
  8004201f95:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201f9a:	48 b9 98 01 20 04 80 	movabs $0x8004200198,%rcx
  8004201fa1:	00 00 00 
  8004201fa4:	ff d1                	callq  *%rcx

	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
  8004201fa6:	48 b9 92 9b 20 04 80 	movabs $0x8004209b92,%rcx
  8004201fad:	00 00 00 
  8004201fb0:	48 ba 4c 9b 20 04 80 	movabs $0x8004209b4c,%rdx
  8004201fb7:	00 00 00 
  8004201fba:	be 2b 01 00 00       	mov    $0x12b,%esi
  8004201fbf:	48 bf 61 9b 20 04 80 	movabs $0x8004209b61,%rdi
  8004201fc6:	00 00 00 
  8004201fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201fce:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004201fd5:	00 00 00 
  8004201fd8:	41 ff d0             	callq  *%r8
	while(_get_next_cu(dbg, &cu) == 0)
  8004201fdb:	e9 6f 01 00 00       	jmpq   800420214f <debuginfo_rip+0x311>
	{
		if(dwarf_siblingof(dbg, NULL, &cudie, &cu) == DW_DLE_NO_ENTRY)
  8004201fe0:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004201fe7:	00 00 00 
  8004201fea:	48 8b 00             	mov    (%rax),%rax
  8004201fed:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004201ff1:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004201ff8:	be 00 00 00 00       	mov    $0x0,%esi
  8004201ffd:	48 89 c7             	mov    %rax,%rdi
  8004202000:	48 b8 bb 50 20 04 80 	movabs $0x80042050bb,%rax
  8004202007:	00 00 00 
  800420200a:	ff d0                	callq  *%rax
  800420200c:	83 f8 04             	cmp    $0x4,%eax
  800420200f:	75 05                	jne    8004202016 <debuginfo_rip+0x1d8>
			continue;
  8004202011:	e9 39 01 00 00       	jmpq   800420214f <debuginfo_rip+0x311>

		cudie.cu_header = &cu;
  8004202016:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800420201a:	48 89 85 10 a2 ff ff 	mov    %rax,-0x5df0(%rbp)
		cudie.cu_die = NULL;
  8004202021:	48 c7 85 18 a2 ff ff 	movq   $0x0,-0x5de8(%rbp)
  8004202028:	00 00 00 00 

		if(dwarf_child(dbg, &cu, &cudie, &die) == DW_DLE_NO_ENTRY)
  800420202c:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004202033:	00 00 00 
  8004202036:	48 8b 00             	mov    (%rax),%rax
  8004202039:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  8004202040:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004202047:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  800420204b:	48 89 c7             	mov    %rax,%rdi
  800420204e:	48 b8 ff 52 20 04 80 	movabs $0x80042052ff,%rax
  8004202055:	00 00 00 
  8004202058:	ff d0                	callq  *%rax
  800420205a:	83 f8 04             	cmp    $0x4,%eax
  800420205d:	75 05                	jne    8004202064 <debuginfo_rip+0x226>
			continue;
  800420205f:	e9 eb 00 00 00       	jmpq   800420214f <debuginfo_rip+0x311>

		die.cu_header = &cu;
  8004202064:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004202068:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
		die.cu_die = &cudie;
  800420206f:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004202076:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		while(1)
		{
			if(list_func_die(info, &die, addr))
  800420207d:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004202084:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  800420208b:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004202092:	48 89 ce             	mov    %rcx,%rsi
  8004202095:	48 89 c7             	mov    %rax,%rdi
  8004202098:	48 b8 d8 16 20 04 80 	movabs $0x80042016d8,%rax
  800420209f:	00 00 00 
  80042020a2:	ff d0                	callq  *%rax
  80042020a4:	85 c0                	test   %eax,%eax
  80042020a6:	74 30                	je     80042020d8 <debuginfo_rip+0x29a>
				goto find_done;
  80042020a8:	90                   	nop

	return -1;

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
  80042020a9:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042020b0:	00 00 00 
  80042020b3:	48 8b 00             	mov    (%rax),%rax
  80042020b6:	be 00 00 00 00       	mov    $0x0,%esi
  80042020bb:	48 89 c7             	mov    %rax,%rdi
  80042020be:	48 b8 d7 79 20 04 80 	movabs $0x80042079d7,%rax
  80042020c5:	00 00 00 
  80042020c8:	ff d0                	callq  *%rax
  80042020ca:	83 f8 01             	cmp    $0x1,%eax
  80042020cd:	0f 85 bb 00 00 00    	jne    800420218e <debuginfo_rip+0x350>
  80042020d3:	e9 ac 00 00 00       	jmpq   8004202184 <debuginfo_rip+0x346>
		die.cu_die = &cudie;
		while(1)
		{
			if(list_func_die(info, &die, addr))
				goto find_done;
			if(dwarf_siblingof(dbg, &die, &die2, &cu) < 0)
  80042020d8:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042020df:	00 00 00 
  80042020e2:	48 8b 00             	mov    (%rax),%rax
  80042020e5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  80042020e9:	48 8d 95 40 6e ff ff 	lea    -0x91c0(%rbp),%rdx
  80042020f0:	48 8d b5 20 cf ff ff 	lea    -0x30e0(%rbp),%rsi
  80042020f7:	48 89 c7             	mov    %rax,%rdi
  80042020fa:	48 b8 bb 50 20 04 80 	movabs $0x80042050bb,%rax
  8004202101:	00 00 00 
  8004202104:	ff d0                	callq  *%rax
  8004202106:	85 c0                	test   %eax,%eax
  8004202108:	79 02                	jns    800420210c <debuginfo_rip+0x2ce>
				break; 
  800420210a:	eb 43                	jmp    800420214f <debuginfo_rip+0x311>
			die = die2;
  800420210c:	48 8d 85 20 cf ff ff 	lea    -0x30e0(%rbp),%rax
  8004202113:	48 8d 8d 40 6e ff ff 	lea    -0x91c0(%rbp),%rcx
  800420211a:	ba 70 30 00 00       	mov    $0x3070,%edx
  800420211f:	48 89 ce             	mov    %rcx,%rsi
  8004202122:	48 89 c7             	mov    %rax,%rdi
  8004202125:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  800420212c:	00 00 00 
  800420212f:	ff d0                	callq  *%rax
			die.cu_header = &cu;
  8004202131:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004202135:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
			die.cu_die = &cudie;
  800420213c:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004202143:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		}
  800420214a:	e9 2e ff ff ff       	jmpq   800420207d <debuginfo_rip+0x23f>
	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
	while(_get_next_cu(dbg, &cu) == 0)
  800420214f:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004202156:	00 00 00 
  8004202159:	48 8b 00             	mov    (%rax),%rax
  800420215c:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  8004202160:	48 89 d6             	mov    %rdx,%rsi
  8004202163:	48 89 c7             	mov    %rax,%rdi
  8004202166:	48 b8 15 40 20 04 80 	movabs $0x8004204015,%rax
  800420216d:	00 00 00 
  8004202170:	ff d0                	callq  *%rax
  8004202172:	85 c0                	test   %eax,%eax
  8004202174:	0f 84 66 fe ff ff    	je     8004201fe0 <debuginfo_rip+0x1a2>
			die.cu_header = &cu;
			die.cu_die = &cudie;
		}
	}

	return -1;
  800420217a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420217f:	e9 a0 00 00 00       	jmpq   8004202224 <debuginfo_rip+0x3e6>

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
		return -1;
  8004202184:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004202189:	e9 96 00 00 00       	jmpq   8004202224 <debuginfo_rip+0x3e6>

	if (dwarf_get_fde_at_pc(dbg, addr, fde, cie, NULL) == DW_DLV_OK) {
  800420218e:	48 b8 b8 c5 21 04 80 	movabs $0x800421c5b8,%rax
  8004202195:	00 00 00 
  8004202198:	48 8b 08             	mov    (%rax),%rcx
  800420219b:	48 b8 b0 c5 21 04 80 	movabs $0x800421c5b0,%rax
  80042021a2:	00 00 00 
  80042021a5:	48 8b 10             	mov    (%rax),%rdx
  80042021a8:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042021af:	00 00 00 
  80042021b2:	48 8b 00             	mov    (%rax),%rax
  80042021b5:	48 8b b5 38 6e ff ff 	mov    -0x91c8(%rbp),%rsi
  80042021bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80042021c2:	48 89 c7             	mov    %rax,%rdi
  80042021c5:	48 b8 40 55 20 04 80 	movabs $0x8004205540,%rax
  80042021cc:	00 00 00 
  80042021cf:	ff d0                	callq  *%rax
  80042021d1:	85 c0                	test   %eax,%eax
  80042021d3:	75 4a                	jne    800420221f <debuginfo_rip+0x3e1>
		dwarf_get_fde_info_for_all_regs(dbg, fde, addr,
  80042021d5:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  80042021dc:	48 8d 88 a8 00 00 00 	lea    0xa8(%rax),%rcx
  80042021e3:	48 b8 b0 c5 21 04 80 	movabs $0x800421c5b0,%rax
  80042021ea:	00 00 00 
  80042021ed:	48 8b 30             	mov    (%rax),%rsi
  80042021f0:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042021f7:	00 00 00 
  80042021fa:	48 8b 00             	mov    (%rax),%rax
  80042021fd:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004202204:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420220a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004202210:	48 89 c7             	mov    %rax,%rdi
  8004202213:	48 b8 4c 68 20 04 80 	movabs $0x800420684c,%rax
  800420221a:	00 00 00 
  800420221d:	ff d0                	callq  *%rax
					break;
			}
		}
#endif
	}
	return 0;
  800420221f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202224:	48 81 c4 c8 91 00 00 	add    $0x91c8,%rsp
  800420222b:	5b                   	pop    %rbx
  800420222c:	5d                   	pop    %rbp
  800420222d:	c3                   	retq   

000000800420222e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800420222e:	55                   	push   %rbp
  800420222f:	48 89 e5             	mov    %rsp,%rbp
  8004202232:	53                   	push   %rbx
  8004202233:	48 83 ec 38          	sub    $0x38,%rsp
  8004202237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420223b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420223f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004202243:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004202246:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800420224a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800420224e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004202251:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004202255:	77 3b                	ja     8004202292 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004202257:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800420225a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800420225e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004202261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202265:	ba 00 00 00 00       	mov    $0x0,%edx
  800420226a:	48 f7 f3             	div    %rbx
  800420226d:	48 89 c2             	mov    %rax,%rdx
  8004202270:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004202273:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004202276:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800420227a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420227e:	41 89 f9             	mov    %edi,%r9d
  8004202281:	48 89 c7             	mov    %rax,%rdi
  8004202284:	48 b8 2e 22 20 04 80 	movabs $0x800420222e,%rax
  800420228b:	00 00 00 
  800420228e:	ff d0                	callq  *%rax
  8004202290:	eb 1e                	jmp    80042022b0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004202292:	eb 12                	jmp    80042022a6 <printnum+0x78>
			putch(padc, putdat);
  8004202294:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004202298:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420229b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420229f:	48 89 ce             	mov    %rcx,%rsi
  80042022a2:	89 d7                	mov    %edx,%edi
  80042022a4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042022a6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80042022aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80042022ae:	7f e4                	jg     8004202294 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042022b0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80042022b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042022b7:	ba 00 00 00 00       	mov    $0x0,%edx
  80042022bc:	48 f7 f1             	div    %rcx
  80042022bf:	48 89 d0             	mov    %rdx,%rax
  80042022c2:	48 ba f0 9c 20 04 80 	movabs $0x8004209cf0,%rdx
  80042022c9:	00 00 00 
  80042022cc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80042022d0:	0f be d0             	movsbl %al,%edx
  80042022d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80042022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042022db:	48 89 ce             	mov    %rcx,%rsi
  80042022de:	89 d7                	mov    %edx,%edi
  80042022e0:	ff d0                	callq  *%rax
}
  80042022e2:	48 83 c4 38          	add    $0x38,%rsp
  80042022e6:	5b                   	pop    %rbx
  80042022e7:	5d                   	pop    %rbp
  80042022e8:	c3                   	retq   

00000080042022e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042022e9:	55                   	push   %rbp
  80042022ea:	48 89 e5             	mov    %rsp,%rbp
  80042022ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042022f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042022f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80042022f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80042022fc:	7e 52                	jle    8004202350 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80042022fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202302:	8b 00                	mov    (%rax),%eax
  8004202304:	83 f8 30             	cmp    $0x30,%eax
  8004202307:	73 24                	jae    800420232d <getuint+0x44>
  8004202309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420230d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202315:	8b 00                	mov    (%rax),%eax
  8004202317:	89 c0                	mov    %eax,%eax
  8004202319:	48 01 d0             	add    %rdx,%rax
  800420231c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202320:	8b 12                	mov    (%rdx),%edx
  8004202322:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004202325:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202329:	89 0a                	mov    %ecx,(%rdx)
  800420232b:	eb 17                	jmp    8004202344 <getuint+0x5b>
  800420232d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202331:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004202335:	48 89 d0             	mov    %rdx,%rax
  8004202338:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800420233c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202340:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004202344:	48 8b 00             	mov    (%rax),%rax
  8004202347:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420234b:	e9 a3 00 00 00       	jmpq   80042023f3 <getuint+0x10a>
	else if (lflag)
  8004202350:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004202354:	74 4f                	je     80042023a5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004202356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420235a:	8b 00                	mov    (%rax),%eax
  800420235c:	83 f8 30             	cmp    $0x30,%eax
  800420235f:	73 24                	jae    8004202385 <getuint+0x9c>
  8004202361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202365:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420236d:	8b 00                	mov    (%rax),%eax
  800420236f:	89 c0                	mov    %eax,%eax
  8004202371:	48 01 d0             	add    %rdx,%rax
  8004202374:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202378:	8b 12                	mov    (%rdx),%edx
  800420237a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420237d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202381:	89 0a                	mov    %ecx,(%rdx)
  8004202383:	eb 17                	jmp    800420239c <getuint+0xb3>
  8004202385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202389:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420238d:	48 89 d0             	mov    %rdx,%rax
  8004202390:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004202394:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202398:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420239c:	48 8b 00             	mov    (%rax),%rax
  800420239f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042023a3:	eb 4e                	jmp    80042023f3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80042023a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042023a9:	8b 00                	mov    (%rax),%eax
  80042023ab:	83 f8 30             	cmp    $0x30,%eax
  80042023ae:	73 24                	jae    80042023d4 <getuint+0xeb>
  80042023b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042023b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042023bc:	8b 00                	mov    (%rax),%eax
  80042023be:	89 c0                	mov    %eax,%eax
  80042023c0:	48 01 d0             	add    %rdx,%rax
  80042023c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042023c7:	8b 12                	mov    (%rdx),%edx
  80042023c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042023cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042023d0:	89 0a                	mov    %ecx,(%rdx)
  80042023d2:	eb 17                	jmp    80042023eb <getuint+0x102>
  80042023d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042023d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042023dc:	48 89 d0             	mov    %rdx,%rax
  80042023df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042023e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042023e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042023eb:	8b 00                	mov    (%rax),%eax
  80042023ed:	89 c0                	mov    %eax,%eax
  80042023ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80042023f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042023f7:	c9                   	leaveq 
  80042023f8:	c3                   	retq   

00000080042023f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80042023f9:	55                   	push   %rbp
  80042023fa:	48 89 e5             	mov    %rsp,%rbp
  80042023fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004202401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202405:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004202408:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800420240c:	7e 52                	jle    8004202460 <getint+0x67>
		x=va_arg(*ap, long long);
  800420240e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202412:	8b 00                	mov    (%rax),%eax
  8004202414:	83 f8 30             	cmp    $0x30,%eax
  8004202417:	73 24                	jae    800420243d <getint+0x44>
  8004202419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420241d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202425:	8b 00                	mov    (%rax),%eax
  8004202427:	89 c0                	mov    %eax,%eax
  8004202429:	48 01 d0             	add    %rdx,%rax
  800420242c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202430:	8b 12                	mov    (%rdx),%edx
  8004202432:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004202435:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202439:	89 0a                	mov    %ecx,(%rdx)
  800420243b:	eb 17                	jmp    8004202454 <getint+0x5b>
  800420243d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202441:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004202445:	48 89 d0             	mov    %rdx,%rax
  8004202448:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800420244c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202450:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004202454:	48 8b 00             	mov    (%rax),%rax
  8004202457:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420245b:	e9 a3 00 00 00       	jmpq   8004202503 <getint+0x10a>
	else if (lflag)
  8004202460:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004202464:	74 4f                	je     80042024b5 <getint+0xbc>
		x=va_arg(*ap, long);
  8004202466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420246a:	8b 00                	mov    (%rax),%eax
  800420246c:	83 f8 30             	cmp    $0x30,%eax
  800420246f:	73 24                	jae    8004202495 <getint+0x9c>
  8004202471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202475:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004202479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420247d:	8b 00                	mov    (%rax),%eax
  800420247f:	89 c0                	mov    %eax,%eax
  8004202481:	48 01 d0             	add    %rdx,%rax
  8004202484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202488:	8b 12                	mov    (%rdx),%edx
  800420248a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420248d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202491:	89 0a                	mov    %ecx,(%rdx)
  8004202493:	eb 17                	jmp    80042024ac <getint+0xb3>
  8004202495:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420249d:	48 89 d0             	mov    %rdx,%rax
  80042024a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042024a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042024a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042024ac:	48 8b 00             	mov    (%rax),%rax
  80042024af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042024b3:	eb 4e                	jmp    8004202503 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80042024b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042024b9:	8b 00                	mov    (%rax),%eax
  80042024bb:	83 f8 30             	cmp    $0x30,%eax
  80042024be:	73 24                	jae    80042024e4 <getint+0xeb>
  80042024c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042024c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042024c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042024cc:	8b 00                	mov    (%rax),%eax
  80042024ce:	89 c0                	mov    %eax,%eax
  80042024d0:	48 01 d0             	add    %rdx,%rax
  80042024d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042024d7:	8b 12                	mov    (%rdx),%edx
  80042024d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042024dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042024e0:	89 0a                	mov    %ecx,(%rdx)
  80042024e2:	eb 17                	jmp    80042024fb <getint+0x102>
  80042024e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042024e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042024ec:	48 89 d0             	mov    %rdx,%rax
  80042024ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042024f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042024f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042024fb:	8b 00                	mov    (%rax),%eax
  80042024fd:	48 98                	cltq   
  80042024ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004202503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004202507:	c9                   	leaveq 
  8004202508:	c3                   	retq   

0000008004202509 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004202509:	55                   	push   %rbp
  800420250a:	48 89 e5             	mov    %rsp,%rbp
  800420250d:	41 54                	push   %r12
  800420250f:	53                   	push   %rbx
  8004202510:	48 83 ec 60          	sub    $0x60,%rsp
  8004202514:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8004202518:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800420251c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004202520:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8004202524:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004202528:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800420252c:	48 8b 0a             	mov    (%rdx),%rcx
  800420252f:	48 89 08             	mov    %rcx,(%rax)
  8004202532:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004202536:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800420253a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800420253e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004202542:	eb 17                	jmp    800420255b <vprintfmt+0x52>
			if (ch == '\0')
  8004202544:	85 db                	test   %ebx,%ebx
  8004202546:	0f 84 cc 04 00 00    	je     8004202a18 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800420254c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202550:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202554:	48 89 d6             	mov    %rdx,%rsi
  8004202557:	89 df                	mov    %ebx,%edi
  8004202559:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800420255b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420255f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202563:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004202567:	0f b6 00             	movzbl (%rax),%eax
  800420256a:	0f b6 d8             	movzbl %al,%ebx
  800420256d:	83 fb 25             	cmp    $0x25,%ebx
  8004202570:	75 d2                	jne    8004202544 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004202572:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8004202576:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800420257d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8004202584:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800420258b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004202592:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004202596:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420259a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800420259e:	0f b6 00             	movzbl (%rax),%eax
  80042025a1:	0f b6 d8             	movzbl %al,%ebx
  80042025a4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80042025a7:	83 f8 55             	cmp    $0x55,%eax
  80042025aa:	0f 87 34 04 00 00    	ja     80042029e4 <vprintfmt+0x4db>
  80042025b0:	89 c0                	mov    %eax,%eax
  80042025b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042025b9:	00 
  80042025ba:	48 b8 18 9d 20 04 80 	movabs $0x8004209d18,%rax
  80042025c1:	00 00 00 
  80042025c4:	48 01 d0             	add    %rdx,%rax
  80042025c7:	48 8b 00             	mov    (%rax),%rax
  80042025ca:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80042025cc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80042025d0:	eb c0                	jmp    8004202592 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80042025d2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80042025d6:	eb ba                	jmp    8004202592 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80042025d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80042025df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80042025e2:	89 d0                	mov    %edx,%eax
  80042025e4:	c1 e0 02             	shl    $0x2,%eax
  80042025e7:	01 d0                	add    %edx,%eax
  80042025e9:	01 c0                	add    %eax,%eax
  80042025eb:	01 d8                	add    %ebx,%eax
  80042025ed:	83 e8 30             	sub    $0x30,%eax
  80042025f0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80042025f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042025f7:	0f b6 00             	movzbl (%rax),%eax
  80042025fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80042025fd:	83 fb 2f             	cmp    $0x2f,%ebx
  8004202600:	7e 0c                	jle    800420260e <vprintfmt+0x105>
  8004202602:	83 fb 39             	cmp    $0x39,%ebx
  8004202605:	7f 07                	jg     800420260e <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004202607:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800420260c:	eb d1                	jmp    80042025df <vprintfmt+0xd6>
			goto process_precision;
  800420260e:	eb 58                	jmp    8004202668 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8004202610:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202613:	83 f8 30             	cmp    $0x30,%eax
  8004202616:	73 17                	jae    800420262f <vprintfmt+0x126>
  8004202618:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420261c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420261f:	89 c0                	mov    %eax,%eax
  8004202621:	48 01 d0             	add    %rdx,%rax
  8004202624:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8004202627:	83 c2 08             	add    $0x8,%edx
  800420262a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800420262d:	eb 0f                	jmp    800420263e <vprintfmt+0x135>
  800420262f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202633:	48 89 d0             	mov    %rdx,%rax
  8004202636:	48 83 c2 08          	add    $0x8,%rdx
  800420263a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800420263e:	8b 00                	mov    (%rax),%eax
  8004202640:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8004202643:	eb 23                	jmp    8004202668 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8004202645:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004202649:	79 0c                	jns    8004202657 <vprintfmt+0x14e>
				width = 0;
  800420264b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8004202652:	e9 3b ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>
  8004202657:	e9 36 ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800420265c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8004202663:	e9 2a ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8004202668:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420266c:	79 12                	jns    8004202680 <vprintfmt+0x177>
				width = precision, precision = -1;
  800420266e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8004202671:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8004202674:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800420267b:	e9 12 ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>
  8004202680:	e9 0d ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004202685:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8004202689:	e9 04 ff ff ff       	jmpq   8004202592 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800420268e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202691:	83 f8 30             	cmp    $0x30,%eax
  8004202694:	73 17                	jae    80042026ad <vprintfmt+0x1a4>
  8004202696:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420269a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420269d:	89 c0                	mov    %eax,%eax
  800420269f:	48 01 d0             	add    %rdx,%rax
  80042026a2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042026a5:	83 c2 08             	add    $0x8,%edx
  80042026a8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80042026ab:	eb 0f                	jmp    80042026bc <vprintfmt+0x1b3>
  80042026ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042026b1:	48 89 d0             	mov    %rdx,%rax
  80042026b4:	48 83 c2 08          	add    $0x8,%rdx
  80042026b8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80042026bc:	8b 10                	mov    (%rax),%edx
  80042026be:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042026c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042026c6:	48 89 ce             	mov    %rcx,%rsi
  80042026c9:	89 d7                	mov    %edx,%edi
  80042026cb:	ff d0                	callq  *%rax
			break;
  80042026cd:	e9 40 03 00 00       	jmpq   8004202a12 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80042026d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042026d5:	83 f8 30             	cmp    $0x30,%eax
  80042026d8:	73 17                	jae    80042026f1 <vprintfmt+0x1e8>
  80042026da:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042026de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042026e1:	89 c0                	mov    %eax,%eax
  80042026e3:	48 01 d0             	add    %rdx,%rax
  80042026e6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042026e9:	83 c2 08             	add    $0x8,%edx
  80042026ec:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80042026ef:	eb 0f                	jmp    8004202700 <vprintfmt+0x1f7>
  80042026f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042026f5:	48 89 d0             	mov    %rdx,%rax
  80042026f8:	48 83 c2 08          	add    $0x8,%rdx
  80042026fc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004202700:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8004202702:	85 db                	test   %ebx,%ebx
  8004202704:	79 02                	jns    8004202708 <vprintfmt+0x1ff>
				err = -err;
  8004202706:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004202708:	83 fb 15             	cmp    $0x15,%ebx
  800420270b:	7f 16                	jg     8004202723 <vprintfmt+0x21a>
  800420270d:	48 b8 40 9c 20 04 80 	movabs $0x8004209c40,%rax
  8004202714:	00 00 00 
  8004202717:	48 63 d3             	movslq %ebx,%rdx
  800420271a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800420271e:	4d 85 e4             	test   %r12,%r12
  8004202721:	75 2e                	jne    8004202751 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8004202723:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8004202727:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420272b:	89 d9                	mov    %ebx,%ecx
  800420272d:	48 ba 01 9d 20 04 80 	movabs $0x8004209d01,%rdx
  8004202734:	00 00 00 
  8004202737:	48 89 c7             	mov    %rax,%rdi
  800420273a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420273f:	49 b8 21 2a 20 04 80 	movabs $0x8004202a21,%r8
  8004202746:	00 00 00 
  8004202749:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800420274c:	e9 c1 02 00 00       	jmpq   8004202a12 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004202751:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8004202755:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202759:	4c 89 e1             	mov    %r12,%rcx
  800420275c:	48 ba 0a 9d 20 04 80 	movabs $0x8004209d0a,%rdx
  8004202763:	00 00 00 
  8004202766:	48 89 c7             	mov    %rax,%rdi
  8004202769:	b8 00 00 00 00       	mov    $0x0,%eax
  800420276e:	49 b8 21 2a 20 04 80 	movabs $0x8004202a21,%r8
  8004202775:	00 00 00 
  8004202778:	41 ff d0             	callq  *%r8
			break;
  800420277b:	e9 92 02 00 00       	jmpq   8004202a12 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8004202780:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202783:	83 f8 30             	cmp    $0x30,%eax
  8004202786:	73 17                	jae    800420279f <vprintfmt+0x296>
  8004202788:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420278c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420278f:	89 c0                	mov    %eax,%eax
  8004202791:	48 01 d0             	add    %rdx,%rax
  8004202794:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8004202797:	83 c2 08             	add    $0x8,%edx
  800420279a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800420279d:	eb 0f                	jmp    80042027ae <vprintfmt+0x2a5>
  800420279f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042027a3:	48 89 d0             	mov    %rdx,%rax
  80042027a6:	48 83 c2 08          	add    $0x8,%rdx
  80042027aa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80042027ae:	4c 8b 20             	mov    (%rax),%r12
  80042027b1:	4d 85 e4             	test   %r12,%r12
  80042027b4:	75 0a                	jne    80042027c0 <vprintfmt+0x2b7>
				p = "(null)";
  80042027b6:	49 bc 0d 9d 20 04 80 	movabs $0x8004209d0d,%r12
  80042027bd:	00 00 00 
			if (width > 0 && padc != '-')
  80042027c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042027c4:	7e 3f                	jle    8004202805 <vprintfmt+0x2fc>
  80042027c6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80042027ca:	74 39                	je     8004202805 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042027cc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80042027cf:	48 98                	cltq   
  80042027d1:	48 89 c6             	mov    %rax,%rsi
  80042027d4:	4c 89 e7             	mov    %r12,%rdi
  80042027d7:	48 b8 1c 2e 20 04 80 	movabs $0x8004202e1c,%rax
  80042027de:	00 00 00 
  80042027e1:	ff d0                	callq  *%rax
  80042027e3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80042027e6:	eb 17                	jmp    80042027ff <vprintfmt+0x2f6>
					putch(padc, putdat);
  80042027e8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80042027ec:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042027f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042027f4:	48 89 ce             	mov    %rcx,%rsi
  80042027f7:	89 d7                	mov    %edx,%edi
  80042027f9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80042027fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80042027ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004202803:	7f e3                	jg     80042027e8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004202805:	eb 37                	jmp    800420283e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8004202807:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800420280b:	74 1e                	je     800420282b <vprintfmt+0x322>
  800420280d:	83 fb 1f             	cmp    $0x1f,%ebx
  8004202810:	7e 05                	jle    8004202817 <vprintfmt+0x30e>
  8004202812:	83 fb 7e             	cmp    $0x7e,%ebx
  8004202815:	7e 14                	jle    800420282b <vprintfmt+0x322>
					putch('?', putdat);
  8004202817:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420281b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420281f:	48 89 d6             	mov    %rdx,%rsi
  8004202822:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8004202827:	ff d0                	callq  *%rax
  8004202829:	eb 0f                	jmp    800420283a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800420282b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420282f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202833:	48 89 d6             	mov    %rdx,%rsi
  8004202836:	89 df                	mov    %ebx,%edi
  8004202838:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800420283a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800420283e:	4c 89 e0             	mov    %r12,%rax
  8004202841:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8004202845:	0f b6 00             	movzbl (%rax),%eax
  8004202848:	0f be d8             	movsbl %al,%ebx
  800420284b:	85 db                	test   %ebx,%ebx
  800420284d:	74 10                	je     800420285f <vprintfmt+0x356>
  800420284f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8004202853:	78 b2                	js     8004202807 <vprintfmt+0x2fe>
  8004202855:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8004202859:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800420285d:	79 a8                	jns    8004202807 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800420285f:	eb 16                	jmp    8004202877 <vprintfmt+0x36e>
				putch(' ', putdat);
  8004202861:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202865:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202869:	48 89 d6             	mov    %rdx,%rsi
  800420286c:	bf 20 00 00 00       	mov    $0x20,%edi
  8004202871:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8004202873:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8004202877:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420287b:	7f e4                	jg     8004202861 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800420287d:	e9 90 01 00 00       	jmpq   8004202a12 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8004202882:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004202886:	be 03 00 00 00       	mov    $0x3,%esi
  800420288b:	48 89 c7             	mov    %rax,%rdi
  800420288e:	48 b8 f9 23 20 04 80 	movabs $0x80042023f9,%rax
  8004202895:	00 00 00 
  8004202898:	ff d0                	callq  *%rax
  800420289a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800420289e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042028a2:	48 85 c0             	test   %rax,%rax
  80042028a5:	79 1d                	jns    80042028c4 <vprintfmt+0x3bb>
				putch('-', putdat);
  80042028a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042028ab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042028af:	48 89 d6             	mov    %rdx,%rsi
  80042028b2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80042028b7:	ff d0                	callq  *%rax
				num = -(long long) num;
  80042028b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042028bd:	48 f7 d8             	neg    %rax
  80042028c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80042028c4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80042028cb:	e9 d5 00 00 00       	jmpq   80042029a5 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80042028d0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80042028d4:	be 03 00 00 00       	mov    $0x3,%esi
  80042028d9:	48 89 c7             	mov    %rax,%rdi
  80042028dc:	48 b8 e9 22 20 04 80 	movabs $0x80042022e9,%rax
  80042028e3:	00 00 00 
  80042028e6:	ff d0                	callq  *%rax
  80042028e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80042028ec:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80042028f3:	e9 ad 00 00 00       	jmpq   80042029a5 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  80042028f8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80042028fc:	be 03 00 00 00       	mov    $0x3,%esi
  8004202901:	48 89 c7             	mov    %rax,%rdi
  8004202904:	48 b8 e9 22 20 04 80 	movabs $0x80042022e9,%rax
  800420290b:	00 00 00 
  800420290e:	ff d0                	callq  *%rax
  8004202910:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8004202914:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800420291b:	e9 85 00 00 00       	jmpq   80042029a5 <vprintfmt+0x49c>
			break;

			// pointer
		case 'p':
			putch('0', putdat);
  8004202920:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202924:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202928:	48 89 d6             	mov    %rdx,%rsi
  800420292b:	bf 30 00 00 00       	mov    $0x30,%edi
  8004202930:	ff d0                	callq  *%rax
			putch('x', putdat);
  8004202932:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004202936:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420293a:	48 89 d6             	mov    %rdx,%rsi
  800420293d:	bf 78 00 00 00       	mov    $0x78,%edi
  8004202942:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8004202944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202947:	83 f8 30             	cmp    $0x30,%eax
  800420294a:	73 17                	jae    8004202963 <vprintfmt+0x45a>
  800420294c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004202950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004202953:	89 c0                	mov    %eax,%eax
  8004202955:	48 01 d0             	add    %rdx,%rax
  8004202958:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800420295b:	83 c2 08             	add    $0x8,%edx
  800420295e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8004202961:	eb 0f                	jmp    8004202972 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8004202963:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202967:	48 89 d0             	mov    %rdx,%rax
  800420296a:	48 83 c2 08          	add    $0x8,%rdx
  800420296e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004202972:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8004202975:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8004202979:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8004202980:	eb 23                	jmp    80042029a5 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8004202982:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004202986:	be 03 00 00 00       	mov    $0x3,%esi
  800420298b:	48 89 c7             	mov    %rax,%rdi
  800420298e:	48 b8 e9 22 20 04 80 	movabs $0x80042022e9,%rax
  8004202995:	00 00 00 
  8004202998:	ff d0                	callq  *%rax
  800420299a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800420299e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80042029a5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80042029aa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80042029ad:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80042029b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042029b4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80042029b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042029bc:	45 89 c1             	mov    %r8d,%r9d
  80042029bf:	41 89 f8             	mov    %edi,%r8d
  80042029c2:	48 89 c7             	mov    %rax,%rdi
  80042029c5:	48 b8 2e 22 20 04 80 	movabs $0x800420222e,%rax
  80042029cc:	00 00 00 
  80042029cf:	ff d0                	callq  *%rax
			break;
  80042029d1:	eb 3f                	jmp    8004202a12 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80042029d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042029d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042029db:	48 89 d6             	mov    %rdx,%rsi
  80042029de:	89 df                	mov    %ebx,%edi
  80042029e0:	ff d0                	callq  *%rax
			break;
  80042029e2:	eb 2e                	jmp    8004202a12 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80042029e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042029e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042029ec:	48 89 d6             	mov    %rdx,%rsi
  80042029ef:	bf 25 00 00 00       	mov    $0x25,%edi
  80042029f4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80042029f6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80042029fb:	eb 05                	jmp    8004202a02 <vprintfmt+0x4f9>
  80042029fd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8004202a02:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004202a06:	48 83 e8 01          	sub    $0x1,%rax
  8004202a0a:	0f b6 00             	movzbl (%rax),%eax
  8004202a0d:	3c 25                	cmp    $0x25,%al
  8004202a0f:	75 ec                	jne    80042029fd <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8004202a11:	90                   	nop
		}
	}
  8004202a12:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004202a13:	e9 43 fb ff ff       	jmpq   800420255b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8004202a18:	48 83 c4 60          	add    $0x60,%rsp
  8004202a1c:	5b                   	pop    %rbx
  8004202a1d:	41 5c                	pop    %r12
  8004202a1f:	5d                   	pop    %rbp
  8004202a20:	c3                   	retq   

0000008004202a21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004202a21:	55                   	push   %rbp
  8004202a22:	48 89 e5             	mov    %rsp,%rbp
  8004202a25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8004202a2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8004202a33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8004202a3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004202a41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004202a48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004202a4f:	84 c0                	test   %al,%al
  8004202a51:	74 20                	je     8004202a73 <printfmt+0x52>
  8004202a53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004202a57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004202a5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004202a5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004202a63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004202a67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004202a6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004202a6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004202a73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004202a7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8004202a81:	00 00 00 
  8004202a84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8004202a8b:	00 00 00 
  8004202a8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004202a92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8004202a99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004202aa0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8004202aa7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8004202aae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004202ab5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8004202abc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004202ac3:	48 89 c7             	mov    %rax,%rdi
  8004202ac6:	48 b8 09 25 20 04 80 	movabs $0x8004202509,%rax
  8004202acd:	00 00 00 
  8004202ad0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8004202ad2:	c9                   	leaveq 
  8004202ad3:	c3                   	retq   

0000008004202ad4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004202ad4:	55                   	push   %rbp
  8004202ad5:	48 89 e5             	mov    %rsp,%rbp
  8004202ad8:	48 83 ec 10          	sub    $0x10,%rsp
  8004202adc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004202adf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8004202ae3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202ae7:	8b 40 10             	mov    0x10(%rax),%eax
  8004202aea:	8d 50 01             	lea    0x1(%rax),%edx
  8004202aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202af1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8004202af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202af8:	48 8b 10             	mov    (%rax),%rdx
  8004202afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202aff:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004202b03:	48 39 c2             	cmp    %rax,%rdx
  8004202b06:	73 17                	jae    8004202b1f <sprintputch+0x4b>
		*b->buf++ = ch;
  8004202b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202b0c:	48 8b 00             	mov    (%rax),%rax
  8004202b0f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8004202b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004202b17:	48 89 0a             	mov    %rcx,(%rdx)
  8004202b1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004202b1d:	88 10                	mov    %dl,(%rax)
}
  8004202b1f:	c9                   	leaveq 
  8004202b20:	c3                   	retq   

0000008004202b21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8004202b21:	55                   	push   %rbp
  8004202b22:	48 89 e5             	mov    %rsp,%rbp
  8004202b25:	48 83 ec 50          	sub    $0x50,%rsp
  8004202b29:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004202b2d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8004202b30:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004202b34:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8004202b38:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8004202b3c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004202b40:	48 8b 0a             	mov    (%rdx),%rcx
  8004202b43:	48 89 08             	mov    %rcx,(%rax)
  8004202b46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004202b4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004202b4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004202b52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8004202b56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202b5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004202b5e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8004202b61:	48 98                	cltq   
  8004202b63:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004202b67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202b6b:	48 01 d0             	add    %rdx,%rax
  8004202b6e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8004202b72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8004202b79:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004202b7e:	74 06                	je     8004202b86 <vsnprintf+0x65>
  8004202b80:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004202b84:	7f 07                	jg     8004202b8d <vsnprintf+0x6c>
		return -E_INVAL;
  8004202b86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004202b8b:	eb 2f                	jmp    8004202bbc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8004202b8d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8004202b91:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004202b95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004202b99:	48 89 c6             	mov    %rax,%rsi
  8004202b9c:	48 bf d4 2a 20 04 80 	movabs $0x8004202ad4,%rdi
  8004202ba3:	00 00 00 
  8004202ba6:	48 b8 09 25 20 04 80 	movabs $0x8004202509,%rax
  8004202bad:	00 00 00 
  8004202bb0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8004202bb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202bb6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8004202bb9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8004202bbc:	c9                   	leaveq 
  8004202bbd:	c3                   	retq   

0000008004202bbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8004202bbe:	55                   	push   %rbp
  8004202bbf:	48 89 e5             	mov    %rsp,%rbp
  8004202bc2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004202bc9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004202bd0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8004202bd6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004202bdd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004202be4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004202beb:	84 c0                	test   %al,%al
  8004202bed:	74 20                	je     8004202c0f <snprintf+0x51>
  8004202bef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004202bf3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004202bf7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004202bfb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004202bff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004202c03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004202c07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004202c0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004202c0f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8004202c16:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8004202c1d:	00 00 00 
  8004202c20:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004202c27:	00 00 00 
  8004202c2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004202c2e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004202c35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004202c3c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004202c43:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004202c4a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004202c51:	48 8b 0a             	mov    (%rdx),%rcx
  8004202c54:	48 89 08             	mov    %rcx,(%rax)
  8004202c57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004202c5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004202c5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004202c63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8004202c67:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8004202c6e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8004202c75:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8004202c7b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004202c82:	48 89 c7             	mov    %rax,%rdi
  8004202c85:	48 b8 21 2b 20 04 80 	movabs $0x8004202b21,%rax
  8004202c8c:	00 00 00 
  8004202c8f:	ff d0                	callq  *%rax
  8004202c91:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8004202c97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004202c9d:	c9                   	leaveq 
  8004202c9e:	c3                   	retq   

0000008004202c9f <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8004202c9f:	55                   	push   %rbp
  8004202ca0:	48 89 e5             	mov    %rsp,%rbp
  8004202ca3:	48 83 ec 20          	sub    $0x20,%rsp
  8004202ca7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, c, echoing;

	if (prompt != NULL)
  8004202cab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202cb0:	74 22                	je     8004202cd4 <readline+0x35>
		cprintf("%s", prompt);
  8004202cb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202cb6:	48 89 c6             	mov    %rax,%rsi
  8004202cb9:	48 bf c8 9f 20 04 80 	movabs $0x8004209fc8,%rdi
  8004202cc0:	00 00 00 
  8004202cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202cc8:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004202ccf:	00 00 00 
  8004202cd2:	ff d2                	callq  *%rdx

	i = 0;
  8004202cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8004202cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  8004202ce0:	48 b8 93 0e 20 04 80 	movabs $0x8004200e93,%rax
  8004202ce7:	00 00 00 
  8004202cea:	ff d0                	callq  *%rax
  8004202cec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8004202cef:	48 b8 71 0e 20 04 80 	movabs $0x8004200e71,%rax
  8004202cf6:	00 00 00 
  8004202cf9:	ff d0                	callq  *%rax
  8004202cfb:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8004202cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004202d02:	79 2a                	jns    8004202d2e <readline+0x8f>
			cprintf("read error: %e\n", c);
  8004202d04:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202d07:	89 c6                	mov    %eax,%esi
  8004202d09:	48 bf cb 9f 20 04 80 	movabs $0x8004209fcb,%rdi
  8004202d10:	00 00 00 
  8004202d13:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202d18:	48 ba b6 15 20 04 80 	movabs $0x80042015b6,%rdx
  8004202d1f:	00 00 00 
  8004202d22:	ff d2                	callq  *%rdx
			return NULL;
  8004202d24:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202d29:	e9 be 00 00 00       	jmpq   8004202dec <readline+0x14d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8004202d2e:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  8004202d32:	74 06                	je     8004202d3a <readline+0x9b>
  8004202d34:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8004202d38:	75 26                	jne    8004202d60 <readline+0xc1>
  8004202d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004202d3e:	7e 20                	jle    8004202d60 <readline+0xc1>
			if (echoing)
  8004202d40:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202d44:	74 11                	je     8004202d57 <readline+0xb8>
				cputchar('\b');
  8004202d46:	bf 08 00 00 00       	mov    $0x8,%edi
  8004202d4b:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202d52:	00 00 00 
  8004202d55:	ff d0                	callq  *%rax
			i--;
  8004202d57:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  8004202d5b:	e9 87 00 00 00       	jmpq   8004202de7 <readline+0x148>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8004202d60:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004202d64:	7e 3f                	jle    8004202da5 <readline+0x106>
  8004202d66:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8004202d6d:	7f 36                	jg     8004202da5 <readline+0x106>
			if (echoing)
  8004202d6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202d73:	74 11                	je     8004202d86 <readline+0xe7>
				cputchar(c);
  8004202d75:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004202d78:	89 c7                	mov    %eax,%edi
  8004202d7a:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202d81:	00 00 00 
  8004202d84:	ff d0                	callq  *%rax
			buf[i++] = c;
  8004202d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202d89:	8d 50 01             	lea    0x1(%rax),%edx
  8004202d8c:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8004202d8f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004202d92:	89 d1                	mov    %edx,%ecx
  8004202d94:	48 ba e0 c8 21 04 80 	movabs $0x800421c8e0,%rdx
  8004202d9b:	00 00 00 
  8004202d9e:	48 98                	cltq   
  8004202da0:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8004202da3:	eb 42                	jmp    8004202de7 <readline+0x148>
		} else if (c == '\n' || c == '\r') {
  8004202da5:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8004202da9:	74 06                	je     8004202db1 <readline+0x112>
  8004202dab:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8004202daf:	75 36                	jne    8004202de7 <readline+0x148>
			if (echoing)
  8004202db1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004202db5:	74 11                	je     8004202dc8 <readline+0x129>
				cputchar('\n');
  8004202db7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004202dbc:	48 b8 53 0e 20 04 80 	movabs $0x8004200e53,%rax
  8004202dc3:	00 00 00 
  8004202dc6:	ff d0                	callq  *%rax
			buf[i] = 0;
  8004202dc8:	48 ba e0 c8 21 04 80 	movabs $0x800421c8e0,%rdx
  8004202dcf:	00 00 00 
  8004202dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202dd5:	48 98                	cltq   
  8004202dd7:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8004202ddb:	48 b8 e0 c8 21 04 80 	movabs $0x800421c8e0,%rax
  8004202de2:	00 00 00 
  8004202de5:	eb 05                	jmp    8004202dec <readline+0x14d>
		}
	}
  8004202de7:	e9 03 ff ff ff       	jmpq   8004202cef <readline+0x50>
}
  8004202dec:	c9                   	leaveq 
  8004202ded:	c3                   	retq   

0000008004202dee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8004202dee:	55                   	push   %rbp
  8004202def:	48 89 e5             	mov    %rsp,%rbp
  8004202df2:	48 83 ec 18          	sub    $0x18,%rsp
  8004202df6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8004202dfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004202e01:	eb 09                	jmp    8004202e0c <strlen+0x1e>
		n++;
  8004202e03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8004202e07:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004202e0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202e10:	0f b6 00             	movzbl (%rax),%eax
  8004202e13:	84 c0                	test   %al,%al
  8004202e15:	75 ec                	jne    8004202e03 <strlen+0x15>
		n++;
	return n;
  8004202e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004202e1a:	c9                   	leaveq 
  8004202e1b:	c3                   	retq   

0000008004202e1c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8004202e1c:	55                   	push   %rbp
  8004202e1d:	48 89 e5             	mov    %rsp,%rbp
  8004202e20:	48 83 ec 20          	sub    $0x20,%rsp
  8004202e24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202e28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004202e2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004202e33:	eb 0e                	jmp    8004202e43 <strnlen+0x27>
		n++;
  8004202e35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004202e39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004202e3e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8004202e43:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004202e48:	74 0b                	je     8004202e55 <strnlen+0x39>
  8004202e4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202e4e:	0f b6 00             	movzbl (%rax),%eax
  8004202e51:	84 c0                	test   %al,%al
  8004202e53:	75 e0                	jne    8004202e35 <strnlen+0x19>
		n++;
	return n;
  8004202e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004202e58:	c9                   	leaveq 
  8004202e59:	c3                   	retq   

0000008004202e5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8004202e5a:	55                   	push   %rbp
  8004202e5b:	48 89 e5             	mov    %rsp,%rbp
  8004202e5e:	48 83 ec 20          	sub    $0x20,%rsp
  8004202e62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202e66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8004202e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202e6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8004202e72:	90                   	nop
  8004202e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202e77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202e7b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202e7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202e83:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004202e87:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004202e8b:	0f b6 12             	movzbl (%rdx),%edx
  8004202e8e:	88 10                	mov    %dl,(%rax)
  8004202e90:	0f b6 00             	movzbl (%rax),%eax
  8004202e93:	84 c0                	test   %al,%al
  8004202e95:	75 dc                	jne    8004202e73 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8004202e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004202e9b:	c9                   	leaveq 
  8004202e9c:	c3                   	retq   

0000008004202e9d <strcat>:

char *
strcat(char *dst, const char *src)
{
  8004202e9d:	55                   	push   %rbp
  8004202e9e:	48 89 e5             	mov    %rsp,%rbp
  8004202ea1:	48 83 ec 20          	sub    $0x20,%rsp
  8004202ea5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202ea9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8004202ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202eb1:	48 89 c7             	mov    %rax,%rdi
  8004202eb4:	48 b8 ee 2d 20 04 80 	movabs $0x8004202dee,%rax
  8004202ebb:	00 00 00 
  8004202ebe:	ff d0                	callq  *%rax
  8004202ec0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8004202ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004202ec6:	48 63 d0             	movslq %eax,%rdx
  8004202ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ecd:	48 01 c2             	add    %rax,%rdx
  8004202ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202ed4:	48 89 c6             	mov    %rax,%rsi
  8004202ed7:	48 89 d7             	mov    %rdx,%rdi
  8004202eda:	48 b8 5a 2e 20 04 80 	movabs $0x8004202e5a,%rax
  8004202ee1:	00 00 00 
  8004202ee4:	ff d0                	callq  *%rax
	return dst;
  8004202ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004202eea:	c9                   	leaveq 
  8004202eeb:	c3                   	retq   

0000008004202eec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8004202eec:	55                   	push   %rbp
  8004202eed:	48 89 e5             	mov    %rsp,%rbp
  8004202ef0:	48 83 ec 28          	sub    $0x28,%rsp
  8004202ef4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202ef8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202efc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8004202f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8004202f08:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004202f0f:	00 
  8004202f10:	eb 2a                	jmp    8004202f3c <strncpy+0x50>
		*dst++ = *src;
  8004202f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f16:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202f1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202f1e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202f22:	0f b6 12             	movzbl (%rdx),%edx
  8004202f25:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8004202f27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202f2b:	0f b6 00             	movzbl (%rax),%eax
  8004202f2e:	84 c0                	test   %al,%al
  8004202f30:	74 05                	je     8004202f37 <strncpy+0x4b>
			src++;
  8004202f32:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8004202f37:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202f3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f40:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004202f44:	72 cc                	jb     8004202f12 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8004202f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004202f4a:	c9                   	leaveq 
  8004202f4b:	c3                   	retq   

0000008004202f4c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8004202f4c:	55                   	push   %rbp
  8004202f4d:	48 89 e5             	mov    %rsp,%rbp
  8004202f50:	48 83 ec 28          	sub    $0x28,%rsp
  8004202f54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202f58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202f5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8004202f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8004202f68:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004202f6d:	74 3d                	je     8004202fac <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8004202f6f:	eb 1d                	jmp    8004202f8e <strlcpy+0x42>
			*dst++ = *src++;
  8004202f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f75:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004202f79:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004202f7d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202f81:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004202f85:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004202f89:	0f b6 12             	movzbl (%rdx),%edx
  8004202f8c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8004202f8e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8004202f93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004202f98:	74 0b                	je     8004202fa5 <strlcpy+0x59>
  8004202f9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202f9e:	0f b6 00             	movzbl (%rax),%eax
  8004202fa1:	84 c0                	test   %al,%al
  8004202fa3:	75 cc                	jne    8004202f71 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8004202fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202fa9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8004202fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202fb4:	48 29 c2             	sub    %rax,%rdx
  8004202fb7:	48 89 d0             	mov    %rdx,%rax
}
  8004202fba:	c9                   	leaveq 
  8004202fbb:	c3                   	retq   

0000008004202fbc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8004202fbc:	55                   	push   %rbp
  8004202fbd:	48 89 e5             	mov    %rsp,%rbp
  8004202fc0:	48 83 ec 10          	sub    $0x10,%rsp
  8004202fc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004202fc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8004202fcc:	eb 0a                	jmp    8004202fd8 <strcmp+0x1c>
		p++, q++;
  8004202fce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004202fd3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8004202fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202fdc:	0f b6 00             	movzbl (%rax),%eax
  8004202fdf:	84 c0                	test   %al,%al
  8004202fe1:	74 12                	je     8004202ff5 <strcmp+0x39>
  8004202fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202fe7:	0f b6 10             	movzbl (%rax),%edx
  8004202fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202fee:	0f b6 00             	movzbl (%rax),%eax
  8004202ff1:	38 c2                	cmp    %al,%dl
  8004202ff3:	74 d9                	je     8004202fce <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8004202ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202ff9:	0f b6 00             	movzbl (%rax),%eax
  8004202ffc:	0f b6 d0             	movzbl %al,%edx
  8004202fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203003:	0f b6 00             	movzbl (%rax),%eax
  8004203006:	0f b6 c0             	movzbl %al,%eax
  8004203009:	29 c2                	sub    %eax,%edx
  800420300b:	89 d0                	mov    %edx,%eax
}
  800420300d:	c9                   	leaveq 
  800420300e:	c3                   	retq   

000000800420300f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800420300f:	55                   	push   %rbp
  8004203010:	48 89 e5             	mov    %rsp,%rbp
  8004203013:	48 83 ec 18          	sub    $0x18,%rsp
  8004203017:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420301b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800420301f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8004203023:	eb 0f                	jmp    8004203034 <strncmp+0x25>
		n--, p++, q++;
  8004203025:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800420302a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800420302f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8004203034:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004203039:	74 1d                	je     8004203058 <strncmp+0x49>
  800420303b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420303f:	0f b6 00             	movzbl (%rax),%eax
  8004203042:	84 c0                	test   %al,%al
  8004203044:	74 12                	je     8004203058 <strncmp+0x49>
  8004203046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420304a:	0f b6 10             	movzbl (%rax),%edx
  800420304d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203051:	0f b6 00             	movzbl (%rax),%eax
  8004203054:	38 c2                	cmp    %al,%dl
  8004203056:	74 cd                	je     8004203025 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8004203058:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420305d:	75 07                	jne    8004203066 <strncmp+0x57>
		return 0;
  800420305f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203064:	eb 18                	jmp    800420307e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8004203066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420306a:	0f b6 00             	movzbl (%rax),%eax
  800420306d:	0f b6 d0             	movzbl %al,%edx
  8004203070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203074:	0f b6 00             	movzbl (%rax),%eax
  8004203077:	0f b6 c0             	movzbl %al,%eax
  800420307a:	29 c2                	sub    %eax,%edx
  800420307c:	89 d0                	mov    %edx,%eax
}
  800420307e:	c9                   	leaveq 
  800420307f:	c3                   	retq   

0000008004203080 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8004203080:	55                   	push   %rbp
  8004203081:	48 89 e5             	mov    %rsp,%rbp
  8004203084:	48 83 ec 0c          	sub    $0xc,%rsp
  8004203088:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420308c:	89 f0                	mov    %esi,%eax
  800420308e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004203091:	eb 17                	jmp    80042030aa <strchr+0x2a>
		if (*s == c)
  8004203093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203097:	0f b6 00             	movzbl (%rax),%eax
  800420309a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  800420309d:	75 06                	jne    80042030a5 <strchr+0x25>
			return (char *) s;
  800420309f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030a3:	eb 15                	jmp    80042030ba <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80042030a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80042030aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030ae:	0f b6 00             	movzbl (%rax),%eax
  80042030b1:	84 c0                	test   %al,%al
  80042030b3:	75 de                	jne    8004203093 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80042030b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042030ba:	c9                   	leaveq 
  80042030bb:	c3                   	retq   

00000080042030bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80042030bc:	55                   	push   %rbp
  80042030bd:	48 89 e5             	mov    %rsp,%rbp
  80042030c0:	48 83 ec 0c          	sub    $0xc,%rsp
  80042030c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042030c8:	89 f0                	mov    %esi,%eax
  80042030ca:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80042030cd:	eb 13                	jmp    80042030e2 <strfind+0x26>
		if (*s == c)
  80042030cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030d3:	0f b6 00             	movzbl (%rax),%eax
  80042030d6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80042030d9:	75 02                	jne    80042030dd <strfind+0x21>
			break;
  80042030db:	eb 10                	jmp    80042030ed <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80042030dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80042030e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030e6:	0f b6 00             	movzbl (%rax),%eax
  80042030e9:	84 c0                	test   %al,%al
  80042030eb:	75 e2                	jne    80042030cf <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80042030ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042030f1:	c9                   	leaveq 
  80042030f2:	c3                   	retq   

00000080042030f3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80042030f3:	55                   	push   %rbp
  80042030f4:	48 89 e5             	mov    %rsp,%rbp
  80042030f7:	48 83 ec 18          	sub    $0x18,%rsp
  80042030fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042030ff:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8004203102:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8004203106:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420310b:	75 06                	jne    8004203113 <memset+0x20>
		return v;
  800420310d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203111:	eb 69                	jmp    800420317c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8004203113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203117:	83 e0 03             	and    $0x3,%eax
  800420311a:	48 85 c0             	test   %rax,%rax
  800420311d:	75 48                	jne    8004203167 <memset+0x74>
  800420311f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203123:	83 e0 03             	and    $0x3,%eax
  8004203126:	48 85 c0             	test   %rax,%rax
  8004203129:	75 3c                	jne    8004203167 <memset+0x74>
		c &= 0xFF;
  800420312b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8004203132:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203135:	c1 e0 18             	shl    $0x18,%eax
  8004203138:	89 c2                	mov    %eax,%edx
  800420313a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420313d:	c1 e0 10             	shl    $0x10,%eax
  8004203140:	09 c2                	or     %eax,%edx
  8004203142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203145:	c1 e0 08             	shl    $0x8,%eax
  8004203148:	09 d0                	or     %edx,%eax
  800420314a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  800420314d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203151:	48 c1 e8 02          	shr    $0x2,%rax
  8004203155:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8004203158:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420315c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420315f:	48 89 d7             	mov    %rdx,%rdi
  8004203162:	fc                   	cld    
  8004203163:	f3 ab                	rep stos %eax,%es:(%rdi)
  8004203165:	eb 11                	jmp    8004203178 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8004203167:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420316b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420316e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004203172:	48 89 d7             	mov    %rdx,%rdi
  8004203175:	fc                   	cld    
  8004203176:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8004203178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420317c:	c9                   	leaveq 
  800420317d:	c3                   	retq   

000000800420317e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800420317e:	55                   	push   %rbp
  800420317f:	48 89 e5             	mov    %rsp,%rbp
  8004203182:	48 83 ec 28          	sub    $0x28,%rsp
  8004203186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420318a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420318e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8004203192:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203196:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  800420319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420319e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80042031a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042031a6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80042031aa:	0f 83 88 00 00 00    	jae    8004203238 <memmove+0xba>
  80042031b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042031b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042031b8:	48 01 d0             	add    %rdx,%rax
  80042031bb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80042031bf:	76 77                	jbe    8004203238 <memmove+0xba>
		s += n;
  80042031c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042031c5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80042031c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042031cd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80042031d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042031d5:	83 e0 03             	and    $0x3,%eax
  80042031d8:	48 85 c0             	test   %rax,%rax
  80042031db:	75 3b                	jne    8004203218 <memmove+0x9a>
  80042031dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042031e1:	83 e0 03             	and    $0x3,%eax
  80042031e4:	48 85 c0             	test   %rax,%rax
  80042031e7:	75 2f                	jne    8004203218 <memmove+0x9a>
  80042031e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042031ed:	83 e0 03             	and    $0x3,%eax
  80042031f0:	48 85 c0             	test   %rax,%rax
  80042031f3:	75 23                	jne    8004203218 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80042031f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042031f9:	48 83 e8 04          	sub    $0x4,%rax
  80042031fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004203201:	48 83 ea 04          	sub    $0x4,%rdx
  8004203205:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004203209:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800420320d:	48 89 c7             	mov    %rax,%rdi
  8004203210:	48 89 d6             	mov    %rdx,%rsi
  8004203213:	fd                   	std    
  8004203214:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8004203216:	eb 1d                	jmp    8004203235 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8004203218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420321c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004203220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203224:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8004203228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420322c:	48 89 d7             	mov    %rdx,%rdi
  800420322f:	48 89 c1             	mov    %rax,%rcx
  8004203232:	fd                   	std    
  8004203233:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8004203235:	fc                   	cld    
  8004203236:	eb 57                	jmp    800420328f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8004203238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420323c:	83 e0 03             	and    $0x3,%eax
  800420323f:	48 85 c0             	test   %rax,%rax
  8004203242:	75 36                	jne    800420327a <memmove+0xfc>
  8004203244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203248:	83 e0 03             	and    $0x3,%eax
  800420324b:	48 85 c0             	test   %rax,%rax
  800420324e:	75 2a                	jne    800420327a <memmove+0xfc>
  8004203250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203254:	83 e0 03             	and    $0x3,%eax
  8004203257:	48 85 c0             	test   %rax,%rax
  800420325a:	75 1e                	jne    800420327a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800420325c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203260:	48 c1 e8 02          	shr    $0x2,%rax
  8004203264:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8004203267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420326b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420326f:	48 89 c7             	mov    %rax,%rdi
  8004203272:	48 89 d6             	mov    %rdx,%rsi
  8004203275:	fc                   	cld    
  8004203276:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8004203278:	eb 15                	jmp    800420328f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800420327a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420327e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004203282:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004203286:	48 89 c7             	mov    %rax,%rdi
  8004203289:	48 89 d6             	mov    %rdx,%rsi
  800420328c:	fc                   	cld    
  800420328d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800420328f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004203293:	c9                   	leaveq 
  8004203294:	c3                   	retq   

0000008004203295 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8004203295:	55                   	push   %rbp
  8004203296:	48 89 e5             	mov    %rsp,%rbp
  8004203299:	48 83 ec 18          	sub    $0x18,%rsp
  800420329d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042032a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80042032a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80042032a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042032ad:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042032b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042032b5:	48 89 ce             	mov    %rcx,%rsi
  80042032b8:	48 89 c7             	mov    %rax,%rdi
  80042032bb:	48 b8 7e 31 20 04 80 	movabs $0x800420317e,%rax
  80042032c2:	00 00 00 
  80042032c5:	ff d0                	callq  *%rax
}
  80042032c7:	c9                   	leaveq 
  80042032c8:	c3                   	retq   

00000080042032c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80042032c9:	55                   	push   %rbp
  80042032ca:	48 89 e5             	mov    %rsp,%rbp
  80042032cd:	48 83 ec 28          	sub    $0x28,%rsp
  80042032d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042032d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042032d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80042032dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042032e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80042032e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042032e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80042032ed:	eb 36                	jmp    8004203325 <memcmp+0x5c>
		if (*s1 != *s2)
  80042032ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042032f3:	0f b6 10             	movzbl (%rax),%edx
  80042032f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042032fa:	0f b6 00             	movzbl (%rax),%eax
  80042032fd:	38 c2                	cmp    %al,%dl
  80042032ff:	74 1a                	je     800420331b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8004203301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203305:	0f b6 00             	movzbl (%rax),%eax
  8004203308:	0f b6 d0             	movzbl %al,%edx
  800420330b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420330f:	0f b6 00             	movzbl (%rax),%eax
  8004203312:	0f b6 c0             	movzbl %al,%eax
  8004203315:	29 c2                	sub    %eax,%edx
  8004203317:	89 d0                	mov    %edx,%eax
  8004203319:	eb 20                	jmp    800420333b <memcmp+0x72>
		s1++, s2++;
  800420331b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004203320:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8004203325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203329:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800420332d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004203331:	48 85 c0             	test   %rax,%rax
  8004203334:	75 b9                	jne    80042032ef <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8004203336:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420333b:	c9                   	leaveq 
  800420333c:	c3                   	retq   

000000800420333d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800420333d:	55                   	push   %rbp
  800420333e:	48 89 e5             	mov    %rsp,%rbp
  8004203341:	48 83 ec 28          	sub    $0x28,%rsp
  8004203345:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203349:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800420334c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8004203350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203354:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203358:	48 01 d0             	add    %rdx,%rax
  800420335b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800420335f:	eb 15                	jmp    8004203376 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004203361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203365:	0f b6 10             	movzbl (%rax),%edx
  8004203368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420336b:	38 c2                	cmp    %al,%dl
  800420336d:	75 02                	jne    8004203371 <memfind+0x34>
			break;
  800420336f:	eb 0f                	jmp    8004203380 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8004203371:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004203376:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420337a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420337e:	72 e1                	jb     8004203361 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8004203380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004203384:	c9                   	leaveq 
  8004203385:	c3                   	retq   

0000008004203386 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004203386:	55                   	push   %rbp
  8004203387:	48 89 e5             	mov    %rsp,%rbp
  800420338a:	48 83 ec 34          	sub    $0x34,%rsp
  800420338e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203392:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004203396:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8004203399:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80042033a0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80042033a7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80042033a8:	eb 05                	jmp    80042033af <strtol+0x29>
		s++;
  80042033aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80042033af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033b3:	0f b6 00             	movzbl (%rax),%eax
  80042033b6:	3c 20                	cmp    $0x20,%al
  80042033b8:	74 f0                	je     80042033aa <strtol+0x24>
  80042033ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033be:	0f b6 00             	movzbl (%rax),%eax
  80042033c1:	3c 09                	cmp    $0x9,%al
  80042033c3:	74 e5                	je     80042033aa <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80042033c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033c9:	0f b6 00             	movzbl (%rax),%eax
  80042033cc:	3c 2b                	cmp    $0x2b,%al
  80042033ce:	75 07                	jne    80042033d7 <strtol+0x51>
		s++;
  80042033d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80042033d5:	eb 17                	jmp    80042033ee <strtol+0x68>
	else if (*s == '-')
  80042033d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033db:	0f b6 00             	movzbl (%rax),%eax
  80042033de:	3c 2d                	cmp    $0x2d,%al
  80042033e0:	75 0c                	jne    80042033ee <strtol+0x68>
		s++, neg = 1;
  80042033e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80042033e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80042033ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80042033f2:	74 06                	je     80042033fa <strtol+0x74>
  80042033f4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80042033f8:	75 28                	jne    8004203422 <strtol+0x9c>
  80042033fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042033fe:	0f b6 00             	movzbl (%rax),%eax
  8004203401:	3c 30                	cmp    $0x30,%al
  8004203403:	75 1d                	jne    8004203422 <strtol+0x9c>
  8004203405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203409:	48 83 c0 01          	add    $0x1,%rax
  800420340d:	0f b6 00             	movzbl (%rax),%eax
  8004203410:	3c 78                	cmp    $0x78,%al
  8004203412:	75 0e                	jne    8004203422 <strtol+0x9c>
		s += 2, base = 16;
  8004203414:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8004203419:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8004203420:	eb 2c                	jmp    800420344e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8004203422:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004203426:	75 19                	jne    8004203441 <strtol+0xbb>
  8004203428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420342c:	0f b6 00             	movzbl (%rax),%eax
  800420342f:	3c 30                	cmp    $0x30,%al
  8004203431:	75 0e                	jne    8004203441 <strtol+0xbb>
		s++, base = 8;
  8004203433:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8004203438:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800420343f:	eb 0d                	jmp    800420344e <strtol+0xc8>
	else if (base == 0)
  8004203441:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004203445:	75 07                	jne    800420344e <strtol+0xc8>
		base = 10;
  8004203447:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800420344e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203452:	0f b6 00             	movzbl (%rax),%eax
  8004203455:	3c 2f                	cmp    $0x2f,%al
  8004203457:	7e 1d                	jle    8004203476 <strtol+0xf0>
  8004203459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420345d:	0f b6 00             	movzbl (%rax),%eax
  8004203460:	3c 39                	cmp    $0x39,%al
  8004203462:	7f 12                	jg     8004203476 <strtol+0xf0>
			dig = *s - '0';
  8004203464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203468:	0f b6 00             	movzbl (%rax),%eax
  800420346b:	0f be c0             	movsbl %al,%eax
  800420346e:	83 e8 30             	sub    $0x30,%eax
  8004203471:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8004203474:	eb 4e                	jmp    80042034c4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8004203476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420347a:	0f b6 00             	movzbl (%rax),%eax
  800420347d:	3c 60                	cmp    $0x60,%al
  800420347f:	7e 1d                	jle    800420349e <strtol+0x118>
  8004203481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203485:	0f b6 00             	movzbl (%rax),%eax
  8004203488:	3c 7a                	cmp    $0x7a,%al
  800420348a:	7f 12                	jg     800420349e <strtol+0x118>
			dig = *s - 'a' + 10;
  800420348c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203490:	0f b6 00             	movzbl (%rax),%eax
  8004203493:	0f be c0             	movsbl %al,%eax
  8004203496:	83 e8 57             	sub    $0x57,%eax
  8004203499:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800420349c:	eb 26                	jmp    80042034c4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  800420349e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042034a2:	0f b6 00             	movzbl (%rax),%eax
  80042034a5:	3c 40                	cmp    $0x40,%al
  80042034a7:	7e 48                	jle    80042034f1 <strtol+0x16b>
  80042034a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042034ad:	0f b6 00             	movzbl (%rax),%eax
  80042034b0:	3c 5a                	cmp    $0x5a,%al
  80042034b2:	7f 3d                	jg     80042034f1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80042034b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042034b8:	0f b6 00             	movzbl (%rax),%eax
  80042034bb:	0f be c0             	movsbl %al,%eax
  80042034be:	83 e8 37             	sub    $0x37,%eax
  80042034c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80042034c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042034c7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80042034ca:	7c 02                	jl     80042034ce <strtol+0x148>
			break;
  80042034cc:	eb 23                	jmp    80042034f1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80042034ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80042034d3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042034d6:	48 98                	cltq   
  80042034d8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80042034dd:	48 89 c2             	mov    %rax,%rdx
  80042034e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042034e3:	48 98                	cltq   
  80042034e5:	48 01 d0             	add    %rdx,%rax
  80042034e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80042034ec:	e9 5d ff ff ff       	jmpq   800420344e <strtol+0xc8>

	if (endptr)
  80042034f1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042034f6:	74 0b                	je     8004203503 <strtol+0x17d>
		*endptr = (char *) s;
  80042034f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042034fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004203500:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8004203503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004203507:	74 09                	je     8004203512 <strtol+0x18c>
  8004203509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420350d:	48 f7 d8             	neg    %rax
  8004203510:	eb 04                	jmp    8004203516 <strtol+0x190>
  8004203512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203516:	c9                   	leaveq 
  8004203517:	c3                   	retq   

0000008004203518 <strstr>:

char * strstr(const char *in, const char *str)
{
  8004203518:	55                   	push   %rbp
  8004203519:	48 89 e5             	mov    %rsp,%rbp
  800420351c:	48 83 ec 30          	sub    $0x30,%rsp
  8004203520:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203524:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8004203528:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420352c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203530:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004203534:	0f b6 00             	movzbl (%rax),%eax
  8004203537:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  800420353a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800420353e:	75 06                	jne    8004203546 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8004203540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203544:	eb 6b                	jmp    80042035b1 <strstr+0x99>

	len = strlen(str);
  8004203546:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420354a:	48 89 c7             	mov    %rax,%rdi
  800420354d:	48 b8 ee 2d 20 04 80 	movabs $0x8004202dee,%rax
  8004203554:	00 00 00 
  8004203557:	ff d0                	callq  *%rax
  8004203559:	48 98                	cltq   
  800420355b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800420355f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203563:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203567:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420356b:	0f b6 00             	movzbl (%rax),%eax
  800420356e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8004203571:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8004203575:	75 07                	jne    800420357e <strstr+0x66>
				return (char *) 0;
  8004203577:	b8 00 00 00 00       	mov    $0x0,%eax
  800420357c:	eb 33                	jmp    80042035b1 <strstr+0x99>
		} while (sc != c);
  800420357e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8004203582:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8004203585:	75 d8                	jne    800420355f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8004203587:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420358b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800420358f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203593:	48 89 ce             	mov    %rcx,%rsi
  8004203596:	48 89 c7             	mov    %rax,%rdi
  8004203599:	48 b8 0f 30 20 04 80 	movabs $0x800420300f,%rax
  80042035a0:	00 00 00 
  80042035a3:	ff d0                	callq  *%rax
  80042035a5:	85 c0                	test   %eax,%eax
  80042035a7:	75 b6                	jne    800420355f <strstr+0x47>

	return (char *) (in - 1);
  80042035a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042035ad:	48 83 e8 01          	sub    $0x1,%rax
}
  80042035b1:	c9                   	leaveq 
  80042035b2:	c3                   	retq   

00000080042035b3 <_dwarf_read_lsb>:
Dwarf_Section *
_dwarf_find_section(const char *name);

uint64_t
_dwarf_read_lsb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  80042035b3:	55                   	push   %rbp
  80042035b4:	48 89 e5             	mov    %rsp,%rbp
  80042035b7:	48 83 ec 24          	sub    $0x24,%rsp
  80042035bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042035bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042035c3:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  80042035c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042035ca:	48 8b 10             	mov    (%rax),%rdx
  80042035cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042035d1:	48 01 d0             	add    %rdx,%rax
  80042035d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  80042035d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042035df:	00 
	switch (bytes_to_read) {
  80042035e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042035e3:	83 f8 02             	cmp    $0x2,%eax
  80042035e6:	0f 84 ab 00 00 00    	je     8004203697 <_dwarf_read_lsb+0xe4>
  80042035ec:	83 f8 02             	cmp    $0x2,%eax
  80042035ef:	7f 0e                	jg     80042035ff <_dwarf_read_lsb+0x4c>
  80042035f1:	83 f8 01             	cmp    $0x1,%eax
  80042035f4:	0f 84 b3 00 00 00    	je     80042036ad <_dwarf_read_lsb+0xfa>
  80042035fa:	e9 d9 00 00 00       	jmpq   80042036d8 <_dwarf_read_lsb+0x125>
  80042035ff:	83 f8 04             	cmp    $0x4,%eax
  8004203602:	74 65                	je     8004203669 <_dwarf_read_lsb+0xb6>
  8004203604:	83 f8 08             	cmp    $0x8,%eax
  8004203607:	0f 85 cb 00 00 00    	jne    80042036d8 <_dwarf_read_lsb+0x125>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  800420360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203611:	48 83 c0 04          	add    $0x4,%rax
  8004203615:	0f b6 00             	movzbl (%rax),%eax
  8004203618:	0f b6 c0             	movzbl %al,%eax
  800420361b:	48 c1 e0 20          	shl    $0x20,%rax
  800420361f:	48 89 c2             	mov    %rax,%rdx
  8004203622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203626:	48 83 c0 05          	add    $0x5,%rax
  800420362a:	0f b6 00             	movzbl (%rax),%eax
  800420362d:	0f b6 c0             	movzbl %al,%eax
  8004203630:	48 c1 e0 28          	shl    $0x28,%rax
  8004203634:	48 09 d0             	or     %rdx,%rax
  8004203637:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  800420363b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420363f:	48 83 c0 06          	add    $0x6,%rax
  8004203643:	0f b6 00             	movzbl (%rax),%eax
  8004203646:	0f b6 c0             	movzbl %al,%eax
  8004203649:	48 c1 e0 30          	shl    $0x30,%rax
  800420364d:	48 89 c2             	mov    %rax,%rdx
  8004203650:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203654:	48 83 c0 07          	add    $0x7,%rax
  8004203658:	0f b6 00             	movzbl (%rax),%eax
  800420365b:	0f b6 c0             	movzbl %al,%eax
  800420365e:	48 c1 e0 38          	shl    $0x38,%rax
  8004203662:	48 09 d0             	or     %rdx,%rax
  8004203665:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  8004203669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420366d:	48 83 c0 02          	add    $0x2,%rax
  8004203671:	0f b6 00             	movzbl (%rax),%eax
  8004203674:	0f b6 c0             	movzbl %al,%eax
  8004203677:	48 c1 e0 10          	shl    $0x10,%rax
  800420367b:	48 89 c2             	mov    %rax,%rdx
  800420367e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203682:	48 83 c0 03          	add    $0x3,%rax
  8004203686:	0f b6 00             	movzbl (%rax),%eax
  8004203689:	0f b6 c0             	movzbl %al,%eax
  800420368c:	48 c1 e0 18          	shl    $0x18,%rax
  8004203690:	48 09 d0             	or     %rdx,%rax
  8004203693:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  8004203697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420369b:	48 83 c0 01          	add    $0x1,%rax
  800420369f:	0f b6 00             	movzbl (%rax),%eax
  80042036a2:	0f b6 c0             	movzbl %al,%eax
  80042036a5:	48 c1 e0 08          	shl    $0x8,%rax
  80042036a9:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  80042036ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042036b1:	0f b6 00             	movzbl (%rax),%eax
  80042036b4:	0f b6 c0             	movzbl %al,%eax
  80042036b7:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042036bb:	90                   	nop
	default:
		return (0);
	}

	*offsetp += bytes_to_read;
  80042036bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042036c0:	48 8b 10             	mov    (%rax),%rdx
  80042036c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042036c6:	48 98                	cltq   
  80042036c8:	48 01 c2             	add    %rax,%rdx
  80042036cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042036cf:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042036d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042036d6:	eb 05                	jmp    80042036dd <_dwarf_read_lsb+0x12a>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  80042036d8:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*offsetp += bytes_to_read;

	return (ret);
}
  80042036dd:	c9                   	leaveq 
  80042036de:	c3                   	retq   

00000080042036df <_dwarf_decode_lsb>:

uint64_t
_dwarf_decode_lsb(uint8_t **data, int bytes_to_read)
{
  80042036df:	55                   	push   %rbp
  80042036e0:	48 89 e5             	mov    %rsp,%rbp
  80042036e3:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042036e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042036eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  80042036ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042036f2:	48 8b 00             	mov    (%rax),%rax
  80042036f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  80042036f9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203700:	00 
	switch (bytes_to_read) {
  8004203701:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004203704:	83 f8 02             	cmp    $0x2,%eax
  8004203707:	0f 84 ab 00 00 00    	je     80042037b8 <_dwarf_decode_lsb+0xd9>
  800420370d:	83 f8 02             	cmp    $0x2,%eax
  8004203710:	7f 0e                	jg     8004203720 <_dwarf_decode_lsb+0x41>
  8004203712:	83 f8 01             	cmp    $0x1,%eax
  8004203715:	0f 84 b3 00 00 00    	je     80042037ce <_dwarf_decode_lsb+0xef>
  800420371b:	e9 d9 00 00 00       	jmpq   80042037f9 <_dwarf_decode_lsb+0x11a>
  8004203720:	83 f8 04             	cmp    $0x4,%eax
  8004203723:	74 65                	je     800420378a <_dwarf_decode_lsb+0xab>
  8004203725:	83 f8 08             	cmp    $0x8,%eax
  8004203728:	0f 85 cb 00 00 00    	jne    80042037f9 <_dwarf_decode_lsb+0x11a>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  800420372e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203732:	48 83 c0 04          	add    $0x4,%rax
  8004203736:	0f b6 00             	movzbl (%rax),%eax
  8004203739:	0f b6 c0             	movzbl %al,%eax
  800420373c:	48 c1 e0 20          	shl    $0x20,%rax
  8004203740:	48 89 c2             	mov    %rax,%rdx
  8004203743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203747:	48 83 c0 05          	add    $0x5,%rax
  800420374b:	0f b6 00             	movzbl (%rax),%eax
  800420374e:	0f b6 c0             	movzbl %al,%eax
  8004203751:	48 c1 e0 28          	shl    $0x28,%rax
  8004203755:	48 09 d0             	or     %rdx,%rax
  8004203758:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  800420375c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203760:	48 83 c0 06          	add    $0x6,%rax
  8004203764:	0f b6 00             	movzbl (%rax),%eax
  8004203767:	0f b6 c0             	movzbl %al,%eax
  800420376a:	48 c1 e0 30          	shl    $0x30,%rax
  800420376e:	48 89 c2             	mov    %rax,%rdx
  8004203771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203775:	48 83 c0 07          	add    $0x7,%rax
  8004203779:	0f b6 00             	movzbl (%rax),%eax
  800420377c:	0f b6 c0             	movzbl %al,%eax
  800420377f:	48 c1 e0 38          	shl    $0x38,%rax
  8004203783:	48 09 d0             	or     %rdx,%rax
  8004203786:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  800420378a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420378e:	48 83 c0 02          	add    $0x2,%rax
  8004203792:	0f b6 00             	movzbl (%rax),%eax
  8004203795:	0f b6 c0             	movzbl %al,%eax
  8004203798:	48 c1 e0 10          	shl    $0x10,%rax
  800420379c:	48 89 c2             	mov    %rax,%rdx
  800420379f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037a3:	48 83 c0 03          	add    $0x3,%rax
  80042037a7:	0f b6 00             	movzbl (%rax),%eax
  80042037aa:	0f b6 c0             	movzbl %al,%eax
  80042037ad:	48 c1 e0 18          	shl    $0x18,%rax
  80042037b1:	48 09 d0             	or     %rdx,%rax
  80042037b4:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  80042037b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037bc:	48 83 c0 01          	add    $0x1,%rax
  80042037c0:	0f b6 00             	movzbl (%rax),%eax
  80042037c3:	0f b6 c0             	movzbl %al,%eax
  80042037c6:	48 c1 e0 08          	shl    $0x8,%rax
  80042037ca:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  80042037ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042037d2:	0f b6 00             	movzbl (%rax),%eax
  80042037d5:	0f b6 c0             	movzbl %al,%eax
  80042037d8:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042037dc:	90                   	nop
	default:
		return (0);
	}

	*data += bytes_to_read;
  80042037dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042037e1:	48 8b 10             	mov    (%rax),%rdx
  80042037e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042037e7:	48 98                	cltq   
  80042037e9:	48 01 c2             	add    %rax,%rdx
  80042037ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042037f0:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042037f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042037f7:	eb 05                	jmp    80042037fe <_dwarf_decode_lsb+0x11f>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  80042037f9:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*data += bytes_to_read;

	return (ret);
}
  80042037fe:	c9                   	leaveq 
  80042037ff:	c3                   	retq   

0000008004203800 <_dwarf_read_msb>:

uint64_t
_dwarf_read_msb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  8004203800:	55                   	push   %rbp
  8004203801:	48 89 e5             	mov    %rsp,%rbp
  8004203804:	48 83 ec 24          	sub    $0x24,%rsp
  8004203808:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420380c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203810:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  8004203813:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203817:	48 8b 10             	mov    (%rax),%rdx
  800420381a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420381e:	48 01 d0             	add    %rdx,%rax
  8004203821:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	switch (bytes_to_read) {
  8004203825:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004203828:	83 f8 02             	cmp    $0x2,%eax
  800420382b:	74 35                	je     8004203862 <_dwarf_read_msb+0x62>
  800420382d:	83 f8 02             	cmp    $0x2,%eax
  8004203830:	7f 0a                	jg     800420383c <_dwarf_read_msb+0x3c>
  8004203832:	83 f8 01             	cmp    $0x1,%eax
  8004203835:	74 18                	je     800420384f <_dwarf_read_msb+0x4f>
  8004203837:	e9 53 01 00 00       	jmpq   800420398f <_dwarf_read_msb+0x18f>
  800420383c:	83 f8 04             	cmp    $0x4,%eax
  800420383f:	74 49                	je     800420388a <_dwarf_read_msb+0x8a>
  8004203841:	83 f8 08             	cmp    $0x8,%eax
  8004203844:	0f 84 96 00 00 00    	je     80042038e0 <_dwarf_read_msb+0xe0>
  800420384a:	e9 40 01 00 00       	jmpq   800420398f <_dwarf_read_msb+0x18f>
	case 1:
		ret = src[0];
  800420384f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203853:	0f b6 00             	movzbl (%rax),%eax
  8004203856:	0f b6 c0             	movzbl %al,%eax
  8004203859:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  800420385d:	e9 34 01 00 00       	jmpq   8004203996 <_dwarf_read_msb+0x196>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  8004203862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203866:	48 83 c0 01          	add    $0x1,%rax
  800420386a:	0f b6 00             	movzbl (%rax),%eax
  800420386d:	0f b6 d0             	movzbl %al,%edx
  8004203870:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203874:	0f b6 00             	movzbl (%rax),%eax
  8004203877:	0f b6 c0             	movzbl %al,%eax
  800420387a:	48 c1 e0 08          	shl    $0x8,%rax
  800420387e:	48 09 d0             	or     %rdx,%rax
  8004203881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004203885:	e9 0c 01 00 00       	jmpq   8004203996 <_dwarf_read_msb+0x196>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  800420388a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420388e:	48 83 c0 03          	add    $0x3,%rax
  8004203892:	0f b6 00             	movzbl (%rax),%eax
  8004203895:	0f b6 c0             	movzbl %al,%eax
  8004203898:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420389c:	48 83 c2 02          	add    $0x2,%rdx
  80042038a0:	0f b6 12             	movzbl (%rdx),%edx
  80042038a3:	0f b6 d2             	movzbl %dl,%edx
  80042038a6:	48 c1 e2 08          	shl    $0x8,%rdx
  80042038aa:	48 09 d0             	or     %rdx,%rax
  80042038ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  80042038b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038b5:	48 83 c0 01          	add    $0x1,%rax
  80042038b9:	0f b6 00             	movzbl (%rax),%eax
  80042038bc:	0f b6 c0             	movzbl %al,%eax
  80042038bf:	48 c1 e0 10          	shl    $0x10,%rax
  80042038c3:	48 89 c2             	mov    %rax,%rdx
  80042038c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038ca:	0f b6 00             	movzbl (%rax),%eax
  80042038cd:	0f b6 c0             	movzbl %al,%eax
  80042038d0:	48 c1 e0 18          	shl    $0x18,%rax
  80042038d4:	48 09 d0             	or     %rdx,%rax
  80042038d7:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042038db:	e9 b6 00 00 00       	jmpq   8004203996 <_dwarf_read_msb+0x196>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  80042038e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042038e4:	48 83 c0 07          	add    $0x7,%rax
  80042038e8:	0f b6 00             	movzbl (%rax),%eax
  80042038eb:	0f b6 c0             	movzbl %al,%eax
  80042038ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042038f2:	48 83 c2 06          	add    $0x6,%rdx
  80042038f6:	0f b6 12             	movzbl (%rdx),%edx
  80042038f9:	0f b6 d2             	movzbl %dl,%edx
  80042038fc:	48 c1 e2 08          	shl    $0x8,%rdx
  8004203900:	48 09 d0             	or     %rdx,%rax
  8004203903:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  8004203907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420390b:	48 83 c0 05          	add    $0x5,%rax
  800420390f:	0f b6 00             	movzbl (%rax),%eax
  8004203912:	0f b6 c0             	movzbl %al,%eax
  8004203915:	48 c1 e0 10          	shl    $0x10,%rax
  8004203919:	48 89 c2             	mov    %rax,%rdx
  800420391c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203920:	48 83 c0 04          	add    $0x4,%rax
  8004203924:	0f b6 00             	movzbl (%rax),%eax
  8004203927:	0f b6 c0             	movzbl %al,%eax
  800420392a:	48 c1 e0 18          	shl    $0x18,%rax
  800420392e:	48 09 d0             	or     %rdx,%rax
  8004203931:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  8004203935:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203939:	48 83 c0 03          	add    $0x3,%rax
  800420393d:	0f b6 00             	movzbl (%rax),%eax
  8004203940:	0f b6 c0             	movzbl %al,%eax
  8004203943:	48 c1 e0 20          	shl    $0x20,%rax
  8004203947:	48 89 c2             	mov    %rax,%rdx
  800420394a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420394e:	48 83 c0 02          	add    $0x2,%rax
  8004203952:	0f b6 00             	movzbl (%rax),%eax
  8004203955:	0f b6 c0             	movzbl %al,%eax
  8004203958:	48 c1 e0 28          	shl    $0x28,%rax
  800420395c:	48 09 d0             	or     %rdx,%rax
  800420395f:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  8004203963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203967:	48 83 c0 01          	add    $0x1,%rax
  800420396b:	0f b6 00             	movzbl (%rax),%eax
  800420396e:	0f b6 c0             	movzbl %al,%eax
  8004203971:	48 c1 e0 30          	shl    $0x30,%rax
  8004203975:	48 89 c2             	mov    %rax,%rdx
  8004203978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420397c:	0f b6 00             	movzbl (%rax),%eax
  800420397f:	0f b6 c0             	movzbl %al,%eax
  8004203982:	48 c1 e0 38          	shl    $0x38,%rax
  8004203986:	48 09 d0             	or     %rdx,%rax
  8004203989:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420398d:	eb 07                	jmp    8004203996 <_dwarf_read_msb+0x196>
	default:
		return (0);
  800420398f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203994:	eb 1a                	jmp    80042039b0 <_dwarf_read_msb+0x1b0>
	}

	*offsetp += bytes_to_read;
  8004203996:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420399a:	48 8b 10             	mov    (%rax),%rdx
  800420399d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042039a0:	48 98                	cltq   
  80042039a2:	48 01 c2             	add    %rax,%rdx
  80042039a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042039a9:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042039ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042039b0:	c9                   	leaveq 
  80042039b1:	c3                   	retq   

00000080042039b2 <_dwarf_decode_msb>:

uint64_t
_dwarf_decode_msb(uint8_t **data, int bytes_to_read)
{
  80042039b2:	55                   	push   %rbp
  80042039b3:	48 89 e5             	mov    %rsp,%rbp
  80042039b6:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042039ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042039be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  80042039c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042039c5:	48 8b 00             	mov    (%rax),%rax
  80042039c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  80042039cc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042039d3:	00 
	switch (bytes_to_read) {
  80042039d4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042039d7:	83 f8 02             	cmp    $0x2,%eax
  80042039da:	74 35                	je     8004203a11 <_dwarf_decode_msb+0x5f>
  80042039dc:	83 f8 02             	cmp    $0x2,%eax
  80042039df:	7f 0a                	jg     80042039eb <_dwarf_decode_msb+0x39>
  80042039e1:	83 f8 01             	cmp    $0x1,%eax
  80042039e4:	74 18                	je     80042039fe <_dwarf_decode_msb+0x4c>
  80042039e6:	e9 53 01 00 00       	jmpq   8004203b3e <_dwarf_decode_msb+0x18c>
  80042039eb:	83 f8 04             	cmp    $0x4,%eax
  80042039ee:	74 49                	je     8004203a39 <_dwarf_decode_msb+0x87>
  80042039f0:	83 f8 08             	cmp    $0x8,%eax
  80042039f3:	0f 84 96 00 00 00    	je     8004203a8f <_dwarf_decode_msb+0xdd>
  80042039f9:	e9 40 01 00 00       	jmpq   8004203b3e <_dwarf_decode_msb+0x18c>
	case 1:
		ret = src[0];
  80042039fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a02:	0f b6 00             	movzbl (%rax),%eax
  8004203a05:	0f b6 c0             	movzbl %al,%eax
  8004203a08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004203a0c:	e9 34 01 00 00       	jmpq   8004203b45 <_dwarf_decode_msb+0x193>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  8004203a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a15:	48 83 c0 01          	add    $0x1,%rax
  8004203a19:	0f b6 00             	movzbl (%rax),%eax
  8004203a1c:	0f b6 d0             	movzbl %al,%edx
  8004203a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a23:	0f b6 00             	movzbl (%rax),%eax
  8004203a26:	0f b6 c0             	movzbl %al,%eax
  8004203a29:	48 c1 e0 08          	shl    $0x8,%rax
  8004203a2d:	48 09 d0             	or     %rdx,%rax
  8004203a30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004203a34:	e9 0c 01 00 00       	jmpq   8004203b45 <_dwarf_decode_msb+0x193>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  8004203a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a3d:	48 83 c0 03          	add    $0x3,%rax
  8004203a41:	0f b6 00             	movzbl (%rax),%eax
  8004203a44:	0f b6 c0             	movzbl %al,%eax
  8004203a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004203a4b:	48 83 c2 02          	add    $0x2,%rdx
  8004203a4f:	0f b6 12             	movzbl (%rdx),%edx
  8004203a52:	0f b6 d2             	movzbl %dl,%edx
  8004203a55:	48 c1 e2 08          	shl    $0x8,%rdx
  8004203a59:	48 09 d0             	or     %rdx,%rax
  8004203a5c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  8004203a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a64:	48 83 c0 01          	add    $0x1,%rax
  8004203a68:	0f b6 00             	movzbl (%rax),%eax
  8004203a6b:	0f b6 c0             	movzbl %al,%eax
  8004203a6e:	48 c1 e0 10          	shl    $0x10,%rax
  8004203a72:	48 89 c2             	mov    %rax,%rdx
  8004203a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a79:	0f b6 00             	movzbl (%rax),%eax
  8004203a7c:	0f b6 c0             	movzbl %al,%eax
  8004203a7f:	48 c1 e0 18          	shl    $0x18,%rax
  8004203a83:	48 09 d0             	or     %rdx,%rax
  8004203a86:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  8004203a8a:	e9 b6 00 00 00       	jmpq   8004203b45 <_dwarf_decode_msb+0x193>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  8004203a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203a93:	48 83 c0 07          	add    $0x7,%rax
  8004203a97:	0f b6 00             	movzbl (%rax),%eax
  8004203a9a:	0f b6 c0             	movzbl %al,%eax
  8004203a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004203aa1:	48 83 c2 06          	add    $0x6,%rdx
  8004203aa5:	0f b6 12             	movzbl (%rdx),%edx
  8004203aa8:	0f b6 d2             	movzbl %dl,%edx
  8004203aab:	48 c1 e2 08          	shl    $0x8,%rdx
  8004203aaf:	48 09 d0             	or     %rdx,%rax
  8004203ab2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  8004203ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203aba:	48 83 c0 05          	add    $0x5,%rax
  8004203abe:	0f b6 00             	movzbl (%rax),%eax
  8004203ac1:	0f b6 c0             	movzbl %al,%eax
  8004203ac4:	48 c1 e0 10          	shl    $0x10,%rax
  8004203ac8:	48 89 c2             	mov    %rax,%rdx
  8004203acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203acf:	48 83 c0 04          	add    $0x4,%rax
  8004203ad3:	0f b6 00             	movzbl (%rax),%eax
  8004203ad6:	0f b6 c0             	movzbl %al,%eax
  8004203ad9:	48 c1 e0 18          	shl    $0x18,%rax
  8004203add:	48 09 d0             	or     %rdx,%rax
  8004203ae0:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  8004203ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203ae8:	48 83 c0 03          	add    $0x3,%rax
  8004203aec:	0f b6 00             	movzbl (%rax),%eax
  8004203aef:	0f b6 c0             	movzbl %al,%eax
  8004203af2:	48 c1 e0 20          	shl    $0x20,%rax
  8004203af6:	48 89 c2             	mov    %rax,%rdx
  8004203af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203afd:	48 83 c0 02          	add    $0x2,%rax
  8004203b01:	0f b6 00             	movzbl (%rax),%eax
  8004203b04:	0f b6 c0             	movzbl %al,%eax
  8004203b07:	48 c1 e0 28          	shl    $0x28,%rax
  8004203b0b:	48 09 d0             	or     %rdx,%rax
  8004203b0e:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  8004203b12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203b16:	48 83 c0 01          	add    $0x1,%rax
  8004203b1a:	0f b6 00             	movzbl (%rax),%eax
  8004203b1d:	0f b6 c0             	movzbl %al,%eax
  8004203b20:	48 c1 e0 30          	shl    $0x30,%rax
  8004203b24:	48 89 c2             	mov    %rax,%rdx
  8004203b27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004203b2b:	0f b6 00             	movzbl (%rax),%eax
  8004203b2e:	0f b6 c0             	movzbl %al,%eax
  8004203b31:	48 c1 e0 38          	shl    $0x38,%rax
  8004203b35:	48 09 d0             	or     %rdx,%rax
  8004203b38:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  8004203b3c:	eb 07                	jmp    8004203b45 <_dwarf_decode_msb+0x193>
	default:
		return (0);
  8004203b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203b43:	eb 1a                	jmp    8004203b5f <_dwarf_decode_msb+0x1ad>
		break;
	}

	*data += bytes_to_read;
  8004203b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203b49:	48 8b 10             	mov    (%rax),%rdx
  8004203b4c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004203b4f:	48 98                	cltq   
  8004203b51:	48 01 c2             	add    %rax,%rdx
  8004203b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203b58:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203b5f:	c9                   	leaveq 
  8004203b60:	c3                   	retq   

0000008004203b61 <_dwarf_read_sleb128>:

int64_t
_dwarf_read_sleb128(uint8_t *data, uint64_t *offsetp)
{
  8004203b61:	55                   	push   %rbp
  8004203b62:	48 89 e5             	mov    %rsp,%rbp
  8004203b65:	48 83 ec 30          	sub    $0x30,%rsp
  8004203b69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203b6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int64_t ret = 0;
  8004203b71:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203b78:	00 
	uint8_t b;
	int shift = 0;
  8004203b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  8004203b80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203b84:	48 8b 10             	mov    (%rax),%rdx
  8004203b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203b8b:	48 01 d0             	add    %rdx,%rax
  8004203b8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203b96:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203b9a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203b9e:	0f b6 00             	movzbl (%rax),%eax
  8004203ba1:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203ba4:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203ba8:	83 e0 7f             	and    $0x7f,%eax
  8004203bab:	89 c2                	mov    %eax,%edx
  8004203bad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203bb0:	89 c1                	mov    %eax,%ecx
  8004203bb2:	d3 e2                	shl    %cl,%edx
  8004203bb4:	89 d0                	mov    %edx,%eax
  8004203bb6:	48 98                	cltq   
  8004203bb8:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004203bbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203bc0:	48 8b 00             	mov    (%rax),%rax
  8004203bc3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203bc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203bcb:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004203bce:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203bd2:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203bd6:	84 c0                	test   %al,%al
  8004203bd8:	78 b8                	js     8004203b92 <_dwarf_read_sleb128+0x31>

	if (shift < 32 && (b & 0x40) != 0)
  8004203bda:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004203bde:	7f 1f                	jg     8004203bff <_dwarf_read_sleb128+0x9e>
  8004203be0:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203be4:	83 e0 40             	and    $0x40,%eax
  8004203be7:	85 c0                	test   %eax,%eax
  8004203be9:	74 14                	je     8004203bff <_dwarf_read_sleb128+0x9e>
		ret |= (-1 << shift);
  8004203beb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203bee:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004203bf3:	89 c1                	mov    %eax,%ecx
  8004203bf5:	d3 e2                	shl    %cl,%edx
  8004203bf7:	89 d0                	mov    %edx,%eax
  8004203bf9:	48 98                	cltq   
  8004203bfb:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	return (ret);
  8004203bff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203c03:	c9                   	leaveq 
  8004203c04:	c3                   	retq   

0000008004203c05 <_dwarf_read_uleb128>:

uint64_t
_dwarf_read_uleb128(uint8_t *data, uint64_t *offsetp)
{
  8004203c05:	55                   	push   %rbp
  8004203c06:	48 89 e5             	mov    %rsp,%rbp
  8004203c09:	48 83 ec 30          	sub    $0x30,%rsp
  8004203c0d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004203c11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	uint64_t ret = 0;
  8004203c15:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203c1c:	00 
	uint8_t b;
	int shift = 0;
  8004203c1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  8004203c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203c28:	48 8b 10             	mov    (%rax),%rdx
  8004203c2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203c2f:	48 01 d0             	add    %rdx,%rax
  8004203c32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203c3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203c3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203c42:	0f b6 00             	movzbl (%rax),%eax
  8004203c45:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203c48:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203c4c:	83 e0 7f             	and    $0x7f,%eax
  8004203c4f:	89 c2                	mov    %eax,%edx
  8004203c51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203c54:	89 c1                	mov    %eax,%ecx
  8004203c56:	d3 e2                	shl    %cl,%edx
  8004203c58:	89 d0                	mov    %edx,%eax
  8004203c5a:	48 98                	cltq   
  8004203c5c:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004203c60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203c64:	48 8b 00             	mov    (%rax),%rax
  8004203c67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203c6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203c6f:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004203c72:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203c76:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203c7a:	84 c0                	test   %al,%al
  8004203c7c:	78 b8                	js     8004203c36 <_dwarf_read_uleb128+0x31>

	return (ret);
  8004203c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203c82:	c9                   	leaveq 
  8004203c83:	c3                   	retq   

0000008004203c84 <_dwarf_decode_sleb128>:

int64_t
_dwarf_decode_sleb128(uint8_t **dp)
{
  8004203c84:	55                   	push   %rbp
  8004203c85:	48 89 e5             	mov    %rsp,%rbp
  8004203c88:	48 83 ec 28          	sub    $0x28,%rsp
  8004203c8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int64_t ret = 0;
  8004203c90:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203c97:	00 
	uint8_t b;
	int shift = 0;
  8004203c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004203c9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203ca3:	48 8b 00             	mov    (%rax),%rax
  8004203ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203cae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203cb2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203cb6:	0f b6 00             	movzbl (%rax),%eax
  8004203cb9:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203cbc:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203cc0:	83 e0 7f             	and    $0x7f,%eax
  8004203cc3:	89 c2                	mov    %eax,%edx
  8004203cc5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203cc8:	89 c1                	mov    %eax,%ecx
  8004203cca:	d3 e2                	shl    %cl,%edx
  8004203ccc:	89 d0                	mov    %edx,%eax
  8004203cce:	48 98                	cltq   
  8004203cd0:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004203cd4:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203cd8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203cdc:	84 c0                	test   %al,%al
  8004203cde:	78 ca                	js     8004203caa <_dwarf_decode_sleb128+0x26>

	if (shift < 32 && (b & 0x40) != 0)
  8004203ce0:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004203ce4:	7f 1f                	jg     8004203d05 <_dwarf_decode_sleb128+0x81>
  8004203ce6:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203cea:	83 e0 40             	and    $0x40,%eax
  8004203ced:	85 c0                	test   %eax,%eax
  8004203cef:	74 14                	je     8004203d05 <_dwarf_decode_sleb128+0x81>
		ret |= (-1 << shift);
  8004203cf1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203cf4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004203cf9:	89 c1                	mov    %eax,%ecx
  8004203cfb:	d3 e2                	shl    %cl,%edx
  8004203cfd:	89 d0                	mov    %edx,%eax
  8004203cff:	48 98                	cltq   
  8004203d01:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	*dp = src;
  8004203d05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203d0d:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203d14:	c9                   	leaveq 
  8004203d15:	c3                   	retq   

0000008004203d16 <_dwarf_decode_uleb128>:

uint64_t
_dwarf_decode_uleb128(uint8_t **dp)
{
  8004203d16:	55                   	push   %rbp
  8004203d17:	48 89 e5             	mov    %rsp,%rbp
  8004203d1a:	48 83 ec 28          	sub    $0x28,%rsp
  8004203d1e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t ret = 0;
  8004203d22:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004203d29:	00 
	uint8_t b;
	int shift = 0;
  8004203d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004203d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203d35:	48 8b 00             	mov    (%rax),%rax
  8004203d38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004203d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203d40:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203d44:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004203d48:	0f b6 00             	movzbl (%rax),%eax
  8004203d4b:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004203d4e:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203d52:	83 e0 7f             	and    $0x7f,%eax
  8004203d55:	89 c2                	mov    %eax,%edx
  8004203d57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203d5a:	89 c1                	mov    %eax,%ecx
  8004203d5c:	d3 e2                	shl    %cl,%edx
  8004203d5e:	89 d0                	mov    %edx,%eax
  8004203d60:	48 98                	cltq   
  8004203d62:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004203d66:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004203d6a:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004203d6e:	84 c0                	test   %al,%al
  8004203d70:	78 ca                	js     8004203d3c <_dwarf_decode_uleb128+0x26>

	*dp = src;
  8004203d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203d76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203d7a:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004203d81:	c9                   	leaveq 
  8004203d82:	c3                   	retq   

0000008004203d83 <_dwarf_read_string>:

#define Dwarf_Unsigned uint64_t

char *
_dwarf_read_string(void *data, Dwarf_Unsigned size, uint64_t *offsetp)
{
  8004203d83:	55                   	push   %rbp
  8004203d84:	48 89 e5             	mov    %rsp,%rbp
  8004203d87:	48 83 ec 28          	sub    $0x28,%rsp
  8004203d8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203d8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203d93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *ret, *src;

	ret = src = (char *) data + *offsetp;
  8004203d97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203d9b:	48 8b 10             	mov    (%rax),%rdx
  8004203d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203da2:	48 01 d0             	add    %rdx,%rax
  8004203da5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203dad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (*src != '\0' && *offsetp < size) {
  8004203db1:	eb 17                	jmp    8004203dca <_dwarf_read_string+0x47>
		src++;
  8004203db3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
		(*offsetp)++;
  8004203db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203dbc:	48 8b 00             	mov    (%rax),%rax
  8004203dbf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203dc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203dc7:	48 89 10             	mov    %rdx,(%rax)
{
	char *ret, *src;

	ret = src = (char *) data + *offsetp;

	while (*src != '\0' && *offsetp < size) {
  8004203dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203dce:	0f b6 00             	movzbl (%rax),%eax
  8004203dd1:	84 c0                	test   %al,%al
  8004203dd3:	74 0d                	je     8004203de2 <_dwarf_read_string+0x5f>
  8004203dd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203dd9:	48 8b 00             	mov    (%rax),%rax
  8004203ddc:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203de0:	72 d1                	jb     8004203db3 <_dwarf_read_string+0x30>
		src++;
		(*offsetp)++;
	}

	if (*src == '\0' && *offsetp < size)
  8004203de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203de6:	0f b6 00             	movzbl (%rax),%eax
  8004203de9:	84 c0                	test   %al,%al
  8004203deb:	75 1f                	jne    8004203e0c <_dwarf_read_string+0x89>
  8004203ded:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203df1:	48 8b 00             	mov    (%rax),%rax
  8004203df4:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203df8:	73 12                	jae    8004203e0c <_dwarf_read_string+0x89>
		(*offsetp)++;
  8004203dfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203dfe:	48 8b 00             	mov    (%rax),%rax
  8004203e01:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004203e05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203e09:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203e10:	c9                   	leaveq 
  8004203e11:	c3                   	retq   

0000008004203e12 <_dwarf_read_block>:

uint8_t *
_dwarf_read_block(void *data, uint64_t *offsetp, uint64_t length)
{
  8004203e12:	55                   	push   %rbp
  8004203e13:	48 89 e5             	mov    %rsp,%rbp
  8004203e16:	48 83 ec 28          	sub    $0x28,%rsp
  8004203e1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203e1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004203e22:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	uint8_t *ret, *src;

	ret = src = (uint8_t *) data + *offsetp;
  8004203e26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203e2a:	48 8b 10             	mov    (%rax),%rdx
  8004203e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e31:	48 01 d0             	add    %rdx,%rax
  8004203e34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203e3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	(*offsetp) += length;
  8004203e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203e44:	48 8b 10             	mov    (%rax),%rdx
  8004203e47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203e4b:	48 01 c2             	add    %rax,%rdx
  8004203e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203e52:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004203e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004203e59:	c9                   	leaveq 
  8004203e5a:	c3                   	retq   

0000008004203e5b <_dwarf_elf_get_byte_order>:

Dwarf_Endianness
_dwarf_elf_get_byte_order(void *obj)
{
  8004203e5b:	55                   	push   %rbp
  8004203e5c:	48 89 e5             	mov    %rsp,%rbp
  8004203e5f:	48 83 ec 20          	sub    $0x20,%rsp
  8004203e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *)obj;
  8004203e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004203e6f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203e74:	75 35                	jne    8004203eab <_dwarf_elf_get_byte_order+0x50>
  8004203e76:	48 b9 e0 9f 20 04 80 	movabs $0x8004209fe0,%rcx
  8004203e7d:	00 00 00 
  8004203e80:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004203e87:	00 00 00 
  8004203e8a:	be 29 01 00 00       	mov    $0x129,%esi
  8004203e8f:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004203e96:	00 00 00 
  8004203e99:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203e9e:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004203ea5:	00 00 00 
  8004203ea8:	41 ff d0             	callq  *%r8

//TODO: Need to check for 64bit here. Because currently Elf header for
//      64bit doesn't have any memeber e_ident. But need to see what is
//      similar in 64bit.
	switch (e->e_ident[EI_DATA]) {
  8004203eab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203eaf:	0f b6 40 05          	movzbl 0x5(%rax),%eax
  8004203eb3:	0f b6 c0             	movzbl %al,%eax
  8004203eb6:	83 f8 02             	cmp    $0x2,%eax
  8004203eb9:	75 07                	jne    8004203ec2 <_dwarf_elf_get_byte_order+0x67>
	case ELFDATA2MSB:
		return (DW_OBJECT_MSB);
  8004203ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203ec0:	eb 05                	jmp    8004203ec7 <_dwarf_elf_get_byte_order+0x6c>

	case ELFDATA2LSB:
	case ELFDATANONE:
	default:
		return (DW_OBJECT_LSB);
  8004203ec2:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
  8004203ec7:	c9                   	leaveq 
  8004203ec8:	c3                   	retq   

0000008004203ec9 <_dwarf_elf_get_pointer_size>:

Dwarf_Small
_dwarf_elf_get_pointer_size(void *obj)
{
  8004203ec9:	55                   	push   %rbp
  8004203eca:	48 89 e5             	mov    %rsp,%rbp
  8004203ecd:	48 83 ec 20          	sub    $0x20,%rsp
  8004203ed1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *) obj;
  8004203ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203ed9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004203edd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203ee2:	75 35                	jne    8004203f19 <_dwarf_elf_get_pointer_size+0x50>
  8004203ee4:	48 b9 e0 9f 20 04 80 	movabs $0x8004209fe0,%rcx
  8004203eeb:	00 00 00 
  8004203eee:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004203ef5:	00 00 00 
  8004203ef8:	be 3f 01 00 00       	mov    $0x13f,%esi
  8004203efd:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004203f04:	00 00 00 
  8004203f07:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203f0c:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004203f13:	00 00 00 
  8004203f16:	41 ff d0             	callq  *%r8

	if (e->e_ident[4] == ELFCLASS32)
  8004203f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203f1d:	0f b6 40 04          	movzbl 0x4(%rax),%eax
  8004203f21:	3c 01                	cmp    $0x1,%al
  8004203f23:	75 07                	jne    8004203f2c <_dwarf_elf_get_pointer_size+0x63>
		return (4);
  8004203f25:	b8 04 00 00 00       	mov    $0x4,%eax
  8004203f2a:	eb 05                	jmp    8004203f31 <_dwarf_elf_get_pointer_size+0x68>
	else
		return (8);
  8004203f2c:	b8 08 00 00 00       	mov    $0x8,%eax
}
  8004203f31:	c9                   	leaveq 
  8004203f32:	c3                   	retq   

0000008004203f33 <_dwarf_init>:

//Return 0 on success
int _dwarf_init(Dwarf_Debug dbg, void *obj)
{
  8004203f33:	55                   	push   %rbp
  8004203f34:	48 89 e5             	mov    %rsp,%rbp
  8004203f37:	53                   	push   %rbx
  8004203f38:	48 83 ec 18          	sub    $0x18,%rsp
  8004203f3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004203f40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	memset(dbg, 0, sizeof(struct _Dwarf_Debug));
  8004203f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f48:	ba 60 00 00 00       	mov    $0x60,%edx
  8004203f4d:	be 00 00 00 00       	mov    $0x0,%esi
  8004203f52:	48 89 c7             	mov    %rax,%rdi
  8004203f55:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  8004203f5c:	00 00 00 
  8004203f5f:	ff d0                	callq  *%rax
	dbg->curr_off_dbginfo = 0;
  8004203f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f65:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	dbg->dbg_info_size = 0;
  8004203f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f70:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8004203f77:	00 
	dbg->dbg_pointer_size = _dwarf_elf_get_pointer_size(obj); 
  8004203f78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f7c:	48 89 c7             	mov    %rax,%rdi
  8004203f7f:	48 b8 c9 3e 20 04 80 	movabs $0x8004203ec9,%rax
  8004203f86:	00 00 00 
  8004203f89:	ff d0                	callq  *%rax
  8004203f8b:	0f b6 d0             	movzbl %al,%edx
  8004203f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f92:	89 50 28             	mov    %edx,0x28(%rax)

	if (_dwarf_elf_get_byte_order(obj) == DW_OBJECT_MSB) {
  8004203f95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f99:	48 89 c7             	mov    %rax,%rdi
  8004203f9c:	48 b8 5b 3e 20 04 80 	movabs $0x8004203e5b,%rax
  8004203fa3:	00 00 00 
  8004203fa6:	ff d0                	callq  *%rax
  8004203fa8:	85 c0                	test   %eax,%eax
  8004203faa:	75 26                	jne    8004203fd2 <_dwarf_init+0x9f>
		dbg->read = _dwarf_read_msb;
  8004203fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203fb0:	48 b9 00 38 20 04 80 	movabs $0x8004203800,%rcx
  8004203fb7:	00 00 00 
  8004203fba:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_msb;
  8004203fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203fc2:	48 bb b2 39 20 04 80 	movabs $0x80042039b2,%rbx
  8004203fc9:	00 00 00 
  8004203fcc:	48 89 58 20          	mov    %rbx,0x20(%rax)
  8004203fd0:	eb 24                	jmp    8004203ff6 <_dwarf_init+0xc3>
	} else {
		dbg->read = _dwarf_read_lsb;
  8004203fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203fd6:	48 b9 b3 35 20 04 80 	movabs $0x80042035b3,%rcx
  8004203fdd:	00 00 00 
  8004203fe0:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_lsb;
  8004203fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203fe8:	48 be df 36 20 04 80 	movabs $0x80042036df,%rsi
  8004203fef:	00 00 00 
  8004203ff2:	48 89 70 20          	mov    %rsi,0x20(%rax)
	}
	_dwarf_frame_params_init(dbg);
  8004203ff6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203ffa:	48 89 c7             	mov    %rax,%rdi
  8004203ffd:	48 b8 00 55 20 04 80 	movabs $0x8004205500,%rax
  8004204004:	00 00 00 
  8004204007:	ff d0                	callq  *%rax
	return 0;
  8004204009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420400e:	48 83 c4 18          	add    $0x18,%rsp
  8004204012:	5b                   	pop    %rbx
  8004204013:	5d                   	pop    %rbp
  8004204014:	c3                   	retq   

0000008004204015 <_get_next_cu>:

//Return 0 on success
int _get_next_cu(Dwarf_Debug dbg, Dwarf_CU *cu)
{
  8004204015:	55                   	push   %rbp
  8004204016:	48 89 e5             	mov    %rsp,%rbp
  8004204019:	48 83 ec 20          	sub    $0x20,%rsp
  800420401d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004204021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uint32_t length;
	uint64_t offset;
	uint8_t dwarf_size;

	if(dbg->curr_off_dbginfo > dbg->dbg_info_size)
  8004204025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204029:	48 8b 10             	mov    (%rax),%rdx
  800420402c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204030:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004204034:	48 39 c2             	cmp    %rax,%rdx
  8004204037:	76 0a                	jbe    8004204043 <_get_next_cu+0x2e>
		return -1;
  8004204039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420403e:	e9 6b 01 00 00       	jmpq   80042041ae <_get_next_cu+0x199>

	offset = dbg->curr_off_dbginfo;
  8004204043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204047:	48 8b 00             	mov    (%rax),%rax
  800420404a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	cu->cu_offset = offset;
  800420404e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004204052:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204056:	48 89 50 30          	mov    %rdx,0x30(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset,4);
  800420405a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420405e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204062:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204066:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  800420406a:	48 89 d1             	mov    %rdx,%rcx
  800420406d:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004204071:	ba 04 00 00 00       	mov    $0x4,%edx
  8004204076:	48 89 cf             	mov    %rcx,%rdi
  8004204079:	ff d0                	callq  *%rax
  800420407b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (length == 0xffffffff) {
  800420407e:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  8004204082:	75 2a                	jne    80042040ae <_get_next_cu+0x99>
		length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 8);
  8004204084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204088:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420408c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204090:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004204094:	48 89 d1             	mov    %rdx,%rcx
  8004204097:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  800420409b:	ba 08 00 00 00       	mov    $0x8,%edx
  80042040a0:	48 89 cf             	mov    %rcx,%rdi
  80042040a3:	ff d0                	callq  *%rax
  80042040a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		dwarf_size = 8;
  80042040a8:	c6 45 fb 08          	movb   $0x8,-0x5(%rbp)
  80042040ac:	eb 04                	jmp    80042040b2 <_get_next_cu+0x9d>
	} else {
		dwarf_size = 4;
  80042040ae:	c6 45 fb 04          	movb   $0x4,-0x5(%rbp)
	}

	cu->cu_dwarf_size = dwarf_size;
  80042040b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042040b6:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  80042040ba:	88 50 19             	mov    %dl,0x19(%rax)
	 if (length > ds->ds_size - offset) {
	 return (DW_DLE_CU_LENGTH_ERROR);
	 }*/

	/* Compute the offset to the next compilation unit: */
	dbg->curr_off_dbginfo = offset + length;
  80042040bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042040c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042040c4:	48 01 c2             	add    %rax,%rdx
  80042040c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042040cb:	48 89 10             	mov    %rdx,(%rax)
	cu->cu_next_offset   = dbg->curr_off_dbginfo;
  80042040ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042040d2:	48 8b 10             	mov    (%rax),%rdx
  80042040d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042040d9:	48 89 50 20          	mov    %rdx,0x20(%rax)

	/* Initialise the compilation unit. */
	cu->cu_length = (uint64_t)length;
  80042040dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042040e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042040e4:	48 89 10             	mov    %rdx,(%rax)

	cu->cu_length_size   = (dwarf_size == 4 ? 4 : 12);
  80042040e7:	80 7d fb 04          	cmpb   $0x4,-0x5(%rbp)
  80042040eb:	75 07                	jne    80042040f4 <_get_next_cu+0xdf>
  80042040ed:	b8 04 00 00 00       	mov    $0x4,%eax
  80042040f2:	eb 05                	jmp    80042040f9 <_get_next_cu+0xe4>
  80042040f4:	b8 0c 00 00 00       	mov    $0xc,%eax
  80042040f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042040fd:	88 42 18             	mov    %al,0x18(%rdx)
	cu->version              = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 2);
  8004204100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204104:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204108:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420410c:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004204110:	48 89 d1             	mov    %rdx,%rcx
  8004204113:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004204117:	ba 02 00 00 00       	mov    $0x2,%edx
  800420411c:	48 89 cf             	mov    %rcx,%rdi
  800420411f:	ff d0                	callq  *%rax
  8004204121:	89 c2                	mov    %eax,%edx
  8004204123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204127:	66 89 50 08          	mov    %dx,0x8(%rax)
	cu->debug_abbrev_offset  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, dwarf_size);
  800420412b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420412f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204133:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  8004204137:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420413b:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  800420413f:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004204143:	48 89 cf             	mov    %rcx,%rdi
  8004204146:	ff d0                	callq  *%rax
  8004204148:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420414c:	48 89 42 10          	mov    %rax,0x10(%rdx)
	//cu->cu_abbrev_offset_cur = cu->cu_abbrev_offset;
	cu->addr_size  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 1);
  8004204150:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204154:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204158:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420415c:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004204160:	48 89 d1             	mov    %rdx,%rcx
  8004204163:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004204167:	ba 01 00 00 00       	mov    $0x1,%edx
  800420416c:	48 89 cf             	mov    %rcx,%rdi
  800420416f:	ff d0                	callq  *%rax
  8004204171:	89 c2                	mov    %eax,%edx
  8004204173:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204177:	88 50 0a             	mov    %dl,0xa(%rax)

	if (cu->version < 2 || cu->version > 4) {
  800420417a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420417e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204182:	66 83 f8 01          	cmp    $0x1,%ax
  8004204186:	76 0e                	jbe    8004204196 <_get_next_cu+0x181>
  8004204188:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420418c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204190:	66 83 f8 04          	cmp    $0x4,%ax
  8004204194:	76 07                	jbe    800420419d <_get_next_cu+0x188>
		return -1;
  8004204196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420419b:	eb 11                	jmp    80042041ae <_get_next_cu+0x199>
	}

	cu->cu_die_offset = offset;
  800420419d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042041a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042041a5:	48 89 50 28          	mov    %rdx,0x28(%rax)

	return 0;
  80042041a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042041ae:	c9                   	leaveq 
  80042041af:	c3                   	retq   

00000080042041b0 <print_cu>:

void print_cu(Dwarf_CU cu)
{
  80042041b0:	55                   	push   %rbp
  80042041b1:	48 89 e5             	mov    %rsp,%rbp
	cprintf("%ld---%du--%d\n",cu.cu_length,cu.version,cu.addr_size);
  80042041b4:	0f b6 45 1a          	movzbl 0x1a(%rbp),%eax
  80042041b8:	0f b6 c8             	movzbl %al,%ecx
  80042041bb:	0f b7 45 18          	movzwl 0x18(%rbp),%eax
  80042041bf:	0f b7 d0             	movzwl %ax,%edx
  80042041c2:	48 8b 45 10          	mov    0x10(%rbp),%rax
  80042041c6:	48 89 c6             	mov    %rax,%rsi
  80042041c9:	48 bf 12 a0 20 04 80 	movabs $0x800420a012,%rdi
  80042041d0:	00 00 00 
  80042041d3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042041d8:	49 b8 b6 15 20 04 80 	movabs $0x80042015b6,%r8
  80042041df:	00 00 00 
  80042041e2:	41 ff d0             	callq  *%r8
}
  80042041e5:	5d                   	pop    %rbp
  80042041e6:	c3                   	retq   

00000080042041e7 <_dwarf_abbrev_parse>:

//Return 0 on success
int
_dwarf_abbrev_parse(Dwarf_Debug dbg, Dwarf_CU cu, Dwarf_Unsigned *offset,
		    Dwarf_Abbrev *abp, Dwarf_Section *ds)
{
  80042041e7:	55                   	push   %rbp
  80042041e8:	48 89 e5             	mov    %rsp,%rbp
  80042041eb:	48 83 ec 60          	sub    $0x60,%rsp
  80042041ef:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80042041f3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  80042041f7:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80042041fb:	48 89 4d a0          	mov    %rcx,-0x60(%rbp)
	uint64_t tag;
	uint8_t children;
	uint64_t abbr_addr;
	int ret;

	assert(abp != NULL);
  80042041ff:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8004204204:	75 35                	jne    800420423b <_dwarf_abbrev_parse+0x54>
  8004204206:	48 b9 21 a0 20 04 80 	movabs $0x800420a021,%rcx
  800420420d:	00 00 00 
  8004204210:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204217:	00 00 00 
  800420421a:	be a4 01 00 00       	mov    $0x1a4,%esi
  800420421f:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204226:	00 00 00 
  8004204229:	b8 00 00 00 00       	mov    $0x0,%eax
  800420422e:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204235:	00 00 00 
  8004204238:	41 ff d0             	callq  *%r8
	assert(ds != NULL);
  800420423b:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
  8004204240:	75 35                	jne    8004204277 <_dwarf_abbrev_parse+0x90>
  8004204242:	48 b9 2d a0 20 04 80 	movabs $0x800420a02d,%rcx
  8004204249:	00 00 00 
  800420424c:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204253:	00 00 00 
  8004204256:	be a5 01 00 00       	mov    $0x1a5,%esi
  800420425b:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204262:	00 00 00 
  8004204265:	b8 00 00 00 00       	mov    $0x0,%eax
  800420426a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204271:	00 00 00 
  8004204274:	41 ff d0             	callq  *%r8

	if (*offset >= ds->ds_size)
  8004204277:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420427b:	48 8b 10             	mov    (%rax),%rdx
  800420427e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004204282:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204286:	48 39 c2             	cmp    %rax,%rdx
  8004204289:	72 0a                	jb     8004204295 <_dwarf_abbrev_parse+0xae>
        	return (DW_DLE_NO_ENTRY);
  800420428b:	b8 04 00 00 00       	mov    $0x4,%eax
  8004204290:	e9 d3 01 00 00       	jmpq   8004204468 <_dwarf_abbrev_parse+0x281>

	aboff = *offset;
  8004204295:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004204299:	48 8b 00             	mov    (%rax),%rax
  800420429c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	abbr_addr = (uint64_t)ds->ds_data; //(uint64_t)((uint8_t *)elf_base_ptr + ds->sh_offset);
  80042042a0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042042a4:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042042a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	entry = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042042ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042042b0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80042042b4:	48 89 d6             	mov    %rdx,%rsi
  80042042b7:	48 89 c7             	mov    %rax,%rdi
  80042042ba:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042042c1:	00 00 00 
  80042042c4:	ff d0                	callq  *%rax
  80042042c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	if (entry == 0) {
  80042042ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042042cf:	75 15                	jne    80042042e6 <_dwarf_abbrev_parse+0xff>
		/* Last entry. */
		//Need to make connection from below function
		abp->ab_entry = 0;
  80042042d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042042d5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		return DW_DLE_NONE;
  80042042dc:	b8 00 00 00 00       	mov    $0x0,%eax
  80042042e1:	e9 82 01 00 00       	jmpq   8004204468 <_dwarf_abbrev_parse+0x281>
	}

	tag = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042042e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042042ea:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80042042ee:	48 89 d6             	mov    %rdx,%rsi
  80042042f1:	48 89 c7             	mov    %rax,%rdi
  80042042f4:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042042fb:	00 00 00 
  80042042fe:	ff d0                	callq  *%rax
  8004204300:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	children = dbg->read((uint8_t *)abbr_addr, offset, 1);
  8004204304:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204308:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420430c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004204310:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004204314:	ba 01 00 00 00       	mov    $0x1,%edx
  8004204319:	48 89 cf             	mov    %rcx,%rdi
  800420431c:	ff d0                	callq  *%rax
  800420431e:	88 45 df             	mov    %al,-0x21(%rbp)

	abp->ab_entry    = entry;
  8004204321:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204325:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204329:	48 89 10             	mov    %rdx,(%rax)
	abp->ab_tag      = tag;
  800420432c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204330:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004204334:	48 89 50 08          	mov    %rdx,0x8(%rax)
	abp->ab_children = children;
  8004204338:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420433c:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8004204340:	88 50 10             	mov    %dl,0x10(%rax)
	abp->ab_offset   = aboff;
  8004204343:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420434b:	48 89 50 18          	mov    %rdx,0x18(%rax)
	abp->ab_length   = 0;    /* fill in later. */
  800420434f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204353:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
  800420435a:	00 
	abp->ab_atnum    = 0;
  800420435b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420435f:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  8004204366:	00 

	/* Parse attribute definitions. */
	do {
		adoff = *offset;
  8004204367:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420436b:	48 8b 00             	mov    (%rax),%rax
  800420436e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		attr = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  8004204372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204376:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800420437a:	48 89 d6             	mov    %rdx,%rsi
  800420437d:	48 89 c7             	mov    %rax,%rdi
  8004204380:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  8004204387:	00 00 00 
  800420438a:	ff d0                	callq  *%rax
  800420438c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
		form = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  8004204390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204394:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004204398:	48 89 d6             	mov    %rdx,%rsi
  800420439b:	48 89 c7             	mov    %rax,%rdi
  800420439e:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042043a5:	00 00 00 
  80042043a8:	ff d0                	callq  *%rax
  80042043aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if (attr != 0)
  80042043ae:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042043b3:	0f 84 89 00 00 00    	je     8004204442 <_dwarf_abbrev_parse+0x25b>
		{
			/* Initialise the attribute definition structure. */
			abp->ab_attrdef[abp->ab_atnum].ad_attrib = attr;
  80042043b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042043bd:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042043c1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80042043c5:	48 89 d0             	mov    %rdx,%rax
  80042043c8:	48 01 c0             	add    %rax,%rax
  80042043cb:	48 01 d0             	add    %rdx,%rax
  80042043ce:	48 c1 e0 03          	shl    $0x3,%rax
  80042043d2:	48 01 c8             	add    %rcx,%rax
  80042043d5:	48 8d 50 30          	lea    0x30(%rax),%rdx
  80042043d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042043dd:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_form   = form;
  80042043e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042043e4:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042043e8:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80042043ec:	48 89 d0             	mov    %rdx,%rax
  80042043ef:	48 01 c0             	add    %rax,%rax
  80042043f2:	48 01 d0             	add    %rdx,%rax
  80042043f5:	48 c1 e0 03          	shl    $0x3,%rax
  80042043f9:	48 01 c8             	add    %rcx,%rax
  80042043fc:	48 8d 50 38          	lea    0x38(%rax),%rdx
  8004204400:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204404:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_offset = adoff;
  8004204407:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420440b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420440f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8004204413:	48 89 d0             	mov    %rdx,%rax
  8004204416:	48 01 c0             	add    %rax,%rax
  8004204419:	48 01 d0             	add    %rdx,%rax
  800420441c:	48 c1 e0 03          	shl    $0x3,%rax
  8004204420:	48 01 c8             	add    %rcx,%rax
  8004204423:	48 8d 50 40          	lea    0x40(%rax),%rdx
  8004204427:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420442b:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_atnum++;
  800420442e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004204432:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004204436:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420443a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420443e:	48 89 50 28          	mov    %rdx,0x28(%rax)
		}
	} while (attr != 0);
  8004204442:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004204447:	0f 85 1a ff ff ff    	jne    8004204367 <_dwarf_abbrev_parse+0x180>

	//(*abp)->ab_length = *offset - aboff;
	abp->ab_length = (uint64_t)(*offset - aboff);
  800420444d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004204451:	48 8b 00             	mov    (%rax),%rax
  8004204454:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
  8004204458:	48 89 c2             	mov    %rax,%rdx
  800420445b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420445f:	48 89 50 20          	mov    %rdx,0x20(%rax)

	return DW_DLV_OK;
  8004204463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004204468:	c9                   	leaveq 
  8004204469:	c3                   	retq   

000000800420446a <_dwarf_abbrev_find>:

//Return 0 on success
int
_dwarf_abbrev_find(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t entry, Dwarf_Abbrev *abp)
{
  800420446a:	55                   	push   %rbp
  800420446b:	48 89 e5             	mov    %rsp,%rbp
  800420446e:	48 83 ec 70          	sub    $0x70,%rsp
  8004204472:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004204476:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420447a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	Dwarf_Section *ds;
	uint64_t offset;
	int ret;

	if (entry == 0)
  800420447e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004204483:	75 0a                	jne    800420448f <_dwarf_abbrev_find+0x25>
	{
		return (DW_DLE_NO_ENTRY);
  8004204485:	b8 04 00 00 00       	mov    $0x4,%eax
  800420448a:	e9 0a 01 00 00       	jmpq   8004204599 <_dwarf_abbrev_find+0x12f>
	}

	/* Load and search the abbrev table. */
	ds = _dwarf_find_section(".debug_abbrev");
  800420448f:	48 bf 38 a0 20 04 80 	movabs $0x800420a038,%rdi
  8004204496:	00 00 00 
  8004204499:	48 b8 ca 87 20 04 80 	movabs $0x80042087ca,%rax
  80042044a0:	00 00 00 
  80042044a3:	ff d0                	callq  *%rax
  80042044a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(ds != NULL);
  80042044a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042044ae:	75 35                	jne    80042044e5 <_dwarf_abbrev_find+0x7b>
  80042044b0:	48 b9 2d a0 20 04 80 	movabs $0x800420a02d,%rcx
  80042044b7:	00 00 00 
  80042044ba:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  80042044c1:	00 00 00 
  80042044c4:	be e5 01 00 00       	mov    $0x1e5,%esi
  80042044c9:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  80042044d0:	00 00 00 
  80042044d3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042044d8:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042044df:	00 00 00 
  80042044e2:	41 ff d0             	callq  *%r8

	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
  80042044e5:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042044e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (offset < ds->ds_size) {
  80042044ed:	e9 8d 00 00 00       	jmpq   800420457f <_dwarf_abbrev_find+0x115>
		ret = _dwarf_abbrev_parse(dbg, cu, &offset, abp, ds);
  80042044f2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80042044f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042044fa:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80042044fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004204502:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8004204506:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420450a:	48 8b 7d 18          	mov    0x18(%rbp),%rdi
  800420450e:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004204513:	48 8b 7d 20          	mov    0x20(%rbp),%rdi
  8004204517:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420451c:	48 8b 7d 28          	mov    0x28(%rbp),%rdi
  8004204520:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004204525:	48 8b 7d 30          	mov    0x30(%rbp),%rdi
  8004204529:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  800420452e:	48 8b 7d 38          	mov    0x38(%rbp),%rdi
  8004204532:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004204537:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  800420453b:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  8004204540:	48 89 c7             	mov    %rax,%rdi
  8004204543:	48 b8 e7 41 20 04 80 	movabs $0x80042041e7,%rax
  800420454a:	00 00 00 
  800420454d:	ff d0                	callq  *%rax
  800420454f:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (ret != DW_DLE_NONE)
  8004204552:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004204556:	74 05                	je     800420455d <_dwarf_abbrev_find+0xf3>
			return (ret);
  8004204558:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420455b:	eb 3c                	jmp    8004204599 <_dwarf_abbrev_find+0x12f>
		if (abp->ab_entry == entry) {
  800420455d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204561:	48 8b 00             	mov    (%rax),%rax
  8004204564:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004204568:	75 07                	jne    8004204571 <_dwarf_abbrev_find+0x107>
			//cu->cu_abbrev_offset_cur = offset;
			return DW_DLE_NONE;
  800420456a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420456f:	eb 28                	jmp    8004204599 <_dwarf_abbrev_find+0x12f>
		}
		if (abp->ab_entry == 0) {
  8004204571:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204575:	48 8b 00             	mov    (%rax),%rax
  8004204578:	48 85 c0             	test   %rax,%rax
  800420457b:	75 02                	jne    800420457f <_dwarf_abbrev_find+0x115>
			//cu->cu_abbrev_offset_cur = offset;
			//cu->cu_abbrev_loaded = 1;
			break;
  800420457d:	eb 15                	jmp    8004204594 <_dwarf_abbrev_find+0x12a>
	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
	while (offset < ds->ds_size) {
  800420457f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004204583:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004204587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420458b:	48 39 c2             	cmp    %rax,%rdx
  800420458e:	0f 87 5e ff ff ff    	ja     80042044f2 <_dwarf_abbrev_find+0x88>
			//cu->cu_abbrev_loaded = 1;
			break;
		}
	}

	return DW_DLE_NO_ENTRY;
  8004204594:	b8 04 00 00 00       	mov    $0x4,%eax
}
  8004204599:	c9                   	leaveq 
  800420459a:	c3                   	retq   

000000800420459b <_dwarf_attr_init>:

//Return 0 on success
int
_dwarf_attr_init(Dwarf_Debug dbg, uint64_t *offsetp, Dwarf_CU *cu, Dwarf_Die *ret_die, Dwarf_AttrDef *ad,
		 uint64_t form, int indirect)
{
  800420459b:	55                   	push   %rbp
  800420459c:	48 89 e5             	mov    %rsp,%rbp
  800420459f:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80042045a6:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80042045ad:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80042045b4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  80042045bb:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
  80042045c2:	4c 89 85 48 ff ff ff 	mov    %r8,-0xb8(%rbp)
  80042045c9:	4c 89 8d 40 ff ff ff 	mov    %r9,-0xc0(%rbp)
	struct _Dwarf_Attribute atref;
	Dwarf_Section *str;
	int ret;
	Dwarf_Section *ds = _dwarf_find_section(".debug_info");
  80042045d0:	48 bf 46 a0 20 04 80 	movabs $0x800420a046,%rdi
  80042045d7:	00 00 00 
  80042045da:	48 b8 ca 87 20 04 80 	movabs $0x80042087ca,%rax
  80042045e1:	00 00 00 
  80042045e4:	ff d0                	callq  *%rax
  80042045e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	uint8_t *ds_data = (uint8_t *)ds->ds_data; //(uint8_t *)dbg->dbg_info_offset_elf;
  80042045ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042045ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042045f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint8_t dwarf_size = cu->cu_dwarf_size;
  80042045f6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80042045fd:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004204601:	88 45 e7             	mov    %al,-0x19(%rbp)

	ret = DW_DLE_NONE;
  8004204604:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	memset(&atref, 0, sizeof(atref));
  800420460b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8004204612:	ba 60 00 00 00       	mov    $0x60,%edx
  8004204617:	be 00 00 00 00       	mov    $0x0,%esi
  800420461c:	48 89 c7             	mov    %rax,%rdi
  800420461f:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  8004204626:	00 00 00 
  8004204629:	ff d0                	callq  *%rax
	atref.at_die = ret_die;
  800420462b:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004204632:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
	atref.at_attrib = ad->ad_attrib;
  8004204639:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004204640:	48 8b 00             	mov    (%rax),%rax
  8004204643:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	atref.at_form = ad->ad_form;
  8004204647:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  800420464e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004204652:	48 89 45 88          	mov    %rax,-0x78(%rbp)
	atref.at_indirect = indirect;
  8004204656:	8b 45 10             	mov    0x10(%rbp),%eax
  8004204659:	89 45 90             	mov    %eax,-0x70(%rbp)
	atref.at_ld = NULL;
  800420465c:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8004204663:	00 

	switch (form) {
  8004204664:	48 83 bd 40 ff ff ff 	cmpq   $0x20,-0xc0(%rbp)
  800420466b:	20 
  800420466c:	0f 87 82 04 00 00    	ja     8004204af4 <_dwarf_attr_init+0x559>
  8004204672:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8004204679:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004204680:	00 
  8004204681:	48 b8 70 a0 20 04 80 	movabs $0x800420a070,%rax
  8004204688:	00 00 00 
  800420468b:	48 01 d0             	add    %rdx,%rax
  800420468e:	48 8b 00             	mov    (%rax),%rax
  8004204691:	ff e0                	jmpq   *%rax
	case DW_FORM_addr:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  8004204693:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420469a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420469e:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80042046a5:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  80042046a9:	0f b6 d2             	movzbl %dl,%edx
  80042046ac:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042046b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042046b7:	48 89 cf             	mov    %rcx,%rdi
  80042046ba:	ff d0                	callq  *%rax
  80042046bc:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042046c0:	e9 37 04 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_block:
	case DW_FORM_exprloc:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  80042046c5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042046cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042046d0:	48 89 d6             	mov    %rdx,%rsi
  80042046d3:	48 89 c7             	mov    %rax,%rdi
  80042046d6:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042046dd:	00 00 00 
  80042046e0:	ff d0                	callq  *%rax
  80042046e2:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  80042046e6:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042046ea:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  80042046f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042046f5:	48 89 ce             	mov    %rcx,%rsi
  80042046f8:	48 89 c7             	mov    %rax,%rdi
  80042046fb:	48 b8 12 3e 20 04 80 	movabs $0x8004203e12,%rax
  8004204702:	00 00 00 
  8004204705:	ff d0                	callq  *%rax
  8004204707:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420470b:	e9 ec 03 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_block1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  8004204710:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204717:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420471b:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204722:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204726:	ba 01 00 00 00       	mov    $0x1,%edx
  800420472b:	48 89 cf             	mov    %rcx,%rdi
  800420472e:	ff d0                	callq  *%rax
  8004204730:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004204734:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204738:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  800420473f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204743:	48 89 ce             	mov    %rcx,%rsi
  8004204746:	48 89 c7             	mov    %rax,%rdi
  8004204749:	48 b8 12 3e 20 04 80 	movabs $0x8004203e12,%rax
  8004204750:	00 00 00 
  8004204753:	ff d0                	callq  *%rax
  8004204755:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  8004204759:	e9 9e 03 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_block2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  800420475e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204765:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204769:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204770:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204774:	ba 02 00 00 00       	mov    $0x2,%edx
  8004204779:	48 89 cf             	mov    %rcx,%rdi
  800420477c:	ff d0                	callq  *%rax
  800420477e:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004204782:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204786:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  800420478d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204791:	48 89 ce             	mov    %rcx,%rsi
  8004204794:	48 89 c7             	mov    %rax,%rdi
  8004204797:	48 b8 12 3e 20 04 80 	movabs $0x8004203e12,%rax
  800420479e:	00 00 00 
  80042047a1:	ff d0                	callq  *%rax
  80042047a3:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042047a7:	e9 50 03 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_block4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  80042047ac:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042047b3:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042047b7:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042047be:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042047c2:	ba 04 00 00 00       	mov    $0x4,%edx
  80042047c7:	48 89 cf             	mov    %rcx,%rdi
  80042047ca:	ff d0                	callq  *%rax
  80042047cc:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  80042047d0:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042047d4:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  80042047db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042047df:	48 89 ce             	mov    %rcx,%rsi
  80042047e2:	48 89 c7             	mov    %rax,%rdi
  80042047e5:	48 b8 12 3e 20 04 80 	movabs $0x8004203e12,%rax
  80042047ec:	00 00 00 
  80042047ef:	ff d0                	callq  *%rax
  80042047f1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042047f5:	e9 02 03 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_data1:
	case DW_FORM_flag:
	case DW_FORM_ref1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  80042047fa:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204801:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204805:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800420480c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204810:	ba 01 00 00 00       	mov    $0x1,%edx
  8004204815:	48 89 cf             	mov    %rcx,%rdi
  8004204818:	ff d0                	callq  *%rax
  800420481a:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420481e:	e9 d9 02 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_data2:
	case DW_FORM_ref2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  8004204823:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420482a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420482e:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204835:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204839:	ba 02 00 00 00       	mov    $0x2,%edx
  800420483e:	48 89 cf             	mov    %rcx,%rdi
  8004204841:	ff d0                	callq  *%rax
  8004204843:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204847:	e9 b0 02 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_data4:
	case DW_FORM_ref4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  800420484c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204853:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204857:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800420485e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204862:	ba 04 00 00 00       	mov    $0x4,%edx
  8004204867:	48 89 cf             	mov    %rcx,%rdi
  800420486a:	ff d0                	callq  *%rax
  800420486c:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204870:	e9 87 02 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_data8:
	case DW_FORM_ref8:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 8);
  8004204875:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420487c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204880:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204887:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420488b:	ba 08 00 00 00       	mov    $0x8,%edx
  8004204890:	48 89 cf             	mov    %rcx,%rdi
  8004204893:	ff d0                	callq  *%rax
  8004204895:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204899:	e9 5e 02 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_indirect:
		form = _dwarf_read_uleb128(ds_data, offsetp);
  800420489e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042048a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042048a9:	48 89 d6             	mov    %rdx,%rsi
  80042048ac:	48 89 c7             	mov    %rax,%rdi
  80042048af:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042048b6:	00 00 00 
  80042048b9:	ff d0                	callq  *%rax
  80042048bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
		return (_dwarf_attr_init(dbg, offsetp, cu, ret_die, ad, form, 1));
  80042048c2:	4c 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%r8
  80042048c9:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  80042048d0:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  80042048d7:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80042048de:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042048e5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042048ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  80042048f3:	4d 89 c1             	mov    %r8,%r9
  80042048f6:	49 89 f8             	mov    %rdi,%r8
  80042048f9:	48 89 c7             	mov    %rax,%rdi
  80042048fc:	48 b8 9b 45 20 04 80 	movabs $0x800420459b,%rax
  8004204903:	00 00 00 
  8004204906:	ff d0                	callq  *%rax
  8004204908:	e9 1d 03 00 00       	jmpq   8004204c2a <_dwarf_attr_init+0x68f>
	case DW_FORM_ref_addr:
		if (cu->version == 2)
  800420490d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004204914:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204918:	66 83 f8 02          	cmp    $0x2,%ax
  800420491c:	75 2f                	jne    800420494d <_dwarf_attr_init+0x3b2>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  800420491e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204925:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204929:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8004204930:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  8004204934:	0f b6 d2             	movzbl %dl,%edx
  8004204937:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800420493e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204942:	48 89 cf             	mov    %rcx,%rdi
  8004204945:	ff d0                	callq  *%rax
  8004204947:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  800420494b:	eb 39                	jmp    8004204986 <_dwarf_attr_init+0x3eb>
		else if (cu->version == 3)
  800420494d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004204954:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204958:	66 83 f8 03          	cmp    $0x3,%ax
  800420495c:	75 28                	jne    8004204986 <_dwarf_attr_init+0x3eb>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  800420495e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204965:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204969:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  800420496d:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204974:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204978:	48 89 cf             	mov    %rcx,%rdi
  800420497b:	ff d0                	callq  *%rax
  800420497d:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204981:	e9 76 01 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
  8004204986:	e9 71 01 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_ref_udata:
	case DW_FORM_udata:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  800420498b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004204992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204996:	48 89 d6             	mov    %rdx,%rsi
  8004204999:	48 89 c7             	mov    %rax,%rdi
  800420499c:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042049a3:	00 00 00 
  80042049a6:	ff d0                	callq  *%rax
  80042049a8:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042049ac:	e9 4b 01 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_sdata:
		atref.u[0].s64 = _dwarf_read_sleb128(ds_data, offsetp);
  80042049b1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042049b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042049bc:	48 89 d6             	mov    %rdx,%rsi
  80042049bf:	48 89 c7             	mov    %rax,%rdi
  80042049c2:	48 b8 61 3b 20 04 80 	movabs $0x8004203b61,%rax
  80042049c9:	00 00 00 
  80042049cc:	ff d0                	callq  *%rax
  80042049ce:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042049d2:	e9 25 01 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_sec_offset:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  80042049d7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042049de:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042049e2:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  80042049e6:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042049ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042049f1:	48 89 cf             	mov    %rcx,%rdi
  80042049f4:	ff d0                	callq  *%rax
  80042049f6:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042049fa:	e9 fd 00 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_string:
		atref.u[0].s =(char*) _dwarf_read_string(ds_data, (uint64_t)ds->ds_size, offsetp);
  80042049ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004204a03:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8004204a07:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004204a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204a12:	48 89 ce             	mov    %rcx,%rsi
  8004204a15:	48 89 c7             	mov    %rax,%rdi
  8004204a18:	48 b8 83 3d 20 04 80 	movabs $0x8004203d83,%rax
  8004204a1f:	00 00 00 
  8004204a22:	ff d0                	callq  *%rax
  8004204a24:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004204a28:	e9 cf 00 00 00       	jmpq   8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_strp:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  8004204a2d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004204a34:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004204a38:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  8004204a3c:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004204a43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204a47:	48 89 cf             	mov    %rcx,%rdi
  8004204a4a:	ff d0                	callq  *%rax
  8004204a4c:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		str = _dwarf_find_section(".debug_str");
  8004204a50:	48 bf 52 a0 20 04 80 	movabs $0x800420a052,%rdi
  8004204a57:	00 00 00 
  8004204a5a:	48 b8 ca 87 20 04 80 	movabs $0x80042087ca,%rax
  8004204a61:	00 00 00 
  8004204a64:	ff d0                	callq  *%rax
  8004204a66:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		assert(str != NULL);
  8004204a6a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004204a6f:	75 35                	jne    8004204aa6 <_dwarf_attr_init+0x50b>
  8004204a71:	48 b9 5d a0 20 04 80 	movabs $0x800420a05d,%rcx
  8004204a78:	00 00 00 
  8004204a7b:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204a82:	00 00 00 
  8004204a85:	be 51 02 00 00       	mov    $0x251,%esi
  8004204a8a:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204a91:	00 00 00 
  8004204a94:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204a99:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204aa0:	00 00 00 
  8004204aa3:	41 ff d0             	callq  *%r8
		//atref.u[1].s = (char *)(elf_base_ptr + str->sh_offset) + atref.u[0].u64;
		atref.u[1].s = (char *)str->ds_data + atref.u[0].u64;
  8004204aa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004204aaa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004204aae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004204ab2:	48 01 d0             	add    %rdx,%rax
  8004204ab5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  8004204ab9:	eb 41                	jmp    8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_ref_sig8:
		atref.u[0].u64 = 8;
  8004204abb:	48 c7 45 98 08 00 00 	movq   $0x8,-0x68(%rbp)
  8004204ac2:	00 
		atref.u[1].u8p = (uint8_t*)(_dwarf_read_block(ds_data, offsetp, atref.u[0].u64));
  8004204ac3:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204ac7:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004204ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204ad2:	48 89 ce             	mov    %rcx,%rsi
  8004204ad5:	48 89 c7             	mov    %rax,%rdi
  8004204ad8:	48 b8 12 3e 20 04 80 	movabs $0x8004203e12,%rax
  8004204adf:	00 00 00 
  8004204ae2:	ff d0                	callq  *%rax
  8004204ae4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  8004204ae8:	eb 12                	jmp    8004204afc <_dwarf_attr_init+0x561>
	case DW_FORM_flag_present:
		/* This form has no value encoded in the DIE. */
		atref.u[0].u64 = 1;
  8004204aea:	48 c7 45 98 01 00 00 	movq   $0x1,-0x68(%rbp)
  8004204af1:	00 
		break;
  8004204af2:	eb 08                	jmp    8004204afc <_dwarf_attr_init+0x561>
	default:
		//DWARF_SET_ERROR(dbg, error, DW_DLE_ATTR_FORM_BAD);
		ret = DW_DLE_ATTR_FORM_BAD;
  8004204af4:	c7 45 fc 0e 00 00 00 	movl   $0xe,-0x4(%rbp)
		break;
  8004204afb:	90                   	nop
	}

	if (ret == DW_DLE_NONE) {
  8004204afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204b00:	0f 85 21 01 00 00    	jne    8004204c27 <_dwarf_attr_init+0x68c>
		if (form == DW_FORM_block || form == DW_FORM_block1 ||
  8004204b06:	48 83 bd 40 ff ff ff 	cmpq   $0x9,-0xc0(%rbp)
  8004204b0d:	09 
  8004204b0e:	74 1e                	je     8004204b2e <_dwarf_attr_init+0x593>
  8004204b10:	48 83 bd 40 ff ff ff 	cmpq   $0xa,-0xc0(%rbp)
  8004204b17:	0a 
  8004204b18:	74 14                	je     8004204b2e <_dwarf_attr_init+0x593>
  8004204b1a:	48 83 bd 40 ff ff ff 	cmpq   $0x3,-0xc0(%rbp)
  8004204b21:	03 
  8004204b22:	74 0a                	je     8004204b2e <_dwarf_attr_init+0x593>
		    form == DW_FORM_block2 || form == DW_FORM_block4) {
  8004204b24:	48 83 bd 40 ff ff ff 	cmpq   $0x4,-0xc0(%rbp)
  8004204b2b:	04 
  8004204b2c:	75 10                	jne    8004204b3e <_dwarf_attr_init+0x5a3>
			atref.at_block.bl_len = atref.u[0].u64;
  8004204b2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004204b32:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			atref.at_block.bl_data = atref.u[1].u8p;
  8004204b36:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004204b3a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
  8004204b3e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004204b42:	48 83 f8 03          	cmp    $0x3,%rax
  8004204b46:	75 39                	jne    8004204b81 <_dwarf_attr_init+0x5e6>
			switch (atref.at_form) {
  8004204b48:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004204b4c:	48 83 f8 08          	cmp    $0x8,%rax
  8004204b50:	74 1c                	je     8004204b6e <_dwarf_attr_init+0x5d3>
  8004204b52:	48 83 f8 0e          	cmp    $0xe,%rax
  8004204b56:	74 02                	je     8004204b5a <_dwarf_attr_init+0x5bf>
				break;
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
				break;
			default:
				break;
  8004204b58:	eb 27                	jmp    8004204b81 <_dwarf_attr_init+0x5e6>
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
			switch (atref.at_form) {
			case DW_FORM_strp:
				ret_die->die_name = atref.u[1].s;
  8004204b5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004204b5e:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004204b65:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  8004204b6c:	eb 13                	jmp    8004204b81 <_dwarf_attr_init+0x5e6>
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
  8004204b6e:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204b72:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004204b79:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  8004204b80:	90                   	nop
			default:
				break;
			}
		}
		ret_die->die_attr[ret_die->die_attr_count++] = atref;
  8004204b81:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004204b88:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  8004204b8f:	8d 48 01             	lea    0x1(%rax),%ecx
  8004204b92:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8004204b99:	88 8a 58 03 00 00    	mov    %cl,0x358(%rdx)
  8004204b9f:	0f b6 c0             	movzbl %al,%eax
  8004204ba2:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  8004204ba9:	48 63 d0             	movslq %eax,%rdx
  8004204bac:	48 89 d0             	mov    %rdx,%rax
  8004204baf:	48 01 c0             	add    %rax,%rax
  8004204bb2:	48 01 d0             	add    %rdx,%rax
  8004204bb5:	48 c1 e0 05          	shl    $0x5,%rax
  8004204bb9:	48 01 c8             	add    %rcx,%rax
  8004204bbc:	48 05 70 03 00 00    	add    $0x370,%rax
  8004204bc2:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  8004204bc9:	48 89 10             	mov    %rdx,(%rax)
  8004204bcc:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004204bd3:	48 89 50 08          	mov    %rdx,0x8(%rax)
  8004204bd7:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004204bdb:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004204bdf:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  8004204be3:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004204be7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004204beb:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004204bef:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004204bf3:	48 89 50 28          	mov    %rdx,0x28(%rax)
  8004204bf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004204bfb:	48 89 50 30          	mov    %rdx,0x30(%rax)
  8004204bff:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004204c03:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004204c07:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004204c0b:	48 89 50 40          	mov    %rdx,0x40(%rax)
  8004204c0f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004204c13:	48 89 50 48          	mov    %rdx,0x48(%rax)
  8004204c17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004204c1b:	48 89 50 50          	mov    %rdx,0x50(%rax)
  8004204c1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004204c23:	48 89 50 58          	mov    %rdx,0x58(%rax)
	}

	return (ret);
  8004204c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004204c2a:	c9                   	leaveq 
  8004204c2b:	c3                   	retq   

0000008004204c2c <dwarf_search_die_within_cu>:

int
dwarf_search_die_within_cu(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t offset, Dwarf_Die *ret_die, int search_sibling)
{
  8004204c2c:	55                   	push   %rbp
  8004204c2d:	48 89 e5             	mov    %rsp,%rbp
  8004204c30:	48 81 ec d0 03 00 00 	sub    $0x3d0,%rsp
  8004204c37:	48 89 bd 88 fc ff ff 	mov    %rdi,-0x378(%rbp)
  8004204c3e:	48 89 b5 80 fc ff ff 	mov    %rsi,-0x380(%rbp)
  8004204c45:	48 89 95 78 fc ff ff 	mov    %rdx,-0x388(%rbp)
  8004204c4c:	89 8d 74 fc ff ff    	mov    %ecx,-0x38c(%rbp)
	uint64_t abnum;
	uint64_t die_offset;
	int ret, level;
	int i;

	assert(dbg);
  8004204c52:	48 83 bd 88 fc ff ff 	cmpq   $0x0,-0x378(%rbp)
  8004204c59:	00 
  8004204c5a:	75 35                	jne    8004204c91 <dwarf_search_die_within_cu+0x65>
  8004204c5c:	48 b9 78 a1 20 04 80 	movabs $0x800420a178,%rcx
  8004204c63:	00 00 00 
  8004204c66:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204c6d:	00 00 00 
  8004204c70:	be 86 02 00 00       	mov    $0x286,%esi
  8004204c75:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204c7c:	00 00 00 
  8004204c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204c84:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204c8b:	00 00 00 
  8004204c8e:	41 ff d0             	callq  *%r8
	//assert(cu);
	assert(ret_die);
  8004204c91:	48 83 bd 78 fc ff ff 	cmpq   $0x0,-0x388(%rbp)
  8004204c98:	00 
  8004204c99:	75 35                	jne    8004204cd0 <dwarf_search_die_within_cu+0xa4>
  8004204c9b:	48 b9 7c a1 20 04 80 	movabs $0x800420a17c,%rcx
  8004204ca2:	00 00 00 
  8004204ca5:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204cac:	00 00 00 
  8004204caf:	be 88 02 00 00       	mov    $0x288,%esi
  8004204cb4:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204cbb:	00 00 00 
  8004204cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204cc3:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204cca:	00 00 00 
  8004204ccd:	41 ff d0             	callq  *%r8

	level = 1;
  8004204cd0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004204cd7:	e9 17 02 00 00       	jmpq   8004204ef3 <dwarf_search_die_within_cu+0x2c7>

		die_offset = offset;
  8004204cdc:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204ce3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		abnum = _dwarf_read_uleb128((uint8_t *)dbg->dbg_info_offset_elf, &offset);
  8004204ce7:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204cee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004204cf2:	48 8d 95 80 fc ff ff 	lea    -0x380(%rbp),%rdx
  8004204cf9:	48 89 d6             	mov    %rdx,%rsi
  8004204cfc:	48 89 c7             	mov    %rax,%rdi
  8004204cff:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  8004204d06:	00 00 00 
  8004204d09:	ff d0                	callq  *%rax
  8004204d0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

		if (abnum == 0) {
  8004204d0f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004204d14:	75 22                	jne    8004204d38 <dwarf_search_die_within_cu+0x10c>
			if (level == 0 || !search_sibling) {
  8004204d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204d1a:	74 09                	je     8004204d25 <dwarf_search_die_within_cu+0xf9>
  8004204d1c:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004204d23:	75 0a                	jne    8004204d2f <dwarf_search_die_within_cu+0x103>
				//No more entry
				return (DW_DLE_NO_ENTRY);
  8004204d25:	b8 04 00 00 00       	mov    $0x4,%eax
  8004204d2a:	e9 f4 01 00 00       	jmpq   8004204f23 <dwarf_search_die_within_cu+0x2f7>
			}
			/*
			 * Return to previous DIE level.
			 */
			level--;
  8004204d2f:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
			continue;
  8004204d33:	e9 bb 01 00 00       	jmpq   8004204ef3 <dwarf_search_die_within_cu+0x2c7>
		}

		if ((ret = _dwarf_abbrev_find(dbg, cu, abnum, &ab)) != DW_DLE_NONE)
  8004204d38:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004204d3f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004204d43:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204d4a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8004204d4e:	48 89 34 24          	mov    %rsi,(%rsp)
  8004204d52:	48 8b 75 18          	mov    0x18(%rbp),%rsi
  8004204d56:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8004204d5b:	48 8b 75 20          	mov    0x20(%rbp),%rsi
  8004204d5f:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8004204d64:	48 8b 75 28          	mov    0x28(%rbp),%rsi
  8004204d68:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  8004204d6d:	48 8b 75 30          	mov    0x30(%rbp),%rsi
  8004204d71:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8004204d76:	48 8b 75 38          	mov    0x38(%rbp),%rsi
  8004204d7a:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  8004204d7f:	48 8b 75 40          	mov    0x40(%rbp),%rsi
  8004204d83:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8004204d88:	48 89 ce             	mov    %rcx,%rsi
  8004204d8b:	48 89 c7             	mov    %rax,%rdi
  8004204d8e:	48 b8 6a 44 20 04 80 	movabs $0x800420446a,%rax
  8004204d95:	00 00 00 
  8004204d98:	ff d0                	callq  *%rax
  8004204d9a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004204d9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004204da1:	74 08                	je     8004204dab <dwarf_search_die_within_cu+0x17f>
			return (ret);
  8004204da3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004204da6:	e9 78 01 00 00       	jmpq   8004204f23 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_offset = die_offset;
  8004204dab:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204db2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004204db6:	48 89 10             	mov    %rdx,(%rax)
		ret_die->die_abnum  = abnum;
  8004204db9:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204dc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204dc4:	48 89 50 10          	mov    %rdx,0x10(%rax)
		ret_die->die_ab  = ab;
  8004204dc8:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204dcf:	48 8d 78 20          	lea    0x20(%rax),%rdi
  8004204dd3:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004204dda:	b8 66 00 00 00       	mov    $0x66,%eax
  8004204ddf:	48 89 d6             	mov    %rdx,%rsi
  8004204de2:	48 89 c1             	mov    %rax,%rcx
  8004204de5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
		ret_die->die_attr_count = 0;
  8004204de8:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204def:	c6 80 58 03 00 00 00 	movb   $0x0,0x358(%rax)
		ret_die->die_tag = ab.ab_tag;
  8004204df6:	48 8b 95 b8 fc ff ff 	mov    -0x348(%rbp),%rdx
  8004204dfd:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204e04:	48 89 50 18          	mov    %rdx,0x18(%rax)
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004204e08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004204e0f:	e9 8e 00 00 00       	jmpq   8004204ea2 <dwarf_search_die_within_cu+0x276>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
  8004204e14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204e17:	48 63 d0             	movslq %eax,%rdx
  8004204e1a:	48 89 d0             	mov    %rdx,%rax
  8004204e1d:	48 01 c0             	add    %rax,%rax
  8004204e20:	48 01 d0             	add    %rdx,%rax
  8004204e23:	48 c1 e0 03          	shl    $0x3,%rax
  8004204e27:	48 01 e8             	add    %rbp,%rax
  8004204e2a:	48 2d 18 03 00 00    	sub    $0x318,%rax
  8004204e30:	48 8b 08             	mov    (%rax),%rcx
  8004204e33:	48 8d b5 b0 fc ff ff 	lea    -0x350(%rbp),%rsi
  8004204e3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204e3d:	48 63 d0             	movslq %eax,%rdx
  8004204e40:	48 89 d0             	mov    %rdx,%rax
  8004204e43:	48 01 c0             	add    %rax,%rax
  8004204e46:	48 01 d0             	add    %rdx,%rax
  8004204e49:	48 c1 e0 03          	shl    $0x3,%rax
  8004204e4d:	48 83 c0 30          	add    $0x30,%rax
  8004204e51:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8004204e55:	48 8b 95 78 fc ff ff 	mov    -0x388(%rbp),%rdx
  8004204e5c:	48 8d b5 80 fc ff ff 	lea    -0x380(%rbp),%rsi
  8004204e63:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  8004204e71:	49 89 c9             	mov    %rcx,%r9
  8004204e74:	49 89 f8             	mov    %rdi,%r8
  8004204e77:	48 89 d1             	mov    %rdx,%rcx
  8004204e7a:	48 8d 55 10          	lea    0x10(%rbp),%rdx
  8004204e7e:	48 89 c7             	mov    %rax,%rdi
  8004204e81:	48 b8 9b 45 20 04 80 	movabs $0x800420459b,%rax
  8004204e88:	00 00 00 
  8004204e8b:	ff d0                	callq  *%rax
  8004204e8d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004204e90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004204e94:	74 08                	je     8004204e9e <dwarf_search_die_within_cu+0x272>
				return (ret);
  8004204e96:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004204e99:	e9 85 00 00 00       	jmpq   8004204f23 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_attr_count = 0;
		ret_die->die_tag = ab.ab_tag;
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004204e9e:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8004204ea2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004204ea5:	48 63 d0             	movslq %eax,%rdx
  8004204ea8:	48 8b 85 d8 fc ff ff 	mov    -0x328(%rbp),%rax
  8004204eaf:	48 39 c2             	cmp    %rax,%rdx
  8004204eb2:	0f 82 5c ff ff ff    	jb     8004204e14 <dwarf_search_die_within_cu+0x1e8>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
				return (ret);
		}

		ret_die->die_next_off = offset;
  8004204eb8:	48 8b 95 80 fc ff ff 	mov    -0x380(%rbp),%rdx
  8004204ebf:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004204ec6:	48 89 50 08          	mov    %rdx,0x8(%rax)
		if (search_sibling && level > 0) {
  8004204eca:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004204ed1:	74 19                	je     8004204eec <dwarf_search_die_within_cu+0x2c0>
  8004204ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004204ed7:	7e 13                	jle    8004204eec <dwarf_search_die_within_cu+0x2c0>
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004204ed9:	0f b6 85 c0 fc ff ff 	movzbl -0x340(%rbp),%eax
  8004204ee0:	3c 01                	cmp    $0x1,%al
  8004204ee2:	75 06                	jne    8004204eea <dwarf_search_die_within_cu+0x2be>
				/* Advance to next DIE level. */
				level++;
  8004204ee4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		}

		ret_die->die_next_off = offset;
		if (search_sibling && level > 0) {
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004204ee8:	eb 09                	jmp    8004204ef3 <dwarf_search_die_within_cu+0x2c7>
  8004204eea:	eb 07                	jmp    8004204ef3 <dwarf_search_die_within_cu+0x2c7>
				/* Advance to next DIE level. */
				level++;
			}
		} else {
			//*ret_die = die;
			return (DW_DLE_NONE);
  8004204eec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204ef1:	eb 30                	jmp    8004204f23 <dwarf_search_die_within_cu+0x2f7>
	//assert(cu);
	assert(ret_die);

	level = 1;

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004204ef3:	48 8b 55 30          	mov    0x30(%rbp),%rdx
  8004204ef7:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204efe:	48 39 c2             	cmp    %rax,%rdx
  8004204f01:	76 1b                	jbe    8004204f1e <dwarf_search_die_within_cu+0x2f2>
  8004204f03:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004204f0a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004204f0e:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004204f15:	48 39 c2             	cmp    %rax,%rdx
  8004204f18:	0f 87 be fd ff ff    	ja     8004204cdc <dwarf_search_die_within_cu+0xb0>
			//*ret_die = die;
			return (DW_DLE_NONE);
		}
	}

	return (DW_DLE_NO_ENTRY);
  8004204f1e:	b8 04 00 00 00       	mov    $0x4,%eax
}
  8004204f23:	c9                   	leaveq 
  8004204f24:	c3                   	retq   

0000008004204f25 <dwarf_offdie>:

//Return 0 on success
int
dwarf_offdie(Dwarf_Debug dbg, uint64_t offset, Dwarf_Die *ret_die, Dwarf_CU cu)
{
  8004204f25:	55                   	push   %rbp
  8004204f26:	48 89 e5             	mov    %rsp,%rbp
  8004204f29:	48 83 ec 60          	sub    $0x60,%rsp
  8004204f2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004204f31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004204f35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int ret;

	assert(dbg);
  8004204f39:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004204f3e:	75 35                	jne    8004204f75 <dwarf_offdie+0x50>
  8004204f40:	48 b9 78 a1 20 04 80 	movabs $0x800420a178,%rcx
  8004204f47:	00 00 00 
  8004204f4a:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204f51:	00 00 00 
  8004204f54:	be c4 02 00 00       	mov    $0x2c4,%esi
  8004204f59:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204f60:	00 00 00 
  8004204f63:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204f68:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204f6f:	00 00 00 
  8004204f72:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004204f75:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004204f7a:	75 35                	jne    8004204fb1 <dwarf_offdie+0x8c>
  8004204f7c:	48 b9 7c a1 20 04 80 	movabs $0x800420a17c,%rcx
  8004204f83:	00 00 00 
  8004204f86:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004204f8d:	00 00 00 
  8004204f90:	be c5 02 00 00       	mov    $0x2c5,%esi
  8004204f95:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004204f9c:	00 00 00 
  8004204f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204fa4:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004204fab:	00 00 00 
  8004204fae:	41 ff d0             	callq  *%r8

	/* First search the current CU. */
	if (offset < cu.cu_next_offset) {
  8004204fb1:	48 8b 45 30          	mov    0x30(%rbp),%rax
  8004204fb5:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004204fb9:	76 66                	jbe    8004205021 <dwarf_offdie+0xfc>
		ret = dwarf_search_die_within_cu(dbg, cu, offset, ret_die, 0);
  8004204fbb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004204fbf:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004204fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204fc7:	48 8b 4d 10          	mov    0x10(%rbp),%rcx
  8004204fcb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8004204fcf:	48 8b 4d 18          	mov    0x18(%rbp),%rcx
  8004204fd3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8004204fd8:	48 8b 4d 20          	mov    0x20(%rbp),%rcx
  8004204fdc:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8004204fe1:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004204fe5:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8004204fea:	48 8b 4d 30          	mov    0x30(%rbp),%rcx
  8004204fee:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8004204ff3:	48 8b 4d 38          	mov    0x38(%rbp),%rcx
  8004204ff7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8004204ffc:	48 8b 4d 40          	mov    0x40(%rbp),%rcx
  8004205000:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  8004205005:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420500a:	48 89 c7             	mov    %rax,%rdi
  800420500d:	48 b8 2c 4c 20 04 80 	movabs $0x8004204c2c,%rax
  8004205014:	00 00 00 
  8004205017:	ff d0                	callq  *%rax
  8004205019:	89 45 fc             	mov    %eax,-0x4(%rbp)
		return ret;
  800420501c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420501f:	eb 05                	jmp    8004205026 <dwarf_offdie+0x101>
	}

	/*TODO: Search other CU*/
	return DW_DLV_OK;
  8004205021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004205026:	c9                   	leaveq 
  8004205027:	c3                   	retq   

0000008004205028 <_dwarf_attr_find>:

Dwarf_Attribute*
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
  8004205028:	55                   	push   %rbp
  8004205029:	48 89 e5             	mov    %rsp,%rbp
  800420502c:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004205030:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004205034:	89 f0                	mov    %esi,%eax
  8004205036:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Attribute *myat = NULL;
  800420503a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004205041:	00 
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  8004205042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004205049:	eb 57                	jmp    80042050a2 <_dwarf_attr_find+0x7a>
	{
		if (die->die_attr[i].at_attrib == attr)
  800420504b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420504f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004205052:	48 63 d0             	movslq %eax,%rdx
  8004205055:	48 89 d0             	mov    %rdx,%rax
  8004205058:	48 01 c0             	add    %rax,%rax
  800420505b:	48 01 d0             	add    %rdx,%rax
  800420505e:	48 c1 e0 05          	shl    $0x5,%rax
  8004205062:	48 01 c8             	add    %rcx,%rax
  8004205065:	48 05 80 03 00 00    	add    $0x380,%rax
  800420506b:	48 8b 10             	mov    (%rax),%rdx
  800420506e:	0f b7 45 e4          	movzwl -0x1c(%rbp),%eax
  8004205072:	48 39 c2             	cmp    %rax,%rdx
  8004205075:	75 27                	jne    800420509e <_dwarf_attr_find+0x76>
		{
			myat = &(die->die_attr[i]);
  8004205077:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420507a:	48 63 d0             	movslq %eax,%rdx
  800420507d:	48 89 d0             	mov    %rdx,%rax
  8004205080:	48 01 c0             	add    %rax,%rax
  8004205083:	48 01 d0             	add    %rdx,%rax
  8004205086:	48 c1 e0 05          	shl    $0x5,%rax
  800420508a:	48 8d 90 70 03 00 00 	lea    0x370(%rax),%rdx
  8004205091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205095:	48 01 d0             	add    %rdx,%rax
  8004205098:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  800420509c:	eb 17                	jmp    80042050b5 <_dwarf_attr_find+0x8d>
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
	Dwarf_Attribute *myat = NULL;
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  800420509e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80042050a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042050a6:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  80042050ad:	0f b6 c0             	movzbl %al,%eax
  80042050b0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80042050b3:	7f 96                	jg     800420504b <_dwarf_attr_find+0x23>
			myat = &(die->die_attr[i]);
			break;
		}
	}

	return myat;
  80042050b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042050b9:	c9                   	leaveq 
  80042050ba:	c3                   	retq   

00000080042050bb <dwarf_siblingof>:

//Return 0 on success
int
dwarf_siblingof(Dwarf_Debug dbg, Dwarf_Die *die, Dwarf_Die *ret_die,
		Dwarf_CU *cu)
{
  80042050bb:	55                   	push   %rbp
  80042050bc:	48 89 e5             	mov    %rsp,%rbp
  80042050bf:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80042050c3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042050c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80042050cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80042050cf:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	Dwarf_Attribute *at;
	uint64_t offset;
	int ret, search_sibling;

	assert(dbg);
  80042050d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80042050d8:	75 35                	jne    800420510f <dwarf_siblingof+0x54>
  80042050da:	48 b9 78 a1 20 04 80 	movabs $0x800420a178,%rcx
  80042050e1:	00 00 00 
  80042050e4:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  80042050eb:	00 00 00 
  80042050ee:	be ec 02 00 00       	mov    $0x2ec,%esi
  80042050f3:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  80042050fa:	00 00 00 
  80042050fd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205102:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205109:	00 00 00 
  800420510c:	41 ff d0             	callq  *%r8
	assert(ret_die);
  800420510f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004205114:	75 35                	jne    800420514b <dwarf_siblingof+0x90>
  8004205116:	48 b9 7c a1 20 04 80 	movabs $0x800420a17c,%rcx
  800420511d:	00 00 00 
  8004205120:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004205127:	00 00 00 
  800420512a:	be ed 02 00 00       	mov    $0x2ed,%esi
  800420512f:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004205136:	00 00 00 
  8004205139:	b8 00 00 00 00       	mov    $0x0,%eax
  800420513e:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205145:	00 00 00 
  8004205148:	41 ff d0             	callq  *%r8
	assert(cu);
  800420514b:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8004205150:	75 35                	jne    8004205187 <dwarf_siblingof+0xcc>
  8004205152:	48 b9 84 a1 20 04 80 	movabs $0x800420a184,%rcx
  8004205159:	00 00 00 
  800420515c:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  8004205163:	00 00 00 
  8004205166:	be ee 02 00 00       	mov    $0x2ee,%esi
  800420516b:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  8004205172:	00 00 00 
  8004205175:	b8 00 00 00 00       	mov    $0x0,%eax
  800420517a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205181:	00 00 00 
  8004205184:	41 ff d0             	callq  *%r8

	/* Application requests the first DIE in this CU. */
	if (die == NULL)
  8004205187:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420518c:	75 65                	jne    80042051f3 <dwarf_siblingof+0x138>
		return (dwarf_offdie(dbg, cu->cu_die_offset, ret_die, *cu));
  800420518e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205192:	48 8b 70 28          	mov    0x28(%rax),%rsi
  8004205196:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420519a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420519e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042051a2:	48 8b 38             	mov    (%rax),%rdi
  80042051a5:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042051a9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80042051ad:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  80042051b2:	48 8b 78 10          	mov    0x10(%rax),%rdi
  80042051b6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  80042051bb:	48 8b 78 18          	mov    0x18(%rax),%rdi
  80042051bf:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  80042051c4:	48 8b 78 20          	mov    0x20(%rax),%rdi
  80042051c8:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  80042051cd:	48 8b 78 28          	mov    0x28(%rax),%rdi
  80042051d1:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  80042051d6:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042051da:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80042051df:	48 89 cf             	mov    %rcx,%rdi
  80042051e2:	48 b8 25 4f 20 04 80 	movabs $0x8004204f25,%rax
  80042051e9:	00 00 00 
  80042051ec:	ff d0                	callq  *%rax
  80042051ee:	e9 0a 01 00 00       	jmpq   80042052fd <dwarf_siblingof+0x242>

	/*
	 * If the DIE doesn't have any children, its sibling sits next
	 * right to it.
	 */
	search_sibling = 0;
  80042051f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	if (die->die_ab.ab_children == DW_CHILDREN_no)
  80042051fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042051fe:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  8004205202:	84 c0                	test   %al,%al
  8004205204:	75 0e                	jne    8004205214 <dwarf_siblingof+0x159>
		offset = die->die_next_off;
  8004205206:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420520a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420520e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004205212:	eb 6b                	jmp    800420527f <dwarf_siblingof+0x1c4>
	else {
		/*
		 * Look for DW_AT_sibling attribute for the offset of
		 * its sibling.
		 */
		if ((at = _dwarf_attr_find(die, DW_AT_sibling)) != NULL) {
  8004205214:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205218:	be 01 00 00 00       	mov    $0x1,%esi
  800420521d:	48 89 c7             	mov    %rax,%rdi
  8004205220:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  8004205227:	00 00 00 
  800420522a:	ff d0                	callq  *%rax
  800420522c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8004205230:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004205235:	74 35                	je     800420526c <dwarf_siblingof+0x1b1>
			if (at->at_form != DW_FORM_ref_addr)
  8004205237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420523b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420523f:	48 83 f8 10          	cmp    $0x10,%rax
  8004205243:	74 19                	je     800420525e <dwarf_siblingof+0x1a3>
				offset = at->u[0].u64 + cu->cu_offset;
  8004205245:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205249:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420524d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205251:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004205255:	48 01 d0             	add    %rdx,%rax
  8004205258:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420525c:	eb 21                	jmp    800420527f <dwarf_siblingof+0x1c4>
			else
				offset = at->u[0].u64;
  800420525e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205262:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004205266:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420526a:	eb 13                	jmp    800420527f <dwarf_siblingof+0x1c4>
		} else {
			offset = die->die_next_off;
  800420526c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205270:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004205274:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			search_sibling = 1;
  8004205278:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
		}
	}

	ret = dwarf_search_die_within_cu(dbg, *cu, offset, ret_die, search_sibling);
  800420527f:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  8004205282:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004205286:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800420528a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800420528e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205292:	4c 8b 00             	mov    (%rax),%r8
  8004205295:	4c 89 04 24          	mov    %r8,(%rsp)
  8004205299:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420529d:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  80042052a2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80042052a6:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  80042052ab:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80042052af:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  80042052b4:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80042052b8:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  80042052bd:	4c 8b 40 28          	mov    0x28(%rax),%r8
  80042052c1:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  80042052c6:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042052ca:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80042052cf:	48 b8 2c 4c 20 04 80 	movabs $0x8004204c2c,%rax
  80042052d6:	00 00 00 
  80042052d9:	ff d0                	callq  *%rax
  80042052db:	89 45 e4             	mov    %eax,-0x1c(%rbp)


	if (ret == DW_DLE_NO_ENTRY) {
  80042052de:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  80042052e2:	75 07                	jne    80042052eb <dwarf_siblingof+0x230>
		return (DW_DLV_NO_ENTRY);
  80042052e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042052e9:	eb 12                	jmp    80042052fd <dwarf_siblingof+0x242>
	} else if (ret != DW_DLE_NONE)
  80042052eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042052ef:	74 07                	je     80042052f8 <dwarf_siblingof+0x23d>
		return (DW_DLV_ERROR);
  80042052f1:	b8 01 00 00 00       	mov    $0x1,%eax
  80042052f6:	eb 05                	jmp    80042052fd <dwarf_siblingof+0x242>


	return (DW_DLV_OK);
  80042052f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042052fd:	c9                   	leaveq 
  80042052fe:	c3                   	retq   

00000080042052ff <dwarf_child>:

int
dwarf_child(Dwarf_Debug dbg, Dwarf_CU *cu, Dwarf_Die *die, Dwarf_Die *ret_die)
{
  80042052ff:	55                   	push   %rbp
  8004205300:	48 89 e5             	mov    %rsp,%rbp
  8004205303:	48 83 ec 70          	sub    $0x70,%rsp
  8004205307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420530b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420530f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004205313:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	int ret;

	assert(die);
  8004205317:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800420531c:	75 35                	jne    8004205353 <dwarf_child+0x54>
  800420531e:	48 b9 87 a1 20 04 80 	movabs $0x800420a187,%rcx
  8004205325:	00 00 00 
  8004205328:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  800420532f:	00 00 00 
  8004205332:	be 1c 03 00 00       	mov    $0x31c,%esi
  8004205337:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  800420533e:	00 00 00 
  8004205341:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205346:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  800420534d:	00 00 00 
  8004205350:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004205353:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004205358:	75 35                	jne    800420538f <dwarf_child+0x90>
  800420535a:	48 b9 7c a1 20 04 80 	movabs $0x800420a17c,%rcx
  8004205361:	00 00 00 
  8004205364:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  800420536b:	00 00 00 
  800420536e:	be 1d 03 00 00       	mov    $0x31d,%esi
  8004205373:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  800420537a:	00 00 00 
  800420537d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205382:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205389:	00 00 00 
  800420538c:	41 ff d0             	callq  *%r8
	assert(dbg);
  800420538f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004205394:	75 35                	jne    80042053cb <dwarf_child+0xcc>
  8004205396:	48 b9 78 a1 20 04 80 	movabs $0x800420a178,%rcx
  800420539d:	00 00 00 
  80042053a0:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  80042053a7:	00 00 00 
  80042053aa:	be 1e 03 00 00       	mov    $0x31e,%esi
  80042053af:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  80042053b6:	00 00 00 
  80042053b9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042053be:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042053c5:	00 00 00 
  80042053c8:	41 ff d0             	callq  *%r8
	assert(cu);
  80042053cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80042053d0:	75 35                	jne    8004205407 <dwarf_child+0x108>
  80042053d2:	48 b9 84 a1 20 04 80 	movabs $0x800420a184,%rcx
  80042053d9:	00 00 00 
  80042053dc:	48 ba ea 9f 20 04 80 	movabs $0x8004209fea,%rdx
  80042053e3:	00 00 00 
  80042053e6:	be 1f 03 00 00       	mov    $0x31f,%esi
  80042053eb:	48 bf ff 9f 20 04 80 	movabs $0x8004209fff,%rdi
  80042053f2:	00 00 00 
  80042053f5:	b8 00 00 00 00       	mov    $0x0,%eax
  80042053fa:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205401:	00 00 00 
  8004205404:	41 ff d0             	callq  *%r8

	if (die->die_ab.ab_children == DW_CHILDREN_no)
  8004205407:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420540b:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  800420540f:	84 c0                	test   %al,%al
  8004205411:	75 0a                	jne    800420541d <dwarf_child+0x11e>
		return (DW_DLE_NO_ENTRY);
  8004205413:	b8 04 00 00 00       	mov    $0x4,%eax
  8004205418:	e9 84 00 00 00       	jmpq   80042054a1 <dwarf_child+0x1a2>

	ret = dwarf_search_die_within_cu(dbg, *cu, die->die_next_off, ret_die, 0);
  800420541d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004205421:	48 8b 70 08          	mov    0x8(%rax),%rsi
  8004205425:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205429:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800420542d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004205431:	48 8b 08             	mov    (%rax),%rcx
  8004205434:	48 89 0c 24          	mov    %rcx,(%rsp)
  8004205438:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420543c:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8004205441:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8004205445:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  800420544a:	48 8b 48 18          	mov    0x18(%rax),%rcx
  800420544e:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8004205453:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205457:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  800420545c:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8004205460:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8004205465:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004205469:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  800420546e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004205473:	48 b8 2c 4c 20 04 80 	movabs $0x8004204c2c,%rax
  800420547a:	00 00 00 
  800420547d:	ff d0                	callq  *%rax
  800420547f:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (ret == DW_DLE_NO_ENTRY) {
  8004205482:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8004205486:	75 07                	jne    800420548f <dwarf_child+0x190>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  8004205488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420548d:	eb 12                	jmp    80042054a1 <dwarf_child+0x1a2>
	} else if (ret != DW_DLE_NONE)
  800420548f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004205493:	74 07                	je     800420549c <dwarf_child+0x19d>
		return (DW_DLV_ERROR);
  8004205495:	b8 01 00 00 00       	mov    $0x1,%eax
  800420549a:	eb 05                	jmp    80042054a1 <dwarf_child+0x1a2>

	return (DW_DLV_OK);
  800420549c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042054a1:	c9                   	leaveq 
  80042054a2:	c3                   	retq   

00000080042054a3 <_dwarf_find_section_enhanced>:


int  _dwarf_find_section_enhanced(Dwarf_Section *ds)
{
  80042054a3:	55                   	push   %rbp
  80042054a4:	48 89 e5             	mov    %rsp,%rbp
  80042054a7:	48 83 ec 20          	sub    $0x20,%rsp
  80042054ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *secthdr = _dwarf_find_section(ds->ds_name);
  80042054af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042054b3:	48 8b 00             	mov    (%rax),%rax
  80042054b6:	48 89 c7             	mov    %rax,%rdi
  80042054b9:	48 b8 ca 87 20 04 80 	movabs $0x80042087ca,%rax
  80042054c0:	00 00 00 
  80042054c3:	ff d0                	callq  *%rax
  80042054c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	ds->ds_data = secthdr->ds_data;//(Dwarf_Small*)((uint8_t *)elf_base_ptr + secthdr->sh_offset);
  80042054c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042054cd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042054d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042054d5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ds->ds_addr = secthdr->ds_addr;
  80042054d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042054dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042054e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042054e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	ds->ds_size = secthdr->ds_size;
  80042054e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042054ed:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042054f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042054f5:	48 89 50 18          	mov    %rdx,0x18(%rax)
	return 0;
  80042054f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042054fe:	c9                   	leaveq 
  80042054ff:	c3                   	retq   

0000008004205500 <_dwarf_frame_params_init>:

extern int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

void
_dwarf_frame_params_init(Dwarf_Debug dbg)
{
  8004205500:	55                   	push   %rbp
  8004205501:	48 89 e5             	mov    %rsp,%rbp
  8004205504:	48 83 ec 08          	sub    $0x8,%rsp
  8004205508:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	/* Initialise call frame related parameters. */
	dbg->dbg_frame_rule_table_size = DW_FRAME_LAST_REG_NUM;
  800420550c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205510:	66 c7 40 48 42 00    	movw   $0x42,0x48(%rax)
	dbg->dbg_frame_rule_initial_value = DW_FRAME_REG_INITIAL_VALUE;
  8004205516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420551a:	66 c7 40 4a 0b 04    	movw   $0x40b,0x4a(%rax)
	dbg->dbg_frame_cfa_value = DW_FRAME_CFA_COL3;
  8004205520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205524:	66 c7 40 4c 9c 05    	movw   $0x59c,0x4c(%rax)
	dbg->dbg_frame_same_value = DW_FRAME_SAME_VAL;
  800420552a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420552e:	66 c7 40 4e 0b 04    	movw   $0x40b,0x4e(%rax)
	dbg->dbg_frame_undefined_value = DW_FRAME_UNDEFINED_VAL;
  8004205534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205538:	66 c7 40 50 0a 04    	movw   $0x40a,0x50(%rax)
}
  800420553e:	c9                   	leaveq 
  800420553f:	c3                   	retq   

0000008004205540 <dwarf_get_fde_at_pc>:

int
dwarf_get_fde_at_pc(Dwarf_Debug dbg, Dwarf_Addr pc,
		    struct _Dwarf_Fde *ret_fde, Dwarf_Cie cie,
		    Dwarf_Error *error)
{
  8004205540:	55                   	push   %rbp
  8004205541:	48 89 e5             	mov    %rsp,%rbp
  8004205544:	48 83 ec 40          	sub    $0x40,%rsp
  8004205548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420554c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004205550:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004205554:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  8004205558:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	Dwarf_Fde fde = ret_fde;
  800420555c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004205560:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memset(fde, 0, sizeof(struct _Dwarf_Fde));
  8004205564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205568:	ba 80 00 00 00       	mov    $0x80,%edx
  800420556d:	be 00 00 00 00       	mov    $0x0,%esi
  8004205572:	48 89 c7             	mov    %rax,%rdi
  8004205575:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  800420557c:	00 00 00 
  800420557f:	ff d0                	callq  *%rax
	fde->fde_cie = cie;
  8004205581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004205585:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205589:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if (ret_fde == NULL)
  800420558d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004205592:	75 07                	jne    800420559b <dwarf_get_fde_at_pc+0x5b>
		return (DW_DLV_ERROR);
  8004205594:	b8 01 00 00 00       	mov    $0x1,%eax
  8004205599:	eb 75                	jmp    8004205610 <dwarf_get_fde_at_pc+0xd0>

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  800420559b:	eb 59                	jmp    80042055f6 <dwarf_get_fde_at_pc+0xb6>
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
  800420559d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80042055a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042055a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042055a9:	be 01 00 00 00       	mov    $0x1,%esi
  80042055ae:	48 89 c7             	mov    %rax,%rdi
  80042055b1:	48 b8 55 77 20 04 80 	movabs $0x8004207755,%rax
  80042055b8:	00 00 00 
  80042055bb:	ff d0                	callq  *%rax
  80042055bd:	85 c0                	test   %eax,%eax
  80042055bf:	79 07                	jns    80042055c8 <dwarf_get_fde_at_pc+0x88>
		{
			return DW_DLV_NO_ENTRY;
  80042055c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042055c6:	eb 48                	jmp    8004205610 <dwarf_get_fde_at_pc+0xd0>
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  80042055c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042055cc:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042055d0:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042055d4:	77 20                	ja     80042055f6 <dwarf_get_fde_at_pc+0xb6>
  80042055d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042055da:	48 8b 50 30          	mov    0x30(%rax),%rdx
		    fde->fde_adrange)
  80042055de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042055e2:	48 8b 40 38          	mov    0x38(%rax),%rax
	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
		{
			return DW_DLV_NO_ENTRY;
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  80042055e6:	48 01 d0             	add    %rdx,%rax
  80042055e9:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042055ed:	76 07                	jbe    80042055f6 <dwarf_get_fde_at_pc+0xb6>
		    fde->fde_adrange)
			return (DW_DLV_OK);
  80042055ef:	b8 00 00 00 00       	mov    $0x0,%eax
  80042055f4:	eb 1a                	jmp    8004205610 <dwarf_get_fde_at_pc+0xd0>
	fde->fde_cie = cie;
	
	if (ret_fde == NULL)
		return (DW_DLV_ERROR);

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  80042055f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042055fa:	48 8b 50 30          	mov    0x30(%rax),%rdx
  80042055fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004205602:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004205606:	48 39 c2             	cmp    %rax,%rdx
  8004205609:	72 92                	jb     800420559d <dwarf_get_fde_at_pc+0x5d>
		    fde->fde_adrange)
			return (DW_DLV_OK);
	}

	DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
	return (DW_DLV_NO_ENTRY);
  800420560b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8004205610:	c9                   	leaveq 
  8004205611:	c3                   	retq   

0000008004205612 <_dwarf_frame_regtable_copy>:

int
_dwarf_frame_regtable_copy(Dwarf_Debug dbg, Dwarf_Regtable3 **dest,
			   Dwarf_Regtable3 *src, Dwarf_Error *error)
{
  8004205612:	55                   	push   %rbp
  8004205613:	48 89 e5             	mov    %rsp,%rbp
  8004205616:	53                   	push   %rbx
  8004205617:	48 83 ec 38          	sub    $0x38,%rsp
  800420561b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800420561f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004205623:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004205627:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	int i;

	assert(dest != NULL);
  800420562b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004205630:	75 35                	jne    8004205667 <_dwarf_frame_regtable_copy+0x55>
  8004205632:	48 b9 9a a1 20 04 80 	movabs $0x800420a19a,%rcx
  8004205639:	00 00 00 
  800420563c:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  8004205643:	00 00 00 
  8004205646:	be 57 00 00 00       	mov    $0x57,%esi
  800420564b:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004205652:	00 00 00 
  8004205655:	b8 00 00 00 00       	mov    $0x0,%eax
  800420565a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004205661:	00 00 00 
  8004205664:	41 ff d0             	callq  *%r8
	assert(src != NULL);
  8004205667:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420566c:	75 35                	jne    80042056a3 <_dwarf_frame_regtable_copy+0x91>
  800420566e:	48 b9 d2 a1 20 04 80 	movabs $0x800420a1d2,%rcx
  8004205675:	00 00 00 
  8004205678:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  800420567f:	00 00 00 
  8004205682:	be 58 00 00 00       	mov    $0x58,%esi
  8004205687:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  800420568e:	00 00 00 
  8004205691:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205696:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  800420569d:	00 00 00 
  80042056a0:	41 ff d0             	callq  *%r8

	if (*dest == NULL) {
  80042056a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042056a7:	48 8b 00             	mov    (%rax),%rax
  80042056aa:	48 85 c0             	test   %rax,%rax
  80042056ad:	75 39                	jne    80042056e8 <_dwarf_frame_regtable_copy+0xd6>
		*dest = &global_rt_table_shadow;
  80042056af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042056b3:	48 bb 20 cd 21 04 80 	movabs $0x800421cd20,%rbx
  80042056ba:	00 00 00 
  80042056bd:	48 89 18             	mov    %rbx,(%rax)
		(*dest)->rt3_reg_table_size = src->rt3_reg_table_size;
  80042056c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042056c4:	48 8b 00             	mov    (%rax),%rax
  80042056c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042056cb:	0f b7 52 18          	movzwl 0x18(%rdx),%edx
  80042056cf:	66 89 50 18          	mov    %dx,0x18(%rax)
		(*dest)->rt3_rules = global_rules_shadow;
  80042056d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042056d7:	48 8b 00             	mov    (%rax),%rax
  80042056da:	48 bb c0 ce 21 04 80 	movabs $0x800421cec0,%rbx
  80042056e1:	00 00 00 
  80042056e4:	48 89 58 20          	mov    %rbx,0x20(%rax)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
  80042056e8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80042056ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042056f0:	48 8b 00             	mov    (%rax),%rax
  80042056f3:	ba 18 00 00 00       	mov    $0x18,%edx
  80042056f8:	48 89 ce             	mov    %rcx,%rsi
  80042056fb:	48 89 c7             	mov    %rax,%rdi
  80042056fe:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004205705:	00 00 00 
  8004205708:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420570a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8004205711:	eb 5a                	jmp    800420576d <_dwarf_frame_regtable_copy+0x15b>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
  8004205713:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004205717:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420571b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420571e:	48 63 d0             	movslq %eax,%rdx
  8004205721:	48 89 d0             	mov    %rdx,%rax
  8004205724:	48 01 c0             	add    %rax,%rax
  8004205727:	48 01 d0             	add    %rdx,%rax
  800420572a:	48 c1 e0 03          	shl    $0x3,%rax
  800420572e:	48 01 c1             	add    %rax,%rcx
  8004205731:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205735:	48 8b 00             	mov    (%rax),%rax
  8004205738:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420573c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420573f:	48 63 d0             	movslq %eax,%rdx
  8004205742:	48 89 d0             	mov    %rdx,%rax
  8004205745:	48 01 c0             	add    %rax,%rax
  8004205748:	48 01 d0             	add    %rdx,%rax
  800420574b:	48 c1 e0 03          	shl    $0x3,%rax
  800420574f:	48 01 f0             	add    %rsi,%rax
  8004205752:	ba 18 00 00 00       	mov    $0x18,%edx
  8004205757:	48 89 ce             	mov    %rcx,%rsi
  800420575a:	48 89 c7             	mov    %rax,%rdi
  800420575d:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004205764:	00 00 00 
  8004205767:	ff d0                	callq  *%rax

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
  8004205769:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420576d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205771:	48 8b 00             	mov    (%rax),%rax
  8004205774:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205778:	0f b7 c0             	movzwl %ax,%eax
  800420577b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800420577e:	7e 10                	jle    8004205790 <_dwarf_frame_regtable_copy+0x17e>
		     i < src->rt3_reg_table_size; i++)
  8004205780:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004205784:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205788:	0f b7 c0             	movzwl %ax,%eax
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420578b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800420578e:	7f 83                	jg     8004205713 <_dwarf_frame_regtable_copy+0x101>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  8004205790:	eb 32                	jmp    80042057c4 <_dwarf_frame_regtable_copy+0x1b2>
		(*dest)->rt3_rules[i].dw_regnum =
  8004205792:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205796:	48 8b 00             	mov    (%rax),%rax
  8004205799:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420579d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042057a0:	48 63 d0             	movslq %eax,%rdx
  80042057a3:	48 89 d0             	mov    %rdx,%rax
  80042057a6:	48 01 c0             	add    %rax,%rax
  80042057a9:	48 01 d0             	add    %rdx,%rax
  80042057ac:	48 c1 e0 03          	shl    $0x3,%rax
  80042057b0:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
			dbg->dbg_frame_undefined_value;
  80042057b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042057b8:	0f b7 40 50          	movzwl 0x50(%rax),%eax
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
		(*dest)->rt3_rules[i].dw_regnum =
  80042057bc:	66 89 42 02          	mov    %ax,0x2(%rdx)
	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  80042057c0:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80042057c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042057c8:	48 8b 00             	mov    (%rax),%rax
  80042057cb:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042057cf:	0f b7 c0             	movzwl %ax,%eax
  80042057d2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80042057d5:	7f bb                	jg     8004205792 <_dwarf_frame_regtable_copy+0x180>
		(*dest)->rt3_rules[i].dw_regnum =
			dbg->dbg_frame_undefined_value;

	return (DW_DLE_NONE);
  80042057d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042057dc:	48 83 c4 38          	add    $0x38,%rsp
  80042057e0:	5b                   	pop    %rbx
  80042057e1:	5d                   	pop    %rbp
  80042057e2:	c3                   	retq   

00000080042057e3 <_dwarf_frame_run_inst>:

static int
_dwarf_frame_run_inst(Dwarf_Debug dbg, Dwarf_Regtable3 *rt, uint8_t *insts,
		      Dwarf_Unsigned len, Dwarf_Unsigned caf, Dwarf_Signed daf, Dwarf_Addr pc,
		      Dwarf_Addr pc_req, Dwarf_Addr *row_pc, Dwarf_Error *error)
{
  80042057e3:	55                   	push   %rbp
  80042057e4:	48 89 e5             	mov    %rsp,%rbp
  80042057e7:	53                   	push   %rbx
  80042057e8:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  80042057ef:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  80042057f3:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  80042057f7:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
  80042057fb:	48 89 4d 80          	mov    %rcx,-0x80(%rbp)
  80042057ff:	4c 89 85 78 ff ff ff 	mov    %r8,-0x88(%rbp)
  8004205806:	4c 89 8d 70 ff ff ff 	mov    %r9,-0x90(%rbp)
			ret = DW_DLE_DF_REG_NUM_TOO_HIGH;               \
			goto program_done;                              \
		}                                                       \
	} while(0)

	ret = DW_DLE_NONE;
  800420580d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	init_rt = saved_rt = NULL;
  8004205814:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  800420581b:	00 
  800420581c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004205820:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	*row_pc = pc;
  8004205824:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205828:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420582c:	48 89 10             	mov    %rdx,(%rax)

	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
  800420582f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004205833:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004205837:	48 8d 75 b0          	lea    -0x50(%rbp),%rsi
  800420583b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420583f:	48 89 c7             	mov    %rax,%rdi
  8004205842:	48 b8 12 56 20 04 80 	movabs $0x8004205612,%rax
  8004205849:	00 00 00 
  800420584c:	ff d0                	callq  *%rax
	p = insts;
  800420584e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004205852:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	pe = p + len;
  8004205856:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420585a:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420585e:	48 01 d0             	add    %rdx,%rax
  8004205861:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	while (p < pe) {
  8004205865:	e9 3a 0d 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		if (*p == DW_CFA_nop) {
  800420586a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420586e:	0f b6 00             	movzbl (%rax),%eax
  8004205871:	84 c0                	test   %al,%al
  8004205873:	75 11                	jne    8004205886 <_dwarf_frame_run_inst+0xa3>
			p++;
  8004205875:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004205879:	48 83 c0 01          	add    $0x1,%rax
  800420587d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			continue;
  8004205881:	e9 1e 0d 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		}

		high2 = *p & 0xc0;
  8004205886:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420588a:	0f b6 00             	movzbl (%rax),%eax
  800420588d:	83 e0 c0             	and    $0xffffffc0,%eax
  8004205890:	88 45 df             	mov    %al,-0x21(%rbp)
		low6 = *p & 0x3f;
  8004205893:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004205897:	0f b6 00             	movzbl (%rax),%eax
  800420589a:	83 e0 3f             	and    $0x3f,%eax
  800420589d:	88 45 de             	mov    %al,-0x22(%rbp)
		p++;
  80042058a0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042058a4:	48 83 c0 01          	add    $0x1,%rax
  80042058a8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)

		if (high2 > 0) {
  80042058ac:	80 7d df 00          	cmpb   $0x0,-0x21(%rbp)
  80042058b0:	0f 84 a1 01 00 00    	je     8004205a57 <_dwarf_frame_run_inst+0x274>
			switch (high2) {
  80042058b6:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80042058ba:	3d 80 00 00 00       	cmp    $0x80,%eax
  80042058bf:	74 38                	je     80042058f9 <_dwarf_frame_run_inst+0x116>
  80042058c1:	3d c0 00 00 00       	cmp    $0xc0,%eax
  80042058c6:	0f 84 01 01 00 00    	je     80042059cd <_dwarf_frame_run_inst+0x1ea>
  80042058cc:	83 f8 40             	cmp    $0x40,%eax
  80042058cf:	0f 85 71 01 00 00    	jne    8004205a46 <_dwarf_frame_run_inst+0x263>
			case DW_CFA_advance_loc:
			        pc += low6 * caf;
  80042058d5:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  80042058d9:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  80042058e0:	ff 
  80042058e1:	48 01 45 10          	add    %rax,0x10(%rbp)
			        if (pc_req < pc)
  80042058e5:	48 8b 45 18          	mov    0x18(%rbp),%rax
  80042058e9:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  80042058ed:	73 05                	jae    80042058f4 <_dwarf_frame_run_inst+0x111>
			                goto program_done;
  80042058ef:	e9 be 0c 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			        break;
  80042058f4:	e9 59 01 00 00       	jmpq   8004205a52 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_offset:
			        *row_pc = pc;
  80042058f9:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042058fd:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205901:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  8004205904:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205908:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420590c:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205910:	66 39 c2             	cmp    %ax,%dx
  8004205913:	72 0c                	jb     8004205921 <_dwarf_frame_run_inst+0x13e>
  8004205915:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420591c:	e9 91 0c 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			        RL[low6].dw_offset_relevant = 1;
  8004205921:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205925:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205929:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420592d:	48 89 d0             	mov    %rdx,%rax
  8004205930:	48 01 c0             	add    %rax,%rax
  8004205933:	48 01 d0             	add    %rdx,%rax
  8004205936:	48 c1 e0 03          	shl    $0x3,%rax
  800420593a:	48 01 c8             	add    %rcx,%rax
  800420593d:	c6 00 01             	movb   $0x1,(%rax)
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
  8004205940:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205944:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205948:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420594c:	48 89 d0             	mov    %rdx,%rax
  800420594f:	48 01 c0             	add    %rax,%rax
  8004205952:	48 01 d0             	add    %rdx,%rax
  8004205955:	48 c1 e0 03          	shl    $0x3,%rax
  8004205959:	48 01 c8             	add    %rcx,%rax
  800420595c:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
  8004205960:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205964:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205968:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420596c:	48 89 d0             	mov    %rdx,%rax
  800420596f:	48 01 c0             	add    %rax,%rax
  8004205972:	48 01 d0             	add    %rdx,%rax
  8004205975:	48 c1 e0 03          	shl    $0x3,%rax
  8004205979:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420597d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205981:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004205985:	66 89 42 02          	mov    %ax,0x2(%rdx)
			        RL[low6].dw_offset_or_block_len =
  8004205989:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420598d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205991:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205995:	48 89 d0             	mov    %rdx,%rax
  8004205998:	48 01 c0             	add    %rax,%rax
  800420599b:	48 01 d0             	add    %rdx,%rax
  800420599e:	48 c1 e0 03          	shl    $0x3,%rax
  80042059a2:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
					_dwarf_decode_uleb128(&p) * daf;
  80042059a6:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042059aa:	48 89 c7             	mov    %rax,%rdi
  80042059ad:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042059b4:	00 00 00 
  80042059b7:	ff d0                	callq  *%rax
  80042059b9:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  80042059c0:	48 0f af c2          	imul   %rdx,%rax
			        *row_pc = pc;
			        CHECK_TABLE_SIZE(low6);
			        RL[low6].dw_offset_relevant = 1;
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
			        RL[low6].dw_offset_or_block_len =
  80042059c4:	48 89 43 08          	mov    %rax,0x8(%rbx)
					_dwarf_decode_uleb128(&p) * daf;
			        break;
  80042059c8:	e9 85 00 00 00       	jmpq   8004205a52 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_restore:
			        *row_pc = pc;
  80042059cd:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042059d1:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042059d5:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  80042059d8:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  80042059dc:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042059e0:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042059e4:	66 39 c2             	cmp    %ax,%dx
  80042059e7:	72 0c                	jb     80042059f5 <_dwarf_frame_run_inst+0x212>
  80042059e9:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  80042059f0:	e9 bd 0b 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			        memcpy(&RL[low6], &INITRL[low6],
  80042059f5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042059f9:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042059fd:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205a01:	48 89 d0             	mov    %rdx,%rax
  8004205a04:	48 01 c0             	add    %rax,%rax
  8004205a07:	48 01 d0             	add    %rdx,%rax
  8004205a0a:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a0e:	48 01 c1             	add    %rax,%rcx
  8004205a11:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205a15:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004205a19:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  8004205a1d:	48 89 d0             	mov    %rdx,%rax
  8004205a20:	48 01 c0             	add    %rax,%rax
  8004205a23:	48 01 d0             	add    %rdx,%rax
  8004205a26:	48 c1 e0 03          	shl    $0x3,%rax
  8004205a2a:	48 01 f0             	add    %rsi,%rax
  8004205a2d:	ba 18 00 00 00       	mov    $0x18,%edx
  8004205a32:	48 89 ce             	mov    %rcx,%rsi
  8004205a35:	48 89 c7             	mov    %rax,%rdi
  8004205a38:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004205a3f:	00 00 00 
  8004205a42:	ff d0                	callq  *%rax
				       sizeof(Dwarf_Regtable_Entry3));
			        break;
  8004205a44:	eb 0c                	jmp    8004205a52 <_dwarf_frame_run_inst+0x26f>
			default:
			        DWARF_SET_ERROR(dbg, error,
						DW_DLE_FRAME_INSTR_EXEC_ERROR);
			        ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  8004205a46:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			        goto program_done;
  8004205a4d:	e9 60 0b 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			}

			continue;
  8004205a52:	e9 4d 0b 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		}

		switch (low6) {
  8004205a57:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8004205a5b:	83 f8 16             	cmp    $0x16,%eax
  8004205a5e:	0f 87 37 0b 00 00    	ja     800420659b <_dwarf_frame_run_inst+0xdb8>
  8004205a64:	89 c0                	mov    %eax,%eax
  8004205a66:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004205a6d:	00 
  8004205a6e:	48 b8 e0 a1 20 04 80 	movabs $0x800420a1e0,%rax
  8004205a75:	00 00 00 
  8004205a78:	48 01 d0             	add    %rdx,%rax
  8004205a7b:	48 8b 00             	mov    (%rax),%rax
  8004205a7e:	ff e0                	jmpq   *%rax
		case DW_CFA_set_loc:
			pc = dbg->decode(&p, dbg->dbg_pointer_size);
  8004205a80:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205a84:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205a88:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004205a8c:	8b 4a 28             	mov    0x28(%rdx),%ecx
  8004205a8f:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205a93:	89 ce                	mov    %ecx,%esi
  8004205a95:	48 89 d7             	mov    %rdx,%rdi
  8004205a98:	ff d0                	callq  *%rax
  8004205a9a:	48 89 45 10          	mov    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205a9e:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205aa2:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205aa6:	73 05                	jae    8004205aad <_dwarf_frame_run_inst+0x2ca>
			        goto program_done;
  8004205aa8:	e9 05 0b 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205aad:	e9 f2 0a 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc1:
			pc += dbg->decode(&p, 1) * caf;
  8004205ab2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205ab6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205aba:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205abe:	be 01 00 00 00       	mov    $0x1,%esi
  8004205ac3:	48 89 d7             	mov    %rdx,%rdi
  8004205ac6:	ff d0                	callq  *%rax
  8004205ac8:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205acf:	ff 
  8004205ad0:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205ad4:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205ad8:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205adc:	73 05                	jae    8004205ae3 <_dwarf_frame_run_inst+0x300>
			        goto program_done;
  8004205ade:	e9 cf 0a 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205ae3:	e9 bc 0a 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc2:
			pc += dbg->decode(&p, 2) * caf;
  8004205ae8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205aec:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205af0:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205af4:	be 02 00 00 00       	mov    $0x2,%esi
  8004205af9:	48 89 d7             	mov    %rdx,%rdi
  8004205afc:	ff d0                	callq  *%rax
  8004205afe:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205b05:	ff 
  8004205b06:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205b0a:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205b0e:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205b12:	73 05                	jae    8004205b19 <_dwarf_frame_run_inst+0x336>
			        goto program_done;
  8004205b14:	e9 99 0a 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205b19:	e9 86 0a 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc4:
			pc += dbg->decode(&p, 4) * caf;
  8004205b1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205b22:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004205b26:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  8004205b2a:	be 04 00 00 00       	mov    $0x4,%esi
  8004205b2f:	48 89 d7             	mov    %rdx,%rdi
  8004205b32:	ff d0                	callq  *%rax
  8004205b34:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  8004205b3b:	ff 
  8004205b3c:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  8004205b40:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8004205b44:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  8004205b48:	73 05                	jae    8004205b4f <_dwarf_frame_run_inst+0x36c>
			        goto program_done;
  8004205b4a:	e9 63 0a 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			break;
  8004205b4f:	e9 50 0a 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended:
			*row_pc = pc;
  8004205b54:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205b58:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205b5c:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205b5f:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205b63:	48 89 c7             	mov    %rax,%rdi
  8004205b66:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205b6d:	00 00 00 
  8004205b70:	ff d0                	callq  *%rax
  8004205b72:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  8004205b76:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205b7a:	48 89 c7             	mov    %rax,%rdi
  8004205b7d:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205b84:	00 00 00 
  8004205b87:	ff d0                	callq  *%rax
  8004205b89:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205b8d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205b91:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205b95:	0f b7 c0             	movzwl %ax,%eax
  8004205b98:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205b9c:	77 0c                	ja     8004205baa <_dwarf_frame_run_inst+0x3c7>
  8004205b9e:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205ba5:	e9 08 0a 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  8004205baa:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205bae:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205bb2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205bb6:	48 89 d0             	mov    %rdx,%rax
  8004205bb9:	48 01 c0             	add    %rax,%rax
  8004205bbc:	48 01 d0             	add    %rdx,%rax
  8004205bbf:	48 c1 e0 03          	shl    $0x3,%rax
  8004205bc3:	48 01 c8             	add    %rcx,%rax
  8004205bc6:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  8004205bc9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205bcd:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205bd1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205bd5:	48 89 d0             	mov    %rdx,%rax
  8004205bd8:	48 01 c0             	add    %rax,%rax
  8004205bdb:	48 01 d0             	add    %rdx,%rax
  8004205bde:	48 c1 e0 03          	shl    $0x3,%rax
  8004205be2:	48 01 c8             	add    %rcx,%rax
  8004205be5:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  8004205be9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205bed:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205bf1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205bf5:	48 89 d0             	mov    %rdx,%rax
  8004205bf8:	48 01 c0             	add    %rax,%rax
  8004205bfb:	48 01 d0             	add    %rdx,%rax
  8004205bfe:	48 c1 e0 03          	shl    $0x3,%rax
  8004205c02:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205c06:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205c0a:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004205c0e:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  8004205c12:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205c16:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205c1a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205c1e:	48 89 d0             	mov    %rdx,%rax
  8004205c21:	48 01 c0             	add    %rax,%rax
  8004205c24:	48 01 d0             	add    %rdx,%rax
  8004205c27:	48 c1 e0 03          	shl    $0x3,%rax
  8004205c2b:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205c2f:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004205c36:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  8004205c3b:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  8004205c3f:	e9 60 09 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_extended:
			*row_pc = pc;
  8004205c44:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205c48:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205c4c:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205c4f:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205c53:	48 89 c7             	mov    %rax,%rdi
  8004205c56:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205c5d:	00 00 00 
  8004205c60:	ff d0                	callq  *%rax
  8004205c62:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205c66:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205c6a:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205c6e:	0f b7 c0             	movzwl %ax,%eax
  8004205c71:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205c75:	77 0c                	ja     8004205c83 <_dwarf_frame_run_inst+0x4a0>
  8004205c77:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205c7e:	e9 2f 09 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			memcpy(&RL[reg], &INITRL[reg],
  8004205c83:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004205c87:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205c8b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205c8f:	48 89 d0             	mov    %rdx,%rax
  8004205c92:	48 01 c0             	add    %rax,%rax
  8004205c95:	48 01 d0             	add    %rdx,%rax
  8004205c98:	48 c1 e0 03          	shl    $0x3,%rax
  8004205c9c:	48 01 c1             	add    %rax,%rcx
  8004205c9f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205ca3:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004205ca7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205cab:	48 89 d0             	mov    %rdx,%rax
  8004205cae:	48 01 c0             	add    %rax,%rax
  8004205cb1:	48 01 d0             	add    %rdx,%rax
  8004205cb4:	48 c1 e0 03          	shl    $0x3,%rax
  8004205cb8:	48 01 f0             	add    %rsi,%rax
  8004205cbb:	ba 18 00 00 00       	mov    $0x18,%edx
  8004205cc0:	48 89 ce             	mov    %rcx,%rsi
  8004205cc3:	48 89 c7             	mov    %rax,%rdi
  8004205cc6:	48 b8 95 32 20 04 80 	movabs $0x8004203295,%rax
  8004205ccd:	00 00 00 
  8004205cd0:	ff d0                	callq  *%rax
			       sizeof(Dwarf_Regtable_Entry3));
			break;
  8004205cd2:	e9 cd 08 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_undefined:
			*row_pc = pc;
  8004205cd7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205cdb:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205cdf:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205ce2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205ce6:	48 89 c7             	mov    %rax,%rdi
  8004205ce9:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205cf0:	00 00 00 
  8004205cf3:	ff d0                	callq  *%rax
  8004205cf5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205cf9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205cfd:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205d01:	0f b7 c0             	movzwl %ax,%eax
  8004205d04:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205d08:	77 0c                	ja     8004205d16 <_dwarf_frame_run_inst+0x533>
  8004205d0a:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205d11:	e9 9c 08 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205d16:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d1a:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205d1e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205d22:	48 89 d0             	mov    %rdx,%rax
  8004205d25:	48 01 c0             	add    %rax,%rax
  8004205d28:	48 01 d0             	add    %rdx,%rax
  8004205d2b:	48 c1 e0 03          	shl    $0x3,%rax
  8004205d2f:	48 01 c8             	add    %rcx,%rax
  8004205d32:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_undefined_value;
  8004205d35:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d39:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205d3d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205d41:	48 89 d0             	mov    %rdx,%rax
  8004205d44:	48 01 c0             	add    %rax,%rax
  8004205d47:	48 01 d0             	add    %rdx,%rax
  8004205d4a:	48 c1 e0 03          	shl    $0x3,%rax
  8004205d4e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205d52:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205d56:	0f b7 40 50          	movzwl 0x50(%rax),%eax
  8004205d5a:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205d5e:	e9 41 08 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_same_value:
			reg = _dwarf_decode_uleb128(&p);
  8004205d63:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205d67:	48 89 c7             	mov    %rax,%rdi
  8004205d6a:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205d71:	00 00 00 
  8004205d74:	ff d0                	callq  *%rax
  8004205d76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205d7a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d7e:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205d82:	0f b7 c0             	movzwl %ax,%eax
  8004205d85:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205d89:	77 0c                	ja     8004205d97 <_dwarf_frame_run_inst+0x5b4>
  8004205d8b:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205d92:	e9 1b 08 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205d97:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205d9b:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205d9f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205da3:	48 89 d0             	mov    %rdx,%rax
  8004205da6:	48 01 c0             	add    %rax,%rax
  8004205da9:	48 01 d0             	add    %rdx,%rax
  8004205dac:	48 c1 e0 03          	shl    $0x3,%rax
  8004205db0:	48 01 c8             	add    %rcx,%rax
  8004205db3:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_same_value;
  8004205db6:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205dba:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205dbe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205dc2:	48 89 d0             	mov    %rdx,%rax
  8004205dc5:	48 01 c0             	add    %rax,%rax
  8004205dc8:	48 01 d0             	add    %rdx,%rax
  8004205dcb:	48 c1 e0 03          	shl    $0x3,%rax
  8004205dcf:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205dd3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205dd7:	0f b7 40 4e          	movzwl 0x4e(%rax),%eax
  8004205ddb:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205ddf:	e9 c0 07 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_register:
			*row_pc = pc;
  8004205de4:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205de8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205dec:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205def:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205df3:	48 89 c7             	mov    %rax,%rdi
  8004205df6:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205dfd:	00 00 00 
  8004205e00:	ff d0                	callq  *%rax
  8004205e02:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			reg2 = _dwarf_decode_uleb128(&p);
  8004205e06:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205e0a:	48 89 c7             	mov    %rax,%rdi
  8004205e0d:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205e14:	00 00 00 
  8004205e17:	ff d0                	callq  *%rax
  8004205e19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004205e1d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e21:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004205e25:	0f b7 c0             	movzwl %ax,%eax
  8004205e28:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205e2c:	77 0c                	ja     8004205e3a <_dwarf_frame_run_inst+0x657>
  8004205e2e:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004205e35:	e9 78 07 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004205e3a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e3e:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205e42:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205e46:	48 89 d0             	mov    %rdx,%rax
  8004205e49:	48 01 c0             	add    %rax,%rax
  8004205e4c:	48 01 d0             	add    %rdx,%rax
  8004205e4f:	48 c1 e0 03          	shl    $0x3,%rax
  8004205e53:	48 01 c8             	add    %rcx,%rax
  8004205e56:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = reg2;
  8004205e59:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205e5d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004205e61:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205e65:	48 89 d0             	mov    %rdx,%rax
  8004205e68:	48 01 c0             	add    %rax,%rax
  8004205e6b:	48 01 d0             	add    %rdx,%rax
  8004205e6e:	48 c1 e0 03          	shl    $0x3,%rax
  8004205e72:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004205e76:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205e7a:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  8004205e7e:	e9 21 07 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_remember_state:
			_dwarf_frame_regtable_copy(dbg, &saved_rt, rt, error);
  8004205e83:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004205e87:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004205e8b:	48 8d 75 a8          	lea    -0x58(%rbp),%rsi
  8004205e8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205e93:	48 89 c7             	mov    %rax,%rdi
  8004205e96:	48 b8 12 56 20 04 80 	movabs $0x8004205612,%rax
  8004205e9d:	00 00 00 
  8004205ea0:	ff d0                	callq  *%rax
			break;
  8004205ea2:	e9 fd 06 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_state:
			*row_pc = pc;
  8004205ea7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205eab:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205eaf:	48 89 10             	mov    %rdx,(%rax)
			_dwarf_frame_regtable_copy(dbg, &rt, saved_rt, error);
  8004205eb2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004205eb6:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004205eba:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  8004205ebe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205ec2:	48 89 c7             	mov    %rax,%rdi
  8004205ec5:	48 b8 12 56 20 04 80 	movabs $0x8004205612,%rax
  8004205ecc:	00 00 00 
  8004205ecf:	ff d0                	callq  *%rax
			break;
  8004205ed1:	e9 ce 06 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa:
			*row_pc = pc;
  8004205ed6:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205eda:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205ede:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205ee1:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205ee5:	48 89 c7             	mov    %rax,%rdi
  8004205ee8:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205eef:	00 00 00 
  8004205ef2:	ff d0                	callq  *%rax
  8004205ef4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  8004205ef8:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205efc:	48 89 c7             	mov    %rax,%rdi
  8004205eff:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205f06:	00 00 00 
  8004205f09:	ff d0                	callq  *%rax
  8004205f0b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  8004205f0f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f13:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004205f16:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f1a:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  8004205f1e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f22:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205f26:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = uoff;
  8004205f2a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f2e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004205f32:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004205f36:	e9 69 06 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_register:
			*row_pc = pc;
  8004205f3b:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205f3f:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205f43:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004205f46:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205f4a:	48 89 c7             	mov    %rax,%rdi
  8004205f4d:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205f54:	00 00 00 
  8004205f57:	ff d0                	callq  *%rax
  8004205f59:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CFA.dw_regnum = reg;
  8004205f5d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f61:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004205f65:	66 89 50 02          	mov    %dx,0x2(%rax)
			 * Note that DW_CFA_def_cfa_register change the CFA
			 * rule register while keep the old offset. So we
			 * should not touch the CFA.dw_offset_relevant flag
			 * here.
			 */
			break;
  8004205f69:	e9 36 06 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset:
			*row_pc = pc;
  8004205f6e:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205f72:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205f76:	48 89 10             	mov    %rdx,(%rax)
			uoff = _dwarf_decode_uleb128(&p);
  8004205f79:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205f7d:	48 89 c7             	mov    %rax,%rdi
  8004205f80:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205f87:	00 00 00 
  8004205f8a:	ff d0                	callq  *%rax
  8004205f8c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  8004205f90:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f94:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004205f97:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205f9b:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = uoff;
  8004205f9f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fa3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004205fa7:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004205fab:	e9 f4 05 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_expression:
			*row_pc = pc;
  8004205fb0:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004205fb4:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004205fb8:	48 89 10             	mov    %rdx,(%rax)
			CFA.dw_offset_relevant = 0;
  8004205fbb:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fbf:	c6 00 00             	movb   $0x0,(%rax)
			CFA.dw_value_type = DW_EXPR_EXPRESSION;
  8004205fc2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fc6:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			CFA.dw_offset_or_block_len = _dwarf_decode_uleb128(&p);
  8004205fca:	48 8b 5d 90          	mov    -0x70(%rbp),%rbx
  8004205fce:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004205fd2:	48 89 c7             	mov    %rax,%rdi
  8004205fd5:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004205fdc:	00 00 00 
  8004205fdf:	ff d0                	callq  *%rax
  8004205fe1:	48 89 43 08          	mov    %rax,0x8(%rbx)
			CFA.dw_block_ptr = p;
  8004205fe5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205fe9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004205fed:	48 89 50 10          	mov    %rdx,0x10(%rax)
			p += CFA.dw_offset_or_block_len;
  8004205ff1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004205ff5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205ff9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004205ffd:	48 01 d0             	add    %rdx,%rax
  8004206000:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  8004206004:	e9 9b 05 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_expression:
			*row_pc = pc;
  8004206009:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420600d:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206011:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  8004206014:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206018:	48 89 c7             	mov    %rax,%rdi
  800420601b:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004206022:	00 00 00 
  8004206025:	ff d0                	callq  *%rax
  8004206027:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420602b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420602f:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004206033:	0f b7 c0             	movzwl %ax,%eax
  8004206036:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420603a:	77 0c                	ja     8004206048 <_dwarf_frame_run_inst+0x865>
  800420603c:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004206043:	e9 6a 05 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  8004206048:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420604c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206050:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206054:	48 89 d0             	mov    %rdx,%rax
  8004206057:	48 01 c0             	add    %rax,%rax
  800420605a:	48 01 d0             	add    %rdx,%rax
  800420605d:	48 c1 e0 03          	shl    $0x3,%rax
  8004206061:	48 01 c8             	add    %rcx,%rax
  8004206064:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
  8004206067:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420606b:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420606f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206073:	48 89 d0             	mov    %rdx,%rax
  8004206076:	48 01 c0             	add    %rax,%rax
  8004206079:	48 01 d0             	add    %rdx,%rax
  800420607c:	48 c1 e0 03          	shl    $0x3,%rax
  8004206080:	48 01 c8             	add    %rcx,%rax
  8004206083:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  8004206087:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420608b:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420608f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206093:	48 89 d0             	mov    %rdx,%rax
  8004206096:	48 01 c0             	add    %rax,%rax
  8004206099:	48 01 d0             	add    %rdx,%rax
  800420609c:	48 c1 e0 03          	shl    $0x3,%rax
  80042060a0:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  80042060a4:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042060a8:	48 89 c7             	mov    %rax,%rdi
  80042060ab:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042060b2:	00 00 00 
  80042060b5:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  80042060b7:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  80042060bb:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060bf:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042060c3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042060c7:	48 89 d0             	mov    %rdx,%rax
  80042060ca:	48 01 c0             	add    %rax,%rax
  80042060cd:	48 01 d0             	add    %rdx,%rax
  80042060d0:	48 c1 e0 03          	shl    $0x3,%rax
  80042060d4:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042060d8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042060dc:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  80042060e0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042060e4:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042060e8:	48 8b 70 20          	mov    0x20(%rax),%rsi
  80042060ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042060f0:	48 89 d0             	mov    %rdx,%rax
  80042060f3:	48 01 c0             	add    %rax,%rax
  80042060f6:	48 01 d0             	add    %rdx,%rax
  80042060f9:	48 c1 e0 03          	shl    $0x3,%rax
  80042060fd:	48 01 f0             	add    %rsi,%rax
  8004206100:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004206104:	48 01 c8             	add    %rcx,%rax
  8004206107:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  800420610b:	e9 94 04 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended_sf:
			*row_pc = pc;
  8004206110:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004206114:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206118:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420611b:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420611f:	48 89 c7             	mov    %rax,%rdi
  8004206122:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004206129:	00 00 00 
  800420612c:	ff d0                	callq  *%rax
  800420612e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  8004206132:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206136:	48 89 c7             	mov    %rax,%rdi
  8004206139:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004206140:	00 00 00 
  8004206143:	ff d0                	callq  *%rax
  8004206145:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  8004206149:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420614d:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004206151:	0f b7 c0             	movzwl %ax,%eax
  8004206154:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004206158:	77 0c                	ja     8004206166 <_dwarf_frame_run_inst+0x983>
  800420615a:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004206161:	e9 4c 04 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  8004206166:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420616a:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420616e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206172:	48 89 d0             	mov    %rdx,%rax
  8004206175:	48 01 c0             	add    %rax,%rax
  8004206178:	48 01 d0             	add    %rdx,%rax
  800420617b:	48 c1 e0 03          	shl    $0x3,%rax
  800420617f:	48 01 c8             	add    %rcx,%rax
  8004206182:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  8004206185:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206189:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420618d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206191:	48 89 d0             	mov    %rdx,%rax
  8004206194:	48 01 c0             	add    %rax,%rax
  8004206197:	48 01 d0             	add    %rdx,%rax
  800420619a:	48 c1 e0 03          	shl    $0x3,%rax
  800420619e:	48 01 c8             	add    %rcx,%rax
  80042061a1:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  80042061a5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042061a9:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042061ad:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042061b1:	48 89 d0             	mov    %rdx,%rax
  80042061b4:	48 01 c0             	add    %rax,%rax
  80042061b7:	48 01 d0             	add    %rdx,%rax
  80042061ba:	48 c1 e0 03          	shl    $0x3,%rax
  80042061be:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042061c2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042061c6:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  80042061ca:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  80042061ce:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042061d2:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042061d6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042061da:	48 89 d0             	mov    %rdx,%rax
  80042061dd:	48 01 c0             	add    %rax,%rax
  80042061e0:	48 01 d0             	add    %rdx,%rax
  80042061e3:	48 c1 e0 03          	shl    $0x3,%rax
  80042061e7:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042061eb:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  80042061f2:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  80042061f7:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  80042061fb:	e9 a4 03 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_sf:
			*row_pc = pc;
  8004206200:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004206204:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206208:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420620b:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420620f:	48 89 c7             	mov    %rax,%rdi
  8004206212:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004206219:	00 00 00 
  800420621c:	ff d0                	callq  *%rax
  800420621e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  8004206222:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206226:	48 89 c7             	mov    %rax,%rdi
  8004206229:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004206230:	00 00 00 
  8004206233:	ff d0                	callq  *%rax
  8004206235:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  8004206239:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420623d:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004206240:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206244:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  8004206248:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420624c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206250:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  8004206254:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206258:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  800420625f:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  8004206264:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  8004206268:	e9 37 03 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset_sf:
			*row_pc = pc;
  800420626d:	48 8b 45 20          	mov    0x20(%rbp),%rax
  8004206271:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8004206275:	48 89 10             	mov    %rdx,(%rax)
			soff = _dwarf_decode_sleb128(&p);
  8004206278:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420627c:	48 89 c7             	mov    %rax,%rdi
  800420627f:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004206286:	00 00 00 
  8004206289:	ff d0                	callq  *%rax
  800420628b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  800420628f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206293:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  8004206296:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420629a:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  800420629e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042062a2:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  80042062a9:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  80042062ae:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  80042062b2:	e9 ed 02 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset:
			*row_pc = pc;
  80042062b7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042062bb:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042062bf:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  80042062c2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042062c6:	48 89 c7             	mov    %rax,%rdi
  80042062c9:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042062d0:	00 00 00 
  80042062d3:	ff d0                	callq  *%rax
  80042062d5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  80042062d9:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042062dd:	48 89 c7             	mov    %rax,%rdi
  80042062e0:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042062e7:	00 00 00 
  80042062ea:	ff d0                	callq  *%rax
  80042062ec:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  80042062f0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042062f4:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042062f8:	0f b7 c0             	movzwl %ax,%eax
  80042062fb:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80042062ff:	77 0c                	ja     800420630d <_dwarf_frame_run_inst+0xb2a>
  8004206301:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  8004206308:	e9 a5 02 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  800420630d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206311:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206315:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206319:	48 89 d0             	mov    %rdx,%rax
  800420631c:	48 01 c0             	add    %rax,%rax
  800420631f:	48 01 d0             	add    %rdx,%rax
  8004206322:	48 c1 e0 03          	shl    $0x3,%rax
  8004206326:	48 01 c8             	add    %rcx,%rax
  8004206329:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420632c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206330:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206334:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206338:	48 89 d0             	mov    %rdx,%rax
  800420633b:	48 01 c0             	add    %rax,%rax
  800420633e:	48 01 d0             	add    %rdx,%rax
  8004206341:	48 c1 e0 03          	shl    $0x3,%rax
  8004206345:	48 01 c8             	add    %rcx,%rax
  8004206348:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420634c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206350:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206354:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206358:	48 89 d0             	mov    %rdx,%rax
  800420635b:	48 01 c0             	add    %rax,%rax
  800420635e:	48 01 d0             	add    %rdx,%rax
  8004206361:	48 c1 e0 03          	shl    $0x3,%rax
  8004206365:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206369:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420636d:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004206371:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  8004206375:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206379:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420637d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206381:	48 89 d0             	mov    %rdx,%rax
  8004206384:	48 01 c0             	add    %rax,%rax
  8004206387:	48 01 d0             	add    %rdx,%rax
  800420638a:	48 c1 e0 03          	shl    $0x3,%rax
  800420638e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206392:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004206399:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  800420639e:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  80042063a2:	e9 fd 01 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset_sf:
			*row_pc = pc;
  80042063a7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042063ab:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  80042063af:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  80042063b2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042063b6:	48 89 c7             	mov    %rax,%rdi
  80042063b9:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042063c0:	00 00 00 
  80042063c3:	ff d0                	callq  *%rax
  80042063c5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  80042063c9:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042063cd:	48 89 c7             	mov    %rax,%rdi
  80042063d0:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  80042063d7:	00 00 00 
  80042063da:	ff d0                	callq  *%rax
  80042063dc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  80042063e0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042063e4:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042063e8:	0f b7 c0             	movzwl %ax,%eax
  80042063eb:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80042063ef:	77 0c                	ja     80042063fd <_dwarf_frame_run_inst+0xc1a>
  80042063f1:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  80042063f8:	e9 b5 01 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  80042063fd:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206401:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206405:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206409:	48 89 d0             	mov    %rdx,%rax
  800420640c:	48 01 c0             	add    %rax,%rax
  800420640f:	48 01 d0             	add    %rdx,%rax
  8004206412:	48 c1 e0 03          	shl    $0x3,%rax
  8004206416:	48 01 c8             	add    %rcx,%rax
  8004206419:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420641c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206420:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206424:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206428:	48 89 d0             	mov    %rdx,%rax
  800420642b:	48 01 c0             	add    %rax,%rax
  800420642e:	48 01 d0             	add    %rdx,%rax
  8004206431:	48 c1 e0 03          	shl    $0x3,%rax
  8004206435:	48 01 c8             	add    %rcx,%rax
  8004206438:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420643c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206440:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206444:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206448:	48 89 d0             	mov    %rdx,%rax
  800420644b:	48 01 c0             	add    %rax,%rax
  800420644e:	48 01 d0             	add    %rdx,%rax
  8004206451:	48 c1 e0 03          	shl    $0x3,%rax
  8004206455:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206459:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420645d:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004206461:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  8004206465:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206469:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420646d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206471:	48 89 d0             	mov    %rdx,%rax
  8004206474:	48 01 c0             	add    %rax,%rax
  8004206477:	48 01 d0             	add    %rdx,%rax
  800420647a:	48 c1 e0 03          	shl    $0x3,%rax
  800420647e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206482:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  8004206489:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  800420648e:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  8004206492:	e9 0d 01 00 00       	jmpq   80042065a4 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_expression:
			*row_pc = pc;
  8004206497:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420649b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420649f:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  80042064a2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  80042064a6:	48 89 c7             	mov    %rax,%rdi
  80042064a9:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042064b0:	00 00 00 
  80042064b3:	ff d0                	callq  *%rax
  80042064b5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  80042064b9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042064bd:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042064c1:	0f b7 c0             	movzwl %ax,%eax
  80042064c4:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  80042064c8:	77 0c                	ja     80042064d6 <_dwarf_frame_run_inst+0xcf3>
  80042064ca:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  80042064d1:	e9 dc 00 00 00       	jmpq   80042065b2 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  80042064d6:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042064da:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042064de:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042064e2:	48 89 d0             	mov    %rdx,%rax
  80042064e5:	48 01 c0             	add    %rax,%rax
  80042064e8:	48 01 d0             	add    %rdx,%rax
  80042064eb:	48 c1 e0 03          	shl    $0x3,%rax
  80042064ef:	48 01 c8             	add    %rcx,%rax
  80042064f2:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
  80042064f5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042064f9:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042064fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206501:	48 89 d0             	mov    %rdx,%rax
  8004206504:	48 01 c0             	add    %rax,%rax
  8004206507:	48 01 d0             	add    %rdx,%rax
  800420650a:	48 c1 e0 03          	shl    $0x3,%rax
  800420650e:	48 01 c8             	add    %rcx,%rax
  8004206511:	c6 40 01 03          	movb   $0x3,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  8004206515:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206519:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420651d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206521:	48 89 d0             	mov    %rdx,%rax
  8004206524:	48 01 c0             	add    %rax,%rax
  8004206527:	48 01 d0             	add    %rdx,%rax
  800420652a:	48 c1 e0 03          	shl    $0x3,%rax
  800420652e:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  8004206532:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  8004206536:	48 89 c7             	mov    %rax,%rdi
  8004206539:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004206540:	00 00 00 
  8004206543:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  8004206545:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  8004206549:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420654d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206551:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206555:	48 89 d0             	mov    %rdx,%rax
  8004206558:	48 01 c0             	add    %rax,%rax
  800420655b:	48 01 d0             	add    %rdx,%rax
  800420655e:	48 c1 e0 03          	shl    $0x3,%rax
  8004206562:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  8004206566:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420656a:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  800420656e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004206572:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004206576:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420657a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420657e:	48 89 d0             	mov    %rdx,%rax
  8004206581:	48 01 c0             	add    %rax,%rax
  8004206584:	48 01 d0             	add    %rdx,%rax
  8004206587:	48 c1 e0 03          	shl    $0x3,%rax
  800420658b:	48 01 f0             	add    %rsi,%rax
  800420658e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004206592:	48 01 c8             	add    %rcx,%rax
  8004206595:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  8004206599:	eb 09                	jmp    80042065a4 <_dwarf_frame_run_inst+0xdc1>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_INSTR_EXEC_ERROR);
			ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  800420659b:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			goto program_done;
  80042065a2:	eb 0e                	jmp    80042065b2 <_dwarf_frame_run_inst+0xdcf>
	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
	p = insts;
	pe = p + len;

	while (p < pe) {
  80042065a4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042065a8:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  80042065ac:	0f 82 b8 f2 ff ff    	jb     800420586a <_dwarf_frame_run_inst+0x87>
			goto program_done;
		}
	}

program_done:
	return (ret);
  80042065b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
#undef  CFA
#undef  INITCFA
#undef  RL
#undef  INITRL
#undef  CHECK_TABLE_SIZE
}
  80042065b5:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  80042065bc:	5b                   	pop    %rbx
  80042065bd:	5d                   	pop    %rbp
  80042065be:	c3                   	retq   

00000080042065bf <_dwarf_frame_get_internal_table>:
int
_dwarf_frame_get_internal_table(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_req, Dwarf_Regtable3 **ret_rt,
				Dwarf_Addr *ret_row_pc,
				Dwarf_Error *error)
{
  80042065bf:	55                   	push   %rbp
  80042065c0:	48 89 e5             	mov    %rsp,%rbp
  80042065c3:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80042065c7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80042065cb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80042065cf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80042065d3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  80042065d7:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
  80042065db:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Cie cie;
	Dwarf_Regtable3 *rt;
	Dwarf_Addr row_pc;
	int i, ret;

	assert(ret_rt != NULL);
  80042065df:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  80042065e4:	75 35                	jne    800420661b <_dwarf_frame_get_internal_table+0x5c>
  80042065e6:	48 b9 98 a2 20 04 80 	movabs $0x800420a298,%rcx
  80042065ed:	00 00 00 
  80042065f0:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  80042065f7:	00 00 00 
  80042065fa:	be 83 01 00 00       	mov    $0x183,%esi
  80042065ff:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004206606:	00 00 00 
  8004206609:	b8 00 00 00 00       	mov    $0x0,%eax
  800420660e:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206615:	00 00 00 
  8004206618:	41 ff d0             	callq  *%r8

	//dbg = fde->fde_dbg;
	assert(dbg != NULL);
  800420661b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004206620:	75 35                	jne    8004206657 <_dwarf_frame_get_internal_table+0x98>
  8004206622:	48 b9 a7 a2 20 04 80 	movabs $0x800420a2a7,%rcx
  8004206629:	00 00 00 
  800420662c:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  8004206633:	00 00 00 
  8004206636:	be 86 01 00 00       	mov    $0x186,%esi
  800420663b:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004206642:	00 00 00 
  8004206645:	b8 00 00 00 00       	mov    $0x0,%eax
  800420664a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206651:	00 00 00 
  8004206654:	41 ff d0             	callq  *%r8

	rt = dbg->dbg_internal_reg_table;
  8004206657:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420665b:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420665f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	/* Clear the content of regtable from previous run. */
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
  8004206663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206667:	ba 18 00 00 00       	mov    $0x18,%edx
  800420666c:	be 00 00 00 00       	mov    $0x0,%esi
  8004206671:	48 89 c7             	mov    %rax,%rdi
  8004206674:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  800420667b:	00 00 00 
  800420667e:	ff d0                	callq  *%rax
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
  8004206680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206684:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  8004206688:	0f b7 d0             	movzwl %ax,%edx
  800420668b:	48 89 d0             	mov    %rdx,%rax
  800420668e:	48 01 c0             	add    %rax,%rax
  8004206691:	48 01 d0             	add    %rdx,%rax
  8004206694:	48 c1 e0 03          	shl    $0x3,%rax
  8004206698:	48 89 c2             	mov    %rax,%rdx
  800420669b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420669f:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042066a3:	be 00 00 00 00       	mov    $0x0,%esi
  80042066a8:	48 89 c7             	mov    %rax,%rdi
  80042066ab:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  80042066b2:	00 00 00 
  80042066b5:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  80042066b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80042066be:	eb 2f                	jmp    80042066ef <_dwarf_frame_get_internal_table+0x130>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;
  80042066c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042066c4:	48 8b 48 20          	mov    0x20(%rax),%rcx
  80042066c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042066cb:	48 63 d0             	movslq %eax,%rdx
  80042066ce:	48 89 d0             	mov    %rdx,%rax
  80042066d1:	48 01 c0             	add    %rax,%rax
  80042066d4:	48 01 d0             	add    %rdx,%rax
  80042066d7:	48 c1 e0 03          	shl    $0x3,%rax
  80042066db:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  80042066df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042066e3:	0f b7 40 4a          	movzwl 0x4a(%rax),%eax
  80042066e7:	66 89 42 02          	mov    %ax,0x2(%rdx)
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  80042066eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80042066ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042066f3:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  80042066f7:	0f b7 c0             	movzwl %ax,%eax
  80042066fa:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80042066fd:	7f c1                	jg     80042066c0 <_dwarf_frame_get_internal_table+0x101>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;

	/* Run initial instructions in CIE. */
	cie = fde->fde_cie;
  80042066ff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206703:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004206707:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	assert(cie != NULL);
  800420670b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206710:	75 35                	jne    8004206747 <_dwarf_frame_get_internal_table+0x188>
  8004206712:	48 b9 b3 a2 20 04 80 	movabs $0x800420a2b3,%rcx
  8004206719:	00 00 00 
  800420671c:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  8004206723:	00 00 00 
  8004206726:	be 95 01 00 00       	mov    $0x195,%esi
  800420672b:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004206732:	00 00 00 
  8004206735:	b8 00 00 00 00       	mov    $0x0,%eax
  800420673a:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206741:	00 00 00 
  8004206744:	41 ff d0             	callq  *%r8
	ret = _dwarf_frame_run_inst(dbg, rt, cie->cie_initinst,
  8004206747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420674b:	4c 8b 48 40          	mov    0x40(%rax),%r9
  800420674f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206753:	4c 8b 40 38          	mov    0x38(%rax),%r8
  8004206757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420675b:	48 8b 48 70          	mov    0x70(%rax),%rcx
  800420675f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206763:	48 8b 50 68          	mov    0x68(%rax),%rdx
  8004206767:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800420676b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420676f:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8004206773:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004206778:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800420677c:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  8004206781:	48 c7 44 24 08 ff ff 	movq   $0xffffffffffffffff,0x8(%rsp)
  8004206788:	ff ff 
  800420678a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004206791:	00 
  8004206792:	48 89 c7             	mov    %rax,%rdi
  8004206795:	48 b8 e3 57 20 04 80 	movabs $0x80042057e3,%rax
  800420679c:	00 00 00 
  800420679f:	ff d0                	callq  *%rax
  80042067a1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
				    cie->cie_instlen, cie->cie_caf,
				    cie->cie_daf, 0, ~0ULL,
				    &row_pc, error);
	if (ret != DW_DLE_NONE)
  80042067a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80042067a8:	74 08                	je     80042067b2 <_dwarf_frame_get_internal_table+0x1f3>
		return (ret);
  80042067aa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042067ad:	e9 98 00 00 00       	jmpq   800420684a <_dwarf_frame_get_internal_table+0x28b>
	/* Run instructions in FDE. */
	if (pc_req >= fde->fde_initloc) {
  80042067b2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042067b6:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042067ba:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  80042067be:	77 6f                	ja     800420682f <_dwarf_frame_get_internal_table+0x270>
		ret = _dwarf_frame_run_inst(dbg, rt, fde->fde_inst,
  80042067c0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042067c4:	48 8b 78 30          	mov    0x30(%rax),%rdi
  80042067c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042067cc:	4c 8b 48 40          	mov    0x40(%rax),%r9
  80042067d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042067d4:	4c 8b 50 38          	mov    0x38(%rax),%r10
  80042067d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042067dc:	48 8b 48 58          	mov    0x58(%rax),%rcx
  80042067e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042067e4:	48 8b 50 50          	mov    0x50(%rax),%rdx
  80042067e8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80042067ec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042067f0:	4c 8b 45 a0          	mov    -0x60(%rbp),%r8
  80042067f4:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  80042067f9:	4c 8d 45 d8          	lea    -0x28(%rbp),%r8
  80042067fd:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8004206802:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
  8004206806:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  800420680b:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420680f:	4d 89 d0             	mov    %r10,%r8
  8004206812:	48 89 c7             	mov    %rax,%rdi
  8004206815:	48 b8 e3 57 20 04 80 	movabs $0x80042057e3,%rax
  800420681c:	00 00 00 
  800420681f:	ff d0                	callq  *%rax
  8004206821:	89 45 e4             	mov    %eax,-0x1c(%rbp)
					    fde->fde_instlen, cie->cie_caf,
					    cie->cie_daf,
					    fde->fde_initloc, pc_req,
					    &row_pc, error);
		if (ret != DW_DLE_NONE)
  8004206824:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004206828:	74 05                	je     800420682f <_dwarf_frame_get_internal_table+0x270>
			return (ret);
  800420682a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420682d:	eb 1b                	jmp    800420684a <_dwarf_frame_get_internal_table+0x28b>
	}

	*ret_rt = rt;
  800420682f:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004206833:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004206837:	48 89 10             	mov    %rdx,(%rax)
	*ret_row_pc = row_pc;
  800420683a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420683e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004206842:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  8004206845:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420684a:	c9                   	leaveq 
  800420684b:	c3                   	retq   

000000800420684c <dwarf_get_fde_info_for_all_regs>:
int
dwarf_get_fde_info_for_all_regs(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_requested,
				Dwarf_Regtable *reg_table, Dwarf_Addr *row_pc,
				Dwarf_Error *error)
{
  800420684c:	55                   	push   %rbp
  800420684d:	48 89 e5             	mov    %rsp,%rbp
  8004206850:	48 83 ec 50          	sub    $0x50,%rsp
  8004206854:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004206858:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420685c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004206860:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  8004206864:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
  8004206868:	4c 89 4d b0          	mov    %r9,-0x50(%rbp)
	Dwarf_Regtable3 *rt;
	Dwarf_Addr pc;
	Dwarf_Half cfa;
	int i, ret;

	if (fde == NULL || reg_table == NULL) {
  800420686c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004206871:	74 07                	je     800420687a <dwarf_get_fde_info_for_all_regs+0x2e>
  8004206873:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8004206878:	75 0a                	jne    8004206884 <dwarf_get_fde_info_for_all_regs+0x38>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  800420687a:	b8 01 00 00 00       	mov    $0x1,%eax
  800420687f:	e9 eb 02 00 00       	jmpq   8004206b6f <dwarf_get_fde_info_for_all_regs+0x323>
	}

	assert(dbg != NULL);
  8004206884:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004206889:	75 35                	jne    80042068c0 <dwarf_get_fde_info_for_all_regs+0x74>
  800420688b:	48 b9 a7 a2 20 04 80 	movabs $0x800420a2a7,%rcx
  8004206892:	00 00 00 
  8004206895:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  800420689c:	00 00 00 
  800420689f:	be bf 01 00 00       	mov    $0x1bf,%esi
  80042068a4:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  80042068ab:	00 00 00 
  80042068ae:	b8 00 00 00 00       	mov    $0x0,%eax
  80042068b3:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042068ba:	00 00 00 
  80042068bd:	41 ff d0             	callq  *%r8

	if (pc_requested < fde->fde_initloc ||
  80042068c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042068c4:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042068c8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80042068cc:	77 19                	ja     80042068e7 <dwarf_get_fde_info_for_all_regs+0x9b>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
  80042068ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042068d2:	48 8b 50 30          	mov    0x30(%rax),%rdx
  80042068d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042068da:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042068de:	48 01 d0             	add    %rdx,%rax
		return (DW_DLV_ERROR);
	}

	assert(dbg != NULL);

	if (pc_requested < fde->fde_initloc ||
  80042068e1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80042068e5:	77 0a                	ja     80042068f1 <dwarf_get_fde_info_for_all_regs+0xa5>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_PC_NOT_IN_FDE_RANGE);
		return (DW_DLV_ERROR);
  80042068e7:	b8 01 00 00 00       	mov    $0x1,%eax
  80042068ec:	e9 7e 02 00 00       	jmpq   8004206b6f <dwarf_get_fde_info_for_all_regs+0x323>
	}

	ret = _dwarf_frame_get_internal_table(dbg, fde, pc_requested, &rt, &pc,
  80042068f1:	4c 8b 45 b0          	mov    -0x50(%rbp),%r8
  80042068f5:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  80042068f9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80042068fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206901:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206909:	4d 89 c1             	mov    %r8,%r9
  800420690c:	49 89 f8             	mov    %rdi,%r8
  800420690f:	48 89 c7             	mov    %rax,%rdi
  8004206912:	48 b8 bf 65 20 04 80 	movabs $0x80042065bf,%rax
  8004206919:	00 00 00 
  800420691c:	ff d0                	callq  *%rax
  800420691e:	89 45 f8             	mov    %eax,-0x8(%rbp)
					      error);
	if (ret != DW_DLE_NONE)
  8004206921:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004206925:	74 0a                	je     8004206931 <dwarf_get_fde_info_for_all_regs+0xe5>
		return (DW_DLV_ERROR);
  8004206927:	b8 01 00 00 00       	mov    $0x1,%eax
  800420692c:	e9 3e 02 00 00       	jmpq   8004206b6f <dwarf_get_fde_info_for_all_regs+0x323>
	/*
	 * Copy the CFA rule to the column intended for holding the CFA,
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
  8004206931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206935:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  8004206939:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
	if (cfa < DW_REG_TABLE_SIZE) {
  800420693d:	66 83 7d f6 41       	cmpw   $0x41,-0xa(%rbp)
  8004206942:	0f 87 b1 00 00 00    	ja     80042069f9 <dwarf_get_fde_info_for_all_regs+0x1ad>
		reg_table->rules[cfa].dw_offset_relevant =
  8004206948:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
			CFA.dw_offset_relevant;
  800420694c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206950:	0f b6 00             	movzbl (%rax),%eax
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
	if (cfa < DW_REG_TABLE_SIZE) {
		reg_table->rules[cfa].dw_offset_relevant =
  8004206953:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206957:	48 63 c9             	movslq %ecx,%rcx
  800420695a:	48 83 c1 01          	add    $0x1,%rcx
  800420695e:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206962:	48 01 ca             	add    %rcx,%rdx
  8004206965:	88 02                	mov    %al,(%rdx)
			CFA.dw_offset_relevant;
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
  8004206967:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  800420696b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420696f:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  8004206973:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206977:	48 63 c9             	movslq %ecx,%rcx
  800420697a:	48 83 c1 01          	add    $0x1,%rcx
  800420697e:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206982:	48 01 ca             	add    %rcx,%rdx
  8004206985:	88 42 01             	mov    %al,0x1(%rdx)
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
  8004206988:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  800420698c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206990:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  8004206994:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206998:	48 63 c9             	movslq %ecx,%rcx
  800420699b:	48 83 c1 01          	add    $0x1,%rcx
  800420699f:	48 c1 e1 04          	shl    $0x4,%rcx
  80042069a3:	48 01 ca             	add    %rcx,%rdx
  80042069a6:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
  80042069aa:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  80042069ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042069b2:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042069b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042069ba:	48 63 c9             	movslq %ecx,%rcx
  80042069bd:	48 83 c1 01          	add    $0x1,%rcx
  80042069c1:	48 c1 e1 04          	shl    $0x4,%rcx
  80042069c5:	48 01 ca             	add    %rcx,%rdx
  80042069c8:	48 83 c2 08          	add    $0x8,%rdx
  80042069cc:	48 89 02             	mov    %rax,(%rdx)
		reg_table->cfa_rule = reg_table->rules[cfa];
  80042069cf:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
  80042069d3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80042069d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042069db:	48 63 d2             	movslq %edx,%rdx
  80042069de:	48 83 c2 01          	add    $0x1,%rdx
  80042069e2:	48 c1 e2 04          	shl    $0x4,%rdx
  80042069e6:	48 01 d0             	add    %rdx,%rax
  80042069e9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042069ed:	48 8b 00             	mov    (%rax),%rax
  80042069f0:	48 89 01             	mov    %rax,(%rcx)
  80042069f3:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  80042069f7:	eb 3c                	jmp    8004206a35 <dwarf_get_fde_info_for_all_regs+0x1e9>
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
		    CFA.dw_offset_relevant;
  80042069f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042069fd:	0f b6 10             	movzbl (%rax),%edx
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
		reg_table->cfa_rule = reg_table->rules[cfa];
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
  8004206a00:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206a04:	88 10                	mov    %dl,(%rax)
		    CFA.dw_offset_relevant;
		reg_table->cfa_rule.dw_value_type = CFA.dw_value_type;
  8004206a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a0a:	0f b6 50 01          	movzbl 0x1(%rax),%edx
  8004206a0e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206a12:	88 50 01             	mov    %dl,0x1(%rax)
		reg_table->cfa_rule.dw_regnum = CFA.dw_regnum;
  8004206a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a19:	0f b7 50 02          	movzwl 0x2(%rax),%edx
  8004206a1d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206a21:	66 89 50 02          	mov    %dx,0x2(%rax)
		reg_table->cfa_rule.dw_offset = CFA.dw_offset_or_block_len;
  8004206a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a29:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004206a2d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206a31:	48 89 50 08          	mov    %rdx,0x8(%rax)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  8004206a35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004206a3c:	e9 fd 00 00 00       	jmpq   8004206b3e <dwarf_get_fde_info_for_all_regs+0x2f2>
	     i++) {

		/* Do not overwrite CFA column */
		if (i == cfa)
  8004206a41:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
  8004206a45:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8004206a48:	75 05                	jne    8004206a4f <dwarf_get_fde_info_for_all_regs+0x203>
			continue;
  8004206a4a:	e9 eb 00 00 00       	jmpq   8004206b3a <dwarf_get_fde_info_for_all_regs+0x2ee>

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
  8004206a4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a53:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004206a5a:	48 63 d0             	movslq %eax,%rdx
  8004206a5d:	48 89 d0             	mov    %rdx,%rax
  8004206a60:	48 01 c0             	add    %rax,%rax
  8004206a63:	48 01 d0             	add    %rdx,%rax
  8004206a66:	48 c1 e0 03          	shl    $0x3,%rax
  8004206a6a:	48 01 c8             	add    %rcx,%rax
  8004206a6d:	0f b6 00             	movzbl (%rax),%eax

		/* Do not overwrite CFA column */
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
  8004206a70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206a74:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206a77:	48 63 c9             	movslq %ecx,%rcx
  8004206a7a:	48 83 c1 01          	add    $0x1,%rcx
  8004206a7e:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206a82:	48 01 ca             	add    %rcx,%rdx
  8004206a85:	88 02                	mov    %al,(%rdx)
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
  8004206a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206a8b:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004206a92:	48 63 d0             	movslq %eax,%rdx
  8004206a95:	48 89 d0             	mov    %rdx,%rax
  8004206a98:	48 01 c0             	add    %rax,%rax
  8004206a9b:	48 01 d0             	add    %rdx,%rax
  8004206a9e:	48 c1 e0 03          	shl    $0x3,%rax
  8004206aa2:	48 01 c8             	add    %rcx,%rax
  8004206aa5:	0f b6 40 01          	movzbl 0x1(%rax),%eax
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
  8004206aa9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206aad:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206ab0:	48 63 c9             	movslq %ecx,%rcx
  8004206ab3:	48 83 c1 01          	add    $0x1,%rcx
  8004206ab7:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206abb:	48 01 ca             	add    %rcx,%rdx
  8004206abe:	88 42 01             	mov    %al,0x1(%rdx)
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
  8004206ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ac5:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004206acc:	48 63 d0             	movslq %eax,%rdx
  8004206acf:	48 89 d0             	mov    %rdx,%rax
  8004206ad2:	48 01 c0             	add    %rax,%rax
  8004206ad5:	48 01 d0             	add    %rdx,%rax
  8004206ad8:	48 c1 e0 03          	shl    $0x3,%rax
  8004206adc:	48 01 c8             	add    %rcx,%rax
  8004206adf:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  8004206ae3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206ae7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206aea:	48 63 c9             	movslq %ecx,%rcx
  8004206aed:	48 83 c1 01          	add    $0x1,%rcx
  8004206af1:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206af5:	48 01 ca             	add    %rcx,%rdx
  8004206af8:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
  8004206afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b00:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8004206b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004206b07:	48 63 d0             	movslq %eax,%rdx
  8004206b0a:	48 89 d0             	mov    %rdx,%rax
  8004206b0d:	48 01 c0             	add    %rax,%rax
  8004206b10:	48 01 d0             	add    %rdx,%rax
  8004206b13:	48 c1 e0 03          	shl    $0x3,%rax
  8004206b17:	48 01 c8             	add    %rcx,%rax
  8004206b1a:	48 8b 40 08          	mov    0x8(%rax),%rax
		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
  8004206b1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004206b22:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8004206b25:	48 63 c9             	movslq %ecx,%rcx
  8004206b28:	48 83 c1 01          	add    $0x1,%rcx
  8004206b2c:	48 c1 e1 04          	shl    $0x4,%rcx
  8004206b30:	48 01 ca             	add    %rcx,%rdx
  8004206b33:	48 83 c2 08          	add    $0x8,%rdx
  8004206b37:	48 89 02             	mov    %rax,(%rdx)

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
	     i++) {
  8004206b3a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  8004206b3e:	83 7d fc 41          	cmpl   $0x41,-0x4(%rbp)
  8004206b42:	7f 14                	jg     8004206b58 <dwarf_get_fde_info_for_all_regs+0x30c>
  8004206b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206b48:	0f b7 40 48          	movzwl 0x48(%rax),%eax
  8004206b4c:	0f b7 c0             	movzwl %ax,%eax
  8004206b4f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8004206b52:	0f 8f e9 fe ff ff    	jg     8004206a41 <dwarf_get_fde_info_for_all_regs+0x1f5>
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
	}

	if (row_pc) *row_pc = pc;
  8004206b58:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8004206b5d:	74 0b                	je     8004206b6a <dwarf_get_fde_info_for_all_regs+0x31e>
  8004206b5f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206b63:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206b67:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLV_OK);
  8004206b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206b6f:	c9                   	leaveq 
  8004206b70:	c3                   	retq   

0000008004206b71 <_dwarf_frame_read_lsb_encoded>:

static int
_dwarf_frame_read_lsb_encoded(Dwarf_Debug dbg, uint64_t *val, uint8_t *data,
			      uint64_t *offsetp, uint8_t encode, Dwarf_Addr pc, Dwarf_Error *error)
{
  8004206b71:	55                   	push   %rbp
  8004206b72:	48 89 e5             	mov    %rsp,%rbp
  8004206b75:	48 83 ec 40          	sub    $0x40,%rsp
  8004206b79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004206b7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004206b81:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004206b85:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  8004206b89:	44 89 c0             	mov    %r8d,%eax
  8004206b8c:	4c 89 4d c0          	mov    %r9,-0x40(%rbp)
  8004206b90:	88 45 cc             	mov    %al,-0x34(%rbp)
	uint8_t application;

	if (encode == DW_EH_PE_omit)
  8004206b93:	80 7d cc ff          	cmpb   $0xff,-0x34(%rbp)
  8004206b97:	75 0a                	jne    8004206ba3 <_dwarf_frame_read_lsb_encoded+0x32>
		return (DW_DLE_NONE);
  8004206b99:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206b9e:	e9 e6 01 00 00       	jmpq   8004206d89 <_dwarf_frame_read_lsb_encoded+0x218>

	application = encode & 0xf0;
  8004206ba3:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  8004206ba7:	83 e0 f0             	and    $0xfffffff0,%eax
  8004206baa:	88 45 ff             	mov    %al,-0x1(%rbp)
	encode &= 0x0f;
  8004206bad:	80 65 cc 0f          	andb   $0xf,-0x34(%rbp)

	switch (encode) {
  8004206bb1:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  8004206bb5:	83 f8 0c             	cmp    $0xc,%eax
  8004206bb8:	0f 87 72 01 00 00    	ja     8004206d30 <_dwarf_frame_read_lsb_encoded+0x1bf>
  8004206bbe:	89 c0                	mov    %eax,%eax
  8004206bc0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004206bc7:	00 
  8004206bc8:	48 b8 c0 a2 20 04 80 	movabs $0x800420a2c0,%rax
  8004206bcf:	00 00 00 
  8004206bd2:	48 01 d0             	add    %rdx,%rax
  8004206bd5:	48 8b 00             	mov    (%rax),%rax
  8004206bd8:	ff e0                	jmpq   *%rax
	case DW_EH_PE_absptr:
		*val = dbg->read(data, offsetp, dbg->dbg_pointer_size);
  8004206bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206bde:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206be2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004206be6:	8b 52 28             	mov    0x28(%rdx),%edx
  8004206be9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206bed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206bf1:	48 89 cf             	mov    %rcx,%rdi
  8004206bf4:	ff d0                	callq  *%rax
  8004206bf6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206bfa:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206bfd:	e9 35 01 00 00       	jmpq   8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_uleb128:
		*val = _dwarf_read_uleb128(data, offsetp);
  8004206c02:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206c06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206c0a:	48 89 d6             	mov    %rdx,%rsi
  8004206c0d:	48 89 c7             	mov    %rax,%rdi
  8004206c10:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  8004206c17:	00 00 00 
  8004206c1a:	ff d0                	callq  *%rax
  8004206c1c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206c20:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206c23:	e9 0f 01 00 00       	jmpq   8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata2:
		*val = dbg->read(data, offsetp, 2);
  8004206c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206c2c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206c30:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206c34:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206c38:	ba 02 00 00 00       	mov    $0x2,%edx
  8004206c3d:	48 89 cf             	mov    %rcx,%rdi
  8004206c40:	ff d0                	callq  *%rax
  8004206c42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206c46:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206c49:	e9 e9 00 00 00       	jmpq   8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata4:
		*val = dbg->read(data, offsetp, 4);
  8004206c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206c52:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206c56:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206c5a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206c5e:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206c63:	48 89 cf             	mov    %rcx,%rdi
  8004206c66:	ff d0                	callq  *%rax
  8004206c68:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206c6c:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206c6f:	e9 c3 00 00 00       	jmpq   8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata8:
		*val = dbg->read(data, offsetp, 8);
  8004206c74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206c78:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206c7c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206c80:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206c84:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206c89:	48 89 cf             	mov    %rcx,%rdi
  8004206c8c:	ff d0                	callq  *%rax
  8004206c8e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206c92:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206c95:	e9 9d 00 00 00       	jmpq   8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sleb128:
		*val = _dwarf_read_sleb128(data, offsetp);
  8004206c9a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206c9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206ca2:	48 89 d6             	mov    %rdx,%rsi
  8004206ca5:	48 89 c7             	mov    %rax,%rdi
  8004206ca8:	48 b8 61 3b 20 04 80 	movabs $0x8004203b61,%rax
  8004206caf:	00 00 00 
  8004206cb2:	ff d0                	callq  *%rax
  8004206cb4:	48 89 c2             	mov    %rax,%rdx
  8004206cb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206cbb:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206cbe:	eb 77                	jmp    8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata2:
		*val = (int16_t) dbg->read(data, offsetp, 2);
  8004206cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206cc4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206cc8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206ccc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206cd0:	ba 02 00 00 00       	mov    $0x2,%edx
  8004206cd5:	48 89 cf             	mov    %rcx,%rdi
  8004206cd8:	ff d0                	callq  *%rax
  8004206cda:	48 0f bf d0          	movswq %ax,%rdx
  8004206cde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206ce2:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206ce5:	eb 50                	jmp    8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata4:
		*val = (int32_t) dbg->read(data, offsetp, 4);
  8004206ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ceb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206cef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206cf3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206cf7:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206cfc:	48 89 cf             	mov    %rcx,%rdi
  8004206cff:	ff d0                	callq  *%rax
  8004206d01:	48 63 d0             	movslq %eax,%rdx
  8004206d04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206d08:	48 89 10             	mov    %rdx,(%rax)
		break;
  8004206d0b:	eb 2a                	jmp    8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata8:
		*val = dbg->read(data, offsetp, 8);
  8004206d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206d11:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206d15:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004206d19:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004206d1d:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206d22:	48 89 cf             	mov    %rcx,%rdi
  8004206d25:	ff d0                	callq  *%rax
  8004206d27:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004206d2b:	48 89 02             	mov    %rax,(%rdx)
		break;
  8004206d2e:	eb 07                	jmp    8004206d37 <_dwarf_frame_read_lsb_encoded+0x1c6>
	default:
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  8004206d30:	b8 14 00 00 00       	mov    $0x14,%eax
  8004206d35:	eb 52                	jmp    8004206d89 <_dwarf_frame_read_lsb_encoded+0x218>
	}

	if (application == DW_EH_PE_pcrel) {
  8004206d37:	80 7d ff 10          	cmpb   $0x10,-0x1(%rbp)
  8004206d3b:	75 47                	jne    8004206d84 <_dwarf_frame_read_lsb_encoded+0x213>
		/*
		 * Value is relative to .eh_frame section virtual addr.
		 */
		switch (encode) {
  8004206d3d:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  8004206d41:	83 f8 01             	cmp    $0x1,%eax
  8004206d44:	7c 3d                	jl     8004206d83 <_dwarf_frame_read_lsb_encoded+0x212>
  8004206d46:	83 f8 04             	cmp    $0x4,%eax
  8004206d49:	7e 0a                	jle    8004206d55 <_dwarf_frame_read_lsb_encoded+0x1e4>
  8004206d4b:	83 e8 09             	sub    $0x9,%eax
  8004206d4e:	83 f8 03             	cmp    $0x3,%eax
  8004206d51:	77 30                	ja     8004206d83 <_dwarf_frame_read_lsb_encoded+0x212>
  8004206d53:	eb 17                	jmp    8004206d6c <_dwarf_frame_read_lsb_encoded+0x1fb>
		case DW_EH_PE_uleb128:
		case DW_EH_PE_udata2:
		case DW_EH_PE_udata4:
		case DW_EH_PE_udata8:
			*val += pc;
  8004206d55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206d59:	48 8b 10             	mov    (%rax),%rdx
  8004206d5c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206d60:	48 01 c2             	add    %rax,%rdx
  8004206d63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206d67:	48 89 10             	mov    %rdx,(%rax)
			break;
  8004206d6a:	eb 18                	jmp    8004206d84 <_dwarf_frame_read_lsb_encoded+0x213>
		case DW_EH_PE_sleb128:
		case DW_EH_PE_sdata2:
		case DW_EH_PE_sdata4:
		case DW_EH_PE_sdata8:
			*val = pc + (int64_t) *val;
  8004206d6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206d70:	48 8b 10             	mov    (%rax),%rdx
  8004206d73:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206d77:	48 01 c2             	add    %rax,%rdx
  8004206d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206d7e:	48 89 10             	mov    %rdx,(%rax)
			break;
  8004206d81:	eb 01                	jmp    8004206d84 <_dwarf_frame_read_lsb_encoded+0x213>
		default:
			/* DW_EH_PE_absptr is absolute value. */
			break;
  8004206d83:	90                   	nop
		}
	}

	/* XXX Applications other than DW_EH_PE_pcrel are not handled. */

	return (DW_DLE_NONE);
  8004206d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206d89:	c9                   	leaveq 
  8004206d8a:	c3                   	retq   

0000008004206d8b <_dwarf_frame_parse_lsb_cie_augment>:

static int
_dwarf_frame_parse_lsb_cie_augment(Dwarf_Debug dbg, Dwarf_Cie cie,
				   Dwarf_Error *error)
{
  8004206d8b:	55                   	push   %rbp
  8004206d8c:	48 89 e5             	mov    %rsp,%rbp
  8004206d8f:	48 83 ec 50          	sub    $0x50,%rsp
  8004206d93:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004206d97:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004206d9b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	uint8_t *aug_p, *augdata_p;
	uint64_t val, offset;
	uint8_t encode;
	int ret;

	assert(cie->cie_augment != NULL && *cie->cie_augment == 'z');
  8004206d9f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206da3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206da7:	48 85 c0             	test   %rax,%rax
  8004206daa:	74 0f                	je     8004206dbb <_dwarf_frame_parse_lsb_cie_augment+0x30>
  8004206dac:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206db0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206db4:	0f b6 00             	movzbl (%rax),%eax
  8004206db7:	3c 7a                	cmp    $0x7a,%al
  8004206db9:	74 35                	je     8004206df0 <_dwarf_frame_parse_lsb_cie_augment+0x65>
  8004206dbb:	48 b9 28 a3 20 04 80 	movabs $0x800420a328,%rcx
  8004206dc2:	00 00 00 
  8004206dc5:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  8004206dcc:	00 00 00 
  8004206dcf:	be 4a 02 00 00       	mov    $0x24a,%esi
  8004206dd4:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004206ddb:	00 00 00 
  8004206dde:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206de3:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206dea:	00 00 00 
  8004206ded:	41 ff d0             	callq  *%r8
	/*
	 * Here we're only interested in the presence of augment 'R'
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
  8004206df0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206df4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206df8:	48 83 c0 01          	add    $0x1,%rax
  8004206dfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	augdata_p = cie->cie_augdata;
  8004206e00:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206e04:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004206e08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (*aug_p != '\0') {
  8004206e0c:	e9 af 00 00 00       	jmpq   8004206ec0 <_dwarf_frame_parse_lsb_cie_augment+0x135>
		switch (*aug_p) {
  8004206e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004206e15:	0f b6 00             	movzbl (%rax),%eax
  8004206e18:	0f b6 c0             	movzbl %al,%eax
  8004206e1b:	83 f8 50             	cmp    $0x50,%eax
  8004206e1e:	74 18                	je     8004206e38 <_dwarf_frame_parse_lsb_cie_augment+0xad>
  8004206e20:	83 f8 52             	cmp    $0x52,%eax
  8004206e23:	74 77                	je     8004206e9c <_dwarf_frame_parse_lsb_cie_augment+0x111>
  8004206e25:	83 f8 4c             	cmp    $0x4c,%eax
  8004206e28:	0f 85 86 00 00 00    	jne    8004206eb4 <_dwarf_frame_parse_lsb_cie_augment+0x129>
		case 'L':
			/* Skip one augment in augment data. */
			augdata_p++;
  8004206e2e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
			break;
  8004206e33:	e9 83 00 00 00       	jmpq   8004206ebb <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'P':
			/* Skip two augments in augment data. */
			encode = *augdata_p++;
  8004206e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206e3c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206e40:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8004206e44:	0f b6 00             	movzbl (%rax),%eax
  8004206e47:	88 45 ef             	mov    %al,-0x11(%rbp)
			offset = 0;
  8004206e4a:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8004206e51:	00 
			ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004206e52:	44 0f b6 45 ef       	movzbl -0x11(%rbp),%r8d
  8004206e57:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  8004206e5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004206e5f:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8004206e63:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206e67:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004206e6b:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004206e6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004206e75:	48 89 c7             	mov    %rax,%rdi
  8004206e78:	48 b8 71 6b 20 04 80 	movabs $0x8004206b71,%rax
  8004206e7f:	00 00 00 
  8004206e82:	ff d0                	callq  *%rax
  8004206e84:	89 45 e8             	mov    %eax,-0x18(%rbp)
							    augdata_p, &offset, encode, 0, error);
			if (ret != DW_DLE_NONE)
  8004206e87:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8004206e8b:	74 05                	je     8004206e92 <_dwarf_frame_parse_lsb_cie_augment+0x107>
				return (ret);
  8004206e8d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8004206e90:	eb 42                	jmp    8004206ed4 <_dwarf_frame_parse_lsb_cie_augment+0x149>
			augdata_p += offset;
  8004206e92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004206e96:	48 01 45 f0          	add    %rax,-0x10(%rbp)
			break;
  8004206e9a:	eb 1f                	jmp    8004206ebb <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'R':
			cie->cie_fde_encode = *augdata_p++;
  8004206e9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004206ea0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206ea4:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8004206ea8:	0f b6 10             	movzbl (%rax),%edx
  8004206eab:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004206eaf:	88 50 60             	mov    %dl,0x60(%rax)
			break;
  8004206eb2:	eb 07                	jmp    8004206ebb <_dwarf_frame_parse_lsb_cie_augment+0x130>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  8004206eb4:	b8 14 00 00 00       	mov    $0x14,%eax
  8004206eb9:	eb 19                	jmp    8004206ed4 <_dwarf_frame_parse_lsb_cie_augment+0x149>
		}
		aug_p++;
  8004206ebb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
	augdata_p = cie->cie_augdata;
	while (*aug_p != '\0') {
  8004206ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004206ec4:	0f b6 00             	movzbl (%rax),%eax
  8004206ec7:	84 c0                	test   %al,%al
  8004206ec9:	0f 85 42 ff ff ff    	jne    8004206e11 <_dwarf_frame_parse_lsb_cie_augment+0x86>
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		}
		aug_p++;
	}

	return (DW_DLE_NONE);
  8004206ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206ed4:	c9                   	leaveq 
  8004206ed5:	c3                   	retq   

0000008004206ed6 <_dwarf_frame_set_cie>:


static int
_dwarf_frame_set_cie(Dwarf_Debug dbg, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, Dwarf_Cie ret_cie, Dwarf_Error *error)
{
  8004206ed6:	55                   	push   %rbp
  8004206ed7:	48 89 e5             	mov    %rsp,%rbp
  8004206eda:	48 83 ec 60          	sub    $0x60,%rsp
  8004206ede:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004206ee2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004206ee6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004206eea:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  8004206eee:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
	Dwarf_Cie cie;
	uint64_t length;
	int dwarf_size, ret;
	char *p;

	assert(ret_cie);
  8004206ef2:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  8004206ef7:	75 35                	jne    8004206f2e <_dwarf_frame_set_cie+0x58>
  8004206ef9:	48 b9 5d a3 20 04 80 	movabs $0x800420a35d,%rcx
  8004206f00:	00 00 00 
  8004206f03:	48 ba a7 a1 20 04 80 	movabs $0x800420a1a7,%rdx
  8004206f0a:	00 00 00 
  8004206f0d:	be 7b 02 00 00       	mov    $0x27b,%esi
  8004206f12:	48 bf bc a1 20 04 80 	movabs $0x800420a1bc,%rdi
  8004206f19:	00 00 00 
  8004206f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206f21:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004206f28:	00 00 00 
  8004206f2b:	41 ff d0             	callq  *%r8
	cie = ret_cie;
  8004206f2e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004206f32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cie->cie_dbg = dbg;
  8004206f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206f3e:	48 89 10             	mov    %rdx,(%rax)
	cie->cie_offset = *off;
  8004206f41:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206f45:	48 8b 10             	mov    (%rax),%rdx
  8004206f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206f4c:	48 89 50 10          	mov    %rdx,0x10(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  8004206f50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206f54:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206f58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206f5c:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206f60:	48 89 d1             	mov    %rdx,%rcx
  8004206f63:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206f67:	ba 04 00 00 00       	mov    $0x4,%edx
  8004206f6c:	48 89 cf             	mov    %rcx,%rdi
  8004206f6f:	ff d0                	callq  *%rax
  8004206f71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  8004206f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004206f7a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8004206f7e:	75 2e                	jne    8004206fae <_dwarf_frame_set_cie+0xd8>
		dwarf_size = 8;
  8004206f80:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  8004206f87:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206f8b:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206f8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206f93:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206f97:	48 89 d1             	mov    %rdx,%rcx
  8004206f9a:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206f9e:	ba 08 00 00 00       	mov    $0x8,%edx
  8004206fa3:	48 89 cf             	mov    %rcx,%rdi
  8004206fa6:	ff d0                	callq  *%rax
  8004206fa8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004206fac:	eb 07                	jmp    8004206fb5 <_dwarf_frame_set_cie+0xdf>
	} else
		dwarf_size = 4;
  8004206fae:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  8004206fb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206fb9:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004206fbd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206fc1:	48 8b 00             	mov    (%rax),%rax
  8004206fc4:	48 29 c2             	sub    %rax,%rdx
  8004206fc7:	48 89 d0             	mov    %rdx,%rax
  8004206fca:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004206fce:	73 0a                	jae    8004206fda <_dwarf_frame_set_cie+0x104>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  8004206fd0:	b8 12 00 00 00       	mov    $0x12,%eax
  8004206fd5:	e9 5d 03 00 00       	jmpq   8004207337 <_dwarf_frame_set_cie+0x461>
	}

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
  8004206fda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206fde:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206fe2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004206fe6:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004206fea:	48 89 d1             	mov    %rdx,%rcx
  8004206fed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004206ff0:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004206ff4:	48 89 cf             	mov    %rcx,%rdi
  8004206ff7:	ff d0                	callq  *%rax
	cie->cie_length = length;
  8004206ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ffd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004207001:	48 89 50 18          	mov    %rdx,0x18(%rax)

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  8004207005:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207009:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420700d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207011:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207015:	48 89 d1             	mov    %rdx,%rcx
  8004207018:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420701c:	ba 01 00 00 00       	mov    $0x1,%edx
  8004207021:	48 89 cf             	mov    %rcx,%rdi
  8004207024:	ff d0                	callq  *%rax
  8004207026:	89 c2                	mov    %eax,%edx
  8004207028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420702c:	66 89 50 20          	mov    %dx,0x20(%rax)
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  8004207030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207034:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  8004207038:	66 83 f8 01          	cmp    $0x1,%ax
  800420703c:	74 26                	je     8004207064 <_dwarf_frame_set_cie+0x18e>
  800420703e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207042:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  8004207046:	66 83 f8 03          	cmp    $0x3,%ax
  800420704a:	74 18                	je     8004207064 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
  800420704c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207050:	0f b7 40 20          	movzwl 0x20(%rax),%eax

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
	cie->cie_length = length;

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  8004207054:	66 83 f8 04          	cmp    $0x4,%ax
  8004207058:	74 0a                	je     8004207064 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_VERSION_BAD);
		return (DW_DLE_FRAME_VERSION_BAD);
  800420705a:	b8 16 00 00 00       	mov    $0x16,%eax
  800420705f:	e9 d3 02 00 00       	jmpq   8004207337 <_dwarf_frame_set_cie+0x461>
	}

	cie->cie_augment = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004207064:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207068:	48 8b 10             	mov    (%rax),%rdx
  800420706b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420706f:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207073:	48 01 d0             	add    %rdx,%rax
  8004207076:	48 89 c2             	mov    %rax,%rdx
  8004207079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420707d:	48 89 50 28          	mov    %rdx,0x28(%rax)
	p = (char *)dbg->dbg_eh_offset;
  8004207081:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207085:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207089:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while (p[(*off)++] != '\0')
  800420708d:	90                   	nop
  800420708e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207092:	48 8b 00             	mov    (%rax),%rax
  8004207095:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8004207099:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420709d:	48 89 0a             	mov    %rcx,(%rdx)
  80042070a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042070a4:	48 01 d0             	add    %rdx,%rax
  80042070a7:	0f b6 00             	movzbl (%rax),%eax
  80042070aa:	84 c0                	test   %al,%al
  80042070ac:	75 e0                	jne    800420708e <_dwarf_frame_set_cie+0x1b8>
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
  80042070ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070b2:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042070b6:	0f b6 00             	movzbl (%rax),%eax
  80042070b9:	84 c0                	test   %al,%al
  80042070bb:	74 48                	je     8004207105 <_dwarf_frame_set_cie+0x22f>
  80042070bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070c1:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042070c5:	0f b6 00             	movzbl (%rax),%eax
  80042070c8:	3c 7a                	cmp    $0x7a,%al
  80042070ca:	74 39                	je     8004207105 <_dwarf_frame_set_cie+0x22f>
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  80042070cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042070d4:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  80042070d8:	75 07                	jne    80042070e1 <_dwarf_frame_set_cie+0x20b>
  80042070da:	b8 04 00 00 00       	mov    $0x4,%eax
  80042070df:	eb 05                	jmp    80042070e6 <_dwarf_frame_set_cie+0x210>
  80042070e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  80042070e6:	48 01 c2             	add    %rax,%rdx
			cie->cie_length;
  80042070e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042070ed:	48 8b 40 18          	mov    0x18(%rax),%rax
	while (p[(*off)++] != '\0')
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  80042070f1:	48 01 c2             	add    %rax,%rdx
  80042070f4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042070f8:	48 89 10             	mov    %rdx,(%rax)
			cie->cie_length;
		return (DW_DLE_NONE);
  80042070fb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207100:	e9 32 02 00 00       	jmpq   8004207337 <_dwarf_frame_set_cie+0x461>
	}

	/* Optional EH Data field for .eh_frame section. */
	if (strstr((char *)cie->cie_augment, "eh") != NULL)
  8004207105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207109:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420710d:	48 be 65 a3 20 04 80 	movabs $0x800420a365,%rsi
  8004207114:	00 00 00 
  8004207117:	48 89 c7             	mov    %rax,%rdi
  800420711a:	48 b8 18 35 20 04 80 	movabs $0x8004203518,%rax
  8004207121:	00 00 00 
  8004207124:	ff d0                	callq  *%rax
  8004207126:	48 85 c0             	test   %rax,%rax
  8004207129:	74 28                	je     8004207153 <_dwarf_frame_set_cie+0x27d>
		cie->cie_ehdata = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  800420712b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420712f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004207133:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207137:	8b 52 28             	mov    0x28(%rdx),%edx
  800420713a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420713e:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  8004207142:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  8004207146:	48 89 cf             	mov    %rcx,%rdi
  8004207149:	ff d0                	callq  *%rax
  800420714b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420714f:	48 89 42 30          	mov    %rax,0x30(%rdx)
					    dbg->dbg_pointer_size);

	cie->cie_caf = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004207153:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207157:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420715b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420715f:	48 89 d6             	mov    %rdx,%rsi
  8004207162:	48 89 c7             	mov    %rax,%rdi
  8004207165:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  800420716c:	00 00 00 
  800420716f:	ff d0                	callq  *%rax
  8004207171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207175:	48 89 42 38          	mov    %rax,0x38(%rdx)
	cie->cie_daf = _dwarf_read_sleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004207179:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420717d:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207181:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004207185:	48 89 d6             	mov    %rdx,%rsi
  8004207188:	48 89 c7             	mov    %rax,%rdi
  800420718b:	48 b8 61 3b 20 04 80 	movabs $0x8004203b61,%rax
  8004207192:	00 00 00 
  8004207195:	ff d0                	callq  *%rax
  8004207197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420719b:	48 89 42 40          	mov    %rax,0x40(%rdx)

	/* Return address register. */
	if (cie->cie_version == 1)
  800420719f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071a3:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  80042071a7:	66 83 f8 01          	cmp    $0x1,%ax
  80042071ab:	75 2b                	jne    80042071d8 <_dwarf_frame_set_cie+0x302>
		cie->cie_ra = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  80042071ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042071b1:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042071b5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042071b9:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042071bd:	48 89 d1             	mov    %rdx,%rcx
  80042071c0:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  80042071c4:	ba 01 00 00 00       	mov    $0x1,%edx
  80042071c9:	48 89 cf             	mov    %rcx,%rdi
  80042071cc:	ff d0                	callq  *%rax
  80042071ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042071d2:	48 89 42 48          	mov    %rax,0x48(%rdx)
  80042071d6:	eb 26                	jmp    80042071fe <_dwarf_frame_set_cie+0x328>
	else
		cie->cie_ra = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  80042071d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042071dc:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042071e0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80042071e4:	48 89 d6             	mov    %rdx,%rsi
  80042071e7:	48 89 c7             	mov    %rax,%rdi
  80042071ea:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  80042071f1:	00 00 00 
  80042071f4:	ff d0                	callq  *%rax
  80042071f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042071fa:	48 89 42 48          	mov    %rax,0x48(%rdx)

	/* Optional CIE augmentation data for .eh_frame section. */
	if (*cie->cie_augment == 'z') {
  80042071fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207202:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004207206:	0f b6 00             	movzbl (%rax),%eax
  8004207209:	3c 7a                	cmp    $0x7a,%al
  800420720b:	0f 85 93 00 00 00    	jne    80042072a4 <_dwarf_frame_set_cie+0x3ce>
		cie->cie_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  8004207211:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207215:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207219:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420721d:	48 89 d6             	mov    %rdx,%rsi
  8004207220:	48 89 c7             	mov    %rax,%rdi
  8004207223:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  800420722a:	00 00 00 
  800420722d:	ff d0                	callq  *%rax
  800420722f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207233:	48 89 42 50          	mov    %rax,0x50(%rdx)
		cie->cie_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004207237:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420723b:	48 8b 10             	mov    (%rax),%rdx
  800420723e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207242:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207246:	48 01 d0             	add    %rdx,%rax
  8004207249:	48 89 c2             	mov    %rax,%rdx
  800420724c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207250:	48 89 50 58          	mov    %rdx,0x58(%rax)
		*off += cie->cie_auglen;
  8004207254:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207258:	48 8b 10             	mov    (%rax),%rdx
  800420725b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420725f:	48 8b 40 50          	mov    0x50(%rax),%rax
  8004207263:	48 01 c2             	add    %rax,%rdx
  8004207266:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420726a:	48 89 10             	mov    %rdx,(%rax)
		/*
		 * XXX Use DW_EH_PE_absptr for default FDE PC start/range,
		 * in case _dwarf_frame_parse_lsb_cie_augment fails to
		 * find out the real encode.
		 */
		cie->cie_fde_encode = DW_EH_PE_absptr;
  800420726d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207271:	c6 40 60 00          	movb   $0x0,0x60(%rax)
		ret = _dwarf_frame_parse_lsb_cie_augment(dbg, cie, error);
  8004207275:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004207279:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420727d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207281:	48 89 ce             	mov    %rcx,%rsi
  8004207284:	48 89 c7             	mov    %rax,%rdi
  8004207287:	48 b8 8b 6d 20 04 80 	movabs $0x8004206d8b,%rax
  800420728e:	00 00 00 
  8004207291:	ff d0                	callq  *%rax
  8004207293:	89 45 dc             	mov    %eax,-0x24(%rbp)
		if (ret != DW_DLE_NONE)
  8004207296:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420729a:	74 08                	je     80042072a4 <_dwarf_frame_set_cie+0x3ce>
			return (ret);
  800420729c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420729f:	e9 93 00 00 00       	jmpq   8004207337 <_dwarf_frame_set_cie+0x461>
	}

	/* CIE Initial instructions. */
	cie->cie_initinst = (uint8_t *)dbg->dbg_eh_offset + *off;
  80042072a4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042072a8:	48 8b 10             	mov    (%rax),%rdx
  80042072ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042072af:	48 8b 40 38          	mov    0x38(%rax),%rax
  80042072b3:	48 01 d0             	add    %rdx,%rax
  80042072b6:	48 89 c2             	mov    %rax,%rdx
  80042072b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072bd:	48 89 50 68          	mov    %rdx,0x68(%rax)
	if (dwarf_size == 4)
  80042072c1:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  80042072c5:	75 2a                	jne    80042072f1 <_dwarf_frame_set_cie+0x41b>
		cie->cie_instlen = cie->cie_offset + 4 + length - *off;
  80042072c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042072cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042072d3:	48 01 c2             	add    %rax,%rdx
  80042072d6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042072da:	48 8b 00             	mov    (%rax),%rax
  80042072dd:	48 29 c2             	sub    %rax,%rdx
  80042072e0:	48 89 d0             	mov    %rdx,%rax
  80042072e3:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80042072e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072eb:	48 89 50 70          	mov    %rdx,0x70(%rax)
  80042072ef:	eb 28                	jmp    8004207319 <_dwarf_frame_set_cie+0x443>
	else
		cie->cie_instlen = cie->cie_offset + 12 + length - *off;
  80042072f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042072f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042072fd:	48 01 c2             	add    %rax,%rdx
  8004207300:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207304:	48 8b 00             	mov    (%rax),%rax
  8004207307:	48 29 c2             	sub    %rax,%rdx
  800420730a:	48 89 d0             	mov    %rdx,%rax
  800420730d:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  8004207311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207315:	48 89 50 70          	mov    %rdx,0x70(%rax)

	*off += cie->cie_instlen;
  8004207319:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420731d:	48 8b 10             	mov    (%rax),%rdx
  8004207320:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207324:	48 8b 40 70          	mov    0x70(%rax),%rax
  8004207328:	48 01 c2             	add    %rax,%rdx
  800420732b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420732f:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  8004207332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004207337:	c9                   	leaveq 
  8004207338:	c3                   	retq   

0000008004207339 <_dwarf_frame_set_fde>:

static int
_dwarf_frame_set_fde(Dwarf_Debug dbg, Dwarf_Fde ret_fde, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, int eh_frame, Dwarf_Cie cie, Dwarf_Error *error)
{
  8004207339:	55                   	push   %rbp
  800420733a:	48 89 e5             	mov    %rsp,%rbp
  800420733d:	48 83 ec 70          	sub    $0x70,%rsp
  8004207341:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004207345:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004207349:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800420734d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  8004207351:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
  8004207355:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Fde fde;
	Dwarf_Unsigned cieoff;
	uint64_t length, val;
	int dwarf_size, ret;

	fde = ret_fde;
  8004207359:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420735d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	fde->fde_dbg = dbg;
  8004207361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207365:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207369:	48 89 10             	mov    %rdx,(%rax)
	fde->fde_addr = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420736c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207370:	48 8b 10             	mov    (%rax),%rdx
  8004207373:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207377:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420737b:	48 01 d0             	add    %rdx,%rax
  800420737e:	48 89 c2             	mov    %rax,%rdx
  8004207381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207385:	48 89 50 10          	mov    %rdx,0x10(%rax)
	fde->fde_offset = *off;
  8004207389:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420738d:	48 8b 10             	mov    (%rax),%rdx
  8004207390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207394:	48 89 50 18          	mov    %rdx,0x18(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  8004207398:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420739c:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042073a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042073a4:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042073a8:	48 89 d1             	mov    %rdx,%rcx
  80042073ab:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042073af:	ba 04 00 00 00       	mov    $0x4,%edx
  80042073b4:	48 89 cf             	mov    %rcx,%rdi
  80042073b7:	ff d0                	callq  *%rax
  80042073b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  80042073bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042073c2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80042073c6:	75 2e                	jne    80042073f6 <_dwarf_frame_set_fde+0xbd>
		dwarf_size = 8;
  80042073c8:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  80042073cf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042073d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042073d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042073db:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042073df:	48 89 d1             	mov    %rdx,%rcx
  80042073e2:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042073e6:	ba 08 00 00 00       	mov    $0x8,%edx
  80042073eb:	48 89 cf             	mov    %rcx,%rdi
  80042073ee:	ff d0                	callq  *%rax
  80042073f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042073f4:	eb 07                	jmp    80042073fd <_dwarf_frame_set_fde+0xc4>
	} else
		dwarf_size = 4;
  80042073f6:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  80042073fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207401:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004207405:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207409:	48 8b 00             	mov    (%rax),%rax
  800420740c:	48 29 c2             	sub    %rax,%rdx
  800420740f:	48 89 d0             	mov    %rdx,%rax
  8004207412:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004207416:	73 0a                	jae    8004207422 <_dwarf_frame_set_fde+0xe9>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  8004207418:	b8 12 00 00 00       	mov    $0x12,%eax
  800420741d:	e9 ca 02 00 00       	jmpq   80042076ec <_dwarf_frame_set_fde+0x3b3>
	}

	fde->fde_length = length;
  8004207422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207426:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420742a:	48 89 50 20          	mov    %rdx,0x20(%rax)

	if (eh_frame) {
  800420742e:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004207432:	74 5e                	je     8004207492 <_dwarf_frame_set_fde+0x159>
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  8004207434:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207438:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420743c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207440:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207444:	48 89 d1             	mov    %rdx,%rcx
  8004207447:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420744b:	ba 04 00 00 00       	mov    $0x4,%edx
  8004207450:	48 89 cf             	mov    %rcx,%rdi
  8004207453:	ff d0                	callq  *%rax
  8004207455:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207459:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = *off - (4 + fde->fde_cieoff);
  800420745d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207461:	48 8b 10             	mov    (%rax),%rdx
  8004207464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207468:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420746c:	48 29 c2             	sub    %rax,%rdx
  800420746f:	48 89 d0             	mov    %rdx,%rax
  8004207472:	48 83 e8 04          	sub    $0x4,%rax
  8004207476:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		/* This delta should never be 0. */
		if (cieoff == fde->fde_offset) {
  800420747a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420747e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004207482:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004207486:	75 3d                	jne    80042074c5 <_dwarf_frame_set_fde+0x18c>
			DWARF_SET_ERROR(dbg, error, DW_DLE_NO_CIE_FOR_FDE);
			return (DW_DLE_NO_CIE_FOR_FDE);
  8004207488:	b8 13 00 00 00       	mov    $0x13,%eax
  800420748d:	e9 5a 02 00 00       	jmpq   80042076ec <_dwarf_frame_set_fde+0x3b3>
		}
	} else {
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size);
  8004207492:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207496:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420749a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420749e:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042074a2:	48 89 d1             	mov    %rdx,%rcx
  80042074a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042074a8:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042074ac:	48 89 cf             	mov    %rcx,%rdi
  80042074af:	ff d0                	callq  *%rax
  80042074b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042074b5:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = fde->fde_cieoff;
  80042074b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042074bd:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042074c1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	}

	if (eh_frame) {
  80042074c5:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80042074c9:	0f 84 c9 00 00 00    	je     8004207598 <_dwarf_frame_set_fde+0x25f>
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  80042074cf:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042074d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042074d7:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042074db:	48 8b 00             	mov    (%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  80042074de:	4c 8d 0c 02          	lea    (%rdx,%rax,1),%r9
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  80042074e2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042074e6:	0f b6 40 60          	movzbl 0x60(%rax),%eax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  80042074ea:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  80042074ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042074f2:	48 8b 40 38          	mov    0x38(%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  80042074f6:	48 89 c2             	mov    %rax,%rdx
  80042074f9:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  80042074fd:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8004207501:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207505:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8004207509:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420750d:	48 89 c7             	mov    %rax,%rdi
  8004207510:	48 b8 71 6b 20 04 80 	movabs $0x8004206b71,%rax
  8004207517:	00 00 00 
  800420751a:	ff d0                	callq  *%rax
  800420751c:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
		if (ret != DW_DLE_NONE)
  800420751f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004207523:	74 08                	je     800420752d <_dwarf_frame_set_fde+0x1f4>
			return (ret);
  8004207525:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004207528:	e9 bf 01 00 00       	jmpq   80042076ec <_dwarf_frame_set_fde+0x3b3>
		fde->fde_initloc = val;
  800420752d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207535:	48 89 50 30          	mov    %rdx,0x30(%rax)
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
  8004207539:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420753d:	0f b6 40 60          	movzbl 0x60(%rax),%eax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  8004207541:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  8004207545:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207549:	48 8b 40 38          	mov    0x38(%rax),%rax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420754d:	48 89 c2             	mov    %rax,%rdx
  8004207550:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  8004207554:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8004207558:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420755c:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8004207560:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004207564:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420756a:	48 89 c7             	mov    %rax,%rdi
  800420756d:	48 b8 71 6b 20 04 80 	movabs $0x8004206b71,%rax
  8004207574:	00 00 00 
  8004207577:	ff d0                	callq  *%rax
  8004207579:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
		if (ret != DW_DLE_NONE)
  800420757c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004207580:	74 08                	je     800420758a <_dwarf_frame_set_fde+0x251>
			return (ret);
  8004207582:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004207585:	e9 62 01 00 00       	jmpq   80042076ec <_dwarf_frame_set_fde+0x3b3>
		fde->fde_adrange = val;
  800420758a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420758e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207592:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004207596:	eb 50                	jmp    80042075e8 <_dwarf_frame_set_fde+0x2af>
	} else {
		fde->fde_initloc = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  8004207598:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420759c:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042075a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042075a4:	8b 52 28             	mov    0x28(%rdx),%edx
  80042075a7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80042075ab:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  80042075af:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042075b3:	48 89 cf             	mov    %rcx,%rdi
  80042075b6:	ff d0                	callq  *%rax
  80042075b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042075bc:	48 89 42 30          	mov    %rax,0x30(%rdx)
					     dbg->dbg_pointer_size);
		fde->fde_adrange = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  80042075c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042075c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042075c8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042075cc:	8b 52 28             	mov    0x28(%rdx),%edx
  80042075cf:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80042075d3:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  80042075d7:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042075db:	48 89 cf             	mov    %rcx,%rdi
  80042075de:	ff d0                	callq  *%rax
  80042075e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042075e4:	48 89 42 38          	mov    %rax,0x38(%rdx)
					     dbg->dbg_pointer_size);
	}

	/* Optional FDE augmentation data for .eh_frame section. (ignored) */
	if (eh_frame && *cie->cie_augment == 'z') {
  80042075e8:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80042075ec:	74 6b                	je     8004207659 <_dwarf_frame_set_fde+0x320>
  80042075ee:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042075f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042075f6:	0f b6 00             	movzbl (%rax),%eax
  80042075f9:	3c 7a                	cmp    $0x7a,%al
  80042075fb:	75 5c                	jne    8004207659 <_dwarf_frame_set_fde+0x320>
		fde->fde_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  80042075fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207601:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207605:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004207609:	48 89 d6             	mov    %rdx,%rsi
  800420760c:	48 89 c7             	mov    %rax,%rdi
  800420760f:	48 b8 05 3c 20 04 80 	movabs $0x8004203c05,%rax
  8004207616:	00 00 00 
  8004207619:	ff d0                	callq  *%rax
  800420761b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420761f:	48 89 42 40          	mov    %rax,0x40(%rdx)
		fde->fde_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004207623:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207627:	48 8b 10             	mov    (%rax),%rdx
  800420762a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420762e:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207632:	48 01 d0             	add    %rdx,%rax
  8004207635:	48 89 c2             	mov    %rax,%rdx
  8004207638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420763c:	48 89 50 48          	mov    %rdx,0x48(%rax)
		*off += fde->fde_auglen;
  8004207640:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207644:	48 8b 10             	mov    (%rax),%rdx
  8004207647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420764b:	48 8b 40 40          	mov    0x40(%rax),%rax
  800420764f:	48 01 c2             	add    %rax,%rdx
  8004207652:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207656:	48 89 10             	mov    %rdx,(%rax)
	}

	fde->fde_inst = (uint8_t *)dbg->dbg_eh_offset + *off;
  8004207659:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420765d:	48 8b 10             	mov    (%rax),%rdx
  8004207660:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207664:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004207668:	48 01 d0             	add    %rdx,%rax
  800420766b:	48 89 c2             	mov    %rax,%rdx
  800420766e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207672:	48 89 50 50          	mov    %rdx,0x50(%rax)
	if (dwarf_size == 4)
  8004207676:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420767a:	75 2a                	jne    80042076a6 <_dwarf_frame_set_fde+0x36d>
		fde->fde_instlen = fde->fde_offset + 4 + length - *off;
  800420767c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207680:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004207684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207688:	48 01 c2             	add    %rax,%rdx
  800420768b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420768f:	48 8b 00             	mov    (%rax),%rax
  8004207692:	48 29 c2             	sub    %rax,%rdx
  8004207695:	48 89 d0             	mov    %rdx,%rax
  8004207698:	48 8d 50 04          	lea    0x4(%rax),%rdx
  800420769c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042076a0:	48 89 50 58          	mov    %rdx,0x58(%rax)
  80042076a4:	eb 28                	jmp    80042076ce <_dwarf_frame_set_fde+0x395>
	else
		fde->fde_instlen = fde->fde_offset + 12 + length - *off;
  80042076a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042076aa:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042076ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042076b2:	48 01 c2             	add    %rax,%rdx
  80042076b5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042076b9:	48 8b 00             	mov    (%rax),%rax
  80042076bc:	48 29 c2             	sub    %rax,%rdx
  80042076bf:	48 89 d0             	mov    %rdx,%rax
  80042076c2:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  80042076c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042076ca:	48 89 50 58          	mov    %rdx,0x58(%rax)

	*off += fde->fde_instlen;
  80042076ce:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042076d2:	48 8b 10             	mov    (%rax),%rdx
  80042076d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042076d9:	48 8b 40 58          	mov    0x58(%rax),%rax
  80042076dd:	48 01 c2             	add    %rax,%rdx
  80042076e0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042076e4:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  80042076e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042076ec:	c9                   	leaveq 
  80042076ed:	c3                   	retq   

00000080042076ee <_dwarf_frame_interal_table_init>:


int
_dwarf_frame_interal_table_init(Dwarf_Debug dbg, Dwarf_Error *error)
{
  80042076ee:	55                   	push   %rbp
  80042076ef:	48 89 e5             	mov    %rsp,%rbp
  80042076f2:	48 83 ec 20          	sub    $0x20,%rsp
  80042076f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042076fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	Dwarf_Regtable3 *rt = &global_rt_table;
  80042076fe:	48 b8 e0 cc 21 04 80 	movabs $0x800421cce0,%rax
  8004207705:	00 00 00 
  8004207708:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (dbg->dbg_internal_reg_table != NULL)
  800420770c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207710:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004207714:	48 85 c0             	test   %rax,%rax
  8004207717:	74 07                	je     8004207720 <_dwarf_frame_interal_table_init+0x32>
		return (DW_DLE_NONE);
  8004207719:	b8 00 00 00 00       	mov    $0x0,%eax
  800420771e:	eb 33                	jmp    8004207753 <_dwarf_frame_interal_table_init+0x65>

	rt->rt3_reg_table_size = dbg->dbg_frame_rule_table_size;
  8004207720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207724:	0f b7 50 48          	movzwl 0x48(%rax),%edx
  8004207728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420772c:	66 89 50 18          	mov    %dx,0x18(%rax)
	rt->rt3_rules = global_rules;
  8004207730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207734:	48 b9 00 d5 21 04 80 	movabs $0x800421d500,%rcx
  800420773b:	00 00 00 
  800420773e:	48 89 48 20          	mov    %rcx,0x20(%rax)

	dbg->dbg_internal_reg_table = rt;
  8004207742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207746:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420774a:	48 89 50 58          	mov    %rdx,0x58(%rax)

	return (DW_DLE_NONE);
  800420774e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004207753:	c9                   	leaveq 
  8004207754:	c3                   	retq   

0000008004207755 <_dwarf_get_next_fde>:

static int
_dwarf_get_next_fde(Dwarf_Debug dbg,
		    int eh_frame, Dwarf_Error *error, Dwarf_Fde ret_fde)
{
  8004207755:	55                   	push   %rbp
  8004207756:	48 89 e5             	mov    %rsp,%rbp
  8004207759:	48 83 ec 60          	sub    $0x60,%rsp
  800420775d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004207761:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8004207764:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004207768:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	Dwarf_Section *ds = &debug_frame_sec; 
  800420776c:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  8004207773:	00 00 00 
  8004207776:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint64_t length, offset, cie_id, entry_off;
	int dwarf_size, i, ret=-1;
  800420777a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%rbp)

	offset = dbg->curr_off_eh;
  8004207781:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207785:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004207789:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (offset < dbg->dbg_eh_size) {
  800420778d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207791:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004207795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004207799:	48 39 c2             	cmp    %rax,%rdx
  800420779c:	0f 86 fe 01 00 00    	jbe    80042079a0 <_dwarf_get_next_fde+0x24b>
		entry_off = offset;
  80042077a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042077a6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 4);
  80042077aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042077ae:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042077b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042077b6:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042077ba:	48 89 d1             	mov    %rdx,%rcx
  80042077bd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80042077c1:	ba 04 00 00 00       	mov    $0x4,%edx
  80042077c6:	48 89 cf             	mov    %rcx,%rdi
  80042077c9:	ff d0                	callq  *%rax
  80042077cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (length == 0xffffffff) {
  80042077cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042077d4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80042077d8:	75 2e                	jne    8004207808 <_dwarf_get_next_fde+0xb3>
			dwarf_size = 8;
  80042077da:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
			length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 8);
  80042077e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042077e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042077e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042077ed:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  80042077f1:	48 89 d1             	mov    %rdx,%rcx
  80042077f4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80042077f8:	ba 08 00 00 00       	mov    $0x8,%edx
  80042077fd:	48 89 cf             	mov    %rcx,%rdi
  8004207800:	ff d0                	callq  *%rax
  8004207802:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004207806:	eb 07                	jmp    800420780f <_dwarf_get_next_fde+0xba>
		} else
			dwarf_size = 4;
  8004207808:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

		if (length > dbg->dbg_eh_size - offset || (length == 0 && !eh_frame)) {
  800420780f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207813:	48 8b 50 40          	mov    0x40(%rax),%rdx
  8004207817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420781b:	48 29 c2             	sub    %rax,%rdx
  800420781e:	48 89 d0             	mov    %rdx,%rax
  8004207821:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004207825:	72 0d                	jb     8004207834 <_dwarf_get_next_fde+0xdf>
  8004207827:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420782c:	75 10                	jne    800420783e <_dwarf_get_next_fde+0xe9>
  800420782e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004207832:	75 0a                	jne    800420783e <_dwarf_get_next_fde+0xe9>
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_DEBUG_FRAME_LENGTH_BAD);
			return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  8004207834:	b8 12 00 00 00       	mov    $0x12,%eax
  8004207839:	e9 67 01 00 00       	jmpq   80042079a5 <_dwarf_get_next_fde+0x250>
		}

		/* Check terminator for .eh_frame */
		if (eh_frame && length == 0)
  800420783e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004207842:	74 11                	je     8004207855 <_dwarf_get_next_fde+0x100>
  8004207844:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004207849:	75 0a                	jne    8004207855 <_dwarf_get_next_fde+0x100>
			return(-1);
  800420784b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207850:	e9 50 01 00 00       	jmpq   80042079a5 <_dwarf_get_next_fde+0x250>

		cie_id = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, dwarf_size);
  8004207855:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207859:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420785d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207861:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  8004207865:	48 89 d1             	mov    %rdx,%rcx
  8004207868:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420786b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800420786f:	48 89 cf             	mov    %rcx,%rdi
  8004207872:	ff d0                	callq  *%rax
  8004207874:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

		if (eh_frame) {
  8004207878:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800420787c:	74 79                	je     80042078f7 <_dwarf_get_next_fde+0x1a2>
			/* GNU .eh_frame use CIE id 0. */
			if (cie_id == 0)
  800420787e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004207883:	75 32                	jne    80042078b7 <_dwarf_get_next_fde+0x162>
				ret = _dwarf_frame_set_cie(dbg, ds,
  8004207885:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207889:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420788d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004207891:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8004207895:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  8004207899:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420789d:	49 89 f8             	mov    %rdi,%r8
  80042078a0:	48 89 c7             	mov    %rax,%rdi
  80042078a3:	48 b8 d6 6e 20 04 80 	movabs $0x8004206ed6,%rax
  80042078aa:	00 00 00 
  80042078ad:	ff d0                	callq  *%rax
  80042078af:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80042078b2:	e9 c8 00 00 00       	jmpq   800420797f <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg,ret_fde, ds,
  80042078b7:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042078bb:	4c 8b 40 08          	mov    0x8(%rax),%r8
  80042078bf:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  80042078c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042078c7:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042078cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042078cf:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80042078d3:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042078d7:	4d 89 c1             	mov    %r8,%r9
  80042078da:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  80042078e0:	48 89 c7             	mov    %rax,%rdi
  80042078e3:	48 b8 39 73 20 04 80 	movabs $0x8004207339,%rax
  80042078ea:	00 00 00 
  80042078ed:	ff d0                	callq  *%rax
  80042078ef:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80042078f2:	e9 88 00 00 00       	jmpq   800420797f <_dwarf_get_next_fde+0x22a>
							   &entry_off, 1, ret_fde->fde_cie, error);
		} else {
			/* .dwarf_frame use CIE id ~0 */
			if ((dwarf_size == 4 && cie_id == ~0U) ||
  80042078f7:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  80042078fb:	75 0b                	jne    8004207908 <_dwarf_get_next_fde+0x1b3>
  80042078fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207902:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8004207906:	74 0d                	je     8004207915 <_dwarf_get_next_fde+0x1c0>
  8004207908:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  800420790c:	75 36                	jne    8004207944 <_dwarf_get_next_fde+0x1ef>
			    (dwarf_size == 8 && cie_id == ~0ULL))
  800420790e:	48 83 7d e0 ff       	cmpq   $0xffffffffffffffff,-0x20(%rbp)
  8004207913:	75 2f                	jne    8004207944 <_dwarf_get_next_fde+0x1ef>
				ret = _dwarf_frame_set_cie(dbg, ds,
  8004207915:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207919:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420791d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004207921:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8004207925:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  8004207929:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420792d:	49 89 f8             	mov    %rdi,%r8
  8004207930:	48 89 c7             	mov    %rax,%rdi
  8004207933:	48 b8 d6 6e 20 04 80 	movabs $0x8004206ed6,%rax
  800420793a:	00 00 00 
  800420793d:	ff d0                	callq  *%rax
  800420793f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8004207942:	eb 3b                	jmp    800420797f <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg, ret_fde, ds,
  8004207944:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004207948:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420794c:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  8004207950:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207954:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  8004207958:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420795c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8004207960:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004207964:	4d 89 c1             	mov    %r8,%r9
  8004207967:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800420796d:	48 89 c7             	mov    %rax,%rdi
  8004207970:	48 b8 39 73 20 04 80 	movabs $0x8004207339,%rax
  8004207977:	00 00 00 
  800420797a:	ff d0                	callq  *%rax
  800420797c:	89 45 f0             	mov    %eax,-0x10(%rbp)
							   &entry_off, 0, ret_fde->fde_cie, error);
		}

		if (ret != DW_DLE_NONE)
  800420797f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8004207983:	74 07                	je     800420798c <_dwarf_get_next_fde+0x237>
			return(-1);
  8004207985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420798a:	eb 19                	jmp    80042079a5 <_dwarf_get_next_fde+0x250>

		offset = entry_off;
  800420798c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004207990:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		dbg->curr_off_eh = offset;
  8004207994:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004207998:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420799c:	48 89 50 30          	mov    %rdx,0x30(%rax)
	}

	return (0);
  80042079a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042079a5:	c9                   	leaveq 
  80042079a6:	c3                   	retq   

00000080042079a7 <dwarf_set_frame_cfa_value>:

Dwarf_Half
dwarf_set_frame_cfa_value(Dwarf_Debug dbg, Dwarf_Half value)
{
  80042079a7:	55                   	push   %rbp
  80042079a8:	48 89 e5             	mov    %rsp,%rbp
  80042079ab:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042079af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042079b3:	89 f0                	mov    %esi,%eax
  80042079b5:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Half old_value;

	old_value = dbg->dbg_frame_cfa_value;
  80042079b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042079bd:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  80042079c1:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
	dbg->dbg_frame_cfa_value = value;
  80042079c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042079c9:	0f b7 55 e4          	movzwl -0x1c(%rbp),%edx
  80042079cd:	66 89 50 4c          	mov    %dx,0x4c(%rax)

	return (old_value);
  80042079d1:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
}
  80042079d5:	c9                   	leaveq 
  80042079d6:	c3                   	retq   

00000080042079d7 <dwarf_init_eh_section>:

int dwarf_init_eh_section(Dwarf_Debug dbg, Dwarf_Error *error)
{
  80042079d7:	55                   	push   %rbp
  80042079d8:	48 89 e5             	mov    %rsp,%rbp
  80042079db:	48 83 ec 10          	sub    $0x10,%rsp
  80042079df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042079e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	Dwarf_Section *section;

	if (dbg == NULL) {
  80042079e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042079ec:	75 0a                	jne    80042079f8 <dwarf_init_eh_section+0x21>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  80042079ee:	b8 01 00 00 00       	mov    $0x1,%eax
  80042079f3:	e9 85 00 00 00       	jmpq   8004207a7d <dwarf_init_eh_section+0xa6>
	}

	if (dbg->dbg_internal_reg_table == NULL) {
  80042079f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042079fc:	48 8b 40 58          	mov    0x58(%rax),%rax
  8004207a00:	48 85 c0             	test   %rax,%rax
  8004207a03:	75 25                	jne    8004207a2a <dwarf_init_eh_section+0x53>
		if (_dwarf_frame_interal_table_init(dbg, error) != DW_DLE_NONE)
  8004207a05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004207a09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207a0d:	48 89 d6             	mov    %rdx,%rsi
  8004207a10:	48 89 c7             	mov    %rax,%rdi
  8004207a13:	48 b8 ee 76 20 04 80 	movabs $0x80042076ee,%rax
  8004207a1a:	00 00 00 
  8004207a1d:	ff d0                	callq  *%rax
  8004207a1f:	85 c0                	test   %eax,%eax
  8004207a21:	74 07                	je     8004207a2a <dwarf_init_eh_section+0x53>
			return (DW_DLV_ERROR);
  8004207a23:	b8 01 00 00 00       	mov    $0x1,%eax
  8004207a28:	eb 53                	jmp    8004207a7d <dwarf_init_eh_section+0xa6>
	}

	_dwarf_find_section_enhanced(&debug_frame_sec);
  8004207a2a:	48 bf e0 c5 21 04 80 	movabs $0x800421c5e0,%rdi
  8004207a31:	00 00 00 
  8004207a34:	48 b8 a3 54 20 04 80 	movabs $0x80042054a3,%rax
  8004207a3b:	00 00 00 
  8004207a3e:	ff d0                	callq  *%rax

	dbg->curr_off_eh = 0;
  8004207a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207a44:	48 c7 40 30 00 00 00 	movq   $0x0,0x30(%rax)
  8004207a4b:	00 
	dbg->dbg_eh_offset = debug_frame_sec.ds_addr;
  8004207a4c:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  8004207a53:	00 00 00 
  8004207a56:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207a5e:	48 89 50 38          	mov    %rdx,0x38(%rax)
	dbg->dbg_eh_size = debug_frame_sec.ds_size;
  8004207a62:	48 b8 e0 c5 21 04 80 	movabs $0x800421c5e0,%rax
  8004207a69:	00 00 00 
  8004207a6c:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004207a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207a74:	48 89 50 40          	mov    %rdx,0x40(%rax)

	return (DW_DLV_OK);
  8004207a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004207a7d:	c9                   	leaveq 
  8004207a7e:	c3                   	retq   

0000008004207a7f <_dwarf_lineno_run_program>:
int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

static int
_dwarf_lineno_run_program(Dwarf_CU *cu, Dwarf_LineInfo li, uint8_t *p,
			  uint8_t *pe, Dwarf_Addr pc, Dwarf_Error *error)
{
  8004207a7f:	55                   	push   %rbp
  8004207a80:	48 89 e5             	mov    %rsp,%rbp
  8004207a83:	53                   	push   %rbx
  8004207a84:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8004207a8b:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8004207a8f:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8004207a93:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  8004207a9a:	48 89 8d 70 ff ff ff 	mov    %rcx,-0x90(%rbp)
  8004207aa1:	4c 89 85 68 ff ff ff 	mov    %r8,-0x98(%rbp)
  8004207aa8:	4c 89 8d 60 ff ff ff 	mov    %r9,-0xa0(%rbp)
	uint64_t address, file, line, column, isa, opsize;
	int is_stmt, basic_block, end_sequence;
	int prologue_end, epilogue_begin;
	int ret;

	ln = &li->li_line;
  8004207aaf:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207ab3:	48 83 c0 48          	add    $0x48,%rax
  8004207ab7:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	/*
	 *   ln->ln_li     = li;             \
	 * Set registers to their default values.
	 */
	RESET_REGISTERS;
  8004207abb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004207ac2:	00 
  8004207ac3:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  8004207aca:	00 
  8004207acb:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  8004207ad2:	00 
  8004207ad3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8004207ada:	00 
  8004207adb:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207adf:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004207ae3:	0f b6 c0             	movzbl %al,%eax
  8004207ae6:	89 45 cc             	mov    %eax,-0x34(%rbp)
  8004207ae9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  8004207af0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  8004207af7:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  8004207afe:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  8004207b05:	e9 0a 05 00 00       	jmpq   8004208014 <_dwarf_lineno_run_program+0x595>
		if (*p == 0) {
  8004207b0a:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b11:	0f b6 00             	movzbl (%rax),%eax
  8004207b14:	84 c0                	test   %al,%al
  8004207b16:	0f 85 78 01 00 00    	jne    8004207c94 <_dwarf_lineno_run_program+0x215>

			/*
			 * Extended Opcodes.
			 */

			p++;
  8004207b1c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b23:	48 83 c0 01          	add    $0x1,%rax
  8004207b27:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
			opsize = _dwarf_decode_uleb128(&p);
  8004207b2e:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207b35:	48 89 c7             	mov    %rax,%rdi
  8004207b38:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004207b3f:	00 00 00 
  8004207b42:	ff d0                	callq  *%rax
  8004207b44:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			switch (*p) {
  8004207b48:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b4f:	0f b6 00             	movzbl (%rax),%eax
  8004207b52:	0f b6 c0             	movzbl %al,%eax
  8004207b55:	83 f8 02             	cmp    $0x2,%eax
  8004207b58:	74 7a                	je     8004207bd4 <_dwarf_lineno_run_program+0x155>
  8004207b5a:	83 f8 03             	cmp    $0x3,%eax
  8004207b5d:	0f 84 b3 00 00 00    	je     8004207c16 <_dwarf_lineno_run_program+0x197>
  8004207b63:	83 f8 01             	cmp    $0x1,%eax
  8004207b66:	0f 85 09 01 00 00    	jne    8004207c75 <_dwarf_lineno_run_program+0x1f6>
			case DW_LNE_end_sequence:
				p++;
  8004207b6c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207b73:	48 83 c0 01          	add    $0x1,%rax
  8004207b77:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				end_sequence = 1;
  8004207b7e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
				RESET_REGISTERS;
  8004207b85:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004207b8c:	00 
  8004207b8d:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  8004207b94:	00 
  8004207b95:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  8004207b9c:	00 
  8004207b9d:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8004207ba4:	00 
  8004207ba5:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207ba9:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  8004207bad:	0f b6 c0             	movzbl %al,%eax
  8004207bb0:	89 45 cc             	mov    %eax,-0x34(%rbp)
  8004207bb3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  8004207bba:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  8004207bc1:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  8004207bc8:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  8004207bcf:	e9 bb 00 00 00       	jmpq   8004207c8f <_dwarf_lineno_run_program+0x210>
			case DW_LNE_set_address:
				p++;
  8004207bd4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207bdb:	48 83 c0 01          	add    $0x1,%rax
  8004207bdf:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				address = dbg->decode(&p, cu->addr_size);
  8004207be6:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207bed:	00 00 00 
  8004207bf0:	48 8b 00             	mov    (%rax),%rax
  8004207bf3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004207bf7:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  8004207bfb:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  8004207bff:	0f b6 ca             	movzbl %dl,%ecx
  8004207c02:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  8004207c09:	89 ce                	mov    %ecx,%esi
  8004207c0b:	48 89 d7             	mov    %rdx,%rdi
  8004207c0e:	ff d0                	callq  *%rax
  8004207c10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				break;
  8004207c14:	eb 79                	jmp    8004207c8f <_dwarf_lineno_run_program+0x210>
			case DW_LNE_define_file:
				p++;
  8004207c16:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207c1d:	48 83 c0 01          	add    $0x1,%rax
  8004207c21:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				ret = _dwarf_lineno_add_file(li, &p, NULL,
  8004207c28:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207c2f:	00 00 00 
  8004207c32:	48 8b 08             	mov    (%rax),%rcx
  8004207c35:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004207c3c:	48 8d b5 78 ff ff ff 	lea    -0x88(%rbp),%rsi
  8004207c43:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207c47:	49 89 c8             	mov    %rcx,%r8
  8004207c4a:	48 89 d1             	mov    %rdx,%rcx
  8004207c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004207c52:	48 89 c7             	mov    %rax,%rdi
  8004207c55:	48 b8 37 80 20 04 80 	movabs $0x8004208037,%rax
  8004207c5c:	00 00 00 
  8004207c5f:	ff d0                	callq  *%rax
  8004207c61:	89 45 a4             	mov    %eax,-0x5c(%rbp)
							     error, dbg);
				if (ret != DW_DLE_NONE)
  8004207c64:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  8004207c68:	74 09                	je     8004207c73 <_dwarf_lineno_run_program+0x1f4>
					goto prog_fail;
  8004207c6a:	90                   	nop

	return (DW_DLE_NONE);

prog_fail:

	return (ret);
  8004207c6b:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8004207c6e:	e9 ba 03 00 00       	jmpq   800420802d <_dwarf_lineno_run_program+0x5ae>
				p++;
				ret = _dwarf_lineno_add_file(li, &p, NULL,
							     error, dbg);
				if (ret != DW_DLE_NONE)
					goto prog_fail;
				break;
  8004207c73:	eb 1a                	jmp    8004207c8f <_dwarf_lineno_run_program+0x210>
			default:
				/* Unrecognized extened opcodes. */
				p += opsize;
  8004207c75:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004207c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207c80:	48 01 d0             	add    %rdx,%rax
  8004207c83:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  8004207c8a:	e9 85 03 00 00       	jmpq   8004208014 <_dwarf_lineno_run_program+0x595>
  8004207c8f:	e9 80 03 00 00       	jmpq   8004208014 <_dwarf_lineno_run_program+0x595>
			}

		} else if (*p > 0 && *p < li->li_opbase) {
  8004207c94:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207c9b:	0f b6 00             	movzbl (%rax),%eax
  8004207c9e:	84 c0                	test   %al,%al
  8004207ca0:	0f 84 3c 02 00 00    	je     8004207ee2 <_dwarf_lineno_run_program+0x463>
  8004207ca6:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207cad:	0f b6 10             	movzbl (%rax),%edx
  8004207cb0:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207cb4:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207cb8:	38 c2                	cmp    %al,%dl
  8004207cba:	0f 83 22 02 00 00    	jae    8004207ee2 <_dwarf_lineno_run_program+0x463>

			/*
			 * Standard Opcodes.
			 */

			switch (*p++) {
  8004207cc0:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207cc7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207ccb:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  8004207cd2:	0f b6 00             	movzbl (%rax),%eax
  8004207cd5:	0f b6 c0             	movzbl %al,%eax
  8004207cd8:	83 f8 0c             	cmp    $0xc,%eax
  8004207cdb:	0f 87 fb 01 00 00    	ja     8004207edc <_dwarf_lineno_run_program+0x45d>
  8004207ce1:	89 c0                	mov    %eax,%eax
  8004207ce3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004207cea:	00 
  8004207ceb:	48 b8 68 a3 20 04 80 	movabs $0x800420a368,%rax
  8004207cf2:	00 00 00 
  8004207cf5:	48 01 d0             	add    %rdx,%rax
  8004207cf8:	48 8b 00             	mov    (%rax),%rax
  8004207cfb:	ff e0                	jmpq   *%rax
			case DW_LNS_copy:
				APPEND_ROW;
  8004207cfd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004207d04:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004207d08:	73 0a                	jae    8004207d14 <_dwarf_lineno_run_program+0x295>
  8004207d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207d0f:	e9 19 03 00 00       	jmpq   800420802d <_dwarf_lineno_run_program+0x5ae>
  8004207d14:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207d1c:	48 89 10             	mov    %rdx,(%rax)
  8004207d1f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d23:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  8004207d2a:	00 
  8004207d2b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d2f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207d33:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004207d37:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d3b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004207d3f:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004207d43:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207d47:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d4b:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004207d4f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d53:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8004207d56:	89 50 28             	mov    %edx,0x28(%rax)
  8004207d59:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d5d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004207d60:	89 50 2c             	mov    %edx,0x2c(%rax)
  8004207d63:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207d67:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004207d6a:	89 50 30             	mov    %edx,0x30(%rax)
  8004207d6d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d71:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8004207d78:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207d7c:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207d80:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
				basic_block = 0;
  8004207d87:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
				prologue_end = 0;
  8004207d8e:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
				epilogue_begin = 0;
  8004207d95:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  8004207d9c:	e9 3c 01 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  8004207da1:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207da8:	48 89 c7             	mov    %rax,%rdi
  8004207dab:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004207db2:	00 00 00 
  8004207db5:	ff d0                	callq  *%rax
					li->li_minlen;
  8004207db7:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004207dbb:	0f b6 52 18          	movzbl 0x18(%rdx),%edx
				basic_block = 0;
				prologue_end = 0;
				epilogue_begin = 0;
				break;
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  8004207dbf:	0f b6 d2             	movzbl %dl,%edx
  8004207dc2:	48 0f af c2          	imul   %rdx,%rax
  8004207dc6:	48 01 45 e8          	add    %rax,-0x18(%rbp)
					li->li_minlen;
				break;
  8004207dca:	e9 0e 01 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_line:
				line += _dwarf_decode_sleb128(&p);
  8004207dcf:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207dd6:	48 89 c7             	mov    %rax,%rdi
  8004207dd9:	48 b8 84 3c 20 04 80 	movabs $0x8004203c84,%rax
  8004207de0:	00 00 00 
  8004207de3:	ff d0                	callq  *%rax
  8004207de5:	48 01 45 d8          	add    %rax,-0x28(%rbp)
				break;
  8004207de9:	e9 ef 00 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_file:
				file = _dwarf_decode_uleb128(&p);
  8004207dee:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207df5:	48 89 c7             	mov    %rax,%rdi
  8004207df8:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004207dff:	00 00 00 
  8004207e02:	ff d0                	callq  *%rax
  8004207e04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
				break;
  8004207e08:	e9 d0 00 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_column:
				column = _dwarf_decode_uleb128(&p);
  8004207e0d:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207e14:	48 89 c7             	mov    %rax,%rdi
  8004207e17:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004207e1e:	00 00 00 
  8004207e21:	ff d0                	callq  *%rax
  8004207e23:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
				break;
  8004207e27:	e9 b1 00 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_negate_stmt:
				is_stmt = !is_stmt;
  8004207e2c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004207e30:	0f 94 c0             	sete   %al
  8004207e33:	0f b6 c0             	movzbl %al,%eax
  8004207e36:	89 45 cc             	mov    %eax,-0x34(%rbp)
				break;
  8004207e39:	e9 9f 00 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_basic_block:
				basic_block = 1;
  8004207e3e:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%rbp)
				break;
  8004207e45:	e9 93 00 00 00       	jmpq   8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_const_add_pc:
				address += ADDRESS(255);
  8004207e4a:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207e4e:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207e52:	0f b6 c0             	movzbl %al,%eax
  8004207e55:	ba ff 00 00 00       	mov    $0xff,%edx
  8004207e5a:	89 d1                	mov    %edx,%ecx
  8004207e5c:	29 c1                	sub    %eax,%ecx
  8004207e5e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207e62:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207e66:	0f b6 d8             	movzbl %al,%ebx
  8004207e69:	89 c8                	mov    %ecx,%eax
  8004207e6b:	99                   	cltd   
  8004207e6c:	f7 fb                	idiv   %ebx
  8004207e6e:	89 c2                	mov    %eax,%edx
  8004207e70:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207e74:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  8004207e78:	0f b6 c0             	movzbl %al,%eax
  8004207e7b:	0f af c2             	imul   %edx,%eax
  8004207e7e:	48 98                	cltq   
  8004207e80:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  8004207e84:	eb 57                	jmp    8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_fixed_advance_pc:
				address += dbg->decode(&p, 2);
  8004207e86:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004207e8d:	00 00 00 
  8004207e90:	48 8b 00             	mov    (%rax),%rax
  8004207e93:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004207e97:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  8004207e9e:	be 02 00 00 00       	mov    $0x2,%esi
  8004207ea3:	48 89 d7             	mov    %rdx,%rdi
  8004207ea6:	ff d0                	callq  *%rax
  8004207ea8:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  8004207eac:	eb 2f                	jmp    8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_prologue_end:
				prologue_end = 1;
  8004207eae:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%rbp)
				break;
  8004207eb5:	eb 26                	jmp    8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_epilogue_begin:
				epilogue_begin = 1;
  8004207eb7:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%rbp)
				break;
  8004207ebe:	eb 1d                	jmp    8004207edd <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_isa:
				isa = _dwarf_decode_uleb128(&p);
  8004207ec0:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  8004207ec7:	48 89 c7             	mov    %rax,%rdi
  8004207eca:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004207ed1:	00 00 00 
  8004207ed4:	ff d0                	callq  *%rax
  8004207ed6:	48 89 45 98          	mov    %rax,-0x68(%rbp)
				break;
  8004207eda:	eb 01                	jmp    8004207edd <_dwarf_lineno_run_program+0x45e>
			default:
				/* Unrecognized extened opcodes. What to do? */
				break;
  8004207edc:	90                   	nop
			}

		} else {
  8004207edd:	e9 32 01 00 00       	jmpq   8004208014 <_dwarf_lineno_run_program+0x595>

			/*
			 * Special Opcodes.
			 */

			line += LINE(*p);
  8004207ee2:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207ee6:	0f b6 40 1a          	movzbl 0x1a(%rax),%eax
  8004207eea:	0f be c8             	movsbl %al,%ecx
  8004207eed:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207ef4:	0f b6 00             	movzbl (%rax),%eax
  8004207ef7:	0f b6 d0             	movzbl %al,%edx
  8004207efa:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207efe:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207f02:	0f b6 c0             	movzbl %al,%eax
  8004207f05:	29 c2                	sub    %eax,%edx
  8004207f07:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207f0b:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207f0f:	0f b6 f0             	movzbl %al,%esi
  8004207f12:	89 d0                	mov    %edx,%eax
  8004207f14:	99                   	cltd   
  8004207f15:	f7 fe                	idiv   %esi
  8004207f17:	89 d0                	mov    %edx,%eax
  8004207f19:	01 c8                	add    %ecx,%eax
  8004207f1b:	48 98                	cltq   
  8004207f1d:	48 01 45 d8          	add    %rax,-0x28(%rbp)
			address += ADDRESS(*p);
  8004207f21:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004207f28:	0f b6 00             	movzbl (%rax),%eax
  8004207f2b:	0f b6 d0             	movzbl %al,%edx
  8004207f2e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207f32:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  8004207f36:	0f b6 c0             	movzbl %al,%eax
  8004207f39:	89 d1                	mov    %edx,%ecx
  8004207f3b:	29 c1                	sub    %eax,%ecx
  8004207f3d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207f41:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  8004207f45:	0f b6 d8             	movzbl %al,%ebx
  8004207f48:	89 c8                	mov    %ecx,%eax
  8004207f4a:	99                   	cltd   
  8004207f4b:	f7 fb                	idiv   %ebx
  8004207f4d:	89 c2                	mov    %eax,%edx
  8004207f4f:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207f53:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  8004207f57:	0f b6 c0             	movzbl %al,%eax
  8004207f5a:	0f af c2             	imul   %edx,%eax
  8004207f5d:	48 98                	cltq   
  8004207f5f:	48 01 45 e8          	add    %rax,-0x18(%rbp)
			APPEND_ROW;
  8004207f63:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004207f6a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004207f6e:	73 0a                	jae    8004207f7a <_dwarf_lineno_run_program+0x4fb>
  8004207f70:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207f75:	e9 b3 00 00 00       	jmpq   800420802d <_dwarf_lineno_run_program+0x5ae>
  8004207f7a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207f7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207f82:	48 89 10             	mov    %rdx,(%rax)
  8004207f85:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207f89:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  8004207f90:	00 
  8004207f91:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207f95:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207f99:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004207f9d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207fa1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004207fa5:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004207fa9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004207fad:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207fb1:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004207fb5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207fb9:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8004207fbc:	89 50 28             	mov    %edx,0x28(%rax)
  8004207fbf:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207fc3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004207fc6:	89 50 2c             	mov    %edx,0x2c(%rax)
  8004207fc9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004207fcd:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004207fd0:	89 50 30             	mov    %edx,0x30(%rax)
  8004207fd3:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207fd7:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  8004207fde:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207fe2:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004207fe6:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
			basic_block = 0;
  8004207fed:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
			prologue_end = 0;
  8004207ff4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
			epilogue_begin = 0;
  8004207ffb:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
			p++;
  8004208002:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004208009:	48 83 c0 01          	add    $0x1,%rax
  800420800d:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
	RESET_REGISTERS;

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  8004208014:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420801b:	48 3b 85 70 ff ff ff 	cmp    -0x90(%rbp),%rax
  8004208022:	0f 82 e2 fa ff ff    	jb     8004207b0a <_dwarf_lineno_run_program+0x8b>
			epilogue_begin = 0;
			p++;
		}
	}

	return (DW_DLE_NONE);
  8004208028:	b8 00 00 00 00       	mov    $0x0,%eax

#undef  RESET_REGISTERS
#undef  APPEND_ROW
#undef  LINE
#undef  ADDRESS
}
  800420802d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8004208034:	5b                   	pop    %rbx
  8004208035:	5d                   	pop    %rbp
  8004208036:	c3                   	retq   

0000008004208037 <_dwarf_lineno_add_file>:

static int
_dwarf_lineno_add_file(Dwarf_LineInfo li, uint8_t **p, const char *compdir,
		       Dwarf_Error *error, Dwarf_Debug dbg)
{
  8004208037:	55                   	push   %rbp
  8004208038:	48 89 e5             	mov    %rsp,%rbp
  800420803b:	53                   	push   %rbx
  800420803c:	48 83 ec 48          	sub    $0x48,%rsp
  8004208040:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004208044:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004208048:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800420804c:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  8004208050:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
	char *fname;
	//const char *dirname;
	uint8_t *src;
	int slen;

	src = *p;
  8004208054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208058:	48 8b 00             	mov    (%rax),%rax
  800420805b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  DWARF_SET_ERROR(dbg, error, DW_DLE_MEMORY);
  return (DW_DLE_MEMORY);
  }
*/  
	//lf->lf_fullpath = NULL;
	fname = (char *) src;
  800420805f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208063:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	src += strlen(fname) + 1;
  8004208067:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
  800420806b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420806f:	48 89 c7             	mov    %rax,%rdi
  8004208072:	48 b8 ee 2d 20 04 80 	movabs $0x8004202dee,%rax
  8004208079:	00 00 00 
  800420807c:	ff d0                	callq  *%rax
  800420807e:	48 98                	cltq   
  8004208080:	48 83 c0 01          	add    $0x1,%rax
  8004208084:	48 01 d8             	add    %rbx,%rax
  8004208087:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	_dwarf_decode_uleb128(&src);
  800420808b:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800420808f:	48 89 c7             	mov    %rax,%rdi
  8004208092:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  8004208099:	00 00 00 
  800420809c:	ff d0                	callq  *%rax
	   snprintf(lf->lf_fullpath, slen, "%s/%s", dirname,
	   lf->lf_fname);
	   }
	   }
	*/
	_dwarf_decode_uleb128(&src);
  800420809e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  80042080a2:	48 89 c7             	mov    %rax,%rdi
  80042080a5:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042080ac:	00 00 00 
  80042080af:	ff d0                	callq  *%rax
	_dwarf_decode_uleb128(&src);
  80042080b1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  80042080b5:	48 89 c7             	mov    %rax,%rdi
  80042080b8:	48 b8 16 3d 20 04 80 	movabs $0x8004203d16,%rax
  80042080bf:	00 00 00 
  80042080c2:	ff d0                	callq  *%rax
	//STAILQ_INSERT_TAIL(&li->li_lflist, lf, lf_next);
	//li->li_lflen++;

	*p = src;
  80042080c4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042080c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042080cc:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  80042080cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042080d4:	48 83 c4 48          	add    $0x48,%rsp
  80042080d8:	5b                   	pop    %rbx
  80042080d9:	5d                   	pop    %rbp
  80042080da:	c3                   	retq   

00000080042080db <_dwarf_lineno_init>:

int     
_dwarf_lineno_init(Dwarf_Die *die, uint64_t offset, Dwarf_LineInfo linfo, Dwarf_Addr pc, Dwarf_Error *error)
{   
  80042080db:	55                   	push   %rbp
  80042080dc:	48 89 e5             	mov    %rsp,%rbp
  80042080df:	53                   	push   %rbx
  80042080e0:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  80042080e7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80042080ee:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
  80042080f5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80042080fc:	48 89 8d 00 ff ff ff 	mov    %rcx,-0x100(%rbp)
  8004208103:	4c 89 85 f8 fe ff ff 	mov    %r8,-0x108(%rbp)
	Dwarf_Section myds = {.ds_name = ".debug_line"};
  800420810a:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
  8004208111:	00 
  8004208112:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
  8004208119:	00 
  800420811a:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
  8004208121:	00 
  8004208122:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  8004208129:	00 
  800420812a:	48 b8 d0 a3 20 04 80 	movabs $0x800420a3d0,%rax
  8004208131:	00 00 00 
  8004208134:	48 89 45 90          	mov    %rax,-0x70(%rbp)
	Dwarf_Section *ds = &myds;
  8004208138:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800420813c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	//Dwarf_LineFile lf, tlf;
	uint64_t length, hdroff, endoff;
	uint8_t *p;
	int dwarf_size, i, ret;
            
	cu = die->cu_header;
  8004208140:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004208147:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  800420814e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	assert(cu != NULL); 
  8004208152:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004208157:	75 35                	jne    800420818e <_dwarf_lineno_init+0xb3>
  8004208159:	48 b9 dc a3 20 04 80 	movabs $0x800420a3dc,%rcx
  8004208160:	00 00 00 
  8004208163:	48 ba e7 a3 20 04 80 	movabs $0x800420a3e7,%rdx
  800420816a:	00 00 00 
  800420816d:	be 13 01 00 00       	mov    $0x113,%esi
  8004208172:	48 bf fc a3 20 04 80 	movabs $0x800420a3fc,%rdi
  8004208179:	00 00 00 
  800420817c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208181:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208188:	00 00 00 
  800420818b:	41 ff d0             	callq  *%r8
	assert(dbg != NULL);
  800420818e:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208195:	00 00 00 
  8004208198:	48 8b 00             	mov    (%rax),%rax
  800420819b:	48 85 c0             	test   %rax,%rax
  800420819e:	75 35                	jne    80042081d5 <_dwarf_lineno_init+0xfa>
  80042081a0:	48 b9 13 a4 20 04 80 	movabs $0x800420a413,%rcx
  80042081a7:	00 00 00 
  80042081aa:	48 ba e7 a3 20 04 80 	movabs $0x800420a3e7,%rdx
  80042081b1:	00 00 00 
  80042081b4:	be 14 01 00 00       	mov    $0x114,%esi
  80042081b9:	48 bf fc a3 20 04 80 	movabs $0x800420a3fc,%rdi
  80042081c0:	00 00 00 
  80042081c3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042081c8:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042081cf:	00 00 00 
  80042081d2:	41 ff d0             	callq  *%r8

	if ((_dwarf_find_section_enhanced(ds)) != 0)
  80042081d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042081d9:	48 89 c7             	mov    %rax,%rdi
  80042081dc:	48 b8 a3 54 20 04 80 	movabs $0x80042054a3,%rax
  80042081e3:	00 00 00 
  80042081e6:	ff d0                	callq  *%rax
  80042081e8:	85 c0                	test   %eax,%eax
  80042081ea:	74 0a                	je     80042081f6 <_dwarf_lineno_init+0x11b>
		return (DW_DLE_NONE);
  80042081ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80042081f1:	e9 4f 04 00 00       	jmpq   8004208645 <_dwarf_lineno_init+0x56a>

	li = linfo;
  80042081f6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80042081fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	 break;
	 }
	 }
	*/

	length = dbg->read(ds->ds_data, &offset, 4);
  8004208201:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208208:	00 00 00 
  800420820b:	48 8b 00             	mov    (%rax),%rax
  800420820e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208212:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208216:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420821a:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208221:	ba 04 00 00 00       	mov    $0x4,%edx
  8004208226:	48 89 cf             	mov    %rcx,%rdi
  8004208229:	ff d0                	callq  *%rax
  800420822b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (length == 0xffffffff) {
  800420822f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004208234:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8004208238:	75 37                	jne    8004208271 <_dwarf_lineno_init+0x196>
		dwarf_size = 8;
  800420823a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
		length = dbg->read(ds->ds_data, &offset, 8);
  8004208241:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208248:	00 00 00 
  800420824b:	48 8b 00             	mov    (%rax),%rax
  800420824e:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208252:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208256:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420825a:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208261:	ba 08 00 00 00       	mov    $0x8,%edx
  8004208266:	48 89 cf             	mov    %rcx,%rdi
  8004208269:	ff d0                	callq  *%rax
  800420826b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800420826f:	eb 07                	jmp    8004208278 <_dwarf_lineno_init+0x19d>
	} else
		dwarf_size = 4;
  8004208271:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%rbp)

	if (length > ds->ds_size - offset) {
  8004208278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420827c:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208280:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004208287:	48 29 c2             	sub    %rax,%rdx
  800420828a:	48 89 d0             	mov    %rdx,%rax
  800420828d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004208291:	73 0a                	jae    800420829d <_dwarf_lineno_init+0x1c2>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_LINE_LENGTH_BAD);
		return (DW_DLE_DEBUG_LINE_LENGTH_BAD);
  8004208293:	b8 0f 00 00 00       	mov    $0xf,%eax
  8004208298:	e9 a8 03 00 00       	jmpq   8004208645 <_dwarf_lineno_init+0x56a>
	}
	/*
	 * Read in line number program header.
	 */
	li->li_length = length;
  800420829d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042082a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042082a5:	48 89 10             	mov    %rdx,(%rax)
	endoff = offset + length;
  80042082a8:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80042082af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042082b3:	48 01 d0             	add    %rdx,%rax
  80042082b6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	li->li_version = dbg->read(ds->ds_data, &offset, 2); /* FIXME: verify version */
  80042082ba:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042082c1:	00 00 00 
  80042082c4:	48 8b 00             	mov    (%rax),%rax
  80042082c7:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042082cb:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042082cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042082d3:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042082da:	ba 02 00 00 00       	mov    $0x2,%edx
  80042082df:	48 89 cf             	mov    %rcx,%rdi
  80042082e2:	ff d0                	callq  *%rax
  80042082e4:	89 c2                	mov    %eax,%edx
  80042082e6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042082ea:	66 89 50 08          	mov    %dx,0x8(%rax)
	li->li_hdrlen = dbg->read(ds->ds_data, &offset, dwarf_size);
  80042082ee:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042082f5:	00 00 00 
  80042082f8:	48 8b 00             	mov    (%rax),%rax
  80042082fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042082ff:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208303:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208307:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800420830a:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208311:	48 89 cf             	mov    %rcx,%rdi
  8004208314:	ff d0                	callq  *%rax
  8004208316:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420831a:	48 89 42 10          	mov    %rax,0x10(%rdx)
	hdroff = offset;
  800420831e:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004208325:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	li->li_minlen = dbg->read(ds->ds_data, &offset, 1);
  8004208329:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208330:	00 00 00 
  8004208333:	48 8b 00             	mov    (%rax),%rax
  8004208336:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420833a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420833e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208342:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208349:	ba 01 00 00 00       	mov    $0x1,%edx
  800420834e:	48 89 cf             	mov    %rcx,%rdi
  8004208351:	ff d0                	callq  *%rax
  8004208353:	89 c2                	mov    %eax,%edx
  8004208355:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208359:	88 50 18             	mov    %dl,0x18(%rax)
	li->li_defstmt = dbg->read(ds->ds_data, &offset, 1);
  800420835c:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208363:	00 00 00 
  8004208366:	48 8b 00             	mov    (%rax),%rax
  8004208369:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420836d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208371:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208375:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420837c:	ba 01 00 00 00       	mov    $0x1,%edx
  8004208381:	48 89 cf             	mov    %rcx,%rdi
  8004208384:	ff d0                	callq  *%rax
  8004208386:	89 c2                	mov    %eax,%edx
  8004208388:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420838c:	88 50 19             	mov    %dl,0x19(%rax)
	li->li_lbase = dbg->read(ds->ds_data, &offset, 1);
  800420838f:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208396:	00 00 00 
  8004208399:	48 8b 00             	mov    (%rax),%rax
  800420839c:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042083a0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042083a4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042083a8:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042083af:	ba 01 00 00 00       	mov    $0x1,%edx
  80042083b4:	48 89 cf             	mov    %rcx,%rdi
  80042083b7:	ff d0                	callq  *%rax
  80042083b9:	89 c2                	mov    %eax,%edx
  80042083bb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042083bf:	88 50 1a             	mov    %dl,0x1a(%rax)
	li->li_lrange = dbg->read(ds->ds_data, &offset, 1);
  80042083c2:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042083c9:	00 00 00 
  80042083cc:	48 8b 00             	mov    (%rax),%rax
  80042083cf:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042083d3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042083d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042083db:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  80042083e2:	ba 01 00 00 00       	mov    $0x1,%edx
  80042083e7:	48 89 cf             	mov    %rcx,%rdi
  80042083ea:	ff d0                	callq  *%rax
  80042083ec:	89 c2                	mov    %eax,%edx
  80042083ee:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042083f2:	88 50 1b             	mov    %dl,0x1b(%rax)
	li->li_opbase = dbg->read(ds->ds_data, &offset, 1);
  80042083f5:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  80042083fc:	00 00 00 
  80042083ff:	48 8b 00             	mov    (%rax),%rax
  8004208402:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208406:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420840a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420840e:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  8004208415:	ba 01 00 00 00       	mov    $0x1,%edx
  800420841a:	48 89 cf             	mov    %rcx,%rdi
  800420841d:	ff d0                	callq  *%rax
  800420841f:	89 c2                	mov    %eax,%edx
  8004208421:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208425:	88 50 1c             	mov    %dl,0x1c(%rax)
	//STAILQ_INIT(&li->li_lflist);
	//STAILQ_INIT(&li->li_lnlist);

	if ((int)li->li_hdrlen - 5 < li->li_opbase - 1) {
  8004208428:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420842c:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208430:	8d 50 fb             	lea    -0x5(%rax),%edx
  8004208433:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208437:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420843b:	0f b6 c0             	movzbl %al,%eax
  800420843e:	83 e8 01             	sub    $0x1,%eax
  8004208441:	39 c2                	cmp    %eax,%edx
  8004208443:	7d 0c                	jge    8004208451 <_dwarf_lineno_init+0x376>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  8004208445:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420844c:	e9 f1 01 00 00       	jmpq   8004208642 <_dwarf_lineno_init+0x567>
	}

	li->li_oplen = global_std_op;
  8004208451:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208455:	48 bb 40 db 21 04 80 	movabs $0x800421db40,%rbx
  800420845c:	00 00 00 
  800420845f:	48 89 58 20          	mov    %rbx,0x20(%rax)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  8004208463:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%rbp)
  800420846a:	eb 41                	jmp    80042084ad <_dwarf_lineno_init+0x3d2>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);
  800420846c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208470:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208474:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004208477:	48 98                	cltq   
  8004208479:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  800420847d:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208484:	00 00 00 
  8004208487:	48 8b 00             	mov    (%rax),%rax
  800420848a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420848e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004208492:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004208496:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420849d:	ba 01 00 00 00       	mov    $0x1,%edx
  80042084a2:	48 89 cf             	mov    %rcx,%rdi
  80042084a5:	ff d0                	callq  *%rax
  80042084a7:	88 03                	mov    %al,(%rbx)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  80042084a9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  80042084ad:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042084b1:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  80042084b5:	0f b6 c0             	movzbl %al,%eax
  80042084b8:	3b 45 e0             	cmp    -0x20(%rbp),%eax
  80042084bb:	7f af                	jg     800420846c <_dwarf_lineno_init+0x391>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);

	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
  80042084bd:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80042084c4:	00 
	p = ds->ds_data + offset;
  80042084c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042084c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042084cd:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80042084d4:	48 01 d0             	add    %rdx,%rax
  80042084d7:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	while (*p != '\0') {
  80042084de:	eb 1f                	jmp    80042084ff <_dwarf_lineno_init+0x424>
		while (*p++ != '\0')
  80042084e0:	90                   	nop
  80042084e1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042084e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042084ec:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
  80042084f3:	0f b6 00             	movzbl (%rax),%eax
  80042084f6:	84 c0                	test   %al,%al
  80042084f8:	75 e7                	jne    80042084e1 <_dwarf_lineno_init+0x406>
			;
		length++;
  80042084fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
	p = ds->ds_data + offset;
	while (*p != '\0') {
  80042084ff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208506:	0f b6 00             	movzbl (%rax),%eax
  8004208509:	84 c0                	test   %al,%al
  800420850b:	75 d3                	jne    80042084e0 <_dwarf_lineno_init+0x405>
		while (*p++ != '\0')
			;
		length++;
	}
	li->li_inclen = length;
  800420850d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004208511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208515:	48 89 50 30          	mov    %rdx,0x30(%rax)

	/* Sanity check. */
	if (p - ds->ds_data > (int) ds->ds_size) {
  8004208519:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208520:	48 89 c2             	mov    %rax,%rdx
  8004208523:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208527:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420852b:	48 29 c2             	sub    %rax,%rdx
  800420852e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208532:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208536:	48 98                	cltq   
  8004208538:	48 39 c2             	cmp    %rax,%rdx
  800420853b:	7e 0c                	jle    8004208549 <_dwarf_lineno_init+0x46e>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  800420853d:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  8004208544:	e9 f9 00 00 00       	jmpq   8004208642 <_dwarf_lineno_init+0x567>
	}
	p++;
  8004208549:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004208550:	48 83 c0 01          	add    $0x1,%rax
  8004208554:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  800420855b:	eb 3c                	jmp    8004208599 <_dwarf_lineno_init+0x4be>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
  800420855d:	48 b8 c0 c5 21 04 80 	movabs $0x800421c5c0,%rax
  8004208564:	00 00 00 
  8004208567:	48 8b 08             	mov    (%rax),%rcx
  800420856a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8004208571:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  8004208578:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420857c:	49 89 c8             	mov    %rcx,%r8
  800420857f:	48 89 d1             	mov    %rdx,%rcx
  8004208582:	ba 00 00 00 00       	mov    $0x0,%edx
  8004208587:	48 89 c7             	mov    %rax,%rdi
  800420858a:	48 b8 37 80 20 04 80 	movabs $0x8004208037,%rax
  8004208591:	00 00 00 
  8004208594:	ff d0                	callq  *%rax
  8004208596:	89 45 dc             	mov    %eax,-0x24(%rbp)
	p++;

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  8004208599:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042085a0:	0f b6 00             	movzbl (%rax),%eax
  80042085a3:	84 c0                	test   %al,%al
  80042085a5:	75 b6                	jne    800420855d <_dwarf_lineno_init+0x482>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
		//p++;
	}

	p++;
  80042085a7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042085ae:	48 83 c0 01          	add    $0x1,%rax
  80042085b2:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	/* Sanity check. */
	if (p - ds->ds_data - hdroff != li->li_hdrlen) {
  80042085b9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042085c0:	48 89 c2             	mov    %rax,%rdx
  80042085c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042085c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042085cb:	48 29 c2             	sub    %rax,%rdx
  80042085ce:	48 89 d0             	mov    %rdx,%rax
  80042085d1:	48 2b 45 b0          	sub    -0x50(%rbp),%rax
  80042085d5:	48 89 c2             	mov    %rax,%rdx
  80042085d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042085dc:	48 8b 40 10          	mov    0x10(%rax),%rax
  80042085e0:	48 39 c2             	cmp    %rax,%rdx
  80042085e3:	74 09                	je     80042085ee <_dwarf_lineno_init+0x513>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  80042085e5:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  80042085ec:	eb 54                	jmp    8004208642 <_dwarf_lineno_init+0x567>
	}

	/*
	 * Process line number program.
	 */
	ret = _dwarf_lineno_run_program(cu, li, p, ds->ds_data + endoff, pc,
  80042085ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042085f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042085f6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042085fa:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80042085fe:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  8004208605:	4c 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%r8
  800420860c:	48 8b bd 00 ff ff ff 	mov    -0x100(%rbp),%rdi
  8004208613:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004208617:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420861b:	4d 89 c1             	mov    %r8,%r9
  800420861e:	49 89 f8             	mov    %rdi,%r8
  8004208621:	48 89 c7             	mov    %rax,%rdi
  8004208624:	48 b8 7f 7a 20 04 80 	movabs $0x8004207a7f,%rax
  800420862b:	00 00 00 
  800420862e:	ff d0                	callq  *%rax
  8004208630:	89 45 dc             	mov    %eax,-0x24(%rbp)
					error);
	if (ret != DW_DLE_NONE)
  8004208633:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004208637:	74 02                	je     800420863b <_dwarf_lineno_init+0x560>
		goto fail_cleanup;
  8004208639:	eb 07                	jmp    8004208642 <_dwarf_lineno_init+0x567>

	//cu->cu_lineinfo = li;

	return (DW_DLE_NONE);
  800420863b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208640:	eb 03                	jmp    8004208645 <_dwarf_lineno_init+0x56a>
fail_cleanup:

	/*if (li->li_oplen)
	  free(li->li_oplen);*/

	return (ret);
  8004208642:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
  8004208645:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  800420864c:	5b                   	pop    %rbx
  800420864d:	5d                   	pop    %rbp
  800420864e:	c3                   	retq   

000000800420864f <dwarf_srclines>:

int
dwarf_srclines(Dwarf_Die *die, Dwarf_Line linebuf, Dwarf_Addr pc, Dwarf_Error *error)
{
  800420864f:	55                   	push   %rbp
  8004208650:	48 89 e5             	mov    %rsp,%rbp
  8004208653:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800420865a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8004208661:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8004208668:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  800420866f:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
	_Dwarf_LineInfo li;
	Dwarf_Attribute *at;

	assert(die);
  8004208676:	48 83 bd 68 ff ff ff 	cmpq   $0x0,-0x98(%rbp)
  800420867d:	00 
  800420867e:	75 35                	jne    80042086b5 <dwarf_srclines+0x66>
  8004208680:	48 b9 1f a4 20 04 80 	movabs $0x800420a41f,%rcx
  8004208687:	00 00 00 
  800420868a:	48 ba e7 a3 20 04 80 	movabs $0x800420a3e7,%rdx
  8004208691:	00 00 00 
  8004208694:	be 9a 01 00 00       	mov    $0x19a,%esi
  8004208699:	48 bf fc a3 20 04 80 	movabs $0x800420a3fc,%rdi
  80042086a0:	00 00 00 
  80042086a3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042086a8:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042086af:	00 00 00 
  80042086b2:	41 ff d0             	callq  *%r8
	assert(linebuf);
  80042086b5:	48 83 bd 60 ff ff ff 	cmpq   $0x0,-0xa0(%rbp)
  80042086bc:	00 
  80042086bd:	75 35                	jne    80042086f4 <dwarf_srclines+0xa5>
  80042086bf:	48 b9 23 a4 20 04 80 	movabs $0x800420a423,%rcx
  80042086c6:	00 00 00 
  80042086c9:	48 ba e7 a3 20 04 80 	movabs $0x800420a3e7,%rdx
  80042086d0:	00 00 00 
  80042086d3:	be 9b 01 00 00       	mov    $0x19b,%esi
  80042086d8:	48 bf fc a3 20 04 80 	movabs $0x800420a3fc,%rdi
  80042086df:	00 00 00 
  80042086e2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042086e7:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042086ee:	00 00 00 
  80042086f1:	41 ff d0             	callq  *%r8

	memset(&li, 0, sizeof(_Dwarf_LineInfo));
  80042086f4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80042086fb:	ba 88 00 00 00       	mov    $0x88,%edx
  8004208700:	be 00 00 00 00       	mov    $0x0,%esi
  8004208705:	48 89 c7             	mov    %rax,%rdi
  8004208708:	48 b8 f3 30 20 04 80 	movabs $0x80042030f3,%rax
  800420870f:	00 00 00 
  8004208712:	ff d0                	callq  *%rax

	if ((at = _dwarf_attr_find(die, DW_AT_stmt_list)) == NULL) {
  8004208714:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420871b:	be 10 00 00 00       	mov    $0x10,%esi
  8004208720:	48 89 c7             	mov    %rax,%rdi
  8004208723:	48 b8 28 50 20 04 80 	movabs $0x8004205028,%rax
  800420872a:	00 00 00 
  800420872d:	ff d0                	callq  *%rax
  800420872f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208733:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004208738:	75 0a                	jne    8004208744 <dwarf_srclines+0xf5>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  800420873a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420873f:	e9 84 00 00 00       	jmpq   80042087c8 <dwarf_srclines+0x179>
	}

	if (_dwarf_lineno_init(die, at->u[0].u64, &li, pc, error) !=
  8004208744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208748:	48 8b 70 28          	mov    0x28(%rax),%rsi
  800420874c:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  8004208753:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800420875a:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  8004208761:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004208768:	49 89 f8             	mov    %rdi,%r8
  800420876b:	48 89 c7             	mov    %rax,%rdi
  800420876e:	48 b8 db 80 20 04 80 	movabs $0x80042080db,%rax
  8004208775:	00 00 00 
  8004208778:	ff d0                	callq  *%rax
  800420877a:	85 c0                	test   %eax,%eax
  800420877c:	74 07                	je     8004208785 <dwarf_srclines+0x136>
	    DW_DLE_NONE)
	{
		return (DW_DLV_ERROR);
  800420877e:	b8 01 00 00 00       	mov    $0x1,%eax
  8004208783:	eb 43                	jmp    80042087c8 <dwarf_srclines+0x179>
	}
	*linebuf = li.li_line;
  8004208785:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800420878c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004208790:	48 89 10             	mov    %rdx,(%rax)
  8004208793:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004208797:	48 89 50 08          	mov    %rdx,0x8(%rax)
  800420879b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420879f:	48 89 50 10          	mov    %rdx,0x10(%rax)
  80042087a3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80042087a7:	48 89 50 18          	mov    %rdx,0x18(%rax)
  80042087ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042087af:	48 89 50 20          	mov    %rdx,0x20(%rax)
  80042087b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042087b7:	48 89 50 28          	mov    %rdx,0x28(%rax)
  80042087bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042087bf:	48 89 50 30          	mov    %rdx,0x30(%rax)

	return (DW_DLV_OK);
  80042087c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042087c8:	c9                   	leaveq 
  80042087c9:	c3                   	retq   

00000080042087ca <_dwarf_find_section>:
uintptr_t
read_section_headers(uintptr_t, uintptr_t);

Dwarf_Section *
_dwarf_find_section(const char *name)
{
  80042087ca:	55                   	push   %rbp
  80042087cb:	48 89 e5             	mov    %rsp,%rbp
  80042087ce:	48 83 ec 20          	sub    $0x20,%rsp
  80042087d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *ret=NULL;
  80042087d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042087dd:	00 
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  80042087de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80042087e5:	eb 57                	jmp    800420883e <_dwarf_find_section+0x74>
		if(!strcmp(section_info[i].ds_name, name)) {
  80042087e7:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042087ee:	00 00 00 
  80042087f1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042087f4:	48 63 d2             	movslq %edx,%rdx
  80042087f7:	48 c1 e2 05          	shl    $0x5,%rdx
  80042087fb:	48 01 d0             	add    %rdx,%rax
  80042087fe:	48 8b 00             	mov    (%rax),%rax
  8004208801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208805:	48 89 d6             	mov    %rdx,%rsi
  8004208808:	48 89 c7             	mov    %rax,%rdi
  800420880b:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208812:	00 00 00 
  8004208815:	ff d0                	callq  *%rax
  8004208817:	85 c0                	test   %eax,%eax
  8004208819:	75 1f                	jne    800420883a <_dwarf_find_section+0x70>
			ret = (section_info + i);
  800420881b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420881e:	48 98                	cltq   
  8004208820:	48 c1 e0 05          	shl    $0x5,%rax
  8004208824:	48 89 c2             	mov    %rax,%rdx
  8004208827:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420882e:	00 00 00 
  8004208831:	48 01 d0             	add    %rdx,%rax
  8004208834:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  8004208838:	eb 0a                	jmp    8004208844 <_dwarf_find_section+0x7a>
_dwarf_find_section(const char *name)
{
	Dwarf_Section *ret=NULL;
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  800420883a:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  800420883e:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  8004208842:	7e a3                	jle    80042087e7 <_dwarf_find_section+0x1d>
			ret = (section_info + i);
			break;
		}
	}

	return ret;
  8004208844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208848:	c9                   	leaveq 
  8004208849:	c3                   	retq   

000000800420884a <find_debug_sections>:

void find_debug_sections(uintptr_t elf) 
{
  800420884a:	55                   	push   %rbp
  800420884b:	48 89 e5             	mov    %rsp,%rbp
  800420884e:	48 83 ec 40          	sub    $0x40,%rsp
  8004208852:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	Elf *ehdr = (Elf *)elf;
  8004208856:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420885a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uintptr_t debug_address = USTABDATA;
  800420885e:	48 c7 45 f8 00 00 20 	movq   $0x200000,-0x8(%rbp)
  8004208865:	00 
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
  8004208866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420886a:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420886e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208872:	48 01 d0             	add    %rdx,%rax
  8004208875:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
  8004208879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420887d:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  8004208881:	0f b7 c0             	movzwl %ax,%eax
  8004208884:	48 c1 e0 06          	shl    $0x6,%rax
  8004208888:	48 89 c2             	mov    %rax,%rdx
  800420888b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420888f:	48 01 d0             	add    %rdx,%rax
  8004208892:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Secthdr* esh = sh + ehdr->e_shnum;
  8004208896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420889a:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  800420889e:	0f b7 c0             	movzwl %ax,%eax
  80042088a1:	48 c1 e0 06          	shl    $0x6,%rax
  80042088a5:	48 89 c2             	mov    %rax,%rdx
  80042088a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088ac:	48 01 d0             	add    %rdx,%rax
  80042088af:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	for(;sh < esh; sh++) {
  80042088b3:	e9 4b 02 00 00       	jmpq   8004208b03 <find_debug_sections+0x2b9>
		char* name = (char*)((uint8_t*)elf + shstr_tab->sh_offset) + sh->sh_name;
  80042088b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088bc:	8b 00                	mov    (%rax),%eax
  80042088be:	89 c2                	mov    %eax,%edx
  80042088c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042088c4:	48 8b 48 18          	mov    0x18(%rax),%rcx
  80042088c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042088cc:	48 01 c8             	add    %rcx,%rax
  80042088cf:	48 01 d0             	add    %rdx,%rax
  80042088d2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if(!strcmp(name, ".debug_info")) {
  80042088d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042088da:	48 be 2b a4 20 04 80 	movabs $0x800420a42b,%rsi
  80042088e1:	00 00 00 
  80042088e4:	48 89 c7             	mov    %rax,%rdi
  80042088e7:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  80042088ee:	00 00 00 
  80042088f1:	ff d0                	callq  *%rax
  80042088f3:	85 c0                	test   %eax,%eax
  80042088f5:	75 4b                	jne    8004208942 <find_debug_sections+0xf8>
			section_info[DEBUG_INFO].ds_data = (uint8_t*)debug_address;
  80042088f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042088fb:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208902:	00 00 00 
  8004208905:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = debug_address;
  8004208909:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208910:	00 00 00 
  8004208913:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208917:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = sh->sh_size;
  800420891b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420891f:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208923:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420892a:	00 00 00 
  800420892d:	48 89 50 18          	mov    %rdx,0x18(%rax)
			debug_address += sh->sh_size;
  8004208931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208935:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004208939:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  800420893d:	e9 bc 01 00 00       	jmpq   8004208afe <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_abbrev")) {
  8004208942:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208946:	48 be 37 a4 20 04 80 	movabs $0x800420a437,%rsi
  800420894d:	00 00 00 
  8004208950:	48 89 c7             	mov    %rax,%rdi
  8004208953:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  800420895a:	00 00 00 
  800420895d:	ff d0                	callq  *%rax
  800420895f:	85 c0                	test   %eax,%eax
  8004208961:	75 4b                	jne    80042089ae <find_debug_sections+0x164>
			section_info[DEBUG_ABBREV].ds_data = (uint8_t*)debug_address;
  8004208963:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208967:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420896e:	00 00 00 
  8004208971:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = debug_address;
  8004208975:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420897c:	00 00 00 
  800420897f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208983:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = sh->sh_size;
  8004208987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420898b:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420898f:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208996:	00 00 00 
  8004208999:	48 89 50 38          	mov    %rdx,0x38(%rax)
			debug_address += sh->sh_size;
  800420899d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089a1:	48 8b 40 20          	mov    0x20(%rax),%rax
  80042089a5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  80042089a9:	e9 50 01 00 00       	jmpq   8004208afe <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_line")){
  80042089ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042089b2:	48 be 4f a4 20 04 80 	movabs $0x800420a44f,%rsi
  80042089b9:	00 00 00 
  80042089bc:	48 89 c7             	mov    %rax,%rdi
  80042089bf:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  80042089c6:	00 00 00 
  80042089c9:	ff d0                	callq  *%rax
  80042089cb:	85 c0                	test   %eax,%eax
  80042089cd:	75 4b                	jne    8004208a1a <find_debug_sections+0x1d0>
			section_info[DEBUG_LINE].ds_data = (uint8_t*)debug_address;
  80042089cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042089d3:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042089da:	00 00 00 
  80042089dd:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = debug_address;
  80042089e1:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042089e8:	00 00 00 
  80042089eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042089ef:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = sh->sh_size;
  80042089f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089f7:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80042089fb:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208a02:	00 00 00 
  8004208a05:	48 89 50 78          	mov    %rdx,0x78(%rax)
			debug_address += sh->sh_size;
  8004208a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208a0d:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004208a11:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  8004208a15:	e9 e4 00 00 00       	jmpq   8004208afe <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".eh_frame")){
  8004208a1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a1e:	48 be 45 a4 20 04 80 	movabs $0x800420a445,%rsi
  8004208a25:	00 00 00 
  8004208a28:	48 89 c7             	mov    %rax,%rdi
  8004208a2b:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208a32:	00 00 00 
  8004208a35:	ff d0                	callq  *%rax
  8004208a37:	85 c0                	test   %eax,%eax
  8004208a39:	75 53                	jne    8004208a8e <find_debug_sections+0x244>
			section_info[DEBUG_FRAME].ds_data = (uint8_t*)sh->sh_addr;
  8004208a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208a3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208a43:	48 89 c2             	mov    %rax,%rdx
  8004208a46:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208a4d:	00 00 00 
  8004208a50:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = sh->sh_addr;
  8004208a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208a58:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004208a5c:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208a63:	00 00 00 
  8004208a66:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = sh->sh_size;
  8004208a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208a6e:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208a72:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208a79:	00 00 00 
  8004208a7c:	48 89 50 58          	mov    %rdx,0x58(%rax)
			debug_address += sh->sh_size;
  8004208a80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208a84:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004208a88:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  8004208a8c:	eb 70                	jmp    8004208afe <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_str")) {
  8004208a8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a92:	48 be 5b a4 20 04 80 	movabs $0x800420a45b,%rsi
  8004208a99:	00 00 00 
  8004208a9c:	48 89 c7             	mov    %rax,%rdi
  8004208a9f:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208aa6:	00 00 00 
  8004208aa9:	ff d0                	callq  *%rax
  8004208aab:	85 c0                	test   %eax,%eax
  8004208aad:	75 4f                	jne    8004208afe <find_debug_sections+0x2b4>
			section_info[DEBUG_STR].ds_data = (uint8_t*)debug_address;
  8004208aaf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208ab3:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208aba:	00 00 00 
  8004208abd:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = debug_address;
  8004208ac4:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208acb:	00 00 00 
  8004208ace:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208ad2:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = sh->sh_size;
  8004208ad9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208add:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208ae1:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208ae8:	00 00 00 
  8004208aeb:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
			debug_address += sh->sh_size;
  8004208af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208af6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8004208afa:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	Elf *ehdr = (Elf *)elf;
	uintptr_t debug_address = USTABDATA;
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
	Secthdr* esh = sh + ehdr->e_shnum;
	for(;sh < esh; sh++) {
  8004208afe:	48 83 45 f0 40       	addq   $0x40,-0x10(%rbp)
  8004208b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208b07:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004208b0b:	0f 82 a7 fd ff ff    	jb     80042088b8 <find_debug_sections+0x6e>
			section_info[DEBUG_STR].ds_size = sh->sh_size;
			debug_address += sh->sh_size;
		}
	}

}
  8004208b11:	c9                   	leaveq 
  8004208b12:	c3                   	retq   

0000008004208b13 <read_section_headers>:

uint64_t
read_section_headers(uintptr_t elfhdr, uintptr_t to_va)
{
  8004208b13:	55                   	push   %rbp
  8004208b14:	48 89 e5             	mov    %rsp,%rbp
  8004208b17:	48 81 ec 60 01 00 00 	sub    $0x160,%rsp
  8004208b1e:	48 89 bd a8 fe ff ff 	mov    %rdi,-0x158(%rbp)
  8004208b25:	48 89 b5 a0 fe ff ff 	mov    %rsi,-0x160(%rbp)
	Secthdr* secthdr_ptr[20] = {0};
  8004208b2c:	48 8d b5 c0 fe ff ff 	lea    -0x140(%rbp),%rsi
  8004208b33:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208b38:	ba 14 00 00 00       	mov    $0x14,%edx
  8004208b3d:	48 89 f7             	mov    %rsi,%rdi
  8004208b40:	48 89 d1             	mov    %rdx,%rcx
  8004208b43:	f3 48 ab             	rep stos %rax,%es:(%rdi)
	char* kvbase = ROUNDUP((char*)to_va, SECTSIZE);
  8004208b46:	48 c7 45 e8 00 02 00 	movq   $0x200,-0x18(%rbp)
  8004208b4d:	00 
  8004208b4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208b52:	48 8b 95 a0 fe ff ff 	mov    -0x160(%rbp),%rdx
  8004208b59:	48 01 d0             	add    %rdx,%rax
  8004208b5c:	48 83 e8 01          	sub    $0x1,%rax
  8004208b60:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004208b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208b68:	ba 00 00 00 00       	mov    $0x0,%edx
  8004208b6d:	48 f7 75 e8          	divq   -0x18(%rbp)
  8004208b71:	48 89 d0             	mov    %rdx,%rax
  8004208b74:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004208b78:	48 29 c2             	sub    %rax,%rdx
  8004208b7b:	48 89 d0             	mov    %rdx,%rax
  8004208b7e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	uint64_t kvoffset = 0;
  8004208b82:	48 c7 85 b8 fe ff ff 	movq   $0x0,-0x148(%rbp)
  8004208b89:	00 00 00 00 
	char *orig_secthdr = (char*)kvbase;
  8004208b8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208b91:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	char * secthdr = NULL;
  8004208b95:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8004208b9c:	00 
	uint64_t offset;
	if(elfhdr == KELFHDR)
  8004208b9d:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  8004208ba4:	00 00 00 
  8004208ba7:	48 39 85 a8 fe ff ff 	cmp    %rax,-0x158(%rbp)
  8004208bae:	75 11                	jne    8004208bc1 <read_section_headers+0xae>
		offset = ((Elf*)elfhdr)->e_shoff;
  8004208bb0:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208bb7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004208bbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208bbf:	eb 26                	jmp    8004208be7 <read_section_headers+0xd4>
	else
		offset = ((Elf*)elfhdr)->e_shoff + (elfhdr - KERNBASE);
  8004208bc1:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208bc8:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004208bcc:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208bd3:	48 01 c2             	add    %rax,%rdx
  8004208bd6:	48 b8 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rax
  8004208bdd:	ff ff ff 
  8004208be0:	48 01 d0             	add    %rdx,%rax
  8004208be3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	int numSectionHeaders = ((Elf*)elfhdr)->e_shnum;
  8004208be7:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208bee:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  8004208bf2:	0f b7 c0             	movzwl %ax,%eax
  8004208bf5:	89 45 c4             	mov    %eax,-0x3c(%rbp)
	int sizeSections = ((Elf*)elfhdr)->e_shentsize;
  8004208bf8:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208bff:	0f b7 40 3a          	movzwl 0x3a(%rax),%eax
  8004208c03:	0f b7 c0             	movzwl %ax,%eax
  8004208c06:	89 45 c0             	mov    %eax,-0x40(%rbp)
	char *nametab;
	int i;
	uint64_t temp;
	char *name;

	Elf *ehdr = (Elf *)elfhdr;
  8004208c09:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  8004208c10:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
  8004208c14:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8004208c17:	0f af 45 c0          	imul   -0x40(%rbp),%eax
  8004208c1b:	48 63 f0             	movslq %eax,%rsi
  8004208c1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208c22:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208c29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208c2d:	48 89 c7             	mov    %rax,%rdi
  8004208c30:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  8004208c37:	00 00 00 
  8004208c3a:	ff d0                	callq  *%rax
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
  8004208c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208c40:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8004208c44:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004208c48:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208c4e:	48 89 c2             	mov    %rax,%rdx
  8004208c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208c55:	48 29 d0             	sub    %rdx,%rax
  8004208c58:	48 89 c2             	mov    %rax,%rdx
  8004208c5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208c5f:	48 01 d0             	add    %rdx,%rax
  8004208c62:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	for (i = 0; i < numSectionHeaders; i++)
  8004208c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004208c6d:	eb 24                	jmp    8004208c93 <read_section_headers+0x180>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
  8004208c6f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c72:	48 98                	cltq   
  8004208c74:	48 c1 e0 06          	shl    $0x6,%rax
  8004208c78:	48 89 c2             	mov    %rax,%rdx
  8004208c7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004208c7f:	48 01 c2             	add    %rax,%rdx
  8004208c82:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c85:	48 98                	cltq   
  8004208c87:	48 89 94 c5 c0 fe ff 	mov    %rdx,-0x140(%rbp,%rax,8)
  8004208c8e:	ff 
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
	for (i = 0; i < numSectionHeaders; i++)
  8004208c8f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004208c93:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c96:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  8004208c99:	7c d4                	jl     8004208c6f <read_section_headers+0x15c>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
	}
	
	sec_name = secthdr_ptr[ehdr->e_shstrndx]; 
  8004208c9b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004208c9f:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  8004208ca3:	0f b7 c0             	movzwl %ax,%eax
  8004208ca6:	48 98                	cltq   
  8004208ca8:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208caf:	ff 
  8004208cb0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	temp = kvoffset;
  8004208cb4:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208cbb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
  8004208cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208cc3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208cc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208ccb:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208ccf:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208cd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208cda:	48 01 c8             	add    %rcx,%rax
  8004208cdd:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208ce4:	48 89 c7             	mov    %rax,%rdi
  8004208ce7:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  8004208cee:	00 00 00 
  8004208cf1:	ff d0                	callq  *%rax
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	
  8004208cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208cf7:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004208cff:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208d03:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  8004208d07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004208d0b:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208d11:	48 29 c2             	sub    %rax,%rdx
  8004208d14:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208d18:	48 01 c2             	add    %rax,%rdx
  8004208d1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208d1f:	48 01 d0             	add    %rdx,%rax
  8004208d22:	48 89 45 90          	mov    %rax,-0x70(%rbp)

	for (i = 0; i < numSectionHeaders; i++)
  8004208d26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004208d2d:	e9 04 05 00 00       	jmpq   8004209236 <read_section_headers+0x723>
	{
		name = (char *)(nametab + secthdr_ptr[i]->sh_name);
  8004208d32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208d35:	48 98                	cltq   
  8004208d37:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208d3e:	ff 
  8004208d3f:	8b 00                	mov    (%rax),%eax
  8004208d41:	89 c2                	mov    %eax,%edx
  8004208d43:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004208d47:	48 01 d0             	add    %rdx,%rax
  8004208d4a:	48 89 45 88          	mov    %rax,-0x78(%rbp)
		assert(kvoffset % SECTSIZE == 0);
  8004208d4e:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208d55:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004208d5a:	48 85 c0             	test   %rax,%rax
  8004208d5d:	74 35                	je     8004208d94 <read_section_headers+0x281>
  8004208d5f:	48 b9 66 a4 20 04 80 	movabs $0x800420a466,%rcx
  8004208d66:	00 00 00 
  8004208d69:	48 ba 7f a4 20 04 80 	movabs $0x800420a47f,%rdx
  8004208d70:	00 00 00 
  8004208d73:	be 86 00 00 00       	mov    $0x86,%esi
  8004208d78:	48 bf 94 a4 20 04 80 	movabs $0x800420a494,%rdi
  8004208d7f:	00 00 00 
  8004208d82:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208d87:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  8004208d8e:	00 00 00 
  8004208d91:	41 ff d0             	callq  *%r8
		temp = kvoffset;
  8004208d94:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  8004208d9b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
  8004208d9f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208da3:	48 be 2b a4 20 04 80 	movabs $0x800420a42b,%rsi
  8004208daa:	00 00 00 
  8004208dad:	48 89 c7             	mov    %rax,%rdi
  8004208db0:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208db7:	00 00 00 
  8004208dba:	ff d0                	callq  *%rax
  8004208dbc:	85 c0                	test   %eax,%eax
  8004208dbe:	0f 85 d8 00 00 00    	jne    8004208e9c <read_section_headers+0x389>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208dc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208dc7:	48 98                	cltq   
  8004208dc9:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208dd0:	ff 
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208dd1:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208dd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208dd8:	48 98                	cltq   
  8004208dda:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208de1:	ff 
  8004208de2:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208de6:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208ded:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208df1:	48 01 c8             	add    %rcx,%rax
  8004208df4:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208dfb:	48 89 c7             	mov    %rax,%rdi
  8004208dfe:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  8004208e05:	00 00 00 
  8004208e08:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_INFO].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208e0a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e0d:	48 98                	cltq   
  8004208e0f:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e16:	ff 
  8004208e17:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208e1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e1e:	48 98                	cltq   
  8004208e20:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e27:	ff 
  8004208e28:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208e2c:	48 89 45 80          	mov    %rax,-0x80(%rbp)
  8004208e30:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004208e34:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208e3a:	48 29 c2             	sub    %rax,%rdx
  8004208e3d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208e41:	48 01 c2             	add    %rax,%rdx
  8004208e44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208e48:	48 01 c2             	add    %rax,%rdx
  8004208e4b:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208e52:	00 00 00 
  8004208e55:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
  8004208e59:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208e60:	00 00 00 
  8004208e63:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004208e67:	48 89 c2             	mov    %rax,%rdx
  8004208e6a:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208e71:	00 00 00 
  8004208e74:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
  8004208e78:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208e7b:	48 98                	cltq   
  8004208e7d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208e84:	ff 
  8004208e85:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208e89:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208e90:	00 00 00 
  8004208e93:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004208e97:	e9 96 03 00 00       	jmpq   8004209232 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_abbrev"))
  8004208e9c:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208ea0:	48 be 37 a4 20 04 80 	movabs $0x800420a437,%rsi
  8004208ea7:	00 00 00 
  8004208eaa:	48 89 c7             	mov    %rax,%rdi
  8004208ead:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208eb4:	00 00 00 
  8004208eb7:	ff d0                	callq  *%rax
  8004208eb9:	85 c0                	test   %eax,%eax
  8004208ebb:	0f 85 de 00 00 00    	jne    8004208f9f <read_section_headers+0x48c>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208ec1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ec4:	48 98                	cltq   
  8004208ec6:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208ecd:	ff 
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_abbrev"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208ece:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208ed2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ed5:	48 98                	cltq   
  8004208ed7:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208ede:	ff 
  8004208edf:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208ee3:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208eee:	48 01 c8             	add    %rcx,%rax
  8004208ef1:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208ef8:	48 89 c7             	mov    %rax,%rdi
  8004208efb:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  8004208f02:	00 00 00 
  8004208f05:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_ABBREV].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004208f07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208f0a:	48 98                	cltq   
  8004208f0c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208f13:	ff 
  8004208f14:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208f18:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208f1b:	48 98                	cltq   
  8004208f1d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208f24:	ff 
  8004208f25:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208f29:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  8004208f30:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004208f37:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004208f3d:	48 29 c2             	sub    %rax,%rdx
  8004208f40:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004208f44:	48 01 c2             	add    %rax,%rdx
  8004208f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208f4b:	48 01 c2             	add    %rax,%rdx
  8004208f4e:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f55:	00 00 00 
  8004208f58:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
  8004208f5c:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f63:	00 00 00 
  8004208f66:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004208f6a:	48 89 c2             	mov    %rax,%rdx
  8004208f6d:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f74:	00 00 00 
  8004208f77:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
  8004208f7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208f7e:	48 98                	cltq   
  8004208f80:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208f87:	ff 
  8004208f88:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004208f8c:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004208f93:	00 00 00 
  8004208f96:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004208f9a:	e9 93 02 00 00       	jmpq   8004209232 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_line"))
  8004208f9f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004208fa3:	48 be 4f a4 20 04 80 	movabs $0x800420a44f,%rsi
  8004208faa:	00 00 00 
  8004208fad:	48 89 c7             	mov    %rax,%rdi
  8004208fb0:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004208fb7:	00 00 00 
  8004208fba:	ff d0                	callq  *%rax
  8004208fbc:	85 c0                	test   %eax,%eax
  8004208fbe:	0f 85 de 00 00 00    	jne    80042090a2 <read_section_headers+0x58f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  8004208fc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208fc7:	48 98                	cltq   
  8004208fc9:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208fd0:	ff 
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_line"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  8004208fd1:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8004208fd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208fd8:	48 98                	cltq   
  8004208fda:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004208fe1:	ff 
  8004208fe2:	48 8b 70 20          	mov    0x20(%rax),%rsi
  8004208fe6:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004208fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208ff1:	48 01 c8             	add    %rcx,%rax
  8004208ff4:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004208ffb:	48 89 c7             	mov    %rax,%rdi
  8004208ffe:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  8004209005:	00 00 00 
  8004209008:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_LINE].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  800420900a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420900d:	48 98                	cltq   
  800420900f:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004209016:	ff 
  8004209017:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420901b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420901e:	48 98                	cltq   
  8004209020:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004209027:	ff 
  8004209028:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420902c:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
  8004209033:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420903a:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  8004209040:	48 29 c2             	sub    %rax,%rdx
  8004209043:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209047:	48 01 c2             	add    %rax,%rdx
  800420904a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420904e:	48 01 c2             	add    %rax,%rdx
  8004209051:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209058:	00 00 00 
  800420905b:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = (uintptr_t)section_info[DEBUG_LINE].ds_data;
  800420905f:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209066:	00 00 00 
  8004209069:	48 8b 40 68          	mov    0x68(%rax),%rax
  800420906d:	48 89 c2             	mov    %rax,%rdx
  8004209070:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209077:	00 00 00 
  800420907a:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = secthdr_ptr[i]->sh_size;
  800420907e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209081:	48 98                	cltq   
  8004209083:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420908a:	ff 
  800420908b:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420908f:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209096:	00 00 00 
  8004209099:	48 89 50 78          	mov    %rdx,0x78(%rax)
  800420909d:	e9 90 01 00 00       	jmpq   8004209232 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".eh_frame"))
  80042090a2:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80042090a6:	48 be 45 a4 20 04 80 	movabs $0x800420a445,%rsi
  80042090ad:	00 00 00 
  80042090b0:	48 89 c7             	mov    %rax,%rdi
  80042090b3:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  80042090ba:	00 00 00 
  80042090bd:	ff d0                	callq  *%rax
  80042090bf:	85 c0                	test   %eax,%eax
  80042090c1:	75 65                	jne    8004209128 <read_section_headers+0x615>
		{
			section_info[DEBUG_FRAME].ds_data = (uint8_t *)secthdr_ptr[i]->sh_addr;
  80042090c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042090c6:	48 98                	cltq   
  80042090c8:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  80042090cf:	ff 
  80042090d0:	48 8b 40 10          	mov    0x10(%rax),%rax
  80042090d4:	48 89 c2             	mov    %rax,%rdx
  80042090d7:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042090de:	00 00 00 
  80042090e1:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
  80042090e5:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042090ec:	00 00 00 
  80042090ef:	48 8b 40 48          	mov    0x48(%rax),%rax
  80042090f3:	48 89 c2             	mov    %rax,%rdx
  80042090f6:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042090fd:	00 00 00 
  8004209100:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
  8004209104:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209107:	48 98                	cltq   
  8004209109:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004209110:	ff 
  8004209111:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004209115:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  800420911c:	00 00 00 
  800420911f:	48 89 50 58          	mov    %rdx,0x58(%rax)
  8004209123:	e9 0a 01 00 00       	jmpq   8004209232 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_str"))
  8004209128:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420912c:	48 be 5b a4 20 04 80 	movabs $0x800420a45b,%rsi
  8004209133:	00 00 00 
  8004209136:	48 89 c7             	mov    %rax,%rdi
  8004209139:	48 b8 bc 2f 20 04 80 	movabs $0x8004202fbc,%rax
  8004209140:	00 00 00 
  8004209143:	ff d0                	callq  *%rax
  8004209145:	85 c0                	test   %eax,%eax
  8004209147:	0f 85 e5 00 00 00    	jne    8004209232 <read_section_headers+0x71f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  800420914d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209150:	48 98                	cltq   
  8004209152:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  8004209159:	ff 
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_str"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  800420915a:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420915e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209161:	48 98                	cltq   
  8004209163:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420916a:	ff 
  800420916b:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420916f:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  8004209176:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420917a:	48 01 c8             	add    %rcx,%rax
  800420917d:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  8004209184:	48 89 c7             	mov    %rax,%rdi
  8004209187:	48 b8 52 92 20 04 80 	movabs $0x8004209252,%rax
  800420918e:	00 00 00 
  8004209191:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_STR].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  8004209193:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209196:	48 98                	cltq   
  8004209198:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420919f:	ff 
  80042091a0:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80042091a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042091a7:	48 98                	cltq   
  80042091a9:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  80042091b0:	ff 
  80042091b1:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042091b5:	48 89 85 68 ff ff ff 	mov    %rax,-0x98(%rbp)
  80042091bc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042091c3:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  80042091c9:	48 29 c2             	sub    %rax,%rdx
  80042091cc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042091d0:	48 01 c2             	add    %rax,%rdx
  80042091d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042091d7:	48 01 c2             	add    %rax,%rdx
  80042091da:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042091e1:	00 00 00 
  80042091e4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
  80042091eb:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  80042091f2:	00 00 00 
  80042091f5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80042091fc:	48 89 c2             	mov    %rax,%rdx
  80042091ff:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209206:	00 00 00 
  8004209209:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
  8004209210:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209213:	48 98                	cltq   
  8004209215:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420921c:	ff 
  800420921d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8004209221:	48 b8 00 c6 21 04 80 	movabs $0x800421c600,%rax
  8004209228:	00 00 00 
  800420922b:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
	temp = kvoffset;
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	

	for (i = 0; i < numSectionHeaders; i++)
  8004209232:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004209236:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209239:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  800420923c:	0f 8c f0 fa ff ff    	jl     8004208d32 <read_section_headers+0x21f>
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
		}
	}
	
	return ((uintptr_t)kvbase + kvoffset);
  8004209242:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004209246:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  800420924d:	48 01 d0             	add    %rdx,%rax
}
  8004209250:	c9                   	leaveq 
  8004209251:	c3                   	retq   

0000008004209252 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
void
readseg(uint64_t pa, uint64_t count, uint64_t offset, uint64_t* kvoffset)
{
  8004209252:	55                   	push   %rbp
  8004209253:	48 89 e5             	mov    %rsp,%rbp
  8004209256:	48 83 ec 30          	sub    $0x30,%rsp
  800420925a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420925e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004209262:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004209266:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	uint64_t end_pa;
	uint64_t orgoff = offset;
  800420926a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420926e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	end_pa = pa + count;
  8004209272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004209276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420927a:	48 01 d0             	add    %rdx,%rax
  800420927d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	assert(pa % SECTSIZE == 0);	
  8004209281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209285:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420928a:	48 85 c0             	test   %rax,%rax
  800420928d:	74 35                	je     80042092c4 <readseg+0x72>
  800420928f:	48 b9 a2 a4 20 04 80 	movabs $0x800420a4a2,%rcx
  8004209296:	00 00 00 
  8004209299:	48 ba 7f a4 20 04 80 	movabs $0x800420a47f,%rdx
  80042092a0:	00 00 00 
  80042092a3:	be c0 00 00 00       	mov    $0xc0,%esi
  80042092a8:	48 bf 94 a4 20 04 80 	movabs $0x800420a494,%rdi
  80042092af:	00 00 00 
  80042092b2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042092b7:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042092be:	00 00 00 
  80042092c1:	41 ff d0             	callq  *%r8
	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
  80042092c4:	48 81 65 e8 00 fe ff 	andq   $0xfffffffffffffe00,-0x18(%rbp)
  80042092cb:	ff 

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
  80042092cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042092d0:	48 c1 e8 09          	shr    $0x9,%rax
  80042092d4:	48 83 c0 01          	add    $0x1,%rax
  80042092d8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  80042092dc:	eb 3c                	jmp    800420931a <readseg+0xc8>
		readsect((uint8_t*) pa, offset);
  80042092de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042092e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042092e6:	48 89 d6             	mov    %rdx,%rsi
  80042092e9:	48 89 c7             	mov    %rax,%rdi
  80042092ec:	48 b8 e2 93 20 04 80 	movabs $0x80042093e2,%rax
  80042092f3:	00 00 00 
  80042092f6:	ff d0                	callq  *%rax
		pa += SECTSIZE;
  80042092f8:	48 81 45 e8 00 02 00 	addq   $0x200,-0x18(%rbp)
  80042092ff:	00 
		*kvoffset += SECTSIZE;
  8004209300:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004209304:	48 8b 00             	mov    (%rax),%rax
  8004209307:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  800420930e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004209312:	48 89 10             	mov    %rdx,(%rax)
		offset++;
  8004209315:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  800420931a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420931e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8004209322:	72 ba                	jb     80042092de <readseg+0x8c>
		pa += SECTSIZE;
		*kvoffset += SECTSIZE;
		offset++;
	}

	if(((orgoff % SECTSIZE) + count) > SECTSIZE)
  8004209324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004209328:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420932d:	48 89 c2             	mov    %rax,%rdx
  8004209330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004209334:	48 01 d0             	add    %rdx,%rax
  8004209337:	48 3d 00 02 00 00    	cmp    $0x200,%rax
  800420933d:	76 2f                	jbe    800420936e <readseg+0x11c>
	{
		readsect((uint8_t*) pa, offset);
  800420933f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209343:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004209347:	48 89 d6             	mov    %rdx,%rsi
  800420934a:	48 89 c7             	mov    %rax,%rdi
  800420934d:	48 b8 e2 93 20 04 80 	movabs $0x80042093e2,%rax
  8004209354:	00 00 00 
  8004209357:	ff d0                	callq  *%rax
		*kvoffset += SECTSIZE;
  8004209359:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420935d:	48 8b 00             	mov    (%rax),%rax
  8004209360:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  8004209367:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420936b:	48 89 10             	mov    %rdx,(%rax)
	}
	assert(*kvoffset % SECTSIZE == 0);
  800420936e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004209372:	48 8b 00             	mov    (%rax),%rax
  8004209375:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420937a:	48 85 c0             	test   %rax,%rax
  800420937d:	74 35                	je     80042093b4 <readseg+0x162>
  800420937f:	48 b9 b5 a4 20 04 80 	movabs $0x800420a4b5,%rcx
  8004209386:	00 00 00 
  8004209389:	48 ba 7f a4 20 04 80 	movabs $0x800420a47f,%rdx
  8004209390:	00 00 00 
  8004209393:	be d6 00 00 00       	mov    $0xd6,%esi
  8004209398:	48 bf 94 a4 20 04 80 	movabs $0x800420a494,%rdi
  800420939f:	00 00 00 
  80042093a2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042093a7:	49 b8 98 01 20 04 80 	movabs $0x8004200198,%r8
  80042093ae:	00 00 00 
  80042093b1:	41 ff d0             	callq  *%r8
}
  80042093b4:	c9                   	leaveq 
  80042093b5:	c3                   	retq   

00000080042093b6 <waitdisk>:

void
waitdisk(void)
{
  80042093b6:	55                   	push   %rbp
  80042093b7:	48 89 e5             	mov    %rsp,%rbp
  80042093ba:	48 83 ec 10          	sub    $0x10,%rsp
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
  80042093be:	90                   	nop
  80042093bf:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042093c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042093c9:	89 c2                	mov    %eax,%edx
  80042093cb:	ec                   	in     (%dx),%al
  80042093cc:	88 45 fb             	mov    %al,-0x5(%rbp)
	return data;
  80042093cf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80042093d3:	0f b6 c0             	movzbl %al,%eax
  80042093d6:	25 c0 00 00 00       	and    $0xc0,%eax
  80042093db:	83 f8 40             	cmp    $0x40,%eax
  80042093de:	75 df                	jne    80042093bf <waitdisk+0x9>
		/* do nothing */;
}
  80042093e0:	c9                   	leaveq 
  80042093e1:	c3                   	retq   

00000080042093e2 <readsect>:

void
readsect(void *dst, uint64_t offset)
{
  80042093e2:	55                   	push   %rbp
  80042093e3:	48 89 e5             	mov    %rsp,%rbp
  80042093e6:	48 83 ec 60          	sub    $0x60,%rsp
  80042093ea:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80042093ee:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	// wait for disk to be ready
	waitdisk();
  80042093f2:	48 b8 b6 93 20 04 80 	movabs $0x80042093b6,%rax
  80042093f9:	00 00 00 
  80042093fc:	ff d0                	callq  *%rax
  80042093fe:	c7 45 fc f2 01 00 00 	movl   $0x1f2,-0x4(%rbp)
  8004209405:	c6 45 fb 01          	movb   $0x1,-0x5(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004209409:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800420940d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004209410:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
  8004209411:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209415:	0f b6 c0             	movzbl %al,%eax
  8004209418:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%rbp)
  800420941f:	88 45 f3             	mov    %al,-0xd(%rbp)
  8004209422:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8004209426:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004209429:	ee                   	out    %al,(%dx)
	outb(0x1F4, offset >> 8);
  800420942a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420942e:	48 c1 e8 08          	shr    $0x8,%rax
  8004209432:	0f b6 c0             	movzbl %al,%eax
  8004209435:	c7 45 ec f4 01 00 00 	movl   $0x1f4,-0x14(%rbp)
  800420943c:	88 45 eb             	mov    %al,-0x15(%rbp)
  800420943f:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  8004209443:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004209446:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
  8004209447:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420944b:	48 c1 e8 10          	shr    $0x10,%rax
  800420944f:	0f b6 c0             	movzbl %al,%eax
  8004209452:	c7 45 e4 f5 01 00 00 	movl   $0x1f5,-0x1c(%rbp)
  8004209459:	88 45 e3             	mov    %al,-0x1d(%rbp)
  800420945c:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8004209460:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004209463:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
  8004209464:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209468:	48 c1 e8 18          	shr    $0x18,%rax
  800420946c:	83 c8 e0             	or     $0xffffffe0,%eax
  800420946f:	0f b6 c0             	movzbl %al,%eax
  8004209472:	c7 45 dc f6 01 00 00 	movl   $0x1f6,-0x24(%rbp)
  8004209479:	88 45 db             	mov    %al,-0x25(%rbp)
  800420947c:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  8004209480:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004209483:	ee                   	out    %al,(%dx)
  8004209484:	c7 45 d4 f7 01 00 00 	movl   $0x1f7,-0x2c(%rbp)
  800420948b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
  800420948f:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  8004209493:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8004209496:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
  8004209497:	48 b8 b6 93 20 04 80 	movabs $0x80042093b6,%rax
  800420949e:	00 00 00 
  80042094a1:	ff d0                	callq  *%rax
  80042094a3:	c7 45 cc f0 01 00 00 	movl   $0x1f0,-0x34(%rbp)
  80042094aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042094ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80042094b2:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  80042094b9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80042094bc:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80042094c0:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80042094c3:	48 89 ce             	mov    %rcx,%rsi
  80042094c6:	48 89 f7             	mov    %rsi,%rdi
  80042094c9:	89 c1                	mov    %eax,%ecx
  80042094cb:	fc                   	cld    
  80042094cc:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  80042094ce:	89 c8                	mov    %ecx,%eax
  80042094d0:	48 89 fe             	mov    %rdi,%rsi
  80042094d3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80042094d7:	89 45 bc             	mov    %eax,-0x44(%rbp)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
  80042094da:	c9                   	leaveq 
  80042094db:	c3                   	retq   
