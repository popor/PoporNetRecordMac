
//
//  PnrPrefix.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 wangkq. All rights reserved.
//

#ifndef PnrPrefix_h
#define PnrPrefix_h

#import "PnrEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PnrBlockPVoid) (void);
typedef void(^PnrBlockPPnrEntity) (PnrEntity * pnrEntity);
typedef void(^PnrBlockFeedback) (NSString * feedback);
typedef void(^PnrBlockResubmit) (NSDictionary * formDic, PnrBlockFeedback _Nonnull blockFeedback);

typedef NS_ENUM(int, PoporNetRecordType) {
    PoporNetRecordAuto = 1, // 开发环境或者虚拟机环境
    PoporNetRecordEnable, // 全部监测
    PoporNetRecordDisable, // 全部忽略
};

static NSString * PoporNetRecordSet = @"设置";

typedef NS_ENUM(int, PnrListType) {
    PnrListTypeClear,
    PnrListTypeTextColor,
    PnrListTypeTextBlack,
    PnrListTypeTextNull,
    PnrListTypeLogDetail,
    PnrListTypeLogSimply,
    PnrListTypeLogNull,
};

NS_ASSUME_NONNULL_END

#endif /* PnrPrefix_h */
