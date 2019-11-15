//
//  RootVCProtocol.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>

#import "ColumnTool.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: 对外接口
@protocol RootVCProtocol <NSObject>

- (NSViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) NSTableView  * infoTV;
@property (nonatomic, strong) NSScrollView * infoTV_CSV;
@property (nonatomic, strong) NSMenu       * infoTVClickMenu;

// MARK: 外部注入的

@end

// MARK: 数据来源
@protocol RootVCDataSource <NSObject>

- (NSArray *)columnTagArray;

@end

// MARK: UI事件
@protocol RootVCEventHandler <NSObject>

@end

NS_ASSUME_NONNULL_END
