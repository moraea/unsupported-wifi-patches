#import "Utils.h"

void add(Class class,NSString* selString,IMP imp,char* types)
{
	trace(@"cw: class_addMethod %@ %d",selString,class_addMethod(class,NSSelectorFromString(selString),imp,types));
}
id fake_UAWSJUFWN(id self,SEL sel,id rdx,id rcx,double xmm0,id (^r8)(id))
{
	r8(nil);
	return nil;
}
id fake(id self,SEL sel,id rdx)
{
	return nil;
}
	
id (*real_ROPWEH)(id self,SEL sel,id rdx);
id fake_ROPWEH(id self,SEL sel,id rdx)
{
	NSObject* result=real_ROPWEH(self,sel,rdx);
	
	if([NSStringFromClass(result.class) isEqualToString:@"__NSXPCInterfaceProxy_CWWiFiXPCRequestProtocol"])
	{	
		add(result.class,@"internal_userAgentWillShowJoinUIForWiFiNetwork:interfaceName:timestamp:reply:",(IMP)fake_UAWSJUFWN,"@@:@@@@");
		add(result.class,@"internal_dumpWiFiLogsAndReply:",(IMP)fake,"@@:@");
	}
	if([NSStringFromClass(result.class) isEqualToString:@"__NSXPCInterfaceProxy_CWWiFiXPCEventProtocol"])
	{	
		add(result.class,@"internal_setWiFiPasswordForUserKeychain:ssid:reply:",(IMP)fake,"@@:@@@");
	}
	return result;
}

__attribute__((constructor))
void load()
{
	traceLog=false;
	tracePrint=false;
	swizzleLog=false;

	if([NSProcessInfo.processInfo.arguments[0] containsString:@"airportd"] || [NSProcessInfo.processInfo.arguments[0] containsString:@"WiFiAgent"])
	{
		swizzleImp(@"NSXPCConnection",@"remoteObjectProxyWithErrorHandler:",true,(IMP)fake_ROPWEH,(IMP*)&real_ROPWEH);
		add(NSClassFromString(@"WAClient"),@"setConfigChangedDelegate:forGroupType:andReply:",(IMP)fake,"@@:@@");
		add(NSClassFromString(@"CWXPCConnection"),@"queryCountryCodeForInterfaceWithName:reply:",(IMP)fake,"@@:@@");
		add(NSClassFromString(@"CWXPCConnection"),@"performScanWithChannels:ssidList:legacyScanSSID:includeHiddenNetworks:mergeScanResults:maxAge:maxMissCount:maxWakeCount:maxAutoJoinCount:interfaceName:waitForWiFi:waitForBluetooth:trimmedScanResultProperties:token:priority:lowPriority:lowLatency:scanType:reply:",(IMP)fake,"@@:@@");
	}
}