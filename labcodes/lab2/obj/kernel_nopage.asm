
bin/kernel_nopageï¼š     æ–‡ä»¶æ ¼å¼ elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 b0 11 40       	mov    $0x4011b000,%eax
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
  100020:	a3 00 b0 11 00       	mov    %eax,0x11b000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 a0 11 00       	mov    $0x11a000,%esp
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
  10003c:	ba c0 49 2a 00       	mov    $0x2a49c0,%edx
  100041:	b8 36 aa 11 00       	mov    $0x11aa36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 aa 11 00 	movl   $0x11aa36,(%esp)
  10005d:	e8 c5 66 00 00       	call   106727 <memset>

    cons_init();                // init the console
  100062:	e8 90 15 00 00       	call   1015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 40 6f 10 00 	movl   $0x106f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 5c 6f 10 00 	movl   $0x106f5c,(%esp)
  10007c:	e8 21 02 00 00       	call   1002a2 <cprintf>

    print_kerninfo();
  100081:	e8 c2 08 00 00       	call   100948 <print_kerninfo>

    grade_backtrace();
  100086:	e8 8e 00 00 00       	call   100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 ad 32 00 00       	call   10333d <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 c7 16 00 00       	call   10175c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 4c 18 00 00       	call   1018e6 <idt_init>

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
  10015a:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 61 6f 10 00 	movl   $0x106f61,(%esp)
  10016e:	e8 2f 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 6f 6f 10 00 	movl   $0x106f6f,(%esp)
  10018d:	e8 10 01 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 7d 6f 10 00 	movl   $0x106f7d,(%esp)
  1001ac:	e8 f1 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 8b 6f 10 00 	movl   $0x106f8b,(%esp)
  1001cb:	e8 d2 00 00 00       	call   1002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 99 6f 10 00 	movl   $0x106f99,(%esp)
  1001ea:	e8 b3 00 00 00       	call   1002a2 <cprintf>
    round ++;
  1001ef:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 d0 11 00       	mov    %eax,0x11d000
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
  10021f:	c7 04 24 a8 6f 10 00 	movl   $0x106fa8,(%esp)
  100226:	e8 77 00 00 00       	call   1002a2 <cprintf>
    lab1_switch_to_user();
  10022b:	e8 cd ff ff ff       	call   1001fd <lab1_switch_to_user>
    lab1_print_cur_status();
  100230:	e8 0a ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100235:	c7 04 24 c8 6f 10 00 	movl   $0x106fc8,(%esp)
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
  100298:	e8 dd 67 00 00       	call   106a7a <vprintfmt>
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
  100357:	c7 04 24 e7 6f 10 00 	movl   $0x106fe7,(%esp)
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
  1003a5:	88 90 20 d0 11 00    	mov    %dl,0x11d020(%eax)
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
  1003e3:	05 20 d0 11 00       	add    $0x11d020,%eax
  1003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003eb:	b8 20 d0 11 00       	mov    $0x11d020,%eax
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
  1003ff:	a1 20 d4 11 00       	mov    0x11d420,%eax
  100404:	85 c0                	test   %eax,%eax
  100406:	75 5b                	jne    100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100408:	c7 05 20 d4 11 00 01 	movl   $0x1,0x11d420
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
  100426:	c7 04 24 ea 6f 10 00 	movl   $0x106fea,(%esp)
  10042d:	e8 70 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100435:	89 44 24 04          	mov    %eax,0x4(%esp)
  100439:	8b 45 10             	mov    0x10(%ebp),%eax
  10043c:	89 04 24             	mov    %eax,(%esp)
  10043f:	e8 2b fe ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  100444:	c7 04 24 06 70 10 00 	movl   $0x107006,(%esp)
  10044b:	e8 52 fe ff ff       	call   1002a2 <cprintf>
    
    cprintf("stack trackback:\n");
  100450:	c7 04 24 08 70 10 00 	movl   $0x107008,(%esp)
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
  100491:	c7 04 24 1a 70 10 00 	movl   $0x10701a,(%esp)
  100498:	e8 05 fe ff ff       	call   1002a2 <cprintf>
    vcprintf(fmt, ap);
  10049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a7:	89 04 24             	mov    %eax,(%esp)
  1004aa:	e8 c0 fd ff ff       	call   10026f <vcprintf>
    cprintf("\n");
  1004af:	c7 04 24 06 70 10 00 	movl   $0x107006,(%esp)
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
  1004c1:	a1 20 d4 11 00       	mov    0x11d420,%eax
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
  10061f:	c7 00 38 70 10 00    	movl   $0x107038,(%eax)
    info->eip_line = 0;
  100625:	8b 45 0c             	mov    0xc(%ebp),%eax
  100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100632:	c7 40 08 38 70 10 00 	movl   $0x107038,0x8(%eax)
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
  100656:	c7 45 f4 34 84 10 00 	movl   $0x108434,-0xc(%ebp)
    stab_end = __STAB_END__;
  10065d:	c7 45 f0 60 48 11 00 	movl   $0x114860,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100664:	c7 45 ec 61 48 11 00 	movl   $0x114861,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10066b:	c7 45 e8 41 76 11 00 	movl   $0x117641,-0x18(%ebp)

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
  1007c6:	e8 d8 5d 00 00       	call   1065a3 <strfind>
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
  10094e:	c7 04 24 42 70 10 00 	movl   $0x107042,(%esp)
  100955:	e8 48 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10095a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100961:	00 
  100962:	c7 04 24 5b 70 10 00 	movl   $0x10705b,(%esp)
  100969:	e8 34 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10096e:	c7 44 24 04 21 6f 10 	movl   $0x106f21,0x4(%esp)
  100975:	00 
  100976:	c7 04 24 73 70 10 00 	movl   $0x107073,(%esp)
  10097d:	e8 20 f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100982:	c7 44 24 04 36 aa 11 	movl   $0x11aa36,0x4(%esp)
  100989:	00 
  10098a:	c7 04 24 8b 70 10 00 	movl   $0x10708b,(%esp)
  100991:	e8 0c f9 ff ff       	call   1002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100996:	c7 44 24 04 c0 49 2a 	movl   $0x2a49c0,0x4(%esp)
  10099d:	00 
  10099e:	c7 04 24 a3 70 10 00 	movl   $0x1070a3,(%esp)
  1009a5:	e8 f8 f8 ff ff       	call   1002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009aa:	b8 c0 49 2a 00       	mov    $0x2a49c0,%eax
  1009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009ba:	29 c2                	sub    %eax,%edx
  1009bc:	89 d0                	mov    %edx,%eax
  1009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	0f 48 c2             	cmovs  %edx,%eax
  1009c9:	c1 f8 0a             	sar    $0xa,%eax
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	c7 04 24 bc 70 10 00 	movl   $0x1070bc,(%esp)
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
  100a05:	c7 04 24 e6 70 10 00 	movl   $0x1070e6,(%esp)
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
  100a73:	c7 04 24 02 71 10 00 	movl   $0x107102,(%esp)
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
  100ac6:	c7 04 24 14 71 10 00 	movl   $0x107114,(%esp)
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
  100af9:	c7 04 24 30 71 10 00 	movl   $0x107130,(%esp)
  100b00:	e8 9d f7 ff ff       	call   1002a2 <cprintf>
        for (j = 0; j < 4; j ++) {
  100b05:	ff 45 e8             	incl   -0x18(%ebp)
  100b08:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b0c:	7e d6                	jle    100ae4 <print_stackframe+0x51>
        }
        cprintf("\n");
  100b0e:	c7 04 24 38 71 10 00 	movl   $0x107138,(%esp)
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
  100b81:	c7 04 24 bc 71 10 00 	movl   $0x1071bc,(%esp)
  100b88:	e8 e4 59 00 00       	call   106571 <strchr>
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
  100ba9:	c7 04 24 c1 71 10 00 	movl   $0x1071c1,(%esp)
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
  100beb:	c7 04 24 bc 71 10 00 	movl   $0x1071bc,(%esp)
  100bf2:	e8 7a 59 00 00       	call   106571 <strchr>
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
  100c4a:	05 00 a0 11 00       	add    $0x11a000,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c55:	89 04 24             	mov    %eax,(%esp)
  100c58:	e8 77 58 00 00       	call   1064d4 <strcmp>
  100c5d:	85 c0                	test   %eax,%eax
  100c5f:	75 31                	jne    100c92 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c64:	89 d0                	mov    %edx,%eax
  100c66:	01 c0                	add    %eax,%eax
  100c68:	01 d0                	add    %edx,%eax
  100c6a:	c1 e0 02             	shl    $0x2,%eax
  100c6d:	05 08 a0 11 00       	add    $0x11a008,%eax
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
  100ca4:	c7 04 24 df 71 10 00 	movl   $0x1071df,(%esp)
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
  100cc1:	c7 04 24 f8 71 10 00 	movl   $0x1071f8,(%esp)
  100cc8:	e8 d5 f5 ff ff       	call   1002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ccd:	c7 04 24 20 72 10 00 	movl   $0x107220,(%esp)
  100cd4:	e8 c9 f5 ff ff       	call   1002a2 <cprintf>

    if (tf != NULL) {
  100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cdd:	74 0b                	je     100cea <kmonitor+0x2f>
        print_trapframe(tf);
  100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce2:	89 04 24             	mov    %eax,(%esp)
  100ce5:	e8 b4 0d 00 00       	call   101a9e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cea:	c7 04 24 45 72 10 00 	movl   $0x107245,(%esp)
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
  100d36:	05 04 a0 11 00       	add    $0x11a004,%eax
  100d3b:	8b 08                	mov    (%eax),%ecx
  100d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d40:	89 d0                	mov    %edx,%eax
  100d42:	01 c0                	add    %eax,%eax
  100d44:	01 d0                	add    %edx,%eax
  100d46:	c1 e0 02             	shl    $0x2,%eax
  100d49:	05 00 a0 11 00       	add    $0x11a000,%eax
  100d4e:	8b 00                	mov    (%eax),%eax
  100d50:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d58:	c7 04 24 49 72 10 00 	movl   $0x107249,(%esp)
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
  100dd9:	c7 05 0c df 11 00 00 	movl   $0x0,0x11df0c
  100de0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de3:	c7 04 24 52 72 10 00 	movl   $0x107252,(%esp)
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
  100ebb:	66 c7 05 46 d4 11 00 	movw   $0x3b4,0x11d446
  100ec2:	b4 03 
  100ec4:	eb 13                	jmp    100ed9 <cga_init+0x54>
    } else {
        *cp = was;
  100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ecd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ed0:	66 c7 05 46 d4 11 00 	movw   $0x3d4,0x11d446
  100ed7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed9:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100ee0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eec:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ef1:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
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
  100f17:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100f1e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f22:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f26:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2f:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
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
  100f55:	a3 40 d4 11 00       	mov    %eax,0x11d440
    crt_pos = pos;
  100f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5d:	0f b7 c0             	movzwl %ax,%eax
  100f60:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
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
  101010:	a3 48 d4 11 00       	mov    %eax,0x11d448
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
  101035:	a1 48 d4 11 00       	mov    0x11d448,%eax
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
  101139:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101140:	85 c0                	test   %eax,%eax
  101142:	0f 84 af 00 00 00    	je     1011f7 <cga_putc+0xf1>
            crt_pos --;
  101148:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10114f:	48                   	dec    %eax
  101150:	0f b7 c0             	movzwl %ax,%eax
  101153:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101159:	8b 45 08             	mov    0x8(%ebp),%eax
  10115c:	98                   	cwtl   
  10115d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101162:	98                   	cwtl   
  101163:	83 c8 20             	or     $0x20,%eax
  101166:	98                   	cwtl   
  101167:	8b 15 40 d4 11 00    	mov    0x11d440,%edx
  10116d:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  101174:	01 c9                	add    %ecx,%ecx
  101176:	01 ca                	add    %ecx,%edx
  101178:	0f b7 c0             	movzwl %ax,%eax
  10117b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10117e:	eb 77                	jmp    1011f7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101180:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101187:	83 c0 50             	add    $0x50,%eax
  10118a:	0f b7 c0             	movzwl %ax,%eax
  10118d:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101193:	0f b7 1d 44 d4 11 00 	movzwl 0x11d444,%ebx
  10119a:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
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
  1011c5:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
        break;
  1011cb:	eb 2b                	jmp    1011f8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011cd:	8b 0d 40 d4 11 00    	mov    0x11d440,%ecx
  1011d3:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011da:	8d 50 01             	lea    0x1(%eax),%edx
  1011dd:	0f b7 d2             	movzwl %dx,%edx
  1011e0:	66 89 15 44 d4 11 00 	mov    %dx,0x11d444
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
  1011f8:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011ff:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101204:	76 5d                	jbe    101263 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101206:	a1 40 d4 11 00       	mov    0x11d440,%eax
  10120b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101211:	a1 40 d4 11 00       	mov    0x11d440,%eax
  101216:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10121d:	00 
  10121e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101222:	89 04 24             	mov    %eax,(%esp)
  101225:	e8 3d 55 00 00       	call   106767 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10122a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101231:	eb 14                	jmp    101247 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101233:	a1 40 d4 11 00       	mov    0x11d440,%eax
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
  101250:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101257:	83 e8 50             	sub    $0x50,%eax
  10125a:	0f b7 c0             	movzwl %ax,%eax
  10125d:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101263:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  10126a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10126e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101272:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101276:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10127a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10127b:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101282:	c1 e8 08             	shr    $0x8,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	0f b6 c0             	movzbl %al,%eax
  10128b:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
  101292:	42                   	inc    %edx
  101293:	0f b7 d2             	movzwl %dx,%edx
  101296:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10129a:	88 45 e9             	mov    %al,-0x17(%ebp)
  10129d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012a1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012a6:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  1012ad:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012b1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012b5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012b9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012be:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1012c5:	0f b6 c0             	movzbl %al,%eax
  1012c8:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
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
  101391:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101396:	8d 50 01             	lea    0x1(%eax),%edx
  101399:	89 15 64 d6 11 00    	mov    %edx,0x11d664
  10139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013a2:	88 90 60 d4 11 00    	mov    %dl,0x11d460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a8:	a1 64 d6 11 00       	mov    0x11d664,%eax
  1013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013b2:	75 0a                	jne    1013be <cons_intr+0x3b>
                cons.wpos = 0;
  1013b4:	c7 05 64 d6 11 00 00 	movl   $0x0,0x11d664
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
  10142c:	a1 48 d4 11 00       	mov    0x11d448,%eax
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
  10148d:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101492:	83 c8 40             	or     $0x40,%eax
  101495:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  10149a:	b8 00 00 00 00       	mov    $0x0,%eax
  10149f:	e9 22 01 00 00       	jmp    1015c6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	84 c0                	test   %al,%al
  1014aa:	79 45                	jns    1014f1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014ac:	a1 68 d6 11 00       	mov    0x11d668,%eax
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
  1014cb:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1014d2:	0c 40                	or     $0x40,%al
  1014d4:	0f b6 c0             	movzbl %al,%eax
  1014d7:	f7 d0                	not    %eax
  1014d9:	89 c2                	mov    %eax,%edx
  1014db:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014e0:	21 d0                	and    %edx,%eax
  1014e2:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  1014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ec:	e9 d5 00 00 00       	jmp    1015c6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014f1:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014f6:	83 e0 40             	and    $0x40,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	74 11                	je     10150e <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101501:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101506:	83 e0 bf             	and    $0xffffffbf,%eax
  101509:	a3 68 d6 11 00       	mov    %eax,0x11d668
    }

    shift |= shiftcode[data];
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  101519:	0f b6 d0             	movzbl %al,%edx
  10151c:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101521:	09 d0                	or     %edx,%eax
  101523:	a3 68 d6 11 00       	mov    %eax,0x11d668
    shift ^= togglecode[data];
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	0f b6 80 40 a1 11 00 	movzbl 0x11a140(%eax),%eax
  101533:	0f b6 d0             	movzbl %al,%edx
  101536:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10153b:	31 d0                	xor    %edx,%eax
  10153d:	a3 68 d6 11 00       	mov    %eax,0x11d668

    c = charcode[shift & (CTL | SHIFT)][data];
  101542:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101547:	83 e0 03             	and    $0x3,%eax
  10154a:	8b 14 85 40 a5 11 00 	mov    0x11a540(,%eax,4),%edx
  101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101555:	01 d0                	add    %edx,%eax
  101557:	0f b6 00             	movzbl (%eax),%eax
  10155a:	0f b6 c0             	movzbl %al,%eax
  10155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101560:	a1 68 d6 11 00       	mov    0x11d668,%eax
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
  10158e:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101593:	f7 d0                	not    %eax
  101595:	83 e0 06             	and    $0x6,%eax
  101598:	85 c0                	test   %eax,%eax
  10159a:	75 27                	jne    1015c3 <kbd_proc_data+0x17f>
  10159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a3:	75 1e                	jne    1015c3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  1015a5:	c7 04 24 6d 72 10 00 	movl   $0x10726d,(%esp)
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
  10160c:	a1 48 d4 11 00       	mov    0x11d448,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	75 0c                	jne    101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101615:	c7 04 24 79 72 10 00 	movl   $0x107279,(%esp)
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
  101680:	8b 15 60 d6 11 00    	mov    0x11d660,%edx
  101686:	a1 64 d6 11 00       	mov    0x11d664,%eax
  10168b:	39 c2                	cmp    %eax,%edx
  10168d:	74 31                	je     1016c0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10168f:	a1 60 d6 11 00       	mov    0x11d660,%eax
  101694:	8d 50 01             	lea    0x1(%eax),%edx
  101697:	89 15 60 d6 11 00    	mov    %edx,0x11d660
  10169d:	0f b6 80 60 d4 11 00 	movzbl 0x11d460(%eax),%eax
  1016a4:	0f b6 c0             	movzbl %al,%eax
  1016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016aa:	a1 60 d6 11 00       	mov    0x11d660,%eax
  1016af:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016b4:	75 0a                	jne    1016c0 <cons_getc+0x5f>
                cons.rpos = 0;
  1016b6:	c7 05 60 d6 11 00 00 	movl   $0x0,0x11d660
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
  1016e0:	66 a3 50 a5 11 00    	mov    %ax,0x11a550
    if (did_init) {
  1016e6:	a1 6c d6 11 00       	mov    0x11d66c,%eax
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
  101743:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
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
  101762:	c7 05 6c d6 11 00 01 	movl   $0x1,0x11d66c
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
  101876:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  10187d:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101882:	74 0f                	je     101893 <pic_init+0x137>
        pic_setmask(irq_mask);
  101884:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
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
  1018b2:	c7 04 24 a0 72 10 00 	movl   $0x1072a0,(%esp)
  1018b9:	e8 e4 e9 ff ff       	call   1002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018be:	c7 04 24 aa 72 10 00 	movl   $0x1072aa,(%esp)
  1018c5:	e8 d8 e9 ff ff       	call   1002a2 <cprintf>
    panic("EOT: kernel seems ok.");
  1018ca:	c7 44 24 08 b8 72 10 	movl   $0x1072b8,0x8(%esp)
  1018d1:	00 
  1018d2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018d9:	00 
  1018da:	c7 04 24 ce 72 10 00 	movl   $0x1072ce,(%esp)
  1018e1:	e8 13 eb ff ff       	call   1003f9 <__panic>

001018e6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018e6:	55                   	push   %ebp
  1018e7:	89 e5                	mov    %esp,%ebp
  1018e9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018f3:	e9 c4 00 00 00       	jmp    1019bc <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  101902:	0f b7 d0             	movzwl %ax,%edx
  101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101908:	66 89 14 c5 80 d6 11 	mov    %dx,0x11d680(,%eax,8)
  10190f:	00 
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	66 c7 04 c5 82 d6 11 	movw   $0x8,0x11d682(,%eax,8)
  10191a:	00 08 00 
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  101927:	00 
  101928:	80 e2 e0             	and    $0xe0,%dl
  10192b:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101932:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101935:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  10193c:	00 
  10193d:	80 e2 1f             	and    $0x1f,%dl
  101940:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194a:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101951:	00 
  101952:	80 e2 f0             	and    $0xf0,%dl
  101955:	80 ca 0e             	or     $0xe,%dl
  101958:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  10195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101962:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101969:	00 
  10196a:	80 e2 ef             	and    $0xef,%dl
  10196d:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  10197e:	00 
  10197f:	80 e2 9f             	and    $0x9f,%dl
  101982:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198c:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101993:	00 
  101994:	80 ca 80             	or     $0x80,%dl
  101997:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  10199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a1:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  1019a8:	c1 e8 10             	shr    $0x10,%eax
  1019ab:	0f b7 d0             	movzwl %ax,%edx
  1019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b1:	66 89 14 c5 86 d6 11 	mov    %dx,0x11d686(,%eax,8)
  1019b8:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019b9:	ff 45 fc             	incl   -0x4(%ebp)
  1019bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019c4:	0f 86 2e ff ff ff    	jbe    1018f8 <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019ca:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  1019cf:	0f b7 c0             	movzwl %ax,%eax
  1019d2:	66 a3 48 da 11 00    	mov    %ax,0x11da48
  1019d8:	66 c7 05 4a da 11 00 	movw   $0x8,0x11da4a
  1019df:	08 00 
  1019e1:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  1019e8:	24 e0                	and    $0xe0,%al
  1019ea:	a2 4c da 11 00       	mov    %al,0x11da4c
  1019ef:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  1019f6:	24 1f                	and    $0x1f,%al
  1019f8:	a2 4c da 11 00       	mov    %al,0x11da4c
  1019fd:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a04:	24 f0                	and    $0xf0,%al
  101a06:	0c 0e                	or     $0xe,%al
  101a08:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a0d:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a14:	24 ef                	and    $0xef,%al
  101a16:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a1b:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a22:	0c 60                	or     $0x60,%al
  101a24:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a29:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a30:	0c 80                	or     $0x80,%al
  101a32:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a37:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101a3c:	c1 e8 10             	shr    $0x10,%eax
  101a3f:	0f b7 c0             	movzwl %ax,%eax
  101a42:	66 a3 4e da 11 00    	mov    %ax,0x11da4e
  101a48:	c7 45 f8 60 a5 11 00 	movl   $0x11a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a52:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a55:	90                   	nop
  101a56:	c9                   	leave  
  101a57:	c3                   	ret    

00101a58 <trapname>:

static const char *
trapname(int trapno) {
  101a58:	55                   	push   %ebp
  101a59:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5e:	83 f8 13             	cmp    $0x13,%eax
  101a61:	77 0c                	ja     101a6f <trapname+0x17>
        return excnames[trapno];
  101a63:	8b 45 08             	mov    0x8(%ebp),%eax
  101a66:	8b 04 85 20 76 10 00 	mov    0x107620(,%eax,4),%eax
  101a6d:	eb 18                	jmp    101a87 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a6f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a73:	7e 0d                	jle    101a82 <trapname+0x2a>
  101a75:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a79:	7f 07                	jg     101a82 <trapname+0x2a>
        return "Hardware Interrupt";
  101a7b:	b8 df 72 10 00       	mov    $0x1072df,%eax
  101a80:	eb 05                	jmp    101a87 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a82:	b8 f2 72 10 00       	mov    $0x1072f2,%eax
}
  101a87:	5d                   	pop    %ebp
  101a88:	c3                   	ret    

00101a89 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a89:	55                   	push   %ebp
  101a8a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a93:	83 f8 08             	cmp    $0x8,%eax
  101a96:	0f 94 c0             	sete   %al
  101a99:	0f b6 c0             	movzbl %al,%eax
}
  101a9c:	5d                   	pop    %ebp
  101a9d:	c3                   	ret    

00101a9e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a9e:	55                   	push   %ebp
  101a9f:	89 e5                	mov    %esp,%ebp
  101aa1:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	c7 04 24 33 73 10 00 	movl   $0x107333,(%esp)
  101ab2:	e8 eb e7 ff ff       	call   1002a2 <cprintf>
    print_regs(&tf->tf_regs);
  101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aba:	89 04 24             	mov    %eax,(%esp)
  101abd:	e8 8f 01 00 00       	call   101c51 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 44 73 10 00 	movl   $0x107344,(%esp)
  101ad4:	e8 c9 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae4:	c7 04 24 57 73 10 00 	movl   $0x107357,(%esp)
  101aeb:	e8 b2 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afb:	c7 04 24 6a 73 10 00 	movl   $0x10736a,(%esp)
  101b02:	e8 9b e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b12:	c7 04 24 7d 73 10 00 	movl   $0x10737d,(%esp)
  101b19:	e8 84 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	8b 40 30             	mov    0x30(%eax),%eax
  101b24:	89 04 24             	mov    %eax,(%esp)
  101b27:	e8 2c ff ff ff       	call   101a58 <trapname>
  101b2c:	89 c2                	mov    %eax,%edx
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	8b 40 30             	mov    0x30(%eax),%eax
  101b34:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 90 73 10 00 	movl   $0x107390,(%esp)
  101b43:	e8 5a e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 34             	mov    0x34(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 a2 73 10 00 	movl   $0x1073a2,(%esp)
  101b59:	e8 44 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	8b 40 38             	mov    0x38(%eax),%eax
  101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b68:	c7 04 24 b1 73 10 00 	movl   $0x1073b1,(%esp)
  101b6f:	e8 2e e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b74:	8b 45 08             	mov    0x8(%ebp),%eax
  101b77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7f:	c7 04 24 c0 73 10 00 	movl   $0x1073c0,(%esp)
  101b86:	e8 17 e7 ff ff       	call   1002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8e:	8b 40 40             	mov    0x40(%eax),%eax
  101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b95:	c7 04 24 d3 73 10 00 	movl   $0x1073d3,(%esp)
  101b9c:	e8 01 e7 ff ff       	call   1002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ba8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101baf:	eb 3d                	jmp    101bee <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	8b 50 40             	mov    0x40(%eax),%edx
  101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bba:	21 d0                	and    %edx,%eax
  101bbc:	85 c0                	test   %eax,%eax
  101bbe:	74 28                	je     101be8 <print_trapframe+0x14a>
  101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc3:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101bca:	85 c0                	test   %eax,%eax
  101bcc:	74 1a                	je     101be8 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd1:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 e2 73 10 00 	movl   $0x1073e2,(%esp)
  101be3:	e8 ba e6 ff ff       	call   1002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101be8:	ff 45 f4             	incl   -0xc(%ebp)
  101beb:	d1 65 f0             	shll   -0x10(%ebp)
  101bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf1:	83 f8 17             	cmp    $0x17,%eax
  101bf4:	76 bb                	jbe    101bb1 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf9:	8b 40 40             	mov    0x40(%eax),%eax
  101bfc:	c1 e8 0c             	shr    $0xc,%eax
  101bff:	83 e0 03             	and    $0x3,%eax
  101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c06:	c7 04 24 e6 73 10 00 	movl   $0x1073e6,(%esp)
  101c0d:	e8 90 e6 ff ff       	call   1002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	89 04 24             	mov    %eax,(%esp)
  101c18:	e8 6c fe ff ff       	call   101a89 <trap_in_kernel>
  101c1d:	85 c0                	test   %eax,%eax
  101c1f:	75 2d                	jne    101c4e <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c21:	8b 45 08             	mov    0x8(%ebp),%eax
  101c24:	8b 40 44             	mov    0x44(%eax),%eax
  101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2b:	c7 04 24 ef 73 10 00 	movl   $0x1073ef,(%esp)
  101c32:	e8 6b e6 ff ff       	call   1002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c37:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c42:	c7 04 24 fe 73 10 00 	movl   $0x1073fe,(%esp)
  101c49:	e8 54 e6 ff ff       	call   1002a2 <cprintf>
    }
}
  101c4e:	90                   	nop
  101c4f:	c9                   	leave  
  101c50:	c3                   	ret    

00101c51 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c51:	55                   	push   %ebp
  101c52:	89 e5                	mov    %esp,%ebp
  101c54:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 00                	mov    (%eax),%eax
  101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c60:	c7 04 24 11 74 10 00 	movl   $0x107411,(%esp)
  101c67:	e8 36 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6f:	8b 40 04             	mov    0x4(%eax),%eax
  101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c76:	c7 04 24 20 74 10 00 	movl   $0x107420,(%esp)
  101c7d:	e8 20 e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 08             	mov    0x8(%eax),%eax
  101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8c:	c7 04 24 2f 74 10 00 	movl   $0x10742f,(%esp)
  101c93:	e8 0a e6 ff ff       	call   1002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c98:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  101c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca2:	c7 04 24 3e 74 10 00 	movl   $0x10743e,(%esp)
  101ca9:	e8 f4 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cae:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb1:	8b 40 10             	mov    0x10(%eax),%eax
  101cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb8:	c7 04 24 4d 74 10 00 	movl   $0x10744d,(%esp)
  101cbf:	e8 de e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc7:	8b 40 14             	mov    0x14(%eax),%eax
  101cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cce:	c7 04 24 5c 74 10 00 	movl   $0x10745c,(%esp)
  101cd5:	e8 c8 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cda:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdd:	8b 40 18             	mov    0x18(%eax),%eax
  101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce4:	c7 04 24 6b 74 10 00 	movl   $0x10746b,(%esp)
  101ceb:	e8 b2 e5 ff ff       	call   1002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf3:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfa:	c7 04 24 7a 74 10 00 	movl   $0x10747a,(%esp)
  101d01:	e8 9c e5 ff ff       	call   1002a2 <cprintf>
}
  101d06:	90                   	nop
  101d07:	c9                   	leave  
  101d08:	c3                   	ret    

00101d09 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d09:	55                   	push   %ebp
  101d0a:	89 e5                	mov    %esp,%ebp
  101d0c:	57                   	push   %edi
  101d0d:	56                   	push   %esi
  101d0e:	53                   	push   %ebx
  101d0f:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	8b 40 30             	mov    0x30(%eax),%eax
  101d18:	83 f8 2f             	cmp    $0x2f,%eax
  101d1b:	77 21                	ja     101d3e <trap_dispatch+0x35>
  101d1d:	83 f8 2e             	cmp    $0x2e,%eax
  101d20:	0f 83 5d 02 00 00    	jae    101f83 <trap_dispatch+0x27a>
  101d26:	83 f8 21             	cmp    $0x21,%eax
  101d29:	0f 84 95 00 00 00    	je     101dc4 <trap_dispatch+0xbb>
  101d2f:	83 f8 24             	cmp    $0x24,%eax
  101d32:	74 67                	je     101d9b <trap_dispatch+0x92>
  101d34:	83 f8 20             	cmp    $0x20,%eax
  101d37:	74 1c                	je     101d55 <trap_dispatch+0x4c>
  101d39:	e9 10 02 00 00       	jmp    101f4e <trap_dispatch+0x245>
  101d3e:	83 f8 78             	cmp    $0x78,%eax
  101d41:	0f 84 a6 00 00 00    	je     101ded <trap_dispatch+0xe4>
  101d47:	83 f8 79             	cmp    $0x79,%eax
  101d4a:	0f 84 81 01 00 00    	je     101ed1 <trap_dispatch+0x1c8>
  101d50:	e9 f9 01 00 00       	jmp    101f4e <trap_dispatch+0x245>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d55:	a1 0c df 11 00       	mov    0x11df0c,%eax
  101d5a:	40                   	inc    %eax
  101d5b:	a3 0c df 11 00       	mov    %eax,0x11df0c
        if (ticks % TICK_NUM == 0) {
  101d60:	8b 0d 0c df 11 00    	mov    0x11df0c,%ecx
  101d66:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d6b:	89 c8                	mov    %ecx,%eax
  101d6d:	f7 e2                	mul    %edx
  101d6f:	c1 ea 05             	shr    $0x5,%edx
  101d72:	89 d0                	mov    %edx,%eax
  101d74:	c1 e0 02             	shl    $0x2,%eax
  101d77:	01 d0                	add    %edx,%eax
  101d79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d80:	01 d0                	add    %edx,%eax
  101d82:	c1 e0 02             	shl    $0x2,%eax
  101d85:	29 c1                	sub    %eax,%ecx
  101d87:	89 ca                	mov    %ecx,%edx
  101d89:	85 d2                	test   %edx,%edx
  101d8b:	0f 85 f5 01 00 00    	jne    101f86 <trap_dispatch+0x27d>
            print_ticks();
  101d91:	e8 0e fb ff ff       	call   1018a4 <print_ticks>
        }
        break;
  101d96:	e9 eb 01 00 00       	jmp    101f86 <trap_dispatch+0x27d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d9b:	e8 c1 f8 ff ff       	call   101661 <cons_getc>
  101da0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101da3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101da7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dab:	89 54 24 08          	mov    %edx,0x8(%esp)
  101daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db3:	c7 04 24 89 74 10 00 	movl   $0x107489,(%esp)
  101dba:	e8 e3 e4 ff ff       	call   1002a2 <cprintf>
        break;
  101dbf:	e9 c9 01 00 00       	jmp    101f8d <trap_dispatch+0x284>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dc4:	e8 98 f8 ff ff       	call   101661 <cons_getc>
  101dc9:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dcc:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dd0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dd4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddc:	c7 04 24 9b 74 10 00 	movl   $0x10749b,(%esp)
  101de3:	e8 ba e4 ff ff       	call   1002a2 <cprintf>
        break;
  101de8:	e9 a0 01 00 00       	jmp    101f8d <trap_dispatch+0x284>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101df4:	83 f8 1b             	cmp    $0x1b,%eax
  101df7:	0f 84 8c 01 00 00    	je     101f89 <trap_dispatch+0x280>
            switchk2u = *tf;
  101dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  101e00:	b8 20 df 11 00       	mov    $0x11df20,%eax
  101e05:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e0a:	89 c1                	mov    %eax,%ecx
  101e0c:	83 e1 01             	and    $0x1,%ecx
  101e0f:	85 c9                	test   %ecx,%ecx
  101e11:	74 0c                	je     101e1f <trap_dispatch+0x116>
  101e13:	0f b6 0a             	movzbl (%edx),%ecx
  101e16:	88 08                	mov    %cl,(%eax)
  101e18:	8d 40 01             	lea    0x1(%eax),%eax
  101e1b:	8d 52 01             	lea    0x1(%edx),%edx
  101e1e:	4b                   	dec    %ebx
  101e1f:	89 c1                	mov    %eax,%ecx
  101e21:	83 e1 02             	and    $0x2,%ecx
  101e24:	85 c9                	test   %ecx,%ecx
  101e26:	74 0f                	je     101e37 <trap_dispatch+0x12e>
  101e28:	0f b7 0a             	movzwl (%edx),%ecx
  101e2b:	66 89 08             	mov    %cx,(%eax)
  101e2e:	8d 40 02             	lea    0x2(%eax),%eax
  101e31:	8d 52 02             	lea    0x2(%edx),%edx
  101e34:	83 eb 02             	sub    $0x2,%ebx
  101e37:	89 df                	mov    %ebx,%edi
  101e39:	83 e7 fc             	and    $0xfffffffc,%edi
  101e3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e41:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101e44:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101e47:	83 c1 04             	add    $0x4,%ecx
  101e4a:	39 f9                	cmp    %edi,%ecx
  101e4c:	72 f3                	jb     101e41 <trap_dispatch+0x138>
  101e4e:	01 c8                	add    %ecx,%eax
  101e50:	01 ca                	add    %ecx,%edx
  101e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e57:	89 de                	mov    %ebx,%esi
  101e59:	83 e6 02             	and    $0x2,%esi
  101e5c:	85 f6                	test   %esi,%esi
  101e5e:	74 0b                	je     101e6b <trap_dispatch+0x162>
  101e60:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101e64:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101e68:	83 c1 02             	add    $0x2,%ecx
  101e6b:	83 e3 01             	and    $0x1,%ebx
  101e6e:	85 db                	test   %ebx,%ebx
  101e70:	74 07                	je     101e79 <trap_dispatch+0x170>
  101e72:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101e76:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101e79:	66 c7 05 5c df 11 00 	movw   $0x1b,0x11df5c
  101e80:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e82:	66 c7 05 68 df 11 00 	movw   $0x23,0x11df68
  101e89:	23 00 
  101e8b:	0f b7 05 68 df 11 00 	movzwl 0x11df68,%eax
  101e92:	66 a3 48 df 11 00    	mov    %ax,0x11df48
  101e98:	0f b7 05 48 df 11 00 	movzwl 0x11df48,%eax
  101e9f:	66 a3 4c df 11 00    	mov    %ax,0x11df4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea8:	83 c0 44             	add    $0x44,%eax
  101eab:	a3 64 df 11 00       	mov    %eax,0x11df64
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101eb0:	a1 60 df 11 00       	mov    0x11df60,%eax
  101eb5:	0d 00 30 00 00       	or     $0x3000,%eax
  101eba:	a3 60 df 11 00       	mov    %eax,0x11df60
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec2:	83 e8 04             	sub    $0x4,%eax
  101ec5:	ba 20 df 11 00       	mov    $0x11df20,%edx
  101eca:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ecc:	e9 b8 00 00 00       	jmp    101f89 <trap_dispatch+0x280>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed8:	83 f8 08             	cmp    $0x8,%eax
  101edb:	0f 84 ab 00 00 00    	je     101f8c <trap_dispatch+0x283>
            tf->tf_cs = KERNEL_CS;
  101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101eea:	8b 45 08             	mov    0x8(%ebp),%eax
  101eed:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101efa:	8b 45 08             	mov    0x8(%ebp),%eax
  101efd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f01:	8b 45 08             	mov    0x8(%ebp),%eax
  101f04:	8b 40 40             	mov    0x40(%eax),%eax
  101f07:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f0c:	89 c2                	mov    %eax,%edx
  101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f11:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f14:	8b 45 08             	mov    0x8(%ebp),%eax
  101f17:	8b 40 44             	mov    0x44(%eax),%eax
  101f1a:	83 e8 44             	sub    $0x44,%eax
  101f1d:	a3 6c df 11 00       	mov    %eax,0x11df6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f22:	a1 6c df 11 00       	mov    0x11df6c,%eax
  101f27:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f2e:	00 
  101f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  101f32:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f36:	89 04 24             	mov    %eax,(%esp)
  101f39:	e8 29 48 00 00       	call   106767 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f3e:	8b 15 6c df 11 00    	mov    0x11df6c,%edx
  101f44:	8b 45 08             	mov    0x8(%ebp),%eax
  101f47:	83 e8 04             	sub    $0x4,%eax
  101f4a:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f4c:	eb 3e                	jmp    101f8c <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f51:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f55:	83 e0 03             	and    $0x3,%eax
  101f58:	85 c0                	test   %eax,%eax
  101f5a:	75 31                	jne    101f8d <trap_dispatch+0x284>
            print_trapframe(tf);
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	89 04 24             	mov    %eax,(%esp)
  101f62:	e8 37 fb ff ff       	call   101a9e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f67:	c7 44 24 08 aa 74 10 	movl   $0x1074aa,0x8(%esp)
  101f6e:	00 
  101f6f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101f76:	00 
  101f77:	c7 04 24 ce 72 10 00 	movl   $0x1072ce,(%esp)
  101f7e:	e8 76 e4 ff ff       	call   1003f9 <__panic>
        break;
  101f83:	90                   	nop
  101f84:	eb 07                	jmp    101f8d <trap_dispatch+0x284>
        break;
  101f86:	90                   	nop
  101f87:	eb 04                	jmp    101f8d <trap_dispatch+0x284>
        break;
  101f89:	90                   	nop
  101f8a:	eb 01                	jmp    101f8d <trap_dispatch+0x284>
        break;
  101f8c:	90                   	nop
        }
    }
}
  101f8d:	90                   	nop
  101f8e:	83 c4 2c             	add    $0x2c,%esp
  101f91:	5b                   	pop    %ebx
  101f92:	5e                   	pop    %esi
  101f93:	5f                   	pop    %edi
  101f94:	5d                   	pop    %ebp
  101f95:	c3                   	ret    

00101f96 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f96:	55                   	push   %ebp
  101f97:	89 e5                	mov    %esp,%ebp
  101f99:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9f:	89 04 24             	mov    %eax,(%esp)
  101fa2:	e8 62 fd ff ff       	call   101d09 <trap_dispatch>
}
  101fa7:	90                   	nop
  101fa8:	c9                   	leave  
  101fa9:	c3                   	ret    

00101faa <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $0
  101fac:	6a 00                	push   $0x0
  jmp __alltraps
  101fae:	e9 69 0a 00 00       	jmp    102a1c <__alltraps>

00101fb3 <vector1>:
.globl vector1
vector1:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $1
  101fb5:	6a 01                	push   $0x1
  jmp __alltraps
  101fb7:	e9 60 0a 00 00       	jmp    102a1c <__alltraps>

00101fbc <vector2>:
.globl vector2
vector2:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $2
  101fbe:	6a 02                	push   $0x2
  jmp __alltraps
  101fc0:	e9 57 0a 00 00       	jmp    102a1c <__alltraps>

00101fc5 <vector3>:
.globl vector3
vector3:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $3
  101fc7:	6a 03                	push   $0x3
  jmp __alltraps
  101fc9:	e9 4e 0a 00 00       	jmp    102a1c <__alltraps>

00101fce <vector4>:
.globl vector4
vector4:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $4
  101fd0:	6a 04                	push   $0x4
  jmp __alltraps
  101fd2:	e9 45 0a 00 00       	jmp    102a1c <__alltraps>

00101fd7 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $5
  101fd9:	6a 05                	push   $0x5
  jmp __alltraps
  101fdb:	e9 3c 0a 00 00       	jmp    102a1c <__alltraps>

00101fe0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $6
  101fe2:	6a 06                	push   $0x6
  jmp __alltraps
  101fe4:	e9 33 0a 00 00       	jmp    102a1c <__alltraps>

00101fe9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $7
  101feb:	6a 07                	push   $0x7
  jmp __alltraps
  101fed:	e9 2a 0a 00 00       	jmp    102a1c <__alltraps>

00101ff2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ff2:	6a 08                	push   $0x8
  jmp __alltraps
  101ff4:	e9 23 0a 00 00       	jmp    102a1c <__alltraps>

00101ff9 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $9
  101ffb:	6a 09                	push   $0x9
  jmp __alltraps
  101ffd:	e9 1a 0a 00 00       	jmp    102a1c <__alltraps>

00102002 <vector10>:
.globl vector10
vector10:
  pushl $10
  102002:	6a 0a                	push   $0xa
  jmp __alltraps
  102004:	e9 13 0a 00 00       	jmp    102a1c <__alltraps>

00102009 <vector11>:
.globl vector11
vector11:
  pushl $11
  102009:	6a 0b                	push   $0xb
  jmp __alltraps
  10200b:	e9 0c 0a 00 00       	jmp    102a1c <__alltraps>

00102010 <vector12>:
.globl vector12
vector12:
  pushl $12
  102010:	6a 0c                	push   $0xc
  jmp __alltraps
  102012:	e9 05 0a 00 00       	jmp    102a1c <__alltraps>

00102017 <vector13>:
.globl vector13
vector13:
  pushl $13
  102017:	6a 0d                	push   $0xd
  jmp __alltraps
  102019:	e9 fe 09 00 00       	jmp    102a1c <__alltraps>

0010201e <vector14>:
.globl vector14
vector14:
  pushl $14
  10201e:	6a 0e                	push   $0xe
  jmp __alltraps
  102020:	e9 f7 09 00 00       	jmp    102a1c <__alltraps>

00102025 <vector15>:
.globl vector15
vector15:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $15
  102027:	6a 0f                	push   $0xf
  jmp __alltraps
  102029:	e9 ee 09 00 00       	jmp    102a1c <__alltraps>

0010202e <vector16>:
.globl vector16
vector16:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $16
  102030:	6a 10                	push   $0x10
  jmp __alltraps
  102032:	e9 e5 09 00 00       	jmp    102a1c <__alltraps>

00102037 <vector17>:
.globl vector17
vector17:
  pushl $17
  102037:	6a 11                	push   $0x11
  jmp __alltraps
  102039:	e9 de 09 00 00       	jmp    102a1c <__alltraps>

0010203e <vector18>:
.globl vector18
vector18:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $18
  102040:	6a 12                	push   $0x12
  jmp __alltraps
  102042:	e9 d5 09 00 00       	jmp    102a1c <__alltraps>

00102047 <vector19>:
.globl vector19
vector19:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $19
  102049:	6a 13                	push   $0x13
  jmp __alltraps
  10204b:	e9 cc 09 00 00       	jmp    102a1c <__alltraps>

00102050 <vector20>:
.globl vector20
vector20:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $20
  102052:	6a 14                	push   $0x14
  jmp __alltraps
  102054:	e9 c3 09 00 00       	jmp    102a1c <__alltraps>

00102059 <vector21>:
.globl vector21
vector21:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $21
  10205b:	6a 15                	push   $0x15
  jmp __alltraps
  10205d:	e9 ba 09 00 00       	jmp    102a1c <__alltraps>

00102062 <vector22>:
.globl vector22
vector22:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $22
  102064:	6a 16                	push   $0x16
  jmp __alltraps
  102066:	e9 b1 09 00 00       	jmp    102a1c <__alltraps>

0010206b <vector23>:
.globl vector23
vector23:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $23
  10206d:	6a 17                	push   $0x17
  jmp __alltraps
  10206f:	e9 a8 09 00 00       	jmp    102a1c <__alltraps>

00102074 <vector24>:
.globl vector24
vector24:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $24
  102076:	6a 18                	push   $0x18
  jmp __alltraps
  102078:	e9 9f 09 00 00       	jmp    102a1c <__alltraps>

0010207d <vector25>:
.globl vector25
vector25:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $25
  10207f:	6a 19                	push   $0x19
  jmp __alltraps
  102081:	e9 96 09 00 00       	jmp    102a1c <__alltraps>

00102086 <vector26>:
.globl vector26
vector26:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $26
  102088:	6a 1a                	push   $0x1a
  jmp __alltraps
  10208a:	e9 8d 09 00 00       	jmp    102a1c <__alltraps>

0010208f <vector27>:
.globl vector27
vector27:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $27
  102091:	6a 1b                	push   $0x1b
  jmp __alltraps
  102093:	e9 84 09 00 00       	jmp    102a1c <__alltraps>

00102098 <vector28>:
.globl vector28
vector28:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $28
  10209a:	6a 1c                	push   $0x1c
  jmp __alltraps
  10209c:	e9 7b 09 00 00       	jmp    102a1c <__alltraps>

001020a1 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $29
  1020a3:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020a5:	e9 72 09 00 00       	jmp    102a1c <__alltraps>

001020aa <vector30>:
.globl vector30
vector30:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $30
  1020ac:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020ae:	e9 69 09 00 00       	jmp    102a1c <__alltraps>

001020b3 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $31
  1020b5:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020b7:	e9 60 09 00 00       	jmp    102a1c <__alltraps>

001020bc <vector32>:
.globl vector32
vector32:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $32
  1020be:	6a 20                	push   $0x20
  jmp __alltraps
  1020c0:	e9 57 09 00 00       	jmp    102a1c <__alltraps>

001020c5 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $33
  1020c7:	6a 21                	push   $0x21
  jmp __alltraps
  1020c9:	e9 4e 09 00 00       	jmp    102a1c <__alltraps>

001020ce <vector34>:
.globl vector34
vector34:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $34
  1020d0:	6a 22                	push   $0x22
  jmp __alltraps
  1020d2:	e9 45 09 00 00       	jmp    102a1c <__alltraps>

001020d7 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $35
  1020d9:	6a 23                	push   $0x23
  jmp __alltraps
  1020db:	e9 3c 09 00 00       	jmp    102a1c <__alltraps>

001020e0 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $36
  1020e2:	6a 24                	push   $0x24
  jmp __alltraps
  1020e4:	e9 33 09 00 00       	jmp    102a1c <__alltraps>

001020e9 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $37
  1020eb:	6a 25                	push   $0x25
  jmp __alltraps
  1020ed:	e9 2a 09 00 00       	jmp    102a1c <__alltraps>

001020f2 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $38
  1020f4:	6a 26                	push   $0x26
  jmp __alltraps
  1020f6:	e9 21 09 00 00       	jmp    102a1c <__alltraps>

001020fb <vector39>:
.globl vector39
vector39:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $39
  1020fd:	6a 27                	push   $0x27
  jmp __alltraps
  1020ff:	e9 18 09 00 00       	jmp    102a1c <__alltraps>

00102104 <vector40>:
.globl vector40
vector40:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $40
  102106:	6a 28                	push   $0x28
  jmp __alltraps
  102108:	e9 0f 09 00 00       	jmp    102a1c <__alltraps>

0010210d <vector41>:
.globl vector41
vector41:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $41
  10210f:	6a 29                	push   $0x29
  jmp __alltraps
  102111:	e9 06 09 00 00       	jmp    102a1c <__alltraps>

00102116 <vector42>:
.globl vector42
vector42:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $42
  102118:	6a 2a                	push   $0x2a
  jmp __alltraps
  10211a:	e9 fd 08 00 00       	jmp    102a1c <__alltraps>

0010211f <vector43>:
.globl vector43
vector43:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $43
  102121:	6a 2b                	push   $0x2b
  jmp __alltraps
  102123:	e9 f4 08 00 00       	jmp    102a1c <__alltraps>

00102128 <vector44>:
.globl vector44
vector44:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $44
  10212a:	6a 2c                	push   $0x2c
  jmp __alltraps
  10212c:	e9 eb 08 00 00       	jmp    102a1c <__alltraps>

00102131 <vector45>:
.globl vector45
vector45:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $45
  102133:	6a 2d                	push   $0x2d
  jmp __alltraps
  102135:	e9 e2 08 00 00       	jmp    102a1c <__alltraps>

0010213a <vector46>:
.globl vector46
vector46:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $46
  10213c:	6a 2e                	push   $0x2e
  jmp __alltraps
  10213e:	e9 d9 08 00 00       	jmp    102a1c <__alltraps>

00102143 <vector47>:
.globl vector47
vector47:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $47
  102145:	6a 2f                	push   $0x2f
  jmp __alltraps
  102147:	e9 d0 08 00 00       	jmp    102a1c <__alltraps>

0010214c <vector48>:
.globl vector48
vector48:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $48
  10214e:	6a 30                	push   $0x30
  jmp __alltraps
  102150:	e9 c7 08 00 00       	jmp    102a1c <__alltraps>

00102155 <vector49>:
.globl vector49
vector49:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $49
  102157:	6a 31                	push   $0x31
  jmp __alltraps
  102159:	e9 be 08 00 00       	jmp    102a1c <__alltraps>

0010215e <vector50>:
.globl vector50
vector50:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $50
  102160:	6a 32                	push   $0x32
  jmp __alltraps
  102162:	e9 b5 08 00 00       	jmp    102a1c <__alltraps>

00102167 <vector51>:
.globl vector51
vector51:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $51
  102169:	6a 33                	push   $0x33
  jmp __alltraps
  10216b:	e9 ac 08 00 00       	jmp    102a1c <__alltraps>

00102170 <vector52>:
.globl vector52
vector52:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $52
  102172:	6a 34                	push   $0x34
  jmp __alltraps
  102174:	e9 a3 08 00 00       	jmp    102a1c <__alltraps>

00102179 <vector53>:
.globl vector53
vector53:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $53
  10217b:	6a 35                	push   $0x35
  jmp __alltraps
  10217d:	e9 9a 08 00 00       	jmp    102a1c <__alltraps>

00102182 <vector54>:
.globl vector54
vector54:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $54
  102184:	6a 36                	push   $0x36
  jmp __alltraps
  102186:	e9 91 08 00 00       	jmp    102a1c <__alltraps>

0010218b <vector55>:
.globl vector55
vector55:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $55
  10218d:	6a 37                	push   $0x37
  jmp __alltraps
  10218f:	e9 88 08 00 00       	jmp    102a1c <__alltraps>

00102194 <vector56>:
.globl vector56
vector56:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $56
  102196:	6a 38                	push   $0x38
  jmp __alltraps
  102198:	e9 7f 08 00 00       	jmp    102a1c <__alltraps>

0010219d <vector57>:
.globl vector57
vector57:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $57
  10219f:	6a 39                	push   $0x39
  jmp __alltraps
  1021a1:	e9 76 08 00 00       	jmp    102a1c <__alltraps>

001021a6 <vector58>:
.globl vector58
vector58:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $58
  1021a8:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021aa:	e9 6d 08 00 00       	jmp    102a1c <__alltraps>

001021af <vector59>:
.globl vector59
vector59:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $59
  1021b1:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021b3:	e9 64 08 00 00       	jmp    102a1c <__alltraps>

001021b8 <vector60>:
.globl vector60
vector60:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $60
  1021ba:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021bc:	e9 5b 08 00 00       	jmp    102a1c <__alltraps>

001021c1 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $61
  1021c3:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021c5:	e9 52 08 00 00       	jmp    102a1c <__alltraps>

001021ca <vector62>:
.globl vector62
vector62:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $62
  1021cc:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021ce:	e9 49 08 00 00       	jmp    102a1c <__alltraps>

001021d3 <vector63>:
.globl vector63
vector63:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $63
  1021d5:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021d7:	e9 40 08 00 00       	jmp    102a1c <__alltraps>

001021dc <vector64>:
.globl vector64
vector64:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $64
  1021de:	6a 40                	push   $0x40
  jmp __alltraps
  1021e0:	e9 37 08 00 00       	jmp    102a1c <__alltraps>

001021e5 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $65
  1021e7:	6a 41                	push   $0x41
  jmp __alltraps
  1021e9:	e9 2e 08 00 00       	jmp    102a1c <__alltraps>

001021ee <vector66>:
.globl vector66
vector66:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $66
  1021f0:	6a 42                	push   $0x42
  jmp __alltraps
  1021f2:	e9 25 08 00 00       	jmp    102a1c <__alltraps>

001021f7 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $67
  1021f9:	6a 43                	push   $0x43
  jmp __alltraps
  1021fb:	e9 1c 08 00 00       	jmp    102a1c <__alltraps>

00102200 <vector68>:
.globl vector68
vector68:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $68
  102202:	6a 44                	push   $0x44
  jmp __alltraps
  102204:	e9 13 08 00 00       	jmp    102a1c <__alltraps>

00102209 <vector69>:
.globl vector69
vector69:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $69
  10220b:	6a 45                	push   $0x45
  jmp __alltraps
  10220d:	e9 0a 08 00 00       	jmp    102a1c <__alltraps>

00102212 <vector70>:
.globl vector70
vector70:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $70
  102214:	6a 46                	push   $0x46
  jmp __alltraps
  102216:	e9 01 08 00 00       	jmp    102a1c <__alltraps>

0010221b <vector71>:
.globl vector71
vector71:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $71
  10221d:	6a 47                	push   $0x47
  jmp __alltraps
  10221f:	e9 f8 07 00 00       	jmp    102a1c <__alltraps>

00102224 <vector72>:
.globl vector72
vector72:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $72
  102226:	6a 48                	push   $0x48
  jmp __alltraps
  102228:	e9 ef 07 00 00       	jmp    102a1c <__alltraps>

0010222d <vector73>:
.globl vector73
vector73:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $73
  10222f:	6a 49                	push   $0x49
  jmp __alltraps
  102231:	e9 e6 07 00 00       	jmp    102a1c <__alltraps>

00102236 <vector74>:
.globl vector74
vector74:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $74
  102238:	6a 4a                	push   $0x4a
  jmp __alltraps
  10223a:	e9 dd 07 00 00       	jmp    102a1c <__alltraps>

0010223f <vector75>:
.globl vector75
vector75:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $75
  102241:	6a 4b                	push   $0x4b
  jmp __alltraps
  102243:	e9 d4 07 00 00       	jmp    102a1c <__alltraps>

00102248 <vector76>:
.globl vector76
vector76:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $76
  10224a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10224c:	e9 cb 07 00 00       	jmp    102a1c <__alltraps>

00102251 <vector77>:
.globl vector77
vector77:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $77
  102253:	6a 4d                	push   $0x4d
  jmp __alltraps
  102255:	e9 c2 07 00 00       	jmp    102a1c <__alltraps>

0010225a <vector78>:
.globl vector78
vector78:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $78
  10225c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10225e:	e9 b9 07 00 00       	jmp    102a1c <__alltraps>

00102263 <vector79>:
.globl vector79
vector79:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $79
  102265:	6a 4f                	push   $0x4f
  jmp __alltraps
  102267:	e9 b0 07 00 00       	jmp    102a1c <__alltraps>

0010226c <vector80>:
.globl vector80
vector80:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $80
  10226e:	6a 50                	push   $0x50
  jmp __alltraps
  102270:	e9 a7 07 00 00       	jmp    102a1c <__alltraps>

00102275 <vector81>:
.globl vector81
vector81:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $81
  102277:	6a 51                	push   $0x51
  jmp __alltraps
  102279:	e9 9e 07 00 00       	jmp    102a1c <__alltraps>

0010227e <vector82>:
.globl vector82
vector82:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $82
  102280:	6a 52                	push   $0x52
  jmp __alltraps
  102282:	e9 95 07 00 00       	jmp    102a1c <__alltraps>

00102287 <vector83>:
.globl vector83
vector83:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $83
  102289:	6a 53                	push   $0x53
  jmp __alltraps
  10228b:	e9 8c 07 00 00       	jmp    102a1c <__alltraps>

00102290 <vector84>:
.globl vector84
vector84:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $84
  102292:	6a 54                	push   $0x54
  jmp __alltraps
  102294:	e9 83 07 00 00       	jmp    102a1c <__alltraps>

00102299 <vector85>:
.globl vector85
vector85:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $85
  10229b:	6a 55                	push   $0x55
  jmp __alltraps
  10229d:	e9 7a 07 00 00       	jmp    102a1c <__alltraps>

001022a2 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $86
  1022a4:	6a 56                	push   $0x56
  jmp __alltraps
  1022a6:	e9 71 07 00 00       	jmp    102a1c <__alltraps>

001022ab <vector87>:
.globl vector87
vector87:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $87
  1022ad:	6a 57                	push   $0x57
  jmp __alltraps
  1022af:	e9 68 07 00 00       	jmp    102a1c <__alltraps>

001022b4 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $88
  1022b6:	6a 58                	push   $0x58
  jmp __alltraps
  1022b8:	e9 5f 07 00 00       	jmp    102a1c <__alltraps>

001022bd <vector89>:
.globl vector89
vector89:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $89
  1022bf:	6a 59                	push   $0x59
  jmp __alltraps
  1022c1:	e9 56 07 00 00       	jmp    102a1c <__alltraps>

001022c6 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $90
  1022c8:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022ca:	e9 4d 07 00 00       	jmp    102a1c <__alltraps>

001022cf <vector91>:
.globl vector91
vector91:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $91
  1022d1:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022d3:	e9 44 07 00 00       	jmp    102a1c <__alltraps>

001022d8 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $92
  1022da:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022dc:	e9 3b 07 00 00       	jmp    102a1c <__alltraps>

001022e1 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $93
  1022e3:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022e5:	e9 32 07 00 00       	jmp    102a1c <__alltraps>

001022ea <vector94>:
.globl vector94
vector94:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $94
  1022ec:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022ee:	e9 29 07 00 00       	jmp    102a1c <__alltraps>

001022f3 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $95
  1022f5:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022f7:	e9 20 07 00 00       	jmp    102a1c <__alltraps>

001022fc <vector96>:
.globl vector96
vector96:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $96
  1022fe:	6a 60                	push   $0x60
  jmp __alltraps
  102300:	e9 17 07 00 00       	jmp    102a1c <__alltraps>

00102305 <vector97>:
.globl vector97
vector97:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $97
  102307:	6a 61                	push   $0x61
  jmp __alltraps
  102309:	e9 0e 07 00 00       	jmp    102a1c <__alltraps>

0010230e <vector98>:
.globl vector98
vector98:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $98
  102310:	6a 62                	push   $0x62
  jmp __alltraps
  102312:	e9 05 07 00 00       	jmp    102a1c <__alltraps>

00102317 <vector99>:
.globl vector99
vector99:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $99
  102319:	6a 63                	push   $0x63
  jmp __alltraps
  10231b:	e9 fc 06 00 00       	jmp    102a1c <__alltraps>

00102320 <vector100>:
.globl vector100
vector100:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $100
  102322:	6a 64                	push   $0x64
  jmp __alltraps
  102324:	e9 f3 06 00 00       	jmp    102a1c <__alltraps>

00102329 <vector101>:
.globl vector101
vector101:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $101
  10232b:	6a 65                	push   $0x65
  jmp __alltraps
  10232d:	e9 ea 06 00 00       	jmp    102a1c <__alltraps>

00102332 <vector102>:
.globl vector102
vector102:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $102
  102334:	6a 66                	push   $0x66
  jmp __alltraps
  102336:	e9 e1 06 00 00       	jmp    102a1c <__alltraps>

0010233b <vector103>:
.globl vector103
vector103:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $103
  10233d:	6a 67                	push   $0x67
  jmp __alltraps
  10233f:	e9 d8 06 00 00       	jmp    102a1c <__alltraps>

00102344 <vector104>:
.globl vector104
vector104:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $104
  102346:	6a 68                	push   $0x68
  jmp __alltraps
  102348:	e9 cf 06 00 00       	jmp    102a1c <__alltraps>

0010234d <vector105>:
.globl vector105
vector105:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $105
  10234f:	6a 69                	push   $0x69
  jmp __alltraps
  102351:	e9 c6 06 00 00       	jmp    102a1c <__alltraps>

00102356 <vector106>:
.globl vector106
vector106:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $106
  102358:	6a 6a                	push   $0x6a
  jmp __alltraps
  10235a:	e9 bd 06 00 00       	jmp    102a1c <__alltraps>

0010235f <vector107>:
.globl vector107
vector107:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $107
  102361:	6a 6b                	push   $0x6b
  jmp __alltraps
  102363:	e9 b4 06 00 00       	jmp    102a1c <__alltraps>

00102368 <vector108>:
.globl vector108
vector108:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $108
  10236a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10236c:	e9 ab 06 00 00       	jmp    102a1c <__alltraps>

00102371 <vector109>:
.globl vector109
vector109:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $109
  102373:	6a 6d                	push   $0x6d
  jmp __alltraps
  102375:	e9 a2 06 00 00       	jmp    102a1c <__alltraps>

0010237a <vector110>:
.globl vector110
vector110:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $110
  10237c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10237e:	e9 99 06 00 00       	jmp    102a1c <__alltraps>

00102383 <vector111>:
.globl vector111
vector111:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $111
  102385:	6a 6f                	push   $0x6f
  jmp __alltraps
  102387:	e9 90 06 00 00       	jmp    102a1c <__alltraps>

0010238c <vector112>:
.globl vector112
vector112:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $112
  10238e:	6a 70                	push   $0x70
  jmp __alltraps
  102390:	e9 87 06 00 00       	jmp    102a1c <__alltraps>

00102395 <vector113>:
.globl vector113
vector113:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $113
  102397:	6a 71                	push   $0x71
  jmp __alltraps
  102399:	e9 7e 06 00 00       	jmp    102a1c <__alltraps>

0010239e <vector114>:
.globl vector114
vector114:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $114
  1023a0:	6a 72                	push   $0x72
  jmp __alltraps
  1023a2:	e9 75 06 00 00       	jmp    102a1c <__alltraps>

001023a7 <vector115>:
.globl vector115
vector115:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $115
  1023a9:	6a 73                	push   $0x73
  jmp __alltraps
  1023ab:	e9 6c 06 00 00       	jmp    102a1c <__alltraps>

001023b0 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $116
  1023b2:	6a 74                	push   $0x74
  jmp __alltraps
  1023b4:	e9 63 06 00 00       	jmp    102a1c <__alltraps>

001023b9 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $117
  1023bb:	6a 75                	push   $0x75
  jmp __alltraps
  1023bd:	e9 5a 06 00 00       	jmp    102a1c <__alltraps>

001023c2 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $118
  1023c4:	6a 76                	push   $0x76
  jmp __alltraps
  1023c6:	e9 51 06 00 00       	jmp    102a1c <__alltraps>

001023cb <vector119>:
.globl vector119
vector119:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $119
  1023cd:	6a 77                	push   $0x77
  jmp __alltraps
  1023cf:	e9 48 06 00 00       	jmp    102a1c <__alltraps>

001023d4 <vector120>:
.globl vector120
vector120:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $120
  1023d6:	6a 78                	push   $0x78
  jmp __alltraps
  1023d8:	e9 3f 06 00 00       	jmp    102a1c <__alltraps>

001023dd <vector121>:
.globl vector121
vector121:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $121
  1023df:	6a 79                	push   $0x79
  jmp __alltraps
  1023e1:	e9 36 06 00 00       	jmp    102a1c <__alltraps>

001023e6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $122
  1023e8:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023ea:	e9 2d 06 00 00       	jmp    102a1c <__alltraps>

001023ef <vector123>:
.globl vector123
vector123:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $123
  1023f1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023f3:	e9 24 06 00 00       	jmp    102a1c <__alltraps>

001023f8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $124
  1023fa:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023fc:	e9 1b 06 00 00       	jmp    102a1c <__alltraps>

00102401 <vector125>:
.globl vector125
vector125:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $125
  102403:	6a 7d                	push   $0x7d
  jmp __alltraps
  102405:	e9 12 06 00 00       	jmp    102a1c <__alltraps>

0010240a <vector126>:
.globl vector126
vector126:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $126
  10240c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10240e:	e9 09 06 00 00       	jmp    102a1c <__alltraps>

00102413 <vector127>:
.globl vector127
vector127:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $127
  102415:	6a 7f                	push   $0x7f
  jmp __alltraps
  102417:	e9 00 06 00 00       	jmp    102a1c <__alltraps>

0010241c <vector128>:
.globl vector128
vector128:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $128
  10241e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102423:	e9 f4 05 00 00       	jmp    102a1c <__alltraps>

00102428 <vector129>:
.globl vector129
vector129:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $129
  10242a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10242f:	e9 e8 05 00 00       	jmp    102a1c <__alltraps>

00102434 <vector130>:
.globl vector130
vector130:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $130
  102436:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10243b:	e9 dc 05 00 00       	jmp    102a1c <__alltraps>

00102440 <vector131>:
.globl vector131
vector131:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $131
  102442:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102447:	e9 d0 05 00 00       	jmp    102a1c <__alltraps>

0010244c <vector132>:
.globl vector132
vector132:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $132
  10244e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102453:	e9 c4 05 00 00       	jmp    102a1c <__alltraps>

00102458 <vector133>:
.globl vector133
vector133:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $133
  10245a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10245f:	e9 b8 05 00 00       	jmp    102a1c <__alltraps>

00102464 <vector134>:
.globl vector134
vector134:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $134
  102466:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10246b:	e9 ac 05 00 00       	jmp    102a1c <__alltraps>

00102470 <vector135>:
.globl vector135
vector135:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $135
  102472:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102477:	e9 a0 05 00 00       	jmp    102a1c <__alltraps>

0010247c <vector136>:
.globl vector136
vector136:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $136
  10247e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102483:	e9 94 05 00 00       	jmp    102a1c <__alltraps>

00102488 <vector137>:
.globl vector137
vector137:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $137
  10248a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10248f:	e9 88 05 00 00       	jmp    102a1c <__alltraps>

00102494 <vector138>:
.globl vector138
vector138:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $138
  102496:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10249b:	e9 7c 05 00 00       	jmp    102a1c <__alltraps>

001024a0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $139
  1024a2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024a7:	e9 70 05 00 00       	jmp    102a1c <__alltraps>

001024ac <vector140>:
.globl vector140
vector140:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $140
  1024ae:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024b3:	e9 64 05 00 00       	jmp    102a1c <__alltraps>

001024b8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $141
  1024ba:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024bf:	e9 58 05 00 00       	jmp    102a1c <__alltraps>

001024c4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $142
  1024c6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024cb:	e9 4c 05 00 00       	jmp    102a1c <__alltraps>

001024d0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $143
  1024d2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024d7:	e9 40 05 00 00       	jmp    102a1c <__alltraps>

001024dc <vector144>:
.globl vector144
vector144:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $144
  1024de:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024e3:	e9 34 05 00 00       	jmp    102a1c <__alltraps>

001024e8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $145
  1024ea:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024ef:	e9 28 05 00 00       	jmp    102a1c <__alltraps>

001024f4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $146
  1024f6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024fb:	e9 1c 05 00 00       	jmp    102a1c <__alltraps>

00102500 <vector147>:
.globl vector147
vector147:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $147
  102502:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102507:	e9 10 05 00 00       	jmp    102a1c <__alltraps>

0010250c <vector148>:
.globl vector148
vector148:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $148
  10250e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102513:	e9 04 05 00 00       	jmp    102a1c <__alltraps>

00102518 <vector149>:
.globl vector149
vector149:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $149
  10251a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10251f:	e9 f8 04 00 00       	jmp    102a1c <__alltraps>

00102524 <vector150>:
.globl vector150
vector150:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $150
  102526:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10252b:	e9 ec 04 00 00       	jmp    102a1c <__alltraps>

00102530 <vector151>:
.globl vector151
vector151:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $151
  102532:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102537:	e9 e0 04 00 00       	jmp    102a1c <__alltraps>

0010253c <vector152>:
.globl vector152
vector152:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $152
  10253e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102543:	e9 d4 04 00 00       	jmp    102a1c <__alltraps>

00102548 <vector153>:
.globl vector153
vector153:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $153
  10254a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10254f:	e9 c8 04 00 00       	jmp    102a1c <__alltraps>

00102554 <vector154>:
.globl vector154
vector154:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $154
  102556:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10255b:	e9 bc 04 00 00       	jmp    102a1c <__alltraps>

00102560 <vector155>:
.globl vector155
vector155:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $155
  102562:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102567:	e9 b0 04 00 00       	jmp    102a1c <__alltraps>

0010256c <vector156>:
.globl vector156
vector156:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $156
  10256e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102573:	e9 a4 04 00 00       	jmp    102a1c <__alltraps>

00102578 <vector157>:
.globl vector157
vector157:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $157
  10257a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10257f:	e9 98 04 00 00       	jmp    102a1c <__alltraps>

00102584 <vector158>:
.globl vector158
vector158:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $158
  102586:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10258b:	e9 8c 04 00 00       	jmp    102a1c <__alltraps>

00102590 <vector159>:
.globl vector159
vector159:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $159
  102592:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102597:	e9 80 04 00 00       	jmp    102a1c <__alltraps>

0010259c <vector160>:
.globl vector160
vector160:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $160
  10259e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025a3:	e9 74 04 00 00       	jmp    102a1c <__alltraps>

001025a8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $161
  1025aa:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025af:	e9 68 04 00 00       	jmp    102a1c <__alltraps>

001025b4 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $162
  1025b6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025bb:	e9 5c 04 00 00       	jmp    102a1c <__alltraps>

001025c0 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $163
  1025c2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025c7:	e9 50 04 00 00       	jmp    102a1c <__alltraps>

001025cc <vector164>:
.globl vector164
vector164:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $164
  1025ce:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025d3:	e9 44 04 00 00       	jmp    102a1c <__alltraps>

001025d8 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $165
  1025da:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025df:	e9 38 04 00 00       	jmp    102a1c <__alltraps>

001025e4 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $166
  1025e6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025eb:	e9 2c 04 00 00       	jmp    102a1c <__alltraps>

001025f0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $167
  1025f2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025f7:	e9 20 04 00 00       	jmp    102a1c <__alltraps>

001025fc <vector168>:
.globl vector168
vector168:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $168
  1025fe:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102603:	e9 14 04 00 00       	jmp    102a1c <__alltraps>

00102608 <vector169>:
.globl vector169
vector169:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $169
  10260a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10260f:	e9 08 04 00 00       	jmp    102a1c <__alltraps>

00102614 <vector170>:
.globl vector170
vector170:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $170
  102616:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10261b:	e9 fc 03 00 00       	jmp    102a1c <__alltraps>

00102620 <vector171>:
.globl vector171
vector171:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $171
  102622:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102627:	e9 f0 03 00 00       	jmp    102a1c <__alltraps>

0010262c <vector172>:
.globl vector172
vector172:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $172
  10262e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102633:	e9 e4 03 00 00       	jmp    102a1c <__alltraps>

00102638 <vector173>:
.globl vector173
vector173:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $173
  10263a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10263f:	e9 d8 03 00 00       	jmp    102a1c <__alltraps>

00102644 <vector174>:
.globl vector174
vector174:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $174
  102646:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10264b:	e9 cc 03 00 00       	jmp    102a1c <__alltraps>

00102650 <vector175>:
.globl vector175
vector175:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $175
  102652:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102657:	e9 c0 03 00 00       	jmp    102a1c <__alltraps>

0010265c <vector176>:
.globl vector176
vector176:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $176
  10265e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102663:	e9 b4 03 00 00       	jmp    102a1c <__alltraps>

00102668 <vector177>:
.globl vector177
vector177:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $177
  10266a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10266f:	e9 a8 03 00 00       	jmp    102a1c <__alltraps>

00102674 <vector178>:
.globl vector178
vector178:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $178
  102676:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10267b:	e9 9c 03 00 00       	jmp    102a1c <__alltraps>

00102680 <vector179>:
.globl vector179
vector179:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $179
  102682:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102687:	e9 90 03 00 00       	jmp    102a1c <__alltraps>

0010268c <vector180>:
.globl vector180
vector180:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $180
  10268e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102693:	e9 84 03 00 00       	jmp    102a1c <__alltraps>

00102698 <vector181>:
.globl vector181
vector181:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $181
  10269a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10269f:	e9 78 03 00 00       	jmp    102a1c <__alltraps>

001026a4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $182
  1026a6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026ab:	e9 6c 03 00 00       	jmp    102a1c <__alltraps>

001026b0 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $183
  1026b2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026b7:	e9 60 03 00 00       	jmp    102a1c <__alltraps>

001026bc <vector184>:
.globl vector184
vector184:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $184
  1026be:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026c3:	e9 54 03 00 00       	jmp    102a1c <__alltraps>

001026c8 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $185
  1026ca:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026cf:	e9 48 03 00 00       	jmp    102a1c <__alltraps>

001026d4 <vector186>:
.globl vector186
vector186:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $186
  1026d6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026db:	e9 3c 03 00 00       	jmp    102a1c <__alltraps>

001026e0 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $187
  1026e2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026e7:	e9 30 03 00 00       	jmp    102a1c <__alltraps>

001026ec <vector188>:
.globl vector188
vector188:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $188
  1026ee:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026f3:	e9 24 03 00 00       	jmp    102a1c <__alltraps>

001026f8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $189
  1026fa:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026ff:	e9 18 03 00 00       	jmp    102a1c <__alltraps>

00102704 <vector190>:
.globl vector190
vector190:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $190
  102706:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10270b:	e9 0c 03 00 00       	jmp    102a1c <__alltraps>

00102710 <vector191>:
.globl vector191
vector191:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $191
  102712:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102717:	e9 00 03 00 00       	jmp    102a1c <__alltraps>

0010271c <vector192>:
.globl vector192
vector192:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $192
  10271e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102723:	e9 f4 02 00 00       	jmp    102a1c <__alltraps>

00102728 <vector193>:
.globl vector193
vector193:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $193
  10272a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10272f:	e9 e8 02 00 00       	jmp    102a1c <__alltraps>

00102734 <vector194>:
.globl vector194
vector194:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $194
  102736:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10273b:	e9 dc 02 00 00       	jmp    102a1c <__alltraps>

00102740 <vector195>:
.globl vector195
vector195:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $195
  102742:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102747:	e9 d0 02 00 00       	jmp    102a1c <__alltraps>

0010274c <vector196>:
.globl vector196
vector196:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $196
  10274e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102753:	e9 c4 02 00 00       	jmp    102a1c <__alltraps>

00102758 <vector197>:
.globl vector197
vector197:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $197
  10275a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10275f:	e9 b8 02 00 00       	jmp    102a1c <__alltraps>

00102764 <vector198>:
.globl vector198
vector198:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $198
  102766:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10276b:	e9 ac 02 00 00       	jmp    102a1c <__alltraps>

00102770 <vector199>:
.globl vector199
vector199:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $199
  102772:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102777:	e9 a0 02 00 00       	jmp    102a1c <__alltraps>

0010277c <vector200>:
.globl vector200
vector200:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $200
  10277e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102783:	e9 94 02 00 00       	jmp    102a1c <__alltraps>

00102788 <vector201>:
.globl vector201
vector201:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $201
  10278a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10278f:	e9 88 02 00 00       	jmp    102a1c <__alltraps>

00102794 <vector202>:
.globl vector202
vector202:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $202
  102796:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10279b:	e9 7c 02 00 00       	jmp    102a1c <__alltraps>

001027a0 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $203
  1027a2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027a7:	e9 70 02 00 00       	jmp    102a1c <__alltraps>

001027ac <vector204>:
.globl vector204
vector204:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $204
  1027ae:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027b3:	e9 64 02 00 00       	jmp    102a1c <__alltraps>

001027b8 <vector205>:
.globl vector205
vector205:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $205
  1027ba:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027bf:	e9 58 02 00 00       	jmp    102a1c <__alltraps>

001027c4 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $206
  1027c6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027cb:	e9 4c 02 00 00       	jmp    102a1c <__alltraps>

001027d0 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $207
  1027d2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027d7:	e9 40 02 00 00       	jmp    102a1c <__alltraps>

001027dc <vector208>:
.globl vector208
vector208:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $208
  1027de:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027e3:	e9 34 02 00 00       	jmp    102a1c <__alltraps>

001027e8 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $209
  1027ea:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027ef:	e9 28 02 00 00       	jmp    102a1c <__alltraps>

001027f4 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $210
  1027f6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027fb:	e9 1c 02 00 00       	jmp    102a1c <__alltraps>

00102800 <vector211>:
.globl vector211
vector211:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $211
  102802:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102807:	e9 10 02 00 00       	jmp    102a1c <__alltraps>

0010280c <vector212>:
.globl vector212
vector212:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $212
  10280e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102813:	e9 04 02 00 00       	jmp    102a1c <__alltraps>

00102818 <vector213>:
.globl vector213
vector213:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $213
  10281a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10281f:	e9 f8 01 00 00       	jmp    102a1c <__alltraps>

00102824 <vector214>:
.globl vector214
vector214:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $214
  102826:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10282b:	e9 ec 01 00 00       	jmp    102a1c <__alltraps>

00102830 <vector215>:
.globl vector215
vector215:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $215
  102832:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102837:	e9 e0 01 00 00       	jmp    102a1c <__alltraps>

0010283c <vector216>:
.globl vector216
vector216:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $216
  10283e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102843:	e9 d4 01 00 00       	jmp    102a1c <__alltraps>

00102848 <vector217>:
.globl vector217
vector217:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $217
  10284a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10284f:	e9 c8 01 00 00       	jmp    102a1c <__alltraps>

00102854 <vector218>:
.globl vector218
vector218:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $218
  102856:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10285b:	e9 bc 01 00 00       	jmp    102a1c <__alltraps>

00102860 <vector219>:
.globl vector219
vector219:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $219
  102862:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102867:	e9 b0 01 00 00       	jmp    102a1c <__alltraps>

0010286c <vector220>:
.globl vector220
vector220:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $220
  10286e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102873:	e9 a4 01 00 00       	jmp    102a1c <__alltraps>

00102878 <vector221>:
.globl vector221
vector221:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $221
  10287a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10287f:	e9 98 01 00 00       	jmp    102a1c <__alltraps>

00102884 <vector222>:
.globl vector222
vector222:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $222
  102886:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10288b:	e9 8c 01 00 00       	jmp    102a1c <__alltraps>

00102890 <vector223>:
.globl vector223
vector223:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $223
  102892:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102897:	e9 80 01 00 00       	jmp    102a1c <__alltraps>

0010289c <vector224>:
.globl vector224
vector224:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $224
  10289e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028a3:	e9 74 01 00 00       	jmp    102a1c <__alltraps>

001028a8 <vector225>:
.globl vector225
vector225:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $225
  1028aa:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028af:	e9 68 01 00 00       	jmp    102a1c <__alltraps>

001028b4 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $226
  1028b6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028bb:	e9 5c 01 00 00       	jmp    102a1c <__alltraps>

001028c0 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $227
  1028c2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028c7:	e9 50 01 00 00       	jmp    102a1c <__alltraps>

001028cc <vector228>:
.globl vector228
vector228:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $228
  1028ce:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028d3:	e9 44 01 00 00       	jmp    102a1c <__alltraps>

001028d8 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $229
  1028da:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028df:	e9 38 01 00 00       	jmp    102a1c <__alltraps>

001028e4 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $230
  1028e6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028eb:	e9 2c 01 00 00       	jmp    102a1c <__alltraps>

001028f0 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $231
  1028f2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028f7:	e9 20 01 00 00       	jmp    102a1c <__alltraps>

001028fc <vector232>:
.globl vector232
vector232:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $232
  1028fe:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102903:	e9 14 01 00 00       	jmp    102a1c <__alltraps>

00102908 <vector233>:
.globl vector233
vector233:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $233
  10290a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10290f:	e9 08 01 00 00       	jmp    102a1c <__alltraps>

00102914 <vector234>:
.globl vector234
vector234:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $234
  102916:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10291b:	e9 fc 00 00 00       	jmp    102a1c <__alltraps>

00102920 <vector235>:
.globl vector235
vector235:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $235
  102922:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102927:	e9 f0 00 00 00       	jmp    102a1c <__alltraps>

0010292c <vector236>:
.globl vector236
vector236:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $236
  10292e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102933:	e9 e4 00 00 00       	jmp    102a1c <__alltraps>

00102938 <vector237>:
.globl vector237
vector237:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $237
  10293a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10293f:	e9 d8 00 00 00       	jmp    102a1c <__alltraps>

00102944 <vector238>:
.globl vector238
vector238:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $238
  102946:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10294b:	e9 cc 00 00 00       	jmp    102a1c <__alltraps>

00102950 <vector239>:
.globl vector239
vector239:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $239
  102952:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102957:	e9 c0 00 00 00       	jmp    102a1c <__alltraps>

0010295c <vector240>:
.globl vector240
vector240:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $240
  10295e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102963:	e9 b4 00 00 00       	jmp    102a1c <__alltraps>

00102968 <vector241>:
.globl vector241
vector241:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $241
  10296a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10296f:	e9 a8 00 00 00       	jmp    102a1c <__alltraps>

00102974 <vector242>:
.globl vector242
vector242:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $242
  102976:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10297b:	e9 9c 00 00 00       	jmp    102a1c <__alltraps>

00102980 <vector243>:
.globl vector243
vector243:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $243
  102982:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102987:	e9 90 00 00 00       	jmp    102a1c <__alltraps>

0010298c <vector244>:
.globl vector244
vector244:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $244
  10298e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102993:	e9 84 00 00 00       	jmp    102a1c <__alltraps>

00102998 <vector245>:
.globl vector245
vector245:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $245
  10299a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10299f:	e9 78 00 00 00       	jmp    102a1c <__alltraps>

001029a4 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $246
  1029a6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029ab:	e9 6c 00 00 00       	jmp    102a1c <__alltraps>

001029b0 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029b0:	6a 00                	push   $0x0
  pushl $247
  1029b2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029b7:	e9 60 00 00 00       	jmp    102a1c <__alltraps>

001029bc <vector248>:
.globl vector248
vector248:
  pushl $0
  1029bc:	6a 00                	push   $0x0
  pushl $248
  1029be:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029c3:	e9 54 00 00 00       	jmp    102a1c <__alltraps>

001029c8 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029c8:	6a 00                	push   $0x0
  pushl $249
  1029ca:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029cf:	e9 48 00 00 00       	jmp    102a1c <__alltraps>

001029d4 <vector250>:
.globl vector250
vector250:
  pushl $0
  1029d4:	6a 00                	push   $0x0
  pushl $250
  1029d6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029db:	e9 3c 00 00 00       	jmp    102a1c <__alltraps>

001029e0 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029e0:	6a 00                	push   $0x0
  pushl $251
  1029e2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029e7:	e9 30 00 00 00       	jmp    102a1c <__alltraps>

001029ec <vector252>:
.globl vector252
vector252:
  pushl $0
  1029ec:	6a 00                	push   $0x0
  pushl $252
  1029ee:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029f3:	e9 24 00 00 00       	jmp    102a1c <__alltraps>

001029f8 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029f8:	6a 00                	push   $0x0
  pushl $253
  1029fa:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029ff:	e9 18 00 00 00       	jmp    102a1c <__alltraps>

00102a04 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a04:	6a 00                	push   $0x0
  pushl $254
  102a06:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a0b:	e9 0c 00 00 00       	jmp    102a1c <__alltraps>

00102a10 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a10:	6a 00                	push   $0x0
  pushl $255
  102a12:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a17:	e9 00 00 00 00       	jmp    102a1c <__alltraps>

00102a1c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a1c:	1e                   	push   %ds
    pushl %es
  102a1d:	06                   	push   %es
    pushl %fs
  102a1e:	0f a0                	push   %fs
    pushl %gs
  102a20:	0f a8                	push   %gs
    pushal
  102a22:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a23:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a28:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a2a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a2c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a2d:	e8 64 f5 ff ff       	call   101f96 <trap>

    # pop the pushed stack pointer
    popl %esp
  102a32:	5c                   	pop    %esp

00102a33 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a33:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a34:	0f a9                	pop    %gs
    popl %fs
  102a36:	0f a1                	pop    %fs
    popl %es
  102a38:	07                   	pop    %es
    popl %ds
  102a39:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a3a:	83 c4 08             	add    $0x8,%esp
    iret
  102a3d:	cf                   	iret   

00102a3e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a3e:	55                   	push   %ebp
  102a3f:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a41:	8b 45 08             	mov    0x8(%ebp),%eax
  102a44:	8b 15 78 df 11 00    	mov    0x11df78,%edx
  102a4a:	29 d0                	sub    %edx,%eax
  102a4c:	c1 f8 02             	sar    $0x2,%eax
  102a4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a55:	5d                   	pop    %ebp
  102a56:	c3                   	ret    

00102a57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a57:	55                   	push   %ebp
  102a58:	89 e5                	mov    %esp,%ebp
  102a5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a60:	89 04 24             	mov    %eax,(%esp)
  102a63:	e8 d6 ff ff ff       	call   102a3e <page2ppn>
  102a68:	c1 e0 0c             	shl    $0xc,%eax
}
  102a6b:	c9                   	leave  
  102a6c:	c3                   	ret    

00102a6d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102a6d:	55                   	push   %ebp
  102a6e:	89 e5                	mov    %esp,%ebp
  102a70:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102a73:	8b 45 08             	mov    0x8(%ebp),%eax
  102a76:	c1 e8 0c             	shr    $0xc,%eax
  102a79:	89 c2                	mov    %eax,%edx
  102a7b:	a1 80 de 11 00       	mov    0x11de80,%eax
  102a80:	39 c2                	cmp    %eax,%edx
  102a82:	72 1c                	jb     102aa0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102a84:	c7 44 24 08 70 76 10 	movl   $0x107670,0x8(%esp)
  102a8b:	00 
  102a8c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a93:	00 
  102a94:	c7 04 24 8f 76 10 00 	movl   $0x10768f,(%esp)
  102a9b:	e8 59 d9 ff ff       	call   1003f9 <__panic>
    }
    return &pages[PPN(pa)];
  102aa0:	8b 0d 78 df 11 00    	mov    0x11df78,%ecx
  102aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa9:	c1 e8 0c             	shr    $0xc,%eax
  102aac:	89 c2                	mov    %eax,%edx
  102aae:	89 d0                	mov    %edx,%eax
  102ab0:	c1 e0 02             	shl    $0x2,%eax
  102ab3:	01 d0                	add    %edx,%eax
  102ab5:	c1 e0 02             	shl    $0x2,%eax
  102ab8:	01 c8                	add    %ecx,%eax
}
  102aba:	c9                   	leave  
  102abb:	c3                   	ret    

00102abc <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102abc:	55                   	push   %ebp
  102abd:	89 e5                	mov    %esp,%ebp
  102abf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac5:	89 04 24             	mov    %eax,(%esp)
  102ac8:	e8 8a ff ff ff       	call   102a57 <page2pa>
  102acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ad3:	c1 e8 0c             	shr    $0xc,%eax
  102ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ad9:	a1 80 de 11 00       	mov    0x11de80,%eax
  102ade:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102ae1:	72 23                	jb     102b06 <page2kva+0x4a>
  102ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102aea:	c7 44 24 08 a0 76 10 	movl   $0x1076a0,0x8(%esp)
  102af1:	00 
  102af2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102af9:	00 
  102afa:	c7 04 24 8f 76 10 00 	movl   $0x10768f,(%esp)
  102b01:	e8 f3 d8 ff ff       	call   1003f9 <__panic>
  102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b09:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102b0e:	c9                   	leave  
  102b0f:	c3                   	ret    

00102b10 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102b10:	55                   	push   %ebp
  102b11:	89 e5                	mov    %esp,%ebp
  102b13:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102b16:	8b 45 08             	mov    0x8(%ebp),%eax
  102b19:	83 e0 01             	and    $0x1,%eax
  102b1c:	85 c0                	test   %eax,%eax
  102b1e:	75 1c                	jne    102b3c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102b20:	c7 44 24 08 c4 76 10 	movl   $0x1076c4,0x8(%esp)
  102b27:	00 
  102b28:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102b2f:	00 
  102b30:	c7 04 24 8f 76 10 00 	movl   $0x10768f,(%esp)
  102b37:	e8 bd d8 ff ff       	call   1003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b44:	89 04 24             	mov    %eax,(%esp)
  102b47:	e8 21 ff ff ff       	call   102a6d <pa2page>
}
  102b4c:	c9                   	leave  
  102b4d:	c3                   	ret    

00102b4e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102b4e:	55                   	push   %ebp
  102b4f:	89 e5                	mov    %esp,%ebp
  102b51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102b54:	8b 45 08             	mov    0x8(%ebp),%eax
  102b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b5c:	89 04 24             	mov    %eax,(%esp)
  102b5f:	e8 09 ff ff ff       	call   102a6d <pa2page>
}
  102b64:	c9                   	leave  
  102b65:	c3                   	ret    

00102b66 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102b66:	55                   	push   %ebp
  102b67:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b69:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6c:	8b 00                	mov    (%eax),%eax
}
  102b6e:	5d                   	pop    %ebp
  102b6f:	c3                   	ret    

00102b70 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102b70:	55                   	push   %ebp
  102b71:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102b73:	8b 45 08             	mov    0x8(%ebp),%eax
  102b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b79:	89 10                	mov    %edx,(%eax)
}
  102b7b:	90                   	nop
  102b7c:	5d                   	pop    %ebp
  102b7d:	c3                   	ret    

00102b7e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102b7e:	55                   	push   %ebp
  102b7f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102b81:	8b 45 08             	mov    0x8(%ebp),%eax
  102b84:	8b 00                	mov    (%eax),%eax
  102b86:	8d 50 01             	lea    0x1(%eax),%edx
  102b89:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b91:	8b 00                	mov    (%eax),%eax
}
  102b93:	5d                   	pop    %ebp
  102b94:	c3                   	ret    

00102b95 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b95:	55                   	push   %ebp
  102b96:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	8b 00                	mov    (%eax),%eax
  102b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba8:	8b 00                	mov    (%eax),%eax
}
  102baa:	5d                   	pop    %ebp
  102bab:	c3                   	ret    

00102bac <__intr_save>:
__intr_save(void) {
  102bac:	55                   	push   %ebp
  102bad:	89 e5                	mov    %esp,%ebp
  102baf:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102bb2:	9c                   	pushf  
  102bb3:	58                   	pop    %eax
  102bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102bba:	25 00 02 00 00       	and    $0x200,%eax
  102bbf:	85 c0                	test   %eax,%eax
  102bc1:	74 0c                	je     102bcf <__intr_save+0x23>
        intr_disable();
  102bc3:	e8 d5 ec ff ff       	call   10189d <intr_disable>
        return 1;
  102bc8:	b8 01 00 00 00       	mov    $0x1,%eax
  102bcd:	eb 05                	jmp    102bd4 <__intr_save+0x28>
    return 0;
  102bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bd4:	c9                   	leave  
  102bd5:	c3                   	ret    

00102bd6 <__intr_restore>:
__intr_restore(bool flag) {
  102bd6:	55                   	push   %ebp
  102bd7:	89 e5                	mov    %esp,%ebp
  102bd9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102be0:	74 05                	je     102be7 <__intr_restore+0x11>
        intr_enable();
  102be2:	e8 af ec ff ff       	call   101896 <intr_enable>
}
  102be7:	90                   	nop
  102be8:	c9                   	leave  
  102be9:	c3                   	ret    

00102bea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102bea:	55                   	push   %ebp
  102beb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102bed:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102bf3:	b8 23 00 00 00       	mov    $0x23,%eax
  102bf8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102bfa:	b8 23 00 00 00       	mov    $0x23,%eax
  102bff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102c01:	b8 10 00 00 00       	mov    $0x10,%eax
  102c06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c08:	b8 10 00 00 00       	mov    $0x10,%eax
  102c0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c0f:	b8 10 00 00 00       	mov    $0x10,%eax
  102c14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102c16:	ea 1d 2c 10 00 08 00 	ljmp   $0x8,$0x102c1d
}
  102c1d:	90                   	nop
  102c1e:	5d                   	pop    %ebp
  102c1f:	c3                   	ret    

00102c20 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102c20:	55                   	push   %ebp
  102c21:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102c23:	8b 45 08             	mov    0x8(%ebp),%eax
  102c26:	a3 a4 de 11 00       	mov    %eax,0x11dea4
}
  102c2b:	90                   	nop
  102c2c:	5d                   	pop    %ebp
  102c2d:	c3                   	ret    

00102c2e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102c2e:	55                   	push   %ebp
  102c2f:	89 e5                	mov    %esp,%ebp
  102c31:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102c34:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  102c39:	89 04 24             	mov    %eax,(%esp)
  102c3c:	e8 df ff ff ff       	call   102c20 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102c41:	66 c7 05 a8 de 11 00 	movw   $0x10,0x11dea8
  102c48:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102c4a:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  102c51:	68 00 
  102c53:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  102c58:	0f b7 c0             	movzwl %ax,%eax
  102c5b:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  102c61:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  102c66:	c1 e8 10             	shr    $0x10,%eax
  102c69:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  102c6e:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102c75:	24 f0                	and    $0xf0,%al
  102c77:	0c 09                	or     $0x9,%al
  102c79:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102c7e:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102c85:	24 ef                	and    $0xef,%al
  102c87:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102c8c:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102c93:	24 9f                	and    $0x9f,%al
  102c95:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102c9a:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102ca1:	0c 80                	or     $0x80,%al
  102ca3:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102ca8:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102caf:	24 f0                	and    $0xf0,%al
  102cb1:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102cb6:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102cbd:	24 ef                	and    $0xef,%al
  102cbf:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102cc4:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102ccb:	24 df                	and    $0xdf,%al
  102ccd:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102cd2:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102cd9:	0c 40                	or     $0x40,%al
  102cdb:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102ce0:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102ce7:	24 7f                	and    $0x7f,%al
  102ce9:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102cee:	b8 a0 de 11 00       	mov    $0x11dea0,%eax
  102cf3:	c1 e8 18             	shr    $0x18,%eax
  102cf6:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102cfb:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
  102d02:	e8 e3 fe ff ff       	call   102bea <lgdt>
  102d07:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102d0d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102d11:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102d14:	90                   	nop
  102d15:	c9                   	leave  
  102d16:	c3                   	ret    

00102d17 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102d17:	55                   	push   %ebp
  102d18:	89 e5                	mov    %esp,%ebp
  102d1a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
  102d1d:	c7 05 70 df 11 00 40 	movl   $0x107e40,0x11df70
  102d24:	7e 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102d27:	a1 70 df 11 00       	mov    0x11df70,%eax
  102d2c:	8b 00                	mov    (%eax),%eax
  102d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d32:	c7 04 24 f0 76 10 00 	movl   $0x1076f0,(%esp)
  102d39:	e8 64 d5 ff ff       	call   1002a2 <cprintf>
    pmm_manager->init();
  102d3e:	a1 70 df 11 00       	mov    0x11df70,%eax
  102d43:	8b 40 04             	mov    0x4(%eax),%eax
  102d46:	ff d0                	call   *%eax
}
  102d48:	90                   	nop
  102d49:	c9                   	leave  
  102d4a:	c3                   	ret    

00102d4b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102d4b:	55                   	push   %ebp
  102d4c:	89 e5                	mov    %esp,%ebp
  102d4e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102d51:	a1 70 df 11 00       	mov    0x11df70,%eax
  102d56:	8b 40 08             	mov    0x8(%eax),%eax
  102d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d60:	8b 55 08             	mov    0x8(%ebp),%edx
  102d63:	89 14 24             	mov    %edx,(%esp)
  102d66:	ff d0                	call   *%eax
}
  102d68:	90                   	nop
  102d69:	c9                   	leave  
  102d6a:	c3                   	ret    

00102d6b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102d6b:	55                   	push   %ebp
  102d6c:	89 e5                	mov    %esp,%ebp
  102d6e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102d78:	e8 2f fe ff ff       	call   102bac <__intr_save>
  102d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102d80:	a1 70 df 11 00       	mov    0x11df70,%eax
  102d85:	8b 40 0c             	mov    0xc(%eax),%eax
  102d88:	8b 55 08             	mov    0x8(%ebp),%edx
  102d8b:	89 14 24             	mov    %edx,(%esp)
  102d8e:	ff d0                	call   *%eax
  102d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d96:	89 04 24             	mov    %eax,(%esp)
  102d99:	e8 38 fe ff ff       	call   102bd6 <__intr_restore>
    return page;
  102d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102da1:	c9                   	leave  
  102da2:	c3                   	ret    

00102da3 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102da3:	55                   	push   %ebp
  102da4:	89 e5                	mov    %esp,%ebp
  102da6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102da9:	e8 fe fd ff ff       	call   102bac <__intr_save>
  102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102db1:	a1 70 df 11 00       	mov    0x11df70,%eax
  102db6:	8b 40 10             	mov    0x10(%eax),%eax
  102db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  102dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc3:	89 14 24             	mov    %edx,(%esp)
  102dc6:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dcb:	89 04 24             	mov    %eax,(%esp)
  102dce:	e8 03 fe ff ff       	call   102bd6 <__intr_restore>
}
  102dd3:	90                   	nop
  102dd4:	c9                   	leave  
  102dd5:	c3                   	ret    

00102dd6 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102dd6:	55                   	push   %ebp
  102dd7:	89 e5                	mov    %esp,%ebp
  102dd9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102ddc:	e8 cb fd ff ff       	call   102bac <__intr_save>
  102de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102de4:	a1 70 df 11 00       	mov    0x11df70,%eax
  102de9:	8b 40 14             	mov    0x14(%eax),%eax
  102dec:	ff d0                	call   *%eax
  102dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df4:	89 04 24             	mov    %eax,(%esp)
  102df7:	e8 da fd ff ff       	call   102bd6 <__intr_restore>
    return ret;
  102dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102dff:	c9                   	leave  
  102e00:	c3                   	ret    

00102e01 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102e01:	55                   	push   %ebp
  102e02:	89 e5                	mov    %esp,%ebp
  102e04:	57                   	push   %edi
  102e05:	56                   	push   %esi
  102e06:	53                   	push   %ebx
  102e07:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102e0d:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102e14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102e1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102e22:	c7 04 24 07 77 10 00 	movl   $0x107707,(%esp)
  102e29:	e8 74 d4 ff ff       	call   1002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102e2e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e35:	e9 22 01 00 00       	jmp    102f5c <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e40:	89 d0                	mov    %edx,%eax
  102e42:	c1 e0 02             	shl    $0x2,%eax
  102e45:	01 d0                	add    %edx,%eax
  102e47:	c1 e0 02             	shl    $0x2,%eax
  102e4a:	01 c8                	add    %ecx,%eax
  102e4c:	8b 50 08             	mov    0x8(%eax),%edx
  102e4f:	8b 40 04             	mov    0x4(%eax),%eax
  102e52:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102e55:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e58:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e5e:	89 d0                	mov    %edx,%eax
  102e60:	c1 e0 02             	shl    $0x2,%eax
  102e63:	01 d0                	add    %edx,%eax
  102e65:	c1 e0 02             	shl    $0x2,%eax
  102e68:	01 c8                	add    %ecx,%eax
  102e6a:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e6d:	8b 58 10             	mov    0x10(%eax),%ebx
  102e70:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e73:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e76:	01 c8                	add    %ecx,%eax
  102e78:	11 da                	adc    %ebx,%edx
  102e7a:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e7d:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102e80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e83:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e86:	89 d0                	mov    %edx,%eax
  102e88:	c1 e0 02             	shl    $0x2,%eax
  102e8b:	01 d0                	add    %edx,%eax
  102e8d:	c1 e0 02             	shl    $0x2,%eax
  102e90:	01 c8                	add    %ecx,%eax
  102e92:	83 c0 14             	add    $0x14,%eax
  102e95:	8b 00                	mov    (%eax),%eax
  102e97:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102e9a:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e9d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102ea0:	83 c0 ff             	add    $0xffffffff,%eax
  102ea3:	83 d2 ff             	adc    $0xffffffff,%edx
  102ea6:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102eac:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102eb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eb8:	89 d0                	mov    %edx,%eax
  102eba:	c1 e0 02             	shl    $0x2,%eax
  102ebd:	01 d0                	add    %edx,%eax
  102ebf:	c1 e0 02             	shl    $0x2,%eax
  102ec2:	01 c8                	add    %ecx,%eax
  102ec4:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ec7:	8b 58 10             	mov    0x10(%eax),%ebx
  102eca:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102ecd:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102ed1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102ed7:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102edd:	89 44 24 14          	mov    %eax,0x14(%esp)
  102ee1:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ee5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ee8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102eef:	89 54 24 10          	mov    %edx,0x10(%esp)
  102ef3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102ef7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102efb:	c7 04 24 14 77 10 00 	movl   $0x107714,(%esp)
  102f02:	e8 9b d3 ff ff       	call   1002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102f07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f0d:	89 d0                	mov    %edx,%eax
  102f0f:	c1 e0 02             	shl    $0x2,%eax
  102f12:	01 d0                	add    %edx,%eax
  102f14:	c1 e0 02             	shl    $0x2,%eax
  102f17:	01 c8                	add    %ecx,%eax
  102f19:	83 c0 14             	add    $0x14,%eax
  102f1c:	8b 00                	mov    (%eax),%eax
  102f1e:	83 f8 01             	cmp    $0x1,%eax
  102f21:	75 36                	jne    102f59 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  102f23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f29:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102f2c:	77 2b                	ja     102f59 <page_init+0x158>
  102f2e:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102f31:	72 05                	jb     102f38 <page_init+0x137>
  102f33:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102f36:	73 21                	jae    102f59 <page_init+0x158>
  102f38:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102f3c:	77 1b                	ja     102f59 <page_init+0x158>
  102f3e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102f42:	72 09                	jb     102f4d <page_init+0x14c>
  102f44:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  102f4b:	77 0c                	ja     102f59 <page_init+0x158>
                maxpa = end;
  102f4d:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f50:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102f53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102f59:	ff 45 dc             	incl   -0x24(%ebp)
  102f5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f5f:	8b 00                	mov    (%eax),%eax
  102f61:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102f64:	0f 8c d0 fe ff ff    	jl     102e3a <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102f6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f6e:	72 1d                	jb     102f8d <page_init+0x18c>
  102f70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f74:	77 09                	ja     102f7f <page_init+0x17e>
  102f76:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102f7d:	76 0e                	jbe    102f8d <page_init+0x18c>
        maxpa = KMEMSIZE;
  102f7f:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f93:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f97:	c1 ea 0c             	shr    $0xc,%edx
  102f9a:	89 c1                	mov    %eax,%ecx
  102f9c:	89 d3                	mov    %edx,%ebx
  102f9e:	89 c8                	mov    %ecx,%eax
  102fa0:	a3 80 de 11 00       	mov    %eax,0x11de80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102fa5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102fac:	b8 c0 49 2a 00       	mov    $0x2a49c0,%eax
  102fb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fb4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102fb7:	01 d0                	add    %edx,%eax
  102fb9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102fbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102fbf:	ba 00 00 00 00       	mov    $0x0,%edx
  102fc4:	f7 75 c0             	divl   -0x40(%ebp)
  102fc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102fca:	29 d0                	sub    %edx,%eax
  102fcc:	a3 78 df 11 00       	mov    %eax,0x11df78

    for (i = 0; i < npage; i ++) {
  102fd1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fd8:	eb 2e                	jmp    103008 <page_init+0x207>
        SetPageReserved(pages + i);
  102fda:	8b 0d 78 df 11 00    	mov    0x11df78,%ecx
  102fe0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe3:	89 d0                	mov    %edx,%eax
  102fe5:	c1 e0 02             	shl    $0x2,%eax
  102fe8:	01 d0                	add    %edx,%eax
  102fea:	c1 e0 02             	shl    $0x2,%eax
  102fed:	01 c8                	add    %ecx,%eax
  102fef:	83 c0 04             	add    $0x4,%eax
  102ff2:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102ff9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ffc:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fff:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103002:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  103005:	ff 45 dc             	incl   -0x24(%ebp)
  103008:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10300b:	a1 80 de 11 00       	mov    0x11de80,%eax
  103010:	39 c2                	cmp    %eax,%edx
  103012:	72 c6                	jb     102fda <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103014:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  10301a:	89 d0                	mov    %edx,%eax
  10301c:	c1 e0 02             	shl    $0x2,%eax
  10301f:	01 d0                	add    %edx,%eax
  103021:	c1 e0 02             	shl    $0x2,%eax
  103024:	89 c2                	mov    %eax,%edx
  103026:	a1 78 df 11 00       	mov    0x11df78,%eax
  10302b:	01 d0                	add    %edx,%eax
  10302d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103030:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103037:	77 23                	ja     10305c <page_init+0x25b>
  103039:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10303c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103040:	c7 44 24 08 44 77 10 	movl   $0x107744,0x8(%esp)
  103047:	00 
  103048:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10304f:	00 
  103050:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103057:	e8 9d d3 ff ff       	call   1003f9 <__panic>
  10305c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10305f:	05 00 00 00 40       	add    $0x40000000,%eax
  103064:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103067:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10306e:	e9 69 01 00 00       	jmp    1031dc <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103073:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103076:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103079:	89 d0                	mov    %edx,%eax
  10307b:	c1 e0 02             	shl    $0x2,%eax
  10307e:	01 d0                	add    %edx,%eax
  103080:	c1 e0 02             	shl    $0x2,%eax
  103083:	01 c8                	add    %ecx,%eax
  103085:	8b 50 08             	mov    0x8(%eax),%edx
  103088:	8b 40 04             	mov    0x4(%eax),%eax
  10308b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10308e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103091:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103094:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103097:	89 d0                	mov    %edx,%eax
  103099:	c1 e0 02             	shl    $0x2,%eax
  10309c:	01 d0                	add    %edx,%eax
  10309e:	c1 e0 02             	shl    $0x2,%eax
  1030a1:	01 c8                	add    %ecx,%eax
  1030a3:	8b 48 0c             	mov    0xc(%eax),%ecx
  1030a6:	8b 58 10             	mov    0x10(%eax),%ebx
  1030a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030af:	01 c8                	add    %ecx,%eax
  1030b1:	11 da                	adc    %ebx,%edx
  1030b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1030b6:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1030b9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030bf:	89 d0                	mov    %edx,%eax
  1030c1:	c1 e0 02             	shl    $0x2,%eax
  1030c4:	01 d0                	add    %edx,%eax
  1030c6:	c1 e0 02             	shl    $0x2,%eax
  1030c9:	01 c8                	add    %ecx,%eax
  1030cb:	83 c0 14             	add    $0x14,%eax
  1030ce:	8b 00                	mov    (%eax),%eax
  1030d0:	83 f8 01             	cmp    $0x1,%eax
  1030d3:	0f 85 00 01 00 00    	jne    1031d9 <page_init+0x3d8>
            if (begin < freemem) {
  1030d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1030e1:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1030e4:	77 17                	ja     1030fd <page_init+0x2fc>
  1030e6:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  1030e9:	72 05                	jb     1030f0 <page_init+0x2ef>
  1030eb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1030ee:	73 0d                	jae    1030fd <page_init+0x2fc>
                begin = freemem;
  1030f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1030f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030f6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1030fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103101:	72 1d                	jb     103120 <page_init+0x31f>
  103103:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103107:	77 09                	ja     103112 <page_init+0x311>
  103109:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103110:	76 0e                	jbe    103120 <page_init+0x31f>
                end = KMEMSIZE;
  103112:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103119:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103120:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103123:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103126:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103129:	0f 87 aa 00 00 00    	ja     1031d9 <page_init+0x3d8>
  10312f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103132:	72 09                	jb     10313d <page_init+0x33c>
  103134:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103137:	0f 83 9c 00 00 00    	jae    1031d9 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  10313d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103144:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103147:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10314a:	01 d0                	add    %edx,%eax
  10314c:	48                   	dec    %eax
  10314d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103150:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103153:	ba 00 00 00 00       	mov    $0x0,%edx
  103158:	f7 75 b0             	divl   -0x50(%ebp)
  10315b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10315e:	29 d0                	sub    %edx,%eax
  103160:	ba 00 00 00 00       	mov    $0x0,%edx
  103165:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103168:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10316b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10316e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103171:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103174:	ba 00 00 00 00       	mov    $0x0,%edx
  103179:	89 c3                	mov    %eax,%ebx
  10317b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103181:	89 de                	mov    %ebx,%esi
  103183:	89 d0                	mov    %edx,%eax
  103185:	83 e0 00             	and    $0x0,%eax
  103188:	89 c7                	mov    %eax,%edi
  10318a:	89 75 c8             	mov    %esi,-0x38(%ebp)
  10318d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103190:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103193:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103196:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103199:	77 3e                	ja     1031d9 <page_init+0x3d8>
  10319b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10319e:	72 05                	jb     1031a5 <page_init+0x3a4>
  1031a0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1031a3:	73 34                	jae    1031d9 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1031a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1031ab:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1031ae:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1031b1:	89 c1                	mov    %eax,%ecx
  1031b3:	89 d3                	mov    %edx,%ebx
  1031b5:	89 c8                	mov    %ecx,%eax
  1031b7:	89 da                	mov    %ebx,%edx
  1031b9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1031bd:	c1 ea 0c             	shr    $0xc,%edx
  1031c0:	89 c3                	mov    %eax,%ebx
  1031c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031c5:	89 04 24             	mov    %eax,(%esp)
  1031c8:	e8 a0 f8 ff ff       	call   102a6d <pa2page>
  1031cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1031d1:	89 04 24             	mov    %eax,(%esp)
  1031d4:	e8 72 fb ff ff       	call   102d4b <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1031d9:	ff 45 dc             	incl   -0x24(%ebp)
  1031dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1031df:	8b 00                	mov    (%eax),%eax
  1031e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1031e4:	0f 8c 89 fe ff ff    	jl     103073 <page_init+0x272>
                }
            }
        }
    }
}
  1031ea:	90                   	nop
  1031eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1031f1:	5b                   	pop    %ebx
  1031f2:	5e                   	pop    %esi
  1031f3:	5f                   	pop    %edi
  1031f4:	5d                   	pop    %ebp
  1031f5:	c3                   	ret    

001031f6 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1031f6:	55                   	push   %ebp
  1031f7:	89 e5                	mov    %esp,%ebp
  1031f9:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ff:	33 45 14             	xor    0x14(%ebp),%eax
  103202:	25 ff 0f 00 00       	and    $0xfff,%eax
  103207:	85 c0                	test   %eax,%eax
  103209:	74 24                	je     10322f <boot_map_segment+0x39>
  10320b:	c7 44 24 0c 76 77 10 	movl   $0x107776,0xc(%esp)
  103212:	00 
  103213:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  10321a:	00 
  10321b:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103222:	00 
  103223:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10322a:	e8 ca d1 ff ff       	call   1003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10322f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103236:	8b 45 0c             	mov    0xc(%ebp),%eax
  103239:	25 ff 0f 00 00       	and    $0xfff,%eax
  10323e:	89 c2                	mov    %eax,%edx
  103240:	8b 45 10             	mov    0x10(%ebp),%eax
  103243:	01 c2                	add    %eax,%edx
  103245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103248:	01 d0                	add    %edx,%eax
  10324a:	48                   	dec    %eax
  10324b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10324e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103251:	ba 00 00 00 00       	mov    $0x0,%edx
  103256:	f7 75 f0             	divl   -0x10(%ebp)
  103259:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10325c:	29 d0                	sub    %edx,%eax
  10325e:	c1 e8 0c             	shr    $0xc,%eax
  103261:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103264:	8b 45 0c             	mov    0xc(%ebp),%eax
  103267:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10326d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103272:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103275:	8b 45 14             	mov    0x14(%ebp),%eax
  103278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10327b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10327e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103283:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103286:	eb 68                	jmp    1032f0 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103288:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10328f:	00 
  103290:	8b 45 0c             	mov    0xc(%ebp),%eax
  103293:	89 44 24 04          	mov    %eax,0x4(%esp)
  103297:	8b 45 08             	mov    0x8(%ebp),%eax
  10329a:	89 04 24             	mov    %eax,(%esp)
  10329d:	e8 7c 01 00 00       	call   10341e <get_pte>
  1032a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1032a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1032a9:	75 24                	jne    1032cf <boot_map_segment+0xd9>
  1032ab:	c7 44 24 0c a2 77 10 	movl   $0x1077a2,0xc(%esp)
  1032b2:	00 
  1032b3:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1032ba:	00 
  1032bb:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1032c2:	00 
  1032c3:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1032ca:	e8 2a d1 ff ff       	call   1003f9 <__panic>
        *ptep = pa | PTE_P | perm;
  1032cf:	8b 45 14             	mov    0x14(%ebp),%eax
  1032d2:	0b 45 18             	or     0x18(%ebp),%eax
  1032d5:	83 c8 01             	or     $0x1,%eax
  1032d8:	89 c2                	mov    %eax,%edx
  1032da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032dd:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1032df:	ff 4d f4             	decl   -0xc(%ebp)
  1032e2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1032e9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1032f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032f4:	75 92                	jne    103288 <boot_map_segment+0x92>
    }
}
  1032f6:	90                   	nop
  1032f7:	c9                   	leave  
  1032f8:	c3                   	ret    

001032f9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1032f9:	55                   	push   %ebp
  1032fa:	89 e5                	mov    %esp,%ebp
  1032fc:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1032ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103306:	e8 60 fa ff ff       	call   102d6b <alloc_pages>
  10330b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10330e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103312:	75 1c                	jne    103330 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  103314:	c7 44 24 08 af 77 10 	movl   $0x1077af,0x8(%esp)
  10331b:	00 
  10331c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  103323:	00 
  103324:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10332b:	e8 c9 d0 ff ff       	call   1003f9 <__panic>
    }
    return page2kva(p);
  103330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103333:	89 04 24             	mov    %eax,(%esp)
  103336:	e8 81 f7 ff ff       	call   102abc <page2kva>
}
  10333b:	c9                   	leave  
  10333c:	c3                   	ret    

0010333d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10333d:	55                   	push   %ebp
  10333e:	89 e5                	mov    %esp,%ebp
  103340:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103343:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10334b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103352:	77 23                	ja     103377 <pmm_init+0x3a>
  103354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103357:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10335b:	c7 44 24 08 44 77 10 	movl   $0x107744,0x8(%esp)
  103362:	00 
  103363:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10336a:	00 
  10336b:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103372:	e8 82 d0 ff ff       	call   1003f9 <__panic>
  103377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10337a:	05 00 00 00 40       	add    $0x40000000,%eax
  10337f:	a3 74 df 11 00       	mov    %eax,0x11df74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103384:	e8 8e f9 ff ff       	call   102d17 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103389:	e8 73 fa ff ff       	call   102e01 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10338e:	e8 d9 03 00 00       	call   10376c <check_alloc_page>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103393:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103398:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10339b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1033a2:	77 23                	ja     1033c7 <pmm_init+0x8a>
  1033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033ab:	c7 44 24 08 44 77 10 	movl   $0x107744,0x8(%esp)
  1033b2:	00 
  1033b3:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1033ba:	00 
  1033bb:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1033c2:	e8 32 d0 ff ff       	call   1003f9 <__panic>
  1033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033ca:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1033d0:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1033d5:	05 ac 0f 00 00       	add    $0xfac,%eax
  1033da:	83 ca 03             	or     $0x3,%edx
  1033dd:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1033df:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1033e4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1033eb:	00 
  1033ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1033f3:	00 
  1033f4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1033fb:	38 
  1033fc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103403:	c0 
  103404:	89 04 24             	mov    %eax,(%esp)
  103407:	e8 ea fd ff ff       	call   1031f6 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10340c:	e8 1d f8 ff ff       	call   102c2e <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103411:	e8 11 0a 00 00       	call   103e27 <check_boot_pgdir>

    print_pgdir();
  103416:	e8 8a 0e 00 00       	call   1042a5 <print_pgdir>

}
  10341b:	90                   	nop
  10341c:	c9                   	leave  
  10341d:	c3                   	ret    

0010341e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10341e:	55                   	push   %ebp
  10341f:	89 e5                	mov    %esp,%ebp
  103421:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  103424:	8b 45 0c             	mov    0xc(%ebp),%eax
  103427:	c1 e8 16             	shr    $0x16,%eax
  10342a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103431:	8b 45 08             	mov    0x8(%ebp),%eax
  103434:	01 d0                	add    %edx,%eax
  103436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10343c:	8b 00                	mov    (%eax),%eax
  10343e:	83 e0 01             	and    $0x1,%eax
  103441:	85 c0                	test   %eax,%eax
  103443:	0f 85 af 00 00 00    	jne    1034f8 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  103449:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10344d:	74 15                	je     103464 <get_pte+0x46>
  10344f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103456:	e8 10 f9 ff ff       	call   102d6b <alloc_pages>
  10345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10345e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103462:	75 0a                	jne    10346e <get_pte+0x50>
            return NULL;
  103464:	b8 00 00 00 00       	mov    $0x0,%eax
  103469:	e9 e7 00 00 00       	jmp    103555 <get_pte+0x137>
        }
        set_page_ref(page, 1);
  10346e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103475:	00 
  103476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103479:	89 04 24             	mov    %eax,(%esp)
  10347c:	e8 ef f6 ff ff       	call   102b70 <set_page_ref>
        uintptr_t pa = page2pa(page);
  103481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103484:	89 04 24             	mov    %eax,(%esp)
  103487:	e8 cb f5 ff ff       	call   102a57 <page2pa>
  10348c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  10348f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103498:	c1 e8 0c             	shr    $0xc,%eax
  10349b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10349e:	a1 80 de 11 00       	mov    0x11de80,%eax
  1034a3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1034a6:	72 23                	jb     1034cb <get_pte+0xad>
  1034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034af:	c7 44 24 08 a0 76 10 	movl   $0x1076a0,0x8(%esp)
  1034b6:	00 
  1034b7:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
  1034be:	00 
  1034bf:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1034c6:	e8 2e cf ff ff       	call   1003f9 <__panic>
  1034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1034d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1034da:	00 
  1034db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1034e2:	00 
  1034e3:	89 04 24             	mov    %eax,(%esp)
  1034e6:	e8 3c 32 00 00       	call   106727 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1034eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ee:	83 c8 07             	or     $0x7,%eax
  1034f1:	89 c2                	mov    %eax,%edx
  1034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034f6:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034fb:	8b 00                	mov    (%eax),%eax
  1034fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103502:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103508:	c1 e8 0c             	shr    $0xc,%eax
  10350b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10350e:	a1 80 de 11 00       	mov    0x11de80,%eax
  103513:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103516:	72 23                	jb     10353b <get_pte+0x11d>
  103518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10351b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10351f:	c7 44 24 08 a0 76 10 	movl   $0x1076a0,0x8(%esp)
  103526:	00 
  103527:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
  10352e:	00 
  10352f:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103536:	e8 be ce ff ff       	call   1003f9 <__panic>
  10353b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10353e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103543:	89 c2                	mov    %eax,%edx
  103545:	8b 45 0c             	mov    0xc(%ebp),%eax
  103548:	c1 e8 0c             	shr    $0xc,%eax
  10354b:	25 ff 03 00 00       	and    $0x3ff,%eax
  103550:	c1 e0 02             	shl    $0x2,%eax
  103553:	01 d0                	add    %edx,%eax
}
  103555:	c9                   	leave  
  103556:	c3                   	ret    

00103557 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103557:	55                   	push   %ebp
  103558:	89 e5                	mov    %esp,%ebp
  10355a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10355d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103564:	00 
  103565:	8b 45 0c             	mov    0xc(%ebp),%eax
  103568:	89 44 24 04          	mov    %eax,0x4(%esp)
  10356c:	8b 45 08             	mov    0x8(%ebp),%eax
  10356f:	89 04 24             	mov    %eax,(%esp)
  103572:	e8 a7 fe ff ff       	call   10341e <get_pte>
  103577:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10357a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10357e:	74 08                	je     103588 <get_page+0x31>
        *ptep_store = ptep;
  103580:	8b 45 10             	mov    0x10(%ebp),%eax
  103583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103586:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10358c:	74 1b                	je     1035a9 <get_page+0x52>
  10358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103591:	8b 00                	mov    (%eax),%eax
  103593:	83 e0 01             	and    $0x1,%eax
  103596:	85 c0                	test   %eax,%eax
  103598:	74 0f                	je     1035a9 <get_page+0x52>
        return pte2page(*ptep);
  10359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10359d:	8b 00                	mov    (%eax),%eax
  10359f:	89 04 24             	mov    %eax,(%esp)
  1035a2:	e8 69 f5 ff ff       	call   102b10 <pte2page>
  1035a7:	eb 05                	jmp    1035ae <get_page+0x57>
    }
    return NULL;
  1035a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035ae:	c9                   	leave  
  1035af:	c3                   	ret    

001035b0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1035b0:	55                   	push   %ebp
  1035b1:	89 e5                	mov    %esp,%ebp
  1035b3:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1035b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b9:	8b 00                	mov    (%eax),%eax
  1035bb:	83 e0 01             	and    $0x1,%eax
  1035be:	85 c0                	test   %eax,%eax
  1035c0:	74 4d                	je     10360f <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  1035c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1035c5:	8b 00                	mov    (%eax),%eax
  1035c7:	89 04 24             	mov    %eax,(%esp)
  1035ca:	e8 41 f5 ff ff       	call   102b10 <pte2page>
  1035cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  1035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035d5:	89 04 24             	mov    %eax,(%esp)
  1035d8:	e8 b8 f5 ff ff       	call   102b95 <page_ref_dec>
  1035dd:	85 c0                	test   %eax,%eax
  1035df:	75 13                	jne    1035f4 <page_remove_pte+0x44>
            free_page(page);
  1035e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035e8:	00 
  1035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035ec:	89 04 24             	mov    %eax,(%esp)
  1035ef:	e8 af f7 ff ff       	call   102da3 <free_pages>
        }
        *ptep = 0;
  1035f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1035f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  1035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103600:	89 44 24 04          	mov    %eax,0x4(%esp)
  103604:	8b 45 08             	mov    0x8(%ebp),%eax
  103607:	89 04 24             	mov    %eax,(%esp)
  10360a:	e8 01 01 00 00       	call   103710 <tlb_invalidate>
    }
}
  10360f:	90                   	nop
  103610:	c9                   	leave  
  103611:	c3                   	ret    

00103612 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103612:	55                   	push   %ebp
  103613:	89 e5                	mov    %esp,%ebp
  103615:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103618:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10361f:	00 
  103620:	8b 45 0c             	mov    0xc(%ebp),%eax
  103623:	89 44 24 04          	mov    %eax,0x4(%esp)
  103627:	8b 45 08             	mov    0x8(%ebp),%eax
  10362a:	89 04 24             	mov    %eax,(%esp)
  10362d:	e8 ec fd ff ff       	call   10341e <get_pte>
  103632:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103639:	74 19                	je     103654 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10363e:	89 44 24 08          	mov    %eax,0x8(%esp)
  103642:	8b 45 0c             	mov    0xc(%ebp),%eax
  103645:	89 44 24 04          	mov    %eax,0x4(%esp)
  103649:	8b 45 08             	mov    0x8(%ebp),%eax
  10364c:	89 04 24             	mov    %eax,(%esp)
  10364f:	e8 5c ff ff ff       	call   1035b0 <page_remove_pte>
    }
}
  103654:	90                   	nop
  103655:	c9                   	leave  
  103656:	c3                   	ret    

00103657 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103657:	55                   	push   %ebp
  103658:	89 e5                	mov    %esp,%ebp
  10365a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10365d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103664:	00 
  103665:	8b 45 10             	mov    0x10(%ebp),%eax
  103668:	89 44 24 04          	mov    %eax,0x4(%esp)
  10366c:	8b 45 08             	mov    0x8(%ebp),%eax
  10366f:	89 04 24             	mov    %eax,(%esp)
  103672:	e8 a7 fd ff ff       	call   10341e <get_pte>
  103677:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10367e:	75 0a                	jne    10368a <page_insert+0x33>
        return -E_NO_MEM;
  103680:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103685:	e9 84 00 00 00       	jmp    10370e <page_insert+0xb7>
    }
    page_ref_inc(page);
  10368a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10368d:	89 04 24             	mov    %eax,(%esp)
  103690:	e8 e9 f4 ff ff       	call   102b7e <page_ref_inc>
    if (*ptep & PTE_P) {
  103695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103698:	8b 00                	mov    (%eax),%eax
  10369a:	83 e0 01             	and    $0x1,%eax
  10369d:	85 c0                	test   %eax,%eax
  10369f:	74 3e                	je     1036df <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a4:	8b 00                	mov    (%eax),%eax
  1036a6:	89 04 24             	mov    %eax,(%esp)
  1036a9:	e8 62 f4 ff ff       	call   102b10 <pte2page>
  1036ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1036b7:	75 0d                	jne    1036c6 <page_insert+0x6f>
            page_ref_dec(page);
  1036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036bc:	89 04 24             	mov    %eax,(%esp)
  1036bf:	e8 d1 f4 ff ff       	call   102b95 <page_ref_dec>
  1036c4:	eb 19                	jmp    1036df <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1036c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d7:	89 04 24             	mov    %eax,(%esp)
  1036da:	e8 d1 fe ff ff       	call   1035b0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1036df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e2:	89 04 24             	mov    %eax,(%esp)
  1036e5:	e8 6d f3 ff ff       	call   102a57 <page2pa>
  1036ea:	0b 45 14             	or     0x14(%ebp),%eax
  1036ed:	83 c8 01             	or     $0x1,%eax
  1036f0:	89 c2                	mov    %eax,%edx
  1036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1036f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1036fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103701:	89 04 24             	mov    %eax,(%esp)
  103704:	e8 07 00 00 00       	call   103710 <tlb_invalidate>
    return 0;
  103709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10370e:	c9                   	leave  
  10370f:	c3                   	ret    

00103710 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103710:	55                   	push   %ebp
  103711:	89 e5                	mov    %esp,%ebp
  103713:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103716:	0f 20 d8             	mov    %cr3,%eax
  103719:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10371c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10371f:	8b 45 08             	mov    0x8(%ebp),%eax
  103722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103725:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10372c:	77 23                	ja     103751 <tlb_invalidate+0x41>
  10372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103731:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103735:	c7 44 24 08 44 77 10 	movl   $0x107744,0x8(%esp)
  10373c:	00 
  10373d:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  103744:	00 
  103745:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10374c:	e8 a8 cc ff ff       	call   1003f9 <__panic>
  103751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103754:	05 00 00 00 40       	add    $0x40000000,%eax
  103759:	39 d0                	cmp    %edx,%eax
  10375b:	75 0c                	jne    103769 <tlb_invalidate+0x59>
        invlpg((void *)la);
  10375d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103760:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103766:	0f 01 38             	invlpg (%eax)
    }
}
  103769:	90                   	nop
  10376a:	c9                   	leave  
  10376b:	c3                   	ret    

0010376c <check_alloc_page>:

static void
check_alloc_page(void) {
  10376c:	55                   	push   %ebp
  10376d:	89 e5                	mov    %esp,%ebp
  10376f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103772:	a1 70 df 11 00       	mov    0x11df70,%eax
  103777:	8b 40 18             	mov    0x18(%eax),%eax
  10377a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10377c:	c7 04 24 c8 77 10 00 	movl   $0x1077c8,(%esp)
  103783:	e8 1a cb ff ff       	call   1002a2 <cprintf>
}
  103788:	90                   	nop
  103789:	c9                   	leave  
  10378a:	c3                   	ret    

0010378b <check_pgdir>:

static void
check_pgdir(void) {
  10378b:	55                   	push   %ebp
  10378c:	89 e5                	mov    %esp,%ebp
  10378e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103791:	a1 80 de 11 00       	mov    0x11de80,%eax
  103796:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10379b:	76 24                	jbe    1037c1 <check_pgdir+0x36>
  10379d:	c7 44 24 0c e7 77 10 	movl   $0x1077e7,0xc(%esp)
  1037a4:	00 
  1037a5:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1037ac:	00 
  1037ad:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1037b4:	00 
  1037b5:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1037bc:	e8 38 cc ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1037c1:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1037c6:	85 c0                	test   %eax,%eax
  1037c8:	74 0e                	je     1037d8 <check_pgdir+0x4d>
  1037ca:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1037cf:	25 ff 0f 00 00       	and    $0xfff,%eax
  1037d4:	85 c0                	test   %eax,%eax
  1037d6:	74 24                	je     1037fc <check_pgdir+0x71>
  1037d8:	c7 44 24 0c 04 78 10 	movl   $0x107804,0xc(%esp)
  1037df:	00 
  1037e0:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1037e7:	00 
  1037e8:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1037ef:	00 
  1037f0:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1037f7:	e8 fd cb ff ff       	call   1003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1037fc:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103801:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103808:	00 
  103809:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103810:	00 
  103811:	89 04 24             	mov    %eax,(%esp)
  103814:	e8 3e fd ff ff       	call   103557 <get_page>
  103819:	85 c0                	test   %eax,%eax
  10381b:	74 24                	je     103841 <check_pgdir+0xb6>
  10381d:	c7 44 24 0c 3c 78 10 	movl   $0x10783c,0xc(%esp)
  103824:	00 
  103825:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  10382c:	00 
  10382d:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  103834:	00 
  103835:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10383c:	e8 b8 cb ff ff       	call   1003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103841:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103848:	e8 1e f5 ff ff       	call   102d6b <alloc_pages>
  10384d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103850:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103855:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10385c:	00 
  10385d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103864:	00 
  103865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103868:	89 54 24 04          	mov    %edx,0x4(%esp)
  10386c:	89 04 24             	mov    %eax,(%esp)
  10386f:	e8 e3 fd ff ff       	call   103657 <page_insert>
  103874:	85 c0                	test   %eax,%eax
  103876:	74 24                	je     10389c <check_pgdir+0x111>
  103878:	c7 44 24 0c 64 78 10 	movl   $0x107864,0xc(%esp)
  10387f:	00 
  103880:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103887:	00 
  103888:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  10388f:	00 
  103890:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103897:	e8 5d cb ff ff       	call   1003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10389c:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1038a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038a8:	00 
  1038a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1038b0:	00 
  1038b1:	89 04 24             	mov    %eax,(%esp)
  1038b4:	e8 65 fb ff ff       	call   10341e <get_pte>
  1038b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038c0:	75 24                	jne    1038e6 <check_pgdir+0x15b>
  1038c2:	c7 44 24 0c 90 78 10 	movl   $0x107890,0xc(%esp)
  1038c9:	00 
  1038ca:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1038d1:	00 
  1038d2:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  1038d9:	00 
  1038da:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1038e1:	e8 13 cb ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  1038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038e9:	8b 00                	mov    (%eax),%eax
  1038eb:	89 04 24             	mov    %eax,(%esp)
  1038ee:	e8 1d f2 ff ff       	call   102b10 <pte2page>
  1038f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1038f6:	74 24                	je     10391c <check_pgdir+0x191>
  1038f8:	c7 44 24 0c bd 78 10 	movl   $0x1078bd,0xc(%esp)
  1038ff:	00 
  103900:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103907:	00 
  103908:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  10390f:	00 
  103910:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103917:	e8 dd ca ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 1);
  10391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10391f:	89 04 24             	mov    %eax,(%esp)
  103922:	e8 3f f2 ff ff       	call   102b66 <page_ref>
  103927:	83 f8 01             	cmp    $0x1,%eax
  10392a:	74 24                	je     103950 <check_pgdir+0x1c5>
  10392c:	c7 44 24 0c d3 78 10 	movl   $0x1078d3,0xc(%esp)
  103933:	00 
  103934:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  10393b:	00 
  10393c:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103943:	00 
  103944:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10394b:	e8 a9 ca ff ff       	call   1003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103950:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103955:	8b 00                	mov    (%eax),%eax
  103957:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10395c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10395f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103962:	c1 e8 0c             	shr    $0xc,%eax
  103965:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103968:	a1 80 de 11 00       	mov    0x11de80,%eax
  10396d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103970:	72 23                	jb     103995 <check_pgdir+0x20a>
  103972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103975:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103979:	c7 44 24 08 a0 76 10 	movl   $0x1076a0,0x8(%esp)
  103980:	00 
  103981:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103988:	00 
  103989:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103990:	e8 64 ca ff ff       	call   1003f9 <__panic>
  103995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103998:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10399d:	83 c0 04             	add    $0x4,%eax
  1039a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1039a3:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1039a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039af:	00 
  1039b0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039b7:	00 
  1039b8:	89 04 24             	mov    %eax,(%esp)
  1039bb:	e8 5e fa ff ff       	call   10341e <get_pte>
  1039c0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1039c3:	74 24                	je     1039e9 <check_pgdir+0x25e>
  1039c5:	c7 44 24 0c e8 78 10 	movl   $0x1078e8,0xc(%esp)
  1039cc:	00 
  1039cd:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1039d4:	00 
  1039d5:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  1039dc:	00 
  1039dd:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1039e4:	e8 10 ca ff ff       	call   1003f9 <__panic>

    p2 = alloc_page();
  1039e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039f0:	e8 76 f3 ff ff       	call   102d6b <alloc_pages>
  1039f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1039f8:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1039fd:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103a04:	00 
  103a05:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103a0c:	00 
  103a0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a10:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a14:	89 04 24             	mov    %eax,(%esp)
  103a17:	e8 3b fc ff ff       	call   103657 <page_insert>
  103a1c:	85 c0                	test   %eax,%eax
  103a1e:	74 24                	je     103a44 <check_pgdir+0x2b9>
  103a20:	c7 44 24 0c 10 79 10 	movl   $0x107910,0xc(%esp)
  103a27:	00 
  103a28:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103a2f:	00 
  103a30:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103a37:	00 
  103a38:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103a3f:	e8 b5 c9 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a44:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103a49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a50:	00 
  103a51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a58:	00 
  103a59:	89 04 24             	mov    %eax,(%esp)
  103a5c:	e8 bd f9 ff ff       	call   10341e <get_pte>
  103a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a68:	75 24                	jne    103a8e <check_pgdir+0x303>
  103a6a:	c7 44 24 0c 48 79 10 	movl   $0x107948,0xc(%esp)
  103a71:	00 
  103a72:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103a79:	00 
  103a7a:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103a81:	00 
  103a82:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103a89:	e8 6b c9 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_U);
  103a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a91:	8b 00                	mov    (%eax),%eax
  103a93:	83 e0 04             	and    $0x4,%eax
  103a96:	85 c0                	test   %eax,%eax
  103a98:	75 24                	jne    103abe <check_pgdir+0x333>
  103a9a:	c7 44 24 0c 78 79 10 	movl   $0x107978,0xc(%esp)
  103aa1:	00 
  103aa2:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103aa9:	00 
  103aaa:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103ab1:	00 
  103ab2:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103ab9:	e8 3b c9 ff ff       	call   1003f9 <__panic>
    assert(*ptep & PTE_W);
  103abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ac1:	8b 00                	mov    (%eax),%eax
  103ac3:	83 e0 02             	and    $0x2,%eax
  103ac6:	85 c0                	test   %eax,%eax
  103ac8:	75 24                	jne    103aee <check_pgdir+0x363>
  103aca:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  103ad1:	00 
  103ad2:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103ad9:	00 
  103ada:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103ae1:	00 
  103ae2:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103ae9:	e8 0b c9 ff ff       	call   1003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103aee:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103af3:	8b 00                	mov    (%eax),%eax
  103af5:	83 e0 04             	and    $0x4,%eax
  103af8:	85 c0                	test   %eax,%eax
  103afa:	75 24                	jne    103b20 <check_pgdir+0x395>
  103afc:	c7 44 24 0c 94 79 10 	movl   $0x107994,0xc(%esp)
  103b03:	00 
  103b04:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103b0b:	00 
  103b0c:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103b13:	00 
  103b14:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103b1b:	e8 d9 c8 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 1);
  103b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b23:	89 04 24             	mov    %eax,(%esp)
  103b26:	e8 3b f0 ff ff       	call   102b66 <page_ref>
  103b2b:	83 f8 01             	cmp    $0x1,%eax
  103b2e:	74 24                	je     103b54 <check_pgdir+0x3c9>
  103b30:	c7 44 24 0c aa 79 10 	movl   $0x1079aa,0xc(%esp)
  103b37:	00 
  103b38:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103b3f:	00 
  103b40:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103b47:	00 
  103b48:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103b4f:	e8 a5 c8 ff ff       	call   1003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103b54:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b59:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103b60:	00 
  103b61:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b68:	00 
  103b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b70:	89 04 24             	mov    %eax,(%esp)
  103b73:	e8 df fa ff ff       	call   103657 <page_insert>
  103b78:	85 c0                	test   %eax,%eax
  103b7a:	74 24                	je     103ba0 <check_pgdir+0x415>
  103b7c:	c7 44 24 0c bc 79 10 	movl   $0x1079bc,0xc(%esp)
  103b83:	00 
  103b84:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103b8b:	00 
  103b8c:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103b93:	00 
  103b94:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103b9b:	e8 59 c8 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p1) == 2);
  103ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ba3:	89 04 24             	mov    %eax,(%esp)
  103ba6:	e8 bb ef ff ff       	call   102b66 <page_ref>
  103bab:	83 f8 02             	cmp    $0x2,%eax
  103bae:	74 24                	je     103bd4 <check_pgdir+0x449>
  103bb0:	c7 44 24 0c e8 79 10 	movl   $0x1079e8,0xc(%esp)
  103bb7:	00 
  103bb8:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103bbf:	00 
  103bc0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103bc7:	00 
  103bc8:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103bcf:	e8 25 c8 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bd7:	89 04 24             	mov    %eax,(%esp)
  103bda:	e8 87 ef ff ff       	call   102b66 <page_ref>
  103bdf:	85 c0                	test   %eax,%eax
  103be1:	74 24                	je     103c07 <check_pgdir+0x47c>
  103be3:	c7 44 24 0c fa 79 10 	movl   $0x1079fa,0xc(%esp)
  103bea:	00 
  103beb:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103bf2:	00 
  103bf3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103bfa:	00 
  103bfb:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103c02:	e8 f2 c7 ff ff       	call   1003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103c07:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c0c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c13:	00 
  103c14:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c1b:	00 
  103c1c:	89 04 24             	mov    %eax,(%esp)
  103c1f:	e8 fa f7 ff ff       	call   10341e <get_pte>
  103c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c2b:	75 24                	jne    103c51 <check_pgdir+0x4c6>
  103c2d:	c7 44 24 0c 48 79 10 	movl   $0x107948,0xc(%esp)
  103c34:	00 
  103c35:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103c3c:	00 
  103c3d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103c44:	00 
  103c45:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103c4c:	e8 a8 c7 ff ff       	call   1003f9 <__panic>
    assert(pte2page(*ptep) == p1);
  103c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c54:	8b 00                	mov    (%eax),%eax
  103c56:	89 04 24             	mov    %eax,(%esp)
  103c59:	e8 b2 ee ff ff       	call   102b10 <pte2page>
  103c5e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c61:	74 24                	je     103c87 <check_pgdir+0x4fc>
  103c63:	c7 44 24 0c bd 78 10 	movl   $0x1078bd,0xc(%esp)
  103c6a:	00 
  103c6b:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103c72:	00 
  103c73:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103c7a:	00 
  103c7b:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103c82:	e8 72 c7 ff ff       	call   1003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c8a:	8b 00                	mov    (%eax),%eax
  103c8c:	83 e0 04             	and    $0x4,%eax
  103c8f:	85 c0                	test   %eax,%eax
  103c91:	74 24                	je     103cb7 <check_pgdir+0x52c>
  103c93:	c7 44 24 0c 0c 7a 10 	movl   $0x107a0c,0xc(%esp)
  103c9a:	00 
  103c9b:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103ca2:	00 
  103ca3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103caa:	00 
  103cab:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103cb2:	e8 42 c7 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103cb7:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103cbc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cc3:	00 
  103cc4:	89 04 24             	mov    %eax,(%esp)
  103cc7:	e8 46 f9 ff ff       	call   103612 <page_remove>
    assert(page_ref(p1) == 1);
  103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ccf:	89 04 24             	mov    %eax,(%esp)
  103cd2:	e8 8f ee ff ff       	call   102b66 <page_ref>
  103cd7:	83 f8 01             	cmp    $0x1,%eax
  103cda:	74 24                	je     103d00 <check_pgdir+0x575>
  103cdc:	c7 44 24 0c d3 78 10 	movl   $0x1078d3,0xc(%esp)
  103ce3:	00 
  103ce4:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103ceb:	00 
  103cec:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103cf3:	00 
  103cf4:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103cfb:	e8 f9 c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d03:	89 04 24             	mov    %eax,(%esp)
  103d06:	e8 5b ee ff ff       	call   102b66 <page_ref>
  103d0b:	85 c0                	test   %eax,%eax
  103d0d:	74 24                	je     103d33 <check_pgdir+0x5a8>
  103d0f:	c7 44 24 0c fa 79 10 	movl   $0x1079fa,0xc(%esp)
  103d16:	00 
  103d17:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103d1e:	00 
  103d1f:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103d26:	00 
  103d27:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103d2e:	e8 c6 c6 ff ff       	call   1003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103d33:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d38:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d3f:	00 
  103d40:	89 04 24             	mov    %eax,(%esp)
  103d43:	e8 ca f8 ff ff       	call   103612 <page_remove>
    assert(page_ref(p1) == 0);
  103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d4b:	89 04 24             	mov    %eax,(%esp)
  103d4e:	e8 13 ee ff ff       	call   102b66 <page_ref>
  103d53:	85 c0                	test   %eax,%eax
  103d55:	74 24                	je     103d7b <check_pgdir+0x5f0>
  103d57:	c7 44 24 0c 21 7a 10 	movl   $0x107a21,0xc(%esp)
  103d5e:	00 
  103d5f:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103d66:	00 
  103d67:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103d6e:	00 
  103d6f:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103d76:	e8 7e c6 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p2) == 0);
  103d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d7e:	89 04 24             	mov    %eax,(%esp)
  103d81:	e8 e0 ed ff ff       	call   102b66 <page_ref>
  103d86:	85 c0                	test   %eax,%eax
  103d88:	74 24                	je     103dae <check_pgdir+0x623>
  103d8a:	c7 44 24 0c fa 79 10 	movl   $0x1079fa,0xc(%esp)
  103d91:	00 
  103d92:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103d99:	00 
  103d9a:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103da1:	00 
  103da2:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103da9:	e8 4b c6 ff ff       	call   1003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103dae:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103db3:	8b 00                	mov    (%eax),%eax
  103db5:	89 04 24             	mov    %eax,(%esp)
  103db8:	e8 91 ed ff ff       	call   102b4e <pde2page>
  103dbd:	89 04 24             	mov    %eax,(%esp)
  103dc0:	e8 a1 ed ff ff       	call   102b66 <page_ref>
  103dc5:	83 f8 01             	cmp    $0x1,%eax
  103dc8:	74 24                	je     103dee <check_pgdir+0x663>
  103dca:	c7 44 24 0c 34 7a 10 	movl   $0x107a34,0xc(%esp)
  103dd1:	00 
  103dd2:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103dd9:	00 
  103dda:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103de1:	00 
  103de2:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103de9:	e8 0b c6 ff ff       	call   1003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103dee:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103df3:	8b 00                	mov    (%eax),%eax
  103df5:	89 04 24             	mov    %eax,(%esp)
  103df8:	e8 51 ed ff ff       	call   102b4e <pde2page>
  103dfd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103e04:	00 
  103e05:	89 04 24             	mov    %eax,(%esp)
  103e08:	e8 96 ef ff ff       	call   102da3 <free_pages>
    boot_pgdir[0] = 0;
  103e0d:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103e18:	c7 04 24 5b 7a 10 00 	movl   $0x107a5b,(%esp)
  103e1f:	e8 7e c4 ff ff       	call   1002a2 <cprintf>
}
  103e24:	90                   	nop
  103e25:	c9                   	leave  
  103e26:	c3                   	ret    

00103e27 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103e27:	55                   	push   %ebp
  103e28:	89 e5                	mov    %esp,%ebp
  103e2a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e34:	e9 ca 00 00 00       	jmp    103f03 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e42:	c1 e8 0c             	shr    $0xc,%eax
  103e45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e48:	a1 80 de 11 00       	mov    0x11de80,%eax
  103e4d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103e50:	72 23                	jb     103e75 <check_boot_pgdir+0x4e>
  103e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e59:	c7 44 24 08 a0 76 10 	movl   $0x1076a0,0x8(%esp)
  103e60:	00 
  103e61:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103e68:	00 
  103e69:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103e70:	e8 84 c5 ff ff       	call   1003f9 <__panic>
  103e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e78:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e7d:	89 c2                	mov    %eax,%edx
  103e7f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e8b:	00 
  103e8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e90:	89 04 24             	mov    %eax,(%esp)
  103e93:	e8 86 f5 ff ff       	call   10341e <get_pte>
  103e98:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103e9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103e9f:	75 24                	jne    103ec5 <check_boot_pgdir+0x9e>
  103ea1:	c7 44 24 0c 78 7a 10 	movl   $0x107a78,0xc(%esp)
  103ea8:	00 
  103ea9:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103eb0:	00 
  103eb1:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103eb8:	00 
  103eb9:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103ec0:	e8 34 c5 ff ff       	call   1003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ec8:	8b 00                	mov    (%eax),%eax
  103eca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ecf:	89 c2                	mov    %eax,%edx
  103ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ed4:	39 c2                	cmp    %eax,%edx
  103ed6:	74 24                	je     103efc <check_boot_pgdir+0xd5>
  103ed8:	c7 44 24 0c b5 7a 10 	movl   $0x107ab5,0xc(%esp)
  103edf:	00 
  103ee0:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103ee7:	00 
  103ee8:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  103eef:	00 
  103ef0:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103ef7:	e8 fd c4 ff ff       	call   1003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103efc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f06:	a1 80 de 11 00       	mov    0x11de80,%eax
  103f0b:	39 c2                	cmp    %eax,%edx
  103f0d:	0f 82 26 ff ff ff    	jb     103e39 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103f13:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103f18:	05 ac 0f 00 00       	add    $0xfac,%eax
  103f1d:	8b 00                	mov    (%eax),%eax
  103f1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f24:	89 c2                	mov    %eax,%edx
  103f26:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f2e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103f35:	77 23                	ja     103f5a <check_boot_pgdir+0x133>
  103f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f3e:	c7 44 24 08 44 77 10 	movl   $0x107744,0x8(%esp)
  103f45:	00 
  103f46:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103f4d:	00 
  103f4e:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103f55:	e8 9f c4 ff ff       	call   1003f9 <__panic>
  103f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f5d:	05 00 00 00 40       	add    $0x40000000,%eax
  103f62:	39 d0                	cmp    %edx,%eax
  103f64:	74 24                	je     103f8a <check_boot_pgdir+0x163>
  103f66:	c7 44 24 0c cc 7a 10 	movl   $0x107acc,0xc(%esp)
  103f6d:	00 
  103f6e:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103f75:	00 
  103f76:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103f7d:	00 
  103f7e:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103f85:	e8 6f c4 ff ff       	call   1003f9 <__panic>

    assert(boot_pgdir[0] == 0);
  103f8a:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103f8f:	8b 00                	mov    (%eax),%eax
  103f91:	85 c0                	test   %eax,%eax
  103f93:	74 24                	je     103fb9 <check_boot_pgdir+0x192>
  103f95:	c7 44 24 0c 00 7b 10 	movl   $0x107b00,0xc(%esp)
  103f9c:	00 
  103f9d:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103fa4:	00 
  103fa5:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  103fac:	00 
  103fad:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  103fb4:	e8 40 c4 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    p = alloc_page();
  103fb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fc0:	e8 a6 ed ff ff       	call   102d6b <alloc_pages>
  103fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103fc8:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103fcd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fd4:	00 
  103fd5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103fdc:	00 
  103fdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fe0:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fe4:	89 04 24             	mov    %eax,(%esp)
  103fe7:	e8 6b f6 ff ff       	call   103657 <page_insert>
  103fec:	85 c0                	test   %eax,%eax
  103fee:	74 24                	je     104014 <check_boot_pgdir+0x1ed>
  103ff0:	c7 44 24 0c 14 7b 10 	movl   $0x107b14,0xc(%esp)
  103ff7:	00 
  103ff8:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  103fff:	00 
  104000:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104007:	00 
  104008:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10400f:	e8 e5 c3 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 1);
  104014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104017:	89 04 24             	mov    %eax,(%esp)
  10401a:	e8 47 eb ff ff       	call   102b66 <page_ref>
  10401f:	83 f8 01             	cmp    $0x1,%eax
  104022:	74 24                	je     104048 <check_boot_pgdir+0x221>
  104024:	c7 44 24 0c 42 7b 10 	movl   $0x107b42,0xc(%esp)
  10402b:	00 
  10402c:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  104033:	00 
  104034:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  10403b:	00 
  10403c:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  104043:	e8 b1 c3 ff ff       	call   1003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104048:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10404d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104054:	00 
  104055:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10405c:	00 
  10405d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104060:	89 54 24 04          	mov    %edx,0x4(%esp)
  104064:	89 04 24             	mov    %eax,(%esp)
  104067:	e8 eb f5 ff ff       	call   103657 <page_insert>
  10406c:	85 c0                	test   %eax,%eax
  10406e:	74 24                	je     104094 <check_boot_pgdir+0x26d>
  104070:	c7 44 24 0c 54 7b 10 	movl   $0x107b54,0xc(%esp)
  104077:	00 
  104078:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  10407f:	00 
  104080:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104087:	00 
  104088:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  10408f:	e8 65 c3 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p) == 2);
  104094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104097:	89 04 24             	mov    %eax,(%esp)
  10409a:	e8 c7 ea ff ff       	call   102b66 <page_ref>
  10409f:	83 f8 02             	cmp    $0x2,%eax
  1040a2:	74 24                	je     1040c8 <check_boot_pgdir+0x2a1>
  1040a4:	c7 44 24 0c 8b 7b 10 	movl   $0x107b8b,0xc(%esp)
  1040ab:	00 
  1040ac:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  1040b3:	00 
  1040b4:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  1040bb:	00 
  1040bc:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  1040c3:	e8 31 c3 ff ff       	call   1003f9 <__panic>

    const char *str = "ucore: Hello world!!";
  1040c8:	c7 45 e8 9c 7b 10 00 	movl   $0x107b9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  1040cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1040d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040d6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040dd:	e8 7b 23 00 00       	call   10645d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1040e2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1040e9:	00 
  1040ea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040f1:	e8 de 23 00 00       	call   1064d4 <strcmp>
  1040f6:	85 c0                	test   %eax,%eax
  1040f8:	74 24                	je     10411e <check_boot_pgdir+0x2f7>
  1040fa:	c7 44 24 0c b4 7b 10 	movl   $0x107bb4,0xc(%esp)
  104101:	00 
  104102:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  104109:	00 
  10410a:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104111:	00 
  104112:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  104119:	e8 db c2 ff ff       	call   1003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10411e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104121:	89 04 24             	mov    %eax,(%esp)
  104124:	e8 93 e9 ff ff       	call   102abc <page2kva>
  104129:	05 00 01 00 00       	add    $0x100,%eax
  10412e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104131:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104138:	e8 ca 22 00 00       	call   106407 <strlen>
  10413d:	85 c0                	test   %eax,%eax
  10413f:	74 24                	je     104165 <check_boot_pgdir+0x33e>
  104141:	c7 44 24 0c ec 7b 10 	movl   $0x107bec,0xc(%esp)
  104148:	00 
  104149:	c7 44 24 08 8d 77 10 	movl   $0x10778d,0x8(%esp)
  104150:	00 
  104151:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104158:	00 
  104159:	c7 04 24 68 77 10 00 	movl   $0x107768,(%esp)
  104160:	e8 94 c2 ff ff       	call   1003f9 <__panic>

    free_page(p);
  104165:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10416c:	00 
  10416d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104170:	89 04 24             	mov    %eax,(%esp)
  104173:	e8 2b ec ff ff       	call   102da3 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104178:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10417d:	8b 00                	mov    (%eax),%eax
  10417f:	89 04 24             	mov    %eax,(%esp)
  104182:	e8 c7 e9 ff ff       	call   102b4e <pde2page>
  104187:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10418e:	00 
  10418f:	89 04 24             	mov    %eax,(%esp)
  104192:	e8 0c ec ff ff       	call   102da3 <free_pages>
    boot_pgdir[0] = 0;
  104197:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10419c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1041a2:	c7 04 24 10 7c 10 00 	movl   $0x107c10,(%esp)
  1041a9:	e8 f4 c0 ff ff       	call   1002a2 <cprintf>
}
  1041ae:	90                   	nop
  1041af:	c9                   	leave  
  1041b0:	c3                   	ret    

001041b1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1041b1:	55                   	push   %ebp
  1041b2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1041b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1041b7:	83 e0 04             	and    $0x4,%eax
  1041ba:	85 c0                	test   %eax,%eax
  1041bc:	74 04                	je     1041c2 <perm2str+0x11>
  1041be:	b0 75                	mov    $0x75,%al
  1041c0:	eb 02                	jmp    1041c4 <perm2str+0x13>
  1041c2:	b0 2d                	mov    $0x2d,%al
  1041c4:	a2 08 df 11 00       	mov    %al,0x11df08
    str[1] = 'r';
  1041c9:	c6 05 09 df 11 00 72 	movb   $0x72,0x11df09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1041d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1041d3:	83 e0 02             	and    $0x2,%eax
  1041d6:	85 c0                	test   %eax,%eax
  1041d8:	74 04                	je     1041de <perm2str+0x2d>
  1041da:	b0 77                	mov    $0x77,%al
  1041dc:	eb 02                	jmp    1041e0 <perm2str+0x2f>
  1041de:	b0 2d                	mov    $0x2d,%al
  1041e0:	a2 0a df 11 00       	mov    %al,0x11df0a
    str[3] = '\0';
  1041e5:	c6 05 0b df 11 00 00 	movb   $0x0,0x11df0b
    return str;
  1041ec:	b8 08 df 11 00       	mov    $0x11df08,%eax
}
  1041f1:	5d                   	pop    %ebp
  1041f2:	c3                   	ret    

001041f3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1041f3:	55                   	push   %ebp
  1041f4:	89 e5                	mov    %esp,%ebp
  1041f6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1041f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1041fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041ff:	72 0d                	jb     10420e <get_pgtable_items+0x1b>
        return 0;
  104201:	b8 00 00 00 00       	mov    $0x0,%eax
  104206:	e9 98 00 00 00       	jmp    1042a3 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10420b:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10420e:	8b 45 10             	mov    0x10(%ebp),%eax
  104211:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104214:	73 18                	jae    10422e <get_pgtable_items+0x3b>
  104216:	8b 45 10             	mov    0x10(%ebp),%eax
  104219:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104220:	8b 45 14             	mov    0x14(%ebp),%eax
  104223:	01 d0                	add    %edx,%eax
  104225:	8b 00                	mov    (%eax),%eax
  104227:	83 e0 01             	and    $0x1,%eax
  10422a:	85 c0                	test   %eax,%eax
  10422c:	74 dd                	je     10420b <get_pgtable_items+0x18>
    }
    if (start < right) {
  10422e:	8b 45 10             	mov    0x10(%ebp),%eax
  104231:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104234:	73 68                	jae    10429e <get_pgtable_items+0xab>
        if (left_store != NULL) {
  104236:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10423a:	74 08                	je     104244 <get_pgtable_items+0x51>
            *left_store = start;
  10423c:	8b 45 18             	mov    0x18(%ebp),%eax
  10423f:	8b 55 10             	mov    0x10(%ebp),%edx
  104242:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104244:	8b 45 10             	mov    0x10(%ebp),%eax
  104247:	8d 50 01             	lea    0x1(%eax),%edx
  10424a:	89 55 10             	mov    %edx,0x10(%ebp)
  10424d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104254:	8b 45 14             	mov    0x14(%ebp),%eax
  104257:	01 d0                	add    %edx,%eax
  104259:	8b 00                	mov    (%eax),%eax
  10425b:	83 e0 07             	and    $0x7,%eax
  10425e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104261:	eb 03                	jmp    104266 <get_pgtable_items+0x73>
            start ++;
  104263:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104266:	8b 45 10             	mov    0x10(%ebp),%eax
  104269:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10426c:	73 1d                	jae    10428b <get_pgtable_items+0x98>
  10426e:	8b 45 10             	mov    0x10(%ebp),%eax
  104271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104278:	8b 45 14             	mov    0x14(%ebp),%eax
  10427b:	01 d0                	add    %edx,%eax
  10427d:	8b 00                	mov    (%eax),%eax
  10427f:	83 e0 07             	and    $0x7,%eax
  104282:	89 c2                	mov    %eax,%edx
  104284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104287:	39 c2                	cmp    %eax,%edx
  104289:	74 d8                	je     104263 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  10428b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10428f:	74 08                	je     104299 <get_pgtable_items+0xa6>
            *right_store = start;
  104291:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104294:	8b 55 10             	mov    0x10(%ebp),%edx
  104297:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10429c:	eb 05                	jmp    1042a3 <get_pgtable_items+0xb0>
    }
    return 0;
  10429e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1042a3:	c9                   	leave  
  1042a4:	c3                   	ret    

001042a5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1042a5:	55                   	push   %ebp
  1042a6:	89 e5                	mov    %esp,%ebp
  1042a8:	57                   	push   %edi
  1042a9:	56                   	push   %esi
  1042aa:	53                   	push   %ebx
  1042ab:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1042ae:	c7 04 24 30 7c 10 00 	movl   $0x107c30,(%esp)
  1042b5:	e8 e8 bf ff ff       	call   1002a2 <cprintf>
    size_t left, right = 0, perm;
  1042ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042c1:	e9 fa 00 00 00       	jmp    1043c0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042c9:	89 04 24             	mov    %eax,(%esp)
  1042cc:	e8 e0 fe ff ff       	call   1041b1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1042d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1042d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042d7:	29 d1                	sub    %edx,%ecx
  1042d9:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1042db:	89 d6                	mov    %edx,%esi
  1042dd:	c1 e6 16             	shl    $0x16,%esi
  1042e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042e3:	89 d3                	mov    %edx,%ebx
  1042e5:	c1 e3 16             	shl    $0x16,%ebx
  1042e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042eb:	89 d1                	mov    %edx,%ecx
  1042ed:	c1 e1 16             	shl    $0x16,%ecx
  1042f0:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1042f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042f6:	29 d7                	sub    %edx,%edi
  1042f8:	89 fa                	mov    %edi,%edx
  1042fa:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042fe:	89 74 24 10          	mov    %esi,0x10(%esp)
  104302:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10430a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10430e:	c7 04 24 61 7c 10 00 	movl   $0x107c61,(%esp)
  104315:	e8 88 bf ff ff       	call   1002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10431a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10431d:	c1 e0 0a             	shl    $0xa,%eax
  104320:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104323:	eb 54                	jmp    104379 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104328:	89 04 24             	mov    %eax,(%esp)
  10432b:	e8 81 fe ff ff       	call   1041b1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104330:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104333:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104336:	29 d1                	sub    %edx,%ecx
  104338:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10433a:	89 d6                	mov    %edx,%esi
  10433c:	c1 e6 0c             	shl    $0xc,%esi
  10433f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104342:	89 d3                	mov    %edx,%ebx
  104344:	c1 e3 0c             	shl    $0xc,%ebx
  104347:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10434a:	89 d1                	mov    %edx,%ecx
  10434c:	c1 e1 0c             	shl    $0xc,%ecx
  10434f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104352:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104355:	29 d7                	sub    %edx,%edi
  104357:	89 fa                	mov    %edi,%edx
  104359:	89 44 24 14          	mov    %eax,0x14(%esp)
  10435d:	89 74 24 10          	mov    %esi,0x10(%esp)
  104361:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104365:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104369:	89 54 24 04          	mov    %edx,0x4(%esp)
  10436d:	c7 04 24 80 7c 10 00 	movl   $0x107c80,(%esp)
  104374:	e8 29 bf ff ff       	call   1002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104379:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  10437e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104381:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104384:	89 d3                	mov    %edx,%ebx
  104386:	c1 e3 0a             	shl    $0xa,%ebx
  104389:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10438c:	89 d1                	mov    %edx,%ecx
  10438e:	c1 e1 0a             	shl    $0xa,%ecx
  104391:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104394:	89 54 24 14          	mov    %edx,0x14(%esp)
  104398:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10439b:	89 54 24 10          	mov    %edx,0x10(%esp)
  10439f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1043a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1043ab:	89 0c 24             	mov    %ecx,(%esp)
  1043ae:	e8 40 fe ff ff       	call   1041f3 <get_pgtable_items>
  1043b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043ba:	0f 85 65 ff ff ff    	jne    104325 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1043c0:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1043c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1043cb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1043cf:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1043d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  1043d6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1043da:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043de:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1043e5:	00 
  1043e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043ed:	e8 01 fe ff ff       	call   1041f3 <get_pgtable_items>
  1043f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1043f9:	0f 85 c7 fe ff ff    	jne    1042c6 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1043ff:	c7 04 24 a4 7c 10 00 	movl   $0x107ca4,(%esp)
  104406:	e8 97 be ff ff       	call   1002a2 <cprintf>
}
  10440b:	90                   	nop
  10440c:	83 c4 4c             	add    $0x4c,%esp
  10440f:	5b                   	pop    %ebx
  104410:	5e                   	pop    %esi
  104411:	5f                   	pop    %edi
  104412:	5d                   	pop    %ebp
  104413:	c3                   	ret    

00104414 <page_ref>:
page_ref(struct Page *page) {
  104414:	55                   	push   %ebp
  104415:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104417:	8b 45 08             	mov    0x8(%ebp),%eax
  10441a:	8b 00                	mov    (%eax),%eax
}
  10441c:	5d                   	pop    %ebp
  10441d:	c3                   	ret    

0010441e <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10441e:	55                   	push   %ebp
  10441f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104421:	8b 45 08             	mov    0x8(%ebp),%eax
  104424:	8b 55 0c             	mov    0xc(%ebp),%edx
  104427:	89 10                	mov    %edx,(%eax)
}
  104429:	90                   	nop
  10442a:	5d                   	pop    %ebp
  10442b:	c3                   	ret    

0010442c <fixsize>:
#define UINT32_MASK(a)          (UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(a,1),2),4),8),16))    
//´óÓÚaµÄÒ»¸ö×îÐ¡µÄ2^k
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))//Ð¡ÓÚaµÄ×î´óµÄ2^k

static unsigned fixsize(unsigned size) {
  10442c:	55                   	push   %ebp
  10442d:	89 e5                	mov    %esp,%ebp
  size |= size >> 1;
  10442f:	8b 45 08             	mov    0x8(%ebp),%eax
  104432:	d1 e8                	shr    %eax
  104434:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 2;
  104437:	8b 45 08             	mov    0x8(%ebp),%eax
  10443a:	c1 e8 02             	shr    $0x2,%eax
  10443d:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 4;
  104440:	8b 45 08             	mov    0x8(%ebp),%eax
  104443:	c1 e8 04             	shr    $0x4,%eax
  104446:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 8;
  104449:	8b 45 08             	mov    0x8(%ebp),%eax
  10444c:	c1 e8 08             	shr    $0x8,%eax
  10444f:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 16;
  104452:	8b 45 08             	mov    0x8(%ebp),%eax
  104455:	c1 e8 10             	shr    $0x10,%eax
  104458:	09 45 08             	or     %eax,0x8(%ebp)
  return size+1;
  10445b:	8b 45 08             	mov    0x8(%ebp),%eax
  10445e:	40                   	inc    %eax
}
  10445f:	5d                   	pop    %ebp
  104460:	c3                   	ret    

00104461 <buddy_init>:

struct allocRecord rec[80000];//´æ·ÅÆ«ÒÆÁ¿µÄÊý×é
int nr_block;//ÒÑ·ÖÅäµÄ¿éÊý

static void buddy_init()
{
  104461:	55                   	push   %ebp
  104462:	89 e5                	mov    %esp,%ebp
  104464:	83 ec 10             	sub    $0x10,%esp
  104467:	c7 45 fc a0 a3 1b 00 	movl   $0x1ba3a0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10446e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104474:	89 50 04             	mov    %edx,0x4(%eax)
  104477:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10447a:	8b 50 04             	mov    0x4(%eax),%edx
  10447d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104480:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free=0;
  104482:	c7 05 a8 a3 1b 00 00 	movl   $0x0,0x1ba3a8
  104489:	00 00 00 
}
  10448c:	90                   	nop
  10448d:	c9                   	leave  
  10448e:	c3                   	ret    

0010448f <buddy2_new>:

//³õÊ¼»¯¶þ²æÊ÷ÉÏµÄ½Úµã
void buddy2_new( int size ) {
  10448f:	55                   	push   %ebp
  104490:	89 e5                	mov    %esp,%ebp
  104492:	83 ec 10             	sub    $0x10,%esp
  unsigned node_size;
  int i;
  nr_block=0;
  104495:	c7 05 80 df 11 00 00 	movl   $0x0,0x11df80
  10449c:	00 00 00 
  if (size < 1 || !IS_POWER_OF_2(size))
  10449f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1044a3:	7e 55                	jle    1044fa <buddy2_new+0x6b>
  1044a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a8:	48                   	dec    %eax
  1044a9:	23 45 08             	and    0x8(%ebp),%eax
  1044ac:	85 c0                	test   %eax,%eax
  1044ae:	75 4a                	jne    1044fa <buddy2_new+0x6b>
    return;

  root[0].size = size;
  1044b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1044b3:	a3 a0 df 11 00       	mov    %eax,0x11dfa0
  node_size = size * 2;
  1044b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bb:	01 c0                	add    %eax,%eax
  1044bd:	89 45 fc             	mov    %eax,-0x4(%ebp)

  for (i = 0; i < 2 * size - 1; ++i) {
  1044c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1044c7:	eb 23                	jmp    1044ec <buddy2_new+0x5d>
    if (IS_POWER_OF_2(i+1))
  1044c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1044cc:	40                   	inc    %eax
  1044cd:	23 45 f8             	and    -0x8(%ebp),%eax
  1044d0:	85 c0                	test   %eax,%eax
  1044d2:	75 08                	jne    1044dc <buddy2_new+0x4d>
      node_size /= 2;
  1044d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044d7:	d1 e8                	shr    %eax
  1044d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    root[i].longest = node_size;
  1044dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1044df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1044e2:	89 14 c5 a4 df 11 00 	mov    %edx,0x11dfa4(,%eax,8)
  for (i = 0; i < 2 * size - 1; ++i) {
  1044e9:	ff 45 f8             	incl   -0x8(%ebp)
  1044ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ef:	01 c0                	add    %eax,%eax
  1044f1:	48                   	dec    %eax
  1044f2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  1044f5:	7c d2                	jl     1044c9 <buddy2_new+0x3a>
  }
  return;
  1044f7:	90                   	nop
  1044f8:	eb 01                	jmp    1044fb <buddy2_new+0x6c>
    return;
  1044fa:	90                   	nop
}
  1044fb:	c9                   	leave  
  1044fc:	c3                   	ret    

001044fd <buddy_init_memmap>:

//³õÊ¼»¯ÄÚ´æÓ³Éä¹ØÏµ
static void
buddy_init_memmap(struct Page *base, size_t n)
{
  1044fd:	55                   	push   %ebp
  1044fe:	89 e5                	mov    %esp,%ebp
  104500:	56                   	push   %esi
  104501:	53                   	push   %ebx
  104502:	83 ec 40             	sub    $0x40,%esp
    assert(n>0);
  104505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104509:	75 24                	jne    10452f <buddy_init_memmap+0x32>
  10450b:	c7 44 24 0c d8 7c 10 	movl   $0x107cd8,0xc(%esp)
  104512:	00 
  104513:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  10451a:	00 
  10451b:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  104522:	00 
  104523:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  10452a:	e8 ca be ff ff       	call   1003f9 <__panic>
    struct Page* p=base;
  10452f:	8b 45 08             	mov    0x8(%ebp),%eax
  104532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;p!=base + n;p++)
  104535:	e9 dc 00 00 00       	jmp    104616 <buddy_init_memmap+0x119>
    {
        assert(PageReserved(p));
  10453a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10453d:	83 c0 04             	add    $0x4,%eax
  104540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104547:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10454a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10454d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104550:	0f a3 10             	bt     %edx,(%eax)
  104553:	19 c0                	sbb    %eax,%eax
  104555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104558:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10455c:	0f 95 c0             	setne  %al
  10455f:	0f b6 c0             	movzbl %al,%eax
  104562:	85 c0                	test   %eax,%eax
  104564:	75 24                	jne    10458a <buddy_init_memmap+0x8d>
  104566:	c7 44 24 0c 01 7d 10 	movl   $0x107d01,0xc(%esp)
  10456d:	00 
  10456e:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104575:	00 
  104576:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  10457d:	00 
  10457e:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104585:	e8 6f be ff ff       	call   1003f9 <__panic>
        p->flags = 0;
  10458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10458d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 1;
  104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104597:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
        set_page_ref(p, 0);   
  10459e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045a5:	00 
  1045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a9:	89 04 24             	mov    %eax,(%esp)
  1045ac:	e8 6d fe ff ff       	call   10441e <set_page_ref>
        SetPageProperty(p);
  1045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b4:	83 c0 04             	add    $0x4,%eax
  1045b7:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  1045be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1045c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1045c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1045c7:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list,&(p->page_link));     
  1045ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045cd:	83 c0 0c             	add    $0xc,%eax
  1045d0:	c7 45 e0 a0 a3 1b 00 	movl   $0x1ba3a0,-0x20(%ebp)
  1045d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1045da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045dd:	8b 00                	mov    (%eax),%eax
  1045df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1045e2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1045e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1045e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1045ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1045f4:	89 10                	mov    %edx,(%eax)
  1045f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1045f9:	8b 10                	mov    (%eax),%edx
  1045fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1045fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104601:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104604:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104607:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10460a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10460d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104610:	89 10                	mov    %edx,(%eax)
    for(;p!=base + n;p++)
  104612:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104616:	8b 55 0c             	mov    0xc(%ebp),%edx
  104619:	89 d0                	mov    %edx,%eax
  10461b:	c1 e0 02             	shl    $0x2,%eax
  10461e:	01 d0                	add    %edx,%eax
  104620:	c1 e0 02             	shl    $0x2,%eax
  104623:	89 c2                	mov    %eax,%edx
  104625:	8b 45 08             	mov    0x8(%ebp),%eax
  104628:	01 d0                	add    %edx,%eax
  10462a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10462d:	0f 85 07 ff ff ff    	jne    10453a <buddy_init_memmap+0x3d>
    }
    nr_free += n;
  104633:	8b 15 a8 a3 1b 00    	mov    0x1ba3a8,%edx
  104639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10463c:	01 d0                	add    %edx,%eax
  10463e:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
    int allocpages=UINT32_ROUND_DOWN(n);
  104643:	8b 45 0c             	mov    0xc(%ebp),%eax
  104646:	d1 e8                	shr    %eax
  104648:	0b 45 0c             	or     0xc(%ebp),%eax
  10464b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10464e:	d1 ea                	shr    %edx
  104650:	0b 55 0c             	or     0xc(%ebp),%edx
  104653:	c1 ea 02             	shr    $0x2,%edx
  104656:	09 d0                	or     %edx,%eax
  104658:	89 c1                	mov    %eax,%ecx
  10465a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465d:	d1 e8                	shr    %eax
  10465f:	0b 45 0c             	or     0xc(%ebp),%eax
  104662:	8b 55 0c             	mov    0xc(%ebp),%edx
  104665:	d1 ea                	shr    %edx
  104667:	0b 55 0c             	or     0xc(%ebp),%edx
  10466a:	c1 ea 02             	shr    $0x2,%edx
  10466d:	09 d0                	or     %edx,%eax
  10466f:	c1 e8 04             	shr    $0x4,%eax
  104672:	09 c1                	or     %eax,%ecx
  104674:	8b 45 0c             	mov    0xc(%ebp),%eax
  104677:	d1 e8                	shr    %eax
  104679:	0b 45 0c             	or     0xc(%ebp),%eax
  10467c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10467f:	d1 ea                	shr    %edx
  104681:	0b 55 0c             	or     0xc(%ebp),%edx
  104684:	c1 ea 02             	shr    $0x2,%edx
  104687:	09 d0                	or     %edx,%eax
  104689:	89 c3                	mov    %eax,%ebx
  10468b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10468e:	d1 e8                	shr    %eax
  104690:	0b 45 0c             	or     0xc(%ebp),%eax
  104693:	8b 55 0c             	mov    0xc(%ebp),%edx
  104696:	d1 ea                	shr    %edx
  104698:	0b 55 0c             	or     0xc(%ebp),%edx
  10469b:	c1 ea 02             	shr    $0x2,%edx
  10469e:	09 d0                	or     %edx,%eax
  1046a0:	c1 e8 04             	shr    $0x4,%eax
  1046a3:	09 d8                	or     %ebx,%eax
  1046a5:	c1 e8 08             	shr    $0x8,%eax
  1046a8:	09 c1                	or     %eax,%ecx
  1046aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046ad:	d1 e8                	shr    %eax
  1046af:	0b 45 0c             	or     0xc(%ebp),%eax
  1046b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046b5:	d1 ea                	shr    %edx
  1046b7:	0b 55 0c             	or     0xc(%ebp),%edx
  1046ba:	c1 ea 02             	shr    $0x2,%edx
  1046bd:	09 d0                	or     %edx,%eax
  1046bf:	89 c3                	mov    %eax,%ebx
  1046c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c4:	d1 e8                	shr    %eax
  1046c6:	0b 45 0c             	or     0xc(%ebp),%eax
  1046c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046cc:	d1 ea                	shr    %edx
  1046ce:	0b 55 0c             	or     0xc(%ebp),%edx
  1046d1:	c1 ea 02             	shr    $0x2,%edx
  1046d4:	09 d0                	or     %edx,%eax
  1046d6:	c1 e8 04             	shr    $0x4,%eax
  1046d9:	09 c3                	or     %eax,%ebx
  1046db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046de:	d1 e8                	shr    %eax
  1046e0:	0b 45 0c             	or     0xc(%ebp),%eax
  1046e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046e6:	d1 ea                	shr    %edx
  1046e8:	0b 55 0c             	or     0xc(%ebp),%edx
  1046eb:	c1 ea 02             	shr    $0x2,%edx
  1046ee:	09 d0                	or     %edx,%eax
  1046f0:	89 c6                	mov    %eax,%esi
  1046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f5:	d1 e8                	shr    %eax
  1046f7:	0b 45 0c             	or     0xc(%ebp),%eax
  1046fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046fd:	d1 ea                	shr    %edx
  1046ff:	0b 55 0c             	or     0xc(%ebp),%edx
  104702:	c1 ea 02             	shr    $0x2,%edx
  104705:	09 d0                	or     %edx,%eax
  104707:	c1 e8 04             	shr    $0x4,%eax
  10470a:	09 f0                	or     %esi,%eax
  10470c:	c1 e8 08             	shr    $0x8,%eax
  10470f:	09 d8                	or     %ebx,%eax
  104711:	c1 e8 10             	shr    $0x10,%eax
  104714:	09 c8                	or     %ecx,%eax
  104716:	d1 e8                	shr    %eax
  104718:	23 45 0c             	and    0xc(%ebp),%eax
  10471b:	85 c0                	test   %eax,%eax
  10471d:	0f 84 dc 00 00 00    	je     1047ff <buddy_init_memmap+0x302>
  104723:	8b 45 0c             	mov    0xc(%ebp),%eax
  104726:	d1 e8                	shr    %eax
  104728:	0b 45 0c             	or     0xc(%ebp),%eax
  10472b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10472e:	d1 ea                	shr    %edx
  104730:	0b 55 0c             	or     0xc(%ebp),%edx
  104733:	c1 ea 02             	shr    $0x2,%edx
  104736:	09 d0                	or     %edx,%eax
  104738:	89 c1                	mov    %eax,%ecx
  10473a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10473d:	d1 e8                	shr    %eax
  10473f:	0b 45 0c             	or     0xc(%ebp),%eax
  104742:	8b 55 0c             	mov    0xc(%ebp),%edx
  104745:	d1 ea                	shr    %edx
  104747:	0b 55 0c             	or     0xc(%ebp),%edx
  10474a:	c1 ea 02             	shr    $0x2,%edx
  10474d:	09 d0                	or     %edx,%eax
  10474f:	c1 e8 04             	shr    $0x4,%eax
  104752:	09 c1                	or     %eax,%ecx
  104754:	8b 45 0c             	mov    0xc(%ebp),%eax
  104757:	d1 e8                	shr    %eax
  104759:	0b 45 0c             	or     0xc(%ebp),%eax
  10475c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10475f:	d1 ea                	shr    %edx
  104761:	0b 55 0c             	or     0xc(%ebp),%edx
  104764:	c1 ea 02             	shr    $0x2,%edx
  104767:	09 d0                	or     %edx,%eax
  104769:	89 c3                	mov    %eax,%ebx
  10476b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10476e:	d1 e8                	shr    %eax
  104770:	0b 45 0c             	or     0xc(%ebp),%eax
  104773:	8b 55 0c             	mov    0xc(%ebp),%edx
  104776:	d1 ea                	shr    %edx
  104778:	0b 55 0c             	or     0xc(%ebp),%edx
  10477b:	c1 ea 02             	shr    $0x2,%edx
  10477e:	09 d0                	or     %edx,%eax
  104780:	c1 e8 04             	shr    $0x4,%eax
  104783:	09 d8                	or     %ebx,%eax
  104785:	c1 e8 08             	shr    $0x8,%eax
  104788:	09 c1                	or     %eax,%ecx
  10478a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10478d:	d1 e8                	shr    %eax
  10478f:	0b 45 0c             	or     0xc(%ebp),%eax
  104792:	8b 55 0c             	mov    0xc(%ebp),%edx
  104795:	d1 ea                	shr    %edx
  104797:	0b 55 0c             	or     0xc(%ebp),%edx
  10479a:	c1 ea 02             	shr    $0x2,%edx
  10479d:	09 d0                	or     %edx,%eax
  10479f:	89 c3                	mov    %eax,%ebx
  1047a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a4:	d1 e8                	shr    %eax
  1047a6:	0b 45 0c             	or     0xc(%ebp),%eax
  1047a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047ac:	d1 ea                	shr    %edx
  1047ae:	0b 55 0c             	or     0xc(%ebp),%edx
  1047b1:	c1 ea 02             	shr    $0x2,%edx
  1047b4:	09 d0                	or     %edx,%eax
  1047b6:	c1 e8 04             	shr    $0x4,%eax
  1047b9:	09 c3                	or     %eax,%ebx
  1047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047be:	d1 e8                	shr    %eax
  1047c0:	0b 45 0c             	or     0xc(%ebp),%eax
  1047c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047c6:	d1 ea                	shr    %edx
  1047c8:	0b 55 0c             	or     0xc(%ebp),%edx
  1047cb:	c1 ea 02             	shr    $0x2,%edx
  1047ce:	09 d0                	or     %edx,%eax
  1047d0:	89 c6                	mov    %eax,%esi
  1047d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d5:	d1 e8                	shr    %eax
  1047d7:	0b 45 0c             	or     0xc(%ebp),%eax
  1047da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047dd:	d1 ea                	shr    %edx
  1047df:	0b 55 0c             	or     0xc(%ebp),%edx
  1047e2:	c1 ea 02             	shr    $0x2,%edx
  1047e5:	09 d0                	or     %edx,%eax
  1047e7:	c1 e8 04             	shr    $0x4,%eax
  1047ea:	09 f0                	or     %esi,%eax
  1047ec:	c1 e8 08             	shr    $0x8,%eax
  1047ef:	09 d8                	or     %ebx,%eax
  1047f1:	c1 e8 10             	shr    $0x10,%eax
  1047f4:	09 c8                	or     %ecx,%eax
  1047f6:	d1 e8                	shr    %eax
  1047f8:	f7 d0                	not    %eax
  1047fa:	23 45 0c             	and    0xc(%ebp),%eax
  1047fd:	eb 03                	jmp    104802 <buddy_init_memmap+0x305>
  1047ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  104802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy2_new(allocpages);
  104805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104808:	89 04 24             	mov    %eax,(%esp)
  10480b:	e8 7f fc ff ff       	call   10448f <buddy2_new>
}
  104810:	90                   	nop
  104811:	83 c4 40             	add    $0x40,%esp
  104814:	5b                   	pop    %ebx
  104815:	5e                   	pop    %esi
  104816:	5d                   	pop    %ebp
  104817:	c3                   	ret    

00104818 <buddy2_alloc>:
//ÄÚ´æ·ÖÅä
int buddy2_alloc(struct buddy2* self, int size) {
  104818:	55                   	push   %ebp
  104819:	89 e5                	mov    %esp,%ebp
  10481b:	53                   	push   %ebx
  10481c:	83 ec 14             	sub    $0x14,%esp
  unsigned index = 0;//½ÚµãµÄ±êºÅ
  10481f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  unsigned node_size;
  unsigned offset = 0;
  104826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if (self==NULL)//ÎÞ·¨·ÖÅä
  10482d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104831:	75 0a                	jne    10483d <buddy2_alloc+0x25>
    return -1;
  104833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104838:	e9 63 01 00 00       	jmp    1049a0 <buddy2_alloc+0x188>

  if (size <= 0)//·ÖÅä²»ºÏÀí
  10483d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104841:	7f 09                	jg     10484c <buddy2_alloc+0x34>
    size = 1;
  104843:	c7 45 0c 01 00 00 00 	movl   $0x1,0xc(%ebp)
  10484a:	eb 19                	jmp    104865 <buddy2_alloc+0x4d>
  else if (!IS_POWER_OF_2(size))//²»Îª2µÄÃÝÊ±£¬È¡±Èsize¸ü´óµÄ2µÄn´ÎÃÝ
  10484c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10484f:	48                   	dec    %eax
  104850:	23 45 0c             	and    0xc(%ebp),%eax
  104853:	85 c0                	test   %eax,%eax
  104855:	74 0e                	je     104865 <buddy2_alloc+0x4d>
    size = fixsize(size);
  104857:	8b 45 0c             	mov    0xc(%ebp),%eax
  10485a:	89 04 24             	mov    %eax,(%esp)
  10485d:	e8 ca fb ff ff       	call   10442c <fixsize>
  104862:	89 45 0c             	mov    %eax,0xc(%ebp)

  if (self[index].longest < size)//¿É·ÖÅäÄÚ´æ²»×ã
  104865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104868:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  10486f:	8b 45 08             	mov    0x8(%ebp),%eax
  104872:	01 d0                	add    %edx,%eax
  104874:	8b 50 04             	mov    0x4(%eax),%edx
  104877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10487a:	39 c2                	cmp    %eax,%edx
  10487c:	73 0a                	jae    104888 <buddy2_alloc+0x70>
    return -1;
  10487e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104883:	e9 18 01 00 00       	jmp    1049a0 <buddy2_alloc+0x188>

  for(node_size = self->size; node_size != size; node_size /= 2 ) {
  104888:	8b 45 08             	mov    0x8(%ebp),%eax
  10488b:	8b 00                	mov    (%eax),%eax
  10488d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104890:	e9 85 00 00 00       	jmp    10491a <buddy2_alloc+0x102>
    if (self[LEFT_LEAF(index)].longest >= size)
  104895:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104898:	c1 e0 04             	shl    $0x4,%eax
  10489b:	8d 50 08             	lea    0x8(%eax),%edx
  10489e:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a1:	01 d0                	add    %edx,%eax
  1048a3:	8b 50 04             	mov    0x4(%eax),%edx
  1048a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048a9:	39 c2                	cmp    %eax,%edx
  1048ab:	72 5c                	jb     104909 <buddy2_alloc+0xf1>
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
  1048ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048b0:	40                   	inc    %eax
  1048b1:	c1 e0 04             	shl    $0x4,%eax
  1048b4:	89 c2                	mov    %eax,%edx
  1048b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1048b9:	01 d0                	add    %edx,%eax
  1048bb:	8b 50 04             	mov    0x4(%eax),%edx
  1048be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048c1:	39 c2                	cmp    %eax,%edx
  1048c3:	72 39                	jb     1048fe <buddy2_alloc+0xe6>
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
  1048c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048c8:	c1 e0 04             	shl    $0x4,%eax
  1048cb:	8d 50 08             	lea    0x8(%eax),%edx
  1048ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d1:	01 d0                	add    %edx,%eax
  1048d3:	8b 50 04             	mov    0x4(%eax),%edx
  1048d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048d9:	40                   	inc    %eax
  1048da:	c1 e0 04             	shl    $0x4,%eax
  1048dd:	89 c1                	mov    %eax,%ecx
  1048df:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e2:	01 c8                	add    %ecx,%eax
  1048e4:	8b 40 04             	mov    0x4(%eax),%eax
  1048e7:	39 c2                	cmp    %eax,%edx
  1048e9:	77 08                	ja     1048f3 <buddy2_alloc+0xdb>
  1048eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048ee:	01 c0                	add    %eax,%eax
  1048f0:	40                   	inc    %eax
  1048f1:	eb 06                	jmp    1048f9 <buddy2_alloc+0xe1>
  1048f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048f6:	40                   	inc    %eax
  1048f7:	01 c0                	add    %eax,%eax
  1048f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1048fc:	eb 14                	jmp    104912 <buddy2_alloc+0xfa>
         //ÕÒµ½Á½¸öÏà·ûºÏµÄ½ÚµãÖÐÄÚ´æ½ÏÐ¡µÄ½áµã
        }
       else
       {
         index=LEFT_LEAF(index);
  1048fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104901:	01 c0                	add    %eax,%eax
  104903:	40                   	inc    %eax
  104904:	89 45 f8             	mov    %eax,-0x8(%ebp)
  104907:	eb 09                	jmp    104912 <buddy2_alloc+0xfa>
       }  
    }
    else
      index = RIGHT_LEAF(index);
  104909:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10490c:	40                   	inc    %eax
  10490d:	01 c0                	add    %eax,%eax
  10490f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(node_size = self->size; node_size != size; node_size /= 2 ) {
  104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104915:	d1 e8                	shr    %eax
  104917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10491a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10491d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104920:	0f 85 6f ff ff ff    	jne    104895 <buddy2_alloc+0x7d>
  }

  self[index].longest = 0;//±ê¼Ç½ÚµãÎªÒÑÊ¹ÓÃ
  104926:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104929:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  104930:	8b 45 08             	mov    0x8(%ebp),%eax
  104933:	01 d0                	add    %edx,%eax
  104935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  offset = (index + 1) * node_size - self->size;
  10493c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10493f:	40                   	inc    %eax
  104940:	0f af 45 f4          	imul   -0xc(%ebp),%eax
  104944:	89 c2                	mov    %eax,%edx
  104946:	8b 45 08             	mov    0x8(%ebp),%eax
  104949:	8b 00                	mov    (%eax),%eax
  10494b:	29 c2                	sub    %eax,%edx
  10494d:	89 d0                	mov    %edx,%eax
  10494f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (index) {
  104952:	eb 43                	jmp    104997 <buddy2_alloc+0x17f>
    index = PARENT(index);
  104954:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104957:	40                   	inc    %eax
  104958:	d1 e8                	shr    %eax
  10495a:	48                   	dec    %eax
  10495b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
  10495e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104961:	40                   	inc    %eax
  104962:	c1 e0 04             	shl    $0x4,%eax
  104965:	89 c2                	mov    %eax,%edx
  104967:	8b 45 08             	mov    0x8(%ebp),%eax
  10496a:	01 d0                	add    %edx,%eax
  10496c:	8b 50 04             	mov    0x4(%eax),%edx
  10496f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104972:	c1 e0 04             	shl    $0x4,%eax
  104975:	8d 48 08             	lea    0x8(%eax),%ecx
  104978:	8b 45 08             	mov    0x8(%ebp),%eax
  10497b:	01 c8                	add    %ecx,%eax
  10497d:	8b 40 04             	mov    0x4(%eax),%eax
    self[index].longest = 
  104980:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  104983:	8d 1c cd 00 00 00 00 	lea    0x0(,%ecx,8),%ebx
  10498a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10498d:	01 d9                	add    %ebx,%ecx
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
  10498f:	39 c2                	cmp    %eax,%edx
  104991:	0f 43 c2             	cmovae %edx,%eax
    self[index].longest = 
  104994:	89 41 04             	mov    %eax,0x4(%ecx)
  while (index) {
  104997:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  10499b:	75 b7                	jne    104954 <buddy2_alloc+0x13c>
  }
//ÏòÉÏË¢ÐÂ£¬ÐÞ¸ÄÏÈ×æ½áµãµÄÊýÖµ
  return offset;
  10499d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1049a0:	83 c4 14             	add    $0x14,%esp
  1049a3:	5b                   	pop    %ebx
  1049a4:	5d                   	pop    %ebp
  1049a5:	c3                   	ret    

001049a6 <buddy_alloc_pages>:

static struct Page*
buddy_alloc_pages(size_t n){
  1049a6:	55                   	push   %ebp
  1049a7:	89 e5                	mov    %esp,%ebp
  1049a9:	53                   	push   %ebx
  1049aa:	83 ec 44             	sub    $0x44,%esp
  assert(n>0);
  1049ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1049b1:	75 24                	jne    1049d7 <buddy_alloc_pages+0x31>
  1049b3:	c7 44 24 0c d8 7c 10 	movl   $0x107cd8,0xc(%esp)
  1049ba:	00 
  1049bb:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  1049c2:	00 
  1049c3:	c7 44 24 04 8d 00 00 	movl   $0x8d,0x4(%esp)
  1049ca:	00 
  1049cb:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  1049d2:	e8 22 ba ff ff       	call   1003f9 <__panic>
  if(n>nr_free)
  1049d7:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  1049dc:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049df:	76 0a                	jbe    1049eb <buddy_alloc_pages+0x45>
   return NULL;
  1049e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1049e6:	e9 41 01 00 00       	jmp    104b2c <buddy_alloc_pages+0x186>
  struct Page* page=NULL;
  1049eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct Page* p;
  list_entry_t *le=&free_list,*len;
  1049f2:	c7 45 f4 a0 a3 1b 00 	movl   $0x1ba3a0,-0xc(%ebp)
  rec[nr_block].offset=buddy2_alloc(root,n);//¼ÇÂ¼Æ«ÒÆÁ¿
  1049f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1049fc:	8b 1d 80 df 11 00    	mov    0x11df80,%ebx
  104a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a06:	c7 04 24 a0 df 11 00 	movl   $0x11dfa0,(%esp)
  104a0d:	e8 06 fe ff ff       	call   104818 <buddy2_alloc>
  104a12:	89 c2                	mov    %eax,%edx
  104a14:	89 d8                	mov    %ebx,%eax
  104a16:	01 c0                	add    %eax,%eax
  104a18:	01 d8                	add    %ebx,%eax
  104a1a:	c1 e0 02             	shl    $0x2,%eax
  104a1d:	05 c4 a3 1b 00       	add    $0x1ba3c4,%eax
  104a22:	89 10                	mov    %edx,(%eax)
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)
  104a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104a2b:	eb 12                	jmp    104a3f <buddy_alloc_pages+0x99>
  104a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a30:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
  104a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a36:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(le);
  104a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<rec[nr_block].offset+1;i++)
  104a3c:	ff 45 f0             	incl   -0x10(%ebp)
  104a3f:	8b 15 80 df 11 00    	mov    0x11df80,%edx
  104a45:	89 d0                	mov    %edx,%eax
  104a47:	01 c0                	add    %eax,%eax
  104a49:	01 d0                	add    %edx,%eax
  104a4b:	c1 e0 02             	shl    $0x2,%eax
  104a4e:	05 c4 a3 1b 00       	add    $0x1ba3c4,%eax
  104a53:	8b 00                	mov    (%eax),%eax
  104a55:	40                   	inc    %eax
  104a56:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a59:	7c d2                	jl     104a2d <buddy_alloc_pages+0x87>
  page=le2page(le,page_link);
  104a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a5e:	83 e8 0c             	sub    $0xc,%eax
  104a61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int allocpages;
  if(!IS_POWER_OF_2(n))
  104a64:	8b 45 08             	mov    0x8(%ebp),%eax
  104a67:	48                   	dec    %eax
  104a68:	23 45 08             	and    0x8(%ebp),%eax
  104a6b:	85 c0                	test   %eax,%eax
  104a6d:	74 10                	je     104a7f <buddy_alloc_pages+0xd9>
   allocpages=fixsize(n);
  104a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  104a72:	89 04 24             	mov    %eax,(%esp)
  104a75:	e8 b2 f9 ff ff       	call   10442c <fixsize>
  104a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a7d:	eb 06                	jmp    104a85 <buddy_alloc_pages+0xdf>
  else
  {
     allocpages=n;
  104a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  104a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  //¸ù¾ÝÐèÇónµÃµ½¿é´óÐ¡
  rec[nr_block].base=page;//¼ÇÂ¼·ÖÅä¿éÊ×Ò³
  104a85:	8b 15 80 df 11 00    	mov    0x11df80,%edx
  104a8b:	89 d0                	mov    %edx,%eax
  104a8d:	01 c0                	add    %eax,%eax
  104a8f:	01 d0                	add    %edx,%eax
  104a91:	c1 e0 02             	shl    $0x2,%eax
  104a94:	8d 90 c0 a3 1b 00    	lea    0x1ba3c0(%eax),%edx
  104a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a9d:	89 02                	mov    %eax,(%edx)
  rec[nr_block].nr=allocpages;//¼ÇÂ¼·ÖÅäµÄÒ³Êý
  104a9f:	8b 15 80 df 11 00    	mov    0x11df80,%edx
  104aa5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  104aa8:	89 d0                	mov    %edx,%eax
  104aaa:	01 c0                	add    %eax,%eax
  104aac:	01 d0                	add    %edx,%eax
  104aae:	c1 e0 02             	shl    $0x2,%eax
  104ab1:	05 c8 a3 1b 00       	add    $0x1ba3c8,%eax
  104ab6:	89 08                	mov    %ecx,(%eax)
  nr_block++;
  104ab8:	a1 80 df 11 00       	mov    0x11df80,%eax
  104abd:	40                   	inc    %eax
  104abe:	a3 80 df 11 00       	mov    %eax,0x11df80
  for(i=0;i<allocpages;i++)
  104ac3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104aca:	eb 3a                	jmp    104b06 <buddy_alloc_pages+0x160>
  104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104acf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ad2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ad5:	8b 40 04             	mov    0x4(%eax),%eax
  {
    len=list_next(le);
  104ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p=le2page(le,page_link);
  104adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ade:	83 e8 0c             	sub    $0xc,%eax
  104ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    ClearPageProperty(p);
  104ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ae7:	83 c0 04             	add    $0x4,%eax
  104aea:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104af7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104afa:	0f b3 10             	btr    %edx,(%eax)
    le=len;
  104afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<allocpages;i++)
  104b03:	ff 45 f0             	incl   -0x10(%ebp)
  104b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104b0c:	7c be                	jl     104acc <buddy_alloc_pages+0x126>
  }//ÐÞ¸ÄÃ¿Ò»Ò³µÄ×´Ì¬
  nr_free-=allocpages;//¼õÈ¥ÒÑ±»·ÖÅäµÄÒ³Êý
  104b0e:	8b 15 a8 a3 1b 00    	mov    0x1ba3a8,%edx
  104b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b17:	29 c2                	sub    %eax,%edx
  104b19:	89 d0                	mov    %edx,%eax
  104b1b:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
  page->property=n;
  104b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b23:	8b 55 08             	mov    0x8(%ebp),%edx
  104b26:	89 50 08             	mov    %edx,0x8(%eax)
  return page;
  104b29:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  104b2c:	83 c4 44             	add    $0x44,%esp
  104b2f:	5b                   	pop    %ebx
  104b30:	5d                   	pop    %ebp
  104b31:	c3                   	ret    

00104b32 <buddy_free_pages>:

void buddy_free_pages(struct Page* base, size_t n) {
  104b32:	55                   	push   %ebp
  104b33:	89 e5                	mov    %esp,%ebp
  104b35:	83 ec 58             	sub    $0x58,%esp
  unsigned node_size, index = 0;
  104b38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
  104b3f:	c7 45 e0 a0 df 11 00 	movl   $0x11dfa0,-0x20(%ebp)
  104b46:	c7 45 c8 a0 a3 1b 00 	movl   $0x1ba3a0,-0x38(%ebp)
  104b4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104b50:	8b 40 04             	mov    0x4(%eax),%eax
  
  list_entry_t *le=list_next(&free_list);
  104b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i=0;
  104b56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(i=0;i<nr_block;i++)//ÕÒµ½¿é
  104b5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104b64:	eb 1b                	jmp    104b81 <buddy_free_pages+0x4f>
  {
    if(rec[i].base==base)
  104b66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104b69:	89 d0                	mov    %edx,%eax
  104b6b:	01 c0                	add    %eax,%eax
  104b6d:	01 d0                	add    %edx,%eax
  104b6f:	c1 e0 02             	shl    $0x2,%eax
  104b72:	05 c0 a3 1b 00       	add    $0x1ba3c0,%eax
  104b77:	8b 00                	mov    (%eax),%eax
  104b79:	39 45 08             	cmp    %eax,0x8(%ebp)
  104b7c:	74 0f                	je     104b8d <buddy_free_pages+0x5b>
  for(i=0;i<nr_block;i++)//ÕÒµ½¿é
  104b7e:	ff 45 e8             	incl   -0x18(%ebp)
  104b81:	a1 80 df 11 00       	mov    0x11df80,%eax
  104b86:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b89:	7c db                	jl     104b66 <buddy_free_pages+0x34>
  104b8b:	eb 01                	jmp    104b8e <buddy_free_pages+0x5c>
     break;
  104b8d:	90                   	nop
  }
  int offset=rec[i].offset;
  104b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104b91:	89 d0                	mov    %edx,%eax
  104b93:	01 c0                	add    %eax,%eax
  104b95:	01 d0                	add    %edx,%eax
  104b97:	c1 e0 02             	shl    $0x2,%eax
  104b9a:	05 c4 a3 1b 00       	add    $0x1ba3c4,%eax
  104b9f:	8b 00                	mov    (%eax),%eax
  104ba1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int pos=i;//ÔÝ´æi
  104ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ba7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  i=0;
  104baa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  while(i<offset)
  104bb1:	eb 12                	jmp    104bc5 <buddy_free_pages+0x93>
  104bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104bbc:	8b 40 04             	mov    0x4(%eax),%eax
  {
    le=list_next(le);
  104bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    i++;
  104bc2:	ff 45 e8             	incl   -0x18(%ebp)
  while(i<offset)
  104bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104bc8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104bcb:	7c e6                	jl     104bb3 <buddy_free_pages+0x81>
  }
  int allocpages;
  if(!IS_POWER_OF_2(n))
  104bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  104bd0:	48                   	dec    %eax
  104bd1:	23 45 0c             	and    0xc(%ebp),%eax
  104bd4:	85 c0                	test   %eax,%eax
  104bd6:	74 10                	je     104be8 <buddy_free_pages+0xb6>
   allocpages=fixsize(n);
  104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  104bdb:	89 04 24             	mov    %eax,(%esp)
  104bde:	e8 49 f8 ff ff       	call   10442c <fixsize>
  104be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104be6:	eb 06                	jmp    104bee <buddy_free_pages+0xbc>
  else
  {
     allocpages=n;
  104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  104beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  assert(self && offset >= 0 && offset < self->size);//ÊÇ·ñºÏ·¨
  104bee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104bf2:	74 12                	je     104c06 <buddy_free_pages+0xd4>
  104bf4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104bf8:	78 0c                	js     104c06 <buddy_free_pages+0xd4>
  104bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104bfd:	8b 10                	mov    (%eax),%edx
  104bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c02:	39 c2                	cmp    %eax,%edx
  104c04:	77 24                	ja     104c2a <buddy_free_pages+0xf8>
  104c06:	c7 44 24 0c 14 7d 10 	movl   $0x107d14,0xc(%esp)
  104c0d:	00 
  104c0e:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104c15:	00 
  104c16:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104c1d:	00 
  104c1e:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104c25:	e8 cf b7 ff ff       	call   1003f9 <__panic>
  node_size = 1;
  104c2a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  index = offset + self->size - 1;
  104c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c34:	8b 10                	mov    (%eax),%edx
  104c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c39:	01 d0                	add    %edx,%eax
  104c3b:	48                   	dec    %eax
  104c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  nr_free+=allocpages;//¸üÐÂ¿ÕÏÐÒ³µÄÊýÁ¿
  104c3f:	8b 15 a8 a3 1b 00    	mov    0x1ba3a8,%edx
  104c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c48:	01 d0                	add    %edx,%eax
  104c4a:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
  struct Page* p;
  self[index].longest = allocpages;
  104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c52:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  104c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c5c:	01 c2                	add    %eax,%edx
  104c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c61:	89 42 04             	mov    %eax,0x4(%edx)
  for(i=0;i<allocpages;i++)//»ØÊÕÒÑ·ÖÅäµÄÒ³
  104c64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104c6b:	eb 48                	jmp    104cb5 <buddy_free_pages+0x183>
  {
     p=le2page(le,page_link);
  104c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c70:	83 e8 0c             	sub    $0xc,%eax
  104c73:	89 45 cc             	mov    %eax,-0x34(%ebp)
     p->flags=0;
  104c76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     p->property=1;
  104c80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
     SetPageProperty(p);
  104c8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c8d:	83 c0 04             	add    $0x4,%eax
  104c90:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104c97:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104c9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104c9d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ca0:	0f ab 10             	bts    %edx,(%eax)
  104ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ca6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104ca9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104cac:	8b 40 04             	mov    0x4(%eax),%eax
     le=list_next(le);
  104caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(i=0;i<allocpages;i++)//»ØÊÕÒÑ·ÖÅäµÄÒ³
  104cb2:	ff 45 e8             	incl   -0x18(%ebp)
  104cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104cb8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  104cbb:	7c b0                	jl     104c6d <buddy_free_pages+0x13b>
  }
  while (index) {//ÏòÉÏºÏ²¢£¬ÐÞ¸ÄÏÈ×æ½ÚµãµÄ¼ÇÂ¼Öµ
  104cbd:	eb 75                	jmp    104d34 <buddy_free_pages+0x202>
    index = PARENT(index);
  104cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cc2:	40                   	inc    %eax
  104cc3:	d1 e8                	shr    %eax
  104cc5:	48                   	dec    %eax
  104cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
  104cc9:	d1 65 f4             	shll   -0xc(%ebp)

    left_longest = self[LEFT_LEAF(index)].longest;
  104ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ccf:	c1 e0 04             	shl    $0x4,%eax
  104cd2:	8d 50 08             	lea    0x8(%eax),%edx
  104cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cd8:	01 d0                	add    %edx,%eax
  104cda:	8b 40 04             	mov    0x4(%eax),%eax
  104cdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    right_longest = self[RIGHT_LEAF(index)].longest;
  104ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce3:	40                   	inc    %eax
  104ce4:	c1 e0 04             	shl    $0x4,%eax
  104ce7:	89 c2                	mov    %eax,%edx
  104ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cec:	01 d0                	add    %edx,%eax
  104cee:	8b 40 04             	mov    0x4(%eax),%eax
  104cf1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    
    if (left_longest + right_longest == node_size) 
  104cf4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104cfa:	01 d0                	add    %edx,%eax
  104cfc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104cff:	75 17                	jne    104d18 <buddy_free_pages+0x1e6>
      self[index].longest = node_size;
  104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d04:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  104d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d0e:	01 c2                	add    %eax,%edx
  104d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d13:	89 42 04             	mov    %eax,0x4(%edx)
  104d16:	eb 1c                	jmp    104d34 <buddy_free_pages+0x202>
    else
      self[index].longest = MAX(left_longest, right_longest);
  104d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d1b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  104d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d25:	01 c2                	add    %eax,%edx
  104d27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d2a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  104d2d:	0f 43 45 d0          	cmovae -0x30(%ebp),%eax
  104d31:	89 42 04             	mov    %eax,0x4(%edx)
  while (index) {//ÏòÉÏºÏ²¢£¬ÐÞ¸ÄÏÈ×æ½ÚµãµÄ¼ÇÂ¼Öµ
  104d34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d38:	75 85                	jne    104cbf <buddy_free_pages+0x18d>
  }
  for(i=pos;i<nr_block-1;i++)//Çå³ý´Ë´ÎµÄ·ÖÅä¼ÇÂ¼
  104d3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104d3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104d40:	eb 39                	jmp    104d7b <buddy_free_pages+0x249>
  {
    rec[i]=rec[i+1];
  104d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d45:	8d 48 01             	lea    0x1(%eax),%ecx
  104d48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104d4b:	89 d0                	mov    %edx,%eax
  104d4d:	01 c0                	add    %eax,%eax
  104d4f:	01 d0                	add    %edx,%eax
  104d51:	c1 e0 02             	shl    $0x2,%eax
  104d54:	8d 90 c0 a3 1b 00    	lea    0x1ba3c0(%eax),%edx
  104d5a:	89 c8                	mov    %ecx,%eax
  104d5c:	01 c0                	add    %eax,%eax
  104d5e:	01 c8                	add    %ecx,%eax
  104d60:	c1 e0 02             	shl    $0x2,%eax
  104d63:	05 c0 a3 1b 00       	add    $0x1ba3c0,%eax
  104d68:	8b 08                	mov    (%eax),%ecx
  104d6a:	89 0a                	mov    %ecx,(%edx)
  104d6c:	8b 48 04             	mov    0x4(%eax),%ecx
  104d6f:	89 4a 04             	mov    %ecx,0x4(%edx)
  104d72:	8b 40 08             	mov    0x8(%eax),%eax
  104d75:	89 42 08             	mov    %eax,0x8(%edx)
  for(i=pos;i<nr_block-1;i++)//Çå³ý´Ë´ÎµÄ·ÖÅä¼ÇÂ¼
  104d78:	ff 45 e8             	incl   -0x18(%ebp)
  104d7b:	a1 80 df 11 00       	mov    0x11df80,%eax
  104d80:	48                   	dec    %eax
  104d81:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104d84:	7c bc                	jl     104d42 <buddy_free_pages+0x210>
  }
  nr_block--;//¸üÐÂ·ÖÅä¿éÊýµÄÖµ
  104d86:	a1 80 df 11 00       	mov    0x11df80,%eax
  104d8b:	48                   	dec    %eax
  104d8c:	a3 80 df 11 00       	mov    %eax,0x11df80
}
  104d91:	90                   	nop
  104d92:	c9                   	leave  
  104d93:	c3                   	ret    

00104d94 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  104d94:	55                   	push   %ebp
  104d95:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104d97:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
}
  104d9c:	5d                   	pop    %ebp
  104d9d:	c3                   	ret    

00104d9e <buddy_check>:

//ÒÔÏÂÊÇÒ»¸ö²âÊÔº¯Êý
static void

buddy_check(void) {
  104d9e:	55                   	push   %ebp
  104d9f:	89 e5                	mov    %esp,%ebp
  104da1:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *A, *B,*C,*D;
    p0 = A = B = C = D =NULL;
  104da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
  104dc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dca:	e8 9c df ff ff       	call   102d6b <alloc_pages>
  104dcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104dd6:	75 24                	jne    104dfc <buddy_check+0x5e>
  104dd8:	c7 44 24 0c 3f 7d 10 	movl   $0x107d3f,0xc(%esp)
  104ddf:	00 
  104de0:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104de7:	00 
  104de8:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  104def:	00 
  104df0:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104df7:	e8 fd b5 ff ff       	call   1003f9 <__panic>
    assert((A = alloc_page()) != NULL);
  104dfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e03:	e8 63 df ff ff       	call   102d6b <alloc_pages>
  104e08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e0f:	75 24                	jne    104e35 <buddy_check+0x97>
  104e11:	c7 44 24 0c 5b 7d 10 	movl   $0x107d5b,0xc(%esp)
  104e18:	00 
  104e19:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104e20:	00 
  104e21:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104e28:	00 
  104e29:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104e30:	e8 c4 b5 ff ff       	call   1003f9 <__panic>
    assert((B = alloc_page()) != NULL);
  104e35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e3c:	e8 2a df ff ff       	call   102d6b <alloc_pages>
  104e41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104e48:	75 24                	jne    104e6e <buddy_check+0xd0>
  104e4a:	c7 44 24 0c 76 7d 10 	movl   $0x107d76,0xc(%esp)
  104e51:	00 
  104e52:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104e59:	00 
  104e5a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  104e61:	00 
  104e62:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104e69:	e8 8b b5 ff ff       	call   1003f9 <__panic>

    assert(p0 != A && p0 != B && A != B);
  104e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e71:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  104e74:	74 10                	je     104e86 <buddy_check+0xe8>
  104e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e79:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e7c:	74 08                	je     104e86 <buddy_check+0xe8>
  104e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e84:	75 24                	jne    104eaa <buddy_check+0x10c>
  104e86:	c7 44 24 0c 91 7d 10 	movl   $0x107d91,0xc(%esp)
  104e8d:	00 
  104e8e:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104e95:	00 
  104e96:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  104e9d:	00 
  104e9e:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104ea5:	e8 4f b5 ff ff       	call   1003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
  104eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ead:	89 04 24             	mov    %eax,(%esp)
  104eb0:	e8 5f f5 ff ff       	call   104414 <page_ref>
  104eb5:	85 c0                	test   %eax,%eax
  104eb7:	75 1e                	jne    104ed7 <buddy_check+0x139>
  104eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ebc:	89 04 24             	mov    %eax,(%esp)
  104ebf:	e8 50 f5 ff ff       	call   104414 <page_ref>
  104ec4:	85 c0                	test   %eax,%eax
  104ec6:	75 0f                	jne    104ed7 <buddy_check+0x139>
  104ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ecb:	89 04 24             	mov    %eax,(%esp)
  104ece:	e8 41 f5 ff ff       	call   104414 <page_ref>
  104ed3:	85 c0                	test   %eax,%eax
  104ed5:	74 24                	je     104efb <buddy_check+0x15d>
  104ed7:	c7 44 24 0c b0 7d 10 	movl   $0x107db0,0xc(%esp)
  104ede:	00 
  104edf:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104ee6:	00 
  104ee7:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  104eee:	00 
  104eef:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104ef6:	e8 fe b4 ff ff       	call   1003f9 <__panic>
    free_page(p0);
  104efb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f02:	00 
  104f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f06:	89 04 24             	mov    %eax,(%esp)
  104f09:	e8 95 de ff ff       	call   102da3 <free_pages>
    free_page(A);
  104f0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f15:	00 
  104f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f19:	89 04 24             	mov    %eax,(%esp)
  104f1c:	e8 82 de ff ff       	call   102da3 <free_pages>
    free_page(B);
  104f21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f28:	00 
  104f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f2c:	89 04 24             	mov    %eax,(%esp)
  104f2f:	e8 6f de ff ff       	call   102da3 <free_pages>
    
    A=alloc_pages(500);
  104f34:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  104f3b:	e8 2b de ff ff       	call   102d6b <alloc_pages>
  104f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(500);
  104f43:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  104f4a:	e8 1c de ff ff       	call   102d6b <alloc_pages>
  104f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("A %p\n",A);
  104f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f59:	c7 04 24 ea 7d 10 00 	movl   $0x107dea,(%esp)
  104f60:	e8 3d b3 ff ff       	call   1002a2 <cprintf>
    cprintf("B %p\n",B);
  104f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f6c:	c7 04 24 f0 7d 10 00 	movl   $0x107df0,(%esp)
  104f73:	e8 2a b3 ff ff       	call   1002a2 <cprintf>
    free_pages(A,250);
  104f78:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104f7f:	00 
  104f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f83:	89 04 24             	mov    %eax,(%esp)
  104f86:	e8 18 de ff ff       	call   102da3 <free_pages>
    free_pages(B,500);
  104f8b:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104f92:	00 
  104f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f96:	89 04 24             	mov    %eax,(%esp)
  104f99:	e8 05 de ff ff       	call   102da3 <free_pages>
    free_pages(A+250,250);
  104f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fa1:	05 88 13 00 00       	add    $0x1388,%eax
  104fa6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104fad:	00 
  104fae:	89 04 24             	mov    %eax,(%esp)
  104fb1:	e8 ed dd ff ff       	call   102da3 <free_pages>
    
    p0=alloc_pages(1024);
  104fb6:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  104fbd:	e8 a9 dd ff ff       	call   102d6b <alloc_pages>
  104fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("p0 %p\n",p0);
  104fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fcc:	c7 04 24 f6 7d 10 00 	movl   $0x107df6,(%esp)
  104fd3:	e8 ca b2 ff ff       	call   1002a2 <cprintf>
    assert(p0 == A);
  104fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fdb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  104fde:	74 24                	je     105004 <buddy_check+0x266>
  104fe0:	c7 44 24 0c fd 7d 10 	movl   $0x107dfd,0xc(%esp)
  104fe7:	00 
  104fe8:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  104fef:	00 
  104ff0:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  104ff7:	00 
  104ff8:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  104fff:	e8 f5 b3 ff ff       	call   1003f9 <__panic>
    //ÒÔÏÂÊÇ¸ù¾ÝÁ´½ÓÖÐµÄÑùÀý²âÊÔ±àÐ´µÄ
    A=alloc_pages(70);  
  105004:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
  10500b:	e8 5b dd ff ff       	call   102d6b <alloc_pages>
  105010:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(35);
  105013:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  10501a:	e8 4c dd ff ff       	call   102d6b <alloc_pages>
  10501f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(A+128==B);//¼ì²éÊÇ·ñÏàÁÚ
  105022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105025:	05 00 0a 00 00       	add    $0xa00,%eax
  10502a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10502d:	74 24                	je     105053 <buddy_check+0x2b5>
  10502f:	c7 44 24 0c 05 7e 10 	movl   $0x107e05,0xc(%esp)
  105036:	00 
  105037:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  10503e:	00 
  10503f:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  105046:	00 
  105047:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  10504e:	e8 a6 b3 ff ff       	call   1003f9 <__panic>
    cprintf("A %p\n",A);
  105053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105056:	89 44 24 04          	mov    %eax,0x4(%esp)
  10505a:	c7 04 24 ea 7d 10 00 	movl   $0x107dea,(%esp)
  105061:	e8 3c b2 ff ff       	call   1002a2 <cprintf>
    cprintf("B %p\n",B);
  105066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105069:	89 44 24 04          	mov    %eax,0x4(%esp)
  10506d:	c7 04 24 f0 7d 10 00 	movl   $0x107df0,(%esp)
  105074:	e8 29 b2 ff ff       	call   1002a2 <cprintf>
    C=alloc_pages(80);
  105079:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  105080:	e8 e6 dc ff ff       	call   102d6b <alloc_pages>
  105085:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(A+256==C);//¼ì²éCÓÐÃ»ÓÐºÍAÖØµþ
  105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10508b:	05 00 14 00 00       	add    $0x1400,%eax
  105090:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  105093:	74 24                	je     1050b9 <buddy_check+0x31b>
  105095:	c7 44 24 0c 0e 7e 10 	movl   $0x107e0e,0xc(%esp)
  10509c:	00 
  10509d:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  1050a4:	00 
  1050a5:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  1050ac:	00 
  1050ad:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  1050b4:	e8 40 b3 ff ff       	call   1003f9 <__panic>
    cprintf("C %p\n",C);
  1050b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050c0:	c7 04 24 17 7e 10 00 	movl   $0x107e17,(%esp)
  1050c7:	e8 d6 b1 ff ff       	call   1002a2 <cprintf>
    free_pages(A,70);//ÊÍ·ÅA
  1050cc:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1050d3:	00 
  1050d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050d7:	89 04 24             	mov    %eax,(%esp)
  1050da:	e8 c4 dc ff ff       	call   102da3 <free_pages>
    cprintf("B %p\n",B);
  1050df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050e6:	c7 04 24 f0 7d 10 00 	movl   $0x107df0,(%esp)
  1050ed:	e8 b0 b1 ff ff       	call   1002a2 <cprintf>
    D=alloc_pages(60);
  1050f2:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
  1050f9:	e8 6d dc ff ff       	call   102d6b <alloc_pages>
  1050fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n",D);
  105101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105104:	89 44 24 04          	mov    %eax,0x4(%esp)
  105108:	c7 04 24 1d 7e 10 00 	movl   $0x107e1d,(%esp)
  10510f:	e8 8e b1 ff ff       	call   1002a2 <cprintf>
    assert(B+64==D);//¼ì²éB£¬DÊÇ·ñÏàÁÚ
  105114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105117:	05 00 05 00 00       	add    $0x500,%eax
  10511c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10511f:	74 24                	je     105145 <buddy_check+0x3a7>
  105121:	c7 44 24 0c 23 7e 10 	movl   $0x107e23,0xc(%esp)
  105128:	00 
  105129:	c7 44 24 08 dc 7c 10 	movl   $0x107cdc,0x8(%esp)
  105130:	00 
  105131:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  105138:	00 
  105139:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  105140:	e8 b4 b2 ff ff       	call   1003f9 <__panic>
    free_pages(B,35);
  105145:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  10514c:	00 
  10514d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105150:	89 04 24             	mov    %eax,(%esp)
  105153:	e8 4b dc ff ff       	call   102da3 <free_pages>
    cprintf("D %p\n",D);
  105158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10515b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10515f:	c7 04 24 1d 7e 10 00 	movl   $0x107e1d,(%esp)
  105166:	e8 37 b1 ff ff       	call   1002a2 <cprintf>
    free_pages(D,60);
  10516b:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  105172:	00 
  105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105176:	89 04 24             	mov    %eax,(%esp)
  105179:	e8 25 dc ff ff       	call   102da3 <free_pages>
    cprintf("C %p\n",C);
  10517e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105181:	89 44 24 04          	mov    %eax,0x4(%esp)
  105185:	c7 04 24 17 7e 10 00 	movl   $0x107e17,(%esp)
  10518c:	e8 11 b1 ff ff       	call   1002a2 <cprintf>
    free_pages(C,80);
  105191:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  105198:	00 
  105199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10519c:	89 04 24             	mov    %eax,(%esp)
  10519f:	e8 ff db ff ff       	call   102da3 <free_pages>
    free_pages(p0,1000);//È«²¿ÊÍ·Å
  1051a4:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  1051ab:	00 
  1051ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051af:	89 04 24             	mov    %eax,(%esp)
  1051b2:	e8 ec db ff ff       	call   102da3 <free_pages>
}
  1051b7:	90                   	nop
  1051b8:	c9                   	leave  
  1051b9:	c3                   	ret    

001051ba <page2ppn>:
page2ppn(struct Page *page) {
  1051ba:	55                   	push   %ebp
  1051bb:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1051bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1051c0:	8b 15 78 df 11 00    	mov    0x11df78,%edx
  1051c6:	29 d0                	sub    %edx,%eax
  1051c8:	c1 f8 02             	sar    $0x2,%eax
  1051cb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1051d1:	5d                   	pop    %ebp
  1051d2:	c3                   	ret    

001051d3 <page2pa>:
page2pa(struct Page *page) {
  1051d3:	55                   	push   %ebp
  1051d4:	89 e5                	mov    %esp,%ebp
  1051d6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1051d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051dc:	89 04 24             	mov    %eax,(%esp)
  1051df:	e8 d6 ff ff ff       	call   1051ba <page2ppn>
  1051e4:	c1 e0 0c             	shl    $0xc,%eax
}
  1051e7:	c9                   	leave  
  1051e8:	c3                   	ret    

001051e9 <page_ref>:
page_ref(struct Page *page) {
  1051e9:	55                   	push   %ebp
  1051ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1051ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1051ef:	8b 00                	mov    (%eax),%eax
}
  1051f1:	5d                   	pop    %ebp
  1051f2:	c3                   	ret    

001051f3 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1051f3:	55                   	push   %ebp
  1051f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1051f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1051fc:	89 10                	mov    %edx,(%eax)
}
  1051fe:	90                   	nop
  1051ff:	5d                   	pop    %ebp
  105200:	c3                   	ret    

00105201 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  105201:	55                   	push   %ebp
  105202:	89 e5                	mov    %esp,%ebp
  105204:	83 ec 10             	sub    $0x10,%esp
  105207:	c7 45 fc a0 a3 1b 00 	movl   $0x1ba3a0,-0x4(%ebp)
    elm->prev = elm->next = elm;
  10520e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105211:	8b 55 fc             	mov    -0x4(%ebp),%edx
  105214:	89 50 04             	mov    %edx,0x4(%eax)
  105217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10521a:	8b 50 04             	mov    0x4(%eax),%edx
  10521d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105220:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  105222:	c7 05 a8 a3 1b 00 00 	movl   $0x0,0x1ba3a8
  105229:	00 00 00 
}
  10522c:	90                   	nop
  10522d:	c9                   	leave  
  10522e:	c3                   	ret    

0010522f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10522f:	55                   	push   %ebp
  105230:	89 e5                	mov    %esp,%ebp
  105232:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  105235:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105239:	75 24                	jne    10525f <default_init_memmap+0x30>
  10523b:	c7 44 24 0c 5c 7e 10 	movl   $0x107e5c,0xc(%esp)
  105242:	00 
  105243:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  10524a:	00 
  10524b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  105252:	00 
  105253:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  10525a:	e8 9a b1 ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  10525f:	8b 45 08             	mov    0x8(%ebp),%eax
  105262:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  105265:	eb 7d                	jmp    1052e4 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  105267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10526a:	83 c0 04             	add    $0x4,%eax
  10526d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  105274:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10527a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10527d:	0f a3 10             	bt     %edx,(%eax)
  105280:	19 c0                	sbb    %eax,%eax
  105282:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  105285:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105289:	0f 95 c0             	setne  %al
  10528c:	0f b6 c0             	movzbl %al,%eax
  10528f:	85 c0                	test   %eax,%eax
  105291:	75 24                	jne    1052b7 <default_init_memmap+0x88>
  105293:	c7 44 24 0c 8d 7e 10 	movl   $0x107e8d,0xc(%esp)
  10529a:	00 
  10529b:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1052a2:	00 
  1052a3:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1052aa:	00 
  1052ab:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1052b2:	e8 42 b1 ff ff       	call   1003f9 <__panic>
        p->flags = p->property = 0;
  1052b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1052c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052c4:	8b 50 08             	mov    0x8(%eax),%edx
  1052c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052ca:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1052cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052d4:	00 
  1052d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052d8:	89 04 24             	mov    %eax,(%esp)
  1052db:	e8 13 ff ff ff       	call   1051f3 <set_page_ref>
    for (; p != base + n; p ++) {
  1052e0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1052e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1052e7:	89 d0                	mov    %edx,%eax
  1052e9:	c1 e0 02             	shl    $0x2,%eax
  1052ec:	01 d0                	add    %edx,%eax
  1052ee:	c1 e0 02             	shl    $0x2,%eax
  1052f1:	89 c2                	mov    %eax,%edx
  1052f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f6:	01 d0                	add    %edx,%eax
  1052f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1052fb:	0f 85 66 ff ff ff    	jne    105267 <default_init_memmap+0x38>
    }
    base->property = n;
  105301:	8b 45 08             	mov    0x8(%ebp),%eax
  105304:	8b 55 0c             	mov    0xc(%ebp),%edx
  105307:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10530a:	8b 45 08             	mov    0x8(%ebp),%eax
  10530d:	83 c0 04             	add    $0x4,%eax
  105310:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105317:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10531a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10531d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105320:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  105323:	8b 15 a8 a3 1b 00    	mov    0x1ba3a8,%edx
  105329:	8b 45 0c             	mov    0xc(%ebp),%eax
  10532c:	01 d0                	add    %edx,%eax
  10532e:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
    list_add_before(&free_list, &(base->page_link));
  105333:	8b 45 08             	mov    0x8(%ebp),%eax
  105336:	83 c0 0c             	add    $0xc,%eax
  105339:	c7 45 e4 a0 a3 1b 00 	movl   $0x1ba3a0,-0x1c(%ebp)
  105340:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm->prev, listelm);
  105343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105346:	8b 00                	mov    (%eax),%eax
  105348:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10534b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10534e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105354:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
  105357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10535a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10535d:	89 10                	mov    %edx,(%eax)
  10535f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105362:	8b 10                	mov    (%eax),%edx
  105364:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105367:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10536a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10536d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105370:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105373:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105376:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105379:	89 10                	mov    %edx,(%eax)
}
  10537b:	90                   	nop
  10537c:	c9                   	leave  
  10537d:	c3                   	ret    

0010537e <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10537e:	55                   	push   %ebp
  10537f:	89 e5                	mov    %esp,%ebp
  105381:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  105384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105388:	75 24                	jne    1053ae <default_alloc_pages+0x30>
  10538a:	c7 44 24 0c 5c 7e 10 	movl   $0x107e5c,0xc(%esp)
  105391:	00 
  105392:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105399:	00 
  10539a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1053a1:	00 
  1053a2:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1053a9:	e8 4b b0 ff ff       	call   1003f9 <__panic>
    if (n > nr_free) {
  1053ae:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  1053b3:	39 45 08             	cmp    %eax,0x8(%ebp)
  1053b6:	76 0a                	jbe    1053c2 <default_alloc_pages+0x44>
        return NULL;
  1053b8:	b8 00 00 00 00       	mov    $0x0,%eax
  1053bd:	e9 3d 01 00 00       	jmp    1054ff <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  1053c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1053c9:	c7 45 f0 a0 a3 1b 00 	movl   $0x1ba3a0,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  1053d0:	eb 1c                	jmp    1053ee <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  1053d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053d5:	83 e8 0c             	sub    $0xc,%eax
  1053d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1053db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053de:	8b 40 08             	mov    0x8(%eax),%eax
  1053e1:	39 45 08             	cmp    %eax,0x8(%ebp)
  1053e4:	77 08                	ja     1053ee <default_alloc_pages+0x70>
            page = p;
  1053e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1053ec:	eb 18                	jmp    105406 <default_alloc_pages+0x88>
  1053ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1053f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053f7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1053fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053fd:	81 7d f0 a0 a3 1b 00 	cmpl   $0x1ba3a0,-0x10(%ebp)
  105404:	75 cc                	jne    1053d2 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  105406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10540a:	0f 84 ec 00 00 00    	je     1054fc <default_alloc_pages+0x17e>
        if (page->property > n) {
  105410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105413:	8b 40 08             	mov    0x8(%eax),%eax
  105416:	39 45 08             	cmp    %eax,0x8(%ebp)
  105419:	0f 83 8c 00 00 00    	jae    1054ab <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  10541f:	8b 55 08             	mov    0x8(%ebp),%edx
  105422:	89 d0                	mov    %edx,%eax
  105424:	c1 e0 02             	shl    $0x2,%eax
  105427:	01 d0                	add    %edx,%eax
  105429:	c1 e0 02             	shl    $0x2,%eax
  10542c:	89 c2                	mov    %eax,%edx
  10542e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105431:	01 d0                	add    %edx,%eax
  105433:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  105436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105439:	8b 40 08             	mov    0x8(%eax),%eax
  10543c:	2b 45 08             	sub    0x8(%ebp),%eax
  10543f:	89 c2                	mov    %eax,%edx
  105441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105444:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  105447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10544a:	83 c0 04             	add    $0x4,%eax
  10544d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  105454:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105457:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10545a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10545d:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  105460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105463:	83 c0 0c             	add    $0xc,%eax
  105466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105469:	83 c2 0c             	add    $0xc,%edx
  10546c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10546f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  105472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105475:	8b 40 04             	mov    0x4(%eax),%eax
  105478:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10547b:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10547e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105481:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105484:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  105487:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10548a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10548d:	89 10                	mov    %edx,(%eax)
  10548f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105492:	8b 10                	mov    (%eax),%edx
  105494:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105497:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10549a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10549d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1054a0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1054a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054a9:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  1054ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054ae:	83 c0 0c             	add    $0xc,%eax
  1054b1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1054b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1054b7:	8b 40 04             	mov    0x4(%eax),%eax
  1054ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1054bd:	8b 12                	mov    (%edx),%edx
  1054bf:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1054c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1054c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1054c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1054cb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1054ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1054d1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1054d4:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  1054d6:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  1054db:	2b 45 08             	sub    0x8(%ebp),%eax
  1054de:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
        ClearPageProperty(page);
  1054e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054e6:	83 c0 04             	add    $0x4,%eax
  1054e9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1054f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1054f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1054f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1054f9:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  1054fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1054ff:	c9                   	leave  
  105500:	c3                   	ret    

00105501 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  105501:	55                   	push   %ebp
  105502:	89 e5                	mov    %esp,%ebp
  105504:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  10550a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10550e:	75 24                	jne    105534 <default_free_pages+0x33>
  105510:	c7 44 24 0c 5c 7e 10 	movl   $0x107e5c,0xc(%esp)
  105517:	00 
  105518:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  10551f:	00 
  105520:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  105527:	00 
  105528:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  10552f:	e8 c5 ae ff ff       	call   1003f9 <__panic>
    struct Page *p = base;
  105534:	8b 45 08             	mov    0x8(%ebp),%eax
  105537:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10553a:	e9 9d 00 00 00       	jmp    1055dc <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  10553f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105542:	83 c0 04             	add    $0x4,%eax
  105545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10554c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10554f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105552:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105555:	0f a3 10             	bt     %edx,(%eax)
  105558:	19 c0                	sbb    %eax,%eax
  10555a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  10555d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105561:	0f 95 c0             	setne  %al
  105564:	0f b6 c0             	movzbl %al,%eax
  105567:	85 c0                	test   %eax,%eax
  105569:	75 2c                	jne    105597 <default_free_pages+0x96>
  10556b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10556e:	83 c0 04             	add    $0x4,%eax
  105571:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  105578:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10557b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10557e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105581:	0f a3 10             	bt     %edx,(%eax)
  105584:	19 c0                	sbb    %eax,%eax
  105586:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  105589:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10558d:	0f 95 c0             	setne  %al
  105590:	0f b6 c0             	movzbl %al,%eax
  105593:	85 c0                	test   %eax,%eax
  105595:	74 24                	je     1055bb <default_free_pages+0xba>
  105597:	c7 44 24 0c a0 7e 10 	movl   $0x107ea0,0xc(%esp)
  10559e:	00 
  10559f:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1055a6:	00 
  1055a7:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  1055ae:	00 
  1055af:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1055b6:	e8 3e ae ff ff       	call   1003f9 <__panic>
        p->flags = 0;
  1055bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1055c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1055cc:	00 
  1055cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d0:	89 04 24             	mov    %eax,(%esp)
  1055d3:	e8 1b fc ff ff       	call   1051f3 <set_page_ref>
    for (; p != base + n; p ++) {
  1055d8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1055dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055df:	89 d0                	mov    %edx,%eax
  1055e1:	c1 e0 02             	shl    $0x2,%eax
  1055e4:	01 d0                	add    %edx,%eax
  1055e6:	c1 e0 02             	shl    $0x2,%eax
  1055e9:	89 c2                	mov    %eax,%edx
  1055eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ee:	01 d0                	add    %edx,%eax
  1055f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1055f3:	0f 85 46 ff ff ff    	jne    10553f <default_free_pages+0x3e>
    }
    base->property = n;
  1055f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055ff:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  105602:	8b 45 08             	mov    0x8(%ebp),%eax
  105605:	83 c0 04             	add    $0x4,%eax
  105608:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10560f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105612:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105615:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105618:	0f ab 10             	bts    %edx,(%eax)
  10561b:	c7 45 d4 a0 a3 1b 00 	movl   $0x1ba3a0,-0x2c(%ebp)
    return listelm->next;
  105622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105625:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  105628:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10562b:	e9 08 01 00 00       	jmp    105738 <default_free_pages+0x237>
        p = le2page(le, page_link);
  105630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105633:	83 e8 0c             	sub    $0xc,%eax
  105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10563c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10563f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105642:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  105645:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  105648:	8b 45 08             	mov    0x8(%ebp),%eax
  10564b:	8b 50 08             	mov    0x8(%eax),%edx
  10564e:	89 d0                	mov    %edx,%eax
  105650:	c1 e0 02             	shl    $0x2,%eax
  105653:	01 d0                	add    %edx,%eax
  105655:	c1 e0 02             	shl    $0x2,%eax
  105658:	89 c2                	mov    %eax,%edx
  10565a:	8b 45 08             	mov    0x8(%ebp),%eax
  10565d:	01 d0                	add    %edx,%eax
  10565f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105662:	75 5a                	jne    1056be <default_free_pages+0x1bd>
            base->property += p->property;
  105664:	8b 45 08             	mov    0x8(%ebp),%eax
  105667:	8b 50 08             	mov    0x8(%eax),%edx
  10566a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10566d:	8b 40 08             	mov    0x8(%eax),%eax
  105670:	01 c2                	add    %eax,%edx
  105672:	8b 45 08             	mov    0x8(%ebp),%eax
  105675:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  105678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10567b:	83 c0 04             	add    $0x4,%eax
  10567e:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  105685:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105688:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10568b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10568e:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  105691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105694:	83 c0 0c             	add    $0xc,%eax
  105697:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  10569a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10569d:	8b 40 04             	mov    0x4(%eax),%eax
  1056a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1056a3:	8b 12                	mov    (%edx),%edx
  1056a5:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1056a8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  1056ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1056ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1056b1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1056b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1056b7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1056ba:	89 10                	mov    %edx,(%eax)
  1056bc:	eb 7a                	jmp    105738 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  1056be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056c1:	8b 50 08             	mov    0x8(%eax),%edx
  1056c4:	89 d0                	mov    %edx,%eax
  1056c6:	c1 e0 02             	shl    $0x2,%eax
  1056c9:	01 d0                	add    %edx,%eax
  1056cb:	c1 e0 02             	shl    $0x2,%eax
  1056ce:	89 c2                	mov    %eax,%edx
  1056d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056d3:	01 d0                	add    %edx,%eax
  1056d5:	39 45 08             	cmp    %eax,0x8(%ebp)
  1056d8:	75 5e                	jne    105738 <default_free_pages+0x237>
            p->property += base->property;
  1056da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056dd:	8b 50 08             	mov    0x8(%eax),%edx
  1056e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e3:	8b 40 08             	mov    0x8(%eax),%eax
  1056e6:	01 c2                	add    %eax,%edx
  1056e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056eb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1056ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f1:	83 c0 04             	add    $0x4,%eax
  1056f4:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1056fb:	89 45 a0             	mov    %eax,-0x60(%ebp)
  1056fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105701:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  105704:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  105707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10570a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10570d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105710:	83 c0 0c             	add    $0xc,%eax
  105713:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  105716:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105719:	8b 40 04             	mov    0x4(%eax),%eax
  10571c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10571f:	8b 12                	mov    (%edx),%edx
  105721:	89 55 ac             	mov    %edx,-0x54(%ebp)
  105724:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  105727:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10572a:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10572d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105730:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105733:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105736:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  105738:	81 7d f0 a0 a3 1b 00 	cmpl   $0x1ba3a0,-0x10(%ebp)
  10573f:	0f 85 eb fe ff ff    	jne    105630 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  105745:	8b 15 a8 a3 1b 00    	mov    0x1ba3a8,%edx
  10574b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10574e:	01 d0                	add    %edx,%eax
  105750:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8
  105755:	c7 45 9c a0 a3 1b 00 	movl   $0x1ba3a0,-0x64(%ebp)
    return listelm->next;
  10575c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10575f:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  105762:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  105765:	eb 74                	jmp    1057db <default_free_pages+0x2da>
        p = le2page(le, page_link);
  105767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10576a:	83 e8 0c             	sub    $0xc,%eax
  10576d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  105770:	8b 45 08             	mov    0x8(%ebp),%eax
  105773:	8b 50 08             	mov    0x8(%eax),%edx
  105776:	89 d0                	mov    %edx,%eax
  105778:	c1 e0 02             	shl    $0x2,%eax
  10577b:	01 d0                	add    %edx,%eax
  10577d:	c1 e0 02             	shl    $0x2,%eax
  105780:	89 c2                	mov    %eax,%edx
  105782:	8b 45 08             	mov    0x8(%ebp),%eax
  105785:	01 d0                	add    %edx,%eax
  105787:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10578a:	72 40                	jb     1057cc <default_free_pages+0x2cb>
            assert(base + base->property != p);
  10578c:	8b 45 08             	mov    0x8(%ebp),%eax
  10578f:	8b 50 08             	mov    0x8(%eax),%edx
  105792:	89 d0                	mov    %edx,%eax
  105794:	c1 e0 02             	shl    $0x2,%eax
  105797:	01 d0                	add    %edx,%eax
  105799:	c1 e0 02             	shl    $0x2,%eax
  10579c:	89 c2                	mov    %eax,%edx
  10579e:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a1:	01 d0                	add    %edx,%eax
  1057a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1057a6:	75 3e                	jne    1057e6 <default_free_pages+0x2e5>
  1057a8:	c7 44 24 0c c5 7e 10 	movl   $0x107ec5,0xc(%esp)
  1057af:	00 
  1057b0:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1057b7:	00 
  1057b8:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  1057bf:	00 
  1057c0:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1057c7:	e8 2d ac ff ff       	call   1003f9 <__panic>
  1057cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057cf:	89 45 98             	mov    %eax,-0x68(%ebp)
  1057d2:	8b 45 98             	mov    -0x68(%ebp),%eax
  1057d5:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  1057d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1057db:	81 7d f0 a0 a3 1b 00 	cmpl   $0x1ba3a0,-0x10(%ebp)
  1057e2:	75 83                	jne    105767 <default_free_pages+0x266>
  1057e4:	eb 01                	jmp    1057e7 <default_free_pages+0x2e6>
            break;
  1057e6:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  1057e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ea:	8d 50 0c             	lea    0xc(%eax),%edx
  1057ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057f0:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1057f3:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1057f6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1057f9:	8b 00                	mov    (%eax),%eax
  1057fb:	8b 55 90             	mov    -0x70(%ebp),%edx
  1057fe:	89 55 8c             	mov    %edx,-0x74(%ebp)
  105801:	89 45 88             	mov    %eax,-0x78(%ebp)
  105804:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105807:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  10580a:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10580d:	8b 55 8c             	mov    -0x74(%ebp),%edx
  105810:	89 10                	mov    %edx,(%eax)
  105812:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105815:	8b 10                	mov    (%eax),%edx
  105817:	8b 45 88             	mov    -0x78(%ebp),%eax
  10581a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10581d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105820:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105823:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105826:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105829:	8b 55 88             	mov    -0x78(%ebp),%edx
  10582c:	89 10                	mov    %edx,(%eax)
}
  10582e:	90                   	nop
  10582f:	c9                   	leave  
  105830:	c3                   	ret    

00105831 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  105831:	55                   	push   %ebp
  105832:	89 e5                	mov    %esp,%ebp
    return nr_free;
  105834:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
}
  105839:	5d                   	pop    %ebp
  10583a:	c3                   	ret    

0010583b <basic_check>:

static void
basic_check(void) {
  10583b:	55                   	push   %ebp
  10583c:	89 e5                	mov    %esp,%ebp
  10583e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  105841:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10584b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105851:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  105854:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10585b:	e8 0b d5 ff ff       	call   102d6b <alloc_pages>
  105860:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105863:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105867:	75 24                	jne    10588d <basic_check+0x52>
  105869:	c7 44 24 0c e0 7e 10 	movl   $0x107ee0,0xc(%esp)
  105870:	00 
  105871:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105878:	00 
  105879:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  105880:	00 
  105881:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105888:	e8 6c ab ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10588d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105894:	e8 d2 d4 ff ff       	call   102d6b <alloc_pages>
  105899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10589c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058a0:	75 24                	jne    1058c6 <basic_check+0x8b>
  1058a2:	c7 44 24 0c fc 7e 10 	movl   $0x107efc,0xc(%esp)
  1058a9:	00 
  1058aa:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1058b1:	00 
  1058b2:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  1058b9:	00 
  1058ba:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1058c1:	e8 33 ab ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1058c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1058cd:	e8 99 d4 ff ff       	call   102d6b <alloc_pages>
  1058d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1058d9:	75 24                	jne    1058ff <basic_check+0xc4>
  1058db:	c7 44 24 0c 18 7f 10 	movl   $0x107f18,0xc(%esp)
  1058e2:	00 
  1058e3:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1058ea:	00 
  1058eb:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1058f2:	00 
  1058f3:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1058fa:	e8 fa aa ff ff       	call   1003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1058ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105902:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  105905:	74 10                	je     105917 <basic_check+0xdc>
  105907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10590a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10590d:	74 08                	je     105917 <basic_check+0xdc>
  10590f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105912:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105915:	75 24                	jne    10593b <basic_check+0x100>
  105917:	c7 44 24 0c 34 7f 10 	movl   $0x107f34,0xc(%esp)
  10591e:	00 
  10591f:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105926:	00 
  105927:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  10592e:	00 
  10592f:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105936:	e8 be aa ff ff       	call   1003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10593b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10593e:	89 04 24             	mov    %eax,(%esp)
  105941:	e8 a3 f8 ff ff       	call   1051e9 <page_ref>
  105946:	85 c0                	test   %eax,%eax
  105948:	75 1e                	jne    105968 <basic_check+0x12d>
  10594a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10594d:	89 04 24             	mov    %eax,(%esp)
  105950:	e8 94 f8 ff ff       	call   1051e9 <page_ref>
  105955:	85 c0                	test   %eax,%eax
  105957:	75 0f                	jne    105968 <basic_check+0x12d>
  105959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10595c:	89 04 24             	mov    %eax,(%esp)
  10595f:	e8 85 f8 ff ff       	call   1051e9 <page_ref>
  105964:	85 c0                	test   %eax,%eax
  105966:	74 24                	je     10598c <basic_check+0x151>
  105968:	c7 44 24 0c 58 7f 10 	movl   $0x107f58,0xc(%esp)
  10596f:	00 
  105970:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105977:	00 
  105978:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  10597f:	00 
  105980:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105987:	e8 6d aa ff ff       	call   1003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10598c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10598f:	89 04 24             	mov    %eax,(%esp)
  105992:	e8 3c f8 ff ff       	call   1051d3 <page2pa>
  105997:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  10599d:	c1 e2 0c             	shl    $0xc,%edx
  1059a0:	39 d0                	cmp    %edx,%eax
  1059a2:	72 24                	jb     1059c8 <basic_check+0x18d>
  1059a4:	c7 44 24 0c 94 7f 10 	movl   $0x107f94,0xc(%esp)
  1059ab:	00 
  1059ac:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1059b3:	00 
  1059b4:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1059bb:	00 
  1059bc:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1059c3:	e8 31 aa ff ff       	call   1003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1059c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059cb:	89 04 24             	mov    %eax,(%esp)
  1059ce:	e8 00 f8 ff ff       	call   1051d3 <page2pa>
  1059d3:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  1059d9:	c1 e2 0c             	shl    $0xc,%edx
  1059dc:	39 d0                	cmp    %edx,%eax
  1059de:	72 24                	jb     105a04 <basic_check+0x1c9>
  1059e0:	c7 44 24 0c b1 7f 10 	movl   $0x107fb1,0xc(%esp)
  1059e7:	00 
  1059e8:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1059ef:	00 
  1059f0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1059f7:	00 
  1059f8:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1059ff:	e8 f5 a9 ff ff       	call   1003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  105a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a07:	89 04 24             	mov    %eax,(%esp)
  105a0a:	e8 c4 f7 ff ff       	call   1051d3 <page2pa>
  105a0f:	8b 15 80 de 11 00    	mov    0x11de80,%edx
  105a15:	c1 e2 0c             	shl    $0xc,%edx
  105a18:	39 d0                	cmp    %edx,%eax
  105a1a:	72 24                	jb     105a40 <basic_check+0x205>
  105a1c:	c7 44 24 0c ce 7f 10 	movl   $0x107fce,0xc(%esp)
  105a23:	00 
  105a24:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105a2b:	00 
  105a2c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  105a33:	00 
  105a34:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105a3b:	e8 b9 a9 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  105a40:	a1 a0 a3 1b 00       	mov    0x1ba3a0,%eax
  105a45:	8b 15 a4 a3 1b 00    	mov    0x1ba3a4,%edx
  105a4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105a4e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105a51:	c7 45 dc a0 a3 1b 00 	movl   $0x1ba3a0,-0x24(%ebp)
    elm->prev = elm->next = elm;
  105a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105a5e:	89 50 04             	mov    %edx,0x4(%eax)
  105a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a64:	8b 50 04             	mov    0x4(%eax),%edx
  105a67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a6a:	89 10                	mov    %edx,(%eax)
  105a6c:	c7 45 e0 a0 a3 1b 00 	movl   $0x1ba3a0,-0x20(%ebp)
    return list->next == list;
  105a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a76:	8b 40 04             	mov    0x4(%eax),%eax
  105a79:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105a7c:	0f 94 c0             	sete   %al
  105a7f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105a82:	85 c0                	test   %eax,%eax
  105a84:	75 24                	jne    105aaa <basic_check+0x26f>
  105a86:	c7 44 24 0c eb 7f 10 	movl   $0x107feb,0xc(%esp)
  105a8d:	00 
  105a8e:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105a95:	00 
  105a96:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  105a9d:	00 
  105a9e:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105aa5:	e8 4f a9 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  105aaa:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  105aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  105ab2:	c7 05 a8 a3 1b 00 00 	movl   $0x0,0x1ba3a8
  105ab9:	00 00 00 

    assert(alloc_page() == NULL);
  105abc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105ac3:	e8 a3 d2 ff ff       	call   102d6b <alloc_pages>
  105ac8:	85 c0                	test   %eax,%eax
  105aca:	74 24                	je     105af0 <basic_check+0x2b5>
  105acc:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  105ad3:	00 
  105ad4:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105adb:	00 
  105adc:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  105ae3:	00 
  105ae4:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105aeb:	e8 09 a9 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  105af0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105af7:	00 
  105af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105afb:	89 04 24             	mov    %eax,(%esp)
  105afe:	e8 a0 d2 ff ff       	call   102da3 <free_pages>
    free_page(p1);
  105b03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105b0a:	00 
  105b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b0e:	89 04 24             	mov    %eax,(%esp)
  105b11:	e8 8d d2 ff ff       	call   102da3 <free_pages>
    free_page(p2);
  105b16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105b1d:	00 
  105b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b21:	89 04 24             	mov    %eax,(%esp)
  105b24:	e8 7a d2 ff ff       	call   102da3 <free_pages>
    assert(nr_free == 3);
  105b29:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  105b2e:	83 f8 03             	cmp    $0x3,%eax
  105b31:	74 24                	je     105b57 <basic_check+0x31c>
  105b33:	c7 44 24 0c 17 80 10 	movl   $0x108017,0xc(%esp)
  105b3a:	00 
  105b3b:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105b42:	00 
  105b43:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  105b4a:	00 
  105b4b:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105b52:	e8 a2 a8 ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  105b57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105b5e:	e8 08 d2 ff ff       	call   102d6b <alloc_pages>
  105b63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105b6a:	75 24                	jne    105b90 <basic_check+0x355>
  105b6c:	c7 44 24 0c e0 7e 10 	movl   $0x107ee0,0xc(%esp)
  105b73:	00 
  105b74:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105b7b:	00 
  105b7c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  105b83:	00 
  105b84:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105b8b:	e8 69 a8 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  105b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105b97:	e8 cf d1 ff ff       	call   102d6b <alloc_pages>
  105b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105ba3:	75 24                	jne    105bc9 <basic_check+0x38e>
  105ba5:	c7 44 24 0c fc 7e 10 	movl   $0x107efc,0xc(%esp)
  105bac:	00 
  105bad:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105bb4:	00 
  105bb5:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  105bbc:	00 
  105bbd:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105bc4:	e8 30 a8 ff ff       	call   1003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  105bc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105bd0:	e8 96 d1 ff ff       	call   102d6b <alloc_pages>
  105bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105bdc:	75 24                	jne    105c02 <basic_check+0x3c7>
  105bde:	c7 44 24 0c 18 7f 10 	movl   $0x107f18,0xc(%esp)
  105be5:	00 
  105be6:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105bed:	00 
  105bee:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  105bf5:	00 
  105bf6:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105bfd:	e8 f7 a7 ff ff       	call   1003f9 <__panic>

    assert(alloc_page() == NULL);
  105c02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c09:	e8 5d d1 ff ff       	call   102d6b <alloc_pages>
  105c0e:	85 c0                	test   %eax,%eax
  105c10:	74 24                	je     105c36 <basic_check+0x3fb>
  105c12:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  105c19:	00 
  105c1a:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105c21:	00 
  105c22:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  105c29:	00 
  105c2a:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105c31:	e8 c3 a7 ff ff       	call   1003f9 <__panic>

    free_page(p0);
  105c36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105c3d:	00 
  105c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c41:	89 04 24             	mov    %eax,(%esp)
  105c44:	e8 5a d1 ff ff       	call   102da3 <free_pages>
  105c49:	c7 45 d8 a0 a3 1b 00 	movl   $0x1ba3a0,-0x28(%ebp)
  105c50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c53:	8b 40 04             	mov    0x4(%eax),%eax
  105c56:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105c59:	0f 94 c0             	sete   %al
  105c5c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  105c5f:	85 c0                	test   %eax,%eax
  105c61:	74 24                	je     105c87 <basic_check+0x44c>
  105c63:	c7 44 24 0c 24 80 10 	movl   $0x108024,0xc(%esp)
  105c6a:	00 
  105c6b:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105c72:	00 
  105c73:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  105c7a:	00 
  105c7b:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105c82:	e8 72 a7 ff ff       	call   1003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  105c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c8e:	e8 d8 d0 ff ff       	call   102d6b <alloc_pages>
  105c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105c9c:	74 24                	je     105cc2 <basic_check+0x487>
  105c9e:	c7 44 24 0c 3c 80 10 	movl   $0x10803c,0xc(%esp)
  105ca5:	00 
  105ca6:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105cad:	00 
  105cae:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  105cb5:	00 
  105cb6:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105cbd:	e8 37 a7 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  105cc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105cc9:	e8 9d d0 ff ff       	call   102d6b <alloc_pages>
  105cce:	85 c0                	test   %eax,%eax
  105cd0:	74 24                	je     105cf6 <basic_check+0x4bb>
  105cd2:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  105cd9:	00 
  105cda:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105ce1:	00 
  105ce2:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  105ce9:	00 
  105cea:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105cf1:	e8 03 a7 ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  105cf6:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  105cfb:	85 c0                	test   %eax,%eax
  105cfd:	74 24                	je     105d23 <basic_check+0x4e8>
  105cff:	c7 44 24 0c 55 80 10 	movl   $0x108055,0xc(%esp)
  105d06:	00 
  105d07:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105d0e:	00 
  105d0f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  105d16:	00 
  105d17:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105d1e:	e8 d6 a6 ff ff       	call   1003f9 <__panic>
    free_list = free_list_store;
  105d23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105d26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105d29:	a3 a0 a3 1b 00       	mov    %eax,0x1ba3a0
  105d2e:	89 15 a4 a3 1b 00    	mov    %edx,0x1ba3a4
    nr_free = nr_free_store;
  105d34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d37:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8

    free_page(p);
  105d3c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105d43:	00 
  105d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d47:	89 04 24             	mov    %eax,(%esp)
  105d4a:	e8 54 d0 ff ff       	call   102da3 <free_pages>
    free_page(p1);
  105d4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105d56:	00 
  105d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d5a:	89 04 24             	mov    %eax,(%esp)
  105d5d:	e8 41 d0 ff ff       	call   102da3 <free_pages>
    free_page(p2);
  105d62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105d69:	00 
  105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d6d:	89 04 24             	mov    %eax,(%esp)
  105d70:	e8 2e d0 ff ff       	call   102da3 <free_pages>
}
  105d75:	90                   	nop
  105d76:	c9                   	leave  
  105d77:	c3                   	ret    

00105d78 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  105d78:	55                   	push   %ebp
  105d79:	89 e5                	mov    %esp,%ebp
  105d7b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  105d81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105d8f:	c7 45 ec a0 a3 1b 00 	movl   $0x1ba3a0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105d96:	eb 6a                	jmp    105e02 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  105d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d9b:	83 e8 0c             	sub    $0xc,%eax
  105d9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  105da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105da4:	83 c0 04             	add    $0x4,%eax
  105da7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105dae:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105db4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105db7:	0f a3 10             	bt     %edx,(%eax)
  105dba:	19 c0                	sbb    %eax,%eax
  105dbc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  105dbf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  105dc3:	0f 95 c0             	setne  %al
  105dc6:	0f b6 c0             	movzbl %al,%eax
  105dc9:	85 c0                	test   %eax,%eax
  105dcb:	75 24                	jne    105df1 <default_check+0x79>
  105dcd:	c7 44 24 0c 62 80 10 	movl   $0x108062,0xc(%esp)
  105dd4:	00 
  105dd5:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105ddc:	00 
  105ddd:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  105de4:	00 
  105de5:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105dec:	e8 08 a6 ff ff       	call   1003f9 <__panic>
        count ++, total += p->property;
  105df1:	ff 45 f4             	incl   -0xc(%ebp)
  105df4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105df7:	8b 50 08             	mov    0x8(%eax),%edx
  105dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dfd:	01 d0                	add    %edx,%eax
  105dff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105e08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105e0b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e11:	81 7d ec a0 a3 1b 00 	cmpl   $0x1ba3a0,-0x14(%ebp)
  105e18:	0f 85 7a ff ff ff    	jne    105d98 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  105e1e:	e8 b3 cf ff ff       	call   102dd6 <nr_free_pages>
  105e23:	89 c2                	mov    %eax,%edx
  105e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e28:	39 c2                	cmp    %eax,%edx
  105e2a:	74 24                	je     105e50 <default_check+0xd8>
  105e2c:	c7 44 24 0c 72 80 10 	movl   $0x108072,0xc(%esp)
  105e33:	00 
  105e34:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105e3b:	00 
  105e3c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  105e43:	00 
  105e44:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105e4b:	e8 a9 a5 ff ff       	call   1003f9 <__panic>

    basic_check();
  105e50:	e8 e6 f9 ff ff       	call   10583b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105e55:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105e5c:	e8 0a cf ff ff       	call   102d6b <alloc_pages>
  105e61:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105e64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e68:	75 24                	jne    105e8e <default_check+0x116>
  105e6a:	c7 44 24 0c 8b 80 10 	movl   $0x10808b,0xc(%esp)
  105e71:	00 
  105e72:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105e79:	00 
  105e7a:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  105e81:	00 
  105e82:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105e89:	e8 6b a5 ff ff       	call   1003f9 <__panic>
    assert(!PageProperty(p0));
  105e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e91:	83 c0 04             	add    $0x4,%eax
  105e94:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105e9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105e9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105ea1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105ea4:	0f a3 10             	bt     %edx,(%eax)
  105ea7:	19 c0                	sbb    %eax,%eax
  105ea9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105eac:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105eb0:	0f 95 c0             	setne  %al
  105eb3:	0f b6 c0             	movzbl %al,%eax
  105eb6:	85 c0                	test   %eax,%eax
  105eb8:	74 24                	je     105ede <default_check+0x166>
  105eba:	c7 44 24 0c 96 80 10 	movl   $0x108096,0xc(%esp)
  105ec1:	00 
  105ec2:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105ec9:	00 
  105eca:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  105ed1:	00 
  105ed2:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105ed9:	e8 1b a5 ff ff       	call   1003f9 <__panic>

    list_entry_t free_list_store = free_list;
  105ede:	a1 a0 a3 1b 00       	mov    0x1ba3a0,%eax
  105ee3:	8b 15 a4 a3 1b 00    	mov    0x1ba3a4,%edx
  105ee9:	89 45 80             	mov    %eax,-0x80(%ebp)
  105eec:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105eef:	c7 45 b0 a0 a3 1b 00 	movl   $0x1ba3a0,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105ef6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105ef9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105efc:	89 50 04             	mov    %edx,0x4(%eax)
  105eff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105f02:	8b 50 04             	mov    0x4(%eax),%edx
  105f05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105f08:	89 10                	mov    %edx,(%eax)
  105f0a:	c7 45 b4 a0 a3 1b 00 	movl   $0x1ba3a0,-0x4c(%ebp)
    return list->next == list;
  105f11:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105f14:	8b 40 04             	mov    0x4(%eax),%eax
  105f17:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105f1a:	0f 94 c0             	sete   %al
  105f1d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105f20:	85 c0                	test   %eax,%eax
  105f22:	75 24                	jne    105f48 <default_check+0x1d0>
  105f24:	c7 44 24 0c eb 7f 10 	movl   $0x107feb,0xc(%esp)
  105f2b:	00 
  105f2c:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105f33:	00 
  105f34:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  105f3b:	00 
  105f3c:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105f43:	e8 b1 a4 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  105f48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105f4f:	e8 17 ce ff ff       	call   102d6b <alloc_pages>
  105f54:	85 c0                	test   %eax,%eax
  105f56:	74 24                	je     105f7c <default_check+0x204>
  105f58:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  105f5f:	00 
  105f60:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105f67:	00 
  105f68:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  105f6f:	00 
  105f70:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105f77:	e8 7d a4 ff ff       	call   1003f9 <__panic>

    unsigned int nr_free_store = nr_free;
  105f7c:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  105f81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  105f84:	c7 05 a8 a3 1b 00 00 	movl   $0x0,0x1ba3a8
  105f8b:	00 00 00 

    free_pages(p0 + 2, 3);
  105f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f91:	83 c0 28             	add    $0x28,%eax
  105f94:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105f9b:	00 
  105f9c:	89 04 24             	mov    %eax,(%esp)
  105f9f:	e8 ff cd ff ff       	call   102da3 <free_pages>
    assert(alloc_pages(4) == NULL);
  105fa4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105fab:	e8 bb cd ff ff       	call   102d6b <alloc_pages>
  105fb0:	85 c0                	test   %eax,%eax
  105fb2:	74 24                	je     105fd8 <default_check+0x260>
  105fb4:	c7 44 24 0c a8 80 10 	movl   $0x1080a8,0xc(%esp)
  105fbb:	00 
  105fbc:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  105fc3:	00 
  105fc4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  105fcb:	00 
  105fcc:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  105fd3:	e8 21 a4 ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fdb:	83 c0 28             	add    $0x28,%eax
  105fde:	83 c0 04             	add    $0x4,%eax
  105fe1:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105fe8:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105fee:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105ff1:	0f a3 10             	bt     %edx,(%eax)
  105ff4:	19 c0                	sbb    %eax,%eax
  105ff6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105ff9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105ffd:	0f 95 c0             	setne  %al
  106000:	0f b6 c0             	movzbl %al,%eax
  106003:	85 c0                	test   %eax,%eax
  106005:	74 0e                	je     106015 <default_check+0x29d>
  106007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10600a:	83 c0 28             	add    $0x28,%eax
  10600d:	8b 40 08             	mov    0x8(%eax),%eax
  106010:	83 f8 03             	cmp    $0x3,%eax
  106013:	74 24                	je     106039 <default_check+0x2c1>
  106015:	c7 44 24 0c c0 80 10 	movl   $0x1080c0,0xc(%esp)
  10601c:	00 
  10601d:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  106024:	00 
  106025:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10602c:	00 
  10602d:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  106034:	e8 c0 a3 ff ff       	call   1003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  106039:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  106040:	e8 26 cd ff ff       	call   102d6b <alloc_pages>
  106045:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106048:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10604c:	75 24                	jne    106072 <default_check+0x2fa>
  10604e:	c7 44 24 0c ec 80 10 	movl   $0x1080ec,0xc(%esp)
  106055:	00 
  106056:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  10605d:	00 
  10605e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  106065:	00 
  106066:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  10606d:	e8 87 a3 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  106072:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106079:	e8 ed cc ff ff       	call   102d6b <alloc_pages>
  10607e:	85 c0                	test   %eax,%eax
  106080:	74 24                	je     1060a6 <default_check+0x32e>
  106082:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  106089:	00 
  10608a:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  106091:	00 
  106092:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  106099:	00 
  10609a:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1060a1:	e8 53 a3 ff ff       	call   1003f9 <__panic>
    assert(p0 + 2 == p1);
  1060a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060a9:	83 c0 28             	add    $0x28,%eax
  1060ac:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1060af:	74 24                	je     1060d5 <default_check+0x35d>
  1060b1:	c7 44 24 0c 0a 81 10 	movl   $0x10810a,0xc(%esp)
  1060b8:	00 
  1060b9:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1060c0:	00 
  1060c1:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  1060c8:	00 
  1060c9:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1060d0:	e8 24 a3 ff ff       	call   1003f9 <__panic>

    p2 = p0 + 1;
  1060d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060d8:	83 c0 14             	add    $0x14,%eax
  1060db:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1060de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1060e5:	00 
  1060e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060e9:	89 04 24             	mov    %eax,(%esp)
  1060ec:	e8 b2 cc ff ff       	call   102da3 <free_pages>
    free_pages(p1, 3);
  1060f1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1060f8:	00 
  1060f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1060fc:	89 04 24             	mov    %eax,(%esp)
  1060ff:	e8 9f cc ff ff       	call   102da3 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  106104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106107:	83 c0 04             	add    $0x4,%eax
  10610a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  106111:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  106114:	8b 45 9c             	mov    -0x64(%ebp),%eax
  106117:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10611a:	0f a3 10             	bt     %edx,(%eax)
  10611d:	19 c0                	sbb    %eax,%eax
  10611f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  106122:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  106126:	0f 95 c0             	setne  %al
  106129:	0f b6 c0             	movzbl %al,%eax
  10612c:	85 c0                	test   %eax,%eax
  10612e:	74 0b                	je     10613b <default_check+0x3c3>
  106130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106133:	8b 40 08             	mov    0x8(%eax),%eax
  106136:	83 f8 01             	cmp    $0x1,%eax
  106139:	74 24                	je     10615f <default_check+0x3e7>
  10613b:	c7 44 24 0c 18 81 10 	movl   $0x108118,0xc(%esp)
  106142:	00 
  106143:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  10614a:	00 
  10614b:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  106152:	00 
  106153:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  10615a:	e8 9a a2 ff ff       	call   1003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10615f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106162:	83 c0 04             	add    $0x4,%eax
  106165:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10616c:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10616f:	8b 45 90             	mov    -0x70(%ebp),%eax
  106172:	8b 55 94             	mov    -0x6c(%ebp),%edx
  106175:	0f a3 10             	bt     %edx,(%eax)
  106178:	19 c0                	sbb    %eax,%eax
  10617a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10617d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  106181:	0f 95 c0             	setne  %al
  106184:	0f b6 c0             	movzbl %al,%eax
  106187:	85 c0                	test   %eax,%eax
  106189:	74 0b                	je     106196 <default_check+0x41e>
  10618b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10618e:	8b 40 08             	mov    0x8(%eax),%eax
  106191:	83 f8 03             	cmp    $0x3,%eax
  106194:	74 24                	je     1061ba <default_check+0x442>
  106196:	c7 44 24 0c 40 81 10 	movl   $0x108140,0xc(%esp)
  10619d:	00 
  10619e:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1061a5:	00 
  1061a6:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1061ad:	00 
  1061ae:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1061b5:	e8 3f a2 ff ff       	call   1003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1061ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1061c1:	e8 a5 cb ff ff       	call   102d6b <alloc_pages>
  1061c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1061c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1061cc:	83 e8 14             	sub    $0x14,%eax
  1061cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1061d2:	74 24                	je     1061f8 <default_check+0x480>
  1061d4:	c7 44 24 0c 66 81 10 	movl   $0x108166,0xc(%esp)
  1061db:	00 
  1061dc:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1061e3:	00 
  1061e4:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  1061eb:	00 
  1061ec:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1061f3:	e8 01 a2 ff ff       	call   1003f9 <__panic>
    free_page(p0);
  1061f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1061ff:	00 
  106200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106203:	89 04 24             	mov    %eax,(%esp)
  106206:	e8 98 cb ff ff       	call   102da3 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10620b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  106212:	e8 54 cb ff ff       	call   102d6b <alloc_pages>
  106217:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10621a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10621d:	83 c0 14             	add    $0x14,%eax
  106220:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  106223:	74 24                	je     106249 <default_check+0x4d1>
  106225:	c7 44 24 0c 84 81 10 	movl   $0x108184,0xc(%esp)
  10622c:	00 
  10622d:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  106234:	00 
  106235:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10623c:	00 
  10623d:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  106244:	e8 b0 a1 ff ff       	call   1003f9 <__panic>

    free_pages(p0, 2);
  106249:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  106250:	00 
  106251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106254:	89 04 24             	mov    %eax,(%esp)
  106257:	e8 47 cb ff ff       	call   102da3 <free_pages>
    free_page(p2);
  10625c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106263:	00 
  106264:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106267:	89 04 24             	mov    %eax,(%esp)
  10626a:	e8 34 cb ff ff       	call   102da3 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10626f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  106276:	e8 f0 ca ff ff       	call   102d6b <alloc_pages>
  10627b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10627e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106282:	75 24                	jne    1062a8 <default_check+0x530>
  106284:	c7 44 24 0c a4 81 10 	movl   $0x1081a4,0xc(%esp)
  10628b:	00 
  10628c:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  106293:	00 
  106294:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10629b:	00 
  10629c:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1062a3:	e8 51 a1 ff ff       	call   1003f9 <__panic>
    assert(alloc_page() == NULL);
  1062a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1062af:	e8 b7 ca ff ff       	call   102d6b <alloc_pages>
  1062b4:	85 c0                	test   %eax,%eax
  1062b6:	74 24                	je     1062dc <default_check+0x564>
  1062b8:	c7 44 24 0c 02 80 10 	movl   $0x108002,0xc(%esp)
  1062bf:	00 
  1062c0:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1062c7:	00 
  1062c8:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1062cf:	00 
  1062d0:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1062d7:	e8 1d a1 ff ff       	call   1003f9 <__panic>

    assert(nr_free == 0);
  1062dc:	a1 a8 a3 1b 00       	mov    0x1ba3a8,%eax
  1062e1:	85 c0                	test   %eax,%eax
  1062e3:	74 24                	je     106309 <default_check+0x591>
  1062e5:	c7 44 24 0c 55 80 10 	movl   $0x108055,0xc(%esp)
  1062ec:	00 
  1062ed:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1062f4:	00 
  1062f5:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1062fc:	00 
  1062fd:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  106304:	e8 f0 a0 ff ff       	call   1003f9 <__panic>
    nr_free = nr_free_store;
  106309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10630c:	a3 a8 a3 1b 00       	mov    %eax,0x1ba3a8

    free_list = free_list_store;
  106311:	8b 45 80             	mov    -0x80(%ebp),%eax
  106314:	8b 55 84             	mov    -0x7c(%ebp),%edx
  106317:	a3 a0 a3 1b 00       	mov    %eax,0x1ba3a0
  10631c:	89 15 a4 a3 1b 00    	mov    %edx,0x1ba3a4
    free_pages(p0, 5);
  106322:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  106329:	00 
  10632a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10632d:	89 04 24             	mov    %eax,(%esp)
  106330:	e8 6e ca ff ff       	call   102da3 <free_pages>

    le = &free_list;
  106335:	c7 45 ec a0 a3 1b 00 	movl   $0x1ba3a0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10633c:	eb 5a                	jmp    106398 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
  10633e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106341:	8b 40 04             	mov    0x4(%eax),%eax
  106344:	8b 00                	mov    (%eax),%eax
  106346:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  106349:	75 0d                	jne    106358 <default_check+0x5e0>
  10634b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10634e:	8b 00                	mov    (%eax),%eax
  106350:	8b 40 04             	mov    0x4(%eax),%eax
  106353:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  106356:	74 24                	je     10637c <default_check+0x604>
  106358:	c7 44 24 0c c4 81 10 	movl   $0x1081c4,0xc(%esp)
  10635f:	00 
  106360:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  106367:	00 
  106368:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  10636f:	00 
  106370:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  106377:	e8 7d a0 ff ff       	call   1003f9 <__panic>
        struct Page *p = le2page(le, page_link);
  10637c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10637f:	83 e8 0c             	sub    $0xc,%eax
  106382:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  106385:	ff 4d f4             	decl   -0xc(%ebp)
  106388:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10638b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10638e:	8b 40 08             	mov    0x8(%eax),%eax
  106391:	29 c2                	sub    %eax,%edx
  106393:	89 d0                	mov    %edx,%eax
  106395:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10639b:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10639e:	8b 45 88             	mov    -0x78(%ebp),%eax
  1063a1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1063a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1063a7:	81 7d ec a0 a3 1b 00 	cmpl   $0x1ba3a0,-0x14(%ebp)
  1063ae:	75 8e                	jne    10633e <default_check+0x5c6>
    }
    assert(count == 0);
  1063b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1063b4:	74 24                	je     1063da <default_check+0x662>
  1063b6:	c7 44 24 0c f1 81 10 	movl   $0x1081f1,0xc(%esp)
  1063bd:	00 
  1063be:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1063c5:	00 
  1063c6:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  1063cd:	00 
  1063ce:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1063d5:	e8 1f a0 ff ff       	call   1003f9 <__panic>
    assert(total == 0);
  1063da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1063de:	74 24                	je     106404 <default_check+0x68c>
  1063e0:	c7 44 24 0c fc 81 10 	movl   $0x1081fc,0xc(%esp)
  1063e7:	00 
  1063e8:	c7 44 24 08 62 7e 10 	movl   $0x107e62,0x8(%esp)
  1063ef:	00 
  1063f0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1063f7:	00 
  1063f8:	c7 04 24 77 7e 10 00 	movl   $0x107e77,(%esp)
  1063ff:	e8 f5 9f ff ff       	call   1003f9 <__panic>
}
  106404:	90                   	nop
  106405:	c9                   	leave  
  106406:	c3                   	ret    

00106407 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  106407:	55                   	push   %ebp
  106408:	89 e5                	mov    %esp,%ebp
  10640a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10640d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  106414:	eb 03                	jmp    106419 <strlen+0x12>
        cnt ++;
  106416:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  106419:	8b 45 08             	mov    0x8(%ebp),%eax
  10641c:	8d 50 01             	lea    0x1(%eax),%edx
  10641f:	89 55 08             	mov    %edx,0x8(%ebp)
  106422:	0f b6 00             	movzbl (%eax),%eax
  106425:	84 c0                	test   %al,%al
  106427:	75 ed                	jne    106416 <strlen+0xf>
    }
    return cnt;
  106429:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10642c:	c9                   	leave  
  10642d:	c3                   	ret    

0010642e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10642e:	55                   	push   %ebp
  10642f:	89 e5                	mov    %esp,%ebp
  106431:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10643b:	eb 03                	jmp    106440 <strnlen+0x12>
        cnt ++;
  10643d:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  106440:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106443:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106446:	73 10                	jae    106458 <strnlen+0x2a>
  106448:	8b 45 08             	mov    0x8(%ebp),%eax
  10644b:	8d 50 01             	lea    0x1(%eax),%edx
  10644e:	89 55 08             	mov    %edx,0x8(%ebp)
  106451:	0f b6 00             	movzbl (%eax),%eax
  106454:	84 c0                	test   %al,%al
  106456:	75 e5                	jne    10643d <strnlen+0xf>
    }
    return cnt;
  106458:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10645b:	c9                   	leave  
  10645c:	c3                   	ret    

0010645d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10645d:	55                   	push   %ebp
  10645e:	89 e5                	mov    %esp,%ebp
  106460:	57                   	push   %edi
  106461:	56                   	push   %esi
  106462:	83 ec 20             	sub    $0x20,%esp
  106465:	8b 45 08             	mov    0x8(%ebp),%eax
  106468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10646b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10646e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  106471:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106477:	89 d1                	mov    %edx,%ecx
  106479:	89 c2                	mov    %eax,%edx
  10647b:	89 ce                	mov    %ecx,%esi
  10647d:	89 d7                	mov    %edx,%edi
  10647f:	ac                   	lods   %ds:(%esi),%al
  106480:	aa                   	stos   %al,%es:(%edi)
  106481:	84 c0                	test   %al,%al
  106483:	75 fa                	jne    10647f <strcpy+0x22>
  106485:	89 fa                	mov    %edi,%edx
  106487:	89 f1                	mov    %esi,%ecx
  106489:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10648c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10648f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  106492:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  106495:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  106496:	83 c4 20             	add    $0x20,%esp
  106499:	5e                   	pop    %esi
  10649a:	5f                   	pop    %edi
  10649b:	5d                   	pop    %ebp
  10649c:	c3                   	ret    

0010649d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10649d:	55                   	push   %ebp
  10649e:	89 e5                	mov    %esp,%ebp
  1064a0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1064a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1064a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1064a9:	eb 1e                	jmp    1064c9 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1064ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064ae:	0f b6 10             	movzbl (%eax),%edx
  1064b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1064b4:	88 10                	mov    %dl,(%eax)
  1064b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1064b9:	0f b6 00             	movzbl (%eax),%eax
  1064bc:	84 c0                	test   %al,%al
  1064be:	74 03                	je     1064c3 <strncpy+0x26>
            src ++;
  1064c0:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1064c3:	ff 45 fc             	incl   -0x4(%ebp)
  1064c6:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1064c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1064cd:	75 dc                	jne    1064ab <strncpy+0xe>
    }
    return dst;
  1064cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1064d2:	c9                   	leave  
  1064d3:	c3                   	ret    

001064d4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1064d4:	55                   	push   %ebp
  1064d5:	89 e5                	mov    %esp,%ebp
  1064d7:	57                   	push   %edi
  1064d8:	56                   	push   %esi
  1064d9:	83 ec 20             	sub    $0x20,%esp
  1064dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1064df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1064e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1064e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1064eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1064ee:	89 d1                	mov    %edx,%ecx
  1064f0:	89 c2                	mov    %eax,%edx
  1064f2:	89 ce                	mov    %ecx,%esi
  1064f4:	89 d7                	mov    %edx,%edi
  1064f6:	ac                   	lods   %ds:(%esi),%al
  1064f7:	ae                   	scas   %es:(%edi),%al
  1064f8:	75 08                	jne    106502 <strcmp+0x2e>
  1064fa:	84 c0                	test   %al,%al
  1064fc:	75 f8                	jne    1064f6 <strcmp+0x22>
  1064fe:	31 c0                	xor    %eax,%eax
  106500:	eb 04                	jmp    106506 <strcmp+0x32>
  106502:	19 c0                	sbb    %eax,%eax
  106504:	0c 01                	or     $0x1,%al
  106506:	89 fa                	mov    %edi,%edx
  106508:	89 f1                	mov    %esi,%ecx
  10650a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10650d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  106513:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  106516:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  106517:	83 c4 20             	add    $0x20,%esp
  10651a:	5e                   	pop    %esi
  10651b:	5f                   	pop    %edi
  10651c:	5d                   	pop    %ebp
  10651d:	c3                   	ret    

0010651e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10651e:	55                   	push   %ebp
  10651f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  106521:	eb 09                	jmp    10652c <strncmp+0xe>
        n --, s1 ++, s2 ++;
  106523:	ff 4d 10             	decl   0x10(%ebp)
  106526:	ff 45 08             	incl   0x8(%ebp)
  106529:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10652c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106530:	74 1a                	je     10654c <strncmp+0x2e>
  106532:	8b 45 08             	mov    0x8(%ebp),%eax
  106535:	0f b6 00             	movzbl (%eax),%eax
  106538:	84 c0                	test   %al,%al
  10653a:	74 10                	je     10654c <strncmp+0x2e>
  10653c:	8b 45 08             	mov    0x8(%ebp),%eax
  10653f:	0f b6 10             	movzbl (%eax),%edx
  106542:	8b 45 0c             	mov    0xc(%ebp),%eax
  106545:	0f b6 00             	movzbl (%eax),%eax
  106548:	38 c2                	cmp    %al,%dl
  10654a:	74 d7                	je     106523 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10654c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106550:	74 18                	je     10656a <strncmp+0x4c>
  106552:	8b 45 08             	mov    0x8(%ebp),%eax
  106555:	0f b6 00             	movzbl (%eax),%eax
  106558:	0f b6 d0             	movzbl %al,%edx
  10655b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10655e:	0f b6 00             	movzbl (%eax),%eax
  106561:	0f b6 c0             	movzbl %al,%eax
  106564:	29 c2                	sub    %eax,%edx
  106566:	89 d0                	mov    %edx,%eax
  106568:	eb 05                	jmp    10656f <strncmp+0x51>
  10656a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10656f:	5d                   	pop    %ebp
  106570:	c3                   	ret    

00106571 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  106571:	55                   	push   %ebp
  106572:	89 e5                	mov    %esp,%ebp
  106574:	83 ec 04             	sub    $0x4,%esp
  106577:	8b 45 0c             	mov    0xc(%ebp),%eax
  10657a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10657d:	eb 13                	jmp    106592 <strchr+0x21>
        if (*s == c) {
  10657f:	8b 45 08             	mov    0x8(%ebp),%eax
  106582:	0f b6 00             	movzbl (%eax),%eax
  106585:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106588:	75 05                	jne    10658f <strchr+0x1e>
            return (char *)s;
  10658a:	8b 45 08             	mov    0x8(%ebp),%eax
  10658d:	eb 12                	jmp    1065a1 <strchr+0x30>
        }
        s ++;
  10658f:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106592:	8b 45 08             	mov    0x8(%ebp),%eax
  106595:	0f b6 00             	movzbl (%eax),%eax
  106598:	84 c0                	test   %al,%al
  10659a:	75 e3                	jne    10657f <strchr+0xe>
    }
    return NULL;
  10659c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1065a1:	c9                   	leave  
  1065a2:	c3                   	ret    

001065a3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1065a3:	55                   	push   %ebp
  1065a4:	89 e5                	mov    %esp,%ebp
  1065a6:	83 ec 04             	sub    $0x4,%esp
  1065a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065ac:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1065af:	eb 0e                	jmp    1065bf <strfind+0x1c>
        if (*s == c) {
  1065b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1065b4:	0f b6 00             	movzbl (%eax),%eax
  1065b7:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1065ba:	74 0f                	je     1065cb <strfind+0x28>
            break;
        }
        s ++;
  1065bc:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1065bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1065c2:	0f b6 00             	movzbl (%eax),%eax
  1065c5:	84 c0                	test   %al,%al
  1065c7:	75 e8                	jne    1065b1 <strfind+0xe>
  1065c9:	eb 01                	jmp    1065cc <strfind+0x29>
            break;
  1065cb:	90                   	nop
    }
    return (char *)s;
  1065cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1065cf:	c9                   	leave  
  1065d0:	c3                   	ret    

001065d1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1065d1:	55                   	push   %ebp
  1065d2:	89 e5                	mov    %esp,%ebp
  1065d4:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1065d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1065de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1065e5:	eb 03                	jmp    1065ea <strtol+0x19>
        s ++;
  1065e7:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1065ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1065ed:	0f b6 00             	movzbl (%eax),%eax
  1065f0:	3c 20                	cmp    $0x20,%al
  1065f2:	74 f3                	je     1065e7 <strtol+0x16>
  1065f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1065f7:	0f b6 00             	movzbl (%eax),%eax
  1065fa:	3c 09                	cmp    $0x9,%al
  1065fc:	74 e9                	je     1065e7 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1065fe:	8b 45 08             	mov    0x8(%ebp),%eax
  106601:	0f b6 00             	movzbl (%eax),%eax
  106604:	3c 2b                	cmp    $0x2b,%al
  106606:	75 05                	jne    10660d <strtol+0x3c>
        s ++;
  106608:	ff 45 08             	incl   0x8(%ebp)
  10660b:	eb 14                	jmp    106621 <strtol+0x50>
    }
    else if (*s == '-') {
  10660d:	8b 45 08             	mov    0x8(%ebp),%eax
  106610:	0f b6 00             	movzbl (%eax),%eax
  106613:	3c 2d                	cmp    $0x2d,%al
  106615:	75 0a                	jne    106621 <strtol+0x50>
        s ++, neg = 1;
  106617:	ff 45 08             	incl   0x8(%ebp)
  10661a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  106621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106625:	74 06                	je     10662d <strtol+0x5c>
  106627:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10662b:	75 22                	jne    10664f <strtol+0x7e>
  10662d:	8b 45 08             	mov    0x8(%ebp),%eax
  106630:	0f b6 00             	movzbl (%eax),%eax
  106633:	3c 30                	cmp    $0x30,%al
  106635:	75 18                	jne    10664f <strtol+0x7e>
  106637:	8b 45 08             	mov    0x8(%ebp),%eax
  10663a:	40                   	inc    %eax
  10663b:	0f b6 00             	movzbl (%eax),%eax
  10663e:	3c 78                	cmp    $0x78,%al
  106640:	75 0d                	jne    10664f <strtol+0x7e>
        s += 2, base = 16;
  106642:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106646:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10664d:	eb 29                	jmp    106678 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  10664f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106653:	75 16                	jne    10666b <strtol+0x9a>
  106655:	8b 45 08             	mov    0x8(%ebp),%eax
  106658:	0f b6 00             	movzbl (%eax),%eax
  10665b:	3c 30                	cmp    $0x30,%al
  10665d:	75 0c                	jne    10666b <strtol+0x9a>
        s ++, base = 8;
  10665f:	ff 45 08             	incl   0x8(%ebp)
  106662:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106669:	eb 0d                	jmp    106678 <strtol+0xa7>
    }
    else if (base == 0) {
  10666b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10666f:	75 07                	jne    106678 <strtol+0xa7>
        base = 10;
  106671:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106678:	8b 45 08             	mov    0x8(%ebp),%eax
  10667b:	0f b6 00             	movzbl (%eax),%eax
  10667e:	3c 2f                	cmp    $0x2f,%al
  106680:	7e 1b                	jle    10669d <strtol+0xcc>
  106682:	8b 45 08             	mov    0x8(%ebp),%eax
  106685:	0f b6 00             	movzbl (%eax),%eax
  106688:	3c 39                	cmp    $0x39,%al
  10668a:	7f 11                	jg     10669d <strtol+0xcc>
            dig = *s - '0';
  10668c:	8b 45 08             	mov    0x8(%ebp),%eax
  10668f:	0f b6 00             	movzbl (%eax),%eax
  106692:	0f be c0             	movsbl %al,%eax
  106695:	83 e8 30             	sub    $0x30,%eax
  106698:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10669b:	eb 48                	jmp    1066e5 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10669d:	8b 45 08             	mov    0x8(%ebp),%eax
  1066a0:	0f b6 00             	movzbl (%eax),%eax
  1066a3:	3c 60                	cmp    $0x60,%al
  1066a5:	7e 1b                	jle    1066c2 <strtol+0xf1>
  1066a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1066aa:	0f b6 00             	movzbl (%eax),%eax
  1066ad:	3c 7a                	cmp    $0x7a,%al
  1066af:	7f 11                	jg     1066c2 <strtol+0xf1>
            dig = *s - 'a' + 10;
  1066b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1066b4:	0f b6 00             	movzbl (%eax),%eax
  1066b7:	0f be c0             	movsbl %al,%eax
  1066ba:	83 e8 57             	sub    $0x57,%eax
  1066bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1066c0:	eb 23                	jmp    1066e5 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1066c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1066c5:	0f b6 00             	movzbl (%eax),%eax
  1066c8:	3c 40                	cmp    $0x40,%al
  1066ca:	7e 3b                	jle    106707 <strtol+0x136>
  1066cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1066cf:	0f b6 00             	movzbl (%eax),%eax
  1066d2:	3c 5a                	cmp    $0x5a,%al
  1066d4:	7f 31                	jg     106707 <strtol+0x136>
            dig = *s - 'A' + 10;
  1066d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1066d9:	0f b6 00             	movzbl (%eax),%eax
  1066dc:	0f be c0             	movsbl %al,%eax
  1066df:	83 e8 37             	sub    $0x37,%eax
  1066e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1066e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1066e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  1066eb:	7d 19                	jge    106706 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1066ed:	ff 45 08             	incl   0x8(%ebp)
  1066f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1066f3:	0f af 45 10          	imul   0x10(%ebp),%eax
  1066f7:	89 c2                	mov    %eax,%edx
  1066f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1066fc:	01 d0                	add    %edx,%eax
  1066fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  106701:	e9 72 ff ff ff       	jmp    106678 <strtol+0xa7>
            break;
  106706:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  106707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10670b:	74 08                	je     106715 <strtol+0x144>
        *endptr = (char *) s;
  10670d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106710:	8b 55 08             	mov    0x8(%ebp),%edx
  106713:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106715:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106719:	74 07                	je     106722 <strtol+0x151>
  10671b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10671e:	f7 d8                	neg    %eax
  106720:	eb 03                	jmp    106725 <strtol+0x154>
  106722:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106725:	c9                   	leave  
  106726:	c3                   	ret    

00106727 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106727:	55                   	push   %ebp
  106728:	89 e5                	mov    %esp,%ebp
  10672a:	57                   	push   %edi
  10672b:	83 ec 24             	sub    $0x24,%esp
  10672e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106731:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106734:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  106738:	8b 55 08             	mov    0x8(%ebp),%edx
  10673b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10673e:	88 45 f7             	mov    %al,-0x9(%ebp)
  106741:	8b 45 10             	mov    0x10(%ebp),%eax
  106744:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106747:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10674a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10674e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106751:	89 d7                	mov    %edx,%edi
  106753:	f3 aa                	rep stos %al,%es:(%edi)
  106755:	89 fa                	mov    %edi,%edx
  106757:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10675a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10675d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106760:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106761:	83 c4 24             	add    $0x24,%esp
  106764:	5f                   	pop    %edi
  106765:	5d                   	pop    %ebp
  106766:	c3                   	ret    

00106767 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106767:	55                   	push   %ebp
  106768:	89 e5                	mov    %esp,%ebp
  10676a:	57                   	push   %edi
  10676b:	56                   	push   %esi
  10676c:	53                   	push   %ebx
  10676d:	83 ec 30             	sub    $0x30,%esp
  106770:	8b 45 08             	mov    0x8(%ebp),%eax
  106773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106776:	8b 45 0c             	mov    0xc(%ebp),%eax
  106779:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10677c:	8b 45 10             	mov    0x10(%ebp),%eax
  10677f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106785:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106788:	73 42                	jae    1067cc <memmove+0x65>
  10678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10678d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106793:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106799:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10679c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10679f:	c1 e8 02             	shr    $0x2,%eax
  1067a2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1067a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1067a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1067aa:	89 d7                	mov    %edx,%edi
  1067ac:	89 c6                	mov    %eax,%esi
  1067ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1067b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1067b3:	83 e1 03             	and    $0x3,%ecx
  1067b6:	74 02                	je     1067ba <memmove+0x53>
  1067b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1067ba:	89 f0                	mov    %esi,%eax
  1067bc:	89 fa                	mov    %edi,%edx
  1067be:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1067c1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1067c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1067c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1067ca:	eb 36                	jmp    106802 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1067cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1067cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1067d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1067d5:	01 c2                	add    %eax,%edx
  1067d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1067da:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1067dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067e0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1067e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1067e6:	89 c1                	mov    %eax,%ecx
  1067e8:	89 d8                	mov    %ebx,%eax
  1067ea:	89 d6                	mov    %edx,%esi
  1067ec:	89 c7                	mov    %eax,%edi
  1067ee:	fd                   	std    
  1067ef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1067f1:	fc                   	cld    
  1067f2:	89 f8                	mov    %edi,%eax
  1067f4:	89 f2                	mov    %esi,%edx
  1067f6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1067f9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1067fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1067ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106802:	83 c4 30             	add    $0x30,%esp
  106805:	5b                   	pop    %ebx
  106806:	5e                   	pop    %esi
  106807:	5f                   	pop    %edi
  106808:	5d                   	pop    %ebp
  106809:	c3                   	ret    

0010680a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10680a:	55                   	push   %ebp
  10680b:	89 e5                	mov    %esp,%ebp
  10680d:	57                   	push   %edi
  10680e:	56                   	push   %esi
  10680f:	83 ec 20             	sub    $0x20,%esp
  106812:	8b 45 08             	mov    0x8(%ebp),%eax
  106815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106818:	8b 45 0c             	mov    0xc(%ebp),%eax
  10681b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10681e:	8b 45 10             	mov    0x10(%ebp),%eax
  106821:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106827:	c1 e8 02             	shr    $0x2,%eax
  10682a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10682c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10682f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106832:	89 d7                	mov    %edx,%edi
  106834:	89 c6                	mov    %eax,%esi
  106836:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106838:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10683b:	83 e1 03             	and    $0x3,%ecx
  10683e:	74 02                	je     106842 <memcpy+0x38>
  106840:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106842:	89 f0                	mov    %esi,%eax
  106844:	89 fa                	mov    %edi,%edx
  106846:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106849:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10684c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10684f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  106852:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106853:	83 c4 20             	add    $0x20,%esp
  106856:	5e                   	pop    %esi
  106857:	5f                   	pop    %edi
  106858:	5d                   	pop    %ebp
  106859:	c3                   	ret    

0010685a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10685a:	55                   	push   %ebp
  10685b:	89 e5                	mov    %esp,%ebp
  10685d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106860:	8b 45 08             	mov    0x8(%ebp),%eax
  106863:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106866:	8b 45 0c             	mov    0xc(%ebp),%eax
  106869:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10686c:	eb 2e                	jmp    10689c <memcmp+0x42>
        if (*s1 != *s2) {
  10686e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106871:	0f b6 10             	movzbl (%eax),%edx
  106874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106877:	0f b6 00             	movzbl (%eax),%eax
  10687a:	38 c2                	cmp    %al,%dl
  10687c:	74 18                	je     106896 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10687e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106881:	0f b6 00             	movzbl (%eax),%eax
  106884:	0f b6 d0             	movzbl %al,%edx
  106887:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10688a:	0f b6 00             	movzbl (%eax),%eax
  10688d:	0f b6 c0             	movzbl %al,%eax
  106890:	29 c2                	sub    %eax,%edx
  106892:	89 d0                	mov    %edx,%eax
  106894:	eb 18                	jmp    1068ae <memcmp+0x54>
        }
        s1 ++, s2 ++;
  106896:	ff 45 fc             	incl   -0x4(%ebp)
  106899:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10689c:	8b 45 10             	mov    0x10(%ebp),%eax
  10689f:	8d 50 ff             	lea    -0x1(%eax),%edx
  1068a2:	89 55 10             	mov    %edx,0x10(%ebp)
  1068a5:	85 c0                	test   %eax,%eax
  1068a7:	75 c5                	jne    10686e <memcmp+0x14>
    }
    return 0;
  1068a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1068ae:	c9                   	leave  
  1068af:	c3                   	ret    

001068b0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1068b0:	55                   	push   %ebp
  1068b1:	89 e5                	mov    %esp,%ebp
  1068b3:	83 ec 58             	sub    $0x58,%esp
  1068b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1068b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1068bc:	8b 45 14             	mov    0x14(%ebp),%eax
  1068bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1068c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1068c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1068c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1068cb:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1068ce:	8b 45 18             	mov    0x18(%ebp),%eax
  1068d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1068d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1068d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1068da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1068dd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1068e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1068e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1068ea:	74 1c                	je     106908 <printnum+0x58>
  1068ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068ef:	ba 00 00 00 00       	mov    $0x0,%edx
  1068f4:	f7 75 e4             	divl   -0x1c(%ebp)
  1068f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1068fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068fd:	ba 00 00 00 00       	mov    $0x0,%edx
  106902:	f7 75 e4             	divl   -0x1c(%ebp)
  106905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10690b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10690e:	f7 75 e4             	divl   -0x1c(%ebp)
  106911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106914:	89 55 dc             	mov    %edx,-0x24(%ebp)
  106917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10691a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10691d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106920:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106923:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106926:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  106929:	8b 45 18             	mov    0x18(%ebp),%eax
  10692c:	ba 00 00 00 00       	mov    $0x0,%edx
  106931:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  106934:	72 56                	jb     10698c <printnum+0xdc>
  106936:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  106939:	77 05                	ja     106940 <printnum+0x90>
  10693b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10693e:	72 4c                	jb     10698c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  106940:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106943:	8d 50 ff             	lea    -0x1(%eax),%edx
  106946:	8b 45 20             	mov    0x20(%ebp),%eax
  106949:	89 44 24 18          	mov    %eax,0x18(%esp)
  10694d:	89 54 24 14          	mov    %edx,0x14(%esp)
  106951:	8b 45 18             	mov    0x18(%ebp),%eax
  106954:	89 44 24 10          	mov    %eax,0x10(%esp)
  106958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10695b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10695e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106962:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106966:	8b 45 0c             	mov    0xc(%ebp),%eax
  106969:	89 44 24 04          	mov    %eax,0x4(%esp)
  10696d:	8b 45 08             	mov    0x8(%ebp),%eax
  106970:	89 04 24             	mov    %eax,(%esp)
  106973:	e8 38 ff ff ff       	call   1068b0 <printnum>
  106978:	eb 1b                	jmp    106995 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10697a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10697d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106981:	8b 45 20             	mov    0x20(%ebp),%eax
  106984:	89 04 24             	mov    %eax,(%esp)
  106987:	8b 45 08             	mov    0x8(%ebp),%eax
  10698a:	ff d0                	call   *%eax
        while (-- width > 0)
  10698c:	ff 4d 1c             	decl   0x1c(%ebp)
  10698f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106993:	7f e5                	jg     10697a <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106995:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106998:	05 b8 82 10 00       	add    $0x1082b8,%eax
  10699d:	0f b6 00             	movzbl (%eax),%eax
  1069a0:	0f be c0             	movsbl %al,%eax
  1069a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1069a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1069aa:	89 04 24             	mov    %eax,(%esp)
  1069ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1069b0:	ff d0                	call   *%eax
}
  1069b2:	90                   	nop
  1069b3:	c9                   	leave  
  1069b4:	c3                   	ret    

001069b5 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1069b5:	55                   	push   %ebp
  1069b6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1069b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1069bc:	7e 14                	jle    1069d2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1069be:	8b 45 08             	mov    0x8(%ebp),%eax
  1069c1:	8b 00                	mov    (%eax),%eax
  1069c3:	8d 48 08             	lea    0x8(%eax),%ecx
  1069c6:	8b 55 08             	mov    0x8(%ebp),%edx
  1069c9:	89 0a                	mov    %ecx,(%edx)
  1069cb:	8b 50 04             	mov    0x4(%eax),%edx
  1069ce:	8b 00                	mov    (%eax),%eax
  1069d0:	eb 30                	jmp    106a02 <getuint+0x4d>
    }
    else if (lflag) {
  1069d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1069d6:	74 16                	je     1069ee <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1069d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1069db:	8b 00                	mov    (%eax),%eax
  1069dd:	8d 48 04             	lea    0x4(%eax),%ecx
  1069e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1069e3:	89 0a                	mov    %ecx,(%edx)
  1069e5:	8b 00                	mov    (%eax),%eax
  1069e7:	ba 00 00 00 00       	mov    $0x0,%edx
  1069ec:	eb 14                	jmp    106a02 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1069ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1069f1:	8b 00                	mov    (%eax),%eax
  1069f3:	8d 48 04             	lea    0x4(%eax),%ecx
  1069f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1069f9:	89 0a                	mov    %ecx,(%edx)
  1069fb:	8b 00                	mov    (%eax),%eax
  1069fd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106a02:	5d                   	pop    %ebp
  106a03:	c3                   	ret    

00106a04 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  106a04:	55                   	push   %ebp
  106a05:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106a07:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106a0b:	7e 14                	jle    106a21 <getint+0x1d>
        return va_arg(*ap, long long);
  106a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  106a10:	8b 00                	mov    (%eax),%eax
  106a12:	8d 48 08             	lea    0x8(%eax),%ecx
  106a15:	8b 55 08             	mov    0x8(%ebp),%edx
  106a18:	89 0a                	mov    %ecx,(%edx)
  106a1a:	8b 50 04             	mov    0x4(%eax),%edx
  106a1d:	8b 00                	mov    (%eax),%eax
  106a1f:	eb 28                	jmp    106a49 <getint+0x45>
    }
    else if (lflag) {
  106a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106a25:	74 12                	je     106a39 <getint+0x35>
        return va_arg(*ap, long);
  106a27:	8b 45 08             	mov    0x8(%ebp),%eax
  106a2a:	8b 00                	mov    (%eax),%eax
  106a2c:	8d 48 04             	lea    0x4(%eax),%ecx
  106a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  106a32:	89 0a                	mov    %ecx,(%edx)
  106a34:	8b 00                	mov    (%eax),%eax
  106a36:	99                   	cltd   
  106a37:	eb 10                	jmp    106a49 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  106a39:	8b 45 08             	mov    0x8(%ebp),%eax
  106a3c:	8b 00                	mov    (%eax),%eax
  106a3e:	8d 48 04             	lea    0x4(%eax),%ecx
  106a41:	8b 55 08             	mov    0x8(%ebp),%edx
  106a44:	89 0a                	mov    %ecx,(%edx)
  106a46:	8b 00                	mov    (%eax),%eax
  106a48:	99                   	cltd   
    }
}
  106a49:	5d                   	pop    %ebp
  106a4a:	c3                   	ret    

00106a4b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106a4b:	55                   	push   %ebp
  106a4c:	89 e5                	mov    %esp,%ebp
  106a4e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  106a51:	8d 45 14             	lea    0x14(%ebp),%eax
  106a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  106a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  106a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  106a6f:	89 04 24             	mov    %eax,(%esp)
  106a72:	e8 03 00 00 00       	call   106a7a <vprintfmt>
    va_end(ap);
}
  106a77:	90                   	nop
  106a78:	c9                   	leave  
  106a79:	c3                   	ret    

00106a7a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106a7a:	55                   	push   %ebp
  106a7b:	89 e5                	mov    %esp,%ebp
  106a7d:	56                   	push   %esi
  106a7e:	53                   	push   %ebx
  106a7f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106a82:	eb 17                	jmp    106a9b <vprintfmt+0x21>
            if (ch == '\0') {
  106a84:	85 db                	test   %ebx,%ebx
  106a86:	0f 84 bf 03 00 00    	je     106e4b <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  106a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a93:	89 1c 24             	mov    %ebx,(%esp)
  106a96:	8b 45 08             	mov    0x8(%ebp),%eax
  106a99:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  106a9e:	8d 50 01             	lea    0x1(%eax),%edx
  106aa1:	89 55 10             	mov    %edx,0x10(%ebp)
  106aa4:	0f b6 00             	movzbl (%eax),%eax
  106aa7:	0f b6 d8             	movzbl %al,%ebx
  106aaa:	83 fb 25             	cmp    $0x25,%ebx
  106aad:	75 d5                	jne    106a84 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106aaf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106ab3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106abd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106ac0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  106ac7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106aca:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  106acd:	8b 45 10             	mov    0x10(%ebp),%eax
  106ad0:	8d 50 01             	lea    0x1(%eax),%edx
  106ad3:	89 55 10             	mov    %edx,0x10(%ebp)
  106ad6:	0f b6 00             	movzbl (%eax),%eax
  106ad9:	0f b6 d8             	movzbl %al,%ebx
  106adc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106adf:	83 f8 55             	cmp    $0x55,%eax
  106ae2:	0f 87 37 03 00 00    	ja     106e1f <vprintfmt+0x3a5>
  106ae8:	8b 04 85 dc 82 10 00 	mov    0x1082dc(,%eax,4),%eax
  106aef:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106af1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106af5:	eb d6                	jmp    106acd <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  106af7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106afb:	eb d0                	jmp    106acd <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106afd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106b04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b07:	89 d0                	mov    %edx,%eax
  106b09:	c1 e0 02             	shl    $0x2,%eax
  106b0c:	01 d0                	add    %edx,%eax
  106b0e:	01 c0                	add    %eax,%eax
  106b10:	01 d8                	add    %ebx,%eax
  106b12:	83 e8 30             	sub    $0x30,%eax
  106b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  106b18:	8b 45 10             	mov    0x10(%ebp),%eax
  106b1b:	0f b6 00             	movzbl (%eax),%eax
  106b1e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  106b21:	83 fb 2f             	cmp    $0x2f,%ebx
  106b24:	7e 38                	jle    106b5e <vprintfmt+0xe4>
  106b26:	83 fb 39             	cmp    $0x39,%ebx
  106b29:	7f 33                	jg     106b5e <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  106b2b:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  106b2e:	eb d4                	jmp    106b04 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  106b30:	8b 45 14             	mov    0x14(%ebp),%eax
  106b33:	8d 50 04             	lea    0x4(%eax),%edx
  106b36:	89 55 14             	mov    %edx,0x14(%ebp)
  106b39:	8b 00                	mov    (%eax),%eax
  106b3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106b3e:	eb 1f                	jmp    106b5f <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  106b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b44:	79 87                	jns    106acd <vprintfmt+0x53>
                width = 0;
  106b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106b4d:	e9 7b ff ff ff       	jmp    106acd <vprintfmt+0x53>

        case '#':
            altflag = 1;
  106b52:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106b59:	e9 6f ff ff ff       	jmp    106acd <vprintfmt+0x53>
            goto process_precision;
  106b5e:	90                   	nop

        process_precision:
            if (width < 0)
  106b5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106b63:	0f 89 64 ff ff ff    	jns    106acd <vprintfmt+0x53>
                width = precision, precision = -1;
  106b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106b6f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106b76:	e9 52 ff ff ff       	jmp    106acd <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106b7b:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  106b7e:	e9 4a ff ff ff       	jmp    106acd <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106b83:	8b 45 14             	mov    0x14(%ebp),%eax
  106b86:	8d 50 04             	lea    0x4(%eax),%edx
  106b89:	89 55 14             	mov    %edx,0x14(%ebp)
  106b8c:	8b 00                	mov    (%eax),%eax
  106b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  106b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  106b95:	89 04 24             	mov    %eax,(%esp)
  106b98:	8b 45 08             	mov    0x8(%ebp),%eax
  106b9b:	ff d0                	call   *%eax
            break;
  106b9d:	e9 a4 02 00 00       	jmp    106e46 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  106ba5:	8d 50 04             	lea    0x4(%eax),%edx
  106ba8:	89 55 14             	mov    %edx,0x14(%ebp)
  106bab:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106bad:	85 db                	test   %ebx,%ebx
  106baf:	79 02                	jns    106bb3 <vprintfmt+0x139>
                err = -err;
  106bb1:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106bb3:	83 fb 06             	cmp    $0x6,%ebx
  106bb6:	7f 0b                	jg     106bc3 <vprintfmt+0x149>
  106bb8:	8b 34 9d 9c 82 10 00 	mov    0x10829c(,%ebx,4),%esi
  106bbf:	85 f6                	test   %esi,%esi
  106bc1:	75 23                	jne    106be6 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  106bc3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106bc7:	c7 44 24 08 c9 82 10 	movl   $0x1082c9,0x8(%esp)
  106bce:	00 
  106bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  106bd9:	89 04 24             	mov    %eax,(%esp)
  106bdc:	e8 6a fe ff ff       	call   106a4b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  106be1:	e9 60 02 00 00       	jmp    106e46 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  106be6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106bea:	c7 44 24 08 d2 82 10 	movl   $0x1082d2,0x8(%esp)
  106bf1:	00 
  106bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  106bfc:	89 04 24             	mov    %eax,(%esp)
  106bff:	e8 47 fe ff ff       	call   106a4b <printfmt>
            break;
  106c04:	e9 3d 02 00 00       	jmp    106e46 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  106c09:	8b 45 14             	mov    0x14(%ebp),%eax
  106c0c:	8d 50 04             	lea    0x4(%eax),%edx
  106c0f:	89 55 14             	mov    %edx,0x14(%ebp)
  106c12:	8b 30                	mov    (%eax),%esi
  106c14:	85 f6                	test   %esi,%esi
  106c16:	75 05                	jne    106c1d <vprintfmt+0x1a3>
                p = "(null)";
  106c18:	be d5 82 10 00       	mov    $0x1082d5,%esi
            }
            if (width > 0 && padc != '-') {
  106c1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106c21:	7e 76                	jle    106c99 <vprintfmt+0x21f>
  106c23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106c27:	74 70                	je     106c99 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  106c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c30:	89 34 24             	mov    %esi,(%esp)
  106c33:	e8 f6 f7 ff ff       	call   10642e <strnlen>
  106c38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106c3b:	29 c2                	sub    %eax,%edx
  106c3d:	89 d0                	mov    %edx,%eax
  106c3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106c42:	eb 16                	jmp    106c5a <vprintfmt+0x1e0>
                    putch(padc, putdat);
  106c44:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  106c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  106c4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  106c4f:	89 04 24             	mov    %eax,(%esp)
  106c52:	8b 45 08             	mov    0x8(%ebp),%eax
  106c55:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  106c57:	ff 4d e8             	decl   -0x18(%ebp)
  106c5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106c5e:	7f e4                	jg     106c44 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106c60:	eb 37                	jmp    106c99 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  106c62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106c66:	74 1f                	je     106c87 <vprintfmt+0x20d>
  106c68:	83 fb 1f             	cmp    $0x1f,%ebx
  106c6b:	7e 05                	jle    106c72 <vprintfmt+0x1f8>
  106c6d:	83 fb 7e             	cmp    $0x7e,%ebx
  106c70:	7e 15                	jle    106c87 <vprintfmt+0x20d>
                    putch('?', putdat);
  106c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c79:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106c80:	8b 45 08             	mov    0x8(%ebp),%eax
  106c83:	ff d0                	call   *%eax
  106c85:	eb 0f                	jmp    106c96 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  106c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c8e:	89 1c 24             	mov    %ebx,(%esp)
  106c91:	8b 45 08             	mov    0x8(%ebp),%eax
  106c94:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106c96:	ff 4d e8             	decl   -0x18(%ebp)
  106c99:	89 f0                	mov    %esi,%eax
  106c9b:	8d 70 01             	lea    0x1(%eax),%esi
  106c9e:	0f b6 00             	movzbl (%eax),%eax
  106ca1:	0f be d8             	movsbl %al,%ebx
  106ca4:	85 db                	test   %ebx,%ebx
  106ca6:	74 27                	je     106ccf <vprintfmt+0x255>
  106ca8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106cac:	78 b4                	js     106c62 <vprintfmt+0x1e8>
  106cae:	ff 4d e4             	decl   -0x1c(%ebp)
  106cb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106cb5:	79 ab                	jns    106c62 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  106cb7:	eb 16                	jmp    106ccf <vprintfmt+0x255>
                putch(' ', putdat);
  106cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  106cc0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  106cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  106cca:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  106ccc:	ff 4d e8             	decl   -0x18(%ebp)
  106ccf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106cd3:	7f e4                	jg     106cb9 <vprintfmt+0x23f>
            }
            break;
  106cd5:	e9 6c 01 00 00       	jmp    106e46 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  106ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  106ce4:	89 04 24             	mov    %eax,(%esp)
  106ce7:	e8 18 fd ff ff       	call   106a04 <getint>
  106cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106cef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106cf8:	85 d2                	test   %edx,%edx
  106cfa:	79 26                	jns    106d22 <vprintfmt+0x2a8>
                putch('-', putdat);
  106cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d03:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  106d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  106d0d:	ff d0                	call   *%eax
                num = -(long long)num;
  106d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106d15:	f7 d8                	neg    %eax
  106d17:	83 d2 00             	adc    $0x0,%edx
  106d1a:	f7 da                	neg    %edx
  106d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106d22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106d29:	e9 a8 00 00 00       	jmp    106dd6 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  106d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d35:	8d 45 14             	lea    0x14(%ebp),%eax
  106d38:	89 04 24             	mov    %eax,(%esp)
  106d3b:	e8 75 fc ff ff       	call   1069b5 <getuint>
  106d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d43:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106d46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106d4d:	e9 84 00 00 00       	jmp    106dd6 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106d52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d59:	8d 45 14             	lea    0x14(%ebp),%eax
  106d5c:	89 04 24             	mov    %eax,(%esp)
  106d5f:	e8 51 fc ff ff       	call   1069b5 <getuint>
  106d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106d67:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106d6a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106d71:	eb 63                	jmp    106dd6 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  106d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d7a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106d81:	8b 45 08             	mov    0x8(%ebp),%eax
  106d84:	ff d0                	call   *%eax
            putch('x', putdat);
  106d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  106d8d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106d94:	8b 45 08             	mov    0x8(%ebp),%eax
  106d97:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106d99:	8b 45 14             	mov    0x14(%ebp),%eax
  106d9c:	8d 50 04             	lea    0x4(%eax),%edx
  106d9f:	89 55 14             	mov    %edx,0x14(%ebp)
  106da2:	8b 00                	mov    (%eax),%eax
  106da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106da7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106dae:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106db5:	eb 1f                	jmp    106dd6 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  106dbe:	8d 45 14             	lea    0x14(%ebp),%eax
  106dc1:	89 04 24             	mov    %eax,(%esp)
  106dc4:	e8 ec fb ff ff       	call   1069b5 <getuint>
  106dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106dcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106dcf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106dd6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106ddd:	89 54 24 18          	mov    %edx,0x18(%esp)
  106de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106de4:	89 54 24 14          	mov    %edx,0x14(%esp)
  106de8:	89 44 24 10          	mov    %eax,0x10(%esp)
  106dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106df2:	89 44 24 08          	mov    %eax,0x8(%esp)
  106df6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  106dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e01:	8b 45 08             	mov    0x8(%ebp),%eax
  106e04:	89 04 24             	mov    %eax,(%esp)
  106e07:	e8 a4 fa ff ff       	call   1068b0 <printnum>
            break;
  106e0c:	eb 38                	jmp    106e46 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e15:	89 1c 24             	mov    %ebx,(%esp)
  106e18:	8b 45 08             	mov    0x8(%ebp),%eax
  106e1b:	ff d0                	call   *%eax
            break;
  106e1d:	eb 27                	jmp    106e46 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e22:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e26:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  106e30:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106e32:	ff 4d 10             	decl   0x10(%ebp)
  106e35:	eb 03                	jmp    106e3a <vprintfmt+0x3c0>
  106e37:	ff 4d 10             	decl   0x10(%ebp)
  106e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  106e3d:	48                   	dec    %eax
  106e3e:	0f b6 00             	movzbl (%eax),%eax
  106e41:	3c 25                	cmp    $0x25,%al
  106e43:	75 f2                	jne    106e37 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  106e45:	90                   	nop
    while (1) {
  106e46:	e9 37 fc ff ff       	jmp    106a82 <vprintfmt+0x8>
                return;
  106e4b:	90                   	nop
        }
    }
}
  106e4c:	83 c4 40             	add    $0x40,%esp
  106e4f:	5b                   	pop    %ebx
  106e50:	5e                   	pop    %esi
  106e51:	5d                   	pop    %ebp
  106e52:	c3                   	ret    

00106e53 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106e53:	55                   	push   %ebp
  106e54:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e59:	8b 40 08             	mov    0x8(%eax),%eax
  106e5c:	8d 50 01             	lea    0x1(%eax),%edx
  106e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e62:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e68:	8b 10                	mov    (%eax),%edx
  106e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e6d:	8b 40 04             	mov    0x4(%eax),%eax
  106e70:	39 c2                	cmp    %eax,%edx
  106e72:	73 12                	jae    106e86 <sprintputch+0x33>
        *b->buf ++ = ch;
  106e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e77:	8b 00                	mov    (%eax),%eax
  106e79:	8d 48 01             	lea    0x1(%eax),%ecx
  106e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e7f:	89 0a                	mov    %ecx,(%edx)
  106e81:	8b 55 08             	mov    0x8(%ebp),%edx
  106e84:	88 10                	mov    %dl,(%eax)
    }
}
  106e86:	90                   	nop
  106e87:	5d                   	pop    %ebp
  106e88:	c3                   	ret    

00106e89 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106e89:	55                   	push   %ebp
  106e8a:	89 e5                	mov    %esp,%ebp
  106e8c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106e8f:	8d 45 14             	lea    0x14(%ebp),%eax
  106e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106e98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  106e9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  106ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
  106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  106ead:	89 04 24             	mov    %eax,(%esp)
  106eb0:	e8 08 00 00 00       	call   106ebd <vsnprintf>
  106eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106ebb:	c9                   	leave  
  106ebc:	c3                   	ret    

00106ebd <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106ebd:	55                   	push   %ebp
  106ebe:	89 e5                	mov    %esp,%ebp
  106ec0:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  106ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  106ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  106ed2:	01 d0                	add    %edx,%eax
  106ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106ee2:	74 0a                	je     106eee <vsnprintf+0x31>
  106ee4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106eea:	39 c2                	cmp    %eax,%edx
  106eec:	76 07                	jbe    106ef5 <vsnprintf+0x38>
        return -E_INVAL;
  106eee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106ef3:	eb 2a                	jmp    106f1f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  106ef8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106efc:	8b 45 10             	mov    0x10(%ebp),%eax
  106eff:	89 44 24 08          	mov    %eax,0x8(%esp)
  106f03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106f06:	89 44 24 04          	mov    %eax,0x4(%esp)
  106f0a:	c7 04 24 53 6e 10 00 	movl   $0x106e53,(%esp)
  106f11:	e8 64 fb ff ff       	call   106a7a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106f19:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106f1f:	c9                   	leave  
  106f20:	c3                   	ret    
