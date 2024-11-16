#import "Utils.h"

BOOL _CSDeviceSupportsAirDrop();
BOOL fake__CSDeviceSupportsAirDrop()
{
	return true;
}

DYLD_INTERPOSE(fake__CSDeviceSupportsAirDrop,_CSDeviceSupportsAirDrop)