#import "Utils.h"

void add(Class class,NSString* selString,IMP imp,char* types)
{
	trace(@"cw: class_addMethod %@ %d",selString,class_addMethod(class,NSSelectorFromString(selString),imp,types));
}

id fake_UAWSJUFWN(id self,SEL sel,id rdx,id rcx,double xmm0,id (^r8)(id))
{
	trace(@"cw: fake_UAWSJUFWN");
	r8(nil);
	return nil;
}

id fake_DWLAR(id self,SEL sel,id rdx)
{
	trace(@"cw: fake_DWLAR");
	return nil;
}

id fake_SWPFUK(id self,SEL sel,id rdx)
{
	trace(@"cw: fake_SWPFUK");
	return nil;
}
	
id (*real_ROPWEH)(id self,SEL sel,id rdx);
id fake_ROPWEH(id self,SEL sel,id rdx)
{
	NSObject* result=real_ROPWEH(self,sel,rdx);
	
	if([NSStringFromClass(result.class) isEqualToString:@"__NSXPCInterfaceProxy_CWWiFiXPCRequestProtocol"])
	{
		trace(@"cw: fake_ROPWEH matched class");
		
		add(result.class,@"internal_userAgentWillShowJoinUIForWiFiNetwork:interfaceName:timestamp:reply:",(IMP)fake_UAWSJUFWN,"@@:@@@@");
		add(result.class,@"internal_dumpWiFiLogsAndReply:",(IMP)fake_DWLAR,"@@:@");
	}
	
	if([NSStringFromClass(result.class) isEqualToString:@"__NSXPCInterfaceProxy_CWWiFiXPCEventProtocol"])
	{
		trace(@"cw: fake_ROPWEH matched class");
		
		add(result.class,@"internal_setWiFiPasswordForUserKeychain:ssid:reply:",(IMP)fake_SWPFUK,"@@:@@@");
	}
	
	return result;
}

void wifiSetup()
{
	traceLog=true;
	
	swizzleImp(@"NSXPCConnection",@"remoteObjectProxyWithErrorHandler:",true,(IMP)fake_ROPWEH,(IMP*)&real_ROPWEH);
}

__attribute__((constructor))
void load()
{
	traceLog=true;
	tracePrint=false;
	swizzleLog=false;
	
	wifiSetup();
}