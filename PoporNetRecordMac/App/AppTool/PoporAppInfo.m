//
//  PoporAppInfo.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PoporAppInfo.h"

@implementation PoporAppInfo

/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

@end
