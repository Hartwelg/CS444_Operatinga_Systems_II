
obj/user/pingpongs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 16 01 00 00       	call   800147 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 dd 11 00 00       	call   80121e <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 5e                	je     8000a6 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800048:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80004e:	e8 f2 0b 00 00       	call   800c45 <sys_getenvid>
  800053:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005b:	c7 04 24 c0 16 80 00 	movl   $0x8016c0,(%esp)
  800062:	e8 df 01 00 00       	call   800246 <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800067:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006a:	e8 d6 0b 00 00       	call   800c45 <sys_getenvid>
  80006f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 da 16 80 00 	movl   $0x8016da,(%esp)
  80007e:	e8 c3 01 00 00       	call   800246 <cprintf>
		ipc_send(who, 0, 0, 0);
  800083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008a:	00 
  80008b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009a:	00 
  80009b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009e:	89 04 24             	mov    %eax,(%esp)
  8000a1:	e8 02 12 00 00       	call   8012a8 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b5:	00 
  8000b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 7f 11 00 00       	call   801240 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c1:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c7:	8b 7b 48             	mov    0x48(%ebx),%edi
  8000ca:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000cd:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000d5:	e8 6b 0b 00 00       	call   800c45 <sys_getenvid>
  8000da:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8000de:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f1:	c7 04 24 f0 16 80 00 	movl   $0x8016f0,(%esp)
  8000f8:	e8 49 01 00 00       	call   800246 <cprintf>
		if (val == 10)
  8000fd:	a1 04 20 80 00       	mov    0x802004,%eax
  800102:	83 f8 0a             	cmp    $0xa,%eax
  800105:	74 38                	je     80013f <umain+0x10c>
			return;
		++val;
  800107:	83 c0 01             	add    $0x1,%eax
  80010a:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80010f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800116:	00 
  800117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800126:	00 
  800127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012a:	89 04 24             	mov    %eax,(%esp)
  80012d:	e8 76 11 00 00       	call   8012a8 <ipc_send>
		if (val == 10)
  800132:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  800139:	0f 85 67 ff ff ff    	jne    8000a6 <umain+0x73>
			return;
	}

}
  80013f:	83 c4 3c             	add    $0x3c,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
  80014c:	83 ec 10             	sub    $0x10,%esp
  80014f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800152:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800155:	e8 eb 0a 00 00       	call   800c45 <sys_getenvid>
  80015a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800162:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800167:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016c:	85 db                	test   %ebx,%ebx
  80016e:	7e 07                	jle    800177 <libmain+0x30>
		binaryname = argv[0];
  800170:	8b 06                	mov    (%esi),%eax
  800172:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800177:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017b:	89 1c 24             	mov    %ebx,(%esp)
  80017e:	e8 b0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800183:	e8 07 00 00 00       	call   80018f <exit>
}
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    

0080018f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 18             	sub    $0x18,%esp
	sys_env_destroy(0);
  800195:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80019c:	e8 52 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 14             	sub    $0x14,%esp
  8001aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ad:	8b 13                	mov    (%ebx),%edx
  8001af:	8d 42 01             	lea    0x1(%edx),%eax
  8001b2:	89 03                	mov    %eax,(%ebx)
  8001b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c0:	75 19                	jne    8001db <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001c9:	00 
  8001ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 e1 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001df:	83 c4 14             	add    $0x14,%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f5:	00 00 00 
	b.cnt = 0;
  8001f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
  800205:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800209:	8b 45 08             	mov    0x8(%ebp),%eax
  80020c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800210:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021a:	c7 04 24 a3 01 80 00 	movl   $0x8001a3,(%esp)
  800221:	e8 a8 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800226:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80022c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800230:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800236:	89 04 24             	mov    %eax,(%esp)
  800239:	e8 78 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  80023e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80024c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80024f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800253:	8b 45 08             	mov    0x8(%ebp),%eax
  800256:	89 04 24             	mov    %eax,(%esp)
  800259:	e8 87 ff ff ff       	call   8001e5 <vcprintf>
	va_end(ap);

	return cnt;
}
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80028d:	39 d9                	cmp    %ebx,%ecx
  80028f:	72 05                	jb     800296 <printnum+0x36>
  800291:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800299:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80029d:	83 ee 01             	sub    $0x1,%esi
  8002a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002b0:	89 c3                	mov    %eax,%ebx
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	e8 5c 11 00 00       	call   801430 <__udivdi3>
  8002d4:	89 d9                	mov    %ebx,%ecx
  8002d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e5:	89 fa                	mov    %edi,%edx
  8002e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ea:	e8 71 ff ff ff       	call   800260 <printnum>
  8002ef:	eb 1b                	jmp    80030c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	ff d3                	call   *%ebx
  8002fd:	eb 03                	jmp    800302 <printnum+0xa2>
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while (--width > 0)
  800302:	83 ee 01             	sub    $0x1,%esi
  800305:	85 f6                	test   %esi,%esi
  800307:	7f e8                	jg     8002f1 <printnum+0x91>
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800310:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80031a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 2c 12 00 00       	call   801560 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 20 17 80 00 	movsbl 0x801720(%eax),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800345:	ff d0                	call   *%eax
}
  800347:	83 c4 3c             	add    $0x3c,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800352:	83 fa 01             	cmp    $0x1,%edx
  800355:	7e 0e                	jle    800365 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800357:	8b 10                	mov    (%eax),%edx
  800359:	8d 4a 08             	lea    0x8(%edx),%ecx
  80035c:	89 08                	mov    %ecx,(%eax)
  80035e:	8b 02                	mov    (%edx),%eax
  800360:	8b 52 04             	mov    0x4(%edx),%edx
  800363:	eb 22                	jmp    800387 <getuint+0x38>
	else if (lflag)
  800365:	85 d2                	test   %edx,%edx
  800367:	74 10                	je     800379 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 02                	mov    (%edx),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
  800377:	eb 0e                	jmp    800387 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800393:	8b 10                	mov    (%eax),%edx
  800395:	3b 50 04             	cmp    0x4(%eax),%edx
  800398:	73 0a                	jae    8003a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039d:	89 08                	mov    %ecx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	88 02                	mov    %al,(%edx)
}
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <printfmt>:
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 18             	sub    $0x18,%esp
	va_start(ap, fmt);
  8003ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 02 00 00 00       	call   8003ce <vprintfmt>
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 3c             	sub    $0x3c,%esp
  8003d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003dd:	eb 14                	jmp    8003f3 <vprintfmt+0x25>
			if (ch == '\0')
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	0f 84 b3 03 00 00    	je     80079a <vprintfmt+0x3cc>
			putch(ch, putdat);
  8003e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	ff 55 08             	call   *0x8(%ebp)
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f1:	89 f3                	mov    %esi,%ebx
  8003f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f6:	0f b6 03             	movzbl (%ebx),%eax
  8003f9:	83 f8 25             	cmp    $0x25,%eax
  8003fc:	75 e1                	jne    8003df <vprintfmt+0x11>
  8003fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800410:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	eb 1d                	jmp    80043b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	89 de                	mov    %ebx,%esi
			padc = '-';
  800420:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800424:	eb 15                	jmp    80043b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  800426:	89 de                	mov    %ebx,%esi
			padc = '0';
  800428:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80042c:	eb 0d                	jmp    80043b <vprintfmt+0x6d>
				width = precision, precision = -1;
  80042e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800431:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800434:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80043e:	0f b6 0e             	movzbl (%esi),%ecx
  800441:	0f b6 c1             	movzbl %cl,%eax
  800444:	83 e9 23             	sub    $0x23,%ecx
  800447:	80 f9 55             	cmp    $0x55,%cl
  80044a:	0f 87 2a 03 00 00    	ja     80077a <vprintfmt+0x3ac>
  800450:	0f b6 c9             	movzbl %cl,%ecx
  800453:	ff 24 8d e0 17 80 00 	jmp    *0x8017e0(,%ecx,4)
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
				precision = precision * 10 + ch - '0';
  800461:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800464:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800468:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80046b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80046e:	83 fb 09             	cmp    $0x9,%ebx
  800471:	77 36                	ja     8004a9 <vprintfmt+0xdb>
			for (precision = 0; ; ++fmt) {
  800473:	83 c6 01             	add    $0x1,%esi
			}
  800476:	eb e9                	jmp    800461 <vprintfmt+0x93>
			precision = va_arg(ap, int);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 48 04             	lea    0x4(%eax),%ecx
  80047e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			goto process_precision;
  800488:	eb 22                	jmp    8004ac <vprintfmt+0xde>
  80048a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 00 00 00 00       	mov    $0x0,%eax
  800494:	0f 49 c1             	cmovns %ecx,%eax
  800497:	89 45 dc             	mov    %eax,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	eb 9d                	jmp    80043b <vprintfmt+0x6d>
  80049e:	89 de                	mov    %ebx,%esi
			altflag = 1;
  8004a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004a7:	eb 92                	jmp    80043b <vprintfmt+0x6d>
  8004a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
			if (width < 0)
  8004ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004b0:	79 89                	jns    80043b <vprintfmt+0x6d>
  8004b2:	e9 77 ff ff ff       	jmp    80042e <vprintfmt+0x60>
			lflag++;
  8004b7:	83 c2 01             	add    $0x1,%edx
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
			goto reswitch;
  8004bc:	e9 7a ff ff ff       	jmp    80043b <vprintfmt+0x6d>
			putch(va_arg(ap, int), putdat);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 50 04             	lea    0x4(%eax),%edx
  8004c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	89 04 24             	mov    %eax,(%esp)
  8004d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d6:	e9 18 ff ff ff       	jmp    8003f3 <vprintfmt+0x25>
			err = va_arg(ap, int);
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 08             	cmp    $0x8,%eax
  8004ee:	7f 0b                	jg     8004fb <vprintfmt+0x12d>
  8004f0:	8b 14 85 40 19 80 00 	mov    0x801940(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 38 17 80 	movl   $0x801738,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 41 17 80 	movl   $0x801741,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 70 fe ff ff       	call   8003a6 <printfmt>
  800536:	e9 b8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800541:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80054f:	85 f6                	test   %esi,%esi
  800551:	b8 31 17 80 00       	mov    $0x801731,%eax
  800556:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800559:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80055d:	0f 84 97 00 00 00    	je     8005fa <vprintfmt+0x22c>
  800563:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800567:	0f 8e 9b 00 00 00    	jle    800608 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800571:	89 34 24             	mov    %esi,(%esp)
  800574:	e8 cf 02 00 00       	call   800848 <strnlen>
  800579:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800581:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800585:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800588:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	eb 0f                	jmp    8005a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800595:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059c:	89 04 24             	mov    %eax,(%esp)
  80059f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	85 db                	test   %ebx,%ebx
  8005a6:	7f ed                	jg     800595 <vprintfmt+0x1c7>
  8005a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c2             	cmovns %edx,%eax
  8005b8:	29 c2                	sub    %eax,%edx
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	89 d7                	mov    %edx,%edi
  8005bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c2:	eb 50                	jmp    800614 <vprintfmt+0x246>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c8:	74 1e                	je     8005e8 <vprintfmt+0x21a>
  8005ca:	0f be d2             	movsbl %dl,%edx
  8005cd:	83 ea 20             	sub    $0x20,%edx
  8005d0:	83 fa 5e             	cmp    $0x5e,%edx
  8005d3:	76 13                	jbe    8005e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
  8005e6:	eb 0d                	jmp    8005f5 <vprintfmt+0x227>
					putch(ch, putdat);
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f5:	83 ef 01             	sub    $0x1,%edi
  8005f8:	eb 1a                	jmp    800614 <vprintfmt+0x246>
  8005fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800600:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800603:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800606:	eb 0c                	jmp    800614 <vprintfmt+0x246>
  800608:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800614:	83 c6 01             	add    $0x1,%esi
  800617:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80061b:	0f be c2             	movsbl %dl,%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	74 27                	je     800649 <vprintfmt+0x27b>
  800622:	85 db                	test   %ebx,%ebx
  800624:	78 9e                	js     8005c4 <vprintfmt+0x1f6>
  800626:	83 eb 01             	sub    $0x1,%ebx
  800629:	79 99                	jns    8005c4 <vprintfmt+0x1f6>
  80062b:	89 f8                	mov    %edi,%eax
  80062d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800630:	8b 75 08             	mov    0x8(%ebp),%esi
  800633:	89 c3                	mov    %eax,%ebx
  800635:	eb 1a                	jmp    800651 <vprintfmt+0x283>
				putch(' ', putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800642:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	eb 08                	jmp    800651 <vprintfmt+0x283>
  800649:	89 fb                	mov    %edi,%ebx
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800651:	85 db                	test   %ebx,%ebx
  800653:	7f e2                	jg     800637 <vprintfmt+0x269>
  800655:	89 75 08             	mov    %esi,0x8(%ebp)
  800658:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80065b:	e9 93 fd ff ff       	jmp    8003f3 <vprintfmt+0x25>
	if (lflag >= 2)
  800660:	83 fa 01             	cmp    $0x1,%edx
  800663:	7e 16                	jle    80067b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 50 08             	lea    0x8(%eax),%edx
  80066b:	89 55 14             	mov    %edx,0x14(%ebp)
  80066e:	8b 50 04             	mov    0x4(%eax),%edx
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800676:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800679:	eb 32                	jmp    8006ad <vprintfmt+0x2df>
	else if (lflag)
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 18                	je     800697 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80068d:	89 f0                	mov    %esi,%eax
  80068f:	c1 f8 1f             	sar    $0x1f,%eax
  800692:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800695:	eb 16                	jmp    8006ad <vprintfmt+0x2df>
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 50 04             	lea    0x4(%eax),%edx
  80069d:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a0:	8b 30                	mov    (%eax),%esi
  8006a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	c1 f8 1f             	sar    $0x1f,%eax
  8006aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			num = getint(&ap, lflag);
  8006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			base = 10;
  8006b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			if ((long long) num < 0) {
  8006b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bc:	0f 89 80 00 00 00    	jns    800742 <vprintfmt+0x374>
				putch('-', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d6:	f7 d8                	neg    %eax
  8006d8:	83 d2 00             	adc    $0x0,%edx
  8006db:	f7 da                	neg    %edx
			base = 10;
  8006dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e2:	eb 5e                	jmp    800742 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e7:	e8 63 fc ff ff       	call   80034f <getuint>
			base = 10;
  8006ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f1:	eb 4f                	jmp    800742 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 54 fc ff ff       	call   80034f <getuint>
			base = 8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	eb 40                	jmp    800742 <vprintfmt+0x374>
			putch('0', putdat);
  800702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800706:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
				(uintptr_t) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 50 04             	lea    0x4(%eax),%edx
  800724:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
			base = 16;
  80072e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800733:	eb 0d                	jmp    800742 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
  800738:	e8 12 fc ff ff       	call   80034f <getuint>
			base = 16;
  80073d:	b9 10 00 00 00       	mov    $0x10,%ecx
			printnum(putch, putdat, num, base, width, padc);
  800742:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800746:	89 74 24 10          	mov    %esi,0x10(%esp)
  80074a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80074d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800751:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075c:	89 fa                	mov    %edi,%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	e8 fa fa ff ff       	call   800260 <printnum>
			break;
  800766:	e9 88 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
			putch(ch, putdat);
  80076b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			break;
  800775:	e9 79 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
			putch('%', putdat);
  80077a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800785:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	89 f3                	mov    %esi,%ebx
  80078a:	eb 03                	jmp    80078f <vprintfmt+0x3c1>
  80078c:	83 eb 01             	sub    $0x1,%ebx
  80078f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800793:	75 f7                	jne    80078c <vprintfmt+0x3be>
  800795:	e9 59 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
}
  80079a:	83 c4 3c             	add    $0x3c,%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 28             	sub    $0x28,%esp
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 30                	je     8007f3 <vsnprintf+0x51>
  8007c3:	85 d2                	test   %edx,%edx
  8007c5:	7e 2c                	jle    8007f3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	c7 04 24 89 03 80 00 	movl   $0x800389,(%esp)
  8007e3:	e8 e6 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	eb 05                	jmp    8007f8 <vsnprintf+0x56>
		return -E_INVAL;
  8007f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 44 24 04          	mov    %eax,0x4(%esp)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	e8 82 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    
  800822:	66 90                	xchg   %ax,%ax
  800824:	66 90                	xchg   %ax,%ax
  800826:	66 90                	xchg   %ax,%ax
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 03                	jmp    80085b <strnlen+0x13>
		n++;
  800858:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1d>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f3                	jne    800858 <strnlen+0x10>
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	84 db                	test   %bl,%bl
  800882:	75 ef                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800891:	89 1c 24             	mov    %ebx,(%esp)
  800894:	e8 97 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	89 04 24             	mov    %eax,(%esp)
  8008a5:	e8 bd ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f2                	mov    %esi,%edx
  8008c4:	eb 0f                	jmp    8008d5 <strncpy+0x23>
		*dst++ = *src;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008d5:	39 da                	cmp    %ebx,%edx
  8008d7:	75 ed                	jne    8008c6 <strncpy+0x14>
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	56                   	push   %esi
  8008e3:	53                   	push   %ebx
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 0b                	jne    800902 <strlcpy+0x23>
  8008f7:	eb 1d                	jmp    800916 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 0b                	je     800911 <strlcpy+0x32>
  800906:	0f b6 0a             	movzbl (%edx),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1a>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	eb 02                	jmp    800913 <strlcpy+0x34>
  800911:	89 c2                	mov    %eax,%edx
		*dst = '\0';
  800913:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800916:	29 f0                	sub    %esi,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800925:	eb 06                	jmp    80092d <strcmp+0x11>
		p++, q++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 04                	je     800938 <strcmp+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	74 ef                	je     800927 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x17>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 15                	je     800972 <strncmp+0x30>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x26>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
  800970:	eb 05                	jmp    800977 <strncmp+0x35>
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800984:	eb 07                	jmp    80098d <strchr+0x13>
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 0f                	je     800999 <strchr+0x1f>
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 f2                	jne    800986 <strchr+0xc>
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strfind+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0a                	je     8009b5 <strfind+0x1a>
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strfind+0xc>
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 36                	je     8009fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cd:	75 28                	jne    8009f7 <memset+0x40>
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 23                	jne    8009f7 <memset+0x40>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 18             	shl    $0x18,%esi
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 10             	shl    $0x10,%eax
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ef:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x46>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 79 ff ff ff       	call   800a04 <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9d:	eb 1a                	jmp    800ab9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a9f:	0f b6 02             	movzbl (%edx),%eax
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	38 d8                	cmp    %bl,%al
  800aa7:	74 0a                	je     800ab3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c0             	movzbl %al,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 0f                	jmp    800ac2 <memcmp+0x35>
		s1++, s2++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
	while (n-- > 0) {
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	75 e2                	jne    800a9f <memcmp+0x12>
	}

	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	eb 07                	jmp    800add <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 07                	je     800ae1 <memfind+0x1b>
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	72 f5                	jb     800ad6 <memfind+0x10>
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aef:	eb 03                	jmp    800af4 <strtol+0x11>
		s++;
  800af1:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800af4:	0f b6 0a             	movzbl (%edx),%ecx
  800af7:	80 f9 09             	cmp    $0x9,%cl
  800afa:	74 f5                	je     800af1 <strtol+0xe>
  800afc:	80 f9 20             	cmp    $0x20,%cl
  800aff:	74 f0                	je     800af1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b01:	80 f9 2b             	cmp    $0x2b,%cl
  800b04:	75 0a                	jne    800b10 <strtol+0x2d>
		s++;
  800b06:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb 11                	jmp    800b21 <strtol+0x3e>
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
	else if (*s == '-')
  800b15:	80 f9 2d             	cmp    $0x2d,%cl
  800b18:	75 07                	jne    800b21 <strtol+0x3e>
		s++, neg = 1;
  800b1a:	8d 52 01             	lea    0x1(%edx),%edx
  800b1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b26:	75 15                	jne    800b3d <strtol+0x5a>
  800b28:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2b:	75 10                	jne    800b3d <strtol+0x5a>
  800b2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b31:	75 0a                	jne    800b3d <strtol+0x5a>
		s += 2, base = 16;
  800b33:	83 c2 02             	add    $0x2,%edx
  800b36:	b8 10 00 00 00       	mov    $0x10,%eax
  800b3b:	eb 10                	jmp    800b4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 0c                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	b0 0a                	mov    $0xa,%al
	else if (base == 0 && s[0] == '0')
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 05                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	b0 08                	mov    $0x8,%al
		base = 10;
  800b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b55:	0f b6 0a             	movzbl (%edx),%ecx
  800b58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	77 08                	ja     800b69 <strtol+0x86>
			dig = *s - '0';
  800b61:	0f be c9             	movsbl %cl,%ecx
  800b64:	83 e9 30             	sub    $0x30,%ecx
  800b67:	eb 20                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b6c:	89 f0                	mov    %esi,%eax
  800b6e:	3c 19                	cmp    $0x19,%al
  800b70:	77 08                	ja     800b7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b72:	0f be c9             	movsbl %cl,%ecx
  800b75:	83 e9 57             	sub    $0x57,%ecx
  800b78:	eb 0f                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	3c 19                	cmp    $0x19,%al
  800b81:	77 16                	ja     800b99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b83:	0f be c9             	movsbl %cl,%ecx
  800b86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b8c:	7d 0f                	jge    800b9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b97:	eb bc                	jmp    800b55 <strtol+0x72>
  800b99:	89 d8                	mov    %ebx,%eax
  800b9b:	eb 02                	jmp    800b9f <strtol+0xbc>
  800b9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 05                	je     800baa <strtol+0xc7>
		*endptr = (char *) s;
  800ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800baa:	f7 d8                	neg    %eax
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 28                	jle    800c3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c20:	00 
  800c21:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800c38:	e8 0a 07 00 00       	call   801347 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3d:	83 c4 2c             	add    $0x2c,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 02 00 00 00       	mov    $0x2,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_yield>:

void
sys_yield(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800c8c:	be 00 00 00 00       	mov    $0x0,%esi
  800c91:	b8 04 00 00 00       	mov    $0x4,%eax
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9f:	89 f7                	mov    %esi,%edi
  800ca1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7e 28                	jle    800ccf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800cca:	e8 78 06 00 00       	call   801347 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccf:	83 c4 2c             	add    $0x2c,%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800ce0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7e 28                	jle    800d22 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d05:	00 
  800d06:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800d1d:	e8 25 06 00 00       	call   801347 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d22:	83 c4 2c             	add    $0x2c,%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7e 28                	jle    800d75 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d51:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d58:	00 
  800d59:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800d70:	e8 d2 05 00 00       	call   801347 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d75:	83 c4 2c             	add    $0x2c,%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7e 28                	jle    800dc8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dab:	00 
  800dac:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800dc3:	e8 7f 05 00 00       	call   801347 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc8:	83 c4 2c             	add    $0x2c,%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 28                	jle    800e1b <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dfe:	00 
  800dff:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800e16:	e8 2c 05 00 00       	call   801347 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1b:	83 c4 2c             	add    $0x2c,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e29:	be 00 00 00 00       	mov    $0x0,%esi
  800e2e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800e4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e54:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 cb                	mov    %ecx,%ebx
  800e5e:	89 cf                	mov    %ecx,%edi
  800e60:	89 ce                	mov    %ecx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7e 28                	jle    800e90 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6c:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800e73:	00 
  800e74:	c7 44 24 08 64 19 80 	movl   $0x801964,0x8(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e83:	00 
  800e84:	c7 04 24 81 19 80 00 	movl   $0x801981,(%esp)
  800e8b:	e8 b7 04 00 00       	call   801347 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e90:	83 c4 2c             	add    $0x2c,%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 24             	sub    $0x24,%esp
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ea2:	8b 10                	mov    (%eax),%edx
	uint32_t err = utf->utf_err;
  800ea4:	8b 40 04             	mov    0x4(%eax),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800ea7:	a8 02                	test   $0x2,%al
  800ea9:	74 11                	je     800ebc <pgfault+0x24>
  800eab:	89 d1                	mov    %edx,%ecx
  800ead:	c1 e9 0c             	shr    $0xc,%ecx
  800eb0:	8b 0c 8d 00 00 40 ef 	mov    -0x10c00000(,%ecx,4),%ecx
  800eb7:	f6 c5 08             	test   $0x8,%ch
  800eba:	75 20                	jne    800edc <pgfault+0x44>
	{
		panic("pgfault: %e", err);
  800ebc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ec0:	c7 44 24 08 8f 19 80 	movl   $0x80198f,0x8(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800ecf:	00 
  800ed0:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  800ed7:	e8 6b 04 00 00       	call   801347 <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800edc:	89 d3                	mov    %edx,%ebx
  800ede:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (sys_page_alloc(0, PFTEMP, PTE_W|PTE_U|PTE_P) < 0)
  800ee4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800eeb:	00 
  800eec:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800ef3:	00 
  800ef4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800efb:	e8 83 fd ff ff       	call   800c83 <sys_page_alloc>
  800f00:	85 c0                	test   %eax,%eax
  800f02:	79 1c                	jns    800f20 <pgfault+0x88>
	{
		panic("pgfault: sys_page_alloc failure");
  800f04:	c7 44 24 08 28 1a 80 	movl   $0x801a28,0x8(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  800f13:	00 
  800f14:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  800f1b:	e8 27 04 00 00       	call   801347 <_panic>
	}
	memcpy(PFTEMP, addr, PGSIZE);
  800f20:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800f27:	00 
  800f28:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f2c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  800f33:	e8 34 fb ff ff       	call   800a6c <memcpy>
	if(sys_page_map(0, PFTEMP, 0, addr, PTE_W|PTE_U|PTE_P) < 0)
  800f38:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  800f3f:	00 
  800f40:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f5b:	e8 77 fd ff ff       	call   800cd7 <sys_page_map>
  800f60:	85 c0                	test   %eax,%eax
  800f62:	79 1c                	jns    800f80 <pgfault+0xe8>
	{
		panic("pgfault: sys_page_map failure");
  800f64:	c7 44 24 08 a6 19 80 	movl   $0x8019a6,0x8(%esp)
  800f6b:	00 
  800f6c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  800f73:	00 
  800f74:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  800f7b:	e8 c7 03 00 00       	call   801347 <_panic>
	}
	if(sys_page_unmap(0, PFTEMP) < 0)
  800f80:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800f87:	00 
  800f88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f8f:	e8 96 fd ff ff       	call   800d2a <sys_page_unmap>
  800f94:	85 c0                	test   %eax,%eax
  800f96:	79 1c                	jns    800fb4 <pgfault+0x11c>
	{
		panic("pgfault: sys_page_unmap failure");
  800f98:	c7 44 24 08 48 1a 80 	movl   $0x801a48,0x8(%esp)
  800f9f:	00 
  800fa0:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  800fa7:	00 
  800fa8:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  800faf:	e8 93 03 00 00       	call   801347 <_panic>
	}
	return;
	// panic("pgfault not implemented");
}
  800fb4:	83 c4 24             	add    $0x24,%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t i, j, pn, r;
	extern volatile pte_t uvpt[];
	extern volatile pde_t uvpd[];
	extern char end[];

	if (!thisenv->env_pgfault_upcall)
  800fc3:	a1 08 20 80 00       	mov    0x802008,%eax
  800fc8:	8b 40 64             	mov    0x64(%eax),%eax
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	75 0c                	jne    800fdb <fork+0x21>
	{
		set_pgfault_handler(pgfault);
  800fcf:	c7 04 24 98 0e 80 00 	movl   $0x800e98,(%esp)
  800fd6:	e8 c2 03 00 00       	call   80139d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fdb:	b8 07 00 00 00       	mov    $0x7,%eax
  800fe0:	cd 30                	int    $0x30
  800fe2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	}
		
	environID = sys_exofork();

	if (environID < 0)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	79 20                	jns    80100c <fork+0x52>
	{
		panic("sys_exofork: %e", environID);
  800fec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ff0:	c7 44 24 08 c4 19 80 	movl   $0x8019c4,0x8(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  800fff:	00 
  801000:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  801007:	e8 3b 03 00 00       	call   801347 <_panic>
	}
	else if (environID == 0)
  80100c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801013:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801017:	0f 85 e4 01 00 00    	jne    801201 <fork+0x247>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80101d:	e8 23 fc ff ff       	call   800c45 <sys_getenvid>
  801022:	25 ff 03 00 00       	and    $0x3ff,%eax
  801027:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80102a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80102f:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
  801039:	e9 d8 01 00 00       	jmp    801216 <fork+0x25c>
  80103e:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
	for (i = 0; i < NPDENTRIES; i++)
	{
		for (j = 0; j < NPTENTRIES; j++)
		{
			pn = i * NPDENTRIES + j;
			if (pn * PGSIZE < UTOP && uvpd[i] && uvpt[pn] && (pn * PGSIZE != UXSTACKTOP - PGSIZE))
  801041:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
  801047:	0f 87 f3 00 00 00    	ja     801140 <fork+0x186>
  80104d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801050:	8b 14 8d 00 d0 7b ef 	mov    -0x10843000(,%ecx,4),%edx
  801057:	85 d2                	test   %edx,%edx
  801059:	0f 84 e1 00 00 00    	je     801140 <fork+0x186>
  80105f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801066:	85 d2                	test   %edx,%edx
  801068:	0f 84 d2 00 00 00    	je     801140 <fork+0x186>
  80106e:	81 fe 00 f0 bf ee    	cmp    $0xeebff000,%esi
  801074:	0f 84 c6 00 00 00    	je     801140 <fork+0x186>
	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  80107a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801081:	f6 c2 02             	test   $0x2,%dl
  801084:	75 10                	jne    801096 <fork+0xdc>
  801086:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108d:	f6 c4 08             	test   $0x8,%ah
  801090:	0f 84 87 00 00 00    	je     80111d <fork+0x163>
		if (sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0)
  801096:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80109d:	00 
  80109e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b4:	e8 1e fc ff ff       	call   800cd7 <sys_page_map>
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	79 1c                	jns    8010d9 <fork+0x11f>
			panic("duppage: sys_page_map failure");
  8010bd:	c7 44 24 08 d4 19 80 	movl   $0x8019d4,0x8(%esp)
  8010c4:	00 
  8010c5:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8010cc:	00 
  8010cd:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  8010d4:	e8 6e 02 00 00       	call   801347 <_panic>
		if (sys_page_map(0, (void*)(pn * PGSIZE), 0, (void*)(pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0)
  8010d9:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8010e0:	00 
  8010e1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ec:	00 
  8010ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010f8:	e8 da fb ff ff       	call   800cd7 <sys_page_map>
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	79 3f                	jns    801140 <fork+0x186>
			panic("Duppage: sys_page_map failure");
  801101:	c7 44 24 08 f2 19 80 	movl   $0x8019f2,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  801118:	e8 2a 02 00 00       	call   801347 <_panic>
		sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_U | PTE_P);
  80111d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801124:	00 
  801125:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801130:	89 74 24 04          	mov    %esi,0x4(%esp)
  801134:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113b:	e8 97 fb ff ff       	call   800cd7 <sys_page_map>
		for (j = 0; j < NPTENTRIES; j++)
  801140:	83 c3 01             	add    $0x1,%ebx
  801143:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801149:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80114f:	0f 85 e9 fe ff ff    	jne    80103e <fork+0x84>
	for (i = 0; i < NPDENTRIES; i++)
  801155:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801159:	81 7d e4 00 04 00 00 	cmpl   $0x400,-0x1c(%ebp)
  801160:	0f 85 9b 00 00 00    	jne    801201 <fork+0x247>
				}
			}
		}
	}

	if ((r = sys_page_alloc(environID, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801166:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80116d:	00 
  80116e:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801175:	ee 
  801176:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801179:	89 3c 24             	mov    %edi,(%esp)
  80117c:	e8 02 fb ff ff       	call   800c83 <sys_page_alloc>
	{
		panic("sys_page_alloc: %e", r);
	}
	if ((r = sys_page_map(environID, (void*)(UXSTACKTOP - PGSIZE), 0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801181:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801188:	00 
  801189:	c7 44 24 0c 00 f0 7f 	movl   $0x7ff000,0xc(%esp)
  801190:	00 
  801191:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801198:	00 
  801199:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8011a0:	ee 
  8011a1:	89 3c 24             	mov    %edi,(%esp)
  8011a4:	e8 2e fb ff ff       	call   800cd7 <sys_page_map>
	{
		panic("sys_page_map: %e", r);
	}
	memmove(PFTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  8011a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011b0:	00 
  8011b1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8011b8:	ee 
  8011b9:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011c0:	e8 3f f8 ff ff       	call   800a04 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8011c5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011cc:	00 
  8011cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d4:	e8 51 fb ff ff       	call   800d2a <sys_page_unmap>
	{
		panic("sys_page_unmap: %e", r);
	}

	sys_env_set_pgfault_upcall(environID, thisenv->env_pgfault_upcall);
  8011d9:	a1 08 20 80 00       	mov    0x802008,%eax
  8011de:	8b 40 64             	mov    0x64(%eax),%eax
  8011e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e5:	89 3c 24             	mov    %edi,(%esp)
  8011e8:	e8 e3 fb ff ff       	call   800dd0 <sys_env_set_pgfault_upcall>
	sys_env_set_status(environID, ENV_RUNNABLE);
  8011ed:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8011f4:	00 
  8011f5:	89 3c 24             	mov    %edi,(%esp)
  8011f8:	e8 80 fb ff ff       	call   800d7d <sys_env_set_status>
	
	return environID;
  8011fd:	89 f8                	mov    %edi,%eax
  8011ff:	eb 15                	jmp    801216 <fork+0x25c>
  801201:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801204:	89 f7                	mov    %esi,%edi
  801206:	c1 e7 0a             	shl    $0xa,%edi
{
  801209:	c1 e6 16             	shl    $0x16,%esi
  80120c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801211:	e9 28 fe ff ff       	jmp    80103e <fork+0x84>
}
  801216:	83 c4 2c             	add    $0x2c,%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <sfork>:

// Challenge!
int
sfork(void)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801224:	c7 44 24 08 10 1a 80 	movl   $0x801a10,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 9b 19 80 00 	movl   $0x80199b,(%esp)
  80123b:	e8 07 01 00 00       	call   801347 <_panic>

00801240 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	56                   	push   %esi
  801244:	53                   	push   %ebx
  801245:	83 ec 10             	sub    $0x10,%esp
  801248:	8b 75 08             	mov    0x8(%ebp),%esi
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	void* vAddr = (void *) ULIM;
	if (pg != NULL)
  801251:	85 c0                	test   %eax,%eax
	void* vAddr = (void *) ULIM;
  801253:	ba 00 00 80 ef       	mov    $0xef800000,%edx
  801258:	0f 44 c2             	cmove  %edx,%eax
	{
		vAddr = pg;
	}

	int x;
	if ((x = sys_ipc_recv (vAddr)))
  80125b:	89 04 24             	mov    %eax,(%esp)
  80125e:	e8 e3 fb ff ff       	call   800e46 <sys_ipc_recv>
  801263:	85 c0                	test   %eax,%eax
  801265:	74 16                	je     80127d <ipc_recv+0x3d>
	{
		if (from_env_store != NULL)
  801267:	85 f6                	test   %esi,%esi
  801269:	74 06                	je     801271 <ipc_recv+0x31>
		{
			*from_env_store = 0;
  80126b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		}
		if (perm_store != NULL) 
  801271:	85 db                	test   %ebx,%ebx
  801273:	74 2c                	je     8012a1 <ipc_recv+0x61>
		{
			*perm_store = 0;
  801275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80127b:	eb 24                	jmp    8012a1 <ipc_recv+0x61>
		}
		return x;
	}

	if (from_env_store != NULL)
  80127d:	85 f6                	test   %esi,%esi
  80127f:	74 0a                	je     80128b <ipc_recv+0x4b>
	{
		*from_env_store = thisenv->env_ipc_from;
  801281:	a1 08 20 80 00       	mov    0x802008,%eax
  801286:	8b 40 74             	mov    0x74(%eax),%eax
  801289:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL)
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	74 0a                	je     801299 <ipc_recv+0x59>
	{
		*perm_store = thisenv->env_ipc_perm;
  80128f:	a1 08 20 80 00       	mov    0x802008,%eax
  801294:	8b 40 78             	mov    0x78(%eax),%eax
  801297:	89 03                	mov    %eax,(%ebx)
	}
	// panic("ipc_recv not implemented");
	return thisenv->env_ipc_value;
  801299:	a1 08 20 80 00       	mov    0x802008,%eax
  80129e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 1c             	sub    $0x1c,%esp
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8012ba:	85 db                	test   %ebx,%ebx
	{
		pg = (void *)-1;
  8012bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8012c1:	0f 44 d8             	cmove  %eax,%ebx
  8012c4:	eb 26                	jmp    8012ec <ipc_send+0x44>
	}

	int x;
	while ((x = sys_ipc_try_send(to_env, val, pg, perm)) != 0)
	{
		if (x != -E_IPC_NOT_RECV)
  8012c6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012c9:	74 1c                	je     8012e7 <ipc_send+0x3f>
		{
			panic("ipc_send");
  8012cb:	c7 44 24 08 68 1a 80 	movl   $0x801a68,0x8(%esp)
  8012d2:	00 
  8012d3:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8012da:	00 
  8012db:	c7 04 24 71 1a 80 00 	movl   $0x801a71,(%esp)
  8012e2:	e8 60 00 00 00       	call   801347 <_panic>
		}
		sys_yield();
  8012e7:	e8 78 f9 ff ff       	call   800c64 <sys_yield>
	while ((x = sys_ipc_try_send(to_env, val, pg, perm)) != 0)
  8012ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fb:	89 3c 24             	mov    %edi,(%esp)
  8012fe:	e8 20 fb ff ff       	call   800e23 <sys_ipc_try_send>
  801303:	85 c0                	test   %eax,%eax
  801305:	75 bf                	jne    8012c6 <ipc_send+0x1e>
	}
	// panic("ipc_send not implemented");
}
  801307:	83 c4 1c             	add    $0x1c,%esp
  80130a:	5b                   	pop    %ebx
  80130b:	5e                   	pop    %esi
  80130c:	5f                   	pop    %edi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801315:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80131a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80131d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801323:	8b 52 50             	mov    0x50(%edx),%edx
  801326:	39 ca                	cmp    %ecx,%edx
  801328:	75 0d                	jne    801337 <ipc_find_env+0x28>
			return envs[i].env_id;
  80132a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80132d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801332:	8b 40 40             	mov    0x40(%eax),%eax
  801335:	eb 0e                	jmp    801345 <ipc_find_env+0x36>
	for (i = 0; i < NENV; i++)
  801337:	83 c0 01             	add    $0x1,%eax
  80133a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80133f:	75 d9                	jne    80131a <ipc_find_env+0xb>
	return 0;
  801341:	66 b8 00 00          	mov    $0x0,%ax
}
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    

00801347 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	56                   	push   %esi
  80134b:	53                   	push   %ebx
  80134c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80134f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801352:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801358:	e8 e8 f8 ff ff       	call   800c45 <sys_getenvid>
  80135d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801360:	89 54 24 10          	mov    %edx,0x10(%esp)
  801364:	8b 55 08             	mov    0x8(%ebp),%edx
  801367:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80136b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80136f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801373:	c7 04 24 7c 1a 80 00 	movl   $0x801a7c,(%esp)
  80137a:	e8 c7 ee ff ff       	call   800246 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80137f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	89 04 24             	mov    %eax,(%esp)
  801389:	e8 57 ee ff ff       	call   8001e5 <vcprintf>
	cprintf("\n");
  80138e:	c7 04 24 d8 16 80 00 	movl   $0x8016d8,(%esp)
  801395:	e8 ac ee ff ff       	call   800246 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80139a:	cc                   	int3   
  80139b:	eb fd                	jmp    80139a <_panic+0x53>

0080139d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013a3:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8013aa:	75 50                	jne    8013fc <set_pgfault_handler+0x5f>
		// First time through!
		// LAB 4: Your code here.
		if ((r = sys_page_alloc (0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P) < 0))
  8013ac:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013bb:	ee 
  8013bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c3:	e8 bb f8 ff ff       	call   800c83 <sys_page_alloc>
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	79 1c                	jns    8013e8 <set_pgfault_handler+0x4b>
		{
			panic("set_pgfault_handler: bad sys_page_alloc");
  8013cc:	c7 44 24 08 a0 1a 80 	movl   $0x801aa0,0x8(%esp)
  8013d3:	00 
  8013d4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013db:	00 
  8013dc:	c7 04 24 c8 1a 80 00 	movl   $0x801ac8,(%esp)
  8013e3:	e8 5f ff ff ff       	call   801347 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8013e8:	c7 44 24 04 06 14 80 	movl   $0x801406,0x4(%esp)
  8013ef:	00 
  8013f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f7:	e8 d4 f9 ff ff       	call   800dd0 <sys_env_set_pgfault_upcall>
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801406:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801407:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  80140c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80140e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  801411:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl %esp, %ebx
  801415:	89 e3                	mov    %esp,%ebx
	movl 0x30(%esp), %esp
  801417:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %edi
  80141b:	57                   	push   %edi
	movl %ebx, %esp
  80141c:	89 dc                	mov    %ebx,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80141e:	83 c4 08             	add    $0x8,%esp
	popal
  801421:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $4, %esp
  801422:	83 c4 04             	add    $0x4,%esp
	sub $4, 0x4(%esp)
  801425:	83 6c 24 04 04       	subl   $0x4,0x4(%esp)
	popfl
  80142a:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80142b:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80142c:	c3                   	ret    
  80142d:	66 90                	xchg   %ax,%ax
  80142f:	90                   	nop

00801430 <__udivdi3>:
  801430:	55                   	push   %ebp
  801431:	57                   	push   %edi
  801432:	56                   	push   %esi
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80143a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80143e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801442:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801446:	85 c0                	test   %eax,%eax
  801448:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80144c:	89 ea                	mov    %ebp,%edx
  80144e:	89 0c 24             	mov    %ecx,(%esp)
  801451:	75 2d                	jne    801480 <__udivdi3+0x50>
  801453:	39 e9                	cmp    %ebp,%ecx
  801455:	77 61                	ja     8014b8 <__udivdi3+0x88>
  801457:	85 c9                	test   %ecx,%ecx
  801459:	89 ce                	mov    %ecx,%esi
  80145b:	75 0b                	jne    801468 <__udivdi3+0x38>
  80145d:	b8 01 00 00 00       	mov    $0x1,%eax
  801462:	31 d2                	xor    %edx,%edx
  801464:	f7 f1                	div    %ecx
  801466:	89 c6                	mov    %eax,%esi
  801468:	31 d2                	xor    %edx,%edx
  80146a:	89 e8                	mov    %ebp,%eax
  80146c:	f7 f6                	div    %esi
  80146e:	89 c5                	mov    %eax,%ebp
  801470:	89 f8                	mov    %edi,%eax
  801472:	f7 f6                	div    %esi
  801474:	89 ea                	mov    %ebp,%edx
  801476:	83 c4 0c             	add    $0xc,%esp
  801479:	5e                   	pop    %esi
  80147a:	5f                   	pop    %edi
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    
  80147d:	8d 76 00             	lea    0x0(%esi),%esi
  801480:	39 e8                	cmp    %ebp,%eax
  801482:	77 24                	ja     8014a8 <__udivdi3+0x78>
  801484:	0f bd e8             	bsr    %eax,%ebp
  801487:	83 f5 1f             	xor    $0x1f,%ebp
  80148a:	75 3c                	jne    8014c8 <__udivdi3+0x98>
  80148c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801490:	39 34 24             	cmp    %esi,(%esp)
  801493:	0f 86 9f 00 00 00    	jbe    801538 <__udivdi3+0x108>
  801499:	39 d0                	cmp    %edx,%eax
  80149b:	0f 82 97 00 00 00    	jb     801538 <__udivdi3+0x108>
  8014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014a8:	31 d2                	xor    %edx,%edx
  8014aa:	31 c0                	xor    %eax,%eax
  8014ac:	83 c4 0c             	add    $0xc,%esp
  8014af:	5e                   	pop    %esi
  8014b0:	5f                   	pop    %edi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    
  8014b3:	90                   	nop
  8014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014b8:	89 f8                	mov    %edi,%eax
  8014ba:	f7 f1                	div    %ecx
  8014bc:	31 d2                	xor    %edx,%edx
  8014be:	83 c4 0c             	add    $0xc,%esp
  8014c1:	5e                   	pop    %esi
  8014c2:	5f                   	pop    %edi
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    
  8014c5:	8d 76 00             	lea    0x0(%esi),%esi
  8014c8:	89 e9                	mov    %ebp,%ecx
  8014ca:	8b 3c 24             	mov    (%esp),%edi
  8014cd:	d3 e0                	shl    %cl,%eax
  8014cf:	89 c6                	mov    %eax,%esi
  8014d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8014d6:	29 e8                	sub    %ebp,%eax
  8014d8:	89 c1                	mov    %eax,%ecx
  8014da:	d3 ef                	shr    %cl,%edi
  8014dc:	89 e9                	mov    %ebp,%ecx
  8014de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014e2:	8b 3c 24             	mov    (%esp),%edi
  8014e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8014e9:	89 d6                	mov    %edx,%esi
  8014eb:	d3 e7                	shl    %cl,%edi
  8014ed:	89 c1                	mov    %eax,%ecx
  8014ef:	89 3c 24             	mov    %edi,(%esp)
  8014f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8014f6:	d3 ee                	shr    %cl,%esi
  8014f8:	89 e9                	mov    %ebp,%ecx
  8014fa:	d3 e2                	shl    %cl,%edx
  8014fc:	89 c1                	mov    %eax,%ecx
  8014fe:	d3 ef                	shr    %cl,%edi
  801500:	09 d7                	or     %edx,%edi
  801502:	89 f2                	mov    %esi,%edx
  801504:	89 f8                	mov    %edi,%eax
  801506:	f7 74 24 08          	divl   0x8(%esp)
  80150a:	89 d6                	mov    %edx,%esi
  80150c:	89 c7                	mov    %eax,%edi
  80150e:	f7 24 24             	mull   (%esp)
  801511:	39 d6                	cmp    %edx,%esi
  801513:	89 14 24             	mov    %edx,(%esp)
  801516:	72 30                	jb     801548 <__udivdi3+0x118>
  801518:	8b 54 24 04          	mov    0x4(%esp),%edx
  80151c:	89 e9                	mov    %ebp,%ecx
  80151e:	d3 e2                	shl    %cl,%edx
  801520:	39 c2                	cmp    %eax,%edx
  801522:	73 05                	jae    801529 <__udivdi3+0xf9>
  801524:	3b 34 24             	cmp    (%esp),%esi
  801527:	74 1f                	je     801548 <__udivdi3+0x118>
  801529:	89 f8                	mov    %edi,%eax
  80152b:	31 d2                	xor    %edx,%edx
  80152d:	e9 7a ff ff ff       	jmp    8014ac <__udivdi3+0x7c>
  801532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801538:	31 d2                	xor    %edx,%edx
  80153a:	b8 01 00 00 00       	mov    $0x1,%eax
  80153f:	e9 68 ff ff ff       	jmp    8014ac <__udivdi3+0x7c>
  801544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801548:	8d 47 ff             	lea    -0x1(%edi),%eax
  80154b:	31 d2                	xor    %edx,%edx
  80154d:	83 c4 0c             	add    $0xc,%esp
  801550:	5e                   	pop    %esi
  801551:	5f                   	pop    %edi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    
  801554:	66 90                	xchg   %ax,%ax
  801556:	66 90                	xchg   %ax,%ax
  801558:	66 90                	xchg   %ax,%ax
  80155a:	66 90                	xchg   %ax,%ax
  80155c:	66 90                	xchg   %ax,%ax
  80155e:	66 90                	xchg   %ax,%ax

00801560 <__umoddi3>:
  801560:	55                   	push   %ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	83 ec 14             	sub    $0x14,%esp
  801566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80156a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80156e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801572:	89 c7                	mov    %eax,%edi
  801574:	89 44 24 04          	mov    %eax,0x4(%esp)
  801578:	8b 44 24 30          	mov    0x30(%esp),%eax
  80157c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801580:	89 34 24             	mov    %esi,(%esp)
  801583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801587:	85 c0                	test   %eax,%eax
  801589:	89 c2                	mov    %eax,%edx
  80158b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80158f:	75 17                	jne    8015a8 <__umoddi3+0x48>
  801591:	39 fe                	cmp    %edi,%esi
  801593:	76 4b                	jbe    8015e0 <__umoddi3+0x80>
  801595:	89 c8                	mov    %ecx,%eax
  801597:	89 fa                	mov    %edi,%edx
  801599:	f7 f6                	div    %esi
  80159b:	89 d0                	mov    %edx,%eax
  80159d:	31 d2                	xor    %edx,%edx
  80159f:	83 c4 14             	add    $0x14,%esp
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    
  8015a6:	66 90                	xchg   %ax,%ax
  8015a8:	39 f8                	cmp    %edi,%eax
  8015aa:	77 54                	ja     801600 <__umoddi3+0xa0>
  8015ac:	0f bd e8             	bsr    %eax,%ebp
  8015af:	83 f5 1f             	xor    $0x1f,%ebp
  8015b2:	75 5c                	jne    801610 <__umoddi3+0xb0>
  8015b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015b8:	39 3c 24             	cmp    %edi,(%esp)
  8015bb:	0f 87 e7 00 00 00    	ja     8016a8 <__umoddi3+0x148>
  8015c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8015c5:	29 f1                	sub    %esi,%ecx
  8015c7:	19 c7                	sbb    %eax,%edi
  8015c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8015d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8015d9:	83 c4 14             	add    $0x14,%esp
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    
  8015e0:	85 f6                	test   %esi,%esi
  8015e2:	89 f5                	mov    %esi,%ebp
  8015e4:	75 0b                	jne    8015f1 <__umoddi3+0x91>
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015eb:	31 d2                	xor    %edx,%edx
  8015ed:	f7 f6                	div    %esi
  8015ef:	89 c5                	mov    %eax,%ebp
  8015f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8015f5:	31 d2                	xor    %edx,%edx
  8015f7:	f7 f5                	div    %ebp
  8015f9:	89 c8                	mov    %ecx,%eax
  8015fb:	f7 f5                	div    %ebp
  8015fd:	eb 9c                	jmp    80159b <__umoddi3+0x3b>
  8015ff:	90                   	nop
  801600:	89 c8                	mov    %ecx,%eax
  801602:	89 fa                	mov    %edi,%edx
  801604:	83 c4 14             	add    $0x14,%esp
  801607:	5e                   	pop    %esi
  801608:	5f                   	pop    %edi
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    
  80160b:	90                   	nop
  80160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801610:	8b 04 24             	mov    (%esp),%eax
  801613:	be 20 00 00 00       	mov    $0x20,%esi
  801618:	89 e9                	mov    %ebp,%ecx
  80161a:	29 ee                	sub    %ebp,%esi
  80161c:	d3 e2                	shl    %cl,%edx
  80161e:	89 f1                	mov    %esi,%ecx
  801620:	d3 e8                	shr    %cl,%eax
  801622:	89 e9                	mov    %ebp,%ecx
  801624:	89 44 24 04          	mov    %eax,0x4(%esp)
  801628:	8b 04 24             	mov    (%esp),%eax
  80162b:	09 54 24 04          	or     %edx,0x4(%esp)
  80162f:	89 fa                	mov    %edi,%edx
  801631:	d3 e0                	shl    %cl,%eax
  801633:	89 f1                	mov    %esi,%ecx
  801635:	89 44 24 08          	mov    %eax,0x8(%esp)
  801639:	8b 44 24 10          	mov    0x10(%esp),%eax
  80163d:	d3 ea                	shr    %cl,%edx
  80163f:	89 e9                	mov    %ebp,%ecx
  801641:	d3 e7                	shl    %cl,%edi
  801643:	89 f1                	mov    %esi,%ecx
  801645:	d3 e8                	shr    %cl,%eax
  801647:	89 e9                	mov    %ebp,%ecx
  801649:	09 f8                	or     %edi,%eax
  80164b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80164f:	f7 74 24 04          	divl   0x4(%esp)
  801653:	d3 e7                	shl    %cl,%edi
  801655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801659:	89 d7                	mov    %edx,%edi
  80165b:	f7 64 24 08          	mull   0x8(%esp)
  80165f:	39 d7                	cmp    %edx,%edi
  801661:	89 c1                	mov    %eax,%ecx
  801663:	89 14 24             	mov    %edx,(%esp)
  801666:	72 2c                	jb     801694 <__umoddi3+0x134>
  801668:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80166c:	72 22                	jb     801690 <__umoddi3+0x130>
  80166e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801672:	29 c8                	sub    %ecx,%eax
  801674:	19 d7                	sbb    %edx,%edi
  801676:	89 e9                	mov    %ebp,%ecx
  801678:	89 fa                	mov    %edi,%edx
  80167a:	d3 e8                	shr    %cl,%eax
  80167c:	89 f1                	mov    %esi,%ecx
  80167e:	d3 e2                	shl    %cl,%edx
  801680:	89 e9                	mov    %ebp,%ecx
  801682:	d3 ef                	shr    %cl,%edi
  801684:	09 d0                	or     %edx,%eax
  801686:	89 fa                	mov    %edi,%edx
  801688:	83 c4 14             	add    $0x14,%esp
  80168b:	5e                   	pop    %esi
  80168c:	5f                   	pop    %edi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    
  80168f:	90                   	nop
  801690:	39 d7                	cmp    %edx,%edi
  801692:	75 da                	jne    80166e <__umoddi3+0x10e>
  801694:	8b 14 24             	mov    (%esp),%edx
  801697:	89 c1                	mov    %eax,%ecx
  801699:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80169d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8016a1:	eb cb                	jmp    80166e <__umoddi3+0x10e>
  8016a3:	90                   	nop
  8016a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8016a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8016ac:	0f 82 0f ff ff ff    	jb     8015c1 <__umoddi3+0x61>
  8016b2:	e9 1a ff ff ff       	jmp    8015d1 <__umoddi3+0x71>
