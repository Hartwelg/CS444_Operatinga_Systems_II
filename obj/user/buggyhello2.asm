
obj/user/buggyhello2:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  800039:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800040:	00 
  800041:	a1 00 20 80 00       	mov    0x802000,%eax
  800046:	89 04 24             	mov    %eax,(%esp)
  800049:	e8 5e 00 00 00       	call   8000ac <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005e:	e8 d8 00 00 00       	call   80013b <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x30>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  800080:	89 74 24 04          	mov    %esi,0x4(%esp)
  800084:	89 1c 24             	mov    %ebx,(%esp)
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 07 00 00 00       	call   800098 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	sys_env_destroy(0);
  80009e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a5:	e8 3f 00 00 00       	call   8000e9 <sys_env_destroy>
}
  8000aa:	c9                   	leave  
  8000ab:	c3                   	ret    

008000ac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	89 c7                	mov    %eax,%edi
  8000c1:	89 c6                	mov    %eax,%esi
  8000c3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000da:	89 d1                	mov    %edx,%ecx
  8000dc:	89 d3                	mov    %edx,%ebx
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	89 d6                	mov    %edx,%esi
  8000e2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8000f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ff:	89 cb                	mov    %ecx,%ebx
  800101:	89 cf                	mov    %ecx,%edi
  800103:	89 ce                	mov    %ecx,%esi
  800105:	cd 30                	int    $0x30
	if(check && ret > 0)
  800107:	85 c0                	test   %eax,%eax
  800109:	7e 28                	jle    800133 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80010b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80010f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800116:	00 
  800117:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  80012e:	e8 5b 02 00 00       	call   80038e <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800133:	83 c4 2c             	add    $0x2c,%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 02 00 00 00       	mov    $0x2,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_yield>:

void
sys_yield(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 0a 00 00 00       	mov    $0xa,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	b8 04 00 00 00       	mov    $0x4,%eax
  80018c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800195:	89 f7                	mov    %esi,%edi
  800197:	cd 30                	int    $0x30
	if(check && ret > 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	7e 28                	jle    8001c5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80019d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001a1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001a8:	00 
  8001a9:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  8001b0:	00 
  8001b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001b8:	00 
  8001b9:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  8001c0:	e8 c9 01 00 00       	call   80038e <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c5:	83 c4 2c             	add    $0x2c,%esp
  8001c8:	5b                   	pop    %ebx
  8001c9:	5e                   	pop    %esi
  8001ca:	5f                   	pop    %edi
  8001cb:	5d                   	pop    %ebp
  8001cc:	c3                   	ret    

008001cd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	57                   	push   %edi
  8001d1:	56                   	push   %esi
  8001d2:	53                   	push   %ebx
  8001d3:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8001d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8001db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001de:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	7e 28                	jle    800218 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001f4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001fb:	00 
  8001fc:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  800203:	00 
  800204:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80020b:	00 
  80020c:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  800213:	e8 76 01 00 00       	call   80038e <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800218:	83 c4 2c             	add    $0x2c,%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    

00800220 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800229:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022e:	b8 06 00 00 00       	mov    $0x6,%eax
  800233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800236:	8b 55 08             	mov    0x8(%ebp),%edx
  800239:	89 df                	mov    %ebx,%edi
  80023b:	89 de                	mov    %ebx,%esi
  80023d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023f:	85 c0                	test   %eax,%eax
  800241:	7e 28                	jle    80026b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800243:	89 44 24 10          	mov    %eax,0x10(%esp)
  800247:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80024e:	00 
  80024f:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  800256:	00 
  800257:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80025e:	00 
  80025f:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  800266:	e8 23 01 00 00       	call   80038e <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80026b:	83 c4 2c             	add    $0x2c,%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    

00800273 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  80027c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800281:	b8 08 00 00 00       	mov    $0x8,%eax
  800286:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800289:	8b 55 08             	mov    0x8(%ebp),%edx
  80028c:	89 df                	mov    %ebx,%edi
  80028e:	89 de                	mov    %ebx,%esi
  800290:	cd 30                	int    $0x30
	if(check && ret > 0)
  800292:	85 c0                	test   %eax,%eax
  800294:	7e 28                	jle    8002be <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800296:	89 44 24 10          	mov    %eax,0x10(%esp)
  80029a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  8002a9:	00 
  8002aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002b1:	00 
  8002b2:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  8002b9:	e8 d0 00 00 00       	call   80038e <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002be:	83 c4 2c             	add    $0x2c,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	57                   	push   %edi
  8002ca:	56                   	push   %esi
  8002cb:	53                   	push   %ebx
  8002cc:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  8002cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002df:	89 df                	mov    %ebx,%edi
  8002e1:	89 de                	mov    %ebx,%esi
  8002e3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	7e 28                	jle    800311 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ed:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002f4:	00 
  8002f5:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  8002fc:	00 
  8002fd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800304:	00 
  800305:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  80030c:	e8 7d 00 00 00       	call   80038e <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800311:	83 c4 2c             	add    $0x2c,%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5f                   	pop    %edi
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	57                   	push   %edi
  80031d:	56                   	push   %esi
  80031e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80031f:	be 00 00 00 00       	mov    $0x0,%esi
  800324:	b8 0b 00 00 00       	mov    $0xb,%eax
  800329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032c:	8b 55 08             	mov    0x8(%ebp),%edx
  80032f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800332:	8b 7d 14             	mov    0x14(%ebp),%edi
  800335:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	57                   	push   %edi
  800340:	56                   	push   %esi
  800341:	53                   	push   %ebx
  800342:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("int %1\n"
  800345:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034f:	8b 55 08             	mov    0x8(%ebp),%edx
  800352:	89 cb                	mov    %ecx,%ebx
  800354:	89 cf                	mov    %ecx,%edi
  800356:	89 ce                	mov    %ecx,%esi
  800358:	cd 30                	int    $0x30
	if(check && ret > 0)
  80035a:	85 c0                	test   %eax,%eax
  80035c:	7e 28                	jle    800386 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80035e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800362:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800369:	00 
  80036a:	c7 44 24 08 b8 10 80 	movl   $0x8010b8,0x8(%esp)
  800371:	00 
  800372:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800379:	00 
  80037a:	c7 04 24 d5 10 80 00 	movl   $0x8010d5,(%esp)
  800381:	e8 08 00 00 00       	call   80038e <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800386:	83 c4 2c             	add    $0x2c,%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	56                   	push   %esi
  800392:	53                   	push   %ebx
  800393:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800396:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800399:	8b 35 04 20 80 00    	mov    0x802004,%esi
  80039f:	e8 97 fd ff ff       	call   80013b <sys_getenvid>
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b2:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 e4 10 80 00 	movl   $0x8010e4,(%esp)
  8003c1:	e8 c1 00 00 00       	call   800487 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cd:	89 04 24             	mov    %eax,(%esp)
  8003d0:	e8 51 00 00 00       	call   800426 <vcprintf>
	cprintf("\n");
  8003d5:	c7 04 24 ac 10 80 00 	movl   $0x8010ac,(%esp)
  8003dc:	e8 a6 00 00 00       	call   800487 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e1:	cc                   	int3   
  8003e2:	eb fd                	jmp    8003e1 <_panic+0x53>

008003e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	53                   	push   %ebx
  8003e8:	83 ec 14             	sub    $0x14,%esp
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ee:	8b 13                	mov    (%ebx),%edx
  8003f0:	8d 42 01             	lea    0x1(%edx),%eax
  8003f3:	89 03                	mov    %eax,(%ebx)
  8003f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800401:	75 19                	jne    80041c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800403:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80040a:	00 
  80040b:	8d 43 08             	lea    0x8(%ebx),%eax
  80040e:	89 04 24             	mov    %eax,(%esp)
  800411:	e8 96 fc ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  800416:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80041c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800420:	83 c4 14             	add    $0x14,%esp
  800423:	5b                   	pop    %ebx
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80042f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800436:	00 00 00 
	b.cnt = 0;
  800439:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800440:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800451:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045b:	c7 04 24 e4 03 80 00 	movl   $0x8003e4,(%esp)
  800462:	e8 b7 01 00 00       	call   80061e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800467:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80046d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800471:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800477:	89 04 24             	mov    %eax,(%esp)
  80047a:	e8 2d fc ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  80047f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800490:	89 44 24 04          	mov    %eax,0x4(%esp)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	89 04 24             	mov    %eax,(%esp)
  80049a:	e8 87 ff ff ff       	call   800426 <vcprintf>
	va_end(ap);

	return cnt;
}
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    
  8004a1:	66 90                	xchg   %ax,%ax
  8004a3:	66 90                	xchg   %ax,%ax
  8004a5:	66 90                	xchg   %ax,%ax
  8004a7:	66 90                	xchg   %ax,%ax
  8004a9:	66 90                	xchg   %ax,%ax
  8004ab:	66 90                	xchg   %ax,%ax
  8004ad:	66 90                	xchg   %ax,%ax
  8004af:	90                   	nop

008004b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 3c             	sub    $0x3c,%esp
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	89 d7                	mov    %edx,%edi
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c7:	89 c3                	mov    %eax,%ebx
  8004c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004dd:	39 d9                	cmp    %ebx,%ecx
  8004df:	72 05                	jb     8004e6 <printnum+0x36>
  8004e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004e4:	77 69                	ja     80054f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004ed:	83 ee 01             	sub    $0x1,%esi
  8004f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800500:	89 c3                	mov    %eax,%ebx
  800502:	89 d6                	mov    %edx,%esi
  800504:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800507:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80050e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	89 04 24             	mov    %eax,(%esp)
  800518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	e8 ec 08 00 00       	call   800e10 <__udivdi3>
  800524:	89 d9                	mov    %ebx,%ecx
  800526:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80052a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	89 54 24 04          	mov    %edx,0x4(%esp)
  800535:	89 fa                	mov    %edi,%edx
  800537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053a:	e8 71 ff ff ff       	call   8004b0 <printnum>
  80053f:	eb 1b                	jmp    80055c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800541:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800545:	8b 45 18             	mov    0x18(%ebp),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff d3                	call   *%ebx
  80054d:	eb 03                	jmp    800552 <printnum+0xa2>
  80054f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		while (--width > 0)
  800552:	83 ee 01             	sub    $0x1,%esi
  800555:	85 f6                	test   %esi,%esi
  800557:	7f e8                	jg     800541 <printnum+0x91>
  800559:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80055c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800560:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800567:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80056e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80057b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057f:	e8 bc 09 00 00       	call   800f40 <__umoddi3>
  800584:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800588:	0f be 80 08 11 80 00 	movsbl 0x801108(%eax),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800595:	ff d0                	call   *%eax
}
  800597:	83 c4 3c             	add    $0x3c,%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a2:	83 fa 01             	cmp    $0x1,%edx
  8005a5:	7e 0e                	jle    8005b5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005ac:	89 08                	mov    %ecx,(%eax)
  8005ae:	8b 02                	mov    (%edx),%eax
  8005b0:	8b 52 04             	mov    0x4(%edx),%edx
  8005b3:	eb 22                	jmp    8005d7 <getuint+0x38>
	else if (lflag)
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	74 10                	je     8005c9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	eb 0e                	jmp    8005d7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ce:	89 08                	mov    %ecx,(%eax)
  8005d0:	8b 02                	mov    (%edx),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e8:	73 0a                	jae    8005f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005ed:	89 08                	mov    %ecx,(%eax)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	88 02                	mov    %al,(%edx)
}
  8005f4:	5d                   	pop    %ebp
  8005f5:	c3                   	ret    

008005f6 <printfmt>:
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	va_start(ap, fmt);
  8005fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800603:	8b 45 10             	mov    0x10(%ebp),%eax
  800606:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 04 24             	mov    %eax,(%esp)
  800617:	e8 02 00 00 00       	call   80061e <vprintfmt>
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <vprintfmt>:
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 3c             	sub    $0x3c,%esp
  800627:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80062a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80062d:	eb 14                	jmp    800643 <vprintfmt+0x25>
			if (ch == '\0')
  80062f:	85 c0                	test   %eax,%eax
  800631:	0f 84 b3 03 00 00    	je     8009ea <vprintfmt+0x3cc>
			putch(ch, putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	89 04 24             	mov    %eax,(%esp)
  80063e:	ff 55 08             	call   *0x8(%ebp)
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	89 f3                	mov    %esi,%ebx
  800643:	8d 73 01             	lea    0x1(%ebx),%esi
  800646:	0f b6 03             	movzbl (%ebx),%eax
  800649:	83 f8 25             	cmp    $0x25,%eax
  80064c:	75 e1                	jne    80062f <vprintfmt+0x11>
  80064e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800659:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800660:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	eb 1d                	jmp    80068b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	89 de                	mov    %ebx,%esi
			padc = '-';
  800670:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800674:	eb 15                	jmp    80068b <vprintfmt+0x6d>
		switch (ch = *(unsigned char *) fmt++) {
  800676:	89 de                	mov    %ebx,%esi
			padc = '0';
  800678:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80067c:	eb 0d                	jmp    80068b <vprintfmt+0x6d>
				width = precision, precision = -1;
  80067e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800684:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80068e:	0f b6 0e             	movzbl (%esi),%ecx
  800691:	0f b6 c1             	movzbl %cl,%eax
  800694:	83 e9 23             	sub    $0x23,%ecx
  800697:	80 f9 55             	cmp    $0x55,%cl
  80069a:	0f 87 2a 03 00 00    	ja     8009ca <vprintfmt+0x3ac>
  8006a0:	0f b6 c9             	movzbl %cl,%ecx
  8006a3:	ff 24 8d c0 11 80 00 	jmp    *0x8011c0(,%ecx,4)
  8006aa:	89 de                	mov    %ebx,%esi
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
				precision = precision * 10 + ch - '0';
  8006b1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006b4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006b8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006be:	83 fb 09             	cmp    $0x9,%ebx
  8006c1:	77 36                	ja     8006f9 <vprintfmt+0xdb>
			for (precision = 0; ; ++fmt) {
  8006c3:	83 c6 01             	add    $0x1,%esi
			}
  8006c6:	eb e9                	jmp    8006b1 <vprintfmt+0x93>
			precision = va_arg(ap, int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006d6:	89 de                	mov    %ebx,%esi
			goto process_precision;
  8006d8:	eb 22                	jmp    8006fc <vprintfmt+0xde>
  8006da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006dd:	85 c9                	test   %ecx,%ecx
  8006df:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e4:	0f 49 c1             	cmovns %ecx,%eax
  8006e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	89 de                	mov    %ebx,%esi
  8006ec:	eb 9d                	jmp    80068b <vprintfmt+0x6d>
  8006ee:	89 de                	mov    %ebx,%esi
			altflag = 1;
  8006f0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006f7:	eb 92                	jmp    80068b <vprintfmt+0x6d>
  8006f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
			if (width < 0)
  8006fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800700:	79 89                	jns    80068b <vprintfmt+0x6d>
  800702:	e9 77 ff ff ff       	jmp    80067e <vprintfmt+0x60>
			lflag++;
  800707:	83 c2 01             	add    $0x1,%edx
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	89 de                	mov    %ebx,%esi
			goto reswitch;
  80070c:	e9 7a ff ff ff       	jmp    80068b <vprintfmt+0x6d>
			putch(va_arg(ap, int), putdat);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	89 55 14             	mov    %edx,0x14(%ebp)
  80071a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	89 04 24             	mov    %eax,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
			break;
  800726:	e9 18 ff ff ff       	jmp    800643 <vprintfmt+0x25>
			err = va_arg(ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	89 55 14             	mov    %edx,0x14(%ebp)
  800734:	8b 00                	mov    (%eax),%eax
  800736:	99                   	cltd   
  800737:	31 d0                	xor    %edx,%eax
  800739:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80073b:	83 f8 08             	cmp    $0x8,%eax
  80073e:	7f 0b                	jg     80074b <vprintfmt+0x12d>
  800740:	8b 14 85 20 13 80 00 	mov    0x801320(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 20 11 80 	movl   $0x801120,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 90 fe ff ff       	call   8005f6 <printfmt>
  800766:	e9 d8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 29 11 80 	movl   $0x801129,0x8(%esp)
  800776:	00 
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 70 fe ff ff       	call   8005f6 <printfmt>
  800786:	e9 b8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80078e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800791:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80079f:	85 f6                	test   %esi,%esi
  8007a1:	b8 19 11 80 00       	mov    $0x801119,%eax
  8007a6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8007a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007ad:	0f 84 97 00 00 00    	je     80084a <vprintfmt+0x22c>
  8007b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007b7:	0f 8e 9b 00 00 00    	jle    800858 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c1:	89 34 24             	mov    %esi,(%esp)
  8007c4:	e8 cf 02 00 00       	call   800a98 <strnlen>
  8007c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007cc:	29 c2                	sub    %eax,%edx
  8007ce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007d1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e1:	89 d3                	mov    %edx,%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e3:	eb 0f                	jmp    8007f4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ec:	89 04 24             	mov    %eax,(%esp)
  8007ef:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	83 eb 01             	sub    $0x1,%ebx
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	7f ed                	jg     8007e5 <vprintfmt+0x1c7>
  8007f8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	0f 49 c2             	cmovns %edx,%eax
  800808:	29 c2                	sub    %eax,%edx
  80080a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80080d:	89 d7                	mov    %edx,%edi
  80080f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800812:	eb 50                	jmp    800864 <vprintfmt+0x246>
				if (altflag && (ch < ' ' || ch > '~'))
  800814:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800818:	74 1e                	je     800838 <vprintfmt+0x21a>
  80081a:	0f be d2             	movsbl %dl,%edx
  80081d:	83 ea 20             	sub    $0x20,%edx
  800820:	83 fa 5e             	cmp    $0x5e,%edx
  800823:	76 13                	jbe    800838 <vprintfmt+0x21a>
					putch('?', putdat);
  800825:	8b 45 0c             	mov    0xc(%ebp),%eax
  800828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800833:	ff 55 08             	call   *0x8(%ebp)
  800836:	eb 0d                	jmp    800845 <vprintfmt+0x227>
					putch(ch, putdat);
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800845:	83 ef 01             	sub    $0x1,%edi
  800848:	eb 1a                	jmp    800864 <vprintfmt+0x246>
  80084a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800850:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800853:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800856:	eb 0c                	jmp    800864 <vprintfmt+0x246>
  800858:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80085b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80085e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800861:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800864:	83 c6 01             	add    $0x1,%esi
  800867:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80086b:	0f be c2             	movsbl %dl,%eax
  80086e:	85 c0                	test   %eax,%eax
  800870:	74 27                	je     800899 <vprintfmt+0x27b>
  800872:	85 db                	test   %ebx,%ebx
  800874:	78 9e                	js     800814 <vprintfmt+0x1f6>
  800876:	83 eb 01             	sub    $0x1,%ebx
  800879:	79 99                	jns    800814 <vprintfmt+0x1f6>
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	89 c3                	mov    %eax,%ebx
  800885:	eb 1a                	jmp    8008a1 <vprintfmt+0x283>
				putch(' ', putdat);
  800887:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800892:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800894:	83 eb 01             	sub    $0x1,%ebx
  800897:	eb 08                	jmp    8008a1 <vprintfmt+0x283>
  800899:	89 fb                	mov    %edi,%ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	7f e2                	jg     800887 <vprintfmt+0x269>
  8008a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008ab:	e9 93 fd ff ff       	jmp    800643 <vprintfmt+0x25>
	if (lflag >= 2)
  8008b0:	83 fa 01             	cmp    $0x1,%edx
  8008b3:	7e 16                	jle    8008cb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 08             	lea    0x8(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c9:	eb 32                	jmp    8008fd <vprintfmt+0x2df>
	else if (lflag)
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	74 18                	je     8008e7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 30                	mov    (%eax),%esi
  8008da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	c1 f8 1f             	sar    $0x1f,%eax
  8008e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e5:	eb 16                	jmp    8008fd <vprintfmt+0x2df>
		return va_arg(*ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f0:	8b 30                	mov    (%eax),%esi
  8008f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008f5:	89 f0                	mov    %esi,%eax
  8008f7:	c1 f8 1f             	sar    $0x1f,%eax
  8008fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			num = getint(&ap, lflag);
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			base = 10;
  800903:	b9 0a 00 00 00       	mov    $0xa,%ecx
			if ((long long) num < 0) {
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 80 00 00 00    	jns    800992 <vprintfmt+0x374>
				putch('-', putdat);
  800912:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800916:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80091d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800926:	f7 d8                	neg    %eax
  800928:	83 d2 00             	adc    $0x0,%edx
  80092b:	f7 da                	neg    %edx
			base = 10;
  80092d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800932:	eb 5e                	jmp    800992 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800934:	8d 45 14             	lea    0x14(%ebp),%eax
  800937:	e8 63 fc ff ff       	call   80059f <getuint>
			base = 10;
  80093c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800941:	eb 4f                	jmp    800992 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800943:	8d 45 14             	lea    0x14(%ebp),%eax
  800946:	e8 54 fc ff ff       	call   80059f <getuint>
			base = 8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800950:	eb 40                	jmp    800992 <vprintfmt+0x374>
			putch('0', putdat);
  800952:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800956:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80095d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800960:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800964:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80096b:	ff 55 08             	call   *0x8(%ebp)
				(uintptr_t) va_arg(ap, void *);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8d 50 04             	lea    0x4(%eax),%edx
  800974:	89 55 14             	mov    %edx,0x14(%ebp)
			num = (unsigned long long)
  800977:	8b 00                	mov    (%eax),%eax
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
			base = 16;
  80097e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800983:	eb 0d                	jmp    800992 <vprintfmt+0x374>
			num = getuint(&ap, lflag);
  800985:	8d 45 14             	lea    0x14(%ebp),%eax
  800988:	e8 12 fc ff ff       	call   80059f <getuint>
			base = 16;
  80098d:	b9 10 00 00 00       	mov    $0x10,%ecx
			printnum(putch, putdat, num, base, width, padc);
  800992:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800996:	89 74 24 10          	mov    %esi,0x10(%esp)
  80099a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80099d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009a5:	89 04 24             	mov    %eax,(%esp)
  8009a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ac:	89 fa                	mov    %edi,%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	e8 fa fa ff ff       	call   8004b0 <printnum>
			break;
  8009b6:	e9 88 fc ff ff       	jmp    800643 <vprintfmt+0x25>
			putch(ch, putdat);
  8009bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bf:	89 04 24             	mov    %eax,(%esp)
  8009c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009c5:	e9 79 fc ff ff       	jmp    800643 <vprintfmt+0x25>
			putch('%', putdat);
  8009ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ce:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d8:	89 f3                	mov    %esi,%ebx
  8009da:	eb 03                	jmp    8009df <vprintfmt+0x3c1>
  8009dc:	83 eb 01             	sub    $0x1,%ebx
  8009df:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009e3:	75 f7                	jne    8009dc <vprintfmt+0x3be>
  8009e5:	e9 59 fc ff ff       	jmp    800643 <vprintfmt+0x25>
}
  8009ea:	83 c4 3c             	add    $0x3c,%esp
  8009ed:	5b                   	pop    %ebx
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 28             	sub    $0x28,%esp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	74 30                	je     800a43 <vsnprintf+0x51>
  800a13:	85 d2                	test   %edx,%edx
  800a15:	7e 2c                	jle    800a43 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2c:	c7 04 24 d9 05 80 00 	movl   $0x8005d9,(%esp)
  800a33:	e8 e6 fb ff ff       	call   80061e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a41:	eb 05                	jmp    800a48 <vsnprintf+0x56>
		return -E_INVAL;
  800a43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	89 04 24             	mov    %eax,(%esp)
  800a6b:	e8 82 ff ff ff       	call   8009f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    
  800a72:	66 90                	xchg   %ax,%ax
  800a74:	66 90                	xchg   %ax,%ax
  800a76:	66 90                	xchg   %ax,%ax
  800a78:	66 90                	xchg   %ax,%ax
  800a7a:	66 90                	xchg   %ax,%ax
  800a7c:	66 90                	xchg   %ax,%ax
  800a7e:	66 90                	xchg   %ax,%ax

00800a80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb 03                	jmp    800a90 <strlen+0x10>
		n++;
  800a8d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a94:	75 f7                	jne    800a8d <strlen+0xd>
	return n;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	eb 03                	jmp    800aab <strnlen+0x13>
		n++;
  800aa8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aab:	39 d0                	cmp    %edx,%eax
  800aad:	74 06                	je     800ab5 <strnlen+0x1d>
  800aaf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ab3:	75 f3                	jne    800aa8 <strnlen+0x10>
	return n;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac1:	89 c2                	mov    %eax,%edx
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800acd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad0:	84 db                	test   %bl,%bl
  800ad2:	75 ef                	jne    800ac3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	53                   	push   %ebx
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae1:	89 1c 24             	mov    %ebx,(%esp)
  800ae4:	e8 97 ff ff ff       	call   800a80 <strlen>
	strcpy(dst + len, src);
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aec:	89 54 24 04          	mov    %edx,0x4(%esp)
  800af0:	01 d8                	add    %ebx,%eax
  800af2:	89 04 24             	mov    %eax,(%esp)
  800af5:	e8 bd ff ff ff       	call   800ab7 <strcpy>
	return dst;
}
  800afa:	89 d8                	mov    %ebx,%eax
  800afc:	83 c4 08             	add    $0x8,%esp
  800aff:	5b                   	pop    %ebx
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0d:	89 f3                	mov    %esi,%ebx
  800b0f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b12:	89 f2                	mov    %esi,%edx
  800b14:	eb 0f                	jmp    800b25 <strncpy+0x23>
		*dst++ = *src;
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	0f b6 01             	movzbl (%ecx),%eax
  800b1c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b1f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b22:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b25:	39 da                	cmp    %ebx,%edx
  800b27:	75 ed                	jne    800b16 <strncpy+0x14>
	}
	return ret;
}
  800b29:	89 f0                	mov    %esi,%eax
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 75 08             	mov    0x8(%ebp),%esi
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	75 0b                	jne    800b52 <strlcpy+0x23>
  800b47:	eb 1d                	jmp    800b66 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	83 c2 01             	add    $0x1,%edx
  800b4f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b52:	39 d8                	cmp    %ebx,%eax
  800b54:	74 0b                	je     800b61 <strlcpy+0x32>
  800b56:	0f b6 0a             	movzbl (%edx),%ecx
  800b59:	84 c9                	test   %cl,%cl
  800b5b:	75 ec                	jne    800b49 <strlcpy+0x1a>
  800b5d:	89 c2                	mov    %eax,%edx
  800b5f:	eb 02                	jmp    800b63 <strlcpy+0x34>
  800b61:	89 c2                	mov    %eax,%edx
		*dst = '\0';
  800b63:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b66:	29 f0                	sub    %esi,%eax
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b75:	eb 06                	jmp    800b7d <strcmp+0x11>
		p++, q++;
  800b77:	83 c1 01             	add    $0x1,%ecx
  800b7a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b7d:	0f b6 01             	movzbl (%ecx),%eax
  800b80:	84 c0                	test   %al,%al
  800b82:	74 04                	je     800b88 <strcmp+0x1c>
  800b84:	3a 02                	cmp    (%edx),%al
  800b86:	74 ef                	je     800b77 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	0f b6 c0             	movzbl %al,%eax
  800b8b:	0f b6 12             	movzbl (%edx),%edx
  800b8e:	29 d0                	sub    %edx,%eax
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba1:	eb 06                	jmp    800ba9 <strncmp+0x17>
		n--, p++, q++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ba9:	39 d8                	cmp    %ebx,%eax
  800bab:	74 15                	je     800bc2 <strncmp+0x30>
  800bad:	0f b6 08             	movzbl (%eax),%ecx
  800bb0:	84 c9                	test   %cl,%cl
  800bb2:	74 04                	je     800bb8 <strncmp+0x26>
  800bb4:	3a 0a                	cmp    (%edx),%cl
  800bb6:	74 eb                	je     800ba3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb8:	0f b6 00             	movzbl (%eax),%eax
  800bbb:	0f b6 12             	movzbl (%edx),%edx
  800bbe:	29 d0                	sub    %edx,%eax
  800bc0:	eb 05                	jmp    800bc7 <strncmp+0x35>
		return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd4:	eb 07                	jmp    800bdd <strchr+0x13>
		if (*s == c)
  800bd6:	38 ca                	cmp    %cl,%dl
  800bd8:	74 0f                	je     800be9 <strchr+0x1f>
	for (; *s; s++)
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	0f b6 10             	movzbl (%eax),%edx
  800be0:	84 d2                	test   %dl,%dl
  800be2:	75 f2                	jne    800bd6 <strchr+0xc>
			return (char *) s;
	return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf5:	eb 07                	jmp    800bfe <strfind+0x13>
		if (*s == c)
  800bf7:	38 ca                	cmp    %cl,%dl
  800bf9:	74 0a                	je     800c05 <strfind+0x1a>
	for (; *s; s++)
  800bfb:	83 c0 01             	add    $0x1,%eax
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	75 f2                	jne    800bf7 <strfind+0xc>
			break;
	return (char *) s;
}
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	74 36                	je     800c4d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c17:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1d:	75 28                	jne    800c47 <memset+0x40>
  800c1f:	f6 c1 03             	test   $0x3,%cl
  800c22:	75 23                	jne    800c47 <memset+0x40>
		c &= 0xFF;
  800c24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	c1 e3 08             	shl    $0x8,%ebx
  800c2d:	89 d6                	mov    %edx,%esi
  800c2f:	c1 e6 18             	shl    $0x18,%esi
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	c1 e0 10             	shl    $0x10,%eax
  800c37:	09 f0                	or     %esi,%eax
  800c39:	09 c2                	or     %eax,%edx
  800c3b:	89 d0                	mov    %edx,%eax
  800c3d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c3f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c42:	fc                   	cld    
  800c43:	f3 ab                	rep stos %eax,%es:(%edi)
  800c45:	eb 06                	jmp    800c4d <memset+0x46>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4d:	89 f8                	mov    %edi,%eax
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c62:	39 c6                	cmp    %eax,%esi
  800c64:	73 35                	jae    800c9b <memmove+0x47>
  800c66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c69:	39 d0                	cmp    %edx,%eax
  800c6b:	73 2e                	jae    800c9b <memmove+0x47>
		s += n;
		d += n;
  800c6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c70:	89 d6                	mov    %edx,%esi
  800c72:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7a:	75 13                	jne    800c8f <memmove+0x3b>
  800c7c:	f6 c1 03             	test   $0x3,%cl
  800c7f:	75 0e                	jne    800c8f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c81:	83 ef 04             	sub    $0x4,%edi
  800c84:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c87:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c8a:	fd                   	std    
  800c8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8d:	eb 09                	jmp    800c98 <memmove+0x44>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c8f:	83 ef 01             	sub    $0x1,%edi
  800c92:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c95:	fd                   	std    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c98:	fc                   	cld    
  800c99:	eb 1d                	jmp    800cb8 <memmove+0x64>
  800c9b:	89 f2                	mov    %esi,%edx
  800c9d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9f:	f6 c2 03             	test   $0x3,%dl
  800ca2:	75 0f                	jne    800cb3 <memmove+0x5f>
  800ca4:	f6 c1 03             	test   $0x3,%cl
  800ca7:	75 0a                	jne    800cb3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	fc                   	cld    
  800caf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb1:	eb 05                	jmp    800cb8 <memmove+0x64>
		else
			asm volatile("cld; rep movsb\n"
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	fc                   	cld    
  800cb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 04 24             	mov    %eax,(%esp)
  800cd6:	e8 79 ff ff ff       	call   800c54 <memmove>
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ced:	eb 1a                	jmp    800d09 <memcmp+0x2c>
		if (*s1 != *s2)
  800cef:	0f b6 02             	movzbl (%edx),%eax
  800cf2:	0f b6 19             	movzbl (%ecx),%ebx
  800cf5:	38 d8                	cmp    %bl,%al
  800cf7:	74 0a                	je     800d03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cf9:	0f b6 c0             	movzbl %al,%eax
  800cfc:	0f b6 db             	movzbl %bl,%ebx
  800cff:	29 d8                	sub    %ebx,%eax
  800d01:	eb 0f                	jmp    800d12 <memcmp+0x35>
		s1++, s2++;
  800d03:	83 c2 01             	add    $0x1,%edx
  800d06:	83 c1 01             	add    $0x1,%ecx
	while (n-- > 0) {
  800d09:	39 f2                	cmp    %esi,%edx
  800d0b:	75 e2                	jne    800cef <memcmp+0x12>
	}

	return 0;
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d1f:	89 c2                	mov    %eax,%edx
  800d21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d24:	eb 07                	jmp    800d2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d26:	38 08                	cmp    %cl,(%eax)
  800d28:	74 07                	je     800d31 <memfind+0x1b>
	for (; s < ends; s++)
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	72 f5                	jb     800d26 <memfind+0x10>
			break;
	return (void *) s;
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3f:	eb 03                	jmp    800d44 <strtol+0x11>
		s++;
  800d41:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
  800d44:	0f b6 0a             	movzbl (%edx),%ecx
  800d47:	80 f9 09             	cmp    $0x9,%cl
  800d4a:	74 f5                	je     800d41 <strtol+0xe>
  800d4c:	80 f9 20             	cmp    $0x20,%cl
  800d4f:	74 f0                	je     800d41 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d51:	80 f9 2b             	cmp    $0x2b,%cl
  800d54:	75 0a                	jne    800d60 <strtol+0x2d>
		s++;
  800d56:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
  800d59:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5e:	eb 11                	jmp    800d71 <strtol+0x3e>
  800d60:	bf 00 00 00 00       	mov    $0x0,%edi
	else if (*s == '-')
  800d65:	80 f9 2d             	cmp    $0x2d,%cl
  800d68:	75 07                	jne    800d71 <strtol+0x3e>
		s++, neg = 1;
  800d6a:	8d 52 01             	lea    0x1(%edx),%edx
  800d6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d76:	75 15                	jne    800d8d <strtol+0x5a>
  800d78:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7b:	75 10                	jne    800d8d <strtol+0x5a>
  800d7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d81:	75 0a                	jne    800d8d <strtol+0x5a>
		s += 2, base = 16;
  800d83:	83 c2 02             	add    $0x2,%edx
  800d86:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8b:	eb 10                	jmp    800d9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 0c                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d91:	b0 0a                	mov    $0xa,%al
	else if (base == 0 && s[0] == '0')
  800d93:	80 3a 30             	cmpb   $0x30,(%edx)
  800d96:	75 05                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
  800d98:	83 c2 01             	add    $0x1,%edx
  800d9b:	b0 08                	mov    $0x8,%al
		base = 10;
  800d9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800da5:	0f b6 0a             	movzbl (%edx),%ecx
  800da8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800dab:	89 f0                	mov    %esi,%eax
  800dad:	3c 09                	cmp    $0x9,%al
  800daf:	77 08                	ja     800db9 <strtol+0x86>
			dig = *s - '0';
  800db1:	0f be c9             	movsbl %cl,%ecx
  800db4:	83 e9 30             	sub    $0x30,%ecx
  800db7:	eb 20                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800db9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	3c 19                	cmp    $0x19,%al
  800dc0:	77 08                	ja     800dca <strtol+0x97>
			dig = *s - 'a' + 10;
  800dc2:	0f be c9             	movsbl %cl,%ecx
  800dc5:	83 e9 57             	sub    $0x57,%ecx
  800dc8:	eb 0f                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	3c 19                	cmp    $0x19,%al
  800dd1:	77 16                	ja     800de9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dd3:	0f be c9             	movsbl %cl,%ecx
  800dd6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dd9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ddc:	7d 0f                	jge    800ded <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dde:	83 c2 01             	add    $0x1,%edx
  800de1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800de5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800de7:	eb bc                	jmp    800da5 <strtol+0x72>
  800de9:	89 d8                	mov    %ebx,%eax
  800deb:	eb 02                	jmp    800def <strtol+0xbc>
  800ded:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	74 05                	je     800dfa <strtol+0xc7>
		*endptr = (char *) s;
  800df5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dfa:	f7 d8                	neg    %eax
  800dfc:	85 ff                	test   %edi,%edi
  800dfe:	0f 44 c3             	cmove  %ebx,%eax
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    
  800e06:	66 90                	xchg   %ax,%ax
  800e08:	66 90                	xchg   %ax,%ax
  800e0a:	66 90                	xchg   %ax,%ax
  800e0c:	66 90                	xchg   %ax,%ax
  800e0e:	66 90                	xchg   %ax,%ax

00800e10 <__udivdi3>:
  800e10:	55                   	push   %ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	8b 44 24 28          	mov    0x28(%esp),%eax
  800e1a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  800e1e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  800e22:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  800e26:	85 c0                	test   %eax,%eax
  800e28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e2c:	89 ea                	mov    %ebp,%edx
  800e2e:	89 0c 24             	mov    %ecx,(%esp)
  800e31:	75 2d                	jne    800e60 <__udivdi3+0x50>
  800e33:	39 e9                	cmp    %ebp,%ecx
  800e35:	77 61                	ja     800e98 <__udivdi3+0x88>
  800e37:	85 c9                	test   %ecx,%ecx
  800e39:	89 ce                	mov    %ecx,%esi
  800e3b:	75 0b                	jne    800e48 <__udivdi3+0x38>
  800e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e42:	31 d2                	xor    %edx,%edx
  800e44:	f7 f1                	div    %ecx
  800e46:	89 c6                	mov    %eax,%esi
  800e48:	31 d2                	xor    %edx,%edx
  800e4a:	89 e8                	mov    %ebp,%eax
  800e4c:	f7 f6                	div    %esi
  800e4e:	89 c5                	mov    %eax,%ebp
  800e50:	89 f8                	mov    %edi,%eax
  800e52:	f7 f6                	div    %esi
  800e54:	89 ea                	mov    %ebp,%edx
  800e56:	83 c4 0c             	add    $0xc,%esp
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    
  800e5d:	8d 76 00             	lea    0x0(%esi),%esi
  800e60:	39 e8                	cmp    %ebp,%eax
  800e62:	77 24                	ja     800e88 <__udivdi3+0x78>
  800e64:	0f bd e8             	bsr    %eax,%ebp
  800e67:	83 f5 1f             	xor    $0x1f,%ebp
  800e6a:	75 3c                	jne    800ea8 <__udivdi3+0x98>
  800e6c:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e70:	39 34 24             	cmp    %esi,(%esp)
  800e73:	0f 86 9f 00 00 00    	jbe    800f18 <__udivdi3+0x108>
  800e79:	39 d0                	cmp    %edx,%eax
  800e7b:	0f 82 97 00 00 00    	jb     800f18 <__udivdi3+0x108>
  800e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e88:	31 d2                	xor    %edx,%edx
  800e8a:	31 c0                	xor    %eax,%eax
  800e8c:	83 c4 0c             	add    $0xc,%esp
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
  800e93:	90                   	nop
  800e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e98:	89 f8                	mov    %edi,%eax
  800e9a:	f7 f1                	div    %ecx
  800e9c:	31 d2                	xor    %edx,%edx
  800e9e:	83 c4 0c             	add    $0xc,%esp
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
  800ea5:	8d 76 00             	lea    0x0(%esi),%esi
  800ea8:	89 e9                	mov    %ebp,%ecx
  800eaa:	8b 3c 24             	mov    (%esp),%edi
  800ead:	d3 e0                	shl    %cl,%eax
  800eaf:	89 c6                	mov    %eax,%esi
  800eb1:	b8 20 00 00 00       	mov    $0x20,%eax
  800eb6:	29 e8                	sub    %ebp,%eax
  800eb8:	89 c1                	mov    %eax,%ecx
  800eba:	d3 ef                	shr    %cl,%edi
  800ebc:	89 e9                	mov    %ebp,%ecx
  800ebe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ec2:	8b 3c 24             	mov    (%esp),%edi
  800ec5:	09 74 24 08          	or     %esi,0x8(%esp)
  800ec9:	89 d6                	mov    %edx,%esi
  800ecb:	d3 e7                	shl    %cl,%edi
  800ecd:	89 c1                	mov    %eax,%ecx
  800ecf:	89 3c 24             	mov    %edi,(%esp)
  800ed2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ed6:	d3 ee                	shr    %cl,%esi
  800ed8:	89 e9                	mov    %ebp,%ecx
  800eda:	d3 e2                	shl    %cl,%edx
  800edc:	89 c1                	mov    %eax,%ecx
  800ede:	d3 ef                	shr    %cl,%edi
  800ee0:	09 d7                	or     %edx,%edi
  800ee2:	89 f2                	mov    %esi,%edx
  800ee4:	89 f8                	mov    %edi,%eax
  800ee6:	f7 74 24 08          	divl   0x8(%esp)
  800eea:	89 d6                	mov    %edx,%esi
  800eec:	89 c7                	mov    %eax,%edi
  800eee:	f7 24 24             	mull   (%esp)
  800ef1:	39 d6                	cmp    %edx,%esi
  800ef3:	89 14 24             	mov    %edx,(%esp)
  800ef6:	72 30                	jb     800f28 <__udivdi3+0x118>
  800ef8:	8b 54 24 04          	mov    0x4(%esp),%edx
  800efc:	89 e9                	mov    %ebp,%ecx
  800efe:	d3 e2                	shl    %cl,%edx
  800f00:	39 c2                	cmp    %eax,%edx
  800f02:	73 05                	jae    800f09 <__udivdi3+0xf9>
  800f04:	3b 34 24             	cmp    (%esp),%esi
  800f07:	74 1f                	je     800f28 <__udivdi3+0x118>
  800f09:	89 f8                	mov    %edi,%eax
  800f0b:	31 d2                	xor    %edx,%edx
  800f0d:	e9 7a ff ff ff       	jmp    800e8c <__udivdi3+0x7c>
  800f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f18:	31 d2                	xor    %edx,%edx
  800f1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800f1f:	e9 68 ff ff ff       	jmp    800e8c <__udivdi3+0x7c>
  800f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f28:	8d 47 ff             	lea    -0x1(%edi),%eax
  800f2b:	31 d2                	xor    %edx,%edx
  800f2d:	83 c4 0c             	add    $0xc,%esp
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
  800f34:	66 90                	xchg   %ax,%ax
  800f36:	66 90                	xchg   %ax,%ax
  800f38:	66 90                	xchg   %ax,%ax
  800f3a:	66 90                	xchg   %ax,%ax
  800f3c:	66 90                	xchg   %ax,%ax
  800f3e:	66 90                	xchg   %ax,%ax

00800f40 <__umoddi3>:
  800f40:	55                   	push   %ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	83 ec 14             	sub    $0x14,%esp
  800f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  800f4a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  800f4e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  800f52:	89 c7                	mov    %eax,%edi
  800f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f58:	8b 44 24 30          	mov    0x30(%esp),%eax
  800f5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800f60:	89 34 24             	mov    %esi,(%esp)
  800f63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800f6f:	75 17                	jne    800f88 <__umoddi3+0x48>
  800f71:	39 fe                	cmp    %edi,%esi
  800f73:	76 4b                	jbe    800fc0 <__umoddi3+0x80>
  800f75:	89 c8                	mov    %ecx,%eax
  800f77:	89 fa                	mov    %edi,%edx
  800f79:	f7 f6                	div    %esi
  800f7b:	89 d0                	mov    %edx,%eax
  800f7d:	31 d2                	xor    %edx,%edx
  800f7f:	83 c4 14             	add    $0x14,%esp
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
  800f86:	66 90                	xchg   %ax,%ax
  800f88:	39 f8                	cmp    %edi,%eax
  800f8a:	77 54                	ja     800fe0 <__umoddi3+0xa0>
  800f8c:	0f bd e8             	bsr    %eax,%ebp
  800f8f:	83 f5 1f             	xor    $0x1f,%ebp
  800f92:	75 5c                	jne    800ff0 <__umoddi3+0xb0>
  800f94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f98:	39 3c 24             	cmp    %edi,(%esp)
  800f9b:	0f 87 e7 00 00 00    	ja     801088 <__umoddi3+0x148>
  800fa1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800fa5:	29 f1                	sub    %esi,%ecx
  800fa7:	19 c7                	sbb    %eax,%edi
  800fa9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800fb1:	8b 44 24 08          	mov    0x8(%esp),%eax
  800fb5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800fb9:	83 c4 14             	add    $0x14,%esp
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    
  800fc0:	85 f6                	test   %esi,%esi
  800fc2:	89 f5                	mov    %esi,%ebp
  800fc4:	75 0b                	jne    800fd1 <__umoddi3+0x91>
  800fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	f7 f6                	div    %esi
  800fcf:	89 c5                	mov    %eax,%ebp
  800fd1:	8b 44 24 04          	mov    0x4(%esp),%eax
  800fd5:	31 d2                	xor    %edx,%edx
  800fd7:	f7 f5                	div    %ebp
  800fd9:	89 c8                	mov    %ecx,%eax
  800fdb:	f7 f5                	div    %ebp
  800fdd:	eb 9c                	jmp    800f7b <__umoddi3+0x3b>
  800fdf:	90                   	nop
  800fe0:	89 c8                	mov    %ecx,%eax
  800fe2:	89 fa                	mov    %edi,%edx
  800fe4:	83 c4 14             	add    $0x14,%esp
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    
  800feb:	90                   	nop
  800fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ff0:	8b 04 24             	mov    (%esp),%eax
  800ff3:	be 20 00 00 00       	mov    $0x20,%esi
  800ff8:	89 e9                	mov    %ebp,%ecx
  800ffa:	29 ee                	sub    %ebp,%esi
  800ffc:	d3 e2                	shl    %cl,%edx
  800ffe:	89 f1                	mov    %esi,%ecx
  801000:	d3 e8                	shr    %cl,%eax
  801002:	89 e9                	mov    %ebp,%ecx
  801004:	89 44 24 04          	mov    %eax,0x4(%esp)
  801008:	8b 04 24             	mov    (%esp),%eax
  80100b:	09 54 24 04          	or     %edx,0x4(%esp)
  80100f:	89 fa                	mov    %edi,%edx
  801011:	d3 e0                	shl    %cl,%eax
  801013:	89 f1                	mov    %esi,%ecx
  801015:	89 44 24 08          	mov    %eax,0x8(%esp)
  801019:	8b 44 24 10          	mov    0x10(%esp),%eax
  80101d:	d3 ea                	shr    %cl,%edx
  80101f:	89 e9                	mov    %ebp,%ecx
  801021:	d3 e7                	shl    %cl,%edi
  801023:	89 f1                	mov    %esi,%ecx
  801025:	d3 e8                	shr    %cl,%eax
  801027:	89 e9                	mov    %ebp,%ecx
  801029:	09 f8                	or     %edi,%eax
  80102b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80102f:	f7 74 24 04          	divl   0x4(%esp)
  801033:	d3 e7                	shl    %cl,%edi
  801035:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801039:	89 d7                	mov    %edx,%edi
  80103b:	f7 64 24 08          	mull   0x8(%esp)
  80103f:	39 d7                	cmp    %edx,%edi
  801041:	89 c1                	mov    %eax,%ecx
  801043:	89 14 24             	mov    %edx,(%esp)
  801046:	72 2c                	jb     801074 <__umoddi3+0x134>
  801048:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80104c:	72 22                	jb     801070 <__umoddi3+0x130>
  80104e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801052:	29 c8                	sub    %ecx,%eax
  801054:	19 d7                	sbb    %edx,%edi
  801056:	89 e9                	mov    %ebp,%ecx
  801058:	89 fa                	mov    %edi,%edx
  80105a:	d3 e8                	shr    %cl,%eax
  80105c:	89 f1                	mov    %esi,%ecx
  80105e:	d3 e2                	shl    %cl,%edx
  801060:	89 e9                	mov    %ebp,%ecx
  801062:	d3 ef                	shr    %cl,%edi
  801064:	09 d0                	or     %edx,%eax
  801066:	89 fa                	mov    %edi,%edx
  801068:	83 c4 14             	add    $0x14,%esp
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    
  80106f:	90                   	nop
  801070:	39 d7                	cmp    %edx,%edi
  801072:	75 da                	jne    80104e <__umoddi3+0x10e>
  801074:	8b 14 24             	mov    (%esp),%edx
  801077:	89 c1                	mov    %eax,%ecx
  801079:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80107d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  801081:	eb cb                	jmp    80104e <__umoddi3+0x10e>
  801083:	90                   	nop
  801084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801088:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80108c:	0f 82 0f ff ff ff    	jb     800fa1 <__umoddi3+0x61>
  801092:	e9 1a ff ff ff       	jmp    800fb1 <__umoddi3+0x71>
