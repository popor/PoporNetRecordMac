//
//  PoporNetRecord.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PnrPrefix.h"
#import "PnrConfig.h"
#import "PnrEntity.h"
#import "PnrDeviceEntity.h"
#import "PnrWebServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PnrConfig           * config;
@property (nonatomic, weak  ) PnrWebServer        * webServer;

@property (nonatomic, strong) NSMutableArray      * infoArray;
@property (nonatomic, strong) NSMutableArray      * deviceNameArray;
@property (nonatomic, strong) NSMutableDictionary * deviceNameDic;

@property (nonatomic, copy  ) BlockPVoid          blockFreshDeviceName;

+ (instancetype)share;

// 网络请求部分
/**
 headValue:      NSDictionary | NSString
 parameterValue: NSDictionary | NSString
 responseValue:  NSDictionary | NSString
 */
+ (void)addRecordID:(NSString *)recordID url:(NSString *)urlString method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue;

// 增加title
+ (void)addRecordID:(NSString *)recordID url:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue;

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic;

// Log 部分
+ (void)addRecordID:(NSString *)recordID log:(NSString *)log;
+ (void)addRecordID:(NSString *)recordID log:(NSString *)log title:(NSString *)title;

+ (void)addDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

