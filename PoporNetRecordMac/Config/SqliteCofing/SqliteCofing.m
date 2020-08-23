//
//  SqliteCofing.m
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SqliteCofing.h"

#import "ColumnEntity.h"
#import "PnrDeviceEntity.h"
#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrRequestTestEntity.h"

#import <PoporFMDB/PoporFMDB.h>

@implementation SqliteCofing

// MARK: 创建table
+ (void)updateTable {
    // 更新PoporFMDB
    [PoporFMDB injectTableArray:@[[ColumnEntity class], [PnrDeviceEntity class], [PnrEntity class], [PnrRequestTestEntity class]]];
}

// MARK: 主 window frame 相关
+ (void)updateWindowFrame:(CGRect)rect {
    [PoporFMDB updatePlistKey:WindowFrameKey value:NSStringFromRect(rect)];
}

+ (void)addWindowFrame:(CGRect)rect {
    [PoporFMDB addPlistKey:WindowFrameKey value:NSStringFromRect(rect)];
}

+ (NSString *)getWindowFrame {
    return [PoporFMDB getPlistKey:WindowFrameKey];
}
//
+ (void)updatePort:(NSString *)port {
    [PoporFMDB updatePlistKey:PNR_Port value:port];
}

+ (void)addPort:(NSString *)port {
    [PoporFMDB addPlistKey:PNR_Port value:port];
}

+ (NSString *)getPort {
    return [PoporFMDB getPlistKey:PNR_Port];
}

// ---
+ (void)updateApi:(NSString *)api {
    [PoporFMDB updatePlistKey:PNR_APi value:api];
}

+ (void)addApi:(NSString *)api {
    [PoporFMDB addPlistKey:PNR_APi value:api];
}

+ (NSString *)getApi {
    return [PoporFMDB getPlistKey:PNR_APi];
}


// MARK: 其他


@end
