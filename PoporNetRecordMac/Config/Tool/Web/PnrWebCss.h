//
//  PnrWebCss.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PnrWebCss : NSObject

+ (NSString *)cssPMarginPadding;
// 单行
+ (NSString *)cssDivWordOneLine;
// 自动变换高度
+ (NSString *)cssTextarea;
// button
+ (NSString *)cssButton;

@end

NS_ASSUME_NONNULL_END
