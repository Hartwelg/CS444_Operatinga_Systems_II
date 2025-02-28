
obj/user/idle:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 20 80 00 a0 	movl   $0x8010a0,0x802000
  800040:	10 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 0c 01 00 00       	call   800154 <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	83 ec 10             	sub    $0x10,%esp
  800052:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800055:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800058:	e8 d8 00 00 00       	call   800135 <sys_getenvid>
  80005d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800062:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800065:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006a:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006f:	85 db                	test   %ebx,%ebx
  800071:	7e 07                	jle    80007a <libmain+0x30>
		binaryname = argv[0];
  800073:	8b 06                	mov    (%esi),%eax
  800075:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80007a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80007e:	89 1c 24             	mov    %ebx,(%esp)
  800081:	e8 ad ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800086:	e8 07 00 00 00       	call   800092 <exit>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    

00800092 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	sys_env_destroy(0);
  800098:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80009f:	e8 3f 00 00 00       	call   8000e3 <sys_env_destroy>
}
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b7:	89 c3                	mov    %eax,%ebx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 c6                	mov    %eax,%esi
  8000bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bf:	5b                   	pop    %ebx
  8000c0:	5e                   	pop    %esi
  8000c1:	5f                   	pop    %edi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	89 d3                	mov    %edx,%ebx
  8000d8:	89 d7                	mov    %edx,%edi
  8000da:	89 d6                	mov    %edx,%esi
  8000dc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8000ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f9:	89 cb                	mov    %ecx,%ebx
  8000fb:	89 cf                	mov    %ecx,%edi
  8000fd:	89 ce                	mov    %ecx,%esi
  8000ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800101:	85 c0                	test   %eax,%eax
  800103:	7e 28                	jle    80012d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800105:	89 44 24 10          	mov    %eax,0x10(%esp)
  800109:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800110:	00 
  800111:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  800118:	00 
  800119:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800120:	00 
  800121:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  800128:	e8 5b 02 00 00       	call   800388 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012d:	83 c4 2c             	add    $0x2c,%esp
  800130:	5b                   	pop    %ebx
  800131:	5e                   	pop    %esi
  800132:	5f                   	pop    %edi
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    

00800135 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	57                   	push   %edi
  800139:	56                   	push   %esi
  80013a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	b8 02 00 00 00       	mov    $0x2,%eax
  800145:	89 d1                	mov    %edx,%ecx
  800147:	89 d3                	mov    %edx,%ebx
  800149:	89 d7                	mov    %edx,%edi
  80014b:	89 d6                	mov    %edx,%esi
  80014d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <sys_yield>:

void
sys_yield(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	57                   	push   %edi
  800158:	56                   	push   %esi
  800159:	53                   	push   %ebx
	asm volatile("int %1\n"
  80015a:	ba 00 00 00 00       	mov    $0x0,%edx
  80015f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800164:	89 d1                	mov    %edx,%ecx
  800166:	89 d3                	mov    %edx,%ebx
  800168:	89 d7                	mov    %edx,%edi
  80016a:	89 d6                	mov    %edx,%esi
  80016c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5f                   	pop    %edi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	57                   	push   %edi
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  80017c:	be 00 00 00 00       	mov    $0x0,%esi
  800181:	b8 04 00 00 00       	mov    $0x4,%eax
  800186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800189:	8b 55 08             	mov    0x8(%ebp),%edx
  80018c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018f:	89 f7                	mov    %esi,%edi
  800191:	cd 30                	int    $0x30
	if(check && ret > 0)
  800193:	85 c0                	test   %eax,%eax
  800195:	7e 28                	jle    8001bf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800197:	89 44 24 10          	mov    %eax,0x10(%esp)
  80019b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001a2:	00 
  8001a3:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  8001aa:	00 
  8001ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001b2:	00 
  8001b3:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  8001ba:	e8 c9 01 00 00       	call   800388 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001bf:	83 c4 2c             	add    $0x2c,%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8001d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	7e 28                	jle    800212 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001ee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800205:	00 
  800206:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  80020d:	e8 76 01 00 00       	call   800388 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800212:	83 c4 2c             	add    $0x2c,%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800223:	bb 00 00 00 00       	mov    $0x0,%ebx
  800228:	b8 06 00 00 00       	mov    $0x6,%eax
  80022d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	89 df                	mov    %ebx,%edi
  800235:	89 de                	mov    %ebx,%esi
  800237:	cd 30                	int    $0x30
	if(check && ret > 0)
  800239:	85 c0                	test   %eax,%eax
  80023b:	7e 28                	jle    800265 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80023d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800241:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800248:	00 
  800249:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  800250:	00 
  800251:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800258:	00 
  800259:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  800260:	e8 23 01 00 00       	call   800388 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800265:	83 c4 2c             	add    $0x2c,%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    

0080026d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	57                   	push   %edi
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800276:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027b:	b8 08 00 00 00       	mov    $0x8,%eax
  800280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
  800286:	89 df                	mov    %ebx,%edi
  800288:	89 de                	mov    %ebx,%esi
  80028a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028c:	85 c0                	test   %eax,%eax
  80028e:	7e 28                	jle    8002b8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800290:	89 44 24 10          	mov    %eax,0x10(%esp)
  800294:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80029b:	00 
  80029c:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  8002a3:	00 
  8002a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002ab:	00 
  8002ac:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  8002b3:	e8 d0 00 00 00       	call   800388 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002b8:	83 c4 2c             	add    $0x2c,%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8002c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d9:	89 df                	mov    %ebx,%edi
  8002db:	89 de                	mov    %ebx,%esi
  8002dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002df:	85 c0                	test   %eax,%eax
  8002e1:	7e 28                	jle    80030b <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002e7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002ee:	00 
  8002ef:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  8002f6:	00 
  8002f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  800306:	e8 7d 00 00 00       	call   800388 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030b:	83 c4 2c             	add    $0x2c,%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
	asm volatile("int %1\n"
  800319:	be 00 00 00 00       	mov    $0x0,%esi
  80031e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800326:	8b 55 08             	mov    0x8(%ebp),%edx
  800329:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80032c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80032f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800331:	5b                   	pop    %ebx
  800332:	5e                   	pop    %esi
  800333:	5f                   	pop    %edi
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    

00800336 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	57                   	push   %edi
  80033a:	56                   	push   %esi
  80033b:	53                   	push   %ebx
  80033c:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  80033f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800344:	b8 0c 00 00 00       	mov    $0xc,%eax
  800349:	8b 55 08             	mov    0x8(%ebp),%edx
  80034c:	89 cb                	mov    %ecx,%ebx
  80034e:	89 cf                	mov    %ecx,%edi
  800350:	89 ce                	mov    %ecx,%esi
  800352:	cd 30                	int    $0x30
	if(check && ret > 0)
  800354:	85 c0                	test   %eax,%eax
  800356:	7e 28                	jle    800380 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800358:	89 44 24 10          	mov    %eax,0x10(%esp)
  80035c:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800363:	00 
  800364:	c7 44 24 08 af 10 80 	movl   $0x8010af,0x8(%esp)
  80036b:	00 
  80036c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800373:	00 
  800374:	c7 04 24 cc 10 80 00 	movl   $0x8010cc,(%esp)
  80037b:	e8 08 00 00 00       	call   800388 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800380:	83 c4 2c             	add    $0x2c,%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	56                   	push   %esi
  80038c:	53                   	push   %ebx
  80038d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800390:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800393:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800399:	e8 97 fd ff ff       	call   800135 <sys_getenvid>
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003ac:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 dc 10 80 00 	movl   $0x8010dc,(%esp)
  8003bb:	e8 c1 00 00 00       	call   800481 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c7:	89 04 24             	mov    %eax,(%esp)
  8003ca:	e8 51 00 00 00       	call   800420 <vcprintf>
	cprintf("\n");
  8003cf:	c7 04 24 00 11 80 00 	movl   $0x801100,(%esp)
  8003d6:	e8 a6 00 00 00       	call   800481 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003db:	cc                   	int3   
  8003dc:	eb fd                	jmp    8003db <_panic+0x53>

008003de <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	53                   	push   %ebx
  8003e2:	83 ec 14             	sub    $0x14,%esp
  8003e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e8:	8b 13                	mov    (%ebx),%edx
  8003ea:	8d 42 01             	lea    0x1(%edx),%eax
  8003ed:	89 03                	mov    %eax,(%ebx)
  8003ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003fb:	75 19                	jne    800416 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003fd:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800404:	00 
  800405:	8d 43 08             	lea    0x8(%ebx),%eax
  800408:	89 04 24             	mov    %eax,(%esp)
  80040b:	e8 96 fc ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  800410:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800416:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80041a:	83 c4 14             	add    $0x14,%esp
  80041d:	5b                   	pop    %ebx
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800429:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800430:	00 00 00 
	b.cnt = 0;
  800433:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800440:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800451:	89 44 24 04          	mov    %eax,0x4(%esp)
  800455:	c7 04 24 de 03 80 00 	movl   $0x8003de,(%esp)
  80045c:	e8 ad 01 00 00       	call   80060e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800461:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800471:	89 04 24             	mov    %eax,(%esp)
  800474:	e8 2d fc ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  800479:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800487:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80048a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	89 04 24             	mov    %eax,(%esp)
  800494:	e8 87 ff ff ff       	call   800420 <vcprintf>
	va_end(ap);

	return cnt;
}
  800499:	c9                   	leave  
  80049a:	c3                   	ret    
  80049b:	66 90                	xchg   %ax,%ax
  80049d:	66 90                	xchg   %ax,%ax
  80049f:	90                   	nop

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004cd:	39 d9                	cmp    %ebx,%ecx
  8004cf:	72 05                	jb     8004d6 <printnum+0x36>
  8004d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d4:	77 69                	ja     80053f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 ec 08 00 00       	call   800e00 <__udivdi3>
  800514:	89 d9                	mov    %ebx,%ecx
  800516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	89 54 24 04          	mov    %edx,0x4(%esp)
  800525:	89 fa                	mov    %edi,%edx
  800527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052a:	e8 71 ff ff ff       	call   8004a0 <printnum>
  80052f:	eb 1b                	jmp    80054c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800535:	8b 45 18             	mov    0x18(%ebp),%eax
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff d3                	call   *%ebx
  80053d:	eb 03                	jmp    800542 <printnum+0xa2>
  80053f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while (--width > 0)
  800542:	83 ee 01             	sub    $0x1,%esi
  800545:	85 f6                	test   %esi,%esi
  800547:	7f e8                	jg     800531 <printnum+0x91>
  800549:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800550:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80055e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056f:	e8 bc 09 00 00       	call   800f30 <__umoddi3>
  800574:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800578:	0f be 80 02 11 80 00 	movsbl 0x801102(%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800585:	ff d0                	call   *%eax
}
  800587:	83 c4 3c             	add    $0x3c,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5f                   	pop    %edi
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800592:	83 fa 01             	cmp    $0x1,%edx
  800595:	7e 0e                	jle    8005a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800597:	8b 10                	mov    (%eax),%edx
  800599:	8d 4a 08             	lea    0x8(%edx),%ecx
  80059c:	89 08                	mov    %ecx,(%eax)
  80059e:	8b 02                	mov    (%edx),%eax
  8005a0:	8b 52 04             	mov    0x4(%edx),%edx
  8005a3:	eb 22                	jmp    8005c7 <getuint+0x38>
	else if (lflag)
  8005a5:	85 d2                	test   %edx,%edx
  8005a7:	74 10                	je     8005b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ae:	89 08                	mov    %ecx,(%eax)
  8005b0:	8b 02                	mov    (%edx),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	eb 0e                	jmp    8005c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c7:	5d                   	pop    %ebp
  8005c8:	c3                   	ret    

008005c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d3:	8b 10                	mov    (%eax),%edx
  8005d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d8:	73 0a                	jae    8005e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005dd:	89 08                	mov    %ecx,(%eax)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 02                	mov    %al,(%edx)
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <printfmt>:
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	83 ec 18             	sub    $0x18,%esp
	va_start(ap, fmt);
  8005ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	e8 02 00 00 00       	call   80060e <vprintfmt>
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <vprintfmt>:
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	57                   	push   %edi
  800612:	56                   	push   %esi
  800613:	53                   	push   %ebx
  800614:	83 ec 3c             	sub    $0x3c,%esp
  800617:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80061a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061d:	eb 14                	jmp    800633 <vprintfmt+0x25>
			if (ch == '\0')
  80061f:	85 c0                	test   %eax,%eax
  800621:	0f 84 b3 03 00 00    	je     8009da <vprintfmt+0x3cc>
			putch(ch, putdat);
  800627:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	ff 55 08             	call   *0x8(%ebp)
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800631:	89 f3                	mov    %esi,%ebx
  800633:	8d 73 01             	lea    0x1(%ebx),%esi
  800636:	0f b6 03             	movzbl (%ebx),%eax
  800639:	83 f8 25             	cmp    $0x25,%eax
  80063c:	75 e1                	jne    80061f <vprintfmt+0x11>
  80063e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800642:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800649:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800650:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	eb 1d                	jmp    80067b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  80065e:	89 de                	mov    %ebx,%esi
			padc = '-';
  800660:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800664:	eb 15                	jmp    80067b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			padc = '0';
  800668:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80066c:	eb 0d                	jmp    80067b <vprintfmt+0x6d>
				width = precision, precision = -1;
  80066e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800671:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800674:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80067e:	0f b6 0e             	movzbl (%esi),%ecx
  800681:	0f b6 c1             	movzbl %cl,%eax
  800684:	83 e9 23             	sub    $0x23,%ecx
  800687:	80 f9 55             	cmp    $0x55,%cl
  80068a:	0f 87 2a 03 00 00    	ja     8009ba <vprintfmt+0x3ac>
  800690:	0f b6 c9             	movzbl %cl,%ecx
  800693:	ff 24 8d c0 11 80 00 	jmp    *0x8011c0(,%ecx,4)
  80069a:	89 de                	mov    %ebx,%esi
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
				precision = precision * 10 + ch - '0';
  8006a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006ae:	83 fb 09             	cmp    $0x9,%ebx
  8006b1:	77 36                	ja     8006e9 <vprintfmt+0xdb>
			for (precision = 0; ; ++fmt) {
  8006b3:	83 c6 01             	add    $0x1,%esi
			}
  8006b6:	eb e9                	jmp    8006a1 <vprintfmt+0x93>
			precision = va_arg(ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	89 de                	mov    %ebx,%esi
			goto process_precision;
  8006c8:	eb 22                	jmp    8006ec <vprintfmt+0xde>
  8006ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d4:	0f 49 c1             	cmovns %ecx,%eax
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	eb 9d                	jmp    80067b <vprintfmt+0x6d>
  8006de:	89 de                	mov    %ebx,%esi
			altflag = 1;
  8006e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006e7:	eb 92                	jmp    80067b <vprintfmt+0x6d>
  8006e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
			if (width < 0)
  8006ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f0:	79 89                	jns    80067b <vprintfmt+0x6d>
  8006f2:	e9 77 ff ff ff       	jmp    80066e <vprintfmt+0x60>
			lflag++;
  8006f7:	83 c2 01             	add    $0x1,%edx
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	89 de                	mov    %ebx,%esi
			goto reswitch;
  8006fc:	e9 7a ff ff ff       	jmp    80067b <vprintfmt+0x6d>
			putch(va_arg(ap, int), putdat);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	89 55 14             	mov    %edx,0x14(%ebp)
  80070a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 04 24             	mov    %eax,(%esp)
  800713:	ff 55 08             	call   *0x8(%ebp)
			break;
  800716:	e9 18 ff ff ff       	jmp    800633 <vprintfmt+0x25>
			err = va_arg(ap, int);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	89 55 14             	mov    %edx,0x14(%ebp)
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	31 d0                	xor    %edx,%eax
  800729:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072b:	83 f8 08             	cmp    $0x8,%eax
  80072e:	7f 0b                	jg     80073b <vprintfmt+0x12d>
  800730:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  800737:	85 d2                	test   %edx,%edx
  800739:	75 20                	jne    80075b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80073b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073f:	c7 44 24 08 1a 11 80 	movl   $0x80111a,0x8(%esp)
  800746:	00 
  800747:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	e8 90 fe ff ff       	call   8005e6 <printfmt>
  800756:	e9 d8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
				printfmt(putch, putdat, "%s", p);
  80075b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80075f:	c7 44 24 08 23 11 80 	movl   $0x801123,0x8(%esp)
  800766:	00 
  800767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	e8 70 fe ff ff       	call   8005e6 <printfmt>
  800776:	e9 b8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
		switch (ch = *(unsigned char *) fmt++) {
  80077b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800781:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	89 55 14             	mov    %edx,0x14(%ebp)
  80078d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80078f:	85 f6                	test   %esi,%esi
  800791:	b8 13 11 80 00       	mov    $0x801113,%eax
  800796:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800799:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80079d:	0f 84 97 00 00 00    	je     80083a <vprintfmt+0x22c>
  8007a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007a7:	0f 8e 9b 00 00 00    	jle    800848 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b1:	89 34 24             	mov    %esi,(%esp)
  8007b4:	e8 cf 02 00 00       	call   800a88 <strnlen>
  8007b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007bc:	29 c2                	sub    %eax,%edx
  8007be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007d1:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d3:	eb 0f                	jmp    8007e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007dc:	89 04 24             	mov    %eax,(%esp)
  8007df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e1:	83 eb 01             	sub    $0x1,%ebx
  8007e4:	85 db                	test   %ebx,%ebx
  8007e6:	7f ed                	jg     8007d5 <vprintfmt+0x1c7>
  8007e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	0f 49 c2             	cmovns %edx,%eax
  8007f8:	29 c2                	sub    %eax,%edx
  8007fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007fd:	89 d7                	mov    %edx,%edi
  8007ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800802:	eb 50                	jmp    800854 <vprintfmt+0x246>
				if (altflag && (ch < ' ' || ch > '~'))
  800804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800808:	74 1e                	je     800828 <vprintfmt+0x21a>
  80080a:	0f be d2             	movsbl %dl,%edx
  80080d:	83 ea 20             	sub    $0x20,%edx
  800810:	83 fa 5e             	cmp    $0x5e,%edx
  800813:	76 13                	jbe    800828 <vprintfmt+0x21a>
					putch('?', putdat);
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800823:	ff 55 08             	call   *0x8(%ebp)
  800826:	eb 0d                	jmp    800835 <vprintfmt+0x227>
					putch(ch, putdat);
  800828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082f:	89 04 24             	mov    %eax,(%esp)
  800832:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800835:	83 ef 01             	sub    $0x1,%edi
  800838:	eb 1a                	jmp    800854 <vprintfmt+0x246>
  80083a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800840:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800843:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800846:	eb 0c                	jmp    800854 <vprintfmt+0x246>
  800848:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80084e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800851:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800854:	83 c6 01             	add    $0x1,%esi
  800857:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80085b:	0f be c2             	movsbl %dl,%eax
  80085e:	85 c0                	test   %eax,%eax
  800860:	74 27                	je     800889 <vprintfmt+0x27b>
  800862:	85 db                	test   %ebx,%ebx
  800864:	78 9e                	js     800804 <vprintfmt+0x1f6>
  800866:	83 eb 01             	sub    $0x1,%ebx
  800869:	79 99                	jns    800804 <vprintfmt+0x1f6>
  80086b:	89 f8                	mov    %edi,%eax
  80086d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800870:	8b 75 08             	mov    0x8(%ebp),%esi
  800873:	89 c3                	mov    %eax,%ebx
  800875:	eb 1a                	jmp    800891 <vprintfmt+0x283>
				putch(' ', putdat);
  800877:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800882:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800884:	83 eb 01             	sub    $0x1,%ebx
  800887:	eb 08                	jmp    800891 <vprintfmt+0x283>
  800889:	89 fb                	mov    %edi,%ebx
  80088b:	8b 75 08             	mov    0x8(%ebp),%esi
  80088e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800891:	85 db                	test   %ebx,%ebx
  800893:	7f e2                	jg     800877 <vprintfmt+0x269>
  800895:	89 75 08             	mov    %esi,0x8(%ebp)
  800898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089b:	e9 93 fd ff ff       	jmp    800633 <vprintfmt+0x25>
	if (lflag >= 2)
  8008a0:	83 fa 01             	cmp    $0x1,%edx
  8008a3:	7e 16                	jle    8008bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 50 08             	lea    0x8(%eax),%edx
  8008ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ae:	8b 50 04             	mov    0x4(%eax),%edx
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008b9:	eb 32                	jmp    8008ed <vprintfmt+0x2df>
	else if (lflag)
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	74 18                	je     8008d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 50 04             	lea    0x4(%eax),%edx
  8008c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c8:	8b 30                	mov    (%eax),%esi
  8008ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008cd:	89 f0                	mov    %esi,%eax
  8008cf:	c1 f8 1f             	sar    $0x1f,%eax
  8008d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x2df>
		return va_arg(*ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 50 04             	lea    0x4(%eax),%edx
  8008dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e0:	8b 30                	mov    (%eax),%esi
  8008e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	c1 f8 1f             	sar    $0x1f,%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			num = getint(&ap, lflag);
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			base = 10;
  8008f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			if ((long long) num < 0) {
  8008f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fc:	0f 89 80 00 00 00    	jns    800982 <vprintfmt+0x374>
				putch('-', putdat);
  800902:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800906:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80090d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800916:	f7 d8                	neg    %eax
  800918:	83 d2 00             	adc    $0x0,%edx
  80091b:	f7 da                	neg    %edx
			base = 10;
  80091d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800922:	eb 5e                	jmp    800982 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
  800927:	e8 63 fc ff ff       	call   80058f <getuint>
			base = 10;
  80092c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800931:	eb 4f                	jmp    800982 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800933:	8d 45 14             	lea    0x14(%ebp),%eax
  800936:	e8 54 fc ff ff       	call   80058f <getuint>
			base = 8;
  80093b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800940:	eb 40                	jmp    800982 <vprintfmt+0x374>
			putch('0', putdat);
  800942:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800946:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80094d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800950:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800954:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80095b:	ff 55 08             	call   *0x8(%ebp)
				(uintptr_t) va_arg(ap, void *);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800967:	8b 00                	mov    (%eax),%eax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
			base = 16;
  80096e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800973:	eb 0d                	jmp    800982 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	e8 12 fc ff ff       	call   80058f <getuint>
			base = 16;
  80097d:	b9 10 00 00 00       	mov    $0x10,%ecx
			printnum(putch, putdat, num, base, width, padc);
  800982:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800986:	89 74 24 10          	mov    %esi,0x10(%esp)
  80098a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80098d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800991:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800995:	89 04 24             	mov    %eax,(%esp)
  800998:	89 54 24 04          	mov    %edx,0x4(%esp)
  80099c:	89 fa                	mov    %edi,%edx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	e8 fa fa ff ff       	call   8004a0 <printnum>
			break;
  8009a6:	e9 88 fc ff ff       	jmp    800633 <vprintfmt+0x25>
			putch(ch, putdat);
  8009ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009af:	89 04 24             	mov    %eax,(%esp)
  8009b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009b5:	e9 79 fc ff ff       	jmp    800633 <vprintfmt+0x25>
			putch('%', putdat);
  8009ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c8:	89 f3                	mov    %esi,%ebx
  8009ca:	eb 03                	jmp    8009cf <vprintfmt+0x3c1>
  8009cc:	83 eb 01             	sub    $0x1,%ebx
  8009cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009d3:	75 f7                	jne    8009cc <vprintfmt+0x3be>
  8009d5:	e9 59 fc ff ff       	jmp    800633 <vprintfmt+0x25>
}
  8009da:	83 c4 3c             	add    $0x3c,%esp
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5f                   	pop    %edi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 28             	sub    $0x28,%esp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ff:	85 c0                	test   %eax,%eax
  800a01:	74 30                	je     800a33 <vsnprintf+0x51>
  800a03:	85 d2                	test   %edx,%edx
  800a05:	7e 2c                	jle    800a33 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a11:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1c:	c7 04 24 c9 05 80 00 	movl   $0x8005c9,(%esp)
  800a23:	e8 e6 fb ff ff       	call   80060e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a31:	eb 05                	jmp    800a38 <vsnprintf+0x56>
		return -E_INVAL;
  800a33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	89 04 24             	mov    %eax,(%esp)
  800a5b:	e8 82 ff ff ff       	call   8009e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    
  800a62:	66 90                	xchg   %ax,%ax
  800a64:	66 90                	xchg   %ax,%ax
  800a66:	66 90                	xchg   %ax,%ax
  800a68:	66 90                	xchg   %ax,%ax
  800a6a:	66 90                	xchg   %ax,%ax
  800a6c:	66 90                	xchg   %ax,%ax
  800a6e:	66 90                	xchg   %ax,%ax

00800a70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	eb 03                	jmp    800a80 <strlen+0x10>
		n++;
  800a7d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a84:	75 f7                	jne    800a7d <strlen+0xd>
	return n;
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	eb 03                	jmp    800a9b <strnlen+0x13>
		n++;
  800a98:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	74 06                	je     800aa5 <strnlen+0x1d>
  800a9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aa3:	75 f3                	jne    800a98 <strnlen+0x10>
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab1:	89 c2                	mov    %eax,%edx
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800abd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac0:	84 db                	test   %bl,%bl
  800ac2:	75 ef                	jne    800ab3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad1:	89 1c 24             	mov    %ebx,(%esp)
  800ad4:	e8 97 ff ff ff       	call   800a70 <strlen>
	strcpy(dst + len, src);
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ae0:	01 d8                	add    %ebx,%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 bd ff ff ff       	call   800aa7 <strcpy>
	return dst;
}
  800aea:	89 d8                	mov    %ebx,%eax
  800aec:	83 c4 08             	add    $0x8,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 75 08             	mov    0x8(%ebp),%esi
  800afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afd:	89 f3                	mov    %esi,%ebx
  800aff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b02:	89 f2                	mov    %esi,%edx
  800b04:	eb 0f                	jmp    800b15 <strncpy+0x23>
		*dst++ = *src;
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	0f b6 01             	movzbl (%ecx),%eax
  800b0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b12:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b15:	39 da                	cmp    %ebx,%edx
  800b17:	75 ed                	jne    800b06 <strncpy+0x14>
	}
	return ret;
}
  800b19:	89 f0                	mov    %esi,%eax
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 75 08             	mov    0x8(%ebp),%esi
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b33:	85 c9                	test   %ecx,%ecx
  800b35:	75 0b                	jne    800b42 <strlcpy+0x23>
  800b37:	eb 1d                	jmp    800b56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b39:	83 c0 01             	add    $0x1,%eax
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b42:	39 d8                	cmp    %ebx,%eax
  800b44:	74 0b                	je     800b51 <strlcpy+0x32>
  800b46:	0f b6 0a             	movzbl (%edx),%ecx
  800b49:	84 c9                	test   %cl,%cl
  800b4b:	75 ec                	jne    800b39 <strlcpy+0x1a>
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	eb 02                	jmp    800b53 <strlcpy+0x34>
  800b51:	89 c2                	mov    %eax,%edx
		*dst = '\0';
  800b53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b56:	29 f0                	sub    %esi,%eax
}
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b65:	eb 06                	jmp    800b6d <strcmp+0x11>
		p++, q++;
  800b67:	83 c1 01             	add    $0x1,%ecx
  800b6a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b6d:	0f b6 01             	movzbl (%ecx),%eax
  800b70:	84 c0                	test   %al,%al
  800b72:	74 04                	je     800b78 <strcmp+0x1c>
  800b74:	3a 02                	cmp    (%edx),%al
  800b76:	74 ef                	je     800b67 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	0f b6 12             	movzbl (%edx),%edx
  800b7e:	29 d0                	sub    %edx,%eax
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b91:	eb 06                	jmp    800b99 <strncmp+0x17>
		n--, p++, q++;
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b99:	39 d8                	cmp    %ebx,%eax
  800b9b:	74 15                	je     800bb2 <strncmp+0x30>
  800b9d:	0f b6 08             	movzbl (%eax),%ecx
  800ba0:	84 c9                	test   %cl,%cl
  800ba2:	74 04                	je     800ba8 <strncmp+0x26>
  800ba4:	3a 0a                	cmp    (%edx),%cl
  800ba6:	74 eb                	je     800b93 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba8:	0f b6 00             	movzbl (%eax),%eax
  800bab:	0f b6 12             	movzbl (%edx),%edx
  800bae:	29 d0                	sub    %edx,%eax
  800bb0:	eb 05                	jmp    800bb7 <strncmp+0x35>
		return 0;
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc4:	eb 07                	jmp    800bcd <strchr+0x13>
		if (*s == c)
  800bc6:	38 ca                	cmp    %cl,%dl
  800bc8:	74 0f                	je     800bd9 <strchr+0x1f>
	for (; *s; s++)
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	0f b6 10             	movzbl (%eax),%edx
  800bd0:	84 d2                	test   %dl,%dl
  800bd2:	75 f2                	jne    800bc6 <strchr+0xc>
			return (char *) s;
	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be5:	eb 07                	jmp    800bee <strfind+0x13>
		if (*s == c)
  800be7:	38 ca                	cmp    %cl,%dl
  800be9:	74 0a                	je     800bf5 <strfind+0x1a>
	for (; *s; s++)
  800beb:	83 c0 01             	add    $0x1,%eax
  800bee:	0f b6 10             	movzbl (%eax),%edx
  800bf1:	84 d2                	test   %dl,%dl
  800bf3:	75 f2                	jne    800be7 <strfind+0xc>
			break;
	return (char *) s;
}
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c03:	85 c9                	test   %ecx,%ecx
  800c05:	74 36                	je     800c3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c0d:	75 28                	jne    800c37 <memset+0x40>
  800c0f:	f6 c1 03             	test   $0x3,%cl
  800c12:	75 23                	jne    800c37 <memset+0x40>
		c &= 0xFF;
  800c14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c18:	89 d3                	mov    %edx,%ebx
  800c1a:	c1 e3 08             	shl    $0x8,%ebx
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	c1 e6 18             	shl    $0x18,%esi
  800c22:	89 d0                	mov    %edx,%eax
  800c24:	c1 e0 10             	shl    $0x10,%eax
  800c27:	09 f0                	or     %esi,%eax
  800c29:	09 c2                	or     %eax,%edx
  800c2b:	89 d0                	mov    %edx,%eax
  800c2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c2f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c32:	fc                   	cld    
  800c33:	f3 ab                	rep stos %eax,%es:(%edi)
  800c35:	eb 06                	jmp    800c3d <memset+0x46>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	fc                   	cld    
  800c3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c3d:	89 f8                	mov    %edi,%eax
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c52:	39 c6                	cmp    %eax,%esi
  800c54:	73 35                	jae    800c8b <memmove+0x47>
  800c56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c59:	39 d0                	cmp    %edx,%eax
  800c5b:	73 2e                	jae    800c8b <memmove+0x47>
		s += n;
		d += n;
  800c5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c6a:	75 13                	jne    800c7f <memmove+0x3b>
  800c6c:	f6 c1 03             	test   $0x3,%cl
  800c6f:	75 0e                	jne    800c7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c71:	83 ef 04             	sub    $0x4,%edi
  800c74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c77:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c7a:	fd                   	std    
  800c7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7d:	eb 09                	jmp    800c88 <memmove+0x44>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c7f:	83 ef 01             	sub    $0x1,%edi
  800c82:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c85:	fd                   	std    
  800c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c88:	fc                   	cld    
  800c89:	eb 1d                	jmp    800ca8 <memmove+0x64>
  800c8b:	89 f2                	mov    %esi,%edx
  800c8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8f:	f6 c2 03             	test   $0x3,%dl
  800c92:	75 0f                	jne    800ca3 <memmove+0x5f>
  800c94:	f6 c1 03             	test   $0x3,%cl
  800c97:	75 0a                	jne    800ca3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c9c:	89 c7                	mov    %eax,%edi
  800c9e:	fc                   	cld    
  800c9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca1:	eb 05                	jmp    800ca8 <memmove+0x64>
		else
			asm volatile("cld; rep movsb\n"
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	fc                   	cld    
  800ca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 04 24             	mov    %eax,(%esp)
  800cc6:	e8 79 ff ff ff       	call   800c44 <memmove>
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cdd:	eb 1a                	jmp    800cf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800cdf:	0f b6 02             	movzbl (%edx),%eax
  800ce2:	0f b6 19             	movzbl (%ecx),%ebx
  800ce5:	38 d8                	cmp    %bl,%al
  800ce7:	74 0a                	je     800cf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ce9:	0f b6 c0             	movzbl %al,%eax
  800cec:	0f b6 db             	movzbl %bl,%ebx
  800cef:	29 d8                	sub    %ebx,%eax
  800cf1:	eb 0f                	jmp    800d02 <memcmp+0x35>
		s1++, s2++;
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	83 c1 01             	add    $0x1,%ecx
	while (n-- > 0) {
  800cf9:	39 f2                	cmp    %esi,%edx
  800cfb:	75 e2                	jne    800cdf <memcmp+0x12>
	}

	return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d14:	eb 07                	jmp    800d1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d16:	38 08                	cmp    %cl,(%eax)
  800d18:	74 07                	je     800d21 <memfind+0x1b>
	for (; s < ends; s++)
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	39 d0                	cmp    %edx,%eax
  800d1f:	72 f5                	jb     800d16 <memfind+0x10>
			break;
	return (void *) s;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2f:	eb 03                	jmp    800d34 <strtol+0x11>
		s++;
  800d31:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d34:	0f b6 0a             	movzbl (%edx),%ecx
  800d37:	80 f9 09             	cmp    $0x9,%cl
  800d3a:	74 f5                	je     800d31 <strtol+0xe>
  800d3c:	80 f9 20             	cmp    $0x20,%cl
  800d3f:	74 f0                	je     800d31 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d41:	80 f9 2b             	cmp    $0x2b,%cl
  800d44:	75 0a                	jne    800d50 <strtol+0x2d>
		s++;
  800d46:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d49:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4e:	eb 11                	jmp    800d61 <strtol+0x3e>
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
	else if (*s == '-')
  800d55:	80 f9 2d             	cmp    $0x2d,%cl
  800d58:	75 07                	jne    800d61 <strtol+0x3e>
		s++, neg = 1;
  800d5a:	8d 52 01             	lea    0x1(%edx),%edx
  800d5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d66:	75 15                	jne    800d7d <strtol+0x5a>
  800d68:	80 3a 30             	cmpb   $0x30,(%edx)
  800d6b:	75 10                	jne    800d7d <strtol+0x5a>
  800d6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d71:	75 0a                	jne    800d7d <strtol+0x5a>
		s += 2, base = 16;
  800d73:	83 c2 02             	add    $0x2,%edx
  800d76:	b8 10 00 00 00       	mov    $0x10,%eax
  800d7b:	eb 10                	jmp    800d8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	75 0c                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d81:	b0 0a                	mov    $0xa,%al
	else if (base == 0 && s[0] == '0')
  800d83:	80 3a 30             	cmpb   $0x30,(%edx)
  800d86:	75 05                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
  800d88:	83 c2 01             	add    $0x1,%edx
  800d8b:	b0 08                	mov    $0x8,%al
		base = 10;
  800d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d95:	0f b6 0a             	movzbl (%edx),%ecx
  800d98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d9b:	89 f0                	mov    %esi,%eax
  800d9d:	3c 09                	cmp    $0x9,%al
  800d9f:	77 08                	ja     800da9 <strtol+0x86>
			dig = *s - '0';
  800da1:	0f be c9             	movsbl %cl,%ecx
  800da4:	83 e9 30             	sub    $0x30,%ecx
  800da7:	eb 20                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800da9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dac:	89 f0                	mov    %esi,%eax
  800dae:	3c 19                	cmp    $0x19,%al
  800db0:	77 08                	ja     800dba <strtol+0x97>
			dig = *s - 'a' + 10;
  800db2:	0f be c9             	movsbl %cl,%ecx
  800db5:	83 e9 57             	sub    $0x57,%ecx
  800db8:	eb 0f                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dbd:	89 f0                	mov    %esi,%eax
  800dbf:	3c 19                	cmp    $0x19,%al
  800dc1:	77 16                	ja     800dd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dc3:	0f be c9             	movsbl %cl,%ecx
  800dc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dcc:	7d 0f                	jge    800ddd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dd7:	eb bc                	jmp    800d95 <strtol+0x72>
  800dd9:	89 d8                	mov    %ebx,%eax
  800ddb:	eb 02                	jmp    800ddf <strtol+0xbc>
  800ddd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	74 05                	je     800dea <strtol+0xc7>
		*endptr = (char *) s;
  800de5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dea:	f7 d8                	neg    %eax
  800dec:	85 ff                	test   %edi,%edi
  800dee:	0f 44 c3             	cmove  %ebx,%eax
}
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
  800df6:	66 90                	xchg   %ax,%ax
  800df8:	66 90                	xchg   %ax,%ax
  800dfa:	66 90                	xchg   %ax,%ax
  800dfc:	66 90                	xchg   %ax,%ax
  800dfe:	66 90                	xchg   %ax,%ax

00800e00 <__udivdi3>:
  800e00:	55                   	push   %ebp
  800e01:	57                   	push   %edi
  800e02:	56                   	push   %esi
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	8b 44 24 28          	mov    0x28(%esp),%eax
  800e0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  800e0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  800e12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  800e16:	85 c0                	test   %eax,%eax
  800e18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e1c:	89 ea                	mov    %ebp,%edx
  800e1e:	89 0c 24             	mov    %ecx,(%esp)
  800e21:	75 2d                	jne    800e50 <__udivdi3+0x50>
  800e23:	39 e9                	cmp    %ebp,%ecx
  800e25:	77 61                	ja     800e88 <__udivdi3+0x88>
  800e27:	85 c9                	test   %ecx,%ecx
  800e29:	89 ce                	mov    %ecx,%esi
  800e2b:	75 0b                	jne    800e38 <__udivdi3+0x38>
  800e2d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e32:	31 d2                	xor    %edx,%edx
  800e34:	f7 f1                	div    %ecx
  800e36:	89 c6                	mov    %eax,%esi
  800e38:	31 d2                	xor    %edx,%edx
  800e3a:	89 e8                	mov    %ebp,%eax
  800e3c:	f7 f6                	div    %esi
  800e3e:	89 c5                	mov    %eax,%ebp
  800e40:	89 f8                	mov    %edi,%eax
  800e42:	f7 f6                	div    %esi
  800e44:	89 ea                	mov    %ebp,%edx
  800e46:	83 c4 0c             	add    $0xc,%esp
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
  800e4d:	8d 76 00             	lea    0x0(%esi),%esi
  800e50:	39 e8                	cmp    %ebp,%eax
  800e52:	77 24                	ja     800e78 <__udivdi3+0x78>
  800e54:	0f bd e8             	bsr    %eax,%ebp
  800e57:	83 f5 1f             	xor    $0x1f,%ebp
  800e5a:	75 3c                	jne    800e98 <__udivdi3+0x98>
  800e5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e60:	39 34 24             	cmp    %esi,(%esp)
  800e63:	0f 86 9f 00 00 00    	jbe    800f08 <__udivdi3+0x108>
  800e69:	39 d0                	cmp    %edx,%eax
  800e6b:	0f 82 97 00 00 00    	jb     800f08 <__udivdi3+0x108>
  800e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e78:	31 d2                	xor    %edx,%edx
  800e7a:	31 c0                	xor    %eax,%eax
  800e7c:	83 c4 0c             	add    $0xc,%esp
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    
  800e83:	90                   	nop
  800e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e88:	89 f8                	mov    %edi,%eax
  800e8a:	f7 f1                	div    %ecx
  800e8c:	31 d2                	xor    %edx,%edx
  800e8e:	83 c4 0c             	add    $0xc,%esp
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
  800e95:	8d 76 00             	lea    0x0(%esi),%esi
  800e98:	89 e9                	mov    %ebp,%ecx
  800e9a:	8b 3c 24             	mov    (%esp),%edi
  800e9d:	d3 e0                	shl    %cl,%eax
  800e9f:	89 c6                	mov    %eax,%esi
  800ea1:	b8 20 00 00 00       	mov    $0x20,%eax
  800ea6:	29 e8                	sub    %ebp,%eax
  800ea8:	89 c1                	mov    %eax,%ecx
  800eaa:	d3 ef                	shr    %cl,%edi
  800eac:	89 e9                	mov    %ebp,%ecx
  800eae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800eb2:	8b 3c 24             	mov    (%esp),%edi
  800eb5:	09 74 24 08          	or     %esi,0x8(%esp)
  800eb9:	89 d6                	mov    %edx,%esi
  800ebb:	d3 e7                	shl    %cl,%edi
  800ebd:	89 c1                	mov    %eax,%ecx
  800ebf:	89 3c 24             	mov    %edi,(%esp)
  800ec2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ec6:	d3 ee                	shr    %cl,%esi
  800ec8:	89 e9                	mov    %ebp,%ecx
  800eca:	d3 e2                	shl    %cl,%edx
  800ecc:	89 c1                	mov    %eax,%ecx
  800ece:	d3 ef                	shr    %cl,%edi
  800ed0:	09 d7                	or     %edx,%edi
  800ed2:	89 f2                	mov    %esi,%edx
  800ed4:	89 f8                	mov    %edi,%eax
  800ed6:	f7 74 24 08          	divl   0x8(%esp)
  800eda:	89 d6                	mov    %edx,%esi
  800edc:	89 c7                	mov    %eax,%edi
  800ede:	f7 24 24             	mull   (%esp)
  800ee1:	39 d6                	cmp    %edx,%esi
  800ee3:	89 14 24             	mov    %edx,(%esp)
  800ee6:	72 30                	jb     800f18 <__udivdi3+0x118>
  800ee8:	8b 54 24 04          	mov    0x4(%esp),%edx
  800eec:	89 e9                	mov    %ebp,%ecx
  800eee:	d3 e2                	shl    %cl,%edx
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	73 05                	jae    800ef9 <__udivdi3+0xf9>
  800ef4:	3b 34 24             	cmp    (%esp),%esi
  800ef7:	74 1f                	je     800f18 <__udivdi3+0x118>
  800ef9:	89 f8                	mov    %edi,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	e9 7a ff ff ff       	jmp    800e7c <__udivdi3+0x7c>
  800f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f08:	31 d2                	xor    %edx,%edx
  800f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800f0f:	e9 68 ff ff ff       	jmp    800e7c <__udivdi3+0x7c>
  800f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f18:	8d 47 ff             	lea    -0x1(%edi),%eax
  800f1b:	31 d2                	xor    %edx,%edx
  800f1d:	83 c4 0c             	add    $0xc,%esp
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    
  800f24:	66 90                	xchg   %ax,%ax
  800f26:	66 90                	xchg   %ax,%ax
  800f28:	66 90                	xchg   %ax,%ax
  800f2a:	66 90                	xchg   %ax,%ax
  800f2c:	66 90                	xchg   %ax,%ax
  800f2e:	66 90                	xchg   %ax,%ax

00800f30 <__umoddi3>:
  800f30:	55                   	push   %ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	83 ec 14             	sub    $0x14,%esp
  800f36:	8b 44 24 28          	mov    0x28(%esp),%eax
  800f3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  800f3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  800f42:	89 c7                	mov    %eax,%edi
  800f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f48:	8b 44 24 30          	mov    0x30(%esp),%eax
  800f4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800f50:	89 34 24             	mov    %esi,(%esp)
  800f53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f5f:	75 17                	jne    800f78 <__umoddi3+0x48>
  800f61:	39 fe                	cmp    %edi,%esi
  800f63:	76 4b                	jbe    800fb0 <__umoddi3+0x80>
  800f65:	89 c8                	mov    %ecx,%eax
  800f67:	89 fa                	mov    %edi,%edx
  800f69:	f7 f6                	div    %esi
  800f6b:	89 d0                	mov    %edx,%eax
  800f6d:	31 d2                	xor    %edx,%edx
  800f6f:	83 c4 14             	add    $0x14,%esp
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
  800f76:	66 90                	xchg   %ax,%ax
  800f78:	39 f8                	cmp    %edi,%eax
  800f7a:	77 54                	ja     800fd0 <__umoddi3+0xa0>
  800f7c:	0f bd e8             	bsr    %eax,%ebp
  800f7f:	83 f5 1f             	xor    $0x1f,%ebp
  800f82:	75 5c                	jne    800fe0 <__umoddi3+0xb0>
  800f84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f88:	39 3c 24             	cmp    %edi,(%esp)
  800f8b:	0f 87 e7 00 00 00    	ja     801078 <__umoddi3+0x148>
  800f91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f95:	29 f1                	sub    %esi,%ecx
  800f97:	19 c7                	sbb    %eax,%edi
  800f99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800fa1:	8b 44 24 08          	mov    0x8(%esp),%eax
  800fa5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800fa9:	83 c4 14             	add    $0x14,%esp
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    
  800fb0:	85 f6                	test   %esi,%esi
  800fb2:	89 f5                	mov    %esi,%ebp
  800fb4:	75 0b                	jne    800fc1 <__umoddi3+0x91>
  800fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	f7 f6                	div    %esi
  800fbf:	89 c5                	mov    %eax,%ebp
  800fc1:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fc5:	31 d2                	xor    %edx,%edx
  800fc7:	f7 f5                	div    %ebp
  800fc9:	89 c8                	mov    %ecx,%eax
  800fcb:	f7 f5                	div    %ebp
  800fcd:	eb 9c                	jmp    800f6b <__umoddi3+0x3b>
  800fcf:	90                   	nop
  800fd0:	89 c8                	mov    %ecx,%eax
  800fd2:	89 fa                	mov    %edi,%edx
  800fd4:	83 c4 14             	add    $0x14,%esp
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
  800fdb:	90                   	nop
  800fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fe0:	8b 04 24             	mov    (%esp),%eax
  800fe3:	be 20 00 00 00       	mov    $0x20,%esi
  800fe8:	89 e9                	mov    %ebp,%ecx
  800fea:	29 ee                	sub    %ebp,%esi
  800fec:	d3 e2                	shl    %cl,%edx
  800fee:	89 f1                	mov    %esi,%ecx
  800ff0:	d3 e8                	shr    %cl,%eax
  800ff2:	89 e9                	mov    %ebp,%ecx
  800ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff8:	8b 04 24             	mov    (%esp),%eax
  800ffb:	09 54 24 04          	or     %edx,0x4(%esp)
  800fff:	89 fa                	mov    %edi,%edx
  801001:	d3 e0                	shl    %cl,%eax
  801003:	89 f1                	mov    %esi,%ecx
  801005:	89 44 24 08          	mov    %eax,0x8(%esp)
  801009:	8b 44 24 10          	mov    0x10(%esp),%eax
  80100d:	d3 ea                	shr    %cl,%edx
  80100f:	89 e9                	mov    %ebp,%ecx
  801011:	d3 e7                	shl    %cl,%edi
  801013:	89 f1                	mov    %esi,%ecx
  801015:	d3 e8                	shr    %cl,%eax
  801017:	89 e9                	mov    %ebp,%ecx
  801019:	09 f8                	or     %edi,%eax
  80101b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80101f:	f7 74 24 04          	divl   0x4(%esp)
  801023:	d3 e7                	shl    %cl,%edi
  801025:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801029:	89 d7                	mov    %edx,%edi
  80102b:	f7 64 24 08          	mull   0x8(%esp)
  80102f:	39 d7                	cmp    %edx,%edi
  801031:	89 c1                	mov    %eax,%ecx
  801033:	89 14 24             	mov    %edx,(%esp)
  801036:	72 2c                	jb     801064 <__umoddi3+0x134>
  801038:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80103c:	72 22                	jb     801060 <__umoddi3+0x130>
  80103e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801042:	29 c8                	sub    %ecx,%eax
  801044:	19 d7                	sbb    %edx,%edi
  801046:	89 e9                	mov    %ebp,%ecx
  801048:	89 fa                	mov    %edi,%edx
  80104a:	d3 e8                	shr    %cl,%eax
  80104c:	89 f1                	mov    %esi,%ecx
  80104e:	d3 e2                	shl    %cl,%edx
  801050:	89 e9                	mov    %ebp,%ecx
  801052:	d3 ef                	shr    %cl,%edi
  801054:	09 d0                	or     %edx,%eax
  801056:	89 fa                	mov    %edi,%edx
  801058:	83 c4 14             	add    $0x14,%esp
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    
  80105f:	90                   	nop
  801060:	39 d7                	cmp    %edx,%edi
  801062:	75 da                	jne    80103e <__umoddi3+0x10e>
  801064:	8b 14 24             	mov    (%esp),%edx
  801067:	89 c1                	mov    %eax,%ecx
  801069:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80106d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  801071:	eb cb                	jmp    80103e <__umoddi3+0x10e>
  801073:	90                   	nop
  801074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801078:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80107c:	0f 82 0f ff ff ff    	jb     800f91 <__umoddi3+0x61>
  801082:	e9 1a ff ff ff       	jmp    800fa1 <__umoddi3+0x71>
