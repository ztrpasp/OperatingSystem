
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 b4 2d 00 00       	call   102dd8 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 42 15 00 00       	call   10156e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 80 35 10 00 	movl   $0x103580,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 9c 35 10 00       	push   $0x10359c
  10003e:	e8 0a 02 00 00       	call   10024d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 a1 08 00 00       	call   1008ec <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 47 2a 00 00       	call   102a9c <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 57 16 00 00       	call   1016b1 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 d9 17 00 00       	call   101838 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 eb 0c 00 00       	call   100d4f <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 85 17 00 00       	call   1017ee <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 50 01 00 00       	call   1001be <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 b9 0c 00 00       	call   100d3d <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 a1 35 10 00       	push   $0x1035a1
  100117:	e8 31 01 00 00       	call   10024d <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 af 35 10 00       	push   $0x1035af
  100135:	e8 13 01 00 00       	call   10024d <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 bd 35 10 00       	push   $0x1035bd
  100153:	e8 f5 00 00 00       	call   10024d <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 cb 35 10 00       	push   $0x1035cb
  100171:	e8 d7 00 00 00       	call   10024d <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 d9 35 10 00       	push   $0x1035d9
  10018f:	e8 b9 00 00 00       	call   10024d <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001aa:	83 ec 08             	sub    $0x8,%esp
  1001ad:	cd 78                	int    $0x78
  1001af:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001b1:	90                   	nop
  1001b2:	5d                   	pop    %ebp
  1001b3:	c3                   	ret    

001001b4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b4:	55                   	push   %ebp
  1001b5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001b7:	cd 79                	int    $0x79
  1001b9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001bb:	90                   	nop
  1001bc:	5d                   	pop    %ebp
  1001bd:	c3                   	ret    

001001be <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001be:	55                   	push   %ebp
  1001bf:	89 e5                	mov    %esp,%ebp
  1001c1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c4:	e8 21 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c9:	83 ec 0c             	sub    $0xc,%esp
  1001cc:	68 e8 35 10 00       	push   $0x1035e8
  1001d1:	e8 77 00 00 00       	call   10024d <cprintf>
  1001d6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d9:	e8 c9 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001de:	e8 07 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 08 36 10 00       	push   $0x103608
  1001eb:	e8 5d 00 00 00       	call   10024d <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f3:	e8 bc ff ff ff       	call   1001b4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f8:	e8 ed fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fd:	90                   	nop
  1001fe:	c9                   	leave  
  1001ff:	c3                   	ret    

00100200 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100206:	83 ec 0c             	sub    $0xc,%esp
  100209:	ff 75 08             	pushl  0x8(%ebp)
  10020c:	e8 8e 13 00 00       	call   10159f <cons_putc>
  100211:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	8b 00                	mov    (%eax),%eax
  100219:	8d 50 01             	lea    0x1(%eax),%edx
  10021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021f:	89 10                	mov    %edx,(%eax)
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10022a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100231:	ff 75 0c             	pushl  0xc(%ebp)
  100234:	ff 75 08             	pushl  0x8(%ebp)
  100237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10023a:	50                   	push   %eax
  10023b:	68 00 02 10 00       	push   $0x100200
  100240:	e8 c9 2e 00 00       	call   10310e <vprintfmt>
  100245:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100248:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100253:	8d 45 0c             	lea    0xc(%ebp),%eax
  100256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	83 ec 08             	sub    $0x8,%esp
  10025f:	50                   	push   %eax
  100260:	ff 75 08             	pushl  0x8(%ebp)
  100263:	e8 bc ff ff ff       	call   100224 <vcprintf>
  100268:	83 c4 10             	add    $0x10,%esp
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100271:	c9                   	leave  
  100272:	c3                   	ret    

00100273 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100273:	55                   	push   %ebp
  100274:	89 e5                	mov    %esp,%ebp
  100276:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100279:	83 ec 0c             	sub    $0xc,%esp
  10027c:	ff 75 08             	pushl  0x8(%ebp)
  10027f:	e8 1b 13 00 00       	call   10159f <cons_putc>
  100284:	83 c4 10             	add    $0x10,%esp
}
  100287:	90                   	nop
  100288:	c9                   	leave  
  100289:	c3                   	ret    

0010028a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10028a:	55                   	push   %ebp
  10028b:	89 e5                	mov    %esp,%ebp
  10028d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100290:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100297:	eb 14                	jmp    1002ad <cputs+0x23>
        cputch(c, &cnt);
  100299:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029d:	83 ec 08             	sub    $0x8,%esp
  1002a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	e8 56 ff ff ff       	call   100200 <cputch>
  1002aa:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	8d 50 01             	lea    0x1(%eax),%edx
  1002b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b6:	0f b6 00             	movzbl (%eax),%eax
  1002b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002c0:	75 d7                	jne    100299 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002c2:	83 ec 08             	sub    $0x8,%esp
  1002c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c8:	50                   	push   %eax
  1002c9:	6a 0a                	push   $0xa
  1002cb:	e8 30 ff ff ff       	call   100200 <cputch>
  1002d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002de:	e8 ec 12 00 00       	call   1015cf <cons_getc>
  1002e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ea:	74 f2                	je     1002de <getchar+0x6>
        /* do nothing */;
    return c;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002fb:	74 13                	je     100310 <readline+0x1f>
        cprintf("%s", prompt);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	ff 75 08             	pushl  0x8(%ebp)
  100303:	68 27 36 10 00       	push   $0x103627
  100308:	e8 40 ff ff ff       	call   10024d <cprintf>
  10030d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100317:	e8 bc ff ff ff       	call   1002d8 <getchar>
  10031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100323:	79 0a                	jns    10032f <readline+0x3e>
            return NULL;
  100325:	b8 00 00 00 00       	mov    $0x0,%eax
  10032a:	e9 82 00 00 00       	jmp    1003b1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100333:	7e 2b                	jle    100360 <readline+0x6f>
  100335:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033c:	7f 22                	jg     100360 <readline+0x6f>
            cputchar(c);
  10033e:	83 ec 0c             	sub    $0xc,%esp
  100341:	ff 75 f0             	pushl  -0x10(%ebp)
  100344:	e8 2a ff ff ff       	call   100273 <cputchar>
  100349:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10034c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034f:	8d 50 01             	lea    0x1(%eax),%edx
  100352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100358:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035e:	eb 4c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100360:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100364:	75 1a                	jne    100380 <readline+0x8f>
  100366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10036a:	7e 14                	jle    100380 <readline+0x8f>
            cputchar(c);
  10036c:	83 ec 0c             	sub    $0xc,%esp
  10036f:	ff 75 f0             	pushl  -0x10(%ebp)
  100372:	e8 fc fe ff ff       	call   100273 <cputchar>
  100377:	83 c4 10             	add    $0x10,%esp
            i --;
  10037a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037e:	eb 2c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100380:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100384:	74 06                	je     10038c <readline+0x9b>
  100386:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038a:	75 8b                	jne    100317 <readline+0x26>
            cputchar(c);
  10038c:	83 ec 0c             	sub    $0xc,%esp
  10038f:	ff 75 f0             	pushl  -0x10(%ebp)
  100392:	e8 dc fe ff ff       	call   100273 <cputchar>
  100397:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xc0>
        c = getchar();
  1003ac:	e9 66 ff ff ff       	jmp    100317 <readline+0x26>
        }
    }
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 5f                	jne    100421 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	83 ec 04             	sub    $0x4,%esp
  1003d5:	ff 75 0c             	pushl  0xc(%ebp)
  1003d8:	ff 75 08             	pushl  0x8(%ebp)
  1003db:	68 2a 36 10 00       	push   $0x10362a
  1003e0:	e8 68 fe ff ff       	call   10024d <cprintf>
  1003e5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003eb:	83 ec 08             	sub    $0x8,%esp
  1003ee:	50                   	push   %eax
  1003ef:	ff 75 10             	pushl  0x10(%ebp)
  1003f2:	e8 2d fe ff ff       	call   100224 <vcprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003fa:	83 ec 0c             	sub    $0xc,%esp
  1003fd:	68 46 36 10 00       	push   $0x103646
  100402:	e8 46 fe ff ff       	call   10024d <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  10040a:	83 ec 0c             	sub    $0xc,%esp
  10040d:	68 48 36 10 00       	push   $0x103648
  100412:	e8 36 fe ff ff       	call   10024d <cprintf>
  100417:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  10041a:	e8 17 06 00 00       	call   100a36 <print_stackframe>
  10041f:	eb 01                	jmp    100422 <__panic+0x6f>
        goto panic_dead;
  100421:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100422:	e8 ce 13 00 00       	call   1017f5 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100427:	83 ec 0c             	sub    $0xc,%esp
  10042a:	6a 00                	push   $0x0
  10042c:	e8 32 08 00 00       	call   100c63 <kmonitor>
  100431:	83 c4 10             	add    $0x10,%esp
  100434:	eb f1                	jmp    100427 <__panic+0x74>

00100436 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100436:	55                   	push   %ebp
  100437:	89 e5                	mov    %esp,%ebp
  100439:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  10043c:	8d 45 14             	lea    0x14(%ebp),%eax
  10043f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100442:	83 ec 04             	sub    $0x4,%esp
  100445:	ff 75 0c             	pushl  0xc(%ebp)
  100448:	ff 75 08             	pushl  0x8(%ebp)
  10044b:	68 5a 36 10 00       	push   $0x10365a
  100450:	e8 f8 fd ff ff       	call   10024d <cprintf>
  100455:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10045b:	83 ec 08             	sub    $0x8,%esp
  10045e:	50                   	push   %eax
  10045f:	ff 75 10             	pushl  0x10(%ebp)
  100462:	e8 bd fd ff ff       	call   100224 <vcprintf>
  100467:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10046a:	83 ec 0c             	sub    $0xc,%esp
  10046d:	68 46 36 10 00       	push   $0x103646
  100472:	e8 d6 fd ff ff       	call   10024d <cprintf>
  100477:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10047a:	90                   	nop
  10047b:	c9                   	leave  
  10047c:	c3                   	ret    

0010047d <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10047d:	55                   	push   %ebp
  10047e:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100480:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100485:	5d                   	pop    %ebp
  100486:	c3                   	ret    

00100487 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100487:	55                   	push   %ebp
  100488:	89 e5                	mov    %esp,%ebp
  10048a:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100490:	8b 00                	mov    (%eax),%eax
  100492:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100495:	8b 45 10             	mov    0x10(%ebp),%eax
  100498:	8b 00                	mov    (%eax),%eax
  10049a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10049d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004a4:	e9 d2 00 00 00       	jmp    10057b <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004af:	01 d0                	add    %edx,%eax
  1004b1:	89 c2                	mov    %eax,%edx
  1004b3:	c1 ea 1f             	shr    $0x1f,%edx
  1004b6:	01 d0                	add    %edx,%eax
  1004b8:	d1 f8                	sar    %eax
  1004ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c3:	eb 04                	jmp    1004c9 <stab_binsearch+0x42>
            m --;
  1004c5:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004cf:	7c 1f                	jl     1004f0 <stab_binsearch+0x69>
  1004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d4:	89 d0                	mov    %edx,%eax
  1004d6:	01 c0                	add    %eax,%eax
  1004d8:	01 d0                	add    %edx,%eax
  1004da:	c1 e0 02             	shl    $0x2,%eax
  1004dd:	89 c2                	mov    %eax,%edx
  1004df:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e8:	0f b6 c0             	movzbl %al,%eax
  1004eb:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004ee:	75 d5                	jne    1004c5 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f6:	7d 0b                	jge    100503 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004fb:	83 c0 01             	add    $0x1,%eax
  1004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100501:	eb 78                	jmp    10057b <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100503:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10050a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	8b 40 08             	mov    0x8(%eax),%eax
  100520:	39 45 18             	cmp    %eax,0x18(%ebp)
  100523:	76 13                	jbe    100538 <stab_binsearch+0xb1>
            *region_left = m;
  100525:	8b 45 0c             	mov    0xc(%ebp),%eax
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10052d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100530:	83 c0 01             	add    $0x1,%eax
  100533:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100536:	eb 43                	jmp    10057b <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10053b:	89 d0                	mov    %edx,%eax
  10053d:	01 c0                	add    %eax,%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	c1 e0 02             	shl    $0x2,%eax
  100544:	89 c2                	mov    %eax,%edx
  100546:	8b 45 08             	mov    0x8(%ebp),%eax
  100549:	01 d0                	add    %edx,%eax
  10054b:	8b 40 08             	mov    0x8(%eax),%eax
  10054e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100551:	73 16                	jae    100569 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100556:	8d 50 ff             	lea    -0x1(%eax),%edx
  100559:	8b 45 10             	mov    0x10(%ebp),%eax
  10055c:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100561:	83 e8 01             	sub    $0x1,%eax
  100564:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100567:	eb 12                	jmp    10057b <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10056f:	89 10                	mov    %edx,(%eax)
            l = m;
  100571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100574:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100577:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  10057b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10057e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100581:	0f 8e 22 ff ff ff    	jle    1004a9 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058b:	75 0f                	jne    10059c <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  10058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100590:	8b 00                	mov    (%eax),%eax
  100592:	8d 50 ff             	lea    -0x1(%eax),%edx
  100595:	8b 45 10             	mov    0x10(%ebp),%eax
  100598:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059a:	eb 3f                	jmp    1005db <stab_binsearch+0x154>
        l = *region_right;
  10059c:	8b 45 10             	mov    0x10(%ebp),%eax
  10059f:	8b 00                	mov    (%eax),%eax
  1005a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a4:	eb 04                	jmp    1005aa <stab_binsearch+0x123>
  1005a6:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ad:	8b 00                	mov    (%eax),%eax
  1005af:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b2:	7e 1f                	jle    1005d3 <stab_binsearch+0x14c>
  1005b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b7:	89 d0                	mov    %edx,%eax
  1005b9:	01 c0                	add    %eax,%eax
  1005bb:	01 d0                	add    %edx,%eax
  1005bd:	c1 e0 02             	shl    $0x2,%eax
  1005c0:	89 c2                	mov    %eax,%edx
  1005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c5:	01 d0                	add    %edx,%eax
  1005c7:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cb:	0f b6 c0             	movzbl %al,%eax
  1005ce:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005d1:	75 d3                	jne    1005a6 <stab_binsearch+0x11f>
        *region_left = l;
  1005d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d9:	89 10                	mov    %edx,(%eax)
}
  1005db:	90                   	nop
  1005dc:	c9                   	leave  
  1005dd:	c3                   	ret    

001005de <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005de:	55                   	push   %ebp
  1005df:	89 e5                	mov    %esp,%ebp
  1005e1:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e7:	c7 00 78 36 10 00    	movl   $0x103678,(%eax)
    info->eip_line = 0;
  1005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fa:	c7 40 08 78 36 10 00 	movl   $0x103678,0x8(%eax)
    info->eip_fn_namelen = 9;
  100601:	8b 45 0c             	mov    0xc(%ebp),%eax
  100604:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	8b 55 08             	mov    0x8(%ebp),%edx
  100611:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100614:	8b 45 0c             	mov    0xc(%ebp),%eax
  100617:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10061e:	c7 45 f4 ac 3e 10 00 	movl   $0x103eac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100625:	c7 45 f0 70 bc 10 00 	movl   $0x10bc70,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062c:	c7 45 ec 71 bc 10 00 	movl   $0x10bc71,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100633:	c7 45 e8 64 dd 10 00 	movl   $0x10dd64,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100640:	76 0d                	jbe    10064f <debuginfo_eip+0x71>
  100642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100645:	83 e8 01             	sub    $0x1,%eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x7b>
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 91 02 00 00       	jmp    1008ea <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	83 e8 01             	sub    $0x1,%eax
  100676:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100679:	ff 75 08             	pushl  0x8(%ebp)
  10067c:	6a 64                	push   $0x64
  10067e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100681:	50                   	push   %eax
  100682:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100685:	50                   	push   %eax
  100686:	ff 75 f4             	pushl  -0xc(%ebp)
  100689:	e8 f9 fd ff ff       	call   100487 <stab_binsearch>
  10068e:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100694:	85 c0                	test   %eax,%eax
  100696:	75 0a                	jne    1006a2 <debuginfo_eip+0xc4>
        return -1;
  100698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10069d:	e9 48 02 00 00       	jmp    1008ea <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006ae:	ff 75 08             	pushl  0x8(%ebp)
  1006b1:	6a 24                	push   $0x24
  1006b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006b6:	50                   	push   %eax
  1006b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ba:	50                   	push   %eax
  1006bb:	ff 75 f4             	pushl  -0xc(%ebp)
  1006be:	e8 c4 fd ff ff       	call   100487 <stab_binsearch>
  1006c3:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006cc:	39 c2                	cmp    %eax,%edx
  1006ce:	7f 7c                	jg     10074c <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	89 d0                	mov    %edx,%eax
  1006d7:	01 c0                	add    %eax,%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	c1 e0 02             	shl    $0x2,%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	8b 00                	mov    (%eax),%eax
  1006e7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006ed:	29 d1                	sub    %edx,%ecx
  1006ef:	89 ca                	mov    %ecx,%edx
  1006f1:	39 d0                	cmp    %edx,%eax
  1006f3:	73 22                	jae    100717 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	89 d0                	mov    %edx,%eax
  1006fc:	01 c0                	add    %eax,%eax
  1006fe:	01 d0                	add    %edx,%eax
  100700:	c1 e0 02             	shl    $0x2,%eax
  100703:	89 c2                	mov    %eax,%edx
  100705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100708:	01 d0                	add    %edx,%eax
  10070a:	8b 10                	mov    (%eax),%edx
  10070c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10070f:	01 c2                	add    %eax,%edx
  100711:	8b 45 0c             	mov    0xc(%ebp),%eax
  100714:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100717:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	89 d0                	mov    %edx,%eax
  10071e:	01 c0                	add    %eax,%eax
  100720:	01 d0                	add    %edx,%eax
  100722:	c1 e0 02             	shl    $0x2,%eax
  100725:	89 c2                	mov    %eax,%edx
  100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072a:	01 d0                	add    %edx,%eax
  10072c:	8b 50 08             	mov    0x8(%eax),%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100735:	8b 45 0c             	mov    0xc(%ebp),%eax
  100738:	8b 40 10             	mov    0x10(%eax),%eax
  10073b:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10073e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100741:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100744:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100747:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10074a:	eb 15                	jmp    100761 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074f:	8b 55 08             	mov    0x8(%ebp),%edx
  100752:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100758:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10075b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10075e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100761:	8b 45 0c             	mov    0xc(%ebp),%eax
  100764:	8b 40 08             	mov    0x8(%eax),%eax
  100767:	83 ec 08             	sub    $0x8,%esp
  10076a:	6a 3a                	push   $0x3a
  10076c:	50                   	push   %eax
  10076d:	e8 da 24 00 00       	call   102c4c <strfind>
  100772:	83 c4 10             	add    $0x10,%esp
  100775:	89 c2                	mov    %eax,%edx
  100777:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077a:	8b 40 08             	mov    0x8(%eax),%eax
  10077d:	29 c2                	sub    %eax,%edx
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100785:	83 ec 0c             	sub    $0xc,%esp
  100788:	ff 75 08             	pushl  0x8(%ebp)
  10078b:	6a 44                	push   $0x44
  10078d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100790:	50                   	push   %eax
  100791:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100794:	50                   	push   %eax
  100795:	ff 75 f4             	pushl  -0xc(%ebp)
  100798:	e8 ea fc ff ff       	call   100487 <stab_binsearch>
  10079d:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007a6:	39 c2                	cmp    %eax,%edx
  1007a8:	7f 24                	jg     1007ce <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	89 d0                	mov    %edx,%eax
  1007b1:	01 c0                	add    %eax,%eax
  1007b3:	01 d0                	add    %edx,%eax
  1007b5:	c1 e0 02             	shl    $0x2,%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c3:	0f b7 d0             	movzwl %ax,%edx
  1007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c9:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007cc:	eb 13                	jmp    1007e1 <debuginfo_eip+0x203>
        return -1;
  1007ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d3:	e9 12 01 00 00       	jmp    1008ea <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007db:	83 e8 01             	sub    $0x1,%eax
  1007de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e7:	39 c2                	cmp    %eax,%edx
  1007e9:	7c 56                	jl     100841 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ee:	89 c2                	mov    %eax,%edx
  1007f0:	89 d0                	mov    %edx,%eax
  1007f2:	01 c0                	add    %eax,%eax
  1007f4:	01 d0                	add    %edx,%eax
  1007f6:	c1 e0 02             	shl    $0x2,%eax
  1007f9:	89 c2                	mov    %eax,%edx
  1007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fe:	01 d0                	add    %edx,%eax
  100800:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100804:	3c 84                	cmp    $0x84,%al
  100806:	74 39                	je     100841 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100808:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080b:	89 c2                	mov    %eax,%edx
  10080d:	89 d0                	mov    %edx,%eax
  10080f:	01 c0                	add    %eax,%eax
  100811:	01 d0                	add    %edx,%eax
  100813:	c1 e0 02             	shl    $0x2,%eax
  100816:	89 c2                	mov    %eax,%edx
  100818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100821:	3c 64                	cmp    $0x64,%al
  100823:	75 b3                	jne    1007d8 <debuginfo_eip+0x1fa>
  100825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100828:	89 c2                	mov    %eax,%edx
  10082a:	89 d0                	mov    %edx,%eax
  10082c:	01 c0                	add    %eax,%eax
  10082e:	01 d0                	add    %edx,%eax
  100830:	c1 e0 02             	shl    $0x2,%eax
  100833:	89 c2                	mov    %eax,%edx
  100835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100838:	01 d0                	add    %edx,%eax
  10083a:	8b 40 08             	mov    0x8(%eax),%eax
  10083d:	85 c0                	test   %eax,%eax
  10083f:	74 97                	je     1007d8 <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100841:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100847:	39 c2                	cmp    %eax,%edx
  100849:	7c 46                	jl     100891 <debuginfo_eip+0x2b3>
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 00                	mov    (%eax),%eax
  100862:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100865:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100868:	29 d1                	sub    %edx,%ecx
  10086a:	89 ca                	mov    %ecx,%edx
  10086c:	39 d0                	cmp    %edx,%eax
  10086e:	73 21                	jae    100891 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	01 c0                	add    %eax,%eax
  100879:	01 d0                	add    %edx,%eax
  10087b:	c1 e0 02             	shl    $0x2,%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	8b 10                	mov    (%eax),%edx
  100887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088a:	01 c2                	add    %eax,%edx
  10088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100891:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100894:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100897:	39 c2                	cmp    %eax,%edx
  100899:	7d 4a                	jge    1008e5 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  10089b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10089e:	83 c0 01             	add    $0x1,%eax
  1008a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a4:	eb 18                	jmp    1008be <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a9:	8b 40 14             	mov    0x14(%eax),%eax
  1008ac:	8d 50 01             	lea    0x1(%eax),%edx
  1008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b2:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b8:	83 c0 01             	add    $0x1,%eax
  1008bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008c4:	39 c2                	cmp    %eax,%edx
  1008c6:	7d 1d                	jge    1008e5 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cb:	89 c2                	mov    %eax,%edx
  1008cd:	89 d0                	mov    %edx,%eax
  1008cf:	01 c0                	add    %eax,%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	c1 e0 02             	shl    $0x2,%eax
  1008d6:	89 c2                	mov    %eax,%edx
  1008d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008db:	01 d0                	add    %edx,%eax
  1008dd:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e1:	3c a0                	cmp    $0xa0,%al
  1008e3:	74 c1                	je     1008a6 <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ea:	c9                   	leave  
  1008eb:	c3                   	ret    

001008ec <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008ec:	55                   	push   %ebp
  1008ed:	89 e5                	mov    %esp,%ebp
  1008ef:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f2:	83 ec 0c             	sub    $0xc,%esp
  1008f5:	68 82 36 10 00       	push   $0x103682
  1008fa:	e8 4e f9 ff ff       	call   10024d <cprintf>
  1008ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100902:	83 ec 08             	sub    $0x8,%esp
  100905:	68 00 00 10 00       	push   $0x100000
  10090a:	68 9b 36 10 00       	push   $0x10369b
  10090f:	e8 39 f9 ff ff       	call   10024d <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 6f 35 10 00       	push   $0x10356f
  10091f:	68 b3 36 10 00       	push   $0x1036b3
  100924:	e8 24 f9 ff ff       	call   10024d <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 16 ea 10 00       	push   $0x10ea16
  100934:	68 cb 36 10 00       	push   $0x1036cb
  100939:	e8 0f f9 ff ff       	call   10024d <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100941:	83 ec 08             	sub    $0x8,%esp
  100944:	68 80 fd 10 00       	push   $0x10fd80
  100949:	68 e3 36 10 00       	push   $0x1036e3
  10094e:	e8 fa f8 ff ff       	call   10024d <cprintf>
  100953:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100956:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10095b:	05 ff 03 00 00       	add    $0x3ff,%eax
  100960:	ba 00 00 10 00       	mov    $0x100000,%edx
  100965:	29 d0                	sub    %edx,%eax
  100967:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10096d:	85 c0                	test   %eax,%eax
  10096f:	0f 48 c2             	cmovs  %edx,%eax
  100972:	c1 f8 0a             	sar    $0xa,%eax
  100975:	83 ec 08             	sub    $0x8,%esp
  100978:	50                   	push   %eax
  100979:	68 fc 36 10 00       	push   $0x1036fc
  10097e:	e8 ca f8 ff ff       	call   10024d <cprintf>
  100983:	83 c4 10             	add    $0x10,%esp
}
  100986:	90                   	nop
  100987:	c9                   	leave  
  100988:	c3                   	ret    

00100989 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100989:	55                   	push   %ebp
  10098a:	89 e5                	mov    %esp,%ebp
  10098c:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100992:	83 ec 08             	sub    $0x8,%esp
  100995:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100998:	50                   	push   %eax
  100999:	ff 75 08             	pushl  0x8(%ebp)
  10099c:	e8 3d fc ff ff       	call   1005de <debuginfo_eip>
  1009a1:	83 c4 10             	add    $0x10,%esp
  1009a4:	85 c0                	test   %eax,%eax
  1009a6:	74 15                	je     1009bd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009a8:	83 ec 08             	sub    $0x8,%esp
  1009ab:	ff 75 08             	pushl  0x8(%ebp)
  1009ae:	68 26 37 10 00       	push   $0x103726
  1009b3:	e8 95 f8 ff ff       	call   10024d <cprintf>
  1009b8:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009bb:	eb 65                	jmp    100a22 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009c4:	eb 1c                	jmp    1009e2 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cc:	01 d0                	add    %edx,%eax
  1009ce:	0f b6 00             	movzbl (%eax),%eax
  1009d1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009da:	01 ca                	add    %ecx,%edx
  1009dc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009e8:	7c dc                	jl     1009c6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009ea:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f3:	01 d0                	add    %edx,%eax
  1009f5:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  1009f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1009fe:	89 d1                	mov    %edx,%ecx
  100a00:	29 c1                	sub    %eax,%ecx
  100a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a08:	83 ec 0c             	sub    $0xc,%esp
  100a0b:	51                   	push   %ecx
  100a0c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a12:	51                   	push   %ecx
  100a13:	52                   	push   %edx
  100a14:	50                   	push   %eax
  100a15:	68 42 37 10 00       	push   $0x103742
  100a1a:	e8 2e f8 ff ff       	call   10024d <cprintf>
  100a1f:	83 c4 20             	add    $0x20,%esp
}
  100a22:	90                   	nop
  100a23:	c9                   	leave  
  100a24:	c3                   	ret    

00100a25 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a25:	55                   	push   %ebp
  100a26:	89 e5                	mov    %esp,%ebp
  100a28:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a2b:	8b 45 04             	mov    0x4(%ebp),%eax
  100a2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a34:	c9                   	leave  
  100a35:	c3                   	ret    

00100a36 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a36:	55                   	push   %ebp
  100a37:	89 e5                	mov    %esp,%ebp
  100a39:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a3c:	89 e8                	mov    %ebp,%eax
  100a3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a41:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a47:	e8 d9 ff ff ff       	call   100a25 <read_eip>
  100a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a56:	e9 8d 00 00 00       	jmp    100ae8 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a5b:	83 ec 04             	sub    $0x4,%esp
  100a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  100a61:	ff 75 f4             	pushl  -0xc(%ebp)
  100a64:	68 54 37 10 00       	push   $0x103754
  100a69:	e8 df f7 ff ff       	call   10024d <cprintf>
  100a6e:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a74:	83 c0 08             	add    $0x8,%eax
  100a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a7a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a81:	eb 26                	jmp    100aa9 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  100a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a90:	01 d0                	add    %edx,%eax
  100a92:	8b 00                	mov    (%eax),%eax
  100a94:	83 ec 08             	sub    $0x8,%esp
  100a97:	50                   	push   %eax
  100a98:	68 70 37 10 00       	push   $0x103770
  100a9d:	e8 ab f7 ff ff       	call   10024d <cprintf>
  100aa2:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  100aa5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa9:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aad:	7e d4                	jle    100a83 <print_stackframe+0x4d>
        }
        cprintf("\n");
  100aaf:	83 ec 0c             	sub    $0xc,%esp
  100ab2:	68 78 37 10 00       	push   $0x103778
  100ab7:	e8 91 f7 ff ff       	call   10024d <cprintf>
  100abc:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac2:	83 e8 01             	sub    $0x1,%eax
  100ac5:	83 ec 0c             	sub    $0xc,%esp
  100ac8:	50                   	push   %eax
  100ac9:	e8 bb fe ff ff       	call   100989 <print_debuginfo>
  100ace:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad4:	83 c0 04             	add    $0x4,%eax
  100ad7:	8b 00                	mov    (%eax),%eax
  100ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adf:	8b 00                	mov    (%eax),%eax
  100ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100ae4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ae8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100aec:	74 0a                	je     100af8 <print_stackframe+0xc2>
  100aee:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100af2:	0f 8e 63 ff ff ff    	jle    100a5b <print_stackframe+0x25>
    }
}
  100af8:	90                   	nop
  100af9:	c9                   	leave  
  100afa:	c3                   	ret    

00100afb <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100afb:	55                   	push   %ebp
  100afc:	89 e5                	mov    %esp,%ebp
  100afe:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b08:	eb 0c                	jmp    100b16 <parse+0x1b>
            *buf ++ = '\0';
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	8d 50 01             	lea    0x1(%eax),%edx
  100b10:	89 55 08             	mov    %edx,0x8(%ebp)
  100b13:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	0f b6 00             	movzbl (%eax),%eax
  100b1c:	84 c0                	test   %al,%al
  100b1e:	74 1e                	je     100b3e <parse+0x43>
  100b20:	8b 45 08             	mov    0x8(%ebp),%eax
  100b23:	0f b6 00             	movzbl (%eax),%eax
  100b26:	0f be c0             	movsbl %al,%eax
  100b29:	83 ec 08             	sub    $0x8,%esp
  100b2c:	50                   	push   %eax
  100b2d:	68 fc 37 10 00       	push   $0x1037fc
  100b32:	e8 e2 20 00 00       	call   102c19 <strchr>
  100b37:	83 c4 10             	add    $0x10,%esp
  100b3a:	85 c0                	test   %eax,%eax
  100b3c:	75 cc                	jne    100b0a <parse+0xf>
        }
        if (*buf == '\0') {
  100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b41:	0f b6 00             	movzbl (%eax),%eax
  100b44:	84 c0                	test   %al,%al
  100b46:	74 65                	je     100bad <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b48:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b4c:	75 12                	jne    100b60 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b4e:	83 ec 08             	sub    $0x8,%esp
  100b51:	6a 10                	push   $0x10
  100b53:	68 01 38 10 00       	push   $0x103801
  100b58:	e8 f0 f6 ff ff       	call   10024d <cprintf>
  100b5d:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b63:	8d 50 01             	lea    0x1(%eax),%edx
  100b66:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b73:	01 c2                	add    %eax,%edx
  100b75:	8b 45 08             	mov    0x8(%ebp),%eax
  100b78:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7a:	eb 04                	jmp    100b80 <parse+0x85>
            buf ++;
  100b7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	84 c0                	test   %al,%al
  100b88:	74 8c                	je     100b16 <parse+0x1b>
  100b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8d:	0f b6 00             	movzbl (%eax),%eax
  100b90:	0f be c0             	movsbl %al,%eax
  100b93:	83 ec 08             	sub    $0x8,%esp
  100b96:	50                   	push   %eax
  100b97:	68 fc 37 10 00       	push   $0x1037fc
  100b9c:	e8 78 20 00 00       	call   102c19 <strchr>
  100ba1:	83 c4 10             	add    $0x10,%esp
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	74 d4                	je     100b7c <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba8:	e9 69 ff ff ff       	jmp    100b16 <parse+0x1b>
            break;
  100bad:	90                   	nop
        }
    }
    return argc;
  100bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bb1:	c9                   	leave  
  100bb2:	c3                   	ret    

00100bb3 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bb3:	55                   	push   %ebp
  100bb4:	89 e5                	mov    %esp,%ebp
  100bb6:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bb9:	83 ec 08             	sub    $0x8,%esp
  100bbc:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bbf:	50                   	push   %eax
  100bc0:	ff 75 08             	pushl  0x8(%ebp)
  100bc3:	e8 33 ff ff ff       	call   100afb <parse>
  100bc8:	83 c4 10             	add    $0x10,%esp
  100bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd2:	75 0a                	jne    100bde <runcmd+0x2b>
        return 0;
  100bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  100bd9:	e9 83 00 00 00       	jmp    100c61 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100be5:	eb 59                	jmp    100c40 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100be7:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bed:	89 d0                	mov    %edx,%eax
  100bef:	01 c0                	add    %eax,%eax
  100bf1:	01 d0                	add    %edx,%eax
  100bf3:	c1 e0 02             	shl    $0x2,%eax
  100bf6:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bfb:	8b 00                	mov    (%eax),%eax
  100bfd:	83 ec 08             	sub    $0x8,%esp
  100c00:	51                   	push   %ecx
  100c01:	50                   	push   %eax
  100c02:	e8 72 1f 00 00       	call   102b79 <strcmp>
  100c07:	83 c4 10             	add    $0x10,%esp
  100c0a:	85 c0                	test   %eax,%eax
  100c0c:	75 2e                	jne    100c3c <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c11:	89 d0                	mov    %edx,%eax
  100c13:	01 c0                	add    %eax,%eax
  100c15:	01 d0                	add    %edx,%eax
  100c17:	c1 e0 02             	shl    $0x2,%eax
  100c1a:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c1f:	8b 10                	mov    (%eax),%edx
  100c21:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c24:	83 c0 04             	add    $0x4,%eax
  100c27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c2a:	83 e9 01             	sub    $0x1,%ecx
  100c2d:	83 ec 04             	sub    $0x4,%esp
  100c30:	ff 75 0c             	pushl  0xc(%ebp)
  100c33:	50                   	push   %eax
  100c34:	51                   	push   %ecx
  100c35:	ff d2                	call   *%edx
  100c37:	83 c4 10             	add    $0x10,%esp
  100c3a:	eb 25                	jmp    100c61 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c43:	83 f8 02             	cmp    $0x2,%eax
  100c46:	76 9f                	jbe    100be7 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c4b:	83 ec 08             	sub    $0x8,%esp
  100c4e:	50                   	push   %eax
  100c4f:	68 1f 38 10 00       	push   $0x10381f
  100c54:	e8 f4 f5 ff ff       	call   10024d <cprintf>
  100c59:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c61:	c9                   	leave  
  100c62:	c3                   	ret    

00100c63 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c63:	55                   	push   %ebp
  100c64:	89 e5                	mov    %esp,%ebp
  100c66:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c69:	83 ec 0c             	sub    $0xc,%esp
  100c6c:	68 38 38 10 00       	push   $0x103838
  100c71:	e8 d7 f5 ff ff       	call   10024d <cprintf>
  100c76:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c79:	83 ec 0c             	sub    $0xc,%esp
  100c7c:	68 60 38 10 00       	push   $0x103860
  100c81:	e8 c7 f5 ff ff       	call   10024d <cprintf>
  100c86:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c8d:	74 0e                	je     100c9d <kmonitor+0x3a>
        print_trapframe(tf);
  100c8f:	83 ec 0c             	sub    $0xc,%esp
  100c92:	ff 75 08             	pushl  0x8(%ebp)
  100c95:	e8 57 0d 00 00       	call   1019f1 <print_trapframe>
  100c9a:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c9d:	83 ec 0c             	sub    $0xc,%esp
  100ca0:	68 85 38 10 00       	push   $0x103885
  100ca5:	e8 47 f6 ff ff       	call   1002f1 <readline>
  100caa:	83 c4 10             	add    $0x10,%esp
  100cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb4:	74 e7                	je     100c9d <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cb6:	83 ec 08             	sub    $0x8,%esp
  100cb9:	ff 75 08             	pushl  0x8(%ebp)
  100cbc:	ff 75 f4             	pushl  -0xc(%ebp)
  100cbf:	e8 ef fe ff ff       	call   100bb3 <runcmd>
  100cc4:	83 c4 10             	add    $0x10,%esp
  100cc7:	85 c0                	test   %eax,%eax
  100cc9:	78 02                	js     100ccd <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100ccb:	eb d0                	jmp    100c9d <kmonitor+0x3a>
                break;
  100ccd:	90                   	nop
            }
        }
    }
}
  100cce:	90                   	nop
  100ccf:	c9                   	leave  
  100cd0:	c3                   	ret    

00100cd1 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cde:	eb 3c                	jmp    100d1c <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce3:	89 d0                	mov    %edx,%eax
  100ce5:	01 c0                	add    %eax,%eax
  100ce7:	01 d0                	add    %edx,%eax
  100ce9:	c1 e0 02             	shl    $0x2,%eax
  100cec:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cf1:	8b 08                	mov    (%eax),%ecx
  100cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf6:	89 d0                	mov    %edx,%eax
  100cf8:	01 c0                	add    %eax,%eax
  100cfa:	01 d0                	add    %edx,%eax
  100cfc:	c1 e0 02             	shl    $0x2,%eax
  100cff:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d04:	8b 00                	mov    (%eax),%eax
  100d06:	83 ec 04             	sub    $0x4,%esp
  100d09:	51                   	push   %ecx
  100d0a:	50                   	push   %eax
  100d0b:	68 89 38 10 00       	push   $0x103889
  100d10:	e8 38 f5 ff ff       	call   10024d <cprintf>
  100d15:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d18:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d1f:	83 f8 02             	cmp    $0x2,%eax
  100d22:	76 bc                	jbe    100ce0 <mon_help+0xf>
    }
    return 0;
  100d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d31:	e8 b6 fb ff ff       	call   1008ec <print_kerninfo>
    return 0;
  100d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3b:	c9                   	leave  
  100d3c:	c3                   	ret    

00100d3d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d43:	e8 ee fc ff ff       	call   100a36 <print_stackframe>
    return 0;
  100d48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4d:	c9                   	leave  
  100d4e:	c3                   	ret    

00100d4f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d4f:	55                   	push   %ebp
  100d50:	89 e5                	mov    %esp,%ebp
  100d52:	83 ec 18             	sub    $0x18,%esp
  100d55:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d5b:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d5f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d63:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d67:	ee                   	out    %al,(%dx)
  100d68:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d6e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d72:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d76:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7a:	ee                   	out    %al,(%dx)
  100d7b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d81:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d85:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d89:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d8d:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d8e:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d95:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d98:	83 ec 0c             	sub    $0xc,%esp
  100d9b:	68 92 38 10 00       	push   $0x103892
  100da0:	e8 a8 f4 ff ff       	call   10024d <cprintf>
  100da5:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100da8:	83 ec 0c             	sub    $0xc,%esp
  100dab:	6a 00                	push   $0x0
  100dad:	e8 d2 08 00 00       	call   101684 <pic_enable>
  100db2:	83 c4 10             	add    $0x10,%esp
}
  100db5:	90                   	nop
  100db6:	c9                   	leave  
  100db7:	c3                   	ret    

00100db8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db8:	55                   	push   %ebp
  100db9:	89 e5                	mov    %esp,%ebp
  100dbb:	83 ec 10             	sub    $0x10,%esp
  100dbe:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dce:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dd4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dde:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de8:	89 c2                	mov    %eax,%edx
  100dea:	ec                   	in     (%dx),%al
  100deb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dee:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100df4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100df8:	89 c2                	mov    %eax,%edx
  100dfa:	ec                   	in     (%dx),%al
  100dfb:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dfe:	90                   	nop
  100dff:	c9                   	leave  
  100e00:	c3                   	ret    

00100e01 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e01:	55                   	push   %ebp
  100e02:	89 e5                	mov    %esp,%ebp
  100e04:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e07:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	0f b7 00             	movzwl (%eax),%eax
  100e26:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2a:	74 12                	je     100e3e <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e2c:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e33:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3a:	b4 03 
  100e3c:	eb 13                	jmp    100e51 <cga_init+0x50>
    } else {
        *cp = was;
  100e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e41:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e45:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e48:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e4f:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e51:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e58:	0f b7 c0             	movzwl %ax,%eax
  100e5b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e5f:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e63:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e67:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e6b:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e6c:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e73:	83 c0 01             	add    $0x1,%eax
  100e76:	0f b7 c0             	movzwl %ax,%eax
  100e79:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e81:	89 c2                	mov    %eax,%edx
  100e83:	ec                   	in     (%dx),%al
  100e84:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e87:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e8b:	0f b6 c0             	movzbl %al,%eax
  100e8e:	c1 e0 08             	shl    $0x8,%eax
  100e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e94:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9b:	0f b7 c0             	movzwl %ax,%eax
  100e9e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ea2:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eaa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eae:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eaf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb6:	83 c0 01             	add    $0x1,%eax
  100eb9:	0f b7 c0             	movzwl %ax,%eax
  100ebc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ec4:	89 c2                	mov    %eax,%edx
  100ec6:	ec                   	in     (%dx),%al
  100ec7:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eca:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ece:	0f b6 c0             	movzbl %al,%eax
  100ed1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed7:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100edf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee5:	90                   	nop
  100ee6:	c9                   	leave  
  100ee7:	c3                   	ret    

00100ee8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee8:	55                   	push   %ebp
  100ee9:	89 e5                	mov    %esp,%ebp
  100eeb:	83 ec 38             	sub    $0x38,%esp
  100eee:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ef4:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100efc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f00:	ee                   	out    %al,(%dx)
  100f01:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f07:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f0b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f0f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f13:	ee                   	out    %al,(%dx)
  100f14:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f1a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f1e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f22:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f26:	ee                   	out    %al,(%dx)
  100f27:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f2d:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f31:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f35:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f39:	ee                   	out    %al,(%dx)
  100f3a:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f40:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f44:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f48:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
  100f4d:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f53:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f57:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
  100f60:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f66:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f6a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f6e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f72:	ee                   	out    %al,(%dx)
  100f73:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f79:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f7d:	89 c2                	mov    %eax,%edx
  100f7f:	ec                   	in     (%dx),%al
  100f80:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f83:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f87:	3c ff                	cmp    $0xff,%al
  100f89:	0f 95 c0             	setne  %al
  100f8c:	0f b6 c0             	movzbl %al,%eax
  100f8f:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f94:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f9e:	89 c2                	mov    %eax,%edx
  100fa0:	ec                   	in     (%dx),%al
  100fa1:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fa4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100faa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fae:	89 c2                	mov    %eax,%edx
  100fb0:	ec                   	in     (%dx),%al
  100fb1:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb4:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb9:	85 c0                	test   %eax,%eax
  100fbb:	74 0d                	je     100fca <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fbd:	83 ec 0c             	sub    $0xc,%esp
  100fc0:	6a 04                	push   $0x4
  100fc2:	e8 bd 06 00 00       	call   101684 <pic_enable>
  100fc7:	83 c4 10             	add    $0x10,%esp
    }
}
  100fca:	90                   	nop
  100fcb:	c9                   	leave  
  100fcc:	c3                   	ret    

00100fcd <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fcd:	55                   	push   %ebp
  100fce:	89 e5                	mov    %esp,%ebp
  100fd0:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fda:	eb 09                	jmp    100fe5 <lpt_putc_sub+0x18>
        delay();
  100fdc:	e8 d7 fd ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe5:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100feb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fef:	89 c2                	mov    %eax,%edx
  100ff1:	ec                   	in     (%dx),%al
  100ff2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff9:	84 c0                	test   %al,%al
  100ffb:	78 09                	js     101006 <lpt_putc_sub+0x39>
  100ffd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101004:	7e d6                	jle    100fdc <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101006:	8b 45 08             	mov    0x8(%ebp),%eax
  101009:	0f b6 c0             	movzbl %al,%eax
  10100c:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101012:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101015:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101019:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
  10101e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101024:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101028:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10102c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101030:	ee                   	out    %al,(%dx)
  101031:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101037:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10103b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101043:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101044:	90                   	nop
  101045:	c9                   	leave  
  101046:	c3                   	ret    

00101047 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101047:	55                   	push   %ebp
  101048:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10104a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104e:	74 0d                	je     10105d <lpt_putc+0x16>
        lpt_putc_sub(c);
  101050:	ff 75 08             	pushl  0x8(%ebp)
  101053:	e8 75 ff ff ff       	call   100fcd <lpt_putc_sub>
  101058:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10105b:	eb 1e                	jmp    10107b <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10105d:	6a 08                	push   $0x8
  10105f:	e8 69 ff ff ff       	call   100fcd <lpt_putc_sub>
  101064:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101067:	6a 20                	push   $0x20
  101069:	e8 5f ff ff ff       	call   100fcd <lpt_putc_sub>
  10106e:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101071:	6a 08                	push   $0x8
  101073:	e8 55 ff ff ff       	call   100fcd <lpt_putc_sub>
  101078:	83 c4 04             	add    $0x4,%esp
}
  10107b:	90                   	nop
  10107c:	c9                   	leave  
  10107d:	c3                   	ret    

0010107e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107e:	55                   	push   %ebp
  10107f:	89 e5                	mov    %esp,%ebp
  101081:	53                   	push   %ebx
  101082:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101085:	8b 45 08             	mov    0x8(%ebp),%eax
  101088:	b0 00                	mov    $0x0,%al
  10108a:	85 c0                	test   %eax,%eax
  10108c:	75 07                	jne    101095 <cga_putc+0x17>
        c |= 0x0700;
  10108e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	0f b6 c0             	movzbl %al,%eax
  10109b:	83 f8 0a             	cmp    $0xa,%eax
  10109e:	74 52                	je     1010f2 <cga_putc+0x74>
  1010a0:	83 f8 0d             	cmp    $0xd,%eax
  1010a3:	74 5d                	je     101102 <cga_putc+0x84>
  1010a5:	83 f8 08             	cmp    $0x8,%eax
  1010a8:	0f 85 8e 00 00 00    	jne    10113c <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  1010ae:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b5:	66 85 c0             	test   %ax,%ax
  1010b8:	0f 84 a4 00 00 00    	je     101162 <cga_putc+0xe4>
            crt_pos --;
  1010be:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c5:	83 e8 01             	sub    $0x1,%eax
  1010c8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d1:	b0 00                	mov    $0x0,%al
  1010d3:	83 c8 20             	or     $0x20,%eax
  1010d6:	89 c1                	mov    %eax,%ecx
  1010d8:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010dd:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010e4:	0f b7 d2             	movzwl %dx,%edx
  1010e7:	01 d2                	add    %edx,%edx
  1010e9:	01 d0                	add    %edx,%eax
  1010eb:	89 ca                	mov    %ecx,%edx
  1010ed:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010f0:	eb 70                	jmp    101162 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  1010f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f9:	83 c0 50             	add    $0x50,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101102:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101109:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101110:	0f b7 c1             	movzwl %cx,%eax
  101113:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101119:	c1 e8 10             	shr    $0x10,%eax
  10111c:	89 c2                	mov    %eax,%edx
  10111e:	66 c1 ea 06          	shr    $0x6,%dx
  101122:	89 d0                	mov    %edx,%eax
  101124:	c1 e0 02             	shl    $0x2,%eax
  101127:	01 d0                	add    %edx,%eax
  101129:	c1 e0 04             	shl    $0x4,%eax
  10112c:	29 c1                	sub    %eax,%ecx
  10112e:	89 ca                	mov    %ecx,%edx
  101130:	89 d8                	mov    %ebx,%eax
  101132:	29 d0                	sub    %edx,%eax
  101134:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10113a:	eb 27                	jmp    101163 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101142:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101149:	8d 50 01             	lea    0x1(%eax),%edx
  10114c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101153:	0f b7 c0             	movzwl %ax,%eax
  101156:	01 c0                	add    %eax,%eax
  101158:	01 c8                	add    %ecx,%eax
  10115a:	8b 55 08             	mov    0x8(%ebp),%edx
  10115d:	66 89 10             	mov    %dx,(%eax)
        break;
  101160:	eb 01                	jmp    101163 <cga_putc+0xe5>
        break;
  101162:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101163:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116e:	76 59                	jbe    1011c9 <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101170:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101175:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101180:	83 ec 04             	sub    $0x4,%esp
  101183:	68 00 0f 00 00       	push   $0xf00
  101188:	52                   	push   %edx
  101189:	50                   	push   %eax
  10118a:	e8 89 1c 00 00       	call   102e18 <memmove>
  10118f:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101192:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101199:	eb 15                	jmp    1011b0 <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  10119b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a3:	01 d2                	add    %edx,%edx
  1011a5:	01 d0                	add    %edx,%eax
  1011a7:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b7:	7e e2                	jle    10119b <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  1011b9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c0:	83 e8 50             	sub    $0x50,%eax
  1011c3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c9:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d0:	0f b7 c0             	movzwl %ax,%eax
  1011d3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011d7:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011db:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011df:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011e3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011eb:	66 c1 e8 08          	shr    $0x8,%ax
  1011ef:	0f b6 c0             	movzbl %al,%eax
  1011f2:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f9:	83 c2 01             	add    $0x1,%edx
  1011fc:	0f b7 d2             	movzwl %dx,%edx
  1011ff:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101203:	88 45 e9             	mov    %al,-0x17(%ebp)
  101206:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10120a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10120e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101216:	0f b7 c0             	movzwl %ax,%eax
  101219:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10121d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101221:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101225:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101229:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10122a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101231:	0f b6 c0             	movzbl %al,%eax
  101234:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123b:	83 c2 01             	add    $0x1,%edx
  10123e:	0f b7 d2             	movzwl %dx,%edx
  101241:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101245:	88 45 f1             	mov    %al,-0xf(%ebp)
  101248:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
}
  101251:	90                   	nop
  101252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101255:	c9                   	leave  
  101256:	c3                   	ret    

00101257 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101257:	55                   	push   %ebp
  101258:	89 e5                	mov    %esp,%ebp
  10125a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101264:	eb 09                	jmp    10126f <serial_putc_sub+0x18>
        delay();
  101266:	e8 4d fb ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101275:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101279:	89 c2                	mov    %eax,%edx
  10127b:	ec                   	in     (%dx),%al
  10127c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101283:	0f b6 c0             	movzbl %al,%eax
  101286:	83 e0 20             	and    $0x20,%eax
  101289:	85 c0                	test   %eax,%eax
  10128b:	75 09                	jne    101296 <serial_putc_sub+0x3f>
  10128d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101294:	7e d0                	jle    101266 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101296:	8b 45 08             	mov    0x8(%ebp),%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a2:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ad:	ee                   	out    %al,(%dx)
}
  1012ae:	90                   	nop
  1012af:	c9                   	leave  
  1012b0:	c3                   	ret    

001012b1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b1:	55                   	push   %ebp
  1012b2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012b4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b8:	74 0d                	je     1012c7 <serial_putc+0x16>
        serial_putc_sub(c);
  1012ba:	ff 75 08             	pushl  0x8(%ebp)
  1012bd:	e8 95 ff ff ff       	call   101257 <serial_putc_sub>
  1012c2:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012c5:	eb 1e                	jmp    1012e5 <serial_putc+0x34>
        serial_putc_sub('\b');
  1012c7:	6a 08                	push   $0x8
  1012c9:	e8 89 ff ff ff       	call   101257 <serial_putc_sub>
  1012ce:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012d1:	6a 20                	push   $0x20
  1012d3:	e8 7f ff ff ff       	call   101257 <serial_putc_sub>
  1012d8:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012db:	6a 08                	push   $0x8
  1012dd:	e8 75 ff ff ff       	call   101257 <serial_putc_sub>
  1012e2:	83 c4 04             	add    $0x4,%esp
}
  1012e5:	90                   	nop
  1012e6:	c9                   	leave  
  1012e7:	c3                   	ret    

001012e8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e8:	55                   	push   %ebp
  1012e9:	89 e5                	mov    %esp,%ebp
  1012eb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012ee:	eb 33                	jmp    101323 <cons_intr+0x3b>
        if (c != 0) {
  1012f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f4:	74 2d                	je     101323 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f6:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fb:	8d 50 01             	lea    0x1(%eax),%edx
  1012fe:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101307:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101312:	3d 00 02 00 00       	cmp    $0x200,%eax
  101317:	75 0a                	jne    101323 <cons_intr+0x3b>
                cons.wpos = 0;
  101319:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101320:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101323:	8b 45 08             	mov    0x8(%ebp),%eax
  101326:	ff d0                	call   *%eax
  101328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10132b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10132f:	75 bf                	jne    1012f0 <cons_intr+0x8>
            }
        }
    }
}
  101331:	90                   	nop
  101332:	c9                   	leave  
  101333:	c3                   	ret    

00101334 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101334:	55                   	push   %ebp
  101335:	89 e5                	mov    %esp,%ebp
  101337:	83 ec 10             	sub    $0x10,%esp
  10133a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101340:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101344:	89 c2                	mov    %eax,%edx
  101346:	ec                   	in     (%dx),%al
  101347:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10134a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134e:	0f b6 c0             	movzbl %al,%eax
  101351:	83 e0 01             	and    $0x1,%eax
  101354:	85 c0                	test   %eax,%eax
  101356:	75 07                	jne    10135f <serial_proc_data+0x2b>
        return -1;
  101358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135d:	eb 2a                	jmp    101389 <serial_proc_data+0x55>
  10135f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101365:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101369:	89 c2                	mov    %eax,%edx
  10136b:	ec                   	in     (%dx),%al
  10136c:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10136f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101373:	0f b6 c0             	movzbl %al,%eax
  101376:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101379:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137d:	75 07                	jne    101386 <serial_proc_data+0x52>
        c = '\b';
  10137f:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101386:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101389:	c9                   	leave  
  10138a:	c3                   	ret    

0010138b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10138b:	55                   	push   %ebp
  10138c:	89 e5                	mov    %esp,%ebp
  10138e:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101391:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101396:	85 c0                	test   %eax,%eax
  101398:	74 10                	je     1013aa <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10139a:	83 ec 0c             	sub    $0xc,%esp
  10139d:	68 34 13 10 00       	push   $0x101334
  1013a2:	e8 41 ff ff ff       	call   1012e8 <cons_intr>
  1013a7:	83 c4 10             	add    $0x10,%esp
    }
}
  1013aa:	90                   	nop
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 28             	sub    $0x28,%esp
  1013b3:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 0a                	jne    1013db <kbd_proc_data+0x2e>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	e9 5d 01 00 00       	jmp    101538 <kbd_proc_data+0x18b>
  1013db:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e5:	89 c2                	mov    %eax,%edx
  1013e7:	ec                   	in     (%dx),%al
  1013e8:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013eb:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ef:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f2:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f6:	75 17                	jne    10140f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fd:	83 c8 40             	or     $0x40,%eax
  101400:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101405:	b8 00 00 00 00       	mov    $0x0,%eax
  10140a:	e9 29 01 00 00       	jmp    101538 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10140f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101413:	84 c0                	test   %al,%al
  101415:	79 47                	jns    10145e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101417:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141c:	83 e0 40             	and    $0x40,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	75 09                	jne    10142c <kbd_proc_data+0x7f>
  101423:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101427:	83 e0 7f             	and    $0x7f,%eax
  10142a:	eb 04                	jmp    101430 <kbd_proc_data+0x83>
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143e:	83 c8 40             	or     $0x40,%eax
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	f7 d0                	not    %eax
  101446:	89 c2                	mov    %eax,%edx
  101448:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144d:	21 d0                	and    %edx,%eax
  10144f:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101454:	b8 00 00 00 00       	mov    $0x0,%eax
  101459:	e9 da 00 00 00       	jmp    101538 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10145e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101463:	83 e0 40             	and    $0x40,%eax
  101466:	85 c0                	test   %eax,%eax
  101468:	74 11                	je     10147b <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10146a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101473:	83 e0 bf             	and    $0xffffffbf,%eax
  101476:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101486:	0f b6 d0             	movzbl %al,%edx
  101489:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148e:	09 d0                	or     %edx,%eax
  101490:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a0:	0f b6 d0             	movzbl %al,%edx
  1014a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a8:	31 d0                	xor    %edx,%eax
  1014aa:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014af:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b4:	83 e0 03             	and    $0x3,%eax
  1014b7:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c2:	01 d0                	add    %edx,%eax
  1014c4:	0f b6 00             	movzbl (%eax),%eax
  1014c7:	0f b6 c0             	movzbl %al,%eax
  1014ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d2:	83 e0 08             	and    $0x8,%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	74 22                	je     1014fb <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d9:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014dd:	7e 0c                	jle    1014eb <kbd_proc_data+0x13e>
  1014df:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e3:	7f 06                	jg     1014eb <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e5:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e9:	eb 10                	jmp    1014fb <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014eb:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ef:	7e 0a                	jle    1014fb <kbd_proc_data+0x14e>
  1014f1:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f5:	7f 04                	jg     1014fb <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101500:	f7 d0                	not    %eax
  101502:	83 e0 06             	and    $0x6,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	75 2c                	jne    101535 <kbd_proc_data+0x188>
  101509:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101510:	75 23                	jne    101535 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101512:	83 ec 0c             	sub    $0xc,%esp
  101515:	68 ad 38 10 00       	push   $0x1038ad
  10151a:	e8 2e ed ff ff       	call   10024d <cprintf>
  10151f:	83 c4 10             	add    $0x10,%esp
  101522:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101528:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101530:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101534:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101535:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101538:	c9                   	leave  
  101539:	c3                   	ret    

0010153a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10153a:	55                   	push   %ebp
  10153b:	89 e5                	mov    %esp,%ebp
  10153d:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101540:	83 ec 0c             	sub    $0xc,%esp
  101543:	68 ad 13 10 00       	push   $0x1013ad
  101548:	e8 9b fd ff ff       	call   1012e8 <cons_intr>
  10154d:	83 c4 10             	add    $0x10,%esp
}
  101550:	90                   	nop
  101551:	c9                   	leave  
  101552:	c3                   	ret    

00101553 <kbd_init>:

static void
kbd_init(void) {
  101553:	55                   	push   %ebp
  101554:	89 e5                	mov    %esp,%ebp
  101556:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101559:	e8 dc ff ff ff       	call   10153a <kbd_intr>
    pic_enable(IRQ_KBD);
  10155e:	83 ec 0c             	sub    $0xc,%esp
  101561:	6a 01                	push   $0x1
  101563:	e8 1c 01 00 00       	call   101684 <pic_enable>
  101568:	83 c4 10             	add    $0x10,%esp
}
  10156b:	90                   	nop
  10156c:	c9                   	leave  
  10156d:	c3                   	ret    

0010156e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156e:	55                   	push   %ebp
  10156f:	89 e5                	mov    %esp,%ebp
  101571:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101574:	e8 88 f8 ff ff       	call   100e01 <cga_init>
    serial_init();
  101579:	e8 6a f9 ff ff       	call   100ee8 <serial_init>
    kbd_init();
  10157e:	e8 d0 ff ff ff       	call   101553 <kbd_init>
    if (!serial_exists) {
  101583:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101588:	85 c0                	test   %eax,%eax
  10158a:	75 10                	jne    10159c <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10158c:	83 ec 0c             	sub    $0xc,%esp
  10158f:	68 b9 38 10 00       	push   $0x1038b9
  101594:	e8 b4 ec ff ff       	call   10024d <cprintf>
  101599:	83 c4 10             	add    $0x10,%esp
    }
}
  10159c:	90                   	nop
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015a5:	ff 75 08             	pushl  0x8(%ebp)
  1015a8:	e8 9a fa ff ff       	call   101047 <lpt_putc>
  1015ad:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	ff 75 08             	pushl  0x8(%ebp)
  1015b6:	e8 c3 fa ff ff       	call   10107e <cga_putc>
  1015bb:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015be:	83 ec 0c             	sub    $0xc,%esp
  1015c1:	ff 75 08             	pushl  0x8(%ebp)
  1015c4:	e8 e8 fc ff ff       	call   1012b1 <serial_putc>
  1015c9:	83 c4 10             	add    $0x10,%esp
}
  1015cc:	90                   	nop
  1015cd:	c9                   	leave  
  1015ce:	c3                   	ret    

001015cf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cf:	55                   	push   %ebp
  1015d0:	89 e5                	mov    %esp,%ebp
  1015d2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d5:	e8 b1 fd ff ff       	call   10138b <serial_intr>
    kbd_intr();
  1015da:	e8 5b ff ff ff       	call   10153a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015df:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ea:	39 c2                	cmp    %eax,%edx
  1015ec:	74 36                	je     101624 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ee:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f3:	8d 50 01             	lea    0x1(%eax),%edx
  1015f6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015fc:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101603:	0f b6 c0             	movzbl %al,%eax
  101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101609:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101613:	75 0a                	jne    10161f <cons_getc+0x50>
            cons.rpos = 0;
  101615:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161c:	00 00 00 
        }
        return c;
  10161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101622:	eb 05                	jmp    101629 <cons_getc+0x5a>
    }
    return 0;
  101624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101629:	c9                   	leave  
  10162a:	c3                   	ret    

0010162b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10162b:	55                   	push   %ebp
  10162c:	89 e5                	mov    %esp,%ebp
  10162e:	83 ec 14             	sub    $0x14,%esp
  101631:	8b 45 08             	mov    0x8(%ebp),%eax
  101634:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101638:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163c:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101642:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101647:	85 c0                	test   %eax,%eax
  101649:	74 36                	je     101681 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10164b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164f:	0f b6 c0             	movzbl %al,%eax
  101652:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101658:	88 45 f9             	mov    %al,-0x7(%ebp)
  10165b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10165f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101663:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101664:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101668:	66 c1 e8 08          	shr    $0x8,%ax
  10166c:	0f b6 c0             	movzbl %al,%eax
  10166f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101675:	88 45 fd             	mov    %al,-0x3(%ebp)
  101678:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10167c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101680:	ee                   	out    %al,(%dx)
    }
}
  101681:	90                   	nop
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101687:	8b 45 08             	mov    0x8(%ebp),%eax
  10168a:	ba 01 00 00 00       	mov    $0x1,%edx
  10168f:	89 c1                	mov    %eax,%ecx
  101691:	d3 e2                	shl    %cl,%edx
  101693:	89 d0                	mov    %edx,%eax
  101695:	f7 d0                	not    %eax
  101697:	89 c2                	mov    %eax,%edx
  101699:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a0:	21 d0                	and    %edx,%eax
  1016a2:	0f b7 c0             	movzwl %ax,%eax
  1016a5:	50                   	push   %eax
  1016a6:	e8 80 ff ff ff       	call   10162b <pic_setmask>
  1016ab:	83 c4 04             	add    $0x4,%esp
}
  1016ae:	90                   	nop
  1016af:	c9                   	leave  
  1016b0:	c3                   	ret    

001016b1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b1:	55                   	push   %ebp
  1016b2:	89 e5                	mov    %esp,%ebp
  1016b4:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016b7:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016be:	00 00 00 
  1016c1:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016c7:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016cb:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016cf:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016da:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016de:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016e2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
  1016e7:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016ed:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016f1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016f5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016f9:	ee                   	out    %al,(%dx)
  1016fa:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101700:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101704:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101708:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10170c:	ee                   	out    %al,(%dx)
  10170d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101713:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101717:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10171b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
  101720:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101726:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  10172a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10172e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101739:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10173d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101741:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10174c:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101750:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101754:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10175f:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101763:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101767:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101772:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101776:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10177a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101785:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101789:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101798:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10179c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017a0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017ab:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017af:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017b3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017be:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017c2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017c6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cb:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d2:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d6:	74 13                	je     1017eb <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017d8:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017df:	0f b7 c0             	movzwl %ax,%eax
  1017e2:	50                   	push   %eax
  1017e3:	e8 43 fe ff ff       	call   10162b <pic_setmask>
  1017e8:	83 c4 04             	add    $0x4,%esp
    }
}
  1017eb:	90                   	nop
  1017ec:	c9                   	leave  
  1017ed:	c3                   	ret    

001017ee <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ee:	55                   	push   %ebp
  1017ef:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017f1:	fb                   	sti    
    sti();
}
  1017f2:	90                   	nop
  1017f3:	5d                   	pop    %ebp
  1017f4:	c3                   	ret    

001017f5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f5:	55                   	push   %ebp
  1017f6:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f8:	fa                   	cli    
    cli();
}
  1017f9:	90                   	nop
  1017fa:	5d                   	pop    %ebp
  1017fb:	c3                   	ret    

001017fc <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017fc:	55                   	push   %ebp
  1017fd:	89 e5                	mov    %esp,%ebp
  1017ff:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101802:	83 ec 08             	sub    $0x8,%esp
  101805:	6a 64                	push   $0x64
  101807:	68 e0 38 10 00       	push   $0x1038e0
  10180c:	e8 3c ea ff ff       	call   10024d <cprintf>
  101811:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101814:	83 ec 0c             	sub    $0xc,%esp
  101817:	68 ea 38 10 00       	push   $0x1038ea
  10181c:	e8 2c ea ff ff       	call   10024d <cprintf>
  101821:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101824:	83 ec 04             	sub    $0x4,%esp
  101827:	68 f8 38 10 00       	push   $0x1038f8
  10182c:	6a 12                	push   $0x12
  10182e:	68 0e 39 10 00       	push   $0x10390e
  101833:	e8 7b eb ff ff       	call   1003b3 <__panic>

00101838 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101838:	55                   	push   %ebp
  101839:	89 e5                	mov    %esp,%ebp
  10183b:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101845:	e9 c3 00 00 00       	jmp    10190d <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101854:	89 c2                	mov    %eax,%edx
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101860:	00 
  101861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101864:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10186b:	00 08 00 
  10186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101871:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101878:	00 
  101879:	83 e2 e0             	and    $0xffffffe0,%edx
  10187c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101883:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101886:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10188d:	00 
  10188e:	83 e2 1f             	and    $0x1f,%edx
  101891:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a2:	00 
  1018a3:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a6:	83 ca 0e             	or     $0xe,%edx
  1018a9:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ba:	00 
  1018bb:	83 e2 ef             	and    $0xffffffef,%edx
  1018be:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018cf:	00 
  1018d0:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e4:	00 
  1018e5:	83 ca 80             	or     $0xffffff80,%edx
  1018e8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f9:	c1 e8 10             	shr    $0x10,%eax
  1018fc:	89 c2                	mov    %eax,%edx
  1018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101901:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101908:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101909:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	3d ff 00 00 00       	cmp    $0xff,%eax
  101915:	0f 86 2f ff ff ff    	jbe    10184a <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10191b:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101920:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101926:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10192d:	08 00 
  10192f:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101936:	83 e0 e0             	and    $0xffffffe0,%eax
  101939:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193e:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101945:	83 e0 1f             	and    $0x1f,%eax
  101948:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10194d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101954:	83 e0 f0             	and    $0xfffffff0,%eax
  101957:	83 c8 0e             	or     $0xe,%eax
  10195a:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195f:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101966:	83 e0 ef             	and    $0xffffffef,%eax
  101969:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196e:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101975:	83 c8 60             	or     $0x60,%eax
  101978:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101984:	83 c8 80             	or     $0xffffff80,%eax
  101987:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10198c:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101991:	c1 e8 10             	shr    $0x10,%eax
  101994:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  10199a:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a4:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  1019a7:	90                   	nop
  1019a8:	c9                   	leave  
  1019a9:	c3                   	ret    

001019aa <trapname>:

static const char *
trapname(int trapno) {
  1019aa:	55                   	push   %ebp
  1019ab:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b0:	83 f8 13             	cmp    $0x13,%eax
  1019b3:	77 0c                	ja     1019c1 <trapname+0x17>
        return excnames[trapno];
  1019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b8:	8b 04 85 60 3c 10 00 	mov    0x103c60(,%eax,4),%eax
  1019bf:	eb 18                	jmp    1019d9 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c1:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c5:	7e 0d                	jle    1019d4 <trapname+0x2a>
  1019c7:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019cb:	7f 07                	jg     1019d4 <trapname+0x2a>
        return "Hardware Interrupt";
  1019cd:	b8 1f 39 10 00       	mov    $0x10391f,%eax
  1019d2:	eb 05                	jmp    1019d9 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d4:	b8 32 39 10 00       	mov    $0x103932,%eax
}
  1019d9:	5d                   	pop    %ebp
  1019da:	c3                   	ret    

001019db <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019db:	55                   	push   %ebp
  1019dc:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019de:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e5:	66 83 f8 08          	cmp    $0x8,%ax
  1019e9:	0f 94 c0             	sete   %al
  1019ec:	0f b6 c0             	movzbl %al,%eax
}
  1019ef:	5d                   	pop    %ebp
  1019f0:	c3                   	ret    

001019f1 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f1:	55                   	push   %ebp
  1019f2:	89 e5                	mov    %esp,%ebp
  1019f4:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019f7:	83 ec 08             	sub    $0x8,%esp
  1019fa:	ff 75 08             	pushl  0x8(%ebp)
  1019fd:	68 73 39 10 00       	push   $0x103973
  101a02:	e8 46 e8 ff ff       	call   10024d <cprintf>
  101a07:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0d:	83 ec 0c             	sub    $0xc,%esp
  101a10:	50                   	push   %eax
  101a11:	e8 b6 01 00 00       	call   101bcc <print_regs>
  101a16:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a20:	0f b7 c0             	movzwl %ax,%eax
  101a23:	83 ec 08             	sub    $0x8,%esp
  101a26:	50                   	push   %eax
  101a27:	68 84 39 10 00       	push   $0x103984
  101a2c:	e8 1c e8 ff ff       	call   10024d <cprintf>
  101a31:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a3b:	0f b7 c0             	movzwl %ax,%eax
  101a3e:	83 ec 08             	sub    $0x8,%esp
  101a41:	50                   	push   %eax
  101a42:	68 97 39 10 00       	push   $0x103997
  101a47:	e8 01 e8 ff ff       	call   10024d <cprintf>
  101a4c:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a52:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a56:	0f b7 c0             	movzwl %ax,%eax
  101a59:	83 ec 08             	sub    $0x8,%esp
  101a5c:	50                   	push   %eax
  101a5d:	68 aa 39 10 00       	push   $0x1039aa
  101a62:	e8 e6 e7 ff ff       	call   10024d <cprintf>
  101a67:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a71:	0f b7 c0             	movzwl %ax,%eax
  101a74:	83 ec 08             	sub    $0x8,%esp
  101a77:	50                   	push   %eax
  101a78:	68 bd 39 10 00       	push   $0x1039bd
  101a7d:	e8 cb e7 ff ff       	call   10024d <cprintf>
  101a82:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	8b 40 30             	mov    0x30(%eax),%eax
  101a8b:	83 ec 0c             	sub    $0xc,%esp
  101a8e:	50                   	push   %eax
  101a8f:	e8 16 ff ff ff       	call   1019aa <trapname>
  101a94:	83 c4 10             	add    $0x10,%esp
  101a97:	89 c2                	mov    %eax,%edx
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	8b 40 30             	mov    0x30(%eax),%eax
  101a9f:	83 ec 04             	sub    $0x4,%esp
  101aa2:	52                   	push   %edx
  101aa3:	50                   	push   %eax
  101aa4:	68 d0 39 10 00       	push   $0x1039d0
  101aa9:	e8 9f e7 ff ff       	call   10024d <cprintf>
  101aae:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab4:	8b 40 34             	mov    0x34(%eax),%eax
  101ab7:	83 ec 08             	sub    $0x8,%esp
  101aba:	50                   	push   %eax
  101abb:	68 e2 39 10 00       	push   $0x1039e2
  101ac0:	e8 88 e7 ff ff       	call   10024d <cprintf>
  101ac5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	8b 40 38             	mov    0x38(%eax),%eax
  101ace:	83 ec 08             	sub    $0x8,%esp
  101ad1:	50                   	push   %eax
  101ad2:	68 f1 39 10 00       	push   $0x1039f1
  101ad7:	e8 71 e7 ff ff       	call   10024d <cprintf>
  101adc:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101adf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae6:	0f b7 c0             	movzwl %ax,%eax
  101ae9:	83 ec 08             	sub    $0x8,%esp
  101aec:	50                   	push   %eax
  101aed:	68 00 3a 10 00       	push   $0x103a00
  101af2:	e8 56 e7 ff ff       	call   10024d <cprintf>
  101af7:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101afa:	8b 45 08             	mov    0x8(%ebp),%eax
  101afd:	8b 40 40             	mov    0x40(%eax),%eax
  101b00:	83 ec 08             	sub    $0x8,%esp
  101b03:	50                   	push   %eax
  101b04:	68 13 3a 10 00       	push   $0x103a13
  101b09:	e8 3f e7 ff ff       	call   10024d <cprintf>
  101b0e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b18:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b1f:	eb 3f                	jmp    101b60 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b21:	8b 45 08             	mov    0x8(%ebp),%eax
  101b24:	8b 50 40             	mov    0x40(%eax),%edx
  101b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b2a:	21 d0                	and    %edx,%eax
  101b2c:	85 c0                	test   %eax,%eax
  101b2e:	74 29                	je     101b59 <print_trapframe+0x168>
  101b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b33:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b3a:	85 c0                	test   %eax,%eax
  101b3c:	74 1b                	je     101b59 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b41:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b48:	83 ec 08             	sub    $0x8,%esp
  101b4b:	50                   	push   %eax
  101b4c:	68 22 3a 10 00       	push   $0x103a22
  101b51:	e8 f7 e6 ff ff       	call   10024d <cprintf>
  101b56:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b5d:	d1 65 f0             	shll   -0x10(%ebp)
  101b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b63:	83 f8 17             	cmp    $0x17,%eax
  101b66:	76 b9                	jbe    101b21 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	8b 40 40             	mov    0x40(%eax),%eax
  101b6e:	c1 e8 0c             	shr    $0xc,%eax
  101b71:	83 e0 03             	and    $0x3,%eax
  101b74:	83 ec 08             	sub    $0x8,%esp
  101b77:	50                   	push   %eax
  101b78:	68 26 3a 10 00       	push   $0x103a26
  101b7d:	e8 cb e6 ff ff       	call   10024d <cprintf>
  101b82:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b85:	83 ec 0c             	sub    $0xc,%esp
  101b88:	ff 75 08             	pushl  0x8(%ebp)
  101b8b:	e8 4b fe ff ff       	call   1019db <trap_in_kernel>
  101b90:	83 c4 10             	add    $0x10,%esp
  101b93:	85 c0                	test   %eax,%eax
  101b95:	75 32                	jne    101bc9 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 40 44             	mov    0x44(%eax),%eax
  101b9d:	83 ec 08             	sub    $0x8,%esp
  101ba0:	50                   	push   %eax
  101ba1:	68 2f 3a 10 00       	push   $0x103a2f
  101ba6:	e8 a2 e6 ff ff       	call   10024d <cprintf>
  101bab:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bb5:	0f b7 c0             	movzwl %ax,%eax
  101bb8:	83 ec 08             	sub    $0x8,%esp
  101bbb:	50                   	push   %eax
  101bbc:	68 3e 3a 10 00       	push   $0x103a3e
  101bc1:	e8 87 e6 ff ff       	call   10024d <cprintf>
  101bc6:	83 c4 10             	add    $0x10,%esp
    }
}
  101bc9:	90                   	nop
  101bca:	c9                   	leave  
  101bcb:	c3                   	ret    

00101bcc <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bcc:	55                   	push   %ebp
  101bcd:	89 e5                	mov    %esp,%ebp
  101bcf:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	8b 00                	mov    (%eax),%eax
  101bd7:	83 ec 08             	sub    $0x8,%esp
  101bda:	50                   	push   %eax
  101bdb:	68 51 3a 10 00       	push   $0x103a51
  101be0:	e8 68 e6 ff ff       	call   10024d <cprintf>
  101be5:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 04             	mov    0x4(%eax),%eax
  101bee:	83 ec 08             	sub    $0x8,%esp
  101bf1:	50                   	push   %eax
  101bf2:	68 60 3a 10 00       	push   $0x103a60
  101bf7:	e8 51 e6 ff ff       	call   10024d <cprintf>
  101bfc:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	8b 40 08             	mov    0x8(%eax),%eax
  101c05:	83 ec 08             	sub    $0x8,%esp
  101c08:	50                   	push   %eax
  101c09:	68 6f 3a 10 00       	push   $0x103a6f
  101c0e:	e8 3a e6 ff ff       	call   10024d <cprintf>
  101c13:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c16:	8b 45 08             	mov    0x8(%ebp),%eax
  101c19:	8b 40 0c             	mov    0xc(%eax),%eax
  101c1c:	83 ec 08             	sub    $0x8,%esp
  101c1f:	50                   	push   %eax
  101c20:	68 7e 3a 10 00       	push   $0x103a7e
  101c25:	e8 23 e6 ff ff       	call   10024d <cprintf>
  101c2a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	8b 40 10             	mov    0x10(%eax),%eax
  101c33:	83 ec 08             	sub    $0x8,%esp
  101c36:	50                   	push   %eax
  101c37:	68 8d 3a 10 00       	push   $0x103a8d
  101c3c:	e8 0c e6 ff ff       	call   10024d <cprintf>
  101c41:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 40 14             	mov    0x14(%eax),%eax
  101c4a:	83 ec 08             	sub    $0x8,%esp
  101c4d:	50                   	push   %eax
  101c4e:	68 9c 3a 10 00       	push   $0x103a9c
  101c53:	e8 f5 e5 ff ff       	call   10024d <cprintf>
  101c58:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	8b 40 18             	mov    0x18(%eax),%eax
  101c61:	83 ec 08             	sub    $0x8,%esp
  101c64:	50                   	push   %eax
  101c65:	68 ab 3a 10 00       	push   $0x103aab
  101c6a:	e8 de e5 ff ff       	call   10024d <cprintf>
  101c6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c72:	8b 45 08             	mov    0x8(%ebp),%eax
  101c75:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c78:	83 ec 08             	sub    $0x8,%esp
  101c7b:	50                   	push   %eax
  101c7c:	68 ba 3a 10 00       	push   $0x103aba
  101c81:	e8 c7 e5 ff ff       	call   10024d <cprintf>
  101c86:	83 c4 10             	add    $0x10,%esp
}
  101c89:	90                   	nop
  101c8a:	c9                   	leave  
  101c8b:	c3                   	ret    

00101c8c <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c8c:	55                   	push   %ebp
  101c8d:	89 e5                	mov    %esp,%ebp
  101c8f:	57                   	push   %edi
  101c90:	56                   	push   %esi
  101c91:	53                   	push   %ebx
  101c92:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c95:	8b 45 08             	mov    0x8(%ebp),%eax
  101c98:	8b 40 30             	mov    0x30(%eax),%eax
  101c9b:	83 f8 2f             	cmp    $0x2f,%eax
  101c9e:	77 21                	ja     101cc1 <trap_dispatch+0x35>
  101ca0:	83 f8 2e             	cmp    $0x2e,%eax
  101ca3:	0f 83 ff 01 00 00    	jae    101ea8 <trap_dispatch+0x21c>
  101ca9:	83 f8 21             	cmp    $0x21,%eax
  101cac:	0f 84 87 00 00 00    	je     101d39 <trap_dispatch+0xad>
  101cb2:	83 f8 24             	cmp    $0x24,%eax
  101cb5:	74 5b                	je     101d12 <trap_dispatch+0x86>
  101cb7:	83 f8 20             	cmp    $0x20,%eax
  101cba:	74 1c                	je     101cd8 <trap_dispatch+0x4c>
  101cbc:	e9 b1 01 00 00       	jmp    101e72 <trap_dispatch+0x1e6>
  101cc1:	83 f8 78             	cmp    $0x78,%eax
  101cc4:	0f 84 96 00 00 00    	je     101d60 <trap_dispatch+0xd4>
  101cca:	83 f8 79             	cmp    $0x79,%eax
  101ccd:	0f 84 29 01 00 00    	je     101dfc <trap_dispatch+0x170>
  101cd3:	e9 9a 01 00 00       	jmp    101e72 <trap_dispatch+0x1e6>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101cd8:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cdd:	83 c0 01             	add    $0x1,%eax
  101ce0:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101ce5:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101ceb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cf0:	89 c8                	mov    %ecx,%eax
  101cf2:	f7 e2                	mul    %edx
  101cf4:	89 d0                	mov    %edx,%eax
  101cf6:	c1 e8 05             	shr    $0x5,%eax
  101cf9:	6b c0 64             	imul   $0x64,%eax,%eax
  101cfc:	29 c1                	sub    %eax,%ecx
  101cfe:	89 c8                	mov    %ecx,%eax
  101d00:	85 c0                	test   %eax,%eax
  101d02:	0f 85 a3 01 00 00    	jne    101eab <trap_dispatch+0x21f>
            print_ticks();
  101d08:	e8 ef fa ff ff       	call   1017fc <print_ticks>
        }
        break;
  101d0d:	e9 99 01 00 00       	jmp    101eab <trap_dispatch+0x21f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d12:	e8 b8 f8 ff ff       	call   1015cf <cons_getc>
  101d17:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d1a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d1e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d22:	83 ec 04             	sub    $0x4,%esp
  101d25:	52                   	push   %edx
  101d26:	50                   	push   %eax
  101d27:	68 c9 3a 10 00       	push   $0x103ac9
  101d2c:	e8 1c e5 ff ff       	call   10024d <cprintf>
  101d31:	83 c4 10             	add    $0x10,%esp
        break;
  101d34:	e9 79 01 00 00       	jmp    101eb2 <trap_dispatch+0x226>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d39:	e8 91 f8 ff ff       	call   1015cf <cons_getc>
  101d3e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d41:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d45:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d49:	83 ec 04             	sub    $0x4,%esp
  101d4c:	52                   	push   %edx
  101d4d:	50                   	push   %eax
  101d4e:	68 db 3a 10 00       	push   $0x103adb
  101d53:	e8 f5 e4 ff ff       	call   10024d <cprintf>
  101d58:	83 c4 10             	add    $0x10,%esp
        break;
  101d5b:	e9 52 01 00 00       	jmp    101eb2 <trap_dispatch+0x226>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d60:	8b 45 08             	mov    0x8(%ebp),%eax
  101d63:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d67:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d6b:	0f 84 3d 01 00 00    	je     101eae <trap_dispatch+0x222>
            switchk2u = *tf;
  101d71:	8b 55 08             	mov    0x8(%ebp),%edx
  101d74:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101d79:	89 d3                	mov    %edx,%ebx
  101d7b:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101d80:	8b 0b                	mov    (%ebx),%ecx
  101d82:	89 08                	mov    %ecx,(%eax)
  101d84:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101d88:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101d8c:	8d 78 04             	lea    0x4(%eax),%edi
  101d8f:	83 e7 fc             	and    $0xfffffffc,%edi
  101d92:	29 f8                	sub    %edi,%eax
  101d94:	29 c3                	sub    %eax,%ebx
  101d96:	01 c2                	add    %eax,%edx
  101d98:	83 e2 fc             	and    $0xfffffffc,%edx
  101d9b:	89 d0                	mov    %edx,%eax
  101d9d:	c1 e8 02             	shr    $0x2,%eax
  101da0:	89 de                	mov    %ebx,%esi
  101da2:	89 c1                	mov    %eax,%ecx
  101da4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101da6:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101dad:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101daf:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101db6:	23 00 
  101db8:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101dbf:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101dc5:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101dcc:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd5:	83 c0 44             	add    $0x44,%eax
  101dd8:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101ddd:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101de2:	80 cc 30             	or     $0x30,%ah
  101de5:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101dea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ded:	83 e8 04             	sub    $0x4,%eax
  101df0:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101df5:	89 10                	mov    %edx,(%eax)
        }
        break;
  101df7:	e9 b2 00 00 00       	jmp    101eae <trap_dispatch+0x222>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e03:	66 83 f8 08          	cmp    $0x8,%ax
  101e07:	0f 84 a4 00 00 00    	je     101eb1 <trap_dispatch+0x225>
            tf->tf_cs = KERNEL_CS;
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e16:	8b 45 08             	mov    0x8(%ebp),%eax
  101e19:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e22:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e26:	8b 45 08             	mov    0x8(%ebp),%eax
  101e29:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e30:	8b 40 40             	mov    0x40(%eax),%eax
  101e33:	80 e4 cf             	and    $0xcf,%ah
  101e36:	89 c2                	mov    %eax,%edx
  101e38:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3b:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e41:	8b 40 44             	mov    0x44(%eax),%eax
  101e44:	83 e8 44             	sub    $0x44,%eax
  101e47:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e4c:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e51:	83 ec 04             	sub    $0x4,%esp
  101e54:	6a 44                	push   $0x44
  101e56:	ff 75 08             	pushl  0x8(%ebp)
  101e59:	50                   	push   %eax
  101e5a:	e8 b9 0f 00 00       	call   102e18 <memmove>
  101e5f:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e62:	8b 15 6c f9 10 00    	mov    0x10f96c,%edx
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	83 e8 04             	sub    $0x4,%eax
  101e6e:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e70:	eb 3f                	jmp    101eb1 <trap_dispatch+0x225>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e79:	0f b7 c0             	movzwl %ax,%eax
  101e7c:	83 e0 03             	and    $0x3,%eax
  101e7f:	85 c0                	test   %eax,%eax
  101e81:	75 2f                	jne    101eb2 <trap_dispatch+0x226>
            print_trapframe(tf);
  101e83:	83 ec 0c             	sub    $0xc,%esp
  101e86:	ff 75 08             	pushl  0x8(%ebp)
  101e89:	e8 63 fb ff ff       	call   1019f1 <print_trapframe>
  101e8e:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e91:	83 ec 04             	sub    $0x4,%esp
  101e94:	68 ea 3a 10 00       	push   $0x103aea
  101e99:	68 d2 00 00 00       	push   $0xd2
  101e9e:	68 0e 39 10 00       	push   $0x10390e
  101ea3:	e8 0b e5 ff ff       	call   1003b3 <__panic>
        break;
  101ea8:	90                   	nop
  101ea9:	eb 07                	jmp    101eb2 <trap_dispatch+0x226>
        break;
  101eab:	90                   	nop
  101eac:	eb 04                	jmp    101eb2 <trap_dispatch+0x226>
        break;
  101eae:	90                   	nop
  101eaf:	eb 01                	jmp    101eb2 <trap_dispatch+0x226>
        break;
  101eb1:	90                   	nop
        }
    }
}
  101eb2:	90                   	nop
  101eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101eb6:	5b                   	pop    %ebx
  101eb7:	5e                   	pop    %esi
  101eb8:	5f                   	pop    %edi
  101eb9:	5d                   	pop    %ebp
  101eba:	c3                   	ret    

00101ebb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ebb:	55                   	push   %ebp
  101ebc:	89 e5                	mov    %esp,%ebp
  101ebe:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ec1:	83 ec 0c             	sub    $0xc,%esp
  101ec4:	ff 75 08             	pushl  0x8(%ebp)
  101ec7:	e8 c0 fd ff ff       	call   101c8c <trap_dispatch>
  101ecc:	83 c4 10             	add    $0x10,%esp
}
  101ecf:	90                   	nop
  101ed0:	c9                   	leave  
  101ed1:	c3                   	ret    

00101ed2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $0
  101ed4:	6a 00                	push   $0x0
  jmp __alltraps
  101ed6:	e9 67 0a 00 00       	jmp    102942 <__alltraps>

00101edb <vector1>:
.globl vector1
vector1:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $1
  101edd:	6a 01                	push   $0x1
  jmp __alltraps
  101edf:	e9 5e 0a 00 00       	jmp    102942 <__alltraps>

00101ee4 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $2
  101ee6:	6a 02                	push   $0x2
  jmp __alltraps
  101ee8:	e9 55 0a 00 00       	jmp    102942 <__alltraps>

00101eed <vector3>:
.globl vector3
vector3:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $3
  101eef:	6a 03                	push   $0x3
  jmp __alltraps
  101ef1:	e9 4c 0a 00 00       	jmp    102942 <__alltraps>

00101ef6 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $4
  101ef8:	6a 04                	push   $0x4
  jmp __alltraps
  101efa:	e9 43 0a 00 00       	jmp    102942 <__alltraps>

00101eff <vector5>:
.globl vector5
vector5:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $5
  101f01:	6a 05                	push   $0x5
  jmp __alltraps
  101f03:	e9 3a 0a 00 00       	jmp    102942 <__alltraps>

00101f08 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $6
  101f0a:	6a 06                	push   $0x6
  jmp __alltraps
  101f0c:	e9 31 0a 00 00       	jmp    102942 <__alltraps>

00101f11 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $7
  101f13:	6a 07                	push   $0x7
  jmp __alltraps
  101f15:	e9 28 0a 00 00       	jmp    102942 <__alltraps>

00101f1a <vector8>:
.globl vector8
vector8:
  pushl $8
  101f1a:	6a 08                	push   $0x8
  jmp __alltraps
  101f1c:	e9 21 0a 00 00       	jmp    102942 <__alltraps>

00101f21 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f21:	6a 09                	push   $0x9
  jmp __alltraps
  101f23:	e9 1a 0a 00 00       	jmp    102942 <__alltraps>

00101f28 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f28:	6a 0a                	push   $0xa
  jmp __alltraps
  101f2a:	e9 13 0a 00 00       	jmp    102942 <__alltraps>

00101f2f <vector11>:
.globl vector11
vector11:
  pushl $11
  101f2f:	6a 0b                	push   $0xb
  jmp __alltraps
  101f31:	e9 0c 0a 00 00       	jmp    102942 <__alltraps>

00101f36 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f36:	6a 0c                	push   $0xc
  jmp __alltraps
  101f38:	e9 05 0a 00 00       	jmp    102942 <__alltraps>

00101f3d <vector13>:
.globl vector13
vector13:
  pushl $13
  101f3d:	6a 0d                	push   $0xd
  jmp __alltraps
  101f3f:	e9 fe 09 00 00       	jmp    102942 <__alltraps>

00101f44 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f44:	6a 0e                	push   $0xe
  jmp __alltraps
  101f46:	e9 f7 09 00 00       	jmp    102942 <__alltraps>

00101f4b <vector15>:
.globl vector15
vector15:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $15
  101f4d:	6a 0f                	push   $0xf
  jmp __alltraps
  101f4f:	e9 ee 09 00 00       	jmp    102942 <__alltraps>

00101f54 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $16
  101f56:	6a 10                	push   $0x10
  jmp __alltraps
  101f58:	e9 e5 09 00 00       	jmp    102942 <__alltraps>

00101f5d <vector17>:
.globl vector17
vector17:
  pushl $17
  101f5d:	6a 11                	push   $0x11
  jmp __alltraps
  101f5f:	e9 de 09 00 00       	jmp    102942 <__alltraps>

00101f64 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $18
  101f66:	6a 12                	push   $0x12
  jmp __alltraps
  101f68:	e9 d5 09 00 00       	jmp    102942 <__alltraps>

00101f6d <vector19>:
.globl vector19
vector19:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $19
  101f6f:	6a 13                	push   $0x13
  jmp __alltraps
  101f71:	e9 cc 09 00 00       	jmp    102942 <__alltraps>

00101f76 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $20
  101f78:	6a 14                	push   $0x14
  jmp __alltraps
  101f7a:	e9 c3 09 00 00       	jmp    102942 <__alltraps>

00101f7f <vector21>:
.globl vector21
vector21:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $21
  101f81:	6a 15                	push   $0x15
  jmp __alltraps
  101f83:	e9 ba 09 00 00       	jmp    102942 <__alltraps>

00101f88 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $22
  101f8a:	6a 16                	push   $0x16
  jmp __alltraps
  101f8c:	e9 b1 09 00 00       	jmp    102942 <__alltraps>

00101f91 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $23
  101f93:	6a 17                	push   $0x17
  jmp __alltraps
  101f95:	e9 a8 09 00 00       	jmp    102942 <__alltraps>

00101f9a <vector24>:
.globl vector24
vector24:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $24
  101f9c:	6a 18                	push   $0x18
  jmp __alltraps
  101f9e:	e9 9f 09 00 00       	jmp    102942 <__alltraps>

00101fa3 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $25
  101fa5:	6a 19                	push   $0x19
  jmp __alltraps
  101fa7:	e9 96 09 00 00       	jmp    102942 <__alltraps>

00101fac <vector26>:
.globl vector26
vector26:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $26
  101fae:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fb0:	e9 8d 09 00 00       	jmp    102942 <__alltraps>

00101fb5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $27
  101fb7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fb9:	e9 84 09 00 00       	jmp    102942 <__alltraps>

00101fbe <vector28>:
.globl vector28
vector28:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $28
  101fc0:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fc2:	e9 7b 09 00 00       	jmp    102942 <__alltraps>

00101fc7 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $29
  101fc9:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fcb:	e9 72 09 00 00       	jmp    102942 <__alltraps>

00101fd0 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $30
  101fd2:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fd4:	e9 69 09 00 00       	jmp    102942 <__alltraps>

00101fd9 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $31
  101fdb:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fdd:	e9 60 09 00 00       	jmp    102942 <__alltraps>

00101fe2 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $32
  101fe4:	6a 20                	push   $0x20
  jmp __alltraps
  101fe6:	e9 57 09 00 00       	jmp    102942 <__alltraps>

00101feb <vector33>:
.globl vector33
vector33:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $33
  101fed:	6a 21                	push   $0x21
  jmp __alltraps
  101fef:	e9 4e 09 00 00       	jmp    102942 <__alltraps>

00101ff4 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $34
  101ff6:	6a 22                	push   $0x22
  jmp __alltraps
  101ff8:	e9 45 09 00 00       	jmp    102942 <__alltraps>

00101ffd <vector35>:
.globl vector35
vector35:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $35
  101fff:	6a 23                	push   $0x23
  jmp __alltraps
  102001:	e9 3c 09 00 00       	jmp    102942 <__alltraps>

00102006 <vector36>:
.globl vector36
vector36:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $36
  102008:	6a 24                	push   $0x24
  jmp __alltraps
  10200a:	e9 33 09 00 00       	jmp    102942 <__alltraps>

0010200f <vector37>:
.globl vector37
vector37:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $37
  102011:	6a 25                	push   $0x25
  jmp __alltraps
  102013:	e9 2a 09 00 00       	jmp    102942 <__alltraps>

00102018 <vector38>:
.globl vector38
vector38:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $38
  10201a:	6a 26                	push   $0x26
  jmp __alltraps
  10201c:	e9 21 09 00 00       	jmp    102942 <__alltraps>

00102021 <vector39>:
.globl vector39
vector39:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $39
  102023:	6a 27                	push   $0x27
  jmp __alltraps
  102025:	e9 18 09 00 00       	jmp    102942 <__alltraps>

0010202a <vector40>:
.globl vector40
vector40:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $40
  10202c:	6a 28                	push   $0x28
  jmp __alltraps
  10202e:	e9 0f 09 00 00       	jmp    102942 <__alltraps>

00102033 <vector41>:
.globl vector41
vector41:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $41
  102035:	6a 29                	push   $0x29
  jmp __alltraps
  102037:	e9 06 09 00 00       	jmp    102942 <__alltraps>

0010203c <vector42>:
.globl vector42
vector42:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $42
  10203e:	6a 2a                	push   $0x2a
  jmp __alltraps
  102040:	e9 fd 08 00 00       	jmp    102942 <__alltraps>

00102045 <vector43>:
.globl vector43
vector43:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $43
  102047:	6a 2b                	push   $0x2b
  jmp __alltraps
  102049:	e9 f4 08 00 00       	jmp    102942 <__alltraps>

0010204e <vector44>:
.globl vector44
vector44:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $44
  102050:	6a 2c                	push   $0x2c
  jmp __alltraps
  102052:	e9 eb 08 00 00       	jmp    102942 <__alltraps>

00102057 <vector45>:
.globl vector45
vector45:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $45
  102059:	6a 2d                	push   $0x2d
  jmp __alltraps
  10205b:	e9 e2 08 00 00       	jmp    102942 <__alltraps>

00102060 <vector46>:
.globl vector46
vector46:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $46
  102062:	6a 2e                	push   $0x2e
  jmp __alltraps
  102064:	e9 d9 08 00 00       	jmp    102942 <__alltraps>

00102069 <vector47>:
.globl vector47
vector47:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $47
  10206b:	6a 2f                	push   $0x2f
  jmp __alltraps
  10206d:	e9 d0 08 00 00       	jmp    102942 <__alltraps>

00102072 <vector48>:
.globl vector48
vector48:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $48
  102074:	6a 30                	push   $0x30
  jmp __alltraps
  102076:	e9 c7 08 00 00       	jmp    102942 <__alltraps>

0010207b <vector49>:
.globl vector49
vector49:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $49
  10207d:	6a 31                	push   $0x31
  jmp __alltraps
  10207f:	e9 be 08 00 00       	jmp    102942 <__alltraps>

00102084 <vector50>:
.globl vector50
vector50:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $50
  102086:	6a 32                	push   $0x32
  jmp __alltraps
  102088:	e9 b5 08 00 00       	jmp    102942 <__alltraps>

0010208d <vector51>:
.globl vector51
vector51:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $51
  10208f:	6a 33                	push   $0x33
  jmp __alltraps
  102091:	e9 ac 08 00 00       	jmp    102942 <__alltraps>

00102096 <vector52>:
.globl vector52
vector52:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $52
  102098:	6a 34                	push   $0x34
  jmp __alltraps
  10209a:	e9 a3 08 00 00       	jmp    102942 <__alltraps>

0010209f <vector53>:
.globl vector53
vector53:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $53
  1020a1:	6a 35                	push   $0x35
  jmp __alltraps
  1020a3:	e9 9a 08 00 00       	jmp    102942 <__alltraps>

001020a8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $54
  1020aa:	6a 36                	push   $0x36
  jmp __alltraps
  1020ac:	e9 91 08 00 00       	jmp    102942 <__alltraps>

001020b1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $55
  1020b3:	6a 37                	push   $0x37
  jmp __alltraps
  1020b5:	e9 88 08 00 00       	jmp    102942 <__alltraps>

001020ba <vector56>:
.globl vector56
vector56:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $56
  1020bc:	6a 38                	push   $0x38
  jmp __alltraps
  1020be:	e9 7f 08 00 00       	jmp    102942 <__alltraps>

001020c3 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $57
  1020c5:	6a 39                	push   $0x39
  jmp __alltraps
  1020c7:	e9 76 08 00 00       	jmp    102942 <__alltraps>

001020cc <vector58>:
.globl vector58
vector58:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $58
  1020ce:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020d0:	e9 6d 08 00 00       	jmp    102942 <__alltraps>

001020d5 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $59
  1020d7:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020d9:	e9 64 08 00 00       	jmp    102942 <__alltraps>

001020de <vector60>:
.globl vector60
vector60:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $60
  1020e0:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020e2:	e9 5b 08 00 00       	jmp    102942 <__alltraps>

001020e7 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $61
  1020e9:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020eb:	e9 52 08 00 00       	jmp    102942 <__alltraps>

001020f0 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $62
  1020f2:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020f4:	e9 49 08 00 00       	jmp    102942 <__alltraps>

001020f9 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $63
  1020fb:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020fd:	e9 40 08 00 00       	jmp    102942 <__alltraps>

00102102 <vector64>:
.globl vector64
vector64:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $64
  102104:	6a 40                	push   $0x40
  jmp __alltraps
  102106:	e9 37 08 00 00       	jmp    102942 <__alltraps>

0010210b <vector65>:
.globl vector65
vector65:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $65
  10210d:	6a 41                	push   $0x41
  jmp __alltraps
  10210f:	e9 2e 08 00 00       	jmp    102942 <__alltraps>

00102114 <vector66>:
.globl vector66
vector66:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $66
  102116:	6a 42                	push   $0x42
  jmp __alltraps
  102118:	e9 25 08 00 00       	jmp    102942 <__alltraps>

0010211d <vector67>:
.globl vector67
vector67:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $67
  10211f:	6a 43                	push   $0x43
  jmp __alltraps
  102121:	e9 1c 08 00 00       	jmp    102942 <__alltraps>

00102126 <vector68>:
.globl vector68
vector68:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $68
  102128:	6a 44                	push   $0x44
  jmp __alltraps
  10212a:	e9 13 08 00 00       	jmp    102942 <__alltraps>

0010212f <vector69>:
.globl vector69
vector69:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $69
  102131:	6a 45                	push   $0x45
  jmp __alltraps
  102133:	e9 0a 08 00 00       	jmp    102942 <__alltraps>

00102138 <vector70>:
.globl vector70
vector70:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $70
  10213a:	6a 46                	push   $0x46
  jmp __alltraps
  10213c:	e9 01 08 00 00       	jmp    102942 <__alltraps>

00102141 <vector71>:
.globl vector71
vector71:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $71
  102143:	6a 47                	push   $0x47
  jmp __alltraps
  102145:	e9 f8 07 00 00       	jmp    102942 <__alltraps>

0010214a <vector72>:
.globl vector72
vector72:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $72
  10214c:	6a 48                	push   $0x48
  jmp __alltraps
  10214e:	e9 ef 07 00 00       	jmp    102942 <__alltraps>

00102153 <vector73>:
.globl vector73
vector73:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $73
  102155:	6a 49                	push   $0x49
  jmp __alltraps
  102157:	e9 e6 07 00 00       	jmp    102942 <__alltraps>

0010215c <vector74>:
.globl vector74
vector74:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $74
  10215e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102160:	e9 dd 07 00 00       	jmp    102942 <__alltraps>

00102165 <vector75>:
.globl vector75
vector75:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $75
  102167:	6a 4b                	push   $0x4b
  jmp __alltraps
  102169:	e9 d4 07 00 00       	jmp    102942 <__alltraps>

0010216e <vector76>:
.globl vector76
vector76:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $76
  102170:	6a 4c                	push   $0x4c
  jmp __alltraps
  102172:	e9 cb 07 00 00       	jmp    102942 <__alltraps>

00102177 <vector77>:
.globl vector77
vector77:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $77
  102179:	6a 4d                	push   $0x4d
  jmp __alltraps
  10217b:	e9 c2 07 00 00       	jmp    102942 <__alltraps>

00102180 <vector78>:
.globl vector78
vector78:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $78
  102182:	6a 4e                	push   $0x4e
  jmp __alltraps
  102184:	e9 b9 07 00 00       	jmp    102942 <__alltraps>

00102189 <vector79>:
.globl vector79
vector79:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $79
  10218b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10218d:	e9 b0 07 00 00       	jmp    102942 <__alltraps>

00102192 <vector80>:
.globl vector80
vector80:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $80
  102194:	6a 50                	push   $0x50
  jmp __alltraps
  102196:	e9 a7 07 00 00       	jmp    102942 <__alltraps>

0010219b <vector81>:
.globl vector81
vector81:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $81
  10219d:	6a 51                	push   $0x51
  jmp __alltraps
  10219f:	e9 9e 07 00 00       	jmp    102942 <__alltraps>

001021a4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $82
  1021a6:	6a 52                	push   $0x52
  jmp __alltraps
  1021a8:	e9 95 07 00 00       	jmp    102942 <__alltraps>

001021ad <vector83>:
.globl vector83
vector83:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $83
  1021af:	6a 53                	push   $0x53
  jmp __alltraps
  1021b1:	e9 8c 07 00 00       	jmp    102942 <__alltraps>

001021b6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $84
  1021b8:	6a 54                	push   $0x54
  jmp __alltraps
  1021ba:	e9 83 07 00 00       	jmp    102942 <__alltraps>

001021bf <vector85>:
.globl vector85
vector85:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $85
  1021c1:	6a 55                	push   $0x55
  jmp __alltraps
  1021c3:	e9 7a 07 00 00       	jmp    102942 <__alltraps>

001021c8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $86
  1021ca:	6a 56                	push   $0x56
  jmp __alltraps
  1021cc:	e9 71 07 00 00       	jmp    102942 <__alltraps>

001021d1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $87
  1021d3:	6a 57                	push   $0x57
  jmp __alltraps
  1021d5:	e9 68 07 00 00       	jmp    102942 <__alltraps>

001021da <vector88>:
.globl vector88
vector88:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $88
  1021dc:	6a 58                	push   $0x58
  jmp __alltraps
  1021de:	e9 5f 07 00 00       	jmp    102942 <__alltraps>

001021e3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $89
  1021e5:	6a 59                	push   $0x59
  jmp __alltraps
  1021e7:	e9 56 07 00 00       	jmp    102942 <__alltraps>

001021ec <vector90>:
.globl vector90
vector90:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $90
  1021ee:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021f0:	e9 4d 07 00 00       	jmp    102942 <__alltraps>

001021f5 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $91
  1021f7:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021f9:	e9 44 07 00 00       	jmp    102942 <__alltraps>

001021fe <vector92>:
.globl vector92
vector92:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $92
  102200:	6a 5c                	push   $0x5c
  jmp __alltraps
  102202:	e9 3b 07 00 00       	jmp    102942 <__alltraps>

00102207 <vector93>:
.globl vector93
vector93:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $93
  102209:	6a 5d                	push   $0x5d
  jmp __alltraps
  10220b:	e9 32 07 00 00       	jmp    102942 <__alltraps>

00102210 <vector94>:
.globl vector94
vector94:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $94
  102212:	6a 5e                	push   $0x5e
  jmp __alltraps
  102214:	e9 29 07 00 00       	jmp    102942 <__alltraps>

00102219 <vector95>:
.globl vector95
vector95:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $95
  10221b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10221d:	e9 20 07 00 00       	jmp    102942 <__alltraps>

00102222 <vector96>:
.globl vector96
vector96:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $96
  102224:	6a 60                	push   $0x60
  jmp __alltraps
  102226:	e9 17 07 00 00       	jmp    102942 <__alltraps>

0010222b <vector97>:
.globl vector97
vector97:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $97
  10222d:	6a 61                	push   $0x61
  jmp __alltraps
  10222f:	e9 0e 07 00 00       	jmp    102942 <__alltraps>

00102234 <vector98>:
.globl vector98
vector98:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $98
  102236:	6a 62                	push   $0x62
  jmp __alltraps
  102238:	e9 05 07 00 00       	jmp    102942 <__alltraps>

0010223d <vector99>:
.globl vector99
vector99:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $99
  10223f:	6a 63                	push   $0x63
  jmp __alltraps
  102241:	e9 fc 06 00 00       	jmp    102942 <__alltraps>

00102246 <vector100>:
.globl vector100
vector100:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $100
  102248:	6a 64                	push   $0x64
  jmp __alltraps
  10224a:	e9 f3 06 00 00       	jmp    102942 <__alltraps>

0010224f <vector101>:
.globl vector101
vector101:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $101
  102251:	6a 65                	push   $0x65
  jmp __alltraps
  102253:	e9 ea 06 00 00       	jmp    102942 <__alltraps>

00102258 <vector102>:
.globl vector102
vector102:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $102
  10225a:	6a 66                	push   $0x66
  jmp __alltraps
  10225c:	e9 e1 06 00 00       	jmp    102942 <__alltraps>

00102261 <vector103>:
.globl vector103
vector103:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $103
  102263:	6a 67                	push   $0x67
  jmp __alltraps
  102265:	e9 d8 06 00 00       	jmp    102942 <__alltraps>

0010226a <vector104>:
.globl vector104
vector104:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $104
  10226c:	6a 68                	push   $0x68
  jmp __alltraps
  10226e:	e9 cf 06 00 00       	jmp    102942 <__alltraps>

00102273 <vector105>:
.globl vector105
vector105:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $105
  102275:	6a 69                	push   $0x69
  jmp __alltraps
  102277:	e9 c6 06 00 00       	jmp    102942 <__alltraps>

0010227c <vector106>:
.globl vector106
vector106:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $106
  10227e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102280:	e9 bd 06 00 00       	jmp    102942 <__alltraps>

00102285 <vector107>:
.globl vector107
vector107:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $107
  102287:	6a 6b                	push   $0x6b
  jmp __alltraps
  102289:	e9 b4 06 00 00       	jmp    102942 <__alltraps>

0010228e <vector108>:
.globl vector108
vector108:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $108
  102290:	6a 6c                	push   $0x6c
  jmp __alltraps
  102292:	e9 ab 06 00 00       	jmp    102942 <__alltraps>

00102297 <vector109>:
.globl vector109
vector109:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $109
  102299:	6a 6d                	push   $0x6d
  jmp __alltraps
  10229b:	e9 a2 06 00 00       	jmp    102942 <__alltraps>

001022a0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $110
  1022a2:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022a4:	e9 99 06 00 00       	jmp    102942 <__alltraps>

001022a9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $111
  1022ab:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022ad:	e9 90 06 00 00       	jmp    102942 <__alltraps>

001022b2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $112
  1022b4:	6a 70                	push   $0x70
  jmp __alltraps
  1022b6:	e9 87 06 00 00       	jmp    102942 <__alltraps>

001022bb <vector113>:
.globl vector113
vector113:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $113
  1022bd:	6a 71                	push   $0x71
  jmp __alltraps
  1022bf:	e9 7e 06 00 00       	jmp    102942 <__alltraps>

001022c4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $114
  1022c6:	6a 72                	push   $0x72
  jmp __alltraps
  1022c8:	e9 75 06 00 00       	jmp    102942 <__alltraps>

001022cd <vector115>:
.globl vector115
vector115:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $115
  1022cf:	6a 73                	push   $0x73
  jmp __alltraps
  1022d1:	e9 6c 06 00 00       	jmp    102942 <__alltraps>

001022d6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $116
  1022d8:	6a 74                	push   $0x74
  jmp __alltraps
  1022da:	e9 63 06 00 00       	jmp    102942 <__alltraps>

001022df <vector117>:
.globl vector117
vector117:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $117
  1022e1:	6a 75                	push   $0x75
  jmp __alltraps
  1022e3:	e9 5a 06 00 00       	jmp    102942 <__alltraps>

001022e8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $118
  1022ea:	6a 76                	push   $0x76
  jmp __alltraps
  1022ec:	e9 51 06 00 00       	jmp    102942 <__alltraps>

001022f1 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $119
  1022f3:	6a 77                	push   $0x77
  jmp __alltraps
  1022f5:	e9 48 06 00 00       	jmp    102942 <__alltraps>

001022fa <vector120>:
.globl vector120
vector120:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $120
  1022fc:	6a 78                	push   $0x78
  jmp __alltraps
  1022fe:	e9 3f 06 00 00       	jmp    102942 <__alltraps>

00102303 <vector121>:
.globl vector121
vector121:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $121
  102305:	6a 79                	push   $0x79
  jmp __alltraps
  102307:	e9 36 06 00 00       	jmp    102942 <__alltraps>

0010230c <vector122>:
.globl vector122
vector122:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $122
  10230e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102310:	e9 2d 06 00 00       	jmp    102942 <__alltraps>

00102315 <vector123>:
.globl vector123
vector123:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $123
  102317:	6a 7b                	push   $0x7b
  jmp __alltraps
  102319:	e9 24 06 00 00       	jmp    102942 <__alltraps>

0010231e <vector124>:
.globl vector124
vector124:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $124
  102320:	6a 7c                	push   $0x7c
  jmp __alltraps
  102322:	e9 1b 06 00 00       	jmp    102942 <__alltraps>

00102327 <vector125>:
.globl vector125
vector125:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $125
  102329:	6a 7d                	push   $0x7d
  jmp __alltraps
  10232b:	e9 12 06 00 00       	jmp    102942 <__alltraps>

00102330 <vector126>:
.globl vector126
vector126:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $126
  102332:	6a 7e                	push   $0x7e
  jmp __alltraps
  102334:	e9 09 06 00 00       	jmp    102942 <__alltraps>

00102339 <vector127>:
.globl vector127
vector127:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $127
  10233b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10233d:	e9 00 06 00 00       	jmp    102942 <__alltraps>

00102342 <vector128>:
.globl vector128
vector128:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $128
  102344:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102349:	e9 f4 05 00 00       	jmp    102942 <__alltraps>

0010234e <vector129>:
.globl vector129
vector129:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $129
  102350:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102355:	e9 e8 05 00 00       	jmp    102942 <__alltraps>

0010235a <vector130>:
.globl vector130
vector130:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $130
  10235c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102361:	e9 dc 05 00 00       	jmp    102942 <__alltraps>

00102366 <vector131>:
.globl vector131
vector131:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $131
  102368:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10236d:	e9 d0 05 00 00       	jmp    102942 <__alltraps>

00102372 <vector132>:
.globl vector132
vector132:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $132
  102374:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102379:	e9 c4 05 00 00       	jmp    102942 <__alltraps>

0010237e <vector133>:
.globl vector133
vector133:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $133
  102380:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102385:	e9 b8 05 00 00       	jmp    102942 <__alltraps>

0010238a <vector134>:
.globl vector134
vector134:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $134
  10238c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102391:	e9 ac 05 00 00       	jmp    102942 <__alltraps>

00102396 <vector135>:
.globl vector135
vector135:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $135
  102398:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10239d:	e9 a0 05 00 00       	jmp    102942 <__alltraps>

001023a2 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $136
  1023a4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023a9:	e9 94 05 00 00       	jmp    102942 <__alltraps>

001023ae <vector137>:
.globl vector137
vector137:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $137
  1023b0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023b5:	e9 88 05 00 00       	jmp    102942 <__alltraps>

001023ba <vector138>:
.globl vector138
vector138:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $138
  1023bc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023c1:	e9 7c 05 00 00       	jmp    102942 <__alltraps>

001023c6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $139
  1023c8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023cd:	e9 70 05 00 00       	jmp    102942 <__alltraps>

001023d2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $140
  1023d4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023d9:	e9 64 05 00 00       	jmp    102942 <__alltraps>

001023de <vector141>:
.globl vector141
vector141:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $141
  1023e0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023e5:	e9 58 05 00 00       	jmp    102942 <__alltraps>

001023ea <vector142>:
.globl vector142
vector142:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $142
  1023ec:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023f1:	e9 4c 05 00 00       	jmp    102942 <__alltraps>

001023f6 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $143
  1023f8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023fd:	e9 40 05 00 00       	jmp    102942 <__alltraps>

00102402 <vector144>:
.globl vector144
vector144:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $144
  102404:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102409:	e9 34 05 00 00       	jmp    102942 <__alltraps>

0010240e <vector145>:
.globl vector145
vector145:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $145
  102410:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102415:	e9 28 05 00 00       	jmp    102942 <__alltraps>

0010241a <vector146>:
.globl vector146
vector146:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $146
  10241c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102421:	e9 1c 05 00 00       	jmp    102942 <__alltraps>

00102426 <vector147>:
.globl vector147
vector147:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $147
  102428:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10242d:	e9 10 05 00 00       	jmp    102942 <__alltraps>

00102432 <vector148>:
.globl vector148
vector148:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $148
  102434:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102439:	e9 04 05 00 00       	jmp    102942 <__alltraps>

0010243e <vector149>:
.globl vector149
vector149:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $149
  102440:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102445:	e9 f8 04 00 00       	jmp    102942 <__alltraps>

0010244a <vector150>:
.globl vector150
vector150:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $150
  10244c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102451:	e9 ec 04 00 00       	jmp    102942 <__alltraps>

00102456 <vector151>:
.globl vector151
vector151:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $151
  102458:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10245d:	e9 e0 04 00 00       	jmp    102942 <__alltraps>

00102462 <vector152>:
.globl vector152
vector152:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $152
  102464:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102469:	e9 d4 04 00 00       	jmp    102942 <__alltraps>

0010246e <vector153>:
.globl vector153
vector153:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $153
  102470:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102475:	e9 c8 04 00 00       	jmp    102942 <__alltraps>

0010247a <vector154>:
.globl vector154
vector154:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $154
  10247c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102481:	e9 bc 04 00 00       	jmp    102942 <__alltraps>

00102486 <vector155>:
.globl vector155
vector155:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $155
  102488:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10248d:	e9 b0 04 00 00       	jmp    102942 <__alltraps>

00102492 <vector156>:
.globl vector156
vector156:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $156
  102494:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102499:	e9 a4 04 00 00       	jmp    102942 <__alltraps>

0010249e <vector157>:
.globl vector157
vector157:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $157
  1024a0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024a5:	e9 98 04 00 00       	jmp    102942 <__alltraps>

001024aa <vector158>:
.globl vector158
vector158:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $158
  1024ac:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024b1:	e9 8c 04 00 00       	jmp    102942 <__alltraps>

001024b6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $159
  1024b8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024bd:	e9 80 04 00 00       	jmp    102942 <__alltraps>

001024c2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $160
  1024c4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024c9:	e9 74 04 00 00       	jmp    102942 <__alltraps>

001024ce <vector161>:
.globl vector161
vector161:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $161
  1024d0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024d5:	e9 68 04 00 00       	jmp    102942 <__alltraps>

001024da <vector162>:
.globl vector162
vector162:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $162
  1024dc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024e1:	e9 5c 04 00 00       	jmp    102942 <__alltraps>

001024e6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $163
  1024e8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024ed:	e9 50 04 00 00       	jmp    102942 <__alltraps>

001024f2 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $164
  1024f4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024f9:	e9 44 04 00 00       	jmp    102942 <__alltraps>

001024fe <vector165>:
.globl vector165
vector165:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $165
  102500:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102505:	e9 38 04 00 00       	jmp    102942 <__alltraps>

0010250a <vector166>:
.globl vector166
vector166:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $166
  10250c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102511:	e9 2c 04 00 00       	jmp    102942 <__alltraps>

00102516 <vector167>:
.globl vector167
vector167:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $167
  102518:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10251d:	e9 20 04 00 00       	jmp    102942 <__alltraps>

00102522 <vector168>:
.globl vector168
vector168:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $168
  102524:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102529:	e9 14 04 00 00       	jmp    102942 <__alltraps>

0010252e <vector169>:
.globl vector169
vector169:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $169
  102530:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102535:	e9 08 04 00 00       	jmp    102942 <__alltraps>

0010253a <vector170>:
.globl vector170
vector170:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $170
  10253c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102541:	e9 fc 03 00 00       	jmp    102942 <__alltraps>

00102546 <vector171>:
.globl vector171
vector171:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $171
  102548:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10254d:	e9 f0 03 00 00       	jmp    102942 <__alltraps>

00102552 <vector172>:
.globl vector172
vector172:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $172
  102554:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102559:	e9 e4 03 00 00       	jmp    102942 <__alltraps>

0010255e <vector173>:
.globl vector173
vector173:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $173
  102560:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102565:	e9 d8 03 00 00       	jmp    102942 <__alltraps>

0010256a <vector174>:
.globl vector174
vector174:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $174
  10256c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102571:	e9 cc 03 00 00       	jmp    102942 <__alltraps>

00102576 <vector175>:
.globl vector175
vector175:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $175
  102578:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10257d:	e9 c0 03 00 00       	jmp    102942 <__alltraps>

00102582 <vector176>:
.globl vector176
vector176:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $176
  102584:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102589:	e9 b4 03 00 00       	jmp    102942 <__alltraps>

0010258e <vector177>:
.globl vector177
vector177:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $177
  102590:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102595:	e9 a8 03 00 00       	jmp    102942 <__alltraps>

0010259a <vector178>:
.globl vector178
vector178:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $178
  10259c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025a1:	e9 9c 03 00 00       	jmp    102942 <__alltraps>

001025a6 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $179
  1025a8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025ad:	e9 90 03 00 00       	jmp    102942 <__alltraps>

001025b2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $180
  1025b4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025b9:	e9 84 03 00 00       	jmp    102942 <__alltraps>

001025be <vector181>:
.globl vector181
vector181:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $181
  1025c0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025c5:	e9 78 03 00 00       	jmp    102942 <__alltraps>

001025ca <vector182>:
.globl vector182
vector182:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $182
  1025cc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025d1:	e9 6c 03 00 00       	jmp    102942 <__alltraps>

001025d6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $183
  1025d8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025dd:	e9 60 03 00 00       	jmp    102942 <__alltraps>

001025e2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $184
  1025e4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025e9:	e9 54 03 00 00       	jmp    102942 <__alltraps>

001025ee <vector185>:
.globl vector185
vector185:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $185
  1025f0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025f5:	e9 48 03 00 00       	jmp    102942 <__alltraps>

001025fa <vector186>:
.globl vector186
vector186:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $186
  1025fc:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102601:	e9 3c 03 00 00       	jmp    102942 <__alltraps>

00102606 <vector187>:
.globl vector187
vector187:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $187
  102608:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10260d:	e9 30 03 00 00       	jmp    102942 <__alltraps>

00102612 <vector188>:
.globl vector188
vector188:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $188
  102614:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102619:	e9 24 03 00 00       	jmp    102942 <__alltraps>

0010261e <vector189>:
.globl vector189
vector189:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $189
  102620:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102625:	e9 18 03 00 00       	jmp    102942 <__alltraps>

0010262a <vector190>:
.globl vector190
vector190:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $190
  10262c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102631:	e9 0c 03 00 00       	jmp    102942 <__alltraps>

00102636 <vector191>:
.globl vector191
vector191:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $191
  102638:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10263d:	e9 00 03 00 00       	jmp    102942 <__alltraps>

00102642 <vector192>:
.globl vector192
vector192:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $192
  102644:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102649:	e9 f4 02 00 00       	jmp    102942 <__alltraps>

0010264e <vector193>:
.globl vector193
vector193:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $193
  102650:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102655:	e9 e8 02 00 00       	jmp    102942 <__alltraps>

0010265a <vector194>:
.globl vector194
vector194:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $194
  10265c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102661:	e9 dc 02 00 00       	jmp    102942 <__alltraps>

00102666 <vector195>:
.globl vector195
vector195:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $195
  102668:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10266d:	e9 d0 02 00 00       	jmp    102942 <__alltraps>

00102672 <vector196>:
.globl vector196
vector196:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $196
  102674:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102679:	e9 c4 02 00 00       	jmp    102942 <__alltraps>

0010267e <vector197>:
.globl vector197
vector197:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $197
  102680:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102685:	e9 b8 02 00 00       	jmp    102942 <__alltraps>

0010268a <vector198>:
.globl vector198
vector198:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $198
  10268c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102691:	e9 ac 02 00 00       	jmp    102942 <__alltraps>

00102696 <vector199>:
.globl vector199
vector199:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $199
  102698:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10269d:	e9 a0 02 00 00       	jmp    102942 <__alltraps>

001026a2 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $200
  1026a4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026a9:	e9 94 02 00 00       	jmp    102942 <__alltraps>

001026ae <vector201>:
.globl vector201
vector201:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $201
  1026b0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026b5:	e9 88 02 00 00       	jmp    102942 <__alltraps>

001026ba <vector202>:
.globl vector202
vector202:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $202
  1026bc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026c1:	e9 7c 02 00 00       	jmp    102942 <__alltraps>

001026c6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $203
  1026c8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026cd:	e9 70 02 00 00       	jmp    102942 <__alltraps>

001026d2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $204
  1026d4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026d9:	e9 64 02 00 00       	jmp    102942 <__alltraps>

001026de <vector205>:
.globl vector205
vector205:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $205
  1026e0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026e5:	e9 58 02 00 00       	jmp    102942 <__alltraps>

001026ea <vector206>:
.globl vector206
vector206:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $206
  1026ec:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026f1:	e9 4c 02 00 00       	jmp    102942 <__alltraps>

001026f6 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $207
  1026f8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026fd:	e9 40 02 00 00       	jmp    102942 <__alltraps>

00102702 <vector208>:
.globl vector208
vector208:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $208
  102704:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102709:	e9 34 02 00 00       	jmp    102942 <__alltraps>

0010270e <vector209>:
.globl vector209
vector209:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $209
  102710:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102715:	e9 28 02 00 00       	jmp    102942 <__alltraps>

0010271a <vector210>:
.globl vector210
vector210:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $210
  10271c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102721:	e9 1c 02 00 00       	jmp    102942 <__alltraps>

00102726 <vector211>:
.globl vector211
vector211:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $211
  102728:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10272d:	e9 10 02 00 00       	jmp    102942 <__alltraps>

00102732 <vector212>:
.globl vector212
vector212:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $212
  102734:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102739:	e9 04 02 00 00       	jmp    102942 <__alltraps>

0010273e <vector213>:
.globl vector213
vector213:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $213
  102740:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102745:	e9 f8 01 00 00       	jmp    102942 <__alltraps>

0010274a <vector214>:
.globl vector214
vector214:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $214
  10274c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102751:	e9 ec 01 00 00       	jmp    102942 <__alltraps>

00102756 <vector215>:
.globl vector215
vector215:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $215
  102758:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10275d:	e9 e0 01 00 00       	jmp    102942 <__alltraps>

00102762 <vector216>:
.globl vector216
vector216:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $216
  102764:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102769:	e9 d4 01 00 00       	jmp    102942 <__alltraps>

0010276e <vector217>:
.globl vector217
vector217:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $217
  102770:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102775:	e9 c8 01 00 00       	jmp    102942 <__alltraps>

0010277a <vector218>:
.globl vector218
vector218:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $218
  10277c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102781:	e9 bc 01 00 00       	jmp    102942 <__alltraps>

00102786 <vector219>:
.globl vector219
vector219:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $219
  102788:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10278d:	e9 b0 01 00 00       	jmp    102942 <__alltraps>

00102792 <vector220>:
.globl vector220
vector220:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $220
  102794:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102799:	e9 a4 01 00 00       	jmp    102942 <__alltraps>

0010279e <vector221>:
.globl vector221
vector221:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $221
  1027a0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027a5:	e9 98 01 00 00       	jmp    102942 <__alltraps>

001027aa <vector222>:
.globl vector222
vector222:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $222
  1027ac:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027b1:	e9 8c 01 00 00       	jmp    102942 <__alltraps>

001027b6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $223
  1027b8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027bd:	e9 80 01 00 00       	jmp    102942 <__alltraps>

001027c2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $224
  1027c4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027c9:	e9 74 01 00 00       	jmp    102942 <__alltraps>

001027ce <vector225>:
.globl vector225
vector225:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $225
  1027d0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027d5:	e9 68 01 00 00       	jmp    102942 <__alltraps>

001027da <vector226>:
.globl vector226
vector226:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $226
  1027dc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027e1:	e9 5c 01 00 00       	jmp    102942 <__alltraps>

001027e6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $227
  1027e8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027ed:	e9 50 01 00 00       	jmp    102942 <__alltraps>

001027f2 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $228
  1027f4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027f9:	e9 44 01 00 00       	jmp    102942 <__alltraps>

001027fe <vector229>:
.globl vector229
vector229:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $229
  102800:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102805:	e9 38 01 00 00       	jmp    102942 <__alltraps>

0010280a <vector230>:
.globl vector230
vector230:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $230
  10280c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102811:	e9 2c 01 00 00       	jmp    102942 <__alltraps>

00102816 <vector231>:
.globl vector231
vector231:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $231
  102818:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10281d:	e9 20 01 00 00       	jmp    102942 <__alltraps>

00102822 <vector232>:
.globl vector232
vector232:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $232
  102824:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102829:	e9 14 01 00 00       	jmp    102942 <__alltraps>

0010282e <vector233>:
.globl vector233
vector233:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $233
  102830:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102835:	e9 08 01 00 00       	jmp    102942 <__alltraps>

0010283a <vector234>:
.globl vector234
vector234:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $234
  10283c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102841:	e9 fc 00 00 00       	jmp    102942 <__alltraps>

00102846 <vector235>:
.globl vector235
vector235:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $235
  102848:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10284d:	e9 f0 00 00 00       	jmp    102942 <__alltraps>

00102852 <vector236>:
.globl vector236
vector236:
  pushl $0
  102852:	6a 00                	push   $0x0
  pushl $236
  102854:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102859:	e9 e4 00 00 00       	jmp    102942 <__alltraps>

0010285e <vector237>:
.globl vector237
vector237:
  pushl $0
  10285e:	6a 00                	push   $0x0
  pushl $237
  102860:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102865:	e9 d8 00 00 00       	jmp    102942 <__alltraps>

0010286a <vector238>:
.globl vector238
vector238:
  pushl $0
  10286a:	6a 00                	push   $0x0
  pushl $238
  10286c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102871:	e9 cc 00 00 00       	jmp    102942 <__alltraps>

00102876 <vector239>:
.globl vector239
vector239:
  pushl $0
  102876:	6a 00                	push   $0x0
  pushl $239
  102878:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10287d:	e9 c0 00 00 00       	jmp    102942 <__alltraps>

00102882 <vector240>:
.globl vector240
vector240:
  pushl $0
  102882:	6a 00                	push   $0x0
  pushl $240
  102884:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102889:	e9 b4 00 00 00       	jmp    102942 <__alltraps>

0010288e <vector241>:
.globl vector241
vector241:
  pushl $0
  10288e:	6a 00                	push   $0x0
  pushl $241
  102890:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102895:	e9 a8 00 00 00       	jmp    102942 <__alltraps>

0010289a <vector242>:
.globl vector242
vector242:
  pushl $0
  10289a:	6a 00                	push   $0x0
  pushl $242
  10289c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028a1:	e9 9c 00 00 00       	jmp    102942 <__alltraps>

001028a6 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028a6:	6a 00                	push   $0x0
  pushl $243
  1028a8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028ad:	e9 90 00 00 00       	jmp    102942 <__alltraps>

001028b2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028b2:	6a 00                	push   $0x0
  pushl $244
  1028b4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028b9:	e9 84 00 00 00       	jmp    102942 <__alltraps>

001028be <vector245>:
.globl vector245
vector245:
  pushl $0
  1028be:	6a 00                	push   $0x0
  pushl $245
  1028c0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028c5:	e9 78 00 00 00       	jmp    102942 <__alltraps>

001028ca <vector246>:
.globl vector246
vector246:
  pushl $0
  1028ca:	6a 00                	push   $0x0
  pushl $246
  1028cc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028d1:	e9 6c 00 00 00       	jmp    102942 <__alltraps>

001028d6 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028d6:	6a 00                	push   $0x0
  pushl $247
  1028d8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028dd:	e9 60 00 00 00       	jmp    102942 <__alltraps>

001028e2 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028e2:	6a 00                	push   $0x0
  pushl $248
  1028e4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028e9:	e9 54 00 00 00       	jmp    102942 <__alltraps>

001028ee <vector249>:
.globl vector249
vector249:
  pushl $0
  1028ee:	6a 00                	push   $0x0
  pushl $249
  1028f0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028f5:	e9 48 00 00 00       	jmp    102942 <__alltraps>

001028fa <vector250>:
.globl vector250
vector250:
  pushl $0
  1028fa:	6a 00                	push   $0x0
  pushl $250
  1028fc:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102901:	e9 3c 00 00 00       	jmp    102942 <__alltraps>

00102906 <vector251>:
.globl vector251
vector251:
  pushl $0
  102906:	6a 00                	push   $0x0
  pushl $251
  102908:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10290d:	e9 30 00 00 00       	jmp    102942 <__alltraps>

00102912 <vector252>:
.globl vector252
vector252:
  pushl $0
  102912:	6a 00                	push   $0x0
  pushl $252
  102914:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102919:	e9 24 00 00 00       	jmp    102942 <__alltraps>

0010291e <vector253>:
.globl vector253
vector253:
  pushl $0
  10291e:	6a 00                	push   $0x0
  pushl $253
  102920:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102925:	e9 18 00 00 00       	jmp    102942 <__alltraps>

0010292a <vector254>:
.globl vector254
vector254:
  pushl $0
  10292a:	6a 00                	push   $0x0
  pushl $254
  10292c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102931:	e9 0c 00 00 00       	jmp    102942 <__alltraps>

00102936 <vector255>:
.globl vector255
vector255:
  pushl $0
  102936:	6a 00                	push   $0x0
  pushl $255
  102938:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10293d:	e9 00 00 00 00       	jmp    102942 <__alltraps>

00102942 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102942:	1e                   	push   %ds
    pushl %es
  102943:	06                   	push   %es
    pushl %fs
  102944:	0f a0                	push   %fs
    pushl %gs
  102946:	0f a8                	push   %gs
    pushal
  102948:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102949:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10294e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102950:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102952:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102953:	e8 63 f5 ff ff       	call   101ebb <trap>

    # pop the pushed stack pointer
    popl %esp
  102958:	5c                   	pop    %esp

00102959 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102959:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10295a:	0f a9                	pop    %gs
    popl %fs
  10295c:	0f a1                	pop    %fs
    popl %es
  10295e:	07                   	pop    %es
    popl %ds
  10295f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102960:	83 c4 08             	add    $0x8,%esp
    iret
  102963:	cf                   	iret   

00102964 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102964:	55                   	push   %ebp
  102965:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102967:	8b 45 08             	mov    0x8(%ebp),%eax
  10296a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10296d:	b8 23 00 00 00       	mov    $0x23,%eax
  102972:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102974:	b8 23 00 00 00       	mov    $0x23,%eax
  102979:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10297b:	b8 10 00 00 00       	mov    $0x10,%eax
  102980:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102982:	b8 10 00 00 00       	mov    $0x10,%eax
  102987:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102989:	b8 10 00 00 00       	mov    $0x10,%eax
  10298e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102990:	ea 97 29 10 00 08 00 	ljmp   $0x8,$0x102997
}
  102997:	90                   	nop
  102998:	5d                   	pop    %ebp
  102999:	c3                   	ret    

0010299a <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10299a:	55                   	push   %ebp
  10299b:	89 e5                	mov    %esp,%ebp
  10299d:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029a0:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  1029a5:	05 00 04 00 00       	add    $0x400,%eax
  1029aa:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029af:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029b6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029b8:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029bf:	68 00 
  1029c1:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029c6:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029cc:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029d1:	c1 e8 10             	shr    $0x10,%eax
  1029d4:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029d9:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029e0:	83 e0 f0             	and    $0xfffffff0,%eax
  1029e3:	83 c8 09             	or     $0x9,%eax
  1029e6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029eb:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029f2:	83 c8 10             	or     $0x10,%eax
  1029f5:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029fa:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a01:	83 e0 9f             	and    $0xffffff9f,%eax
  102a04:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a09:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a10:	83 c8 80             	or     $0xffffff80,%eax
  102a13:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a18:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a1f:	83 e0 f0             	and    $0xfffffff0,%eax
  102a22:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a27:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a2e:	83 e0 ef             	and    $0xffffffef,%eax
  102a31:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a36:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a3d:	83 e0 df             	and    $0xffffffdf,%eax
  102a40:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a45:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a4c:	83 c8 40             	or     $0x40,%eax
  102a4f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a54:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a5b:	83 e0 7f             	and    $0x7f,%eax
  102a5e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a63:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a68:	c1 e8 18             	shr    $0x18,%eax
  102a6b:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a70:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a77:	83 e0 ef             	and    $0xffffffef,%eax
  102a7a:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a7f:	68 10 ea 10 00       	push   $0x10ea10
  102a84:	e8 db fe ff ff       	call   102964 <lgdt>
  102a89:	83 c4 04             	add    $0x4,%esp
  102a8c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a92:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a96:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a99:	90                   	nop
  102a9a:	c9                   	leave  
  102a9b:	c3                   	ret    

00102a9c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a9c:	55                   	push   %ebp
  102a9d:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a9f:	e8 f6 fe ff ff       	call   10299a <gdt_init>
}
  102aa4:	90                   	nop
  102aa5:	5d                   	pop    %ebp
  102aa6:	c3                   	ret    

00102aa7 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102aa7:	55                   	push   %ebp
  102aa8:	89 e5                	mov    %esp,%ebp
  102aaa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102aad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102ab4:	eb 04                	jmp    102aba <strlen+0x13>
        cnt ++;
  102ab6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102aba:	8b 45 08             	mov    0x8(%ebp),%eax
  102abd:	8d 50 01             	lea    0x1(%eax),%edx
  102ac0:	89 55 08             	mov    %edx,0x8(%ebp)
  102ac3:	0f b6 00             	movzbl (%eax),%eax
  102ac6:	84 c0                	test   %al,%al
  102ac8:	75 ec                	jne    102ab6 <strlen+0xf>
    }
    return cnt;
  102aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102acd:	c9                   	leave  
  102ace:	c3                   	ret    

00102acf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102acf:	55                   	push   %ebp
  102ad0:	89 e5                	mov    %esp,%ebp
  102ad2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ad5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102adc:	eb 04                	jmp    102ae2 <strnlen+0x13>
        cnt ++;
  102ade:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ae5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ae8:	73 10                	jae    102afa <strnlen+0x2b>
  102aea:	8b 45 08             	mov    0x8(%ebp),%eax
  102aed:	8d 50 01             	lea    0x1(%eax),%edx
  102af0:	89 55 08             	mov    %edx,0x8(%ebp)
  102af3:	0f b6 00             	movzbl (%eax),%eax
  102af6:	84 c0                	test   %al,%al
  102af8:	75 e4                	jne    102ade <strnlen+0xf>
    }
    return cnt;
  102afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102afd:	c9                   	leave  
  102afe:	c3                   	ret    

00102aff <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102aff:	55                   	push   %ebp
  102b00:	89 e5                	mov    %esp,%ebp
  102b02:	57                   	push   %edi
  102b03:	56                   	push   %esi
  102b04:	83 ec 20             	sub    $0x20,%esp
  102b07:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b19:	89 d1                	mov    %edx,%ecx
  102b1b:	89 c2                	mov    %eax,%edx
  102b1d:	89 ce                	mov    %ecx,%esi
  102b1f:	89 d7                	mov    %edx,%edi
  102b21:	ac                   	lods   %ds:(%esi),%al
  102b22:	aa                   	stos   %al,%es:(%edi)
  102b23:	84 c0                	test   %al,%al
  102b25:	75 fa                	jne    102b21 <strcpy+0x22>
  102b27:	89 fa                	mov    %edi,%edx
  102b29:	89 f1                	mov    %esi,%ecx
  102b2b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b2e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b37:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b38:	83 c4 20             	add    $0x20,%esp
  102b3b:	5e                   	pop    %esi
  102b3c:	5f                   	pop    %edi
  102b3d:	5d                   	pop    %ebp
  102b3e:	c3                   	ret    

00102b3f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b3f:	55                   	push   %ebp
  102b40:	89 e5                	mov    %esp,%ebp
  102b42:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b45:	8b 45 08             	mov    0x8(%ebp),%eax
  102b48:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b4b:	eb 21                	jmp    102b6e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b50:	0f b6 10             	movzbl (%eax),%edx
  102b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b56:	88 10                	mov    %dl,(%eax)
  102b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b5b:	0f b6 00             	movzbl (%eax),%eax
  102b5e:	84 c0                	test   %al,%al
  102b60:	74 04                	je     102b66 <strncpy+0x27>
            src ++;
  102b62:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b66:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b72:	75 d9                	jne    102b4d <strncpy+0xe>
    }
    return dst;
  102b74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b77:	c9                   	leave  
  102b78:	c3                   	ret    

00102b79 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b79:	55                   	push   %ebp
  102b7a:	89 e5                	mov    %esp,%ebp
  102b7c:	57                   	push   %edi
  102b7d:	56                   	push   %esi
  102b7e:	83 ec 20             	sub    $0x20,%esp
  102b81:	8b 45 08             	mov    0x8(%ebp),%eax
  102b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b93:	89 d1                	mov    %edx,%ecx
  102b95:	89 c2                	mov    %eax,%edx
  102b97:	89 ce                	mov    %ecx,%esi
  102b99:	89 d7                	mov    %edx,%edi
  102b9b:	ac                   	lods   %ds:(%esi),%al
  102b9c:	ae                   	scas   %es:(%edi),%al
  102b9d:	75 08                	jne    102ba7 <strcmp+0x2e>
  102b9f:	84 c0                	test   %al,%al
  102ba1:	75 f8                	jne    102b9b <strcmp+0x22>
  102ba3:	31 c0                	xor    %eax,%eax
  102ba5:	eb 04                	jmp    102bab <strcmp+0x32>
  102ba7:	19 c0                	sbb    %eax,%eax
  102ba9:	0c 01                	or     $0x1,%al
  102bab:	89 fa                	mov    %edi,%edx
  102bad:	89 f1                	mov    %esi,%ecx
  102baf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bb2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102bb5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102bbb:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102bbc:	83 c4 20             	add    $0x20,%esp
  102bbf:	5e                   	pop    %esi
  102bc0:	5f                   	pop    %edi
  102bc1:	5d                   	pop    %ebp
  102bc2:	c3                   	ret    

00102bc3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102bc3:	55                   	push   %ebp
  102bc4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bc6:	eb 0c                	jmp    102bd4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102bc8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102bcc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bd0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bd8:	74 1a                	je     102bf4 <strncmp+0x31>
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	0f b6 00             	movzbl (%eax),%eax
  102be0:	84 c0                	test   %al,%al
  102be2:	74 10                	je     102bf4 <strncmp+0x31>
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	0f b6 10             	movzbl (%eax),%edx
  102bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bed:	0f b6 00             	movzbl (%eax),%eax
  102bf0:	38 c2                	cmp    %al,%dl
  102bf2:	74 d4                	je     102bc8 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bf8:	74 18                	je     102c12 <strncmp+0x4f>
  102bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfd:	0f b6 00             	movzbl (%eax),%eax
  102c00:	0f b6 d0             	movzbl %al,%edx
  102c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c06:	0f b6 00             	movzbl (%eax),%eax
  102c09:	0f b6 c0             	movzbl %al,%eax
  102c0c:	29 c2                	sub    %eax,%edx
  102c0e:	89 d0                	mov    %edx,%eax
  102c10:	eb 05                	jmp    102c17 <strncmp+0x54>
  102c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c17:	5d                   	pop    %ebp
  102c18:	c3                   	ret    

00102c19 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c19:	55                   	push   %ebp
  102c1a:	89 e5                	mov    %esp,%ebp
  102c1c:	83 ec 04             	sub    $0x4,%esp
  102c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c22:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c25:	eb 14                	jmp    102c3b <strchr+0x22>
        if (*s == c) {
  102c27:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2a:	0f b6 00             	movzbl (%eax),%eax
  102c2d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c30:	75 05                	jne    102c37 <strchr+0x1e>
            return (char *)s;
  102c32:	8b 45 08             	mov    0x8(%ebp),%eax
  102c35:	eb 13                	jmp    102c4a <strchr+0x31>
        }
        s ++;
  102c37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3e:	0f b6 00             	movzbl (%eax),%eax
  102c41:	84 c0                	test   %al,%al
  102c43:	75 e2                	jne    102c27 <strchr+0xe>
    }
    return NULL;
  102c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c4a:	c9                   	leave  
  102c4b:	c3                   	ret    

00102c4c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c4c:	55                   	push   %ebp
  102c4d:	89 e5                	mov    %esp,%ebp
  102c4f:	83 ec 04             	sub    $0x4,%esp
  102c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c55:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c58:	eb 0f                	jmp    102c69 <strfind+0x1d>
        if (*s == c) {
  102c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5d:	0f b6 00             	movzbl (%eax),%eax
  102c60:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c63:	74 10                	je     102c75 <strfind+0x29>
            break;
        }
        s ++;
  102c65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c69:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6c:	0f b6 00             	movzbl (%eax),%eax
  102c6f:	84 c0                	test   %al,%al
  102c71:	75 e7                	jne    102c5a <strfind+0xe>
  102c73:	eb 01                	jmp    102c76 <strfind+0x2a>
            break;
  102c75:	90                   	nop
    }
    return (char *)s;
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c79:	c9                   	leave  
  102c7a:	c3                   	ret    

00102c7b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c7b:	55                   	push   %ebp
  102c7c:	89 e5                	mov    %esp,%ebp
  102c7e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c8f:	eb 04                	jmp    102c95 <strtol+0x1a>
        s ++;
  102c91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c95:	8b 45 08             	mov    0x8(%ebp),%eax
  102c98:	0f b6 00             	movzbl (%eax),%eax
  102c9b:	3c 20                	cmp    $0x20,%al
  102c9d:	74 f2                	je     102c91 <strtol+0x16>
  102c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca2:	0f b6 00             	movzbl (%eax),%eax
  102ca5:	3c 09                	cmp    $0x9,%al
  102ca7:	74 e8                	je     102c91 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cac:	0f b6 00             	movzbl (%eax),%eax
  102caf:	3c 2b                	cmp    $0x2b,%al
  102cb1:	75 06                	jne    102cb9 <strtol+0x3e>
        s ++;
  102cb3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cb7:	eb 15                	jmp    102cce <strtol+0x53>
    }
    else if (*s == '-') {
  102cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbc:	0f b6 00             	movzbl (%eax),%eax
  102cbf:	3c 2d                	cmp    $0x2d,%al
  102cc1:	75 0b                	jne    102cce <strtol+0x53>
        s ++, neg = 1;
  102cc3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cc7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cd2:	74 06                	je     102cda <strtol+0x5f>
  102cd4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102cd8:	75 24                	jne    102cfe <strtol+0x83>
  102cda:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdd:	0f b6 00             	movzbl (%eax),%eax
  102ce0:	3c 30                	cmp    $0x30,%al
  102ce2:	75 1a                	jne    102cfe <strtol+0x83>
  102ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce7:	83 c0 01             	add    $0x1,%eax
  102cea:	0f b6 00             	movzbl (%eax),%eax
  102ced:	3c 78                	cmp    $0x78,%al
  102cef:	75 0d                	jne    102cfe <strtol+0x83>
        s += 2, base = 16;
  102cf1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102cf5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cfc:	eb 2a                	jmp    102d28 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d02:	75 17                	jne    102d1b <strtol+0xa0>
  102d04:	8b 45 08             	mov    0x8(%ebp),%eax
  102d07:	0f b6 00             	movzbl (%eax),%eax
  102d0a:	3c 30                	cmp    $0x30,%al
  102d0c:	75 0d                	jne    102d1b <strtol+0xa0>
        s ++, base = 8;
  102d0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d12:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d19:	eb 0d                	jmp    102d28 <strtol+0xad>
    }
    else if (base == 0) {
  102d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d1f:	75 07                	jne    102d28 <strtol+0xad>
        base = 10;
  102d21:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d28:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2b:	0f b6 00             	movzbl (%eax),%eax
  102d2e:	3c 2f                	cmp    $0x2f,%al
  102d30:	7e 1b                	jle    102d4d <strtol+0xd2>
  102d32:	8b 45 08             	mov    0x8(%ebp),%eax
  102d35:	0f b6 00             	movzbl (%eax),%eax
  102d38:	3c 39                	cmp    $0x39,%al
  102d3a:	7f 11                	jg     102d4d <strtol+0xd2>
            dig = *s - '0';
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	0f b6 00             	movzbl (%eax),%eax
  102d42:	0f be c0             	movsbl %al,%eax
  102d45:	83 e8 30             	sub    $0x30,%eax
  102d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d4b:	eb 48                	jmp    102d95 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	0f b6 00             	movzbl (%eax),%eax
  102d53:	3c 60                	cmp    $0x60,%al
  102d55:	7e 1b                	jle    102d72 <strtol+0xf7>
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	0f b6 00             	movzbl (%eax),%eax
  102d5d:	3c 7a                	cmp    $0x7a,%al
  102d5f:	7f 11                	jg     102d72 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d61:	8b 45 08             	mov    0x8(%ebp),%eax
  102d64:	0f b6 00             	movzbl (%eax),%eax
  102d67:	0f be c0             	movsbl %al,%eax
  102d6a:	83 e8 57             	sub    $0x57,%eax
  102d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d70:	eb 23                	jmp    102d95 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d72:	8b 45 08             	mov    0x8(%ebp),%eax
  102d75:	0f b6 00             	movzbl (%eax),%eax
  102d78:	3c 40                	cmp    $0x40,%al
  102d7a:	7e 3c                	jle    102db8 <strtol+0x13d>
  102d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7f:	0f b6 00             	movzbl (%eax),%eax
  102d82:	3c 5a                	cmp    $0x5a,%al
  102d84:	7f 32                	jg     102db8 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102d86:	8b 45 08             	mov    0x8(%ebp),%eax
  102d89:	0f b6 00             	movzbl (%eax),%eax
  102d8c:	0f be c0             	movsbl %al,%eax
  102d8f:	83 e8 37             	sub    $0x37,%eax
  102d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d9b:	7d 1a                	jge    102db7 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102d9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102da4:	0f af 45 10          	imul   0x10(%ebp),%eax
  102da8:	89 c2                	mov    %eax,%edx
  102daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dad:	01 d0                	add    %edx,%eax
  102daf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102db2:	e9 71 ff ff ff       	jmp    102d28 <strtol+0xad>
            break;
  102db7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dbc:	74 08                	je     102dc6 <strtol+0x14b>
        *endptr = (char *) s;
  102dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102dc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102dca:	74 07                	je     102dd3 <strtol+0x158>
  102dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dcf:	f7 d8                	neg    %eax
  102dd1:	eb 03                	jmp    102dd6 <strtol+0x15b>
  102dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102dd6:	c9                   	leave  
  102dd7:	c3                   	ret    

00102dd8 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102dd8:	55                   	push   %ebp
  102dd9:	89 e5                	mov    %esp,%ebp
  102ddb:	57                   	push   %edi
  102ddc:	83 ec 24             	sub    $0x24,%esp
  102ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102de5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102de9:	8b 55 08             	mov    0x8(%ebp),%edx
  102dec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102def:	88 45 f7             	mov    %al,-0x9(%ebp)
  102df2:	8b 45 10             	mov    0x10(%ebp),%eax
  102df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102df8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102dfb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102dff:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102e02:	89 d7                	mov    %edx,%edi
  102e04:	f3 aa                	rep stos %al,%es:(%edi)
  102e06:	89 fa                	mov    %edi,%edx
  102e08:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e0b:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e11:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e12:	83 c4 24             	add    $0x24,%esp
  102e15:	5f                   	pop    %edi
  102e16:	5d                   	pop    %ebp
  102e17:	c3                   	ret    

00102e18 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e18:	55                   	push   %ebp
  102e19:	89 e5                	mov    %esp,%ebp
  102e1b:	57                   	push   %edi
  102e1c:	56                   	push   %esi
  102e1d:	53                   	push   %ebx
  102e1e:	83 ec 30             	sub    $0x30,%esp
  102e21:	8b 45 08             	mov    0x8(%ebp),%eax
  102e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  102e30:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e39:	73 42                	jae    102e7d <memmove+0x65>
  102e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e50:	c1 e8 02             	shr    $0x2,%eax
  102e53:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5b:	89 d7                	mov    %edx,%edi
  102e5d:	89 c6                	mov    %eax,%esi
  102e5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e61:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e64:	83 e1 03             	and    $0x3,%ecx
  102e67:	74 02                	je     102e6b <memmove+0x53>
  102e69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e6b:	89 f0                	mov    %esi,%eax
  102e6d:	89 fa                	mov    %edi,%edx
  102e6f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e75:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e7b:	eb 36                	jmp    102eb3 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e80:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e86:	01 c2                	add    %eax,%edx
  102e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e8b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e91:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e97:	89 c1                	mov    %eax,%ecx
  102e99:	89 d8                	mov    %ebx,%eax
  102e9b:	89 d6                	mov    %edx,%esi
  102e9d:	89 c7                	mov    %eax,%edi
  102e9f:	fd                   	std    
  102ea0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ea2:	fc                   	cld    
  102ea3:	89 f8                	mov    %edi,%eax
  102ea5:	89 f2                	mov    %esi,%edx
  102ea7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102eaa:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ead:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102eb3:	83 c4 30             	add    $0x30,%esp
  102eb6:	5b                   	pop    %ebx
  102eb7:	5e                   	pop    %esi
  102eb8:	5f                   	pop    %edi
  102eb9:	5d                   	pop    %ebp
  102eba:	c3                   	ret    

00102ebb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ebb:	55                   	push   %ebp
  102ebc:	89 e5                	mov    %esp,%ebp
  102ebe:	57                   	push   %edi
  102ebf:	56                   	push   %esi
  102ec0:	83 ec 20             	sub    $0x20,%esp
  102ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  102ed2:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed8:	c1 e8 02             	shr    $0x2,%eax
  102edb:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee3:	89 d7                	mov    %edx,%edi
  102ee5:	89 c6                	mov    %eax,%esi
  102ee7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ee9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102eec:	83 e1 03             	and    $0x3,%ecx
  102eef:	74 02                	je     102ef3 <memcpy+0x38>
  102ef1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ef3:	89 f0                	mov    %esi,%eax
  102ef5:	89 fa                	mov    %edi,%edx
  102ef7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102efa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102efd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102f03:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102f04:	83 c4 20             	add    $0x20,%esp
  102f07:	5e                   	pop    %esi
  102f08:	5f                   	pop    %edi
  102f09:	5d                   	pop    %ebp
  102f0a:	c3                   	ret    

00102f0b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102f0b:	55                   	push   %ebp
  102f0c:	89 e5                	mov    %esp,%ebp
  102f0e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102f11:	8b 45 08             	mov    0x8(%ebp),%eax
  102f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f1d:	eb 30                	jmp    102f4f <memcmp+0x44>
        if (*s1 != *s2) {
  102f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f22:	0f b6 10             	movzbl (%eax),%edx
  102f25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f28:	0f b6 00             	movzbl (%eax),%eax
  102f2b:	38 c2                	cmp    %al,%dl
  102f2d:	74 18                	je     102f47 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f32:	0f b6 00             	movzbl (%eax),%eax
  102f35:	0f b6 d0             	movzbl %al,%edx
  102f38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f3b:	0f b6 00             	movzbl (%eax),%eax
  102f3e:	0f b6 c0             	movzbl %al,%eax
  102f41:	29 c2                	sub    %eax,%edx
  102f43:	89 d0                	mov    %edx,%eax
  102f45:	eb 1a                	jmp    102f61 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f47:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f4b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  102f52:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f55:	89 55 10             	mov    %edx,0x10(%ebp)
  102f58:	85 c0                	test   %eax,%eax
  102f5a:	75 c3                	jne    102f1f <memcmp+0x14>
    }
    return 0;
  102f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f61:	c9                   	leave  
  102f62:	c3                   	ret    

00102f63 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f63:	55                   	push   %ebp
  102f64:	89 e5                	mov    %esp,%ebp
  102f66:	83 ec 38             	sub    $0x38,%esp
  102f69:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  102f72:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f75:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f7e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f81:	8b 45 18             	mov    0x18(%ebp),%eax
  102f84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f90:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f9d:	74 1c                	je     102fbb <printnum+0x58>
  102f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa7:	f7 75 e4             	divl   -0x1c(%ebp)
  102faa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb5:	f7 75 e4             	divl   -0x1c(%ebp)
  102fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fc1:	f7 75 e4             	divl   -0x1c(%ebp)
  102fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fc7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102fca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fd3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fd9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fdc:	8b 45 18             	mov    0x18(%ebp),%eax
  102fdf:	ba 00 00 00 00       	mov    $0x0,%edx
  102fe4:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fe7:	72 41                	jb     10302a <printnum+0xc7>
  102fe9:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fec:	77 05                	ja     102ff3 <printnum+0x90>
  102fee:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102ff1:	72 37                	jb     10302a <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102ff3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ff6:	83 e8 01             	sub    $0x1,%eax
  102ff9:	83 ec 04             	sub    $0x4,%esp
  102ffc:	ff 75 20             	pushl  0x20(%ebp)
  102fff:	50                   	push   %eax
  103000:	ff 75 18             	pushl  0x18(%ebp)
  103003:	ff 75 ec             	pushl  -0x14(%ebp)
  103006:	ff 75 e8             	pushl  -0x18(%ebp)
  103009:	ff 75 0c             	pushl  0xc(%ebp)
  10300c:	ff 75 08             	pushl  0x8(%ebp)
  10300f:	e8 4f ff ff ff       	call   102f63 <printnum>
  103014:	83 c4 20             	add    $0x20,%esp
  103017:	eb 1b                	jmp    103034 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103019:	83 ec 08             	sub    $0x8,%esp
  10301c:	ff 75 0c             	pushl  0xc(%ebp)
  10301f:	ff 75 20             	pushl  0x20(%ebp)
  103022:	8b 45 08             	mov    0x8(%ebp),%eax
  103025:	ff d0                	call   *%eax
  103027:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  10302a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10302e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103032:	7f e5                	jg     103019 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103034:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103037:	05 30 3d 10 00       	add    $0x103d30,%eax
  10303c:	0f b6 00             	movzbl (%eax),%eax
  10303f:	0f be c0             	movsbl %al,%eax
  103042:	83 ec 08             	sub    $0x8,%esp
  103045:	ff 75 0c             	pushl  0xc(%ebp)
  103048:	50                   	push   %eax
  103049:	8b 45 08             	mov    0x8(%ebp),%eax
  10304c:	ff d0                	call   *%eax
  10304e:	83 c4 10             	add    $0x10,%esp
}
  103051:	90                   	nop
  103052:	c9                   	leave  
  103053:	c3                   	ret    

00103054 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103054:	55                   	push   %ebp
  103055:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103057:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10305b:	7e 14                	jle    103071 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10305d:	8b 45 08             	mov    0x8(%ebp),%eax
  103060:	8b 00                	mov    (%eax),%eax
  103062:	8d 48 08             	lea    0x8(%eax),%ecx
  103065:	8b 55 08             	mov    0x8(%ebp),%edx
  103068:	89 0a                	mov    %ecx,(%edx)
  10306a:	8b 50 04             	mov    0x4(%eax),%edx
  10306d:	8b 00                	mov    (%eax),%eax
  10306f:	eb 30                	jmp    1030a1 <getuint+0x4d>
    }
    else if (lflag) {
  103071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103075:	74 16                	je     10308d <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103077:	8b 45 08             	mov    0x8(%ebp),%eax
  10307a:	8b 00                	mov    (%eax),%eax
  10307c:	8d 48 04             	lea    0x4(%eax),%ecx
  10307f:	8b 55 08             	mov    0x8(%ebp),%edx
  103082:	89 0a                	mov    %ecx,(%edx)
  103084:	8b 00                	mov    (%eax),%eax
  103086:	ba 00 00 00 00       	mov    $0x0,%edx
  10308b:	eb 14                	jmp    1030a1 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10308d:	8b 45 08             	mov    0x8(%ebp),%eax
  103090:	8b 00                	mov    (%eax),%eax
  103092:	8d 48 04             	lea    0x4(%eax),%ecx
  103095:	8b 55 08             	mov    0x8(%ebp),%edx
  103098:	89 0a                	mov    %ecx,(%edx)
  10309a:	8b 00                	mov    (%eax),%eax
  10309c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1030a1:	5d                   	pop    %ebp
  1030a2:	c3                   	ret    

001030a3 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1030a3:	55                   	push   %ebp
  1030a4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1030a6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1030aa:	7e 14                	jle    1030c0 <getint+0x1d>
        return va_arg(*ap, long long);
  1030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1030af:	8b 00                	mov    (%eax),%eax
  1030b1:	8d 48 08             	lea    0x8(%eax),%ecx
  1030b4:	8b 55 08             	mov    0x8(%ebp),%edx
  1030b7:	89 0a                	mov    %ecx,(%edx)
  1030b9:	8b 50 04             	mov    0x4(%eax),%edx
  1030bc:	8b 00                	mov    (%eax),%eax
  1030be:	eb 28                	jmp    1030e8 <getint+0x45>
    }
    else if (lflag) {
  1030c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030c4:	74 12                	je     1030d8 <getint+0x35>
        return va_arg(*ap, long);
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	8b 00                	mov    (%eax),%eax
  1030cb:	8d 48 04             	lea    0x4(%eax),%ecx
  1030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1030d1:	89 0a                	mov    %ecx,(%edx)
  1030d3:	8b 00                	mov    (%eax),%eax
  1030d5:	99                   	cltd   
  1030d6:	eb 10                	jmp    1030e8 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030db:	8b 00                	mov    (%eax),%eax
  1030dd:	8d 48 04             	lea    0x4(%eax),%ecx
  1030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e3:	89 0a                	mov    %ecx,(%edx)
  1030e5:	8b 00                	mov    (%eax),%eax
  1030e7:	99                   	cltd   
    }
}
  1030e8:	5d                   	pop    %ebp
  1030e9:	c3                   	ret    

001030ea <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030ea:	55                   	push   %ebp
  1030eb:	89 e5                	mov    %esp,%ebp
  1030ed:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1030f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1030f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030f9:	50                   	push   %eax
  1030fa:	ff 75 10             	pushl  0x10(%ebp)
  1030fd:	ff 75 0c             	pushl  0xc(%ebp)
  103100:	ff 75 08             	pushl  0x8(%ebp)
  103103:	e8 06 00 00 00       	call   10310e <vprintfmt>
  103108:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10310b:	90                   	nop
  10310c:	c9                   	leave  
  10310d:	c3                   	ret    

0010310e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10310e:	55                   	push   %ebp
  10310f:	89 e5                	mov    %esp,%ebp
  103111:	56                   	push   %esi
  103112:	53                   	push   %ebx
  103113:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103116:	eb 17                	jmp    10312f <vprintfmt+0x21>
            if (ch == '\0') {
  103118:	85 db                	test   %ebx,%ebx
  10311a:	0f 84 8e 03 00 00    	je     1034ae <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  103120:	83 ec 08             	sub    $0x8,%esp
  103123:	ff 75 0c             	pushl  0xc(%ebp)
  103126:	53                   	push   %ebx
  103127:	8b 45 08             	mov    0x8(%ebp),%eax
  10312a:	ff d0                	call   *%eax
  10312c:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10312f:	8b 45 10             	mov    0x10(%ebp),%eax
  103132:	8d 50 01             	lea    0x1(%eax),%edx
  103135:	89 55 10             	mov    %edx,0x10(%ebp)
  103138:	0f b6 00             	movzbl (%eax),%eax
  10313b:	0f b6 d8             	movzbl %al,%ebx
  10313e:	83 fb 25             	cmp    $0x25,%ebx
  103141:	75 d5                	jne    103118 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103143:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103147:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10314e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103151:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103154:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10315b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10315e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103161:	8b 45 10             	mov    0x10(%ebp),%eax
  103164:	8d 50 01             	lea    0x1(%eax),%edx
  103167:	89 55 10             	mov    %edx,0x10(%ebp)
  10316a:	0f b6 00             	movzbl (%eax),%eax
  10316d:	0f b6 d8             	movzbl %al,%ebx
  103170:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103173:	83 f8 55             	cmp    $0x55,%eax
  103176:	0f 87 05 03 00 00    	ja     103481 <vprintfmt+0x373>
  10317c:	8b 04 85 54 3d 10 00 	mov    0x103d54(,%eax,4),%eax
  103183:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103185:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103189:	eb d6                	jmp    103161 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10318b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10318f:	eb d0                	jmp    103161 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103191:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103198:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10319b:	89 d0                	mov    %edx,%eax
  10319d:	c1 e0 02             	shl    $0x2,%eax
  1031a0:	01 d0                	add    %edx,%eax
  1031a2:	01 c0                	add    %eax,%eax
  1031a4:	01 d8                	add    %ebx,%eax
  1031a6:	83 e8 30             	sub    $0x30,%eax
  1031a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1031ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1031af:	0f b6 00             	movzbl (%eax),%eax
  1031b2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031b5:	83 fb 2f             	cmp    $0x2f,%ebx
  1031b8:	7e 39                	jle    1031f3 <vprintfmt+0xe5>
  1031ba:	83 fb 39             	cmp    $0x39,%ebx
  1031bd:	7f 34                	jg     1031f3 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  1031bf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1031c3:	eb d3                	jmp    103198 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1031c5:	8b 45 14             	mov    0x14(%ebp),%eax
  1031c8:	8d 50 04             	lea    0x4(%eax),%edx
  1031cb:	89 55 14             	mov    %edx,0x14(%ebp)
  1031ce:	8b 00                	mov    (%eax),%eax
  1031d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031d3:	eb 1f                	jmp    1031f4 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1031d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031d9:	79 86                	jns    103161 <vprintfmt+0x53>
                width = 0;
  1031db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031e2:	e9 7a ff ff ff       	jmp    103161 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1031e7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031ee:	e9 6e ff ff ff       	jmp    103161 <vprintfmt+0x53>
            goto process_precision;
  1031f3:	90                   	nop

        process_precision:
            if (width < 0)
  1031f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031f8:	0f 89 63 ff ff ff    	jns    103161 <vprintfmt+0x53>
                width = precision, precision = -1;
  1031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103201:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103204:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10320b:	e9 51 ff ff ff       	jmp    103161 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103210:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103214:	e9 48 ff ff ff       	jmp    103161 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103219:	8b 45 14             	mov    0x14(%ebp),%eax
  10321c:	8d 50 04             	lea    0x4(%eax),%edx
  10321f:	89 55 14             	mov    %edx,0x14(%ebp)
  103222:	8b 00                	mov    (%eax),%eax
  103224:	83 ec 08             	sub    $0x8,%esp
  103227:	ff 75 0c             	pushl  0xc(%ebp)
  10322a:	50                   	push   %eax
  10322b:	8b 45 08             	mov    0x8(%ebp),%eax
  10322e:	ff d0                	call   *%eax
  103230:	83 c4 10             	add    $0x10,%esp
            break;
  103233:	e9 71 02 00 00       	jmp    1034a9 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103238:	8b 45 14             	mov    0x14(%ebp),%eax
  10323b:	8d 50 04             	lea    0x4(%eax),%edx
  10323e:	89 55 14             	mov    %edx,0x14(%ebp)
  103241:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103243:	85 db                	test   %ebx,%ebx
  103245:	79 02                	jns    103249 <vprintfmt+0x13b>
                err = -err;
  103247:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103249:	83 fb 06             	cmp    $0x6,%ebx
  10324c:	7f 0b                	jg     103259 <vprintfmt+0x14b>
  10324e:	8b 34 9d 14 3d 10 00 	mov    0x103d14(,%ebx,4),%esi
  103255:	85 f6                	test   %esi,%esi
  103257:	75 19                	jne    103272 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103259:	53                   	push   %ebx
  10325a:	68 41 3d 10 00       	push   $0x103d41
  10325f:	ff 75 0c             	pushl  0xc(%ebp)
  103262:	ff 75 08             	pushl  0x8(%ebp)
  103265:	e8 80 fe ff ff       	call   1030ea <printfmt>
  10326a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10326d:	e9 37 02 00 00       	jmp    1034a9 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  103272:	56                   	push   %esi
  103273:	68 4a 3d 10 00       	push   $0x103d4a
  103278:	ff 75 0c             	pushl  0xc(%ebp)
  10327b:	ff 75 08             	pushl  0x8(%ebp)
  10327e:	e8 67 fe ff ff       	call   1030ea <printfmt>
  103283:	83 c4 10             	add    $0x10,%esp
            break;
  103286:	e9 1e 02 00 00       	jmp    1034a9 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10328b:	8b 45 14             	mov    0x14(%ebp),%eax
  10328e:	8d 50 04             	lea    0x4(%eax),%edx
  103291:	89 55 14             	mov    %edx,0x14(%ebp)
  103294:	8b 30                	mov    (%eax),%esi
  103296:	85 f6                	test   %esi,%esi
  103298:	75 05                	jne    10329f <vprintfmt+0x191>
                p = "(null)";
  10329a:	be 4d 3d 10 00       	mov    $0x103d4d,%esi
            }
            if (width > 0 && padc != '-') {
  10329f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032a3:	7e 76                	jle    10331b <vprintfmt+0x20d>
  1032a5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1032a9:	74 70                	je     10331b <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032ae:	83 ec 08             	sub    $0x8,%esp
  1032b1:	50                   	push   %eax
  1032b2:	56                   	push   %esi
  1032b3:	e8 17 f8 ff ff       	call   102acf <strnlen>
  1032b8:	83 c4 10             	add    $0x10,%esp
  1032bb:	89 c2                	mov    %eax,%edx
  1032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032c0:	29 d0                	sub    %edx,%eax
  1032c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032c5:	eb 17                	jmp    1032de <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1032c7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032cb:	83 ec 08             	sub    $0x8,%esp
  1032ce:	ff 75 0c             	pushl  0xc(%ebp)
  1032d1:	50                   	push   %eax
  1032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d5:	ff d0                	call   *%eax
  1032d7:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032da:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032e2:	7f e3                	jg     1032c7 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032e4:	eb 35                	jmp    10331b <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032ea:	74 1c                	je     103308 <vprintfmt+0x1fa>
  1032ec:	83 fb 1f             	cmp    $0x1f,%ebx
  1032ef:	7e 05                	jle    1032f6 <vprintfmt+0x1e8>
  1032f1:	83 fb 7e             	cmp    $0x7e,%ebx
  1032f4:	7e 12                	jle    103308 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1032f6:	83 ec 08             	sub    $0x8,%esp
  1032f9:	ff 75 0c             	pushl  0xc(%ebp)
  1032fc:	6a 3f                	push   $0x3f
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	ff d0                	call   *%eax
  103303:	83 c4 10             	add    $0x10,%esp
  103306:	eb 0f                	jmp    103317 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103308:	83 ec 08             	sub    $0x8,%esp
  10330b:	ff 75 0c             	pushl  0xc(%ebp)
  10330e:	53                   	push   %ebx
  10330f:	8b 45 08             	mov    0x8(%ebp),%eax
  103312:	ff d0                	call   *%eax
  103314:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103317:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10331b:	89 f0                	mov    %esi,%eax
  10331d:	8d 70 01             	lea    0x1(%eax),%esi
  103320:	0f b6 00             	movzbl (%eax),%eax
  103323:	0f be d8             	movsbl %al,%ebx
  103326:	85 db                	test   %ebx,%ebx
  103328:	74 26                	je     103350 <vprintfmt+0x242>
  10332a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10332e:	78 b6                	js     1032e6 <vprintfmt+0x1d8>
  103330:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103334:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103338:	79 ac                	jns    1032e6 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  10333a:	eb 14                	jmp    103350 <vprintfmt+0x242>
                putch(' ', putdat);
  10333c:	83 ec 08             	sub    $0x8,%esp
  10333f:	ff 75 0c             	pushl  0xc(%ebp)
  103342:	6a 20                	push   $0x20
  103344:	8b 45 08             	mov    0x8(%ebp),%eax
  103347:	ff d0                	call   *%eax
  103349:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  10334c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103350:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103354:	7f e6                	jg     10333c <vprintfmt+0x22e>
            }
            break;
  103356:	e9 4e 01 00 00       	jmp    1034a9 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10335b:	83 ec 08             	sub    $0x8,%esp
  10335e:	ff 75 e0             	pushl  -0x20(%ebp)
  103361:	8d 45 14             	lea    0x14(%ebp),%eax
  103364:	50                   	push   %eax
  103365:	e8 39 fd ff ff       	call   1030a3 <getint>
  10336a:	83 c4 10             	add    $0x10,%esp
  10336d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103370:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103379:	85 d2                	test   %edx,%edx
  10337b:	79 23                	jns    1033a0 <vprintfmt+0x292>
                putch('-', putdat);
  10337d:	83 ec 08             	sub    $0x8,%esp
  103380:	ff 75 0c             	pushl  0xc(%ebp)
  103383:	6a 2d                	push   $0x2d
  103385:	8b 45 08             	mov    0x8(%ebp),%eax
  103388:	ff d0                	call   *%eax
  10338a:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10338d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103393:	f7 d8                	neg    %eax
  103395:	83 d2 00             	adc    $0x0,%edx
  103398:	f7 da                	neg    %edx
  10339a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10339d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1033a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033a7:	e9 9f 00 00 00       	jmp    10344b <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1033ac:	83 ec 08             	sub    $0x8,%esp
  1033af:	ff 75 e0             	pushl  -0x20(%ebp)
  1033b2:	8d 45 14             	lea    0x14(%ebp),%eax
  1033b5:	50                   	push   %eax
  1033b6:	e8 99 fc ff ff       	call   103054 <getuint>
  1033bb:	83 c4 10             	add    $0x10,%esp
  1033be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033cb:	eb 7e                	jmp    10344b <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033cd:	83 ec 08             	sub    $0x8,%esp
  1033d0:	ff 75 e0             	pushl  -0x20(%ebp)
  1033d3:	8d 45 14             	lea    0x14(%ebp),%eax
  1033d6:	50                   	push   %eax
  1033d7:	e8 78 fc ff ff       	call   103054 <getuint>
  1033dc:	83 c4 10             	add    $0x10,%esp
  1033df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033e5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1033ec:	eb 5d                	jmp    10344b <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1033ee:	83 ec 08             	sub    $0x8,%esp
  1033f1:	ff 75 0c             	pushl  0xc(%ebp)
  1033f4:	6a 30                	push   $0x30
  1033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f9:	ff d0                	call   *%eax
  1033fb:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1033fe:	83 ec 08             	sub    $0x8,%esp
  103401:	ff 75 0c             	pushl  0xc(%ebp)
  103404:	6a 78                	push   $0x78
  103406:	8b 45 08             	mov    0x8(%ebp),%eax
  103409:	ff d0                	call   *%eax
  10340b:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10340e:	8b 45 14             	mov    0x14(%ebp),%eax
  103411:	8d 50 04             	lea    0x4(%eax),%edx
  103414:	89 55 14             	mov    %edx,0x14(%ebp)
  103417:	8b 00                	mov    (%eax),%eax
  103419:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10341c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103423:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10342a:	eb 1f                	jmp    10344b <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10342c:	83 ec 08             	sub    $0x8,%esp
  10342f:	ff 75 e0             	pushl  -0x20(%ebp)
  103432:	8d 45 14             	lea    0x14(%ebp),%eax
  103435:	50                   	push   %eax
  103436:	e8 19 fc ff ff       	call   103054 <getuint>
  10343b:	83 c4 10             	add    $0x10,%esp
  10343e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103441:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103444:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10344b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10344f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103452:	83 ec 04             	sub    $0x4,%esp
  103455:	52                   	push   %edx
  103456:	ff 75 e8             	pushl  -0x18(%ebp)
  103459:	50                   	push   %eax
  10345a:	ff 75 f4             	pushl  -0xc(%ebp)
  10345d:	ff 75 f0             	pushl  -0x10(%ebp)
  103460:	ff 75 0c             	pushl  0xc(%ebp)
  103463:	ff 75 08             	pushl  0x8(%ebp)
  103466:	e8 f8 fa ff ff       	call   102f63 <printnum>
  10346b:	83 c4 20             	add    $0x20,%esp
            break;
  10346e:	eb 39                	jmp    1034a9 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103470:	83 ec 08             	sub    $0x8,%esp
  103473:	ff 75 0c             	pushl  0xc(%ebp)
  103476:	53                   	push   %ebx
  103477:	8b 45 08             	mov    0x8(%ebp),%eax
  10347a:	ff d0                	call   *%eax
  10347c:	83 c4 10             	add    $0x10,%esp
            break;
  10347f:	eb 28                	jmp    1034a9 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103481:	83 ec 08             	sub    $0x8,%esp
  103484:	ff 75 0c             	pushl  0xc(%ebp)
  103487:	6a 25                	push   $0x25
  103489:	8b 45 08             	mov    0x8(%ebp),%eax
  10348c:	ff d0                	call   *%eax
  10348e:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103491:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103495:	eb 04                	jmp    10349b <vprintfmt+0x38d>
  103497:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10349b:	8b 45 10             	mov    0x10(%ebp),%eax
  10349e:	83 e8 01             	sub    $0x1,%eax
  1034a1:	0f b6 00             	movzbl (%eax),%eax
  1034a4:	3c 25                	cmp    $0x25,%al
  1034a6:	75 ef                	jne    103497 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1034a8:	90                   	nop
    while (1) {
  1034a9:	e9 68 fc ff ff       	jmp    103116 <vprintfmt+0x8>
                return;
  1034ae:	90                   	nop
        }
    }
}
  1034af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1034b2:	5b                   	pop    %ebx
  1034b3:	5e                   	pop    %esi
  1034b4:	5d                   	pop    %ebp
  1034b5:	c3                   	ret    

001034b6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034b6:	55                   	push   %ebp
  1034b7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bc:	8b 40 08             	mov    0x8(%eax),%eax
  1034bf:	8d 50 01             	lea    0x1(%eax),%edx
  1034c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034cb:	8b 10                	mov    (%eax),%edx
  1034cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d0:	8b 40 04             	mov    0x4(%eax),%eax
  1034d3:	39 c2                	cmp    %eax,%edx
  1034d5:	73 12                	jae    1034e9 <sprintputch+0x33>
        *b->buf ++ = ch;
  1034d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034da:	8b 00                	mov    (%eax),%eax
  1034dc:	8d 48 01             	lea    0x1(%eax),%ecx
  1034df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034e2:	89 0a                	mov    %ecx,(%edx)
  1034e4:	8b 55 08             	mov    0x8(%ebp),%edx
  1034e7:	88 10                	mov    %dl,(%eax)
    }
}
  1034e9:	90                   	nop
  1034ea:	5d                   	pop    %ebp
  1034eb:	c3                   	ret    

001034ec <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1034ec:	55                   	push   %ebp
  1034ed:	89 e5                	mov    %esp,%ebp
  1034ef:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1034f2:	8d 45 14             	lea    0x14(%ebp),%eax
  1034f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1034f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034fb:	50                   	push   %eax
  1034fc:	ff 75 10             	pushl  0x10(%ebp)
  1034ff:	ff 75 0c             	pushl  0xc(%ebp)
  103502:	ff 75 08             	pushl  0x8(%ebp)
  103505:	e8 0b 00 00 00       	call   103515 <vsnprintf>
  10350a:	83 c4 10             	add    $0x10,%esp
  10350d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103510:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103513:	c9                   	leave  
  103514:	c3                   	ret    

00103515 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103515:	55                   	push   %ebp
  103516:	89 e5                	mov    %esp,%ebp
  103518:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10351b:	8b 45 08             	mov    0x8(%ebp),%eax
  10351e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103521:	8b 45 0c             	mov    0xc(%ebp),%eax
  103524:	8d 50 ff             	lea    -0x1(%eax),%edx
  103527:	8b 45 08             	mov    0x8(%ebp),%eax
  10352a:	01 d0                	add    %edx,%eax
  10352c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10352f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10353a:	74 0a                	je     103546 <vsnprintf+0x31>
  10353c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10353f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103542:	39 c2                	cmp    %eax,%edx
  103544:	76 07                	jbe    10354d <vsnprintf+0x38>
        return -E_INVAL;
  103546:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10354b:	eb 20                	jmp    10356d <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10354d:	ff 75 14             	pushl  0x14(%ebp)
  103550:	ff 75 10             	pushl  0x10(%ebp)
  103553:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103556:	50                   	push   %eax
  103557:	68 b6 34 10 00       	push   $0x1034b6
  10355c:	e8 ad fb ff ff       	call   10310e <vprintfmt>
  103561:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103567:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10356d:	c9                   	leave  
  10356e:	c3                   	ret    
