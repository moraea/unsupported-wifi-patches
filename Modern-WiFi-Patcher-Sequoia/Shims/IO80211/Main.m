#import "Utils.h"

void add(Class class,NSString* selString,IMP imp,char* types)
{
	trace(@"cw: class_addMethod %@ %d",selString,class_addMethod(class,NSSelectorFromString(selString),imp,types));
}
id fake()
{
	return nil;
}
long fake_canDoHEVC()
{
	return 1;
}

__attribute__((constructor))
void load()
{
    @autoreleasepool
    {
        traceLog=false;
        tracePrint=false;
        swizzleLog=false;
        
        if([NSProcessInfo.processInfo.arguments[0] containsString:@"airportd"])
        {
            add(NSClassFromString(@"WiFiUsageMonitor"),@"startMonitoringWiFiInterface:",(IMP)fake,"@@:@@");
            add(NSClassFromString(@"WiFiUsageMonitor"),@"setScanningState:client:neighborBSS:otherBSS:withChannelInfoList:forInterface:",(IMP)fake,"@@:@@");
            add(NSClassFromString(@"WAClient"),@"setConfigChangedDelegate:forGroupType:andReply:",(IMP)fake,"@@:@@");
            add(NSClassFromString(@"WAClient"),@"submitWiFiAnalyticsMessage:andReply:",(IMP)fake,"@@:@@");
        }
        if([NSProcessInfo.processInfo.arguments[0] containsString:@"ContinuityCaptureAgent"])
        {
            swizzleImp(@"VCHardwareSettingsMac",@"canDoHEVC",true,(IMP)fake_canDoHEVC,NULL);
        }
    }
}
