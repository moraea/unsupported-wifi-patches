#import <IOKit/IOService.h>

#define __ACIDANTHERA_MAC_SDK
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wsign-conversion"
#pragma clang diagnostic ignored "-Wshadow"
#import <Headers/kern_api.hpp>
#pragma clang diagnostic pop

#define trace IOLog

extern "C"
{
	void* IORPCMessageFromMach()
	{
		return NULL;
	}
}

struct OldInside
{
	int version;
	short flag1;
	short flag2;
	char toEndOfKey[0x1f0];
	char notCopied[0x2c];
};

struct NewInside
{
	int version;
	int flag1;
	int flag2;
	char toEndOfKey[0x1f0];
	char notCopied[0x28];
};

struct Wrap
{
	char unknown[0x10];
	long selector;
	long size;
	long maybePointer;
};

char* (*real_IO80211Controller_apple80211RequestIoctl)(char*,int,int,char*,char*);
char* fake_IO80211Controller_apple80211RequestIoctl(char* rdi,int esi,int edx,char* rcx,char* r8)
{
	if(edx==20)
	{
		struct NewInside* newStruct=(struct NewInside*)r8;
		struct OldInside oldStruct={};
		oldStruct.version=newStruct->version;
		oldStruct.flag1=(short)newStruct->flag1;
		oldStruct.flag2=(short)newStruct->flag2;
		memcpy(&oldStruct.toEndOfKey,newStruct->toEndOfKey,0x1f0);
		memcpy(newStruct,&oldStruct,sizeof(struct OldInside));
	}
	
	return real_IO80211Controller_apple80211RequestIoctl(rdi,esi,edx,rcx,r8);
}

char* (*real_IO80211Interface_performCommand)(char*,char*,long,char*,char*);
char* fake_IO80211Interface_performCommand(char* rdi,char* rsi,long rdx,char* rcx,char* r8)
{
	struct Wrap* header=(struct Wrap*)r8;
	
	if(rdx==0xc02869c9&&header->selector==11)
	{
		header->size=0x48c;
	}
	
	char* result=real_IO80211Interface_performCommand(rdi,rsi,rdx,rcx,r8);
	
	if(rdx==0x802869c8&&(header->selector==10||header->selector==86))
	{
		long sleptCount=0;
		while(true)
		{
			char* thing=*(char**)(rdi+0x2d0);
			if(thing&&*(thing+0xac)!=3)
			{
				break;
			}
			
			IOSleep(10);
			sleptCount+=10;
		}
		
		trace("slept %ld\n",sleptCount);
	}
	
	return result;
}

const char* path={"IO80211FamilyLegacy.kext"};
KernelPatcher::KextInfo legacy={"com.apple.iokit.IO80211FamilyLegacy",&path,1};

void handleKextLoad(void* user,KernelPatcher& patcher,size_t id,mach_vm_address_t slide,size_t size)
{
	if(id!=legacy.loadIndex)
	{
		return;
	}
	
	KernelPatcher::RouteRequest request1("__ZN16IO80211Interface14performCommandEP19IONetworkControllermPvS2_",fake_IO80211Interface_performCommand,real_IO80211Interface_performCommand);
	patcher.routeMultipleLong(id,&request1,1,slide,size);
	
	if(getKernelVersion()>=24)
	{
		KernelPatcher::RouteRequest request2("__ZN17IO80211Controller22apple80211RequestIoctlEjiP16IO80211InterfacePv",fake_IO80211Controller_apple80211RequestIoctl,real_IO80211Controller_apple80211RequestIoctl);
		patcher.routeMultipleLong(id,&request2,1,slide,size);
	}
}

class KextName:IOService
{
	OSDeclareDefaultStructors(KextName)
public:
	bool start(IOService*) override;
};

OSDefineMetaClassAndStructors(KextName,IOService)

bool KextName::start(IOService* provider)
{
	lilu.onKextLoad(&legacy,1,handleKextLoad);
	
	return true;
}

int doNothing()
{
	return 0;
}
#define kmodStub(name,version) KMOD_EXPLICIT_DECL(name,xStringify(version),(kmod_start_func_t*)doNothing,(kmod_stop_func_t*)doNothing)
kmodStub(KextName,KextVersion)
