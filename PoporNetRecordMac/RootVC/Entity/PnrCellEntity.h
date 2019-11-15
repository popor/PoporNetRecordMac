//
//  PnrCellEntity.h
//  PoporNetRecord_Example
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PnrPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface PnrCellEntity : NSObject

@property (nonatomic        ) PnrListType type;
@property (nonatomic, strong) NSString * title;

+ (PnrCellEntity *)type:(PnrListType)type title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
