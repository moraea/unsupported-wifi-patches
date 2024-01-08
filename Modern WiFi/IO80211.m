#import "Utils.h"

void add(Class class,NSString* selString,IMP imp,char* types)
{
	trace(@"cw: class_addMethod %@ %d",selString,class_addMethod(class,NSSelectorFromString(selString),imp,types));
}
id fake()
{
	return nil;
}

__attribute__((constructor))
void load()
{
	traceLog=false;
	tracePrint=false;
	swizzleLog=false;
	
	if([NSProcessInfo.processInfo.arguments[0] containsString:@"airportd"])
	{
		add(NSClassFromString(@"WiFiUsageMonitor"),@"startMonitoringWiFiInterface:",(IMP)fake,"@@:@@");
		add(NSClassFromString(@"WAClient"),@"setConfigChangedDelegate:forGroupType:andReply:",(IMP)fake,"@@:@@");
		add(NSClassFromString(@"CWFNetworkProfile"),@"scanRecord",(IMP)fake,"@@:@@");
		add(NSClassFromString(@"CWFNetworkProfile"),@"matchingKnownNetworkProfile",(IMP)fake,"@@:@@");
	}
}