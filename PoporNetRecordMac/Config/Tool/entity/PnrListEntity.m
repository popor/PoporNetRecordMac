//
//  PnrListEntity.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrListEntity.h"

@implementation PnrListEntity

- (id)init {
    if (self =[super init]) {
        _list = [NSMutableArray<PnrEntity> new];
    }
    return self;
}

@end
