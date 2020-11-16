//
//  PnrDeviceEntity.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrDeviceEntity.h"

@implementation PnrDeviceEntity

- (id)init {
    if (self =[super init]) {
        _receive      = YES;
        _requestArray = [NSMutableArray<PnrEntity> new];
        _listWebH5    = [NSMutableString new];
    }
    return self;
}

@end
