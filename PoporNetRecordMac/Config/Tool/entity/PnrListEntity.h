//
//  PnrListEntity.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import <PoporJsonModel/PoporJsonModel.h>

#import "PnrEntity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PnrListEntity;
@interface PnrListEntity : PoporJsonModel

@property (nonatomic        ) NSInteger  sort;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * note;
@property (nonatomic, strong) NSString * recordID;

@property (nonatomic, strong) NSMutableArray<PnrEntity> * list;
@end

NS_ASSUME_NONNULL_END
