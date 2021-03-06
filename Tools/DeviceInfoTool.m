//
//  DeviceInfoTool.m
//
//  Created by PP on 15/8/28.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//
//  获取设备信息及系统信息

#import <SystemConfiguration/CaptiveNetwork.h>
#import "DeviceInfoTool.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation DeviceInfoTool

// 获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+ (NSString *)getSystemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)getApplicationVersion
{
    NSString *versionKey = @"CFBundleShortVersionString";
    return [NSBundle mainBundle].infoDictionary[versionKey];
}

+ (NSString *)getBundleIdentifier
{
    return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)getBundleVersion
{
    return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
}

+ (CGSize)getScreenPixel
{
    CGSize size_screen = [[UIScreen mainScreen] bounds].size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width * scale_screen;
    CGFloat height = size_screen.height * scale_screen;
    
    return CGSizeMake(width, height);
}

+ (NSString *)getCurrentWiFiSSID
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}
@end
