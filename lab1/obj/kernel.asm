
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 af 32 00 00       	call   1032db <memset>

    cons_init();                // init the console
  10002c:	e8 28 15 00 00       	call   101559 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 34 10 00 	movl   $0x103480,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 34 10 00 	movl   $0x10349c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 c7 28 00 00       	call   102921 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3d 16 00 00       	call   10169c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 8f 17 00 00       	call   1017f3 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 e3 0c 00 00       	call   100d4c <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 9c 15 00 00       	call   10160a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 ec 0b 00 00       	call   100c7e <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 a1 34 10 00 	movl   $0x1034a1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 af 34 10 00 	movl   $0x1034af,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 bd 34 10 00 	movl   $0x1034bd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 d9 34 10 00 	movl   $0x1034d9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 b5 12 00 00       	call   101585 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 e7 27 00 00       	call   102af4 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 3c 12 00 00       	call   101585 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 09 12 00 00       	call   1015ae <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 2c 35 10 00    	movl   $0x10352c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 2c 35 10 00 	movl   $0x10352c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 8c 3d 10 00 	movl   $0x103d8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 78 b4 10 00 	movl   $0x10b478,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 79 b4 10 00 	movl   $0x10b479,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 51 d4 10 00 	movl   $0x10d451,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 8d 2a 00 00       	call   10314f <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 36 35 10 00 	movl   $0x103536,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 64 34 10 	movl   $0x103464,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 7f 35 10 00 	movl   $0x10357f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 97 35 10 00 	movl   $0x103597,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 b0 35 10 00 	movl   $0x1035b0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 da 35 10 00 	movl   $0x1035da,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 f6 35 10 00 	movl   $0x1035f6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  10099b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 82 00 00 00       	jmp    100a37 <print_stackframe+0xa7>
	  cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>
	  for(j=0;j<4;j++){
  1009cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009d6:	eb 28                	jmp    100a00 <print_stackframe+0x70>
		cprintf("0x%08x ",((uint32_t *)ebp)[j]+2);
  1009d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e5:	01 d0                	add    %edx,%eax
  1009e7:	8b 00                	mov    (%eax),%eax
  1009e9:	83 c0 02             	add    $0x2,%eax
  1009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f0:	c7 04 24 24 36 10 00 	movl   $0x103624,(%esp)
  1009f7:	e8 16 f9 ff ff       	call   100312 <cprintf>
	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
	  cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
	  for(j=0;j<4;j++){
  1009fc:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a00:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a04:	7e d2                	jle    1009d8 <print_stackframe+0x48>
		cprintf("0x%08x ",((uint32_t *)ebp)[j]+2);
	  }
	  cprintf("\n");
  100a06:	c7 04 24 2c 36 10 00 	movl   $0x10362c,(%esp)
  100a0d:	e8 00 f9 ff ff       	call   100312 <cprintf>
	  print_debuginfo(eip-1);
  100a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a15:	83 e8 01             	sub    $0x1,%eax
  100a18:	89 04 24             	mov    %eax,(%esp)
  100a1b:	e8 bc fe ff ff       	call   1008dc <print_debuginfo>
	  eip=((uint32_t *)ebp)[1];
  100a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a23:	83 c0 04             	add    $0x4,%eax
  100a26:	8b 00                	mov    (%eax),%eax
  100a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  ebp=((uint32_t *)ebp)[0];
  100a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2e:	8b 00                	mov    (%eax),%eax
  100a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i,j;
	for(i=0;i<STACKFRAME_DEPTH;i++){
  100a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a37:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a3b:	0f 8e 74 ff ff ff    	jle    1009b5 <print_stackframe+0x25>

	}



}
  100a41:	c9                   	leave  
  100a42:	c3                   	ret    

00100a43 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a43:	55                   	push   %ebp
  100a44:	89 e5                	mov    %esp,%ebp
  100a46:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a50:	eb 0c                	jmp    100a5e <parse+0x1b>
            *buf ++ = '\0';
  100a52:	8b 45 08             	mov    0x8(%ebp),%eax
  100a55:	8d 50 01             	lea    0x1(%eax),%edx
  100a58:	89 55 08             	mov    %edx,0x8(%ebp)
  100a5b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a61:	0f b6 00             	movzbl (%eax),%eax
  100a64:	84 c0                	test   %al,%al
  100a66:	74 1d                	je     100a85 <parse+0x42>
  100a68:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6b:	0f b6 00             	movzbl (%eax),%eax
  100a6e:	0f be c0             	movsbl %al,%eax
  100a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a75:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100a7c:	e8 9b 26 00 00       	call   10311c <strchr>
  100a81:	85 c0                	test   %eax,%eax
  100a83:	75 cd                	jne    100a52 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a85:	8b 45 08             	mov    0x8(%ebp),%eax
  100a88:	0f b6 00             	movzbl (%eax),%eax
  100a8b:	84 c0                	test   %al,%al
  100a8d:	75 02                	jne    100a91 <parse+0x4e>
            break;
  100a8f:	eb 67                	jmp    100af8 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a91:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a95:	75 14                	jne    100aab <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a97:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a9e:	00 
  100a9f:	c7 04 24 b5 36 10 00 	movl   $0x1036b5,(%esp)
  100aa6:	e8 67 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aae:	8d 50 01             	lea    0x1(%eax),%edx
  100ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ab4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100abe:	01 c2                	add    %eax,%edx
  100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ac5:	eb 04                	jmp    100acb <parse+0x88>
            buf ++;
  100ac7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100acb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ace:	0f b6 00             	movzbl (%eax),%eax
  100ad1:	84 c0                	test   %al,%al
  100ad3:	74 1d                	je     100af2 <parse+0xaf>
  100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad8:	0f b6 00             	movzbl (%eax),%eax
  100adb:	0f be c0             	movsbl %al,%eax
  100ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae2:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100ae9:	e8 2e 26 00 00       	call   10311c <strchr>
  100aee:	85 c0                	test   %eax,%eax
  100af0:	74 d5                	je     100ac7 <parse+0x84>
            buf ++;
        }
    }
  100af2:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af3:	e9 66 ff ff ff       	jmp    100a5e <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100afb:	c9                   	leave  
  100afc:	c3                   	ret    

00100afd <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100afd:	55                   	push   %ebp
  100afe:	89 e5                	mov    %esp,%ebp
  100b00:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b03:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	89 04 24             	mov    %eax,(%esp)
  100b10:	e8 2e ff ff ff       	call   100a43 <parse>
  100b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b1c:	75 0a                	jne    100b28 <runcmd+0x2b>
        return 0;
  100b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b23:	e9 85 00 00 00       	jmp    100bad <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b2f:	eb 5c                	jmp    100b8d <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b31:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b37:	89 d0                	mov    %edx,%eax
  100b39:	01 c0                	add    %eax,%eax
  100b3b:	01 d0                	add    %edx,%eax
  100b3d:	c1 e0 02             	shl    $0x2,%eax
  100b40:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b45:	8b 00                	mov    (%eax),%eax
  100b47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b4b:	89 04 24             	mov    %eax,(%esp)
  100b4e:	e8 2a 25 00 00       	call   10307d <strcmp>
  100b53:	85 c0                	test   %eax,%eax
  100b55:	75 32                	jne    100b89 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b5a:	89 d0                	mov    %edx,%eax
  100b5c:	01 c0                	add    %eax,%eax
  100b5e:	01 d0                	add    %edx,%eax
  100b60:	c1 e0 02             	shl    $0x2,%eax
  100b63:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b68:	8b 40 08             	mov    0x8(%eax),%eax
  100b6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b6e:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b74:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b78:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b7b:	83 c2 04             	add    $0x4,%edx
  100b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b82:	89 0c 24             	mov    %ecx,(%esp)
  100b85:	ff d0                	call   *%eax
  100b87:	eb 24                	jmp    100bad <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b90:	83 f8 02             	cmp    $0x2,%eax
  100b93:	76 9c                	jbe    100b31 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9c:	c7 04 24 d3 36 10 00 	movl   $0x1036d3,(%esp)
  100ba3:	e8 6a f7 ff ff       	call   100312 <cprintf>
    return 0;
  100ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bad:	c9                   	leave  
  100bae:	c3                   	ret    

00100baf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100baf:	55                   	push   %ebp
  100bb0:	89 e5                	mov    %esp,%ebp
  100bb2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bb5:	c7 04 24 ec 36 10 00 	movl   $0x1036ec,(%esp)
  100bbc:	e8 51 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bc1:	c7 04 24 14 37 10 00 	movl   $0x103714,(%esp)
  100bc8:	e8 45 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bd1:	74 0b                	je     100bde <kmonitor+0x2f>
        print_trapframe(tf);
  100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd6:	89 04 24             	mov    %eax,(%esp)
  100bd9:	e8 cc 0d 00 00       	call   1019aa <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bde:	c7 04 24 39 37 10 00 	movl   $0x103739,(%esp)
  100be5:	e8 1f f6 ff ff       	call   100209 <readline>
  100bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bf1:	74 18                	je     100c0b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bfd:	89 04 24             	mov    %eax,(%esp)
  100c00:	e8 f8 fe ff ff       	call   100afd <runcmd>
  100c05:	85 c0                	test   %eax,%eax
  100c07:	79 02                	jns    100c0b <kmonitor+0x5c>
                break;
  100c09:	eb 02                	jmp    100c0d <kmonitor+0x5e>
            }
        }
    }
  100c0b:	eb d1                	jmp    100bde <kmonitor+0x2f>
}
  100c0d:	c9                   	leave  
  100c0e:	c3                   	ret    

00100c0f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c0f:	55                   	push   %ebp
  100c10:	89 e5                	mov    %esp,%ebp
  100c12:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c1c:	eb 3f                	jmp    100c5d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c21:	89 d0                	mov    %edx,%eax
  100c23:	01 c0                	add    %eax,%eax
  100c25:	01 d0                	add    %edx,%eax
  100c27:	c1 e0 02             	shl    $0x2,%eax
  100c2a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c2f:	8b 48 04             	mov    0x4(%eax),%ecx
  100c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c35:	89 d0                	mov    %edx,%eax
  100c37:	01 c0                	add    %eax,%eax
  100c39:	01 d0                	add    %edx,%eax
  100c3b:	c1 e0 02             	shl    $0x2,%eax
  100c3e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c43:	8b 00                	mov    (%eax),%eax
  100c45:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4d:	c7 04 24 3d 37 10 00 	movl   $0x10373d,(%esp)
  100c54:	e8 b9 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c60:	83 f8 02             	cmp    $0x2,%eax
  100c63:	76 b9                	jbe    100c1e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6a:	c9                   	leave  
  100c6b:	c3                   	ret    

00100c6c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c6c:	55                   	push   %ebp
  100c6d:	89 e5                	mov    %esp,%ebp
  100c6f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c72:	e8 cf fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7c:	c9                   	leave  
  100c7d:	c3                   	ret    

00100c7e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c7e:	55                   	push   %ebp
  100c7f:	89 e5                	mov    %esp,%ebp
  100c81:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c84:	e8 07 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8e:	c9                   	leave  
  100c8f:	c3                   	ret    

00100c90 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c90:	55                   	push   %ebp
  100c91:	89 e5                	mov    %esp,%ebp
  100c93:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c96:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100c9b:	85 c0                	test   %eax,%eax
  100c9d:	74 02                	je     100ca1 <__panic+0x11>
        goto panic_dead;
  100c9f:	eb 48                	jmp    100ce9 <__panic+0x59>
    }
    is_panic = 1;
  100ca1:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100ca8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cab:	8d 45 14             	lea    0x14(%ebp),%eax
  100cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cb4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  100cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbf:	c7 04 24 46 37 10 00 	movl   $0x103746,(%esp)
  100cc6:	e8 47 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  100cd5:	89 04 24             	mov    %eax,(%esp)
  100cd8:	e8 02 f6 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cdd:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100ce4:	e8 29 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100ce9:	e8 22 09 00 00       	call   101610 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cf5:	e8 b5 fe ff ff       	call   100baf <kmonitor>
    }
  100cfa:	eb f2                	jmp    100cee <__panic+0x5e>

00100cfc <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100cfc:	55                   	push   %ebp
  100cfd:	89 e5                	mov    %esp,%ebp
  100cff:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d02:	8d 45 14             	lea    0x14(%ebp),%eax
  100d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d16:	c7 04 24 64 37 10 00 	movl   $0x103764,(%esp)
  100d1d:	e8 f0 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d29:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2c:	89 04 24             	mov    %eax,(%esp)
  100d2f:	e8 ab f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d34:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100d3b:	e8 d2 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d40:	c9                   	leave  
  100d41:	c3                   	ret    

00100d42 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d42:	55                   	push   %ebp
  100d43:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d45:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d4a:	5d                   	pop    %ebp
  100d4b:	c3                   	ret    

00100d4c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 28             	sub    $0x28,%esp
  100d52:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d58:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d5c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d60:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d64:	ee                   	out    %al,(%dx)
  100d65:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d6b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d6f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d73:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d77:	ee                   	out    %al,(%dx)
  100d78:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d7e:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d82:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d86:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d8a:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d8b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d92:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d95:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100d9c:	e8 71 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100da1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100da8:	e8 c1 08 00 00       	call   10166e <pic_enable>
}
  100dad:	c9                   	leave  
  100dae:	c3                   	ret    

00100daf <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100daf:	55                   	push   %ebp
  100db0:	89 e5                	mov    %esp,%ebp
  100db2:	83 ec 10             	sub    $0x10,%esp
  100db5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dbb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dbf:	89 c2                	mov    %eax,%edx
  100dc1:	ec                   	in     (%dx),%al
  100dc2:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dc5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dcb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dcf:	89 c2                	mov    %eax,%edx
  100dd1:	ec                   	in     (%dx),%al
  100dd2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dd5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ddb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ddf:	89 c2                	mov    %eax,%edx
  100de1:	ec                   	in     (%dx),%al
  100de2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100deb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100def:	89 c2                	mov    %eax,%edx
  100df1:	ec                   	in     (%dx),%al
  100df2:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100df7:	55                   	push   %ebp
  100df8:	89 e5                	mov    %esp,%ebp
  100dfa:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100dfd:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e07:	0f b7 00             	movzwl (%eax),%eax
  100e0a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e19:	0f b7 00             	movzwl (%eax),%eax
  100e1c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e20:	74 12                	je     100e34 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e22:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e29:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e30:	b4 03 
  100e32:	eb 13                	jmp    100e47 <cga_init+0x50>
    } else {
        *cp = was;
  100e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e3e:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e47:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4e:	0f b7 c0             	movzwl %ax,%eax
  100e51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e55:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e59:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e5d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e61:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e62:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e69:	83 c0 01             	add    $0x1,%eax
  100e6c:	0f b7 c0             	movzwl %ax,%eax
  100e6f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e73:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e77:	89 c2                	mov    %eax,%edx
  100e79:	ec                   	in     (%dx),%al
  100e7a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e7d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e81:	0f b6 c0             	movzbl %al,%eax
  100e84:	c1 e0 08             	shl    $0x8,%eax
  100e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e8a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e91:	0f b7 c0             	movzwl %ax,%eax
  100e94:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e98:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ea0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ea4:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ea5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eac:	83 c0 01             	add    $0x1,%eax
  100eaf:	0f b7 c0             	movzwl %ax,%eax
  100eb2:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100eba:	89 c2                	mov    %eax,%edx
  100ebc:	ec                   	in     (%dx),%al
  100ebd:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ec0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ec4:	0f b6 c0             	movzbl %al,%eax
  100ec7:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecd:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100edb:	c9                   	leave  
  100edc:	c3                   	ret    

00100edd <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edd:	55                   	push   %ebp
  100ede:	89 e5                	mov    %esp,%ebp
  100ee0:	83 ec 48             	sub    $0x48,%esp
  100ee3:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee9:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eed:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ef1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef5:	ee                   	out    %al,(%dx)
  100ef6:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100efc:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f00:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f04:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f08:	ee                   	out    %al,(%dx)
  100f09:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f0f:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f13:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f17:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f1b:	ee                   	out    %al,(%dx)
  100f1c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f22:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
  100f2f:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f35:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f39:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f41:	ee                   	out    %al,(%dx)
  100f42:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f48:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f4c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f50:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
  100f55:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f5b:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f5f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f63:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6e:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f72:	89 c2                	mov    %eax,%edx
  100f74:	ec                   	in     (%dx),%al
  100f75:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f78:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7c:	3c ff                	cmp    $0xff,%al
  100f7e:	0f 95 c0             	setne  %al
  100f81:	0f b6 c0             	movzbl %al,%eax
  100f84:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f89:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8f:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f93:	89 c2                	mov    %eax,%edx
  100f95:	ec                   	in     (%dx),%al
  100f96:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f99:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f9f:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fa3:	89 c2                	mov    %eax,%edx
  100fa5:	ec                   	in     (%dx),%al
  100fa6:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fae:	85 c0                	test   %eax,%eax
  100fb0:	74 0c                	je     100fbe <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fb2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fb9:	e8 b0 06 00 00       	call   10166e <pic_enable>
    }
}
  100fbe:	c9                   	leave  
  100fbf:	c3                   	ret    

00100fc0 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc0:	55                   	push   %ebp
  100fc1:	89 e5                	mov    %esp,%ebp
  100fc3:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fcd:	eb 09                	jmp    100fd8 <lpt_putc_sub+0x18>
        delay();
  100fcf:	e8 db fd ff ff       	call   100daf <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd8:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fde:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fe2:	89 c2                	mov    %eax,%edx
  100fe4:	ec                   	in     (%dx),%al
  100fe5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fec:	84 c0                	test   %al,%al
  100fee:	78 09                	js     100ff9 <lpt_putc_sub+0x39>
  100ff0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff7:	7e d6                	jle    100fcf <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffc:	0f b6 c0             	movzbl %al,%eax
  100fff:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101005:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101008:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10100c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101010:	ee                   	out    %al,(%dx)
  101011:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101017:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10101b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
  101024:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10102a:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10102e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101032:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101037:	c9                   	leave  
  101038:	c3                   	ret    

00101039 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101039:	55                   	push   %ebp
  10103a:	89 e5                	mov    %esp,%ebp
  10103c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10103f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101043:	74 0d                	je     101052 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101045:	8b 45 08             	mov    0x8(%ebp),%eax
  101048:	89 04 24             	mov    %eax,(%esp)
  10104b:	e8 70 ff ff ff       	call   100fc0 <lpt_putc_sub>
  101050:	eb 24                	jmp    101076 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101052:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101059:	e8 62 ff ff ff       	call   100fc0 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10105e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101065:	e8 56 ff ff ff       	call   100fc0 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10106a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101071:	e8 4a ff ff ff       	call   100fc0 <lpt_putc_sub>
    }
}
  101076:	c9                   	leave  
  101077:	c3                   	ret    

00101078 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101078:	55                   	push   %ebp
  101079:	89 e5                	mov    %esp,%ebp
  10107b:	53                   	push   %ebx
  10107c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10107f:	8b 45 08             	mov    0x8(%ebp),%eax
  101082:	b0 00                	mov    $0x0,%al
  101084:	85 c0                	test   %eax,%eax
  101086:	75 07                	jne    10108f <cga_putc+0x17>
        c |= 0x0700;
  101088:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10108f:	8b 45 08             	mov    0x8(%ebp),%eax
  101092:	0f b6 c0             	movzbl %al,%eax
  101095:	83 f8 0a             	cmp    $0xa,%eax
  101098:	74 4c                	je     1010e6 <cga_putc+0x6e>
  10109a:	83 f8 0d             	cmp    $0xd,%eax
  10109d:	74 57                	je     1010f6 <cga_putc+0x7e>
  10109f:	83 f8 08             	cmp    $0x8,%eax
  1010a2:	0f 85 88 00 00 00    	jne    101130 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010a8:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010af:	66 85 c0             	test   %ax,%ax
  1010b2:	74 30                	je     1010e4 <cga_putc+0x6c>
            crt_pos --;
  1010b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bb:	83 e8 01             	sub    $0x1,%eax
  1010be:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c9:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d0:	0f b7 d2             	movzwl %dx,%edx
  1010d3:	01 d2                	add    %edx,%edx
  1010d5:	01 c2                	add    %eax,%edx
  1010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010da:	b0 00                	mov    $0x0,%al
  1010dc:	83 c8 20             	or     $0x20,%eax
  1010df:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e2:	eb 72                	jmp    101156 <cga_putc+0xde>
  1010e4:	eb 70                	jmp    101156 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010e6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ed:	83 c0 50             	add    $0x50,%eax
  1010f0:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f6:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010fd:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101104:	0f b7 c1             	movzwl %cx,%eax
  101107:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10110d:	c1 e8 10             	shr    $0x10,%eax
  101110:	89 c2                	mov    %eax,%edx
  101112:	66 c1 ea 06          	shr    $0x6,%dx
  101116:	89 d0                	mov    %edx,%eax
  101118:	c1 e0 02             	shl    $0x2,%eax
  10111b:	01 d0                	add    %edx,%eax
  10111d:	c1 e0 04             	shl    $0x4,%eax
  101120:	29 c1                	sub    %eax,%ecx
  101122:	89 ca                	mov    %ecx,%edx
  101124:	89 d8                	mov    %ebx,%eax
  101126:	29 d0                	sub    %edx,%eax
  101128:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10112e:	eb 26                	jmp    101156 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101130:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101136:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10113d:	8d 50 01             	lea    0x1(%eax),%edx
  101140:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101147:	0f b7 c0             	movzwl %ax,%eax
  10114a:	01 c0                	add    %eax,%eax
  10114c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        break;
  101155:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101156:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115d:	66 3d cf 07          	cmp    $0x7cf,%ax
  101161:	76 5b                	jbe    1011be <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101163:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101168:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10116e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101173:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10117a:	00 
  10117b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10117f:	89 04 24             	mov    %eax,(%esp)
  101182:	e8 93 21 00 00       	call   10331a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101187:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10118e:	eb 15                	jmp    1011a5 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101190:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101198:	01 d2                	add    %edx,%edx
  10119a:	01 d0                	add    %edx,%eax
  10119c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011a5:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ac:	7e e2                	jle    101190 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ae:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b5:	83 e8 50             	sub    $0x50,%eax
  1011b8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011be:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011c5:	0f b7 c0             	movzwl %ax,%eax
  1011c8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011cc:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011d0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011d4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e0:	66 c1 e8 08          	shr    $0x8,%ax
  1011e4:	0f b6 c0             	movzbl %al,%eax
  1011e7:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011ee:	83 c2 01             	add    $0x1,%edx
  1011f1:	0f b7 d2             	movzwl %dx,%edx
  1011f4:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011f8:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011fb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011ff:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101203:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101204:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10120b:	0f b7 c0             	movzwl %ax,%eax
  10120e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101212:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101216:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10121a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10121e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10121f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101226:	0f b6 c0             	movzbl %al,%eax
  101229:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101230:	83 c2 01             	add    $0x1,%edx
  101233:	0f b7 d2             	movzwl %dx,%edx
  101236:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10123a:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10123d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101241:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101245:	ee                   	out    %al,(%dx)
}
  101246:	83 c4 34             	add    $0x34,%esp
  101249:	5b                   	pop    %ebx
  10124a:	5d                   	pop    %ebp
  10124b:	c3                   	ret    

0010124c <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10124c:	55                   	push   %ebp
  10124d:	89 e5                	mov    %esp,%ebp
  10124f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101259:	eb 09                	jmp    101264 <serial_putc_sub+0x18>
        delay();
  10125b:	e8 4f fb ff ff       	call   100daf <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101264:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10126a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10126e:	89 c2                	mov    %eax,%edx
  101270:	ec                   	in     (%dx),%al
  101271:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101274:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101278:	0f b6 c0             	movzbl %al,%eax
  10127b:	83 e0 20             	and    $0x20,%eax
  10127e:	85 c0                	test   %eax,%eax
  101280:	75 09                	jne    10128b <serial_putc_sub+0x3f>
  101282:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101289:	7e d0                	jle    10125b <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10128b:	8b 45 08             	mov    0x8(%ebp),%eax
  10128e:	0f b6 c0             	movzbl %al,%eax
  101291:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101297:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10129e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012a2:	ee                   	out    %al,(%dx)
}
  1012a3:	c9                   	leave  
  1012a4:	c3                   	ret    

001012a5 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a5:	55                   	push   %ebp
  1012a6:	89 e5                	mov    %esp,%ebp
  1012a8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012ab:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012af:	74 0d                	je     1012be <serial_putc+0x19>
        serial_putc_sub(c);
  1012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b4:	89 04 24             	mov    %eax,(%esp)
  1012b7:	e8 90 ff ff ff       	call   10124c <serial_putc_sub>
  1012bc:	eb 24                	jmp    1012e2 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012c5:	e8 82 ff ff ff       	call   10124c <serial_putc_sub>
        serial_putc_sub(' ');
  1012ca:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012d1:	e8 76 ff ff ff       	call   10124c <serial_putc_sub>
        serial_putc_sub('\b');
  1012d6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012dd:	e8 6a ff ff ff       	call   10124c <serial_putc_sub>
    }
}
  1012e2:	c9                   	leave  
  1012e3:	c3                   	ret    

001012e4 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e4:	55                   	push   %ebp
  1012e5:	89 e5                	mov    %esp,%ebp
  1012e7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012ea:	eb 33                	jmp    10131f <cons_intr+0x3b>
        if (c != 0) {
  1012ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f0:	74 2d                	je     10131f <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012f7:	8d 50 01             	lea    0x1(%eax),%edx
  1012fa:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101303:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101309:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101313:	75 0a                	jne    10131f <cons_intr+0x3b>
                cons.wpos = 0;
  101315:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10131c:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10131f:	8b 45 08             	mov    0x8(%ebp),%eax
  101322:	ff d0                	call   *%eax
  101324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101327:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10132b:	75 bf                	jne    1012ec <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10132d:	c9                   	leave  
  10132e:	c3                   	ret    

0010132f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10132f:	55                   	push   %ebp
  101330:	89 e5                	mov    %esp,%ebp
  101332:	83 ec 10             	sub    $0x10,%esp
  101335:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133f:	89 c2                	mov    %eax,%edx
  101341:	ec                   	in     (%dx),%al
  101342:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101345:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101349:	0f b6 c0             	movzbl %al,%eax
  10134c:	83 e0 01             	and    $0x1,%eax
  10134f:	85 c0                	test   %eax,%eax
  101351:	75 07                	jne    10135a <serial_proc_data+0x2b>
        return -1;
  101353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101358:	eb 2a                	jmp    101384 <serial_proc_data+0x55>
  10135a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101360:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101364:	89 c2                	mov    %eax,%edx
  101366:	ec                   	in     (%dx),%al
  101367:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10136a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10136e:	0f b6 c0             	movzbl %al,%eax
  101371:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101374:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101378:	75 07                	jne    101381 <serial_proc_data+0x52>
        c = '\b';
  10137a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101381:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101384:	c9                   	leave  
  101385:	c3                   	ret    

00101386 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10138c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101391:	85 c0                	test   %eax,%eax
  101393:	74 0c                	je     1013a1 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101395:	c7 04 24 2f 13 10 00 	movl   $0x10132f,(%esp)
  10139c:	e8 43 ff ff ff       	call   1012e4 <cons_intr>
    }
}
  1013a1:	c9                   	leave  
  1013a2:	c3                   	ret    

001013a3 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 38             	sub    $0x38,%esp
  1013a9:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013af:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013b3:	89 c2                	mov    %eax,%edx
  1013b5:	ec                   	in     (%dx),%al
  1013b6:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013bd:	0f b6 c0             	movzbl %al,%eax
  1013c0:	83 e0 01             	and    $0x1,%eax
  1013c3:	85 c0                	test   %eax,%eax
  1013c5:	75 0a                	jne    1013d1 <kbd_proc_data+0x2e>
        return -1;
  1013c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cc:	e9 59 01 00 00       	jmp    10152a <kbd_proc_data+0x187>
  1013d1:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013db:	89 c2                	mov    %eax,%edx
  1013dd:	ec                   	in     (%dx),%al
  1013de:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013e1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013e5:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013ec:	75 17                	jne    101405 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013ee:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f3:	83 c8 40             	or     $0x40,%eax
  1013f6:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013fb:	b8 00 00 00 00       	mov    $0x0,%eax
  101400:	e9 25 01 00 00       	jmp    10152a <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101405:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101409:	84 c0                	test   %al,%al
  10140b:	79 47                	jns    101454 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10140d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101412:	83 e0 40             	and    $0x40,%eax
  101415:	85 c0                	test   %eax,%eax
  101417:	75 09                	jne    101422 <kbd_proc_data+0x7f>
  101419:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141d:	83 e0 7f             	and    $0x7f,%eax
  101420:	eb 04                	jmp    101426 <kbd_proc_data+0x83>
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101429:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101434:	83 c8 40             	or     $0x40,%eax
  101437:	0f b6 c0             	movzbl %al,%eax
  10143a:	f7 d0                	not    %eax
  10143c:	89 c2                	mov    %eax,%edx
  10143e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101443:	21 d0                	and    %edx,%eax
  101445:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10144a:	b8 00 00 00 00       	mov    $0x0,%eax
  10144f:	e9 d6 00 00 00       	jmp    10152a <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101454:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101459:	83 e0 40             	and    $0x40,%eax
  10145c:	85 c0                	test   %eax,%eax
  10145e:	74 11                	je     101471 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101460:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101464:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101469:	83 e0 bf             	and    $0xffffffbf,%eax
  10146c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101471:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101475:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10147c:	0f b6 d0             	movzbl %al,%edx
  10147f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101484:	09 d0                	or     %edx,%eax
  101486:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10148b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148f:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101496:	0f b6 d0             	movzbl %al,%edx
  101499:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149e:	31 d0                	xor    %edx,%eax
  1014a0:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014aa:	83 e0 03             	and    $0x3,%eax
  1014ad:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b8:	01 d0                	add    %edx,%eax
  1014ba:	0f b6 00             	movzbl (%eax),%eax
  1014bd:	0f b6 c0             	movzbl %al,%eax
  1014c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014c3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c8:	83 e0 08             	and    $0x8,%eax
  1014cb:	85 c0                	test   %eax,%eax
  1014cd:	74 22                	je     1014f1 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014cf:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014d3:	7e 0c                	jle    1014e1 <kbd_proc_data+0x13e>
  1014d5:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d9:	7f 06                	jg     1014e1 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014db:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014df:	eb 10                	jmp    1014f1 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014e1:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014e5:	7e 0a                	jle    1014f1 <kbd_proc_data+0x14e>
  1014e7:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014eb:	7f 04                	jg     1014f1 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014ed:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014f1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f6:	f7 d0                	not    %eax
  1014f8:	83 e0 06             	and    $0x6,%eax
  1014fb:	85 c0                	test   %eax,%eax
  1014fd:	75 28                	jne    101527 <kbd_proc_data+0x184>
  1014ff:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101506:	75 1f                	jne    101527 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101508:	c7 04 24 9d 37 10 00 	movl   $0x10379d,(%esp)
  10150f:	e8 fe ed ff ff       	call   100312 <cprintf>
  101514:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10151a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101522:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101526:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101527:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10152a:	c9                   	leave  
  10152b:	c3                   	ret    

0010152c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10152c:	55                   	push   %ebp
  10152d:	89 e5                	mov    %esp,%ebp
  10152f:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101532:	c7 04 24 a3 13 10 00 	movl   $0x1013a3,(%esp)
  101539:	e8 a6 fd ff ff       	call   1012e4 <cons_intr>
}
  10153e:	c9                   	leave  
  10153f:	c3                   	ret    

00101540 <kbd_init>:

static void
kbd_init(void) {
  101540:	55                   	push   %ebp
  101541:	89 e5                	mov    %esp,%ebp
  101543:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101546:	e8 e1 ff ff ff       	call   10152c <kbd_intr>
    pic_enable(IRQ_KBD);
  10154b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101552:	e8 17 01 00 00       	call   10166e <pic_enable>
}
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10155f:	e8 93 f8 ff ff       	call   100df7 <cga_init>
    serial_init();
  101564:	e8 74 f9 ff ff       	call   100edd <serial_init>
    kbd_init();
  101569:	e8 d2 ff ff ff       	call   101540 <kbd_init>
    if (!serial_exists) {
  10156e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	75 0c                	jne    101583 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101577:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  10157e:	e8 8f ed ff ff       	call   100312 <cprintf>
    }
}
  101583:	c9                   	leave  
  101584:	c3                   	ret    

00101585 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101585:	55                   	push   %ebp
  101586:	89 e5                	mov    %esp,%ebp
  101588:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10158b:	8b 45 08             	mov    0x8(%ebp),%eax
  10158e:	89 04 24             	mov    %eax,(%esp)
  101591:	e8 a3 fa ff ff       	call   101039 <lpt_putc>
    cga_putc(c);
  101596:	8b 45 08             	mov    0x8(%ebp),%eax
  101599:	89 04 24             	mov    %eax,(%esp)
  10159c:	e8 d7 fa ff ff       	call   101078 <cga_putc>
    serial_putc(c);
  1015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a4:	89 04 24             	mov    %eax,(%esp)
  1015a7:	e8 f9 fc ff ff       	call   1012a5 <serial_putc>
}
  1015ac:	c9                   	leave  
  1015ad:	c3                   	ret    

001015ae <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ae:	55                   	push   %ebp
  1015af:	89 e5                	mov    %esp,%ebp
  1015b1:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015b4:	e8 cd fd ff ff       	call   101386 <serial_intr>
    kbd_intr();
  1015b9:	e8 6e ff ff ff       	call   10152c <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015be:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015c4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015c9:	39 c2                	cmp    %eax,%edx
  1015cb:	74 36                	je     101603 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015cd:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d2:	8d 50 01             	lea    0x1(%eax),%edx
  1015d5:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015db:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e2:	0f b6 c0             	movzbl %al,%eax
  1015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015e8:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ed:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f2:	75 0a                	jne    1015fe <cons_getc+0x50>
            cons.rpos = 0;
  1015f4:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015fb:	00 00 00 
        }
        return c;
  1015fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101601:	eb 05                	jmp    101608 <cons_getc+0x5a>
    }
    return 0;
  101603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101608:	c9                   	leave  
  101609:	c3                   	ret    

0010160a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10160a:	55                   	push   %ebp
  10160b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10160d:	fb                   	sti    
    sti();
}
  10160e:	5d                   	pop    %ebp
  10160f:	c3                   	ret    

00101610 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101613:	fa                   	cli    
    cli();
}
  101614:	5d                   	pop    %ebp
  101615:	c3                   	ret    

00101616 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
  101619:	83 ec 14             	sub    $0x14,%esp
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101623:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101627:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10162d:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101632:	85 c0                	test   %eax,%eax
  101634:	74 36                	je     10166c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101636:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163a:	0f b6 c0             	movzbl %al,%eax
  10163d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101643:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101646:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10164a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10164e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10164f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101653:	66 c1 e8 08          	shr    $0x8,%ax
  101657:	0f b6 c0             	movzbl %al,%eax
  10165a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101660:	88 45 f9             	mov    %al,-0x7(%ebp)
  101663:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101667:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10166b:	ee                   	out    %al,(%dx)
    }
}
  10166c:	c9                   	leave  
  10166d:	c3                   	ret    

0010166e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10166e:	55                   	push   %ebp
  10166f:	89 e5                	mov    %esp,%ebp
  101671:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101674:	8b 45 08             	mov    0x8(%ebp),%eax
  101677:	ba 01 00 00 00       	mov    $0x1,%edx
  10167c:	89 c1                	mov    %eax,%ecx
  10167e:	d3 e2                	shl    %cl,%edx
  101680:	89 d0                	mov    %edx,%eax
  101682:	f7 d0                	not    %eax
  101684:	89 c2                	mov    %eax,%edx
  101686:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168d:	21 d0                	and    %edx,%eax
  10168f:	0f b7 c0             	movzwl %ax,%eax
  101692:	89 04 24             	mov    %eax,(%esp)
  101695:	e8 7c ff ff ff       	call   101616 <pic_setmask>
}
  10169a:	c9                   	leave  
  10169b:	c3                   	ret    

0010169c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169c:	55                   	push   %ebp
  10169d:	89 e5                	mov    %esp,%ebp
  10169f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016a2:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016a9:	00 00 00 
  1016ac:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b2:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016b6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ba:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016be:	ee                   	out    %al,(%dx)
  1016bf:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016c5:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d1:	ee                   	out    %al,(%dx)
  1016d2:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016d8:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016dc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016e0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016eb:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016ef:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016f3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016fe:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101702:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101706:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101711:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101715:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101719:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101724:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101728:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10172c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101737:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10173b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10173f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10174a:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10174e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101752:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10175d:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101761:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101765:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101770:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101774:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101778:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101783:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101787:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10178b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101796:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10179a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10179e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017a9:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017ad:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017b1:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017bd:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c1:	74 12                	je     1017d5 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017c3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ca:	0f b7 c0             	movzwl %ax,%eax
  1017cd:	89 04 24             	mov    %eax,(%esp)
  1017d0:	e8 41 fe ff ff       	call   101616 <pic_setmask>
    }
}
  1017d5:	c9                   	leave  
  1017d6:	c3                   	ret    

001017d7 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017d7:	55                   	push   %ebp
  1017d8:	89 e5                	mov    %esp,%ebp
  1017da:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017dd:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017e4:	00 
  1017e5:	c7 04 24 e0 37 10 00 	movl   $0x1037e0,(%esp)
  1017ec:	e8 21 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017f1:	c9                   	leave  
  1017f2:	c3                   	ret    

001017f3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
  1017f6:	83 ec 10             	sub    $0x10,%esp
          SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        lidt(&idt_pd);*/
	extern uintptr_t __vectors[];
	int i;
	for(i=0;i<256;i++){
  1017f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101800:	e9 c3 00 00 00       	jmp    1018c8 <idt_init+0xd5>
	//SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[i],0,KERNEL_CS,__vectors[i],3); 
  101805:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101808:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10180f:	89 c2                	mov    %eax,%edx
  101811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101814:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10181b:	00 
  10181c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181f:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101826:	00 08 00 
  101829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182c:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101833:	00 
  101834:	83 e2 e0             	and    $0xffffffe0,%edx
  101837:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10183e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101841:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101848:	00 
  101849:	83 e2 1f             	and    $0x1f,%edx
  10184c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101856:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10185d:	00 
  10185e:	83 e2 f0             	and    $0xfffffff0,%edx
  101861:	83 ca 0e             	or     $0xe,%edx
  101864:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10186b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186e:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101875:	00 
  101876:	83 e2 ef             	and    $0xffffffef,%edx
  101879:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101880:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101883:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10188a:	00 
  10188b:	83 ca 60             	or     $0x60,%edx
  10188e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101895:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101898:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189f:	00 
  1018a0:	83 ca 80             	or     $0xffffff80,%edx
  1018a3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018b4:	c1 e8 10             	shr    $0x10,%eax
  1018b7:	89 c2                	mov    %eax,%edx
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018c3:	00 
          SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        lidt(&idt_pd);*/
	extern uintptr_t __vectors[];
	int i;
	for(i=0;i<256;i++){
  1018c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018c8:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018cf:	0f 8e 30 ff ff ff    	jle    101805 <idt_init+0x12>
	//SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[i],0,KERNEL_CS,__vectors[i],3); 
	}
	SETGATE(idt[T_SYSCALL],0,KERNEL_CS,__vectors[T_SYSCALL],0);
  1018d5:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  1018da:	66 a3 a0 f4 10 00    	mov    %ax,0x10f4a0
  1018e0:	66 c7 05 a2 f4 10 00 	movw   $0x8,0x10f4a2
  1018e7:	08 00 
  1018e9:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  1018f0:	83 e0 e0             	and    $0xffffffe0,%eax
  1018f3:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  1018f8:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  1018ff:	83 e0 1f             	and    $0x1f,%eax
  101902:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101907:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10190e:	83 e0 f0             	and    $0xfffffff0,%eax
  101911:	83 c8 0e             	or     $0xe,%eax
  101914:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101919:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101920:	83 e0 ef             	and    $0xffffffef,%eax
  101923:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101928:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10192f:	83 e0 9f             	and    $0xffffff9f,%eax
  101932:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101937:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10193e:	83 c8 80             	or     $0xffffff80,%eax
  101941:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101946:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  10194b:	c1 e8 10             	shr    $0x10,%eax
  10194e:	66 a3 a6 f4 10 00    	mov    %ax,0x10f4a6
  101954:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10195e:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd); 
}
  101961:	c9                   	leave  
  101962:	c3                   	ret    

00101963 <trapname>:

static const char *
trapname(int trapno) {
  101963:	55                   	push   %ebp
  101964:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101966:	8b 45 08             	mov    0x8(%ebp),%eax
  101969:	83 f8 13             	cmp    $0x13,%eax
  10196c:	77 0c                	ja     10197a <trapname+0x17>
        return excnames[trapno];
  10196e:	8b 45 08             	mov    0x8(%ebp),%eax
  101971:	8b 04 85 40 3b 10 00 	mov    0x103b40(,%eax,4),%eax
  101978:	eb 18                	jmp    101992 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10197a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10197e:	7e 0d                	jle    10198d <trapname+0x2a>
  101980:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101984:	7f 07                	jg     10198d <trapname+0x2a>
        return "Hardware Interrupt";
  101986:	b8 ea 37 10 00       	mov    $0x1037ea,%eax
  10198b:	eb 05                	jmp    101992 <trapname+0x2f>
    }
    return "(unknown trap)";
  10198d:	b8 fd 37 10 00       	mov    $0x1037fd,%eax
}
  101992:	5d                   	pop    %ebp
  101993:	c3                   	ret    

00101994 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101994:	55                   	push   %ebp
  101995:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101997:	8b 45 08             	mov    0x8(%ebp),%eax
  10199a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10199e:	66 83 f8 08          	cmp    $0x8,%ax
  1019a2:	0f 94 c0             	sete   %al
  1019a5:	0f b6 c0             	movzbl %al,%eax
}
  1019a8:	5d                   	pop    %ebp
  1019a9:	c3                   	ret    

001019aa <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019aa:	55                   	push   %ebp
  1019ab:	89 e5                	mov    %esp,%ebp
  1019ad:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b7:	c7 04 24 3e 38 10 00 	movl   $0x10383e,(%esp)
  1019be:	e8 4f e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c6:	89 04 24             	mov    %eax,(%esp)
  1019c9:	e8 a1 01 00 00       	call   101b6f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019d5:	0f b7 c0             	movzwl %ax,%eax
  1019d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019dc:	c7 04 24 4f 38 10 00 	movl   $0x10384f,(%esp)
  1019e3:	e8 2a e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019eb:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019ef:	0f b7 c0             	movzwl %ax,%eax
  1019f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f6:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  1019fd:	e8 10 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a02:	8b 45 08             	mov    0x8(%ebp),%eax
  101a05:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a09:	0f b7 c0             	movzwl %ax,%eax
  101a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a10:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  101a17:	e8 f6 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a23:	0f b7 c0             	movzwl %ax,%eax
  101a26:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2a:	c7 04 24 88 38 10 00 	movl   $0x103888,(%esp)
  101a31:	e8 dc e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a36:	8b 45 08             	mov    0x8(%ebp),%eax
  101a39:	8b 40 30             	mov    0x30(%eax),%eax
  101a3c:	89 04 24             	mov    %eax,(%esp)
  101a3f:	e8 1f ff ff ff       	call   101963 <trapname>
  101a44:	8b 55 08             	mov    0x8(%ebp),%edx
  101a47:	8b 52 30             	mov    0x30(%edx),%edx
  101a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a4e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a52:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  101a59:	e8 b4 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	8b 40 34             	mov    0x34(%eax),%eax
  101a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a68:	c7 04 24 ad 38 10 00 	movl   $0x1038ad,(%esp)
  101a6f:	e8 9e e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	8b 40 38             	mov    0x38(%eax),%eax
  101a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7e:	c7 04 24 bc 38 10 00 	movl   $0x1038bc,(%esp)
  101a85:	e8 88 e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a91:	0f b7 c0             	movzwl %ax,%eax
  101a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a98:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  101a9f:	e8 6e e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa7:	8b 40 40             	mov    0x40(%eax),%eax
  101aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aae:	c7 04 24 de 38 10 00 	movl   $0x1038de,(%esp)
  101ab5:	e8 58 e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ac1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ac8:	eb 3e                	jmp    101b08 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aca:	8b 45 08             	mov    0x8(%ebp),%eax
  101acd:	8b 50 40             	mov    0x40(%eax),%edx
  101ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ad3:	21 d0                	and    %edx,%eax
  101ad5:	85 c0                	test   %eax,%eax
  101ad7:	74 28                	je     101b01 <print_trapframe+0x157>
  101ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101adc:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ae3:	85 c0                	test   %eax,%eax
  101ae5:	74 1a                	je     101b01 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aea:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af5:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  101afc:	e8 11 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b01:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b05:	d1 65 f0             	shll   -0x10(%ebp)
  101b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0b:	83 f8 17             	cmp    $0x17,%eax
  101b0e:	76 ba                	jbe    101aca <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	8b 40 40             	mov    0x40(%eax),%eax
  101b16:	25 00 30 00 00       	and    $0x3000,%eax
  101b1b:	c1 e8 0c             	shr    $0xc,%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 f1 38 10 00 	movl   $0x1038f1,(%esp)
  101b29:	e8 e4 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	89 04 24             	mov    %eax,(%esp)
  101b34:	e8 5b fe ff ff       	call   101994 <trap_in_kernel>
  101b39:	85 c0                	test   %eax,%eax
  101b3b:	75 30                	jne    101b6d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b40:	8b 40 44             	mov    0x44(%eax),%eax
  101b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b47:	c7 04 24 fa 38 10 00 	movl   $0x1038fa,(%esp)
  101b4e:	e8 bf e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b5a:	0f b7 c0             	movzwl %ax,%eax
  101b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b61:	c7 04 24 09 39 10 00 	movl   $0x103909,(%esp)
  101b68:	e8 a5 e7 ff ff       	call   100312 <cprintf>
    }
}
  101b6d:	c9                   	leave  
  101b6e:	c3                   	ret    

00101b6f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b6f:	55                   	push   %ebp
  101b70:	89 e5                	mov    %esp,%ebp
  101b72:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	8b 00                	mov    (%eax),%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  101b85:	e8 88 e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	8b 40 04             	mov    0x4(%eax),%eax
  101b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b94:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  101b9b:	e8 72 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba3:	8b 40 08             	mov    0x8(%eax),%eax
  101ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baa:	c7 04 24 3a 39 10 00 	movl   $0x10393a,(%esp)
  101bb1:	e8 5c e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  101bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc0:	c7 04 24 49 39 10 00 	movl   $0x103949,(%esp)
  101bc7:	e8 46 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcf:	8b 40 10             	mov    0x10(%eax),%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 58 39 10 00 	movl   $0x103958,(%esp)
  101bdd:	e8 30 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	8b 40 14             	mov    0x14(%eax),%eax
  101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bec:	c7 04 24 67 39 10 00 	movl   $0x103967,(%esp)
  101bf3:	e8 1a e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 18             	mov    0x18(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 76 39 10 00 	movl   $0x103976,(%esp)
  101c09:	e8 04 e7 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 85 39 10 00 	movl   $0x103985,(%esp)
  101c1f:	e8 ee e6 ff ff       	call   100312 <cprintf>
}
  101c24:	c9                   	leave  
  101c25:	c3                   	ret    

00101c26 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c26:	55                   	push   %ebp
  101c27:	89 e5                	mov    %esp,%ebp
  101c29:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 40 30             	mov    0x30(%eax),%eax
  101c32:	83 f8 2f             	cmp    $0x2f,%eax
  101c35:	77 21                	ja     101c58 <trap_dispatch+0x32>
  101c37:	83 f8 2e             	cmp    $0x2e,%eax
  101c3a:	0f 83 04 01 00 00    	jae    101d44 <trap_dispatch+0x11e>
  101c40:	83 f8 21             	cmp    $0x21,%eax
  101c43:	0f 84 81 00 00 00    	je     101cca <trap_dispatch+0xa4>
  101c49:	83 f8 24             	cmp    $0x24,%eax
  101c4c:	74 56                	je     101ca4 <trap_dispatch+0x7e>
  101c4e:	83 f8 20             	cmp    $0x20,%eax
  101c51:	74 16                	je     101c69 <trap_dispatch+0x43>
  101c53:	e9 b4 00 00 00       	jmp    101d0c <trap_dispatch+0xe6>
  101c58:	83 e8 78             	sub    $0x78,%eax
  101c5b:	83 f8 01             	cmp    $0x1,%eax
  101c5e:	0f 87 a8 00 00 00    	ja     101d0c <trap_dispatch+0xe6>
  101c64:	e9 87 00 00 00       	jmp    101cf0 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101c69:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c6e:	83 c0 01             	add    $0x1,%eax
  101c71:	a3 08 f9 10 00       	mov    %eax,0x10f908
	 if (ticks % TICK_NUM == 0) {
  101c76:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c7c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c81:	89 c8                	mov    %ecx,%eax
  101c83:	f7 e2                	mul    %edx
  101c85:	89 d0                	mov    %edx,%eax
  101c87:	c1 e8 05             	shr    $0x5,%eax
  101c8a:	6b c0 64             	imul   $0x64,%eax,%eax
  101c8d:	29 c1                	sub    %eax,%ecx
  101c8f:	89 c8                	mov    %ecx,%eax
  101c91:	85 c0                	test   %eax,%eax
  101c93:	75 0a                	jne    101c9f <trap_dispatch+0x79>
            print_ticks();
  101c95:	e8 3d fb ff ff       	call   1017d7 <print_ticks>
        }
        break;
  101c9a:	e9 a6 00 00 00       	jmp    101d45 <trap_dispatch+0x11f>
  101c9f:	e9 a1 00 00 00       	jmp    101d45 <trap_dispatch+0x11f>
       
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ca4:	e8 05 f9 ff ff       	call   1015ae <cons_getc>
  101ca9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cac:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cb0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cb4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbc:	c7 04 24 94 39 10 00 	movl   $0x103994,(%esp)
  101cc3:	e8 4a e6 ff ff       	call   100312 <cprintf>
        break;
  101cc8:	eb 7b                	jmp    101d45 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cca:	e8 df f8 ff ff       	call   1015ae <cons_getc>
  101ccf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cd2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cd6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cda:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce2:	c7 04 24 a6 39 10 00 	movl   $0x1039a6,(%esp)
  101ce9:	e8 24 e6 ff ff       	call   100312 <cprintf>
        break;
  101cee:	eb 55                	jmp    101d45 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cf0:	c7 44 24 08 b5 39 10 	movl   $0x1039b5,0x8(%esp)
  101cf7:	00 
  101cf8:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101cff:	00 
  101d00:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d07:	e8 84 ef ff ff       	call   100c90 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d13:	0f b7 c0             	movzwl %ax,%eax
  101d16:	83 e0 03             	and    $0x3,%eax
  101d19:	85 c0                	test   %eax,%eax
  101d1b:	75 28                	jne    101d45 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d20:	89 04 24             	mov    %eax,(%esp)
  101d23:	e8 82 fc ff ff       	call   1019aa <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d28:	c7 44 24 08 d6 39 10 	movl   $0x1039d6,0x8(%esp)
  101d2f:	00 
  101d30:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  101d37:	00 
  101d38:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d3f:	e8 4c ef ff ff       	call   100c90 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d44:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d45:	c9                   	leave  
  101d46:	c3                   	ret    

00101d47 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d47:	55                   	push   %ebp
  101d48:	89 e5                	mov    %esp,%ebp
  101d4a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	89 04 24             	mov    %eax,(%esp)
  101d53:	e8 ce fe ff ff       	call   101c26 <trap_dispatch>
}
  101d58:	c9                   	leave  
  101d59:	c3                   	ret    

00101d5a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d5a:	1e                   	push   %ds
    pushl %es
  101d5b:	06                   	push   %es
    pushl %fs
  101d5c:	0f a0                	push   %fs
    pushl %gs
  101d5e:	0f a8                	push   %gs
    pushal
  101d60:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d61:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d66:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d68:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d6a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d6b:	e8 d7 ff ff ff       	call   101d47 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d70:	5c                   	pop    %esp

00101d71 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d71:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d72:	0f a9                	pop    %gs
    popl %fs
  101d74:	0f a1                	pop    %fs
    popl %es
  101d76:	07                   	pop    %es
    popl %ds
  101d77:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d78:	83 c4 08             	add    $0x8,%esp
    iret
  101d7b:	cf                   	iret   

00101d7c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $0
  101d7e:	6a 00                	push   $0x0
  jmp __alltraps
  101d80:	e9 d5 ff ff ff       	jmp    101d5a <__alltraps>

00101d85 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $1
  101d87:	6a 01                	push   $0x1
  jmp __alltraps
  101d89:	e9 cc ff ff ff       	jmp    101d5a <__alltraps>

00101d8e <vector2>:
.globl vector2
vector2:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $2
  101d90:	6a 02                	push   $0x2
  jmp __alltraps
  101d92:	e9 c3 ff ff ff       	jmp    101d5a <__alltraps>

00101d97 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $3
  101d99:	6a 03                	push   $0x3
  jmp __alltraps
  101d9b:	e9 ba ff ff ff       	jmp    101d5a <__alltraps>

00101da0 <vector4>:
.globl vector4
vector4:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $4
  101da2:	6a 04                	push   $0x4
  jmp __alltraps
  101da4:	e9 b1 ff ff ff       	jmp    101d5a <__alltraps>

00101da9 <vector5>:
.globl vector5
vector5:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $5
  101dab:	6a 05                	push   $0x5
  jmp __alltraps
  101dad:	e9 a8 ff ff ff       	jmp    101d5a <__alltraps>

00101db2 <vector6>:
.globl vector6
vector6:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $6
  101db4:	6a 06                	push   $0x6
  jmp __alltraps
  101db6:	e9 9f ff ff ff       	jmp    101d5a <__alltraps>

00101dbb <vector7>:
.globl vector7
vector7:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $7
  101dbd:	6a 07                	push   $0x7
  jmp __alltraps
  101dbf:	e9 96 ff ff ff       	jmp    101d5a <__alltraps>

00101dc4 <vector8>:
.globl vector8
vector8:
  pushl $8
  101dc4:	6a 08                	push   $0x8
  jmp __alltraps
  101dc6:	e9 8f ff ff ff       	jmp    101d5a <__alltraps>

00101dcb <vector9>:
.globl vector9
vector9:
  pushl $9
  101dcb:	6a 09                	push   $0x9
  jmp __alltraps
  101dcd:	e9 88 ff ff ff       	jmp    101d5a <__alltraps>

00101dd2 <vector10>:
.globl vector10
vector10:
  pushl $10
  101dd2:	6a 0a                	push   $0xa
  jmp __alltraps
  101dd4:	e9 81 ff ff ff       	jmp    101d5a <__alltraps>

00101dd9 <vector11>:
.globl vector11
vector11:
  pushl $11
  101dd9:	6a 0b                	push   $0xb
  jmp __alltraps
  101ddb:	e9 7a ff ff ff       	jmp    101d5a <__alltraps>

00101de0 <vector12>:
.globl vector12
vector12:
  pushl $12
  101de0:	6a 0c                	push   $0xc
  jmp __alltraps
  101de2:	e9 73 ff ff ff       	jmp    101d5a <__alltraps>

00101de7 <vector13>:
.globl vector13
vector13:
  pushl $13
  101de7:	6a 0d                	push   $0xd
  jmp __alltraps
  101de9:	e9 6c ff ff ff       	jmp    101d5a <__alltraps>

00101dee <vector14>:
.globl vector14
vector14:
  pushl $14
  101dee:	6a 0e                	push   $0xe
  jmp __alltraps
  101df0:	e9 65 ff ff ff       	jmp    101d5a <__alltraps>

00101df5 <vector15>:
.globl vector15
vector15:
  pushl $0
  101df5:	6a 00                	push   $0x0
  pushl $15
  101df7:	6a 0f                	push   $0xf
  jmp __alltraps
  101df9:	e9 5c ff ff ff       	jmp    101d5a <__alltraps>

00101dfe <vector16>:
.globl vector16
vector16:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $16
  101e00:	6a 10                	push   $0x10
  jmp __alltraps
  101e02:	e9 53 ff ff ff       	jmp    101d5a <__alltraps>

00101e07 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e07:	6a 11                	push   $0x11
  jmp __alltraps
  101e09:	e9 4c ff ff ff       	jmp    101d5a <__alltraps>

00101e0e <vector18>:
.globl vector18
vector18:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $18
  101e10:	6a 12                	push   $0x12
  jmp __alltraps
  101e12:	e9 43 ff ff ff       	jmp    101d5a <__alltraps>

00101e17 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $19
  101e19:	6a 13                	push   $0x13
  jmp __alltraps
  101e1b:	e9 3a ff ff ff       	jmp    101d5a <__alltraps>

00101e20 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $20
  101e22:	6a 14                	push   $0x14
  jmp __alltraps
  101e24:	e9 31 ff ff ff       	jmp    101d5a <__alltraps>

00101e29 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $21
  101e2b:	6a 15                	push   $0x15
  jmp __alltraps
  101e2d:	e9 28 ff ff ff       	jmp    101d5a <__alltraps>

00101e32 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $22
  101e34:	6a 16                	push   $0x16
  jmp __alltraps
  101e36:	e9 1f ff ff ff       	jmp    101d5a <__alltraps>

00101e3b <vector23>:
.globl vector23
vector23:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $23
  101e3d:	6a 17                	push   $0x17
  jmp __alltraps
  101e3f:	e9 16 ff ff ff       	jmp    101d5a <__alltraps>

00101e44 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $24
  101e46:	6a 18                	push   $0x18
  jmp __alltraps
  101e48:	e9 0d ff ff ff       	jmp    101d5a <__alltraps>

00101e4d <vector25>:
.globl vector25
vector25:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $25
  101e4f:	6a 19                	push   $0x19
  jmp __alltraps
  101e51:	e9 04 ff ff ff       	jmp    101d5a <__alltraps>

00101e56 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $26
  101e58:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e5a:	e9 fb fe ff ff       	jmp    101d5a <__alltraps>

00101e5f <vector27>:
.globl vector27
vector27:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $27
  101e61:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e63:	e9 f2 fe ff ff       	jmp    101d5a <__alltraps>

00101e68 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $28
  101e6a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e6c:	e9 e9 fe ff ff       	jmp    101d5a <__alltraps>

00101e71 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $29
  101e73:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e75:	e9 e0 fe ff ff       	jmp    101d5a <__alltraps>

00101e7a <vector30>:
.globl vector30
vector30:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $30
  101e7c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e7e:	e9 d7 fe ff ff       	jmp    101d5a <__alltraps>

00101e83 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $31
  101e85:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e87:	e9 ce fe ff ff       	jmp    101d5a <__alltraps>

00101e8c <vector32>:
.globl vector32
vector32:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $32
  101e8e:	6a 20                	push   $0x20
  jmp __alltraps
  101e90:	e9 c5 fe ff ff       	jmp    101d5a <__alltraps>

00101e95 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $33
  101e97:	6a 21                	push   $0x21
  jmp __alltraps
  101e99:	e9 bc fe ff ff       	jmp    101d5a <__alltraps>

00101e9e <vector34>:
.globl vector34
vector34:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $34
  101ea0:	6a 22                	push   $0x22
  jmp __alltraps
  101ea2:	e9 b3 fe ff ff       	jmp    101d5a <__alltraps>

00101ea7 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $35
  101ea9:	6a 23                	push   $0x23
  jmp __alltraps
  101eab:	e9 aa fe ff ff       	jmp    101d5a <__alltraps>

00101eb0 <vector36>:
.globl vector36
vector36:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $36
  101eb2:	6a 24                	push   $0x24
  jmp __alltraps
  101eb4:	e9 a1 fe ff ff       	jmp    101d5a <__alltraps>

00101eb9 <vector37>:
.globl vector37
vector37:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $37
  101ebb:	6a 25                	push   $0x25
  jmp __alltraps
  101ebd:	e9 98 fe ff ff       	jmp    101d5a <__alltraps>

00101ec2 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $38
  101ec4:	6a 26                	push   $0x26
  jmp __alltraps
  101ec6:	e9 8f fe ff ff       	jmp    101d5a <__alltraps>

00101ecb <vector39>:
.globl vector39
vector39:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $39
  101ecd:	6a 27                	push   $0x27
  jmp __alltraps
  101ecf:	e9 86 fe ff ff       	jmp    101d5a <__alltraps>

00101ed4 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $40
  101ed6:	6a 28                	push   $0x28
  jmp __alltraps
  101ed8:	e9 7d fe ff ff       	jmp    101d5a <__alltraps>

00101edd <vector41>:
.globl vector41
vector41:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $41
  101edf:	6a 29                	push   $0x29
  jmp __alltraps
  101ee1:	e9 74 fe ff ff       	jmp    101d5a <__alltraps>

00101ee6 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $42
  101ee8:	6a 2a                	push   $0x2a
  jmp __alltraps
  101eea:	e9 6b fe ff ff       	jmp    101d5a <__alltraps>

00101eef <vector43>:
.globl vector43
vector43:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $43
  101ef1:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ef3:	e9 62 fe ff ff       	jmp    101d5a <__alltraps>

00101ef8 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $44
  101efa:	6a 2c                	push   $0x2c
  jmp __alltraps
  101efc:	e9 59 fe ff ff       	jmp    101d5a <__alltraps>

00101f01 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $45
  101f03:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f05:	e9 50 fe ff ff       	jmp    101d5a <__alltraps>

00101f0a <vector46>:
.globl vector46
vector46:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $46
  101f0c:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f0e:	e9 47 fe ff ff       	jmp    101d5a <__alltraps>

00101f13 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $47
  101f15:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f17:	e9 3e fe ff ff       	jmp    101d5a <__alltraps>

00101f1c <vector48>:
.globl vector48
vector48:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $48
  101f1e:	6a 30                	push   $0x30
  jmp __alltraps
  101f20:	e9 35 fe ff ff       	jmp    101d5a <__alltraps>

00101f25 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $49
  101f27:	6a 31                	push   $0x31
  jmp __alltraps
  101f29:	e9 2c fe ff ff       	jmp    101d5a <__alltraps>

00101f2e <vector50>:
.globl vector50
vector50:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $50
  101f30:	6a 32                	push   $0x32
  jmp __alltraps
  101f32:	e9 23 fe ff ff       	jmp    101d5a <__alltraps>

00101f37 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $51
  101f39:	6a 33                	push   $0x33
  jmp __alltraps
  101f3b:	e9 1a fe ff ff       	jmp    101d5a <__alltraps>

00101f40 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $52
  101f42:	6a 34                	push   $0x34
  jmp __alltraps
  101f44:	e9 11 fe ff ff       	jmp    101d5a <__alltraps>

00101f49 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $53
  101f4b:	6a 35                	push   $0x35
  jmp __alltraps
  101f4d:	e9 08 fe ff ff       	jmp    101d5a <__alltraps>

00101f52 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $54
  101f54:	6a 36                	push   $0x36
  jmp __alltraps
  101f56:	e9 ff fd ff ff       	jmp    101d5a <__alltraps>

00101f5b <vector55>:
.globl vector55
vector55:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $55
  101f5d:	6a 37                	push   $0x37
  jmp __alltraps
  101f5f:	e9 f6 fd ff ff       	jmp    101d5a <__alltraps>

00101f64 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $56
  101f66:	6a 38                	push   $0x38
  jmp __alltraps
  101f68:	e9 ed fd ff ff       	jmp    101d5a <__alltraps>

00101f6d <vector57>:
.globl vector57
vector57:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $57
  101f6f:	6a 39                	push   $0x39
  jmp __alltraps
  101f71:	e9 e4 fd ff ff       	jmp    101d5a <__alltraps>

00101f76 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $58
  101f78:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f7a:	e9 db fd ff ff       	jmp    101d5a <__alltraps>

00101f7f <vector59>:
.globl vector59
vector59:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $59
  101f81:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f83:	e9 d2 fd ff ff       	jmp    101d5a <__alltraps>

00101f88 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $60
  101f8a:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f8c:	e9 c9 fd ff ff       	jmp    101d5a <__alltraps>

00101f91 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $61
  101f93:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f95:	e9 c0 fd ff ff       	jmp    101d5a <__alltraps>

00101f9a <vector62>:
.globl vector62
vector62:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $62
  101f9c:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f9e:	e9 b7 fd ff ff       	jmp    101d5a <__alltraps>

00101fa3 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $63
  101fa5:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fa7:	e9 ae fd ff ff       	jmp    101d5a <__alltraps>

00101fac <vector64>:
.globl vector64
vector64:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $64
  101fae:	6a 40                	push   $0x40
  jmp __alltraps
  101fb0:	e9 a5 fd ff ff       	jmp    101d5a <__alltraps>

00101fb5 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $65
  101fb7:	6a 41                	push   $0x41
  jmp __alltraps
  101fb9:	e9 9c fd ff ff       	jmp    101d5a <__alltraps>

00101fbe <vector66>:
.globl vector66
vector66:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $66
  101fc0:	6a 42                	push   $0x42
  jmp __alltraps
  101fc2:	e9 93 fd ff ff       	jmp    101d5a <__alltraps>

00101fc7 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $67
  101fc9:	6a 43                	push   $0x43
  jmp __alltraps
  101fcb:	e9 8a fd ff ff       	jmp    101d5a <__alltraps>

00101fd0 <vector68>:
.globl vector68
vector68:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $68
  101fd2:	6a 44                	push   $0x44
  jmp __alltraps
  101fd4:	e9 81 fd ff ff       	jmp    101d5a <__alltraps>

00101fd9 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $69
  101fdb:	6a 45                	push   $0x45
  jmp __alltraps
  101fdd:	e9 78 fd ff ff       	jmp    101d5a <__alltraps>

00101fe2 <vector70>:
.globl vector70
vector70:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $70
  101fe4:	6a 46                	push   $0x46
  jmp __alltraps
  101fe6:	e9 6f fd ff ff       	jmp    101d5a <__alltraps>

00101feb <vector71>:
.globl vector71
vector71:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $71
  101fed:	6a 47                	push   $0x47
  jmp __alltraps
  101fef:	e9 66 fd ff ff       	jmp    101d5a <__alltraps>

00101ff4 <vector72>:
.globl vector72
vector72:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $72
  101ff6:	6a 48                	push   $0x48
  jmp __alltraps
  101ff8:	e9 5d fd ff ff       	jmp    101d5a <__alltraps>

00101ffd <vector73>:
.globl vector73
vector73:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $73
  101fff:	6a 49                	push   $0x49
  jmp __alltraps
  102001:	e9 54 fd ff ff       	jmp    101d5a <__alltraps>

00102006 <vector74>:
.globl vector74
vector74:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $74
  102008:	6a 4a                	push   $0x4a
  jmp __alltraps
  10200a:	e9 4b fd ff ff       	jmp    101d5a <__alltraps>

0010200f <vector75>:
.globl vector75
vector75:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $75
  102011:	6a 4b                	push   $0x4b
  jmp __alltraps
  102013:	e9 42 fd ff ff       	jmp    101d5a <__alltraps>

00102018 <vector76>:
.globl vector76
vector76:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $76
  10201a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10201c:	e9 39 fd ff ff       	jmp    101d5a <__alltraps>

00102021 <vector77>:
.globl vector77
vector77:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $77
  102023:	6a 4d                	push   $0x4d
  jmp __alltraps
  102025:	e9 30 fd ff ff       	jmp    101d5a <__alltraps>

0010202a <vector78>:
.globl vector78
vector78:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $78
  10202c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10202e:	e9 27 fd ff ff       	jmp    101d5a <__alltraps>

00102033 <vector79>:
.globl vector79
vector79:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $79
  102035:	6a 4f                	push   $0x4f
  jmp __alltraps
  102037:	e9 1e fd ff ff       	jmp    101d5a <__alltraps>

0010203c <vector80>:
.globl vector80
vector80:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $80
  10203e:	6a 50                	push   $0x50
  jmp __alltraps
  102040:	e9 15 fd ff ff       	jmp    101d5a <__alltraps>

00102045 <vector81>:
.globl vector81
vector81:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $81
  102047:	6a 51                	push   $0x51
  jmp __alltraps
  102049:	e9 0c fd ff ff       	jmp    101d5a <__alltraps>

0010204e <vector82>:
.globl vector82
vector82:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $82
  102050:	6a 52                	push   $0x52
  jmp __alltraps
  102052:	e9 03 fd ff ff       	jmp    101d5a <__alltraps>

00102057 <vector83>:
.globl vector83
vector83:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $83
  102059:	6a 53                	push   $0x53
  jmp __alltraps
  10205b:	e9 fa fc ff ff       	jmp    101d5a <__alltraps>

00102060 <vector84>:
.globl vector84
vector84:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $84
  102062:	6a 54                	push   $0x54
  jmp __alltraps
  102064:	e9 f1 fc ff ff       	jmp    101d5a <__alltraps>

00102069 <vector85>:
.globl vector85
vector85:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $85
  10206b:	6a 55                	push   $0x55
  jmp __alltraps
  10206d:	e9 e8 fc ff ff       	jmp    101d5a <__alltraps>

00102072 <vector86>:
.globl vector86
vector86:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $86
  102074:	6a 56                	push   $0x56
  jmp __alltraps
  102076:	e9 df fc ff ff       	jmp    101d5a <__alltraps>

0010207b <vector87>:
.globl vector87
vector87:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $87
  10207d:	6a 57                	push   $0x57
  jmp __alltraps
  10207f:	e9 d6 fc ff ff       	jmp    101d5a <__alltraps>

00102084 <vector88>:
.globl vector88
vector88:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $88
  102086:	6a 58                	push   $0x58
  jmp __alltraps
  102088:	e9 cd fc ff ff       	jmp    101d5a <__alltraps>

0010208d <vector89>:
.globl vector89
vector89:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $89
  10208f:	6a 59                	push   $0x59
  jmp __alltraps
  102091:	e9 c4 fc ff ff       	jmp    101d5a <__alltraps>

00102096 <vector90>:
.globl vector90
vector90:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $90
  102098:	6a 5a                	push   $0x5a
  jmp __alltraps
  10209a:	e9 bb fc ff ff       	jmp    101d5a <__alltraps>

0010209f <vector91>:
.globl vector91
vector91:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $91
  1020a1:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020a3:	e9 b2 fc ff ff       	jmp    101d5a <__alltraps>

001020a8 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $92
  1020aa:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020ac:	e9 a9 fc ff ff       	jmp    101d5a <__alltraps>

001020b1 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $93
  1020b3:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020b5:	e9 a0 fc ff ff       	jmp    101d5a <__alltraps>

001020ba <vector94>:
.globl vector94
vector94:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $94
  1020bc:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020be:	e9 97 fc ff ff       	jmp    101d5a <__alltraps>

001020c3 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $95
  1020c5:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020c7:	e9 8e fc ff ff       	jmp    101d5a <__alltraps>

001020cc <vector96>:
.globl vector96
vector96:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $96
  1020ce:	6a 60                	push   $0x60
  jmp __alltraps
  1020d0:	e9 85 fc ff ff       	jmp    101d5a <__alltraps>

001020d5 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $97
  1020d7:	6a 61                	push   $0x61
  jmp __alltraps
  1020d9:	e9 7c fc ff ff       	jmp    101d5a <__alltraps>

001020de <vector98>:
.globl vector98
vector98:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $98
  1020e0:	6a 62                	push   $0x62
  jmp __alltraps
  1020e2:	e9 73 fc ff ff       	jmp    101d5a <__alltraps>

001020e7 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $99
  1020e9:	6a 63                	push   $0x63
  jmp __alltraps
  1020eb:	e9 6a fc ff ff       	jmp    101d5a <__alltraps>

001020f0 <vector100>:
.globl vector100
vector100:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $100
  1020f2:	6a 64                	push   $0x64
  jmp __alltraps
  1020f4:	e9 61 fc ff ff       	jmp    101d5a <__alltraps>

001020f9 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $101
  1020fb:	6a 65                	push   $0x65
  jmp __alltraps
  1020fd:	e9 58 fc ff ff       	jmp    101d5a <__alltraps>

00102102 <vector102>:
.globl vector102
vector102:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $102
  102104:	6a 66                	push   $0x66
  jmp __alltraps
  102106:	e9 4f fc ff ff       	jmp    101d5a <__alltraps>

0010210b <vector103>:
.globl vector103
vector103:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $103
  10210d:	6a 67                	push   $0x67
  jmp __alltraps
  10210f:	e9 46 fc ff ff       	jmp    101d5a <__alltraps>

00102114 <vector104>:
.globl vector104
vector104:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $104
  102116:	6a 68                	push   $0x68
  jmp __alltraps
  102118:	e9 3d fc ff ff       	jmp    101d5a <__alltraps>

0010211d <vector105>:
.globl vector105
vector105:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $105
  10211f:	6a 69                	push   $0x69
  jmp __alltraps
  102121:	e9 34 fc ff ff       	jmp    101d5a <__alltraps>

00102126 <vector106>:
.globl vector106
vector106:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $106
  102128:	6a 6a                	push   $0x6a
  jmp __alltraps
  10212a:	e9 2b fc ff ff       	jmp    101d5a <__alltraps>

0010212f <vector107>:
.globl vector107
vector107:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $107
  102131:	6a 6b                	push   $0x6b
  jmp __alltraps
  102133:	e9 22 fc ff ff       	jmp    101d5a <__alltraps>

00102138 <vector108>:
.globl vector108
vector108:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $108
  10213a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10213c:	e9 19 fc ff ff       	jmp    101d5a <__alltraps>

00102141 <vector109>:
.globl vector109
vector109:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $109
  102143:	6a 6d                	push   $0x6d
  jmp __alltraps
  102145:	e9 10 fc ff ff       	jmp    101d5a <__alltraps>

0010214a <vector110>:
.globl vector110
vector110:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $110
  10214c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10214e:	e9 07 fc ff ff       	jmp    101d5a <__alltraps>

00102153 <vector111>:
.globl vector111
vector111:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $111
  102155:	6a 6f                	push   $0x6f
  jmp __alltraps
  102157:	e9 fe fb ff ff       	jmp    101d5a <__alltraps>

0010215c <vector112>:
.globl vector112
vector112:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $112
  10215e:	6a 70                	push   $0x70
  jmp __alltraps
  102160:	e9 f5 fb ff ff       	jmp    101d5a <__alltraps>

00102165 <vector113>:
.globl vector113
vector113:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $113
  102167:	6a 71                	push   $0x71
  jmp __alltraps
  102169:	e9 ec fb ff ff       	jmp    101d5a <__alltraps>

0010216e <vector114>:
.globl vector114
vector114:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $114
  102170:	6a 72                	push   $0x72
  jmp __alltraps
  102172:	e9 e3 fb ff ff       	jmp    101d5a <__alltraps>

00102177 <vector115>:
.globl vector115
vector115:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $115
  102179:	6a 73                	push   $0x73
  jmp __alltraps
  10217b:	e9 da fb ff ff       	jmp    101d5a <__alltraps>

00102180 <vector116>:
.globl vector116
vector116:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $116
  102182:	6a 74                	push   $0x74
  jmp __alltraps
  102184:	e9 d1 fb ff ff       	jmp    101d5a <__alltraps>

00102189 <vector117>:
.globl vector117
vector117:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $117
  10218b:	6a 75                	push   $0x75
  jmp __alltraps
  10218d:	e9 c8 fb ff ff       	jmp    101d5a <__alltraps>

00102192 <vector118>:
.globl vector118
vector118:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $118
  102194:	6a 76                	push   $0x76
  jmp __alltraps
  102196:	e9 bf fb ff ff       	jmp    101d5a <__alltraps>

0010219b <vector119>:
.globl vector119
vector119:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $119
  10219d:	6a 77                	push   $0x77
  jmp __alltraps
  10219f:	e9 b6 fb ff ff       	jmp    101d5a <__alltraps>

001021a4 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $120
  1021a6:	6a 78                	push   $0x78
  jmp __alltraps
  1021a8:	e9 ad fb ff ff       	jmp    101d5a <__alltraps>

001021ad <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $121
  1021af:	6a 79                	push   $0x79
  jmp __alltraps
  1021b1:	e9 a4 fb ff ff       	jmp    101d5a <__alltraps>

001021b6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $122
  1021b8:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021ba:	e9 9b fb ff ff       	jmp    101d5a <__alltraps>

001021bf <vector123>:
.globl vector123
vector123:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $123
  1021c1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021c3:	e9 92 fb ff ff       	jmp    101d5a <__alltraps>

001021c8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $124
  1021ca:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021cc:	e9 89 fb ff ff       	jmp    101d5a <__alltraps>

001021d1 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $125
  1021d3:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021d5:	e9 80 fb ff ff       	jmp    101d5a <__alltraps>

001021da <vector126>:
.globl vector126
vector126:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $126
  1021dc:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021de:	e9 77 fb ff ff       	jmp    101d5a <__alltraps>

001021e3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $127
  1021e5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021e7:	e9 6e fb ff ff       	jmp    101d5a <__alltraps>

001021ec <vector128>:
.globl vector128
vector128:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $128
  1021ee:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021f3:	e9 62 fb ff ff       	jmp    101d5a <__alltraps>

001021f8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $129
  1021fa:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021ff:	e9 56 fb ff ff       	jmp    101d5a <__alltraps>

00102204 <vector130>:
.globl vector130
vector130:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $130
  102206:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10220b:	e9 4a fb ff ff       	jmp    101d5a <__alltraps>

00102210 <vector131>:
.globl vector131
vector131:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $131
  102212:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102217:	e9 3e fb ff ff       	jmp    101d5a <__alltraps>

0010221c <vector132>:
.globl vector132
vector132:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $132
  10221e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102223:	e9 32 fb ff ff       	jmp    101d5a <__alltraps>

00102228 <vector133>:
.globl vector133
vector133:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $133
  10222a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10222f:	e9 26 fb ff ff       	jmp    101d5a <__alltraps>

00102234 <vector134>:
.globl vector134
vector134:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $134
  102236:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10223b:	e9 1a fb ff ff       	jmp    101d5a <__alltraps>

00102240 <vector135>:
.globl vector135
vector135:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $135
  102242:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102247:	e9 0e fb ff ff       	jmp    101d5a <__alltraps>

0010224c <vector136>:
.globl vector136
vector136:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $136
  10224e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102253:	e9 02 fb ff ff       	jmp    101d5a <__alltraps>

00102258 <vector137>:
.globl vector137
vector137:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $137
  10225a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10225f:	e9 f6 fa ff ff       	jmp    101d5a <__alltraps>

00102264 <vector138>:
.globl vector138
vector138:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $138
  102266:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10226b:	e9 ea fa ff ff       	jmp    101d5a <__alltraps>

00102270 <vector139>:
.globl vector139
vector139:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $139
  102272:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102277:	e9 de fa ff ff       	jmp    101d5a <__alltraps>

0010227c <vector140>:
.globl vector140
vector140:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $140
  10227e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102283:	e9 d2 fa ff ff       	jmp    101d5a <__alltraps>

00102288 <vector141>:
.globl vector141
vector141:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $141
  10228a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10228f:	e9 c6 fa ff ff       	jmp    101d5a <__alltraps>

00102294 <vector142>:
.globl vector142
vector142:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $142
  102296:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10229b:	e9 ba fa ff ff       	jmp    101d5a <__alltraps>

001022a0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $143
  1022a2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022a7:	e9 ae fa ff ff       	jmp    101d5a <__alltraps>

001022ac <vector144>:
.globl vector144
vector144:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $144
  1022ae:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022b3:	e9 a2 fa ff ff       	jmp    101d5a <__alltraps>

001022b8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $145
  1022ba:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022bf:	e9 96 fa ff ff       	jmp    101d5a <__alltraps>

001022c4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $146
  1022c6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022cb:	e9 8a fa ff ff       	jmp    101d5a <__alltraps>

001022d0 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $147
  1022d2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022d7:	e9 7e fa ff ff       	jmp    101d5a <__alltraps>

001022dc <vector148>:
.globl vector148
vector148:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $148
  1022de:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022e3:	e9 72 fa ff ff       	jmp    101d5a <__alltraps>

001022e8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $149
  1022ea:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022ef:	e9 66 fa ff ff       	jmp    101d5a <__alltraps>

001022f4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $150
  1022f6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022fb:	e9 5a fa ff ff       	jmp    101d5a <__alltraps>

00102300 <vector151>:
.globl vector151
vector151:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $151
  102302:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102307:	e9 4e fa ff ff       	jmp    101d5a <__alltraps>

0010230c <vector152>:
.globl vector152
vector152:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $152
  10230e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102313:	e9 42 fa ff ff       	jmp    101d5a <__alltraps>

00102318 <vector153>:
.globl vector153
vector153:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $153
  10231a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10231f:	e9 36 fa ff ff       	jmp    101d5a <__alltraps>

00102324 <vector154>:
.globl vector154
vector154:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $154
  102326:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10232b:	e9 2a fa ff ff       	jmp    101d5a <__alltraps>

00102330 <vector155>:
.globl vector155
vector155:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $155
  102332:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102337:	e9 1e fa ff ff       	jmp    101d5a <__alltraps>

0010233c <vector156>:
.globl vector156
vector156:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $156
  10233e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102343:	e9 12 fa ff ff       	jmp    101d5a <__alltraps>

00102348 <vector157>:
.globl vector157
vector157:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $157
  10234a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10234f:	e9 06 fa ff ff       	jmp    101d5a <__alltraps>

00102354 <vector158>:
.globl vector158
vector158:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $158
  102356:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10235b:	e9 fa f9 ff ff       	jmp    101d5a <__alltraps>

00102360 <vector159>:
.globl vector159
vector159:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $159
  102362:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102367:	e9 ee f9 ff ff       	jmp    101d5a <__alltraps>

0010236c <vector160>:
.globl vector160
vector160:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $160
  10236e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102373:	e9 e2 f9 ff ff       	jmp    101d5a <__alltraps>

00102378 <vector161>:
.globl vector161
vector161:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $161
  10237a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10237f:	e9 d6 f9 ff ff       	jmp    101d5a <__alltraps>

00102384 <vector162>:
.globl vector162
vector162:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $162
  102386:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10238b:	e9 ca f9 ff ff       	jmp    101d5a <__alltraps>

00102390 <vector163>:
.globl vector163
vector163:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $163
  102392:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102397:	e9 be f9 ff ff       	jmp    101d5a <__alltraps>

0010239c <vector164>:
.globl vector164
vector164:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $164
  10239e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023a3:	e9 b2 f9 ff ff       	jmp    101d5a <__alltraps>

001023a8 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $165
  1023aa:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023af:	e9 a6 f9 ff ff       	jmp    101d5a <__alltraps>

001023b4 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $166
  1023b6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023bb:	e9 9a f9 ff ff       	jmp    101d5a <__alltraps>

001023c0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $167
  1023c2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023c7:	e9 8e f9 ff ff       	jmp    101d5a <__alltraps>

001023cc <vector168>:
.globl vector168
vector168:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $168
  1023ce:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023d3:	e9 82 f9 ff ff       	jmp    101d5a <__alltraps>

001023d8 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $169
  1023da:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023df:	e9 76 f9 ff ff       	jmp    101d5a <__alltraps>

001023e4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $170
  1023e6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023eb:	e9 6a f9 ff ff       	jmp    101d5a <__alltraps>

001023f0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $171
  1023f2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023f7:	e9 5e f9 ff ff       	jmp    101d5a <__alltraps>

001023fc <vector172>:
.globl vector172
vector172:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $172
  1023fe:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102403:	e9 52 f9 ff ff       	jmp    101d5a <__alltraps>

00102408 <vector173>:
.globl vector173
vector173:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $173
  10240a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10240f:	e9 46 f9 ff ff       	jmp    101d5a <__alltraps>

00102414 <vector174>:
.globl vector174
vector174:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $174
  102416:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10241b:	e9 3a f9 ff ff       	jmp    101d5a <__alltraps>

00102420 <vector175>:
.globl vector175
vector175:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $175
  102422:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102427:	e9 2e f9 ff ff       	jmp    101d5a <__alltraps>

0010242c <vector176>:
.globl vector176
vector176:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $176
  10242e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102433:	e9 22 f9 ff ff       	jmp    101d5a <__alltraps>

00102438 <vector177>:
.globl vector177
vector177:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $177
  10243a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10243f:	e9 16 f9 ff ff       	jmp    101d5a <__alltraps>

00102444 <vector178>:
.globl vector178
vector178:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $178
  102446:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10244b:	e9 0a f9 ff ff       	jmp    101d5a <__alltraps>

00102450 <vector179>:
.globl vector179
vector179:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $179
  102452:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102457:	e9 fe f8 ff ff       	jmp    101d5a <__alltraps>

0010245c <vector180>:
.globl vector180
vector180:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $180
  10245e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102463:	e9 f2 f8 ff ff       	jmp    101d5a <__alltraps>

00102468 <vector181>:
.globl vector181
vector181:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $181
  10246a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10246f:	e9 e6 f8 ff ff       	jmp    101d5a <__alltraps>

00102474 <vector182>:
.globl vector182
vector182:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $182
  102476:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10247b:	e9 da f8 ff ff       	jmp    101d5a <__alltraps>

00102480 <vector183>:
.globl vector183
vector183:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $183
  102482:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102487:	e9 ce f8 ff ff       	jmp    101d5a <__alltraps>

0010248c <vector184>:
.globl vector184
vector184:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $184
  10248e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102493:	e9 c2 f8 ff ff       	jmp    101d5a <__alltraps>

00102498 <vector185>:
.globl vector185
vector185:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $185
  10249a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10249f:	e9 b6 f8 ff ff       	jmp    101d5a <__alltraps>

001024a4 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $186
  1024a6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ab:	e9 aa f8 ff ff       	jmp    101d5a <__alltraps>

001024b0 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $187
  1024b2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024b7:	e9 9e f8 ff ff       	jmp    101d5a <__alltraps>

001024bc <vector188>:
.globl vector188
vector188:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $188
  1024be:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024c3:	e9 92 f8 ff ff       	jmp    101d5a <__alltraps>

001024c8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $189
  1024ca:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024cf:	e9 86 f8 ff ff       	jmp    101d5a <__alltraps>

001024d4 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $190
  1024d6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024db:	e9 7a f8 ff ff       	jmp    101d5a <__alltraps>

001024e0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $191
  1024e2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024e7:	e9 6e f8 ff ff       	jmp    101d5a <__alltraps>

001024ec <vector192>:
.globl vector192
vector192:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $192
  1024ee:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024f3:	e9 62 f8 ff ff       	jmp    101d5a <__alltraps>

001024f8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $193
  1024fa:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024ff:	e9 56 f8 ff ff       	jmp    101d5a <__alltraps>

00102504 <vector194>:
.globl vector194
vector194:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $194
  102506:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10250b:	e9 4a f8 ff ff       	jmp    101d5a <__alltraps>

00102510 <vector195>:
.globl vector195
vector195:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $195
  102512:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102517:	e9 3e f8 ff ff       	jmp    101d5a <__alltraps>

0010251c <vector196>:
.globl vector196
vector196:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $196
  10251e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102523:	e9 32 f8 ff ff       	jmp    101d5a <__alltraps>

00102528 <vector197>:
.globl vector197
vector197:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $197
  10252a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10252f:	e9 26 f8 ff ff       	jmp    101d5a <__alltraps>

00102534 <vector198>:
.globl vector198
vector198:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $198
  102536:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10253b:	e9 1a f8 ff ff       	jmp    101d5a <__alltraps>

00102540 <vector199>:
.globl vector199
vector199:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $199
  102542:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102547:	e9 0e f8 ff ff       	jmp    101d5a <__alltraps>

0010254c <vector200>:
.globl vector200
vector200:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $200
  10254e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102553:	e9 02 f8 ff ff       	jmp    101d5a <__alltraps>

00102558 <vector201>:
.globl vector201
vector201:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $201
  10255a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10255f:	e9 f6 f7 ff ff       	jmp    101d5a <__alltraps>

00102564 <vector202>:
.globl vector202
vector202:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $202
  102566:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10256b:	e9 ea f7 ff ff       	jmp    101d5a <__alltraps>

00102570 <vector203>:
.globl vector203
vector203:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $203
  102572:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102577:	e9 de f7 ff ff       	jmp    101d5a <__alltraps>

0010257c <vector204>:
.globl vector204
vector204:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $204
  10257e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102583:	e9 d2 f7 ff ff       	jmp    101d5a <__alltraps>

00102588 <vector205>:
.globl vector205
vector205:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $205
  10258a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10258f:	e9 c6 f7 ff ff       	jmp    101d5a <__alltraps>

00102594 <vector206>:
.globl vector206
vector206:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $206
  102596:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10259b:	e9 ba f7 ff ff       	jmp    101d5a <__alltraps>

001025a0 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $207
  1025a2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025a7:	e9 ae f7 ff ff       	jmp    101d5a <__alltraps>

001025ac <vector208>:
.globl vector208
vector208:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $208
  1025ae:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025b3:	e9 a2 f7 ff ff       	jmp    101d5a <__alltraps>

001025b8 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $209
  1025ba:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025bf:	e9 96 f7 ff ff       	jmp    101d5a <__alltraps>

001025c4 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $210
  1025c6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025cb:	e9 8a f7 ff ff       	jmp    101d5a <__alltraps>

001025d0 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $211
  1025d2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025d7:	e9 7e f7 ff ff       	jmp    101d5a <__alltraps>

001025dc <vector212>:
.globl vector212
vector212:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $212
  1025de:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025e3:	e9 72 f7 ff ff       	jmp    101d5a <__alltraps>

001025e8 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $213
  1025ea:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025ef:	e9 66 f7 ff ff       	jmp    101d5a <__alltraps>

001025f4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $214
  1025f6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025fb:	e9 5a f7 ff ff       	jmp    101d5a <__alltraps>

00102600 <vector215>:
.globl vector215
vector215:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $215
  102602:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102607:	e9 4e f7 ff ff       	jmp    101d5a <__alltraps>

0010260c <vector216>:
.globl vector216
vector216:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $216
  10260e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102613:	e9 42 f7 ff ff       	jmp    101d5a <__alltraps>

00102618 <vector217>:
.globl vector217
vector217:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $217
  10261a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10261f:	e9 36 f7 ff ff       	jmp    101d5a <__alltraps>

00102624 <vector218>:
.globl vector218
vector218:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $218
  102626:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10262b:	e9 2a f7 ff ff       	jmp    101d5a <__alltraps>

00102630 <vector219>:
.globl vector219
vector219:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $219
  102632:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102637:	e9 1e f7 ff ff       	jmp    101d5a <__alltraps>

0010263c <vector220>:
.globl vector220
vector220:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $220
  10263e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102643:	e9 12 f7 ff ff       	jmp    101d5a <__alltraps>

00102648 <vector221>:
.globl vector221
vector221:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $221
  10264a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10264f:	e9 06 f7 ff ff       	jmp    101d5a <__alltraps>

00102654 <vector222>:
.globl vector222
vector222:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $222
  102656:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10265b:	e9 fa f6 ff ff       	jmp    101d5a <__alltraps>

00102660 <vector223>:
.globl vector223
vector223:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $223
  102662:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102667:	e9 ee f6 ff ff       	jmp    101d5a <__alltraps>

0010266c <vector224>:
.globl vector224
vector224:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $224
  10266e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102673:	e9 e2 f6 ff ff       	jmp    101d5a <__alltraps>

00102678 <vector225>:
.globl vector225
vector225:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $225
  10267a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10267f:	e9 d6 f6 ff ff       	jmp    101d5a <__alltraps>

00102684 <vector226>:
.globl vector226
vector226:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $226
  102686:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10268b:	e9 ca f6 ff ff       	jmp    101d5a <__alltraps>

00102690 <vector227>:
.globl vector227
vector227:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $227
  102692:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102697:	e9 be f6 ff ff       	jmp    101d5a <__alltraps>

0010269c <vector228>:
.globl vector228
vector228:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $228
  10269e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026a3:	e9 b2 f6 ff ff       	jmp    101d5a <__alltraps>

001026a8 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $229
  1026aa:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026af:	e9 a6 f6 ff ff       	jmp    101d5a <__alltraps>

001026b4 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $230
  1026b6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026bb:	e9 9a f6 ff ff       	jmp    101d5a <__alltraps>

001026c0 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $231
  1026c2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026c7:	e9 8e f6 ff ff       	jmp    101d5a <__alltraps>

001026cc <vector232>:
.globl vector232
vector232:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $232
  1026ce:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026d3:	e9 82 f6 ff ff       	jmp    101d5a <__alltraps>

001026d8 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $233
  1026da:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026df:	e9 76 f6 ff ff       	jmp    101d5a <__alltraps>

001026e4 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $234
  1026e6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026eb:	e9 6a f6 ff ff       	jmp    101d5a <__alltraps>

001026f0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $235
  1026f2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026f7:	e9 5e f6 ff ff       	jmp    101d5a <__alltraps>

001026fc <vector236>:
.globl vector236
vector236:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $236
  1026fe:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102703:	e9 52 f6 ff ff       	jmp    101d5a <__alltraps>

00102708 <vector237>:
.globl vector237
vector237:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $237
  10270a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10270f:	e9 46 f6 ff ff       	jmp    101d5a <__alltraps>

00102714 <vector238>:
.globl vector238
vector238:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $238
  102716:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10271b:	e9 3a f6 ff ff       	jmp    101d5a <__alltraps>

00102720 <vector239>:
.globl vector239
vector239:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $239
  102722:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102727:	e9 2e f6 ff ff       	jmp    101d5a <__alltraps>

0010272c <vector240>:
.globl vector240
vector240:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $240
  10272e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102733:	e9 22 f6 ff ff       	jmp    101d5a <__alltraps>

00102738 <vector241>:
.globl vector241
vector241:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $241
  10273a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10273f:	e9 16 f6 ff ff       	jmp    101d5a <__alltraps>

00102744 <vector242>:
.globl vector242
vector242:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $242
  102746:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10274b:	e9 0a f6 ff ff       	jmp    101d5a <__alltraps>

00102750 <vector243>:
.globl vector243
vector243:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $243
  102752:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102757:	e9 fe f5 ff ff       	jmp    101d5a <__alltraps>

0010275c <vector244>:
.globl vector244
vector244:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $244
  10275e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102763:	e9 f2 f5 ff ff       	jmp    101d5a <__alltraps>

00102768 <vector245>:
.globl vector245
vector245:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $245
  10276a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10276f:	e9 e6 f5 ff ff       	jmp    101d5a <__alltraps>

00102774 <vector246>:
.globl vector246
vector246:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $246
  102776:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10277b:	e9 da f5 ff ff       	jmp    101d5a <__alltraps>

00102780 <vector247>:
.globl vector247
vector247:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $247
  102782:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102787:	e9 ce f5 ff ff       	jmp    101d5a <__alltraps>

0010278c <vector248>:
.globl vector248
vector248:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $248
  10278e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102793:	e9 c2 f5 ff ff       	jmp    101d5a <__alltraps>

00102798 <vector249>:
.globl vector249
vector249:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $249
  10279a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10279f:	e9 b6 f5 ff ff       	jmp    101d5a <__alltraps>

001027a4 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $250
  1027a6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ab:	e9 aa f5 ff ff       	jmp    101d5a <__alltraps>

001027b0 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $251
  1027b2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027b7:	e9 9e f5 ff ff       	jmp    101d5a <__alltraps>

001027bc <vector252>:
.globl vector252
vector252:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $252
  1027be:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027c3:	e9 92 f5 ff ff       	jmp    101d5a <__alltraps>

001027c8 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $253
  1027ca:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027cf:	e9 86 f5 ff ff       	jmp    101d5a <__alltraps>

001027d4 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $254
  1027d6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027db:	e9 7a f5 ff ff       	jmp    101d5a <__alltraps>

001027e0 <vector255>:
.globl vector255
vector255:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $255
  1027e2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027e7:	e9 6e f5 ff ff       	jmp    101d5a <__alltraps>

001027ec <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027ec:	55                   	push   %ebp
  1027ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1027f2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027f5:	b8 23 00 00 00       	mov    $0x23,%eax
  1027fa:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027fc:	b8 23 00 00 00       	mov    $0x23,%eax
  102801:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102803:	b8 10 00 00 00       	mov    $0x10,%eax
  102808:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10280a:	b8 10 00 00 00       	mov    $0x10,%eax
  10280f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102811:	b8 10 00 00 00       	mov    $0x10,%eax
  102816:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102818:	ea 1f 28 10 00 08 00 	ljmp   $0x8,$0x10281f
}
  10281f:	5d                   	pop    %ebp
  102820:	c3                   	ret    

00102821 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102821:	55                   	push   %ebp
  102822:	89 e5                	mov    %esp,%ebp
  102824:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102827:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10282c:	05 00 04 00 00       	add    $0x400,%eax
  102831:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102836:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10283d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10283f:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102846:	68 00 
  102848:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10284d:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102853:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102858:	c1 e8 10             	shr    $0x10,%eax
  10285b:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102860:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102867:	83 e0 f0             	and    $0xfffffff0,%eax
  10286a:	83 c8 09             	or     $0x9,%eax
  10286d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102872:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102879:	83 c8 10             	or     $0x10,%eax
  10287c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102881:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102888:	83 e0 9f             	and    $0xffffff9f,%eax
  10288b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102890:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102897:	83 c8 80             	or     $0xffffff80,%eax
  10289a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028a6:	83 e0 f0             	and    $0xfffffff0,%eax
  1028a9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ae:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028b5:	83 e0 ef             	and    $0xffffffef,%eax
  1028b8:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028bd:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c4:	83 e0 df             	and    $0xffffffdf,%eax
  1028c7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028cc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d3:	83 c8 40             	or     $0x40,%eax
  1028d6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028db:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e2:	83 e0 7f             	and    $0x7f,%eax
  1028e5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ea:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028ef:	c1 e8 18             	shr    $0x18,%eax
  1028f2:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028f7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028fe:	83 e0 ef             	and    $0xffffffef,%eax
  102901:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102906:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10290d:	e8 da fe ff ff       	call   1027ec <lgdt>
  102912:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102918:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10291c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10291f:	c9                   	leave  
  102920:	c3                   	ret    

00102921 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102921:	55                   	push   %ebp
  102922:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102924:	e8 f8 fe ff ff       	call   102821 <gdt_init>
}
  102929:	5d                   	pop    %ebp
  10292a:	c3                   	ret    

0010292b <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10292b:	55                   	push   %ebp
  10292c:	89 e5                	mov    %esp,%ebp
  10292e:	83 ec 58             	sub    $0x58,%esp
  102931:	8b 45 10             	mov    0x10(%ebp),%eax
  102934:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102937:	8b 45 14             	mov    0x14(%ebp),%eax
  10293a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10293d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102940:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102943:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102946:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102949:	8b 45 18             	mov    0x18(%ebp),%eax
  10294c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10294f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102952:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102955:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102958:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10295e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102961:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102965:	74 1c                	je     102983 <printnum+0x58>
  102967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10296a:	ba 00 00 00 00       	mov    $0x0,%edx
  10296f:	f7 75 e4             	divl   -0x1c(%ebp)
  102972:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102978:	ba 00 00 00 00       	mov    $0x0,%edx
  10297d:	f7 75 e4             	divl   -0x1c(%ebp)
  102980:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102989:	f7 75 e4             	divl   -0x1c(%ebp)
  10298c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10298f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102992:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102995:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102998:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10299b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10299e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029a1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029a4:	8b 45 18             	mov    0x18(%ebp),%eax
  1029a7:	ba 00 00 00 00       	mov    $0x0,%edx
  1029ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029af:	77 56                	ja     102a07 <printnum+0xdc>
  1029b1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029b4:	72 05                	jb     1029bb <printnum+0x90>
  1029b6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029b9:	77 4c                	ja     102a07 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029c1:	8b 45 20             	mov    0x20(%ebp),%eax
  1029c4:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029c8:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029cc:	8b 45 18             	mov    0x18(%ebp),%eax
  1029cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029eb:	89 04 24             	mov    %eax,(%esp)
  1029ee:	e8 38 ff ff ff       	call   10292b <printnum>
  1029f3:	eb 1c                	jmp    102a11 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029fc:	8b 45 20             	mov    0x20(%ebp),%eax
  1029ff:	89 04 24             	mov    %eax,(%esp)
  102a02:	8b 45 08             	mov    0x8(%ebp),%eax
  102a05:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a07:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a0b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a0f:	7f e4                	jg     1029f5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a14:	05 10 3c 10 00       	add    $0x103c10,%eax
  102a19:	0f b6 00             	movzbl (%eax),%eax
  102a1c:	0f be c0             	movsbl %al,%eax
  102a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a22:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a26:	89 04 24             	mov    %eax,(%esp)
  102a29:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2c:	ff d0                	call   *%eax
}
  102a2e:	c9                   	leave  
  102a2f:	c3                   	ret    

00102a30 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a30:	55                   	push   %ebp
  102a31:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a37:	7e 14                	jle    102a4d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a39:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3c:	8b 00                	mov    (%eax),%eax
  102a3e:	8d 48 08             	lea    0x8(%eax),%ecx
  102a41:	8b 55 08             	mov    0x8(%ebp),%edx
  102a44:	89 0a                	mov    %ecx,(%edx)
  102a46:	8b 50 04             	mov    0x4(%eax),%edx
  102a49:	8b 00                	mov    (%eax),%eax
  102a4b:	eb 30                	jmp    102a7d <getuint+0x4d>
    }
    else if (lflag) {
  102a4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a51:	74 16                	je     102a69 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a53:	8b 45 08             	mov    0x8(%ebp),%eax
  102a56:	8b 00                	mov    (%eax),%eax
  102a58:	8d 48 04             	lea    0x4(%eax),%ecx
  102a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  102a5e:	89 0a                	mov    %ecx,(%edx)
  102a60:	8b 00                	mov    (%eax),%eax
  102a62:	ba 00 00 00 00       	mov    $0x0,%edx
  102a67:	eb 14                	jmp    102a7d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a69:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6c:	8b 00                	mov    (%eax),%eax
  102a6e:	8d 48 04             	lea    0x4(%eax),%ecx
  102a71:	8b 55 08             	mov    0x8(%ebp),%edx
  102a74:	89 0a                	mov    %ecx,(%edx)
  102a76:	8b 00                	mov    (%eax),%eax
  102a78:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a7d:	5d                   	pop    %ebp
  102a7e:	c3                   	ret    

00102a7f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a7f:	55                   	push   %ebp
  102a80:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a82:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a86:	7e 14                	jle    102a9c <getint+0x1d>
        return va_arg(*ap, long long);
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	8b 00                	mov    (%eax),%eax
  102a8d:	8d 48 08             	lea    0x8(%eax),%ecx
  102a90:	8b 55 08             	mov    0x8(%ebp),%edx
  102a93:	89 0a                	mov    %ecx,(%edx)
  102a95:	8b 50 04             	mov    0x4(%eax),%edx
  102a98:	8b 00                	mov    (%eax),%eax
  102a9a:	eb 28                	jmp    102ac4 <getint+0x45>
    }
    else if (lflag) {
  102a9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102aa0:	74 12                	je     102ab4 <getint+0x35>
        return va_arg(*ap, long);
  102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa5:	8b 00                	mov    (%eax),%eax
  102aa7:	8d 48 04             	lea    0x4(%eax),%ecx
  102aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  102aad:	89 0a                	mov    %ecx,(%edx)
  102aaf:	8b 00                	mov    (%eax),%eax
  102ab1:	99                   	cltd   
  102ab2:	eb 10                	jmp    102ac4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab7:	8b 00                	mov    (%eax),%eax
  102ab9:	8d 48 04             	lea    0x4(%eax),%ecx
  102abc:	8b 55 08             	mov    0x8(%ebp),%edx
  102abf:	89 0a                	mov    %ecx,(%edx)
  102ac1:	8b 00                	mov    (%eax),%eax
  102ac3:	99                   	cltd   
    }
}
  102ac4:	5d                   	pop    %ebp
  102ac5:	c3                   	ret    

00102ac6 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ac6:	55                   	push   %ebp
  102ac7:	89 e5                	mov    %esp,%ebp
  102ac9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102acc:	8d 45 14             	lea    0x14(%ebp),%eax
  102acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ad5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  102adc:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aea:	89 04 24             	mov    %eax,(%esp)
  102aed:	e8 02 00 00 00       	call   102af4 <vprintfmt>
    va_end(ap);
}
  102af2:	c9                   	leave  
  102af3:	c3                   	ret    

00102af4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102af4:	55                   	push   %ebp
  102af5:	89 e5                	mov    %esp,%ebp
  102af7:	56                   	push   %esi
  102af8:	53                   	push   %ebx
  102af9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102afc:	eb 18                	jmp    102b16 <vprintfmt+0x22>
            if (ch == '\0') {
  102afe:	85 db                	test   %ebx,%ebx
  102b00:	75 05                	jne    102b07 <vprintfmt+0x13>
                return;
  102b02:	e9 d1 03 00 00       	jmp    102ed8 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b0e:	89 1c 24             	mov    %ebx,(%esp)
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b16:	8b 45 10             	mov    0x10(%ebp),%eax
  102b19:	8d 50 01             	lea    0x1(%eax),%edx
  102b1c:	89 55 10             	mov    %edx,0x10(%ebp)
  102b1f:	0f b6 00             	movzbl (%eax),%eax
  102b22:	0f b6 d8             	movzbl %al,%ebx
  102b25:	83 fb 25             	cmp    $0x25,%ebx
  102b28:	75 d4                	jne    102afe <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b2a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b2e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b38:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b45:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b48:	8b 45 10             	mov    0x10(%ebp),%eax
  102b4b:	8d 50 01             	lea    0x1(%eax),%edx
  102b4e:	89 55 10             	mov    %edx,0x10(%ebp)
  102b51:	0f b6 00             	movzbl (%eax),%eax
  102b54:	0f b6 d8             	movzbl %al,%ebx
  102b57:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b5a:	83 f8 55             	cmp    $0x55,%eax
  102b5d:	0f 87 44 03 00 00    	ja     102ea7 <vprintfmt+0x3b3>
  102b63:	8b 04 85 34 3c 10 00 	mov    0x103c34(,%eax,4),%eax
  102b6a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b6c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b70:	eb d6                	jmp    102b48 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b72:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b76:	eb d0                	jmp    102b48 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b82:	89 d0                	mov    %edx,%eax
  102b84:	c1 e0 02             	shl    $0x2,%eax
  102b87:	01 d0                	add    %edx,%eax
  102b89:	01 c0                	add    %eax,%eax
  102b8b:	01 d8                	add    %ebx,%eax
  102b8d:	83 e8 30             	sub    $0x30,%eax
  102b90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102b93:	8b 45 10             	mov    0x10(%ebp),%eax
  102b96:	0f b6 00             	movzbl (%eax),%eax
  102b99:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102b9c:	83 fb 2f             	cmp    $0x2f,%ebx
  102b9f:	7e 0b                	jle    102bac <vprintfmt+0xb8>
  102ba1:	83 fb 39             	cmp    $0x39,%ebx
  102ba4:	7f 06                	jg     102bac <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ba6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102baa:	eb d3                	jmp    102b7f <vprintfmt+0x8b>
            goto process_precision;
  102bac:	eb 33                	jmp    102be1 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bae:	8b 45 14             	mov    0x14(%ebp),%eax
  102bb1:	8d 50 04             	lea    0x4(%eax),%edx
  102bb4:	89 55 14             	mov    %edx,0x14(%ebp)
  102bb7:	8b 00                	mov    (%eax),%eax
  102bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bbc:	eb 23                	jmp    102be1 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bbe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bc2:	79 0c                	jns    102bd0 <vprintfmt+0xdc>
                width = 0;
  102bc4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bcb:	e9 78 ff ff ff       	jmp    102b48 <vprintfmt+0x54>
  102bd0:	e9 73 ff ff ff       	jmp    102b48 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bd5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bdc:	e9 67 ff ff ff       	jmp    102b48 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102be1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102be5:	79 12                	jns    102bf9 <vprintfmt+0x105>
                width = precision, precision = -1;
  102be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102bf4:	e9 4f ff ff ff       	jmp    102b48 <vprintfmt+0x54>
  102bf9:	e9 4a ff ff ff       	jmp    102b48 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102bfe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c02:	e9 41 ff ff ff       	jmp    102b48 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c07:	8b 45 14             	mov    0x14(%ebp),%eax
  102c0a:	8d 50 04             	lea    0x4(%eax),%edx
  102c0d:	89 55 14             	mov    %edx,0x14(%ebp)
  102c10:	8b 00                	mov    (%eax),%eax
  102c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c15:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c19:	89 04 24             	mov    %eax,(%esp)
  102c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1f:	ff d0                	call   *%eax
            break;
  102c21:	e9 ac 02 00 00       	jmp    102ed2 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c26:	8b 45 14             	mov    0x14(%ebp),%eax
  102c29:	8d 50 04             	lea    0x4(%eax),%edx
  102c2c:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c31:	85 db                	test   %ebx,%ebx
  102c33:	79 02                	jns    102c37 <vprintfmt+0x143>
                err = -err;
  102c35:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c37:	83 fb 06             	cmp    $0x6,%ebx
  102c3a:	7f 0b                	jg     102c47 <vprintfmt+0x153>
  102c3c:	8b 34 9d f4 3b 10 00 	mov    0x103bf4(,%ebx,4),%esi
  102c43:	85 f6                	test   %esi,%esi
  102c45:	75 23                	jne    102c6a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c47:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c4b:	c7 44 24 08 21 3c 10 	movl   $0x103c21,0x8(%esp)
  102c52:	00 
  102c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5d:	89 04 24             	mov    %eax,(%esp)
  102c60:	e8 61 fe ff ff       	call   102ac6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c65:	e9 68 02 00 00       	jmp    102ed2 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c6a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c6e:	c7 44 24 08 2a 3c 10 	movl   $0x103c2a,0x8(%esp)
  102c75:	00 
  102c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c80:	89 04 24             	mov    %eax,(%esp)
  102c83:	e8 3e fe ff ff       	call   102ac6 <printfmt>
            }
            break;
  102c88:	e9 45 02 00 00       	jmp    102ed2 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  102c90:	8d 50 04             	lea    0x4(%eax),%edx
  102c93:	89 55 14             	mov    %edx,0x14(%ebp)
  102c96:	8b 30                	mov    (%eax),%esi
  102c98:	85 f6                	test   %esi,%esi
  102c9a:	75 05                	jne    102ca1 <vprintfmt+0x1ad>
                p = "(null)";
  102c9c:	be 2d 3c 10 00       	mov    $0x103c2d,%esi
            }
            if (width > 0 && padc != '-') {
  102ca1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ca5:	7e 3e                	jle    102ce5 <vprintfmt+0x1f1>
  102ca7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cab:	74 38                	je     102ce5 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cad:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cb7:	89 34 24             	mov    %esi,(%esp)
  102cba:	e8 15 03 00 00       	call   102fd4 <strnlen>
  102cbf:	29 c3                	sub    %eax,%ebx
  102cc1:	89 d8                	mov    %ebx,%eax
  102cc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cc6:	eb 17                	jmp    102cdf <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102cc8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ccf:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cd3:	89 04 24             	mov    %eax,(%esp)
  102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd9:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cdb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cdf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ce3:	7f e3                	jg     102cc8 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ce5:	eb 38                	jmp    102d1f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ce7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ceb:	74 1f                	je     102d0c <vprintfmt+0x218>
  102ced:	83 fb 1f             	cmp    $0x1f,%ebx
  102cf0:	7e 05                	jle    102cf7 <vprintfmt+0x203>
  102cf2:	83 fb 7e             	cmp    $0x7e,%ebx
  102cf5:	7e 15                	jle    102d0c <vprintfmt+0x218>
                    putch('?', putdat);
  102cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cfe:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d05:	8b 45 08             	mov    0x8(%ebp),%eax
  102d08:	ff d0                	call   *%eax
  102d0a:	eb 0f                	jmp    102d1b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d13:	89 1c 24             	mov    %ebx,(%esp)
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d1b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d1f:	89 f0                	mov    %esi,%eax
  102d21:	8d 70 01             	lea    0x1(%eax),%esi
  102d24:	0f b6 00             	movzbl (%eax),%eax
  102d27:	0f be d8             	movsbl %al,%ebx
  102d2a:	85 db                	test   %ebx,%ebx
  102d2c:	74 10                	je     102d3e <vprintfmt+0x24a>
  102d2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d32:	78 b3                	js     102ce7 <vprintfmt+0x1f3>
  102d34:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d3c:	79 a9                	jns    102ce7 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d3e:	eb 17                	jmp    102d57 <vprintfmt+0x263>
                putch(' ', putdat);
  102d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d47:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d51:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d53:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d5b:	7f e3                	jg     102d40 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d5d:	e9 70 01 00 00       	jmp    102ed2 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d69:	8d 45 14             	lea    0x14(%ebp),%eax
  102d6c:	89 04 24             	mov    %eax,(%esp)
  102d6f:	e8 0b fd ff ff       	call   102a7f <getint>
  102d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d77:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d80:	85 d2                	test   %edx,%edx
  102d82:	79 26                	jns    102daa <vprintfmt+0x2b6>
                putch('-', putdat);
  102d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d8b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d92:	8b 45 08             	mov    0x8(%ebp),%eax
  102d95:	ff d0                	call   *%eax
                num = -(long long)num;
  102d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d9d:	f7 d8                	neg    %eax
  102d9f:	83 d2 00             	adc    $0x0,%edx
  102da2:	f7 da                	neg    %edx
  102da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102da7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102daa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102db1:	e9 a8 00 00 00       	jmp    102e5e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102db9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dbd:	8d 45 14             	lea    0x14(%ebp),%eax
  102dc0:	89 04 24             	mov    %eax,(%esp)
  102dc3:	e8 68 fc ff ff       	call   102a30 <getuint>
  102dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102dce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dd5:	e9 84 00 00 00       	jmp    102e5e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de1:	8d 45 14             	lea    0x14(%ebp),%eax
  102de4:	89 04 24             	mov    %eax,(%esp)
  102de7:	e8 44 fc ff ff       	call   102a30 <getuint>
  102dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102def:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102df2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102df9:	eb 63                	jmp    102e5e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e02:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	ff d0                	call   *%eax
            putch('x', putdat);
  102e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e15:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e21:	8b 45 14             	mov    0x14(%ebp),%eax
  102e24:	8d 50 04             	lea    0x4(%eax),%edx
  102e27:	89 55 14             	mov    %edx,0x14(%ebp)
  102e2a:	8b 00                	mov    (%eax),%eax
  102e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e3d:	eb 1f                	jmp    102e5e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e42:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e46:	8d 45 14             	lea    0x14(%ebp),%eax
  102e49:	89 04 24             	mov    %eax,(%esp)
  102e4c:	e8 df fb ff ff       	call   102a30 <getuint>
  102e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e54:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e57:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e5e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e65:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e6c:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e85:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e89:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8c:	89 04 24             	mov    %eax,(%esp)
  102e8f:	e8 97 fa ff ff       	call   10292b <printnum>
            break;
  102e94:	eb 3c                	jmp    102ed2 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e99:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e9d:	89 1c 24             	mov    %ebx,(%esp)
  102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea3:	ff d0                	call   *%eax
            break;
  102ea5:	eb 2b                	jmp    102ed2 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb8:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102eba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ebe:	eb 04                	jmp    102ec4 <vprintfmt+0x3d0>
  102ec0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ec4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ec7:	83 e8 01             	sub    $0x1,%eax
  102eca:	0f b6 00             	movzbl (%eax),%eax
  102ecd:	3c 25                	cmp    $0x25,%al
  102ecf:	75 ef                	jne    102ec0 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ed1:	90                   	nop
        }
    }
  102ed2:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ed3:	e9 3e fc ff ff       	jmp    102b16 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ed8:	83 c4 40             	add    $0x40,%esp
  102edb:	5b                   	pop    %ebx
  102edc:	5e                   	pop    %esi
  102edd:	5d                   	pop    %ebp
  102ede:	c3                   	ret    

00102edf <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102edf:	55                   	push   %ebp
  102ee0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee5:	8b 40 08             	mov    0x8(%eax),%eax
  102ee8:	8d 50 01             	lea    0x1(%eax),%edx
  102eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eee:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef4:	8b 10                	mov    (%eax),%edx
  102ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef9:	8b 40 04             	mov    0x4(%eax),%eax
  102efc:	39 c2                	cmp    %eax,%edx
  102efe:	73 12                	jae    102f12 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f03:	8b 00                	mov    (%eax),%eax
  102f05:	8d 48 01             	lea    0x1(%eax),%ecx
  102f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f0b:	89 0a                	mov    %ecx,(%edx)
  102f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  102f10:	88 10                	mov    %dl,(%eax)
    }
}
  102f12:	5d                   	pop    %ebp
  102f13:	c3                   	ret    

00102f14 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f14:	55                   	push   %ebp
  102f15:	89 e5                	mov    %esp,%ebp
  102f17:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f1a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f27:	8b 45 10             	mov    0x10(%ebp),%eax
  102f2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f35:	8b 45 08             	mov    0x8(%ebp),%eax
  102f38:	89 04 24             	mov    %eax,(%esp)
  102f3b:	e8 08 00 00 00       	call   102f48 <vsnprintf>
  102f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f46:	c9                   	leave  
  102f47:	c3                   	ret    

00102f48 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f48:	55                   	push   %ebp
  102f49:	89 e5                	mov    %esp,%ebp
  102f4b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f57:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5d:	01 d0                	add    %edx,%eax
  102f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f6d:	74 0a                	je     102f79 <vsnprintf+0x31>
  102f6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f75:	39 c2                	cmp    %eax,%edx
  102f77:	76 07                	jbe    102f80 <vsnprintf+0x38>
        return -E_INVAL;
  102f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f7e:	eb 2a                	jmp    102faa <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f80:	8b 45 14             	mov    0x14(%ebp),%eax
  102f83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f87:	8b 45 10             	mov    0x10(%ebp),%eax
  102f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f95:	c7 04 24 df 2e 10 00 	movl   $0x102edf,(%esp)
  102f9c:	e8 53 fb ff ff       	call   102af4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102faa:	c9                   	leave  
  102fab:	c3                   	ret    

00102fac <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fac:	55                   	push   %ebp
  102fad:	89 e5                	mov    %esp,%ebp
  102faf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fb9:	eb 04                	jmp    102fbf <strlen+0x13>
        cnt ++;
  102fbb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc2:	8d 50 01             	lea    0x1(%eax),%edx
  102fc5:	89 55 08             	mov    %edx,0x8(%ebp)
  102fc8:	0f b6 00             	movzbl (%eax),%eax
  102fcb:	84 c0                	test   %al,%al
  102fcd:	75 ec                	jne    102fbb <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fd2:	c9                   	leave  
  102fd3:	c3                   	ret    

00102fd4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fd4:	55                   	push   %ebp
  102fd5:	89 e5                	mov    %esp,%ebp
  102fd7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102fe1:	eb 04                	jmp    102fe7 <strnlen+0x13>
        cnt ++;
  102fe3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102fed:	73 10                	jae    102fff <strnlen+0x2b>
  102fef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff2:	8d 50 01             	lea    0x1(%eax),%edx
  102ff5:	89 55 08             	mov    %edx,0x8(%ebp)
  102ff8:	0f b6 00             	movzbl (%eax),%eax
  102ffb:	84 c0                	test   %al,%al
  102ffd:	75 e4                	jne    102fe3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103002:	c9                   	leave  
  103003:	c3                   	ret    

00103004 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103004:	55                   	push   %ebp
  103005:	89 e5                	mov    %esp,%ebp
  103007:	57                   	push   %edi
  103008:	56                   	push   %esi
  103009:	83 ec 20             	sub    $0x20,%esp
  10300c:	8b 45 08             	mov    0x8(%ebp),%eax
  10300f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103012:	8b 45 0c             	mov    0xc(%ebp),%eax
  103015:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103018:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10301e:	89 d1                	mov    %edx,%ecx
  103020:	89 c2                	mov    %eax,%edx
  103022:	89 ce                	mov    %ecx,%esi
  103024:	89 d7                	mov    %edx,%edi
  103026:	ac                   	lods   %ds:(%esi),%al
  103027:	aa                   	stos   %al,%es:(%edi)
  103028:	84 c0                	test   %al,%al
  10302a:	75 fa                	jne    103026 <strcpy+0x22>
  10302c:	89 fa                	mov    %edi,%edx
  10302e:	89 f1                	mov    %esi,%ecx
  103030:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103033:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103039:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10303c:	83 c4 20             	add    $0x20,%esp
  10303f:	5e                   	pop    %esi
  103040:	5f                   	pop    %edi
  103041:	5d                   	pop    %ebp
  103042:	c3                   	ret    

00103043 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103043:	55                   	push   %ebp
  103044:	89 e5                	mov    %esp,%ebp
  103046:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103049:	8b 45 08             	mov    0x8(%ebp),%eax
  10304c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10304f:	eb 21                	jmp    103072 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103051:	8b 45 0c             	mov    0xc(%ebp),%eax
  103054:	0f b6 10             	movzbl (%eax),%edx
  103057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10305a:	88 10                	mov    %dl,(%eax)
  10305c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10305f:	0f b6 00             	movzbl (%eax),%eax
  103062:	84 c0                	test   %al,%al
  103064:	74 04                	je     10306a <strncpy+0x27>
            src ++;
  103066:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10306a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10306e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103076:	75 d9                	jne    103051 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103078:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10307b:	c9                   	leave  
  10307c:	c3                   	ret    

0010307d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10307d:	55                   	push   %ebp
  10307e:	89 e5                	mov    %esp,%ebp
  103080:	57                   	push   %edi
  103081:	56                   	push   %esi
  103082:	83 ec 20             	sub    $0x20,%esp
  103085:	8b 45 08             	mov    0x8(%ebp),%eax
  103088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10308b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10308e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103097:	89 d1                	mov    %edx,%ecx
  103099:	89 c2                	mov    %eax,%edx
  10309b:	89 ce                	mov    %ecx,%esi
  10309d:	89 d7                	mov    %edx,%edi
  10309f:	ac                   	lods   %ds:(%esi),%al
  1030a0:	ae                   	scas   %es:(%edi),%al
  1030a1:	75 08                	jne    1030ab <strcmp+0x2e>
  1030a3:	84 c0                	test   %al,%al
  1030a5:	75 f8                	jne    10309f <strcmp+0x22>
  1030a7:	31 c0                	xor    %eax,%eax
  1030a9:	eb 04                	jmp    1030af <strcmp+0x32>
  1030ab:	19 c0                	sbb    %eax,%eax
  1030ad:	0c 01                	or     $0x1,%al
  1030af:	89 fa                	mov    %edi,%edx
  1030b1:	89 f1                	mov    %esi,%ecx
  1030b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030bf:	83 c4 20             	add    $0x20,%esp
  1030c2:	5e                   	pop    %esi
  1030c3:	5f                   	pop    %edi
  1030c4:	5d                   	pop    %ebp
  1030c5:	c3                   	ret    

001030c6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030c6:	55                   	push   %ebp
  1030c7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030c9:	eb 0c                	jmp    1030d7 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030cb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030db:	74 1a                	je     1030f7 <strncmp+0x31>
  1030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e0:	0f b6 00             	movzbl (%eax),%eax
  1030e3:	84 c0                	test   %al,%al
  1030e5:	74 10                	je     1030f7 <strncmp+0x31>
  1030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ea:	0f b6 10             	movzbl (%eax),%edx
  1030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f0:	0f b6 00             	movzbl (%eax),%eax
  1030f3:	38 c2                	cmp    %al,%dl
  1030f5:	74 d4                	je     1030cb <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030fb:	74 18                	je     103115 <strncmp+0x4f>
  1030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103100:	0f b6 00             	movzbl (%eax),%eax
  103103:	0f b6 d0             	movzbl %al,%edx
  103106:	8b 45 0c             	mov    0xc(%ebp),%eax
  103109:	0f b6 00             	movzbl (%eax),%eax
  10310c:	0f b6 c0             	movzbl %al,%eax
  10310f:	29 c2                	sub    %eax,%edx
  103111:	89 d0                	mov    %edx,%eax
  103113:	eb 05                	jmp    10311a <strncmp+0x54>
  103115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10311a:	5d                   	pop    %ebp
  10311b:	c3                   	ret    

0010311c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10311c:	55                   	push   %ebp
  10311d:	89 e5                	mov    %esp,%ebp
  10311f:	83 ec 04             	sub    $0x4,%esp
  103122:	8b 45 0c             	mov    0xc(%ebp),%eax
  103125:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103128:	eb 14                	jmp    10313e <strchr+0x22>
        if (*s == c) {
  10312a:	8b 45 08             	mov    0x8(%ebp),%eax
  10312d:	0f b6 00             	movzbl (%eax),%eax
  103130:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103133:	75 05                	jne    10313a <strchr+0x1e>
            return (char *)s;
  103135:	8b 45 08             	mov    0x8(%ebp),%eax
  103138:	eb 13                	jmp    10314d <strchr+0x31>
        }
        s ++;
  10313a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10313e:	8b 45 08             	mov    0x8(%ebp),%eax
  103141:	0f b6 00             	movzbl (%eax),%eax
  103144:	84 c0                	test   %al,%al
  103146:	75 e2                	jne    10312a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10314d:	c9                   	leave  
  10314e:	c3                   	ret    

0010314f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10314f:	55                   	push   %ebp
  103150:	89 e5                	mov    %esp,%ebp
  103152:	83 ec 04             	sub    $0x4,%esp
  103155:	8b 45 0c             	mov    0xc(%ebp),%eax
  103158:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10315b:	eb 11                	jmp    10316e <strfind+0x1f>
        if (*s == c) {
  10315d:	8b 45 08             	mov    0x8(%ebp),%eax
  103160:	0f b6 00             	movzbl (%eax),%eax
  103163:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103166:	75 02                	jne    10316a <strfind+0x1b>
            break;
  103168:	eb 0e                	jmp    103178 <strfind+0x29>
        }
        s ++;
  10316a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10316e:	8b 45 08             	mov    0x8(%ebp),%eax
  103171:	0f b6 00             	movzbl (%eax),%eax
  103174:	84 c0                	test   %al,%al
  103176:	75 e5                	jne    10315d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10317b:	c9                   	leave  
  10317c:	c3                   	ret    

0010317d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10317d:	55                   	push   %ebp
  10317e:	89 e5                	mov    %esp,%ebp
  103180:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10318a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103191:	eb 04                	jmp    103197 <strtol+0x1a>
        s ++;
  103193:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103197:	8b 45 08             	mov    0x8(%ebp),%eax
  10319a:	0f b6 00             	movzbl (%eax),%eax
  10319d:	3c 20                	cmp    $0x20,%al
  10319f:	74 f2                	je     103193 <strtol+0x16>
  1031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a4:	0f b6 00             	movzbl (%eax),%eax
  1031a7:	3c 09                	cmp    $0x9,%al
  1031a9:	74 e8                	je     103193 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ae:	0f b6 00             	movzbl (%eax),%eax
  1031b1:	3c 2b                	cmp    $0x2b,%al
  1031b3:	75 06                	jne    1031bb <strtol+0x3e>
        s ++;
  1031b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031b9:	eb 15                	jmp    1031d0 <strtol+0x53>
    }
    else if (*s == '-') {
  1031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031be:	0f b6 00             	movzbl (%eax),%eax
  1031c1:	3c 2d                	cmp    $0x2d,%al
  1031c3:	75 0b                	jne    1031d0 <strtol+0x53>
        s ++, neg = 1;
  1031c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031d4:	74 06                	je     1031dc <strtol+0x5f>
  1031d6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031da:	75 24                	jne    103200 <strtol+0x83>
  1031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031df:	0f b6 00             	movzbl (%eax),%eax
  1031e2:	3c 30                	cmp    $0x30,%al
  1031e4:	75 1a                	jne    103200 <strtol+0x83>
  1031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e9:	83 c0 01             	add    $0x1,%eax
  1031ec:	0f b6 00             	movzbl (%eax),%eax
  1031ef:	3c 78                	cmp    $0x78,%al
  1031f1:	75 0d                	jne    103200 <strtol+0x83>
        s += 2, base = 16;
  1031f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1031f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1031fe:	eb 2a                	jmp    10322a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103204:	75 17                	jne    10321d <strtol+0xa0>
  103206:	8b 45 08             	mov    0x8(%ebp),%eax
  103209:	0f b6 00             	movzbl (%eax),%eax
  10320c:	3c 30                	cmp    $0x30,%al
  10320e:	75 0d                	jne    10321d <strtol+0xa0>
        s ++, base = 8;
  103210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103214:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10321b:	eb 0d                	jmp    10322a <strtol+0xad>
    }
    else if (base == 0) {
  10321d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103221:	75 07                	jne    10322a <strtol+0xad>
        base = 10;
  103223:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10322a:	8b 45 08             	mov    0x8(%ebp),%eax
  10322d:	0f b6 00             	movzbl (%eax),%eax
  103230:	3c 2f                	cmp    $0x2f,%al
  103232:	7e 1b                	jle    10324f <strtol+0xd2>
  103234:	8b 45 08             	mov    0x8(%ebp),%eax
  103237:	0f b6 00             	movzbl (%eax),%eax
  10323a:	3c 39                	cmp    $0x39,%al
  10323c:	7f 11                	jg     10324f <strtol+0xd2>
            dig = *s - '0';
  10323e:	8b 45 08             	mov    0x8(%ebp),%eax
  103241:	0f b6 00             	movzbl (%eax),%eax
  103244:	0f be c0             	movsbl %al,%eax
  103247:	83 e8 30             	sub    $0x30,%eax
  10324a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10324d:	eb 48                	jmp    103297 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10324f:	8b 45 08             	mov    0x8(%ebp),%eax
  103252:	0f b6 00             	movzbl (%eax),%eax
  103255:	3c 60                	cmp    $0x60,%al
  103257:	7e 1b                	jle    103274 <strtol+0xf7>
  103259:	8b 45 08             	mov    0x8(%ebp),%eax
  10325c:	0f b6 00             	movzbl (%eax),%eax
  10325f:	3c 7a                	cmp    $0x7a,%al
  103261:	7f 11                	jg     103274 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103263:	8b 45 08             	mov    0x8(%ebp),%eax
  103266:	0f b6 00             	movzbl (%eax),%eax
  103269:	0f be c0             	movsbl %al,%eax
  10326c:	83 e8 57             	sub    $0x57,%eax
  10326f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103272:	eb 23                	jmp    103297 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103274:	8b 45 08             	mov    0x8(%ebp),%eax
  103277:	0f b6 00             	movzbl (%eax),%eax
  10327a:	3c 40                	cmp    $0x40,%al
  10327c:	7e 3d                	jle    1032bb <strtol+0x13e>
  10327e:	8b 45 08             	mov    0x8(%ebp),%eax
  103281:	0f b6 00             	movzbl (%eax),%eax
  103284:	3c 5a                	cmp    $0x5a,%al
  103286:	7f 33                	jg     1032bb <strtol+0x13e>
            dig = *s - 'A' + 10;
  103288:	8b 45 08             	mov    0x8(%ebp),%eax
  10328b:	0f b6 00             	movzbl (%eax),%eax
  10328e:	0f be c0             	movsbl %al,%eax
  103291:	83 e8 37             	sub    $0x37,%eax
  103294:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329a:	3b 45 10             	cmp    0x10(%ebp),%eax
  10329d:	7c 02                	jl     1032a1 <strtol+0x124>
            break;
  10329f:	eb 1a                	jmp    1032bb <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032a8:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032ac:	89 c2                	mov    %eax,%edx
  1032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b1:	01 d0                	add    %edx,%eax
  1032b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032b6:	e9 6f ff ff ff       	jmp    10322a <strtol+0xad>

    if (endptr) {
  1032bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032bf:	74 08                	je     1032c9 <strtol+0x14c>
        *endptr = (char *) s;
  1032c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1032c7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032cd:	74 07                	je     1032d6 <strtol+0x159>
  1032cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032d2:	f7 d8                	neg    %eax
  1032d4:	eb 03                	jmp    1032d9 <strtol+0x15c>
  1032d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032d9:	c9                   	leave  
  1032da:	c3                   	ret    

001032db <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032db:	55                   	push   %ebp
  1032dc:	89 e5                	mov    %esp,%ebp
  1032de:	57                   	push   %edi
  1032df:	83 ec 24             	sub    $0x24,%esp
  1032e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032e8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032ec:	8b 55 08             	mov    0x8(%ebp),%edx
  1032ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032f2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1032f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1032fb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1032fe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103302:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103305:	89 d7                	mov    %edx,%edi
  103307:	f3 aa                	rep stos %al,%es:(%edi)
  103309:	89 fa                	mov    %edi,%edx
  10330b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10330e:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103311:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103314:	83 c4 24             	add    $0x24,%esp
  103317:	5f                   	pop    %edi
  103318:	5d                   	pop    %ebp
  103319:	c3                   	ret    

0010331a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10331a:	55                   	push   %ebp
  10331b:	89 e5                	mov    %esp,%ebp
  10331d:	57                   	push   %edi
  10331e:	56                   	push   %esi
  10331f:	53                   	push   %ebx
  103320:	83 ec 30             	sub    $0x30,%esp
  103323:	8b 45 08             	mov    0x8(%ebp),%eax
  103326:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103329:	8b 45 0c             	mov    0xc(%ebp),%eax
  10332c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10332f:	8b 45 10             	mov    0x10(%ebp),%eax
  103332:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103338:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10333b:	73 42                	jae    10337f <memmove+0x65>
  10333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103346:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10334c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10334f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103352:	c1 e8 02             	shr    $0x2,%eax
  103355:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103357:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10335a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10335d:	89 d7                	mov    %edx,%edi
  10335f:	89 c6                	mov    %eax,%esi
  103361:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103363:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103366:	83 e1 03             	and    $0x3,%ecx
  103369:	74 02                	je     10336d <memmove+0x53>
  10336b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10336d:	89 f0                	mov    %esi,%eax
  10336f:	89 fa                	mov    %edi,%edx
  103371:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103374:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103377:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10337a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10337d:	eb 36                	jmp    1033b5 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103382:	8d 50 ff             	lea    -0x1(%eax),%edx
  103385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103388:	01 c2                	add    %eax,%edx
  10338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103393:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103399:	89 c1                	mov    %eax,%ecx
  10339b:	89 d8                	mov    %ebx,%eax
  10339d:	89 d6                	mov    %edx,%esi
  10339f:	89 c7                	mov    %eax,%edi
  1033a1:	fd                   	std    
  1033a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033a4:	fc                   	cld    
  1033a5:	89 f8                	mov    %edi,%eax
  1033a7:	89 f2                	mov    %esi,%edx
  1033a9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033ac:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033b5:	83 c4 30             	add    $0x30,%esp
  1033b8:	5b                   	pop    %ebx
  1033b9:	5e                   	pop    %esi
  1033ba:	5f                   	pop    %edi
  1033bb:	5d                   	pop    %ebp
  1033bc:	c3                   	ret    

001033bd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033bd:	55                   	push   %ebp
  1033be:	89 e5                	mov    %esp,%ebp
  1033c0:	57                   	push   %edi
  1033c1:	56                   	push   %esi
  1033c2:	83 ec 20             	sub    $0x20,%esp
  1033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1033d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033da:	c1 e8 02             	shr    $0x2,%eax
  1033dd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e5:	89 d7                	mov    %edx,%edi
  1033e7:	89 c6                	mov    %eax,%esi
  1033e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033eb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033ee:	83 e1 03             	and    $0x3,%ecx
  1033f1:	74 02                	je     1033f5 <memcpy+0x38>
  1033f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033f5:	89 f0                	mov    %esi,%eax
  1033f7:	89 fa                	mov    %edi,%edx
  1033f9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1033ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103402:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103405:	83 c4 20             	add    $0x20,%esp
  103408:	5e                   	pop    %esi
  103409:	5f                   	pop    %edi
  10340a:	5d                   	pop    %ebp
  10340b:	c3                   	ret    

0010340c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10340c:	55                   	push   %ebp
  10340d:	89 e5                	mov    %esp,%ebp
  10340f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103412:	8b 45 08             	mov    0x8(%ebp),%eax
  103415:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103418:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10341e:	eb 30                	jmp    103450 <memcmp+0x44>
        if (*s1 != *s2) {
  103420:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103423:	0f b6 10             	movzbl (%eax),%edx
  103426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103429:	0f b6 00             	movzbl (%eax),%eax
  10342c:	38 c2                	cmp    %al,%dl
  10342e:	74 18                	je     103448 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103433:	0f b6 00             	movzbl (%eax),%eax
  103436:	0f b6 d0             	movzbl %al,%edx
  103439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10343c:	0f b6 00             	movzbl (%eax),%eax
  10343f:	0f b6 c0             	movzbl %al,%eax
  103442:	29 c2                	sub    %eax,%edx
  103444:	89 d0                	mov    %edx,%eax
  103446:	eb 1a                	jmp    103462 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103448:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10344c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103450:	8b 45 10             	mov    0x10(%ebp),%eax
  103453:	8d 50 ff             	lea    -0x1(%eax),%edx
  103456:	89 55 10             	mov    %edx,0x10(%ebp)
  103459:	85 c0                	test   %eax,%eax
  10345b:	75 c3                	jne    103420 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10345d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103462:	c9                   	leave  
  103463:	c3                   	ret    
