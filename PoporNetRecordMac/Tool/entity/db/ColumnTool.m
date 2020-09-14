//
//  ColumnTool.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import "ColumnTool.h"
#import <PoporFMDB/PoporFMDB.h>

@implementation ColumnTool

+ (instancetype)share {
    static dispatch_once_t once;
    static ColumnTool * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance initColumnTagArray];
    });
    return instance;
}

- (void)initColumnTagArray {
    _columnTagArray = [PDB arrayClass:[ColumnEntity class] where:ColumnEntity_type equal:ColumnTypeTag];
    // orderBy:@"sort" asc:YES
    
    if (_columnTagArray.count != 1) {
        [PDB deleteClass:[ColumnEntity class] where:ColumnEntity_type equal:ColumnTypeTag];
        _columnTagArray = [NSMutableArray new];
        NSArray * IDArray        = @[TvColumnId_info1,    TvColumnId_info2,    TvColumnId_info3];
        NSArray * titleArray     = @[TvColumnTitle_info1, TvColumnTitle_info2, TvColumnTitle_info3];
        NSArray * tipArray       = @[TvColumnTip_info1,   TvColumnTip_info2,   TvColumnTip_info3];
        
        NSArray * widthArray     = @[@(25), @(70), @(ColumnTagMiniWidth)];
        NSArray * miniWidthArray = @[@(25), @(70), @(ColumnTagMiniWidth)];
        
        for (int i=0; i<IDArray.count; i++) {
            ColumnEntity * entity = [ColumnEntity new];
            entity.uuid      = [ColumnTool getUUID];
            entity.type      = ColumnTypeTag;
            
            entity.sort      = i;
            entity.columnID  = IDArray[i];
            entity.tip       = tipArray[i];
            entity.title     = titleArray[i];
            entity.width     = [widthArray[i] intValue];
            entity.miniWidth = [miniWidthArray[i] intValue];
            
            [_columnTagArray addObject:entity];
            
            [PDB addEntity:entity];
        }
    }
}

+ (NSString *)getUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString  * uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
@end
