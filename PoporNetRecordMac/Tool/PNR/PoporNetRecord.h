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

@property (nonatomic, strong) NSMutableArray      * allRequestArray;
@property (nonatomic, strong) NSMutableArray      * deviceNameArray;
@property (nonatomic, strong) NSMutableDictionary * deviceNameDic;

@property (nonatomic, copy  ) BlockPVoid          blockFreshDeviceName;

@property (nonatomic, strong) NSMutableString     * allRequestListWebH5;

+ (instancetype)share;

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic;

+ (void)addDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

