//
//  PoporAppInfo.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporAppInfo : NSObject

/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short;

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build;

@end

NS_ASSUME_NONNULL_END
