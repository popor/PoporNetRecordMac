//
//  PnrWebBodyYcUrl.h
//  PoporNetRecordMac
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * YcUrlPsd_saveKey = @"YcUrlPsd";

@interface PnrWebBodyYcUrl : NSObject

+ (NSString *)ycUrlBody;

+ (NSString *)getPsd;
+ (BOOL)updatePsd:(NSString *)psd;

+ (NSString *)analysisUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
