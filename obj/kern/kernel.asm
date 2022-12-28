
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
  800420000c:	48 b8 38 20 22 04 80 	movabs $0x8004222038,%rax
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
  800420003d:	48 b8 00 20 22 04 80 	movabs $0x8004222000,%rax
  8004200044:	00 00 00 
	movq  %rax,%rsp
  8004200047:	48 89 c4             	mov    %rax,%rsp

	# now to C code
    movabs $i386_init, %rax
  800420004a:	48 b8 58 00 20 04 80 	movabs $0x8004200058,%rax
  8004200051:	00 00 00 
	call *%rax
  8004200054:	ff d0                	callq  *%rax

0000008004200056 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
  8004200056:	eb fe                	jmp    8004200056 <spin>

0000008004200058 <i386_init>:



void
i386_init(void)
{
  8004200058:	55                   	push   %rbp
  8004200059:	48 89 e5             	mov    %rsp,%rbp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
  800420005c:	48 ba 80 3d 22 04 80 	movabs $0x8004223d80,%rdx
  8004200063:	00 00 00 
  8004200066:	48 b8 a0 26 22 04 80 	movabs $0x80042226a0,%rax
  800420006d:	00 00 00 
  8004200070:	48 29 c2             	sub    %rax,%rdx
  8004200073:	48 89 d0             	mov    %rdx,%rax
  8004200076:	48 89 c2             	mov    %rax,%rdx
  8004200079:	be 00 00 00 00       	mov    $0x0,%esi
  800420007e:	48 bf a0 26 22 04 80 	movabs $0x80042226a0,%rdi
  8004200085:	00 00 00 
  8004200088:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420008f:	00 00 00 
  8004200092:	ff d0                	callq  *%rax

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
  8004200094:	48 b8 76 0d 20 04 80 	movabs $0x8004200d76,%rax
  800420009b:	00 00 00 
  800420009e:	ff d0                	callq  *%rax

	cprintf("6828 decimal is %o octal!\n", 6828);
  80042000a0:	be ac 1a 00 00       	mov    $0x1aac,%esi
  80042000a5:	48 bf a0 e3 20 04 80 	movabs $0x800420e3a0,%rdi
  80042000ac:	00 00 00 
  80042000af:	b8 00 00 00 00       	mov    $0x0,%eax
  80042000b4:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  80042000bb:	00 00 00 
  80042000be:	ff d2                	callq  *%rdx

	extern char end[];
	end_debug = read_section_headers((0x10000+KERNBASE), (uintptr_t)end);
  80042000c0:	48 b8 80 3d 22 04 80 	movabs $0x8004223d80,%rax
  80042000c7:	00 00 00 
  80042000ca:	48 89 c6             	mov    %rax,%rsi
  80042000cd:	48 bf 00 00 01 04 80 	movabs $0x8004010000,%rdi
  80042000d4:	00 00 00 
  80042000d7:	48 b8 d6 d9 20 04 80 	movabs $0x800420d9d6,%rax
  80042000de:	00 00 00 
  80042000e1:	ff d0                	callq  *%rax
  80042000e3:	48 ba 68 2d 22 04 80 	movabs $0x8004222d68,%rdx
  80042000ea:	00 00 00 
  80042000ed:	48 89 02             	mov    %rax,(%rdx)

	// Lab 2 memory management initialization functions
	x64_vm_init();
  80042000f0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042000f5:	48 ba 18 1e 20 04 80 	movabs $0x8004201e18,%rdx
  80042000fc:	00 00 00 
  80042000ff:	ff d2                	callq  *%rdx



	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
  8004200101:	bf 00 00 00 00       	mov    $0x0,%edi
  8004200106:	48 b8 71 12 20 04 80 	movabs $0x8004201271,%rax
  800420010d:	00 00 00 
  8004200110:	ff d0                	callq  *%rax
  8004200112:	eb ed                	jmp    8004200101 <i386_init+0xa9>

0000008004200114 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004200114:	55                   	push   %rbp
  8004200115:	48 89 e5             	mov    %rsp,%rbp
  8004200118:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800420011f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8004200126:	89 b5 24 ff ff ff    	mov    %esi,-0xdc(%rbp)
  800420012c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004200133:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800420013a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004200141:	84 c0                	test   %al,%al
  8004200143:	74 20                	je     8004200165 <_panic+0x51>
  8004200145:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004200149:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800420014d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004200151:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004200155:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004200159:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800420015d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004200161:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004200165:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	if (panicstr)
  800420016c:	48 b8 70 2d 22 04 80 	movabs $0x8004222d70,%rax
  8004200173:	00 00 00 
  8004200176:	48 8b 00             	mov    (%rax),%rax
  8004200179:	48 85 c0             	test   %rax,%rax
  800420017c:	74 05                	je     8004200183 <_panic+0x6f>
		goto dead;
  800420017e:	e9 a9 00 00 00       	jmpq   800420022c <_panic+0x118>
	panicstr = fmt;
  8004200183:	48 b8 70 2d 22 04 80 	movabs $0x8004222d70,%rax
  800420018a:	00 00 00 
  800420018d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004200194:	48 89 10             	mov    %rdx,(%rax)

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
  8004200197:	fa                   	cli    
  8004200198:	fc                   	cld    

	va_start(ap, fmt);
  8004200199:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80042001a0:	00 00 00 
  80042001a3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80042001aa:	00 00 00 
  80042001ad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80042001b1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80042001b8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042001bf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	cprintf("kernel panic at %s:%d: ", file, line);
  80042001c6:	8b 95 24 ff ff ff    	mov    -0xdc(%rbp),%edx
  80042001cc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042001d3:	48 89 c6             	mov    %rax,%rsi
  80042001d6:	48 bf bb e3 20 04 80 	movabs $0x800420e3bb,%rdi
  80042001dd:	00 00 00 
  80042001e0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042001e5:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  80042001ec:	00 00 00 
  80042001ef:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  80042001f1:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  80042001f8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80042001ff:	48 89 d6             	mov    %rdx,%rsi
  8004200202:	48 89 c7             	mov    %rax,%rdi
  8004200205:	48 b8 07 64 20 04 80 	movabs $0x8004206407,%rax
  800420020c:	00 00 00 
  800420020f:	ff d0                	callq  *%rax
	cprintf("\n");
  8004200211:	48 bf d3 e3 20 04 80 	movabs $0x800420e3d3,%rdi
  8004200218:	00 00 00 
  800420021b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200220:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200227:	00 00 00 
  800420022a:	ff d2                	callq  *%rdx
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
  800420022c:	bf 00 00 00 00       	mov    $0x0,%edi
  8004200231:	48 b8 71 12 20 04 80 	movabs $0x8004201271,%rax
  8004200238:	00 00 00 
  800420023b:	ff d0                	callq  *%rax
  800420023d:	eb ed                	jmp    800420022c <_panic+0x118>

000000800420023f <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
  800420023f:	55                   	push   %rbp
  8004200240:	48 89 e5             	mov    %rsp,%rbp
  8004200243:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800420024a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8004200251:	89 b5 24 ff ff ff    	mov    %esi,-0xdc(%rbp)
  8004200257:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800420025e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004200265:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800420026c:	84 c0                	test   %al,%al
  800420026e:	74 20                	je     8004200290 <_warn+0x51>
  8004200270:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004200274:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004200278:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800420027c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004200280:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004200284:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004200288:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800420028c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004200290:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004200297:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800420029e:	00 00 00 
  80042002a1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80042002a8:	00 00 00 
  80042002ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80042002af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80042002b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042002bd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	cprintf("kernel warning at %s:%d: ", file, line);
  80042002c4:	8b 95 24 ff ff ff    	mov    -0xdc(%rbp),%edx
  80042002ca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80042002d1:	48 89 c6             	mov    %rax,%rsi
  80042002d4:	48 bf d5 e3 20 04 80 	movabs $0x800420e3d5,%rdi
  80042002db:	00 00 00 
  80042002de:	b8 00 00 00 00       	mov    $0x0,%eax
  80042002e3:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  80042002ea:	00 00 00 
  80042002ed:	ff d1                	callq  *%rcx
	vcprintf(fmt, ap);
  80042002ef:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  80042002f6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80042002fd:	48 89 d6             	mov    %rdx,%rsi
  8004200300:	48 89 c7             	mov    %rax,%rdi
  8004200303:	48 b8 07 64 20 04 80 	movabs $0x8004206407,%rax
  800420030a:	00 00 00 
  800420030d:	ff d0                	callq  *%rax
	cprintf("\n");
  800420030f:	48 bf d3 e3 20 04 80 	movabs $0x800420e3d3,%rdi
  8004200316:	00 00 00 
  8004200319:	b8 00 00 00 00       	mov    $0x0,%eax
  800420031e:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200325:	00 00 00 
  8004200328:	ff d2                	callq  *%rdx
	va_end(ap);
}
  800420032a:	c9                   	leaveq 
  800420032b:	c3                   	retq   

000000800420032c <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
  800420032c:	55                   	push   %rbp
  800420032d:	48 89 e5             	mov    %rsp,%rbp
  8004200330:	48 83 ec 20          	sub    $0x20,%rsp
  8004200334:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800420033b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420033e:	89 c2                	mov    %eax,%edx
  8004200340:	ec                   	in     (%dx),%al
  8004200341:	88 45 fb             	mov    %al,-0x5(%rbp)
  8004200344:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
  800420034b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420034e:	89 c2                	mov    %eax,%edx
  8004200350:	ec                   	in     (%dx),%al
  8004200351:	88 45 f3             	mov    %al,-0xd(%rbp)
  8004200354:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
  800420035b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420035e:	89 c2                	mov    %eax,%edx
  8004200360:	ec                   	in     (%dx),%al
  8004200361:	88 45 eb             	mov    %al,-0x15(%rbp)
  8004200364:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
  800420036b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420036e:	89 c2                	mov    %eax,%edx
  8004200370:	ec                   	in     (%dx),%al
  8004200371:	88 45 e3             	mov    %al,-0x1d(%rbp)
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
  8004200374:	c9                   	leaveq 
  8004200375:	c3                   	retq   

0000008004200376 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
  8004200376:	55                   	push   %rbp
  8004200377:	48 89 e5             	mov    %rsp,%rbp
  800420037a:	48 83 ec 10          	sub    $0x10,%rsp
  800420037e:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%rbp)
  8004200385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200388:	89 c2                	mov    %eax,%edx
  800420038a:	ec                   	in     (%dx),%al
  800420038b:	88 45 fb             	mov    %al,-0x5(%rbp)
	return data;
  800420038e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  8004200392:	0f b6 c0             	movzbl %al,%eax
  8004200395:	83 e0 01             	and    $0x1,%eax
  8004200398:	85 c0                	test   %eax,%eax
  800420039a:	75 07                	jne    80042003a3 <serial_proc_data+0x2d>
		return -1;
  800420039c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042003a1:	eb 17                	jmp    80042003ba <serial_proc_data+0x44>
  80042003a3:	c7 45 f4 f8 03 00 00 	movl   $0x3f8,-0xc(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042003aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042003ad:	89 c2                	mov    %eax,%edx
  80042003af:	ec                   	in     (%dx),%al
  80042003b0:	88 45 f3             	mov    %al,-0xd(%rbp)
	return data;
  80042003b3:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
	return inb(COM1+COM_RX);
  80042003b7:	0f b6 c0             	movzbl %al,%eax
}
  80042003ba:	c9                   	leaveq 
  80042003bb:	c3                   	retq   

00000080042003bc <serial_intr>:

void
serial_intr(void)
{
  80042003bc:	55                   	push   %rbp
  80042003bd:	48 89 e5             	mov    %rsp,%rbp
	if (serial_exists)
  80042003c0:	48 b8 a0 26 22 04 80 	movabs $0x80042226a0,%rax
  80042003c7:	00 00 00 
  80042003ca:	0f b6 00             	movzbl (%rax),%eax
  80042003cd:	84 c0                	test   %al,%al
  80042003cf:	74 16                	je     80042003e7 <serial_intr+0x2b>
		cons_intr(serial_proc_data);
  80042003d1:	48 bf 76 03 20 04 80 	movabs $0x8004200376,%rdi
  80042003d8:	00 00 00 
  80042003db:	48 b8 f9 0b 20 04 80 	movabs $0x8004200bf9,%rax
  80042003e2:	00 00 00 
  80042003e5:	ff d0                	callq  *%rax
}
  80042003e7:	5d                   	pop    %rbp
  80042003e8:	c3                   	retq   

00000080042003e9 <serial_putc>:

static void
serial_putc(int c)
{
  80042003e9:	55                   	push   %rbp
  80042003ea:	48 89 e5             	mov    %rsp,%rbp
  80042003ed:	48 83 ec 28          	sub    $0x28,%rsp
  80042003f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i;

	for (i = 0;
  80042003f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80042003fb:	eb 10                	jmp    800420040d <serial_putc+0x24>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
  80042003fd:	48 b8 2c 03 20 04 80 	movabs $0x800420032c,%rax
  8004200404:	00 00 00 
  8004200407:	ff d0                	callq  *%rax
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
  8004200409:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800420040d:	c7 45 f8 fd 03 00 00 	movl   $0x3fd,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200414:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004200417:	89 c2                	mov    %eax,%edx
  8004200419:	ec                   	in     (%dx),%al
  800420041a:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800420041d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
serial_putc(int c)
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  8004200421:	0f b6 c0             	movzbl %al,%eax
  8004200424:	83 e0 20             	and    $0x20,%eax
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
  8004200427:	85 c0                	test   %eax,%eax
  8004200429:	75 09                	jne    8004200434 <serial_putc+0x4b>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  800420042b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
  8004200432:	7e c9                	jle    80042003fd <serial_putc+0x14>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
  8004200434:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004200437:	0f b6 c0             	movzbl %al,%eax
  800420043a:	c7 45 f0 f8 03 00 00 	movl   $0x3f8,-0x10(%rbp)
  8004200441:	88 45 ef             	mov    %al,-0x11(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004200444:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8004200448:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800420044b:	ee                   	out    %al,(%dx)
}
  800420044c:	c9                   	leaveq 
  800420044d:	c3                   	retq   

000000800420044e <serial_init>:

static void
serial_init(void)
{
  800420044e:	55                   	push   %rbp
  800420044f:	48 89 e5             	mov    %rsp,%rbp
  8004200452:	48 83 ec 50          	sub    $0x50,%rsp
  8004200456:	c7 45 fc fa 03 00 00 	movl   $0x3fa,-0x4(%rbp)
  800420045d:	c6 45 fb 00          	movb   $0x0,-0x5(%rbp)
  8004200461:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200465:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004200468:	ee                   	out    %al,(%dx)
  8004200469:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%rbp)
  8004200470:	c6 45 f3 80          	movb   $0x80,-0xd(%rbp)
  8004200474:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8004200478:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420047b:	ee                   	out    %al,(%dx)
  800420047c:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%rbp)
  8004200483:	c6 45 eb 0c          	movb   $0xc,-0x15(%rbp)
  8004200487:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  800420048b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800420048e:	ee                   	out    %al,(%dx)
  800420048f:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%rbp)
  8004200496:	c6 45 e3 00          	movb   $0x0,-0x1d(%rbp)
  800420049a:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  800420049e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80042004a1:	ee                   	out    %al,(%dx)
  80042004a2:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%rbp)
  80042004a9:	c6 45 db 03          	movb   $0x3,-0x25(%rbp)
  80042004ad:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  80042004b1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80042004b4:	ee                   	out    %al,(%dx)
  80042004b5:	c7 45 d4 fc 03 00 00 	movl   $0x3fc,-0x2c(%rbp)
  80042004bc:	c6 45 d3 00          	movb   $0x0,-0x2d(%rbp)
  80042004c0:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  80042004c4:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80042004c7:	ee                   	out    %al,(%dx)
  80042004c8:	c7 45 cc f9 03 00 00 	movl   $0x3f9,-0x34(%rbp)
  80042004cf:	c6 45 cb 01          	movb   $0x1,-0x35(%rbp)
  80042004d3:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
  80042004d7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80042004da:	ee                   	out    %al,(%dx)
  80042004db:	c7 45 c4 fd 03 00 00 	movl   $0x3fd,-0x3c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042004e2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80042004e5:	89 c2                	mov    %eax,%edx
  80042004e7:	ec                   	in     (%dx),%al
  80042004e8:	88 45 c3             	mov    %al,-0x3d(%rbp)
	return data;
  80042004eb:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  80042004ef:	3c ff                	cmp    $0xff,%al
  80042004f1:	0f 95 c2             	setne  %dl
  80042004f4:	48 b8 a0 26 22 04 80 	movabs $0x80042226a0,%rax
  80042004fb:	00 00 00 
  80042004fe:	88 10                	mov    %dl,(%rax)
  8004200500:	c7 45 bc fa 03 00 00 	movl   $0x3fa,-0x44(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200507:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800420050a:	89 c2                	mov    %eax,%edx
  800420050c:	ec                   	in     (%dx),%al
  800420050d:	88 45 bb             	mov    %al,-0x45(%rbp)
  8004200510:	c7 45 b4 f8 03 00 00 	movl   $0x3f8,-0x4c(%rbp)
  8004200517:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  800420051a:	89 c2                	mov    %eax,%edx
  800420051c:	ec                   	in     (%dx),%al
  800420051d:	88 45 b3             	mov    %al,-0x4d(%rbp)
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

}
  8004200520:	c9                   	leaveq 
  8004200521:	c3                   	retq   

0000008004200522 <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
  8004200522:	55                   	push   %rbp
  8004200523:	48 89 e5             	mov    %rsp,%rbp
  8004200526:	48 83 ec 38          	sub    $0x38,%rsp
  800420052a:	89 7d cc             	mov    %edi,-0x34(%rbp)
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  800420052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004200534:	eb 10                	jmp    8004200546 <lpt_putc+0x24>
		delay();
  8004200536:	48 b8 2c 03 20 04 80 	movabs $0x800420032c,%rax
  800420053d:	00 00 00 
  8004200540:	ff d0                	callq  *%rax
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  8004200542:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004200546:	c7 45 f8 79 03 00 00 	movl   $0x379,-0x8(%rbp)
  800420054d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004200550:	89 c2                	mov    %eax,%edx
  8004200552:	ec                   	in     (%dx),%al
  8004200553:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  8004200556:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800420055a:	84 c0                	test   %al,%al
  800420055c:	78 09                	js     8004200567 <lpt_putc+0x45>
  800420055e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
  8004200565:	7e cf                	jle    8004200536 <lpt_putc+0x14>
		delay();
	outb(0x378+0, c);
  8004200567:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800420056a:	0f b6 c0             	movzbl %al,%eax
  800420056d:	c7 45 f0 78 03 00 00 	movl   $0x378,-0x10(%rbp)
  8004200574:	88 45 ef             	mov    %al,-0x11(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004200577:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800420057b:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800420057e:	ee                   	out    %al,(%dx)
  800420057f:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
  8004200586:	c6 45 e7 0d          	movb   $0xd,-0x19(%rbp)
  800420058a:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800420058e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8004200591:	ee                   	out    %al,(%dx)
  8004200592:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
  8004200599:	c6 45 df 08          	movb   $0x8,-0x21(%rbp)
  800420059d:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80042005a1:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80042005a4:	ee                   	out    %al,(%dx)
	outb(0x378+2, 0x08|0x04|0x01);
	outb(0x378+2, 0x08);
}
  80042005a5:	c9                   	leaveq 
  80042005a6:	c3                   	retq   

00000080042005a7 <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
  80042005a7:	55                   	push   %rbp
  80042005a8:	48 89 e5             	mov    %rsp,%rbp
  80042005ab:	48 83 ec 30          	sub    $0x30,%rsp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
  80042005af:	48 b8 00 80 0b 04 80 	movabs $0x80040b8000,%rax
  80042005b6:	00 00 00 
  80042005b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	was = *cp;
  80042005bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042005c1:	0f b7 00             	movzwl (%rax),%eax
  80042005c4:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
	*cp = (uint16_t) 0xA55A;
  80042005c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042005cc:	66 c7 00 5a a5       	movw   $0xa55a,(%rax)
	if (*cp != 0xA55A) {
  80042005d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042005d5:	0f b7 00             	movzwl (%rax),%eax
  80042005d8:	66 3d 5a a5          	cmp    $0xa55a,%ax
  80042005dc:	74 20                	je     80042005fe <cga_init+0x57>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
  80042005de:	48 b8 00 00 0b 04 80 	movabs $0x80040b0000,%rax
  80042005e5:	00 00 00 
  80042005e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		addr_6845 = MONO_BASE;
  80042005ec:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  80042005f3:	00 00 00 
  80042005f6:	c7 00 b4 03 00 00    	movl   $0x3b4,(%rax)
  80042005fc:	eb 1b                	jmp    8004200619 <cga_init+0x72>
	} else {
		*cp = was;
  80042005fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004200602:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
  8004200606:	66 89 10             	mov    %dx,(%rax)
		addr_6845 = CGA_BASE;
  8004200609:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  8004200610:	00 00 00 
  8004200613:	c7 00 d4 03 00 00    	movl   $0x3d4,(%rax)
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
  8004200619:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  8004200620:	00 00 00 
  8004200623:	8b 00                	mov    (%rax),%eax
  8004200625:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8004200628:	c6 45 eb 0e          	movb   $0xe,-0x15(%rbp)
  800420062c:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  8004200630:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004200633:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
  8004200634:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  800420063b:	00 00 00 
  800420063e:	8b 00                	mov    (%rax),%eax
  8004200640:	83 c0 01             	add    $0x1,%eax
  8004200643:	89 45 e4             	mov    %eax,-0x1c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200646:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004200649:	89 c2                	mov    %eax,%edx
  800420064b:	ec                   	in     (%dx),%al
  800420064c:	88 45 e3             	mov    %al,-0x1d(%rbp)
	return data;
  800420064f:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8004200653:	0f b6 c0             	movzbl %al,%eax
  8004200656:	c1 e0 08             	shl    $0x8,%eax
  8004200659:	89 45 f0             	mov    %eax,-0x10(%rbp)
	outb(addr_6845, 15);
  800420065c:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  8004200663:	00 00 00 
  8004200666:	8b 00                	mov    (%rax),%eax
  8004200668:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800420066b:	c6 45 db 0f          	movb   $0xf,-0x25(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800420066f:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  8004200673:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004200676:	ee                   	out    %al,(%dx)
	pos |= inb(addr_6845 + 1);
  8004200677:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  800420067e:	00 00 00 
  8004200681:	8b 00                	mov    (%rax),%eax
  8004200683:	83 c0 01             	add    $0x1,%eax
  8004200686:	89 45 d4             	mov    %eax,-0x2c(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004200689:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800420068c:	89 c2                	mov    %eax,%edx
  800420068e:	ec                   	in     (%dx),%al
  800420068f:	88 45 d3             	mov    %al,-0x2d(%rbp)
	return data;
  8004200692:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  8004200696:	0f b6 c0             	movzbl %al,%eax
  8004200699:	09 45 f0             	or     %eax,-0x10(%rbp)

	crt_buf = (uint16_t*) cp;
  800420069c:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  80042006a3:	00 00 00 
  80042006a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042006aa:	48 89 10             	mov    %rdx,(%rax)
	crt_pos = pos;
  80042006ad:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80042006b0:	89 c2                	mov    %eax,%edx
  80042006b2:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  80042006b9:	00 00 00 
  80042006bc:	66 89 10             	mov    %dx,(%rax)
}
  80042006bf:	c9                   	leaveq 
  80042006c0:	c3                   	retq   

00000080042006c1 <cga_putc>:



static void
cga_putc(int c)
{
  80042006c1:	55                   	push   %rbp
  80042006c2:	48 89 e5             	mov    %rsp,%rbp
  80042006c5:	48 83 ec 40          	sub    $0x40,%rsp
  80042006c9:	89 7d cc             	mov    %edi,-0x34(%rbp)
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
  80042006cc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042006cf:	b0 00                	mov    $0x0,%al
  80042006d1:	85 c0                	test   %eax,%eax
  80042006d3:	75 07                	jne    80042006dc <cga_putc+0x1b>
		c |= 0x0700;
  80042006d5:	81 4d cc 00 07 00 00 	orl    $0x700,-0x34(%rbp)

	switch (c & 0xff) {
  80042006dc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80042006df:	0f b6 c0             	movzbl %al,%eax
  80042006e2:	83 f8 09             	cmp    $0x9,%eax
  80042006e5:	0f 84 f6 00 00 00    	je     80042007e1 <cga_putc+0x120>
  80042006eb:	83 f8 09             	cmp    $0x9,%eax
  80042006ee:	7f 0a                	jg     80042006fa <cga_putc+0x39>
  80042006f0:	83 f8 08             	cmp    $0x8,%eax
  80042006f3:	74 18                	je     800420070d <cga_putc+0x4c>
  80042006f5:	e9 3e 01 00 00       	jmpq   8004200838 <cga_putc+0x177>
  80042006fa:	83 f8 0a             	cmp    $0xa,%eax
  80042006fd:	74 75                	je     8004200774 <cga_putc+0xb3>
  80042006ff:	83 f8 0d             	cmp    $0xd,%eax
  8004200702:	0f 84 89 00 00 00    	je     8004200791 <cga_putc+0xd0>
  8004200708:	e9 2b 01 00 00       	jmpq   8004200838 <cga_putc+0x177>
	case '\b':
		if (crt_pos > 0) {
  800420070d:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200714:	00 00 00 
  8004200717:	0f b7 00             	movzwl (%rax),%eax
  800420071a:	66 85 c0             	test   %ax,%ax
  800420071d:	74 50                	je     800420076f <cga_putc+0xae>
			crt_pos--;
  800420071f:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200726:	00 00 00 
  8004200729:	0f b7 00             	movzwl (%rax),%eax
  800420072c:	8d 50 ff             	lea    -0x1(%rax),%edx
  800420072f:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200736:	00 00 00 
  8004200739:	66 89 10             	mov    %dx,(%rax)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
  800420073c:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  8004200743:	00 00 00 
  8004200746:	48 8b 10             	mov    (%rax),%rdx
  8004200749:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200750:	00 00 00 
  8004200753:	0f b7 00             	movzwl (%rax),%eax
  8004200756:	0f b7 c0             	movzwl %ax,%eax
  8004200759:	48 01 c0             	add    %rax,%rax
  800420075c:	48 01 c2             	add    %rax,%rdx
  800420075f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004200762:	b0 00                	mov    $0x0,%al
  8004200764:	83 c8 20             	or     $0x20,%eax
  8004200767:	66 89 02             	mov    %ax,(%rdx)
		}
		break;
  800420076a:	e9 04 01 00 00       	jmpq   8004200873 <cga_putc+0x1b2>
  800420076f:	e9 ff 00 00 00       	jmpq   8004200873 <cga_putc+0x1b2>
	case '\n':
		crt_pos += CRT_COLS;
  8004200774:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  800420077b:	00 00 00 
  800420077e:	0f b7 00             	movzwl (%rax),%eax
  8004200781:	8d 50 50             	lea    0x50(%rax),%edx
  8004200784:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  800420078b:	00 00 00 
  800420078e:	66 89 10             	mov    %dx,(%rax)
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
  8004200791:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200798:	00 00 00 
  800420079b:	0f b7 30             	movzwl (%rax),%esi
  800420079e:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  80042007a5:	00 00 00 
  80042007a8:	0f b7 08             	movzwl (%rax),%ecx
  80042007ab:	0f b7 c1             	movzwl %cx,%eax
  80042007ae:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  80042007b4:	c1 e8 10             	shr    $0x10,%eax
  80042007b7:	89 c2                	mov    %eax,%edx
  80042007b9:	66 c1 ea 06          	shr    $0x6,%dx
  80042007bd:	89 d0                	mov    %edx,%eax
  80042007bf:	c1 e0 02             	shl    $0x2,%eax
  80042007c2:	01 d0                	add    %edx,%eax
  80042007c4:	c1 e0 04             	shl    $0x4,%eax
  80042007c7:	29 c1                	sub    %eax,%ecx
  80042007c9:	89 ca                	mov    %ecx,%edx
  80042007cb:	29 d6                	sub    %edx,%esi
  80042007cd:	89 f2                	mov    %esi,%edx
  80042007cf:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  80042007d6:	00 00 00 
  80042007d9:	66 89 10             	mov    %dx,(%rax)
		break;
  80042007dc:	e9 92 00 00 00       	jmpq   8004200873 <cga_putc+0x1b2>
	case '\t':
		cons_putc(' ');
  80042007e1:	bf 20 00 00 00       	mov    $0x20,%edi
  80042007e6:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  80042007ed:	00 00 00 
  80042007f0:	ff d0                	callq  *%rax
		cons_putc(' ');
  80042007f2:	bf 20 00 00 00       	mov    $0x20,%edi
  80042007f7:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  80042007fe:	00 00 00 
  8004200801:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200803:	bf 20 00 00 00       	mov    $0x20,%edi
  8004200808:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  800420080f:	00 00 00 
  8004200812:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200814:	bf 20 00 00 00       	mov    $0x20,%edi
  8004200819:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  8004200820:	00 00 00 
  8004200823:	ff d0                	callq  *%rax
		cons_putc(' ');
  8004200825:	bf 20 00 00 00       	mov    $0x20,%edi
  800420082a:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  8004200831:	00 00 00 
  8004200834:	ff d0                	callq  *%rax
		break;
  8004200836:	eb 3b                	jmp    8004200873 <cga_putc+0x1b2>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
  8004200838:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  800420083f:	00 00 00 
  8004200842:	48 8b 30             	mov    (%rax),%rsi
  8004200845:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  800420084c:	00 00 00 
  800420084f:	0f b7 00             	movzwl (%rax),%eax
  8004200852:	8d 48 01             	lea    0x1(%rax),%ecx
  8004200855:	48 ba b0 26 22 04 80 	movabs $0x80042226b0,%rdx
  800420085c:	00 00 00 
  800420085f:	66 89 0a             	mov    %cx,(%rdx)
  8004200862:	0f b7 c0             	movzwl %ax,%eax
  8004200865:	48 01 c0             	add    %rax,%rax
  8004200868:	48 8d 14 06          	lea    (%rsi,%rax,1),%rdx
  800420086c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800420086f:	66 89 02             	mov    %ax,(%rdx)
		break;
  8004200872:	90                   	nop
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
  8004200873:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  800420087a:	00 00 00 
  800420087d:	0f b7 00             	movzwl (%rax),%eax
  8004200880:	66 3d cf 07          	cmp    $0x7cf,%ax
  8004200884:	0f 86 89 00 00 00    	jbe    8004200913 <cga_putc+0x252>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  800420088a:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  8004200891:	00 00 00 
  8004200894:	48 8b 00             	mov    (%rax),%rax
  8004200897:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
  800420089e:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  80042008a5:	00 00 00 
  80042008a8:	48 8b 00             	mov    (%rax),%rax
  80042008ab:	ba 00 0f 00 00       	mov    $0xf00,%edx
  80042008b0:	48 89 ce             	mov    %rcx,%rsi
  80042008b3:	48 89 c7             	mov    %rax,%rdi
  80042008b6:	48 b8 41 80 20 04 80 	movabs $0x8004208041,%rax
  80042008bd:	00 00 00 
  80042008c0:	ff d0                	callq  *%rax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  80042008c2:	c7 45 fc 80 07 00 00 	movl   $0x780,-0x4(%rbp)
  80042008c9:	eb 22                	jmp    80042008ed <cga_putc+0x22c>
			crt_buf[i] = 0x0700 | ' ';
  80042008cb:	48 b8 a8 26 22 04 80 	movabs $0x80042226a8,%rax
  80042008d2:	00 00 00 
  80042008d5:	48 8b 00             	mov    (%rax),%rax
  80042008d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042008db:	48 63 d2             	movslq %edx,%rdx
  80042008de:	48 01 d2             	add    %rdx,%rdx
  80042008e1:	48 01 d0             	add    %rdx,%rax
  80042008e4:	66 c7 00 20 07       	movw   $0x720,(%rax)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  80042008e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80042008ed:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  80042008f4:	7e d5                	jle    80042008cb <cga_putc+0x20a>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
  80042008f6:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  80042008fd:	00 00 00 
  8004200900:	0f b7 00             	movzwl (%rax),%eax
  8004200903:	8d 50 b0             	lea    -0x50(%rax),%edx
  8004200906:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  800420090d:	00 00 00 
  8004200910:	66 89 10             	mov    %dx,(%rax)
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
  8004200913:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  800420091a:	00 00 00 
  800420091d:	8b 00                	mov    (%rax),%eax
  800420091f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8004200922:	c6 45 f7 0e          	movb   $0xe,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004200926:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800420092a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800420092d:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
  800420092e:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200935:	00 00 00 
  8004200938:	0f b7 00             	movzwl (%rax),%eax
  800420093b:	66 c1 e8 08          	shr    $0x8,%ax
  800420093f:	0f b6 c0             	movzbl %al,%eax
  8004200942:	48 ba a4 26 22 04 80 	movabs $0x80042226a4,%rdx
  8004200949:	00 00 00 
  800420094c:	8b 12                	mov    (%rdx),%edx
  800420094e:	83 c2 01             	add    $0x1,%edx
  8004200951:	89 55 f0             	mov    %edx,-0x10(%rbp)
  8004200954:	88 45 ef             	mov    %al,-0x11(%rbp)
  8004200957:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800420095b:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800420095e:	ee                   	out    %al,(%dx)
	outb(addr_6845, 15);
  800420095f:	48 b8 a4 26 22 04 80 	movabs $0x80042226a4,%rax
  8004200966:	00 00 00 
  8004200969:	8b 00                	mov    (%rax),%eax
  800420096b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800420096e:	c6 45 e7 0f          	movb   $0xf,-0x19(%rbp)
  8004200972:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004200976:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8004200979:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos);
  800420097a:	48 b8 b0 26 22 04 80 	movabs $0x80042226b0,%rax
  8004200981:	00 00 00 
  8004200984:	0f b7 00             	movzwl (%rax),%eax
  8004200987:	0f b6 c0             	movzbl %al,%eax
  800420098a:	48 ba a4 26 22 04 80 	movabs $0x80042226a4,%rdx
  8004200991:	00 00 00 
  8004200994:	8b 12                	mov    (%rdx),%edx
  8004200996:	83 c2 01             	add    $0x1,%edx
  8004200999:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800420099c:	88 45 df             	mov    %al,-0x21(%rbp)
  800420099f:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80042009a3:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80042009a6:	ee                   	out    %al,(%dx)
}
  80042009a7:	c9                   	leaveq 
  80042009a8:	c3                   	retq   

00000080042009a9 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  80042009a9:	55                   	push   %rbp
  80042009aa:	48 89 e5             	mov    %rsp,%rbp
  80042009ad:	48 83 ec 20          	sub    $0x20,%rsp
  80042009b1:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042009b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80042009bb:	89 c2                	mov    %eax,%edx
  80042009bd:	ec                   	in     (%dx),%al
  80042009be:	88 45 f3             	mov    %al,-0xd(%rbp)
	return data;
  80042009c1:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
	int c;
	uint8_t data;
	static uint32_t shift;
	int r;
	if ((inb(KBSTATP) & KBS_DIB) == 0)
  80042009c5:	0f b6 c0             	movzbl %al,%eax
  80042009c8:	83 e0 01             	and    $0x1,%eax
  80042009cb:	85 c0                	test   %eax,%eax
  80042009cd:	75 0a                	jne    80042009d9 <kbd_proc_data+0x30>
		return -1;
  80042009cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80042009d4:	e9 fc 01 00 00       	jmpq   8004200bd5 <kbd_proc_data+0x22c>
  80042009d9:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80042009e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042009e3:	89 c2                	mov    %eax,%edx
  80042009e5:	ec                   	in     (%dx),%al
  80042009e6:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  80042009e9:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax

	data = inb(KBDATAP);
  80042009ed:	88 45 fb             	mov    %al,-0x5(%rbp)

	if (data == 0xE0) {
  80042009f0:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
  80042009f4:	75 27                	jne    8004200a1d <kbd_proc_data+0x74>
		// E0 escape character
		shift |= E0ESC;
  80042009f6:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  80042009fd:	00 00 00 
  8004200a00:	8b 00                	mov    (%rax),%eax
  8004200a02:	83 c8 40             	or     $0x40,%eax
  8004200a05:	89 c2                	mov    %eax,%edx
  8004200a07:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200a0e:	00 00 00 
  8004200a11:	89 10                	mov    %edx,(%rax)
		return 0;
  8004200a13:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200a18:	e9 b8 01 00 00       	jmpq   8004200bd5 <kbd_proc_data+0x22c>
	} else if (data & 0x80) {
  8004200a1d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200a21:	84 c0                	test   %al,%al
  8004200a23:	79 65                	jns    8004200a8a <kbd_proc_data+0xe1>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
  8004200a25:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200a2c:	00 00 00 
  8004200a2f:	8b 00                	mov    (%rax),%eax
  8004200a31:	83 e0 40             	and    $0x40,%eax
  8004200a34:	85 c0                	test   %eax,%eax
  8004200a36:	75 09                	jne    8004200a41 <kbd_proc_data+0x98>
  8004200a38:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200a3c:	83 e0 7f             	and    $0x7f,%eax
  8004200a3f:	eb 04                	jmp    8004200a45 <kbd_proc_data+0x9c>
  8004200a41:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200a45:	88 45 fb             	mov    %al,-0x5(%rbp)
		shift &= ~(shiftcode[data] | E0ESC);
  8004200a48:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200a4c:	48 ba 60 20 22 04 80 	movabs $0x8004222060,%rdx
  8004200a53:	00 00 00 
  8004200a56:	48 98                	cltq   
  8004200a58:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200a5c:	83 c8 40             	or     $0x40,%eax
  8004200a5f:	0f b6 c0             	movzbl %al,%eax
  8004200a62:	f7 d0                	not    %eax
  8004200a64:	89 c2                	mov    %eax,%edx
  8004200a66:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200a6d:	00 00 00 
  8004200a70:	8b 00                	mov    (%rax),%eax
  8004200a72:	21 c2                	and    %eax,%edx
  8004200a74:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200a7b:	00 00 00 
  8004200a7e:	89 10                	mov    %edx,(%rax)
		return 0;
  8004200a80:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200a85:	e9 4b 01 00 00       	jmpq   8004200bd5 <kbd_proc_data+0x22c>
	} else if (shift & E0ESC) {
  8004200a8a:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200a91:	00 00 00 
  8004200a94:	8b 00                	mov    (%rax),%eax
  8004200a96:	83 e0 40             	and    $0x40,%eax
  8004200a99:	85 c0                	test   %eax,%eax
  8004200a9b:	74 21                	je     8004200abe <kbd_proc_data+0x115>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
  8004200a9d:	80 4d fb 80          	orb    $0x80,-0x5(%rbp)
		shift &= ~E0ESC;
  8004200aa1:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200aa8:	00 00 00 
  8004200aab:	8b 00                	mov    (%rax),%eax
  8004200aad:	83 e0 bf             	and    $0xffffffbf,%eax
  8004200ab0:	89 c2                	mov    %eax,%edx
  8004200ab2:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200ab9:	00 00 00 
  8004200abc:	89 10                	mov    %edx,(%rax)
	}

	shift |= shiftcode[data];
  8004200abe:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200ac2:	48 ba 60 20 22 04 80 	movabs $0x8004222060,%rdx
  8004200ac9:	00 00 00 
  8004200acc:	48 98                	cltq   
  8004200ace:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200ad2:	0f b6 d0             	movzbl %al,%edx
  8004200ad5:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200adc:	00 00 00 
  8004200adf:	8b 00                	mov    (%rax),%eax
  8004200ae1:	09 c2                	or     %eax,%edx
  8004200ae3:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200aea:	00 00 00 
  8004200aed:	89 10                	mov    %edx,(%rax)
	shift ^= togglecode[data];
  8004200aef:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200af3:	48 ba 60 21 22 04 80 	movabs $0x8004222160,%rdx
  8004200afa:	00 00 00 
  8004200afd:	48 98                	cltq   
  8004200aff:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200b03:	0f b6 d0             	movzbl %al,%edx
  8004200b06:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200b0d:	00 00 00 
  8004200b10:	8b 00                	mov    (%rax),%eax
  8004200b12:	31 c2                	xor    %eax,%edx
  8004200b14:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200b1b:	00 00 00 
  8004200b1e:	89 10                	mov    %edx,(%rax)

	c = charcode[shift & (CTL | SHIFT)][data];
  8004200b20:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200b27:	00 00 00 
  8004200b2a:	8b 00                	mov    (%rax),%eax
  8004200b2c:	83 e0 03             	and    $0x3,%eax
  8004200b2f:	89 c2                	mov    %eax,%edx
  8004200b31:	48 b8 60 25 22 04 80 	movabs $0x8004222560,%rax
  8004200b38:	00 00 00 
  8004200b3b:	89 d2                	mov    %edx,%edx
  8004200b3d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004200b41:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8004200b45:	48 01 d0             	add    %rdx,%rax
  8004200b48:	0f b6 00             	movzbl (%rax),%eax
  8004200b4b:	0f b6 c0             	movzbl %al,%eax
  8004200b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (shift & CAPSLOCK) {
  8004200b51:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200b58:	00 00 00 
  8004200b5b:	8b 00                	mov    (%rax),%eax
  8004200b5d:	83 e0 08             	and    $0x8,%eax
  8004200b60:	85 c0                	test   %eax,%eax
  8004200b62:	74 22                	je     8004200b86 <kbd_proc_data+0x1dd>
		if ('a' <= c && c <= 'z')
  8004200b64:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
  8004200b68:	7e 0c                	jle    8004200b76 <kbd_proc_data+0x1cd>
  8004200b6a:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
  8004200b6e:	7f 06                	jg     8004200b76 <kbd_proc_data+0x1cd>
			c += 'A' - 'a';
  8004200b70:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
  8004200b74:	eb 10                	jmp    8004200b86 <kbd_proc_data+0x1dd>
		else if ('A' <= c && c <= 'Z')
  8004200b76:	83 7d fc 40          	cmpl   $0x40,-0x4(%rbp)
  8004200b7a:	7e 0a                	jle    8004200b86 <kbd_proc_data+0x1dd>
  8004200b7c:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%rbp)
  8004200b80:	7f 04                	jg     8004200b86 <kbd_proc_data+0x1dd>
			c += 'a' - 'A';
  8004200b82:	83 45 fc 20          	addl   $0x20,-0x4(%rbp)
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  8004200b86:	48 b8 c8 28 22 04 80 	movabs $0x80042228c8,%rax
  8004200b8d:	00 00 00 
  8004200b90:	8b 00                	mov    (%rax),%eax
  8004200b92:	f7 d0                	not    %eax
  8004200b94:	83 e0 06             	and    $0x6,%eax
  8004200b97:	85 c0                	test   %eax,%eax
  8004200b99:	75 37                	jne    8004200bd2 <kbd_proc_data+0x229>
  8004200b9b:	81 7d fc e9 00 00 00 	cmpl   $0xe9,-0x4(%rbp)
  8004200ba2:	75 2e                	jne    8004200bd2 <kbd_proc_data+0x229>
		cprintf("Rebooting!\n");
  8004200ba4:	48 bf ef e3 20 04 80 	movabs $0x800420e3ef,%rdi
  8004200bab:	00 00 00 
  8004200bae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200bb3:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200bba:	00 00 00 
  8004200bbd:	ff d2                	callq  *%rdx
  8004200bbf:	c7 45 e4 92 00 00 00 	movl   $0x92,-0x1c(%rbp)
  8004200bc6:	c6 45 e3 03          	movb   $0x3,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004200bca:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8004200bce:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004200bd1:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}
	return c;
  8004200bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004200bd5:	c9                   	leaveq 
  8004200bd6:	c3                   	retq   

0000008004200bd7 <kbd_intr>:

void
kbd_intr(void)
{
  8004200bd7:	55                   	push   %rbp
  8004200bd8:	48 89 e5             	mov    %rsp,%rbp
	cons_intr(kbd_proc_data);
  8004200bdb:	48 bf a9 09 20 04 80 	movabs $0x80042009a9,%rdi
  8004200be2:	00 00 00 
  8004200be5:	48 b8 f9 0b 20 04 80 	movabs $0x8004200bf9,%rax
  8004200bec:	00 00 00 
  8004200bef:	ff d0                	callq  *%rax
}
  8004200bf1:	5d                   	pop    %rbp
  8004200bf2:	c3                   	retq   

0000008004200bf3 <kbd_init>:

static void
kbd_init(void)
{
  8004200bf3:	55                   	push   %rbp
  8004200bf4:	48 89 e5             	mov    %rsp,%rbp
}
  8004200bf7:	5d                   	pop    %rbp
  8004200bf8:	c3                   	retq   

0000008004200bf9 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
  8004200bf9:	55                   	push   %rbp
  8004200bfa:	48 89 e5             	mov    %rsp,%rbp
  8004200bfd:	48 83 ec 20          	sub    $0x20,%rsp
  8004200c01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int c;

	while ((c = (*proc)()) != -1) {
  8004200c05:	eb 6a                	jmp    8004200c71 <cons_intr+0x78>
		if (c == 0)
  8004200c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004200c0b:	75 02                	jne    8004200c0f <cons_intr+0x16>
			continue;
  8004200c0d:	eb 62                	jmp    8004200c71 <cons_intr+0x78>
		cons.buf[cons.wpos++] = c;
  8004200c0f:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200c16:	00 00 00 
  8004200c19:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200c1f:	8d 48 01             	lea    0x1(%rax),%ecx
  8004200c22:	48 ba c0 26 22 04 80 	movabs $0x80042226c0,%rdx
  8004200c29:	00 00 00 
  8004200c2c:	89 8a 04 02 00 00    	mov    %ecx,0x204(%rdx)
  8004200c32:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004200c35:	89 d1                	mov    %edx,%ecx
  8004200c37:	48 ba c0 26 22 04 80 	movabs $0x80042226c0,%rdx
  8004200c3e:	00 00 00 
  8004200c41:	89 c0                	mov    %eax,%eax
  8004200c43:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
		if (cons.wpos == CONSBUFSIZE)
  8004200c46:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200c4d:	00 00 00 
  8004200c50:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200c56:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004200c5b:	75 14                	jne    8004200c71 <cons_intr+0x78>
			cons.wpos = 0;
  8004200c5d:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200c64:	00 00 00 
  8004200c67:	c7 80 04 02 00 00 00 	movl   $0x0,0x204(%rax)
  8004200c6e:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  8004200c71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004200c75:	ff d0                	callq  *%rax
  8004200c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004200c7a:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  8004200c7e:	75 87                	jne    8004200c07 <cons_intr+0xe>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
  8004200c80:	c9                   	leaveq 
  8004200c81:	c3                   	retq   

0000008004200c82 <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
  8004200c82:	55                   	push   %rbp
  8004200c83:	48 89 e5             	mov    %rsp,%rbp
  8004200c86:	48 83 ec 10          	sub    $0x10,%rsp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
  8004200c8a:	48 b8 bc 03 20 04 80 	movabs $0x80042003bc,%rax
  8004200c91:	00 00 00 
  8004200c94:	ff d0                	callq  *%rax
	kbd_intr();
  8004200c96:	48 b8 d7 0b 20 04 80 	movabs $0x8004200bd7,%rax
  8004200c9d:	00 00 00 
  8004200ca0:	ff d0                	callq  *%rax

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  8004200ca2:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200ca9:	00 00 00 
  8004200cac:	8b 90 00 02 00 00    	mov    0x200(%rax),%edx
  8004200cb2:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200cb9:	00 00 00 
  8004200cbc:	8b 80 04 02 00 00    	mov    0x204(%rax),%eax
  8004200cc2:	39 c2                	cmp    %eax,%edx
  8004200cc4:	74 69                	je     8004200d2f <cons_getc+0xad>
		c = cons.buf[cons.rpos++];
  8004200cc6:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200ccd:	00 00 00 
  8004200cd0:	8b 80 00 02 00 00    	mov    0x200(%rax),%eax
  8004200cd6:	8d 48 01             	lea    0x1(%rax),%ecx
  8004200cd9:	48 ba c0 26 22 04 80 	movabs $0x80042226c0,%rdx
  8004200ce0:	00 00 00 
  8004200ce3:	89 8a 00 02 00 00    	mov    %ecx,0x200(%rdx)
  8004200ce9:	48 ba c0 26 22 04 80 	movabs $0x80042226c0,%rdx
  8004200cf0:	00 00 00 
  8004200cf3:	89 c0                	mov    %eax,%eax
  8004200cf5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004200cf9:	0f b6 c0             	movzbl %al,%eax
  8004200cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (cons.rpos == CONSBUFSIZE)
  8004200cff:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200d06:	00 00 00 
  8004200d09:	8b 80 00 02 00 00    	mov    0x200(%rax),%eax
  8004200d0f:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004200d14:	75 14                	jne    8004200d2a <cons_getc+0xa8>
			cons.rpos = 0;
  8004200d16:	48 b8 c0 26 22 04 80 	movabs $0x80042226c0,%rax
  8004200d1d:	00 00 00 
  8004200d20:	c7 80 00 02 00 00 00 	movl   $0x0,0x200(%rax)
  8004200d27:	00 00 00 
		return c;
  8004200d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200d2d:	eb 05                	jmp    8004200d34 <cons_getc+0xb2>
	}
	return 0;
  8004200d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004200d34:	c9                   	leaveq 
  8004200d35:	c3                   	retq   

0000008004200d36 <cons_putc>:

// output a character to the console
static void
cons_putc(int c)
{
  8004200d36:	55                   	push   %rbp
  8004200d37:	48 89 e5             	mov    %rsp,%rbp
  8004200d3a:	48 83 ec 10          	sub    $0x10,%rsp
  8004200d3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	serial_putc(c);
  8004200d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200d44:	89 c7                	mov    %eax,%edi
  8004200d46:	48 b8 e9 03 20 04 80 	movabs $0x80042003e9,%rax
  8004200d4d:	00 00 00 
  8004200d50:	ff d0                	callq  *%rax
	lpt_putc(c);
  8004200d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200d55:	89 c7                	mov    %eax,%edi
  8004200d57:	48 b8 22 05 20 04 80 	movabs $0x8004200522,%rax
  8004200d5e:	00 00 00 
  8004200d61:	ff d0                	callq  *%rax
	cga_putc(c);
  8004200d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200d66:	89 c7                	mov    %eax,%edi
  8004200d68:	48 b8 c1 06 20 04 80 	movabs $0x80042006c1,%rax
  8004200d6f:	00 00 00 
  8004200d72:	ff d0                	callq  *%rax
}
  8004200d74:	c9                   	leaveq 
  8004200d75:	c3                   	retq   

0000008004200d76 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
  8004200d76:	55                   	push   %rbp
  8004200d77:	48 89 e5             	mov    %rsp,%rbp
	cga_init();
  8004200d7a:	48 b8 a7 05 20 04 80 	movabs $0x80042005a7,%rax
  8004200d81:	00 00 00 
  8004200d84:	ff d0                	callq  *%rax
	kbd_init();
  8004200d86:	48 b8 f3 0b 20 04 80 	movabs $0x8004200bf3,%rax
  8004200d8d:	00 00 00 
  8004200d90:	ff d0                	callq  *%rax
	serial_init();
  8004200d92:	48 b8 4e 04 20 04 80 	movabs $0x800420044e,%rax
  8004200d99:	00 00 00 
  8004200d9c:	ff d0                	callq  *%rax

	if (!serial_exists)
  8004200d9e:	48 b8 a0 26 22 04 80 	movabs $0x80042226a0,%rax
  8004200da5:	00 00 00 
  8004200da8:	0f b6 00             	movzbl (%rax),%eax
  8004200dab:	83 f0 01             	xor    $0x1,%eax
  8004200dae:	84 c0                	test   %al,%al
  8004200db0:	74 1b                	je     8004200dcd <cons_init+0x57>
		cprintf("Serial port does not exist!\n");
  8004200db2:	48 bf fb e3 20 04 80 	movabs $0x800420e3fb,%rdi
  8004200db9:	00 00 00 
  8004200dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200dc1:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200dc8:	00 00 00 
  8004200dcb:	ff d2                	callq  *%rdx
}
  8004200dcd:	5d                   	pop    %rbp
  8004200dce:	c3                   	retq   

0000008004200dcf <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
  8004200dcf:	55                   	push   %rbp
  8004200dd0:	48 89 e5             	mov    %rsp,%rbp
  8004200dd3:	48 83 ec 10          	sub    $0x10,%rsp
  8004200dd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	cons_putc(c);
  8004200dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200ddd:	89 c7                	mov    %eax,%edi
  8004200ddf:	48 b8 36 0d 20 04 80 	movabs $0x8004200d36,%rax
  8004200de6:	00 00 00 
  8004200de9:	ff d0                	callq  *%rax
}
  8004200deb:	c9                   	leaveq 
  8004200dec:	c3                   	retq   

0000008004200ded <getchar>:

int
getchar(void)
{
  8004200ded:	55                   	push   %rbp
  8004200dee:	48 89 e5             	mov    %rsp,%rbp
  8004200df1:	48 83 ec 10          	sub    $0x10,%rsp
	int c;

	while ((c = cons_getc()) == 0)
  8004200df5:	48 b8 82 0c 20 04 80 	movabs $0x8004200c82,%rax
  8004200dfc:	00 00 00 
  8004200dff:	ff d0                	callq  *%rax
  8004200e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004200e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004200e08:	74 eb                	je     8004200df5 <getchar+0x8>
		/* do nothing */;
	return c;
  8004200e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004200e0d:	c9                   	leaveq 
  8004200e0e:	c3                   	retq   

0000008004200e0f <iscons>:

int
iscons(int fdnum)
{
  8004200e0f:	55                   	push   %rbp
  8004200e10:	48 89 e5             	mov    %rsp,%rbp
  8004200e13:	48 83 ec 04          	sub    $0x4,%rsp
  8004200e17:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// used by readline
	return 1;
  8004200e1a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004200e1f:	c9                   	leaveq 
  8004200e20:	c3                   	retq   

0000008004200e21 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
  8004200e21:	55                   	push   %rbp
  8004200e22:	48 89 e5             	mov    %rsp,%rbp
  8004200e25:	48 83 ec 30          	sub    $0x30,%rsp
  8004200e29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8004200e2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004200e30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  8004200e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004200e3b:	eb 6c                	jmp    8004200ea9 <mon_help+0x88>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  8004200e3d:	48 b9 80 25 22 04 80 	movabs $0x8004222580,%rcx
  8004200e44:	00 00 00 
  8004200e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200e4a:	48 63 d0             	movslq %eax,%rdx
  8004200e4d:	48 89 d0             	mov    %rdx,%rax
  8004200e50:	48 01 c0             	add    %rax,%rax
  8004200e53:	48 01 d0             	add    %rdx,%rax
  8004200e56:	48 c1 e0 03          	shl    $0x3,%rax
  8004200e5a:	48 01 c8             	add    %rcx,%rax
  8004200e5d:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8004200e61:	48 be 80 25 22 04 80 	movabs $0x8004222580,%rsi
  8004200e68:	00 00 00 
  8004200e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200e6e:	48 63 d0             	movslq %eax,%rdx
  8004200e71:	48 89 d0             	mov    %rdx,%rax
  8004200e74:	48 01 c0             	add    %rax,%rax
  8004200e77:	48 01 d0             	add    %rdx,%rax
  8004200e7a:	48 c1 e0 03          	shl    $0x3,%rax
  8004200e7e:	48 01 f0             	add    %rsi,%rax
  8004200e81:	48 8b 00             	mov    (%rax),%rax
  8004200e84:	48 89 ca             	mov    %rcx,%rdx
  8004200e87:	48 89 c6             	mov    %rax,%rsi
  8004200e8a:	48 bf 6d e4 20 04 80 	movabs $0x800420e46d,%rdi
  8004200e91:	00 00 00 
  8004200e94:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200e99:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  8004200ea0:	00 00 00 
  8004200ea3:	ff d1                	callq  *%rcx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  8004200ea5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8004200ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004200eac:	83 f8 01             	cmp    $0x1,%eax
  8004200eaf:	76 8c                	jbe    8004200e3d <mon_help+0x1c>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
  8004200eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004200eb6:	c9                   	leaveq 
  8004200eb7:	c3                   	retq   

0000008004200eb8 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  8004200eb8:	55                   	push   %rbp
  8004200eb9:	48 89 e5             	mov    %rsp,%rbp
  8004200ebc:	48 83 ec 30          	sub    $0x30,%rsp
  8004200ec0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8004200ec3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004200ec7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
  8004200ecb:	48 bf 76 e4 20 04 80 	movabs $0x800420e476,%rdi
  8004200ed2:	00 00 00 
  8004200ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200eda:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200ee1:	00 00 00 
  8004200ee4:	ff d2                	callq  *%rdx
	cprintf("  _start                  %08x (phys)\n", _start);
  8004200ee6:	48 be 0c 00 20 00 00 	movabs $0x20000c,%rsi
  8004200eed:	00 00 00 
  8004200ef0:	48 bf 90 e4 20 04 80 	movabs $0x800420e490,%rdi
  8004200ef7:	00 00 00 
  8004200efa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200eff:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004200f06:	00 00 00 
  8004200f09:	ff d2                	callq  *%rdx
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
  8004200f0b:	48 ba 0c 00 20 00 00 	movabs $0x20000c,%rdx
  8004200f12:	00 00 00 
  8004200f15:	48 be 0c 00 20 04 80 	movabs $0x800420000c,%rsi
  8004200f1c:	00 00 00 
  8004200f1f:	48 bf b8 e4 20 04 80 	movabs $0x800420e4b8,%rdi
  8004200f26:	00 00 00 
  8004200f29:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f2e:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  8004200f35:	00 00 00 
  8004200f38:	ff d1                	callq  *%rcx
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
  8004200f3a:	48 ba 9f e3 20 00 00 	movabs $0x20e39f,%rdx
  8004200f41:	00 00 00 
  8004200f44:	48 be 9f e3 20 04 80 	movabs $0x800420e39f,%rsi
  8004200f4b:	00 00 00 
  8004200f4e:	48 bf e0 e4 20 04 80 	movabs $0x800420e4e0,%rdi
  8004200f55:	00 00 00 
  8004200f58:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f5d:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  8004200f64:	00 00 00 
  8004200f67:	ff d1                	callq  *%rcx
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
  8004200f69:	48 ba a0 26 22 00 00 	movabs $0x2226a0,%rdx
  8004200f70:	00 00 00 
  8004200f73:	48 be a0 26 22 04 80 	movabs $0x80042226a0,%rsi
  8004200f7a:	00 00 00 
  8004200f7d:	48 bf 08 e5 20 04 80 	movabs $0x800420e508,%rdi
  8004200f84:	00 00 00 
  8004200f87:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200f8c:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  8004200f93:	00 00 00 
  8004200f96:	ff d1                	callq  *%rcx
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
  8004200f98:	48 ba 80 3d 22 00 00 	movabs $0x223d80,%rdx
  8004200f9f:	00 00 00 
  8004200fa2:	48 be 80 3d 22 04 80 	movabs $0x8004223d80,%rsi
  8004200fa9:	00 00 00 
  8004200fac:	48 bf 30 e5 20 04 80 	movabs $0x800420e530,%rdi
  8004200fb3:	00 00 00 
  8004200fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004200fbb:	48 b9 66 64 20 04 80 	movabs $0x8004206466,%rcx
  8004200fc2:	00 00 00 
  8004200fc5:	ff d1                	callq  *%rcx
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
  8004200fc7:	48 c7 45 f8 00 04 00 	movq   $0x400,-0x8(%rbp)
  8004200fce:	00 
  8004200fcf:	48 b8 0c 00 20 04 80 	movabs $0x800420000c,%rax
  8004200fd6:	00 00 00 
  8004200fd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004200fdd:	48 29 c2             	sub    %rax,%rdx
  8004200fe0:	48 b8 80 3d 22 04 80 	movabs $0x8004223d80,%rax
  8004200fe7:	00 00 00 
  8004200fea:	48 83 e8 01          	sub    $0x1,%rax
  8004200fee:	48 01 d0             	add    %rdx,%rax
  8004200ff1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004200ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004200ff9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004200ffe:	48 f7 75 f8          	divq   -0x8(%rbp)
  8004201002:	48 89 d0             	mov    %rdx,%rax
  8004201005:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201009:	48 29 c2             	sub    %rax,%rdx
  800420100c:	48 89 d0             	mov    %rdx,%rax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
  800420100f:	48 8d 90 ff 03 00 00 	lea    0x3ff(%rax),%rdx
  8004201016:	48 85 c0             	test   %rax,%rax
  8004201019:	48 0f 48 c2          	cmovs  %rdx,%rax
  800420101d:	48 c1 f8 0a          	sar    $0xa,%rax
  8004201021:	48 89 c6             	mov    %rax,%rsi
  8004201024:	48 bf 58 e5 20 04 80 	movabs $0x800420e558,%rdi
  800420102b:	00 00 00 
  800420102e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201033:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  800420103a:	00 00 00 
  800420103d:	ff d2                	callq  *%rdx
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
  800420103f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004201044:	c9                   	leaveq 
  8004201045:	c3                   	retq   

0000008004201046 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
  8004201046:	55                   	push   %rbp
  8004201047:	48 89 e5             	mov    %rsp,%rbp
  800420104a:	48 83 ec 18          	sub    $0x18,%rsp
  800420104e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004201051:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004201055:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Your code here.
	return 0;
  8004201059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420105e:	c9                   	leaveq 
  800420105f:	c3                   	retq   

0000008004201060 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
  8004201060:	55                   	push   %rbp
  8004201061:	48 89 e5             	mov    %rsp,%rbp
  8004201064:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800420106b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8004201072:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  8004201079:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	argv[argc] = 0;
  8004201080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201083:	48 98                	cltq   
  8004201085:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  800420108c:	ff 00 00 00 00 
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  8004201091:	eb 15                	jmp    80042010a8 <runcmd+0x48>
			*buf++ = 0;
  8004201093:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420109a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420109e:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  80042010a5:	c6 00 00             	movb   $0x0,(%rax)
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  80042010a8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042010af:	0f b6 00             	movzbl (%rax),%eax
  80042010b2:	84 c0                	test   %al,%al
  80042010b4:	74 2a                	je     80042010e0 <runcmd+0x80>
  80042010b6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042010bd:	0f b6 00             	movzbl (%rax),%eax
  80042010c0:	0f be c0             	movsbl %al,%eax
  80042010c3:	89 c6                	mov    %eax,%esi
  80042010c5:	48 bf 82 e5 20 04 80 	movabs $0x800420e582,%rdi
  80042010cc:	00 00 00 
  80042010cf:	48 b8 43 7f 20 04 80 	movabs $0x8004207f43,%rax
  80042010d6:	00 00 00 
  80042010d9:	ff d0                	callq  *%rax
  80042010db:	48 85 c0             	test   %rax,%rax
  80042010de:	75 b3                	jne    8004201093 <runcmd+0x33>
			*buf++ = 0;
		if (*buf == 0)
  80042010e0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042010e7:	0f b6 00             	movzbl (%rax),%eax
  80042010ea:	84 c0                	test   %al,%al
  80042010ec:	75 21                	jne    800420110f <runcmd+0xaf>
			break;
  80042010ee:	90                   	nop
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  80042010ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042010f2:	48 98                	cltq   
  80042010f4:	48 c7 84 c5 70 ff ff 	movq   $0x0,-0x90(%rbp,%rax,8)
  80042010fb:	ff 00 00 00 00 

	// Lookup and invoke the command
	if (argc == 0)
  8004201100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004201104:	0f 85 a1 00 00 00    	jne    80042011ab <runcmd+0x14b>
  800420110a:	e9 92 00 00 00       	jmpq   80042011a1 <runcmd+0x141>
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  800420110f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
  8004201113:	75 2a                	jne    800420113f <runcmd+0xdf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  8004201115:	be 10 00 00 00       	mov    $0x10,%esi
  800420111a:	48 bf 87 e5 20 04 80 	movabs $0x800420e587,%rdi
  8004201121:	00 00 00 
  8004201124:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201129:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004201130:	00 00 00 
  8004201133:	ff d2                	callq  *%rdx
			return 0;
  8004201135:	b8 00 00 00 00       	mov    $0x0,%eax
  800420113a:	e9 30 01 00 00       	jmpq   800420126f <runcmd+0x20f>
		}
		argv[argc++] = buf;
  800420113f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004201142:	8d 50 01             	lea    0x1(%rax),%edx
  8004201145:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8004201148:	48 98                	cltq   
  800420114a:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
  8004201151:	48 89 94 c5 70 ff ff 	mov    %rdx,-0x90(%rbp,%rax,8)
  8004201158:	ff 
		while (*buf && !strchr(WHITESPACE, *buf))
  8004201159:	eb 08                	jmp    8004201163 <runcmd+0x103>
			buf++;
  800420115b:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  8004201162:	01 
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  8004201163:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420116a:	0f b6 00             	movzbl (%rax),%eax
  800420116d:	84 c0                	test   %al,%al
  800420116f:	74 2a                	je     800420119b <runcmd+0x13b>
  8004201171:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004201178:	0f b6 00             	movzbl (%rax),%eax
  800420117b:	0f be c0             	movsbl %al,%eax
  800420117e:	89 c6                	mov    %eax,%esi
  8004201180:	48 bf 82 e5 20 04 80 	movabs $0x800420e582,%rdi
  8004201187:	00 00 00 
  800420118a:	48 b8 43 7f 20 04 80 	movabs $0x8004207f43,%rax
  8004201191:	00 00 00 
  8004201194:	ff d0                	callq  *%rax
  8004201196:	48 85 c0             	test   %rax,%rax
  8004201199:	74 c0                	je     800420115b <runcmd+0xfb>
			buf++;
	}
  800420119b:	90                   	nop
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  800420119c:	e9 07 ff ff ff       	jmpq   80042010a8 <runcmd+0x48>
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
  80042011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  80042011a6:	e9 c4 00 00 00       	jmpq   800420126f <runcmd+0x20f>
	for (i = 0; i < NCOMMANDS; i++) {
  80042011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80042011b2:	e9 82 00 00 00       	jmpq   8004201239 <runcmd+0x1d9>
		if (strcmp(argv[0], commands[i].name) == 0)
  80042011b7:	48 b9 80 25 22 04 80 	movabs $0x8004222580,%rcx
  80042011be:	00 00 00 
  80042011c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80042011c4:	48 63 d0             	movslq %eax,%rdx
  80042011c7:	48 89 d0             	mov    %rdx,%rax
  80042011ca:	48 01 c0             	add    %rax,%rax
  80042011cd:	48 01 d0             	add    %rdx,%rax
  80042011d0:	48 c1 e0 03          	shl    $0x3,%rax
  80042011d4:	48 01 c8             	add    %rcx,%rax
  80042011d7:	48 8b 10             	mov    (%rax),%rdx
  80042011da:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  80042011e1:	48 89 d6             	mov    %rdx,%rsi
  80042011e4:	48 89 c7             	mov    %rax,%rdi
  80042011e7:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  80042011ee:	00 00 00 
  80042011f1:	ff d0                	callq  *%rax
  80042011f3:	85 c0                	test   %eax,%eax
  80042011f5:	75 3e                	jne    8004201235 <runcmd+0x1d5>
			return commands[i].func(argc, argv, tf);
  80042011f7:	48 b9 80 25 22 04 80 	movabs $0x8004222580,%rcx
  80042011fe:	00 00 00 
  8004201201:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004201204:	48 63 d0             	movslq %eax,%rdx
  8004201207:	48 89 d0             	mov    %rdx,%rax
  800420120a:	48 01 c0             	add    %rax,%rax
  800420120d:	48 01 d0             	add    %rdx,%rax
  8004201210:	48 c1 e0 03          	shl    $0x3,%rax
  8004201214:	48 01 c8             	add    %rcx,%rax
  8004201217:	48 83 c0 10          	add    $0x10,%rax
  800420121b:	48 8b 00             	mov    (%rax),%rax
  800420121e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004201225:	48 8d b5 70 ff ff ff 	lea    -0x90(%rbp),%rsi
  800420122c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420122f:	89 cf                	mov    %ecx,%edi
  8004201231:	ff d0                	callq  *%rax
  8004201233:	eb 3a                	jmp    800420126f <runcmd+0x20f>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  8004201235:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8004201239:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800420123c:	83 f8 01             	cmp    $0x1,%eax
  800420123f:	0f 86 72 ff ff ff    	jbe    80042011b7 <runcmd+0x157>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  8004201245:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420124c:	48 89 c6             	mov    %rax,%rsi
  800420124f:	48 bf a4 e5 20 04 80 	movabs $0x800420e5a4,%rdi
  8004201256:	00 00 00 
  8004201259:	b8 00 00 00 00       	mov    $0x0,%eax
  800420125e:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004201265:	00 00 00 
  8004201268:	ff d2                	callq  *%rdx
	return 0;
  800420126a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420126f:	c9                   	leaveq 
  8004201270:	c3                   	retq   

0000008004201271 <monitor>:

void
monitor(struct Trapframe *tf)
{
  8004201271:	55                   	push   %rbp
  8004201272:	48 89 e5             	mov    %rsp,%rbp
  8004201275:	48 83 ec 20          	sub    $0x20,%rsp
  8004201279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
  800420127d:	48 bf c0 e5 20 04 80 	movabs $0x800420e5c0,%rdi
  8004201284:	00 00 00 
  8004201287:	b8 00 00 00 00       	mov    $0x0,%eax
  800420128c:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004201293:	00 00 00 
  8004201296:	ff d2                	callq  *%rdx
	cprintf("Type 'help' for a list of commands.\n");
  8004201298:	48 bf e8 e5 20 04 80 	movabs $0x800420e5e8,%rdi
  800420129f:	00 00 00 
  80042012a2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042012a7:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  80042012ae:	00 00 00 
  80042012b1:	ff d2                	callq  *%rdx


	while (1) {
		buf = readline("K> ");
  80042012b3:	48 bf 0d e6 20 04 80 	movabs $0x800420e60d,%rdi
  80042012ba:	00 00 00 
  80042012bd:	48 b8 62 7b 20 04 80 	movabs $0x8004207b62,%rax
  80042012c4:	00 00 00 
  80042012c7:	ff d0                	callq  *%rax
  80042012c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (buf != NULL)
  80042012cd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042012d2:	74 20                	je     80042012f4 <monitor+0x83>
			if (runcmd(buf, tf) < 0)
  80042012d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042012dc:	48 89 d6             	mov    %rdx,%rsi
  80042012df:	48 89 c7             	mov    %rax,%rdi
  80042012e2:	48 b8 60 10 20 04 80 	movabs $0x8004201060,%rax
  80042012e9:	00 00 00 
  80042012ec:	ff d0                	callq  *%rax
  80042012ee:	85 c0                	test   %eax,%eax
  80042012f0:	79 02                	jns    80042012f4 <monitor+0x83>
				break;
  80042012f2:	eb 02                	jmp    80042012f6 <monitor+0x85>
	}
  80042012f4:	eb bd                	jmp    80042012b3 <monitor+0x42>
}
  80042012f6:	c9                   	leaveq 
  80042012f7:	c3                   	retq   

00000080042012f8 <page2ppn>:

void	tlb_invalidate(pml4e_t *pml4e, void *va);

static inline ppn_t
page2ppn(struct PageInfo *pp)
{
  80042012f8:	55                   	push   %rbp
  80042012f9:	48 89 e5             	mov    %rsp,%rbp
  80042012fc:	48 83 ec 08          	sub    $0x8,%rsp
  8004201300:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return pp - pages;
  8004201304:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004201308:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  800420130f:	00 00 00 
  8004201312:	48 8b 00             	mov    (%rax),%rax
  8004201315:	48 29 c2             	sub    %rax,%rdx
  8004201318:	48 89 d0             	mov    %rdx,%rax
  800420131b:	48 c1 f8 04          	sar    $0x4,%rax
}
  800420131f:	c9                   	leaveq 
  8004201320:	c3                   	retq   

0000008004201321 <page2pa>:

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
  8004201321:	55                   	push   %rbp
  8004201322:	48 89 e5             	mov    %rsp,%rbp
  8004201325:	48 83 ec 08          	sub    $0x8,%rsp
  8004201329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return page2ppn(pp) << PGSHIFT;
  800420132d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201331:	48 89 c7             	mov    %rax,%rdi
  8004201334:	48 b8 f8 12 20 04 80 	movabs $0x80042012f8,%rax
  800420133b:	00 00 00 
  800420133e:	ff d0                	callq  *%rax
  8004201340:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8004201344:	c9                   	leaveq 
  8004201345:	c3                   	retq   

0000008004201346 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
  8004201346:	55                   	push   %rbp
  8004201347:	48 89 e5             	mov    %rsp,%rbp
  800420134a:	48 83 ec 10          	sub    $0x10,%rsp
  800420134e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (PPN(pa) >= npages)
  8004201352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201356:	48 c1 e8 0c          	shr    $0xc,%rax
  800420135a:	48 89 c2             	mov    %rax,%rdx
  800420135d:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201364:	00 00 00 
  8004201367:	48 8b 00             	mov    (%rax),%rax
  800420136a:	48 39 c2             	cmp    %rax,%rdx
  800420136d:	72 2a                	jb     8004201399 <pa2page+0x53>
		panic("pa2page called with invalid pa");
  800420136f:	48 ba 18 e6 20 04 80 	movabs $0x800420e618,%rdx
  8004201376:	00 00 00 
  8004201379:	be 4e 00 00 00       	mov    $0x4e,%esi
  800420137e:	48 bf 37 e6 20 04 80 	movabs $0x800420e637,%rdi
  8004201385:	00 00 00 
  8004201388:	b8 00 00 00 00       	mov    $0x0,%eax
  800420138d:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004201394:	00 00 00 
  8004201397:	ff d1                	callq  *%rcx
	return &pages[PPN(pa)];
  8004201399:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042013a0:	00 00 00 
  80042013a3:	48 8b 00             	mov    (%rax),%rax
  80042013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042013aa:	48 c1 ea 0c          	shr    $0xc,%rdx
  80042013ae:	48 c1 e2 04          	shl    $0x4,%rdx
  80042013b2:	48 01 d0             	add    %rdx,%rax
}
  80042013b5:	c9                   	leaveq 
  80042013b6:	c3                   	retq   

00000080042013b7 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
  80042013b7:	55                   	push   %rbp
  80042013b8:	48 89 e5             	mov    %rsp,%rbp
  80042013bb:	48 83 ec 20          	sub    $0x20,%rsp
  80042013bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	return KADDR(page2pa(pp));
  80042013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042013c7:	48 89 c7             	mov    %rax,%rdi
  80042013ca:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042013d1:	00 00 00 
  80042013d4:	ff d0                	callq  *%rax
  80042013d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042013de:	48 c1 e8 0c          	shr    $0xc,%rax
  80042013e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80042013e5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042013e8:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042013ef:	00 00 00 
  80042013f2:	48 8b 00             	mov    (%rax),%rax
  80042013f5:	48 39 c2             	cmp    %rax,%rdx
  80042013f8:	72 32                	jb     800420142c <page2kva+0x75>
  80042013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042013fe:	48 89 c1             	mov    %rax,%rcx
  8004201401:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004201408:	00 00 00 
  800420140b:	be 55 00 00 00       	mov    $0x55,%esi
  8004201410:	48 bf 37 e6 20 04 80 	movabs $0x800420e637,%rdi
  8004201417:	00 00 00 
  800420141a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420141f:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004201426:	00 00 00 
  8004201429:	41 ff d0             	callq  *%r8
  800420142c:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004201433:	00 00 00 
  8004201436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420143a:	48 01 d0             	add    %rdx,%rax
}
  800420143d:	c9                   	leaveq 
  800420143e:	c3                   	retq   

000000800420143f <restrictive_type>:
   uint32_t length_low;
   uint32_t length_high;
   uint32_t type;
 } memory_map_t;

static __inline uint32_t restrictive_type(uint32_t t1, uint32_t t2) {
  800420143f:	55                   	push   %rbp
  8004201440:	48 89 e5             	mov    %rsp,%rbp
  8004201443:	48 83 ec 08          	sub    $0x8,%rsp
  8004201447:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800420144a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  if(t1==MB_TYPE_BAD || t2==MB_TYPE_BAD)
  800420144d:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
  8004201451:	74 06                	je     8004201459 <restrictive_type+0x1a>
  8004201453:	83 7d f8 05          	cmpl   $0x5,-0x8(%rbp)
  8004201457:	75 07                	jne    8004201460 <restrictive_type+0x21>
    return MB_TYPE_BAD;
  8004201459:	b8 05 00 00 00       	mov    $0x5,%eax
  800420145e:	eb 3e                	jmp    800420149e <restrictive_type+0x5f>
  else if(t1==MB_TYPE_ACPI_NVS || t2==MB_TYPE_ACPI_NVS)
  8004201460:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8004201464:	74 06                	je     800420146c <restrictive_type+0x2d>
  8004201466:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
  800420146a:	75 07                	jne    8004201473 <restrictive_type+0x34>
    return MB_TYPE_ACPI_NVS;
  800420146c:	b8 04 00 00 00       	mov    $0x4,%eax
  8004201471:	eb 2b                	jmp    800420149e <restrictive_type+0x5f>
  else if(t1==MB_TYPE_RESERVED || t2==MB_TYPE_RESERVED)
  8004201473:	83 7d fc 02          	cmpl   $0x2,-0x4(%rbp)
  8004201477:	74 06                	je     800420147f <restrictive_type+0x40>
  8004201479:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  800420147d:	75 07                	jne    8004201486 <restrictive_type+0x47>
    return MB_TYPE_RESERVED;
  800420147f:	b8 02 00 00 00       	mov    $0x2,%eax
  8004201484:	eb 18                	jmp    800420149e <restrictive_type+0x5f>
  else if(t1==MB_TYPE_ACPI_RECLM || t2==MB_TYPE_ACPI_RECLM)
  8004201486:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
  800420148a:	74 06                	je     8004201492 <restrictive_type+0x53>
  800420148c:	83 7d f8 03          	cmpl   $0x3,-0x8(%rbp)
  8004201490:	75 07                	jne    8004201499 <restrictive_type+0x5a>
    return MB_TYPE_ACPI_RECLM;
  8004201492:	b8 03 00 00 00       	mov    $0x3,%eax
  8004201497:	eb 05                	jmp    800420149e <restrictive_type+0x5f>

  return MB_TYPE_USABLE;
  8004201499:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800420149e:	c9                   	leaveq 
  800420149f:	c3                   	retq   

00000080042014a0 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
  80042014a0:	55                   	push   %rbp
  80042014a1:	48 89 e5             	mov    %rsp,%rbp
  80042014a4:	53                   	push   %rbx
  80042014a5:	48 83 ec 18          	sub    $0x18,%rsp
  80042014a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
  80042014ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042014af:	89 c7                	mov    %eax,%edi
  80042014b1:	48 b8 5d 63 20 04 80 	movabs $0x800420635d,%rax
  80042014b8:	00 00 00 
  80042014bb:	ff d0                	callq  *%rax
  80042014bd:	89 c3                	mov    %eax,%ebx
  80042014bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042014c2:	83 c0 01             	add    $0x1,%eax
  80042014c5:	89 c7                	mov    %eax,%edi
  80042014c7:	48 b8 5d 63 20 04 80 	movabs $0x800420635d,%rax
  80042014ce:	00 00 00 
  80042014d1:	ff d0                	callq  *%rax
  80042014d3:	c1 e0 08             	shl    $0x8,%eax
  80042014d6:	09 d8                	or     %ebx,%eax
}
  80042014d8:	48 83 c4 18          	add    $0x18,%rsp
  80042014dc:	5b                   	pop    %rbx
  80042014dd:	5d                   	pop    %rbp
  80042014de:	c3                   	retq   

00000080042014df <multiboot_read>:

static void
multiboot_read(multiboot_info_t* mbinfo, size_t* basemem, size_t* extmem) {
  80042014df:	55                   	push   %rbp
  80042014e0:	48 89 e5             	mov    %rsp,%rbp
  80042014e3:	41 54                	push   %r12
  80042014e5:	53                   	push   %rbx
  80042014e6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80042014ed:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  80042014f4:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
  80042014fb:	48 89 95 48 ff ff ff 	mov    %rdx,-0xb8(%rbp)
  8004201502:	48 89 e0             	mov    %rsp,%rax
  8004201505:	49 89 c4             	mov    %rax,%r12
	int i;

	memory_map_t* mmap_base = (memory_map_t*)(uintptr_t)mbinfo->mmap_addr;
  8004201508:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800420150f:	8b 40 30             	mov    0x30(%rax),%eax
  8004201512:	89 c0                	mov    %eax,%eax
  8004201514:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
 	memory_map_t* mmap_list[mbinfo->mmap_length/ (sizeof(memory_map_t))];
  8004201518:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800420151f:	8b 40 2c             	mov    0x2c(%rax),%eax
  8004201522:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  8004201527:	f7 e2                	mul    %edx
  8004201529:	89 d0                	mov    %edx,%eax
  800420152b:	c1 e8 04             	shr    $0x4,%eax
  800420152e:	89 c0                	mov    %eax,%eax
  8004201530:	48 89 c2             	mov    %rax,%rdx
  8004201533:	48 83 ea 01          	sub    $0x1,%rdx
  8004201537:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800420153b:	49 89 c0             	mov    %rax,%r8
  800420153e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004201544:	48 89 c1             	mov    %rax,%rcx
  8004201547:	bb 00 00 00 00       	mov    $0x0,%ebx
  800420154c:	48 c1 e0 03          	shl    $0x3,%rax
  8004201550:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8004201554:	b8 10 00 00 00       	mov    $0x10,%eax
  8004201559:	48 83 e8 01          	sub    $0x1,%rax
  800420155d:	48 01 d0             	add    %rdx,%rax
  8004201560:	bb 10 00 00 00       	mov    $0x10,%ebx
  8004201565:	ba 00 00 00 00       	mov    $0x0,%edx
  800420156a:	48 f7 f3             	div    %rbx
  800420156d:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8004201571:	48 29 c4             	sub    %rax,%rsp
  8004201574:	48 89 e0             	mov    %rsp,%rax
  8004201577:	48 83 c0 07          	add    $0x7,%rax
  800420157b:	48 c1 e8 03          	shr    $0x3,%rax
  800420157f:	48 c1 e0 03          	shl    $0x3,%rax
  8004201583:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

	cprintf("\ne820 MEMORY MAP\n");
  8004201587:	48 bf 6b e6 20 04 80 	movabs $0x800420e66b,%rdi
  800420158e:	00 00 00 
  8004201591:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201596:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  800420159d:	00 00 00 
  80042015a0:	ff d2                	callq  *%rdx
	for(i = 0; i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  80042015a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80042015a9:	e9 6c 01 00 00       	jmpq   800420171a <multiboot_read+0x23b>
		memory_map_t* mmap = &mmap_base[i];
  80042015ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042015b1:	48 63 d0             	movslq %eax,%rdx
  80042015b4:	48 89 d0             	mov    %rdx,%rax
  80042015b7:	48 01 c0             	add    %rax,%rax
  80042015ba:	48 01 d0             	add    %rdx,%rax
  80042015bd:	48 c1 e0 03          	shl    $0x3,%rax
  80042015c1:	48 89 c2             	mov    %rax,%rdx
  80042015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042015c8:	48 01 d0             	add    %rdx,%rax
  80042015cb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

		uint64_t addr = APPEND_HILO(mmap->base_addr_high, mmap->base_addr_low);
  80042015cf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042015d3:	8b 40 08             	mov    0x8(%rax),%eax
  80042015d6:	89 c0                	mov    %eax,%eax
  80042015d8:	48 c1 e0 20          	shl    $0x20,%rax
  80042015dc:	48 89 c2             	mov    %rax,%rdx
  80042015df:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042015e3:	8b 40 04             	mov    0x4(%rax),%eax
  80042015e6:	89 c0                	mov    %eax,%eax
  80042015e8:	48 01 d0             	add    %rdx,%rax
  80042015eb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
		uint64_t len = APPEND_HILO(mmap->length_high, mmap->length_low);
  80042015ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042015f3:	8b 40 10             	mov    0x10(%rax),%eax
  80042015f6:	89 c0                	mov    %eax,%eax
  80042015f8:	48 c1 e0 20          	shl    $0x20,%rax
  80042015fc:	48 89 c2             	mov    %rax,%rdx
  80042015ff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201603:	8b 40 0c             	mov    0xc(%rax),%eax
  8004201606:	89 c0                	mov    %eax,%eax
  8004201608:	48 01 d0             	add    %rdx,%rax
  800420160b:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
        
		cprintf("size: %d, address: 0x%016x, length: 0x%016x, type: %x\n", mmap->size, 
  800420160f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201613:	8b 70 14             	mov    0x14(%rax),%esi
  8004201616:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420161a:	8b 00                	mov    (%rax),%eax
  800420161c:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  8004201620:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004201624:	41 89 f0             	mov    %esi,%r8d
  8004201627:	89 c6                	mov    %eax,%esi
  8004201629:	48 bf 80 e6 20 04 80 	movabs $0x800420e680,%rdi
  8004201630:	00 00 00 
  8004201633:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201638:	49 b9 66 64 20 04 80 	movabs $0x8004206466,%r9
  800420163f:	00 00 00 
  8004201642:	41 ff d1             	callq  *%r9
			addr, len, mmap->type);

		if(mmap->type > 5 || mmap->type < 1)
  8004201645:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201649:	8b 40 14             	mov    0x14(%rax),%eax
  800420164c:	83 f8 05             	cmp    $0x5,%eax
  800420164f:	77 0b                	ja     800420165c <multiboot_read+0x17d>
  8004201651:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201655:	8b 40 14             	mov    0x14(%rax),%eax
  8004201658:	85 c0                	test   %eax,%eax
  800420165a:	75 0b                	jne    8004201667 <multiboot_read+0x188>
			mmap->type = MB_TYPE_RESERVED;
  800420165c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201660:	c7 40 14 02 00 00 00 	movl   $0x2,0x14(%rax)
       
		//Insert into the sorted list
		int j = 0;
  8004201667:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
		for(;j<i;j++) {
  800420166e:	e9 85 00 00 00       	jmpq   80042016f8 <multiboot_read+0x219>
			memory_map_t* this = mmap_list[j];
  8004201673:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201677:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800420167a:	48 63 d2             	movslq %edx,%rdx
  800420167d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8004201681:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			uint64_t this_addr = APPEND_HILO(this->base_addr_high, this->base_addr_low);
  8004201685:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004201689:	8b 40 08             	mov    0x8(%rax),%eax
  800420168c:	89 c0                	mov    %eax,%eax
  800420168e:	48 c1 e0 20          	shl    $0x20,%rax
  8004201692:	48 89 c2             	mov    %rax,%rdx
  8004201695:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004201699:	8b 40 04             	mov    0x4(%rax),%eax
  800420169c:	89 c0                	mov    %eax,%eax
  800420169e:	48 01 d0             	add    %rdx,%rax
  80042016a1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			if(this_addr > addr) {
  80042016a5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042016a9:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  80042016ad:	76 45                	jbe    80042016f4 <multiboot_read+0x215>
				int last = i+1;
  80042016af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042016b2:	83 c0 01             	add    $0x1,%eax
  80042016b5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
				while(last != j) {
  80042016b8:	eb 30                	jmp    80042016ea <multiboot_read+0x20b>
					*(mmap_list + last) = *(mmap_list + last - 1);
  80042016ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042016be:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80042016c1:	48 63 d2             	movslq %edx,%rdx
  80042016c4:	48 c1 e2 03          	shl    $0x3,%rdx
  80042016c8:	48 01 c2             	add    %rax,%rdx
  80042016cb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042016cf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80042016d2:	48 63 c9             	movslq %ecx,%rcx
  80042016d5:	48 c1 e1 03          	shl    $0x3,%rcx
  80042016d9:	48 83 e9 08          	sub    $0x8,%rcx
  80042016dd:	48 01 c8             	add    %rcx,%rax
  80042016e0:	48 8b 00             	mov    (%rax),%rax
  80042016e3:	48 89 02             	mov    %rax,(%rdx)
					last--;
  80042016e6:	83 6d e4 01          	subl   $0x1,-0x1c(%rbp)
		for(;j<i;j++) {
			memory_map_t* this = mmap_list[j];
			uint64_t this_addr = APPEND_HILO(this->base_addr_high, this->base_addr_low);
			if(this_addr > addr) {
				int last = i+1;
				while(last != j) {
  80042016ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042016ed:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80042016f0:	75 c8                	jne    80042016ba <multiboot_read+0x1db>
					*(mmap_list + last) = *(mmap_list + last - 1);
					last--;
				}
				break; 
  80042016f2:	eb 10                	jmp    8004201704 <multiboot_read+0x225>
		if(mmap->type > 5 || mmap->type < 1)
			mmap->type = MB_TYPE_RESERVED;
       
		//Insert into the sorted list
		int j = 0;
		for(;j<i;j++) {
  80042016f4:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80042016f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80042016fb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80042016fe:	0f 8c 6f ff ff ff    	jl     8004201673 <multiboot_read+0x194>
					last--;
				}
				break; 
			}
		}
		mmap_list[j] = mmap;  
  8004201704:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201708:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800420170b:	48 63 d2             	movslq %edx,%rdx
  800420170e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8004201712:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)

	memory_map_t* mmap_base = (memory_map_t*)(uintptr_t)mbinfo->mmap_addr;
 	memory_map_t* mmap_list[mbinfo->mmap_length/ (sizeof(memory_map_t))];

	cprintf("\ne820 MEMORY MAP\n");
	for(i = 0; i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  8004201716:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800420171a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420171d:	48 63 c8             	movslq %eax,%rcx
  8004201720:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004201727:	8b 40 2c             	mov    0x2c(%rax),%eax
  800420172a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  800420172f:	f7 e2                	mul    %edx
  8004201731:	89 d0                	mov    %edx,%eax
  8004201733:	c1 e8 04             	shr    $0x4,%eax
  8004201736:	89 c0                	mov    %eax,%eax
  8004201738:	48 39 c1             	cmp    %rax,%rcx
  800420173b:	0f 82 6d fe ff ff    	jb     80042015ae <multiboot_read+0xcf>
				break; 
			}
		}
		mmap_list[j] = mmap;  
	}
	cprintf("\n");
  8004201741:	48 bf b7 e6 20 04 80 	movabs $0x800420e6b7,%rdi
  8004201748:	00 00 00 
  800420174b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201750:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004201757:	00 00 00 
  800420175a:	ff d2                	callq  *%rdx
    
	// Sanitize the list
	for(i=1;i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  800420175c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8004201763:	e9 93 01 00 00       	jmpq   80042018fb <multiboot_read+0x41c>
		memory_map_t* prev = mmap_list[i-1];
  8004201768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420176b:	8d 50 ff             	lea    -0x1(%rax),%edx
  800420176e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201772:	48 63 d2             	movslq %edx,%rdx
  8004201775:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8004201779:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		memory_map_t* this = mmap_list[i];
  800420177d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201781:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004201784:	48 63 d2             	movslq %edx,%rdx
  8004201787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800420178b:	48 89 45 90          	mov    %rax,-0x70(%rbp)

		uint64_t this_addr = APPEND_HILO(this->base_addr_high, this->base_addr_low);
  800420178f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004201793:	8b 40 08             	mov    0x8(%rax),%eax
  8004201796:	89 c0                	mov    %eax,%eax
  8004201798:	48 c1 e0 20          	shl    $0x20,%rax
  800420179c:	48 89 c2             	mov    %rax,%rdx
  800420179f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042017a3:	8b 40 04             	mov    0x4(%rax),%eax
  80042017a6:	89 c0                	mov    %eax,%eax
  80042017a8:	48 01 d0             	add    %rdx,%rax
  80042017ab:	48 89 45 88          	mov    %rax,-0x78(%rbp)
		uint64_t prev_addr = APPEND_HILO(prev->base_addr_high, prev->base_addr_low);
  80042017af:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042017b3:	8b 40 08             	mov    0x8(%rax),%eax
  80042017b6:	89 c0                	mov    %eax,%eax
  80042017b8:	48 c1 e0 20          	shl    $0x20,%rax
  80042017bc:	48 89 c2             	mov    %rax,%rdx
  80042017bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042017c3:	8b 40 04             	mov    0x4(%rax),%eax
  80042017c6:	89 c0                	mov    %eax,%eax
  80042017c8:	48 01 d0             	add    %rdx,%rax
  80042017cb:	48 89 45 80          	mov    %rax,-0x80(%rbp)
		uint64_t prev_length = APPEND_HILO(prev->length_high, prev->length_low);
  80042017cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042017d3:	8b 40 10             	mov    0x10(%rax),%eax
  80042017d6:	89 c0                	mov    %eax,%eax
  80042017d8:	48 c1 e0 20          	shl    $0x20,%rax
  80042017dc:	48 89 c2             	mov    %rax,%rdx
  80042017df:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042017e3:	8b 40 0c             	mov    0xc(%rax),%eax
  80042017e6:	89 c0                	mov    %eax,%eax
  80042017e8:	48 01 d0             	add    %rdx,%rax
  80042017eb:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
		uint64_t this_length = APPEND_HILO(this->length_high, this->length_low);
  80042017f2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042017f6:	8b 40 10             	mov    0x10(%rax),%eax
  80042017f9:	89 c0                	mov    %eax,%eax
  80042017fb:	48 c1 e0 20          	shl    $0x20,%rax
  80042017ff:	48 89 c2             	mov    %rax,%rdx
  8004201802:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004201806:	8b 40 0c             	mov    0xc(%rax),%eax
  8004201809:	89 c0                	mov    %eax,%eax
  800420180b:	48 01 d0             	add    %rdx,%rax
  800420180e:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)

		// Merge adjacent regions with same type
		if(prev_addr + prev_length == this_addr && prev->type == this->type) {
  8004201815:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420181c:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004201820:	48 01 d0             	add    %rdx,%rax
  8004201823:	48 3b 45 88          	cmp    -0x78(%rbp),%rax
  8004201827:	75 7c                	jne    80042018a5 <multiboot_read+0x3c6>
  8004201829:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420182d:	8b 50 14             	mov    0x14(%rax),%edx
  8004201830:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004201834:	8b 40 14             	mov    0x14(%rax),%eax
  8004201837:	39 c2                	cmp    %eax,%edx
  8004201839:	75 6a                	jne    80042018a5 <multiboot_read+0x3c6>
			this->length_low = (uint32_t)prev_length + this_length;
  800420183b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004201842:	89 c2                	mov    %eax,%edx
  8004201844:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420184b:	01 c2                	add    %eax,%edx
  800420184d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004201851:	89 50 0c             	mov    %edx,0xc(%rax)
			this->length_high = (uint32_t)((prev_length + this_length)>>32);
  8004201854:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420185b:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004201862:	48 01 d0             	add    %rdx,%rax
  8004201865:	48 c1 e8 20          	shr    $0x20,%rax
  8004201869:	89 c2                	mov    %eax,%edx
  800420186b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420186f:	89 50 10             	mov    %edx,0x10(%rax)
			this->base_addr_low = prev->base_addr_low;
  8004201872:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201876:	8b 50 04             	mov    0x4(%rax),%edx
  8004201879:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420187d:	89 50 04             	mov    %edx,0x4(%rax)
			this->base_addr_high = prev->base_addr_high;
  8004201880:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004201884:	8b 50 08             	mov    0x8(%rax),%edx
  8004201887:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420188b:	89 50 08             	mov    %edx,0x8(%rax)
			mmap_list[i-1] = NULL;
  800420188e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004201891:	8d 50 ff             	lea    -0x1(%rax),%edx
  8004201894:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201898:	48 63 d2             	movslq %edx,%rdx
  800420189b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80042018a2:	00 
  80042018a3:	eb 52                	jmp    80042018f7 <multiboot_read+0x418>
		} else if(prev_addr + prev_length > this_addr) {
  80042018a5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  80042018ac:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  80042018b0:	48 01 d0             	add    %rdx,%rax
  80042018b3:	48 3b 45 88          	cmp    -0x78(%rbp),%rax
  80042018b7:	76 3e                	jbe    80042018f7 <multiboot_read+0x418>
			//Overlapping regions
			uint32_t type = restrictive_type(prev->type, this->type);
  80042018b9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042018bd:	8b 50 14             	mov    0x14(%rax),%edx
  80042018c0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042018c4:	8b 40 14             	mov    0x14(%rax),%eax
  80042018c7:	89 d6                	mov    %edx,%esi
  80042018c9:	89 c7                	mov    %eax,%edi
  80042018cb:	48 b8 3f 14 20 04 80 	movabs $0x800420143f,%rax
  80042018d2:	00 00 00 
  80042018d5:	ff d0                	callq  *%rax
  80042018d7:	89 85 6c ff ff ff    	mov    %eax,-0x94(%rbp)
			prev->type = type;
  80042018dd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042018e1:	8b 95 6c ff ff ff    	mov    -0x94(%rbp),%edx
  80042018e7:	89 50 14             	mov    %edx,0x14(%rax)
			this->type = type;
  80042018ea:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042018ee:	8b 95 6c ff ff ff    	mov    -0x94(%rbp),%edx
  80042018f4:	89 50 14             	mov    %edx,0x14(%rax)
		mmap_list[j] = mmap;  
	}
	cprintf("\n");
    
	// Sanitize the list
	for(i=1;i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  80042018f7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80042018fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042018fe:	48 63 c8             	movslq %eax,%rcx
  8004201901:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004201908:	8b 40 2c             	mov    0x2c(%rax),%eax
  800420190b:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  8004201910:	f7 e2                	mul    %edx
  8004201912:	89 d0                	mov    %edx,%eax
  8004201914:	c1 e8 04             	shr    $0x4,%eax
  8004201917:	89 c0                	mov    %eax,%eax
  8004201919:	48 39 c1             	cmp    %rax,%rcx
  800420191c:	0f 82 46 fe ff ff    	jb     8004201768 <multiboot_read+0x289>
			prev->type = type;
			this->type = type;
		}
	}

	for(i=0;i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  8004201922:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8004201929:	e9 dc 00 00 00       	jmpq   8004201a0a <multiboot_read+0x52b>
		memory_map_t* mmap = mmap_list[i];
  800420192e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201932:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8004201935:	48 63 d2             	movslq %edx,%rdx
  8004201938:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800420193c:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
		if(mmap) {
  8004201943:	48 83 bd 60 ff ff ff 	cmpq   $0x0,-0xa0(%rbp)
  800420194a:	00 
  800420194b:	0f 84 b5 00 00 00    	je     8004201a06 <multiboot_read+0x527>
			if(mmap->type == MB_TYPE_USABLE || mmap->type == MB_TYPE_ACPI_RECLM) {
  8004201951:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8004201958:	8b 40 14             	mov    0x14(%rax),%eax
  800420195b:	83 f8 01             	cmp    $0x1,%eax
  800420195e:	74 13                	je     8004201973 <multiboot_read+0x494>
  8004201960:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8004201967:	8b 40 14             	mov    0x14(%rax),%eax
  800420196a:	83 f8 03             	cmp    $0x3,%eax
  800420196d:	0f 85 93 00 00 00    	jne    8004201a06 <multiboot_read+0x527>
				if(mmap->base_addr_low < 0x100000 && mmap->base_addr_high == 0)
  8004201973:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800420197a:	8b 40 04             	mov    0x4(%rax),%eax
  800420197d:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  8004201982:	77 49                	ja     80042019cd <multiboot_read+0x4ee>
  8004201984:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800420198b:	8b 40 08             	mov    0x8(%rax),%eax
  800420198e:	85 c0                	test   %eax,%eax
  8004201990:	75 3b                	jne    80042019cd <multiboot_read+0x4ee>
					*basemem += APPEND_HILO(mmap->length_high, mmap->length_low);
  8004201992:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004201999:	48 8b 10             	mov    (%rax),%rdx
  800420199c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80042019a3:	8b 40 10             	mov    0x10(%rax),%eax
  80042019a6:	89 c0                	mov    %eax,%eax
  80042019a8:	48 c1 e0 20          	shl    $0x20,%rax
  80042019ac:	48 89 c1             	mov    %rax,%rcx
  80042019af:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80042019b6:	8b 40 0c             	mov    0xc(%rax),%eax
  80042019b9:	89 c0                	mov    %eax,%eax
  80042019bb:	48 01 c8             	add    %rcx,%rax
  80042019be:	48 01 c2             	add    %rax,%rdx
  80042019c1:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80042019c8:	48 89 10             	mov    %rdx,(%rax)
  80042019cb:	eb 39                	jmp    8004201a06 <multiboot_read+0x527>
				else
					*extmem += APPEND_HILO(mmap->length_high, mmap->length_low);
  80042019cd:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80042019d4:	48 8b 10             	mov    (%rax),%rdx
  80042019d7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80042019de:	8b 40 10             	mov    0x10(%rax),%eax
  80042019e1:	89 c0                	mov    %eax,%eax
  80042019e3:	48 c1 e0 20          	shl    $0x20,%rax
  80042019e7:	48 89 c1             	mov    %rax,%rcx
  80042019ea:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80042019f1:	8b 40 0c             	mov    0xc(%rax),%eax
  80042019f4:	89 c0                	mov    %eax,%eax
  80042019f6:	48 01 c8             	add    %rcx,%rax
  80042019f9:	48 01 c2             	add    %rax,%rdx
  80042019fc:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004201a03:	48 89 10             	mov    %rdx,(%rax)
			prev->type = type;
			this->type = type;
		}
	}

	for(i=0;i < (mbinfo->mmap_length / (sizeof(memory_map_t))); i++) {
  8004201a06:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8004201a0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004201a0d:	48 63 c8             	movslq %eax,%rcx
  8004201a10:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004201a17:	8b 40 2c             	mov    0x2c(%rax),%eax
  8004201a1a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  8004201a1f:	f7 e2                	mul    %edx
  8004201a21:	89 d0                	mov    %edx,%eax
  8004201a23:	c1 e8 04             	shr    $0x4,%eax
  8004201a26:	89 c0                	mov    %eax,%eax
  8004201a28:	48 39 c1             	cmp    %rax,%rcx
  8004201a2b:	0f 82 fd fe ff ff    	jb     800420192e <multiboot_read+0x44f>
  8004201a31:	4c 89 e4             	mov    %r12,%rsp
				else
					*extmem += APPEND_HILO(mmap->length_high, mmap->length_low);
			}
		}
	}
}
  8004201a34:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
  8004201a38:	5b                   	pop    %rbx
  8004201a39:	41 5c                	pop    %r12
  8004201a3b:	5d                   	pop    %rbp
  8004201a3c:	c3                   	retq   

0000008004201a3d <i386_detect_memory>:

static void
i386_detect_memory(void)
{
  8004201a3d:	55                   	push   %rbp
  8004201a3e:	48 89 e5             	mov    %rsp,%rbp
  8004201a41:	48 83 ec 50          	sub    $0x50,%rsp
	size_t npages_extmem;
	size_t basemem = 0;
  8004201a45:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004201a4c:	00 
	size_t extmem = 0;
  8004201a4d:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8004201a54:	00 

	// Check if the bootloader passed us a multiboot structure
	extern char multiboot_info[];
	uintptr_t* mbp = (uintptr_t*)multiboot_info;
  8004201a55:	48 b8 00 70 10 00 00 	movabs $0x107000,%rax
  8004201a5c:	00 00 00 
  8004201a5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	multiboot_info_t * mbinfo = (multiboot_info_t*)*mbp;
  8004201a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004201a67:	48 8b 00             	mov    (%rax),%rax
  8004201a6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	if(mbinfo && (mbinfo->flags & MB_FLAG_MMAP)) {
  8004201a6e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004201a73:	74 2d                	je     8004201aa2 <i386_detect_memory+0x65>
  8004201a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201a79:	8b 00                	mov    (%rax),%eax
  8004201a7b:	83 e0 40             	and    $0x40,%eax
  8004201a7e:	85 c0                	test   %eax,%eax
  8004201a80:	74 20                	je     8004201aa2 <i386_detect_memory+0x65>
		multiboot_read(mbinfo, &basemem, &extmem);
  8004201a82:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8004201a86:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004201a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201a8e:	48 89 ce             	mov    %rcx,%rsi
  8004201a91:	48 89 c7             	mov    %rax,%rdi
  8004201a94:	48 b8 df 14 20 04 80 	movabs $0x80042014df,%rax
  8004201a9b:	00 00 00 
  8004201a9e:	ff d0                	callq  *%rax
  8004201aa0:	eb 34                	jmp    8004201ad6 <i386_detect_memory+0x99>
	} else {
		basemem = (nvram_read(NVRAM_BASELO) * 1024);
  8004201aa2:	bf 15 00 00 00       	mov    $0x15,%edi
  8004201aa7:	48 b8 a0 14 20 04 80 	movabs $0x80042014a0,%rax
  8004201aae:	00 00 00 
  8004201ab1:	ff d0                	callq  *%rax
  8004201ab3:	c1 e0 0a             	shl    $0xa,%eax
  8004201ab6:	48 98                	cltq   
  8004201ab8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		extmem = (nvram_read(NVRAM_EXTLO) * 1024);
  8004201abc:	bf 17 00 00 00       	mov    $0x17,%edi
  8004201ac1:	48 b8 a0 14 20 04 80 	movabs $0x80042014a0,%rax
  8004201ac8:	00 00 00 
  8004201acb:	ff d0                	callq  *%rax
  8004201acd:	c1 e0 0a             	shl    $0xa,%eax
  8004201ad0:	48 98                	cltq   
  8004201ad2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	}

	assert(basemem);
  8004201ad6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201ada:	48 85 c0             	test   %rax,%rax
  8004201add:	75 35                	jne    8004201b14 <i386_detect_memory+0xd7>
  8004201adf:	48 b9 b9 e6 20 04 80 	movabs $0x800420e6b9,%rcx
  8004201ae6:	00 00 00 
  8004201ae9:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004201af0:	00 00 00 
  8004201af3:	be 84 00 00 00       	mov    $0x84,%esi
  8004201af8:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004201aff:	00 00 00 
  8004201b02:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201b07:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004201b0e:	00 00 00 
  8004201b11:	41 ff d0             	callq  *%r8

	npages_basemem = basemem / PGSIZE;
  8004201b14:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004201b18:	48 c1 e8 0c          	shr    $0xc,%rax
  8004201b1c:	48 89 c2             	mov    %rax,%rdx
  8004201b1f:	48 b8 d0 28 22 04 80 	movabs $0x80042228d0,%rax
  8004201b26:	00 00 00 
  8004201b29:	48 89 10             	mov    %rdx,(%rax)
	npages_extmem = extmem / PGSIZE;
  8004201b2c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004201b30:	48 c1 e8 0c          	shr    $0xc,%rax
  8004201b34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	
	if(nvram_read(NVRAM_EXTLO) == 0xffff) {
  8004201b38:	bf 17 00 00 00       	mov    $0x17,%edi
  8004201b3d:	48 b8 a0 14 20 04 80 	movabs $0x80042014a0,%rax
  8004201b44:	00 00 00 
  8004201b47:	ff d0                	callq  *%rax
  8004201b49:	3d ff ff 00 00       	cmp    $0xffff,%eax
  8004201b4e:	75 2c                	jne    8004201b7c <i386_detect_memory+0x13f>
		// EXTMEM > 16M in blocks of 64k
		size_t pextmem = nvram_read(NVRAM_EXTGT16LO) * (64 * 1024);
  8004201b50:	bf 34 00 00 00       	mov    $0x34,%edi
  8004201b55:	48 b8 a0 14 20 04 80 	movabs $0x80042014a0,%rax
  8004201b5c:	00 00 00 
  8004201b5f:	ff d0                	callq  *%rax
  8004201b61:	c1 e0 10             	shl    $0x10,%eax
  8004201b64:	48 98                	cltq   
  8004201b66:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		npages_extmem = ((16 * 1024 * 1024) + pextmem - (1 * 1024 * 1024)) / PGSIZE;
  8004201b6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201b6e:	48 05 00 00 f0 00    	add    $0xf00000,%rax
  8004201b74:	48 c1 e8 0c          	shr    $0xc,%rax
  8004201b78:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	}
	
	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
  8004201b7c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004201b81:	74 1a                	je     8004201b9d <i386_detect_memory+0x160>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  8004201b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201b87:	48 8d 90 00 01 00 00 	lea    0x100(%rax),%rdx
  8004201b8e:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201b95:	00 00 00 
  8004201b98:	48 89 10             	mov    %rdx,(%rax)
  8004201b9b:	eb 1a                	jmp    8004201bb7 <i386_detect_memory+0x17a>
	else
		npages = npages_basemem;
  8004201b9d:	48 b8 d0 28 22 04 80 	movabs $0x80042228d0,%rax
  8004201ba4:	00 00 00 
  8004201ba7:	48 8b 10             	mov    (%rax),%rdx
  8004201baa:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201bb1:	00 00 00 
  8004201bb4:	48 89 10             	mov    %rdx,(%rax)

	cprintf("Physical memory: %uM available, base = %uK, extended = %uK, npages = %d\n",
  8004201bb7:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201bbe:	00 00 00 
  8004201bc1:	48 8b 30             	mov    (%rax),%rsi
		npages * PGSIZE / (1024 * 1024),
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024,
  8004201bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201bc8:	48 c1 e0 0c          	shl    $0xc,%rax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uM available, base = %uK, extended = %uK, npages = %d\n",
  8004201bcc:	48 c1 e8 0a          	shr    $0xa,%rax
  8004201bd0:	48 89 c1             	mov    %rax,%rcx
		npages * PGSIZE / (1024 * 1024),
		npages_basemem * PGSIZE / 1024,
  8004201bd3:	48 b8 d0 28 22 04 80 	movabs $0x80042228d0,%rax
  8004201bda:	00 00 00 
  8004201bdd:	48 8b 00             	mov    (%rax),%rax
  8004201be0:	48 c1 e0 0c          	shl    $0xc,%rax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uM available, base = %uK, extended = %uK, npages = %d\n",
  8004201be4:	48 c1 e8 0a          	shr    $0xa,%rax
  8004201be8:	48 89 c2             	mov    %rax,%rdx
		npages * PGSIZE / (1024 * 1024),
  8004201beb:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201bf2:	00 00 00 
  8004201bf5:	48 8b 00             	mov    (%rax),%rax
  8004201bf8:	48 c1 e0 0c          	shl    $0xc,%rax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uM available, base = %uK, extended = %uK, npages = %d\n",
  8004201bfc:	48 c1 e8 14          	shr    $0x14,%rax
  8004201c00:	49 89 f0             	mov    %rsi,%r8
  8004201c03:	48 89 c6             	mov    %rax,%rsi
  8004201c06:	48 bf e8 e6 20 04 80 	movabs $0x800420e6e8,%rdi
  8004201c0d:	00 00 00 
  8004201c10:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201c15:	49 b9 66 64 20 04 80 	movabs $0x8004206466,%r9
  8004201c1c:	00 00 00 
  8004201c1f:	41 ff d1             	callq  *%r9
	//JOS 64 pages are limited by the size of both the UPAGES
	//  virtual address space, and the range from KERNBASE to UVPT.
	//
	// NB: qemu seems to have a bug that crashes the host system on 13.10 if you try to 
	//     max out memory.
	uint64_t upages_max = (ULIM - UPAGES) / sizeof(struct PageInfo);
  8004201c22:	48 c7 45 d8 00 00 32 	movq   $0x320000,-0x28(%rbp)
  8004201c29:	00 
	uint64_t kern_mem_max = (UVPT - KERNBASE) / PGSIZE;
  8004201c2a:	48 c7 45 d0 00 c0 ff 	movq   $0x7ffc000,-0x30(%rbp)
  8004201c31:	07 
	cprintf("Pages limited to %llu by upage address range (%uMB), Pages limited to %llu by remapped phys mem (%uMB)\n", 
		upages_max, ((upages_max * PGSIZE) / (1024 * 1024)),
		kern_mem_max, kern_mem_max * PGSIZE / (1024 * 1024));
  8004201c32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004201c36:	48 c1 e0 0c          	shl    $0xc,%rax
	//
	// NB: qemu seems to have a bug that crashes the host system on 13.10 if you try to 
	//     max out memory.
	uint64_t upages_max = (ULIM - UPAGES) / sizeof(struct PageInfo);
	uint64_t kern_mem_max = (UVPT - KERNBASE) / PGSIZE;
	cprintf("Pages limited to %llu by upage address range (%uMB), Pages limited to %llu by remapped phys mem (%uMB)\n", 
  8004201c3a:	48 c1 e8 14          	shr    $0x14,%rax
  8004201c3e:	48 89 c1             	mov    %rax,%rcx
		upages_max, ((upages_max * PGSIZE) / (1024 * 1024)),
  8004201c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004201c45:	48 c1 e0 0c          	shl    $0xc,%rax
	//
	// NB: qemu seems to have a bug that crashes the host system on 13.10 if you try to 
	//     max out memory.
	uint64_t upages_max = (ULIM - UPAGES) / sizeof(struct PageInfo);
	uint64_t kern_mem_max = (UVPT - KERNBASE) / PGSIZE;
	cprintf("Pages limited to %llu by upage address range (%uMB), Pages limited to %llu by remapped phys mem (%uMB)\n", 
  8004201c49:	48 c1 e8 14          	shr    $0x14,%rax
  8004201c4d:	48 89 c6             	mov    %rax,%rsi
  8004201c50:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004201c54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004201c58:	49 89 c8             	mov    %rcx,%r8
  8004201c5b:	48 89 d1             	mov    %rdx,%rcx
  8004201c5e:	48 89 f2             	mov    %rsi,%rdx
  8004201c61:	48 89 c6             	mov    %rax,%rsi
  8004201c64:	48 bf 38 e7 20 04 80 	movabs $0x800420e738,%rdi
  8004201c6b:	00 00 00 
  8004201c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201c73:	49 b9 66 64 20 04 80 	movabs $0x8004206466,%r9
  8004201c7a:	00 00 00 
  8004201c7d:	41 ff d1             	callq  *%r9
		upages_max, ((upages_max * PGSIZE) / (1024 * 1024)),
		kern_mem_max, kern_mem_max * PGSIZE / (1024 * 1024));
	uint64_t max_npages = upages_max < kern_mem_max ? upages_max : kern_mem_max;
  8004201c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004201c84:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
  8004201c88:	48 0f 46 45 d0       	cmovbe -0x30(%rbp),%rax
  8004201c8d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

	if(npages > max_npages) {
  8004201c91:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201c98:	00 00 00 
  8004201c9b:	48 8b 00             	mov    (%rax),%rax
  8004201c9e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004201ca2:	76 3a                	jbe    8004201cde <i386_detect_memory+0x2a1>
		npages = max_npages - 1024;
  8004201ca4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201ca8:	48 8d 90 00 fc ff ff 	lea    -0x400(%rax),%rdx
  8004201caf:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201cb6:	00 00 00 
  8004201cb9:	48 89 10             	mov    %rdx,(%rax)
		cprintf("Using only %uK of the available memory.\n", max_npages);
  8004201cbc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004201cc0:	48 89 c6             	mov    %rax,%rsi
  8004201cc3:	48 bf a0 e7 20 04 80 	movabs $0x800420e7a0,%rdi
  8004201cca:	00 00 00 
  8004201ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201cd2:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004201cd9:	00 00 00 
  8004201cdc:	ff d2                	callq  *%rdx
	}
}
  8004201cde:	c9                   	leaveq 
  8004201cdf:	c3                   	retq   

0000008004201ce0 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
  8004201ce0:	55                   	push   %rbp
  8004201ce1:	48 89 e5             	mov    %rsp,%rbp
  8004201ce4:	48 83 ec 40          	sub    $0x40,%rsp
  8004201ce8:	89 7d cc             	mov    %edi,-0x34(%rbp)
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
  8004201ceb:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201cf2:	00 00 00 
  8004201cf5:	48 8b 00             	mov    (%rax),%rax
  8004201cf8:	48 85 c0             	test   %rax,%rax
  8004201cfb:	75 4b                	jne    8004201d48 <boot_alloc+0x68>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
  8004201cfd:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
  8004201d04:	00 
  8004201d05:	48 b8 80 3d 22 04 80 	movabs $0x8004223d80,%rax
  8004201d0c:	00 00 00 
  8004201d0f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004201d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201d17:	48 01 d0             	add    %rdx,%rax
  8004201d1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004201d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004201d22:	ba 00 00 00 00       	mov    $0x0,%edx
  8004201d27:	48 f7 75 f8          	divq   -0x8(%rbp)
  8004201d2b:	48 89 d0             	mov    %rdx,%rax
  8004201d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004201d32:	48 29 c2             	sub    %rax,%rdx
  8004201d35:	48 89 d0             	mov    %rdx,%rax
  8004201d38:	48 89 c2             	mov    %rax,%rdx
  8004201d3b:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201d42:	00 00 00 
  8004201d45:	48 89 10             	mov    %rdx,(%rax)
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.

	if((uint64_t)(nextfree + n) > (npages * PGSIZE + KERNBASE))
  8004201d48:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201d4f:	00 00 00 
  8004201d52:	48 8b 10             	mov    (%rax),%rdx
  8004201d55:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004201d58:	48 01 d0             	add    %rdx,%rax
  8004201d5b:	48 89 c2             	mov    %rax,%rdx
  8004201d5e:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201d65:	00 00 00 
  8004201d68:	48 8b 00             	mov    (%rax),%rax
  8004201d6b:	48 05 00 40 00 08    	add    $0x8004000,%rax
  8004201d71:	48 c1 e0 0c          	shl    $0xc,%rax
  8004201d75:	48 39 c2             	cmp    %rax,%rdx
  8004201d78:	76 2a                	jbe    8004201da4 <boot_alloc+0xc4>
		panic("out of memory in boot_alloc");
  8004201d7a:	48 ba c9 e7 20 04 80 	movabs $0x800420e7c9,%rdx
  8004201d81:	00 00 00 
  8004201d84:	be dd 00 00 00       	mov    $0xdd,%esi
  8004201d89:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004201d90:	00 00 00 
  8004201d93:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201d98:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004201d9f:	00 00 00 
  8004201da2:	ff d1                	callq  *%rcx
	result = nextfree;
  8004201da4:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201dab:	00 00 00 
  8004201dae:	48 8b 00             	mov    (%rax),%rax
  8004201db1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if(n != 0)
  8004201db5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004201db9:	74 57                	je     8004201e12 <boot_alloc+0x132>
		nextfree = ROUNDUP(nextfree + n,PGSIZE);
  8004201dbb:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  8004201dc2:	00 
  8004201dc3:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201dca:	00 00 00 
  8004201dcd:	48 8b 10             	mov    (%rax),%rdx
  8004201dd0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004201dd3:	48 01 d0             	add    %rdx,%rax
  8004201dd6:	48 89 c2             	mov    %rax,%rdx
  8004201dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201ddd:	48 01 d0             	add    %rdx,%rax
  8004201de0:	48 83 e8 01          	sub    $0x1,%rax
  8004201de4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8004201de8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004201dec:	ba 00 00 00 00       	mov    $0x0,%edx
  8004201df1:	48 f7 75 e0          	divq   -0x20(%rbp)
  8004201df5:	48 89 d0             	mov    %rdx,%rax
  8004201df8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004201dfc:	48 29 c2             	sub    %rax,%rdx
  8004201dff:	48 89 d0             	mov    %rdx,%rax
  8004201e02:	48 89 c2             	mov    %rax,%rdx
  8004201e05:	48 b8 e0 28 22 04 80 	movabs $0x80042228e0,%rax
  8004201e0c:	00 00 00 
  8004201e0f:	48 89 10             	mov    %rdx,(%rax)
	return result;
  8004201e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004201e16:	c9                   	leaveq 
  8004201e17:	c3                   	retq   

0000008004201e18 <x64_vm_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
x64_vm_init(void)
{
  8004201e18:	55                   	push   %rbp
  8004201e19:	48 89 e5             	mov    %rsp,%rbp
  8004201e1c:	48 83 ec 70          	sub    $0x70,%rsp
	pml4e_t* pml4e;
	uint32_t cr0;
	uint64_t n;
	int r;
	struct Env *env;
	i386_detect_memory();
  8004201e20:	48 b8 3d 1a 20 04 80 	movabs $0x8004201a3d,%rax
  8004201e27:	00 00 00 
  8004201e2a:	ff d0                	callq  *%rax
	//panic("i386_vm_init: This function is not finished\n");
	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	//panic("x64_vm_init: this function is not finished\n");
	pml4e = boot_alloc(PGSIZE);
  8004201e2c:	bf 00 10 00 00       	mov    $0x1000,%edi
  8004201e31:	48 b8 e0 1c 20 04 80 	movabs $0x8004201ce0,%rax
  8004201e38:	00 00 00 
  8004201e3b:	ff d0                	callq  *%rax
  8004201e3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memset(pml4e, 0, PGSIZE);
  8004201e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201e45:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004201e4a:	be 00 00 00 00       	mov    $0x0,%esi
  8004201e4f:	48 89 c7             	mov    %rax,%rdi
  8004201e52:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  8004201e59:	00 00 00 
  8004201e5c:	ff d0                	callq  *%rax
	boot_pml4e = pml4e;
  8004201e5e:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004201e65:	00 00 00 
  8004201e68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004201e6c:	48 89 10             	mov    %rdx,(%rax)
	boot_cr3 = PADDR(pml4e);
  8004201e6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201e73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004201e77:	48 b8 ff ff ff 03 80 	movabs $0x8003ffffff,%rax
  8004201e7e:	00 00 00 
  8004201e81:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  8004201e85:	77 32                	ja     8004201eb9 <x64_vm_init+0xa1>
  8004201e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004201e8b:	48 89 c1             	mov    %rax,%rcx
  8004201e8e:	48 ba e8 e7 20 04 80 	movabs $0x800420e7e8,%rdx
  8004201e95:	00 00 00 
  8004201e98:	be fd 00 00 00       	mov    $0xfd,%esi
  8004201e9d:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004201ea4:	00 00 00 
  8004201ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201eac:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004201eb3:	00 00 00 
  8004201eb6:	41 ff d0             	callq  *%r8
  8004201eb9:	48 ba 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rdx
  8004201ec0:	ff ff ff 
  8004201ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004201ec7:	48 01 c2             	add    %rax,%rdx
  8004201eca:	48 b8 78 2d 22 04 80 	movabs $0x8004222d78,%rax
  8004201ed1:	00 00 00 
  8004201ed4:	48 89 10             	mov    %rdx,(%rax)
	// Allocate an array of npages 'struct PageInfo's and store it in 'pages'.
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.
	// Your code goes here:
	pages = (struct PageInfo*)boot_alloc(npages * sizeof(struct PageInfo));
  8004201ed7:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201ede:	00 00 00 
  8004201ee1:	48 8b 00             	mov    (%rax),%rax
  8004201ee4:	c1 e0 04             	shl    $0x4,%eax
  8004201ee7:	89 c7                	mov    %eax,%edi
  8004201ee9:	48 b8 e0 1c 20 04 80 	movabs $0x8004201ce0,%rax
  8004201ef0:	00 00 00 
  8004201ef3:	ff d0                	callq  *%rax
  8004201ef5:	48 ba 90 2d 22 04 80 	movabs $0x8004222d90,%rdx
  8004201efc:	00 00 00 
  8004201eff:	48 89 02             	mov    %rax,(%rdx)
	//////////////////////////////////////////////////////////////////////
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region or page_insert
	page_init();
  8004201f02:	48 b8 2d 22 20 04 80 	movabs $0x800420222d,%rax
  8004201f09:	00 00 00 
  8004201f0c:	ff d0                	callq  *%rax
	check_page_free_list(1);
  8004201f0e:	bf 01 00 00 00       	mov    $0x1,%edi
  8004201f13:	48 b8 48 2f 20 04 80 	movabs $0x8004202f48,%rax
  8004201f1a:	00 00 00 
  8004201f1d:	ff d0                	callq  *%rax
	check_page_alloc();
  8004201f1f:	48 b8 25 34 20 04 80 	movabs $0x8004203425,%rax
  8004201f26:	00 00 00 
  8004201f29:	ff d0                	callq  *%rax
	page_check();
  8004201f2b:	48 b8 35 46 20 04 80 	movabs $0x8004204635,%rax
  8004201f32:	00 00 00 
  8004201f35:	ff d0                	callq  *%rax
	// Permissions:
	//    - the new image at UPAGES -- kernel R, us/er R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(pml4e, UPAGES, ROUNDUP(sizeof(struct PageInfo) * npages, PGSIZE), PADDR(pages), PTE_U);
  8004201f37:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004201f3e:	00 00 00 
  8004201f41:	48 8b 00             	mov    (%rax),%rax
  8004201f44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8004201f48:	48 b8 ff ff ff 03 80 	movabs $0x8003ffffff,%rax
  8004201f4f:	00 00 00 
  8004201f52:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8004201f56:	77 32                	ja     8004201f8a <x64_vm_init+0x172>
  8004201f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201f5c:	48 89 c1             	mov    %rax,%rcx
  8004201f5f:	48 ba e8 e7 20 04 80 	movabs $0x800420e7e8,%rdx
  8004201f66:	00 00 00 
  8004201f69:	be 18 01 00 00       	mov    $0x118,%esi
  8004201f6e:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004201f75:	00 00 00 
  8004201f78:	b8 00 00 00 00       	mov    $0x0,%eax
  8004201f7d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004201f84:	00 00 00 
  8004201f87:	41 ff d0             	callq  *%r8
  8004201f8a:	48 ba 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rdx
  8004201f91:	ff ff ff 
  8004201f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004201f98:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8004201f9c:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  8004201fa3:	00 
  8004201fa4:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004201fab:	00 00 00 
  8004201fae:	48 8b 00             	mov    (%rax),%rax
  8004201fb1:	48 c1 e0 04          	shl    $0x4,%rax
  8004201fb5:	48 89 c2             	mov    %rax,%rdx
  8004201fb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004201fbc:	48 01 d0             	add    %rdx,%rax
  8004201fbf:	48 83 e8 01          	sub    $0x1,%rax
  8004201fc3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8004201fc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004201fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004201fd0:	48 f7 75 e0          	divq   -0x20(%rbp)
  8004201fd4:	48 89 d0             	mov    %rdx,%rax
  8004201fd7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004201fdb:	48 29 c2             	sub    %rax,%rdx
  8004201fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004201fe2:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  8004201fe8:	48 be 00 00 a0 00 80 	movabs $0x8000a00000,%rsi
  8004201fef:	00 00 00 
  8004201ff2:	48 89 c7             	mov    %rax,%rdi
  8004201ff5:	48 b8 74 2c 20 04 80 	movabs $0x8004202c74,%rax
  8004201ffc:	00 00 00 
  8004201fff:	ff d0                	callq  *%rax
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(pml4e, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
  8004202001:	48 b8 00 20 21 04 80 	movabs $0x8004212000,%rax
  8004202008:	00 00 00 
  800420200b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800420200f:	48 b8 ff ff ff 03 80 	movabs $0x8003ffffff,%rax
  8004202016:	00 00 00 
  8004202019:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
  800420201d:	77 32                	ja     8004202051 <x64_vm_init+0x239>
  800420201f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202023:	48 89 c1             	mov    %rax,%rcx
  8004202026:	48 ba e8 e7 20 04 80 	movabs $0x800420e7e8,%rdx
  800420202d:	00 00 00 
  8004202030:	be 25 01 00 00       	mov    $0x125,%esi
  8004202035:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420203c:	00 00 00 
  800420203f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202044:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420204b:	00 00 00 
  800420204e:	41 ff d0             	callq  *%r8
  8004202051:	48 ba 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rdx
  8004202058:	ff ff ff 
  800420205b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420205f:	48 01 c2             	add    %rax,%rdx
  8004202062:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202066:	41 b8 02 00 00 00    	mov    $0x2,%r8d
  800420206c:	48 89 d1             	mov    %rdx,%rcx
  800420206f:	ba 00 00 01 00       	mov    $0x10000,%edx
  8004202074:	48 be 00 00 ff 03 80 	movabs $0x8003ff0000,%rsi
  800420207b:	00 00 00 
  800420207e:	48 89 c7             	mov    %rax,%rdi
  8004202081:	48 b8 74 2c 20 04 80 	movabs $0x8004202c74,%rax
  8004202088:	00 00 00 
  800420208b:	ff d0                	callq  *%rax
	// of physical pages to be npages.
	// Ie.  the VA range [KERNBASE, npages*PGSIZE) should map to
	//      the PA range [0, npages*PGSIZE)
	// Permissions: kernel RW, user NONE
	// Your code goes here: 
	boot_map_region(pml4e, KERNBASE, (npages * PGSIZE), 0x0, PTE_W);
  800420208d:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202094:	00 00 00 
  8004202097:	48 8b 00             	mov    (%rax),%rax
  800420209a:	48 c1 e0 0c          	shl    $0xc,%rax
  800420209e:	48 89 c2             	mov    %rax,%rdx
  80042020a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042020a5:	41 b8 02 00 00 00    	mov    $0x2,%r8d
  80042020ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  80042020b0:	48 be 00 00 00 04 80 	movabs $0x8004000000,%rsi
  80042020b7:	00 00 00 
  80042020ba:	48 89 c7             	mov    %rax,%rdi
  80042020bd:	48 b8 74 2c 20 04 80 	movabs $0x8004202c74,%rax
  80042020c4:	00 00 00 
  80042020c7:	ff d0                	callq  *%rax
	// Check that the initial page directory has been set up correctly.
	check_page_free_list(1);
  80042020c9:	bf 01 00 00 00       	mov    $0x1,%edi
  80042020ce:	48 b8 48 2f 20 04 80 	movabs $0x8004202f48,%rax
  80042020d5:	00 00 00 
  80042020d8:	ff d0                	callq  *%rax
	check_page_alloc();
  80042020da:	48 b8 25 34 20 04 80 	movabs $0x8004203425,%rax
  80042020e1:	00 00 00 
  80042020e4:	ff d0                	callq  *%rax
	page_check();
  80042020e6:	48 b8 35 46 20 04 80 	movabs $0x8004204635,%rax
  80042020ed:	00 00 00 
  80042020f0:	ff d0                	callq  *%rax
	check_page_free_list(0);
  80042020f2:	bf 00 00 00 00       	mov    $0x0,%edi
  80042020f7:	48 b8 48 2f 20 04 80 	movabs $0x8004202f48,%rax
  80042020fe:	00 00 00 
  8004202101:	ff d0                	callq  *%rax
	check_boot_pml4e(boot_pml4e);
  8004202103:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  800420210a:	00 00 00 
  800420210d:	48 8b 00             	mov    (%rax),%rax
  8004202110:	48 89 c7             	mov    %rax,%rdi
  8004202113:	48 b8 11 3e 20 04 80 	movabs $0x8004203e11,%rax
  800420211a:	00 00 00 
  800420211d:	ff d0                	callq  *%rax

	//////////////////////////////////////////////////////////////////////
	// Permissions: kernel RW, user NONE
	pdpe_t *pdpe = KADDR(PTE_ADDR(pml4e[1]));
  800420211f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202123:	48 83 c0 08          	add    $0x8,%rax
  8004202127:	48 8b 00             	mov    (%rax),%rax
  800420212a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202130:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8004202134:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202138:	48 c1 e8 0c          	shr    $0xc,%rax
  800420213c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
  800420213f:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004202142:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202149:	00 00 00 
  800420214c:	48 8b 00             	mov    (%rax),%rax
  800420214f:	48 39 c2             	cmp    %rax,%rdx
  8004202152:	72 32                	jb     8004202186 <x64_vm_init+0x36e>
  8004202154:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202158:	48 89 c1             	mov    %rax,%rcx
  800420215b:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004202162:	00 00 00 
  8004202165:	be 37 01 00 00       	mov    $0x137,%esi
  800420216a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004202171:	00 00 00 
  8004202174:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202179:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004202180:	00 00 00 
  8004202183:	41 ff d0             	callq  *%r8
  8004202186:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  800420218d:	00 00 00 
  8004202190:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202194:	48 01 d0             	add    %rdx,%rax
  8004202197:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	pde_t *pgdir = KADDR(PTE_ADDR(pdpe[0]));
  800420219b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420219f:	48 8b 00             	mov    (%rax),%rax
  80042021a2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80042021a8:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80042021ac:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042021b0:	48 c1 e8 0c          	shr    $0xc,%rax
  80042021b4:	89 45 ac             	mov    %eax,-0x54(%rbp)
  80042021b7:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80042021ba:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042021c1:	00 00 00 
  80042021c4:	48 8b 00             	mov    (%rax),%rax
  80042021c7:	48 39 c2             	cmp    %rax,%rdx
  80042021ca:	72 32                	jb     80042021fe <x64_vm_init+0x3e6>
  80042021cc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042021d0:	48 89 c1             	mov    %rax,%rcx
  80042021d3:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  80042021da:	00 00 00 
  80042021dd:	be 38 01 00 00       	mov    $0x138,%esi
  80042021e2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042021e9:	00 00 00 
  80042021ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80042021f1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042021f8:	00 00 00 
  80042021fb:	41 ff d0             	callq  *%r8
  80042021fe:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004202205:	00 00 00 
  8004202208:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420220c:	48 01 d0             	add    %rdx,%rax
  800420220f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	lcr3(boot_cr3);
  8004202213:	48 b8 78 2d 22 04 80 	movabs $0x8004222d78,%rax
  800420221a:	00 00 00 
  800420221d:	48 8b 00             	mov    (%rax),%rax
  8004202220:	48 89 45 98          	mov    %rax,-0x68(%rbp)
}

static __inline void
lcr3(uint64_t val)
{
	__asm __volatile("movq %0,%%cr3" : : "r" (val));
  8004202224:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004202228:	0f 22 d8             	mov    %rax,%cr3
}
  800420222b:	c9                   	leaveq 
  800420222c:	c3                   	retq   

000000800420222d <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
  800420222d:	55                   	push   %rbp
  800420222e:	48 89 e5             	mov    %rsp,%rbp
  8004202231:	53                   	push   %rbx
  8004202232:	48 83 ec 28          	sub    $0x28,%rsp
	// free pages!
	// NB: Make sure you preserve the direction in which your page_free_list 
	// is constructed
	// NB: Remember to mark the memory used for initial boot page table i.e (va>=BOOT_PAGE_TABLE_START && va < BOOT_PAGE_TABLE_END) as in-use (not free)
	size_t i;
	struct PageInfo* last = NULL;
  8004202236:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  800420223d:	00 
	char*  first_free_page = (char *) boot_alloc(0);
  800420223e:	bf 00 00 00 00       	mov    $0x0,%edi
  8004202243:	48 b8 e0 1c 20 04 80 	movabs $0x8004201ce0,%rax
  800420224a:	00 00 00 
  800420224d:	ff d0                	callq  *%rax
  800420224f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	for (i = 0; i < npages; i++) {
  8004202253:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800420225a:	00 
  800420225b:	e9 b8 01 00 00       	jmpq   8004202418 <page_init+0x1eb>
		if((i == 0) || (&pages[i] >= pa2page((physaddr_t)IOPHYSMEM) && (uintptr_t)page2kva(&pages[i]) < (uintptr_t)first_free_page)
  8004202260:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004202265:	0f 84 c0 00 00 00    	je     800420232b <page_init+0xfe>
  800420226b:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202272:	00 00 00 
  8004202275:	48 8b 00             	mov    (%rax),%rax
  8004202278:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420227c:	48 c1 e2 04          	shl    $0x4,%rdx
  8004202280:	48 8d 1c 10          	lea    (%rax,%rdx,1),%rbx
  8004202284:	bf 00 00 0a 00       	mov    $0xa0000,%edi
  8004202289:	48 b8 46 13 20 04 80 	movabs $0x8004201346,%rax
  8004202290:	00 00 00 
  8004202293:	ff d0                	callq  *%rax
  8004202295:	48 39 c3             	cmp    %rax,%rbx
  8004202298:	72 33                	jb     80042022cd <page_init+0xa0>
  800420229a:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042022a1:	00 00 00 
  80042022a4:	48 8b 00             	mov    (%rax),%rax
  80042022a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022ab:	48 c1 e2 04          	shl    $0x4,%rdx
  80042022af:	48 01 d0             	add    %rdx,%rax
  80042022b2:	48 89 c7             	mov    %rax,%rdi
  80042022b5:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  80042022bc:	00 00 00 
  80042022bf:	ff d0                	callq  *%rax
  80042022c1:	48 89 c2             	mov    %rax,%rdx
  80042022c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042022c8:	48 39 c2             	cmp    %rax,%rdx
  80042022cb:	72 5e                	jb     800420232b <page_init+0xfe>
			|| (&pages[i] >= pa2page((physaddr_t)0x8000) && &pages[i] < pa2page((physaddr_t)0xe000))){
  80042022cd:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042022d4:	00 00 00 
  80042022d7:	48 8b 00             	mov    (%rax),%rax
  80042022da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042022de:	48 c1 e2 04          	shl    $0x4,%rdx
  80042022e2:	48 8d 1c 10          	lea    (%rax,%rdx,1),%rbx
  80042022e6:	bf 00 80 00 00       	mov    $0x8000,%edi
  80042022eb:	48 b8 46 13 20 04 80 	movabs $0x8004201346,%rax
  80042022f2:	00 00 00 
  80042022f5:	ff d0                	callq  *%rax
  80042022f7:	48 39 c3             	cmp    %rax,%rbx
  80042022fa:	72 71                	jb     800420236d <page_init+0x140>
  80042022fc:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202303:	00 00 00 
  8004202306:	48 8b 00             	mov    (%rax),%rax
  8004202309:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420230d:	48 c1 e2 04          	shl    $0x4,%rdx
  8004202311:	48 8d 1c 10          	lea    (%rax,%rdx,1),%rbx
  8004202315:	bf 00 e0 00 00       	mov    $0xe000,%edi
  800420231a:	48 b8 46 13 20 04 80 	movabs $0x8004201346,%rax
  8004202321:	00 00 00 
  8004202324:	ff d0                	callq  *%rax
  8004202326:	48 39 c3             	cmp    %rax,%rbx
  8004202329:	73 42                	jae    800420236d <page_init+0x140>

			pages[i].pp_ref = 1;
  800420232b:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202332:	00 00 00 
  8004202335:	48 8b 00             	mov    (%rax),%rax
  8004202338:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420233c:	48 c1 e2 04          	shl    $0x4,%rdx
  8004202340:	48 01 d0             	add    %rdx,%rax
  8004202343:	66 c7 40 08 01 00    	movw   $0x1,0x8(%rax)
			pages[i].pp_link = NULL;
  8004202349:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202350:	00 00 00 
  8004202353:	48 8b 00             	mov    (%rax),%rax
  8004202356:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420235a:	48 c1 e2 04          	shl    $0x4,%rdx
  800420235e:	48 01 d0             	add    %rdx,%rax
  8004202361:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  8004202368:	e9 a6 00 00 00       	jmpq   8004202413 <page_init+0x1e6>
		}
		else
		{
			
			pages[i].pp_ref = 0;
  800420236d:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202374:	00 00 00 
  8004202377:	48 8b 00             	mov    (%rax),%rax
  800420237a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420237e:	48 c1 e2 04          	shl    $0x4,%rdx
  8004202382:	48 01 d0             	add    %rdx,%rax
  8004202385:	66 c7 40 08 00 00    	movw   $0x0,0x8(%rax)
			pages[i].pp_link = NULL;
  800420238b:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004202392:	00 00 00 
  8004202395:	48 8b 00             	mov    (%rax),%rax
  8004202398:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420239c:	48 c1 e2 04          	shl    $0x4,%rdx
  80042023a0:	48 01 d0             	add    %rdx,%rax
  80042023a3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			if(last)
  80042023aa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80042023af:	74 21                	je     80042023d2 <page_init+0x1a5>
				last->pp_link = &pages[i];
  80042023b1:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042023b8:	00 00 00 
  80042023bb:	48 8b 00             	mov    (%rax),%rax
  80042023be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042023c2:	48 c1 e2 04          	shl    $0x4,%rdx
  80042023c6:	48 01 c2             	add    %rax,%rdx
  80042023c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042023cd:	48 89 10             	mov    %rdx,(%rax)
  80042023d0:	eb 25                	jmp    80042023f7 <page_init+0x1ca>
			else
				page_free_list = &pages[i];
  80042023d2:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042023d9:	00 00 00 
  80042023dc:	48 8b 00             	mov    (%rax),%rax
  80042023df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042023e3:	48 c1 e2 04          	shl    $0x4,%rdx
  80042023e7:	48 01 c2             	add    %rax,%rdx
  80042023ea:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  80042023f1:	00 00 00 
  80042023f4:	48 89 10             	mov    %rdx,(%rax)
			
			last = &pages[i];
  80042023f7:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042023fe:	00 00 00 
  8004202401:	48 8b 00             	mov    (%rax),%rax
  8004202404:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004202408:	48 c1 e2 04          	shl    $0x4,%rdx
  800420240c:	48 01 d0             	add    %rdx,%rax
  800420240f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// is constructed
	// NB: Remember to mark the memory used for initial boot page table i.e (va>=BOOT_PAGE_TABLE_START && va < BOOT_PAGE_TABLE_END) as in-use (not free)
	size_t i;
	struct PageInfo* last = NULL;
	char*  first_free_page = (char *) boot_alloc(0);
	for (i = 0; i < npages; i++) {
  8004202413:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004202418:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  800420241f:	00 00 00 
  8004202422:	48 8b 00             	mov    (%rax),%rax
  8004202425:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8004202429:	0f 82 31 fe ff ff    	jb     8004202260 <page_init+0x33>
				page_free_list = &pages[i];
			
			last = &pages[i];
		}
	}
}
  800420242f:	48 83 c4 28          	add    $0x28,%rsp
  8004202433:	5b                   	pop    %rbx
  8004202434:	5d                   	pop    %rbp
  8004202435:	c3                   	retq   

0000008004202436 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
  8004202436:	55                   	push   %rbp
  8004202437:	48 89 e5             	mov    %rsp,%rbp
  800420243a:	48 83 ec 20          	sub    $0x20,%rsp
  800420243e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// Fill this function in
	struct PageInfo *newPage;
	newPage = page_free_list;
  8004202441:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004202448:	00 00 00 
  800420244b:	48 8b 00             	mov    (%rax),%rax
  800420244e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (newPage == NULL)
  8004202452:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004202457:	75 07                	jne    8004202460 <page_alloc+0x2a>
		return NULL;
  8004202459:	b8 00 00 00 00       	mov    $0x0,%eax
  800420245e:	eb 62                	jmp    80042024c2 <page_alloc+0x8c>
	else{
		
		if (alloc_flags & ALLOC_ZERO)
  8004202460:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8004202463:	83 e0 01             	and    $0x1,%eax
  8004202466:	85 c0                	test   %eax,%eax
  8004202468:	74 2c                	je     8004202496 <page_alloc+0x60>
			memset(page2kva(newPage), 0, PGSIZE);
  800420246a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420246e:	48 89 c7             	mov    %rax,%rdi
  8004202471:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  8004202478:	00 00 00 
  800420247b:	ff d0                	callq  *%rax
  800420247d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004202482:	be 00 00 00 00       	mov    $0x0,%esi
  8004202487:	48 89 c7             	mov    %rax,%rdi
  800420248a:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  8004202491:	00 00 00 
  8004202494:	ff d0                	callq  *%rax
		
		page_free_list = page_free_list->pp_link;
  8004202496:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  800420249d:	00 00 00 
  80042024a0:	48 8b 00             	mov    (%rax),%rax
  80042024a3:	48 8b 10             	mov    (%rax),%rdx
  80042024a6:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  80042024ad:	00 00 00 
  80042024b0:	48 89 10             	mov    %rdx,(%rax)
		newPage->pp_link = NULL;
  80042024b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042024b7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		return newPage;
  80042024be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}
}
  80042024c2:	c9                   	leaveq 
  80042024c3:	c3                   	retq   

00000080042024c4 <page_initpp>:
// The result has null links and 0 refcount.
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct PageInfo *pp)
{
  80042024c4:	55                   	push   %rbp
  80042024c5:	48 89 e5             	mov    %rsp,%rbp
  80042024c8:	48 83 ec 10          	sub    $0x10,%rsp
  80042024cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	memset(pp, 0, sizeof(*pp));
  80042024d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042024d4:	ba 10 00 00 00       	mov    $0x10,%edx
  80042024d9:	be 00 00 00 00       	mov    $0x0,%esi
  80042024de:	48 89 c7             	mov    %rax,%rdi
  80042024e1:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  80042024e8:	00 00 00 
  80042024eb:	ff d0                	callq  *%rax
}
  80042024ed:	c9                   	leaveq 
  80042024ee:	c3                   	retq   

00000080042024ef <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
  80042024ef:	55                   	push   %rbp
  80042024f0:	48 89 e5             	mov    %rsp,%rbp
  80042024f3:	48 83 ec 10          	sub    $0x10,%rsp
  80042024f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	if (pp->pp_ref != 0 || pp->pp_link != NULL)
  80042024fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042024ff:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004202503:	66 85 c0             	test   %ax,%ax
  8004202506:	75 0c                	jne    8004202514 <page_free+0x25>
  8004202508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420250c:	48 8b 00             	mov    (%rax),%rax
  800420250f:	48 85 c0             	test   %rax,%rax
  8004202512:	74 2a                	je     800420253e <page_free+0x4f>
		panic("we have problem");
  8004202514:	48 ba 0c e8 20 04 80 	movabs $0x800420e80c,%rdx
  800420251b:	00 00 00 
  800420251e:	be ad 01 00 00       	mov    $0x1ad,%esi
  8004202523:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420252a:	00 00 00 
  800420252d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202532:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004202539:	00 00 00 
  800420253c:	ff d1                	callq  *%rcx
	
	pp->pp_link = page_free_list;
  800420253e:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004202545:	00 00 00 
  8004202548:	48 8b 10             	mov    (%rax),%rdx
  800420254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420254f:	48 89 10             	mov    %rdx,(%rax)
	page_free_list = pp;
  8004202552:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004202559:	00 00 00 
  800420255c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004202560:	48 89 10             	mov    %rdx,(%rax)
}
  8004202563:	c9                   	leaveq 
  8004202564:	c3                   	retq   

0000008004202565 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
  8004202565:	55                   	push   %rbp
  8004202566:	48 89 e5             	mov    %rsp,%rbp
  8004202569:	48 83 ec 10          	sub    $0x10,%rsp
  800420256d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (--pp->pp_ref == 0)
  8004202571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202575:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004202579:	8d 50 ff             	lea    -0x1(%rax),%edx
  800420257c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202580:	66 89 50 08          	mov    %dx,0x8(%rax)
  8004202584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202588:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420258c:	66 85 c0             	test   %ax,%ax
  800420258f:	75 13                	jne    80042025a4 <page_decref+0x3f>
		page_free(pp);
  8004202591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202595:	48 89 c7             	mov    %rax,%rdi
  8004202598:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  800420259f:	00 00 00 
  80042025a2:	ff d0                	callq  *%rax
}
  80042025a4:	c9                   	leaveq 
  80042025a5:	c3                   	retq   

00000080042025a6 <pml4e_walk>:
// table, page directory,page directory pointer and pml4 entries.
//

pte_t *
pml4e_walk(pml4e_t *pml4e, const void *va, int create)
{
  80042025a6:	55                   	push   %rbp
  80042025a7:	48 89 e5             	mov    %rsp,%rbp
  80042025aa:	53                   	push   %rbx
  80042025ab:	48 83 ec 68          	sub    $0x68,%rsp
  80042025af:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80042025b3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80042025b7:	89 55 9c             	mov    %edx,-0x64(%rbp)
	pte_t *pte = NULL;
  80042025ba:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80042025c1:	00 
	pdpe_t *pdpe = NULL;
  80042025c2:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80042025c9:	00 
	

	if((pml4e[PML4(va)] & PTE_P))
  80042025ca:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042025ce:	48 c1 e8 27          	shr    $0x27,%rax
  80042025d2:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042025d7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042025de:	00 
  80042025df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042025e3:	48 01 d0             	add    %rdx,%rax
  80042025e6:	48 8b 00             	mov    (%rax),%rax
  80042025e9:	83 e0 01             	and    $0x1,%eax
  80042025ec:	48 85 c0             	test   %rax,%rax
  80042025ef:	0f 84 ba 00 00 00    	je     80042026af <pml4e_walk+0x109>
	{
		
		pdpe = (pdpe_t *) KADDR(PTE_ADDR(pml4e[PML4(va)]));
  80042025f5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042025f9:	48 c1 e8 27          	shr    $0x27,%rax
  80042025fd:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202602:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202609:	00 
  800420260a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420260e:	48 01 d0             	add    %rdx,%rax
  8004202611:	48 8b 00             	mov    (%rax),%rax
  8004202614:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800420261a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800420261e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202622:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202626:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  8004202629:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800420262c:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202633:	00 00 00 
  8004202636:	48 8b 00             	mov    (%rax),%rax
  8004202639:	48 39 c2             	cmp    %rax,%rdx
  800420263c:	72 32                	jb     8004202670 <pml4e_walk+0xca>
  800420263e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202642:	48 89 c1             	mov    %rax,%rcx
  8004202645:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  800420264c:	00 00 00 
  800420264f:	be e1 01 00 00       	mov    $0x1e1,%esi
  8004202654:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420265b:	00 00 00 
  800420265e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202663:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420266a:	00 00 00 
  800420266d:	41 ff d0             	callq  *%r8
  8004202670:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004202677:	00 00 00 
  800420267a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420267e:	48 01 d0             	add    %rdx,%rax
  8004202681:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		pte = pdpe_walk(pdpe, va, create);
  8004202685:	8b 55 9c             	mov    -0x64(%rbp),%edx
  8004202688:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800420268c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202690:	48 89 ce             	mov    %rcx,%rsi
  8004202693:	48 89 c7             	mov    %rax,%rdi
  8004202696:	48 b8 f4 27 20 04 80 	movabs $0x80042027f4,%rax
  800420269d:	00 00 00 
  80042026a0:	ff d0                	callq  *%rax
  80042026a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		return pte;
  80042026a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042026aa:	e9 3e 01 00 00       	jmpq   80042027ed <pml4e_walk+0x247>
	}
	else if(create)
  80042026af:	83 7d 9c 00          	cmpl   $0x0,-0x64(%rbp)
  80042026b3:	0f 84 2f 01 00 00    	je     80042027e8 <pml4e_walk+0x242>
	{
		struct PageInfo* newPDPT = page_alloc(ALLOC_ZERO);
  80042026b9:	bf 01 00 00 00       	mov    $0x1,%edi
  80042026be:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  80042026c5:	00 00 00 
  80042026c8:	ff d0                	callq  *%rax
  80042026ca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
		if (newPDPT == NULL)
  80042026ce:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042026d3:	75 0a                	jne    80042026df <pml4e_walk+0x139>
			return NULL;
  80042026d5:	b8 00 00 00 00       	mov    $0x0,%eax
  80042026da:	e9 0e 01 00 00       	jmpq   80042027ed <pml4e_walk+0x247>
		newPDPT->pp_ref++;	
  80042026df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042026e3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042026e7:	8d 50 01             	lea    0x1(%rax),%edx
  80042026ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042026ee:	66 89 50 08          	mov    %dx,0x8(%rax)

		pml4e[PML4(va)] = (page2pa(newPDPT) & ~0xFFF) | PTE_USER;
  80042026f2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042026f6:	48 c1 e8 27          	shr    $0x27,%rax
  80042026fa:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042026ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202706:	00 
  8004202707:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420270b:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  800420270f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202713:	48 89 c7             	mov    %rax,%rdi
  8004202716:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420271d:	00 00 00 
  8004202720:	ff d0                	callq  *%rax
  8004202722:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202728:	48 0d 07 0e 00 00    	or     $0xe07,%rax
  800420272e:	48 89 03             	mov    %rax,(%rbx)
		pdpe = (pdpe_t *) KADDR(PTE_ADDR(pml4e[PML4(va)]));
  8004202731:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004202735:	48 c1 e8 27          	shr    $0x27,%rax
  8004202739:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420273e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202745:	00 
  8004202746:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420274a:	48 01 d0             	add    %rdx,%rax
  800420274d:	48 8b 00             	mov    (%rax),%rax
  8004202750:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202756:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800420275a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420275e:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202762:	89 45 bc             	mov    %eax,-0x44(%rbp)
  8004202765:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8004202768:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  800420276f:	00 00 00 
  8004202772:	48 8b 00             	mov    (%rax),%rax
  8004202775:	48 39 c2             	cmp    %rax,%rdx
  8004202778:	72 32                	jb     80042027ac <pml4e_walk+0x206>
  800420277a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420277e:	48 89 c1             	mov    %rax,%rcx
  8004202781:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004202788:	00 00 00 
  800420278b:	be ed 01 00 00       	mov    $0x1ed,%esi
  8004202790:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004202797:	00 00 00 
  800420279a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420279f:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042027a6:	00 00 00 
  80042027a9:	41 ff d0             	callq  *%r8
  80042027ac:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042027b3:	00 00 00 
  80042027b6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042027ba:	48 01 d0             	add    %rdx,%rax
  80042027bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		pte = pdpe_walk(pdpe, va, create);
  80042027c1:	8b 55 9c             	mov    -0x64(%rbp),%edx
  80042027c4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042027c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042027cc:	48 89 ce             	mov    %rcx,%rsi
  80042027cf:	48 89 c7             	mov    %rax,%rdi
  80042027d2:	48 b8 f4 27 20 04 80 	movabs $0x80042027f4,%rax
  80042027d9:	00 00 00 
  80042027dc:	ff d0                	callq  *%rax
  80042027de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		
		return pte;
  80042027e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042027e6:	eb 05                	jmp    80042027ed <pml4e_walk+0x247>
	}
	else
		return NULL;
  80042027e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042027ed:	48 83 c4 68          	add    $0x68,%rsp
  80042027f1:	5b                   	pop    %rbx
  80042027f2:	5d                   	pop    %rbp
  80042027f3:	c3                   	retq   

00000080042027f4 <pdpe_walk>:
// Given a pdpe i.e page directory pointer pdpe_walk returns the pointer to page table entry
// The programming logic in this function is similar to pml4e_walk.
// It calls the pgdir_walk which returns the page_table entry pointer.
// Hints are the same as in pml4e_walk
pte_t *
pdpe_walk(pdpe_t *pdpe,const void *va,int create){
  80042027f4:	55                   	push   %rbp
  80042027f5:	48 89 e5             	mov    %rsp,%rbp
  80042027f8:	53                   	push   %rbx
  80042027f9:	48 83 ec 68          	sub    $0x68,%rsp
  80042027fd:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8004202801:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8004202805:	89 55 9c             	mov    %edx,-0x64(%rbp)

	pte_t *pte = NULL;
  8004202808:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800420280f:	00 
	pde_t *pde = NULL;
  8004202810:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8004202817:	00 
	
	
	if((pdpe[PDPE(va)] & PTE_P))
  8004202818:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420281c:	48 c1 e8 1e          	shr    $0x1e,%rax
  8004202820:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202825:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420282c:	00 
  800420282d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202831:	48 01 d0             	add    %rdx,%rax
  8004202834:	48 8b 00             	mov    (%rax),%rax
  8004202837:	83 e0 01             	and    $0x1,%eax
  800420283a:	48 85 c0             	test   %rax,%rax
  800420283d:	0f 84 ba 00 00 00    	je     80042028fd <pdpe_walk+0x109>
	{
		pde = (pde_t *) KADDR(PTE_ADDR(pdpe[PDPE(va)]));
  8004202843:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004202847:	48 c1 e8 1e          	shr    $0x1e,%rax
  800420284b:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202850:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202857:	00 
  8004202858:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420285c:	48 01 d0             	add    %rdx,%rax
  800420285f:	48 8b 00             	mov    (%rax),%rax
  8004202862:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202868:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800420286c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202870:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202874:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  8004202877:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800420287a:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202881:	00 00 00 
  8004202884:	48 8b 00             	mov    (%rax),%rax
  8004202887:	48 39 c2             	cmp    %rax,%rdx
  800420288a:	72 32                	jb     80042028be <pdpe_walk+0xca>
  800420288c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202890:	48 89 c1             	mov    %rax,%rcx
  8004202893:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  800420289a:	00 00 00 
  800420289d:	be 04 02 00 00       	mov    $0x204,%esi
  80042028a2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042028a9:	00 00 00 
  80042028ac:	b8 00 00 00 00       	mov    $0x0,%eax
  80042028b1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042028b8:	00 00 00 
  80042028bb:	41 ff d0             	callq  *%r8
  80042028be:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042028c5:	00 00 00 
  80042028c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042028cc:	48 01 d0             	add    %rdx,%rax
  80042028cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		pte = pgdir_walk(pde, va, create);
  80042028d3:	8b 55 9c             	mov    -0x64(%rbp),%edx
  80042028d6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042028da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042028de:	48 89 ce             	mov    %rcx,%rsi
  80042028e1:	48 89 c7             	mov    %rax,%rdi
  80042028e4:	48 b8 42 2a 20 04 80 	movabs $0x8004202a42,%rax
  80042028eb:	00 00 00 
  80042028ee:	ff d0                	callq  *%rax
  80042028f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		return pte;
  80042028f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042028f8:	e9 3e 01 00 00       	jmpq   8004202a3b <pdpe_walk+0x247>
	}
	else if(create)
  80042028fd:	83 7d 9c 00          	cmpl   $0x0,-0x64(%rbp)
  8004202901:	0f 84 2f 01 00 00    	je     8004202a36 <pdpe_walk+0x242>
	{
		struct PageInfo* newPDT = page_alloc(ALLOC_ZERO);
  8004202907:	bf 01 00 00 00       	mov    $0x1,%edi
  800420290c:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004202913:	00 00 00 
  8004202916:	ff d0                	callq  *%rax
  8004202918:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
		if (newPDT == NULL)
  800420291c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004202921:	75 0a                	jne    800420292d <pdpe_walk+0x139>
			return NULL;
  8004202923:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202928:	e9 0e 01 00 00       	jmpq   8004202a3b <pdpe_walk+0x247>
		newPDT->pp_ref++;	
  800420292d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202931:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004202935:	8d 50 01             	lea    0x1(%rax),%edx
  8004202938:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420293c:	66 89 50 08          	mov    %dx,0x8(%rax)
		
		pdpe[PDPE(va)] = (page2pa(newPDT) & ~0xFFF) | PTE_USER;
  8004202940:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004202944:	48 c1 e8 1e          	shr    $0x1e,%rax
  8004202948:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420294d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202954:	00 
  8004202955:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202959:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  800420295d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202961:	48 89 c7             	mov    %rax,%rdi
  8004202964:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420296b:	00 00 00 
  800420296e:	ff d0                	callq  *%rax
  8004202970:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202976:	48 0d 07 0e 00 00    	or     $0xe07,%rax
  800420297c:	48 89 03             	mov    %rax,(%rbx)
		pde = (pde_t *) KADDR(PTE_ADDR(pdpe[PDPE(va)]));
  800420297f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004202983:	48 c1 e8 1e          	shr    $0x1e,%rax
  8004202987:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420298c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202993:	00 
  8004202994:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004202998:	48 01 d0             	add    %rdx,%rax
  800420299b:	48 8b 00             	mov    (%rax),%rax
  800420299e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80042029a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80042029a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042029ac:	48 c1 e8 0c          	shr    $0xc,%rax
  80042029b0:	89 45 bc             	mov    %eax,-0x44(%rbp)
  80042029b3:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80042029b6:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042029bd:	00 00 00 
  80042029c0:	48 8b 00             	mov    (%rax),%rax
  80042029c3:	48 39 c2             	cmp    %rax,%rdx
  80042029c6:	72 32                	jb     80042029fa <pdpe_walk+0x206>
  80042029c8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042029cc:	48 89 c1             	mov    %rax,%rcx
  80042029cf:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  80042029d6:	00 00 00 
  80042029d9:	be 10 02 00 00       	mov    $0x210,%esi
  80042029de:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042029e5:	00 00 00 
  80042029e8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042029ed:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042029f4:	00 00 00 
  80042029f7:	41 ff d0             	callq  *%r8
  80042029fa:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004202a01:	00 00 00 
  8004202a04:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004202a08:	48 01 d0             	add    %rdx,%rax
  8004202a0b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		
		pte = pgdir_walk(pde, va, create);
  8004202a0f:	8b 55 9c             	mov    -0x64(%rbp),%edx
  8004202a12:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004202a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202a1a:	48 89 ce             	mov    %rcx,%rsi
  8004202a1d:	48 89 c7             	mov    %rax,%rdi
  8004202a20:	48 b8 42 2a 20 04 80 	movabs $0x8004202a42,%rax
  8004202a27:	00 00 00 
  8004202a2a:	ff d0                	callq  *%rax
  8004202a2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		
		return pte;
  8004202a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202a34:	eb 05                	jmp    8004202a3b <pdpe_walk+0x247>
	}
	else
		return NULL;
  8004202a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202a3b:	48 83 c4 68          	add    $0x68,%rsp
  8004202a3f:	5b                   	pop    %rbx
  8004202a40:	5d                   	pop    %rbp
  8004202a41:	c3                   	retq   

0000008004202a42 <pgdir_walk>:
// The logic here is slightly different, in that it needs to look
// not just at the page directory, but also get the last-level page table entry.

pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
  8004202a42:	55                   	push   %rbp
  8004202a43:	48 89 e5             	mov    %rsp,%rbp
  8004202a46:	53                   	push   %rbx
  8004202a47:	48 83 ec 58          	sub    $0x58,%rsp
  8004202a4b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8004202a4f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8004202a53:	89 55 ac             	mov    %edx,-0x54(%rbp)
	// Fill this function in
	pte_t *pte = NULL;
  8004202a56:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004202a5d:	00 
	
	
	if((pgdir[PDX(va)] & PTE_P))
  8004202a5e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202a62:	48 c1 e8 15          	shr    $0x15,%rax
  8004202a66:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202a6b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202a72:	00 
  8004202a73:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004202a77:	48 01 d0             	add    %rdx,%rax
  8004202a7a:	48 8b 00             	mov    (%rax),%rax
  8004202a7d:	83 e0 01             	and    $0x1,%eax
  8004202a80:	48 85 c0             	test   %rax,%rax
  8004202a83:	0f 84 b0 00 00 00    	je     8004202b39 <pgdir_walk+0xf7>
	{
		pte = (pte_t*)KADDR((PTE_ADDR(pgdir[PDX(va)]) & ~0xFFF) + PTX(va)*8);
  8004202a89:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202a8d:	48 c1 e8 15          	shr    $0x15,%rax
  8004202a91:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202a96:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202a9d:	00 
  8004202a9e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004202aa2:	48 01 d0             	add    %rdx,%rax
  8004202aa5:	48 8b 00             	mov    (%rax),%rax
  8004202aa8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202aae:	48 89 c2             	mov    %rax,%rdx
  8004202ab1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202ab5:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202ab9:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202abe:	48 c1 e0 03          	shl    $0x3,%rax
  8004202ac2:	48 01 d0             	add    %rdx,%rax
  8004202ac5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004202ac9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202acd:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202ad1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8004202ad4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004202ad7:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202ade:	00 00 00 
  8004202ae1:	48 8b 00             	mov    (%rax),%rax
  8004202ae4:	48 39 c2             	cmp    %rax,%rdx
  8004202ae7:	72 32                	jb     8004202b1b <pgdir_walk+0xd9>
  8004202ae9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202aed:	48 89 c1             	mov    %rax,%rcx
  8004202af0:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004202af7:	00 00 00 
  8004202afa:	be 2a 02 00 00       	mov    $0x22a,%esi
  8004202aff:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004202b06:	00 00 00 
  8004202b09:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202b0e:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004202b15:	00 00 00 
  8004202b18:	41 ff d0             	callq  *%r8
  8004202b1b:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004202b22:	00 00 00 
  8004202b25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202b29:	48 01 d0             	add    %rdx,%rax
  8004202b2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		return pte;
  8004202b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202b34:	e9 34 01 00 00       	jmpq   8004202c6d <pgdir_walk+0x22b>
	}
	else if(create)
  8004202b39:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004202b3d:	0f 84 25 01 00 00    	je     8004202c68 <pgdir_walk+0x226>
	{
		struct PageInfo* newPT = page_alloc(ALLOC_ZERO);
  8004202b43:	bf 01 00 00 00       	mov    $0x1,%edi
  8004202b48:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004202b4f:	00 00 00 
  8004202b52:	ff d0                	callq  *%rax
  8004202b54:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if (newPT == NULL)
  8004202b58:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004202b5d:	75 0a                	jne    8004202b69 <pgdir_walk+0x127>
			return NULL;
  8004202b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202b64:	e9 04 01 00 00       	jmpq   8004202c6d <pgdir_walk+0x22b>
		newPT->pp_ref++;	
  8004202b69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202b6d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004202b71:	8d 50 01             	lea    0x1(%rax),%edx
  8004202b74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202b78:	66 89 50 08          	mov    %dx,0x8(%rax)
		
		pgdir[PDX(va)] = (page2pa(newPT) & ~0xFFF) | PTE_USER;
  8004202b7c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202b80:	48 c1 e8 15          	shr    $0x15,%rax
  8004202b84:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202b89:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202b90:	00 
  8004202b91:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004202b95:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  8004202b99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202b9d:	48 89 c7             	mov    %rax,%rdi
  8004202ba0:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004202ba7:	00 00 00 
  8004202baa:	ff d0                	callq  *%rax
  8004202bac:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202bb2:	48 0d 07 0e 00 00    	or     $0xe07,%rax
  8004202bb8:	48 89 03             	mov    %rax,(%rbx)
		pte = (pte_t*)KADDR((PTE_ADDR(pgdir[PDX(va)]) & ~0xFFF) + PTX(va)*8);
  8004202bbb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202bbf:	48 c1 e8 15          	shr    $0x15,%rax
  8004202bc3:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202bc8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004202bcf:	00 
  8004202bd0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004202bd4:	48 01 d0             	add    %rdx,%rax
  8004202bd7:	48 8b 00             	mov    (%rax),%rax
  8004202bda:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202be0:	48 89 c2             	mov    %rax,%rdx
  8004202be3:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202be7:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202beb:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202bf0:	48 c1 e0 03          	shl    $0x3,%rax
  8004202bf4:	48 01 d0             	add    %rdx,%rax
  8004202bf7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8004202bfb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202bff:	48 c1 e8 0c          	shr    $0xc,%rax
  8004202c03:	89 45 c4             	mov    %eax,-0x3c(%rbp)
  8004202c06:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004202c09:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004202c10:	00 00 00 
  8004202c13:	48 8b 00             	mov    (%rax),%rax
  8004202c16:	48 39 c2             	cmp    %rax,%rdx
  8004202c19:	72 32                	jb     8004202c4d <pgdir_walk+0x20b>
  8004202c1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202c1f:	48 89 c1             	mov    %rax,%rcx
  8004202c22:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004202c29:	00 00 00 
  8004202c2c:	be 35 02 00 00       	mov    $0x235,%esi
  8004202c31:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004202c38:	00 00 00 
  8004202c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202c40:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004202c47:	00 00 00 
  8004202c4a:	41 ff d0             	callq  *%r8
  8004202c4d:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004202c54:	00 00 00 
  8004202c57:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202c5b:	48 01 d0             	add    %rdx,%rax
  8004202c5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		return pte;
  8004202c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202c66:	eb 05                	jmp    8004202c6d <pgdir_walk+0x22b>
	}
	else
		return NULL;
  8004202c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202c6d:	48 83 c4 58          	add    $0x58,%rsp
  8004202c71:	5b                   	pop    %rbx
  8004202c72:	5d                   	pop    %rbp
  8004202c73:	c3                   	retq   

0000008004202c74 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pml4e_walk
static void
boot_map_region(pml4e_t *pml4e, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
  8004202c74:	55                   	push   %rbp
  8004202c75:	48 89 e5             	mov    %rsp,%rbp
  8004202c78:	48 83 ec 60          	sub    $0x60,%rsp
  8004202c7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8004202c80:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8004202c84:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8004202c88:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  8004202c8c:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
	// Fill this function in
	uintptr_t top = ROUNDUP(la + size, PGSIZE);
  8004202c90:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8004202c97:	00 
  8004202c98:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004202c9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004202ca0:	48 01 c2             	add    %rax,%rdx
  8004202ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ca7:	48 01 d0             	add    %rdx,%rax
  8004202caa:	48 83 e8 01          	sub    $0x1,%rax
  8004202cae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004202cb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004202cbb:	48 f7 75 e8          	divq   -0x18(%rbp)
  8004202cbf:	48 89 d0             	mov    %rdx,%rax
  8004202cc2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202cc6:	48 29 c2             	sub    %rax,%rdx
  8004202cc9:	48 89 d0             	mov    %rdx,%rax
  8004202ccc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	char *vaTemp, *paTemp;
	for(vaTemp = (char*)la, paTemp = (char*)pa; (uintptr_t)vaTemp < top; vaTemp+=PGSIZE, paTemp+=PGSIZE)
  8004202cd0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004202cd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004202cd8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004202cdc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8004202ce0:	eb 4e                	jmp    8004202d30 <boot_map_region+0xbc>
	{
		pte_t *pte = pml4e_walk(pml4e, (char*)vaTemp, 1);
  8004202ce2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004202ce6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202cea:	ba 01 00 00 00       	mov    $0x1,%edx
  8004202cef:	48 89 ce             	mov    %rcx,%rsi
  8004202cf2:	48 89 c7             	mov    %rax,%rdi
  8004202cf5:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004202cfc:	00 00 00 
  8004202cff:	ff d0                	callq  *%rax
  8004202d01:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		*pte = (uintptr_t)paTemp | perm | PTE_P;
  8004202d05:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8004202d08:	48 63 d0             	movslq %eax,%rdx
  8004202d0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202d0f:	48 09 d0             	or     %rdx,%rax
  8004202d12:	48 83 c8 01          	or     $0x1,%rax
  8004202d16:	48 89 c2             	mov    %rax,%rdx
  8004202d19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202d1d:	48 89 10             	mov    %rdx,(%rax)
boot_map_region(pml4e_t *pml4e, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
	// Fill this function in
	uintptr_t top = ROUNDUP(la + size, PGSIZE);
	char *vaTemp, *paTemp;
	for(vaTemp = (char*)la, paTemp = (char*)pa; (uintptr_t)vaTemp < top; vaTemp+=PGSIZE, paTemp+=PGSIZE)
  8004202d20:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8004202d27:	00 
  8004202d28:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  8004202d2f:	00 
  8004202d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202d34:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004202d38:	72 a8                	jb     8004202ce2 <boot_map_region+0x6e>
	{
		pte_t *pte = pml4e_walk(pml4e, (char*)vaTemp, 1);
		*pte = (uintptr_t)paTemp | perm | PTE_P;
	}
}
  8004202d3a:	c9                   	leaveq 
  8004202d3b:	c3                   	retq   

0000008004202d3c <page_insert>:
// Hint: The TA solution is implemented using pml4e_walk, page_remove,
// and page2pa.
//
int
page_insert(pml4e_t *pml4e, struct PageInfo *pp, void *va, int perm)
{
  8004202d3c:	55                   	push   %rbp
  8004202d3d:	48 89 e5             	mov    %rsp,%rbp
  8004202d40:	48 83 ec 30          	sub    $0x30,%rsp
  8004202d44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202d48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202d4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004202d50:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
	// Fill this function in
	pte_t *pte = pml4e_walk(pml4e, va, 1);
  8004202d53:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004202d57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d5b:	ba 01 00 00 00       	mov    $0x1,%edx
  8004202d60:	48 89 ce             	mov    %rcx,%rsi
  8004202d63:	48 89 c7             	mov    %rax,%rdi
  8004202d66:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004202d6d:	00 00 00 
  8004202d70:	ff d0                	callq  *%rax
  8004202d72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pte == NULL)
  8004202d76:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004202d7b:	75 07                	jne    8004202d84 <page_insert+0x48>
		return -E_NO_MEM;
  8004202d7d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8004202d82:	eb 6f                	jmp    8004202df3 <page_insert+0xb7>
	if (*pte & PTE_P)
  8004202d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202d88:	48 8b 00             	mov    (%rax),%rax
  8004202d8b:	83 e0 01             	and    $0x1,%eax
  8004202d8e:	48 85 c0             	test   %rax,%rax
  8004202d91:	74 1a                	je     8004202dad <page_insert+0x71>
		page_remove(pml4e, va);
  8004202d93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004202d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202d9b:	48 89 d6             	mov    %rdx,%rsi
  8004202d9e:	48 89 c7             	mov    %rax,%rdi
  8004202da1:	48 b8 89 2e 20 04 80 	movabs $0x8004202e89,%rax
  8004202da8:	00 00 00 
  8004202dab:	ff d0                	callq  *%rax
	
	pp->pp_ref++;
  8004202dad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202db1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004202db5:	8d 50 01             	lea    0x1(%rax),%edx
  8004202db8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202dbc:	66 89 50 08          	mov    %dx,0x8(%rax)
	*pte = (page2pa(pp) & ~0xFFF) | (perm|PTE_P);
  8004202dc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202dc4:	48 89 c7             	mov    %rax,%rdi
  8004202dc7:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004202dce:	00 00 00 
  8004202dd1:	ff d0                	callq  *%rax
  8004202dd3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202dd9:	48 89 c2             	mov    %rax,%rdx
  8004202ddc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004202ddf:	83 c8 01             	or     $0x1,%eax
  8004202de2:	48 98                	cltq   
  8004202de4:	48 09 c2             	or     %rax,%rdx
  8004202de7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202deb:	48 89 10             	mov    %rdx,(%rax)
	
	
	return 0;
  8004202dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004202df3:	c9                   	leaveq 
  8004202df4:	c3                   	retq   

0000008004202df5 <page_lookup>:
//
// Hint: the TA solution uses pml4e_walk and pa2page.
//
struct PageInfo *
page_lookup(pml4e_t *pml4e, void *va, pte_t **pte_store)
{
  8004202df5:	55                   	push   %rbp
  8004202df6:	48 89 e5             	mov    %rsp,%rbp
  8004202df9:	48 83 ec 40          	sub    $0x40,%rsp
  8004202dfd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004202e01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004202e05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// Fill this function in
	struct PageInfo *result;
	pte_t *pte = pml4e_walk(pml4e, va, 0);
  8004202e09:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8004202e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004202e11:	ba 00 00 00 00       	mov    $0x0,%edx
  8004202e16:	48 89 ce             	mov    %rcx,%rsi
  8004202e19:	48 89 c7             	mov    %rax,%rdi
  8004202e1c:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004202e23:	00 00 00 
  8004202e26:	ff d0                	callq  *%rax
  8004202e28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if(pte == NULL) 
  8004202e2c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004202e31:	75 07                	jne    8004202e3a <page_lookup+0x45>
		return NULL;
  8004202e33:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202e38:	eb 4d                	jmp    8004202e87 <page_lookup+0x92>
	
	physaddr_t pa = (physaddr_t)((*pte & ~0xFFF) + PGOFF(va));
  8004202e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202e3e:	48 8b 00             	mov    (%rax),%rax
  8004202e41:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004202e47:	48 89 c2             	mov    %rax,%rdx
  8004202e4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004202e4e:	25 ff 0f 00 00       	and    $0xfff,%eax
  8004202e53:	48 01 d0             	add    %rdx,%rax
  8004202e56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	result = pa2page(pa);
  8004202e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202e5e:	48 89 c7             	mov    %rax,%rdi
  8004202e61:	48 b8 46 13 20 04 80 	movabs $0x8004201346,%rax
  8004202e68:	00 00 00 
  8004202e6b:	ff d0                	callq  *%rax
  8004202e6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if(pte_store != NULL)
  8004202e71:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004202e76:	74 0b                	je     8004202e83 <page_lookup+0x8e>
		*pte_store = pte;
  8004202e78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004202e7c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004202e80:	48 89 10             	mov    %rdx,(%rax)
	return result;
  8004202e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004202e87:	c9                   	leaveq 
  8004202e88:	c3                   	retq   

0000008004202e89 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pml4e_t *pml4e, void *va)
{
  8004202e89:	55                   	push   %rbp
  8004202e8a:	48 89 e5             	mov    %rsp,%rbp
  8004202e8d:	48 83 ec 20          	sub    $0x20,%rsp
  8004202e91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202e95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Fill this function in
	struct PageInfo *PageRemove = page_lookup(pml4e, va, 0);
  8004202e99:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004202e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004202ea6:	48 89 ce             	mov    %rcx,%rsi
  8004202ea9:	48 89 c7             	mov    %rax,%rdi
  8004202eac:	48 b8 f5 2d 20 04 80 	movabs $0x8004202df5,%rax
  8004202eb3:	00 00 00 
  8004202eb6:	ff d0                	callq  *%rax
  8004202eb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if(PageRemove != NULL)
  8004202ebc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004202ec1:	74 62                	je     8004202f25 <page_remove+0x9c>
	{
		page_decref(PageRemove);
  8004202ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202ec7:	48 89 c7             	mov    %rax,%rdi
  8004202eca:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004202ed1:	00 00 00 
  8004202ed4:	ff d0                	callq  *%rax
		pte_t *pte = pml4e_walk(pml4e, va, 0);
  8004202ed6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004202eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202ede:	ba 00 00 00 00       	mov    $0x0,%edx
  8004202ee3:	48 89 ce             	mov    %rcx,%rsi
  8004202ee6:	48 89 c7             	mov    %rax,%rdi
  8004202ee9:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004202ef0:	00 00 00 
  8004202ef3:	ff d0                	callq  *%rax
  8004202ef5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (pte != NULL)
  8004202ef9:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8004202efe:	74 0b                	je     8004202f0b <page_remove+0x82>
			*pte = 0;
  8004202f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004202f04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		tlb_invalidate(pml4e, va);
  8004202f0b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004202f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004202f13:	48 89 d6             	mov    %rdx,%rsi
  8004202f16:	48 89 c7             	mov    %rax,%rdi
  8004202f19:	48 b8 27 2f 20 04 80 	movabs $0x8004202f27,%rax
  8004202f20:	00 00 00 
  8004202f23:	ff d0                	callq  *%rax
	}
}
  8004202f25:	c9                   	leaveq 
  8004202f26:	c3                   	retq   

0000008004202f27 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pml4e_t *pml4e, void *va)
{
  8004202f27:	55                   	push   %rbp
  8004202f28:	48 89 e5             	mov    %rsp,%rbp
  8004202f2b:	48 83 ec 20          	sub    $0x20,%rsp
  8004202f2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004202f33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004202f37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004202f3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
}

static __inline void 
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
  8004202f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202f43:	0f 01 38             	invlpg (%rax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
  8004202f46:	c9                   	leaveq 
  8004202f47:	c3                   	retq   

0000008004202f48 <check_page_free_list>:
// Check that the pages on the page_free_list are reasonable.
//

static void
check_page_free_list(bool only_low_memory)
{
  8004202f48:	55                   	push   %rbp
  8004202f49:	48 89 e5             	mov    %rsp,%rbp
  8004202f4c:	48 83 ec 60          	sub    $0x60,%rsp
  8004202f50:	89 f8                	mov    %edi,%eax
  8004202f52:	88 45 ac             	mov    %al,-0x54(%rbp)
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
  8004202f55:	80 7d ac 00          	cmpb   $0x0,-0x54(%rbp)
  8004202f59:	74 07                	je     8004202f62 <check_page_free_list+0x1a>
  8004202f5b:	b8 01 00 00 00       	mov    $0x1,%eax
  8004202f60:	eb 05                	jmp    8004202f67 <check_page_free_list+0x1f>
  8004202f62:	b8 00 02 00 00       	mov    $0x200,%eax
  8004202f67:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	uint64_t nfree_basemem = 0, nfree_extmem = 0;
  8004202f6a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004202f71:	00 
  8004202f72:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004202f79:	00 
	void *first_free_page;

	if (!page_free_list)
  8004202f7a:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004202f81:	00 00 00 
  8004202f84:	48 8b 00             	mov    (%rax),%rax
  8004202f87:	48 85 c0             	test   %rax,%rax
  8004202f8a:	75 2a                	jne    8004202fb6 <check_page_free_list+0x6e>
		panic("'page_free_list' is a null pointer!");
  8004202f8c:	48 ba 20 e8 20 04 80 	movabs $0x800420e820,%rdx
  8004202f93:	00 00 00 
  8004202f96:	be d4 02 00 00       	mov    $0x2d4,%esi
  8004202f9b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004202fa2:	00 00 00 
  8004202fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004202faa:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004202fb1:	00 00 00 
  8004202fb4:	ff d1                	callq  *%rcx

	if (only_low_memory) {
  8004202fb6:	80 7d ac 00          	cmpb   $0x0,-0x54(%rbp)
  8004202fba:	0f 84 a9 00 00 00    	je     8004203069 <check_page_free_list+0x121>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
  8004202fc0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004202fc4:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8004202fc8:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
  8004202fcc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
  8004202fd0:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004202fd7:	00 00 00 
  8004202fda:	48 8b 00             	mov    (%rax),%rax
  8004202fdd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004202fe1:	eb 58                	jmp    800420303b <check_page_free_list+0xf3>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
  8004202fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004202fe7:	48 89 c7             	mov    %rax,%rdi
  8004202fea:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004202ff1:	00 00 00 
  8004202ff4:	ff d0                	callq  *%rax
  8004202ff6:	48 c1 e8 15          	shr    $0x15,%rax
  8004202ffa:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004202fff:	48 89 c2             	mov    %rax,%rdx
  8004203002:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004203005:	48 39 c2             	cmp    %rax,%rdx
  8004203008:	0f 93 c0             	setae  %al
  800420300b:	0f b6 c0             	movzbl %al,%eax
  800420300e:	89 45 e0             	mov    %eax,-0x20(%rbp)
			*tp[pagetype] = pp;
  8004203011:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004203014:	48 98                	cltq   
  8004203016:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
  800420301b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420301f:	48 89 10             	mov    %rdx,(%rax)
			tp[pagetype] = &pp->pp_link;
  8004203022:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004203026:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004203029:	48 98                	cltq   
  800420302b:	48 89 54 c5 b0       	mov    %rdx,-0x50(%rbp,%rax,8)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
  8004203030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203034:	48 8b 00             	mov    (%rax),%rax
  8004203037:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420303b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203040:	75 a1                	jne    8004202fe3 <check_page_free_list+0x9b>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
  8004203042:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004203046:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		*tp[0] = pp2;
  800420304d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004203051:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004203055:	48 89 10             	mov    %rdx,(%rax)
		page_free_list = pp1;
  8004203058:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420305c:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004203063:	00 00 00 
  8004203066:	48 89 10             	mov    %rdx,(%rax)
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
  8004203069:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004203070:	00 00 00 
  8004203073:	48 8b 00             	mov    (%rax),%rax
  8004203076:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420307a:	eb 5e                	jmp    80042030da <check_page_free_list+0x192>
		if (PDX(page2pa(pp)) < pdx_limit)
  800420307c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203080:	48 89 c7             	mov    %rax,%rdi
  8004203083:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420308a:	00 00 00 
  800420308d:	ff d0                	callq  *%rax
  800420308f:	48 c1 e8 15          	shr    $0x15,%rax
  8004203093:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004203098:	48 89 c2             	mov    %rax,%rdx
  800420309b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420309e:	48 39 c2             	cmp    %rax,%rdx
  80042030a1:	73 2c                	jae    80042030cf <check_page_free_list+0x187>
			memset(page2kva(pp), 0x97, 128);
  80042030a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030a7:	48 89 c7             	mov    %rax,%rdi
  80042030aa:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  80042030b1:	00 00 00 
  80042030b4:	ff d0                	callq  *%rax
  80042030b6:	ba 80 00 00 00       	mov    $0x80,%edx
  80042030bb:	be 97 00 00 00       	mov    $0x97,%esi
  80042030c0:	48 89 c7             	mov    %rax,%rdi
  80042030c3:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  80042030ca:	00 00 00 
  80042030cd:	ff d0                	callq  *%rax
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
  80042030cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042030d3:	48 8b 00             	mov    (%rax),%rax
  80042030d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042030da:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042030df:	75 9b                	jne    800420307c <check_page_free_list+0x134>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = boot_alloc(0);
  80042030e1:	bf 00 00 00 00       	mov    $0x0,%edi
  80042030e6:	48 b8 e0 1c 20 04 80 	movabs $0x8004201ce0,%rax
  80042030ed:	00 00 00 
  80042030f0:	ff d0                	callq  *%rax
  80042030f2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
  80042030f6:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  80042030fd:	00 00 00 
  8004203100:	48 8b 00             	mov    (%rax),%rax
  8004203103:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203107:	e9 d0 02 00 00       	jmpq   80042033dc <check_page_free_list+0x494>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
  800420310c:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  8004203113:	00 00 00 
  8004203116:	48 8b 00             	mov    (%rax),%rax
  8004203119:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800420311d:	73 35                	jae    8004203154 <check_page_free_list+0x20c>
  800420311f:	48 b9 44 e8 20 04 80 	movabs $0x800420e844,%rcx
  8004203126:	00 00 00 
  8004203129:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203130:	00 00 00 
  8004203133:	be ee 02 00 00       	mov    $0x2ee,%esi
  8004203138:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420313f:	00 00 00 
  8004203142:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203147:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420314e:	00 00 00 
  8004203151:	41 ff d0             	callq  *%r8
		assert(pp < pages + npages);
  8004203154:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  800420315b:	00 00 00 
  800420315e:	48 8b 10             	mov    (%rax),%rdx
  8004203161:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004203168:	00 00 00 
  800420316b:	48 8b 00             	mov    (%rax),%rax
  800420316e:	48 c1 e0 04          	shl    $0x4,%rax
  8004203172:	48 01 d0             	add    %rdx,%rax
  8004203175:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004203179:	77 35                	ja     80042031b0 <check_page_free_list+0x268>
  800420317b:	48 b9 50 e8 20 04 80 	movabs $0x800420e850,%rcx
  8004203182:	00 00 00 
  8004203185:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420318c:	00 00 00 
  800420318f:	be ef 02 00 00       	mov    $0x2ef,%esi
  8004203194:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420319b:	00 00 00 
  800420319e:	b8 00 00 00 00       	mov    $0x0,%eax
  80042031a3:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042031aa:	00 00 00 
  80042031ad:	41 ff d0             	callq  *%r8
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
  80042031b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042031b4:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042031bb:	00 00 00 
  80042031be:	48 8b 00             	mov    (%rax),%rax
  80042031c1:	48 29 c2             	sub    %rax,%rdx
  80042031c4:	48 89 d0             	mov    %rdx,%rax
  80042031c7:	83 e0 0f             	and    $0xf,%eax
  80042031ca:	48 85 c0             	test   %rax,%rax
  80042031cd:	74 35                	je     8004203204 <check_page_free_list+0x2bc>
  80042031cf:	48 b9 68 e8 20 04 80 	movabs $0x800420e868,%rcx
  80042031d6:	00 00 00 
  80042031d9:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042031e0:	00 00 00 
  80042031e3:	be f0 02 00 00       	mov    $0x2f0,%esi
  80042031e8:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042031ef:	00 00 00 
  80042031f2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042031f7:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042031fe:	00 00 00 
  8004203201:	41 ff d0             	callq  *%r8

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
  8004203204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203208:	48 89 c7             	mov    %rax,%rdi
  800420320b:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004203212:	00 00 00 
  8004203215:	ff d0                	callq  *%rax
  8004203217:	48 85 c0             	test   %rax,%rax
  800420321a:	75 35                	jne    8004203251 <check_page_free_list+0x309>
  800420321c:	48 b9 9a e8 20 04 80 	movabs $0x800420e89a,%rcx
  8004203223:	00 00 00 
  8004203226:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420322d:	00 00 00 
  8004203230:	be f3 02 00 00       	mov    $0x2f3,%esi
  8004203235:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420323c:	00 00 00 
  800420323f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203244:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420324b:	00 00 00 
  800420324e:	41 ff d0             	callq  *%r8
		assert(page2pa(pp) != IOPHYSMEM);
  8004203251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203255:	48 89 c7             	mov    %rax,%rdi
  8004203258:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420325f:	00 00 00 
  8004203262:	ff d0                	callq  *%rax
  8004203264:	48 3d 00 00 0a 00    	cmp    $0xa0000,%rax
  800420326a:	75 35                	jne    80042032a1 <check_page_free_list+0x359>
  800420326c:	48 b9 ab e8 20 04 80 	movabs $0x800420e8ab,%rcx
  8004203273:	00 00 00 
  8004203276:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420327d:	00 00 00 
  8004203280:	be f4 02 00 00       	mov    $0x2f4,%esi
  8004203285:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420328c:	00 00 00 
  800420328f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203294:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420329b:	00 00 00 
  800420329e:	41 ff d0             	callq  *%r8
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
  80042032a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042032a5:	48 89 c7             	mov    %rax,%rdi
  80042032a8:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042032af:	00 00 00 
  80042032b2:	ff d0                	callq  *%rax
  80042032b4:	48 3d 00 f0 0f 00    	cmp    $0xff000,%rax
  80042032ba:	75 35                	jne    80042032f1 <check_page_free_list+0x3a9>
  80042032bc:	48 b9 c8 e8 20 04 80 	movabs $0x800420e8c8,%rcx
  80042032c3:	00 00 00 
  80042032c6:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042032cd:	00 00 00 
  80042032d0:	be f5 02 00 00       	mov    $0x2f5,%esi
  80042032d5:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042032dc:	00 00 00 
  80042032df:	b8 00 00 00 00       	mov    $0x0,%eax
  80042032e4:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042032eb:	00 00 00 
  80042032ee:	41 ff d0             	callq  *%r8
		assert(page2pa(pp) != EXTPHYSMEM);
  80042032f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042032f5:	48 89 c7             	mov    %rax,%rdi
  80042032f8:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042032ff:	00 00 00 
  8004203302:	ff d0                	callq  *%rax
  8004203304:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  800420330a:	75 35                	jne    8004203341 <check_page_free_list+0x3f9>
  800420330c:	48 b9 eb e8 20 04 80 	movabs $0x800420e8eb,%rcx
  8004203313:	00 00 00 
  8004203316:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420331d:	00 00 00 
  8004203320:	be f6 02 00 00       	mov    $0x2f6,%esi
  8004203325:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420332c:	00 00 00 
  800420332f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203334:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420333b:	00 00 00 
  800420333e:	41 ff d0             	callq  *%r8
		assert(page2pa(pp) < EXTPHYSMEM || page2kva(pp) >= first_free_page);
  8004203341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203345:	48 89 c7             	mov    %rax,%rdi
  8004203348:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420334f:	00 00 00 
  8004203352:	ff d0                	callq  *%rax
  8004203354:	48 3d ff ff 0f 00    	cmp    $0xfffff,%rax
  800420335a:	76 4e                	jbe    80042033aa <check_page_free_list+0x462>
  800420335c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203360:	48 89 c7             	mov    %rax,%rdi
  8004203363:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  800420336a:	00 00 00 
  800420336d:	ff d0                	callq  *%rax
  800420336f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004203373:	73 35                	jae    80042033aa <check_page_free_list+0x462>
  8004203375:	48 b9 08 e9 20 04 80 	movabs $0x800420e908,%rcx
  800420337c:	00 00 00 
  800420337f:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203386:	00 00 00 
  8004203389:	be f7 02 00 00       	mov    $0x2f7,%esi
  800420338e:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203395:	00 00 00 
  8004203398:	b8 00 00 00 00       	mov    $0x0,%eax
  800420339d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042033a4:	00 00 00 
  80042033a7:	41 ff d0             	callq  *%r8

		if (page2pa(pp) < EXTPHYSMEM)
  80042033aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042033ae:	48 89 c7             	mov    %rax,%rdi
  80042033b1:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042033b8:	00 00 00 
  80042033bb:	ff d0                	callq  *%rax
  80042033bd:	48 3d ff ff 0f 00    	cmp    $0xfffff,%rax
  80042033c3:	77 07                	ja     80042033cc <check_page_free_list+0x484>
			++nfree_basemem;
  80042033c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  80042033ca:	eb 05                	jmp    80042033d1 <check_page_free_list+0x489>
		else
			++nfree_extmem;
  80042033cc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
  80042033d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042033d5:	48 8b 00             	mov    (%rax),%rax
  80042033d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042033dc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042033e1:	0f 85 25 fd ff ff    	jne    800420310c <check_page_free_list+0x1c4>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_extmem > 0);
  80042033e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042033ec:	75 35                	jne    8004203423 <check_page_free_list+0x4db>
  80042033ee:	48 b9 44 e9 20 04 80 	movabs $0x800420e944,%rcx
  80042033f5:	00 00 00 
  80042033f8:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042033ff:	00 00 00 
  8004203402:	be ff 02 00 00       	mov    $0x2ff,%esi
  8004203407:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420340e:	00 00 00 
  8004203411:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203416:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420341d:	00 00 00 
  8004203420:	41 ff d0             	callq  *%r8
}
  8004203423:	c9                   	leaveq 
  8004203424:	c3                   	retq   

0000008004203425 <check_page_alloc>:
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc(void)
{
  8004203425:	55                   	push   %rbp
  8004203426:	48 89 e5             	mov    %rsp,%rbp
  8004203429:	48 83 ec 40          	sub    $0x40,%rsp
	int i;

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	for (pp0 = page_free_list, nfree = 0; pp0; pp0 = pp0->pp_link) {
  800420342d:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004203434:	00 00 00 
  8004203437:	48 8b 00             	mov    (%rax),%rax
  800420343a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420343e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8004203445:	eb 37                	jmp    800420347e <check_page_alloc+0x59>
		memset(page2kva(pp0), 0x97, PGSIZE);
  8004203447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420344b:	48 89 c7             	mov    %rax,%rdi
  800420344e:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  8004203455:	00 00 00 
  8004203458:	ff d0                	callq  *%rax
  800420345a:	ba 00 10 00 00       	mov    $0x1000,%edx
  800420345f:	be 97 00 00 00       	mov    $0x97,%esi
  8004203464:	48 89 c7             	mov    %rax,%rdi
  8004203467:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420346e:	00 00 00 
  8004203471:	ff d0                	callq  *%rax
	int i;

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	for (pp0 = page_free_list, nfree = 0; pp0; pp0 = pp0->pp_link) {
  8004203473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203477:	48 8b 00             	mov    (%rax),%rax
  800420347a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420347e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203483:	75 c2                	jne    8004203447 <check_page_alloc+0x22>
		memset(page2kva(pp0), 0x97, PGSIZE);
	}

	for (pp0 = page_free_list, nfree = 0; pp0; pp0 = pp0->pp_link) {
  8004203485:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  800420348c:	00 00 00 
  800420348f:	48 8b 00             	mov    (%rax),%rax
  8004203492:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  800420349d:	e9 ec 01 00 00       	jmpq   800420368e <check_page_alloc+0x269>
		// check that we didn't corrupt the free list itself
		assert(pp0 >= pages);
  80042034a2:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042034a9:	00 00 00 
  80042034ac:	48 8b 00             	mov    (%rax),%rax
  80042034af:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80042034b3:	73 35                	jae    80042034ea <check_page_alloc+0xc5>
  80042034b5:	48 b9 55 e9 20 04 80 	movabs $0x800420e955,%rcx
  80042034bc:	00 00 00 
  80042034bf:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042034c6:	00 00 00 
  80042034c9:	be 19 03 00 00       	mov    $0x319,%esi
  80042034ce:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042034d5:	00 00 00 
  80042034d8:	b8 00 00 00 00       	mov    $0x0,%eax
  80042034dd:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042034e4:	00 00 00 
  80042034e7:	41 ff d0             	callq  *%r8
		assert(pp0 < pages + npages);
  80042034ea:	48 b8 90 2d 22 04 80 	movabs $0x8004222d90,%rax
  80042034f1:	00 00 00 
  80042034f4:	48 8b 10             	mov    (%rax),%rdx
  80042034f7:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042034fe:	00 00 00 
  8004203501:	48 8b 00             	mov    (%rax),%rax
  8004203504:	48 c1 e0 04          	shl    $0x4,%rax
  8004203508:	48 01 d0             	add    %rdx,%rax
  800420350b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420350f:	77 35                	ja     8004203546 <check_page_alloc+0x121>
  8004203511:	48 b9 62 e9 20 04 80 	movabs $0x800420e962,%rcx
  8004203518:	00 00 00 
  800420351b:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203522:	00 00 00 
  8004203525:	be 1a 03 00 00       	mov    $0x31a,%esi
  800420352a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203531:	00 00 00 
  8004203534:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203539:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203540:	00 00 00 
  8004203543:	41 ff d0             	callq  *%r8

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp0) != 0);
  8004203546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420354a:	48 89 c7             	mov    %rax,%rdi
  800420354d:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004203554:	00 00 00 
  8004203557:	ff d0                	callq  *%rax
  8004203559:	48 85 c0             	test   %rax,%rax
  800420355c:	75 35                	jne    8004203593 <check_page_alloc+0x16e>
  800420355e:	48 b9 77 e9 20 04 80 	movabs $0x800420e977,%rcx
  8004203565:	00 00 00 
  8004203568:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420356f:	00 00 00 
  8004203572:	be 1d 03 00 00       	mov    $0x31d,%esi
  8004203577:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420357e:	00 00 00 
  8004203581:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203586:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420358d:	00 00 00 
  8004203590:	41 ff d0             	callq  *%r8
		assert(page2pa(pp0) != IOPHYSMEM);
  8004203593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203597:	48 89 c7             	mov    %rax,%rdi
  800420359a:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042035a1:	00 00 00 
  80042035a4:	ff d0                	callq  *%rax
  80042035a6:	48 3d 00 00 0a 00    	cmp    $0xa0000,%rax
  80042035ac:	75 35                	jne    80042035e3 <check_page_alloc+0x1be>
  80042035ae:	48 b9 89 e9 20 04 80 	movabs $0x800420e989,%rcx
  80042035b5:	00 00 00 
  80042035b8:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042035bf:	00 00 00 
  80042035c2:	be 1e 03 00 00       	mov    $0x31e,%esi
  80042035c7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042035ce:	00 00 00 
  80042035d1:	b8 00 00 00 00       	mov    $0x0,%eax
  80042035d6:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042035dd:	00 00 00 
  80042035e0:	41 ff d0             	callq  *%r8
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
  80042035e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042035e7:	48 89 c7             	mov    %rax,%rdi
  80042035ea:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042035f1:	00 00 00 
  80042035f4:	ff d0                	callq  *%rax
  80042035f6:	48 3d 00 f0 0f 00    	cmp    $0xff000,%rax
  80042035fc:	75 35                	jne    8004203633 <check_page_alloc+0x20e>
  80042035fe:	48 b9 a8 e9 20 04 80 	movabs $0x800420e9a8,%rcx
  8004203605:	00 00 00 
  8004203608:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420360f:	00 00 00 
  8004203612:	be 1f 03 00 00       	mov    $0x31f,%esi
  8004203617:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420361e:	00 00 00 
  8004203621:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203626:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420362d:	00 00 00 
  8004203630:	41 ff d0             	callq  *%r8
		assert(page2pa(pp0) != EXTPHYSMEM);
  8004203633:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203637:	48 89 c7             	mov    %rax,%rdi
  800420363a:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004203641:	00 00 00 
  8004203644:	ff d0                	callq  *%rax
  8004203646:	48 3d 00 00 10 00    	cmp    $0x100000,%rax
  800420364c:	75 35                	jne    8004203683 <check_page_alloc+0x25e>
  800420364e:	48 b9 cc e9 20 04 80 	movabs $0x800420e9cc,%rcx
  8004203655:	00 00 00 
  8004203658:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420365f:	00 00 00 
  8004203662:	be 20 03 00 00       	mov    $0x320,%esi
  8004203667:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420366e:	00 00 00 
  8004203671:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203676:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420367d:	00 00 00 
  8004203680:	41 ff d0             	callq  *%r8
	// eventually causes trouble.
	for (pp0 = page_free_list, nfree = 0; pp0; pp0 = pp0->pp_link) {
		memset(page2kva(pp0), 0x97, PGSIZE);
	}

	for (pp0 = page_free_list, nfree = 0; pp0; pp0 = pp0->pp_link) {
  8004203683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203687:	48 8b 00             	mov    (%rax),%rax
  800420368a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420368e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203693:	0f 85 09 fe ff ff    	jne    80042034a2 <check_page_alloc+0x7d>
		assert(page2pa(pp0) != IOPHYSMEM);
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp0) != EXTPHYSMEM);
	}
	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
  8004203699:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80042036a0:	00 
  80042036a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042036a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80042036a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042036ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert((pp0 = page_alloc(0)));
  80042036b1:	bf 00 00 00 00       	mov    $0x0,%edi
  80042036b6:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  80042036bd:	00 00 00 
  80042036c0:	ff d0                	callq  *%rax
  80042036c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042036c6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042036cb:	75 35                	jne    8004203702 <check_page_alloc+0x2dd>
  80042036cd:	48 b9 e7 e9 20 04 80 	movabs $0x800420e9e7,%rcx
  80042036d4:	00 00 00 
  80042036d7:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042036de:	00 00 00 
  80042036e1:	be 24 03 00 00       	mov    $0x324,%esi
  80042036e6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042036ed:	00 00 00 
  80042036f0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042036f5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042036fc:	00 00 00 
  80042036ff:	41 ff d0             	callq  *%r8
	assert((pp1 = page_alloc(0)));
  8004203702:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203707:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  800420370e:	00 00 00 
  8004203711:	ff d0                	callq  *%rax
  8004203713:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004203717:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800420371c:	75 35                	jne    8004203753 <check_page_alloc+0x32e>
  800420371e:	48 b9 fd e9 20 04 80 	movabs $0x800420e9fd,%rcx
  8004203725:	00 00 00 
  8004203728:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420372f:	00 00 00 
  8004203732:	be 25 03 00 00       	mov    $0x325,%esi
  8004203737:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420373e:	00 00 00 
  8004203741:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203746:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420374d:	00 00 00 
  8004203750:	41 ff d0             	callq  *%r8
	assert((pp2 = page_alloc(0)));
  8004203753:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203758:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  800420375f:	00 00 00 
  8004203762:	ff d0                	callq  *%rax
  8004203764:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8004203768:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420376d:	75 35                	jne    80042037a4 <check_page_alloc+0x37f>
  800420376f:	48 b9 13 ea 20 04 80 	movabs $0x800420ea13,%rcx
  8004203776:	00 00 00 
  8004203779:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203780:	00 00 00 
  8004203783:	be 26 03 00 00       	mov    $0x326,%esi
  8004203788:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420378f:	00 00 00 
  8004203792:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203797:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420379e:	00 00 00 
  80042037a1:	41 ff d0             	callq  *%r8
	assert(pp0);
  80042037a4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80042037a9:	75 35                	jne    80042037e0 <check_page_alloc+0x3bb>
  80042037ab:	48 b9 29 ea 20 04 80 	movabs $0x800420ea29,%rcx
  80042037b2:	00 00 00 
  80042037b5:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042037bc:	00 00 00 
  80042037bf:	be 27 03 00 00       	mov    $0x327,%esi
  80042037c4:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042037cb:	00 00 00 
  80042037ce:	b8 00 00 00 00       	mov    $0x0,%eax
  80042037d3:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042037da:	00 00 00 
  80042037dd:	41 ff d0             	callq  *%r8
	assert(pp1 && pp1 != pp0);
  80042037e0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80042037e5:	74 0a                	je     80042037f1 <check_page_alloc+0x3cc>
  80042037e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042037eb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80042037ef:	75 35                	jne    8004203826 <check_page_alloc+0x401>
  80042037f1:	48 b9 2d ea 20 04 80 	movabs $0x800420ea2d,%rcx
  80042037f8:	00 00 00 
  80042037fb:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203802:	00 00 00 
  8004203805:	be 28 03 00 00       	mov    $0x328,%esi
  800420380a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203811:	00 00 00 
  8004203814:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203819:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203820:	00 00 00 
  8004203823:	41 ff d0             	callq  *%r8
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
  8004203826:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420382b:	74 14                	je     8004203841 <check_page_alloc+0x41c>
  800420382d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203831:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203835:	74 0a                	je     8004203841 <check_page_alloc+0x41c>
  8004203837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420383b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420383f:	75 35                	jne    8004203876 <check_page_alloc+0x451>
  8004203841:	48 b9 40 ea 20 04 80 	movabs $0x800420ea40,%rcx
  8004203848:	00 00 00 
  800420384b:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203852:	00 00 00 
  8004203855:	be 29 03 00 00       	mov    $0x329,%esi
  800420385a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203861:	00 00 00 
  8004203864:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203869:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203870:	00 00 00 
  8004203873:	41 ff d0             	callq  *%r8
	assert(page2pa(pp0) < npages*PGSIZE);
  8004203876:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420387a:	48 89 c7             	mov    %rax,%rdi
  800420387d:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004203884:	00 00 00 
  8004203887:	ff d0                	callq  *%rax
  8004203889:	48 ba 88 2d 22 04 80 	movabs $0x8004222d88,%rdx
  8004203890:	00 00 00 
  8004203893:	48 8b 12             	mov    (%rdx),%rdx
  8004203896:	48 c1 e2 0c          	shl    $0xc,%rdx
  800420389a:	48 39 d0             	cmp    %rdx,%rax
  800420389d:	72 35                	jb     80042038d4 <check_page_alloc+0x4af>
  800420389f:	48 b9 60 ea 20 04 80 	movabs $0x800420ea60,%rcx
  80042038a6:	00 00 00 
  80042038a9:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042038b0:	00 00 00 
  80042038b3:	be 2a 03 00 00       	mov    $0x32a,%esi
  80042038b8:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042038bf:	00 00 00 
  80042038c2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042038c7:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042038ce:	00 00 00 
  80042038d1:	41 ff d0             	callq  *%r8
	assert(page2pa(pp1) < npages*PGSIZE);
  80042038d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042038d8:	48 89 c7             	mov    %rax,%rdi
  80042038db:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042038e2:	00 00 00 
  80042038e5:	ff d0                	callq  *%rax
  80042038e7:	48 ba 88 2d 22 04 80 	movabs $0x8004222d88,%rdx
  80042038ee:	00 00 00 
  80042038f1:	48 8b 12             	mov    (%rdx),%rdx
  80042038f4:	48 c1 e2 0c          	shl    $0xc,%rdx
  80042038f8:	48 39 d0             	cmp    %rdx,%rax
  80042038fb:	72 35                	jb     8004203932 <check_page_alloc+0x50d>
  80042038fd:	48 b9 7d ea 20 04 80 	movabs $0x800420ea7d,%rcx
  8004203904:	00 00 00 
  8004203907:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420390e:	00 00 00 
  8004203911:	be 2b 03 00 00       	mov    $0x32b,%esi
  8004203916:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420391d:	00 00 00 
  8004203920:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203925:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420392c:	00 00 00 
  800420392f:	41 ff d0             	callq  *%r8
	assert(page2pa(pp2) < npages*PGSIZE);
  8004203932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203936:	48 89 c7             	mov    %rax,%rdi
  8004203939:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004203940:	00 00 00 
  8004203943:	ff d0                	callq  *%rax
  8004203945:	48 ba 88 2d 22 04 80 	movabs $0x8004222d88,%rdx
  800420394c:	00 00 00 
  800420394f:	48 8b 12             	mov    (%rdx),%rdx
  8004203952:	48 c1 e2 0c          	shl    $0xc,%rdx
  8004203956:	48 39 d0             	cmp    %rdx,%rax
  8004203959:	72 35                	jb     8004203990 <check_page_alloc+0x56b>
  800420395b:	48 b9 9a ea 20 04 80 	movabs $0x800420ea9a,%rcx
  8004203962:	00 00 00 
  8004203965:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420396c:	00 00 00 
  800420396f:	be 2c 03 00 00       	mov    $0x32c,%esi
  8004203974:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420397b:	00 00 00 
  800420397e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203983:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420398a:	00 00 00 
  800420398d:	41 ff d0             	callq  *%r8

	// temporarily steal the rest of the free pages
	fl = page_free_list;
  8004203990:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004203997:	00 00 00 
  800420399a:	48 8b 00             	mov    (%rax),%rax
  800420399d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	page_free_list = 0;
  80042039a1:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  80042039a8:	00 00 00 
  80042039ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// should be no free memory
	assert(!page_alloc(0));
  80042039b2:	bf 00 00 00 00       	mov    $0x0,%edi
  80042039b7:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  80042039be:	00 00 00 
  80042039c1:	ff d0                	callq  *%rax
  80042039c3:	48 85 c0             	test   %rax,%rax
  80042039c6:	74 35                	je     80042039fd <check_page_alloc+0x5d8>
  80042039c8:	48 b9 b7 ea 20 04 80 	movabs $0x800420eab7,%rcx
  80042039cf:	00 00 00 
  80042039d2:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042039d9:	00 00 00 
  80042039dc:	be 33 03 00 00       	mov    $0x333,%esi
  80042039e1:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042039e8:	00 00 00 
  80042039eb:	b8 00 00 00 00       	mov    $0x0,%eax
  80042039f0:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042039f7:	00 00 00 
  80042039fa:	41 ff d0             	callq  *%r8

	// free and re-allocate?
	page_free(pp0);
  80042039fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203a01:	48 89 c7             	mov    %rax,%rdi
  8004203a04:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203a0b:	00 00 00 
  8004203a0e:	ff d0                	callq  *%rax
	page_free(pp1);
  8004203a10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203a14:	48 89 c7             	mov    %rax,%rdi
  8004203a17:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203a1e:	00 00 00 
  8004203a21:	ff d0                	callq  *%rax
	page_free(pp2);
  8004203a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203a27:	48 89 c7             	mov    %rax,%rdi
  8004203a2a:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203a31:	00 00 00 
  8004203a34:	ff d0                	callq  *%rax
	pp0 = pp1 = pp2 = 0;
  8004203a36:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004203a3d:	00 
  8004203a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004203a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert((pp0 = page_alloc(0)));
  8004203a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203a53:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004203a5a:	00 00 00 
  8004203a5d:	ff d0                	callq  *%rax
  8004203a5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004203a63:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203a68:	75 35                	jne    8004203a9f <check_page_alloc+0x67a>
  8004203a6a:	48 b9 e7 e9 20 04 80 	movabs $0x800420e9e7,%rcx
  8004203a71:	00 00 00 
  8004203a74:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203a7b:	00 00 00 
  8004203a7e:	be 3a 03 00 00       	mov    $0x33a,%esi
  8004203a83:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203a8a:	00 00 00 
  8004203a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203a92:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203a99:	00 00 00 
  8004203a9c:	41 ff d0             	callq  *%r8
	assert((pp1 = page_alloc(0)));
  8004203a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203aa4:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004203aab:	00 00 00 
  8004203aae:	ff d0                	callq  *%rax
  8004203ab0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004203ab4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004203ab9:	75 35                	jne    8004203af0 <check_page_alloc+0x6cb>
  8004203abb:	48 b9 fd e9 20 04 80 	movabs $0x800420e9fd,%rcx
  8004203ac2:	00 00 00 
  8004203ac5:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203acc:	00 00 00 
  8004203acf:	be 3b 03 00 00       	mov    $0x33b,%esi
  8004203ad4:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203adb:	00 00 00 
  8004203ade:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203ae3:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203aea:	00 00 00 
  8004203aed:	41 ff d0             	callq  *%r8
	assert((pp2 = page_alloc(0)));
  8004203af0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203af5:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004203afc:	00 00 00 
  8004203aff:	ff d0                	callq  *%rax
  8004203b01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8004203b05:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004203b0a:	75 35                	jne    8004203b41 <check_page_alloc+0x71c>
  8004203b0c:	48 b9 13 ea 20 04 80 	movabs $0x800420ea13,%rcx
  8004203b13:	00 00 00 
  8004203b16:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203b1d:	00 00 00 
  8004203b20:	be 3c 03 00 00       	mov    $0x33c,%esi
  8004203b25:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203b2c:	00 00 00 
  8004203b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203b34:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203b3b:	00 00 00 
  8004203b3e:	41 ff d0             	callq  *%r8
	assert(pp0);
  8004203b41:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004203b46:	75 35                	jne    8004203b7d <check_page_alloc+0x758>
  8004203b48:	48 b9 29 ea 20 04 80 	movabs $0x800420ea29,%rcx
  8004203b4f:	00 00 00 
  8004203b52:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203b59:	00 00 00 
  8004203b5c:	be 3d 03 00 00       	mov    $0x33d,%esi
  8004203b61:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203b68:	00 00 00 
  8004203b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203b70:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203b77:	00 00 00 
  8004203b7a:	41 ff d0             	callq  *%r8
	assert(pp1 && pp1 != pp0);
  8004203b7d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004203b82:	74 0a                	je     8004203b8e <check_page_alloc+0x769>
  8004203b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203b88:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004203b8c:	75 35                	jne    8004203bc3 <check_page_alloc+0x79e>
  8004203b8e:	48 b9 2d ea 20 04 80 	movabs $0x800420ea2d,%rcx
  8004203b95:	00 00 00 
  8004203b98:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203b9f:	00 00 00 
  8004203ba2:	be 3e 03 00 00       	mov    $0x33e,%esi
  8004203ba7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203bae:	00 00 00 
  8004203bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203bb6:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203bbd:	00 00 00 
  8004203bc0:	41 ff d0             	callq  *%r8
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
  8004203bc3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004203bc8:	74 14                	je     8004203bde <check_page_alloc+0x7b9>
  8004203bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203bce:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004203bd2:	74 0a                	je     8004203bde <check_page_alloc+0x7b9>
  8004203bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203bd8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004203bdc:	75 35                	jne    8004203c13 <check_page_alloc+0x7ee>
  8004203bde:	48 b9 40 ea 20 04 80 	movabs $0x800420ea40,%rcx
  8004203be5:	00 00 00 
  8004203be8:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203bef:	00 00 00 
  8004203bf2:	be 3f 03 00 00       	mov    $0x33f,%esi
  8004203bf7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203bfe:	00 00 00 
  8004203c01:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203c06:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203c0d:	00 00 00 
  8004203c10:	41 ff d0             	callq  *%r8
	assert(!page_alloc(0));
  8004203c13:	bf 00 00 00 00       	mov    $0x0,%edi
  8004203c18:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004203c1f:	00 00 00 
  8004203c22:	ff d0                	callq  *%rax
  8004203c24:	48 85 c0             	test   %rax,%rax
  8004203c27:	74 35                	je     8004203c5e <check_page_alloc+0x839>
  8004203c29:	48 b9 b7 ea 20 04 80 	movabs $0x800420eab7,%rcx
  8004203c30:	00 00 00 
  8004203c33:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203c3a:	00 00 00 
  8004203c3d:	be 40 03 00 00       	mov    $0x340,%esi
  8004203c42:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203c49:	00 00 00 
  8004203c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203c51:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203c58:	00 00 00 
  8004203c5b:	41 ff d0             	callq  *%r8

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
  8004203c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c62:	48 89 c7             	mov    %rax,%rdi
  8004203c65:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  8004203c6c:	00 00 00 
  8004203c6f:	ff d0                	callq  *%rax
  8004203c71:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004203c76:	be 01 00 00 00       	mov    $0x1,%esi
  8004203c7b:	48 89 c7             	mov    %rax,%rdi
  8004203c7e:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  8004203c85:	00 00 00 
  8004203c88:	ff d0                	callq  *%rax
	page_free(pp0);
  8004203c8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203c8e:	48 89 c7             	mov    %rax,%rdi
  8004203c91:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203c98:	00 00 00 
  8004203c9b:	ff d0                	callq  *%rax
	assert((pp = page_alloc(ALLOC_ZERO)));
  8004203c9d:	bf 01 00 00 00       	mov    $0x1,%edi
  8004203ca2:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004203ca9:	00 00 00 
  8004203cac:	ff d0                	callq  *%rax
  8004203cae:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004203cb2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004203cb7:	75 35                	jne    8004203cee <check_page_alloc+0x8c9>
  8004203cb9:	48 b9 c6 ea 20 04 80 	movabs $0x800420eac6,%rcx
  8004203cc0:	00 00 00 
  8004203cc3:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203cca:	00 00 00 
  8004203ccd:	be 45 03 00 00       	mov    $0x345,%esi
  8004203cd2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203cd9:	00 00 00 
  8004203cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203ce1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203ce8:	00 00 00 
  8004203ceb:	41 ff d0             	callq  *%r8
	assert(pp && pp0 == pp);
  8004203cee:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004203cf3:	74 0a                	je     8004203cff <check_page_alloc+0x8da>
  8004203cf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203cf9:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004203cfd:	74 35                	je     8004203d34 <check_page_alloc+0x90f>
  8004203cff:	48 b9 e4 ea 20 04 80 	movabs $0x800420eae4,%rcx
  8004203d06:	00 00 00 
  8004203d09:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203d10:	00 00 00 
  8004203d13:	be 46 03 00 00       	mov    $0x346,%esi
  8004203d18:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203d1f:	00 00 00 
  8004203d22:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203d27:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203d2e:	00 00 00 
  8004203d31:	41 ff d0             	callq  *%r8
	c = page2kva(pp);
  8004203d34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203d38:	48 89 c7             	mov    %rax,%rdi
  8004203d3b:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  8004203d42:	00 00 00 
  8004203d45:	ff d0                	callq  *%rax
  8004203d47:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	for (i = 0; i < PGSIZE; i++)
  8004203d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004203d52:	eb 4d                	jmp    8004203da1 <check_page_alloc+0x97c>
		assert(c[i] == 0);
  8004203d54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004203d57:	48 63 d0             	movslq %eax,%rdx
  8004203d5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004203d5e:	48 01 d0             	add    %rdx,%rax
  8004203d61:	0f b6 00             	movzbl (%rax),%eax
  8004203d64:	84 c0                	test   %al,%al
  8004203d66:	74 35                	je     8004203d9d <check_page_alloc+0x978>
  8004203d68:	48 b9 f4 ea 20 04 80 	movabs $0x800420eaf4,%rcx
  8004203d6f:	00 00 00 
  8004203d72:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203d79:	00 00 00 
  8004203d7c:	be 49 03 00 00       	mov    $0x349,%esi
  8004203d81:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203d88:	00 00 00 
  8004203d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203d90:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203d97:	00 00 00 
  8004203d9a:	41 ff d0             	callq  *%r8
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
  8004203d9d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004203da1:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%rbp)
  8004203da8:	7e aa                	jle    8004203d54 <check_page_alloc+0x92f>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
  8004203daa:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004203db1:	00 00 00 
  8004203db4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004203db8:	48 89 10             	mov    %rdx,(%rax)

	// free the pages we took
	page_free(pp0);
  8004203dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004203dbf:	48 89 c7             	mov    %rax,%rdi
  8004203dc2:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203dc9:	00 00 00 
  8004203dcc:	ff d0                	callq  *%rax
	page_free(pp1);
  8004203dce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203dd2:	48 89 c7             	mov    %rax,%rdi
  8004203dd5:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203ddc:	00 00 00 
  8004203ddf:	ff d0                	callq  *%rax
	page_free(pp2);
  8004203de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203de5:	48 89 c7             	mov    %rax,%rdi
  8004203de8:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004203def:	00 00 00 
  8004203df2:	ff d0                	callq  *%rax

	cprintf("check_page_alloc() succeeded!\n");
  8004203df4:	48 bf 00 eb 20 04 80 	movabs $0x800420eb00,%rdi
  8004203dfb:	00 00 00 
  8004203dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203e03:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004203e0a:	00 00 00 
  8004203e0d:	ff d2                	callq  *%rdx
}
  8004203e0f:	c9                   	leaveq 
  8004203e10:	c3                   	retq   

0000008004203e11 <check_boot_pml4e>:
// but it is a pretty good sanity check.
//

static void
check_boot_pml4e(pml4e_t *pml4e)
{
  8004203e11:	55                   	push   %rbp
  8004203e12:	48 89 e5             	mov    %rsp,%rbp
  8004203e15:	53                   	push   %rbx
  8004203e16:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  8004203e1d:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
	uint64_t i, n;

	pml4e = boot_pml4e;
  8004203e24:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004203e2b:	00 00 00 
  8004203e2e:	48 8b 00             	mov    (%rax),%rax
  8004203e31:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
  8004203e35:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  8004203e3c:	00 
  8004203e3d:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004203e44:	00 00 00 
  8004203e47:	48 8b 00             	mov    (%rax),%rax
  8004203e4a:	48 c1 e0 04          	shl    $0x4,%rax
  8004203e4e:	48 89 c2             	mov    %rax,%rdx
  8004203e51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004203e55:	48 01 d0             	add    %rdx,%rax
  8004203e58:	48 83 e8 01          	sub    $0x1,%rax
  8004203e5c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004203e60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004203e64:	ba 00 00 00 00       	mov    $0x0,%edx
  8004203e69:	48 f7 75 d8          	divq   -0x28(%rbp)
  8004203e6d:	48 89 d0             	mov    %rdx,%rax
  8004203e70:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004203e74:	48 29 c2             	sub    %rax,%rdx
  8004203e77:	48 89 d0             	mov    %rdx,%rax
  8004203e7a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	for (i = 0; i < n; i += PGSIZE) {
  8004203e7e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004203e85:	00 
  8004203e86:	e9 d4 00 00 00       	jmpq   8004203f5f <check_boot_pml4e+0x14e>
		// cprintf("%x %x %x\n",i,check_va2pa(pml4e, UPAGES + i), PADDR(pages) + i);
		assert(check_va2pa(pml4e, UPAGES + i) == PADDR(pages) + i);
  8004203e8b:	48 ba 00 00 a0 00 80 	movabs $0x8000a00000,%rdx
  8004203e92:	00 00 00 
  8004203e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203e99:	48 01 c2             	add    %rax,%rdx
  8004203e9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203ea0:	48 89 d6             	mov    %rdx,%rsi
  8004203ea3:	48 89 c7             	mov    %rax,%rdi
  8004203ea6:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004203ead:	00 00 00 
  8004203eb0:	ff d0                	callq  *%rax
  8004203eb2:	48 ba 90 2d 22 04 80 	movabs $0x8004222d90,%rdx
  8004203eb9:	00 00 00 
  8004203ebc:	48 8b 12             	mov    (%rdx),%rdx
  8004203ebf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004203ec3:	48 ba ff ff ff 03 80 	movabs $0x8003ffffff,%rdx
  8004203eca:	00 00 00 
  8004203ecd:	48 39 55 c0          	cmp    %rdx,-0x40(%rbp)
  8004203ed1:	77 32                	ja     8004203f05 <check_boot_pml4e+0xf4>
  8004203ed3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004203ed7:	48 89 c1             	mov    %rax,%rcx
  8004203eda:	48 ba e8 e7 20 04 80 	movabs $0x800420e7e8,%rdx
  8004203ee1:	00 00 00 
  8004203ee4:	be 69 03 00 00       	mov    $0x369,%esi
  8004203ee9:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203ef0:	00 00 00 
  8004203ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203ef8:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203eff:	00 00 00 
  8004203f02:	41 ff d0             	callq  *%r8
  8004203f05:	48 b9 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rcx
  8004203f0c:	ff ff ff 
  8004203f0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004203f13:	48 01 d1             	add    %rdx,%rcx
  8004203f16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004203f1a:	48 01 ca             	add    %rcx,%rdx
  8004203f1d:	48 39 d0             	cmp    %rdx,%rax
  8004203f20:	74 35                	je     8004203f57 <check_boot_pml4e+0x146>
  8004203f22:	48 b9 20 eb 20 04 80 	movabs $0x800420eb20,%rcx
  8004203f29:	00 00 00 
  8004203f2c:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203f33:	00 00 00 
  8004203f36:	be 69 03 00 00       	mov    $0x369,%esi
  8004203f3b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203f42:	00 00 00 
  8004203f45:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203f4a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203f51:	00 00 00 
  8004203f54:	41 ff d0             	callq  *%r8

	pml4e = boot_pml4e;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE) {
  8004203f57:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
  8004203f5e:	00 
  8004203f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f63:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004203f67:	0f 82 1e ff ff ff    	jb     8004203e8b <check_boot_pml4e+0x7a>
		assert(check_va2pa(pml4e, UPAGES + i) == PADDR(pages) + i);
	}


	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
  8004203f6d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004203f74:	00 
  8004203f75:	eb 6a                	jmp    8004203fe1 <check_boot_pml4e+0x1d0>
		assert(check_va2pa(pml4e, KERNBASE + i) == i);
  8004203f77:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004203f7e:	00 00 00 
  8004203f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004203f85:	48 01 c2             	add    %rax,%rdx
  8004203f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004203f8c:	48 89 d6             	mov    %rdx,%rsi
  8004203f8f:	48 89 c7             	mov    %rax,%rdi
  8004203f92:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004203f99:	00 00 00 
  8004203f9c:	ff d0                	callq  *%rax
  8004203f9e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004203fa2:	74 35                	je     8004203fd9 <check_boot_pml4e+0x1c8>
  8004203fa4:	48 b9 58 eb 20 04 80 	movabs $0x800420eb58,%rcx
  8004203fab:	00 00 00 
  8004203fae:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004203fb5:	00 00 00 
  8004203fb8:	be 6f 03 00 00       	mov    $0x36f,%esi
  8004203fbd:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004203fc4:	00 00 00 
  8004203fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004203fcc:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004203fd3:	00 00 00 
  8004203fd6:	41 ff d0             	callq  *%r8
		assert(check_va2pa(pml4e, UPAGES + i) == PADDR(pages) + i);
	}


	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
  8004203fd9:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
  8004203fe0:	00 
  8004203fe1:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004203fe8:	00 00 00 
  8004203feb:	48 8b 00             	mov    (%rax),%rax
  8004203fee:	48 c1 e0 0c          	shl    $0xc,%rax
  8004203ff2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004203ff6:	0f 87 7b ff ff ff    	ja     8004203f77 <check_boot_pml4e+0x166>
		assert(check_va2pa(pml4e, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE) {
  8004203ffc:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004204003:	00 
  8004204004:	e9 d1 00 00 00       	jmpq   80042040da <check_boot_pml4e+0x2c9>
		assert(check_va2pa(pml4e, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
  8004204009:	48 ba 00 00 ff 03 80 	movabs $0x8003ff0000,%rdx
  8004204010:	00 00 00 
  8004204013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204017:	48 01 c2             	add    %rax,%rdx
  800420401a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420401e:	48 89 d6             	mov    %rdx,%rsi
  8004204021:	48 89 c7             	mov    %rax,%rdi
  8004204024:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  800420402b:	00 00 00 
  800420402e:	ff d0                	callq  *%rax
  8004204030:	48 bb 00 20 21 04 80 	movabs $0x8004212000,%rbx
  8004204037:	00 00 00 
  800420403a:	48 89 5d b8          	mov    %rbx,-0x48(%rbp)
  800420403e:	48 ba ff ff ff 03 80 	movabs $0x8003ffffff,%rdx
  8004204045:	00 00 00 
  8004204048:	48 39 55 b8          	cmp    %rdx,-0x48(%rbp)
  800420404c:	77 32                	ja     8004204080 <check_boot_pml4e+0x26f>
  800420404e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204052:	48 89 c1             	mov    %rax,%rcx
  8004204055:	48 ba e8 e7 20 04 80 	movabs $0x800420e7e8,%rdx
  800420405c:	00 00 00 
  800420405f:	be 73 03 00 00       	mov    $0x373,%esi
  8004204064:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420406b:	00 00 00 
  800420406e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204073:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420407a:	00 00 00 
  800420407d:	41 ff d0             	callq  *%r8
  8004204080:	48 b9 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rcx
  8004204087:	ff ff ff 
  800420408a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420408e:	48 01 d1             	add    %rdx,%rcx
  8004204091:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004204095:	48 01 ca             	add    %rcx,%rdx
  8004204098:	48 39 d0             	cmp    %rdx,%rax
  800420409b:	74 35                	je     80042040d2 <check_boot_pml4e+0x2c1>
  800420409d:	48 b9 80 eb 20 04 80 	movabs $0x800420eb80,%rcx
  80042040a4:	00 00 00 
  80042040a7:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042040ae:	00 00 00 
  80042040b1:	be 73 03 00 00       	mov    $0x373,%esi
  80042040b6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042040bd:	00 00 00 
  80042040c0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042040c5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042040cc:	00 00 00 
  80042040cf:	41 ff d0             	callq  *%r8
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pml4e, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE) {
  80042040d2:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
  80042040d9:	00 
  80042040da:	48 81 7d e8 ff ff 00 	cmpq   $0xffff,-0x18(%rbp)
  80042040e1:	00 
  80042040e2:	0f 86 21 ff ff ff    	jbe    8004204009 <check_boot_pml4e+0x1f8>
		assert(check_va2pa(pml4e, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	}
	assert(check_va2pa(pml4e, KSTACKTOP - KSTKSIZE - 1 )  == ~0);
  80042040e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042040ec:	48 be ff ff fe 03 80 	movabs $0x8003feffff,%rsi
  80042040f3:	00 00 00 
  80042040f6:	48 89 c7             	mov    %rax,%rdi
  80042040f9:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004204100:	00 00 00 
  8004204103:	ff d0                	callq  *%rax
  8004204105:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  8004204109:	74 35                	je     8004204140 <check_boot_pml4e+0x32f>
  800420410b:	48 b9 c8 eb 20 04 80 	movabs $0x800420ebc8,%rcx
  8004204112:	00 00 00 
  8004204115:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420411c:	00 00 00 
  800420411f:	be 75 03 00 00       	mov    $0x375,%esi
  8004204124:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420412b:	00 00 00 
  800420412e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204133:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420413a:	00 00 00 
  800420413d:	41 ff d0             	callq  *%r8

	pdpe_t *pdpe = KADDR(PTE_ADDR(boot_pml4e[1]));
  8004204140:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204147:	00 00 00 
  800420414a:	48 8b 00             	mov    (%rax),%rax
  800420414d:	48 83 c0 08          	add    $0x8,%rax
  8004204151:	48 8b 00             	mov    (%rax),%rax
  8004204154:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800420415a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800420415e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004204162:	48 c1 e8 0c          	shr    $0xc,%rax
  8004204166:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8004204169:	8b 55 ac             	mov    -0x54(%rbp),%edx
  800420416c:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004204173:	00 00 00 
  8004204176:	48 8b 00             	mov    (%rax),%rax
  8004204179:	48 39 c2             	cmp    %rax,%rdx
  800420417c:	72 32                	jb     80042041b0 <check_boot_pml4e+0x39f>
  800420417e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004204182:	48 89 c1             	mov    %rax,%rcx
  8004204185:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  800420418c:	00 00 00 
  800420418f:	be 77 03 00 00       	mov    $0x377,%esi
  8004204194:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420419b:	00 00 00 
  800420419e:	b8 00 00 00 00       	mov    $0x0,%eax
  80042041a3:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042041aa:	00 00 00 
  80042041ad:	41 ff d0             	callq  *%r8
  80042041b0:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042041b7:	00 00 00 
  80042041ba:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042041be:	48 01 d0             	add    %rdx,%rax
  80042041c1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	pde_t  *pgdir = KADDR(PTE_ADDR(pdpe[0]));
  80042041c5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042041c9:	48 8b 00             	mov    (%rax),%rax
  80042041cc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80042041d2:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  80042041d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042041da:	48 c1 e8 0c          	shr    $0xc,%rax
  80042041de:	89 45 94             	mov    %eax,-0x6c(%rbp)
  80042041e1:	8b 55 94             	mov    -0x6c(%rbp),%edx
  80042041e4:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042041eb:	00 00 00 
  80042041ee:	48 8b 00             	mov    (%rax),%rax
  80042041f1:	48 39 c2             	cmp    %rax,%rdx
  80042041f4:	72 32                	jb     8004204228 <check_boot_pml4e+0x417>
  80042041f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042041fa:	48 89 c1             	mov    %rax,%rcx
  80042041fd:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004204204:	00 00 00 
  8004204207:	be 78 03 00 00       	mov    $0x378,%esi
  800420420c:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204213:	00 00 00 
  8004204216:	b8 00 00 00 00       	mov    $0x0,%eax
  800420421b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204222:	00 00 00 
  8004204225:	41 ff d0             	callq  *%r8
  8004204228:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  800420422f:	00 00 00 
  8004204232:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004204236:	48 01 d0             	add    %rdx,%rax
  8004204239:	48 89 45 88          	mov    %rax,-0x78(%rbp)
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
  800420423d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004204244:	00 
  8004204245:	e9 3e 01 00 00       	jmpq   8004204388 <check_boot_pml4e+0x577>
		switch (i) {
  800420424a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420424e:	48 83 f8 05          	cmp    $0x5,%rax
  8004204252:	74 06                	je     800420425a <check_boot_pml4e+0x449>
  8004204254:	48 83 f8 1f          	cmp    $0x1f,%rax
  8004204258:	75 58                	jne    80042042b2 <check_boot_pml4e+0x4a1>
			//case PDX(UVPT):
		case PDX(KSTACKTOP - 1):
		case PDX(UPAGES):
			assert(pgdir[i] & PTE_P);
  800420425a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420425e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004204265:	00 
  8004204266:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420426a:	48 01 d0             	add    %rdx,%rax
  800420426d:	48 8b 00             	mov    (%rax),%rax
  8004204270:	83 e0 01             	and    $0x1,%eax
  8004204273:	48 85 c0             	test   %rax,%rax
  8004204276:	75 35                	jne    80042042ad <check_boot_pml4e+0x49c>
  8004204278:	48 b9 fc eb 20 04 80 	movabs $0x800420ebfc,%rcx
  800420427f:	00 00 00 
  8004204282:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204289:	00 00 00 
  800420428c:	be 7f 03 00 00       	mov    $0x37f,%esi
  8004204291:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204298:	00 00 00 
  800420429b:	b8 00 00 00 00       	mov    $0x0,%eax
  80042042a0:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042042a7:	00 00 00 
  80042042aa:	41 ff d0             	callq  *%r8
			break;
  80042042ad:	e9 d1 00 00 00       	jmpq   8004204383 <check_boot_pml4e+0x572>
		default:
			if (i >= PDX(KERNBASE)) {
  80042042b2:	48 83 7d e8 1f       	cmpq   $0x1f,-0x18(%rbp)
  80042042b7:	0f 86 c5 00 00 00    	jbe    8004204382 <check_boot_pml4e+0x571>
				if (pgdir[i] & PTE_P)
  80042042bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042042c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042042c8:	00 
  80042042c9:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80042042cd:	48 01 d0             	add    %rdx,%rax
  80042042d0:	48 8b 00             	mov    (%rax),%rax
  80042042d3:	83 e0 01             	and    $0x1,%eax
  80042042d6:	48 85 c0             	test   %rax,%rax
  80042042d9:	74 57                	je     8004204332 <check_boot_pml4e+0x521>
					assert(pgdir[i] & PTE_W);
  80042042db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042042df:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042042e6:	00 
  80042042e7:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80042042eb:	48 01 d0             	add    %rdx,%rax
  80042042ee:	48 8b 00             	mov    (%rax),%rax
  80042042f1:	83 e0 02             	and    $0x2,%eax
  80042042f4:	48 85 c0             	test   %rax,%rax
  80042042f7:	0f 85 85 00 00 00    	jne    8004204382 <check_boot_pml4e+0x571>
  80042042fd:	48 b9 0d ec 20 04 80 	movabs $0x800420ec0d,%rcx
  8004204304:	00 00 00 
  8004204307:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420430e:	00 00 00 
  8004204311:	be 84 03 00 00       	mov    $0x384,%esi
  8004204316:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420431d:	00 00 00 
  8004204320:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204325:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420432c:	00 00 00 
  800420432f:	41 ff d0             	callq  *%r8
				else
					assert(pgdir[i] == 0);
  8004204332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004204336:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420433d:	00 
  800420433e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004204342:	48 01 d0             	add    %rdx,%rax
  8004204345:	48 8b 00             	mov    (%rax),%rax
  8004204348:	48 85 c0             	test   %rax,%rax
  800420434b:	74 35                	je     8004204382 <check_boot_pml4e+0x571>
  800420434d:	48 b9 1e ec 20 04 80 	movabs $0x800420ec1e,%rcx
  8004204354:	00 00 00 
  8004204357:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420435e:	00 00 00 
  8004204361:	be 86 03 00 00       	mov    $0x386,%esi
  8004204366:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420436d:	00 00 00 
  8004204370:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204375:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420437c:	00 00 00 
  800420437f:	41 ff d0             	callq  *%r8
			} 
			break;
  8004204382:	90                   	nop
	assert(check_va2pa(pml4e, KSTACKTOP - KSTKSIZE - 1 )  == ~0);

	pdpe_t *pdpe = KADDR(PTE_ADDR(boot_pml4e[1]));
	pde_t  *pgdir = KADDR(PTE_ADDR(pdpe[0]));
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
  8004204383:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004204388:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  800420438f:	00 
  8004204390:	0f 86 b4 fe ff ff    	jbe    800420424a <check_boot_pml4e+0x439>
					assert(pgdir[i] == 0);
			} 
			break;
		}
	}
	cprintf("check_boot_pml4e() succeeded!\n");
  8004204396:	48 bf 30 ec 20 04 80 	movabs $0x800420ec30,%rdi
  800420439d:	00 00 00 
  80042043a0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042043a5:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  80042043ac:	00 00 00 
  80042043af:	ff d2                	callq  *%rdx
}
  80042043b1:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  80042043b8:	5b                   	pop    %rbx
  80042043b9:	5d                   	pop    %rbp
  80042043ba:	c3                   	retq   

00000080042043bb <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_boot_pml4e() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pml4e_t *pml4e, uintptr_t va)
{
  80042043bb:	55                   	push   %rbp
  80042043bc:	48 89 e5             	mov    %rsp,%rbp
  80042043bf:	48 83 ec 60          	sub    $0x60,%rsp
  80042043c3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80042043c7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	pte_t *pte;
	pdpe_t *pdpe;
	pde_t *pde;
	// cprintf("%x", va);
	pml4e = &pml4e[PML4(va)];
  80042043cb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042043cf:	48 c1 e8 27          	shr    $0x27,%rax
  80042043d3:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042043d8:	48 c1 e0 03          	shl    $0x3,%rax
  80042043dc:	48 01 45 a8          	add    %rax,-0x58(%rbp)
	// cprintf(" %x %x " , PML4(va), *pml4e);
	if(!(*pml4e & PTE_P))
  80042043e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042043e4:	48 8b 00             	mov    (%rax),%rax
  80042043e7:	83 e0 01             	and    $0x1,%eax
  80042043ea:	48 85 c0             	test   %rax,%rax
  80042043ed:	75 0c                	jne    80042043fb <check_va2pa+0x40>
		return ~0;
  80042043ef:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  80042043f6:	e9 38 02 00 00       	jmpq   8004204633 <check_va2pa+0x278>
	pdpe = (pdpe_t *) KADDR(PTE_ADDR(*pml4e));
  80042043fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042043ff:	48 8b 00             	mov    (%rax),%rax
  8004204402:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004204408:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420440c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004204410:	48 c1 e8 0c          	shr    $0xc,%rax
  8004204414:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8004204417:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420441a:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004204421:	00 00 00 
  8004204424:	48 8b 00             	mov    (%rax),%rax
  8004204427:	48 39 c2             	cmp    %rax,%rdx
  800420442a:	72 32                	jb     800420445e <check_va2pa+0xa3>
  800420442c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004204430:	48 89 c1             	mov    %rax,%rcx
  8004204433:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  800420443a:	00 00 00 
  800420443d:	be 9e 03 00 00       	mov    $0x39e,%esi
  8004204442:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204449:	00 00 00 
  800420444c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204451:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204458:	00 00 00 
  800420445b:	41 ff d0             	callq  *%r8
  800420445e:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004204465:	00 00 00 
  8004204468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420446c:	48 01 d0             	add    %rdx,%rax
  800420446f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// cprintf(" %x %x " , pdpe, *pdpe);
	if (!(pdpe[PDPE(va)] & PTE_P))
  8004204473:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004204477:	48 c1 e8 1e          	shr    $0x1e,%rax
  800420447b:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004204480:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004204487:	00 
  8004204488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420448c:	48 01 d0             	add    %rdx,%rax
  800420448f:	48 8b 00             	mov    (%rax),%rax
  8004204492:	83 e0 01             	and    $0x1,%eax
  8004204495:	48 85 c0             	test   %rax,%rax
  8004204498:	75 0c                	jne    80042044a6 <check_va2pa+0xeb>
		return ~0;
  800420449a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  80042044a1:	e9 8d 01 00 00       	jmpq   8004204633 <check_va2pa+0x278>
	pde = (pde_t *) KADDR(PTE_ADDR(pdpe[PDPE(va)]));
  80042044a6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042044aa:	48 c1 e8 1e          	shr    $0x1e,%rax
  80042044ae:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042044b3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042044ba:	00 
  80042044bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042044bf:	48 01 d0             	add    %rdx,%rax
  80042044c2:	48 8b 00             	mov    (%rax),%rax
  80042044c5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80042044cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80042044cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042044d3:	48 c1 e8 0c          	shr    $0xc,%rax
  80042044d7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80042044da:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80042044dd:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042044e4:	00 00 00 
  80042044e7:	48 8b 00             	mov    (%rax),%rax
  80042044ea:	48 39 c2             	cmp    %rax,%rdx
  80042044ed:	72 32                	jb     8004204521 <check_va2pa+0x166>
  80042044ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042044f3:	48 89 c1             	mov    %rax,%rcx
  80042044f6:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  80042044fd:	00 00 00 
  8004204500:	be a2 03 00 00       	mov    $0x3a2,%esi
  8004204505:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420450c:	00 00 00 
  800420450f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204514:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420451b:	00 00 00 
  800420451e:	41 ff d0             	callq  *%r8
  8004204521:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004204528:	00 00 00 
  800420452b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420452f:	48 01 d0             	add    %rdx,%rax
  8004204532:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// cprintf(" %x %x " , pde, *pde);
	pde = &pde[PDX(va)];
  8004204536:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420453a:	48 c1 e8 15          	shr    $0x15,%rax
  800420453e:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004204543:	48 c1 e0 03          	shl    $0x3,%rax
  8004204547:	48 01 45 d0          	add    %rax,-0x30(%rbp)
	if (!(*pde & PTE_P))
  800420454b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420454f:	48 8b 00             	mov    (%rax),%rax
  8004204552:	83 e0 01             	and    $0x1,%eax
  8004204555:	48 85 c0             	test   %rax,%rax
  8004204558:	75 0c                	jne    8004204566 <check_va2pa+0x1ab>
		return ~0;
  800420455a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  8004204561:	e9 cd 00 00 00       	jmpq   8004204633 <check_va2pa+0x278>
	pte = (pte_t*) KADDR(PTE_ADDR(*pde));
  8004204566:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420456a:	48 8b 00             	mov    (%rax),%rax
  800420456d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004204573:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8004204577:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420457b:	48 c1 e8 0c          	shr    $0xc,%rax
  800420457f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
  8004204582:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  8004204585:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  800420458c:	00 00 00 
  800420458f:	48 8b 00             	mov    (%rax),%rax
  8004204592:	48 39 c2             	cmp    %rax,%rdx
  8004204595:	72 32                	jb     80042045c9 <check_va2pa+0x20e>
  8004204597:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420459b:	48 89 c1             	mov    %rax,%rcx
  800420459e:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  80042045a5:	00 00 00 
  80042045a8:	be a7 03 00 00       	mov    $0x3a7,%esi
  80042045ad:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042045b4:	00 00 00 
  80042045b7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042045bc:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042045c3:	00 00 00 
  80042045c6:	41 ff d0             	callq  *%r8
  80042045c9:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042045d0:	00 00 00 
  80042045d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042045d7:	48 01 d0             	add    %rdx,%rax
  80042045da:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	// cprintf(" %x %x " , pte, *pte);
	if (!(pte[PTX(va)] & PTE_P))
  80042045de:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042045e2:	48 c1 e8 0c          	shr    $0xc,%rax
  80042045e6:	25 ff 01 00 00       	and    $0x1ff,%eax
  80042045eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80042045f2:	00 
  80042045f3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042045f7:	48 01 d0             	add    %rdx,%rax
  80042045fa:	48 8b 00             	mov    (%rax),%rax
  80042045fd:	83 e0 01             	and    $0x1,%eax
  8004204600:	48 85 c0             	test   %rax,%rax
  8004204603:	75 09                	jne    800420460e <check_va2pa+0x253>
		return ~0;
  8004204605:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  800420460c:	eb 25                	jmp    8004204633 <check_va2pa+0x278>
	// cprintf(" %x %x\n" , PTX(va),  PTE_ADDR(pte[PTX(va)]));
	return PTE_ADDR(pte[PTX(va)]);
  800420460e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004204612:	48 c1 e8 0c          	shr    $0xc,%rax
  8004204616:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420461b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004204622:	00 
  8004204623:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204627:	48 01 d0             	add    %rdx,%rax
  800420462a:	48 8b 00             	mov    (%rax),%rax
  800420462d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
}
  8004204633:	c9                   	leaveq 
  8004204634:	c3                   	retq   

0000008004204635 <page_check>:


// check page_insert, page_remove, &c
static void
page_check(void)
{
  8004204635:	55                   	push   %rbp
  8004204636:	48 89 e5             	mov    %rsp,%rbp
  8004204639:	53                   	push   %rbx
  800420463a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
	pte_t *ptep, *ptep1;
	pdpe_t *pdpe;
	pde_t *pde;
	void *va;
	int i;
	pp0 = pp1 = pp2 = pp3 = pp4 = pp5 =0;
  8004204641:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8004204648:	00 
  8004204649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420464d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8004204651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004204655:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004204659:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420465d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8004204661:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204665:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004204669:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420466d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	assert(pp0 = page_alloc(0));
  8004204671:	bf 00 00 00 00       	mov    $0x0,%edi
  8004204676:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  800420467d:	00 00 00 
  8004204680:	ff d0                	callq  *%rax
  8004204682:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004204686:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  800420468b:	75 35                	jne    80042046c2 <page_check+0x8d>
  800420468d:	48 b9 4f ec 20 04 80 	movabs $0x800420ec4f,%rcx
  8004204694:	00 00 00 
  8004204697:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420469e:	00 00 00 
  80042046a1:	be bc 03 00 00       	mov    $0x3bc,%esi
  80042046a6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042046ad:	00 00 00 
  80042046b0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042046b5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042046bc:	00 00 00 
  80042046bf:	41 ff d0             	callq  *%r8
	assert(pp1 = page_alloc(0));
  80042046c2:	bf 00 00 00 00       	mov    $0x0,%edi
  80042046c7:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  80042046ce:	00 00 00 
  80042046d1:	ff d0                	callq  *%rax
  80042046d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80042046d7:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  80042046dc:	75 35                	jne    8004204713 <page_check+0xde>
  80042046de:	48 b9 63 ec 20 04 80 	movabs $0x800420ec63,%rcx
  80042046e5:	00 00 00 
  80042046e8:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042046ef:	00 00 00 
  80042046f2:	be bd 03 00 00       	mov    $0x3bd,%esi
  80042046f7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042046fe:	00 00 00 
  8004204701:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204706:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420470d:	00 00 00 
  8004204710:	41 ff d0             	callq  *%r8
	assert(pp2 = page_alloc(0));
  8004204713:	bf 00 00 00 00       	mov    $0x0,%edi
  8004204718:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  800420471f:	00 00 00 
  8004204722:	ff d0                	callq  *%rax
  8004204724:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8004204728:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420472d:	75 35                	jne    8004204764 <page_check+0x12f>
  800420472f:	48 b9 77 ec 20 04 80 	movabs $0x800420ec77,%rcx
  8004204736:	00 00 00 
  8004204739:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204740:	00 00 00 
  8004204743:	be be 03 00 00       	mov    $0x3be,%esi
  8004204748:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420474f:	00 00 00 
  8004204752:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204757:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420475e:	00 00 00 
  8004204761:	41 ff d0             	callq  *%r8
	assert(pp3 = page_alloc(0));
  8004204764:	bf 00 00 00 00       	mov    $0x0,%edi
  8004204769:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004204770:	00 00 00 
  8004204773:	ff d0                	callq  *%rax
  8004204775:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004204779:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420477e:	75 35                	jne    80042047b5 <page_check+0x180>
  8004204780:	48 b9 8b ec 20 04 80 	movabs $0x800420ec8b,%rcx
  8004204787:	00 00 00 
  800420478a:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204791:	00 00 00 
  8004204794:	be bf 03 00 00       	mov    $0x3bf,%esi
  8004204799:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042047a0:	00 00 00 
  80042047a3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042047a8:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042047af:	00 00 00 
  80042047b2:	41 ff d0             	callq  *%r8
	assert(pp4 = page_alloc(0));
  80042047b5:	bf 00 00 00 00       	mov    $0x0,%edi
  80042047ba:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  80042047c1:	00 00 00 
  80042047c4:	ff d0                	callq  *%rax
  80042047c6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80042047ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80042047cf:	75 35                	jne    8004204806 <page_check+0x1d1>
  80042047d1:	48 b9 9f ec 20 04 80 	movabs $0x800420ec9f,%rcx
  80042047d8:	00 00 00 
  80042047db:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042047e2:	00 00 00 
  80042047e5:	be c0 03 00 00       	mov    $0x3c0,%esi
  80042047ea:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042047f1:	00 00 00 
  80042047f4:	b8 00 00 00 00       	mov    $0x0,%eax
  80042047f9:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204800:	00 00 00 
  8004204803:	41 ff d0             	callq  *%r8
	assert(pp5 = page_alloc(0));
  8004204806:	bf 00 00 00 00       	mov    $0x0,%edi
  800420480b:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004204812:	00 00 00 
  8004204815:	ff d0                	callq  *%rax
  8004204817:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800420481b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004204820:	75 35                	jne    8004204857 <page_check+0x222>
  8004204822:	48 b9 b3 ec 20 04 80 	movabs $0x800420ecb3,%rcx
  8004204829:	00 00 00 
  800420482c:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204833:	00 00 00 
  8004204836:	be c1 03 00 00       	mov    $0x3c1,%esi
  800420483b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204842:	00 00 00 
  8004204845:	b8 00 00 00 00       	mov    $0x0,%eax
  800420484a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204851:	00 00 00 
  8004204854:	41 ff d0             	callq  *%r8

	assert(pp0);
  8004204857:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  800420485c:	75 35                	jne    8004204893 <page_check+0x25e>
  800420485e:	48 b9 29 ea 20 04 80 	movabs $0x800420ea29,%rcx
  8004204865:	00 00 00 
  8004204868:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420486f:	00 00 00 
  8004204872:	be c3 03 00 00       	mov    $0x3c3,%esi
  8004204877:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420487e:	00 00 00 
  8004204881:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204886:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420488d:	00 00 00 
  8004204890:	41 ff d0             	callq  *%r8
	assert(pp1 && pp1 != pp0);
  8004204893:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8004204898:	74 0a                	je     80042048a4 <page_check+0x26f>
  800420489a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420489e:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  80042048a2:	75 35                	jne    80042048d9 <page_check+0x2a4>
  80042048a4:	48 b9 2d ea 20 04 80 	movabs $0x800420ea2d,%rcx
  80042048ab:	00 00 00 
  80042048ae:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042048b5:	00 00 00 
  80042048b8:	be c4 03 00 00       	mov    $0x3c4,%esi
  80042048bd:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042048c4:	00 00 00 
  80042048c7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042048cc:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042048d3:	00 00 00 
  80042048d6:	41 ff d0             	callq  *%r8
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
  80042048d9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042048de:	74 14                	je     80042048f4 <page_check+0x2bf>
  80042048e0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042048e4:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80042048e8:	74 0a                	je     80042048f4 <page_check+0x2bf>
  80042048ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042048ee:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  80042048f2:	75 35                	jne    8004204929 <page_check+0x2f4>
  80042048f4:	48 b9 40 ea 20 04 80 	movabs $0x800420ea40,%rcx
  80042048fb:	00 00 00 
  80042048fe:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204905:	00 00 00 
  8004204908:	be c5 03 00 00       	mov    $0x3c5,%esi
  800420490d:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204914:	00 00 00 
  8004204917:	b8 00 00 00 00       	mov    $0x0,%eax
  800420491c:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204923:	00 00 00 
  8004204926:	41 ff d0             	callq  *%r8
	assert(pp3 && pp3 != pp2 && pp3 != pp1 && pp3 != pp0);
  8004204929:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420492e:	74 1e                	je     800420494e <page_check+0x319>
  8004204930:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204934:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004204938:	74 14                	je     800420494e <page_check+0x319>
  800420493a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420493e:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8004204942:	74 0a                	je     800420494e <page_check+0x319>
  8004204944:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204948:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  800420494c:	75 35                	jne    8004204983 <page_check+0x34e>
  800420494e:	48 b9 c8 ec 20 04 80 	movabs $0x800420ecc8,%rcx
  8004204955:	00 00 00 
  8004204958:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420495f:	00 00 00 
  8004204962:	be c6 03 00 00       	mov    $0x3c6,%esi
  8004204967:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420496e:	00 00 00 
  8004204971:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204976:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420497d:	00 00 00 
  8004204980:	41 ff d0             	callq  *%r8
	assert(pp4 && pp4 != pp3 && pp4 != pp2 && pp4 != pp1 && pp4 != pp0);
  8004204983:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004204988:	74 28                	je     80042049b2 <page_check+0x37d>
  800420498a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420498e:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004204992:	74 1e                	je     80042049b2 <page_check+0x37d>
  8004204994:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004204998:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  800420499c:	74 14                	je     80042049b2 <page_check+0x37d>
  800420499e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042049a2:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80042049a6:	74 0a                	je     80042049b2 <page_check+0x37d>
  80042049a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042049ac:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  80042049b0:	75 35                	jne    80042049e7 <page_check+0x3b2>
  80042049b2:	48 b9 f8 ec 20 04 80 	movabs $0x800420ecf8,%rcx
  80042049b9:	00 00 00 
  80042049bc:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042049c3:	00 00 00 
  80042049c6:	be c7 03 00 00       	mov    $0x3c7,%esi
  80042049cb:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042049d2:	00 00 00 
  80042049d5:	b8 00 00 00 00       	mov    $0x0,%eax
  80042049da:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042049e1:	00 00 00 
  80042049e4:	41 ff d0             	callq  *%r8
	assert(pp5 && pp5 != pp4 && pp5 != pp3 && pp5 != pp2 && pp5 != pp1 && pp5 != pp0);
  80042049e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80042049ec:	74 32                	je     8004204a20 <page_check+0x3eb>
  80042049ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042049f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80042049f6:	74 28                	je     8004204a20 <page_check+0x3eb>
  80042049f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042049fc:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004204a00:	74 1e                	je     8004204a20 <page_check+0x3eb>
  8004204a02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204a06:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004204a0a:	74 14                	je     8004204a20 <page_check+0x3eb>
  8004204a0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204a10:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8004204a14:	74 0a                	je     8004204a20 <page_check+0x3eb>
  8004204a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004204a1a:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  8004204a1e:	75 35                	jne    8004204a55 <page_check+0x420>
  8004204a20:	48 b9 38 ed 20 04 80 	movabs $0x800420ed38,%rcx
  8004204a27:	00 00 00 
  8004204a2a:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204a31:	00 00 00 
  8004204a34:	be c8 03 00 00       	mov    $0x3c8,%esi
  8004204a39:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204a40:	00 00 00 
  8004204a43:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204a48:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204a4f:	00 00 00 
  8004204a52:	41 ff d0             	callq  *%r8

	// temporarily steal the rest of the free pages
	fl = page_free_list;
  8004204a55:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004204a5c:	00 00 00 
  8004204a5f:	48 8b 00             	mov    (%rax),%rax
  8004204a62:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	page_free_list = NULL;
  8004204a66:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004204a6d:	00 00 00 
  8004204a70:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// should be no free memory
	assert(!page_alloc(0));
  8004204a77:	bf 00 00 00 00       	mov    $0x0,%edi
  8004204a7c:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004204a83:	00 00 00 
  8004204a86:	ff d0                	callq  *%rax
  8004204a88:	48 85 c0             	test   %rax,%rax
  8004204a8b:	74 35                	je     8004204ac2 <page_check+0x48d>
  8004204a8d:	48 b9 b7 ea 20 04 80 	movabs $0x800420eab7,%rcx
  8004204a94:	00 00 00 
  8004204a97:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204a9e:	00 00 00 
  8004204aa1:	be cf 03 00 00       	mov    $0x3cf,%esi
  8004204aa6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204aad:	00 00 00 
  8004204ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204ab5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204abc:	00 00 00 
  8004204abf:	41 ff d0             	callq  *%r8

	// there is no page allocated at address 0
	assert(page_lookup(boot_pml4e, (void *) 0x0, &ptep) == NULL);
  8004204ac2:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204ac9:	00 00 00 
  8004204acc:	48 8b 00             	mov    (%rax),%rax
  8004204acf:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004204ad6:	be 00 00 00 00       	mov    $0x0,%esi
  8004204adb:	48 89 c7             	mov    %rax,%rdi
  8004204ade:	48 b8 f5 2d 20 04 80 	movabs $0x8004202df5,%rax
  8004204ae5:	00 00 00 
  8004204ae8:	ff d0                	callq  *%rax
  8004204aea:	48 85 c0             	test   %rax,%rax
  8004204aed:	74 35                	je     8004204b24 <page_check+0x4ef>
  8004204aef:	48 b9 88 ed 20 04 80 	movabs $0x800420ed88,%rcx
  8004204af6:	00 00 00 
  8004204af9:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204b00:	00 00 00 
  8004204b03:	be d2 03 00 00       	mov    $0x3d2,%esi
  8004204b08:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204b0f:	00 00 00 
  8004204b12:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204b17:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204b1e:	00 00 00 
  8004204b21:	41 ff d0             	callq  *%r8

	// there is no free memory, so we can't allocate a page table 
	assert(page_insert(boot_pml4e, pp1, 0x0, 0) < 0);
  8004204b24:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204b2b:	00 00 00 
  8004204b2e:	48 8b 00             	mov    (%rax),%rax
  8004204b31:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004204b35:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004204b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  8004204b3f:	48 89 c7             	mov    %rax,%rdi
  8004204b42:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004204b49:	00 00 00 
  8004204b4c:	ff d0                	callq  *%rax
  8004204b4e:	85 c0                	test   %eax,%eax
  8004204b50:	78 35                	js     8004204b87 <page_check+0x552>
  8004204b52:	48 b9 c0 ed 20 04 80 	movabs $0x800420edc0,%rcx
  8004204b59:	00 00 00 
  8004204b5c:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204b63:	00 00 00 
  8004204b66:	be d5 03 00 00       	mov    $0x3d5,%esi
  8004204b6b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204b72:	00 00 00 
  8004204b75:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204b7a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204b81:	00 00 00 
  8004204b84:	41 ff d0             	callq  *%r8

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
  8004204b87:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204b8b:	48 89 c7             	mov    %rax,%rdi
  8004204b8e:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004204b95:	00 00 00 
  8004204b98:	ff d0                	callq  *%rax
	assert(page_insert(boot_pml4e, pp1, 0x0, 0) < 0);
  8004204b9a:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204ba1:	00 00 00 
  8004204ba4:	48 8b 00             	mov    (%rax),%rax
  8004204ba7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004204bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004204bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004204bb5:	48 89 c7             	mov    %rax,%rdi
  8004204bb8:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004204bbf:	00 00 00 
  8004204bc2:	ff d0                	callq  *%rax
  8004204bc4:	85 c0                	test   %eax,%eax
  8004204bc6:	78 35                	js     8004204bfd <page_check+0x5c8>
  8004204bc8:	48 b9 c0 ed 20 04 80 	movabs $0x800420edc0,%rcx
  8004204bcf:	00 00 00 
  8004204bd2:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204bd9:	00 00 00 
  8004204bdc:	be d9 03 00 00       	mov    $0x3d9,%esi
  8004204be1:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204be8:	00 00 00 
  8004204beb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204bf0:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204bf7:	00 00 00 
  8004204bfa:	41 ff d0             	callq  *%r8
	page_free(pp2);
  8004204bfd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204c01:	48 89 c7             	mov    %rax,%rdi
  8004204c04:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004204c0b:	00 00 00 
  8004204c0e:	ff d0                	callq  *%rax
	page_free(pp3);
  8004204c10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204c14:	48 89 c7             	mov    %rax,%rdi
  8004204c17:	48 b8 ef 24 20 04 80 	movabs $0x80042024ef,%rax
  8004204c1e:	00 00 00 
  8004204c21:	ff d0                	callq  *%rax
	//cprintf("pp1 ref count = %d\n",pp1->pp_ref);
	//cprintf("pp0 ref count = %d\n",pp0->pp_ref);
	//cprintf("pp2 ref count = %d\n",pp2->pp_ref);
	assert(page_insert(boot_pml4e, pp1, 0x0, 0) == 0);
  8004204c23:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204c2a:	00 00 00 
  8004204c2d:	48 8b 00             	mov    (%rax),%rax
  8004204c30:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004204c34:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004204c39:	ba 00 00 00 00       	mov    $0x0,%edx
  8004204c3e:	48 89 c7             	mov    %rax,%rdi
  8004204c41:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004204c48:	00 00 00 
  8004204c4b:	ff d0                	callq  *%rax
  8004204c4d:	85 c0                	test   %eax,%eax
  8004204c4f:	74 35                	je     8004204c86 <page_check+0x651>
  8004204c51:	48 b9 f0 ed 20 04 80 	movabs $0x800420edf0,%rcx
  8004204c58:	00 00 00 
  8004204c5b:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204c62:	00 00 00 
  8004204c65:	be df 03 00 00       	mov    $0x3df,%esi
  8004204c6a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204c71:	00 00 00 
  8004204c74:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204c79:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204c80:	00 00 00 
  8004204c83:	41 ff d0             	callq  *%r8
	assert((PTE_ADDR(boot_pml4e[0]) == page2pa(pp0) || PTE_ADDR(boot_pml4e[0]) == page2pa(pp2) || PTE_ADDR(boot_pml4e[0]) == page2pa(pp3) ));
  8004204c86:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204c8d:	00 00 00 
  8004204c90:	48 8b 00             	mov    (%rax),%rax
  8004204c93:	48 8b 00             	mov    (%rax),%rax
  8004204c96:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004204c9c:	48 89 c3             	mov    %rax,%rbx
  8004204c9f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204ca3:	48 89 c7             	mov    %rax,%rdi
  8004204ca6:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004204cad:	00 00 00 
  8004204cb0:	ff d0                	callq  *%rax
  8004204cb2:	48 39 c3             	cmp    %rax,%rbx
  8004204cb5:	0f 84 97 00 00 00    	je     8004204d52 <page_check+0x71d>
  8004204cbb:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204cc2:	00 00 00 
  8004204cc5:	48 8b 00             	mov    (%rax),%rax
  8004204cc8:	48 8b 00             	mov    (%rax),%rax
  8004204ccb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004204cd1:	48 89 c3             	mov    %rax,%rbx
  8004204cd4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204cd8:	48 89 c7             	mov    %rax,%rdi
  8004204cdb:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004204ce2:	00 00 00 
  8004204ce5:	ff d0                	callq  *%rax
  8004204ce7:	48 39 c3             	cmp    %rax,%rbx
  8004204cea:	74 66                	je     8004204d52 <page_check+0x71d>
  8004204cec:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204cf3:	00 00 00 
  8004204cf6:	48 8b 00             	mov    (%rax),%rax
  8004204cf9:	48 8b 00             	mov    (%rax),%rax
  8004204cfc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004204d02:	48 89 c3             	mov    %rax,%rbx
  8004204d05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204d09:	48 89 c7             	mov    %rax,%rdi
  8004204d0c:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004204d13:	00 00 00 
  8004204d16:	ff d0                	callq  *%rax
  8004204d18:	48 39 c3             	cmp    %rax,%rbx
  8004204d1b:	74 35                	je     8004204d52 <page_check+0x71d>
  8004204d1d:	48 b9 20 ee 20 04 80 	movabs $0x800420ee20,%rcx
  8004204d24:	00 00 00 
  8004204d27:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204d2e:	00 00 00 
  8004204d31:	be e0 03 00 00       	mov    $0x3e0,%esi
  8004204d36:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204d3d:	00 00 00 
  8004204d40:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204d45:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204d4c:	00 00 00 
  8004204d4f:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, 0x0) == page2pa(pp1));
  8004204d52:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204d59:	00 00 00 
  8004204d5c:	48 8b 00             	mov    (%rax),%rax
  8004204d5f:	be 00 00 00 00       	mov    $0x0,%esi
  8004204d64:	48 89 c7             	mov    %rax,%rdi
  8004204d67:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004204d6e:	00 00 00 
  8004204d71:	ff d0                	callq  *%rax
  8004204d73:	48 89 c3             	mov    %rax,%rbx
  8004204d76:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204d7a:	48 89 c7             	mov    %rax,%rdi
  8004204d7d:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004204d84:	00 00 00 
  8004204d87:	ff d0                	callq  *%rax
  8004204d89:	48 39 c3             	cmp    %rax,%rbx
  8004204d8c:	74 35                	je     8004204dc3 <page_check+0x78e>
  8004204d8e:	48 b9 a8 ee 20 04 80 	movabs $0x800420eea8,%rcx
  8004204d95:	00 00 00 
  8004204d98:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204d9f:	00 00 00 
  8004204da2:	be e1 03 00 00       	mov    $0x3e1,%esi
  8004204da7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204dae:	00 00 00 
  8004204db1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204db6:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204dbd:	00 00 00 
  8004204dc0:	41 ff d0             	callq  *%r8
	assert(pp1->pp_ref == 1);
  8004204dc3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004204dc7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204dcb:	66 83 f8 01          	cmp    $0x1,%ax
  8004204dcf:	74 35                	je     8004204e06 <page_check+0x7d1>
  8004204dd1:	48 b9 d5 ee 20 04 80 	movabs $0x800420eed5,%rcx
  8004204dd8:	00 00 00 
  8004204ddb:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204de2:	00 00 00 
  8004204de5:	be e2 03 00 00       	mov    $0x3e2,%esi
  8004204dea:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204df1:	00 00 00 
  8004204df4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204df9:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204e00:	00 00 00 
  8004204e03:	41 ff d0             	callq  *%r8
	assert(pp0->pp_ref == 1);
  8004204e06:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004204e0a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204e0e:	66 83 f8 01          	cmp    $0x1,%ax
  8004204e12:	74 35                	je     8004204e49 <page_check+0x814>
  8004204e14:	48 b9 e6 ee 20 04 80 	movabs $0x800420eee6,%rcx
  8004204e1b:	00 00 00 
  8004204e1e:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204e25:	00 00 00 
  8004204e28:	be e3 03 00 00       	mov    $0x3e3,%esi
  8004204e2d:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204e34:	00 00 00 
  8004204e37:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204e3c:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204e43:	00 00 00 
  8004204e46:	41 ff d0             	callq  *%r8
	assert(pp2->pp_ref == 1);
  8004204e49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004204e4d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204e51:	66 83 f8 01          	cmp    $0x1,%ax
  8004204e55:	74 35                	je     8004204e8c <page_check+0x857>
  8004204e57:	48 b9 f7 ee 20 04 80 	movabs $0x800420eef7,%rcx
  8004204e5e:	00 00 00 
  8004204e61:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204e68:	00 00 00 
  8004204e6b:	be e4 03 00 00       	mov    $0x3e4,%esi
  8004204e70:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204e77:	00 00 00 
  8004204e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204e7f:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204e86:	00 00 00 
  8004204e89:	41 ff d0             	callq  *%r8
	//should be able to map pp3 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(boot_pml4e, pp3, (void*) PGSIZE, 0) == 0);
  8004204e8c:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204e93:	00 00 00 
  8004204e96:	48 8b 00             	mov    (%rax),%rax
  8004204e99:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004204e9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004204ea2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004204ea7:	48 89 c7             	mov    %rax,%rdi
  8004204eaa:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004204eb1:	00 00 00 
  8004204eb4:	ff d0                	callq  *%rax
  8004204eb6:	85 c0                	test   %eax,%eax
  8004204eb8:	74 35                	je     8004204eef <page_check+0x8ba>
  8004204eba:	48 b9 08 ef 20 04 80 	movabs $0x800420ef08,%rcx
  8004204ec1:	00 00 00 
  8004204ec4:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204ecb:	00 00 00 
  8004204ece:	be e6 03 00 00       	mov    $0x3e6,%esi
  8004204ed3:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204eda:	00 00 00 
  8004204edd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204ee2:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204ee9:	00 00 00 
  8004204eec:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == page2pa(pp3));
  8004204eef:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204ef6:	00 00 00 
  8004204ef9:	48 8b 00             	mov    (%rax),%rax
  8004204efc:	be 00 10 00 00       	mov    $0x1000,%esi
  8004204f01:	48 89 c7             	mov    %rax,%rdi
  8004204f04:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004204f0b:	00 00 00 
  8004204f0e:	ff d0                	callq  *%rax
  8004204f10:	48 89 c3             	mov    %rax,%rbx
  8004204f13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204f17:	48 89 c7             	mov    %rax,%rdi
  8004204f1a:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004204f21:	00 00 00 
  8004204f24:	ff d0                	callq  *%rax
  8004204f26:	48 39 c3             	cmp    %rax,%rbx
  8004204f29:	74 35                	je     8004204f60 <page_check+0x92b>
  8004204f2b:	48 b9 40 ef 20 04 80 	movabs $0x800420ef40,%rcx
  8004204f32:	00 00 00 
  8004204f35:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204f3c:	00 00 00 
  8004204f3f:	be e7 03 00 00       	mov    $0x3e7,%esi
  8004204f44:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204f4b:	00 00 00 
  8004204f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204f53:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204f5a:	00 00 00 
  8004204f5d:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 2);
  8004204f60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004204f64:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004204f68:	66 83 f8 02          	cmp    $0x2,%ax
  8004204f6c:	74 35                	je     8004204fa3 <page_check+0x96e>
  8004204f6e:	48 b9 70 ef 20 04 80 	movabs $0x800420ef70,%rcx
  8004204f75:	00 00 00 
  8004204f78:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204f7f:	00 00 00 
  8004204f82:	be e8 03 00 00       	mov    $0x3e8,%esi
  8004204f87:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204f8e:	00 00 00 
  8004204f91:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204f96:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204f9d:	00 00 00 
  8004204fa0:	41 ff d0             	callq  *%r8

	// should be no free memory
	assert(!page_alloc(0));
  8004204fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  8004204fa8:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004204faf:	00 00 00 
  8004204fb2:	ff d0                	callq  *%rax
  8004204fb4:	48 85 c0             	test   %rax,%rax
  8004204fb7:	74 35                	je     8004204fee <page_check+0x9b9>
  8004204fb9:	48 b9 b7 ea 20 04 80 	movabs $0x800420eab7,%rcx
  8004204fc0:	00 00 00 
  8004204fc3:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004204fca:	00 00 00 
  8004204fcd:	be eb 03 00 00       	mov    $0x3eb,%esi
  8004204fd2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004204fd9:	00 00 00 
  8004204fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004204fe1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004204fe8:	00 00 00 
  8004204feb:	41 ff d0             	callq  *%r8

	// should be able to map pp3 at PGSIZE because it's already there
	assert(page_insert(boot_pml4e, pp3, (void*) PGSIZE, 0) == 0);
  8004204fee:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004204ff5:	00 00 00 
  8004204ff8:	48 8b 00             	mov    (%rax),%rax
  8004204ffb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004204fff:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004205004:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004205009:	48 89 c7             	mov    %rax,%rdi
  800420500c:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004205013:	00 00 00 
  8004205016:	ff d0                	callq  *%rax
  8004205018:	85 c0                	test   %eax,%eax
  800420501a:	74 35                	je     8004205051 <page_check+0xa1c>
  800420501c:	48 b9 08 ef 20 04 80 	movabs $0x800420ef08,%rcx
  8004205023:	00 00 00 
  8004205026:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420502d:	00 00 00 
  8004205030:	be ee 03 00 00       	mov    $0x3ee,%esi
  8004205035:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420503c:	00 00 00 
  800420503f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205044:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420504b:	00 00 00 
  800420504e:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == page2pa(pp3));
  8004205051:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205058:	00 00 00 
  800420505b:	48 8b 00             	mov    (%rax),%rax
  800420505e:	be 00 10 00 00       	mov    $0x1000,%esi
  8004205063:	48 89 c7             	mov    %rax,%rdi
  8004205066:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  800420506d:	00 00 00 
  8004205070:	ff d0                	callq  *%rax
  8004205072:	48 89 c3             	mov    %rax,%rbx
  8004205075:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205079:	48 89 c7             	mov    %rax,%rdi
  800420507c:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004205083:	00 00 00 
  8004205086:	ff d0                	callq  *%rax
  8004205088:	48 39 c3             	cmp    %rax,%rbx
  800420508b:	74 35                	je     80042050c2 <page_check+0xa8d>
  800420508d:	48 b9 40 ef 20 04 80 	movabs $0x800420ef40,%rcx
  8004205094:	00 00 00 
  8004205097:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420509e:	00 00 00 
  80042050a1:	be ef 03 00 00       	mov    $0x3ef,%esi
  80042050a6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042050ad:	00 00 00 
  80042050b0:	b8 00 00 00 00       	mov    $0x0,%eax
  80042050b5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042050bc:	00 00 00 
  80042050bf:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 2);
  80042050c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042050c6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042050ca:	66 83 f8 02          	cmp    $0x2,%ax
  80042050ce:	74 35                	je     8004205105 <page_check+0xad0>
  80042050d0:	48 b9 70 ef 20 04 80 	movabs $0x800420ef70,%rcx
  80042050d7:	00 00 00 
  80042050da:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042050e1:	00 00 00 
  80042050e4:	be f0 03 00 00       	mov    $0x3f0,%esi
  80042050e9:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042050f0:	00 00 00 
  80042050f3:	b8 00 00 00 00       	mov    $0x0,%eax
  80042050f8:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042050ff:	00 00 00 
  8004205102:	41 ff d0             	callq  *%r8

	// pp3 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
  8004205105:	bf 00 00 00 00       	mov    $0x0,%edi
  800420510a:	48 b8 36 24 20 04 80 	movabs $0x8004202436,%rax
  8004205111:	00 00 00 
  8004205114:	ff d0                	callq  *%rax
  8004205116:	48 85 c0             	test   %rax,%rax
  8004205119:	74 35                	je     8004205150 <page_check+0xb1b>
  800420511b:	48 b9 b7 ea 20 04 80 	movabs $0x800420eab7,%rcx
  8004205122:	00 00 00 
  8004205125:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420512c:	00 00 00 
  800420512f:	be f4 03 00 00       	mov    $0x3f4,%esi
  8004205134:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420513b:	00 00 00 
  800420513e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205143:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420514a:	00 00 00 
  800420514d:	41 ff d0             	callq  *%r8
	// check that pgdir_walk returns a pointer to the pte
	pdpe = KADDR(PTE_ADDR(boot_pml4e[PML4(PGSIZE)]));
  8004205150:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205157:	00 00 00 
  800420515a:	48 8b 00             	mov    (%rax),%rax
  800420515d:	48 8b 00             	mov    (%rax),%rax
  8004205160:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205166:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
  800420516a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420516e:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205172:	89 45 a4             	mov    %eax,-0x5c(%rbp)
  8004205175:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  8004205178:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  800420517f:	00 00 00 
  8004205182:	48 8b 00             	mov    (%rax),%rax
  8004205185:	48 39 c2             	cmp    %rax,%rdx
  8004205188:	72 32                	jb     80042051bc <page_check+0xb87>
  800420518a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420518e:	48 89 c1             	mov    %rax,%rcx
  8004205191:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205198:	00 00 00 
  800420519b:	be f6 03 00 00       	mov    $0x3f6,%esi
  80042051a0:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042051a7:	00 00 00 
  80042051aa:	b8 00 00 00 00       	mov    $0x0,%eax
  80042051af:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042051b6:	00 00 00 
  80042051b9:	41 ff d0             	callq  *%r8
  80042051bc:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042051c3:	00 00 00 
  80042051c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042051ca:	48 01 d0             	add    %rdx,%rax
  80042051cd:	48 89 45 98          	mov    %rax,-0x68(%rbp)
	pde = KADDR(PTE_ADDR(pdpe[PDPE(PGSIZE)]));
  80042051d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042051d5:	48 8b 00             	mov    (%rax),%rax
  80042051d8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80042051de:	48 89 45 90          	mov    %rax,-0x70(%rbp)
  80042051e2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  80042051e6:	48 c1 e8 0c          	shr    $0xc,%rax
  80042051ea:	89 45 8c             	mov    %eax,-0x74(%rbp)
  80042051ed:	8b 55 8c             	mov    -0x74(%rbp),%edx
  80042051f0:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  80042051f7:	00 00 00 
  80042051fa:	48 8b 00             	mov    (%rax),%rax
  80042051fd:	48 39 c2             	cmp    %rax,%rdx
  8004205200:	72 32                	jb     8004205234 <page_check+0xbff>
  8004205202:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205206:	48 89 c1             	mov    %rax,%rcx
  8004205209:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205210:	00 00 00 
  8004205213:	be f7 03 00 00       	mov    $0x3f7,%esi
  8004205218:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420521f:	00 00 00 
  8004205222:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205227:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420522e:	00 00 00 
  8004205231:	41 ff d0             	callq  *%r8
  8004205234:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  800420523b:	00 00 00 
  800420523e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8004205242:	48 01 d0             	add    %rdx,%rax
  8004205245:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	ptep = KADDR(PTE_ADDR(pde[PDX(PGSIZE)]));
  8004205249:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420524d:	48 8b 00             	mov    (%rax),%rax
  8004205250:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205256:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  800420525d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  8004205264:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205268:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
  800420526e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8004205274:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  800420527b:	00 00 00 
  800420527e:	48 8b 00             	mov    (%rax),%rax
  8004205281:	48 39 c2             	cmp    %rax,%rdx
  8004205284:	72 35                	jb     80042052bb <page_check+0xc86>
  8004205286:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420528d:	48 89 c1             	mov    %rax,%rcx
  8004205290:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205297:	00 00 00 
  800420529a:	be f8 03 00 00       	mov    $0x3f8,%esi
  800420529f:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042052a6:	00 00 00 
  80042052a9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042052ae:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042052b5:	00 00 00 
  80042052b8:	41 ff d0             	callq  *%r8
  80042052bb:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042052c2:	00 00 00 
  80042052c5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  80042052cc:	48 01 d0             	add    %rdx,%rax
  80042052cf:	48 89 85 f0 fe ff ff 	mov    %rax,-0x110(%rbp)
	assert(pml4e_walk(boot_pml4e, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
  80042052d6:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042052dd:	00 00 00 
  80042052e0:	48 8b 00             	mov    (%rax),%rax
  80042052e3:	ba 00 00 00 00       	mov    $0x0,%edx
  80042052e8:	be 00 10 00 00       	mov    $0x1000,%esi
  80042052ed:	48 89 c7             	mov    %rax,%rdi
  80042052f0:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  80042052f7:	00 00 00 
  80042052fa:	ff d0                	callq  *%rax
  80042052fc:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8004205303:	48 83 c2 08          	add    $0x8,%rdx
  8004205307:	48 39 d0             	cmp    %rdx,%rax
  800420530a:	74 35                	je     8004205341 <page_check+0xd0c>
  800420530c:	48 b9 88 ef 20 04 80 	movabs $0x800420ef88,%rcx
  8004205313:	00 00 00 
  8004205316:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420531d:	00 00 00 
  8004205320:	be f9 03 00 00       	mov    $0x3f9,%esi
  8004205325:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420532c:	00 00 00 
  800420532f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205334:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420533b:	00 00 00 
  800420533e:	41 ff d0             	callq  *%r8

	// should be able to change permissions too.
	assert(page_insert(boot_pml4e, pp3, (void*) PGSIZE, PTE_U) == 0);
  8004205341:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205348:	00 00 00 
  800420534b:	48 8b 00             	mov    (%rax),%rax
  800420534e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8004205352:	b9 04 00 00 00       	mov    $0x4,%ecx
  8004205357:	ba 00 10 00 00       	mov    $0x1000,%edx
  800420535c:	48 89 c7             	mov    %rax,%rdi
  800420535f:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004205366:	00 00 00 
  8004205369:	ff d0                	callq  *%rax
  800420536b:	85 c0                	test   %eax,%eax
  800420536d:	74 35                	je     80042053a4 <page_check+0xd6f>
  800420536f:	48 b9 c8 ef 20 04 80 	movabs $0x800420efc8,%rcx
  8004205376:	00 00 00 
  8004205379:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205380:	00 00 00 
  8004205383:	be fc 03 00 00       	mov    $0x3fc,%esi
  8004205388:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420538f:	00 00 00 
  8004205392:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205397:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420539e:	00 00 00 
  80042053a1:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == page2pa(pp3));
  80042053a4:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042053ab:	00 00 00 
  80042053ae:	48 8b 00             	mov    (%rax),%rax
  80042053b1:	be 00 10 00 00       	mov    $0x1000,%esi
  80042053b6:	48 89 c7             	mov    %rax,%rdi
  80042053b9:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  80042053c0:	00 00 00 
  80042053c3:	ff d0                	callq  *%rax
  80042053c5:	48 89 c3             	mov    %rax,%rbx
  80042053c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042053cc:	48 89 c7             	mov    %rax,%rdi
  80042053cf:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042053d6:	00 00 00 
  80042053d9:	ff d0                	callq  *%rax
  80042053db:	48 39 c3             	cmp    %rax,%rbx
  80042053de:	74 35                	je     8004205415 <page_check+0xde0>
  80042053e0:	48 b9 40 ef 20 04 80 	movabs $0x800420ef40,%rcx
  80042053e7:	00 00 00 
  80042053ea:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042053f1:	00 00 00 
  80042053f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  80042053f9:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205400:	00 00 00 
  8004205403:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205408:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420540f:	00 00 00 
  8004205412:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 2);
  8004205415:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205419:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420541d:	66 83 f8 02          	cmp    $0x2,%ax
  8004205421:	74 35                	je     8004205458 <page_check+0xe23>
  8004205423:	48 b9 70 ef 20 04 80 	movabs $0x800420ef70,%rcx
  800420542a:	00 00 00 
  800420542d:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205434:	00 00 00 
  8004205437:	be fe 03 00 00       	mov    $0x3fe,%esi
  800420543c:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205443:	00 00 00 
  8004205446:	b8 00 00 00 00       	mov    $0x0,%eax
  800420544b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205452:	00 00 00 
  8004205455:	41 ff d0             	callq  *%r8
	assert(*pml4e_walk(boot_pml4e, (void*) PGSIZE, 0) & PTE_U);
  8004205458:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  800420545f:	00 00 00 
  8004205462:	48 8b 00             	mov    (%rax),%rax
  8004205465:	ba 00 00 00 00       	mov    $0x0,%edx
  800420546a:	be 00 10 00 00       	mov    $0x1000,%esi
  800420546f:	48 89 c7             	mov    %rax,%rdi
  8004205472:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004205479:	00 00 00 
  800420547c:	ff d0                	callq  *%rax
  800420547e:	48 8b 00             	mov    (%rax),%rax
  8004205481:	83 e0 04             	and    $0x4,%eax
  8004205484:	48 85 c0             	test   %rax,%rax
  8004205487:	75 35                	jne    80042054be <page_check+0xe89>
  8004205489:	48 b9 08 f0 20 04 80 	movabs $0x800420f008,%rcx
  8004205490:	00 00 00 
  8004205493:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420549a:	00 00 00 
  800420549d:	be ff 03 00 00       	mov    $0x3ff,%esi
  80042054a2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042054a9:	00 00 00 
  80042054ac:	b8 00 00 00 00       	mov    $0x0,%eax
  80042054b1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042054b8:	00 00 00 
  80042054bb:	41 ff d0             	callq  *%r8
	assert(boot_pml4e[0] & PTE_U);
  80042054be:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042054c5:	00 00 00 
  80042054c8:	48 8b 00             	mov    (%rax),%rax
  80042054cb:	48 8b 00             	mov    (%rax),%rax
  80042054ce:	83 e0 04             	and    $0x4,%eax
  80042054d1:	48 85 c0             	test   %rax,%rax
  80042054d4:	75 35                	jne    800420550b <page_check+0xed6>
  80042054d6:	48 b9 3b f0 20 04 80 	movabs $0x800420f03b,%rcx
  80042054dd:	00 00 00 
  80042054e0:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042054e7:	00 00 00 
  80042054ea:	be 00 04 00 00       	mov    $0x400,%esi
  80042054ef:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042054f6:	00 00 00 
  80042054f9:	b8 00 00 00 00       	mov    $0x0,%eax
  80042054fe:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205505:	00 00 00 
  8004205508:	41 ff d0             	callq  *%r8


	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(boot_pml4e, pp0, (void*) PTSIZE, 0) < 0);
  800420550b:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205512:	00 00 00 
  8004205515:	48 8b 00             	mov    (%rax),%rax
  8004205518:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420551c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004205521:	ba 00 00 20 00       	mov    $0x200000,%edx
  8004205526:	48 89 c7             	mov    %rax,%rdi
  8004205529:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004205530:	00 00 00 
  8004205533:	ff d0                	callq  *%rax
  8004205535:	85 c0                	test   %eax,%eax
  8004205537:	78 35                	js     800420556e <page_check+0xf39>
  8004205539:	48 b9 58 f0 20 04 80 	movabs $0x800420f058,%rcx
  8004205540:	00 00 00 
  8004205543:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420554a:	00 00 00 
  800420554d:	be 04 04 00 00       	mov    $0x404,%esi
  8004205552:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205559:	00 00 00 
  800420555c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205561:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205568:	00 00 00 
  800420556b:	41 ff d0             	callq  *%r8

	// insert pp1 at PGSIZE (replacing pp3)
	assert(page_insert(boot_pml4e, pp1, (void*) PGSIZE, 0) == 0);
  800420556e:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205575:	00 00 00 
  8004205578:	48 8b 00             	mov    (%rax),%rax
  800420557b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800420557f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004205584:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004205589:	48 89 c7             	mov    %rax,%rdi
  800420558c:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004205593:	00 00 00 
  8004205596:	ff d0                	callq  *%rax
  8004205598:	85 c0                	test   %eax,%eax
  800420559a:	74 35                	je     80042055d1 <page_check+0xf9c>
  800420559c:	48 b9 90 f0 20 04 80 	movabs $0x800420f090,%rcx
  80042055a3:	00 00 00 
  80042055a6:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042055ad:	00 00 00 
  80042055b0:	be 07 04 00 00       	mov    $0x407,%esi
  80042055b5:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042055bc:	00 00 00 
  80042055bf:	b8 00 00 00 00       	mov    $0x0,%eax
  80042055c4:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042055cb:	00 00 00 
  80042055ce:	41 ff d0             	callq  *%r8
	assert(!(*pml4e_walk(boot_pml4e, (void*) PGSIZE, 0) & PTE_U));
  80042055d1:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042055d8:	00 00 00 
  80042055db:	48 8b 00             	mov    (%rax),%rax
  80042055de:	ba 00 00 00 00       	mov    $0x0,%edx
  80042055e3:	be 00 10 00 00       	mov    $0x1000,%esi
  80042055e8:	48 89 c7             	mov    %rax,%rdi
  80042055eb:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  80042055f2:	00 00 00 
  80042055f5:	ff d0                	callq  *%rax
  80042055f7:	48 8b 00             	mov    (%rax),%rax
  80042055fa:	83 e0 04             	and    $0x4,%eax
  80042055fd:	48 85 c0             	test   %rax,%rax
  8004205600:	74 35                	je     8004205637 <page_check+0x1002>
  8004205602:	48 b9 c8 f0 20 04 80 	movabs $0x800420f0c8,%rcx
  8004205609:	00 00 00 
  800420560c:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205613:	00 00 00 
  8004205616:	be 08 04 00 00       	mov    $0x408,%esi
  800420561b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205622:	00 00 00 
  8004205625:	b8 00 00 00 00       	mov    $0x0,%eax
  800420562a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205631:	00 00 00 
  8004205634:	41 ff d0             	callq  *%r8

	// should have pp1 at both 0 and PGSIZE
	assert(check_va2pa(boot_pml4e, 0) == page2pa(pp1));
  8004205637:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  800420563e:	00 00 00 
  8004205641:	48 8b 00             	mov    (%rax),%rax
  8004205644:	be 00 00 00 00       	mov    $0x0,%esi
  8004205649:	48 89 c7             	mov    %rax,%rdi
  800420564c:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004205653:	00 00 00 
  8004205656:	ff d0                	callq  *%rax
  8004205658:	48 89 c3             	mov    %rax,%rbx
  800420565b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420565f:	48 89 c7             	mov    %rax,%rdi
  8004205662:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  8004205669:	00 00 00 
  800420566c:	ff d0                	callq  *%rax
  800420566e:	48 39 c3             	cmp    %rax,%rbx
  8004205671:	74 35                	je     80042056a8 <page_check+0x1073>
  8004205673:	48 b9 00 f1 20 04 80 	movabs $0x800420f100,%rcx
  800420567a:	00 00 00 
  800420567d:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205684:	00 00 00 
  8004205687:	be 0b 04 00 00       	mov    $0x40b,%esi
  800420568c:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205693:	00 00 00 
  8004205696:	b8 00 00 00 00       	mov    $0x0,%eax
  800420569b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042056a2:	00 00 00 
  80042056a5:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == page2pa(pp1));
  80042056a8:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042056af:	00 00 00 
  80042056b2:	48 8b 00             	mov    (%rax),%rax
  80042056b5:	be 00 10 00 00       	mov    $0x1000,%esi
  80042056ba:	48 89 c7             	mov    %rax,%rdi
  80042056bd:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  80042056c4:	00 00 00 
  80042056c7:	ff d0                	callq  *%rax
  80042056c9:	48 89 c3             	mov    %rax,%rbx
  80042056cc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042056d0:	48 89 c7             	mov    %rax,%rdi
  80042056d3:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  80042056da:	00 00 00 
  80042056dd:	ff d0                	callq  *%rax
  80042056df:	48 39 c3             	cmp    %rax,%rbx
  80042056e2:	74 35                	je     8004205719 <page_check+0x10e4>
  80042056e4:	48 b9 30 f1 20 04 80 	movabs $0x800420f130,%rcx
  80042056eb:	00 00 00 
  80042056ee:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042056f5:	00 00 00 
  80042056f8:	be 0c 04 00 00       	mov    $0x40c,%esi
  80042056fd:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205704:	00 00 00 
  8004205707:	b8 00 00 00 00       	mov    $0x0,%eax
  800420570c:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205713:	00 00 00 
  8004205716:	41 ff d0             	callq  *%r8
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
  8004205719:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420571d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205721:	66 83 f8 02          	cmp    $0x2,%ax
  8004205725:	74 35                	je     800420575c <page_check+0x1127>
  8004205727:	48 b9 60 f1 20 04 80 	movabs $0x800420f160,%rcx
  800420572e:	00 00 00 
  8004205731:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205738:	00 00 00 
  800420573b:	be 0e 04 00 00       	mov    $0x40e,%esi
  8004205740:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205747:	00 00 00 
  800420574a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420574f:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205756:	00 00 00 
  8004205759:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 1);
  800420575c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205760:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205764:	66 83 f8 01          	cmp    $0x1,%ax
  8004205768:	74 35                	je     800420579f <page_check+0x116a>
  800420576a:	48 b9 71 f1 20 04 80 	movabs $0x800420f171,%rcx
  8004205771:	00 00 00 
  8004205774:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420577b:	00 00 00 
  800420577e:	be 0f 04 00 00       	mov    $0x40f,%esi
  8004205783:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420578a:	00 00 00 
  800420578d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205792:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205799:	00 00 00 
  800420579c:	41 ff d0             	callq  *%r8


	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(boot_pml4e, 0x0);
  800420579f:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042057a6:	00 00 00 
  80042057a9:	48 8b 00             	mov    (%rax),%rax
  80042057ac:	be 00 00 00 00       	mov    $0x0,%esi
  80042057b1:	48 89 c7             	mov    %rax,%rdi
  80042057b4:	48 b8 89 2e 20 04 80 	movabs $0x8004202e89,%rax
  80042057bb:	00 00 00 
  80042057be:	ff d0                	callq  *%rax
	assert(check_va2pa(boot_pml4e, 0x0) == ~0);
  80042057c0:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  80042057c7:	00 00 00 
  80042057ca:	48 8b 00             	mov    (%rax),%rax
  80042057cd:	be 00 00 00 00       	mov    $0x0,%esi
  80042057d2:	48 89 c7             	mov    %rax,%rdi
  80042057d5:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  80042057dc:	00 00 00 
  80042057df:	ff d0                	callq  *%rax
  80042057e1:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  80042057e5:	74 35                	je     800420581c <page_check+0x11e7>
  80042057e7:	48 b9 88 f1 20 04 80 	movabs $0x800420f188,%rcx
  80042057ee:	00 00 00 
  80042057f1:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042057f8:	00 00 00 
  80042057fb:	be 14 04 00 00       	mov    $0x414,%esi
  8004205800:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205807:	00 00 00 
  800420580a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420580f:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205816:	00 00 00 
  8004205819:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == page2pa(pp1));
  800420581c:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205823:	00 00 00 
  8004205826:	48 8b 00             	mov    (%rax),%rax
  8004205829:	be 00 10 00 00       	mov    $0x1000,%esi
  800420582e:	48 89 c7             	mov    %rax,%rdi
  8004205831:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004205838:	00 00 00 
  800420583b:	ff d0                	callq  *%rax
  800420583d:	48 89 c3             	mov    %rax,%rbx
  8004205840:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205844:	48 89 c7             	mov    %rax,%rdi
  8004205847:	48 b8 21 13 20 04 80 	movabs $0x8004201321,%rax
  800420584e:	00 00 00 
  8004205851:	ff d0                	callq  *%rax
  8004205853:	48 39 c3             	cmp    %rax,%rbx
  8004205856:	74 35                	je     800420588d <page_check+0x1258>
  8004205858:	48 b9 30 f1 20 04 80 	movabs $0x800420f130,%rcx
  800420585f:	00 00 00 
  8004205862:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205869:	00 00 00 
  800420586c:	be 15 04 00 00       	mov    $0x415,%esi
  8004205871:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205878:	00 00 00 
  800420587b:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205880:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205887:	00 00 00 
  800420588a:	41 ff d0             	callq  *%r8
	assert(pp1->pp_ref == 1);
  800420588d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205891:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205895:	66 83 f8 01          	cmp    $0x1,%ax
  8004205899:	74 35                	je     80042058d0 <page_check+0x129b>
  800420589b:	48 b9 d5 ee 20 04 80 	movabs $0x800420eed5,%rcx
  80042058a2:	00 00 00 
  80042058a5:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042058ac:	00 00 00 
  80042058af:	be 16 04 00 00       	mov    $0x416,%esi
  80042058b4:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042058bb:	00 00 00 
  80042058be:	b8 00 00 00 00       	mov    $0x0,%eax
  80042058c3:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042058ca:	00 00 00 
  80042058cd:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 1);
  80042058d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042058d4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042058d8:	66 83 f8 01          	cmp    $0x1,%ax
  80042058dc:	74 35                	je     8004205913 <page_check+0x12de>
  80042058de:	48 b9 71 f1 20 04 80 	movabs $0x800420f171,%rcx
  80042058e5:	00 00 00 
  80042058e8:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042058ef:	00 00 00 
  80042058f2:	be 17 04 00 00       	mov    $0x417,%esi
  80042058f7:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042058fe:	00 00 00 
  8004205901:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205906:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420590d:	00 00 00 
  8004205910:	41 ff d0             	callq  *%r8

	// Test re-inserting pp1 at PGSIZE.
	// Thanks to Varun Agrawal for suggesting this test case.
	assert(page_insert(boot_pml4e, pp1, (void*) PGSIZE, 0) == 0);
  8004205913:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  800420591a:	00 00 00 
  800420591d:	48 8b 00             	mov    (%rax),%rax
  8004205920:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004205924:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004205929:	ba 00 10 00 00       	mov    $0x1000,%edx
  800420592e:	48 89 c7             	mov    %rax,%rdi
  8004205931:	48 b8 3c 2d 20 04 80 	movabs $0x8004202d3c,%rax
  8004205938:	00 00 00 
  800420593b:	ff d0                	callq  *%rax
  800420593d:	85 c0                	test   %eax,%eax
  800420593f:	74 35                	je     8004205976 <page_check+0x1341>
  8004205941:	48 b9 90 f0 20 04 80 	movabs $0x800420f090,%rcx
  8004205948:	00 00 00 
  800420594b:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205952:	00 00 00 
  8004205955:	be 1b 04 00 00       	mov    $0x41b,%esi
  800420595a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205961:	00 00 00 
  8004205964:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205969:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205970:	00 00 00 
  8004205973:	41 ff d0             	callq  *%r8
	assert(pp1->pp_ref);
  8004205976:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420597a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420597e:	66 85 c0             	test   %ax,%ax
  8004205981:	75 35                	jne    80042059b8 <page_check+0x1383>
  8004205983:	48 b9 ab f1 20 04 80 	movabs $0x800420f1ab,%rcx
  800420598a:	00 00 00 
  800420598d:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205994:	00 00 00 
  8004205997:	be 1c 04 00 00       	mov    $0x41c,%esi
  800420599c:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042059a3:	00 00 00 
  80042059a6:	b8 00 00 00 00       	mov    $0x0,%eax
  80042059ab:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042059b2:	00 00 00 
  80042059b5:	41 ff d0             	callq  *%r8
	assert(pp1->pp_link == NULL);
  80042059b8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042059bc:	48 8b 00             	mov    (%rax),%rax
  80042059bf:	48 85 c0             	test   %rax,%rax
  80042059c2:	74 35                	je     80042059f9 <page_check+0x13c4>
  80042059c4:	48 b9 b7 f1 20 04 80 	movabs $0x800420f1b7,%rcx
  80042059cb:	00 00 00 
  80042059ce:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042059d5:	00 00 00 
  80042059d8:	be 1d 04 00 00       	mov    $0x41d,%esi
  80042059dd:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042059e4:	00 00 00 
  80042059e7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042059ec:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042059f3:	00 00 00 
  80042059f6:	41 ff d0             	callq  *%r8

	// unmapping pp1 at PGSIZE should free it
	page_remove(boot_pml4e, (void*) PGSIZE);
  80042059f9:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205a00:	00 00 00 
  8004205a03:	48 8b 00             	mov    (%rax),%rax
  8004205a06:	be 00 10 00 00       	mov    $0x1000,%esi
  8004205a0b:	48 89 c7             	mov    %rax,%rdi
  8004205a0e:	48 b8 89 2e 20 04 80 	movabs $0x8004202e89,%rax
  8004205a15:	00 00 00 
  8004205a18:	ff d0                	callq  *%rax
	assert(check_va2pa(boot_pml4e, 0x0) == ~0);
  8004205a1a:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205a21:	00 00 00 
  8004205a24:	48 8b 00             	mov    (%rax),%rax
  8004205a27:	be 00 00 00 00       	mov    $0x0,%esi
  8004205a2c:	48 89 c7             	mov    %rax,%rdi
  8004205a2f:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004205a36:	00 00 00 
  8004205a39:	ff d0                	callq  *%rax
  8004205a3b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  8004205a3f:	74 35                	je     8004205a76 <page_check+0x1441>
  8004205a41:	48 b9 88 f1 20 04 80 	movabs $0x800420f188,%rcx
  8004205a48:	00 00 00 
  8004205a4b:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205a52:	00 00 00 
  8004205a55:	be 21 04 00 00       	mov    $0x421,%esi
  8004205a5a:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205a61:	00 00 00 
  8004205a64:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205a69:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205a70:	00 00 00 
  8004205a73:	41 ff d0             	callq  *%r8
	assert(check_va2pa(boot_pml4e, PGSIZE) == ~0);
  8004205a76:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205a7d:	00 00 00 
  8004205a80:	48 8b 00             	mov    (%rax),%rax
  8004205a83:	be 00 10 00 00       	mov    $0x1000,%esi
  8004205a88:	48 89 c7             	mov    %rax,%rdi
  8004205a8b:	48 b8 bb 43 20 04 80 	movabs $0x80042043bb,%rax
  8004205a92:	00 00 00 
  8004205a95:	ff d0                	callq  *%rax
  8004205a97:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  8004205a9b:	74 35                	je     8004205ad2 <page_check+0x149d>
  8004205a9d:	48 b9 d0 f1 20 04 80 	movabs $0x800420f1d0,%rcx
  8004205aa4:	00 00 00 
  8004205aa7:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205aae:	00 00 00 
  8004205ab1:	be 22 04 00 00       	mov    $0x422,%esi
  8004205ab6:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205abd:	00 00 00 
  8004205ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205ac5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205acc:	00 00 00 
  8004205acf:	41 ff d0             	callq  *%r8
	assert(pp1->pp_ref == 0);
  8004205ad2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004205ad6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205ada:	66 85 c0             	test   %ax,%ax
  8004205add:	74 35                	je     8004205b14 <page_check+0x14df>
  8004205adf:	48 b9 f6 f1 20 04 80 	movabs $0x800420f1f6,%rcx
  8004205ae6:	00 00 00 
  8004205ae9:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205af0:	00 00 00 
  8004205af3:	be 23 04 00 00       	mov    $0x423,%esi
  8004205af8:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205aff:	00 00 00 
  8004205b02:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205b07:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205b0e:	00 00 00 
  8004205b11:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 1);
  8004205b14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205b18:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205b1c:	66 83 f8 01          	cmp    $0x1,%ax
  8004205b20:	74 35                	je     8004205b57 <page_check+0x1522>
  8004205b22:	48 b9 71 f1 20 04 80 	movabs $0x800420f171,%rcx
  8004205b29:	00 00 00 
  8004205b2c:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205b33:	00 00 00 
  8004205b36:	be 24 04 00 00       	mov    $0x424,%esi
  8004205b3b:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205b42:	00 00 00 
  8004205b45:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205b4a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205b51:	00 00 00 
  8004205b54:	41 ff d0             	callq  *%r8
	page_remove(boot_pgdir, 0x0);
	assert(pp2->pp_ref == 0);
#endif

	// forcibly take pp3 back
	struct PageInfo *pp_l1 = pa2page(PTE_ADDR(boot_pml4e[0]));
  8004205b57:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205b5e:	00 00 00 
  8004205b61:	48 8b 00             	mov    (%rax),%rax
  8004205b64:	48 8b 00             	mov    (%rax),%rax
  8004205b67:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205b6d:	48 89 c7             	mov    %rax,%rdi
  8004205b70:	48 b8 46 13 20 04 80 	movabs $0x8004201346,%rax
  8004205b77:	00 00 00 
  8004205b7a:	ff d0                	callq  *%rax
  8004205b7c:	48 89 85 68 ff ff ff 	mov    %rax,-0x98(%rbp)
	boot_pml4e[0] = 0;
  8004205b83:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205b8a:	00 00 00 
  8004205b8d:	48 8b 00             	mov    (%rax),%rax
  8004205b90:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(pp3->pp_ref == 1);
  8004205b97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205b9b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004205b9f:	66 83 f8 01          	cmp    $0x1,%ax
  8004205ba3:	74 35                	je     8004205bda <page_check+0x15a5>
  8004205ba5:	48 b9 71 f1 20 04 80 	movabs $0x800420f171,%rcx
  8004205bac:	00 00 00 
  8004205baf:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205bb6:	00 00 00 
  8004205bb9:	be 3a 04 00 00       	mov    $0x43a,%esi
  8004205bbe:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205bc5:	00 00 00 
  8004205bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205bcd:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205bd4:	00 00 00 
  8004205bd7:	41 ff d0             	callq  *%r8
	page_decref(pp_l1);
  8004205bda:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004205be1:	48 89 c7             	mov    %rax,%rdi
  8004205be4:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004205beb:	00 00 00 
  8004205bee:	ff d0                	callq  *%rax
	// check pointer arithmetic in pml4e_walk
	if (pp_l1 != pp3) page_decref(pp3);
  8004205bf0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004205bf7:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  8004205bfb:	74 13                	je     8004205c10 <page_check+0x15db>
  8004205bfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004205c01:	48 89 c7             	mov    %rax,%rdi
  8004205c04:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004205c0b:	00 00 00 
  8004205c0e:	ff d0                	callq  *%rax
	if (pp_l1 != pp2) page_decref(pp2);
  8004205c10:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004205c17:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8004205c1b:	74 13                	je     8004205c30 <page_check+0x15fb>
  8004205c1d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004205c21:	48 89 c7             	mov    %rax,%rdi
  8004205c24:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004205c2b:	00 00 00 
  8004205c2e:	ff d0                	callq  *%rax
	if (pp_l1 != pp0) page_decref(pp0);
  8004205c30:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004205c37:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  8004205c3b:	74 13                	je     8004205c50 <page_check+0x161b>
  8004205c3d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004205c41:	48 89 c7             	mov    %rax,%rdi
  8004205c44:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004205c4b:	00 00 00 
  8004205c4e:	ff d0                	callq  *%rax
	va = (void*)(PGSIZE * 100);
  8004205c50:	48 c7 85 60 ff ff ff 	movq   $0x64000,-0xa0(%rbp)
  8004205c57:	00 40 06 00 
	ptep = pml4e_walk(boot_pml4e, va, 1);
  8004205c5b:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205c62:	00 00 00 
  8004205c65:	48 8b 00             	mov    (%rax),%rax
  8004205c68:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004205c6f:	ba 01 00 00 00       	mov    $0x1,%edx
  8004205c74:	48 89 ce             	mov    %rcx,%rsi
  8004205c77:	48 89 c7             	mov    %rax,%rdi
  8004205c7a:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004205c81:	00 00 00 
  8004205c84:	ff d0                	callq  *%rax
  8004205c86:	48 89 85 f0 fe ff ff 	mov    %rax,-0x110(%rbp)
	pdpe = KADDR(PTE_ADDR(boot_pml4e[PML4(va)]));
  8004205c8d:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205c94:	00 00 00 
  8004205c97:	48 8b 00             	mov    (%rax),%rax
  8004205c9a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004205ca1:	48 c1 ea 27          	shr    $0x27,%rdx
  8004205ca5:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  8004205cab:	48 c1 e2 03          	shl    $0x3,%rdx
  8004205caf:	48 01 d0             	add    %rdx,%rax
  8004205cb2:	48 8b 00             	mov    (%rax),%rax
  8004205cb5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205cbb:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
  8004205cc2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004205cc9:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205ccd:	89 85 54 ff ff ff    	mov    %eax,-0xac(%rbp)
  8004205cd3:	8b 95 54 ff ff ff    	mov    -0xac(%rbp),%edx
  8004205cd9:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004205ce0:	00 00 00 
  8004205ce3:	48 8b 00             	mov    (%rax),%rax
  8004205ce6:	48 39 c2             	cmp    %rax,%rdx
  8004205ce9:	72 35                	jb     8004205d20 <page_check+0x16eb>
  8004205ceb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004205cf2:	48 89 c1             	mov    %rax,%rcx
  8004205cf5:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205cfc:	00 00 00 
  8004205cff:	be 42 04 00 00       	mov    $0x442,%esi
  8004205d04:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205d0b:	00 00 00 
  8004205d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205d13:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205d1a:	00 00 00 
  8004205d1d:	41 ff d0             	callq  *%r8
  8004205d20:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004205d27:	00 00 00 
  8004205d2a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004205d31:	48 01 d0             	add    %rdx,%rax
  8004205d34:	48 89 45 98          	mov    %rax,-0x68(%rbp)
	pde  = KADDR(PTE_ADDR(pdpe[PDPE(va)]));
  8004205d38:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8004205d3f:	48 c1 e8 1e          	shr    $0x1e,%rax
  8004205d43:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004205d48:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004205d4f:	00 
  8004205d50:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205d54:	48 01 d0             	add    %rdx,%rax
  8004205d57:	48 8b 00             	mov    (%rax),%rax
  8004205d5a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205d60:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  8004205d67:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004205d6e:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205d72:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%rbp)
  8004205d78:	8b 95 44 ff ff ff    	mov    -0xbc(%rbp),%edx
  8004205d7e:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004205d85:	00 00 00 
  8004205d88:	48 8b 00             	mov    (%rax),%rax
  8004205d8b:	48 39 c2             	cmp    %rax,%rdx
  8004205d8e:	72 35                	jb     8004205dc5 <page_check+0x1790>
  8004205d90:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004205d97:	48 89 c1             	mov    %rax,%rcx
  8004205d9a:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205da1:	00 00 00 
  8004205da4:	be 43 04 00 00       	mov    $0x443,%esi
  8004205da9:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205db0:	00 00 00 
  8004205db3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205db8:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205dbf:	00 00 00 
  8004205dc2:	41 ff d0             	callq  *%r8
  8004205dc5:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004205dcc:	00 00 00 
  8004205dcf:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004205dd6:	48 01 d0             	add    %rdx,%rax
  8004205dd9:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	ptep1 = KADDR(PTE_ADDR(pde[PDX(va)]));
  8004205ddd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8004205de4:	48 c1 e8 15          	shr    $0x15,%rax
  8004205de8:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004205ded:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004205df4:	00 
  8004205df5:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004205df9:	48 01 d0             	add    %rdx,%rax
  8004205dfc:	48 8b 00             	mov    (%rax),%rax
  8004205dff:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205e05:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004205e0c:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8004205e13:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205e17:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%rbp)
  8004205e1d:	8b 95 34 ff ff ff    	mov    -0xcc(%rbp),%edx
  8004205e23:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004205e2a:	00 00 00 
  8004205e2d:	48 8b 00             	mov    (%rax),%rax
  8004205e30:	48 39 c2             	cmp    %rax,%rdx
  8004205e33:	72 35                	jb     8004205e6a <page_check+0x1835>
  8004205e35:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8004205e3c:	48 89 c1             	mov    %rax,%rcx
  8004205e3f:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205e46:	00 00 00 
  8004205e49:	be 44 04 00 00       	mov    $0x444,%esi
  8004205e4e:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205e55:	00 00 00 
  8004205e58:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205e5d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205e64:	00 00 00 
  8004205e67:	41 ff d0             	callq  *%r8
  8004205e6a:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004205e71:	00 00 00 
  8004205e74:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8004205e7b:	48 01 d0             	add    %rdx,%rax
  8004205e7e:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	assert(ptep == ptep1 + PTX(va));
  8004205e85:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8004205e8c:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205e90:	25 ff 01 00 00       	and    $0x1ff,%eax
  8004205e95:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004205e9c:	00 
  8004205e9d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004205ea4:	48 01 c2             	add    %rax,%rdx
  8004205ea7:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8004205eae:	48 39 c2             	cmp    %rax,%rdx
  8004205eb1:	74 35                	je     8004205ee8 <page_check+0x18b3>
  8004205eb3:	48 b9 07 f2 20 04 80 	movabs $0x800420f207,%rcx
  8004205eba:	00 00 00 
  8004205ebd:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004205ec4:	00 00 00 
  8004205ec7:	be 45 04 00 00       	mov    $0x445,%esi
  8004205ecc:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205ed3:	00 00 00 
  8004205ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205edb:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205ee2:	00 00 00 
  8004205ee5:	41 ff d0             	callq  *%r8

	// check that new page tables get cleared
	memset(page2kva(pp4), 0xFF, PGSIZE);
  8004205ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004205eec:	48 89 c7             	mov    %rax,%rdi
  8004205eef:	48 b8 b7 13 20 04 80 	movabs $0x80042013b7,%rax
  8004205ef6:	00 00 00 
  8004205ef9:	ff d0                	callq  *%rax
  8004205efb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8004205f00:	be ff 00 00 00       	mov    $0xff,%esi
  8004205f05:	48 89 c7             	mov    %rax,%rdi
  8004205f08:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  8004205f0f:	00 00 00 
  8004205f12:	ff d0                	callq  *%rax
	pml4e_walk(boot_pml4e, 0x0, 1);
  8004205f14:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205f1b:	00 00 00 
  8004205f1e:	48 8b 00             	mov    (%rax),%rax
  8004205f21:	ba 01 00 00 00       	mov    $0x1,%edx
  8004205f26:	be 00 00 00 00       	mov    $0x0,%esi
  8004205f2b:	48 89 c7             	mov    %rax,%rdi
  8004205f2e:	48 b8 a6 25 20 04 80 	movabs $0x80042025a6,%rax
  8004205f35:	00 00 00 
  8004205f38:	ff d0                	callq  *%rax
	pdpe = KADDR(PTE_ADDR(boot_pml4e[0]));
  8004205f3a:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004205f41:	00 00 00 
  8004205f44:	48 8b 00             	mov    (%rax),%rax
  8004205f47:	48 8b 00             	mov    (%rax),%rax
  8004205f4a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205f50:	48 89 85 20 ff ff ff 	mov    %rax,-0xe0(%rbp)
  8004205f57:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  8004205f5e:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205f62:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%rbp)
  8004205f68:	8b 95 1c ff ff ff    	mov    -0xe4(%rbp),%edx
  8004205f6e:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004205f75:	00 00 00 
  8004205f78:	48 8b 00             	mov    (%rax),%rax
  8004205f7b:	48 39 c2             	cmp    %rax,%rdx
  8004205f7e:	72 35                	jb     8004205fb5 <page_check+0x1980>
  8004205f80:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  8004205f87:	48 89 c1             	mov    %rax,%rcx
  8004205f8a:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  8004205f91:	00 00 00 
  8004205f94:	be 4a 04 00 00       	mov    $0x44a,%esi
  8004205f99:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004205fa0:	00 00 00 
  8004205fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004205fa8:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004205faf:	00 00 00 
  8004205fb2:	41 ff d0             	callq  *%r8
  8004205fb5:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004205fbc:	00 00 00 
  8004205fbf:	48 8b 85 20 ff ff ff 	mov    -0xe0(%rbp),%rax
  8004205fc6:	48 01 d0             	add    %rdx,%rax
  8004205fc9:	48 89 45 98          	mov    %rax,-0x68(%rbp)
	pde  = KADDR(PTE_ADDR(pdpe[0]));
  8004205fcd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004205fd1:	48 8b 00             	mov    (%rax),%rax
  8004205fd4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004205fda:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
  8004205fe1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004205fe8:	48 c1 e8 0c          	shr    $0xc,%rax
  8004205fec:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%rbp)
  8004205ff2:	8b 95 0c ff ff ff    	mov    -0xf4(%rbp),%edx
  8004205ff8:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004205fff:	00 00 00 
  8004206002:	48 8b 00             	mov    (%rax),%rax
  8004206005:	48 39 c2             	cmp    %rax,%rdx
  8004206008:	72 35                	jb     800420603f <page_check+0x1a0a>
  800420600a:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004206011:	48 89 c1             	mov    %rax,%rcx
  8004206014:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  800420601b:	00 00 00 
  800420601e:	be 4b 04 00 00       	mov    $0x44b,%esi
  8004206023:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420602a:	00 00 00 
  800420602d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206032:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004206039:	00 00 00 
  800420603c:	41 ff d0             	callq  *%r8
  800420603f:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  8004206046:	00 00 00 
  8004206049:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8004206050:	48 01 d0             	add    %rdx,%rax
  8004206053:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	ptep  = KADDR(PTE_ADDR(pde[0]));
  8004206057:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420605b:	48 8b 00             	mov    (%rax),%rax
  800420605e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8004206064:	48 89 85 00 ff ff ff 	mov    %rax,-0x100(%rbp)
  800420606b:	48 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%rax
  8004206072:	48 c1 e8 0c          	shr    $0xc,%rax
  8004206076:	89 85 fc fe ff ff    	mov    %eax,-0x104(%rbp)
  800420607c:	8b 95 fc fe ff ff    	mov    -0x104(%rbp),%edx
  8004206082:	48 b8 88 2d 22 04 80 	movabs $0x8004222d88,%rax
  8004206089:	00 00 00 
  800420608c:	48 8b 00             	mov    (%rax),%rax
  800420608f:	48 39 c2             	cmp    %rax,%rdx
  8004206092:	72 35                	jb     80042060c9 <page_check+0x1a94>
  8004206094:	48 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%rax
  800420609b:	48 89 c1             	mov    %rax,%rcx
  800420609e:	48 ba 48 e6 20 04 80 	movabs $0x800420e648,%rdx
  80042060a5:	00 00 00 
  80042060a8:	be 4c 04 00 00       	mov    $0x44c,%esi
  80042060ad:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042060b4:	00 00 00 
  80042060b7:	b8 00 00 00 00       	mov    $0x0,%eax
  80042060bc:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042060c3:	00 00 00 
  80042060c6:	41 ff d0             	callq  *%r8
  80042060c9:	48 ba 00 00 00 04 80 	movabs $0x8004000000,%rdx
  80042060d0:	00 00 00 
  80042060d3:	48 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%rax
  80042060da:	48 01 d0             	add    %rdx,%rax
  80042060dd:	48 89 85 f0 fe ff ff 	mov    %rax,-0x110(%rbp)
	for(i=0; i<NPTENTRIES; i++)
  80042060e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80042060eb:	eb 58                	jmp    8004206145 <page_check+0x1b10>
		assert((ptep[i] & PTE_P) == 0);
  80042060ed:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  80042060f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80042060f7:	48 63 d2             	movslq %edx,%rdx
  80042060fa:	48 c1 e2 03          	shl    $0x3,%rdx
  80042060fe:	48 01 d0             	add    %rdx,%rax
  8004206101:	48 8b 00             	mov    (%rax),%rax
  8004206104:	83 e0 01             	and    $0x1,%eax
  8004206107:	48 85 c0             	test   %rax,%rax
  800420610a:	74 35                	je     8004206141 <page_check+0x1b0c>
  800420610c:	48 b9 1f f2 20 04 80 	movabs $0x800420f21f,%rcx
  8004206113:	00 00 00 
  8004206116:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420611d:	00 00 00 
  8004206120:	be 4e 04 00 00       	mov    $0x44e,%esi
  8004206125:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420612c:	00 00 00 
  800420612f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206134:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420613b:	00 00 00 
  800420613e:	41 ff d0             	callq  *%r8
	memset(page2kva(pp4), 0xFF, PGSIZE);
	pml4e_walk(boot_pml4e, 0x0, 1);
	pdpe = KADDR(PTE_ADDR(boot_pml4e[0]));
	pde  = KADDR(PTE_ADDR(pdpe[0]));
	ptep  = KADDR(PTE_ADDR(pde[0]));
	for(i=0; i<NPTENTRIES; i++)
  8004206141:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8004206145:	81 7d ec ff 01 00 00 	cmpl   $0x1ff,-0x14(%rbp)
  800420614c:	7e 9f                	jle    80042060ed <page_check+0x1ab8>
		assert((ptep[i] & PTE_P) == 0);
	boot_pml4e[0] = 0;
  800420614e:	48 b8 80 2d 22 04 80 	movabs $0x8004222d80,%rax
  8004206155:	00 00 00 
  8004206158:	48 8b 00             	mov    (%rax),%rax
  800420615b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// give free list back
	page_free_list = fl;
  8004206162:	48 b8 d8 28 22 04 80 	movabs $0x80042228d8,%rax
  8004206169:	00 00 00 
  800420616c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004206170:	48 89 10             	mov    %rdx,(%rax)

	// free the pages we took
	page_decref(pp0);
  8004206173:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8004206177:	48 89 c7             	mov    %rax,%rdi
  800420617a:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004206181:	00 00 00 
  8004206184:	ff d0                	callq  *%rax
	page_decref(pp2);
  8004206186:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420618a:	48 89 c7             	mov    %rax,%rdi
  800420618d:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  8004206194:	00 00 00 
  8004206197:	ff d0                	callq  *%rax
	page_decref(pp3);
  8004206199:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420619d:	48 89 c7             	mov    %rax,%rdi
  80042061a0:	48 b8 65 25 20 04 80 	movabs $0x8004202565,%rax
  80042061a7:	00 00 00 
  80042061aa:	ff d0                	callq  *%rax

	// Triple check that we got the ref counts right
	assert(pp0->pp_ref == 0);
  80042061ac:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042061b0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042061b4:	66 85 c0             	test   %ax,%ax
  80042061b7:	74 35                	je     80042061ee <page_check+0x1bb9>
  80042061b9:	48 b9 36 f2 20 04 80 	movabs $0x800420f236,%rcx
  80042061c0:	00 00 00 
  80042061c3:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042061ca:	00 00 00 
  80042061cd:	be 5a 04 00 00       	mov    $0x45a,%esi
  80042061d2:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042061d9:	00 00 00 
  80042061dc:	b8 00 00 00 00       	mov    $0x0,%eax
  80042061e1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042061e8:	00 00 00 
  80042061eb:	41 ff d0             	callq  *%r8
	assert(pp1->pp_ref == 0);
  80042061ee:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042061f2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042061f6:	66 85 c0             	test   %ax,%ax
  80042061f9:	74 35                	je     8004206230 <page_check+0x1bfb>
  80042061fb:	48 b9 f6 f1 20 04 80 	movabs $0x800420f1f6,%rcx
  8004206202:	00 00 00 
  8004206205:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420620c:	00 00 00 
  800420620f:	be 5b 04 00 00       	mov    $0x45b,%esi
  8004206214:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420621b:	00 00 00 
  800420621e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206223:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420622a:	00 00 00 
  800420622d:	41 ff d0             	callq  *%r8
	assert(pp2->pp_ref == 0);
  8004206230:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004206234:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004206238:	66 85 c0             	test   %ax,%ax
  800420623b:	74 35                	je     8004206272 <page_check+0x1c3d>
  800420623d:	48 b9 47 f2 20 04 80 	movabs $0x800420f247,%rcx
  8004206244:	00 00 00 
  8004206247:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  800420624e:	00 00 00 
  8004206251:	be 5c 04 00 00       	mov    $0x45c,%esi
  8004206256:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420625d:	00 00 00 
  8004206260:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206265:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420626c:	00 00 00 
  800420626f:	41 ff d0             	callq  *%r8
	assert(pp3->pp_ref == 0);
  8004206272:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004206276:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420627a:	66 85 c0             	test   %ax,%ax
  800420627d:	74 35                	je     80042062b4 <page_check+0x1c7f>
  800420627f:	48 b9 58 f2 20 04 80 	movabs $0x800420f258,%rcx
  8004206286:	00 00 00 
  8004206289:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004206290:	00 00 00 
  8004206293:	be 5d 04 00 00       	mov    $0x45d,%esi
  8004206298:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  800420629f:	00 00 00 
  80042062a2:	b8 00 00 00 00       	mov    $0x0,%eax
  80042062a7:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042062ae:	00 00 00 
  80042062b1:	41 ff d0             	callq  *%r8
	assert(pp4->pp_ref == 0);
  80042062b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042062b8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042062bc:	66 85 c0             	test   %ax,%ax
  80042062bf:	74 35                	je     80042062f6 <page_check+0x1cc1>
  80042062c1:	48 b9 69 f2 20 04 80 	movabs $0x800420f269,%rcx
  80042062c8:	00 00 00 
  80042062cb:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  80042062d2:	00 00 00 
  80042062d5:	be 5e 04 00 00       	mov    $0x45e,%esi
  80042062da:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  80042062e1:	00 00 00 
  80042062e4:	b8 00 00 00 00       	mov    $0x0,%eax
  80042062e9:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042062f0:	00 00 00 
  80042062f3:	41 ff d0             	callq  *%r8
	assert(pp5->pp_ref == 0);
  80042062f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042062fa:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042062fe:	66 85 c0             	test   %ax,%ax
  8004206301:	74 35                	je     8004206338 <page_check+0x1d03>
  8004206303:	48 b9 7a f2 20 04 80 	movabs $0x800420f27a,%rcx
  800420630a:	00 00 00 
  800420630d:	48 ba c1 e6 20 04 80 	movabs $0x800420e6c1,%rdx
  8004206314:	00 00 00 
  8004206317:	be 5f 04 00 00       	mov    $0x45f,%esi
  800420631c:	48 bf d6 e6 20 04 80 	movabs $0x800420e6d6,%rdi
  8004206323:	00 00 00 
  8004206326:	b8 00 00 00 00       	mov    $0x0,%eax
  800420632b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004206332:	00 00 00 
  8004206335:	41 ff d0             	callq  *%r8

	cprintf("check_page() succeeded!\n");
  8004206338:	48 bf 8b f2 20 04 80 	movabs $0x800420f28b,%rdi
  800420633f:	00 00 00 
  8004206342:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206347:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  800420634e:	00 00 00 
  8004206351:	ff d2                	callq  *%rdx
}
  8004206353:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  800420635a:	5b                   	pop    %rbx
  800420635b:	5d                   	pop    %rbp
  800420635c:	c3                   	retq   

000000800420635d <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
  800420635d:	55                   	push   %rbp
  800420635e:	48 89 e5             	mov    %rsp,%rbp
  8004206361:	48 83 ec 14          	sub    $0x14,%rsp
  8004206365:	89 7d ec             	mov    %edi,-0x14(%rbp)
	outb(IO_RTC, reg);
  8004206368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420636b:	0f b6 c0             	movzbl %al,%eax
  800420636e:	c7 45 fc 70 00 00 00 	movl   $0x70,-0x4(%rbp)
  8004206375:	88 45 fb             	mov    %al,-0x5(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8004206378:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800420637c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800420637f:	ee                   	out    %al,(%dx)
  8004206380:	c7 45 f4 71 00 00 00 	movl   $0x71,-0xc(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8004206387:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420638a:	89 c2                	mov    %eax,%edx
  800420638c:	ec                   	in     (%dx),%al
  800420638d:	88 45 f3             	mov    %al,-0xd(%rbp)
	return data;
  8004206390:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
	return inb(IO_RTC+1);
  8004206394:	0f b6 c0             	movzbl %al,%eax
}
  8004206397:	c9                   	leaveq 
  8004206398:	c3                   	retq   

0000008004206399 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
  8004206399:	55                   	push   %rbp
  800420639a:	48 89 e5             	mov    %rsp,%rbp
  800420639d:	48 83 ec 18          	sub    $0x18,%rsp
  80042063a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80042063a4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	outb(IO_RTC, reg);
  80042063a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042063aa:	0f b6 c0             	movzbl %al,%eax
  80042063ad:	c7 45 fc 70 00 00 00 	movl   $0x70,-0x4(%rbp)
  80042063b4:	88 45 fb             	mov    %al,-0x5(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80042063b7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80042063bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042063be:	ee                   	out    %al,(%dx)
	outb(IO_RTC+1, datum);
  80042063bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80042063c2:	0f b6 c0             	movzbl %al,%eax
  80042063c5:	c7 45 f4 71 00 00 00 	movl   $0x71,-0xc(%rbp)
  80042063cc:	88 45 f3             	mov    %al,-0xd(%rbp)
  80042063cf:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80042063d3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80042063d6:	ee                   	out    %al,(%dx)
}
  80042063d7:	c9                   	leaveq 
  80042063d8:	c3                   	retq   

00000080042063d9 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
  80042063d9:	55                   	push   %rbp
  80042063da:	48 89 e5             	mov    %rsp,%rbp
  80042063dd:	48 83 ec 10          	sub    $0x10,%rsp
  80042063e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042063e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cputchar(ch);
  80042063e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80042063eb:	89 c7                	mov    %eax,%edi
  80042063ed:	48 b8 cf 0d 20 04 80 	movabs $0x8004200dcf,%rax
  80042063f4:	00 00 00 
  80042063f7:	ff d0                	callq  *%rax
	*cnt++;
  80042063f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042063fd:	48 83 c0 04          	add    $0x4,%rax
  8004206401:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
}
  8004206405:	c9                   	leaveq 
  8004206406:	c3                   	retq   

0000008004206407 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004206407:	55                   	push   %rbp
  8004206408:	48 89 e5             	mov    %rsp,%rbp
  800420640b:	48 83 ec 30          	sub    $0x30,%rsp
  800420640f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004206413:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int cnt = 0;
  8004206417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800420641e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8004206422:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206426:	48 8b 0a             	mov    (%rdx),%rcx
  8004206429:	48 89 08             	mov    %rcx,(%rax)
  800420642c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004206430:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004206434:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004206438:	48 89 50 10          	mov    %rdx,0x10(%rax)
	vprintfmt((void*)putch, &cnt, fmt, aq);
  800420643c:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  8004206440:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004206444:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  8004206448:	48 89 c6             	mov    %rax,%rsi
  800420644b:	48 bf d9 63 20 04 80 	movabs $0x80042063d9,%rdi
  8004206452:	00 00 00 
  8004206455:	48 b8 b9 73 20 04 80 	movabs $0x80042073b9,%rax
  800420645c:	00 00 00 
  800420645f:	ff d0                	callq  *%rax
	va_end(aq);
	return cnt;
  8004206461:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8004206464:	c9                   	leaveq 
  8004206465:	c3                   	retq   

0000008004206466 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004206466:	55                   	push   %rbp
  8004206467:	48 89 e5             	mov    %rsp,%rbp
  800420646a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004206471:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004206478:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800420647f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004206486:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800420648d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004206494:	84 c0                	test   %al,%al
  8004206496:	74 20                	je     80042064b8 <cprintf+0x52>
  8004206498:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800420649c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80042064a0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80042064a4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042064a8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80042064ac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80042064b0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80042064b4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80042064b8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_start(ap, fmt);
  80042064bf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042064c6:	00 00 00 
  80042064c9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80042064d0:	00 00 00 
  80042064d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80042064d7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80042064de:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80042064e5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80042064ec:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80042064f3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80042064fa:	48 8b 0a             	mov    (%rdx),%rcx
  80042064fd:	48 89 08             	mov    %rcx,(%rax)
  8004206500:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004206504:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004206508:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800420650c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8004206510:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004206517:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800420651e:	48 89 d6             	mov    %rdx,%rsi
  8004206521:	48 89 c7             	mov    %rax,%rdi
  8004206524:	48 b8 07 64 20 04 80 	movabs $0x8004206407,%rax
  800420652b:	00 00 00 
  800420652e:	ff d0                	callq  *%rax
  8004206530:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004206536:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800420653c:	c9                   	leaveq 
  800420653d:	c3                   	retq   

000000800420653e <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int64_t
syscall(uint64_t syscallno, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800420653e:	55                   	push   %rbp
  800420653f:	48 89 e5             	mov    %rsp,%rbp
  8004206542:	48 83 ec 30          	sub    $0x30,%rsp
  8004206546:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420654a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800420654e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004206552:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004206556:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
  800420655a:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	panic("syscall not implemented");
  800420655e:	48 ba a4 f2 20 04 80 	movabs $0x800420f2a4,%rdx
  8004206565:	00 00 00 
  8004206568:	be 0e 00 00 00       	mov    $0xe,%esi
  800420656d:	48 bf bc f2 20 04 80 	movabs $0x800420f2bc,%rdi
  8004206574:	00 00 00 
  8004206577:	b8 00 00 00 00       	mov    $0x0,%eax
  800420657c:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004206583:	00 00 00 
  8004206586:	ff d1                	callq  *%rcx

0000008004206588 <list_func_die>:

#endif


int list_func_die(struct Ripdebuginfo *info, Dwarf_Die *die, uint64_t addr)
{
  8004206588:	55                   	push   %rbp
  8004206589:	48 89 e5             	mov    %rsp,%rbp
  800420658c:	48 81 ec f0 61 00 00 	sub    $0x61f0,%rsp
  8004206593:	48 89 bd 58 9e ff ff 	mov    %rdi,-0x61a8(%rbp)
  800420659a:	48 89 b5 50 9e ff ff 	mov    %rsi,-0x61b0(%rbp)
  80042065a1:	48 89 95 48 9e ff ff 	mov    %rdx,-0x61b8(%rbp)
	_Dwarf_Line ln;
	Dwarf_Attribute *low;
	Dwarf_Attribute *high;
	Dwarf_CU *cu = die->cu_header;
  80042065a8:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042065af:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  80042065b6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Dwarf_Die *cudie = die->cu_die; 
  80042065ba:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042065c1:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  80042065c8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	Dwarf_Die ret, sib=*die; 
  80042065cc:	48 8b 95 50 9e ff ff 	mov    -0x61b0(%rbp),%rdx
  80042065d3:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  80042065da:	48 89 d1             	mov    %rdx,%rcx
  80042065dd:	ba 70 30 00 00       	mov    $0x3070,%edx
  80042065e2:	48 89 ce             	mov    %rcx,%rsi
  80042065e5:	48 89 c7             	mov    %rax,%rdi
  80042065e8:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  80042065ef:	00 00 00 
  80042065f2:	ff d0                	callq  *%rax
	Dwarf_Attribute *attr;
	uint64_t offset;
	uint64_t ret_val=8;
  80042065f4:	48 c7 45 f8 08 00 00 	movq   $0x8,-0x8(%rbp)
  80042065fb:	00 
	uint64_t ret_offset=0;
  80042065fc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004206603:	00 

	if(die->die_tag != DW_TAG_subprogram)
  8004206604:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  800420660b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420660f:	48 83 f8 2e          	cmp    $0x2e,%rax
  8004206613:	74 0a                	je     800420661f <list_func_die+0x97>
		return 0;
  8004206615:	b8 00 00 00 00       	mov    $0x0,%eax
  800420661a:	e9 cd 06 00 00       	jmpq   8004206cec <list_func_die+0x764>

	memset(&ln, 0, sizeof(_Dwarf_Line));
  800420661f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004206626:	ba 38 00 00 00       	mov    $0x38,%edx
  800420662b:	be 00 00 00 00       	mov    $0x0,%esi
  8004206630:	48 89 c7             	mov    %rax,%rdi
  8004206633:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420663a:	00 00 00 
  800420663d:	ff d0                	callq  *%rax

	low  = _dwarf_attr_find(die, DW_AT_low_pc);
  800420663f:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004206646:	be 11 00 00 00       	mov    $0x11,%esi
  800420664b:	48 89 c7             	mov    %rax,%rdi
  800420664e:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206655:	00 00 00 
  8004206658:	ff d0                	callq  *%rax
  800420665a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	high = _dwarf_attr_find(die, DW_AT_high_pc);
  800420665e:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004206665:	be 12 00 00 00       	mov    $0x12,%esi
  800420666a:	48 89 c7             	mov    %rax,%rdi
  800420666d:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206674:	00 00 00 
  8004206677:	ff d0                	callq  *%rax
  8004206679:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

	if((low && (low->u[0].u64 < addr)) && (high && (high->u[0].u64 > addr)))
  800420667d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004206682:	0f 84 5f 06 00 00    	je     8004206ce7 <list_func_die+0x75f>
  8004206688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420668c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206690:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  8004206697:	0f 83 4a 06 00 00    	jae    8004206ce7 <list_func_die+0x75f>
  800420669d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80042066a2:	0f 84 3f 06 00 00    	je     8004206ce7 <list_func_die+0x75f>
  80042066a8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042066ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042066b0:	48 3b 85 48 9e ff ff 	cmp    -0x61b8(%rbp),%rax
  80042066b7:	0f 86 2a 06 00 00    	jbe    8004206ce7 <list_func_die+0x75f>
	{
		info->rip_file = die->cu_die->die_name;
  80042066bd:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042066c4:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  80042066cb:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  80042066d2:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042066d9:	48 89 10             	mov    %rdx,(%rax)

		info->rip_fn_name = die->die_name;
  80042066dc:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042066e3:	48 8b 90 50 03 00 00 	mov    0x350(%rax),%rdx
  80042066ea:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042066f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
		info->rip_fn_namelen = strlen(die->die_name);
  80042066f5:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  80042066fc:	48 8b 80 50 03 00 00 	mov    0x350(%rax),%rax
  8004206703:	48 89 c7             	mov    %rax,%rdi
  8004206706:	48 b8 b1 7c 20 04 80 	movabs $0x8004207cb1,%rax
  800420670d:	00 00 00 
  8004206710:	ff d0                	callq  *%rax
  8004206712:	48 8b 95 58 9e ff ff 	mov    -0x61a8(%rbp),%rdx
  8004206719:	89 42 18             	mov    %eax,0x18(%rdx)

		info->rip_fn_addr = (uintptr_t)low->u[0].u64;
  800420671c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004206720:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004206724:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  800420672b:	48 89 50 20          	mov    %rdx,0x20(%rax)

		assert(die->cu_die);	
  800420672f:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  8004206736:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  800420673d:	48 85 c0             	test   %rax,%rax
  8004206740:	75 35                	jne    8004206777 <list_func_die+0x1ef>
  8004206742:	48 b9 00 f6 20 04 80 	movabs $0x800420f600,%rcx
  8004206749:	00 00 00 
  800420674c:	48 ba 0c f6 20 04 80 	movabs $0x800420f60c,%rdx
  8004206753:	00 00 00 
  8004206756:	be 88 00 00 00       	mov    $0x88,%esi
  800420675b:	48 bf 21 f6 20 04 80 	movabs $0x800420f621,%rdi
  8004206762:	00 00 00 
  8004206765:	b8 00 00 00 00       	mov    $0x0,%eax
  800420676a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004206771:	00 00 00 
  8004206774:	41 ff d0             	callq  *%r8
		dwarf_srclines(die->cu_die, &ln, addr, NULL); 
  8004206777:	48 8b 85 50 9e ff ff 	mov    -0x61b0(%rbp),%rax
  800420677e:	48 8b 80 68 03 00 00 	mov    0x368(%rax),%rax
  8004206785:	48 8b 95 48 9e ff ff 	mov    -0x61b8(%rbp),%rdx
  800420678c:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  8004206793:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004206798:	48 89 c7             	mov    %rax,%rdi
  800420679b:	48 b8 12 d5 20 04 80 	movabs $0x800420d512,%rax
  80042067a2:	00 00 00 
  80042067a5:	ff d0                	callq  *%rax

		info->rip_line = ln.ln_lineno;
  80042067a7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042067ae:	89 c2                	mov    %eax,%edx
  80042067b0:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042067b7:	89 50 08             	mov    %edx,0x8(%rax)
		info->rip_fn_narg = 0;
  80042067ba:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042067c1:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)

		Dwarf_Attribute* attr;

		if(dwarf_child(dbg, cu, &sib, &ret) != DW_DLE_NO_ENTRY)
  80042067c8:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  80042067cf:	00 00 00 
  80042067d2:	48 8b 00             	mov    (%rax),%rax
  80042067d5:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  80042067dc:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  80042067e3:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80042067e7:	48 89 c7             	mov    %rax,%rdi
  80042067ea:	48 b8 c2 a1 20 04 80 	movabs $0x800420a1c2,%rax
  80042067f1:	00 00 00 
  80042067f4:	ff d0                	callq  *%rax
  80042067f6:	83 f8 04             	cmp    $0x4,%eax
  80042067f9:	0f 84 e1 04 00 00    	je     8004206ce0 <list_func_die+0x758>
		{
			if(ret.die_tag != DW_TAG_formal_parameter)
  80042067ff:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  8004206806:	48 83 f8 05          	cmp    $0x5,%rax
  800420680a:	74 05                	je     8004206811 <list_func_die+0x289>
				goto last;
  800420680c:	e9 cf 04 00 00       	jmpq   8004206ce0 <list_func_die+0x758>

			attr = _dwarf_attr_find(&ret, DW_AT_type);
  8004206811:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004206818:	be 49 00 00 00       	mov    $0x49,%esi
  800420681d:	48 89 c7             	mov    %rax,%rdi
  8004206820:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206827:	00 00 00 
  800420682a:	ff d0                	callq  *%rax
  800420682c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	
		try_again:
			if(attr != NULL)
  8004206830:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206835:	0f 84 d7 00 00 00    	je     8004206912 <list_func_die+0x38a>
			{
				offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  800420683b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420683f:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004206843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206847:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420684b:	48 01 d0             	add    %rdx,%rax
  800420684e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
				dwarf_offdie(dbg, offset, &sib, *cu);
  8004206852:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206859:	00 00 00 
  800420685c:	48 8b 08             	mov    (%rax),%rcx
  800420685f:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004206866:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800420686a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420686e:	48 8b 38             	mov    (%rax),%rdi
  8004206871:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004206875:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8004206879:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  800420687e:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004206882:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  8004206887:	48 8b 78 18          	mov    0x18(%rax),%rdi
  800420688b:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004206890:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8004206894:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004206899:	48 8b 78 28          	mov    0x28(%rax),%rdi
  800420689d:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  80042068a2:	48 8b 40 30          	mov    0x30(%rax),%rax
  80042068a6:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  80042068ab:	48 89 cf             	mov    %rcx,%rdi
  80042068ae:	48 b8 e8 9d 20 04 80 	movabs $0x8004209de8,%rax
  80042068b5:	00 00 00 
  80042068b8:	ff d0                	callq  *%rax
				attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  80042068ba:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  80042068c1:	be 0b 00 00 00       	mov    $0xb,%esi
  80042068c6:	48 89 c7             	mov    %rax,%rdi
  80042068c9:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  80042068d0:	00 00 00 
  80042068d3:	ff d0                	callq  *%rax
  80042068d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		
				if(attr != NULL)
  80042068d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80042068de:	74 0e                	je     80042068ee <list_func_die+0x366>
				{
					ret_val = attr->u[0].u64;
  80042068e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042068e4:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042068e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042068ec:	eb 24                	jmp    8004206912 <list_func_die+0x38a>
				}
				else
				{
					attr = _dwarf_attr_find(&sib, DW_AT_type);
  80042068ee:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  80042068f5:	be 49 00 00 00       	mov    $0x49,%esi
  80042068fa:	48 89 c7             	mov    %rax,%rdi
  80042068fd:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206904:	00 00 00 
  8004206907:	ff d0                	callq  *%rax
  8004206909:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					goto try_again;
  800420690d:	e9 1e ff ff ff       	jmpq   8004206830 <list_func_die+0x2a8>
				}
			}

			ret_offset = 0;
  8004206912:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004206919:	00 
			attr = _dwarf_attr_find(&ret, DW_AT_location);
  800420691a:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004206921:	be 02 00 00 00       	mov    $0x2,%esi
  8004206926:	48 89 c7             	mov    %rax,%rdi
  8004206929:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206930:	00 00 00 
  8004206933:	ff d0                	callq  *%rax
  8004206935:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if (attr != NULL)
  8004206939:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420693e:	0f 84 a2 00 00 00    	je     80042069e6 <list_func_die+0x45e>
			{
				Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  8004206944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206948:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420694c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
				Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  8004206950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206954:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004206958:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
				Dwarf_Small atom;
				Dwarf_Unsigned op1, op2;

				switch(attr->at_form) {
  800420695c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206960:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206964:	48 83 f8 03          	cmp    $0x3,%rax
  8004206968:	72 7c                	jb     80042069e6 <list_func_die+0x45e>
  800420696a:	48 83 f8 04          	cmp    $0x4,%rax
  800420696e:	76 06                	jbe    8004206976 <list_func_die+0x3ee>
  8004206970:	48 83 f8 0a          	cmp    $0xa,%rax
  8004206974:	75 70                	jne    80042069e6 <list_func_die+0x45e>
					case DW_FORM_block1:
					case DW_FORM_block2:
					case DW_FORM_block4:
						offset = 0;
  8004206976:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  800420697d:	00 
						atom = *(loc_ptr++);
  800420697e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004206982:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206986:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
  800420698a:	0f b6 00             	movzbl (%rax),%eax
  800420698d:	88 45 af             	mov    %al,-0x51(%rbp)
						offset++;
  8004206990:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
						if (atom == DW_OP_fbreg) {
  8004206995:	80 7d af 91          	cmpb   $0x91,-0x51(%rbp)
  8004206999:	75 4a                	jne    80042069e5 <list_func_die+0x45d>
							uint8_t *p = loc_ptr;
  800420699b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420699f:	48 89 85 68 9e ff ff 	mov    %rax,-0x6198(%rbp)
							ret_offset = _dwarf_decode_sleb128(&p);
  80042069a6:	48 8d 85 68 9e ff ff 	lea    -0x6198(%rbp),%rax
  80042069ad:	48 89 c7             	mov    %rax,%rdi
  80042069b0:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  80042069b7:	00 00 00 
  80042069ba:	ff d0                	callq  *%rax
  80042069bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
							offset += p - loc_ptr;
  80042069c0:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  80042069c7:	48 89 c2             	mov    %rax,%rdx
  80042069ca:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80042069ce:	48 29 c2             	sub    %rax,%rdx
  80042069d1:	48 89 d0             	mov    %rdx,%rax
  80042069d4:	48 01 45 c0          	add    %rax,-0x40(%rbp)
							loc_ptr = p;
  80042069d8:	48 8b 85 68 9e ff ff 	mov    -0x6198(%rbp),%rax
  80042069df:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
						}
						break;
  80042069e3:	eb 00                	jmp    80042069e5 <list_func_die+0x45d>
  80042069e5:	90                   	nop
				}
			}

			info->size_fn_arg[info->rip_fn_narg] = ret_val;
  80042069e6:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042069ed:	8b 48 28             	mov    0x28(%rax),%ecx
  80042069f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042069f4:	89 c2                	mov    %eax,%edx
  80042069f6:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  80042069fd:	48 63 c9             	movslq %ecx,%rcx
  8004206a00:	48 83 c1 08          	add    $0x8,%rcx
  8004206a04:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
  8004206a08:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206a0f:	8b 50 28             	mov    0x28(%rax),%edx
  8004206a12:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206a19:	48 63 d2             	movslq %edx,%rdx
  8004206a1c:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  8004206a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004206a24:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
			info->rip_fn_narg++;
  8004206a29:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206a30:	8b 40 28             	mov    0x28(%rax),%eax
  8004206a33:	8d 50 01             	lea    0x1(%rax),%edx
  8004206a36:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206a3d:	89 50 28             	mov    %edx,0x28(%rax)
			sib = ret; 
  8004206a40:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004206a47:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  8004206a4e:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004206a53:	48 89 ce             	mov    %rcx,%rsi
  8004206a56:	48 89 c7             	mov    %rax,%rdi
  8004206a59:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  8004206a60:	00 00 00 
  8004206a63:	ff d0                	callq  *%rax

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004206a65:	e9 40 02 00 00       	jmpq   8004206caa <list_func_die+0x722>
			{
				if(ret.die_tag != DW_TAG_formal_parameter)
  8004206a6a:	48 8b 85 f8 ce ff ff 	mov    -0x3108(%rbp),%rax
  8004206a71:	48 83 f8 05          	cmp    $0x5,%rax
  8004206a75:	74 05                	je     8004206a7c <list_func_die+0x4f4>
					break;
  8004206a77:	e9 64 02 00 00       	jmpq   8004206ce0 <list_func_die+0x758>

				attr = _dwarf_attr_find(&ret, DW_AT_type);
  8004206a7c:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004206a83:	be 49 00 00 00       	mov    $0x49,%esi
  8004206a88:	48 89 c7             	mov    %rax,%rdi
  8004206a8b:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206a92:	00 00 00 
  8004206a95:	ff d0                	callq  *%rax
  8004206a97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    
				if(attr != NULL)
  8004206a9b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206aa0:	0f 84 b1 00 00 00    	je     8004206b57 <list_func_die+0x5cf>
				{	   
					offset = (uint64_t)cu->cu_offset + attr->u[0].u64;
  8004206aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206aaa:	48 8b 50 30          	mov    0x30(%rax),%rdx
  8004206aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ab2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206ab6:	48 01 d0             	add    %rdx,%rax
  8004206ab9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
					dwarf_offdie(dbg, offset, &sib, *cu);
  8004206abd:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206ac4:	00 00 00 
  8004206ac7:	48 8b 08             	mov    (%rax),%rcx
  8004206aca:	48 8d 95 70 9e ff ff 	lea    -0x6190(%rbp),%rdx
  8004206ad1:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8004206ad5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004206ad9:	48 8b 38             	mov    (%rax),%rdi
  8004206adc:	48 89 3c 24          	mov    %rdi,(%rsp)
  8004206ae0:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8004206ae4:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8004206ae9:	48 8b 78 10          	mov    0x10(%rax),%rdi
  8004206aed:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  8004206af2:	48 8b 78 18          	mov    0x18(%rax),%rdi
  8004206af6:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8004206afb:	48 8b 78 20          	mov    0x20(%rax),%rdi
  8004206aff:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8004206b04:	48 8b 78 28          	mov    0x28(%rax),%rdi
  8004206b08:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8004206b0d:	48 8b 40 30          	mov    0x30(%rax),%rax
  8004206b11:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8004206b16:	48 89 cf             	mov    %rcx,%rdi
  8004206b19:	48 b8 e8 9d 20 04 80 	movabs $0x8004209de8,%rax
  8004206b20:	00 00 00 
  8004206b23:	ff d0                	callq  *%rax
					attr = _dwarf_attr_find(&sib, DW_AT_byte_size);
  8004206b25:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004206b2c:	be 0b 00 00 00       	mov    $0xb,%esi
  8004206b31:	48 89 c7             	mov    %rax,%rdi
  8004206b34:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206b3b:	00 00 00 
  8004206b3e:	ff d0                	callq  *%rax
  8004206b40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        
					if(attr != NULL)
  8004206b44:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206b49:	74 0c                	je     8004206b57 <list_func_die+0x5cf>
					{
						ret_val = attr->u[0].u64;
  8004206b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b4f:	48 8b 40 28          	mov    0x28(%rax),%rax
  8004206b53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
					}
				}
	
				ret_offset = 0;
  8004206b57:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8004206b5e:	00 
				attr = _dwarf_attr_find(&ret, DW_AT_location);
  8004206b5f:	48 8d 85 e0 ce ff ff 	lea    -0x3120(%rbp),%rax
  8004206b66:	be 02 00 00 00       	mov    $0x2,%esi
  8004206b6b:	48 89 c7             	mov    %rax,%rdi
  8004206b6e:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  8004206b75:	00 00 00 
  8004206b78:	ff d0                	callq  *%rax
  8004206b7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				if (attr != NULL)
  8004206b7e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004206b83:	0f 84 a2 00 00 00    	je     8004206c2b <list_func_die+0x6a3>
				{
					Dwarf_Unsigned loc_len = attr->at_block.bl_len;
  8004206b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b8d:	48 8b 40 38          	mov    0x38(%rax),%rax
  8004206b91:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
					Dwarf_Small *loc_ptr = attr->at_block.bl_data;
  8004206b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206b99:	48 8b 40 40          	mov    0x40(%rax),%rax
  8004206b9d:	48 89 45 98          	mov    %rax,-0x68(%rbp)
					Dwarf_Small atom;
					Dwarf_Unsigned op1, op2;

					switch(attr->at_form) {
  8004206ba1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004206ba5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004206ba9:	48 83 f8 03          	cmp    $0x3,%rax
  8004206bad:	72 7c                	jb     8004206c2b <list_func_die+0x6a3>
  8004206baf:	48 83 f8 04          	cmp    $0x4,%rax
  8004206bb3:	76 06                	jbe    8004206bbb <list_func_die+0x633>
  8004206bb5:	48 83 f8 0a          	cmp    $0xa,%rax
  8004206bb9:	75 70                	jne    8004206c2b <list_func_die+0x6a3>
						case DW_FORM_block1:
						case DW_FORM_block2:
						case DW_FORM_block4:
							offset = 0;
  8004206bbb:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8004206bc2:	00 
							atom = *(loc_ptr++);
  8004206bc3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004206bc7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004206bcb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004206bcf:	0f b6 00             	movzbl (%rax),%eax
  8004206bd2:	88 45 97             	mov    %al,-0x69(%rbp)
							offset++;
  8004206bd5:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
							if (atom == DW_OP_fbreg) {
  8004206bda:	80 7d 97 91          	cmpb   $0x91,-0x69(%rbp)
  8004206bde:	75 4a                	jne    8004206c2a <list_func_die+0x6a2>
								uint8_t *p = loc_ptr;
  8004206be0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004206be4:	48 89 85 60 9e ff ff 	mov    %rax,-0x61a0(%rbp)
								ret_offset = _dwarf_decode_sleb128(&p);
  8004206beb:	48 8d 85 60 9e ff ff 	lea    -0x61a0(%rbp),%rax
  8004206bf2:	48 89 c7             	mov    %rax,%rdi
  8004206bf5:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  8004206bfc:	00 00 00 
  8004206bff:	ff d0                	callq  *%rax
  8004206c01:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
								offset += p - loc_ptr;
  8004206c05:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004206c0c:	48 89 c2             	mov    %rax,%rdx
  8004206c0f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004206c13:	48 29 c2             	sub    %rax,%rdx
  8004206c16:	48 89 d0             	mov    %rdx,%rax
  8004206c19:	48 01 45 c0          	add    %rax,-0x40(%rbp)
								loc_ptr = p;
  8004206c1d:	48 8b 85 60 9e ff ff 	mov    -0x61a0(%rbp),%rax
  8004206c24:	48 89 45 98          	mov    %rax,-0x68(%rbp)
							}
							break;
  8004206c28:	eb 00                	jmp    8004206c2a <list_func_die+0x6a2>
  8004206c2a:	90                   	nop
					}
				}

				info->size_fn_arg[info->rip_fn_narg]=ret_val;// _get_arg_size(ret);
  8004206c2b:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c32:	8b 48 28             	mov    0x28(%rax),%ecx
  8004206c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004206c39:	89 c2                	mov    %eax,%edx
  8004206c3b:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c42:	48 63 c9             	movslq %ecx,%rcx
  8004206c45:	48 83 c1 08          	add    $0x8,%rcx
  8004206c49:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
				info->offset_fn_arg[info->rip_fn_narg]=ret_offset;
  8004206c4d:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c54:	8b 50 28             	mov    0x28(%rax),%edx
  8004206c57:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c5e:	48 63 d2             	movslq %edx,%rdx
  8004206c61:	48 8d 4a 0a          	lea    0xa(%rdx),%rcx
  8004206c65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004206c69:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
				info->rip_fn_narg++;
  8004206c6e:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c75:	8b 40 28             	mov    0x28(%rax),%eax
  8004206c78:	8d 50 01             	lea    0x1(%rax),%edx
  8004206c7b:	48 8b 85 58 9e ff ff 	mov    -0x61a8(%rbp),%rax
  8004206c82:	89 50 28             	mov    %edx,0x28(%rax)
				sib = ret; 
  8004206c85:	48 8d 85 70 9e ff ff 	lea    -0x6190(%rbp),%rax
  8004206c8c:	48 8d 8d e0 ce ff ff 	lea    -0x3120(%rbp),%rcx
  8004206c93:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004206c98:	48 89 ce             	mov    %rcx,%rsi
  8004206c9b:	48 89 c7             	mov    %rax,%rdi
  8004206c9e:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  8004206ca5:	00 00 00 
  8004206ca8:	ff d0                	callq  *%rax
			info->size_fn_arg[info->rip_fn_narg] = ret_val;
			info->offset_fn_arg[info->rip_fn_narg] = ret_offset;
			info->rip_fn_narg++;
			sib = ret; 

			while(dwarf_siblingof(dbg, &sib, &ret, cu) == DW_DLV_OK)	
  8004206caa:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206cb1:	00 00 00 
  8004206cb4:	48 8b 00             	mov    (%rax),%rax
  8004206cb7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004206cbb:	48 8d 95 e0 ce ff ff 	lea    -0x3120(%rbp),%rdx
  8004206cc2:	48 8d b5 70 9e ff ff 	lea    -0x6190(%rbp),%rsi
  8004206cc9:	48 89 c7             	mov    %rax,%rdi
  8004206ccc:	48 b8 7e 9f 20 04 80 	movabs $0x8004209f7e,%rax
  8004206cd3:	00 00 00 
  8004206cd6:	ff d0                	callq  *%rax
  8004206cd8:	85 c0                	test   %eax,%eax
  8004206cda:	0f 84 8a fd ff ff    	je     8004206a6a <list_func_die+0x4e2>
				info->rip_fn_narg++;
				sib = ret; 
			}
		}
	last:	
		return 1;
  8004206ce0:	b8 01 00 00 00       	mov    $0x1,%eax
  8004206ce5:	eb 05                	jmp    8004206cec <list_func_die+0x764>
	}

	return 0;
  8004206ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004206cec:	c9                   	leaveq 
  8004206ced:	c3                   	retq   

0000008004206cee <debuginfo_rip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_rip(uintptr_t addr, struct Ripdebuginfo *info)
{
  8004206cee:	55                   	push   %rbp
  8004206cef:	48 89 e5             	mov    %rsp,%rbp
  8004206cf2:	53                   	push   %rbx
  8004206cf3:	48 81 ec c8 91 00 00 	sub    $0x91c8,%rsp
  8004206cfa:	48 89 bd 38 6e ff ff 	mov    %rdi,-0x91c8(%rbp)
  8004206d01:	48 89 b5 30 6e ff ff 	mov    %rsi,-0x91d0(%rbp)
	static struct Env* lastenv = NULL;
	void* elf;    
	Dwarf_Section *sect;
	Dwarf_CU cu;
	Dwarf_Die die, cudie, die2;
	Dwarf_Regtable *rt = NULL;
  8004206d08:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004206d0f:	00 
	//Set up initial pc
	uint64_t pc  = (uintptr_t)addr;
  8004206d10:	48 8b 85 38 6e ff ff 	mov    -0x91c8(%rbp),%rax
  8004206d17:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

    
	// Initialize *info
	info->rip_file = "<unknown>";
  8004206d1b:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d22:	48 bb 2f f6 20 04 80 	movabs $0x800420f62f,%rbx
  8004206d29:	00 00 00 
  8004206d2c:	48 89 18             	mov    %rbx,(%rax)
	info->rip_line = 0;
  8004206d2f:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	info->rip_fn_name = "<unknown>";
  8004206d3d:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d44:	48 bb 2f f6 20 04 80 	movabs $0x800420f62f,%rbx
  8004206d4b:	00 00 00 
  8004206d4e:	48 89 58 10          	mov    %rbx,0x10(%rax)
	info->rip_fn_namelen = 9;
  8004206d52:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d59:	c7 40 18 09 00 00 00 	movl   $0x9,0x18(%rax)
	info->rip_fn_addr = addr;
  8004206d60:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d67:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004206d6e:	48 89 50 20          	mov    %rdx,0x20(%rax)
	info->rip_fn_narg = 0;
  8004206d72:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206d79:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%rax)
    
	// Find the relevant set of stabs
	if (addr >= ULIM) {
  8004206d80:	48 b8 ff ff bf 03 80 	movabs $0x8003bfffff,%rax
  8004206d87:	00 00 00 
  8004206d8a:	48 39 85 38 6e ff ff 	cmp    %rax,-0x91c8(%rbp)
  8004206d91:	0f 86 95 00 00 00    	jbe    8004206e2c <debuginfo_rip+0x13e>
		elf = (void *)0x10000 + KERNBASE;
  8004206d97:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  8004206d9e:	00 00 00 
  8004206da1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
	}
	_dwarf_init(dbg, elf);
  8004206da5:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206dac:	00 00 00 
  8004206daf:	48 8b 00             	mov    (%rax),%rax
  8004206db2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004206db6:	48 89 d6             	mov    %rdx,%rsi
  8004206db9:	48 89 c7             	mov    %rax,%rdi
  8004206dbc:	48 b8 f6 8d 20 04 80 	movabs $0x8004208df6,%rax
  8004206dc3:	00 00 00 
  8004206dc6:	ff d0                	callq  *%rax

	sect = _dwarf_find_section(".debug_info");	
  8004206dc8:	48 bf 46 f6 20 04 80 	movabs $0x800420f646,%rdi
  8004206dcf:	00 00 00 
  8004206dd2:	48 b8 8d d6 20 04 80 	movabs $0x800420d68d,%rax
  8004206dd9:	00 00 00 
  8004206ddc:	ff d0                	callq  *%rax
  8004206dde:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
  8004206de2:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206de9:	00 00 00 
  8004206dec:	48 8b 00             	mov    (%rax),%rax
  8004206def:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206df3:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004206df7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	dbg->dbg_info_size = sect->ds_size;
  8004206dfb:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206e02:	00 00 00 
  8004206e05:	48 8b 00             	mov    (%rax),%rax
  8004206e08:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004206e0c:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8004206e10:	48 89 50 10          	mov    %rdx,0x10(%rax)

	assert(dbg->dbg_info_size);
  8004206e14:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206e1b:	00 00 00 
  8004206e1e:	48 8b 00             	mov    (%rax),%rax
  8004206e21:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004206e25:	48 85 c0             	test   %rax,%rax
  8004206e28:	75 61                	jne    8004206e8b <debuginfo_rip+0x19d>
  8004206e2a:	eb 2a                	jmp    8004206e56 <debuginfo_rip+0x168>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		elf = (void *)0x10000 + KERNBASE;
	} else {
		// Can't search for user-level addresses yet!
		panic("User address");
  8004206e2c:	48 ba 39 f6 20 04 80 	movabs $0x800420f639,%rdx
  8004206e33:	00 00 00 
  8004206e36:	be 23 01 00 00       	mov    $0x123,%esi
  8004206e3b:	48 bf 21 f6 20 04 80 	movabs $0x800420f621,%rdi
  8004206e42:	00 00 00 
  8004206e45:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206e4a:	48 b9 14 01 20 04 80 	movabs $0x8004200114,%rcx
  8004206e51:	00 00 00 
  8004206e54:	ff d1                	callq  *%rcx

	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
  8004206e56:	48 b9 52 f6 20 04 80 	movabs $0x800420f652,%rcx
  8004206e5d:	00 00 00 
  8004206e60:	48 ba 0c f6 20 04 80 	movabs $0x800420f60c,%rdx
  8004206e67:	00 00 00 
  8004206e6a:	be 2b 01 00 00       	mov    $0x12b,%esi
  8004206e6f:	48 bf 21 f6 20 04 80 	movabs $0x800420f621,%rdi
  8004206e76:	00 00 00 
  8004206e79:	b8 00 00 00 00       	mov    $0x0,%eax
  8004206e7e:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004206e85:	00 00 00 
  8004206e88:	41 ff d0             	callq  *%r8
	while(_get_next_cu(dbg, &cu) == 0)
  8004206e8b:	e9 6f 01 00 00       	jmpq   8004206fff <debuginfo_rip+0x311>
	{
		if(dwarf_siblingof(dbg, NULL, &cudie, &cu) == DW_DLE_NO_ENTRY)
  8004206e90:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206e97:	00 00 00 
  8004206e9a:	48 8b 00             	mov    (%rax),%rax
  8004206e9d:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004206ea1:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004206ea8:	be 00 00 00 00       	mov    $0x0,%esi
  8004206ead:	48 89 c7             	mov    %rax,%rdi
  8004206eb0:	48 b8 7e 9f 20 04 80 	movabs $0x8004209f7e,%rax
  8004206eb7:	00 00 00 
  8004206eba:	ff d0                	callq  *%rax
  8004206ebc:	83 f8 04             	cmp    $0x4,%eax
  8004206ebf:	75 05                	jne    8004206ec6 <debuginfo_rip+0x1d8>
			continue;
  8004206ec1:	e9 39 01 00 00       	jmpq   8004206fff <debuginfo_rip+0x311>

		cudie.cu_header = &cu;
  8004206ec6:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004206eca:	48 89 85 10 a2 ff ff 	mov    %rax,-0x5df0(%rbp)
		cudie.cu_die = NULL;
  8004206ed1:	48 c7 85 18 a2 ff ff 	movq   $0x0,-0x5de8(%rbp)
  8004206ed8:	00 00 00 00 

		if(dwarf_child(dbg, &cu, &cudie, &die) == DW_DLE_NO_ENTRY)
  8004206edc:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206ee3:	00 00 00 
  8004206ee6:	48 8b 00             	mov    (%rax),%rax
  8004206ee9:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  8004206ef0:	48 8d 95 b0 9e ff ff 	lea    -0x6150(%rbp),%rdx
  8004206ef7:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  8004206efb:	48 89 c7             	mov    %rax,%rdi
  8004206efe:	48 b8 c2 a1 20 04 80 	movabs $0x800420a1c2,%rax
  8004206f05:	00 00 00 
  8004206f08:	ff d0                	callq  *%rax
  8004206f0a:	83 f8 04             	cmp    $0x4,%eax
  8004206f0d:	75 05                	jne    8004206f14 <debuginfo_rip+0x226>
			continue;
  8004206f0f:	e9 eb 00 00 00       	jmpq   8004206fff <debuginfo_rip+0x311>

		die.cu_header = &cu;
  8004206f14:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004206f18:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
		die.cu_die = &cudie;
  8004206f1f:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004206f26:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		while(1)
		{
			if(list_func_die(info, &die, addr))
  8004206f2d:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  8004206f34:	48 8d 8d 20 cf ff ff 	lea    -0x30e0(%rbp),%rcx
  8004206f3b:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  8004206f42:	48 89 ce             	mov    %rcx,%rsi
  8004206f45:	48 89 c7             	mov    %rax,%rdi
  8004206f48:	48 b8 88 65 20 04 80 	movabs $0x8004206588,%rax
  8004206f4f:	00 00 00 
  8004206f52:	ff d0                	callq  *%rax
  8004206f54:	85 c0                	test   %eax,%eax
  8004206f56:	74 30                	je     8004206f88 <debuginfo_rip+0x29a>
				goto find_done;
  8004206f58:	90                   	nop

	return -1;

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
  8004206f59:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206f60:	00 00 00 
  8004206f63:	48 8b 00             	mov    (%rax),%rax
  8004206f66:	be 00 00 00 00       	mov    $0x0,%esi
  8004206f6b:	48 89 c7             	mov    %rax,%rdi
  8004206f6e:	48 b8 9a c8 20 04 80 	movabs $0x800420c89a,%rax
  8004206f75:	00 00 00 
  8004206f78:	ff d0                	callq  *%rax
  8004206f7a:	83 f8 01             	cmp    $0x1,%eax
  8004206f7d:	0f 85 bb 00 00 00    	jne    800420703e <debuginfo_rip+0x350>
  8004206f83:	e9 ac 00 00 00       	jmpq   8004207034 <debuginfo_rip+0x346>
		die.cu_die = &cudie;
		while(1)
		{
			if(list_func_die(info, &die, addr))
				goto find_done;
			if(dwarf_siblingof(dbg, &die, &die2, &cu) < 0)
  8004206f88:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004206f8f:	00 00 00 
  8004206f92:	48 8b 00             	mov    (%rax),%rax
  8004206f95:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004206f99:	48 8d 95 40 6e ff ff 	lea    -0x91c0(%rbp),%rdx
  8004206fa0:	48 8d b5 20 cf ff ff 	lea    -0x30e0(%rbp),%rsi
  8004206fa7:	48 89 c7             	mov    %rax,%rdi
  8004206faa:	48 b8 7e 9f 20 04 80 	movabs $0x8004209f7e,%rax
  8004206fb1:	00 00 00 
  8004206fb4:	ff d0                	callq  *%rax
  8004206fb6:	85 c0                	test   %eax,%eax
  8004206fb8:	79 02                	jns    8004206fbc <debuginfo_rip+0x2ce>
				break; 
  8004206fba:	eb 43                	jmp    8004206fff <debuginfo_rip+0x311>
			die = die2;
  8004206fbc:	48 8d 85 20 cf ff ff 	lea    -0x30e0(%rbp),%rax
  8004206fc3:	48 8d 8d 40 6e ff ff 	lea    -0x91c0(%rbp),%rcx
  8004206fca:	ba 70 30 00 00       	mov    $0x3070,%edx
  8004206fcf:	48 89 ce             	mov    %rcx,%rsi
  8004206fd2:	48 89 c7             	mov    %rax,%rdi
  8004206fd5:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  8004206fdc:	00 00 00 
  8004206fdf:	ff d0                	callq  *%rax
			die.cu_header = &cu;
  8004206fe1:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004206fe5:	48 89 85 80 d2 ff ff 	mov    %rax,-0x2d80(%rbp)
			die.cu_die = &cudie;
  8004206fec:	48 8d 85 b0 9e ff ff 	lea    -0x6150(%rbp),%rax
  8004206ff3:	48 89 85 88 d2 ff ff 	mov    %rax,-0x2d78(%rbp)
		}
  8004206ffa:	e9 2e ff ff ff       	jmpq   8004206f2d <debuginfo_rip+0x23f>
	sect = _dwarf_find_section(".debug_info");	
	dbg->dbg_info_offset_elf = (uint64_t)sect->ds_data; 
	dbg->dbg_info_size = sect->ds_size;

	assert(dbg->dbg_info_size);
	while(_get_next_cu(dbg, &cu) == 0)
  8004206fff:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  8004207006:	00 00 00 
  8004207009:	48 8b 00             	mov    (%rax),%rax
  800420700c:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  8004207010:	48 89 d6             	mov    %rdx,%rsi
  8004207013:	48 89 c7             	mov    %rax,%rdi
  8004207016:	48 b8 d8 8e 20 04 80 	movabs $0x8004208ed8,%rax
  800420701d:	00 00 00 
  8004207020:	ff d0                	callq  *%rax
  8004207022:	85 c0                	test   %eax,%eax
  8004207024:	0f 84 66 fe ff ff    	je     8004206e90 <debuginfo_rip+0x1a2>
			die.cu_header = &cu;
			die.cu_die = &cudie;
		}
	}

	return -1;
  800420702a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420702f:	e9 a0 00 00 00       	jmpq   80042070d4 <debuginfo_rip+0x3e6>

find_done:

	if (dwarf_init_eh_section(dbg, NULL) == DW_DLV_ERROR)
		return -1;
  8004207034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004207039:	e9 96 00 00 00       	jmpq   80042070d4 <debuginfo_rip+0x3e6>

	if (dwarf_get_fde_at_pc(dbg, addr, fde, cie, NULL) == DW_DLV_OK) {
  800420703e:	48 b8 b8 25 22 04 80 	movabs $0x80042225b8,%rax
  8004207045:	00 00 00 
  8004207048:	48 8b 08             	mov    (%rax),%rcx
  800420704b:	48 b8 b0 25 22 04 80 	movabs $0x80042225b0,%rax
  8004207052:	00 00 00 
  8004207055:	48 8b 10             	mov    (%rax),%rdx
  8004207058:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420705f:	00 00 00 
  8004207062:	48 8b 00             	mov    (%rax),%rax
  8004207065:	48 8b b5 38 6e ff ff 	mov    -0x91c8(%rbp),%rsi
  800420706c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004207072:	48 89 c7             	mov    %rax,%rdi
  8004207075:	48 b8 03 a4 20 04 80 	movabs $0x800420a403,%rax
  800420707c:	00 00 00 
  800420707f:	ff d0                	callq  *%rax
  8004207081:	85 c0                	test   %eax,%eax
  8004207083:	75 4a                	jne    80042070cf <debuginfo_rip+0x3e1>
		dwarf_get_fde_info_for_all_regs(dbg, fde, addr,
  8004207085:	48 8b 85 30 6e ff ff 	mov    -0x91d0(%rbp),%rax
  800420708c:	48 8d 88 a8 00 00 00 	lea    0xa8(%rax),%rcx
  8004207093:	48 b8 b0 25 22 04 80 	movabs $0x80042225b0,%rax
  800420709a:	00 00 00 
  800420709d:	48 8b 30             	mov    (%rax),%rsi
  80042070a0:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  80042070a7:	00 00 00 
  80042070aa:	48 8b 00             	mov    (%rax),%rax
  80042070ad:	48 8b 95 38 6e ff ff 	mov    -0x91c8(%rbp),%rdx
  80042070b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80042070ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80042070c0:	48 89 c7             	mov    %rax,%rdi
  80042070c3:	48 b8 0f b7 20 04 80 	movabs $0x800420b70f,%rax
  80042070ca:	00 00 00 
  80042070cd:	ff d0                	callq  *%rax
					break;
			}
		}
#endif
	}
	return 0;
  80042070cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042070d4:	48 81 c4 c8 91 00 00 	add    $0x91c8,%rsp
  80042070db:	5b                   	pop    %rbx
  80042070dc:	5d                   	pop    %rbp
  80042070dd:	c3                   	retq   

00000080042070de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042070de:	55                   	push   %rbp
  80042070df:	48 89 e5             	mov    %rsp,%rbp
  80042070e2:	53                   	push   %rbx
  80042070e3:	48 83 ec 38          	sub    $0x38,%rsp
  80042070e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042070eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042070ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042070f3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80042070f6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80042070fa:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042070fe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004207101:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004207105:	77 3b                	ja     8004207142 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004207107:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800420710a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800420710e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004207111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004207115:	ba 00 00 00 00       	mov    $0x0,%edx
  800420711a:	48 f7 f3             	div    %rbx
  800420711d:	48 89 c2             	mov    %rax,%rdx
  8004207120:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004207123:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004207126:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800420712a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420712e:	41 89 f9             	mov    %edi,%r9d
  8004207131:	48 89 c7             	mov    %rax,%rdi
  8004207134:	48 b8 de 70 20 04 80 	movabs $0x80042070de,%rax
  800420713b:	00 00 00 
  800420713e:	ff d0                	callq  *%rax
  8004207140:	eb 1e                	jmp    8004207160 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004207142:	eb 12                	jmp    8004207156 <printnum+0x78>
			putch(padc, putdat);
  8004207144:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004207148:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420714b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420714f:	48 89 ce             	mov    %rcx,%rsi
  8004207152:	89 d7                	mov    %edx,%edi
  8004207154:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004207156:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800420715a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800420715e:	7f e4                	jg     8004207144 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004207160:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004207163:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004207167:	ba 00 00 00 00       	mov    $0x0,%edx
  800420716c:	48 f7 f1             	div    %rcx
  800420716f:	48 89 d0             	mov    %rdx,%rax
  8004207172:	48 ba b0 f7 20 04 80 	movabs $0x800420f7b0,%rdx
  8004207179:	00 00 00 
  800420717c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004207180:	0f be d0             	movsbl %al,%edx
  8004207183:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004207187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420718b:	48 89 ce             	mov    %rcx,%rsi
  800420718e:	89 d7                	mov    %edx,%edi
  8004207190:	ff d0                	callq  *%rax
}
  8004207192:	48 83 c4 38          	add    $0x38,%rsp
  8004207196:	5b                   	pop    %rbx
  8004207197:	5d                   	pop    %rbp
  8004207198:	c3                   	retq   

0000008004207199 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004207199:	55                   	push   %rbp
  800420719a:	48 89 e5             	mov    %rsp,%rbp
  800420719d:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042071a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042071a5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80042071a8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80042071ac:	7e 52                	jle    8004207200 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80042071ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071b2:	8b 00                	mov    (%rax),%eax
  80042071b4:	83 f8 30             	cmp    $0x30,%eax
  80042071b7:	73 24                	jae    80042071dd <getuint+0x44>
  80042071b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042071c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071c5:	8b 00                	mov    (%rax),%eax
  80042071c7:	89 c0                	mov    %eax,%eax
  80042071c9:	48 01 d0             	add    %rdx,%rax
  80042071cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042071d0:	8b 12                	mov    (%rdx),%edx
  80042071d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042071d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042071d9:	89 0a                	mov    %ecx,(%rdx)
  80042071db:	eb 17                	jmp    80042071f4 <getuint+0x5b>
  80042071dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042071e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042071e5:	48 89 d0             	mov    %rdx,%rax
  80042071e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042071ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042071f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042071f4:	48 8b 00             	mov    (%rax),%rax
  80042071f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80042071fb:	e9 a3 00 00 00       	jmpq   80042072a3 <getuint+0x10a>
	else if (lflag)
  8004207200:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004207204:	74 4f                	je     8004207255 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004207206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420720a:	8b 00                	mov    (%rax),%eax
  800420720c:	83 f8 30             	cmp    $0x30,%eax
  800420720f:	73 24                	jae    8004207235 <getuint+0x9c>
  8004207211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207215:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420721d:	8b 00                	mov    (%rax),%eax
  800420721f:	89 c0                	mov    %eax,%eax
  8004207221:	48 01 d0             	add    %rdx,%rax
  8004207224:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207228:	8b 12                	mov    (%rdx),%edx
  800420722a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420722d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207231:	89 0a                	mov    %ecx,(%rdx)
  8004207233:	eb 17                	jmp    800420724c <getuint+0xb3>
  8004207235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207239:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420723d:	48 89 d0             	mov    %rdx,%rax
  8004207240:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004207244:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207248:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420724c:	48 8b 00             	mov    (%rax),%rax
  800420724f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004207253:	eb 4e                	jmp    80042072a3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004207255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207259:	8b 00                	mov    (%rax),%eax
  800420725b:	83 f8 30             	cmp    $0x30,%eax
  800420725e:	73 24                	jae    8004207284 <getuint+0xeb>
  8004207260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207264:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420726c:	8b 00                	mov    (%rax),%eax
  800420726e:	89 c0                	mov    %eax,%eax
  8004207270:	48 01 d0             	add    %rdx,%rax
  8004207273:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207277:	8b 12                	mov    (%rdx),%edx
  8004207279:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420727c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207280:	89 0a                	mov    %ecx,(%rdx)
  8004207282:	eb 17                	jmp    800420729b <getuint+0x102>
  8004207284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207288:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420728c:	48 89 d0             	mov    %rdx,%rax
  800420728f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004207293:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207297:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420729b:	8b 00                	mov    (%rax),%eax
  800420729d:	89 c0                	mov    %eax,%eax
  800420729f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80042072a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042072a7:	c9                   	leaveq 
  80042072a8:	c3                   	retq   

00000080042072a9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80042072a9:	55                   	push   %rbp
  80042072aa:	48 89 e5             	mov    %rsp,%rbp
  80042072ad:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042072b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042072b5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80042072b8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80042072bc:	7e 52                	jle    8004207310 <getint+0x67>
		x=va_arg(*ap, long long);
  80042072be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072c2:	8b 00                	mov    (%rax),%eax
  80042072c4:	83 f8 30             	cmp    $0x30,%eax
  80042072c7:	73 24                	jae    80042072ed <getint+0x44>
  80042072c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072cd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042072d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072d5:	8b 00                	mov    (%rax),%eax
  80042072d7:	89 c0                	mov    %eax,%eax
  80042072d9:	48 01 d0             	add    %rdx,%rax
  80042072dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042072e0:	8b 12                	mov    (%rdx),%edx
  80042072e2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042072e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042072e9:	89 0a                	mov    %ecx,(%rdx)
  80042072eb:	eb 17                	jmp    8004207304 <getint+0x5b>
  80042072ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042072f1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80042072f5:	48 89 d0             	mov    %rdx,%rax
  80042072f8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042072fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207300:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004207304:	48 8b 00             	mov    (%rax),%rax
  8004207307:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420730b:	e9 a3 00 00 00       	jmpq   80042073b3 <getint+0x10a>
	else if (lflag)
  8004207310:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004207314:	74 4f                	je     8004207365 <getint+0xbc>
		x=va_arg(*ap, long);
  8004207316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420731a:	8b 00                	mov    (%rax),%eax
  800420731c:	83 f8 30             	cmp    $0x30,%eax
  800420731f:	73 24                	jae    8004207345 <getint+0x9c>
  8004207321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207325:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420732d:	8b 00                	mov    (%rax),%eax
  800420732f:	89 c0                	mov    %eax,%eax
  8004207331:	48 01 d0             	add    %rdx,%rax
  8004207334:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207338:	8b 12                	mov    (%rdx),%edx
  800420733a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420733d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207341:	89 0a                	mov    %ecx,(%rdx)
  8004207343:	eb 17                	jmp    800420735c <getint+0xb3>
  8004207345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207349:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420734d:	48 89 d0             	mov    %rdx,%rax
  8004207350:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004207354:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207358:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800420735c:	48 8b 00             	mov    (%rax),%rax
  800420735f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004207363:	eb 4e                	jmp    80042073b3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8004207365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207369:	8b 00                	mov    (%rax),%eax
  800420736b:	83 f8 30             	cmp    $0x30,%eax
  800420736e:	73 24                	jae    8004207394 <getint+0xeb>
  8004207370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207374:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004207378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420737c:	8b 00                	mov    (%rax),%eax
  800420737e:	89 c0                	mov    %eax,%eax
  8004207380:	48 01 d0             	add    %rdx,%rax
  8004207383:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207387:	8b 12                	mov    (%rdx),%edx
  8004207389:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800420738c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207390:	89 0a                	mov    %ecx,(%rdx)
  8004207392:	eb 17                	jmp    80042073ab <getint+0x102>
  8004207394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207398:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420739c:	48 89 d0             	mov    %rdx,%rax
  800420739f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80042073a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042073a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042073ab:	8b 00                	mov    (%rax),%eax
  80042073ad:	48 98                	cltq   
  80042073af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80042073b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80042073b7:	c9                   	leaveq 
  80042073b8:	c3                   	retq   

00000080042073b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042073b9:	55                   	push   %rbp
  80042073ba:	48 89 e5             	mov    %rsp,%rbp
  80042073bd:	41 54                	push   %r12
  80042073bf:	53                   	push   %rbx
  80042073c0:	48 83 ec 60          	sub    $0x60,%rsp
  80042073c4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80042073c8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80042073cc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80042073d0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80042073d4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80042073d8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80042073dc:	48 8b 0a             	mov    (%rdx),%rcx
  80042073df:	48 89 08             	mov    %rcx,(%rax)
  80042073e2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80042073e6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042073ea:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042073ee:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042073f2:	eb 17                	jmp    800420740b <vprintfmt+0x52>
			if (ch == '\0')
  80042073f4:	85 db                	test   %ebx,%ebx
  80042073f6:	0f 84 df 04 00 00    	je     80042078db <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80042073fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004207400:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207404:	48 89 d6             	mov    %rdx,%rsi
  8004207407:	89 df                	mov    %ebx,%edi
  8004207409:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800420740b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420740f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207413:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8004207417:	0f b6 00             	movzbl (%rax),%eax
  800420741a:	0f b6 d8             	movzbl %al,%ebx
  800420741d:	83 fb 25             	cmp    $0x25,%ebx
  8004207420:	75 d2                	jne    80042073f4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004207422:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8004207426:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800420742d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8004207434:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800420743b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004207442:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004207446:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420744a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800420744e:	0f b6 00             	movzbl (%rax),%eax
  8004207451:	0f b6 d8             	movzbl %al,%ebx
  8004207454:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8004207457:	83 f8 55             	cmp    $0x55,%eax
  800420745a:	0f 87 47 04 00 00    	ja     80042078a7 <vprintfmt+0x4ee>
  8004207460:	89 c0                	mov    %eax,%eax
  8004207462:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004207469:	00 
  800420746a:	48 b8 d8 f7 20 04 80 	movabs $0x800420f7d8,%rax
  8004207471:	00 00 00 
  8004207474:	48 01 d0             	add    %rdx,%rax
  8004207477:	48 8b 00             	mov    (%rax),%rax
  800420747a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800420747c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8004207480:	eb c0                	jmp    8004207442 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004207482:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8004207486:	eb ba                	jmp    8004207442 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004207488:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800420748f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8004207492:	89 d0                	mov    %edx,%eax
  8004207494:	c1 e0 02             	shl    $0x2,%eax
  8004207497:	01 d0                	add    %edx,%eax
  8004207499:	01 c0                	add    %eax,%eax
  800420749b:	01 d8                	add    %ebx,%eax
  800420749d:	83 e8 30             	sub    $0x30,%eax
  80042074a0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80042074a3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042074a7:	0f b6 00             	movzbl (%rax),%eax
  80042074aa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80042074ad:	83 fb 2f             	cmp    $0x2f,%ebx
  80042074b0:	7e 0c                	jle    80042074be <vprintfmt+0x105>
  80042074b2:	83 fb 39             	cmp    $0x39,%ebx
  80042074b5:	7f 07                	jg     80042074be <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80042074b7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80042074bc:	eb d1                	jmp    800420748f <vprintfmt+0xd6>
			goto process_precision;
  80042074be:	eb 58                	jmp    8004207518 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80042074c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042074c3:	83 f8 30             	cmp    $0x30,%eax
  80042074c6:	73 17                	jae    80042074df <vprintfmt+0x126>
  80042074c8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042074cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80042074cf:	89 c0                	mov    %eax,%eax
  80042074d1:	48 01 d0             	add    %rdx,%rax
  80042074d4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80042074d7:	83 c2 08             	add    $0x8,%edx
  80042074da:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80042074dd:	eb 0f                	jmp    80042074ee <vprintfmt+0x135>
  80042074df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042074e3:	48 89 d0             	mov    %rdx,%rax
  80042074e6:	48 83 c2 08          	add    $0x8,%rdx
  80042074ea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80042074ee:	8b 00                	mov    (%rax),%eax
  80042074f0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80042074f3:	eb 23                	jmp    8004207518 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80042074f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042074f9:	79 0c                	jns    8004207507 <vprintfmt+0x14e>
				width = 0;
  80042074fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8004207502:	e9 3b ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>
  8004207507:	e9 36 ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800420750c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8004207513:	e9 2a ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8004207518:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420751c:	79 12                	jns    8004207530 <vprintfmt+0x177>
				width = precision, precision = -1;
  800420751e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8004207521:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8004207524:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800420752b:	e9 12 ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>
  8004207530:	e9 0d ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004207535:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8004207539:	e9 04 ff ff ff       	jmpq   8004207442 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800420753e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004207541:	83 f8 30             	cmp    $0x30,%eax
  8004207544:	73 17                	jae    800420755d <vprintfmt+0x1a4>
  8004207546:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420754a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420754d:	89 c0                	mov    %eax,%eax
  800420754f:	48 01 d0             	add    %rdx,%rax
  8004207552:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8004207555:	83 c2 08             	add    $0x8,%edx
  8004207558:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800420755b:	eb 0f                	jmp    800420756c <vprintfmt+0x1b3>
  800420755d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004207561:	48 89 d0             	mov    %rdx,%rax
  8004207564:	48 83 c2 08          	add    $0x8,%rdx
  8004207568:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800420756c:	8b 10                	mov    (%rax),%edx
  800420756e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8004207572:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207576:	48 89 ce             	mov    %rcx,%rsi
  8004207579:	89 d7                	mov    %edx,%edi
  800420757b:	ff d0                	callq  *%rax
			break;
  800420757d:	e9 53 03 00 00       	jmpq   80042078d5 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8004207582:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004207585:	83 f8 30             	cmp    $0x30,%eax
  8004207588:	73 17                	jae    80042075a1 <vprintfmt+0x1e8>
  800420758a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420758e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004207591:	89 c0                	mov    %eax,%eax
  8004207593:	48 01 d0             	add    %rdx,%rax
  8004207596:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8004207599:	83 c2 08             	add    $0x8,%edx
  800420759c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800420759f:	eb 0f                	jmp    80042075b0 <vprintfmt+0x1f7>
  80042075a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80042075a5:	48 89 d0             	mov    %rdx,%rax
  80042075a8:	48 83 c2 08          	add    $0x8,%rdx
  80042075ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80042075b0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80042075b2:	85 db                	test   %ebx,%ebx
  80042075b4:	79 02                	jns    80042075b8 <vprintfmt+0x1ff>
				err = -err;
  80042075b6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042075b8:	83 fb 15             	cmp    $0x15,%ebx
  80042075bb:	7f 16                	jg     80042075d3 <vprintfmt+0x21a>
  80042075bd:	48 b8 00 f7 20 04 80 	movabs $0x800420f700,%rax
  80042075c4:	00 00 00 
  80042075c7:	48 63 d3             	movslq %ebx,%rdx
  80042075ca:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80042075ce:	4d 85 e4             	test   %r12,%r12
  80042075d1:	75 2e                	jne    8004207601 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80042075d3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80042075d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042075db:	89 d9                	mov    %ebx,%ecx
  80042075dd:	48 ba c1 f7 20 04 80 	movabs $0x800420f7c1,%rdx
  80042075e4:	00 00 00 
  80042075e7:	48 89 c7             	mov    %rax,%rdi
  80042075ea:	b8 00 00 00 00       	mov    $0x0,%eax
  80042075ef:	49 b8 e4 78 20 04 80 	movabs $0x80042078e4,%r8
  80042075f6:	00 00 00 
  80042075f9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80042075fc:	e9 d4 02 00 00       	jmpq   80042078d5 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004207601:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8004207605:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207609:	4c 89 e1             	mov    %r12,%rcx
  800420760c:	48 ba ca f7 20 04 80 	movabs $0x800420f7ca,%rdx
  8004207613:	00 00 00 
  8004207616:	48 89 c7             	mov    %rax,%rdi
  8004207619:	b8 00 00 00 00       	mov    $0x0,%eax
  800420761e:	49 b8 e4 78 20 04 80 	movabs $0x80042078e4,%r8
  8004207625:	00 00 00 
  8004207628:	41 ff d0             	callq  *%r8
			break;
  800420762b:	e9 a5 02 00 00       	jmpq   80042078d5 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8004207630:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004207633:	83 f8 30             	cmp    $0x30,%eax
  8004207636:	73 17                	jae    800420764f <vprintfmt+0x296>
  8004207638:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420763c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420763f:	89 c0                	mov    %eax,%eax
  8004207641:	48 01 d0             	add    %rdx,%rax
  8004207644:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8004207647:	83 c2 08             	add    $0x8,%edx
  800420764a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800420764d:	eb 0f                	jmp    800420765e <vprintfmt+0x2a5>
  800420764f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004207653:	48 89 d0             	mov    %rdx,%rax
  8004207656:	48 83 c2 08          	add    $0x8,%rdx
  800420765a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800420765e:	4c 8b 20             	mov    (%rax),%r12
  8004207661:	4d 85 e4             	test   %r12,%r12
  8004207664:	75 0a                	jne    8004207670 <vprintfmt+0x2b7>
				p = "(null)";
  8004207666:	49 bc cd f7 20 04 80 	movabs $0x800420f7cd,%r12
  800420766d:	00 00 00 
			if (width > 0 && padc != '-')
  8004207670:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8004207674:	7e 3f                	jle    80042076b5 <vprintfmt+0x2fc>
  8004207676:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800420767a:	74 39                	je     80042076b5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800420767c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800420767f:	48 98                	cltq   
  8004207681:	48 89 c6             	mov    %rax,%rsi
  8004207684:	4c 89 e7             	mov    %r12,%rdi
  8004207687:	48 b8 df 7c 20 04 80 	movabs $0x8004207cdf,%rax
  800420768e:	00 00 00 
  8004207691:	ff d0                	callq  *%rax
  8004207693:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8004207696:	eb 17                	jmp    80042076af <vprintfmt+0x2f6>
					putch(padc, putdat);
  8004207698:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800420769c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80042076a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042076a4:	48 89 ce             	mov    %rcx,%rsi
  80042076a7:	89 d7                	mov    %edx,%edi
  80042076a9:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80042076ab:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80042076af:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80042076b3:	7f e3                	jg     8004207698 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80042076b5:	eb 37                	jmp    80042076ee <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80042076b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80042076bb:	74 1e                	je     80042076db <vprintfmt+0x322>
  80042076bd:	83 fb 1f             	cmp    $0x1f,%ebx
  80042076c0:	7e 05                	jle    80042076c7 <vprintfmt+0x30e>
  80042076c2:	83 fb 7e             	cmp    $0x7e,%ebx
  80042076c5:	7e 14                	jle    80042076db <vprintfmt+0x322>
					putch('?', putdat);
  80042076c7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042076cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042076cf:	48 89 d6             	mov    %rdx,%rsi
  80042076d2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80042076d7:	ff d0                	callq  *%rax
  80042076d9:	eb 0f                	jmp    80042076ea <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80042076db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042076df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042076e3:	48 89 d6             	mov    %rdx,%rsi
  80042076e6:	89 df                	mov    %ebx,%edi
  80042076e8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80042076ea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80042076ee:	4c 89 e0             	mov    %r12,%rax
  80042076f1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80042076f5:	0f b6 00             	movzbl (%rax),%eax
  80042076f8:	0f be d8             	movsbl %al,%ebx
  80042076fb:	85 db                	test   %ebx,%ebx
  80042076fd:	74 10                	je     800420770f <vprintfmt+0x356>
  80042076ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8004207703:	78 b2                	js     80042076b7 <vprintfmt+0x2fe>
  8004207705:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8004207709:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800420770d:	79 a8                	jns    80042076b7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800420770f:	eb 16                	jmp    8004207727 <vprintfmt+0x36e>
				putch(' ', putdat);
  8004207711:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004207715:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004207719:	48 89 d6             	mov    %rdx,%rsi
  800420771c:	bf 20 00 00 00       	mov    $0x20,%edi
  8004207721:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8004207723:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8004207727:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420772b:	7f e4                	jg     8004207711 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800420772d:	e9 a3 01 00 00       	jmpq   80042078d5 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8004207732:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004207736:	be 03 00 00 00       	mov    $0x3,%esi
  800420773b:	48 89 c7             	mov    %rax,%rdi
  800420773e:	48 b8 a9 72 20 04 80 	movabs $0x80042072a9,%rax
  8004207745:	00 00 00 
  8004207748:	ff d0                	callq  *%rax
  800420774a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800420774e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207752:	48 85 c0             	test   %rax,%rax
  8004207755:	79 1d                	jns    8004207774 <vprintfmt+0x3bb>
				putch('-', putdat);
  8004207757:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420775b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420775f:	48 89 d6             	mov    %rdx,%rsi
  8004207762:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8004207767:	ff d0                	callq  *%rax
				num = -(long long) num;
  8004207769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420776d:	48 f7 d8             	neg    %rax
  8004207770:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8004207774:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800420777b:	e9 e8 00 00 00       	jmpq   8004207868 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8004207780:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004207784:	be 03 00 00 00       	mov    $0x3,%esi
  8004207789:	48 89 c7             	mov    %rax,%rdi
  800420778c:	48 b8 99 71 20 04 80 	movabs $0x8004207199,%rax
  8004207793:	00 00 00 
  8004207796:	ff d0                	callq  *%rax
  8004207798:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800420779c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80042077a3:	e9 c0 00 00 00       	jmpq   8004207868 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80042077a8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042077ac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042077b0:	48 89 d6             	mov    %rdx,%rsi
  80042077b3:	bf 58 00 00 00       	mov    $0x58,%edi
  80042077b8:	ff d0                	callq  *%rax
			putch('X', putdat);
  80042077ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042077be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042077c2:	48 89 d6             	mov    %rdx,%rsi
  80042077c5:	bf 58 00 00 00       	mov    $0x58,%edi
  80042077ca:	ff d0                	callq  *%rax
			putch('X', putdat);
  80042077cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042077d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042077d4:	48 89 d6             	mov    %rdx,%rsi
  80042077d7:	bf 58 00 00 00       	mov    $0x58,%edi
  80042077dc:	ff d0                	callq  *%rax
			break;
  80042077de:	e9 f2 00 00 00       	jmpq   80042078d5 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  80042077e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042077e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042077eb:	48 89 d6             	mov    %rdx,%rsi
  80042077ee:	bf 30 00 00 00       	mov    $0x30,%edi
  80042077f3:	ff d0                	callq  *%rax
			putch('x', putdat);
  80042077f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042077f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042077fd:	48 89 d6             	mov    %rdx,%rsi
  8004207800:	bf 78 00 00 00       	mov    $0x78,%edi
  8004207805:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8004207807:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800420780a:	83 f8 30             	cmp    $0x30,%eax
  800420780d:	73 17                	jae    8004207826 <vprintfmt+0x46d>
  800420780f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004207813:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004207816:	89 c0                	mov    %eax,%eax
  8004207818:	48 01 d0             	add    %rdx,%rax
  800420781b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800420781e:	83 c2 08             	add    $0x8,%edx
  8004207821:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8004207824:	eb 0f                	jmp    8004207835 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  8004207826:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420782a:	48 89 d0             	mov    %rdx,%rax
  800420782d:	48 83 c2 08          	add    $0x8,%rdx
  8004207831:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8004207835:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8004207838:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800420783c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8004207843:	eb 23                	jmp    8004207868 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8004207845:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8004207849:	be 03 00 00 00       	mov    $0x3,%esi
  800420784e:	48 89 c7             	mov    %rax,%rdi
  8004207851:	48 b8 99 71 20 04 80 	movabs $0x8004207199,%rax
  8004207858:	00 00 00 
  800420785b:	ff d0                	callq  *%rax
  800420785d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8004207861:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8004207868:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800420786d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004207870:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8004207873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207877:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800420787b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420787f:	45 89 c1             	mov    %r8d,%r9d
  8004207882:	41 89 f8             	mov    %edi,%r8d
  8004207885:	48 89 c7             	mov    %rax,%rdi
  8004207888:	48 b8 de 70 20 04 80 	movabs $0x80042070de,%rax
  800420788f:	00 00 00 
  8004207892:	ff d0                	callq  *%rax
			break;
  8004207894:	eb 3f                	jmp    80042078d5 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8004207896:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420789a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420789e:	48 89 d6             	mov    %rdx,%rsi
  80042078a1:	89 df                	mov    %ebx,%edi
  80042078a3:	ff d0                	callq  *%rax
			break;
  80042078a5:	eb 2e                	jmp    80042078d5 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80042078a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80042078ab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042078af:	48 89 d6             	mov    %rdx,%rsi
  80042078b2:	bf 25 00 00 00       	mov    $0x25,%edi
  80042078b7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80042078b9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80042078be:	eb 05                	jmp    80042078c5 <vprintfmt+0x50c>
  80042078c0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80042078c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042078c9:	48 83 e8 01          	sub    $0x1,%rax
  80042078cd:	0f b6 00             	movzbl (%rax),%eax
  80042078d0:	3c 25                	cmp    $0x25,%al
  80042078d2:	75 ec                	jne    80042078c0 <vprintfmt+0x507>
				/* do nothing */;
			break;
  80042078d4:	90                   	nop
		}
	}
  80042078d5:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80042078d6:	e9 30 fb ff ff       	jmpq   800420740b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80042078db:	48 83 c4 60          	add    $0x60,%rsp
  80042078df:	5b                   	pop    %rbx
  80042078e0:	41 5c                	pop    %r12
  80042078e2:	5d                   	pop    %rbp
  80042078e3:	c3                   	retq   

00000080042078e4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80042078e4:	55                   	push   %rbp
  80042078e5:	48 89 e5             	mov    %rsp,%rbp
  80042078e8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80042078ef:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80042078f6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80042078fd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004207904:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800420790b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004207912:	84 c0                	test   %al,%al
  8004207914:	74 20                	je     8004207936 <printfmt+0x52>
  8004207916:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800420791a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800420791e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004207922:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004207926:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800420792a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800420792e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004207932:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004207936:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800420793d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8004207944:	00 00 00 
  8004207947:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800420794e:	00 00 00 
  8004207951:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004207955:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800420795c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004207963:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800420796a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8004207971:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004207978:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800420797f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8004207986:	48 89 c7             	mov    %rax,%rdi
  8004207989:	48 b8 b9 73 20 04 80 	movabs $0x80042073b9,%rax
  8004207990:	00 00 00 
  8004207993:	ff d0                	callq  *%rax
	va_end(ap);
}
  8004207995:	c9                   	leaveq 
  8004207996:	c3                   	retq   

0000008004207997 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004207997:	55                   	push   %rbp
  8004207998:	48 89 e5             	mov    %rsp,%rbp
  800420799b:	48 83 ec 10          	sub    $0x10,%rsp
  800420799f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042079a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80042079a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042079aa:	8b 40 10             	mov    0x10(%rax),%eax
  80042079ad:	8d 50 01             	lea    0x1(%rax),%edx
  80042079b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042079b4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80042079b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042079bb:	48 8b 10             	mov    (%rax),%rdx
  80042079be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042079c2:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042079c6:	48 39 c2             	cmp    %rax,%rdx
  80042079c9:	73 17                	jae    80042079e2 <sprintputch+0x4b>
		*b->buf++ = ch;
  80042079cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042079cf:	48 8b 00             	mov    (%rax),%rax
  80042079d2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80042079d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042079da:	48 89 0a             	mov    %rcx,(%rdx)
  80042079dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042079e0:	88 10                	mov    %dl,(%rax)
}
  80042079e2:	c9                   	leaveq 
  80042079e3:	c3                   	retq   

00000080042079e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80042079e4:	55                   	push   %rbp
  80042079e5:	48 89 e5             	mov    %rsp,%rbp
  80042079e8:	48 83 ec 50          	sub    $0x50,%rsp
  80042079ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80042079f0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80042079f3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80042079f7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80042079fb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80042079ff:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004207a03:	48 8b 0a             	mov    (%rdx),%rcx
  8004207a06:	48 89 08             	mov    %rcx,(%rax)
  8004207a09:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004207a0d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004207a11:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004207a15:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8004207a19:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207a1d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8004207a21:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8004207a24:	48 98                	cltq   
  8004207a26:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8004207a2a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004207a2e:	48 01 d0             	add    %rdx,%rax
  8004207a31:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8004207a35:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8004207a3c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004207a41:	74 06                	je     8004207a49 <vsnprintf+0x65>
  8004207a43:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8004207a47:	7f 07                	jg     8004207a50 <vsnprintf+0x6c>
		return -E_INVAL;
  8004207a49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004207a4e:	eb 2f                	jmp    8004207a7f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8004207a50:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8004207a54:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004207a58:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8004207a5c:	48 89 c6             	mov    %rax,%rsi
  8004207a5f:	48 bf 97 79 20 04 80 	movabs $0x8004207997,%rdi
  8004207a66:	00 00 00 
  8004207a69:	48 b8 b9 73 20 04 80 	movabs $0x80042073b9,%rax
  8004207a70:	00 00 00 
  8004207a73:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8004207a75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004207a79:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8004207a7c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8004207a7f:	c9                   	leaveq 
  8004207a80:	c3                   	retq   

0000008004207a81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8004207a81:	55                   	push   %rbp
  8004207a82:	48 89 e5             	mov    %rsp,%rbp
  8004207a85:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004207a8c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8004207a93:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8004207a99:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004207aa0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004207aa7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004207aae:	84 c0                	test   %al,%al
  8004207ab0:	74 20                	je     8004207ad2 <snprintf+0x51>
  8004207ab2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004207ab6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004207aba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004207abe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004207ac2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004207ac6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004207aca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004207ace:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004207ad2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8004207ad9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8004207ae0:	00 00 00 
  8004207ae3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004207aea:	00 00 00 
  8004207aed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004207af1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004207af8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004207aff:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004207b06:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004207b0d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004207b14:	48 8b 0a             	mov    (%rdx),%rcx
  8004207b17:	48 89 08             	mov    %rcx,(%rax)
  8004207b1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004207b1e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004207b22:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004207b26:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8004207b2a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8004207b31:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8004207b38:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8004207b3e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004207b45:	48 89 c7             	mov    %rax,%rdi
  8004207b48:	48 b8 e4 79 20 04 80 	movabs $0x80042079e4,%rax
  8004207b4f:	00 00 00 
  8004207b52:	ff d0                	callq  *%rax
  8004207b54:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8004207b5a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004207b60:	c9                   	leaveq 
  8004207b61:	c3                   	retq   

0000008004207b62 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8004207b62:	55                   	push   %rbp
  8004207b63:	48 89 e5             	mov    %rsp,%rbp
  8004207b66:	48 83 ec 20          	sub    $0x20,%rsp
  8004207b6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, c, echoing;

	if (prompt != NULL)
  8004207b6e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004207b73:	74 22                	je     8004207b97 <readline+0x35>
		cprintf("%s", prompt);
  8004207b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207b79:	48 89 c6             	mov    %rax,%rsi
  8004207b7c:	48 bf 88 fa 20 04 80 	movabs $0x800420fa88,%rdi
  8004207b83:	00 00 00 
  8004207b86:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207b8b:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004207b92:	00 00 00 
  8004207b95:	ff d2                	callq  *%rdx

	i = 0;
  8004207b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8004207b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  8004207ba3:	48 b8 0f 0e 20 04 80 	movabs $0x8004200e0f,%rax
  8004207baa:	00 00 00 
  8004207bad:	ff d0                	callq  *%rax
  8004207baf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8004207bb2:	48 b8 ed 0d 20 04 80 	movabs $0x8004200ded,%rax
  8004207bb9:	00 00 00 
  8004207bbc:	ff d0                	callq  *%rax
  8004207bbe:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8004207bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004207bc5:	79 2a                	jns    8004207bf1 <readline+0x8f>
			cprintf("read error: %e\n", c);
  8004207bc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004207bca:	89 c6                	mov    %eax,%esi
  8004207bcc:	48 bf 8b fa 20 04 80 	movabs $0x800420fa8b,%rdi
  8004207bd3:	00 00 00 
  8004207bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207bdb:	48 ba 66 64 20 04 80 	movabs $0x8004206466,%rdx
  8004207be2:	00 00 00 
  8004207be5:	ff d2                	callq  *%rdx
			return NULL;
  8004207be7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207bec:	e9 be 00 00 00       	jmpq   8004207caf <readline+0x14d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8004207bf1:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  8004207bf5:	74 06                	je     8004207bfd <readline+0x9b>
  8004207bf7:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8004207bfb:	75 26                	jne    8004207c23 <readline+0xc1>
  8004207bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004207c01:	7e 20                	jle    8004207c23 <readline+0xc1>
			if (echoing)
  8004207c03:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004207c07:	74 11                	je     8004207c1a <readline+0xb8>
				cputchar('\b');
  8004207c09:	bf 08 00 00 00       	mov    $0x8,%edi
  8004207c0e:	48 b8 cf 0d 20 04 80 	movabs $0x8004200dcf,%rax
  8004207c15:	00 00 00 
  8004207c18:	ff d0                	callq  *%rax
			i--;
  8004207c1a:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  8004207c1e:	e9 87 00 00 00       	jmpq   8004207caa <readline+0x148>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8004207c23:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004207c27:	7e 3f                	jle    8004207c68 <readline+0x106>
  8004207c29:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8004207c30:	7f 36                	jg     8004207c68 <readline+0x106>
			if (echoing)
  8004207c32:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004207c36:	74 11                	je     8004207c49 <readline+0xe7>
				cputchar(c);
  8004207c38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004207c3b:	89 c7                	mov    %eax,%edi
  8004207c3d:	48 b8 cf 0d 20 04 80 	movabs $0x8004200dcf,%rax
  8004207c44:	00 00 00 
  8004207c47:	ff d0                	callq  *%rax
			buf[i++] = c;
  8004207c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004207c4c:	8d 50 01             	lea    0x1(%rax),%edx
  8004207c4f:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8004207c52:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8004207c55:	89 d1                	mov    %edx,%ecx
  8004207c57:	48 ba 00 29 22 04 80 	movabs $0x8004222900,%rdx
  8004207c5e:	00 00 00 
  8004207c61:	48 98                	cltq   
  8004207c63:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8004207c66:	eb 42                	jmp    8004207caa <readline+0x148>
		} else if (c == '\n' || c == '\r') {
  8004207c68:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8004207c6c:	74 06                	je     8004207c74 <readline+0x112>
  8004207c6e:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8004207c72:	75 36                	jne    8004207caa <readline+0x148>
			if (echoing)
  8004207c74:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8004207c78:	74 11                	je     8004207c8b <readline+0x129>
				cputchar('\n');
  8004207c7a:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004207c7f:	48 b8 cf 0d 20 04 80 	movabs $0x8004200dcf,%rax
  8004207c86:	00 00 00 
  8004207c89:	ff d0                	callq  *%rax
			buf[i] = 0;
  8004207c8b:	48 ba 00 29 22 04 80 	movabs $0x8004222900,%rdx
  8004207c92:	00 00 00 
  8004207c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004207c98:	48 98                	cltq   
  8004207c9a:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8004207c9e:	48 b8 00 29 22 04 80 	movabs $0x8004222900,%rax
  8004207ca5:	00 00 00 
  8004207ca8:	eb 05                	jmp    8004207caf <readline+0x14d>
		}
	}
  8004207caa:	e9 03 ff ff ff       	jmpq   8004207bb2 <readline+0x50>
}
  8004207caf:	c9                   	leaveq 
  8004207cb0:	c3                   	retq   

0000008004207cb1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8004207cb1:	55                   	push   %rbp
  8004207cb2:	48 89 e5             	mov    %rsp,%rbp
  8004207cb5:	48 83 ec 18          	sub    $0x18,%rsp
  8004207cb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8004207cbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004207cc4:	eb 09                	jmp    8004207ccf <strlen+0x1e>
		n++;
  8004207cc6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8004207cca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004207ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207cd3:	0f b6 00             	movzbl (%rax),%eax
  8004207cd6:	84 c0                	test   %al,%al
  8004207cd8:	75 ec                	jne    8004207cc6 <strlen+0x15>
		n++;
	return n;
  8004207cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004207cdd:	c9                   	leaveq 
  8004207cde:	c3                   	retq   

0000008004207cdf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8004207cdf:	55                   	push   %rbp
  8004207ce0:	48 89 e5             	mov    %rsp,%rbp
  8004207ce3:	48 83 ec 20          	sub    $0x20,%rsp
  8004207ce7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207ceb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004207cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8004207cf6:	eb 0e                	jmp    8004207d06 <strnlen+0x27>
		n++;
  8004207cf8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8004207cfc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004207d01:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8004207d06:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8004207d0b:	74 0b                	je     8004207d18 <strnlen+0x39>
  8004207d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207d11:	0f b6 00             	movzbl (%rax),%eax
  8004207d14:	84 c0                	test   %al,%al
  8004207d16:	75 e0                	jne    8004207cf8 <strnlen+0x19>
		n++;
	return n;
  8004207d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004207d1b:	c9                   	leaveq 
  8004207d1c:	c3                   	retq   

0000008004207d1d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8004207d1d:	55                   	push   %rbp
  8004207d1e:	48 89 e5             	mov    %rsp,%rbp
  8004207d21:	48 83 ec 20          	sub    $0x20,%rsp
  8004207d25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207d29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8004207d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207d31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8004207d35:	90                   	nop
  8004207d36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207d3a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207d3e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004207d42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207d46:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004207d4a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004207d4e:	0f b6 12             	movzbl (%rdx),%edx
  8004207d51:	88 10                	mov    %dl,(%rax)
  8004207d53:	0f b6 00             	movzbl (%rax),%eax
  8004207d56:	84 c0                	test   %al,%al
  8004207d58:	75 dc                	jne    8004207d36 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8004207d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004207d5e:	c9                   	leaveq 
  8004207d5f:	c3                   	retq   

0000008004207d60 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8004207d60:	55                   	push   %rbp
  8004207d61:	48 89 e5             	mov    %rsp,%rbp
  8004207d64:	48 83 ec 20          	sub    $0x20,%rsp
  8004207d68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207d6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8004207d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207d74:	48 89 c7             	mov    %rax,%rdi
  8004207d77:	48 b8 b1 7c 20 04 80 	movabs $0x8004207cb1,%rax
  8004207d7e:	00 00 00 
  8004207d81:	ff d0                	callq  *%rax
  8004207d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8004207d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004207d89:	48 63 d0             	movslq %eax,%rdx
  8004207d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207d90:	48 01 c2             	add    %rax,%rdx
  8004207d93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004207d97:	48 89 c6             	mov    %rax,%rsi
  8004207d9a:	48 89 d7             	mov    %rdx,%rdi
  8004207d9d:	48 b8 1d 7d 20 04 80 	movabs $0x8004207d1d,%rax
  8004207da4:	00 00 00 
  8004207da7:	ff d0                	callq  *%rax
	return dst;
  8004207da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004207dad:	c9                   	leaveq 
  8004207dae:	c3                   	retq   

0000008004207daf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8004207daf:	55                   	push   %rbp
  8004207db0:	48 89 e5             	mov    %rsp,%rbp
  8004207db3:	48 83 ec 28          	sub    $0x28,%rsp
  8004207db7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207dbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004207dbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8004207dc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207dc7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8004207dcb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004207dd2:	00 
  8004207dd3:	eb 2a                	jmp    8004207dff <strncpy+0x50>
		*dst++ = *src;
  8004207dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207dd9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207ddd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004207de1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207de5:	0f b6 12             	movzbl (%rdx),%edx
  8004207de8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8004207dea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004207dee:	0f b6 00             	movzbl (%rax),%eax
  8004207df1:	84 c0                	test   %al,%al
  8004207df3:	74 05                	je     8004207dfa <strncpy+0x4b>
			src++;
  8004207df5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8004207dfa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004207dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207e03:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004207e07:	72 cc                	jb     8004207dd5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8004207e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004207e0d:	c9                   	leaveq 
  8004207e0e:	c3                   	retq   

0000008004207e0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8004207e0f:	55                   	push   %rbp
  8004207e10:	48 89 e5             	mov    %rsp,%rbp
  8004207e13:	48 83 ec 28          	sub    $0x28,%rsp
  8004207e17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004207e1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004207e1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8004207e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207e27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8004207e2b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004207e30:	74 3d                	je     8004207e6f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8004207e32:	eb 1d                	jmp    8004207e51 <strlcpy+0x42>
			*dst++ = *src++;
  8004207e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207e38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004207e3c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004207e40:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004207e44:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8004207e48:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8004207e4c:	0f b6 12             	movzbl (%rdx),%edx
  8004207e4f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8004207e51:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8004207e56:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004207e5b:	74 0b                	je     8004207e68 <strlcpy+0x59>
  8004207e5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004207e61:	0f b6 00             	movzbl (%rax),%eax
  8004207e64:	84 c0                	test   %al,%al
  8004207e66:	75 cc                	jne    8004207e34 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8004207e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207e6c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8004207e6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004207e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207e77:	48 29 c2             	sub    %rax,%rdx
  8004207e7a:	48 89 d0             	mov    %rdx,%rax
}
  8004207e7d:	c9                   	leaveq 
  8004207e7e:	c3                   	retq   

0000008004207e7f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8004207e7f:	55                   	push   %rbp
  8004207e80:	48 89 e5             	mov    %rsp,%rbp
  8004207e83:	48 83 ec 10          	sub    $0x10,%rsp
  8004207e87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207e8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8004207e8f:	eb 0a                	jmp    8004207e9b <strcmp+0x1c>
		p++, q++;
  8004207e91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004207e96:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8004207e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207e9f:	0f b6 00             	movzbl (%rax),%eax
  8004207ea2:	84 c0                	test   %al,%al
  8004207ea4:	74 12                	je     8004207eb8 <strcmp+0x39>
  8004207ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207eaa:	0f b6 10             	movzbl (%rax),%edx
  8004207ead:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004207eb1:	0f b6 00             	movzbl (%rax),%eax
  8004207eb4:	38 c2                	cmp    %al,%dl
  8004207eb6:	74 d9                	je     8004207e91 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8004207eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207ebc:	0f b6 00             	movzbl (%rax),%eax
  8004207ebf:	0f b6 d0             	movzbl %al,%edx
  8004207ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004207ec6:	0f b6 00             	movzbl (%rax),%eax
  8004207ec9:	0f b6 c0             	movzbl %al,%eax
  8004207ecc:	29 c2                	sub    %eax,%edx
  8004207ece:	89 d0                	mov    %edx,%eax
}
  8004207ed0:	c9                   	leaveq 
  8004207ed1:	c3                   	retq   

0000008004207ed2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8004207ed2:	55                   	push   %rbp
  8004207ed3:	48 89 e5             	mov    %rsp,%rbp
  8004207ed6:	48 83 ec 18          	sub    $0x18,%rsp
  8004207eda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207ede:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004207ee2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8004207ee6:	eb 0f                	jmp    8004207ef7 <strncmp+0x25>
		n--, p++, q++;
  8004207ee8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8004207eed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004207ef2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8004207ef7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004207efc:	74 1d                	je     8004207f1b <strncmp+0x49>
  8004207efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f02:	0f b6 00             	movzbl (%rax),%eax
  8004207f05:	84 c0                	test   %al,%al
  8004207f07:	74 12                	je     8004207f1b <strncmp+0x49>
  8004207f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f0d:	0f b6 10             	movzbl (%rax),%edx
  8004207f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004207f14:	0f b6 00             	movzbl (%rax),%eax
  8004207f17:	38 c2                	cmp    %al,%dl
  8004207f19:	74 cd                	je     8004207ee8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8004207f1b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004207f20:	75 07                	jne    8004207f29 <strncmp+0x57>
		return 0;
  8004207f22:	b8 00 00 00 00       	mov    $0x0,%eax
  8004207f27:	eb 18                	jmp    8004207f41 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8004207f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f2d:	0f b6 00             	movzbl (%rax),%eax
  8004207f30:	0f b6 d0             	movzbl %al,%edx
  8004207f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004207f37:	0f b6 00             	movzbl (%rax),%eax
  8004207f3a:	0f b6 c0             	movzbl %al,%eax
  8004207f3d:	29 c2                	sub    %eax,%edx
  8004207f3f:	89 d0                	mov    %edx,%eax
}
  8004207f41:	c9                   	leaveq 
  8004207f42:	c3                   	retq   

0000008004207f43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8004207f43:	55                   	push   %rbp
  8004207f44:	48 89 e5             	mov    %rsp,%rbp
  8004207f47:	48 83 ec 0c          	sub    $0xc,%rsp
  8004207f4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207f4f:	89 f0                	mov    %esi,%eax
  8004207f51:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004207f54:	eb 17                	jmp    8004207f6d <strchr+0x2a>
		if (*s == c)
  8004207f56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f5a:	0f b6 00             	movzbl (%rax),%eax
  8004207f5d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004207f60:	75 06                	jne    8004207f68 <strchr+0x25>
			return (char *) s;
  8004207f62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f66:	eb 15                	jmp    8004207f7d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004207f68:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004207f6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f71:	0f b6 00             	movzbl (%rax),%eax
  8004207f74:	84 c0                	test   %al,%al
  8004207f76:	75 de                	jne    8004207f56 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004207f78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004207f7d:	c9                   	leaveq 
  8004207f7e:	c3                   	retq   

0000008004207f7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004207f7f:	55                   	push   %rbp
  8004207f80:	48 89 e5             	mov    %rsp,%rbp
  8004207f83:	48 83 ec 0c          	sub    $0xc,%rsp
  8004207f87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207f8b:	89 f0                	mov    %esi,%eax
  8004207f8d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004207f90:	eb 13                	jmp    8004207fa5 <strfind+0x26>
		if (*s == c)
  8004207f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207f96:	0f b6 00             	movzbl (%rax),%eax
  8004207f99:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004207f9c:	75 02                	jne    8004207fa0 <strfind+0x21>
			break;
  8004207f9e:	eb 10                	jmp    8004207fb0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004207fa0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004207fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207fa9:	0f b6 00             	movzbl (%rax),%eax
  8004207fac:	84 c0                	test   %al,%al
  8004207fae:	75 e2                	jne    8004207f92 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004207fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004207fb4:	c9                   	leaveq 
  8004207fb5:	c3                   	retq   

0000008004207fb6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004207fb6:	55                   	push   %rbp
  8004207fb7:	48 89 e5             	mov    %rsp,%rbp
  8004207fba:	48 83 ec 18          	sub    $0x18,%rsp
  8004207fbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004207fc2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8004207fc5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8004207fc9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004207fce:	75 06                	jne    8004207fd6 <memset+0x20>
		return v;
  8004207fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207fd4:	eb 69                	jmp    800420803f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8004207fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004207fda:	83 e0 03             	and    $0x3,%eax
  8004207fdd:	48 85 c0             	test   %rax,%rax
  8004207fe0:	75 48                	jne    800420802a <memset+0x74>
  8004207fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004207fe6:	83 e0 03             	and    $0x3,%eax
  8004207fe9:	48 85 c0             	test   %rax,%rax
  8004207fec:	75 3c                	jne    800420802a <memset+0x74>
		c &= 0xFF;
  8004207fee:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8004207ff5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004207ff8:	c1 e0 18             	shl    $0x18,%eax
  8004207ffb:	89 c2                	mov    %eax,%edx
  8004207ffd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208000:	c1 e0 10             	shl    $0x10,%eax
  8004208003:	09 c2                	or     %eax,%edx
  8004208005:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208008:	c1 e0 08             	shl    $0x8,%eax
  800420800b:	09 d0                	or     %edx,%eax
  800420800d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8004208010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208014:	48 c1 e8 02          	shr    $0x2,%rax
  8004208018:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800420801b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420801f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208022:	48 89 d7             	mov    %rdx,%rdi
  8004208025:	fc                   	cld    
  8004208026:	f3 ab                	rep stos %eax,%es:(%rdi)
  8004208028:	eb 11                	jmp    800420803b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800420802a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420802e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208031:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004208035:	48 89 d7             	mov    %rdx,%rdi
  8004208038:	fc                   	cld    
  8004208039:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800420803b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420803f:	c9                   	leaveq 
  8004208040:	c3                   	retq   

0000008004208041 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8004208041:	55                   	push   %rbp
  8004208042:	48 89 e5             	mov    %rsp,%rbp
  8004208045:	48 83 ec 28          	sub    $0x28,%rsp
  8004208049:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420804d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004208051:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8004208055:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208059:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  800420805d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208061:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8004208065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208069:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  800420806d:	0f 83 88 00 00 00    	jae    80042080fb <memmove+0xba>
  8004208073:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208077:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420807b:	48 01 d0             	add    %rdx,%rax
  800420807e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8004208082:	76 77                	jbe    80042080fb <memmove+0xba>
		s += n;
  8004208084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208088:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  800420808c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208090:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8004208094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208098:	83 e0 03             	and    $0x3,%eax
  800420809b:	48 85 c0             	test   %rax,%rax
  800420809e:	75 3b                	jne    80042080db <memmove+0x9a>
  80042080a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042080a4:	83 e0 03             	and    $0x3,%eax
  80042080a7:	48 85 c0             	test   %rax,%rax
  80042080aa:	75 2f                	jne    80042080db <memmove+0x9a>
  80042080ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042080b0:	83 e0 03             	and    $0x3,%eax
  80042080b3:	48 85 c0             	test   %rax,%rax
  80042080b6:	75 23                	jne    80042080db <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80042080b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042080bc:	48 83 e8 04          	sub    $0x4,%rax
  80042080c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80042080c4:	48 83 ea 04          	sub    $0x4,%rdx
  80042080c8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80042080cc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80042080d0:	48 89 c7             	mov    %rax,%rdi
  80042080d3:	48 89 d6             	mov    %rdx,%rsi
  80042080d6:	fd                   	std    
  80042080d7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80042080d9:	eb 1d                	jmp    80042080f8 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80042080db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042080df:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80042080e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042080e7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80042080eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042080ef:	48 89 d7             	mov    %rdx,%rdi
  80042080f2:	48 89 c1             	mov    %rax,%rcx
  80042080f5:	fd                   	std    
  80042080f6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80042080f8:	fc                   	cld    
  80042080f9:	eb 57                	jmp    8004208152 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80042080fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042080ff:	83 e0 03             	and    $0x3,%eax
  8004208102:	48 85 c0             	test   %rax,%rax
  8004208105:	75 36                	jne    800420813d <memmove+0xfc>
  8004208107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420810b:	83 e0 03             	and    $0x3,%eax
  800420810e:	48 85 c0             	test   %rax,%rax
  8004208111:	75 2a                	jne    800420813d <memmove+0xfc>
  8004208113:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208117:	83 e0 03             	and    $0x3,%eax
  800420811a:	48 85 c0             	test   %rax,%rax
  800420811d:	75 1e                	jne    800420813d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800420811f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208123:	48 c1 e8 02          	shr    $0x2,%rax
  8004208127:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800420812a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420812e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208132:	48 89 c7             	mov    %rax,%rdi
  8004208135:	48 89 d6             	mov    %rdx,%rsi
  8004208138:	fc                   	cld    
  8004208139:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800420813b:	eb 15                	jmp    8004208152 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800420813d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208141:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8004208145:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8004208149:	48 89 c7             	mov    %rax,%rdi
  800420814c:	48 89 d6             	mov    %rdx,%rsi
  800420814f:	fc                   	cld    
  8004208150:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8004208152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004208156:	c9                   	leaveq 
  8004208157:	c3                   	retq   

0000008004208158 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8004208158:	55                   	push   %rbp
  8004208159:	48 89 e5             	mov    %rsp,%rbp
  800420815c:	48 83 ec 18          	sub    $0x18,%rsp
  8004208160:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004208164:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004208168:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  800420816c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208170:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004208174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208178:	48 89 ce             	mov    %rcx,%rsi
  800420817b:	48 89 c7             	mov    %rax,%rdi
  800420817e:	48 b8 41 80 20 04 80 	movabs $0x8004208041,%rax
  8004208185:	00 00 00 
  8004208188:	ff d0                	callq  *%rax
}
  800420818a:	c9                   	leaveq 
  800420818b:	c3                   	retq   

000000800420818c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800420818c:	55                   	push   %rbp
  800420818d:	48 89 e5             	mov    %rsp,%rbp
  8004208190:	48 83 ec 28          	sub    $0x28,%rsp
  8004208194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208198:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420819c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80042081a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042081a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80042081a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042081ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80042081b0:	eb 36                	jmp    80042081e8 <memcmp+0x5c>
		if (*s1 != *s2)
  80042081b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042081b6:	0f b6 10             	movzbl (%rax),%edx
  80042081b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042081bd:	0f b6 00             	movzbl (%rax),%eax
  80042081c0:	38 c2                	cmp    %al,%dl
  80042081c2:	74 1a                	je     80042081de <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80042081c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042081c8:	0f b6 00             	movzbl (%rax),%eax
  80042081cb:	0f b6 d0             	movzbl %al,%edx
  80042081ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042081d2:	0f b6 00             	movzbl (%rax),%eax
  80042081d5:	0f b6 c0             	movzbl %al,%eax
  80042081d8:	29 c2                	sub    %eax,%edx
  80042081da:	89 d0                	mov    %edx,%eax
  80042081dc:	eb 20                	jmp    80042081fe <memcmp+0x72>
		s1++, s2++;
  80042081de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80042081e3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80042081e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042081ec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80042081f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042081f4:	48 85 c0             	test   %rax,%rax
  80042081f7:	75 b9                	jne    80042081b2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80042081f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042081fe:	c9                   	leaveq 
  80042081ff:	c3                   	retq   

0000008004208200 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8004208200:	55                   	push   %rbp
  8004208201:	48 89 e5             	mov    %rsp,%rbp
  8004208204:	48 83 ec 28          	sub    $0x28,%rsp
  8004208208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420820c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800420820f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8004208213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208217:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420821b:	48 01 d0             	add    %rdx,%rax
  800420821e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8004208222:	eb 15                	jmp    8004208239 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004208224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208228:	0f b6 10             	movzbl (%rax),%edx
  800420822b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420822e:	38 c2                	cmp    %al,%dl
  8004208230:	75 02                	jne    8004208234 <memfind+0x34>
			break;
  8004208232:	eb 0f                	jmp    8004208243 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8004208234:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8004208239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420823d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004208241:	72 e1                	jb     8004208224 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8004208243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8004208247:	c9                   	leaveq 
  8004208248:	c3                   	retq   

0000008004208249 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004208249:	55                   	push   %rbp
  800420824a:	48 89 e5             	mov    %rsp,%rbp
  800420824d:	48 83 ec 34          	sub    $0x34,%rsp
  8004208251:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004208255:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004208259:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  800420825c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8004208263:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  800420826a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800420826b:	eb 05                	jmp    8004208272 <strtol+0x29>
		s++;
  800420826d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004208272:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208276:	0f b6 00             	movzbl (%rax),%eax
  8004208279:	3c 20                	cmp    $0x20,%al
  800420827b:	74 f0                	je     800420826d <strtol+0x24>
  800420827d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208281:	0f b6 00             	movzbl (%rax),%eax
  8004208284:	3c 09                	cmp    $0x9,%al
  8004208286:	74 e5                	je     800420826d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8004208288:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420828c:	0f b6 00             	movzbl (%rax),%eax
  800420828f:	3c 2b                	cmp    $0x2b,%al
  8004208291:	75 07                	jne    800420829a <strtol+0x51>
		s++;
  8004208293:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8004208298:	eb 17                	jmp    80042082b1 <strtol+0x68>
	else if (*s == '-')
  800420829a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420829e:	0f b6 00             	movzbl (%rax),%eax
  80042082a1:	3c 2d                	cmp    $0x2d,%al
  80042082a3:	75 0c                	jne    80042082b1 <strtol+0x68>
		s++, neg = 1;
  80042082a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80042082aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80042082b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80042082b5:	74 06                	je     80042082bd <strtol+0x74>
  80042082b7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80042082bb:	75 28                	jne    80042082e5 <strtol+0x9c>
  80042082bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042082c1:	0f b6 00             	movzbl (%rax),%eax
  80042082c4:	3c 30                	cmp    $0x30,%al
  80042082c6:	75 1d                	jne    80042082e5 <strtol+0x9c>
  80042082c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042082cc:	48 83 c0 01          	add    $0x1,%rax
  80042082d0:	0f b6 00             	movzbl (%rax),%eax
  80042082d3:	3c 78                	cmp    $0x78,%al
  80042082d5:	75 0e                	jne    80042082e5 <strtol+0x9c>
		s += 2, base = 16;
  80042082d7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80042082dc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80042082e3:	eb 2c                	jmp    8004208311 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80042082e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80042082e9:	75 19                	jne    8004208304 <strtol+0xbb>
  80042082eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042082ef:	0f b6 00             	movzbl (%rax),%eax
  80042082f2:	3c 30                	cmp    $0x30,%al
  80042082f4:	75 0e                	jne    8004208304 <strtol+0xbb>
		s++, base = 8;
  80042082f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80042082fb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8004208302:	eb 0d                	jmp    8004208311 <strtol+0xc8>
	else if (base == 0)
  8004208304:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8004208308:	75 07                	jne    8004208311 <strtol+0xc8>
		base = 10;
  800420830a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8004208311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208315:	0f b6 00             	movzbl (%rax),%eax
  8004208318:	3c 2f                	cmp    $0x2f,%al
  800420831a:	7e 1d                	jle    8004208339 <strtol+0xf0>
  800420831c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208320:	0f b6 00             	movzbl (%rax),%eax
  8004208323:	3c 39                	cmp    $0x39,%al
  8004208325:	7f 12                	jg     8004208339 <strtol+0xf0>
			dig = *s - '0';
  8004208327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420832b:	0f b6 00             	movzbl (%rax),%eax
  800420832e:	0f be c0             	movsbl %al,%eax
  8004208331:	83 e8 30             	sub    $0x30,%eax
  8004208334:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8004208337:	eb 4e                	jmp    8004208387 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8004208339:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420833d:	0f b6 00             	movzbl (%rax),%eax
  8004208340:	3c 60                	cmp    $0x60,%al
  8004208342:	7e 1d                	jle    8004208361 <strtol+0x118>
  8004208344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208348:	0f b6 00             	movzbl (%rax),%eax
  800420834b:	3c 7a                	cmp    $0x7a,%al
  800420834d:	7f 12                	jg     8004208361 <strtol+0x118>
			dig = *s - 'a' + 10;
  800420834f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208353:	0f b6 00             	movzbl (%rax),%eax
  8004208356:	0f be c0             	movsbl %al,%eax
  8004208359:	83 e8 57             	sub    $0x57,%eax
  800420835c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800420835f:	eb 26                	jmp    8004208387 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8004208361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208365:	0f b6 00             	movzbl (%rax),%eax
  8004208368:	3c 40                	cmp    $0x40,%al
  800420836a:	7e 48                	jle    80042083b4 <strtol+0x16b>
  800420836c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208370:	0f b6 00             	movzbl (%rax),%eax
  8004208373:	3c 5a                	cmp    $0x5a,%al
  8004208375:	7f 3d                	jg     80042083b4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8004208377:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420837b:	0f b6 00             	movzbl (%rax),%eax
  800420837e:	0f be c0             	movsbl %al,%eax
  8004208381:	83 e8 37             	sub    $0x37,%eax
  8004208384:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8004208387:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420838a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  800420838d:	7c 02                	jl     8004208391 <strtol+0x148>
			break;
  800420838f:	eb 23                	jmp    80042083b4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8004208391:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8004208396:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8004208399:	48 98                	cltq   
  800420839b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80042083a0:	48 89 c2             	mov    %rax,%rdx
  80042083a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80042083a6:	48 98                	cltq   
  80042083a8:	48 01 d0             	add    %rdx,%rax
  80042083ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80042083af:	e9 5d ff ff ff       	jmpq   8004208311 <strtol+0xc8>

	if (endptr)
  80042083b4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80042083b9:	74 0b                	je     80042083c6 <strtol+0x17d>
		*endptr = (char *) s;
  80042083bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042083bf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80042083c3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80042083c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80042083ca:	74 09                	je     80042083d5 <strtol+0x18c>
  80042083cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042083d0:	48 f7 d8             	neg    %rax
  80042083d3:	eb 04                	jmp    80042083d9 <strtol+0x190>
  80042083d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80042083d9:	c9                   	leaveq 
  80042083da:	c3                   	retq   

00000080042083db <strstr>:

char * strstr(const char *in, const char *str)
{
  80042083db:	55                   	push   %rbp
  80042083dc:	48 89 e5             	mov    %rsp,%rbp
  80042083df:	48 83 ec 30          	sub    $0x30,%rsp
  80042083e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80042083e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80042083eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042083ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042083f3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80042083f7:	0f b6 00             	movzbl (%rax),%eax
  80042083fa:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80042083fd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8004208401:	75 06                	jne    8004208409 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8004208403:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208407:	eb 6b                	jmp    8004208474 <strstr+0x99>

	len = strlen(str);
  8004208409:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420840d:	48 89 c7             	mov    %rax,%rdi
  8004208410:	48 b8 b1 7c 20 04 80 	movabs $0x8004207cb1,%rax
  8004208417:	00 00 00 
  800420841a:	ff d0                	callq  *%rax
  800420841c:	48 98                	cltq   
  800420841e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8004208422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208426:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420842a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420842e:	0f b6 00             	movzbl (%rax),%eax
  8004208431:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8004208434:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8004208438:	75 07                	jne    8004208441 <strstr+0x66>
				return (char *) 0;
  800420843a:	b8 00 00 00 00       	mov    $0x0,%eax
  800420843f:	eb 33                	jmp    8004208474 <strstr+0x99>
		} while (sc != c);
  8004208441:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8004208445:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8004208448:	75 d8                	jne    8004208422 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  800420844a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420844e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8004208452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208456:	48 89 ce             	mov    %rcx,%rsi
  8004208459:	48 89 c7             	mov    %rax,%rdi
  800420845c:	48 b8 d2 7e 20 04 80 	movabs $0x8004207ed2,%rax
  8004208463:	00 00 00 
  8004208466:	ff d0                	callq  *%rax
  8004208468:	85 c0                	test   %eax,%eax
  800420846a:	75 b6                	jne    8004208422 <strstr+0x47>

	return (char *) (in - 1);
  800420846c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208470:	48 83 e8 01          	sub    $0x1,%rax
}
  8004208474:	c9                   	leaveq 
  8004208475:	c3                   	retq   

0000008004208476 <_dwarf_read_lsb>:
Dwarf_Section *
_dwarf_find_section(const char *name);

uint64_t
_dwarf_read_lsb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  8004208476:	55                   	push   %rbp
  8004208477:	48 89 e5             	mov    %rsp,%rbp
  800420847a:	48 83 ec 24          	sub    $0x24,%rsp
  800420847e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208482:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004208486:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  8004208489:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420848d:	48 8b 10             	mov    (%rax),%rdx
  8004208490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208494:	48 01 d0             	add    %rdx,%rax
  8004208497:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  800420849b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042084a2:	00 
	switch (bytes_to_read) {
  80042084a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042084a6:	83 f8 02             	cmp    $0x2,%eax
  80042084a9:	0f 84 ab 00 00 00    	je     800420855a <_dwarf_read_lsb+0xe4>
  80042084af:	83 f8 02             	cmp    $0x2,%eax
  80042084b2:	7f 0e                	jg     80042084c2 <_dwarf_read_lsb+0x4c>
  80042084b4:	83 f8 01             	cmp    $0x1,%eax
  80042084b7:	0f 84 b3 00 00 00    	je     8004208570 <_dwarf_read_lsb+0xfa>
  80042084bd:	e9 d9 00 00 00       	jmpq   800420859b <_dwarf_read_lsb+0x125>
  80042084c2:	83 f8 04             	cmp    $0x4,%eax
  80042084c5:	74 65                	je     800420852c <_dwarf_read_lsb+0xb6>
  80042084c7:	83 f8 08             	cmp    $0x8,%eax
  80042084ca:	0f 85 cb 00 00 00    	jne    800420859b <_dwarf_read_lsb+0x125>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  80042084d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042084d4:	48 83 c0 04          	add    $0x4,%rax
  80042084d8:	0f b6 00             	movzbl (%rax),%eax
  80042084db:	0f b6 c0             	movzbl %al,%eax
  80042084de:	48 c1 e0 20          	shl    $0x20,%rax
  80042084e2:	48 89 c2             	mov    %rax,%rdx
  80042084e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042084e9:	48 83 c0 05          	add    $0x5,%rax
  80042084ed:	0f b6 00             	movzbl (%rax),%eax
  80042084f0:	0f b6 c0             	movzbl %al,%eax
  80042084f3:	48 c1 e0 28          	shl    $0x28,%rax
  80042084f7:	48 09 d0             	or     %rdx,%rax
  80042084fa:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  80042084fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208502:	48 83 c0 06          	add    $0x6,%rax
  8004208506:	0f b6 00             	movzbl (%rax),%eax
  8004208509:	0f b6 c0             	movzbl %al,%eax
  800420850c:	48 c1 e0 30          	shl    $0x30,%rax
  8004208510:	48 89 c2             	mov    %rax,%rdx
  8004208513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208517:	48 83 c0 07          	add    $0x7,%rax
  800420851b:	0f b6 00             	movzbl (%rax),%eax
  800420851e:	0f b6 c0             	movzbl %al,%eax
  8004208521:	48 c1 e0 38          	shl    $0x38,%rax
  8004208525:	48 09 d0             	or     %rdx,%rax
  8004208528:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  800420852c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208530:	48 83 c0 02          	add    $0x2,%rax
  8004208534:	0f b6 00             	movzbl (%rax),%eax
  8004208537:	0f b6 c0             	movzbl %al,%eax
  800420853a:	48 c1 e0 10          	shl    $0x10,%rax
  800420853e:	48 89 c2             	mov    %rax,%rdx
  8004208541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208545:	48 83 c0 03          	add    $0x3,%rax
  8004208549:	0f b6 00             	movzbl (%rax),%eax
  800420854c:	0f b6 c0             	movzbl %al,%eax
  800420854f:	48 c1 e0 18          	shl    $0x18,%rax
  8004208553:	48 09 d0             	or     %rdx,%rax
  8004208556:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  800420855a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420855e:	48 83 c0 01          	add    $0x1,%rax
  8004208562:	0f b6 00             	movzbl (%rax),%eax
  8004208565:	0f b6 c0             	movzbl %al,%eax
  8004208568:	48 c1 e0 08          	shl    $0x8,%rax
  800420856c:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  8004208570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208574:	0f b6 00             	movzbl (%rax),%eax
  8004208577:	0f b6 c0             	movzbl %al,%eax
  800420857a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420857e:	90                   	nop
	default:
		return (0);
	}

	*offsetp += bytes_to_read;
  800420857f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208583:	48 8b 10             	mov    (%rax),%rdx
  8004208586:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004208589:	48 98                	cltq   
  800420858b:	48 01 c2             	add    %rax,%rdx
  800420858e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208592:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208599:	eb 05                	jmp    80042085a0 <_dwarf_read_lsb+0x12a>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  800420859b:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*offsetp += bytes_to_read;

	return (ret);
}
  80042085a0:	c9                   	leaveq 
  80042085a1:	c3                   	retq   

00000080042085a2 <_dwarf_decode_lsb>:

uint64_t
_dwarf_decode_lsb(uint8_t **data, int bytes_to_read)
{
  80042085a2:	55                   	push   %rbp
  80042085a3:	48 89 e5             	mov    %rsp,%rbp
  80042085a6:	48 83 ec 1c          	sub    $0x1c,%rsp
  80042085aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042085ae:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  80042085b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042085b5:	48 8b 00             	mov    (%rax),%rax
  80042085b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  80042085bc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80042085c3:	00 
	switch (bytes_to_read) {
  80042085c4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042085c7:	83 f8 02             	cmp    $0x2,%eax
  80042085ca:	0f 84 ab 00 00 00    	je     800420867b <_dwarf_decode_lsb+0xd9>
  80042085d0:	83 f8 02             	cmp    $0x2,%eax
  80042085d3:	7f 0e                	jg     80042085e3 <_dwarf_decode_lsb+0x41>
  80042085d5:	83 f8 01             	cmp    $0x1,%eax
  80042085d8:	0f 84 b3 00 00 00    	je     8004208691 <_dwarf_decode_lsb+0xef>
  80042085de:	e9 d9 00 00 00       	jmpq   80042086bc <_dwarf_decode_lsb+0x11a>
  80042085e3:	83 f8 04             	cmp    $0x4,%eax
  80042085e6:	74 65                	je     800420864d <_dwarf_decode_lsb+0xab>
  80042085e8:	83 f8 08             	cmp    $0x8,%eax
  80042085eb:	0f 85 cb 00 00 00    	jne    80042086bc <_dwarf_decode_lsb+0x11a>
	case 8:
		ret |= ((uint64_t) src[4]) << 32 | ((uint64_t) src[5]) << 40;
  80042085f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042085f5:	48 83 c0 04          	add    $0x4,%rax
  80042085f9:	0f b6 00             	movzbl (%rax),%eax
  80042085fc:	0f b6 c0             	movzbl %al,%eax
  80042085ff:	48 c1 e0 20          	shl    $0x20,%rax
  8004208603:	48 89 c2             	mov    %rax,%rdx
  8004208606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420860a:	48 83 c0 05          	add    $0x5,%rax
  800420860e:	0f b6 00             	movzbl (%rax),%eax
  8004208611:	0f b6 c0             	movzbl %al,%eax
  8004208614:	48 c1 e0 28          	shl    $0x28,%rax
  8004208618:	48 09 d0             	or     %rdx,%rax
  800420861b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[6]) << 48 | ((uint64_t) src[7]) << 56;
  800420861f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208623:	48 83 c0 06          	add    $0x6,%rax
  8004208627:	0f b6 00             	movzbl (%rax),%eax
  800420862a:	0f b6 c0             	movzbl %al,%eax
  800420862d:	48 c1 e0 30          	shl    $0x30,%rax
  8004208631:	48 89 c2             	mov    %rax,%rdx
  8004208634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208638:	48 83 c0 07          	add    $0x7,%rax
  800420863c:	0f b6 00             	movzbl (%rax),%eax
  800420863f:	0f b6 c0             	movzbl %al,%eax
  8004208642:	48 c1 e0 38          	shl    $0x38,%rax
  8004208646:	48 09 d0             	or     %rdx,%rax
  8004208649:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 4:
		ret |= ((uint64_t) src[2]) << 16 | ((uint64_t) src[3]) << 24;
  800420864d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208651:	48 83 c0 02          	add    $0x2,%rax
  8004208655:	0f b6 00             	movzbl (%rax),%eax
  8004208658:	0f b6 c0             	movzbl %al,%eax
  800420865b:	48 c1 e0 10          	shl    $0x10,%rax
  800420865f:	48 89 c2             	mov    %rax,%rdx
  8004208662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208666:	48 83 c0 03          	add    $0x3,%rax
  800420866a:	0f b6 00             	movzbl (%rax),%eax
  800420866d:	0f b6 c0             	movzbl %al,%eax
  8004208670:	48 c1 e0 18          	shl    $0x18,%rax
  8004208674:	48 09 d0             	or     %rdx,%rax
  8004208677:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 2:
		ret |= ((uint64_t) src[1]) << 8;
  800420867b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420867f:	48 83 c0 01          	add    $0x1,%rax
  8004208683:	0f b6 00             	movzbl (%rax),%eax
  8004208686:	0f b6 c0             	movzbl %al,%eax
  8004208689:	48 c1 e0 08          	shl    $0x8,%rax
  800420868d:	48 09 45 f8          	or     %rax,-0x8(%rbp)
	case 1:
		ret |= src[0];
  8004208691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208695:	0f b6 00             	movzbl (%rax),%eax
  8004208698:	0f b6 c0             	movzbl %al,%eax
  800420869b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420869f:	90                   	nop
	default:
		return (0);
	}

	*data += bytes_to_read;
  80042086a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086a4:	48 8b 10             	mov    (%rax),%rdx
  80042086a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80042086aa:	48 98                	cltq   
  80042086ac:	48 01 c2             	add    %rax,%rdx
  80042086af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086b3:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  80042086b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042086ba:	eb 05                	jmp    80042086c1 <_dwarf_decode_lsb+0x11f>
		ret |= ((uint64_t) src[1]) << 8;
	case 1:
		ret |= src[0];
		break;
	default:
		return (0);
  80042086bc:	b8 00 00 00 00       	mov    $0x0,%eax
	}

	*data += bytes_to_read;

	return (ret);
}
  80042086c1:	c9                   	leaveq 
  80042086c2:	c3                   	retq   

00000080042086c3 <_dwarf_read_msb>:

uint64_t
_dwarf_read_msb(uint8_t *data, uint64_t *offsetp, int bytes_to_read)
{
  80042086c3:	55                   	push   %rbp
  80042086c4:	48 89 e5             	mov    %rsp,%rbp
  80042086c7:	48 83 ec 24          	sub    $0x24,%rsp
  80042086cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042086cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80042086d3:	89 55 dc             	mov    %edx,-0x24(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = data + *offsetp;
  80042086d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80042086da:	48 8b 10             	mov    (%rax),%rdx
  80042086dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042086e1:	48 01 d0             	add    %rdx,%rax
  80042086e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	switch (bytes_to_read) {
  80042086e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80042086eb:	83 f8 02             	cmp    $0x2,%eax
  80042086ee:	74 35                	je     8004208725 <_dwarf_read_msb+0x62>
  80042086f0:	83 f8 02             	cmp    $0x2,%eax
  80042086f3:	7f 0a                	jg     80042086ff <_dwarf_read_msb+0x3c>
  80042086f5:	83 f8 01             	cmp    $0x1,%eax
  80042086f8:	74 18                	je     8004208712 <_dwarf_read_msb+0x4f>
  80042086fa:	e9 53 01 00 00       	jmpq   8004208852 <_dwarf_read_msb+0x18f>
  80042086ff:	83 f8 04             	cmp    $0x4,%eax
  8004208702:	74 49                	je     800420874d <_dwarf_read_msb+0x8a>
  8004208704:	83 f8 08             	cmp    $0x8,%eax
  8004208707:	0f 84 96 00 00 00    	je     80042087a3 <_dwarf_read_msb+0xe0>
  800420870d:	e9 40 01 00 00       	jmpq   8004208852 <_dwarf_read_msb+0x18f>
	case 1:
		ret = src[0];
  8004208712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208716:	0f b6 00             	movzbl (%rax),%eax
  8004208719:	0f b6 c0             	movzbl %al,%eax
  800420871c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004208720:	e9 34 01 00 00       	jmpq   8004208859 <_dwarf_read_msb+0x196>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  8004208725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208729:	48 83 c0 01          	add    $0x1,%rax
  800420872d:	0f b6 00             	movzbl (%rax),%eax
  8004208730:	0f b6 d0             	movzbl %al,%edx
  8004208733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208737:	0f b6 00             	movzbl (%rax),%eax
  800420873a:	0f b6 c0             	movzbl %al,%eax
  800420873d:	48 c1 e0 08          	shl    $0x8,%rax
  8004208741:	48 09 d0             	or     %rdx,%rax
  8004208744:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  8004208748:	e9 0c 01 00 00       	jmpq   8004208859 <_dwarf_read_msb+0x196>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  800420874d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208751:	48 83 c0 03          	add    $0x3,%rax
  8004208755:	0f b6 00             	movzbl (%rax),%eax
  8004208758:	0f b6 c0             	movzbl %al,%eax
  800420875b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420875f:	48 83 c2 02          	add    $0x2,%rdx
  8004208763:	0f b6 12             	movzbl (%rdx),%edx
  8004208766:	0f b6 d2             	movzbl %dl,%edx
  8004208769:	48 c1 e2 08          	shl    $0x8,%rdx
  800420876d:	48 09 d0             	or     %rdx,%rax
  8004208770:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  8004208774:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208778:	48 83 c0 01          	add    $0x1,%rax
  800420877c:	0f b6 00             	movzbl (%rax),%eax
  800420877f:	0f b6 c0             	movzbl %al,%eax
  8004208782:	48 c1 e0 10          	shl    $0x10,%rax
  8004208786:	48 89 c2             	mov    %rax,%rdx
  8004208789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420878d:	0f b6 00             	movzbl (%rax),%eax
  8004208790:	0f b6 c0             	movzbl %al,%eax
  8004208793:	48 c1 e0 18          	shl    $0x18,%rax
  8004208797:	48 09 d0             	or     %rdx,%rax
  800420879a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420879e:	e9 b6 00 00 00       	jmpq   8004208859 <_dwarf_read_msb+0x196>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  80042087a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087a7:	48 83 c0 07          	add    $0x7,%rax
  80042087ab:	0f b6 00             	movzbl (%rax),%eax
  80042087ae:	0f b6 c0             	movzbl %al,%eax
  80042087b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042087b5:	48 83 c2 06          	add    $0x6,%rdx
  80042087b9:	0f b6 12             	movzbl (%rdx),%edx
  80042087bc:	0f b6 d2             	movzbl %dl,%edx
  80042087bf:	48 c1 e2 08          	shl    $0x8,%rdx
  80042087c3:	48 09 d0             	or     %rdx,%rax
  80042087c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  80042087ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087ce:	48 83 c0 05          	add    $0x5,%rax
  80042087d2:	0f b6 00             	movzbl (%rax),%eax
  80042087d5:	0f b6 c0             	movzbl %al,%eax
  80042087d8:	48 c1 e0 10          	shl    $0x10,%rax
  80042087dc:	48 89 c2             	mov    %rax,%rdx
  80042087df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087e3:	48 83 c0 04          	add    $0x4,%rax
  80042087e7:	0f b6 00             	movzbl (%rax),%eax
  80042087ea:	0f b6 c0             	movzbl %al,%eax
  80042087ed:	48 c1 e0 18          	shl    $0x18,%rax
  80042087f1:	48 09 d0             	or     %rdx,%rax
  80042087f4:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  80042087f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042087fc:	48 83 c0 03          	add    $0x3,%rax
  8004208800:	0f b6 00             	movzbl (%rax),%eax
  8004208803:	0f b6 c0             	movzbl %al,%eax
  8004208806:	48 c1 e0 20          	shl    $0x20,%rax
  800420880a:	48 89 c2             	mov    %rax,%rdx
  800420880d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208811:	48 83 c0 02          	add    $0x2,%rax
  8004208815:	0f b6 00             	movzbl (%rax),%eax
  8004208818:	0f b6 c0             	movzbl %al,%eax
  800420881b:	48 c1 e0 28          	shl    $0x28,%rax
  800420881f:	48 09 d0             	or     %rdx,%rax
  8004208822:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  8004208826:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420882a:	48 83 c0 01          	add    $0x1,%rax
  800420882e:	0f b6 00             	movzbl (%rax),%eax
  8004208831:	0f b6 c0             	movzbl %al,%eax
  8004208834:	48 c1 e0 30          	shl    $0x30,%rax
  8004208838:	48 89 c2             	mov    %rax,%rdx
  800420883b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420883f:	0f b6 00             	movzbl (%rax),%eax
  8004208842:	0f b6 c0             	movzbl %al,%eax
  8004208845:	48 c1 e0 38          	shl    $0x38,%rax
  8004208849:	48 09 d0             	or     %rdx,%rax
  800420884c:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  8004208850:	eb 07                	jmp    8004208859 <_dwarf_read_msb+0x196>
	default:
		return (0);
  8004208852:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208857:	eb 1a                	jmp    8004208873 <_dwarf_read_msb+0x1b0>
	}

	*offsetp += bytes_to_read;
  8004208859:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420885d:	48 8b 10             	mov    (%rax),%rdx
  8004208860:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004208863:	48 98                	cltq   
  8004208865:	48 01 c2             	add    %rax,%rdx
  8004208868:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420886c:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  800420886f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208873:	c9                   	leaveq 
  8004208874:	c3                   	retq   

0000008004208875 <_dwarf_decode_msb>:

uint64_t
_dwarf_decode_msb(uint8_t **data, int bytes_to_read)
{
  8004208875:	55                   	push   %rbp
  8004208876:	48 89 e5             	mov    %rsp,%rbp
  8004208879:	48 83 ec 1c          	sub    $0x1c,%rsp
  800420887d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208881:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	uint64_t ret;
	uint8_t *src;

	src = *data;
  8004208884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208888:	48 8b 00             	mov    (%rax),%rax
  800420888b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	ret = 0;
  800420888f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208896:	00 
	switch (bytes_to_read) {
  8004208897:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420889a:	83 f8 02             	cmp    $0x2,%eax
  800420889d:	74 35                	je     80042088d4 <_dwarf_decode_msb+0x5f>
  800420889f:	83 f8 02             	cmp    $0x2,%eax
  80042088a2:	7f 0a                	jg     80042088ae <_dwarf_decode_msb+0x39>
  80042088a4:	83 f8 01             	cmp    $0x1,%eax
  80042088a7:	74 18                	je     80042088c1 <_dwarf_decode_msb+0x4c>
  80042088a9:	e9 53 01 00 00       	jmpq   8004208a01 <_dwarf_decode_msb+0x18c>
  80042088ae:	83 f8 04             	cmp    $0x4,%eax
  80042088b1:	74 49                	je     80042088fc <_dwarf_decode_msb+0x87>
  80042088b3:	83 f8 08             	cmp    $0x8,%eax
  80042088b6:	0f 84 96 00 00 00    	je     8004208952 <_dwarf_decode_msb+0xdd>
  80042088bc:	e9 40 01 00 00       	jmpq   8004208a01 <_dwarf_decode_msb+0x18c>
	case 1:
		ret = src[0];
  80042088c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088c5:	0f b6 00             	movzbl (%rax),%eax
  80042088c8:	0f b6 c0             	movzbl %al,%eax
  80042088cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  80042088cf:	e9 34 01 00 00       	jmpq   8004208a08 <_dwarf_decode_msb+0x193>
	case 2:
		ret = src[1] | ((uint64_t) src[0]) << 8;
  80042088d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088d8:	48 83 c0 01          	add    $0x1,%rax
  80042088dc:	0f b6 00             	movzbl (%rax),%eax
  80042088df:	0f b6 d0             	movzbl %al,%edx
  80042088e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042088e6:	0f b6 00             	movzbl (%rax),%eax
  80042088e9:	0f b6 c0             	movzbl %al,%eax
  80042088ec:	48 c1 e0 08          	shl    $0x8,%rax
  80042088f0:	48 09 d0             	or     %rdx,%rax
  80042088f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		break;
  80042088f7:	e9 0c 01 00 00       	jmpq   8004208a08 <_dwarf_decode_msb+0x193>
	case 4:
		ret = src[3] | ((uint64_t) src[2]) << 8;
  80042088fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208900:	48 83 c0 03          	add    $0x3,%rax
  8004208904:	0f b6 00             	movzbl (%rax),%eax
  8004208907:	0f b6 c0             	movzbl %al,%eax
  800420890a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420890e:	48 83 c2 02          	add    $0x2,%rdx
  8004208912:	0f b6 12             	movzbl (%rdx),%edx
  8004208915:	0f b6 d2             	movzbl %dl,%edx
  8004208918:	48 c1 e2 08          	shl    $0x8,%rdx
  800420891c:	48 09 d0             	or     %rdx,%rax
  800420891f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 16 | ((uint64_t) src[0]) << 24;
  8004208923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208927:	48 83 c0 01          	add    $0x1,%rax
  800420892b:	0f b6 00             	movzbl (%rax),%eax
  800420892e:	0f b6 c0             	movzbl %al,%eax
  8004208931:	48 c1 e0 10          	shl    $0x10,%rax
  8004208935:	48 89 c2             	mov    %rax,%rdx
  8004208938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420893c:	0f b6 00             	movzbl (%rax),%eax
  800420893f:	0f b6 c0             	movzbl %al,%eax
  8004208942:	48 c1 e0 18          	shl    $0x18,%rax
  8004208946:	48 09 d0             	or     %rdx,%rax
  8004208949:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  800420894d:	e9 b6 00 00 00       	jmpq   8004208a08 <_dwarf_decode_msb+0x193>
	case 8:
		ret = src[7] | ((uint64_t) src[6]) << 8;
  8004208952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208956:	48 83 c0 07          	add    $0x7,%rax
  800420895a:	0f b6 00             	movzbl (%rax),%eax
  800420895d:	0f b6 c0             	movzbl %al,%eax
  8004208960:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004208964:	48 83 c2 06          	add    $0x6,%rdx
  8004208968:	0f b6 12             	movzbl (%rdx),%edx
  800420896b:	0f b6 d2             	movzbl %dl,%edx
  800420896e:	48 c1 e2 08          	shl    $0x8,%rdx
  8004208972:	48 09 d0             	or     %rdx,%rax
  8004208975:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[5]) << 16 | ((uint64_t) src[4]) << 24;
  8004208979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420897d:	48 83 c0 05          	add    $0x5,%rax
  8004208981:	0f b6 00             	movzbl (%rax),%eax
  8004208984:	0f b6 c0             	movzbl %al,%eax
  8004208987:	48 c1 e0 10          	shl    $0x10,%rax
  800420898b:	48 89 c2             	mov    %rax,%rdx
  800420898e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208992:	48 83 c0 04          	add    $0x4,%rax
  8004208996:	0f b6 00             	movzbl (%rax),%eax
  8004208999:	0f b6 c0             	movzbl %al,%eax
  800420899c:	48 c1 e0 18          	shl    $0x18,%rax
  80042089a0:	48 09 d0             	or     %rdx,%rax
  80042089a3:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[3]) << 32 | ((uint64_t) src[2]) << 40;
  80042089a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089ab:	48 83 c0 03          	add    $0x3,%rax
  80042089af:	0f b6 00             	movzbl (%rax),%eax
  80042089b2:	0f b6 c0             	movzbl %al,%eax
  80042089b5:	48 c1 e0 20          	shl    $0x20,%rax
  80042089b9:	48 89 c2             	mov    %rax,%rdx
  80042089bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089c0:	48 83 c0 02          	add    $0x2,%rax
  80042089c4:	0f b6 00             	movzbl (%rax),%eax
  80042089c7:	0f b6 c0             	movzbl %al,%eax
  80042089ca:	48 c1 e0 28          	shl    $0x28,%rax
  80042089ce:	48 09 d0             	or     %rdx,%rax
  80042089d1:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		ret |= ((uint64_t) src[1]) << 48 | ((uint64_t) src[0]) << 56;
  80042089d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089d9:	48 83 c0 01          	add    $0x1,%rax
  80042089dd:	0f b6 00             	movzbl (%rax),%eax
  80042089e0:	0f b6 c0             	movzbl %al,%eax
  80042089e3:	48 c1 e0 30          	shl    $0x30,%rax
  80042089e7:	48 89 c2             	mov    %rax,%rdx
  80042089ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042089ee:	0f b6 00             	movzbl (%rax),%eax
  80042089f1:	0f b6 c0             	movzbl %al,%eax
  80042089f4:	48 c1 e0 38          	shl    $0x38,%rax
  80042089f8:	48 09 d0             	or     %rdx,%rax
  80042089fb:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		break;
  80042089ff:	eb 07                	jmp    8004208a08 <_dwarf_decode_msb+0x193>
	default:
		return (0);
  8004208a01:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208a06:	eb 1a                	jmp    8004208a22 <_dwarf_decode_msb+0x1ad>
		break;
	}

	*data += bytes_to_read;
  8004208a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208a0c:	48 8b 10             	mov    (%rax),%rdx
  8004208a0f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004208a12:	48 98                	cltq   
  8004208a14:	48 01 c2             	add    %rax,%rdx
  8004208a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208a1b:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208a1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208a22:	c9                   	leaveq 
  8004208a23:	c3                   	retq   

0000008004208a24 <_dwarf_read_sleb128>:

int64_t
_dwarf_read_sleb128(uint8_t *data, uint64_t *offsetp)
{
  8004208a24:	55                   	push   %rbp
  8004208a25:	48 89 e5             	mov    %rsp,%rbp
  8004208a28:	48 83 ec 30          	sub    $0x30,%rsp
  8004208a2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004208a30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int64_t ret = 0;
  8004208a34:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208a3b:	00 
	uint8_t b;
	int shift = 0;
  8004208a3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  8004208a43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a47:	48 8b 10             	mov    (%rax),%rdx
  8004208a4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208a4e:	48 01 d0             	add    %rdx,%rax
  8004208a51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004208a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208a59:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208a5d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004208a61:	0f b6 00             	movzbl (%rax),%eax
  8004208a64:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004208a67:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208a6b:	83 e0 7f             	and    $0x7f,%eax
  8004208a6e:	89 c2                	mov    %eax,%edx
  8004208a70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208a73:	89 c1                	mov    %eax,%ecx
  8004208a75:	d3 e2                	shl    %cl,%edx
  8004208a77:	89 d0                	mov    %edx,%eax
  8004208a79:	48 98                	cltq   
  8004208a7b:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004208a7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a83:	48 8b 00             	mov    (%rax),%rax
  8004208a86:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208a8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208a8e:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004208a91:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004208a95:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208a99:	84 c0                	test   %al,%al
  8004208a9b:	78 b8                	js     8004208a55 <_dwarf_read_sleb128+0x31>

	if (shift < 32 && (b & 0x40) != 0)
  8004208a9d:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004208aa1:	7f 1f                	jg     8004208ac2 <_dwarf_read_sleb128+0x9e>
  8004208aa3:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208aa7:	83 e0 40             	and    $0x40,%eax
  8004208aaa:	85 c0                	test   %eax,%eax
  8004208aac:	74 14                	je     8004208ac2 <_dwarf_read_sleb128+0x9e>
		ret |= (-1 << shift);
  8004208aae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208ab1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004208ab6:	89 c1                	mov    %eax,%ecx
  8004208ab8:	d3 e2                	shl    %cl,%edx
  8004208aba:	89 d0                	mov    %edx,%eax
  8004208abc:	48 98                	cltq   
  8004208abe:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	return (ret);
  8004208ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208ac6:	c9                   	leaveq 
  8004208ac7:	c3                   	retq   

0000008004208ac8 <_dwarf_read_uleb128>:

uint64_t
_dwarf_read_uleb128(uint8_t *data, uint64_t *offsetp)
{
  8004208ac8:	55                   	push   %rbp
  8004208ac9:	48 89 e5             	mov    %rsp,%rbp
  8004208acc:	48 83 ec 30          	sub    $0x30,%rsp
  8004208ad0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004208ad4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	uint64_t ret = 0;
  8004208ad8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208adf:	00 
	uint8_t b;
	int shift = 0;
  8004208ae0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	uint8_t *src;

	src = data + *offsetp;
  8004208ae7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208aeb:	48 8b 10             	mov    (%rax),%rdx
  8004208aee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208af2:	48 01 d0             	add    %rdx,%rax
  8004208af5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004208af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208afd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208b01:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004208b05:	0f b6 00             	movzbl (%rax),%eax
  8004208b08:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004208b0b:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208b0f:	83 e0 7f             	and    $0x7f,%eax
  8004208b12:	89 c2                	mov    %eax,%edx
  8004208b14:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208b17:	89 c1                	mov    %eax,%ecx
  8004208b19:	d3 e2                	shl    %cl,%edx
  8004208b1b:	89 d0                	mov    %edx,%eax
  8004208b1d:	48 98                	cltq   
  8004208b1f:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		(*offsetp)++;
  8004208b23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208b27:	48 8b 00             	mov    (%rax),%rax
  8004208b2a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208b2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004208b32:	48 89 10             	mov    %rdx,(%rax)
		shift += 7;
  8004208b35:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004208b39:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208b3d:	84 c0                	test   %al,%al
  8004208b3f:	78 b8                	js     8004208af9 <_dwarf_read_uleb128+0x31>

	return (ret);
  8004208b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208b45:	c9                   	leaveq 
  8004208b46:	c3                   	retq   

0000008004208b47 <_dwarf_decode_sleb128>:

int64_t
_dwarf_decode_sleb128(uint8_t **dp)
{
  8004208b47:	55                   	push   %rbp
  8004208b48:	48 89 e5             	mov    %rsp,%rbp
  8004208b4b:	48 83 ec 28          	sub    $0x28,%rsp
  8004208b4f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int64_t ret = 0;
  8004208b53:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208b5a:	00 
	uint8_t b;
	int shift = 0;
  8004208b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004208b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208b66:	48 8b 00             	mov    (%rax),%rax
  8004208b69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004208b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208b71:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208b75:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004208b79:	0f b6 00             	movzbl (%rax),%eax
  8004208b7c:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004208b7f:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208b83:	83 e0 7f             	and    $0x7f,%eax
  8004208b86:	89 c2                	mov    %eax,%edx
  8004208b88:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208b8b:	89 c1                	mov    %eax,%ecx
  8004208b8d:	d3 e2                	shl    %cl,%edx
  8004208b8f:	89 d0                	mov    %edx,%eax
  8004208b91:	48 98                	cltq   
  8004208b93:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004208b97:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004208b9b:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208b9f:	84 c0                	test   %al,%al
  8004208ba1:	78 ca                	js     8004208b6d <_dwarf_decode_sleb128+0x26>

	if (shift < 32 && (b & 0x40) != 0)
  8004208ba3:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8004208ba7:	7f 1f                	jg     8004208bc8 <_dwarf_decode_sleb128+0x81>
  8004208ba9:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208bad:	83 e0 40             	and    $0x40,%eax
  8004208bb0:	85 c0                	test   %eax,%eax
  8004208bb2:	74 14                	je     8004208bc8 <_dwarf_decode_sleb128+0x81>
		ret |= (-1 << shift);
  8004208bb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208bb7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8004208bbc:	89 c1                	mov    %eax,%ecx
  8004208bbe:	d3 e2                	shl    %cl,%edx
  8004208bc0:	89 d0                	mov    %edx,%eax
  8004208bc2:	48 98                	cltq   
  8004208bc4:	48 09 45 f8          	or     %rax,-0x8(%rbp)

	*dp = src;
  8004208bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208bcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208bd0:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208bd7:	c9                   	leaveq 
  8004208bd8:	c3                   	retq   

0000008004208bd9 <_dwarf_decode_uleb128>:

uint64_t
_dwarf_decode_uleb128(uint8_t **dp)
{
  8004208bd9:	55                   	push   %rbp
  8004208bda:	48 89 e5             	mov    %rsp,%rbp
  8004208bdd:	48 83 ec 28          	sub    $0x28,%rsp
  8004208be1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t ret = 0;
  8004208be5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004208bec:	00 
	uint8_t b;
	int shift = 0;
  8004208bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)

	uint8_t *src = *dp;
  8004208bf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208bf8:	48 8b 00             	mov    (%rax),%rax
  8004208bfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	do {
		b = *src++;
  8004208bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208c03:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208c07:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004208c0b:	0f b6 00             	movzbl (%rax),%eax
  8004208c0e:	88 45 e7             	mov    %al,-0x19(%rbp)
		ret |= ((b & 0x7f) << shift);
  8004208c11:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208c15:	83 e0 7f             	and    $0x7f,%eax
  8004208c18:	89 c2                	mov    %eax,%edx
  8004208c1a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004208c1d:	89 c1                	mov    %eax,%ecx
  8004208c1f:	d3 e2                	shl    %cl,%edx
  8004208c21:	89 d0                	mov    %edx,%eax
  8004208c23:	48 98                	cltq   
  8004208c25:	48 09 45 f8          	or     %rax,-0x8(%rbp)
		shift += 7;
  8004208c29:	83 45 f4 07          	addl   $0x7,-0xc(%rbp)
	} while ((b & 0x80) != 0);
  8004208c2d:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8004208c31:	84 c0                	test   %al,%al
  8004208c33:	78 ca                	js     8004208bff <_dwarf_decode_uleb128+0x26>

	*dp = src;
  8004208c35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208c3d:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004208c44:	c9                   	leaveq 
  8004208c45:	c3                   	retq   

0000008004208c46 <_dwarf_read_string>:

#define Dwarf_Unsigned uint64_t

char *
_dwarf_read_string(void *data, Dwarf_Unsigned size, uint64_t *offsetp)
{
  8004208c46:	55                   	push   %rbp
  8004208c47:	48 89 e5             	mov    %rsp,%rbp
  8004208c4a:	48 83 ec 28          	sub    $0x28,%rsp
  8004208c4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208c52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004208c56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *ret, *src;

	ret = src = (char *) data + *offsetp;
  8004208c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c5e:	48 8b 10             	mov    (%rax),%rdx
  8004208c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208c65:	48 01 d0             	add    %rdx,%rax
  8004208c68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208c70:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (*src != '\0' && *offsetp < size) {
  8004208c74:	eb 17                	jmp    8004208c8d <_dwarf_read_string+0x47>
		src++;
  8004208c76:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
		(*offsetp)++;
  8004208c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c7f:	48 8b 00             	mov    (%rax),%rax
  8004208c82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208c86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c8a:	48 89 10             	mov    %rdx,(%rax)
{
	char *ret, *src;

	ret = src = (char *) data + *offsetp;

	while (*src != '\0' && *offsetp < size) {
  8004208c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208c91:	0f b6 00             	movzbl (%rax),%eax
  8004208c94:	84 c0                	test   %al,%al
  8004208c96:	74 0d                	je     8004208ca5 <_dwarf_read_string+0x5f>
  8004208c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208c9c:	48 8b 00             	mov    (%rax),%rax
  8004208c9f:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004208ca3:	72 d1                	jb     8004208c76 <_dwarf_read_string+0x30>
		src++;
		(*offsetp)++;
	}

	if (*src == '\0' && *offsetp < size)
  8004208ca5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208ca9:	0f b6 00             	movzbl (%rax),%eax
  8004208cac:	84 c0                	test   %al,%al
  8004208cae:	75 1f                	jne    8004208ccf <_dwarf_read_string+0x89>
  8004208cb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208cb4:	48 8b 00             	mov    (%rax),%rax
  8004208cb7:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004208cbb:	73 12                	jae    8004208ccf <_dwarf_read_string+0x89>
		(*offsetp)++;
  8004208cbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208cc1:	48 8b 00             	mov    (%rax),%rax
  8004208cc4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004208cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208ccc:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004208cd3:	c9                   	leaveq 
  8004208cd4:	c3                   	retq   

0000008004208cd5 <_dwarf_read_block>:

uint8_t *
_dwarf_read_block(void *data, uint64_t *offsetp, uint64_t length)
{
  8004208cd5:	55                   	push   %rbp
  8004208cd6:	48 89 e5             	mov    %rsp,%rbp
  8004208cd9:	48 83 ec 28          	sub    $0x28,%rsp
  8004208cdd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208ce1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004208ce5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	uint8_t *ret, *src;

	ret = src = (uint8_t *) data + *offsetp;
  8004208ce9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208ced:	48 8b 10             	mov    (%rax),%rdx
  8004208cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208cf4:	48 01 d0             	add    %rdx,%rax
  8004208cf7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004208cfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208cff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	(*offsetp) += length;
  8004208d03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208d07:	48 8b 10             	mov    (%rax),%rdx
  8004208d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004208d0e:	48 01 c2             	add    %rax,%rdx
  8004208d11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208d15:	48 89 10             	mov    %rdx,(%rax)

	return (ret);
  8004208d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8004208d1c:	c9                   	leaveq 
  8004208d1d:	c3                   	retq   

0000008004208d1e <_dwarf_elf_get_byte_order>:

Dwarf_Endianness
_dwarf_elf_get_byte_order(void *obj)
{
  8004208d1e:	55                   	push   %rbp
  8004208d1f:	48 89 e5             	mov    %rsp,%rbp
  8004208d22:	48 83 ec 20          	sub    $0x20,%rsp
  8004208d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *)obj;
  8004208d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208d2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004208d32:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004208d37:	75 35                	jne    8004208d6e <_dwarf_elf_get_byte_order+0x50>
  8004208d39:	48 b9 a0 fa 20 04 80 	movabs $0x800420faa0,%rcx
  8004208d40:	00 00 00 
  8004208d43:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004208d4a:	00 00 00 
  8004208d4d:	be 29 01 00 00       	mov    $0x129,%esi
  8004208d52:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004208d59:	00 00 00 
  8004208d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208d61:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004208d68:	00 00 00 
  8004208d6b:	41 ff d0             	callq  *%r8

//TODO: Need to check for 64bit here. Because currently Elf header for
//      64bit doesn't have any memeber e_ident. But need to see what is
//      similar in 64bit.
	switch (e->e_ident[EI_DATA]) {
  8004208d6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208d72:	0f b6 40 05          	movzbl 0x5(%rax),%eax
  8004208d76:	0f b6 c0             	movzbl %al,%eax
  8004208d79:	83 f8 02             	cmp    $0x2,%eax
  8004208d7c:	75 07                	jne    8004208d85 <_dwarf_elf_get_byte_order+0x67>
	case ELFDATA2MSB:
		return (DW_OBJECT_MSB);
  8004208d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208d83:	eb 05                	jmp    8004208d8a <_dwarf_elf_get_byte_order+0x6c>

	case ELFDATA2LSB:
	case ELFDATANONE:
	default:
		return (DW_OBJECT_LSB);
  8004208d85:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
  8004208d8a:	c9                   	leaveq 
  8004208d8b:	c3                   	retq   

0000008004208d8c <_dwarf_elf_get_pointer_size>:

Dwarf_Small
_dwarf_elf_get_pointer_size(void *obj)
{
  8004208d8c:	55                   	push   %rbp
  8004208d8d:	48 89 e5             	mov    %rsp,%rbp
  8004208d90:	48 83 ec 20          	sub    $0x20,%rsp
  8004208d94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Elf *e;

	e = (Elf *) obj;
  8004208d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208d9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(e != NULL);
  8004208da0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004208da5:	75 35                	jne    8004208ddc <_dwarf_elf_get_pointer_size+0x50>
  8004208da7:	48 b9 a0 fa 20 04 80 	movabs $0x800420faa0,%rcx
  8004208dae:	00 00 00 
  8004208db1:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004208db8:	00 00 00 
  8004208dbb:	be 3f 01 00 00       	mov    $0x13f,%esi
  8004208dc0:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004208dc7:	00 00 00 
  8004208dca:	b8 00 00 00 00       	mov    $0x0,%eax
  8004208dcf:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004208dd6:	00 00 00 
  8004208dd9:	41 ff d0             	callq  *%r8

	if (e->e_ident[4] == ELFCLASS32)
  8004208ddc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004208de0:	0f b6 40 04          	movzbl 0x4(%rax),%eax
  8004208de4:	3c 01                	cmp    $0x1,%al
  8004208de6:	75 07                	jne    8004208def <_dwarf_elf_get_pointer_size+0x63>
		return (4);
  8004208de8:	b8 04 00 00 00       	mov    $0x4,%eax
  8004208ded:	eb 05                	jmp    8004208df4 <_dwarf_elf_get_pointer_size+0x68>
	else
		return (8);
  8004208def:	b8 08 00 00 00       	mov    $0x8,%eax
}
  8004208df4:	c9                   	leaveq 
  8004208df5:	c3                   	retq   

0000008004208df6 <_dwarf_init>:

//Return 0 on success
int _dwarf_init(Dwarf_Debug dbg, void *obj)
{
  8004208df6:	55                   	push   %rbp
  8004208df7:	48 89 e5             	mov    %rsp,%rbp
  8004208dfa:	53                   	push   %rbx
  8004208dfb:	48 83 ec 18          	sub    $0x18,%rsp
  8004208dff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208e03:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	memset(dbg, 0, sizeof(struct _Dwarf_Debug));
  8004208e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e0b:	ba 60 00 00 00       	mov    $0x60,%edx
  8004208e10:	be 00 00 00 00       	mov    $0x0,%esi
  8004208e15:	48 89 c7             	mov    %rax,%rdi
  8004208e18:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  8004208e1f:	00 00 00 
  8004208e22:	ff d0                	callq  *%rax
	dbg->curr_off_dbginfo = 0;
  8004208e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e28:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	dbg->dbg_info_size = 0;
  8004208e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e33:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8004208e3a:	00 
	dbg->dbg_pointer_size = _dwarf_elf_get_pointer_size(obj); 
  8004208e3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208e3f:	48 89 c7             	mov    %rax,%rdi
  8004208e42:	48 b8 8c 8d 20 04 80 	movabs $0x8004208d8c,%rax
  8004208e49:	00 00 00 
  8004208e4c:	ff d0                	callq  *%rax
  8004208e4e:	0f b6 d0             	movzbl %al,%edx
  8004208e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e55:	89 50 28             	mov    %edx,0x28(%rax)

	if (_dwarf_elf_get_byte_order(obj) == DW_OBJECT_MSB) {
  8004208e58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208e5c:	48 89 c7             	mov    %rax,%rdi
  8004208e5f:	48 b8 1e 8d 20 04 80 	movabs $0x8004208d1e,%rax
  8004208e66:	00 00 00 
  8004208e69:	ff d0                	callq  *%rax
  8004208e6b:	85 c0                	test   %eax,%eax
  8004208e6d:	75 26                	jne    8004208e95 <_dwarf_init+0x9f>
		dbg->read = _dwarf_read_msb;
  8004208e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e73:	48 b9 c3 86 20 04 80 	movabs $0x80042086c3,%rcx
  8004208e7a:	00 00 00 
  8004208e7d:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_msb;
  8004208e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e85:	48 bb 75 88 20 04 80 	movabs $0x8004208875,%rbx
  8004208e8c:	00 00 00 
  8004208e8f:	48 89 58 20          	mov    %rbx,0x20(%rax)
  8004208e93:	eb 24                	jmp    8004208eb9 <_dwarf_init+0xc3>
	} else {
		dbg->read = _dwarf_read_lsb;
  8004208e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208e99:	48 b9 76 84 20 04 80 	movabs $0x8004208476,%rcx
  8004208ea0:	00 00 00 
  8004208ea3:	48 89 48 18          	mov    %rcx,0x18(%rax)
		dbg->decode = _dwarf_decode_lsb;
  8004208ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208eab:	48 be a2 85 20 04 80 	movabs $0x80042085a2,%rsi
  8004208eb2:	00 00 00 
  8004208eb5:	48 89 70 20          	mov    %rsi,0x20(%rax)
	}
	_dwarf_frame_params_init(dbg);
  8004208eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208ebd:	48 89 c7             	mov    %rax,%rdi
  8004208ec0:	48 b8 c3 a3 20 04 80 	movabs $0x800420a3c3,%rax
  8004208ec7:	00 00 00 
  8004208eca:	ff d0                	callq  *%rax
	return 0;
  8004208ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004208ed1:	48 83 c4 18          	add    $0x18,%rsp
  8004208ed5:	5b                   	pop    %rbx
  8004208ed6:	5d                   	pop    %rbp
  8004208ed7:	c3                   	retq   

0000008004208ed8 <_get_next_cu>:

//Return 0 on success
int _get_next_cu(Dwarf_Debug dbg, Dwarf_CU *cu)
{
  8004208ed8:	55                   	push   %rbp
  8004208ed9:	48 89 e5             	mov    %rsp,%rbp
  8004208edc:	48 83 ec 20          	sub    $0x20,%rsp
  8004208ee0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004208ee4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uint32_t length;
	uint64_t offset;
	uint8_t dwarf_size;

	if(dbg->curr_off_dbginfo > dbg->dbg_info_size)
  8004208ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208eec:	48 8b 10             	mov    (%rax),%rdx
  8004208eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208ef3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004208ef7:	48 39 c2             	cmp    %rax,%rdx
  8004208efa:	76 0a                	jbe    8004208f06 <_get_next_cu+0x2e>
		return -1;
  8004208efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004208f01:	e9 6b 01 00 00       	jmpq   8004209071 <_get_next_cu+0x199>

	offset = dbg->curr_off_dbginfo;
  8004208f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208f0a:	48 8b 00             	mov    (%rax),%rax
  8004208f0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	cu->cu_offset = offset;
  8004208f11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004208f15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208f19:	48 89 50 30          	mov    %rdx,0x30(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset,4);
  8004208f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208f21:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208f25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208f29:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004208f2d:	48 89 d1             	mov    %rdx,%rcx
  8004208f30:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004208f34:	ba 04 00 00 00       	mov    $0x4,%edx
  8004208f39:	48 89 cf             	mov    %rcx,%rdi
  8004208f3c:	ff d0                	callq  *%rax
  8004208f3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (length == 0xffffffff) {
  8004208f41:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%rbp)
  8004208f45:	75 2a                	jne    8004208f71 <_get_next_cu+0x99>
		length = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 8);
  8004208f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208f4b:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208f4f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208f53:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004208f57:	48 89 d1             	mov    %rdx,%rcx
  8004208f5a:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004208f5e:	ba 08 00 00 00       	mov    $0x8,%edx
  8004208f63:	48 89 cf             	mov    %rcx,%rdi
  8004208f66:	ff d0                	callq  *%rax
  8004208f68:	89 45 fc             	mov    %eax,-0x4(%rbp)
		dwarf_size = 8;
  8004208f6b:	c6 45 fb 08          	movb   $0x8,-0x5(%rbp)
  8004208f6f:	eb 04                	jmp    8004208f75 <_get_next_cu+0x9d>
	} else {
		dwarf_size = 4;
  8004208f71:	c6 45 fb 04          	movb   $0x4,-0x5(%rbp)
	}

	cu->cu_dwarf_size = dwarf_size;
  8004208f75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208f79:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  8004208f7d:	88 50 19             	mov    %dl,0x19(%rax)
	 if (length > ds->ds_size - offset) {
	 return (DW_DLE_CU_LENGTH_ERROR);
	 }*/

	/* Compute the offset to the next compilation unit: */
	dbg->curr_off_dbginfo = offset + length;
  8004208f80:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004208f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004208f87:	48 01 c2             	add    %rax,%rdx
  8004208f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208f8e:	48 89 10             	mov    %rdx,(%rax)
	cu->cu_next_offset   = dbg->curr_off_dbginfo;
  8004208f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208f95:	48 8b 10             	mov    (%rax),%rdx
  8004208f98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208f9c:	48 89 50 20          	mov    %rdx,0x20(%rax)

	/* Initialise the compilation unit. */
	cu->cu_length = (uint64_t)length;
  8004208fa0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004208fa3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208fa7:	48 89 10             	mov    %rdx,(%rax)

	cu->cu_length_size   = (dwarf_size == 4 ? 4 : 12);
  8004208faa:	80 7d fb 04          	cmpb   $0x4,-0x5(%rbp)
  8004208fae:	75 07                	jne    8004208fb7 <_get_next_cu+0xdf>
  8004208fb0:	b8 04 00 00 00       	mov    $0x4,%eax
  8004208fb5:	eb 05                	jmp    8004208fbc <_get_next_cu+0xe4>
  8004208fb7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8004208fbc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8004208fc0:	88 42 18             	mov    %al,0x18(%rdx)
	cu->version              = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 2);
  8004208fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208fc7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208fcb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004208fcf:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004208fd3:	48 89 d1             	mov    %rdx,%rcx
  8004208fd6:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004208fda:	ba 02 00 00 00       	mov    $0x2,%edx
  8004208fdf:	48 89 cf             	mov    %rcx,%rdi
  8004208fe2:	ff d0                	callq  *%rax
  8004208fe4:	89 c2                	mov    %eax,%edx
  8004208fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004208fea:	66 89 50 08          	mov    %dx,0x8(%rax)
	cu->debug_abbrev_offset  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, dwarf_size);
  8004208fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004208ff2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004208ff6:	0f b6 55 fb          	movzbl -0x5(%rbp),%edx
  8004208ffa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004208ffe:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  8004209002:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  8004209006:	48 89 cf             	mov    %rcx,%rdi
  8004209009:	ff d0                	callq  *%rax
  800420900b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420900f:	48 89 42 10          	mov    %rax,0x10(%rdx)
	//cu->cu_abbrev_offset_cur = cu->cu_abbrev_offset;
	cu->addr_size  = dbg->read((uint8_t *)dbg->dbg_info_offset_elf, &offset, 1);
  8004209013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209017:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420901b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420901f:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  8004209023:	48 89 d1             	mov    %rdx,%rcx
  8004209026:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  800420902a:	ba 01 00 00 00       	mov    $0x1,%edx
  800420902f:	48 89 cf             	mov    %rcx,%rdi
  8004209032:	ff d0                	callq  *%rax
  8004209034:	89 c2                	mov    %eax,%edx
  8004209036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420903a:	88 50 0a             	mov    %dl,0xa(%rax)

	if (cu->version < 2 || cu->version > 4) {
  800420903d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004209041:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004209045:	66 83 f8 01          	cmp    $0x1,%ax
  8004209049:	76 0e                	jbe    8004209059 <_get_next_cu+0x181>
  800420904b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420904f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8004209053:	66 83 f8 04          	cmp    $0x4,%ax
  8004209057:	76 07                	jbe    8004209060 <_get_next_cu+0x188>
		return -1;
  8004209059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420905e:	eb 11                	jmp    8004209071 <_get_next_cu+0x199>
	}

	cu->cu_die_offset = offset;
  8004209060:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004209064:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004209068:	48 89 50 28          	mov    %rdx,0x28(%rax)

	return 0;
  800420906c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004209071:	c9                   	leaveq 
  8004209072:	c3                   	retq   

0000008004209073 <print_cu>:

void print_cu(Dwarf_CU cu)
{
  8004209073:	55                   	push   %rbp
  8004209074:	48 89 e5             	mov    %rsp,%rbp
	cprintf("%ld---%du--%d\n",cu.cu_length,cu.version,cu.addr_size);
  8004209077:	0f b6 45 1a          	movzbl 0x1a(%rbp),%eax
  800420907b:	0f b6 c8             	movzbl %al,%ecx
  800420907e:	0f b7 45 18          	movzwl 0x18(%rbp),%eax
  8004209082:	0f b7 d0             	movzwl %ax,%edx
  8004209085:	48 8b 45 10          	mov    0x10(%rbp),%rax
  8004209089:	48 89 c6             	mov    %rax,%rsi
  800420908c:	48 bf d2 fa 20 04 80 	movabs $0x800420fad2,%rdi
  8004209093:	00 00 00 
  8004209096:	b8 00 00 00 00       	mov    $0x0,%eax
  800420909b:	49 b8 66 64 20 04 80 	movabs $0x8004206466,%r8
  80042090a2:	00 00 00 
  80042090a5:	41 ff d0             	callq  *%r8
}
  80042090a8:	5d                   	pop    %rbp
  80042090a9:	c3                   	retq   

00000080042090aa <_dwarf_abbrev_parse>:

//Return 0 on success
int
_dwarf_abbrev_parse(Dwarf_Debug dbg, Dwarf_CU cu, Dwarf_Unsigned *offset,
		    Dwarf_Abbrev *abp, Dwarf_Section *ds)
{
  80042090aa:	55                   	push   %rbp
  80042090ab:	48 89 e5             	mov    %rsp,%rbp
  80042090ae:	48 83 ec 60          	sub    $0x60,%rsp
  80042090b2:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80042090b6:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  80042090ba:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80042090be:	48 89 4d a0          	mov    %rcx,-0x60(%rbp)
	uint64_t tag;
	uint8_t children;
	uint64_t abbr_addr;
	int ret;

	assert(abp != NULL);
  80042090c2:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80042090c7:	75 35                	jne    80042090fe <_dwarf_abbrev_parse+0x54>
  80042090c9:	48 b9 e1 fa 20 04 80 	movabs $0x800420fae1,%rcx
  80042090d0:	00 00 00 
  80042090d3:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  80042090da:	00 00 00 
  80042090dd:	be a4 01 00 00       	mov    $0x1a4,%esi
  80042090e2:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  80042090e9:	00 00 00 
  80042090ec:	b8 00 00 00 00       	mov    $0x0,%eax
  80042090f1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042090f8:	00 00 00 
  80042090fb:	41 ff d0             	callq  *%r8
	assert(ds != NULL);
  80042090fe:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
  8004209103:	75 35                	jne    800420913a <_dwarf_abbrev_parse+0x90>
  8004209105:	48 b9 ed fa 20 04 80 	movabs $0x800420faed,%rcx
  800420910c:	00 00 00 
  800420910f:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209116:	00 00 00 
  8004209119:	be a5 01 00 00       	mov    $0x1a5,%esi
  800420911e:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209125:	00 00 00 
  8004209128:	b8 00 00 00 00       	mov    $0x0,%eax
  800420912d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209134:	00 00 00 
  8004209137:	41 ff d0             	callq  *%r8

	if (*offset >= ds->ds_size)
  800420913a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420913e:	48 8b 10             	mov    (%rax),%rdx
  8004209141:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209145:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004209149:	48 39 c2             	cmp    %rax,%rdx
  800420914c:	72 0a                	jb     8004209158 <_dwarf_abbrev_parse+0xae>
        	return (DW_DLE_NO_ENTRY);
  800420914e:	b8 04 00 00 00       	mov    $0x4,%eax
  8004209153:	e9 d3 01 00 00       	jmpq   800420932b <_dwarf_abbrev_parse+0x281>

	aboff = *offset;
  8004209158:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420915c:	48 8b 00             	mov    (%rax),%rax
  800420915f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	abbr_addr = (uint64_t)ds->ds_data; //(uint64_t)((uint8_t *)elf_base_ptr + ds->sh_offset);
  8004209163:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8004209167:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420916b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	entry = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  800420916f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004209173:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004209177:	48 89 d6             	mov    %rdx,%rsi
  800420917a:	48 89 c7             	mov    %rax,%rdi
  800420917d:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  8004209184:	00 00 00 
  8004209187:	ff d0                	callq  *%rax
  8004209189:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	if (entry == 0) {
  800420918d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004209192:	75 15                	jne    80042091a9 <_dwarf_abbrev_parse+0xff>
		/* Last entry. */
		//Need to make connection from below function
		abp->ab_entry = 0;
  8004209194:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209198:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
		return DW_DLE_NONE;
  800420919f:	b8 00 00 00 00       	mov    $0x0,%eax
  80042091a4:	e9 82 01 00 00       	jmpq   800420932b <_dwarf_abbrev_parse+0x281>
	}

	tag = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  80042091a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042091ad:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80042091b1:	48 89 d6             	mov    %rdx,%rsi
  80042091b4:	48 89 c7             	mov    %rax,%rdi
  80042091b7:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  80042091be:	00 00 00 
  80042091c1:	ff d0                	callq  *%rax
  80042091c3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	children = dbg->read((uint8_t *)abbr_addr, offset, 1);
  80042091c7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80042091cb:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042091cf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042091d3:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  80042091d7:	ba 01 00 00 00       	mov    $0x1,%edx
  80042091dc:	48 89 cf             	mov    %rcx,%rdi
  80042091df:	ff d0                	callq  *%rax
  80042091e1:	88 45 df             	mov    %al,-0x21(%rbp)

	abp->ab_entry    = entry;
  80042091e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042091e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042091ec:	48 89 10             	mov    %rdx,(%rax)
	abp->ab_tag      = tag;
  80042091ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042091f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80042091f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	abp->ab_children = children;
  80042091fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042091ff:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8004209203:	88 50 10             	mov    %dl,0x10(%rax)
	abp->ab_offset   = aboff;
  8004209206:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420920a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420920e:	48 89 50 18          	mov    %rdx,0x18(%rax)
	abp->ab_length   = 0;    /* fill in later. */
  8004209212:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209216:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
  800420921d:	00 
	abp->ab_atnum    = 0;
  800420921e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209222:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  8004209229:	00 

	/* Parse attribute definitions. */
	do {
		adoff = *offset;
  800420922a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420922e:	48 8b 00             	mov    (%rax),%rax
  8004209231:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		attr = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  8004209235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004209239:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800420923d:	48 89 d6             	mov    %rdx,%rsi
  8004209240:	48 89 c7             	mov    %rax,%rdi
  8004209243:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420924a:	00 00 00 
  800420924d:	ff d0                	callq  *%rax
  800420924f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
		form = _dwarf_read_uleb128((uint8_t *)abbr_addr, offset);
  8004209253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004209257:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800420925b:	48 89 d6             	mov    %rdx,%rsi
  800420925e:	48 89 c7             	mov    %rax,%rdi
  8004209261:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  8004209268:	00 00 00 
  800420926b:	ff d0                	callq  *%rax
  800420926d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
		if (attr != 0)
  8004209271:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004209276:	0f 84 89 00 00 00    	je     8004209305 <_dwarf_abbrev_parse+0x25b>
		{
			/* Initialise the attribute definition structure. */
			abp->ab_attrdef[abp->ab_atnum].ad_attrib = attr;
  800420927c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209280:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8004209284:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8004209288:	48 89 d0             	mov    %rdx,%rax
  800420928b:	48 01 c0             	add    %rax,%rax
  800420928e:	48 01 d0             	add    %rdx,%rax
  8004209291:	48 c1 e0 03          	shl    $0x3,%rax
  8004209295:	48 01 c8             	add    %rcx,%rax
  8004209298:	48 8d 50 30          	lea    0x30(%rax),%rdx
  800420929c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80042092a0:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_form   = form;
  80042092a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042092a7:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042092ab:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80042092af:	48 89 d0             	mov    %rdx,%rax
  80042092b2:	48 01 c0             	add    %rax,%rax
  80042092b5:	48 01 d0             	add    %rdx,%rax
  80042092b8:	48 c1 e0 03          	shl    $0x3,%rax
  80042092bc:	48 01 c8             	add    %rcx,%rax
  80042092bf:	48 8d 50 38          	lea    0x38(%rax),%rdx
  80042092c3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80042092c7:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_attrdef[abp->ab_atnum].ad_offset = adoff;
  80042092ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042092ce:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80042092d2:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80042092d6:	48 89 d0             	mov    %rdx,%rax
  80042092d9:	48 01 c0             	add    %rax,%rax
  80042092dc:	48 01 d0             	add    %rdx,%rax
  80042092df:	48 c1 e0 03          	shl    $0x3,%rax
  80042092e3:	48 01 c8             	add    %rcx,%rax
  80042092e6:	48 8d 50 40          	lea    0x40(%rax),%rdx
  80042092ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80042092ee:	48 89 02             	mov    %rax,(%rdx)
			abp->ab_atnum++;
  80042092f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80042092f5:	48 8b 40 28          	mov    0x28(%rax),%rax
  80042092f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80042092fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209301:	48 89 50 28          	mov    %rdx,0x28(%rax)
		}
	} while (attr != 0);
  8004209305:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420930a:	0f 85 1a ff ff ff    	jne    800420922a <_dwarf_abbrev_parse+0x180>

	//(*abp)->ab_length = *offset - aboff;
	abp->ab_length = (uint64_t)(*offset - aboff);
  8004209310:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8004209314:	48 8b 00             	mov    (%rax),%rax
  8004209317:	48 2b 45 f8          	sub    -0x8(%rbp),%rax
  800420931b:	48 89 c2             	mov    %rax,%rdx
  800420931e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8004209322:	48 89 50 20          	mov    %rdx,0x20(%rax)

	return DW_DLV_OK;
  8004209326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420932b:	c9                   	leaveq 
  800420932c:	c3                   	retq   

000000800420932d <_dwarf_abbrev_find>:

//Return 0 on success
int
_dwarf_abbrev_find(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t entry, Dwarf_Abbrev *abp)
{
  800420932d:	55                   	push   %rbp
  800420932e:	48 89 e5             	mov    %rsp,%rbp
  8004209331:	48 83 ec 70          	sub    $0x70,%rsp
  8004209335:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004209339:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420933d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	Dwarf_Section *ds;
	uint64_t offset;
	int ret;

	if (entry == 0)
  8004209341:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8004209346:	75 0a                	jne    8004209352 <_dwarf_abbrev_find+0x25>
	{
		return (DW_DLE_NO_ENTRY);
  8004209348:	b8 04 00 00 00       	mov    $0x4,%eax
  800420934d:	e9 0a 01 00 00       	jmpq   800420945c <_dwarf_abbrev_find+0x12f>
	}

	/* Load and search the abbrev table. */
	ds = _dwarf_find_section(".debug_abbrev");
  8004209352:	48 bf f8 fa 20 04 80 	movabs $0x800420faf8,%rdi
  8004209359:	00 00 00 
  800420935c:	48 b8 8d d6 20 04 80 	movabs $0x800420d68d,%rax
  8004209363:	00 00 00 
  8004209366:	ff d0                	callq  *%rax
  8004209368:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	assert(ds != NULL);
  800420936c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004209371:	75 35                	jne    80042093a8 <_dwarf_abbrev_find+0x7b>
  8004209373:	48 b9 ed fa 20 04 80 	movabs $0x800420faed,%rcx
  800420937a:	00 00 00 
  800420937d:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209384:	00 00 00 
  8004209387:	be e5 01 00 00       	mov    $0x1e5,%esi
  800420938c:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209393:	00 00 00 
  8004209396:	b8 00 00 00 00       	mov    $0x0,%eax
  800420939b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  80042093a2:	00 00 00 
  80042093a5:	41 ff d0             	callq  *%r8

	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
  80042093a8:	48 8b 45 20          	mov    0x20(%rbp),%rax
  80042093ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (offset < ds->ds_size) {
  80042093b0:	e9 8d 00 00 00       	jmpq   8004209442 <_dwarf_abbrev_find+0x115>
		ret = _dwarf_abbrev_parse(dbg, cu, &offset, abp, ds);
  80042093b5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80042093b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80042093bd:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80042093c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042093c5:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  80042093c9:	48 89 3c 24          	mov    %rdi,(%rsp)
  80042093cd:	48 8b 7d 18          	mov    0x18(%rbp),%rdi
  80042093d1:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  80042093d6:	48 8b 7d 20          	mov    0x20(%rbp),%rdi
  80042093da:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  80042093df:	48 8b 7d 28          	mov    0x28(%rbp),%rdi
  80042093e3:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  80042093e8:	48 8b 7d 30          	mov    0x30(%rbp),%rdi
  80042093ec:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  80042093f1:	48 8b 7d 38          	mov    0x38(%rbp),%rdi
  80042093f5:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  80042093fa:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  80042093fe:	48 89 7c 24 30       	mov    %rdi,0x30(%rsp)
  8004209403:	48 89 c7             	mov    %rax,%rdi
  8004209406:	48 b8 aa 90 20 04 80 	movabs $0x80042090aa,%rax
  800420940d:	00 00 00 
  8004209410:	ff d0                	callq  *%rax
  8004209412:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (ret != DW_DLE_NONE)
  8004209415:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8004209419:	74 05                	je     8004209420 <_dwarf_abbrev_find+0xf3>
			return (ret);
  800420941b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420941e:	eb 3c                	jmp    800420945c <_dwarf_abbrev_find+0x12f>
		if (abp->ab_entry == entry) {
  8004209420:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004209424:	48 8b 00             	mov    (%rax),%rax
  8004209427:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420942b:	75 07                	jne    8004209434 <_dwarf_abbrev_find+0x107>
			//cu->cu_abbrev_offset_cur = offset;
			return DW_DLE_NONE;
  800420942d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209432:	eb 28                	jmp    800420945c <_dwarf_abbrev_find+0x12f>
		}
		if (abp->ab_entry == 0) {
  8004209434:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004209438:	48 8b 00             	mov    (%rax),%rax
  800420943b:	48 85 c0             	test   %rax,%rax
  800420943e:	75 02                	jne    8004209442 <_dwarf_abbrev_find+0x115>
			//cu->cu_abbrev_offset_cur = offset;
			//cu->cu_abbrev_loaded = 1;
			break;
  8004209440:	eb 15                	jmp    8004209457 <_dwarf_abbrev_find+0x12a>
	//TODO: We are starting offset from 0, however libdwarf logic
	//      is keeping a counter for current offset. Ok. let use
	//      that. I relent, but this will be done in Phase 2. :)
	//offset = 0; //cu->cu_abbrev_offset_cur;
	offset = cu.debug_abbrev_offset; //cu->cu_abbrev_offset_cur;
	while (offset < ds->ds_size) {
  8004209442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004209446:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420944a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420944e:	48 39 c2             	cmp    %rax,%rdx
  8004209451:	0f 87 5e ff ff ff    	ja     80042093b5 <_dwarf_abbrev_find+0x88>
			//cu->cu_abbrev_loaded = 1;
			break;
		}
	}

	return DW_DLE_NO_ENTRY;
  8004209457:	b8 04 00 00 00       	mov    $0x4,%eax
}
  800420945c:	c9                   	leaveq 
  800420945d:	c3                   	retq   

000000800420945e <_dwarf_attr_init>:

//Return 0 on success
int
_dwarf_attr_init(Dwarf_Debug dbg, uint64_t *offsetp, Dwarf_CU *cu, Dwarf_Die *ret_die, Dwarf_AttrDef *ad,
		 uint64_t form, int indirect)
{
  800420945e:	55                   	push   %rbp
  800420945f:	48 89 e5             	mov    %rsp,%rbp
  8004209462:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8004209469:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8004209470:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8004209477:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  800420947e:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
  8004209485:	4c 89 85 48 ff ff ff 	mov    %r8,-0xb8(%rbp)
  800420948c:	4c 89 8d 40 ff ff ff 	mov    %r9,-0xc0(%rbp)
	struct _Dwarf_Attribute atref;
	Dwarf_Section *str;
	int ret;
	Dwarf_Section *ds = _dwarf_find_section(".debug_info");
  8004209493:	48 bf 06 fb 20 04 80 	movabs $0x800420fb06,%rdi
  800420949a:	00 00 00 
  800420949d:	48 b8 8d d6 20 04 80 	movabs $0x800420d68d,%rax
  80042094a4:	00 00 00 
  80042094a7:	ff d0                	callq  *%rax
  80042094a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	uint8_t *ds_data = (uint8_t *)ds->ds_data; //(uint8_t *)dbg->dbg_info_offset_elf;
  80042094ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042094b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  80042094b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint8_t dwarf_size = cu->cu_dwarf_size;
  80042094b9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80042094c0:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  80042094c4:	88 45 e7             	mov    %al,-0x19(%rbp)

	ret = DW_DLE_NONE;
  80042094c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	memset(&atref, 0, sizeof(atref));
  80042094ce:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80042094d5:	ba 60 00 00 00       	mov    $0x60,%edx
  80042094da:	be 00 00 00 00       	mov    $0x0,%esi
  80042094df:	48 89 c7             	mov    %rax,%rdi
  80042094e2:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  80042094e9:	00 00 00 
  80042094ec:	ff d0                	callq  *%rax
	atref.at_die = ret_die;
  80042094ee:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80042094f5:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
	atref.at_attrib = ad->ad_attrib;
  80042094fc:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004209503:	48 8b 00             	mov    (%rax),%rax
  8004209506:	48 89 45 80          	mov    %rax,-0x80(%rbp)
	atref.at_form = ad->ad_form;
  800420950a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8004209511:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004209515:	48 89 45 88          	mov    %rax,-0x78(%rbp)
	atref.at_indirect = indirect;
  8004209519:	8b 45 10             	mov    0x10(%rbp),%eax
  800420951c:	89 45 90             	mov    %eax,-0x70(%rbp)
	atref.at_ld = NULL;
  800420951f:	48 c7 45 b8 00 00 00 	movq   $0x0,-0x48(%rbp)
  8004209526:	00 

	switch (form) {
  8004209527:	48 83 bd 40 ff ff ff 	cmpq   $0x20,-0xc0(%rbp)
  800420952e:	20 
  800420952f:	0f 87 82 04 00 00    	ja     80042099b7 <_dwarf_attr_init+0x559>
  8004209535:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  800420953c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004209543:	00 
  8004209544:	48 b8 30 fb 20 04 80 	movabs $0x800420fb30,%rax
  800420954b:	00 00 00 
  800420954e:	48 01 d0             	add    %rdx,%rax
  8004209551:	48 8b 00             	mov    (%rax),%rax
  8004209554:	ff e0                	jmpq   *%rax
	case DW_FORM_addr:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  8004209556:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420955d:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004209561:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8004209568:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  800420956c:	0f b6 d2             	movzbl %dl,%edx
  800420956f:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209576:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420957a:	48 89 cf             	mov    %rcx,%rdi
  800420957d:	ff d0                	callq  *%rax
  800420957f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004209583:	e9 37 04 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_block:
	case DW_FORM_exprloc:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  8004209588:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800420958f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209593:	48 89 d6             	mov    %rdx,%rsi
  8004209596:	48 89 c7             	mov    %rax,%rdi
  8004209599:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  80042095a0:	00 00 00 
  80042095a3:	ff d0                	callq  *%rax
  80042095a5:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  80042095a9:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042095ad:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  80042095b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042095b8:	48 89 ce             	mov    %rcx,%rsi
  80042095bb:	48 89 c7             	mov    %rax,%rdi
  80042095be:	48 b8 d5 8c 20 04 80 	movabs $0x8004208cd5,%rax
  80042095c5:	00 00 00 
  80042095c8:	ff d0                	callq  *%rax
  80042095ca:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042095ce:	e9 ec 03 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_block1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  80042095d3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042095da:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042095de:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042095e5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042095e9:	ba 01 00 00 00       	mov    $0x1,%edx
  80042095ee:	48 89 cf             	mov    %rcx,%rdi
  80042095f1:	ff d0                	callq  *%rax
  80042095f3:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  80042095f7:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  80042095fb:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004209602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209606:	48 89 ce             	mov    %rcx,%rsi
  8004209609:	48 89 c7             	mov    %rax,%rdi
  800420960c:	48 b8 d5 8c 20 04 80 	movabs $0x8004208cd5,%rax
  8004209613:	00 00 00 
  8004209616:	ff d0                	callq  *%rax
  8004209618:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420961c:	e9 9e 03 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_block2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  8004209621:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004209628:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420962c:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209633:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209637:	ba 02 00 00 00       	mov    $0x2,%edx
  800420963c:	48 89 cf             	mov    %rcx,%rdi
  800420963f:	ff d0                	callq  *%rax
  8004209641:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004209645:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004209649:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004209650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209654:	48 89 ce             	mov    %rcx,%rsi
  8004209657:	48 89 c7             	mov    %rax,%rdi
  800420965a:	48 b8 d5 8c 20 04 80 	movabs $0x8004208cd5,%rax
  8004209661:	00 00 00 
  8004209664:	ff d0                	callq  *%rax
  8004209666:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420966a:	e9 50 03 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_block4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  800420966f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004209676:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420967a:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209681:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209685:	ba 04 00 00 00       	mov    $0x4,%edx
  800420968a:	48 89 cf             	mov    %rcx,%rdi
  800420968d:	ff d0                	callq  *%rax
  800420968f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		atref.u[1].u8p = (uint8_t*)_dwarf_read_block(ds_data, offsetp, atref.u[0].u64);
  8004209693:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004209697:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  800420969e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042096a2:	48 89 ce             	mov    %rcx,%rsi
  80042096a5:	48 89 c7             	mov    %rax,%rdi
  80042096a8:	48 b8 d5 8c 20 04 80 	movabs $0x8004208cd5,%rax
  80042096af:	00 00 00 
  80042096b2:	ff d0                	callq  *%rax
  80042096b4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042096b8:	e9 02 03 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_data1:
	case DW_FORM_flag:
	case DW_FORM_ref1:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 1);
  80042096bd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042096c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042096c8:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042096cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042096d3:	ba 01 00 00 00       	mov    $0x1,%edx
  80042096d8:	48 89 cf             	mov    %rcx,%rdi
  80042096db:	ff d0                	callq  *%rax
  80042096dd:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042096e1:	e9 d9 02 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_data2:
	case DW_FORM_ref2:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 2);
  80042096e6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042096ed:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042096f1:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042096f8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042096fc:	ba 02 00 00 00       	mov    $0x2,%edx
  8004209701:	48 89 cf             	mov    %rcx,%rdi
  8004209704:	ff d0                	callq  *%rax
  8004209706:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420970a:	e9 b0 02 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_data4:
	case DW_FORM_ref4:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 4);
  800420970f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004209716:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420971a:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209721:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209725:	ba 04 00 00 00       	mov    $0x4,%edx
  800420972a:	48 89 cf             	mov    %rcx,%rdi
  800420972d:	ff d0                	callq  *%rax
  800420972f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004209733:	e9 87 02 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_data8:
	case DW_FORM_ref8:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, 8);
  8004209738:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420973f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8004209743:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800420974a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420974e:	ba 08 00 00 00       	mov    $0x8,%edx
  8004209753:	48 89 cf             	mov    %rcx,%rdi
  8004209756:	ff d0                	callq  *%rax
  8004209758:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420975c:	e9 5e 02 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_indirect:
		form = _dwarf_read_uleb128(ds_data, offsetp);
  8004209761:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004209768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420976c:	48 89 d6             	mov    %rdx,%rsi
  800420976f:	48 89 c7             	mov    %rax,%rdi
  8004209772:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  8004209779:	00 00 00 
  800420977c:	ff d0                	callq  *%rax
  800420977e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
		return (_dwarf_attr_init(dbg, offsetp, cu, ret_die, ad, form, 1));
  8004209785:	4c 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%r8
  800420978c:	48 8b bd 48 ff ff ff 	mov    -0xb8(%rbp),%rdi
  8004209793:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  800420979a:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80042097a1:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042097a8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042097af:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  80042097b6:	4d 89 c1             	mov    %r8,%r9
  80042097b9:	49 89 f8             	mov    %rdi,%r8
  80042097bc:	48 89 c7             	mov    %rax,%rdi
  80042097bf:	48 b8 5e 94 20 04 80 	movabs $0x800420945e,%rax
  80042097c6:	00 00 00 
  80042097c9:	ff d0                	callq  *%rax
  80042097cb:	e9 1d 03 00 00       	jmpq   8004209aed <_dwarf_attr_init+0x68f>
	case DW_FORM_ref_addr:
		if (cu->version == 2)
  80042097d0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80042097d7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80042097db:	66 83 f8 02          	cmp    $0x2,%ax
  80042097df:	75 2f                	jne    8004209810 <_dwarf_attr_init+0x3b2>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, cu->addr_size);
  80042097e1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042097e8:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042097ec:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80042097f3:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  80042097f7:	0f b6 d2             	movzbl %dl,%edx
  80042097fa:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209801:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209805:	48 89 cf             	mov    %rcx,%rdi
  8004209808:	ff d0                	callq  *%rax
  800420980a:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  800420980e:	eb 39                	jmp    8004209849 <_dwarf_attr_init+0x3eb>
		else if (cu->version == 3)
  8004209810:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8004209817:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  800420981b:	66 83 f8 03          	cmp    $0x3,%ax
  800420981f:	75 28                	jne    8004209849 <_dwarf_attr_init+0x3eb>
			atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  8004209821:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8004209828:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420982c:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  8004209830:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209837:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420983b:	48 89 cf             	mov    %rcx,%rdi
  800420983e:	ff d0                	callq  *%rax
  8004209840:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004209844:	e9 76 01 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
  8004209849:	e9 71 01 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_ref_udata:
	case DW_FORM_udata:
		atref.u[0].u64 = _dwarf_read_uleb128(ds_data, offsetp);
  800420984e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004209855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209859:	48 89 d6             	mov    %rdx,%rsi
  800420985c:	48 89 c7             	mov    %rax,%rdi
  800420985f:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  8004209866:	00 00 00 
  8004209869:	ff d0                	callq  *%rax
  800420986b:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  800420986f:	e9 4b 01 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_sdata:
		atref.u[0].s64 = _dwarf_read_sleb128(ds_data, offsetp);
  8004209874:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800420987b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420987f:	48 89 d6             	mov    %rdx,%rsi
  8004209882:	48 89 c7             	mov    %rax,%rdi
  8004209885:	48 b8 24 8a 20 04 80 	movabs $0x8004208a24,%rax
  800420988c:	00 00 00 
  800420988f:	ff d0                	callq  *%rax
  8004209891:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  8004209895:	e9 25 01 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_sec_offset:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  800420989a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042098a1:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042098a5:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  80042098a9:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  80042098b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80042098b4:	48 89 cf             	mov    %rcx,%rdi
  80042098b7:	ff d0                	callq  *%rax
  80042098b9:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042098bd:	e9 fd 00 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_string:
		atref.u[0].s =(char*) _dwarf_read_string(ds_data, (uint64_t)ds->ds_size, offsetp);
  80042098c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042098c6:	48 8b 48 18          	mov    0x18(%rax),%rcx
  80042098ca:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80042098d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042098d5:	48 89 ce             	mov    %rcx,%rsi
  80042098d8:	48 89 c7             	mov    %rax,%rdi
  80042098db:	48 b8 46 8c 20 04 80 	movabs $0x8004208c46,%rax
  80042098e2:	00 00 00 
  80042098e5:	ff d0                	callq  *%rax
  80042098e7:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		break;
  80042098eb:	e9 cf 00 00 00       	jmpq   80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_strp:
		atref.u[0].u64 = dbg->read(ds_data, offsetp, dwarf_size);
  80042098f0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80042098f7:	48 8b 40 18          	mov    0x18(%rax),%rax
  80042098fb:	0f b6 55 e7          	movzbl -0x19(%rbp),%edx
  80042098ff:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004209906:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420990a:	48 89 cf             	mov    %rcx,%rdi
  800420990d:	ff d0                	callq  *%rax
  800420990f:	48 89 45 98          	mov    %rax,-0x68(%rbp)
		str = _dwarf_find_section(".debug_str");
  8004209913:	48 bf 12 fb 20 04 80 	movabs $0x800420fb12,%rdi
  800420991a:	00 00 00 
  800420991d:	48 b8 8d d6 20 04 80 	movabs $0x800420d68d,%rax
  8004209924:	00 00 00 
  8004209927:	ff d0                	callq  *%rax
  8004209929:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		assert(str != NULL);
  800420992d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004209932:	75 35                	jne    8004209969 <_dwarf_attr_init+0x50b>
  8004209934:	48 b9 1d fb 20 04 80 	movabs $0x800420fb1d,%rcx
  800420993b:	00 00 00 
  800420993e:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209945:	00 00 00 
  8004209948:	be 51 02 00 00       	mov    $0x251,%esi
  800420994d:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209954:	00 00 00 
  8004209957:	b8 00 00 00 00       	mov    $0x0,%eax
  800420995c:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209963:	00 00 00 
  8004209966:	41 ff d0             	callq  *%r8
		//atref.u[1].s = (char *)(elf_base_ptr + str->sh_offset) + atref.u[0].u64;
		atref.u[1].s = (char *)str->ds_data + atref.u[0].u64;
  8004209969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420996d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004209971:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8004209975:	48 01 d0             	add    %rdx,%rax
  8004209978:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  800420997c:	eb 41                	jmp    80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_ref_sig8:
		atref.u[0].u64 = 8;
  800420997e:	48 c7 45 98 08 00 00 	movq   $0x8,-0x68(%rbp)
  8004209985:	00 
		atref.u[1].u8p = (uint8_t*)(_dwarf_read_block(ds_data, offsetp, atref.u[0].u64));
  8004209986:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800420998a:	48 8b 8d 60 ff ff ff 	mov    -0xa0(%rbp),%rcx
  8004209991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209995:	48 89 ce             	mov    %rcx,%rsi
  8004209998:	48 89 c7             	mov    %rax,%rdi
  800420999b:	48 b8 d5 8c 20 04 80 	movabs $0x8004208cd5,%rax
  80042099a2:	00 00 00 
  80042099a5:	ff d0                	callq  *%rax
  80042099a7:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
		break;
  80042099ab:	eb 12                	jmp    80042099bf <_dwarf_attr_init+0x561>
	case DW_FORM_flag_present:
		/* This form has no value encoded in the DIE. */
		atref.u[0].u64 = 1;
  80042099ad:	48 c7 45 98 01 00 00 	movq   $0x1,-0x68(%rbp)
  80042099b4:	00 
		break;
  80042099b5:	eb 08                	jmp    80042099bf <_dwarf_attr_init+0x561>
	default:
		//DWARF_SET_ERROR(dbg, error, DW_DLE_ATTR_FORM_BAD);
		ret = DW_DLE_ATTR_FORM_BAD;
  80042099b7:	c7 45 fc 0e 00 00 00 	movl   $0xe,-0x4(%rbp)
		break;
  80042099be:	90                   	nop
	}

	if (ret == DW_DLE_NONE) {
  80042099bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80042099c3:	0f 85 21 01 00 00    	jne    8004209aea <_dwarf_attr_init+0x68c>
		if (form == DW_FORM_block || form == DW_FORM_block1 ||
  80042099c9:	48 83 bd 40 ff ff ff 	cmpq   $0x9,-0xc0(%rbp)
  80042099d0:	09 
  80042099d1:	74 1e                	je     80042099f1 <_dwarf_attr_init+0x593>
  80042099d3:	48 83 bd 40 ff ff ff 	cmpq   $0xa,-0xc0(%rbp)
  80042099da:	0a 
  80042099db:	74 14                	je     80042099f1 <_dwarf_attr_init+0x593>
  80042099dd:	48 83 bd 40 ff ff ff 	cmpq   $0x3,-0xc0(%rbp)
  80042099e4:	03 
  80042099e5:	74 0a                	je     80042099f1 <_dwarf_attr_init+0x593>
		    form == DW_FORM_block2 || form == DW_FORM_block4) {
  80042099e7:	48 83 bd 40 ff ff ff 	cmpq   $0x4,-0xc0(%rbp)
  80042099ee:	04 
  80042099ef:	75 10                	jne    8004209a01 <_dwarf_attr_init+0x5a3>
			atref.at_block.bl_len = atref.u[0].u64;
  80042099f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80042099f5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			atref.at_block.bl_data = atref.u[1].u8p;
  80042099f9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80042099fd:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
  8004209a01:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  8004209a05:	48 83 f8 03          	cmp    $0x3,%rax
  8004209a09:	75 39                	jne    8004209a44 <_dwarf_attr_init+0x5e6>
			switch (atref.at_form) {
  8004209a0b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8004209a0f:	48 83 f8 08          	cmp    $0x8,%rax
  8004209a13:	74 1c                	je     8004209a31 <_dwarf_attr_init+0x5d3>
  8004209a15:	48 83 f8 0e          	cmp    $0xe,%rax
  8004209a19:	74 02                	je     8004209a1d <_dwarf_attr_init+0x5bf>
				break;
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
				break;
			default:
				break;
  8004209a1b:	eb 27                	jmp    8004209a44 <_dwarf_attr_init+0x5e6>
		}
		//ret = _dwarf_attr_add(die, &atref, NULL, error);
		if (atref.at_attrib == DW_AT_name) {
			switch (atref.at_form) {
			case DW_FORM_strp:
				ret_die->die_name = atref.u[1].s;
  8004209a1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004209a21:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004209a28:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  8004209a2f:	eb 13                	jmp    8004209a44 <_dwarf_attr_init+0x5e6>
			case DW_FORM_string:
				ret_die->die_name = atref.u[0].s;
  8004209a31:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004209a35:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004209a3c:	48 89 90 50 03 00 00 	mov    %rdx,0x350(%rax)
				break;
  8004209a43:	90                   	nop
			default:
				break;
			}
		}
		ret_die->die_attr[ret_die->die_attr_count++] = atref;
  8004209a44:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8004209a4b:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  8004209a52:	8d 48 01             	lea    0x1(%rax),%ecx
  8004209a55:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8004209a5c:	88 8a 58 03 00 00    	mov    %cl,0x358(%rdx)
  8004209a62:	0f b6 c0             	movzbl %al,%eax
  8004209a65:	48 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%rcx
  8004209a6c:	48 63 d0             	movslq %eax,%rdx
  8004209a6f:	48 89 d0             	mov    %rdx,%rax
  8004209a72:	48 01 c0             	add    %rax,%rax
  8004209a75:	48 01 d0             	add    %rdx,%rax
  8004209a78:	48 c1 e0 05          	shl    $0x5,%rax
  8004209a7c:	48 01 c8             	add    %rcx,%rax
  8004209a7f:	48 05 70 03 00 00    	add    $0x370,%rax
  8004209a85:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  8004209a8c:	48 89 10             	mov    %rdx,(%rax)
  8004209a8f:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  8004209a96:	48 89 50 08          	mov    %rdx,0x8(%rax)
  8004209a9a:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  8004209a9e:	48 89 50 10          	mov    %rdx,0x10(%rax)
  8004209aa2:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  8004209aa6:	48 89 50 18          	mov    %rdx,0x18(%rax)
  8004209aaa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8004209aae:	48 89 50 20          	mov    %rdx,0x20(%rax)
  8004209ab2:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  8004209ab6:	48 89 50 28          	mov    %rdx,0x28(%rax)
  8004209aba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8004209abe:	48 89 50 30          	mov    %rdx,0x30(%rax)
  8004209ac2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8004209ac6:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8004209aca:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8004209ace:	48 89 50 40          	mov    %rdx,0x40(%rax)
  8004209ad2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8004209ad6:	48 89 50 48          	mov    %rdx,0x48(%rax)
  8004209ada:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8004209ade:	48 89 50 50          	mov    %rdx,0x50(%rax)
  8004209ae2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8004209ae6:	48 89 50 58          	mov    %rdx,0x58(%rax)
	}

	return (ret);
  8004209aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8004209aed:	c9                   	leaveq 
  8004209aee:	c3                   	retq   

0000008004209aef <dwarf_search_die_within_cu>:

int
dwarf_search_die_within_cu(Dwarf_Debug dbg, Dwarf_CU cu, uint64_t offset, Dwarf_Die *ret_die, int search_sibling)
{
  8004209aef:	55                   	push   %rbp
  8004209af0:	48 89 e5             	mov    %rsp,%rbp
  8004209af3:	48 81 ec d0 03 00 00 	sub    $0x3d0,%rsp
  8004209afa:	48 89 bd 88 fc ff ff 	mov    %rdi,-0x378(%rbp)
  8004209b01:	48 89 b5 80 fc ff ff 	mov    %rsi,-0x380(%rbp)
  8004209b08:	48 89 95 78 fc ff ff 	mov    %rdx,-0x388(%rbp)
  8004209b0f:	89 8d 74 fc ff ff    	mov    %ecx,-0x38c(%rbp)
	uint64_t abnum;
	uint64_t die_offset;
	int ret, level;
	int i;

	assert(dbg);
  8004209b15:	48 83 bd 88 fc ff ff 	cmpq   $0x0,-0x378(%rbp)
  8004209b1c:	00 
  8004209b1d:	75 35                	jne    8004209b54 <dwarf_search_die_within_cu+0x65>
  8004209b1f:	48 b9 38 fc 20 04 80 	movabs $0x800420fc38,%rcx
  8004209b26:	00 00 00 
  8004209b29:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209b30:	00 00 00 
  8004209b33:	be 86 02 00 00       	mov    $0x286,%esi
  8004209b38:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209b3f:	00 00 00 
  8004209b42:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209b47:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209b4e:	00 00 00 
  8004209b51:	41 ff d0             	callq  *%r8
	//assert(cu);
	assert(ret_die);
  8004209b54:	48 83 bd 78 fc ff ff 	cmpq   $0x0,-0x388(%rbp)
  8004209b5b:	00 
  8004209b5c:	75 35                	jne    8004209b93 <dwarf_search_die_within_cu+0xa4>
  8004209b5e:	48 b9 3c fc 20 04 80 	movabs $0x800420fc3c,%rcx
  8004209b65:	00 00 00 
  8004209b68:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209b6f:	00 00 00 
  8004209b72:	be 88 02 00 00       	mov    $0x288,%esi
  8004209b77:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209b7e:	00 00 00 
  8004209b81:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209b86:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209b8d:	00 00 00 
  8004209b90:	41 ff d0             	callq  *%r8

	level = 1;
  8004209b93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004209b9a:	e9 17 02 00 00       	jmpq   8004209db6 <dwarf_search_die_within_cu+0x2c7>

		die_offset = offset;
  8004209b9f:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004209ba6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

		abnum = _dwarf_read_uleb128((uint8_t *)dbg->dbg_info_offset_elf, &offset);
  8004209baa:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004209bb1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004209bb5:	48 8d 95 80 fc ff ff 	lea    -0x380(%rbp),%rdx
  8004209bbc:	48 89 d6             	mov    %rdx,%rsi
  8004209bbf:	48 89 c7             	mov    %rax,%rdi
  8004209bc2:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  8004209bc9:	00 00 00 
  8004209bcc:	ff d0                	callq  *%rax
  8004209bce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

		if (abnum == 0) {
  8004209bd2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004209bd7:	75 22                	jne    8004209bfb <dwarf_search_die_within_cu+0x10c>
			if (level == 0 || !search_sibling) {
  8004209bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004209bdd:	74 09                	je     8004209be8 <dwarf_search_die_within_cu+0xf9>
  8004209bdf:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004209be6:	75 0a                	jne    8004209bf2 <dwarf_search_die_within_cu+0x103>
				//No more entry
				return (DW_DLE_NO_ENTRY);
  8004209be8:	b8 04 00 00 00       	mov    $0x4,%eax
  8004209bed:	e9 f4 01 00 00       	jmpq   8004209de6 <dwarf_search_die_within_cu+0x2f7>
			}
			/*
			 * Return to previous DIE level.
			 */
			level--;
  8004209bf2:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
			continue;
  8004209bf6:	e9 bb 01 00 00       	jmpq   8004209db6 <dwarf_search_die_within_cu+0x2c7>
		}

		if ((ret = _dwarf_abbrev_find(dbg, cu, abnum, &ab)) != DW_DLE_NONE)
  8004209bfb:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004209c02:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209c06:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004209c0d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8004209c11:	48 89 34 24          	mov    %rsi,(%rsp)
  8004209c15:	48 8b 75 18          	mov    0x18(%rbp),%rsi
  8004209c19:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8004209c1e:	48 8b 75 20          	mov    0x20(%rbp),%rsi
  8004209c22:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8004209c27:	48 8b 75 28          	mov    0x28(%rbp),%rsi
  8004209c2b:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  8004209c30:	48 8b 75 30          	mov    0x30(%rbp),%rsi
  8004209c34:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8004209c39:	48 8b 75 38          	mov    0x38(%rbp),%rsi
  8004209c3d:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  8004209c42:	48 8b 75 40          	mov    0x40(%rbp),%rsi
  8004209c46:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  8004209c4b:	48 89 ce             	mov    %rcx,%rsi
  8004209c4e:	48 89 c7             	mov    %rax,%rdi
  8004209c51:	48 b8 2d 93 20 04 80 	movabs $0x800420932d,%rax
  8004209c58:	00 00 00 
  8004209c5b:	ff d0                	callq  *%rax
  8004209c5d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004209c60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004209c64:	74 08                	je     8004209c6e <dwarf_search_die_within_cu+0x17f>
			return (ret);
  8004209c66:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004209c69:	e9 78 01 00 00       	jmpq   8004209de6 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_offset = die_offset;
  8004209c6e:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209c75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004209c79:	48 89 10             	mov    %rdx,(%rax)
		ret_die->die_abnum  = abnum;
  8004209c7c:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209c83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004209c87:	48 89 50 10          	mov    %rdx,0x10(%rax)
		ret_die->die_ab  = ab;
  8004209c8b:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209c92:	48 8d 78 20          	lea    0x20(%rax),%rdi
  8004209c96:	48 8d 95 b0 fc ff ff 	lea    -0x350(%rbp),%rdx
  8004209c9d:	b8 66 00 00 00       	mov    $0x66,%eax
  8004209ca2:	48 89 d6             	mov    %rdx,%rsi
  8004209ca5:	48 89 c1             	mov    %rax,%rcx
  8004209ca8:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
		ret_die->die_attr_count = 0;
  8004209cab:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209cb2:	c6 80 58 03 00 00 00 	movb   $0x0,0x358(%rax)
		ret_die->die_tag = ab.ab_tag;
  8004209cb9:	48 8b 95 b8 fc ff ff 	mov    -0x348(%rbp),%rdx
  8004209cc0:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209cc7:	48 89 50 18          	mov    %rdx,0x18(%rax)
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004209ccb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004209cd2:	e9 8e 00 00 00       	jmpq   8004209d65 <dwarf_search_die_within_cu+0x276>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
  8004209cd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004209cda:	48 63 d0             	movslq %eax,%rdx
  8004209cdd:	48 89 d0             	mov    %rdx,%rax
  8004209ce0:	48 01 c0             	add    %rax,%rax
  8004209ce3:	48 01 d0             	add    %rdx,%rax
  8004209ce6:	48 c1 e0 03          	shl    $0x3,%rax
  8004209cea:	48 01 e8             	add    %rbp,%rax
  8004209ced:	48 2d 18 03 00 00    	sub    $0x318,%rax
  8004209cf3:	48 8b 08             	mov    (%rax),%rcx
  8004209cf6:	48 8d b5 b0 fc ff ff 	lea    -0x350(%rbp),%rsi
  8004209cfd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004209d00:	48 63 d0             	movslq %eax,%rdx
  8004209d03:	48 89 d0             	mov    %rdx,%rax
  8004209d06:	48 01 c0             	add    %rax,%rax
  8004209d09:	48 01 d0             	add    %rdx,%rax
  8004209d0c:	48 c1 e0 03          	shl    $0x3,%rax
  8004209d10:	48 83 c0 30          	add    $0x30,%rax
  8004209d14:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8004209d18:	48 8b 95 78 fc ff ff 	mov    -0x388(%rbp),%rdx
  8004209d1f:	48 8d b5 80 fc ff ff 	lea    -0x380(%rbp),%rsi
  8004209d26:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004209d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  8004209d34:	49 89 c9             	mov    %rcx,%r9
  8004209d37:	49 89 f8             	mov    %rdi,%r8
  8004209d3a:	48 89 d1             	mov    %rdx,%rcx
  8004209d3d:	48 8d 55 10          	lea    0x10(%rbp),%rdx
  8004209d41:	48 89 c7             	mov    %rax,%rdi
  8004209d44:	48 b8 5e 94 20 04 80 	movabs $0x800420945e,%rax
  8004209d4b:	00 00 00 
  8004209d4e:	ff d0                	callq  *%rax
  8004209d50:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8004209d53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004209d57:	74 08                	je     8004209d61 <dwarf_search_die_within_cu+0x272>
				return (ret);
  8004209d59:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004209d5c:	e9 85 00 00 00       	jmpq   8004209de6 <dwarf_search_die_within_cu+0x2f7>
		ret_die->die_attr_count = 0;
		ret_die->die_tag = ab.ab_tag;
		//ret_die->die_cu  = cu;
		//ret_die->die_dbg = cu->cu_dbg;

		for(i=0; i < ab.ab_atnum; i++)
  8004209d61:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8004209d65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004209d68:	48 63 d0             	movslq %eax,%rdx
  8004209d6b:	48 8b 85 d8 fc ff ff 	mov    -0x328(%rbp),%rax
  8004209d72:	48 39 c2             	cmp    %rax,%rdx
  8004209d75:	0f 82 5c ff ff ff    	jb     8004209cd7 <dwarf_search_die_within_cu+0x1e8>
		{
			if ((ret = _dwarf_attr_init(dbg, &offset, &cu, ret_die, &ab.ab_attrdef[i], ab.ab_attrdef[i].ad_form, 0)) != DW_DLE_NONE)
				return (ret);
		}

		ret_die->die_next_off = offset;
  8004209d7b:	48 8b 95 80 fc ff ff 	mov    -0x380(%rbp),%rdx
  8004209d82:	48 8b 85 78 fc ff ff 	mov    -0x388(%rbp),%rax
  8004209d89:	48 89 50 08          	mov    %rdx,0x8(%rax)
		if (search_sibling && level > 0) {
  8004209d8d:	83 bd 74 fc ff ff 00 	cmpl   $0x0,-0x38c(%rbp)
  8004209d94:	74 19                	je     8004209daf <dwarf_search_die_within_cu+0x2c0>
  8004209d96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004209d9a:	7e 13                	jle    8004209daf <dwarf_search_die_within_cu+0x2c0>
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004209d9c:	0f b6 85 c0 fc ff ff 	movzbl -0x340(%rbp),%eax
  8004209da3:	3c 01                	cmp    $0x1,%al
  8004209da5:	75 06                	jne    8004209dad <dwarf_search_die_within_cu+0x2be>
				/* Advance to next DIE level. */
				level++;
  8004209da7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		}

		ret_die->die_next_off = offset;
		if (search_sibling && level > 0) {
			//dwarf_dealloc(dbg, die, DW_DLA_DIE);
			if (ab.ab_children == DW_CHILDREN_yes) {
  8004209dab:	eb 09                	jmp    8004209db6 <dwarf_search_die_within_cu+0x2c7>
  8004209dad:	eb 07                	jmp    8004209db6 <dwarf_search_die_within_cu+0x2c7>
				/* Advance to next DIE level. */
				level++;
			}
		} else {
			//*ret_die = die;
			return (DW_DLE_NONE);
  8004209daf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209db4:	eb 30                	jmp    8004209de6 <dwarf_search_die_within_cu+0x2f7>
	//assert(cu);
	assert(ret_die);

	level = 1;

	while (offset < cu.cu_next_offset && offset < dbg->dbg_info_size) {
  8004209db6:	48 8b 55 30          	mov    0x30(%rbp),%rdx
  8004209dba:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004209dc1:	48 39 c2             	cmp    %rax,%rdx
  8004209dc4:	76 1b                	jbe    8004209de1 <dwarf_search_die_within_cu+0x2f2>
  8004209dc6:	48 8b 85 88 fc ff ff 	mov    -0x378(%rbp),%rax
  8004209dcd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004209dd1:	48 8b 85 80 fc ff ff 	mov    -0x380(%rbp),%rax
  8004209dd8:	48 39 c2             	cmp    %rax,%rdx
  8004209ddb:	0f 87 be fd ff ff    	ja     8004209b9f <dwarf_search_die_within_cu+0xb0>
			//*ret_die = die;
			return (DW_DLE_NONE);
		}
	}

	return (DW_DLE_NO_ENTRY);
  8004209de1:	b8 04 00 00 00       	mov    $0x4,%eax
}
  8004209de6:	c9                   	leaveq 
  8004209de7:	c3                   	retq   

0000008004209de8 <dwarf_offdie>:

//Return 0 on success
int
dwarf_offdie(Dwarf_Debug dbg, uint64_t offset, Dwarf_Die *ret_die, Dwarf_CU cu)
{
  8004209de8:	55                   	push   %rbp
  8004209de9:	48 89 e5             	mov    %rsp,%rbp
  8004209dec:	48 83 ec 60          	sub    $0x60,%rsp
  8004209df0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004209df4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004209df8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int ret;

	assert(dbg);
  8004209dfc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004209e01:	75 35                	jne    8004209e38 <dwarf_offdie+0x50>
  8004209e03:	48 b9 38 fc 20 04 80 	movabs $0x800420fc38,%rcx
  8004209e0a:	00 00 00 
  8004209e0d:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209e14:	00 00 00 
  8004209e17:	be c4 02 00 00       	mov    $0x2c4,%esi
  8004209e1c:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209e23:	00 00 00 
  8004209e26:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209e2b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209e32:	00 00 00 
  8004209e35:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004209e38:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004209e3d:	75 35                	jne    8004209e74 <dwarf_offdie+0x8c>
  8004209e3f:	48 b9 3c fc 20 04 80 	movabs $0x800420fc3c,%rcx
  8004209e46:	00 00 00 
  8004209e49:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209e50:	00 00 00 
  8004209e53:	be c5 02 00 00       	mov    $0x2c5,%esi
  8004209e58:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209e5f:	00 00 00 
  8004209e62:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209e67:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209e6e:	00 00 00 
  8004209e71:	41 ff d0             	callq  *%r8

	/* First search the current CU. */
	if (offset < cu.cu_next_offset) {
  8004209e74:	48 8b 45 30          	mov    0x30(%rbp),%rax
  8004209e78:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  8004209e7c:	76 66                	jbe    8004209ee4 <dwarf_offdie+0xfc>
		ret = dwarf_search_die_within_cu(dbg, cu, offset, ret_die, 0);
  8004209e7e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8004209e82:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004209e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209e8a:	48 8b 4d 10          	mov    0x10(%rbp),%rcx
  8004209e8e:	48 89 0c 24          	mov    %rcx,(%rsp)
  8004209e92:	48 8b 4d 18          	mov    0x18(%rbp),%rcx
  8004209e96:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8004209e9b:	48 8b 4d 20          	mov    0x20(%rbp),%rcx
  8004209e9f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8004209ea4:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  8004209ea8:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8004209ead:	48 8b 4d 30          	mov    0x30(%rbp),%rcx
  8004209eb1:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8004209eb6:	48 8b 4d 38          	mov    0x38(%rbp),%rcx
  8004209eba:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8004209ebf:	48 8b 4d 40          	mov    0x40(%rbp),%rcx
  8004209ec3:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  8004209ec8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004209ecd:	48 89 c7             	mov    %rax,%rdi
  8004209ed0:	48 b8 ef 9a 20 04 80 	movabs $0x8004209aef,%rax
  8004209ed7:	00 00 00 
  8004209eda:	ff d0                	callq  *%rax
  8004209edc:	89 45 fc             	mov    %eax,-0x4(%rbp)
		return ret;
  8004209edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004209ee2:	eb 05                	jmp    8004209ee9 <dwarf_offdie+0x101>
	}

	/*TODO: Search other CU*/
	return DW_DLV_OK;
  8004209ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004209ee9:	c9                   	leaveq 
  8004209eea:	c3                   	retq   

0000008004209eeb <_dwarf_attr_find>:

Dwarf_Attribute*
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
  8004209eeb:	55                   	push   %rbp
  8004209eec:	48 89 e5             	mov    %rsp,%rbp
  8004209eef:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004209ef3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004209ef7:	89 f0                	mov    %esi,%eax
  8004209ef9:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Attribute *myat = NULL;
  8004209efd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8004209f04:	00 
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  8004209f05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8004209f0c:	eb 57                	jmp    8004209f65 <_dwarf_attr_find+0x7a>
	{
		if (die->die_attr[i].at_attrib == attr)
  8004209f0e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004209f12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209f15:	48 63 d0             	movslq %eax,%rdx
  8004209f18:	48 89 d0             	mov    %rdx,%rax
  8004209f1b:	48 01 c0             	add    %rax,%rax
  8004209f1e:	48 01 d0             	add    %rdx,%rax
  8004209f21:	48 c1 e0 05          	shl    $0x5,%rax
  8004209f25:	48 01 c8             	add    %rcx,%rax
  8004209f28:	48 05 80 03 00 00    	add    $0x380,%rax
  8004209f2e:	48 8b 10             	mov    (%rax),%rdx
  8004209f31:	0f b7 45 e4          	movzwl -0x1c(%rbp),%eax
  8004209f35:	48 39 c2             	cmp    %rax,%rdx
  8004209f38:	75 27                	jne    8004209f61 <_dwarf_attr_find+0x76>
		{
			myat = &(die->die_attr[i]);
  8004209f3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004209f3d:	48 63 d0             	movslq %eax,%rdx
  8004209f40:	48 89 d0             	mov    %rdx,%rax
  8004209f43:	48 01 c0             	add    %rax,%rax
  8004209f46:	48 01 d0             	add    %rdx,%rax
  8004209f49:	48 c1 e0 05          	shl    $0x5,%rax
  8004209f4d:	48 8d 90 70 03 00 00 	lea    0x370(%rax),%rdx
  8004209f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209f58:	48 01 d0             	add    %rdx,%rax
  8004209f5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  8004209f5f:	eb 17                	jmp    8004209f78 <_dwarf_attr_find+0x8d>
_dwarf_attr_find(Dwarf_Die *die, uint16_t attr)
{
	Dwarf_Attribute *myat = NULL;
	int i;
    
	for(i=0; i < die->die_attr_count; i++)
  8004209f61:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8004209f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004209f69:	0f b6 80 58 03 00 00 	movzbl 0x358(%rax),%eax
  8004209f70:	0f b6 c0             	movzbl %al,%eax
  8004209f73:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8004209f76:	7f 96                	jg     8004209f0e <_dwarf_attr_find+0x23>
			myat = &(die->die_attr[i]);
			break;
		}
	}

	return myat;
  8004209f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004209f7c:	c9                   	leaveq 
  8004209f7d:	c3                   	retq   

0000008004209f7e <dwarf_siblingof>:

//Return 0 on success
int
dwarf_siblingof(Dwarf_Debug dbg, Dwarf_Die *die, Dwarf_Die *ret_die,
		Dwarf_CU *cu)
{
  8004209f7e:	55                   	push   %rbp
  8004209f7f:	48 89 e5             	mov    %rsp,%rbp
  8004209f82:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  8004209f86:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004209f8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8004209f8e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8004209f92:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	Dwarf_Attribute *at;
	uint64_t offset;
	int ret, search_sibling;

	assert(dbg);
  8004209f96:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004209f9b:	75 35                	jne    8004209fd2 <dwarf_siblingof+0x54>
  8004209f9d:	48 b9 38 fc 20 04 80 	movabs $0x800420fc38,%rcx
  8004209fa4:	00 00 00 
  8004209fa7:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209fae:	00 00 00 
  8004209fb1:	be ec 02 00 00       	mov    $0x2ec,%esi
  8004209fb6:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209fbd:	00 00 00 
  8004209fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004209fc5:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  8004209fcc:	00 00 00 
  8004209fcf:	41 ff d0             	callq  *%r8
	assert(ret_die);
  8004209fd2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8004209fd7:	75 35                	jne    800420a00e <dwarf_siblingof+0x90>
  8004209fd9:	48 b9 3c fc 20 04 80 	movabs $0x800420fc3c,%rcx
  8004209fe0:	00 00 00 
  8004209fe3:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  8004209fea:	00 00 00 
  8004209fed:	be ed 02 00 00       	mov    $0x2ed,%esi
  8004209ff2:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  8004209ff9:	00 00 00 
  8004209ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a001:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a008:	00 00 00 
  800420a00b:	41 ff d0             	callq  *%r8
	assert(cu);
  800420a00e:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  800420a013:	75 35                	jne    800420a04a <dwarf_siblingof+0xcc>
  800420a015:	48 b9 44 fc 20 04 80 	movabs $0x800420fc44,%rcx
  800420a01c:	00 00 00 
  800420a01f:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  800420a026:	00 00 00 
  800420a029:	be ee 02 00 00       	mov    $0x2ee,%esi
  800420a02e:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  800420a035:	00 00 00 
  800420a038:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a03d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a044:	00 00 00 
  800420a047:	41 ff d0             	callq  *%r8

	/* Application requests the first DIE in this CU. */
	if (die == NULL)
  800420a04a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420a04f:	75 65                	jne    800420a0b6 <dwarf_siblingof+0x138>
		return (dwarf_offdie(dbg, cu->cu_die_offset, ret_die, *cu));
  800420a051:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420a055:	48 8b 70 28          	mov    0x28(%rax),%rsi
  800420a059:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420a05d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420a061:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420a065:	48 8b 38             	mov    (%rax),%rdi
  800420a068:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420a06c:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800420a070:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  800420a075:	48 8b 78 10          	mov    0x10(%rax),%rdi
  800420a079:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420a07e:	48 8b 78 18          	mov    0x18(%rax),%rdi
  800420a082:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  800420a087:	48 8b 78 20          	mov    0x20(%rax),%rdi
  800420a08b:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  800420a090:	48 8b 78 28          	mov    0x28(%rax),%rdi
  800420a094:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  800420a099:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420a09d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  800420a0a2:	48 89 cf             	mov    %rcx,%rdi
  800420a0a5:	48 b8 e8 9d 20 04 80 	movabs $0x8004209de8,%rax
  800420a0ac:	00 00 00 
  800420a0af:	ff d0                	callq  *%rax
  800420a0b1:	e9 0a 01 00 00       	jmpq   800420a1c0 <dwarf_siblingof+0x242>

	/*
	 * If the DIE doesn't have any children, its sibling sits next
	 * right to it.
	 */
	search_sibling = 0;
  800420a0b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	if (die->die_ab.ab_children == DW_CHILDREN_no)
  800420a0bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a0c1:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  800420a0c5:	84 c0                	test   %al,%al
  800420a0c7:	75 0e                	jne    800420a0d7 <dwarf_siblingof+0x159>
		offset = die->die_next_off;
  800420a0c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a0cd:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420a0d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420a0d5:	eb 6b                	jmp    800420a142 <dwarf_siblingof+0x1c4>
	else {
		/*
		 * Look for DW_AT_sibling attribute for the offset of
		 * its sibling.
		 */
		if ((at = _dwarf_attr_find(die, DW_AT_sibling)) != NULL) {
  800420a0d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a0db:	be 01 00 00 00       	mov    $0x1,%esi
  800420a0e0:	48 89 c7             	mov    %rax,%rdi
  800420a0e3:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  800420a0ea:	00 00 00 
  800420a0ed:	ff d0                	callq  *%rax
  800420a0ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800420a0f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420a0f8:	74 35                	je     800420a12f <dwarf_siblingof+0x1b1>
			if (at->at_form != DW_FORM_ref_addr)
  800420a0fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a0fe:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420a102:	48 83 f8 10          	cmp    $0x10,%rax
  800420a106:	74 19                	je     800420a121 <dwarf_siblingof+0x1a3>
				offset = at->u[0].u64 + cu->cu_offset;
  800420a108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a10c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420a110:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420a114:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420a118:	48 01 d0             	add    %rdx,%rax
  800420a11b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420a11f:	eb 21                	jmp    800420a142 <dwarf_siblingof+0x1c4>
			else
				offset = at->u[0].u64;
  800420a121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a125:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420a129:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420a12d:	eb 13                	jmp    800420a142 <dwarf_siblingof+0x1c4>
		} else {
			offset = die->die_next_off;
  800420a12f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a133:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420a137:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			search_sibling = 1;
  800420a13b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
		}
	}

	ret = dwarf_search_die_within_cu(dbg, *cu, offset, ret_die, search_sibling);
  800420a142:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  800420a145:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420a149:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800420a14d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  800420a151:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420a155:	4c 8b 00             	mov    (%rax),%r8
  800420a158:	4c 89 04 24          	mov    %r8,(%rsp)
  800420a15c:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420a160:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  800420a165:	4c 8b 40 10          	mov    0x10(%rax),%r8
  800420a169:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  800420a16e:	4c 8b 40 18          	mov    0x18(%rax),%r8
  800420a172:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  800420a177:	4c 8b 40 20          	mov    0x20(%rax),%r8
  800420a17b:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  800420a180:	4c 8b 40 28          	mov    0x28(%rax),%r8
  800420a184:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  800420a189:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420a18d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  800420a192:	48 b8 ef 9a 20 04 80 	movabs $0x8004209aef,%rax
  800420a199:	00 00 00 
  800420a19c:	ff d0                	callq  *%rax
  800420a19e:	89 45 e4             	mov    %eax,-0x1c(%rbp)


	if (ret == DW_DLE_NO_ENTRY) {
  800420a1a1:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  800420a1a5:	75 07                	jne    800420a1ae <dwarf_siblingof+0x230>
		return (DW_DLV_NO_ENTRY);
  800420a1a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420a1ac:	eb 12                	jmp    800420a1c0 <dwarf_siblingof+0x242>
	} else if (ret != DW_DLE_NONE)
  800420a1ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800420a1b2:	74 07                	je     800420a1bb <dwarf_siblingof+0x23d>
		return (DW_DLV_ERROR);
  800420a1b4:	b8 01 00 00 00       	mov    $0x1,%eax
  800420a1b9:	eb 05                	jmp    800420a1c0 <dwarf_siblingof+0x242>


	return (DW_DLV_OK);
  800420a1bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420a1c0:	c9                   	leaveq 
  800420a1c1:	c3                   	retq   

000000800420a1c2 <dwarf_child>:

int
dwarf_child(Dwarf_Debug dbg, Dwarf_CU *cu, Dwarf_Die *die, Dwarf_Die *ret_die)
{
  800420a1c2:	55                   	push   %rbp
  800420a1c3:	48 89 e5             	mov    %rsp,%rbp
  800420a1c6:	48 83 ec 70          	sub    $0x70,%rsp
  800420a1ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420a1ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420a1d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420a1d6:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	int ret;

	assert(die);
  800420a1da:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800420a1df:	75 35                	jne    800420a216 <dwarf_child+0x54>
  800420a1e1:	48 b9 47 fc 20 04 80 	movabs $0x800420fc47,%rcx
  800420a1e8:	00 00 00 
  800420a1eb:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  800420a1f2:	00 00 00 
  800420a1f5:	be 1c 03 00 00       	mov    $0x31c,%esi
  800420a1fa:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  800420a201:	00 00 00 
  800420a204:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a209:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a210:	00 00 00 
  800420a213:	41 ff d0             	callq  *%r8
	assert(ret_die);
  800420a216:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420a21b:	75 35                	jne    800420a252 <dwarf_child+0x90>
  800420a21d:	48 b9 3c fc 20 04 80 	movabs $0x800420fc3c,%rcx
  800420a224:	00 00 00 
  800420a227:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  800420a22e:	00 00 00 
  800420a231:	be 1d 03 00 00       	mov    $0x31d,%esi
  800420a236:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  800420a23d:	00 00 00 
  800420a240:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a245:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a24c:	00 00 00 
  800420a24f:	41 ff d0             	callq  *%r8
	assert(dbg);
  800420a252:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420a257:	75 35                	jne    800420a28e <dwarf_child+0xcc>
  800420a259:	48 b9 38 fc 20 04 80 	movabs $0x800420fc38,%rcx
  800420a260:	00 00 00 
  800420a263:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  800420a26a:	00 00 00 
  800420a26d:	be 1e 03 00 00       	mov    $0x31e,%esi
  800420a272:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  800420a279:	00 00 00 
  800420a27c:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a281:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a288:	00 00 00 
  800420a28b:	41 ff d0             	callq  *%r8
	assert(cu);
  800420a28e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800420a293:	75 35                	jne    800420a2ca <dwarf_child+0x108>
  800420a295:	48 b9 44 fc 20 04 80 	movabs $0x800420fc44,%rcx
  800420a29c:	00 00 00 
  800420a29f:	48 ba aa fa 20 04 80 	movabs $0x800420faaa,%rdx
  800420a2a6:	00 00 00 
  800420a2a9:	be 1f 03 00 00       	mov    $0x31f,%esi
  800420a2ae:	48 bf bf fa 20 04 80 	movabs $0x800420fabf,%rdi
  800420a2b5:	00 00 00 
  800420a2b8:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a2bd:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a2c4:	00 00 00 
  800420a2c7:	41 ff d0             	callq  *%r8

	if (die->die_ab.ab_children == DW_CHILDREN_no)
  800420a2ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420a2ce:	0f b6 40 30          	movzbl 0x30(%rax),%eax
  800420a2d2:	84 c0                	test   %al,%al
  800420a2d4:	75 0a                	jne    800420a2e0 <dwarf_child+0x11e>
		return (DW_DLE_NO_ENTRY);
  800420a2d6:	b8 04 00 00 00       	mov    $0x4,%eax
  800420a2db:	e9 84 00 00 00       	jmpq   800420a364 <dwarf_child+0x1a2>

	ret = dwarf_search_die_within_cu(dbg, *cu, die->die_next_off, ret_die, 0);
  800420a2e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420a2e4:	48 8b 70 08          	mov    0x8(%rax),%rsi
  800420a2e8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420a2ec:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800420a2f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420a2f4:	48 8b 08             	mov    (%rax),%rcx
  800420a2f7:	48 89 0c 24          	mov    %rcx,(%rsp)
  800420a2fb:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420a2ff:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  800420a304:	48 8b 48 10          	mov    0x10(%rax),%rcx
  800420a308:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  800420a30d:	48 8b 48 18          	mov    0x18(%rax),%rcx
  800420a311:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  800420a316:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a31a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  800420a31f:	48 8b 48 28          	mov    0x28(%rax),%rcx
  800420a323:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  800420a328:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420a32c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  800420a331:	b9 00 00 00 00       	mov    $0x0,%ecx
  800420a336:	48 b8 ef 9a 20 04 80 	movabs $0x8004209aef,%rax
  800420a33d:	00 00 00 
  800420a340:	ff d0                	callq  *%rax
  800420a342:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (ret == DW_DLE_NO_ENTRY) {
  800420a345:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800420a349:	75 07                	jne    800420a352 <dwarf_child+0x190>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  800420a34b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420a350:	eb 12                	jmp    800420a364 <dwarf_child+0x1a2>
	} else if (ret != DW_DLE_NONE)
  800420a352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800420a356:	74 07                	je     800420a35f <dwarf_child+0x19d>
		return (DW_DLV_ERROR);
  800420a358:	b8 01 00 00 00       	mov    $0x1,%eax
  800420a35d:	eb 05                	jmp    800420a364 <dwarf_child+0x1a2>

	return (DW_DLV_OK);
  800420a35f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420a364:	c9                   	leaveq 
  800420a365:	c3                   	retq   

000000800420a366 <_dwarf_find_section_enhanced>:


int  _dwarf_find_section_enhanced(Dwarf_Section *ds)
{
  800420a366:	55                   	push   %rbp
  800420a367:	48 89 e5             	mov    %rsp,%rbp
  800420a36a:	48 83 ec 20          	sub    $0x20,%rsp
  800420a36e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *secthdr = _dwarf_find_section(ds->ds_name);
  800420a372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a376:	48 8b 00             	mov    (%rax),%rax
  800420a379:	48 89 c7             	mov    %rax,%rdi
  800420a37c:	48 b8 8d d6 20 04 80 	movabs $0x800420d68d,%rax
  800420a383:	00 00 00 
  800420a386:	ff d0                	callq  *%rax
  800420a388:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	ds->ds_data = secthdr->ds_data;//(Dwarf_Small*)((uint8_t *)elf_base_ptr + secthdr->sh_offset);
  800420a38c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a390:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420a394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a398:	48 89 50 08          	mov    %rdx,0x8(%rax)
	ds->ds_addr = secthdr->ds_addr;
  800420a39c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420a3a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a3a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	ds->ds_size = secthdr->ds_size;
  800420a3ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3b0:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420a3b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a3b8:	48 89 50 18          	mov    %rdx,0x18(%rax)
	return 0;
  800420a3bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420a3c1:	c9                   	leaveq 
  800420a3c2:	c3                   	retq   

000000800420a3c3 <_dwarf_frame_params_init>:

extern int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

void
_dwarf_frame_params_init(Dwarf_Debug dbg)
{
  800420a3c3:	55                   	push   %rbp
  800420a3c4:	48 89 e5             	mov    %rsp,%rbp
  800420a3c7:	48 83 ec 08          	sub    $0x8,%rsp
  800420a3cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	/* Initialise call frame related parameters. */
	dbg->dbg_frame_rule_table_size = DW_FRAME_LAST_REG_NUM;
  800420a3cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3d3:	66 c7 40 48 42 00    	movw   $0x42,0x48(%rax)
	dbg->dbg_frame_rule_initial_value = DW_FRAME_REG_INITIAL_VALUE;
  800420a3d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3dd:	66 c7 40 4a 0b 04    	movw   $0x40b,0x4a(%rax)
	dbg->dbg_frame_cfa_value = DW_FRAME_CFA_COL3;
  800420a3e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3e7:	66 c7 40 4c 9c 05    	movw   $0x59c,0x4c(%rax)
	dbg->dbg_frame_same_value = DW_FRAME_SAME_VAL;
  800420a3ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3f1:	66 c7 40 4e 0b 04    	movw   $0x40b,0x4e(%rax)
	dbg->dbg_frame_undefined_value = DW_FRAME_UNDEFINED_VAL;
  800420a3f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a3fb:	66 c7 40 50 0a 04    	movw   $0x40a,0x50(%rax)
}
  800420a401:	c9                   	leaveq 
  800420a402:	c3                   	retq   

000000800420a403 <dwarf_get_fde_at_pc>:

int
dwarf_get_fde_at_pc(Dwarf_Debug dbg, Dwarf_Addr pc,
		    struct _Dwarf_Fde *ret_fde, Dwarf_Cie cie,
		    Dwarf_Error *error)
{
  800420a403:	55                   	push   %rbp
  800420a404:	48 89 e5             	mov    %rsp,%rbp
  800420a407:	48 83 ec 40          	sub    $0x40,%rsp
  800420a40b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420a40f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420a413:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420a417:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  800420a41b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	Dwarf_Fde fde = ret_fde;
  800420a41f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420a423:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memset(fde, 0, sizeof(struct _Dwarf_Fde));
  800420a427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a42b:	ba 80 00 00 00       	mov    $0x80,%edx
  800420a430:	be 00 00 00 00       	mov    $0x0,%esi
  800420a435:	48 89 c7             	mov    %rax,%rdi
  800420a438:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420a43f:	00 00 00 
  800420a442:	ff d0                	callq  *%rax
	fde->fde_cie = cie;
  800420a444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a448:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420a44c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if (ret_fde == NULL)
  800420a450:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800420a455:	75 07                	jne    800420a45e <dwarf_get_fde_at_pc+0x5b>
		return (DW_DLV_ERROR);
  800420a457:	b8 01 00 00 00       	mov    $0x1,%eax
  800420a45c:	eb 75                	jmp    800420a4d3 <dwarf_get_fde_at_pc+0xd0>

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  800420a45e:	eb 59                	jmp    800420a4b9 <dwarf_get_fde_at_pc+0xb6>
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
  800420a460:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800420a464:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420a468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a46c:	be 01 00 00 00       	mov    $0x1,%esi
  800420a471:	48 89 c7             	mov    %rax,%rdi
  800420a474:	48 b8 18 c6 20 04 80 	movabs $0x800420c618,%rax
  800420a47b:	00 00 00 
  800420a47e:	ff d0                	callq  *%rax
  800420a480:	85 c0                	test   %eax,%eax
  800420a482:	79 07                	jns    800420a48b <dwarf_get_fde_at_pc+0x88>
		{
			return DW_DLV_NO_ENTRY;
  800420a484:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420a489:	eb 48                	jmp    800420a4d3 <dwarf_get_fde_at_pc+0xd0>
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  800420a48b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a48f:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420a493:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800420a497:	77 20                	ja     800420a4b9 <dwarf_get_fde_at_pc+0xb6>
  800420a499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a49d:	48 8b 50 30          	mov    0x30(%rax),%rdx
		    fde->fde_adrange)
  800420a4a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420a4a5:	48 8b 40 38          	mov    0x38(%rax),%rax
	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
		if (_dwarf_get_next_fde(dbg, true, error, fde) < 0)
		{
			return DW_DLV_NO_ENTRY;
		}
		if (pc >= fde->fde_initloc && pc < fde->fde_initloc +
  800420a4a9:	48 01 d0             	add    %rdx,%rax
  800420a4ac:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800420a4b0:	76 07                	jbe    800420a4b9 <dwarf_get_fde_at_pc+0xb6>
		    fde->fde_adrange)
			return (DW_DLV_OK);
  800420a4b2:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a4b7:	eb 1a                	jmp    800420a4d3 <dwarf_get_fde_at_pc+0xd0>
	fde->fde_cie = cie;
	
	if (ret_fde == NULL)
		return (DW_DLV_ERROR);

	while(dbg->curr_off_eh < dbg->dbg_eh_size) {
  800420a4b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a4bd:	48 8b 50 30          	mov    0x30(%rax),%rdx
  800420a4c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420a4c5:	48 8b 40 40          	mov    0x40(%rax),%rax
  800420a4c9:	48 39 c2             	cmp    %rax,%rdx
  800420a4cc:	72 92                	jb     800420a460 <dwarf_get_fde_at_pc+0x5d>
		    fde->fde_adrange)
			return (DW_DLV_OK);
	}

	DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
	return (DW_DLV_NO_ENTRY);
  800420a4ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  800420a4d3:	c9                   	leaveq 
  800420a4d4:	c3                   	retq   

000000800420a4d5 <_dwarf_frame_regtable_copy>:

int
_dwarf_frame_regtable_copy(Dwarf_Debug dbg, Dwarf_Regtable3 **dest,
			   Dwarf_Regtable3 *src, Dwarf_Error *error)
{
  800420a4d5:	55                   	push   %rbp
  800420a4d6:	48 89 e5             	mov    %rsp,%rbp
  800420a4d9:	53                   	push   %rbx
  800420a4da:	48 83 ec 38          	sub    $0x38,%rsp
  800420a4de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800420a4e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420a4e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800420a4ea:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
	int i;

	assert(dest != NULL);
  800420a4ee:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420a4f3:	75 35                	jne    800420a52a <_dwarf_frame_regtable_copy+0x55>
  800420a4f5:	48 b9 5a fc 20 04 80 	movabs $0x800420fc5a,%rcx
  800420a4fc:	00 00 00 
  800420a4ff:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420a506:	00 00 00 
  800420a509:	be 57 00 00 00       	mov    $0x57,%esi
  800420a50e:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420a515:	00 00 00 
  800420a518:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a51d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a524:	00 00 00 
  800420a527:	41 ff d0             	callq  *%r8
	assert(src != NULL);
  800420a52a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420a52f:	75 35                	jne    800420a566 <_dwarf_frame_regtable_copy+0x91>
  800420a531:	48 b9 92 fc 20 04 80 	movabs $0x800420fc92,%rcx
  800420a538:	00 00 00 
  800420a53b:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420a542:	00 00 00 
  800420a545:	be 58 00 00 00       	mov    $0x58,%esi
  800420a54a:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420a551:	00 00 00 
  800420a554:	b8 00 00 00 00       	mov    $0x0,%eax
  800420a559:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420a560:	00 00 00 
  800420a563:	41 ff d0             	callq  *%r8

	if (*dest == NULL) {
  800420a566:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a56a:	48 8b 00             	mov    (%rax),%rax
  800420a56d:	48 85 c0             	test   %rax,%rax
  800420a570:	75 39                	jne    800420a5ab <_dwarf_frame_regtable_copy+0xd6>
		*dest = &global_rt_table_shadow;
  800420a572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a576:	48 bb 40 2d 22 04 80 	movabs $0x8004222d40,%rbx
  800420a57d:	00 00 00 
  800420a580:	48 89 18             	mov    %rbx,(%rax)
		(*dest)->rt3_reg_table_size = src->rt3_reg_table_size;
  800420a583:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a587:	48 8b 00             	mov    (%rax),%rax
  800420a58a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420a58e:	0f b7 52 18          	movzwl 0x18(%rdx),%edx
  800420a592:	66 89 50 18          	mov    %dx,0x18(%rax)
		(*dest)->rt3_rules = global_rules_shadow;
  800420a596:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a59a:	48 8b 00             	mov    (%rax),%rax
  800420a59d:	48 bb 00 2f 22 04 80 	movabs $0x8004222f00,%rbx
  800420a5a4:	00 00 00 
  800420a5a7:	48 89 58 20          	mov    %rbx,0x20(%rax)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
  800420a5ab:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420a5af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a5b3:	48 8b 00             	mov    (%rax),%rax
  800420a5b6:	ba 18 00 00 00       	mov    $0x18,%edx
  800420a5bb:	48 89 ce             	mov    %rcx,%rsi
  800420a5be:	48 89 c7             	mov    %rax,%rdi
  800420a5c1:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  800420a5c8:	00 00 00 
  800420a5cb:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420a5cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  800420a5d4:	eb 5a                	jmp    800420a630 <_dwarf_frame_regtable_copy+0x15b>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
  800420a5d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420a5da:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a5de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420a5e1:	48 63 d0             	movslq %eax,%rdx
  800420a5e4:	48 89 d0             	mov    %rdx,%rax
  800420a5e7:	48 01 c0             	add    %rax,%rax
  800420a5ea:	48 01 d0             	add    %rdx,%rax
  800420a5ed:	48 c1 e0 03          	shl    $0x3,%rax
  800420a5f1:	48 01 c1             	add    %rax,%rcx
  800420a5f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a5f8:	48 8b 00             	mov    (%rax),%rax
  800420a5fb:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420a5ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420a602:	48 63 d0             	movslq %eax,%rdx
  800420a605:	48 89 d0             	mov    %rdx,%rax
  800420a608:	48 01 c0             	add    %rax,%rax
  800420a60b:	48 01 d0             	add    %rdx,%rax
  800420a60e:	48 c1 e0 03          	shl    $0x3,%rax
  800420a612:	48 01 f0             	add    %rsi,%rax
  800420a615:	ba 18 00 00 00       	mov    $0x18,%edx
  800420a61a:	48 89 ce             	mov    %rcx,%rsi
  800420a61d:	48 89 c7             	mov    %rax,%rdi
  800420a620:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  800420a627:	00 00 00 
  800420a62a:	ff d0                	callq  *%rax

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
  800420a62c:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420a630:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a634:	48 8b 00             	mov    (%rax),%rax
  800420a637:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420a63b:	0f b7 c0             	movzwl %ax,%eax
  800420a63e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800420a641:	7e 10                	jle    800420a653 <_dwarf_frame_regtable_copy+0x17e>
		     i < src->rt3_reg_table_size; i++)
  800420a643:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420a647:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420a64b:	0f b7 c0             	movzwl %ax,%eax
	}

	memcpy(&(*dest)->rt3_cfa_rule, &src->rt3_cfa_rule,
	       sizeof(Dwarf_Regtable_Entry3));

	for (i = 0; i < (*dest)->rt3_reg_table_size &&
  800420a64e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800420a651:	7f 83                	jg     800420a5d6 <_dwarf_frame_regtable_copy+0x101>
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  800420a653:	eb 32                	jmp    800420a687 <_dwarf_frame_regtable_copy+0x1b2>
		(*dest)->rt3_rules[i].dw_regnum =
  800420a655:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a659:	48 8b 00             	mov    (%rax),%rax
  800420a65c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a660:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800420a663:	48 63 d0             	movslq %eax,%rdx
  800420a666:	48 89 d0             	mov    %rdx,%rax
  800420a669:	48 01 c0             	add    %rax,%rax
  800420a66c:	48 01 d0             	add    %rdx,%rax
  800420a66f:	48 c1 e0 03          	shl    $0x3,%rax
  800420a673:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
			dbg->dbg_frame_undefined_value;
  800420a677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420a67b:	0f b7 40 50          	movzwl 0x50(%rax),%eax
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
		(*dest)->rt3_rules[i].dw_regnum =
  800420a67f:	66 89 42 02          	mov    %ax,0x2(%rdx)
	for (i = 0; i < (*dest)->rt3_reg_table_size &&
		     i < src->rt3_reg_table_size; i++)
		memcpy(&(*dest)->rt3_rules[i], &src->rt3_rules[i],
		       sizeof(Dwarf_Regtable_Entry3));

	for (; i < (*dest)->rt3_reg_table_size; i++)
  800420a683:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800420a687:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420a68b:	48 8b 00             	mov    (%rax),%rax
  800420a68e:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420a692:	0f b7 c0             	movzwl %ax,%eax
  800420a695:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800420a698:	7f bb                	jg     800420a655 <_dwarf_frame_regtable_copy+0x180>
		(*dest)->rt3_rules[i].dw_regnum =
			dbg->dbg_frame_undefined_value;

	return (DW_DLE_NONE);
  800420a69a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420a69f:	48 83 c4 38          	add    $0x38,%rsp
  800420a6a3:	5b                   	pop    %rbx
  800420a6a4:	5d                   	pop    %rbp
  800420a6a5:	c3                   	retq   

000000800420a6a6 <_dwarf_frame_run_inst>:

static int
_dwarf_frame_run_inst(Dwarf_Debug dbg, Dwarf_Regtable3 *rt, uint8_t *insts,
		      Dwarf_Unsigned len, Dwarf_Unsigned caf, Dwarf_Signed daf, Dwarf_Addr pc,
		      Dwarf_Addr pc_req, Dwarf_Addr *row_pc, Dwarf_Error *error)
{
  800420a6a6:	55                   	push   %rbp
  800420a6a7:	48 89 e5             	mov    %rsp,%rbp
  800420a6aa:	53                   	push   %rbx
  800420a6ab:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  800420a6b2:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  800420a6b6:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  800420a6ba:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
  800420a6be:	48 89 4d 80          	mov    %rcx,-0x80(%rbp)
  800420a6c2:	4c 89 85 78 ff ff ff 	mov    %r8,-0x88(%rbp)
  800420a6c9:	4c 89 8d 70 ff ff ff 	mov    %r9,-0x90(%rbp)
			ret = DW_DLE_DF_REG_NUM_TOO_HIGH;               \
			goto program_done;                              \
		}                                                       \
	} while(0)

	ret = DW_DLE_NONE;
  800420a6d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	init_rt = saved_rt = NULL;
  800420a6d7:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  800420a6de:	00 
  800420a6df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420a6e3:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	*row_pc = pc;
  800420a6e7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420a6eb:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420a6ef:	48 89 10             	mov    %rdx,(%rax)

	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
  800420a6f2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800420a6f6:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  800420a6fa:	48 8d 75 b0          	lea    -0x50(%rbp),%rsi
  800420a6fe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a702:	48 89 c7             	mov    %rax,%rdi
  800420a705:	48 b8 d5 a4 20 04 80 	movabs $0x800420a4d5,%rax
  800420a70c:	00 00 00 
  800420a70f:	ff d0                	callq  *%rax
	p = insts;
  800420a711:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420a715:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	pe = p + len;
  800420a719:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420a71d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420a721:	48 01 d0             	add    %rdx,%rax
  800420a724:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	while (p < pe) {
  800420a728:	e9 3a 0d 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		if (*p == DW_CFA_nop) {
  800420a72d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420a731:	0f b6 00             	movzbl (%rax),%eax
  800420a734:	84 c0                	test   %al,%al
  800420a736:	75 11                	jne    800420a749 <_dwarf_frame_run_inst+0xa3>
			p++;
  800420a738:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420a73c:	48 83 c0 01          	add    $0x1,%rax
  800420a740:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			continue;
  800420a744:	e9 1e 0d 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		}

		high2 = *p & 0xc0;
  800420a749:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420a74d:	0f b6 00             	movzbl (%rax),%eax
  800420a750:	83 e0 c0             	and    $0xffffffc0,%eax
  800420a753:	88 45 df             	mov    %al,-0x21(%rbp)
		low6 = *p & 0x3f;
  800420a756:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420a75a:	0f b6 00             	movzbl (%rax),%eax
  800420a75d:	83 e0 3f             	and    $0x3f,%eax
  800420a760:	88 45 de             	mov    %al,-0x22(%rbp)
		p++;
  800420a763:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420a767:	48 83 c0 01          	add    $0x1,%rax
  800420a76b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)

		if (high2 > 0) {
  800420a76f:	80 7d df 00          	cmpb   $0x0,-0x21(%rbp)
  800420a773:	0f 84 a1 01 00 00    	je     800420a91a <_dwarf_frame_run_inst+0x274>
			switch (high2) {
  800420a779:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800420a77d:	3d 80 00 00 00       	cmp    $0x80,%eax
  800420a782:	74 38                	je     800420a7bc <_dwarf_frame_run_inst+0x116>
  800420a784:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800420a789:	0f 84 01 01 00 00    	je     800420a890 <_dwarf_frame_run_inst+0x1ea>
  800420a78f:	83 f8 40             	cmp    $0x40,%eax
  800420a792:	0f 85 71 01 00 00    	jne    800420a909 <_dwarf_frame_run_inst+0x263>
			case DW_CFA_advance_loc:
			        pc += low6 * caf;
  800420a798:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  800420a79c:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  800420a7a3:	ff 
  800420a7a4:	48 01 45 10          	add    %rax,0x10(%rbp)
			        if (pc_req < pc)
  800420a7a8:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420a7ac:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420a7b0:	73 05                	jae    800420a7b7 <_dwarf_frame_run_inst+0x111>
			                goto program_done;
  800420a7b2:	e9 be 0c 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			        break;
  800420a7b7:	e9 59 01 00 00       	jmpq   800420a915 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_offset:
			        *row_pc = pc;
  800420a7bc:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420a7c0:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420a7c4:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  800420a7c7:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a7cb:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a7cf:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420a7d3:	66 39 c2             	cmp    %ax,%dx
  800420a7d6:	72 0c                	jb     800420a7e4 <_dwarf_frame_run_inst+0x13e>
  800420a7d8:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420a7df:	e9 91 0c 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			        RL[low6].dw_offset_relevant = 1;
  800420a7e4:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a7e8:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a7ec:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a7f0:	48 89 d0             	mov    %rdx,%rax
  800420a7f3:	48 01 c0             	add    %rax,%rax
  800420a7f6:	48 01 d0             	add    %rdx,%rax
  800420a7f9:	48 c1 e0 03          	shl    $0x3,%rax
  800420a7fd:	48 01 c8             	add    %rcx,%rax
  800420a800:	c6 00 01             	movb   $0x1,(%rax)
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
  800420a803:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a807:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a80b:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a80f:	48 89 d0             	mov    %rdx,%rax
  800420a812:	48 01 c0             	add    %rax,%rax
  800420a815:	48 01 d0             	add    %rdx,%rax
  800420a818:	48 c1 e0 03          	shl    $0x3,%rax
  800420a81c:	48 01 c8             	add    %rcx,%rax
  800420a81f:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
  800420a823:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a827:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a82b:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a82f:	48 89 d0             	mov    %rdx,%rax
  800420a832:	48 01 c0             	add    %rax,%rax
  800420a835:	48 01 d0             	add    %rdx,%rax
  800420a838:	48 c1 e0 03          	shl    $0x3,%rax
  800420a83c:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420a840:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a844:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420a848:	66 89 42 02          	mov    %ax,0x2(%rdx)
			        RL[low6].dw_offset_or_block_len =
  800420a84c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a850:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a854:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a858:	48 89 d0             	mov    %rdx,%rax
  800420a85b:	48 01 c0             	add    %rax,%rax
  800420a85e:	48 01 d0             	add    %rdx,%rax
  800420a861:	48 c1 e0 03          	shl    $0x3,%rax
  800420a865:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
					_dwarf_decode_uleb128(&p) * daf;
  800420a869:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420a86d:	48 89 c7             	mov    %rax,%rdi
  800420a870:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420a877:	00 00 00 
  800420a87a:	ff d0                	callq  *%rax
  800420a87c:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  800420a883:	48 0f af c2          	imul   %rdx,%rax
			        *row_pc = pc;
			        CHECK_TABLE_SIZE(low6);
			        RL[low6].dw_offset_relevant = 1;
			        RL[low6].dw_value_type = DW_EXPR_OFFSET;
			        RL[low6].dw_regnum = dbg->dbg_frame_cfa_value;
			        RL[low6].dw_offset_or_block_len =
  800420a887:	48 89 43 08          	mov    %rax,0x8(%rbx)
					_dwarf_decode_uleb128(&p) * daf;
			        break;
  800420a88b:	e9 85 00 00 00       	jmpq   800420a915 <_dwarf_frame_run_inst+0x26f>
			case DW_CFA_restore:
			        *row_pc = pc;
  800420a890:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420a894:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420a898:	48 89 10             	mov    %rdx,(%rax)
			        CHECK_TABLE_SIZE(low6);
  800420a89b:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a89f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a8a3:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420a8a7:	66 39 c2             	cmp    %ax,%dx
  800420a8aa:	72 0c                	jb     800420a8b8 <_dwarf_frame_run_inst+0x212>
  800420a8ac:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420a8b3:	e9 bd 0b 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			        memcpy(&RL[low6], &INITRL[low6],
  800420a8b8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420a8bc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420a8c0:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a8c4:	48 89 d0             	mov    %rdx,%rax
  800420a8c7:	48 01 c0             	add    %rax,%rax
  800420a8ca:	48 01 d0             	add    %rdx,%rax
  800420a8cd:	48 c1 e0 03          	shl    $0x3,%rax
  800420a8d1:	48 01 c1             	add    %rax,%rcx
  800420a8d4:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420a8d8:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420a8dc:	0f b6 55 de          	movzbl -0x22(%rbp),%edx
  800420a8e0:	48 89 d0             	mov    %rdx,%rax
  800420a8e3:	48 01 c0             	add    %rax,%rax
  800420a8e6:	48 01 d0             	add    %rdx,%rax
  800420a8e9:	48 c1 e0 03          	shl    $0x3,%rax
  800420a8ed:	48 01 f0             	add    %rsi,%rax
  800420a8f0:	ba 18 00 00 00       	mov    $0x18,%edx
  800420a8f5:	48 89 ce             	mov    %rcx,%rsi
  800420a8f8:	48 89 c7             	mov    %rax,%rdi
  800420a8fb:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  800420a902:	00 00 00 
  800420a905:	ff d0                	callq  *%rax
				       sizeof(Dwarf_Regtable_Entry3));
			        break;
  800420a907:	eb 0c                	jmp    800420a915 <_dwarf_frame_run_inst+0x26f>
			default:
			        DWARF_SET_ERROR(dbg, error,
						DW_DLE_FRAME_INSTR_EXEC_ERROR);
			        ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  800420a909:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			        goto program_done;
  800420a910:	e9 60 0b 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			}

			continue;
  800420a915:	e9 4d 0b 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		}

		switch (low6) {
  800420a91a:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  800420a91e:	83 f8 16             	cmp    $0x16,%eax
  800420a921:	0f 87 37 0b 00 00    	ja     800420b45e <_dwarf_frame_run_inst+0xdb8>
  800420a927:	89 c0                	mov    %eax,%eax
  800420a929:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420a930:	00 
  800420a931:	48 b8 a0 fc 20 04 80 	movabs $0x800420fca0,%rax
  800420a938:	00 00 00 
  800420a93b:	48 01 d0             	add    %rdx,%rax
  800420a93e:	48 8b 00             	mov    (%rax),%rax
  800420a941:	ff e0                	jmpq   *%rax
		case DW_CFA_set_loc:
			pc = dbg->decode(&p, dbg->dbg_pointer_size);
  800420a943:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a947:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420a94b:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  800420a94f:	8b 4a 28             	mov    0x28(%rdx),%ecx
  800420a952:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  800420a956:	89 ce                	mov    %ecx,%esi
  800420a958:	48 89 d7             	mov    %rdx,%rdi
  800420a95b:	ff d0                	callq  *%rax
  800420a95d:	48 89 45 10          	mov    %rax,0x10(%rbp)
			if (pc_req < pc)
  800420a961:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420a965:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420a969:	73 05                	jae    800420a970 <_dwarf_frame_run_inst+0x2ca>
			        goto program_done;
  800420a96b:	e9 05 0b 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			break;
  800420a970:	e9 f2 0a 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc1:
			pc += dbg->decode(&p, 1) * caf;
  800420a975:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a979:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420a97d:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  800420a981:	be 01 00 00 00       	mov    $0x1,%esi
  800420a986:	48 89 d7             	mov    %rdx,%rdi
  800420a989:	ff d0                	callq  *%rax
  800420a98b:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  800420a992:	ff 
  800420a993:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  800420a997:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420a99b:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420a99f:	73 05                	jae    800420a9a6 <_dwarf_frame_run_inst+0x300>
			        goto program_done;
  800420a9a1:	e9 cf 0a 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			break;
  800420a9a6:	e9 bc 0a 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc2:
			pc += dbg->decode(&p, 2) * caf;
  800420a9ab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a9af:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420a9b3:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  800420a9b7:	be 02 00 00 00       	mov    $0x2,%esi
  800420a9bc:	48 89 d7             	mov    %rdx,%rdi
  800420a9bf:	ff d0                	callq  *%rax
  800420a9c1:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  800420a9c8:	ff 
  800420a9c9:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  800420a9cd:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420a9d1:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420a9d5:	73 05                	jae    800420a9dc <_dwarf_frame_run_inst+0x336>
			        goto program_done;
  800420a9d7:	e9 99 0a 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			break;
  800420a9dc:	e9 86 0a 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_advance_loc4:
			pc += dbg->decode(&p, 4) * caf;
  800420a9e1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420a9e5:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420a9e9:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
  800420a9ed:	be 04 00 00 00       	mov    $0x4,%esi
  800420a9f2:	48 89 d7             	mov    %rdx,%rdi
  800420a9f5:	ff d0                	callq  *%rax
  800420a9f7:	48 0f af 85 78 ff ff 	imul   -0x88(%rbp),%rax
  800420a9fe:	ff 
  800420a9ff:	48 01 45 10          	add    %rax,0x10(%rbp)
			if (pc_req < pc)
  800420aa03:	48 8b 45 18          	mov    0x18(%rbp),%rax
  800420aa07:	48 3b 45 10          	cmp    0x10(%rbp),%rax
  800420aa0b:	73 05                	jae    800420aa12 <_dwarf_frame_run_inst+0x36c>
			        goto program_done;
  800420aa0d:	e9 63 0a 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			break;
  800420aa12:	e9 50 0a 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended:
			*row_pc = pc;
  800420aa17:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420aa1b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420aa1f:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420aa22:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420aa26:	48 89 c7             	mov    %rax,%rdi
  800420aa29:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420aa30:	00 00 00 
  800420aa33:	ff d0                	callq  *%rax
  800420aa35:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  800420aa39:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420aa3d:	48 89 c7             	mov    %rax,%rdi
  800420aa40:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420aa47:	00 00 00 
  800420aa4a:	ff d0                	callq  *%rax
  800420aa4c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420aa50:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aa54:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420aa58:	0f b7 c0             	movzwl %ax,%eax
  800420aa5b:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420aa5f:	77 0c                	ja     800420aa6d <_dwarf_frame_run_inst+0x3c7>
  800420aa61:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420aa68:	e9 08 0a 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  800420aa6d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aa71:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420aa75:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420aa79:	48 89 d0             	mov    %rdx,%rax
  800420aa7c:	48 01 c0             	add    %rax,%rax
  800420aa7f:	48 01 d0             	add    %rdx,%rax
  800420aa82:	48 c1 e0 03          	shl    $0x3,%rax
  800420aa86:	48 01 c8             	add    %rcx,%rax
  800420aa89:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  800420aa8c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aa90:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420aa94:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420aa98:	48 89 d0             	mov    %rdx,%rax
  800420aa9b:	48 01 c0             	add    %rax,%rax
  800420aa9e:	48 01 d0             	add    %rdx,%rax
  800420aaa1:	48 c1 e0 03          	shl    $0x3,%rax
  800420aaa5:	48 01 c8             	add    %rcx,%rax
  800420aaa8:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420aaac:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aab0:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420aab4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420aab8:	48 89 d0             	mov    %rdx,%rax
  800420aabb:	48 01 c0             	add    %rax,%rax
  800420aabe:	48 01 d0             	add    %rdx,%rax
  800420aac1:	48 c1 e0 03          	shl    $0x3,%rax
  800420aac5:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420aac9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420aacd:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420aad1:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  800420aad5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aad9:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420aadd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420aae1:	48 89 d0             	mov    %rdx,%rax
  800420aae4:	48 01 c0             	add    %rax,%rax
  800420aae7:	48 01 d0             	add    %rdx,%rax
  800420aaea:	48 c1 e0 03          	shl    $0x3,%rax
  800420aaee:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420aaf2:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420aaf9:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  800420aafe:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  800420ab02:	e9 60 09 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_extended:
			*row_pc = pc;
  800420ab07:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ab0b:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ab0f:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420ab12:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ab16:	48 89 c7             	mov    %rax,%rdi
  800420ab19:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ab20:	00 00 00 
  800420ab23:	ff d0                	callq  *%rax
  800420ab25:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420ab29:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ab2d:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420ab31:	0f b7 c0             	movzwl %ax,%eax
  800420ab34:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420ab38:	77 0c                	ja     800420ab46 <_dwarf_frame_run_inst+0x4a0>
  800420ab3a:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420ab41:	e9 2f 09 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			memcpy(&RL[reg], &INITRL[reg],
  800420ab46:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420ab4a:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ab4e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ab52:	48 89 d0             	mov    %rdx,%rax
  800420ab55:	48 01 c0             	add    %rax,%rax
  800420ab58:	48 01 d0             	add    %rdx,%rax
  800420ab5b:	48 c1 e0 03          	shl    $0x3,%rax
  800420ab5f:	48 01 c1             	add    %rax,%rcx
  800420ab62:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ab66:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420ab6a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ab6e:	48 89 d0             	mov    %rdx,%rax
  800420ab71:	48 01 c0             	add    %rax,%rax
  800420ab74:	48 01 d0             	add    %rdx,%rax
  800420ab77:	48 c1 e0 03          	shl    $0x3,%rax
  800420ab7b:	48 01 f0             	add    %rsi,%rax
  800420ab7e:	ba 18 00 00 00       	mov    $0x18,%edx
  800420ab83:	48 89 ce             	mov    %rcx,%rsi
  800420ab86:	48 89 c7             	mov    %rax,%rdi
  800420ab89:	48 b8 58 81 20 04 80 	movabs $0x8004208158,%rax
  800420ab90:	00 00 00 
  800420ab93:	ff d0                	callq  *%rax
			       sizeof(Dwarf_Regtable_Entry3));
			break;
  800420ab95:	e9 cd 08 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_undefined:
			*row_pc = pc;
  800420ab9a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ab9e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420aba2:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420aba5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420aba9:	48 89 c7             	mov    %rax,%rdi
  800420abac:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420abb3:	00 00 00 
  800420abb6:	ff d0                	callq  *%rax
  800420abb8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420abbc:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420abc0:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420abc4:	0f b7 c0             	movzwl %ax,%eax
  800420abc7:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420abcb:	77 0c                	ja     800420abd9 <_dwarf_frame_run_inst+0x533>
  800420abcd:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420abd4:	e9 9c 08 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  800420abd9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420abdd:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420abe1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420abe5:	48 89 d0             	mov    %rdx,%rax
  800420abe8:	48 01 c0             	add    %rax,%rax
  800420abeb:	48 01 d0             	add    %rdx,%rax
  800420abee:	48 c1 e0 03          	shl    $0x3,%rax
  800420abf2:	48 01 c8             	add    %rcx,%rax
  800420abf5:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_undefined_value;
  800420abf8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420abfc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ac00:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ac04:	48 89 d0             	mov    %rdx,%rax
  800420ac07:	48 01 c0             	add    %rax,%rax
  800420ac0a:	48 01 d0             	add    %rdx,%rax
  800420ac0d:	48 c1 e0 03          	shl    $0x3,%rax
  800420ac11:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420ac15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420ac19:	0f b7 40 50          	movzwl 0x50(%rax),%eax
  800420ac1d:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  800420ac21:	e9 41 08 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_same_value:
			reg = _dwarf_decode_uleb128(&p);
  800420ac26:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ac2a:	48 89 c7             	mov    %rax,%rdi
  800420ac2d:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ac34:	00 00 00 
  800420ac37:	ff d0                	callq  *%rax
  800420ac39:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420ac3d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ac41:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420ac45:	0f b7 c0             	movzwl %ax,%eax
  800420ac48:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420ac4c:	77 0c                	ja     800420ac5a <_dwarf_frame_run_inst+0x5b4>
  800420ac4e:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420ac55:	e9 1b 08 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  800420ac5a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ac5e:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ac62:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ac66:	48 89 d0             	mov    %rdx,%rax
  800420ac69:	48 01 c0             	add    %rax,%rax
  800420ac6c:	48 01 d0             	add    %rdx,%rax
  800420ac6f:	48 c1 e0 03          	shl    $0x3,%rax
  800420ac73:	48 01 c8             	add    %rcx,%rax
  800420ac76:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_same_value;
  800420ac79:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ac7d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ac81:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ac85:	48 89 d0             	mov    %rdx,%rax
  800420ac88:	48 01 c0             	add    %rax,%rax
  800420ac8b:	48 01 d0             	add    %rdx,%rax
  800420ac8e:	48 c1 e0 03          	shl    $0x3,%rax
  800420ac92:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420ac96:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420ac9a:	0f b7 40 4e          	movzwl 0x4e(%rax),%eax
  800420ac9e:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  800420aca2:	e9 c0 07 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_register:
			*row_pc = pc;
  800420aca7:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420acab:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420acaf:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420acb2:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420acb6:	48 89 c7             	mov    %rax,%rdi
  800420acb9:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420acc0:	00 00 00 
  800420acc3:	ff d0                	callq  *%rax
  800420acc5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			reg2 = _dwarf_decode_uleb128(&p);
  800420acc9:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420accd:	48 89 c7             	mov    %rax,%rdi
  800420acd0:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420acd7:	00 00 00 
  800420acda:	ff d0                	callq  *%rax
  800420acdc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420ace0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ace4:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420ace8:	0f b7 c0             	movzwl %ax,%eax
  800420aceb:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420acef:	77 0c                	ja     800420acfd <_dwarf_frame_run_inst+0x657>
  800420acf1:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420acf8:	e9 78 07 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  800420acfd:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ad01:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ad05:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ad09:	48 89 d0             	mov    %rdx,%rax
  800420ad0c:	48 01 c0             	add    %rax,%rax
  800420ad0f:	48 01 d0             	add    %rdx,%rax
  800420ad12:	48 c1 e0 03          	shl    $0x3,%rax
  800420ad16:	48 01 c8             	add    %rcx,%rax
  800420ad19:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_regnum = reg2;
  800420ad1c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ad20:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420ad24:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ad28:	48 89 d0             	mov    %rdx,%rax
  800420ad2b:	48 01 c0             	add    %rax,%rax
  800420ad2e:	48 01 d0             	add    %rdx,%rax
  800420ad31:	48 c1 e0 03          	shl    $0x3,%rax
  800420ad35:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420ad39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420ad3d:	66 89 42 02          	mov    %ax,0x2(%rdx)
			break;
  800420ad41:	e9 21 07 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_remember_state:
			_dwarf_frame_regtable_copy(dbg, &saved_rt, rt, error);
  800420ad46:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800420ad4a:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  800420ad4e:	48 8d 75 a8          	lea    -0x58(%rbp),%rsi
  800420ad52:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420ad56:	48 89 c7             	mov    %rax,%rdi
  800420ad59:	48 b8 d5 a4 20 04 80 	movabs $0x800420a4d5,%rax
  800420ad60:	00 00 00 
  800420ad63:	ff d0                	callq  *%rax
			break;
  800420ad65:	e9 fd 06 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_restore_state:
			*row_pc = pc;
  800420ad6a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ad6e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ad72:	48 89 10             	mov    %rdx,(%rax)
			_dwarf_frame_regtable_copy(dbg, &rt, saved_rt, error);
  800420ad75:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800420ad79:	48 8b 4d 28          	mov    0x28(%rbp),%rcx
  800420ad7d:	48 8d 75 90          	lea    -0x70(%rbp),%rsi
  800420ad81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420ad85:	48 89 c7             	mov    %rax,%rdi
  800420ad88:	48 b8 d5 a4 20 04 80 	movabs $0x800420a4d5,%rax
  800420ad8f:	00 00 00 
  800420ad92:	ff d0                	callq  *%rax
			break;
  800420ad94:	e9 ce 06 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa:
			*row_pc = pc;
  800420ad99:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ad9d:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ada1:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420ada4:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ada8:	48 89 c7             	mov    %rax,%rdi
  800420adab:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420adb2:	00 00 00 
  800420adb5:	ff d0                	callq  *%rax
  800420adb7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  800420adbb:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420adbf:	48 89 c7             	mov    %rax,%rdi
  800420adc2:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420adc9:	00 00 00 
  800420adcc:	ff d0                	callq  *%rax
  800420adce:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  800420add2:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420add6:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  800420add9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420addd:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  800420ade1:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ade5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ade9:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = uoff;
  800420aded:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420adf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420adf5:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  800420adf9:	e9 69 06 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_register:
			*row_pc = pc;
  800420adfe:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ae02:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ae06:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420ae09:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ae0d:	48 89 c7             	mov    %rax,%rdi
  800420ae10:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ae17:	00 00 00 
  800420ae1a:	ff d0                	callq  *%rax
  800420ae1c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CFA.dw_regnum = reg;
  800420ae20:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae24:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ae28:	66 89 50 02          	mov    %dx,0x2(%rax)
			 * Note that DW_CFA_def_cfa_register change the CFA
			 * rule register while keep the old offset. So we
			 * should not touch the CFA.dw_offset_relevant flag
			 * here.
			 */
			break;
  800420ae2c:	e9 36 06 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset:
			*row_pc = pc;
  800420ae31:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ae35:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ae39:	48 89 10             	mov    %rdx,(%rax)
			uoff = _dwarf_decode_uleb128(&p);
  800420ae3c:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ae40:	48 89 c7             	mov    %rax,%rdi
  800420ae43:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ae4a:	00 00 00 
  800420ae4d:	ff d0                	callq  *%rax
  800420ae4f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CFA.dw_offset_relevant = 1;
  800420ae53:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae57:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  800420ae5a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae5e:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = uoff;
  800420ae62:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae66:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420ae6a:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  800420ae6e:	e9 f4 05 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_expression:
			*row_pc = pc;
  800420ae73:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420ae77:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420ae7b:	48 89 10             	mov    %rdx,(%rax)
			CFA.dw_offset_relevant = 0;
  800420ae7e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae82:	c6 00 00             	movb   $0x0,(%rax)
			CFA.dw_value_type = DW_EXPR_EXPRESSION;
  800420ae85:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420ae89:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			CFA.dw_offset_or_block_len = _dwarf_decode_uleb128(&p);
  800420ae8d:	48 8b 5d 90          	mov    -0x70(%rbp),%rbx
  800420ae91:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420ae95:	48 89 c7             	mov    %rax,%rdi
  800420ae98:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ae9f:	00 00 00 
  800420aea2:	ff d0                	callq  *%rax
  800420aea4:	48 89 43 08          	mov    %rax,0x8(%rbx)
			CFA.dw_block_ptr = p;
  800420aea8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aeac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420aeb0:	48 89 50 10          	mov    %rdx,0x10(%rax)
			p += CFA.dw_offset_or_block_len;
  800420aeb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800420aeb8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aebc:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420aec0:	48 01 d0             	add    %rdx,%rax
  800420aec3:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  800420aec7:	e9 9b 05 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_expression:
			*row_pc = pc;
  800420aecc:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420aed0:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420aed4:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420aed7:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420aedb:	48 89 c7             	mov    %rax,%rdi
  800420aede:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420aee5:	00 00 00 
  800420aee8:	ff d0                	callq  *%rax
  800420aeea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420aeee:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420aef2:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420aef6:	0f b7 c0             	movzwl %ax,%eax
  800420aef9:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420aefd:	77 0c                	ja     800420af0b <_dwarf_frame_run_inst+0x865>
  800420aeff:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420af06:	e9 6a 05 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  800420af0b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420af0f:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420af13:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420af17:	48 89 d0             	mov    %rdx,%rax
  800420af1a:	48 01 c0             	add    %rax,%rax
  800420af1d:	48 01 d0             	add    %rdx,%rax
  800420af20:	48 c1 e0 03          	shl    $0x3,%rax
  800420af24:	48 01 c8             	add    %rcx,%rax
  800420af27:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
  800420af2a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420af2e:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420af32:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420af36:	48 89 d0             	mov    %rdx,%rax
  800420af39:	48 01 c0             	add    %rax,%rax
  800420af3c:	48 01 d0             	add    %rdx,%rax
  800420af3f:	48 c1 e0 03          	shl    $0x3,%rax
  800420af43:	48 01 c8             	add    %rcx,%rax
  800420af46:	c6 40 01 02          	movb   $0x2,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  800420af4a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420af4e:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420af52:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420af56:	48 89 d0             	mov    %rdx,%rax
  800420af59:	48 01 c0             	add    %rax,%rax
  800420af5c:	48 01 d0             	add    %rdx,%rax
  800420af5f:	48 c1 e0 03          	shl    $0x3,%rax
  800420af63:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  800420af67:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420af6b:	48 89 c7             	mov    %rax,%rdi
  800420af6e:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420af75:	00 00 00 
  800420af78:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  800420af7a:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  800420af7e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420af82:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420af86:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420af8a:	48 89 d0             	mov    %rdx,%rax
  800420af8d:	48 01 c0             	add    %rax,%rax
  800420af90:	48 01 d0             	add    %rdx,%rax
  800420af93:	48 c1 e0 03          	shl    $0x3,%rax
  800420af97:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420af9b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420af9f:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  800420afa3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800420afa7:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420afab:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420afaf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420afb3:	48 89 d0             	mov    %rdx,%rax
  800420afb6:	48 01 c0             	add    %rax,%rax
  800420afb9:	48 01 d0             	add    %rdx,%rax
  800420afbc:	48 c1 e0 03          	shl    $0x3,%rax
  800420afc0:	48 01 f0             	add    %rsi,%rax
  800420afc3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420afc7:	48 01 c8             	add    %rcx,%rax
  800420afca:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  800420afce:	e9 94 04 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_offset_extended_sf:
			*row_pc = pc;
  800420afd3:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420afd7:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420afdb:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420afde:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420afe2:	48 89 c7             	mov    %rax,%rdi
  800420afe5:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420afec:	00 00 00 
  800420afef:	ff d0                	callq  *%rax
  800420aff1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  800420aff5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420aff9:	48 89 c7             	mov    %rax,%rdi
  800420affc:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  800420b003:	00 00 00 
  800420b006:	ff d0                	callq  *%rax
  800420b008:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420b00c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b010:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b014:	0f b7 c0             	movzwl %ax,%eax
  800420b017:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420b01b:	77 0c                	ja     800420b029 <_dwarf_frame_run_inst+0x983>
  800420b01d:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420b024:	e9 4c 04 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  800420b029:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b02d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b031:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b035:	48 89 d0             	mov    %rdx,%rax
  800420b038:	48 01 c0             	add    %rax,%rax
  800420b03b:	48 01 d0             	add    %rdx,%rax
  800420b03e:	48 c1 e0 03          	shl    $0x3,%rax
  800420b042:	48 01 c8             	add    %rcx,%rax
  800420b045:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_OFFSET;
  800420b048:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b04c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b050:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b054:	48 89 d0             	mov    %rdx,%rax
  800420b057:	48 01 c0             	add    %rax,%rax
  800420b05a:	48 01 d0             	add    %rdx,%rax
  800420b05d:	48 c1 e0 03          	shl    $0x3,%rax
  800420b061:	48 01 c8             	add    %rcx,%rax
  800420b064:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420b068:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b06c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b070:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b074:	48 89 d0             	mov    %rdx,%rax
  800420b077:	48 01 c0             	add    %rax,%rax
  800420b07a:	48 01 d0             	add    %rdx,%rax
  800420b07d:	48 c1 e0 03          	shl    $0x3,%rax
  800420b081:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b085:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420b089:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420b08d:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  800420b091:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b095:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b099:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b09d:	48 89 d0             	mov    %rdx,%rax
  800420b0a0:	48 01 c0             	add    %rax,%rax
  800420b0a3:	48 01 d0             	add    %rdx,%rax
  800420b0a6:	48 c1 e0 03          	shl    $0x3,%rax
  800420b0aa:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b0ae:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420b0b5:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  800420b0ba:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  800420b0be:	e9 a4 03 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_sf:
			*row_pc = pc;
  800420b0c3:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420b0c7:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420b0cb:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420b0ce:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b0d2:	48 89 c7             	mov    %rax,%rdi
  800420b0d5:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b0dc:	00 00 00 
  800420b0df:	ff d0                	callq  *%rax
  800420b0e1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  800420b0e5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b0e9:	48 89 c7             	mov    %rax,%rdi
  800420b0ec:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  800420b0f3:	00 00 00 
  800420b0f6:	ff d0                	callq  *%rax
  800420b0f8:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  800420b0fc:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b100:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  800420b103:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b107:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_regnum = reg;
  800420b10b:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b10f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b113:	66 89 50 02          	mov    %dx,0x2(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  800420b117:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b11b:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  800420b122:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  800420b127:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  800420b12b:	e9 37 03 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_def_cfa_offset_sf:
			*row_pc = pc;
  800420b130:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420b134:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420b138:	48 89 10             	mov    %rdx,(%rax)
			soff = _dwarf_decode_sleb128(&p);
  800420b13b:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b13f:	48 89 c7             	mov    %rax,%rdi
  800420b142:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  800420b149:	00 00 00 
  800420b14c:	ff d0                	callq  *%rax
  800420b14e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CFA.dw_offset_relevant = 1;
  800420b152:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b156:	c6 00 01             	movb   $0x1,(%rax)
			CFA.dw_value_type = DW_EXPR_OFFSET;
  800420b159:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b15d:	c6 40 01 00          	movb   $0x0,0x1(%rax)
			CFA.dw_offset_or_block_len = soff * daf;
  800420b161:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b165:	48 8b 95 70 ff ff ff 	mov    -0x90(%rbp),%rdx
  800420b16c:	48 0f af 55 b8       	imul   -0x48(%rbp),%rdx
  800420b171:	48 89 50 08          	mov    %rdx,0x8(%rax)
			break;
  800420b175:	e9 ed 02 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset:
			*row_pc = pc;
  800420b17a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420b17e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420b182:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420b185:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b189:	48 89 c7             	mov    %rax,%rdi
  800420b18c:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b193:	00 00 00 
  800420b196:	ff d0                	callq  *%rax
  800420b198:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			uoff = _dwarf_decode_uleb128(&p);
  800420b19c:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b1a0:	48 89 c7             	mov    %rax,%rdi
  800420b1a3:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b1aa:	00 00 00 
  800420b1ad:	ff d0                	callq  *%rax
  800420b1af:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420b1b3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b1b7:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b1bb:	0f b7 c0             	movzwl %ax,%eax
  800420b1be:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420b1c2:	77 0c                	ja     800420b1d0 <_dwarf_frame_run_inst+0xb2a>
  800420b1c4:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420b1cb:	e9 a5 02 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  800420b1d0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b1d4:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b1d8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b1dc:	48 89 d0             	mov    %rdx,%rax
  800420b1df:	48 01 c0             	add    %rax,%rax
  800420b1e2:	48 01 d0             	add    %rdx,%rax
  800420b1e5:	48 c1 e0 03          	shl    $0x3,%rax
  800420b1e9:	48 01 c8             	add    %rcx,%rax
  800420b1ec:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420b1ef:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b1f3:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b1f7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b1fb:	48 89 d0             	mov    %rdx,%rax
  800420b1fe:	48 01 c0             	add    %rax,%rax
  800420b201:	48 01 d0             	add    %rdx,%rax
  800420b204:	48 c1 e0 03          	shl    $0x3,%rax
  800420b208:	48 01 c8             	add    %rcx,%rax
  800420b20b:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420b20f:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b213:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b217:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b21b:	48 89 d0             	mov    %rdx,%rax
  800420b21e:	48 01 c0             	add    %rax,%rax
  800420b221:	48 01 d0             	add    %rdx,%rax
  800420b224:	48 c1 e0 03          	shl    $0x3,%rax
  800420b228:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b22c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420b230:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420b234:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = uoff * daf;
  800420b238:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b23c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b240:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b244:	48 89 d0             	mov    %rdx,%rax
  800420b247:	48 01 c0             	add    %rax,%rax
  800420b24a:	48 01 d0             	add    %rdx,%rax
  800420b24d:	48 c1 e0 03          	shl    $0x3,%rax
  800420b251:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b255:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420b25c:	48 0f af 45 c8       	imul   -0x38(%rbp),%rax
  800420b261:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  800420b265:	e9 fd 01 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_offset_sf:
			*row_pc = pc;
  800420b26a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420b26e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420b272:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420b275:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b279:	48 89 c7             	mov    %rax,%rdi
  800420b27c:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b283:	00 00 00 
  800420b286:	ff d0                	callq  *%rax
  800420b288:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			soff = _dwarf_decode_sleb128(&p);
  800420b28c:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b290:	48 89 c7             	mov    %rax,%rdi
  800420b293:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  800420b29a:	00 00 00 
  800420b29d:	ff d0                	callq  *%rax
  800420b29f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420b2a3:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b2a7:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b2ab:	0f b7 c0             	movzwl %ax,%eax
  800420b2ae:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420b2b2:	77 0c                	ja     800420b2c0 <_dwarf_frame_run_inst+0xc1a>
  800420b2b4:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420b2bb:	e9 b5 01 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 1;
  800420b2c0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b2c4:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b2c8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b2cc:	48 89 d0             	mov    %rdx,%rax
  800420b2cf:	48 01 c0             	add    %rax,%rax
  800420b2d2:	48 01 d0             	add    %rdx,%rax
  800420b2d5:	48 c1 e0 03          	shl    $0x3,%rax
  800420b2d9:	48 01 c8             	add    %rcx,%rax
  800420b2dc:	c6 00 01             	movb   $0x1,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_OFFSET;
  800420b2df:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b2e3:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b2e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b2eb:	48 89 d0             	mov    %rdx,%rax
  800420b2ee:	48 01 c0             	add    %rax,%rax
  800420b2f1:	48 01 d0             	add    %rdx,%rax
  800420b2f4:	48 c1 e0 03          	shl    $0x3,%rax
  800420b2f8:	48 01 c8             	add    %rcx,%rax
  800420b2fb:	c6 40 01 01          	movb   $0x1,0x1(%rax)
			RL[reg].dw_regnum = dbg->dbg_frame_cfa_value;
  800420b2ff:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b303:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b307:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b30b:	48 89 d0             	mov    %rdx,%rax
  800420b30e:	48 01 c0             	add    %rax,%rax
  800420b311:	48 01 d0             	add    %rdx,%rax
  800420b314:	48 c1 e0 03          	shl    $0x3,%rax
  800420b318:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b31c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420b320:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420b324:	66 89 42 02          	mov    %ax,0x2(%rdx)
			RL[reg].dw_offset_or_block_len = soff * daf;
  800420b328:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b32c:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b330:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b334:	48 89 d0             	mov    %rdx,%rax
  800420b337:	48 01 c0             	add    %rax,%rax
  800420b33a:	48 01 d0             	add    %rdx,%rax
  800420b33d:	48 c1 e0 03          	shl    $0x3,%rax
  800420b341:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b345:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420b34c:	48 0f af 45 b8       	imul   -0x48(%rbp),%rax
  800420b351:	48 89 42 08          	mov    %rax,0x8(%rdx)
			break;
  800420b355:	e9 0d 01 00 00       	jmpq   800420b467 <_dwarf_frame_run_inst+0xdc1>
		case DW_CFA_val_expression:
			*row_pc = pc;
  800420b35a:	48 8b 45 20          	mov    0x20(%rbp),%rax
  800420b35e:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  800420b362:	48 89 10             	mov    %rdx,(%rax)
			reg = _dwarf_decode_uleb128(&p);
  800420b365:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b369:	48 89 c7             	mov    %rax,%rdi
  800420b36c:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b373:	00 00 00 
  800420b376:	ff d0                	callq  *%rax
  800420b378:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
			CHECK_TABLE_SIZE(reg);
  800420b37c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b380:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b384:	0f b7 c0             	movzwl %ax,%eax
  800420b387:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
  800420b38b:	77 0c                	ja     800420b399 <_dwarf_frame_run_inst+0xcf3>
  800420b38d:	c7 45 ec 18 00 00 00 	movl   $0x18,-0x14(%rbp)
  800420b394:	e9 dc 00 00 00       	jmpq   800420b475 <_dwarf_frame_run_inst+0xdcf>
			RL[reg].dw_offset_relevant = 0;
  800420b399:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b39d:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b3a1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b3a5:	48 89 d0             	mov    %rdx,%rax
  800420b3a8:	48 01 c0             	add    %rax,%rax
  800420b3ab:	48 01 d0             	add    %rdx,%rax
  800420b3ae:	48 c1 e0 03          	shl    $0x3,%rax
  800420b3b2:	48 01 c8             	add    %rcx,%rax
  800420b3b5:	c6 00 00             	movb   $0x0,(%rax)
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
  800420b3b8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b3bc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b3c0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b3c4:	48 89 d0             	mov    %rdx,%rax
  800420b3c7:	48 01 c0             	add    %rax,%rax
  800420b3ca:	48 01 d0             	add    %rdx,%rax
  800420b3cd:	48 c1 e0 03          	shl    $0x3,%rax
  800420b3d1:	48 01 c8             	add    %rcx,%rax
  800420b3d4:	c6 40 01 03          	movb   $0x3,0x1(%rax)
			RL[reg].dw_offset_or_block_len =
  800420b3d8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b3dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b3e0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b3e4:	48 89 d0             	mov    %rdx,%rax
  800420b3e7:	48 01 c0             	add    %rax,%rax
  800420b3ea:	48 01 d0             	add    %rdx,%rax
  800420b3ed:	48 c1 e0 03          	shl    $0x3,%rax
  800420b3f1:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
				_dwarf_decode_uleb128(&p);
  800420b3f5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  800420b3f9:	48 89 c7             	mov    %rax,%rdi
  800420b3fc:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420b403:	00 00 00 
  800420b406:	ff d0                	callq  *%rax
			*row_pc = pc;
			reg = _dwarf_decode_uleb128(&p);
			CHECK_TABLE_SIZE(reg);
			RL[reg].dw_offset_relevant = 0;
			RL[reg].dw_value_type = DW_EXPR_VAL_EXPRESSION;
			RL[reg].dw_offset_or_block_len =
  800420b408:	48 89 43 08          	mov    %rax,0x8(%rbx)
				_dwarf_decode_uleb128(&p);
			RL[reg].dw_block_ptr = p;
  800420b40c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b410:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b414:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b418:	48 89 d0             	mov    %rdx,%rax
  800420b41b:	48 01 c0             	add    %rax,%rax
  800420b41e:	48 01 d0             	add    %rdx,%rax
  800420b421:	48 c1 e0 03          	shl    $0x3,%rax
  800420b425:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b429:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420b42d:	48 89 42 10          	mov    %rax,0x10(%rdx)
			p += RL[reg].dw_offset_or_block_len;
  800420b431:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800420b435:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420b439:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420b43d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420b441:	48 89 d0             	mov    %rdx,%rax
  800420b444:	48 01 c0             	add    %rax,%rax
  800420b447:	48 01 d0             	add    %rdx,%rax
  800420b44a:	48 c1 e0 03          	shl    $0x3,%rax
  800420b44e:	48 01 f0             	add    %rsi,%rax
  800420b451:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420b455:	48 01 c8             	add    %rcx,%rax
  800420b458:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
			break;
  800420b45c:	eb 09                	jmp    800420b467 <_dwarf_frame_run_inst+0xdc1>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_INSTR_EXEC_ERROR);
			ret = DW_DLE_FRAME_INSTR_EXEC_ERROR;
  800420b45e:	c7 45 ec 15 00 00 00 	movl   $0x15,-0x14(%rbp)
			goto program_done;
  800420b465:	eb 0e                	jmp    800420b475 <_dwarf_frame_run_inst+0xdcf>
	/* Save a copy of the table as initial state. */
	_dwarf_frame_regtable_copy(dbg, &init_rt, rt, error);
	p = insts;
	pe = p + len;

	while (p < pe) {
  800420b467:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420b46b:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800420b46f:	0f 82 b8 f2 ff ff    	jb     800420a72d <_dwarf_frame_run_inst+0x87>
			goto program_done;
		}
	}

program_done:
	return (ret);
  800420b475:	8b 45 ec             	mov    -0x14(%rbp),%eax
#undef  CFA
#undef  INITCFA
#undef  RL
#undef  INITRL
#undef  CHECK_TABLE_SIZE
}
  800420b478:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  800420b47f:	5b                   	pop    %rbx
  800420b480:	5d                   	pop    %rbp
  800420b481:	c3                   	retq   

000000800420b482 <_dwarf_frame_get_internal_table>:
int
_dwarf_frame_get_internal_table(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_req, Dwarf_Regtable3 **ret_rt,
				Dwarf_Addr *ret_row_pc,
				Dwarf_Error *error)
{
  800420b482:	55                   	push   %rbp
  800420b483:	48 89 e5             	mov    %rsp,%rbp
  800420b486:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  800420b48a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420b48e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420b492:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800420b496:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  800420b49a:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
  800420b49e:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Cie cie;
	Dwarf_Regtable3 *rt;
	Dwarf_Addr row_pc;
	int i, ret;

	assert(ret_rt != NULL);
  800420b4a2:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  800420b4a7:	75 35                	jne    800420b4de <_dwarf_frame_get_internal_table+0x5c>
  800420b4a9:	48 b9 58 fd 20 04 80 	movabs $0x800420fd58,%rcx
  800420b4b0:	00 00 00 
  800420b4b3:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420b4ba:	00 00 00 
  800420b4bd:	be 83 01 00 00       	mov    $0x183,%esi
  800420b4c2:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420b4c9:	00 00 00 
  800420b4cc:	b8 00 00 00 00       	mov    $0x0,%eax
  800420b4d1:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420b4d8:	00 00 00 
  800420b4db:	41 ff d0             	callq  *%r8

	//dbg = fde->fde_dbg;
	assert(dbg != NULL);
  800420b4de:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420b4e3:	75 35                	jne    800420b51a <_dwarf_frame_get_internal_table+0x98>
  800420b4e5:	48 b9 67 fd 20 04 80 	movabs $0x800420fd67,%rcx
  800420b4ec:	00 00 00 
  800420b4ef:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420b4f6:	00 00 00 
  800420b4f9:	be 86 01 00 00       	mov    $0x186,%esi
  800420b4fe:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420b505:	00 00 00 
  800420b508:	b8 00 00 00 00       	mov    $0x0,%eax
  800420b50d:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420b514:	00 00 00 
  800420b517:	41 ff d0             	callq  *%r8

	rt = dbg->dbg_internal_reg_table;
  800420b51a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420b51e:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420b522:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	/* Clear the content of regtable from previous run. */
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
  800420b526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420b52a:	ba 18 00 00 00       	mov    $0x18,%edx
  800420b52f:	be 00 00 00 00       	mov    $0x0,%esi
  800420b534:	48 89 c7             	mov    %rax,%rdi
  800420b537:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420b53e:	00 00 00 
  800420b541:	ff d0                	callq  *%rax
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
  800420b543:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420b547:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b54b:	0f b7 d0             	movzwl %ax,%edx
  800420b54e:	48 89 d0             	mov    %rdx,%rax
  800420b551:	48 01 c0             	add    %rax,%rax
  800420b554:	48 01 d0             	add    %rdx,%rax
  800420b557:	48 c1 e0 03          	shl    $0x3,%rax
  800420b55b:	48 89 c2             	mov    %rax,%rdx
  800420b55e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420b562:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420b566:	be 00 00 00 00       	mov    $0x0,%esi
  800420b56b:	48 89 c7             	mov    %rax,%rdi
  800420b56e:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420b575:	00 00 00 
  800420b578:	ff d0                	callq  *%rax
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  800420b57a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800420b581:	eb 2f                	jmp    800420b5b2 <_dwarf_frame_get_internal_table+0x130>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;
  800420b583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420b587:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b58b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420b58e:	48 63 d0             	movslq %eax,%rdx
  800420b591:	48 89 d0             	mov    %rdx,%rax
  800420b594:	48 01 c0             	add    %rax,%rax
  800420b597:	48 01 d0             	add    %rdx,%rax
  800420b59a:	48 c1 e0 03          	shl    $0x3,%rax
  800420b59e:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
  800420b5a2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420b5a6:	0f b7 40 4a          	movzwl 0x4a(%rax),%eax
  800420b5aa:	66 89 42 02          	mov    %ax,0x2(%rdx)
	memset(&rt->rt3_cfa_rule, 0, sizeof(Dwarf_Regtable_Entry3));
	memset(rt->rt3_rules, 0, rt->rt3_reg_table_size *
	       sizeof(Dwarf_Regtable_Entry3));

	/* Set rules to initial values. */
	for (i = 0; i < rt->rt3_reg_table_size; i++)
  800420b5ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800420b5b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420b5b6:	0f b7 40 18          	movzwl 0x18(%rax),%eax
  800420b5ba:	0f b7 c0             	movzwl %ax,%eax
  800420b5bd:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800420b5c0:	7f c1                	jg     800420b583 <_dwarf_frame_get_internal_table+0x101>
		rt->rt3_rules[i].dw_regnum = dbg->dbg_frame_rule_initial_value;

	/* Run initial instructions in CIE. */
	cie = fde->fde_cie;
  800420b5c2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b5c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420b5ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	assert(cie != NULL);
  800420b5ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800420b5d3:	75 35                	jne    800420b60a <_dwarf_frame_get_internal_table+0x188>
  800420b5d5:	48 b9 73 fd 20 04 80 	movabs $0x800420fd73,%rcx
  800420b5dc:	00 00 00 
  800420b5df:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420b5e6:	00 00 00 
  800420b5e9:	be 95 01 00 00       	mov    $0x195,%esi
  800420b5ee:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420b5f5:	00 00 00 
  800420b5f8:	b8 00 00 00 00       	mov    $0x0,%eax
  800420b5fd:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420b604:	00 00 00 
  800420b607:	41 ff d0             	callq  *%r8
	ret = _dwarf_frame_run_inst(dbg, rt, cie->cie_initinst,
  800420b60a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b60e:	4c 8b 48 40          	mov    0x40(%rax),%r9
  800420b612:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b616:	4c 8b 40 38          	mov    0x38(%rax),%r8
  800420b61a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b61e:	48 8b 48 70          	mov    0x70(%rax),%rcx
  800420b622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b626:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800420b62a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800420b62e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420b632:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800420b636:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  800420b63b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  800420b63f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  800420b644:	48 c7 44 24 08 ff ff 	movq   $0xffffffffffffffff,0x8(%rsp)
  800420b64b:	ff ff 
  800420b64d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800420b654:	00 
  800420b655:	48 89 c7             	mov    %rax,%rdi
  800420b658:	48 b8 a6 a6 20 04 80 	movabs $0x800420a6a6,%rax
  800420b65f:	00 00 00 
  800420b662:	ff d0                	callq  *%rax
  800420b664:	89 45 e4             	mov    %eax,-0x1c(%rbp)
				    cie->cie_instlen, cie->cie_caf,
				    cie->cie_daf, 0, ~0ULL,
				    &row_pc, error);
	if (ret != DW_DLE_NONE)
  800420b667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800420b66b:	74 08                	je     800420b675 <_dwarf_frame_get_internal_table+0x1f3>
		return (ret);
  800420b66d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420b670:	e9 98 00 00 00       	jmpq   800420b70d <_dwarf_frame_get_internal_table+0x28b>
	/* Run instructions in FDE. */
	if (pc_req >= fde->fde_initloc) {
  800420b675:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b679:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420b67d:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
  800420b681:	77 6f                	ja     800420b6f2 <_dwarf_frame_get_internal_table+0x270>
		ret = _dwarf_frame_run_inst(dbg, rt, fde->fde_inst,
  800420b683:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b687:	48 8b 78 30          	mov    0x30(%rax),%rdi
  800420b68b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b68f:	4c 8b 48 40          	mov    0x40(%rax),%r9
  800420b693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b697:	4c 8b 50 38          	mov    0x38(%rax),%r10
  800420b69b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b69f:	48 8b 48 58          	mov    0x58(%rax),%rcx
  800420b6a3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b6a7:	48 8b 50 50          	mov    0x50(%rax),%rdx
  800420b6ab:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800420b6af:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420b6b3:	4c 8b 45 a0          	mov    -0x60(%rbp),%r8
  800420b6b7:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  800420b6bc:	4c 8d 45 d8          	lea    -0x28(%rbp),%r8
  800420b6c0:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  800420b6c5:	4c 8b 45 b8          	mov    -0x48(%rbp),%r8
  800420b6c9:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  800420b6ce:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420b6d2:	4d 89 d0             	mov    %r10,%r8
  800420b6d5:	48 89 c7             	mov    %rax,%rdi
  800420b6d8:	48 b8 a6 a6 20 04 80 	movabs $0x800420a6a6,%rax
  800420b6df:	00 00 00 
  800420b6e2:	ff d0                	callq  *%rax
  800420b6e4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
					    fde->fde_instlen, cie->cie_caf,
					    cie->cie_daf,
					    fde->fde_initloc, pc_req,
					    &row_pc, error);
		if (ret != DW_DLE_NONE)
  800420b6e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800420b6eb:	74 05                	je     800420b6f2 <_dwarf_frame_get_internal_table+0x270>
			return (ret);
  800420b6ed:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800420b6f0:	eb 1b                	jmp    800420b70d <_dwarf_frame_get_internal_table+0x28b>
	}

	*ret_rt = rt;
  800420b6f2:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420b6f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420b6fa:	48 89 10             	mov    %rdx,(%rax)
	*ret_row_pc = row_pc;
  800420b6fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420b701:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420b705:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  800420b708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420b70d:	c9                   	leaveq 
  800420b70e:	c3                   	retq   

000000800420b70f <dwarf_get_fde_info_for_all_regs>:
int
dwarf_get_fde_info_for_all_regs(Dwarf_Debug dbg, Dwarf_Fde fde,
				Dwarf_Addr pc_requested,
				Dwarf_Regtable *reg_table, Dwarf_Addr *row_pc,
				Dwarf_Error *error)
{
  800420b70f:	55                   	push   %rbp
  800420b710:	48 89 e5             	mov    %rsp,%rbp
  800420b713:	48 83 ec 50          	sub    $0x50,%rsp
  800420b717:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800420b71b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420b71f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800420b723:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  800420b727:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
  800420b72b:	4c 89 4d b0          	mov    %r9,-0x50(%rbp)
	Dwarf_Regtable3 *rt;
	Dwarf_Addr pc;
	Dwarf_Half cfa;
	int i, ret;

	if (fde == NULL || reg_table == NULL) {
  800420b72f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800420b734:	74 07                	je     800420b73d <dwarf_get_fde_info_for_all_regs+0x2e>
  800420b736:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  800420b73b:	75 0a                	jne    800420b747 <dwarf_get_fde_info_for_all_regs+0x38>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  800420b73d:	b8 01 00 00 00       	mov    $0x1,%eax
  800420b742:	e9 eb 02 00 00       	jmpq   800420ba32 <dwarf_get_fde_info_for_all_regs+0x323>
	}

	assert(dbg != NULL);
  800420b747:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800420b74c:	75 35                	jne    800420b783 <dwarf_get_fde_info_for_all_regs+0x74>
  800420b74e:	48 b9 67 fd 20 04 80 	movabs $0x800420fd67,%rcx
  800420b755:	00 00 00 
  800420b758:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420b75f:	00 00 00 
  800420b762:	be bf 01 00 00       	mov    $0x1bf,%esi
  800420b767:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420b76e:	00 00 00 
  800420b771:	b8 00 00 00 00       	mov    $0x0,%eax
  800420b776:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420b77d:	00 00 00 
  800420b780:	41 ff d0             	callq  *%r8

	if (pc_requested < fde->fde_initloc ||
  800420b783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420b787:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420b78b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  800420b78f:	77 19                	ja     800420b7aa <dwarf_get_fde_info_for_all_regs+0x9b>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
  800420b791:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420b795:	48 8b 50 30          	mov    0x30(%rax),%rdx
  800420b799:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420b79d:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420b7a1:	48 01 d0             	add    %rdx,%rax
		return (DW_DLV_ERROR);
	}

	assert(dbg != NULL);

	if (pc_requested < fde->fde_initloc ||
  800420b7a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  800420b7a8:	77 0a                	ja     800420b7b4 <dwarf_get_fde_info_for_all_regs+0xa5>
	    pc_requested >= fde->fde_initloc + fde->fde_adrange) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_PC_NOT_IN_FDE_RANGE);
		return (DW_DLV_ERROR);
  800420b7aa:	b8 01 00 00 00       	mov    $0x1,%eax
  800420b7af:	e9 7e 02 00 00       	jmpq   800420ba32 <dwarf_get_fde_info_for_all_regs+0x323>
	}

	ret = _dwarf_frame_get_internal_table(dbg, fde, pc_requested, &rt, &pc,
  800420b7b4:	4c 8b 45 b0          	mov    -0x50(%rbp),%r8
  800420b7b8:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  800420b7bc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800420b7c0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420b7c4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420b7c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420b7cc:	4d 89 c1             	mov    %r8,%r9
  800420b7cf:	49 89 f8             	mov    %rdi,%r8
  800420b7d2:	48 89 c7             	mov    %rax,%rdi
  800420b7d5:	48 b8 82 b4 20 04 80 	movabs $0x800420b482,%rax
  800420b7dc:	00 00 00 
  800420b7df:	ff d0                	callq  *%rax
  800420b7e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
					      error);
	if (ret != DW_DLE_NONE)
  800420b7e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800420b7e8:	74 0a                	je     800420b7f4 <dwarf_get_fde_info_for_all_regs+0xe5>
		return (DW_DLV_ERROR);
  800420b7ea:	b8 01 00 00 00       	mov    $0x1,%eax
  800420b7ef:	e9 3e 02 00 00       	jmpq   800420ba32 <dwarf_get_fde_info_for_all_regs+0x323>
	/*
	 * Copy the CFA rule to the column intended for holding the CFA,
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
  800420b7f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420b7f8:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420b7fc:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
	if (cfa < DW_REG_TABLE_SIZE) {
  800420b800:	66 83 7d f6 41       	cmpw   $0x41,-0xa(%rbp)
  800420b805:	0f 87 b1 00 00 00    	ja     800420b8bc <dwarf_get_fde_info_for_all_regs+0x1ad>
		reg_table->rules[cfa].dw_offset_relevant =
  800420b80b:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
			CFA.dw_offset_relevant;
  800420b80f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b813:	0f b6 00             	movzbl (%rax),%eax
	 * if it's within the range of regtable.
	 */
#define CFA rt->rt3_cfa_rule
	cfa = dbg->dbg_frame_cfa_value;
	if (cfa < DW_REG_TABLE_SIZE) {
		reg_table->rules[cfa].dw_offset_relevant =
  800420b816:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b81a:	48 63 c9             	movslq %ecx,%rcx
  800420b81d:	48 83 c1 01          	add    $0x1,%rcx
  800420b821:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b825:	48 01 ca             	add    %rcx,%rdx
  800420b828:	88 02                	mov    %al,(%rdx)
			CFA.dw_offset_relevant;
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
  800420b82a:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  800420b82e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b832:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  800420b836:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b83a:	48 63 c9             	movslq %ecx,%rcx
  800420b83d:	48 83 c1 01          	add    $0x1,%rcx
  800420b841:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b845:	48 01 ca             	add    %rcx,%rdx
  800420b848:	88 42 01             	mov    %al,0x1(%rdx)
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
  800420b84b:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  800420b84f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b853:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  800420b857:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b85b:	48 63 c9             	movslq %ecx,%rcx
  800420b85e:	48 83 c1 01          	add    $0x1,%rcx
  800420b862:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b866:	48 01 ca             	add    %rcx,%rdx
  800420b869:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
  800420b86d:	0f b7 4d f6          	movzwl -0xa(%rbp),%ecx
  800420b871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b875:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420b879:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b87d:	48 63 c9             	movslq %ecx,%rcx
  800420b880:	48 83 c1 01          	add    $0x1,%rcx
  800420b884:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b888:	48 01 ca             	add    %rcx,%rdx
  800420b88b:	48 83 c2 08          	add    $0x8,%rdx
  800420b88f:	48 89 02             	mov    %rax,(%rdx)
		reg_table->cfa_rule = reg_table->rules[cfa];
  800420b892:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
  800420b896:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800420b89a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b89e:	48 63 d2             	movslq %edx,%rdx
  800420b8a1:	48 83 c2 01          	add    $0x1,%rdx
  800420b8a5:	48 c1 e2 04          	shl    $0x4,%rdx
  800420b8a9:	48 01 d0             	add    %rdx,%rax
  800420b8ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420b8b0:	48 8b 00             	mov    (%rax),%rax
  800420b8b3:	48 89 01             	mov    %rax,(%rcx)
  800420b8b6:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  800420b8ba:	eb 3c                	jmp    800420b8f8 <dwarf_get_fde_info_for_all_regs+0x1e9>
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
		    CFA.dw_offset_relevant;
  800420b8bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b8c0:	0f b6 10             	movzbl (%rax),%edx
		reg_table->rules[cfa].dw_value_type = CFA.dw_value_type;
		reg_table->rules[cfa].dw_regnum = CFA.dw_regnum;
		reg_table->rules[cfa].dw_offset = CFA.dw_offset_or_block_len;
		reg_table->cfa_rule = reg_table->rules[cfa];
	} else {
		reg_table->cfa_rule.dw_offset_relevant =
  800420b8c3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b8c7:	88 10                	mov    %dl,(%rax)
		    CFA.dw_offset_relevant;
		reg_table->cfa_rule.dw_value_type = CFA.dw_value_type;
  800420b8c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b8cd:	0f b6 50 01          	movzbl 0x1(%rax),%edx
  800420b8d1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b8d5:	88 50 01             	mov    %dl,0x1(%rax)
		reg_table->cfa_rule.dw_regnum = CFA.dw_regnum;
  800420b8d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b8dc:	0f b7 50 02          	movzwl 0x2(%rax),%edx
  800420b8e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b8e4:	66 89 50 02          	mov    %dx,0x2(%rax)
		reg_table->cfa_rule.dw_offset = CFA.dw_offset_or_block_len;
  800420b8e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b8ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420b8f0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420b8f4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  800420b8f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800420b8ff:	e9 fd 00 00 00       	jmpq   800420ba01 <dwarf_get_fde_info_for_all_regs+0x2f2>
	     i++) {

		/* Do not overwrite CFA column */
		if (i == cfa)
  800420b904:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
  800420b908:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800420b90b:	75 05                	jne    800420b912 <dwarf_get_fde_info_for_all_regs+0x203>
			continue;
  800420b90d:	e9 eb 00 00 00       	jmpq   800420b9fd <dwarf_get_fde_info_for_all_regs+0x2ee>

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
  800420b912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b916:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b91a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420b91d:	48 63 d0             	movslq %eax,%rdx
  800420b920:	48 89 d0             	mov    %rdx,%rax
  800420b923:	48 01 c0             	add    %rax,%rax
  800420b926:	48 01 d0             	add    %rdx,%rax
  800420b929:	48 c1 e0 03          	shl    $0x3,%rax
  800420b92d:	48 01 c8             	add    %rcx,%rax
  800420b930:	0f b6 00             	movzbl (%rax),%eax

		/* Do not overwrite CFA column */
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
  800420b933:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b937:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420b93a:	48 63 c9             	movslq %ecx,%rcx
  800420b93d:	48 83 c1 01          	add    $0x1,%rcx
  800420b941:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b945:	48 01 ca             	add    %rcx,%rdx
  800420b948:	88 02                	mov    %al,(%rdx)
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
  800420b94a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b94e:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420b955:	48 63 d0             	movslq %eax,%rdx
  800420b958:	48 89 d0             	mov    %rdx,%rax
  800420b95b:	48 01 c0             	add    %rax,%rax
  800420b95e:	48 01 d0             	add    %rdx,%rax
  800420b961:	48 c1 e0 03          	shl    $0x3,%rax
  800420b965:	48 01 c8             	add    %rcx,%rax
  800420b968:	0f b6 40 01          	movzbl 0x1(%rax),%eax
		if (i == cfa)
			continue;

		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
  800420b96c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b970:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420b973:	48 63 c9             	movslq %ecx,%rcx
  800420b976:	48 83 c1 01          	add    $0x1,%rcx
  800420b97a:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b97e:	48 01 ca             	add    %rcx,%rdx
  800420b981:	88 42 01             	mov    %al,0x1(%rdx)
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
  800420b984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b988:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b98c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420b98f:	48 63 d0             	movslq %eax,%rdx
  800420b992:	48 89 d0             	mov    %rdx,%rax
  800420b995:	48 01 c0             	add    %rax,%rax
  800420b998:	48 01 d0             	add    %rdx,%rax
  800420b99b:	48 c1 e0 03          	shl    $0x3,%rax
  800420b99f:	48 01 c8             	add    %rcx,%rax
  800420b9a2:	0f b7 40 02          	movzwl 0x2(%rax),%eax
  800420b9a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b9aa:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420b9ad:	48 63 c9             	movslq %ecx,%rcx
  800420b9b0:	48 83 c1 01          	add    $0x1,%rcx
  800420b9b4:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b9b8:	48 01 ca             	add    %rcx,%rdx
  800420b9bb:	66 89 42 02          	mov    %ax,0x2(%rdx)
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
  800420b9bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420b9c3:	48 8b 48 20          	mov    0x20(%rax),%rcx
  800420b9c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420b9ca:	48 63 d0             	movslq %eax,%rdx
  800420b9cd:	48 89 d0             	mov    %rdx,%rax
  800420b9d0:	48 01 c0             	add    %rax,%rax
  800420b9d3:	48 01 d0             	add    %rdx,%rax
  800420b9d6:	48 c1 e0 03          	shl    $0x3,%rax
  800420b9da:	48 01 c8             	add    %rcx,%rax
  800420b9dd:	48 8b 40 08          	mov    0x8(%rax),%rax
		reg_table->rules[i].dw_offset_relevant =
			rt->rt3_rules[i].dw_offset_relevant;
		reg_table->rules[i].dw_value_type =
			rt->rt3_rules[i].dw_value_type;
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
  800420b9e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420b9e5:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800420b9e8:	48 63 c9             	movslq %ecx,%rcx
  800420b9eb:	48 83 c1 01          	add    $0x1,%rcx
  800420b9ef:	48 c1 e1 04          	shl    $0x4,%rcx
  800420b9f3:	48 01 ca             	add    %rcx,%rdx
  800420b9f6:	48 83 c2 08          	add    $0x8,%rdx
  800420b9fa:	48 89 02             	mov    %rax,(%rdx)

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
	     i++) {
  800420b9fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	}

	/*
	 * Copy other columns.
	 */
	for (i = 0; i < DW_REG_TABLE_SIZE && i < dbg->dbg_frame_rule_table_size;
  800420ba01:	83 7d fc 41          	cmpl   $0x41,-0x4(%rbp)
  800420ba05:	7f 14                	jg     800420ba1b <dwarf_get_fde_info_for_all_regs+0x30c>
  800420ba07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420ba0b:	0f b7 40 48          	movzwl 0x48(%rax),%eax
  800420ba0f:	0f b7 c0             	movzwl %ax,%eax
  800420ba12:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800420ba15:	0f 8f e9 fe ff ff    	jg     800420b904 <dwarf_get_fde_info_for_all_regs+0x1f5>
		reg_table->rules[i].dw_regnum = rt->rt3_rules[i].dw_regnum;
		reg_table->rules[i].dw_offset =
			rt->rt3_rules[i].dw_offset_or_block_len;
	}

	if (row_pc) *row_pc = pc;
  800420ba1b:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  800420ba20:	74 0b                	je     800420ba2d <dwarf_get_fde_info_for_all_regs+0x31e>
  800420ba22:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420ba26:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ba2a:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLV_OK);
  800420ba2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420ba32:	c9                   	leaveq 
  800420ba33:	c3                   	retq   

000000800420ba34 <_dwarf_frame_read_lsb_encoded>:

static int
_dwarf_frame_read_lsb_encoded(Dwarf_Debug dbg, uint64_t *val, uint8_t *data,
			      uint64_t *offsetp, uint8_t encode, Dwarf_Addr pc, Dwarf_Error *error)
{
  800420ba34:	55                   	push   %rbp
  800420ba35:	48 89 e5             	mov    %rsp,%rbp
  800420ba38:	48 83 ec 40          	sub    $0x40,%rsp
  800420ba3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420ba40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420ba44:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420ba48:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  800420ba4c:	44 89 c0             	mov    %r8d,%eax
  800420ba4f:	4c 89 4d c0          	mov    %r9,-0x40(%rbp)
  800420ba53:	88 45 cc             	mov    %al,-0x34(%rbp)
	uint8_t application;

	if (encode == DW_EH_PE_omit)
  800420ba56:	80 7d cc ff          	cmpb   $0xff,-0x34(%rbp)
  800420ba5a:	75 0a                	jne    800420ba66 <_dwarf_frame_read_lsb_encoded+0x32>
		return (DW_DLE_NONE);
  800420ba5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800420ba61:	e9 e6 01 00 00       	jmpq   800420bc4c <_dwarf_frame_read_lsb_encoded+0x218>

	application = encode & 0xf0;
  800420ba66:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  800420ba6a:	83 e0 f0             	and    $0xfffffff0,%eax
  800420ba6d:	88 45 ff             	mov    %al,-0x1(%rbp)
	encode &= 0x0f;
  800420ba70:	80 65 cc 0f          	andb   $0xf,-0x34(%rbp)

	switch (encode) {
  800420ba74:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  800420ba78:	83 f8 0c             	cmp    $0xc,%eax
  800420ba7b:	0f 87 72 01 00 00    	ja     800420bbf3 <_dwarf_frame_read_lsb_encoded+0x1bf>
  800420ba81:	89 c0                	mov    %eax,%eax
  800420ba83:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420ba8a:	00 
  800420ba8b:	48 b8 80 fd 20 04 80 	movabs $0x800420fd80,%rax
  800420ba92:	00 00 00 
  800420ba95:	48 01 d0             	add    %rdx,%rax
  800420ba98:	48 8b 00             	mov    (%rax),%rax
  800420ba9b:	ff e0                	jmpq   *%rax
	case DW_EH_PE_absptr:
		*val = dbg->read(data, offsetp, dbg->dbg_pointer_size);
  800420ba9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420baa1:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420baa5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420baa9:	8b 52 28             	mov    0x28(%rdx),%edx
  800420baac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bab0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bab4:	48 89 cf             	mov    %rcx,%rdi
  800420bab7:	ff d0                	callq  *%rax
  800420bab9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420babd:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bac0:	e9 35 01 00 00       	jmpq   800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_uleb128:
		*val = _dwarf_read_uleb128(data, offsetp);
  800420bac5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420bac9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420bacd:	48 89 d6             	mov    %rdx,%rsi
  800420bad0:	48 89 c7             	mov    %rax,%rdi
  800420bad3:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420bada:	00 00 00 
  800420badd:	ff d0                	callq  *%rax
  800420badf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bae3:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bae6:	e9 0f 01 00 00       	jmpq   800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata2:
		*val = dbg->read(data, offsetp, 2);
  800420baeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420baef:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420baf3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420baf7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bafb:	ba 02 00 00 00       	mov    $0x2,%edx
  800420bb00:	48 89 cf             	mov    %rcx,%rdi
  800420bb03:	ff d0                	callq  *%rax
  800420bb05:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bb09:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bb0c:	e9 e9 00 00 00       	jmpq   800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata4:
		*val = dbg->read(data, offsetp, 4);
  800420bb11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bb15:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bb19:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bb1d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bb21:	ba 04 00 00 00       	mov    $0x4,%edx
  800420bb26:	48 89 cf             	mov    %rcx,%rdi
  800420bb29:	ff d0                	callq  *%rax
  800420bb2b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bb2f:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bb32:	e9 c3 00 00 00       	jmpq   800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_udata8:
		*val = dbg->read(data, offsetp, 8);
  800420bb37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bb3b:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bb3f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bb43:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bb47:	ba 08 00 00 00       	mov    $0x8,%edx
  800420bb4c:	48 89 cf             	mov    %rcx,%rdi
  800420bb4f:	ff d0                	callq  *%rax
  800420bb51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bb55:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bb58:	e9 9d 00 00 00       	jmpq   800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sleb128:
		*val = _dwarf_read_sleb128(data, offsetp);
  800420bb5d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420bb61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420bb65:	48 89 d6             	mov    %rdx,%rsi
  800420bb68:	48 89 c7             	mov    %rax,%rdi
  800420bb6b:	48 b8 24 8a 20 04 80 	movabs $0x8004208a24,%rax
  800420bb72:	00 00 00 
  800420bb75:	ff d0                	callq  *%rax
  800420bb77:	48 89 c2             	mov    %rax,%rdx
  800420bb7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bb7e:	48 89 10             	mov    %rdx,(%rax)
		break;
  800420bb81:	eb 77                	jmp    800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata2:
		*val = (int16_t) dbg->read(data, offsetp, 2);
  800420bb83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bb87:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bb8b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bb8f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bb93:	ba 02 00 00 00       	mov    $0x2,%edx
  800420bb98:	48 89 cf             	mov    %rcx,%rdi
  800420bb9b:	ff d0                	callq  *%rax
  800420bb9d:	48 0f bf d0          	movswq %ax,%rdx
  800420bba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bba5:	48 89 10             	mov    %rdx,(%rax)
		break;
  800420bba8:	eb 50                	jmp    800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata4:
		*val = (int32_t) dbg->read(data, offsetp, 4);
  800420bbaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bbae:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bbb2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bbb6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bbba:	ba 04 00 00 00       	mov    $0x4,%edx
  800420bbbf:	48 89 cf             	mov    %rcx,%rdi
  800420bbc2:	ff d0                	callq  *%rax
  800420bbc4:	48 63 d0             	movslq %eax,%rdx
  800420bbc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bbcb:	48 89 10             	mov    %rdx,(%rax)
		break;
  800420bbce:	eb 2a                	jmp    800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	case DW_EH_PE_sdata8:
		*val = dbg->read(data, offsetp, 8);
  800420bbd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bbd4:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bbd8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800420bbdc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800420bbe0:	ba 08 00 00 00       	mov    $0x8,%edx
  800420bbe5:	48 89 cf             	mov    %rcx,%rdi
  800420bbe8:	ff d0                	callq  *%rax
  800420bbea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bbee:	48 89 02             	mov    %rax,(%rdx)
		break;
  800420bbf1:	eb 07                	jmp    800420bbfa <_dwarf_frame_read_lsb_encoded+0x1c6>
	default:
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  800420bbf3:	b8 14 00 00 00       	mov    $0x14,%eax
  800420bbf8:	eb 52                	jmp    800420bc4c <_dwarf_frame_read_lsb_encoded+0x218>
	}

	if (application == DW_EH_PE_pcrel) {
  800420bbfa:	80 7d ff 10          	cmpb   $0x10,-0x1(%rbp)
  800420bbfe:	75 47                	jne    800420bc47 <_dwarf_frame_read_lsb_encoded+0x213>
		/*
		 * Value is relative to .eh_frame section virtual addr.
		 */
		switch (encode) {
  800420bc00:	0f b6 45 cc          	movzbl -0x34(%rbp),%eax
  800420bc04:	83 f8 01             	cmp    $0x1,%eax
  800420bc07:	7c 3d                	jl     800420bc46 <_dwarf_frame_read_lsb_encoded+0x212>
  800420bc09:	83 f8 04             	cmp    $0x4,%eax
  800420bc0c:	7e 0a                	jle    800420bc18 <_dwarf_frame_read_lsb_encoded+0x1e4>
  800420bc0e:	83 e8 09             	sub    $0x9,%eax
  800420bc11:	83 f8 03             	cmp    $0x3,%eax
  800420bc14:	77 30                	ja     800420bc46 <_dwarf_frame_read_lsb_encoded+0x212>
  800420bc16:	eb 17                	jmp    800420bc2f <_dwarf_frame_read_lsb_encoded+0x1fb>
		case DW_EH_PE_uleb128:
		case DW_EH_PE_udata2:
		case DW_EH_PE_udata4:
		case DW_EH_PE_udata8:
			*val += pc;
  800420bc18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bc1c:	48 8b 10             	mov    (%rax),%rdx
  800420bc1f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bc23:	48 01 c2             	add    %rax,%rdx
  800420bc26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bc2a:	48 89 10             	mov    %rdx,(%rax)
			break;
  800420bc2d:	eb 18                	jmp    800420bc47 <_dwarf_frame_read_lsb_encoded+0x213>
		case DW_EH_PE_sleb128:
		case DW_EH_PE_sdata2:
		case DW_EH_PE_sdata4:
		case DW_EH_PE_sdata8:
			*val = pc + (int64_t) *val;
  800420bc2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bc33:	48 8b 10             	mov    (%rax),%rdx
  800420bc36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bc3a:	48 01 c2             	add    %rax,%rdx
  800420bc3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420bc41:	48 89 10             	mov    %rdx,(%rax)
			break;
  800420bc44:	eb 01                	jmp    800420bc47 <_dwarf_frame_read_lsb_encoded+0x213>
		default:
			/* DW_EH_PE_absptr is absolute value. */
			break;
  800420bc46:	90                   	nop
		}
	}

	/* XXX Applications other than DW_EH_PE_pcrel are not handled. */

	return (DW_DLE_NONE);
  800420bc47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420bc4c:	c9                   	leaveq 
  800420bc4d:	c3                   	retq   

000000800420bc4e <_dwarf_frame_parse_lsb_cie_augment>:

static int
_dwarf_frame_parse_lsb_cie_augment(Dwarf_Debug dbg, Dwarf_Cie cie,
				   Dwarf_Error *error)
{
  800420bc4e:	55                   	push   %rbp
  800420bc4f:	48 89 e5             	mov    %rsp,%rbp
  800420bc52:	48 83 ec 50          	sub    $0x50,%rsp
  800420bc56:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420bc5a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420bc5e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	uint8_t *aug_p, *augdata_p;
	uint64_t val, offset;
	uint8_t encode;
	int ret;

	assert(cie->cie_augment != NULL && *cie->cie_augment == 'z');
  800420bc62:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bc66:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bc6a:	48 85 c0             	test   %rax,%rax
  800420bc6d:	74 0f                	je     800420bc7e <_dwarf_frame_parse_lsb_cie_augment+0x30>
  800420bc6f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bc73:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bc77:	0f b6 00             	movzbl (%rax),%eax
  800420bc7a:	3c 7a                	cmp    $0x7a,%al
  800420bc7c:	74 35                	je     800420bcb3 <_dwarf_frame_parse_lsb_cie_augment+0x65>
  800420bc7e:	48 b9 e8 fd 20 04 80 	movabs $0x800420fde8,%rcx
  800420bc85:	00 00 00 
  800420bc88:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420bc8f:	00 00 00 
  800420bc92:	be 4a 02 00 00       	mov    $0x24a,%esi
  800420bc97:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420bc9e:	00 00 00 
  800420bca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800420bca6:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420bcad:	00 00 00 
  800420bcb0:	41 ff d0             	callq  *%r8
	/*
	 * Here we're only interested in the presence of augment 'R'
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
  800420bcb3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bcb7:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bcbb:	48 83 c0 01          	add    $0x1,%rax
  800420bcbf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	augdata_p = cie->cie_augdata;
  800420bcc3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bcc7:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420bccb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (*aug_p != '\0') {
  800420bccf:	e9 af 00 00 00       	jmpq   800420bd83 <_dwarf_frame_parse_lsb_cie_augment+0x135>
		switch (*aug_p) {
  800420bcd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420bcd8:	0f b6 00             	movzbl (%rax),%eax
  800420bcdb:	0f b6 c0             	movzbl %al,%eax
  800420bcde:	83 f8 50             	cmp    $0x50,%eax
  800420bce1:	74 18                	je     800420bcfb <_dwarf_frame_parse_lsb_cie_augment+0xad>
  800420bce3:	83 f8 52             	cmp    $0x52,%eax
  800420bce6:	74 77                	je     800420bd5f <_dwarf_frame_parse_lsb_cie_augment+0x111>
  800420bce8:	83 f8 4c             	cmp    $0x4c,%eax
  800420bceb:	0f 85 86 00 00 00    	jne    800420bd77 <_dwarf_frame_parse_lsb_cie_augment+0x129>
		case 'L':
			/* Skip one augment in augment data. */
			augdata_p++;
  800420bcf1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
			break;
  800420bcf6:	e9 83 00 00 00       	jmpq   800420bd7e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'P':
			/* Skip two augments in augment data. */
			encode = *augdata_p++;
  800420bcfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420bcff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420bd03:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800420bd07:	0f b6 00             	movzbl (%rax),%eax
  800420bd0a:	88 45 ef             	mov    %al,-0x11(%rbp)
			offset = 0;
  800420bd0d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  800420bd14:	00 
			ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420bd15:	44 0f b6 45 ef       	movzbl -0x11(%rbp),%r8d
  800420bd1a:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  800420bd1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420bd22:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  800420bd26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420bd2a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800420bd2e:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420bd32:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420bd38:	48 89 c7             	mov    %rax,%rdi
  800420bd3b:	48 b8 34 ba 20 04 80 	movabs $0x800420ba34,%rax
  800420bd42:	00 00 00 
  800420bd45:	ff d0                	callq  *%rax
  800420bd47:	89 45 e8             	mov    %eax,-0x18(%rbp)
							    augdata_p, &offset, encode, 0, error);
			if (ret != DW_DLE_NONE)
  800420bd4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800420bd4e:	74 05                	je     800420bd55 <_dwarf_frame_parse_lsb_cie_augment+0x107>
				return (ret);
  800420bd50:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800420bd53:	eb 42                	jmp    800420bd97 <_dwarf_frame_parse_lsb_cie_augment+0x149>
			augdata_p += offset;
  800420bd55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420bd59:	48 01 45 f0          	add    %rax,-0x10(%rbp)
			break;
  800420bd5d:	eb 1f                	jmp    800420bd7e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		case 'R':
			cie->cie_fde_encode = *augdata_p++;
  800420bd5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420bd63:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420bd67:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800420bd6b:	0f b6 10             	movzbl (%rax),%edx
  800420bd6e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420bd72:	88 50 60             	mov    %dl,0x60(%rax)
			break;
  800420bd75:	eb 07                	jmp    800420bd7e <_dwarf_frame_parse_lsb_cie_augment+0x130>
		default:
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
  800420bd77:	b8 14 00 00 00       	mov    $0x14,%eax
  800420bd7c:	eb 19                	jmp    800420bd97 <_dwarf_frame_parse_lsb_cie_augment+0x149>
		}
		aug_p++;
  800420bd7e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
	 * and associated CIE augment data, which describes the
	 * encoding scheme of FDE PC begin and range.
	 */
	aug_p = &cie->cie_augment[1];
	augdata_p = cie->cie_augdata;
	while (*aug_p != '\0') {
  800420bd83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420bd87:	0f b6 00             	movzbl (%rax),%eax
  800420bd8a:	84 c0                	test   %al,%al
  800420bd8c:	0f 85 42 ff ff ff    	jne    800420bcd4 <_dwarf_frame_parse_lsb_cie_augment+0x86>
			return (DW_DLE_FRAME_AUGMENTATION_UNKNOWN);
		}
		aug_p++;
	}

	return (DW_DLE_NONE);
  800420bd92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420bd97:	c9                   	leaveq 
  800420bd98:	c3                   	retq   

000000800420bd99 <_dwarf_frame_set_cie>:


static int
_dwarf_frame_set_cie(Dwarf_Debug dbg, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, Dwarf_Cie ret_cie, Dwarf_Error *error)
{
  800420bd99:	55                   	push   %rbp
  800420bd9a:	48 89 e5             	mov    %rsp,%rbp
  800420bd9d:	48 83 ec 60          	sub    $0x60,%rsp
  800420bda1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420bda5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420bda9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800420bdad:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  800420bdb1:	4c 89 45 a8          	mov    %r8,-0x58(%rbp)
	Dwarf_Cie cie;
	uint64_t length;
	int dwarf_size, ret;
	char *p;

	assert(ret_cie);
  800420bdb5:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  800420bdba:	75 35                	jne    800420bdf1 <_dwarf_frame_set_cie+0x58>
  800420bdbc:	48 b9 1d fe 20 04 80 	movabs $0x800420fe1d,%rcx
  800420bdc3:	00 00 00 
  800420bdc6:	48 ba 67 fc 20 04 80 	movabs $0x800420fc67,%rdx
  800420bdcd:	00 00 00 
  800420bdd0:	be 7b 02 00 00       	mov    $0x27b,%esi
  800420bdd5:	48 bf 7c fc 20 04 80 	movabs $0x800420fc7c,%rdi
  800420bddc:	00 00 00 
  800420bddf:	b8 00 00 00 00       	mov    $0x0,%eax
  800420bde4:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420bdeb:	00 00 00 
  800420bdee:	41 ff d0             	callq  *%r8
	cie = ret_cie;
  800420bdf1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420bdf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

	cie->cie_dbg = dbg;
  800420bdf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bdfd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420be01:	48 89 10             	mov    %rdx,(%rax)
	cie->cie_offset = *off;
  800420be04:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420be08:	48 8b 10             	mov    (%rax),%rdx
  800420be0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420be0f:	48 89 50 10          	mov    %rdx,0x10(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  800420be13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420be17:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420be1b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420be1f:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420be23:	48 89 d1             	mov    %rdx,%rcx
  800420be26:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420be2a:	ba 04 00 00 00       	mov    $0x4,%edx
  800420be2f:	48 89 cf             	mov    %rcx,%rdi
  800420be32:	ff d0                	callq  *%rax
  800420be34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  800420be38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420be3d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800420be41:	75 2e                	jne    800420be71 <_dwarf_frame_set_cie+0xd8>
		dwarf_size = 8;
  800420be43:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  800420be4a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420be4e:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420be52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420be56:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420be5a:	48 89 d1             	mov    %rdx,%rcx
  800420be5d:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420be61:	ba 08 00 00 00       	mov    $0x8,%edx
  800420be66:	48 89 cf             	mov    %rcx,%rdi
  800420be69:	ff d0                	callq  *%rax
  800420be6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420be6f:	eb 07                	jmp    800420be78 <_dwarf_frame_set_cie+0xdf>
	} else
		dwarf_size = 4;
  800420be71:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  800420be78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420be7c:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800420be80:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420be84:	48 8b 00             	mov    (%rax),%rax
  800420be87:	48 29 c2             	sub    %rax,%rdx
  800420be8a:	48 89 d0             	mov    %rdx,%rax
  800420be8d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420be91:	73 0a                	jae    800420be9d <_dwarf_frame_set_cie+0x104>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  800420be93:	b8 12 00 00 00       	mov    $0x12,%eax
  800420be98:	e9 5d 03 00 00       	jmpq   800420c1fa <_dwarf_frame_set_cie+0x461>
	}

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
  800420be9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420bea1:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bea5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420bea9:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420bead:	48 89 d1             	mov    %rdx,%rcx
  800420beb0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420beb3:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420beb7:	48 89 cf             	mov    %rcx,%rdi
  800420beba:	ff d0                	callq  *%rax
	cie->cie_length = length;
  800420bebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bec0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420bec4:	48 89 50 18          	mov    %rdx,0x18(%rax)

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  800420bec8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420becc:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bed0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420bed4:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420bed8:	48 89 d1             	mov    %rdx,%rcx
  800420bedb:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420bedf:	ba 01 00 00 00       	mov    $0x1,%edx
  800420bee4:	48 89 cf             	mov    %rcx,%rdi
  800420bee7:	ff d0                	callq  *%rax
  800420bee9:	89 c2                	mov    %eax,%edx
  800420beeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420beef:	66 89 50 20          	mov    %dx,0x20(%rax)
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  800420bef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bef7:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  800420befb:	66 83 f8 01          	cmp    $0x1,%ax
  800420beff:	74 26                	je     800420bf27 <_dwarf_frame_set_cie+0x18e>
  800420bf01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf05:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  800420bf09:	66 83 f8 03          	cmp    $0x3,%ax
  800420bf0d:	74 18                	je     800420bf27 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
  800420bf0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf13:	0f b7 40 20          	movzwl 0x20(%rax),%eax

	(void) dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size); /* Skip CIE id. */
	cie->cie_length = length;

	cie->cie_version = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
	if (cie->cie_version != 1 && cie->cie_version != 3 &&
  800420bf17:	66 83 f8 04          	cmp    $0x4,%ax
  800420bf1b:	74 0a                	je     800420bf27 <_dwarf_frame_set_cie+0x18e>
	    cie->cie_version != 4) {
		DWARF_SET_ERROR(dbg, error, DW_DLE_FRAME_VERSION_BAD);
		return (DW_DLE_FRAME_VERSION_BAD);
  800420bf1d:	b8 16 00 00 00       	mov    $0x16,%eax
  800420bf22:	e9 d3 02 00 00       	jmpq   800420c1fa <_dwarf_frame_set_cie+0x461>
	}

	cie->cie_augment = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420bf27:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420bf2b:	48 8b 10             	mov    (%rax),%rdx
  800420bf2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420bf32:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420bf36:	48 01 d0             	add    %rdx,%rax
  800420bf39:	48 89 c2             	mov    %rax,%rdx
  800420bf3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf40:	48 89 50 28          	mov    %rdx,0x28(%rax)
	p = (char *)dbg->dbg_eh_offset;
  800420bf44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420bf48:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420bf4c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while (p[(*off)++] != '\0')
  800420bf50:	90                   	nop
  800420bf51:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420bf55:	48 8b 00             	mov    (%rax),%rax
  800420bf58:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800420bf5c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420bf60:	48 89 0a             	mov    %rcx,(%rdx)
  800420bf63:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420bf67:	48 01 d0             	add    %rdx,%rax
  800420bf6a:	0f b6 00             	movzbl (%rax),%eax
  800420bf6d:	84 c0                	test   %al,%al
  800420bf6f:	75 e0                	jne    800420bf51 <_dwarf_frame_set_cie+0x1b8>
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
  800420bf71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf75:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bf79:	0f b6 00             	movzbl (%rax),%eax
  800420bf7c:	84 c0                	test   %al,%al
  800420bf7e:	74 48                	je     800420bfc8 <_dwarf_frame_set_cie+0x22f>
  800420bf80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf84:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bf88:	0f b6 00             	movzbl (%rax),%eax
  800420bf8b:	3c 7a                	cmp    $0x7a,%al
  800420bf8d:	74 39                	je     800420bfc8 <_dwarf_frame_set_cie+0x22f>
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  800420bf8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bf93:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420bf97:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420bf9b:	75 07                	jne    800420bfa4 <_dwarf_frame_set_cie+0x20b>
  800420bf9d:	b8 04 00 00 00       	mov    $0x4,%eax
  800420bfa2:	eb 05                	jmp    800420bfa9 <_dwarf_frame_set_cie+0x210>
  800420bfa4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800420bfa9:	48 01 c2             	add    %rax,%rdx
			cie->cie_length;
  800420bfac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bfb0:	48 8b 40 18          	mov    0x18(%rax),%rax
	while (p[(*off)++] != '\0')
		;

	/* We only recognize normal .dwarf_frame and GNU .eh_frame sections. */
	if (*cie->cie_augment != 0 && *cie->cie_augment != 'z') {
		*off = cie->cie_offset + ((dwarf_size == 4) ? 4 : 12) +
  800420bfb4:	48 01 c2             	add    %rax,%rdx
  800420bfb7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420bfbb:	48 89 10             	mov    %rdx,(%rax)
			cie->cie_length;
		return (DW_DLE_NONE);
  800420bfbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800420bfc3:	e9 32 02 00 00       	jmpq   800420c1fa <_dwarf_frame_set_cie+0x461>
	}

	/* Optional EH Data field for .eh_frame section. */
	if (strstr((char *)cie->cie_augment, "eh") != NULL)
  800420bfc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420bfcc:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420bfd0:	48 be 25 fe 20 04 80 	movabs $0x800420fe25,%rsi
  800420bfd7:	00 00 00 
  800420bfda:	48 89 c7             	mov    %rax,%rdi
  800420bfdd:	48 b8 db 83 20 04 80 	movabs $0x80042083db,%rax
  800420bfe4:	00 00 00 
  800420bfe7:	ff d0                	callq  *%rax
  800420bfe9:	48 85 c0             	test   %rax,%rax
  800420bfec:	74 28                	je     800420c016 <_dwarf_frame_set_cie+0x27d>
		cie->cie_ehdata = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  800420bfee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420bff2:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420bff6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420bffa:	8b 52 28             	mov    0x28(%rdx),%edx
  800420bffd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420c001:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  800420c005:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420c009:	48 89 cf             	mov    %rcx,%rdi
  800420c00c:	ff d0                	callq  *%rax
  800420c00e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c012:	48 89 42 30          	mov    %rax,0x30(%rdx)
					    dbg->dbg_pointer_size);

	cie->cie_caf = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420c016:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c01a:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c01e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420c022:	48 89 d6             	mov    %rdx,%rsi
  800420c025:	48 89 c7             	mov    %rax,%rdi
  800420c028:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420c02f:	00 00 00 
  800420c032:	ff d0                	callq  *%rax
  800420c034:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c038:	48 89 42 38          	mov    %rax,0x38(%rdx)
	cie->cie_daf = _dwarf_read_sleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420c03c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c040:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c044:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420c048:	48 89 d6             	mov    %rdx,%rsi
  800420c04b:	48 89 c7             	mov    %rax,%rdi
  800420c04e:	48 b8 24 8a 20 04 80 	movabs $0x8004208a24,%rax
  800420c055:	00 00 00 
  800420c058:	ff d0                	callq  *%rax
  800420c05a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c05e:	48 89 42 40          	mov    %rax,0x40(%rdx)

	/* Return address register. */
	if (cie->cie_version == 1)
  800420c062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c066:	0f b7 40 20          	movzwl 0x20(%rax),%eax
  800420c06a:	66 83 f8 01          	cmp    $0x1,%ax
  800420c06e:	75 2b                	jne    800420c09b <_dwarf_frame_set_cie+0x302>
		cie->cie_ra = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 1);
  800420c070:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c074:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c078:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c07c:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c080:	48 89 d1             	mov    %rdx,%rcx
  800420c083:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  800420c087:	ba 01 00 00 00       	mov    $0x1,%edx
  800420c08c:	48 89 cf             	mov    %rcx,%rdi
  800420c08f:	ff d0                	callq  *%rax
  800420c091:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c095:	48 89 42 48          	mov    %rax,0x48(%rdx)
  800420c099:	eb 26                	jmp    800420c0c1 <_dwarf_frame_set_cie+0x328>
	else
		cie->cie_ra = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420c09b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c09f:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c0a3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420c0a7:	48 89 d6             	mov    %rdx,%rsi
  800420c0aa:	48 89 c7             	mov    %rax,%rdi
  800420c0ad:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420c0b4:	00 00 00 
  800420c0b7:	ff d0                	callq  *%rax
  800420c0b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c0bd:	48 89 42 48          	mov    %rax,0x48(%rdx)

	/* Optional CIE augmentation data for .eh_frame section. */
	if (*cie->cie_augment == 'z') {
  800420c0c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c0c5:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420c0c9:	0f b6 00             	movzbl (%rax),%eax
  800420c0cc:	3c 7a                	cmp    $0x7a,%al
  800420c0ce:	0f 85 93 00 00 00    	jne    800420c167 <_dwarf_frame_set_cie+0x3ce>
		cie->cie_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420c0d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c0d8:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c0dc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420c0e0:	48 89 d6             	mov    %rdx,%rsi
  800420c0e3:	48 89 c7             	mov    %rax,%rdi
  800420c0e6:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420c0ed:	00 00 00 
  800420c0f0:	ff d0                	callq  *%rax
  800420c0f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c0f6:	48 89 42 50          	mov    %rax,0x50(%rdx)
		cie->cie_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420c0fa:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c0fe:	48 8b 10             	mov    (%rax),%rdx
  800420c101:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c105:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c109:	48 01 d0             	add    %rdx,%rax
  800420c10c:	48 89 c2             	mov    %rax,%rdx
  800420c10f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c113:	48 89 50 58          	mov    %rdx,0x58(%rax)
		*off += cie->cie_auglen;
  800420c117:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c11b:	48 8b 10             	mov    (%rax),%rdx
  800420c11e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c122:	48 8b 40 50          	mov    0x50(%rax),%rax
  800420c126:	48 01 c2             	add    %rax,%rdx
  800420c129:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c12d:	48 89 10             	mov    %rdx,(%rax)
		/*
		 * XXX Use DW_EH_PE_absptr for default FDE PC start/range,
		 * in case _dwarf_frame_parse_lsb_cie_augment fails to
		 * find out the real encode.
		 */
		cie->cie_fde_encode = DW_EH_PE_absptr;
  800420c130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c134:	c6 40 60 00          	movb   $0x0,0x60(%rax)
		ret = _dwarf_frame_parse_lsb_cie_augment(dbg, cie, error);
  800420c138:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800420c13c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800420c140:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c144:	48 89 ce             	mov    %rcx,%rsi
  800420c147:	48 89 c7             	mov    %rax,%rdi
  800420c14a:	48 b8 4e bc 20 04 80 	movabs $0x800420bc4e,%rax
  800420c151:	00 00 00 
  800420c154:	ff d0                	callq  *%rax
  800420c156:	89 45 dc             	mov    %eax,-0x24(%rbp)
		if (ret != DW_DLE_NONE)
  800420c159:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420c15d:	74 08                	je     800420c167 <_dwarf_frame_set_cie+0x3ce>
			return (ret);
  800420c15f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420c162:	e9 93 00 00 00       	jmpq   800420c1fa <_dwarf_frame_set_cie+0x461>
	}

	/* CIE Initial instructions. */
	cie->cie_initinst = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420c167:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c16b:	48 8b 10             	mov    (%rax),%rdx
  800420c16e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c172:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c176:	48 01 d0             	add    %rdx,%rax
  800420c179:	48 89 c2             	mov    %rax,%rdx
  800420c17c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c180:	48 89 50 68          	mov    %rdx,0x68(%rax)
	if (dwarf_size == 4)
  800420c184:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420c188:	75 2a                	jne    800420c1b4 <_dwarf_frame_set_cie+0x41b>
		cie->cie_instlen = cie->cie_offset + 4 + length - *off;
  800420c18a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c18e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420c192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c196:	48 01 c2             	add    %rax,%rdx
  800420c199:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c19d:	48 8b 00             	mov    (%rax),%rax
  800420c1a0:	48 29 c2             	sub    %rax,%rdx
  800420c1a3:	48 89 d0             	mov    %rdx,%rax
  800420c1a6:	48 8d 50 04          	lea    0x4(%rax),%rdx
  800420c1aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c1ae:	48 89 50 70          	mov    %rdx,0x70(%rax)
  800420c1b2:	eb 28                	jmp    800420c1dc <_dwarf_frame_set_cie+0x443>
	else
		cie->cie_instlen = cie->cie_offset + 12 + length - *off;
  800420c1b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c1b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420c1bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c1c0:	48 01 c2             	add    %rax,%rdx
  800420c1c3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c1c7:	48 8b 00             	mov    (%rax),%rax
  800420c1ca:	48 29 c2             	sub    %rax,%rdx
  800420c1cd:	48 89 d0             	mov    %rdx,%rax
  800420c1d0:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  800420c1d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c1d8:	48 89 50 70          	mov    %rdx,0x70(%rax)

	*off += cie->cie_instlen;
  800420c1dc:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c1e0:	48 8b 10             	mov    (%rax),%rdx
  800420c1e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c1e7:	48 8b 40 70          	mov    0x70(%rax),%rax
  800420c1eb:	48 01 c2             	add    %rax,%rdx
  800420c1ee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c1f2:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  800420c1f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420c1fa:	c9                   	leaveq 
  800420c1fb:	c3                   	retq   

000000800420c1fc <_dwarf_frame_set_fde>:

static int
_dwarf_frame_set_fde(Dwarf_Debug dbg, Dwarf_Fde ret_fde, Dwarf_Section *ds,
		     Dwarf_Unsigned *off, int eh_frame, Dwarf_Cie cie, Dwarf_Error *error)
{
  800420c1fc:	55                   	push   %rbp
  800420c1fd:	48 89 e5             	mov    %rsp,%rbp
  800420c200:	48 83 ec 70          	sub    $0x70,%rsp
  800420c204:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420c208:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420c20c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800420c210:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
  800420c214:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)
  800420c218:	4c 89 4d a0          	mov    %r9,-0x60(%rbp)
	Dwarf_Fde fde;
	Dwarf_Unsigned cieoff;
	uint64_t length, val;
	int dwarf_size, ret;

	fde = ret_fde;
  800420c21c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420c220:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	fde->fde_dbg = dbg;
  800420c224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c228:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c22c:	48 89 10             	mov    %rdx,(%rax)
	fde->fde_addr = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420c22f:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c233:	48 8b 10             	mov    (%rax),%rdx
  800420c236:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c23a:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c23e:	48 01 d0             	add    %rdx,%rax
  800420c241:	48 89 c2             	mov    %rax,%rdx
  800420c244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c248:	48 89 50 10          	mov    %rdx,0x10(%rax)
	fde->fde_offset = *off;
  800420c24c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c250:	48 8b 10             	mov    (%rax),%rdx
  800420c253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c257:	48 89 50 18          	mov    %rdx,0x18(%rax)

	length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  800420c25b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c25f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c263:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c267:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c26b:	48 89 d1             	mov    %rdx,%rcx
  800420c26e:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c272:	ba 04 00 00 00       	mov    $0x4,%edx
  800420c277:	48 89 cf             	mov    %rcx,%rdi
  800420c27a:	ff d0                	callq  *%rax
  800420c27c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (length == 0xffffffff) {
  800420c280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420c285:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800420c289:	75 2e                	jne    800420c2b9 <_dwarf_frame_set_fde+0xbd>
		dwarf_size = 8;
  800420c28b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 8);
  800420c292:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c296:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c29a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c29e:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c2a2:	48 89 d1             	mov    %rdx,%rcx
  800420c2a5:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c2a9:	ba 08 00 00 00       	mov    $0x8,%edx
  800420c2ae:	48 89 cf             	mov    %rcx,%rdi
  800420c2b1:	ff d0                	callq  *%rax
  800420c2b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420c2b7:	eb 07                	jmp    800420c2c0 <_dwarf_frame_set_fde+0xc4>
	} else
		dwarf_size = 4;
  800420c2b9:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

	if (length > dbg->dbg_eh_size - *off) {
  800420c2c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c2c4:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800420c2c8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c2cc:	48 8b 00             	mov    (%rax),%rax
  800420c2cf:	48 29 c2             	sub    %rax,%rdx
  800420c2d2:	48 89 d0             	mov    %rdx,%rax
  800420c2d5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420c2d9:	73 0a                	jae    800420c2e5 <_dwarf_frame_set_fde+0xe9>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_FRAME_LENGTH_BAD);
		return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  800420c2db:	b8 12 00 00 00       	mov    $0x12,%eax
  800420c2e0:	e9 ca 02 00 00       	jmpq   800420c5af <_dwarf_frame_set_fde+0x3b3>
	}

	fde->fde_length = length;
  800420c2e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c2e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420c2ed:	48 89 50 20          	mov    %rdx,0x20(%rax)

	if (eh_frame) {
  800420c2f1:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420c2f5:	74 5e                	je     800420c355 <_dwarf_frame_set_fde+0x159>
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, 4);
  800420c2f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c2fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c2ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c303:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c307:	48 89 d1             	mov    %rdx,%rcx
  800420c30a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c30e:	ba 04 00 00 00       	mov    $0x4,%edx
  800420c313:	48 89 cf             	mov    %rcx,%rdi
  800420c316:	ff d0                	callq  *%rax
  800420c318:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c31c:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = *off - (4 + fde->fde_cieoff);
  800420c320:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c324:	48 8b 10             	mov    (%rax),%rdx
  800420c327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c32b:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420c32f:	48 29 c2             	sub    %rax,%rdx
  800420c332:	48 89 d0             	mov    %rdx,%rax
  800420c335:	48 83 e8 04          	sub    $0x4,%rax
  800420c339:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		/* This delta should never be 0. */
		if (cieoff == fde->fde_offset) {
  800420c33d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c341:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c345:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800420c349:	75 3d                	jne    800420c388 <_dwarf_frame_set_fde+0x18c>
			DWARF_SET_ERROR(dbg, error, DW_DLE_NO_CIE_FOR_FDE);
			return (DW_DLE_NO_CIE_FOR_FDE);
  800420c34b:	b8 13 00 00 00       	mov    $0x13,%eax
  800420c350:	e9 5a 02 00 00       	jmpq   800420c5af <_dwarf_frame_set_fde+0x3b3>
		}
	} else {
		fde->fde_cieoff = dbg->read((uint8_t *)dbg->dbg_eh_offset, off, dwarf_size);
  800420c355:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c359:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c35d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c361:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c365:	48 89 d1             	mov    %rdx,%rcx
  800420c368:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420c36b:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c36f:	48 89 cf             	mov    %rcx,%rdi
  800420c372:	ff d0                	callq  *%rax
  800420c374:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c378:	48 89 42 28          	mov    %rax,0x28(%rdx)
		cieoff = fde->fde_cieoff;
  800420c37c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c380:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420c384:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	}

	if (eh_frame) {
  800420c388:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420c38c:	0f 84 c9 00 00 00    	je     800420c45b <_dwarf_frame_set_fde+0x25f>
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  800420c392:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420c396:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420c39a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c39e:	48 8b 00             	mov    (%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420c3a1:	4c 8d 0c 02          	lea    (%rdx,%rax,1),%r9
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
  800420c3a5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420c3a9:	0f b6 40 60          	movzbl 0x60(%rax),%eax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420c3ad:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  800420c3b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c3b5:	48 8b 40 38          	mov    0x38(%rax),%rax
	if (eh_frame) {
		/*
		 * The FDE PC start/range for .eh_frame is encoded according
		 * to the LSB spec's extension to DWARF2.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420c3b9:	48 89 c2             	mov    %rax,%rdx
  800420c3bc:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800420c3c0:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800420c3c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c3c8:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  800420c3cc:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420c3d0:	48 89 c7             	mov    %rax,%rdi
  800420c3d3:	48 b8 34 ba 20 04 80 	movabs $0x800420ba34,%rax
  800420c3da:	00 00 00 
  800420c3dd:	ff d0                	callq  *%rax
  800420c3df:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, ds->ds_addr + *off, error);
		if (ret != DW_DLE_NONE)
  800420c3e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420c3e6:	74 08                	je     800420c3f0 <_dwarf_frame_set_fde+0x1f4>
			return (ret);
  800420c3e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420c3eb:	e9 bf 01 00 00       	jmpq   800420c5af <_dwarf_frame_set_fde+0x3b3>
		fde->fde_initloc = val;
  800420c3f0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420c3f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c3f8:	48 89 50 30          	mov    %rdx,0x30(%rax)
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
  800420c3fc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420c400:	0f b6 40 60          	movzbl 0x60(%rax),%eax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420c404:	44 0f b6 c0          	movzbl %al,%r8d
						    (uint8_t *)dbg->dbg_eh_offset,
  800420c408:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c40c:	48 8b 40 38          	mov    0x38(%rax),%rax
		fde->fde_initloc = val;
		/*
		 * FDE PC range should not be relative value to anything.
		 * So pass 0 for pc value.
		 */
		ret = _dwarf_frame_read_lsb_encoded(dbg, &val,
  800420c410:	48 89 c2             	mov    %rax,%rdx
  800420c413:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800420c417:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800420c41b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c41f:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  800420c423:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420c427:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800420c42d:	48 89 c7             	mov    %rax,%rdi
  800420c430:	48 b8 34 ba 20 04 80 	movabs $0x800420ba34,%rax
  800420c437:	00 00 00 
  800420c43a:	ff d0                	callq  *%rax
  800420c43c:	89 45 dc             	mov    %eax,-0x24(%rbp)
						    (uint8_t *)dbg->dbg_eh_offset,
						    off, cie->cie_fde_encode, 0, error);
		if (ret != DW_DLE_NONE)
  800420c43f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420c443:	74 08                	je     800420c44d <_dwarf_frame_set_fde+0x251>
			return (ret);
  800420c445:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800420c448:	e9 62 01 00 00       	jmpq   800420c5af <_dwarf_frame_set_fde+0x3b3>
		fde->fde_adrange = val;
  800420c44d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420c451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c455:	48 89 50 38          	mov    %rdx,0x38(%rax)
  800420c459:	eb 50                	jmp    800420c4ab <_dwarf_frame_set_fde+0x2af>
	} else {
		fde->fde_initloc = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  800420c45b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c45f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c463:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c467:	8b 52 28             	mov    0x28(%rdx),%edx
  800420c46a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420c46e:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  800420c472:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c476:	48 89 cf             	mov    %rcx,%rdi
  800420c479:	ff d0                	callq  *%rax
  800420c47b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c47f:	48 89 42 30          	mov    %rax,0x30(%rdx)
					     dbg->dbg_pointer_size);
		fde->fde_adrange = dbg->read((uint8_t *)dbg->dbg_eh_offset, off,
  800420c483:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c487:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c48b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c48f:	8b 52 28             	mov    0x28(%rdx),%edx
  800420c492:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800420c496:	48 8b 49 38          	mov    0x38(%rcx),%rcx
  800420c49a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c49e:	48 89 cf             	mov    %rcx,%rdi
  800420c4a1:	ff d0                	callq  *%rax
  800420c4a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c4a7:	48 89 42 38          	mov    %rax,0x38(%rdx)
					     dbg->dbg_pointer_size);
	}

	/* Optional FDE augmentation data for .eh_frame section. (ignored) */
	if (eh_frame && *cie->cie_augment == 'z') {
  800420c4ab:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800420c4af:	74 6b                	je     800420c51c <_dwarf_frame_set_fde+0x320>
  800420c4b1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420c4b5:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420c4b9:	0f b6 00             	movzbl (%rax),%eax
  800420c4bc:	3c 7a                	cmp    $0x7a,%al
  800420c4be:	75 5c                	jne    800420c51c <_dwarf_frame_set_fde+0x320>
		fde->fde_auglen = _dwarf_read_uleb128((uint8_t *)dbg->dbg_eh_offset, off);
  800420c4c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c4c4:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c4c8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800420c4cc:	48 89 d6             	mov    %rdx,%rsi
  800420c4cf:	48 89 c7             	mov    %rax,%rdi
  800420c4d2:	48 b8 c8 8a 20 04 80 	movabs $0x8004208ac8,%rax
  800420c4d9:	00 00 00 
  800420c4dc:	ff d0                	callq  *%rax
  800420c4de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c4e2:	48 89 42 40          	mov    %rax,0x40(%rdx)
		fde->fde_augdata = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420c4e6:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c4ea:	48 8b 10             	mov    (%rax),%rdx
  800420c4ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c4f1:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c4f5:	48 01 d0             	add    %rdx,%rax
  800420c4f8:	48 89 c2             	mov    %rax,%rdx
  800420c4fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c4ff:	48 89 50 48          	mov    %rdx,0x48(%rax)
		*off += fde->fde_auglen;
  800420c503:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c507:	48 8b 10             	mov    (%rax),%rdx
  800420c50a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c50e:	48 8b 40 40          	mov    0x40(%rax),%rax
  800420c512:	48 01 c2             	add    %rax,%rdx
  800420c515:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c519:	48 89 10             	mov    %rdx,(%rax)
	}

	fde->fde_inst = (uint8_t *)dbg->dbg_eh_offset + *off;
  800420c51c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c520:	48 8b 10             	mov    (%rax),%rdx
  800420c523:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c527:	48 8b 40 38          	mov    0x38(%rax),%rax
  800420c52b:	48 01 d0             	add    %rdx,%rax
  800420c52e:	48 89 c2             	mov    %rax,%rdx
  800420c531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c535:	48 89 50 50          	mov    %rdx,0x50(%rax)
	if (dwarf_size == 4)
  800420c539:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420c53d:	75 2a                	jne    800420c569 <_dwarf_frame_set_fde+0x36d>
		fde->fde_instlen = fde->fde_offset + 4 + length - *off;
  800420c53f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c543:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420c547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c54b:	48 01 c2             	add    %rax,%rdx
  800420c54e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c552:	48 8b 00             	mov    (%rax),%rax
  800420c555:	48 29 c2             	sub    %rax,%rdx
  800420c558:	48 89 d0             	mov    %rdx,%rax
  800420c55b:	48 8d 50 04          	lea    0x4(%rax),%rdx
  800420c55f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c563:	48 89 50 58          	mov    %rdx,0x58(%rax)
  800420c567:	eb 28                	jmp    800420c591 <_dwarf_frame_set_fde+0x395>
	else
		fde->fde_instlen = fde->fde_offset + 12 + length - *off;
  800420c569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c56d:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420c571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c575:	48 01 c2             	add    %rax,%rdx
  800420c578:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c57c:	48 8b 00             	mov    (%rax),%rax
  800420c57f:	48 29 c2             	sub    %rax,%rdx
  800420c582:	48 89 d0             	mov    %rdx,%rax
  800420c585:	48 8d 50 0c          	lea    0xc(%rax),%rdx
  800420c589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c58d:	48 89 50 58          	mov    %rdx,0x58(%rax)

	*off += fde->fde_instlen;
  800420c591:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c595:	48 8b 10             	mov    (%rax),%rdx
  800420c598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c59c:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420c5a0:	48 01 c2             	add    %rax,%rdx
  800420c5a3:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c5a7:	48 89 10             	mov    %rdx,(%rax)
	return (DW_DLE_NONE);
  800420c5aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420c5af:	c9                   	leaveq 
  800420c5b0:	c3                   	retq   

000000800420c5b1 <_dwarf_frame_interal_table_init>:


int
_dwarf_frame_interal_table_init(Dwarf_Debug dbg, Dwarf_Error *error)
{
  800420c5b1:	55                   	push   %rbp
  800420c5b2:	48 89 e5             	mov    %rsp,%rbp
  800420c5b5:	48 83 ec 20          	sub    $0x20,%rsp
  800420c5b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420c5bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	Dwarf_Regtable3 *rt = &global_rt_table;
  800420c5c1:	48 b8 00 2d 22 04 80 	movabs $0x8004222d00,%rax
  800420c5c8:	00 00 00 
  800420c5cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (dbg->dbg_internal_reg_table != NULL)
  800420c5cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c5d3:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420c5d7:	48 85 c0             	test   %rax,%rax
  800420c5da:	74 07                	je     800420c5e3 <_dwarf_frame_interal_table_init+0x32>
		return (DW_DLE_NONE);
  800420c5dc:	b8 00 00 00 00       	mov    $0x0,%eax
  800420c5e1:	eb 33                	jmp    800420c616 <_dwarf_frame_interal_table_init+0x65>

	rt->rt3_reg_table_size = dbg->dbg_frame_rule_table_size;
  800420c5e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c5e7:	0f b7 50 48          	movzwl 0x48(%rax),%edx
  800420c5eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c5ef:	66 89 50 18          	mov    %dx,0x18(%rax)
	rt->rt3_rules = global_rules;
  800420c5f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c5f7:	48 b9 40 35 22 04 80 	movabs $0x8004223540,%rcx
  800420c5fe:	00 00 00 
  800420c601:	48 89 48 20          	mov    %rcx,0x20(%rax)

	dbg->dbg_internal_reg_table = rt;
  800420c605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c609:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420c60d:	48 89 50 58          	mov    %rdx,0x58(%rax)

	return (DW_DLE_NONE);
  800420c611:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420c616:	c9                   	leaveq 
  800420c617:	c3                   	retq   

000000800420c618 <_dwarf_get_next_fde>:

static int
_dwarf_get_next_fde(Dwarf_Debug dbg,
		    int eh_frame, Dwarf_Error *error, Dwarf_Fde ret_fde)
{
  800420c618:	55                   	push   %rbp
  800420c619:	48 89 e5             	mov    %rsp,%rbp
  800420c61c:	48 83 ec 60          	sub    $0x60,%rsp
  800420c620:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800420c624:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800420c627:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800420c62b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	Dwarf_Section *ds = &debug_frame_sec; 
  800420c62f:	48 b8 e0 25 22 04 80 	movabs $0x80042225e0,%rax
  800420c636:	00 00 00 
  800420c639:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint64_t length, offset, cie_id, entry_off;
	int dwarf_size, i, ret=-1;
  800420c63d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%rbp)

	offset = dbg->curr_off_eh;
  800420c644:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c648:	48 8b 40 30          	mov    0x30(%rax),%rax
  800420c64c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (offset < dbg->dbg_eh_size) {
  800420c650:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c654:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800420c658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420c65c:	48 39 c2             	cmp    %rax,%rdx
  800420c65f:	0f 86 fe 01 00 00    	jbe    800420c863 <_dwarf_get_next_fde+0x24b>
		entry_off = offset;
  800420c665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420c669:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 4);
  800420c66d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c671:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c675:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c679:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c67d:	48 89 d1             	mov    %rdx,%rcx
  800420c680:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800420c684:	ba 04 00 00 00       	mov    $0x4,%edx
  800420c689:	48 89 cf             	mov    %rcx,%rdi
  800420c68c:	ff d0                	callq  *%rax
  800420c68e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		if (length == 0xffffffff) {
  800420c692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420c697:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800420c69b:	75 2e                	jne    800420c6cb <_dwarf_get_next_fde+0xb3>
			dwarf_size = 8;
  800420c69d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%rbp)
			length = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, 8);
  800420c6a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c6a8:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c6ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c6b0:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c6b4:	48 89 d1             	mov    %rdx,%rcx
  800420c6b7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800420c6bb:	ba 08 00 00 00       	mov    $0x8,%edx
  800420c6c0:	48 89 cf             	mov    %rcx,%rdi
  800420c6c3:	ff d0                	callq  *%rax
  800420c6c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420c6c9:	eb 07                	jmp    800420c6d2 <_dwarf_get_next_fde+0xba>
		} else
			dwarf_size = 4;
  800420c6cb:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%rbp)

		if (length > dbg->dbg_eh_size - offset || (length == 0 && !eh_frame)) {
  800420c6d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c6d6:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800420c6da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420c6de:	48 29 c2             	sub    %rax,%rdx
  800420c6e1:	48 89 d0             	mov    %rdx,%rax
  800420c6e4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800420c6e8:	72 0d                	jb     800420c6f7 <_dwarf_get_next_fde+0xdf>
  800420c6ea:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420c6ef:	75 10                	jne    800420c701 <_dwarf_get_next_fde+0xe9>
  800420c6f1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800420c6f5:	75 0a                	jne    800420c701 <_dwarf_get_next_fde+0xe9>
			DWARF_SET_ERROR(dbg, error,
					DW_DLE_DEBUG_FRAME_LENGTH_BAD);
			return (DW_DLE_DEBUG_FRAME_LENGTH_BAD);
  800420c6f7:	b8 12 00 00 00       	mov    $0x12,%eax
  800420c6fc:	e9 67 01 00 00       	jmpq   800420c868 <_dwarf_get_next_fde+0x250>
		}

		/* Check terminator for .eh_frame */
		if (eh_frame && length == 0)
  800420c701:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800420c705:	74 11                	je     800420c718 <_dwarf_get_next_fde+0x100>
  800420c707:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420c70c:	75 0a                	jne    800420c718 <_dwarf_get_next_fde+0x100>
			return(-1);
  800420c70e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420c713:	e9 50 01 00 00       	jmpq   800420c868 <_dwarf_get_next_fde+0x250>

		cie_id = dbg->read((uint8_t *)dbg->dbg_eh_offset, &offset, dwarf_size);
  800420c718:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c71c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420c720:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420c724:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  800420c728:	48 89 d1             	mov    %rdx,%rcx
  800420c72b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420c72e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800420c732:	48 89 cf             	mov    %rcx,%rdi
  800420c735:	ff d0                	callq  *%rax
  800420c737:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

		if (eh_frame) {
  800420c73b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800420c73f:	74 79                	je     800420c7ba <_dwarf_get_next_fde+0x1a2>
			/* GNU .eh_frame use CIE id 0. */
			if (cie_id == 0)
  800420c741:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800420c746:	75 32                	jne    800420c77a <_dwarf_get_next_fde+0x162>
				ret = _dwarf_frame_set_cie(dbg, ds,
  800420c748:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c74c:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420c750:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800420c754:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800420c758:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  800420c75c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c760:	49 89 f8             	mov    %rdi,%r8
  800420c763:	48 89 c7             	mov    %rax,%rdi
  800420c766:	48 b8 99 bd 20 04 80 	movabs $0x800420bd99,%rax
  800420c76d:	00 00 00 
  800420c770:	ff d0                	callq  *%rax
  800420c772:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800420c775:	e9 c8 00 00 00       	jmpq   800420c842 <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg,ret_fde, ds,
  800420c77a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c77e:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420c782:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800420c786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c78a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c78e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c792:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800420c796:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420c79a:	4d 89 c1             	mov    %r8,%r9
  800420c79d:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  800420c7a3:	48 89 c7             	mov    %rax,%rdi
  800420c7a6:	48 b8 fc c1 20 04 80 	movabs $0x800420c1fc,%rax
  800420c7ad:	00 00 00 
  800420c7b0:	ff d0                	callq  *%rax
  800420c7b2:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800420c7b5:	e9 88 00 00 00       	jmpq   800420c842 <_dwarf_get_next_fde+0x22a>
							   &entry_off, 1, ret_fde->fde_cie, error);
		} else {
			/* .dwarf_frame use CIE id ~0 */
			if ((dwarf_size == 4 && cie_id == ~0U) ||
  800420c7ba:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420c7be:	75 0b                	jne    800420c7cb <_dwarf_get_next_fde+0x1b3>
  800420c7c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420c7c5:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800420c7c9:	74 0d                	je     800420c7d8 <_dwarf_get_next_fde+0x1c0>
  800420c7cb:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  800420c7cf:	75 36                	jne    800420c807 <_dwarf_get_next_fde+0x1ef>
			    (dwarf_size == 8 && cie_id == ~0ULL))
  800420c7d1:	48 83 7d e0 ff       	cmpq   $0xffffffffffffffff,-0x20(%rbp)
  800420c7d6:	75 2f                	jne    800420c807 <_dwarf_get_next_fde+0x1ef>
				ret = _dwarf_frame_set_cie(dbg, ds,
  800420c7d8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c7dc:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800420c7e0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800420c7e4:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800420c7e8:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  800420c7ec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c7f0:	49 89 f8             	mov    %rdi,%r8
  800420c7f3:	48 89 c7             	mov    %rax,%rdi
  800420c7f6:	48 b8 99 bd 20 04 80 	movabs $0x800420bd99,%rax
  800420c7fd:	00 00 00 
  800420c800:	ff d0                	callq  *%rax
  800420c802:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800420c805:	eb 3b                	jmp    800420c842 <_dwarf_get_next_fde+0x22a>
							   &entry_off, ret_fde->fde_cie, error);
			else
				ret = _dwarf_frame_set_fde(dbg, ret_fde, ds,
  800420c807:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420c80b:	4c 8b 40 08          	mov    0x8(%rax),%r8
  800420c80f:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800420c813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420c817:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  800420c81b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c81f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800420c823:	48 89 3c 24          	mov    %rdi,(%rsp)
  800420c827:	4d 89 c1             	mov    %r8,%r9
  800420c82a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800420c830:	48 89 c7             	mov    %rax,%rdi
  800420c833:	48 b8 fc c1 20 04 80 	movabs $0x800420c1fc,%rax
  800420c83a:	00 00 00 
  800420c83d:	ff d0                	callq  *%rax
  800420c83f:	89 45 f0             	mov    %eax,-0x10(%rbp)
							   &entry_off, 0, ret_fde->fde_cie, error);
		}

		if (ret != DW_DLE_NONE)
  800420c842:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800420c846:	74 07                	je     800420c84f <_dwarf_get_next_fde+0x237>
			return(-1);
  800420c848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420c84d:	eb 19                	jmp    800420c868 <_dwarf_get_next_fde+0x250>

		offset = entry_off;
  800420c84f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420c853:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
		dbg->curr_off_eh = offset;
  800420c857:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420c85b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420c85f:	48 89 50 30          	mov    %rdx,0x30(%rax)
	}

	return (0);
  800420c863:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420c868:	c9                   	leaveq 
  800420c869:	c3                   	retq   

000000800420c86a <dwarf_set_frame_cfa_value>:

Dwarf_Half
dwarf_set_frame_cfa_value(Dwarf_Debug dbg, Dwarf_Half value)
{
  800420c86a:	55                   	push   %rbp
  800420c86b:	48 89 e5             	mov    %rsp,%rbp
  800420c86e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800420c872:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420c876:	89 f0                	mov    %esi,%eax
  800420c878:	66 89 45 e4          	mov    %ax,-0x1c(%rbp)
	Dwarf_Half old_value;

	old_value = dbg->dbg_frame_cfa_value;
  800420c87c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c880:	0f b7 40 4c          	movzwl 0x4c(%rax),%eax
  800420c884:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
	dbg->dbg_frame_cfa_value = value;
  800420c888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420c88c:	0f b7 55 e4          	movzwl -0x1c(%rbp),%edx
  800420c890:	66 89 50 4c          	mov    %dx,0x4c(%rax)

	return (old_value);
  800420c894:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
}
  800420c898:	c9                   	leaveq 
  800420c899:	c3                   	retq   

000000800420c89a <dwarf_init_eh_section>:

int dwarf_init_eh_section(Dwarf_Debug dbg, Dwarf_Error *error)
{
  800420c89a:	55                   	push   %rbp
  800420c89b:	48 89 e5             	mov    %rsp,%rbp
  800420c89e:	48 83 ec 10          	sub    $0x10,%rsp
  800420c8a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420c8a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	Dwarf_Section *section;

	if (dbg == NULL) {
  800420c8aa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420c8af:	75 0a                	jne    800420c8bb <dwarf_init_eh_section+0x21>
		DWARF_SET_ERROR(dbg, error, DW_DLE_ARGUMENT);
		return (DW_DLV_ERROR);
  800420c8b1:	b8 01 00 00 00       	mov    $0x1,%eax
  800420c8b6:	e9 85 00 00 00       	jmpq   800420c940 <dwarf_init_eh_section+0xa6>
	}

	if (dbg->dbg_internal_reg_table == NULL) {
  800420c8bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c8bf:	48 8b 40 58          	mov    0x58(%rax),%rax
  800420c8c3:	48 85 c0             	test   %rax,%rax
  800420c8c6:	75 25                	jne    800420c8ed <dwarf_init_eh_section+0x53>
		if (_dwarf_frame_interal_table_init(dbg, error) != DW_DLE_NONE)
  800420c8c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420c8cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c8d0:	48 89 d6             	mov    %rdx,%rsi
  800420c8d3:	48 89 c7             	mov    %rax,%rdi
  800420c8d6:	48 b8 b1 c5 20 04 80 	movabs $0x800420c5b1,%rax
  800420c8dd:	00 00 00 
  800420c8e0:	ff d0                	callq  *%rax
  800420c8e2:	85 c0                	test   %eax,%eax
  800420c8e4:	74 07                	je     800420c8ed <dwarf_init_eh_section+0x53>
			return (DW_DLV_ERROR);
  800420c8e6:	b8 01 00 00 00       	mov    $0x1,%eax
  800420c8eb:	eb 53                	jmp    800420c940 <dwarf_init_eh_section+0xa6>
	}

	_dwarf_find_section_enhanced(&debug_frame_sec);
  800420c8ed:	48 bf e0 25 22 04 80 	movabs $0x80042225e0,%rdi
  800420c8f4:	00 00 00 
  800420c8f7:	48 b8 66 a3 20 04 80 	movabs $0x800420a366,%rax
  800420c8fe:	00 00 00 
  800420c901:	ff d0                	callq  *%rax

	dbg->curr_off_eh = 0;
  800420c903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c907:	48 c7 40 30 00 00 00 	movq   $0x0,0x30(%rax)
  800420c90e:	00 
	dbg->dbg_eh_offset = debug_frame_sec.ds_addr;
  800420c90f:	48 b8 e0 25 22 04 80 	movabs $0x80042225e0,%rax
  800420c916:	00 00 00 
  800420c919:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420c91d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c921:	48 89 50 38          	mov    %rdx,0x38(%rax)
	dbg->dbg_eh_size = debug_frame_sec.ds_size;
  800420c925:	48 b8 e0 25 22 04 80 	movabs $0x80042225e0,%rax
  800420c92c:	00 00 00 
  800420c92f:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420c933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420c937:	48 89 50 40          	mov    %rdx,0x40(%rax)

	return (DW_DLV_OK);
  800420c93b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420c940:	c9                   	leaveq 
  800420c941:	c3                   	retq   

000000800420c942 <_dwarf_lineno_run_program>:
int  _dwarf_find_section_enhanced(Dwarf_Section *ds);

static int
_dwarf_lineno_run_program(Dwarf_CU *cu, Dwarf_LineInfo li, uint8_t *p,
			  uint8_t *pe, Dwarf_Addr pc, Dwarf_Error *error)
{
  800420c942:	55                   	push   %rbp
  800420c943:	48 89 e5             	mov    %rsp,%rbp
  800420c946:	53                   	push   %rbx
  800420c947:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  800420c94e:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  800420c952:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  800420c956:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  800420c95d:	48 89 8d 70 ff ff ff 	mov    %rcx,-0x90(%rbp)
  800420c964:	4c 89 85 68 ff ff ff 	mov    %r8,-0x98(%rbp)
  800420c96b:	4c 89 8d 60 ff ff ff 	mov    %r9,-0xa0(%rbp)
	uint64_t address, file, line, column, isa, opsize;
	int is_stmt, basic_block, end_sequence;
	int prologue_end, epilogue_begin;
	int ret;

	ln = &li->li_line;
  800420c972:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420c976:	48 83 c0 48          	add    $0x48,%rax
  800420c97a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	/*
	 *   ln->ln_li     = li;             \
	 * Set registers to their default values.
	 */
	RESET_REGISTERS;
  800420c97e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800420c985:	00 
  800420c986:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  800420c98d:	00 
  800420c98e:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  800420c995:	00 
  800420c996:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  800420c99d:	00 
  800420c99e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420c9a2:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  800420c9a6:	0f b6 c0             	movzbl %al,%eax
  800420c9a9:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800420c9ac:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  800420c9b3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  800420c9ba:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  800420c9c1:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  800420c9c8:	e9 0a 05 00 00       	jmpq   800420ced7 <_dwarf_lineno_run_program+0x595>
		if (*p == 0) {
  800420c9cd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420c9d4:	0f b6 00             	movzbl (%rax),%eax
  800420c9d7:	84 c0                	test   %al,%al
  800420c9d9:	0f 85 78 01 00 00    	jne    800420cb57 <_dwarf_lineno_run_program+0x215>

			/*
			 * Extended Opcodes.
			 */

			p++;
  800420c9df:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420c9e6:	48 83 c0 01          	add    $0x1,%rax
  800420c9ea:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
			opsize = _dwarf_decode_uleb128(&p);
  800420c9f1:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420c9f8:	48 89 c7             	mov    %rax,%rdi
  800420c9fb:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ca02:	00 00 00 
  800420ca05:	ff d0                	callq  *%rax
  800420ca07:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
			switch (*p) {
  800420ca0b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420ca12:	0f b6 00             	movzbl (%rax),%eax
  800420ca15:	0f b6 c0             	movzbl %al,%eax
  800420ca18:	83 f8 02             	cmp    $0x2,%eax
  800420ca1b:	74 7a                	je     800420ca97 <_dwarf_lineno_run_program+0x155>
  800420ca1d:	83 f8 03             	cmp    $0x3,%eax
  800420ca20:	0f 84 b3 00 00 00    	je     800420cad9 <_dwarf_lineno_run_program+0x197>
  800420ca26:	83 f8 01             	cmp    $0x1,%eax
  800420ca29:	0f 85 09 01 00 00    	jne    800420cb38 <_dwarf_lineno_run_program+0x1f6>
			case DW_LNE_end_sequence:
				p++;
  800420ca2f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420ca36:	48 83 c0 01          	add    $0x1,%rax
  800420ca3a:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				end_sequence = 1;
  800420ca41:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
				RESET_REGISTERS;
  800420ca48:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800420ca4f:	00 
  800420ca50:	48 c7 45 e0 01 00 00 	movq   $0x1,-0x20(%rbp)
  800420ca57:	00 
  800420ca58:	48 c7 45 d8 01 00 00 	movq   $0x1,-0x28(%rbp)
  800420ca5f:	00 
  800420ca60:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  800420ca67:	00 
  800420ca68:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420ca6c:	0f b6 40 19          	movzbl 0x19(%rax),%eax
  800420ca70:	0f b6 c0             	movzbl %al,%eax
  800420ca73:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800420ca76:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
  800420ca7d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%rbp)
  800420ca84:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
  800420ca8b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  800420ca92:	e9 bb 00 00 00       	jmpq   800420cb52 <_dwarf_lineno_run_program+0x210>
			case DW_LNE_set_address:
				p++;
  800420ca97:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420ca9e:	48 83 c0 01          	add    $0x1,%rax
  800420caa2:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				address = dbg->decode(&p, cu->addr_size);
  800420caa9:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420cab0:	00 00 00 
  800420cab3:	48 8b 00             	mov    (%rax),%rax
  800420cab6:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420caba:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  800420cabe:	0f b6 52 0a          	movzbl 0xa(%rdx),%edx
  800420cac2:	0f b6 ca             	movzbl %dl,%ecx
  800420cac5:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  800420cacc:	89 ce                	mov    %ecx,%esi
  800420cace:	48 89 d7             	mov    %rdx,%rdi
  800420cad1:	ff d0                	callq  *%rax
  800420cad3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				break;
  800420cad7:	eb 79                	jmp    800420cb52 <_dwarf_lineno_run_program+0x210>
			case DW_LNE_define_file:
				p++;
  800420cad9:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cae0:	48 83 c0 01          	add    $0x1,%rax
  800420cae4:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
				ret = _dwarf_lineno_add_file(li, &p, NULL,
  800420caeb:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420caf2:	00 00 00 
  800420caf5:	48 8b 08             	mov    (%rax),%rcx
  800420caf8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800420caff:	48 8d b5 78 ff ff ff 	lea    -0x88(%rbp),%rsi
  800420cb06:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cb0a:	49 89 c8             	mov    %rcx,%r8
  800420cb0d:	48 89 d1             	mov    %rdx,%rcx
  800420cb10:	ba 00 00 00 00       	mov    $0x0,%edx
  800420cb15:	48 89 c7             	mov    %rax,%rdi
  800420cb18:	48 b8 fa ce 20 04 80 	movabs $0x800420cefa,%rax
  800420cb1f:	00 00 00 
  800420cb22:	ff d0                	callq  *%rax
  800420cb24:	89 45 a4             	mov    %eax,-0x5c(%rbp)
							     error, dbg);
				if (ret != DW_DLE_NONE)
  800420cb27:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  800420cb2b:	74 09                	je     800420cb36 <_dwarf_lineno_run_program+0x1f4>
					goto prog_fail;
  800420cb2d:	90                   	nop

	return (DW_DLE_NONE);

prog_fail:

	return (ret);
  800420cb2e:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  800420cb31:	e9 ba 03 00 00       	jmpq   800420cef0 <_dwarf_lineno_run_program+0x5ae>
				p++;
				ret = _dwarf_lineno_add_file(li, &p, NULL,
							     error, dbg);
				if (ret != DW_DLE_NONE)
					goto prog_fail;
				break;
  800420cb36:	eb 1a                	jmp    800420cb52 <_dwarf_lineno_run_program+0x210>
			default:
				/* Unrecognized extened opcodes. */
				p += opsize;
  800420cb38:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  800420cb3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420cb43:	48 01 d0             	add    %rdx,%rax
  800420cb46:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  800420cb4d:	e9 85 03 00 00       	jmpq   800420ced7 <_dwarf_lineno_run_program+0x595>
  800420cb52:	e9 80 03 00 00       	jmpq   800420ced7 <_dwarf_lineno_run_program+0x595>
			}

		} else if (*p > 0 && *p < li->li_opbase) {
  800420cb57:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cb5e:	0f b6 00             	movzbl (%rax),%eax
  800420cb61:	84 c0                	test   %al,%al
  800420cb63:	0f 84 3c 02 00 00    	je     800420cda5 <_dwarf_lineno_run_program+0x463>
  800420cb69:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cb70:	0f b6 10             	movzbl (%rax),%edx
  800420cb73:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cb77:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420cb7b:	38 c2                	cmp    %al,%dl
  800420cb7d:	0f 83 22 02 00 00    	jae    800420cda5 <_dwarf_lineno_run_program+0x463>

			/*
			 * Standard Opcodes.
			 */

			switch (*p++) {
  800420cb83:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cb8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420cb8e:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
  800420cb95:	0f b6 00             	movzbl (%rax),%eax
  800420cb98:	0f b6 c0             	movzbl %al,%eax
  800420cb9b:	83 f8 0c             	cmp    $0xc,%eax
  800420cb9e:	0f 87 fb 01 00 00    	ja     800420cd9f <_dwarf_lineno_run_program+0x45d>
  800420cba4:	89 c0                	mov    %eax,%eax
  800420cba6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800420cbad:	00 
  800420cbae:	48 b8 28 fe 20 04 80 	movabs $0x800420fe28,%rax
  800420cbb5:	00 00 00 
  800420cbb8:	48 01 d0             	add    %rdx,%rax
  800420cbbb:	48 8b 00             	mov    (%rax),%rax
  800420cbbe:	ff e0                	jmpq   *%rax
			case DW_LNS_copy:
				APPEND_ROW;
  800420cbc0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420cbc7:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800420cbcb:	73 0a                	jae    800420cbd7 <_dwarf_lineno_run_program+0x295>
  800420cbcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800420cbd2:	e9 19 03 00 00       	jmpq   800420cef0 <_dwarf_lineno_run_program+0x5ae>
  800420cbd7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cbdb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420cbdf:	48 89 10             	mov    %rdx,(%rax)
  800420cbe2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cbe6:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  800420cbed:	00 
  800420cbee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cbf2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420cbf6:	48 89 50 10          	mov    %rdx,0x10(%rax)
  800420cbfa:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cbfe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420cc02:	48 89 50 18          	mov    %rdx,0x18(%rax)
  800420cc06:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420cc0a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cc0e:	48 89 50 20          	mov    %rdx,0x20(%rax)
  800420cc12:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cc16:	8b 55 c8             	mov    -0x38(%rbp),%edx
  800420cc19:	89 50 28             	mov    %edx,0x28(%rax)
  800420cc1c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cc20:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420cc23:	89 50 2c             	mov    %edx,0x2c(%rax)
  800420cc26:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420cc2a:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  800420cc2d:	89 50 30             	mov    %edx,0x30(%rax)
  800420cc30:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cc34:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800420cc3b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420cc3f:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cc43:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
				basic_block = 0;
  800420cc4a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
				prologue_end = 0;
  800420cc51:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
				epilogue_begin = 0;
  800420cc58:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
				break;
  800420cc5f:	e9 3c 01 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  800420cc64:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420cc6b:	48 89 c7             	mov    %rax,%rdi
  800420cc6e:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cc75:	00 00 00 
  800420cc78:	ff d0                	callq  *%rax
					li->li_minlen;
  800420cc7a:	48 8b 55 80          	mov    -0x80(%rbp),%rdx
  800420cc7e:	0f b6 52 18          	movzbl 0x18(%rdx),%edx
				basic_block = 0;
				prologue_end = 0;
				epilogue_begin = 0;
				break;
			case DW_LNS_advance_pc:
				address += _dwarf_decode_uleb128(&p) *
  800420cc82:	0f b6 d2             	movzbl %dl,%edx
  800420cc85:	48 0f af c2          	imul   %rdx,%rax
  800420cc89:	48 01 45 e8          	add    %rax,-0x18(%rbp)
					li->li_minlen;
				break;
  800420cc8d:	e9 0e 01 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_advance_line:
				line += _dwarf_decode_sleb128(&p);
  800420cc92:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420cc99:	48 89 c7             	mov    %rax,%rdi
  800420cc9c:	48 b8 47 8b 20 04 80 	movabs $0x8004208b47,%rax
  800420cca3:	00 00 00 
  800420cca6:	ff d0                	callq  *%rax
  800420cca8:	48 01 45 d8          	add    %rax,-0x28(%rbp)
				break;
  800420ccac:	e9 ef 00 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_file:
				file = _dwarf_decode_uleb128(&p);
  800420ccb1:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420ccb8:	48 89 c7             	mov    %rax,%rdi
  800420ccbb:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420ccc2:	00 00 00 
  800420ccc5:	ff d0                	callq  *%rax
  800420ccc7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
				break;
  800420cccb:	e9 d0 00 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_column:
				column = _dwarf_decode_uleb128(&p);
  800420ccd0:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420ccd7:	48 89 c7             	mov    %rax,%rdi
  800420ccda:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cce1:	00 00 00 
  800420cce4:	ff d0                	callq  *%rax
  800420cce6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
				break;
  800420ccea:	e9 b1 00 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_negate_stmt:
				is_stmt = !is_stmt;
  800420ccef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800420ccf3:	0f 94 c0             	sete   %al
  800420ccf6:	0f b6 c0             	movzbl %al,%eax
  800420ccf9:	89 45 cc             	mov    %eax,-0x34(%rbp)
				break;
  800420ccfc:	e9 9f 00 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_basic_block:
				basic_block = 1;
  800420cd01:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%rbp)
				break;
  800420cd08:	e9 93 00 00 00       	jmpq   800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_const_add_pc:
				address += ADDRESS(255);
  800420cd0d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cd11:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420cd15:	0f b6 c0             	movzbl %al,%eax
  800420cd18:	ba ff 00 00 00       	mov    $0xff,%edx
  800420cd1d:	89 d1                	mov    %edx,%ecx
  800420cd1f:	29 c1                	sub    %eax,%ecx
  800420cd21:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cd25:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  800420cd29:	0f b6 d8             	movzbl %al,%ebx
  800420cd2c:	89 c8                	mov    %ecx,%eax
  800420cd2e:	99                   	cltd   
  800420cd2f:	f7 fb                	idiv   %ebx
  800420cd31:	89 c2                	mov    %eax,%edx
  800420cd33:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cd37:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  800420cd3b:	0f b6 c0             	movzbl %al,%eax
  800420cd3e:	0f af c2             	imul   %edx,%eax
  800420cd41:	48 98                	cltq   
  800420cd43:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  800420cd47:	eb 57                	jmp    800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_fixed_advance_pc:
				address += dbg->decode(&p, 2);
  800420cd49:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420cd50:	00 00 00 
  800420cd53:	48 8b 00             	mov    (%rax),%rax
  800420cd56:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420cd5a:	48 8d 95 78 ff ff ff 	lea    -0x88(%rbp),%rdx
  800420cd61:	be 02 00 00 00       	mov    $0x2,%esi
  800420cd66:	48 89 d7             	mov    %rdx,%rdi
  800420cd69:	ff d0                	callq  *%rax
  800420cd6b:	48 01 45 e8          	add    %rax,-0x18(%rbp)
				break;
  800420cd6f:	eb 2f                	jmp    800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_prologue_end:
				prologue_end = 1;
  800420cd71:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%rbp)
				break;
  800420cd78:	eb 26                	jmp    800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_epilogue_begin:
				epilogue_begin = 1;
  800420cd7a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%rbp)
				break;
  800420cd81:	eb 1d                	jmp    800420cda0 <_dwarf_lineno_run_program+0x45e>
			case DW_LNS_set_isa:
				isa = _dwarf_decode_uleb128(&p);
  800420cd83:	48 8d 85 78 ff ff ff 	lea    -0x88(%rbp),%rax
  800420cd8a:	48 89 c7             	mov    %rax,%rdi
  800420cd8d:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cd94:	00 00 00 
  800420cd97:	ff d0                	callq  *%rax
  800420cd99:	48 89 45 98          	mov    %rax,-0x68(%rbp)
				break;
  800420cd9d:	eb 01                	jmp    800420cda0 <_dwarf_lineno_run_program+0x45e>
			default:
				/* Unrecognized extened opcodes. What to do? */
				break;
  800420cd9f:	90                   	nop
			}

		} else {
  800420cda0:	e9 32 01 00 00       	jmpq   800420ced7 <_dwarf_lineno_run_program+0x595>

			/*
			 * Special Opcodes.
			 */

			line += LINE(*p);
  800420cda5:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cda9:	0f b6 40 1a          	movzbl 0x1a(%rax),%eax
  800420cdad:	0f be c8             	movsbl %al,%ecx
  800420cdb0:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cdb7:	0f b6 00             	movzbl (%rax),%eax
  800420cdba:	0f b6 d0             	movzbl %al,%edx
  800420cdbd:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cdc1:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420cdc5:	0f b6 c0             	movzbl %al,%eax
  800420cdc8:	29 c2                	sub    %eax,%edx
  800420cdca:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cdce:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  800420cdd2:	0f b6 f0             	movzbl %al,%esi
  800420cdd5:	89 d0                	mov    %edx,%eax
  800420cdd7:	99                   	cltd   
  800420cdd8:	f7 fe                	idiv   %esi
  800420cdda:	89 d0                	mov    %edx,%eax
  800420cddc:	01 c8                	add    %ecx,%eax
  800420cdde:	48 98                	cltq   
  800420cde0:	48 01 45 d8          	add    %rax,-0x28(%rbp)
			address += ADDRESS(*p);
  800420cde4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cdeb:	0f b6 00             	movzbl (%rax),%eax
  800420cdee:	0f b6 d0             	movzbl %al,%edx
  800420cdf1:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cdf5:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420cdf9:	0f b6 c0             	movzbl %al,%eax
  800420cdfc:	89 d1                	mov    %edx,%ecx
  800420cdfe:	29 c1                	sub    %eax,%ecx
  800420ce00:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420ce04:	0f b6 40 1b          	movzbl 0x1b(%rax),%eax
  800420ce08:	0f b6 d8             	movzbl %al,%ebx
  800420ce0b:	89 c8                	mov    %ecx,%eax
  800420ce0d:	99                   	cltd   
  800420ce0e:	f7 fb                	idiv   %ebx
  800420ce10:	89 c2                	mov    %eax,%edx
  800420ce12:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420ce16:	0f b6 40 18          	movzbl 0x18(%rax),%eax
  800420ce1a:	0f b6 c0             	movzbl %al,%eax
  800420ce1d:	0f af c2             	imul   %edx,%eax
  800420ce20:	48 98                	cltq   
  800420ce22:	48 01 45 e8          	add    %rax,-0x18(%rbp)
			APPEND_ROW;
  800420ce26:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420ce2d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800420ce31:	73 0a                	jae    800420ce3d <_dwarf_lineno_run_program+0x4fb>
  800420ce33:	b8 00 00 00 00       	mov    $0x0,%eax
  800420ce38:	e9 b3 00 00 00       	jmpq   800420cef0 <_dwarf_lineno_run_program+0x5ae>
  800420ce3d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420ce45:	48 89 10             	mov    %rdx,(%rax)
  800420ce48:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce4c:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  800420ce53:	00 
  800420ce54:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce58:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420ce5c:	48 89 50 10          	mov    %rdx,0x10(%rax)
  800420ce60:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce64:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420ce68:	48 89 50 18          	mov    %rdx,0x18(%rax)
  800420ce6c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420ce70:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce74:	48 89 50 20          	mov    %rdx,0x20(%rax)
  800420ce78:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce7c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  800420ce7f:	89 50 28             	mov    %edx,0x28(%rax)
  800420ce82:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce86:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420ce89:	89 50 2c             	mov    %edx,0x2c(%rax)
  800420ce8c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420ce90:	8b 55 c4             	mov    -0x3c(%rbp),%edx
  800420ce93:	89 50 30             	mov    %edx,0x30(%rax)
  800420ce96:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420ce9a:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800420cea1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420cea5:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420cea9:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
			basic_block = 0;
  800420ceb0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
			prologue_end = 0;
  800420ceb7:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%rbp)
			epilogue_begin = 0;
  800420cebe:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%rbp)
			p++;
  800420cec5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cecc:	48 83 c0 01          	add    $0x1,%rax
  800420ced0:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
	RESET_REGISTERS;

	/*
	 * Start line number program.
	 */
	while (p < pe) {
  800420ced7:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420cede:	48 3b 85 70 ff ff ff 	cmp    -0x90(%rbp),%rax
  800420cee5:	0f 82 e2 fa ff ff    	jb     800420c9cd <_dwarf_lineno_run_program+0x8b>
			epilogue_begin = 0;
			p++;
		}
	}

	return (DW_DLE_NONE);
  800420ceeb:	b8 00 00 00 00       	mov    $0x0,%eax

#undef  RESET_REGISTERS
#undef  APPEND_ROW
#undef  LINE
#undef  ADDRESS
}
  800420cef0:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800420cef7:	5b                   	pop    %rbx
  800420cef8:	5d                   	pop    %rbp
  800420cef9:	c3                   	retq   

000000800420cefa <_dwarf_lineno_add_file>:

static int
_dwarf_lineno_add_file(Dwarf_LineInfo li, uint8_t **p, const char *compdir,
		       Dwarf_Error *error, Dwarf_Debug dbg)
{
  800420cefa:	55                   	push   %rbp
  800420cefb:	48 89 e5             	mov    %rsp,%rbp
  800420cefe:	53                   	push   %rbx
  800420ceff:	48 83 ec 48          	sub    $0x48,%rsp
  800420cf03:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800420cf07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800420cf0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800420cf0f:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
  800420cf13:	4c 89 45 b8          	mov    %r8,-0x48(%rbp)
	char *fname;
	//const char *dirname;
	uint8_t *src;
	int slen;

	src = *p;
  800420cf17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420cf1b:	48 8b 00             	mov    (%rax),%rax
  800420cf1e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  DWARF_SET_ERROR(dbg, error, DW_DLE_MEMORY);
  return (DW_DLE_MEMORY);
  }
*/  
	//lf->lf_fullpath = NULL;
	fname = (char *) src;
  800420cf22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420cf26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	src += strlen(fname) + 1;
  800420cf2a:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
  800420cf2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420cf32:	48 89 c7             	mov    %rax,%rdi
  800420cf35:	48 b8 b1 7c 20 04 80 	movabs $0x8004207cb1,%rax
  800420cf3c:	00 00 00 
  800420cf3f:	ff d0                	callq  *%rax
  800420cf41:	48 98                	cltq   
  800420cf43:	48 83 c0 01          	add    $0x1,%rax
  800420cf47:	48 01 d8             	add    %rbx,%rax
  800420cf4a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	_dwarf_decode_uleb128(&src);
  800420cf4e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800420cf52:	48 89 c7             	mov    %rax,%rdi
  800420cf55:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cf5c:	00 00 00 
  800420cf5f:	ff d0                	callq  *%rax
	   snprintf(lf->lf_fullpath, slen, "%s/%s", dirname,
	   lf->lf_fname);
	   }
	   }
	*/
	_dwarf_decode_uleb128(&src);
  800420cf61:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800420cf65:	48 89 c7             	mov    %rax,%rdi
  800420cf68:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cf6f:	00 00 00 
  800420cf72:	ff d0                	callq  *%rax
	_dwarf_decode_uleb128(&src);
  800420cf74:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800420cf78:	48 89 c7             	mov    %rax,%rdi
  800420cf7b:	48 b8 d9 8b 20 04 80 	movabs $0x8004208bd9,%rax
  800420cf82:	00 00 00 
  800420cf85:	ff d0                	callq  *%rax
	//STAILQ_INSERT_TAIL(&li->li_lflist, lf, lf_next);
	//li->li_lflen++;

	*p = src;
  800420cf87:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420cf8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420cf8f:	48 89 10             	mov    %rdx,(%rax)

	return (DW_DLE_NONE);
  800420cf92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420cf97:	48 83 c4 48          	add    $0x48,%rsp
  800420cf9b:	5b                   	pop    %rbx
  800420cf9c:	5d                   	pop    %rbp
  800420cf9d:	c3                   	retq   

000000800420cf9e <_dwarf_lineno_init>:

int     
_dwarf_lineno_init(Dwarf_Die *die, uint64_t offset, Dwarf_LineInfo linfo, Dwarf_Addr pc, Dwarf_Error *error)
{   
  800420cf9e:	55                   	push   %rbp
  800420cf9f:	48 89 e5             	mov    %rsp,%rbp
  800420cfa2:	53                   	push   %rbx
  800420cfa3:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  800420cfaa:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800420cfb1:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
  800420cfb8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800420cfbf:	48 89 8d 00 ff ff ff 	mov    %rcx,-0x100(%rbp)
  800420cfc6:	4c 89 85 f8 fe ff ff 	mov    %r8,-0x108(%rbp)
	Dwarf_Section myds = {.ds_name = ".debug_line"};
  800420cfcd:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
  800420cfd4:	00 
  800420cfd5:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
  800420cfdc:	00 
  800420cfdd:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
  800420cfe4:	00 
  800420cfe5:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  800420cfec:	00 
  800420cfed:	48 b8 90 fe 20 04 80 	movabs $0x800420fe90,%rax
  800420cff4:	00 00 00 
  800420cff7:	48 89 45 90          	mov    %rax,-0x70(%rbp)
	Dwarf_Section *ds = &myds;
  800420cffb:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800420cfff:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	//Dwarf_LineFile lf, tlf;
	uint64_t length, hdroff, endoff;
	uint8_t *p;
	int dwarf_size, i, ret;
            
	cu = die->cu_header;
  800420d003:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800420d00a:	48 8b 80 60 03 00 00 	mov    0x360(%rax),%rax
  800420d011:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	assert(cu != NULL); 
  800420d015:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800420d01a:	75 35                	jne    800420d051 <_dwarf_lineno_init+0xb3>
  800420d01c:	48 b9 9c fe 20 04 80 	movabs $0x800420fe9c,%rcx
  800420d023:	00 00 00 
  800420d026:	48 ba a7 fe 20 04 80 	movabs $0x800420fea7,%rdx
  800420d02d:	00 00 00 
  800420d030:	be 13 01 00 00       	mov    $0x113,%esi
  800420d035:	48 bf bc fe 20 04 80 	movabs $0x800420febc,%rdi
  800420d03c:	00 00 00 
  800420d03f:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d044:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420d04b:	00 00 00 
  800420d04e:	41 ff d0             	callq  *%r8
	assert(dbg != NULL);
  800420d051:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d058:	00 00 00 
  800420d05b:	48 8b 00             	mov    (%rax),%rax
  800420d05e:	48 85 c0             	test   %rax,%rax
  800420d061:	75 35                	jne    800420d098 <_dwarf_lineno_init+0xfa>
  800420d063:	48 b9 d3 fe 20 04 80 	movabs $0x800420fed3,%rcx
  800420d06a:	00 00 00 
  800420d06d:	48 ba a7 fe 20 04 80 	movabs $0x800420fea7,%rdx
  800420d074:	00 00 00 
  800420d077:	be 14 01 00 00       	mov    $0x114,%esi
  800420d07c:	48 bf bc fe 20 04 80 	movabs $0x800420febc,%rdi
  800420d083:	00 00 00 
  800420d086:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d08b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420d092:	00 00 00 
  800420d095:	41 ff d0             	callq  *%r8

	if ((_dwarf_find_section_enhanced(ds)) != 0)
  800420d098:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d09c:	48 89 c7             	mov    %rax,%rdi
  800420d09f:	48 b8 66 a3 20 04 80 	movabs $0x800420a366,%rax
  800420d0a6:	00 00 00 
  800420d0a9:	ff d0                	callq  *%rax
  800420d0ab:	85 c0                	test   %eax,%eax
  800420d0ad:	74 0a                	je     800420d0b9 <_dwarf_lineno_init+0x11b>
		return (DW_DLE_NONE);
  800420d0af:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d0b4:	e9 4f 04 00 00       	jmpq   800420d508 <_dwarf_lineno_init+0x56a>

	li = linfo;
  800420d0b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800420d0c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	 break;
	 }
	 }
	*/

	length = dbg->read(ds->ds_data, &offset, 4);
  800420d0c4:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d0cb:	00 00 00 
  800420d0ce:	48 8b 00             	mov    (%rax),%rax
  800420d0d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d0d5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d0d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d0dd:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d0e4:	ba 04 00 00 00       	mov    $0x4,%edx
  800420d0e9:	48 89 cf             	mov    %rcx,%rdi
  800420d0ec:	ff d0                	callq  *%rax
  800420d0ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (length == 0xffffffff) {
  800420d0f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420d0f7:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  800420d0fb:	75 37                	jne    800420d134 <_dwarf_lineno_init+0x196>
		dwarf_size = 8;
  800420d0fd:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
		length = dbg->read(ds->ds_data, &offset, 8);
  800420d104:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d10b:	00 00 00 
  800420d10e:	48 8b 00             	mov    (%rax),%rax
  800420d111:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d115:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d119:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d11d:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d124:	ba 08 00 00 00       	mov    $0x8,%edx
  800420d129:	48 89 cf             	mov    %rcx,%rdi
  800420d12c:	ff d0                	callq  *%rax
  800420d12e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800420d132:	eb 07                	jmp    800420d13b <_dwarf_lineno_init+0x19d>
	} else
		dwarf_size = 4;
  800420d134:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%rbp)

	if (length > ds->ds_size - offset) {
  800420d13b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d13f:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420d143:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  800420d14a:	48 29 c2             	sub    %rax,%rdx
  800420d14d:	48 89 d0             	mov    %rdx,%rax
  800420d150:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800420d154:	73 0a                	jae    800420d160 <_dwarf_lineno_init+0x1c2>
		DWARF_SET_ERROR(dbg, error, DW_DLE_DEBUG_LINE_LENGTH_BAD);
		return (DW_DLE_DEBUG_LINE_LENGTH_BAD);
  800420d156:	b8 0f 00 00 00       	mov    $0xf,%eax
  800420d15b:	e9 a8 03 00 00       	jmpq   800420d508 <_dwarf_lineno_init+0x56a>
	}
	/*
	 * Read in line number program header.
	 */
	li->li_length = length;
  800420d160:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d164:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420d168:	48 89 10             	mov    %rdx,(%rax)
	endoff = offset + length;
  800420d16b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  800420d172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420d176:	48 01 d0             	add    %rdx,%rax
  800420d179:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	li->li_version = dbg->read(ds->ds_data, &offset, 2); /* FIXME: verify version */
  800420d17d:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d184:	00 00 00 
  800420d187:	48 8b 00             	mov    (%rax),%rax
  800420d18a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d18e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d192:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d196:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d19d:	ba 02 00 00 00       	mov    $0x2,%edx
  800420d1a2:	48 89 cf             	mov    %rcx,%rdi
  800420d1a5:	ff d0                	callq  *%rax
  800420d1a7:	89 c2                	mov    %eax,%edx
  800420d1a9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d1ad:	66 89 50 08          	mov    %dx,0x8(%rax)
	li->li_hdrlen = dbg->read(ds->ds_data, &offset, dwarf_size);
  800420d1b1:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d1b8:	00 00 00 
  800420d1bb:	48 8b 00             	mov    (%rax),%rax
  800420d1be:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d1c2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d1c6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d1ca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800420d1cd:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d1d4:	48 89 cf             	mov    %rcx,%rdi
  800420d1d7:	ff d0                	callq  *%rax
  800420d1d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420d1dd:	48 89 42 10          	mov    %rax,0x10(%rdx)
	hdroff = offset;
  800420d1e1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  800420d1e8:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
	li->li_minlen = dbg->read(ds->ds_data, &offset, 1);
  800420d1ec:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d1f3:	00 00 00 
  800420d1f6:	48 8b 00             	mov    (%rax),%rax
  800420d1f9:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d1fd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d201:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d205:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d20c:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d211:	48 89 cf             	mov    %rcx,%rdi
  800420d214:	ff d0                	callq  *%rax
  800420d216:	89 c2                	mov    %eax,%edx
  800420d218:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d21c:	88 50 18             	mov    %dl,0x18(%rax)
	li->li_defstmt = dbg->read(ds->ds_data, &offset, 1);
  800420d21f:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d226:	00 00 00 
  800420d229:	48 8b 00             	mov    (%rax),%rax
  800420d22c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d230:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d234:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d238:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d23f:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d244:	48 89 cf             	mov    %rcx,%rdi
  800420d247:	ff d0                	callq  *%rax
  800420d249:	89 c2                	mov    %eax,%edx
  800420d24b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d24f:	88 50 19             	mov    %dl,0x19(%rax)
	li->li_lbase = dbg->read(ds->ds_data, &offset, 1);
  800420d252:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d259:	00 00 00 
  800420d25c:	48 8b 00             	mov    (%rax),%rax
  800420d25f:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d263:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d267:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d26b:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d272:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d277:	48 89 cf             	mov    %rcx,%rdi
  800420d27a:	ff d0                	callq  *%rax
  800420d27c:	89 c2                	mov    %eax,%edx
  800420d27e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d282:	88 50 1a             	mov    %dl,0x1a(%rax)
	li->li_lrange = dbg->read(ds->ds_data, &offset, 1);
  800420d285:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d28c:	00 00 00 
  800420d28f:	48 8b 00             	mov    (%rax),%rax
  800420d292:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d296:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d29a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d29e:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d2a5:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d2aa:	48 89 cf             	mov    %rcx,%rdi
  800420d2ad:	ff d0                	callq  *%rax
  800420d2af:	89 c2                	mov    %eax,%edx
  800420d2b1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d2b5:	88 50 1b             	mov    %dl,0x1b(%rax)
	li->li_opbase = dbg->read(ds->ds_data, &offset, 1);
  800420d2b8:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d2bf:	00 00 00 
  800420d2c2:	48 8b 00             	mov    (%rax),%rax
  800420d2c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d2c9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d2cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d2d1:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d2d8:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d2dd:	48 89 cf             	mov    %rcx,%rdi
  800420d2e0:	ff d0                	callq  *%rax
  800420d2e2:	89 c2                	mov    %eax,%edx
  800420d2e4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d2e8:	88 50 1c             	mov    %dl,0x1c(%rax)
	//STAILQ_INIT(&li->li_lflist);
	//STAILQ_INIT(&li->li_lnlist);

	if ((int)li->li_hdrlen - 5 < li->li_opbase - 1) {
  800420d2eb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d2ef:	48 8b 40 10          	mov    0x10(%rax),%rax
  800420d2f3:	8d 50 fb             	lea    -0x5(%rax),%edx
  800420d2f6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d2fa:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420d2fe:	0f b6 c0             	movzbl %al,%eax
  800420d301:	83 e8 01             	sub    $0x1,%eax
  800420d304:	39 c2                	cmp    %eax,%edx
  800420d306:	7d 0c                	jge    800420d314 <_dwarf_lineno_init+0x376>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  800420d308:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420d30f:	e9 f1 01 00 00       	jmpq   800420d505 <_dwarf_lineno_init+0x567>
	}

	li->li_oplen = global_std_op;
  800420d314:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d318:	48 bb 80 3b 22 04 80 	movabs $0x8004223b80,%rbx
  800420d31f:	00 00 00 
  800420d322:	48 89 58 20          	mov    %rbx,0x20(%rax)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  800420d326:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%rbp)
  800420d32d:	eb 41                	jmp    800420d370 <_dwarf_lineno_init+0x3d2>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);
  800420d32f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d333:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d337:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800420d33a:	48 98                	cltq   
  800420d33c:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
  800420d340:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d347:	00 00 00 
  800420d34a:	48 8b 00             	mov    (%rax),%rax
  800420d34d:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d351:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d355:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800420d359:	48 8d b5 10 ff ff ff 	lea    -0xf0(%rbp),%rsi
  800420d360:	ba 01 00 00 00       	mov    $0x1,%edx
  800420d365:	48 89 cf             	mov    %rcx,%rdi
  800420d368:	ff d0                	callq  *%rax
  800420d36a:	88 03                	mov    %al,(%rbx)

	/*
	 * Read in std opcode arg length list. Note that the first
	 * element is not used.
	 */
	for (i = 1; i < li->li_opbase; i++)
  800420d36c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  800420d370:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d374:	0f b6 40 1c          	movzbl 0x1c(%rax),%eax
  800420d378:	0f b6 c0             	movzbl %al,%eax
  800420d37b:	3b 45 e0             	cmp    -0x20(%rbp),%eax
  800420d37e:	7f af                	jg     800420d32f <_dwarf_lineno_init+0x391>
		li->li_oplen[i] = dbg->read(ds->ds_data, &offset, 1);

	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
  800420d380:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800420d387:	00 
	p = ds->ds_data + offset;
  800420d388:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d38c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420d390:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  800420d397:	48 01 d0             	add    %rdx,%rax
  800420d39a:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	while (*p != '\0') {
  800420d3a1:	eb 1f                	jmp    800420d3c2 <_dwarf_lineno_init+0x424>
		while (*p++ != '\0')
  800420d3a3:	90                   	nop
  800420d3a4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d3ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800420d3af:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
  800420d3b6:	0f b6 00             	movzbl (%rax),%eax
  800420d3b9:	84 c0                	test   %al,%al
  800420d3bb:	75 e7                	jne    800420d3a4 <_dwarf_lineno_init+0x406>
			;
		length++;
  800420d3bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
	/*
	 * Check how many strings in the include dir string array.
	 */
	length = 0;
	p = ds->ds_data + offset;
	while (*p != '\0') {
  800420d3c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d3c9:	0f b6 00             	movzbl (%rax),%eax
  800420d3cc:	84 c0                	test   %al,%al
  800420d3ce:	75 d3                	jne    800420d3a3 <_dwarf_lineno_init+0x405>
		while (*p++ != '\0')
			;
		length++;
	}
	li->li_inclen = length;
  800420d3d0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d3d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420d3d8:	48 89 50 30          	mov    %rdx,0x30(%rax)

	/* Sanity check. */
	if (p - ds->ds_data > (int) ds->ds_size) {
  800420d3dc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d3e3:	48 89 c2             	mov    %rax,%rdx
  800420d3e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d3ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420d3ee:	48 29 c2             	sub    %rax,%rdx
  800420d3f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d3f5:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420d3f9:	48 98                	cltq   
  800420d3fb:	48 39 c2             	cmp    %rax,%rdx
  800420d3fe:	7e 0c                	jle    800420d40c <_dwarf_lineno_init+0x46e>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  800420d400:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420d407:	e9 f9 00 00 00       	jmpq   800420d505 <_dwarf_lineno_init+0x567>
	}
	p++;
  800420d40c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d413:	48 83 c0 01          	add    $0x1,%rax
  800420d417:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  800420d41e:	eb 3c                	jmp    800420d45c <_dwarf_lineno_init+0x4be>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
  800420d420:	48 b8 c0 25 22 04 80 	movabs $0x80042225c0,%rax
  800420d427:	00 00 00 
  800420d42a:	48 8b 08             	mov    (%rax),%rcx
  800420d42d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800420d434:	48 8d b5 28 ff ff ff 	lea    -0xd8(%rbp),%rsi
  800420d43b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d43f:	49 89 c8             	mov    %rcx,%r8
  800420d442:	48 89 d1             	mov    %rdx,%rcx
  800420d445:	ba 00 00 00 00       	mov    $0x0,%edx
  800420d44a:	48 89 c7             	mov    %rax,%rdi
  800420d44d:	48 b8 fa ce 20 04 80 	movabs $0x800420cefa,%rax
  800420d454:	00 00 00 
  800420d457:	ff d0                	callq  *%rax
  800420d459:	89 45 dc             	mov    %eax,-0x24(%rbp)
	p++;

	/*
	 * Process file list.
	 */
	while (*p != '\0') {
  800420d45c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d463:	0f b6 00             	movzbl (%rax),%eax
  800420d466:	84 c0                	test   %al,%al
  800420d468:	75 b6                	jne    800420d420 <_dwarf_lineno_init+0x482>
		ret = _dwarf_lineno_add_file(li, &p, NULL, error, dbg);
		//p++;
	}

	p++;
  800420d46a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d471:	48 83 c0 01          	add    $0x1,%rax
  800420d475:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	/* Sanity check. */
	if (p - ds->ds_data - hdroff != li->li_hdrlen) {
  800420d47c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800420d483:	48 89 c2             	mov    %rax,%rdx
  800420d486:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d48a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420d48e:	48 29 c2             	sub    %rax,%rdx
  800420d491:	48 89 d0             	mov    %rdx,%rax
  800420d494:	48 2b 45 b0          	sub    -0x50(%rbp),%rax
  800420d498:	48 89 c2             	mov    %rax,%rdx
  800420d49b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800420d49f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800420d4a3:	48 39 c2             	cmp    %rax,%rdx
  800420d4a6:	74 09                	je     800420d4b1 <_dwarf_lineno_init+0x513>
		ret = DW_DLE_DEBUG_LINE_LENGTH_BAD;
  800420d4a8:	c7 45 dc 0f 00 00 00 	movl   $0xf,-0x24(%rbp)
		DWARF_SET_ERROR(dbg, error, ret);
		goto fail_cleanup;
  800420d4af:	eb 54                	jmp    800420d505 <_dwarf_lineno_init+0x567>
	}

	/*
	 * Process line number program.
	 */
	ret = _dwarf_lineno_run_program(cu, li, p, ds->ds_data + endoff, pc,
  800420d4b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d4b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800420d4b9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420d4bd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  800420d4c1:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  800420d4c8:	4c 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%r8
  800420d4cf:	48 8b bd 00 ff ff ff 	mov    -0x100(%rbp),%rdi
  800420d4d6:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  800420d4da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420d4de:	4d 89 c1             	mov    %r8,%r9
  800420d4e1:	49 89 f8             	mov    %rdi,%r8
  800420d4e4:	48 89 c7             	mov    %rax,%rdi
  800420d4e7:	48 b8 42 c9 20 04 80 	movabs $0x800420c942,%rax
  800420d4ee:	00 00 00 
  800420d4f1:	ff d0                	callq  *%rax
  800420d4f3:	89 45 dc             	mov    %eax,-0x24(%rbp)
					error);
	if (ret != DW_DLE_NONE)
  800420d4f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800420d4fa:	74 02                	je     800420d4fe <_dwarf_lineno_init+0x560>
		goto fail_cleanup;
  800420d4fc:	eb 07                	jmp    800420d505 <_dwarf_lineno_init+0x567>

	//cu->cu_lineinfo = li;

	return (DW_DLE_NONE);
  800420d4fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d503:	eb 03                	jmp    800420d508 <_dwarf_lineno_init+0x56a>
fail_cleanup:

	/*if (li->li_oplen)
	  free(li->li_oplen);*/

	return (ret);
  800420d505:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
  800420d508:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  800420d50f:	5b                   	pop    %rbx
  800420d510:	5d                   	pop    %rbp
  800420d511:	c3                   	retq   

000000800420d512 <dwarf_srclines>:

int
dwarf_srclines(Dwarf_Die *die, Dwarf_Line linebuf, Dwarf_Addr pc, Dwarf_Error *error)
{
  800420d512:	55                   	push   %rbp
  800420d513:	48 89 e5             	mov    %rsp,%rbp
  800420d516:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800420d51d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800420d524:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800420d52b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
  800420d532:	48 89 8d 50 ff ff ff 	mov    %rcx,-0xb0(%rbp)
	_Dwarf_LineInfo li;
	Dwarf_Attribute *at;

	assert(die);
  800420d539:	48 83 bd 68 ff ff ff 	cmpq   $0x0,-0x98(%rbp)
  800420d540:	00 
  800420d541:	75 35                	jne    800420d578 <dwarf_srclines+0x66>
  800420d543:	48 b9 df fe 20 04 80 	movabs $0x800420fedf,%rcx
  800420d54a:	00 00 00 
  800420d54d:	48 ba a7 fe 20 04 80 	movabs $0x800420fea7,%rdx
  800420d554:	00 00 00 
  800420d557:	be 9a 01 00 00       	mov    $0x19a,%esi
  800420d55c:	48 bf bc fe 20 04 80 	movabs $0x800420febc,%rdi
  800420d563:	00 00 00 
  800420d566:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d56b:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420d572:	00 00 00 
  800420d575:	41 ff d0             	callq  *%r8
	assert(linebuf);
  800420d578:	48 83 bd 60 ff ff ff 	cmpq   $0x0,-0xa0(%rbp)
  800420d57f:	00 
  800420d580:	75 35                	jne    800420d5b7 <dwarf_srclines+0xa5>
  800420d582:	48 b9 e3 fe 20 04 80 	movabs $0x800420fee3,%rcx
  800420d589:	00 00 00 
  800420d58c:	48 ba a7 fe 20 04 80 	movabs $0x800420fea7,%rdx
  800420d593:	00 00 00 
  800420d596:	be 9b 01 00 00       	mov    $0x19b,%esi
  800420d59b:	48 bf bc fe 20 04 80 	movabs $0x800420febc,%rdi
  800420d5a2:	00 00 00 
  800420d5a5:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d5aa:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420d5b1:	00 00 00 
  800420d5b4:	41 ff d0             	callq  *%r8

	memset(&li, 0, sizeof(_Dwarf_LineInfo));
  800420d5b7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800420d5be:	ba 88 00 00 00       	mov    $0x88,%edx
  800420d5c3:	be 00 00 00 00       	mov    $0x0,%esi
  800420d5c8:	48 89 c7             	mov    %rax,%rdi
  800420d5cb:	48 b8 b6 7f 20 04 80 	movabs $0x8004207fb6,%rax
  800420d5d2:	00 00 00 
  800420d5d5:	ff d0                	callq  *%rax

	if ((at = _dwarf_attr_find(die, DW_AT_stmt_list)) == NULL) {
  800420d5d7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420d5de:	be 10 00 00 00       	mov    $0x10,%esi
  800420d5e3:	48 89 c7             	mov    %rax,%rdi
  800420d5e6:	48 b8 eb 9e 20 04 80 	movabs $0x8004209eeb,%rax
  800420d5ed:	00 00 00 
  800420d5f0:	ff d0                	callq  *%rax
  800420d5f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420d5f6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800420d5fb:	75 0a                	jne    800420d607 <dwarf_srclines+0xf5>
		DWARF_SET_ERROR(dbg, error, DW_DLE_NO_ENTRY);
		return (DW_DLV_NO_ENTRY);
  800420d5fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800420d602:	e9 84 00 00 00       	jmpq   800420d68b <dwarf_srclines+0x179>
	}

	if (_dwarf_lineno_init(die, at->u[0].u64, &li, pc, error) !=
  800420d607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420d60b:	48 8b 70 28          	mov    0x28(%rax),%rsi
  800420d60f:	48 8b bd 50 ff ff ff 	mov    -0xb0(%rbp),%rdi
  800420d616:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800420d61d:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  800420d624:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420d62b:	49 89 f8             	mov    %rdi,%r8
  800420d62e:	48 89 c7             	mov    %rax,%rdi
  800420d631:	48 b8 9e cf 20 04 80 	movabs $0x800420cf9e,%rax
  800420d638:	00 00 00 
  800420d63b:	ff d0                	callq  *%rax
  800420d63d:	85 c0                	test   %eax,%eax
  800420d63f:	74 07                	je     800420d648 <dwarf_srclines+0x136>
	    DW_DLE_NONE)
	{
		return (DW_DLV_ERROR);
  800420d641:	b8 01 00 00 00       	mov    $0x1,%eax
  800420d646:	eb 43                	jmp    800420d68b <dwarf_srclines+0x179>
	}
	*linebuf = li.li_line;
  800420d648:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800420d64f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800420d653:	48 89 10             	mov    %rdx,(%rax)
  800420d656:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800420d65a:	48 89 50 08          	mov    %rdx,0x8(%rax)
  800420d65e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800420d662:	48 89 50 10          	mov    %rdx,0x10(%rax)
  800420d666:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800420d66a:	48 89 50 18          	mov    %rdx,0x18(%rax)
  800420d66e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420d672:	48 89 50 20          	mov    %rdx,0x20(%rax)
  800420d676:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420d67a:	48 89 50 28          	mov    %rdx,0x28(%rax)
  800420d67e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420d682:	48 89 50 30          	mov    %rdx,0x30(%rax)

	return (DW_DLV_OK);
  800420d686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800420d68b:	c9                   	leaveq 
  800420d68c:	c3                   	retq   

000000800420d68d <_dwarf_find_section>:
uintptr_t
read_section_headers(uintptr_t, uintptr_t);

Dwarf_Section *
_dwarf_find_section(const char *name)
{
  800420d68d:	55                   	push   %rbp
  800420d68e:	48 89 e5             	mov    %rsp,%rbp
  800420d691:	48 83 ec 20          	sub    $0x20,%rsp
  800420d695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	Dwarf_Section *ret=NULL;
  800420d699:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800420d6a0:	00 
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  800420d6a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  800420d6a8:	eb 57                	jmp    800420d701 <_dwarf_find_section+0x74>
		if(!strcmp(section_info[i].ds_name, name)) {
  800420d6aa:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d6b1:	00 00 00 
  800420d6b4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420d6b7:	48 63 d2             	movslq %edx,%rdx
  800420d6ba:	48 c1 e2 05          	shl    $0x5,%rdx
  800420d6be:	48 01 d0             	add    %rdx,%rax
  800420d6c1:	48 8b 00             	mov    (%rax),%rax
  800420d6c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420d6c8:	48 89 d6             	mov    %rdx,%rsi
  800420d6cb:	48 89 c7             	mov    %rax,%rdi
  800420d6ce:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d6d5:	00 00 00 
  800420d6d8:	ff d0                	callq  *%rax
  800420d6da:	85 c0                	test   %eax,%eax
  800420d6dc:	75 1f                	jne    800420d6fd <_dwarf_find_section+0x70>
			ret = (section_info + i);
  800420d6de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420d6e1:	48 98                	cltq   
  800420d6e3:	48 c1 e0 05          	shl    $0x5,%rax
  800420d6e7:	48 89 c2             	mov    %rax,%rdx
  800420d6ea:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d6f1:	00 00 00 
  800420d6f4:	48 01 d0             	add    %rdx,%rax
  800420d6f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
			break;
  800420d6fb:	eb 0a                	jmp    800420d707 <_dwarf_find_section+0x7a>
_dwarf_find_section(const char *name)
{
	Dwarf_Section *ret=NULL;
	int i;

	for(i=0; i < NDEBUG_SECT; i++) {
  800420d6fd:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  800420d701:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
  800420d705:	7e a3                	jle    800420d6aa <_dwarf_find_section+0x1d>
			ret = (section_info + i);
			break;
		}
	}

	return ret;
  800420d707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800420d70b:	c9                   	leaveq 
  800420d70c:	c3                   	retq   

000000800420d70d <find_debug_sections>:

void find_debug_sections(uintptr_t elf) 
{
  800420d70d:	55                   	push   %rbp
  800420d70e:	48 89 e5             	mov    %rsp,%rbp
  800420d711:	48 83 ec 40          	sub    $0x40,%rsp
  800420d715:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	Elf *ehdr = (Elf *)elf;
  800420d719:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420d71d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uintptr_t debug_address = USTABDATA;
  800420d721:	48 c7 45 f8 00 00 20 	movq   $0x200000,-0x8(%rbp)
  800420d728:	00 
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
  800420d729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420d72d:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420d731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420d735:	48 01 d0             	add    %rdx,%rax
  800420d738:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
  800420d73c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420d740:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  800420d744:	0f b7 c0             	movzwl %ax,%eax
  800420d747:	48 c1 e0 06          	shl    $0x6,%rax
  800420d74b:	48 89 c2             	mov    %rax,%rdx
  800420d74e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d752:	48 01 d0             	add    %rdx,%rax
  800420d755:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	Secthdr* esh = sh + ehdr->e_shnum;
  800420d759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420d75d:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  800420d761:	0f b7 c0             	movzwl %ax,%eax
  800420d764:	48 c1 e0 06          	shl    $0x6,%rax
  800420d768:	48 89 c2             	mov    %rax,%rdx
  800420d76b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d76f:	48 01 d0             	add    %rdx,%rax
  800420d772:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	for(;sh < esh; sh++) {
  800420d776:	e9 4b 02 00 00       	jmpq   800420d9c6 <find_debug_sections+0x2b9>
		char* name = (char*)((uint8_t*)elf + shstr_tab->sh_offset) + sh->sh_name;
  800420d77b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d77f:	8b 00                	mov    (%rax),%eax
  800420d781:	89 c2                	mov    %eax,%edx
  800420d783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420d787:	48 8b 48 18          	mov    0x18(%rax),%rcx
  800420d78b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420d78f:	48 01 c8             	add    %rcx,%rax
  800420d792:	48 01 d0             	add    %rdx,%rax
  800420d795:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if(!strcmp(name, ".debug_info")) {
  800420d799:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d79d:	48 be eb fe 20 04 80 	movabs $0x800420feeb,%rsi
  800420d7a4:	00 00 00 
  800420d7a7:	48 89 c7             	mov    %rax,%rdi
  800420d7aa:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d7b1:	00 00 00 
  800420d7b4:	ff d0                	callq  *%rax
  800420d7b6:	85 c0                	test   %eax,%eax
  800420d7b8:	75 4b                	jne    800420d805 <find_debug_sections+0xf8>
			section_info[DEBUG_INFO].ds_data = (uint8_t*)debug_address;
  800420d7ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d7be:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d7c5:	00 00 00 
  800420d7c8:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = debug_address;
  800420d7cc:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d7d3:	00 00 00 
  800420d7d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d7da:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = sh->sh_size;
  800420d7de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d7e2:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d7e6:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d7ed:	00 00 00 
  800420d7f0:	48 89 50 18          	mov    %rdx,0x18(%rax)
			debug_address += sh->sh_size;
  800420d7f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d7f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420d7fc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  800420d800:	e9 bc 01 00 00       	jmpq   800420d9c1 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_abbrev")) {
  800420d805:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d809:	48 be f7 fe 20 04 80 	movabs $0x800420fef7,%rsi
  800420d810:	00 00 00 
  800420d813:	48 89 c7             	mov    %rax,%rdi
  800420d816:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d81d:	00 00 00 
  800420d820:	ff d0                	callq  *%rax
  800420d822:	85 c0                	test   %eax,%eax
  800420d824:	75 4b                	jne    800420d871 <find_debug_sections+0x164>
			section_info[DEBUG_ABBREV].ds_data = (uint8_t*)debug_address;
  800420d826:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d82a:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d831:	00 00 00 
  800420d834:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = debug_address;
  800420d838:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d83f:	00 00 00 
  800420d842:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d846:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = sh->sh_size;
  800420d84a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d84e:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d852:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d859:	00 00 00 
  800420d85c:	48 89 50 38          	mov    %rdx,0x38(%rax)
			debug_address += sh->sh_size;
  800420d860:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d864:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420d868:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  800420d86c:	e9 50 01 00 00       	jmpq   800420d9c1 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_line")){
  800420d871:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d875:	48 be 0f ff 20 04 80 	movabs $0x800420ff0f,%rsi
  800420d87c:	00 00 00 
  800420d87f:	48 89 c7             	mov    %rax,%rdi
  800420d882:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d889:	00 00 00 
  800420d88c:	ff d0                	callq  *%rax
  800420d88e:	85 c0                	test   %eax,%eax
  800420d890:	75 4b                	jne    800420d8dd <find_debug_sections+0x1d0>
			section_info[DEBUG_LINE].ds_data = (uint8_t*)debug_address;
  800420d892:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d896:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d89d:	00 00 00 
  800420d8a0:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = debug_address;
  800420d8a4:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d8ab:	00 00 00 
  800420d8ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d8b2:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = sh->sh_size;
  800420d8b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d8ba:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d8be:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d8c5:	00 00 00 
  800420d8c8:	48 89 50 78          	mov    %rdx,0x78(%rax)
			debug_address += sh->sh_size;
  800420d8cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d8d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420d8d4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  800420d8d8:	e9 e4 00 00 00       	jmpq   800420d9c1 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".eh_frame")){
  800420d8dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d8e1:	48 be 05 ff 20 04 80 	movabs $0x800420ff05,%rsi
  800420d8e8:	00 00 00 
  800420d8eb:	48 89 c7             	mov    %rax,%rdi
  800420d8ee:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d8f5:	00 00 00 
  800420d8f8:	ff d0                	callq  *%rax
  800420d8fa:	85 c0                	test   %eax,%eax
  800420d8fc:	75 53                	jne    800420d951 <find_debug_sections+0x244>
			section_info[DEBUG_FRAME].ds_data = (uint8_t*)sh->sh_addr;
  800420d8fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d902:	48 8b 40 10          	mov    0x10(%rax),%rax
  800420d906:	48 89 c2             	mov    %rax,%rdx
  800420d909:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d910:	00 00 00 
  800420d913:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = sh->sh_addr;
  800420d917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d91b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420d91f:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d926:	00 00 00 
  800420d929:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = sh->sh_size;
  800420d92d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d931:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d935:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d93c:	00 00 00 
  800420d93f:	48 89 50 58          	mov    %rdx,0x58(%rax)
			debug_address += sh->sh_size;
  800420d943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d947:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420d94b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  800420d94f:	eb 70                	jmp    800420d9c1 <find_debug_sections+0x2b4>
		} else if(!strcmp(name, ".debug_str")) {
  800420d951:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420d955:	48 be 1b ff 20 04 80 	movabs $0x800420ff1b,%rsi
  800420d95c:	00 00 00 
  800420d95f:	48 89 c7             	mov    %rax,%rdi
  800420d962:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420d969:	00 00 00 
  800420d96c:	ff d0                	callq  *%rax
  800420d96e:	85 c0                	test   %eax,%eax
  800420d970:	75 4f                	jne    800420d9c1 <find_debug_sections+0x2b4>
			section_info[DEBUG_STR].ds_data = (uint8_t*)debug_address;
  800420d972:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d976:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d97d:	00 00 00 
  800420d980:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = debug_address;
  800420d987:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d98e:	00 00 00 
  800420d991:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420d995:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = sh->sh_size;
  800420d99c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d9a0:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420d9a4:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420d9ab:	00 00 00 
  800420d9ae:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
			debug_address += sh->sh_size;
  800420d9b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d9b9:	48 8b 40 20          	mov    0x20(%rax),%rax
  800420d9bd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	Elf *ehdr = (Elf *)elf;
	uintptr_t debug_address = USTABDATA;
	Secthdr *sh = (Secthdr *)(((uint8_t *)ehdr + ehdr->e_shoff));
	Secthdr *shstr_tab = sh + ehdr->e_shstrndx;
	Secthdr* esh = sh + ehdr->e_shnum;
	for(;sh < esh; sh++) {
  800420d9c1:	48 83 45 f0 40       	addq   $0x40,-0x10(%rbp)
  800420d9c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420d9ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800420d9ce:	0f 82 a7 fd ff ff    	jb     800420d77b <find_debug_sections+0x6e>
			section_info[DEBUG_STR].ds_size = sh->sh_size;
			debug_address += sh->sh_size;
		}
	}

}
  800420d9d4:	c9                   	leaveq 
  800420d9d5:	c3                   	retq   

000000800420d9d6 <read_section_headers>:

uint64_t
read_section_headers(uintptr_t elfhdr, uintptr_t to_va)
{
  800420d9d6:	55                   	push   %rbp
  800420d9d7:	48 89 e5             	mov    %rsp,%rbp
  800420d9da:	48 81 ec 60 01 00 00 	sub    $0x160,%rsp
  800420d9e1:	48 89 bd a8 fe ff ff 	mov    %rdi,-0x158(%rbp)
  800420d9e8:	48 89 b5 a0 fe ff ff 	mov    %rsi,-0x160(%rbp)
	Secthdr* secthdr_ptr[20] = {0};
  800420d9ef:	48 8d b5 c0 fe ff ff 	lea    -0x140(%rbp),%rsi
  800420d9f6:	b8 00 00 00 00       	mov    $0x0,%eax
  800420d9fb:	ba 14 00 00 00       	mov    $0x14,%edx
  800420da00:	48 89 f7             	mov    %rsi,%rdi
  800420da03:	48 89 d1             	mov    %rdx,%rcx
  800420da06:	f3 48 ab             	rep stos %rax,%es:(%rdi)
	char* kvbase = ROUNDUP((char*)to_va, SECTSIZE);
  800420da09:	48 c7 45 e8 00 02 00 	movq   $0x200,-0x18(%rbp)
  800420da10:	00 
  800420da11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420da15:	48 8b 95 a0 fe ff ff 	mov    -0x160(%rbp),%rdx
  800420da1c:	48 01 d0             	add    %rdx,%rax
  800420da1f:	48 83 e8 01          	sub    $0x1,%rax
  800420da23:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800420da27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420da2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800420da30:	48 f7 75 e8          	divq   -0x18(%rbp)
  800420da34:	48 89 d0             	mov    %rdx,%rax
  800420da37:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800420da3b:	48 29 c2             	sub    %rax,%rdx
  800420da3e:	48 89 d0             	mov    %rdx,%rax
  800420da41:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	uint64_t kvoffset = 0;
  800420da45:	48 c7 85 b8 fe ff ff 	movq   $0x0,-0x148(%rbp)
  800420da4c:	00 00 00 00 
	char *orig_secthdr = (char*)kvbase;
  800420da50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420da54:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	char * secthdr = NULL;
  800420da58:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  800420da5f:	00 
	uint64_t offset;
	if(elfhdr == KELFHDR)
  800420da60:	48 b8 00 00 01 04 80 	movabs $0x8004010000,%rax
  800420da67:	00 00 00 
  800420da6a:	48 39 85 a8 fe ff ff 	cmp    %rax,-0x158(%rbp)
  800420da71:	75 11                	jne    800420da84 <read_section_headers+0xae>
		offset = ((Elf*)elfhdr)->e_shoff;
  800420da73:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420da7a:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420da7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800420da82:	eb 26                	jmp    800420daaa <read_section_headers+0xd4>
	else
		offset = ((Elf*)elfhdr)->e_shoff + (elfhdr - KERNBASE);
  800420da84:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420da8b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  800420da8f:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420da96:	48 01 c2             	add    %rax,%rdx
  800420da99:	48 b8 00 00 00 fc 7f 	movabs $0xffffff7ffc000000,%rax
  800420daa0:	ff ff ff 
  800420daa3:	48 01 d0             	add    %rdx,%rax
  800420daa6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	int numSectionHeaders = ((Elf*)elfhdr)->e_shnum;
  800420daaa:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420dab1:	0f b7 40 3c          	movzwl 0x3c(%rax),%eax
  800420dab5:	0f b7 c0             	movzwl %ax,%eax
  800420dab8:	89 45 c4             	mov    %eax,-0x3c(%rbp)
	int sizeSections = ((Elf*)elfhdr)->e_shentsize;
  800420dabb:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420dac2:	0f b7 40 3a          	movzwl 0x3a(%rax),%eax
  800420dac6:	0f b7 c0             	movzwl %ax,%eax
  800420dac9:	89 45 c0             	mov    %eax,-0x40(%rbp)
	char *nametab;
	int i;
	uint64_t temp;
	char *name;

	Elf *ehdr = (Elf *)elfhdr;
  800420dacc:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
  800420dad3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
  800420dad7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800420dada:	0f af 45 c0          	imul   -0x40(%rbp),%eax
  800420dade:	48 63 f0             	movslq %eax,%rsi
  800420dae1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420dae5:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420daec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800420daf0:	48 89 c7             	mov    %rax,%rdi
  800420daf3:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420dafa:	00 00 00 
  800420dafd:	ff d0                	callq  *%rax
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
  800420daff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420db03:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800420db07:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800420db0b:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420db11:	48 89 c2             	mov    %rax,%rdx
  800420db14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420db18:	48 29 d0             	sub    %rdx,%rax
  800420db1b:	48 89 c2             	mov    %rax,%rdx
  800420db1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420db22:	48 01 d0             	add    %rdx,%rax
  800420db25:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	for (i = 0; i < numSectionHeaders; i++)
  800420db29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  800420db30:	eb 24                	jmp    800420db56 <read_section_headers+0x180>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
  800420db32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420db35:	48 98                	cltq   
  800420db37:	48 c1 e0 06          	shl    $0x6,%rax
  800420db3b:	48 89 c2             	mov    %rax,%rdx
  800420db3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800420db42:	48 01 c2             	add    %rax,%rdx
  800420db45:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420db48:	48 98                	cltq   
  800420db4a:	48 89 94 c5 c0 fe ff 	mov    %rdx,-0x140(%rbp,%rax,8)
  800420db51:	ff 
	Secthdr *sec_name;  

	readseg((uint64_t)orig_secthdr , numSectionHeaders * sizeSections,
		offset, &kvoffset);
	secthdr = (char*)orig_secthdr + (offset - ROUNDDOWN(offset, SECTSIZE));
	for (i = 0; i < numSectionHeaders; i++)
  800420db52:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  800420db56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420db59:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  800420db5c:	7c d4                	jl     800420db32 <read_section_headers+0x15c>
	{
		secthdr_ptr[i] = (Secthdr*)(secthdr) + i;
	}
	
	sec_name = secthdr_ptr[ehdr->e_shstrndx]; 
  800420db5e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800420db62:	0f b7 40 3e          	movzwl 0x3e(%rax),%eax
  800420db66:	0f b7 c0             	movzwl %ax,%eax
  800420db69:	48 98                	cltq   
  800420db6b:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420db72:	ff 
  800420db73:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	temp = kvoffset;
  800420db77:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  800420db7e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
  800420db82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420db86:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420db8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420db8e:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420db92:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  800420db99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420db9d:	48 01 c8             	add    %rcx,%rax
  800420dba0:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420dba7:	48 89 c7             	mov    %rax,%rdi
  800420dbaa:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420dbb1:	00 00 00 
  800420dbb4:	ff d0                	callq  *%rax
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	
  800420dbb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420dbba:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dbbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420dbc2:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420dbc6:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  800420dbca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800420dbce:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420dbd4:	48 29 c2             	sub    %rax,%rdx
  800420dbd7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420dbdb:	48 01 c2             	add    %rax,%rdx
  800420dbde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420dbe2:	48 01 d0             	add    %rdx,%rax
  800420dbe5:	48 89 45 90          	mov    %rax,-0x70(%rbp)

	for (i = 0; i < numSectionHeaders; i++)
  800420dbe9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  800420dbf0:	e9 04 05 00 00       	jmpq   800420e0f9 <read_section_headers+0x723>
	{
		name = (char *)(nametab + secthdr_ptr[i]->sh_name);
  800420dbf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dbf8:	48 98                	cltq   
  800420dbfa:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dc01:	ff 
  800420dc02:	8b 00                	mov    (%rax),%eax
  800420dc04:	89 c2                	mov    %eax,%edx
  800420dc06:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800420dc0a:	48 01 d0             	add    %rdx,%rax
  800420dc0d:	48 89 45 88          	mov    %rax,-0x78(%rbp)
		assert(kvoffset % SECTSIZE == 0);
  800420dc11:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  800420dc18:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420dc1d:	48 85 c0             	test   %rax,%rax
  800420dc20:	74 35                	je     800420dc57 <read_section_headers+0x281>
  800420dc22:	48 b9 26 ff 20 04 80 	movabs $0x800420ff26,%rcx
  800420dc29:	00 00 00 
  800420dc2c:	48 ba 3f ff 20 04 80 	movabs $0x800420ff3f,%rdx
  800420dc33:	00 00 00 
  800420dc36:	be 86 00 00 00       	mov    $0x86,%esi
  800420dc3b:	48 bf 54 ff 20 04 80 	movabs $0x800420ff54,%rdi
  800420dc42:	00 00 00 
  800420dc45:	b8 00 00 00 00       	mov    $0x0,%eax
  800420dc4a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420dc51:	00 00 00 
  800420dc54:	41 ff d0             	callq  *%r8
		temp = kvoffset;
  800420dc57:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  800420dc5e:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
  800420dc62:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420dc66:	48 be eb fe 20 04 80 	movabs $0x800420feeb,%rsi
  800420dc6d:	00 00 00 
  800420dc70:	48 89 c7             	mov    %rax,%rdi
  800420dc73:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420dc7a:	00 00 00 
  800420dc7d:	ff d0                	callq  *%rax
  800420dc7f:	85 c0                	test   %eax,%eax
  800420dc81:	0f 85 d8 00 00 00    	jne    800420dd5f <read_section_headers+0x389>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  800420dc87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dc8a:	48 98                	cltq   
  800420dc8c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dc93:	ff 
#ifdef DWARF_DEBUG
		cprintf("SectName: %s\n", name);
#endif
		if(!strcmp(name, ".debug_info"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  800420dc94:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dc98:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dc9b:	48 98                	cltq   
  800420dc9d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dca4:	ff 
  800420dca5:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420dca9:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  800420dcb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420dcb4:	48 01 c8             	add    %rcx,%rax
  800420dcb7:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420dcbe:	48 89 c7             	mov    %rax,%rdi
  800420dcc1:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420dcc8:	00 00 00 
  800420dccb:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_INFO].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  800420dccd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dcd0:	48 98                	cltq   
  800420dcd2:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dcd9:	ff 
  800420dcda:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dcde:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dce1:	48 98                	cltq   
  800420dce3:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dcea:	ff 
  800420dceb:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420dcef:	48 89 45 80          	mov    %rax,-0x80(%rbp)
  800420dcf3:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800420dcf7:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420dcfd:	48 29 c2             	sub    %rax,%rdx
  800420dd00:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420dd04:	48 01 c2             	add    %rax,%rdx
  800420dd07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420dd0b:	48 01 c2             	add    %rax,%rdx
  800420dd0e:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dd15:	00 00 00 
  800420dd18:	48 89 50 08          	mov    %rdx,0x8(%rax)
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
  800420dd1c:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dd23:	00 00 00 
  800420dd26:	48 8b 40 08          	mov    0x8(%rax),%rax
  800420dd2a:	48 89 c2             	mov    %rax,%rdx
  800420dd2d:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dd34:	00 00 00 
  800420dd37:	48 89 50 10          	mov    %rdx,0x10(%rax)
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
  800420dd3b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dd3e:	48 98                	cltq   
  800420dd40:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dd47:	ff 
  800420dd48:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420dd4c:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dd53:	00 00 00 
  800420dd56:	48 89 50 18          	mov    %rdx,0x18(%rax)
  800420dd5a:	e9 96 03 00 00       	jmpq   800420e0f5 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_abbrev"))
  800420dd5f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420dd63:	48 be f7 fe 20 04 80 	movabs $0x800420fef7,%rsi
  800420dd6a:	00 00 00 
  800420dd6d:	48 89 c7             	mov    %rax,%rdi
  800420dd70:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420dd77:	00 00 00 
  800420dd7a:	ff d0                	callq  *%rax
  800420dd7c:	85 c0                	test   %eax,%eax
  800420dd7e:	0f 85 de 00 00 00    	jne    800420de62 <read_section_headers+0x48c>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  800420dd84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dd87:	48 98                	cltq   
  800420dd89:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dd90:	ff 
			section_info[DEBUG_INFO].ds_addr = (uintptr_t)section_info[DEBUG_INFO].ds_data;
			section_info[DEBUG_INFO].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_abbrev"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  800420dd91:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dd95:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dd98:	48 98                	cltq   
  800420dd9a:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dda1:	ff 
  800420dda2:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420dda6:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  800420ddad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420ddb1:	48 01 c8             	add    %rcx,%rax
  800420ddb4:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420ddbb:	48 89 c7             	mov    %rax,%rdi
  800420ddbe:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420ddc5:	00 00 00 
  800420ddc8:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_ABBREV].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  800420ddca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420ddcd:	48 98                	cltq   
  800420ddcf:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420ddd6:	ff 
  800420ddd7:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dddb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420ddde:	48 98                	cltq   
  800420dde0:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dde7:	ff 
  800420dde8:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420ddec:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
  800420ddf3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  800420ddfa:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420de00:	48 29 c2             	sub    %rax,%rdx
  800420de03:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420de07:	48 01 c2             	add    %rax,%rdx
  800420de0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420de0e:	48 01 c2             	add    %rax,%rdx
  800420de11:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420de18:	00 00 00 
  800420de1b:	48 89 50 28          	mov    %rdx,0x28(%rax)
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
  800420de1f:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420de26:	00 00 00 
  800420de29:	48 8b 40 28          	mov    0x28(%rax),%rax
  800420de2d:	48 89 c2             	mov    %rax,%rdx
  800420de30:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420de37:	00 00 00 
  800420de3a:	48 89 50 30          	mov    %rdx,0x30(%rax)
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
  800420de3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420de41:	48 98                	cltq   
  800420de43:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420de4a:	ff 
  800420de4b:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420de4f:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420de56:	00 00 00 
  800420de59:	48 89 50 38          	mov    %rdx,0x38(%rax)
  800420de5d:	e9 93 02 00 00       	jmpq   800420e0f5 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_line"))
  800420de62:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420de66:	48 be 0f ff 20 04 80 	movabs $0x800420ff0f,%rsi
  800420de6d:	00 00 00 
  800420de70:	48 89 c7             	mov    %rax,%rdi
  800420de73:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420de7a:	00 00 00 
  800420de7d:	ff d0                	callq  *%rax
  800420de7f:	85 c0                	test   %eax,%eax
  800420de81:	0f 85 de 00 00 00    	jne    800420df65 <read_section_headers+0x58f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  800420de87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420de8a:	48 98                	cltq   
  800420de8c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420de93:	ff 
			section_info[DEBUG_ABBREV].ds_addr = (uintptr_t)section_info[DEBUG_ABBREV].ds_data;
			section_info[DEBUG_ABBREV].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_line"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  800420de94:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420de98:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420de9b:	48 98                	cltq   
  800420de9d:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dea4:	ff 
  800420dea5:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420dea9:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  800420deb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420deb4:	48 01 c8             	add    %rcx,%rax
  800420deb7:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420debe:	48 89 c7             	mov    %rax,%rdi
  800420dec1:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420dec8:	00 00 00 
  800420decb:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_LINE].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  800420decd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420ded0:	48 98                	cltq   
  800420ded2:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420ded9:	ff 
  800420deda:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420dede:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dee1:	48 98                	cltq   
  800420dee3:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420deea:	ff 
  800420deeb:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420deef:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
  800420def6:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
  800420defd:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420df03:	48 29 c2             	sub    %rax,%rdx
  800420df06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420df0a:	48 01 c2             	add    %rax,%rdx
  800420df0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420df11:	48 01 c2             	add    %rax,%rdx
  800420df14:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420df1b:	00 00 00 
  800420df1e:	48 89 50 68          	mov    %rdx,0x68(%rax)
			section_info[DEBUG_LINE].ds_addr = (uintptr_t)section_info[DEBUG_LINE].ds_data;
  800420df22:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420df29:	00 00 00 
  800420df2c:	48 8b 40 68          	mov    0x68(%rax),%rax
  800420df30:	48 89 c2             	mov    %rax,%rdx
  800420df33:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420df3a:	00 00 00 
  800420df3d:	48 89 50 70          	mov    %rdx,0x70(%rax)
			section_info[DEBUG_LINE].ds_size = secthdr_ptr[i]->sh_size;
  800420df41:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420df44:	48 98                	cltq   
  800420df46:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420df4d:	ff 
  800420df4e:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420df52:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420df59:	00 00 00 
  800420df5c:	48 89 50 78          	mov    %rdx,0x78(%rax)
  800420df60:	e9 90 01 00 00       	jmpq   800420e0f5 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".eh_frame"))
  800420df65:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420df69:	48 be 05 ff 20 04 80 	movabs $0x800420ff05,%rsi
  800420df70:	00 00 00 
  800420df73:	48 89 c7             	mov    %rax,%rdi
  800420df76:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420df7d:	00 00 00 
  800420df80:	ff d0                	callq  *%rax
  800420df82:	85 c0                	test   %eax,%eax
  800420df84:	75 65                	jne    800420dfeb <read_section_headers+0x615>
		{
			section_info[DEBUG_FRAME].ds_data = (uint8_t *)secthdr_ptr[i]->sh_addr;
  800420df86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420df89:	48 98                	cltq   
  800420df8b:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420df92:	ff 
  800420df93:	48 8b 40 10          	mov    0x10(%rax),%rax
  800420df97:	48 89 c2             	mov    %rax,%rdx
  800420df9a:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dfa1:	00 00 00 
  800420dfa4:	48 89 50 48          	mov    %rdx,0x48(%rax)
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
  800420dfa8:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dfaf:	00 00 00 
  800420dfb2:	48 8b 40 48          	mov    0x48(%rax),%rax
  800420dfb6:	48 89 c2             	mov    %rax,%rdx
  800420dfb9:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dfc0:	00 00 00 
  800420dfc3:	48 89 50 50          	mov    %rdx,0x50(%rax)
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
  800420dfc7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420dfca:	48 98                	cltq   
  800420dfcc:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420dfd3:	ff 
  800420dfd4:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420dfd8:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420dfdf:	00 00 00 
  800420dfe2:	48 89 50 58          	mov    %rdx,0x58(%rax)
  800420dfe6:	e9 0a 01 00 00       	jmpq   800420e0f5 <read_section_headers+0x71f>
		}
		else if(!strcmp(name, ".debug_str"))
  800420dfeb:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  800420dfef:	48 be 1b ff 20 04 80 	movabs $0x800420ff1b,%rsi
  800420dff6:	00 00 00 
  800420dff9:	48 89 c7             	mov    %rax,%rdi
  800420dffc:	48 b8 7f 7e 20 04 80 	movabs $0x8004207e7f,%rax
  800420e003:	00 00 00 
  800420e006:	ff d0                	callq  *%rax
  800420e008:	85 c0                	test   %eax,%eax
  800420e00a:	0f 85 e5 00 00 00    	jne    800420e0f5 <read_section_headers+0x71f>
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
				secthdr_ptr[i]->sh_offset, &kvoffset);	
  800420e010:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e013:	48 98                	cltq   
  800420e015:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420e01c:	ff 
			section_info[DEBUG_FRAME].ds_addr = (uintptr_t)section_info[DEBUG_FRAME].ds_data;
			section_info[DEBUG_FRAME].ds_size = secthdr_ptr[i]->sh_size;
		}
		else if(!strcmp(name, ".debug_str"))
		{
			readseg((uint64_t)((char *)kvbase + kvoffset), secthdr_ptr[i]->sh_size, 
  800420e01d:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420e021:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e024:	48 98                	cltq   
  800420e026:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420e02d:	ff 
  800420e02e:	48 8b 70 20          	mov    0x20(%rax),%rsi
  800420e032:	48 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%rcx
  800420e039:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420e03d:	48 01 c8             	add    %rcx,%rax
  800420e040:	48 8d 8d b8 fe ff ff 	lea    -0x148(%rbp),%rcx
  800420e047:	48 89 c7             	mov    %rax,%rdi
  800420e04a:	48 b8 15 e1 20 04 80 	movabs $0x800420e115,%rax
  800420e051:	00 00 00 
  800420e054:	ff d0                	callq  *%rax
				secthdr_ptr[i]->sh_offset, &kvoffset);	
			section_info[DEBUG_STR].ds_data = (uint8_t *)((char *)kvbase + temp) + OFFSET_CORRECT(secthdr_ptr[i]->sh_offset);
  800420e056:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e059:	48 98                	cltq   
  800420e05b:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420e062:	ff 
  800420e063:	48 8b 50 18          	mov    0x18(%rax),%rdx
  800420e067:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e06a:	48 98                	cltq   
  800420e06c:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420e073:	ff 
  800420e074:	48 8b 40 18          	mov    0x18(%rax),%rax
  800420e078:	48 89 85 68 ff ff ff 	mov    %rax,-0x98(%rbp)
  800420e07f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800420e086:	48 25 00 fe ff ff    	and    $0xfffffffffffffe00,%rax
  800420e08c:	48 29 c2             	sub    %rax,%rdx
  800420e08f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420e093:	48 01 c2             	add    %rax,%rdx
  800420e096:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420e09a:	48 01 c2             	add    %rax,%rdx
  800420e09d:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420e0a4:	00 00 00 
  800420e0a7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
  800420e0ae:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420e0b5:	00 00 00 
  800420e0b8:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800420e0bf:	48 89 c2             	mov    %rax,%rdx
  800420e0c2:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420e0c9:	00 00 00 
  800420e0cc:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
  800420e0d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e0d6:	48 98                	cltq   
  800420e0d8:	48 8b 84 c5 c0 fe ff 	mov    -0x140(%rbp,%rax,8),%rax
  800420e0df:	ff 
  800420e0e0:	48 8b 50 20          	mov    0x20(%rax),%rdx
  800420e0e4:	48 b8 00 26 22 04 80 	movabs $0x8004222600,%rax
  800420e0eb:	00 00 00 
  800420e0ee:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
	temp = kvoffset;
	readseg((uint64_t)((char *)kvbase + kvoffset), sec_name->sh_size,
		sec_name->sh_offset, &kvoffset);
	nametab = (char *)((char *)kvbase + temp) + OFFSET_CORRECT(sec_name->sh_offset);	

	for (i = 0; i < numSectionHeaders; i++)
  800420e0f5:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  800420e0f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800420e0fc:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  800420e0ff:	0f 8c f0 fa ff ff    	jl     800420dbf5 <read_section_headers+0x21f>
			section_info[DEBUG_STR].ds_addr = (uintptr_t)section_info[DEBUG_STR].ds_data;
			section_info[DEBUG_STR].ds_size = secthdr_ptr[i]->sh_size;
		}
	}
	
	return ((uintptr_t)kvbase + kvoffset);
  800420e105:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420e109:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
  800420e110:	48 01 d0             	add    %rdx,%rax
}
  800420e113:	c9                   	leaveq 
  800420e114:	c3                   	retq   

000000800420e115 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
void
readseg(uint64_t pa, uint64_t count, uint64_t offset, uint64_t* kvoffset)
{
  800420e115:	55                   	push   %rbp
  800420e116:	48 89 e5             	mov    %rsp,%rbp
  800420e119:	48 83 ec 30          	sub    $0x30,%rsp
  800420e11d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800420e121:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800420e125:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800420e129:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
	uint64_t end_pa;
	uint64_t orgoff = offset;
  800420e12d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420e131:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	end_pa = pa + count;
  800420e135:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420e139:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800420e13d:	48 01 d0             	add    %rdx,%rax
  800420e140:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	assert(pa % SECTSIZE == 0);	
  800420e144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420e148:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420e14d:	48 85 c0             	test   %rax,%rax
  800420e150:	74 35                	je     800420e187 <readseg+0x72>
  800420e152:	48 b9 62 ff 20 04 80 	movabs $0x800420ff62,%rcx
  800420e159:	00 00 00 
  800420e15c:	48 ba 3f ff 20 04 80 	movabs $0x800420ff3f,%rdx
  800420e163:	00 00 00 
  800420e166:	be c0 00 00 00       	mov    $0xc0,%esi
  800420e16b:	48 bf 54 ff 20 04 80 	movabs $0x800420ff54,%rdi
  800420e172:	00 00 00 
  800420e175:	b8 00 00 00 00       	mov    $0x0,%eax
  800420e17a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420e181:	00 00 00 
  800420e184:	41 ff d0             	callq  *%r8
	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
  800420e187:	48 81 65 e8 00 fe ff 	andq   $0xfffffffffffffe00,-0x18(%rbp)
  800420e18e:	ff 

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
  800420e18f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800420e193:	48 c1 e8 09          	shr    $0x9,%rax
  800420e197:	48 83 c0 01          	add    $0x1,%rax
  800420e19b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  800420e19f:	eb 3c                	jmp    800420e1dd <readseg+0xc8>
		readsect((uint8_t*) pa, offset);
  800420e1a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420e1a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420e1a9:	48 89 d6             	mov    %rdx,%rsi
  800420e1ac:	48 89 c7             	mov    %rax,%rdi
  800420e1af:	48 b8 a5 e2 20 04 80 	movabs $0x800420e2a5,%rax
  800420e1b6:	00 00 00 
  800420e1b9:	ff d0                	callq  *%rax
		pa += SECTSIZE;
  800420e1bb:	48 81 45 e8 00 02 00 	addq   $0x200,-0x18(%rbp)
  800420e1c2:	00 
		*kvoffset += SECTSIZE;
  800420e1c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420e1c7:	48 8b 00             	mov    (%rax),%rax
  800420e1ca:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  800420e1d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420e1d5:	48 89 10             	mov    %rdx,(%rax)
		offset++;
  800420e1d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
  800420e1dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420e1e1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  800420e1e5:	72 ba                	jb     800420e1a1 <readseg+0x8c>
		pa += SECTSIZE;
		*kvoffset += SECTSIZE;
		offset++;
	}

	if(((orgoff % SECTSIZE) + count) > SECTSIZE)
  800420e1e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800420e1eb:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420e1f0:	48 89 c2             	mov    %rax,%rdx
  800420e1f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800420e1f7:	48 01 d0             	add    %rdx,%rax
  800420e1fa:	48 3d 00 02 00 00    	cmp    $0x200,%rax
  800420e200:	76 2f                	jbe    800420e231 <readseg+0x11c>
	{
		readsect((uint8_t*) pa, offset);
  800420e202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420e206:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800420e20a:	48 89 d6             	mov    %rdx,%rsi
  800420e20d:	48 89 c7             	mov    %rax,%rdi
  800420e210:	48 b8 a5 e2 20 04 80 	movabs $0x800420e2a5,%rax
  800420e217:	00 00 00 
  800420e21a:	ff d0                	callq  *%rax
		*kvoffset += SECTSIZE;
  800420e21c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420e220:	48 8b 00             	mov    (%rax),%rax
  800420e223:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  800420e22a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420e22e:	48 89 10             	mov    %rdx,(%rax)
	}
	assert(*kvoffset % SECTSIZE == 0);
  800420e231:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800420e235:	48 8b 00             	mov    (%rax),%rax
  800420e238:	25 ff 01 00 00       	and    $0x1ff,%eax
  800420e23d:	48 85 c0             	test   %rax,%rax
  800420e240:	74 35                	je     800420e277 <readseg+0x162>
  800420e242:	48 b9 75 ff 20 04 80 	movabs $0x800420ff75,%rcx
  800420e249:	00 00 00 
  800420e24c:	48 ba 3f ff 20 04 80 	movabs $0x800420ff3f,%rdx
  800420e253:	00 00 00 
  800420e256:	be d6 00 00 00       	mov    $0xd6,%esi
  800420e25b:	48 bf 54 ff 20 04 80 	movabs $0x800420ff54,%rdi
  800420e262:	00 00 00 
  800420e265:	b8 00 00 00 00       	mov    $0x0,%eax
  800420e26a:	49 b8 14 01 20 04 80 	movabs $0x8004200114,%r8
  800420e271:	00 00 00 
  800420e274:	41 ff d0             	callq  *%r8
}
  800420e277:	c9                   	leaveq 
  800420e278:	c3                   	retq   

000000800420e279 <waitdisk>:

void
waitdisk(void)
{
  800420e279:	55                   	push   %rbp
  800420e27a:	48 89 e5             	mov    %rsp,%rbp
  800420e27d:	48 83 ec 10          	sub    $0x10,%rsp
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
  800420e281:	90                   	nop
  800420e282:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800420e289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420e28c:	89 c2                	mov    %eax,%edx
  800420e28e:	ec                   	in     (%dx),%al
  800420e28f:	88 45 fb             	mov    %al,-0x5(%rbp)
	return data;
  800420e292:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800420e296:	0f b6 c0             	movzbl %al,%eax
  800420e299:	25 c0 00 00 00       	and    $0xc0,%eax
  800420e29e:	83 f8 40             	cmp    $0x40,%eax
  800420e2a1:	75 df                	jne    800420e282 <waitdisk+0x9>
		/* do nothing */;
}
  800420e2a3:	c9                   	leaveq 
  800420e2a4:	c3                   	retq   

000000800420e2a5 <readsect>:

void
readsect(void *dst, uint64_t offset)
{
  800420e2a5:	55                   	push   %rbp
  800420e2a6:	48 89 e5             	mov    %rsp,%rbp
  800420e2a9:	48 83 ec 60          	sub    $0x60,%rsp
  800420e2ad:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800420e2b1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
	// wait for disk to be ready
	waitdisk();
  800420e2b5:	48 b8 79 e2 20 04 80 	movabs $0x800420e279,%rax
  800420e2bc:	00 00 00 
  800420e2bf:	ff d0                	callq  *%rax
  800420e2c1:	c7 45 fc f2 01 00 00 	movl   $0x1f2,-0x4(%rbp)
  800420e2c8:	c6 45 fb 01          	movb   $0x1,-0x5(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800420e2cc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800420e2d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800420e2d3:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
  800420e2d4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420e2d8:	0f b6 c0             	movzbl %al,%eax
  800420e2db:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%rbp)
  800420e2e2:	88 45 f3             	mov    %al,-0xd(%rbp)
  800420e2e5:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  800420e2e9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800420e2ec:	ee                   	out    %al,(%dx)
	outb(0x1F4, offset >> 8);
  800420e2ed:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420e2f1:	48 c1 e8 08          	shr    $0x8,%rax
  800420e2f5:	0f b6 c0             	movzbl %al,%eax
  800420e2f8:	c7 45 ec f4 01 00 00 	movl   $0x1f4,-0x14(%rbp)
  800420e2ff:	88 45 eb             	mov    %al,-0x15(%rbp)
  800420e302:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  800420e306:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800420e309:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
  800420e30a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420e30e:	48 c1 e8 10          	shr    $0x10,%rax
  800420e312:	0f b6 c0             	movzbl %al,%eax
  800420e315:	c7 45 e4 f5 01 00 00 	movl   $0x1f5,-0x1c(%rbp)
  800420e31c:	88 45 e3             	mov    %al,-0x1d(%rbp)
  800420e31f:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  800420e323:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800420e326:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
  800420e327:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800420e32b:	48 c1 e8 18          	shr    $0x18,%rax
  800420e32f:	83 c8 e0             	or     $0xffffffe0,%eax
  800420e332:	0f b6 c0             	movzbl %al,%eax
  800420e335:	c7 45 dc f6 01 00 00 	movl   $0x1f6,-0x24(%rbp)
  800420e33c:	88 45 db             	mov    %al,-0x25(%rbp)
  800420e33f:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  800420e343:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800420e346:	ee                   	out    %al,(%dx)
  800420e347:	c7 45 d4 f7 01 00 00 	movl   $0x1f7,-0x2c(%rbp)
  800420e34e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
  800420e352:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  800420e356:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800420e359:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
  800420e35a:	48 b8 79 e2 20 04 80 	movabs $0x800420e279,%rax
  800420e361:	00 00 00 
  800420e364:	ff d0                	callq  *%rax
  800420e366:	c7 45 cc f0 01 00 00 	movl   $0x1f0,-0x34(%rbp)
  800420e36d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800420e371:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800420e375:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800420e37c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800420e37f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800420e383:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800420e386:	48 89 ce             	mov    %rcx,%rsi
  800420e389:	48 89 f7             	mov    %rsi,%rdi
  800420e38c:	89 c1                	mov    %eax,%ecx
  800420e38e:	fc                   	cld    
  800420e38f:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  800420e391:	89 c8                	mov    %ecx,%eax
  800420e393:	48 89 fe             	mov    %rdi,%rsi
  800420e396:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800420e39a:	89 45 bc             	mov    %eax,-0x44(%rbp)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
  800420e39d:	c9                   	leaveq 
  800420e39e:	c3                   	retq   
