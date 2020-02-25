//
//  RootVCPresenter.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

#import "EditableTextField.h"
#import "NSView+Address.h"
#import "LLCustomBT.h"
#import "PnrPortEntity.h"
#import "PoporNetRecord.h"
#import <PoporAFN/PoporAFN.h>
#import "iToast.h"
#import "PnrRequestTestEntity.h"

static int CellHeight = 23;

static NSString * SepactorKey = @"_PnrMac_";

@interface RootVCPresenter ()

@property (nonatomic, weak  ) id<RootVCProtocol> view;
@property (nonatomic, strong) RootVCInteractor * interactor;

@property (nonatomic, weak  ) PoporNetRecord * pnr;

@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation RootVCPresenter

- (id)init {
    if (self = [super init]) {
        _pnr = [PoporNetRecord share];
        
    }
    return self;
}

- (void)setMyInteractor:(RootVCInteractor *)interactor {
    self.interactor = interactor;
    
}

- (void)setMyView:(id<RootVCProtocol>)view {
    self.view = view;
    
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    
    @weakify(self);
    _pnr.blockFreshDeviceName = ^(void) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.infoTV reloadData];
        });
    };
    
    [PnrWebServer share].serverLaunchFinish = ^(BOOL value) {
        @strongify(self);
        if (value) {
            [self freshAction];
        } else {
            AlertToastTitle(@"端口被占用", self.view.vc.view);
        }
    };
    [[PnrWebServer share] startServer];
    
    [self setPnrResubmit];
    
    [self setPnrConfig];
    [self freshLeftIfrmeL];
    //[self setStatusImage];
}

- (void)setPnrResubmit {
    [PoporAFNConfig share].recordBlock = ^(NSString *url, NSString *title, NSString *method, id head, id parameters, id response) {
        NSRange range = [title rangeOfString:SepactorKey];
        NSString * deviceName = PnrCN_Simulator;
        if (range.length > 0) {
            deviceName = [title substringFromIndex:range.location + SepactorKey.length];
            title = [title substringToIndex:range.location];
        }
        
        NSDictionary * dic =
        @{PnrKey_Url:url,
          PnrKey_Title:title,
          PnrKey_Method:method,
          PnrKey_Head:head,
          PnrKey_Parameter:parameters,
          PnrKey_Response:response,
          PnrKey_Time:[NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"],
          PnrKey_DeviceName:deviceName,
        };
        [PoporNetRecord addDic:dic];
    };
    [PoporNetRecord setPnrBlockResubmit:^(NSDictionary *formDic, PnrBlockFeedback  _Nonnull blockFeedback) {
        NSString * title        = formDic[PnrKey_Title];
        NSString * urlStr       = formDic[PnrKey_Url];
        NSString * methodStr    = formDic[PnrKey_Method];
        NSString * headStr      = formDic[PnrKey_Head];
        NSString * parameterStr = formDic[PnrKey_Parameter];
        NSString * deviceName   = formDic[PnrKey_DeviceName];
        
        //NSString * extraStr     = formDic[@"extra"];
        title = [title hasPrefix:@"["] ? title:[NSString stringWithFormat:@"[%@]", title];
        
        AFHTTPSessionManager * manager = [self managerDic:headStr.toDic];
        
        PoporAFNFinishBlock finishBlock = ^(NSString * _Nonnull url, NSData * _Nonnull data, NSDictionary * _Nonnull dic) {
            // 结果反馈给PoporNetRecord
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (dic) {
                    blockFeedback(dic.toJsonString);
                }else{
                    blockFeedback(@{@"error":@"非dic"}.toJsonString);
                }
            });
        };
        
        PoporAFNFailureBlock errorBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 结果反馈给PoporNetRecord
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                blockFeedback(@{@"error":error.localizedDescription}.toJsonString);
            });
        };
        
        {
            PoporMethod method;
            if ([methodStr.lowercaseString isEqualToString:@"get"]) {
                method = PoporMethodGet;
            } else if ([methodStr.lowercaseString isEqualToString:@"post"]) {
                method = PoporMethodPost;
            } else {
                return ;
            }
            
            [[PoporAFN new] title:[NSString stringWithFormat:@"%@%@%@", title, SepactorKey, deviceName] url:urlStr method:PoporMethodGet parameters:parameterStr.toDic afnManager:manager success:finishBlock failure:errorBlock];
        }
    } extraDic:@{}];
}

- (void)setPnrConfig {
    PnrConfig * config = [PnrConfig share];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    config.webIconData = [NSData dataWithContentsOfFile:path];
}

// MARK: 获取manager
- (AFHTTPSessionManager *)managerDic:(NSDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]; // 不然不支持www.baidu.com.
    
    NSArray * keyArray = dic.allKeys;
    for (NSString * key in keyArray) {
        [manager.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
    
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    return manager;
}

#pragma mark - VC_EventHandler
- (void)editPortAction {
    
    NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)];
    accessory.placeholderString = @"8080";
    accessory.stringValue = [NSString stringWithFormat:@"%i", [PnrPortEntity share].getPort_get];
    [accessory setEditable:YES];
    
    NSString * message = @"修改端口号";
    NSAlert * alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:message];
    [alert setAlertStyle:NSAlertStyleCritical];
    
    [alert setAccessoryView:accessory];
    
    __weak typeof(self) weakSelf = self;
    [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            int port = accessory.stringValue.intValue;
            if (port > 0) {
                [weakSelf freshAction];
                
                [[PnrPortEntity share] savePort_get:[NSString stringWithFormat:@"%i", port]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[PoporNetRecord share].webServer updateServerPort];
                });
            }
        }
    }];
}

- (void)editLeftIfrmeAction {
    PnrWebBodyRecord * share = [PnrWebBodyRecord share];
    NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)];
    accessory.placeholderString = [NSString stringWithFormat:@"%i", KrecordLeftIframeMiniWidth];
    accessory.stringValue = [NSString stringWithFormat:@"%i", share.recordLeftIframeWidth];
    [accessory setEditable:YES];
    
    NSString * message = @"修改网络请求左侧窗口宽度";
    NSAlert * alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:message];
    [alert setAlertStyle:NSAlertStyleCritical];
    
    [alert setAccessoryView:accessory];
    
    __weak typeof(self) weakSelf = self;
    [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            int width = accessory.stringValue.intValue;
            if (width <= KrecordLeftIframeMiniWidth) {
                AlertToastTitle(@"最小宽度为: 166 px", weakSelf.view.vc.view);
                return;
            }
            if (width > 0) {
                [share saveRecordLeftIframeWidth:width];
                [weakSelf freshAction];
                if (width >= 1000) {
                    AlertToastTitle(@"宽度超过屏幕宽度的话，显示会出错。", weakSelf.view.vc.view);
                }
            }
            
        }
    }];
}

- (void)createRequestAction {
    [PoporNetRecord addDic:
     @{PnrKey_Title:PnrKey_Title,
       PnrKey_Url:@"http://www.baidu.com",
       PnrKey_Method:@"POST",
       PnrKey_Path:@"/path",
       PnrKey_Head:@{PnrKey_Head:PnrKey_Head},
       PnrKey_Parameter:@{PnrKey_Parameter:PnrKey_Parameter},
       PnrKey_Response:@{PnrKey_Response:PnrKey_Response},
       PnrKey_Time:[NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"],
       PnrKey_DeviceName:PnrCN_Simulator,
     }];
}

- (void)createTestAction {
    NSView * view;
    NSTextField * urlTF;
    NSTextField * responseTF;
    {
        urlTF = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 30, 300, 20)];
        urlTF.placeholderString = @"test 开头的URL";
        urlTF.stringValue = @"test_";
        [urlTF setEditable:YES];
    }
    {
        responseTF = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)];
        responseTF.placeholderString = @"返回数据";
        responseTF.stringValue = PnrCN_testDefaultResponse;
        [responseTF setEditable:YES];
    }
    {
        view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        [view addSubview:urlTF];
        [view addSubview:responseTF];
    }
    NSString * message = FunRecord_TestAdd;
    NSAlert * alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:message];
    [alert setAlertStyle:NSAlertStyleCritical];
    
    [alert setAccessoryView:view];
    
    //__weak typeof(self) weakSelf = self;
    [alert beginSheetModalForWindow:self.view.vc.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
            entity.url = urlTF.stringValue;
            entity.response = responseTF.stringValue;
            
            if ([PnrRequestTestEntity addEntity:entity]) {
                AlertToastTitle(@"新增完成", self.view.vc.view);
            } else {
                AlertToastTitle(@"新增失败", self.view.vc.view);
            }
            
            
        }
    }];
}

- (void)freshAction {
    [self freshWifiName];
    [self freshUrlValue];
    [self freshLeftIfrmeL];
    [self.view.infoTV reloadData];
}

- (void)freshWifiName {
    CWInterface *wif = [[CWWiFiClient  sharedWiFiClient] interface];
    if (wif.ssid) {
        self.view.wifiTF.stringValue = [NSString stringWithFormat:@"WIFI: %@", wif.ssid];
    } else {
        self.view.wifiTF.stringValue = @"WIFI: 无";
    }
}

- (void)freshUrlValue {
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.webServer.webServer.serverURL.absoluteString) {
        self.view.ipTF.stringValue = pnr.webServer.webServer.serverURL.absoluteString;
    }
}

- (void)freshLeftIfrmeL {
    PnrWebBodyRecord * share = [PnrWebBodyRecord share];
    self.view.LeftIfrmeL.text = [NSString stringWithFormat:@"网络请求左侧窗口宽度: %i px", share.recordLeftIframeWidth];
    
    //    NSMutableAttributedString * att = [NSMutableAttributedString new];
    //    NSFont * font = [NSFont systemFontOfSize:13];
    //
    //    //NSColor * color1 = [NSColor textBackgroundColor];
    //    NSColor * color1 = [NSColor textColor];
    //    NSColor * color2 = [NSColor textColor]; //[NSColor redColor];[NSColor selectedTextColor];
    //
    //    [att addString:@"网络请求左侧窗口宽度: " font:font color:color1];
    //    [att addString:[NSString stringWithFormat:@"%i", share.recordLeftIframeWidth] font:font color:color2];
    //    [att addString:@" px" font:font color:color1];
    //
    //    self.view.LeftIfrmeL.attributedText = att;
}

- (void)webview_adminAction {
    PoporNetRecord * pnr = [PoporNetRecord share];
       NSString * url = [NSString stringWithFormat:@"%@", pnr.webServer.webServer.serverURL];
       [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}
- (void)webview_recordAction {
    PoporNetRecord * pnr = [PoporNetRecord share];
    NSString * url = [NSString stringWithFormat:@"%@%@", pnr.webServer.webServer.serverURL, PnrGet_recordRoot];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

- (void)webview_testRequstAction {
    
    PoporNetRecord * pnr = [PoporNetRecord share];
    NSString * url = [NSString stringWithFormat:@"%@%@", pnr.webServer.webServer.serverURL, PnrGet_TestRoot];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

#pragma mark table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return self.pnr.deviceNameArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return CellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    //__weak typeof(self) weakSelf = self;
    NSInteger column = [[tableColumn.identifier substringFromIndex:tableColumn.identifier.length-1] intValue];
    //NSLog(@"column: %li", column);
    NSView *cell;
    PnrDeviceEntity * entity = self.pnr.deviceNameArray[row];
    if (!entity) {
        NSLog(@"self.interactor.moveEntityArray count: %li", self.pnr.deviceNameArray.count);
        return nil;
    }
    // NSLog(@"%li - %li", row, column);
    switch (column) {
        case 1:{
            NSButton * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                cellBT = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                [cellBT setButtonType:NSButtonTypeSwitch];
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellMoveBTAction:)];
                cellBT.title = @"";
            }
            cellBT.tag = row;
            cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            
            cellBT.weakEntity = entity;
            
            break;
        }
            
        case 2:{
            LLCustomBT * cellBT = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
            if (!cellBT) {
                //使用方法
                cellBT = [[LLCustomBT alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
                cellBT.isHandCursor = YES;
                cellBT.defaultTitle = @"单独查看";
                //cellBT.selectedTitle = @"已选中";
                cellBT.defaultTitleColor  = [NSColor textColor]; //[NSColor whiteColor];
                //cellBT.selectedTitleColor = [NSColor blackColor];
                cellBT.defaultFont  = [NSFont systemFontOfSize:15];
                //cellBT.selectedFont = [NSFont systemFontOfSize:10];
                cellBT.defaultBackgroundColor  = [NSColor clearColor];
                cellBT.selectedBackgroundColor = [NSColor selectedTextBackgroundColor];
                cellBT.defaultBackgroundImage  = [NSImage imageNamed:@""];
                cellBT.selectedBackgroundImage = [NSImage imageNamed:@""];
                //cellBT.rectCorners = LLRectCornerTopLeft|LLRectCornerBottomLeft;
                //cellBT.radius = 15;
                cellBT.textAlignment = LLTextAlignmentLeft;
                //cellBT.textUnderLineStyle = LLTextUnderLineStyleDeleteDouble;
               
                [cellBT setTarget:self];
                [cellBT setAction:@selector(cellViewBTAction:)];
                
            }
            cellBT.weakEntity = entity;
            //cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            
            break;
        }
        case 3:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:NO initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.deviceName ? :@"";
            cell = cellTF;
            break;
        }
        default: {
            break;
        }
    }
    
    
    return cell;
    // */
}

// 返回编辑状态下成白色的背景色的TF.
- (EditableTextField *)tableView:(NSTableView *)tableView cellTFForColumn:(NSTableColumn *)tableColumn row:(NSInteger)row edit:(BOOL)edit initBlock:(BlockPDic)block {
    EditableTextField * cellTF = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self.view];
    if (!cellTF) {
        int font = 15;
        cellTF = [[EditableTextField alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, CellHeight)];
        cellTF.font            = [NSFont systemFontOfSize:font];
        cellTF.alignment       = NSTextAlignmentCenter;
        cellTF.editable        = edit;
        cellTF.identifier      = tableColumn.identifier;
        
        cellTF.backgroundColor = [NSColor clearColor];
        cellTF.bordered        = NO;
        
        cellTF.lineBreakMode   = NSLineBreakByTruncatingMiddle;
        if (block) {
            block(@{@"tf":cellTF});
        }
    }
    cellTF.tag = row;
    return cellTF;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    // NSLog(@"clumn : %@", tableColumn.identifier);
}

- (void)cellMoveBTAction:(NSButton *)cellBT {
    PnrDeviceEntity * entity = (PnrDeviceEntity *)cellBT.weakEntity;
    //cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
    entity.receive = cellBT.state==NSControlStateValueOn ? YES:NO;
    
}

- (void)cellViewBTAction:(NSButton *)cellBT {
    PnrDeviceEntity * entity = (PnrDeviceEntity *)cellBT.weakEntity;
    PoporNetRecord * pnr     = [PoporNetRecord share];
    NSString * url           = [NSString stringWithFormat:@"%@%@?%@=%@", pnr.webServer.webServer.serverURL.absoluteString, PnrGet_recordRoot, PnrKey_DeviceName, entity.deviceName];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
    
}

#pragma mark - Interactor_EventHandler

@end
