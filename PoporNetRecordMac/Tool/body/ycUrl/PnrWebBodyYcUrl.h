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

static int YcUrl_timeL     = 13;// 包括毫秒为13位,否则10位.
static int YcUrl_phoneL    = 11;
static int YcUrl_sourceL   = 1;
static int YcUrl_compressL = 1;

@interface PnrWebBodyYcUrl : NSObject

+ (NSString *)ycUrlBody;

+ (NSString *)getPsd;
+ (BOOL)updatePsd:(NSString *)psd;

+ (NSDictionary *)analysisUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
