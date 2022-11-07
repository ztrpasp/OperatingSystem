
bin/kernelï¼š     æ–‡ä»¶æ ¼å¼ elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 b0 11 00       	mov    $0x11b000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 b0 11 c0       	mov    %eax,0xc011b000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba c0 49 2a c0       	mov    $0xc02a49c0,%edx
c0100041:	b8 00 d0 11 c0       	mov    $0xc011d000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 d0 11 c0 	movl   $0xc011d000,(%esp)
c010005d:	e8 c5 66 00 00       	call   c0106727 <memset>

    cons_init();                // init the console
c0100062:	e8 90 15 00 00       	call   c01015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 6f 10 c0 	movl   $0xc0106f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 6f 10 c0 	movl   $0xc0106f5c,(%esp)
c010007c:	e8 21 02 00 00       	call   c01002a2 <cprintf>

    print_kerninfo();
c0100081:	e8 c2 08 00 00       	call   c0100948 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 8e 00 00 00       	call   c0100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 ad 32 00 00       	call   c010333d <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 c7 16 00 00       	call   c010175c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 4c 18 00 00       	call   c01018e6 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 fb 0c 00 00       	call   c0100d9a <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 f2 17 00 00       	call   c0101896 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c01000a4:	e8 6b 01 00 00       	call   c0100214 <lab1_switch_test>

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x73>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	55                   	push   %ebp
c01000ac:	89 e5                	mov    %esp,%ebp
c01000ae:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b8:	00 
c01000b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c0:	00 
c01000c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c8:	e8 bb 0c 00 00       	call   c0100d88 <mon_backtrace>
}
c01000cd:	90                   	nop
c01000ce:	c9                   	leave  
c01000cf:	c3                   	ret    

c01000d0 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d0:	55                   	push   %ebp
c01000d1:	89 e5                	mov    %esp,%ebp
c01000d3:	53                   	push   %ebx
c01000d4:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ef:	89 04 24             	mov    %eax,(%esp)
c01000f2:	e8 b4 ff ff ff       	call   c01000ab <grade_backtrace2>
}
c01000f7:	90                   	nop
c01000f8:	83 c4 14             	add    $0x14,%esp
c01000fb:	5b                   	pop    %ebx
c01000fc:	5d                   	pop    %ebp
c01000fd:	c3                   	ret    

c01000fe <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fe:	55                   	push   %ebp
c01000ff:	89 e5                	mov    %esp,%ebp
c0100101:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100104:	8b 45 10             	mov    0x10(%ebp),%eax
c0100107:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010b:	8b 45 08             	mov    0x8(%ebp),%eax
c010010e:	89 04 24             	mov    %eax,(%esp)
c0100111:	e8 ba ff ff ff       	call   c01000d0 <grade_backtrace1>
}
c0100116:	90                   	nop
c0100117:	c9                   	leave  
c0100118:	c3                   	ret    

c0100119 <grade_backtrace>:

void
grade_backtrace(void) {
c0100119:	55                   	push   %ebp
c010011a:	89 e5                	mov    %esp,%ebp
c010011c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100124:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012b:	ff 
c010012c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100137:	e8 c2 ff ff ff       	call   c01000fe <grade_backtrace0>
}
c010013c:	90                   	nop
c010013d:	c9                   	leave  
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 61 6f 10 c0 	movl   $0xc0106f61,(%esp)
c010016e:	e8 2f 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 6f 6f 10 c0 	movl   $0xc0106f6f,(%esp)
c010018d:	e8 10 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 7d 6f 10 c0 	movl   $0xc0106f7d,(%esp)
c01001ac:	e8 f1 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 8b 6f 10 c0 	movl   $0xc0106f8b,(%esp)
c01001cb:	e8 d2 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 99 6f 10 c0 	movl   $0xc0106f99,(%esp)
c01001ea:	e8 b3 00 00 00       	call   c01002a2 <cprintf>
    round ++;
c01001ef:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 d0 11 c0       	mov    %eax,0xc011d000
}
c01001fa:	90                   	nop
c01001fb:	c9                   	leave  
c01001fc:	c3                   	ret    

c01001fd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fd:	55                   	push   %ebp
c01001fe:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c0100200:	83 ec 08             	sub    $0x8,%esp
c0100203:	cd 78                	int    $0x78
c0100205:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c0100207:	90                   	nop
c0100208:	5d                   	pop    %ebp
c0100209:	c3                   	ret    

c010020a <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020a:	55                   	push   %ebp
c010020b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c010020d:	cd 79                	int    $0x79
c010020f:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100211:	90                   	nop
c0100212:	5d                   	pop    %ebp
c0100213:	c3                   	ret    

c0100214 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100214:	55                   	push   %ebp
c0100215:	89 e5                	mov    %esp,%ebp
c0100217:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021a:	e8 20 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021f:	c7 04 24 a8 6f 10 c0 	movl   $0xc0106fa8,(%esp)
c0100226:	e8 77 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_user();
c010022b:	e8 cd ff ff ff       	call   c01001fd <lab1_switch_to_user>
    lab1_print_cur_status();
c0100230:	e8 0a ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100235:	c7 04 24 c8 6f 10 c0 	movl   $0xc0106fc8,(%esp)
c010023c:	e8 61 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_kernel();
c0100241:	e8 c4 ff ff ff       	call   c010020a <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100246:	e8 f4 fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c010024b:	90                   	nop
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100254:	8b 45 08             	mov    0x8(%ebp),%eax
c0100257:	89 04 24             	mov    %eax,(%esp)
c010025a:	e8 c5 13 00 00       	call   c0101624 <cons_putc>
    (*cnt) ++;
c010025f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100262:	8b 00                	mov    (%eax),%eax
c0100264:	8d 50 01             	lea    0x1(%eax),%edx
c0100267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026a:	89 10                	mov    %edx,(%eax)
}
c010026c:	90                   	nop
c010026d:	c9                   	leave  
c010026e:	c3                   	ret    

c010026f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026f:	55                   	push   %ebp
c0100270:	89 e5                	mov    %esp,%ebp
c0100272:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100283:	8b 45 08             	mov    0x8(%ebp),%eax
c0100286:	89 44 24 08          	mov    %eax,0x8(%esp)
c010028a:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010028d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100291:	c7 04 24 4e 02 10 c0 	movl   $0xc010024e,(%esp)
c0100298:	e8 dd 67 00 00       	call   c0106a7a <vprintfmt>
    return cnt;
c010029d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a0:	c9                   	leave  
c01002a1:	c3                   	ret    

c01002a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a2:	55                   	push   %ebp
c01002a3:	89 e5                	mov    %esp,%ebp
c01002a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b8:	89 04 24             	mov    %eax,(%esp)
c01002bb:	e8 af ff ff ff       	call   c010026f <vcprintf>
c01002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c6:	c9                   	leave  
c01002c7:	c3                   	ret    

c01002c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c8:	55                   	push   %ebp
c01002c9:	89 e5                	mov    %esp,%ebp
c01002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d1:	89 04 24             	mov    %eax,(%esp)
c01002d4:	e8 4b 13 00 00       	call   c0101624 <cons_putc>
}
c01002d9:	90                   	nop
c01002da:	c9                   	leave  
c01002db:	c3                   	ret    

c01002dc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002dc:	55                   	push   %ebp
c01002dd:	89 e5                	mov    %esp,%ebp
c01002df:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e9:	eb 13                	jmp    c01002fe <cputs+0x22>
        cputch(c, &cnt);
c01002eb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002ef:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002f6:	89 04 24             	mov    %eax,(%esp)
c01002f9:	e8 50 ff ff ff       	call   c010024e <cputch>
    while ((c = *str ++) != '\0') {
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	8d 50 01             	lea    0x1(%eax),%edx
c0100304:	89 55 08             	mov    %edx,0x8(%ebp)
c0100307:	0f b6 00             	movzbl (%eax),%eax
c010030a:	88 45 f7             	mov    %al,-0x9(%ebp)
c010030d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100311:	75 d8                	jne    c01002eb <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100313:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100316:	89 44 24 04          	mov    %eax,0x4(%esp)
c010031a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100321:	e8 28 ff ff ff       	call   c010024e <cputch>
    return cnt;
c0100326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100329:	c9                   	leave  
c010032a:	c3                   	ret    

c010032b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010032b:	55                   	push   %ebp
c010032c:	89 e5                	mov    %esp,%ebp
c010032e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100331:	e8 2b 13 00 00       	call   c0101661 <cons_getc>
c0100336:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010033d:	74 f2                	je     c0100331 <getchar+0x6>
        /* do nothing */;
    return c;
c010033f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100342:	c9                   	leave  
c0100343:	c3                   	ret    

c0100344 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100344:	55                   	push   %ebp
c0100345:	89 e5                	mov    %esp,%ebp
c0100347:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010034a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010034e:	74 13                	je     c0100363 <readline+0x1f>
        cprintf("%s", prompt);
c0100350:	8b 45 08             	mov    0x8(%ebp),%eax
c0100353:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100357:	c7 04 24 e7 6f 10 c0 	movl   $0xc0106fe7,(%esp)
c010035e:	e8 3f ff ff ff       	call   c01002a2 <cprintf>
    }
    int i = 0, c;
c0100363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010036a:	e8 bc ff ff ff       	call   c010032b <getchar>
c010036f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100376:	79 07                	jns    c010037f <readline+0x3b>
            return NULL;
c0100378:	b8 00 00 00 00       	mov    $0x0,%eax
c010037d:	eb 78                	jmp    c01003f7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010037f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100383:	7e 28                	jle    c01003ad <readline+0x69>
c0100385:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010038c:	7f 1f                	jg     c01003ad <readline+0x69>
            cputchar(c);
c010038e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100391:	89 04 24             	mov    %eax,(%esp)
c0100394:	e8 2f ff ff ff       	call   c01002c8 <cputchar>
            buf[i ++] = c;
c0100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010039c:	8d 50 01             	lea    0x1(%eax),%edx
c010039f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003a5:	88 90 20 d0 11 c0    	mov    %dl,-0x3fee2fe0(%eax)
c01003ab:	eb 45                	jmp    c01003f2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003ad:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003b1:	75 16                	jne    c01003c9 <readline+0x85>
c01003b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b7:	7e 10                	jle    c01003c9 <readline+0x85>
            cputchar(c);
c01003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003bc:	89 04 24             	mov    %eax,(%esp)
c01003bf:	e8 04 ff ff ff       	call   c01002c8 <cputchar>
            i --;
c01003c4:	ff 4d f4             	decl   -0xc(%ebp)
c01003c7:	eb 29                	jmp    c01003f2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003cd:	74 06                	je     c01003d5 <readline+0x91>
c01003cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003d3:	75 95                	jne    c010036a <readline+0x26>
            cputchar(c);
c01003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d8:	89 04 24             	mov    %eax,(%esp)
c01003db:	e8 e8 fe ff ff       	call   c01002c8 <cputchar>
            buf[i] = '\0';
c01003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e3:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c01003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003eb:	b8 20 d0 11 c0       	mov    $0xc011d020,%eax
c01003f0:	eb 05                	jmp    c01003f7 <readline+0xb3>
        c = getchar();
c01003f2:	e9 73 ff ff ff       	jmp    c010036a <readline+0x26>
        }
    }
}
c01003f7:	c9                   	leave  
c01003f8:	c3                   	ret    

c01003f9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f9:	55                   	push   %ebp
c01003fa:	89 e5                	mov    %esp,%ebp
c01003fc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ff:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
c0100404:	85 c0                	test   %eax,%eax
c0100406:	75 5b                	jne    c0100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100408:	c7 05 20 d4 11 c0 01 	movl   $0x1,0xc011d420
c010040f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100412:	8d 45 14             	lea    0x14(%ebp),%eax
c0100415:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100418:	8b 45 0c             	mov    0xc(%ebp),%eax
c010041b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010041f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100422:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100426:	c7 04 24 ea 6f 10 c0 	movl   $0xc0106fea,(%esp)
c010042d:	e8 70 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c0100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100435:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100439:	8b 45 10             	mov    0x10(%ebp),%eax
c010043c:	89 04 24             	mov    %eax,(%esp)
c010043f:	e8 2b fe ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c0100444:	c7 04 24 06 70 10 c0 	movl   $0xc0107006,(%esp)
c010044b:	e8 52 fe ff ff       	call   c01002a2 <cprintf>
    
    cprintf("stack trackback:\n");
c0100450:	c7 04 24 08 70 10 c0 	movl   $0xc0107008,(%esp)
c0100457:	e8 46 fe ff ff       	call   c01002a2 <cprintf>
    print_stackframe();
c010045c:	e8 32 06 00 00       	call   c0100a93 <print_stackframe>
c0100461:	eb 01                	jmp    c0100464 <__panic+0x6b>
        goto panic_dead;
c0100463:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100464:	e8 34 14 00 00       	call   c010189d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100470:	e8 46 08 00 00       	call   c0100cbb <kmonitor>
c0100475:	eb f2                	jmp    c0100469 <__panic+0x70>

c0100477 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100477:	55                   	push   %ebp
c0100478:	89 e5                	mov    %esp,%ebp
c010047a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010047d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100480:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100483:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100486:	89 44 24 08          	mov    %eax,0x8(%esp)
c010048a:	8b 45 08             	mov    0x8(%ebp),%eax
c010048d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100491:	c7 04 24 1a 70 10 c0 	movl   $0xc010701a,(%esp)
c0100498:	e8 05 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c010049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a7:	89 04 24             	mov    %eax,(%esp)
c01004aa:	e8 c0 fd ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c01004af:	c7 04 24 06 70 10 c0 	movl   $0xc0107006,(%esp)
c01004b6:	e8 e7 fd ff ff       	call   c01002a2 <cprintf>
    va_end(ap);
}
c01004bb:	90                   	nop
c01004bc:	c9                   	leave  
c01004bd:	c3                   	ret    

c01004be <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004be:	55                   	push   %ebp
c01004bf:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004c1:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
}
c01004c6:	5d                   	pop    %ebp
c01004c7:	c3                   	ret    

c01004c8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c8:	55                   	push   %ebp
c01004c9:	89 e5                	mov    %esp,%ebp
c01004cb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 00                	mov    (%eax),%eax
c01004d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d9:	8b 00                	mov    (%eax),%eax
c01004db:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004e5:	e9 ca 00 00 00       	jmp    c01005b4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f0:	01 d0                	add    %edx,%eax
c01004f2:	89 c2                	mov    %eax,%edx
c01004f4:	c1 ea 1f             	shr    $0x1f,%edx
c01004f7:	01 d0                	add    %edx,%eax
c01004f9:	d1 f8                	sar    %eax
c01004fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100501:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100504:	eb 03                	jmp    c0100509 <stab_binsearch+0x41>
            m --;
c0100506:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100509:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050f:	7c 1f                	jl     c0100530 <stab_binsearch+0x68>
c0100511:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100514:	89 d0                	mov    %edx,%eax
c0100516:	01 c0                	add    %eax,%eax
c0100518:	01 d0                	add    %edx,%eax
c010051a:	c1 e0 02             	shl    $0x2,%eax
c010051d:	89 c2                	mov    %eax,%edx
c010051f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100528:	0f b6 c0             	movzbl %al,%eax
c010052b:	39 45 14             	cmp    %eax,0x14(%ebp)
c010052e:	75 d6                	jne    c0100506 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100530:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100533:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100536:	7d 09                	jge    c0100541 <stab_binsearch+0x79>
            l = true_m + 1;
c0100538:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053b:	40                   	inc    %eax
c010053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010053f:	eb 73                	jmp    c01005b4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010054b:	89 d0                	mov    %edx,%eax
c010054d:	01 c0                	add    %eax,%eax
c010054f:	01 d0                	add    %edx,%eax
c0100551:	c1 e0 02             	shl    $0x2,%eax
c0100554:	89 c2                	mov    %eax,%edx
c0100556:	8b 45 08             	mov    0x8(%ebp),%eax
c0100559:	01 d0                	add    %edx,%eax
c010055b:	8b 40 08             	mov    0x8(%eax),%eax
c010055e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100561:	76 11                	jbe    c0100574 <stab_binsearch+0xac>
            *region_left = m;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	40                   	inc    %eax
c010056f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100572:	eb 40                	jmp    c01005b4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c0100574:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100577:	89 d0                	mov    %edx,%eax
c0100579:	01 c0                	add    %eax,%eax
c010057b:	01 d0                	add    %edx,%eax
c010057d:	c1 e0 02             	shl    $0x2,%eax
c0100580:	89 c2                	mov    %eax,%edx
c0100582:	8b 45 08             	mov    0x8(%ebp),%eax
c0100585:	01 d0                	add    %edx,%eax
c0100587:	8b 40 08             	mov    0x8(%eax),%eax
c010058a:	39 45 18             	cmp    %eax,0x18(%ebp)
c010058d:	73 14                	jae    c01005a3 <stab_binsearch+0xdb>
            *region_right = m - 1;
c010058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100592:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100595:	8b 45 10             	mov    0x10(%ebp),%eax
c0100598:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059d:	48                   	dec    %eax
c010059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a1:	eb 11                	jmp    c01005b4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a9:	89 10                	mov    %edx,(%eax)
            l = m;
c01005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005ba:	0f 8e 2a ff ff ff    	jle    c01004ea <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005c4:	75 0f                	jne    c01005d5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c9:	8b 00                	mov    (%eax),%eax
c01005cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005d3:	eb 3e                	jmp    c0100613 <stab_binsearch+0x14b>
        l = *region_right;
c01005d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d8:	8b 00                	mov    (%eax),%eax
c01005da:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005dd:	eb 03                	jmp    c01005e2 <stab_binsearch+0x11a>
c01005df:	ff 4d fc             	decl   -0x4(%ebp)
c01005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e5:	8b 00                	mov    (%eax),%eax
c01005e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005ea:	7e 1f                	jle    c010060b <stab_binsearch+0x143>
c01005ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ef:	89 d0                	mov    %edx,%eax
c01005f1:	01 c0                	add    %eax,%eax
c01005f3:	01 d0                	add    %edx,%eax
c01005f5:	c1 e0 02             	shl    $0x2,%eax
c01005f8:	89 c2                	mov    %eax,%edx
c01005fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01005fd:	01 d0                	add    %edx,%eax
c01005ff:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100603:	0f b6 c0             	movzbl %al,%eax
c0100606:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100609:	75 d4                	jne    c01005df <stab_binsearch+0x117>
        *region_left = l;
c010060b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100611:	89 10                	mov    %edx,(%eax)
}
c0100613:	90                   	nop
c0100614:	c9                   	leave  
c0100615:	c3                   	ret    

c0100616 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100616:	55                   	push   %ebp
c0100617:	89 e5                	mov    %esp,%ebp
c0100619:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010061c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061f:	c7 00 38 70 10 c0    	movl   $0xc0107038,(%eax)
    info->eip_line = 0;
c0100625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	c7 40 08 38 70 10 c0 	movl   $0xc0107038,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100646:	8b 55 08             	mov    0x8(%ebp),%edx
c0100649:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010064c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100656:	c7 45 f4 34 84 10 c0 	movl   $0xc0108434,-0xc(%ebp)
    stab_end = __STAB_END__;
c010065d:	c7 45 f0 60 48 11 c0 	movl   $0xc0114860,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100664:	c7 45 ec 61 48 11 c0 	movl   $0xc0114861,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010066b:	c7 45 e8 41 76 11 c0 	movl   $0xc0117641,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100678:	76 0b                	jbe    c0100685 <debuginfo_eip+0x6f>
c010067a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067d:	48                   	dec    %eax
c010067e:	0f b6 00             	movzbl (%eax),%eax
c0100681:	84 c0                	test   %al,%al
c0100683:	74 0a                	je     c010068f <debuginfo_eip+0x79>
        return -1;
c0100685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010068a:	e9 b7 02 00 00       	jmp    c0100946 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010068f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100696:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069c:	29 c2                	sub    %eax,%edx
c010069e:	89 d0                	mov    %edx,%eax
c01006a0:	c1 f8 02             	sar    $0x2,%eax
c01006a3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006a9:	48                   	dec    %eax
c01006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006b4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006bb:	00 
c01006bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006bf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006cd:	89 04 24             	mov    %eax,(%esp)
c01006d0:	e8 f3 fd ff ff       	call   c01004c8 <stab_binsearch>
    if (lfile == 0)
c01006d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d8:	85 c0                	test   %eax,%eax
c01006da:	75 0a                	jne    c01006e6 <debuginfo_eip+0xd0>
        return -1;
c01006dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e1:	e9 60 02 00 00       	jmp    c0100946 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006f5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006f9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100700:	00 
c0100701:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100704:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100708:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010070b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100712:	89 04 24             	mov    %eax,(%esp)
c0100715:	e8 ae fd ff ff       	call   c01004c8 <stab_binsearch>

    if (lfun <= rfun) {
c010071a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010071d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100720:	39 c2                	cmp    %eax,%edx
c0100722:	7f 7c                	jg     c01007a0 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100724:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100727:	89 c2                	mov    %eax,%edx
c0100729:	89 d0                	mov    %edx,%eax
c010072b:	01 c0                	add    %eax,%eax
c010072d:	01 d0                	add    %edx,%eax
c010072f:	c1 e0 02             	shl    $0x2,%eax
c0100732:	89 c2                	mov    %eax,%edx
c0100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	8b 00                	mov    (%eax),%eax
c010073b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010073e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100741:	29 d1                	sub    %edx,%ecx
c0100743:	89 ca                	mov    %ecx,%edx
c0100745:	39 d0                	cmp    %edx,%eax
c0100747:	73 22                	jae    c010076b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	89 d0                	mov    %edx,%eax
c0100750:	01 c0                	add    %eax,%eax
c0100752:	01 d0                	add    %edx,%eax
c0100754:	c1 e0 02             	shl    $0x2,%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	8b 10                	mov    (%eax),%edx
c0100760:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100763:	01 c2                	add    %eax,%edx
c0100765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100768:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010076e:	89 c2                	mov    %eax,%edx
c0100770:	89 d0                	mov    %edx,%eax
c0100772:	01 c0                	add    %eax,%eax
c0100774:	01 d0                	add    %edx,%eax
c0100776:	c1 e0 02             	shl    $0x2,%eax
c0100779:	89 c2                	mov    %eax,%edx
c010077b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077e:	01 d0                	add    %edx,%eax
c0100780:	8b 50 08             	mov    0x8(%eax),%edx
c0100783:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100786:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078c:	8b 40 10             	mov    0x10(%eax),%eax
c010078f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100798:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010079b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010079e:	eb 15                	jmp    c01007b5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007a6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b8:	8b 40 08             	mov    0x8(%eax),%eax
c01007bb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007c2:	00 
c01007c3:	89 04 24             	mov    %eax,(%esp)
c01007c6:	e8 d8 5d 00 00       	call   c01065a3 <strfind>
c01007cb:	89 c2                	mov    %eax,%edx
c01007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d0:	8b 40 08             	mov    0x8(%eax),%eax
c01007d3:	29 c2                	sub    %eax,%edx
c01007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007db:	8b 45 08             	mov    0x8(%ebp),%eax
c01007de:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007e2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007e9:	00 
c01007ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007f1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fb:	89 04 24             	mov    %eax,(%esp)
c01007fe:	e8 c5 fc ff ff       	call   c01004c8 <stab_binsearch>
    if (lline <= rline) {
c0100803:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100806:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100809:	39 c2                	cmp    %eax,%edx
c010080b:	7f 23                	jg     c0100830 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c010080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100826:	89 c2                	mov    %eax,%edx
c0100828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010082e:	eb 11                	jmp    c0100841 <debuginfo_eip+0x22b>
        return -1;
c0100830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100835:	e9 0c 01 00 00       	jmp    c0100946 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010083a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083d:	48                   	dec    %eax
c010083e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100847:	39 c2                	cmp    %eax,%edx
c0100849:	7c 56                	jl     c01008a1 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c010084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084e:	89 c2                	mov    %eax,%edx
c0100850:	89 d0                	mov    %edx,%eax
c0100852:	01 c0                	add    %eax,%eax
c0100854:	01 d0                	add    %edx,%eax
c0100856:	c1 e0 02             	shl    $0x2,%eax
c0100859:	89 c2                	mov    %eax,%edx
c010085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100864:	3c 84                	cmp    $0x84,%al
c0100866:	74 39                	je     c01008a1 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086b:	89 c2                	mov    %eax,%edx
c010086d:	89 d0                	mov    %edx,%eax
c010086f:	01 c0                	add    %eax,%eax
c0100871:	01 d0                	add    %edx,%eax
c0100873:	c1 e0 02             	shl    $0x2,%eax
c0100876:	89 c2                	mov    %eax,%edx
c0100878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087b:	01 d0                	add    %edx,%eax
c010087d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100881:	3c 64                	cmp    $0x64,%al
c0100883:	75 b5                	jne    c010083a <debuginfo_eip+0x224>
c0100885:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100888:	89 c2                	mov    %eax,%edx
c010088a:	89 d0                	mov    %edx,%eax
c010088c:	01 c0                	add    %eax,%eax
c010088e:	01 d0                	add    %edx,%eax
c0100890:	c1 e0 02             	shl    $0x2,%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	8b 40 08             	mov    0x8(%eax),%eax
c010089d:	85 c0                	test   %eax,%eax
c010089f:	74 99                	je     c010083a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008a7:	39 c2                	cmp    %eax,%edx
c01008a9:	7c 46                	jl     c01008f1 <debuginfo_eip+0x2db>
c01008ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008ae:	89 c2                	mov    %eax,%edx
c01008b0:	89 d0                	mov    %edx,%eax
c01008b2:	01 c0                	add    %eax,%eax
c01008b4:	01 d0                	add    %edx,%eax
c01008b6:	c1 e0 02             	shl    $0x2,%eax
c01008b9:	89 c2                	mov    %eax,%edx
c01008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008be:	01 d0                	add    %edx,%eax
c01008c0:	8b 00                	mov    (%eax),%eax
c01008c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008c8:	29 d1                	sub    %edx,%ecx
c01008ca:	89 ca                	mov    %ecx,%edx
c01008cc:	39 d0                	cmp    %edx,%eax
c01008ce:	73 21                	jae    c01008f1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d3:	89 c2                	mov    %eax,%edx
c01008d5:	89 d0                	mov    %edx,%eax
c01008d7:	01 c0                	add    %eax,%eax
c01008d9:	01 d0                	add    %edx,%eax
c01008db:	c1 e0 02             	shl    $0x2,%eax
c01008de:	89 c2                	mov    %eax,%edx
c01008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e3:	01 d0                	add    %edx,%eax
c01008e5:	8b 10                	mov    (%eax),%edx
c01008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008ea:	01 c2                	add    %eax,%edx
c01008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ef:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008f7:	39 c2                	cmp    %eax,%edx
c01008f9:	7d 46                	jge    c0100941 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c01008fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008fe:	40                   	inc    %eax
c01008ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100902:	eb 16                	jmp    c010091a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100904:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100907:	8b 40 14             	mov    0x14(%eax),%eax
c010090a:	8d 50 01             	lea    0x1(%eax),%edx
c010090d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100910:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100916:	40                   	inc    %eax
c0100917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100920:	39 c2                	cmp    %eax,%edx
c0100922:	7d 1d                	jge    c0100941 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100927:	89 c2                	mov    %eax,%edx
c0100929:	89 d0                	mov    %edx,%eax
c010092b:	01 c0                	add    %eax,%eax
c010092d:	01 d0                	add    %edx,%eax
c010092f:	c1 e0 02             	shl    $0x2,%eax
c0100932:	89 c2                	mov    %eax,%edx
c0100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100937:	01 d0                	add    %edx,%eax
c0100939:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010093d:	3c a0                	cmp    $0xa0,%al
c010093f:	74 c3                	je     c0100904 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c0100941:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100946:	c9                   	leave  
c0100947:	c3                   	ret    

c0100948 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100948:	55                   	push   %ebp
c0100949:	89 e5                	mov    %esp,%ebp
c010094b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010094e:	c7 04 24 42 70 10 c0 	movl   $0xc0107042,(%esp)
c0100955:	e8 48 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010095a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100961:	c0 
c0100962:	c7 04 24 5b 70 10 c0 	movl   $0xc010705b,(%esp)
c0100969:	e8 34 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010096e:	c7 44 24 04 21 6f 10 	movl   $0xc0106f21,0x4(%esp)
c0100975:	c0 
c0100976:	c7 04 24 73 70 10 c0 	movl   $0xc0107073,(%esp)
c010097d:	e8 20 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100982:	c7 44 24 04 00 d0 11 	movl   $0xc011d000,0x4(%esp)
c0100989:	c0 
c010098a:	c7 04 24 8b 70 10 c0 	movl   $0xc010708b,(%esp)
c0100991:	e8 0c f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100996:	c7 44 24 04 c0 49 2a 	movl   $0xc02a49c0,0x4(%esp)
c010099d:	c0 
c010099e:	c7 04 24 a3 70 10 c0 	movl   $0xc01070a3,(%esp)
c01009a5:	e8 f8 f8 ff ff       	call   c01002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009aa:	b8 c0 49 2a c0       	mov    $0xc02a49c0,%eax
c01009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ba:	29 c2                	sub    %eax,%edx
c01009bc:	89 d0                	mov    %edx,%eax
c01009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c4:	85 c0                	test   %eax,%eax
c01009c6:	0f 48 c2             	cmovs  %edx,%eax
c01009c9:	c1 f8 0a             	sar    $0xa,%eax
c01009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d0:	c7 04 24 bc 70 10 c0 	movl   $0xc01070bc,(%esp)
c01009d7:	e8 c6 f8 ff ff       	call   c01002a2 <cprintf>
}
c01009dc:	90                   	nop
c01009dd:	c9                   	leave  
c01009de:	c3                   	ret    

c01009df <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009df:	55                   	push   %ebp
c01009e0:	89 e5                	mov    %esp,%ebp
c01009e2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f2:	89 04 24             	mov    %eax,(%esp)
c01009f5:	e8 1c fc ff ff       	call   c0100616 <debuginfo_eip>
c01009fa:	85 c0                	test   %eax,%eax
c01009fc:	74 15                	je     c0100a13 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a05:	c7 04 24 e6 70 10 c0 	movl   $0xc01070e6,(%esp)
c0100a0c:	e8 91 f8 ff ff       	call   c01002a2 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a11:	eb 6c                	jmp    c0100a7f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a1a:	eb 1b                	jmp    c0100a37 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a22:	01 d0                	add    %edx,%eax
c0100a24:	0f b6 00             	movzbl (%eax),%eax
c0100a27:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a30:	01 ca                	add    %ecx,%edx
c0100a32:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a34:	ff 45 f4             	incl   -0xc(%ebp)
c0100a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a3d:	7c dd                	jl     c0100a1c <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a3f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a48:	01 d0                	add    %edx,%eax
c0100a4a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a50:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a53:	89 d1                	mov    %edx,%ecx
c0100a55:	29 c1                	sub    %eax,%ecx
c0100a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a61:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a73:	c7 04 24 02 71 10 c0 	movl   $0xc0107102,(%esp)
c0100a7a:	e8 23 f8 ff ff       	call   c01002a2 <cprintf>
}
c0100a7f:	90                   	nop
c0100a80:	c9                   	leave  
c0100a81:	c3                   	ret    

c0100a82 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a82:	55                   	push   %ebp
c0100a83:	89 e5                	mov    %esp,%ebp
c0100a85:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a88:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a91:	c9                   	leave  
c0100a92:	c3                   	ret    

c0100a93 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a93:	55                   	push   %ebp
c0100a94:	89 e5                	mov    %esp,%ebp
c0100a96:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a99:	89 e8                	mov    %ebp,%eax
c0100a9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();
c0100aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100aa4:	e8 d9 ff ff ff       	call   c0100a82 <read_eip>
c0100aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100aac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ab3:	e9 84 00 00 00       	jmp    c0100b3c <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac6:	c7 04 24 14 71 10 c0 	movl   $0xc0107114,(%esp)
c0100acd:	e8 d0 f7 ff ff       	call   c01002a2 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad5:	83 c0 08             	add    $0x8,%eax
c0100ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100adb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100ae2:	eb 24                	jmp    c0100b08 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
c0100ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ae7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100af1:	01 d0                	add    %edx,%eax
c0100af3:	8b 00                	mov    (%eax),%eax
c0100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100af9:	c7 04 24 30 71 10 c0 	movl   $0xc0107130,(%esp)
c0100b00:	e8 9d f7 ff ff       	call   c01002a2 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100b05:	ff 45 e8             	incl   -0x18(%ebp)
c0100b08:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b0c:	7e d6                	jle    c0100ae4 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b0e:	c7 04 24 38 71 10 c0 	movl   $0xc0107138,(%esp)
c0100b15:	e8 88 f7 ff ff       	call   c01002a2 <cprintf>
        print_debuginfo(eip - 1);
c0100b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b1d:	48                   	dec    %eax
c0100b1e:	89 04 24             	mov    %eax,(%esp)
c0100b21:	e8 b9 fe ff ff       	call   c01009df <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b29:	83 c0 04             	add    $0x4,%eax
c0100b2c:	8b 00                	mov    (%eax),%eax
c0100b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b34:	8b 00                	mov    (%eax),%eax
c0100b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b39:	ff 45 ec             	incl   -0x14(%ebp)
c0100b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b40:	74 0a                	je     c0100b4c <print_stackframe+0xb9>
c0100b42:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b46:	0f 8e 6c ff ff ff    	jle    c0100ab8 <print_stackframe+0x25>
    }
}
c0100b4c:	90                   	nop
c0100b4d:	c9                   	leave  
c0100b4e:	c3                   	ret    

c0100b4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b4f:	55                   	push   %ebp
c0100b50:	89 e5                	mov    %esp,%ebp
c0100b52:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b5c:	eb 0c                	jmp    c0100b6a <parse+0x1b>
            *buf ++ = '\0';
c0100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b61:	8d 50 01             	lea    0x1(%eax),%edx
c0100b64:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b67:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6d:	0f b6 00             	movzbl (%eax),%eax
c0100b70:	84 c0                	test   %al,%al
c0100b72:	74 1d                	je     c0100b91 <parse+0x42>
c0100b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b77:	0f b6 00             	movzbl (%eax),%eax
c0100b7a:	0f be c0             	movsbl %al,%eax
c0100b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b81:	c7 04 24 bc 71 10 c0 	movl   $0xc01071bc,(%esp)
c0100b88:	e8 e4 59 00 00       	call   c0106571 <strchr>
c0100b8d:	85 c0                	test   %eax,%eax
c0100b8f:	75 cd                	jne    c0100b5e <parse+0xf>
        }
        if (*buf == '\0') {
c0100b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b94:	0f b6 00             	movzbl (%eax),%eax
c0100b97:	84 c0                	test   %al,%al
c0100b99:	74 65                	je     c0100c00 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b9b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b9f:	75 14                	jne    c0100bb5 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ba1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ba8:	00 
c0100ba9:	c7 04 24 c1 71 10 c0 	movl   $0xc01071c1,(%esp)
c0100bb0:	e8 ed f6 ff ff       	call   c01002a2 <cprintf>
        }
        argv[argc ++] = buf;
c0100bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb8:	8d 50 01             	lea    0x1(%eax),%edx
c0100bbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bc8:	01 c2                	add    %eax,%edx
c0100bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bcf:	eb 03                	jmp    c0100bd4 <parse+0x85>
            buf ++;
c0100bd1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd7:	0f b6 00             	movzbl (%eax),%eax
c0100bda:	84 c0                	test   %al,%al
c0100bdc:	74 8c                	je     c0100b6a <parse+0x1b>
c0100bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be1:	0f b6 00             	movzbl (%eax),%eax
c0100be4:	0f be c0             	movsbl %al,%eax
c0100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100beb:	c7 04 24 bc 71 10 c0 	movl   $0xc01071bc,(%esp)
c0100bf2:	e8 7a 59 00 00       	call   c0106571 <strchr>
c0100bf7:	85 c0                	test   %eax,%eax
c0100bf9:	74 d6                	je     c0100bd1 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bfb:	e9 6a ff ff ff       	jmp    c0100b6a <parse+0x1b>
            break;
c0100c00:	90                   	nop
        }
    }
    return argc;
c0100c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c04:	c9                   	leave  
c0100c05:	c3                   	ret    

c0100c06 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c06:	55                   	push   %ebp
c0100c07:	89 e5                	mov    %esp,%ebp
c0100c09:	53                   	push   %ebx
c0100c0a:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c0d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c17:	89 04 24             	mov    %eax,(%esp)
c0100c1a:	e8 30 ff ff ff       	call   c0100b4f <parse>
c0100c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c26:	75 0a                	jne    c0100c32 <runcmd+0x2c>
        return 0;
c0100c28:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c2d:	e9 83 00 00 00       	jmp    c0100cb5 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c39:	eb 5a                	jmp    c0100c95 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c3b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c41:	89 d0                	mov    %edx,%eax
c0100c43:	01 c0                	add    %eax,%eax
c0100c45:	01 d0                	add    %edx,%eax
c0100c47:	c1 e0 02             	shl    $0x2,%eax
c0100c4a:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100c4f:	8b 00                	mov    (%eax),%eax
c0100c51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c55:	89 04 24             	mov    %eax,(%esp)
c0100c58:	e8 77 58 00 00       	call   c01064d4 <strcmp>
c0100c5d:	85 c0                	test   %eax,%eax
c0100c5f:	75 31                	jne    c0100c92 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c64:	89 d0                	mov    %edx,%eax
c0100c66:	01 c0                	add    %eax,%eax
c0100c68:	01 d0                	add    %edx,%eax
c0100c6a:	c1 e0 02             	shl    $0x2,%eax
c0100c6d:	05 08 a0 11 c0       	add    $0xc011a008,%eax
c0100c72:	8b 10                	mov    (%eax),%edx
c0100c74:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c77:	83 c0 04             	add    $0x4,%eax
c0100c7a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c7d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8b:	89 1c 24             	mov    %ebx,(%esp)
c0100c8e:	ff d2                	call   *%edx
c0100c90:	eb 23                	jmp    c0100cb5 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c92:	ff 45 f4             	incl   -0xc(%ebp)
c0100c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c98:	83 f8 02             	cmp    $0x2,%eax
c0100c9b:	76 9e                	jbe    c0100c3b <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca4:	c7 04 24 df 71 10 c0 	movl   $0xc01071df,(%esp)
c0100cab:	e8 f2 f5 ff ff       	call   c01002a2 <cprintf>
    return 0;
c0100cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb5:	83 c4 64             	add    $0x64,%esp
c0100cb8:	5b                   	pop    %ebx
c0100cb9:	5d                   	pop    %ebp
c0100cba:	c3                   	ret    

c0100cbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cbb:	55                   	push   %ebp
c0100cbc:	89 e5                	mov    %esp,%ebp
c0100cbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cc1:	c7 04 24 f8 71 10 c0 	movl   $0xc01071f8,(%esp)
c0100cc8:	e8 d5 f5 ff ff       	call   c01002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100ccd:	c7 04 24 20 72 10 c0 	movl   $0xc0107220,(%esp)
c0100cd4:	e8 c9 f5 ff ff       	call   c01002a2 <cprintf>

    if (tf != NULL) {
c0100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cdd:	74 0b                	je     c0100cea <kmonitor+0x2f>
        print_trapframe(tf);
c0100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ce2:	89 04 24             	mov    %eax,(%esp)
c0100ce5:	e8 b4 0d 00 00       	call   c0101a9e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cea:	c7 04 24 45 72 10 c0 	movl   $0xc0107245,(%esp)
c0100cf1:	e8 4e f6 ff ff       	call   c0100344 <readline>
c0100cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cfd:	74 eb                	je     c0100cea <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d09:	89 04 24             	mov    %eax,(%esp)
c0100d0c:	e8 f5 fe ff ff       	call   c0100c06 <runcmd>
c0100d11:	85 c0                	test   %eax,%eax
c0100d13:	78 02                	js     c0100d17 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100d15:	eb d3                	jmp    c0100cea <kmonitor+0x2f>
                break;
c0100d17:	90                   	nop
            }
        }
    }
}
c0100d18:	90                   	nop
c0100d19:	c9                   	leave  
c0100d1a:	c3                   	ret    

c0100d1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d1b:	55                   	push   %ebp
c0100d1c:	89 e5                	mov    %esp,%ebp
c0100d1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d28:	eb 3d                	jmp    c0100d67 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d2d:	89 d0                	mov    %edx,%eax
c0100d2f:	01 c0                	add    %eax,%eax
c0100d31:	01 d0                	add    %edx,%eax
c0100d33:	c1 e0 02             	shl    $0x2,%eax
c0100d36:	05 04 a0 11 c0       	add    $0xc011a004,%eax
c0100d3b:	8b 08                	mov    (%eax),%ecx
c0100d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d40:	89 d0                	mov    %edx,%eax
c0100d42:	01 c0                	add    %eax,%eax
c0100d44:	01 d0                	add    %edx,%eax
c0100d46:	c1 e0 02             	shl    $0x2,%eax
c0100d49:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100d4e:	8b 00                	mov    (%eax),%eax
c0100d50:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d58:	c7 04 24 49 72 10 c0 	movl   $0xc0107249,(%esp)
c0100d5f:	e8 3e f5 ff ff       	call   c01002a2 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d64:	ff 45 f4             	incl   -0xc(%ebp)
c0100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6a:	83 f8 02             	cmp    $0x2,%eax
c0100d6d:	76 bb                	jbe    c0100d2a <mon_help+0xf>
    }
    return 0;
c0100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d74:	c9                   	leave  
c0100d75:	c3                   	ret    

c0100d76 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
c0100d79:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d7c:	e8 c7 fb ff ff       	call   c0100948 <print_kerninfo>
    return 0;
c0100d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d86:	c9                   	leave  
c0100d87:	c3                   	ret    

c0100d88 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d88:	55                   	push   %ebp
c0100d89:	89 e5                	mov    %esp,%ebp
c0100d8b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d8e:	e8 00 fd ff ff       	call   c0100a93 <print_stackframe>
    return 0;
c0100d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d98:	c9                   	leave  
c0100d99:	c3                   	ret    

c0100d9a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d9a:	55                   	push   %ebp
c0100d9b:	89 e5                	mov    %esp,%ebp
c0100d9d:	83 ec 28             	sub    $0x28,%esp
c0100da0:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100da6:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100daa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100db2:	ee                   	out    %al,(%dx)
c0100db3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc5:	ee                   	out    %al,(%dx)
c0100dc6:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100dcc:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100dd0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dd4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dd8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd9:	c7 05 0c df 11 c0 00 	movl   $0x0,0xc011df0c
c0100de0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de3:	c7 04 24 52 72 10 c0 	movl   $0xc0107252,(%esp)
c0100dea:	e8 b3 f4 ff ff       	call   c01002a2 <cprintf>
    pic_enable(IRQ_TIMER);
c0100def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df6:	e8 2e 09 00 00       	call   c0101729 <pic_enable>
}
c0100dfb:	90                   	nop
c0100dfc:	c9                   	leave  
c0100dfd:	c3                   	ret    

c0100dfe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfe:	55                   	push   %ebp
c0100dff:	89 e5                	mov    %esp,%ebp
c0100e01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e04:	9c                   	pushf  
c0100e05:	58                   	pop    %eax
c0100e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0c:	25 00 02 00 00       	and    $0x200,%eax
c0100e11:	85 c0                	test   %eax,%eax
c0100e13:	74 0c                	je     c0100e21 <__intr_save+0x23>
        intr_disable();
c0100e15:	e8 83 0a 00 00       	call   c010189d <intr_disable>
        return 1;
c0100e1a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1f:	eb 05                	jmp    c0100e26 <__intr_save+0x28>
    }
    return 0;
c0100e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e26:	c9                   	leave  
c0100e27:	c3                   	ret    

c0100e28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e28:	55                   	push   %ebp
c0100e29:	89 e5                	mov    %esp,%ebp
c0100e2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e32:	74 05                	je     c0100e39 <__intr_restore+0x11>
        intr_enable();
c0100e34:	e8 5d 0a 00 00       	call   c0101896 <intr_enable>
    }
}
c0100e39:	90                   	nop
c0100e3a:	c9                   	leave  
c0100e3b:	c3                   	ret    

c0100e3c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e3c:	55                   	push   %ebp
c0100e3d:	89 e5                	mov    %esp,%ebp
c0100e3f:	83 ec 10             	sub    $0x10,%esp
c0100e42:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e48:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e4c:	89 c2                	mov    %eax,%edx
c0100e4e:	ec                   	in     (%dx),%al
c0100e4f:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e52:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e58:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5c:	89 c2                	mov    %eax,%edx
c0100e5e:	ec                   	in     (%dx),%al
c0100e5f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e62:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e68:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6c:	89 c2                	mov    %eax,%edx
c0100e6e:	ec                   	in     (%dx),%al
c0100e6f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e72:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e78:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e7c:	89 c2                	mov    %eax,%edx
c0100e7e:	ec                   	in     (%dx),%al
c0100e7f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e82:	90                   	nop
c0100e83:	c9                   	leave  
c0100e84:	c3                   	ret    

c0100e85 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e85:	55                   	push   %ebp
c0100e86:	89 e5                	mov    %esp,%ebp
c0100e88:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e8b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	0f b7 00             	movzwl (%eax),%eax
c0100e98:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea7:	0f b7 00             	movzwl (%eax),%eax
c0100eaa:	0f b7 c0             	movzwl %ax,%eax
c0100ead:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100eb2:	74 12                	je     c0100ec6 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eb4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ebb:	66 c7 05 46 d4 11 c0 	movw   $0x3b4,0xc011d446
c0100ec2:	b4 03 
c0100ec4:	eb 13                	jmp    c0100ed9 <cga_init+0x54>
    } else {
        *cp = was;
c0100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ecd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ed0:	66 c7 05 46 d4 11 c0 	movw   $0x3d4,0xc011d446
c0100ed7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed9:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100ee0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ee4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100eec:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ef0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef1:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100ef8:	40                   	inc    %eax
c0100ef9:	0f b7 c0             	movzwl %ax,%eax
c0100efc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f00:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f04:	89 c2                	mov    %eax,%edx
c0100f06:	ec                   	in     (%dx),%al
c0100f07:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f0a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f0e:	0f b6 c0             	movzbl %al,%eax
c0100f11:	c1 e0 08             	shl    $0x8,%eax
c0100f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f17:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f1e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f22:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f2a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f36:	40                   	inc    %eax
c0100f37:	0f b7 c0             	movzwl %ax,%eax
c0100f3a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f42:	89 c2                	mov    %eax,%edx
c0100f44:	ec                   	in     (%dx),%al
c0100f45:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f48:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f4c:	0f b6 c0             	movzbl %al,%eax
c0100f4f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f55:	a3 40 d4 11 c0       	mov    %eax,0xc011d440
    crt_pos = pos;
c0100f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5d:	0f b7 c0             	movzwl %ax,%eax
c0100f60:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
}
c0100f66:	90                   	nop
c0100f67:	c9                   	leave  
c0100f68:	c3                   	ret    

c0100f69 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f69:	55                   	push   %ebp
c0100f6a:	89 e5                	mov    %esp,%ebp
c0100f6c:	83 ec 48             	sub    $0x48,%esp
c0100f6f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f75:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f79:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f7d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f81:	ee                   	out    %al,(%dx)
c0100f82:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f88:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f8c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f90:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
c0100f95:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f9b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f9f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fa3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fa7:	ee                   	out    %al,(%dx)
c0100fa8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fae:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100fb2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fb6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fba:	ee                   	out    %al,(%dx)
c0100fbb:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fc1:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fc5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fcd:	ee                   	out    %al,(%dx)
c0100fce:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fd4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fe0:	ee                   	out    %al,(%dx)
c0100fe1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fe7:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100feb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ff3:	ee                   	out    %al,(%dx)
c0100ff4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffa:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ffe:	89 c2                	mov    %eax,%edx
c0101000:	ec                   	in     (%dx),%al
c0101001:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101004:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101008:	3c ff                	cmp    $0xff,%al
c010100a:	0f 95 c0             	setne  %al
c010100d:	0f b6 c0             	movzbl %al,%eax
c0101010:	a3 48 d4 11 c0       	mov    %eax,0xc011d448
c0101015:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010101f:	89 c2                	mov    %eax,%edx
c0101021:	ec                   	in     (%dx),%al
c0101022:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101025:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010102b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010102f:	89 c2                	mov    %eax,%edx
c0101031:	ec                   	in     (%dx),%al
c0101032:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101035:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c010103a:	85 c0                	test   %eax,%eax
c010103c:	74 0c                	je     c010104a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101045:	e8 df 06 00 00       	call   c0101729 <pic_enable>
    }
}
c010104a:	90                   	nop
c010104b:	c9                   	leave  
c010104c:	c3                   	ret    

c010104d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104d:	55                   	push   %ebp
c010104e:	89 e5                	mov    %esp,%ebp
c0101050:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010105a:	eb 08                	jmp    c0101064 <lpt_putc_sub+0x17>
        delay();
c010105c:	e8 db fd ff ff       	call   c0100e3c <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101061:	ff 45 fc             	incl   -0x4(%ebp)
c0101064:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010106a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106e:	89 c2                	mov    %eax,%edx
c0101070:	ec                   	in     (%dx),%al
c0101071:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101074:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101078:	84 c0                	test   %al,%al
c010107a:	78 09                	js     c0101085 <lpt_putc_sub+0x38>
c010107c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101083:	7e d7                	jle    c010105c <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101085:	8b 45 08             	mov    0x8(%ebp),%eax
c0101088:	0f b6 c0             	movzbl %al,%eax
c010108b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101091:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101094:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101098:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109c:	ee                   	out    %al,(%dx)
c010109d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a3:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010ab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010af:	ee                   	out    %al,(%dx)
c01010b0:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010b6:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c01010ba:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010be:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010c2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c3:	90                   	nop
c01010c4:	c9                   	leave  
c01010c5:	c3                   	ret    

c01010c6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c6:	55                   	push   %ebp
c01010c7:	89 e5                	mov    %esp,%ebp
c01010c9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010cc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010d0:	74 0d                	je     c01010df <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d5:	89 04 24             	mov    %eax,(%esp)
c01010d8:	e8 70 ff ff ff       	call   c010104d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010dd:	eb 24                	jmp    c0101103 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010df:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e6:	e8 62 ff ff ff       	call   c010104d <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010f2:	e8 56 ff ff ff       	call   c010104d <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fe:	e8 4a ff ff ff       	call   c010104d <lpt_putc_sub>
}
c0101103:	90                   	nop
c0101104:	c9                   	leave  
c0101105:	c3                   	ret    

c0101106 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101106:	55                   	push   %ebp
c0101107:	89 e5                	mov    %esp,%ebp
c0101109:	53                   	push   %ebx
c010110a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101115:	85 c0                	test   %eax,%eax
c0101117:	75 07                	jne    c0101120 <cga_putc+0x1a>
        c |= 0x0700;
c0101119:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101120:	8b 45 08             	mov    0x8(%ebp),%eax
c0101123:	0f b6 c0             	movzbl %al,%eax
c0101126:	83 f8 0a             	cmp    $0xa,%eax
c0101129:	74 55                	je     c0101180 <cga_putc+0x7a>
c010112b:	83 f8 0d             	cmp    $0xd,%eax
c010112e:	74 63                	je     c0101193 <cga_putc+0x8d>
c0101130:	83 f8 08             	cmp    $0x8,%eax
c0101133:	0f 85 94 00 00 00    	jne    c01011cd <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101139:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101140:	85 c0                	test   %eax,%eax
c0101142:	0f 84 af 00 00 00    	je     c01011f7 <cga_putc+0xf1>
            crt_pos --;
c0101148:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010114f:	48                   	dec    %eax
c0101150:	0f b7 c0             	movzwl %ax,%eax
c0101153:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101159:	8b 45 08             	mov    0x8(%ebp),%eax
c010115c:	98                   	cwtl   
c010115d:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101162:	98                   	cwtl   
c0101163:	83 c8 20             	or     $0x20,%eax
c0101166:	98                   	cwtl   
c0101167:	8b 15 40 d4 11 c0    	mov    0xc011d440,%edx
c010116d:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c0101174:	01 c9                	add    %ecx,%ecx
c0101176:	01 ca                	add    %ecx,%edx
c0101178:	0f b7 c0             	movzwl %ax,%eax
c010117b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010117e:	eb 77                	jmp    c01011f7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c0101180:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101187:	83 c0 50             	add    $0x50,%eax
c010118a:	0f b7 c0             	movzwl %ax,%eax
c010118d:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101193:	0f b7 1d 44 d4 11 c0 	movzwl 0xc011d444,%ebx
c010119a:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c01011a1:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011a6:	89 c8                	mov    %ecx,%eax
c01011a8:	f7 e2                	mul    %edx
c01011aa:	c1 ea 06             	shr    $0x6,%edx
c01011ad:	89 d0                	mov    %edx,%eax
c01011af:	c1 e0 02             	shl    $0x2,%eax
c01011b2:	01 d0                	add    %edx,%eax
c01011b4:	c1 e0 04             	shl    $0x4,%eax
c01011b7:	29 c1                	sub    %eax,%ecx
c01011b9:	89 c8                	mov    %ecx,%eax
c01011bb:	0f b7 c0             	movzwl %ax,%eax
c01011be:	29 c3                	sub    %eax,%ebx
c01011c0:	89 d8                	mov    %ebx,%eax
c01011c2:	0f b7 c0             	movzwl %ax,%eax
c01011c5:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
        break;
c01011cb:	eb 2b                	jmp    c01011f8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cd:	8b 0d 40 d4 11 c0    	mov    0xc011d440,%ecx
c01011d3:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011da:	8d 50 01             	lea    0x1(%eax),%edx
c01011dd:	0f b7 d2             	movzwl %dx,%edx
c01011e0:	66 89 15 44 d4 11 c0 	mov    %dx,0xc011d444
c01011e7:	01 c0                	add    %eax,%eax
c01011e9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ef:	0f b7 c0             	movzwl %ax,%eax
c01011f2:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f5:	eb 01                	jmp    c01011f8 <cga_putc+0xf2>
        break;
c01011f7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f8:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011ff:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101204:	76 5d                	jbe    c0101263 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101206:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c010120b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101211:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c0101216:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010121d:	00 
c010121e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101222:	89 04 24             	mov    %eax,(%esp)
c0101225:	e8 3d 55 00 00       	call   c0106767 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101231:	eb 14                	jmp    c0101247 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c0101233:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c0101238:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010123b:	01 d2                	add    %edx,%edx
c010123d:	01 d0                	add    %edx,%eax
c010123f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101244:	ff 45 f4             	incl   -0xc(%ebp)
c0101247:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010124e:	7e e3                	jle    c0101233 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c0101250:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101257:	83 e8 50             	sub    $0x50,%eax
c010125a:	0f b7 c0             	movzwl %ax,%eax
c010125d:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101263:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c010126a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010126e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101272:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101276:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010127a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010127b:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101282:	c1 e8 08             	shr    $0x8,%eax
c0101285:	0f b7 c0             	movzwl %ax,%eax
c0101288:	0f b6 c0             	movzbl %al,%eax
c010128b:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c0101292:	42                   	inc    %edx
c0101293:	0f b7 d2             	movzwl %dx,%edx
c0101296:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010129a:	88 45 e9             	mov    %al,-0x17(%ebp)
c010129d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a6:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c01012ad:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012b1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012b5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012b9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012be:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01012c5:	0f b6 c0             	movzbl %al,%eax
c01012c8:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c01012cf:	42                   	inc    %edx
c01012d0:	0f b7 d2             	movzwl %dx,%edx
c01012d3:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012d7:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012da:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e2:	ee                   	out    %al,(%dx)
}
c01012e3:	90                   	nop
c01012e4:	83 c4 34             	add    $0x34,%esp
c01012e7:	5b                   	pop    %ebx
c01012e8:	5d                   	pop    %ebp
c01012e9:	c3                   	ret    

c01012ea <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ea:	55                   	push   %ebp
c01012eb:	89 e5                	mov    %esp,%ebp
c01012ed:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f7:	eb 08                	jmp    c0101301 <serial_putc_sub+0x17>
        delay();
c01012f9:	e8 3e fb ff ff       	call   c0100e3c <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012fe:	ff 45 fc             	incl   -0x4(%ebp)
c0101301:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101307:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010130b:	89 c2                	mov    %eax,%edx
c010130d:	ec                   	in     (%dx),%al
c010130e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101311:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101315:	0f b6 c0             	movzbl %al,%eax
c0101318:	83 e0 20             	and    $0x20,%eax
c010131b:	85 c0                	test   %eax,%eax
c010131d:	75 09                	jne    c0101328 <serial_putc_sub+0x3e>
c010131f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101326:	7e d1                	jle    c01012f9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101328:	8b 45 08             	mov    0x8(%ebp),%eax
c010132b:	0f b6 c0             	movzbl %al,%eax
c010132e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101334:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101337:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010133f:	ee                   	out    %al,(%dx)
}
c0101340:	90                   	nop
c0101341:	c9                   	leave  
c0101342:	c3                   	ret    

c0101343 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101343:	55                   	push   %ebp
c0101344:	89 e5                	mov    %esp,%ebp
c0101346:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101349:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134d:	74 0d                	je     c010135c <serial_putc+0x19>
        serial_putc_sub(c);
c010134f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101352:	89 04 24             	mov    %eax,(%esp)
c0101355:	e8 90 ff ff ff       	call   c01012ea <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c010135a:	eb 24                	jmp    c0101380 <serial_putc+0x3d>
        serial_putc_sub('\b');
c010135c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101363:	e8 82 ff ff ff       	call   c01012ea <serial_putc_sub>
        serial_putc_sub(' ');
c0101368:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010136f:	e8 76 ff ff ff       	call   c01012ea <serial_putc_sub>
        serial_putc_sub('\b');
c0101374:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010137b:	e8 6a ff ff ff       	call   c01012ea <serial_putc_sub>
}
c0101380:	90                   	nop
c0101381:	c9                   	leave  
c0101382:	c3                   	ret    

c0101383 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101383:	55                   	push   %ebp
c0101384:	89 e5                	mov    %esp,%ebp
c0101386:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101389:	eb 33                	jmp    c01013be <cons_intr+0x3b>
        if (c != 0) {
c010138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138f:	74 2d                	je     c01013be <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101391:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101396:	8d 50 01             	lea    0x1(%eax),%edx
c0101399:	89 15 64 d6 11 c0    	mov    %edx,0xc011d664
c010139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a2:	88 90 60 d4 11 c0    	mov    %dl,-0x3fee2ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a8:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c01013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b2:	75 0a                	jne    c01013be <cons_intr+0x3b>
                cons.wpos = 0;
c01013b4:	c7 05 64 d6 11 c0 00 	movl   $0x0,0xc011d664
c01013bb:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013be:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c1:	ff d0                	call   *%eax
c01013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ca:	75 bf                	jne    c010138b <cons_intr+0x8>
            }
        }
    }
}
c01013cc:	90                   	nop
c01013cd:	c9                   	leave  
c01013ce:	c3                   	ret    

c01013cf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013cf:	55                   	push   %ebp
c01013d0:	89 e5                	mov    %esp,%ebp
c01013d2:	83 ec 10             	sub    $0x10,%esp
c01013d5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013db:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013df:	89 c2                	mov    %eax,%edx
c01013e1:	ec                   	in     (%dx),%al
c01013e2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e9:	0f b6 c0             	movzbl %al,%eax
c01013ec:	83 e0 01             	and    $0x1,%eax
c01013ef:	85 c0                	test   %eax,%eax
c01013f1:	75 07                	jne    c01013fa <serial_proc_data+0x2b>
        return -1;
c01013f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f8:	eb 2a                	jmp    c0101424 <serial_proc_data+0x55>
c01013fa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101400:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101404:	89 c2                	mov    %eax,%edx
c0101406:	ec                   	in     (%dx),%al
c0101407:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010140a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010140e:	0f b6 c0             	movzbl %al,%eax
c0101411:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101414:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101418:	75 07                	jne    c0101421 <serial_proc_data+0x52>
        c = '\b';
c010141a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101421:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101424:	c9                   	leave  
c0101425:	c3                   	ret    

c0101426 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101426:	55                   	push   %ebp
c0101427:	89 e5                	mov    %esp,%ebp
c0101429:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010142c:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c0101431:	85 c0                	test   %eax,%eax
c0101433:	74 0c                	je     c0101441 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101435:	c7 04 24 cf 13 10 c0 	movl   $0xc01013cf,(%esp)
c010143c:	e8 42 ff ff ff       	call   c0101383 <cons_intr>
    }
}
c0101441:	90                   	nop
c0101442:	c9                   	leave  
c0101443:	c3                   	ret    

c0101444 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101444:	55                   	push   %ebp
c0101445:	89 e5                	mov    %esp,%ebp
c0101447:	83 ec 38             	sub    $0x38,%esp
c010144a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101453:	89 c2                	mov    %eax,%edx
c0101455:	ec                   	in     (%dx),%al
c0101456:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101459:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010145d:	0f b6 c0             	movzbl %al,%eax
c0101460:	83 e0 01             	and    $0x1,%eax
c0101463:	85 c0                	test   %eax,%eax
c0101465:	75 0a                	jne    c0101471 <kbd_proc_data+0x2d>
        return -1;
c0101467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010146c:	e9 55 01 00 00       	jmp    c01015c6 <kbd_proc_data+0x182>
c0101471:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101477:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010147a:	89 c2                	mov    %eax,%edx
c010147c:	ec                   	in     (%dx),%al
c010147d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101480:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101484:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101487:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010148b:	75 17                	jne    c01014a4 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c010148d:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101492:	83 c8 40             	or     $0x40,%eax
c0101495:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c010149a:	b8 00 00 00 00       	mov    $0x0,%eax
c010149f:	e9 22 01 00 00       	jmp    c01015c6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	84 c0                	test   %al,%al
c01014aa:	79 45                	jns    c01014f1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014ac:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014b1:	83 e0 40             	and    $0x40,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	75 08                	jne    c01014c0 <kbd_proc_data+0x7c>
c01014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bc:	24 7f                	and    $0x7f,%al
c01014be:	eb 04                	jmp    c01014c4 <kbd_proc_data+0x80>
c01014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cb:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c01014d2:	0c 40                	or     $0x40,%al
c01014d4:	0f b6 c0             	movzbl %al,%eax
c01014d7:	f7 d0                	not    %eax
c01014d9:	89 c2                	mov    %eax,%edx
c01014db:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014e0:	21 d0                	and    %edx,%eax
c01014e2:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c01014e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ec:	e9 d5 00 00 00       	jmp    c01015c6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014f1:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014f6:	83 e0 40             	and    $0x40,%eax
c01014f9:	85 c0                	test   %eax,%eax
c01014fb:	74 11                	je     c010150e <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101501:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101506:	83 e0 bf             	and    $0xffffffbf,%eax
c0101509:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    }

    shift |= shiftcode[data];
c010150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101512:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c0101519:	0f b6 d0             	movzbl %al,%edx
c010151c:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101521:	09 d0                	or     %edx,%eax
c0101523:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    shift ^= togglecode[data];
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	0f b6 80 40 a1 11 c0 	movzbl -0x3fee5ec0(%eax),%eax
c0101533:	0f b6 d0             	movzbl %al,%edx
c0101536:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c010153b:	31 d0                	xor    %edx,%eax
c010153d:	a3 68 d6 11 c0       	mov    %eax,0xc011d668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101542:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101547:	83 e0 03             	and    $0x3,%eax
c010154a:	8b 14 85 40 a5 11 c0 	mov    -0x3fee5ac0(,%eax,4),%edx
c0101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101555:	01 d0                	add    %edx,%eax
c0101557:	0f b6 00             	movzbl (%eax),%eax
c010155a:	0f b6 c0             	movzbl %al,%eax
c010155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101560:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101565:	83 e0 08             	and    $0x8,%eax
c0101568:	85 c0                	test   %eax,%eax
c010156a:	74 22                	je     c010158e <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c010156c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101570:	7e 0c                	jle    c010157e <kbd_proc_data+0x13a>
c0101572:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101576:	7f 06                	jg     c010157e <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101578:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157c:	eb 10                	jmp    c010158e <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c010157e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101582:	7e 0a                	jle    c010158e <kbd_proc_data+0x14a>
c0101584:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101588:	7f 04                	jg     c010158e <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c010158a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010158e:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101593:	f7 d0                	not    %eax
c0101595:	83 e0 06             	and    $0x6,%eax
c0101598:	85 c0                	test   %eax,%eax
c010159a:	75 27                	jne    c01015c3 <kbd_proc_data+0x17f>
c010159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a3:	75 1e                	jne    c01015c3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c01015a5:	c7 04 24 6d 72 10 c0 	movl   $0xc010726d,(%esp)
c01015ac:	e8 f1 ec ff ff       	call   c01002a2 <cprintf>
c01015b1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01015c2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c6:	c9                   	leave  
c01015c7:	c3                   	ret    

c01015c8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015c8:	55                   	push   %ebp
c01015c9:	89 e5                	mov    %esp,%ebp
c01015cb:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ce:	c7 04 24 44 14 10 c0 	movl   $0xc0101444,(%esp)
c01015d5:	e8 a9 fd ff ff       	call   c0101383 <cons_intr>
}
c01015da:	90                   	nop
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <kbd_init>:

static void
kbd_init(void) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e3:	e8 e0 ff ff ff       	call   c01015c8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ef:	e8 35 01 00 00       	call   c0101729 <pic_enable>
}
c01015f4:	90                   	nop
c01015f5:	c9                   	leave  
c01015f6:	c3                   	ret    

c01015f7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f7:	55                   	push   %ebp
c01015f8:	89 e5                	mov    %esp,%ebp
c01015fa:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fd:	e8 83 f8 ff ff       	call   c0100e85 <cga_init>
    serial_init();
c0101602:	e8 62 f9 ff ff       	call   c0100f69 <serial_init>
    kbd_init();
c0101607:	e8 d1 ff ff ff       	call   c01015dd <kbd_init>
    if (!serial_exists) {
c010160c:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	75 0c                	jne    c0101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101615:	c7 04 24 79 72 10 c0 	movl   $0xc0107279,(%esp)
c010161c:	e8 81 ec ff ff       	call   c01002a2 <cprintf>
    }
}
c0101621:	90                   	nop
c0101622:	c9                   	leave  
c0101623:	c3                   	ret    

c0101624 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101624:	55                   	push   %ebp
c0101625:	89 e5                	mov    %esp,%ebp
c0101627:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010162a:	e8 cf f7 ff ff       	call   c0100dfe <__intr_save>
c010162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 89 fa ff ff       	call   c01010c6 <lpt_putc>
        cga_putc(c);
c010163d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 be fa ff ff       	call   c0101106 <cga_putc>
        serial_putc(c);
c0101648:	8b 45 08             	mov    0x8(%ebp),%eax
c010164b:	89 04 24             	mov    %eax,(%esp)
c010164e:	e8 f0 fc ff ff       	call   c0101343 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101656:	89 04 24             	mov    %eax,(%esp)
c0101659:	e8 ca f7 ff ff       	call   c0100e28 <__intr_restore>
}
c010165e:	90                   	nop
c010165f:	c9                   	leave  
c0101660:	c3                   	ret    

c0101661 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101661:	55                   	push   %ebp
c0101662:	89 e5                	mov    %esp,%ebp
c0101664:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101667:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010166e:	e8 8b f7 ff ff       	call   c0100dfe <__intr_save>
c0101673:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101676:	e8 ab fd ff ff       	call   c0101426 <serial_intr>
        kbd_intr();
c010167b:	e8 48 ff ff ff       	call   c01015c8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101680:	8b 15 60 d6 11 c0    	mov    0xc011d660,%edx
c0101686:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c010168b:	39 c2                	cmp    %eax,%edx
c010168d:	74 31                	je     c01016c0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168f:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c0101694:	8d 50 01             	lea    0x1(%eax),%edx
c0101697:	89 15 60 d6 11 c0    	mov    %edx,0xc011d660
c010169d:	0f b6 80 60 d4 11 c0 	movzbl -0x3fee2ba0(%eax),%eax
c01016a4:	0f b6 c0             	movzbl %al,%eax
c01016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016aa:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c01016af:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b4:	75 0a                	jne    c01016c0 <cons_getc+0x5f>
                cons.rpos = 0;
c01016b6:	c7 05 60 d6 11 c0 00 	movl   $0x0,0xc011d660
c01016bd:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c3:	89 04 24             	mov    %eax,(%esp)
c01016c6:	e8 5d f7 ff ff       	call   c0100e28 <__intr_restore>
    return c;
c01016cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ce:	c9                   	leave  
c01016cf:	c3                   	ret    

c01016d0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016d0:	55                   	push   %ebp
c01016d1:	89 e5                	mov    %esp,%ebp
c01016d3:	83 ec 14             	sub    $0x14,%esp
c01016d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016e0:	66 a3 50 a5 11 c0    	mov    %ax,0xc011a550
    if (did_init) {
c01016e6:	a1 6c d6 11 c0       	mov    0xc011d66c,%eax
c01016eb:	85 c0                	test   %eax,%eax
c01016ed:	74 37                	je     c0101726 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016f2:	0f b6 c0             	movzbl %al,%eax
c01016f5:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016fb:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101702:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101706:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101707:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010170b:	c1 e8 08             	shr    $0x8,%eax
c010170e:	0f b7 c0             	movzwl %ax,%eax
c0101711:	0f b6 c0             	movzbl %al,%eax
c0101714:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c010171a:	88 45 fd             	mov    %al,-0x3(%ebp)
c010171d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101721:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101725:	ee                   	out    %al,(%dx)
    }
}
c0101726:	90                   	nop
c0101727:	c9                   	leave  
c0101728:	c3                   	ret    

c0101729 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101729:	55                   	push   %ebp
c010172a:	89 e5                	mov    %esp,%ebp
c010172c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010172f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101732:	ba 01 00 00 00       	mov    $0x1,%edx
c0101737:	88 c1                	mov    %al,%cl
c0101739:	d3 e2                	shl    %cl,%edx
c010173b:	89 d0                	mov    %edx,%eax
c010173d:	98                   	cwtl   
c010173e:	f7 d0                	not    %eax
c0101740:	0f bf d0             	movswl %ax,%edx
c0101743:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010174a:	98                   	cwtl   
c010174b:	21 d0                	and    %edx,%eax
c010174d:	98                   	cwtl   
c010174e:	0f b7 c0             	movzwl %ax,%eax
c0101751:	89 04 24             	mov    %eax,(%esp)
c0101754:	e8 77 ff ff ff       	call   c01016d0 <pic_setmask>
}
c0101759:	90                   	nop
c010175a:	c9                   	leave  
c010175b:	c3                   	ret    

c010175c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010175c:	55                   	push   %ebp
c010175d:	89 e5                	mov    %esp,%ebp
c010175f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101762:	c7 05 6c d6 11 c0 01 	movl   $0x1,0xc011d66c
c0101769:	00 00 00 
c010176c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101772:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101776:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010177a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010177e:	ee                   	out    %al,(%dx)
c010177f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101785:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101789:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010178d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101791:	ee                   	out    %al,(%dx)
c0101792:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101798:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c010179c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017a0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017a4:	ee                   	out    %al,(%dx)
c01017a5:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01017ab:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c01017af:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017b3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017b7:	ee                   	out    %al,(%dx)
c01017b8:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017be:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017c2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017c6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017ca:	ee                   	out    %al,(%dx)
c01017cb:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017d1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017d5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017dd:	ee                   	out    %al,(%dx)
c01017de:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017e4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017e8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017ec:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f0:	ee                   	out    %al,(%dx)
c01017f1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017f7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017fb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ff:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101803:	ee                   	out    %al,(%dx)
c0101804:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c010180a:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c010180e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101812:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101816:	ee                   	out    %al,(%dx)
c0101817:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010181d:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101821:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101825:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101829:	ee                   	out    %al,(%dx)
c010182a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101830:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101834:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101838:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010183c:	ee                   	out    %al,(%dx)
c010183d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101843:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101847:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010184b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010184f:	ee                   	out    %al,(%dx)
c0101850:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101856:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c010185a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010185e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101862:	ee                   	out    %al,(%dx)
c0101863:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101869:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c010186d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101871:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101875:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101876:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010187d:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101882:	74 0f                	je     c0101893 <pic_init+0x137>
        pic_setmask(irq_mask);
c0101884:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010188b:	89 04 24             	mov    %eax,(%esp)
c010188e:	e8 3d fe ff ff       	call   c01016d0 <pic_setmask>
    }
}
c0101893:	90                   	nop
c0101894:	c9                   	leave  
c0101895:	c3                   	ret    

c0101896 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101896:	55                   	push   %ebp
c0101897:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101899:	fb                   	sti    
    sti();
}
c010189a:	90                   	nop
c010189b:	5d                   	pop    %ebp
c010189c:	c3                   	ret    

c010189d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010189d:	55                   	push   %ebp
c010189e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01018a0:	fa                   	cli    
    cli();
}
c01018a1:	90                   	nop
c01018a2:	5d                   	pop    %ebp
c01018a3:	c3                   	ret    

c01018a4 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018a4:	55                   	push   %ebp
c01018a5:	89 e5                	mov    %esp,%ebp
c01018a7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018aa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018b1:	00 
c01018b2:	c7 04 24 a0 72 10 c0 	movl   $0xc01072a0,(%esp)
c01018b9:	e8 e4 e9 ff ff       	call   c01002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018be:	c7 04 24 aa 72 10 c0 	movl   $0xc01072aa,(%esp)
c01018c5:	e8 d8 e9 ff ff       	call   c01002a2 <cprintf>
    panic("EOT: kernel seems ok.");
c01018ca:	c7 44 24 08 b8 72 10 	movl   $0xc01072b8,0x8(%esp)
c01018d1:	c0 
c01018d2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018d9:	00 
c01018da:	c7 04 24 ce 72 10 c0 	movl   $0xc01072ce,(%esp)
c01018e1:	e8 13 eb ff ff       	call   c01003f9 <__panic>

c01018e6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018e6:	55                   	push   %ebp
c01018e7:	89 e5                	mov    %esp,%ebp
c01018e9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018f3:	e9 c4 00 00 00       	jmp    c01019bc <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c0101902:	0f b7 d0             	movzwl %ax,%edx
c0101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101908:	66 89 14 c5 80 d6 11 	mov    %dx,-0x3fee2980(,%eax,8)
c010190f:	c0 
c0101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101913:	66 c7 04 c5 82 d6 11 	movw   $0x8,-0x3fee297e(,%eax,8)
c010191a:	c0 08 00 
c010191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101920:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c0101927:	c0 
c0101928:	80 e2 e0             	and    $0xe0,%dl
c010192b:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101932:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101935:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c010193c:	c0 
c010193d:	80 e2 1f             	and    $0x1f,%dl
c0101940:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194a:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101951:	c0 
c0101952:	80 e2 f0             	and    $0xf0,%dl
c0101955:	80 ca 0e             	or     $0xe,%dl
c0101958:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c010195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101962:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101969:	c0 
c010196a:	80 e2 ef             	and    $0xef,%dl
c010196d:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101977:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c010197e:	c0 
c010197f:	80 e2 9f             	and    $0x9f,%dl
c0101982:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198c:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101993:	c0 
c0101994:	80 ca 80             	or     $0x80,%dl
c0101997:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c010199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a1:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c01019a8:	c1 e8 10             	shr    $0x10,%eax
c01019ab:	0f b7 d0             	movzwl %ax,%edx
c01019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b1:	66 89 14 c5 86 d6 11 	mov    %dx,-0x3fee297a(,%eax,8)
c01019b8:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019b9:	ff 45 fc             	incl   -0x4(%ebp)
c01019bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bf:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019c4:	0f 86 2e ff ff ff    	jbe    c01018f8 <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019ca:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c01019cf:	0f b7 c0             	movzwl %ax,%eax
c01019d2:	66 a3 48 da 11 c0    	mov    %ax,0xc011da48
c01019d8:	66 c7 05 4a da 11 c0 	movw   $0x8,0xc011da4a
c01019df:	08 00 
c01019e1:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c01019e8:	24 e0                	and    $0xe0,%al
c01019ea:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c01019ef:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c01019f6:	24 1f                	and    $0x1f,%al
c01019f8:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c01019fd:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a04:	24 f0                	and    $0xf0,%al
c0101a06:	0c 0e                	or     $0xe,%al
c0101a08:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a0d:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a14:	24 ef                	and    $0xef,%al
c0101a16:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a1b:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a22:	0c 60                	or     $0x60,%al
c0101a24:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a29:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a30:	0c 80                	or     $0x80,%al
c0101a32:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a37:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101a3c:	c1 e8 10             	shr    $0x10,%eax
c0101a3f:	0f b7 c0             	movzwl %ax,%eax
c0101a42:	66 a3 4e da 11 c0    	mov    %ax,0xc011da4e
c0101a48:	c7 45 f8 60 a5 11 c0 	movl   $0xc011a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a52:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c0101a55:	90                   	nop
c0101a56:	c9                   	leave  
c0101a57:	c3                   	ret    

c0101a58 <trapname>:

static const char *
trapname(int trapno) {
c0101a58:	55                   	push   %ebp
c0101a59:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5e:	83 f8 13             	cmp    $0x13,%eax
c0101a61:	77 0c                	ja     c0101a6f <trapname+0x17>
        return excnames[trapno];
c0101a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a66:	8b 04 85 20 76 10 c0 	mov    -0x3fef89e0(,%eax,4),%eax
c0101a6d:	eb 18                	jmp    c0101a87 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a6f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a73:	7e 0d                	jle    c0101a82 <trapname+0x2a>
c0101a75:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a79:	7f 07                	jg     c0101a82 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a7b:	b8 df 72 10 c0       	mov    $0xc01072df,%eax
c0101a80:	eb 05                	jmp    c0101a87 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a82:	b8 f2 72 10 c0       	mov    $0xc01072f2,%eax
}
c0101a87:	5d                   	pop    %ebp
c0101a88:	c3                   	ret    

c0101a89 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a89:	55                   	push   %ebp
c0101a8a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a93:	83 f8 08             	cmp    $0x8,%eax
c0101a96:	0f 94 c0             	sete   %al
c0101a99:	0f b6 c0             	movzbl %al,%eax
}
c0101a9c:	5d                   	pop    %ebp
c0101a9d:	c3                   	ret    

c0101a9e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a9e:	55                   	push   %ebp
c0101a9f:	89 e5                	mov    %esp,%ebp
c0101aa1:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aab:	c7 04 24 33 73 10 c0 	movl   $0xc0107333,(%esp)
c0101ab2:	e8 eb e7 ff ff       	call   c01002a2 <cprintf>
    print_regs(&tf->tf_regs);
c0101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aba:	89 04 24             	mov    %eax,(%esp)
c0101abd:	e8 8f 01 00 00       	call   c0101c51 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101acd:	c7 04 24 44 73 10 c0 	movl   $0xc0107344,(%esp)
c0101ad4:	e8 c9 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adc:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae4:	c7 04 24 57 73 10 c0 	movl   $0xc0107357,(%esp)
c0101aeb:	e8 b2 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101afb:	c7 04 24 6a 73 10 c0 	movl   $0xc010736a,(%esp)
c0101b02:	e8 9b e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b12:	c7 04 24 7d 73 10 c0 	movl   $0xc010737d,(%esp)
c0101b19:	e8 84 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b21:	8b 40 30             	mov    0x30(%eax),%eax
c0101b24:	89 04 24             	mov    %eax,(%esp)
c0101b27:	e8 2c ff ff ff       	call   c0101a58 <trapname>
c0101b2c:	89 c2                	mov    %eax,%edx
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	8b 40 30             	mov    0x30(%eax),%eax
c0101b34:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3c:	c7 04 24 90 73 10 c0 	movl   $0xc0107390,(%esp)
c0101b43:	e8 5a e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	8b 40 34             	mov    0x34(%eax),%eax
c0101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b52:	c7 04 24 a2 73 10 c0 	movl   $0xc01073a2,(%esp)
c0101b59:	e8 44 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b61:	8b 40 38             	mov    0x38(%eax),%eax
c0101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b68:	c7 04 24 b1 73 10 c0 	movl   $0xc01073b1,(%esp)
c0101b6f:	e8 2e e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7f:	c7 04 24 c0 73 10 c0 	movl   $0xc01073c0,(%esp)
c0101b86:	e8 17 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b95:	c7 04 24 d3 73 10 c0 	movl   $0xc01073d3,(%esp)
c0101b9c:	e8 01 e7 ff ff       	call   c01002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ba8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101baf:	eb 3d                	jmp    c0101bee <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb4:	8b 50 40             	mov    0x40(%eax),%edx
c0101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bba:	21 d0                	and    %edx,%eax
c0101bbc:	85 c0                	test   %eax,%eax
c0101bbe:	74 28                	je     c0101be8 <print_trapframe+0x14a>
c0101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc3:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101bca:	85 c0                	test   %eax,%eax
c0101bcc:	74 1a                	je     c0101be8 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd1:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 e2 73 10 c0 	movl   $0xc01073e2,(%esp)
c0101be3:	e8 ba e6 ff ff       	call   c01002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101be8:	ff 45 f4             	incl   -0xc(%ebp)
c0101beb:	d1 65 f0             	shll   -0x10(%ebp)
c0101bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf1:	83 f8 17             	cmp    $0x17,%eax
c0101bf4:	76 bb                	jbe    c0101bb1 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf9:	8b 40 40             	mov    0x40(%eax),%eax
c0101bfc:	c1 e8 0c             	shr    $0xc,%eax
c0101bff:	83 e0 03             	and    $0x3,%eax
c0101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c06:	c7 04 24 e6 73 10 c0 	movl   $0xc01073e6,(%esp)
c0101c0d:	e8 90 e6 ff ff       	call   c01002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	89 04 24             	mov    %eax,(%esp)
c0101c18:	e8 6c fe ff ff       	call   c0101a89 <trap_in_kernel>
c0101c1d:	85 c0                	test   %eax,%eax
c0101c1f:	75 2d                	jne    c0101c4e <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c24:	8b 40 44             	mov    0x44(%eax),%eax
c0101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2b:	c7 04 24 ef 73 10 c0 	movl   $0xc01073ef,(%esp)
c0101c32:	e8 6b e6 ff ff       	call   c01002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c42:	c7 04 24 fe 73 10 c0 	movl   $0xc01073fe,(%esp)
c0101c49:	e8 54 e6 ff ff       	call   c01002a2 <cprintf>
    }
}
c0101c4e:	90                   	nop
c0101c4f:	c9                   	leave  
c0101c50:	c3                   	ret    

c0101c51 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c51:	55                   	push   %ebp
c0101c52:	89 e5                	mov    %esp,%ebp
c0101c54:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5a:	8b 00                	mov    (%eax),%eax
c0101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c60:	c7 04 24 11 74 10 c0 	movl   $0xc0107411,(%esp)
c0101c67:	e8 36 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6f:	8b 40 04             	mov    0x4(%eax),%eax
c0101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c76:	c7 04 24 20 74 10 c0 	movl   $0xc0107420,(%esp)
c0101c7d:	e8 20 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c85:	8b 40 08             	mov    0x8(%eax),%eax
c0101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8c:	c7 04 24 2f 74 10 c0 	movl   $0xc010742f,(%esp)
c0101c93:	e8 0a e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9b:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca2:	c7 04 24 3e 74 10 c0 	movl   $0xc010743e,(%esp)
c0101ca9:	e8 f4 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb1:	8b 40 10             	mov    0x10(%eax),%eax
c0101cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb8:	c7 04 24 4d 74 10 c0 	movl   $0xc010744d,(%esp)
c0101cbf:	e8 de e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc7:	8b 40 14             	mov    0x14(%eax),%eax
c0101cca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cce:	c7 04 24 5c 74 10 c0 	movl   $0xc010745c,(%esp)
c0101cd5:	e8 c8 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdd:	8b 40 18             	mov    0x18(%eax),%eax
c0101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce4:	c7 04 24 6b 74 10 c0 	movl   $0xc010746b,(%esp)
c0101ceb:	e8 b2 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf3:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfa:	c7 04 24 7a 74 10 c0 	movl   $0xc010747a,(%esp)
c0101d01:	e8 9c e5 ff ff       	call   c01002a2 <cprintf>
}
c0101d06:	90                   	nop
c0101d07:	c9                   	leave  
c0101d08:	c3                   	ret    

c0101d09 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d09:	55                   	push   %ebp
c0101d0a:	89 e5                	mov    %esp,%ebp
c0101d0c:	57                   	push   %edi
c0101d0d:	56                   	push   %esi
c0101d0e:	53                   	push   %ebx
c0101d0f:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d15:	8b 40 30             	mov    0x30(%eax),%eax
c0101d18:	83 f8 2f             	cmp    $0x2f,%eax
c0101d1b:	77 21                	ja     c0101d3e <trap_dispatch+0x35>
c0101d1d:	83 f8 2e             	cmp    $0x2e,%eax
c0101d20:	0f 83 5d 02 00 00    	jae    c0101f83 <trap_dispatch+0x27a>
c0101d26:	83 f8 21             	cmp    $0x21,%eax
c0101d29:	0f 84 95 00 00 00    	je     c0101dc4 <trap_dispatch+0xbb>
c0101d2f:	83 f8 24             	cmp    $0x24,%eax
c0101d32:	74 67                	je     c0101d9b <trap_dispatch+0x92>
c0101d34:	83 f8 20             	cmp    $0x20,%eax
c0101d37:	74 1c                	je     c0101d55 <trap_dispatch+0x4c>
c0101d39:	e9 10 02 00 00       	jmp    c0101f4e <trap_dispatch+0x245>
c0101d3e:	83 f8 78             	cmp    $0x78,%eax
c0101d41:	0f 84 a6 00 00 00    	je     c0101ded <trap_dispatch+0xe4>
c0101d47:	83 f8 79             	cmp    $0x79,%eax
c0101d4a:	0f 84 81 01 00 00    	je     c0101ed1 <trap_dispatch+0x1c8>
c0101d50:	e9 f9 01 00 00       	jmp    c0101f4e <trap_dispatch+0x245>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d55:	a1 0c df 11 c0       	mov    0xc011df0c,%eax
c0101d5a:	40                   	inc    %eax
c0101d5b:	a3 0c df 11 c0       	mov    %eax,0xc011df0c
        if (ticks % TICK_NUM == 0) {
c0101d60:	8b 0d 0c df 11 c0    	mov    0xc011df0c,%ecx
c0101d66:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d6b:	89 c8                	mov    %ecx,%eax
c0101d6d:	f7 e2                	mul    %edx
c0101d6f:	c1 ea 05             	shr    $0x5,%edx
c0101d72:	89 d0                	mov    %edx,%eax
c0101d74:	c1 e0 02             	shl    $0x2,%eax
c0101d77:	01 d0                	add    %edx,%eax
c0101d79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d80:	01 d0                	add    %edx,%eax
c0101d82:	c1 e0 02             	shl    $0x2,%eax
c0101d85:	29 c1                	sub    %eax,%ecx
c0101d87:	89 ca                	mov    %ecx,%edx
c0101d89:	85 d2                	test   %edx,%edx
c0101d8b:	0f 85 f5 01 00 00    	jne    c0101f86 <trap_dispatch+0x27d>
            print_ticks();
c0101d91:	e8 0e fb ff ff       	call   c01018a4 <print_ticks>
        }
        break;
c0101d96:	e9 eb 01 00 00       	jmp    c0101f86 <trap_dispatch+0x27d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d9b:	e8 c1 f8 ff ff       	call   c0101661 <cons_getc>
c0101da0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101da3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101da7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dab:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101daf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db3:	c7 04 24 89 74 10 c0 	movl   $0xc0107489,(%esp)
c0101dba:	e8 e3 e4 ff ff       	call   c01002a2 <cprintf>
        break;
c0101dbf:	e9 c9 01 00 00       	jmp    c0101f8d <trap_dispatch+0x284>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dc4:	e8 98 f8 ff ff       	call   c0101661 <cons_getc>
c0101dc9:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dcc:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101dd0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dd4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ddc:	c7 04 24 9b 74 10 c0 	movl   $0xc010749b,(%esp)
c0101de3:	e8 ba e4 ff ff       	call   c01002a2 <cprintf>
        break;
c0101de8:	e9 a0 01 00 00       	jmp    c0101f8d <trap_dispatch+0x284>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101df4:	83 f8 1b             	cmp    $0x1b,%eax
c0101df7:	0f 84 8c 01 00 00    	je     c0101f89 <trap_dispatch+0x280>
            switchk2u = *tf;
c0101dfd:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e00:	b8 20 df 11 c0       	mov    $0xc011df20,%eax
c0101e05:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101e0a:	89 c1                	mov    %eax,%ecx
c0101e0c:	83 e1 01             	and    $0x1,%ecx
c0101e0f:	85 c9                	test   %ecx,%ecx
c0101e11:	74 0c                	je     c0101e1f <trap_dispatch+0x116>
c0101e13:	0f b6 0a             	movzbl (%edx),%ecx
c0101e16:	88 08                	mov    %cl,(%eax)
c0101e18:	8d 40 01             	lea    0x1(%eax),%eax
c0101e1b:	8d 52 01             	lea    0x1(%edx),%edx
c0101e1e:	4b                   	dec    %ebx
c0101e1f:	89 c1                	mov    %eax,%ecx
c0101e21:	83 e1 02             	and    $0x2,%ecx
c0101e24:	85 c9                	test   %ecx,%ecx
c0101e26:	74 0f                	je     c0101e37 <trap_dispatch+0x12e>
c0101e28:	0f b7 0a             	movzwl (%edx),%ecx
c0101e2b:	66 89 08             	mov    %cx,(%eax)
c0101e2e:	8d 40 02             	lea    0x2(%eax),%eax
c0101e31:	8d 52 02             	lea    0x2(%edx),%edx
c0101e34:	83 eb 02             	sub    $0x2,%ebx
c0101e37:	89 df                	mov    %ebx,%edi
c0101e39:	83 e7 fc             	and    $0xfffffffc,%edi
c0101e3c:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101e41:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101e44:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101e47:	83 c1 04             	add    $0x4,%ecx
c0101e4a:	39 f9                	cmp    %edi,%ecx
c0101e4c:	72 f3                	jb     c0101e41 <trap_dispatch+0x138>
c0101e4e:	01 c8                	add    %ecx,%eax
c0101e50:	01 ca                	add    %ecx,%edx
c0101e52:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101e57:	89 de                	mov    %ebx,%esi
c0101e59:	83 e6 02             	and    $0x2,%esi
c0101e5c:	85 f6                	test   %esi,%esi
c0101e5e:	74 0b                	je     c0101e6b <trap_dispatch+0x162>
c0101e60:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101e64:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101e68:	83 c1 02             	add    $0x2,%ecx
c0101e6b:	83 e3 01             	and    $0x1,%ebx
c0101e6e:	85 db                	test   %ebx,%ebx
c0101e70:	74 07                	je     c0101e79 <trap_dispatch+0x170>
c0101e72:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101e76:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101e79:	66 c7 05 5c df 11 c0 	movw   $0x1b,0xc011df5c
c0101e80:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101e82:	66 c7 05 68 df 11 c0 	movw   $0x23,0xc011df68
c0101e89:	23 00 
c0101e8b:	0f b7 05 68 df 11 c0 	movzwl 0xc011df68,%eax
c0101e92:	66 a3 48 df 11 c0    	mov    %ax,0xc011df48
c0101e98:	0f b7 05 48 df 11 c0 	movzwl 0xc011df48,%eax
c0101e9f:	66 a3 4c df 11 c0    	mov    %ax,0xc011df4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea8:	83 c0 44             	add    $0x44,%eax
c0101eab:	a3 64 df 11 c0       	mov    %eax,0xc011df64
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101eb0:	a1 60 df 11 c0       	mov    0xc011df60,%eax
c0101eb5:	0d 00 30 00 00       	or     $0x3000,%eax
c0101eba:	a3 60 df 11 c0       	mov    %eax,0xc011df60
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec2:	83 e8 04             	sub    $0x4,%eax
c0101ec5:	ba 20 df 11 c0       	mov    $0xc011df20,%edx
c0101eca:	89 10                	mov    %edx,(%eax)
        }
        break;
c0101ecc:	e9 b8 00 00 00       	jmp    c0101f89 <trap_dispatch+0x280>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ed8:	83 f8 08             	cmp    $0x8,%eax
c0101edb:	0f 84 ab 00 00 00    	je     c0101f8c <trap_dispatch+0x283>
            tf->tf_cs = KERNEL_CS;
c0101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eed:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101efa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f04:	8b 40 40             	mov    0x40(%eax),%eax
c0101f07:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f0c:	89 c2                	mov    %eax,%edx
c0101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f11:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f17:	8b 40 44             	mov    0x44(%eax),%eax
c0101f1a:	83 e8 44             	sub    $0x44,%eax
c0101f1d:	a3 6c df 11 c0       	mov    %eax,0xc011df6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101f22:	a1 6c df 11 c0       	mov    0xc011df6c,%eax
c0101f27:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101f2e:	00 
c0101f2f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101f32:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101f36:	89 04 24             	mov    %eax,(%esp)
c0101f39:	e8 29 48 00 00       	call   c0106767 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101f3e:	8b 15 6c df 11 c0    	mov    0xc011df6c,%edx
c0101f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f47:	83 e8 04             	sub    $0x4,%eax
c0101f4a:	89 10                	mov    %edx,(%eax)
        }
        break;
c0101f4c:	eb 3e                	jmp    c0101f8c <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f51:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f55:	83 e0 03             	and    $0x3,%eax
c0101f58:	85 c0                	test   %eax,%eax
c0101f5a:	75 31                	jne    c0101f8d <trap_dispatch+0x284>
            print_trapframe(tf);
c0101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5f:	89 04 24             	mov    %eax,(%esp)
c0101f62:	e8 37 fb ff ff       	call   c0101a9e <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f67:	c7 44 24 08 aa 74 10 	movl   $0xc01074aa,0x8(%esp)
c0101f6e:	c0 
c0101f6f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0101f76:	00 
c0101f77:	c7 04 24 ce 72 10 c0 	movl   $0xc01072ce,(%esp)
c0101f7e:	e8 76 e4 ff ff       	call   c01003f9 <__panic>
        break;
c0101f83:	90                   	nop
c0101f84:	eb 07                	jmp    c0101f8d <trap_dispatch+0x284>
        break;
c0101f86:	90                   	nop
c0101f87:	eb 04                	jmp    c0101f8d <trap_dispatch+0x284>
        break;
c0101f89:	90                   	nop
c0101f8a:	eb 01                	jmp    c0101f8d <trap_dispatch+0x284>
        break;
c0101f8c:	90                   	nop
        }
    }
}
c0101f8d:	90                   	nop
c0101f8e:	83 c4 2c             	add    $0x2c,%esp
c0101f91:	5b                   	pop    %ebx
c0101f92:	5e                   	pop    %esi
c0101f93:	5f                   	pop    %edi
c0101f94:	5d                   	pop    %ebp
c0101f95:	c3                   	ret    

c0101f96 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f96:	55                   	push   %ebp
c0101f97:	89 e5                	mov    %esp,%ebp
c0101f99:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9f:	89 04 24             	mov    %eax,(%esp)
c0101fa2:	e8 62 fd ff ff       	call   c0101d09 <trap_dispatch>
}
c0101fa7:	90                   	nop
c0101fa8:	c9                   	leave  
c0101fa9:	c3                   	ret    

c0101faa <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $0
c0101fac:	6a 00                	push   $0x0
  jmp __alltraps
c0101fae:	e9 69 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fb3 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $1
c0101fb5:	6a 01                	push   $0x1
  jmp __alltraps
c0101fb7:	e9 60 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fbc <vector2>:
.globl vector2
vector2:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $2
c0101fbe:	6a 02                	push   $0x2
  jmp __alltraps
c0101fc0:	e9 57 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fc5 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $3
c0101fc7:	6a 03                	push   $0x3
  jmp __alltraps
c0101fc9:	e9 4e 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fce <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $4
c0101fd0:	6a 04                	push   $0x4
  jmp __alltraps
c0101fd2:	e9 45 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fd7 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $5
c0101fd9:	6a 05                	push   $0x5
  jmp __alltraps
c0101fdb:	e9 3c 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fe0 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $6
c0101fe2:	6a 06                	push   $0x6
  jmp __alltraps
c0101fe4:	e9 33 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101fe9 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $7
c0101feb:	6a 07                	push   $0x7
  jmp __alltraps
c0101fed:	e9 2a 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101ff2 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ff2:	6a 08                	push   $0x8
  jmp __alltraps
c0101ff4:	e9 23 0a 00 00       	jmp    c0102a1c <__alltraps>

c0101ff9 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $9
c0101ffb:	6a 09                	push   $0x9
  jmp __alltraps
c0101ffd:	e9 1a 0a 00 00       	jmp    c0102a1c <__alltraps>

c0102002 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102002:	6a 0a                	push   $0xa
  jmp __alltraps
c0102004:	e9 13 0a 00 00       	jmp    c0102a1c <__alltraps>

c0102009 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102009:	6a 0b                	push   $0xb
  jmp __alltraps
c010200b:	e9 0c 0a 00 00       	jmp    c0102a1c <__alltraps>

c0102010 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102010:	6a 0c                	push   $0xc
  jmp __alltraps
c0102012:	e9 05 0a 00 00       	jmp    c0102a1c <__alltraps>

c0102017 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102017:	6a 0d                	push   $0xd
  jmp __alltraps
c0102019:	e9 fe 09 00 00       	jmp    c0102a1c <__alltraps>

c010201e <vector14>:
.globl vector14
vector14:
  pushl $14
c010201e:	6a 0e                	push   $0xe
  jmp __alltraps
c0102020:	e9 f7 09 00 00       	jmp    c0102a1c <__alltraps>

c0102025 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102025:	6a 00                	push   $0x0
  pushl $15
c0102027:	6a 0f                	push   $0xf
  jmp __alltraps
c0102029:	e9 ee 09 00 00       	jmp    c0102a1c <__alltraps>

c010202e <vector16>:
.globl vector16
vector16:
  pushl $0
c010202e:	6a 00                	push   $0x0
  pushl $16
c0102030:	6a 10                	push   $0x10
  jmp __alltraps
c0102032:	e9 e5 09 00 00       	jmp    c0102a1c <__alltraps>

c0102037 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102037:	6a 11                	push   $0x11
  jmp __alltraps
c0102039:	e9 de 09 00 00       	jmp    c0102a1c <__alltraps>

c010203e <vector18>:
.globl vector18
vector18:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $18
c0102040:	6a 12                	push   $0x12
  jmp __alltraps
c0102042:	e9 d5 09 00 00       	jmp    c0102a1c <__alltraps>

c0102047 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $19
c0102049:	6a 13                	push   $0x13
  jmp __alltraps
c010204b:	e9 cc 09 00 00       	jmp    c0102a1c <__alltraps>

c0102050 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $20
c0102052:	6a 14                	push   $0x14
  jmp __alltraps
c0102054:	e9 c3 09 00 00       	jmp    c0102a1c <__alltraps>

c0102059 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $21
c010205b:	6a 15                	push   $0x15
  jmp __alltraps
c010205d:	e9 ba 09 00 00       	jmp    c0102a1c <__alltraps>

c0102062 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $22
c0102064:	6a 16                	push   $0x16
  jmp __alltraps
c0102066:	e9 b1 09 00 00       	jmp    c0102a1c <__alltraps>

c010206b <vector23>:
.globl vector23
vector23:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $23
c010206d:	6a 17                	push   $0x17
  jmp __alltraps
c010206f:	e9 a8 09 00 00       	jmp    c0102a1c <__alltraps>

c0102074 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $24
c0102076:	6a 18                	push   $0x18
  jmp __alltraps
c0102078:	e9 9f 09 00 00       	jmp    c0102a1c <__alltraps>

c010207d <vector25>:
.globl vector25
vector25:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $25
c010207f:	6a 19                	push   $0x19
  jmp __alltraps
c0102081:	e9 96 09 00 00       	jmp    c0102a1c <__alltraps>

c0102086 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $26
c0102088:	6a 1a                	push   $0x1a
  jmp __alltraps
c010208a:	e9 8d 09 00 00       	jmp    c0102a1c <__alltraps>

c010208f <vector27>:
.globl vector27
vector27:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $27
c0102091:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102093:	e9 84 09 00 00       	jmp    c0102a1c <__alltraps>

c0102098 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $28
c010209a:	6a 1c                	push   $0x1c
  jmp __alltraps
c010209c:	e9 7b 09 00 00       	jmp    c0102a1c <__alltraps>

c01020a1 <vector29>:
.globl vector29
vector29:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $29
c01020a3:	6a 1d                	push   $0x1d
  jmp __alltraps
c01020a5:	e9 72 09 00 00       	jmp    c0102a1c <__alltraps>

c01020aa <vector30>:
.globl vector30
vector30:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $30
c01020ac:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020ae:	e9 69 09 00 00       	jmp    c0102a1c <__alltraps>

c01020b3 <vector31>:
.globl vector31
vector31:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $31
c01020b5:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020b7:	e9 60 09 00 00       	jmp    c0102a1c <__alltraps>

c01020bc <vector32>:
.globl vector32
vector32:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $32
c01020be:	6a 20                	push   $0x20
  jmp __alltraps
c01020c0:	e9 57 09 00 00       	jmp    c0102a1c <__alltraps>

c01020c5 <vector33>:
.globl vector33
vector33:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $33
c01020c7:	6a 21                	push   $0x21
  jmp __alltraps
c01020c9:	e9 4e 09 00 00       	jmp    c0102a1c <__alltraps>

c01020ce <vector34>:
.globl vector34
vector34:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $34
c01020d0:	6a 22                	push   $0x22
  jmp __alltraps
c01020d2:	e9 45 09 00 00       	jmp    c0102a1c <__alltraps>

c01020d7 <vector35>:
.globl vector35
vector35:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $35
c01020d9:	6a 23                	push   $0x23
  jmp __alltraps
c01020db:	e9 3c 09 00 00       	jmp    c0102a1c <__alltraps>

c01020e0 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $36
c01020e2:	6a 24                	push   $0x24
  jmp __alltraps
c01020e4:	e9 33 09 00 00       	jmp    c0102a1c <__alltraps>

c01020e9 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $37
c01020eb:	6a 25                	push   $0x25
  jmp __alltraps
c01020ed:	e9 2a 09 00 00       	jmp    c0102a1c <__alltraps>

c01020f2 <vector38>:
.globl vector38
vector38:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $38
c01020f4:	6a 26                	push   $0x26
  jmp __alltraps
c01020f6:	e9 21 09 00 00       	jmp    c0102a1c <__alltraps>

c01020fb <vector39>:
.globl vector39
vector39:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $39
c01020fd:	6a 27                	push   $0x27
  jmp __alltraps
c01020ff:	e9 18 09 00 00       	jmp    c0102a1c <__alltraps>

c0102104 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $40
c0102106:	6a 28                	push   $0x28
  jmp __alltraps
c0102108:	e9 0f 09 00 00       	jmp    c0102a1c <__alltraps>

c010210d <vector41>:
.globl vector41
vector41:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $41
c010210f:	6a 29                	push   $0x29
  jmp __alltraps
c0102111:	e9 06 09 00 00       	jmp    c0102a1c <__alltraps>

c0102116 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $42
c0102118:	6a 2a                	push   $0x2a
  jmp __alltraps
c010211a:	e9 fd 08 00 00       	jmp    c0102a1c <__alltraps>

c010211f <vector43>:
.globl vector43
vector43:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $43
c0102121:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102123:	e9 f4 08 00 00       	jmp    c0102a1c <__alltraps>

c0102128 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $44
c010212a:	6a 2c                	push   $0x2c
  jmp __alltraps
c010212c:	e9 eb 08 00 00       	jmp    c0102a1c <__alltraps>

c0102131 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $45
c0102133:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102135:	e9 e2 08 00 00       	jmp    c0102a1c <__alltraps>

c010213a <vector46>:
.globl vector46
vector46:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $46
c010213c:	6a 2e                	push   $0x2e
  jmp __alltraps
c010213e:	e9 d9 08 00 00       	jmp    c0102a1c <__alltraps>

c0102143 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $47
c0102145:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102147:	e9 d0 08 00 00       	jmp    c0102a1c <__alltraps>

c010214c <vector48>:
.globl vector48
vector48:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $48
c010214e:	6a 30                	push   $0x30
  jmp __alltraps
c0102150:	e9 c7 08 00 00       	jmp    c0102a1c <__alltraps>

c0102155 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $49
c0102157:	6a 31                	push   $0x31
  jmp __alltraps
c0102159:	e9 be 08 00 00       	jmp    c0102a1c <__alltraps>

c010215e <vector50>:
.globl vector50
vector50:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $50
c0102160:	6a 32                	push   $0x32
  jmp __alltraps
c0102162:	e9 b5 08 00 00       	jmp    c0102a1c <__alltraps>

c0102167 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $51
c0102169:	6a 33                	push   $0x33
  jmp __alltraps
c010216b:	e9 ac 08 00 00       	jmp    c0102a1c <__alltraps>

c0102170 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $52
c0102172:	6a 34                	push   $0x34
  jmp __alltraps
c0102174:	e9 a3 08 00 00       	jmp    c0102a1c <__alltraps>

c0102179 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $53
c010217b:	6a 35                	push   $0x35
  jmp __alltraps
c010217d:	e9 9a 08 00 00       	jmp    c0102a1c <__alltraps>

c0102182 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $54
c0102184:	6a 36                	push   $0x36
  jmp __alltraps
c0102186:	e9 91 08 00 00       	jmp    c0102a1c <__alltraps>

c010218b <vector55>:
.globl vector55
vector55:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $55
c010218d:	6a 37                	push   $0x37
  jmp __alltraps
c010218f:	e9 88 08 00 00       	jmp    c0102a1c <__alltraps>

c0102194 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $56
c0102196:	6a 38                	push   $0x38
  jmp __alltraps
c0102198:	e9 7f 08 00 00       	jmp    c0102a1c <__alltraps>

c010219d <vector57>:
.globl vector57
vector57:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $57
c010219f:	6a 39                	push   $0x39
  jmp __alltraps
c01021a1:	e9 76 08 00 00       	jmp    c0102a1c <__alltraps>

c01021a6 <vector58>:
.globl vector58
vector58:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $58
c01021a8:	6a 3a                	push   $0x3a
  jmp __alltraps
c01021aa:	e9 6d 08 00 00       	jmp    c0102a1c <__alltraps>

c01021af <vector59>:
.globl vector59
vector59:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $59
c01021b1:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021b3:	e9 64 08 00 00       	jmp    c0102a1c <__alltraps>

c01021b8 <vector60>:
.globl vector60
vector60:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $60
c01021ba:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021bc:	e9 5b 08 00 00       	jmp    c0102a1c <__alltraps>

c01021c1 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $61
c01021c3:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021c5:	e9 52 08 00 00       	jmp    c0102a1c <__alltraps>

c01021ca <vector62>:
.globl vector62
vector62:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $62
c01021cc:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021ce:	e9 49 08 00 00       	jmp    c0102a1c <__alltraps>

c01021d3 <vector63>:
.globl vector63
vector63:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $63
c01021d5:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021d7:	e9 40 08 00 00       	jmp    c0102a1c <__alltraps>

c01021dc <vector64>:
.globl vector64
vector64:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $64
c01021de:	6a 40                	push   $0x40
  jmp __alltraps
c01021e0:	e9 37 08 00 00       	jmp    c0102a1c <__alltraps>

c01021e5 <vector65>:
.globl vector65
vector65:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $65
c01021e7:	6a 41                	push   $0x41
  jmp __alltraps
c01021e9:	e9 2e 08 00 00       	jmp    c0102a1c <__alltraps>

c01021ee <vector66>:
.globl vector66
vector66:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $66
c01021f0:	6a 42                	push   $0x42
  jmp __alltraps
c01021f2:	e9 25 08 00 00       	jmp    c0102a1c <__alltraps>

c01021f7 <vector67>:
.globl vector67
vector67:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $67
c01021f9:	6a 43                	push   $0x43
  jmp __alltraps
c01021fb:	e9 1c 08 00 00       	jmp    c0102a1c <__alltraps>

c0102200 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $68
c0102202:	6a 44                	push   $0x44
  jmp __alltraps
c0102204:	e9 13 08 00 00       	jmp    c0102a1c <__alltraps>

c0102209 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $69
c010220b:	6a 45                	push   $0x45
  jmp __alltraps
c010220d:	e9 0a 08 00 00       	jmp    c0102a1c <__alltraps>

c0102212 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $70
c0102214:	6a 46                	push   $0x46
  jmp __alltraps
c0102216:	e9 01 08 00 00       	jmp    c0102a1c <__alltraps>

c010221b <vector71>:
.globl vector71
vector71:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $71
c010221d:	6a 47                	push   $0x47
  jmp __alltraps
c010221f:	e9 f8 07 00 00       	jmp    c0102a1c <__alltraps>

c0102224 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $72
c0102226:	6a 48                	push   $0x48
  jmp __alltraps
c0102228:	e9 ef 07 00 00       	jmp    c0102a1c <__alltraps>

c010222d <vector73>:
.globl vector73
vector73:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $73
c010222f:	6a 49                	push   $0x49
  jmp __alltraps
c0102231:	e9 e6 07 00 00       	jmp    c0102a1c <__alltraps>

c0102236 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $74
c0102238:	6a 4a                	push   $0x4a
  jmp __alltraps
c010223a:	e9 dd 07 00 00       	jmp    c0102a1c <__alltraps>

c010223f <vector75>:
.globl vector75
vector75:
  pushl $0
c010223f:	6a 00                	push   $0x0
  pushl $75
c0102241:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102243:	e9 d4 07 00 00       	jmp    c0102a1c <__alltraps>

c0102248 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $76
c010224a:	6a 4c                	push   $0x4c
  jmp __alltraps
c010224c:	e9 cb 07 00 00       	jmp    c0102a1c <__alltraps>

c0102251 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $77
c0102253:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102255:	e9 c2 07 00 00       	jmp    c0102a1c <__alltraps>

c010225a <vector78>:
.globl vector78
vector78:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $78
c010225c:	6a 4e                	push   $0x4e
  jmp __alltraps
c010225e:	e9 b9 07 00 00       	jmp    c0102a1c <__alltraps>

c0102263 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $79
c0102265:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102267:	e9 b0 07 00 00       	jmp    c0102a1c <__alltraps>

c010226c <vector80>:
.globl vector80
vector80:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $80
c010226e:	6a 50                	push   $0x50
  jmp __alltraps
c0102270:	e9 a7 07 00 00       	jmp    c0102a1c <__alltraps>

c0102275 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $81
c0102277:	6a 51                	push   $0x51
  jmp __alltraps
c0102279:	e9 9e 07 00 00       	jmp    c0102a1c <__alltraps>

c010227e <vector82>:
.globl vector82
vector82:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $82
c0102280:	6a 52                	push   $0x52
  jmp __alltraps
c0102282:	e9 95 07 00 00       	jmp    c0102a1c <__alltraps>

c0102287 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $83
c0102289:	6a 53                	push   $0x53
  jmp __alltraps
c010228b:	e9 8c 07 00 00       	jmp    c0102a1c <__alltraps>

c0102290 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $84
c0102292:	6a 54                	push   $0x54
  jmp __alltraps
c0102294:	e9 83 07 00 00       	jmp    c0102a1c <__alltraps>

c0102299 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $85
c010229b:	6a 55                	push   $0x55
  jmp __alltraps
c010229d:	e9 7a 07 00 00       	jmp    c0102a1c <__alltraps>

c01022a2 <vector86>:
.globl vector86
vector86:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $86
c01022a4:	6a 56                	push   $0x56
  jmp __alltraps
c01022a6:	e9 71 07 00 00       	jmp    c0102a1c <__alltraps>

c01022ab <vector87>:
.globl vector87
vector87:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $87
c01022ad:	6a 57                	push   $0x57
  jmp __alltraps
c01022af:	e9 68 07 00 00       	jmp    c0102a1c <__alltraps>

c01022b4 <vector88>:
.globl vector88
vector88:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $88
c01022b6:	6a 58                	push   $0x58
  jmp __alltraps
c01022b8:	e9 5f 07 00 00       	jmp    c0102a1c <__alltraps>

c01022bd <vector89>:
.globl vector89
vector89:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $89
c01022bf:	6a 59                	push   $0x59
  jmp __alltraps
c01022c1:	e9 56 07 00 00       	jmp    c0102a1c <__alltraps>

c01022c6 <vector90>:
.globl vector90
vector90:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $90
c01022c8:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022ca:	e9 4d 07 00 00       	jmp    c0102a1c <__alltraps>

c01022cf <vector91>:
.globl vector91
vector91:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $91
c01022d1:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022d3:	e9 44 07 00 00       	jmp    c0102a1c <__alltraps>

c01022d8 <vector92>:
.globl vector92
vector92:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $92
c01022da:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022dc:	e9 3b 07 00 00       	jmp    c0102a1c <__alltraps>

c01022e1 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $93
c01022e3:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022e5:	e9 32 07 00 00       	jmp    c0102a1c <__alltraps>

c01022ea <vector94>:
.globl vector94
vector94:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $94
c01022ec:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022ee:	e9 29 07 00 00       	jmp    c0102a1c <__alltraps>

c01022f3 <vector95>:
.globl vector95
vector95:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $95
c01022f5:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022f7:	e9 20 07 00 00       	jmp    c0102a1c <__alltraps>

c01022fc <vector96>:
.globl vector96
vector96:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $96
c01022fe:	6a 60                	push   $0x60
  jmp __alltraps
c0102300:	e9 17 07 00 00       	jmp    c0102a1c <__alltraps>

c0102305 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $97
c0102307:	6a 61                	push   $0x61
  jmp __alltraps
c0102309:	e9 0e 07 00 00       	jmp    c0102a1c <__alltraps>

c010230e <vector98>:
.globl vector98
vector98:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $98
c0102310:	6a 62                	push   $0x62
  jmp __alltraps
c0102312:	e9 05 07 00 00       	jmp    c0102a1c <__alltraps>

c0102317 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $99
c0102319:	6a 63                	push   $0x63
  jmp __alltraps
c010231b:	e9 fc 06 00 00       	jmp    c0102a1c <__alltraps>

c0102320 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $100
c0102322:	6a 64                	push   $0x64
  jmp __alltraps
c0102324:	e9 f3 06 00 00       	jmp    c0102a1c <__alltraps>

c0102329 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $101
c010232b:	6a 65                	push   $0x65
  jmp __alltraps
c010232d:	e9 ea 06 00 00       	jmp    c0102a1c <__alltraps>

c0102332 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $102
c0102334:	6a 66                	push   $0x66
  jmp __alltraps
c0102336:	e9 e1 06 00 00       	jmp    c0102a1c <__alltraps>

c010233b <vector103>:
.globl vector103
vector103:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $103
c010233d:	6a 67                	push   $0x67
  jmp __alltraps
c010233f:	e9 d8 06 00 00       	jmp    c0102a1c <__alltraps>

c0102344 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $104
c0102346:	6a 68                	push   $0x68
  jmp __alltraps
c0102348:	e9 cf 06 00 00       	jmp    c0102a1c <__alltraps>

c010234d <vector105>:
.globl vector105
vector105:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $105
c010234f:	6a 69                	push   $0x69
  jmp __alltraps
c0102351:	e9 c6 06 00 00       	jmp    c0102a1c <__alltraps>

c0102356 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $106
c0102358:	6a 6a                	push   $0x6a
  jmp __alltraps
c010235a:	e9 bd 06 00 00       	jmp    c0102a1c <__alltraps>

c010235f <vector107>:
.globl vector107
vector107:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $107
c0102361:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102363:	e9 b4 06 00 00       	jmp    c0102a1c <__alltraps>

c0102368 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $108
c010236a:	6a 6c                	push   $0x6c
  jmp __alltraps
c010236c:	e9 ab 06 00 00       	jmp    c0102a1c <__alltraps>

c0102371 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $109
c0102373:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102375:	e9 a2 06 00 00       	jmp    c0102a1c <__alltraps>

c010237a <vector110>:
.globl vector110
vector110:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $110
c010237c:	6a 6e                	push   $0x6e
  jmp __alltraps
c010237e:	e9 99 06 00 00       	jmp    c0102a1c <__alltraps>

c0102383 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $111
c0102385:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102387:	e9 90 06 00 00       	jmp    c0102a1c <__alltraps>

c010238c <vector112>:
.globl vector112
vector112:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $112
c010238e:	6a 70                	push   $0x70
  jmp __alltraps
c0102390:	e9 87 06 00 00       	jmp    c0102a1c <__alltraps>

c0102395 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $113
c0102397:	6a 71                	push   $0x71
  jmp __alltraps
c0102399:	e9 7e 06 00 00       	jmp    c0102a1c <__alltraps>

c010239e <vector114>:
.globl vector114
vector114:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $114
c01023a0:	6a 72                	push   $0x72
  jmp __alltraps
c01023a2:	e9 75 06 00 00       	jmp    c0102a1c <__alltraps>

c01023a7 <vector115>:
.globl vector115
vector115:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $115
c01023a9:	6a 73                	push   $0x73
  jmp __alltraps
c01023ab:	e9 6c 06 00 00       	jmp    c0102a1c <__alltraps>

c01023b0 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $116
c01023b2:	6a 74                	push   $0x74
  jmp __alltraps
c01023b4:	e9 63 06 00 00       	jmp    c0102a1c <__alltraps>

c01023b9 <vector117>:
.globl vector117
vector117:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $117
c01023bb:	6a 75                	push   $0x75
  jmp __alltraps
c01023bd:	e9 5a 06 00 00       	jmp    c0102a1c <__alltraps>

c01023c2 <vector118>:
.globl vector118
vector118:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $118
c01023c4:	6a 76                	push   $0x76
  jmp __alltraps
c01023c6:	e9 51 06 00 00       	jmp    c0102a1c <__alltraps>

c01023cb <vector119>:
.globl vector119
vector119:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $119
c01023cd:	6a 77                	push   $0x77
  jmp __alltraps
c01023cf:	e9 48 06 00 00       	jmp    c0102a1c <__alltraps>

c01023d4 <vector120>:
.globl vector120
vector120:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $120
c01023d6:	6a 78                	push   $0x78
  jmp __alltraps
c01023d8:	e9 3f 06 00 00       	jmp    c0102a1c <__alltraps>

c01023dd <vector121>:
.globl vector121
vector121:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $121
c01023df:	6a 79                	push   $0x79
  jmp __alltraps
c01023e1:	e9 36 06 00 00       	jmp    c0102a1c <__alltraps>

c01023e6 <vector122>:
.globl vector122
vector122:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $122
c01023e8:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023ea:	e9 2d 06 00 00       	jmp    c0102a1c <__alltraps>

c01023ef <vector123>:
.globl vector123
vector123:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $123
c01023f1:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023f3:	e9 24 06 00 00       	jmp    c0102a1c <__alltraps>

c01023f8 <vector124>:
.globl vector124
vector124:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $124
c01023fa:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023fc:	e9 1b 06 00 00       	jmp    c0102a1c <__alltraps>

c0102401 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $125
c0102403:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102405:	e9 12 06 00 00       	jmp    c0102a1c <__alltraps>

c010240a <vector126>:
.globl vector126
vector126:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $126
c010240c:	6a 7e                	push   $0x7e
  jmp __alltraps
c010240e:	e9 09 06 00 00       	jmp    c0102a1c <__alltraps>

c0102413 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $127
c0102415:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102417:	e9 00 06 00 00       	jmp    c0102a1c <__alltraps>

c010241c <vector128>:
.globl vector128
vector128:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $128
c010241e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102423:	e9 f4 05 00 00       	jmp    c0102a1c <__alltraps>

c0102428 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $129
c010242a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010242f:	e9 e8 05 00 00       	jmp    c0102a1c <__alltraps>

c0102434 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $130
c0102436:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010243b:	e9 dc 05 00 00       	jmp    c0102a1c <__alltraps>

c0102440 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $131
c0102442:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102447:	e9 d0 05 00 00       	jmp    c0102a1c <__alltraps>

c010244c <vector132>:
.globl vector132
vector132:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $132
c010244e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102453:	e9 c4 05 00 00       	jmp    c0102a1c <__alltraps>

c0102458 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $133
c010245a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010245f:	e9 b8 05 00 00       	jmp    c0102a1c <__alltraps>

c0102464 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $134
c0102466:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010246b:	e9 ac 05 00 00       	jmp    c0102a1c <__alltraps>

c0102470 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $135
c0102472:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102477:	e9 a0 05 00 00       	jmp    c0102a1c <__alltraps>

c010247c <vector136>:
.globl vector136
vector136:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $136
c010247e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102483:	e9 94 05 00 00       	jmp    c0102a1c <__alltraps>

c0102488 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $137
c010248a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010248f:	e9 88 05 00 00       	jmp    c0102a1c <__alltraps>

c0102494 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $138
c0102496:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010249b:	e9 7c 05 00 00       	jmp    c0102a1c <__alltraps>

c01024a0 <vector139>:
.globl vector139
vector139:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $139
c01024a2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01024a7:	e9 70 05 00 00       	jmp    c0102a1c <__alltraps>

c01024ac <vector140>:
.globl vector140
vector140:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $140
c01024ae:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024b3:	e9 64 05 00 00       	jmp    c0102a1c <__alltraps>

c01024b8 <vector141>:
.globl vector141
vector141:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $141
c01024ba:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024bf:	e9 58 05 00 00       	jmp    c0102a1c <__alltraps>

c01024c4 <vector142>:
.globl vector142
vector142:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $142
c01024c6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024cb:	e9 4c 05 00 00       	jmp    c0102a1c <__alltraps>

c01024d0 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $143
c01024d2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024d7:	e9 40 05 00 00       	jmp    c0102a1c <__alltraps>

c01024dc <vector144>:
.globl vector144
vector144:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $144
c01024de:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024e3:	e9 34 05 00 00       	jmp    c0102a1c <__alltraps>

c01024e8 <vector145>:
.globl vector145
vector145:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $145
c01024ea:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024ef:	e9 28 05 00 00       	jmp    c0102a1c <__alltraps>

c01024f4 <vector146>:
.globl vector146
vector146:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $146
c01024f6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024fb:	e9 1c 05 00 00       	jmp    c0102a1c <__alltraps>

c0102500 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $147
c0102502:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102507:	e9 10 05 00 00       	jmp    c0102a1c <__alltraps>

c010250c <vector148>:
.globl vector148
vector148:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $148
c010250e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102513:	e9 04 05 00 00       	jmp    c0102a1c <__alltraps>

c0102518 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $149
c010251a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010251f:	e9 f8 04 00 00       	jmp    c0102a1c <__alltraps>

c0102524 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $150
c0102526:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010252b:	e9 ec 04 00 00       	jmp    c0102a1c <__alltraps>

c0102530 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $151
c0102532:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102537:	e9 e0 04 00 00       	jmp    c0102a1c <__alltraps>

c010253c <vector152>:
.globl vector152
vector152:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $152
c010253e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102543:	e9 d4 04 00 00       	jmp    c0102a1c <__alltraps>

c0102548 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $153
c010254a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010254f:	e9 c8 04 00 00       	jmp    c0102a1c <__alltraps>

c0102554 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $154
c0102556:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010255b:	e9 bc 04 00 00       	jmp    c0102a1c <__alltraps>

c0102560 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $155
c0102562:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102567:	e9 b0 04 00 00       	jmp    c0102a1c <__alltraps>

c010256c <vector156>:
.globl vector156
vector156:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $156
c010256e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102573:	e9 a4 04 00 00       	jmp    c0102a1c <__alltraps>

c0102578 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $157
c010257a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010257f:	e9 98 04 00 00       	jmp    c0102a1c <__alltraps>

c0102584 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $158
c0102586:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010258b:	e9 8c 04 00 00       	jmp    c0102a1c <__alltraps>

c0102590 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $159
c0102592:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102597:	e9 80 04 00 00       	jmp    c0102a1c <__alltraps>

c010259c <vector160>:
.globl vector160
vector160:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $160
c010259e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01025a3:	e9 74 04 00 00       	jmp    c0102a1c <__alltraps>

c01025a8 <vector161>:
.globl vector161
vector161:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $161
c01025aa:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025af:	e9 68 04 00 00       	jmp    c0102a1c <__alltraps>

c01025b4 <vector162>:
.globl vector162
vector162:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $162
c01025b6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025bb:	e9 5c 04 00 00       	jmp    c0102a1c <__alltraps>

c01025c0 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $163
c01025c2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025c7:	e9 50 04 00 00       	jmp    c0102a1c <__alltraps>

c01025cc <vector164>:
.globl vector164
vector164:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $164
c01025ce:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025d3:	e9 44 04 00 00       	jmp    c0102a1c <__alltraps>

c01025d8 <vector165>:
.globl vector165
vector165:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $165
c01025da:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025df:	e9 38 04 00 00       	jmp    c0102a1c <__alltraps>

c01025e4 <vector166>:
.globl vector166
vector166:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $166
c01025e6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025eb:	e9 2c 04 00 00       	jmp    c0102a1c <__alltraps>

c01025f0 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $167
c01025f2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025f7:	e9 20 04 00 00       	jmp    c0102a1c <__alltraps>

c01025fc <vector168>:
.globl vector168
vector168:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $168
c01025fe:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102603:	e9 14 04 00 00       	jmp    c0102a1c <__alltraps>

c0102608 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $169
c010260a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010260f:	e9 08 04 00 00       	jmp    c0102a1c <__alltraps>

c0102614 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $170
c0102616:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010261b:	e9 fc 03 00 00       	jmp    c0102a1c <__alltraps>

c0102620 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $171
c0102622:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102627:	e9 f0 03 00 00       	jmp    c0102a1c <__alltraps>

c010262c <vector172>:
.globl vector172
vector172:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $172
c010262e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102633:	e9 e4 03 00 00       	jmp    c0102a1c <__alltraps>

c0102638 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $173
c010263a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010263f:	e9 d8 03 00 00       	jmp    c0102a1c <__alltraps>

c0102644 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $174
c0102646:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010264b:	e9 cc 03 00 00       	jmp    c0102a1c <__alltraps>

c0102650 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $175
c0102652:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102657:	e9 c0 03 00 00       	jmp    c0102a1c <__alltraps>

c010265c <vector176>:
.globl vector176
vector176:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $176
c010265e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102663:	e9 b4 03 00 00       	jmp    c0102a1c <__alltraps>

c0102668 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $177
c010266a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010266f:	e9 a8 03 00 00       	jmp    c0102a1c <__alltraps>

c0102674 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $178
c0102676:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010267b:	e9 9c 03 00 00       	jmp    c0102a1c <__alltraps>

c0102680 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $179
c0102682:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102687:	e9 90 03 00 00       	jmp    c0102a1c <__alltraps>

c010268c <vector180>:
.globl vector180
vector180:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $180
c010268e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102693:	e9 84 03 00 00       	jmp    c0102a1c <__alltraps>

c0102698 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $181
c010269a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010269f:	e9 78 03 00 00       	jmp    c0102a1c <__alltraps>

c01026a4 <vector182>:
.globl vector182
vector182:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $182
c01026a6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01026ab:	e9 6c 03 00 00       	jmp    c0102a1c <__alltraps>

c01026b0 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $183
c01026b2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026b7:	e9 60 03 00 00       	jmp    c0102a1c <__alltraps>

c01026bc <vector184>:
.globl vector184
vector184:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $184
c01026be:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026c3:	e9 54 03 00 00       	jmp    c0102a1c <__alltraps>

c01026c8 <vector185>:
.globl vector185
vector185:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $185
c01026ca:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026cf:	e9 48 03 00 00       	jmp    c0102a1c <__alltraps>

c01026d4 <vector186>:
.globl vector186
vector186:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $186
c01026d6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026db:	e9 3c 03 00 00       	jmp    c0102a1c <__alltraps>

c01026e0 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $187
c01026e2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026e7:	e9 30 03 00 00       	jmp    c0102a1c <__alltraps>

c01026ec <vector188>:
.globl vector188
vector188:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $188
c01026ee:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026f3:	e9 24 03 00 00       	jmp    c0102a1c <__alltraps>

c01026f8 <vector189>:
.globl vector189
vector189:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $189
c01026fa:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026ff:	e9 18 03 00 00       	jmp    c0102a1c <__alltraps>

c0102704 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $190
c0102706:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010270b:	e9 0c 03 00 00       	jmp    c0102a1c <__alltraps>

c0102710 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $191
c0102712:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102717:	e9 00 03 00 00       	jmp    c0102a1c <__alltraps>

c010271c <vector192>:
.globl vector192
vector192:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $192
c010271e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102723:	e9 f4 02 00 00       	jmp    c0102a1c <__alltraps>

c0102728 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $193
c010272a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010272f:	e9 e8 02 00 00       	jmp    c0102a1c <__alltraps>

c0102734 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $194
c0102736:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010273b:	e9 dc 02 00 00       	jmp    c0102a1c <__alltraps>

c0102740 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $195
c0102742:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102747:	e9 d0 02 00 00       	jmp    c0102a1c <__alltraps>

c010274c <vector196>:
.globl vector196
vector196:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $196
c010274e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102753:	e9 c4 02 00 00       	jmp    c0102a1c <__alltraps>

c0102758 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $197
c010275a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010275f:	e9 b8 02 00 00       	jmp    c0102a1c <__alltraps>

c0102764 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $198
c0102766:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010276b:	e9 ac 02 00 00       	jmp    c0102a1c <__alltraps>

c0102770 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $199
c0102772:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102777:	e9 a0 02 00 00       	jmp    c0102a1c <__alltraps>

c010277c <vector200>:
.globl vector200
vector200:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $200
c010277e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102783:	e9 94 02 00 00       	jmp    c0102a1c <__alltraps>

c0102788 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $201
c010278a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010278f:	e9 88 02 00 00       	jmp    c0102a1c <__alltraps>

c0102794 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $202
c0102796:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010279b:	e9 7c 02 00 00       	jmp    c0102a1c <__alltraps>

c01027a0 <vector203>:
.globl vector203
vector203:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $203
c01027a2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01027a7:	e9 70 02 00 00       	jmp    c0102a1c <__alltraps>

c01027ac <vector204>:
.globl vector204
vector204:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $204
c01027ae:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027b3:	e9 64 02 00 00       	jmp    c0102a1c <__alltraps>

c01027b8 <vector205>:
.globl vector205
vector205:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $205
c01027ba:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027bf:	e9 58 02 00 00       	jmp    c0102a1c <__alltraps>

c01027c4 <vector206>:
.globl vector206
vector206:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $206
c01027c6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027cb:	e9 4c 02 00 00       	jmp    c0102a1c <__alltraps>

c01027d0 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $207
c01027d2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027d7:	e9 40 02 00 00       	jmp    c0102a1c <__alltraps>

c01027dc <vector208>:
.globl vector208
vector208:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $208
c01027de:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027e3:	e9 34 02 00 00       	jmp    c0102a1c <__alltraps>

c01027e8 <vector209>:
.globl vector209
vector209:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $209
c01027ea:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027ef:	e9 28 02 00 00       	jmp    c0102a1c <__alltraps>

c01027f4 <vector210>:
.globl vector210
vector210:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $210
c01027f6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027fb:	e9 1c 02 00 00       	jmp    c0102a1c <__alltraps>

c0102800 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $211
c0102802:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102807:	e9 10 02 00 00       	jmp    c0102a1c <__alltraps>

c010280c <vector212>:
.globl vector212
vector212:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $212
c010280e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102813:	e9 04 02 00 00       	jmp    c0102a1c <__alltraps>

c0102818 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $213
c010281a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010281f:	e9 f8 01 00 00       	jmp    c0102a1c <__alltraps>

c0102824 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $214
c0102826:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010282b:	e9 ec 01 00 00       	jmp    c0102a1c <__alltraps>

c0102830 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $215
c0102832:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102837:	e9 e0 01 00 00       	jmp    c0102a1c <__alltraps>

c010283c <vector216>:
.globl vector216
vector216:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $216
c010283e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102843:	e9 d4 01 00 00       	jmp    c0102a1c <__alltraps>

c0102848 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $217
c010284a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010284f:	e9 c8 01 00 00       	jmp    c0102a1c <__alltraps>

c0102854 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $218
c0102856:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010285b:	e9 bc 01 00 00       	jmp    c0102a1c <__alltraps>

c0102860 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $219
c0102862:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102867:	e9 b0 01 00 00       	jmp    c0102a1c <__alltraps>

c010286c <vector220>:
.globl vector220
vector220:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $220
c010286e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102873:	e9 a4 01 00 00       	jmp    c0102a1c <__alltraps>

c0102878 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $221
c010287a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010287f:	e9 98 01 00 00       	jmp    c0102a1c <__alltraps>

c0102884 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $222
c0102886:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010288b:	e9 8c 01 00 00       	jmp    c0102a1c <__alltraps>

c0102890 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $223
c0102892:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102897:	e9 80 01 00 00       	jmp    c0102a1c <__alltraps>

c010289c <vector224>:
.globl vector224
vector224:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $224
c010289e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01028a3:	e9 74 01 00 00       	jmp    c0102a1c <__alltraps>

c01028a8 <vector225>:
.globl vector225
vector225:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $225
c01028aa:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028af:	e9 68 01 00 00       	jmp    c0102a1c <__alltraps>

c01028b4 <vector226>:
.globl vector226
vector226:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $226
c01028b6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028bb:	e9 5c 01 00 00       	jmp    c0102a1c <__alltraps>

c01028c0 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $227
c01028c2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028c7:	e9 50 01 00 00       	jmp    c0102a1c <__alltraps>

c01028cc <vector228>:
.globl vector228
vector228:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $228
c01028ce:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028d3:	e9 44 01 00 00       	jmp    c0102a1c <__alltraps>

c01028d8 <vector229>:
.globl vector229
vector229:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $229
c01028da:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028df:	e9 38 01 00 00       	jmp    c0102a1c <__alltraps>

c01028e4 <vector230>:
.globl vector230
vector230:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $230
c01028e6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028eb:	e9 2c 01 00 00       	jmp    c0102a1c <__alltraps>

c01028f0 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $231
c01028f2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028f7:	e9 20 01 00 00       	jmp    c0102a1c <__alltraps>

c01028fc <vector232>:
.globl vector232
vector232:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $232
c01028fe:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102903:	e9 14 01 00 00       	jmp    c0102a1c <__alltraps>

c0102908 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $233
c010290a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010290f:	e9 08 01 00 00       	jmp    c0102a1c <__alltraps>

c0102914 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102914:	6a 00                	push   $0x0
  pushl $234
c0102916:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010291b:	e9 fc 00 00 00       	jmp    c0102a1c <__alltraps>

c0102920 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $235
c0102922:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102927:	e9 f0 00 00 00       	jmp    c0102a1c <__alltraps>

c010292c <vector236>:
.globl vector236
vector236:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $236
c010292e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102933:	e9 e4 00 00 00       	jmp    c0102a1c <__alltraps>

c0102938 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102938:	6a 00                	push   $0x0
  pushl $237
c010293a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010293f:	e9 d8 00 00 00       	jmp    c0102a1c <__alltraps>

c0102944 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $238
c0102946:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010294b:	e9 cc 00 00 00       	jmp    c0102a1c <__alltraps>

c0102950 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $239
c0102952:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102957:	e9 c0 00 00 00       	jmp    c0102a1c <__alltraps>

c010295c <vector240>:
.globl vector240
vector240:
  pushl $0
c010295c:	6a 00                	push   $0x0
  pushl $240
c010295e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102963:	e9 b4 00 00 00       	jmp    c0102a1c <__alltraps>

c0102968 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $241
c010296a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010296f:	e9 a8 00 00 00       	jmp    c0102a1c <__alltraps>

c0102974 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $242
c0102976:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010297b:	e9 9c 00 00 00       	jmp    c0102a1c <__alltraps>

c0102980 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102980:	6a 00                	push   $0x0
  pushl $243
c0102982:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102987:	e9 90 00 00 00       	jmp    c0102a1c <__alltraps>

c010298c <vector244>:
.globl vector244
vector244:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $244
c010298e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102993:	e9 84 00 00 00       	jmp    c0102a1c <__alltraps>

c0102998 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $245
c010299a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010299f:	e9 78 00 00 00       	jmp    c0102a1c <__alltraps>

c01029a4 <vector246>:
.globl vector246
vector246:
  pushl $0
c01029a4:	6a 00                	push   $0x0
  pushl $246
c01029a6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01029ab:	e9 6c 00 00 00       	jmp    c0102a1c <__alltraps>

c01029b0 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029b0:	6a 00                	push   $0x0
  pushl $247
c01029b2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029b7:	e9 60 00 00 00       	jmp    c0102a1c <__alltraps>

c01029bc <vector248>:
.globl vector248
vector248:
  pushl $0
c01029bc:	6a 00                	push   $0x0
  pushl $248
c01029be:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029c3:	e9 54 00 00 00       	jmp    c0102a1c <__alltraps>

c01029c8 <vector249>:
.globl vector249
vector249:
  pushl $0
c01029c8:	6a 00                	push   $0x0
  pushl $249
c01029ca:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029cf:	e9 48 00 00 00       	jmp    c0102a1c <__alltraps>

c01029d4 <vector250>:
.globl vector250
vector250:
  pushl $0
c01029d4:	6a 00                	push   $0x0
  pushl $250
c01029d6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029db:	e9 3c 00 00 00       	jmp    c0102a1c <__alltraps>

c01029e0 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029e0:	6a 00                	push   $0x0
  pushl $251
c01029e2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029e7:	e9 30 00 00 00       	jmp    c0102a1c <__alltraps>

c01029ec <vector252>:
.globl vector252
vector252:
  pushl $0
c01029ec:	6a 00                	push   $0x0
  pushl $252
c01029ee:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029f3:	e9 24 00 00 00       	jmp    c0102a1c <__alltraps>

c01029f8 <vector253>:
.globl vector253
vector253:
  pushl $0
c01029f8:	6a 00                	push   $0x0
  pushl $253
c01029fa:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029ff:	e9 18 00 00 00       	jmp    c0102a1c <__alltraps>

c0102a04 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102a04:	6a 00                	push   $0x0
  pushl $254
c0102a06:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a0b:	e9 0c 00 00 00       	jmp    c0102a1c <__alltraps>

c0102a10 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a10:	6a 00                	push   $0x0
  pushl $255
c0102a12:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a17:	e9 00 00 00 00       	jmp    c0102a1c <__alltraps>

c0102a1c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a1c:	1e                   	push   %ds
    pushl %es
c0102a1d:	06                   	push   %es
    pushl %fs
c0102a1e:	0f a0                	push   %fs
    pushl %gs
c0102a20:	0f a8                	push   %gs
    pushal
c0102a22:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a23:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a28:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a2a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a2c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a2d:	e8 64 f5 ff ff       	call   c0101f96 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a32:	5c                   	pop    %esp

c0102a33 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a33:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a34:	0f a9                	pop    %gs
    popl %fs
c0102a36:	0f a1                	pop    %fs
    popl %es
c0102a38:	07                   	pop    %es
    popl %ds
c0102a39:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a3a:	83 c4 08             	add    $0x8,%esp
    iret
c0102a3d:	cf                   	iret   

c0102a3e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a3e:	55                   	push   %ebp
c0102a3f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a44:	8b 15 78 df 11 c0    	mov    0xc011df78,%edx
c0102a4a:	29 d0                	sub    %edx,%eax
c0102a4c:	c1 f8 02             	sar    $0x2,%eax
c0102a4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a55:	5d                   	pop    %ebp
c0102a56:	c3                   	ret    

c0102a57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a57:	55                   	push   %ebp
c0102a58:	89 e5                	mov    %esp,%ebp
c0102a5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a60:	89 04 24             	mov    %eax,(%esp)
c0102a63:	e8 d6 ff ff ff       	call   c0102a3e <page2ppn>
c0102a68:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a6b:	c9                   	leave  
c0102a6c:	c3                   	ret    

c0102a6d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102a6d:	55                   	push   %ebp
c0102a6e:	89 e5                	mov    %esp,%ebp
c0102a70:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a76:	c1 e8 0c             	shr    $0xc,%eax
c0102a79:	89 c2                	mov    %eax,%edx
c0102a7b:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102a80:	39 c2                	cmp    %eax,%edx
c0102a82:	72 1c                	jb     c0102aa0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102a84:	c7 44 24 08 70 76 10 	movl   $0xc0107670,0x8(%esp)
c0102a8b:	c0 
c0102a8c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102a93:	00 
c0102a94:	c7 04 24 8f 76 10 c0 	movl   $0xc010768f,(%esp)
c0102a9b:	e8 59 d9 ff ff       	call   c01003f9 <__panic>
    }
    return &pages[PPN(pa)];
c0102aa0:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c0102aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa9:	c1 e8 0c             	shr    $0xc,%eax
c0102aac:	89 c2                	mov    %eax,%edx
c0102aae:	89 d0                	mov    %edx,%eax
c0102ab0:	c1 e0 02             	shl    $0x2,%eax
c0102ab3:	01 d0                	add    %edx,%eax
c0102ab5:	c1 e0 02             	shl    $0x2,%eax
c0102ab8:	01 c8                	add    %ecx,%eax
}
c0102aba:	c9                   	leave  
c0102abb:	c3                   	ret    

c0102abc <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102abc:	55                   	push   %ebp
c0102abd:	89 e5                	mov    %esp,%ebp
c0102abf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac5:	89 04 24             	mov    %eax,(%esp)
c0102ac8:	e8 8a ff ff ff       	call   c0102a57 <page2pa>
c0102acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ad3:	c1 e8 0c             	shr    $0xc,%eax
c0102ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ad9:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102ade:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102ae1:	72 23                	jb     c0102b06 <page2kva+0x4a>
c0102ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102aea:	c7 44 24 08 a0 76 10 	movl   $0xc01076a0,0x8(%esp)
c0102af1:	c0 
c0102af2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102af9:	00 
c0102afa:	c7 04 24 8f 76 10 c0 	movl   $0xc010768f,(%esp)
c0102b01:	e8 f3 d8 ff ff       	call   c01003f9 <__panic>
c0102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b09:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102b0e:	c9                   	leave  
c0102b0f:	c3                   	ret    

c0102b10 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102b10:	55                   	push   %ebp
c0102b11:	89 e5                	mov    %esp,%ebp
c0102b13:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b19:	83 e0 01             	and    $0x1,%eax
c0102b1c:	85 c0                	test   %eax,%eax
c0102b1e:	75 1c                	jne    c0102b3c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102b20:	c7 44 24 08 c4 76 10 	movl   $0xc01076c4,0x8(%esp)
c0102b27:	c0 
c0102b28:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102b2f:	00 
c0102b30:	c7 04 24 8f 76 10 c0 	movl   $0xc010768f,(%esp)
c0102b37:	e8 bd d8 ff ff       	call   c01003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b44:	89 04 24             	mov    %eax,(%esp)
c0102b47:	e8 21 ff ff ff       	call   c0102a6d <pa2page>
}
c0102b4c:	c9                   	leave  
c0102b4d:	c3                   	ret    

c0102b4e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102b4e:	55                   	push   %ebp
c0102b4f:	89 e5                	mov    %esp,%ebp
c0102b51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b5c:	89 04 24             	mov    %eax,(%esp)
c0102b5f:	e8 09 ff ff ff       	call   c0102a6d <pa2page>
}
c0102b64:	c9                   	leave  
c0102b65:	c3                   	ret    

c0102b66 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102b66:	55                   	push   %ebp
c0102b67:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b6c:	8b 00                	mov    (%eax),%eax
}
c0102b6e:	5d                   	pop    %ebp
c0102b6f:	c3                   	ret    

c0102b70 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102b70:	55                   	push   %ebp
c0102b71:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b76:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b79:	89 10                	mov    %edx,(%eax)
}
c0102b7b:	90                   	nop
c0102b7c:	5d                   	pop    %ebp
c0102b7d:	c3                   	ret    

c0102b7e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102b7e:	55                   	push   %ebp
c0102b7f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b84:	8b 00                	mov    (%eax),%eax
c0102b86:	8d 50 01             	lea    0x1(%eax),%edx
c0102b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b91:	8b 00                	mov    (%eax),%eax
}
c0102b93:	5d                   	pop    %ebp
c0102b94:	c3                   	ret    

c0102b95 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b95:	55                   	push   %ebp
c0102b96:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b9b:	8b 00                	mov    (%eax),%eax
c0102b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba3:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba8:	8b 00                	mov    (%eax),%eax
}
c0102baa:	5d                   	pop    %ebp
c0102bab:	c3                   	ret    

c0102bac <__intr_save>:
__intr_save(void) {
c0102bac:	55                   	push   %ebp
c0102bad:	89 e5                	mov    %esp,%ebp
c0102baf:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102bb2:	9c                   	pushf  
c0102bb3:	58                   	pop    %eax
c0102bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102bba:	25 00 02 00 00       	and    $0x200,%eax
c0102bbf:	85 c0                	test   %eax,%eax
c0102bc1:	74 0c                	je     c0102bcf <__intr_save+0x23>
        intr_disable();
c0102bc3:	e8 d5 ec ff ff       	call   c010189d <intr_disable>
        return 1;
c0102bc8:	b8 01 00 00 00       	mov    $0x1,%eax
c0102bcd:	eb 05                	jmp    c0102bd4 <__intr_save+0x28>
    return 0;
c0102bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102bd4:	c9                   	leave  
c0102bd5:	c3                   	ret    

c0102bd6 <__intr_restore>:
__intr_restore(bool flag) {
c0102bd6:	55                   	push   %ebp
c0102bd7:	89 e5                	mov    %esp,%ebp
c0102bd9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102be0:	74 05                	je     c0102be7 <__intr_restore+0x11>
        intr_enable();
c0102be2:	e8 af ec ff ff       	call   c0101896 <intr_enable>
}
c0102be7:	90                   	nop
c0102be8:	c9                   	leave  
c0102be9:	c3                   	ret    

c0102bea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102bea:	55                   	push   %ebp
c0102beb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102bf3:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bf8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102bfa:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102c01:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102c08:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102c0f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102c16:	ea 1d 2c 10 c0 08 00 	ljmp   $0x8,$0xc0102c1d
}
c0102c1d:	90                   	nop
c0102c1e:	5d                   	pop    %ebp
c0102c1f:	c3                   	ret    

c0102c20 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102c20:	55                   	push   %ebp
c0102c21:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c26:	a3 a4 de 11 c0       	mov    %eax,0xc011dea4
}
c0102c2b:	90                   	nop
c0102c2c:	5d                   	pop    %ebp
c0102c2d:	c3                   	ret    

c0102c2e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102c2e:	55                   	push   %ebp
c0102c2f:	89 e5                	mov    %esp,%ebp
c0102c31:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102c34:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0102c39:	89 04 24             	mov    %eax,(%esp)
c0102c3c:	e8 df ff ff ff       	call   c0102c20 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102c41:	66 c7 05 a8 de 11 c0 	movw   $0x10,0xc011dea8
c0102c48:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102c4a:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0102c51:	68 00 
c0102c53:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102c58:	0f b7 c0             	movzwl %ax,%eax
c0102c5b:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0102c61:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102c66:	c1 e8 10             	shr    $0x10,%eax
c0102c69:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0102c6e:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102c75:	24 f0                	and    $0xf0,%al
c0102c77:	0c 09                	or     $0x9,%al
c0102c79:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102c7e:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102c85:	24 ef                	and    $0xef,%al
c0102c87:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102c8c:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102c93:	24 9f                	and    $0x9f,%al
c0102c95:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102c9a:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102ca1:	0c 80                	or     $0x80,%al
c0102ca3:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102ca8:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102caf:	24 f0                	and    $0xf0,%al
c0102cb1:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102cb6:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102cbd:	24 ef                	and    $0xef,%al
c0102cbf:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102cc4:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102ccb:	24 df                	and    $0xdf,%al
c0102ccd:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102cd2:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102cd9:	0c 40                	or     $0x40,%al
c0102cdb:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102ce0:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102ce7:	24 7f                	and    $0x7f,%al
c0102ce9:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102cee:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102cf3:	c1 e8 18             	shr    $0x18,%eax
c0102cf6:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102cfb:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c0102d02:	e8 e3 fe ff ff       	call   c0102bea <lgdt>
c0102d07:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102d0d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102d11:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102d14:	90                   	nop
c0102d15:	c9                   	leave  
c0102d16:	c3                   	ret    

c0102d17 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102d17:	55                   	push   %ebp
c0102d18:	89 e5                	mov    %esp,%ebp
c0102d1a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
c0102d1d:	c7 05 70 df 11 c0 40 	movl   $0xc0107e40,0xc011df70
c0102d24:	7e 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102d27:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102d2c:	8b 00                	mov    (%eax),%eax
c0102d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102d32:	c7 04 24 f0 76 10 c0 	movl   $0xc01076f0,(%esp)
c0102d39:	e8 64 d5 ff ff       	call   c01002a2 <cprintf>
    pmm_manager->init();
c0102d3e:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102d43:	8b 40 04             	mov    0x4(%eax),%eax
c0102d46:	ff d0                	call   *%eax
}
c0102d48:	90                   	nop
c0102d49:	c9                   	leave  
c0102d4a:	c3                   	ret    

c0102d4b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102d4b:	55                   	push   %ebp
c0102d4c:	89 e5                	mov    %esp,%ebp
c0102d4e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102d51:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102d56:	8b 40 08             	mov    0x8(%eax),%eax
c0102d59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d60:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d63:	89 14 24             	mov    %edx,(%esp)
c0102d66:	ff d0                	call   *%eax
}
c0102d68:	90                   	nop
c0102d69:	c9                   	leave  
c0102d6a:	c3                   	ret    

c0102d6b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102d6b:	55                   	push   %ebp
c0102d6c:	89 e5                	mov    %esp,%ebp
c0102d6e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d78:	e8 2f fe ff ff       	call   c0102bac <__intr_save>
c0102d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102d80:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102d85:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d88:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d8b:	89 14 24             	mov    %edx,(%esp)
c0102d8e:	ff d0                	call   *%eax
c0102d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d96:	89 04 24             	mov    %eax,(%esp)
c0102d99:	e8 38 fe ff ff       	call   c0102bd6 <__intr_restore>
    return page;
c0102d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102da1:	c9                   	leave  
c0102da2:	c3                   	ret    

c0102da3 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102da3:	55                   	push   %ebp
c0102da4:	89 e5                	mov    %esp,%ebp
c0102da6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102da9:	e8 fe fd ff ff       	call   c0102bac <__intr_save>
c0102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102db1:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102db6:	8b 40 10             	mov    0x10(%eax),%eax
c0102db9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102dbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102dc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0102dc3:	89 14 24             	mov    %edx,(%esp)
c0102dc6:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dcb:	89 04 24             	mov    %eax,(%esp)
c0102dce:	e8 03 fe ff ff       	call   c0102bd6 <__intr_restore>
}
c0102dd3:	90                   	nop
c0102dd4:	c9                   	leave  
c0102dd5:	c3                   	ret    

c0102dd6 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102dd6:	55                   	push   %ebp
c0102dd7:	89 e5                	mov    %esp,%ebp
c0102dd9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ddc:	e8 cb fd ff ff       	call   c0102bac <__intr_save>
c0102de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102de4:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0102de9:	8b 40 14             	mov    0x14(%eax),%eax
c0102dec:	ff d0                	call   *%eax
c0102dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df4:	89 04 24             	mov    %eax,(%esp)
c0102df7:	e8 da fd ff ff       	call   c0102bd6 <__intr_restore>
    return ret;
c0102dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102dff:	c9                   	leave  
c0102e00:	c3                   	ret    

c0102e01 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102e01:	55                   	push   %ebp
c0102e02:	89 e5                	mov    %esp,%ebp
c0102e04:	57                   	push   %edi
c0102e05:	56                   	push   %esi
c0102e06:	53                   	push   %ebx
c0102e07:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102e0d:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102e14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102e1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102e22:	c7 04 24 07 77 10 c0 	movl   $0xc0107707,(%esp)
c0102e29:	e8 74 d4 ff ff       	call   c01002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e2e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e35:	e9 22 01 00 00       	jmp    c0102f5c <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e40:	89 d0                	mov    %edx,%eax
c0102e42:	c1 e0 02             	shl    $0x2,%eax
c0102e45:	01 d0                	add    %edx,%eax
c0102e47:	c1 e0 02             	shl    $0x2,%eax
c0102e4a:	01 c8                	add    %ecx,%eax
c0102e4c:	8b 50 08             	mov    0x8(%eax),%edx
c0102e4f:	8b 40 04             	mov    0x4(%eax),%eax
c0102e52:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102e55:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e58:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e5e:	89 d0                	mov    %edx,%eax
c0102e60:	c1 e0 02             	shl    $0x2,%eax
c0102e63:	01 d0                	add    %edx,%eax
c0102e65:	c1 e0 02             	shl    $0x2,%eax
c0102e68:	01 c8                	add    %ecx,%eax
c0102e6a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e6d:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e70:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e73:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e76:	01 c8                	add    %ecx,%eax
c0102e78:	11 da                	adc    %ebx,%edx
c0102e7a:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e7d:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102e80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e83:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e86:	89 d0                	mov    %edx,%eax
c0102e88:	c1 e0 02             	shl    $0x2,%eax
c0102e8b:	01 d0                	add    %edx,%eax
c0102e8d:	c1 e0 02             	shl    $0x2,%eax
c0102e90:	01 c8                	add    %ecx,%eax
c0102e92:	83 c0 14             	add    $0x14,%eax
c0102e95:	8b 00                	mov    (%eax),%eax
c0102e97:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102e9a:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e9d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102ea0:	83 c0 ff             	add    $0xffffffff,%eax
c0102ea3:	83 d2 ff             	adc    $0xffffffff,%edx
c0102ea6:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102eac:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102eb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eb8:	89 d0                	mov    %edx,%eax
c0102eba:	c1 e0 02             	shl    $0x2,%eax
c0102ebd:	01 d0                	add    %edx,%eax
c0102ebf:	c1 e0 02             	shl    $0x2,%eax
c0102ec2:	01 c8                	add    %ecx,%eax
c0102ec4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ec7:	8b 58 10             	mov    0x10(%eax),%ebx
c0102eca:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ecd:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102ed1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102ed7:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102edd:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102ee1:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102ee5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ee8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102eef:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102ef3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102ef7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102efb:	c7 04 24 14 77 10 c0 	movl   $0xc0107714,(%esp)
c0102f02:	e8 9b d3 ff ff       	call   c01002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102f07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f0d:	89 d0                	mov    %edx,%eax
c0102f0f:	c1 e0 02             	shl    $0x2,%eax
c0102f12:	01 d0                	add    %edx,%eax
c0102f14:	c1 e0 02             	shl    $0x2,%eax
c0102f17:	01 c8                	add    %ecx,%eax
c0102f19:	83 c0 14             	add    $0x14,%eax
c0102f1c:	8b 00                	mov    (%eax),%eax
c0102f1e:	83 f8 01             	cmp    $0x1,%eax
c0102f21:	75 36                	jne    c0102f59 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0102f23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f29:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102f2c:	77 2b                	ja     c0102f59 <page_init+0x158>
c0102f2e:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102f31:	72 05                	jb     c0102f38 <page_init+0x137>
c0102f33:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102f36:	73 21                	jae    c0102f59 <page_init+0x158>
c0102f38:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102f3c:	77 1b                	ja     c0102f59 <page_init+0x158>
c0102f3e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102f42:	72 09                	jb     c0102f4d <page_init+0x14c>
c0102f44:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102f4b:	77 0c                	ja     c0102f59 <page_init+0x158>
                maxpa = end;
c0102f4d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f50:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102f53:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102f56:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f59:	ff 45 dc             	incl   -0x24(%ebp)
c0102f5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f5f:	8b 00                	mov    (%eax),%eax
c0102f61:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102f64:	0f 8c d0 fe ff ff    	jl     c0102e3a <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102f6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f6e:	72 1d                	jb     c0102f8d <page_init+0x18c>
c0102f70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f74:	77 09                	ja     c0102f7f <page_init+0x17e>
c0102f76:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102f7d:	76 0e                	jbe    c0102f8d <page_init+0x18c>
        maxpa = KMEMSIZE;
c0102f7f:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102f8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f93:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f97:	c1 ea 0c             	shr    $0xc,%edx
c0102f9a:	89 c1                	mov    %eax,%ecx
c0102f9c:	89 d3                	mov    %edx,%ebx
c0102f9e:	89 c8                	mov    %ecx,%eax
c0102fa0:	a3 80 de 11 c0       	mov    %eax,0xc011de80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102fa5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102fac:	b8 c0 49 2a c0       	mov    $0xc02a49c0,%eax
c0102fb1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102fb4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102fb7:	01 d0                	add    %edx,%eax
c0102fb9:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102fbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102fbf:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fc4:	f7 75 c0             	divl   -0x40(%ebp)
c0102fc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102fca:	29 d0                	sub    %edx,%eax
c0102fcc:	a3 78 df 11 c0       	mov    %eax,0xc011df78

    for (i = 0; i < npage; i ++) {
c0102fd1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fd8:	eb 2e                	jmp    c0103008 <page_init+0x207>
        SetPageReserved(pages + i);
c0102fda:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c0102fe0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe3:	89 d0                	mov    %edx,%eax
c0102fe5:	c1 e0 02             	shl    $0x2,%eax
c0102fe8:	01 d0                	add    %edx,%eax
c0102fea:	c1 e0 02             	shl    $0x2,%eax
c0102fed:	01 c8                	add    %ecx,%eax
c0102fef:	83 c0 04             	add    $0x4,%eax
c0102ff2:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102ff9:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ffc:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fff:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103002:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0103005:	ff 45 dc             	incl   -0x24(%ebp)
c0103008:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010300b:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103010:	39 c2                	cmp    %eax,%edx
c0103012:	72 c6                	jb     c0102fda <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103014:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c010301a:	89 d0                	mov    %edx,%eax
c010301c:	c1 e0 02             	shl    $0x2,%eax
c010301f:	01 d0                	add    %edx,%eax
c0103021:	c1 e0 02             	shl    $0x2,%eax
c0103024:	89 c2                	mov    %eax,%edx
c0103026:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c010302b:	01 d0                	add    %edx,%eax
c010302d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103030:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103037:	77 23                	ja     c010305c <page_init+0x25b>
c0103039:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010303c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103040:	c7 44 24 08 44 77 10 	movl   $0xc0107744,0x8(%esp)
c0103047:	c0 
c0103048:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010304f:	00 
c0103050:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103057:	e8 9d d3 ff ff       	call   c01003f9 <__panic>
c010305c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010305f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103064:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103067:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010306e:	e9 69 01 00 00       	jmp    c01031dc <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103073:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103076:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103079:	89 d0                	mov    %edx,%eax
c010307b:	c1 e0 02             	shl    $0x2,%eax
c010307e:	01 d0                	add    %edx,%eax
c0103080:	c1 e0 02             	shl    $0x2,%eax
c0103083:	01 c8                	add    %ecx,%eax
c0103085:	8b 50 08             	mov    0x8(%eax),%edx
c0103088:	8b 40 04             	mov    0x4(%eax),%eax
c010308b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010308e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103091:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103094:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103097:	89 d0                	mov    %edx,%eax
c0103099:	c1 e0 02             	shl    $0x2,%eax
c010309c:	01 d0                	add    %edx,%eax
c010309e:	c1 e0 02             	shl    $0x2,%eax
c01030a1:	01 c8                	add    %ecx,%eax
c01030a3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01030a6:	8b 58 10             	mov    0x10(%eax),%ebx
c01030a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030af:	01 c8                	add    %ecx,%eax
c01030b1:	11 da                	adc    %ebx,%edx
c01030b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01030b6:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01030b9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030bf:	89 d0                	mov    %edx,%eax
c01030c1:	c1 e0 02             	shl    $0x2,%eax
c01030c4:	01 d0                	add    %edx,%eax
c01030c6:	c1 e0 02             	shl    $0x2,%eax
c01030c9:	01 c8                	add    %ecx,%eax
c01030cb:	83 c0 14             	add    $0x14,%eax
c01030ce:	8b 00                	mov    (%eax),%eax
c01030d0:	83 f8 01             	cmp    $0x1,%eax
c01030d3:	0f 85 00 01 00 00    	jne    c01031d9 <page_init+0x3d8>
            if (begin < freemem) {
c01030d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01030e1:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01030e4:	77 17                	ja     c01030fd <page_init+0x2fc>
c01030e6:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01030e9:	72 05                	jb     c01030f0 <page_init+0x2ef>
c01030eb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01030ee:	73 0d                	jae    c01030fd <page_init+0x2fc>
                begin = freemem;
c01030f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030f6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01030fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103101:	72 1d                	jb     c0103120 <page_init+0x31f>
c0103103:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103107:	77 09                	ja     c0103112 <page_init+0x311>
c0103109:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103110:	76 0e                	jbe    c0103120 <page_init+0x31f>
                end = KMEMSIZE;
c0103112:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103119:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103120:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103123:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103126:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103129:	0f 87 aa 00 00 00    	ja     c01031d9 <page_init+0x3d8>
c010312f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103132:	72 09                	jb     c010313d <page_init+0x33c>
c0103134:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103137:	0f 83 9c 00 00 00    	jae    c01031d9 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c010313d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103144:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103147:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010314a:	01 d0                	add    %edx,%eax
c010314c:	48                   	dec    %eax
c010314d:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103150:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103153:	ba 00 00 00 00       	mov    $0x0,%edx
c0103158:	f7 75 b0             	divl   -0x50(%ebp)
c010315b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010315e:	29 d0                	sub    %edx,%eax
c0103160:	ba 00 00 00 00       	mov    $0x0,%edx
c0103165:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103168:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010316b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010316e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103171:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103174:	ba 00 00 00 00       	mov    $0x0,%edx
c0103179:	89 c3                	mov    %eax,%ebx
c010317b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103181:	89 de                	mov    %ebx,%esi
c0103183:	89 d0                	mov    %edx,%eax
c0103185:	83 e0 00             	and    $0x0,%eax
c0103188:	89 c7                	mov    %eax,%edi
c010318a:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010318d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103190:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103193:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103196:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103199:	77 3e                	ja     c01031d9 <page_init+0x3d8>
c010319b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010319e:	72 05                	jb     c01031a5 <page_init+0x3a4>
c01031a0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01031a3:	73 34                	jae    c01031d9 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01031a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01031ab:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01031ae:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01031b1:	89 c1                	mov    %eax,%ecx
c01031b3:	89 d3                	mov    %edx,%ebx
c01031b5:	89 c8                	mov    %ecx,%eax
c01031b7:	89 da                	mov    %ebx,%edx
c01031b9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01031bd:	c1 ea 0c             	shr    $0xc,%edx
c01031c0:	89 c3                	mov    %eax,%ebx
c01031c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031c5:	89 04 24             	mov    %eax,(%esp)
c01031c8:	e8 a0 f8 ff ff       	call   c0102a6d <pa2page>
c01031cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01031d1:	89 04 24             	mov    %eax,(%esp)
c01031d4:	e8 72 fb ff ff       	call   c0102d4b <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01031d9:	ff 45 dc             	incl   -0x24(%ebp)
c01031dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01031df:	8b 00                	mov    (%eax),%eax
c01031e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01031e4:	0f 8c 89 fe ff ff    	jl     c0103073 <page_init+0x272>
                }
            }
        }
    }
}
c01031ea:	90                   	nop
c01031eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01031f1:	5b                   	pop    %ebx
c01031f2:	5e                   	pop    %esi
c01031f3:	5f                   	pop    %edi
c01031f4:	5d                   	pop    %ebp
c01031f5:	c3                   	ret    

c01031f6 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01031f6:	55                   	push   %ebp
c01031f7:	89 e5                	mov    %esp,%ebp
c01031f9:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031ff:	33 45 14             	xor    0x14(%ebp),%eax
c0103202:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103207:	85 c0                	test   %eax,%eax
c0103209:	74 24                	je     c010322f <boot_map_segment+0x39>
c010320b:	c7 44 24 0c 76 77 10 	movl   $0xc0107776,0xc(%esp)
c0103212:	c0 
c0103213:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c010321a:	c0 
c010321b:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103222:	00 
c0103223:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010322a:	e8 ca d1 ff ff       	call   c01003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010322f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103239:	25 ff 0f 00 00       	and    $0xfff,%eax
c010323e:	89 c2                	mov    %eax,%edx
c0103240:	8b 45 10             	mov    0x10(%ebp),%eax
c0103243:	01 c2                	add    %eax,%edx
c0103245:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103248:	01 d0                	add    %edx,%eax
c010324a:	48                   	dec    %eax
c010324b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010324e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103251:	ba 00 00 00 00       	mov    $0x0,%edx
c0103256:	f7 75 f0             	divl   -0x10(%ebp)
c0103259:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010325c:	29 d0                	sub    %edx,%eax
c010325e:	c1 e8 0c             	shr    $0xc,%eax
c0103261:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103264:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103267:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010326d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103272:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103275:	8b 45 14             	mov    0x14(%ebp),%eax
c0103278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010327b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010327e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103283:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103286:	eb 68                	jmp    c01032f0 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103288:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010328f:	00 
c0103290:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103293:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103297:	8b 45 08             	mov    0x8(%ebp),%eax
c010329a:	89 04 24             	mov    %eax,(%esp)
c010329d:	e8 7c 01 00 00       	call   c010341e <get_pte>
c01032a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01032a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01032a9:	75 24                	jne    c01032cf <boot_map_segment+0xd9>
c01032ab:	c7 44 24 0c a2 77 10 	movl   $0xc01077a2,0xc(%esp)
c01032b2:	c0 
c01032b3:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01032ba:	c0 
c01032bb:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01032c2:	00 
c01032c3:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01032ca:	e8 2a d1 ff ff       	call   c01003f9 <__panic>
        *ptep = pa | PTE_P | perm;
c01032cf:	8b 45 14             	mov    0x14(%ebp),%eax
c01032d2:	0b 45 18             	or     0x18(%ebp),%eax
c01032d5:	83 c8 01             	or     $0x1,%eax
c01032d8:	89 c2                	mov    %eax,%edx
c01032da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032dd:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01032df:	ff 4d f4             	decl   -0xc(%ebp)
c01032e2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01032e9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01032f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032f4:	75 92                	jne    c0103288 <boot_map_segment+0x92>
    }
}
c01032f6:	90                   	nop
c01032f7:	c9                   	leave  
c01032f8:	c3                   	ret    

c01032f9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01032f9:	55                   	push   %ebp
c01032fa:	89 e5                	mov    %esp,%ebp
c01032fc:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01032ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103306:	e8 60 fa ff ff       	call   c0102d6b <alloc_pages>
c010330b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010330e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103312:	75 1c                	jne    c0103330 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0103314:	c7 44 24 08 af 77 10 	movl   $0xc01077af,0x8(%esp)
c010331b:	c0 
c010331c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0103323:	00 
c0103324:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010332b:	e8 c9 d0 ff ff       	call   c01003f9 <__panic>
    }
    return page2kva(p);
c0103330:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103333:	89 04 24             	mov    %eax,(%esp)
c0103336:	e8 81 f7 ff ff       	call   c0102abc <page2kva>
}
c010333b:	c9                   	leave  
c010333c:	c3                   	ret    

c010333d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010333d:	55                   	push   %ebp
c010333e:	89 e5                	mov    %esp,%ebp
c0103340:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103343:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103348:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010334b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103352:	77 23                	ja     c0103377 <pmm_init+0x3a>
c0103354:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103357:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010335b:	c7 44 24 08 44 77 10 	movl   $0xc0107744,0x8(%esp)
c0103362:	c0 
c0103363:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010336a:	00 
c010336b:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103372:	e8 82 d0 ff ff       	call   c01003f9 <__panic>
c0103377:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337a:	05 00 00 00 40       	add    $0x40000000,%eax
c010337f:	a3 74 df 11 c0       	mov    %eax,0xc011df74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103384:	e8 8e f9 ff ff       	call   c0102d17 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103389:	e8 73 fa ff ff       	call   c0102e01 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010338e:	e8 d9 03 00 00       	call   c010376c <check_alloc_page>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103393:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103398:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010339b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01033a2:	77 23                	ja     c01033c7 <pmm_init+0x8a>
c01033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01033ab:	c7 44 24 08 44 77 10 	movl   $0xc0107744,0x8(%esp)
c01033b2:	c0 
c01033b3:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01033ba:	00 
c01033bb:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01033c2:	e8 32 d0 ff ff       	call   c01003f9 <__panic>
c01033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ca:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01033d0:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01033d5:	05 ac 0f 00 00       	add    $0xfac,%eax
c01033da:	83 ca 03             	or     $0x3,%edx
c01033dd:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01033df:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01033e4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01033eb:	00 
c01033ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01033f3:	00 
c01033f4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01033fb:	38 
c01033fc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103403:	c0 
c0103404:	89 04 24             	mov    %eax,(%esp)
c0103407:	e8 ea fd ff ff       	call   c01031f6 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010340c:	e8 1d f8 ff ff       	call   c0102c2e <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103411:	e8 11 0a 00 00       	call   c0103e27 <check_boot_pgdir>

    print_pgdir();
c0103416:	e8 8a 0e 00 00       	call   c01042a5 <print_pgdir>

}
c010341b:	90                   	nop
c010341c:	c9                   	leave  
c010341d:	c3                   	ret    

c010341e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010341e:	55                   	push   %ebp
c010341f:	89 e5                	mov    %esp,%ebp
c0103421:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0103424:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103427:	c1 e8 16             	shr    $0x16,%eax
c010342a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103431:	8b 45 08             	mov    0x8(%ebp),%eax
c0103434:	01 d0                	add    %edx,%eax
c0103436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343c:	8b 00                	mov    (%eax),%eax
c010343e:	83 e0 01             	and    $0x1,%eax
c0103441:	85 c0                	test   %eax,%eax
c0103443:	0f 85 af 00 00 00    	jne    c01034f8 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0103449:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010344d:	74 15                	je     c0103464 <get_pte+0x46>
c010344f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103456:	e8 10 f9 ff ff       	call   c0102d6b <alloc_pages>
c010345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010345e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103462:	75 0a                	jne    c010346e <get_pte+0x50>
            return NULL;
c0103464:	b8 00 00 00 00       	mov    $0x0,%eax
c0103469:	e9 e7 00 00 00       	jmp    c0103555 <get_pte+0x137>
        }
        set_page_ref(page, 1);
c010346e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103475:	00 
c0103476:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103479:	89 04 24             	mov    %eax,(%esp)
c010347c:	e8 ef f6 ff ff       	call   c0102b70 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0103481:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103484:	89 04 24             	mov    %eax,(%esp)
c0103487:	e8 cb f5 ff ff       	call   c0102a57 <page2pa>
c010348c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010348f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103492:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103495:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103498:	c1 e8 0c             	shr    $0xc,%eax
c010349b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010349e:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01034a3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01034a6:	72 23                	jb     c01034cb <get_pte+0xad>
c01034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034af:	c7 44 24 08 a0 76 10 	movl   $0xc01076a0,0x8(%esp)
c01034b6:	c0 
c01034b7:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
c01034be:	00 
c01034bf:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01034c6:	e8 2e cf ff ff       	call   c01003f9 <__panic>
c01034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01034d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01034da:	00 
c01034db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01034e2:	00 
c01034e3:	89 04 24             	mov    %eax,(%esp)
c01034e6:	e8 3c 32 00 00       	call   c0106727 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01034eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ee:	83 c8 07             	or     $0x7,%eax
c01034f1:	89 c2                	mov    %eax,%edx
c01034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f6:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fb:	8b 00                	mov    (%eax),%eax
c01034fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103502:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103505:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103508:	c1 e8 0c             	shr    $0xc,%eax
c010350b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010350e:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103513:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103516:	72 23                	jb     c010353b <get_pte+0x11d>
c0103518:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010351b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010351f:	c7 44 24 08 a0 76 10 	movl   $0xc01076a0,0x8(%esp)
c0103526:	c0 
c0103527:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c010352e:	00 
c010352f:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103536:	e8 be ce ff ff       	call   c01003f9 <__panic>
c010353b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010353e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103543:	89 c2                	mov    %eax,%edx
c0103545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103548:	c1 e8 0c             	shr    $0xc,%eax
c010354b:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103550:	c1 e0 02             	shl    $0x2,%eax
c0103553:	01 d0                	add    %edx,%eax
}
c0103555:	c9                   	leave  
c0103556:	c3                   	ret    

c0103557 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103557:	55                   	push   %ebp
c0103558:	89 e5                	mov    %esp,%ebp
c010355a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010355d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103564:	00 
c0103565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010356c:	8b 45 08             	mov    0x8(%ebp),%eax
c010356f:	89 04 24             	mov    %eax,(%esp)
c0103572:	e8 a7 fe ff ff       	call   c010341e <get_pte>
c0103577:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010357a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010357e:	74 08                	je     c0103588 <get_page+0x31>
        *ptep_store = ptep;
c0103580:	8b 45 10             	mov    0x10(%ebp),%eax
c0103583:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103586:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010358c:	74 1b                	je     c01035a9 <get_page+0x52>
c010358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103591:	8b 00                	mov    (%eax),%eax
c0103593:	83 e0 01             	and    $0x1,%eax
c0103596:	85 c0                	test   %eax,%eax
c0103598:	74 0f                	je     c01035a9 <get_page+0x52>
        return pte2page(*ptep);
c010359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359d:	8b 00                	mov    (%eax),%eax
c010359f:	89 04 24             	mov    %eax,(%esp)
c01035a2:	e8 69 f5 ff ff       	call   c0102b10 <pte2page>
c01035a7:	eb 05                	jmp    c01035ae <get_page+0x57>
    }
    return NULL;
c01035a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035ae:	c9                   	leave  
c01035af:	c3                   	ret    

c01035b0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01035b0:	55                   	push   %ebp
c01035b1:	89 e5                	mov    %esp,%ebp
c01035b3:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01035b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01035b9:	8b 00                	mov    (%eax),%eax
c01035bb:	83 e0 01             	and    $0x1,%eax
c01035be:	85 c0                	test   %eax,%eax
c01035c0:	74 4d                	je     c010360f <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01035c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01035c5:	8b 00                	mov    (%eax),%eax
c01035c7:	89 04 24             	mov    %eax,(%esp)
c01035ca:	e8 41 f5 ff ff       	call   c0102b10 <pte2page>
c01035cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d5:	89 04 24             	mov    %eax,(%esp)
c01035d8:	e8 b8 f5 ff ff       	call   c0102b95 <page_ref_dec>
c01035dd:	85 c0                	test   %eax,%eax
c01035df:	75 13                	jne    c01035f4 <page_remove_pte+0x44>
            free_page(page);
c01035e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035e8:	00 
c01035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ec:	89 04 24             	mov    %eax,(%esp)
c01035ef:	e8 af f7 ff ff       	call   c0102da3 <free_pages>
        }
        *ptep = 0;
c01035f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01035f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103600:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103604:	8b 45 08             	mov    0x8(%ebp),%eax
c0103607:	89 04 24             	mov    %eax,(%esp)
c010360a:	e8 01 01 00 00       	call   c0103710 <tlb_invalidate>
    }
}
c010360f:	90                   	nop
c0103610:	c9                   	leave  
c0103611:	c3                   	ret    

c0103612 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103612:	55                   	push   %ebp
c0103613:	89 e5                	mov    %esp,%ebp
c0103615:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103618:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010361f:	00 
c0103620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103623:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103627:	8b 45 08             	mov    0x8(%ebp),%eax
c010362a:	89 04 24             	mov    %eax,(%esp)
c010362d:	e8 ec fd ff ff       	call   c010341e <get_pte>
c0103632:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103639:	74 19                	je     c0103654 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010363e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103642:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103645:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103649:	8b 45 08             	mov    0x8(%ebp),%eax
c010364c:	89 04 24             	mov    %eax,(%esp)
c010364f:	e8 5c ff ff ff       	call   c01035b0 <page_remove_pte>
    }
}
c0103654:	90                   	nop
c0103655:	c9                   	leave  
c0103656:	c3                   	ret    

c0103657 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103657:	55                   	push   %ebp
c0103658:	89 e5                	mov    %esp,%ebp
c010365a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010365d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103664:	00 
c0103665:	8b 45 10             	mov    0x10(%ebp),%eax
c0103668:	89 44 24 04          	mov    %eax,0x4(%esp)
c010366c:	8b 45 08             	mov    0x8(%ebp),%eax
c010366f:	89 04 24             	mov    %eax,(%esp)
c0103672:	e8 a7 fd ff ff       	call   c010341e <get_pte>
c0103677:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010367e:	75 0a                	jne    c010368a <page_insert+0x33>
        return -E_NO_MEM;
c0103680:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103685:	e9 84 00 00 00       	jmp    c010370e <page_insert+0xb7>
    }
    page_ref_inc(page);
c010368a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010368d:	89 04 24             	mov    %eax,(%esp)
c0103690:	e8 e9 f4 ff ff       	call   c0102b7e <page_ref_inc>
    if (*ptep & PTE_P) {
c0103695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103698:	8b 00                	mov    (%eax),%eax
c010369a:	83 e0 01             	and    $0x1,%eax
c010369d:	85 c0                	test   %eax,%eax
c010369f:	74 3e                	je     c01036df <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a4:	8b 00                	mov    (%eax),%eax
c01036a6:	89 04 24             	mov    %eax,(%esp)
c01036a9:	e8 62 f4 ff ff       	call   c0102b10 <pte2page>
c01036ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01036b7:	75 0d                	jne    c01036c6 <page_insert+0x6f>
            page_ref_dec(page);
c01036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036bc:	89 04 24             	mov    %eax,(%esp)
c01036bf:	e8 d1 f4 ff ff       	call   c0102b95 <page_ref_dec>
c01036c4:	eb 19                	jmp    c01036df <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01036c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01036cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01036d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d7:	89 04 24             	mov    %eax,(%esp)
c01036da:	e8 d1 fe ff ff       	call   c01035b0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01036df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036e2:	89 04 24             	mov    %eax,(%esp)
c01036e5:	e8 6d f3 ff ff       	call   c0102a57 <page2pa>
c01036ea:	0b 45 14             	or     0x14(%ebp),%eax
c01036ed:	83 c8 01             	or     $0x1,%eax
c01036f0:	89 c2                	mov    %eax,%edx
c01036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01036f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01036fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103701:	89 04 24             	mov    %eax,(%esp)
c0103704:	e8 07 00 00 00       	call   c0103710 <tlb_invalidate>
    return 0;
c0103709:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010370e:	c9                   	leave  
c010370f:	c3                   	ret    

c0103710 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103710:	55                   	push   %ebp
c0103711:	89 e5                	mov    %esp,%ebp
c0103713:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103716:	0f 20 d8             	mov    %cr3,%eax
c0103719:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010371c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010371f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103722:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103725:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010372c:	77 23                	ja     c0103751 <tlb_invalidate+0x41>
c010372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103731:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103735:	c7 44 24 08 44 77 10 	movl   $0xc0107744,0x8(%esp)
c010373c:	c0 
c010373d:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0103744:	00 
c0103745:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010374c:	e8 a8 cc ff ff       	call   c01003f9 <__panic>
c0103751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103754:	05 00 00 00 40       	add    $0x40000000,%eax
c0103759:	39 d0                	cmp    %edx,%eax
c010375b:	75 0c                	jne    c0103769 <tlb_invalidate+0x59>
        invlpg((void *)la);
c010375d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103760:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103763:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103766:	0f 01 38             	invlpg (%eax)
    }
}
c0103769:	90                   	nop
c010376a:	c9                   	leave  
c010376b:	c3                   	ret    

c010376c <check_alloc_page>:

static void
check_alloc_page(void) {
c010376c:	55                   	push   %ebp
c010376d:	89 e5                	mov    %esp,%ebp
c010376f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103772:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103777:	8b 40 18             	mov    0x18(%eax),%eax
c010377a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010377c:	c7 04 24 c8 77 10 c0 	movl   $0xc01077c8,(%esp)
c0103783:	e8 1a cb ff ff       	call   c01002a2 <cprintf>
}
c0103788:	90                   	nop
c0103789:	c9                   	leave  
c010378a:	c3                   	ret    

c010378b <check_pgdir>:

static void
check_pgdir(void) {
c010378b:	55                   	push   %ebp
c010378c:	89 e5                	mov    %esp,%ebp
c010378e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103791:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103796:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010379b:	76 24                	jbe    c01037c1 <check_pgdir+0x36>
c010379d:	c7 44 24 0c e7 77 10 	movl   $0xc01077e7,0xc(%esp)
c01037a4:	c0 
c01037a5:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01037ac:	c0 
c01037ad:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01037b4:	00 
c01037b5:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01037bc:	e8 38 cc ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01037c1:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01037c6:	85 c0                	test   %eax,%eax
c01037c8:	74 0e                	je     c01037d8 <check_pgdir+0x4d>
c01037ca:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01037cf:	25 ff 0f 00 00       	and    $0xfff,%eax
c01037d4:	85 c0                	test   %eax,%eax
c01037d6:	74 24                	je     c01037fc <check_pgdir+0x71>
c01037d8:	c7 44 24 0c 04 78 10 	movl   $0xc0107804,0xc(%esp)
c01037df:	c0 
c01037e0:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01037e7:	c0 
c01037e8:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01037ef:	00 
c01037f0:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01037f7:	e8 fd cb ff ff       	call   c01003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01037fc:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103801:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103808:	00 
c0103809:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103810:	00 
c0103811:	89 04 24             	mov    %eax,(%esp)
c0103814:	e8 3e fd ff ff       	call   c0103557 <get_page>
c0103819:	85 c0                	test   %eax,%eax
c010381b:	74 24                	je     c0103841 <check_pgdir+0xb6>
c010381d:	c7 44 24 0c 3c 78 10 	movl   $0xc010783c,0xc(%esp)
c0103824:	c0 
c0103825:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c010382c:	c0 
c010382d:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0103834:	00 
c0103835:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010383c:	e8 b8 cb ff ff       	call   c01003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103841:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103848:	e8 1e f5 ff ff       	call   c0102d6b <alloc_pages>
c010384d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103850:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103855:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010385c:	00 
c010385d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103864:	00 
c0103865:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103868:	89 54 24 04          	mov    %edx,0x4(%esp)
c010386c:	89 04 24             	mov    %eax,(%esp)
c010386f:	e8 e3 fd ff ff       	call   c0103657 <page_insert>
c0103874:	85 c0                	test   %eax,%eax
c0103876:	74 24                	je     c010389c <check_pgdir+0x111>
c0103878:	c7 44 24 0c 64 78 10 	movl   $0xc0107864,0xc(%esp)
c010387f:	c0 
c0103880:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103887:	c0 
c0103888:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c010388f:	00 
c0103890:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103897:	e8 5d cb ff ff       	call   c01003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010389c:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01038a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038a8:	00 
c01038a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038b0:	00 
c01038b1:	89 04 24             	mov    %eax,(%esp)
c01038b4:	e8 65 fb ff ff       	call   c010341e <get_pte>
c01038b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038c0:	75 24                	jne    c01038e6 <check_pgdir+0x15b>
c01038c2:	c7 44 24 0c 90 78 10 	movl   $0xc0107890,0xc(%esp)
c01038c9:	c0 
c01038ca:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01038d1:	c0 
c01038d2:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c01038d9:	00 
c01038da:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01038e1:	e8 13 cb ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c01038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038e9:	8b 00                	mov    (%eax),%eax
c01038eb:	89 04 24             	mov    %eax,(%esp)
c01038ee:	e8 1d f2 ff ff       	call   c0102b10 <pte2page>
c01038f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01038f6:	74 24                	je     c010391c <check_pgdir+0x191>
c01038f8:	c7 44 24 0c bd 78 10 	movl   $0xc01078bd,0xc(%esp)
c01038ff:	c0 
c0103900:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103907:	c0 
c0103908:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c010390f:	00 
c0103910:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103917:	e8 dd ca ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 1);
c010391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010391f:	89 04 24             	mov    %eax,(%esp)
c0103922:	e8 3f f2 ff ff       	call   c0102b66 <page_ref>
c0103927:	83 f8 01             	cmp    $0x1,%eax
c010392a:	74 24                	je     c0103950 <check_pgdir+0x1c5>
c010392c:	c7 44 24 0c d3 78 10 	movl   $0xc01078d3,0xc(%esp)
c0103933:	c0 
c0103934:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c010393b:	c0 
c010393c:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103943:	00 
c0103944:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010394b:	e8 a9 ca ff ff       	call   c01003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103950:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103955:	8b 00                	mov    (%eax),%eax
c0103957:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010395c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010395f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103962:	c1 e8 0c             	shr    $0xc,%eax
c0103965:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103968:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010396d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103970:	72 23                	jb     c0103995 <check_pgdir+0x20a>
c0103972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103975:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103979:	c7 44 24 08 a0 76 10 	movl   $0xc01076a0,0x8(%esp)
c0103980:	c0 
c0103981:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103988:	00 
c0103989:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103990:	e8 64 ca ff ff       	call   c01003f9 <__panic>
c0103995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103998:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010399d:	83 c0 04             	add    $0x4,%eax
c01039a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01039a3:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01039a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039af:	00 
c01039b0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01039b7:	00 
c01039b8:	89 04 24             	mov    %eax,(%esp)
c01039bb:	e8 5e fa ff ff       	call   c010341e <get_pte>
c01039c0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01039c3:	74 24                	je     c01039e9 <check_pgdir+0x25e>
c01039c5:	c7 44 24 0c e8 78 10 	movl   $0xc01078e8,0xc(%esp)
c01039cc:	c0 
c01039cd:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01039d4:	c0 
c01039d5:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c01039dc:	00 
c01039dd:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01039e4:	e8 10 ca ff ff       	call   c01003f9 <__panic>

    p2 = alloc_page();
c01039e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039f0:	e8 76 f3 ff ff       	call   c0102d6b <alloc_pages>
c01039f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01039f8:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01039fd:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103a04:	00 
c0103a05:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103a0c:	00 
c0103a0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103a10:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a14:	89 04 24             	mov    %eax,(%esp)
c0103a17:	e8 3b fc ff ff       	call   c0103657 <page_insert>
c0103a1c:	85 c0                	test   %eax,%eax
c0103a1e:	74 24                	je     c0103a44 <check_pgdir+0x2b9>
c0103a20:	c7 44 24 0c 10 79 10 	movl   $0xc0107910,0xc(%esp)
c0103a27:	c0 
c0103a28:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103a2f:	c0 
c0103a30:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103a37:	00 
c0103a38:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103a3f:	e8 b5 c9 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a44:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103a49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a50:	00 
c0103a51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a58:	00 
c0103a59:	89 04 24             	mov    %eax,(%esp)
c0103a5c:	e8 bd f9 ff ff       	call   c010341e <get_pte>
c0103a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a68:	75 24                	jne    c0103a8e <check_pgdir+0x303>
c0103a6a:	c7 44 24 0c 48 79 10 	movl   $0xc0107948,0xc(%esp)
c0103a71:	c0 
c0103a72:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103a79:	c0 
c0103a7a:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103a81:	00 
c0103a82:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103a89:	e8 6b c9 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_U);
c0103a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a91:	8b 00                	mov    (%eax),%eax
c0103a93:	83 e0 04             	and    $0x4,%eax
c0103a96:	85 c0                	test   %eax,%eax
c0103a98:	75 24                	jne    c0103abe <check_pgdir+0x333>
c0103a9a:	c7 44 24 0c 78 79 10 	movl   $0xc0107978,0xc(%esp)
c0103aa1:	c0 
c0103aa2:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103aa9:	c0 
c0103aaa:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103ab1:	00 
c0103ab2:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103ab9:	e8 3b c9 ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_W);
c0103abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac1:	8b 00                	mov    (%eax),%eax
c0103ac3:	83 e0 02             	and    $0x2,%eax
c0103ac6:	85 c0                	test   %eax,%eax
c0103ac8:	75 24                	jne    c0103aee <check_pgdir+0x363>
c0103aca:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c0103ad1:	c0 
c0103ad2:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103ad9:	c0 
c0103ada:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103ae1:	00 
c0103ae2:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103ae9:	e8 0b c9 ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103aee:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103af3:	8b 00                	mov    (%eax),%eax
c0103af5:	83 e0 04             	and    $0x4,%eax
c0103af8:	85 c0                	test   %eax,%eax
c0103afa:	75 24                	jne    c0103b20 <check_pgdir+0x395>
c0103afc:	c7 44 24 0c 94 79 10 	movl   $0xc0107994,0xc(%esp)
c0103b03:	c0 
c0103b04:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103b0b:	c0 
c0103b0c:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103b13:	00 
c0103b14:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103b1b:	e8 d9 c8 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 1);
c0103b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b23:	89 04 24             	mov    %eax,(%esp)
c0103b26:	e8 3b f0 ff ff       	call   c0102b66 <page_ref>
c0103b2b:	83 f8 01             	cmp    $0x1,%eax
c0103b2e:	74 24                	je     c0103b54 <check_pgdir+0x3c9>
c0103b30:	c7 44 24 0c aa 79 10 	movl   $0xc01079aa,0xc(%esp)
c0103b37:	c0 
c0103b38:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103b3f:	c0 
c0103b40:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103b47:	00 
c0103b48:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103b4f:	e8 a5 c8 ff ff       	call   c01003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103b54:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b59:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103b60:	00 
c0103b61:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b68:	00 
c0103b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b6c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b70:	89 04 24             	mov    %eax,(%esp)
c0103b73:	e8 df fa ff ff       	call   c0103657 <page_insert>
c0103b78:	85 c0                	test   %eax,%eax
c0103b7a:	74 24                	je     c0103ba0 <check_pgdir+0x415>
c0103b7c:	c7 44 24 0c bc 79 10 	movl   $0xc01079bc,0xc(%esp)
c0103b83:	c0 
c0103b84:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103b8b:	c0 
c0103b8c:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103b93:	00 
c0103b94:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103b9b:	e8 59 c8 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 2);
c0103ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba3:	89 04 24             	mov    %eax,(%esp)
c0103ba6:	e8 bb ef ff ff       	call   c0102b66 <page_ref>
c0103bab:	83 f8 02             	cmp    $0x2,%eax
c0103bae:	74 24                	je     c0103bd4 <check_pgdir+0x449>
c0103bb0:	c7 44 24 0c e8 79 10 	movl   $0xc01079e8,0xc(%esp)
c0103bb7:	c0 
c0103bb8:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103bbf:	c0 
c0103bc0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103bc7:	00 
c0103bc8:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103bcf:	e8 25 c8 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd7:	89 04 24             	mov    %eax,(%esp)
c0103bda:	e8 87 ef ff ff       	call   c0102b66 <page_ref>
c0103bdf:	85 c0                	test   %eax,%eax
c0103be1:	74 24                	je     c0103c07 <check_pgdir+0x47c>
c0103be3:	c7 44 24 0c fa 79 10 	movl   $0xc01079fa,0xc(%esp)
c0103bea:	c0 
c0103beb:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103bf2:	c0 
c0103bf3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103bfa:	00 
c0103bfb:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103c02:	e8 f2 c7 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103c07:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103c0c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c13:	00 
c0103c14:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c1b:	00 
c0103c1c:	89 04 24             	mov    %eax,(%esp)
c0103c1f:	e8 fa f7 ff ff       	call   c010341e <get_pte>
c0103c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c2b:	75 24                	jne    c0103c51 <check_pgdir+0x4c6>
c0103c2d:	c7 44 24 0c 48 79 10 	movl   $0xc0107948,0xc(%esp)
c0103c34:	c0 
c0103c35:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103c3c:	c0 
c0103c3d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103c44:	00 
c0103c45:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103c4c:	e8 a8 c7 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c54:	8b 00                	mov    (%eax),%eax
c0103c56:	89 04 24             	mov    %eax,(%esp)
c0103c59:	e8 b2 ee ff ff       	call   c0102b10 <pte2page>
c0103c5e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103c61:	74 24                	je     c0103c87 <check_pgdir+0x4fc>
c0103c63:	c7 44 24 0c bd 78 10 	movl   $0xc01078bd,0xc(%esp)
c0103c6a:	c0 
c0103c6b:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103c72:	c0 
c0103c73:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103c7a:	00 
c0103c7b:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103c82:	e8 72 c7 ff ff       	call   c01003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c8a:	8b 00                	mov    (%eax),%eax
c0103c8c:	83 e0 04             	and    $0x4,%eax
c0103c8f:	85 c0                	test   %eax,%eax
c0103c91:	74 24                	je     c0103cb7 <check_pgdir+0x52c>
c0103c93:	c7 44 24 0c 0c 7a 10 	movl   $0xc0107a0c,0xc(%esp)
c0103c9a:	c0 
c0103c9b:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103ca2:	c0 
c0103ca3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103caa:	00 
c0103cab:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103cb2:	e8 42 c7 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103cb7:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103cbc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103cc3:	00 
c0103cc4:	89 04 24             	mov    %eax,(%esp)
c0103cc7:	e8 46 f9 ff ff       	call   c0103612 <page_remove>
    assert(page_ref(p1) == 1);
c0103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ccf:	89 04 24             	mov    %eax,(%esp)
c0103cd2:	e8 8f ee ff ff       	call   c0102b66 <page_ref>
c0103cd7:	83 f8 01             	cmp    $0x1,%eax
c0103cda:	74 24                	je     c0103d00 <check_pgdir+0x575>
c0103cdc:	c7 44 24 0c d3 78 10 	movl   $0xc01078d3,0xc(%esp)
c0103ce3:	c0 
c0103ce4:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103ceb:	c0 
c0103cec:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103cf3:	00 
c0103cf4:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103cfb:	e8 f9 c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d03:	89 04 24             	mov    %eax,(%esp)
c0103d06:	e8 5b ee ff ff       	call   c0102b66 <page_ref>
c0103d0b:	85 c0                	test   %eax,%eax
c0103d0d:	74 24                	je     c0103d33 <check_pgdir+0x5a8>
c0103d0f:	c7 44 24 0c fa 79 10 	movl   $0xc01079fa,0xc(%esp)
c0103d16:	c0 
c0103d17:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103d1e:	c0 
c0103d1f:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103d26:	00 
c0103d27:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103d2e:	e8 c6 c6 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103d33:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d38:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d3f:	00 
c0103d40:	89 04 24             	mov    %eax,(%esp)
c0103d43:	e8 ca f8 ff ff       	call   c0103612 <page_remove>
    assert(page_ref(p1) == 0);
c0103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d4b:	89 04 24             	mov    %eax,(%esp)
c0103d4e:	e8 13 ee ff ff       	call   c0102b66 <page_ref>
c0103d53:	85 c0                	test   %eax,%eax
c0103d55:	74 24                	je     c0103d7b <check_pgdir+0x5f0>
c0103d57:	c7 44 24 0c 21 7a 10 	movl   $0xc0107a21,0xc(%esp)
c0103d5e:	c0 
c0103d5f:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103d66:	c0 
c0103d67:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103d6e:	00 
c0103d6f:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103d76:	e8 7e c6 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d7e:	89 04 24             	mov    %eax,(%esp)
c0103d81:	e8 e0 ed ff ff       	call   c0102b66 <page_ref>
c0103d86:	85 c0                	test   %eax,%eax
c0103d88:	74 24                	je     c0103dae <check_pgdir+0x623>
c0103d8a:	c7 44 24 0c fa 79 10 	movl   $0xc01079fa,0xc(%esp)
c0103d91:	c0 
c0103d92:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103d99:	c0 
c0103d9a:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103da1:	00 
c0103da2:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103da9:	e8 4b c6 ff ff       	call   c01003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103dae:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103db3:	8b 00                	mov    (%eax),%eax
c0103db5:	89 04 24             	mov    %eax,(%esp)
c0103db8:	e8 91 ed ff ff       	call   c0102b4e <pde2page>
c0103dbd:	89 04 24             	mov    %eax,(%esp)
c0103dc0:	e8 a1 ed ff ff       	call   c0102b66 <page_ref>
c0103dc5:	83 f8 01             	cmp    $0x1,%eax
c0103dc8:	74 24                	je     c0103dee <check_pgdir+0x663>
c0103dca:	c7 44 24 0c 34 7a 10 	movl   $0xc0107a34,0xc(%esp)
c0103dd1:	c0 
c0103dd2:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103dd9:	c0 
c0103dda:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0103de1:	00 
c0103de2:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103de9:	e8 0b c6 ff ff       	call   c01003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103dee:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103df3:	8b 00                	mov    (%eax),%eax
c0103df5:	89 04 24             	mov    %eax,(%esp)
c0103df8:	e8 51 ed ff ff       	call   c0102b4e <pde2page>
c0103dfd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e04:	00 
c0103e05:	89 04 24             	mov    %eax,(%esp)
c0103e08:	e8 96 ef ff ff       	call   c0102da3 <free_pages>
    boot_pgdir[0] = 0;
c0103e0d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103e18:	c7 04 24 5b 7a 10 c0 	movl   $0xc0107a5b,(%esp)
c0103e1f:	e8 7e c4 ff ff       	call   c01002a2 <cprintf>
}
c0103e24:	90                   	nop
c0103e25:	c9                   	leave  
c0103e26:	c3                   	ret    

c0103e27 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103e27:	55                   	push   %ebp
c0103e28:	89 e5                	mov    %esp,%ebp
c0103e2a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e34:	e9 ca 00 00 00       	jmp    c0103f03 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e42:	c1 e8 0c             	shr    $0xc,%eax
c0103e45:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e48:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103e4d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103e50:	72 23                	jb     c0103e75 <check_boot_pgdir+0x4e>
c0103e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e59:	c7 44 24 08 a0 76 10 	movl   $0xc01076a0,0x8(%esp)
c0103e60:	c0 
c0103e61:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103e68:	00 
c0103e69:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103e70:	e8 84 c5 ff ff       	call   c01003f9 <__panic>
c0103e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e78:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e7d:	89 c2                	mov    %eax,%edx
c0103e7f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e8b:	00 
c0103e8c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e90:	89 04 24             	mov    %eax,(%esp)
c0103e93:	e8 86 f5 ff ff       	call   c010341e <get_pte>
c0103e98:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103e9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103e9f:	75 24                	jne    c0103ec5 <check_boot_pgdir+0x9e>
c0103ea1:	c7 44 24 0c 78 7a 10 	movl   $0xc0107a78,0xc(%esp)
c0103ea8:	c0 
c0103ea9:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103eb8:	00 
c0103eb9:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103ec0:	e8 34 c5 ff ff       	call   c01003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ec8:	8b 00                	mov    (%eax),%eax
c0103eca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ecf:	89 c2                	mov    %eax,%edx
c0103ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ed4:	39 c2                	cmp    %eax,%edx
c0103ed6:	74 24                	je     c0103efc <check_boot_pgdir+0xd5>
c0103ed8:	c7 44 24 0c b5 7a 10 	movl   $0xc0107ab5,0xc(%esp)
c0103edf:	c0 
c0103ee0:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103ee7:	c0 
c0103ee8:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0103eef:	00 
c0103ef0:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103ef7:	e8 fd c4 ff ff       	call   c01003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103efc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f06:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103f0b:	39 c2                	cmp    %eax,%edx
c0103f0d:	0f 82 26 ff ff ff    	jb     c0103e39 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103f13:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103f18:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103f1d:	8b 00                	mov    (%eax),%eax
c0103f1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f24:	89 c2                	mov    %eax,%edx
c0103f26:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f2e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103f35:	77 23                	ja     c0103f5a <check_boot_pgdir+0x133>
c0103f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f3e:	c7 44 24 08 44 77 10 	movl   $0xc0107744,0x8(%esp)
c0103f45:	c0 
c0103f46:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103f4d:	00 
c0103f4e:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103f55:	e8 9f c4 ff ff       	call   c01003f9 <__panic>
c0103f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f5d:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f62:	39 d0                	cmp    %edx,%eax
c0103f64:	74 24                	je     c0103f8a <check_boot_pgdir+0x163>
c0103f66:	c7 44 24 0c cc 7a 10 	movl   $0xc0107acc,0xc(%esp)
c0103f6d:	c0 
c0103f6e:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103f75:	c0 
c0103f76:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103f7d:	00 
c0103f7e:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103f85:	e8 6f c4 ff ff       	call   c01003f9 <__panic>

    assert(boot_pgdir[0] == 0);
c0103f8a:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103f8f:	8b 00                	mov    (%eax),%eax
c0103f91:	85 c0                	test   %eax,%eax
c0103f93:	74 24                	je     c0103fb9 <check_boot_pgdir+0x192>
c0103f95:	c7 44 24 0c 00 7b 10 	movl   $0xc0107b00,0xc(%esp)
c0103f9c:	c0 
c0103f9d:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103fa4:	c0 
c0103fa5:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0103fac:	00 
c0103fad:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0103fb4:	e8 40 c4 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    p = alloc_page();
c0103fb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fc0:	e8 a6 ed ff ff       	call   c0102d6b <alloc_pages>
c0103fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103fc8:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103fcd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103fd4:	00 
c0103fd5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103fdc:	00 
c0103fdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103fe0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fe4:	89 04 24             	mov    %eax,(%esp)
c0103fe7:	e8 6b f6 ff ff       	call   c0103657 <page_insert>
c0103fec:	85 c0                	test   %eax,%eax
c0103fee:	74 24                	je     c0104014 <check_boot_pgdir+0x1ed>
c0103ff0:	c7 44 24 0c 14 7b 10 	movl   $0xc0107b14,0xc(%esp)
c0103ff7:	c0 
c0103ff8:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0103fff:	c0 
c0104000:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104007:	00 
c0104008:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010400f:	e8 e5 c3 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 1);
c0104014:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104017:	89 04 24             	mov    %eax,(%esp)
c010401a:	e8 47 eb ff ff       	call   c0102b66 <page_ref>
c010401f:	83 f8 01             	cmp    $0x1,%eax
c0104022:	74 24                	je     c0104048 <check_boot_pgdir+0x221>
c0104024:	c7 44 24 0c 42 7b 10 	movl   $0xc0107b42,0xc(%esp)
c010402b:	c0 
c010402c:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0104033:	c0 
c0104034:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c010403b:	00 
c010403c:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0104043:	e8 b1 c3 ff ff       	call   c01003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104048:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010404d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104054:	00 
c0104055:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010405c:	00 
c010405d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104060:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104064:	89 04 24             	mov    %eax,(%esp)
c0104067:	e8 eb f5 ff ff       	call   c0103657 <page_insert>
c010406c:	85 c0                	test   %eax,%eax
c010406e:	74 24                	je     c0104094 <check_boot_pgdir+0x26d>
c0104070:	c7 44 24 0c 54 7b 10 	movl   $0xc0107b54,0xc(%esp)
c0104077:	c0 
c0104078:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c010407f:	c0 
c0104080:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104087:	00 
c0104088:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c010408f:	e8 65 c3 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 2);
c0104094:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104097:	89 04 24             	mov    %eax,(%esp)
c010409a:	e8 c7 ea ff ff       	call   c0102b66 <page_ref>
c010409f:	83 f8 02             	cmp    $0x2,%eax
c01040a2:	74 24                	je     c01040c8 <check_boot_pgdir+0x2a1>
c01040a4:	c7 44 24 0c 8b 7b 10 	movl   $0xc0107b8b,0xc(%esp)
c01040ab:	c0 
c01040ac:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c01040b3:	c0 
c01040b4:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c01040bb:	00 
c01040bc:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c01040c3:	e8 31 c3 ff ff       	call   c01003f9 <__panic>

    const char *str = "ucore: Hello world!!";
c01040c8:	c7 45 e8 9c 7b 10 c0 	movl   $0xc0107b9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01040cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040d6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040dd:	e8 7b 23 00 00       	call   c010645d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01040e2:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01040e9:	00 
c01040ea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040f1:	e8 de 23 00 00       	call   c01064d4 <strcmp>
c01040f6:	85 c0                	test   %eax,%eax
c01040f8:	74 24                	je     c010411e <check_boot_pgdir+0x2f7>
c01040fa:	c7 44 24 0c b4 7b 10 	movl   $0xc0107bb4,0xc(%esp)
c0104101:	c0 
c0104102:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0104109:	c0 
c010410a:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104111:	00 
c0104112:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0104119:	e8 db c2 ff ff       	call   c01003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010411e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104121:	89 04 24             	mov    %eax,(%esp)
c0104124:	e8 93 e9 ff ff       	call   c0102abc <page2kva>
c0104129:	05 00 01 00 00       	add    $0x100,%eax
c010412e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104131:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104138:	e8 ca 22 00 00       	call   c0106407 <strlen>
c010413d:	85 c0                	test   %eax,%eax
c010413f:	74 24                	je     c0104165 <check_boot_pgdir+0x33e>
c0104141:	c7 44 24 0c ec 7b 10 	movl   $0xc0107bec,0xc(%esp)
c0104148:	c0 
c0104149:	c7 44 24 08 8d 77 10 	movl   $0xc010778d,0x8(%esp)
c0104150:	c0 
c0104151:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104158:	00 
c0104159:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0104160:	e8 94 c2 ff ff       	call   c01003f9 <__panic>

    free_page(p);
c0104165:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010416c:	00 
c010416d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104170:	89 04 24             	mov    %eax,(%esp)
c0104173:	e8 2b ec ff ff       	call   c0102da3 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104178:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010417d:	8b 00                	mov    (%eax),%eax
c010417f:	89 04 24             	mov    %eax,(%esp)
c0104182:	e8 c7 e9 ff ff       	call   c0102b4e <pde2page>
c0104187:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010418e:	00 
c010418f:	89 04 24             	mov    %eax,(%esp)
c0104192:	e8 0c ec ff ff       	call   c0102da3 <free_pages>
    boot_pgdir[0] = 0;
c0104197:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010419c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01041a2:	c7 04 24 10 7c 10 c0 	movl   $0xc0107c10,(%esp)
c01041a9:	e8 f4 c0 ff ff       	call   c01002a2 <cprintf>
}
c01041ae:	90                   	nop
c01041af:	c9                   	leave  
c01041b0:	c3                   	ret    

c01041b1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01041b1:	55                   	push   %ebp
c01041b2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01041b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01041b7:	83 e0 04             	and    $0x4,%eax
c01041ba:	85 c0                	test   %eax,%eax
c01041bc:	74 04                	je     c01041c2 <perm2str+0x11>
c01041be:	b0 75                	mov    $0x75,%al
c01041c0:	eb 02                	jmp    c01041c4 <perm2str+0x13>
c01041c2:	b0 2d                	mov    $0x2d,%al
c01041c4:	a2 08 df 11 c0       	mov    %al,0xc011df08
    str[1] = 'r';
c01041c9:	c6 05 09 df 11 c0 72 	movb   $0x72,0xc011df09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01041d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01041d3:	83 e0 02             	and    $0x2,%eax
c01041d6:	85 c0                	test   %eax,%eax
c01041d8:	74 04                	je     c01041de <perm2str+0x2d>
c01041da:	b0 77                	mov    $0x77,%al
c01041dc:	eb 02                	jmp    c01041e0 <perm2str+0x2f>
c01041de:	b0 2d                	mov    $0x2d,%al
c01041e0:	a2 0a df 11 c0       	mov    %al,0xc011df0a
    str[3] = '\0';
c01041e5:	c6 05 0b df 11 c0 00 	movb   $0x0,0xc011df0b
    return str;
c01041ec:	b8 08 df 11 c0       	mov    $0xc011df08,%eax
}
c01041f1:	5d                   	pop    %ebp
c01041f2:	c3                   	ret    

c01041f3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01041f3:	55                   	push   %ebp
c01041f4:	89 e5                	mov    %esp,%ebp
c01041f6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01041f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01041fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041ff:	72 0d                	jb     c010420e <get_pgtable_items+0x1b>
        return 0;
c0104201:	b8 00 00 00 00       	mov    $0x0,%eax
c0104206:	e9 98 00 00 00       	jmp    c01042a3 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010420b:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010420e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104211:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104214:	73 18                	jae    c010422e <get_pgtable_items+0x3b>
c0104216:	8b 45 10             	mov    0x10(%ebp),%eax
c0104219:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104220:	8b 45 14             	mov    0x14(%ebp),%eax
c0104223:	01 d0                	add    %edx,%eax
c0104225:	8b 00                	mov    (%eax),%eax
c0104227:	83 e0 01             	and    $0x1,%eax
c010422a:	85 c0                	test   %eax,%eax
c010422c:	74 dd                	je     c010420b <get_pgtable_items+0x18>
    }
    if (start < right) {
c010422e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104231:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104234:	73 68                	jae    c010429e <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104236:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010423a:	74 08                	je     c0104244 <get_pgtable_items+0x51>
            *left_store = start;
c010423c:	8b 45 18             	mov    0x18(%ebp),%eax
c010423f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104242:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104244:	8b 45 10             	mov    0x10(%ebp),%eax
c0104247:	8d 50 01             	lea    0x1(%eax),%edx
c010424a:	89 55 10             	mov    %edx,0x10(%ebp)
c010424d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104254:	8b 45 14             	mov    0x14(%ebp),%eax
c0104257:	01 d0                	add    %edx,%eax
c0104259:	8b 00                	mov    (%eax),%eax
c010425b:	83 e0 07             	and    $0x7,%eax
c010425e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104261:	eb 03                	jmp    c0104266 <get_pgtable_items+0x73>
            start ++;
c0104263:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104266:	8b 45 10             	mov    0x10(%ebp),%eax
c0104269:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010426c:	73 1d                	jae    c010428b <get_pgtable_items+0x98>
c010426e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104278:	8b 45 14             	mov    0x14(%ebp),%eax
c010427b:	01 d0                	add    %edx,%eax
c010427d:	8b 00                	mov    (%eax),%eax
c010427f:	83 e0 07             	and    $0x7,%eax
c0104282:	89 c2                	mov    %eax,%edx
c0104284:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104287:	39 c2                	cmp    %eax,%edx
c0104289:	74 d8                	je     c0104263 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c010428b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010428f:	74 08                	je     c0104299 <get_pgtable_items+0xa6>
            *right_store = start;
c0104291:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104294:	8b 55 10             	mov    0x10(%ebp),%edx
c0104297:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104299:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010429c:	eb 05                	jmp    c01042a3 <get_pgtable_items+0xb0>
    }
    return 0;
c010429e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042a3:	c9                   	leave  
c01042a4:	c3                   	ret    

c01042a5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01042a5:	55                   	push   %ebp
c01042a6:	89 e5                	mov    %esp,%ebp
c01042a8:	57                   	push   %edi
c01042a9:	56                   	push   %esi
c01042aa:	53                   	push   %ebx
c01042ab:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01042ae:	c7 04 24 30 7c 10 c0 	movl   $0xc0107c30,(%esp)
c01042b5:	e8 e8 bf ff ff       	call   c01002a2 <cprintf>
    size_t left, right = 0, perm;
c01042ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01042c1:	e9 fa 00 00 00       	jmp    c01043c0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042c9:	89 04 24             	mov    %eax,(%esp)
c01042cc:	e8 e0 fe ff ff       	call   c01041b1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01042d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01042d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042d7:	29 d1                	sub    %edx,%ecx
c01042d9:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01042db:	89 d6                	mov    %edx,%esi
c01042dd:	c1 e6 16             	shl    $0x16,%esi
c01042e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042e3:	89 d3                	mov    %edx,%ebx
c01042e5:	c1 e3 16             	shl    $0x16,%ebx
c01042e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042eb:	89 d1                	mov    %edx,%ecx
c01042ed:	c1 e1 16             	shl    $0x16,%ecx
c01042f0:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01042f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042f6:	29 d7                	sub    %edx,%edi
c01042f8:	89 fa                	mov    %edi,%edx
c01042fa:	89 44 24 14          	mov    %eax,0x14(%esp)
c01042fe:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104302:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010430a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010430e:	c7 04 24 61 7c 10 c0 	movl   $0xc0107c61,(%esp)
c0104315:	e8 88 bf ff ff       	call   c01002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010431a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010431d:	c1 e0 0a             	shl    $0xa,%eax
c0104320:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104323:	eb 54                	jmp    c0104379 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104328:	89 04 24             	mov    %eax,(%esp)
c010432b:	e8 81 fe ff ff       	call   c01041b1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104330:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104333:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104336:	29 d1                	sub    %edx,%ecx
c0104338:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010433a:	89 d6                	mov    %edx,%esi
c010433c:	c1 e6 0c             	shl    $0xc,%esi
c010433f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104342:	89 d3                	mov    %edx,%ebx
c0104344:	c1 e3 0c             	shl    $0xc,%ebx
c0104347:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010434a:	89 d1                	mov    %edx,%ecx
c010434c:	c1 e1 0c             	shl    $0xc,%ecx
c010434f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104352:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104355:	29 d7                	sub    %edx,%edi
c0104357:	89 fa                	mov    %edi,%edx
c0104359:	89 44 24 14          	mov    %eax,0x14(%esp)
c010435d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104361:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104365:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104369:	89 54 24 04          	mov    %edx,0x4(%esp)
c010436d:	c7 04 24 80 7c 10 c0 	movl   $0xc0107c80,(%esp)
c0104374:	e8 29 bf ff ff       	call   c01002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104379:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010437e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104381:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104384:	89 d3                	mov    %edx,%ebx
c0104386:	c1 e3 0a             	shl    $0xa,%ebx
c0104389:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010438c:	89 d1                	mov    %edx,%ecx
c010438e:	c1 e1 0a             	shl    $0xa,%ecx
c0104391:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104394:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104398:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010439b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010439f:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01043a3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01043ab:	89 0c 24             	mov    %ecx,(%esp)
c01043ae:	e8 40 fe ff ff       	call   c01041f3 <get_pgtable_items>
c01043b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043ba:	0f 85 65 ff ff ff    	jne    c0104325 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01043c0:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01043c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01043cb:	89 54 24 14          	mov    %edx,0x14(%esp)
c01043cf:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01043d2:	89 54 24 10          	mov    %edx,0x10(%esp)
c01043d6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01043da:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043de:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01043e5:	00 
c01043e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01043ed:	e8 01 fe ff ff       	call   c01041f3 <get_pgtable_items>
c01043f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01043f9:	0f 85 c7 fe ff ff    	jne    c01042c6 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01043ff:	c7 04 24 a4 7c 10 c0 	movl   $0xc0107ca4,(%esp)
c0104406:	e8 97 be ff ff       	call   c01002a2 <cprintf>
}
c010440b:	90                   	nop
c010440c:	83 c4 4c             	add    $0x4c,%esp
c010440f:	5b                   	pop    %ebx
c0104410:	5e                   	pop    %esi
c0104411:	5f                   	pop    %edi
c0104412:	5d                   	pop    %ebp
c0104413:	c3                   	ret    

c0104414 <page_ref>:
page_ref(struct Page *page) {
c0104414:	55                   	push   %ebp
c0104415:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104417:	8b 45 08             	mov    0x8(%ebp),%eax
c010441a:	8b 00                	mov    (%eax),%eax
}
c010441c:	5d                   	pop    %ebp
c010441d:	c3                   	ret    

c010441e <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010441e:	55                   	push   %ebp
c010441f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104421:	8b 45 08             	mov    0x8(%ebp),%eax
c0104424:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104427:	89 10                	mov    %edx,(%eax)
}
c0104429:	90                   	nop
c010442a:	5d                   	pop    %ebp
c010442b:	c3                   	ret    

c010442c <fixsize>:
#define UINT32_MASK(a)          (UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(a,1),2),4),8),16))    
//´óÓÚaµÄÒ»¸ö×îÐ¡µÄ2^k
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))//Ð¡ÓÚaµÄ×î´óµÄ2^k

static unsigned fixsize(unsigned size) {
c010442c:	55                   	push   %ebp
c010442d:	89 e5                	mov    %esp,%ebp
  size |= size >> 1;
c010442f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104432:	d1 e8                	shr    %eax
c0104434:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 2;
c0104437:	8b 45 08             	mov    0x8(%ebp),%eax
c010443a:	c1 e8 02             	shr    $0x2,%eax
c010443d:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 4;
c0104440:	8b 45 08             	mov    0x8(%ebp),%eax
c0104443:	c1 e8 04             	shr    $0x4,%eax
c0104446:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 8;
c0104449:	8b 45 08             	mov    0x8(%ebp),%eax
c010444c:	c1 e8 08             	shr    $0x8,%eax
c010444f:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 16;
c0104452:	8b 45 08             	mov    0x8(%ebp),%eax
c0104455:	c1 e8 10             	shr    $0x10,%eax
c0104458:	09 45 08             	or     %eax,0x8(%ebp)
  return size+1;
c010445b:	8b 45 08             	mov    0x8(%ebp),%eax
c010445e:	40                   	inc    %eax
}
c010445f:	5d                   	pop    %ebp
c0104460:	c3                   	ret    

c0104461 <buddy_init>:

struct allocRecord rec[80000];//´æ·ÅÆ«ÒÆÁ¿µÄÊý×é
int nr_block;//ÒÑ·ÖÅäµÄ¿éÊý

static void buddy_init()
{
c0104461:	55                   	push   %ebp
c0104462:	89 e5                	mov    %esp,%ebp
c0104464:	83 ec 10             	sub    $0x10,%esp
c0104467:	c7 45 fc a0 a3 1b c0 	movl   $0xc01ba3a0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010446e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104471:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104474:	89 50 04             	mov    %edx,0x4(%eax)
c0104477:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010447a:	8b 50 04             	mov    0x4(%eax),%edx
c010447d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104480:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free=0;
c0104482:	c7 05 a8 a3 1b c0 00 	movl   $0x0,0xc01ba3a8
c0104489:	00 00 00 
}
c010448c:	90                   	nop
c010448d:	c9                   	leave  
c010448e:	c3                   	ret    

c010448f <buddy2_new>:

//³õÊ¼»¯¶þ²æÊ÷ÉÏµÄ½Úµã
void buddy2_new( int size ) {
c010448f:	55                   	push   %ebp
c0104490:	89 e5                	mov    %esp,%ebp
c0104492:	83 ec 10             	sub    $0x10,%esp
  unsigned node_size;
  int i;
  nr_block=0;
c0104495:	c7 05 80 df 11 c0 00 	movl   $0x0,0xc011df80
c010449c:	00 00 00 
  if (size < 1 || !IS_POWER_OF_2(size))
c010449f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01044a3:	7e 55                	jle    c01044fa <buddy2_new+0x6b>
c01044a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a8:	48                   	dec    %eax
c01044a9:	23 45 08             	and    0x8(%ebp),%eax
c01044ac:	85 c0                	test   %eax,%eax
c01044ae:	75 4a                	jne    c01044fa <buddy2_new+0x6b>
    return;

  root[0].size = size;
c01044b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b3:	a3 a0 df 11 c0       	mov    %eax,0xc011dfa0
  node_size = size * 2;
c01044b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bb:	01 c0                	add    %eax,%eax
c01044bd:	89 45 fc             	mov    %eax,-0x4(%ebp)

  for (i = 0; i < 2 * size - 1; ++i) {
c01044c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01044c7:	eb 23                	jmp    c01044ec <buddy2_new+0x5d>
    if (IS_POWER_OF_2(i+1))
c01044c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01044cc:	40                   	inc    %eax
c01044cd:	23 45 f8             	and    -0x8(%ebp),%eax
c01044d0:	85 c0                	test   %eax,%eax
c01044d2:	75 08                	jne    c01044dc <buddy2_new+0x4d>
      node_size /= 2;
c01044d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044d7:	d1 e8                	shr    %eax
c01044d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    root[i].longest = node_size;
c01044dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01044df:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01044e2:	89 14 c5 a4 df 11 c0 	mov    %edx,-0x3fee205c(,%eax,8)
  for (i = 0; i < 2 * size - 1; ++i) {
c01044e9:	ff 45 f8             	incl   -0x8(%ebp)
c01044ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ef:	01 c0                	add    %eax,%eax
c01044f1:	48                   	dec    %eax
c01044f2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
c01044f5:	7c d2                	jl     c01044c9 <buddy2_new+0x3a>
  }
  return;
c01044f7:	90                   	nop
c01044f8:	eb 01                	jmp    c01044fb <buddy2_new+0x6c>
    return;
c01044fa:	90                   	nop
}
c01044fb:	c9                   	leave  
c01044fc:	c3                   	ret    

c01044fd <buddy_init_memmap>:

//³õÊ¼»¯ÄÚ´æÓ³Éä¹ØÏµ
static void
buddy_init_memmap(struct Page *base, size_t n)
{
c01044fd:	55                   	push   %ebp
c01044fe:	89 e5                	mov    %esp,%ebp
c0104500:	56                   	push   %esi
c0104501:	53                   	push   %ebx
c0104502:	83 ec 40             	sub    $0x40,%esp
    assert(n>0);
c0104505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104509:	75 24                	jne    c010452f <buddy_init_memmap+0x32>
c010450b:	c7 44 24 0c d8 7c 10 	movl   $0xc0107cd8,0xc(%esp)
c0104512:	c0 
c0104513:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c010451a:	c0 
c010451b:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
c0104522:	00 
c0104523:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c010452a:	e8 ca be ff ff       	call   c01003f9 <__panic>
    struct Page* p=base;
c010452f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;p!=base + n;p++)
c0104535:	e9 dc 00 00 00       	jmp    c0104616 <buddy_init_memmap+0x119>
    {
        assert(PageReserved(p));
c010453a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453d:	83 c0 04             	add    $0x4,%eax
c0104540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104547:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010454a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010454d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104550:	0f a3 10             	bt     %edx,(%eax)
c0104553:	19 c0                	sbb    %eax,%eax
c0104555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104558:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010455c:	0f 95 c0             	setne  %al
c010455f:	0f b6 c0             	movzbl %al,%eax
c0104562:	85 c0                	test   %eax,%eax
c0104564:	75 24                	jne    c010458a <buddy_init_memmap+0x8d>
c0104566:	c7 44 24 0c 01 7d 10 	movl   $0xc0107d01,0xc(%esp)
c010456d:	c0 
c010456e:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104575:	c0 
c0104576:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c010457d:	00 
c010457e:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104585:	e8 6f be ff ff       	call   c01003f9 <__panic>
        p->flags = 0;
c010458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 1;
c0104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104597:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
        set_page_ref(p, 0);   
c010459e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045a5:	00 
c01045a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a9:	89 04 24             	mov    %eax,(%esp)
c01045ac:	e8 6d fe ff ff       	call   c010441e <set_page_ref>
        SetPageProperty(p);
c01045b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b4:	83 c0 04             	add    $0x4,%eax
c01045b7:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c01045be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01045c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01045c7:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list,&(p->page_link));     
c01045ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045cd:	83 c0 0c             	add    $0xc,%eax
c01045d0:	c7 45 e0 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x20(%ebp)
c01045d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01045da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045dd:	8b 00                	mov    (%eax),%eax
c01045df:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045e2:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01045e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01045e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01045ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01045f4:	89 10                	mov    %edx,(%eax)
c01045f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01045f9:	8b 10                	mov    (%eax),%edx
c01045fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01045fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104601:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104604:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104607:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010460a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010460d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104610:	89 10                	mov    %edx,(%eax)
    for(;p!=base + n;p++)
c0104612:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104616:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104619:	89 d0                	mov    %edx,%eax
c010461b:	c1 e0 02             	shl    $0x2,%eax
c010461e:	01 d0                	add    %edx,%eax
c0104620:	c1 e0 02             	shl    $0x2,%eax
c0104623:	89 c2                	mov    %eax,%edx
c0104625:	8b 45 08             	mov    0x8(%ebp),%eax
c0104628:	01 d0                	add    %edx,%eax
c010462a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010462d:	0f 85 07 ff ff ff    	jne    c010453a <buddy_init_memmap+0x3d>
    }
    nr_free += n;
c0104633:	8b 15 a8 a3 1b c0    	mov    0xc01ba3a8,%edx
c0104639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010463c:	01 d0                	add    %edx,%eax
c010463e:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
    int allocpages=UINT32_ROUND_DOWN(n);
c0104643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104646:	d1 e8                	shr    %eax
c0104648:	0b 45 0c             	or     0xc(%ebp),%eax
c010464b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010464e:	d1 ea                	shr    %edx
c0104650:	0b 55 0c             	or     0xc(%ebp),%edx
c0104653:	c1 ea 02             	shr    $0x2,%edx
c0104656:	09 d0                	or     %edx,%eax
c0104658:	89 c1                	mov    %eax,%ecx
c010465a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465d:	d1 e8                	shr    %eax
c010465f:	0b 45 0c             	or     0xc(%ebp),%eax
c0104662:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104665:	d1 ea                	shr    %edx
c0104667:	0b 55 0c             	or     0xc(%ebp),%edx
c010466a:	c1 ea 02             	shr    $0x2,%edx
c010466d:	09 d0                	or     %edx,%eax
c010466f:	c1 e8 04             	shr    $0x4,%eax
c0104672:	09 c1                	or     %eax,%ecx
c0104674:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104677:	d1 e8                	shr    %eax
c0104679:	0b 45 0c             	or     0xc(%ebp),%eax
c010467c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010467f:	d1 ea                	shr    %edx
c0104681:	0b 55 0c             	or     0xc(%ebp),%edx
c0104684:	c1 ea 02             	shr    $0x2,%edx
c0104687:	09 d0                	or     %edx,%eax
c0104689:	89 c3                	mov    %eax,%ebx
c010468b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010468e:	d1 e8                	shr    %eax
c0104690:	0b 45 0c             	or     0xc(%ebp),%eax
c0104693:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104696:	d1 ea                	shr    %edx
c0104698:	0b 55 0c             	or     0xc(%ebp),%edx
c010469b:	c1 ea 02             	shr    $0x2,%edx
c010469e:	09 d0                	or     %edx,%eax
c01046a0:	c1 e8 04             	shr    $0x4,%eax
c01046a3:	09 d8                	or     %ebx,%eax
c01046a5:	c1 e8 08             	shr    $0x8,%eax
c01046a8:	09 c1                	or     %eax,%ecx
c01046aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046ad:	d1 e8                	shr    %eax
c01046af:	0b 45 0c             	or     0xc(%ebp),%eax
c01046b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046b5:	d1 ea                	shr    %edx
c01046b7:	0b 55 0c             	or     0xc(%ebp),%edx
c01046ba:	c1 ea 02             	shr    $0x2,%edx
c01046bd:	09 d0                	or     %edx,%eax
c01046bf:	89 c3                	mov    %eax,%ebx
c01046c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c4:	d1 e8                	shr    %eax
c01046c6:	0b 45 0c             	or     0xc(%ebp),%eax
c01046c9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046cc:	d1 ea                	shr    %edx
c01046ce:	0b 55 0c             	or     0xc(%ebp),%edx
c01046d1:	c1 ea 02             	shr    $0x2,%edx
c01046d4:	09 d0                	or     %edx,%eax
c01046d6:	c1 e8 04             	shr    $0x4,%eax
c01046d9:	09 c3                	or     %eax,%ebx
c01046db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046de:	d1 e8                	shr    %eax
c01046e0:	0b 45 0c             	or     0xc(%ebp),%eax
c01046e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046e6:	d1 ea                	shr    %edx
c01046e8:	0b 55 0c             	or     0xc(%ebp),%edx
c01046eb:	c1 ea 02             	shr    $0x2,%edx
c01046ee:	09 d0                	or     %edx,%eax
c01046f0:	89 c6                	mov    %eax,%esi
c01046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f5:	d1 e8                	shr    %eax
c01046f7:	0b 45 0c             	or     0xc(%ebp),%eax
c01046fa:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046fd:	d1 ea                	shr    %edx
c01046ff:	0b 55 0c             	or     0xc(%ebp),%edx
c0104702:	c1 ea 02             	shr    $0x2,%edx
c0104705:	09 d0                	or     %edx,%eax
c0104707:	c1 e8 04             	shr    $0x4,%eax
c010470a:	09 f0                	or     %esi,%eax
c010470c:	c1 e8 08             	shr    $0x8,%eax
c010470f:	09 d8                	or     %ebx,%eax
c0104711:	c1 e8 10             	shr    $0x10,%eax
c0104714:	09 c8                	or     %ecx,%eax
c0104716:	d1 e8                	shr    %eax
c0104718:	23 45 0c             	and    0xc(%ebp),%eax
c010471b:	85 c0                	test   %eax,%eax
c010471d:	0f 84 dc 00 00 00    	je     c01047ff <buddy_init_memmap+0x302>
c0104723:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104726:	d1 e8                	shr    %eax
c0104728:	0b 45 0c             	or     0xc(%ebp),%eax
c010472b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010472e:	d1 ea                	shr    %edx
c0104730:	0b 55 0c             	or     0xc(%ebp),%edx
c0104733:	c1 ea 02             	shr    $0x2,%edx
c0104736:	09 d0                	or     %edx,%eax
c0104738:	89 c1                	mov    %eax,%ecx
c010473a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010473d:	d1 e8                	shr    %eax
c010473f:	0b 45 0c             	or     0xc(%ebp),%eax
c0104742:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104745:	d1 ea                	shr    %edx
c0104747:	0b 55 0c             	or     0xc(%ebp),%edx
c010474a:	c1 ea 02             	shr    $0x2,%edx
c010474d:	09 d0                	or     %edx,%eax
c010474f:	c1 e8 04             	shr    $0x4,%eax
c0104752:	09 c1                	or     %eax,%ecx
c0104754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104757:	d1 e8                	shr    %eax
c0104759:	0b 45 0c             	or     0xc(%ebp),%eax
c010475c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010475f:	d1 ea                	shr    %edx
c0104761:	0b 55 0c             	or     0xc(%ebp),%edx
c0104764:	c1 ea 02             	shr    $0x2,%edx
c0104767:	09 d0                	or     %edx,%eax
c0104769:	89 c3                	mov    %eax,%ebx
c010476b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010476e:	d1 e8                	shr    %eax
c0104770:	0b 45 0c             	or     0xc(%ebp),%eax
c0104773:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104776:	d1 ea                	shr    %edx
c0104778:	0b 55 0c             	or     0xc(%ebp),%edx
c010477b:	c1 ea 02             	shr    $0x2,%edx
c010477e:	09 d0                	or     %edx,%eax
c0104780:	c1 e8 04             	shr    $0x4,%eax
c0104783:	09 d8                	or     %ebx,%eax
c0104785:	c1 e8 08             	shr    $0x8,%eax
c0104788:	09 c1                	or     %eax,%ecx
c010478a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010478d:	d1 e8                	shr    %eax
c010478f:	0b 45 0c             	or     0xc(%ebp),%eax
c0104792:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104795:	d1 ea                	shr    %edx
c0104797:	0b 55 0c             	or     0xc(%ebp),%edx
c010479a:	c1 ea 02             	shr    $0x2,%edx
c010479d:	09 d0                	or     %edx,%eax
c010479f:	89 c3                	mov    %eax,%ebx
c01047a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047a4:	d1 e8                	shr    %eax
c01047a6:	0b 45 0c             	or     0xc(%ebp),%eax
c01047a9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047ac:	d1 ea                	shr    %edx
c01047ae:	0b 55 0c             	or     0xc(%ebp),%edx
c01047b1:	c1 ea 02             	shr    $0x2,%edx
c01047b4:	09 d0                	or     %edx,%eax
c01047b6:	c1 e8 04             	shr    $0x4,%eax
c01047b9:	09 c3                	or     %eax,%ebx
c01047bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047be:	d1 e8                	shr    %eax
c01047c0:	0b 45 0c             	or     0xc(%ebp),%eax
c01047c3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047c6:	d1 ea                	shr    %edx
c01047c8:	0b 55 0c             	or     0xc(%ebp),%edx
c01047cb:	c1 ea 02             	shr    $0x2,%edx
c01047ce:	09 d0                	or     %edx,%eax
c01047d0:	89 c6                	mov    %eax,%esi
c01047d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d5:	d1 e8                	shr    %eax
c01047d7:	0b 45 0c             	or     0xc(%ebp),%eax
c01047da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047dd:	d1 ea                	shr    %edx
c01047df:	0b 55 0c             	or     0xc(%ebp),%edx
c01047e2:	c1 ea 02             	shr    $0x2,%edx
c01047e5:	09 d0                	or     %edx,%eax
c01047e7:	c1 e8 04             	shr    $0x4,%eax
c01047ea:	09 f0                	or     %esi,%eax
c01047ec:	c1 e8 08             	shr    $0x8,%eax
c01047ef:	09 d8                	or     %ebx,%eax
c01047f1:	c1 e8 10             	shr    $0x10,%eax
c01047f4:	09 c8                	or     %ecx,%eax
c01047f6:	d1 e8                	shr    %eax
c01047f8:	f7 d0                	not    %eax
c01047fa:	23 45 0c             	and    0xc(%ebp),%eax
c01047fd:	eb 03                	jmp    c0104802 <buddy_init_memmap+0x305>
c01047ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy2_new(allocpages);
c0104805:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104808:	89 04 24             	mov    %eax,(%esp)
c010480b:	e8 7f fc ff ff       	call   c010448f <buddy2_new>
}
c0104810:	90                   	nop
c0104811:	83 c4 40             	add    $0x40,%esp
c0104814:	5b                   	pop    %ebx
c0104815:	5e                   	pop    %esi
c0104816:	5d                   	pop    %ebp
c0104817:	c3                   	ret    

c0104818 <buddy2_alloc>:
//ÄÚ´æ·ÖÅä
int buddy2_alloc(struct buddy2* self, int size) {
c0104818:	55                   	push   %ebp
c0104819:	89 e5                	mov    %esp,%ebp
c010481b:	53                   	push   %ebx
c010481c:	83 ec 14             	sub    $0x14,%esp
  unsigned index = 0;//½ÚµãµÄ±êºÅ
c010481f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  unsigned node_size;
  unsigned offset = 0;
c0104826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if (self==NULL)//ÎÞ·¨·ÖÅä
c010482d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104831:	75 0a                	jne    c010483d <buddy2_alloc+0x25>
    return -1;
c0104833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0104838:	e9 63 01 00 00       	jmp    c01049a0 <buddy2_alloc+0x188>

  if (size <= 0)//·ÖÅä²»ºÏÀí
c010483d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104841:	7f 09                	jg     c010484c <buddy2_alloc+0x34>
    size = 1;
c0104843:	c7 45 0c 01 00 00 00 	movl   $0x1,0xc(%ebp)
c010484a:	eb 19                	jmp    c0104865 <buddy2_alloc+0x4d>
  else if (!IS_POWER_OF_2(size))//²»Îª2µÄÃÝÊ±£¬È¡±Èsize¸ü´óµÄ2µÄn´ÎÃÝ
c010484c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010484f:	48                   	dec    %eax
c0104850:	23 45 0c             	and    0xc(%ebp),%eax
c0104853:	85 c0                	test   %eax,%eax
c0104855:	74 0e                	je     c0104865 <buddy2_alloc+0x4d>
    size = fixsize(size);
c0104857:	8b 45 0c             	mov    0xc(%ebp),%eax
c010485a:	89 04 24             	mov    %eax,(%esp)
c010485d:	e8 ca fb ff ff       	call   c010442c <fixsize>
c0104862:	89 45 0c             	mov    %eax,0xc(%ebp)

  if (self[index].longest < size)//¿É·ÖÅäÄÚ´æ²»×ã
c0104865:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104868:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010486f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104872:	01 d0                	add    %edx,%eax
c0104874:	8b 50 04             	mov    0x4(%eax),%edx
c0104877:	8b 45 0c             	mov    0xc(%ebp),%eax
c010487a:	39 c2                	cmp    %eax,%edx
c010487c:	73 0a                	jae    c0104888 <buddy2_alloc+0x70>
    return -1;
c010487e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0104883:	e9 18 01 00 00       	jmp    c01049a0 <buddy2_alloc+0x188>

  for(node_size = self->size; node_size != size; node_size /= 2 ) {
c0104888:	8b 45 08             	mov    0x8(%ebp),%eax
c010488b:	8b 00                	mov    (%eax),%eax
c010488d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104890:	e9 85 00 00 00       	jmp    c010491a <buddy2_alloc+0x102>
    if (self[LEFT_LEAF(index)].longest >= size)
c0104895:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104898:	c1 e0 04             	shl    $0x4,%eax
c010489b:	8d 50 08             	lea    0x8(%eax),%edx
c010489e:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a1:	01 d0                	add    %edx,%eax
c01048a3:	8b 50 04             	mov    0x4(%eax),%edx
c01048a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048a9:	39 c2                	cmp    %eax,%edx
c01048ab:	72 5c                	jb     c0104909 <buddy2_alloc+0xf1>
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
c01048ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048b0:	40                   	inc    %eax
c01048b1:	c1 e0 04             	shl    $0x4,%eax
c01048b4:	89 c2                	mov    %eax,%edx
c01048b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01048b9:	01 d0                	add    %edx,%eax
c01048bb:	8b 50 04             	mov    0x4(%eax),%edx
c01048be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048c1:	39 c2                	cmp    %eax,%edx
c01048c3:	72 39                	jb     c01048fe <buddy2_alloc+0xe6>
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
c01048c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048c8:	c1 e0 04             	shl    $0x4,%eax
c01048cb:	8d 50 08             	lea    0x8(%eax),%edx
c01048ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d1:	01 d0                	add    %edx,%eax
c01048d3:	8b 50 04             	mov    0x4(%eax),%edx
c01048d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048d9:	40                   	inc    %eax
c01048da:	c1 e0 04             	shl    $0x4,%eax
c01048dd:	89 c1                	mov    %eax,%ecx
c01048df:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e2:	01 c8                	add    %ecx,%eax
c01048e4:	8b 40 04             	mov    0x4(%eax),%eax
c01048e7:	39 c2                	cmp    %eax,%edx
c01048e9:	77 08                	ja     c01048f3 <buddy2_alloc+0xdb>
c01048eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048ee:	01 c0                	add    %eax,%eax
c01048f0:	40                   	inc    %eax
c01048f1:	eb 06                	jmp    c01048f9 <buddy2_alloc+0xe1>
c01048f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01048f6:	40                   	inc    %eax
c01048f7:	01 c0                	add    %eax,%eax
c01048f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01048fc:	eb 14                	jmp    c0104912 <buddy2_alloc+0xfa>
         //ÕÒµ½Á½¸öÏà·ûºÏµÄ½ÚµãÖÐÄÚ´æ½ÏÐ¡µÄ½áµã
        }
       else
       {
         index=LEFT_LEAF(index);
c01048fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104901:	01 c0                	add    %eax,%eax
c0104903:	40                   	inc    %eax
c0104904:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0104907:	eb 09                	jmp    c0104912 <buddy2_alloc+0xfa>
       }  
    }
    else
      index = RIGHT_LEAF(index);
c0104909:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010490c:	40                   	inc    %eax
c010490d:	01 c0                	add    %eax,%eax
c010490f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(node_size = self->size; node_size != size; node_size /= 2 ) {
c0104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104915:	d1 e8                	shr    %eax
c0104917:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010491a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010491d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104920:	0f 85 6f ff ff ff    	jne    c0104895 <buddy2_alloc+0x7d>
  }

  self[index].longest = 0;//±ê¼Ç½ÚµãÎªÒÑÊ¹ÓÃ
c0104926:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104929:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104930:	8b 45 08             	mov    0x8(%ebp),%eax
c0104933:	01 d0                	add    %edx,%eax
c0104935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  offset = (index + 1) * node_size - self->size;
c010493c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010493f:	40                   	inc    %eax
c0104940:	0f af 45 f4          	imul   -0xc(%ebp),%eax
c0104944:	89 c2                	mov    %eax,%edx
c0104946:	8b 45 08             	mov    0x8(%ebp),%eax
c0104949:	8b 00                	mov    (%eax),%eax
c010494b:	29 c2                	sub    %eax,%edx
c010494d:	89 d0                	mov    %edx,%eax
c010494f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (index) {
c0104952:	eb 43                	jmp    c0104997 <buddy2_alloc+0x17f>
    index = PARENT(index);
c0104954:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104957:	40                   	inc    %eax
c0104958:	d1 e8                	shr    %eax
c010495a:	48                   	dec    %eax
c010495b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
c010495e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104961:	40                   	inc    %eax
c0104962:	c1 e0 04             	shl    $0x4,%eax
c0104965:	89 c2                	mov    %eax,%edx
c0104967:	8b 45 08             	mov    0x8(%ebp),%eax
c010496a:	01 d0                	add    %edx,%eax
c010496c:	8b 50 04             	mov    0x4(%eax),%edx
c010496f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104972:	c1 e0 04             	shl    $0x4,%eax
c0104975:	8d 48 08             	lea    0x8(%eax),%ecx
c0104978:	8b 45 08             	mov    0x8(%ebp),%eax
c010497b:	01 c8                	add    %ecx,%eax
c010497d:	8b 40 04             	mov    0x4(%eax),%eax
    self[index].longest = 
c0104980:	8b 4d f8             	mov    -0x8(%ebp),%ecx
c0104983:	8d 1c cd 00 00 00 00 	lea    0x0(,%ecx,8),%ebx
c010498a:	8b 4d 08             	mov    0x8(%ebp),%ecx
c010498d:	01 d9                	add    %ebx,%ecx
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
c010498f:	39 c2                	cmp    %eax,%edx
c0104991:	0f 43 c2             	cmovae %edx,%eax
    self[index].longest = 
c0104994:	89 41 04             	mov    %eax,0x4(%ecx)
  while (index) {
c0104997:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010499b:	75 b7                	jne    c0104954 <buddy2_alloc+0x13c>
  }
//ÏòÉÏË¢ÐÂ£¬ÐÞ¸ÄÏÈ×æ½áµãµÄÊýÖµ
  return offset;
c010499d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01049a0:	83 c4 14             	add    $0x14,%esp
c01049a3:	5b                   	pop    %ebx
c01049a4:	5d                   	pop    %ebp
c01049a5:	c3                   	ret    

c01049a6 <buddy_alloc_pages>:

static struct Page*
buddy_alloc_pages(size_t n){
c01049a6:	55                   	push   %ebp
c01049a7:	89 e5                	mov    %esp,%ebp
c01049a9:	53                   	push   %ebx
c01049aa:	83 ec 44             	sub    $0x44,%esp
  assert(n>0);
c01049ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049b1:	75 24                	jne    c01049d7 <buddy_alloc_pages+0x31>
c01049b3:	c7 44 24 0c d8 7c 10 	movl   $0xc0107cd8,0xc(%esp)
c01049ba:	c0 
c01049bb:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c01049c2:	c0 
c01049c3:	c7 44 24 04 8d 00 00 	movl   $0x8d,0x4(%esp)
c01049ca:	00 
c01049cb:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c01049d2:	e8 22 ba ff ff       	call   c01003f9 <__panic>
  if(n>nr_free)
c01049d7:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c01049dc:	39 45 08             	cmp    %eax,0x8(%ebp)
c01049df:	76 0a                	jbe    c01049eb <buddy_alloc_pages+0x45>
   return NULL;
c01049e1:	b8 00 00 00 00       	mov    $0x0,%eax
c01049e6:	e9 41 01 00 00       	jmp    c0104b2c <buddy_alloc_pages+0x186>
  struct Page* page=NULL;
c01049eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct Page* p;
  list_entry_t *le=&free_list,*len;
c01049f2:	c7 45 f4 a0 a3 1b c0 	movl   $0xc01ba3a0,-0xc(%ebp)
  rec[nr_block].offset=buddy2_alloc(root,n);//¼ÇÂ¼Æ«ÒÆÁ¿
c01049f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01049fc:	8b 1d 80 df 11 c0    	mov    0xc011df80,%ebx
c0104a02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a06:	c7 04 24 a0 df 11 c0 	movl   $0xc011dfa0,(%esp)
c0104a0d:	e8 06 fe ff ff       	call   c0104818 <buddy2_alloc>
c0104a12:	89 c2                	mov    %eax,%edx
c0104a14:	89 d8                	mov    %ebx,%eax
c0104a16:	01 c0                	add    %eax,%eax
c0104a18:	01 d8                	add    %ebx,%eax
c0104a1a:	c1 e0 02             	shl    $0x2,%eax
c0104a1d:	05 c4 a3 1b c0       	add    $0xc01ba3c4,%eax
c0104a22:	89 10                	mov    %edx,(%eax)
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)
c0104a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104a2b:	eb 12                	jmp    c0104a3f <buddy_alloc_pages+0x99>
c0104a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a30:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
c0104a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a36:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(le);
c0104a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<rec[nr_block].offset+1;i++)
c0104a3c:	ff 45 f0             	incl   -0x10(%ebp)
c0104a3f:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c0104a45:	89 d0                	mov    %edx,%eax
c0104a47:	01 c0                	add    %eax,%eax
c0104a49:	01 d0                	add    %edx,%eax
c0104a4b:	c1 e0 02             	shl    $0x2,%eax
c0104a4e:	05 c4 a3 1b c0       	add    $0xc01ba3c4,%eax
c0104a53:	8b 00                	mov    (%eax),%eax
c0104a55:	40                   	inc    %eax
c0104a56:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a59:	7c d2                	jl     c0104a2d <buddy_alloc_pages+0x87>
  page=le2page(le,page_link);
c0104a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a5e:	83 e8 0c             	sub    $0xc,%eax
c0104a61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int allocpages;
  if(!IS_POWER_OF_2(n))
c0104a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a67:	48                   	dec    %eax
c0104a68:	23 45 08             	and    0x8(%ebp),%eax
c0104a6b:	85 c0                	test   %eax,%eax
c0104a6d:	74 10                	je     c0104a7f <buddy_alloc_pages+0xd9>
   allocpages=fixsize(n);
c0104a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a72:	89 04 24             	mov    %eax,(%esp)
c0104a75:	e8 b2 f9 ff ff       	call   c010442c <fixsize>
c0104a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a7d:	eb 06                	jmp    c0104a85 <buddy_alloc_pages+0xdf>
  else
  {
     allocpages=n;
c0104a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  //¸ù¾ÝÐèÇónµÃµ½¿é´óÐ¡
  rec[nr_block].base=page;//¼ÇÂ¼·ÖÅä¿éÊ×Ò³
c0104a85:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c0104a8b:	89 d0                	mov    %edx,%eax
c0104a8d:	01 c0                	add    %eax,%eax
c0104a8f:	01 d0                	add    %edx,%eax
c0104a91:	c1 e0 02             	shl    $0x2,%eax
c0104a94:	8d 90 c0 a3 1b c0    	lea    -0x3fe45c40(%eax),%edx
c0104a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a9d:	89 02                	mov    %eax,(%edx)
  rec[nr_block].nr=allocpages;//¼ÇÂ¼·ÖÅäµÄÒ³Êý
c0104a9f:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c0104aa5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0104aa8:	89 d0                	mov    %edx,%eax
c0104aaa:	01 c0                	add    %eax,%eax
c0104aac:	01 d0                	add    %edx,%eax
c0104aae:	c1 e0 02             	shl    $0x2,%eax
c0104ab1:	05 c8 a3 1b c0       	add    $0xc01ba3c8,%eax
c0104ab6:	89 08                	mov    %ecx,(%eax)
  nr_block++;
c0104ab8:	a1 80 df 11 c0       	mov    0xc011df80,%eax
c0104abd:	40                   	inc    %eax
c0104abe:	a3 80 df 11 c0       	mov    %eax,0xc011df80
  for(i=0;i<allocpages;i++)
c0104ac3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104aca:	eb 3a                	jmp    c0104b06 <buddy_alloc_pages+0x160>
c0104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104acf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ad2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ad5:	8b 40 04             	mov    0x4(%eax),%eax
  {
    len=list_next(le);
c0104ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p=le2page(le,page_link);
c0104adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ade:	83 e8 0c             	sub    $0xc,%eax
c0104ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    ClearPageProperty(p);
c0104ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ae7:	83 c0 04             	add    $0x4,%eax
c0104aea:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0104af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104af7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104afa:	0f b3 10             	btr    %edx,(%eax)
    le=len;
c0104afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i=0;i<allocpages;i++)
c0104b03:	ff 45 f0             	incl   -0x10(%ebp)
c0104b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b0c:	7c be                	jl     c0104acc <buddy_alloc_pages+0x126>
  }//ÐÞ¸ÄÃ¿Ò»Ò³µÄ×´Ì¬
  nr_free-=allocpages;//¼õÈ¥ÒÑ±»·ÖÅäµÄÒ³Êý
c0104b0e:	8b 15 a8 a3 1b c0    	mov    0xc01ba3a8,%edx
c0104b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b17:	29 c2                	sub    %eax,%edx
c0104b19:	89 d0                	mov    %edx,%eax
c0104b1b:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
  page->property=n;
c0104b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b23:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b26:	89 50 08             	mov    %edx,0x8(%eax)
  return page;
c0104b29:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c0104b2c:	83 c4 44             	add    $0x44,%esp
c0104b2f:	5b                   	pop    %ebx
c0104b30:	5d                   	pop    %ebp
c0104b31:	c3                   	ret    

c0104b32 <buddy_free_pages>:

void buddy_free_pages(struct Page* base, size_t n) {
c0104b32:	55                   	push   %ebp
c0104b33:	89 e5                	mov    %esp,%ebp
c0104b35:	83 ec 58             	sub    $0x58,%esp
  unsigned node_size, index = 0;
c0104b38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
c0104b3f:	c7 45 e0 a0 df 11 c0 	movl   $0xc011dfa0,-0x20(%ebp)
c0104b46:	c7 45 c8 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x38(%ebp)
c0104b4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b50:	8b 40 04             	mov    0x4(%eax),%eax
  
  list_entry_t *le=list_next(&free_list);
c0104b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i=0;
c0104b56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(i=0;i<nr_block;i++)//ÕÒµ½¿é
c0104b5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104b64:	eb 1b                	jmp    c0104b81 <buddy_free_pages+0x4f>
  {
    if(rec[i].base==base)
c0104b66:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b69:	89 d0                	mov    %edx,%eax
c0104b6b:	01 c0                	add    %eax,%eax
c0104b6d:	01 d0                	add    %edx,%eax
c0104b6f:	c1 e0 02             	shl    $0x2,%eax
c0104b72:	05 c0 a3 1b c0       	add    $0xc01ba3c0,%eax
c0104b77:	8b 00                	mov    (%eax),%eax
c0104b79:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104b7c:	74 0f                	je     c0104b8d <buddy_free_pages+0x5b>
  for(i=0;i<nr_block;i++)//ÕÒµ½¿é
c0104b7e:	ff 45 e8             	incl   -0x18(%ebp)
c0104b81:	a1 80 df 11 c0       	mov    0xc011df80,%eax
c0104b86:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b89:	7c db                	jl     c0104b66 <buddy_free_pages+0x34>
c0104b8b:	eb 01                	jmp    c0104b8e <buddy_free_pages+0x5c>
     break;
c0104b8d:	90                   	nop
  }
  int offset=rec[i].offset;
c0104b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b91:	89 d0                	mov    %edx,%eax
c0104b93:	01 c0                	add    %eax,%eax
c0104b95:	01 d0                	add    %edx,%eax
c0104b97:	c1 e0 02             	shl    $0x2,%eax
c0104b9a:	05 c4 a3 1b c0       	add    $0xc01ba3c4,%eax
c0104b9f:	8b 00                	mov    (%eax),%eax
c0104ba1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int pos=i;//ÔÝ´æi
c0104ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ba7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  i=0;
c0104baa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  while(i<offset)
c0104bb1:	eb 12                	jmp    c0104bc5 <buddy_free_pages+0x93>
c0104bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104bbc:	8b 40 04             	mov    0x4(%eax),%eax
  {
    le=list_next(le);
c0104bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    i++;
c0104bc2:	ff 45 e8             	incl   -0x18(%ebp)
  while(i<offset)
c0104bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104bc8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104bcb:	7c e6                	jl     c0104bb3 <buddy_free_pages+0x81>
  }
  int allocpages;
  if(!IS_POWER_OF_2(n))
c0104bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bd0:	48                   	dec    %eax
c0104bd1:	23 45 0c             	and    0xc(%ebp),%eax
c0104bd4:	85 c0                	test   %eax,%eax
c0104bd6:	74 10                	je     c0104be8 <buddy_free_pages+0xb6>
   allocpages=fixsize(n);
c0104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bdb:	89 04 24             	mov    %eax,(%esp)
c0104bde:	e8 49 f8 ff ff       	call   c010442c <fixsize>
c0104be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104be6:	eb 06                	jmp    c0104bee <buddy_free_pages+0xbc>
  else
  {
     allocpages=n;
c0104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  assert(self && offset >= 0 && offset < self->size);//ÊÇ·ñºÏ·¨
c0104bee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104bf2:	74 12                	je     c0104c06 <buddy_free_pages+0xd4>
c0104bf4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104bf8:	78 0c                	js     c0104c06 <buddy_free_pages+0xd4>
c0104bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bfd:	8b 10                	mov    (%eax),%edx
c0104bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c02:	39 c2                	cmp    %eax,%edx
c0104c04:	77 24                	ja     c0104c2a <buddy_free_pages+0xf8>
c0104c06:	c7 44 24 0c 14 7d 10 	movl   $0xc0107d14,0xc(%esp)
c0104c0d:	c0 
c0104c0e:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104c15:	c0 
c0104c16:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104c1d:	00 
c0104c1e:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104c25:	e8 cf b7 ff ff       	call   c01003f9 <__panic>
  node_size = 1;
c0104c2a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  index = offset + self->size - 1;
c0104c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c34:	8b 10                	mov    (%eax),%edx
c0104c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c39:	01 d0                	add    %edx,%eax
c0104c3b:	48                   	dec    %eax
c0104c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  nr_free+=allocpages;//¸üÐÂ¿ÕÏÐÒ³µÄÊýÁ¿
c0104c3f:	8b 15 a8 a3 1b c0    	mov    0xc01ba3a8,%edx
c0104c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c48:	01 d0                	add    %edx,%eax
c0104c4a:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
  struct Page* p;
  self[index].longest = allocpages;
c0104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c52:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c5c:	01 c2                	add    %eax,%edx
c0104c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c61:	89 42 04             	mov    %eax,0x4(%edx)
  for(i=0;i<allocpages;i++)//»ØÊÕÒÑ·ÖÅäµÄÒ³
c0104c64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104c6b:	eb 48                	jmp    c0104cb5 <buddy_free_pages+0x183>
  {
     p=le2page(le,page_link);
c0104c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c70:	83 e8 0c             	sub    $0xc,%eax
c0104c73:	89 45 cc             	mov    %eax,-0x34(%ebp)
     p->flags=0;
c0104c76:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     p->property=1;
c0104c80:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
     SetPageProperty(p);
c0104c8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c8d:	83 c0 04             	add    $0x4,%eax
c0104c90:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104c97:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104c9d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ca0:	0f ab 10             	bts    %edx,(%eax)
c0104ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ca6:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104ca9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104cac:	8b 40 04             	mov    0x4(%eax),%eax
     le=list_next(le);
c0104caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(i=0;i<allocpages;i++)//»ØÊÕÒÑ·ÖÅäµÄÒ³
c0104cb2:	ff 45 e8             	incl   -0x18(%ebp)
c0104cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cb8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c0104cbb:	7c b0                	jl     c0104c6d <buddy_free_pages+0x13b>
  }
  while (index) {//ÏòÉÏºÏ²¢£¬ÐÞ¸ÄÏÈ×æ½ÚµãµÄ¼ÇÂ¼Öµ
c0104cbd:	eb 75                	jmp    c0104d34 <buddy_free_pages+0x202>
    index = PARENT(index);
c0104cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cc2:	40                   	inc    %eax
c0104cc3:	d1 e8                	shr    %eax
c0104cc5:	48                   	dec    %eax
c0104cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
c0104cc9:	d1 65 f4             	shll   -0xc(%ebp)

    left_longest = self[LEFT_LEAF(index)].longest;
c0104ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ccf:	c1 e0 04             	shl    $0x4,%eax
c0104cd2:	8d 50 08             	lea    0x8(%eax),%edx
c0104cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cd8:	01 d0                	add    %edx,%eax
c0104cda:	8b 40 04             	mov    0x4(%eax),%eax
c0104cdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    right_longest = self[RIGHT_LEAF(index)].longest;
c0104ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ce3:	40                   	inc    %eax
c0104ce4:	c1 e0 04             	shl    $0x4,%eax
c0104ce7:	89 c2                	mov    %eax,%edx
c0104ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cec:	01 d0                	add    %edx,%eax
c0104cee:	8b 40 04             	mov    0x4(%eax),%eax
c0104cf1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    
    if (left_longest + right_longest == node_size) 
c0104cf4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104cfa:	01 d0                	add    %edx,%eax
c0104cfc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104cff:	75 17                	jne    c0104d18 <buddy_free_pages+0x1e6>
      self[index].longest = node_size;
c0104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d04:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d0e:	01 c2                	add    %eax,%edx
c0104d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d13:	89 42 04             	mov    %eax,0x4(%edx)
c0104d16:	eb 1c                	jmp    c0104d34 <buddy_free_pages+0x202>
    else
      self[index].longest = MAX(left_longest, right_longest);
c0104d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d1b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d25:	01 c2                	add    %eax,%edx
c0104d27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d2a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104d2d:	0f 43 45 d0          	cmovae -0x30(%ebp),%eax
c0104d31:	89 42 04             	mov    %eax,0x4(%edx)
  while (index) {//ÏòÉÏºÏ²¢£¬ÐÞ¸ÄÏÈ×æ½ÚµãµÄ¼ÇÂ¼Öµ
c0104d34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d38:	75 85                	jne    c0104cbf <buddy_free_pages+0x18d>
  }
  for(i=pos;i<nr_block-1;i++)//Çå³ý´Ë´ÎµÄ·ÖÅä¼ÇÂ¼
c0104d3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104d3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d40:	eb 39                	jmp    c0104d7b <buddy_free_pages+0x249>
  {
    rec[i]=rec[i+1];
c0104d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d45:	8d 48 01             	lea    0x1(%eax),%ecx
c0104d48:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104d4b:	89 d0                	mov    %edx,%eax
c0104d4d:	01 c0                	add    %eax,%eax
c0104d4f:	01 d0                	add    %edx,%eax
c0104d51:	c1 e0 02             	shl    $0x2,%eax
c0104d54:	8d 90 c0 a3 1b c0    	lea    -0x3fe45c40(%eax),%edx
c0104d5a:	89 c8                	mov    %ecx,%eax
c0104d5c:	01 c0                	add    %eax,%eax
c0104d5e:	01 c8                	add    %ecx,%eax
c0104d60:	c1 e0 02             	shl    $0x2,%eax
c0104d63:	05 c0 a3 1b c0       	add    $0xc01ba3c0,%eax
c0104d68:	8b 08                	mov    (%eax),%ecx
c0104d6a:	89 0a                	mov    %ecx,(%edx)
c0104d6c:	8b 48 04             	mov    0x4(%eax),%ecx
c0104d6f:	89 4a 04             	mov    %ecx,0x4(%edx)
c0104d72:	8b 40 08             	mov    0x8(%eax),%eax
c0104d75:	89 42 08             	mov    %eax,0x8(%edx)
  for(i=pos;i<nr_block-1;i++)//Çå³ý´Ë´ÎµÄ·ÖÅä¼ÇÂ¼
c0104d78:	ff 45 e8             	incl   -0x18(%ebp)
c0104d7b:	a1 80 df 11 c0       	mov    0xc011df80,%eax
c0104d80:	48                   	dec    %eax
c0104d81:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104d84:	7c bc                	jl     c0104d42 <buddy_free_pages+0x210>
  }
  nr_block--;//¸üÐÂ·ÖÅä¿éÊýµÄÖµ
c0104d86:	a1 80 df 11 c0       	mov    0xc011df80,%eax
c0104d8b:	48                   	dec    %eax
c0104d8c:	a3 80 df 11 c0       	mov    %eax,0xc011df80
}
c0104d91:	90                   	nop
c0104d92:	c9                   	leave  
c0104d93:	c3                   	ret    

c0104d94 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c0104d94:	55                   	push   %ebp
c0104d95:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104d97:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
}
c0104d9c:	5d                   	pop    %ebp
c0104d9d:	c3                   	ret    

c0104d9e <buddy_check>:

//ÒÔÏÂÊÇÒ»¸ö²âÊÔº¯Êý
static void

buddy_check(void) {
c0104d9e:	55                   	push   %ebp
c0104d9f:	89 e5                	mov    %esp,%ebp
c0104da1:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *A, *B,*C,*D;
    p0 = A = B = C = D =NULL;
c0104da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dba:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
c0104dc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dca:	e8 9c df ff ff       	call   c0102d6b <alloc_pages>
c0104dcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104dd6:	75 24                	jne    c0104dfc <buddy_check+0x5e>
c0104dd8:	c7 44 24 0c 3f 7d 10 	movl   $0xc0107d3f,0xc(%esp)
c0104ddf:	c0 
c0104de0:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104de7:	c0 
c0104de8:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0104def:	00 
c0104df0:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104df7:	e8 fd b5 ff ff       	call   c01003f9 <__panic>
    assert((A = alloc_page()) != NULL);
c0104dfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e03:	e8 63 df ff ff       	call   c0102d6b <alloc_pages>
c0104e08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e0f:	75 24                	jne    c0104e35 <buddy_check+0x97>
c0104e11:	c7 44 24 0c 5b 7d 10 	movl   $0xc0107d5b,0xc(%esp)
c0104e18:	c0 
c0104e19:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104e20:	c0 
c0104e21:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104e28:	00 
c0104e29:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104e30:	e8 c4 b5 ff ff       	call   c01003f9 <__panic>
    assert((B = alloc_page()) != NULL);
c0104e35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e3c:	e8 2a df ff ff       	call   c0102d6b <alloc_pages>
c0104e41:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e48:	75 24                	jne    c0104e6e <buddy_check+0xd0>
c0104e4a:	c7 44 24 0c 76 7d 10 	movl   $0xc0107d76,0xc(%esp)
c0104e51:	c0 
c0104e52:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104e59:	c0 
c0104e5a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0104e61:	00 
c0104e62:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104e69:	e8 8b b5 ff ff       	call   c01003f9 <__panic>

    assert(p0 != A && p0 != B && A != B);
c0104e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e71:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0104e74:	74 10                	je     c0104e86 <buddy_check+0xe8>
c0104e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e79:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e7c:	74 08                	je     c0104e86 <buddy_check+0xe8>
c0104e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e84:	75 24                	jne    c0104eaa <buddy_check+0x10c>
c0104e86:	c7 44 24 0c 91 7d 10 	movl   $0xc0107d91,0xc(%esp)
c0104e8d:	c0 
c0104e8e:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104e95:	c0 
c0104e96:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104e9d:	00 
c0104e9e:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104ea5:	e8 4f b5 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
c0104eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ead:	89 04 24             	mov    %eax,(%esp)
c0104eb0:	e8 5f f5 ff ff       	call   c0104414 <page_ref>
c0104eb5:	85 c0                	test   %eax,%eax
c0104eb7:	75 1e                	jne    c0104ed7 <buddy_check+0x139>
c0104eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ebc:	89 04 24             	mov    %eax,(%esp)
c0104ebf:	e8 50 f5 ff ff       	call   c0104414 <page_ref>
c0104ec4:	85 c0                	test   %eax,%eax
c0104ec6:	75 0f                	jne    c0104ed7 <buddy_check+0x139>
c0104ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ecb:	89 04 24             	mov    %eax,(%esp)
c0104ece:	e8 41 f5 ff ff       	call   c0104414 <page_ref>
c0104ed3:	85 c0                	test   %eax,%eax
c0104ed5:	74 24                	je     c0104efb <buddy_check+0x15d>
c0104ed7:	c7 44 24 0c b0 7d 10 	movl   $0xc0107db0,0xc(%esp)
c0104ede:	c0 
c0104edf:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104ee6:	c0 
c0104ee7:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104eee:	00 
c0104eef:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104ef6:	e8 fe b4 ff ff       	call   c01003f9 <__panic>
    free_page(p0);
c0104efb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f02:	00 
c0104f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f06:	89 04 24             	mov    %eax,(%esp)
c0104f09:	e8 95 de ff ff       	call   c0102da3 <free_pages>
    free_page(A);
c0104f0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f15:	00 
c0104f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f19:	89 04 24             	mov    %eax,(%esp)
c0104f1c:	e8 82 de ff ff       	call   c0102da3 <free_pages>
    free_page(B);
c0104f21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f28:	00 
c0104f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f2c:	89 04 24             	mov    %eax,(%esp)
c0104f2f:	e8 6f de ff ff       	call   c0102da3 <free_pages>
    
    A=alloc_pages(500);
c0104f34:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c0104f3b:	e8 2b de ff ff       	call   c0102d6b <alloc_pages>
c0104f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(500);
c0104f43:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c0104f4a:	e8 1c de ff ff       	call   c0102d6b <alloc_pages>
c0104f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("A %p\n",A);
c0104f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f59:	c7 04 24 ea 7d 10 c0 	movl   $0xc0107dea,(%esp)
c0104f60:	e8 3d b3 ff ff       	call   c01002a2 <cprintf>
    cprintf("B %p\n",B);
c0104f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f6c:	c7 04 24 f0 7d 10 c0 	movl   $0xc0107df0,(%esp)
c0104f73:	e8 2a b3 ff ff       	call   c01002a2 <cprintf>
    free_pages(A,250);
c0104f78:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104f7f:	00 
c0104f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f83:	89 04 24             	mov    %eax,(%esp)
c0104f86:	e8 18 de ff ff       	call   c0102da3 <free_pages>
    free_pages(B,500);
c0104f8b:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104f92:	00 
c0104f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f96:	89 04 24             	mov    %eax,(%esp)
c0104f99:	e8 05 de ff ff       	call   c0102da3 <free_pages>
    free_pages(A+250,250);
c0104f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fa1:	05 88 13 00 00       	add    $0x1388,%eax
c0104fa6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104fad:	00 
c0104fae:	89 04 24             	mov    %eax,(%esp)
c0104fb1:	e8 ed dd ff ff       	call   c0102da3 <free_pages>
    
    p0=alloc_pages(1024);
c0104fb6:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
c0104fbd:	e8 a9 dd ff ff       	call   c0102d6b <alloc_pages>
c0104fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("p0 %p\n",p0);
c0104fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fcc:	c7 04 24 f6 7d 10 c0 	movl   $0xc0107df6,(%esp)
c0104fd3:	e8 ca b2 ff ff       	call   c01002a2 <cprintf>
    assert(p0 == A);
c0104fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fdb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0104fde:	74 24                	je     c0105004 <buddy_check+0x266>
c0104fe0:	c7 44 24 0c fd 7d 10 	movl   $0xc0107dfd,0xc(%esp)
c0104fe7:	c0 
c0104fe8:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0104fef:	c0 
c0104ff0:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104ff7:	00 
c0104ff8:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0104fff:	e8 f5 b3 ff ff       	call   c01003f9 <__panic>
    //ÒÔÏÂÊÇ¸ù¾ÝÁ´½ÓÖÐµÄÑùÀý²âÊÔ±àÐ´µÄ
    A=alloc_pages(70);  
c0105004:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
c010500b:	e8 5b dd ff ff       	call   c0102d6b <alloc_pages>
c0105010:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(35);
c0105013:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
c010501a:	e8 4c dd ff ff       	call   c0102d6b <alloc_pages>
c010501f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(A+128==B);//¼ì²éÊÇ·ñÏàÁÚ
c0105022:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105025:	05 00 0a 00 00       	add    $0xa00,%eax
c010502a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010502d:	74 24                	je     c0105053 <buddy_check+0x2b5>
c010502f:	c7 44 24 0c 05 7e 10 	movl   $0xc0107e05,0xc(%esp)
c0105036:	c0 
c0105037:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c010503e:	c0 
c010503f:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0105046:	00 
c0105047:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c010504e:	e8 a6 b3 ff ff       	call   c01003f9 <__panic>
    cprintf("A %p\n",A);
c0105053:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105056:	89 44 24 04          	mov    %eax,0x4(%esp)
c010505a:	c7 04 24 ea 7d 10 c0 	movl   $0xc0107dea,(%esp)
c0105061:	e8 3c b2 ff ff       	call   c01002a2 <cprintf>
    cprintf("B %p\n",B);
c0105066:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010506d:	c7 04 24 f0 7d 10 c0 	movl   $0xc0107df0,(%esp)
c0105074:	e8 29 b2 ff ff       	call   c01002a2 <cprintf>
    C=alloc_pages(80);
c0105079:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
c0105080:	e8 e6 dc ff ff       	call   c0102d6b <alloc_pages>
c0105085:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(A+256==C);//¼ì²éCÓÐÃ»ÓÐºÍAÖØµþ
c0105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010508b:	05 00 14 00 00       	add    $0x1400,%eax
c0105090:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105093:	74 24                	je     c01050b9 <buddy_check+0x31b>
c0105095:	c7 44 24 0c 0e 7e 10 	movl   $0xc0107e0e,0xc(%esp)
c010509c:	c0 
c010509d:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c01050a4:	c0 
c01050a5:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c01050ac:	00 
c01050ad:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c01050b4:	e8 40 b3 ff ff       	call   c01003f9 <__panic>
    cprintf("C %p\n",C);
c01050b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050c0:	c7 04 24 17 7e 10 c0 	movl   $0xc0107e17,(%esp)
c01050c7:	e8 d6 b1 ff ff       	call   c01002a2 <cprintf>
    free_pages(A,70);//ÊÍ·ÅA
c01050cc:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01050d3:	00 
c01050d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050d7:	89 04 24             	mov    %eax,(%esp)
c01050da:	e8 c4 dc ff ff       	call   c0102da3 <free_pages>
    cprintf("B %p\n",B);
c01050df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050e6:	c7 04 24 f0 7d 10 c0 	movl   $0xc0107df0,(%esp)
c01050ed:	e8 b0 b1 ff ff       	call   c01002a2 <cprintf>
    D=alloc_pages(60);
c01050f2:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
c01050f9:	e8 6d dc ff ff       	call   c0102d6b <alloc_pages>
c01050fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n",D);
c0105101:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105104:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105108:	c7 04 24 1d 7e 10 c0 	movl   $0xc0107e1d,(%esp)
c010510f:	e8 8e b1 ff ff       	call   c01002a2 <cprintf>
    assert(B+64==D);//¼ì²éB£¬DÊÇ·ñÏàÁÚ
c0105114:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105117:	05 00 05 00 00       	add    $0x500,%eax
c010511c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010511f:	74 24                	je     c0105145 <buddy_check+0x3a7>
c0105121:	c7 44 24 0c 23 7e 10 	movl   $0xc0107e23,0xc(%esp)
c0105128:	c0 
c0105129:	c7 44 24 08 dc 7c 10 	movl   $0xc0107cdc,0x8(%esp)
c0105130:	c0 
c0105131:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0105138:	00 
c0105139:	c7 04 24 f1 7c 10 c0 	movl   $0xc0107cf1,(%esp)
c0105140:	e8 b4 b2 ff ff       	call   c01003f9 <__panic>
    free_pages(B,35);
c0105145:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
c010514c:	00 
c010514d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105150:	89 04 24             	mov    %eax,(%esp)
c0105153:	e8 4b dc ff ff       	call   c0102da3 <free_pages>
    cprintf("D %p\n",D);
c0105158:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010515b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010515f:	c7 04 24 1d 7e 10 c0 	movl   $0xc0107e1d,(%esp)
c0105166:	e8 37 b1 ff ff       	call   c01002a2 <cprintf>
    free_pages(D,60);
c010516b:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c0105172:	00 
c0105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105176:	89 04 24             	mov    %eax,(%esp)
c0105179:	e8 25 dc ff ff       	call   c0102da3 <free_pages>
    cprintf("C %p\n",C);
c010517e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105181:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105185:	c7 04 24 17 7e 10 c0 	movl   $0xc0107e17,(%esp)
c010518c:	e8 11 b1 ff ff       	call   c01002a2 <cprintf>
    free_pages(C,80);
c0105191:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
c0105198:	00 
c0105199:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010519c:	89 04 24             	mov    %eax,(%esp)
c010519f:	e8 ff db ff ff       	call   c0102da3 <free_pages>
    free_pages(p0,1000);//È«²¿ÊÍ·Å
c01051a4:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
c01051ab:	00 
c01051ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051af:	89 04 24             	mov    %eax,(%esp)
c01051b2:	e8 ec db ff ff       	call   c0102da3 <free_pages>
}
c01051b7:	90                   	nop
c01051b8:	c9                   	leave  
c01051b9:	c3                   	ret    

c01051ba <page2ppn>:
page2ppn(struct Page *page) {
c01051ba:	55                   	push   %ebp
c01051bb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01051bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c0:	8b 15 78 df 11 c0    	mov    0xc011df78,%edx
c01051c6:	29 d0                	sub    %edx,%eax
c01051c8:	c1 f8 02             	sar    $0x2,%eax
c01051cb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01051d1:	5d                   	pop    %ebp
c01051d2:	c3                   	ret    

c01051d3 <page2pa>:
page2pa(struct Page *page) {
c01051d3:	55                   	push   %ebp
c01051d4:	89 e5                	mov    %esp,%ebp
c01051d6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01051d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051dc:	89 04 24             	mov    %eax,(%esp)
c01051df:	e8 d6 ff ff ff       	call   c01051ba <page2ppn>
c01051e4:	c1 e0 0c             	shl    $0xc,%eax
}
c01051e7:	c9                   	leave  
c01051e8:	c3                   	ret    

c01051e9 <page_ref>:
page_ref(struct Page *page) {
c01051e9:	55                   	push   %ebp
c01051ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01051ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ef:	8b 00                	mov    (%eax),%eax
}
c01051f1:	5d                   	pop    %ebp
c01051f2:	c3                   	ret    

c01051f3 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01051f3:	55                   	push   %ebp
c01051f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01051f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051fc:	89 10                	mov    %edx,(%eax)
}
c01051fe:	90                   	nop
c01051ff:	5d                   	pop    %ebp
c0105200:	c3                   	ret    

c0105201 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105201:	55                   	push   %ebp
c0105202:	89 e5                	mov    %esp,%ebp
c0105204:	83 ec 10             	sub    $0x10,%esp
c0105207:	c7 45 fc a0 a3 1b c0 	movl   $0xc01ba3a0,-0x4(%ebp)
    elm->prev = elm->next = elm;
c010520e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105211:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0105214:	89 50 04             	mov    %edx,0x4(%eax)
c0105217:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010521a:	8b 50 04             	mov    0x4(%eax),%edx
c010521d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105220:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105222:	c7 05 a8 a3 1b c0 00 	movl   $0x0,0xc01ba3a8
c0105229:	00 00 00 
}
c010522c:	90                   	nop
c010522d:	c9                   	leave  
c010522e:	c3                   	ret    

c010522f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010522f:	55                   	push   %ebp
c0105230:	89 e5                	mov    %esp,%ebp
c0105232:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0105235:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105239:	75 24                	jne    c010525f <default_init_memmap+0x30>
c010523b:	c7 44 24 0c 5c 7e 10 	movl   $0xc0107e5c,0xc(%esp)
c0105242:	c0 
c0105243:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c010524a:	c0 
c010524b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105252:	00 
c0105253:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c010525a:	e8 9a b1 ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c010525f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105262:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105265:	eb 7d                	jmp    c01052e4 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0105267:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010526a:	83 c0 04             	add    $0x4,%eax
c010526d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0105274:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105277:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010527a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010527d:	0f a3 10             	bt     %edx,(%eax)
c0105280:	19 c0                	sbb    %eax,%eax
c0105282:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0105285:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105289:	0f 95 c0             	setne  %al
c010528c:	0f b6 c0             	movzbl %al,%eax
c010528f:	85 c0                	test   %eax,%eax
c0105291:	75 24                	jne    c01052b7 <default_init_memmap+0x88>
c0105293:	c7 44 24 0c 8d 7e 10 	movl   $0xc0107e8d,0xc(%esp)
c010529a:	c0 
c010529b:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01052a2:	c0 
c01052a3:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01052aa:	00 
c01052ab:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01052b2:	e8 42 b1 ff ff       	call   c01003f9 <__panic>
        p->flags = p->property = 0;
c01052b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01052c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052c4:	8b 50 08             	mov    0x8(%eax),%edx
c01052c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ca:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01052cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052d4:	00 
c01052d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052d8:	89 04 24             	mov    %eax,(%esp)
c01052db:	e8 13 ff ff ff       	call   c01051f3 <set_page_ref>
    for (; p != base + n; p ++) {
c01052e0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01052e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01052e7:	89 d0                	mov    %edx,%eax
c01052e9:	c1 e0 02             	shl    $0x2,%eax
c01052ec:	01 d0                	add    %edx,%eax
c01052ee:	c1 e0 02             	shl    $0x2,%eax
c01052f1:	89 c2                	mov    %eax,%edx
c01052f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f6:	01 d0                	add    %edx,%eax
c01052f8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01052fb:	0f 85 66 ff ff ff    	jne    c0105267 <default_init_memmap+0x38>
    }
    base->property = n;
c0105301:	8b 45 08             	mov    0x8(%ebp),%eax
c0105304:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105307:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010530a:	8b 45 08             	mov    0x8(%ebp),%eax
c010530d:	83 c0 04             	add    $0x4,%eax
c0105310:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105317:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010531a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010531d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105320:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105323:	8b 15 a8 a3 1b c0    	mov    0xc01ba3a8,%edx
c0105329:	8b 45 0c             	mov    0xc(%ebp),%eax
c010532c:	01 d0                	add    %edx,%eax
c010532e:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
    list_add_before(&free_list, &(base->page_link));
c0105333:	8b 45 08             	mov    0x8(%ebp),%eax
c0105336:	83 c0 0c             	add    $0xc,%eax
c0105339:	c7 45 e4 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x1c(%ebp)
c0105340:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105346:	8b 00                	mov    (%eax),%eax
c0105348:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010534b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010534e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105354:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0105357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010535a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010535d:	89 10                	mov    %edx,(%eax)
c010535f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105362:	8b 10                	mov    (%eax),%edx
c0105364:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105367:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010536a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010536d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105370:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105373:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105376:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105379:	89 10                	mov    %edx,(%eax)
}
c010537b:	90                   	nop
c010537c:	c9                   	leave  
c010537d:	c3                   	ret    

c010537e <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010537e:	55                   	push   %ebp
c010537f:	89 e5                	mov    %esp,%ebp
c0105381:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0105384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105388:	75 24                	jne    c01053ae <default_alloc_pages+0x30>
c010538a:	c7 44 24 0c 5c 7e 10 	movl   $0xc0107e5c,0xc(%esp)
c0105391:	c0 
c0105392:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105399:	c0 
c010539a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01053a1:	00 
c01053a2:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01053a9:	e8 4b b0 ff ff       	call   c01003f9 <__panic>
    if (n > nr_free) {
c01053ae:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c01053b3:	39 45 08             	cmp    %eax,0x8(%ebp)
c01053b6:	76 0a                	jbe    c01053c2 <default_alloc_pages+0x44>
        return NULL;
c01053b8:	b8 00 00 00 00       	mov    $0x0,%eax
c01053bd:	e9 3d 01 00 00       	jmp    c01054ff <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c01053c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01053c9:	c7 45 f0 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01053d0:	eb 1c                	jmp    c01053ee <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01053d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d5:	83 e8 0c             	sub    $0xc,%eax
c01053d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01053db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053de:	8b 40 08             	mov    0x8(%eax),%eax
c01053e1:	39 45 08             	cmp    %eax,0x8(%ebp)
c01053e4:	77 08                	ja     c01053ee <default_alloc_pages+0x70>
            page = p;
c01053e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01053ec:	eb 18                	jmp    c0105406 <default_alloc_pages+0x88>
c01053ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01053f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053f7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01053fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053fd:	81 7d f0 a0 a3 1b c0 	cmpl   $0xc01ba3a0,-0x10(%ebp)
c0105404:	75 cc                	jne    c01053d2 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0105406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010540a:	0f 84 ec 00 00 00    	je     c01054fc <default_alloc_pages+0x17e>
        if (page->property > n) {
c0105410:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105413:	8b 40 08             	mov    0x8(%eax),%eax
c0105416:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105419:	0f 83 8c 00 00 00    	jae    c01054ab <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c010541f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105422:	89 d0                	mov    %edx,%eax
c0105424:	c1 e0 02             	shl    $0x2,%eax
c0105427:	01 d0                	add    %edx,%eax
c0105429:	c1 e0 02             	shl    $0x2,%eax
c010542c:	89 c2                	mov    %eax,%edx
c010542e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105431:	01 d0                	add    %edx,%eax
c0105433:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0105436:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105439:	8b 40 08             	mov    0x8(%eax),%eax
c010543c:	2b 45 08             	sub    0x8(%ebp),%eax
c010543f:	89 c2                	mov    %eax,%edx
c0105441:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105444:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0105447:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010544a:	83 c0 04             	add    $0x4,%eax
c010544d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0105454:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105457:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010545a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010545d:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0105460:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105463:	83 c0 0c             	add    $0xc,%eax
c0105466:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105469:	83 c2 0c             	add    $0xc,%edx
c010546c:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010546f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105472:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105475:	8b 40 04             	mov    0x4(%eax),%eax
c0105478:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010547b:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010547e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105481:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105484:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0105487:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010548a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010548d:	89 10                	mov    %edx,(%eax)
c010548f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105492:	8b 10                	mov    (%eax),%edx
c0105494:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105497:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010549a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010549d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01054a0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01054a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054a9:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01054ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054ae:	83 c0 0c             	add    $0xc,%eax
c01054b1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01054b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01054b7:	8b 40 04             	mov    0x4(%eax),%eax
c01054ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01054bd:	8b 12                	mov    (%edx),%edx
c01054bf:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01054c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01054c5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01054c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01054cb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01054ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01054d1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01054d4:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01054d6:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c01054db:	2b 45 08             	sub    0x8(%ebp),%eax
c01054de:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
        ClearPageProperty(page);
c01054e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054e6:	83 c0 04             	add    $0x4,%eax
c01054e9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01054f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01054f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01054f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01054f9:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01054fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01054ff:	c9                   	leave  
c0105500:	c3                   	ret    

c0105501 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105501:	55                   	push   %ebp
c0105502:	89 e5                	mov    %esp,%ebp
c0105504:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c010550a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010550e:	75 24                	jne    c0105534 <default_free_pages+0x33>
c0105510:	c7 44 24 0c 5c 7e 10 	movl   $0xc0107e5c,0xc(%esp)
c0105517:	c0 
c0105518:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c010551f:	c0 
c0105520:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0105527:	00 
c0105528:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c010552f:	e8 c5 ae ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c0105534:	8b 45 08             	mov    0x8(%ebp),%eax
c0105537:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010553a:	e9 9d 00 00 00       	jmp    c01055dc <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010553f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105542:	83 c0 04             	add    $0x4,%eax
c0105545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010554c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010554f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105552:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105555:	0f a3 10             	bt     %edx,(%eax)
c0105558:	19 c0                	sbb    %eax,%eax
c010555a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c010555d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105561:	0f 95 c0             	setne  %al
c0105564:	0f b6 c0             	movzbl %al,%eax
c0105567:	85 c0                	test   %eax,%eax
c0105569:	75 2c                	jne    c0105597 <default_free_pages+0x96>
c010556b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010556e:	83 c0 04             	add    $0x4,%eax
c0105571:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105578:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010557b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010557e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105581:	0f a3 10             	bt     %edx,(%eax)
c0105584:	19 c0                	sbb    %eax,%eax
c0105586:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0105589:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010558d:	0f 95 c0             	setne  %al
c0105590:	0f b6 c0             	movzbl %al,%eax
c0105593:	85 c0                	test   %eax,%eax
c0105595:	74 24                	je     c01055bb <default_free_pages+0xba>
c0105597:	c7 44 24 0c a0 7e 10 	movl   $0xc0107ea0,0xc(%esp)
c010559e:	c0 
c010559f:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01055a6:	c0 
c01055a7:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c01055ae:	00 
c01055af:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01055b6:	e8 3e ae ff ff       	call   c01003f9 <__panic>
        p->flags = 0;
c01055bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01055c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01055cc:	00 
c01055cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055d0:	89 04 24             	mov    %eax,(%esp)
c01055d3:	e8 1b fc ff ff       	call   c01051f3 <set_page_ref>
    for (; p != base + n; p ++) {
c01055d8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01055dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055df:	89 d0                	mov    %edx,%eax
c01055e1:	c1 e0 02             	shl    $0x2,%eax
c01055e4:	01 d0                	add    %edx,%eax
c01055e6:	c1 e0 02             	shl    $0x2,%eax
c01055e9:	89 c2                	mov    %eax,%edx
c01055eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ee:	01 d0                	add    %edx,%eax
c01055f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01055f3:	0f 85 46 ff ff ff    	jne    c010553f <default_free_pages+0x3e>
    }
    base->property = n;
c01055f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055ff:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105602:	8b 45 08             	mov    0x8(%ebp),%eax
c0105605:	83 c0 04             	add    $0x4,%eax
c0105608:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010560f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105612:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105615:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105618:	0f ab 10             	bts    %edx,(%eax)
c010561b:	c7 45 d4 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x2c(%ebp)
    return listelm->next;
c0105622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105625:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0105628:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010562b:	e9 08 01 00 00       	jmp    c0105738 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0105630:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105633:	83 e8 0c             	sub    $0xc,%eax
c0105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010563c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010563f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105642:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105645:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0105648:	8b 45 08             	mov    0x8(%ebp),%eax
c010564b:	8b 50 08             	mov    0x8(%eax),%edx
c010564e:	89 d0                	mov    %edx,%eax
c0105650:	c1 e0 02             	shl    $0x2,%eax
c0105653:	01 d0                	add    %edx,%eax
c0105655:	c1 e0 02             	shl    $0x2,%eax
c0105658:	89 c2                	mov    %eax,%edx
c010565a:	8b 45 08             	mov    0x8(%ebp),%eax
c010565d:	01 d0                	add    %edx,%eax
c010565f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105662:	75 5a                	jne    c01056be <default_free_pages+0x1bd>
            base->property += p->property;
c0105664:	8b 45 08             	mov    0x8(%ebp),%eax
c0105667:	8b 50 08             	mov    0x8(%eax),%edx
c010566a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010566d:	8b 40 08             	mov    0x8(%eax),%eax
c0105670:	01 c2                	add    %eax,%edx
c0105672:	8b 45 08             	mov    0x8(%ebp),%eax
c0105675:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0105678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010567b:	83 c0 04             	add    $0x4,%eax
c010567e:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0105685:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105688:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010568b:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010568e:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105694:	83 c0 0c             	add    $0xc,%eax
c0105697:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c010569a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010569d:	8b 40 04             	mov    0x4(%eax),%eax
c01056a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01056a3:	8b 12                	mov    (%edx),%edx
c01056a5:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01056a8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01056ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01056ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01056b1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01056b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01056b7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01056ba:	89 10                	mov    %edx,(%eax)
c01056bc:	eb 7a                	jmp    c0105738 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c01056be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c1:	8b 50 08             	mov    0x8(%eax),%edx
c01056c4:	89 d0                	mov    %edx,%eax
c01056c6:	c1 e0 02             	shl    $0x2,%eax
c01056c9:	01 d0                	add    %edx,%eax
c01056cb:	c1 e0 02             	shl    $0x2,%eax
c01056ce:	89 c2                	mov    %eax,%edx
c01056d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d3:	01 d0                	add    %edx,%eax
c01056d5:	39 45 08             	cmp    %eax,0x8(%ebp)
c01056d8:	75 5e                	jne    c0105738 <default_free_pages+0x237>
            p->property += base->property;
c01056da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056dd:	8b 50 08             	mov    0x8(%eax),%edx
c01056e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e3:	8b 40 08             	mov    0x8(%eax),%eax
c01056e6:	01 c2                	add    %eax,%edx
c01056e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056eb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01056ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f1:	83 c0 04             	add    $0x4,%eax
c01056f4:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c01056fb:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01056fe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105701:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105704:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010570a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010570d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105710:	83 c0 0c             	add    $0xc,%eax
c0105713:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105716:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105719:	8b 40 04             	mov    0x4(%eax),%eax
c010571c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010571f:	8b 12                	mov    (%edx),%edx
c0105721:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0105724:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0105727:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010572a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010572d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105730:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105733:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105736:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0105738:	81 7d f0 a0 a3 1b c0 	cmpl   $0xc01ba3a0,-0x10(%ebp)
c010573f:	0f 85 eb fe ff ff    	jne    c0105630 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c0105745:	8b 15 a8 a3 1b c0    	mov    0xc01ba3a8,%edx
c010574b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010574e:	01 d0                	add    %edx,%eax
c0105750:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8
c0105755:	c7 45 9c a0 a3 1b c0 	movl   $0xc01ba3a0,-0x64(%ebp)
    return listelm->next;
c010575c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010575f:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0105762:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105765:	eb 74                	jmp    c01057db <default_free_pages+0x2da>
        p = le2page(le, page_link);
c0105767:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010576a:	83 e8 0c             	sub    $0xc,%eax
c010576d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0105770:	8b 45 08             	mov    0x8(%ebp),%eax
c0105773:	8b 50 08             	mov    0x8(%eax),%edx
c0105776:	89 d0                	mov    %edx,%eax
c0105778:	c1 e0 02             	shl    $0x2,%eax
c010577b:	01 d0                	add    %edx,%eax
c010577d:	c1 e0 02             	shl    $0x2,%eax
c0105780:	89 c2                	mov    %eax,%edx
c0105782:	8b 45 08             	mov    0x8(%ebp),%eax
c0105785:	01 d0                	add    %edx,%eax
c0105787:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010578a:	72 40                	jb     c01057cc <default_free_pages+0x2cb>
            assert(base + base->property != p);
c010578c:	8b 45 08             	mov    0x8(%ebp),%eax
c010578f:	8b 50 08             	mov    0x8(%eax),%edx
c0105792:	89 d0                	mov    %edx,%eax
c0105794:	c1 e0 02             	shl    $0x2,%eax
c0105797:	01 d0                	add    %edx,%eax
c0105799:	c1 e0 02             	shl    $0x2,%eax
c010579c:	89 c2                	mov    %eax,%edx
c010579e:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a1:	01 d0                	add    %edx,%eax
c01057a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01057a6:	75 3e                	jne    c01057e6 <default_free_pages+0x2e5>
c01057a8:	c7 44 24 0c c5 7e 10 	movl   $0xc0107ec5,0xc(%esp)
c01057af:	c0 
c01057b0:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01057b7:	c0 
c01057b8:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01057bf:	00 
c01057c0:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01057c7:	e8 2d ac ff ff       	call   c01003f9 <__panic>
c01057cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057cf:	89 45 98             	mov    %eax,-0x68(%ebp)
c01057d2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01057d5:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01057d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01057db:	81 7d f0 a0 a3 1b c0 	cmpl   $0xc01ba3a0,-0x10(%ebp)
c01057e2:	75 83                	jne    c0105767 <default_free_pages+0x266>
c01057e4:	eb 01                	jmp    c01057e7 <default_free_pages+0x2e6>
            break;
c01057e6:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01057e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ea:	8d 50 0c             	lea    0xc(%eax),%edx
c01057ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f0:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01057f3:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01057f6:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01057f9:	8b 00                	mov    (%eax),%eax
c01057fb:	8b 55 90             	mov    -0x70(%ebp),%edx
c01057fe:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105801:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105804:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105807:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c010580a:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010580d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105810:	89 10                	mov    %edx,(%eax)
c0105812:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105815:	8b 10                	mov    (%eax),%edx
c0105817:	8b 45 88             	mov    -0x78(%ebp),%eax
c010581a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010581d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105820:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105823:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105826:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105829:	8b 55 88             	mov    -0x78(%ebp),%edx
c010582c:	89 10                	mov    %edx,(%eax)
}
c010582e:	90                   	nop
c010582f:	c9                   	leave  
c0105830:	c3                   	ret    

c0105831 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105831:	55                   	push   %ebp
c0105832:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105834:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
}
c0105839:	5d                   	pop    %ebp
c010583a:	c3                   	ret    

c010583b <basic_check>:

static void
basic_check(void) {
c010583b:	55                   	push   %ebp
c010583c:	89 e5                	mov    %esp,%ebp
c010583e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105841:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105848:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010584b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010584e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105851:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105854:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010585b:	e8 0b d5 ff ff       	call   c0102d6b <alloc_pages>
c0105860:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105863:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105867:	75 24                	jne    c010588d <basic_check+0x52>
c0105869:	c7 44 24 0c e0 7e 10 	movl   $0xc0107ee0,0xc(%esp)
c0105870:	c0 
c0105871:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105878:	c0 
c0105879:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0105880:	00 
c0105881:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105888:	e8 6c ab ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010588d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105894:	e8 d2 d4 ff ff       	call   c0102d6b <alloc_pages>
c0105899:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010589c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058a0:	75 24                	jne    c01058c6 <basic_check+0x8b>
c01058a2:	c7 44 24 0c fc 7e 10 	movl   $0xc0107efc,0xc(%esp)
c01058a9:	c0 
c01058aa:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01058b1:	c0 
c01058b2:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01058b9:	00 
c01058ba:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01058c1:	e8 33 ab ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01058c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058cd:	e8 99 d4 ff ff       	call   c0102d6b <alloc_pages>
c01058d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058d9:	75 24                	jne    c01058ff <basic_check+0xc4>
c01058db:	c7 44 24 0c 18 7f 10 	movl   $0xc0107f18,0xc(%esp)
c01058e2:	c0 
c01058e3:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01058ea:	c0 
c01058eb:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01058f2:	00 
c01058f3:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01058fa:	e8 fa aa ff ff       	call   c01003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01058ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105902:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105905:	74 10                	je     c0105917 <basic_check+0xdc>
c0105907:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010590a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010590d:	74 08                	je     c0105917 <basic_check+0xdc>
c010590f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105912:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105915:	75 24                	jne    c010593b <basic_check+0x100>
c0105917:	c7 44 24 0c 34 7f 10 	movl   $0xc0107f34,0xc(%esp)
c010591e:	c0 
c010591f:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105926:	c0 
c0105927:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c010592e:	00 
c010592f:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105936:	e8 be aa ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010593b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010593e:	89 04 24             	mov    %eax,(%esp)
c0105941:	e8 a3 f8 ff ff       	call   c01051e9 <page_ref>
c0105946:	85 c0                	test   %eax,%eax
c0105948:	75 1e                	jne    c0105968 <basic_check+0x12d>
c010594a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010594d:	89 04 24             	mov    %eax,(%esp)
c0105950:	e8 94 f8 ff ff       	call   c01051e9 <page_ref>
c0105955:	85 c0                	test   %eax,%eax
c0105957:	75 0f                	jne    c0105968 <basic_check+0x12d>
c0105959:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595c:	89 04 24             	mov    %eax,(%esp)
c010595f:	e8 85 f8 ff ff       	call   c01051e9 <page_ref>
c0105964:	85 c0                	test   %eax,%eax
c0105966:	74 24                	je     c010598c <basic_check+0x151>
c0105968:	c7 44 24 0c 58 7f 10 	movl   $0xc0107f58,0xc(%esp)
c010596f:	c0 
c0105970:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105977:	c0 
c0105978:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010597f:	00 
c0105980:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105987:	e8 6d aa ff ff       	call   c01003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010598c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010598f:	89 04 24             	mov    %eax,(%esp)
c0105992:	e8 3c f8 ff ff       	call   c01051d3 <page2pa>
c0105997:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c010599d:	c1 e2 0c             	shl    $0xc,%edx
c01059a0:	39 d0                	cmp    %edx,%eax
c01059a2:	72 24                	jb     c01059c8 <basic_check+0x18d>
c01059a4:	c7 44 24 0c 94 7f 10 	movl   $0xc0107f94,0xc(%esp)
c01059ab:	c0 
c01059ac:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01059b3:	c0 
c01059b4:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01059bb:	00 
c01059bc:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01059c3:	e8 31 aa ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01059c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059cb:	89 04 24             	mov    %eax,(%esp)
c01059ce:	e8 00 f8 ff ff       	call   c01051d3 <page2pa>
c01059d3:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c01059d9:	c1 e2 0c             	shl    $0xc,%edx
c01059dc:	39 d0                	cmp    %edx,%eax
c01059de:	72 24                	jb     c0105a04 <basic_check+0x1c9>
c01059e0:	c7 44 24 0c b1 7f 10 	movl   $0xc0107fb1,0xc(%esp)
c01059e7:	c0 
c01059e8:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01059ef:	c0 
c01059f0:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01059f7:	00 
c01059f8:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01059ff:	e8 f5 a9 ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a07:	89 04 24             	mov    %eax,(%esp)
c0105a0a:	e8 c4 f7 ff ff       	call   c01051d3 <page2pa>
c0105a0f:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0105a15:	c1 e2 0c             	shl    $0xc,%edx
c0105a18:	39 d0                	cmp    %edx,%eax
c0105a1a:	72 24                	jb     c0105a40 <basic_check+0x205>
c0105a1c:	c7 44 24 0c ce 7f 10 	movl   $0xc0107fce,0xc(%esp)
c0105a23:	c0 
c0105a24:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105a2b:	c0 
c0105a2c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105a33:	00 
c0105a34:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105a3b:	e8 b9 a9 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c0105a40:	a1 a0 a3 1b c0       	mov    0xc01ba3a0,%eax
c0105a45:	8b 15 a4 a3 1b c0    	mov    0xc01ba3a4,%edx
c0105a4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105a4e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105a51:	c7 45 dc a0 a3 1b c0 	movl   $0xc01ba3a0,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105a5e:	89 50 04             	mov    %edx,0x4(%eax)
c0105a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a64:	8b 50 04             	mov    0x4(%eax),%edx
c0105a67:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a6a:	89 10                	mov    %edx,(%eax)
c0105a6c:	c7 45 e0 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x20(%ebp)
    return list->next == list;
c0105a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a76:	8b 40 04             	mov    0x4(%eax),%eax
c0105a79:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105a7c:	0f 94 c0             	sete   %al
c0105a7f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105a82:	85 c0                	test   %eax,%eax
c0105a84:	75 24                	jne    c0105aaa <basic_check+0x26f>
c0105a86:	c7 44 24 0c eb 7f 10 	movl   $0xc0107feb,0xc(%esp)
c0105a8d:	c0 
c0105a8e:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105a95:	c0 
c0105a96:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0105a9d:	00 
c0105a9e:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105aa5:	e8 4f a9 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105aaa:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c0105aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105ab2:	c7 05 a8 a3 1b c0 00 	movl   $0x0,0xc01ba3a8
c0105ab9:	00 00 00 

    assert(alloc_page() == NULL);
c0105abc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ac3:	e8 a3 d2 ff ff       	call   c0102d6b <alloc_pages>
c0105ac8:	85 c0                	test   %eax,%eax
c0105aca:	74 24                	je     c0105af0 <basic_check+0x2b5>
c0105acc:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0105ad3:	c0 
c0105ad4:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105adb:	c0 
c0105adc:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0105ae3:	00 
c0105ae4:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105aeb:	e8 09 a9 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c0105af0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105af7:	00 
c0105af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105afb:	89 04 24             	mov    %eax,(%esp)
c0105afe:	e8 a0 d2 ff ff       	call   c0102da3 <free_pages>
    free_page(p1);
c0105b03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b0a:	00 
c0105b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b0e:	89 04 24             	mov    %eax,(%esp)
c0105b11:	e8 8d d2 ff ff       	call   c0102da3 <free_pages>
    free_page(p2);
c0105b16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b1d:	00 
c0105b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b21:	89 04 24             	mov    %eax,(%esp)
c0105b24:	e8 7a d2 ff ff       	call   c0102da3 <free_pages>
    assert(nr_free == 3);
c0105b29:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c0105b2e:	83 f8 03             	cmp    $0x3,%eax
c0105b31:	74 24                	je     c0105b57 <basic_check+0x31c>
c0105b33:	c7 44 24 0c 17 80 10 	movl   $0xc0108017,0xc(%esp)
c0105b3a:	c0 
c0105b3b:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105b42:	c0 
c0105b43:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0105b4a:	00 
c0105b4b:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105b52:	e8 a2 a8 ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105b57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b5e:	e8 08 d2 ff ff       	call   c0102d6b <alloc_pages>
c0105b63:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105b6a:	75 24                	jne    c0105b90 <basic_check+0x355>
c0105b6c:	c7 44 24 0c e0 7e 10 	movl   $0xc0107ee0,0xc(%esp)
c0105b73:	c0 
c0105b74:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105b7b:	c0 
c0105b7c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0105b83:	00 
c0105b84:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105b8b:	e8 69 a8 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b97:	e8 cf d1 ff ff       	call   c0102d6b <alloc_pages>
c0105b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ba3:	75 24                	jne    c0105bc9 <basic_check+0x38e>
c0105ba5:	c7 44 24 0c fc 7e 10 	movl   $0xc0107efc,0xc(%esp)
c0105bac:	c0 
c0105bad:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105bb4:	c0 
c0105bb5:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0105bbc:	00 
c0105bbd:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105bc4:	e8 30 a8 ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105bc9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105bd0:	e8 96 d1 ff ff       	call   c0102d6b <alloc_pages>
c0105bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105bdc:	75 24                	jne    c0105c02 <basic_check+0x3c7>
c0105bde:	c7 44 24 0c 18 7f 10 	movl   $0xc0107f18,0xc(%esp)
c0105be5:	c0 
c0105be6:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105bed:	c0 
c0105bee:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0105bf5:	00 
c0105bf6:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105bfd:	e8 f7 a7 ff ff       	call   c01003f9 <__panic>

    assert(alloc_page() == NULL);
c0105c02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c09:	e8 5d d1 ff ff       	call   c0102d6b <alloc_pages>
c0105c0e:	85 c0                	test   %eax,%eax
c0105c10:	74 24                	je     c0105c36 <basic_check+0x3fb>
c0105c12:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0105c19:	c0 
c0105c1a:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105c21:	c0 
c0105c22:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0105c29:	00 
c0105c2a:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105c31:	e8 c3 a7 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c0105c36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c3d:	00 
c0105c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c41:	89 04 24             	mov    %eax,(%esp)
c0105c44:	e8 5a d1 ff ff       	call   c0102da3 <free_pages>
c0105c49:	c7 45 d8 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x28(%ebp)
c0105c50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c53:	8b 40 04             	mov    0x4(%eax),%eax
c0105c56:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105c59:	0f 94 c0             	sete   %al
c0105c5c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105c5f:	85 c0                	test   %eax,%eax
c0105c61:	74 24                	je     c0105c87 <basic_check+0x44c>
c0105c63:	c7 44 24 0c 24 80 10 	movl   $0xc0108024,0xc(%esp)
c0105c6a:	c0 
c0105c6b:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105c72:	c0 
c0105c73:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0105c7a:	00 
c0105c7b:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105c82:	e8 72 a7 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c8e:	e8 d8 d0 ff ff       	call   c0102d6b <alloc_pages>
c0105c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105c9c:	74 24                	je     c0105cc2 <basic_check+0x487>
c0105c9e:	c7 44 24 0c 3c 80 10 	movl   $0xc010803c,0xc(%esp)
c0105ca5:	c0 
c0105ca6:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105cad:	c0 
c0105cae:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0105cb5:	00 
c0105cb6:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105cbd:	e8 37 a7 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0105cc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105cc9:	e8 9d d0 ff ff       	call   c0102d6b <alloc_pages>
c0105cce:	85 c0                	test   %eax,%eax
c0105cd0:	74 24                	je     c0105cf6 <basic_check+0x4bb>
c0105cd2:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0105cd9:	c0 
c0105cda:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105ce1:	c0 
c0105ce2:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0105ce9:	00 
c0105cea:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105cf1:	e8 03 a7 ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c0105cf6:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c0105cfb:	85 c0                	test   %eax,%eax
c0105cfd:	74 24                	je     c0105d23 <basic_check+0x4e8>
c0105cff:	c7 44 24 0c 55 80 10 	movl   $0xc0108055,0xc(%esp)
c0105d06:	c0 
c0105d07:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105d0e:	c0 
c0105d0f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0105d16:	00 
c0105d17:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105d1e:	e8 d6 a6 ff ff       	call   c01003f9 <__panic>
    free_list = free_list_store;
c0105d23:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105d26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d29:	a3 a0 a3 1b c0       	mov    %eax,0xc01ba3a0
c0105d2e:	89 15 a4 a3 1b c0    	mov    %edx,0xc01ba3a4
    nr_free = nr_free_store;
c0105d34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d37:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8

    free_page(p);
c0105d3c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d43:	00 
c0105d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d47:	89 04 24             	mov    %eax,(%esp)
c0105d4a:	e8 54 d0 ff ff       	call   c0102da3 <free_pages>
    free_page(p1);
c0105d4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d56:	00 
c0105d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d5a:	89 04 24             	mov    %eax,(%esp)
c0105d5d:	e8 41 d0 ff ff       	call   c0102da3 <free_pages>
    free_page(p2);
c0105d62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d69:	00 
c0105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d6d:	89 04 24             	mov    %eax,(%esp)
c0105d70:	e8 2e d0 ff ff       	call   c0102da3 <free_pages>
}
c0105d75:	90                   	nop
c0105d76:	c9                   	leave  
c0105d77:	c3                   	ret    

c0105d78 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0105d78:	55                   	push   %ebp
c0105d79:	89 e5                	mov    %esp,%ebp
c0105d7b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0105d81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105d8f:	c7 45 ec a0 a3 1b c0 	movl   $0xc01ba3a0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105d96:	eb 6a                	jmp    c0105e02 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0105d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d9b:	83 e8 0c             	sub    $0xc,%eax
c0105d9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0105da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105da4:	83 c0 04             	add    $0x4,%eax
c0105da7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105dae:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105db4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105db7:	0f a3 10             	bt     %edx,(%eax)
c0105dba:	19 c0                	sbb    %eax,%eax
c0105dbc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105dbf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105dc3:	0f 95 c0             	setne  %al
c0105dc6:	0f b6 c0             	movzbl %al,%eax
c0105dc9:	85 c0                	test   %eax,%eax
c0105dcb:	75 24                	jne    c0105df1 <default_check+0x79>
c0105dcd:	c7 44 24 0c 62 80 10 	movl   $0xc0108062,0xc(%esp)
c0105dd4:	c0 
c0105dd5:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105ddc:	c0 
c0105ddd:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0105de4:	00 
c0105de5:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105dec:	e8 08 a6 ff ff       	call   c01003f9 <__panic>
        count ++, total += p->property;
c0105df1:	ff 45 f4             	incl   -0xc(%ebp)
c0105df4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105df7:	8b 50 08             	mov    0x8(%eax),%edx
c0105dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dfd:	01 d0                	add    %edx,%eax
c0105dff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105e08:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105e0b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e11:	81 7d ec a0 a3 1b c0 	cmpl   $0xc01ba3a0,-0x14(%ebp)
c0105e18:	0f 85 7a ff ff ff    	jne    c0105d98 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0105e1e:	e8 b3 cf ff ff       	call   c0102dd6 <nr_free_pages>
c0105e23:	89 c2                	mov    %eax,%edx
c0105e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e28:	39 c2                	cmp    %eax,%edx
c0105e2a:	74 24                	je     c0105e50 <default_check+0xd8>
c0105e2c:	c7 44 24 0c 72 80 10 	movl   $0xc0108072,0xc(%esp)
c0105e33:	c0 
c0105e34:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105e3b:	c0 
c0105e3c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0105e43:	00 
c0105e44:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105e4b:	e8 a9 a5 ff ff       	call   c01003f9 <__panic>

    basic_check();
c0105e50:	e8 e6 f9 ff ff       	call   c010583b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105e55:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105e5c:	e8 0a cf ff ff       	call   c0102d6b <alloc_pages>
c0105e61:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105e64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e68:	75 24                	jne    c0105e8e <default_check+0x116>
c0105e6a:	c7 44 24 0c 8b 80 10 	movl   $0xc010808b,0xc(%esp)
c0105e71:	c0 
c0105e72:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105e79:	c0 
c0105e7a:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0105e81:	00 
c0105e82:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105e89:	e8 6b a5 ff ff       	call   c01003f9 <__panic>
    assert(!PageProperty(p0));
c0105e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e91:	83 c0 04             	add    $0x4,%eax
c0105e94:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105e9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105e9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105ea1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105ea4:	0f a3 10             	bt     %edx,(%eax)
c0105ea7:	19 c0                	sbb    %eax,%eax
c0105ea9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105eac:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105eb0:	0f 95 c0             	setne  %al
c0105eb3:	0f b6 c0             	movzbl %al,%eax
c0105eb6:	85 c0                	test   %eax,%eax
c0105eb8:	74 24                	je     c0105ede <default_check+0x166>
c0105eba:	c7 44 24 0c 96 80 10 	movl   $0xc0108096,0xc(%esp)
c0105ec1:	c0 
c0105ec2:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105ec9:	c0 
c0105eca:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0105ed1:	00 
c0105ed2:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105ed9:	e8 1b a5 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c0105ede:	a1 a0 a3 1b c0       	mov    0xc01ba3a0,%eax
c0105ee3:	8b 15 a4 a3 1b c0    	mov    0xc01ba3a4,%edx
c0105ee9:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105eec:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105eef:	c7 45 b0 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105ef6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105ef9:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105efc:	89 50 04             	mov    %edx,0x4(%eax)
c0105eff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f02:	8b 50 04             	mov    0x4(%eax),%edx
c0105f05:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f08:	89 10                	mov    %edx,(%eax)
c0105f0a:	c7 45 b4 a0 a3 1b c0 	movl   $0xc01ba3a0,-0x4c(%ebp)
    return list->next == list;
c0105f11:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105f14:	8b 40 04             	mov    0x4(%eax),%eax
c0105f17:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105f1a:	0f 94 c0             	sete   %al
c0105f1d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105f20:	85 c0                	test   %eax,%eax
c0105f22:	75 24                	jne    c0105f48 <default_check+0x1d0>
c0105f24:	c7 44 24 0c eb 7f 10 	movl   $0xc0107feb,0xc(%esp)
c0105f2b:	c0 
c0105f2c:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105f33:	c0 
c0105f34:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0105f3b:	00 
c0105f3c:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105f43:	e8 b1 a4 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0105f48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f4f:	e8 17 ce ff ff       	call   c0102d6b <alloc_pages>
c0105f54:	85 c0                	test   %eax,%eax
c0105f56:	74 24                	je     c0105f7c <default_check+0x204>
c0105f58:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0105f5f:	c0 
c0105f60:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105f67:	c0 
c0105f68:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0105f6f:	00 
c0105f70:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105f77:	e8 7d a4 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0105f7c:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c0105f81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105f84:	c7 05 a8 a3 1b c0 00 	movl   $0x0,0xc01ba3a8
c0105f8b:	00 00 00 

    free_pages(p0 + 2, 3);
c0105f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f91:	83 c0 28             	add    $0x28,%eax
c0105f94:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105f9b:	00 
c0105f9c:	89 04 24             	mov    %eax,(%esp)
c0105f9f:	e8 ff cd ff ff       	call   c0102da3 <free_pages>
    assert(alloc_pages(4) == NULL);
c0105fa4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105fab:	e8 bb cd ff ff       	call   c0102d6b <alloc_pages>
c0105fb0:	85 c0                	test   %eax,%eax
c0105fb2:	74 24                	je     c0105fd8 <default_check+0x260>
c0105fb4:	c7 44 24 0c a8 80 10 	movl   $0xc01080a8,0xc(%esp)
c0105fbb:	c0 
c0105fbc:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0105fc3:	c0 
c0105fc4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0105fcb:	00 
c0105fcc:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0105fd3:	e8 21 a4 ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fdb:	83 c0 28             	add    $0x28,%eax
c0105fde:	83 c0 04             	add    $0x4,%eax
c0105fe1:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105fe8:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105fee:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105ff1:	0f a3 10             	bt     %edx,(%eax)
c0105ff4:	19 c0                	sbb    %eax,%eax
c0105ff6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105ff9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105ffd:	0f 95 c0             	setne  %al
c0106000:	0f b6 c0             	movzbl %al,%eax
c0106003:	85 c0                	test   %eax,%eax
c0106005:	74 0e                	je     c0106015 <default_check+0x29d>
c0106007:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010600a:	83 c0 28             	add    $0x28,%eax
c010600d:	8b 40 08             	mov    0x8(%eax),%eax
c0106010:	83 f8 03             	cmp    $0x3,%eax
c0106013:	74 24                	je     c0106039 <default_check+0x2c1>
c0106015:	c7 44 24 0c c0 80 10 	movl   $0xc01080c0,0xc(%esp)
c010601c:	c0 
c010601d:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0106024:	c0 
c0106025:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010602c:	00 
c010602d:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0106034:	e8 c0 a3 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0106039:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106040:	e8 26 cd ff ff       	call   c0102d6b <alloc_pages>
c0106045:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106048:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010604c:	75 24                	jne    c0106072 <default_check+0x2fa>
c010604e:	c7 44 24 0c ec 80 10 	movl   $0xc01080ec,0xc(%esp)
c0106055:	c0 
c0106056:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c010605d:	c0 
c010605e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0106065:	00 
c0106066:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c010606d:	e8 87 a3 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0106072:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106079:	e8 ed cc ff ff       	call   c0102d6b <alloc_pages>
c010607e:	85 c0                	test   %eax,%eax
c0106080:	74 24                	je     c01060a6 <default_check+0x32e>
c0106082:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c0106089:	c0 
c010608a:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0106091:	c0 
c0106092:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0106099:	00 
c010609a:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01060a1:	e8 53 a3 ff ff       	call   c01003f9 <__panic>
    assert(p0 + 2 == p1);
c01060a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060a9:	83 c0 28             	add    $0x28,%eax
c01060ac:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01060af:	74 24                	je     c01060d5 <default_check+0x35d>
c01060b1:	c7 44 24 0c 0a 81 10 	movl   $0xc010810a,0xc(%esp)
c01060b8:	c0 
c01060b9:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01060c0:	c0 
c01060c1:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01060c8:	00 
c01060c9:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01060d0:	e8 24 a3 ff ff       	call   c01003f9 <__panic>

    p2 = p0 + 1;
c01060d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060d8:	83 c0 14             	add    $0x14,%eax
c01060db:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01060de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060e5:	00 
c01060e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060e9:	89 04 24             	mov    %eax,(%esp)
c01060ec:	e8 b2 cc ff ff       	call   c0102da3 <free_pages>
    free_pages(p1, 3);
c01060f1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01060f8:	00 
c01060f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060fc:	89 04 24             	mov    %eax,(%esp)
c01060ff:	e8 9f cc ff ff       	call   c0102da3 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0106104:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106107:	83 c0 04             	add    $0x4,%eax
c010610a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0106111:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106114:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0106117:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010611a:	0f a3 10             	bt     %edx,(%eax)
c010611d:	19 c0                	sbb    %eax,%eax
c010611f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106122:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0106126:	0f 95 c0             	setne  %al
c0106129:	0f b6 c0             	movzbl %al,%eax
c010612c:	85 c0                	test   %eax,%eax
c010612e:	74 0b                	je     c010613b <default_check+0x3c3>
c0106130:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106133:	8b 40 08             	mov    0x8(%eax),%eax
c0106136:	83 f8 01             	cmp    $0x1,%eax
c0106139:	74 24                	je     c010615f <default_check+0x3e7>
c010613b:	c7 44 24 0c 18 81 10 	movl   $0xc0108118,0xc(%esp)
c0106142:	c0 
c0106143:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c010614a:	c0 
c010614b:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0106152:	00 
c0106153:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c010615a:	e8 9a a2 ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010615f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106162:	83 c0 04             	add    $0x4,%eax
c0106165:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010616c:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010616f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106172:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0106175:	0f a3 10             	bt     %edx,(%eax)
c0106178:	19 c0                	sbb    %eax,%eax
c010617a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010617d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0106181:	0f 95 c0             	setne  %al
c0106184:	0f b6 c0             	movzbl %al,%eax
c0106187:	85 c0                	test   %eax,%eax
c0106189:	74 0b                	je     c0106196 <default_check+0x41e>
c010618b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010618e:	8b 40 08             	mov    0x8(%eax),%eax
c0106191:	83 f8 03             	cmp    $0x3,%eax
c0106194:	74 24                	je     c01061ba <default_check+0x442>
c0106196:	c7 44 24 0c 40 81 10 	movl   $0xc0108140,0xc(%esp)
c010619d:	c0 
c010619e:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01061a5:	c0 
c01061a6:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01061ad:	00 
c01061ae:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01061b5:	e8 3f a2 ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01061ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061c1:	e8 a5 cb ff ff       	call   c0102d6b <alloc_pages>
c01061c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061cc:	83 e8 14             	sub    $0x14,%eax
c01061cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01061d2:	74 24                	je     c01061f8 <default_check+0x480>
c01061d4:	c7 44 24 0c 66 81 10 	movl   $0xc0108166,0xc(%esp)
c01061db:	c0 
c01061dc:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01061e3:	c0 
c01061e4:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01061eb:	00 
c01061ec:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01061f3:	e8 01 a2 ff ff       	call   c01003f9 <__panic>
    free_page(p0);
c01061f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01061ff:	00 
c0106200:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106203:	89 04 24             	mov    %eax,(%esp)
c0106206:	e8 98 cb ff ff       	call   c0102da3 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010620b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0106212:	e8 54 cb ff ff       	call   c0102d6b <alloc_pages>
c0106217:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010621a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010621d:	83 c0 14             	add    $0x14,%eax
c0106220:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106223:	74 24                	je     c0106249 <default_check+0x4d1>
c0106225:	c7 44 24 0c 84 81 10 	movl   $0xc0108184,0xc(%esp)
c010622c:	c0 
c010622d:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0106234:	c0 
c0106235:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010623c:	00 
c010623d:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0106244:	e8 b0 a1 ff ff       	call   c01003f9 <__panic>

    free_pages(p0, 2);
c0106249:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106250:	00 
c0106251:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106254:	89 04 24             	mov    %eax,(%esp)
c0106257:	e8 47 cb ff ff       	call   c0102da3 <free_pages>
    free_page(p2);
c010625c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106263:	00 
c0106264:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106267:	89 04 24             	mov    %eax,(%esp)
c010626a:	e8 34 cb ff ff       	call   c0102da3 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010626f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106276:	e8 f0 ca ff ff       	call   c0102d6b <alloc_pages>
c010627b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010627e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106282:	75 24                	jne    c01062a8 <default_check+0x530>
c0106284:	c7 44 24 0c a4 81 10 	movl   $0xc01081a4,0xc(%esp)
c010628b:	c0 
c010628c:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0106293:	c0 
c0106294:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010629b:	00 
c010629c:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01062a3:	e8 51 a1 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c01062a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062af:	e8 b7 ca ff ff       	call   c0102d6b <alloc_pages>
c01062b4:	85 c0                	test   %eax,%eax
c01062b6:	74 24                	je     c01062dc <default_check+0x564>
c01062b8:	c7 44 24 0c 02 80 10 	movl   $0xc0108002,0xc(%esp)
c01062bf:	c0 
c01062c0:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01062c7:	c0 
c01062c8:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01062cf:	00 
c01062d0:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01062d7:	e8 1d a1 ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c01062dc:	a1 a8 a3 1b c0       	mov    0xc01ba3a8,%eax
c01062e1:	85 c0                	test   %eax,%eax
c01062e3:	74 24                	je     c0106309 <default_check+0x591>
c01062e5:	c7 44 24 0c 55 80 10 	movl   $0xc0108055,0xc(%esp)
c01062ec:	c0 
c01062ed:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01062f4:	c0 
c01062f5:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01062fc:	00 
c01062fd:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0106304:	e8 f0 a0 ff ff       	call   c01003f9 <__panic>
    nr_free = nr_free_store;
c0106309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010630c:	a3 a8 a3 1b c0       	mov    %eax,0xc01ba3a8

    free_list = free_list_store;
c0106311:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106314:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106317:	a3 a0 a3 1b c0       	mov    %eax,0xc01ba3a0
c010631c:	89 15 a4 a3 1b c0    	mov    %edx,0xc01ba3a4
    free_pages(p0, 5);
c0106322:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0106329:	00 
c010632a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010632d:	89 04 24             	mov    %eax,(%esp)
c0106330:	e8 6e ca ff ff       	call   c0102da3 <free_pages>

    le = &free_list;
c0106335:	c7 45 ec a0 a3 1b c0 	movl   $0xc01ba3a0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010633c:	eb 5a                	jmp    c0106398 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
c010633e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106341:	8b 40 04             	mov    0x4(%eax),%eax
c0106344:	8b 00                	mov    (%eax),%eax
c0106346:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106349:	75 0d                	jne    c0106358 <default_check+0x5e0>
c010634b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010634e:	8b 00                	mov    (%eax),%eax
c0106350:	8b 40 04             	mov    0x4(%eax),%eax
c0106353:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106356:	74 24                	je     c010637c <default_check+0x604>
c0106358:	c7 44 24 0c c4 81 10 	movl   $0xc01081c4,0xc(%esp)
c010635f:	c0 
c0106360:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c0106367:	c0 
c0106368:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010636f:	00 
c0106370:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c0106377:	e8 7d a0 ff ff       	call   c01003f9 <__panic>
        struct Page *p = le2page(le, page_link);
c010637c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010637f:	83 e8 0c             	sub    $0xc,%eax
c0106382:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0106385:	ff 4d f4             	decl   -0xc(%ebp)
c0106388:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010638b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010638e:	8b 40 08             	mov    0x8(%eax),%eax
c0106391:	29 c2                	sub    %eax,%edx
c0106393:	89 d0                	mov    %edx,%eax
c0106395:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106398:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010639b:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010639e:	8b 45 88             	mov    -0x78(%ebp),%eax
c01063a1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01063a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01063a7:	81 7d ec a0 a3 1b c0 	cmpl   $0xc01ba3a0,-0x14(%ebp)
c01063ae:	75 8e                	jne    c010633e <default_check+0x5c6>
    }
    assert(count == 0);
c01063b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063b4:	74 24                	je     c01063da <default_check+0x662>
c01063b6:	c7 44 24 0c f1 81 10 	movl   $0xc01081f1,0xc(%esp)
c01063bd:	c0 
c01063be:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01063c5:	c0 
c01063c6:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01063cd:	00 
c01063ce:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01063d5:	e8 1f a0 ff ff       	call   c01003f9 <__panic>
    assert(total == 0);
c01063da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01063de:	74 24                	je     c0106404 <default_check+0x68c>
c01063e0:	c7 44 24 0c fc 81 10 	movl   $0xc01081fc,0xc(%esp)
c01063e7:	c0 
c01063e8:	c7 44 24 08 62 7e 10 	movl   $0xc0107e62,0x8(%esp)
c01063ef:	c0 
c01063f0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01063f7:	00 
c01063f8:	c7 04 24 77 7e 10 c0 	movl   $0xc0107e77,(%esp)
c01063ff:	e8 f5 9f ff ff       	call   c01003f9 <__panic>
}
c0106404:	90                   	nop
c0106405:	c9                   	leave  
c0106406:	c3                   	ret    

c0106407 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0106407:	55                   	push   %ebp
c0106408:	89 e5                	mov    %esp,%ebp
c010640a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010640d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0106414:	eb 03                	jmp    c0106419 <strlen+0x12>
        cnt ++;
c0106416:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0106419:	8b 45 08             	mov    0x8(%ebp),%eax
c010641c:	8d 50 01             	lea    0x1(%eax),%edx
c010641f:	89 55 08             	mov    %edx,0x8(%ebp)
c0106422:	0f b6 00             	movzbl (%eax),%eax
c0106425:	84 c0                	test   %al,%al
c0106427:	75 ed                	jne    c0106416 <strlen+0xf>
    }
    return cnt;
c0106429:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010642c:	c9                   	leave  
c010642d:	c3                   	ret    

c010642e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010642e:	55                   	push   %ebp
c010642f:	89 e5                	mov    %esp,%ebp
c0106431:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010643b:	eb 03                	jmp    c0106440 <strnlen+0x12>
        cnt ++;
c010643d:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0106440:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106443:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106446:	73 10                	jae    c0106458 <strnlen+0x2a>
c0106448:	8b 45 08             	mov    0x8(%ebp),%eax
c010644b:	8d 50 01             	lea    0x1(%eax),%edx
c010644e:	89 55 08             	mov    %edx,0x8(%ebp)
c0106451:	0f b6 00             	movzbl (%eax),%eax
c0106454:	84 c0                	test   %al,%al
c0106456:	75 e5                	jne    c010643d <strnlen+0xf>
    }
    return cnt;
c0106458:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010645b:	c9                   	leave  
c010645c:	c3                   	ret    

c010645d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010645d:	55                   	push   %ebp
c010645e:	89 e5                	mov    %esp,%ebp
c0106460:	57                   	push   %edi
c0106461:	56                   	push   %esi
c0106462:	83 ec 20             	sub    $0x20,%esp
c0106465:	8b 45 08             	mov    0x8(%ebp),%eax
c0106468:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010646b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010646e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0106471:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106477:	89 d1                	mov    %edx,%ecx
c0106479:	89 c2                	mov    %eax,%edx
c010647b:	89 ce                	mov    %ecx,%esi
c010647d:	89 d7                	mov    %edx,%edi
c010647f:	ac                   	lods   %ds:(%esi),%al
c0106480:	aa                   	stos   %al,%es:(%edi)
c0106481:	84 c0                	test   %al,%al
c0106483:	75 fa                	jne    c010647f <strcpy+0x22>
c0106485:	89 fa                	mov    %edi,%edx
c0106487:	89 f1                	mov    %esi,%ecx
c0106489:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010648c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010648f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0106492:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0106495:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0106496:	83 c4 20             	add    $0x20,%esp
c0106499:	5e                   	pop    %esi
c010649a:	5f                   	pop    %edi
c010649b:	5d                   	pop    %ebp
c010649c:	c3                   	ret    

c010649d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010649d:	55                   	push   %ebp
c010649e:	89 e5                	mov    %esp,%ebp
c01064a0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01064a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01064a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01064a9:	eb 1e                	jmp    c01064c9 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01064ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064ae:	0f b6 10             	movzbl (%eax),%edx
c01064b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01064b4:	88 10                	mov    %dl,(%eax)
c01064b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01064b9:	0f b6 00             	movzbl (%eax),%eax
c01064bc:	84 c0                	test   %al,%al
c01064be:	74 03                	je     c01064c3 <strncpy+0x26>
            src ++;
c01064c0:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01064c3:	ff 45 fc             	incl   -0x4(%ebp)
c01064c6:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01064c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01064cd:	75 dc                	jne    c01064ab <strncpy+0xe>
    }
    return dst;
c01064cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01064d2:	c9                   	leave  
c01064d3:	c3                   	ret    

c01064d4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01064d4:	55                   	push   %ebp
c01064d5:	89 e5                	mov    %esp,%ebp
c01064d7:	57                   	push   %edi
c01064d8:	56                   	push   %esi
c01064d9:	83 ec 20             	sub    $0x20,%esp
c01064dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01064df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01064e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01064e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01064eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064ee:	89 d1                	mov    %edx,%ecx
c01064f0:	89 c2                	mov    %eax,%edx
c01064f2:	89 ce                	mov    %ecx,%esi
c01064f4:	89 d7                	mov    %edx,%edi
c01064f6:	ac                   	lods   %ds:(%esi),%al
c01064f7:	ae                   	scas   %es:(%edi),%al
c01064f8:	75 08                	jne    c0106502 <strcmp+0x2e>
c01064fa:	84 c0                	test   %al,%al
c01064fc:	75 f8                	jne    c01064f6 <strcmp+0x22>
c01064fe:	31 c0                	xor    %eax,%eax
c0106500:	eb 04                	jmp    c0106506 <strcmp+0x32>
c0106502:	19 c0                	sbb    %eax,%eax
c0106504:	0c 01                	or     $0x1,%al
c0106506:	89 fa                	mov    %edi,%edx
c0106508:	89 f1                	mov    %esi,%ecx
c010650a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010650d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0106513:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0106516:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0106517:	83 c4 20             	add    $0x20,%esp
c010651a:	5e                   	pop    %esi
c010651b:	5f                   	pop    %edi
c010651c:	5d                   	pop    %ebp
c010651d:	c3                   	ret    

c010651e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010651e:	55                   	push   %ebp
c010651f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0106521:	eb 09                	jmp    c010652c <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0106523:	ff 4d 10             	decl   0x10(%ebp)
c0106526:	ff 45 08             	incl   0x8(%ebp)
c0106529:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010652c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106530:	74 1a                	je     c010654c <strncmp+0x2e>
c0106532:	8b 45 08             	mov    0x8(%ebp),%eax
c0106535:	0f b6 00             	movzbl (%eax),%eax
c0106538:	84 c0                	test   %al,%al
c010653a:	74 10                	je     c010654c <strncmp+0x2e>
c010653c:	8b 45 08             	mov    0x8(%ebp),%eax
c010653f:	0f b6 10             	movzbl (%eax),%edx
c0106542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106545:	0f b6 00             	movzbl (%eax),%eax
c0106548:	38 c2                	cmp    %al,%dl
c010654a:	74 d7                	je     c0106523 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010654c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106550:	74 18                	je     c010656a <strncmp+0x4c>
c0106552:	8b 45 08             	mov    0x8(%ebp),%eax
c0106555:	0f b6 00             	movzbl (%eax),%eax
c0106558:	0f b6 d0             	movzbl %al,%edx
c010655b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010655e:	0f b6 00             	movzbl (%eax),%eax
c0106561:	0f b6 c0             	movzbl %al,%eax
c0106564:	29 c2                	sub    %eax,%edx
c0106566:	89 d0                	mov    %edx,%eax
c0106568:	eb 05                	jmp    c010656f <strncmp+0x51>
c010656a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010656f:	5d                   	pop    %ebp
c0106570:	c3                   	ret    

c0106571 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0106571:	55                   	push   %ebp
c0106572:	89 e5                	mov    %esp,%ebp
c0106574:	83 ec 04             	sub    $0x4,%esp
c0106577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010657a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010657d:	eb 13                	jmp    c0106592 <strchr+0x21>
        if (*s == c) {
c010657f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106582:	0f b6 00             	movzbl (%eax),%eax
c0106585:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0106588:	75 05                	jne    c010658f <strchr+0x1e>
            return (char *)s;
c010658a:	8b 45 08             	mov    0x8(%ebp),%eax
c010658d:	eb 12                	jmp    c01065a1 <strchr+0x30>
        }
        s ++;
c010658f:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0106592:	8b 45 08             	mov    0x8(%ebp),%eax
c0106595:	0f b6 00             	movzbl (%eax),%eax
c0106598:	84 c0                	test   %al,%al
c010659a:	75 e3                	jne    c010657f <strchr+0xe>
    }
    return NULL;
c010659c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01065a1:	c9                   	leave  
c01065a2:	c3                   	ret    

c01065a3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01065a3:	55                   	push   %ebp
c01065a4:	89 e5                	mov    %esp,%ebp
c01065a6:	83 ec 04             	sub    $0x4,%esp
c01065a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065ac:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01065af:	eb 0e                	jmp    c01065bf <strfind+0x1c>
        if (*s == c) {
c01065b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01065b4:	0f b6 00             	movzbl (%eax),%eax
c01065b7:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01065ba:	74 0f                	je     c01065cb <strfind+0x28>
            break;
        }
        s ++;
c01065bc:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01065bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01065c2:	0f b6 00             	movzbl (%eax),%eax
c01065c5:	84 c0                	test   %al,%al
c01065c7:	75 e8                	jne    c01065b1 <strfind+0xe>
c01065c9:	eb 01                	jmp    c01065cc <strfind+0x29>
            break;
c01065cb:	90                   	nop
    }
    return (char *)s;
c01065cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01065cf:	c9                   	leave  
c01065d0:	c3                   	ret    

c01065d1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01065d1:	55                   	push   %ebp
c01065d2:	89 e5                	mov    %esp,%ebp
c01065d4:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01065d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01065de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01065e5:	eb 03                	jmp    c01065ea <strtol+0x19>
        s ++;
c01065e7:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01065ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01065ed:	0f b6 00             	movzbl (%eax),%eax
c01065f0:	3c 20                	cmp    $0x20,%al
c01065f2:	74 f3                	je     c01065e7 <strtol+0x16>
c01065f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01065f7:	0f b6 00             	movzbl (%eax),%eax
c01065fa:	3c 09                	cmp    $0x9,%al
c01065fc:	74 e9                	je     c01065e7 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01065fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0106601:	0f b6 00             	movzbl (%eax),%eax
c0106604:	3c 2b                	cmp    $0x2b,%al
c0106606:	75 05                	jne    c010660d <strtol+0x3c>
        s ++;
c0106608:	ff 45 08             	incl   0x8(%ebp)
c010660b:	eb 14                	jmp    c0106621 <strtol+0x50>
    }
    else if (*s == '-') {
c010660d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106610:	0f b6 00             	movzbl (%eax),%eax
c0106613:	3c 2d                	cmp    $0x2d,%al
c0106615:	75 0a                	jne    c0106621 <strtol+0x50>
        s ++, neg = 1;
c0106617:	ff 45 08             	incl   0x8(%ebp)
c010661a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0106621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106625:	74 06                	je     c010662d <strtol+0x5c>
c0106627:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010662b:	75 22                	jne    c010664f <strtol+0x7e>
c010662d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106630:	0f b6 00             	movzbl (%eax),%eax
c0106633:	3c 30                	cmp    $0x30,%al
c0106635:	75 18                	jne    c010664f <strtol+0x7e>
c0106637:	8b 45 08             	mov    0x8(%ebp),%eax
c010663a:	40                   	inc    %eax
c010663b:	0f b6 00             	movzbl (%eax),%eax
c010663e:	3c 78                	cmp    $0x78,%al
c0106640:	75 0d                	jne    c010664f <strtol+0x7e>
        s += 2, base = 16;
c0106642:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106646:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010664d:	eb 29                	jmp    c0106678 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c010664f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106653:	75 16                	jne    c010666b <strtol+0x9a>
c0106655:	8b 45 08             	mov    0x8(%ebp),%eax
c0106658:	0f b6 00             	movzbl (%eax),%eax
c010665b:	3c 30                	cmp    $0x30,%al
c010665d:	75 0c                	jne    c010666b <strtol+0x9a>
        s ++, base = 8;
c010665f:	ff 45 08             	incl   0x8(%ebp)
c0106662:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106669:	eb 0d                	jmp    c0106678 <strtol+0xa7>
    }
    else if (base == 0) {
c010666b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010666f:	75 07                	jne    c0106678 <strtol+0xa7>
        base = 10;
c0106671:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0106678:	8b 45 08             	mov    0x8(%ebp),%eax
c010667b:	0f b6 00             	movzbl (%eax),%eax
c010667e:	3c 2f                	cmp    $0x2f,%al
c0106680:	7e 1b                	jle    c010669d <strtol+0xcc>
c0106682:	8b 45 08             	mov    0x8(%ebp),%eax
c0106685:	0f b6 00             	movzbl (%eax),%eax
c0106688:	3c 39                	cmp    $0x39,%al
c010668a:	7f 11                	jg     c010669d <strtol+0xcc>
            dig = *s - '0';
c010668c:	8b 45 08             	mov    0x8(%ebp),%eax
c010668f:	0f b6 00             	movzbl (%eax),%eax
c0106692:	0f be c0             	movsbl %al,%eax
c0106695:	83 e8 30             	sub    $0x30,%eax
c0106698:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010669b:	eb 48                	jmp    c01066e5 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010669d:	8b 45 08             	mov    0x8(%ebp),%eax
c01066a0:	0f b6 00             	movzbl (%eax),%eax
c01066a3:	3c 60                	cmp    $0x60,%al
c01066a5:	7e 1b                	jle    c01066c2 <strtol+0xf1>
c01066a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01066aa:	0f b6 00             	movzbl (%eax),%eax
c01066ad:	3c 7a                	cmp    $0x7a,%al
c01066af:	7f 11                	jg     c01066c2 <strtol+0xf1>
            dig = *s - 'a' + 10;
c01066b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01066b4:	0f b6 00             	movzbl (%eax),%eax
c01066b7:	0f be c0             	movsbl %al,%eax
c01066ba:	83 e8 57             	sub    $0x57,%eax
c01066bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01066c0:	eb 23                	jmp    c01066e5 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01066c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01066c5:	0f b6 00             	movzbl (%eax),%eax
c01066c8:	3c 40                	cmp    $0x40,%al
c01066ca:	7e 3b                	jle    c0106707 <strtol+0x136>
c01066cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01066cf:	0f b6 00             	movzbl (%eax),%eax
c01066d2:	3c 5a                	cmp    $0x5a,%al
c01066d4:	7f 31                	jg     c0106707 <strtol+0x136>
            dig = *s - 'A' + 10;
c01066d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01066d9:	0f b6 00             	movzbl (%eax),%eax
c01066dc:	0f be c0             	movsbl %al,%eax
c01066df:	83 e8 37             	sub    $0x37,%eax
c01066e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01066e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066e8:	3b 45 10             	cmp    0x10(%ebp),%eax
c01066eb:	7d 19                	jge    c0106706 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c01066ed:	ff 45 08             	incl   0x8(%ebp)
c01066f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01066f3:	0f af 45 10          	imul   0x10(%ebp),%eax
c01066f7:	89 c2                	mov    %eax,%edx
c01066f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066fc:	01 d0                	add    %edx,%eax
c01066fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0106701:	e9 72 ff ff ff       	jmp    c0106678 <strtol+0xa7>
            break;
c0106706:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0106707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010670b:	74 08                	je     c0106715 <strtol+0x144>
        *endptr = (char *) s;
c010670d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106710:	8b 55 08             	mov    0x8(%ebp),%edx
c0106713:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106715:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106719:	74 07                	je     c0106722 <strtol+0x151>
c010671b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010671e:	f7 d8                	neg    %eax
c0106720:	eb 03                	jmp    c0106725 <strtol+0x154>
c0106722:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106725:	c9                   	leave  
c0106726:	c3                   	ret    

c0106727 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0106727:	55                   	push   %ebp
c0106728:	89 e5                	mov    %esp,%ebp
c010672a:	57                   	push   %edi
c010672b:	83 ec 24             	sub    $0x24,%esp
c010672e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106731:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106734:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0106738:	8b 55 08             	mov    0x8(%ebp),%edx
c010673b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010673e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0106741:	8b 45 10             	mov    0x10(%ebp),%eax
c0106744:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0106747:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010674a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010674e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106751:	89 d7                	mov    %edx,%edi
c0106753:	f3 aa                	rep stos %al,%es:(%edi)
c0106755:	89 fa                	mov    %edi,%edx
c0106757:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010675a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010675d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106760:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0106761:	83 c4 24             	add    $0x24,%esp
c0106764:	5f                   	pop    %edi
c0106765:	5d                   	pop    %ebp
c0106766:	c3                   	ret    

c0106767 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106767:	55                   	push   %ebp
c0106768:	89 e5                	mov    %esp,%ebp
c010676a:	57                   	push   %edi
c010676b:	56                   	push   %esi
c010676c:	53                   	push   %ebx
c010676d:	83 ec 30             	sub    $0x30,%esp
c0106770:	8b 45 08             	mov    0x8(%ebp),%eax
c0106773:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106776:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106779:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010677c:	8b 45 10             	mov    0x10(%ebp),%eax
c010677f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0106782:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106785:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106788:	73 42                	jae    c01067cc <memmove+0x65>
c010678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010678d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106793:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106796:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106799:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010679c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010679f:	c1 e8 02             	shr    $0x2,%eax
c01067a2:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01067a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067aa:	89 d7                	mov    %edx,%edi
c01067ac:	89 c6                	mov    %eax,%esi
c01067ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01067b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01067b3:	83 e1 03             	and    $0x3,%ecx
c01067b6:	74 02                	je     c01067ba <memmove+0x53>
c01067b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01067ba:	89 f0                	mov    %esi,%eax
c01067bc:	89 fa                	mov    %edi,%edx
c01067be:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01067c1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01067c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01067c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01067ca:	eb 36                	jmp    c0106802 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01067cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067cf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01067d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067d5:	01 c2                	add    %eax,%edx
c01067d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067da:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01067dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067e0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01067e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067e6:	89 c1                	mov    %eax,%ecx
c01067e8:	89 d8                	mov    %ebx,%eax
c01067ea:	89 d6                	mov    %edx,%esi
c01067ec:	89 c7                	mov    %eax,%edi
c01067ee:	fd                   	std    
c01067ef:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01067f1:	fc                   	cld    
c01067f2:	89 f8                	mov    %edi,%eax
c01067f4:	89 f2                	mov    %esi,%edx
c01067f6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01067f9:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01067fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01067ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106802:	83 c4 30             	add    $0x30,%esp
c0106805:	5b                   	pop    %ebx
c0106806:	5e                   	pop    %esi
c0106807:	5f                   	pop    %edi
c0106808:	5d                   	pop    %ebp
c0106809:	c3                   	ret    

c010680a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010680a:	55                   	push   %ebp
c010680b:	89 e5                	mov    %esp,%ebp
c010680d:	57                   	push   %edi
c010680e:	56                   	push   %esi
c010680f:	83 ec 20             	sub    $0x20,%esp
c0106812:	8b 45 08             	mov    0x8(%ebp),%eax
c0106815:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010681b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010681e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106821:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106824:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106827:	c1 e8 02             	shr    $0x2,%eax
c010682a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010682c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010682f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106832:	89 d7                	mov    %edx,%edi
c0106834:	89 c6                	mov    %eax,%esi
c0106836:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106838:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010683b:	83 e1 03             	and    $0x3,%ecx
c010683e:	74 02                	je     c0106842 <memcpy+0x38>
c0106840:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106842:	89 f0                	mov    %esi,%eax
c0106844:	89 fa                	mov    %edi,%edx
c0106846:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106849:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010684c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010684f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0106852:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106853:	83 c4 20             	add    $0x20,%esp
c0106856:	5e                   	pop    %esi
c0106857:	5f                   	pop    %edi
c0106858:	5d                   	pop    %ebp
c0106859:	c3                   	ret    

c010685a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010685a:	55                   	push   %ebp
c010685b:	89 e5                	mov    %esp,%ebp
c010685d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106860:	8b 45 08             	mov    0x8(%ebp),%eax
c0106863:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106869:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010686c:	eb 2e                	jmp    c010689c <memcmp+0x42>
        if (*s1 != *s2) {
c010686e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106871:	0f b6 10             	movzbl (%eax),%edx
c0106874:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106877:	0f b6 00             	movzbl (%eax),%eax
c010687a:	38 c2                	cmp    %al,%dl
c010687c:	74 18                	je     c0106896 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010687e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106881:	0f b6 00             	movzbl (%eax),%eax
c0106884:	0f b6 d0             	movzbl %al,%edx
c0106887:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010688a:	0f b6 00             	movzbl (%eax),%eax
c010688d:	0f b6 c0             	movzbl %al,%eax
c0106890:	29 c2                	sub    %eax,%edx
c0106892:	89 d0                	mov    %edx,%eax
c0106894:	eb 18                	jmp    c01068ae <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0106896:	ff 45 fc             	incl   -0x4(%ebp)
c0106899:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010689c:	8b 45 10             	mov    0x10(%ebp),%eax
c010689f:	8d 50 ff             	lea    -0x1(%eax),%edx
c01068a2:	89 55 10             	mov    %edx,0x10(%ebp)
c01068a5:	85 c0                	test   %eax,%eax
c01068a7:	75 c5                	jne    c010686e <memcmp+0x14>
    }
    return 0;
c01068a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01068ae:	c9                   	leave  
c01068af:	c3                   	ret    

c01068b0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01068b0:	55                   	push   %ebp
c01068b1:	89 e5                	mov    %esp,%ebp
c01068b3:	83 ec 58             	sub    $0x58,%esp
c01068b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01068b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01068bc:	8b 45 14             	mov    0x14(%ebp),%eax
c01068bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01068c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01068c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01068c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01068cb:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01068ce:	8b 45 18             	mov    0x18(%ebp),%eax
c01068d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01068d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068da:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01068dd:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01068e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01068e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068ea:	74 1c                	je     c0106908 <printnum+0x58>
c01068ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068ef:	ba 00 00 00 00       	mov    $0x0,%edx
c01068f4:	f7 75 e4             	divl   -0x1c(%ebp)
c01068f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01068fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068fd:	ba 00 00 00 00       	mov    $0x0,%edx
c0106902:	f7 75 e4             	divl   -0x1c(%ebp)
c0106905:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106908:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010690b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010690e:	f7 75 e4             	divl   -0x1c(%ebp)
c0106911:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106914:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106917:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010691a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010691d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106920:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0106923:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106926:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0106929:	8b 45 18             	mov    0x18(%ebp),%eax
c010692c:	ba 00 00 00 00       	mov    $0x0,%edx
c0106931:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106934:	72 56                	jb     c010698c <printnum+0xdc>
c0106936:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106939:	77 05                	ja     c0106940 <printnum+0x90>
c010693b:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010693e:	72 4c                	jb     c010698c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0106940:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106943:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106946:	8b 45 20             	mov    0x20(%ebp),%eax
c0106949:	89 44 24 18          	mov    %eax,0x18(%esp)
c010694d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106951:	8b 45 18             	mov    0x18(%ebp),%eax
c0106954:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106958:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010695b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010695e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106962:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106966:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106969:	89 44 24 04          	mov    %eax,0x4(%esp)
c010696d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106970:	89 04 24             	mov    %eax,(%esp)
c0106973:	e8 38 ff ff ff       	call   c01068b0 <printnum>
c0106978:	eb 1b                	jmp    c0106995 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010697a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010697d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106981:	8b 45 20             	mov    0x20(%ebp),%eax
c0106984:	89 04 24             	mov    %eax,(%esp)
c0106987:	8b 45 08             	mov    0x8(%ebp),%eax
c010698a:	ff d0                	call   *%eax
        while (-- width > 0)
c010698c:	ff 4d 1c             	decl   0x1c(%ebp)
c010698f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106993:	7f e5                	jg     c010697a <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106995:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106998:	05 b8 82 10 c0       	add    $0xc01082b8,%eax
c010699d:	0f b6 00             	movzbl (%eax),%eax
c01069a0:	0f be c0             	movsbl %al,%eax
c01069a3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01069a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069aa:	89 04 24             	mov    %eax,(%esp)
c01069ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01069b0:	ff d0                	call   *%eax
}
c01069b2:	90                   	nop
c01069b3:	c9                   	leave  
c01069b4:	c3                   	ret    

c01069b5 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01069b5:	55                   	push   %ebp
c01069b6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01069b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01069bc:	7e 14                	jle    c01069d2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01069be:	8b 45 08             	mov    0x8(%ebp),%eax
c01069c1:	8b 00                	mov    (%eax),%eax
c01069c3:	8d 48 08             	lea    0x8(%eax),%ecx
c01069c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01069c9:	89 0a                	mov    %ecx,(%edx)
c01069cb:	8b 50 04             	mov    0x4(%eax),%edx
c01069ce:	8b 00                	mov    (%eax),%eax
c01069d0:	eb 30                	jmp    c0106a02 <getuint+0x4d>
    }
    else if (lflag) {
c01069d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01069d6:	74 16                	je     c01069ee <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01069d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01069db:	8b 00                	mov    (%eax),%eax
c01069dd:	8d 48 04             	lea    0x4(%eax),%ecx
c01069e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01069e3:	89 0a                	mov    %ecx,(%edx)
c01069e5:	8b 00                	mov    (%eax),%eax
c01069e7:	ba 00 00 00 00       	mov    $0x0,%edx
c01069ec:	eb 14                	jmp    c0106a02 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01069ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01069f1:	8b 00                	mov    (%eax),%eax
c01069f3:	8d 48 04             	lea    0x4(%eax),%ecx
c01069f6:	8b 55 08             	mov    0x8(%ebp),%edx
c01069f9:	89 0a                	mov    %ecx,(%edx)
c01069fb:	8b 00                	mov    (%eax),%eax
c01069fd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106a02:	5d                   	pop    %ebp
c0106a03:	c3                   	ret    

c0106a04 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0106a04:	55                   	push   %ebp
c0106a05:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106a07:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106a0b:	7e 14                	jle    c0106a21 <getint+0x1d>
        return va_arg(*ap, long long);
c0106a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a10:	8b 00                	mov    (%eax),%eax
c0106a12:	8d 48 08             	lea    0x8(%eax),%ecx
c0106a15:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a18:	89 0a                	mov    %ecx,(%edx)
c0106a1a:	8b 50 04             	mov    0x4(%eax),%edx
c0106a1d:	8b 00                	mov    (%eax),%eax
c0106a1f:	eb 28                	jmp    c0106a49 <getint+0x45>
    }
    else if (lflag) {
c0106a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106a25:	74 12                	je     c0106a39 <getint+0x35>
        return va_arg(*ap, long);
c0106a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a2a:	8b 00                	mov    (%eax),%eax
c0106a2c:	8d 48 04             	lea    0x4(%eax),%ecx
c0106a2f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a32:	89 0a                	mov    %ecx,(%edx)
c0106a34:	8b 00                	mov    (%eax),%eax
c0106a36:	99                   	cltd   
c0106a37:	eb 10                	jmp    c0106a49 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0106a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a3c:	8b 00                	mov    (%eax),%eax
c0106a3e:	8d 48 04             	lea    0x4(%eax),%ecx
c0106a41:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a44:	89 0a                	mov    %ecx,(%edx)
c0106a46:	8b 00                	mov    (%eax),%eax
c0106a48:	99                   	cltd   
    }
}
c0106a49:	5d                   	pop    %ebp
c0106a4a:	c3                   	ret    

c0106a4b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0106a4b:	55                   	push   %ebp
c0106a4c:	89 e5                	mov    %esp,%ebp
c0106a4e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0106a51:	8d 45 14             	lea    0x14(%ebp),%eax
c0106a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a61:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a6f:	89 04 24             	mov    %eax,(%esp)
c0106a72:	e8 03 00 00 00       	call   c0106a7a <vprintfmt>
    va_end(ap);
}
c0106a77:	90                   	nop
c0106a78:	c9                   	leave  
c0106a79:	c3                   	ret    

c0106a7a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0106a7a:	55                   	push   %ebp
c0106a7b:	89 e5                	mov    %esp,%ebp
c0106a7d:	56                   	push   %esi
c0106a7e:	53                   	push   %ebx
c0106a7f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106a82:	eb 17                	jmp    c0106a9b <vprintfmt+0x21>
            if (ch == '\0') {
c0106a84:	85 db                	test   %ebx,%ebx
c0106a86:	0f 84 bf 03 00 00    	je     c0106e4b <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0106a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a93:	89 1c 24             	mov    %ebx,(%esp)
c0106a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a99:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106a9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a9e:	8d 50 01             	lea    0x1(%eax),%edx
c0106aa1:	89 55 10             	mov    %edx,0x10(%ebp)
c0106aa4:	0f b6 00             	movzbl (%eax),%eax
c0106aa7:	0f b6 d8             	movzbl %al,%ebx
c0106aaa:	83 fb 25             	cmp    $0x25,%ebx
c0106aad:	75 d5                	jne    c0106a84 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106aaf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106ab3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0106aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106abd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106ac0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106ac7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106aca:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0106acd:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ad0:	8d 50 01             	lea    0x1(%eax),%edx
c0106ad3:	89 55 10             	mov    %edx,0x10(%ebp)
c0106ad6:	0f b6 00             	movzbl (%eax),%eax
c0106ad9:	0f b6 d8             	movzbl %al,%ebx
c0106adc:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106adf:	83 f8 55             	cmp    $0x55,%eax
c0106ae2:	0f 87 37 03 00 00    	ja     c0106e1f <vprintfmt+0x3a5>
c0106ae8:	8b 04 85 dc 82 10 c0 	mov    -0x3fef7d24(,%eax,4),%eax
c0106aef:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106af1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106af5:	eb d6                	jmp    c0106acd <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0106af7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106afb:	eb d0                	jmp    c0106acd <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106afd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106b04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b07:	89 d0                	mov    %edx,%eax
c0106b09:	c1 e0 02             	shl    $0x2,%eax
c0106b0c:	01 d0                	add    %edx,%eax
c0106b0e:	01 c0                	add    %eax,%eax
c0106b10:	01 d8                	add    %ebx,%eax
c0106b12:	83 e8 30             	sub    $0x30,%eax
c0106b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0106b18:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b1b:	0f b6 00             	movzbl (%eax),%eax
c0106b1e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106b21:	83 fb 2f             	cmp    $0x2f,%ebx
c0106b24:	7e 38                	jle    c0106b5e <vprintfmt+0xe4>
c0106b26:	83 fb 39             	cmp    $0x39,%ebx
c0106b29:	7f 33                	jg     c0106b5e <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0106b2b:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0106b2e:	eb d4                	jmp    c0106b04 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0106b30:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b33:	8d 50 04             	lea    0x4(%eax),%edx
c0106b36:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b39:	8b 00                	mov    (%eax),%eax
c0106b3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106b3e:	eb 1f                	jmp    c0106b5f <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0106b40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b44:	79 87                	jns    c0106acd <vprintfmt+0x53>
                width = 0;
c0106b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106b4d:	e9 7b ff ff ff       	jmp    c0106acd <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0106b52:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106b59:	e9 6f ff ff ff       	jmp    c0106acd <vprintfmt+0x53>
            goto process_precision;
c0106b5e:	90                   	nop

        process_precision:
            if (width < 0)
c0106b5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b63:	0f 89 64 ff ff ff    	jns    c0106acd <vprintfmt+0x53>
                width = precision, precision = -1;
c0106b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b6f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106b76:	e9 52 ff ff ff       	jmp    c0106acd <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106b7b:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0106b7e:	e9 4a ff ff ff       	jmp    c0106acd <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106b83:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b86:	8d 50 04             	lea    0x4(%eax),%edx
c0106b89:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b8c:	8b 00                	mov    (%eax),%eax
c0106b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106b91:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b95:	89 04 24             	mov    %eax,(%esp)
c0106b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b9b:	ff d0                	call   *%eax
            break;
c0106b9d:	e9 a4 02 00 00       	jmp    c0106e46 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ba5:	8d 50 04             	lea    0x4(%eax),%edx
c0106ba8:	89 55 14             	mov    %edx,0x14(%ebp)
c0106bab:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106bad:	85 db                	test   %ebx,%ebx
c0106baf:	79 02                	jns    c0106bb3 <vprintfmt+0x139>
                err = -err;
c0106bb1:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106bb3:	83 fb 06             	cmp    $0x6,%ebx
c0106bb6:	7f 0b                	jg     c0106bc3 <vprintfmt+0x149>
c0106bb8:	8b 34 9d 9c 82 10 c0 	mov    -0x3fef7d64(,%ebx,4),%esi
c0106bbf:	85 f6                	test   %esi,%esi
c0106bc1:	75 23                	jne    c0106be6 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0106bc3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106bc7:	c7 44 24 08 c9 82 10 	movl   $0xc01082c9,0x8(%esp)
c0106bce:	c0 
c0106bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd9:	89 04 24             	mov    %eax,(%esp)
c0106bdc:	e8 6a fe ff ff       	call   c0106a4b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106be1:	e9 60 02 00 00       	jmp    c0106e46 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0106be6:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106bea:	c7 44 24 08 d2 82 10 	movl   $0xc01082d2,0x8(%esp)
c0106bf1:	c0 
c0106bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bfc:	89 04 24             	mov    %eax,(%esp)
c0106bff:	e8 47 fe ff ff       	call   c0106a4b <printfmt>
            break;
c0106c04:	e9 3d 02 00 00       	jmp    c0106e46 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0106c09:	8b 45 14             	mov    0x14(%ebp),%eax
c0106c0c:	8d 50 04             	lea    0x4(%eax),%edx
c0106c0f:	89 55 14             	mov    %edx,0x14(%ebp)
c0106c12:	8b 30                	mov    (%eax),%esi
c0106c14:	85 f6                	test   %esi,%esi
c0106c16:	75 05                	jne    c0106c1d <vprintfmt+0x1a3>
                p = "(null)";
c0106c18:	be d5 82 10 c0       	mov    $0xc01082d5,%esi
            }
            if (width > 0 && padc != '-') {
c0106c1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106c21:	7e 76                	jle    c0106c99 <vprintfmt+0x21f>
c0106c23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106c27:	74 70                	je     c0106c99 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c30:	89 34 24             	mov    %esi,(%esp)
c0106c33:	e8 f6 f7 ff ff       	call   c010642e <strnlen>
c0106c38:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106c3b:	29 c2                	sub    %eax,%edx
c0106c3d:	89 d0                	mov    %edx,%eax
c0106c3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c42:	eb 16                	jmp    c0106c5a <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0106c44:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0106c48:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c4b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c4f:	89 04 24             	mov    %eax,(%esp)
c0106c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c55:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106c57:	ff 4d e8             	decl   -0x18(%ebp)
c0106c5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106c5e:	7f e4                	jg     c0106c44 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106c60:	eb 37                	jmp    c0106c99 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106c62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106c66:	74 1f                	je     c0106c87 <vprintfmt+0x20d>
c0106c68:	83 fb 1f             	cmp    $0x1f,%ebx
c0106c6b:	7e 05                	jle    c0106c72 <vprintfmt+0x1f8>
c0106c6d:	83 fb 7e             	cmp    $0x7e,%ebx
c0106c70:	7e 15                	jle    c0106c87 <vprintfmt+0x20d>
                    putch('?', putdat);
c0106c72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c79:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c83:	ff d0                	call   *%eax
c0106c85:	eb 0f                	jmp    c0106c96 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0106c87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c8e:	89 1c 24             	mov    %ebx,(%esp)
c0106c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c94:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106c96:	ff 4d e8             	decl   -0x18(%ebp)
c0106c99:	89 f0                	mov    %esi,%eax
c0106c9b:	8d 70 01             	lea    0x1(%eax),%esi
c0106c9e:	0f b6 00             	movzbl (%eax),%eax
c0106ca1:	0f be d8             	movsbl %al,%ebx
c0106ca4:	85 db                	test   %ebx,%ebx
c0106ca6:	74 27                	je     c0106ccf <vprintfmt+0x255>
c0106ca8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106cac:	78 b4                	js     c0106c62 <vprintfmt+0x1e8>
c0106cae:	ff 4d e4             	decl   -0x1c(%ebp)
c0106cb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106cb5:	79 ab                	jns    c0106c62 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0106cb7:	eb 16                	jmp    c0106ccf <vprintfmt+0x255>
                putch(' ', putdat);
c0106cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cc0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106cc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cca:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0106ccc:	ff 4d e8             	decl   -0x18(%ebp)
c0106ccf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106cd3:	7f e4                	jg     c0106cb9 <vprintfmt+0x23f>
            }
            break;
c0106cd5:	e9 6c 01 00 00       	jmp    c0106e46 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0106ce4:	89 04 24             	mov    %eax,(%esp)
c0106ce7:	e8 18 fd ff ff       	call   c0106a04 <getint>
c0106cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106cf8:	85 d2                	test   %edx,%edx
c0106cfa:	79 26                	jns    c0106d22 <vprintfmt+0x2a8>
                putch('-', putdat);
c0106cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d03:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0106d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d0d:	ff d0                	call   *%eax
                num = -(long long)num;
c0106d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106d15:	f7 d8                	neg    %eax
c0106d17:	83 d2 00             	adc    $0x0,%edx
c0106d1a:	f7 da                	neg    %edx
c0106d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106d22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106d29:	e9 a8 00 00 00       	jmp    c0106dd6 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d35:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d38:	89 04 24             	mov    %eax,(%esp)
c0106d3b:	e8 75 fc ff ff       	call   c01069b5 <getuint>
c0106d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d43:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106d46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106d4d:	e9 84 00 00 00       	jmp    c0106dd6 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106d52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d59:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d5c:	89 04 24             	mov    %eax,(%esp)
c0106d5f:	e8 51 fc ff ff       	call   c01069b5 <getuint>
c0106d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d67:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106d6a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106d71:	eb 63                	jmp    c0106dd6 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0106d73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d7a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d84:	ff d0                	call   *%eax
            putch('x', putdat);
c0106d86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d8d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d97:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106d99:	8b 45 14             	mov    0x14(%ebp),%eax
c0106d9c:	8d 50 04             	lea    0x4(%eax),%edx
c0106d9f:	89 55 14             	mov    %edx,0x14(%ebp)
c0106da2:	8b 00                	mov    (%eax),%eax
c0106da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106da7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106dae:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106db5:	eb 1f                	jmp    c0106dd6 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dbe:	8d 45 14             	lea    0x14(%ebp),%eax
c0106dc1:	89 04 24             	mov    %eax,(%esp)
c0106dc4:	e8 ec fb ff ff       	call   c01069b5 <getuint>
c0106dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106dcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106dcf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106dd6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ddd:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106de4:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106de8:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106def:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106df2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106df6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e01:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e04:	89 04 24             	mov    %eax,(%esp)
c0106e07:	e8 a4 fa ff ff       	call   c01068b0 <printnum>
            break;
c0106e0c:	eb 38                	jmp    c0106e46 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e15:	89 1c 24             	mov    %ebx,(%esp)
c0106e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e1b:	ff d0                	call   *%eax
            break;
c0106e1d:	eb 27                	jmp    c0106e46 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e26:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e30:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106e32:	ff 4d 10             	decl   0x10(%ebp)
c0106e35:	eb 03                	jmp    c0106e3a <vprintfmt+0x3c0>
c0106e37:	ff 4d 10             	decl   0x10(%ebp)
c0106e3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e3d:	48                   	dec    %eax
c0106e3e:	0f b6 00             	movzbl (%eax),%eax
c0106e41:	3c 25                	cmp    $0x25,%al
c0106e43:	75 f2                	jne    c0106e37 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0106e45:	90                   	nop
    while (1) {
c0106e46:	e9 37 fc ff ff       	jmp    c0106a82 <vprintfmt+0x8>
                return;
c0106e4b:	90                   	nop
        }
    }
}
c0106e4c:	83 c4 40             	add    $0x40,%esp
c0106e4f:	5b                   	pop    %ebx
c0106e50:	5e                   	pop    %esi
c0106e51:	5d                   	pop    %ebp
c0106e52:	c3                   	ret    

c0106e53 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106e53:	55                   	push   %ebp
c0106e54:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106e56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e59:	8b 40 08             	mov    0x8(%eax),%eax
c0106e5c:	8d 50 01             	lea    0x1(%eax),%edx
c0106e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e62:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106e65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e68:	8b 10                	mov    (%eax),%edx
c0106e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e6d:	8b 40 04             	mov    0x4(%eax),%eax
c0106e70:	39 c2                	cmp    %eax,%edx
c0106e72:	73 12                	jae    c0106e86 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106e74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e77:	8b 00                	mov    (%eax),%eax
c0106e79:	8d 48 01             	lea    0x1(%eax),%ecx
c0106e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e7f:	89 0a                	mov    %ecx,(%edx)
c0106e81:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e84:	88 10                	mov    %dl,(%eax)
    }
}
c0106e86:	90                   	nop
c0106e87:	5d                   	pop    %ebp
c0106e88:	c3                   	ret    

c0106e89 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106e89:	55                   	push   %ebp
c0106e8a:	89 e5                	mov    %esp,%ebp
c0106e8c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106e8f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e9f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ead:	89 04 24             	mov    %eax,(%esp)
c0106eb0:	e8 08 00 00 00       	call   c0106ebd <vsnprintf>
c0106eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106ebb:	c9                   	leave  
c0106ebc:	c3                   	ret    

c0106ebd <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106ebd:	55                   	push   %ebp
c0106ebe:	89 e5                	mov    %esp,%ebp
c0106ec0:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106ecf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ed2:	01 d0                	add    %edx,%eax
c0106ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106ee2:	74 0a                	je     c0106eee <vsnprintf+0x31>
c0106ee4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eea:	39 c2                	cmp    %eax,%edx
c0106eec:	76 07                	jbe    c0106ef5 <vsnprintf+0x38>
        return -E_INVAL;
c0106eee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106ef3:	eb 2a                	jmp    c0106f1f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106ef5:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ef8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106efc:	8b 45 10             	mov    0x10(%ebp),%eax
c0106eff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106f03:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106f06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f0a:	c7 04 24 53 6e 10 c0 	movl   $0xc0106e53,(%esp)
c0106f11:	e8 64 fb ff ff       	call   c0106a7a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f19:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106f1f:	c9                   	leave  
c0106f20:	c3                   	ret    
