//
//  SqliteCofing.h
//  MoveFile
//
//  Created by apple on 2019/10/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SqlitePrifix.h"

NS_ASSUME_NONNULL_BEGIN

@interface SqliteCofing : NSObject

// MARK: 创建table
+ (void)updateTable;

// MARK: 主 window frame 相关
+ (void)updateWindowFrame:(CGRect)rect;

+ (void)addWindowFrame:(CGRect)rect;

+ (NSString *)getWindowFrame;

// MARK: 端口号
+ (void)updatePort:(NSString *)port;
+ (void)addPort:(NSString *)port;
+ (NSString *)getPort;

// MARK: 接口
+ (void)updateApi:(NSString *)api;

+ (void)addApi:(NSString *)api;

+ (NSString *)getApi;
// MARK: 其他


@end

NS_ASSUME_NONNULL_END
