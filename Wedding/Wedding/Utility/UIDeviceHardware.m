//
//  UIDeviceHardware.m
//  PXiPhone
//
//  Created by Tuitu_Zaza on 11-5-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#include <sys/socket.h> 
#include <net/if.h> 
#include <net/if_dl.h> 

#import <CommonCrypto/CommonDigest.h>


@implementation UIDeviceHardware


+ (NSString *) platform{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return platform;
}

+ (NSString *) platformString{
	NSString *platform = [UIDeviceHardware platform];
	if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
	if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
	if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
	if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
	if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
	if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
	if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
	if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
	if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 GSM";
	if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 CDMAS";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini Wifi";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini GSM";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini CDMA";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 GSM";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 CDMA";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
	return platform;
}
/*
QVGA（240×320）
HVGA (320x480)
WVGA（800×480）
Double VGA（960×640）
WQVGA（400×240）
FWVGA（854×480)
*/
+ (NSString*)screenModel {
	NSString *platform = [UIDeviceHardware platform];
	if ([platform isEqualToString:@"iPhone1,2"])    return @"HVGA";
	if ([platform isEqualToString:@"iPhone2,1"])    return @"HVGA";
	if ([platform isEqualToString:@"iPhone3,1"])    return @"Double VGA";
	if ([platform isEqualToString:@"iPhone3,2"])    return @"Double VGA";
	if ([platform isEqualToString:@"iPod3,1"])      return @"HVGA";
	if ([platform isEqualToString:@"iPod4,1"])      return @"Double VGA";
	return platform;
}


+ (BOOL)hasRetinaDisplay {
	NSString *platform = [UIDeviceHardware platform];
	BOOL ret = YES;
	if ([platform isEqualToString:@"iPhone1,1"]) {
		ret = NO;
	}
	else
		if ([platform isEqualToString:@"iPhone1,2"])    ret = NO;
    else 
			if ([platform isEqualToString:@"iPhone2,1"])    ret = NO;
			else 
        if ([platform isEqualToString:@"iPod1,1"])      ret = NO;
				else
					if ([platform isEqualToString:@"iPod2,1"])      ret = NO;
					else
						if ([platform isEqualToString:@"iPod3,1"])      ret = NO;
	return ret;
}

+ (NSString*)getDeviceUUID {
    
    const char *cStr = [[UIDeviceHardware getMacAddress] UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *resultStr = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3], 
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ]; 
    
    return [resultStr lowercaseString];
}

+ (NSString *)getMacAddress 

{ 
    
    int                 mgmtInfoBase[6]; 
    
    char                *msgBuffer = NULL; 
    
    size_t              length; 
    
    unsigned char       macAddress[6]; 
    
    struct if_msghdr    *interfaceMsgStruct; 
    
    struct sockaddr_dl  *socketStruct; 
    
    NSString            *errorFlag = NULL; 
    
    
    
    // Setup the management Information Base (mib) 
    
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem 
    
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info 
    
    mgmtInfoBase[2] = 0;               
    
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information 
    
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces 
    
    
    
    // With all configured interfaces requested, get handle index 
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)  
        
        errorFlag = @"if_nametoindex failure"; 
    
    else 
        
        { 
            
            // Get the size of the data available (store in len) 
            
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)  
                
                errorFlag = @"sysctl mgmtInfoBase failure"; 
            
            else 
                
                { 
                    
                    // Alloc memory based on above call 
                    
                    if ((msgBuffer = malloc(length)) == NULL) 
                        
                        errorFlag = @"buffer allocation failure"; 
                    
                    else 
                        
                        { 
                            
                            // Get system information, store in buffer 
                            
                            if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) 
                                
                                errorFlag = @"sysctl msgBuffer failure"; 
                            
                        } 
                    
                } 
            
        } 
    
    
    
    // Befor going any further... 
    
    if (errorFlag != NULL) 
        
        { 
            
            NSLog(@"Error: %@", errorFlag); 
            
            return errorFlag; 
            
        } 
    
    
    // Map msgbuffer to interface message structure 
    
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer; 
    
    
    
    // Map to link-level socket structure 
    
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1); 
    
    
    
    // Copy link layer address data in socket structure to an array 
    
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6); 
    
    
    
    // Read from char array into a string object, into traditional Mac address format 
    
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",  
                                  
                                  macAddress[0], macAddress[1], macAddress[2],  
                                  
                                  macAddress[3], macAddress[4], macAddress[5]]; 
    
//    NSLog(@"Mac Address: %@", macAddressString); 
    
    
    
    // Release the buffer memory 
    
    free(msgBuffer); 
    
    
    return macAddressString; 
    
}

+ (UIDevice *)currentDevice {
    return [UIDevice currentDevice];
}

+(NSString*)uuid {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString ;
}



@end
