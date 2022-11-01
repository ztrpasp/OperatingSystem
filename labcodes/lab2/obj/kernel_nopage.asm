
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 88 af 11 00       	mov    $0x11af88,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 d8 56 00 00       	call   10573a <memset>

    cons_init();                // init the console
  100062:	e8 90 15 00 00       	call   1015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 5f 10 00 	movl   $0x105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 5f 10 00 	movl   $0x105f5c,(%esp)
  10007c:	e8 21 02 00 00       	call   1002a2 <cprintf>

    print_kerninfo();
  100081:	e8 c2 08 00 00       	call   100948 <print_kerninfo>

    grade_backtrace();
  100086:	e8 8e 00 00 00       	call   100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 7a 32 00 00       	call   10330a <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 c7 16 00 00       	call   10175c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 27 18 00 00       	call   1018c1 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 fb 0c 00 00       	call   100d9a <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 f2 17 00 00       	call   101896 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  1000a4:	e8 6b 01 00 00       	call   100214 <lab1_switch_test>

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x73>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b8:	00 
  1000b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c0:	00 
  1000c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c8:	e8 bb 0c 00 00       	call   100d88 <mon_backtrace>
}
  1000cd:	90                   	nop
  1000ce:	c9                   	leave  
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d0:	55                   	push   %ebp
  1000d1:	89 e5                	mov    %esp,%ebp
  1000d3:	53                   	push   %ebx
  1000d4:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ef:	89 04 24             	mov    %eax,(%esp)
  1000f2:	e8 b4 ff ff ff       	call   1000ab <grade_backtrace2>
}
  1000f7:	90                   	nop
  1000f8:	83 c4 14             	add    $0x14,%esp
  1000fb:	5b                   	pop    %ebx
  1000fc:	5d                   	pop    %ebp
  1000fd:	c3                   	ret    

001000fe <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fe:	55                   	push   %ebp
  1000ff:	89 e5                	mov    %esp,%ebp
  100101:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100104:	8b 45 10             	mov    0x10(%ebp),%eax
  100107:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010b:	8b 45 08             	mov    0x8(%ebp),%eax
  10010e:	89 04 24             	mov    %eax,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace1>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <grade_backtrace>:

void
grade_backtrace(void) {
  100119:	55                   	push   %ebp
  10011a:	89 e5                	mov    %esp,%ebp
  10011c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011f:	b8 36 00 10 00       	mov    $0x100036,%eax
  100124:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10012b:	ff 
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100137:	e8 c2 ff ff ff       	call   1000fe <grade_backtrace0>
}
  10013c:	90                   	nop
  10013d:	c9                   	leave  
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 61 5f 10 00 	movl   $0x105f61,(%esp)
  10016e:	e8 2f 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 6f 5f 10 00 	movl   $0x105f6f,(%esp)
  10018d:	e8 10 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 7d 5f 10 00 	movl   $0x105f7d,(%esp)
  1001ac:	e8 f1 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 8b 5f 10 00 	movl   $0x105f8b,(%esp)
  1001cb:	e8 d2 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 99 5f 10 00 	movl   $0x105f99,(%esp)
  1001ea:	e8 b3 00 00 00       	call   1002a2 <cprintf>
    round ++;
  1001ef:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	90                   	nop
  1001fb:	c9                   	leave  
  1001fc:	c3                   	ret    

001001fd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fd:	55                   	push   %ebp
  1001fe:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  100200:	83 ec 08             	sub    $0x8,%esp
  100203:	cd 78                	int    $0x78
  100205:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  100207:	90                   	nop
  100208:	5d                   	pop    %ebp
  100209:	c3                   	ret    

0010020a <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10020a:	55                   	push   %ebp
  10020b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  10020d:	cd 79                	int    $0x79
  10020f:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100211:	90                   	nop
  100212:	5d                   	pop    %ebp
  100213:	c3                   	ret    

00100214 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10021a:	e8 20 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10021f:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  100226:	e8 77 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_user();
  10022b:	e8 cd ff ff ff       	call   1001fd <lab1_switch_to_user>
    lab1_print_cur_status();
  100230:	e8 0a ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100235:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  10023c:	e8 61 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_kernel();
  100241:	e8 c4 ff ff ff       	call   10020a <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100246:	e8 f4 fe ff ff       	call   10013f <lab1_print_cur_status>
}
  10024b:	90                   	nop
  10024c:	c9                   	leave  
  10024d:	c3                   	ret    

0010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10024e:	55                   	push   %ebp
  10024f:	89 e5                	mov    %esp,%ebp
  100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100254:	8b 45 08             	mov    0x8(%ebp),%eax
  100257:	89 04 24             	mov    %eax,(%esp)
  10025a:	e8 c5 13 00 00       	call   101624 <cons_putc>
    (*cnt) ++;
  10025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100262:	8b 00                	mov    (%eax),%eax
  100264:	8d 50 01             	lea    0x1(%eax),%edx
  100267:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026a:	89 10                	mov    %edx,(%eax)
}
  10026c:	90                   	nop
  10026d:	c9                   	leave  
  10026e:	c3                   	ret    

0010026f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10026f:	55                   	push   %ebp
  100270:	89 e5                	mov    %esp,%ebp
  100272:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10027c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100283:	8b 45 08             	mov    0x8(%ebp),%eax
  100286:	89 44 24 08          	mov    %eax,0x8(%esp)
  10028a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100291:	c7 04 24 4e 02 10 00 	movl   $0x10024e,(%esp)
  100298:	e8 f0 57 00 00       	call   105a8d <vprintfmt>
    return cnt;
  10029d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002a0:	c9                   	leave  
  1002a1:	c3                   	ret    

001002a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002a2:	55                   	push   %ebp
  1002a3:	89 e5                	mov    %esp,%ebp
  1002a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b8:	89 04 24             	mov    %eax,(%esp)
  1002bb:	e8 af ff ff ff       	call   10026f <vcprintf>
  1002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 4b 13 00 00       	call   101624 <cons_putc>
}
  1002d9:	90                   	nop
  1002da:	c9                   	leave  
  1002db:	c3                   	ret    

001002dc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002dc:	55                   	push   %ebp
  1002dd:	89 e5                	mov    %esp,%ebp
  1002df:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e9:	eb 13                	jmp    1002fe <cputs+0x22>
        cputch(c, &cnt);
  1002eb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ef:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f6:	89 04 24             	mov    %eax,(%esp)
  1002f9:	e8 50 ff ff ff       	call   10024e <cputch>
    while ((c = *str ++) != '\0') {
  1002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100301:	8d 50 01             	lea    0x1(%eax),%edx
  100304:	89 55 08             	mov    %edx,0x8(%ebp)
  100307:	0f b6 00             	movzbl (%eax),%eax
  10030a:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100311:	75 d8                	jne    1002eb <cputs+0xf>
    }
    cputch('\n', &cnt);
  100313:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100316:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100321:	e8 28 ff ff ff       	call   10024e <cputch>
    return cnt;
  100326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100329:	c9                   	leave  
  10032a:	c3                   	ret    

0010032b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10032b:	55                   	push   %ebp
  10032c:	89 e5                	mov    %esp,%ebp
  10032e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100331:	e8 2b 13 00 00       	call   101661 <cons_getc>
  100336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10033d:	74 f2                	je     100331 <getchar+0x6>
        /* do nothing */;
    return c;
  10033f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100342:	c9                   	leave  
  100343:	c3                   	ret    

00100344 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100344:	55                   	push   %ebp
  100345:	89 e5                	mov    %esp,%ebp
  100347:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10034a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10034e:	74 13                	je     100363 <readline+0x1f>
        cprintf("%s", prompt);
  100350:	8b 45 08             	mov    0x8(%ebp),%eax
  100353:	89 44 24 04          	mov    %eax,0x4(%esp)
  100357:	c7 04 24 e7 5f 10 00 	movl   $0x105fe7,(%esp)
  10035e:	e8 3f ff ff ff       	call   1002a2 <cprintf>
    }
    int i = 0, c;
  100363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10036a:	e8 bc ff ff ff       	call   10032b <getchar>
  10036f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100376:	79 07                	jns    10037f <readline+0x3b>
            return NULL;
  100378:	b8 00 00 00 00       	mov    $0x0,%eax
  10037d:	eb 78                	jmp    1003f7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10037f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100383:	7e 28                	jle    1003ad <readline+0x69>
  100385:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10038c:	7f 1f                	jg     1003ad <readline+0x69>
            cputchar(c);
  10038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100391:	89 04 24             	mov    %eax,(%esp)
  100394:	e8 2f ff ff ff       	call   1002c8 <cputchar>
            buf[i ++] = c;
  100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039c:	8d 50 01             	lea    0x1(%eax),%edx
  10039f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003a5:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1003ab:	eb 45                	jmp    1003f2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1003ad:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b1:	75 16                	jne    1003c9 <readline+0x85>
  1003b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b7:	7e 10                	jle    1003c9 <readline+0x85>
            cputchar(c);
  1003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003bc:	89 04 24             	mov    %eax,(%esp)
  1003bf:	e8 04 ff ff ff       	call   1002c8 <cputchar>
            i --;
  1003c4:	ff 4d f4             	decl   -0xc(%ebp)
  1003c7:	eb 29                	jmp    1003f2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003cd:	74 06                	je     1003d5 <readline+0x91>
  1003cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003d3:	75 95                	jne    10036a <readline+0x26>
            cputchar(c);
  1003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003d8:	89 04 24             	mov    %eax,(%esp)
  1003db:	e8 e8 fe ff ff       	call   1002c8 <cputchar>
            buf[i] = '\0';
  1003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e3:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003eb:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1003f0:	eb 05                	jmp    1003f7 <readline+0xb3>
        c = getchar();
  1003f2:	e9 73 ff ff ff       	jmp    10036a <readline+0x26>
        }
    }
}
  1003f7:	c9                   	leave  
  1003f8:	c3                   	ret    

001003f9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f9:	55                   	push   %ebp
  1003fa:	89 e5                	mov    %esp,%ebp
  1003fc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ff:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100404:	85 c0                	test   %eax,%eax
  100406:	75 5b                	jne    100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100408:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  10040f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100412:	8d 45 14             	lea    0x14(%ebp),%eax
  100415:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100418:	8b 45 0c             	mov    0xc(%ebp),%eax
  10041b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041f:	8b 45 08             	mov    0x8(%ebp),%eax
  100422:	89 44 24 04          	mov    %eax,0x4(%esp)
  100426:	c7 04 24 ea 5f 10 00 	movl   $0x105fea,(%esp)
  10042d:	e8 70 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	89 44 24 04          	mov    %eax,0x4(%esp)
  100439:	8b 45 10             	mov    0x10(%ebp),%eax
  10043c:	89 04 24             	mov    %eax,(%esp)
  10043f:	e8 2b fe ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  100444:	c7 04 24 06 60 10 00 	movl   $0x106006,(%esp)
  10044b:	e8 52 fe ff ff       	call   1002a2 <cprintf>
    
    cprintf("stack trackback:\n");
  100450:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  100457:	e8 46 fe ff ff       	call   1002a2 <cprintf>
    print_stackframe();
  10045c:	e8 32 06 00 00       	call   100a93 <print_stackframe>
  100461:	eb 01                	jmp    100464 <__panic+0x6b>
        goto panic_dead;
  100463:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100464:	e8 34 14 00 00       	call   10189d <intr_disable>
    while (1) {
        kmonitor(NULL);
  100469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100470:	e8 46 08 00 00       	call   100cbb <kmonitor>
  100475:	eb f2                	jmp    100469 <__panic+0x70>

00100477 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100477:	55                   	push   %ebp
  100478:	89 e5                	mov    %esp,%ebp
  10047a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10047d:	8d 45 14             	lea    0x14(%ebp),%eax
  100480:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100483:	8b 45 0c             	mov    0xc(%ebp),%eax
  100486:	89 44 24 08          	mov    %eax,0x8(%esp)
  10048a:	8b 45 08             	mov    0x8(%ebp),%eax
  10048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100491:	c7 04 24 1a 60 10 00 	movl   $0x10601a,(%esp)
  100498:	e8 05 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  10049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a7:	89 04 24             	mov    %eax,(%esp)
  1004aa:	e8 c0 fd ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  1004af:	c7 04 24 06 60 10 00 	movl   $0x106006,(%esp)
  1004b6:	e8 e7 fd ff ff       	call   1002a2 <cprintf>
    va_end(ap);
}
  1004bb:	90                   	nop
  1004bc:	c9                   	leave  
  1004bd:	c3                   	ret    

001004be <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004be:	55                   	push   %ebp
  1004bf:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004c1:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  1004c6:	5d                   	pop    %ebp
  1004c7:	c3                   	ret    

001004c8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004c8:	55                   	push   %ebp
  1004c9:	89 e5                	mov    %esp,%ebp
  1004cb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d1:	8b 00                	mov    (%eax),%eax
  1004d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004e5:	e9 ca 00 00 00       	jmp    1005b4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	89 c2                	mov    %eax,%edx
  1004f4:	c1 ea 1f             	shr    $0x1f,%edx
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	d1 f8                	sar    %eax
  1004fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100501:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100504:	eb 03                	jmp    100509 <stab_binsearch+0x41>
            m --;
  100506:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050f:	7c 1f                	jl     100530 <stab_binsearch+0x68>
  100511:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100514:	89 d0                	mov    %edx,%eax
  100516:	01 c0                	add    %eax,%eax
  100518:	01 d0                	add    %edx,%eax
  10051a:	c1 e0 02             	shl    $0x2,%eax
  10051d:	89 c2                	mov    %eax,%edx
  10051f:	8b 45 08             	mov    0x8(%ebp),%eax
  100522:	01 d0                	add    %edx,%eax
  100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100528:	0f b6 c0             	movzbl %al,%eax
  10052b:	39 45 14             	cmp    %eax,0x14(%ebp)
  10052e:	75 d6                	jne    100506 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100533:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100536:	7d 09                	jge    100541 <stab_binsearch+0x79>
            l = true_m + 1;
  100538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053b:	40                   	inc    %eax
  10053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10053f:	eb 73                	jmp    1005b4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054b:	89 d0                	mov    %edx,%eax
  10054d:	01 c0                	add    %eax,%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	c1 e0 02             	shl    $0x2,%eax
  100554:	89 c2                	mov    %eax,%edx
  100556:	8b 45 08             	mov    0x8(%ebp),%eax
  100559:	01 d0                	add    %edx,%eax
  10055b:	8b 40 08             	mov    0x8(%eax),%eax
  10055e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100561:	76 11                	jbe    100574 <stab_binsearch+0xac>
            *region_left = m;
  100563:	8b 45 0c             	mov    0xc(%ebp),%eax
  100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10056e:	40                   	inc    %eax
  10056f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100572:	eb 40                	jmp    1005b4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100574:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100577:	89 d0                	mov    %edx,%eax
  100579:	01 c0                	add    %eax,%eax
  10057b:	01 d0                	add    %edx,%eax
  10057d:	c1 e0 02             	shl    $0x2,%eax
  100580:	89 c2                	mov    %eax,%edx
  100582:	8b 45 08             	mov    0x8(%ebp),%eax
  100585:	01 d0                	add    %edx,%eax
  100587:	8b 40 08             	mov    0x8(%eax),%eax
  10058a:	39 45 18             	cmp    %eax,0x18(%ebp)
  10058d:	73 14                	jae    1005a3 <stab_binsearch+0xdb>
            *region_right = m - 1;
  10058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100592:	8d 50 ff             	lea    -0x1(%eax),%edx
  100595:	8b 45 10             	mov    0x10(%ebp),%eax
  100598:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059d:	48                   	dec    %eax
  10059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005a1:	eb 11                	jmp    1005b4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a9:	89 10                	mov    %edx,(%eax)
            l = m;
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005b1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005ba:	0f 8e 2a ff ff ff    	jle    1004ea <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005c4:	75 0f                	jne    1005d5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c9:	8b 00                	mov    (%eax),%eax
  1005cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005d3:	eb 3e                	jmp    100613 <stab_binsearch+0x14b>
        l = *region_right;
  1005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d8:	8b 00                	mov    (%eax),%eax
  1005da:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005dd:	eb 03                	jmp    1005e2 <stab_binsearch+0x11a>
  1005df:	ff 4d fc             	decl   -0x4(%ebp)
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	8b 00                	mov    (%eax),%eax
  1005e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005ea:	7e 1f                	jle    10060b <stab_binsearch+0x143>
  1005ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ef:	89 d0                	mov    %edx,%eax
  1005f1:	01 c0                	add    %eax,%eax
  1005f3:	01 d0                	add    %edx,%eax
  1005f5:	c1 e0 02             	shl    $0x2,%eax
  1005f8:	89 c2                	mov    %eax,%edx
  1005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fd:	01 d0                	add    %edx,%eax
  1005ff:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100603:	0f b6 c0             	movzbl %al,%eax
  100606:	39 45 14             	cmp    %eax,0x14(%ebp)
  100609:	75 d4                	jne    1005df <stab_binsearch+0x117>
        *region_left = l;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100611:	89 10                	mov    %edx,(%eax)
}
  100613:	90                   	nop
  100614:	c9                   	leave  
  100615:	c3                   	ret    

00100616 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100616:	55                   	push   %ebp
  100617:	89 e5                	mov    %esp,%ebp
  100619:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061f:	c7 00 38 60 10 00    	movl   $0x106038,(%eax)
    info->eip_line = 0;
  100625:	8b 45 0c             	mov    0xc(%ebp),%eax
  100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100632:	c7 40 08 38 60 10 00 	movl   $0x106038,0x8(%eax)
    info->eip_fn_namelen = 9;
  100639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100643:	8b 45 0c             	mov    0xc(%ebp),%eax
  100646:	8b 55 08             	mov    0x8(%ebp),%edx
  100649:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100656:	c7 45 f4 78 72 10 00 	movl   $0x107278,-0xc(%ebp)
    stab_end = __STAB_END__;
  10065d:	c7 45 f0 88 22 11 00 	movl   $0x112288,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100664:	c7 45 ec 89 22 11 00 	movl   $0x112289,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10066b:	c7 45 e8 94 4d 11 00 	movl   $0x114d94,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100678:	76 0b                	jbe    100685 <debuginfo_eip+0x6f>
  10067a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10067d:	48                   	dec    %eax
  10067e:	0f b6 00             	movzbl (%eax),%eax
  100681:	84 c0                	test   %al,%al
  100683:	74 0a                	je     10068f <debuginfo_eip+0x79>
        return -1;
  100685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10068a:	e9 b7 02 00 00       	jmp    100946 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10068f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100696:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069c:	29 c2                	sub    %eax,%edx
  10069e:	89 d0                	mov    %edx,%eax
  1006a0:	c1 f8 02             	sar    $0x2,%eax
  1006a3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006a9:	48                   	dec    %eax
  1006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006bb:	00 
  1006bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006cd:	89 04 24             	mov    %eax,(%esp)
  1006d0:	e8 f3 fd ff ff       	call   1004c8 <stab_binsearch>
    if (lfile == 0)
  1006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d8:	85 c0                	test   %eax,%eax
  1006da:	75 0a                	jne    1006e6 <debuginfo_eip+0xd0>
        return -1;
  1006dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006e1:	e9 60 02 00 00       	jmp    100946 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006f9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100700:	00 
  100701:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100704:	89 44 24 08          	mov    %eax,0x8(%esp)
  100708:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10070b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100712:	89 04 24             	mov    %eax,(%esp)
  100715:	e8 ae fd ff ff       	call   1004c8 <stab_binsearch>

    if (lfun <= rfun) {
  10071a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10071d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100720:	39 c2                	cmp    %eax,%edx
  100722:	7f 7c                	jg     1007a0 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100727:	89 c2                	mov    %eax,%edx
  100729:	89 d0                	mov    %edx,%eax
  10072b:	01 c0                	add    %eax,%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	c1 e0 02             	shl    $0x2,%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	8b 00                	mov    (%eax),%eax
  10073b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10073e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100741:	29 d1                	sub    %edx,%ecx
  100743:	89 ca                	mov    %ecx,%edx
  100745:	39 d0                	cmp    %edx,%eax
  100747:	73 22                	jae    10076b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	89 d0                	mov    %edx,%eax
  100750:	01 c0                	add    %eax,%eax
  100752:	01 d0                	add    %edx,%eax
  100754:	c1 e0 02             	shl    $0x2,%eax
  100757:	89 c2                	mov    %eax,%edx
  100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075c:	01 d0                	add    %edx,%eax
  10075e:	8b 10                	mov    (%eax),%edx
  100760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100763:	01 c2                	add    %eax,%edx
  100765:	8b 45 0c             	mov    0xc(%ebp),%eax
  100768:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076e:	89 c2                	mov    %eax,%edx
  100770:	89 d0                	mov    %edx,%eax
  100772:	01 c0                	add    %eax,%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	c1 e0 02             	shl    $0x2,%eax
  100779:	89 c2                	mov    %eax,%edx
  10077b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	8b 50 08             	mov    0x8(%eax),%edx
  100783:	8b 45 0c             	mov    0xc(%ebp),%eax
  100786:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078c:	8b 40 10             	mov    0x10(%eax),%eax
  10078f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100798:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10079b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10079e:	eb 15                	jmp    1007b5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1007a6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b8:	8b 40 08             	mov    0x8(%eax),%eax
  1007bb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007c2:	00 
  1007c3:	89 04 24             	mov    %eax,(%esp)
  1007c6:	e8 eb 4d 00 00       	call   1055b6 <strfind>
  1007cb:	89 c2                	mov    %eax,%edx
  1007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d0:	8b 40 08             	mov    0x8(%eax),%eax
  1007d3:	29 c2                	sub    %eax,%edx
  1007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007db:	8b 45 08             	mov    0x8(%ebp),%eax
  1007de:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007e2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007e9:	00 
  1007ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007f1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fb:	89 04 24             	mov    %eax,(%esp)
  1007fe:	e8 c5 fc ff ff       	call   1004c8 <stab_binsearch>
    if (lline <= rline) {
  100803:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100806:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100809:	39 c2                	cmp    %eax,%edx
  10080b:	7f 23                	jg     100830 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  10080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100826:	89 c2                	mov    %eax,%edx
  100828:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10082e:	eb 11                	jmp    100841 <debuginfo_eip+0x22b>
        return -1;
  100830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100835:	e9 0c 01 00 00       	jmp    100946 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083d:	48                   	dec    %eax
  10083e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100847:	39 c2                	cmp    %eax,%edx
  100849:	7c 56                	jl     1008a1 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100864:	3c 84                	cmp    $0x84,%al
  100866:	74 39                	je     1008a1 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086b:	89 c2                	mov    %eax,%edx
  10086d:	89 d0                	mov    %edx,%eax
  10086f:	01 c0                	add    %eax,%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	c1 e0 02             	shl    $0x2,%eax
  100876:	89 c2                	mov    %eax,%edx
  100878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087b:	01 d0                	add    %edx,%eax
  10087d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100881:	3c 64                	cmp    $0x64,%al
  100883:	75 b5                	jne    10083a <debuginfo_eip+0x224>
  100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100888:	89 c2                	mov    %eax,%edx
  10088a:	89 d0                	mov    %edx,%eax
  10088c:	01 c0                	add    %eax,%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	c1 e0 02             	shl    $0x2,%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	8b 40 08             	mov    0x8(%eax),%eax
  10089d:	85 c0                	test   %eax,%eax
  10089f:	74 99                	je     10083a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008a7:	39 c2                	cmp    %eax,%edx
  1008a9:	7c 46                	jl     1008f1 <debuginfo_eip+0x2db>
  1008ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ae:	89 c2                	mov    %eax,%edx
  1008b0:	89 d0                	mov    %edx,%eax
  1008b2:	01 c0                	add    %eax,%eax
  1008b4:	01 d0                	add    %edx,%eax
  1008b6:	c1 e0 02             	shl    $0x2,%eax
  1008b9:	89 c2                	mov    %eax,%edx
  1008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008be:	01 d0                	add    %edx,%eax
  1008c0:	8b 00                	mov    (%eax),%eax
  1008c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008c8:	29 d1                	sub    %edx,%ecx
  1008ca:	89 ca                	mov    %ecx,%edx
  1008cc:	39 d0                	cmp    %edx,%eax
  1008ce:	73 21                	jae    1008f1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d3:	89 c2                	mov    %eax,%edx
  1008d5:	89 d0                	mov    %edx,%eax
  1008d7:	01 c0                	add    %eax,%eax
  1008d9:	01 d0                	add    %edx,%eax
  1008db:	c1 e0 02             	shl    $0x2,%eax
  1008de:	89 c2                	mov    %eax,%edx
  1008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e3:	01 d0                	add    %edx,%eax
  1008e5:	8b 10                	mov    (%eax),%edx
  1008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008ea:	01 c2                	add    %eax,%edx
  1008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ef:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008f7:	39 c2                	cmp    %eax,%edx
  1008f9:	7d 46                	jge    100941 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008fe:	40                   	inc    %eax
  1008ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100902:	eb 16                	jmp    10091a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100904:	8b 45 0c             	mov    0xc(%ebp),%eax
  100907:	8b 40 14             	mov    0x14(%eax),%eax
  10090a:	8d 50 01             	lea    0x1(%eax),%edx
  10090d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100910:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100916:	40                   	inc    %eax
  100917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100920:	39 c2                	cmp    %eax,%edx
  100922:	7d 1d                	jge    100941 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100927:	89 c2                	mov    %eax,%edx
  100929:	89 d0                	mov    %edx,%eax
  10092b:	01 c0                	add    %eax,%eax
  10092d:	01 d0                	add    %edx,%eax
  10092f:	c1 e0 02             	shl    $0x2,%eax
  100932:	89 c2                	mov    %eax,%edx
  100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100937:	01 d0                	add    %edx,%eax
  100939:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10093d:	3c a0                	cmp    $0xa0,%al
  10093f:	74 c3                	je     100904 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  100941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100946:	c9                   	leave  
  100947:	c3                   	ret    

00100948 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100948:	55                   	push   %ebp
  100949:	89 e5                	mov    %esp,%ebp
  10094b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10094e:	c7 04 24 42 60 10 00 	movl   $0x106042,(%esp)
  100955:	e8 48 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100961:	00 
  100962:	c7 04 24 5b 60 10 00 	movl   $0x10605b,(%esp)
  100969:	e8 34 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10096e:	c7 44 24 04 34 5f 10 	movl   $0x105f34,0x4(%esp)
  100975:	00 
  100976:	c7 04 24 73 60 10 00 	movl   $0x106073,(%esp)
  10097d:	e8 20 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100982:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100989:	00 
  10098a:	c7 04 24 8b 60 10 00 	movl   $0x10608b,(%esp)
  100991:	e8 0c f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100996:	c7 44 24 04 88 af 11 	movl   $0x11af88,0x4(%esp)
  10099d:	00 
  10099e:	c7 04 24 a3 60 10 00 	movl   $0x1060a3,(%esp)
  1009a5:	e8 f8 f8 ff ff       	call   1002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009aa:	b8 88 af 11 00       	mov    $0x11af88,%eax
  1009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009ba:	29 c2                	sub    %eax,%edx
  1009bc:	89 d0                	mov    %edx,%eax
  1009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	0f 48 c2             	cmovs  %edx,%eax
  1009c9:	c1 f8 0a             	sar    $0xa,%eax
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	c7 04 24 bc 60 10 00 	movl   $0x1060bc,(%esp)
  1009d7:	e8 c6 f8 ff ff       	call   1002a2 <cprintf>
}
  1009dc:	90                   	nop
  1009dd:	c9                   	leave  
  1009de:	c3                   	ret    

001009df <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009df:	55                   	push   %ebp
  1009e0:	89 e5                	mov    %esp,%ebp
  1009e2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f2:	89 04 24             	mov    %eax,(%esp)
  1009f5:	e8 1c fc ff ff       	call   100616 <debuginfo_eip>
  1009fa:	85 c0                	test   %eax,%eax
  1009fc:	74 15                	je     100a13 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a05:	c7 04 24 e6 60 10 00 	movl   $0x1060e6,(%esp)
  100a0c:	e8 91 f8 ff ff       	call   1002a2 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a11:	eb 6c                	jmp    100a7f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a1a:	eb 1b                	jmp    100a37 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a22:	01 d0                	add    %edx,%eax
  100a24:	0f b6 00             	movzbl (%eax),%eax
  100a27:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a30:	01 ca                	add    %ecx,%edx
  100a32:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a34:	ff 45 f4             	incl   -0xc(%ebp)
  100a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a3d:	7c dd                	jl     100a1c <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a3f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a48:	01 d0                	add    %edx,%eax
  100a4a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a50:	8b 55 08             	mov    0x8(%ebp),%edx
  100a53:	89 d1                	mov    %edx,%ecx
  100a55:	29 c1                	sub    %eax,%ecx
  100a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a61:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a73:	c7 04 24 02 61 10 00 	movl   $0x106102,(%esp)
  100a7a:	e8 23 f8 ff ff       	call   1002a2 <cprintf>
}
  100a7f:	90                   	nop
  100a80:	c9                   	leave  
  100a81:	c3                   	ret    

00100a82 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a82:	55                   	push   %ebp
  100a83:	89 e5                	mov    %esp,%ebp
  100a85:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a88:	8b 45 04             	mov    0x4(%ebp),%eax
  100a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a91:	c9                   	leave  
  100a92:	c3                   	ret    

00100a93 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a93:	55                   	push   %ebp
  100a94:	89 e5                	mov    %esp,%ebp
  100a96:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a99:	89 e8                	mov    %ebp,%eax
  100a9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();
  100aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100aa4:	e8 d9 ff ff ff       	call   100a82 <read_eip>
  100aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100ab3:	e9 84 00 00 00       	jmp    100b3c <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac6:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
  100acd:	e8 d0 f7 ff ff       	call   1002a2 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad5:	83 c0 08             	add    $0x8,%eax
  100ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100adb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ae2:	eb 24                	jmp    100b08 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ae7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100af1:	01 d0                	add    %edx,%eax
  100af3:	8b 00                	mov    (%eax),%eax
  100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af9:	c7 04 24 30 61 10 00 	movl   $0x106130,(%esp)
  100b00:	e8 9d f7 ff ff       	call   1002a2 <cprintf>
        for (j = 0; j < 4; j ++) {
  100b05:	ff 45 e8             	incl   -0x18(%ebp)
  100b08:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b0c:	7e d6                	jle    100ae4 <print_stackframe+0x51>
        }
        cprintf("\n");
  100b0e:	c7 04 24 38 61 10 00 	movl   $0x106138,(%esp)
  100b15:	e8 88 f7 ff ff       	call   1002a2 <cprintf>
        print_debuginfo(eip - 1);
  100b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b1d:	48                   	dec    %eax
  100b1e:	89 04 24             	mov    %eax,(%esp)
  100b21:	e8 b9 fe ff ff       	call   1009df <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b29:	83 c0 04             	add    $0x4,%eax
  100b2c:	8b 00                	mov    (%eax),%eax
  100b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b34:	8b 00                	mov    (%eax),%eax
  100b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b39:	ff 45 ec             	incl   -0x14(%ebp)
  100b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b40:	74 0a                	je     100b4c <print_stackframe+0xb9>
  100b42:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b46:	0f 8e 6c ff ff ff    	jle    100ab8 <print_stackframe+0x25>
    }
}
  100b4c:	90                   	nop
  100b4d:	c9                   	leave  
  100b4e:	c3                   	ret    

00100b4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b4f:	55                   	push   %ebp
  100b50:	89 e5                	mov    %esp,%ebp
  100b52:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b5c:	eb 0c                	jmp    100b6a <parse+0x1b>
            *buf ++ = '\0';
  100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b61:	8d 50 01             	lea    0x1(%eax),%edx
  100b64:	89 55 08             	mov    %edx,0x8(%ebp)
  100b67:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6d:	0f b6 00             	movzbl (%eax),%eax
  100b70:	84 c0                	test   %al,%al
  100b72:	74 1d                	je     100b91 <parse+0x42>
  100b74:	8b 45 08             	mov    0x8(%ebp),%eax
  100b77:	0f b6 00             	movzbl (%eax),%eax
  100b7a:	0f be c0             	movsbl %al,%eax
  100b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b81:	c7 04 24 bc 61 10 00 	movl   $0x1061bc,(%esp)
  100b88:	e8 f7 49 00 00       	call   105584 <strchr>
  100b8d:	85 c0                	test   %eax,%eax
  100b8f:	75 cd                	jne    100b5e <parse+0xf>
        }
        if (*buf == '\0') {
  100b91:	8b 45 08             	mov    0x8(%ebp),%eax
  100b94:	0f b6 00             	movzbl (%eax),%eax
  100b97:	84 c0                	test   %al,%al
  100b99:	74 65                	je     100c00 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b9b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b9f:	75 14                	jne    100bb5 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ba1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ba8:	00 
  100ba9:	c7 04 24 c1 61 10 00 	movl   $0x1061c1,(%esp)
  100bb0:	e8 ed f6 ff ff       	call   1002a2 <cprintf>
        }
        argv[argc ++] = buf;
  100bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb8:	8d 50 01             	lea    0x1(%eax),%edx
  100bbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bc8:	01 c2                	add    %eax,%edx
  100bca:	8b 45 08             	mov    0x8(%ebp),%eax
  100bcd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bcf:	eb 03                	jmp    100bd4 <parse+0x85>
            buf ++;
  100bd1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd7:	0f b6 00             	movzbl (%eax),%eax
  100bda:	84 c0                	test   %al,%al
  100bdc:	74 8c                	je     100b6a <parse+0x1b>
  100bde:	8b 45 08             	mov    0x8(%ebp),%eax
  100be1:	0f b6 00             	movzbl (%eax),%eax
  100be4:	0f be c0             	movsbl %al,%eax
  100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100beb:	c7 04 24 bc 61 10 00 	movl   $0x1061bc,(%esp)
  100bf2:	e8 8d 49 00 00       	call   105584 <strchr>
  100bf7:	85 c0                	test   %eax,%eax
  100bf9:	74 d6                	je     100bd1 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bfb:	e9 6a ff ff ff       	jmp    100b6a <parse+0x1b>
            break;
  100c00:	90                   	nop
        }
    }
    return argc;
  100c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c04:	c9                   	leave  
  100c05:	c3                   	ret    

00100c06 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c06:	55                   	push   %ebp
  100c07:	89 e5                	mov    %esp,%ebp
  100c09:	53                   	push   %ebx
  100c0a:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c0d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c14:	8b 45 08             	mov    0x8(%ebp),%eax
  100c17:	89 04 24             	mov    %eax,(%esp)
  100c1a:	e8 30 ff ff ff       	call   100b4f <parse>
  100c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c26:	75 0a                	jne    100c32 <runcmd+0x2c>
        return 0;
  100c28:	b8 00 00 00 00       	mov    $0x0,%eax
  100c2d:	e9 83 00 00 00       	jmp    100cb5 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c39:	eb 5a                	jmp    100c95 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c3b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c41:	89 d0                	mov    %edx,%eax
  100c43:	01 c0                	add    %eax,%eax
  100c45:	01 d0                	add    %edx,%eax
  100c47:	c1 e0 02             	shl    $0x2,%eax
  100c4a:	05 00 70 11 00       	add    $0x117000,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c55:	89 04 24             	mov    %eax,(%esp)
  100c58:	e8 8a 48 00 00       	call   1054e7 <strcmp>
  100c5d:	85 c0                	test   %eax,%eax
  100c5f:	75 31                	jne    100c92 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c64:	89 d0                	mov    %edx,%eax
  100c66:	01 c0                	add    %eax,%eax
  100c68:	01 d0                	add    %edx,%eax
  100c6a:	c1 e0 02             	shl    $0x2,%eax
  100c6d:	05 08 70 11 00       	add    $0x117008,%eax
  100c72:	8b 10                	mov    (%eax),%edx
  100c74:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c77:	83 c0 04             	add    $0x4,%eax
  100c7a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c7d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8b:	89 1c 24             	mov    %ebx,(%esp)
  100c8e:	ff d2                	call   *%edx
  100c90:	eb 23                	jmp    100cb5 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c92:	ff 45 f4             	incl   -0xc(%ebp)
  100c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c98:	83 f8 02             	cmp    $0x2,%eax
  100c9b:	76 9e                	jbe    100c3b <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca4:	c7 04 24 df 61 10 00 	movl   $0x1061df,(%esp)
  100cab:	e8 f2 f5 ff ff       	call   1002a2 <cprintf>
    return 0;
  100cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb5:	83 c4 64             	add    $0x64,%esp
  100cb8:	5b                   	pop    %ebx
  100cb9:	5d                   	pop    %ebp
  100cba:	c3                   	ret    

00100cbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cc1:	c7 04 24 f8 61 10 00 	movl   $0x1061f8,(%esp)
  100cc8:	e8 d5 f5 ff ff       	call   1002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ccd:	c7 04 24 20 62 10 00 	movl   $0x106220,(%esp)
  100cd4:	e8 c9 f5 ff ff       	call   1002a2 <cprintf>

    if (tf != NULL) {
  100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cdd:	74 0b                	je     100cea <kmonitor+0x2f>
        print_trapframe(tf);
  100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce2:	89 04 24             	mov    %eax,(%esp)
  100ce5:	e8 8f 0d 00 00       	call   101a79 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cea:	c7 04 24 45 62 10 00 	movl   $0x106245,(%esp)
  100cf1:	e8 4e f6 ff ff       	call   100344 <readline>
  100cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cfd:	74 eb                	je     100cea <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cff:	8b 45 08             	mov    0x8(%ebp),%eax
  100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d09:	89 04 24             	mov    %eax,(%esp)
  100d0c:	e8 f5 fe ff ff       	call   100c06 <runcmd>
  100d11:	85 c0                	test   %eax,%eax
  100d13:	78 02                	js     100d17 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100d15:	eb d3                	jmp    100cea <kmonitor+0x2f>
                break;
  100d17:	90                   	nop
            }
        }
    }
}
  100d18:	90                   	nop
  100d19:	c9                   	leave  
  100d1a:	c3                   	ret    

00100d1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d1b:	55                   	push   %ebp
  100d1c:	89 e5                	mov    %esp,%ebp
  100d1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d28:	eb 3d                	jmp    100d67 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d2d:	89 d0                	mov    %edx,%eax
  100d2f:	01 c0                	add    %eax,%eax
  100d31:	01 d0                	add    %edx,%eax
  100d33:	c1 e0 02             	shl    $0x2,%eax
  100d36:	05 04 70 11 00       	add    $0x117004,%eax
  100d3b:	8b 08                	mov    (%eax),%ecx
  100d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d40:	89 d0                	mov    %edx,%eax
  100d42:	01 c0                	add    %eax,%eax
  100d44:	01 d0                	add    %edx,%eax
  100d46:	c1 e0 02             	shl    $0x2,%eax
  100d49:	05 00 70 11 00       	add    $0x117000,%eax
  100d4e:	8b 00                	mov    (%eax),%eax
  100d50:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d58:	c7 04 24 49 62 10 00 	movl   $0x106249,(%esp)
  100d5f:	e8 3e f5 ff ff       	call   1002a2 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d64:	ff 45 f4             	incl   -0xc(%ebp)
  100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d6a:	83 f8 02             	cmp    $0x2,%eax
  100d6d:	76 bb                	jbe    100d2a <mon_help+0xf>
    }
    return 0;
  100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d74:	c9                   	leave  
  100d75:	c3                   	ret    

00100d76 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d7c:	e8 c7 fb ff ff       	call   100948 <print_kerninfo>
    return 0;
  100d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d86:	c9                   	leave  
  100d87:	c3                   	ret    

00100d88 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d88:	55                   	push   %ebp
  100d89:	89 e5                	mov    %esp,%ebp
  100d8b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d8e:	e8 00 fd ff ff       	call   100a93 <print_stackframe>
    return 0;
  100d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d98:	c9                   	leave  
  100d99:	c3                   	ret    

00100d9a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d9a:	55                   	push   %ebp
  100d9b:	89 e5                	mov    %esp,%ebp
  100d9d:	83 ec 28             	sub    $0x28,%esp
  100da0:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100da6:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100daa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
  100db3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dbd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc5:	ee                   	out    %al,(%dx)
  100dc6:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dcc:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100dd0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dd4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd9:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100de0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de3:	c7 04 24 52 62 10 00 	movl   $0x106252,(%esp)
  100dea:	e8 b3 f4 ff ff       	call   1002a2 <cprintf>
    pic_enable(IRQ_TIMER);
  100def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df6:	e8 2e 09 00 00       	call   101729 <pic_enable>
}
  100dfb:	90                   	nop
  100dfc:	c9                   	leave  
  100dfd:	c3                   	ret    

00100dfe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dfe:	55                   	push   %ebp
  100dff:	89 e5                	mov    %esp,%ebp
  100e01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e04:	9c                   	pushf  
  100e05:	58                   	pop    %eax
  100e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e0c:	25 00 02 00 00       	and    $0x200,%eax
  100e11:	85 c0                	test   %eax,%eax
  100e13:	74 0c                	je     100e21 <__intr_save+0x23>
        intr_disable();
  100e15:	e8 83 0a 00 00       	call   10189d <intr_disable>
        return 1;
  100e1a:	b8 01 00 00 00       	mov    $0x1,%eax
  100e1f:	eb 05                	jmp    100e26 <__intr_save+0x28>
    }
    return 0;
  100e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e26:	c9                   	leave  
  100e27:	c3                   	ret    

00100e28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e28:	55                   	push   %ebp
  100e29:	89 e5                	mov    %esp,%ebp
  100e2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e32:	74 05                	je     100e39 <__intr_restore+0x11>
        intr_enable();
  100e34:	e8 5d 0a 00 00       	call   101896 <intr_enable>
    }
}
  100e39:	90                   	nop
  100e3a:	c9                   	leave  
  100e3b:	c3                   	ret    

00100e3c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e3c:	55                   	push   %ebp
  100e3d:	89 e5                	mov    %esp,%ebp
  100e3f:	83 ec 10             	sub    $0x10,%esp
  100e42:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e48:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4c:	89 c2                	mov    %eax,%edx
  100e4e:	ec                   	in     (%dx),%al
  100e4f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e52:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e58:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5c:	89 c2                	mov    %eax,%edx
  100e5e:	ec                   	in     (%dx),%al
  100e5f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e62:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e68:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6c:	89 c2                	mov    %eax,%edx
  100e6e:	ec                   	in     (%dx),%al
  100e6f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e72:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e78:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e7c:	89 c2                	mov    %eax,%edx
  100e7e:	ec                   	in     (%dx),%al
  100e7f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e82:	90                   	nop
  100e83:	c9                   	leave  
  100e84:	c3                   	ret    

00100e85 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e85:	55                   	push   %ebp
  100e86:	89 e5                	mov    %esp,%ebp
  100e88:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e8b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	0f b7 00             	movzwl (%eax),%eax
  100e98:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea7:	0f b7 00             	movzwl (%eax),%eax
  100eaa:	0f b7 c0             	movzwl %ax,%eax
  100ead:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eb2:	74 12                	je     100ec6 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eb4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ebb:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ec2:	b4 03 
  100ec4:	eb 13                	jmp    100ed9 <cga_init+0x54>
    } else {
        *cp = was;
  100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ecd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ed0:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ed7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed9:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ee0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eec:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ef1:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ef8:	40                   	inc    %eax
  100ef9:	0f b7 c0             	movzwl %ax,%eax
  100efc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f00:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f04:	89 c2                	mov    %eax,%edx
  100f06:	ec                   	in     (%dx),%al
  100f07:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f0a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f0e:	0f b6 c0             	movzbl %al,%eax
  100f11:	c1 e0 08             	shl    $0x8,%eax
  100f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f17:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f1e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f22:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f26:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f36:	40                   	inc    %eax
  100f37:	0f b7 c0             	movzwl %ax,%eax
  100f3a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f42:	89 c2                	mov    %eax,%edx
  100f44:	ec                   	in     (%dx),%al
  100f45:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f48:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f4c:	0f b6 c0             	movzbl %al,%eax
  100f4f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f55:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5d:	0f b7 c0             	movzwl %ax,%eax
  100f60:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f66:	90                   	nop
  100f67:	c9                   	leave  
  100f68:	c3                   	ret    

00100f69 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f69:	55                   	push   %ebp
  100f6a:	89 e5                	mov    %esp,%ebp
  100f6c:	83 ec 48             	sub    $0x48,%esp
  100f6f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f75:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f79:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f7d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f81:	ee                   	out    %al,(%dx)
  100f82:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f88:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f8c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f90:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
  100f95:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f9b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f9f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fa3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fa7:	ee                   	out    %al,(%dx)
  100fa8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fae:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100fb2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fba:	ee                   	out    %al,(%dx)
  100fbb:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fc1:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fc5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fcd:	ee                   	out    %al,(%dx)
  100fce:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fd4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fe0:	ee                   	out    %al,(%dx)
  100fe1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fe7:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100feb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ff3:	ee                   	out    %al,(%dx)
  100ff4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ffa:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ffe:	89 c2                	mov    %eax,%edx
  101000:	ec                   	in     (%dx),%al
  101001:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101004:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101008:	3c ff                	cmp    $0xff,%al
  10100a:	0f 95 c0             	setne  %al
  10100d:	0f b6 c0             	movzbl %al,%eax
  101010:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101015:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10101b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10101f:	89 c2                	mov    %eax,%edx
  101021:	ec                   	in     (%dx),%al
  101022:	88 45 f1             	mov    %al,-0xf(%ebp)
  101025:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10102b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10102f:	89 c2                	mov    %eax,%edx
  101031:	ec                   	in     (%dx),%al
  101032:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101035:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10103a:	85 c0                	test   %eax,%eax
  10103c:	74 0c                	je     10104a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10103e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101045:	e8 df 06 00 00       	call   101729 <pic_enable>
    }
}
  10104a:	90                   	nop
  10104b:	c9                   	leave  
  10104c:	c3                   	ret    

0010104d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10104d:	55                   	push   %ebp
  10104e:	89 e5                	mov    %esp,%ebp
  101050:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10105a:	eb 08                	jmp    101064 <lpt_putc_sub+0x17>
        delay();
  10105c:	e8 db fd ff ff       	call   100e3c <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101061:	ff 45 fc             	incl   -0x4(%ebp)
  101064:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10106a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10106e:	89 c2                	mov    %eax,%edx
  101070:	ec                   	in     (%dx),%al
  101071:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101074:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101078:	84 c0                	test   %al,%al
  10107a:	78 09                	js     101085 <lpt_putc_sub+0x38>
  10107c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101083:	7e d7                	jle    10105c <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101085:	8b 45 08             	mov    0x8(%ebp),%eax
  101088:	0f b6 c0             	movzbl %al,%eax
  10108b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101091:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101094:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101098:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10109c:	ee                   	out    %al,(%dx)
  10109d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010a3:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010af:	ee                   	out    %al,(%dx)
  1010b0:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010b6:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  1010ba:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010be:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010c2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c3:	90                   	nop
  1010c4:	c9                   	leave  
  1010c5:	c3                   	ret    

001010c6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c6:	55                   	push   %ebp
  1010c7:	89 e5                	mov    %esp,%ebp
  1010c9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010cc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d0:	74 0d                	je     1010df <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d5:	89 04 24             	mov    %eax,(%esp)
  1010d8:	e8 70 ff ff ff       	call   10104d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010dd:	eb 24                	jmp    101103 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010df:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e6:	e8 62 ff ff ff       	call   10104d <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010f2:	e8 56 ff ff ff       	call   10104d <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010f7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010fe:	e8 4a ff ff ff       	call   10104d <lpt_putc_sub>
}
  101103:	90                   	nop
  101104:	c9                   	leave  
  101105:	c3                   	ret    

00101106 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101106:	55                   	push   %ebp
  101107:	89 e5                	mov    %esp,%ebp
  101109:	53                   	push   %ebx
  10110a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101115:	85 c0                	test   %eax,%eax
  101117:	75 07                	jne    101120 <cga_putc+0x1a>
        c |= 0x0700;
  101119:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101120:	8b 45 08             	mov    0x8(%ebp),%eax
  101123:	0f b6 c0             	movzbl %al,%eax
  101126:	83 f8 0a             	cmp    $0xa,%eax
  101129:	74 55                	je     101180 <cga_putc+0x7a>
  10112b:	83 f8 0d             	cmp    $0xd,%eax
  10112e:	74 63                	je     101193 <cga_putc+0x8d>
  101130:	83 f8 08             	cmp    $0x8,%eax
  101133:	0f 85 94 00 00 00    	jne    1011cd <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  101139:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101140:	85 c0                	test   %eax,%eax
  101142:	0f 84 af 00 00 00    	je     1011f7 <cga_putc+0xf1>
            crt_pos --;
  101148:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114f:	48                   	dec    %eax
  101150:	0f b7 c0             	movzwl %ax,%eax
  101153:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101159:	8b 45 08             	mov    0x8(%ebp),%eax
  10115c:	98                   	cwtl   
  10115d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101162:	98                   	cwtl   
  101163:	83 c8 20             	or     $0x20,%eax
  101166:	98                   	cwtl   
  101167:	8b 15 40 a4 11 00    	mov    0x11a440,%edx
  10116d:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101174:	01 c9                	add    %ecx,%ecx
  101176:	01 ca                	add    %ecx,%edx
  101178:	0f b7 c0             	movzwl %ax,%eax
  10117b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10117e:	eb 77                	jmp    1011f7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101180:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101187:	83 c0 50             	add    $0x50,%eax
  10118a:	0f b7 c0             	movzwl %ax,%eax
  10118d:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101193:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  10119a:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  1011a1:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011a6:	89 c8                	mov    %ecx,%eax
  1011a8:	f7 e2                	mul    %edx
  1011aa:	c1 ea 06             	shr    $0x6,%edx
  1011ad:	89 d0                	mov    %edx,%eax
  1011af:	c1 e0 02             	shl    $0x2,%eax
  1011b2:	01 d0                	add    %edx,%eax
  1011b4:	c1 e0 04             	shl    $0x4,%eax
  1011b7:	29 c1                	sub    %eax,%ecx
  1011b9:	89 c8                	mov    %ecx,%eax
  1011bb:	0f b7 c0             	movzwl %ax,%eax
  1011be:	29 c3                	sub    %eax,%ebx
  1011c0:	89 d8                	mov    %ebx,%eax
  1011c2:	0f b7 c0             	movzwl %ax,%eax
  1011c5:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011cb:	eb 2b                	jmp    1011f8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011cd:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011d3:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011da:	8d 50 01             	lea    0x1(%eax),%edx
  1011dd:	0f b7 d2             	movzwl %dx,%edx
  1011e0:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011e7:	01 c0                	add    %eax,%eax
  1011e9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ef:	0f b7 c0             	movzwl %ax,%eax
  1011f2:	66 89 02             	mov    %ax,(%edx)
        break;
  1011f5:	eb 01                	jmp    1011f8 <cga_putc+0xf2>
        break;
  1011f7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011f8:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ff:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101204:	76 5d                	jbe    101263 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101206:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10120b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101211:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101216:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10121d:	00 
  10121e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101222:	89 04 24             	mov    %eax,(%esp)
  101225:	e8 50 45 00 00       	call   10577a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10122a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101231:	eb 14                	jmp    101247 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101233:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10123b:	01 d2                	add    %edx,%edx
  10123d:	01 d0                	add    %edx,%eax
  10123f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101244:	ff 45 f4             	incl   -0xc(%ebp)
  101247:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10124e:	7e e3                	jle    101233 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  101250:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101257:	83 e8 50             	sub    $0x50,%eax
  10125a:	0f b7 c0             	movzwl %ax,%eax
  10125d:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101263:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10126a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10126e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101272:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101276:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10127a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10127b:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101282:	c1 e8 08             	shr    $0x8,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	0f b6 c0             	movzbl %al,%eax
  10128b:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101292:	42                   	inc    %edx
  101293:	0f b7 d2             	movzwl %dx,%edx
  101296:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10129a:	88 45 e9             	mov    %al,-0x17(%ebp)
  10129d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012a1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012a6:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1012ad:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012b1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012b5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012b9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012be:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012c5:	0f b6 c0             	movzbl %al,%eax
  1012c8:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012cf:	42                   	inc    %edx
  1012d0:	0f b7 d2             	movzwl %dx,%edx
  1012d3:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012d7:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012da:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012e2:	ee                   	out    %al,(%dx)
}
  1012e3:	90                   	nop
  1012e4:	83 c4 34             	add    $0x34,%esp
  1012e7:	5b                   	pop    %ebx
  1012e8:	5d                   	pop    %ebp
  1012e9:	c3                   	ret    

001012ea <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
  1012ed:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012f7:	eb 08                	jmp    101301 <serial_putc_sub+0x17>
        delay();
  1012f9:	e8 3e fb ff ff       	call   100e3c <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012fe:	ff 45 fc             	incl   -0x4(%ebp)
  101301:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101307:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10130b:	89 c2                	mov    %eax,%edx
  10130d:	ec                   	in     (%dx),%al
  10130e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101311:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101315:	0f b6 c0             	movzbl %al,%eax
  101318:	83 e0 20             	and    $0x20,%eax
  10131b:	85 c0                	test   %eax,%eax
  10131d:	75 09                	jne    101328 <serial_putc_sub+0x3e>
  10131f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101326:	7e d1                	jle    1012f9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101328:	8b 45 08             	mov    0x8(%ebp),%eax
  10132b:	0f b6 c0             	movzbl %al,%eax
  10132e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101334:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101337:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10133b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10133f:	ee                   	out    %al,(%dx)
}
  101340:	90                   	nop
  101341:	c9                   	leave  
  101342:	c3                   	ret    

00101343 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101343:	55                   	push   %ebp
  101344:	89 e5                	mov    %esp,%ebp
  101346:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101349:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10134d:	74 0d                	je     10135c <serial_putc+0x19>
        serial_putc_sub(c);
  10134f:	8b 45 08             	mov    0x8(%ebp),%eax
  101352:	89 04 24             	mov    %eax,(%esp)
  101355:	e8 90 ff ff ff       	call   1012ea <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10135a:	eb 24                	jmp    101380 <serial_putc+0x3d>
        serial_putc_sub('\b');
  10135c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101363:	e8 82 ff ff ff       	call   1012ea <serial_putc_sub>
        serial_putc_sub(' ');
  101368:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10136f:	e8 76 ff ff ff       	call   1012ea <serial_putc_sub>
        serial_putc_sub('\b');
  101374:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10137b:	e8 6a ff ff ff       	call   1012ea <serial_putc_sub>
}
  101380:	90                   	nop
  101381:	c9                   	leave  
  101382:	c3                   	ret    

00101383 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101383:	55                   	push   %ebp
  101384:	89 e5                	mov    %esp,%ebp
  101386:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101389:	eb 33                	jmp    1013be <cons_intr+0x3b>
        if (c != 0) {
  10138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10138f:	74 2d                	je     1013be <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101391:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101396:	8d 50 01             	lea    0x1(%eax),%edx
  101399:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  10139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013a2:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a8:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013b2:	75 0a                	jne    1013be <cons_intr+0x3b>
                cons.wpos = 0;
  1013b4:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013bb:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013be:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c1:	ff d0                	call   *%eax
  1013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013ca:	75 bf                	jne    10138b <cons_intr+0x8>
            }
        }
    }
}
  1013cc:	90                   	nop
  1013cd:	c9                   	leave  
  1013ce:	c3                   	ret    

001013cf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013cf:	55                   	push   %ebp
  1013d0:	89 e5                	mov    %esp,%ebp
  1013d2:	83 ec 10             	sub    $0x10,%esp
  1013d5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013db:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013df:	89 c2                	mov    %eax,%edx
  1013e1:	ec                   	in     (%dx),%al
  1013e2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013e9:	0f b6 c0             	movzbl %al,%eax
  1013ec:	83 e0 01             	and    $0x1,%eax
  1013ef:	85 c0                	test   %eax,%eax
  1013f1:	75 07                	jne    1013fa <serial_proc_data+0x2b>
        return -1;
  1013f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f8:	eb 2a                	jmp    101424 <serial_proc_data+0x55>
  1013fa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101400:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101404:	89 c2                	mov    %eax,%edx
  101406:	ec                   	in     (%dx),%al
  101407:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10140a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10140e:	0f b6 c0             	movzbl %al,%eax
  101411:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101414:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101418:	75 07                	jne    101421 <serial_proc_data+0x52>
        c = '\b';
  10141a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101421:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101424:	c9                   	leave  
  101425:	c3                   	ret    

00101426 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101426:	55                   	push   %ebp
  101427:	89 e5                	mov    %esp,%ebp
  101429:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10142c:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101431:	85 c0                	test   %eax,%eax
  101433:	74 0c                	je     101441 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101435:	c7 04 24 cf 13 10 00 	movl   $0x1013cf,(%esp)
  10143c:	e8 42 ff ff ff       	call   101383 <cons_intr>
    }
}
  101441:	90                   	nop
  101442:	c9                   	leave  
  101443:	c3                   	ret    

00101444 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101444:	55                   	push   %ebp
  101445:	89 e5                	mov    %esp,%ebp
  101447:	83 ec 38             	sub    $0x38,%esp
  10144a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101453:	89 c2                	mov    %eax,%edx
  101455:	ec                   	in     (%dx),%al
  101456:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101459:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10145d:	0f b6 c0             	movzbl %al,%eax
  101460:	83 e0 01             	and    $0x1,%eax
  101463:	85 c0                	test   %eax,%eax
  101465:	75 0a                	jne    101471 <kbd_proc_data+0x2d>
        return -1;
  101467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10146c:	e9 55 01 00 00       	jmp    1015c6 <kbd_proc_data+0x182>
  101471:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10147a:	89 c2                	mov    %eax,%edx
  10147c:	ec                   	in     (%dx),%al
  10147d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101480:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101484:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101487:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10148b:	75 17                	jne    1014a4 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  10148d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101492:	83 c8 40             	or     $0x40,%eax
  101495:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  10149a:	b8 00 00 00 00       	mov    $0x0,%eax
  10149f:	e9 22 01 00 00       	jmp    1015c6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	84 c0                	test   %al,%al
  1014aa:	79 45                	jns    1014f1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014ac:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014b1:	83 e0 40             	and    $0x40,%eax
  1014b4:	85 c0                	test   %eax,%eax
  1014b6:	75 08                	jne    1014c0 <kbd_proc_data+0x7c>
  1014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bc:	24 7f                	and    $0x7f,%al
  1014be:	eb 04                	jmp    1014c4 <kbd_proc_data+0x80>
  1014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cb:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014d2:	0c 40                	or     $0x40,%al
  1014d4:	0f b6 c0             	movzbl %al,%eax
  1014d7:	f7 d0                	not    %eax
  1014d9:	89 c2                	mov    %eax,%edx
  1014db:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014e0:	21 d0                	and    %edx,%eax
  1014e2:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ec:	e9 d5 00 00 00       	jmp    1015c6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014f1:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f6:	83 e0 40             	and    $0x40,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	74 11                	je     10150e <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101501:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101506:	83 e0 bf             	and    $0xffffffbf,%eax
  101509:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101519:	0f b6 d0             	movzbl %al,%edx
  10151c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101521:	09 d0                	or     %edx,%eax
  101523:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101533:	0f b6 d0             	movzbl %al,%edx
  101536:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10153b:	31 d0                	xor    %edx,%eax
  10153d:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101542:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101547:	83 e0 03             	and    $0x3,%eax
  10154a:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101555:	01 d0                	add    %edx,%eax
  101557:	0f b6 00             	movzbl (%eax),%eax
  10155a:	0f b6 c0             	movzbl %al,%eax
  10155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101560:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101565:	83 e0 08             	and    $0x8,%eax
  101568:	85 c0                	test   %eax,%eax
  10156a:	74 22                	je     10158e <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10156c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101570:	7e 0c                	jle    10157e <kbd_proc_data+0x13a>
  101572:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101576:	7f 06                	jg     10157e <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101578:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10157c:	eb 10                	jmp    10158e <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10157e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101582:	7e 0a                	jle    10158e <kbd_proc_data+0x14a>
  101584:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101588:	7f 04                	jg     10158e <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10158a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10158e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101593:	f7 d0                	not    %eax
  101595:	83 e0 06             	and    $0x6,%eax
  101598:	85 c0                	test   %eax,%eax
  10159a:	75 27                	jne    1015c3 <kbd_proc_data+0x17f>
  10159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a3:	75 1e                	jne    1015c3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  1015a5:	c7 04 24 6d 62 10 00 	movl   $0x10626d,(%esp)
  1015ac:	e8 f1 ec ff ff       	call   1002a2 <cprintf>
  1015b1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015b7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015c2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015c6:	c9                   	leave  
  1015c7:	c3                   	ret    

001015c8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015c8:	55                   	push   %ebp
  1015c9:	89 e5                	mov    %esp,%ebp
  1015cb:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ce:	c7 04 24 44 14 10 00 	movl   $0x101444,(%esp)
  1015d5:	e8 a9 fd ff ff       	call   101383 <cons_intr>
}
  1015da:	90                   	nop
  1015db:	c9                   	leave  
  1015dc:	c3                   	ret    

001015dd <kbd_init>:

static void
kbd_init(void) {
  1015dd:	55                   	push   %ebp
  1015de:	89 e5                	mov    %esp,%ebp
  1015e0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015e3:	e8 e0 ff ff ff       	call   1015c8 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ef:	e8 35 01 00 00       	call   101729 <pic_enable>
}
  1015f4:	90                   	nop
  1015f5:	c9                   	leave  
  1015f6:	c3                   	ret    

001015f7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f7:	55                   	push   %ebp
  1015f8:	89 e5                	mov    %esp,%ebp
  1015fa:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015fd:	e8 83 f8 ff ff       	call   100e85 <cga_init>
    serial_init();
  101602:	e8 62 f9 ff ff       	call   100f69 <serial_init>
    kbd_init();
  101607:	e8 d1 ff ff ff       	call   1015dd <kbd_init>
    if (!serial_exists) {
  10160c:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	75 0c                	jne    101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101615:	c7 04 24 79 62 10 00 	movl   $0x106279,(%esp)
  10161c:	e8 81 ec ff ff       	call   1002a2 <cprintf>
    }
}
  101621:	90                   	nop
  101622:	c9                   	leave  
  101623:	c3                   	ret    

00101624 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101624:	55                   	push   %ebp
  101625:	89 e5                	mov    %esp,%ebp
  101627:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10162a:	e8 cf f7 ff ff       	call   100dfe <__intr_save>
  10162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101632:	8b 45 08             	mov    0x8(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 89 fa ff ff       	call   1010c6 <lpt_putc>
        cga_putc(c);
  10163d:	8b 45 08             	mov    0x8(%ebp),%eax
  101640:	89 04 24             	mov    %eax,(%esp)
  101643:	e8 be fa ff ff       	call   101106 <cga_putc>
        serial_putc(c);
  101648:	8b 45 08             	mov    0x8(%ebp),%eax
  10164b:	89 04 24             	mov    %eax,(%esp)
  10164e:	e8 f0 fc ff ff       	call   101343 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101656:	89 04 24             	mov    %eax,(%esp)
  101659:	e8 ca f7 ff ff       	call   100e28 <__intr_restore>
}
  10165e:	90                   	nop
  10165f:	c9                   	leave  
  101660:	c3                   	ret    

00101661 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101661:	55                   	push   %ebp
  101662:	89 e5                	mov    %esp,%ebp
  101664:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101667:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10166e:	e8 8b f7 ff ff       	call   100dfe <__intr_save>
  101673:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101676:	e8 ab fd ff ff       	call   101426 <serial_intr>
        kbd_intr();
  10167b:	e8 48 ff ff ff       	call   1015c8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101680:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101686:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10168b:	39 c2                	cmp    %eax,%edx
  10168d:	74 31                	je     1016c0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10168f:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101694:	8d 50 01             	lea    0x1(%eax),%edx
  101697:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  10169d:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  1016a4:	0f b6 c0             	movzbl %al,%eax
  1016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016aa:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016af:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016b4:	75 0a                	jne    1016c0 <cons_getc+0x5f>
                cons.rpos = 0;
  1016b6:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016bd:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016c3:	89 04 24             	mov    %eax,(%esp)
  1016c6:	e8 5d f7 ff ff       	call   100e28 <__intr_restore>
    return c;
  1016cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016ce:	c9                   	leave  
  1016cf:	c3                   	ret    

001016d0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016d0:	55                   	push   %ebp
  1016d1:	89 e5                	mov    %esp,%ebp
  1016d3:	83 ec 14             	sub    $0x14,%esp
  1016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016e0:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016e6:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016eb:	85 c0                	test   %eax,%eax
  1016ed:	74 37                	je     101726 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016f2:	0f b6 c0             	movzbl %al,%eax
  1016f5:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016fb:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101702:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101706:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101707:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10170b:	c1 e8 08             	shr    $0x8,%eax
  10170e:	0f b7 c0             	movzwl %ax,%eax
  101711:	0f b6 c0             	movzbl %al,%eax
  101714:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10171a:	88 45 fd             	mov    %al,-0x3(%ebp)
  10171d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101721:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101725:	ee                   	out    %al,(%dx)
    }
}
  101726:	90                   	nop
  101727:	c9                   	leave  
  101728:	c3                   	ret    

00101729 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101729:	55                   	push   %ebp
  10172a:	89 e5                	mov    %esp,%ebp
  10172c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10172f:	8b 45 08             	mov    0x8(%ebp),%eax
  101732:	ba 01 00 00 00       	mov    $0x1,%edx
  101737:	88 c1                	mov    %al,%cl
  101739:	d3 e2                	shl    %cl,%edx
  10173b:	89 d0                	mov    %edx,%eax
  10173d:	98                   	cwtl   
  10173e:	f7 d0                	not    %eax
  101740:	0f bf d0             	movswl %ax,%edx
  101743:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10174a:	98                   	cwtl   
  10174b:	21 d0                	and    %edx,%eax
  10174d:	98                   	cwtl   
  10174e:	0f b7 c0             	movzwl %ax,%eax
  101751:	89 04 24             	mov    %eax,(%esp)
  101754:	e8 77 ff ff ff       	call   1016d0 <pic_setmask>
}
  101759:	90                   	nop
  10175a:	c9                   	leave  
  10175b:	c3                   	ret    

0010175c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10175c:	55                   	push   %ebp
  10175d:	89 e5                	mov    %esp,%ebp
  10175f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101762:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101769:	00 00 00 
  10176c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101772:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101776:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10177a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101785:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101789:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10178d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101798:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10179c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017ab:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1017af:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017b3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017be:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1017c2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017c6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
  1017cb:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017d1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017d5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017dd:	ee                   	out    %al,(%dx)
  1017de:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017e4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017e8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017ec:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
  1017f1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017f7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017fb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ff:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101803:	ee                   	out    %al,(%dx)
  101804:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10180a:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10180e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101812:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101816:	ee                   	out    %al,(%dx)
  101817:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10181d:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101821:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101825:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101829:	ee                   	out    %al,(%dx)
  10182a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101830:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101834:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101838:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10183c:	ee                   	out    %al,(%dx)
  10183d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101843:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101847:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10184b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10184f:	ee                   	out    %al,(%dx)
  101850:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101856:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10185a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10185e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101862:	ee                   	out    %al,(%dx)
  101863:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101869:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  10186d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101871:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101875:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101876:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10187d:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101882:	74 0f                	je     101893 <pic_init+0x137>
        pic_setmask(irq_mask);
  101884:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10188b:	89 04 24             	mov    %eax,(%esp)
  10188e:	e8 3d fe ff ff       	call   1016d0 <pic_setmask>
    }
}
  101893:	90                   	nop
  101894:	c9                   	leave  
  101895:	c3                   	ret    

00101896 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101896:	55                   	push   %ebp
  101897:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101899:	fb                   	sti    
    sti();
}
  10189a:	90                   	nop
  10189b:	5d                   	pop    %ebp
  10189c:	c3                   	ret    

0010189d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10189d:	55                   	push   %ebp
  10189e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  1018a0:	fa                   	cli    
    cli();
}
  1018a1:	90                   	nop
  1018a2:	5d                   	pop    %ebp
  1018a3:	c3                   	ret    

001018a4 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018a4:	55                   	push   %ebp
  1018a5:	89 e5                	mov    %esp,%ebp
  1018a7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018aa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018b1:	00 
  1018b2:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
  1018b9:	e8 e4 e9 ff ff       	call   1002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018be:	90                   	nop
  1018bf:	c9                   	leave  
  1018c0:	c3                   	ret    

001018c1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c1:	55                   	push   %ebp
  1018c2:	89 e5                	mov    %esp,%ebp
  1018c4:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ce:	e9 c4 00 00 00       	jmp    101997 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d6:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018dd:	0f b7 d0             	movzwl %ax,%edx
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018ea:	00 
  1018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ee:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  1018f5:	00 08 00 
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101902:	00 
  101903:	80 e2 e0             	and    $0xe0,%dl
  101906:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101917:	00 
  101918:	80 e2 1f             	and    $0x1f,%dl
  10191b:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101925:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10192c:	00 
  10192d:	80 e2 f0             	and    $0xf0,%dl
  101930:	80 ca 0e             	or     $0xe,%dl
  101933:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193d:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101944:	00 
  101945:	80 e2 ef             	and    $0xef,%dl
  101948:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101959:	00 
  10195a:	80 e2 9f             	and    $0x9f,%dl
  10195d:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101967:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10196e:	00 
  10196f:	80 ca 80             	or     $0x80,%dl
  101972:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197c:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101983:	c1 e8 10             	shr    $0x10,%eax
  101986:	0f b7 d0             	movzwl %ax,%edx
  101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198c:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  101993:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101994:	ff 45 fc             	incl   -0x4(%ebp)
  101997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199a:	3d ff 00 00 00       	cmp    $0xff,%eax
  10199f:	0f 86 2e ff ff ff    	jbe    1018d3 <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019a5:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019aa:	0f b7 c0             	movzwl %ax,%eax
  1019ad:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  1019b3:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  1019ba:	08 00 
  1019bc:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019c3:	24 e0                	and    $0xe0,%al
  1019c5:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019ca:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019d1:	24 1f                	and    $0x1f,%al
  1019d3:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019d8:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019df:	24 f0                	and    $0xf0,%al
  1019e1:	0c 0e                	or     $0xe,%al
  1019e3:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019e8:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019ef:	24 ef                	and    $0xef,%al
  1019f1:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019f6:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019fd:	0c 60                	or     $0x60,%al
  1019ff:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a04:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a0b:	0c 80                	or     $0x80,%al
  101a0d:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a12:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a17:	c1 e8 10             	shr    $0x10,%eax
  101a1a:	0f b7 c0             	movzwl %ax,%eax
  101a1d:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a23:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a2d:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a30:	90                   	nop
  101a31:	c9                   	leave  
  101a32:	c3                   	ret    

00101a33 <trapname>:

static const char *
trapname(int trapno) {
  101a33:	55                   	push   %ebp
  101a34:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a36:	8b 45 08             	mov    0x8(%ebp),%eax
  101a39:	83 f8 13             	cmp    $0x13,%eax
  101a3c:	77 0c                	ja     101a4a <trapname+0x17>
        return excnames[trapno];
  101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a41:	8b 04 85 00 66 10 00 	mov    0x106600(,%eax,4),%eax
  101a48:	eb 18                	jmp    101a62 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a4a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a4e:	7e 0d                	jle    101a5d <trapname+0x2a>
  101a50:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a54:	7f 07                	jg     101a5d <trapname+0x2a>
        return "Hardware Interrupt";
  101a56:	b8 aa 62 10 00       	mov    $0x1062aa,%eax
  101a5b:	eb 05                	jmp    101a62 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a5d:	b8 bd 62 10 00       	mov    $0x1062bd,%eax
}
  101a62:	5d                   	pop    %ebp
  101a63:	c3                   	ret    

00101a64 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a64:	55                   	push   %ebp
  101a65:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a67:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a6e:	83 f8 08             	cmp    $0x8,%eax
  101a71:	0f 94 c0             	sete   %al
  101a74:	0f b6 c0             	movzbl %al,%eax
}
  101a77:	5d                   	pop    %ebp
  101a78:	c3                   	ret    

00101a79 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a79:	55                   	push   %ebp
  101a7a:	89 e5                	mov    %esp,%ebp
  101a7c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a86:	c7 04 24 fe 62 10 00 	movl   $0x1062fe,(%esp)
  101a8d:	e8 10 e8 ff ff       	call   1002a2 <cprintf>
    print_regs(&tf->tf_regs);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	89 04 24             	mov    %eax,(%esp)
  101a98:	e8 8f 01 00 00       	call   101c2c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa8:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  101aaf:	e8 ee e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abf:	c7 04 24 22 63 10 00 	movl   $0x106322,(%esp)
  101ac6:	e8 d7 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101acb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ace:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 35 63 10 00 	movl   $0x106335,(%esp)
  101add:	e8 c0 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aed:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  101af4:	e8 a9 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af9:	8b 45 08             	mov    0x8(%ebp),%eax
  101afc:	8b 40 30             	mov    0x30(%eax),%eax
  101aff:	89 04 24             	mov    %eax,(%esp)
  101b02:	e8 2c ff ff ff       	call   101a33 <trapname>
  101b07:	89 c2                	mov    %eax,%edx
  101b09:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0c:	8b 40 30             	mov    0x30(%eax),%eax
  101b0f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b17:	c7 04 24 5b 63 10 00 	movl   $0x10635b,(%esp)
  101b1e:	e8 7f e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b23:	8b 45 08             	mov    0x8(%ebp),%eax
  101b26:	8b 40 34             	mov    0x34(%eax),%eax
  101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2d:	c7 04 24 6d 63 10 00 	movl   $0x10636d,(%esp)
  101b34:	e8 69 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b39:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3c:	8b 40 38             	mov    0x38(%eax),%eax
  101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b43:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  101b4a:	e8 53 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5a:	c7 04 24 8b 63 10 00 	movl   $0x10638b,(%esp)
  101b61:	e8 3c e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	8b 40 40             	mov    0x40(%eax),%eax
  101b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b70:	c7 04 24 9e 63 10 00 	movl   $0x10639e,(%esp)
  101b77:	e8 26 e7 ff ff       	call   1002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b8a:	eb 3d                	jmp    101bc9 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	8b 50 40             	mov    0x40(%eax),%edx
  101b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b95:	21 d0                	and    %edx,%eax
  101b97:	85 c0                	test   %eax,%eax
  101b99:	74 28                	je     101bc3 <print_trapframe+0x14a>
  101b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b9e:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101ba5:	85 c0                	test   %eax,%eax
  101ba7:	74 1a                	je     101bc3 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bac:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 ad 63 10 00 	movl   $0x1063ad,(%esp)
  101bbe:	e8 df e6 ff ff       	call   1002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bc3:	ff 45 f4             	incl   -0xc(%ebp)
  101bc6:	d1 65 f0             	shll   -0x10(%ebp)
  101bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bcc:	83 f8 17             	cmp    $0x17,%eax
  101bcf:	76 bb                	jbe    101b8c <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	8b 40 40             	mov    0x40(%eax),%eax
  101bd7:	c1 e8 0c             	shr    $0xc,%eax
  101bda:	83 e0 03             	and    $0x3,%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 b1 63 10 00 	movl   $0x1063b1,(%esp)
  101be8:	e8 b5 e6 ff ff       	call   1002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	89 04 24             	mov    %eax,(%esp)
  101bf3:	e8 6c fe ff ff       	call   101a64 <trap_in_kernel>
  101bf8:	85 c0                	test   %eax,%eax
  101bfa:	75 2d                	jne    101c29 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bff:	8b 40 44             	mov    0x44(%eax),%eax
  101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c06:	c7 04 24 ba 63 10 00 	movl   $0x1063ba,(%esp)
  101c0d:	e8 90 e6 ff ff       	call   1002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1d:	c7 04 24 c9 63 10 00 	movl   $0x1063c9,(%esp)
  101c24:	e8 79 e6 ff ff       	call   1002a2 <cprintf>
    }
}
  101c29:	90                   	nop
  101c2a:	c9                   	leave  
  101c2b:	c3                   	ret    

00101c2c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c2c:	55                   	push   %ebp
  101c2d:	89 e5                	mov    %esp,%ebp
  101c2f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 00                	mov    (%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 dc 63 10 00 	movl   $0x1063dc,(%esp)
  101c42:	e8 5b e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	8b 40 04             	mov    0x4(%eax),%eax
  101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c51:	c7 04 24 eb 63 10 00 	movl   $0x1063eb,(%esp)
  101c58:	e8 45 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c60:	8b 40 08             	mov    0x8(%eax),%eax
  101c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c67:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101c6e:	e8 2f e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c73:	8b 45 08             	mov    0x8(%ebp),%eax
  101c76:	8b 40 0c             	mov    0xc(%eax),%eax
  101c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7d:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101c84:	e8 19 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c89:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8c:	8b 40 10             	mov    0x10(%eax),%eax
  101c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c93:	c7 04 24 18 64 10 00 	movl   $0x106418,(%esp)
  101c9a:	e8 03 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca2:	8b 40 14             	mov    0x14(%eax),%eax
  101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca9:	c7 04 24 27 64 10 00 	movl   $0x106427,(%esp)
  101cb0:	e8 ed e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb8:	8b 40 18             	mov    0x18(%eax),%eax
  101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbf:	c7 04 24 36 64 10 00 	movl   $0x106436,(%esp)
  101cc6:	e8 d7 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd5:	c7 04 24 45 64 10 00 	movl   $0x106445,(%esp)
  101cdc:	e8 c1 e5 ff ff       	call   1002a2 <cprintf>
}
  101ce1:	90                   	nop
  101ce2:	c9                   	leave  
  101ce3:	c3                   	ret    

00101ce4 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ce4:	55                   	push   %ebp
  101ce5:	89 e5                	mov    %esp,%ebp
  101ce7:	57                   	push   %edi
  101ce8:	56                   	push   %esi
  101ce9:	53                   	push   %ebx
  101cea:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101ced:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf0:	8b 40 30             	mov    0x30(%eax),%eax
  101cf3:	83 f8 2f             	cmp    $0x2f,%eax
  101cf6:	77 21                	ja     101d19 <trap_dispatch+0x35>
  101cf8:	83 f8 2e             	cmp    $0x2e,%eax
  101cfb:	0f 83 5d 02 00 00    	jae    101f5e <trap_dispatch+0x27a>
  101d01:	83 f8 21             	cmp    $0x21,%eax
  101d04:	0f 84 95 00 00 00    	je     101d9f <trap_dispatch+0xbb>
  101d0a:	83 f8 24             	cmp    $0x24,%eax
  101d0d:	74 67                	je     101d76 <trap_dispatch+0x92>
  101d0f:	83 f8 20             	cmp    $0x20,%eax
  101d12:	74 1c                	je     101d30 <trap_dispatch+0x4c>
  101d14:	e9 10 02 00 00       	jmp    101f29 <trap_dispatch+0x245>
  101d19:	83 f8 78             	cmp    $0x78,%eax
  101d1c:	0f 84 a6 00 00 00    	je     101dc8 <trap_dispatch+0xe4>
  101d22:	83 f8 79             	cmp    $0x79,%eax
  101d25:	0f 84 81 01 00 00    	je     101eac <trap_dispatch+0x1c8>
  101d2b:	e9 f9 01 00 00       	jmp    101f29 <trap_dispatch+0x245>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d30:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d35:	40                   	inc    %eax
  101d36:	a3 0c af 11 00       	mov    %eax,0x11af0c
        if (ticks % TICK_NUM == 0) {
  101d3b:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d41:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d46:	89 c8                	mov    %ecx,%eax
  101d48:	f7 e2                	mul    %edx
  101d4a:	c1 ea 05             	shr    $0x5,%edx
  101d4d:	89 d0                	mov    %edx,%eax
  101d4f:	c1 e0 02             	shl    $0x2,%eax
  101d52:	01 d0                	add    %edx,%eax
  101d54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d5b:	01 d0                	add    %edx,%eax
  101d5d:	c1 e0 02             	shl    $0x2,%eax
  101d60:	29 c1                	sub    %eax,%ecx
  101d62:	89 ca                	mov    %ecx,%edx
  101d64:	85 d2                	test   %edx,%edx
  101d66:	0f 85 f5 01 00 00    	jne    101f61 <trap_dispatch+0x27d>
            print_ticks();
  101d6c:	e8 33 fb ff ff       	call   1018a4 <print_ticks>
        }
        break;
  101d71:	e9 eb 01 00 00       	jmp    101f61 <trap_dispatch+0x27d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d76:	e8 e6 f8 ff ff       	call   101661 <cons_getc>
  101d7b:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7e:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d82:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d86:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8e:	c7 04 24 54 64 10 00 	movl   $0x106454,(%esp)
  101d95:	e8 08 e5 ff ff       	call   1002a2 <cprintf>
        break;
  101d9a:	e9 c9 01 00 00       	jmp    101f68 <trap_dispatch+0x284>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d9f:	e8 bd f8 ff ff       	call   101661 <cons_getc>
  101da4:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da7:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dab:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101daf:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db7:	c7 04 24 66 64 10 00 	movl   $0x106466,(%esp)
  101dbe:	e8 df e4 ff ff       	call   1002a2 <cprintf>
        break;
  101dc3:	e9 a0 01 00 00       	jmp    101f68 <trap_dispatch+0x284>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dcf:	83 f8 1b             	cmp    $0x1b,%eax
  101dd2:	0f 84 8c 01 00 00    	je     101f64 <trap_dispatch+0x280>
            switchk2u = *tf;
  101dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  101ddb:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101de0:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101de5:	89 c1                	mov    %eax,%ecx
  101de7:	83 e1 01             	and    $0x1,%ecx
  101dea:	85 c9                	test   %ecx,%ecx
  101dec:	74 0c                	je     101dfa <trap_dispatch+0x116>
  101dee:	0f b6 0a             	movzbl (%edx),%ecx
  101df1:	88 08                	mov    %cl,(%eax)
  101df3:	8d 40 01             	lea    0x1(%eax),%eax
  101df6:	8d 52 01             	lea    0x1(%edx),%edx
  101df9:	4b                   	dec    %ebx
  101dfa:	89 c1                	mov    %eax,%ecx
  101dfc:	83 e1 02             	and    $0x2,%ecx
  101dff:	85 c9                	test   %ecx,%ecx
  101e01:	74 0f                	je     101e12 <trap_dispatch+0x12e>
  101e03:	0f b7 0a             	movzwl (%edx),%ecx
  101e06:	66 89 08             	mov    %cx,(%eax)
  101e09:	8d 40 02             	lea    0x2(%eax),%eax
  101e0c:	8d 52 02             	lea    0x2(%edx),%edx
  101e0f:	83 eb 02             	sub    $0x2,%ebx
  101e12:	89 df                	mov    %ebx,%edi
  101e14:	83 e7 fc             	and    $0xfffffffc,%edi
  101e17:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e1c:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101e1f:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101e22:	83 c1 04             	add    $0x4,%ecx
  101e25:	39 f9                	cmp    %edi,%ecx
  101e27:	72 f3                	jb     101e1c <trap_dispatch+0x138>
  101e29:	01 c8                	add    %ecx,%eax
  101e2b:	01 ca                	add    %ecx,%edx
  101e2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e32:	89 de                	mov    %ebx,%esi
  101e34:	83 e6 02             	and    $0x2,%esi
  101e37:	85 f6                	test   %esi,%esi
  101e39:	74 0b                	je     101e46 <trap_dispatch+0x162>
  101e3b:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101e3f:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101e43:	83 c1 02             	add    $0x2,%ecx
  101e46:	83 e3 01             	and    $0x1,%ebx
  101e49:	85 db                	test   %ebx,%ebx
  101e4b:	74 07                	je     101e54 <trap_dispatch+0x170>
  101e4d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101e51:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101e54:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  101e5b:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e5d:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  101e64:	23 00 
  101e66:	0f b7 05 68 af 11 00 	movzwl 0x11af68,%eax
  101e6d:	66 a3 48 af 11 00    	mov    %ax,0x11af48
  101e73:	0f b7 05 48 af 11 00 	movzwl 0x11af48,%eax
  101e7a:	66 a3 4c af 11 00    	mov    %ax,0x11af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e80:	8b 45 08             	mov    0x8(%ebp),%eax
  101e83:	83 c0 44             	add    $0x44,%eax
  101e86:	a3 64 af 11 00       	mov    %eax,0x11af64
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e8b:	a1 60 af 11 00       	mov    0x11af60,%eax
  101e90:	0d 00 30 00 00       	or     $0x3000,%eax
  101e95:	a3 60 af 11 00       	mov    %eax,0x11af60
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	83 e8 04             	sub    $0x4,%eax
  101ea0:	ba 20 af 11 00       	mov    $0x11af20,%edx
  101ea5:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ea7:	e9 b8 00 00 00       	jmp    101f64 <trap_dispatch+0x280>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101eac:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eb3:	83 f8 08             	cmp    $0x8,%eax
  101eb6:	0f 84 ab 00 00 00    	je     101f67 <trap_dispatch+0x283>
            tf->tf_cs = KERNEL_CS;
  101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebf:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec8:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ece:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101edc:	8b 45 08             	mov    0x8(%ebp),%eax
  101edf:	8b 40 40             	mov    0x40(%eax),%eax
  101ee2:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101ee7:	89 c2                	mov    %eax,%edx
  101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eec:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101eef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef2:	8b 40 44             	mov    0x44(%eax),%eax
  101ef5:	83 e8 44             	sub    $0x44,%eax
  101ef8:	a3 6c af 11 00       	mov    %eax,0x11af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101efd:	a1 6c af 11 00       	mov    0x11af6c,%eax
  101f02:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f09:	00 
  101f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  101f0d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f11:	89 04 24             	mov    %eax,(%esp)
  101f14:	e8 61 38 00 00       	call   10577a <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f19:	8b 15 6c af 11 00    	mov    0x11af6c,%edx
  101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f22:	83 e8 04             	sub    $0x4,%eax
  101f25:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f27:	eb 3e                	jmp    101f67 <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f29:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f30:	83 e0 03             	and    $0x3,%eax
  101f33:	85 c0                	test   %eax,%eax
  101f35:	75 31                	jne    101f68 <trap_dispatch+0x284>
            print_trapframe(tf);
  101f37:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3a:	89 04 24             	mov    %eax,(%esp)
  101f3d:	e8 37 fb ff ff       	call   101a79 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f42:	c7 44 24 08 75 64 10 	movl   $0x106475,0x8(%esp)
  101f49:	00 
  101f4a:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101f51:	00 
  101f52:	c7 04 24 91 64 10 00 	movl   $0x106491,(%esp)
  101f59:	e8 9b e4 ff ff       	call   1003f9 <__panic>
        break;
  101f5e:	90                   	nop
  101f5f:	eb 07                	jmp    101f68 <trap_dispatch+0x284>
        break;
  101f61:	90                   	nop
  101f62:	eb 04                	jmp    101f68 <trap_dispatch+0x284>
        break;
  101f64:	90                   	nop
  101f65:	eb 01                	jmp    101f68 <trap_dispatch+0x284>
        break;
  101f67:	90                   	nop
        }
    }
}
  101f68:	90                   	nop
  101f69:	83 c4 2c             	add    $0x2c,%esp
  101f6c:	5b                   	pop    %ebx
  101f6d:	5e                   	pop    %esi
  101f6e:	5f                   	pop    %edi
  101f6f:	5d                   	pop    %ebp
  101f70:	c3                   	ret    

00101f71 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f71:	55                   	push   %ebp
  101f72:	89 e5                	mov    %esp,%ebp
  101f74:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f77:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7a:	89 04 24             	mov    %eax,(%esp)
  101f7d:	e8 62 fd ff ff       	call   101ce4 <trap_dispatch>
}
  101f82:	90                   	nop
  101f83:	c9                   	leave  
  101f84:	c3                   	ret    

00101f85 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $0
  101f87:	6a 00                	push   $0x0
  jmp __alltraps
  101f89:	e9 69 0a 00 00       	jmp    1029f7 <__alltraps>

00101f8e <vector1>:
.globl vector1
vector1:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $1
  101f90:	6a 01                	push   $0x1
  jmp __alltraps
  101f92:	e9 60 0a 00 00       	jmp    1029f7 <__alltraps>

00101f97 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $2
  101f99:	6a 02                	push   $0x2
  jmp __alltraps
  101f9b:	e9 57 0a 00 00       	jmp    1029f7 <__alltraps>

00101fa0 <vector3>:
.globl vector3
vector3:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $3
  101fa2:	6a 03                	push   $0x3
  jmp __alltraps
  101fa4:	e9 4e 0a 00 00       	jmp    1029f7 <__alltraps>

00101fa9 <vector4>:
.globl vector4
vector4:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $4
  101fab:	6a 04                	push   $0x4
  jmp __alltraps
  101fad:	e9 45 0a 00 00       	jmp    1029f7 <__alltraps>

00101fb2 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $5
  101fb4:	6a 05                	push   $0x5
  jmp __alltraps
  101fb6:	e9 3c 0a 00 00       	jmp    1029f7 <__alltraps>

00101fbb <vector6>:
.globl vector6
vector6:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $6
  101fbd:	6a 06                	push   $0x6
  jmp __alltraps
  101fbf:	e9 33 0a 00 00       	jmp    1029f7 <__alltraps>

00101fc4 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $7
  101fc6:	6a 07                	push   $0x7
  jmp __alltraps
  101fc8:	e9 2a 0a 00 00       	jmp    1029f7 <__alltraps>

00101fcd <vector8>:
.globl vector8
vector8:
  pushl $8
  101fcd:	6a 08                	push   $0x8
  jmp __alltraps
  101fcf:	e9 23 0a 00 00       	jmp    1029f7 <__alltraps>

00101fd4 <vector9>:
.globl vector9
vector9:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $9
  101fd6:	6a 09                	push   $0x9
  jmp __alltraps
  101fd8:	e9 1a 0a 00 00       	jmp    1029f7 <__alltraps>

00101fdd <vector10>:
.globl vector10
vector10:
  pushl $10
  101fdd:	6a 0a                	push   $0xa
  jmp __alltraps
  101fdf:	e9 13 0a 00 00       	jmp    1029f7 <__alltraps>

00101fe4 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fe4:	6a 0b                	push   $0xb
  jmp __alltraps
  101fe6:	e9 0c 0a 00 00       	jmp    1029f7 <__alltraps>

00101feb <vector12>:
.globl vector12
vector12:
  pushl $12
  101feb:	6a 0c                	push   $0xc
  jmp __alltraps
  101fed:	e9 05 0a 00 00       	jmp    1029f7 <__alltraps>

00101ff2 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ff2:	6a 0d                	push   $0xd
  jmp __alltraps
  101ff4:	e9 fe 09 00 00       	jmp    1029f7 <__alltraps>

00101ff9 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ff9:	6a 0e                	push   $0xe
  jmp __alltraps
  101ffb:	e9 f7 09 00 00       	jmp    1029f7 <__alltraps>

00102000 <vector15>:
.globl vector15
vector15:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $15
  102002:	6a 0f                	push   $0xf
  jmp __alltraps
  102004:	e9 ee 09 00 00       	jmp    1029f7 <__alltraps>

00102009 <vector16>:
.globl vector16
vector16:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $16
  10200b:	6a 10                	push   $0x10
  jmp __alltraps
  10200d:	e9 e5 09 00 00       	jmp    1029f7 <__alltraps>

00102012 <vector17>:
.globl vector17
vector17:
  pushl $17
  102012:	6a 11                	push   $0x11
  jmp __alltraps
  102014:	e9 de 09 00 00       	jmp    1029f7 <__alltraps>

00102019 <vector18>:
.globl vector18
vector18:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $18
  10201b:	6a 12                	push   $0x12
  jmp __alltraps
  10201d:	e9 d5 09 00 00       	jmp    1029f7 <__alltraps>

00102022 <vector19>:
.globl vector19
vector19:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $19
  102024:	6a 13                	push   $0x13
  jmp __alltraps
  102026:	e9 cc 09 00 00       	jmp    1029f7 <__alltraps>

0010202b <vector20>:
.globl vector20
vector20:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $20
  10202d:	6a 14                	push   $0x14
  jmp __alltraps
  10202f:	e9 c3 09 00 00       	jmp    1029f7 <__alltraps>

00102034 <vector21>:
.globl vector21
vector21:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $21
  102036:	6a 15                	push   $0x15
  jmp __alltraps
  102038:	e9 ba 09 00 00       	jmp    1029f7 <__alltraps>

0010203d <vector22>:
.globl vector22
vector22:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $22
  10203f:	6a 16                	push   $0x16
  jmp __alltraps
  102041:	e9 b1 09 00 00       	jmp    1029f7 <__alltraps>

00102046 <vector23>:
.globl vector23
vector23:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $23
  102048:	6a 17                	push   $0x17
  jmp __alltraps
  10204a:	e9 a8 09 00 00       	jmp    1029f7 <__alltraps>

0010204f <vector24>:
.globl vector24
vector24:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $24
  102051:	6a 18                	push   $0x18
  jmp __alltraps
  102053:	e9 9f 09 00 00       	jmp    1029f7 <__alltraps>

00102058 <vector25>:
.globl vector25
vector25:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $25
  10205a:	6a 19                	push   $0x19
  jmp __alltraps
  10205c:	e9 96 09 00 00       	jmp    1029f7 <__alltraps>

00102061 <vector26>:
.globl vector26
vector26:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $26
  102063:	6a 1a                	push   $0x1a
  jmp __alltraps
  102065:	e9 8d 09 00 00       	jmp    1029f7 <__alltraps>

0010206a <vector27>:
.globl vector27
vector27:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $27
  10206c:	6a 1b                	push   $0x1b
  jmp __alltraps
  10206e:	e9 84 09 00 00       	jmp    1029f7 <__alltraps>

00102073 <vector28>:
.globl vector28
vector28:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $28
  102075:	6a 1c                	push   $0x1c
  jmp __alltraps
  102077:	e9 7b 09 00 00       	jmp    1029f7 <__alltraps>

0010207c <vector29>:
.globl vector29
vector29:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $29
  10207e:	6a 1d                	push   $0x1d
  jmp __alltraps
  102080:	e9 72 09 00 00       	jmp    1029f7 <__alltraps>

00102085 <vector30>:
.globl vector30
vector30:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $30
  102087:	6a 1e                	push   $0x1e
  jmp __alltraps
  102089:	e9 69 09 00 00       	jmp    1029f7 <__alltraps>

0010208e <vector31>:
.globl vector31
vector31:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $31
  102090:	6a 1f                	push   $0x1f
  jmp __alltraps
  102092:	e9 60 09 00 00       	jmp    1029f7 <__alltraps>

00102097 <vector32>:
.globl vector32
vector32:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $32
  102099:	6a 20                	push   $0x20
  jmp __alltraps
  10209b:	e9 57 09 00 00       	jmp    1029f7 <__alltraps>

001020a0 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $33
  1020a2:	6a 21                	push   $0x21
  jmp __alltraps
  1020a4:	e9 4e 09 00 00       	jmp    1029f7 <__alltraps>

001020a9 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $34
  1020ab:	6a 22                	push   $0x22
  jmp __alltraps
  1020ad:	e9 45 09 00 00       	jmp    1029f7 <__alltraps>

001020b2 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $35
  1020b4:	6a 23                	push   $0x23
  jmp __alltraps
  1020b6:	e9 3c 09 00 00       	jmp    1029f7 <__alltraps>

001020bb <vector36>:
.globl vector36
vector36:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $36
  1020bd:	6a 24                	push   $0x24
  jmp __alltraps
  1020bf:	e9 33 09 00 00       	jmp    1029f7 <__alltraps>

001020c4 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $37
  1020c6:	6a 25                	push   $0x25
  jmp __alltraps
  1020c8:	e9 2a 09 00 00       	jmp    1029f7 <__alltraps>

001020cd <vector38>:
.globl vector38
vector38:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $38
  1020cf:	6a 26                	push   $0x26
  jmp __alltraps
  1020d1:	e9 21 09 00 00       	jmp    1029f7 <__alltraps>

001020d6 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $39
  1020d8:	6a 27                	push   $0x27
  jmp __alltraps
  1020da:	e9 18 09 00 00       	jmp    1029f7 <__alltraps>

001020df <vector40>:
.globl vector40
vector40:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $40
  1020e1:	6a 28                	push   $0x28
  jmp __alltraps
  1020e3:	e9 0f 09 00 00       	jmp    1029f7 <__alltraps>

001020e8 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $41
  1020ea:	6a 29                	push   $0x29
  jmp __alltraps
  1020ec:	e9 06 09 00 00       	jmp    1029f7 <__alltraps>

001020f1 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $42
  1020f3:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020f5:	e9 fd 08 00 00       	jmp    1029f7 <__alltraps>

001020fa <vector43>:
.globl vector43
vector43:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $43
  1020fc:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020fe:	e9 f4 08 00 00       	jmp    1029f7 <__alltraps>

00102103 <vector44>:
.globl vector44
vector44:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $44
  102105:	6a 2c                	push   $0x2c
  jmp __alltraps
  102107:	e9 eb 08 00 00       	jmp    1029f7 <__alltraps>

0010210c <vector45>:
.globl vector45
vector45:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $45
  10210e:	6a 2d                	push   $0x2d
  jmp __alltraps
  102110:	e9 e2 08 00 00       	jmp    1029f7 <__alltraps>

00102115 <vector46>:
.globl vector46
vector46:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $46
  102117:	6a 2e                	push   $0x2e
  jmp __alltraps
  102119:	e9 d9 08 00 00       	jmp    1029f7 <__alltraps>

0010211e <vector47>:
.globl vector47
vector47:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $47
  102120:	6a 2f                	push   $0x2f
  jmp __alltraps
  102122:	e9 d0 08 00 00       	jmp    1029f7 <__alltraps>

00102127 <vector48>:
.globl vector48
vector48:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $48
  102129:	6a 30                	push   $0x30
  jmp __alltraps
  10212b:	e9 c7 08 00 00       	jmp    1029f7 <__alltraps>

00102130 <vector49>:
.globl vector49
vector49:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $49
  102132:	6a 31                	push   $0x31
  jmp __alltraps
  102134:	e9 be 08 00 00       	jmp    1029f7 <__alltraps>

00102139 <vector50>:
.globl vector50
vector50:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $50
  10213b:	6a 32                	push   $0x32
  jmp __alltraps
  10213d:	e9 b5 08 00 00       	jmp    1029f7 <__alltraps>

00102142 <vector51>:
.globl vector51
vector51:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $51
  102144:	6a 33                	push   $0x33
  jmp __alltraps
  102146:	e9 ac 08 00 00       	jmp    1029f7 <__alltraps>

0010214b <vector52>:
.globl vector52
vector52:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $52
  10214d:	6a 34                	push   $0x34
  jmp __alltraps
  10214f:	e9 a3 08 00 00       	jmp    1029f7 <__alltraps>

00102154 <vector53>:
.globl vector53
vector53:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $53
  102156:	6a 35                	push   $0x35
  jmp __alltraps
  102158:	e9 9a 08 00 00       	jmp    1029f7 <__alltraps>

0010215d <vector54>:
.globl vector54
vector54:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $54
  10215f:	6a 36                	push   $0x36
  jmp __alltraps
  102161:	e9 91 08 00 00       	jmp    1029f7 <__alltraps>

00102166 <vector55>:
.globl vector55
vector55:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $55
  102168:	6a 37                	push   $0x37
  jmp __alltraps
  10216a:	e9 88 08 00 00       	jmp    1029f7 <__alltraps>

0010216f <vector56>:
.globl vector56
vector56:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $56
  102171:	6a 38                	push   $0x38
  jmp __alltraps
  102173:	e9 7f 08 00 00       	jmp    1029f7 <__alltraps>

00102178 <vector57>:
.globl vector57
vector57:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $57
  10217a:	6a 39                	push   $0x39
  jmp __alltraps
  10217c:	e9 76 08 00 00       	jmp    1029f7 <__alltraps>

00102181 <vector58>:
.globl vector58
vector58:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $58
  102183:	6a 3a                	push   $0x3a
  jmp __alltraps
  102185:	e9 6d 08 00 00       	jmp    1029f7 <__alltraps>

0010218a <vector59>:
.globl vector59
vector59:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $59
  10218c:	6a 3b                	push   $0x3b
  jmp __alltraps
  10218e:	e9 64 08 00 00       	jmp    1029f7 <__alltraps>

00102193 <vector60>:
.globl vector60
vector60:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $60
  102195:	6a 3c                	push   $0x3c
  jmp __alltraps
  102197:	e9 5b 08 00 00       	jmp    1029f7 <__alltraps>

0010219c <vector61>:
.globl vector61
vector61:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $61
  10219e:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021a0:	e9 52 08 00 00       	jmp    1029f7 <__alltraps>

001021a5 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $62
  1021a7:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021a9:	e9 49 08 00 00       	jmp    1029f7 <__alltraps>

001021ae <vector63>:
.globl vector63
vector63:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $63
  1021b0:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021b2:	e9 40 08 00 00       	jmp    1029f7 <__alltraps>

001021b7 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $64
  1021b9:	6a 40                	push   $0x40
  jmp __alltraps
  1021bb:	e9 37 08 00 00       	jmp    1029f7 <__alltraps>

001021c0 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $65
  1021c2:	6a 41                	push   $0x41
  jmp __alltraps
  1021c4:	e9 2e 08 00 00       	jmp    1029f7 <__alltraps>

001021c9 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $66
  1021cb:	6a 42                	push   $0x42
  jmp __alltraps
  1021cd:	e9 25 08 00 00       	jmp    1029f7 <__alltraps>

001021d2 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $67
  1021d4:	6a 43                	push   $0x43
  jmp __alltraps
  1021d6:	e9 1c 08 00 00       	jmp    1029f7 <__alltraps>

001021db <vector68>:
.globl vector68
vector68:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $68
  1021dd:	6a 44                	push   $0x44
  jmp __alltraps
  1021df:	e9 13 08 00 00       	jmp    1029f7 <__alltraps>

001021e4 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $69
  1021e6:	6a 45                	push   $0x45
  jmp __alltraps
  1021e8:	e9 0a 08 00 00       	jmp    1029f7 <__alltraps>

001021ed <vector70>:
.globl vector70
vector70:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $70
  1021ef:	6a 46                	push   $0x46
  jmp __alltraps
  1021f1:	e9 01 08 00 00       	jmp    1029f7 <__alltraps>

001021f6 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $71
  1021f8:	6a 47                	push   $0x47
  jmp __alltraps
  1021fa:	e9 f8 07 00 00       	jmp    1029f7 <__alltraps>

001021ff <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $72
  102201:	6a 48                	push   $0x48
  jmp __alltraps
  102203:	e9 ef 07 00 00       	jmp    1029f7 <__alltraps>

00102208 <vector73>:
.globl vector73
vector73:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $73
  10220a:	6a 49                	push   $0x49
  jmp __alltraps
  10220c:	e9 e6 07 00 00       	jmp    1029f7 <__alltraps>

00102211 <vector74>:
.globl vector74
vector74:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $74
  102213:	6a 4a                	push   $0x4a
  jmp __alltraps
  102215:	e9 dd 07 00 00       	jmp    1029f7 <__alltraps>

0010221a <vector75>:
.globl vector75
vector75:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $75
  10221c:	6a 4b                	push   $0x4b
  jmp __alltraps
  10221e:	e9 d4 07 00 00       	jmp    1029f7 <__alltraps>

00102223 <vector76>:
.globl vector76
vector76:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $76
  102225:	6a 4c                	push   $0x4c
  jmp __alltraps
  102227:	e9 cb 07 00 00       	jmp    1029f7 <__alltraps>

0010222c <vector77>:
.globl vector77
vector77:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $77
  10222e:	6a 4d                	push   $0x4d
  jmp __alltraps
  102230:	e9 c2 07 00 00       	jmp    1029f7 <__alltraps>

00102235 <vector78>:
.globl vector78
vector78:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $78
  102237:	6a 4e                	push   $0x4e
  jmp __alltraps
  102239:	e9 b9 07 00 00       	jmp    1029f7 <__alltraps>

0010223e <vector79>:
.globl vector79
vector79:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $79
  102240:	6a 4f                	push   $0x4f
  jmp __alltraps
  102242:	e9 b0 07 00 00       	jmp    1029f7 <__alltraps>

00102247 <vector80>:
.globl vector80
vector80:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $80
  102249:	6a 50                	push   $0x50
  jmp __alltraps
  10224b:	e9 a7 07 00 00       	jmp    1029f7 <__alltraps>

00102250 <vector81>:
.globl vector81
vector81:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $81
  102252:	6a 51                	push   $0x51
  jmp __alltraps
  102254:	e9 9e 07 00 00       	jmp    1029f7 <__alltraps>

00102259 <vector82>:
.globl vector82
vector82:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $82
  10225b:	6a 52                	push   $0x52
  jmp __alltraps
  10225d:	e9 95 07 00 00       	jmp    1029f7 <__alltraps>

00102262 <vector83>:
.globl vector83
vector83:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $83
  102264:	6a 53                	push   $0x53
  jmp __alltraps
  102266:	e9 8c 07 00 00       	jmp    1029f7 <__alltraps>

0010226b <vector84>:
.globl vector84
vector84:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $84
  10226d:	6a 54                	push   $0x54
  jmp __alltraps
  10226f:	e9 83 07 00 00       	jmp    1029f7 <__alltraps>

00102274 <vector85>:
.globl vector85
vector85:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $85
  102276:	6a 55                	push   $0x55
  jmp __alltraps
  102278:	e9 7a 07 00 00       	jmp    1029f7 <__alltraps>

0010227d <vector86>:
.globl vector86
vector86:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $86
  10227f:	6a 56                	push   $0x56
  jmp __alltraps
  102281:	e9 71 07 00 00       	jmp    1029f7 <__alltraps>

00102286 <vector87>:
.globl vector87
vector87:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $87
  102288:	6a 57                	push   $0x57
  jmp __alltraps
  10228a:	e9 68 07 00 00       	jmp    1029f7 <__alltraps>

0010228f <vector88>:
.globl vector88
vector88:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $88
  102291:	6a 58                	push   $0x58
  jmp __alltraps
  102293:	e9 5f 07 00 00       	jmp    1029f7 <__alltraps>

00102298 <vector89>:
.globl vector89
vector89:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $89
  10229a:	6a 59                	push   $0x59
  jmp __alltraps
  10229c:	e9 56 07 00 00       	jmp    1029f7 <__alltraps>

001022a1 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $90
  1022a3:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022a5:	e9 4d 07 00 00       	jmp    1029f7 <__alltraps>

001022aa <vector91>:
.globl vector91
vector91:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $91
  1022ac:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022ae:	e9 44 07 00 00       	jmp    1029f7 <__alltraps>

001022b3 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $92
  1022b5:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022b7:	e9 3b 07 00 00       	jmp    1029f7 <__alltraps>

001022bc <vector93>:
.globl vector93
vector93:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $93
  1022be:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022c0:	e9 32 07 00 00       	jmp    1029f7 <__alltraps>

001022c5 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $94
  1022c7:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022c9:	e9 29 07 00 00       	jmp    1029f7 <__alltraps>

001022ce <vector95>:
.globl vector95
vector95:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $95
  1022d0:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022d2:	e9 20 07 00 00       	jmp    1029f7 <__alltraps>

001022d7 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $96
  1022d9:	6a 60                	push   $0x60
  jmp __alltraps
  1022db:	e9 17 07 00 00       	jmp    1029f7 <__alltraps>

001022e0 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $97
  1022e2:	6a 61                	push   $0x61
  jmp __alltraps
  1022e4:	e9 0e 07 00 00       	jmp    1029f7 <__alltraps>

001022e9 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $98
  1022eb:	6a 62                	push   $0x62
  jmp __alltraps
  1022ed:	e9 05 07 00 00       	jmp    1029f7 <__alltraps>

001022f2 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $99
  1022f4:	6a 63                	push   $0x63
  jmp __alltraps
  1022f6:	e9 fc 06 00 00       	jmp    1029f7 <__alltraps>

001022fb <vector100>:
.globl vector100
vector100:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $100
  1022fd:	6a 64                	push   $0x64
  jmp __alltraps
  1022ff:	e9 f3 06 00 00       	jmp    1029f7 <__alltraps>

00102304 <vector101>:
.globl vector101
vector101:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $101
  102306:	6a 65                	push   $0x65
  jmp __alltraps
  102308:	e9 ea 06 00 00       	jmp    1029f7 <__alltraps>

0010230d <vector102>:
.globl vector102
vector102:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $102
  10230f:	6a 66                	push   $0x66
  jmp __alltraps
  102311:	e9 e1 06 00 00       	jmp    1029f7 <__alltraps>

00102316 <vector103>:
.globl vector103
vector103:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $103
  102318:	6a 67                	push   $0x67
  jmp __alltraps
  10231a:	e9 d8 06 00 00       	jmp    1029f7 <__alltraps>

0010231f <vector104>:
.globl vector104
vector104:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $104
  102321:	6a 68                	push   $0x68
  jmp __alltraps
  102323:	e9 cf 06 00 00       	jmp    1029f7 <__alltraps>

00102328 <vector105>:
.globl vector105
vector105:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $105
  10232a:	6a 69                	push   $0x69
  jmp __alltraps
  10232c:	e9 c6 06 00 00       	jmp    1029f7 <__alltraps>

00102331 <vector106>:
.globl vector106
vector106:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $106
  102333:	6a 6a                	push   $0x6a
  jmp __alltraps
  102335:	e9 bd 06 00 00       	jmp    1029f7 <__alltraps>

0010233a <vector107>:
.globl vector107
vector107:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $107
  10233c:	6a 6b                	push   $0x6b
  jmp __alltraps
  10233e:	e9 b4 06 00 00       	jmp    1029f7 <__alltraps>

00102343 <vector108>:
.globl vector108
vector108:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $108
  102345:	6a 6c                	push   $0x6c
  jmp __alltraps
  102347:	e9 ab 06 00 00       	jmp    1029f7 <__alltraps>

0010234c <vector109>:
.globl vector109
vector109:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $109
  10234e:	6a 6d                	push   $0x6d
  jmp __alltraps
  102350:	e9 a2 06 00 00       	jmp    1029f7 <__alltraps>

00102355 <vector110>:
.globl vector110
vector110:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $110
  102357:	6a 6e                	push   $0x6e
  jmp __alltraps
  102359:	e9 99 06 00 00       	jmp    1029f7 <__alltraps>

0010235e <vector111>:
.globl vector111
vector111:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $111
  102360:	6a 6f                	push   $0x6f
  jmp __alltraps
  102362:	e9 90 06 00 00       	jmp    1029f7 <__alltraps>

00102367 <vector112>:
.globl vector112
vector112:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $112
  102369:	6a 70                	push   $0x70
  jmp __alltraps
  10236b:	e9 87 06 00 00       	jmp    1029f7 <__alltraps>

00102370 <vector113>:
.globl vector113
vector113:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $113
  102372:	6a 71                	push   $0x71
  jmp __alltraps
  102374:	e9 7e 06 00 00       	jmp    1029f7 <__alltraps>

00102379 <vector114>:
.globl vector114
vector114:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $114
  10237b:	6a 72                	push   $0x72
  jmp __alltraps
  10237d:	e9 75 06 00 00       	jmp    1029f7 <__alltraps>

00102382 <vector115>:
.globl vector115
vector115:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $115
  102384:	6a 73                	push   $0x73
  jmp __alltraps
  102386:	e9 6c 06 00 00       	jmp    1029f7 <__alltraps>

0010238b <vector116>:
.globl vector116
vector116:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $116
  10238d:	6a 74                	push   $0x74
  jmp __alltraps
  10238f:	e9 63 06 00 00       	jmp    1029f7 <__alltraps>

00102394 <vector117>:
.globl vector117
vector117:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $117
  102396:	6a 75                	push   $0x75
  jmp __alltraps
  102398:	e9 5a 06 00 00       	jmp    1029f7 <__alltraps>

0010239d <vector118>:
.globl vector118
vector118:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $118
  10239f:	6a 76                	push   $0x76
  jmp __alltraps
  1023a1:	e9 51 06 00 00       	jmp    1029f7 <__alltraps>

001023a6 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $119
  1023a8:	6a 77                	push   $0x77
  jmp __alltraps
  1023aa:	e9 48 06 00 00       	jmp    1029f7 <__alltraps>

001023af <vector120>:
.globl vector120
vector120:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $120
  1023b1:	6a 78                	push   $0x78
  jmp __alltraps
  1023b3:	e9 3f 06 00 00       	jmp    1029f7 <__alltraps>

001023b8 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $121
  1023ba:	6a 79                	push   $0x79
  jmp __alltraps
  1023bc:	e9 36 06 00 00       	jmp    1029f7 <__alltraps>

001023c1 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $122
  1023c3:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023c5:	e9 2d 06 00 00       	jmp    1029f7 <__alltraps>

001023ca <vector123>:
.globl vector123
vector123:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $123
  1023cc:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023ce:	e9 24 06 00 00       	jmp    1029f7 <__alltraps>

001023d3 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $124
  1023d5:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023d7:	e9 1b 06 00 00       	jmp    1029f7 <__alltraps>

001023dc <vector125>:
.globl vector125
vector125:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $125
  1023de:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023e0:	e9 12 06 00 00       	jmp    1029f7 <__alltraps>

001023e5 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $126
  1023e7:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023e9:	e9 09 06 00 00       	jmp    1029f7 <__alltraps>

001023ee <vector127>:
.globl vector127
vector127:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $127
  1023f0:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023f2:	e9 00 06 00 00       	jmp    1029f7 <__alltraps>

001023f7 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $128
  1023f9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023fe:	e9 f4 05 00 00       	jmp    1029f7 <__alltraps>

00102403 <vector129>:
.globl vector129
vector129:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $129
  102405:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10240a:	e9 e8 05 00 00       	jmp    1029f7 <__alltraps>

0010240f <vector130>:
.globl vector130
vector130:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $130
  102411:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102416:	e9 dc 05 00 00       	jmp    1029f7 <__alltraps>

0010241b <vector131>:
.globl vector131
vector131:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $131
  10241d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102422:	e9 d0 05 00 00       	jmp    1029f7 <__alltraps>

00102427 <vector132>:
.globl vector132
vector132:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $132
  102429:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10242e:	e9 c4 05 00 00       	jmp    1029f7 <__alltraps>

00102433 <vector133>:
.globl vector133
vector133:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $133
  102435:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10243a:	e9 b8 05 00 00       	jmp    1029f7 <__alltraps>

0010243f <vector134>:
.globl vector134
vector134:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $134
  102441:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102446:	e9 ac 05 00 00       	jmp    1029f7 <__alltraps>

0010244b <vector135>:
.globl vector135
vector135:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $135
  10244d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102452:	e9 a0 05 00 00       	jmp    1029f7 <__alltraps>

00102457 <vector136>:
.globl vector136
vector136:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $136
  102459:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10245e:	e9 94 05 00 00       	jmp    1029f7 <__alltraps>

00102463 <vector137>:
.globl vector137
vector137:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $137
  102465:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10246a:	e9 88 05 00 00       	jmp    1029f7 <__alltraps>

0010246f <vector138>:
.globl vector138
vector138:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $138
  102471:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102476:	e9 7c 05 00 00       	jmp    1029f7 <__alltraps>

0010247b <vector139>:
.globl vector139
vector139:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $139
  10247d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102482:	e9 70 05 00 00       	jmp    1029f7 <__alltraps>

00102487 <vector140>:
.globl vector140
vector140:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $140
  102489:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10248e:	e9 64 05 00 00       	jmp    1029f7 <__alltraps>

00102493 <vector141>:
.globl vector141
vector141:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $141
  102495:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10249a:	e9 58 05 00 00       	jmp    1029f7 <__alltraps>

0010249f <vector142>:
.globl vector142
vector142:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $142
  1024a1:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024a6:	e9 4c 05 00 00       	jmp    1029f7 <__alltraps>

001024ab <vector143>:
.globl vector143
vector143:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $143
  1024ad:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024b2:	e9 40 05 00 00       	jmp    1029f7 <__alltraps>

001024b7 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $144
  1024b9:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024be:	e9 34 05 00 00       	jmp    1029f7 <__alltraps>

001024c3 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $145
  1024c5:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024ca:	e9 28 05 00 00       	jmp    1029f7 <__alltraps>

001024cf <vector146>:
.globl vector146
vector146:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $146
  1024d1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024d6:	e9 1c 05 00 00       	jmp    1029f7 <__alltraps>

001024db <vector147>:
.globl vector147
vector147:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $147
  1024dd:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024e2:	e9 10 05 00 00       	jmp    1029f7 <__alltraps>

001024e7 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $148
  1024e9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024ee:	e9 04 05 00 00       	jmp    1029f7 <__alltraps>

001024f3 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $149
  1024f5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024fa:	e9 f8 04 00 00       	jmp    1029f7 <__alltraps>

001024ff <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $150
  102501:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102506:	e9 ec 04 00 00       	jmp    1029f7 <__alltraps>

0010250b <vector151>:
.globl vector151
vector151:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $151
  10250d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102512:	e9 e0 04 00 00       	jmp    1029f7 <__alltraps>

00102517 <vector152>:
.globl vector152
vector152:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $152
  102519:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10251e:	e9 d4 04 00 00       	jmp    1029f7 <__alltraps>

00102523 <vector153>:
.globl vector153
vector153:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $153
  102525:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10252a:	e9 c8 04 00 00       	jmp    1029f7 <__alltraps>

0010252f <vector154>:
.globl vector154
vector154:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $154
  102531:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102536:	e9 bc 04 00 00       	jmp    1029f7 <__alltraps>

0010253b <vector155>:
.globl vector155
vector155:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $155
  10253d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102542:	e9 b0 04 00 00       	jmp    1029f7 <__alltraps>

00102547 <vector156>:
.globl vector156
vector156:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $156
  102549:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10254e:	e9 a4 04 00 00       	jmp    1029f7 <__alltraps>

00102553 <vector157>:
.globl vector157
vector157:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $157
  102555:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10255a:	e9 98 04 00 00       	jmp    1029f7 <__alltraps>

0010255f <vector158>:
.globl vector158
vector158:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $158
  102561:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102566:	e9 8c 04 00 00       	jmp    1029f7 <__alltraps>

0010256b <vector159>:
.globl vector159
vector159:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $159
  10256d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102572:	e9 80 04 00 00       	jmp    1029f7 <__alltraps>

00102577 <vector160>:
.globl vector160
vector160:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $160
  102579:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10257e:	e9 74 04 00 00       	jmp    1029f7 <__alltraps>

00102583 <vector161>:
.globl vector161
vector161:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $161
  102585:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10258a:	e9 68 04 00 00       	jmp    1029f7 <__alltraps>

0010258f <vector162>:
.globl vector162
vector162:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $162
  102591:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102596:	e9 5c 04 00 00       	jmp    1029f7 <__alltraps>

0010259b <vector163>:
.globl vector163
vector163:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $163
  10259d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025a2:	e9 50 04 00 00       	jmp    1029f7 <__alltraps>

001025a7 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $164
  1025a9:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025ae:	e9 44 04 00 00       	jmp    1029f7 <__alltraps>

001025b3 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $165
  1025b5:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025ba:	e9 38 04 00 00       	jmp    1029f7 <__alltraps>

001025bf <vector166>:
.globl vector166
vector166:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $166
  1025c1:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025c6:	e9 2c 04 00 00       	jmp    1029f7 <__alltraps>

001025cb <vector167>:
.globl vector167
vector167:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $167
  1025cd:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025d2:	e9 20 04 00 00       	jmp    1029f7 <__alltraps>

001025d7 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $168
  1025d9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025de:	e9 14 04 00 00       	jmp    1029f7 <__alltraps>

001025e3 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $169
  1025e5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025ea:	e9 08 04 00 00       	jmp    1029f7 <__alltraps>

001025ef <vector170>:
.globl vector170
vector170:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $170
  1025f1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025f6:	e9 fc 03 00 00       	jmp    1029f7 <__alltraps>

001025fb <vector171>:
.globl vector171
vector171:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $171
  1025fd:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102602:	e9 f0 03 00 00       	jmp    1029f7 <__alltraps>

00102607 <vector172>:
.globl vector172
vector172:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $172
  102609:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10260e:	e9 e4 03 00 00       	jmp    1029f7 <__alltraps>

00102613 <vector173>:
.globl vector173
vector173:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $173
  102615:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10261a:	e9 d8 03 00 00       	jmp    1029f7 <__alltraps>

0010261f <vector174>:
.globl vector174
vector174:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $174
  102621:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102626:	e9 cc 03 00 00       	jmp    1029f7 <__alltraps>

0010262b <vector175>:
.globl vector175
vector175:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $175
  10262d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102632:	e9 c0 03 00 00       	jmp    1029f7 <__alltraps>

00102637 <vector176>:
.globl vector176
vector176:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $176
  102639:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10263e:	e9 b4 03 00 00       	jmp    1029f7 <__alltraps>

00102643 <vector177>:
.globl vector177
vector177:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $177
  102645:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10264a:	e9 a8 03 00 00       	jmp    1029f7 <__alltraps>

0010264f <vector178>:
.globl vector178
vector178:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $178
  102651:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102656:	e9 9c 03 00 00       	jmp    1029f7 <__alltraps>

0010265b <vector179>:
.globl vector179
vector179:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $179
  10265d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102662:	e9 90 03 00 00       	jmp    1029f7 <__alltraps>

00102667 <vector180>:
.globl vector180
vector180:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $180
  102669:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10266e:	e9 84 03 00 00       	jmp    1029f7 <__alltraps>

00102673 <vector181>:
.globl vector181
vector181:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $181
  102675:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10267a:	e9 78 03 00 00       	jmp    1029f7 <__alltraps>

0010267f <vector182>:
.globl vector182
vector182:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $182
  102681:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102686:	e9 6c 03 00 00       	jmp    1029f7 <__alltraps>

0010268b <vector183>:
.globl vector183
vector183:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $183
  10268d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102692:	e9 60 03 00 00       	jmp    1029f7 <__alltraps>

00102697 <vector184>:
.globl vector184
vector184:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $184
  102699:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10269e:	e9 54 03 00 00       	jmp    1029f7 <__alltraps>

001026a3 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $185
  1026a5:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026aa:	e9 48 03 00 00       	jmp    1029f7 <__alltraps>

001026af <vector186>:
.globl vector186
vector186:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $186
  1026b1:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026b6:	e9 3c 03 00 00       	jmp    1029f7 <__alltraps>

001026bb <vector187>:
.globl vector187
vector187:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $187
  1026bd:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026c2:	e9 30 03 00 00       	jmp    1029f7 <__alltraps>

001026c7 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $188
  1026c9:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026ce:	e9 24 03 00 00       	jmp    1029f7 <__alltraps>

001026d3 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $189
  1026d5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026da:	e9 18 03 00 00       	jmp    1029f7 <__alltraps>

001026df <vector190>:
.globl vector190
vector190:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $190
  1026e1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026e6:	e9 0c 03 00 00       	jmp    1029f7 <__alltraps>

001026eb <vector191>:
.globl vector191
vector191:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $191
  1026ed:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026f2:	e9 00 03 00 00       	jmp    1029f7 <__alltraps>

001026f7 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $192
  1026f9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026fe:	e9 f4 02 00 00       	jmp    1029f7 <__alltraps>

00102703 <vector193>:
.globl vector193
vector193:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $193
  102705:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10270a:	e9 e8 02 00 00       	jmp    1029f7 <__alltraps>

0010270f <vector194>:
.globl vector194
vector194:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $194
  102711:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102716:	e9 dc 02 00 00       	jmp    1029f7 <__alltraps>

0010271b <vector195>:
.globl vector195
vector195:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $195
  10271d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102722:	e9 d0 02 00 00       	jmp    1029f7 <__alltraps>

00102727 <vector196>:
.globl vector196
vector196:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $196
  102729:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10272e:	e9 c4 02 00 00       	jmp    1029f7 <__alltraps>

00102733 <vector197>:
.globl vector197
vector197:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $197
  102735:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10273a:	e9 b8 02 00 00       	jmp    1029f7 <__alltraps>

0010273f <vector198>:
.globl vector198
vector198:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $198
  102741:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102746:	e9 ac 02 00 00       	jmp    1029f7 <__alltraps>

0010274b <vector199>:
.globl vector199
vector199:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $199
  10274d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102752:	e9 a0 02 00 00       	jmp    1029f7 <__alltraps>

00102757 <vector200>:
.globl vector200
vector200:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $200
  102759:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10275e:	e9 94 02 00 00       	jmp    1029f7 <__alltraps>

00102763 <vector201>:
.globl vector201
vector201:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $201
  102765:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10276a:	e9 88 02 00 00       	jmp    1029f7 <__alltraps>

0010276f <vector202>:
.globl vector202
vector202:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $202
  102771:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102776:	e9 7c 02 00 00       	jmp    1029f7 <__alltraps>

0010277b <vector203>:
.globl vector203
vector203:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $203
  10277d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102782:	e9 70 02 00 00       	jmp    1029f7 <__alltraps>

00102787 <vector204>:
.globl vector204
vector204:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $204
  102789:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10278e:	e9 64 02 00 00       	jmp    1029f7 <__alltraps>

00102793 <vector205>:
.globl vector205
vector205:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $205
  102795:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10279a:	e9 58 02 00 00       	jmp    1029f7 <__alltraps>

0010279f <vector206>:
.globl vector206
vector206:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $206
  1027a1:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027a6:	e9 4c 02 00 00       	jmp    1029f7 <__alltraps>

001027ab <vector207>:
.globl vector207
vector207:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $207
  1027ad:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027b2:	e9 40 02 00 00       	jmp    1029f7 <__alltraps>

001027b7 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $208
  1027b9:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027be:	e9 34 02 00 00       	jmp    1029f7 <__alltraps>

001027c3 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $209
  1027c5:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027ca:	e9 28 02 00 00       	jmp    1029f7 <__alltraps>

001027cf <vector210>:
.globl vector210
vector210:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $210
  1027d1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027d6:	e9 1c 02 00 00       	jmp    1029f7 <__alltraps>

001027db <vector211>:
.globl vector211
vector211:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $211
  1027dd:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027e2:	e9 10 02 00 00       	jmp    1029f7 <__alltraps>

001027e7 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $212
  1027e9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027ee:	e9 04 02 00 00       	jmp    1029f7 <__alltraps>

001027f3 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $213
  1027f5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027fa:	e9 f8 01 00 00       	jmp    1029f7 <__alltraps>

001027ff <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $214
  102801:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102806:	e9 ec 01 00 00       	jmp    1029f7 <__alltraps>

0010280b <vector215>:
.globl vector215
vector215:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $215
  10280d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102812:	e9 e0 01 00 00       	jmp    1029f7 <__alltraps>

00102817 <vector216>:
.globl vector216
vector216:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $216
  102819:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10281e:	e9 d4 01 00 00       	jmp    1029f7 <__alltraps>

00102823 <vector217>:
.globl vector217
vector217:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $217
  102825:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10282a:	e9 c8 01 00 00       	jmp    1029f7 <__alltraps>

0010282f <vector218>:
.globl vector218
vector218:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $218
  102831:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102836:	e9 bc 01 00 00       	jmp    1029f7 <__alltraps>

0010283b <vector219>:
.globl vector219
vector219:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $219
  10283d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102842:	e9 b0 01 00 00       	jmp    1029f7 <__alltraps>

00102847 <vector220>:
.globl vector220
vector220:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $220
  102849:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10284e:	e9 a4 01 00 00       	jmp    1029f7 <__alltraps>

00102853 <vector221>:
.globl vector221
vector221:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $221
  102855:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10285a:	e9 98 01 00 00       	jmp    1029f7 <__alltraps>

0010285f <vector222>:
.globl vector222
vector222:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $222
  102861:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102866:	e9 8c 01 00 00       	jmp    1029f7 <__alltraps>

0010286b <vector223>:
.globl vector223
vector223:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $223
  10286d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102872:	e9 80 01 00 00       	jmp    1029f7 <__alltraps>

00102877 <vector224>:
.globl vector224
vector224:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $224
  102879:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10287e:	e9 74 01 00 00       	jmp    1029f7 <__alltraps>

00102883 <vector225>:
.globl vector225
vector225:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $225
  102885:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10288a:	e9 68 01 00 00       	jmp    1029f7 <__alltraps>

0010288f <vector226>:
.globl vector226
vector226:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $226
  102891:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102896:	e9 5c 01 00 00       	jmp    1029f7 <__alltraps>

0010289b <vector227>:
.globl vector227
vector227:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $227
  10289d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028a2:	e9 50 01 00 00       	jmp    1029f7 <__alltraps>

001028a7 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $228
  1028a9:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028ae:	e9 44 01 00 00       	jmp    1029f7 <__alltraps>

001028b3 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $229
  1028b5:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028ba:	e9 38 01 00 00       	jmp    1029f7 <__alltraps>

001028bf <vector230>:
.globl vector230
vector230:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $230
  1028c1:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028c6:	e9 2c 01 00 00       	jmp    1029f7 <__alltraps>

001028cb <vector231>:
.globl vector231
vector231:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $231
  1028cd:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028d2:	e9 20 01 00 00       	jmp    1029f7 <__alltraps>

001028d7 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $232
  1028d9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028de:	e9 14 01 00 00       	jmp    1029f7 <__alltraps>

001028e3 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $233
  1028e5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028ea:	e9 08 01 00 00       	jmp    1029f7 <__alltraps>

001028ef <vector234>:
.globl vector234
vector234:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $234
  1028f1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028f6:	e9 fc 00 00 00       	jmp    1029f7 <__alltraps>

001028fb <vector235>:
.globl vector235
vector235:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $235
  1028fd:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102902:	e9 f0 00 00 00       	jmp    1029f7 <__alltraps>

00102907 <vector236>:
.globl vector236
vector236:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $236
  102909:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10290e:	e9 e4 00 00 00       	jmp    1029f7 <__alltraps>

00102913 <vector237>:
.globl vector237
vector237:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $237
  102915:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10291a:	e9 d8 00 00 00       	jmp    1029f7 <__alltraps>

0010291f <vector238>:
.globl vector238
vector238:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $238
  102921:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102926:	e9 cc 00 00 00       	jmp    1029f7 <__alltraps>

0010292b <vector239>:
.globl vector239
vector239:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $239
  10292d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102932:	e9 c0 00 00 00       	jmp    1029f7 <__alltraps>

00102937 <vector240>:
.globl vector240
vector240:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $240
  102939:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10293e:	e9 b4 00 00 00       	jmp    1029f7 <__alltraps>

00102943 <vector241>:
.globl vector241
vector241:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $241
  102945:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10294a:	e9 a8 00 00 00       	jmp    1029f7 <__alltraps>

0010294f <vector242>:
.globl vector242
vector242:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $242
  102951:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102956:	e9 9c 00 00 00       	jmp    1029f7 <__alltraps>

0010295b <vector243>:
.globl vector243
vector243:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $243
  10295d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102962:	e9 90 00 00 00       	jmp    1029f7 <__alltraps>

00102967 <vector244>:
.globl vector244
vector244:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $244
  102969:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10296e:	e9 84 00 00 00       	jmp    1029f7 <__alltraps>

00102973 <vector245>:
.globl vector245
vector245:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $245
  102975:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10297a:	e9 78 00 00 00       	jmp    1029f7 <__alltraps>

0010297f <vector246>:
.globl vector246
vector246:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $246
  102981:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102986:	e9 6c 00 00 00       	jmp    1029f7 <__alltraps>

0010298b <vector247>:
.globl vector247
vector247:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $247
  10298d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102992:	e9 60 00 00 00       	jmp    1029f7 <__alltraps>

00102997 <vector248>:
.globl vector248
vector248:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $248
  102999:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10299e:	e9 54 00 00 00       	jmp    1029f7 <__alltraps>

001029a3 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $249
  1029a5:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029aa:	e9 48 00 00 00       	jmp    1029f7 <__alltraps>

001029af <vector250>:
.globl vector250
vector250:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $250
  1029b1:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029b6:	e9 3c 00 00 00       	jmp    1029f7 <__alltraps>

001029bb <vector251>:
.globl vector251
vector251:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $251
  1029bd:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029c2:	e9 30 00 00 00       	jmp    1029f7 <__alltraps>

001029c7 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $252
  1029c9:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029ce:	e9 24 00 00 00       	jmp    1029f7 <__alltraps>

001029d3 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $253
  1029d5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029da:	e9 18 00 00 00       	jmp    1029f7 <__alltraps>

001029df <vector254>:
.globl vector254
vector254:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $254
  1029e1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029e6:	e9 0c 00 00 00       	jmp    1029f7 <__alltraps>

001029eb <vector255>:
.globl vector255
vector255:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $255
  1029ed:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029f2:	e9 00 00 00 00       	jmp    1029f7 <__alltraps>

001029f7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029f7:	1e                   	push   %ds
    pushl %es
  1029f8:	06                   	push   %es
    pushl %fs
  1029f9:	0f a0                	push   %fs
    pushl %gs
  1029fb:	0f a8                	push   %gs
    pushal
  1029fd:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029fe:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a03:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a05:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a07:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a08:	e8 64 f5 ff ff       	call   101f71 <trap>

    # pop the pushed stack pointer
    popl %esp
  102a0d:	5c                   	pop    %esp

00102a0e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a0e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a0f:	0f a9                	pop    %gs
    popl %fs
  102a11:	0f a1                	pop    %fs
    popl %es
  102a13:	07                   	pop    %es
    popl %ds
  102a14:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a15:	83 c4 08             	add    $0x8,%esp
    iret
  102a18:	cf                   	iret   

00102a19 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a19:	55                   	push   %ebp
  102a1a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1f:	8b 15 78 af 11 00    	mov    0x11af78,%edx
  102a25:	29 d0                	sub    %edx,%eax
  102a27:	c1 f8 02             	sar    $0x2,%eax
  102a2a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a30:	5d                   	pop    %ebp
  102a31:	c3                   	ret    

00102a32 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a32:	55                   	push   %ebp
  102a33:	89 e5                	mov    %esp,%ebp
  102a35:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a38:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3b:	89 04 24             	mov    %eax,(%esp)
  102a3e:	e8 d6 ff ff ff       	call   102a19 <page2ppn>
  102a43:	c1 e0 0c             	shl    $0xc,%eax
}
  102a46:	c9                   	leave  
  102a47:	c3                   	ret    

00102a48 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102a48:	55                   	push   %ebp
  102a49:	89 e5                	mov    %esp,%ebp
  102a4b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a51:	c1 e8 0c             	shr    $0xc,%eax
  102a54:	89 c2                	mov    %eax,%edx
  102a56:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102a5b:	39 c2                	cmp    %eax,%edx
  102a5d:	72 1c                	jb     102a7b <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102a5f:	c7 44 24 08 50 66 10 	movl   $0x106650,0x8(%esp)
  102a66:	00 
  102a67:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a6e:	00 
  102a6f:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  102a76:	e8 7e d9 ff ff       	call   1003f9 <__panic>
    }
    return &pages[PPN(pa)];
  102a7b:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  102a81:	8b 45 08             	mov    0x8(%ebp),%eax
  102a84:	c1 e8 0c             	shr    $0xc,%eax
  102a87:	89 c2                	mov    %eax,%edx
  102a89:	89 d0                	mov    %edx,%eax
  102a8b:	c1 e0 02             	shl    $0x2,%eax
  102a8e:	01 d0                	add    %edx,%eax
  102a90:	c1 e0 02             	shl    $0x2,%eax
  102a93:	01 c8                	add    %ecx,%eax
}
  102a95:	c9                   	leave  
  102a96:	c3                   	ret    

00102a97 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102a97:	55                   	push   %ebp
  102a98:	89 e5                	mov    %esp,%ebp
  102a9a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa0:	89 04 24             	mov    %eax,(%esp)
  102aa3:	e8 8a ff ff ff       	call   102a32 <page2pa>
  102aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aae:	c1 e8 0c             	shr    $0xc,%eax
  102ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ab4:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102ab9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102abc:	72 23                	jb     102ae1 <page2kva+0x4a>
  102abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ac5:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  102acc:	00 
  102acd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102ad4:	00 
  102ad5:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  102adc:	e8 18 d9 ff ff       	call   1003f9 <__panic>
  102ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102ae9:	c9                   	leave  
  102aea:	c3                   	ret    

00102aeb <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102aeb:	55                   	push   %ebp
  102aec:	89 e5                	mov    %esp,%ebp
  102aee:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102af1:	8b 45 08             	mov    0x8(%ebp),%eax
  102af4:	83 e0 01             	and    $0x1,%eax
  102af7:	85 c0                	test   %eax,%eax
  102af9:	75 1c                	jne    102b17 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102afb:	c7 44 24 08 a4 66 10 	movl   $0x1066a4,0x8(%esp)
  102b02:	00 
  102b03:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102b0a:	00 
  102b0b:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  102b12:	e8 e2 d8 ff ff       	call   1003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102b17:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b1f:	89 04 24             	mov    %eax,(%esp)
  102b22:	e8 21 ff ff ff       	call   102a48 <pa2page>
}
  102b27:	c9                   	leave  
  102b28:	c3                   	ret    

00102b29 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102b29:	55                   	push   %ebp
  102b2a:	89 e5                	mov    %esp,%ebp
  102b2c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b37:	89 04 24             	mov    %eax,(%esp)
  102b3a:	e8 09 ff ff ff       	call   102a48 <pa2page>
}
  102b3f:	c9                   	leave  
  102b40:	c3                   	ret    

00102b41 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b44:	8b 45 08             	mov    0x8(%ebp),%eax
  102b47:	8b 00                	mov    (%eax),%eax
}
  102b49:	5d                   	pop    %ebp
  102b4a:	c3                   	ret    

00102b4b <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102b4b:	55                   	push   %ebp
  102b4c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b51:	8b 00                	mov    (%eax),%eax
  102b53:	8d 50 01             	lea    0x1(%eax),%edx
  102b56:	8b 45 08             	mov    0x8(%ebp),%eax
  102b59:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5e:	8b 00                	mov    (%eax),%eax
}
  102b60:	5d                   	pop    %ebp
  102b61:	c3                   	ret    

00102b62 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b62:	55                   	push   %ebp
  102b63:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	8b 00                	mov    (%eax),%eax
  102b6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b70:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b72:	8b 45 08             	mov    0x8(%ebp),%eax
  102b75:	8b 00                	mov    (%eax),%eax
}
  102b77:	5d                   	pop    %ebp
  102b78:	c3                   	ret    

00102b79 <__intr_save>:
__intr_save(void) {
  102b79:	55                   	push   %ebp
  102b7a:	89 e5                	mov    %esp,%ebp
  102b7c:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102b7f:	9c                   	pushf  
  102b80:	58                   	pop    %eax
  102b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102b87:	25 00 02 00 00       	and    $0x200,%eax
  102b8c:	85 c0                	test   %eax,%eax
  102b8e:	74 0c                	je     102b9c <__intr_save+0x23>
        intr_disable();
  102b90:	e8 08 ed ff ff       	call   10189d <intr_disable>
        return 1;
  102b95:	b8 01 00 00 00       	mov    $0x1,%eax
  102b9a:	eb 05                	jmp    102ba1 <__intr_save+0x28>
    return 0;
  102b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ba1:	c9                   	leave  
  102ba2:	c3                   	ret    

00102ba3 <__intr_restore>:
__intr_restore(bool flag) {
  102ba3:	55                   	push   %ebp
  102ba4:	89 e5                	mov    %esp,%ebp
  102ba6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102ba9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102bad:	74 05                	je     102bb4 <__intr_restore+0x11>
        intr_enable();
  102baf:	e8 e2 ec ff ff       	call   101896 <intr_enable>
}
  102bb4:	90                   	nop
  102bb5:	c9                   	leave  
  102bb6:	c3                   	ret    

00102bb7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102bb7:	55                   	push   %ebp
  102bb8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102bba:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbd:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102bc0:	b8 23 00 00 00       	mov    $0x23,%eax
  102bc5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102bc7:	b8 23 00 00 00       	mov    $0x23,%eax
  102bcc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102bce:	b8 10 00 00 00       	mov    $0x10,%eax
  102bd3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102bd5:	b8 10 00 00 00       	mov    $0x10,%eax
  102bda:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102bdc:	b8 10 00 00 00       	mov    $0x10,%eax
  102be1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102be3:	ea ea 2b 10 00 08 00 	ljmp   $0x8,$0x102bea
}
  102bea:	90                   	nop
  102beb:	5d                   	pop    %ebp
  102bec:	c3                   	ret    

00102bed <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102bed:	55                   	push   %ebp
  102bee:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf3:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  102bf8:	90                   	nop
  102bf9:	5d                   	pop    %ebp
  102bfa:	c3                   	ret    

00102bfb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102bfb:	55                   	push   %ebp
  102bfc:	89 e5                	mov    %esp,%ebp
  102bfe:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102c01:	b8 00 70 11 00       	mov    $0x117000,%eax
  102c06:	89 04 24             	mov    %eax,(%esp)
  102c09:	e8 df ff ff ff       	call   102bed <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102c0e:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  102c15:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102c17:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102c1e:	68 00 
  102c20:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102c25:	0f b7 c0             	movzwl %ax,%eax
  102c28:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102c2e:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102c33:	c1 e8 10             	shr    $0x10,%eax
  102c36:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102c3b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c42:	24 f0                	and    $0xf0,%al
  102c44:	0c 09                	or     $0x9,%al
  102c46:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c4b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c52:	24 ef                	and    $0xef,%al
  102c54:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c59:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c60:	24 9f                	and    $0x9f,%al
  102c62:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c67:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c6e:	0c 80                	or     $0x80,%al
  102c70:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c75:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c7c:	24 f0                	and    $0xf0,%al
  102c7e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c83:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c8a:	24 ef                	and    $0xef,%al
  102c8c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c91:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c98:	24 df                	and    $0xdf,%al
  102c9a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c9f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102ca6:	0c 40                	or     $0x40,%al
  102ca8:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102cad:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102cb4:	24 7f                	and    $0x7f,%al
  102cb6:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102cbb:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102cc0:	c1 e8 18             	shr    $0x18,%eax
  102cc3:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102cc8:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102ccf:	e8 e3 fe ff ff       	call   102bb7 <lgdt>
  102cd4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102cda:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102cde:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102ce1:	90                   	nop
  102ce2:	c9                   	leave  
  102ce3:	c3                   	ret    

00102ce4 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102ce4:	55                   	push   %ebp
  102ce5:	89 e5                	mov    %esp,%ebp
  102ce7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102cea:	c7 05 70 af 11 00 60 	movl   $0x107060,0x11af70
  102cf1:	70 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102cf4:	a1 70 af 11 00       	mov    0x11af70,%eax
  102cf9:	8b 00                	mov    (%eax),%eax
  102cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cff:	c7 04 24 d0 66 10 00 	movl   $0x1066d0,(%esp)
  102d06:	e8 97 d5 ff ff       	call   1002a2 <cprintf>
    pmm_manager->init();
  102d0b:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d10:	8b 40 04             	mov    0x4(%eax),%eax
  102d13:	ff d0                	call   *%eax
}
  102d15:	90                   	nop
  102d16:	c9                   	leave  
  102d17:	c3                   	ret    

00102d18 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102d18:	55                   	push   %ebp
  102d19:	89 e5                	mov    %esp,%ebp
  102d1b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102d1e:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d23:	8b 40 08             	mov    0x8(%eax),%eax
  102d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d29:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  102d30:	89 14 24             	mov    %edx,(%esp)
  102d33:	ff d0                	call   *%eax
}
  102d35:	90                   	nop
  102d36:	c9                   	leave  
  102d37:	c3                   	ret    

00102d38 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102d38:	55                   	push   %ebp
  102d39:	89 e5                	mov    %esp,%ebp
  102d3b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102d45:	e8 2f fe ff ff       	call   102b79 <__intr_save>
  102d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102d4d:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d52:	8b 40 0c             	mov    0xc(%eax),%eax
  102d55:	8b 55 08             	mov    0x8(%ebp),%edx
  102d58:	89 14 24             	mov    %edx,(%esp)
  102d5b:	ff d0                	call   *%eax
  102d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d63:	89 04 24             	mov    %eax,(%esp)
  102d66:	e8 38 fe ff ff       	call   102ba3 <__intr_restore>
    return page;
  102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d6e:	c9                   	leave  
  102d6f:	c3                   	ret    

00102d70 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102d70:	55                   	push   %ebp
  102d71:	89 e5                	mov    %esp,%ebp
  102d73:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102d76:	e8 fe fd ff ff       	call   102b79 <__intr_save>
  102d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102d7e:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d83:	8b 40 10             	mov    0x10(%eax),%eax
  102d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d89:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102d90:	89 14 24             	mov    %edx,(%esp)
  102d93:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	89 04 24             	mov    %eax,(%esp)
  102d9b:	e8 03 fe ff ff       	call   102ba3 <__intr_restore>
}
  102da0:	90                   	nop
  102da1:	c9                   	leave  
  102da2:	c3                   	ret    

00102da3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102da3:	55                   	push   %ebp
  102da4:	89 e5                	mov    %esp,%ebp
  102da6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102da9:	e8 cb fd ff ff       	call   102b79 <__intr_save>
  102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102db1:	a1 70 af 11 00       	mov    0x11af70,%eax
  102db6:	8b 40 14             	mov    0x14(%eax),%eax
  102db9:	ff d0                	call   *%eax
  102dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc1:	89 04 24             	mov    %eax,(%esp)
  102dc4:	e8 da fd ff ff       	call   102ba3 <__intr_restore>
    return ret;
  102dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102dcc:	c9                   	leave  
  102dcd:	c3                   	ret    

00102dce <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102dce:	55                   	push   %ebp
  102dcf:	89 e5                	mov    %esp,%ebp
  102dd1:	57                   	push   %edi
  102dd2:	56                   	push   %esi
  102dd3:	53                   	push   %ebx
  102dd4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102dda:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102de1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102de8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102def:	c7 04 24 e7 66 10 00 	movl   $0x1066e7,(%esp)
  102df6:	e8 a7 d4 ff ff       	call   1002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102dfb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e02:	e9 22 01 00 00       	jmp    102f29 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e0d:	89 d0                	mov    %edx,%eax
  102e0f:	c1 e0 02             	shl    $0x2,%eax
  102e12:	01 d0                	add    %edx,%eax
  102e14:	c1 e0 02             	shl    $0x2,%eax
  102e17:	01 c8                	add    %ecx,%eax
  102e19:	8b 50 08             	mov    0x8(%eax),%edx
  102e1c:	8b 40 04             	mov    0x4(%eax),%eax
  102e1f:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102e22:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e25:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e2b:	89 d0                	mov    %edx,%eax
  102e2d:	c1 e0 02             	shl    $0x2,%eax
  102e30:	01 d0                	add    %edx,%eax
  102e32:	c1 e0 02             	shl    $0x2,%eax
  102e35:	01 c8                	add    %ecx,%eax
  102e37:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e3a:	8b 58 10             	mov    0x10(%eax),%ebx
  102e3d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e40:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e43:	01 c8                	add    %ecx,%eax
  102e45:	11 da                	adc    %ebx,%edx
  102e47:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e4a:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102e4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e53:	89 d0                	mov    %edx,%eax
  102e55:	c1 e0 02             	shl    $0x2,%eax
  102e58:	01 d0                	add    %edx,%eax
  102e5a:	c1 e0 02             	shl    $0x2,%eax
  102e5d:	01 c8                	add    %ecx,%eax
  102e5f:	83 c0 14             	add    $0x14,%eax
  102e62:	8b 00                	mov    (%eax),%eax
  102e64:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102e67:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e6a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e6d:	83 c0 ff             	add    $0xffffffff,%eax
  102e70:	83 d2 ff             	adc    $0xffffffff,%edx
  102e73:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102e79:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102e7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e85:	89 d0                	mov    %edx,%eax
  102e87:	c1 e0 02             	shl    $0x2,%eax
  102e8a:	01 d0                	add    %edx,%eax
  102e8c:	c1 e0 02             	shl    $0x2,%eax
  102e8f:	01 c8                	add    %ecx,%eax
  102e91:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e94:	8b 58 10             	mov    0x10(%eax),%ebx
  102e97:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e9a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102e9e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102ea4:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102eaa:	89 44 24 14          	mov    %eax,0x14(%esp)
  102eae:	89 54 24 18          	mov    %edx,0x18(%esp)
  102eb2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102eb5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102eb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ebc:	89 54 24 10          	mov    %edx,0x10(%esp)
  102ec0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102ec4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102ec8:	c7 04 24 f4 66 10 00 	movl   $0x1066f4,(%esp)
  102ecf:	e8 ce d3 ff ff       	call   1002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102ed4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ed7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eda:	89 d0                	mov    %edx,%eax
  102edc:	c1 e0 02             	shl    $0x2,%eax
  102edf:	01 d0                	add    %edx,%eax
  102ee1:	c1 e0 02             	shl    $0x2,%eax
  102ee4:	01 c8                	add    %ecx,%eax
  102ee6:	83 c0 14             	add    $0x14,%eax
  102ee9:	8b 00                	mov    (%eax),%eax
  102eeb:	83 f8 01             	cmp    $0x1,%eax
  102eee:	75 36                	jne    102f26 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  102ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ef3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ef6:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102ef9:	77 2b                	ja     102f26 <page_init+0x158>
  102efb:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102efe:	72 05                	jb     102f05 <page_init+0x137>
  102f00:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102f03:	73 21                	jae    102f26 <page_init+0x158>
  102f05:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102f09:	77 1b                	ja     102f26 <page_init+0x158>
  102f0b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102f0f:	72 09                	jb     102f1a <page_init+0x14c>
  102f11:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  102f18:	77 0c                	ja     102f26 <page_init+0x158>
                maxpa = end;
  102f1a:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f1d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102f20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f23:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102f26:	ff 45 dc             	incl   -0x24(%ebp)
  102f29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f2c:	8b 00                	mov    (%eax),%eax
  102f2e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102f31:	0f 8c d0 fe ff ff    	jl     102e07 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102f37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f3b:	72 1d                	jb     102f5a <page_init+0x18c>
  102f3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f41:	77 09                	ja     102f4c <page_init+0x17e>
  102f43:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102f4a:	76 0e                	jbe    102f5a <page_init+0x18c>
        maxpa = KMEMSIZE;
  102f4c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102f53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f60:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f64:	c1 ea 0c             	shr    $0xc,%edx
  102f67:	89 c1                	mov    %eax,%ecx
  102f69:	89 d3                	mov    %edx,%ebx
  102f6b:	89 c8                	mov    %ecx,%eax
  102f6d:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102f72:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102f79:	b8 88 af 11 00       	mov    $0x11af88,%eax
  102f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f81:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102f84:	01 d0                	add    %edx,%eax
  102f86:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102f89:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  102f91:	f7 75 c0             	divl   -0x40(%ebp)
  102f94:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f97:	29 d0                	sub    %edx,%eax
  102f99:	a3 78 af 11 00       	mov    %eax,0x11af78

    for (i = 0; i < npage; i ++) {
  102f9e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fa5:	eb 2e                	jmp    102fd5 <page_init+0x207>
        SetPageReserved(pages + i);
  102fa7:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  102fad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fb0:	89 d0                	mov    %edx,%eax
  102fb2:	c1 e0 02             	shl    $0x2,%eax
  102fb5:	01 d0                	add    %edx,%eax
  102fb7:	c1 e0 02             	shl    $0x2,%eax
  102fba:	01 c8                	add    %ecx,%eax
  102fbc:	83 c0 04             	add    $0x4,%eax
  102fbf:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102fc6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102fc9:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fcc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102fcf:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102fd2:	ff 45 dc             	incl   -0x24(%ebp)
  102fd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fd8:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102fdd:	39 c2                	cmp    %eax,%edx
  102fdf:	72 c6                	jb     102fa7 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102fe1:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102fe7:	89 d0                	mov    %edx,%eax
  102fe9:	c1 e0 02             	shl    $0x2,%eax
  102fec:	01 d0                	add    %edx,%eax
  102fee:	c1 e0 02             	shl    $0x2,%eax
  102ff1:	89 c2                	mov    %eax,%edx
  102ff3:	a1 78 af 11 00       	mov    0x11af78,%eax
  102ff8:	01 d0                	add    %edx,%eax
  102ffa:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102ffd:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103004:	77 23                	ja     103029 <page_init+0x25b>
  103006:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103009:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10300d:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103014:	00 
  103015:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10301c:	00 
  10301d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103024:	e8 d0 d3 ff ff       	call   1003f9 <__panic>
  103029:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10302c:	05 00 00 00 40       	add    $0x40000000,%eax
  103031:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103034:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10303b:	e9 69 01 00 00       	jmp    1031a9 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103040:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103043:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103046:	89 d0                	mov    %edx,%eax
  103048:	c1 e0 02             	shl    $0x2,%eax
  10304b:	01 d0                	add    %edx,%eax
  10304d:	c1 e0 02             	shl    $0x2,%eax
  103050:	01 c8                	add    %ecx,%eax
  103052:	8b 50 08             	mov    0x8(%eax),%edx
  103055:	8b 40 04             	mov    0x4(%eax),%eax
  103058:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10305b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10305e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103061:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103064:	89 d0                	mov    %edx,%eax
  103066:	c1 e0 02             	shl    $0x2,%eax
  103069:	01 d0                	add    %edx,%eax
  10306b:	c1 e0 02             	shl    $0x2,%eax
  10306e:	01 c8                	add    %ecx,%eax
  103070:	8b 48 0c             	mov    0xc(%eax),%ecx
  103073:	8b 58 10             	mov    0x10(%eax),%ebx
  103076:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10307c:	01 c8                	add    %ecx,%eax
  10307e:	11 da                	adc    %ebx,%edx
  103080:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103083:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103086:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10308c:	89 d0                	mov    %edx,%eax
  10308e:	c1 e0 02             	shl    $0x2,%eax
  103091:	01 d0                	add    %edx,%eax
  103093:	c1 e0 02             	shl    $0x2,%eax
  103096:	01 c8                	add    %ecx,%eax
  103098:	83 c0 14             	add    $0x14,%eax
  10309b:	8b 00                	mov    (%eax),%eax
  10309d:	83 f8 01             	cmp    $0x1,%eax
  1030a0:	0f 85 00 01 00 00    	jne    1031a6 <page_init+0x3d8>
            if (begin < freemem) {
  1030a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ae:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1030b1:	77 17                	ja     1030ca <page_init+0x2fc>
  1030b3:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1030b6:	72 05                	jb     1030bd <page_init+0x2ef>
  1030b8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1030bb:	73 0d                	jae    1030ca <page_init+0x2fc>
                begin = freemem;
  1030bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030c3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1030ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1030ce:	72 1d                	jb     1030ed <page_init+0x31f>
  1030d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1030d4:	77 09                	ja     1030df <page_init+0x311>
  1030d6:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1030dd:	76 0e                	jbe    1030ed <page_init+0x31f>
                end = KMEMSIZE;
  1030df:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1030e6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1030ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030f3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030f6:	0f 87 aa 00 00 00    	ja     1031a6 <page_init+0x3d8>
  1030fc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030ff:	72 09                	jb     10310a <page_init+0x33c>
  103101:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103104:	0f 83 9c 00 00 00    	jae    1031a6 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  10310a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103111:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103114:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103117:	01 d0                	add    %edx,%eax
  103119:	48                   	dec    %eax
  10311a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10311d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103120:	ba 00 00 00 00       	mov    $0x0,%edx
  103125:	f7 75 b0             	divl   -0x50(%ebp)
  103128:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10312b:	29 d0                	sub    %edx,%eax
  10312d:	ba 00 00 00 00       	mov    $0x0,%edx
  103132:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103135:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103138:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10313b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10313e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103141:	ba 00 00 00 00       	mov    $0x0,%edx
  103146:	89 c3                	mov    %eax,%ebx
  103148:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10314e:	89 de                	mov    %ebx,%esi
  103150:	89 d0                	mov    %edx,%eax
  103152:	83 e0 00             	and    $0x0,%eax
  103155:	89 c7                	mov    %eax,%edi
  103157:	89 75 c8             	mov    %esi,-0x38(%ebp)
  10315a:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  10315d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103160:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103163:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103166:	77 3e                	ja     1031a6 <page_init+0x3d8>
  103168:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10316b:	72 05                	jb     103172 <page_init+0x3a4>
  10316d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103170:	73 34                	jae    1031a6 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103172:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103175:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103178:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10317b:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10317e:	89 c1                	mov    %eax,%ecx
  103180:	89 d3                	mov    %edx,%ebx
  103182:	89 c8                	mov    %ecx,%eax
  103184:	89 da                	mov    %ebx,%edx
  103186:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10318a:	c1 ea 0c             	shr    $0xc,%edx
  10318d:	89 c3                	mov    %eax,%ebx
  10318f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103192:	89 04 24             	mov    %eax,(%esp)
  103195:	e8 ae f8 ff ff       	call   102a48 <pa2page>
  10319a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10319e:	89 04 24             	mov    %eax,(%esp)
  1031a1:	e8 72 fb ff ff       	call   102d18 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1031a6:	ff 45 dc             	incl   -0x24(%ebp)
  1031a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1031ac:	8b 00                	mov    (%eax),%eax
  1031ae:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1031b1:	0f 8c 89 fe ff ff    	jl     103040 <page_init+0x272>
                }
            }
        }
    }
}
  1031b7:	90                   	nop
  1031b8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1031be:	5b                   	pop    %ebx
  1031bf:	5e                   	pop    %esi
  1031c0:	5f                   	pop    %edi
  1031c1:	5d                   	pop    %ebp
  1031c2:	c3                   	ret    

001031c3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1031c3:	55                   	push   %ebp
  1031c4:	89 e5                	mov    %esp,%ebp
  1031c6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1031c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031cc:	33 45 14             	xor    0x14(%ebp),%eax
  1031cf:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031d4:	85 c0                	test   %eax,%eax
  1031d6:	74 24                	je     1031fc <boot_map_segment+0x39>
  1031d8:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1031df:	00 
  1031e0:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1031e7:	00 
  1031e8:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1031ef:	00 
  1031f0:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1031f7:	e8 fd d1 ff ff       	call   1003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1031fc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103203:	8b 45 0c             	mov    0xc(%ebp),%eax
  103206:	25 ff 0f 00 00       	and    $0xfff,%eax
  10320b:	89 c2                	mov    %eax,%edx
  10320d:	8b 45 10             	mov    0x10(%ebp),%eax
  103210:	01 c2                	add    %eax,%edx
  103212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103215:	01 d0                	add    %edx,%eax
  103217:	48                   	dec    %eax
  103218:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10321e:	ba 00 00 00 00       	mov    $0x0,%edx
  103223:	f7 75 f0             	divl   -0x10(%ebp)
  103226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103229:	29 d0                	sub    %edx,%eax
  10322b:	c1 e8 0c             	shr    $0xc,%eax
  10322e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103231:	8b 45 0c             	mov    0xc(%ebp),%eax
  103234:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10323a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10323f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103242:	8b 45 14             	mov    0x14(%ebp),%eax
  103245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10324b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103250:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103253:	eb 68                	jmp    1032bd <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103255:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10325c:	00 
  10325d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103260:	89 44 24 04          	mov    %eax,0x4(%esp)
  103264:	8b 45 08             	mov    0x8(%ebp),%eax
  103267:	89 04 24             	mov    %eax,(%esp)
  10326a:	e8 81 01 00 00       	call   1033f0 <get_pte>
  10326f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103272:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103276:	75 24                	jne    10329c <boot_map_segment+0xd9>
  103278:	c7 44 24 0c 82 67 10 	movl   $0x106782,0xc(%esp)
  10327f:	00 
  103280:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103287:	00 
  103288:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10328f:	00 
  103290:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103297:	e8 5d d1 ff ff       	call   1003f9 <__panic>
        *ptep = pa | PTE_P | perm;
  10329c:	8b 45 14             	mov    0x14(%ebp),%eax
  10329f:	0b 45 18             	or     0x18(%ebp),%eax
  1032a2:	83 c8 01             	or     $0x1,%eax
  1032a5:	89 c2                	mov    %eax,%edx
  1032a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032aa:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1032ac:	ff 4d f4             	decl   -0xc(%ebp)
  1032af:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1032b6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1032bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032c1:	75 92                	jne    103255 <boot_map_segment+0x92>
    }
}
  1032c3:	90                   	nop
  1032c4:	c9                   	leave  
  1032c5:	c3                   	ret    

001032c6 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1032c6:	55                   	push   %ebp
  1032c7:	89 e5                	mov    %esp,%ebp
  1032c9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1032cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032d3:	e8 60 fa ff ff       	call   102d38 <alloc_pages>
  1032d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1032db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032df:	75 1c                	jne    1032fd <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1032e1:	c7 44 24 08 8f 67 10 	movl   $0x10678f,0x8(%esp)
  1032e8:	00 
  1032e9:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1032f0:	00 
  1032f1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1032f8:	e8 fc d0 ff ff       	call   1003f9 <__panic>
    }
    return page2kva(p);
  1032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103300:	89 04 24             	mov    %eax,(%esp)
  103303:	e8 8f f7 ff ff       	call   102a97 <page2kva>
}
  103308:	c9                   	leave  
  103309:	c3                   	ret    

0010330a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10330a:	55                   	push   %ebp
  10330b:	89 e5                	mov    %esp,%ebp
  10330d:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103310:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103318:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10331f:	77 23                	ja     103344 <pmm_init+0x3a>
  103321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103328:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  10332f:	00 
  103330:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103337:	00 
  103338:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10333f:	e8 b5 d0 ff ff       	call   1003f9 <__panic>
  103344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103347:	05 00 00 00 40       	add    $0x40000000,%eax
  10334c:	a3 74 af 11 00       	mov    %eax,0x11af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103351:	e8 8e f9 ff ff       	call   102ce4 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103356:	e8 73 fa ff ff       	call   102dce <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10335b:	e8 4f 02 00 00       	call   1035af <check_alloc_page>

    check_pgdir();
  103360:	e8 69 02 00 00       	call   1035ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103365:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10336a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10336d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103374:	77 23                	ja     103399 <pmm_init+0x8f>
  103376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103379:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10337d:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103384:	00 
  103385:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10338c:	00 
  10338d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103394:	e8 60 d0 ff ff       	call   1003f9 <__panic>
  103399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10339c:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1033a2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1033a7:	05 ac 0f 00 00       	add    $0xfac,%eax
  1033ac:	83 ca 03             	or     $0x3,%edx
  1033af:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1033b1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1033b6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1033bd:	00 
  1033be:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1033c5:	00 
  1033c6:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1033cd:	38 
  1033ce:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1033d5:	c0 
  1033d6:	89 04 24             	mov    %eax,(%esp)
  1033d9:	e8 e5 fd ff ff       	call   1031c3 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1033de:	e8 18 f8 ff ff       	call   102bfb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1033e3:	e8 82 08 00 00       	call   103c6a <check_boot_pgdir>

    print_pgdir();
  1033e8:	e8 fb 0c 00 00       	call   1040e8 <print_pgdir>

}
  1033ed:	90                   	nop
  1033ee:	c9                   	leave  
  1033ef:	c3                   	ret    

001033f0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1033f0:	55                   	push   %ebp
  1033f1:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1033f3:	90                   	nop
  1033f4:	5d                   	pop    %ebp
  1033f5:	c3                   	ret    

001033f6 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1033f6:	55                   	push   %ebp
  1033f7:	89 e5                	mov    %esp,%ebp
  1033f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1033fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103403:	00 
  103404:	8b 45 0c             	mov    0xc(%ebp),%eax
  103407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10340b:	8b 45 08             	mov    0x8(%ebp),%eax
  10340e:	89 04 24             	mov    %eax,(%esp)
  103411:	e8 da ff ff ff       	call   1033f0 <get_pte>
  103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10341d:	74 08                	je     103427 <get_page+0x31>
        *ptep_store = ptep;
  10341f:	8b 45 10             	mov    0x10(%ebp),%eax
  103422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103425:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10342b:	74 1b                	je     103448 <get_page+0x52>
  10342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103430:	8b 00                	mov    (%eax),%eax
  103432:	83 e0 01             	and    $0x1,%eax
  103435:	85 c0                	test   %eax,%eax
  103437:	74 0f                	je     103448 <get_page+0x52>
        return pte2page(*ptep);
  103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10343c:	8b 00                	mov    (%eax),%eax
  10343e:	89 04 24             	mov    %eax,(%esp)
  103441:	e8 a5 f6 ff ff       	call   102aeb <pte2page>
  103446:	eb 05                	jmp    10344d <get_page+0x57>
    }
    return NULL;
  103448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10344d:	c9                   	leave  
  10344e:	c3                   	ret    

0010344f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10344f:	55                   	push   %ebp
  103450:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103452:	90                   	nop
  103453:	5d                   	pop    %ebp
  103454:	c3                   	ret    

00103455 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103455:	55                   	push   %ebp
  103456:	89 e5                	mov    %esp,%ebp
  103458:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10345b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103462:	00 
  103463:	8b 45 0c             	mov    0xc(%ebp),%eax
  103466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	89 04 24             	mov    %eax,(%esp)
  103470:	e8 7b ff ff ff       	call   1033f0 <get_pte>
  103475:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  103478:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10347c:	74 19                	je     103497 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10347e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103481:	89 44 24 08          	mov    %eax,0x8(%esp)
  103485:	8b 45 0c             	mov    0xc(%ebp),%eax
  103488:	89 44 24 04          	mov    %eax,0x4(%esp)
  10348c:	8b 45 08             	mov    0x8(%ebp),%eax
  10348f:	89 04 24             	mov    %eax,(%esp)
  103492:	e8 b8 ff ff ff       	call   10344f <page_remove_pte>
    }
}
  103497:	90                   	nop
  103498:	c9                   	leave  
  103499:	c3                   	ret    

0010349a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10349a:	55                   	push   %ebp
  10349b:	89 e5                	mov    %esp,%ebp
  10349d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1034a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1034a7:	00 
  1034a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034af:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b2:	89 04 24             	mov    %eax,(%esp)
  1034b5:	e8 36 ff ff ff       	call   1033f0 <get_pte>
  1034ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034c1:	75 0a                	jne    1034cd <page_insert+0x33>
        return -E_NO_MEM;
  1034c3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1034c8:	e9 84 00 00 00       	jmp    103551 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1034cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d0:	89 04 24             	mov    %eax,(%esp)
  1034d3:	e8 73 f6 ff ff       	call   102b4b <page_ref_inc>
    if (*ptep & PTE_P) {
  1034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034db:	8b 00                	mov    (%eax),%eax
  1034dd:	83 e0 01             	and    $0x1,%eax
  1034e0:	85 c0                	test   %eax,%eax
  1034e2:	74 3e                	je     103522 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034e7:	8b 00                	mov    (%eax),%eax
  1034e9:	89 04 24             	mov    %eax,(%esp)
  1034ec:	e8 fa f5 ff ff       	call   102aeb <pte2page>
  1034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034fa:	75 0d                	jne    103509 <page_insert+0x6f>
            page_ref_dec(page);
  1034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ff:	89 04 24             	mov    %eax,(%esp)
  103502:	e8 5b f6 ff ff       	call   102b62 <page_ref_dec>
  103507:	eb 19                	jmp    103522 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10350c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103510:	8b 45 10             	mov    0x10(%ebp),%eax
  103513:	89 44 24 04          	mov    %eax,0x4(%esp)
  103517:	8b 45 08             	mov    0x8(%ebp),%eax
  10351a:	89 04 24             	mov    %eax,(%esp)
  10351d:	e8 2d ff ff ff       	call   10344f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103522:	8b 45 0c             	mov    0xc(%ebp),%eax
  103525:	89 04 24             	mov    %eax,(%esp)
  103528:	e8 05 f5 ff ff       	call   102a32 <page2pa>
  10352d:	0b 45 14             	or     0x14(%ebp),%eax
  103530:	83 c8 01             	or     $0x1,%eax
  103533:	89 c2                	mov    %eax,%edx
  103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103538:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10353a:	8b 45 10             	mov    0x10(%ebp),%eax
  10353d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103541:	8b 45 08             	mov    0x8(%ebp),%eax
  103544:	89 04 24             	mov    %eax,(%esp)
  103547:	e8 07 00 00 00       	call   103553 <tlb_invalidate>
    return 0;
  10354c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103551:	c9                   	leave  
  103552:	c3                   	ret    

00103553 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103553:	55                   	push   %ebp
  103554:	89 e5                	mov    %esp,%ebp
  103556:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103559:	0f 20 d8             	mov    %cr3,%eax
  10355c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10355f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103562:	8b 45 08             	mov    0x8(%ebp),%eax
  103565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103568:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10356f:	77 23                	ja     103594 <tlb_invalidate+0x41>
  103571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103574:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103578:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  10357f:	00 
  103580:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  103587:	00 
  103588:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10358f:	e8 65 ce ff ff       	call   1003f9 <__panic>
  103594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103597:	05 00 00 00 40       	add    $0x40000000,%eax
  10359c:	39 d0                	cmp    %edx,%eax
  10359e:	75 0c                	jne    1035ac <tlb_invalidate+0x59>
        invlpg((void *)la);
  1035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1035a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a9:	0f 01 38             	invlpg (%eax)
    }
}
  1035ac:	90                   	nop
  1035ad:	c9                   	leave  
  1035ae:	c3                   	ret    

001035af <check_alloc_page>:

static void
check_alloc_page(void) {
  1035af:	55                   	push   %ebp
  1035b0:	89 e5                	mov    %esp,%ebp
  1035b2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1035b5:	a1 70 af 11 00       	mov    0x11af70,%eax
  1035ba:	8b 40 18             	mov    0x18(%eax),%eax
  1035bd:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1035bf:	c7 04 24 a8 67 10 00 	movl   $0x1067a8,(%esp)
  1035c6:	e8 d7 cc ff ff       	call   1002a2 <cprintf>
}
  1035cb:	90                   	nop
  1035cc:	c9                   	leave  
  1035cd:	c3                   	ret    

001035ce <check_pgdir>:

static void
check_pgdir(void) {
  1035ce:	55                   	push   %ebp
  1035cf:	89 e5                	mov    %esp,%ebp
  1035d1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035d4:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1035d9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035de:	76 24                	jbe    103604 <check_pgdir+0x36>
  1035e0:	c7 44 24 0c c7 67 10 	movl   $0x1067c7,0xc(%esp)
  1035e7:	00 
  1035e8:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1035ef:	00 
  1035f0:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  1035f7:	00 
  1035f8:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1035ff:	e8 f5 cd ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103604:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103609:	85 c0                	test   %eax,%eax
  10360b:	74 0e                	je     10361b <check_pgdir+0x4d>
  10360d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103612:	25 ff 0f 00 00       	and    $0xfff,%eax
  103617:	85 c0                	test   %eax,%eax
  103619:	74 24                	je     10363f <check_pgdir+0x71>
  10361b:	c7 44 24 0c e4 67 10 	movl   $0x1067e4,0xc(%esp)
  103622:	00 
  103623:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10362a:	00 
  10362b:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  103632:	00 
  103633:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10363a:	e8 ba cd ff ff       	call   1003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10363f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103644:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10364b:	00 
  10364c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103653:	00 
  103654:	89 04 24             	mov    %eax,(%esp)
  103657:	e8 9a fd ff ff       	call   1033f6 <get_page>
  10365c:	85 c0                	test   %eax,%eax
  10365e:	74 24                	je     103684 <check_pgdir+0xb6>
  103660:	c7 44 24 0c 1c 68 10 	movl   $0x10681c,0xc(%esp)
  103667:	00 
  103668:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10366f:	00 
  103670:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  103677:	00 
  103678:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10367f:	e8 75 cd ff ff       	call   1003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10368b:	e8 a8 f6 ff ff       	call   102d38 <alloc_pages>
  103690:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103693:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103698:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10369f:	00 
  1036a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036a7:	00 
  1036a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1036af:	89 04 24             	mov    %eax,(%esp)
  1036b2:	e8 e3 fd ff ff       	call   10349a <page_insert>
  1036b7:	85 c0                	test   %eax,%eax
  1036b9:	74 24                	je     1036df <check_pgdir+0x111>
  1036bb:	c7 44 24 0c 44 68 10 	movl   $0x106844,0xc(%esp)
  1036c2:	00 
  1036c3:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1036ca:	00 
  1036cb:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1036d2:	00 
  1036d3:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1036da:	e8 1a cd ff ff       	call   1003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1036df:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1036e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036eb:	00 
  1036ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036f3:	00 
  1036f4:	89 04 24             	mov    %eax,(%esp)
  1036f7:	e8 f4 fc ff ff       	call   1033f0 <get_pte>
  1036fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103703:	75 24                	jne    103729 <check_pgdir+0x15b>
  103705:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  10370c:	00 
  10370d:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103714:	00 
  103715:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  10371c:	00 
  10371d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103724:	e8 d0 cc ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10372c:	8b 00                	mov    (%eax),%eax
  10372e:	89 04 24             	mov    %eax,(%esp)
  103731:	e8 b5 f3 ff ff       	call   102aeb <pte2page>
  103736:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103739:	74 24                	je     10375f <check_pgdir+0x191>
  10373b:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103742:	00 
  103743:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10374a:	00 
  10374b:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  103752:	00 
  103753:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10375a:	e8 9a cc ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 1);
  10375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103762:	89 04 24             	mov    %eax,(%esp)
  103765:	e8 d7 f3 ff ff       	call   102b41 <page_ref>
  10376a:	83 f8 01             	cmp    $0x1,%eax
  10376d:	74 24                	je     103793 <check_pgdir+0x1c5>
  10376f:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  103776:	00 
  103777:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10377e:	00 
  10377f:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  103786:	00 
  103787:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10378e:	e8 66 cc ff ff       	call   1003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103793:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103798:	8b 00                	mov    (%eax),%eax
  10379a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10379f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1037a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037a5:	c1 e8 0c             	shr    $0xc,%eax
  1037a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1037ab:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1037b0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1037b3:	72 23                	jb     1037d8 <check_pgdir+0x20a>
  1037b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1037bc:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  1037c3:	00 
  1037c4:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1037cb:	00 
  1037cc:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1037d3:	e8 21 cc ff ff       	call   1003f9 <__panic>
  1037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037db:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037e0:	83 c0 04             	add    $0x4,%eax
  1037e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1037e6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1037eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037f2:	00 
  1037f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037fa:	00 
  1037fb:	89 04 24             	mov    %eax,(%esp)
  1037fe:	e8 ed fb ff ff       	call   1033f0 <get_pte>
  103803:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103806:	74 24                	je     10382c <check_pgdir+0x25e>
  103808:	c7 44 24 0c c8 68 10 	movl   $0x1068c8,0xc(%esp)
  10380f:	00 
  103810:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103817:	00 
  103818:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  10381f:	00 
  103820:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103827:	e8 cd cb ff ff       	call   1003f9 <__panic>

    p2 = alloc_page();
  10382c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103833:	e8 00 f5 ff ff       	call   102d38 <alloc_pages>
  103838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10383b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103840:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103847:	00 
  103848:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10384f:	00 
  103850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103853:	89 54 24 04          	mov    %edx,0x4(%esp)
  103857:	89 04 24             	mov    %eax,(%esp)
  10385a:	e8 3b fc ff ff       	call   10349a <page_insert>
  10385f:	85 c0                	test   %eax,%eax
  103861:	74 24                	je     103887 <check_pgdir+0x2b9>
  103863:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  10386a:	00 
  10386b:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103872:	00 
  103873:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  10387a:	00 
  10387b:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103882:	e8 72 cb ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103887:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10388c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103893:	00 
  103894:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10389b:	00 
  10389c:	89 04 24             	mov    %eax,(%esp)
  10389f:	e8 4c fb ff ff       	call   1033f0 <get_pte>
  1038a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038ab:	75 24                	jne    1038d1 <check_pgdir+0x303>
  1038ad:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  1038b4:	00 
  1038b5:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038bc:	00 
  1038bd:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  1038c4:	00 
  1038c5:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038cc:	e8 28 cb ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_U);
  1038d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038d4:	8b 00                	mov    (%eax),%eax
  1038d6:	83 e0 04             	and    $0x4,%eax
  1038d9:	85 c0                	test   %eax,%eax
  1038db:	75 24                	jne    103901 <check_pgdir+0x333>
  1038dd:	c7 44 24 0c 58 69 10 	movl   $0x106958,0xc(%esp)
  1038e4:	00 
  1038e5:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038ec:	00 
  1038ed:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  1038f4:	00 
  1038f5:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038fc:	e8 f8 ca ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_W);
  103901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103904:	8b 00                	mov    (%eax),%eax
  103906:	83 e0 02             	and    $0x2,%eax
  103909:	85 c0                	test   %eax,%eax
  10390b:	75 24                	jne    103931 <check_pgdir+0x363>
  10390d:	c7 44 24 0c 66 69 10 	movl   $0x106966,0xc(%esp)
  103914:	00 
  103915:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10391c:	00 
  10391d:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  103924:	00 
  103925:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10392c:	e8 c8 ca ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103931:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103936:	8b 00                	mov    (%eax),%eax
  103938:	83 e0 04             	and    $0x4,%eax
  10393b:	85 c0                	test   %eax,%eax
  10393d:	75 24                	jne    103963 <check_pgdir+0x395>
  10393f:	c7 44 24 0c 74 69 10 	movl   $0x106974,0xc(%esp)
  103946:	00 
  103947:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10394e:	00 
  10394f:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103956:	00 
  103957:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10395e:	e8 96 ca ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 1);
  103963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103966:	89 04 24             	mov    %eax,(%esp)
  103969:	e8 d3 f1 ff ff       	call   102b41 <page_ref>
  10396e:	83 f8 01             	cmp    $0x1,%eax
  103971:	74 24                	je     103997 <check_pgdir+0x3c9>
  103973:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  10397a:	00 
  10397b:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103982:	00 
  103983:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10398a:	00 
  10398b:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103992:	e8 62 ca ff ff       	call   1003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103997:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10399c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1039a3:	00 
  1039a4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1039ab:	00 
  1039ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039b3:	89 04 24             	mov    %eax,(%esp)
  1039b6:	e8 df fa ff ff       	call   10349a <page_insert>
  1039bb:	85 c0                	test   %eax,%eax
  1039bd:	74 24                	je     1039e3 <check_pgdir+0x415>
  1039bf:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  1039c6:	00 
  1039c7:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1039ce:	00 
  1039cf:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1039d6:	00 
  1039d7:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1039de:	e8 16 ca ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 2);
  1039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039e6:	89 04 24             	mov    %eax,(%esp)
  1039e9:	e8 53 f1 ff ff       	call   102b41 <page_ref>
  1039ee:	83 f8 02             	cmp    $0x2,%eax
  1039f1:	74 24                	je     103a17 <check_pgdir+0x449>
  1039f3:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  1039fa:	00 
  1039fb:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a02:	00 
  103a03:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103a0a:	00 
  103a0b:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a12:	e8 e2 c9 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a1a:	89 04 24             	mov    %eax,(%esp)
  103a1d:	e8 1f f1 ff ff       	call   102b41 <page_ref>
  103a22:	85 c0                	test   %eax,%eax
  103a24:	74 24                	je     103a4a <check_pgdir+0x47c>
  103a26:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103a2d:	00 
  103a2e:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a35:	00 
  103a36:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103a3d:	00 
  103a3e:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a45:	e8 af c9 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a4a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a56:	00 
  103a57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a5e:	00 
  103a5f:	89 04 24             	mov    %eax,(%esp)
  103a62:	e8 89 f9 ff ff       	call   1033f0 <get_pte>
  103a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a6e:	75 24                	jne    103a94 <check_pgdir+0x4c6>
  103a70:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  103a77:	00 
  103a78:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a7f:	00 
  103a80:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  103a87:	00 
  103a88:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a8f:	e8 65 c9 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a97:	8b 00                	mov    (%eax),%eax
  103a99:	89 04 24             	mov    %eax,(%esp)
  103a9c:	e8 4a f0 ff ff       	call   102aeb <pte2page>
  103aa1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103aa4:	74 24                	je     103aca <check_pgdir+0x4fc>
  103aa6:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103aad:	00 
  103aae:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ab5:	00 
  103ab6:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103abd:	00 
  103abe:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103ac5:	e8 2f c9 ff ff       	call   1003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103acd:	8b 00                	mov    (%eax),%eax
  103acf:	83 e0 04             	and    $0x4,%eax
  103ad2:	85 c0                	test   %eax,%eax
  103ad4:	74 24                	je     103afa <check_pgdir+0x52c>
  103ad6:	c7 44 24 0c ec 69 10 	movl   $0x1069ec,0xc(%esp)
  103add:	00 
  103ade:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ae5:	00 
  103ae6:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103aed:	00 
  103aee:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103af5:	e8 ff c8 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103afa:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b06:	00 
  103b07:	89 04 24             	mov    %eax,(%esp)
  103b0a:	e8 46 f9 ff ff       	call   103455 <page_remove>
    assert(page_ref(p1) == 1);
  103b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b12:	89 04 24             	mov    %eax,(%esp)
  103b15:	e8 27 f0 ff ff       	call   102b41 <page_ref>
  103b1a:	83 f8 01             	cmp    $0x1,%eax
  103b1d:	74 24                	je     103b43 <check_pgdir+0x575>
  103b1f:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  103b26:	00 
  103b27:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b2e:	00 
  103b2f:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103b36:	00 
  103b37:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b3e:	e8 b6 c8 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b46:	89 04 24             	mov    %eax,(%esp)
  103b49:	e8 f3 ef ff ff       	call   102b41 <page_ref>
  103b4e:	85 c0                	test   %eax,%eax
  103b50:	74 24                	je     103b76 <check_pgdir+0x5a8>
  103b52:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103b59:	00 
  103b5a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b61:	00 
  103b62:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103b69:	00 
  103b6a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b71:	e8 83 c8 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b76:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b7b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b82:	00 
  103b83:	89 04 24             	mov    %eax,(%esp)
  103b86:	e8 ca f8 ff ff       	call   103455 <page_remove>
    assert(page_ref(p1) == 0);
  103b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b8e:	89 04 24             	mov    %eax,(%esp)
  103b91:	e8 ab ef ff ff       	call   102b41 <page_ref>
  103b96:	85 c0                	test   %eax,%eax
  103b98:	74 24                	je     103bbe <check_pgdir+0x5f0>
  103b9a:	c7 44 24 0c 01 6a 10 	movl   $0x106a01,0xc(%esp)
  103ba1:	00 
  103ba2:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ba9:	00 
  103baa:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103bb1:	00 
  103bb2:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103bb9:	e8 3b c8 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bc1:	89 04 24             	mov    %eax,(%esp)
  103bc4:	e8 78 ef ff ff       	call   102b41 <page_ref>
  103bc9:	85 c0                	test   %eax,%eax
  103bcb:	74 24                	je     103bf1 <check_pgdir+0x623>
  103bcd:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103bd4:	00 
  103bd5:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103bdc:	00 
  103bdd:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103be4:	00 
  103be5:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103bec:	e8 08 c8 ff ff       	call   1003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103bf1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103bf6:	8b 00                	mov    (%eax),%eax
  103bf8:	89 04 24             	mov    %eax,(%esp)
  103bfb:	e8 29 ef ff ff       	call   102b29 <pde2page>
  103c00:	89 04 24             	mov    %eax,(%esp)
  103c03:	e8 39 ef ff ff       	call   102b41 <page_ref>
  103c08:	83 f8 01             	cmp    $0x1,%eax
  103c0b:	74 24                	je     103c31 <check_pgdir+0x663>
  103c0d:	c7 44 24 0c 14 6a 10 	movl   $0x106a14,0xc(%esp)
  103c14:	00 
  103c15:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103c1c:	00 
  103c1d:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103c24:	00 
  103c25:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c2c:	e8 c8 c7 ff ff       	call   1003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103c31:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c36:	8b 00                	mov    (%eax),%eax
  103c38:	89 04 24             	mov    %eax,(%esp)
  103c3b:	e8 e9 ee ff ff       	call   102b29 <pde2page>
  103c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c47:	00 
  103c48:	89 04 24             	mov    %eax,(%esp)
  103c4b:	e8 20 f1 ff ff       	call   102d70 <free_pages>
    boot_pgdir[0] = 0;
  103c50:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c5b:	c7 04 24 3b 6a 10 00 	movl   $0x106a3b,(%esp)
  103c62:	e8 3b c6 ff ff       	call   1002a2 <cprintf>
}
  103c67:	90                   	nop
  103c68:	c9                   	leave  
  103c69:	c3                   	ret    

00103c6a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c6a:	55                   	push   %ebp
  103c6b:	89 e5                	mov    %esp,%ebp
  103c6d:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c77:	e9 ca 00 00 00       	jmp    103d46 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c85:	c1 e8 0c             	shr    $0xc,%eax
  103c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c8b:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103c90:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103c93:	72 23                	jb     103cb8 <check_boot_pgdir+0x4e>
  103c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c9c:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  103ca3:	00 
  103ca4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103cab:	00 
  103cac:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103cb3:	e8 41 c7 ff ff       	call   1003f9 <__panic>
  103cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cbb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103cc0:	89 c2                	mov    %eax,%edx
  103cc2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103cc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103cce:	00 
  103ccf:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cd3:	89 04 24             	mov    %eax,(%esp)
  103cd6:	e8 15 f7 ff ff       	call   1033f0 <get_pte>
  103cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103ce2:	75 24                	jne    103d08 <check_boot_pgdir+0x9e>
  103ce4:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  103ceb:	00 
  103cec:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103cf3:	00 
  103cf4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103cfb:	00 
  103cfc:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d03:	e8 f1 c6 ff ff       	call   1003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103d0b:	8b 00                	mov    (%eax),%eax
  103d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d12:	89 c2                	mov    %eax,%edx
  103d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d17:	39 c2                	cmp    %eax,%edx
  103d19:	74 24                	je     103d3f <check_boot_pgdir+0xd5>
  103d1b:	c7 44 24 0c 95 6a 10 	movl   $0x106a95,0xc(%esp)
  103d22:	00 
  103d23:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103d2a:	00 
  103d2b:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103d32:	00 
  103d33:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d3a:	e8 ba c6 ff ff       	call   1003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103d3f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d49:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103d4e:	39 c2                	cmp    %eax,%edx
  103d50:	0f 82 26 ff ff ff    	jb     103c7c <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103d56:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d5b:	05 ac 0f 00 00       	add    $0xfac,%eax
  103d60:	8b 00                	mov    (%eax),%eax
  103d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d67:	89 c2                	mov    %eax,%edx
  103d69:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d71:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103d78:	77 23                	ja     103d9d <check_boot_pgdir+0x133>
  103d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d81:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103d88:	00 
  103d89:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103d90:	00 
  103d91:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d98:	e8 5c c6 ff ff       	call   1003f9 <__panic>
  103d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103da0:	05 00 00 00 40       	add    $0x40000000,%eax
  103da5:	39 d0                	cmp    %edx,%eax
  103da7:	74 24                	je     103dcd <check_boot_pgdir+0x163>
  103da9:	c7 44 24 0c ac 6a 10 	movl   $0x106aac,0xc(%esp)
  103db0:	00 
  103db1:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103db8:	00 
  103db9:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103dc0:	00 
  103dc1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103dc8:	e8 2c c6 ff ff       	call   1003f9 <__panic>

    assert(boot_pgdir[0] == 0);
  103dcd:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103dd2:	8b 00                	mov    (%eax),%eax
  103dd4:	85 c0                	test   %eax,%eax
  103dd6:	74 24                	je     103dfc <check_boot_pgdir+0x192>
  103dd8:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  103ddf:	00 
  103de0:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103de7:	00 
  103de8:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103def:	00 
  103df0:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103df7:	e8 fd c5 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    p = alloc_page();
  103dfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103e03:	e8 30 ef ff ff       	call   102d38 <alloc_pages>
  103e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103e0b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e10:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e17:	00 
  103e18:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103e1f:	00 
  103e20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103e23:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e27:	89 04 24             	mov    %eax,(%esp)
  103e2a:	e8 6b f6 ff ff       	call   10349a <page_insert>
  103e2f:	85 c0                	test   %eax,%eax
  103e31:	74 24                	je     103e57 <check_boot_pgdir+0x1ed>
  103e33:	c7 44 24 0c f4 6a 10 	movl   $0x106af4,0xc(%esp)
  103e3a:	00 
  103e3b:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e42:	00 
  103e43:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103e4a:	00 
  103e4b:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e52:	e8 a2 c5 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 1);
  103e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e5a:	89 04 24             	mov    %eax,(%esp)
  103e5d:	e8 df ec ff ff       	call   102b41 <page_ref>
  103e62:	83 f8 01             	cmp    $0x1,%eax
  103e65:	74 24                	je     103e8b <check_boot_pgdir+0x221>
  103e67:	c7 44 24 0c 22 6b 10 	movl   $0x106b22,0xc(%esp)
  103e6e:	00 
  103e6f:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e76:	00 
  103e77:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103e7e:	00 
  103e7f:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e86:	e8 6e c5 ff ff       	call   1003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103e8b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e90:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e97:	00 
  103e98:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103e9f:	00 
  103ea0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ea7:	89 04 24             	mov    %eax,(%esp)
  103eaa:	e8 eb f5 ff ff       	call   10349a <page_insert>
  103eaf:	85 c0                	test   %eax,%eax
  103eb1:	74 24                	je     103ed7 <check_boot_pgdir+0x26d>
  103eb3:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103eba:	00 
  103ebb:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ec2:	00 
  103ec3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103eca:	00 
  103ecb:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103ed2:	e8 22 c5 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 2);
  103ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103eda:	89 04 24             	mov    %eax,(%esp)
  103edd:	e8 5f ec ff ff       	call   102b41 <page_ref>
  103ee2:	83 f8 02             	cmp    $0x2,%eax
  103ee5:	74 24                	je     103f0b <check_boot_pgdir+0x2a1>
  103ee7:	c7 44 24 0c 6b 6b 10 	movl   $0x106b6b,0xc(%esp)
  103eee:	00 
  103eef:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ef6:	00 
  103ef7:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103efe:	00 
  103eff:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103f06:	e8 ee c4 ff ff       	call   1003f9 <__panic>

    const char *str = "ucore: Hello world!!";
  103f0b:	c7 45 e8 7c 6b 10 00 	movl   $0x106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f19:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f20:	e8 4b 15 00 00       	call   105470 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103f25:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103f2c:	00 
  103f2d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f34:	e8 ae 15 00 00       	call   1054e7 <strcmp>
  103f39:	85 c0                	test   %eax,%eax
  103f3b:	74 24                	je     103f61 <check_boot_pgdir+0x2f7>
  103f3d:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  103f44:	00 
  103f45:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103f4c:	00 
  103f4d:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103f54:	00 
  103f55:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103f5c:	e8 98 c4 ff ff       	call   1003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f64:	89 04 24             	mov    %eax,(%esp)
  103f67:	e8 2b eb ff ff       	call   102a97 <page2kva>
  103f6c:	05 00 01 00 00       	add    $0x100,%eax
  103f71:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103f74:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f7b:	e8 9a 14 00 00       	call   10541a <strlen>
  103f80:	85 c0                	test   %eax,%eax
  103f82:	74 24                	je     103fa8 <check_boot_pgdir+0x33e>
  103f84:	c7 44 24 0c cc 6b 10 	movl   $0x106bcc,0xc(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103f93:	00 
  103f94:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103f9b:	00 
  103f9c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103fa3:	e8 51 c4 ff ff       	call   1003f9 <__panic>

    free_page(p);
  103fa8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103faf:	00 
  103fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fb3:	89 04 24             	mov    %eax,(%esp)
  103fb6:	e8 b5 ed ff ff       	call   102d70 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103fbb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fc0:	8b 00                	mov    (%eax),%eax
  103fc2:	89 04 24             	mov    %eax,(%esp)
  103fc5:	e8 5f eb ff ff       	call   102b29 <pde2page>
  103fca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fd1:	00 
  103fd2:	89 04 24             	mov    %eax,(%esp)
  103fd5:	e8 96 ed ff ff       	call   102d70 <free_pages>
    boot_pgdir[0] = 0;
  103fda:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103fe5:	c7 04 24 f0 6b 10 00 	movl   $0x106bf0,(%esp)
  103fec:	e8 b1 c2 ff ff       	call   1002a2 <cprintf>
}
  103ff1:	90                   	nop
  103ff2:	c9                   	leave  
  103ff3:	c3                   	ret    

00103ff4 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103ff4:	55                   	push   %ebp
  103ff5:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  103ffa:	83 e0 04             	and    $0x4,%eax
  103ffd:	85 c0                	test   %eax,%eax
  103fff:	74 04                	je     104005 <perm2str+0x11>
  104001:	b0 75                	mov    $0x75,%al
  104003:	eb 02                	jmp    104007 <perm2str+0x13>
  104005:	b0 2d                	mov    $0x2d,%al
  104007:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  10400c:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104013:	8b 45 08             	mov    0x8(%ebp),%eax
  104016:	83 e0 02             	and    $0x2,%eax
  104019:	85 c0                	test   %eax,%eax
  10401b:	74 04                	je     104021 <perm2str+0x2d>
  10401d:	b0 77                	mov    $0x77,%al
  10401f:	eb 02                	jmp    104023 <perm2str+0x2f>
  104021:	b0 2d                	mov    $0x2d,%al
  104023:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  104028:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  10402f:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  104034:	5d                   	pop    %ebp
  104035:	c3                   	ret    

00104036 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104036:	55                   	push   %ebp
  104037:	89 e5                	mov    %esp,%ebp
  104039:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10403c:	8b 45 10             	mov    0x10(%ebp),%eax
  10403f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104042:	72 0d                	jb     104051 <get_pgtable_items+0x1b>
        return 0;
  104044:	b8 00 00 00 00       	mov    $0x0,%eax
  104049:	e9 98 00 00 00       	jmp    1040e6 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10404e:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104051:	8b 45 10             	mov    0x10(%ebp),%eax
  104054:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104057:	73 18                	jae    104071 <get_pgtable_items+0x3b>
  104059:	8b 45 10             	mov    0x10(%ebp),%eax
  10405c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104063:	8b 45 14             	mov    0x14(%ebp),%eax
  104066:	01 d0                	add    %edx,%eax
  104068:	8b 00                	mov    (%eax),%eax
  10406a:	83 e0 01             	and    $0x1,%eax
  10406d:	85 c0                	test   %eax,%eax
  10406f:	74 dd                	je     10404e <get_pgtable_items+0x18>
    }
    if (start < right) {
  104071:	8b 45 10             	mov    0x10(%ebp),%eax
  104074:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104077:	73 68                	jae    1040e1 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  104079:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10407d:	74 08                	je     104087 <get_pgtable_items+0x51>
            *left_store = start;
  10407f:	8b 45 18             	mov    0x18(%ebp),%eax
  104082:	8b 55 10             	mov    0x10(%ebp),%edx
  104085:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104087:	8b 45 10             	mov    0x10(%ebp),%eax
  10408a:	8d 50 01             	lea    0x1(%eax),%edx
  10408d:	89 55 10             	mov    %edx,0x10(%ebp)
  104090:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104097:	8b 45 14             	mov    0x14(%ebp),%eax
  10409a:	01 d0                	add    %edx,%eax
  10409c:	8b 00                	mov    (%eax),%eax
  10409e:	83 e0 07             	and    $0x7,%eax
  1040a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1040a4:	eb 03                	jmp    1040a9 <get_pgtable_items+0x73>
            start ++;
  1040a6:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1040a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1040ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040af:	73 1d                	jae    1040ce <get_pgtable_items+0x98>
  1040b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1040b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1040bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1040be:	01 d0                	add    %edx,%eax
  1040c0:	8b 00                	mov    (%eax),%eax
  1040c2:	83 e0 07             	and    $0x7,%eax
  1040c5:	89 c2                	mov    %eax,%edx
  1040c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040ca:	39 c2                	cmp    %eax,%edx
  1040cc:	74 d8                	je     1040a6 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1040ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1040d2:	74 08                	je     1040dc <get_pgtable_items+0xa6>
            *right_store = start;
  1040d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1040d7:	8b 55 10             	mov    0x10(%ebp),%edx
  1040da:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1040dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040df:	eb 05                	jmp    1040e6 <get_pgtable_items+0xb0>
    }
    return 0;
  1040e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1040e6:	c9                   	leave  
  1040e7:	c3                   	ret    

001040e8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1040e8:	55                   	push   %ebp
  1040e9:	89 e5                	mov    %esp,%ebp
  1040eb:	57                   	push   %edi
  1040ec:	56                   	push   %esi
  1040ed:	53                   	push   %ebx
  1040ee:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1040f1:	c7 04 24 10 6c 10 00 	movl   $0x106c10,(%esp)
  1040f8:	e8 a5 c1 ff ff       	call   1002a2 <cprintf>
    size_t left, right = 0, perm;
  1040fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104104:	e9 fa 00 00 00       	jmp    104203 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10410c:	89 04 24             	mov    %eax,(%esp)
  10410f:	e8 e0 fe ff ff       	call   103ff4 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104114:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104117:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10411a:	29 d1                	sub    %edx,%ecx
  10411c:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10411e:	89 d6                	mov    %edx,%esi
  104120:	c1 e6 16             	shl    $0x16,%esi
  104123:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104126:	89 d3                	mov    %edx,%ebx
  104128:	c1 e3 16             	shl    $0x16,%ebx
  10412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10412e:	89 d1                	mov    %edx,%ecx
  104130:	c1 e1 16             	shl    $0x16,%ecx
  104133:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104136:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104139:	29 d7                	sub    %edx,%edi
  10413b:	89 fa                	mov    %edi,%edx
  10413d:	89 44 24 14          	mov    %eax,0x14(%esp)
  104141:	89 74 24 10          	mov    %esi,0x10(%esp)
  104145:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104149:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10414d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104151:	c7 04 24 41 6c 10 00 	movl   $0x106c41,(%esp)
  104158:	e8 45 c1 ff ff       	call   1002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10415d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104160:	c1 e0 0a             	shl    $0xa,%eax
  104163:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104166:	eb 54                	jmp    1041bc <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10416b:	89 04 24             	mov    %eax,(%esp)
  10416e:	e8 81 fe ff ff       	call   103ff4 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104173:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104176:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104179:	29 d1                	sub    %edx,%ecx
  10417b:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10417d:	89 d6                	mov    %edx,%esi
  10417f:	c1 e6 0c             	shl    $0xc,%esi
  104182:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104185:	89 d3                	mov    %edx,%ebx
  104187:	c1 e3 0c             	shl    $0xc,%ebx
  10418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10418d:	89 d1                	mov    %edx,%ecx
  10418f:	c1 e1 0c             	shl    $0xc,%ecx
  104192:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104195:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104198:	29 d7                	sub    %edx,%edi
  10419a:	89 fa                	mov    %edi,%edx
  10419c:	89 44 24 14          	mov    %eax,0x14(%esp)
  1041a0:	89 74 24 10          	mov    %esi,0x10(%esp)
  1041a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1041a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1041ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041b0:	c7 04 24 60 6c 10 00 	movl   $0x106c60,(%esp)
  1041b7:	e8 e6 c0 ff ff       	call   1002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1041bc:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1041c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041c7:	89 d3                	mov    %edx,%ebx
  1041c9:	c1 e3 0a             	shl    $0xa,%ebx
  1041cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1041cf:	89 d1                	mov    %edx,%ecx
  1041d1:	c1 e1 0a             	shl    $0xa,%ecx
  1041d4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1041d7:	89 54 24 14          	mov    %edx,0x14(%esp)
  1041db:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1041de:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1041e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1041ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041ee:	89 0c 24             	mov    %ecx,(%esp)
  1041f1:	e8 40 fe ff ff       	call   104036 <get_pgtable_items>
  1041f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1041fd:	0f 85 65 ff ff ff    	jne    104168 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104203:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104208:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10420b:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10420e:	89 54 24 14          	mov    %edx,0x14(%esp)
  104212:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104215:	89 54 24 10          	mov    %edx,0x10(%esp)
  104219:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10421d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104221:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104228:	00 
  104229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104230:	e8 01 fe ff ff       	call   104036 <get_pgtable_items>
  104235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104238:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10423c:	0f 85 c7 fe ff ff    	jne    104109 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104242:	c7 04 24 84 6c 10 00 	movl   $0x106c84,(%esp)
  104249:	e8 54 c0 ff ff       	call   1002a2 <cprintf>
}
  10424e:	90                   	nop
  10424f:	83 c4 4c             	add    $0x4c,%esp
  104252:	5b                   	pop    %ebx
  104253:	5e                   	pop    %esi
  104254:	5f                   	pop    %edi
  104255:	5d                   	pop    %ebp
  104256:	c3                   	ret    

00104257 <page2ppn>:
page2ppn(struct Page *page) {
  104257:	55                   	push   %ebp
  104258:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10425a:	8b 45 08             	mov    0x8(%ebp),%eax
  10425d:	8b 15 78 af 11 00    	mov    0x11af78,%edx
  104263:	29 d0                	sub    %edx,%eax
  104265:	c1 f8 02             	sar    $0x2,%eax
  104268:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10426e:	5d                   	pop    %ebp
  10426f:	c3                   	ret    

00104270 <page2pa>:
page2pa(struct Page *page) {
  104270:	55                   	push   %ebp
  104271:	89 e5                	mov    %esp,%ebp
  104273:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104276:	8b 45 08             	mov    0x8(%ebp),%eax
  104279:	89 04 24             	mov    %eax,(%esp)
  10427c:	e8 d6 ff ff ff       	call   104257 <page2ppn>
  104281:	c1 e0 0c             	shl    $0xc,%eax
}
  104284:	c9                   	leave  
  104285:	c3                   	ret    

00104286 <page_ref>:
page_ref(struct Page *page) {
  104286:	55                   	push   %ebp
  104287:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104289:	8b 45 08             	mov    0x8(%ebp),%eax
  10428c:	8b 00                	mov    (%eax),%eax
}
  10428e:	5d                   	pop    %ebp
  10428f:	c3                   	ret    

00104290 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104290:	55                   	push   %ebp
  104291:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104293:	8b 45 08             	mov    0x8(%ebp),%eax
  104296:	8b 55 0c             	mov    0xc(%ebp),%edx
  104299:	89 10                	mov    %edx,(%eax)
}
  10429b:	90                   	nop
  10429c:	5d                   	pop    %ebp
  10429d:	c3                   	ret    

0010429e <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10429e:	55                   	push   %ebp
  10429f:	89 e5                	mov    %esp,%ebp
  1042a1:	83 ec 10             	sub    $0x10,%esp
  1042a4:	c7 45 fc 7c af 11 00 	movl   $0x11af7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1042ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1042b1:	89 50 04             	mov    %edx,0x4(%eax)
  1042b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042b7:	8b 50 04             	mov    0x4(%eax),%edx
  1042ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042bd:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1042bf:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  1042c6:	00 00 00 
}
  1042c9:	90                   	nop
  1042ca:	c9                   	leave  
  1042cb:	c3                   	ret    

001042cc <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1042cc:	55                   	push   %ebp
  1042cd:	89 e5                	mov    %esp,%ebp
  1042cf:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1042d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1042d6:	75 24                	jne    1042fc <default_init_memmap+0x30>
  1042d8:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  1042df:	00 
  1042e0:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1042e7:	00 
  1042e8:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  1042ef:	00 
  1042f0:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1042f7:	e8 fd c0 ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  1042fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104302:	eb 7d                	jmp    104381 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104307:	83 c0 04             	add    $0x4,%eax
  10430a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104311:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104317:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10431a:	0f a3 10             	bt     %edx,(%eax)
  10431d:	19 c0                	sbb    %eax,%eax
  10431f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104322:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104326:	0f 95 c0             	setne  %al
  104329:	0f b6 c0             	movzbl %al,%eax
  10432c:	85 c0                	test   %eax,%eax
  10432e:	75 24                	jne    104354 <default_init_memmap+0x88>
  104330:	c7 44 24 0c e9 6c 10 	movl   $0x106ce9,0xc(%esp)
  104337:	00 
  104338:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10433f:	00 
  104340:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  104347:	00 
  104348:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10434f:	e8 a5 c0 ff ff       	call   1003f9 <__panic>
        p->flags = p->property = 0;
  104354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104357:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10435e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104361:	8b 50 08             	mov    0x8(%eax),%edx
  104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104367:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10436a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104371:	00 
  104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104375:	89 04 24             	mov    %eax,(%esp)
  104378:	e8 13 ff ff ff       	call   104290 <set_page_ref>
    for (; p != base + n; p ++) {
  10437d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104381:	8b 55 0c             	mov    0xc(%ebp),%edx
  104384:	89 d0                	mov    %edx,%eax
  104386:	c1 e0 02             	shl    $0x2,%eax
  104389:	01 d0                	add    %edx,%eax
  10438b:	c1 e0 02             	shl    $0x2,%eax
  10438e:	89 c2                	mov    %eax,%edx
  104390:	8b 45 08             	mov    0x8(%ebp),%eax
  104393:	01 d0                	add    %edx,%eax
  104395:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104398:	0f 85 66 ff ff ff    	jne    104304 <default_init_memmap+0x38>
    }
    base->property = n;
  10439e:	8b 45 08             	mov    0x8(%ebp),%eax
  1043a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043a4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1043a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1043aa:	83 c0 04             	add    $0x4,%eax
  1043ad:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  1043b4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1043b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1043bd:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1043c0:	8b 15 84 af 11 00    	mov    0x11af84,%edx
  1043c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043c9:	01 d0                	add    %edx,%eax
  1043cb:	a3 84 af 11 00       	mov    %eax,0x11af84
    list_add(&free_list, &(base->page_link));
  1043d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d3:	83 c0 0c             	add    $0xc,%eax
  1043d6:	c7 45 e4 7c af 11 00 	movl   $0x11af7c,-0x1c(%ebp)
  1043dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1043e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1043e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1043ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043ef:	8b 40 04             	mov    0x4(%eax),%eax
  1043f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1043f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043fb:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1043fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104401:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104404:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104407:	89 10                	mov    %edx,(%eax)
  104409:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10440c:	8b 10                	mov    (%eax),%edx
  10440e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104411:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104414:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104417:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10441a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10441d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104420:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104423:	89 10                	mov    %edx,(%eax)
}
  104425:	90                   	nop
  104426:	c9                   	leave  
  104427:	c3                   	ret    

00104428 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104428:	55                   	push   %ebp
  104429:	89 e5                	mov    %esp,%ebp
  10442b:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10442e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104432:	75 24                	jne    104458 <default_alloc_pages+0x30>
  104434:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  10443b:	00 
  10443c:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104443:	00 
  104444:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  10444b:	00 
  10444c:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104453:	e8 a1 bf ff ff       	call   1003f9 <__panic>
    if (n > nr_free) {
  104458:	a1 84 af 11 00       	mov    0x11af84,%eax
  10445d:	39 45 08             	cmp    %eax,0x8(%ebp)
  104460:	76 0a                	jbe    10446c <default_alloc_pages+0x44>
        return NULL;
  104462:	b8 00 00 00 00       	mov    $0x0,%eax
  104467:	e9 2a 01 00 00       	jmp    104596 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  10446c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104473:	c7 45 f0 7c af 11 00 	movl   $0x11af7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10447a:	eb 1c                	jmp    104498 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  10447c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10447f:	83 e8 0c             	sub    $0xc,%eax
  104482:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  104485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104488:	8b 40 08             	mov    0x8(%eax),%eax
  10448b:	39 45 08             	cmp    %eax,0x8(%ebp)
  10448e:	77 08                	ja     104498 <default_alloc_pages+0x70>
            page = p;
  104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104493:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104496:	eb 18                	jmp    1044b0 <default_alloc_pages+0x88>
  104498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10449b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  10449e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044a1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1044a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044a7:	81 7d f0 7c af 11 00 	cmpl   $0x11af7c,-0x10(%ebp)
  1044ae:	75 cc                	jne    10447c <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  1044b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b4:	0f 84 d9 00 00 00    	je     104593 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  1044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044bd:	83 c0 0c             	add    $0xc,%eax
  1044c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  1044c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044c6:	8b 40 04             	mov    0x4(%eax),%eax
  1044c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044cc:	8b 12                	mov    (%edx),%edx
  1044ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1044d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1044d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1044dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1044e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044e3:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e8:	8b 40 08             	mov    0x8(%eax),%eax
  1044eb:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044ee:	73 7d                	jae    10456d <default_alloc_pages+0x145>
            struct Page *p = page + n;
  1044f0:	8b 55 08             	mov    0x8(%ebp),%edx
  1044f3:	89 d0                	mov    %edx,%eax
  1044f5:	c1 e0 02             	shl    $0x2,%eax
  1044f8:	01 d0                	add    %edx,%eax
  1044fa:	c1 e0 02             	shl    $0x2,%eax
  1044fd:	89 c2                	mov    %eax,%edx
  1044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104502:	01 d0                	add    %edx,%eax
  104504:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10450a:	8b 40 08             	mov    0x8(%eax),%eax
  10450d:	2b 45 08             	sub    0x8(%ebp),%eax
  104510:	89 c2                	mov    %eax,%edx
  104512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104515:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  104518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10451b:	83 c0 0c             	add    $0xc,%eax
  10451e:	c7 45 d4 7c af 11 00 	movl   $0x11af7c,-0x2c(%ebp)
  104525:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10452b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10452e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104531:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  104534:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104537:	8b 40 04             	mov    0x4(%eax),%eax
  10453a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10453d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104540:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104543:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104546:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  104549:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10454c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10454f:	89 10                	mov    %edx,(%eax)
  104551:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104554:	8b 10                	mov    (%eax),%edx
  104556:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104559:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10455c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10455f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104562:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104565:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104568:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10456b:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  10456d:	a1 84 af 11 00       	mov    0x11af84,%eax
  104572:	2b 45 08             	sub    0x8(%ebp),%eax
  104575:	a3 84 af 11 00       	mov    %eax,0x11af84
        ClearPageProperty(page);
  10457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457d:	83 c0 04             	add    $0x4,%eax
  104580:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104587:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10458a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10458d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104590:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104596:	c9                   	leave  
  104597:	c3                   	ret    

00104598 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104598:	55                   	push   %ebp
  104599:	89 e5                	mov    %esp,%ebp
  10459b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1045a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1045a5:	75 24                	jne    1045cb <default_free_pages+0x33>
  1045a7:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  1045ae:	00 
  1045af:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1045b6:	00 
  1045b7:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  1045be:	00 
  1045bf:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1045c6:	e8 2e be ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  1045cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1045d1:	e9 9d 00 00 00       	jmp    104673 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  1045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d9:	83 c0 04             	add    $0x4,%eax
  1045dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1045e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1045ec:	0f a3 10             	bt     %edx,(%eax)
  1045ef:	19 c0                	sbb    %eax,%eax
  1045f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1045f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1045f8:	0f 95 c0             	setne  %al
  1045fb:	0f b6 c0             	movzbl %al,%eax
  1045fe:	85 c0                	test   %eax,%eax
  104600:	75 2c                	jne    10462e <default_free_pages+0x96>
  104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104605:	83 c0 04             	add    $0x4,%eax
  104608:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10460f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104612:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104615:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104618:	0f a3 10             	bt     %edx,(%eax)
  10461b:	19 c0                	sbb    %eax,%eax
  10461d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104620:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104624:	0f 95 c0             	setne  %al
  104627:	0f b6 c0             	movzbl %al,%eax
  10462a:	85 c0                	test   %eax,%eax
  10462c:	74 24                	je     104652 <default_free_pages+0xba>
  10462e:	c7 44 24 0c fc 6c 10 	movl   $0x106cfc,0xc(%esp)
  104635:	00 
  104636:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10463d:	00 
  10463e:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  104645:	00 
  104646:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10464d:	e8 a7 bd ff ff       	call   1003f9 <__panic>
        p->flags = 0;
  104652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  10465c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104663:	00 
  104664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104667:	89 04 24             	mov    %eax,(%esp)
  10466a:	e8 21 fc ff ff       	call   104290 <set_page_ref>
    for (; p != base + n; p ++) {
  10466f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104673:	8b 55 0c             	mov    0xc(%ebp),%edx
  104676:	89 d0                	mov    %edx,%eax
  104678:	c1 e0 02             	shl    $0x2,%eax
  10467b:	01 d0                	add    %edx,%eax
  10467d:	c1 e0 02             	shl    $0x2,%eax
  104680:	89 c2                	mov    %eax,%edx
  104682:	8b 45 08             	mov    0x8(%ebp),%eax
  104685:	01 d0                	add    %edx,%eax
  104687:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10468a:	0f 85 46 ff ff ff    	jne    1045d6 <default_free_pages+0x3e>
    }
    base->property = n;
  104690:	8b 45 08             	mov    0x8(%ebp),%eax
  104693:	8b 55 0c             	mov    0xc(%ebp),%edx
  104696:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104699:	8b 45 08             	mov    0x8(%ebp),%eax
  10469c:	83 c0 04             	add    $0x4,%eax
  10469f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1046a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1046ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1046af:	0f ab 10             	bts    %edx,(%eax)
  1046b2:	c7 45 d4 7c af 11 00 	movl   $0x11af7c,-0x2c(%ebp)
    return listelm->next;
  1046b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1046bc:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1046bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1046c2:	e9 08 01 00 00       	jmp    1047cf <default_free_pages+0x237>
        p = le2page(le, page_link);
  1046c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ca:	83 e8 0c             	sub    $0xc,%eax
  1046cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1046d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1046d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046d9:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1046dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  1046df:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e2:	8b 50 08             	mov    0x8(%eax),%edx
  1046e5:	89 d0                	mov    %edx,%eax
  1046e7:	c1 e0 02             	shl    $0x2,%eax
  1046ea:	01 d0                	add    %edx,%eax
  1046ec:	c1 e0 02             	shl    $0x2,%eax
  1046ef:	89 c2                	mov    %eax,%edx
  1046f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046f4:	01 d0                	add    %edx,%eax
  1046f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1046f9:	75 5a                	jne    104755 <default_free_pages+0x1bd>
            base->property += p->property;
  1046fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fe:	8b 50 08             	mov    0x8(%eax),%edx
  104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104704:	8b 40 08             	mov    0x8(%eax),%eax
  104707:	01 c2                	add    %eax,%edx
  104709:	8b 45 08             	mov    0x8(%ebp),%eax
  10470c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104712:	83 c0 04             	add    $0x4,%eax
  104715:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10471c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10471f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104722:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104725:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472b:	83 c0 0c             	add    $0xc,%eax
  10472e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104731:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104734:	8b 40 04             	mov    0x4(%eax),%eax
  104737:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10473a:	8b 12                	mov    (%edx),%edx
  10473c:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10473f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104742:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104745:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104748:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10474b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10474e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104751:	89 10                	mov    %edx,(%eax)
  104753:	eb 7a                	jmp    1047cf <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  104755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104758:	8b 50 08             	mov    0x8(%eax),%edx
  10475b:	89 d0                	mov    %edx,%eax
  10475d:	c1 e0 02             	shl    $0x2,%eax
  104760:	01 d0                	add    %edx,%eax
  104762:	c1 e0 02             	shl    $0x2,%eax
  104765:	89 c2                	mov    %eax,%edx
  104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476a:	01 d0                	add    %edx,%eax
  10476c:	39 45 08             	cmp    %eax,0x8(%ebp)
  10476f:	75 5e                	jne    1047cf <default_free_pages+0x237>
            p->property += base->property;
  104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104774:	8b 50 08             	mov    0x8(%eax),%edx
  104777:	8b 45 08             	mov    0x8(%ebp),%eax
  10477a:	8b 40 08             	mov    0x8(%eax),%eax
  10477d:	01 c2                	add    %eax,%edx
  10477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104782:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104785:	8b 45 08             	mov    0x8(%ebp),%eax
  104788:	83 c0 04             	add    $0x4,%eax
  10478b:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104792:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104795:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104798:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10479b:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  10479e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a1:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a7:	83 c0 0c             	add    $0xc,%eax
  1047aa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  1047ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1047b0:	8b 40 04             	mov    0x4(%eax),%eax
  1047b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1047b6:	8b 12                	mov    (%edx),%edx
  1047b8:	89 55 ac             	mov    %edx,-0x54(%ebp)
  1047bb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  1047be:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1047c1:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1047c4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1047c7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1047ca:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1047cd:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  1047cf:	81 7d f0 7c af 11 00 	cmpl   $0x11af7c,-0x10(%ebp)
  1047d6:	0f 85 eb fe ff ff    	jne    1046c7 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  1047dc:	8b 15 84 af 11 00    	mov    0x11af84,%edx
  1047e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047e5:	01 d0                	add    %edx,%eax
  1047e7:	a3 84 af 11 00       	mov    %eax,0x11af84
    list_add(&free_list, &(base->page_link));
  1047ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ef:	83 c0 0c             	add    $0xc,%eax
  1047f2:	c7 45 9c 7c af 11 00 	movl   $0x11af7c,-0x64(%ebp)
  1047f9:	89 45 98             	mov    %eax,-0x68(%ebp)
  1047fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1047ff:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104802:	8b 45 98             	mov    -0x68(%ebp),%eax
  104805:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
  104808:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10480b:	8b 40 04             	mov    0x4(%eax),%eax
  10480e:	8b 55 90             	mov    -0x70(%ebp),%edx
  104811:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104814:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104817:	89 55 88             	mov    %edx,-0x78(%ebp)
  10481a:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  10481d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104820:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104823:	89 10                	mov    %edx,(%eax)
  104825:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104828:	8b 10                	mov    (%eax),%edx
  10482a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10482d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104830:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104833:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104836:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104839:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10483c:	8b 55 88             	mov    -0x78(%ebp),%edx
  10483f:	89 10                	mov    %edx,(%eax)
}
  104841:	90                   	nop
  104842:	c9                   	leave  
  104843:	c3                   	ret    

00104844 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104844:	55                   	push   %ebp
  104845:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104847:	a1 84 af 11 00       	mov    0x11af84,%eax
}
  10484c:	5d                   	pop    %ebp
  10484d:	c3                   	ret    

0010484e <basic_check>:

static void
basic_check(void) {
  10484e:	55                   	push   %ebp
  10484f:	89 e5                	mov    %esp,%ebp
  104851:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104854:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104864:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104867:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10486e:	e8 c5 e4 ff ff       	call   102d38 <alloc_pages>
  104873:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10487a:	75 24                	jne    1048a0 <basic_check+0x52>
  10487c:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  104883:	00 
  104884:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10488b:	00 
  10488c:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  104893:	00 
  104894:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10489b:	e8 59 bb ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1048a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048a7:	e8 8c e4 ff ff       	call   102d38 <alloc_pages>
  1048ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048b3:	75 24                	jne    1048d9 <basic_check+0x8b>
  1048b5:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  1048bc:	00 
  1048bd:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1048c4:	00 
  1048c5:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  1048cc:	00 
  1048cd:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1048d4:	e8 20 bb ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048e0:	e8 53 e4 ff ff       	call   102d38 <alloc_pages>
  1048e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048ec:	75 24                	jne    104912 <basic_check+0xc4>
  1048ee:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  1048f5:	00 
  1048f6:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1048fd:	00 
  1048fe:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  104905:	00 
  104906:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10490d:	e8 e7 ba ff ff       	call   1003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104915:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104918:	74 10                	je     10492a <basic_check+0xdc>
  10491a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10491d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104920:	74 08                	je     10492a <basic_check+0xdc>
  104922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104925:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104928:	75 24                	jne    10494e <basic_check+0x100>
  10492a:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  104931:	00 
  104932:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104939:	00 
  10493a:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  104941:	00 
  104942:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104949:	e8 ab ba ff ff       	call   1003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10494e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104951:	89 04 24             	mov    %eax,(%esp)
  104954:	e8 2d f9 ff ff       	call   104286 <page_ref>
  104959:	85 c0                	test   %eax,%eax
  10495b:	75 1e                	jne    10497b <basic_check+0x12d>
  10495d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104960:	89 04 24             	mov    %eax,(%esp)
  104963:	e8 1e f9 ff ff       	call   104286 <page_ref>
  104968:	85 c0                	test   %eax,%eax
  10496a:	75 0f                	jne    10497b <basic_check+0x12d>
  10496c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10496f:	89 04 24             	mov    %eax,(%esp)
  104972:	e8 0f f9 ff ff       	call   104286 <page_ref>
  104977:	85 c0                	test   %eax,%eax
  104979:	74 24                	je     10499f <basic_check+0x151>
  10497b:	c7 44 24 0c 9c 6d 10 	movl   $0x106d9c,0xc(%esp)
  104982:	00 
  104983:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10498a:	00 
  10498b:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  104992:	00 
  104993:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10499a:	e8 5a ba ff ff       	call   1003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10499f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049a2:	89 04 24             	mov    %eax,(%esp)
  1049a5:	e8 c6 f8 ff ff       	call   104270 <page2pa>
  1049aa:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1049b0:	c1 e2 0c             	shl    $0xc,%edx
  1049b3:	39 d0                	cmp    %edx,%eax
  1049b5:	72 24                	jb     1049db <basic_check+0x18d>
  1049b7:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  1049be:	00 
  1049bf:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1049c6:	00 
  1049c7:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  1049ce:	00 
  1049cf:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1049d6:	e8 1e ba ff ff       	call   1003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1049db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049de:	89 04 24             	mov    %eax,(%esp)
  1049e1:	e8 8a f8 ff ff       	call   104270 <page2pa>
  1049e6:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1049ec:	c1 e2 0c             	shl    $0xc,%edx
  1049ef:	39 d0                	cmp    %edx,%eax
  1049f1:	72 24                	jb     104a17 <basic_check+0x1c9>
  1049f3:	c7 44 24 0c f5 6d 10 	movl   $0x106df5,0xc(%esp)
  1049fa:	00 
  1049fb:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a02:	00 
  104a03:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  104a0a:	00 
  104a0b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a12:	e8 e2 b9 ff ff       	call   1003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a1a:	89 04 24             	mov    %eax,(%esp)
  104a1d:	e8 4e f8 ff ff       	call   104270 <page2pa>
  104a22:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104a28:	c1 e2 0c             	shl    $0xc,%edx
  104a2b:	39 d0                	cmp    %edx,%eax
  104a2d:	72 24                	jb     104a53 <basic_check+0x205>
  104a2f:	c7 44 24 0c 12 6e 10 	movl   $0x106e12,0xc(%esp)
  104a36:	00 
  104a37:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a3e:	00 
  104a3f:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  104a46:	00 
  104a47:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a4e:	e8 a6 b9 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  104a53:	a1 7c af 11 00       	mov    0x11af7c,%eax
  104a58:	8b 15 80 af 11 00    	mov    0x11af80,%edx
  104a5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104a61:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a64:	c7 45 dc 7c af 11 00 	movl   $0x11af7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104a71:	89 50 04             	mov    %edx,0x4(%eax)
  104a74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a77:	8b 50 04             	mov    0x4(%eax),%edx
  104a7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a7d:	89 10                	mov    %edx,(%eax)
  104a7f:	c7 45 e0 7c af 11 00 	movl   $0x11af7c,-0x20(%ebp)
    return list->next == list;
  104a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a89:	8b 40 04             	mov    0x4(%eax),%eax
  104a8c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104a8f:	0f 94 c0             	sete   %al
  104a92:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104a95:	85 c0                	test   %eax,%eax
  104a97:	75 24                	jne    104abd <basic_check+0x26f>
  104a99:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104aa0:	00 
  104aa1:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104aa8:	00 
  104aa9:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104ab0:	00 
  104ab1:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104ab8:	e8 3c b9 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  104abd:	a1 84 af 11 00       	mov    0x11af84,%eax
  104ac2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104ac5:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  104acc:	00 00 00 

    assert(alloc_page() == NULL);
  104acf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ad6:	e8 5d e2 ff ff       	call   102d38 <alloc_pages>
  104adb:	85 c0                	test   %eax,%eax
  104add:	74 24                	je     104b03 <basic_check+0x2b5>
  104adf:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104ae6:	00 
  104ae7:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104aee:	00 
  104aef:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104af6:	00 
  104af7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104afe:	e8 f6 b8 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  104b03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b0a:	00 
  104b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b0e:	89 04 24             	mov    %eax,(%esp)
  104b11:	e8 5a e2 ff ff       	call   102d70 <free_pages>
    free_page(p1);
  104b16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b1d:	00 
  104b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b21:	89 04 24             	mov    %eax,(%esp)
  104b24:	e8 47 e2 ff ff       	call   102d70 <free_pages>
    free_page(p2);
  104b29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b30:	00 
  104b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b34:	89 04 24             	mov    %eax,(%esp)
  104b37:	e8 34 e2 ff ff       	call   102d70 <free_pages>
    assert(nr_free == 3);
  104b3c:	a1 84 af 11 00       	mov    0x11af84,%eax
  104b41:	83 f8 03             	cmp    $0x3,%eax
  104b44:	74 24                	je     104b6a <basic_check+0x31c>
  104b46:	c7 44 24 0c 5b 6e 10 	movl   $0x106e5b,0xc(%esp)
  104b4d:	00 
  104b4e:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b55:	00 
  104b56:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104b5d:	00 
  104b5e:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b65:	e8 8f b8 ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b71:	e8 c2 e1 ff ff       	call   102d38 <alloc_pages>
  104b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b7d:	75 24                	jne    104ba3 <basic_check+0x355>
  104b7f:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  104b86:	00 
  104b87:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b8e:	00 
  104b8f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104b96:	00 
  104b97:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b9e:	e8 56 b8 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104baa:	e8 89 e1 ff ff       	call   102d38 <alloc_pages>
  104baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104bb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104bb6:	75 24                	jne    104bdc <basic_check+0x38e>
  104bb8:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  104bbf:	00 
  104bc0:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104bc7:	00 
  104bc8:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  104bcf:	00 
  104bd0:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104bd7:	e8 1d b8 ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104bdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104be3:	e8 50 e1 ff ff       	call   102d38 <alloc_pages>
  104be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104bef:	75 24                	jne    104c15 <basic_check+0x3c7>
  104bf1:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  104bf8:	00 
  104bf9:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c00:	00 
  104c01:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  104c08:	00 
  104c09:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c10:	e8 e4 b7 ff ff       	call   1003f9 <__panic>

    assert(alloc_page() == NULL);
  104c15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c1c:	e8 17 e1 ff ff       	call   102d38 <alloc_pages>
  104c21:	85 c0                	test   %eax,%eax
  104c23:	74 24                	je     104c49 <basic_check+0x3fb>
  104c25:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104c2c:	00 
  104c2d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c34:	00 
  104c35:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104c3c:	00 
  104c3d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c44:	e8 b0 b7 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  104c49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c50:	00 
  104c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c54:	89 04 24             	mov    %eax,(%esp)
  104c57:	e8 14 e1 ff ff       	call   102d70 <free_pages>
  104c5c:	c7 45 d8 7c af 11 00 	movl   $0x11af7c,-0x28(%ebp)
  104c63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c66:	8b 40 04             	mov    0x4(%eax),%eax
  104c69:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104c6c:	0f 94 c0             	sete   %al
  104c6f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104c72:	85 c0                	test   %eax,%eax
  104c74:	74 24                	je     104c9a <basic_check+0x44c>
  104c76:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104c7d:	00 
  104c7e:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c85:	00 
  104c86:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  104c8d:	00 
  104c8e:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c95:	e8 5f b7 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104c9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ca1:	e8 92 e0 ff ff       	call   102d38 <alloc_pages>
  104ca6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104caf:	74 24                	je     104cd5 <basic_check+0x487>
  104cb1:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104cb8:	00 
  104cb9:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104cc0:	00 
  104cc1:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104cc8:	00 
  104cc9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104cd0:	e8 24 b7 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  104cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cdc:	e8 57 e0 ff ff       	call   102d38 <alloc_pages>
  104ce1:	85 c0                	test   %eax,%eax
  104ce3:	74 24                	je     104d09 <basic_check+0x4bb>
  104ce5:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104cec:	00 
  104ced:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104cf4:	00 
  104cf5:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104cfc:	00 
  104cfd:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104d04:	e8 f0 b6 ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  104d09:	a1 84 af 11 00       	mov    0x11af84,%eax
  104d0e:	85 c0                	test   %eax,%eax
  104d10:	74 24                	je     104d36 <basic_check+0x4e8>
  104d12:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104d19:	00 
  104d1a:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104d21:	00 
  104d22:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104d29:	00 
  104d2a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104d31:	e8 c3 b6 ff ff       	call   1003f9 <__panic>
    free_list = free_list_store;
  104d36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104d3c:	a3 7c af 11 00       	mov    %eax,0x11af7c
  104d41:	89 15 80 af 11 00    	mov    %edx,0x11af80
    nr_free = nr_free_store;
  104d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d4a:	a3 84 af 11 00       	mov    %eax,0x11af84

    free_page(p);
  104d4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d56:	00 
  104d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d5a:	89 04 24             	mov    %eax,(%esp)
  104d5d:	e8 0e e0 ff ff       	call   102d70 <free_pages>
    free_page(p1);
  104d62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d69:	00 
  104d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d6d:	89 04 24             	mov    %eax,(%esp)
  104d70:	e8 fb df ff ff       	call   102d70 <free_pages>
    free_page(p2);
  104d75:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d7c:	00 
  104d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d80:	89 04 24             	mov    %eax,(%esp)
  104d83:	e8 e8 df ff ff       	call   102d70 <free_pages>
}
  104d88:	90                   	nop
  104d89:	c9                   	leave  
  104d8a:	c3                   	ret    

00104d8b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104d8b:	55                   	push   %ebp
  104d8c:	89 e5                	mov    %esp,%ebp
  104d8e:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d9b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104da2:	c7 45 ec 7c af 11 00 	movl   $0x11af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104da9:	eb 6a                	jmp    104e15 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  104dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dae:	83 e8 0c             	sub    $0xc,%eax
  104db1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104db4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104db7:	83 c0 04             	add    $0x4,%eax
  104dba:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104dc1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104dc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104dc7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104dca:	0f a3 10             	bt     %edx,(%eax)
  104dcd:	19 c0                	sbb    %eax,%eax
  104dcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104dd2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104dd6:	0f 95 c0             	setne  %al
  104dd9:	0f b6 c0             	movzbl %al,%eax
  104ddc:	85 c0                	test   %eax,%eax
  104dde:	75 24                	jne    104e04 <default_check+0x79>
  104de0:	c7 44 24 0c a6 6e 10 	movl   $0x106ea6,0xc(%esp)
  104de7:	00 
  104de8:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104def:	00 
  104df0:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104df7:	00 
  104df8:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104dff:	e8 f5 b5 ff ff       	call   1003f9 <__panic>
        count ++, total += p->property;
  104e04:	ff 45 f4             	incl   -0xc(%ebp)
  104e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e0a:	8b 50 08             	mov    0x8(%eax),%edx
  104e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e10:	01 d0                	add    %edx,%eax
  104e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104e1b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e1e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e24:	81 7d ec 7c af 11 00 	cmpl   $0x11af7c,-0x14(%ebp)
  104e2b:	0f 85 7a ff ff ff    	jne    104dab <default_check+0x20>
    }
    assert(total == nr_free_pages());
  104e31:	e8 6d df ff ff       	call   102da3 <nr_free_pages>
  104e36:	89 c2                	mov    %eax,%edx
  104e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e3b:	39 c2                	cmp    %eax,%edx
  104e3d:	74 24                	je     104e63 <default_check+0xd8>
  104e3f:	c7 44 24 0c b6 6e 10 	movl   $0x106eb6,0xc(%esp)
  104e46:	00 
  104e47:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e4e:	00 
  104e4f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104e56:	00 
  104e57:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e5e:	e8 96 b5 ff ff       	call   1003f9 <__panic>

    basic_check();
  104e63:	e8 e6 f9 ff ff       	call   10484e <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104e68:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104e6f:	e8 c4 de ff ff       	call   102d38 <alloc_pages>
  104e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  104e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e7b:	75 24                	jne    104ea1 <default_check+0x116>
  104e7d:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  104e84:	00 
  104e85:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e8c:	00 
  104e8d:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104e94:	00 
  104e95:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e9c:	e8 58 b5 ff ff       	call   1003f9 <__panic>
    assert(!PageProperty(p0));
  104ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ea4:	83 c0 04             	add    $0x4,%eax
  104ea7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104eae:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104eb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104eb4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104eb7:	0f a3 10             	bt     %edx,(%eax)
  104eba:	19 c0                	sbb    %eax,%eax
  104ebc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104ebf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104ec3:	0f 95 c0             	setne  %al
  104ec6:	0f b6 c0             	movzbl %al,%eax
  104ec9:	85 c0                	test   %eax,%eax
  104ecb:	74 24                	je     104ef1 <default_check+0x166>
  104ecd:	c7 44 24 0c da 6e 10 	movl   $0x106eda,0xc(%esp)
  104ed4:	00 
  104ed5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104edc:	00 
  104edd:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104ee4:	00 
  104ee5:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104eec:	e8 08 b5 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  104ef1:	a1 7c af 11 00       	mov    0x11af7c,%eax
  104ef6:	8b 15 80 af 11 00    	mov    0x11af80,%edx
  104efc:	89 45 80             	mov    %eax,-0x80(%ebp)
  104eff:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104f02:	c7 45 b0 7c af 11 00 	movl   $0x11af7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104f09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f0c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104f0f:	89 50 04             	mov    %edx,0x4(%eax)
  104f12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f15:	8b 50 04             	mov    0x4(%eax),%edx
  104f18:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f1b:	89 10                	mov    %edx,(%eax)
  104f1d:	c7 45 b4 7c af 11 00 	movl   $0x11af7c,-0x4c(%ebp)
    return list->next == list;
  104f24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f27:	8b 40 04             	mov    0x4(%eax),%eax
  104f2a:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104f2d:	0f 94 c0             	sete   %al
  104f30:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104f33:	85 c0                	test   %eax,%eax
  104f35:	75 24                	jne    104f5b <default_check+0x1d0>
  104f37:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104f3e:	00 
  104f3f:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f46:	00 
  104f47:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104f4e:	00 
  104f4f:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f56:	e8 9e b4 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  104f5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f62:	e8 d1 dd ff ff       	call   102d38 <alloc_pages>
  104f67:	85 c0                	test   %eax,%eax
  104f69:	74 24                	je     104f8f <default_check+0x204>
  104f6b:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104f72:	00 
  104f73:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f7a:	00 
  104f7b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  104f82:	00 
  104f83:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f8a:	e8 6a b4 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  104f8f:	a1 84 af 11 00       	mov    0x11af84,%eax
  104f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  104f97:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  104f9e:	00 00 00 

    free_pages(p0 + 2, 3);
  104fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fa4:	83 c0 28             	add    $0x28,%eax
  104fa7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104fae:	00 
  104faf:	89 04 24             	mov    %eax,(%esp)
  104fb2:	e8 b9 dd ff ff       	call   102d70 <free_pages>
    assert(alloc_pages(4) == NULL);
  104fb7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104fbe:	e8 75 dd ff ff       	call   102d38 <alloc_pages>
  104fc3:	85 c0                	test   %eax,%eax
  104fc5:	74 24                	je     104feb <default_check+0x260>
  104fc7:	c7 44 24 0c ec 6e 10 	movl   $0x106eec,0xc(%esp)
  104fce:	00 
  104fcf:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104fd6:	00 
  104fd7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  104fde:	00 
  104fdf:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104fe6:	e8 0e b4 ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fee:	83 c0 28             	add    $0x28,%eax
  104ff1:	83 c0 04             	add    $0x4,%eax
  104ff4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104ffb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ffe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105001:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105004:	0f a3 10             	bt     %edx,(%eax)
  105007:	19 c0                	sbb    %eax,%eax
  105009:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10500c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105010:	0f 95 c0             	setne  %al
  105013:	0f b6 c0             	movzbl %al,%eax
  105016:	85 c0                	test   %eax,%eax
  105018:	74 0e                	je     105028 <default_check+0x29d>
  10501a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10501d:	83 c0 28             	add    $0x28,%eax
  105020:	8b 40 08             	mov    0x8(%eax),%eax
  105023:	83 f8 03             	cmp    $0x3,%eax
  105026:	74 24                	je     10504c <default_check+0x2c1>
  105028:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  10502f:	00 
  105030:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105037:	00 
  105038:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10503f:	00 
  105040:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105047:	e8 ad b3 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10504c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105053:	e8 e0 dc ff ff       	call   102d38 <alloc_pages>
  105058:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10505b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10505f:	75 24                	jne    105085 <default_check+0x2fa>
  105061:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  105068:	00 
  105069:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105070:	00 
  105071:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  105078:	00 
  105079:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105080:	e8 74 b3 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  105085:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10508c:	e8 a7 dc ff ff       	call   102d38 <alloc_pages>
  105091:	85 c0                	test   %eax,%eax
  105093:	74 24                	je     1050b9 <default_check+0x32e>
  105095:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  10509c:	00 
  10509d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1050a4:	00 
  1050a5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1050ac:	00 
  1050ad:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1050b4:	e8 40 b3 ff ff       	call   1003f9 <__panic>
    assert(p0 + 2 == p1);
  1050b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050bc:	83 c0 28             	add    $0x28,%eax
  1050bf:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1050c2:	74 24                	je     1050e8 <default_check+0x35d>
  1050c4:	c7 44 24 0c 4e 6f 10 	movl   $0x106f4e,0xc(%esp)
  1050cb:	00 
  1050cc:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1050d3:	00 
  1050d4:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1050db:	00 
  1050dc:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1050e3:	e8 11 b3 ff ff       	call   1003f9 <__panic>

    p2 = p0 + 1;
  1050e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050eb:	83 c0 14             	add    $0x14,%eax
  1050ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1050f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050f8:	00 
  1050f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050fc:	89 04 24             	mov    %eax,(%esp)
  1050ff:	e8 6c dc ff ff       	call   102d70 <free_pages>
    free_pages(p1, 3);
  105104:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10510b:	00 
  10510c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10510f:	89 04 24             	mov    %eax,(%esp)
  105112:	e8 59 dc ff ff       	call   102d70 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10511a:	83 c0 04             	add    $0x4,%eax
  10511d:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105124:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105127:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10512a:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10512d:	0f a3 10             	bt     %edx,(%eax)
  105130:	19 c0                	sbb    %eax,%eax
  105132:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105135:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105139:	0f 95 c0             	setne  %al
  10513c:	0f b6 c0             	movzbl %al,%eax
  10513f:	85 c0                	test   %eax,%eax
  105141:	74 0b                	je     10514e <default_check+0x3c3>
  105143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105146:	8b 40 08             	mov    0x8(%eax),%eax
  105149:	83 f8 01             	cmp    $0x1,%eax
  10514c:	74 24                	je     105172 <default_check+0x3e7>
  10514e:	c7 44 24 0c 5c 6f 10 	movl   $0x106f5c,0xc(%esp)
  105155:	00 
  105156:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10515d:	00 
  10515e:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  105165:	00 
  105166:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10516d:	e8 87 b2 ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105175:	83 c0 04             	add    $0x4,%eax
  105178:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10517f:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105182:	8b 45 90             	mov    -0x70(%ebp),%eax
  105185:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105188:	0f a3 10             	bt     %edx,(%eax)
  10518b:	19 c0                	sbb    %eax,%eax
  10518d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105190:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105194:	0f 95 c0             	setne  %al
  105197:	0f b6 c0             	movzbl %al,%eax
  10519a:	85 c0                	test   %eax,%eax
  10519c:	74 0b                	je     1051a9 <default_check+0x41e>
  10519e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051a1:	8b 40 08             	mov    0x8(%eax),%eax
  1051a4:	83 f8 03             	cmp    $0x3,%eax
  1051a7:	74 24                	je     1051cd <default_check+0x442>
  1051a9:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  1051b0:	00 
  1051b1:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1051b8:	00 
  1051b9:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  1051c0:	00 
  1051c1:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1051c8:	e8 2c b2 ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1051cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051d4:	e8 5f db ff ff       	call   102d38 <alloc_pages>
  1051d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1051dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051df:	83 e8 14             	sub    $0x14,%eax
  1051e2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1051e5:	74 24                	je     10520b <default_check+0x480>
  1051e7:	c7 44 24 0c aa 6f 10 	movl   $0x106faa,0xc(%esp)
  1051ee:	00 
  1051ef:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1051f6:	00 
  1051f7:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1051fe:	00 
  1051ff:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105206:	e8 ee b1 ff ff       	call   1003f9 <__panic>
    free_page(p0);
  10520b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105212:	00 
  105213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105216:	89 04 24             	mov    %eax,(%esp)
  105219:	e8 52 db ff ff       	call   102d70 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10521e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105225:	e8 0e db ff ff       	call   102d38 <alloc_pages>
  10522a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10522d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105230:	83 c0 14             	add    $0x14,%eax
  105233:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105236:	74 24                	je     10525c <default_check+0x4d1>
  105238:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  10523f:	00 
  105240:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105247:	00 
  105248:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10524f:	00 
  105250:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105257:	e8 9d b1 ff ff       	call   1003f9 <__panic>

    free_pages(p0, 2);
  10525c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105263:	00 
  105264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105267:	89 04 24             	mov    %eax,(%esp)
  10526a:	e8 01 db ff ff       	call   102d70 <free_pages>
    free_page(p2);
  10526f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105276:	00 
  105277:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10527a:	89 04 24             	mov    %eax,(%esp)
  10527d:	e8 ee da ff ff       	call   102d70 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105282:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105289:	e8 aa da ff ff       	call   102d38 <alloc_pages>
  10528e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105291:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105295:	75 24                	jne    1052bb <default_check+0x530>
  105297:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  10529e:	00 
  10529f:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052a6:	00 
  1052a7:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1052ae:	00 
  1052af:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052b6:	e8 3e b1 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  1052bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052c2:	e8 71 da ff ff       	call   102d38 <alloc_pages>
  1052c7:	85 c0                	test   %eax,%eax
  1052c9:	74 24                	je     1052ef <default_check+0x564>
  1052cb:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  1052d2:	00 
  1052d3:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052da:	00 
  1052db:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1052e2:	00 
  1052e3:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052ea:	e8 0a b1 ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  1052ef:	a1 84 af 11 00       	mov    0x11af84,%eax
  1052f4:	85 c0                	test   %eax,%eax
  1052f6:	74 24                	je     10531c <default_check+0x591>
  1052f8:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  1052ff:	00 
  105300:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105307:	00 
  105308:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  10530f:	00 
  105310:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105317:	e8 dd b0 ff ff       	call   1003f9 <__panic>
    nr_free = nr_free_store;
  10531c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10531f:	a3 84 af 11 00       	mov    %eax,0x11af84

    free_list = free_list_store;
  105324:	8b 45 80             	mov    -0x80(%ebp),%eax
  105327:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10532a:	a3 7c af 11 00       	mov    %eax,0x11af7c
  10532f:	89 15 80 af 11 00    	mov    %edx,0x11af80
    free_pages(p0, 5);
  105335:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10533c:	00 
  10533d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105340:	89 04 24             	mov    %eax,(%esp)
  105343:	e8 28 da ff ff       	call   102d70 <free_pages>

    le = &free_list;
  105348:	c7 45 ec 7c af 11 00 	movl   $0x11af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10534f:	eb 5a                	jmp    1053ab <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
  105351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105354:	8b 40 04             	mov    0x4(%eax),%eax
  105357:	8b 00                	mov    (%eax),%eax
  105359:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10535c:	75 0d                	jne    10536b <default_check+0x5e0>
  10535e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105361:	8b 00                	mov    (%eax),%eax
  105363:	8b 40 04             	mov    0x4(%eax),%eax
  105366:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105369:	74 24                	je     10538f <default_check+0x604>
  10536b:	c7 44 24 0c 08 70 10 	movl   $0x107008,0xc(%esp)
  105372:	00 
  105373:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10537a:	00 
  10537b:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  105382:	00 
  105383:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10538a:	e8 6a b0 ff ff       	call   1003f9 <__panic>
        struct Page *p = le2page(le, page_link);
  10538f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105392:	83 e8 0c             	sub    $0xc,%eax
  105395:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  105398:	ff 4d f4             	decl   -0xc(%ebp)
  10539b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10539e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053a1:	8b 40 08             	mov    0x8(%eax),%eax
  1053a4:	29 c2                	sub    %eax,%edx
  1053a6:	89 d0                	mov    %edx,%eax
  1053a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053ae:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1053b1:	8b 45 88             	mov    -0x78(%ebp),%eax
  1053b4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1053b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1053ba:	81 7d ec 7c af 11 00 	cmpl   $0x11af7c,-0x14(%ebp)
  1053c1:	75 8e                	jne    105351 <default_check+0x5c6>
    }
    assert(count == 0);
  1053c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1053c7:	74 24                	je     1053ed <default_check+0x662>
  1053c9:	c7 44 24 0c 35 70 10 	movl   $0x107035,0xc(%esp)
  1053d0:	00 
  1053d1:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1053d8:	00 
  1053d9:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1053e0:	00 
  1053e1:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1053e8:	e8 0c b0 ff ff       	call   1003f9 <__panic>
    assert(total == 0);
  1053ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053f1:	74 24                	je     105417 <default_check+0x68c>
  1053f3:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  1053fa:	00 
  1053fb:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105402:	00 
  105403:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10540a:	00 
  10540b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105412:	e8 e2 af ff ff       	call   1003f9 <__panic>
}
  105417:	90                   	nop
  105418:	c9                   	leave  
  105419:	c3                   	ret    

0010541a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10541a:	55                   	push   %ebp
  10541b:	89 e5                	mov    %esp,%ebp
  10541d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105427:	eb 03                	jmp    10542c <strlen+0x12>
        cnt ++;
  105429:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  10542c:	8b 45 08             	mov    0x8(%ebp),%eax
  10542f:	8d 50 01             	lea    0x1(%eax),%edx
  105432:	89 55 08             	mov    %edx,0x8(%ebp)
  105435:	0f b6 00             	movzbl (%eax),%eax
  105438:	84 c0                	test   %al,%al
  10543a:	75 ed                	jne    105429 <strlen+0xf>
    }
    return cnt;
  10543c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10543f:	c9                   	leave  
  105440:	c3                   	ret    

00105441 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105441:	55                   	push   %ebp
  105442:	89 e5                	mov    %esp,%ebp
  105444:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10544e:	eb 03                	jmp    105453 <strnlen+0x12>
        cnt ++;
  105450:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105456:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105459:	73 10                	jae    10546b <strnlen+0x2a>
  10545b:	8b 45 08             	mov    0x8(%ebp),%eax
  10545e:	8d 50 01             	lea    0x1(%eax),%edx
  105461:	89 55 08             	mov    %edx,0x8(%ebp)
  105464:	0f b6 00             	movzbl (%eax),%eax
  105467:	84 c0                	test   %al,%al
  105469:	75 e5                	jne    105450 <strnlen+0xf>
    }
    return cnt;
  10546b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10546e:	c9                   	leave  
  10546f:	c3                   	ret    

00105470 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105470:	55                   	push   %ebp
  105471:	89 e5                	mov    %esp,%ebp
  105473:	57                   	push   %edi
  105474:	56                   	push   %esi
  105475:	83 ec 20             	sub    $0x20,%esp
  105478:	8b 45 08             	mov    0x8(%ebp),%eax
  10547b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10547e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105481:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105484:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10548a:	89 d1                	mov    %edx,%ecx
  10548c:	89 c2                	mov    %eax,%edx
  10548e:	89 ce                	mov    %ecx,%esi
  105490:	89 d7                	mov    %edx,%edi
  105492:	ac                   	lods   %ds:(%esi),%al
  105493:	aa                   	stos   %al,%es:(%edi)
  105494:	84 c0                	test   %al,%al
  105496:	75 fa                	jne    105492 <strcpy+0x22>
  105498:	89 fa                	mov    %edi,%edx
  10549a:	89 f1                	mov    %esi,%ecx
  10549c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10549f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1054a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1054a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1054a8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1054a9:	83 c4 20             	add    $0x20,%esp
  1054ac:	5e                   	pop    %esi
  1054ad:	5f                   	pop    %edi
  1054ae:	5d                   	pop    %ebp
  1054af:	c3                   	ret    

001054b0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1054b0:	55                   	push   %ebp
  1054b1:	89 e5                	mov    %esp,%ebp
  1054b3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1054b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1054b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1054bc:	eb 1e                	jmp    1054dc <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1054be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c1:	0f b6 10             	movzbl (%eax),%edx
  1054c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054c7:	88 10                	mov    %dl,(%eax)
  1054c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054cc:	0f b6 00             	movzbl (%eax),%eax
  1054cf:	84 c0                	test   %al,%al
  1054d1:	74 03                	je     1054d6 <strncpy+0x26>
            src ++;
  1054d3:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1054d6:	ff 45 fc             	incl   -0x4(%ebp)
  1054d9:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1054dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054e0:	75 dc                	jne    1054be <strncpy+0xe>
    }
    return dst;
  1054e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1054e5:	c9                   	leave  
  1054e6:	c3                   	ret    

001054e7 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1054e7:	55                   	push   %ebp
  1054e8:	89 e5                	mov    %esp,%ebp
  1054ea:	57                   	push   %edi
  1054eb:	56                   	push   %esi
  1054ec:	83 ec 20             	sub    $0x20,%esp
  1054ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1054fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105501:	89 d1                	mov    %edx,%ecx
  105503:	89 c2                	mov    %eax,%edx
  105505:	89 ce                	mov    %ecx,%esi
  105507:	89 d7                	mov    %edx,%edi
  105509:	ac                   	lods   %ds:(%esi),%al
  10550a:	ae                   	scas   %es:(%edi),%al
  10550b:	75 08                	jne    105515 <strcmp+0x2e>
  10550d:	84 c0                	test   %al,%al
  10550f:	75 f8                	jne    105509 <strcmp+0x22>
  105511:	31 c0                	xor    %eax,%eax
  105513:	eb 04                	jmp    105519 <strcmp+0x32>
  105515:	19 c0                	sbb    %eax,%eax
  105517:	0c 01                	or     $0x1,%al
  105519:	89 fa                	mov    %edi,%edx
  10551b:	89 f1                	mov    %esi,%ecx
  10551d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105520:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105523:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105526:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105529:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10552a:	83 c4 20             	add    $0x20,%esp
  10552d:	5e                   	pop    %esi
  10552e:	5f                   	pop    %edi
  10552f:	5d                   	pop    %ebp
  105530:	c3                   	ret    

00105531 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105531:	55                   	push   %ebp
  105532:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105534:	eb 09                	jmp    10553f <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105536:	ff 4d 10             	decl   0x10(%ebp)
  105539:	ff 45 08             	incl   0x8(%ebp)
  10553c:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10553f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105543:	74 1a                	je     10555f <strncmp+0x2e>
  105545:	8b 45 08             	mov    0x8(%ebp),%eax
  105548:	0f b6 00             	movzbl (%eax),%eax
  10554b:	84 c0                	test   %al,%al
  10554d:	74 10                	je     10555f <strncmp+0x2e>
  10554f:	8b 45 08             	mov    0x8(%ebp),%eax
  105552:	0f b6 10             	movzbl (%eax),%edx
  105555:	8b 45 0c             	mov    0xc(%ebp),%eax
  105558:	0f b6 00             	movzbl (%eax),%eax
  10555b:	38 c2                	cmp    %al,%dl
  10555d:	74 d7                	je     105536 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10555f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105563:	74 18                	je     10557d <strncmp+0x4c>
  105565:	8b 45 08             	mov    0x8(%ebp),%eax
  105568:	0f b6 00             	movzbl (%eax),%eax
  10556b:	0f b6 d0             	movzbl %al,%edx
  10556e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105571:	0f b6 00             	movzbl (%eax),%eax
  105574:	0f b6 c0             	movzbl %al,%eax
  105577:	29 c2                	sub    %eax,%edx
  105579:	89 d0                	mov    %edx,%eax
  10557b:	eb 05                	jmp    105582 <strncmp+0x51>
  10557d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105582:	5d                   	pop    %ebp
  105583:	c3                   	ret    

00105584 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105584:	55                   	push   %ebp
  105585:	89 e5                	mov    %esp,%ebp
  105587:	83 ec 04             	sub    $0x4,%esp
  10558a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10558d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105590:	eb 13                	jmp    1055a5 <strchr+0x21>
        if (*s == c) {
  105592:	8b 45 08             	mov    0x8(%ebp),%eax
  105595:	0f b6 00             	movzbl (%eax),%eax
  105598:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10559b:	75 05                	jne    1055a2 <strchr+0x1e>
            return (char *)s;
  10559d:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a0:	eb 12                	jmp    1055b4 <strchr+0x30>
        }
        s ++;
  1055a2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1055a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a8:	0f b6 00             	movzbl (%eax),%eax
  1055ab:	84 c0                	test   %al,%al
  1055ad:	75 e3                	jne    105592 <strchr+0xe>
    }
    return NULL;
  1055af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1055b4:	c9                   	leave  
  1055b5:	c3                   	ret    

001055b6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1055b6:	55                   	push   %ebp
  1055b7:	89 e5                	mov    %esp,%ebp
  1055b9:	83 ec 04             	sub    $0x4,%esp
  1055bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055bf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1055c2:	eb 0e                	jmp    1055d2 <strfind+0x1c>
        if (*s == c) {
  1055c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c7:	0f b6 00             	movzbl (%eax),%eax
  1055ca:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1055cd:	74 0f                	je     1055de <strfind+0x28>
            break;
        }
        s ++;
  1055cf:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1055d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d5:	0f b6 00             	movzbl (%eax),%eax
  1055d8:	84 c0                	test   %al,%al
  1055da:	75 e8                	jne    1055c4 <strfind+0xe>
  1055dc:	eb 01                	jmp    1055df <strfind+0x29>
            break;
  1055de:	90                   	nop
    }
    return (char *)s;
  1055df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1055e2:	c9                   	leave  
  1055e3:	c3                   	ret    

001055e4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1055e4:	55                   	push   %ebp
  1055e5:	89 e5                	mov    %esp,%ebp
  1055e7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1055ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1055f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1055f8:	eb 03                	jmp    1055fd <strtol+0x19>
        s ++;
  1055fa:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1055fd:	8b 45 08             	mov    0x8(%ebp),%eax
  105600:	0f b6 00             	movzbl (%eax),%eax
  105603:	3c 20                	cmp    $0x20,%al
  105605:	74 f3                	je     1055fa <strtol+0x16>
  105607:	8b 45 08             	mov    0x8(%ebp),%eax
  10560a:	0f b6 00             	movzbl (%eax),%eax
  10560d:	3c 09                	cmp    $0x9,%al
  10560f:	74 e9                	je     1055fa <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105611:	8b 45 08             	mov    0x8(%ebp),%eax
  105614:	0f b6 00             	movzbl (%eax),%eax
  105617:	3c 2b                	cmp    $0x2b,%al
  105619:	75 05                	jne    105620 <strtol+0x3c>
        s ++;
  10561b:	ff 45 08             	incl   0x8(%ebp)
  10561e:	eb 14                	jmp    105634 <strtol+0x50>
    }
    else if (*s == '-') {
  105620:	8b 45 08             	mov    0x8(%ebp),%eax
  105623:	0f b6 00             	movzbl (%eax),%eax
  105626:	3c 2d                	cmp    $0x2d,%al
  105628:	75 0a                	jne    105634 <strtol+0x50>
        s ++, neg = 1;
  10562a:	ff 45 08             	incl   0x8(%ebp)
  10562d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105634:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105638:	74 06                	je     105640 <strtol+0x5c>
  10563a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10563e:	75 22                	jne    105662 <strtol+0x7e>
  105640:	8b 45 08             	mov    0x8(%ebp),%eax
  105643:	0f b6 00             	movzbl (%eax),%eax
  105646:	3c 30                	cmp    $0x30,%al
  105648:	75 18                	jne    105662 <strtol+0x7e>
  10564a:	8b 45 08             	mov    0x8(%ebp),%eax
  10564d:	40                   	inc    %eax
  10564e:	0f b6 00             	movzbl (%eax),%eax
  105651:	3c 78                	cmp    $0x78,%al
  105653:	75 0d                	jne    105662 <strtol+0x7e>
        s += 2, base = 16;
  105655:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105659:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105660:	eb 29                	jmp    10568b <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105662:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105666:	75 16                	jne    10567e <strtol+0x9a>
  105668:	8b 45 08             	mov    0x8(%ebp),%eax
  10566b:	0f b6 00             	movzbl (%eax),%eax
  10566e:	3c 30                	cmp    $0x30,%al
  105670:	75 0c                	jne    10567e <strtol+0x9a>
        s ++, base = 8;
  105672:	ff 45 08             	incl   0x8(%ebp)
  105675:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10567c:	eb 0d                	jmp    10568b <strtol+0xa7>
    }
    else if (base == 0) {
  10567e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105682:	75 07                	jne    10568b <strtol+0xa7>
        base = 10;
  105684:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10568b:	8b 45 08             	mov    0x8(%ebp),%eax
  10568e:	0f b6 00             	movzbl (%eax),%eax
  105691:	3c 2f                	cmp    $0x2f,%al
  105693:	7e 1b                	jle    1056b0 <strtol+0xcc>
  105695:	8b 45 08             	mov    0x8(%ebp),%eax
  105698:	0f b6 00             	movzbl (%eax),%eax
  10569b:	3c 39                	cmp    $0x39,%al
  10569d:	7f 11                	jg     1056b0 <strtol+0xcc>
            dig = *s - '0';
  10569f:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a2:	0f b6 00             	movzbl (%eax),%eax
  1056a5:	0f be c0             	movsbl %al,%eax
  1056a8:	83 e8 30             	sub    $0x30,%eax
  1056ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056ae:	eb 48                	jmp    1056f8 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1056b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b3:	0f b6 00             	movzbl (%eax),%eax
  1056b6:	3c 60                	cmp    $0x60,%al
  1056b8:	7e 1b                	jle    1056d5 <strtol+0xf1>
  1056ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1056bd:	0f b6 00             	movzbl (%eax),%eax
  1056c0:	3c 7a                	cmp    $0x7a,%al
  1056c2:	7f 11                	jg     1056d5 <strtol+0xf1>
            dig = *s - 'a' + 10;
  1056c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c7:	0f b6 00             	movzbl (%eax),%eax
  1056ca:	0f be c0             	movsbl %al,%eax
  1056cd:	83 e8 57             	sub    $0x57,%eax
  1056d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056d3:	eb 23                	jmp    1056f8 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1056d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d8:	0f b6 00             	movzbl (%eax),%eax
  1056db:	3c 40                	cmp    $0x40,%al
  1056dd:	7e 3b                	jle    10571a <strtol+0x136>
  1056df:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e2:	0f b6 00             	movzbl (%eax),%eax
  1056e5:	3c 5a                	cmp    $0x5a,%al
  1056e7:	7f 31                	jg     10571a <strtol+0x136>
            dig = *s - 'A' + 10;
  1056e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ec:	0f b6 00             	movzbl (%eax),%eax
  1056ef:	0f be c0             	movsbl %al,%eax
  1056f2:	83 e8 37             	sub    $0x37,%eax
  1056f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1056f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  1056fe:	7d 19                	jge    105719 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105700:	ff 45 08             	incl   0x8(%ebp)
  105703:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105706:	0f af 45 10          	imul   0x10(%ebp),%eax
  10570a:	89 c2                	mov    %eax,%edx
  10570c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10570f:	01 d0                	add    %edx,%eax
  105711:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105714:	e9 72 ff ff ff       	jmp    10568b <strtol+0xa7>
            break;
  105719:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10571a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10571e:	74 08                	je     105728 <strtol+0x144>
        *endptr = (char *) s;
  105720:	8b 45 0c             	mov    0xc(%ebp),%eax
  105723:	8b 55 08             	mov    0x8(%ebp),%edx
  105726:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105728:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10572c:	74 07                	je     105735 <strtol+0x151>
  10572e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105731:	f7 d8                	neg    %eax
  105733:	eb 03                	jmp    105738 <strtol+0x154>
  105735:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105738:	c9                   	leave  
  105739:	c3                   	ret    

0010573a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10573a:	55                   	push   %ebp
  10573b:	89 e5                	mov    %esp,%ebp
  10573d:	57                   	push   %edi
  10573e:	83 ec 24             	sub    $0x24,%esp
  105741:	8b 45 0c             	mov    0xc(%ebp),%eax
  105744:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105747:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10574b:	8b 55 08             	mov    0x8(%ebp),%edx
  10574e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105751:	88 45 f7             	mov    %al,-0x9(%ebp)
  105754:	8b 45 10             	mov    0x10(%ebp),%eax
  105757:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10575a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10575d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105761:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105764:	89 d7                	mov    %edx,%edi
  105766:	f3 aa                	rep stos %al,%es:(%edi)
  105768:	89 fa                	mov    %edi,%edx
  10576a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10576d:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105770:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105773:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105774:	83 c4 24             	add    $0x24,%esp
  105777:	5f                   	pop    %edi
  105778:	5d                   	pop    %ebp
  105779:	c3                   	ret    

0010577a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10577a:	55                   	push   %ebp
  10577b:	89 e5                	mov    %esp,%ebp
  10577d:	57                   	push   %edi
  10577e:	56                   	push   %esi
  10577f:	53                   	push   %ebx
  105780:	83 ec 30             	sub    $0x30,%esp
  105783:	8b 45 08             	mov    0x8(%ebp),%eax
  105786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10578f:	8b 45 10             	mov    0x10(%ebp),%eax
  105792:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105798:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10579b:	73 42                	jae    1057df <memmove+0x65>
  10579d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1057a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1057a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1057af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057b2:	c1 e8 02             	shr    $0x2,%eax
  1057b5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1057b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057bd:	89 d7                	mov    %edx,%edi
  1057bf:	89 c6                	mov    %eax,%esi
  1057c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1057c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1057c6:	83 e1 03             	and    $0x3,%ecx
  1057c9:	74 02                	je     1057cd <memmove+0x53>
  1057cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057cd:	89 f0                	mov    %esi,%eax
  1057cf:	89 fa                	mov    %edi,%edx
  1057d1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1057d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1057d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1057da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1057dd:	eb 36                	jmp    105815 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1057df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1057e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057e8:	01 c2                	add    %eax,%edx
  1057ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057ed:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1057f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057f3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1057f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057f9:	89 c1                	mov    %eax,%ecx
  1057fb:	89 d8                	mov    %ebx,%eax
  1057fd:	89 d6                	mov    %edx,%esi
  1057ff:	89 c7                	mov    %eax,%edi
  105801:	fd                   	std    
  105802:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105804:	fc                   	cld    
  105805:	89 f8                	mov    %edi,%eax
  105807:	89 f2                	mov    %esi,%edx
  105809:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10580c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10580f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105812:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105815:	83 c4 30             	add    $0x30,%esp
  105818:	5b                   	pop    %ebx
  105819:	5e                   	pop    %esi
  10581a:	5f                   	pop    %edi
  10581b:	5d                   	pop    %ebp
  10581c:	c3                   	ret    

0010581d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10581d:	55                   	push   %ebp
  10581e:	89 e5                	mov    %esp,%ebp
  105820:	57                   	push   %edi
  105821:	56                   	push   %esi
  105822:	83 ec 20             	sub    $0x20,%esp
  105825:	8b 45 08             	mov    0x8(%ebp),%eax
  105828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10582b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105831:	8b 45 10             	mov    0x10(%ebp),%eax
  105834:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10583a:	c1 e8 02             	shr    $0x2,%eax
  10583d:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10583f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105845:	89 d7                	mov    %edx,%edi
  105847:	89 c6                	mov    %eax,%esi
  105849:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10584b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10584e:	83 e1 03             	and    $0x3,%ecx
  105851:	74 02                	je     105855 <memcpy+0x38>
  105853:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105855:	89 f0                	mov    %esi,%eax
  105857:	89 fa                	mov    %edi,%edx
  105859:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10585c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10585f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105865:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105866:	83 c4 20             	add    $0x20,%esp
  105869:	5e                   	pop    %esi
  10586a:	5f                   	pop    %edi
  10586b:	5d                   	pop    %ebp
  10586c:	c3                   	ret    

0010586d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10586d:	55                   	push   %ebp
  10586e:	89 e5                	mov    %esp,%ebp
  105870:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105873:	8b 45 08             	mov    0x8(%ebp),%eax
  105876:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105879:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10587f:	eb 2e                	jmp    1058af <memcmp+0x42>
        if (*s1 != *s2) {
  105881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105884:	0f b6 10             	movzbl (%eax),%edx
  105887:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10588a:	0f b6 00             	movzbl (%eax),%eax
  10588d:	38 c2                	cmp    %al,%dl
  10588f:	74 18                	je     1058a9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105894:	0f b6 00             	movzbl (%eax),%eax
  105897:	0f b6 d0             	movzbl %al,%edx
  10589a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10589d:	0f b6 00             	movzbl (%eax),%eax
  1058a0:	0f b6 c0             	movzbl %al,%eax
  1058a3:	29 c2                	sub    %eax,%edx
  1058a5:	89 d0                	mov    %edx,%eax
  1058a7:	eb 18                	jmp    1058c1 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1058a9:	ff 45 fc             	incl   -0x4(%ebp)
  1058ac:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1058af:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058b5:	89 55 10             	mov    %edx,0x10(%ebp)
  1058b8:	85 c0                	test   %eax,%eax
  1058ba:	75 c5                	jne    105881 <memcmp+0x14>
    }
    return 0;
  1058bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1058c1:	c9                   	leave  
  1058c2:	c3                   	ret    

001058c3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1058c3:	55                   	push   %ebp
  1058c4:	89 e5                	mov    %esp,%ebp
  1058c6:	83 ec 58             	sub    $0x58,%esp
  1058c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1058cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1058cf:	8b 45 14             	mov    0x14(%ebp),%eax
  1058d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1058d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1058db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058de:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1058e1:	8b 45 18             	mov    0x18(%ebp),%eax
  1058e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1058ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1058f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058fd:	74 1c                	je     10591b <printnum+0x58>
  1058ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105902:	ba 00 00 00 00       	mov    $0x0,%edx
  105907:	f7 75 e4             	divl   -0x1c(%ebp)
  10590a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105910:	ba 00 00 00 00       	mov    $0x0,%edx
  105915:	f7 75 e4             	divl   -0x1c(%ebp)
  105918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10591b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10591e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105921:	f7 75 e4             	divl   -0x1c(%ebp)
  105924:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10592a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10592d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105930:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105933:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105939:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10593c:	8b 45 18             	mov    0x18(%ebp),%eax
  10593f:	ba 00 00 00 00       	mov    $0x0,%edx
  105944:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105947:	72 56                	jb     10599f <printnum+0xdc>
  105949:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10594c:	77 05                	ja     105953 <printnum+0x90>
  10594e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105951:	72 4c                	jb     10599f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105953:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105956:	8d 50 ff             	lea    -0x1(%eax),%edx
  105959:	8b 45 20             	mov    0x20(%ebp),%eax
  10595c:	89 44 24 18          	mov    %eax,0x18(%esp)
  105960:	89 54 24 14          	mov    %edx,0x14(%esp)
  105964:	8b 45 18             	mov    0x18(%ebp),%eax
  105967:	89 44 24 10          	mov    %eax,0x10(%esp)
  10596b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10596e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105971:	89 44 24 08          	mov    %eax,0x8(%esp)
  105975:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105979:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105980:	8b 45 08             	mov    0x8(%ebp),%eax
  105983:	89 04 24             	mov    %eax,(%esp)
  105986:	e8 38 ff ff ff       	call   1058c3 <printnum>
  10598b:	eb 1b                	jmp    1059a8 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10598d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105990:	89 44 24 04          	mov    %eax,0x4(%esp)
  105994:	8b 45 20             	mov    0x20(%ebp),%eax
  105997:	89 04 24             	mov    %eax,(%esp)
  10599a:	8b 45 08             	mov    0x8(%ebp),%eax
  10599d:	ff d0                	call   *%eax
        while (-- width > 0)
  10599f:	ff 4d 1c             	decl   0x1c(%ebp)
  1059a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1059a6:	7f e5                	jg     10598d <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1059a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1059ab:	05 fc 70 10 00       	add    $0x1070fc,%eax
  1059b0:	0f b6 00             	movzbl (%eax),%eax
  1059b3:	0f be c0             	movsbl %al,%eax
  1059b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059bd:	89 04 24             	mov    %eax,(%esp)
  1059c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c3:	ff d0                	call   *%eax
}
  1059c5:	90                   	nop
  1059c6:	c9                   	leave  
  1059c7:	c3                   	ret    

001059c8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1059c8:	55                   	push   %ebp
  1059c9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1059cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1059cf:	7e 14                	jle    1059e5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1059d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d4:	8b 00                	mov    (%eax),%eax
  1059d6:	8d 48 08             	lea    0x8(%eax),%ecx
  1059d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1059dc:	89 0a                	mov    %ecx,(%edx)
  1059de:	8b 50 04             	mov    0x4(%eax),%edx
  1059e1:	8b 00                	mov    (%eax),%eax
  1059e3:	eb 30                	jmp    105a15 <getuint+0x4d>
    }
    else if (lflag) {
  1059e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059e9:	74 16                	je     105a01 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1059eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ee:	8b 00                	mov    (%eax),%eax
  1059f0:	8d 48 04             	lea    0x4(%eax),%ecx
  1059f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1059f6:	89 0a                	mov    %ecx,(%edx)
  1059f8:	8b 00                	mov    (%eax),%eax
  1059fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1059ff:	eb 14                	jmp    105a15 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105a01:	8b 45 08             	mov    0x8(%ebp),%eax
  105a04:	8b 00                	mov    (%eax),%eax
  105a06:	8d 48 04             	lea    0x4(%eax),%ecx
  105a09:	8b 55 08             	mov    0x8(%ebp),%edx
  105a0c:	89 0a                	mov    %ecx,(%edx)
  105a0e:	8b 00                	mov    (%eax),%eax
  105a10:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105a15:	5d                   	pop    %ebp
  105a16:	c3                   	ret    

00105a17 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105a17:	55                   	push   %ebp
  105a18:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105a1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105a1e:	7e 14                	jle    105a34 <getint+0x1d>
        return va_arg(*ap, long long);
  105a20:	8b 45 08             	mov    0x8(%ebp),%eax
  105a23:	8b 00                	mov    (%eax),%eax
  105a25:	8d 48 08             	lea    0x8(%eax),%ecx
  105a28:	8b 55 08             	mov    0x8(%ebp),%edx
  105a2b:	89 0a                	mov    %ecx,(%edx)
  105a2d:	8b 50 04             	mov    0x4(%eax),%edx
  105a30:	8b 00                	mov    (%eax),%eax
  105a32:	eb 28                	jmp    105a5c <getint+0x45>
    }
    else if (lflag) {
  105a34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a38:	74 12                	je     105a4c <getint+0x35>
        return va_arg(*ap, long);
  105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3d:	8b 00                	mov    (%eax),%eax
  105a3f:	8d 48 04             	lea    0x4(%eax),%ecx
  105a42:	8b 55 08             	mov    0x8(%ebp),%edx
  105a45:	89 0a                	mov    %ecx,(%edx)
  105a47:	8b 00                	mov    (%eax),%eax
  105a49:	99                   	cltd   
  105a4a:	eb 10                	jmp    105a5c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4f:	8b 00                	mov    (%eax),%eax
  105a51:	8d 48 04             	lea    0x4(%eax),%ecx
  105a54:	8b 55 08             	mov    0x8(%ebp),%edx
  105a57:	89 0a                	mov    %ecx,(%edx)
  105a59:	8b 00                	mov    (%eax),%eax
  105a5b:	99                   	cltd   
    }
}
  105a5c:	5d                   	pop    %ebp
  105a5d:	c3                   	ret    

00105a5e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105a5e:	55                   	push   %ebp
  105a5f:	89 e5                	mov    %esp,%ebp
  105a61:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105a64:	8d 45 14             	lea    0x14(%ebp),%eax
  105a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a71:	8b 45 10             	mov    0x10(%ebp),%eax
  105a74:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a82:	89 04 24             	mov    %eax,(%esp)
  105a85:	e8 03 00 00 00       	call   105a8d <vprintfmt>
    va_end(ap);
}
  105a8a:	90                   	nop
  105a8b:	c9                   	leave  
  105a8c:	c3                   	ret    

00105a8d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105a8d:	55                   	push   %ebp
  105a8e:	89 e5                	mov    %esp,%ebp
  105a90:	56                   	push   %esi
  105a91:	53                   	push   %ebx
  105a92:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a95:	eb 17                	jmp    105aae <vprintfmt+0x21>
            if (ch == '\0') {
  105a97:	85 db                	test   %ebx,%ebx
  105a99:	0f 84 bf 03 00 00    	je     105e5e <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa6:	89 1c 24             	mov    %ebx,(%esp)
  105aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  105aac:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105aae:	8b 45 10             	mov    0x10(%ebp),%eax
  105ab1:	8d 50 01             	lea    0x1(%eax),%edx
  105ab4:	89 55 10             	mov    %edx,0x10(%ebp)
  105ab7:	0f b6 00             	movzbl (%eax),%eax
  105aba:	0f b6 d8             	movzbl %al,%ebx
  105abd:	83 fb 25             	cmp    $0x25,%ebx
  105ac0:	75 d5                	jne    105a97 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105ac2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105ac6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105ad3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105ada:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105add:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  105ae3:	8d 50 01             	lea    0x1(%eax),%edx
  105ae6:	89 55 10             	mov    %edx,0x10(%ebp)
  105ae9:	0f b6 00             	movzbl (%eax),%eax
  105aec:	0f b6 d8             	movzbl %al,%ebx
  105aef:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105af2:	83 f8 55             	cmp    $0x55,%eax
  105af5:	0f 87 37 03 00 00    	ja     105e32 <vprintfmt+0x3a5>
  105afb:	8b 04 85 20 71 10 00 	mov    0x107120(,%eax,4),%eax
  105b02:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105b04:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105b08:	eb d6                	jmp    105ae0 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105b0a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105b0e:	eb d0                	jmp    105ae0 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105b10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105b17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b1a:	89 d0                	mov    %edx,%eax
  105b1c:	c1 e0 02             	shl    $0x2,%eax
  105b1f:	01 d0                	add    %edx,%eax
  105b21:	01 c0                	add    %eax,%eax
  105b23:	01 d8                	add    %ebx,%eax
  105b25:	83 e8 30             	sub    $0x30,%eax
  105b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105b2b:	8b 45 10             	mov    0x10(%ebp),%eax
  105b2e:	0f b6 00             	movzbl (%eax),%eax
  105b31:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105b34:	83 fb 2f             	cmp    $0x2f,%ebx
  105b37:	7e 38                	jle    105b71 <vprintfmt+0xe4>
  105b39:	83 fb 39             	cmp    $0x39,%ebx
  105b3c:	7f 33                	jg     105b71 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105b3e:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105b41:	eb d4                	jmp    105b17 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105b43:	8b 45 14             	mov    0x14(%ebp),%eax
  105b46:	8d 50 04             	lea    0x4(%eax),%edx
  105b49:	89 55 14             	mov    %edx,0x14(%ebp)
  105b4c:	8b 00                	mov    (%eax),%eax
  105b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105b51:	eb 1f                	jmp    105b72 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105b53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b57:	79 87                	jns    105ae0 <vprintfmt+0x53>
                width = 0;
  105b59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105b60:	e9 7b ff ff ff       	jmp    105ae0 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105b65:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105b6c:	e9 6f ff ff ff       	jmp    105ae0 <vprintfmt+0x53>
            goto process_precision;
  105b71:	90                   	nop

        process_precision:
            if (width < 0)
  105b72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b76:	0f 89 64 ff ff ff    	jns    105ae0 <vprintfmt+0x53>
                width = precision, precision = -1;
  105b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105b89:	e9 52 ff ff ff       	jmp    105ae0 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105b8e:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105b91:	e9 4a ff ff ff       	jmp    105ae0 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105b96:	8b 45 14             	mov    0x14(%ebp),%eax
  105b99:	8d 50 04             	lea    0x4(%eax),%edx
  105b9c:	89 55 14             	mov    %edx,0x14(%ebp)
  105b9f:	8b 00                	mov    (%eax),%eax
  105ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ba4:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ba8:	89 04 24             	mov    %eax,(%esp)
  105bab:	8b 45 08             	mov    0x8(%ebp),%eax
  105bae:	ff d0                	call   *%eax
            break;
  105bb0:	e9 a4 02 00 00       	jmp    105e59 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  105bb8:	8d 50 04             	lea    0x4(%eax),%edx
  105bbb:	89 55 14             	mov    %edx,0x14(%ebp)
  105bbe:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105bc0:	85 db                	test   %ebx,%ebx
  105bc2:	79 02                	jns    105bc6 <vprintfmt+0x139>
                err = -err;
  105bc4:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105bc6:	83 fb 06             	cmp    $0x6,%ebx
  105bc9:	7f 0b                	jg     105bd6 <vprintfmt+0x149>
  105bcb:	8b 34 9d e0 70 10 00 	mov    0x1070e0(,%ebx,4),%esi
  105bd2:	85 f6                	test   %esi,%esi
  105bd4:	75 23                	jne    105bf9 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105bd6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105bda:	c7 44 24 08 0d 71 10 	movl   $0x10710d,0x8(%esp)
  105be1:	00 
  105be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bec:	89 04 24             	mov    %eax,(%esp)
  105bef:	e8 6a fe ff ff       	call   105a5e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105bf4:	e9 60 02 00 00       	jmp    105e59 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105bf9:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105bfd:	c7 44 24 08 16 71 10 	movl   $0x107116,0x8(%esp)
  105c04:	00 
  105c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0f:	89 04 24             	mov    %eax,(%esp)
  105c12:	e8 47 fe ff ff       	call   105a5e <printfmt>
            break;
  105c17:	e9 3d 02 00 00       	jmp    105e59 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  105c1f:	8d 50 04             	lea    0x4(%eax),%edx
  105c22:	89 55 14             	mov    %edx,0x14(%ebp)
  105c25:	8b 30                	mov    (%eax),%esi
  105c27:	85 f6                	test   %esi,%esi
  105c29:	75 05                	jne    105c30 <vprintfmt+0x1a3>
                p = "(null)";
  105c2b:	be 19 71 10 00       	mov    $0x107119,%esi
            }
            if (width > 0 && padc != '-') {
  105c30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c34:	7e 76                	jle    105cac <vprintfmt+0x21f>
  105c36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105c3a:	74 70                	je     105cac <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c43:	89 34 24             	mov    %esi,(%esp)
  105c46:	e8 f6 f7 ff ff       	call   105441 <strnlen>
  105c4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c4e:	29 c2                	sub    %eax,%edx
  105c50:	89 d0                	mov    %edx,%eax
  105c52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c55:	eb 16                	jmp    105c6d <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105c57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c62:	89 04 24             	mov    %eax,(%esp)
  105c65:	8b 45 08             	mov    0x8(%ebp),%eax
  105c68:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c6a:	ff 4d e8             	decl   -0x18(%ebp)
  105c6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c71:	7f e4                	jg     105c57 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105c73:	eb 37                	jmp    105cac <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  105c75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105c79:	74 1f                	je     105c9a <vprintfmt+0x20d>
  105c7b:	83 fb 1f             	cmp    $0x1f,%ebx
  105c7e:	7e 05                	jle    105c85 <vprintfmt+0x1f8>
  105c80:	83 fb 7e             	cmp    $0x7e,%ebx
  105c83:	7e 15                	jle    105c9a <vprintfmt+0x20d>
                    putch('?', putdat);
  105c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105c93:	8b 45 08             	mov    0x8(%ebp),%eax
  105c96:	ff d0                	call   *%eax
  105c98:	eb 0f                	jmp    105ca9 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ca1:	89 1c 24             	mov    %ebx,(%esp)
  105ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca7:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ca9:	ff 4d e8             	decl   -0x18(%ebp)
  105cac:	89 f0                	mov    %esi,%eax
  105cae:	8d 70 01             	lea    0x1(%eax),%esi
  105cb1:	0f b6 00             	movzbl (%eax),%eax
  105cb4:	0f be d8             	movsbl %al,%ebx
  105cb7:	85 db                	test   %ebx,%ebx
  105cb9:	74 27                	je     105ce2 <vprintfmt+0x255>
  105cbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105cbf:	78 b4                	js     105c75 <vprintfmt+0x1e8>
  105cc1:	ff 4d e4             	decl   -0x1c(%ebp)
  105cc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105cc8:	79 ab                	jns    105c75 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105cca:	eb 16                	jmp    105ce2 <vprintfmt+0x255>
                putch(' ', putdat);
  105ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cd3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105cda:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdd:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105cdf:	ff 4d e8             	decl   -0x18(%ebp)
  105ce2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ce6:	7f e4                	jg     105ccc <vprintfmt+0x23f>
            }
            break;
  105ce8:	e9 6c 01 00 00       	jmp    105e59 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cf4:	8d 45 14             	lea    0x14(%ebp),%eax
  105cf7:	89 04 24             	mov    %eax,(%esp)
  105cfa:	e8 18 fd ff ff       	call   105a17 <getint>
  105cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d0b:	85 d2                	test   %edx,%edx
  105d0d:	79 26                	jns    105d35 <vprintfmt+0x2a8>
                putch('-', putdat);
  105d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d16:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d20:	ff d0                	call   *%eax
                num = -(long long)num;
  105d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d28:	f7 d8                	neg    %eax
  105d2a:	83 d2 00             	adc    $0x0,%edx
  105d2d:	f7 da                	neg    %edx
  105d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d32:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105d35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d3c:	e9 a8 00 00 00       	jmp    105de9 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d48:	8d 45 14             	lea    0x14(%ebp),%eax
  105d4b:	89 04 24             	mov    %eax,(%esp)
  105d4e:	e8 75 fc ff ff       	call   1059c8 <getuint>
  105d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d56:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105d59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d60:	e9 84 00 00 00       	jmp    105de9 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d6c:	8d 45 14             	lea    0x14(%ebp),%eax
  105d6f:	89 04 24             	mov    %eax,(%esp)
  105d72:	e8 51 fc ff ff       	call   1059c8 <getuint>
  105d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105d7d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105d84:	eb 63                	jmp    105de9 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d8d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105d94:	8b 45 08             	mov    0x8(%ebp),%eax
  105d97:	ff d0                	call   *%eax
            putch('x', putdat);
  105d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105da0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105da7:	8b 45 08             	mov    0x8(%ebp),%eax
  105daa:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105dac:	8b 45 14             	mov    0x14(%ebp),%eax
  105daf:	8d 50 04             	lea    0x4(%eax),%edx
  105db2:	89 55 14             	mov    %edx,0x14(%ebp)
  105db5:	8b 00                	mov    (%eax),%eax
  105db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105dc1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105dc8:	eb 1f                	jmp    105de9 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dd1:	8d 45 14             	lea    0x14(%ebp),%eax
  105dd4:	89 04 24             	mov    %eax,(%esp)
  105dd7:	e8 ec fb ff ff       	call   1059c8 <getuint>
  105ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ddf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105de2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105de9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105df0:	89 54 24 18          	mov    %edx,0x18(%esp)
  105df4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105df7:	89 54 24 14          	mov    %edx,0x14(%esp)
  105dfb:	89 44 24 10          	mov    %eax,0x10(%esp)
  105dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e05:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e09:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e14:	8b 45 08             	mov    0x8(%ebp),%eax
  105e17:	89 04 24             	mov    %eax,(%esp)
  105e1a:	e8 a4 fa ff ff       	call   1058c3 <printnum>
            break;
  105e1f:	eb 38                	jmp    105e59 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e28:	89 1c 24             	mov    %ebx,(%esp)
  105e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2e:	ff d0                	call   *%eax
            break;
  105e30:	eb 27                	jmp    105e59 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e35:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e39:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105e40:	8b 45 08             	mov    0x8(%ebp),%eax
  105e43:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105e45:	ff 4d 10             	decl   0x10(%ebp)
  105e48:	eb 03                	jmp    105e4d <vprintfmt+0x3c0>
  105e4a:	ff 4d 10             	decl   0x10(%ebp)
  105e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  105e50:	48                   	dec    %eax
  105e51:	0f b6 00             	movzbl (%eax),%eax
  105e54:	3c 25                	cmp    $0x25,%al
  105e56:	75 f2                	jne    105e4a <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105e58:	90                   	nop
    while (1) {
  105e59:	e9 37 fc ff ff       	jmp    105a95 <vprintfmt+0x8>
                return;
  105e5e:	90                   	nop
        }
    }
}
  105e5f:	83 c4 40             	add    $0x40,%esp
  105e62:	5b                   	pop    %ebx
  105e63:	5e                   	pop    %esi
  105e64:	5d                   	pop    %ebp
  105e65:	c3                   	ret    

00105e66 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105e66:	55                   	push   %ebp
  105e67:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e6c:	8b 40 08             	mov    0x8(%eax),%eax
  105e6f:	8d 50 01             	lea    0x1(%eax),%edx
  105e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e75:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e7b:	8b 10                	mov    (%eax),%edx
  105e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e80:	8b 40 04             	mov    0x4(%eax),%eax
  105e83:	39 c2                	cmp    %eax,%edx
  105e85:	73 12                	jae    105e99 <sprintputch+0x33>
        *b->buf ++ = ch;
  105e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e8a:	8b 00                	mov    (%eax),%eax
  105e8c:	8d 48 01             	lea    0x1(%eax),%ecx
  105e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e92:	89 0a                	mov    %ecx,(%edx)
  105e94:	8b 55 08             	mov    0x8(%ebp),%edx
  105e97:	88 10                	mov    %dl,(%eax)
    }
}
  105e99:	90                   	nop
  105e9a:	5d                   	pop    %ebp
  105e9b:	c3                   	ret    

00105e9c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105e9c:	55                   	push   %ebp
  105e9d:	89 e5                	mov    %esp,%ebp
  105e9f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105ea2:	8d 45 14             	lea    0x14(%ebp),%eax
  105ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  105eb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  105eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec0:	89 04 24             	mov    %eax,(%esp)
  105ec3:	e8 08 00 00 00       	call   105ed0 <vsnprintf>
  105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ece:	c9                   	leave  
  105ecf:	c3                   	ret    

00105ed0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ed0:	55                   	push   %ebp
  105ed1:	89 e5                	mov    %esp,%ebp
  105ed3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105edf:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee5:	01 d0                	add    %edx,%eax
  105ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105ef5:	74 0a                	je     105f01 <vsnprintf+0x31>
  105ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105efd:	39 c2                	cmp    %eax,%edx
  105eff:	76 07                	jbe    105f08 <vsnprintf+0x38>
        return -E_INVAL;
  105f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105f06:	eb 2a                	jmp    105f32 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105f08:	8b 45 14             	mov    0x14(%ebp),%eax
  105f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  105f12:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f1d:	c7 04 24 66 5e 10 00 	movl   $0x105e66,(%esp)
  105f24:	e8 64 fb ff ff       	call   105a8d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f2c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105f32:	c9                   	leave  
  105f33:	c3                   	ret    
