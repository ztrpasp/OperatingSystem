
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
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
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
c010003c:	ba 88 af 11 c0       	mov    $0xc011af88,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 d8 56 00 00       	call   c010573a <memset>

    cons_init();                // init the console
c0100062:	e8 90 15 00 00       	call   c01015f7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 5f 10 c0 	movl   $0xc0105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 5f 10 c0 	movl   $0xc0105f5c,(%esp)
c010007c:	e8 21 02 00 00       	call   c01002a2 <cprintf>

    print_kerninfo();
c0100081:	e8 c2 08 00 00       	call   c0100948 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 8e 00 00 00       	call   c0100119 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 7a 32 00 00       	call   c010330a <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 c7 16 00 00       	call   c010175c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 27 18 00 00       	call   c01018c1 <idt_init>

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
c010015a:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 61 5f 10 c0 	movl   $0xc0105f61,(%esp)
c010016e:	e8 2f 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 6f 5f 10 c0 	movl   $0xc0105f6f,(%esp)
c010018d:	e8 10 01 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 7d 5f 10 c0 	movl   $0xc0105f7d,(%esp)
c01001ac:	e8 f1 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 8b 5f 10 c0 	movl   $0xc0105f8b,(%esp)
c01001cb:	e8 d2 00 00 00       	call   c01002a2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 99 5f 10 c0 	movl   $0xc0105f99,(%esp)
c01001ea:	e8 b3 00 00 00       	call   c01002a2 <cprintf>
    round ++;
c01001ef:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
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
c010021f:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c0100226:	e8 77 00 00 00       	call   c01002a2 <cprintf>
    lab1_switch_to_user();
c010022b:	e8 cd ff ff ff       	call   c01001fd <lab1_switch_to_user>
    lab1_print_cur_status();
c0100230:	e8 0a ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100235:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
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
c0100298:	e8 f0 57 00 00       	call   c0105a8d <vprintfmt>
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
c0100357:	c7 04 24 e7 5f 10 c0 	movl   $0xc0105fe7,(%esp)
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
c01003a5:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
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
c01003e3:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003eb:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
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
c01003ff:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100404:	85 c0                	test   %eax,%eax
c0100406:	75 5b                	jne    c0100463 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100408:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
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
c0100426:	c7 04 24 ea 5f 10 c0 	movl   $0xc0105fea,(%esp)
c010042d:	e8 70 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c0100432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100435:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100439:	8b 45 10             	mov    0x10(%ebp),%eax
c010043c:	89 04 24             	mov    %eax,(%esp)
c010043f:	e8 2b fe ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c0100444:	c7 04 24 06 60 10 c0 	movl   $0xc0106006,(%esp)
c010044b:	e8 52 fe ff ff       	call   c01002a2 <cprintf>
    
    cprintf("stack trackback:\n");
c0100450:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
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
c0100491:	c7 04 24 1a 60 10 c0 	movl   $0xc010601a,(%esp)
c0100498:	e8 05 fe ff ff       	call   c01002a2 <cprintf>
    vcprintf(fmt, ap);
c010049d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a7:	89 04 24             	mov    %eax,(%esp)
c01004aa:	e8 c0 fd ff ff       	call   c010026f <vcprintf>
    cprintf("\n");
c01004af:	c7 04 24 06 60 10 c0 	movl   $0xc0106006,(%esp)
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
c01004c1:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
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
c010061f:	c7 00 38 60 10 c0    	movl   $0xc0106038,(%eax)
    info->eip_line = 0;
c0100625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	c7 40 08 38 60 10 c0 	movl   $0xc0106038,0x8(%eax)
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
c0100656:	c7 45 f4 78 72 10 c0 	movl   $0xc0107278,-0xc(%ebp)
    stab_end = __STAB_END__;
c010065d:	c7 45 f0 88 22 11 c0 	movl   $0xc0112288,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100664:	c7 45 ec 89 22 11 c0 	movl   $0xc0112289,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010066b:	c7 45 e8 94 4d 11 c0 	movl   $0xc0114d94,-0x18(%ebp)

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
c01007c6:	e8 eb 4d 00 00       	call   c01055b6 <strfind>
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
c010094e:	c7 04 24 42 60 10 c0 	movl   $0xc0106042,(%esp)
c0100955:	e8 48 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010095a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100961:	c0 
c0100962:	c7 04 24 5b 60 10 c0 	movl   $0xc010605b,(%esp)
c0100969:	e8 34 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010096e:	c7 44 24 04 34 5f 10 	movl   $0xc0105f34,0x4(%esp)
c0100975:	c0 
c0100976:	c7 04 24 73 60 10 c0 	movl   $0xc0106073,(%esp)
c010097d:	e8 20 f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100982:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100989:	c0 
c010098a:	c7 04 24 8b 60 10 c0 	movl   $0xc010608b,(%esp)
c0100991:	e8 0c f9 ff ff       	call   c01002a2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100996:	c7 44 24 04 88 af 11 	movl   $0xc011af88,0x4(%esp)
c010099d:	c0 
c010099e:	c7 04 24 a3 60 10 c0 	movl   $0xc01060a3,(%esp)
c01009a5:	e8 f8 f8 ff ff       	call   c01002a2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009aa:	b8 88 af 11 c0       	mov    $0xc011af88,%eax
c01009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ba:	29 c2                	sub    %eax,%edx
c01009bc:	89 d0                	mov    %edx,%eax
c01009be:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c4:	85 c0                	test   %eax,%eax
c01009c6:	0f 48 c2             	cmovs  %edx,%eax
c01009c9:	c1 f8 0a             	sar    $0xa,%eax
c01009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d0:	c7 04 24 bc 60 10 c0 	movl   $0xc01060bc,(%esp)
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
c0100a05:	c7 04 24 e6 60 10 c0 	movl   $0xc01060e6,(%esp)
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
c0100a73:	c7 04 24 02 61 10 c0 	movl   $0xc0106102,(%esp)
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
c0100ac6:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
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
c0100af9:	c7 04 24 30 61 10 c0 	movl   $0xc0106130,(%esp)
c0100b00:	e8 9d f7 ff ff       	call   c01002a2 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100b05:	ff 45 e8             	incl   -0x18(%ebp)
c0100b08:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b0c:	7e d6                	jle    c0100ae4 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b0e:	c7 04 24 38 61 10 c0 	movl   $0xc0106138,(%esp)
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
c0100b81:	c7 04 24 bc 61 10 c0 	movl   $0xc01061bc,(%esp)
c0100b88:	e8 f7 49 00 00       	call   c0105584 <strchr>
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
c0100ba9:	c7 04 24 c1 61 10 c0 	movl   $0xc01061c1,(%esp)
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
c0100beb:	c7 04 24 bc 61 10 c0 	movl   $0xc01061bc,(%esp)
c0100bf2:	e8 8d 49 00 00       	call   c0105584 <strchr>
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
c0100c4a:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c4f:	8b 00                	mov    (%eax),%eax
c0100c51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c55:	89 04 24             	mov    %eax,(%esp)
c0100c58:	e8 8a 48 00 00       	call   c01054e7 <strcmp>
c0100c5d:	85 c0                	test   %eax,%eax
c0100c5f:	75 31                	jne    c0100c92 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c64:	89 d0                	mov    %edx,%eax
c0100c66:	01 c0                	add    %eax,%eax
c0100c68:	01 d0                	add    %edx,%eax
c0100c6a:	c1 e0 02             	shl    $0x2,%eax
c0100c6d:	05 08 70 11 c0       	add    $0xc0117008,%eax
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
c0100ca4:	c7 04 24 df 61 10 c0 	movl   $0xc01061df,(%esp)
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
c0100cc1:	c7 04 24 f8 61 10 c0 	movl   $0xc01061f8,(%esp)
c0100cc8:	e8 d5 f5 ff ff       	call   c01002a2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100ccd:	c7 04 24 20 62 10 c0 	movl   $0xc0106220,(%esp)
c0100cd4:	e8 c9 f5 ff ff       	call   c01002a2 <cprintf>

    if (tf != NULL) {
c0100cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cdd:	74 0b                	je     c0100cea <kmonitor+0x2f>
        print_trapframe(tf);
c0100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ce2:	89 04 24             	mov    %eax,(%esp)
c0100ce5:	e8 8f 0d 00 00       	call   c0101a79 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cea:	c7 04 24 45 62 10 c0 	movl   $0xc0106245,(%esp)
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
c0100d36:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100d3b:	8b 08                	mov    (%eax),%ecx
c0100d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d40:	89 d0                	mov    %edx,%eax
c0100d42:	01 c0                	add    %eax,%eax
c0100d44:	01 d0                	add    %edx,%eax
c0100d46:	c1 e0 02             	shl    $0x2,%eax
c0100d49:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d4e:	8b 00                	mov    (%eax),%eax
c0100d50:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d58:	c7 04 24 49 62 10 c0 	movl   $0xc0106249,(%esp)
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
c0100dd9:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100de0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de3:	c7 04 24 52 62 10 c0 	movl   $0xc0106252,(%esp)
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
c0100ebb:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ec2:	b4 03 
c0100ec4:	eb 13                	jmp    c0100ed9 <cga_init+0x54>
    } else {
        *cp = was;
c0100ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ecd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ed0:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ed7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed9:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ee0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ee4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100eec:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ef0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef1:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
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
c0100f17:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f1e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f22:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f2a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
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
c0100f55:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5d:	0f b7 c0             	movzwl %ax,%eax
c0100f60:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
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
c0101010:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
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
c0101035:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
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
c0101139:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101140:	85 c0                	test   %eax,%eax
c0101142:	0f 84 af 00 00 00    	je     c01011f7 <cga_putc+0xf1>
            crt_pos --;
c0101148:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114f:	48                   	dec    %eax
c0101150:	0f b7 c0             	movzwl %ax,%eax
c0101153:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101159:	8b 45 08             	mov    0x8(%ebp),%eax
c010115c:	98                   	cwtl   
c010115d:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101162:	98                   	cwtl   
c0101163:	83 c8 20             	or     $0x20,%eax
c0101166:	98                   	cwtl   
c0101167:	8b 15 40 a4 11 c0    	mov    0xc011a440,%edx
c010116d:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101174:	01 c9                	add    %ecx,%ecx
c0101176:	01 ca                	add    %ecx,%edx
c0101178:	0f b7 c0             	movzwl %ax,%eax
c010117b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010117e:	eb 77                	jmp    c01011f7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c0101180:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101187:	83 c0 50             	add    $0x50,%eax
c010118a:	0f b7 c0             	movzwl %ax,%eax
c010118d:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101193:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010119a:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
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
c01011c5:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011cb:	eb 2b                	jmp    c01011f8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cd:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011d3:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011da:	8d 50 01             	lea    0x1(%eax),%edx
c01011dd:	0f b7 d2             	movzwl %dx,%edx
c01011e0:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
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
c01011f8:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ff:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101204:	76 5d                	jbe    c0101263 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101206:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010120b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101211:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101216:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010121d:	00 
c010121e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101222:	89 04 24             	mov    %eax,(%esp)
c0101225:	e8 50 45 00 00       	call   c010577a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101231:	eb 14                	jmp    c0101247 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c0101233:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
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
c0101250:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101257:	83 e8 50             	sub    $0x50,%eax
c010125a:	0f b7 c0             	movzwl %ax,%eax
c010125d:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101263:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010126a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010126e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101272:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101276:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010127a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010127b:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101282:	c1 e8 08             	shr    $0x8,%eax
c0101285:	0f b7 c0             	movzwl %ax,%eax
c0101288:	0f b6 c0             	movzbl %al,%eax
c010128b:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101292:	42                   	inc    %edx
c0101293:	0f b7 d2             	movzwl %dx,%edx
c0101296:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010129a:	88 45 e9             	mov    %al,-0x17(%ebp)
c010129d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a6:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01012ad:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012b1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012b5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012b9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012be:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012c5:	0f b6 c0             	movzbl %al,%eax
c01012c8:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
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
c0101391:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101396:	8d 50 01             	lea    0x1(%eax),%edx
c0101399:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c010139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a2:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a8:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b2:	75 0a                	jne    c01013be <cons_intr+0x3b>
                cons.wpos = 0;
c01013b4:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
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
c010142c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
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
c010148d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101492:	83 c8 40             	or     $0x40,%eax
c0101495:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010149a:	b8 00 00 00 00       	mov    $0x0,%eax
c010149f:	e9 22 01 00 00       	jmp    c01015c6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	84 c0                	test   %al,%al
c01014aa:	79 45                	jns    c01014f1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014ac:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
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
c01014cb:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014d2:	0c 40                	or     $0x40,%al
c01014d4:	0f b6 c0             	movzbl %al,%eax
c01014d7:	f7 d0                	not    %eax
c01014d9:	89 c2                	mov    %eax,%edx
c01014db:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e0:	21 d0                	and    %edx,%eax
c01014e2:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ec:	e9 d5 00 00 00       	jmp    c01015c6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014f1:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f6:	83 e0 40             	and    $0x40,%eax
c01014f9:	85 c0                	test   %eax,%eax
c01014fb:	74 11                	je     c010150e <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101501:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101506:	83 e0 bf             	and    $0xffffffbf,%eax
c0101509:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c010150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101512:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101519:	0f b6 d0             	movzbl %al,%edx
c010151c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101521:	09 d0                	or     %edx,%eax
c0101523:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101533:	0f b6 d0             	movzbl %al,%edx
c0101536:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153b:	31 d0                	xor    %edx,%eax
c010153d:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101542:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101547:	83 e0 03             	and    $0x3,%eax
c010154a:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101555:	01 d0                	add    %edx,%eax
c0101557:	0f b6 00             	movzbl (%eax),%eax
c010155a:	0f b6 c0             	movzbl %al,%eax
c010155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101560:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
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
c010158e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101593:	f7 d0                	not    %eax
c0101595:	83 e0 06             	and    $0x6,%eax
c0101598:	85 c0                	test   %eax,%eax
c010159a:	75 27                	jne    c01015c3 <kbd_proc_data+0x17f>
c010159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a3:	75 1e                	jne    c01015c3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c01015a5:	c7 04 24 6d 62 10 c0 	movl   $0xc010626d,(%esp)
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
c010160c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	75 0c                	jne    c0101621 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101615:	c7 04 24 79 62 10 c0 	movl   $0xc0106279,(%esp)
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
c0101680:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101686:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010168b:	39 c2                	cmp    %eax,%edx
c010168d:	74 31                	je     c01016c0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168f:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101694:	8d 50 01             	lea    0x1(%eax),%edx
c0101697:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c010169d:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c01016a4:	0f b6 c0             	movzbl %al,%eax
c01016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016aa:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016af:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b4:	75 0a                	jne    c01016c0 <cons_getc+0x5f>
                cons.rpos = 0;
c01016b6:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
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
c01016e0:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016e6:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
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
c0101743:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
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
c0101762:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
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
c0101876:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010187d:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101882:	74 0f                	je     c0101893 <pic_init+0x137>
        pic_setmask(irq_mask);
c0101884:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
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
c01018b2:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c01018b9:	e8 e4 e9 ff ff       	call   c01002a2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018be:	90                   	nop
c01018bf:	c9                   	leave  
c01018c0:	c3                   	ret    

c01018c1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018c1:	55                   	push   %ebp
c01018c2:	89 e5                	mov    %esp,%ebp
c01018c4:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ce:	e9 c4 00 00 00       	jmp    c0101997 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d6:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018dd:	0f b7 d0             	movzwl %ax,%edx
c01018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e3:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018ea:	c0 
c01018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ee:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c01018f5:	c0 08 00 
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101902:	c0 
c0101903:	80 e2 e0             	and    $0xe0,%dl
c0101906:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101910:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101917:	c0 
c0101918:	80 e2 1f             	and    $0x1f,%dl
c010191b:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101925:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010192c:	c0 
c010192d:	80 e2 f0             	and    $0xf0,%dl
c0101930:	80 ca 0e             	or     $0xe,%dl
c0101933:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193d:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101944:	c0 
c0101945:	80 e2 ef             	and    $0xef,%dl
c0101948:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101952:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101959:	c0 
c010195a:	80 e2 9f             	and    $0x9f,%dl
c010195d:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101967:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010196e:	c0 
c010196f:	80 ca 80             	or     $0x80,%dl
c0101972:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197c:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101983:	c1 e8 10             	shr    $0x10,%eax
c0101986:	0f b7 d0             	movzwl %ax,%edx
c0101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198c:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c0101993:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101994:	ff 45 fc             	incl   -0x4(%ebp)
c0101997:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010199a:	3d ff 00 00 00       	cmp    $0xff,%eax
c010199f:	0f 86 2e ff ff ff    	jbe    c01018d3 <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019a5:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019aa:	0f b7 c0             	movzwl %ax,%eax
c01019ad:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c01019b3:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c01019ba:	08 00 
c01019bc:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019c3:	24 e0                	and    $0xe0,%al
c01019c5:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019ca:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019d1:	24 1f                	and    $0x1f,%al
c01019d3:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019d8:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019df:	24 f0                	and    $0xf0,%al
c01019e1:	0c 0e                	or     $0xe,%al
c01019e3:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019e8:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019ef:	24 ef                	and    $0xef,%al
c01019f1:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019f6:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019fd:	0c 60                	or     $0x60,%al
c01019ff:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a04:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a0b:	0c 80                	or     $0x80,%al
c0101a0d:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a12:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a17:	c1 e8 10             	shr    $0x10,%eax
c0101a1a:	0f b7 c0             	movzwl %ax,%eax
c0101a1d:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a23:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a2d:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c0101a30:	90                   	nop
c0101a31:	c9                   	leave  
c0101a32:	c3                   	ret    

c0101a33 <trapname>:

static const char *
trapname(int trapno) {
c0101a33:	55                   	push   %ebp
c0101a34:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a39:	83 f8 13             	cmp    $0x13,%eax
c0101a3c:	77 0c                	ja     c0101a4a <trapname+0x17>
        return excnames[trapno];
c0101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a41:	8b 04 85 00 66 10 c0 	mov    -0x3fef9a00(,%eax,4),%eax
c0101a48:	eb 18                	jmp    c0101a62 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a4a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a4e:	7e 0d                	jle    c0101a5d <trapname+0x2a>
c0101a50:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a54:	7f 07                	jg     c0101a5d <trapname+0x2a>
        return "Hardware Interrupt";
c0101a56:	b8 aa 62 10 c0       	mov    $0xc01062aa,%eax
c0101a5b:	eb 05                	jmp    c0101a62 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a5d:	b8 bd 62 10 c0       	mov    $0xc01062bd,%eax
}
c0101a62:	5d                   	pop    %ebp
c0101a63:	c3                   	ret    

c0101a64 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a64:	55                   	push   %ebp
c0101a65:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a6e:	83 f8 08             	cmp    $0x8,%eax
c0101a71:	0f 94 c0             	sete   %al
c0101a74:	0f b6 c0             	movzbl %al,%eax
}
c0101a77:	5d                   	pop    %ebp
c0101a78:	c3                   	ret    

c0101a79 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a79:	55                   	push   %ebp
c0101a7a:	89 e5                	mov    %esp,%ebp
c0101a7c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a86:	c7 04 24 fe 62 10 c0 	movl   $0xc01062fe,(%esp)
c0101a8d:	e8 10 e8 ff ff       	call   c01002a2 <cprintf>
    print_regs(&tf->tf_regs);
c0101a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a95:	89 04 24             	mov    %eax,(%esp)
c0101a98:	e8 8f 01 00 00       	call   c0101c2c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa8:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c0101aaf:	e8 ee e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abf:	c7 04 24 22 63 10 c0 	movl   $0xc0106322,(%esp)
c0101ac6:	e8 d7 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad6:	c7 04 24 35 63 10 c0 	movl   $0xc0106335,(%esp)
c0101add:	e8 c0 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aed:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0101af4:	e8 a9 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afc:	8b 40 30             	mov    0x30(%eax),%eax
c0101aff:	89 04 24             	mov    %eax,(%esp)
c0101b02:	e8 2c ff ff ff       	call   c0101a33 <trapname>
c0101b07:	89 c2                	mov    %eax,%edx
c0101b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0c:	8b 40 30             	mov    0x30(%eax),%eax
c0101b0f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b17:	c7 04 24 5b 63 10 c0 	movl   $0xc010635b,(%esp)
c0101b1e:	e8 7f e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b26:	8b 40 34             	mov    0x34(%eax),%eax
c0101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2d:	c7 04 24 6d 63 10 c0 	movl   $0xc010636d,(%esp)
c0101b34:	e8 69 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3c:	8b 40 38             	mov    0x38(%eax),%eax
c0101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b43:	c7 04 24 7c 63 10 c0 	movl   $0xc010637c,(%esp)
c0101b4a:	e8 53 e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b52:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5a:	c7 04 24 8b 63 10 c0 	movl   $0xc010638b,(%esp)
c0101b61:	e8 3c e7 ff ff       	call   c01002a2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	8b 40 40             	mov    0x40(%eax),%eax
c0101b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b70:	c7 04 24 9e 63 10 c0 	movl   $0xc010639e,(%esp)
c0101b77:	e8 26 e7 ff ff       	call   c01002a2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b8a:	eb 3d                	jmp    c0101bc9 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	8b 50 40             	mov    0x40(%eax),%edx
c0101b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b95:	21 d0                	and    %edx,%eax
c0101b97:	85 c0                	test   %eax,%eax
c0101b99:	74 28                	je     c0101bc3 <print_trapframe+0x14a>
c0101b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b9e:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101ba5:	85 c0                	test   %eax,%eax
c0101ba7:	74 1a                	je     c0101bc3 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bac:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb7:	c7 04 24 ad 63 10 c0 	movl   $0xc01063ad,(%esp)
c0101bbe:	e8 df e6 ff ff       	call   c01002a2 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bc3:	ff 45 f4             	incl   -0xc(%ebp)
c0101bc6:	d1 65 f0             	shll   -0x10(%ebp)
c0101bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bcc:	83 f8 17             	cmp    $0x17,%eax
c0101bcf:	76 bb                	jbe    c0101b8c <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	8b 40 40             	mov    0x40(%eax),%eax
c0101bd7:	c1 e8 0c             	shr    $0xc,%eax
c0101bda:	83 e0 03             	and    $0x3,%eax
c0101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be1:	c7 04 24 b1 63 10 c0 	movl   $0xc01063b1,(%esp)
c0101be8:	e8 b5 e6 ff ff       	call   c01002a2 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	89 04 24             	mov    %eax,(%esp)
c0101bf3:	e8 6c fe ff ff       	call   c0101a64 <trap_in_kernel>
c0101bf8:	85 c0                	test   %eax,%eax
c0101bfa:	75 2d                	jne    c0101c29 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bff:	8b 40 44             	mov    0x44(%eax),%eax
c0101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c06:	c7 04 24 ba 63 10 c0 	movl   $0xc01063ba,(%esp)
c0101c0d:	e8 90 e6 ff ff       	call   c01002a2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1d:	c7 04 24 c9 63 10 c0 	movl   $0xc01063c9,(%esp)
c0101c24:	e8 79 e6 ff ff       	call   c01002a2 <cprintf>
    }
}
c0101c29:	90                   	nop
c0101c2a:	c9                   	leave  
c0101c2b:	c3                   	ret    

c0101c2c <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c2c:	55                   	push   %ebp
c0101c2d:	89 e5                	mov    %esp,%ebp
c0101c2f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	8b 00                	mov    (%eax),%eax
c0101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3b:	c7 04 24 dc 63 10 c0 	movl   $0xc01063dc,(%esp)
c0101c42:	e8 5b e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4a:	8b 40 04             	mov    0x4(%eax),%eax
c0101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c51:	c7 04 24 eb 63 10 c0 	movl   $0xc01063eb,(%esp)
c0101c58:	e8 45 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c60:	8b 40 08             	mov    0x8(%eax),%eax
c0101c63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c67:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101c6e:	e8 2f e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c76:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7d:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101c84:	e8 19 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8c:	8b 40 10             	mov    0x10(%eax),%eax
c0101c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c93:	c7 04 24 18 64 10 c0 	movl   $0xc0106418,(%esp)
c0101c9a:	e8 03 e6 ff ff       	call   c01002a2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca2:	8b 40 14             	mov    0x14(%eax),%eax
c0101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca9:	c7 04 24 27 64 10 c0 	movl   $0xc0106427,(%esp)
c0101cb0:	e8 ed e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb8:	8b 40 18             	mov    0x18(%eax),%eax
c0101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbf:	c7 04 24 36 64 10 c0 	movl   $0xc0106436,(%esp)
c0101cc6:	e8 d7 e5 ff ff       	call   c01002a2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cce:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd5:	c7 04 24 45 64 10 c0 	movl   $0xc0106445,(%esp)
c0101cdc:	e8 c1 e5 ff ff       	call   c01002a2 <cprintf>
}
c0101ce1:	90                   	nop
c0101ce2:	c9                   	leave  
c0101ce3:	c3                   	ret    

c0101ce4 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ce4:	55                   	push   %ebp
c0101ce5:	89 e5                	mov    %esp,%ebp
c0101ce7:	57                   	push   %edi
c0101ce8:	56                   	push   %esi
c0101ce9:	53                   	push   %ebx
c0101cea:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf0:	8b 40 30             	mov    0x30(%eax),%eax
c0101cf3:	83 f8 2f             	cmp    $0x2f,%eax
c0101cf6:	77 21                	ja     c0101d19 <trap_dispatch+0x35>
c0101cf8:	83 f8 2e             	cmp    $0x2e,%eax
c0101cfb:	0f 83 5d 02 00 00    	jae    c0101f5e <trap_dispatch+0x27a>
c0101d01:	83 f8 21             	cmp    $0x21,%eax
c0101d04:	0f 84 95 00 00 00    	je     c0101d9f <trap_dispatch+0xbb>
c0101d0a:	83 f8 24             	cmp    $0x24,%eax
c0101d0d:	74 67                	je     c0101d76 <trap_dispatch+0x92>
c0101d0f:	83 f8 20             	cmp    $0x20,%eax
c0101d12:	74 1c                	je     c0101d30 <trap_dispatch+0x4c>
c0101d14:	e9 10 02 00 00       	jmp    c0101f29 <trap_dispatch+0x245>
c0101d19:	83 f8 78             	cmp    $0x78,%eax
c0101d1c:	0f 84 a6 00 00 00    	je     c0101dc8 <trap_dispatch+0xe4>
c0101d22:	83 f8 79             	cmp    $0x79,%eax
c0101d25:	0f 84 81 01 00 00    	je     c0101eac <trap_dispatch+0x1c8>
c0101d2b:	e9 f9 01 00 00       	jmp    c0101f29 <trap_dispatch+0x245>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d30:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d35:	40                   	inc    %eax
c0101d36:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if (ticks % TICK_NUM == 0) {
c0101d3b:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d41:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d46:	89 c8                	mov    %ecx,%eax
c0101d48:	f7 e2                	mul    %edx
c0101d4a:	c1 ea 05             	shr    $0x5,%edx
c0101d4d:	89 d0                	mov    %edx,%eax
c0101d4f:	c1 e0 02             	shl    $0x2,%eax
c0101d52:	01 d0                	add    %edx,%eax
c0101d54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d5b:	01 d0                	add    %edx,%eax
c0101d5d:	c1 e0 02             	shl    $0x2,%eax
c0101d60:	29 c1                	sub    %eax,%ecx
c0101d62:	89 ca                	mov    %ecx,%edx
c0101d64:	85 d2                	test   %edx,%edx
c0101d66:	0f 85 f5 01 00 00    	jne    c0101f61 <trap_dispatch+0x27d>
            print_ticks();
c0101d6c:	e8 33 fb ff ff       	call   c01018a4 <print_ticks>
        }
        break;
c0101d71:	e9 eb 01 00 00       	jmp    c0101f61 <trap_dispatch+0x27d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d76:	e8 e6 f8 ff ff       	call   c0101661 <cons_getc>
c0101d7b:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d7e:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d82:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d86:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8e:	c7 04 24 54 64 10 c0 	movl   $0xc0106454,(%esp)
c0101d95:	e8 08 e5 ff ff       	call   c01002a2 <cprintf>
        break;
c0101d9a:	e9 c9 01 00 00       	jmp    c0101f68 <trap_dispatch+0x284>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d9f:	e8 bd f8 ff ff       	call   c0101661 <cons_getc>
c0101da4:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101da7:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101dab:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101daf:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101db3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db7:	c7 04 24 66 64 10 c0 	movl   $0xc0106466,(%esp)
c0101dbe:	e8 df e4 ff ff       	call   c01002a2 <cprintf>
        break;
c0101dc3:	e9 a0 01 00 00       	jmp    c0101f68 <trap_dispatch+0x284>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dcb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dcf:	83 f8 1b             	cmp    $0x1b,%eax
c0101dd2:	0f 84 8c 01 00 00    	je     c0101f64 <trap_dispatch+0x280>
            switchk2u = *tf;
c0101dd8:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ddb:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101de0:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101de5:	89 c1                	mov    %eax,%ecx
c0101de7:	83 e1 01             	and    $0x1,%ecx
c0101dea:	85 c9                	test   %ecx,%ecx
c0101dec:	74 0c                	je     c0101dfa <trap_dispatch+0x116>
c0101dee:	0f b6 0a             	movzbl (%edx),%ecx
c0101df1:	88 08                	mov    %cl,(%eax)
c0101df3:	8d 40 01             	lea    0x1(%eax),%eax
c0101df6:	8d 52 01             	lea    0x1(%edx),%edx
c0101df9:	4b                   	dec    %ebx
c0101dfa:	89 c1                	mov    %eax,%ecx
c0101dfc:	83 e1 02             	and    $0x2,%ecx
c0101dff:	85 c9                	test   %ecx,%ecx
c0101e01:	74 0f                	je     c0101e12 <trap_dispatch+0x12e>
c0101e03:	0f b7 0a             	movzwl (%edx),%ecx
c0101e06:	66 89 08             	mov    %cx,(%eax)
c0101e09:	8d 40 02             	lea    0x2(%eax),%eax
c0101e0c:	8d 52 02             	lea    0x2(%edx),%edx
c0101e0f:	83 eb 02             	sub    $0x2,%ebx
c0101e12:	89 df                	mov    %ebx,%edi
c0101e14:	83 e7 fc             	and    $0xfffffffc,%edi
c0101e17:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101e1c:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101e1f:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101e22:	83 c1 04             	add    $0x4,%ecx
c0101e25:	39 f9                	cmp    %edi,%ecx
c0101e27:	72 f3                	jb     c0101e1c <trap_dispatch+0x138>
c0101e29:	01 c8                	add    %ecx,%eax
c0101e2b:	01 ca                	add    %ecx,%edx
c0101e2d:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101e32:	89 de                	mov    %ebx,%esi
c0101e34:	83 e6 02             	and    $0x2,%esi
c0101e37:	85 f6                	test   %esi,%esi
c0101e39:	74 0b                	je     c0101e46 <trap_dispatch+0x162>
c0101e3b:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101e3f:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0101e43:	83 c1 02             	add    $0x2,%ecx
c0101e46:	83 e3 01             	and    $0x1,%ebx
c0101e49:	85 db                	test   %ebx,%ebx
c0101e4b:	74 07                	je     c0101e54 <trap_dispatch+0x170>
c0101e4d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0101e51:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0101e54:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0101e5b:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101e5d:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c0101e64:	23 00 
c0101e66:	0f b7 05 68 af 11 c0 	movzwl 0xc011af68,%eax
c0101e6d:	66 a3 48 af 11 c0    	mov    %ax,0xc011af48
c0101e73:	0f b7 05 48 af 11 c0 	movzwl 0xc011af48,%eax
c0101e7a:	66 a3 4c af 11 c0    	mov    %ax,0xc011af4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e83:	83 c0 44             	add    $0x44,%eax
c0101e86:	a3 64 af 11 c0       	mov    %eax,0xc011af64
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101e8b:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0101e90:	0d 00 30 00 00       	or     $0x3000,%eax
c0101e95:	a3 60 af 11 c0       	mov    %eax,0xc011af60
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9d:	83 e8 04             	sub    $0x4,%eax
c0101ea0:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c0101ea5:	89 10                	mov    %edx,(%eax)
        }
        break;
c0101ea7:	e9 b8 00 00 00       	jmp    c0101f64 <trap_dispatch+0x280>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101eb3:	83 f8 08             	cmp    $0x8,%eax
c0101eb6:	0f 84 ab 00 00 00    	je     c0101f67 <trap_dispatch+0x283>
            tf->tf_cs = KERNEL_CS;
c0101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebf:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec8:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101edc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101edf:	8b 40 40             	mov    0x40(%eax),%eax
c0101ee2:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101ee7:	89 c2                	mov    %eax,%edx
c0101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eec:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef2:	8b 40 44             	mov    0x44(%eax),%eax
c0101ef5:	83 e8 44             	sub    $0x44,%eax
c0101ef8:	a3 6c af 11 c0       	mov    %eax,0xc011af6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101efd:	a1 6c af 11 c0       	mov    0xc011af6c,%eax
c0101f02:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101f09:	00 
c0101f0a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101f0d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101f11:	89 04 24             	mov    %eax,(%esp)
c0101f14:	e8 61 38 00 00       	call   c010577a <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101f19:	8b 15 6c af 11 c0    	mov    0xc011af6c,%edx
c0101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f22:	83 e8 04             	sub    $0x4,%eax
c0101f25:	89 10                	mov    %edx,(%eax)
        }
        break;
c0101f27:	eb 3e                	jmp    c0101f67 <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f30:	83 e0 03             	and    $0x3,%eax
c0101f33:	85 c0                	test   %eax,%eax
c0101f35:	75 31                	jne    c0101f68 <trap_dispatch+0x284>
            print_trapframe(tf);
c0101f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3a:	89 04 24             	mov    %eax,(%esp)
c0101f3d:	e8 37 fb ff ff       	call   c0101a79 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f42:	c7 44 24 08 75 64 10 	movl   $0xc0106475,0x8(%esp)
c0101f49:	c0 
c0101f4a:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0101f51:	00 
c0101f52:	c7 04 24 91 64 10 c0 	movl   $0xc0106491,(%esp)
c0101f59:	e8 9b e4 ff ff       	call   c01003f9 <__panic>
        break;
c0101f5e:	90                   	nop
c0101f5f:	eb 07                	jmp    c0101f68 <trap_dispatch+0x284>
        break;
c0101f61:	90                   	nop
c0101f62:	eb 04                	jmp    c0101f68 <trap_dispatch+0x284>
        break;
c0101f64:	90                   	nop
c0101f65:	eb 01                	jmp    c0101f68 <trap_dispatch+0x284>
        break;
c0101f67:	90                   	nop
        }
    }
}
c0101f68:	90                   	nop
c0101f69:	83 c4 2c             	add    $0x2c,%esp
c0101f6c:	5b                   	pop    %ebx
c0101f6d:	5e                   	pop    %esi
c0101f6e:	5f                   	pop    %edi
c0101f6f:	5d                   	pop    %ebp
c0101f70:	c3                   	ret    

c0101f71 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f71:	55                   	push   %ebp
c0101f72:	89 e5                	mov    %esp,%ebp
c0101f74:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7a:	89 04 24             	mov    %eax,(%esp)
c0101f7d:	e8 62 fd ff ff       	call   c0101ce4 <trap_dispatch>
}
c0101f82:	90                   	nop
c0101f83:	c9                   	leave  
c0101f84:	c3                   	ret    

c0101f85 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $0
c0101f87:	6a 00                	push   $0x0
  jmp __alltraps
c0101f89:	e9 69 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101f8e <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $1
c0101f90:	6a 01                	push   $0x1
  jmp __alltraps
c0101f92:	e9 60 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101f97 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $2
c0101f99:	6a 02                	push   $0x2
  jmp __alltraps
c0101f9b:	e9 57 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fa0 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $3
c0101fa2:	6a 03                	push   $0x3
  jmp __alltraps
c0101fa4:	e9 4e 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fa9 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $4
c0101fab:	6a 04                	push   $0x4
  jmp __alltraps
c0101fad:	e9 45 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fb2 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $5
c0101fb4:	6a 05                	push   $0x5
  jmp __alltraps
c0101fb6:	e9 3c 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fbb <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $6
c0101fbd:	6a 06                	push   $0x6
  jmp __alltraps
c0101fbf:	e9 33 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fc4 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $7
c0101fc6:	6a 07                	push   $0x7
  jmp __alltraps
c0101fc8:	e9 2a 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fcd <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fcd:	6a 08                	push   $0x8
  jmp __alltraps
c0101fcf:	e9 23 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fd4 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101fd4:	6a 00                	push   $0x0
  pushl $9
c0101fd6:	6a 09                	push   $0x9
  jmp __alltraps
c0101fd8:	e9 1a 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fdd <vector10>:
.globl vector10
vector10:
  pushl $10
c0101fdd:	6a 0a                	push   $0xa
  jmp __alltraps
c0101fdf:	e9 13 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101fe4 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101fe4:	6a 0b                	push   $0xb
  jmp __alltraps
c0101fe6:	e9 0c 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101feb <vector12>:
.globl vector12
vector12:
  pushl $12
c0101feb:	6a 0c                	push   $0xc
  jmp __alltraps
c0101fed:	e9 05 0a 00 00       	jmp    c01029f7 <__alltraps>

c0101ff2 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ff2:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ff4:	e9 fe 09 00 00       	jmp    c01029f7 <__alltraps>

c0101ff9 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ff9:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ffb:	e9 f7 09 00 00       	jmp    c01029f7 <__alltraps>

c0102000 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $15
c0102002:	6a 0f                	push   $0xf
  jmp __alltraps
c0102004:	e9 ee 09 00 00       	jmp    c01029f7 <__alltraps>

c0102009 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102009:	6a 00                	push   $0x0
  pushl $16
c010200b:	6a 10                	push   $0x10
  jmp __alltraps
c010200d:	e9 e5 09 00 00       	jmp    c01029f7 <__alltraps>

c0102012 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102012:	6a 11                	push   $0x11
  jmp __alltraps
c0102014:	e9 de 09 00 00       	jmp    c01029f7 <__alltraps>

c0102019 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $18
c010201b:	6a 12                	push   $0x12
  jmp __alltraps
c010201d:	e9 d5 09 00 00       	jmp    c01029f7 <__alltraps>

c0102022 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $19
c0102024:	6a 13                	push   $0x13
  jmp __alltraps
c0102026:	e9 cc 09 00 00       	jmp    c01029f7 <__alltraps>

c010202b <vector20>:
.globl vector20
vector20:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $20
c010202d:	6a 14                	push   $0x14
  jmp __alltraps
c010202f:	e9 c3 09 00 00       	jmp    c01029f7 <__alltraps>

c0102034 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $21
c0102036:	6a 15                	push   $0x15
  jmp __alltraps
c0102038:	e9 ba 09 00 00       	jmp    c01029f7 <__alltraps>

c010203d <vector22>:
.globl vector22
vector22:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $22
c010203f:	6a 16                	push   $0x16
  jmp __alltraps
c0102041:	e9 b1 09 00 00       	jmp    c01029f7 <__alltraps>

c0102046 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $23
c0102048:	6a 17                	push   $0x17
  jmp __alltraps
c010204a:	e9 a8 09 00 00       	jmp    c01029f7 <__alltraps>

c010204f <vector24>:
.globl vector24
vector24:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $24
c0102051:	6a 18                	push   $0x18
  jmp __alltraps
c0102053:	e9 9f 09 00 00       	jmp    c01029f7 <__alltraps>

c0102058 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $25
c010205a:	6a 19                	push   $0x19
  jmp __alltraps
c010205c:	e9 96 09 00 00       	jmp    c01029f7 <__alltraps>

c0102061 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $26
c0102063:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102065:	e9 8d 09 00 00       	jmp    c01029f7 <__alltraps>

c010206a <vector27>:
.globl vector27
vector27:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $27
c010206c:	6a 1b                	push   $0x1b
  jmp __alltraps
c010206e:	e9 84 09 00 00       	jmp    c01029f7 <__alltraps>

c0102073 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $28
c0102075:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102077:	e9 7b 09 00 00       	jmp    c01029f7 <__alltraps>

c010207c <vector29>:
.globl vector29
vector29:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $29
c010207e:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102080:	e9 72 09 00 00       	jmp    c01029f7 <__alltraps>

c0102085 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $30
c0102087:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102089:	e9 69 09 00 00       	jmp    c01029f7 <__alltraps>

c010208e <vector31>:
.globl vector31
vector31:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $31
c0102090:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102092:	e9 60 09 00 00       	jmp    c01029f7 <__alltraps>

c0102097 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $32
c0102099:	6a 20                	push   $0x20
  jmp __alltraps
c010209b:	e9 57 09 00 00       	jmp    c01029f7 <__alltraps>

c01020a0 <vector33>:
.globl vector33
vector33:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $33
c01020a2:	6a 21                	push   $0x21
  jmp __alltraps
c01020a4:	e9 4e 09 00 00       	jmp    c01029f7 <__alltraps>

c01020a9 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $34
c01020ab:	6a 22                	push   $0x22
  jmp __alltraps
c01020ad:	e9 45 09 00 00       	jmp    c01029f7 <__alltraps>

c01020b2 <vector35>:
.globl vector35
vector35:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $35
c01020b4:	6a 23                	push   $0x23
  jmp __alltraps
c01020b6:	e9 3c 09 00 00       	jmp    c01029f7 <__alltraps>

c01020bb <vector36>:
.globl vector36
vector36:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $36
c01020bd:	6a 24                	push   $0x24
  jmp __alltraps
c01020bf:	e9 33 09 00 00       	jmp    c01029f7 <__alltraps>

c01020c4 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $37
c01020c6:	6a 25                	push   $0x25
  jmp __alltraps
c01020c8:	e9 2a 09 00 00       	jmp    c01029f7 <__alltraps>

c01020cd <vector38>:
.globl vector38
vector38:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $38
c01020cf:	6a 26                	push   $0x26
  jmp __alltraps
c01020d1:	e9 21 09 00 00       	jmp    c01029f7 <__alltraps>

c01020d6 <vector39>:
.globl vector39
vector39:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $39
c01020d8:	6a 27                	push   $0x27
  jmp __alltraps
c01020da:	e9 18 09 00 00       	jmp    c01029f7 <__alltraps>

c01020df <vector40>:
.globl vector40
vector40:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $40
c01020e1:	6a 28                	push   $0x28
  jmp __alltraps
c01020e3:	e9 0f 09 00 00       	jmp    c01029f7 <__alltraps>

c01020e8 <vector41>:
.globl vector41
vector41:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $41
c01020ea:	6a 29                	push   $0x29
  jmp __alltraps
c01020ec:	e9 06 09 00 00       	jmp    c01029f7 <__alltraps>

c01020f1 <vector42>:
.globl vector42
vector42:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $42
c01020f3:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020f5:	e9 fd 08 00 00       	jmp    c01029f7 <__alltraps>

c01020fa <vector43>:
.globl vector43
vector43:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $43
c01020fc:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020fe:	e9 f4 08 00 00       	jmp    c01029f7 <__alltraps>

c0102103 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $44
c0102105:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102107:	e9 eb 08 00 00       	jmp    c01029f7 <__alltraps>

c010210c <vector45>:
.globl vector45
vector45:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $45
c010210e:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102110:	e9 e2 08 00 00       	jmp    c01029f7 <__alltraps>

c0102115 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $46
c0102117:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102119:	e9 d9 08 00 00       	jmp    c01029f7 <__alltraps>

c010211e <vector47>:
.globl vector47
vector47:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $47
c0102120:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102122:	e9 d0 08 00 00       	jmp    c01029f7 <__alltraps>

c0102127 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $48
c0102129:	6a 30                	push   $0x30
  jmp __alltraps
c010212b:	e9 c7 08 00 00       	jmp    c01029f7 <__alltraps>

c0102130 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $49
c0102132:	6a 31                	push   $0x31
  jmp __alltraps
c0102134:	e9 be 08 00 00       	jmp    c01029f7 <__alltraps>

c0102139 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $50
c010213b:	6a 32                	push   $0x32
  jmp __alltraps
c010213d:	e9 b5 08 00 00       	jmp    c01029f7 <__alltraps>

c0102142 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $51
c0102144:	6a 33                	push   $0x33
  jmp __alltraps
c0102146:	e9 ac 08 00 00       	jmp    c01029f7 <__alltraps>

c010214b <vector52>:
.globl vector52
vector52:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $52
c010214d:	6a 34                	push   $0x34
  jmp __alltraps
c010214f:	e9 a3 08 00 00       	jmp    c01029f7 <__alltraps>

c0102154 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $53
c0102156:	6a 35                	push   $0x35
  jmp __alltraps
c0102158:	e9 9a 08 00 00       	jmp    c01029f7 <__alltraps>

c010215d <vector54>:
.globl vector54
vector54:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $54
c010215f:	6a 36                	push   $0x36
  jmp __alltraps
c0102161:	e9 91 08 00 00       	jmp    c01029f7 <__alltraps>

c0102166 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $55
c0102168:	6a 37                	push   $0x37
  jmp __alltraps
c010216a:	e9 88 08 00 00       	jmp    c01029f7 <__alltraps>

c010216f <vector56>:
.globl vector56
vector56:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $56
c0102171:	6a 38                	push   $0x38
  jmp __alltraps
c0102173:	e9 7f 08 00 00       	jmp    c01029f7 <__alltraps>

c0102178 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $57
c010217a:	6a 39                	push   $0x39
  jmp __alltraps
c010217c:	e9 76 08 00 00       	jmp    c01029f7 <__alltraps>

c0102181 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $58
c0102183:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102185:	e9 6d 08 00 00       	jmp    c01029f7 <__alltraps>

c010218a <vector59>:
.globl vector59
vector59:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $59
c010218c:	6a 3b                	push   $0x3b
  jmp __alltraps
c010218e:	e9 64 08 00 00       	jmp    c01029f7 <__alltraps>

c0102193 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $60
c0102195:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102197:	e9 5b 08 00 00       	jmp    c01029f7 <__alltraps>

c010219c <vector61>:
.globl vector61
vector61:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $61
c010219e:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021a0:	e9 52 08 00 00       	jmp    c01029f7 <__alltraps>

c01021a5 <vector62>:
.globl vector62
vector62:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $62
c01021a7:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021a9:	e9 49 08 00 00       	jmp    c01029f7 <__alltraps>

c01021ae <vector63>:
.globl vector63
vector63:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $63
c01021b0:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021b2:	e9 40 08 00 00       	jmp    c01029f7 <__alltraps>

c01021b7 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $64
c01021b9:	6a 40                	push   $0x40
  jmp __alltraps
c01021bb:	e9 37 08 00 00       	jmp    c01029f7 <__alltraps>

c01021c0 <vector65>:
.globl vector65
vector65:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $65
c01021c2:	6a 41                	push   $0x41
  jmp __alltraps
c01021c4:	e9 2e 08 00 00       	jmp    c01029f7 <__alltraps>

c01021c9 <vector66>:
.globl vector66
vector66:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $66
c01021cb:	6a 42                	push   $0x42
  jmp __alltraps
c01021cd:	e9 25 08 00 00       	jmp    c01029f7 <__alltraps>

c01021d2 <vector67>:
.globl vector67
vector67:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $67
c01021d4:	6a 43                	push   $0x43
  jmp __alltraps
c01021d6:	e9 1c 08 00 00       	jmp    c01029f7 <__alltraps>

c01021db <vector68>:
.globl vector68
vector68:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $68
c01021dd:	6a 44                	push   $0x44
  jmp __alltraps
c01021df:	e9 13 08 00 00       	jmp    c01029f7 <__alltraps>

c01021e4 <vector69>:
.globl vector69
vector69:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $69
c01021e6:	6a 45                	push   $0x45
  jmp __alltraps
c01021e8:	e9 0a 08 00 00       	jmp    c01029f7 <__alltraps>

c01021ed <vector70>:
.globl vector70
vector70:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $70
c01021ef:	6a 46                	push   $0x46
  jmp __alltraps
c01021f1:	e9 01 08 00 00       	jmp    c01029f7 <__alltraps>

c01021f6 <vector71>:
.globl vector71
vector71:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $71
c01021f8:	6a 47                	push   $0x47
  jmp __alltraps
c01021fa:	e9 f8 07 00 00       	jmp    c01029f7 <__alltraps>

c01021ff <vector72>:
.globl vector72
vector72:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $72
c0102201:	6a 48                	push   $0x48
  jmp __alltraps
c0102203:	e9 ef 07 00 00       	jmp    c01029f7 <__alltraps>

c0102208 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $73
c010220a:	6a 49                	push   $0x49
  jmp __alltraps
c010220c:	e9 e6 07 00 00       	jmp    c01029f7 <__alltraps>

c0102211 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $74
c0102213:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102215:	e9 dd 07 00 00       	jmp    c01029f7 <__alltraps>

c010221a <vector75>:
.globl vector75
vector75:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $75
c010221c:	6a 4b                	push   $0x4b
  jmp __alltraps
c010221e:	e9 d4 07 00 00       	jmp    c01029f7 <__alltraps>

c0102223 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $76
c0102225:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102227:	e9 cb 07 00 00       	jmp    c01029f7 <__alltraps>

c010222c <vector77>:
.globl vector77
vector77:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $77
c010222e:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102230:	e9 c2 07 00 00       	jmp    c01029f7 <__alltraps>

c0102235 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $78
c0102237:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102239:	e9 b9 07 00 00       	jmp    c01029f7 <__alltraps>

c010223e <vector79>:
.globl vector79
vector79:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $79
c0102240:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102242:	e9 b0 07 00 00       	jmp    c01029f7 <__alltraps>

c0102247 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $80
c0102249:	6a 50                	push   $0x50
  jmp __alltraps
c010224b:	e9 a7 07 00 00       	jmp    c01029f7 <__alltraps>

c0102250 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $81
c0102252:	6a 51                	push   $0x51
  jmp __alltraps
c0102254:	e9 9e 07 00 00       	jmp    c01029f7 <__alltraps>

c0102259 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $82
c010225b:	6a 52                	push   $0x52
  jmp __alltraps
c010225d:	e9 95 07 00 00       	jmp    c01029f7 <__alltraps>

c0102262 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $83
c0102264:	6a 53                	push   $0x53
  jmp __alltraps
c0102266:	e9 8c 07 00 00       	jmp    c01029f7 <__alltraps>

c010226b <vector84>:
.globl vector84
vector84:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $84
c010226d:	6a 54                	push   $0x54
  jmp __alltraps
c010226f:	e9 83 07 00 00       	jmp    c01029f7 <__alltraps>

c0102274 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $85
c0102276:	6a 55                	push   $0x55
  jmp __alltraps
c0102278:	e9 7a 07 00 00       	jmp    c01029f7 <__alltraps>

c010227d <vector86>:
.globl vector86
vector86:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $86
c010227f:	6a 56                	push   $0x56
  jmp __alltraps
c0102281:	e9 71 07 00 00       	jmp    c01029f7 <__alltraps>

c0102286 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $87
c0102288:	6a 57                	push   $0x57
  jmp __alltraps
c010228a:	e9 68 07 00 00       	jmp    c01029f7 <__alltraps>

c010228f <vector88>:
.globl vector88
vector88:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $88
c0102291:	6a 58                	push   $0x58
  jmp __alltraps
c0102293:	e9 5f 07 00 00       	jmp    c01029f7 <__alltraps>

c0102298 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $89
c010229a:	6a 59                	push   $0x59
  jmp __alltraps
c010229c:	e9 56 07 00 00       	jmp    c01029f7 <__alltraps>

c01022a1 <vector90>:
.globl vector90
vector90:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $90
c01022a3:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022a5:	e9 4d 07 00 00       	jmp    c01029f7 <__alltraps>

c01022aa <vector91>:
.globl vector91
vector91:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $91
c01022ac:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022ae:	e9 44 07 00 00       	jmp    c01029f7 <__alltraps>

c01022b3 <vector92>:
.globl vector92
vector92:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $92
c01022b5:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022b7:	e9 3b 07 00 00       	jmp    c01029f7 <__alltraps>

c01022bc <vector93>:
.globl vector93
vector93:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $93
c01022be:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022c0:	e9 32 07 00 00       	jmp    c01029f7 <__alltraps>

c01022c5 <vector94>:
.globl vector94
vector94:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $94
c01022c7:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022c9:	e9 29 07 00 00       	jmp    c01029f7 <__alltraps>

c01022ce <vector95>:
.globl vector95
vector95:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $95
c01022d0:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022d2:	e9 20 07 00 00       	jmp    c01029f7 <__alltraps>

c01022d7 <vector96>:
.globl vector96
vector96:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $96
c01022d9:	6a 60                	push   $0x60
  jmp __alltraps
c01022db:	e9 17 07 00 00       	jmp    c01029f7 <__alltraps>

c01022e0 <vector97>:
.globl vector97
vector97:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $97
c01022e2:	6a 61                	push   $0x61
  jmp __alltraps
c01022e4:	e9 0e 07 00 00       	jmp    c01029f7 <__alltraps>

c01022e9 <vector98>:
.globl vector98
vector98:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $98
c01022eb:	6a 62                	push   $0x62
  jmp __alltraps
c01022ed:	e9 05 07 00 00       	jmp    c01029f7 <__alltraps>

c01022f2 <vector99>:
.globl vector99
vector99:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $99
c01022f4:	6a 63                	push   $0x63
  jmp __alltraps
c01022f6:	e9 fc 06 00 00       	jmp    c01029f7 <__alltraps>

c01022fb <vector100>:
.globl vector100
vector100:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $100
c01022fd:	6a 64                	push   $0x64
  jmp __alltraps
c01022ff:	e9 f3 06 00 00       	jmp    c01029f7 <__alltraps>

c0102304 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $101
c0102306:	6a 65                	push   $0x65
  jmp __alltraps
c0102308:	e9 ea 06 00 00       	jmp    c01029f7 <__alltraps>

c010230d <vector102>:
.globl vector102
vector102:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $102
c010230f:	6a 66                	push   $0x66
  jmp __alltraps
c0102311:	e9 e1 06 00 00       	jmp    c01029f7 <__alltraps>

c0102316 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $103
c0102318:	6a 67                	push   $0x67
  jmp __alltraps
c010231a:	e9 d8 06 00 00       	jmp    c01029f7 <__alltraps>

c010231f <vector104>:
.globl vector104
vector104:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $104
c0102321:	6a 68                	push   $0x68
  jmp __alltraps
c0102323:	e9 cf 06 00 00       	jmp    c01029f7 <__alltraps>

c0102328 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $105
c010232a:	6a 69                	push   $0x69
  jmp __alltraps
c010232c:	e9 c6 06 00 00       	jmp    c01029f7 <__alltraps>

c0102331 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $106
c0102333:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102335:	e9 bd 06 00 00       	jmp    c01029f7 <__alltraps>

c010233a <vector107>:
.globl vector107
vector107:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $107
c010233c:	6a 6b                	push   $0x6b
  jmp __alltraps
c010233e:	e9 b4 06 00 00       	jmp    c01029f7 <__alltraps>

c0102343 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $108
c0102345:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102347:	e9 ab 06 00 00       	jmp    c01029f7 <__alltraps>

c010234c <vector109>:
.globl vector109
vector109:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $109
c010234e:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102350:	e9 a2 06 00 00       	jmp    c01029f7 <__alltraps>

c0102355 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $110
c0102357:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102359:	e9 99 06 00 00       	jmp    c01029f7 <__alltraps>

c010235e <vector111>:
.globl vector111
vector111:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $111
c0102360:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102362:	e9 90 06 00 00       	jmp    c01029f7 <__alltraps>

c0102367 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $112
c0102369:	6a 70                	push   $0x70
  jmp __alltraps
c010236b:	e9 87 06 00 00       	jmp    c01029f7 <__alltraps>

c0102370 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $113
c0102372:	6a 71                	push   $0x71
  jmp __alltraps
c0102374:	e9 7e 06 00 00       	jmp    c01029f7 <__alltraps>

c0102379 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $114
c010237b:	6a 72                	push   $0x72
  jmp __alltraps
c010237d:	e9 75 06 00 00       	jmp    c01029f7 <__alltraps>

c0102382 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $115
c0102384:	6a 73                	push   $0x73
  jmp __alltraps
c0102386:	e9 6c 06 00 00       	jmp    c01029f7 <__alltraps>

c010238b <vector116>:
.globl vector116
vector116:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $116
c010238d:	6a 74                	push   $0x74
  jmp __alltraps
c010238f:	e9 63 06 00 00       	jmp    c01029f7 <__alltraps>

c0102394 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $117
c0102396:	6a 75                	push   $0x75
  jmp __alltraps
c0102398:	e9 5a 06 00 00       	jmp    c01029f7 <__alltraps>

c010239d <vector118>:
.globl vector118
vector118:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $118
c010239f:	6a 76                	push   $0x76
  jmp __alltraps
c01023a1:	e9 51 06 00 00       	jmp    c01029f7 <__alltraps>

c01023a6 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $119
c01023a8:	6a 77                	push   $0x77
  jmp __alltraps
c01023aa:	e9 48 06 00 00       	jmp    c01029f7 <__alltraps>

c01023af <vector120>:
.globl vector120
vector120:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $120
c01023b1:	6a 78                	push   $0x78
  jmp __alltraps
c01023b3:	e9 3f 06 00 00       	jmp    c01029f7 <__alltraps>

c01023b8 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $121
c01023ba:	6a 79                	push   $0x79
  jmp __alltraps
c01023bc:	e9 36 06 00 00       	jmp    c01029f7 <__alltraps>

c01023c1 <vector122>:
.globl vector122
vector122:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $122
c01023c3:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023c5:	e9 2d 06 00 00       	jmp    c01029f7 <__alltraps>

c01023ca <vector123>:
.globl vector123
vector123:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $123
c01023cc:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023ce:	e9 24 06 00 00       	jmp    c01029f7 <__alltraps>

c01023d3 <vector124>:
.globl vector124
vector124:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $124
c01023d5:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023d7:	e9 1b 06 00 00       	jmp    c01029f7 <__alltraps>

c01023dc <vector125>:
.globl vector125
vector125:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $125
c01023de:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023e0:	e9 12 06 00 00       	jmp    c01029f7 <__alltraps>

c01023e5 <vector126>:
.globl vector126
vector126:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $126
c01023e7:	6a 7e                	push   $0x7e
  jmp __alltraps
c01023e9:	e9 09 06 00 00       	jmp    c01029f7 <__alltraps>

c01023ee <vector127>:
.globl vector127
vector127:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $127
c01023f0:	6a 7f                	push   $0x7f
  jmp __alltraps
c01023f2:	e9 00 06 00 00       	jmp    c01029f7 <__alltraps>

c01023f7 <vector128>:
.globl vector128
vector128:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $128
c01023f9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023fe:	e9 f4 05 00 00       	jmp    c01029f7 <__alltraps>

c0102403 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $129
c0102405:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010240a:	e9 e8 05 00 00       	jmp    c01029f7 <__alltraps>

c010240f <vector130>:
.globl vector130
vector130:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $130
c0102411:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102416:	e9 dc 05 00 00       	jmp    c01029f7 <__alltraps>

c010241b <vector131>:
.globl vector131
vector131:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $131
c010241d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102422:	e9 d0 05 00 00       	jmp    c01029f7 <__alltraps>

c0102427 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $132
c0102429:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010242e:	e9 c4 05 00 00       	jmp    c01029f7 <__alltraps>

c0102433 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $133
c0102435:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010243a:	e9 b8 05 00 00       	jmp    c01029f7 <__alltraps>

c010243f <vector134>:
.globl vector134
vector134:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $134
c0102441:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102446:	e9 ac 05 00 00       	jmp    c01029f7 <__alltraps>

c010244b <vector135>:
.globl vector135
vector135:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $135
c010244d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102452:	e9 a0 05 00 00       	jmp    c01029f7 <__alltraps>

c0102457 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $136
c0102459:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010245e:	e9 94 05 00 00       	jmp    c01029f7 <__alltraps>

c0102463 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $137
c0102465:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010246a:	e9 88 05 00 00       	jmp    c01029f7 <__alltraps>

c010246f <vector138>:
.globl vector138
vector138:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $138
c0102471:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102476:	e9 7c 05 00 00       	jmp    c01029f7 <__alltraps>

c010247b <vector139>:
.globl vector139
vector139:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $139
c010247d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102482:	e9 70 05 00 00       	jmp    c01029f7 <__alltraps>

c0102487 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $140
c0102489:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010248e:	e9 64 05 00 00       	jmp    c01029f7 <__alltraps>

c0102493 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $141
c0102495:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010249a:	e9 58 05 00 00       	jmp    c01029f7 <__alltraps>

c010249f <vector142>:
.globl vector142
vector142:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $142
c01024a1:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024a6:	e9 4c 05 00 00       	jmp    c01029f7 <__alltraps>

c01024ab <vector143>:
.globl vector143
vector143:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $143
c01024ad:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024b2:	e9 40 05 00 00       	jmp    c01029f7 <__alltraps>

c01024b7 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $144
c01024b9:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024be:	e9 34 05 00 00       	jmp    c01029f7 <__alltraps>

c01024c3 <vector145>:
.globl vector145
vector145:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $145
c01024c5:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024ca:	e9 28 05 00 00       	jmp    c01029f7 <__alltraps>

c01024cf <vector146>:
.globl vector146
vector146:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $146
c01024d1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024d6:	e9 1c 05 00 00       	jmp    c01029f7 <__alltraps>

c01024db <vector147>:
.globl vector147
vector147:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $147
c01024dd:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024e2:	e9 10 05 00 00       	jmp    c01029f7 <__alltraps>

c01024e7 <vector148>:
.globl vector148
vector148:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $148
c01024e9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024ee:	e9 04 05 00 00       	jmp    c01029f7 <__alltraps>

c01024f3 <vector149>:
.globl vector149
vector149:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $149
c01024f5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024fa:	e9 f8 04 00 00       	jmp    c01029f7 <__alltraps>

c01024ff <vector150>:
.globl vector150
vector150:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $150
c0102501:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102506:	e9 ec 04 00 00       	jmp    c01029f7 <__alltraps>

c010250b <vector151>:
.globl vector151
vector151:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $151
c010250d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102512:	e9 e0 04 00 00       	jmp    c01029f7 <__alltraps>

c0102517 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $152
c0102519:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010251e:	e9 d4 04 00 00       	jmp    c01029f7 <__alltraps>

c0102523 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $153
c0102525:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010252a:	e9 c8 04 00 00       	jmp    c01029f7 <__alltraps>

c010252f <vector154>:
.globl vector154
vector154:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $154
c0102531:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102536:	e9 bc 04 00 00       	jmp    c01029f7 <__alltraps>

c010253b <vector155>:
.globl vector155
vector155:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $155
c010253d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102542:	e9 b0 04 00 00       	jmp    c01029f7 <__alltraps>

c0102547 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $156
c0102549:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010254e:	e9 a4 04 00 00       	jmp    c01029f7 <__alltraps>

c0102553 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $157
c0102555:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010255a:	e9 98 04 00 00       	jmp    c01029f7 <__alltraps>

c010255f <vector158>:
.globl vector158
vector158:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $158
c0102561:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102566:	e9 8c 04 00 00       	jmp    c01029f7 <__alltraps>

c010256b <vector159>:
.globl vector159
vector159:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $159
c010256d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102572:	e9 80 04 00 00       	jmp    c01029f7 <__alltraps>

c0102577 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $160
c0102579:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010257e:	e9 74 04 00 00       	jmp    c01029f7 <__alltraps>

c0102583 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $161
c0102585:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010258a:	e9 68 04 00 00       	jmp    c01029f7 <__alltraps>

c010258f <vector162>:
.globl vector162
vector162:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $162
c0102591:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102596:	e9 5c 04 00 00       	jmp    c01029f7 <__alltraps>

c010259b <vector163>:
.globl vector163
vector163:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $163
c010259d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025a2:	e9 50 04 00 00       	jmp    c01029f7 <__alltraps>

c01025a7 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $164
c01025a9:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025ae:	e9 44 04 00 00       	jmp    c01029f7 <__alltraps>

c01025b3 <vector165>:
.globl vector165
vector165:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $165
c01025b5:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025ba:	e9 38 04 00 00       	jmp    c01029f7 <__alltraps>

c01025bf <vector166>:
.globl vector166
vector166:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $166
c01025c1:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025c6:	e9 2c 04 00 00       	jmp    c01029f7 <__alltraps>

c01025cb <vector167>:
.globl vector167
vector167:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $167
c01025cd:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025d2:	e9 20 04 00 00       	jmp    c01029f7 <__alltraps>

c01025d7 <vector168>:
.globl vector168
vector168:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $168
c01025d9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025de:	e9 14 04 00 00       	jmp    c01029f7 <__alltraps>

c01025e3 <vector169>:
.globl vector169
vector169:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $169
c01025e5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025ea:	e9 08 04 00 00       	jmp    c01029f7 <__alltraps>

c01025ef <vector170>:
.globl vector170
vector170:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $170
c01025f1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025f6:	e9 fc 03 00 00       	jmp    c01029f7 <__alltraps>

c01025fb <vector171>:
.globl vector171
vector171:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $171
c01025fd:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102602:	e9 f0 03 00 00       	jmp    c01029f7 <__alltraps>

c0102607 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $172
c0102609:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010260e:	e9 e4 03 00 00       	jmp    c01029f7 <__alltraps>

c0102613 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $173
c0102615:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010261a:	e9 d8 03 00 00       	jmp    c01029f7 <__alltraps>

c010261f <vector174>:
.globl vector174
vector174:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $174
c0102621:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102626:	e9 cc 03 00 00       	jmp    c01029f7 <__alltraps>

c010262b <vector175>:
.globl vector175
vector175:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $175
c010262d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102632:	e9 c0 03 00 00       	jmp    c01029f7 <__alltraps>

c0102637 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $176
c0102639:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010263e:	e9 b4 03 00 00       	jmp    c01029f7 <__alltraps>

c0102643 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $177
c0102645:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010264a:	e9 a8 03 00 00       	jmp    c01029f7 <__alltraps>

c010264f <vector178>:
.globl vector178
vector178:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $178
c0102651:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102656:	e9 9c 03 00 00       	jmp    c01029f7 <__alltraps>

c010265b <vector179>:
.globl vector179
vector179:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $179
c010265d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102662:	e9 90 03 00 00       	jmp    c01029f7 <__alltraps>

c0102667 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $180
c0102669:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010266e:	e9 84 03 00 00       	jmp    c01029f7 <__alltraps>

c0102673 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $181
c0102675:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010267a:	e9 78 03 00 00       	jmp    c01029f7 <__alltraps>

c010267f <vector182>:
.globl vector182
vector182:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $182
c0102681:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102686:	e9 6c 03 00 00       	jmp    c01029f7 <__alltraps>

c010268b <vector183>:
.globl vector183
vector183:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $183
c010268d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102692:	e9 60 03 00 00       	jmp    c01029f7 <__alltraps>

c0102697 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $184
c0102699:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010269e:	e9 54 03 00 00       	jmp    c01029f7 <__alltraps>

c01026a3 <vector185>:
.globl vector185
vector185:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $185
c01026a5:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026aa:	e9 48 03 00 00       	jmp    c01029f7 <__alltraps>

c01026af <vector186>:
.globl vector186
vector186:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $186
c01026b1:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026b6:	e9 3c 03 00 00       	jmp    c01029f7 <__alltraps>

c01026bb <vector187>:
.globl vector187
vector187:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $187
c01026bd:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026c2:	e9 30 03 00 00       	jmp    c01029f7 <__alltraps>

c01026c7 <vector188>:
.globl vector188
vector188:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $188
c01026c9:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026ce:	e9 24 03 00 00       	jmp    c01029f7 <__alltraps>

c01026d3 <vector189>:
.globl vector189
vector189:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $189
c01026d5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026da:	e9 18 03 00 00       	jmp    c01029f7 <__alltraps>

c01026df <vector190>:
.globl vector190
vector190:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $190
c01026e1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026e6:	e9 0c 03 00 00       	jmp    c01029f7 <__alltraps>

c01026eb <vector191>:
.globl vector191
vector191:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $191
c01026ed:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01026f2:	e9 00 03 00 00       	jmp    c01029f7 <__alltraps>

c01026f7 <vector192>:
.globl vector192
vector192:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $192
c01026f9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026fe:	e9 f4 02 00 00       	jmp    c01029f7 <__alltraps>

c0102703 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $193
c0102705:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010270a:	e9 e8 02 00 00       	jmp    c01029f7 <__alltraps>

c010270f <vector194>:
.globl vector194
vector194:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $194
c0102711:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102716:	e9 dc 02 00 00       	jmp    c01029f7 <__alltraps>

c010271b <vector195>:
.globl vector195
vector195:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $195
c010271d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102722:	e9 d0 02 00 00       	jmp    c01029f7 <__alltraps>

c0102727 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $196
c0102729:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010272e:	e9 c4 02 00 00       	jmp    c01029f7 <__alltraps>

c0102733 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $197
c0102735:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010273a:	e9 b8 02 00 00       	jmp    c01029f7 <__alltraps>

c010273f <vector198>:
.globl vector198
vector198:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $198
c0102741:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102746:	e9 ac 02 00 00       	jmp    c01029f7 <__alltraps>

c010274b <vector199>:
.globl vector199
vector199:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $199
c010274d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102752:	e9 a0 02 00 00       	jmp    c01029f7 <__alltraps>

c0102757 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $200
c0102759:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010275e:	e9 94 02 00 00       	jmp    c01029f7 <__alltraps>

c0102763 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $201
c0102765:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010276a:	e9 88 02 00 00       	jmp    c01029f7 <__alltraps>

c010276f <vector202>:
.globl vector202
vector202:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $202
c0102771:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102776:	e9 7c 02 00 00       	jmp    c01029f7 <__alltraps>

c010277b <vector203>:
.globl vector203
vector203:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $203
c010277d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102782:	e9 70 02 00 00       	jmp    c01029f7 <__alltraps>

c0102787 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $204
c0102789:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010278e:	e9 64 02 00 00       	jmp    c01029f7 <__alltraps>

c0102793 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $205
c0102795:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010279a:	e9 58 02 00 00       	jmp    c01029f7 <__alltraps>

c010279f <vector206>:
.globl vector206
vector206:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $206
c01027a1:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027a6:	e9 4c 02 00 00       	jmp    c01029f7 <__alltraps>

c01027ab <vector207>:
.globl vector207
vector207:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $207
c01027ad:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027b2:	e9 40 02 00 00       	jmp    c01029f7 <__alltraps>

c01027b7 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $208
c01027b9:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027be:	e9 34 02 00 00       	jmp    c01029f7 <__alltraps>

c01027c3 <vector209>:
.globl vector209
vector209:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $209
c01027c5:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027ca:	e9 28 02 00 00       	jmp    c01029f7 <__alltraps>

c01027cf <vector210>:
.globl vector210
vector210:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $210
c01027d1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027d6:	e9 1c 02 00 00       	jmp    c01029f7 <__alltraps>

c01027db <vector211>:
.globl vector211
vector211:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $211
c01027dd:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027e2:	e9 10 02 00 00       	jmp    c01029f7 <__alltraps>

c01027e7 <vector212>:
.globl vector212
vector212:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $212
c01027e9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027ee:	e9 04 02 00 00       	jmp    c01029f7 <__alltraps>

c01027f3 <vector213>:
.globl vector213
vector213:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $213
c01027f5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027fa:	e9 f8 01 00 00       	jmp    c01029f7 <__alltraps>

c01027ff <vector214>:
.globl vector214
vector214:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $214
c0102801:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102806:	e9 ec 01 00 00       	jmp    c01029f7 <__alltraps>

c010280b <vector215>:
.globl vector215
vector215:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $215
c010280d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102812:	e9 e0 01 00 00       	jmp    c01029f7 <__alltraps>

c0102817 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $216
c0102819:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010281e:	e9 d4 01 00 00       	jmp    c01029f7 <__alltraps>

c0102823 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $217
c0102825:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010282a:	e9 c8 01 00 00       	jmp    c01029f7 <__alltraps>

c010282f <vector218>:
.globl vector218
vector218:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $218
c0102831:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102836:	e9 bc 01 00 00       	jmp    c01029f7 <__alltraps>

c010283b <vector219>:
.globl vector219
vector219:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $219
c010283d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102842:	e9 b0 01 00 00       	jmp    c01029f7 <__alltraps>

c0102847 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $220
c0102849:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010284e:	e9 a4 01 00 00       	jmp    c01029f7 <__alltraps>

c0102853 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $221
c0102855:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010285a:	e9 98 01 00 00       	jmp    c01029f7 <__alltraps>

c010285f <vector222>:
.globl vector222
vector222:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $222
c0102861:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102866:	e9 8c 01 00 00       	jmp    c01029f7 <__alltraps>

c010286b <vector223>:
.globl vector223
vector223:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $223
c010286d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102872:	e9 80 01 00 00       	jmp    c01029f7 <__alltraps>

c0102877 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $224
c0102879:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010287e:	e9 74 01 00 00       	jmp    c01029f7 <__alltraps>

c0102883 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $225
c0102885:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010288a:	e9 68 01 00 00       	jmp    c01029f7 <__alltraps>

c010288f <vector226>:
.globl vector226
vector226:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $226
c0102891:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102896:	e9 5c 01 00 00       	jmp    c01029f7 <__alltraps>

c010289b <vector227>:
.globl vector227
vector227:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $227
c010289d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028a2:	e9 50 01 00 00       	jmp    c01029f7 <__alltraps>

c01028a7 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $228
c01028a9:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028ae:	e9 44 01 00 00       	jmp    c01029f7 <__alltraps>

c01028b3 <vector229>:
.globl vector229
vector229:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $229
c01028b5:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028ba:	e9 38 01 00 00       	jmp    c01029f7 <__alltraps>

c01028bf <vector230>:
.globl vector230
vector230:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $230
c01028c1:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028c6:	e9 2c 01 00 00       	jmp    c01029f7 <__alltraps>

c01028cb <vector231>:
.globl vector231
vector231:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $231
c01028cd:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028d2:	e9 20 01 00 00       	jmp    c01029f7 <__alltraps>

c01028d7 <vector232>:
.globl vector232
vector232:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $232
c01028d9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028de:	e9 14 01 00 00       	jmp    c01029f7 <__alltraps>

c01028e3 <vector233>:
.globl vector233
vector233:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $233
c01028e5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028ea:	e9 08 01 00 00       	jmp    c01029f7 <__alltraps>

c01028ef <vector234>:
.globl vector234
vector234:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $234
c01028f1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028f6:	e9 fc 00 00 00       	jmp    c01029f7 <__alltraps>

c01028fb <vector235>:
.globl vector235
vector235:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $235
c01028fd:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102902:	e9 f0 00 00 00       	jmp    c01029f7 <__alltraps>

c0102907 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $236
c0102909:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010290e:	e9 e4 00 00 00       	jmp    c01029f7 <__alltraps>

c0102913 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $237
c0102915:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010291a:	e9 d8 00 00 00       	jmp    c01029f7 <__alltraps>

c010291f <vector238>:
.globl vector238
vector238:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $238
c0102921:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102926:	e9 cc 00 00 00       	jmp    c01029f7 <__alltraps>

c010292b <vector239>:
.globl vector239
vector239:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $239
c010292d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102932:	e9 c0 00 00 00       	jmp    c01029f7 <__alltraps>

c0102937 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $240
c0102939:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010293e:	e9 b4 00 00 00       	jmp    c01029f7 <__alltraps>

c0102943 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $241
c0102945:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010294a:	e9 a8 00 00 00       	jmp    c01029f7 <__alltraps>

c010294f <vector242>:
.globl vector242
vector242:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $242
c0102951:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102956:	e9 9c 00 00 00       	jmp    c01029f7 <__alltraps>

c010295b <vector243>:
.globl vector243
vector243:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $243
c010295d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102962:	e9 90 00 00 00       	jmp    c01029f7 <__alltraps>

c0102967 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $244
c0102969:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010296e:	e9 84 00 00 00       	jmp    c01029f7 <__alltraps>

c0102973 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $245
c0102975:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010297a:	e9 78 00 00 00       	jmp    c01029f7 <__alltraps>

c010297f <vector246>:
.globl vector246
vector246:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $246
c0102981:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102986:	e9 6c 00 00 00       	jmp    c01029f7 <__alltraps>

c010298b <vector247>:
.globl vector247
vector247:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $247
c010298d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102992:	e9 60 00 00 00       	jmp    c01029f7 <__alltraps>

c0102997 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $248
c0102999:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010299e:	e9 54 00 00 00       	jmp    c01029f7 <__alltraps>

c01029a3 <vector249>:
.globl vector249
vector249:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $249
c01029a5:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029aa:	e9 48 00 00 00       	jmp    c01029f7 <__alltraps>

c01029af <vector250>:
.globl vector250
vector250:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $250
c01029b1:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029b6:	e9 3c 00 00 00       	jmp    c01029f7 <__alltraps>

c01029bb <vector251>:
.globl vector251
vector251:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $251
c01029bd:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029c2:	e9 30 00 00 00       	jmp    c01029f7 <__alltraps>

c01029c7 <vector252>:
.globl vector252
vector252:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $252
c01029c9:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029ce:	e9 24 00 00 00       	jmp    c01029f7 <__alltraps>

c01029d3 <vector253>:
.globl vector253
vector253:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $253
c01029d5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029da:	e9 18 00 00 00       	jmp    c01029f7 <__alltraps>

c01029df <vector254>:
.globl vector254
vector254:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $254
c01029e1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029e6:	e9 0c 00 00 00       	jmp    c01029f7 <__alltraps>

c01029eb <vector255>:
.globl vector255
vector255:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $255
c01029ed:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01029f2:	e9 00 00 00 00       	jmp    c01029f7 <__alltraps>

c01029f7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029f7:	1e                   	push   %ds
    pushl %es
c01029f8:	06                   	push   %es
    pushl %fs
c01029f9:	0f a0                	push   %fs
    pushl %gs
c01029fb:	0f a8                	push   %gs
    pushal
c01029fd:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029fe:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a03:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a05:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a07:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a08:	e8 64 f5 ff ff       	call   c0101f71 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a0d:	5c                   	pop    %esp

c0102a0e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a0e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a0f:	0f a9                	pop    %gs
    popl %fs
c0102a11:	0f a1                	pop    %fs
    popl %es
c0102a13:	07                   	pop    %es
    popl %ds
c0102a14:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a15:	83 c4 08             	add    $0x8,%esp
    iret
c0102a18:	cf                   	iret   

c0102a19 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a19:	55                   	push   %ebp
c0102a1a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1f:	8b 15 78 af 11 c0    	mov    0xc011af78,%edx
c0102a25:	29 d0                	sub    %edx,%eax
c0102a27:	c1 f8 02             	sar    $0x2,%eax
c0102a2a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a30:	5d                   	pop    %ebp
c0102a31:	c3                   	ret    

c0102a32 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a32:	55                   	push   %ebp
c0102a33:	89 e5                	mov    %esp,%ebp
c0102a35:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3b:	89 04 24             	mov    %eax,(%esp)
c0102a3e:	e8 d6 ff ff ff       	call   c0102a19 <page2ppn>
c0102a43:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a46:	c9                   	leave  
c0102a47:	c3                   	ret    

c0102a48 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102a48:	55                   	push   %ebp
c0102a49:	89 e5                	mov    %esp,%ebp
c0102a4b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a51:	c1 e8 0c             	shr    $0xc,%eax
c0102a54:	89 c2                	mov    %eax,%edx
c0102a56:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102a5b:	39 c2                	cmp    %eax,%edx
c0102a5d:	72 1c                	jb     c0102a7b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102a5f:	c7 44 24 08 50 66 10 	movl   $0xc0106650,0x8(%esp)
c0102a66:	c0 
c0102a67:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102a6e:	00 
c0102a6f:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102a76:	e8 7e d9 ff ff       	call   c01003f9 <__panic>
    }
    return &pages[PPN(pa)];
c0102a7b:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0102a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a84:	c1 e8 0c             	shr    $0xc,%eax
c0102a87:	89 c2                	mov    %eax,%edx
c0102a89:	89 d0                	mov    %edx,%eax
c0102a8b:	c1 e0 02             	shl    $0x2,%eax
c0102a8e:	01 d0                	add    %edx,%eax
c0102a90:	c1 e0 02             	shl    $0x2,%eax
c0102a93:	01 c8                	add    %ecx,%eax
}
c0102a95:	c9                   	leave  
c0102a96:	c3                   	ret    

c0102a97 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102a97:	55                   	push   %ebp
c0102a98:	89 e5                	mov    %esp,%ebp
c0102a9a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa0:	89 04 24             	mov    %eax,(%esp)
c0102aa3:	e8 8a ff ff ff       	call   c0102a32 <page2pa>
c0102aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aae:	c1 e8 0c             	shr    $0xc,%eax
c0102ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ab4:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102ab9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102abc:	72 23                	jb     c0102ae1 <page2kva+0x4a>
c0102abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102ac5:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0102acc:	c0 
c0102acd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102ad4:	00 
c0102ad5:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102adc:	e8 18 d9 ff ff       	call   c01003f9 <__panic>
c0102ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102ae9:	c9                   	leave  
c0102aea:	c3                   	ret    

c0102aeb <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102aeb:	55                   	push   %ebp
c0102aec:	89 e5                	mov    %esp,%ebp
c0102aee:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af4:	83 e0 01             	and    $0x1,%eax
c0102af7:	85 c0                	test   %eax,%eax
c0102af9:	75 1c                	jne    c0102b17 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102afb:	c7 44 24 08 a4 66 10 	movl   $0xc01066a4,0x8(%esp)
c0102b02:	c0 
c0102b03:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102b0a:	00 
c0102b0b:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102b12:	e8 e2 d8 ff ff       	call   c01003f9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b1f:	89 04 24             	mov    %eax,(%esp)
c0102b22:	e8 21 ff ff ff       	call   c0102a48 <pa2page>
}
c0102b27:	c9                   	leave  
c0102b28:	c3                   	ret    

c0102b29 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102b29:	55                   	push   %ebp
c0102b2a:	89 e5                	mov    %esp,%ebp
c0102b2c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b37:	89 04 24             	mov    %eax,(%esp)
c0102b3a:	e8 09 ff ff ff       	call   c0102a48 <pa2page>
}
c0102b3f:	c9                   	leave  
c0102b40:	c3                   	ret    

c0102b41 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102b41:	55                   	push   %ebp
c0102b42:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b47:	8b 00                	mov    (%eax),%eax
}
c0102b49:	5d                   	pop    %ebp
c0102b4a:	c3                   	ret    

c0102b4b <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102b4b:	55                   	push   %ebp
c0102b4c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b51:	8b 00                	mov    (%eax),%eax
c0102b53:	8d 50 01             	lea    0x1(%eax),%edx
c0102b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b59:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b5e:	8b 00                	mov    (%eax),%eax
}
c0102b60:	5d                   	pop    %ebp
c0102b61:	c3                   	ret    

c0102b62 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b62:	55                   	push   %ebp
c0102b63:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b68:	8b 00                	mov    (%eax),%eax
c0102b6a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b70:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b75:	8b 00                	mov    (%eax),%eax
}
c0102b77:	5d                   	pop    %ebp
c0102b78:	c3                   	ret    

c0102b79 <__intr_save>:
__intr_save(void) {
c0102b79:	55                   	push   %ebp
c0102b7a:	89 e5                	mov    %esp,%ebp
c0102b7c:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102b7f:	9c                   	pushf  
c0102b80:	58                   	pop    %eax
c0102b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102b87:	25 00 02 00 00       	and    $0x200,%eax
c0102b8c:	85 c0                	test   %eax,%eax
c0102b8e:	74 0c                	je     c0102b9c <__intr_save+0x23>
        intr_disable();
c0102b90:	e8 08 ed ff ff       	call   c010189d <intr_disable>
        return 1;
c0102b95:	b8 01 00 00 00       	mov    $0x1,%eax
c0102b9a:	eb 05                	jmp    c0102ba1 <__intr_save+0x28>
    return 0;
c0102b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ba1:	c9                   	leave  
c0102ba2:	c3                   	ret    

c0102ba3 <__intr_restore>:
__intr_restore(bool flag) {
c0102ba3:	55                   	push   %ebp
c0102ba4:	89 e5                	mov    %esp,%ebp
c0102ba6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102ba9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bad:	74 05                	je     c0102bb4 <__intr_restore+0x11>
        intr_enable();
c0102baf:	e8 e2 ec ff ff       	call   c0101896 <intr_enable>
}
c0102bb4:	90                   	nop
c0102bb5:	c9                   	leave  
c0102bb6:	c3                   	ret    

c0102bb7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102bb7:	55                   	push   %ebp
c0102bb8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbd:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102bc0:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bc5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102bc7:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bcc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102bce:	b8 10 00 00 00       	mov    $0x10,%eax
c0102bd3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102bd5:	b8 10 00 00 00       	mov    $0x10,%eax
c0102bda:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102bdc:	b8 10 00 00 00       	mov    $0x10,%eax
c0102be1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102be3:	ea ea 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102bea
}
c0102bea:	90                   	nop
c0102beb:	5d                   	pop    %ebp
c0102bec:	c3                   	ret    

c0102bed <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102bed:	55                   	push   %ebp
c0102bee:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bf3:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0102bf8:	90                   	nop
c0102bf9:	5d                   	pop    %ebp
c0102bfa:	c3                   	ret    

c0102bfb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102bfb:	55                   	push   %ebp
c0102bfc:	89 e5                	mov    %esp,%ebp
c0102bfe:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102c01:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102c06:	89 04 24             	mov    %eax,(%esp)
c0102c09:	e8 df ff ff ff       	call   c0102bed <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102c0e:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0102c15:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102c17:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102c1e:	68 00 
c0102c20:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102c25:	0f b7 c0             	movzwl %ax,%eax
c0102c28:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102c2e:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102c33:	c1 e8 10             	shr    $0x10,%eax
c0102c36:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102c3b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c42:	24 f0                	and    $0xf0,%al
c0102c44:	0c 09                	or     $0x9,%al
c0102c46:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c4b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c52:	24 ef                	and    $0xef,%al
c0102c54:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c59:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c60:	24 9f                	and    $0x9f,%al
c0102c62:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c67:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c6e:	0c 80                	or     $0x80,%al
c0102c70:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c75:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c7c:	24 f0                	and    $0xf0,%al
c0102c7e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c83:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c8a:	24 ef                	and    $0xef,%al
c0102c8c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c91:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c98:	24 df                	and    $0xdf,%al
c0102c9a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c9f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ca6:	0c 40                	or     $0x40,%al
c0102ca8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102cad:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102cb4:	24 7f                	and    $0x7f,%al
c0102cb6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102cbb:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102cc0:	c1 e8 18             	shr    $0x18,%eax
c0102cc3:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102cc8:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102ccf:	e8 e3 fe ff ff       	call   c0102bb7 <lgdt>
c0102cd4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102cda:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102cde:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102ce1:	90                   	nop
c0102ce2:	c9                   	leave  
c0102ce3:	c3                   	ret    

c0102ce4 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102ce4:	55                   	push   %ebp
c0102ce5:	89 e5                	mov    %esp,%ebp
c0102ce7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102cea:	c7 05 70 af 11 c0 60 	movl   $0xc0107060,0xc011af70
c0102cf1:	70 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102cf4:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102cf9:	8b 00                	mov    (%eax),%eax
c0102cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cff:	c7 04 24 d0 66 10 c0 	movl   $0xc01066d0,(%esp)
c0102d06:	e8 97 d5 ff ff       	call   c01002a2 <cprintf>
    pmm_manager->init();
c0102d0b:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d10:	8b 40 04             	mov    0x4(%eax),%eax
c0102d13:	ff d0                	call   *%eax
}
c0102d15:	90                   	nop
c0102d16:	c9                   	leave  
c0102d17:	c3                   	ret    

c0102d18 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102d18:	55                   	push   %ebp
c0102d19:	89 e5                	mov    %esp,%ebp
c0102d1b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102d1e:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d23:	8b 40 08             	mov    0x8(%eax),%eax
c0102d26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d29:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d2d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d30:	89 14 24             	mov    %edx,(%esp)
c0102d33:	ff d0                	call   *%eax
}
c0102d35:	90                   	nop
c0102d36:	c9                   	leave  
c0102d37:	c3                   	ret    

c0102d38 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102d38:	55                   	push   %ebp
c0102d39:	89 e5                	mov    %esp,%ebp
c0102d3b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d45:	e8 2f fe ff ff       	call   c0102b79 <__intr_save>
c0102d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102d4d:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d52:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d55:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d58:	89 14 24             	mov    %edx,(%esp)
c0102d5b:	ff d0                	call   *%eax
c0102d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d63:	89 04 24             	mov    %eax,(%esp)
c0102d66:	e8 38 fe ff ff       	call   c0102ba3 <__intr_restore>
    return page;
c0102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d6e:	c9                   	leave  
c0102d6f:	c3                   	ret    

c0102d70 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102d70:	55                   	push   %ebp
c0102d71:	89 e5                	mov    %esp,%ebp
c0102d73:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d76:	e8 fe fd ff ff       	call   c0102b79 <__intr_save>
c0102d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d7e:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d83:	8b 40 10             	mov    0x10(%eax),%eax
c0102d86:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d89:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d90:	89 14 24             	mov    %edx,(%esp)
c0102d93:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d98:	89 04 24             	mov    %eax,(%esp)
c0102d9b:	e8 03 fe ff ff       	call   c0102ba3 <__intr_restore>
}
c0102da0:	90                   	nop
c0102da1:	c9                   	leave  
c0102da2:	c3                   	ret    

c0102da3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102da3:	55                   	push   %ebp
c0102da4:	89 e5                	mov    %esp,%ebp
c0102da6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102da9:	e8 cb fd ff ff       	call   c0102b79 <__intr_save>
c0102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102db1:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102db6:	8b 40 14             	mov    0x14(%eax),%eax
c0102db9:	ff d0                	call   *%eax
c0102dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc1:	89 04 24             	mov    %eax,(%esp)
c0102dc4:	e8 da fd ff ff       	call   c0102ba3 <__intr_restore>
    return ret;
c0102dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102dcc:	c9                   	leave  
c0102dcd:	c3                   	ret    

c0102dce <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102dce:	55                   	push   %ebp
c0102dcf:	89 e5                	mov    %esp,%ebp
c0102dd1:	57                   	push   %edi
c0102dd2:	56                   	push   %esi
c0102dd3:	53                   	push   %ebx
c0102dd4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102dda:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102de1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102de8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102def:	c7 04 24 e7 66 10 c0 	movl   $0xc01066e7,(%esp)
c0102df6:	e8 a7 d4 ff ff       	call   c01002a2 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102dfb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e02:	e9 22 01 00 00       	jmp    c0102f29 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e0d:	89 d0                	mov    %edx,%eax
c0102e0f:	c1 e0 02             	shl    $0x2,%eax
c0102e12:	01 d0                	add    %edx,%eax
c0102e14:	c1 e0 02             	shl    $0x2,%eax
c0102e17:	01 c8                	add    %ecx,%eax
c0102e19:	8b 50 08             	mov    0x8(%eax),%edx
c0102e1c:	8b 40 04             	mov    0x4(%eax),%eax
c0102e1f:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102e22:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e25:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e28:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e2b:	89 d0                	mov    %edx,%eax
c0102e2d:	c1 e0 02             	shl    $0x2,%eax
c0102e30:	01 d0                	add    %edx,%eax
c0102e32:	c1 e0 02             	shl    $0x2,%eax
c0102e35:	01 c8                	add    %ecx,%eax
c0102e37:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e3a:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e3d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e40:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e43:	01 c8                	add    %ecx,%eax
c0102e45:	11 da                	adc    %ebx,%edx
c0102e47:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e4a:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102e4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e53:	89 d0                	mov    %edx,%eax
c0102e55:	c1 e0 02             	shl    $0x2,%eax
c0102e58:	01 d0                	add    %edx,%eax
c0102e5a:	c1 e0 02             	shl    $0x2,%eax
c0102e5d:	01 c8                	add    %ecx,%eax
c0102e5f:	83 c0 14             	add    $0x14,%eax
c0102e62:	8b 00                	mov    (%eax),%eax
c0102e64:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102e67:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e6a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e6d:	83 c0 ff             	add    $0xffffffff,%eax
c0102e70:	83 d2 ff             	adc    $0xffffffff,%edx
c0102e73:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102e79:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102e7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e85:	89 d0                	mov    %edx,%eax
c0102e87:	c1 e0 02             	shl    $0x2,%eax
c0102e8a:	01 d0                	add    %edx,%eax
c0102e8c:	c1 e0 02             	shl    $0x2,%eax
c0102e8f:	01 c8                	add    %ecx,%eax
c0102e91:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e94:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e97:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e9a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102e9e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102ea4:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102eaa:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102eae:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102eb2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102eb5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102eb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102ebc:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102ec0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102ec4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102ec8:	c7 04 24 f4 66 10 c0 	movl   $0xc01066f4,(%esp)
c0102ecf:	e8 ce d3 ff ff       	call   c01002a2 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102ed4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ed7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eda:	89 d0                	mov    %edx,%eax
c0102edc:	c1 e0 02             	shl    $0x2,%eax
c0102edf:	01 d0                	add    %edx,%eax
c0102ee1:	c1 e0 02             	shl    $0x2,%eax
c0102ee4:	01 c8                	add    %ecx,%eax
c0102ee6:	83 c0 14             	add    $0x14,%eax
c0102ee9:	8b 00                	mov    (%eax),%eax
c0102eeb:	83 f8 01             	cmp    $0x1,%eax
c0102eee:	75 36                	jne    c0102f26 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0102ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ef3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ef6:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102ef9:	77 2b                	ja     c0102f26 <page_init+0x158>
c0102efb:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102efe:	72 05                	jb     c0102f05 <page_init+0x137>
c0102f00:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102f03:	73 21                	jae    c0102f26 <page_init+0x158>
c0102f05:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102f09:	77 1b                	ja     c0102f26 <page_init+0x158>
c0102f0b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102f0f:	72 09                	jb     c0102f1a <page_init+0x14c>
c0102f11:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102f18:	77 0c                	ja     c0102f26 <page_init+0x158>
                maxpa = end;
c0102f1a:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f1d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102f20:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102f23:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f26:	ff 45 dc             	incl   -0x24(%ebp)
c0102f29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f2c:	8b 00                	mov    (%eax),%eax
c0102f2e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102f31:	0f 8c d0 fe ff ff    	jl     c0102e07 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102f37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f3b:	72 1d                	jb     c0102f5a <page_init+0x18c>
c0102f3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102f41:	77 09                	ja     c0102f4c <page_init+0x17e>
c0102f43:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102f4a:	76 0e                	jbe    c0102f5a <page_init+0x18c>
        maxpa = KMEMSIZE;
c0102f4c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102f53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f60:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f64:	c1 ea 0c             	shr    $0xc,%edx
c0102f67:	89 c1                	mov    %eax,%ecx
c0102f69:	89 d3                	mov    %edx,%ebx
c0102f6b:	89 c8                	mov    %ecx,%eax
c0102f6d:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102f72:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102f79:	b8 88 af 11 c0       	mov    $0xc011af88,%eax
c0102f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102f81:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102f84:	01 d0                	add    %edx,%eax
c0102f86:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102f89:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f8c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f91:	f7 75 c0             	divl   -0x40(%ebp)
c0102f94:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f97:	29 d0                	sub    %edx,%eax
c0102f99:	a3 78 af 11 c0       	mov    %eax,0xc011af78

    for (i = 0; i < npage; i ++) {
c0102f9e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fa5:	eb 2e                	jmp    c0102fd5 <page_init+0x207>
        SetPageReserved(pages + i);
c0102fa7:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0102fad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fb0:	89 d0                	mov    %edx,%eax
c0102fb2:	c1 e0 02             	shl    $0x2,%eax
c0102fb5:	01 d0                	add    %edx,%eax
c0102fb7:	c1 e0 02             	shl    $0x2,%eax
c0102fba:	01 c8                	add    %ecx,%eax
c0102fbc:	83 c0 04             	add    $0x4,%eax
c0102fbf:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102fc6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102fc9:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fcc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102fcf:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102fd2:	ff 45 dc             	incl   -0x24(%ebp)
c0102fd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fd8:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102fdd:	39 c2                	cmp    %eax,%edx
c0102fdf:	72 c6                	jb     c0102fa7 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102fe1:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102fe7:	89 d0                	mov    %edx,%eax
c0102fe9:	c1 e0 02             	shl    $0x2,%eax
c0102fec:	01 d0                	add    %edx,%eax
c0102fee:	c1 e0 02             	shl    $0x2,%eax
c0102ff1:	89 c2                	mov    %eax,%edx
c0102ff3:	a1 78 af 11 c0       	mov    0xc011af78,%eax
c0102ff8:	01 d0                	add    %edx,%eax
c0102ffa:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102ffd:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103004:	77 23                	ja     c0103029 <page_init+0x25b>
c0103006:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103009:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010300d:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103014:	c0 
c0103015:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010301c:	00 
c010301d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103024:	e8 d0 d3 ff ff       	call   c01003f9 <__panic>
c0103029:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010302c:	05 00 00 00 40       	add    $0x40000000,%eax
c0103031:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103034:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010303b:	e9 69 01 00 00       	jmp    c01031a9 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103040:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103043:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103046:	89 d0                	mov    %edx,%eax
c0103048:	c1 e0 02             	shl    $0x2,%eax
c010304b:	01 d0                	add    %edx,%eax
c010304d:	c1 e0 02             	shl    $0x2,%eax
c0103050:	01 c8                	add    %ecx,%eax
c0103052:	8b 50 08             	mov    0x8(%eax),%edx
c0103055:	8b 40 04             	mov    0x4(%eax),%eax
c0103058:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010305b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010305e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103061:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103064:	89 d0                	mov    %edx,%eax
c0103066:	c1 e0 02             	shl    $0x2,%eax
c0103069:	01 d0                	add    %edx,%eax
c010306b:	c1 e0 02             	shl    $0x2,%eax
c010306e:	01 c8                	add    %ecx,%eax
c0103070:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103073:	8b 58 10             	mov    0x10(%eax),%ebx
c0103076:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010307c:	01 c8                	add    %ecx,%eax
c010307e:	11 da                	adc    %ebx,%edx
c0103080:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103083:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103086:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103089:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010308c:	89 d0                	mov    %edx,%eax
c010308e:	c1 e0 02             	shl    $0x2,%eax
c0103091:	01 d0                	add    %edx,%eax
c0103093:	c1 e0 02             	shl    $0x2,%eax
c0103096:	01 c8                	add    %ecx,%eax
c0103098:	83 c0 14             	add    $0x14,%eax
c010309b:	8b 00                	mov    (%eax),%eax
c010309d:	83 f8 01             	cmp    $0x1,%eax
c01030a0:	0f 85 00 01 00 00    	jne    c01031a6 <page_init+0x3d8>
            if (begin < freemem) {
c01030a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01030ae:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01030b1:	77 17                	ja     c01030ca <page_init+0x2fc>
c01030b3:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01030b6:	72 05                	jb     c01030bd <page_init+0x2ef>
c01030b8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01030bb:	73 0d                	jae    c01030ca <page_init+0x2fc>
                begin = freemem;
c01030bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030c3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01030ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01030ce:	72 1d                	jb     c01030ed <page_init+0x31f>
c01030d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01030d4:	77 09                	ja     c01030df <page_init+0x311>
c01030d6:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01030dd:	76 0e                	jbe    c01030ed <page_init+0x31f>
                end = KMEMSIZE;
c01030df:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01030e6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01030ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030f3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030f6:	0f 87 aa 00 00 00    	ja     c01031a6 <page_init+0x3d8>
c01030fc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030ff:	72 09                	jb     c010310a <page_init+0x33c>
c0103101:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103104:	0f 83 9c 00 00 00    	jae    c01031a6 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c010310a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103111:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103114:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103117:	01 d0                	add    %edx,%eax
c0103119:	48                   	dec    %eax
c010311a:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010311d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103120:	ba 00 00 00 00       	mov    $0x0,%edx
c0103125:	f7 75 b0             	divl   -0x50(%ebp)
c0103128:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010312b:	29 d0                	sub    %edx,%eax
c010312d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103132:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103135:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103138:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010313b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010313e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103141:	ba 00 00 00 00       	mov    $0x0,%edx
c0103146:	89 c3                	mov    %eax,%ebx
c0103148:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010314e:	89 de                	mov    %ebx,%esi
c0103150:	89 d0                	mov    %edx,%eax
c0103152:	83 e0 00             	and    $0x0,%eax
c0103155:	89 c7                	mov    %eax,%edi
c0103157:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010315a:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010315d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103160:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103163:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103166:	77 3e                	ja     c01031a6 <page_init+0x3d8>
c0103168:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010316b:	72 05                	jb     c0103172 <page_init+0x3a4>
c010316d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103170:	73 34                	jae    c01031a6 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103172:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103175:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103178:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010317b:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010317e:	89 c1                	mov    %eax,%ecx
c0103180:	89 d3                	mov    %edx,%ebx
c0103182:	89 c8                	mov    %ecx,%eax
c0103184:	89 da                	mov    %ebx,%edx
c0103186:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010318a:	c1 ea 0c             	shr    $0xc,%edx
c010318d:	89 c3                	mov    %eax,%ebx
c010318f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103192:	89 04 24             	mov    %eax,(%esp)
c0103195:	e8 ae f8 ff ff       	call   c0102a48 <pa2page>
c010319a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010319e:	89 04 24             	mov    %eax,(%esp)
c01031a1:	e8 72 fb ff ff       	call   c0102d18 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01031a6:	ff 45 dc             	incl   -0x24(%ebp)
c01031a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01031ac:	8b 00                	mov    (%eax),%eax
c01031ae:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01031b1:	0f 8c 89 fe ff ff    	jl     c0103040 <page_init+0x272>
                }
            }
        }
    }
}
c01031b7:	90                   	nop
c01031b8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01031be:	5b                   	pop    %ebx
c01031bf:	5e                   	pop    %esi
c01031c0:	5f                   	pop    %edi
c01031c1:	5d                   	pop    %ebp
c01031c2:	c3                   	ret    

c01031c3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01031c3:	55                   	push   %ebp
c01031c4:	89 e5                	mov    %esp,%ebp
c01031c6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01031c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031cc:	33 45 14             	xor    0x14(%ebp),%eax
c01031cf:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031d4:	85 c0                	test   %eax,%eax
c01031d6:	74 24                	je     c01031fc <boot_map_segment+0x39>
c01031d8:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01031e7:	c0 
c01031e8:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01031ef:	00 
c01031f0:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01031f7:	e8 fd d1 ff ff       	call   c01003f9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01031fc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103203:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103206:	25 ff 0f 00 00       	and    $0xfff,%eax
c010320b:	89 c2                	mov    %eax,%edx
c010320d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103210:	01 c2                	add    %eax,%edx
c0103212:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103215:	01 d0                	add    %edx,%eax
c0103217:	48                   	dec    %eax
c0103218:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010321e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103223:	f7 75 f0             	divl   -0x10(%ebp)
c0103226:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103229:	29 d0                	sub    %edx,%eax
c010322b:	c1 e8 0c             	shr    $0xc,%eax
c010322e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103231:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103234:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103237:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010323a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010323f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103242:	8b 45 14             	mov    0x14(%ebp),%eax
c0103245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010324b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103250:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103253:	eb 68                	jmp    c01032bd <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103255:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010325c:	00 
c010325d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103260:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103264:	8b 45 08             	mov    0x8(%ebp),%eax
c0103267:	89 04 24             	mov    %eax,(%esp)
c010326a:	e8 81 01 00 00       	call   c01033f0 <get_pte>
c010326f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103272:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103276:	75 24                	jne    c010329c <boot_map_segment+0xd9>
c0103278:	c7 44 24 0c 82 67 10 	movl   $0xc0106782,0xc(%esp)
c010327f:	c0 
c0103280:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103287:	c0 
c0103288:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010328f:	00 
c0103290:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103297:	e8 5d d1 ff ff       	call   c01003f9 <__panic>
        *ptep = pa | PTE_P | perm;
c010329c:	8b 45 14             	mov    0x14(%ebp),%eax
c010329f:	0b 45 18             	or     0x18(%ebp),%eax
c01032a2:	83 c8 01             	or     $0x1,%eax
c01032a5:	89 c2                	mov    %eax,%edx
c01032a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032aa:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01032ac:	ff 4d f4             	decl   -0xc(%ebp)
c01032af:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01032b6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01032bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032c1:	75 92                	jne    c0103255 <boot_map_segment+0x92>
    }
}
c01032c3:	90                   	nop
c01032c4:	c9                   	leave  
c01032c5:	c3                   	ret    

c01032c6 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01032c6:	55                   	push   %ebp
c01032c7:	89 e5                	mov    %esp,%ebp
c01032c9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01032cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032d3:	e8 60 fa ff ff       	call   c0102d38 <alloc_pages>
c01032d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01032db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032df:	75 1c                	jne    c01032fd <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01032e1:	c7 44 24 08 8f 67 10 	movl   $0xc010678f,0x8(%esp)
c01032e8:	c0 
c01032e9:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01032f0:	00 
c01032f1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01032f8:	e8 fc d0 ff ff       	call   c01003f9 <__panic>
    }
    return page2kva(p);
c01032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103300:	89 04 24             	mov    %eax,(%esp)
c0103303:	e8 8f f7 ff ff       	call   c0102a97 <page2kva>
}
c0103308:	c9                   	leave  
c0103309:	c3                   	ret    

c010330a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010330a:	55                   	push   %ebp
c010330b:	89 e5                	mov    %esp,%ebp
c010330d:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103310:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103315:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103318:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010331f:	77 23                	ja     c0103344 <pmm_init+0x3a>
c0103321:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103328:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c010332f:	c0 
c0103330:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103337:	00 
c0103338:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010333f:	e8 b5 d0 ff ff       	call   c01003f9 <__panic>
c0103344:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103347:	05 00 00 00 40       	add    $0x40000000,%eax
c010334c:	a3 74 af 11 c0       	mov    %eax,0xc011af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103351:	e8 8e f9 ff ff       	call   c0102ce4 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103356:	e8 73 fa ff ff       	call   c0102dce <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010335b:	e8 4f 02 00 00       	call   c01035af <check_alloc_page>

    check_pgdir();
c0103360:	e8 69 02 00 00       	call   c01035ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103365:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010336a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010336d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103374:	77 23                	ja     c0103399 <pmm_init+0x8f>
c0103376:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103379:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010337d:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103384:	c0 
c0103385:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010338c:	00 
c010338d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103394:	e8 60 d0 ff ff       	call   c01003f9 <__panic>
c0103399:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010339c:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01033a2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01033a7:	05 ac 0f 00 00       	add    $0xfac,%eax
c01033ac:	83 ca 03             	or     $0x3,%edx
c01033af:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01033b1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01033b6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01033bd:	00 
c01033be:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01033c5:	00 
c01033c6:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01033cd:	38 
c01033ce:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01033d5:	c0 
c01033d6:	89 04 24             	mov    %eax,(%esp)
c01033d9:	e8 e5 fd ff ff       	call   c01031c3 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01033de:	e8 18 f8 ff ff       	call   c0102bfb <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01033e3:	e8 82 08 00 00       	call   c0103c6a <check_boot_pgdir>

    print_pgdir();
c01033e8:	e8 fb 0c 00 00       	call   c01040e8 <print_pgdir>

}
c01033ed:	90                   	nop
c01033ee:	c9                   	leave  
c01033ef:	c3                   	ret    

c01033f0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01033f0:	55                   	push   %ebp
c01033f1:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01033f3:	90                   	nop
c01033f4:	5d                   	pop    %ebp
c01033f5:	c3                   	ret    

c01033f6 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01033f6:	55                   	push   %ebp
c01033f7:	89 e5                	mov    %esp,%ebp
c01033f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103403:	00 
c0103404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103407:	89 44 24 04          	mov    %eax,0x4(%esp)
c010340b:	8b 45 08             	mov    0x8(%ebp),%eax
c010340e:	89 04 24             	mov    %eax,(%esp)
c0103411:	e8 da ff ff ff       	call   c01033f0 <get_pte>
c0103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010341d:	74 08                	je     c0103427 <get_page+0x31>
        *ptep_store = ptep;
c010341f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103422:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103425:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010342b:	74 1b                	je     c0103448 <get_page+0x52>
c010342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103430:	8b 00                	mov    (%eax),%eax
c0103432:	83 e0 01             	and    $0x1,%eax
c0103435:	85 c0                	test   %eax,%eax
c0103437:	74 0f                	je     c0103448 <get_page+0x52>
        return pte2page(*ptep);
c0103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343c:	8b 00                	mov    (%eax),%eax
c010343e:	89 04 24             	mov    %eax,(%esp)
c0103441:	e8 a5 f6 ff ff       	call   c0102aeb <pte2page>
c0103446:	eb 05                	jmp    c010344d <get_page+0x57>
    }
    return NULL;
c0103448:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010344d:	c9                   	leave  
c010344e:	c3                   	ret    

c010344f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010344f:	55                   	push   %ebp
c0103450:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103452:	90                   	nop
c0103453:	5d                   	pop    %ebp
c0103454:	c3                   	ret    

c0103455 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103455:	55                   	push   %ebp
c0103456:	89 e5                	mov    %esp,%ebp
c0103458:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010345b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103462:	00 
c0103463:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103466:	89 44 24 04          	mov    %eax,0x4(%esp)
c010346a:	8b 45 08             	mov    0x8(%ebp),%eax
c010346d:	89 04 24             	mov    %eax,(%esp)
c0103470:	e8 7b ff ff ff       	call   c01033f0 <get_pte>
c0103475:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0103478:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010347c:	74 19                	je     c0103497 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010347e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103481:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103485:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103488:	89 44 24 04          	mov    %eax,0x4(%esp)
c010348c:	8b 45 08             	mov    0x8(%ebp),%eax
c010348f:	89 04 24             	mov    %eax,(%esp)
c0103492:	e8 b8 ff ff ff       	call   c010344f <page_remove_pte>
    }
}
c0103497:	90                   	nop
c0103498:	c9                   	leave  
c0103499:	c3                   	ret    

c010349a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010349a:	55                   	push   %ebp
c010349b:	89 e5                	mov    %esp,%ebp
c010349d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01034a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01034a7:	00 
c01034a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01034ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034af:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b2:	89 04 24             	mov    %eax,(%esp)
c01034b5:	e8 36 ff ff ff       	call   c01033f0 <get_pte>
c01034ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034c1:	75 0a                	jne    c01034cd <page_insert+0x33>
        return -E_NO_MEM;
c01034c3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034c8:	e9 84 00 00 00       	jmp    c0103551 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034d0:	89 04 24             	mov    %eax,(%esp)
c01034d3:	e8 73 f6 ff ff       	call   c0102b4b <page_ref_inc>
    if (*ptep & PTE_P) {
c01034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034db:	8b 00                	mov    (%eax),%eax
c01034dd:	83 e0 01             	and    $0x1,%eax
c01034e0:	85 c0                	test   %eax,%eax
c01034e2:	74 3e                	je     c0103522 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e7:	8b 00                	mov    (%eax),%eax
c01034e9:	89 04 24             	mov    %eax,(%esp)
c01034ec:	e8 fa f5 ff ff       	call   c0102aeb <pte2page>
c01034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034fa:	75 0d                	jne    c0103509 <page_insert+0x6f>
            page_ref_dec(page);
c01034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034ff:	89 04 24             	mov    %eax,(%esp)
c0103502:	e8 5b f6 ff ff       	call   c0102b62 <page_ref_dec>
c0103507:	eb 19                	jmp    c0103522 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103509:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010350c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103510:	8b 45 10             	mov    0x10(%ebp),%eax
c0103513:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103517:	8b 45 08             	mov    0x8(%ebp),%eax
c010351a:	89 04 24             	mov    %eax,(%esp)
c010351d:	e8 2d ff ff ff       	call   c010344f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103525:	89 04 24             	mov    %eax,(%esp)
c0103528:	e8 05 f5 ff ff       	call   c0102a32 <page2pa>
c010352d:	0b 45 14             	or     0x14(%ebp),%eax
c0103530:	83 c8 01             	or     $0x1,%eax
c0103533:	89 c2                	mov    %eax,%edx
c0103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103538:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010353a:	8b 45 10             	mov    0x10(%ebp),%eax
c010353d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103541:	8b 45 08             	mov    0x8(%ebp),%eax
c0103544:	89 04 24             	mov    %eax,(%esp)
c0103547:	e8 07 00 00 00       	call   c0103553 <tlb_invalidate>
    return 0;
c010354c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103551:	c9                   	leave  
c0103552:	c3                   	ret    

c0103553 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103553:	55                   	push   %ebp
c0103554:	89 e5                	mov    %esp,%ebp
c0103556:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103559:	0f 20 d8             	mov    %cr3,%eax
c010355c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010355f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103562:	8b 45 08             	mov    0x8(%ebp),%eax
c0103565:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103568:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010356f:	77 23                	ja     c0103594 <tlb_invalidate+0x41>
c0103571:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103574:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103578:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c010357f:	c0 
c0103580:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c0103587:	00 
c0103588:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010358f:	e8 65 ce ff ff       	call   c01003f9 <__panic>
c0103594:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103597:	05 00 00 00 40       	add    $0x40000000,%eax
c010359c:	39 d0                	cmp    %edx,%eax
c010359e:	75 0c                	jne    c01035ac <tlb_invalidate+0x59>
        invlpg((void *)la);
c01035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01035a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035a9:	0f 01 38             	invlpg (%eax)
    }
}
c01035ac:	90                   	nop
c01035ad:	c9                   	leave  
c01035ae:	c3                   	ret    

c01035af <check_alloc_page>:

static void
check_alloc_page(void) {
c01035af:	55                   	push   %ebp
c01035b0:	89 e5                	mov    %esp,%ebp
c01035b2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01035b5:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c01035ba:	8b 40 18             	mov    0x18(%eax),%eax
c01035bd:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01035bf:	c7 04 24 a8 67 10 c0 	movl   $0xc01067a8,(%esp)
c01035c6:	e8 d7 cc ff ff       	call   c01002a2 <cprintf>
}
c01035cb:	90                   	nop
c01035cc:	c9                   	leave  
c01035cd:	c3                   	ret    

c01035ce <check_pgdir>:

static void
check_pgdir(void) {
c01035ce:	55                   	push   %ebp
c01035cf:	89 e5                	mov    %esp,%ebp
c01035d1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035d4:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01035d9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035de:	76 24                	jbe    c0103604 <check_pgdir+0x36>
c01035e0:	c7 44 24 0c c7 67 10 	movl   $0xc01067c7,0xc(%esp)
c01035e7:	c0 
c01035e8:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01035ef:	c0 
c01035f0:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c01035f7:	00 
c01035f8:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01035ff:	e8 f5 cd ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103604:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103609:	85 c0                	test   %eax,%eax
c010360b:	74 0e                	je     c010361b <check_pgdir+0x4d>
c010360d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103612:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103617:	85 c0                	test   %eax,%eax
c0103619:	74 24                	je     c010363f <check_pgdir+0x71>
c010361b:	c7 44 24 0c e4 67 10 	movl   $0xc01067e4,0xc(%esp)
c0103622:	c0 
c0103623:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010362a:	c0 
c010362b:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0103632:	00 
c0103633:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010363a:	e8 ba cd ff ff       	call   c01003f9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010363f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103644:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010364b:	00 
c010364c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103653:	00 
c0103654:	89 04 24             	mov    %eax,(%esp)
c0103657:	e8 9a fd ff ff       	call   c01033f6 <get_page>
c010365c:	85 c0                	test   %eax,%eax
c010365e:	74 24                	je     c0103684 <check_pgdir+0xb6>
c0103660:	c7 44 24 0c 1c 68 10 	movl   $0xc010681c,0xc(%esp)
c0103667:	c0 
c0103668:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010366f:	c0 
c0103670:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c0103677:	00 
c0103678:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010367f:	e8 75 cd ff ff       	call   c01003f9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010368b:	e8 a8 f6 ff ff       	call   c0102d38 <alloc_pages>
c0103690:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103693:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103698:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010369f:	00 
c01036a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036a7:	00 
c01036a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01036af:	89 04 24             	mov    %eax,(%esp)
c01036b2:	e8 e3 fd ff ff       	call   c010349a <page_insert>
c01036b7:	85 c0                	test   %eax,%eax
c01036b9:	74 24                	je     c01036df <check_pgdir+0x111>
c01036bb:	c7 44 24 0c 44 68 10 	movl   $0xc0106844,0xc(%esp)
c01036c2:	c0 
c01036c3:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01036ca:	c0 
c01036cb:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01036d2:	00 
c01036d3:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01036da:	e8 1a cd ff ff       	call   c01003f9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01036df:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01036e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036eb:	00 
c01036ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036f3:	00 
c01036f4:	89 04 24             	mov    %eax,(%esp)
c01036f7:	e8 f4 fc ff ff       	call   c01033f0 <get_pte>
c01036fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103703:	75 24                	jne    c0103729 <check_pgdir+0x15b>
c0103705:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c010370c:	c0 
c010370d:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103714:	c0 
c0103715:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c010371c:	00 
c010371d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103724:	e8 d0 cc ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103729:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010372c:	8b 00                	mov    (%eax),%eax
c010372e:	89 04 24             	mov    %eax,(%esp)
c0103731:	e8 b5 f3 ff ff       	call   c0102aeb <pte2page>
c0103736:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103739:	74 24                	je     c010375f <check_pgdir+0x191>
c010373b:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103742:	c0 
c0103743:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010374a:	c0 
c010374b:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0103752:	00 
c0103753:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010375a:	e8 9a cc ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 1);
c010375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103762:	89 04 24             	mov    %eax,(%esp)
c0103765:	e8 d7 f3 ff ff       	call   c0102b41 <page_ref>
c010376a:	83 f8 01             	cmp    $0x1,%eax
c010376d:	74 24                	je     c0103793 <check_pgdir+0x1c5>
c010376f:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c0103776:	c0 
c0103777:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010377e:	c0 
c010377f:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0103786:	00 
c0103787:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010378e:	e8 66 cc ff ff       	call   c01003f9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103793:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103798:	8b 00                	mov    (%eax),%eax
c010379a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010379f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a5:	c1 e8 0c             	shr    $0xc,%eax
c01037a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037ab:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01037b0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037b3:	72 23                	jb     c01037d8 <check_pgdir+0x20a>
c01037b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01037bc:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c01037c3:	c0 
c01037c4:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01037cb:	00 
c01037cc:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01037d3:	e8 21 cc ff ff       	call   c01003f9 <__panic>
c01037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037db:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037e0:	83 c0 04             	add    $0x4,%eax
c01037e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037e6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037f2:	00 
c01037f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037fa:	00 
c01037fb:	89 04 24             	mov    %eax,(%esp)
c01037fe:	e8 ed fb ff ff       	call   c01033f0 <get_pte>
c0103803:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103806:	74 24                	je     c010382c <check_pgdir+0x25e>
c0103808:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c010380f:	c0 
c0103810:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103817:	c0 
c0103818:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c010381f:	00 
c0103820:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103827:	e8 cd cb ff ff       	call   c01003f9 <__panic>

    p2 = alloc_page();
c010382c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103833:	e8 00 f5 ff ff       	call   c0102d38 <alloc_pages>
c0103838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010383b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103840:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103847:	00 
c0103848:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010384f:	00 
c0103850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103853:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103857:	89 04 24             	mov    %eax,(%esp)
c010385a:	e8 3b fc ff ff       	call   c010349a <page_insert>
c010385f:	85 c0                	test   %eax,%eax
c0103861:	74 24                	je     c0103887 <check_pgdir+0x2b9>
c0103863:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c010386a:	c0 
c010386b:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103872:	c0 
c0103873:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c010387a:	00 
c010387b:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103882:	e8 72 cb ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103887:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010388c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103893:	00 
c0103894:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010389b:	00 
c010389c:	89 04 24             	mov    %eax,(%esp)
c010389f:	e8 4c fb ff ff       	call   c01033f0 <get_pte>
c01038a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038ab:	75 24                	jne    c01038d1 <check_pgdir+0x303>
c01038ad:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c01038b4:	c0 
c01038b5:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038bc:	c0 
c01038bd:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c01038c4:	00 
c01038c5:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038cc:	e8 28 cb ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_U);
c01038d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d4:	8b 00                	mov    (%eax),%eax
c01038d6:	83 e0 04             	and    $0x4,%eax
c01038d9:	85 c0                	test   %eax,%eax
c01038db:	75 24                	jne    c0103901 <check_pgdir+0x333>
c01038dd:	c7 44 24 0c 58 69 10 	movl   $0xc0106958,0xc(%esp)
c01038e4:	c0 
c01038e5:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038ec:	c0 
c01038ed:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c01038f4:	00 
c01038f5:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038fc:	e8 f8 ca ff ff       	call   c01003f9 <__panic>
    assert(*ptep & PTE_W);
c0103901:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103904:	8b 00                	mov    (%eax),%eax
c0103906:	83 e0 02             	and    $0x2,%eax
c0103909:	85 c0                	test   %eax,%eax
c010390b:	75 24                	jne    c0103931 <check_pgdir+0x363>
c010390d:	c7 44 24 0c 66 69 10 	movl   $0xc0106966,0xc(%esp)
c0103914:	c0 
c0103915:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010391c:	c0 
c010391d:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0103924:	00 
c0103925:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010392c:	e8 c8 ca ff ff       	call   c01003f9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103931:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103936:	8b 00                	mov    (%eax),%eax
c0103938:	83 e0 04             	and    $0x4,%eax
c010393b:	85 c0                	test   %eax,%eax
c010393d:	75 24                	jne    c0103963 <check_pgdir+0x395>
c010393f:	c7 44 24 0c 74 69 10 	movl   $0xc0106974,0xc(%esp)
c0103946:	c0 
c0103947:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010394e:	c0 
c010394f:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103956:	00 
c0103957:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010395e:	e8 96 ca ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 1);
c0103963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103966:	89 04 24             	mov    %eax,(%esp)
c0103969:	e8 d3 f1 ff ff       	call   c0102b41 <page_ref>
c010396e:	83 f8 01             	cmp    $0x1,%eax
c0103971:	74 24                	je     c0103997 <check_pgdir+0x3c9>
c0103973:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c010397a:	c0 
c010397b:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103982:	c0 
c0103983:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010398a:	00 
c010398b:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103992:	e8 62 ca ff ff       	call   c01003f9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103997:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010399c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01039a3:	00 
c01039a4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01039ab:	00 
c01039ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039b3:	89 04 24             	mov    %eax,(%esp)
c01039b6:	e8 df fa ff ff       	call   c010349a <page_insert>
c01039bb:	85 c0                	test   %eax,%eax
c01039bd:	74 24                	je     c01039e3 <check_pgdir+0x415>
c01039bf:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c01039c6:	c0 
c01039c7:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01039ce:	c0 
c01039cf:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01039d6:	00 
c01039d7:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01039de:	e8 16 ca ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p1) == 2);
c01039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e6:	89 04 24             	mov    %eax,(%esp)
c01039e9:	e8 53 f1 ff ff       	call   c0102b41 <page_ref>
c01039ee:	83 f8 02             	cmp    $0x2,%eax
c01039f1:	74 24                	je     c0103a17 <check_pgdir+0x449>
c01039f3:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c01039fa:	c0 
c01039fb:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a02:	c0 
c0103a03:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103a0a:	00 
c0103a0b:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a12:	e8 e2 c9 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a1a:	89 04 24             	mov    %eax,(%esp)
c0103a1d:	e8 1f f1 ff ff       	call   c0102b41 <page_ref>
c0103a22:	85 c0                	test   %eax,%eax
c0103a24:	74 24                	je     c0103a4a <check_pgdir+0x47c>
c0103a26:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103a2d:	c0 
c0103a2e:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a35:	c0 
c0103a36:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103a3d:	00 
c0103a3e:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a45:	e8 af c9 ff ff       	call   c01003f9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a4a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a56:	00 
c0103a57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a5e:	00 
c0103a5f:	89 04 24             	mov    %eax,(%esp)
c0103a62:	e8 89 f9 ff ff       	call   c01033f0 <get_pte>
c0103a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a6e:	75 24                	jne    c0103a94 <check_pgdir+0x4c6>
c0103a70:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c0103a77:	c0 
c0103a78:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a7f:	c0 
c0103a80:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0103a87:	00 
c0103a88:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a8f:	e8 65 c9 ff ff       	call   c01003f9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a97:	8b 00                	mov    (%eax),%eax
c0103a99:	89 04 24             	mov    %eax,(%esp)
c0103a9c:	e8 4a f0 ff ff       	call   c0102aeb <pte2page>
c0103aa1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103aa4:	74 24                	je     c0103aca <check_pgdir+0x4fc>
c0103aa6:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103aad:	c0 
c0103aae:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ab5:	c0 
c0103ab6:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103abd:	00 
c0103abe:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103ac5:	e8 2f c9 ff ff       	call   c01003f9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103acd:	8b 00                	mov    (%eax),%eax
c0103acf:	83 e0 04             	and    $0x4,%eax
c0103ad2:	85 c0                	test   %eax,%eax
c0103ad4:	74 24                	je     c0103afa <check_pgdir+0x52c>
c0103ad6:	c7 44 24 0c ec 69 10 	movl   $0xc01069ec,0xc(%esp)
c0103add:	c0 
c0103ade:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ae5:	c0 
c0103ae6:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103aed:	00 
c0103aee:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103af5:	e8 ff c8 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103afa:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103b06:	00 
c0103b07:	89 04 24             	mov    %eax,(%esp)
c0103b0a:	e8 46 f9 ff ff       	call   c0103455 <page_remove>
    assert(page_ref(p1) == 1);
c0103b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b12:	89 04 24             	mov    %eax,(%esp)
c0103b15:	e8 27 f0 ff ff       	call   c0102b41 <page_ref>
c0103b1a:	83 f8 01             	cmp    $0x1,%eax
c0103b1d:	74 24                	je     c0103b43 <check_pgdir+0x575>
c0103b1f:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c0103b26:	c0 
c0103b27:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b2e:	c0 
c0103b2f:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103b36:	00 
c0103b37:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b3e:	e8 b6 c8 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b46:	89 04 24             	mov    %eax,(%esp)
c0103b49:	e8 f3 ef ff ff       	call   c0102b41 <page_ref>
c0103b4e:	85 c0                	test   %eax,%eax
c0103b50:	74 24                	je     c0103b76 <check_pgdir+0x5a8>
c0103b52:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103b59:	c0 
c0103b5a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b61:	c0 
c0103b62:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103b69:	00 
c0103b6a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b71:	e8 83 c8 ff ff       	call   c01003f9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b76:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b7b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b82:	00 
c0103b83:	89 04 24             	mov    %eax,(%esp)
c0103b86:	e8 ca f8 ff ff       	call   c0103455 <page_remove>
    assert(page_ref(p1) == 0);
c0103b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b8e:	89 04 24             	mov    %eax,(%esp)
c0103b91:	e8 ab ef ff ff       	call   c0102b41 <page_ref>
c0103b96:	85 c0                	test   %eax,%eax
c0103b98:	74 24                	je     c0103bbe <check_pgdir+0x5f0>
c0103b9a:	c7 44 24 0c 01 6a 10 	movl   $0xc0106a01,0xc(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103bb1:	00 
c0103bb2:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103bb9:	e8 3b c8 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p2) == 0);
c0103bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bc1:	89 04 24             	mov    %eax,(%esp)
c0103bc4:	e8 78 ef ff ff       	call   c0102b41 <page_ref>
c0103bc9:	85 c0                	test   %eax,%eax
c0103bcb:	74 24                	je     c0103bf1 <check_pgdir+0x623>
c0103bcd:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103bd4:	c0 
c0103bd5:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103bdc:	c0 
c0103bdd:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103be4:	00 
c0103be5:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103bec:	e8 08 c8 ff ff       	call   c01003f9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103bf1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103bf6:	8b 00                	mov    (%eax),%eax
c0103bf8:	89 04 24             	mov    %eax,(%esp)
c0103bfb:	e8 29 ef ff ff       	call   c0102b29 <pde2page>
c0103c00:	89 04 24             	mov    %eax,(%esp)
c0103c03:	e8 39 ef ff ff       	call   c0102b41 <page_ref>
c0103c08:	83 f8 01             	cmp    $0x1,%eax
c0103c0b:	74 24                	je     c0103c31 <check_pgdir+0x663>
c0103c0d:	c7 44 24 0c 14 6a 10 	movl   $0xc0106a14,0xc(%esp)
c0103c14:	c0 
c0103c15:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103c1c:	c0 
c0103c1d:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103c24:	00 
c0103c25:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c2c:	e8 c8 c7 ff ff       	call   c01003f9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103c31:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c36:	8b 00                	mov    (%eax),%eax
c0103c38:	89 04 24             	mov    %eax,(%esp)
c0103c3b:	e8 e9 ee ff ff       	call   c0102b29 <pde2page>
c0103c40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c47:	00 
c0103c48:	89 04 24             	mov    %eax,(%esp)
c0103c4b:	e8 20 f1 ff ff       	call   c0102d70 <free_pages>
    boot_pgdir[0] = 0;
c0103c50:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c5b:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103c62:	e8 3b c6 ff ff       	call   c01002a2 <cprintf>
}
c0103c67:	90                   	nop
c0103c68:	c9                   	leave  
c0103c69:	c3                   	ret    

c0103c6a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c6a:	55                   	push   %ebp
c0103c6b:	89 e5                	mov    %esp,%ebp
c0103c6d:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c77:	e9 ca 00 00 00       	jmp    c0103d46 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c85:	c1 e8 0c             	shr    $0xc,%eax
c0103c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c8b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103c90:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103c93:	72 23                	jb     c0103cb8 <check_boot_pgdir+0x4e>
c0103c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c9c:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0103ca3:	c0 
c0103ca4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103cab:	00 
c0103cac:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103cb3:	e8 41 c7 ff ff       	call   c01003f9 <__panic>
c0103cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cbb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103cc0:	89 c2                	mov    %eax,%edx
c0103cc2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103cc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103cce:	00 
c0103ccf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cd3:	89 04 24             	mov    %eax,(%esp)
c0103cd6:	e8 15 f7 ff ff       	call   c01033f0 <get_pte>
c0103cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103ce2:	75 24                	jne    c0103d08 <check_boot_pgdir+0x9e>
c0103ce4:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c0103ceb:	c0 
c0103cec:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103cf3:	c0 
c0103cf4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103cfb:	00 
c0103cfc:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d03:	e8 f1 c6 ff ff       	call   c01003f9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d0b:	8b 00                	mov    (%eax),%eax
c0103d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d12:	89 c2                	mov    %eax,%edx
c0103d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d17:	39 c2                	cmp    %eax,%edx
c0103d19:	74 24                	je     c0103d3f <check_boot_pgdir+0xd5>
c0103d1b:	c7 44 24 0c 95 6a 10 	movl   $0xc0106a95,0xc(%esp)
c0103d22:	c0 
c0103d23:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103d2a:	c0 
c0103d2b:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103d32:	00 
c0103d33:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d3a:	e8 ba c6 ff ff       	call   c01003f9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103d3f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d49:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103d4e:	39 c2                	cmp    %eax,%edx
c0103d50:	0f 82 26 ff ff ff    	jb     c0103c7c <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103d56:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d5b:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103d60:	8b 00                	mov    (%eax),%eax
c0103d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d67:	89 c2                	mov    %eax,%edx
c0103d69:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d71:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103d78:	77 23                	ja     c0103d9d <check_boot_pgdir+0x133>
c0103d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d81:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103d88:	c0 
c0103d89:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103d90:	00 
c0103d91:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d98:	e8 5c c6 ff ff       	call   c01003f9 <__panic>
c0103d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da0:	05 00 00 00 40       	add    $0x40000000,%eax
c0103da5:	39 d0                	cmp    %edx,%eax
c0103da7:	74 24                	je     c0103dcd <check_boot_pgdir+0x163>
c0103da9:	c7 44 24 0c ac 6a 10 	movl   $0xc0106aac,0xc(%esp)
c0103db0:	c0 
c0103db1:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103db8:	c0 
c0103db9:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103dc0:	00 
c0103dc1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103dc8:	e8 2c c6 ff ff       	call   c01003f9 <__panic>

    assert(boot_pgdir[0] == 0);
c0103dcd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103dd2:	8b 00                	mov    (%eax),%eax
c0103dd4:	85 c0                	test   %eax,%eax
c0103dd6:	74 24                	je     c0103dfc <check_boot_pgdir+0x192>
c0103dd8:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c0103ddf:	c0 
c0103de0:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103de7:	c0 
c0103de8:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103def:	00 
c0103df0:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103df7:	e8 fd c5 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    p = alloc_page();
c0103dfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e03:	e8 30 ef ff ff       	call   c0102d38 <alloc_pages>
c0103e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103e0b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e10:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e17:	00 
c0103e18:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103e1f:	00 
c0103e20:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103e23:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e27:	89 04 24             	mov    %eax,(%esp)
c0103e2a:	e8 6b f6 ff ff       	call   c010349a <page_insert>
c0103e2f:	85 c0                	test   %eax,%eax
c0103e31:	74 24                	je     c0103e57 <check_boot_pgdir+0x1ed>
c0103e33:	c7 44 24 0c f4 6a 10 	movl   $0xc0106af4,0xc(%esp)
c0103e3a:	c0 
c0103e3b:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e42:	c0 
c0103e43:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103e4a:	00 
c0103e4b:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e52:	e8 a2 c5 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 1);
c0103e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e5a:	89 04 24             	mov    %eax,(%esp)
c0103e5d:	e8 df ec ff ff       	call   c0102b41 <page_ref>
c0103e62:	83 f8 01             	cmp    $0x1,%eax
c0103e65:	74 24                	je     c0103e8b <check_boot_pgdir+0x221>
c0103e67:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c0103e6e:	c0 
c0103e6f:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e76:	c0 
c0103e77:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103e7e:	00 
c0103e7f:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e86:	e8 6e c5 ff ff       	call   c01003f9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103e8b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e90:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e97:	00 
c0103e98:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103e9f:	00 
c0103ea0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ea7:	89 04 24             	mov    %eax,(%esp)
c0103eaa:	e8 eb f5 ff ff       	call   c010349a <page_insert>
c0103eaf:	85 c0                	test   %eax,%eax
c0103eb1:	74 24                	je     c0103ed7 <check_boot_pgdir+0x26d>
c0103eb3:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0103eba:	c0 
c0103ebb:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ec2:	c0 
c0103ec3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103eca:	00 
c0103ecb:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103ed2:	e8 22 c5 ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p) == 2);
c0103ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103eda:	89 04 24             	mov    %eax,(%esp)
c0103edd:	e8 5f ec ff ff       	call   c0102b41 <page_ref>
c0103ee2:	83 f8 02             	cmp    $0x2,%eax
c0103ee5:	74 24                	je     c0103f0b <check_boot_pgdir+0x2a1>
c0103ee7:	c7 44 24 0c 6b 6b 10 	movl   $0xc0106b6b,0xc(%esp)
c0103eee:	c0 
c0103eef:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ef6:	c0 
c0103ef7:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103efe:	00 
c0103eff:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103f06:	e8 ee c4 ff ff       	call   c01003f9 <__panic>

    const char *str = "ucore: Hello world!!";
c0103f0b:	c7 45 e8 7c 6b 10 c0 	movl   $0xc0106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f19:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f20:	e8 4b 15 00 00       	call   c0105470 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103f25:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103f2c:	00 
c0103f2d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f34:	e8 ae 15 00 00       	call   c01054e7 <strcmp>
c0103f39:	85 c0                	test   %eax,%eax
c0103f3b:	74 24                	je     c0103f61 <check_boot_pgdir+0x2f7>
c0103f3d:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0103f44:	c0 
c0103f45:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103f4c:	c0 
c0103f4d:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103f54:	00 
c0103f55:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103f5c:	e8 98 c4 ff ff       	call   c01003f9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f64:	89 04 24             	mov    %eax,(%esp)
c0103f67:	e8 2b eb ff ff       	call   c0102a97 <page2kva>
c0103f6c:	05 00 01 00 00       	add    $0x100,%eax
c0103f71:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103f74:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f7b:	e8 9a 14 00 00       	call   c010541a <strlen>
c0103f80:	85 c0                	test   %eax,%eax
c0103f82:	74 24                	je     c0103fa8 <check_boot_pgdir+0x33e>
c0103f84:	c7 44 24 0c cc 6b 10 	movl   $0xc0106bcc,0xc(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103f93:	c0 
c0103f94:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103f9b:	00 
c0103f9c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103fa3:	e8 51 c4 ff ff       	call   c01003f9 <__panic>

    free_page(p);
c0103fa8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103faf:	00 
c0103fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fb3:	89 04 24             	mov    %eax,(%esp)
c0103fb6:	e8 b5 ed ff ff       	call   c0102d70 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103fbb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fc0:	8b 00                	mov    (%eax),%eax
c0103fc2:	89 04 24             	mov    %eax,(%esp)
c0103fc5:	e8 5f eb ff ff       	call   c0102b29 <pde2page>
c0103fca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fd1:	00 
c0103fd2:	89 04 24             	mov    %eax,(%esp)
c0103fd5:	e8 96 ed ff ff       	call   c0102d70 <free_pages>
    boot_pgdir[0] = 0;
c0103fda:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103fe5:	c7 04 24 f0 6b 10 c0 	movl   $0xc0106bf0,(%esp)
c0103fec:	e8 b1 c2 ff ff       	call   c01002a2 <cprintf>
}
c0103ff1:	90                   	nop
c0103ff2:	c9                   	leave  
c0103ff3:	c3                   	ret    

c0103ff4 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103ff4:	55                   	push   %ebp
c0103ff5:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ffa:	83 e0 04             	and    $0x4,%eax
c0103ffd:	85 c0                	test   %eax,%eax
c0103fff:	74 04                	je     c0104005 <perm2str+0x11>
c0104001:	b0 75                	mov    $0x75,%al
c0104003:	eb 02                	jmp    c0104007 <perm2str+0x13>
c0104005:	b0 2d                	mov    $0x2d,%al
c0104007:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c010400c:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104013:	8b 45 08             	mov    0x8(%ebp),%eax
c0104016:	83 e0 02             	and    $0x2,%eax
c0104019:	85 c0                	test   %eax,%eax
c010401b:	74 04                	je     c0104021 <perm2str+0x2d>
c010401d:	b0 77                	mov    $0x77,%al
c010401f:	eb 02                	jmp    c0104023 <perm2str+0x2f>
c0104021:	b0 2d                	mov    $0x2d,%al
c0104023:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0104028:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c010402f:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c0104034:	5d                   	pop    %ebp
c0104035:	c3                   	ret    

c0104036 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104036:	55                   	push   %ebp
c0104037:	89 e5                	mov    %esp,%ebp
c0104039:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010403c:	8b 45 10             	mov    0x10(%ebp),%eax
c010403f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104042:	72 0d                	jb     c0104051 <get_pgtable_items+0x1b>
        return 0;
c0104044:	b8 00 00 00 00       	mov    $0x0,%eax
c0104049:	e9 98 00 00 00       	jmp    c01040e6 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010404e:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104051:	8b 45 10             	mov    0x10(%ebp),%eax
c0104054:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104057:	73 18                	jae    c0104071 <get_pgtable_items+0x3b>
c0104059:	8b 45 10             	mov    0x10(%ebp),%eax
c010405c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104063:	8b 45 14             	mov    0x14(%ebp),%eax
c0104066:	01 d0                	add    %edx,%eax
c0104068:	8b 00                	mov    (%eax),%eax
c010406a:	83 e0 01             	and    $0x1,%eax
c010406d:	85 c0                	test   %eax,%eax
c010406f:	74 dd                	je     c010404e <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104071:	8b 45 10             	mov    0x10(%ebp),%eax
c0104074:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104077:	73 68                	jae    c01040e1 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104079:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010407d:	74 08                	je     c0104087 <get_pgtable_items+0x51>
            *left_store = start;
c010407f:	8b 45 18             	mov    0x18(%ebp),%eax
c0104082:	8b 55 10             	mov    0x10(%ebp),%edx
c0104085:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104087:	8b 45 10             	mov    0x10(%ebp),%eax
c010408a:	8d 50 01             	lea    0x1(%eax),%edx
c010408d:	89 55 10             	mov    %edx,0x10(%ebp)
c0104090:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104097:	8b 45 14             	mov    0x14(%ebp),%eax
c010409a:	01 d0                	add    %edx,%eax
c010409c:	8b 00                	mov    (%eax),%eax
c010409e:	83 e0 07             	and    $0x7,%eax
c01040a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01040a4:	eb 03                	jmp    c01040a9 <get_pgtable_items+0x73>
            start ++;
c01040a6:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01040a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01040ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040af:	73 1d                	jae    c01040ce <get_pgtable_items+0x98>
c01040b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01040b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01040bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01040be:	01 d0                	add    %edx,%eax
c01040c0:	8b 00                	mov    (%eax),%eax
c01040c2:	83 e0 07             	and    $0x7,%eax
c01040c5:	89 c2                	mov    %eax,%edx
c01040c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040ca:	39 c2                	cmp    %eax,%edx
c01040cc:	74 d8                	je     c01040a6 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01040ce:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01040d2:	74 08                	je     c01040dc <get_pgtable_items+0xa6>
            *right_store = start;
c01040d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01040d7:	8b 55 10             	mov    0x10(%ebp),%edx
c01040da:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01040dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040df:	eb 05                	jmp    c01040e6 <get_pgtable_items+0xb0>
    }
    return 0;
c01040e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01040e6:	c9                   	leave  
c01040e7:	c3                   	ret    

c01040e8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01040e8:	55                   	push   %ebp
c01040e9:	89 e5                	mov    %esp,%ebp
c01040eb:	57                   	push   %edi
c01040ec:	56                   	push   %esi
c01040ed:	53                   	push   %ebx
c01040ee:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01040f1:	c7 04 24 10 6c 10 c0 	movl   $0xc0106c10,(%esp)
c01040f8:	e8 a5 c1 ff ff       	call   c01002a2 <cprintf>
    size_t left, right = 0, perm;
c01040fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104104:	e9 fa 00 00 00       	jmp    c0104203 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010410c:	89 04 24             	mov    %eax,(%esp)
c010410f:	e8 e0 fe ff ff       	call   c0103ff4 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104114:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104117:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010411a:	29 d1                	sub    %edx,%ecx
c010411c:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010411e:	89 d6                	mov    %edx,%esi
c0104120:	c1 e6 16             	shl    $0x16,%esi
c0104123:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104126:	89 d3                	mov    %edx,%ebx
c0104128:	c1 e3 16             	shl    $0x16,%ebx
c010412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010412e:	89 d1                	mov    %edx,%ecx
c0104130:	c1 e1 16             	shl    $0x16,%ecx
c0104133:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104136:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104139:	29 d7                	sub    %edx,%edi
c010413b:	89 fa                	mov    %edi,%edx
c010413d:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104141:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104145:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104149:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010414d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104151:	c7 04 24 41 6c 10 c0 	movl   $0xc0106c41,(%esp)
c0104158:	e8 45 c1 ff ff       	call   c01002a2 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010415d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104160:	c1 e0 0a             	shl    $0xa,%eax
c0104163:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104166:	eb 54                	jmp    c01041bc <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010416b:	89 04 24             	mov    %eax,(%esp)
c010416e:	e8 81 fe ff ff       	call   c0103ff4 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104173:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104176:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104179:	29 d1                	sub    %edx,%ecx
c010417b:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010417d:	89 d6                	mov    %edx,%esi
c010417f:	c1 e6 0c             	shl    $0xc,%esi
c0104182:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104185:	89 d3                	mov    %edx,%ebx
c0104187:	c1 e3 0c             	shl    $0xc,%ebx
c010418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010418d:	89 d1                	mov    %edx,%ecx
c010418f:	c1 e1 0c             	shl    $0xc,%ecx
c0104192:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104195:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104198:	29 d7                	sub    %edx,%edi
c010419a:	89 fa                	mov    %edi,%edx
c010419c:	89 44 24 14          	mov    %eax,0x14(%esp)
c01041a0:	89 74 24 10          	mov    %esi,0x10(%esp)
c01041a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01041a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01041ac:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041b0:	c7 04 24 60 6c 10 c0 	movl   $0xc0106c60,(%esp)
c01041b7:	e8 e6 c0 ff ff       	call   c01002a2 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01041bc:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01041c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041c7:	89 d3                	mov    %edx,%ebx
c01041c9:	c1 e3 0a             	shl    $0xa,%ebx
c01041cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041cf:	89 d1                	mov    %edx,%ecx
c01041d1:	c1 e1 0a             	shl    $0xa,%ecx
c01041d4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01041d7:	89 54 24 14          	mov    %edx,0x14(%esp)
c01041db:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01041de:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01041e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01041ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041ee:	89 0c 24             	mov    %ecx,(%esp)
c01041f1:	e8 40 fe ff ff       	call   c0104036 <get_pgtable_items>
c01041f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041fd:	0f 85 65 ff ff ff    	jne    c0104168 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104203:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104208:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010420b:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010420e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104212:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104215:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104219:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010421d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104221:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104228:	00 
c0104229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104230:	e8 01 fe ff ff       	call   c0104036 <get_pgtable_items>
c0104235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104238:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010423c:	0f 85 c7 fe ff ff    	jne    c0104109 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104242:	c7 04 24 84 6c 10 c0 	movl   $0xc0106c84,(%esp)
c0104249:	e8 54 c0 ff ff       	call   c01002a2 <cprintf>
}
c010424e:	90                   	nop
c010424f:	83 c4 4c             	add    $0x4c,%esp
c0104252:	5b                   	pop    %ebx
c0104253:	5e                   	pop    %esi
c0104254:	5f                   	pop    %edi
c0104255:	5d                   	pop    %ebp
c0104256:	c3                   	ret    

c0104257 <page2ppn>:
page2ppn(struct Page *page) {
c0104257:	55                   	push   %ebp
c0104258:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010425a:	8b 45 08             	mov    0x8(%ebp),%eax
c010425d:	8b 15 78 af 11 c0    	mov    0xc011af78,%edx
c0104263:	29 d0                	sub    %edx,%eax
c0104265:	c1 f8 02             	sar    $0x2,%eax
c0104268:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010426e:	5d                   	pop    %ebp
c010426f:	c3                   	ret    

c0104270 <page2pa>:
page2pa(struct Page *page) {
c0104270:	55                   	push   %ebp
c0104271:	89 e5                	mov    %esp,%ebp
c0104273:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104276:	8b 45 08             	mov    0x8(%ebp),%eax
c0104279:	89 04 24             	mov    %eax,(%esp)
c010427c:	e8 d6 ff ff ff       	call   c0104257 <page2ppn>
c0104281:	c1 e0 0c             	shl    $0xc,%eax
}
c0104284:	c9                   	leave  
c0104285:	c3                   	ret    

c0104286 <page_ref>:
page_ref(struct Page *page) {
c0104286:	55                   	push   %ebp
c0104287:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104289:	8b 45 08             	mov    0x8(%ebp),%eax
c010428c:	8b 00                	mov    (%eax),%eax
}
c010428e:	5d                   	pop    %ebp
c010428f:	c3                   	ret    

c0104290 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104290:	55                   	push   %ebp
c0104291:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104293:	8b 45 08             	mov    0x8(%ebp),%eax
c0104296:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104299:	89 10                	mov    %edx,(%eax)
}
c010429b:	90                   	nop
c010429c:	5d                   	pop    %ebp
c010429d:	c3                   	ret    

c010429e <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010429e:	55                   	push   %ebp
c010429f:	89 e5                	mov    %esp,%ebp
c01042a1:	83 ec 10             	sub    $0x10,%esp
c01042a4:	c7 45 fc 7c af 11 c0 	movl   $0xc011af7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01042ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01042b1:	89 50 04             	mov    %edx,0x4(%eax)
c01042b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042b7:	8b 50 04             	mov    0x4(%eax),%edx
c01042ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042bd:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01042bf:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c01042c6:	00 00 00 
}
c01042c9:	90                   	nop
c01042ca:	c9                   	leave  
c01042cb:	c3                   	ret    

c01042cc <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01042cc:	55                   	push   %ebp
c01042cd:	89 e5                	mov    %esp,%ebp
c01042cf:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042d6:	75 24                	jne    c01042fc <default_init_memmap+0x30>
c01042d8:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c01042df:	c0 
c01042e0:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01042e7:	c0 
c01042e8:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01042ef:	00 
c01042f0:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01042f7:	e8 fd c0 ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c01042fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104302:	eb 7d                	jmp    c0104381 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104307:	83 c0 04             	add    $0x4,%eax
c010430a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104311:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104314:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104317:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010431a:	0f a3 10             	bt     %edx,(%eax)
c010431d:	19 c0                	sbb    %eax,%eax
c010431f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104322:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104326:	0f 95 c0             	setne  %al
c0104329:	0f b6 c0             	movzbl %al,%eax
c010432c:	85 c0                	test   %eax,%eax
c010432e:	75 24                	jne    c0104354 <default_init_memmap+0x88>
c0104330:	c7 44 24 0c e9 6c 10 	movl   $0xc0106ce9,0xc(%esp)
c0104337:	c0 
c0104338:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010433f:	c0 
c0104340:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104347:	00 
c0104348:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010434f:	e8 a5 c0 ff ff       	call   c01003f9 <__panic>
        p->flags = p->property = 0;
c0104354:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104357:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010435e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104361:	8b 50 08             	mov    0x8(%eax),%edx
c0104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104367:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010436a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104371:	00 
c0104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104375:	89 04 24             	mov    %eax,(%esp)
c0104378:	e8 13 ff ff ff       	call   c0104290 <set_page_ref>
    for (; p != base + n; p ++) {
c010437d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104381:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104384:	89 d0                	mov    %edx,%eax
c0104386:	c1 e0 02             	shl    $0x2,%eax
c0104389:	01 d0                	add    %edx,%eax
c010438b:	c1 e0 02             	shl    $0x2,%eax
c010438e:	89 c2                	mov    %eax,%edx
c0104390:	8b 45 08             	mov    0x8(%ebp),%eax
c0104393:	01 d0                	add    %edx,%eax
c0104395:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104398:	0f 85 66 ff ff ff    	jne    c0104304 <default_init_memmap+0x38>
    }
    base->property = n;
c010439e:	8b 45 08             	mov    0x8(%ebp),%eax
c01043a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043a4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01043a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01043aa:	83 c0 04             	add    $0x4,%eax
c01043ad:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01043b4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043bd:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01043c0:	8b 15 84 af 11 c0    	mov    0xc011af84,%edx
c01043c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043c9:	01 d0                	add    %edx,%eax
c01043cb:	a3 84 af 11 c0       	mov    %eax,0xc011af84
    list_add(&free_list, &(base->page_link));
c01043d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d3:	83 c0 0c             	add    $0xc,%eax
c01043d6:	c7 45 e4 7c af 11 c0 	movl   $0xc011af7c,-0x1c(%ebp)
c01043dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01043e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01043ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043ef:	8b 40 04             	mov    0x4(%eax),%eax
c01043f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043fb:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01043fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104401:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104404:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104407:	89 10                	mov    %edx,(%eax)
c0104409:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010440c:	8b 10                	mov    (%eax),%edx
c010440e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104411:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104414:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104417:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010441a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010441d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104420:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104423:	89 10                	mov    %edx,(%eax)
}
c0104425:	90                   	nop
c0104426:	c9                   	leave  
c0104427:	c3                   	ret    

c0104428 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104428:	55                   	push   %ebp
c0104429:	89 e5                	mov    %esp,%ebp
c010442b:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010442e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104432:	75 24                	jne    c0104458 <default_alloc_pages+0x30>
c0104434:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c010443b:	c0 
c010443c:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104443:	c0 
c0104444:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010444b:	00 
c010444c:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104453:	e8 a1 bf ff ff       	call   c01003f9 <__panic>
    if (n > nr_free) {
c0104458:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c010445d:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104460:	76 0a                	jbe    c010446c <default_alloc_pages+0x44>
        return NULL;
c0104462:	b8 00 00 00 00       	mov    $0x0,%eax
c0104467:	e9 2a 01 00 00       	jmp    c0104596 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c010446c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104473:	c7 45 f0 7c af 11 c0 	movl   $0xc011af7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010447a:	eb 1c                	jmp    c0104498 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010447c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010447f:	83 e8 0c             	sub    $0xc,%eax
c0104482:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0104485:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104488:	8b 40 08             	mov    0x8(%eax),%eax
c010448b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010448e:	77 08                	ja     c0104498 <default_alloc_pages+0x70>
            page = p;
c0104490:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104493:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104496:	eb 18                	jmp    c01044b0 <default_alloc_pages+0x88>
c0104498:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010449b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c010449e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044a1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01044a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044a7:	81 7d f0 7c af 11 c0 	cmpl   $0xc011af7c,-0x10(%ebp)
c01044ae:	75 cc                	jne    c010447c <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c01044b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b4:	0f 84 d9 00 00 00    	je     c0104593 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c01044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044bd:	83 c0 0c             	add    $0xc,%eax
c01044c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c01044c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044c6:	8b 40 04             	mov    0x4(%eax),%eax
c01044c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044cc:	8b 12                	mov    (%edx),%edx
c01044ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01044d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01044d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01044dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044e3:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e8:	8b 40 08             	mov    0x8(%eax),%eax
c01044eb:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044ee:	73 7d                	jae    c010456d <default_alloc_pages+0x145>
            struct Page *p = page + n;
c01044f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01044f3:	89 d0                	mov    %edx,%eax
c01044f5:	c1 e0 02             	shl    $0x2,%eax
c01044f8:	01 d0                	add    %edx,%eax
c01044fa:	c1 e0 02             	shl    $0x2,%eax
c01044fd:	89 c2                	mov    %eax,%edx
c01044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104502:	01 d0                	add    %edx,%eax
c0104504:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104507:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010450a:	8b 40 08             	mov    0x8(%eax),%eax
c010450d:	2b 45 08             	sub    0x8(%ebp),%eax
c0104510:	89 c2                	mov    %eax,%edx
c0104512:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104515:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0104518:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010451b:	83 c0 0c             	add    $0xc,%eax
c010451e:	c7 45 d4 7c af 11 c0 	movl   $0xc011af7c,-0x2c(%ebp)
c0104525:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010452b:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010452e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104531:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104534:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104537:	8b 40 04             	mov    0x4(%eax),%eax
c010453a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010453d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104540:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104543:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104546:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c0104549:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010454c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010454f:	89 10                	mov    %edx,(%eax)
c0104551:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104554:	8b 10                	mov    (%eax),%edx
c0104556:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104559:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010455c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010455f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104562:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104565:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104568:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010456b:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c010456d:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104572:	2b 45 08             	sub    0x8(%ebp),%eax
c0104575:	a3 84 af 11 c0       	mov    %eax,0xc011af84
        ClearPageProperty(page);
c010457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457d:	83 c0 04             	add    $0x4,%eax
c0104580:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104587:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010458a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010458d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104590:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104596:	c9                   	leave  
c0104597:	c3                   	ret    

c0104598 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104598:	55                   	push   %ebp
c0104599:	89 e5                	mov    %esp,%ebp
c010459b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c01045a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01045a5:	75 24                	jne    c01045cb <default_free_pages+0x33>
c01045a7:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c01045ae:	c0 
c01045af:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01045b6:	c0 
c01045b7:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01045be:	00 
c01045bf:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01045c6:	e8 2e be ff ff       	call   c01003f9 <__panic>
    struct Page *p = base;
c01045cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01045d1:	e9 9d 00 00 00       	jmp    c0104673 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d9:	83 c0 04             	add    $0x4,%eax
c01045dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01045e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045ec:	0f a3 10             	bt     %edx,(%eax)
c01045ef:	19 c0                	sbb    %eax,%eax
c01045f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01045f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045f8:	0f 95 c0             	setne  %al
c01045fb:	0f b6 c0             	movzbl %al,%eax
c01045fe:	85 c0                	test   %eax,%eax
c0104600:	75 2c                	jne    c010462e <default_free_pages+0x96>
c0104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104605:	83 c0 04             	add    $0x4,%eax
c0104608:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010460f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104612:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104615:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104618:	0f a3 10             	bt     %edx,(%eax)
c010461b:	19 c0                	sbb    %eax,%eax
c010461d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104620:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104624:	0f 95 c0             	setne  %al
c0104627:	0f b6 c0             	movzbl %al,%eax
c010462a:	85 c0                	test   %eax,%eax
c010462c:	74 24                	je     c0104652 <default_free_pages+0xba>
c010462e:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c0104635:	c0 
c0104636:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010463d:	c0 
c010463e:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0104645:	00 
c0104646:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010464d:	e8 a7 bd ff ff       	call   c01003f9 <__panic>
        p->flags = 0;
c0104652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010465c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104663:	00 
c0104664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104667:	89 04 24             	mov    %eax,(%esp)
c010466a:	e8 21 fc ff ff       	call   c0104290 <set_page_ref>
    for (; p != base + n; p ++) {
c010466f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104673:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104676:	89 d0                	mov    %edx,%eax
c0104678:	c1 e0 02             	shl    $0x2,%eax
c010467b:	01 d0                	add    %edx,%eax
c010467d:	c1 e0 02             	shl    $0x2,%eax
c0104680:	89 c2                	mov    %eax,%edx
c0104682:	8b 45 08             	mov    0x8(%ebp),%eax
c0104685:	01 d0                	add    %edx,%eax
c0104687:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010468a:	0f 85 46 ff ff ff    	jne    c01045d6 <default_free_pages+0x3e>
    }
    base->property = n;
c0104690:	8b 45 08             	mov    0x8(%ebp),%eax
c0104693:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104696:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104699:	8b 45 08             	mov    0x8(%ebp),%eax
c010469c:	83 c0 04             	add    $0x4,%eax
c010469f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01046a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01046ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01046af:	0f ab 10             	bts    %edx,(%eax)
c01046b2:	c7 45 d4 7c af 11 c0 	movl   $0xc011af7c,-0x2c(%ebp)
    return listelm->next;
c01046b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046bc:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01046bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01046c2:	e9 08 01 00 00       	jmp    c01047cf <default_free_pages+0x237>
        p = le2page(le, page_link);
c01046c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ca:	83 e8 0c             	sub    $0xc,%eax
c01046cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01046d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046d9:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01046dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01046df:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e2:	8b 50 08             	mov    0x8(%eax),%edx
c01046e5:	89 d0                	mov    %edx,%eax
c01046e7:	c1 e0 02             	shl    $0x2,%eax
c01046ea:	01 d0                	add    %edx,%eax
c01046ec:	c1 e0 02             	shl    $0x2,%eax
c01046ef:	89 c2                	mov    %eax,%edx
c01046f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046f4:	01 d0                	add    %edx,%eax
c01046f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046f9:	75 5a                	jne    c0104755 <default_free_pages+0x1bd>
            base->property += p->property;
c01046fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fe:	8b 50 08             	mov    0x8(%eax),%edx
c0104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104704:	8b 40 08             	mov    0x8(%eax),%eax
c0104707:	01 c2                	add    %eax,%edx
c0104709:	8b 45 08             	mov    0x8(%ebp),%eax
c010470c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104712:	83 c0 04             	add    $0x4,%eax
c0104715:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010471c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010471f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104722:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104725:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472b:	83 c0 0c             	add    $0xc,%eax
c010472e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104731:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104734:	8b 40 04             	mov    0x4(%eax),%eax
c0104737:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010473a:	8b 12                	mov    (%edx),%edx
c010473c:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010473f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104742:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104745:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104748:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010474b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010474e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104751:	89 10                	mov    %edx,(%eax)
c0104753:	eb 7a                	jmp    c01047cf <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0104755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104758:	8b 50 08             	mov    0x8(%eax),%edx
c010475b:	89 d0                	mov    %edx,%eax
c010475d:	c1 e0 02             	shl    $0x2,%eax
c0104760:	01 d0                	add    %edx,%eax
c0104762:	c1 e0 02             	shl    $0x2,%eax
c0104765:	89 c2                	mov    %eax,%edx
c0104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476a:	01 d0                	add    %edx,%eax
c010476c:	39 45 08             	cmp    %eax,0x8(%ebp)
c010476f:	75 5e                	jne    c01047cf <default_free_pages+0x237>
            p->property += base->property;
c0104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104774:	8b 50 08             	mov    0x8(%eax),%edx
c0104777:	8b 45 08             	mov    0x8(%ebp),%eax
c010477a:	8b 40 08             	mov    0x8(%eax),%eax
c010477d:	01 c2                	add    %eax,%edx
c010477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104782:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104785:	8b 45 08             	mov    0x8(%ebp),%eax
c0104788:	83 c0 04             	add    $0x4,%eax
c010478b:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104792:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104795:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104798:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010479b:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c010479e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a1:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a7:	83 c0 0c             	add    $0xc,%eax
c01047aa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01047ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047b0:	8b 40 04             	mov    0x4(%eax),%eax
c01047b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01047b6:	8b 12                	mov    (%edx),%edx
c01047b8:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01047bb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c01047be:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01047c1:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01047c4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01047c7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01047ca:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01047cd:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01047cf:	81 7d f0 7c af 11 c0 	cmpl   $0xc011af7c,-0x10(%ebp)
c01047d6:	0f 85 eb fe ff ff    	jne    c01046c7 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c01047dc:	8b 15 84 af 11 c0    	mov    0xc011af84,%edx
c01047e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047e5:	01 d0                	add    %edx,%eax
c01047e7:	a3 84 af 11 c0       	mov    %eax,0xc011af84
    list_add(&free_list, &(base->page_link));
c01047ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ef:	83 c0 0c             	add    $0xc,%eax
c01047f2:	c7 45 9c 7c af 11 c0 	movl   $0xc011af7c,-0x64(%ebp)
c01047f9:	89 45 98             	mov    %eax,-0x68(%ebp)
c01047fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01047ff:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104802:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104805:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104808:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010480b:	8b 40 04             	mov    0x4(%eax),%eax
c010480e:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104811:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104814:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104817:	89 55 88             	mov    %edx,-0x78(%ebp)
c010481a:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c010481d:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104820:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104823:	89 10                	mov    %edx,(%eax)
c0104825:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104828:	8b 10                	mov    (%eax),%edx
c010482a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010482d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104830:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104833:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104836:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104839:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010483c:	8b 55 88             	mov    -0x78(%ebp),%edx
c010483f:	89 10                	mov    %edx,(%eax)
}
c0104841:	90                   	nop
c0104842:	c9                   	leave  
c0104843:	c3                   	ret    

c0104844 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104844:	55                   	push   %ebp
c0104845:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104847:	a1 84 af 11 c0       	mov    0xc011af84,%eax
}
c010484c:	5d                   	pop    %ebp
c010484d:	c3                   	ret    

c010484e <basic_check>:

static void
basic_check(void) {
c010484e:	55                   	push   %ebp
c010484f:	89 e5                	mov    %esp,%ebp
c0104851:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104854:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104861:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104864:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104867:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010486e:	e8 c5 e4 ff ff       	call   c0102d38 <alloc_pages>
c0104873:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010487a:	75 24                	jne    c01048a0 <basic_check+0x52>
c010487c:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0104883:	c0 
c0104884:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010488b:	c0 
c010488c:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0104893:	00 
c0104894:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010489b:	e8 59 bb ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01048a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048a7:	e8 8c e4 ff ff       	call   c0102d38 <alloc_pages>
c01048ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048b3:	75 24                	jne    c01048d9 <basic_check+0x8b>
c01048b5:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c01048bc:	c0 
c01048bd:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01048c4:	c0 
c01048c5:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01048cc:	00 
c01048cd:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01048d4:	e8 20 bb ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048e0:	e8 53 e4 ff ff       	call   c0102d38 <alloc_pages>
c01048e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048ec:	75 24                	jne    c0104912 <basic_check+0xc4>
c01048ee:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c01048f5:	c0 
c01048f6:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01048fd:	c0 
c01048fe:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0104905:	00 
c0104906:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010490d:	e8 e7 ba ff ff       	call   c01003f9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104912:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104915:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104918:	74 10                	je     c010492a <basic_check+0xdc>
c010491a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010491d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104920:	74 08                	je     c010492a <basic_check+0xdc>
c0104922:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104925:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104928:	75 24                	jne    c010494e <basic_check+0x100>
c010492a:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0104931:	c0 
c0104932:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104939:	c0 
c010493a:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0104941:	00 
c0104942:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104949:	e8 ab ba ff ff       	call   c01003f9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010494e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104951:	89 04 24             	mov    %eax,(%esp)
c0104954:	e8 2d f9 ff ff       	call   c0104286 <page_ref>
c0104959:	85 c0                	test   %eax,%eax
c010495b:	75 1e                	jne    c010497b <basic_check+0x12d>
c010495d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104960:	89 04 24             	mov    %eax,(%esp)
c0104963:	e8 1e f9 ff ff       	call   c0104286 <page_ref>
c0104968:	85 c0                	test   %eax,%eax
c010496a:	75 0f                	jne    c010497b <basic_check+0x12d>
c010496c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010496f:	89 04 24             	mov    %eax,(%esp)
c0104972:	e8 0f f9 ff ff       	call   c0104286 <page_ref>
c0104977:	85 c0                	test   %eax,%eax
c0104979:	74 24                	je     c010499f <basic_check+0x151>
c010497b:	c7 44 24 0c 9c 6d 10 	movl   $0xc0106d9c,0xc(%esp)
c0104982:	c0 
c0104983:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010498a:	c0 
c010498b:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0104992:	00 
c0104993:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010499a:	e8 5a ba ff ff       	call   c01003f9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010499f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049a2:	89 04 24             	mov    %eax,(%esp)
c01049a5:	e8 c6 f8 ff ff       	call   c0104270 <page2pa>
c01049aa:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01049b0:	c1 e2 0c             	shl    $0xc,%edx
c01049b3:	39 d0                	cmp    %edx,%eax
c01049b5:	72 24                	jb     c01049db <basic_check+0x18d>
c01049b7:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c01049be:	c0 
c01049bf:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01049c6:	c0 
c01049c7:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01049ce:	00 
c01049cf:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01049d6:	e8 1e ba ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01049db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049de:	89 04 24             	mov    %eax,(%esp)
c01049e1:	e8 8a f8 ff ff       	call   c0104270 <page2pa>
c01049e6:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01049ec:	c1 e2 0c             	shl    $0xc,%edx
c01049ef:	39 d0                	cmp    %edx,%eax
c01049f1:	72 24                	jb     c0104a17 <basic_check+0x1c9>
c01049f3:	c7 44 24 0c f5 6d 10 	movl   $0xc0106df5,0xc(%esp)
c01049fa:	c0 
c01049fb:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a02:	c0 
c0104a03:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0104a0a:	00 
c0104a0b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a12:	e8 e2 b9 ff ff       	call   c01003f9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a1a:	89 04 24             	mov    %eax,(%esp)
c0104a1d:	e8 4e f8 ff ff       	call   c0104270 <page2pa>
c0104a22:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104a28:	c1 e2 0c             	shl    $0xc,%edx
c0104a2b:	39 d0                	cmp    %edx,%eax
c0104a2d:	72 24                	jb     c0104a53 <basic_check+0x205>
c0104a2f:	c7 44 24 0c 12 6e 10 	movl   $0xc0106e12,0xc(%esp)
c0104a36:	c0 
c0104a37:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a3e:	c0 
c0104a3f:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104a46:	00 
c0104a47:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a4e:	e8 a6 b9 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c0104a53:	a1 7c af 11 c0       	mov    0xc011af7c,%eax
c0104a58:	8b 15 80 af 11 c0    	mov    0xc011af80,%edx
c0104a5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a61:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a64:	c7 45 dc 7c af 11 c0 	movl   $0xc011af7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a71:	89 50 04             	mov    %edx,0x4(%eax)
c0104a74:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a77:	8b 50 04             	mov    0x4(%eax),%edx
c0104a7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a7d:	89 10                	mov    %edx,(%eax)
c0104a7f:	c7 45 e0 7c af 11 c0 	movl   $0xc011af7c,-0x20(%ebp)
    return list->next == list;
c0104a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a89:	8b 40 04             	mov    0x4(%eax),%eax
c0104a8c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104a8f:	0f 94 c0             	sete   %al
c0104a92:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104a95:	85 c0                	test   %eax,%eax
c0104a97:	75 24                	jne    c0104abd <basic_check+0x26f>
c0104a99:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104aa0:	c0 
c0104aa1:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104aa8:	c0 
c0104aa9:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104ab0:	00 
c0104ab1:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104ab8:	e8 3c b9 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104abd:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104ac2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104ac5:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c0104acc:	00 00 00 

    assert(alloc_page() == NULL);
c0104acf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ad6:	e8 5d e2 ff ff       	call   c0102d38 <alloc_pages>
c0104adb:	85 c0                	test   %eax,%eax
c0104add:	74 24                	je     c0104b03 <basic_check+0x2b5>
c0104adf:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104ae6:	c0 
c0104ae7:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104aee:	c0 
c0104aef:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104af6:	00 
c0104af7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104afe:	e8 f6 b8 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c0104b03:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b0a:	00 
c0104b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b0e:	89 04 24             	mov    %eax,(%esp)
c0104b11:	e8 5a e2 ff ff       	call   c0102d70 <free_pages>
    free_page(p1);
c0104b16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b1d:	00 
c0104b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b21:	89 04 24             	mov    %eax,(%esp)
c0104b24:	e8 47 e2 ff ff       	call   c0102d70 <free_pages>
    free_page(p2);
c0104b29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b30:	00 
c0104b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b34:	89 04 24             	mov    %eax,(%esp)
c0104b37:	e8 34 e2 ff ff       	call   c0102d70 <free_pages>
    assert(nr_free == 3);
c0104b3c:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104b41:	83 f8 03             	cmp    $0x3,%eax
c0104b44:	74 24                	je     c0104b6a <basic_check+0x31c>
c0104b46:	c7 44 24 0c 5b 6e 10 	movl   $0xc0106e5b,0xc(%esp)
c0104b4d:	c0 
c0104b4e:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b55:	c0 
c0104b56:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104b5d:	00 
c0104b5e:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b65:	e8 8f b8 ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b71:	e8 c2 e1 ff ff       	call   c0102d38 <alloc_pages>
c0104b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b7d:	75 24                	jne    c0104ba3 <basic_check+0x355>
c0104b7f:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b9e:	e8 56 b8 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104baa:	e8 89 e1 ff ff       	call   c0102d38 <alloc_pages>
c0104baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bb6:	75 24                	jne    c0104bdc <basic_check+0x38e>
c0104bb8:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c0104bbf:	c0 
c0104bc0:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0104bcf:	00 
c0104bd0:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104bd7:	e8 1d b8 ff ff       	call   c01003f9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104bdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104be3:	e8 50 e1 ff ff       	call   c0102d38 <alloc_pages>
c0104be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bef:	75 24                	jne    c0104c15 <basic_check+0x3c7>
c0104bf1:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c0104bf8:	c0 
c0104bf9:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c00:	c0 
c0104c01:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0104c08:	00 
c0104c09:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c10:	e8 e4 b7 ff ff       	call   c01003f9 <__panic>

    assert(alloc_page() == NULL);
c0104c15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c1c:	e8 17 e1 ff ff       	call   c0102d38 <alloc_pages>
c0104c21:	85 c0                	test   %eax,%eax
c0104c23:	74 24                	je     c0104c49 <basic_check+0x3fb>
c0104c25:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104c2c:	c0 
c0104c2d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c34:	c0 
c0104c35:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104c3c:	00 
c0104c3d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c44:	e8 b0 b7 ff ff       	call   c01003f9 <__panic>

    free_page(p0);
c0104c49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c50:	00 
c0104c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c54:	89 04 24             	mov    %eax,(%esp)
c0104c57:	e8 14 e1 ff ff       	call   c0102d70 <free_pages>
c0104c5c:	c7 45 d8 7c af 11 c0 	movl   $0xc011af7c,-0x28(%ebp)
c0104c63:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c66:	8b 40 04             	mov    0x4(%eax),%eax
c0104c69:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104c6c:	0f 94 c0             	sete   %al
c0104c6f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104c72:	85 c0                	test   %eax,%eax
c0104c74:	74 24                	je     c0104c9a <basic_check+0x44c>
c0104c76:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104c7d:	c0 
c0104c7e:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c85:	c0 
c0104c86:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104c8d:	00 
c0104c8e:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c95:	e8 5f b7 ff ff       	call   c01003f9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104c9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ca1:	e8 92 e0 ff ff       	call   c0102d38 <alloc_pages>
c0104ca6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104caf:	74 24                	je     c0104cd5 <basic_check+0x487>
c0104cb1:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104cb8:	c0 
c0104cb9:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104cc0:	c0 
c0104cc1:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104cc8:	00 
c0104cc9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104cd0:	e8 24 b7 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0104cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cdc:	e8 57 e0 ff ff       	call   c0102d38 <alloc_pages>
c0104ce1:	85 c0                	test   %eax,%eax
c0104ce3:	74 24                	je     c0104d09 <basic_check+0x4bb>
c0104ce5:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104cec:	c0 
c0104ced:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104cf4:	c0 
c0104cf5:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104cfc:	00 
c0104cfd:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104d04:	e8 f0 b6 ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c0104d09:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104d0e:	85 c0                	test   %eax,%eax
c0104d10:	74 24                	je     c0104d36 <basic_check+0x4e8>
c0104d12:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104d19:	c0 
c0104d1a:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104d21:	c0 
c0104d22:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104d29:	00 
c0104d2a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104d31:	e8 c3 b6 ff ff       	call   c01003f9 <__panic>
    free_list = free_list_store;
c0104d36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d3c:	a3 7c af 11 c0       	mov    %eax,0xc011af7c
c0104d41:	89 15 80 af 11 c0    	mov    %edx,0xc011af80
    nr_free = nr_free_store;
c0104d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d4a:	a3 84 af 11 c0       	mov    %eax,0xc011af84

    free_page(p);
c0104d4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d56:	00 
c0104d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d5a:	89 04 24             	mov    %eax,(%esp)
c0104d5d:	e8 0e e0 ff ff       	call   c0102d70 <free_pages>
    free_page(p1);
c0104d62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d69:	00 
c0104d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d6d:	89 04 24             	mov    %eax,(%esp)
c0104d70:	e8 fb df ff ff       	call   c0102d70 <free_pages>
    free_page(p2);
c0104d75:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d7c:	00 
c0104d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d80:	89 04 24             	mov    %eax,(%esp)
c0104d83:	e8 e8 df ff ff       	call   c0102d70 <free_pages>
}
c0104d88:	90                   	nop
c0104d89:	c9                   	leave  
c0104d8a:	c3                   	ret    

c0104d8b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104d8b:	55                   	push   %ebp
c0104d8c:	89 e5                	mov    %esp,%ebp
c0104d8e:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d9b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104da2:	c7 45 ec 7c af 11 c0 	movl   $0xc011af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104da9:	eb 6a                	jmp    c0104e15 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0104dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dae:	83 e8 0c             	sub    $0xc,%eax
c0104db1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104db4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104db7:	83 c0 04             	add    $0x4,%eax
c0104dba:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104dc1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104dc7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104dca:	0f a3 10             	bt     %edx,(%eax)
c0104dcd:	19 c0                	sbb    %eax,%eax
c0104dcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104dd2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104dd6:	0f 95 c0             	setne  %al
c0104dd9:	0f b6 c0             	movzbl %al,%eax
c0104ddc:	85 c0                	test   %eax,%eax
c0104dde:	75 24                	jne    c0104e04 <default_check+0x79>
c0104de0:	c7 44 24 0c a6 6e 10 	movl   $0xc0106ea6,0xc(%esp)
c0104de7:	c0 
c0104de8:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104def:	c0 
c0104df0:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104df7:	00 
c0104df8:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104dff:	e8 f5 b5 ff ff       	call   c01003f9 <__panic>
        count ++, total += p->property;
c0104e04:	ff 45 f4             	incl   -0xc(%ebp)
c0104e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e0a:	8b 50 08             	mov    0x8(%eax),%edx
c0104e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e10:	01 d0                	add    %edx,%eax
c0104e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104e1b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e1e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e24:	81 7d ec 7c af 11 c0 	cmpl   $0xc011af7c,-0x14(%ebp)
c0104e2b:	0f 85 7a ff ff ff    	jne    c0104dab <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104e31:	e8 6d df ff ff       	call   c0102da3 <nr_free_pages>
c0104e36:	89 c2                	mov    %eax,%edx
c0104e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e3b:	39 c2                	cmp    %eax,%edx
c0104e3d:	74 24                	je     c0104e63 <default_check+0xd8>
c0104e3f:	c7 44 24 0c b6 6e 10 	movl   $0xc0106eb6,0xc(%esp)
c0104e46:	c0 
c0104e47:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e4e:	c0 
c0104e4f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104e56:	00 
c0104e57:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e5e:	e8 96 b5 ff ff       	call   c01003f9 <__panic>

    basic_check();
c0104e63:	e8 e6 f9 ff ff       	call   c010484e <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104e68:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104e6f:	e8 c4 de ff ff       	call   c0102d38 <alloc_pages>
c0104e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e7b:	75 24                	jne    c0104ea1 <default_check+0x116>
c0104e7d:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0104e84:	c0 
c0104e85:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e8c:	c0 
c0104e8d:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104e94:	00 
c0104e95:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e9c:	e8 58 b5 ff ff       	call   c01003f9 <__panic>
    assert(!PageProperty(p0));
c0104ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ea4:	83 c0 04             	add    $0x4,%eax
c0104ea7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104eae:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104eb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104eb4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104eb7:	0f a3 10             	bt     %edx,(%eax)
c0104eba:	19 c0                	sbb    %eax,%eax
c0104ebc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104ebf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104ec3:	0f 95 c0             	setne  %al
c0104ec6:	0f b6 c0             	movzbl %al,%eax
c0104ec9:	85 c0                	test   %eax,%eax
c0104ecb:	74 24                	je     c0104ef1 <default_check+0x166>
c0104ecd:	c7 44 24 0c da 6e 10 	movl   $0xc0106eda,0xc(%esp)
c0104ed4:	c0 
c0104ed5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104ee4:	00 
c0104ee5:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104eec:	e8 08 b5 ff ff       	call   c01003f9 <__panic>

    list_entry_t free_list_store = free_list;
c0104ef1:	a1 7c af 11 c0       	mov    0xc011af7c,%eax
c0104ef6:	8b 15 80 af 11 c0    	mov    0xc011af80,%edx
c0104efc:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104eff:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104f02:	c7 45 b0 7c af 11 c0 	movl   $0xc011af7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104f09:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f0c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104f0f:	89 50 04             	mov    %edx,0x4(%eax)
c0104f12:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f15:	8b 50 04             	mov    0x4(%eax),%edx
c0104f18:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f1b:	89 10                	mov    %edx,(%eax)
c0104f1d:	c7 45 b4 7c af 11 c0 	movl   $0xc011af7c,-0x4c(%ebp)
    return list->next == list;
c0104f24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f27:	8b 40 04             	mov    0x4(%eax),%eax
c0104f2a:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104f2d:	0f 94 c0             	sete   %al
c0104f30:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104f33:	85 c0                	test   %eax,%eax
c0104f35:	75 24                	jne    c0104f5b <default_check+0x1d0>
c0104f37:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104f3e:	c0 
c0104f3f:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f46:	c0 
c0104f47:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104f4e:	00 
c0104f4f:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f56:	e8 9e b4 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0104f5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f62:	e8 d1 dd ff ff       	call   c0102d38 <alloc_pages>
c0104f67:	85 c0                	test   %eax,%eax
c0104f69:	74 24                	je     c0104f8f <default_check+0x204>
c0104f6b:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104f72:	c0 
c0104f73:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f7a:	c0 
c0104f7b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104f82:	00 
c0104f83:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f8a:	e8 6a b4 ff ff       	call   c01003f9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104f8f:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104f97:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c0104f9e:	00 00 00 

    free_pages(p0 + 2, 3);
c0104fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fa4:	83 c0 28             	add    $0x28,%eax
c0104fa7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104fae:	00 
c0104faf:	89 04 24             	mov    %eax,(%esp)
c0104fb2:	e8 b9 dd ff ff       	call   c0102d70 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104fb7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104fbe:	e8 75 dd ff ff       	call   c0102d38 <alloc_pages>
c0104fc3:	85 c0                	test   %eax,%eax
c0104fc5:	74 24                	je     c0104feb <default_check+0x260>
c0104fc7:	c7 44 24 0c ec 6e 10 	movl   $0xc0106eec,0xc(%esp)
c0104fce:	c0 
c0104fcf:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104fd6:	c0 
c0104fd7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0104fde:	00 
c0104fdf:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104fe6:	e8 0e b4 ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fee:	83 c0 28             	add    $0x28,%eax
c0104ff1:	83 c0 04             	add    $0x4,%eax
c0104ff4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104ffb:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ffe:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105001:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105004:	0f a3 10             	bt     %edx,(%eax)
c0105007:	19 c0                	sbb    %eax,%eax
c0105009:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010500c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105010:	0f 95 c0             	setne  %al
c0105013:	0f b6 c0             	movzbl %al,%eax
c0105016:	85 c0                	test   %eax,%eax
c0105018:	74 0e                	je     c0105028 <default_check+0x29d>
c010501a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010501d:	83 c0 28             	add    $0x28,%eax
c0105020:	8b 40 08             	mov    0x8(%eax),%eax
c0105023:	83 f8 03             	cmp    $0x3,%eax
c0105026:	74 24                	je     c010504c <default_check+0x2c1>
c0105028:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c010502f:	c0 
c0105030:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105037:	c0 
c0105038:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010503f:	00 
c0105040:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105047:	e8 ad b3 ff ff       	call   c01003f9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010504c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105053:	e8 e0 dc ff ff       	call   c0102d38 <alloc_pages>
c0105058:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010505b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010505f:	75 24                	jne    c0105085 <default_check+0x2fa>
c0105061:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0105068:	c0 
c0105069:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105070:	c0 
c0105071:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0105078:	00 
c0105079:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105080:	e8 74 b3 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c0105085:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010508c:	e8 a7 dc ff ff       	call   c0102d38 <alloc_pages>
c0105091:	85 c0                	test   %eax,%eax
c0105093:	74 24                	je     c01050b9 <default_check+0x32e>
c0105095:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c010509c:	c0 
c010509d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01050a4:	c0 
c01050a5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01050ac:	00 
c01050ad:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01050b4:	e8 40 b3 ff ff       	call   c01003f9 <__panic>
    assert(p0 + 2 == p1);
c01050b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050bc:	83 c0 28             	add    $0x28,%eax
c01050bf:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01050c2:	74 24                	je     c01050e8 <default_check+0x35d>
c01050c4:	c7 44 24 0c 4e 6f 10 	movl   $0xc0106f4e,0xc(%esp)
c01050cb:	c0 
c01050cc:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01050d3:	c0 
c01050d4:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01050db:	00 
c01050dc:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01050e3:	e8 11 b3 ff ff       	call   c01003f9 <__panic>

    p2 = p0 + 1;
c01050e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050eb:	83 c0 14             	add    $0x14,%eax
c01050ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01050f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050f8:	00 
c01050f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050fc:	89 04 24             	mov    %eax,(%esp)
c01050ff:	e8 6c dc ff ff       	call   c0102d70 <free_pages>
    free_pages(p1, 3);
c0105104:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010510b:	00 
c010510c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010510f:	89 04 24             	mov    %eax,(%esp)
c0105112:	e8 59 dc ff ff       	call   c0102d70 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105117:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010511a:	83 c0 04             	add    $0x4,%eax
c010511d:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105124:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105127:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010512a:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010512d:	0f a3 10             	bt     %edx,(%eax)
c0105130:	19 c0                	sbb    %eax,%eax
c0105132:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105135:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105139:	0f 95 c0             	setne  %al
c010513c:	0f b6 c0             	movzbl %al,%eax
c010513f:	85 c0                	test   %eax,%eax
c0105141:	74 0b                	je     c010514e <default_check+0x3c3>
c0105143:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105146:	8b 40 08             	mov    0x8(%eax),%eax
c0105149:	83 f8 01             	cmp    $0x1,%eax
c010514c:	74 24                	je     c0105172 <default_check+0x3e7>
c010514e:	c7 44 24 0c 5c 6f 10 	movl   $0xc0106f5c,0xc(%esp)
c0105155:	c0 
c0105156:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010515d:	c0 
c010515e:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105165:	00 
c0105166:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010516d:	e8 87 b2 ff ff       	call   c01003f9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105172:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105175:	83 c0 04             	add    $0x4,%eax
c0105178:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010517f:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105182:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105185:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105188:	0f a3 10             	bt     %edx,(%eax)
c010518b:	19 c0                	sbb    %eax,%eax
c010518d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105190:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105194:	0f 95 c0             	setne  %al
c0105197:	0f b6 c0             	movzbl %al,%eax
c010519a:	85 c0                	test   %eax,%eax
c010519c:	74 0b                	je     c01051a9 <default_check+0x41e>
c010519e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051a1:	8b 40 08             	mov    0x8(%eax),%eax
c01051a4:	83 f8 03             	cmp    $0x3,%eax
c01051a7:	74 24                	je     c01051cd <default_check+0x442>
c01051a9:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c01051b0:	c0 
c01051b1:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01051b8:	c0 
c01051b9:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c01051c0:	00 
c01051c1:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01051c8:	e8 2c b2 ff ff       	call   c01003f9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01051cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051d4:	e8 5f db ff ff       	call   c0102d38 <alloc_pages>
c01051d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051df:	83 e8 14             	sub    $0x14,%eax
c01051e2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01051e5:	74 24                	je     c010520b <default_check+0x480>
c01051e7:	c7 44 24 0c aa 6f 10 	movl   $0xc0106faa,0xc(%esp)
c01051ee:	c0 
c01051ef:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01051f6:	c0 
c01051f7:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01051fe:	00 
c01051ff:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105206:	e8 ee b1 ff ff       	call   c01003f9 <__panic>
    free_page(p0);
c010520b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105212:	00 
c0105213:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105216:	89 04 24             	mov    %eax,(%esp)
c0105219:	e8 52 db ff ff       	call   c0102d70 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010521e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105225:	e8 0e db ff ff       	call   c0102d38 <alloc_pages>
c010522a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010522d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105230:	83 c0 14             	add    $0x14,%eax
c0105233:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105236:	74 24                	je     c010525c <default_check+0x4d1>
c0105238:	c7 44 24 0c c8 6f 10 	movl   $0xc0106fc8,0xc(%esp)
c010523f:	c0 
c0105240:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105247:	c0 
c0105248:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010524f:	00 
c0105250:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105257:	e8 9d b1 ff ff       	call   c01003f9 <__panic>

    free_pages(p0, 2);
c010525c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105263:	00 
c0105264:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105267:	89 04 24             	mov    %eax,(%esp)
c010526a:	e8 01 db ff ff       	call   c0102d70 <free_pages>
    free_page(p2);
c010526f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105276:	00 
c0105277:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010527a:	89 04 24             	mov    %eax,(%esp)
c010527d:	e8 ee da ff ff       	call   c0102d70 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105282:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105289:	e8 aa da ff ff       	call   c0102d38 <alloc_pages>
c010528e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105291:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105295:	75 24                	jne    c01052bb <default_check+0x530>
c0105297:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c010529e:	c0 
c010529f:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052a6:	c0 
c01052a7:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01052ae:	00 
c01052af:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052b6:	e8 3e b1 ff ff       	call   c01003f9 <__panic>
    assert(alloc_page() == NULL);
c01052bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052c2:	e8 71 da ff ff       	call   c0102d38 <alloc_pages>
c01052c7:	85 c0                	test   %eax,%eax
c01052c9:	74 24                	je     c01052ef <default_check+0x564>
c01052cb:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c01052d2:	c0 
c01052d3:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052da:	c0 
c01052db:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01052e2:	00 
c01052e3:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052ea:	e8 0a b1 ff ff       	call   c01003f9 <__panic>

    assert(nr_free == 0);
c01052ef:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c01052f4:	85 c0                	test   %eax,%eax
c01052f6:	74 24                	je     c010531c <default_check+0x591>
c01052f8:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c01052ff:	c0 
c0105300:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105307:	c0 
c0105308:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c010530f:	00 
c0105310:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105317:	e8 dd b0 ff ff       	call   c01003f9 <__panic>
    nr_free = nr_free_store;
c010531c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010531f:	a3 84 af 11 c0       	mov    %eax,0xc011af84

    free_list = free_list_store;
c0105324:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105327:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010532a:	a3 7c af 11 c0       	mov    %eax,0xc011af7c
c010532f:	89 15 80 af 11 c0    	mov    %edx,0xc011af80
    free_pages(p0, 5);
c0105335:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010533c:	00 
c010533d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105340:	89 04 24             	mov    %eax,(%esp)
c0105343:	e8 28 da ff ff       	call   c0102d70 <free_pages>

    le = &free_list;
c0105348:	c7 45 ec 7c af 11 c0 	movl   $0xc011af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010534f:	eb 5a                	jmp    c01053ab <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
c0105351:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105354:	8b 40 04             	mov    0x4(%eax),%eax
c0105357:	8b 00                	mov    (%eax),%eax
c0105359:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010535c:	75 0d                	jne    c010536b <default_check+0x5e0>
c010535e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105361:	8b 00                	mov    (%eax),%eax
c0105363:	8b 40 04             	mov    0x4(%eax),%eax
c0105366:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105369:	74 24                	je     c010538f <default_check+0x604>
c010536b:	c7 44 24 0c 08 70 10 	movl   $0xc0107008,0xc(%esp)
c0105372:	c0 
c0105373:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010537a:	c0 
c010537b:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0105382:	00 
c0105383:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010538a:	e8 6a b0 ff ff       	call   c01003f9 <__panic>
        struct Page *p = le2page(le, page_link);
c010538f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105392:	83 e8 0c             	sub    $0xc,%eax
c0105395:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105398:	ff 4d f4             	decl   -0xc(%ebp)
c010539b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010539e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053a1:	8b 40 08             	mov    0x8(%eax),%eax
c01053a4:	29 c2                	sub    %eax,%edx
c01053a6:	89 d0                	mov    %edx,%eax
c01053a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ae:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01053b1:	8b 45 88             	mov    -0x78(%ebp),%eax
c01053b4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01053b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053ba:	81 7d ec 7c af 11 c0 	cmpl   $0xc011af7c,-0x14(%ebp)
c01053c1:	75 8e                	jne    c0105351 <default_check+0x5c6>
    }
    assert(count == 0);
c01053c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053c7:	74 24                	je     c01053ed <default_check+0x662>
c01053c9:	c7 44 24 0c 35 70 10 	movl   $0xc0107035,0xc(%esp)
c01053d0:	c0 
c01053d1:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01053d8:	c0 
c01053d9:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01053e0:	00 
c01053e1:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01053e8:	e8 0c b0 ff ff       	call   c01003f9 <__panic>
    assert(total == 0);
c01053ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053f1:	74 24                	je     c0105417 <default_check+0x68c>
c01053f3:	c7 44 24 0c 40 70 10 	movl   $0xc0107040,0xc(%esp)
c01053fa:	c0 
c01053fb:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105402:	c0 
c0105403:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010540a:	00 
c010540b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105412:	e8 e2 af ff ff       	call   c01003f9 <__panic>
}
c0105417:	90                   	nop
c0105418:	c9                   	leave  
c0105419:	c3                   	ret    

c010541a <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010541a:	55                   	push   %ebp
c010541b:	89 e5                	mov    %esp,%ebp
c010541d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105420:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105427:	eb 03                	jmp    c010542c <strlen+0x12>
        cnt ++;
c0105429:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010542c:	8b 45 08             	mov    0x8(%ebp),%eax
c010542f:	8d 50 01             	lea    0x1(%eax),%edx
c0105432:	89 55 08             	mov    %edx,0x8(%ebp)
c0105435:	0f b6 00             	movzbl (%eax),%eax
c0105438:	84 c0                	test   %al,%al
c010543a:	75 ed                	jne    c0105429 <strlen+0xf>
    }
    return cnt;
c010543c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010543f:	c9                   	leave  
c0105440:	c3                   	ret    

c0105441 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105441:	55                   	push   %ebp
c0105442:	89 e5                	mov    %esp,%ebp
c0105444:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010544e:	eb 03                	jmp    c0105453 <strnlen+0x12>
        cnt ++;
c0105450:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105456:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105459:	73 10                	jae    c010546b <strnlen+0x2a>
c010545b:	8b 45 08             	mov    0x8(%ebp),%eax
c010545e:	8d 50 01             	lea    0x1(%eax),%edx
c0105461:	89 55 08             	mov    %edx,0x8(%ebp)
c0105464:	0f b6 00             	movzbl (%eax),%eax
c0105467:	84 c0                	test   %al,%al
c0105469:	75 e5                	jne    c0105450 <strnlen+0xf>
    }
    return cnt;
c010546b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010546e:	c9                   	leave  
c010546f:	c3                   	ret    

c0105470 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105470:	55                   	push   %ebp
c0105471:	89 e5                	mov    %esp,%ebp
c0105473:	57                   	push   %edi
c0105474:	56                   	push   %esi
c0105475:	83 ec 20             	sub    $0x20,%esp
c0105478:	8b 45 08             	mov    0x8(%ebp),%eax
c010547b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010547e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105481:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105484:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105487:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010548a:	89 d1                	mov    %edx,%ecx
c010548c:	89 c2                	mov    %eax,%edx
c010548e:	89 ce                	mov    %ecx,%esi
c0105490:	89 d7                	mov    %edx,%edi
c0105492:	ac                   	lods   %ds:(%esi),%al
c0105493:	aa                   	stos   %al,%es:(%edi)
c0105494:	84 c0                	test   %al,%al
c0105496:	75 fa                	jne    c0105492 <strcpy+0x22>
c0105498:	89 fa                	mov    %edi,%edx
c010549a:	89 f1                	mov    %esi,%ecx
c010549c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010549f:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01054a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01054a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01054a8:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01054a9:	83 c4 20             	add    $0x20,%esp
c01054ac:	5e                   	pop    %esi
c01054ad:	5f                   	pop    %edi
c01054ae:	5d                   	pop    %ebp
c01054af:	c3                   	ret    

c01054b0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01054b0:	55                   	push   %ebp
c01054b1:	89 e5                	mov    %esp,%ebp
c01054b3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01054b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01054bc:	eb 1e                	jmp    c01054dc <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01054be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c1:	0f b6 10             	movzbl (%eax),%edx
c01054c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054c7:	88 10                	mov    %dl,(%eax)
c01054c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054cc:	0f b6 00             	movzbl (%eax),%eax
c01054cf:	84 c0                	test   %al,%al
c01054d1:	74 03                	je     c01054d6 <strncpy+0x26>
            src ++;
c01054d3:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01054d6:	ff 45 fc             	incl   -0x4(%ebp)
c01054d9:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01054dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054e0:	75 dc                	jne    c01054be <strncpy+0xe>
    }
    return dst;
c01054e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01054e5:	c9                   	leave  
c01054e6:	c3                   	ret    

c01054e7 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01054e7:	55                   	push   %ebp
c01054e8:	89 e5                	mov    %esp,%ebp
c01054ea:	57                   	push   %edi
c01054eb:	56                   	push   %esi
c01054ec:	83 ec 20             	sub    $0x20,%esp
c01054ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01054fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105501:	89 d1                	mov    %edx,%ecx
c0105503:	89 c2                	mov    %eax,%edx
c0105505:	89 ce                	mov    %ecx,%esi
c0105507:	89 d7                	mov    %edx,%edi
c0105509:	ac                   	lods   %ds:(%esi),%al
c010550a:	ae                   	scas   %es:(%edi),%al
c010550b:	75 08                	jne    c0105515 <strcmp+0x2e>
c010550d:	84 c0                	test   %al,%al
c010550f:	75 f8                	jne    c0105509 <strcmp+0x22>
c0105511:	31 c0                	xor    %eax,%eax
c0105513:	eb 04                	jmp    c0105519 <strcmp+0x32>
c0105515:	19 c0                	sbb    %eax,%eax
c0105517:	0c 01                	or     $0x1,%al
c0105519:	89 fa                	mov    %edi,%edx
c010551b:	89 f1                	mov    %esi,%ecx
c010551d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105520:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105523:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105526:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105529:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010552a:	83 c4 20             	add    $0x20,%esp
c010552d:	5e                   	pop    %esi
c010552e:	5f                   	pop    %edi
c010552f:	5d                   	pop    %ebp
c0105530:	c3                   	ret    

c0105531 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105531:	55                   	push   %ebp
c0105532:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105534:	eb 09                	jmp    c010553f <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105536:	ff 4d 10             	decl   0x10(%ebp)
c0105539:	ff 45 08             	incl   0x8(%ebp)
c010553c:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010553f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105543:	74 1a                	je     c010555f <strncmp+0x2e>
c0105545:	8b 45 08             	mov    0x8(%ebp),%eax
c0105548:	0f b6 00             	movzbl (%eax),%eax
c010554b:	84 c0                	test   %al,%al
c010554d:	74 10                	je     c010555f <strncmp+0x2e>
c010554f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105552:	0f b6 10             	movzbl (%eax),%edx
c0105555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105558:	0f b6 00             	movzbl (%eax),%eax
c010555b:	38 c2                	cmp    %al,%dl
c010555d:	74 d7                	je     c0105536 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010555f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105563:	74 18                	je     c010557d <strncmp+0x4c>
c0105565:	8b 45 08             	mov    0x8(%ebp),%eax
c0105568:	0f b6 00             	movzbl (%eax),%eax
c010556b:	0f b6 d0             	movzbl %al,%edx
c010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105571:	0f b6 00             	movzbl (%eax),%eax
c0105574:	0f b6 c0             	movzbl %al,%eax
c0105577:	29 c2                	sub    %eax,%edx
c0105579:	89 d0                	mov    %edx,%eax
c010557b:	eb 05                	jmp    c0105582 <strncmp+0x51>
c010557d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105582:	5d                   	pop    %ebp
c0105583:	c3                   	ret    

c0105584 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105584:	55                   	push   %ebp
c0105585:	89 e5                	mov    %esp,%ebp
c0105587:	83 ec 04             	sub    $0x4,%esp
c010558a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010558d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105590:	eb 13                	jmp    c01055a5 <strchr+0x21>
        if (*s == c) {
c0105592:	8b 45 08             	mov    0x8(%ebp),%eax
c0105595:	0f b6 00             	movzbl (%eax),%eax
c0105598:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010559b:	75 05                	jne    c01055a2 <strchr+0x1e>
            return (char *)s;
c010559d:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a0:	eb 12                	jmp    c01055b4 <strchr+0x30>
        }
        s ++;
c01055a2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a8:	0f b6 00             	movzbl (%eax),%eax
c01055ab:	84 c0                	test   %al,%al
c01055ad:	75 e3                	jne    c0105592 <strchr+0xe>
    }
    return NULL;
c01055af:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055b4:	c9                   	leave  
c01055b5:	c3                   	ret    

c01055b6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01055b6:	55                   	push   %ebp
c01055b7:	89 e5                	mov    %esp,%ebp
c01055b9:	83 ec 04             	sub    $0x4,%esp
c01055bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055bf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01055c2:	eb 0e                	jmp    c01055d2 <strfind+0x1c>
        if (*s == c) {
c01055c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c7:	0f b6 00             	movzbl (%eax),%eax
c01055ca:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01055cd:	74 0f                	je     c01055de <strfind+0x28>
            break;
        }
        s ++;
c01055cf:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d5:	0f b6 00             	movzbl (%eax),%eax
c01055d8:	84 c0                	test   %al,%al
c01055da:	75 e8                	jne    c01055c4 <strfind+0xe>
c01055dc:	eb 01                	jmp    c01055df <strfind+0x29>
            break;
c01055de:	90                   	nop
    }
    return (char *)s;
c01055df:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055e2:	c9                   	leave  
c01055e3:	c3                   	ret    

c01055e4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01055e4:	55                   	push   %ebp
c01055e5:	89 e5                	mov    %esp,%ebp
c01055e7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01055ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01055f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01055f8:	eb 03                	jmp    c01055fd <strtol+0x19>
        s ++;
c01055fa:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01055fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105600:	0f b6 00             	movzbl (%eax),%eax
c0105603:	3c 20                	cmp    $0x20,%al
c0105605:	74 f3                	je     c01055fa <strtol+0x16>
c0105607:	8b 45 08             	mov    0x8(%ebp),%eax
c010560a:	0f b6 00             	movzbl (%eax),%eax
c010560d:	3c 09                	cmp    $0x9,%al
c010560f:	74 e9                	je     c01055fa <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105611:	8b 45 08             	mov    0x8(%ebp),%eax
c0105614:	0f b6 00             	movzbl (%eax),%eax
c0105617:	3c 2b                	cmp    $0x2b,%al
c0105619:	75 05                	jne    c0105620 <strtol+0x3c>
        s ++;
c010561b:	ff 45 08             	incl   0x8(%ebp)
c010561e:	eb 14                	jmp    c0105634 <strtol+0x50>
    }
    else if (*s == '-') {
c0105620:	8b 45 08             	mov    0x8(%ebp),%eax
c0105623:	0f b6 00             	movzbl (%eax),%eax
c0105626:	3c 2d                	cmp    $0x2d,%al
c0105628:	75 0a                	jne    c0105634 <strtol+0x50>
        s ++, neg = 1;
c010562a:	ff 45 08             	incl   0x8(%ebp)
c010562d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105634:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105638:	74 06                	je     c0105640 <strtol+0x5c>
c010563a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010563e:	75 22                	jne    c0105662 <strtol+0x7e>
c0105640:	8b 45 08             	mov    0x8(%ebp),%eax
c0105643:	0f b6 00             	movzbl (%eax),%eax
c0105646:	3c 30                	cmp    $0x30,%al
c0105648:	75 18                	jne    c0105662 <strtol+0x7e>
c010564a:	8b 45 08             	mov    0x8(%ebp),%eax
c010564d:	40                   	inc    %eax
c010564e:	0f b6 00             	movzbl (%eax),%eax
c0105651:	3c 78                	cmp    $0x78,%al
c0105653:	75 0d                	jne    c0105662 <strtol+0x7e>
        s += 2, base = 16;
c0105655:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105659:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105660:	eb 29                	jmp    c010568b <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105662:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105666:	75 16                	jne    c010567e <strtol+0x9a>
c0105668:	8b 45 08             	mov    0x8(%ebp),%eax
c010566b:	0f b6 00             	movzbl (%eax),%eax
c010566e:	3c 30                	cmp    $0x30,%al
c0105670:	75 0c                	jne    c010567e <strtol+0x9a>
        s ++, base = 8;
c0105672:	ff 45 08             	incl   0x8(%ebp)
c0105675:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010567c:	eb 0d                	jmp    c010568b <strtol+0xa7>
    }
    else if (base == 0) {
c010567e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105682:	75 07                	jne    c010568b <strtol+0xa7>
        base = 10;
c0105684:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010568b:	8b 45 08             	mov    0x8(%ebp),%eax
c010568e:	0f b6 00             	movzbl (%eax),%eax
c0105691:	3c 2f                	cmp    $0x2f,%al
c0105693:	7e 1b                	jle    c01056b0 <strtol+0xcc>
c0105695:	8b 45 08             	mov    0x8(%ebp),%eax
c0105698:	0f b6 00             	movzbl (%eax),%eax
c010569b:	3c 39                	cmp    $0x39,%al
c010569d:	7f 11                	jg     c01056b0 <strtol+0xcc>
            dig = *s - '0';
c010569f:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a2:	0f b6 00             	movzbl (%eax),%eax
c01056a5:	0f be c0             	movsbl %al,%eax
c01056a8:	83 e8 30             	sub    $0x30,%eax
c01056ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056ae:	eb 48                	jmp    c01056f8 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01056b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b3:	0f b6 00             	movzbl (%eax),%eax
c01056b6:	3c 60                	cmp    $0x60,%al
c01056b8:	7e 1b                	jle    c01056d5 <strtol+0xf1>
c01056ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bd:	0f b6 00             	movzbl (%eax),%eax
c01056c0:	3c 7a                	cmp    $0x7a,%al
c01056c2:	7f 11                	jg     c01056d5 <strtol+0xf1>
            dig = *s - 'a' + 10;
c01056c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c7:	0f b6 00             	movzbl (%eax),%eax
c01056ca:	0f be c0             	movsbl %al,%eax
c01056cd:	83 e8 57             	sub    $0x57,%eax
c01056d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056d3:	eb 23                	jmp    c01056f8 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01056d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d8:	0f b6 00             	movzbl (%eax),%eax
c01056db:	3c 40                	cmp    $0x40,%al
c01056dd:	7e 3b                	jle    c010571a <strtol+0x136>
c01056df:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e2:	0f b6 00             	movzbl (%eax),%eax
c01056e5:	3c 5a                	cmp    $0x5a,%al
c01056e7:	7f 31                	jg     c010571a <strtol+0x136>
            dig = *s - 'A' + 10;
c01056e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ec:	0f b6 00             	movzbl (%eax),%eax
c01056ef:	0f be c0             	movsbl %al,%eax
c01056f2:	83 e8 37             	sub    $0x37,%eax
c01056f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01056f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056fb:	3b 45 10             	cmp    0x10(%ebp),%eax
c01056fe:	7d 19                	jge    c0105719 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105700:	ff 45 08             	incl   0x8(%ebp)
c0105703:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105706:	0f af 45 10          	imul   0x10(%ebp),%eax
c010570a:	89 c2                	mov    %eax,%edx
c010570c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010570f:	01 d0                	add    %edx,%eax
c0105711:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105714:	e9 72 ff ff ff       	jmp    c010568b <strtol+0xa7>
            break;
c0105719:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c010571a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010571e:	74 08                	je     c0105728 <strtol+0x144>
        *endptr = (char *) s;
c0105720:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105723:	8b 55 08             	mov    0x8(%ebp),%edx
c0105726:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105728:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010572c:	74 07                	je     c0105735 <strtol+0x151>
c010572e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105731:	f7 d8                	neg    %eax
c0105733:	eb 03                	jmp    c0105738 <strtol+0x154>
c0105735:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105738:	c9                   	leave  
c0105739:	c3                   	ret    

c010573a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010573a:	55                   	push   %ebp
c010573b:	89 e5                	mov    %esp,%ebp
c010573d:	57                   	push   %edi
c010573e:	83 ec 24             	sub    $0x24,%esp
c0105741:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105744:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105747:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010574b:	8b 55 08             	mov    0x8(%ebp),%edx
c010574e:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105751:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105754:	8b 45 10             	mov    0x10(%ebp),%eax
c0105757:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010575a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010575d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105761:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105764:	89 d7                	mov    %edx,%edi
c0105766:	f3 aa                	rep stos %al,%es:(%edi)
c0105768:	89 fa                	mov    %edi,%edx
c010576a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010576d:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105770:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105773:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105774:	83 c4 24             	add    $0x24,%esp
c0105777:	5f                   	pop    %edi
c0105778:	5d                   	pop    %ebp
c0105779:	c3                   	ret    

c010577a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010577a:	55                   	push   %ebp
c010577b:	89 e5                	mov    %esp,%ebp
c010577d:	57                   	push   %edi
c010577e:	56                   	push   %esi
c010577f:	53                   	push   %ebx
c0105780:	83 ec 30             	sub    $0x30,%esp
c0105783:	8b 45 08             	mov    0x8(%ebp),%eax
c0105786:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010578f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105792:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105795:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105798:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010579b:	73 42                	jae    c01057df <memmove+0x65>
c010579d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01057a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01057a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01057af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057b2:	c1 e8 02             	shr    $0x2,%eax
c01057b5:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01057b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057bd:	89 d7                	mov    %edx,%edi
c01057bf:	89 c6                	mov    %eax,%esi
c01057c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01057c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01057c6:	83 e1 03             	and    $0x3,%ecx
c01057c9:	74 02                	je     c01057cd <memmove+0x53>
c01057cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057cd:	89 f0                	mov    %esi,%eax
c01057cf:	89 fa                	mov    %edi,%edx
c01057d1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01057d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01057d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01057da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01057dd:	eb 36                	jmp    c0105815 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01057df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057e8:	01 c2                	add    %eax,%edx
c01057ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057ed:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01057f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01057f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057f9:	89 c1                	mov    %eax,%ecx
c01057fb:	89 d8                	mov    %ebx,%eax
c01057fd:	89 d6                	mov    %edx,%esi
c01057ff:	89 c7                	mov    %eax,%edi
c0105801:	fd                   	std    
c0105802:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105804:	fc                   	cld    
c0105805:	89 f8                	mov    %edi,%eax
c0105807:	89 f2                	mov    %esi,%edx
c0105809:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010580c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010580f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105812:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105815:	83 c4 30             	add    $0x30,%esp
c0105818:	5b                   	pop    %ebx
c0105819:	5e                   	pop    %esi
c010581a:	5f                   	pop    %edi
c010581b:	5d                   	pop    %ebp
c010581c:	c3                   	ret    

c010581d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010581d:	55                   	push   %ebp
c010581e:	89 e5                	mov    %esp,%ebp
c0105820:	57                   	push   %edi
c0105821:	56                   	push   %esi
c0105822:	83 ec 20             	sub    $0x20,%esp
c0105825:	8b 45 08             	mov    0x8(%ebp),%eax
c0105828:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010582b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105831:	8b 45 10             	mov    0x10(%ebp),%eax
c0105834:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105837:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010583a:	c1 e8 02             	shr    $0x2,%eax
c010583d:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010583f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105842:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105845:	89 d7                	mov    %edx,%edi
c0105847:	89 c6                	mov    %eax,%esi
c0105849:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010584b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010584e:	83 e1 03             	and    $0x3,%ecx
c0105851:	74 02                	je     c0105855 <memcpy+0x38>
c0105853:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105855:	89 f0                	mov    %esi,%eax
c0105857:	89 fa                	mov    %edi,%edx
c0105859:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010585c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010585f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105865:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105866:	83 c4 20             	add    $0x20,%esp
c0105869:	5e                   	pop    %esi
c010586a:	5f                   	pop    %edi
c010586b:	5d                   	pop    %ebp
c010586c:	c3                   	ret    

c010586d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010586d:	55                   	push   %ebp
c010586e:	89 e5                	mov    %esp,%ebp
c0105870:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105873:	8b 45 08             	mov    0x8(%ebp),%eax
c0105876:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105879:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010587f:	eb 2e                	jmp    c01058af <memcmp+0x42>
        if (*s1 != *s2) {
c0105881:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105884:	0f b6 10             	movzbl (%eax),%edx
c0105887:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010588a:	0f b6 00             	movzbl (%eax),%eax
c010588d:	38 c2                	cmp    %al,%dl
c010588f:	74 18                	je     c01058a9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105891:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105894:	0f b6 00             	movzbl (%eax),%eax
c0105897:	0f b6 d0             	movzbl %al,%edx
c010589a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010589d:	0f b6 00             	movzbl (%eax),%eax
c01058a0:	0f b6 c0             	movzbl %al,%eax
c01058a3:	29 c2                	sub    %eax,%edx
c01058a5:	89 d0                	mov    %edx,%eax
c01058a7:	eb 18                	jmp    c01058c1 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01058a9:	ff 45 fc             	incl   -0x4(%ebp)
c01058ac:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01058af:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058b5:	89 55 10             	mov    %edx,0x10(%ebp)
c01058b8:	85 c0                	test   %eax,%eax
c01058ba:	75 c5                	jne    c0105881 <memcmp+0x14>
    }
    return 0;
c01058bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01058c1:	c9                   	leave  
c01058c2:	c3                   	ret    

c01058c3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01058c3:	55                   	push   %ebp
c01058c4:	89 e5                	mov    %esp,%ebp
c01058c6:	83 ec 58             	sub    $0x58,%esp
c01058c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01058cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01058cf:	8b 45 14             	mov    0x14(%ebp),%eax
c01058d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01058d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058db:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058de:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01058e1:	8b 45 18             	mov    0x18(%ebp),%eax
c01058e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01058ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01058f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058fd:	74 1c                	je     c010591b <printnum+0x58>
c01058ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105902:	ba 00 00 00 00       	mov    $0x0,%edx
c0105907:	f7 75 e4             	divl   -0x1c(%ebp)
c010590a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105910:	ba 00 00 00 00       	mov    $0x0,%edx
c0105915:	f7 75 e4             	divl   -0x1c(%ebp)
c0105918:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010591b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010591e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105921:	f7 75 e4             	divl   -0x1c(%ebp)
c0105924:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105927:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010592a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010592d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105930:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105933:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105936:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105939:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010593c:	8b 45 18             	mov    0x18(%ebp),%eax
c010593f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105944:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105947:	72 56                	jb     c010599f <printnum+0xdc>
c0105949:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010594c:	77 05                	ja     c0105953 <printnum+0x90>
c010594e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105951:	72 4c                	jb     c010599f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105953:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105956:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105959:	8b 45 20             	mov    0x20(%ebp),%eax
c010595c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105960:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105964:	8b 45 18             	mov    0x18(%ebp),%eax
c0105967:	89 44 24 10          	mov    %eax,0x10(%esp)
c010596b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010596e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105971:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105975:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105979:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105980:	8b 45 08             	mov    0x8(%ebp),%eax
c0105983:	89 04 24             	mov    %eax,(%esp)
c0105986:	e8 38 ff ff ff       	call   c01058c3 <printnum>
c010598b:	eb 1b                	jmp    c01059a8 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010598d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105990:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105994:	8b 45 20             	mov    0x20(%ebp),%eax
c0105997:	89 04 24             	mov    %eax,(%esp)
c010599a:	8b 45 08             	mov    0x8(%ebp),%eax
c010599d:	ff d0                	call   *%eax
        while (-- width > 0)
c010599f:	ff 4d 1c             	decl   0x1c(%ebp)
c01059a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01059a6:	7f e5                	jg     c010598d <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01059a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059ab:	05 fc 70 10 c0       	add    $0xc01070fc,%eax
c01059b0:	0f b6 00             	movzbl (%eax),%eax
c01059b3:	0f be c0             	movsbl %al,%eax
c01059b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059bd:	89 04 24             	mov    %eax,(%esp)
c01059c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c3:	ff d0                	call   *%eax
}
c01059c5:	90                   	nop
c01059c6:	c9                   	leave  
c01059c7:	c3                   	ret    

c01059c8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01059c8:	55                   	push   %ebp
c01059c9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01059cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01059cf:	7e 14                	jle    c01059e5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d4:	8b 00                	mov    (%eax),%eax
c01059d6:	8d 48 08             	lea    0x8(%eax),%ecx
c01059d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01059dc:	89 0a                	mov    %ecx,(%edx)
c01059de:	8b 50 04             	mov    0x4(%eax),%edx
c01059e1:	8b 00                	mov    (%eax),%eax
c01059e3:	eb 30                	jmp    c0105a15 <getuint+0x4d>
    }
    else if (lflag) {
c01059e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059e9:	74 16                	je     c0105a01 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01059eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ee:	8b 00                	mov    (%eax),%eax
c01059f0:	8d 48 04             	lea    0x4(%eax),%ecx
c01059f3:	8b 55 08             	mov    0x8(%ebp),%edx
c01059f6:	89 0a                	mov    %ecx,(%edx)
c01059f8:	8b 00                	mov    (%eax),%eax
c01059fa:	ba 00 00 00 00       	mov    $0x0,%edx
c01059ff:	eb 14                	jmp    c0105a15 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a04:	8b 00                	mov    (%eax),%eax
c0105a06:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a09:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a0c:	89 0a                	mov    %ecx,(%edx)
c0105a0e:	8b 00                	mov    (%eax),%eax
c0105a10:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105a15:	5d                   	pop    %ebp
c0105a16:	c3                   	ret    

c0105a17 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105a17:	55                   	push   %ebp
c0105a18:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105a1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105a1e:	7e 14                	jle    c0105a34 <getint+0x1d>
        return va_arg(*ap, long long);
c0105a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a23:	8b 00                	mov    (%eax),%eax
c0105a25:	8d 48 08             	lea    0x8(%eax),%ecx
c0105a28:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a2b:	89 0a                	mov    %ecx,(%edx)
c0105a2d:	8b 50 04             	mov    0x4(%eax),%edx
c0105a30:	8b 00                	mov    (%eax),%eax
c0105a32:	eb 28                	jmp    c0105a5c <getint+0x45>
    }
    else if (lflag) {
c0105a34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a38:	74 12                	je     c0105a4c <getint+0x35>
        return va_arg(*ap, long);
c0105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3d:	8b 00                	mov    (%eax),%eax
c0105a3f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a42:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a45:	89 0a                	mov    %ecx,(%edx)
c0105a47:	8b 00                	mov    (%eax),%eax
c0105a49:	99                   	cltd   
c0105a4a:	eb 10                	jmp    c0105a5c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4f:	8b 00                	mov    (%eax),%eax
c0105a51:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a54:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a57:	89 0a                	mov    %ecx,(%edx)
c0105a59:	8b 00                	mov    (%eax),%eax
c0105a5b:	99                   	cltd   
    }
}
c0105a5c:	5d                   	pop    %ebp
c0105a5d:	c3                   	ret    

c0105a5e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105a5e:	55                   	push   %ebp
c0105a5f:	89 e5                	mov    %esp,%ebp
c0105a61:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105a64:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a71:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a74:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a82:	89 04 24             	mov    %eax,(%esp)
c0105a85:	e8 03 00 00 00       	call   c0105a8d <vprintfmt>
    va_end(ap);
}
c0105a8a:	90                   	nop
c0105a8b:	c9                   	leave  
c0105a8c:	c3                   	ret    

c0105a8d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105a8d:	55                   	push   %ebp
c0105a8e:	89 e5                	mov    %esp,%ebp
c0105a90:	56                   	push   %esi
c0105a91:	53                   	push   %ebx
c0105a92:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a95:	eb 17                	jmp    c0105aae <vprintfmt+0x21>
            if (ch == '\0') {
c0105a97:	85 db                	test   %ebx,%ebx
c0105a99:	0f 84 bf 03 00 00    	je     c0105e5e <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa6:	89 1c 24             	mov    %ebx,(%esp)
c0105aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aac:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105aae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ab1:	8d 50 01             	lea    0x1(%eax),%edx
c0105ab4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ab7:	0f b6 00             	movzbl (%eax),%eax
c0105aba:	0f b6 d8             	movzbl %al,%ebx
c0105abd:	83 fb 25             	cmp    $0x25,%ebx
c0105ac0:	75 d5                	jne    c0105a97 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105ac2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105ac6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105ad3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105ada:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105add:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105ae0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ae3:	8d 50 01             	lea    0x1(%eax),%edx
c0105ae6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ae9:	0f b6 00             	movzbl (%eax),%eax
c0105aec:	0f b6 d8             	movzbl %al,%ebx
c0105aef:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105af2:	83 f8 55             	cmp    $0x55,%eax
c0105af5:	0f 87 37 03 00 00    	ja     c0105e32 <vprintfmt+0x3a5>
c0105afb:	8b 04 85 20 71 10 c0 	mov    -0x3fef8ee0(,%eax,4),%eax
c0105b02:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105b04:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105b08:	eb d6                	jmp    c0105ae0 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105b0a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105b0e:	eb d0                	jmp    c0105ae0 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105b10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105b17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b1a:	89 d0                	mov    %edx,%eax
c0105b1c:	c1 e0 02             	shl    $0x2,%eax
c0105b1f:	01 d0                	add    %edx,%eax
c0105b21:	01 c0                	add    %eax,%eax
c0105b23:	01 d8                	add    %ebx,%eax
c0105b25:	83 e8 30             	sub    $0x30,%eax
c0105b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105b2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b2e:	0f b6 00             	movzbl (%eax),%eax
c0105b31:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105b34:	83 fb 2f             	cmp    $0x2f,%ebx
c0105b37:	7e 38                	jle    c0105b71 <vprintfmt+0xe4>
c0105b39:	83 fb 39             	cmp    $0x39,%ebx
c0105b3c:	7f 33                	jg     c0105b71 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105b3e:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105b41:	eb d4                	jmp    c0105b17 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105b43:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b46:	8d 50 04             	lea    0x4(%eax),%edx
c0105b49:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b4c:	8b 00                	mov    (%eax),%eax
c0105b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105b51:	eb 1f                	jmp    c0105b72 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105b53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b57:	79 87                	jns    c0105ae0 <vprintfmt+0x53>
                width = 0;
c0105b59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105b60:	e9 7b ff ff ff       	jmp    c0105ae0 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105b65:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105b6c:	e9 6f ff ff ff       	jmp    c0105ae0 <vprintfmt+0x53>
            goto process_precision;
c0105b71:	90                   	nop

        process_precision:
            if (width < 0)
c0105b72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b76:	0f 89 64 ff ff ff    	jns    c0105ae0 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105b89:	e9 52 ff ff ff       	jmp    c0105ae0 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105b8e:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105b91:	e9 4a ff ff ff       	jmp    c0105ae0 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105b96:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b99:	8d 50 04             	lea    0x4(%eax),%edx
c0105b9c:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b9f:	8b 00                	mov    (%eax),%eax
c0105ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ba4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ba8:	89 04 24             	mov    %eax,(%esp)
c0105bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bae:	ff d0                	call   *%eax
            break;
c0105bb0:	e9 a4 02 00 00       	jmp    c0105e59 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105bb5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bb8:	8d 50 04             	lea    0x4(%eax),%edx
c0105bbb:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bbe:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105bc0:	85 db                	test   %ebx,%ebx
c0105bc2:	79 02                	jns    c0105bc6 <vprintfmt+0x139>
                err = -err;
c0105bc4:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105bc6:	83 fb 06             	cmp    $0x6,%ebx
c0105bc9:	7f 0b                	jg     c0105bd6 <vprintfmt+0x149>
c0105bcb:	8b 34 9d e0 70 10 c0 	mov    -0x3fef8f20(,%ebx,4),%esi
c0105bd2:	85 f6                	test   %esi,%esi
c0105bd4:	75 23                	jne    c0105bf9 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105bd6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105bda:	c7 44 24 08 0d 71 10 	movl   $0xc010710d,0x8(%esp)
c0105be1:	c0 
c0105be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bec:	89 04 24             	mov    %eax,(%esp)
c0105bef:	e8 6a fe ff ff       	call   c0105a5e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105bf4:	e9 60 02 00 00       	jmp    c0105e59 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105bf9:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105bfd:	c7 44 24 08 16 71 10 	movl   $0xc0107116,0x8(%esp)
c0105c04:	c0 
c0105c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0f:	89 04 24             	mov    %eax,(%esp)
c0105c12:	e8 47 fe ff ff       	call   c0105a5e <printfmt>
            break;
c0105c17:	e9 3d 02 00 00       	jmp    c0105e59 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105c1c:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c1f:	8d 50 04             	lea    0x4(%eax),%edx
c0105c22:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c25:	8b 30                	mov    (%eax),%esi
c0105c27:	85 f6                	test   %esi,%esi
c0105c29:	75 05                	jne    c0105c30 <vprintfmt+0x1a3>
                p = "(null)";
c0105c2b:	be 19 71 10 c0       	mov    $0xc0107119,%esi
            }
            if (width > 0 && padc != '-') {
c0105c30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c34:	7e 76                	jle    c0105cac <vprintfmt+0x21f>
c0105c36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105c3a:	74 70                	je     c0105cac <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c43:	89 34 24             	mov    %esi,(%esp)
c0105c46:	e8 f6 f7 ff ff       	call   c0105441 <strnlen>
c0105c4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c4e:	29 c2                	sub    %eax,%edx
c0105c50:	89 d0                	mov    %edx,%eax
c0105c52:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c55:	eb 16                	jmp    c0105c6d <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105c57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c5e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c62:	89 04 24             	mov    %eax,(%esp)
c0105c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c68:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c6a:	ff 4d e8             	decl   -0x18(%ebp)
c0105c6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c71:	7f e4                	jg     c0105c57 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105c73:	eb 37                	jmp    c0105cac <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105c75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105c79:	74 1f                	je     c0105c9a <vprintfmt+0x20d>
c0105c7b:	83 fb 1f             	cmp    $0x1f,%ebx
c0105c7e:	7e 05                	jle    c0105c85 <vprintfmt+0x1f8>
c0105c80:	83 fb 7e             	cmp    $0x7e,%ebx
c0105c83:	7e 15                	jle    c0105c9a <vprintfmt+0x20d>
                    putch('?', putdat);
c0105c85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c96:	ff d0                	call   *%eax
c0105c98:	eb 0f                	jmp    c0105ca9 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ca1:	89 1c 24             	mov    %ebx,(%esp)
c0105ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca7:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ca9:	ff 4d e8             	decl   -0x18(%ebp)
c0105cac:	89 f0                	mov    %esi,%eax
c0105cae:	8d 70 01             	lea    0x1(%eax),%esi
c0105cb1:	0f b6 00             	movzbl (%eax),%eax
c0105cb4:	0f be d8             	movsbl %al,%ebx
c0105cb7:	85 db                	test   %ebx,%ebx
c0105cb9:	74 27                	je     c0105ce2 <vprintfmt+0x255>
c0105cbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cbf:	78 b4                	js     c0105c75 <vprintfmt+0x1e8>
c0105cc1:	ff 4d e4             	decl   -0x1c(%ebp)
c0105cc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cc8:	79 ab                	jns    c0105c75 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105cca:	eb 16                	jmp    c0105ce2 <vprintfmt+0x255>
                putch(' ', putdat);
c0105ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cd3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdd:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105cdf:	ff 4d e8             	decl   -0x18(%ebp)
c0105ce2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ce6:	7f e4                	jg     c0105ccc <vprintfmt+0x23f>
            }
            break;
c0105ce8:	e9 6c 01 00 00       	jmp    c0105e59 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cf4:	8d 45 14             	lea    0x14(%ebp),%eax
c0105cf7:	89 04 24             	mov    %eax,(%esp)
c0105cfa:	e8 18 fd ff ff       	call   c0105a17 <getint>
c0105cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d0b:	85 d2                	test   %edx,%edx
c0105d0d:	79 26                	jns    c0105d35 <vprintfmt+0x2a8>
                putch('-', putdat);
c0105d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d16:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d20:	ff d0                	call   *%eax
                num = -(long long)num;
c0105d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d28:	f7 d8                	neg    %eax
c0105d2a:	83 d2 00             	adc    $0x0,%edx
c0105d2d:	f7 da                	neg    %edx
c0105d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d32:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105d35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d3c:	e9 a8 00 00 00       	jmp    c0105de9 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d48:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d4b:	89 04 24             	mov    %eax,(%esp)
c0105d4e:	e8 75 fc ff ff       	call   c01059c8 <getuint>
c0105d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d56:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105d59:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d60:	e9 84 00 00 00       	jmp    c0105de9 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d6c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d6f:	89 04 24             	mov    %eax,(%esp)
c0105d72:	e8 51 fc ff ff       	call   c01059c8 <getuint>
c0105d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105d7d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105d84:	eb 63                	jmp    c0105de9 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d8d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d97:	ff d0                	call   *%eax
            putch('x', putdat);
c0105d99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105da0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105da7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105daa:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105dac:	8b 45 14             	mov    0x14(%ebp),%eax
c0105daf:	8d 50 04             	lea    0x4(%eax),%edx
c0105db2:	89 55 14             	mov    %edx,0x14(%ebp)
c0105db5:	8b 00                	mov    (%eax),%eax
c0105db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105dc1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105dc8:	eb 1f                	jmp    c0105de9 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105dca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dd1:	8d 45 14             	lea    0x14(%ebp),%eax
c0105dd4:	89 04 24             	mov    %eax,(%esp)
c0105dd7:	e8 ec fb ff ff       	call   c01059c8 <getuint>
c0105ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ddf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105de2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105de9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105df0:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105df4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105df7:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105dfb:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e09:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e17:	89 04 24             	mov    %eax,(%esp)
c0105e1a:	e8 a4 fa ff ff       	call   c01058c3 <printnum>
            break;
c0105e1f:	eb 38                	jmp    c0105e59 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105e21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e28:	89 1c 24             	mov    %ebx,(%esp)
c0105e2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2e:	ff d0                	call   *%eax
            break;
c0105e30:	eb 27                	jmp    c0105e59 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e39:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e43:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105e45:	ff 4d 10             	decl   0x10(%ebp)
c0105e48:	eb 03                	jmp    c0105e4d <vprintfmt+0x3c0>
c0105e4a:	ff 4d 10             	decl   0x10(%ebp)
c0105e4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e50:	48                   	dec    %eax
c0105e51:	0f b6 00             	movzbl (%eax),%eax
c0105e54:	3c 25                	cmp    $0x25,%al
c0105e56:	75 f2                	jne    c0105e4a <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105e58:	90                   	nop
    while (1) {
c0105e59:	e9 37 fc ff ff       	jmp    c0105a95 <vprintfmt+0x8>
                return;
c0105e5e:	90                   	nop
        }
    }
}
c0105e5f:	83 c4 40             	add    $0x40,%esp
c0105e62:	5b                   	pop    %ebx
c0105e63:	5e                   	pop    %esi
c0105e64:	5d                   	pop    %ebp
c0105e65:	c3                   	ret    

c0105e66 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105e66:	55                   	push   %ebp
c0105e67:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105e69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e6c:	8b 40 08             	mov    0x8(%eax),%eax
c0105e6f:	8d 50 01             	lea    0x1(%eax),%edx
c0105e72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e75:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105e78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7b:	8b 10                	mov    (%eax),%edx
c0105e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e80:	8b 40 04             	mov    0x4(%eax),%eax
c0105e83:	39 c2                	cmp    %eax,%edx
c0105e85:	73 12                	jae    c0105e99 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105e87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e8a:	8b 00                	mov    (%eax),%eax
c0105e8c:	8d 48 01             	lea    0x1(%eax),%ecx
c0105e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e92:	89 0a                	mov    %ecx,(%edx)
c0105e94:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e97:	88 10                	mov    %dl,(%eax)
    }
}
c0105e99:	90                   	nop
c0105e9a:	5d                   	pop    %ebp
c0105e9b:	c3                   	ret    

c0105e9c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105e9c:	55                   	push   %ebp
c0105e9d:	89 e5                	mov    %esp,%ebp
c0105e9f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105ea2:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105eaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eb2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec0:	89 04 24             	mov    %eax,(%esp)
c0105ec3:	e8 08 00 00 00       	call   c0105ed0 <vsnprintf>
c0105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ece:	c9                   	leave  
c0105ecf:	c3                   	ret    

c0105ed0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ed0:	55                   	push   %ebp
c0105ed1:	89 e5                	mov    %esp,%ebp
c0105ed3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105edc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105edf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ee2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee5:	01 d0                	add    %edx,%eax
c0105ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ef5:	74 0a                	je     c0105f01 <vsnprintf+0x31>
c0105ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105efd:	39 c2                	cmp    %eax,%edx
c0105eff:	76 07                	jbe    c0105f08 <vsnprintf+0x38>
        return -E_INVAL;
c0105f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105f06:	eb 2a                	jmp    c0105f32 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105f08:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f12:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f16:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105f19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f1d:	c7 04 24 66 5e 10 c0 	movl   $0xc0105e66,(%esp)
c0105f24:	e8 64 fb ff ff       	call   c0105a8d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f2c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f32:	c9                   	leave  
c0105f33:	c3                   	ret    
