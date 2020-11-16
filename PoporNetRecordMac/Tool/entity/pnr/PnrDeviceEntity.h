//
//  PnrDeviceEntity.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import <PoporJsonModel/PoporJsonModel.h>
#import "PnrEntity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PnrDeviceEntity;
@interface PnrDeviceEntity : PoporJsonModel

@property (nonatomic        ) NSInteger  sort;

@property (nonatomic        ) BOOL       receive; // 是否接收
@property (nonatomic, strong) NSString * note;
@property (nonatomic, strong) NSString * deviceName;

@property (nonatomic, strong) NSMutableArray<PnrEntity> * requestArray;
@property (nonatomic, strong) NSMutableString * listWebH5;

@end

NS_ASSUME_NONNULL_END
