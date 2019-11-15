//
//  RootVC.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "RootVCProtocol.h"

@interface RootVC : NSViewController <RootVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)addViews;

// 开始执行事件,比如获取网络数据
- (void)startEvent;


@end

