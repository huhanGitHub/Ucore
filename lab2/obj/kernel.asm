
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 dd 5c 00 00       	call   c0105d33 <memset>

    cons_init();                // init the console
c0100056:	e8 65 15 00 00       	call   c01015c0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 5e 10 c0 	movl   $0xc0105ec0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 5e 10 c0 	movl   $0xc0105edc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 cb 41 00 00       	call   c010424f <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 a0 16 00 00       	call   c0101729 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 f2 17 00 00       	call   c0101880 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 e3 0c 00 00       	call   c0100d76 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 ff 15 00 00       	call   c0101697 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 ec 0b 00 00       	call   c0100ca8 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 e1 5e 10 c0 	movl   $0xc0105ee1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 ef 5e 10 c0 	movl   $0xc0105eef,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 fd 5e 10 c0 	movl   $0xc0105efd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 0b 5f 10 c0 	movl   $0xc0105f0b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 19 5f 10 c0 	movl   $0xc0105f19,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 28 5f 10 c0 	movl   $0xc0105f28,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 67 5f 10 c0 	movl   $0xc0105f67,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 f2 12 00 00       	call   c01015ec <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 15 52 00 00       	call   c010554c <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 79 12 00 00       	call   c01015ec <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 59 12 00 00       	call   c0101628 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 6c 5f 10 c0    	movl   $0xc0105f6c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 6c 5f 10 c0 	movl   $0xc0105f6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 71 10 c0 	movl   $0xc01071a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 50 1d 11 c0 	movl   $0xc0111d50,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 51 1d 11 c0 	movl   $0xc0111d51,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 6b 47 11 c0 	movl   $0xc011476b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 bb 54 00 00       	call   c0105ba7 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 76 5f 10 c0 	movl   $0xc0105f76,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 8f 5f 10 c0 	movl   $0xc0105f8f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 bc 5e 10 	movl   $0xc0105ebc,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 a7 5f 10 c0 	movl   $0xc0105fa7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 bf 5f 10 c0 	movl   $0xc0105fbf,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 d7 5f 10 c0 	movl   $0xc0105fd7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 f0 5f 10 c0 	movl   $0xc0105ff0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 1a 60 10 c0 	movl   $0xc010601a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
 	uint32_t ebp=read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 82 00 00 00       	jmp    c0100a61 <print_stackframe+0xa7>
	  cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 48 60 10 c0 	movl   $0xc0106048,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
	  for(j=0;j<4;j++){
c01009f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a00:	eb 28                	jmp    c0100a2a <print_stackframe+0x70>
		cprintf("0x%08x ",((uint32_t *)ebp+2)[j]);
c0100a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0f:	01 d0                	add    %edx,%eax
c0100a11:	83 c0 08             	add    $0x8,%eax
c0100a14:	8b 00                	mov    (%eax),%eax
c0100a16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a1a:	c7 04 24 64 60 10 c0 	movl   $0xc0106064,(%esp)
c0100a21:	e8 16 f9 ff ff       	call   c010033c <cprintf>
 	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
	  cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
	  for(j=0;j<4;j++){
c0100a26:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a2a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a2e:	7e d2                	jle    c0100a02 <print_stackframe+0x48>
		cprintf("0x%08x ",((uint32_t *)ebp+2)[j]);
	  }
	  cprintf("\n");
c0100a30:	c7 04 24 6c 60 10 c0 	movl   $0xc010606c,(%esp)
c0100a37:	e8 00 f9 ff ff       	call   c010033c <cprintf>
	  print_debuginfo(eip-1);
c0100a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a3f:	83 e8 01             	sub    $0x1,%eax
c0100a42:	89 04 24             	mov    %eax,(%esp)
c0100a45:	e8 bc fe ff ff       	call   c0100906 <print_debuginfo>
	  eip=((uint32_t *)ebp)[1];
c0100a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4d:	83 c0 04             	add    $0x4,%eax
c0100a50:	8b 00                	mov    (%eax),%eax
c0100a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  ebp=((uint32_t *)ebp)[0];
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	8b 00                	mov    (%eax),%eax
c0100a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
 	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
c0100a5d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a61:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a65:	0f 8e 74 ff ff ff    	jle    c01009df <print_stackframe+0x25>
	  print_debuginfo(eip-1);
	  eip=((uint32_t *)ebp)[1];
	  ebp=((uint32_t *)ebp)[0];

	}
}
c0100a6b:	c9                   	leave  
c0100a6c:	c3                   	ret    

c0100a6d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a6d:	55                   	push   %ebp
c0100a6e:	89 e5                	mov    %esp,%ebp
c0100a70:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a7a:	eb 0c                	jmp    c0100a88 <parse+0x1b>
            *buf ++ = '\0';
c0100a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a7f:	8d 50 01             	lea    0x1(%eax),%edx
c0100a82:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a85:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	0f b6 00             	movzbl (%eax),%eax
c0100a8e:	84 c0                	test   %al,%al
c0100a90:	74 1d                	je     c0100aaf <parse+0x42>
c0100a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a95:	0f b6 00             	movzbl (%eax),%eax
c0100a98:	0f be c0             	movsbl %al,%eax
c0100a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a9f:	c7 04 24 f0 60 10 c0 	movl   $0xc01060f0,(%esp)
c0100aa6:	e8 c9 50 00 00       	call   c0105b74 <strchr>
c0100aab:	85 c0                	test   %eax,%eax
c0100aad:	75 cd                	jne    c0100a7c <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	84 c0                	test   %al,%al
c0100ab7:	75 02                	jne    c0100abb <parse+0x4e>
            break;
c0100ab9:	eb 67                	jmp    c0100b22 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100abb:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100abf:	75 14                	jne    c0100ad5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ac1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ac8:	00 
c0100ac9:	c7 04 24 f5 60 10 c0 	movl   $0xc01060f5,(%esp)
c0100ad0:	e8 67 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad8:	8d 50 01             	lea    0x1(%eax),%edx
c0100adb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ade:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ae8:	01 c2                	add    %eax,%edx
c0100aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aed:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100aef:	eb 04                	jmp    c0100af5 <parse+0x88>
            buf ++;
c0100af1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af8:	0f b6 00             	movzbl (%eax),%eax
c0100afb:	84 c0                	test   %al,%al
c0100afd:	74 1d                	je     c0100b1c <parse+0xaf>
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	0f b6 00             	movzbl (%eax),%eax
c0100b05:	0f be c0             	movsbl %al,%eax
c0100b08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0c:	c7 04 24 f0 60 10 c0 	movl   $0xc01060f0,(%esp)
c0100b13:	e8 5c 50 00 00       	call   c0105b74 <strchr>
c0100b18:	85 c0                	test   %eax,%eax
c0100b1a:	74 d5                	je     c0100af1 <parse+0x84>
            buf ++;
        }
    }
c0100b1c:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b1d:	e9 66 ff ff ff       	jmp    c0100a88 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b25:	c9                   	leave  
c0100b26:	c3                   	ret    

c0100b27 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b27:	55                   	push   %ebp
c0100b28:	89 e5                	mov    %esp,%ebp
c0100b2a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b2d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b37:	89 04 24             	mov    %eax,(%esp)
c0100b3a:	e8 2e ff ff ff       	call   c0100a6d <parse>
c0100b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b46:	75 0a                	jne    c0100b52 <runcmd+0x2b>
        return 0;
c0100b48:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b4d:	e9 85 00 00 00       	jmp    c0100bd7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b59:	eb 5c                	jmp    c0100bb7 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b5b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b61:	89 d0                	mov    %edx,%eax
c0100b63:	01 c0                	add    %eax,%eax
c0100b65:	01 d0                	add    %edx,%eax
c0100b67:	c1 e0 02             	shl    $0x2,%eax
c0100b6a:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b6f:	8b 00                	mov    (%eax),%eax
c0100b71:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b75:	89 04 24             	mov    %eax,(%esp)
c0100b78:	e8 58 4f 00 00       	call   c0105ad5 <strcmp>
c0100b7d:	85 c0                	test   %eax,%eax
c0100b7f:	75 32                	jne    c0100bb3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b84:	89 d0                	mov    %edx,%eax
c0100b86:	01 c0                	add    %eax,%eax
c0100b88:	01 d0                	add    %edx,%eax
c0100b8a:	c1 e0 02             	shl    $0x2,%eax
c0100b8d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b92:	8b 40 08             	mov    0x8(%eax),%eax
c0100b95:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100b98:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100b9e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ba2:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100ba5:	83 c2 04             	add    $0x4,%edx
c0100ba8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bac:	89 0c 24             	mov    %ecx,(%esp)
c0100baf:	ff d0                	call   *%eax
c0100bb1:	eb 24                	jmp    c0100bd7 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bb3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bba:	83 f8 02             	cmp    $0x2,%eax
c0100bbd:	76 9c                	jbe    c0100b5b <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc6:	c7 04 24 13 61 10 c0 	movl   $0xc0106113,(%esp)
c0100bcd:	e8 6a f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bd7:	c9                   	leave  
c0100bd8:	c3                   	ret    

c0100bd9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bd9:	55                   	push   %ebp
c0100bda:	89 e5                	mov    %esp,%ebp
c0100bdc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bdf:	c7 04 24 2c 61 10 c0 	movl   $0xc010612c,(%esp)
c0100be6:	e8 51 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100beb:	c7 04 24 54 61 10 c0 	movl   $0xc0106154,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100bf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bfb:	74 0b                	je     c0100c08 <kmonitor+0x2f>
        print_trapframe(tf);
c0100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c00:	89 04 24             	mov    %eax,(%esp)
c0100c03:	e8 b0 0d 00 00       	call   c01019b8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c08:	c7 04 24 79 61 10 c0 	movl   $0xc0106179,(%esp)
c0100c0f:	e8 1f f6 ff ff       	call   c0100233 <readline>
c0100c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c1b:	74 18                	je     c0100c35 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c27:	89 04 24             	mov    %eax,(%esp)
c0100c2a:	e8 f8 fe ff ff       	call   c0100b27 <runcmd>
c0100c2f:	85 c0                	test   %eax,%eax
c0100c31:	79 02                	jns    c0100c35 <kmonitor+0x5c>
                break;
c0100c33:	eb 02                	jmp    c0100c37 <kmonitor+0x5e>
            }
        }
    }
c0100c35:	eb d1                	jmp    c0100c08 <kmonitor+0x2f>
}
c0100c37:	c9                   	leave  
c0100c38:	c3                   	ret    

c0100c39 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c39:	55                   	push   %ebp
c0100c3a:	89 e5                	mov    %esp,%ebp
c0100c3c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c46:	eb 3f                	jmp    c0100c87 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c4b:	89 d0                	mov    %edx,%eax
c0100c4d:	01 c0                	add    %eax,%eax
c0100c4f:	01 d0                	add    %edx,%eax
c0100c51:	c1 e0 02             	shl    $0x2,%eax
c0100c54:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c59:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5f:	89 d0                	mov    %edx,%eax
c0100c61:	01 c0                	add    %eax,%eax
c0100c63:	01 d0                	add    %edx,%eax
c0100c65:	c1 e0 02             	shl    $0x2,%eax
c0100c68:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6d:	8b 00                	mov    (%eax),%eax
c0100c6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c77:	c7 04 24 7d 61 10 c0 	movl   $0xc010617d,(%esp)
c0100c7e:	e8 b9 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c8a:	83 f8 02             	cmp    $0x2,%eax
c0100c8d:	76 b9                	jbe    c0100c48 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c94:	c9                   	leave  
c0100c95:	c3                   	ret    

c0100c96 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c96:	55                   	push   %ebp
c0100c97:	89 e5                	mov    %esp,%ebp
c0100c99:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c9c:	e8 cf fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca6:	c9                   	leave  
c0100ca7:	c3                   	ret    

c0100ca8 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ca8:	55                   	push   %ebp
c0100ca9:	89 e5                	mov    %esp,%ebp
c0100cab:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cae:	e8 07 fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb8:	c9                   	leave  
c0100cb9:	c3                   	ret    

c0100cba <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cba:	55                   	push   %ebp
c0100cbb:	89 e5                	mov    %esp,%ebp
c0100cbd:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cc0:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cc5:	85 c0                	test   %eax,%eax
c0100cc7:	74 02                	je     c0100ccb <__panic+0x11>
        goto panic_dead;
c0100cc9:	eb 48                	jmp    c0100d13 <__panic+0x59>
    }
    is_panic = 1;
c0100ccb:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cd2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cd5:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cde:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce9:	c7 04 24 86 61 10 c0 	movl   $0xc0106186,(%esp)
c0100cf0:	e8 47 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfc:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cff:	89 04 24             	mov    %eax,(%esp)
c0100d02:	e8 02 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d07:	c7 04 24 a2 61 10 c0 	movl   $0xc01061a2,(%esp)
c0100d0e:	e8 29 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d13:	e8 85 09 00 00       	call   c010169d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d1f:	e8 b5 fe ff ff       	call   c0100bd9 <kmonitor>
    }
c0100d24:	eb f2                	jmp    c0100d18 <__panic+0x5e>

c0100d26 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d26:	55                   	push   %ebp
c0100d27:	89 e5                	mov    %esp,%ebp
c0100d29:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d2c:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d35:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d40:	c7 04 24 a4 61 10 c0 	movl   $0xc01061a4,(%esp)
c0100d47:	e8 f0 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d53:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d56:	89 04 24             	mov    %eax,(%esp)
c0100d59:	e8 ab f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d5e:	c7 04 24 a2 61 10 c0 	movl   $0xc01061a2,(%esp)
c0100d65:	e8 d2 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d6a:	c9                   	leave  
c0100d6b:	c3                   	ret    

c0100d6c <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d6c:	55                   	push   %ebp
c0100d6d:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d6f:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d74:	5d                   	pop    %ebp
c0100d75:	c3                   	ret    

c0100d76 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
c0100d79:	83 ec 28             	sub    $0x28,%esp
c0100d7c:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d82:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d86:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d8a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d8e:	ee                   	out    %al,(%dx)
c0100d8f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d95:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d99:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d9d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da1:	ee                   	out    %al,(%dx)
c0100da2:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100da8:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100db0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100db4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100db5:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dbc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dbf:	c7 04 24 c2 61 10 c0 	movl   $0xc01061c2,(%esp)
c0100dc6:	e8 71 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dd2:	e8 24 09 00 00       	call   c01016fb <pic_enable>
}
c0100dd7:	c9                   	leave  
c0100dd8:	c3                   	ret    

c0100dd9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd9:	55                   	push   %ebp
c0100dda:	89 e5                	mov    %esp,%ebp
c0100ddc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100ddf:	9c                   	pushf  
c0100de0:	58                   	pop    %eax
c0100de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100de7:	25 00 02 00 00       	and    $0x200,%eax
c0100dec:	85 c0                	test   %eax,%eax
c0100dee:	74 0c                	je     c0100dfc <__intr_save+0x23>
        intr_disable();
c0100df0:	e8 a8 08 00 00       	call   c010169d <intr_disable>
        return 1;
c0100df5:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dfa:	eb 05                	jmp    c0100e01 <__intr_save+0x28>
    }
    return 0;
c0100dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e01:	c9                   	leave  
c0100e02:	c3                   	ret    

c0100e03 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e03:	55                   	push   %ebp
c0100e04:	89 e5                	mov    %esp,%ebp
c0100e06:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e0d:	74 05                	je     c0100e14 <__intr_restore+0x11>
        intr_enable();
c0100e0f:	e8 83 08 00 00       	call   c0101697 <intr_enable>
    }
}
c0100e14:	c9                   	leave  
c0100e15:	c3                   	ret    

c0100e16 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e16:	55                   	push   %ebp
c0100e17:	89 e5                	mov    %esp,%ebp
c0100e19:	83 ec 10             	sub    $0x10,%esp
c0100e1c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e22:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e26:	89 c2                	mov    %eax,%edx
c0100e28:	ec                   	in     (%dx),%al
c0100e29:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e2c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e32:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e36:	89 c2                	mov    %eax,%edx
c0100e38:	ec                   	in     (%dx),%al
c0100e39:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e3c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e42:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e46:	89 c2                	mov    %eax,%edx
c0100e48:	ec                   	in     (%dx),%al
c0100e49:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e4c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e52:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e56:	89 c2                	mov    %eax,%edx
c0100e58:	ec                   	in     (%dx),%al
c0100e59:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e5c:	c9                   	leave  
c0100e5d:	c3                   	ret    

c0100e5e <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e5e:	55                   	push   %ebp
c0100e5f:	89 e5                	mov    %esp,%ebp
c0100e61:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e64:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e6e:	0f b7 00             	movzwl (%eax),%eax
c0100e71:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e78:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e80:	0f b7 00             	movzwl (%eax),%eax
c0100e83:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e87:	74 12                	je     c0100e9b <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e89:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e90:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e97:	b4 03 
c0100e99:	eb 13                	jmp    c0100eae <cga_init+0x50>
    } else {
        *cp = was;
c0100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea2:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ea5:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eac:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eae:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eb5:	0f b7 c0             	movzwl %ax,%eax
c0100eb8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ebc:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ec4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec8:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ec9:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ed0:	83 c0 01             	add    $0x1,%eax
c0100ed3:	0f b7 c0             	movzwl %ax,%eax
c0100ed6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eda:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ede:	89 c2                	mov    %eax,%edx
c0100ee0:	ec                   	in     (%dx),%al
c0100ee1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ee4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ee8:	0f b6 c0             	movzbl %al,%eax
c0100eeb:	c1 e0 08             	shl    $0x8,%eax
c0100eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ef1:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef8:	0f b7 c0             	movzwl %ax,%eax
c0100efb:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100eff:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f03:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f07:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f0b:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f0c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f13:	83 c0 01             	add    $0x1,%eax
c0100f16:	0f b7 c0             	movzwl %ax,%eax
c0100f19:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f1d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f21:	89 c2                	mov    %eax,%edx
c0100f23:	ec                   	in     (%dx),%al
c0100f24:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f27:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f2b:	0f b6 c0             	movzbl %al,%eax
c0100f2e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f34:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f3c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f42:	c9                   	leave  
c0100f43:	c3                   	ret    

c0100f44 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f44:	55                   	push   %ebp
c0100f45:	89 e5                	mov    %esp,%ebp
c0100f47:	83 ec 48             	sub    $0x48,%esp
c0100f4a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f50:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f54:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f58:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f5c:	ee                   	out    %al,(%dx)
c0100f5d:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f63:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f6b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f6f:	ee                   	out    %al,(%dx)
c0100f70:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f76:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f7a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f7e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f82:	ee                   	out    %al,(%dx)
c0100f83:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f89:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f8d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f91:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f95:	ee                   	out    %al,(%dx)
c0100f96:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100f9c:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fa0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fa4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
c0100fa9:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100faf:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fb3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fb7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fbb:	ee                   	out    %al,(%dx)
c0100fbc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fc2:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fc6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fca:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fce:	ee                   	out    %al,(%dx)
c0100fcf:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd5:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fd9:	89 c2                	mov    %eax,%edx
c0100fdb:	ec                   	in     (%dx),%al
c0100fdc:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fdf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fe3:	3c ff                	cmp    $0xff,%al
c0100fe5:	0f 95 c0             	setne  %al
c0100fe8:	0f b6 c0             	movzbl %al,%eax
c0100feb:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ff0:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff6:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100ffa:	89 c2                	mov    %eax,%edx
c0100ffc:	ec                   	in     (%dx),%al
c0100ffd:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101000:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101006:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010100a:	89 c2                	mov    %eax,%edx
c010100c:	ec                   	in     (%dx),%al
c010100d:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101010:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101015:	85 c0                	test   %eax,%eax
c0101017:	74 0c                	je     c0101025 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101019:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101020:	e8 d6 06 00 00       	call   c01016fb <pic_enable>
    }
}
c0101025:	c9                   	leave  
c0101026:	c3                   	ret    

c0101027 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101027:	55                   	push   %ebp
c0101028:	89 e5                	mov    %esp,%ebp
c010102a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010102d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101034:	eb 09                	jmp    c010103f <lpt_putc_sub+0x18>
        delay();
c0101036:	e8 db fd ff ff       	call   c0100e16 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010103f:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101045:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101049:	89 c2                	mov    %eax,%edx
c010104b:	ec                   	in     (%dx),%al
c010104c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010104f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101053:	84 c0                	test   %al,%al
c0101055:	78 09                	js     c0101060 <lpt_putc_sub+0x39>
c0101057:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010105e:	7e d6                	jle    c0101036 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101060:	8b 45 08             	mov    0x8(%ebp),%eax
c0101063:	0f b6 c0             	movzbl %al,%eax
c0101066:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010106c:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010107e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101082:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101086:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0101091:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0101095:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101099:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010109e:	c9                   	leave  
c010109f:	c3                   	ret    

c01010a0 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010a0:	55                   	push   %ebp
c01010a1:	89 e5                	mov    %esp,%ebp
c01010a3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010a6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010aa:	74 0d                	je     c01010b9 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01010af:	89 04 24             	mov    %eax,(%esp)
c01010b2:	e8 70 ff ff ff       	call   c0101027 <lpt_putc_sub>
c01010b7:	eb 24                	jmp    c01010dd <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010b9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010c0:	e8 62 ff ff ff       	call   c0101027 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010cc:	e8 56 ff ff ff       	call   c0101027 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010d1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d8:	e8 4a ff ff ff       	call   c0101027 <lpt_putc_sub>
    }
}
c01010dd:	c9                   	leave  
c01010de:	c3                   	ret    

c01010df <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010df:	55                   	push   %ebp
c01010e0:	89 e5                	mov    %esp,%ebp
c01010e2:	53                   	push   %ebx
c01010e3:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e9:	b0 00                	mov    $0x0,%al
c01010eb:	85 c0                	test   %eax,%eax
c01010ed:	75 07                	jne    c01010f6 <cga_putc+0x17>
        c |= 0x0700;
c01010ef:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f9:	0f b6 c0             	movzbl %al,%eax
c01010fc:	83 f8 0a             	cmp    $0xa,%eax
c01010ff:	74 4c                	je     c010114d <cga_putc+0x6e>
c0101101:	83 f8 0d             	cmp    $0xd,%eax
c0101104:	74 57                	je     c010115d <cga_putc+0x7e>
c0101106:	83 f8 08             	cmp    $0x8,%eax
c0101109:	0f 85 88 00 00 00    	jne    c0101197 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010110f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101116:	66 85 c0             	test   %ax,%ax
c0101119:	74 30                	je     c010114b <cga_putc+0x6c>
            crt_pos --;
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	83 e8 01             	sub    $0x1,%eax
c0101125:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010112b:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101130:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101137:	0f b7 d2             	movzwl %dx,%edx
c010113a:	01 d2                	add    %edx,%edx
c010113c:	01 c2                	add    %eax,%edx
c010113e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101141:	b0 00                	mov    $0x0,%al
c0101143:	83 c8 20             	or     $0x20,%eax
c0101146:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101149:	eb 72                	jmp    c01011bd <cga_putc+0xde>
c010114b:	eb 70                	jmp    c01011bd <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010114d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101154:	83 c0 50             	add    $0x50,%eax
c0101157:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010115d:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101164:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010116b:	0f b7 c1             	movzwl %cx,%eax
c010116e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101174:	c1 e8 10             	shr    $0x10,%eax
c0101177:	89 c2                	mov    %eax,%edx
c0101179:	66 c1 ea 06          	shr    $0x6,%dx
c010117d:	89 d0                	mov    %edx,%eax
c010117f:	c1 e0 02             	shl    $0x2,%eax
c0101182:	01 d0                	add    %edx,%eax
c0101184:	c1 e0 04             	shl    $0x4,%eax
c0101187:	29 c1                	sub    %eax,%ecx
c0101189:	89 ca                	mov    %ecx,%edx
c010118b:	89 d8                	mov    %ebx,%eax
c010118d:	29 d0                	sub    %edx,%eax
c010118f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101195:	eb 26                	jmp    c01011bd <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101197:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c010119d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011a4:	8d 50 01             	lea    0x1(%eax),%edx
c01011a7:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ae:	0f b7 c0             	movzwl %ax,%eax
c01011b1:	01 c0                	add    %eax,%eax
c01011b3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b9:	66 89 02             	mov    %ax,(%edx)
        break;
c01011bc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011bd:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011c4:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011c8:	76 5b                	jbe    c0101225 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ca:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011cf:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011d5:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011da:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011e1:	00 
c01011e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011e6:	89 04 24             	mov    %eax,(%esp)
c01011e9:	e8 84 4b 00 00       	call   c0105d72 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011ee:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011f5:	eb 15                	jmp    c010120c <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c01011f7:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011ff:	01 d2                	add    %edx,%edx
c0101201:	01 d0                	add    %edx,%eax
c0101203:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101208:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010120c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101213:	7e e2                	jle    c01011f7 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101215:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010121c:	83 e8 50             	sub    $0x50,%eax
c010121f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101225:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010122c:	0f b7 c0             	movzwl %ax,%eax
c010122f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101233:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101237:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010123b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010123f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101240:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101247:	66 c1 e8 08          	shr    $0x8,%ax
c010124b:	0f b6 c0             	movzbl %al,%eax
c010124e:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101255:	83 c2 01             	add    $0x1,%edx
c0101258:	0f b7 d2             	movzwl %dx,%edx
c010125b:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010125f:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101262:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101266:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010126a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010126b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101272:	0f b7 c0             	movzwl %ax,%eax
c0101275:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101279:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010127d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101281:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101285:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101286:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010128d:	0f b6 c0             	movzbl %al,%eax
c0101290:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101297:	83 c2 01             	add    $0x1,%edx
c010129a:	0f b7 d2             	movzwl %dx,%edx
c010129d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012a1:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012a4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012a8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ac:	ee                   	out    %al,(%dx)
}
c01012ad:	83 c4 34             	add    $0x34,%esp
c01012b0:	5b                   	pop    %ebx
c01012b1:	5d                   	pop    %ebp
c01012b2:	c3                   	ret    

c01012b3 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012b3:	55                   	push   %ebp
c01012b4:	89 e5                	mov    %esp,%ebp
c01012b6:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012c0:	eb 09                	jmp    c01012cb <serial_putc_sub+0x18>
        delay();
c01012c2:	e8 4f fb ff ff       	call   c0100e16 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012cb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012d1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012d5:	89 c2                	mov    %eax,%edx
c01012d7:	ec                   	in     (%dx),%al
c01012d8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012db:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012df:	0f b6 c0             	movzbl %al,%eax
c01012e2:	83 e0 20             	and    $0x20,%eax
c01012e5:	85 c0                	test   %eax,%eax
c01012e7:	75 09                	jne    c01012f2 <serial_putc_sub+0x3f>
c01012e9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012f0:	7e d0                	jle    c01012c2 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01012f5:	0f b6 c0             	movzbl %al,%eax
c01012f8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01012fe:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101301:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101305:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101309:	ee                   	out    %al,(%dx)
}
c010130a:	c9                   	leave  
c010130b:	c3                   	ret    

c010130c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010130c:	55                   	push   %ebp
c010130d:	89 e5                	mov    %esp,%ebp
c010130f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101312:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101316:	74 0d                	je     c0101325 <serial_putc+0x19>
        serial_putc_sub(c);
c0101318:	8b 45 08             	mov    0x8(%ebp),%eax
c010131b:	89 04 24             	mov    %eax,(%esp)
c010131e:	e8 90 ff ff ff       	call   c01012b3 <serial_putc_sub>
c0101323:	eb 24                	jmp    c0101349 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101325:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010132c:	e8 82 ff ff ff       	call   c01012b3 <serial_putc_sub>
        serial_putc_sub(' ');
c0101331:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101338:	e8 76 ff ff ff       	call   c01012b3 <serial_putc_sub>
        serial_putc_sub('\b');
c010133d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101344:	e8 6a ff ff ff       	call   c01012b3 <serial_putc_sub>
    }
}
c0101349:	c9                   	leave  
c010134a:	c3                   	ret    

c010134b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010134b:	55                   	push   %ebp
c010134c:	89 e5                	mov    %esp,%ebp
c010134e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101351:	eb 33                	jmp    c0101386 <cons_intr+0x3b>
        if (c != 0) {
c0101353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101357:	74 2d                	je     c0101386 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101359:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010135e:	8d 50 01             	lea    0x1(%eax),%edx
c0101361:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101367:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010136a:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101370:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101375:	3d 00 02 00 00       	cmp    $0x200,%eax
c010137a:	75 0a                	jne    c0101386 <cons_intr+0x3b>
                cons.wpos = 0;
c010137c:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101383:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101386:	8b 45 08             	mov    0x8(%ebp),%eax
c0101389:	ff d0                	call   *%eax
c010138b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010138e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101392:	75 bf                	jne    c0101353 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101394:	c9                   	leave  
c0101395:	c3                   	ret    

c0101396 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101396:	55                   	push   %ebp
c0101397:	89 e5                	mov    %esp,%ebp
c0101399:	83 ec 10             	sub    $0x10,%esp
c010139c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a6:	89 c2                	mov    %eax,%edx
c01013a8:	ec                   	in     (%dx),%al
c01013a9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ac:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013b0:	0f b6 c0             	movzbl %al,%eax
c01013b3:	83 e0 01             	and    $0x1,%eax
c01013b6:	85 c0                	test   %eax,%eax
c01013b8:	75 07                	jne    c01013c1 <serial_proc_data+0x2b>
        return -1;
c01013ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013bf:	eb 2a                	jmp    c01013eb <serial_proc_data+0x55>
c01013c1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013cb:	89 c2                	mov    %eax,%edx
c01013cd:	ec                   	in     (%dx),%al
c01013ce:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013d1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013d5:	0f b6 c0             	movzbl %al,%eax
c01013d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013db:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013df:	75 07                	jne    c01013e8 <serial_proc_data+0x52>
        c = '\b';
c01013e1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013eb:	c9                   	leave  
c01013ec:	c3                   	ret    

c01013ed <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013ed:	55                   	push   %ebp
c01013ee:	89 e5                	mov    %esp,%ebp
c01013f0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013f3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013f8:	85 c0                	test   %eax,%eax
c01013fa:	74 0c                	je     c0101408 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c01013fc:	c7 04 24 96 13 10 c0 	movl   $0xc0101396,(%esp)
c0101403:	e8 43 ff ff ff       	call   c010134b <cons_intr>
    }
}
c0101408:	c9                   	leave  
c0101409:	c3                   	ret    

c010140a <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010140a:	55                   	push   %ebp
c010140b:	89 e5                	mov    %esp,%ebp
c010140d:	83 ec 38             	sub    $0x38,%esp
c0101410:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101416:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010141a:	89 c2                	mov    %eax,%edx
c010141c:	ec                   	in     (%dx),%al
c010141d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101420:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101424:	0f b6 c0             	movzbl %al,%eax
c0101427:	83 e0 01             	and    $0x1,%eax
c010142a:	85 c0                	test   %eax,%eax
c010142c:	75 0a                	jne    c0101438 <kbd_proc_data+0x2e>
        return -1;
c010142e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101433:	e9 59 01 00 00       	jmp    c0101591 <kbd_proc_data+0x187>
c0101438:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101442:	89 c2                	mov    %eax,%edx
c0101444:	ec                   	in     (%dx),%al
c0101445:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101448:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010144c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010144f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101453:	75 17                	jne    c010146c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101455:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010145a:	83 c8 40             	or     $0x40,%eax
c010145d:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101462:	b8 00 00 00 00       	mov    $0x0,%eax
c0101467:	e9 25 01 00 00       	jmp    c0101591 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010146c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101470:	84 c0                	test   %al,%al
c0101472:	79 47                	jns    c01014bb <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101474:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101479:	83 e0 40             	and    $0x40,%eax
c010147c:	85 c0                	test   %eax,%eax
c010147e:	75 09                	jne    c0101489 <kbd_proc_data+0x7f>
c0101480:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101484:	83 e0 7f             	and    $0x7f,%eax
c0101487:	eb 04                	jmp    c010148d <kbd_proc_data+0x83>
c0101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101490:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101494:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010149b:	83 c8 40             	or     $0x40,%eax
c010149e:	0f b6 c0             	movzbl %al,%eax
c01014a1:	f7 d0                	not    %eax
c01014a3:	89 c2                	mov    %eax,%edx
c01014a5:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014aa:	21 d0                	and    %edx,%eax
c01014ac:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014b1:	b8 00 00 00 00       	mov    $0x0,%eax
c01014b6:	e9 d6 00 00 00       	jmp    c0101591 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014bb:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c0:	83 e0 40             	and    $0x40,%eax
c01014c3:	85 c0                	test   %eax,%eax
c01014c5:	74 11                	je     c01014d8 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014c7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014cb:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d0:	83 e0 bf             	and    $0xffffffbf,%eax
c01014d3:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014d8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014dc:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014e3:	0f b6 d0             	movzbl %al,%edx
c01014e6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014eb:	09 d0                	or     %edx,%eax
c01014ed:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f6:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014fd:	0f b6 d0             	movzbl %al,%edx
c0101500:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101505:	31 d0                	xor    %edx,%eax
c0101507:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	83 e0 03             	and    $0x3,%eax
c0101514:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010151b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151f:	01 d0                	add    %edx,%eax
c0101521:	0f b6 00             	movzbl (%eax),%eax
c0101524:	0f b6 c0             	movzbl %al,%eax
c0101527:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010152a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010152f:	83 e0 08             	and    $0x8,%eax
c0101532:	85 c0                	test   %eax,%eax
c0101534:	74 22                	je     c0101558 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101536:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010153a:	7e 0c                	jle    c0101548 <kbd_proc_data+0x13e>
c010153c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101540:	7f 06                	jg     c0101548 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101542:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101546:	eb 10                	jmp    c0101558 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101548:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010154c:	7e 0a                	jle    c0101558 <kbd_proc_data+0x14e>
c010154e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101552:	7f 04                	jg     c0101558 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101554:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101558:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010155d:	f7 d0                	not    %eax
c010155f:	83 e0 06             	and    $0x6,%eax
c0101562:	85 c0                	test   %eax,%eax
c0101564:	75 28                	jne    c010158e <kbd_proc_data+0x184>
c0101566:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010156d:	75 1f                	jne    c010158e <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010156f:	c7 04 24 dd 61 10 c0 	movl   $0xc01061dd,(%esp)
c0101576:	e8 c1 ed ff ff       	call   c010033c <cprintf>
c010157b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101581:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101585:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101589:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010158d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101591:	c9                   	leave  
c0101592:	c3                   	ret    

c0101593 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101593:	55                   	push   %ebp
c0101594:	89 e5                	mov    %esp,%ebp
c0101596:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101599:	c7 04 24 0a 14 10 c0 	movl   $0xc010140a,(%esp)
c01015a0:	e8 a6 fd ff ff       	call   c010134b <cons_intr>
}
c01015a5:	c9                   	leave  
c01015a6:	c3                   	ret    

c01015a7 <kbd_init>:

static void
kbd_init(void) {
c01015a7:	55                   	push   %ebp
c01015a8:	89 e5                	mov    %esp,%ebp
c01015aa:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ad:	e8 e1 ff ff ff       	call   c0101593 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015b9:	e8 3d 01 00 00       	call   c01016fb <pic_enable>
}
c01015be:	c9                   	leave  
c01015bf:	c3                   	ret    

c01015c0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015c0:	55                   	push   %ebp
c01015c1:	89 e5                	mov    %esp,%ebp
c01015c3:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015c6:	e8 93 f8 ff ff       	call   c0100e5e <cga_init>
    serial_init();
c01015cb:	e8 74 f9 ff ff       	call   c0100f44 <serial_init>
    kbd_init();
c01015d0:	e8 d2 ff ff ff       	call   c01015a7 <kbd_init>
    if (!serial_exists) {
c01015d5:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015da:	85 c0                	test   %eax,%eax
c01015dc:	75 0c                	jne    c01015ea <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015de:	c7 04 24 e9 61 10 c0 	movl   $0xc01061e9,(%esp)
c01015e5:	e8 52 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015ea:	c9                   	leave  
c01015eb:	c3                   	ret    

c01015ec <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015ec:	55                   	push   %ebp
c01015ed:	89 e5                	mov    %esp,%ebp
c01015ef:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015f2:	e8 e2 f7 ff ff       	call   c0100dd9 <__intr_save>
c01015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01015fd:	89 04 24             	mov    %eax,(%esp)
c0101600:	e8 9b fa ff ff       	call   c01010a0 <lpt_putc>
        cga_putc(c);
c0101605:	8b 45 08             	mov    0x8(%ebp),%eax
c0101608:	89 04 24             	mov    %eax,(%esp)
c010160b:	e8 cf fa ff ff       	call   c01010df <cga_putc>
        serial_putc(c);
c0101610:	8b 45 08             	mov    0x8(%ebp),%eax
c0101613:	89 04 24             	mov    %eax,(%esp)
c0101616:	e8 f1 fc ff ff       	call   c010130c <serial_putc>
    }
    local_intr_restore(intr_flag);
c010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010161e:	89 04 24             	mov    %eax,(%esp)
c0101621:	e8 dd f7 ff ff       	call   c0100e03 <__intr_restore>
}
c0101626:	c9                   	leave  
c0101627:	c3                   	ret    

c0101628 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101628:	55                   	push   %ebp
c0101629:	89 e5                	mov    %esp,%ebp
c010162b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010162e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101635:	e8 9f f7 ff ff       	call   c0100dd9 <__intr_save>
c010163a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010163d:	e8 ab fd ff ff       	call   c01013ed <serial_intr>
        kbd_intr();
c0101642:	e8 4c ff ff ff       	call   c0101593 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101647:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010164d:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101652:	39 c2                	cmp    %eax,%edx
c0101654:	74 31                	je     c0101687 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101656:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010165b:	8d 50 01             	lea    0x1(%eax),%edx
c010165e:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101664:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010166b:	0f b6 c0             	movzbl %al,%eax
c010166e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101671:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101676:	3d 00 02 00 00       	cmp    $0x200,%eax
c010167b:	75 0a                	jne    c0101687 <cons_getc+0x5f>
                cons.rpos = 0;
c010167d:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101684:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101687:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010168a:	89 04 24             	mov    %eax,(%esp)
c010168d:	e8 71 f7 ff ff       	call   c0100e03 <__intr_restore>
    return c;
c0101692:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101695:	c9                   	leave  
c0101696:	c3                   	ret    

c0101697 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101697:	55                   	push   %ebp
c0101698:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010169a:	fb                   	sti    
    sti();
}
c010169b:	5d                   	pop    %ebp
c010169c:	c3                   	ret    

c010169d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016a0:	fa                   	cli    
    cli();
}
c01016a1:	5d                   	pop    %ebp
c01016a2:	c3                   	ret    

c01016a3 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
c01016a6:	83 ec 14             	sub    $0x14,%esp
c01016a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ac:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016b4:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016ba:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016bf:	85 c0                	test   %eax,%eax
c01016c1:	74 36                	je     c01016f9 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c7:	0f b6 c0             	movzbl %al,%eax
c01016ca:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016d0:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016db:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016dc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e0:	66 c1 e8 08          	shr    $0x8,%ax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016ed:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016f8:	ee                   	out    %al,(%dx)
    }
}
c01016f9:	c9                   	leave  
c01016fa:	c3                   	ret    

c01016fb <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016fb:	55                   	push   %ebp
c01016fc:	89 e5                	mov    %esp,%ebp
c01016fe:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101701:	8b 45 08             	mov    0x8(%ebp),%eax
c0101704:	ba 01 00 00 00       	mov    $0x1,%edx
c0101709:	89 c1                	mov    %eax,%ecx
c010170b:	d3 e2                	shl    %cl,%edx
c010170d:	89 d0                	mov    %edx,%eax
c010170f:	f7 d0                	not    %eax
c0101711:	89 c2                	mov    %eax,%edx
c0101713:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010171a:	21 d0                	and    %edx,%eax
c010171c:	0f b7 c0             	movzwl %ax,%eax
c010171f:	89 04 24             	mov    %eax,(%esp)
c0101722:	e8 7c ff ff ff       	call   c01016a3 <pic_setmask>
}
c0101727:	c9                   	leave  
c0101728:	c3                   	ret    

c0101729 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101729:	55                   	push   %ebp
c010172a:	89 e5                	mov    %esp,%ebp
c010172c:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010172f:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101736:	00 00 00 
c0101739:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010173f:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101743:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101747:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010174b:	ee                   	out    %al,(%dx)
c010174c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101752:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101756:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010175a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010175e:	ee                   	out    %al,(%dx)
c010175f:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101765:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101769:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010176d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101778:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010177c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101780:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
c0101785:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010178b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010178f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101793:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101797:	ee                   	out    %al,(%dx)
c0101798:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010179e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017a2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017a6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017aa:	ee                   	out    %al,(%dx)
c01017ab:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017b1:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
c01017be:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017c4:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017c8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017cc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017d0:	ee                   	out    %al,(%dx)
c01017d1:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017d7:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017db:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017df:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017e3:	ee                   	out    %al,(%dx)
c01017e4:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017ea:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017ee:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017f2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017f6:	ee                   	out    %al,(%dx)
c01017f7:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01017fd:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101801:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101805:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101810:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101814:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101818:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101823:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101827:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010182b:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101836:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010183a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010183e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101843:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010184a:	66 83 f8 ff          	cmp    $0xffff,%ax
c010184e:	74 12                	je     c0101862 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101850:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101857:	0f b7 c0             	movzwl %ax,%eax
c010185a:	89 04 24             	mov    %eax,(%esp)
c010185d:	e8 41 fe ff ff       	call   c01016a3 <pic_setmask>
    }
}
c0101862:	c9                   	leave  
c0101863:	c3                   	ret    

c0101864 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101864:	55                   	push   %ebp
c0101865:	89 e5                	mov    %esp,%ebp
c0101867:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010186a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101871:	00 
c0101872:	c7 04 24 20 62 10 c0 	movl   $0xc0106220,(%esp)
c0101879:	e8 be ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010187e:	c9                   	leave  
c010187f:	c3                   	ret    

c0101880 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101880:	55                   	push   %ebp
c0101881:	89 e5                	mov    %esp,%ebp
c0101883:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 255; i ++) {
c0101886:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010188d:	e9 c3 00 00 00       	jmp    c0101955 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101892:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101895:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010189c:	89 c2                	mov    %eax,%edx
c010189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a1:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018a8:	c0 
c01018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ac:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018b3:	c0 08 00 
c01018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b9:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018c0:	c0 
c01018c1:	83 e2 e0             	and    $0xffffffe0,%edx
c01018c4:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ce:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d5:	c0 
c01018d6:	83 e2 1f             	and    $0x1f,%edx
c01018d9:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e3:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018ea:	c0 
c01018eb:	83 e2 f0             	and    $0xfffffff0,%edx
c01018ee:	83 ca 0e             	or     $0xe,%edx
c01018f1:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101902:	c0 
c0101903:	83 e2 ef             	and    $0xffffffef,%edx
c0101906:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101910:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101917:	c0 
c0101918:	83 e2 9f             	and    $0xffffff9f,%edx
c010191b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101925:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192c:	c0 
c010192d:	83 ca 80             	or     $0xffffff80,%edx
c0101930:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193a:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101941:	c1 e8 10             	shr    $0x10,%eax
c0101944:	89 c2                	mov    %eax,%edx
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101950:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 255; i ++) {
c0101951:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101955:	81 7d fc fe 00 00 00 	cmpl   $0xfe,-0x4(%ebp)
c010195c:	0f 8e 30 ff ff ff    	jle    c0101892 <idt_init+0x12>
c0101962:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101969:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010196c:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c010196f:	c9                   	leave  
c0101970:	c3                   	ret    

c0101971 <trapname>:

static const char *
trapname(int trapno) {
c0101971:	55                   	push   %ebp
c0101972:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101974:	8b 45 08             	mov    0x8(%ebp),%eax
c0101977:	83 f8 13             	cmp    $0x13,%eax
c010197a:	77 0c                	ja     c0101988 <trapname+0x17>
        return excnames[trapno];
c010197c:	8b 45 08             	mov    0x8(%ebp),%eax
c010197f:	8b 04 85 80 65 10 c0 	mov    -0x3fef9a80(,%eax,4),%eax
c0101986:	eb 18                	jmp    c01019a0 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101988:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010198c:	7e 0d                	jle    c010199b <trapname+0x2a>
c010198e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101992:	7f 07                	jg     c010199b <trapname+0x2a>
        return "Hardware Interrupt";
c0101994:	b8 2a 62 10 c0       	mov    $0xc010622a,%eax
c0101999:	eb 05                	jmp    c01019a0 <trapname+0x2f>
    }
    return "(unknown trap)";
c010199b:	b8 3d 62 10 c0       	mov    $0xc010623d,%eax
}
c01019a0:	5d                   	pop    %ebp
c01019a1:	c3                   	ret    

c01019a2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019a2:	55                   	push   %ebp
c01019a3:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019ac:	66 83 f8 08          	cmp    $0x8,%ax
c01019b0:	0f 94 c0             	sete   %al
c01019b3:	0f b6 c0             	movzbl %al,%eax
}
c01019b6:	5d                   	pop    %ebp
c01019b7:	c3                   	ret    

c01019b8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019b8:	55                   	push   %ebp
c01019b9:	89 e5                	mov    %esp,%ebp
c01019bb:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019be:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019c5:	c7 04 24 7e 62 10 c0 	movl   $0xc010627e,(%esp)
c01019cc:	e8 6b e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c01019d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d4:	89 04 24             	mov    %eax,(%esp)
c01019d7:	e8 a1 01 00 00       	call   c0101b7d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01019dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019df:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01019e3:	0f b7 c0             	movzwl %ax,%eax
c01019e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019ea:	c7 04 24 8f 62 10 c0 	movl   $0xc010628f,(%esp)
c01019f1:	e8 46 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01019f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01019fd:	0f b7 c0             	movzwl %ax,%eax
c0101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a04:	c7 04 24 a2 62 10 c0 	movl   $0xc01062a2,(%esp)
c0101a0b:	e8 2c e9 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a13:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a17:	0f b7 c0             	movzwl %ax,%eax
c0101a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1e:	c7 04 24 b5 62 10 c0 	movl   $0xc01062b5,(%esp)
c0101a25:	e8 12 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a31:	0f b7 c0             	movzwl %ax,%eax
c0101a34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a38:	c7 04 24 c8 62 10 c0 	movl   $0xc01062c8,(%esp)
c0101a3f:	e8 f8 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a47:	8b 40 30             	mov    0x30(%eax),%eax
c0101a4a:	89 04 24             	mov    %eax,(%esp)
c0101a4d:	e8 1f ff ff ff       	call   c0101971 <trapname>
c0101a52:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a55:	8b 52 30             	mov    0x30(%edx),%edx
c0101a58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a60:	c7 04 24 db 62 10 c0 	movl   $0xc01062db,(%esp)
c0101a67:	e8 d0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6f:	8b 40 34             	mov    0x34(%eax),%eax
c0101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a76:	c7 04 24 ed 62 10 c0 	movl   $0xc01062ed,(%esp)
c0101a7d:	e8 ba e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	8b 40 38             	mov    0x38(%eax),%eax
c0101a88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a8c:	c7 04 24 fc 62 10 c0 	movl   $0xc01062fc,(%esp)
c0101a93:	e8 a4 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a9f:	0f b7 c0             	movzwl %ax,%eax
c0101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa6:	c7 04 24 0b 63 10 c0 	movl   $0xc010630b,(%esp)
c0101aad:	e8 8a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	8b 40 40             	mov    0x40(%eax),%eax
c0101ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abc:	c7 04 24 1e 63 10 c0 	movl   $0xc010631e,(%esp)
c0101ac3:	e8 74 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101acf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ad6:	eb 3e                	jmp    c0101b16 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adb:	8b 50 40             	mov    0x40(%eax),%edx
c0101ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ae1:	21 d0                	and    %edx,%eax
c0101ae3:	85 c0                	test   %eax,%eax
c0101ae5:	74 28                	je     c0101b0f <print_trapframe+0x157>
c0101ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aea:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101af1:	85 c0                	test   %eax,%eax
c0101af3:	74 1a                	je     c0101b0f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101af8:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101aff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b03:	c7 04 24 2d 63 10 c0 	movl   $0xc010632d,(%esp)
c0101b0a:	e8 2d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b13:	d1 65 f0             	shll   -0x10(%ebp)
c0101b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b19:	83 f8 17             	cmp    $0x17,%eax
c0101b1c:	76 ba                	jbe    c0101ad8 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b21:	8b 40 40             	mov    0x40(%eax),%eax
c0101b24:	25 00 30 00 00       	and    $0x3000,%eax
c0101b29:	c1 e8 0c             	shr    $0xc,%eax
c0101b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b30:	c7 04 24 31 63 10 c0 	movl   $0xc0106331,(%esp)
c0101b37:	e8 00 e8 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	89 04 24             	mov    %eax,(%esp)
c0101b42:	e8 5b fe ff ff       	call   c01019a2 <trap_in_kernel>
c0101b47:	85 c0                	test   %eax,%eax
c0101b49:	75 30                	jne    c0101b7b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4e:	8b 40 44             	mov    0x44(%eax),%eax
c0101b51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b55:	c7 04 24 3a 63 10 c0 	movl   $0xc010633a,(%esp)
c0101b5c:	e8 db e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b64:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b68:	0f b7 c0             	movzwl %ax,%eax
c0101b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6f:	c7 04 24 49 63 10 c0 	movl   $0xc0106349,(%esp)
c0101b76:	e8 c1 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101b7b:	c9                   	leave  
c0101b7c:	c3                   	ret    

c0101b7d <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101b7d:	55                   	push   %ebp
c0101b7e:	89 e5                	mov    %esp,%ebp
c0101b80:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b86:	8b 00                	mov    (%eax),%eax
c0101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8c:	c7 04 24 5c 63 10 c0 	movl   $0xc010635c,(%esp)
c0101b93:	e8 a4 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9b:	8b 40 04             	mov    0x4(%eax),%eax
c0101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba2:	c7 04 24 6b 63 10 c0 	movl   $0xc010636b,(%esp)
c0101ba9:	e8 8e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb1:	8b 40 08             	mov    0x8(%eax),%eax
c0101bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb8:	c7 04 24 7a 63 10 c0 	movl   $0xc010637a,(%esp)
c0101bbf:	e8 78 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc7:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bce:	c7 04 24 89 63 10 c0 	movl   $0xc0106389,(%esp)
c0101bd5:	e8 62 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdd:	8b 40 10             	mov    0x10(%eax),%eax
c0101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be4:	c7 04 24 98 63 10 c0 	movl   $0xc0106398,(%esp)
c0101beb:	e8 4c e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf3:	8b 40 14             	mov    0x14(%eax),%eax
c0101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfa:	c7 04 24 a7 63 10 c0 	movl   $0xc01063a7,(%esp)
c0101c01:	e8 36 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c09:	8b 40 18             	mov    0x18(%eax),%eax
c0101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c10:	c7 04 24 b6 63 10 c0 	movl   $0xc01063b6,(%esp)
c0101c17:	e8 20 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 c5 63 10 c0 	movl   $0xc01063c5,(%esp)
c0101c2d:	e8 0a e7 ff ff       	call   c010033c <cprintf>
}
c0101c32:	c9                   	leave  
c0101c33:	c3                   	ret    

c0101c34 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c34:	55                   	push   %ebp
c0101c35:	89 e5                	mov    %esp,%ebp
c0101c37:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3d:	8b 40 30             	mov    0x30(%eax),%eax
c0101c40:	83 f8 2f             	cmp    $0x2f,%eax
c0101c43:	77 21                	ja     c0101c66 <trap_dispatch+0x32>
c0101c45:	83 f8 2e             	cmp    $0x2e,%eax
c0101c48:	0f 83 04 01 00 00    	jae    c0101d52 <trap_dispatch+0x11e>
c0101c4e:	83 f8 21             	cmp    $0x21,%eax
c0101c51:	0f 84 81 00 00 00    	je     c0101cd8 <trap_dispatch+0xa4>
c0101c57:	83 f8 24             	cmp    $0x24,%eax
c0101c5a:	74 56                	je     c0101cb2 <trap_dispatch+0x7e>
c0101c5c:	83 f8 20             	cmp    $0x20,%eax
c0101c5f:	74 16                	je     c0101c77 <trap_dispatch+0x43>
c0101c61:	e9 b4 00 00 00       	jmp    c0101d1a <trap_dispatch+0xe6>
c0101c66:	83 e8 78             	sub    $0x78,%eax
c0101c69:	83 f8 01             	cmp    $0x1,%eax
c0101c6c:	0f 87 a8 00 00 00    	ja     c0101d1a <trap_dispatch+0xe6>
c0101c72:	e9 87 00 00 00       	jmp    c0101cfe <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101c77:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101c7c:	83 c0 01             	add    $0x1,%eax
c0101c7f:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101c84:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101c8a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101c8f:	89 c8                	mov    %ecx,%eax
c0101c91:	f7 e2                	mul    %edx
c0101c93:	89 d0                	mov    %edx,%eax
c0101c95:	c1 e8 05             	shr    $0x5,%eax
c0101c98:	6b c0 64             	imul   $0x64,%eax,%eax
c0101c9b:	29 c1                	sub    %eax,%ecx
c0101c9d:	89 c8                	mov    %ecx,%eax
c0101c9f:	85 c0                	test   %eax,%eax
c0101ca1:	75 0a                	jne    c0101cad <trap_dispatch+0x79>
            print_ticks();
c0101ca3:	e8 bc fb ff ff       	call   c0101864 <print_ticks>
        }
        break;
c0101ca8:	e9 a6 00 00 00       	jmp    c0101d53 <trap_dispatch+0x11f>
c0101cad:	e9 a1 00 00 00       	jmp    c0101d53 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cb2:	e8 71 f9 ff ff       	call   c0101628 <cons_getc>
c0101cb7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101cba:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cbe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cca:	c7 04 24 d4 63 10 c0 	movl   $0xc01063d4,(%esp)
c0101cd1:	e8 66 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101cd6:	eb 7b                	jmp    c0101d53 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101cd8:	e8 4b f9 ff ff       	call   c0101628 <cons_getc>
c0101cdd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ce0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ce4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ce8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 e6 63 10 c0 	movl   $0xc01063e6,(%esp)
c0101cf7:	e8 40 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101cfc:	eb 55                	jmp    c0101d53 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101cfe:	c7 44 24 08 f5 63 10 	movl   $0xc01063f5,0x8(%esp)
c0101d05:	c0 
c0101d06:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d0d:	00 
c0101d0e:	c7 04 24 05 64 10 c0 	movl   $0xc0106405,(%esp)
c0101d15:	e8 a0 ef ff ff       	call   c0100cba <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d21:	0f b7 c0             	movzwl %ax,%eax
c0101d24:	83 e0 03             	and    $0x3,%eax
c0101d27:	85 c0                	test   %eax,%eax
c0101d29:	75 28                	jne    c0101d53 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2e:	89 04 24             	mov    %eax,(%esp)
c0101d31:	e8 82 fc ff ff       	call   c01019b8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d36:	c7 44 24 08 16 64 10 	movl   $0xc0106416,0x8(%esp)
c0101d3d:	c0 
c0101d3e:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d45:	00 
c0101d46:	c7 04 24 05 64 10 c0 	movl   $0xc0106405,(%esp)
c0101d4d:	e8 68 ef ff ff       	call   c0100cba <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d52:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d53:	c9                   	leave  
c0101d54:	c3                   	ret    

c0101d55 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d55:	55                   	push   %ebp
c0101d56:	89 e5                	mov    %esp,%ebp
c0101d58:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5e:	89 04 24             	mov    %eax,(%esp)
c0101d61:	e8 ce fe ff ff       	call   c0101c34 <trap_dispatch>
}
c0101d66:	c9                   	leave  
c0101d67:	c3                   	ret    

c0101d68 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d68:	1e                   	push   %ds
    pushl %es
c0101d69:	06                   	push   %es
    pushl %fs
c0101d6a:	0f a0                	push   %fs
    pushl %gs
c0101d6c:	0f a8                	push   %gs
    pushal
c0101d6e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d6f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d74:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101d76:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101d78:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101d79:	e8 d7 ff ff ff       	call   c0101d55 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101d7e:	5c                   	pop    %esp

c0101d7f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101d7f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101d80:	0f a9                	pop    %gs
    popl %fs
c0101d82:	0f a1                	pop    %fs
    popl %es
c0101d84:	07                   	pop    %es
    popl %ds
c0101d85:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101d86:	83 c4 08             	add    $0x8,%esp
    iret
c0101d89:	cf                   	iret   

c0101d8a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d8a:	6a 00                	push   $0x0
  pushl $0
c0101d8c:	6a 00                	push   $0x0
  jmp __alltraps
c0101d8e:	e9 d5 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101d93 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101d93:	6a 00                	push   $0x0
  pushl $1
c0101d95:	6a 01                	push   $0x1
  jmp __alltraps
c0101d97:	e9 cc ff ff ff       	jmp    c0101d68 <__alltraps>

c0101d9c <vector2>:
.globl vector2
vector2:
  pushl $0
c0101d9c:	6a 00                	push   $0x0
  pushl $2
c0101d9e:	6a 02                	push   $0x2
  jmp __alltraps
c0101da0:	e9 c3 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101da5 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101da5:	6a 00                	push   $0x0
  pushl $3
c0101da7:	6a 03                	push   $0x3
  jmp __alltraps
c0101da9:	e9 ba ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dae <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dae:	6a 00                	push   $0x0
  pushl $4
c0101db0:	6a 04                	push   $0x4
  jmp __alltraps
c0101db2:	e9 b1 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101db7 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101db7:	6a 00                	push   $0x0
  pushl $5
c0101db9:	6a 05                	push   $0x5
  jmp __alltraps
c0101dbb:	e9 a8 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dc0 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dc0:	6a 00                	push   $0x0
  pushl $6
c0101dc2:	6a 06                	push   $0x6
  jmp __alltraps
c0101dc4:	e9 9f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dc9 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dc9:	6a 00                	push   $0x0
  pushl $7
c0101dcb:	6a 07                	push   $0x7
  jmp __alltraps
c0101dcd:	e9 96 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dd2 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101dd2:	6a 08                	push   $0x8
  jmp __alltraps
c0101dd4:	e9 8f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dd9 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101dd9:	6a 09                	push   $0x9
  jmp __alltraps
c0101ddb:	e9 88 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101de0 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101de0:	6a 0a                	push   $0xa
  jmp __alltraps
c0101de2:	e9 81 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101de7 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101de7:	6a 0b                	push   $0xb
  jmp __alltraps
c0101de9:	e9 7a ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dee <vector12>:
.globl vector12
vector12:
  pushl $12
c0101dee:	6a 0c                	push   $0xc
  jmp __alltraps
c0101df0:	e9 73 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101df5 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101df5:	6a 0d                	push   $0xd
  jmp __alltraps
c0101df7:	e9 6c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dfc <vector14>:
.globl vector14
vector14:
  pushl $14
c0101dfc:	6a 0e                	push   $0xe
  jmp __alltraps
c0101dfe:	e9 65 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e03 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e03:	6a 00                	push   $0x0
  pushl $15
c0101e05:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e07:	e9 5c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e0c <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e0c:	6a 00                	push   $0x0
  pushl $16
c0101e0e:	6a 10                	push   $0x10
  jmp __alltraps
c0101e10:	e9 53 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e15 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e15:	6a 11                	push   $0x11
  jmp __alltraps
c0101e17:	e9 4c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e1c <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $18
c0101e1e:	6a 12                	push   $0x12
  jmp __alltraps
c0101e20:	e9 43 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e25 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $19
c0101e27:	6a 13                	push   $0x13
  jmp __alltraps
c0101e29:	e9 3a ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e2e <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $20
c0101e30:	6a 14                	push   $0x14
  jmp __alltraps
c0101e32:	e9 31 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e37 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $21
c0101e39:	6a 15                	push   $0x15
  jmp __alltraps
c0101e3b:	e9 28 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e40 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e40:	6a 00                	push   $0x0
  pushl $22
c0101e42:	6a 16                	push   $0x16
  jmp __alltraps
c0101e44:	e9 1f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e49 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $23
c0101e4b:	6a 17                	push   $0x17
  jmp __alltraps
c0101e4d:	e9 16 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e52 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $24
c0101e54:	6a 18                	push   $0x18
  jmp __alltraps
c0101e56:	e9 0d ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e5b <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $25
c0101e5d:	6a 19                	push   $0x19
  jmp __alltraps
c0101e5f:	e9 04 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e64 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e64:	6a 00                	push   $0x0
  pushl $26
c0101e66:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e68:	e9 fb fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e6d <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e6d:	6a 00                	push   $0x0
  pushl $27
c0101e6f:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e71:	e9 f2 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e76 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $28
c0101e78:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e7a:	e9 e9 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e7f <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $29
c0101e81:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e83:	e9 e0 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e88 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $30
c0101e8a:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e8c:	e9 d7 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e91 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $31
c0101e93:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101e95:	e9 ce fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e9a <vector32>:
.globl vector32
vector32:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $32
c0101e9c:	6a 20                	push   $0x20
  jmp __alltraps
c0101e9e:	e9 c5 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ea3 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ea3:	6a 00                	push   $0x0
  pushl $33
c0101ea5:	6a 21                	push   $0x21
  jmp __alltraps
c0101ea7:	e9 bc fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eac <vector34>:
.globl vector34
vector34:
  pushl $0
c0101eac:	6a 00                	push   $0x0
  pushl $34
c0101eae:	6a 22                	push   $0x22
  jmp __alltraps
c0101eb0:	e9 b3 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eb5 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eb5:	6a 00                	push   $0x0
  pushl $35
c0101eb7:	6a 23                	push   $0x23
  jmp __alltraps
c0101eb9:	e9 aa fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ebe <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ebe:	6a 00                	push   $0x0
  pushl $36
c0101ec0:	6a 24                	push   $0x24
  jmp __alltraps
c0101ec2:	e9 a1 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ec7 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ec7:	6a 00                	push   $0x0
  pushl $37
c0101ec9:	6a 25                	push   $0x25
  jmp __alltraps
c0101ecb:	e9 98 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ed0 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ed0:	6a 00                	push   $0x0
  pushl $38
c0101ed2:	6a 26                	push   $0x26
  jmp __alltraps
c0101ed4:	e9 8f fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ed9 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ed9:	6a 00                	push   $0x0
  pushl $39
c0101edb:	6a 27                	push   $0x27
  jmp __alltraps
c0101edd:	e9 86 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ee2 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ee2:	6a 00                	push   $0x0
  pushl $40
c0101ee4:	6a 28                	push   $0x28
  jmp __alltraps
c0101ee6:	e9 7d fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eeb <vector41>:
.globl vector41
vector41:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $41
c0101eed:	6a 29                	push   $0x29
  jmp __alltraps
c0101eef:	e9 74 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ef4 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  pushl $42
c0101ef6:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101ef8:	e9 6b fe ff ff       	jmp    c0101d68 <__alltraps>

c0101efd <vector43>:
.globl vector43
vector43:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $43
c0101eff:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f01:	e9 62 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f06 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $44
c0101f08:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f0a:	e9 59 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f0f <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f0f:	6a 00                	push   $0x0
  pushl $45
c0101f11:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f13:	e9 50 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f18 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f18:	6a 00                	push   $0x0
  pushl $46
c0101f1a:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f1c:	e9 47 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f21 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f21:	6a 00                	push   $0x0
  pushl $47
c0101f23:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f25:	e9 3e fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f2a <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $48
c0101f2c:	6a 30                	push   $0x30
  jmp __alltraps
c0101f2e:	e9 35 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f33 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f33:	6a 00                	push   $0x0
  pushl $49
c0101f35:	6a 31                	push   $0x31
  jmp __alltraps
c0101f37:	e9 2c fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f3c <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f3c:	6a 00                	push   $0x0
  pushl $50
c0101f3e:	6a 32                	push   $0x32
  jmp __alltraps
c0101f40:	e9 23 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f45 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f45:	6a 00                	push   $0x0
  pushl $51
c0101f47:	6a 33                	push   $0x33
  jmp __alltraps
c0101f49:	e9 1a fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f4e <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f4e:	6a 00                	push   $0x0
  pushl $52
c0101f50:	6a 34                	push   $0x34
  jmp __alltraps
c0101f52:	e9 11 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f57 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f57:	6a 00                	push   $0x0
  pushl $53
c0101f59:	6a 35                	push   $0x35
  jmp __alltraps
c0101f5b:	e9 08 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f60 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f60:	6a 00                	push   $0x0
  pushl $54
c0101f62:	6a 36                	push   $0x36
  jmp __alltraps
c0101f64:	e9 ff fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f69 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f69:	6a 00                	push   $0x0
  pushl $55
c0101f6b:	6a 37                	push   $0x37
  jmp __alltraps
c0101f6d:	e9 f6 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f72 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f72:	6a 00                	push   $0x0
  pushl $56
c0101f74:	6a 38                	push   $0x38
  jmp __alltraps
c0101f76:	e9 ed fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f7b <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f7b:	6a 00                	push   $0x0
  pushl $57
c0101f7d:	6a 39                	push   $0x39
  jmp __alltraps
c0101f7f:	e9 e4 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f84 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f84:	6a 00                	push   $0x0
  pushl $58
c0101f86:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f88:	e9 db fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f8d <vector59>:
.globl vector59
vector59:
  pushl $0
c0101f8d:	6a 00                	push   $0x0
  pushl $59
c0101f8f:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101f91:	e9 d2 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f96 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101f96:	6a 00                	push   $0x0
  pushl $60
c0101f98:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101f9a:	e9 c9 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f9f <vector61>:
.globl vector61
vector61:
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  pushl $61
c0101fa1:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fa3:	e9 c0 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fa8 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fa8:	6a 00                	push   $0x0
  pushl $62
c0101faa:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fac:	e9 b7 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fb1 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fb1:	6a 00                	push   $0x0
  pushl $63
c0101fb3:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fb5:	e9 ae fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fba <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fba:	6a 00                	push   $0x0
  pushl $64
c0101fbc:	6a 40                	push   $0x40
  jmp __alltraps
c0101fbe:	e9 a5 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fc3 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  pushl $65
c0101fc5:	6a 41                	push   $0x41
  jmp __alltraps
c0101fc7:	e9 9c fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fcc <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fcc:	6a 00                	push   $0x0
  pushl $66
c0101fce:	6a 42                	push   $0x42
  jmp __alltraps
c0101fd0:	e9 93 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fd5 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fd5:	6a 00                	push   $0x0
  pushl $67
c0101fd7:	6a 43                	push   $0x43
  jmp __alltraps
c0101fd9:	e9 8a fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fde <vector68>:
.globl vector68
vector68:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $68
c0101fe0:	6a 44                	push   $0x44
  jmp __alltraps
c0101fe2:	e9 81 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fe7 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $69
c0101fe9:	6a 45                	push   $0x45
  jmp __alltraps
c0101feb:	e9 78 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101ff0 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $70
c0101ff2:	6a 46                	push   $0x46
  jmp __alltraps
c0101ff4:	e9 6f fd ff ff       	jmp    c0101d68 <__alltraps>

c0101ff9 <vector71>:
.globl vector71
vector71:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $71
c0101ffb:	6a 47                	push   $0x47
  jmp __alltraps
c0101ffd:	e9 66 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102002 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $72
c0102004:	6a 48                	push   $0x48
  jmp __alltraps
c0102006:	e9 5d fd ff ff       	jmp    c0101d68 <__alltraps>

c010200b <vector73>:
.globl vector73
vector73:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $73
c010200d:	6a 49                	push   $0x49
  jmp __alltraps
c010200f:	e9 54 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102014 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $74
c0102016:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102018:	e9 4b fd ff ff       	jmp    c0101d68 <__alltraps>

c010201d <vector75>:
.globl vector75
vector75:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $75
c010201f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102021:	e9 42 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102026 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102026:	6a 00                	push   $0x0
  pushl $76
c0102028:	6a 4c                	push   $0x4c
  jmp __alltraps
c010202a:	e9 39 fd ff ff       	jmp    c0101d68 <__alltraps>

c010202f <vector77>:
.globl vector77
vector77:
  pushl $0
c010202f:	6a 00                	push   $0x0
  pushl $77
c0102031:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102033:	e9 30 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102038 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102038:	6a 00                	push   $0x0
  pushl $78
c010203a:	6a 4e                	push   $0x4e
  jmp __alltraps
c010203c:	e9 27 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102041 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102041:	6a 00                	push   $0x0
  pushl $79
c0102043:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102045:	e9 1e fd ff ff       	jmp    c0101d68 <__alltraps>

c010204a <vector80>:
.globl vector80
vector80:
  pushl $0
c010204a:	6a 00                	push   $0x0
  pushl $80
c010204c:	6a 50                	push   $0x50
  jmp __alltraps
c010204e:	e9 15 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102053 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $81
c0102055:	6a 51                	push   $0x51
  jmp __alltraps
c0102057:	e9 0c fd ff ff       	jmp    c0101d68 <__alltraps>

c010205c <vector82>:
.globl vector82
vector82:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $82
c010205e:	6a 52                	push   $0x52
  jmp __alltraps
c0102060:	e9 03 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102065 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $83
c0102067:	6a 53                	push   $0x53
  jmp __alltraps
c0102069:	e9 fa fc ff ff       	jmp    c0101d68 <__alltraps>

c010206e <vector84>:
.globl vector84
vector84:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $84
c0102070:	6a 54                	push   $0x54
  jmp __alltraps
c0102072:	e9 f1 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102077 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $85
c0102079:	6a 55                	push   $0x55
  jmp __alltraps
c010207b:	e9 e8 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102080 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $86
c0102082:	6a 56                	push   $0x56
  jmp __alltraps
c0102084:	e9 df fc ff ff       	jmp    c0101d68 <__alltraps>

c0102089 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $87
c010208b:	6a 57                	push   $0x57
  jmp __alltraps
c010208d:	e9 d6 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102092 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $88
c0102094:	6a 58                	push   $0x58
  jmp __alltraps
c0102096:	e9 cd fc ff ff       	jmp    c0101d68 <__alltraps>

c010209b <vector89>:
.globl vector89
vector89:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $89
c010209d:	6a 59                	push   $0x59
  jmp __alltraps
c010209f:	e9 c4 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020a4 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $90
c01020a6:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020a8:	e9 bb fc ff ff       	jmp    c0101d68 <__alltraps>

c01020ad <vector91>:
.globl vector91
vector91:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $91
c01020af:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020b1:	e9 b2 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020b6 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $92
c01020b8:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020ba:	e9 a9 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020bf <vector93>:
.globl vector93
vector93:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $93
c01020c1:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020c3:	e9 a0 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020c8 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $94
c01020ca:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020cc:	e9 97 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020d1 <vector95>:
.globl vector95
vector95:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $95
c01020d3:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020d5:	e9 8e fc ff ff       	jmp    c0101d68 <__alltraps>

c01020da <vector96>:
.globl vector96
vector96:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $96
c01020dc:	6a 60                	push   $0x60
  jmp __alltraps
c01020de:	e9 85 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020e3 <vector97>:
.globl vector97
vector97:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $97
c01020e5:	6a 61                	push   $0x61
  jmp __alltraps
c01020e7:	e9 7c fc ff ff       	jmp    c0101d68 <__alltraps>

c01020ec <vector98>:
.globl vector98
vector98:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $98
c01020ee:	6a 62                	push   $0x62
  jmp __alltraps
c01020f0:	e9 73 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020f5 <vector99>:
.globl vector99
vector99:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $99
c01020f7:	6a 63                	push   $0x63
  jmp __alltraps
c01020f9:	e9 6a fc ff ff       	jmp    c0101d68 <__alltraps>

c01020fe <vector100>:
.globl vector100
vector100:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $100
c0102100:	6a 64                	push   $0x64
  jmp __alltraps
c0102102:	e9 61 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102107 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $101
c0102109:	6a 65                	push   $0x65
  jmp __alltraps
c010210b:	e9 58 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102110 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $102
c0102112:	6a 66                	push   $0x66
  jmp __alltraps
c0102114:	e9 4f fc ff ff       	jmp    c0101d68 <__alltraps>

c0102119 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $103
c010211b:	6a 67                	push   $0x67
  jmp __alltraps
c010211d:	e9 46 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102122 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $104
c0102124:	6a 68                	push   $0x68
  jmp __alltraps
c0102126:	e9 3d fc ff ff       	jmp    c0101d68 <__alltraps>

c010212b <vector105>:
.globl vector105
vector105:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $105
c010212d:	6a 69                	push   $0x69
  jmp __alltraps
c010212f:	e9 34 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102134 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $106
c0102136:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102138:	e9 2b fc ff ff       	jmp    c0101d68 <__alltraps>

c010213d <vector107>:
.globl vector107
vector107:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $107
c010213f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102141:	e9 22 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102146 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $108
c0102148:	6a 6c                	push   $0x6c
  jmp __alltraps
c010214a:	e9 19 fc ff ff       	jmp    c0101d68 <__alltraps>

c010214f <vector109>:
.globl vector109
vector109:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $109
c0102151:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102153:	e9 10 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102158 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $110
c010215a:	6a 6e                	push   $0x6e
  jmp __alltraps
c010215c:	e9 07 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102161 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $111
c0102163:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102165:	e9 fe fb ff ff       	jmp    c0101d68 <__alltraps>

c010216a <vector112>:
.globl vector112
vector112:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $112
c010216c:	6a 70                	push   $0x70
  jmp __alltraps
c010216e:	e9 f5 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102173 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $113
c0102175:	6a 71                	push   $0x71
  jmp __alltraps
c0102177:	e9 ec fb ff ff       	jmp    c0101d68 <__alltraps>

c010217c <vector114>:
.globl vector114
vector114:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $114
c010217e:	6a 72                	push   $0x72
  jmp __alltraps
c0102180:	e9 e3 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102185 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $115
c0102187:	6a 73                	push   $0x73
  jmp __alltraps
c0102189:	e9 da fb ff ff       	jmp    c0101d68 <__alltraps>

c010218e <vector116>:
.globl vector116
vector116:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $116
c0102190:	6a 74                	push   $0x74
  jmp __alltraps
c0102192:	e9 d1 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102197 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $117
c0102199:	6a 75                	push   $0x75
  jmp __alltraps
c010219b:	e9 c8 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021a0 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $118
c01021a2:	6a 76                	push   $0x76
  jmp __alltraps
c01021a4:	e9 bf fb ff ff       	jmp    c0101d68 <__alltraps>

c01021a9 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $119
c01021ab:	6a 77                	push   $0x77
  jmp __alltraps
c01021ad:	e9 b6 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021b2 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $120
c01021b4:	6a 78                	push   $0x78
  jmp __alltraps
c01021b6:	e9 ad fb ff ff       	jmp    c0101d68 <__alltraps>

c01021bb <vector121>:
.globl vector121
vector121:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $121
c01021bd:	6a 79                	push   $0x79
  jmp __alltraps
c01021bf:	e9 a4 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021c4 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $122
c01021c6:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021c8:	e9 9b fb ff ff       	jmp    c0101d68 <__alltraps>

c01021cd <vector123>:
.globl vector123
vector123:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $123
c01021cf:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021d1:	e9 92 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021d6 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $124
c01021d8:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021da:	e9 89 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021df <vector125>:
.globl vector125
vector125:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $125
c01021e1:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021e3:	e9 80 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021e8 <vector126>:
.globl vector126
vector126:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $126
c01021ea:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021ec:	e9 77 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021f1 <vector127>:
.globl vector127
vector127:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $127
c01021f3:	6a 7f                	push   $0x7f
  jmp __alltraps
c01021f5:	e9 6e fb ff ff       	jmp    c0101d68 <__alltraps>

c01021fa <vector128>:
.globl vector128
vector128:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $128
c01021fc:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102201:	e9 62 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102206 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $129
c0102208:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010220d:	e9 56 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102212 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $130
c0102214:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102219:	e9 4a fb ff ff       	jmp    c0101d68 <__alltraps>

c010221e <vector131>:
.globl vector131
vector131:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $131
c0102220:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102225:	e9 3e fb ff ff       	jmp    c0101d68 <__alltraps>

c010222a <vector132>:
.globl vector132
vector132:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $132
c010222c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102231:	e9 32 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102236 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $133
c0102238:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010223d:	e9 26 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102242 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $134
c0102244:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102249:	e9 1a fb ff ff       	jmp    c0101d68 <__alltraps>

c010224e <vector135>:
.globl vector135
vector135:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $135
c0102250:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102255:	e9 0e fb ff ff       	jmp    c0101d68 <__alltraps>

c010225a <vector136>:
.globl vector136
vector136:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $136
c010225c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102261:	e9 02 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102266 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $137
c0102268:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010226d:	e9 f6 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102272 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $138
c0102274:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102279:	e9 ea fa ff ff       	jmp    c0101d68 <__alltraps>

c010227e <vector139>:
.globl vector139
vector139:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $139
c0102280:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102285:	e9 de fa ff ff       	jmp    c0101d68 <__alltraps>

c010228a <vector140>:
.globl vector140
vector140:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $140
c010228c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102291:	e9 d2 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102296 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $141
c0102298:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010229d:	e9 c6 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022a2 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $142
c01022a4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022a9:	e9 ba fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ae <vector143>:
.globl vector143
vector143:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $143
c01022b0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022b5:	e9 ae fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ba <vector144>:
.globl vector144
vector144:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $144
c01022bc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022c1:	e9 a2 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022c6 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $145
c01022c8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022cd:	e9 96 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022d2 <vector146>:
.globl vector146
vector146:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $146
c01022d4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022d9:	e9 8a fa ff ff       	jmp    c0101d68 <__alltraps>

c01022de <vector147>:
.globl vector147
vector147:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $147
c01022e0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022e5:	e9 7e fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ea <vector148>:
.globl vector148
vector148:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $148
c01022ec:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01022f1:	e9 72 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022f6 <vector149>:
.globl vector149
vector149:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $149
c01022f8:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01022fd:	e9 66 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102302 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $150
c0102304:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102309:	e9 5a fa ff ff       	jmp    c0101d68 <__alltraps>

c010230e <vector151>:
.globl vector151
vector151:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $151
c0102310:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102315:	e9 4e fa ff ff       	jmp    c0101d68 <__alltraps>

c010231a <vector152>:
.globl vector152
vector152:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $152
c010231c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102321:	e9 42 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102326 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $153
c0102328:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010232d:	e9 36 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102332 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $154
c0102334:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102339:	e9 2a fa ff ff       	jmp    c0101d68 <__alltraps>

c010233e <vector155>:
.globl vector155
vector155:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $155
c0102340:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102345:	e9 1e fa ff ff       	jmp    c0101d68 <__alltraps>

c010234a <vector156>:
.globl vector156
vector156:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $156
c010234c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102351:	e9 12 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102356 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $157
c0102358:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010235d:	e9 06 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102362 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $158
c0102364:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102369:	e9 fa f9 ff ff       	jmp    c0101d68 <__alltraps>

c010236e <vector159>:
.globl vector159
vector159:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $159
c0102370:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102375:	e9 ee f9 ff ff       	jmp    c0101d68 <__alltraps>

c010237a <vector160>:
.globl vector160
vector160:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $160
c010237c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102381:	e9 e2 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102386 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $161
c0102388:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010238d:	e9 d6 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102392 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $162
c0102394:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102399:	e9 ca f9 ff ff       	jmp    c0101d68 <__alltraps>

c010239e <vector163>:
.globl vector163
vector163:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $163
c01023a0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023a5:	e9 be f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023aa <vector164>:
.globl vector164
vector164:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $164
c01023ac:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023b1:	e9 b2 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023b6 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023b6:	6a 00                	push   $0x0
  pushl $165
c01023b8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023bd:	e9 a6 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023c2 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $166
c01023c4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023c9:	e9 9a f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023ce <vector167>:
.globl vector167
vector167:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $167
c01023d0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023d5:	e9 8e f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023da <vector168>:
.globl vector168
vector168:
  pushl $0
c01023da:	6a 00                	push   $0x0
  pushl $168
c01023dc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023e1:	e9 82 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023e6 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $169
c01023e8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01023ed:	e9 76 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023f2 <vector170>:
.globl vector170
vector170:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $170
c01023f4:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01023f9:	e9 6a f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023fe <vector171>:
.globl vector171
vector171:
  pushl $0
c01023fe:	6a 00                	push   $0x0
  pushl $171
c0102400:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102405:	e9 5e f9 ff ff       	jmp    c0101d68 <__alltraps>

c010240a <vector172>:
.globl vector172
vector172:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $172
c010240c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102411:	e9 52 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102416 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $173
c0102418:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010241d:	e9 46 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102422 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102422:	6a 00                	push   $0x0
  pushl $174
c0102424:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102429:	e9 3a f9 ff ff       	jmp    c0101d68 <__alltraps>

c010242e <vector175>:
.globl vector175
vector175:
  pushl $0
c010242e:	6a 00                	push   $0x0
  pushl $175
c0102430:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102435:	e9 2e f9 ff ff       	jmp    c0101d68 <__alltraps>

c010243a <vector176>:
.globl vector176
vector176:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $176
c010243c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102441:	e9 22 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102446 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102446:	6a 00                	push   $0x0
  pushl $177
c0102448:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010244d:	e9 16 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102452 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102452:	6a 00                	push   $0x0
  pushl $178
c0102454:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102459:	e9 0a f9 ff ff       	jmp    c0101d68 <__alltraps>

c010245e <vector179>:
.globl vector179
vector179:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $179
c0102460:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102465:	e9 fe f8 ff ff       	jmp    c0101d68 <__alltraps>

c010246a <vector180>:
.globl vector180
vector180:
  pushl $0
c010246a:	6a 00                	push   $0x0
  pushl $180
c010246c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102471:	e9 f2 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102476 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $181
c0102478:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010247d:	e9 e6 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102482 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $182
c0102484:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102489:	e9 da f8 ff ff       	jmp    c0101d68 <__alltraps>

c010248e <vector183>:
.globl vector183
vector183:
  pushl $0
c010248e:	6a 00                	push   $0x0
  pushl $183
c0102490:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102495:	e9 ce f8 ff ff       	jmp    c0101d68 <__alltraps>

c010249a <vector184>:
.globl vector184
vector184:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $184
c010249c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024a1:	e9 c2 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024a6 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $185
c01024a8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024ad:	e9 b6 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024b2 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $186
c01024b4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024b9:	e9 aa f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024be <vector187>:
.globl vector187
vector187:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $187
c01024c0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024c5:	e9 9e f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024ca <vector188>:
.globl vector188
vector188:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $188
c01024cc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024d1:	e9 92 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024d6 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $189
c01024d8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024dd:	e9 86 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024e2 <vector190>:
.globl vector190
vector190:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $190
c01024e4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024e9:	e9 7a f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024ee <vector191>:
.globl vector191
vector191:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $191
c01024f0:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01024f5:	e9 6e f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024fa <vector192>:
.globl vector192
vector192:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $192
c01024fc:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102501:	e9 62 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102506 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $193
c0102508:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010250d:	e9 56 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102512 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $194
c0102514:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102519:	e9 4a f8 ff ff       	jmp    c0101d68 <__alltraps>

c010251e <vector195>:
.globl vector195
vector195:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $195
c0102520:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102525:	e9 3e f8 ff ff       	jmp    c0101d68 <__alltraps>

c010252a <vector196>:
.globl vector196
vector196:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $196
c010252c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102531:	e9 32 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102536 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $197
c0102538:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010253d:	e9 26 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102542 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $198
c0102544:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102549:	e9 1a f8 ff ff       	jmp    c0101d68 <__alltraps>

c010254e <vector199>:
.globl vector199
vector199:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $199
c0102550:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102555:	e9 0e f8 ff ff       	jmp    c0101d68 <__alltraps>

c010255a <vector200>:
.globl vector200
vector200:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $200
c010255c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102561:	e9 02 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102566 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $201
c0102568:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010256d:	e9 f6 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102572 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $202
c0102574:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102579:	e9 ea f7 ff ff       	jmp    c0101d68 <__alltraps>

c010257e <vector203>:
.globl vector203
vector203:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $203
c0102580:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102585:	e9 de f7 ff ff       	jmp    c0101d68 <__alltraps>

c010258a <vector204>:
.globl vector204
vector204:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $204
c010258c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102591:	e9 d2 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102596 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $205
c0102598:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010259d:	e9 c6 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025a2 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $206
c01025a4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025a9:	e9 ba f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ae <vector207>:
.globl vector207
vector207:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $207
c01025b0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025b5:	e9 ae f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ba <vector208>:
.globl vector208
vector208:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $208
c01025bc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025c1:	e9 a2 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025c6 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $209
c01025c8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025cd:	e9 96 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025d2 <vector210>:
.globl vector210
vector210:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $210
c01025d4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025d9:	e9 8a f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025de <vector211>:
.globl vector211
vector211:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $211
c01025e0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025e5:	e9 7e f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ea <vector212>:
.globl vector212
vector212:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $212
c01025ec:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01025f1:	e9 72 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025f6 <vector213>:
.globl vector213
vector213:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $213
c01025f8:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01025fd:	e9 66 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102602 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $214
c0102604:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102609:	e9 5a f7 ff ff       	jmp    c0101d68 <__alltraps>

c010260e <vector215>:
.globl vector215
vector215:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $215
c0102610:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102615:	e9 4e f7 ff ff       	jmp    c0101d68 <__alltraps>

c010261a <vector216>:
.globl vector216
vector216:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $216
c010261c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102621:	e9 42 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102626 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $217
c0102628:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010262d:	e9 36 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102632 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $218
c0102634:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102639:	e9 2a f7 ff ff       	jmp    c0101d68 <__alltraps>

c010263e <vector219>:
.globl vector219
vector219:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $219
c0102640:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102645:	e9 1e f7 ff ff       	jmp    c0101d68 <__alltraps>

c010264a <vector220>:
.globl vector220
vector220:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $220
c010264c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102651:	e9 12 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102656 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $221
c0102658:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010265d:	e9 06 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102662 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $222
c0102664:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102669:	e9 fa f6 ff ff       	jmp    c0101d68 <__alltraps>

c010266e <vector223>:
.globl vector223
vector223:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $223
c0102670:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102675:	e9 ee f6 ff ff       	jmp    c0101d68 <__alltraps>

c010267a <vector224>:
.globl vector224
vector224:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $224
c010267c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102681:	e9 e2 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102686 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $225
c0102688:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010268d:	e9 d6 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102692 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $226
c0102694:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102699:	e9 ca f6 ff ff       	jmp    c0101d68 <__alltraps>

c010269e <vector227>:
.globl vector227
vector227:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $227
c01026a0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026a5:	e9 be f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026aa <vector228>:
.globl vector228
vector228:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $228
c01026ac:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026b1:	e9 b2 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026b6 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $229
c01026b8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026bd:	e9 a6 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026c2 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $230
c01026c4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026c9:	e9 9a f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026ce <vector231>:
.globl vector231
vector231:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $231
c01026d0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026d5:	e9 8e f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026da <vector232>:
.globl vector232
vector232:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $232
c01026dc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026e1:	e9 82 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026e6 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $233
c01026e8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01026ed:	e9 76 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026f2 <vector234>:
.globl vector234
vector234:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $234
c01026f4:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01026f9:	e9 6a f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026fe <vector235>:
.globl vector235
vector235:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $235
c0102700:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102705:	e9 5e f6 ff ff       	jmp    c0101d68 <__alltraps>

c010270a <vector236>:
.globl vector236
vector236:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $236
c010270c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102711:	e9 52 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102716 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $237
c0102718:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010271d:	e9 46 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102722 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $238
c0102724:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102729:	e9 3a f6 ff ff       	jmp    c0101d68 <__alltraps>

c010272e <vector239>:
.globl vector239
vector239:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $239
c0102730:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102735:	e9 2e f6 ff ff       	jmp    c0101d68 <__alltraps>

c010273a <vector240>:
.globl vector240
vector240:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $240
c010273c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102741:	e9 22 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102746 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $241
c0102748:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010274d:	e9 16 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102752 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $242
c0102754:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102759:	e9 0a f6 ff ff       	jmp    c0101d68 <__alltraps>

c010275e <vector243>:
.globl vector243
vector243:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $243
c0102760:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102765:	e9 fe f5 ff ff       	jmp    c0101d68 <__alltraps>

c010276a <vector244>:
.globl vector244
vector244:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $244
c010276c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102771:	e9 f2 f5 ff ff       	jmp    c0101d68 <__alltraps>

c0102776 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $245
c0102778:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010277d:	e9 e6 f5 ff ff       	jmp    c0101d68 <__alltraps>

c0102782 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $246
c0102784:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102789:	e9 da f5 ff ff       	jmp    c0101d68 <__alltraps>

c010278e <vector247>:
.globl vector247
vector247:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $247
c0102790:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102795:	e9 ce f5 ff ff       	jmp    c0101d68 <__alltraps>

c010279a <vector248>:
.globl vector248
vector248:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $248
c010279c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027a1:	e9 c2 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027a6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $249
c01027a8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027ad:	e9 b6 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027b2 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $250
c01027b4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027b9:	e9 aa f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027be <vector251>:
.globl vector251
vector251:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $251
c01027c0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027c5:	e9 9e f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027ca <vector252>:
.globl vector252
vector252:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $252
c01027cc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027d1:	e9 92 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027d6 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $253
c01027d8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027dd:	e9 86 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027e2 <vector254>:
.globl vector254
vector254:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $254
c01027e4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027e9:	e9 7a f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027ee <vector255>:
.globl vector255
vector255:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $255
c01027f0:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01027f5:	e9 6e f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01027fa:	55                   	push   %ebp
c01027fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01027fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0102800:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102805:	29 c2                	sub    %eax,%edx
c0102807:	89 d0                	mov    %edx,%eax
c0102809:	c1 f8 02             	sar    $0x2,%eax
c010280c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102812:	5d                   	pop    %ebp
c0102813:	c3                   	ret    

c0102814 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102814:	55                   	push   %ebp
c0102815:	89 e5                	mov    %esp,%ebp
c0102817:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010281a:	8b 45 08             	mov    0x8(%ebp),%eax
c010281d:	89 04 24             	mov    %eax,(%esp)
c0102820:	e8 d5 ff ff ff       	call   c01027fa <page2ppn>
c0102825:	c1 e0 0c             	shl    $0xc,%eax
}
c0102828:	c9                   	leave  
c0102829:	c3                   	ret    

c010282a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010282a:	55                   	push   %ebp
c010282b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010282d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102830:	8b 00                	mov    (%eax),%eax
}
c0102832:	5d                   	pop    %ebp
c0102833:	c3                   	ret    

c0102834 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102834:	55                   	push   %ebp
c0102835:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102837:	8b 45 08             	mov    0x8(%ebp),%eax
c010283a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010283d:	89 10                	mov    %edx,(%eax)
}
c010283f:	5d                   	pop    %ebp
c0102840:	c3                   	ret    

c0102841 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102841:	55                   	push   %ebp
c0102842:	89 e5                	mov    %esp,%ebp
c0102844:	83 ec 10             	sub    $0x10,%esp
c0102847:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010284e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102851:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102854:	89 50 04             	mov    %edx,0x4(%eax)
c0102857:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010285a:	8b 50 04             	mov    0x4(%eax),%edx
c010285d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102860:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102862:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102869:	00 00 00 
}
c010286c:	c9                   	leave  
c010286d:	c3                   	ret    

c010286e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010286e:	55                   	push   %ebp
c010286f:	89 e5                	mov    %esp,%ebp
c0102871:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102874:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102878:	75 24                	jne    c010289e <default_init_memmap+0x30>
c010287a:	c7 44 24 0c d0 65 10 	movl   $0xc01065d0,0xc(%esp)
c0102881:	c0 
c0102882:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102889:	c0 
c010288a:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102891:	00 
c0102892:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102899:	e8 1c e4 ff ff       	call   c0100cba <__panic>
    struct Page *p = base;
c010289e:	8b 45 08             	mov    0x8(%ebp),%eax
c01028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028a4:	e9 e8 00 00 00       	jmp    c0102991 <default_init_memmap+0x123>
        assert(PageReserved(p));
c01028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028ac:	83 c0 04             	add    $0x4,%eax
c01028af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028bf:	0f a3 10             	bt     %edx,(%eax)
c01028c2:	19 c0                	sbb    %eax,%eax
c01028c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028cb:	0f 95 c0             	setne  %al
c01028ce:	0f b6 c0             	movzbl %al,%eax
c01028d1:	85 c0                	test   %eax,%eax
c01028d3:	75 24                	jne    c01028f9 <default_init_memmap+0x8b>
c01028d5:	c7 44 24 0c 01 66 10 	movl   $0xc0106601,0xc(%esp)
c01028dc:	c0 
c01028dd:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01028e4:	c0 
c01028e5:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01028ec:	00 
c01028ed:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01028f4:	e8 c1 e3 ff ff       	call   c0100cba <__panic>
        p->flags =0;
c01028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	p->flags = p->property =0;
c0102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102906:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102910:	8b 50 08             	mov    0x8(%eax),%edx
c0102913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102916:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);     
c0102919:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010291c:	83 c0 04             	add    $0x4,%eax
c010291f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102926:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102929:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010292c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010292f:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c0102932:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102939:	00 
c010293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293d:	89 04 24             	mov    %eax,(%esp)
c0102940:	e8 ef fe ff ff       	call   c0102834 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102945:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102948:	83 c0 0c             	add    $0xc,%eax
c010294b:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102952:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102955:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102958:	8b 00                	mov    (%eax),%eax
c010295a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010295d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102960:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102963:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102966:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102969:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010296c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010296f:	89 10                	mov    %edx,(%eax)
c0102971:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102974:	8b 10                	mov    (%eax),%edx
c0102976:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102979:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010297c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010297f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102982:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102985:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102988:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010298b:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010298d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102991:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102994:	89 d0                	mov    %edx,%eax
c0102996:	c1 e0 02             	shl    $0x2,%eax
c0102999:	01 d0                	add    %edx,%eax
c010299b:	c1 e0 02             	shl    $0x2,%eax
c010299e:	89 c2                	mov    %eax,%edx
c01029a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a3:	01 d0                	add    %edx,%eax
c01029a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029a8:	0f 85 fb fe ff ff    	jne    c01028a9 <default_init_memmap+0x3b>
	p->flags = p->property =0;
        SetPageProperty(p);     
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
	 base->property = n;
c01029ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029b4:	89 50 08             	mov    %edx,0x8(%eax)
         nr_free += n;
c01029b7:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029c0:	01 d0                	add    %edx,%eax
c01029c2:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c01029c7:	c9                   	leave  
c01029c8:	c3                   	ret    

c01029c9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029c9:	55                   	push   %ebp
c01029ca:	89 e5                	mov    %esp,%ebp
c01029cc:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029d3:	75 24                	jne    c01029f9 <default_alloc_pages+0x30>
c01029d5:	c7 44 24 0c d0 65 10 	movl   $0xc01065d0,0xc(%esp)
c01029dc:	c0 
c01029dd:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01029e4:	c0 
c01029e5:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c01029ec:	00 
c01029ed:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01029f4:	e8 c1 e2 ff ff       	call   c0100cba <__panic>
    if (n > nr_free) {
c01029f9:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a01:	73 0a                	jae    c0102a0d <default_alloc_pages+0x44>
        return NULL;
c0102a03:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a08:	e9 37 01 00 00       	jmp    c0102b44 <default_alloc_pages+0x17b>
    }
    list_entry_t *le= &free_list, *len;
c0102a0d:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    while((le=list_next(le)) != &free_list) {
c0102a14:	e9 0a 01 00 00       	jmp    c0102b23 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c0102a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a1c:	83 e8 0c             	sub    $0xc,%eax
c0102a1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0102a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a25:	8b 40 08             	mov    0x8(%eax),%eax
c0102a28:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a2b:	0f 82 f2 00 00 00    	jb     c0102b23 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c0102a31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a38:	eb 7c                	jmp    c0102ab6 <default_alloc_pages+0xed>
c0102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a43:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0102a46:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *p2 = le2page(le, page_link);
c0102a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a4c:	83 e8 0c             	sub    $0xc,%eax
c0102a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(p2);
c0102a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a55:	83 c0 04             	add    $0x4,%eax
c0102a58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102a5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a62:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a68:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(p2);
c0102a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a6e:	83 c0 04             	add    $0x4,%eax
c0102a71:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102a78:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a81:	0f b3 10             	btr    %edx,(%eax)
c0102a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a87:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102a8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a8d:	8b 40 04             	mov    0x4(%eax),%eax
c0102a90:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a93:	8b 12                	mov    (%edx),%edx
c0102a95:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a98:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a9e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102aa1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102aa4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102aa7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102aaa:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c0102aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le= &free_list, *len;
    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0102ab2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102abc:	0f 82 78 ff ff ff    	jb     c0102a3a <default_alloc_pages+0x71>
          SetPageReserved(p2);
          ClearPageProperty(p2);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0102ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ac5:	8b 40 08             	mov    0x8(%eax),%eax
c0102ac8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102acb:	76 12                	jbe    c0102adf <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c0102acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ad0:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ad6:	8b 40 08             	mov    0x8(%eax),%eax
c0102ad9:	2b 45 08             	sub    0x8(%ebp),%eax
c0102adc:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0102adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ae2:	83 c0 04             	add    $0x4,%eax
c0102ae5:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102aec:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102aef:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102af2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102af5:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0102af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102afb:	83 c0 04             	add    $0x4,%eax
c0102afe:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102b05:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b0b:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b0e:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c0102b11:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b16:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b19:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        return p;
c0102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b21:	eb 21                	jmp    c0102b44 <default_alloc_pages+0x17b>
c0102b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b26:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b29:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b2c:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le= &free_list, *len;
    while((le=list_next(le)) != &free_list) {
c0102b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b32:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102b39:	0f 85 da fe ff ff    	jne    c0102a19 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0102b3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b44:	c9                   	leave  
c0102b45:	c3                   	ret    

c0102b46 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b46:	55                   	push   %ebp
c0102b47:	89 e5                	mov    %esp,%ebp
c0102b49:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b50:	75 24                	jne    c0102b76 <default_free_pages+0x30>
c0102b52:	c7 44 24 0c d0 65 10 	movl   $0xc01065d0,0xc(%esp)
c0102b59:	c0 
c0102b5a:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102b61:	c0 
c0102b62:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0102b69:	00 
c0102b6a:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102b71:	e8 44 e1 ff ff       	call   c0100cba <__panic>
    assert(PageReserved(base));
c0102b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b79:	83 c0 04             	add    $0x4,%eax
c0102b7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102b83:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102b8c:	0f a3 10             	bt     %edx,(%eax)
c0102b8f:	19 c0                	sbb    %eax,%eax
c0102b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102b98:	0f 95 c0             	setne  %al
c0102b9b:	0f b6 c0             	movzbl %al,%eax
c0102b9e:	85 c0                	test   %eax,%eax
c0102ba0:	75 24                	jne    c0102bc6 <default_free_pages+0x80>
c0102ba2:	c7 44 24 0c 11 66 10 	movl   $0xc0106611,0xc(%esp)
c0102ba9:	c0 
c0102baa:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102bb1:	c0 
c0102bb2:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0102bb9:	00 
c0102bba:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102bc1:	e8 f4 e0 ff ff       	call   c0100cba <__panic>

    list_entry_t *le = &free_list;
c0102bc6:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102bcd:	eb 13                	jmp    c0102be2 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c0102bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd2:	83 e8 0c             	sub    $0xc,%eax
c0102bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0102bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bdb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bde:	76 02                	jbe    c0102be2 <default_free_pages+0x9c>
        break;
c0102be0:	eb 18                	jmp    c0102bfa <default_free_pages+0xb4>
c0102be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102be8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102beb:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bf1:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102bf8:	75 d5                	jne    c0102bcf <default_free_pages+0x89>
      p = le2page(le, page_link);
      if(p>base){
        break;
      }
    }
    for(p=base;p<base+n;p++){
c0102bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c00:	eb 4b                	jmp    c0102c4d <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c0102c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c05:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c0e:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c14:	8b 00                	mov    (%eax),%eax
c0102c16:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c19:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c22:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c25:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c2b:	89 10                	mov    %edx,(%eax)
c0102c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c30:	8b 10                	mov    (%eax),%edx
c0102c32:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c3b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c3e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c44:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c47:	89 10                	mov    %edx,(%eax)
      p = le2page(le, page_link);
      if(p>base){
        break;
      }
    }
    for(p=base;p<base+n;p++){
c0102c49:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c50:	89 d0                	mov    %edx,%eax
c0102c52:	c1 e0 02             	shl    $0x2,%eax
c0102c55:	01 d0                	add    %edx,%eax
c0102c57:	c1 e0 02             	shl    $0x2,%eax
c0102c5a:	89 c2                	mov    %eax,%edx
c0102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c5f:	01 d0                	add    %edx,%eax
c0102c61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102c64:	77 9c                	ja     c0102c02 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0102c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102c70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c77:	00 
c0102c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7b:	89 04 24             	mov    %eax,(%esp)
c0102c7e:	e8 b1 fb ff ff       	call   c0102834 <set_page_ref>
    ClearPageProperty(base);
c0102c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c86:	83 c0 04             	add    $0x4,%eax
c0102c89:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102c90:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c96:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c99:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9f:	83 c0 04             	add    $0x4,%eax
c0102ca2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102ca9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cac:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102caf:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102cb2:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cbb:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0102cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cc1:	83 e8 0c             	sub    $0xc,%eax
c0102cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0102cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cca:	89 d0                	mov    %edx,%eax
c0102ccc:	c1 e0 02             	shl    $0x2,%eax
c0102ccf:	01 d0                	add    %edx,%eax
c0102cd1:	c1 e0 02             	shl    $0x2,%eax
c0102cd4:	89 c2                	mov    %eax,%edx
c0102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd9:	01 d0                	add    %edx,%eax
c0102cdb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102cde:	75 1e                	jne    c0102cfe <default_free_pages+0x1b8>
      base->property += p->property;
c0102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce3:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ce9:	8b 40 08             	mov    0x8(%eax),%eax
c0102cec:	01 c2                	add    %eax,%edx
c0102cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf1:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0102cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cf7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d01:	83 c0 0c             	add    $0xc,%eax
c0102d04:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d07:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d0a:	8b 00                	mov    (%eax),%eax
c0102d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d12:	83 e8 0c             	sub    $0xc,%eax
c0102d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0102d18:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102d1f:	74 57                	je     c0102d78 <default_free_pages+0x232>
c0102d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d24:	83 e8 14             	sub    $0x14,%eax
c0102d27:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d2a:	75 4c                	jne    c0102d78 <default_free_pages+0x232>
      while(le!=&free_list){
c0102d2c:	eb 41                	jmp    c0102d6f <default_free_pages+0x229>
        if(p->property){
c0102d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d31:	8b 40 08             	mov    0x8(%eax),%eax
c0102d34:	85 c0                	test   %eax,%eax
c0102d36:	74 20                	je     c0102d58 <default_free_pages+0x212>
          p->property += base->property;
c0102d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d3b:	8b 50 08             	mov    0x8(%eax),%edx
c0102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d41:	8b 40 08             	mov    0x8(%eax),%eax
c0102d44:	01 c2                	add    %eax,%edx
c0102d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d49:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0102d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0102d56:	eb 20                	jmp    c0102d78 <default_free_pages+0x232>
c0102d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d5b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102d5e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d61:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0102d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0102d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d69:	83 e8 0c             	sub    $0xc,%eax
c0102d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0102d6f:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102d76:	75 b6                	jne    c0102d2e <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0102d78:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d81:	01 d0                	add    %edx,%eax
c0102d83:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return ;
c0102d88:	90                   	nop
}
c0102d89:	c9                   	leave  
c0102d8a:	c3                   	ret    

c0102d8b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102d8b:	55                   	push   %ebp
c0102d8c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102d8e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102d93:	5d                   	pop    %ebp
c0102d94:	c3                   	ret    

c0102d95 <basic_check>:

static void
basic_check(void) {
c0102d95:	55                   	push   %ebp
c0102d96:	89 e5                	mov    %esp,%ebp
c0102d98:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102d9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102db5:	e8 85 0e 00 00       	call   c0103c3f <alloc_pages>
c0102dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102dbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102dc1:	75 24                	jne    c0102de7 <basic_check+0x52>
c0102dc3:	c7 44 24 0c 24 66 10 	movl   $0xc0106624,0xc(%esp)
c0102dca:	c0 
c0102dcb:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102dd2:	c0 
c0102dd3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0102dda:	00 
c0102ddb:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102de2:	e8 d3 de ff ff       	call   c0100cba <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102de7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102dee:	e8 4c 0e 00 00       	call   c0103c3f <alloc_pages>
c0102df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102df6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102dfa:	75 24                	jne    c0102e20 <basic_check+0x8b>
c0102dfc:	c7 44 24 0c 40 66 10 	movl   $0xc0106640,0xc(%esp)
c0102e03:	c0 
c0102e04:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102e0b:	c0 
c0102e0c:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0102e13:	00 
c0102e14:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102e1b:	e8 9a de ff ff       	call   c0100cba <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e27:	e8 13 0e 00 00       	call   c0103c3f <alloc_pages>
c0102e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e33:	75 24                	jne    c0102e59 <basic_check+0xc4>
c0102e35:	c7 44 24 0c 5c 66 10 	movl   $0xc010665c,0xc(%esp)
c0102e3c:	c0 
c0102e3d:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102e44:	c0 
c0102e45:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0102e4c:	00 
c0102e4d:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102e54:	e8 61 de ff ff       	call   c0100cba <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e5f:	74 10                	je     c0102e71 <basic_check+0xdc>
c0102e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e67:	74 08                	je     c0102e71 <basic_check+0xdc>
c0102e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e6f:	75 24                	jne    c0102e95 <basic_check+0x100>
c0102e71:	c7 44 24 0c 78 66 10 	movl   $0xc0106678,0xc(%esp)
c0102e78:	c0 
c0102e79:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102e80:	c0 
c0102e81:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0102e88:	00 
c0102e89:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102e90:	e8 25 de ff ff       	call   c0100cba <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e98:	89 04 24             	mov    %eax,(%esp)
c0102e9b:	e8 8a f9 ff ff       	call   c010282a <page_ref>
c0102ea0:	85 c0                	test   %eax,%eax
c0102ea2:	75 1e                	jne    c0102ec2 <basic_check+0x12d>
c0102ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea7:	89 04 24             	mov    %eax,(%esp)
c0102eaa:	e8 7b f9 ff ff       	call   c010282a <page_ref>
c0102eaf:	85 c0                	test   %eax,%eax
c0102eb1:	75 0f                	jne    c0102ec2 <basic_check+0x12d>
c0102eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb6:	89 04 24             	mov    %eax,(%esp)
c0102eb9:	e8 6c f9 ff ff       	call   c010282a <page_ref>
c0102ebe:	85 c0                	test   %eax,%eax
c0102ec0:	74 24                	je     c0102ee6 <basic_check+0x151>
c0102ec2:	c7 44 24 0c 9c 66 10 	movl   $0xc010669c,0xc(%esp)
c0102ec9:	c0 
c0102eca:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102ed1:	c0 
c0102ed2:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102ed9:	00 
c0102eda:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102ee1:	e8 d4 dd ff ff       	call   c0100cba <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee9:	89 04 24             	mov    %eax,(%esp)
c0102eec:	e8 23 f9 ff ff       	call   c0102814 <page2pa>
c0102ef1:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ef7:	c1 e2 0c             	shl    $0xc,%edx
c0102efa:	39 d0                	cmp    %edx,%eax
c0102efc:	72 24                	jb     c0102f22 <basic_check+0x18d>
c0102efe:	c7 44 24 0c d8 66 10 	movl   $0xc01066d8,0xc(%esp)
c0102f05:	c0 
c0102f06:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102f0d:	c0 
c0102f0e:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102f15:	00 
c0102f16:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102f1d:	e8 98 dd ff ff       	call   c0100cba <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f25:	89 04 24             	mov    %eax,(%esp)
c0102f28:	e8 e7 f8 ff ff       	call   c0102814 <page2pa>
c0102f2d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f33:	c1 e2 0c             	shl    $0xc,%edx
c0102f36:	39 d0                	cmp    %edx,%eax
c0102f38:	72 24                	jb     c0102f5e <basic_check+0x1c9>
c0102f3a:	c7 44 24 0c f5 66 10 	movl   $0xc01066f5,0xc(%esp)
c0102f41:	c0 
c0102f42:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102f49:	c0 
c0102f4a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102f51:	00 
c0102f52:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102f59:	e8 5c dd ff ff       	call   c0100cba <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f61:	89 04 24             	mov    %eax,(%esp)
c0102f64:	e8 ab f8 ff ff       	call   c0102814 <page2pa>
c0102f69:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f6f:	c1 e2 0c             	shl    $0xc,%edx
c0102f72:	39 d0                	cmp    %edx,%eax
c0102f74:	72 24                	jb     c0102f9a <basic_check+0x205>
c0102f76:	c7 44 24 0c 12 67 10 	movl   $0xc0106712,0xc(%esp)
c0102f7d:	c0 
c0102f7e:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102f85:	c0 
c0102f86:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102f8d:	00 
c0102f8e:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102f95:	e8 20 dd ff ff       	call   c0100cba <__panic>

    list_entry_t free_list_store = free_list;
c0102f9a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102f9f:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102fa5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fa8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fab:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102fb8:	89 50 04             	mov    %edx,0x4(%eax)
c0102fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fbe:	8b 50 04             	mov    0x4(%eax),%edx
c0102fc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fc4:	89 10                	mov    %edx,(%eax)
c0102fc6:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102fcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102fd0:	8b 40 04             	mov    0x4(%eax),%eax
c0102fd3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fd6:	0f 94 c0             	sete   %al
c0102fd9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102fdc:	85 c0                	test   %eax,%eax
c0102fde:	75 24                	jne    c0103004 <basic_check+0x26f>
c0102fe0:	c7 44 24 0c 2f 67 10 	movl   $0xc010672f,0xc(%esp)
c0102fe7:	c0 
c0102fe8:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0102fef:	c0 
c0102ff0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102ff7:	00 
c0102ff8:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0102fff:	e8 b6 dc ff ff       	call   c0100cba <__panic>

    unsigned int nr_free_store = nr_free;
c0103004:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103009:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010300c:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103013:	00 00 00 

    assert(alloc_page() == NULL);
c0103016:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010301d:	e8 1d 0c 00 00       	call   c0103c3f <alloc_pages>
c0103022:	85 c0                	test   %eax,%eax
c0103024:	74 24                	je     c010304a <basic_check+0x2b5>
c0103026:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c010302d:	c0 
c010302e:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103035:	c0 
c0103036:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010303d:	00 
c010303e:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103045:	e8 70 dc ff ff       	call   c0100cba <__panic>

    free_page(p0);
c010304a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103051:	00 
c0103052:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103055:	89 04 24             	mov    %eax,(%esp)
c0103058:	e8 1a 0c 00 00       	call   c0103c77 <free_pages>
    free_page(p1);
c010305d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103064:	00 
c0103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103068:	89 04 24             	mov    %eax,(%esp)
c010306b:	e8 07 0c 00 00       	call   c0103c77 <free_pages>
    free_page(p2);
c0103070:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103077:	00 
c0103078:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010307b:	89 04 24             	mov    %eax,(%esp)
c010307e:	e8 f4 0b 00 00       	call   c0103c77 <free_pages>
    assert(nr_free == 3);
c0103083:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103088:	83 f8 03             	cmp    $0x3,%eax
c010308b:	74 24                	je     c01030b1 <basic_check+0x31c>
c010308d:	c7 44 24 0c 5b 67 10 	movl   $0xc010675b,0xc(%esp)
c0103094:	c0 
c0103095:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010309c:	c0 
c010309d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01030a4:	00 
c01030a5:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01030ac:	e8 09 dc ff ff       	call   c0100cba <__panic>

    assert((p0 = alloc_page()) != NULL);
c01030b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030b8:	e8 82 0b 00 00       	call   c0103c3f <alloc_pages>
c01030bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01030c4:	75 24                	jne    c01030ea <basic_check+0x355>
c01030c6:	c7 44 24 0c 24 66 10 	movl   $0xc0106624,0xc(%esp)
c01030cd:	c0 
c01030ce:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01030d5:	c0 
c01030d6:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c01030dd:	00 
c01030de:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01030e5:	e8 d0 db ff ff       	call   c0100cba <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030f1:	e8 49 0b 00 00       	call   c0103c3f <alloc_pages>
c01030f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030fd:	75 24                	jne    c0103123 <basic_check+0x38e>
c01030ff:	c7 44 24 0c 40 66 10 	movl   $0xc0106640,0xc(%esp)
c0103106:	c0 
c0103107:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010310e:	c0 
c010310f:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103116:	00 
c0103117:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010311e:	e8 97 db ff ff       	call   c0100cba <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103123:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010312a:	e8 10 0b 00 00       	call   c0103c3f <alloc_pages>
c010312f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103136:	75 24                	jne    c010315c <basic_check+0x3c7>
c0103138:	c7 44 24 0c 5c 66 10 	movl   $0xc010665c,0xc(%esp)
c010313f:	c0 
c0103140:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103147:	c0 
c0103148:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c010314f:	00 
c0103150:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103157:	e8 5e db ff ff       	call   c0100cba <__panic>

    assert(alloc_page() == NULL);
c010315c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103163:	e8 d7 0a 00 00       	call   c0103c3f <alloc_pages>
c0103168:	85 c0                	test   %eax,%eax
c010316a:	74 24                	je     c0103190 <basic_check+0x3fb>
c010316c:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c0103173:	c0 
c0103174:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010317b:	c0 
c010317c:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103183:	00 
c0103184:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010318b:	e8 2a db ff ff       	call   c0100cba <__panic>

    free_page(p0);
c0103190:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103197:	00 
c0103198:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010319b:	89 04 24             	mov    %eax,(%esp)
c010319e:	e8 d4 0a 00 00       	call   c0103c77 <free_pages>
c01031a3:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c01031aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01031ad:	8b 40 04             	mov    0x4(%eax),%eax
c01031b0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01031b3:	0f 94 c0             	sete   %al
c01031b6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01031b9:	85 c0                	test   %eax,%eax
c01031bb:	74 24                	je     c01031e1 <basic_check+0x44c>
c01031bd:	c7 44 24 0c 68 67 10 	movl   $0xc0106768,0xc(%esp)
c01031c4:	c0 
c01031c5:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01031cc:	c0 
c01031cd:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01031d4:	00 
c01031d5:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01031dc:	e8 d9 da ff ff       	call   c0100cba <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01031e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e8:	e8 52 0a 00 00       	call   c0103c3f <alloc_pages>
c01031ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01031f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01031f6:	74 24                	je     c010321c <basic_check+0x487>
c01031f8:	c7 44 24 0c 80 67 10 	movl   $0xc0106780,0xc(%esp)
c01031ff:	c0 
c0103200:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103207:	c0 
c0103208:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010320f:	00 
c0103210:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103217:	e8 9e da ff ff       	call   c0100cba <__panic>
    assert(alloc_page() == NULL);
c010321c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103223:	e8 17 0a 00 00       	call   c0103c3f <alloc_pages>
c0103228:	85 c0                	test   %eax,%eax
c010322a:	74 24                	je     c0103250 <basic_check+0x4bb>
c010322c:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c0103233:	c0 
c0103234:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010323b:	c0 
c010323c:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103243:	00 
c0103244:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010324b:	e8 6a da ff ff       	call   c0100cba <__panic>

    assert(nr_free == 0);
c0103250:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103255:	85 c0                	test   %eax,%eax
c0103257:	74 24                	je     c010327d <basic_check+0x4e8>
c0103259:	c7 44 24 0c 99 67 10 	movl   $0xc0106799,0xc(%esp)
c0103260:	c0 
c0103261:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103268:	c0 
c0103269:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103270:	00 
c0103271:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103278:	e8 3d da ff ff       	call   c0100cba <__panic>
    free_list = free_list_store;
c010327d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103280:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103283:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103288:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103291:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103296:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010329d:	00 
c010329e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032a1:	89 04 24             	mov    %eax,(%esp)
c01032a4:	e8 ce 09 00 00       	call   c0103c77 <free_pages>
    free_page(p1);
c01032a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032b0:	00 
c01032b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032b4:	89 04 24             	mov    %eax,(%esp)
c01032b7:	e8 bb 09 00 00       	call   c0103c77 <free_pages>
    free_page(p2);
c01032bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032c3:	00 
c01032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c7:	89 04 24             	mov    %eax,(%esp)
c01032ca:	e8 a8 09 00 00       	call   c0103c77 <free_pages>
}
c01032cf:	c9                   	leave  
c01032d0:	c3                   	ret    

c01032d1 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01032d1:	55                   	push   %ebp
c01032d2:	89 e5                	mov    %esp,%ebp
c01032d4:	53                   	push   %ebx
c01032d5:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01032db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01032e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01032e9:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01032f0:	eb 6b                	jmp    c010335d <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01032f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032f5:	83 e8 0c             	sub    $0xc,%eax
c01032f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032fe:	83 c0 04             	add    $0x4,%eax
c0103301:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103308:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010330b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010330e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103311:	0f a3 10             	bt     %edx,(%eax)
c0103314:	19 c0                	sbb    %eax,%eax
c0103316:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103319:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010331d:	0f 95 c0             	setne  %al
c0103320:	0f b6 c0             	movzbl %al,%eax
c0103323:	85 c0                	test   %eax,%eax
c0103325:	75 24                	jne    c010334b <default_check+0x7a>
c0103327:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c010332e:	c0 
c010332f:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103336:	c0 
c0103337:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010333e:	00 
c010333f:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103346:	e8 6f d9 ff ff       	call   c0100cba <__panic>
        count ++, total += p->property;
c010334b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103352:	8b 50 08             	mov    0x8(%eax),%edx
c0103355:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103358:	01 d0                	add    %edx,%eax
c010335a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103360:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103363:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103366:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103369:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010336c:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103373:	0f 85 79 ff ff ff    	jne    c01032f2 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103379:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010337c:	e8 28 09 00 00       	call   c0103ca9 <nr_free_pages>
c0103381:	39 c3                	cmp    %eax,%ebx
c0103383:	74 24                	je     c01033a9 <default_check+0xd8>
c0103385:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c010338c:	c0 
c010338d:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103394:	c0 
c0103395:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010339c:	00 
c010339d:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01033a4:	e8 11 d9 ff ff       	call   c0100cba <__panic>

    basic_check();
c01033a9:	e8 e7 f9 ff ff       	call   c0102d95 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01033ae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01033b5:	e8 85 08 00 00       	call   c0103c3f <alloc_pages>
c01033ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01033bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033c1:	75 24                	jne    c01033e7 <default_check+0x116>
c01033c3:	c7 44 24 0c cf 67 10 	movl   $0xc01067cf,0xc(%esp)
c01033ca:	c0 
c01033cb:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01033d2:	c0 
c01033d3:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01033da:	00 
c01033db:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01033e2:	e8 d3 d8 ff ff       	call   c0100cba <__panic>
    assert(!PageProperty(p0));
c01033e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ea:	83 c0 04             	add    $0x4,%eax
c01033ed:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01033f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033f7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01033fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01033fd:	0f a3 10             	bt     %edx,(%eax)
c0103400:	19 c0                	sbb    %eax,%eax
c0103402:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103405:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103409:	0f 95 c0             	setne  %al
c010340c:	0f b6 c0             	movzbl %al,%eax
c010340f:	85 c0                	test   %eax,%eax
c0103411:	74 24                	je     c0103437 <default_check+0x166>
c0103413:	c7 44 24 0c da 67 10 	movl   $0xc01067da,0xc(%esp)
c010341a:	c0 
c010341b:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103422:	c0 
c0103423:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010342a:	00 
c010342b:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103432:	e8 83 d8 ff ff       	call   c0100cba <__panic>

    list_entry_t free_list_store = free_list;
c0103437:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010343c:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103442:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103445:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103448:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010344f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103452:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103455:	89 50 04             	mov    %edx,0x4(%eax)
c0103458:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010345b:	8b 50 04             	mov    0x4(%eax),%edx
c010345e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103461:	89 10                	mov    %edx,(%eax)
c0103463:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010346a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010346d:	8b 40 04             	mov    0x4(%eax),%eax
c0103470:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103473:	0f 94 c0             	sete   %al
c0103476:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103479:	85 c0                	test   %eax,%eax
c010347b:	75 24                	jne    c01034a1 <default_check+0x1d0>
c010347d:	c7 44 24 0c 2f 67 10 	movl   $0xc010672f,0xc(%esp)
c0103484:	c0 
c0103485:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010348c:	c0 
c010348d:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103494:	00 
c0103495:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010349c:	e8 19 d8 ff ff       	call   c0100cba <__panic>
    assert(alloc_page() == NULL);
c01034a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034a8:	e8 92 07 00 00       	call   c0103c3f <alloc_pages>
c01034ad:	85 c0                	test   %eax,%eax
c01034af:	74 24                	je     c01034d5 <default_check+0x204>
c01034b1:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c01034b8:	c0 
c01034b9:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01034c0:	c0 
c01034c1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01034c8:	00 
c01034c9:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01034d0:	e8 e5 d7 ff ff       	call   c0100cba <__panic>

    unsigned int nr_free_store = nr_free;
c01034d5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01034da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01034dd:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01034e4:	00 00 00 

    free_pages(p0 + 2, 3);
c01034e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034ea:	83 c0 28             	add    $0x28,%eax
c01034ed:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01034f4:	00 
c01034f5:	89 04 24             	mov    %eax,(%esp)
c01034f8:	e8 7a 07 00 00       	call   c0103c77 <free_pages>
    assert(alloc_pages(4) == NULL);
c01034fd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103504:	e8 36 07 00 00       	call   c0103c3f <alloc_pages>
c0103509:	85 c0                	test   %eax,%eax
c010350b:	74 24                	je     c0103531 <default_check+0x260>
c010350d:	c7 44 24 0c ec 67 10 	movl   $0xc01067ec,0xc(%esp)
c0103514:	c0 
c0103515:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010351c:	c0 
c010351d:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103524:	00 
c0103525:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010352c:	e8 89 d7 ff ff       	call   c0100cba <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103534:	83 c0 28             	add    $0x28,%eax
c0103537:	83 c0 04             	add    $0x4,%eax
c010353a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103541:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103544:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103547:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010354a:	0f a3 10             	bt     %edx,(%eax)
c010354d:	19 c0                	sbb    %eax,%eax
c010354f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103552:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103556:	0f 95 c0             	setne  %al
c0103559:	0f b6 c0             	movzbl %al,%eax
c010355c:	85 c0                	test   %eax,%eax
c010355e:	74 0e                	je     c010356e <default_check+0x29d>
c0103560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103563:	83 c0 28             	add    $0x28,%eax
c0103566:	8b 40 08             	mov    0x8(%eax),%eax
c0103569:	83 f8 03             	cmp    $0x3,%eax
c010356c:	74 24                	je     c0103592 <default_check+0x2c1>
c010356e:	c7 44 24 0c 04 68 10 	movl   $0xc0106804,0xc(%esp)
c0103575:	c0 
c0103576:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010357d:	c0 
c010357e:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103585:	00 
c0103586:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010358d:	e8 28 d7 ff ff       	call   c0100cba <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103592:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103599:	e8 a1 06 00 00       	call   c0103c3f <alloc_pages>
c010359e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01035a5:	75 24                	jne    c01035cb <default_check+0x2fa>
c01035a7:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c01035ae:	c0 
c01035af:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c01035be:	00 
c01035bf:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01035c6:	e8 ef d6 ff ff       	call   c0100cba <__panic>
    assert(alloc_page() == NULL);
c01035cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035d2:	e8 68 06 00 00       	call   c0103c3f <alloc_pages>
c01035d7:	85 c0                	test   %eax,%eax
c01035d9:	74 24                	je     c01035ff <default_check+0x32e>
c01035db:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c01035e2:	c0 
c01035e3:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01035ea:	c0 
c01035eb:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01035f2:	00 
c01035f3:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01035fa:	e8 bb d6 ff ff       	call   c0100cba <__panic>
    assert(p0 + 2 == p1);
c01035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103602:	83 c0 28             	add    $0x28,%eax
c0103605:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103608:	74 24                	je     c010362e <default_check+0x35d>
c010360a:	c7 44 24 0c 4e 68 10 	movl   $0xc010684e,0xc(%esp)
c0103611:	c0 
c0103612:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103619:	c0 
c010361a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103621:	00 
c0103622:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103629:	e8 8c d6 ff ff       	call   c0100cba <__panic>

    p2 = p0 + 1;
c010362e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103631:	83 c0 14             	add    $0x14,%eax
c0103634:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103637:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010363e:	00 
c010363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103642:	89 04 24             	mov    %eax,(%esp)
c0103645:	e8 2d 06 00 00       	call   c0103c77 <free_pages>
    free_pages(p1, 3);
c010364a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103651:	00 
c0103652:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103655:	89 04 24             	mov    %eax,(%esp)
c0103658:	e8 1a 06 00 00       	call   c0103c77 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103660:	83 c0 04             	add    $0x4,%eax
c0103663:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010366a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010366d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103670:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103673:	0f a3 10             	bt     %edx,(%eax)
c0103676:	19 c0                	sbb    %eax,%eax
c0103678:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010367b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010367f:	0f 95 c0             	setne  %al
c0103682:	0f b6 c0             	movzbl %al,%eax
c0103685:	85 c0                	test   %eax,%eax
c0103687:	74 0b                	je     c0103694 <default_check+0x3c3>
c0103689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010368c:	8b 40 08             	mov    0x8(%eax),%eax
c010368f:	83 f8 01             	cmp    $0x1,%eax
c0103692:	74 24                	je     c01036b8 <default_check+0x3e7>
c0103694:	c7 44 24 0c 5c 68 10 	movl   $0xc010685c,0xc(%esp)
c010369b:	c0 
c010369c:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01036a3:	c0 
c01036a4:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01036ab:	00 
c01036ac:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01036b3:	e8 02 d6 ff ff       	call   c0100cba <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01036b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036bb:	83 c0 04             	add    $0x4,%eax
c01036be:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01036c5:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036c8:	8b 45 90             	mov    -0x70(%ebp),%eax
c01036cb:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01036ce:	0f a3 10             	bt     %edx,(%eax)
c01036d1:	19 c0                	sbb    %eax,%eax
c01036d3:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01036d6:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01036da:	0f 95 c0             	setne  %al
c01036dd:	0f b6 c0             	movzbl %al,%eax
c01036e0:	85 c0                	test   %eax,%eax
c01036e2:	74 0b                	je     c01036ef <default_check+0x41e>
c01036e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036e7:	8b 40 08             	mov    0x8(%eax),%eax
c01036ea:	83 f8 03             	cmp    $0x3,%eax
c01036ed:	74 24                	je     c0103713 <default_check+0x442>
c01036ef:	c7 44 24 0c 84 68 10 	movl   $0xc0106884,0xc(%esp)
c01036f6:	c0 
c01036f7:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01036fe:	c0 
c01036ff:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103706:	00 
c0103707:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010370e:	e8 a7 d5 ff ff       	call   c0100cba <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103713:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010371a:	e8 20 05 00 00       	call   c0103c3f <alloc_pages>
c010371f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103722:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103725:	83 e8 14             	sub    $0x14,%eax
c0103728:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010372b:	74 24                	je     c0103751 <default_check+0x480>
c010372d:	c7 44 24 0c aa 68 10 	movl   $0xc01068aa,0xc(%esp)
c0103734:	c0 
c0103735:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010373c:	c0 
c010373d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103744:	00 
c0103745:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010374c:	e8 69 d5 ff ff       	call   c0100cba <__panic>
    free_page(p0);
c0103751:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103758:	00 
c0103759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010375c:	89 04 24             	mov    %eax,(%esp)
c010375f:	e8 13 05 00 00       	call   c0103c77 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103764:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010376b:	e8 cf 04 00 00       	call   c0103c3f <alloc_pages>
c0103770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103773:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103776:	83 c0 14             	add    $0x14,%eax
c0103779:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010377c:	74 24                	je     c01037a2 <default_check+0x4d1>
c010377e:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c0103785:	c0 
c0103786:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010378d:	c0 
c010378e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103795:	00 
c0103796:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010379d:	e8 18 d5 ff ff       	call   c0100cba <__panic>

    free_pages(p0, 2);
c01037a2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01037a9:	00 
c01037aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ad:	89 04 24             	mov    %eax,(%esp)
c01037b0:	e8 c2 04 00 00       	call   c0103c77 <free_pages>
    free_page(p2);
c01037b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037bc:	00 
c01037bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037c0:	89 04 24             	mov    %eax,(%esp)
c01037c3:	e8 af 04 00 00       	call   c0103c77 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01037c8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037cf:	e8 6b 04 00 00       	call   c0103c3f <alloc_pages>
c01037d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037db:	75 24                	jne    c0103801 <default_check+0x530>
c01037dd:	c7 44 24 0c e8 68 10 	movl   $0xc01068e8,0xc(%esp)
c01037e4:	c0 
c01037e5:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01037ec:	c0 
c01037ed:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01037f4:	00 
c01037f5:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01037fc:	e8 b9 d4 ff ff       	call   c0100cba <__panic>
    assert(alloc_page() == NULL);
c0103801:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103808:	e8 32 04 00 00       	call   c0103c3f <alloc_pages>
c010380d:	85 c0                	test   %eax,%eax
c010380f:	74 24                	je     c0103835 <default_check+0x564>
c0103811:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c0103818:	c0 
c0103819:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c0103820:	c0 
c0103821:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103828:	00 
c0103829:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0103830:	e8 85 d4 ff ff       	call   c0100cba <__panic>

    assert(nr_free == 0);
c0103835:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010383a:	85 c0                	test   %eax,%eax
c010383c:	74 24                	je     c0103862 <default_check+0x591>
c010383e:	c7 44 24 0c 99 67 10 	movl   $0xc0106799,0xc(%esp)
c0103845:	c0 
c0103846:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010384d:	c0 
c010384e:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103855:	00 
c0103856:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010385d:	e8 58 d4 ff ff       	call   c0100cba <__panic>
    nr_free = nr_free_store;
c0103862:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103865:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c010386a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010386d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103870:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103875:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010387b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103882:	00 
c0103883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103886:	89 04 24             	mov    %eax,(%esp)
c0103889:	e8 e9 03 00 00       	call   c0103c77 <free_pages>

    le = &free_list;
c010388e:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103895:	eb 1d                	jmp    c01038b4 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103897:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010389a:	83 e8 0c             	sub    $0xc,%eax
c010389d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01038a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01038a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01038a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038aa:	8b 40 08             	mov    0x8(%eax),%eax
c01038ad:	29 c2                	sub    %eax,%edx
c01038af:	89 d0                	mov    %edx,%eax
c01038b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038b7:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01038ba:	8b 45 88             	mov    -0x78(%ebp),%eax
c01038bd:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01038c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038c3:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01038ca:	75 cb                	jne    c0103897 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01038cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038d0:	74 24                	je     c01038f6 <default_check+0x625>
c01038d2:	c7 44 24 0c 06 69 10 	movl   $0xc0106906,0xc(%esp)
c01038d9:	c0 
c01038da:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01038e9:	00 
c01038ea:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c01038f1:	e8 c4 d3 ff ff       	call   c0100cba <__panic>
    assert(total == 0);
c01038f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038fa:	74 24                	je     c0103920 <default_check+0x64f>
c01038fc:	c7 44 24 0c 11 69 10 	movl   $0xc0106911,0xc(%esp)
c0103903:	c0 
c0103904:	c7 44 24 08 d6 65 10 	movl   $0xc01065d6,0x8(%esp)
c010390b:	c0 
c010390c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103913:	00 
c0103914:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c010391b:	e8 9a d3 ff ff       	call   c0100cba <__panic>
}
c0103920:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103926:	5b                   	pop    %ebx
c0103927:	5d                   	pop    %ebp
c0103928:	c3                   	ret    

c0103929 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103929:	55                   	push   %ebp
c010392a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010392c:	8b 55 08             	mov    0x8(%ebp),%edx
c010392f:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103934:	29 c2                	sub    %eax,%edx
c0103936:	89 d0                	mov    %edx,%eax
c0103938:	c1 f8 02             	sar    $0x2,%eax
c010393b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103941:	5d                   	pop    %ebp
c0103942:	c3                   	ret    

c0103943 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103943:	55                   	push   %ebp
c0103944:	89 e5                	mov    %esp,%ebp
c0103946:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103949:	8b 45 08             	mov    0x8(%ebp),%eax
c010394c:	89 04 24             	mov    %eax,(%esp)
c010394f:	e8 d5 ff ff ff       	call   c0103929 <page2ppn>
c0103954:	c1 e0 0c             	shl    $0xc,%eax
}
c0103957:	c9                   	leave  
c0103958:	c3                   	ret    

c0103959 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103959:	55                   	push   %ebp
c010395a:	89 e5                	mov    %esp,%ebp
c010395c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010395f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103962:	c1 e8 0c             	shr    $0xc,%eax
c0103965:	89 c2                	mov    %eax,%edx
c0103967:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010396c:	39 c2                	cmp    %eax,%edx
c010396e:	72 1c                	jb     c010398c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103970:	c7 44 24 08 4c 69 10 	movl   $0xc010694c,0x8(%esp)
c0103977:	c0 
c0103978:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010397f:	00 
c0103980:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103987:	e8 2e d3 ff ff       	call   c0100cba <__panic>
    }
    return &pages[PPN(pa)];
c010398c:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103992:	8b 45 08             	mov    0x8(%ebp),%eax
c0103995:	c1 e8 0c             	shr    $0xc,%eax
c0103998:	89 c2                	mov    %eax,%edx
c010399a:	89 d0                	mov    %edx,%eax
c010399c:	c1 e0 02             	shl    $0x2,%eax
c010399f:	01 d0                	add    %edx,%eax
c01039a1:	c1 e0 02             	shl    $0x2,%eax
c01039a4:	01 c8                	add    %ecx,%eax
}
c01039a6:	c9                   	leave  
c01039a7:	c3                   	ret    

c01039a8 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01039a8:	55                   	push   %ebp
c01039a9:	89 e5                	mov    %esp,%ebp
c01039ab:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01039ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b1:	89 04 24             	mov    %eax,(%esp)
c01039b4:	e8 8a ff ff ff       	call   c0103943 <page2pa>
c01039b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039bf:	c1 e8 0c             	shr    $0xc,%eax
c01039c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039c5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039ca:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01039cd:	72 23                	jb     c01039f2 <page2kva+0x4a>
c01039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039d6:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c01039dd:	c0 
c01039de:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01039e5:	00 
c01039e6:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01039ed:	e8 c8 d2 ff ff       	call   c0100cba <__panic>
c01039f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01039fa:	c9                   	leave  
c01039fb:	c3                   	ret    

c01039fc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01039fc:	55                   	push   %ebp
c01039fd:	89 e5                	mov    %esp,%ebp
c01039ff:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a05:	83 e0 01             	and    $0x1,%eax
c0103a08:	85 c0                	test   %eax,%eax
c0103a0a:	75 1c                	jne    c0103a28 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a0c:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c0103a13:	c0 
c0103a14:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a1b:	00 
c0103a1c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103a23:	e8 92 d2 ff ff       	call   c0100cba <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a30:	89 04 24             	mov    %eax,(%esp)
c0103a33:	e8 21 ff ff ff       	call   c0103959 <pa2page>
}
c0103a38:	c9                   	leave  
c0103a39:	c3                   	ret    

c0103a3a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103a3a:	55                   	push   %ebp
c0103a3b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a40:	8b 00                	mov    (%eax),%eax
}
c0103a42:	5d                   	pop    %ebp
c0103a43:	c3                   	ret    

c0103a44 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103a44:	55                   	push   %ebp
c0103a45:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a4d:	89 10                	mov    %edx,(%eax)
}
c0103a4f:	5d                   	pop    %ebp
c0103a50:	c3                   	ret    

c0103a51 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103a51:	55                   	push   %ebp
c0103a52:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a57:	8b 00                	mov    (%eax),%eax
c0103a59:	8d 50 01             	lea    0x1(%eax),%edx
c0103a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a64:	8b 00                	mov    (%eax),%eax
}
c0103a66:	5d                   	pop    %ebp
c0103a67:	c3                   	ret    

c0103a68 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103a68:	55                   	push   %ebp
c0103a69:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6e:	8b 00                	mov    (%eax),%eax
c0103a70:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a76:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7b:	8b 00                	mov    (%eax),%eax
}
c0103a7d:	5d                   	pop    %ebp
c0103a7e:	c3                   	ret    

c0103a7f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103a7f:	55                   	push   %ebp
c0103a80:	89 e5                	mov    %esp,%ebp
c0103a82:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a85:	9c                   	pushf  
c0103a86:	58                   	pop    %eax
c0103a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a8d:	25 00 02 00 00       	and    $0x200,%eax
c0103a92:	85 c0                	test   %eax,%eax
c0103a94:	74 0c                	je     c0103aa2 <__intr_save+0x23>
        intr_disable();
c0103a96:	e8 02 dc ff ff       	call   c010169d <intr_disable>
        return 1;
c0103a9b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103aa0:	eb 05                	jmp    c0103aa7 <__intr_save+0x28>
    }
    return 0;
c0103aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103aa7:	c9                   	leave  
c0103aa8:	c3                   	ret    

c0103aa9 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103aa9:	55                   	push   %ebp
c0103aaa:	89 e5                	mov    %esp,%ebp
c0103aac:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103aaf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103ab3:	74 05                	je     c0103aba <__intr_restore+0x11>
        intr_enable();
c0103ab5:	e8 dd db ff ff       	call   c0101697 <intr_enable>
    }
}
c0103aba:	c9                   	leave  
c0103abb:	c3                   	ret    

c0103abc <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103abc:	55                   	push   %ebp
c0103abd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ac5:	b8 23 00 00 00       	mov    $0x23,%eax
c0103aca:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103acc:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ad1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103ad3:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ad8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103ada:	b8 10 00 00 00       	mov    $0x10,%eax
c0103adf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103ae1:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ae6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103ae8:	ea ef 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103aef
}
c0103aef:	5d                   	pop    %ebp
c0103af0:	c3                   	ret    

c0103af1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103af1:	55                   	push   %ebp
c0103af2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af7:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103afc:	5d                   	pop    %ebp
c0103afd:	c3                   	ret    

c0103afe <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103afe:	55                   	push   %ebp
c0103aff:	89 e5                	mov    %esp,%ebp
c0103b01:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b04:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b09:	89 04 24             	mov    %eax,(%esp)
c0103b0c:	e8 e0 ff ff ff       	call   c0103af1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b11:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b18:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b1a:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b21:	68 00 
c0103b23:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b28:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103b2e:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b33:	c1 e8 10             	shr    $0x10,%eax
c0103b36:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103b3b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b42:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b45:	83 c8 09             	or     $0x9,%eax
c0103b48:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b4d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b54:	83 e0 ef             	and    $0xffffffef,%eax
c0103b57:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b5c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b63:	83 e0 9f             	and    $0xffffff9f,%eax
c0103b66:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b6b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b72:	83 c8 80             	or     $0xffffff80,%eax
c0103b75:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b7a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b81:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b84:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b89:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b90:	83 e0 ef             	and    $0xffffffef,%eax
c0103b93:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b98:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b9f:	83 e0 df             	and    $0xffffffdf,%eax
c0103ba2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ba7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bae:	83 c8 40             	or     $0x40,%eax
c0103bb1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bb6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bbd:	83 e0 7f             	and    $0x7f,%eax
c0103bc0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bc5:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bca:	c1 e8 18             	shr    $0x18,%eax
c0103bcd:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103bd2:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103bd9:	e8 de fe ff ff       	call   c0103abc <lgdt>
c0103bde:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103be4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103be8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103beb:	c9                   	leave  
c0103bec:	c3                   	ret    

c0103bed <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103bed:	55                   	push   %ebp
c0103bee:	89 e5                	mov    %esp,%ebp
c0103bf0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103bf3:	c7 05 5c 89 11 c0 30 	movl   $0xc0106930,0xc011895c
c0103bfa:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103bfd:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c02:	8b 00                	mov    (%eax),%eax
c0103c04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c08:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0103c0f:	e8 28 c7 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c14:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c19:	8b 40 04             	mov    0x4(%eax),%eax
c0103c1c:	ff d0                	call   *%eax
}
c0103c1e:	c9                   	leave  
c0103c1f:	c3                   	ret    

c0103c20 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c20:	55                   	push   %ebp
c0103c21:	89 e5                	mov    %esp,%ebp
c0103c23:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c26:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c2b:	8b 40 08             	mov    0x8(%eax),%eax
c0103c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c31:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c35:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c38:	89 14 24             	mov    %edx,(%esp)
c0103c3b:	ff d0                	call   *%eax
}
c0103c3d:	c9                   	leave  
c0103c3e:	c3                   	ret    

c0103c3f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103c3f:	55                   	push   %ebp
c0103c40:	89 e5                	mov    %esp,%ebp
c0103c42:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c4c:	e8 2e fe ff ff       	call   c0103a7f <__intr_save>
c0103c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103c54:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c59:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c5c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c5f:	89 14 24             	mov    %edx,(%esp)
c0103c62:	ff d0                	call   *%eax
c0103c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c6a:	89 04 24             	mov    %eax,(%esp)
c0103c6d:	e8 37 fe ff ff       	call   c0103aa9 <__intr_restore>
    return page;
c0103c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c75:	c9                   	leave  
c0103c76:	c3                   	ret    

c0103c77 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c77:	55                   	push   %ebp
c0103c78:	89 e5                	mov    %esp,%ebp
c0103c7a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c7d:	e8 fd fd ff ff       	call   c0103a7f <__intr_save>
c0103c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c85:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c8a:	8b 40 10             	mov    0x10(%eax),%eax
c0103c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c90:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c94:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c97:	89 14 24             	mov    %edx,(%esp)
c0103c9a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9f:	89 04 24             	mov    %eax,(%esp)
c0103ca2:	e8 02 fe ff ff       	call   c0103aa9 <__intr_restore>
}
c0103ca7:	c9                   	leave  
c0103ca8:	c3                   	ret    

c0103ca9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103ca9:	55                   	push   %ebp
c0103caa:	89 e5                	mov    %esp,%ebp
c0103cac:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103caf:	e8 cb fd ff ff       	call   c0103a7f <__intr_save>
c0103cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103cb7:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cbc:	8b 40 14             	mov    0x14(%eax),%eax
c0103cbf:	ff d0                	call   *%eax
c0103cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc7:	89 04 24             	mov    %eax,(%esp)
c0103cca:	e8 da fd ff ff       	call   c0103aa9 <__intr_restore>
    return ret;
c0103ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103cd2:	c9                   	leave  
c0103cd3:	c3                   	ret    

c0103cd4 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103cd4:	55                   	push   %ebp
c0103cd5:	89 e5                	mov    %esp,%ebp
c0103cd7:	57                   	push   %edi
c0103cd8:	56                   	push   %esi
c0103cd9:	53                   	push   %ebx
c0103cda:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103ce0:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103ce7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103cee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103cf5:	c7 04 24 e3 69 10 c0 	movl   $0xc01069e3,(%esp)
c0103cfc:	e8 3b c6 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d08:	e9 15 01 00 00       	jmp    c0103e22 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d0d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d10:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d13:	89 d0                	mov    %edx,%eax
c0103d15:	c1 e0 02             	shl    $0x2,%eax
c0103d18:	01 d0                	add    %edx,%eax
c0103d1a:	c1 e0 02             	shl    $0x2,%eax
c0103d1d:	01 c8                	add    %ecx,%eax
c0103d1f:	8b 50 08             	mov    0x8(%eax),%edx
c0103d22:	8b 40 04             	mov    0x4(%eax),%eax
c0103d25:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d28:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103d2b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d31:	89 d0                	mov    %edx,%eax
c0103d33:	c1 e0 02             	shl    $0x2,%eax
c0103d36:	01 d0                	add    %edx,%eax
c0103d38:	c1 e0 02             	shl    $0x2,%eax
c0103d3b:	01 c8                	add    %ecx,%eax
c0103d3d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d40:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d43:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d46:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d49:	01 c8                	add    %ecx,%eax
c0103d4b:	11 da                	adc    %ebx,%edx
c0103d4d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103d50:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103d53:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d56:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d59:	89 d0                	mov    %edx,%eax
c0103d5b:	c1 e0 02             	shl    $0x2,%eax
c0103d5e:	01 d0                	add    %edx,%eax
c0103d60:	c1 e0 02             	shl    $0x2,%eax
c0103d63:	01 c8                	add    %ecx,%eax
c0103d65:	83 c0 14             	add    $0x14,%eax
c0103d68:	8b 00                	mov    (%eax),%eax
c0103d6a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103d70:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d73:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d76:	83 c0 ff             	add    $0xffffffff,%eax
c0103d79:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d7c:	89 c6                	mov    %eax,%esi
c0103d7e:	89 d7                	mov    %edx,%edi
c0103d80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d83:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d86:	89 d0                	mov    %edx,%eax
c0103d88:	c1 e0 02             	shl    $0x2,%eax
c0103d8b:	01 d0                	add    %edx,%eax
c0103d8d:	c1 e0 02             	shl    $0x2,%eax
c0103d90:	01 c8                	add    %ecx,%eax
c0103d92:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d95:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d98:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103d9e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103da2:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103da6:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103daa:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dad:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103db0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103db4:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103db8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103dbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103dc0:	c7 04 24 f0 69 10 c0 	movl   $0xc01069f0,(%esp)
c0103dc7:	e8 70 c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103dcc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dcf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd2:	89 d0                	mov    %edx,%eax
c0103dd4:	c1 e0 02             	shl    $0x2,%eax
c0103dd7:	01 d0                	add    %edx,%eax
c0103dd9:	c1 e0 02             	shl    $0x2,%eax
c0103ddc:	01 c8                	add    %ecx,%eax
c0103dde:	83 c0 14             	add    $0x14,%eax
c0103de1:	8b 00                	mov    (%eax),%eax
c0103de3:	83 f8 01             	cmp    $0x1,%eax
c0103de6:	75 36                	jne    c0103e1e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103deb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dee:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103df1:	77 2b                	ja     c0103e1e <page_init+0x14a>
c0103df3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103df6:	72 05                	jb     c0103dfd <page_init+0x129>
c0103df8:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103dfb:	73 21                	jae    c0103e1e <page_init+0x14a>
c0103dfd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e01:	77 1b                	ja     c0103e1e <page_init+0x14a>
c0103e03:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e07:	72 09                	jb     c0103e12 <page_init+0x13e>
c0103e09:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e10:	77 0c                	ja     c0103e1e <page_init+0x14a>
                maxpa = end;
c0103e12:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e15:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e18:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e1e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e25:	8b 00                	mov    (%eax),%eax
c0103e27:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e2a:	0f 8f dd fe ff ff    	jg     c0103d0d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e34:	72 1d                	jb     c0103e53 <page_init+0x17f>
c0103e36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e3a:	77 09                	ja     c0103e45 <page_init+0x171>
c0103e3c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103e43:	76 0e                	jbe    c0103e53 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103e45:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103e4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e59:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103e5d:	c1 ea 0c             	shr    $0xc,%edx
c0103e60:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103e65:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103e6c:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103e71:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103e74:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103e77:	01 d0                	add    %edx,%eax
c0103e79:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103e7c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103e7f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e84:	f7 75 ac             	divl   -0x54(%ebp)
c0103e87:	89 d0                	mov    %edx,%eax
c0103e89:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103e8c:	29 c2                	sub    %eax,%edx
c0103e8e:	89 d0                	mov    %edx,%eax
c0103e90:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103e95:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e9c:	eb 2f                	jmp    c0103ecd <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103e9e:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103ea4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea7:	89 d0                	mov    %edx,%eax
c0103ea9:	c1 e0 02             	shl    $0x2,%eax
c0103eac:	01 d0                	add    %edx,%eax
c0103eae:	c1 e0 02             	shl    $0x2,%eax
c0103eb1:	01 c8                	add    %ecx,%eax
c0103eb3:	83 c0 04             	add    $0x4,%eax
c0103eb6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103ebd:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103ec0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103ec3:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103ec6:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103ec9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ed0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103ed5:	39 c2                	cmp    %eax,%edx
c0103ed7:	72 c5                	jb     c0103e9e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103ed9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103edf:	89 d0                	mov    %edx,%eax
c0103ee1:	c1 e0 02             	shl    $0x2,%eax
c0103ee4:	01 d0                	add    %edx,%eax
c0103ee6:	c1 e0 02             	shl    $0x2,%eax
c0103ee9:	89 c2                	mov    %eax,%edx
c0103eeb:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103ef0:	01 d0                	add    %edx,%eax
c0103ef2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103ef5:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103efc:	77 23                	ja     c0103f21 <page_init+0x24d>
c0103efe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f01:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f05:	c7 44 24 08 20 6a 10 	movl   $0xc0106a20,0x8(%esp)
c0103f0c:	c0 
c0103f0d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f14:	00 
c0103f15:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0103f1c:	e8 99 cd ff ff       	call   c0100cba <__panic>
c0103f21:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f24:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f29:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f33:	e9 74 01 00 00       	jmp    c01040ac <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f38:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f3e:	89 d0                	mov    %edx,%eax
c0103f40:	c1 e0 02             	shl    $0x2,%eax
c0103f43:	01 d0                	add    %edx,%eax
c0103f45:	c1 e0 02             	shl    $0x2,%eax
c0103f48:	01 c8                	add    %ecx,%eax
c0103f4a:	8b 50 08             	mov    0x8(%eax),%edx
c0103f4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f50:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f53:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103f56:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f59:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f5c:	89 d0                	mov    %edx,%eax
c0103f5e:	c1 e0 02             	shl    $0x2,%eax
c0103f61:	01 d0                	add    %edx,%eax
c0103f63:	c1 e0 02             	shl    $0x2,%eax
c0103f66:	01 c8                	add    %ecx,%eax
c0103f68:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f6b:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f74:	01 c8                	add    %ecx,%eax
c0103f76:	11 da                	adc    %ebx,%edx
c0103f78:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103f7b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103f7e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f81:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f84:	89 d0                	mov    %edx,%eax
c0103f86:	c1 e0 02             	shl    $0x2,%eax
c0103f89:	01 d0                	add    %edx,%eax
c0103f8b:	c1 e0 02             	shl    $0x2,%eax
c0103f8e:	01 c8                	add    %ecx,%eax
c0103f90:	83 c0 14             	add    $0x14,%eax
c0103f93:	8b 00                	mov    (%eax),%eax
c0103f95:	83 f8 01             	cmp    $0x1,%eax
c0103f98:	0f 85 0a 01 00 00    	jne    c01040a8 <page_init+0x3d4>
            if (begin < freemem) {
c0103f9e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103fa1:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fa6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103fa9:	72 17                	jb     c0103fc2 <page_init+0x2ee>
c0103fab:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103fae:	77 05                	ja     c0103fb5 <page_init+0x2e1>
c0103fb0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103fb3:	76 0d                	jbe    c0103fc2 <page_init+0x2ee>
                begin = freemem;
c0103fb5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103fb8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fbb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103fc2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fc6:	72 1d                	jb     c0103fe5 <page_init+0x311>
c0103fc8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fcc:	77 09                	ja     c0103fd7 <page_init+0x303>
c0103fce:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103fd5:	76 0e                	jbe    c0103fe5 <page_init+0x311>
                end = KMEMSIZE;
c0103fd7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103fde:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fe8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103feb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103fee:	0f 87 b4 00 00 00    	ja     c01040a8 <page_init+0x3d4>
c0103ff4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103ff7:	72 09                	jb     c0104002 <page_init+0x32e>
c0103ff9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103ffc:	0f 83 a6 00 00 00    	jae    c01040a8 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104002:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104009:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010400c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010400f:	01 d0                	add    %edx,%eax
c0104011:	83 e8 01             	sub    $0x1,%eax
c0104014:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104017:	8b 45 98             	mov    -0x68(%ebp),%eax
c010401a:	ba 00 00 00 00       	mov    $0x0,%edx
c010401f:	f7 75 9c             	divl   -0x64(%ebp)
c0104022:	89 d0                	mov    %edx,%eax
c0104024:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104027:	29 c2                	sub    %eax,%edx
c0104029:	89 d0                	mov    %edx,%eax
c010402b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104030:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104033:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104036:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104039:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010403c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010403f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104044:	89 c7                	mov    %eax,%edi
c0104046:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010404c:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010404f:	89 d0                	mov    %edx,%eax
c0104051:	83 e0 00             	and    $0x0,%eax
c0104054:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104057:	8b 45 80             	mov    -0x80(%ebp),%eax
c010405a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010405d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104060:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104063:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104066:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104069:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010406c:	77 3a                	ja     c01040a8 <page_init+0x3d4>
c010406e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104071:	72 05                	jb     c0104078 <page_init+0x3a4>
c0104073:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104076:	73 30                	jae    c01040a8 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104078:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010407b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010407e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104081:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104084:	29 c8                	sub    %ecx,%eax
c0104086:	19 da                	sbb    %ebx,%edx
c0104088:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010408c:	c1 ea 0c             	shr    $0xc,%edx
c010408f:	89 c3                	mov    %eax,%ebx
c0104091:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104094:	89 04 24             	mov    %eax,(%esp)
c0104097:	e8 bd f8 ff ff       	call   c0103959 <pa2page>
c010409c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01040a0:	89 04 24             	mov    %eax,(%esp)
c01040a3:	e8 78 fb ff ff       	call   c0103c20 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01040a8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040af:	8b 00                	mov    (%eax),%eax
c01040b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040b4:	0f 8f 7e fe ff ff    	jg     c0103f38 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01040ba:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01040c0:	5b                   	pop    %ebx
c01040c1:	5e                   	pop    %esi
c01040c2:	5f                   	pop    %edi
c01040c3:	5d                   	pop    %ebp
c01040c4:	c3                   	ret    

c01040c5 <enable_paging>:

static void
enable_paging(void) {
c01040c5:	55                   	push   %ebp
c01040c6:	89 e5                	mov    %esp,%ebp
c01040c8:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01040cb:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01040d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01040d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01040d6:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01040d9:	0f 20 c0             	mov    %cr0,%eax
c01040dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01040df:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01040e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01040e5:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01040ec:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01040f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01040f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040f9:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01040fc:	c9                   	leave  
c01040fd:	c3                   	ret    

c01040fe <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01040fe:	55                   	push   %ebp
c01040ff:	89 e5                	mov    %esp,%ebp
c0104101:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104104:	8b 45 14             	mov    0x14(%ebp),%eax
c0104107:	8b 55 0c             	mov    0xc(%ebp),%edx
c010410a:	31 d0                	xor    %edx,%eax
c010410c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104111:	85 c0                	test   %eax,%eax
c0104113:	74 24                	je     c0104139 <boot_map_segment+0x3b>
c0104115:	c7 44 24 0c 52 6a 10 	movl   $0xc0106a52,0xc(%esp)
c010411c:	c0 
c010411d:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104124:	c0 
c0104125:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010412c:	00 
c010412d:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104134:	e8 81 cb ff ff       	call   c0100cba <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104139:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104140:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104143:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104148:	89 c2                	mov    %eax,%edx
c010414a:	8b 45 10             	mov    0x10(%ebp),%eax
c010414d:	01 c2                	add    %eax,%edx
c010414f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104152:	01 d0                	add    %edx,%eax
c0104154:	83 e8 01             	sub    $0x1,%eax
c0104157:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010415a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010415d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104162:	f7 75 f0             	divl   -0x10(%ebp)
c0104165:	89 d0                	mov    %edx,%eax
c0104167:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010416a:	29 c2                	sub    %eax,%edx
c010416c:	89 d0                	mov    %edx,%eax
c010416e:	c1 e8 0c             	shr    $0xc,%eax
c0104171:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104174:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104177:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010417a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010417d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104182:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104185:	8b 45 14             	mov    0x14(%ebp),%eax
c0104188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010418b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010418e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104193:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104196:	eb 6b                	jmp    c0104203 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104198:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010419f:	00 
c01041a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01041aa:	89 04 24             	mov    %eax,(%esp)
c01041ad:	e8 cc 01 00 00       	call   c010437e <get_pte>
c01041b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01041b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01041b9:	75 24                	jne    c01041df <boot_map_segment+0xe1>
c01041bb:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c01041c2:	c0 
c01041c3:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c01041ca:	c0 
c01041cb:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01041d2:	00 
c01041d3:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01041da:	e8 db ca ff ff       	call   c0100cba <__panic>
        *ptep = pa | PTE_P | perm;
c01041df:	8b 45 18             	mov    0x18(%ebp),%eax
c01041e2:	8b 55 14             	mov    0x14(%ebp),%edx
c01041e5:	09 d0                	or     %edx,%eax
c01041e7:	83 c8 01             	or     $0x1,%eax
c01041ea:	89 c2                	mov    %eax,%edx
c01041ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041ef:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01041f1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041f5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01041fc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104207:	75 8f                	jne    c0104198 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104209:	c9                   	leave  
c010420a:	c3                   	ret    

c010420b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010420b:	55                   	push   %ebp
c010420c:	89 e5                	mov    %esp,%ebp
c010420e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104211:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104218:	e8 22 fa ff ff       	call   c0103c3f <alloc_pages>
c010421d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104224:	75 1c                	jne    c0104242 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104226:	c7 44 24 08 8b 6a 10 	movl   $0xc0106a8b,0x8(%esp)
c010422d:	c0 
c010422e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104235:	00 
c0104236:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c010423d:	e8 78 ca ff ff       	call   c0100cba <__panic>
    }
    return page2kva(p);
c0104242:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104245:	89 04 24             	mov    %eax,(%esp)
c0104248:	e8 5b f7 ff ff       	call   c01039a8 <page2kva>
}
c010424d:	c9                   	leave  
c010424e:	c3                   	ret    

c010424f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010424f:	55                   	push   %ebp
c0104250:	89 e5                	mov    %esp,%ebp
c0104252:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104255:	e8 93 f9 ff ff       	call   c0103bed <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010425a:	e8 75 fa ff ff       	call   c0103cd4 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010425f:	e8 66 04 00 00       	call   c01046ca <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104264:	e8 a2 ff ff ff       	call   c010420b <boot_alloc_page>
c0104269:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010426e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104273:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010427a:	00 
c010427b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104282:	00 
c0104283:	89 04 24             	mov    %eax,(%esp)
c0104286:	e8 a8 1a 00 00       	call   c0105d33 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010428b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104290:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104293:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010429a:	77 23                	ja     c01042bf <pmm_init+0x70>
c010429c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010429f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042a3:	c7 44 24 08 20 6a 10 	movl   $0xc0106a20,0x8(%esp)
c01042aa:	c0 
c01042ab:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01042b2:	00 
c01042b3:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01042ba:	e8 fb c9 ff ff       	call   c0100cba <__panic>
c01042bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01042c7:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01042cc:	e8 17 04 00 00       	call   c01046e8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01042d1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042d6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01042dc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042e4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01042eb:	77 23                	ja     c0104310 <pmm_init+0xc1>
c01042ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042f4:	c7 44 24 08 20 6a 10 	movl   $0xc0106a20,0x8(%esp)
c01042fb:	c0 
c01042fc:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104303:	00 
c0104304:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c010430b:	e8 aa c9 ff ff       	call   c0100cba <__panic>
c0104310:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104313:	05 00 00 00 40       	add    $0x40000000,%eax
c0104318:	83 c8 03             	or     $0x3,%eax
c010431b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010431d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104322:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104329:	00 
c010432a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104331:	00 
c0104332:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104339:	38 
c010433a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104341:	c0 
c0104342:	89 04 24             	mov    %eax,(%esp)
c0104345:	e8 b4 fd ff ff       	call   c01040fe <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010434a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010434f:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104355:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010435b:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010435d:	e8 63 fd ff ff       	call   c01040c5 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104362:	e8 97 f7 ff ff       	call   c0103afe <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104367:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010436c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104372:	e8 0c 0a 00 00       	call   c0104d83 <check_boot_pgdir>

    print_pgdir();
c0104377:	e8 99 0e 00 00       	call   c0105215 <print_pgdir>

}
c010437c:	c9                   	leave  
c010437d:	c3                   	ret    

c010437e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010437e:	55                   	push   %ebp
c010437f:	89 e5                	mov    %esp,%ebp
c0104381:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104384:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104387:	c1 e8 16             	shr    $0x16,%eax
c010438a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104391:	8b 45 08             	mov    0x8(%ebp),%eax
c0104394:	01 d0                	add    %edx,%eax
c0104396:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104399:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439c:	8b 00                	mov    (%eax),%eax
c010439e:	83 e0 01             	and    $0x1,%eax
c01043a1:	85 c0                	test   %eax,%eax
c01043a3:	0f 85 af 00 00 00    	jne    c0104458 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01043a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01043ad:	74 15                	je     c01043c4 <get_pte+0x46>
c01043af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043b6:	e8 84 f8 ff ff       	call   c0103c3f <alloc_pages>
c01043bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043c2:	75 0a                	jne    c01043ce <get_pte+0x50>
            return NULL;
c01043c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01043c9:	e9 e6 00 00 00       	jmp    c01044b4 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01043ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043d5:	00 
c01043d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d9:	89 04 24             	mov    %eax,(%esp)
c01043dc:	e8 63 f6 ff ff       	call   c0103a44 <set_page_ref>
        uintptr_t pa = page2pa(page);
c01043e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043e4:	89 04 24             	mov    %eax,(%esp)
c01043e7:	e8 57 f5 ff ff       	call   c0103943 <page2pa>
c01043ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01043ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f8:	c1 e8 0c             	shr    $0xc,%eax
c01043fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043fe:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104403:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104406:	72 23                	jb     c010442b <get_pte+0xad>
c0104408:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010440b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010440f:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c0104416:	c0 
c0104417:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c010441e:	00 
c010441f:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104426:	e8 8f c8 ff ff       	call   c0100cba <__panic>
c010442b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010442e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104433:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010443a:	00 
c010443b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104442:	00 
c0104443:	89 04 24             	mov    %eax,(%esp)
c0104446:	e8 e8 18 00 00       	call   c0105d33 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010444b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010444e:	83 c8 07             	or     $0x7,%eax
c0104451:	89 c2                	mov    %eax,%edx
c0104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104456:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445b:	8b 00                	mov    (%eax),%eax
c010445d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104462:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104465:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104468:	c1 e8 0c             	shr    $0xc,%eax
c010446b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010446e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104473:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104476:	72 23                	jb     c010449b <get_pte+0x11d>
c0104478:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010447b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010447f:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c0104486:	c0 
c0104487:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c010448e:	00 
c010448f:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104496:	e8 1f c8 ff ff       	call   c0100cba <__panic>
c010449b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010449e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044a3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044a6:	c1 ea 0c             	shr    $0xc,%edx
c01044a9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01044af:	c1 e2 02             	shl    $0x2,%edx
c01044b2:	01 d0                	add    %edx,%eax
}
c01044b4:	c9                   	leave  
c01044b5:	c3                   	ret    

c01044b6 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01044b6:	55                   	push   %ebp
c01044b7:	89 e5                	mov    %esp,%ebp
c01044b9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044c3:	00 
c01044c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ce:	89 04 24             	mov    %eax,(%esp)
c01044d1:	e8 a8 fe ff ff       	call   c010437e <get_pte>
c01044d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01044d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044dd:	74 08                	je     c01044e7 <get_page+0x31>
        *ptep_store = ptep;
c01044df:	8b 45 10             	mov    0x10(%ebp),%eax
c01044e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044e5:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01044e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044eb:	74 1b                	je     c0104508 <get_page+0x52>
c01044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f0:	8b 00                	mov    (%eax),%eax
c01044f2:	83 e0 01             	and    $0x1,%eax
c01044f5:	85 c0                	test   %eax,%eax
c01044f7:	74 0f                	je     c0104508 <get_page+0x52>
        return pa2page(*ptep);
c01044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fc:	8b 00                	mov    (%eax),%eax
c01044fe:	89 04 24             	mov    %eax,(%esp)
c0104501:	e8 53 f4 ff ff       	call   c0103959 <pa2page>
c0104506:	eb 05                	jmp    c010450d <get_page+0x57>
    }
    return NULL;
c0104508:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010450d:	c9                   	leave  
c010450e:	c3                   	ret    

c010450f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010450f:	55                   	push   %ebp
c0104510:	89 e5                	mov    %esp,%ebp
c0104512:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104515:	8b 45 10             	mov    0x10(%ebp),%eax
c0104518:	8b 00                	mov    (%eax),%eax
c010451a:	83 e0 01             	and    $0x1,%eax
c010451d:	85 c0                	test   %eax,%eax
c010451f:	74 4d                	je     c010456e <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0104521:	8b 45 10             	mov    0x10(%ebp),%eax
c0104524:	8b 00                	mov    (%eax),%eax
c0104526:	89 04 24             	mov    %eax,(%esp)
c0104529:	e8 ce f4 ff ff       	call   c01039fc <pte2page>
c010452e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104534:	89 04 24             	mov    %eax,(%esp)
c0104537:	e8 2c f5 ff ff       	call   c0103a68 <page_ref_dec>
c010453c:	85 c0                	test   %eax,%eax
c010453e:	75 13                	jne    c0104553 <page_remove_pte+0x44>
            free_page(page);
c0104540:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104547:	00 
c0104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454b:	89 04 24             	mov    %eax,(%esp)
c010454e:	e8 24 f7 ff ff       	call   c0103c77 <free_pages>
        }
        *ptep = 0;
c0104553:	8b 45 10             	mov    0x10(%ebp),%eax
c0104556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010455c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010455f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104563:	8b 45 08             	mov    0x8(%ebp),%eax
c0104566:	89 04 24             	mov    %eax,(%esp)
c0104569:	e8 ff 00 00 00       	call   c010466d <tlb_invalidate>
    }
}
c010456e:	c9                   	leave  
c010456f:	c3                   	ret    

c0104570 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104570:	55                   	push   %ebp
c0104571:	89 e5                	mov    %esp,%ebp
c0104573:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104576:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010457d:	00 
c010457e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104581:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104585:	8b 45 08             	mov    0x8(%ebp),%eax
c0104588:	89 04 24             	mov    %eax,(%esp)
c010458b:	e8 ee fd ff ff       	call   c010437e <get_pte>
c0104590:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104597:	74 19                	je     c01045b2 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104599:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459c:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045aa:	89 04 24             	mov    %eax,(%esp)
c01045ad:	e8 5d ff ff ff       	call   c010450f <page_remove_pte>
    }
}
c01045b2:	c9                   	leave  
c01045b3:	c3                   	ret    

c01045b4 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01045b4:	55                   	push   %ebp
c01045b5:	89 e5                	mov    %esp,%ebp
c01045b7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01045ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045c1:	00 
c01045c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01045c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01045cc:	89 04 24             	mov    %eax,(%esp)
c01045cf:	e8 aa fd ff ff       	call   c010437e <get_pte>
c01045d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01045d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045db:	75 0a                	jne    c01045e7 <page_insert+0x33>
        return -E_NO_MEM;
c01045dd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01045e2:	e9 84 00 00 00       	jmp    c010466b <page_insert+0xb7>
    }
    page_ref_inc(page);
c01045e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ea:	89 04 24             	mov    %eax,(%esp)
c01045ed:	e8 5f f4 ff ff       	call   c0103a51 <page_ref_inc>
    if (*ptep & PTE_P) {
c01045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f5:	8b 00                	mov    (%eax),%eax
c01045f7:	83 e0 01             	and    $0x1,%eax
c01045fa:	85 c0                	test   %eax,%eax
c01045fc:	74 3e                	je     c010463c <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104601:	8b 00                	mov    (%eax),%eax
c0104603:	89 04 24             	mov    %eax,(%esp)
c0104606:	e8 f1 f3 ff ff       	call   c01039fc <pte2page>
c010460b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010460e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104611:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104614:	75 0d                	jne    c0104623 <page_insert+0x6f>
            page_ref_dec(page);
c0104616:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104619:	89 04 24             	mov    %eax,(%esp)
c010461c:	e8 47 f4 ff ff       	call   c0103a68 <page_ref_dec>
c0104621:	eb 19                	jmp    c010463c <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104626:	89 44 24 08          	mov    %eax,0x8(%esp)
c010462a:	8b 45 10             	mov    0x10(%ebp),%eax
c010462d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104631:	8b 45 08             	mov    0x8(%ebp),%eax
c0104634:	89 04 24             	mov    %eax,(%esp)
c0104637:	e8 d3 fe ff ff       	call   c010450f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010463c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010463f:	89 04 24             	mov    %eax,(%esp)
c0104642:	e8 fc f2 ff ff       	call   c0103943 <page2pa>
c0104647:	0b 45 14             	or     0x14(%ebp),%eax
c010464a:	83 c8 01             	or     $0x1,%eax
c010464d:	89 c2                	mov    %eax,%edx
c010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104652:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104654:	8b 45 10             	mov    0x10(%ebp),%eax
c0104657:	89 44 24 04          	mov    %eax,0x4(%esp)
c010465b:	8b 45 08             	mov    0x8(%ebp),%eax
c010465e:	89 04 24             	mov    %eax,(%esp)
c0104661:	e8 07 00 00 00       	call   c010466d <tlb_invalidate>
    return 0;
c0104666:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010466b:	c9                   	leave  
c010466c:	c3                   	ret    

c010466d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010466d:	55                   	push   %ebp
c010466e:	89 e5                	mov    %esp,%ebp
c0104670:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104673:	0f 20 d8             	mov    %cr3,%eax
c0104676:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104679:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010467c:	89 c2                	mov    %eax,%edx
c010467e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104681:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104684:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010468b:	77 23                	ja     c01046b0 <tlb_invalidate+0x43>
c010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104690:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104694:	c7 44 24 08 20 6a 10 	movl   $0xc0106a20,0x8(%esp)
c010469b:	c0 
c010469c:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c01046a3:	00 
c01046a4:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01046ab:	e8 0a c6 ff ff       	call   c0100cba <__panic>
c01046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b3:	05 00 00 00 40       	add    $0x40000000,%eax
c01046b8:	39 c2                	cmp    %eax,%edx
c01046ba:	75 0c                	jne    c01046c8 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01046c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046c5:	0f 01 38             	invlpg (%eax)
    }
}
c01046c8:	c9                   	leave  
c01046c9:	c3                   	ret    

c01046ca <check_alloc_page>:

static void
check_alloc_page(void) {
c01046ca:	55                   	push   %ebp
c01046cb:	89 e5                	mov    %esp,%ebp
c01046cd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01046d0:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01046d5:	8b 40 18             	mov    0x18(%eax),%eax
c01046d8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01046da:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01046e1:	e8 56 bc ff ff       	call   c010033c <cprintf>
}
c01046e6:	c9                   	leave  
c01046e7:	c3                   	ret    

c01046e8 <check_pgdir>:

static void
check_pgdir(void) {
c01046e8:	55                   	push   %ebp
c01046e9:	89 e5                	mov    %esp,%ebp
c01046eb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01046ee:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046f3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01046f8:	76 24                	jbe    c010471e <check_pgdir+0x36>
c01046fa:	c7 44 24 0c c3 6a 10 	movl   $0xc0106ac3,0xc(%esp)
c0104701:	c0 
c0104702:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104709:	c0 
c010470a:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104711:	00 
c0104712:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104719:	e8 9c c5 ff ff       	call   c0100cba <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010471e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104723:	85 c0                	test   %eax,%eax
c0104725:	74 0e                	je     c0104735 <check_pgdir+0x4d>
c0104727:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010472c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104731:	85 c0                	test   %eax,%eax
c0104733:	74 24                	je     c0104759 <check_pgdir+0x71>
c0104735:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c010473c:	c0 
c010473d:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104744:	c0 
c0104745:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c010474c:	00 
c010474d:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104754:	e8 61 c5 ff ff       	call   c0100cba <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104759:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010475e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104765:	00 
c0104766:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010476d:	00 
c010476e:	89 04 24             	mov    %eax,(%esp)
c0104771:	e8 40 fd ff ff       	call   c01044b6 <get_page>
c0104776:	85 c0                	test   %eax,%eax
c0104778:	74 24                	je     c010479e <check_pgdir+0xb6>
c010477a:	c7 44 24 0c 18 6b 10 	movl   $0xc0106b18,0xc(%esp)
c0104781:	c0 
c0104782:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104789:	c0 
c010478a:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104791:	00 
c0104792:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104799:	e8 1c c5 ff ff       	call   c0100cba <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010479e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047a5:	e8 95 f4 ff ff       	call   c0103c3f <alloc_pages>
c01047aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01047ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01047b9:	00 
c01047ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047c1:	00 
c01047c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047c9:	89 04 24             	mov    %eax,(%esp)
c01047cc:	e8 e3 fd ff ff       	call   c01045b4 <page_insert>
c01047d1:	85 c0                	test   %eax,%eax
c01047d3:	74 24                	je     c01047f9 <check_pgdir+0x111>
c01047d5:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c01047dc:	c0 
c01047dd:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c01047e4:	c0 
c01047e5:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01047ec:	00 
c01047ed:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01047f4:	e8 c1 c4 ff ff       	call   c0100cba <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01047f9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104805:	00 
c0104806:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010480d:	00 
c010480e:	89 04 24             	mov    %eax,(%esp)
c0104811:	e8 68 fb ff ff       	call   c010437e <get_pte>
c0104816:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010481d:	75 24                	jne    c0104843 <check_pgdir+0x15b>
c010481f:	c7 44 24 0c 6c 6b 10 	movl   $0xc0106b6c,0xc(%esp)
c0104826:	c0 
c0104827:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c010482e:	c0 
c010482f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104836:	00 
c0104837:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c010483e:	e8 77 c4 ff ff       	call   c0100cba <__panic>
    assert(pa2page(*ptep) == p1);
c0104843:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104846:	8b 00                	mov    (%eax),%eax
c0104848:	89 04 24             	mov    %eax,(%esp)
c010484b:	e8 09 f1 ff ff       	call   c0103959 <pa2page>
c0104850:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104853:	74 24                	je     c0104879 <check_pgdir+0x191>
c0104855:	c7 44 24 0c 99 6b 10 	movl   $0xc0106b99,0xc(%esp)
c010485c:	c0 
c010485d:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104864:	c0 
c0104865:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c010486c:	00 
c010486d:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104874:	e8 41 c4 ff ff       	call   c0100cba <__panic>
    assert(page_ref(p1) == 1);
c0104879:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487c:	89 04 24             	mov    %eax,(%esp)
c010487f:	e8 b6 f1 ff ff       	call   c0103a3a <page_ref>
c0104884:	83 f8 01             	cmp    $0x1,%eax
c0104887:	74 24                	je     c01048ad <check_pgdir+0x1c5>
c0104889:	c7 44 24 0c ae 6b 10 	movl   $0xc0106bae,0xc(%esp)
c0104890:	c0 
c0104891:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104898:	c0 
c0104899:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01048a0:	00 
c01048a1:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01048a8:	e8 0d c4 ff ff       	call   c0100cba <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01048ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048b2:	8b 00                	mov    (%eax),%eax
c01048b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048bf:	c1 e8 0c             	shr    $0xc,%eax
c01048c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01048c5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048ca:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01048cd:	72 23                	jb     c01048f2 <check_pgdir+0x20a>
c01048cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048d6:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c01048dd:	c0 
c01048de:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01048e5:	00 
c01048e6:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01048ed:	e8 c8 c3 ff ff       	call   c0100cba <__panic>
c01048f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048f5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01048fa:	83 c0 04             	add    $0x4,%eax
c01048fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104900:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104905:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010490c:	00 
c010490d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104914:	00 
c0104915:	89 04 24             	mov    %eax,(%esp)
c0104918:	e8 61 fa ff ff       	call   c010437e <get_pte>
c010491d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104920:	74 24                	je     c0104946 <check_pgdir+0x25e>
c0104922:	c7 44 24 0c c0 6b 10 	movl   $0xc0106bc0,0xc(%esp)
c0104929:	c0 
c010492a:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104931:	c0 
c0104932:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104939:	00 
c010493a:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104941:	e8 74 c3 ff ff       	call   c0100cba <__panic>

    p2 = alloc_page();
c0104946:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010494d:	e8 ed f2 ff ff       	call   c0103c3f <alloc_pages>
c0104952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104955:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010495a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104961:	00 
c0104962:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104969:	00 
c010496a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010496d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104971:	89 04 24             	mov    %eax,(%esp)
c0104974:	e8 3b fc ff ff       	call   c01045b4 <page_insert>
c0104979:	85 c0                	test   %eax,%eax
c010497b:	74 24                	je     c01049a1 <check_pgdir+0x2b9>
c010497d:	c7 44 24 0c e8 6b 10 	movl   $0xc0106be8,0xc(%esp)
c0104984:	c0 
c0104985:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c010498c:	c0 
c010498d:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104994:	00 
c0104995:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c010499c:	e8 19 c3 ff ff       	call   c0100cba <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01049a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049ad:	00 
c01049ae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049b5:	00 
c01049b6:	89 04 24             	mov    %eax,(%esp)
c01049b9:	e8 c0 f9 ff ff       	call   c010437e <get_pte>
c01049be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049c5:	75 24                	jne    c01049eb <check_pgdir+0x303>
c01049c7:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c01049ce:	c0 
c01049cf:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c01049d6:	c0 
c01049d7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c01049de:	00 
c01049df:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01049e6:	e8 cf c2 ff ff       	call   c0100cba <__panic>
    assert(*ptep & PTE_U);
c01049eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ee:	8b 00                	mov    (%eax),%eax
c01049f0:	83 e0 04             	and    $0x4,%eax
c01049f3:	85 c0                	test   %eax,%eax
c01049f5:	75 24                	jne    c0104a1b <check_pgdir+0x333>
c01049f7:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c01049fe:	c0 
c01049ff:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104a06:	c0 
c0104a07:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a0e:	00 
c0104a0f:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104a16:	e8 9f c2 ff ff       	call   c0100cba <__panic>
    assert(*ptep & PTE_W);
c0104a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a1e:	8b 00                	mov    (%eax),%eax
c0104a20:	83 e0 02             	and    $0x2,%eax
c0104a23:	85 c0                	test   %eax,%eax
c0104a25:	75 24                	jne    c0104a4b <check_pgdir+0x363>
c0104a27:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104a2e:	c0 
c0104a2f:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104a36:	c0 
c0104a37:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104a3e:	00 
c0104a3f:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104a46:	e8 6f c2 ff ff       	call   c0100cba <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a4b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a50:	8b 00                	mov    (%eax),%eax
c0104a52:	83 e0 04             	and    $0x4,%eax
c0104a55:	85 c0                	test   %eax,%eax
c0104a57:	75 24                	jne    c0104a7d <check_pgdir+0x395>
c0104a59:	c7 44 24 0c 6c 6c 10 	movl   $0xc0106c6c,0xc(%esp)
c0104a60:	c0 
c0104a61:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104a68:	c0 
c0104a69:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104a70:	00 
c0104a71:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104a78:	e8 3d c2 ff ff       	call   c0100cba <__panic>
    assert(page_ref(p2) == 1);
c0104a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a80:	89 04 24             	mov    %eax,(%esp)
c0104a83:	e8 b2 ef ff ff       	call   c0103a3a <page_ref>
c0104a88:	83 f8 01             	cmp    $0x1,%eax
c0104a8b:	74 24                	je     c0104ab1 <check_pgdir+0x3c9>
c0104a8d:	c7 44 24 0c 82 6c 10 	movl   $0xc0106c82,0xc(%esp)
c0104a94:	c0 
c0104a95:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104a9c:	c0 
c0104a9d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104aa4:	00 
c0104aa5:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104aac:	e8 09 c2 ff ff       	call   c0100cba <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104ab1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ab6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104abd:	00 
c0104abe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ac5:	00 
c0104ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104acd:	89 04 24             	mov    %eax,(%esp)
c0104ad0:	e8 df fa ff ff       	call   c01045b4 <page_insert>
c0104ad5:	85 c0                	test   %eax,%eax
c0104ad7:	74 24                	je     c0104afd <check_pgdir+0x415>
c0104ad9:	c7 44 24 0c 94 6c 10 	movl   $0xc0106c94,0xc(%esp)
c0104ae0:	c0 
c0104ae1:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104ae8:	c0 
c0104ae9:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104af0:	00 
c0104af1:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104af8:	e8 bd c1 ff ff       	call   c0100cba <__panic>
    assert(page_ref(p1) == 2);
c0104afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b00:	89 04 24             	mov    %eax,(%esp)
c0104b03:	e8 32 ef ff ff       	call   c0103a3a <page_ref>
c0104b08:	83 f8 02             	cmp    $0x2,%eax
c0104b0b:	74 24                	je     c0104b31 <check_pgdir+0x449>
c0104b0d:	c7 44 24 0c c0 6c 10 	movl   $0xc0106cc0,0xc(%esp)
c0104b14:	c0 
c0104b15:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104b24:	00 
c0104b25:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104b2c:	e8 89 c1 ff ff       	call   c0100cba <__panic>
    assert(page_ref(p2) == 0);
c0104b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b34:	89 04 24             	mov    %eax,(%esp)
c0104b37:	e8 fe ee ff ff       	call   c0103a3a <page_ref>
c0104b3c:	85 c0                	test   %eax,%eax
c0104b3e:	74 24                	je     c0104b64 <check_pgdir+0x47c>
c0104b40:	c7 44 24 0c d2 6c 10 	movl   $0xc0106cd2,0xc(%esp)
c0104b47:	c0 
c0104b48:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104b4f:	c0 
c0104b50:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b57:	00 
c0104b58:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104b5f:	e8 56 c1 ff ff       	call   c0100cba <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b64:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b70:	00 
c0104b71:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b78:	00 
c0104b79:	89 04 24             	mov    %eax,(%esp)
c0104b7c:	e8 fd f7 ff ff       	call   c010437e <get_pte>
c0104b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b88:	75 24                	jne    c0104bae <check_pgdir+0x4c6>
c0104b8a:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104b91:	c0 
c0104b92:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104b99:	c0 
c0104b9a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104ba1:	00 
c0104ba2:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104ba9:	e8 0c c1 ff ff       	call   c0100cba <__panic>
    assert(pa2page(*ptep) == p1);
c0104bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bb1:	8b 00                	mov    (%eax),%eax
c0104bb3:	89 04 24             	mov    %eax,(%esp)
c0104bb6:	e8 9e ed ff ff       	call   c0103959 <pa2page>
c0104bbb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bbe:	74 24                	je     c0104be4 <check_pgdir+0x4fc>
c0104bc0:	c7 44 24 0c 99 6b 10 	movl   $0xc0106b99,0xc(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104bd7:	00 
c0104bd8:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104bdf:	e8 d6 c0 ff ff       	call   c0100cba <__panic>
    assert((*ptep & PTE_U) == 0);
c0104be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104be7:	8b 00                	mov    (%eax),%eax
c0104be9:	83 e0 04             	and    $0x4,%eax
c0104bec:	85 c0                	test   %eax,%eax
c0104bee:	74 24                	je     c0104c14 <check_pgdir+0x52c>
c0104bf0:	c7 44 24 0c e4 6c 10 	movl   $0xc0106ce4,0xc(%esp)
c0104bf7:	c0 
c0104bf8:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104bff:	c0 
c0104c00:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104c07:	00 
c0104c08:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104c0f:	e8 a6 c0 ff ff       	call   c0100cba <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c14:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c20:	00 
c0104c21:	89 04 24             	mov    %eax,(%esp)
c0104c24:	e8 47 f9 ff ff       	call   c0104570 <page_remove>
    assert(page_ref(p1) == 1);
c0104c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c2c:	89 04 24             	mov    %eax,(%esp)
c0104c2f:	e8 06 ee ff ff       	call   c0103a3a <page_ref>
c0104c34:	83 f8 01             	cmp    $0x1,%eax
c0104c37:	74 24                	je     c0104c5d <check_pgdir+0x575>
c0104c39:	c7 44 24 0c ae 6b 10 	movl   $0xc0106bae,0xc(%esp)
c0104c40:	c0 
c0104c41:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104c48:	c0 
c0104c49:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c50:	00 
c0104c51:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104c58:	e8 5d c0 ff ff       	call   c0100cba <__panic>
    assert(page_ref(p2) == 0);
c0104c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c60:	89 04 24             	mov    %eax,(%esp)
c0104c63:	e8 d2 ed ff ff       	call   c0103a3a <page_ref>
c0104c68:	85 c0                	test   %eax,%eax
c0104c6a:	74 24                	je     c0104c90 <check_pgdir+0x5a8>
c0104c6c:	c7 44 24 0c d2 6c 10 	movl   $0xc0106cd2,0xc(%esp)
c0104c73:	c0 
c0104c74:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104c7b:	c0 
c0104c7c:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104c83:	00 
c0104c84:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104c8b:	e8 2a c0 ff ff       	call   c0100cba <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104c90:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c95:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c9c:	00 
c0104c9d:	89 04 24             	mov    %eax,(%esp)
c0104ca0:	e8 cb f8 ff ff       	call   c0104570 <page_remove>
    assert(page_ref(p1) == 0);
c0104ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca8:	89 04 24             	mov    %eax,(%esp)
c0104cab:	e8 8a ed ff ff       	call   c0103a3a <page_ref>
c0104cb0:	85 c0                	test   %eax,%eax
c0104cb2:	74 24                	je     c0104cd8 <check_pgdir+0x5f0>
c0104cb4:	c7 44 24 0c f9 6c 10 	movl   $0xc0106cf9,0xc(%esp)
c0104cbb:	c0 
c0104cbc:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104cc3:	c0 
c0104cc4:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104ccb:	00 
c0104ccc:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104cd3:	e8 e2 bf ff ff       	call   c0100cba <__panic>
    assert(page_ref(p2) == 0);
c0104cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cdb:	89 04 24             	mov    %eax,(%esp)
c0104cde:	e8 57 ed ff ff       	call   c0103a3a <page_ref>
c0104ce3:	85 c0                	test   %eax,%eax
c0104ce5:	74 24                	je     c0104d0b <check_pgdir+0x623>
c0104ce7:	c7 44 24 0c d2 6c 10 	movl   $0xc0106cd2,0xc(%esp)
c0104cee:	c0 
c0104cef:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104cf6:	c0 
c0104cf7:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104cfe:	00 
c0104cff:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104d06:	e8 af bf ff ff       	call   c0100cba <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104d0b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d10:	8b 00                	mov    (%eax),%eax
c0104d12:	89 04 24             	mov    %eax,(%esp)
c0104d15:	e8 3f ec ff ff       	call   c0103959 <pa2page>
c0104d1a:	89 04 24             	mov    %eax,(%esp)
c0104d1d:	e8 18 ed ff ff       	call   c0103a3a <page_ref>
c0104d22:	83 f8 01             	cmp    $0x1,%eax
c0104d25:	74 24                	je     c0104d4b <check_pgdir+0x663>
c0104d27:	c7 44 24 0c 0c 6d 10 	movl   $0xc0106d0c,0xc(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104d36:	c0 
c0104d37:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d3e:	00 
c0104d3f:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104d46:	e8 6f bf ff ff       	call   c0100cba <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104d4b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d50:	8b 00                	mov    (%eax),%eax
c0104d52:	89 04 24             	mov    %eax,(%esp)
c0104d55:	e8 ff eb ff ff       	call   c0103959 <pa2page>
c0104d5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d61:	00 
c0104d62:	89 04 24             	mov    %eax,(%esp)
c0104d65:	e8 0d ef ff ff       	call   c0103c77 <free_pages>
    boot_pgdir[0] = 0;
c0104d6a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104d75:	c7 04 24 32 6d 10 c0 	movl   $0xc0106d32,(%esp)
c0104d7c:	e8 bb b5 ff ff       	call   c010033c <cprintf>
}
c0104d81:	c9                   	leave  
c0104d82:	c3                   	ret    

c0104d83 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104d83:	55                   	push   %ebp
c0104d84:	89 e5                	mov    %esp,%ebp
c0104d86:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d90:	e9 ca 00 00 00       	jmp    c0104e5f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d9e:	c1 e8 0c             	shr    $0xc,%eax
c0104da1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104da4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104da9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104dac:	72 23                	jb     c0104dd1 <check_boot_pgdir+0x4e>
c0104dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104db5:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c0104dbc:	c0 
c0104dbd:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104dc4:	00 
c0104dc5:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104dcc:	e8 e9 be ff ff       	call   c0100cba <__panic>
c0104dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104dd9:	89 c2                	mov    %eax,%edx
c0104ddb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104de0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104de7:	00 
c0104de8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dec:	89 04 24             	mov    %eax,(%esp)
c0104def:	e8 8a f5 ff ff       	call   c010437e <get_pte>
c0104df4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104df7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104dfb:	75 24                	jne    c0104e21 <check_boot_pgdir+0x9e>
c0104dfd:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0104e04:	c0 
c0104e05:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104e0c:	c0 
c0104e0d:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104e14:	00 
c0104e15:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104e1c:	e8 99 be ff ff       	call   c0100cba <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e24:	8b 00                	mov    (%eax),%eax
c0104e26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e2b:	89 c2                	mov    %eax,%edx
c0104e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e30:	39 c2                	cmp    %eax,%edx
c0104e32:	74 24                	je     c0104e58 <check_boot_pgdir+0xd5>
c0104e34:	c7 44 24 0c 89 6d 10 	movl   $0xc0106d89,0xc(%esp)
c0104e3b:	c0 
c0104e3c:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104e43:	c0 
c0104e44:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104e4b:	00 
c0104e4c:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104e53:	e8 62 be ff ff       	call   c0100cba <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e62:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e67:	39 c2                	cmp    %eax,%edx
c0104e69:	0f 82 26 ff ff ff    	jb     c0104d95 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104e6f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e74:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104e79:	8b 00                	mov    (%eax),%eax
c0104e7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e80:	89 c2                	mov    %eax,%edx
c0104e82:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e8a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104e91:	77 23                	ja     c0104eb6 <check_boot_pgdir+0x133>
c0104e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e9a:	c7 44 24 08 20 6a 10 	movl   $0xc0106a20,0x8(%esp)
c0104ea1:	c0 
c0104ea2:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104ea9:	00 
c0104eaa:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104eb1:	e8 04 be ff ff       	call   c0100cba <__panic>
c0104eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eb9:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ebe:	39 c2                	cmp    %eax,%edx
c0104ec0:	74 24                	je     c0104ee6 <check_boot_pgdir+0x163>
c0104ec2:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104ec9:	c0 
c0104eca:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104ed1:	c0 
c0104ed2:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104ed9:	00 
c0104eda:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104ee1:	e8 d4 bd ff ff       	call   c0100cba <__panic>

    assert(boot_pgdir[0] == 0);
c0104ee6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104eeb:	8b 00                	mov    (%eax),%eax
c0104eed:	85 c0                	test   %eax,%eax
c0104eef:	74 24                	je     c0104f15 <check_boot_pgdir+0x192>
c0104ef1:	c7 44 24 0c d4 6d 10 	movl   $0xc0106dd4,0xc(%esp)
c0104ef8:	c0 
c0104ef9:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104f00:	c0 
c0104f01:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104f08:	00 
c0104f09:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104f10:	e8 a5 bd ff ff       	call   c0100cba <__panic>

    struct Page *p;
    p = alloc_page();
c0104f15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f1c:	e8 1e ed ff ff       	call   c0103c3f <alloc_pages>
c0104f21:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104f24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f29:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f30:	00 
c0104f31:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104f38:	00 
c0104f39:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f3c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f40:	89 04 24             	mov    %eax,(%esp)
c0104f43:	e8 6c f6 ff ff       	call   c01045b4 <page_insert>
c0104f48:	85 c0                	test   %eax,%eax
c0104f4a:	74 24                	je     c0104f70 <check_boot_pgdir+0x1ed>
c0104f4c:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c0104f53:	c0 
c0104f54:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104f5b:	c0 
c0104f5c:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104f63:	00 
c0104f64:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104f6b:	e8 4a bd ff ff       	call   c0100cba <__panic>
    assert(page_ref(p) == 1);
c0104f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f73:	89 04 24             	mov    %eax,(%esp)
c0104f76:	e8 bf ea ff ff       	call   c0103a3a <page_ref>
c0104f7b:	83 f8 01             	cmp    $0x1,%eax
c0104f7e:	74 24                	je     c0104fa4 <check_boot_pgdir+0x221>
c0104f80:	c7 44 24 0c 16 6e 10 	movl   $0xc0106e16,0xc(%esp)
c0104f87:	c0 
c0104f88:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104f8f:	c0 
c0104f90:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0104f97:	00 
c0104f98:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104f9f:	e8 16 bd ff ff       	call   c0100cba <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104fa4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fa9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fb0:	00 
c0104fb1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104fb8:	00 
c0104fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fc0:	89 04 24             	mov    %eax,(%esp)
c0104fc3:	e8 ec f5 ff ff       	call   c01045b4 <page_insert>
c0104fc8:	85 c0                	test   %eax,%eax
c0104fca:	74 24                	je     c0104ff0 <check_boot_pgdir+0x26d>
c0104fcc:	c7 44 24 0c 28 6e 10 	movl   $0xc0106e28,0xc(%esp)
c0104fd3:	c0 
c0104fd4:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0104fdb:	c0 
c0104fdc:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0104fe3:	00 
c0104fe4:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0104feb:	e8 ca bc ff ff       	call   c0100cba <__panic>
    assert(page_ref(p) == 2);
c0104ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ff3:	89 04 24             	mov    %eax,(%esp)
c0104ff6:	e8 3f ea ff ff       	call   c0103a3a <page_ref>
c0104ffb:	83 f8 02             	cmp    $0x2,%eax
c0104ffe:	74 24                	je     c0105024 <check_boot_pgdir+0x2a1>
c0105000:	c7 44 24 0c 5f 6e 10 	movl   $0xc0106e5f,0xc(%esp)
c0105007:	c0 
c0105008:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c010500f:	c0 
c0105010:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105017:	00 
c0105018:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c010501f:	e8 96 bc ff ff       	call   c0100cba <__panic>

    const char *str = "ucore: Hello world!!";
c0105024:	c7 45 dc 70 6e 10 c0 	movl   $0xc0106e70,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010502b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010502e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105032:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105039:	e8 1e 0a 00 00       	call   c0105a5c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010503e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105045:	00 
c0105046:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010504d:	e8 83 0a 00 00       	call   c0105ad5 <strcmp>
c0105052:	85 c0                	test   %eax,%eax
c0105054:	74 24                	je     c010507a <check_boot_pgdir+0x2f7>
c0105056:	c7 44 24 0c 88 6e 10 	movl   $0xc0106e88,0xc(%esp)
c010505d:	c0 
c010505e:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c0105065:	c0 
c0105066:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c010506d:	00 
c010506e:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c0105075:	e8 40 bc ff ff       	call   c0100cba <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010507a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010507d:	89 04 24             	mov    %eax,(%esp)
c0105080:	e8 23 e9 ff ff       	call   c01039a8 <page2kva>
c0105085:	05 00 01 00 00       	add    $0x100,%eax
c010508a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010508d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105094:	e8 6b 09 00 00       	call   c0105a04 <strlen>
c0105099:	85 c0                	test   %eax,%eax
c010509b:	74 24                	je     c01050c1 <check_boot_pgdir+0x33e>
c010509d:	c7 44 24 0c c0 6e 10 	movl   $0xc0106ec0,0xc(%esp)
c01050a4:	c0 
c01050a5:	c7 44 24 08 69 6a 10 	movl   $0xc0106a69,0x8(%esp)
c01050ac:	c0 
c01050ad:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01050b4:	00 
c01050b5:	c7 04 24 44 6a 10 c0 	movl   $0xc0106a44,(%esp)
c01050bc:	e8 f9 bb ff ff       	call   c0100cba <__panic>

    free_page(p);
c01050c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050c8:	00 
c01050c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050cc:	89 04 24             	mov    %eax,(%esp)
c01050cf:	e8 a3 eb ff ff       	call   c0103c77 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01050d4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050d9:	8b 00                	mov    (%eax),%eax
c01050db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050e0:	89 04 24             	mov    %eax,(%esp)
c01050e3:	e8 71 e8 ff ff       	call   c0103959 <pa2page>
c01050e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050ef:	00 
c01050f0:	89 04 24             	mov    %eax,(%esp)
c01050f3:	e8 7f eb ff ff       	call   c0103c77 <free_pages>
    boot_pgdir[0] = 0;
c01050f8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105103:	c7 04 24 e4 6e 10 c0 	movl   $0xc0106ee4,(%esp)
c010510a:	e8 2d b2 ff ff       	call   c010033c <cprintf>
}
c010510f:	c9                   	leave  
c0105110:	c3                   	ret    

c0105111 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105111:	55                   	push   %ebp
c0105112:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105114:	8b 45 08             	mov    0x8(%ebp),%eax
c0105117:	83 e0 04             	and    $0x4,%eax
c010511a:	85 c0                	test   %eax,%eax
c010511c:	74 07                	je     c0105125 <perm2str+0x14>
c010511e:	b8 75 00 00 00       	mov    $0x75,%eax
c0105123:	eb 05                	jmp    c010512a <perm2str+0x19>
c0105125:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010512a:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c010512f:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105136:	8b 45 08             	mov    0x8(%ebp),%eax
c0105139:	83 e0 02             	and    $0x2,%eax
c010513c:	85 c0                	test   %eax,%eax
c010513e:	74 07                	je     c0105147 <perm2str+0x36>
c0105140:	b8 77 00 00 00       	mov    $0x77,%eax
c0105145:	eb 05                	jmp    c010514c <perm2str+0x3b>
c0105147:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010514c:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105151:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105158:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c010515d:	5d                   	pop    %ebp
c010515e:	c3                   	ret    

c010515f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010515f:	55                   	push   %ebp
c0105160:	89 e5                	mov    %esp,%ebp
c0105162:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105165:	8b 45 10             	mov    0x10(%ebp),%eax
c0105168:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010516b:	72 0a                	jb     c0105177 <get_pgtable_items+0x18>
        return 0;
c010516d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105172:	e9 9c 00 00 00       	jmp    c0105213 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105177:	eb 04                	jmp    c010517d <get_pgtable_items+0x1e>
        start ++;
c0105179:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010517d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105180:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105183:	73 18                	jae    c010519d <get_pgtable_items+0x3e>
c0105185:	8b 45 10             	mov    0x10(%ebp),%eax
c0105188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010518f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105192:	01 d0                	add    %edx,%eax
c0105194:	8b 00                	mov    (%eax),%eax
c0105196:	83 e0 01             	and    $0x1,%eax
c0105199:	85 c0                	test   %eax,%eax
c010519b:	74 dc                	je     c0105179 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010519d:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051a3:	73 69                	jae    c010520e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01051a5:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01051a9:	74 08                	je     c01051b3 <get_pgtable_items+0x54>
            *left_store = start;
c01051ab:	8b 45 18             	mov    0x18(%ebp),%eax
c01051ae:	8b 55 10             	mov    0x10(%ebp),%edx
c01051b1:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01051b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01051b6:	8d 50 01             	lea    0x1(%eax),%edx
c01051b9:	89 55 10             	mov    %edx,0x10(%ebp)
c01051bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051c3:	8b 45 14             	mov    0x14(%ebp),%eax
c01051c6:	01 d0                	add    %edx,%eax
c01051c8:	8b 00                	mov    (%eax),%eax
c01051ca:	83 e0 07             	and    $0x7,%eax
c01051cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051d0:	eb 04                	jmp    c01051d6 <get_pgtable_items+0x77>
            start ++;
c01051d2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01051d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051dc:	73 1d                	jae    c01051fb <get_pgtable_items+0x9c>
c01051de:	8b 45 10             	mov    0x10(%ebp),%eax
c01051e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051e8:	8b 45 14             	mov    0x14(%ebp),%eax
c01051eb:	01 d0                	add    %edx,%eax
c01051ed:	8b 00                	mov    (%eax),%eax
c01051ef:	83 e0 07             	and    $0x7,%eax
c01051f2:	89 c2                	mov    %eax,%edx
c01051f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051f7:	39 c2                	cmp    %eax,%edx
c01051f9:	74 d7                	je     c01051d2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01051fb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01051ff:	74 08                	je     c0105209 <get_pgtable_items+0xaa>
            *right_store = start;
c0105201:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105204:	8b 55 10             	mov    0x10(%ebp),%edx
c0105207:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105209:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010520c:	eb 05                	jmp    c0105213 <get_pgtable_items+0xb4>
    }
    return 0;
c010520e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105213:	c9                   	leave  
c0105214:	c3                   	ret    

c0105215 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105215:	55                   	push   %ebp
c0105216:	89 e5                	mov    %esp,%ebp
c0105218:	57                   	push   %edi
c0105219:	56                   	push   %esi
c010521a:	53                   	push   %ebx
c010521b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010521e:	c7 04 24 04 6f 10 c0 	movl   $0xc0106f04,(%esp)
c0105225:	e8 12 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c010522a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105231:	e9 fa 00 00 00       	jmp    c0105330 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105239:	89 04 24             	mov    %eax,(%esp)
c010523c:	e8 d0 fe ff ff       	call   c0105111 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105241:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105244:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105247:	29 d1                	sub    %edx,%ecx
c0105249:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010524b:	89 d6                	mov    %edx,%esi
c010524d:	c1 e6 16             	shl    $0x16,%esi
c0105250:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105253:	89 d3                	mov    %edx,%ebx
c0105255:	c1 e3 16             	shl    $0x16,%ebx
c0105258:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010525b:	89 d1                	mov    %edx,%ecx
c010525d:	c1 e1 16             	shl    $0x16,%ecx
c0105260:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105263:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105266:	29 d7                	sub    %edx,%edi
c0105268:	89 fa                	mov    %edi,%edx
c010526a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010526e:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105272:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105276:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010527a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010527e:	c7 04 24 35 6f 10 c0 	movl   $0xc0106f35,(%esp)
c0105285:	e8 b2 b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010528a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010528d:	c1 e0 0a             	shl    $0xa,%eax
c0105290:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105293:	eb 54                	jmp    c01052e9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105298:	89 04 24             	mov    %eax,(%esp)
c010529b:	e8 71 fe ff ff       	call   c0105111 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01052a0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01052a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052a6:	29 d1                	sub    %edx,%ecx
c01052a8:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052aa:	89 d6                	mov    %edx,%esi
c01052ac:	c1 e6 0c             	shl    $0xc,%esi
c01052af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052b2:	89 d3                	mov    %edx,%ebx
c01052b4:	c1 e3 0c             	shl    $0xc,%ebx
c01052b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052ba:	c1 e2 0c             	shl    $0xc,%edx
c01052bd:	89 d1                	mov    %edx,%ecx
c01052bf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01052c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052c5:	29 d7                	sub    %edx,%edi
c01052c7:	89 fa                	mov    %edi,%edx
c01052c9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052cd:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052dd:	c7 04 24 54 6f 10 c0 	movl   $0xc0106f54,(%esp)
c01052e4:	e8 53 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052e9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01052ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052f1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052f4:	89 ce                	mov    %ecx,%esi
c01052f6:	c1 e6 0a             	shl    $0xa,%esi
c01052f9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01052fc:	89 cb                	mov    %ecx,%ebx
c01052fe:	c1 e3 0a             	shl    $0xa,%ebx
c0105301:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105304:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105308:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010530b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010530f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105313:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105317:	89 74 24 04          	mov    %esi,0x4(%esp)
c010531b:	89 1c 24             	mov    %ebx,(%esp)
c010531e:	e8 3c fe ff ff       	call   c010515f <get_pgtable_items>
c0105323:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105326:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010532a:	0f 85 65 ff ff ff    	jne    c0105295 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105330:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105335:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105338:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010533b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010533f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105342:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105346:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010534a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010534e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105355:	00 
c0105356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010535d:	e8 fd fd ff ff       	call   c010515f <get_pgtable_items>
c0105362:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105365:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105369:	0f 85 c7 fe ff ff    	jne    c0105236 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010536f:	c7 04 24 78 6f 10 c0 	movl   $0xc0106f78,(%esp)
c0105376:	e8 c1 af ff ff       	call   c010033c <cprintf>
}
c010537b:	83 c4 4c             	add    $0x4c,%esp
c010537e:	5b                   	pop    %ebx
c010537f:	5e                   	pop    %esi
c0105380:	5f                   	pop    %edi
c0105381:	5d                   	pop    %ebp
c0105382:	c3                   	ret    

c0105383 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105383:	55                   	push   %ebp
c0105384:	89 e5                	mov    %esp,%ebp
c0105386:	83 ec 58             	sub    $0x58,%esp
c0105389:	8b 45 10             	mov    0x10(%ebp),%eax
c010538c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010538f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105392:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105395:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105398:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010539b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010539e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01053a1:	8b 45 18             	mov    0x18(%ebp),%eax
c01053a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053b0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01053b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053bd:	74 1c                	je     c01053db <printnum+0x58>
c01053bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c2:	ba 00 00 00 00       	mov    $0x0,%edx
c01053c7:	f7 75 e4             	divl   -0x1c(%ebp)
c01053ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01053cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d0:	ba 00 00 00 00       	mov    $0x0,%edx
c01053d5:	f7 75 e4             	divl   -0x1c(%ebp)
c01053d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053de:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053e1:	f7 75 e4             	divl   -0x1c(%ebp)
c01053e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01053ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01053f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053f9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01053fc:	8b 45 18             	mov    0x18(%ebp),%eax
c01053ff:	ba 00 00 00 00       	mov    $0x0,%edx
c0105404:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105407:	77 56                	ja     c010545f <printnum+0xdc>
c0105409:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010540c:	72 05                	jb     c0105413 <printnum+0x90>
c010540e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105411:	77 4c                	ja     c010545f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105413:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105416:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105419:	8b 45 20             	mov    0x20(%ebp),%eax
c010541c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105420:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105424:	8b 45 18             	mov    0x18(%ebp),%eax
c0105427:	89 44 24 10          	mov    %eax,0x10(%esp)
c010542b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010542e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105431:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105435:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105439:	8b 45 0c             	mov    0xc(%ebp),%eax
c010543c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105440:	8b 45 08             	mov    0x8(%ebp),%eax
c0105443:	89 04 24             	mov    %eax,(%esp)
c0105446:	e8 38 ff ff ff       	call   c0105383 <printnum>
c010544b:	eb 1c                	jmp    c0105469 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010544d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105450:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105454:	8b 45 20             	mov    0x20(%ebp),%eax
c0105457:	89 04 24             	mov    %eax,(%esp)
c010545a:	8b 45 08             	mov    0x8(%ebp),%eax
c010545d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010545f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105463:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105467:	7f e4                	jg     c010544d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105469:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010546c:	05 2c 70 10 c0       	add    $0xc010702c,%eax
c0105471:	0f b6 00             	movzbl (%eax),%eax
c0105474:	0f be c0             	movsbl %al,%eax
c0105477:	8b 55 0c             	mov    0xc(%ebp),%edx
c010547a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010547e:	89 04 24             	mov    %eax,(%esp)
c0105481:	8b 45 08             	mov    0x8(%ebp),%eax
c0105484:	ff d0                	call   *%eax
}
c0105486:	c9                   	leave  
c0105487:	c3                   	ret    

c0105488 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105488:	55                   	push   %ebp
c0105489:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010548b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010548f:	7e 14                	jle    c01054a5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105491:	8b 45 08             	mov    0x8(%ebp),%eax
c0105494:	8b 00                	mov    (%eax),%eax
c0105496:	8d 48 08             	lea    0x8(%eax),%ecx
c0105499:	8b 55 08             	mov    0x8(%ebp),%edx
c010549c:	89 0a                	mov    %ecx,(%edx)
c010549e:	8b 50 04             	mov    0x4(%eax),%edx
c01054a1:	8b 00                	mov    (%eax),%eax
c01054a3:	eb 30                	jmp    c01054d5 <getuint+0x4d>
    }
    else if (lflag) {
c01054a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054a9:	74 16                	je     c01054c1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01054ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ae:	8b 00                	mov    (%eax),%eax
c01054b0:	8d 48 04             	lea    0x4(%eax),%ecx
c01054b3:	8b 55 08             	mov    0x8(%ebp),%edx
c01054b6:	89 0a                	mov    %ecx,(%edx)
c01054b8:	8b 00                	mov    (%eax),%eax
c01054ba:	ba 00 00 00 00       	mov    $0x0,%edx
c01054bf:	eb 14                	jmp    c01054d5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01054c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c4:	8b 00                	mov    (%eax),%eax
c01054c6:	8d 48 04             	lea    0x4(%eax),%ecx
c01054c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01054cc:	89 0a                	mov    %ecx,(%edx)
c01054ce:	8b 00                	mov    (%eax),%eax
c01054d0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01054d5:	5d                   	pop    %ebp
c01054d6:	c3                   	ret    

c01054d7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01054d7:	55                   	push   %ebp
c01054d8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054de:	7e 14                	jle    c01054f4 <getint+0x1d>
        return va_arg(*ap, long long);
c01054e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e3:	8b 00                	mov    (%eax),%eax
c01054e5:	8d 48 08             	lea    0x8(%eax),%ecx
c01054e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01054eb:	89 0a                	mov    %ecx,(%edx)
c01054ed:	8b 50 04             	mov    0x4(%eax),%edx
c01054f0:	8b 00                	mov    (%eax),%eax
c01054f2:	eb 28                	jmp    c010551c <getint+0x45>
    }
    else if (lflag) {
c01054f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054f8:	74 12                	je     c010550c <getint+0x35>
        return va_arg(*ap, long);
c01054fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fd:	8b 00                	mov    (%eax),%eax
c01054ff:	8d 48 04             	lea    0x4(%eax),%ecx
c0105502:	8b 55 08             	mov    0x8(%ebp),%edx
c0105505:	89 0a                	mov    %ecx,(%edx)
c0105507:	8b 00                	mov    (%eax),%eax
c0105509:	99                   	cltd   
c010550a:	eb 10                	jmp    c010551c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010550c:	8b 45 08             	mov    0x8(%ebp),%eax
c010550f:	8b 00                	mov    (%eax),%eax
c0105511:	8d 48 04             	lea    0x4(%eax),%ecx
c0105514:	8b 55 08             	mov    0x8(%ebp),%edx
c0105517:	89 0a                	mov    %ecx,(%edx)
c0105519:	8b 00                	mov    (%eax),%eax
c010551b:	99                   	cltd   
    }
}
c010551c:	5d                   	pop    %ebp
c010551d:	c3                   	ret    

c010551e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010551e:	55                   	push   %ebp
c010551f:	89 e5                	mov    %esp,%ebp
c0105521:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105524:	8d 45 14             	lea    0x14(%ebp),%eax
c0105527:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010552a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010552d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105531:	8b 45 10             	mov    0x10(%ebp),%eax
c0105534:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010553b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010553f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105542:	89 04 24             	mov    %eax,(%esp)
c0105545:	e8 02 00 00 00       	call   c010554c <vprintfmt>
    va_end(ap);
}
c010554a:	c9                   	leave  
c010554b:	c3                   	ret    

c010554c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010554c:	55                   	push   %ebp
c010554d:	89 e5                	mov    %esp,%ebp
c010554f:	56                   	push   %esi
c0105550:	53                   	push   %ebx
c0105551:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105554:	eb 18                	jmp    c010556e <vprintfmt+0x22>
            if (ch == '\0') {
c0105556:	85 db                	test   %ebx,%ebx
c0105558:	75 05                	jne    c010555f <vprintfmt+0x13>
                return;
c010555a:	e9 d1 03 00 00       	jmp    c0105930 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010555f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105562:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105566:	89 1c 24             	mov    %ebx,(%esp)
c0105569:	8b 45 08             	mov    0x8(%ebp),%eax
c010556c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010556e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105571:	8d 50 01             	lea    0x1(%eax),%edx
c0105574:	89 55 10             	mov    %edx,0x10(%ebp)
c0105577:	0f b6 00             	movzbl (%eax),%eax
c010557a:	0f b6 d8             	movzbl %al,%ebx
c010557d:	83 fb 25             	cmp    $0x25,%ebx
c0105580:	75 d4                	jne    c0105556 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105582:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105586:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010558d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105590:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105593:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010559a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010559d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01055a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01055a3:	8d 50 01             	lea    0x1(%eax),%edx
c01055a6:	89 55 10             	mov    %edx,0x10(%ebp)
c01055a9:	0f b6 00             	movzbl (%eax),%eax
c01055ac:	0f b6 d8             	movzbl %al,%ebx
c01055af:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01055b2:	83 f8 55             	cmp    $0x55,%eax
c01055b5:	0f 87 44 03 00 00    	ja     c01058ff <vprintfmt+0x3b3>
c01055bb:	8b 04 85 50 70 10 c0 	mov    -0x3fef8fb0(,%eax,4),%eax
c01055c2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055c4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01055c8:	eb d6                	jmp    c01055a0 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01055ca:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01055ce:	eb d0                	jmp    c01055a0 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01055d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055da:	89 d0                	mov    %edx,%eax
c01055dc:	c1 e0 02             	shl    $0x2,%eax
c01055df:	01 d0                	add    %edx,%eax
c01055e1:	01 c0                	add    %eax,%eax
c01055e3:	01 d8                	add    %ebx,%eax
c01055e5:	83 e8 30             	sub    $0x30,%eax
c01055e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01055eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ee:	0f b6 00             	movzbl (%eax),%eax
c01055f1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01055f4:	83 fb 2f             	cmp    $0x2f,%ebx
c01055f7:	7e 0b                	jle    c0105604 <vprintfmt+0xb8>
c01055f9:	83 fb 39             	cmp    $0x39,%ebx
c01055fc:	7f 06                	jg     c0105604 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055fe:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105602:	eb d3                	jmp    c01055d7 <vprintfmt+0x8b>
            goto process_precision;
c0105604:	eb 33                	jmp    c0105639 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105606:	8b 45 14             	mov    0x14(%ebp),%eax
c0105609:	8d 50 04             	lea    0x4(%eax),%edx
c010560c:	89 55 14             	mov    %edx,0x14(%ebp)
c010560f:	8b 00                	mov    (%eax),%eax
c0105611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105614:	eb 23                	jmp    c0105639 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105616:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010561a:	79 0c                	jns    c0105628 <vprintfmt+0xdc>
                width = 0;
c010561c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105623:	e9 78 ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>
c0105628:	e9 73 ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010562d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105634:	e9 67 ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105639:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010563d:	79 12                	jns    c0105651 <vprintfmt+0x105>
                width = precision, precision = -1;
c010563f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105642:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105645:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010564c:	e9 4f ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>
c0105651:	e9 4a ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105656:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010565a:	e9 41 ff ff ff       	jmp    c01055a0 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010565f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105662:	8d 50 04             	lea    0x4(%eax),%edx
c0105665:	89 55 14             	mov    %edx,0x14(%ebp)
c0105668:	8b 00                	mov    (%eax),%eax
c010566a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010566d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105671:	89 04 24             	mov    %eax,(%esp)
c0105674:	8b 45 08             	mov    0x8(%ebp),%eax
c0105677:	ff d0                	call   *%eax
            break;
c0105679:	e9 ac 02 00 00       	jmp    c010592a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010567e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105681:	8d 50 04             	lea    0x4(%eax),%edx
c0105684:	89 55 14             	mov    %edx,0x14(%ebp)
c0105687:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105689:	85 db                	test   %ebx,%ebx
c010568b:	79 02                	jns    c010568f <vprintfmt+0x143>
                err = -err;
c010568d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010568f:	83 fb 06             	cmp    $0x6,%ebx
c0105692:	7f 0b                	jg     c010569f <vprintfmt+0x153>
c0105694:	8b 34 9d 10 70 10 c0 	mov    -0x3fef8ff0(,%ebx,4),%esi
c010569b:	85 f6                	test   %esi,%esi
c010569d:	75 23                	jne    c01056c2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010569f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01056a3:	c7 44 24 08 3d 70 10 	movl   $0xc010703d,0x8(%esp)
c01056aa:	c0 
c01056ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b5:	89 04 24             	mov    %eax,(%esp)
c01056b8:	e8 61 fe ff ff       	call   c010551e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056bd:	e9 68 02 00 00       	jmp    c010592a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01056c2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01056c6:	c7 44 24 08 46 70 10 	movl   $0xc0107046,0x8(%esp)
c01056cd:	c0 
c01056ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d8:	89 04 24             	mov    %eax,(%esp)
c01056db:	e8 3e fe ff ff       	call   c010551e <printfmt>
            }
            break;
c01056e0:	e9 45 02 00 00       	jmp    c010592a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01056e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e8:	8d 50 04             	lea    0x4(%eax),%edx
c01056eb:	89 55 14             	mov    %edx,0x14(%ebp)
c01056ee:	8b 30                	mov    (%eax),%esi
c01056f0:	85 f6                	test   %esi,%esi
c01056f2:	75 05                	jne    c01056f9 <vprintfmt+0x1ad>
                p = "(null)";
c01056f4:	be 49 70 10 c0       	mov    $0xc0107049,%esi
            }
            if (width > 0 && padc != '-') {
c01056f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056fd:	7e 3e                	jle    c010573d <vprintfmt+0x1f1>
c01056ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105703:	74 38                	je     c010573d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105705:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010570b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010570f:	89 34 24             	mov    %esi,(%esp)
c0105712:	e8 15 03 00 00       	call   c0105a2c <strnlen>
c0105717:	29 c3                	sub    %eax,%ebx
c0105719:	89 d8                	mov    %ebx,%eax
c010571b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010571e:	eb 17                	jmp    c0105737 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105720:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105724:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105727:	89 54 24 04          	mov    %edx,0x4(%esp)
c010572b:	89 04 24             	mov    %eax,(%esp)
c010572e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105731:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105733:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105737:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010573b:	7f e3                	jg     c0105720 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010573d:	eb 38                	jmp    c0105777 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010573f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105743:	74 1f                	je     c0105764 <vprintfmt+0x218>
c0105745:	83 fb 1f             	cmp    $0x1f,%ebx
c0105748:	7e 05                	jle    c010574f <vprintfmt+0x203>
c010574a:	83 fb 7e             	cmp    $0x7e,%ebx
c010574d:	7e 15                	jle    c0105764 <vprintfmt+0x218>
                    putch('?', putdat);
c010574f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105752:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105756:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010575d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105760:	ff d0                	call   *%eax
c0105762:	eb 0f                	jmp    c0105773 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105764:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105767:	89 44 24 04          	mov    %eax,0x4(%esp)
c010576b:	89 1c 24             	mov    %ebx,(%esp)
c010576e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105771:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105773:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105777:	89 f0                	mov    %esi,%eax
c0105779:	8d 70 01             	lea    0x1(%eax),%esi
c010577c:	0f b6 00             	movzbl (%eax),%eax
c010577f:	0f be d8             	movsbl %al,%ebx
c0105782:	85 db                	test   %ebx,%ebx
c0105784:	74 10                	je     c0105796 <vprintfmt+0x24a>
c0105786:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010578a:	78 b3                	js     c010573f <vprintfmt+0x1f3>
c010578c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105790:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105794:	79 a9                	jns    c010573f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105796:	eb 17                	jmp    c01057af <vprintfmt+0x263>
                putch(' ', putdat);
c0105798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010579b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010579f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01057a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a9:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057ab:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057b3:	7f e3                	jg     c0105798 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01057b5:	e9 70 01 00 00       	jmp    c010592a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01057c4:	89 04 24             	mov    %eax,(%esp)
c01057c7:	e8 0b fd ff ff       	call   c01054d7 <getint>
c01057cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01057d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057d8:	85 d2                	test   %edx,%edx
c01057da:	79 26                	jns    c0105802 <vprintfmt+0x2b6>
                putch('-', putdat);
c01057dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01057ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ed:	ff d0                	call   *%eax
                num = -(long long)num;
c01057ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057f5:	f7 d8                	neg    %eax
c01057f7:	83 d2 00             	adc    $0x0,%edx
c01057fa:	f7 da                	neg    %edx
c01057fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105802:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105809:	e9 a8 00 00 00       	jmp    c01058b6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010580e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105811:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105815:	8d 45 14             	lea    0x14(%ebp),%eax
c0105818:	89 04 24             	mov    %eax,(%esp)
c010581b:	e8 68 fc ff ff       	call   c0105488 <getuint>
c0105820:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105823:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105826:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010582d:	e9 84 00 00 00       	jmp    c01058b6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105832:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105835:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105839:	8d 45 14             	lea    0x14(%ebp),%eax
c010583c:	89 04 24             	mov    %eax,(%esp)
c010583f:	e8 44 fc ff ff       	call   c0105488 <getuint>
c0105844:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105847:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010584a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105851:	eb 63                	jmp    c01058b6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105853:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105856:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105861:	8b 45 08             	mov    0x8(%ebp),%eax
c0105864:	ff d0                	call   *%eax
            putch('x', putdat);
c0105866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105869:	89 44 24 04          	mov    %eax,0x4(%esp)
c010586d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105879:	8b 45 14             	mov    0x14(%ebp),%eax
c010587c:	8d 50 04             	lea    0x4(%eax),%edx
c010587f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105882:	8b 00                	mov    (%eax),%eax
c0105884:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010588e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105895:	eb 1f                	jmp    c01058b6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105897:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010589a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589e:	8d 45 14             	lea    0x14(%ebp),%eax
c01058a1:	89 04 24             	mov    %eax,(%esp)
c01058a4:	e8 df fb ff ff       	call   c0105488 <getuint>
c01058a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01058af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058b6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058bd:	89 54 24 18          	mov    %edx,0x18(%esp)
c01058c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058c4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01058c8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01058cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01058da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e4:	89 04 24             	mov    %eax,(%esp)
c01058e7:	e8 97 fa ff ff       	call   c0105383 <printnum>
            break;
c01058ec:	eb 3c                	jmp    c010592a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f5:	89 1c 24             	mov    %ebx,(%esp)
c01058f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fb:	ff d0                	call   *%eax
            break;
c01058fd:	eb 2b                	jmp    c010592a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01058ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105902:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105906:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010590d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105910:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105912:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105916:	eb 04                	jmp    c010591c <vprintfmt+0x3d0>
c0105918:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010591c:	8b 45 10             	mov    0x10(%ebp),%eax
c010591f:	83 e8 01             	sub    $0x1,%eax
c0105922:	0f b6 00             	movzbl (%eax),%eax
c0105925:	3c 25                	cmp    $0x25,%al
c0105927:	75 ef                	jne    c0105918 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105929:	90                   	nop
        }
    }
c010592a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010592b:	e9 3e fc ff ff       	jmp    c010556e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105930:	83 c4 40             	add    $0x40,%esp
c0105933:	5b                   	pop    %ebx
c0105934:	5e                   	pop    %esi
c0105935:	5d                   	pop    %ebp
c0105936:	c3                   	ret    

c0105937 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105937:	55                   	push   %ebp
c0105938:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010593a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593d:	8b 40 08             	mov    0x8(%eax),%eax
c0105940:	8d 50 01             	lea    0x1(%eax),%edx
c0105943:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105946:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105949:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594c:	8b 10                	mov    (%eax),%edx
c010594e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105951:	8b 40 04             	mov    0x4(%eax),%eax
c0105954:	39 c2                	cmp    %eax,%edx
c0105956:	73 12                	jae    c010596a <sprintputch+0x33>
        *b->buf ++ = ch;
c0105958:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595b:	8b 00                	mov    (%eax),%eax
c010595d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105960:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105963:	89 0a                	mov    %ecx,(%edx)
c0105965:	8b 55 08             	mov    0x8(%ebp),%edx
c0105968:	88 10                	mov    %dl,(%eax)
    }
}
c010596a:	5d                   	pop    %ebp
c010596b:	c3                   	ret    

c010596c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010596c:	55                   	push   %ebp
c010596d:	89 e5                	mov    %esp,%ebp
c010596f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105972:	8d 45 14             	lea    0x14(%ebp),%eax
c0105975:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105978:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010597b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010597f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105982:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105986:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105989:	89 44 24 04          	mov    %eax,0x4(%esp)
c010598d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105990:	89 04 24             	mov    %eax,(%esp)
c0105993:	e8 08 00 00 00       	call   c01059a0 <vsnprintf>
c0105998:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010599e:	c9                   	leave  
c010599f:	c3                   	ret    

c01059a0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01059a0:	55                   	push   %ebp
c01059a1:	89 e5                	mov    %esp,%ebp
c01059a3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01059a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059af:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b5:	01 d0                	add    %edx,%eax
c01059b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059c5:	74 0a                	je     c01059d1 <vsnprintf+0x31>
c01059c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01059ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059cd:	39 c2                	cmp    %eax,%edx
c01059cf:	76 07                	jbe    c01059d8 <vsnprintf+0x38>
        return -E_INVAL;
c01059d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01059d6:	eb 2a                	jmp    c0105a02 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01059d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01059db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059df:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01059e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ed:	c7 04 24 37 59 10 c0 	movl   $0xc0105937,(%esp)
c01059f4:	e8 53 fb ff ff       	call   c010554c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01059f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059fc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01059ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a02:	c9                   	leave  
c0105a03:	c3                   	ret    

c0105a04 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a04:	55                   	push   %ebp
c0105a05:	89 e5                	mov    %esp,%ebp
c0105a07:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a11:	eb 04                	jmp    c0105a17 <strlen+0x13>
        cnt ++;
c0105a13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1a:	8d 50 01             	lea    0x1(%eax),%edx
c0105a1d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a20:	0f b6 00             	movzbl (%eax),%eax
c0105a23:	84 c0                	test   %al,%al
c0105a25:	75 ec                	jne    c0105a13 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a2a:	c9                   	leave  
c0105a2b:	c3                   	ret    

c0105a2c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a2c:	55                   	push   %ebp
c0105a2d:	89 e5                	mov    %esp,%ebp
c0105a2f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a39:	eb 04                	jmp    c0105a3f <strnlen+0x13>
        cnt ++;
c0105a3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a42:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a45:	73 10                	jae    c0105a57 <strnlen+0x2b>
c0105a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4a:	8d 50 01             	lea    0x1(%eax),%edx
c0105a4d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a50:	0f b6 00             	movzbl (%eax),%eax
c0105a53:	84 c0                	test   %al,%al
c0105a55:	75 e4                	jne    c0105a3b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a5a:	c9                   	leave  
c0105a5b:	c3                   	ret    

c0105a5c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a5c:	55                   	push   %ebp
c0105a5d:	89 e5                	mov    %esp,%ebp
c0105a5f:	57                   	push   %edi
c0105a60:	56                   	push   %esi
c0105a61:	83 ec 20             	sub    $0x20,%esp
c0105a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a70:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a76:	89 d1                	mov    %edx,%ecx
c0105a78:	89 c2                	mov    %eax,%edx
c0105a7a:	89 ce                	mov    %ecx,%esi
c0105a7c:	89 d7                	mov    %edx,%edi
c0105a7e:	ac                   	lods   %ds:(%esi),%al
c0105a7f:	aa                   	stos   %al,%es:(%edi)
c0105a80:	84 c0                	test   %al,%al
c0105a82:	75 fa                	jne    c0105a7e <strcpy+0x22>
c0105a84:	89 fa                	mov    %edi,%edx
c0105a86:	89 f1                	mov    %esi,%ecx
c0105a88:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a8b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a94:	83 c4 20             	add    $0x20,%esp
c0105a97:	5e                   	pop    %esi
c0105a98:	5f                   	pop    %edi
c0105a99:	5d                   	pop    %ebp
c0105a9a:	c3                   	ret    

c0105a9b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a9b:	55                   	push   %ebp
c0105a9c:	89 e5                	mov    %esp,%ebp
c0105a9e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105aa7:	eb 21                	jmp    c0105aca <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aac:	0f b6 10             	movzbl (%eax),%edx
c0105aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ab2:	88 10                	mov    %dl,(%eax)
c0105ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ab7:	0f b6 00             	movzbl (%eax),%eax
c0105aba:	84 c0                	test   %al,%al
c0105abc:	74 04                	je     c0105ac2 <strncpy+0x27>
            src ++;
c0105abe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105ac2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ac6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105aca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ace:	75 d9                	jne    c0105aa9 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105ad0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ad3:	c9                   	leave  
c0105ad4:	c3                   	ret    

c0105ad5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105ad5:	55                   	push   %ebp
c0105ad6:	89 e5                	mov    %esp,%ebp
c0105ad8:	57                   	push   %edi
c0105ad9:	56                   	push   %esi
c0105ada:	83 ec 20             	sub    $0x20,%esp
c0105add:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aef:	89 d1                	mov    %edx,%ecx
c0105af1:	89 c2                	mov    %eax,%edx
c0105af3:	89 ce                	mov    %ecx,%esi
c0105af5:	89 d7                	mov    %edx,%edi
c0105af7:	ac                   	lods   %ds:(%esi),%al
c0105af8:	ae                   	scas   %es:(%edi),%al
c0105af9:	75 08                	jne    c0105b03 <strcmp+0x2e>
c0105afb:	84 c0                	test   %al,%al
c0105afd:	75 f8                	jne    c0105af7 <strcmp+0x22>
c0105aff:	31 c0                	xor    %eax,%eax
c0105b01:	eb 04                	jmp    c0105b07 <strcmp+0x32>
c0105b03:	19 c0                	sbb    %eax,%eax
c0105b05:	0c 01                	or     $0x1,%al
c0105b07:	89 fa                	mov    %edi,%edx
c0105b09:	89 f1                	mov    %esi,%ecx
c0105b0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b0e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b17:	83 c4 20             	add    $0x20,%esp
c0105b1a:	5e                   	pop    %esi
c0105b1b:	5f                   	pop    %edi
c0105b1c:	5d                   	pop    %ebp
c0105b1d:	c3                   	ret    

c0105b1e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b1e:	55                   	push   %ebp
c0105b1f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b21:	eb 0c                	jmp    c0105b2f <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105b23:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b27:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b2b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b33:	74 1a                	je     c0105b4f <strncmp+0x31>
c0105b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b38:	0f b6 00             	movzbl (%eax),%eax
c0105b3b:	84 c0                	test   %al,%al
c0105b3d:	74 10                	je     c0105b4f <strncmp+0x31>
c0105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b42:	0f b6 10             	movzbl (%eax),%edx
c0105b45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b48:	0f b6 00             	movzbl (%eax),%eax
c0105b4b:	38 c2                	cmp    %al,%dl
c0105b4d:	74 d4                	je     c0105b23 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b53:	74 18                	je     c0105b6d <strncmp+0x4f>
c0105b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b58:	0f b6 00             	movzbl (%eax),%eax
c0105b5b:	0f b6 d0             	movzbl %al,%edx
c0105b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b61:	0f b6 00             	movzbl (%eax),%eax
c0105b64:	0f b6 c0             	movzbl %al,%eax
c0105b67:	29 c2                	sub    %eax,%edx
c0105b69:	89 d0                	mov    %edx,%eax
c0105b6b:	eb 05                	jmp    c0105b72 <strncmp+0x54>
c0105b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b72:	5d                   	pop    %ebp
c0105b73:	c3                   	ret    

c0105b74 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b74:	55                   	push   %ebp
c0105b75:	89 e5                	mov    %esp,%ebp
c0105b77:	83 ec 04             	sub    $0x4,%esp
c0105b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b80:	eb 14                	jmp    c0105b96 <strchr+0x22>
        if (*s == c) {
c0105b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b85:	0f b6 00             	movzbl (%eax),%eax
c0105b88:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b8b:	75 05                	jne    c0105b92 <strchr+0x1e>
            return (char *)s;
c0105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b90:	eb 13                	jmp    c0105ba5 <strchr+0x31>
        }
        s ++;
c0105b92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b99:	0f b6 00             	movzbl (%eax),%eax
c0105b9c:	84 c0                	test   %al,%al
c0105b9e:	75 e2                	jne    c0105b82 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ba5:	c9                   	leave  
c0105ba6:	c3                   	ret    

c0105ba7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105ba7:	55                   	push   %ebp
c0105ba8:	89 e5                	mov    %esp,%ebp
c0105baa:	83 ec 04             	sub    $0x4,%esp
c0105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bb3:	eb 11                	jmp    c0105bc6 <strfind+0x1f>
        if (*s == c) {
c0105bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb8:	0f b6 00             	movzbl (%eax),%eax
c0105bbb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105bbe:	75 02                	jne    c0105bc2 <strfind+0x1b>
            break;
c0105bc0:	eb 0e                	jmp    c0105bd0 <strfind+0x29>
        }
        s ++;
c0105bc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc9:	0f b6 00             	movzbl (%eax),%eax
c0105bcc:	84 c0                	test   %al,%al
c0105bce:	75 e5                	jne    c0105bb5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bd3:	c9                   	leave  
c0105bd4:	c3                   	ret    

c0105bd5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105bd5:	55                   	push   %ebp
c0105bd6:	89 e5                	mov    %esp,%ebp
c0105bd8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105bdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105be2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105be9:	eb 04                	jmp    c0105bef <strtol+0x1a>
        s ++;
c0105beb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf2:	0f b6 00             	movzbl (%eax),%eax
c0105bf5:	3c 20                	cmp    $0x20,%al
c0105bf7:	74 f2                	je     c0105beb <strtol+0x16>
c0105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfc:	0f b6 00             	movzbl (%eax),%eax
c0105bff:	3c 09                	cmp    $0x9,%al
c0105c01:	74 e8                	je     c0105beb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c06:	0f b6 00             	movzbl (%eax),%eax
c0105c09:	3c 2b                	cmp    $0x2b,%al
c0105c0b:	75 06                	jne    c0105c13 <strtol+0x3e>
        s ++;
c0105c0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c11:	eb 15                	jmp    c0105c28 <strtol+0x53>
    }
    else if (*s == '-') {
c0105c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c16:	0f b6 00             	movzbl (%eax),%eax
c0105c19:	3c 2d                	cmp    $0x2d,%al
c0105c1b:	75 0b                	jne    c0105c28 <strtol+0x53>
        s ++, neg = 1;
c0105c1d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c21:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c2c:	74 06                	je     c0105c34 <strtol+0x5f>
c0105c2e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c32:	75 24                	jne    c0105c58 <strtol+0x83>
c0105c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c37:	0f b6 00             	movzbl (%eax),%eax
c0105c3a:	3c 30                	cmp    $0x30,%al
c0105c3c:	75 1a                	jne    c0105c58 <strtol+0x83>
c0105c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c41:	83 c0 01             	add    $0x1,%eax
c0105c44:	0f b6 00             	movzbl (%eax),%eax
c0105c47:	3c 78                	cmp    $0x78,%al
c0105c49:	75 0d                	jne    c0105c58 <strtol+0x83>
        s += 2, base = 16;
c0105c4b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c4f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c56:	eb 2a                	jmp    c0105c82 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105c58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c5c:	75 17                	jne    c0105c75 <strtol+0xa0>
c0105c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c61:	0f b6 00             	movzbl (%eax),%eax
c0105c64:	3c 30                	cmp    $0x30,%al
c0105c66:	75 0d                	jne    c0105c75 <strtol+0xa0>
        s ++, base = 8;
c0105c68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c73:	eb 0d                	jmp    c0105c82 <strtol+0xad>
    }
    else if (base == 0) {
c0105c75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c79:	75 07                	jne    c0105c82 <strtol+0xad>
        base = 10;
c0105c7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c85:	0f b6 00             	movzbl (%eax),%eax
c0105c88:	3c 2f                	cmp    $0x2f,%al
c0105c8a:	7e 1b                	jle    c0105ca7 <strtol+0xd2>
c0105c8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8f:	0f b6 00             	movzbl (%eax),%eax
c0105c92:	3c 39                	cmp    $0x39,%al
c0105c94:	7f 11                	jg     c0105ca7 <strtol+0xd2>
            dig = *s - '0';
c0105c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c99:	0f b6 00             	movzbl (%eax),%eax
c0105c9c:	0f be c0             	movsbl %al,%eax
c0105c9f:	83 e8 30             	sub    $0x30,%eax
c0105ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ca5:	eb 48                	jmp    c0105cef <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ca7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105caa:	0f b6 00             	movzbl (%eax),%eax
c0105cad:	3c 60                	cmp    $0x60,%al
c0105caf:	7e 1b                	jle    c0105ccc <strtol+0xf7>
c0105cb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb4:	0f b6 00             	movzbl (%eax),%eax
c0105cb7:	3c 7a                	cmp    $0x7a,%al
c0105cb9:	7f 11                	jg     c0105ccc <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbe:	0f b6 00             	movzbl (%eax),%eax
c0105cc1:	0f be c0             	movsbl %al,%eax
c0105cc4:	83 e8 57             	sub    $0x57,%eax
c0105cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cca:	eb 23                	jmp    c0105cef <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccf:	0f b6 00             	movzbl (%eax),%eax
c0105cd2:	3c 40                	cmp    $0x40,%al
c0105cd4:	7e 3d                	jle    c0105d13 <strtol+0x13e>
c0105cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd9:	0f b6 00             	movzbl (%eax),%eax
c0105cdc:	3c 5a                	cmp    $0x5a,%al
c0105cde:	7f 33                	jg     c0105d13 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce3:	0f b6 00             	movzbl (%eax),%eax
c0105ce6:	0f be c0             	movsbl %al,%eax
c0105ce9:	83 e8 37             	sub    $0x37,%eax
c0105cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cf5:	7c 02                	jl     c0105cf9 <strtol+0x124>
            break;
c0105cf7:	eb 1a                	jmp    c0105d13 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105cf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d00:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d04:	89 c2                	mov    %eax,%edx
c0105d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d09:	01 d0                	add    %edx,%eax
c0105d0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105d0e:	e9 6f ff ff ff       	jmp    c0105c82 <strtol+0xad>

    if (endptr) {
c0105d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d17:	74 08                	je     c0105d21 <strtol+0x14c>
        *endptr = (char *) s;
c0105d19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d1f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d25:	74 07                	je     c0105d2e <strtol+0x159>
c0105d27:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d2a:	f7 d8                	neg    %eax
c0105d2c:	eb 03                	jmp    c0105d31 <strtol+0x15c>
c0105d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d31:	c9                   	leave  
c0105d32:	c3                   	ret    

c0105d33 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d33:	55                   	push   %ebp
c0105d34:	89 e5                	mov    %esp,%ebp
c0105d36:	57                   	push   %edi
c0105d37:	83 ec 24             	sub    $0x24,%esp
c0105d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d3d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d40:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105d44:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d47:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105d4a:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d53:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d56:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d5d:	89 d7                	mov    %edx,%edi
c0105d5f:	f3 aa                	rep stos %al,%es:(%edi)
c0105d61:	89 fa                	mov    %edi,%edx
c0105d63:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d66:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d6c:	83 c4 24             	add    $0x24,%esp
c0105d6f:	5f                   	pop    %edi
c0105d70:	5d                   	pop    %ebp
c0105d71:	c3                   	ret    

c0105d72 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d72:	55                   	push   %ebp
c0105d73:	89 e5                	mov    %esp,%ebp
c0105d75:	57                   	push   %edi
c0105d76:	56                   	push   %esi
c0105d77:	53                   	push   %ebx
c0105d78:	83 ec 30             	sub    $0x30,%esp
c0105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d87:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d8a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d93:	73 42                	jae    c0105dd7 <memmove+0x65>
c0105d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105da4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105daa:	c1 e8 02             	shr    $0x2,%eax
c0105dad:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105db5:	89 d7                	mov    %edx,%edi
c0105db7:	89 c6                	mov    %eax,%esi
c0105db9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dbb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105dbe:	83 e1 03             	and    $0x3,%ecx
c0105dc1:	74 02                	je     c0105dc5 <memmove+0x53>
c0105dc3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dc5:	89 f0                	mov    %esi,%eax
c0105dc7:	89 fa                	mov    %edi,%edx
c0105dc9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105dcc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dd5:	eb 36                	jmp    c0105e0d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dda:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105de0:	01 c2                	add    %eax,%edx
c0105de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105de5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105deb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105df1:	89 c1                	mov    %eax,%ecx
c0105df3:	89 d8                	mov    %ebx,%eax
c0105df5:	89 d6                	mov    %edx,%esi
c0105df7:	89 c7                	mov    %eax,%edi
c0105df9:	fd                   	std    
c0105dfa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dfc:	fc                   	cld    
c0105dfd:	89 f8                	mov    %edi,%eax
c0105dff:	89 f2                	mov    %esi,%edx
c0105e01:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e04:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e07:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e0d:	83 c4 30             	add    $0x30,%esp
c0105e10:	5b                   	pop    %ebx
c0105e11:	5e                   	pop    %esi
c0105e12:	5f                   	pop    %edi
c0105e13:	5d                   	pop    %ebp
c0105e14:	c3                   	ret    

c0105e15 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e15:	55                   	push   %ebp
c0105e16:	89 e5                	mov    %esp,%ebp
c0105e18:	57                   	push   %edi
c0105e19:	56                   	push   %esi
c0105e1a:	83 ec 20             	sub    $0x20,%esp
c0105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e29:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e32:	c1 e8 02             	shr    $0x2,%eax
c0105e35:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e3d:	89 d7                	mov    %edx,%edi
c0105e3f:	89 c6                	mov    %eax,%esi
c0105e41:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e43:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e46:	83 e1 03             	and    $0x3,%ecx
c0105e49:	74 02                	je     c0105e4d <memcpy+0x38>
c0105e4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e4d:	89 f0                	mov    %esi,%eax
c0105e4f:	89 fa                	mov    %edi,%edx
c0105e51:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e54:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e57:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e5d:	83 c4 20             	add    $0x20,%esp
c0105e60:	5e                   	pop    %esi
c0105e61:	5f                   	pop    %edi
c0105e62:	5d                   	pop    %ebp
c0105e63:	c3                   	ret    

c0105e64 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e64:	55                   	push   %ebp
c0105e65:	89 e5                	mov    %esp,%ebp
c0105e67:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e73:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e76:	eb 30                	jmp    c0105ea8 <memcmp+0x44>
        if (*s1 != *s2) {
c0105e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e7b:	0f b6 10             	movzbl (%eax),%edx
c0105e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e81:	0f b6 00             	movzbl (%eax),%eax
c0105e84:	38 c2                	cmp    %al,%dl
c0105e86:	74 18                	je     c0105ea0 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e8b:	0f b6 00             	movzbl (%eax),%eax
c0105e8e:	0f b6 d0             	movzbl %al,%edx
c0105e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e94:	0f b6 00             	movzbl (%eax),%eax
c0105e97:	0f b6 c0             	movzbl %al,%eax
c0105e9a:	29 c2                	sub    %eax,%edx
c0105e9c:	89 d0                	mov    %edx,%eax
c0105e9e:	eb 1a                	jmp    c0105eba <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105ea0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ea4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105ea8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eab:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eae:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eb1:	85 c0                	test   %eax,%eax
c0105eb3:	75 c3                	jne    c0105e78 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105eba:	c9                   	leave  
c0105ebb:	c3                   	ret    
