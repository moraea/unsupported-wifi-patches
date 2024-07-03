#import "Utils.h"

/*

_CSDeviceSupportsAirDrop
essentially [[[CWFInterface initWithServiceType:6] capabilities] containsObject:@32]

-[CWFInterface initWithServiceType:]
1 com.apple.private.corewifi.internal-xpc
2 com.apple.private.corewifi-xpc
3 com.apple.private.corewifi.readonly-xpc
4 com.apple.wifi-xpc
5 com.apple.corewlan-xpc
6 com.apple.private.corewifi.unrestricted-xpc
7 com.apple.private.corewifi.mobilewifi-xpc
in old, returns nil if > 5

-[CWFXPCListener __allowXPCConnection:serviceType:]
Finder lacks entitlements for any of 1-3

-[CWFInterface capabilities]
in old, works on 1-3

*/

NSObject* (*real_initWithServiceType)(NSObject*,SEL,int);
NSObject* fake_initWithServiceType(NSObject* self,SEL sel,int type)
{
	if(type>5)
	{
		type=3;
	}
	
	return real_initWithServiceType(self,sel,type);
}

BOOL (*real_allowXPCConnection)(NSObject*,SEL,NSXPCConnection*,int);
BOOL fake_allowXPCConnection(NSObject* self,SEL sel,NSXPCConnection* connection,int type)
{
	if(type==3)
	{
		return true;
	}
	
	return real_allowXPCConnection(self,sel,connection,type);
}

__attribute__((constructor)) void load()
{
	@autoreleasepool
	{
		tracePrint=false;
		traceLog=false;
		
		swizzleImp(@"CWFInterface",@"initWithServiceType:",true,(IMP)fake_initWithServiceType,(IMP*)&real_initWithServiceType);
		swizzleImp(@"CWFXPCListener",@"__allowXPCConnection:serviceType:",true,(IMP)fake_allowXPCConnection,(IMP*)&real_allowXPCConnection);
	}
}
