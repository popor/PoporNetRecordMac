//
//  RootVCPresenter.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import "RootVCProtocol.h"

// 处理和View事件
@interface RootVCPresenter : NSObject <RootVCEventHandler, RootVCDataSource, RootVCEventHandler, NSTableViewDelegate, NSTableViewDataSource>

- (void)setMyInteractor:(id)interactor;

- (void)setMyView:(id)view;

// 开始执行事件,比如获取网络数据
- (void)startEvent;

@end

