//
//  PnrCellEntity.m
//  PoporNetRecord_Example
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrCellEntity.h"

@implementation PnrCellEntity

+ (PnrCellEntity *)type:(PnrListType)type title:(NSString *)title {
    PnrCellEntity * entity = [PnrCellEntity new];
    entity.type  = type;
    entity.title = title;
    
    return entity;
}

@end
