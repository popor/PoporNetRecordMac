//
//  ColumnTool.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnEntity.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * TvColumnId_info1       = @"tag1";
static NSString * TvColumnTitle_info1    = @"开关";
static NSString * TvColumnTip_info1      = @"";

static NSString * TvColumnId_info2       = @"tag2";
static NSString * TvColumnTitle_info2    = @"备注";
static NSString * TvColumnTip_info2      = @"";

static NSString * TvColumnId_info3       = @"tag3";
static NSString * TvColumnTitle_info3    = @"设备名称";
static NSString * TvColumnTip_info3      = @"";

//static NSString * TvColumnId_info4       = @"tag4";
//static NSString * TvColumnTitle_info4    = @"开关";
//static NSString * TvColumnTip_info4      = @"";

//static NSString * TvColumnId_info5       = @"tag5";
//static NSString * TvColumnTitle_info5    = @"服务开关";
//static NSString * TvColumnTip_info5      = @"";


@interface ColumnTool : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSMutableArray * columnTagArray;

@end

NS_ASSUME_NONNULL_END
