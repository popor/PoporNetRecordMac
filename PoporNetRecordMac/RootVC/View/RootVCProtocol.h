//
//  RootVCProtocol.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import <Foundation/Foundation.h>

#import "ColumnTool.h"
#import "EditableTextField.h"
#import "JHLabel.h"
#import "PnrWebBodyRecord.h"

//#import <SystemConfiguration/CaptiveNetwork.h>
//#import <SystemConfiguration/SystemConfiguration.h>

#import <CoreWLAN/CoreWLAN.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * FunRecord_Fresh       = @"刷新";
static NSString * FunRecord_View        = @"查看";

static NSString * FunAdmin              = @"网页入口";

static NSString * FunRecord_RequestAdd  = @"新增记录";
static NSString * FunRecord_TestAdd     = @"新增测试";

static NSString * FunTest_Request       = @"模拟管理";

// MARK: 对外接口
@protocol RootVCProtocol <NSObject>

- (NSViewController *)vc;

// MARK: 自己的
@property (nonatomic, strong) NSTableView  * infoTV;
@property (nonatomic, strong) NSScrollView * infoTV_CSV;
@property (nonatomic, strong) NSMenu       * infoTVClickMenu;

@property (nonatomic, strong) EditableTextField * ipTF;
@property (nonatomic, strong) EditableTextField * wifiTF;
@property (nonatomic, strong) NSButton          * editPortBT;

@property (nonatomic, strong) NSButton          * funFirstBT;

@property (nonatomic, strong) JHLabel           * recordApiL;
@property (nonatomic, strong) NSButton          * editRecordApiBT;

@property (nonatomic, strong) JHLabel           * LeftIfrmeL;
@property (nonatomic, strong) NSButton          * editLeftIfrmeBT;

// MARK: 外部注入的

@end

// MARK: 数据来源
@protocol RootVCDataSource <NSObject>

@end

// MARK: UI事件
@protocol RootVCEventHandler <NSObject>

- (void)freshAction;
- (void)editPortAction;
- (void)editApiAction;
- (void)editLeftIfrmeAction;
- (void)createRequestAction;
- (void)createTestAction;

- (void)webview_adminAction;
- (void)webview_recordAction;
- (void)webview_testRequstAction;

- (void)freshLeftIfrmeL;

@end

NS_ASSUME_NONNULL_END
