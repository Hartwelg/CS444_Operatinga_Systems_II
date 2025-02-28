
obj/user/faultregs:     file format elf32-i386


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
  80002c:	e8 6a 05 00 00       	call   80059b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 b1 16 80 	movl   $0x8016b1,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 80 16 80 00 	movl   $0x801680,(%esp)
  80005a:	e8 91 06 00 00       	call   8006f0 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 90 16 80 	movl   $0x801690,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  80007a:	e8 71 06 00 00       	call   8006f0 <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  80008c:	e8 5f 06 00 00       	call   8006f0 <cprintf>
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  80009f:	e8 4c 06 00 00       	call   8006f0 <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 b2 16 80 	movl   $0x8016b2,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  8000c6:	e8 25 06 00 00       	call   8006f0 <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  8000da:	e8 11 06 00 00       	call   8006f0 <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  8000e8:	e8 03 06 00 00       	call   8006f0 <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 b6 16 80 	movl   $0x8016b6,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  80010f:	e8 dc 05 00 00       	call   8006f0 <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800123:	e8 c8 05 00 00       	call   8006f0 <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  800131:	e8 ba 05 00 00       	call   8006f0 <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 ba 16 80 	movl   $0x8016ba,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  800158:	e8 93 05 00 00       	call   8006f0 <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  80016c:	e8 7f 05 00 00       	call   8006f0 <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  80017a:	e8 71 05 00 00       	call   8006f0 <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 be 16 80 	movl   $0x8016be,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  8001a1:	e8 4a 05 00 00       	call   8006f0 <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  8001b5:	e8 36 05 00 00       	call   8006f0 <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  8001c3:	e8 28 05 00 00       	call   8006f0 <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 c2 16 80 	movl   $0x8016c2,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  8001ea:	e8 01 05 00 00       	call   8006f0 <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  8001fe:	e8 ed 04 00 00       	call   8006f0 <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  80020c:	e8 df 04 00 00       	call   8006f0 <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 c6 16 80 	movl   $0x8016c6,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  800233:	e8 b8 04 00 00       	call   8006f0 <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800247:	e8 a4 04 00 00       	call   8006f0 <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  800255:	e8 96 04 00 00       	call   8006f0 <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 ca 16 80 	movl   $0x8016ca,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  80027c:	e8 6f 04 00 00       	call   8006f0 <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800290:	e8 5b 04 00 00       	call   8006f0 <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  80029e:	e8 4d 04 00 00       	call   8006f0 <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 ce 16 80 	movl   $0x8016ce,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  8002c5:	e8 26 04 00 00       	call   8006f0 <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  8002d9:	e8 12 04 00 00       	call   8006f0 <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  8002e7:	e8 04 04 00 00       	call   8006f0 <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 d5 16 80 	movl   $0x8016d5,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 94 16 80 00 	movl   $0x801694,(%esp)
  80030e:	e8 dd 03 00 00       	call   8006f0 <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800322:	e8 c9 03 00 00       	call   8006f0 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 d9 16 80 00 	movl   $0x8016d9,(%esp)
  800335:	e8 b6 03 00 00       	call   8006f0 <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(esp, esp);
  800340:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  800347:	e8 a4 03 00 00       	call   8006f0 <cprintf>
	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 d9 16 80 00 	movl   $0x8016d9,(%esp)
  80035a:	e8 91 03 00 00       	call   8006f0 <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
		cprintf("OK\n");
  800361:	c7 04 24 a4 16 80 00 	movl   $0x8016a4,(%esp)
  800368:	e8 83 03 00 00       	call   8006f0 <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 a8 16 80 00 	movl   $0x8016a8,(%esp)
  800376:	e8 75 03 00 00       	call   8006f0 <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 40 17 80 	movl   $0x801740,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 e7 16 80 00 	movl   $0x8016e7,(%esp)
  8003b8:	e8 3a 02 00 00       	call   8005f7 <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 60 20 80 00    	mov    %edx,0x802060
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 64 20 80 00    	mov    %edx,0x802064
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 68 20 80 00    	mov    %edx,0x802068
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 6c 20 80 00    	mov    %edx,0x80206c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 70 20 80 00    	mov    %edx,0x802070
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 74 20 80 00    	mov    %edx,0x802074
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 78 20 80 00    	mov    %edx,0x802078
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 7c 20 80 00    	mov    %edx,0x80207c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 80 20 80 00    	mov    %edx,0x802080
	during.eflags = utf->utf_eflags & ~FL_RF;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800417:	89 15 84 20 80 00    	mov    %edx,0x802084
	during.esp = utf->utf_esp;
  80041d:	8b 40 30             	mov    0x30(%eax),%eax
  800420:	a3 88 20 80 00       	mov    %eax,0x802088
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800425:	c7 44 24 04 ff 16 80 	movl   $0x8016ff,0x4(%esp)
  80042c:	00 
  80042d:	c7 04 24 0d 17 80 00 	movl   $0x80170d,(%esp)
  800434:	b9 60 20 80 00       	mov    $0x802060,%ecx
  800439:	ba f8 16 80 00       	mov    $0x8016f8,%edx
  80043e:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  800443:	e8 eb fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800448:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80044f:	00 
  800450:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800457:	00 
  800458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80045f:	e8 cf 0c 00 00       	call   801133 <sys_page_alloc>
  800464:	85 c0                	test   %eax,%eax
  800466:	79 20                	jns    800488 <pgfault+0x105>
		panic("sys_page_alloc: %e", r);
  800468:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046c:	c7 44 24 08 14 17 80 	movl   $0x801714,0x8(%esp)
  800473:	00 
  800474:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80047b:	00 
  80047c:	c7 04 24 e7 16 80 00 	movl   $0x8016e7,(%esp)
  800483:	e8 6f 01 00 00       	call   8005f7 <_panic>
}
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <umain>:

void
umain(int argc, char **argv)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  800490:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800497:	e8 ac 0e 00 00       	call   801348 <set_pgfault_handler>

	asm volatile(
  80049c:	50                   	push   %eax
  80049d:	9c                   	pushf  
  80049e:	58                   	pop    %eax
  80049f:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004a4:	50                   	push   %eax
  8004a5:	9d                   	popf   
  8004a6:	a3 c4 20 80 00       	mov    %eax,0x8020c4
  8004ab:	8d 05 e6 04 80 00    	lea    0x8004e6,%eax
  8004b1:	a3 c0 20 80 00       	mov    %eax,0x8020c0
  8004b6:	58                   	pop    %eax
  8004b7:	89 3d a0 20 80 00    	mov    %edi,0x8020a0
  8004bd:	89 35 a4 20 80 00    	mov    %esi,0x8020a4
  8004c3:	89 2d a8 20 80 00    	mov    %ebp,0x8020a8
  8004c9:	89 1d b0 20 80 00    	mov    %ebx,0x8020b0
  8004cf:	89 15 b4 20 80 00    	mov    %edx,0x8020b4
  8004d5:	89 0d b8 20 80 00    	mov    %ecx,0x8020b8
  8004db:	a3 bc 20 80 00       	mov    %eax,0x8020bc
  8004e0:	89 25 c8 20 80 00    	mov    %esp,0x8020c8
  8004e6:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004ed:	00 00 00 
  8004f0:	89 3d 20 20 80 00    	mov    %edi,0x802020
  8004f6:	89 35 24 20 80 00    	mov    %esi,0x802024
  8004fc:	89 2d 28 20 80 00    	mov    %ebp,0x802028
  800502:	89 1d 30 20 80 00    	mov    %ebx,0x802030
  800508:	89 15 34 20 80 00    	mov    %edx,0x802034
  80050e:	89 0d 38 20 80 00    	mov    %ecx,0x802038
  800514:	a3 3c 20 80 00       	mov    %eax,0x80203c
  800519:	89 25 48 20 80 00    	mov    %esp,0x802048
  80051f:	8b 3d a0 20 80 00    	mov    0x8020a0,%edi
  800525:	8b 35 a4 20 80 00    	mov    0x8020a4,%esi
  80052b:	8b 2d a8 20 80 00    	mov    0x8020a8,%ebp
  800531:	8b 1d b0 20 80 00    	mov    0x8020b0,%ebx
  800537:	8b 15 b4 20 80 00    	mov    0x8020b4,%edx
  80053d:	8b 0d b8 20 80 00    	mov    0x8020b8,%ecx
  800543:	a1 bc 20 80 00       	mov    0x8020bc,%eax
  800548:	8b 25 c8 20 80 00    	mov    0x8020c8,%esp
  80054e:	50                   	push   %eax
  80054f:	9c                   	pushf  
  800550:	58                   	pop    %eax
  800551:	a3 44 20 80 00       	mov    %eax,0x802044
  800556:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800557:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80055e:	74 0c                	je     80056c <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  800560:	c7 04 24 74 17 80 00 	movl   $0x801774,(%esp)
  800567:	e8 84 01 00 00       	call   8006f0 <cprintf>
	after.eip = before.eip;
  80056c:	a1 c0 20 80 00       	mov    0x8020c0,%eax
  800571:	a3 40 20 80 00       	mov    %eax,0x802040

	check_regs(&before, "before", &after, "after", "after page-fault");
  800576:	c7 44 24 04 27 17 80 	movl   $0x801727,0x4(%esp)
  80057d:	00 
  80057e:	c7 04 24 38 17 80 00 	movl   $0x801738,(%esp)
  800585:	b9 20 20 80 00       	mov    $0x802020,%ecx
  80058a:	ba f8 16 80 00       	mov    $0x8016f8,%edx
  80058f:	b8 a0 20 80 00       	mov    $0x8020a0,%eax
  800594:	e8 9a fa ff ff       	call   800033 <check_regs>
}
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	56                   	push   %esi
  80059f:	53                   	push   %ebx
  8005a0:	83 ec 10             	sub    $0x10,%esp
  8005a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005a9:	e8 47 0b 00 00       	call   8010f5 <sys_getenvid>
  8005ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005bb:	a3 cc 20 80 00       	mov    %eax,0x8020cc

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c0:	85 db                	test   %ebx,%ebx
  8005c2:	7e 07                	jle    8005cb <libmain+0x30>
		binaryname = argv[0];
  8005c4:	8b 06                	mov    (%esi),%eax
  8005c6:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8005cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cf:	89 1c 24             	mov    %ebx,(%esp)
  8005d2:	e8 b3 fe ff ff       	call   80048a <umain>

	// exit gracefully
	exit();
  8005d7:	e8 07 00 00 00       	call   8005e3 <exit>
}
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	5b                   	pop    %ebx
  8005e0:	5e                   	pop    %esi
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 18             	sub    $0x18,%esp
	sys_env_destroy(0);
  8005e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f0:	e8 ae 0a 00 00       	call   8010a3 <sys_env_destroy>
}
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	56                   	push   %esi
  8005fb:	53                   	push   %ebx
  8005fc:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800602:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800608:	e8 e8 0a 00 00       	call   8010f5 <sys_getenvid>
  80060d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800610:	89 54 24 10          	mov    %edx,0x10(%esp)
  800614:	8b 55 08             	mov    0x8(%ebp),%edx
  800617:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80061f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800623:	c7 04 24 a0 17 80 00 	movl   $0x8017a0,(%esp)
  80062a:	e8 c1 00 00 00       	call   8006f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80062f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800633:	8b 45 10             	mov    0x10(%ebp),%eax
  800636:	89 04 24             	mov    %eax,(%esp)
  800639:	e8 51 00 00 00       	call   80068f <vcprintf>
	cprintf("\n");
  80063e:	c7 04 24 b0 16 80 00 	movl   $0x8016b0,(%esp)
  800645:	e8 a6 00 00 00       	call   8006f0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80064a:	cc                   	int3   
  80064b:	eb fd                	jmp    80064a <_panic+0x53>

0080064d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80064d:	55                   	push   %ebp
  80064e:	89 e5                	mov    %esp,%ebp
  800650:	53                   	push   %ebx
  800651:	83 ec 14             	sub    $0x14,%esp
  800654:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800657:	8b 13                	mov    (%ebx),%edx
  800659:	8d 42 01             	lea    0x1(%edx),%eax
  80065c:	89 03                	mov    %eax,(%ebx)
  80065e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800661:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 19                	jne    800685 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80066c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800673:	00 
  800674:	8d 43 08             	lea    0x8(%ebx),%eax
  800677:	89 04 24             	mov    %eax,(%esp)
  80067a:	e8 e7 09 00 00       	call   801066 <sys_cputs>
		b->idx = 0;
  80067f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800685:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800689:	83 c4 14             	add    $0x14,%esp
  80068c:	5b                   	pop    %ebx
  80068d:	5d                   	pop    %ebp
  80068e:	c3                   	ret    

0080068f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800698:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80069f:	00 00 00 
	b.cnt = 0;
  8006a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c4:	c7 04 24 4d 06 80 00 	movl   $0x80064d,(%esp)
  8006cb:	e8 ae 01 00 00       	call   80087e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006d0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006e0:	89 04 24             	mov    %eax,(%esp)
  8006e3:	e8 7e 09 00 00       	call   801066 <sys_cputs>

	return b.cnt;
}
  8006e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	e8 87 ff ff ff       	call   80068f <vcprintf>
	va_end(ap);

	return cnt;
}
  800708:	c9                   	leave  
  800709:	c3                   	ret    
  80070a:	66 90                	xchg   %ax,%ax
  80070c:	66 90                	xchg   %ax,%ax
  80070e:	66 90                	xchg   %ax,%ax

00800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	57                   	push   %edi
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 3c             	sub    $0x3c,%esp
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	89 c3                	mov    %eax,%ebx
  800729:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073d:	39 d9                	cmp    %ebx,%ecx
  80073f:	72 05                	jb     800746 <printnum+0x36>
  800741:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800744:	77 69                	ja     8007af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800749:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80074d:	83 ee 01             	sub    $0x1,%esi
  800750:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800754:	89 44 24 08          	mov    %eax,0x8(%esp)
  800758:	8b 44 24 08          	mov    0x8(%esp),%eax
  80075c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800760:	89 c3                	mov    %eax,%ebx
  800762:	89 d6                	mov    %edx,%esi
  800764:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800767:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80076e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	e8 5c 0c 00 00       	call   8013e0 <__udivdi3>
  800784:	89 d9                	mov    %ebx,%ecx
  800786:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80078a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	89 54 24 04          	mov    %edx,0x4(%esp)
  800795:	89 fa                	mov    %edi,%edx
  800797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079a:	e8 71 ff ff ff       	call   800710 <printnum>
  80079f:	eb 1b                	jmp    8007bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	ff d3                	call   *%ebx
  8007ad:	eb 03                	jmp    8007b2 <printnum+0xa2>
  8007af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while (--width > 0)
  8007b2:	83 ee 01             	sub    $0x1,%esi
  8007b5:	85 f6                	test   %esi,%esi
  8007b7:	7f e8                	jg     8007a1 <printnum+0x91>
  8007b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007df:	e8 2c 0d 00 00       	call   801510 <__umoddi3>
  8007e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e8:	0f be 80 c3 17 80 00 	movsbl 0x8017c3(%eax),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
}
  8007f7:	83 c4 3c             	add    $0x3c,%esp
  8007fa:	5b                   	pop    %ebx
  8007fb:	5e                   	pop    %esi
  8007fc:	5f                   	pop    %edi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800802:	83 fa 01             	cmp    $0x1,%edx
  800805:	7e 0e                	jle    800815 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800807:	8b 10                	mov    (%eax),%edx
  800809:	8d 4a 08             	lea    0x8(%edx),%ecx
  80080c:	89 08                	mov    %ecx,(%eax)
  80080e:	8b 02                	mov    (%edx),%eax
  800810:	8b 52 04             	mov    0x4(%edx),%edx
  800813:	eb 22                	jmp    800837 <getuint+0x38>
	else if (lflag)
  800815:	85 d2                	test   %edx,%edx
  800817:	74 10                	je     800829 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80081e:	89 08                	mov    %ecx,(%eax)
  800820:	8b 02                	mov    (%edx),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	eb 0e                	jmp    800837 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082e:	89 08                	mov    %ecx,(%eax)
  800830:	8b 02                	mov    (%edx),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800843:	8b 10                	mov    (%eax),%edx
  800845:	3b 50 04             	cmp    0x4(%eax),%edx
  800848:	73 0a                	jae    800854 <sprintputch+0x1b>
		*b->buf++ = ch;
  80084a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80084d:	89 08                	mov    %ecx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	88 02                	mov    %al,(%edx)
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <printfmt>:
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	va_start(ap, fmt);
  80085c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80085f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	89 04 24             	mov    %eax,(%esp)
  800877:	e8 02 00 00 00       	call   80087e <vprintfmt>
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <vprintfmt>:
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	57                   	push   %edi
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 3c             	sub    $0x3c,%esp
  800887:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80088a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80088d:	eb 14                	jmp    8008a3 <vprintfmt+0x25>
			if (ch == '\0')
  80088f:	85 c0                	test   %eax,%eax
  800891:	0f 84 b3 03 00 00    	je     800c4a <vprintfmt+0x3cc>
			putch(ch, putdat);
  800897:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089b:	89 04 24             	mov    %eax,(%esp)
  80089e:	ff 55 08             	call   *0x8(%ebp)
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	89 f3                	mov    %esi,%ebx
  8008a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8008a6:	0f b6 03             	movzbl (%ebx),%eax
  8008a9:	83 f8 25             	cmp    $0x25,%eax
  8008ac:	75 e1                	jne    80088f <vprintfmt+0x11>
  8008ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8008b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	eb 1d                	jmp    8008eb <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  8008ce:	89 de                	mov    %ebx,%esi
			padc = '-';
  8008d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8008d4:	eb 15                	jmp    8008eb <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	89 de                	mov    %ebx,%esi
			padc = '0';
  8008d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8008dc:	eb 0d                	jmp    8008eb <vprintfmt+0x6d>
				width = precision, precision = -1;
  8008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008ee:	0f b6 0e             	movzbl (%esi),%ecx
  8008f1:	0f b6 c1             	movzbl %cl,%eax
  8008f4:	83 e9 23             	sub    $0x23,%ecx
  8008f7:	80 f9 55             	cmp    $0x55,%cl
  8008fa:	0f 87 2a 03 00 00    	ja     800c2a <vprintfmt+0x3ac>
  800900:	0f b6 c9             	movzbl %cl,%ecx
  800903:	ff 24 8d 80 18 80 00 	jmp    *0x801880(,%ecx,4)
  80090a:	89 de                	mov    %ebx,%esi
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
				precision = precision * 10 + ch - '0';
  800911:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800914:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800918:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80091b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80091e:	83 fb 09             	cmp    $0x9,%ebx
  800921:	77 36                	ja     800959 <vprintfmt+0xdb>
			for (precision = 0; ; ++fmt) {
  800923:	83 c6 01             	add    $0x1,%esi
			}
  800926:	eb e9                	jmp    800911 <vprintfmt+0x93>
			precision = va_arg(ap, int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 48 04             	lea    0x4(%eax),%ecx
  80092e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800931:	8b 00                	mov    (%eax),%eax
  800933:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800936:	89 de                	mov    %ebx,%esi
			goto process_precision;
  800938:	eb 22                	jmp    80095c <vprintfmt+0xde>
  80093a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	0f 49 c1             	cmovns %ecx,%eax
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	89 de                	mov    %ebx,%esi
  80094c:	eb 9d                	jmp    8008eb <vprintfmt+0x6d>
  80094e:	89 de                	mov    %ebx,%esi
			altflag = 1;
  800950:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800957:	eb 92                	jmp    8008eb <vprintfmt+0x6d>
  800959:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
			if (width < 0)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	79 89                	jns    8008eb <vprintfmt+0x6d>
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x60>
			lflag++;
  800967:	83 c2 01             	add    $0x1,%edx
		switch (ch = *(unsigned char *) fmt++) {
  80096a:	89 de                	mov    %ebx,%esi
			goto reswitch;
  80096c:	e9 7a ff ff ff       	jmp    8008eb <vprintfmt+0x6d>
			putch(va_arg(ap, int), putdat);
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	89 55 14             	mov    %edx,0x14(%ebp)
  80097a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	89 04 24             	mov    %eax,(%esp)
  800983:	ff 55 08             	call   *0x8(%ebp)
			break;
  800986:	e9 18 ff ff ff       	jmp    8008a3 <vprintfmt+0x25>
			err = va_arg(ap, int);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8d 50 04             	lea    0x4(%eax),%edx
  800991:	89 55 14             	mov    %edx,0x14(%ebp)
  800994:	8b 00                	mov    (%eax),%eax
  800996:	99                   	cltd   
  800997:	31 d0                	xor    %edx,%eax
  800999:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80099b:	83 f8 08             	cmp    $0x8,%eax
  80099e:	7f 0b                	jg     8009ab <vprintfmt+0x12d>
  8009a0:	8b 14 85 e0 19 80 00 	mov    0x8019e0(,%eax,4),%edx
  8009a7:	85 d2                	test   %edx,%edx
  8009a9:	75 20                	jne    8009cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009af:	c7 44 24 08 db 17 80 	movl   $0x8017db,0x8(%esp)
  8009b6:	00 
  8009b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	89 04 24             	mov    %eax,(%esp)
  8009c1:	e8 90 fe ff ff       	call   800856 <printfmt>
  8009c6:	e9 d8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
				printfmt(putch, putdat, "%s", p);
  8009cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009cf:	c7 44 24 08 e4 17 80 	movl   $0x8017e4,0x8(%esp)
  8009d6:	00 
  8009d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 04 24             	mov    %eax,(%esp)
  8009e1:	e8 70 fe ff ff       	call   800856 <printfmt>
  8009e6:	e9 b8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
		switch (ch = *(unsigned char *) fmt++) {
  8009eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8d 50 04             	lea    0x4(%eax),%edx
  8009fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8009fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009ff:	85 f6                	test   %esi,%esi
  800a01:	b8 d4 17 80 00       	mov    $0x8017d4,%eax
  800a06:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800a09:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800a0d:	0f 84 97 00 00 00    	je     800aaa <vprintfmt+0x22c>
  800a13:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a17:	0f 8e 9b 00 00 00    	jle    800ab8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a21:	89 34 24             	mov    %esi,(%esp)
  800a24:	e8 cf 02 00 00       	call   800cf8 <strnlen>
  800a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a2c:	29 c2                	sub    %eax,%edx
  800a2e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800a31:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a38:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a41:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  800a43:	eb 0f                	jmp    800a54 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4c:	89 04 24             	mov    %eax,(%esp)
  800a4f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	83 eb 01             	sub    $0x1,%ebx
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	7f ed                	jg     800a45 <vprintfmt+0x1c7>
  800a58:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a5b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	0f 49 c2             	cmovns %edx,%eax
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6d:	89 d7                	mov    %edx,%edi
  800a6f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a72:	eb 50                	jmp    800ac4 <vprintfmt+0x246>
				if (altflag && (ch < ' ' || ch > '~'))
  800a74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a78:	74 1e                	je     800a98 <vprintfmt+0x21a>
  800a7a:	0f be d2             	movsbl %dl,%edx
  800a7d:	83 ea 20             	sub    $0x20,%edx
  800a80:	83 fa 5e             	cmp    $0x5e,%edx
  800a83:	76 13                	jbe    800a98 <vprintfmt+0x21a>
					putch('?', putdat);
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a93:	ff 55 08             	call   *0x8(%ebp)
  800a96:	eb 0d                	jmp    800aa5 <vprintfmt+0x227>
					putch(ch, putdat);
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa5:	83 ef 01             	sub    $0x1,%edi
  800aa8:	eb 1a                	jmp    800ac4 <vprintfmt+0x246>
  800aaa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800aad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ab6:	eb 0c                	jmp    800ac4 <vprintfmt+0x246>
  800ab8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800abb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800abe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ac4:	83 c6 01             	add    $0x1,%esi
  800ac7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800acb:	0f be c2             	movsbl %dl,%eax
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	74 27                	je     800af9 <vprintfmt+0x27b>
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	78 9e                	js     800a74 <vprintfmt+0x1f6>
  800ad6:	83 eb 01             	sub    $0x1,%ebx
  800ad9:	79 99                	jns    800a74 <vprintfmt+0x1f6>
  800adb:	89 f8                	mov    %edi,%eax
  800add:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ae0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ae3:	89 c3                	mov    %eax,%ebx
  800ae5:	eb 1a                	jmp    800b01 <vprintfmt+0x283>
				putch(' ', putdat);
  800ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aeb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800af2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800af4:	83 eb 01             	sub    $0x1,%ebx
  800af7:	eb 08                	jmp    800b01 <vprintfmt+0x283>
  800af9:	89 fb                	mov    %edi,%ebx
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
  800afe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	7f e2                	jg     800ae7 <vprintfmt+0x269>
  800b05:	89 75 08             	mov    %esi,0x8(%ebp)
  800b08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b0b:	e9 93 fd ff ff       	jmp    8008a3 <vprintfmt+0x25>
	if (lflag >= 2)
  800b10:	83 fa 01             	cmp    $0x1,%edx
  800b13:	7e 16                	jle    800b2b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	8d 50 08             	lea    0x8(%eax),%edx
  800b1b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b1e:	8b 50 04             	mov    0x4(%eax),%edx
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b29:	eb 32                	jmp    800b5d <vprintfmt+0x2df>
	else if (lflag)
  800b2b:	85 d2                	test   %edx,%edx
  800b2d:	74 18                	je     800b47 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	89 55 14             	mov    %edx,0x14(%ebp)
  800b38:	8b 30                	mov    (%eax),%esi
  800b3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	c1 f8 1f             	sar    $0x1f,%eax
  800b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x2df>
		return va_arg(*ap, int);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8d 50 04             	lea    0x4(%eax),%edx
  800b4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b50:	8b 30                	mov    (%eax),%esi
  800b52:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b55:	89 f0                	mov    %esi,%eax
  800b57:	c1 f8 1f             	sar    $0x1f,%eax
  800b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			num = getint(&ap, lflag);
  800b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			base = 10;
  800b63:	b9 0a 00 00 00       	mov    $0xa,%ecx
			if ((long long) num < 0) {
  800b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6c:	0f 89 80 00 00 00    	jns    800bf2 <vprintfmt+0x374>
				putch('-', putdat);
  800b72:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b76:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b7d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b86:	f7 d8                	neg    %eax
  800b88:	83 d2 00             	adc    $0x0,%edx
  800b8b:	f7 da                	neg    %edx
			base = 10;
  800b8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b92:	eb 5e                	jmp    800bf2 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800b94:	8d 45 14             	lea    0x14(%ebp),%eax
  800b97:	e8 63 fc ff ff       	call   8007ff <getuint>
			base = 10;
  800b9c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ba1:	eb 4f                	jmp    800bf2 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800ba3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba6:	e8 54 fc ff ff       	call   8007ff <getuint>
			base = 8;
  800bab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bb0:	eb 40                	jmp    800bf2 <vprintfmt+0x374>
			putch('0', putdat);
  800bb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bbd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bc0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bcb:	ff 55 08             	call   *0x8(%ebp)
				(uintptr_t) va_arg(ap, void *);
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	8d 50 04             	lea    0x4(%eax),%edx
  800bd4:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
			base = 16;
  800bde:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800be3:	eb 0d                	jmp    800bf2 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	e8 12 fc ff ff       	call   8007ff <getuint>
			base = 16;
  800bed:	b9 10 00 00 00       	mov    $0x10,%ecx
			printnum(putch, putdat, num, base, width, padc);
  800bf2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800bf6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bfa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bfd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c01:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c05:	89 04 24             	mov    %eax,(%esp)
  800c08:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0c:	89 fa                	mov    %edi,%edx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	e8 fa fa ff ff       	call   800710 <printnum>
			break;
  800c16:	e9 88 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>
			putch(ch, putdat);
  800c1b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c1f:	89 04 24             	mov    %eax,(%esp)
  800c22:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c25:	e9 79 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>
			putch('%', putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c35:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c38:	89 f3                	mov    %esi,%ebx
  800c3a:	eb 03                	jmp    800c3f <vprintfmt+0x3c1>
  800c3c:	83 eb 01             	sub    $0x1,%ebx
  800c3f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c43:	75 f7                	jne    800c3c <vprintfmt+0x3be>
  800c45:	e9 59 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>
}
  800c4a:	83 c4 3c             	add    $0x3c,%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 28             	sub    $0x28,%esp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c61:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c65:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	74 30                	je     800ca3 <vsnprintf+0x51>
  800c73:	85 d2                	test   %edx,%edx
  800c75:	7e 2c                	jle    800ca3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c8c:	c7 04 24 39 08 80 00 	movl   $0x800839,(%esp)
  800c93:	e8 e6 fb ff ff       	call   80087e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca1:	eb 05                	jmp    800ca8 <vsnprintf+0x56>
		return -E_INVAL;
  800ca3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 04 24             	mov    %eax,(%esp)
  800ccb:	e8 82 ff ff ff       	call   800c52 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    
  800cd2:	66 90                	xchg   %ax,%ax
  800cd4:	66 90                	xchg   %ax,%ax
  800cd6:	66 90                	xchg   %ax,%ax
  800cd8:	66 90                	xchg   %ax,%ax
  800cda:	66 90                	xchg   %ax,%ax
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	eb 03                	jmp    800cf0 <strlen+0x10>
		n++;
  800ced:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf4:	75 f7                	jne    800ced <strlen+0xd>
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 03                	jmp    800d0b <strnlen+0x13>
		n++;
  800d08:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0b:	39 d0                	cmp    %edx,%eax
  800d0d:	74 06                	je     800d15 <strnlen+0x1d>
  800d0f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d13:	75 f3                	jne    800d08 <strnlen+0x10>
	return n;
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d21:	89 c2                	mov    %eax,%edx
  800d23:	83 c2 01             	add    $0x1,%edx
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d30:	84 db                	test   %bl,%bl
  800d32:	75 ef                	jne    800d23 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d34:	5b                   	pop    %ebx
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d41:	89 1c 24             	mov    %ebx,(%esp)
  800d44:	e8 97 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	89 04 24             	mov    %eax,(%esp)
  800d55:	e8 bd ff ff ff       	call   800d17 <strcpy>
	return dst;
}
  800d5a:	89 d8                	mov    %ebx,%eax
  800d5c:	83 c4 08             	add    $0x8,%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	89 f3                	mov    %esi,%ebx
  800d6f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d72:	89 f2                	mov    %esi,%edx
  800d74:	eb 0f                	jmp    800d85 <strncpy+0x23>
		*dst++ = *src;
  800d76:	83 c2 01             	add    $0x1,%edx
  800d79:	0f b6 01             	movzbl (%ecx),%eax
  800d7c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d7f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d82:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800d85:	39 da                	cmp    %ebx,%edx
  800d87:	75 ed                	jne    800d76 <strncpy+0x14>
	}
	return ret;
}
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	8b 75 08             	mov    0x8(%ebp),%esi
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d9d:	89 f0                	mov    %esi,%eax
  800d9f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800da3:	85 c9                	test   %ecx,%ecx
  800da5:	75 0b                	jne    800db2 <strlcpy+0x23>
  800da7:	eb 1d                	jmp    800dc6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da9:	83 c0 01             	add    $0x1,%eax
  800dac:	83 c2 01             	add    $0x1,%edx
  800daf:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800db2:	39 d8                	cmp    %ebx,%eax
  800db4:	74 0b                	je     800dc1 <strlcpy+0x32>
  800db6:	0f b6 0a             	movzbl (%edx),%ecx
  800db9:	84 c9                	test   %cl,%cl
  800dbb:	75 ec                	jne    800da9 <strlcpy+0x1a>
  800dbd:	89 c2                	mov    %eax,%edx
  800dbf:	eb 02                	jmp    800dc3 <strlcpy+0x34>
  800dc1:	89 c2                	mov    %eax,%edx
		*dst = '\0';
  800dc3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800dc6:	29 f0                	sub    %esi,%eax
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0x11>
		p++, q++;
  800dd7:	83 c1 01             	add    $0x1,%ecx
  800dda:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ddd:	0f b6 01             	movzbl (%ecx),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	74 04                	je     800de8 <strcmp+0x1c>
  800de4:	3a 02                	cmp    (%edx),%al
  800de6:	74 ef                	je     800dd7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de8:	0f b6 c0             	movzbl %al,%eax
  800deb:	0f b6 12             	movzbl (%edx),%edx
  800dee:	29 d0                	sub    %edx,%eax
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e01:	eb 06                	jmp    800e09 <strncmp+0x17>
		n--, p++, q++;
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e09:	39 d8                	cmp    %ebx,%eax
  800e0b:	74 15                	je     800e22 <strncmp+0x30>
  800e0d:	0f b6 08             	movzbl (%eax),%ecx
  800e10:	84 c9                	test   %cl,%cl
  800e12:	74 04                	je     800e18 <strncmp+0x26>
  800e14:	3a 0a                	cmp    (%edx),%cl
  800e16:	74 eb                	je     800e03 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	0f b6 12             	movzbl (%edx),%edx
  800e1e:	29 d0                	sub    %edx,%eax
  800e20:	eb 05                	jmp    800e27 <strncmp+0x35>
		return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e34:	eb 07                	jmp    800e3d <strchr+0x13>
		if (*s == c)
  800e36:	38 ca                	cmp    %cl,%dl
  800e38:	74 0f                	je     800e49 <strchr+0x1f>
	for (; *s; s++)
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	75 f2                	jne    800e36 <strchr+0xc>
			return (char *) s;
	return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e55:	eb 07                	jmp    800e5e <strfind+0x13>
		if (*s == c)
  800e57:	38 ca                	cmp    %cl,%dl
  800e59:	74 0a                	je     800e65 <strfind+0x1a>
	for (; *s; s++)
  800e5b:	83 c0 01             	add    $0x1,%eax
  800e5e:	0f b6 10             	movzbl (%eax),%edx
  800e61:	84 d2                	test   %dl,%dl
  800e63:	75 f2                	jne    800e57 <strfind+0xc>
			break;
	return (char *) s;
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e73:	85 c9                	test   %ecx,%ecx
  800e75:	74 36                	je     800ead <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e7d:	75 28                	jne    800ea7 <memset+0x40>
  800e7f:	f6 c1 03             	test   $0x3,%cl
  800e82:	75 23                	jne    800ea7 <memset+0x40>
		c &= 0xFF;
  800e84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	c1 e3 08             	shl    $0x8,%ebx
  800e8d:	89 d6                	mov    %edx,%esi
  800e8f:	c1 e6 18             	shl    $0x18,%esi
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	c1 e0 10             	shl    $0x10,%eax
  800e97:	09 f0                	or     %esi,%eax
  800e99:	09 c2                	or     %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e9f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ea2:	fc                   	cld    
  800ea3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ea5:	eb 06                	jmp    800ead <memset+0x46>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	fc                   	cld    
  800eab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ead:	89 f8                	mov    %edi,%eax
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec2:	39 c6                	cmp    %eax,%esi
  800ec4:	73 35                	jae    800efb <memmove+0x47>
  800ec6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ec9:	39 d0                	cmp    %edx,%eax
  800ecb:	73 2e                	jae    800efb <memmove+0x47>
		s += n;
		d += n;
  800ecd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ed0:	89 d6                	mov    %edx,%esi
  800ed2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eda:	75 13                	jne    800eef <memmove+0x3b>
  800edc:	f6 c1 03             	test   $0x3,%cl
  800edf:	75 0e                	jne    800eef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ee1:	83 ef 04             	sub    $0x4,%edi
  800ee4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ee7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800eea:	fd                   	std    
  800eeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eed:	eb 09                	jmp    800ef8 <memmove+0x44>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eef:	83 ef 01             	sub    $0x1,%edi
  800ef2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ef5:	fd                   	std    
  800ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef8:	fc                   	cld    
  800ef9:	eb 1d                	jmp    800f18 <memmove+0x64>
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eff:	f6 c2 03             	test   $0x3,%dl
  800f02:	75 0f                	jne    800f13 <memmove+0x5f>
  800f04:	f6 c1 03             	test   $0x3,%cl
  800f07:	75 0a                	jne    800f13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f0c:	89 c7                	mov    %eax,%edi
  800f0e:	fc                   	cld    
  800f0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f11:	eb 05                	jmp    800f18 <memmove+0x64>
		else
			asm volatile("cld; rep movsb\n"
  800f13:	89 c7                	mov    %eax,%edi
  800f15:	fc                   	cld    
  800f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 04 24             	mov    %eax,(%esp)
  800f36:	e8 79 ff ff ff       	call   800eb4 <memmove>
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	89 d6                	mov    %edx,%esi
  800f4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f4d:	eb 1a                	jmp    800f69 <memcmp+0x2c>
		if (*s1 != *s2)
  800f4f:	0f b6 02             	movzbl (%edx),%eax
  800f52:	0f b6 19             	movzbl (%ecx),%ebx
  800f55:	38 d8                	cmp    %bl,%al
  800f57:	74 0a                	je     800f63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	0f b6 db             	movzbl %bl,%ebx
  800f5f:	29 d8                	sub    %ebx,%eax
  800f61:	eb 0f                	jmp    800f72 <memcmp+0x35>
		s1++, s2++;
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	83 c1 01             	add    $0x1,%ecx
	while (n-- > 0) {
  800f69:	39 f2                	cmp    %esi,%edx
  800f6b:	75 e2                	jne    800f4f <memcmp+0x12>
	}

	return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f84:	eb 07                	jmp    800f8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	38 08                	cmp    %cl,(%eax)
  800f88:	74 07                	je     800f91 <memfind+0x1b>
	for (; s < ends; s++)
  800f8a:	83 c0 01             	add    $0x1,%eax
  800f8d:	39 d0                	cmp    %edx,%eax
  800f8f:	72 f5                	jb     800f86 <memfind+0x10>
			break;
	return (void *) s;
}
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9f:	eb 03                	jmp    800fa4 <strtol+0x11>
		s++;
  800fa1:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800fa4:	0f b6 0a             	movzbl (%edx),%ecx
  800fa7:	80 f9 09             	cmp    $0x9,%cl
  800faa:	74 f5                	je     800fa1 <strtol+0xe>
  800fac:	80 f9 20             	cmp    $0x20,%cl
  800faf:	74 f0                	je     800fa1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800fb1:	80 f9 2b             	cmp    $0x2b,%cl
  800fb4:	75 0a                	jne    800fc0 <strtol+0x2d>
		s++;
  800fb6:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	eb 11                	jmp    800fd1 <strtol+0x3e>
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
	else if (*s == '-')
  800fc5:	80 f9 2d             	cmp    $0x2d,%cl
  800fc8:	75 07                	jne    800fd1 <strtol+0x3e>
		s++, neg = 1;
  800fca:	8d 52 01             	lea    0x1(%edx),%edx
  800fcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800fd6:	75 15                	jne    800fed <strtol+0x5a>
  800fd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800fdb:	75 10                	jne    800fed <strtol+0x5a>
  800fdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fe1:	75 0a                	jne    800fed <strtol+0x5a>
		s += 2, base = 16;
  800fe3:	83 c2 02             	add    $0x2,%edx
  800fe6:	b8 10 00 00 00       	mov    $0x10,%eax
  800feb:	eb 10                	jmp    800ffd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 0c                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ff1:	b0 0a                	mov    $0xa,%al
	else if (base == 0 && s[0] == '0')
  800ff3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ff6:	75 05                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
  800ff8:	83 c2 01             	add    $0x1,%edx
  800ffb:	b0 08                	mov    $0x8,%al
		base = 10;
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801005:	0f b6 0a             	movzbl (%edx),%ecx
  801008:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	3c 09                	cmp    $0x9,%al
  80100f:	77 08                	ja     801019 <strtol+0x86>
			dig = *s - '0';
  801011:	0f be c9             	movsbl %cl,%ecx
  801014:	83 e9 30             	sub    $0x30,%ecx
  801017:	eb 20                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801019:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80101c:	89 f0                	mov    %esi,%eax
  80101e:	3c 19                	cmp    $0x19,%al
  801020:	77 08                	ja     80102a <strtol+0x97>
			dig = *s - 'a' + 10;
  801022:	0f be c9             	movsbl %cl,%ecx
  801025:	83 e9 57             	sub    $0x57,%ecx
  801028:	eb 0f                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80102a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80102d:	89 f0                	mov    %esi,%eax
  80102f:	3c 19                	cmp    $0x19,%al
  801031:	77 16                	ja     801049 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801033:	0f be c9             	movsbl %cl,%ecx
  801036:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801039:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80103c:	7d 0f                	jge    80104d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80103e:	83 c2 01             	add    $0x1,%edx
  801041:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801045:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801047:	eb bc                	jmp    801005 <strtol+0x72>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	eb 02                	jmp    80104f <strtol+0xbc>
  80104d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80104f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801053:	74 05                	je     80105a <strtol+0xc7>
		*endptr = (char *) s;
  801055:	8b 75 0c             	mov    0xc(%ebp),%esi
  801058:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80105a:	f7 d8                	neg    %eax
  80105c:	85 ff                	test   %edi,%edi
  80105e:	0f 44 c3             	cmove  %ebx,%eax
}
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	89 c3                	mov    %eax,%ebx
  801079:	89 c7                	mov    %eax,%edi
  80107b:	89 c6                	mov    %eax,%esi
  80107d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_cgetc>:

int
sys_cgetc(void)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 01 00 00 00       	mov    $0x1,%eax
  801094:	89 d1                	mov    %edx,%ecx
  801096:	89 d3                	mov    %edx,%ebx
  801098:	89 d7                	mov    %edx,%edi
  80109a:	89 d6                	mov    %edx,%esi
  80109c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7e 28                	jle    8010ed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  8010e8:	e8 0a f5 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ed:	83 c4 2c             	add    $0x2c,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801100:	b8 02 00 00 00       	mov    $0x2,%eax
  801105:	89 d1                	mov    %edx,%ecx
  801107:	89 d3                	mov    %edx,%ebx
  801109:	89 d7                	mov    %edx,%edi
  80110b:	89 d6                	mov    %edx,%esi
  80110d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <sys_yield>:

void
sys_yield(void)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801124:	89 d1                	mov    %edx,%ecx
  801126:	89 d3                	mov    %edx,%ebx
  801128:	89 d7                	mov    %edx,%edi
  80112a:	89 d6                	mov    %edx,%esi
  80112c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	57                   	push   %edi
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
  801139:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  80113c:	be 00 00 00 00       	mov    $0x0,%esi
  801141:	b8 04 00 00 00       	mov    $0x4,%eax
  801146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114f:	89 f7                	mov    %esi,%edi
  801151:	cd 30                	int    $0x30
	if(check && ret > 0)
  801153:	85 c0                	test   %eax,%eax
  801155:	7e 28                	jle    80117f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801162:	00 
  801163:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  80116a:	00 
  80116b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801172:	00 
  801173:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  80117a:	e8 78 f4 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117f:	83 c4 2c             	add    $0x2c,%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
  80118d:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  801190:	b8 05 00 00 00       	mov    $0x5,%eax
  801195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
  80119b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80119e:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	7e 28                	jle    8011d2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  8011bd:	00 
  8011be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c5:	00 
  8011c6:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  8011cd:	e8 25 f4 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011d2:	83 c4 2c             	add    $0x2c,%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8011ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f3:	89 df                	mov    %ebx,%edi
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	7e 28                	jle    801225 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801201:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801208:	00 
  801209:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  801210:	00 
  801211:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801218:	00 
  801219:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  801220:	e8 d2 f3 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801225:	83 c4 2c             	add    $0x2c,%esp
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123b:	b8 08 00 00 00       	mov    $0x8,%eax
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	89 df                	mov    %ebx,%edi
  801248:	89 de                	mov    %ebx,%esi
  80124a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80124c:	85 c0                	test   %eax,%eax
  80124e:	7e 28                	jle    801278 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801250:	89 44 24 10          	mov    %eax,0x10(%esp)
  801254:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80125b:	00 
  80125c:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  801263:	00 
  801264:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126b:	00 
  80126c:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  801273:	e8 7f f3 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801278:	83 c4 2c             	add    $0x2c,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	57                   	push   %edi
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  801289:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128e:	b8 09 00 00 00       	mov    $0x9,%eax
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	8b 55 08             	mov    0x8(%ebp),%edx
  801299:	89 df                	mov    %ebx,%edi
  80129b:	89 de                	mov    %ebx,%esi
  80129d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	7e 28                	jle    8012cb <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012ae:	00 
  8012af:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012be:	00 
  8012bf:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  8012c6:	e8 2c f3 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012cb:	83 c4 2c             	add    $0x2c,%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d9:	be 00 00 00 00       	mov    $0x0,%esi
  8012de:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ef:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8012ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801304:	b8 0c 00 00 00       	mov    $0xc,%eax
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	89 cb                	mov    %ecx,%ebx
  80130e:	89 cf                	mov    %ecx,%edi
  801310:	89 ce                	mov    %ecx,%esi
  801312:	cd 30                	int    $0x30
	if(check && ret > 0)
  801314:	85 c0                	test   %eax,%eax
  801316:	7e 28                	jle    801340 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801318:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131c:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801323:	00 
  801324:	c7 44 24 08 04 1a 80 	movl   $0x801a04,0x8(%esp)
  80132b:	00 
  80132c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801333:	00 
  801334:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  80133b:	e8 b7 f2 ff ff       	call   8005f7 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801340:	83 c4 2c             	add    $0x2c,%esp
  801343:	5b                   	pop    %ebx
  801344:	5e                   	pop    %esi
  801345:	5f                   	pop    %edi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80134e:	83 3d d0 20 80 00 00 	cmpl   $0x0,0x8020d0
  801355:	75 50                	jne    8013a7 <set_pgfault_handler+0x5f>
		// First time through!
		// LAB 4: Your code here.
		if ((r = sys_page_alloc (0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P) < 0))
  801357:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80135e:	00 
  80135f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801366:	ee 
  801367:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136e:	e8 c0 fd ff ff       	call   801133 <sys_page_alloc>
  801373:	85 c0                	test   %eax,%eax
  801375:	79 1c                	jns    801393 <set_pgfault_handler+0x4b>
		{
			panic("set_pgfault_handler: bad sys_page_alloc");
  801377:	c7 44 24 08 30 1a 80 	movl   $0x801a30,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 58 1a 80 00 	movl   $0x801a58,(%esp)
  80138e:	e8 64 f2 ff ff       	call   8005f7 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801393:	c7 44 24 04 b1 13 80 	movl   $0x8013b1,0x4(%esp)
  80139a:	00 
  80139b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a2:	e8 d9 fe ff ff       	call   801280 <sys_env_set_pgfault_upcall>
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	a3 d0 20 80 00       	mov    %eax,0x8020d0
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013b1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013b2:	a1 d0 20 80 00       	mov    0x8020d0,%eax
	call *%eax
  8013b7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013b9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8013bc:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl %esp, %ebx
  8013c0:	89 e3                	mov    %esp,%ebx
	movl 0x30(%esp), %esp
  8013c2:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %edi
  8013c6:	57                   	push   %edi
	movl %ebx, %esp
  8013c7:	89 dc                	mov    %ebx,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  8013c9:	83 c4 08             	add    $0x8,%esp
	popal
  8013cc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $4, %esp
  8013cd:	83 c4 04             	add    $0x4,%esp
	sub $4, 0x4(%esp)
  8013d0:	83 6c 24 04 04       	subl   $0x4,0x4(%esp)
	popfl
  8013d5:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8013d6:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8013d7:	c3                   	ret    
  8013d8:	66 90                	xchg   %ax,%ax
  8013da:	66 90                	xchg   %ax,%ax
  8013dc:	66 90                	xchg   %ax,%ax
  8013de:	66 90                	xchg   %ax,%ax

008013e0 <__udivdi3>:
  8013e0:	55                   	push   %ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8013ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8013ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8013f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013fc:	89 ea                	mov    %ebp,%edx
  8013fe:	89 0c 24             	mov    %ecx,(%esp)
  801401:	75 2d                	jne    801430 <__udivdi3+0x50>
  801403:	39 e9                	cmp    %ebp,%ecx
  801405:	77 61                	ja     801468 <__udivdi3+0x88>
  801407:	85 c9                	test   %ecx,%ecx
  801409:	89 ce                	mov    %ecx,%esi
  80140b:	75 0b                	jne    801418 <__udivdi3+0x38>
  80140d:	b8 01 00 00 00       	mov    $0x1,%eax
  801412:	31 d2                	xor    %edx,%edx
  801414:	f7 f1                	div    %ecx
  801416:	89 c6                	mov    %eax,%esi
  801418:	31 d2                	xor    %edx,%edx
  80141a:	89 e8                	mov    %ebp,%eax
  80141c:	f7 f6                	div    %esi
  80141e:	89 c5                	mov    %eax,%ebp
  801420:	89 f8                	mov    %edi,%eax
  801422:	f7 f6                	div    %esi
  801424:	89 ea                	mov    %ebp,%edx
  801426:	83 c4 0c             	add    $0xc,%esp
  801429:	5e                   	pop    %esi
  80142a:	5f                   	pop    %edi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    
  80142d:	8d 76 00             	lea    0x0(%esi),%esi
  801430:	39 e8                	cmp    %ebp,%eax
  801432:	77 24                	ja     801458 <__udivdi3+0x78>
  801434:	0f bd e8             	bsr    %eax,%ebp
  801437:	83 f5 1f             	xor    $0x1f,%ebp
  80143a:	75 3c                	jne    801478 <__udivdi3+0x98>
  80143c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801440:	39 34 24             	cmp    %esi,(%esp)
  801443:	0f 86 9f 00 00 00    	jbe    8014e8 <__udivdi3+0x108>
  801449:	39 d0                	cmp    %edx,%eax
  80144b:	0f 82 97 00 00 00    	jb     8014e8 <__udivdi3+0x108>
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	31 d2                	xor    %edx,%edx
  80145a:	31 c0                	xor    %eax,%eax
  80145c:	83 c4 0c             	add    $0xc,%esp
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    
  801463:	90                   	nop
  801464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801468:	89 f8                	mov    %edi,%eax
  80146a:	f7 f1                	div    %ecx
  80146c:	31 d2                	xor    %edx,%edx
  80146e:	83 c4 0c             	add    $0xc,%esp
  801471:	5e                   	pop    %esi
  801472:	5f                   	pop    %edi
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    
  801475:	8d 76 00             	lea    0x0(%esi),%esi
  801478:	89 e9                	mov    %ebp,%ecx
  80147a:	8b 3c 24             	mov    (%esp),%edi
  80147d:	d3 e0                	shl    %cl,%eax
  80147f:	89 c6                	mov    %eax,%esi
  801481:	b8 20 00 00 00       	mov    $0x20,%eax
  801486:	29 e8                	sub    %ebp,%eax
  801488:	89 c1                	mov    %eax,%ecx
  80148a:	d3 ef                	shr    %cl,%edi
  80148c:	89 e9                	mov    %ebp,%ecx
  80148e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801492:	8b 3c 24             	mov    (%esp),%edi
  801495:	09 74 24 08          	or     %esi,0x8(%esp)
  801499:	89 d6                	mov    %edx,%esi
  80149b:	d3 e7                	shl    %cl,%edi
  80149d:	89 c1                	mov    %eax,%ecx
  80149f:	89 3c 24             	mov    %edi,(%esp)
  8014a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8014a6:	d3 ee                	shr    %cl,%esi
  8014a8:	89 e9                	mov    %ebp,%ecx
  8014aa:	d3 e2                	shl    %cl,%edx
  8014ac:	89 c1                	mov    %eax,%ecx
  8014ae:	d3 ef                	shr    %cl,%edi
  8014b0:	09 d7                	or     %edx,%edi
  8014b2:	89 f2                	mov    %esi,%edx
  8014b4:	89 f8                	mov    %edi,%eax
  8014b6:	f7 74 24 08          	divl   0x8(%esp)
  8014ba:	89 d6                	mov    %edx,%esi
  8014bc:	89 c7                	mov    %eax,%edi
  8014be:	f7 24 24             	mull   (%esp)
  8014c1:	39 d6                	cmp    %edx,%esi
  8014c3:	89 14 24             	mov    %edx,(%esp)
  8014c6:	72 30                	jb     8014f8 <__udivdi3+0x118>
  8014c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8014cc:	89 e9                	mov    %ebp,%ecx
  8014ce:	d3 e2                	shl    %cl,%edx
  8014d0:	39 c2                	cmp    %eax,%edx
  8014d2:	73 05                	jae    8014d9 <__udivdi3+0xf9>
  8014d4:	3b 34 24             	cmp    (%esp),%esi
  8014d7:	74 1f                	je     8014f8 <__udivdi3+0x118>
  8014d9:	89 f8                	mov    %edi,%eax
  8014db:	31 d2                	xor    %edx,%edx
  8014dd:	e9 7a ff ff ff       	jmp    80145c <__udivdi3+0x7c>
  8014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8014e8:	31 d2                	xor    %edx,%edx
  8014ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ef:	e9 68 ff ff ff       	jmp    80145c <__udivdi3+0x7c>
  8014f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8014fb:	31 d2                	xor    %edx,%edx
  8014fd:	83 c4 0c             	add    $0xc,%esp
  801500:	5e                   	pop    %esi
  801501:	5f                   	pop    %edi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    
  801504:	66 90                	xchg   %ax,%ax
  801506:	66 90                	xchg   %ax,%ax
  801508:	66 90                	xchg   %ax,%ax
  80150a:	66 90                	xchg   %ax,%ax
  80150c:	66 90                	xchg   %ax,%ax
  80150e:	66 90                	xchg   %ax,%ax

00801510 <__umoddi3>:
  801510:	55                   	push   %ebp
  801511:	57                   	push   %edi
  801512:	56                   	push   %esi
  801513:	83 ec 14             	sub    $0x14,%esp
  801516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80151a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80151e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801522:	89 c7                	mov    %eax,%edi
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	8b 44 24 30          	mov    0x30(%esp),%eax
  80152c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801530:	89 34 24             	mov    %esi,(%esp)
  801533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801537:	85 c0                	test   %eax,%eax
  801539:	89 c2                	mov    %eax,%edx
  80153b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80153f:	75 17                	jne    801558 <__umoddi3+0x48>
  801541:	39 fe                	cmp    %edi,%esi
  801543:	76 4b                	jbe    801590 <__umoddi3+0x80>
  801545:	89 c8                	mov    %ecx,%eax
  801547:	89 fa                	mov    %edi,%edx
  801549:	f7 f6                	div    %esi
  80154b:	89 d0                	mov    %edx,%eax
  80154d:	31 d2                	xor    %edx,%edx
  80154f:	83 c4 14             	add    $0x14,%esp
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    
  801556:	66 90                	xchg   %ax,%ax
  801558:	39 f8                	cmp    %edi,%eax
  80155a:	77 54                	ja     8015b0 <__umoddi3+0xa0>
  80155c:	0f bd e8             	bsr    %eax,%ebp
  80155f:	83 f5 1f             	xor    $0x1f,%ebp
  801562:	75 5c                	jne    8015c0 <__umoddi3+0xb0>
  801564:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801568:	39 3c 24             	cmp    %edi,(%esp)
  80156b:	0f 87 e7 00 00 00    	ja     801658 <__umoddi3+0x148>
  801571:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801575:	29 f1                	sub    %esi,%ecx
  801577:	19 c7                	sbb    %eax,%edi
  801579:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80157d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801581:	8b 44 24 08          	mov    0x8(%esp),%eax
  801585:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801589:	83 c4 14             	add    $0x14,%esp
  80158c:	5e                   	pop    %esi
  80158d:	5f                   	pop    %edi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    
  801590:	85 f6                	test   %esi,%esi
  801592:	89 f5                	mov    %esi,%ebp
  801594:	75 0b                	jne    8015a1 <__umoddi3+0x91>
  801596:	b8 01 00 00 00       	mov    $0x1,%eax
  80159b:	31 d2                	xor    %edx,%edx
  80159d:	f7 f6                	div    %esi
  80159f:	89 c5                	mov    %eax,%ebp
  8015a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8015a5:	31 d2                	xor    %edx,%edx
  8015a7:	f7 f5                	div    %ebp
  8015a9:	89 c8                	mov    %ecx,%eax
  8015ab:	f7 f5                	div    %ebp
  8015ad:	eb 9c                	jmp    80154b <__umoddi3+0x3b>
  8015af:	90                   	nop
  8015b0:	89 c8                	mov    %ecx,%eax
  8015b2:	89 fa                	mov    %edi,%edx
  8015b4:	83 c4 14             	add    $0x14,%esp
  8015b7:	5e                   	pop    %esi
  8015b8:	5f                   	pop    %edi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    
  8015bb:	90                   	nop
  8015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8015c0:	8b 04 24             	mov    (%esp),%eax
  8015c3:	be 20 00 00 00       	mov    $0x20,%esi
  8015c8:	89 e9                	mov    %ebp,%ecx
  8015ca:	29 ee                	sub    %ebp,%esi
  8015cc:	d3 e2                	shl    %cl,%edx
  8015ce:	89 f1                	mov    %esi,%ecx
  8015d0:	d3 e8                	shr    %cl,%eax
  8015d2:	89 e9                	mov    %ebp,%ecx
  8015d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d8:	8b 04 24             	mov    (%esp),%eax
  8015db:	09 54 24 04          	or     %edx,0x4(%esp)
  8015df:	89 fa                	mov    %edi,%edx
  8015e1:	d3 e0                	shl    %cl,%eax
  8015e3:	89 f1                	mov    %esi,%ecx
  8015e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8015ed:	d3 ea                	shr    %cl,%edx
  8015ef:	89 e9                	mov    %ebp,%ecx
  8015f1:	d3 e7                	shl    %cl,%edi
  8015f3:	89 f1                	mov    %esi,%ecx
  8015f5:	d3 e8                	shr    %cl,%eax
  8015f7:	89 e9                	mov    %ebp,%ecx
  8015f9:	09 f8                	or     %edi,%eax
  8015fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8015ff:	f7 74 24 04          	divl   0x4(%esp)
  801603:	d3 e7                	shl    %cl,%edi
  801605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801609:	89 d7                	mov    %edx,%edi
  80160b:	f7 64 24 08          	mull   0x8(%esp)
  80160f:	39 d7                	cmp    %edx,%edi
  801611:	89 c1                	mov    %eax,%ecx
  801613:	89 14 24             	mov    %edx,(%esp)
  801616:	72 2c                	jb     801644 <__umoddi3+0x134>
  801618:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80161c:	72 22                	jb     801640 <__umoddi3+0x130>
  80161e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801622:	29 c8                	sub    %ecx,%eax
  801624:	19 d7                	sbb    %edx,%edi
  801626:	89 e9                	mov    %ebp,%ecx
  801628:	89 fa                	mov    %edi,%edx
  80162a:	d3 e8                	shr    %cl,%eax
  80162c:	89 f1                	mov    %esi,%ecx
  80162e:	d3 e2                	shl    %cl,%edx
  801630:	89 e9                	mov    %ebp,%ecx
  801632:	d3 ef                	shr    %cl,%edi
  801634:	09 d0                	or     %edx,%eax
  801636:	89 fa                	mov    %edi,%edx
  801638:	83 c4 14             	add    $0x14,%esp
  80163b:	5e                   	pop    %esi
  80163c:	5f                   	pop    %edi
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    
  80163f:	90                   	nop
  801640:	39 d7                	cmp    %edx,%edi
  801642:	75 da                	jne    80161e <__umoddi3+0x10e>
  801644:	8b 14 24             	mov    (%esp),%edx
  801647:	89 c1                	mov    %eax,%ecx
  801649:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80164d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  801651:	eb cb                	jmp    80161e <__umoddi3+0x10e>
  801653:	90                   	nop
  801654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801658:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80165c:	0f 82 0f ff ff ff    	jb     801571 <__umoddi3+0x61>
  801662:	e9 1a ff ff ff       	jmp    801581 <__umoddi3+0x71>
