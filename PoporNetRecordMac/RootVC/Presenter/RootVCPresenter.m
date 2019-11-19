//
//  RootVCPresenter.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

#import "EditableTextField.h"
#import "NSTextField+Address.h"
#import "NSButton+Address.h"
#import "PnrPortEntity.h"
#import "PoporNetRecord.h"
#import <PoporAFN/PoporAFN.h>

static int CellHeight = 23;

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
    [self freshAction];
    
    @weakify(self);
    _pnr.blockFreshDeviceName = ^(void) {
        @strongify(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.infoTV reloadData];
        });
    };
    
    [self setPnrResubmit];
    
    [self setPnrConfig];
    //[self setStatusImage];
}

- (void)setPnrResubmit {
    [PoporAFNConfig share].recordBlock = ^(NSString *url, NSString *title, NSString *method, id head, id parameters, id response) {
        [PoporNetRecord addUrl:url title:title method:method head:head parameter:parameters response:response]; //PoporNetRecord 会触发 blockExtraRecord
    };
    [PoporNetRecord setPnrBlockResubmit:^(NSDictionary *formDic, PnrBlockFeedback  _Nonnull blockFeedback) {
        NSString * title        = formDic[@"title"];
        NSString * urlStr       = formDic[@"url"];
        NSString * methodStr    = formDic[@"method"];
        NSString * headStr      = formDic[@"head"];
        NSString * parameterStr = formDic[@"parameter"];
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
            
            [[PoporAFN new] title:title url:urlStr method:PoporMethodGet parameters:parameterStr.toDic afnManager:manager success:finishBlock failure:errorBlock];
        }
    } extraDic:@{}];
}

- (void)setStatusImage {
    //获取系统单例NSStatusBar对象
    self.statusItem = ({
        NSStatusBar * statusBar = [NSStatusBar systemStatusBar];
        NSStatusItem * item = [statusBar statusItemWithLength:NSVariableStatusItemLength];
        //NSStatusItem *statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
        item.button.image = [NSImage imageNamed:@"icon_16x16"];
        
        [item.button setTarget:self];
        [item.button setAction:@selector(statusItemAction:)];
        
        item.menu = [NSMenu new];
        {
            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"显示" action:@selector(menuShow) keyEquivalent:@""];
            
            [item.menu addItem:mi];
        }
        {
            NSMenuItem * mi = [NSMenuItem separatorItem];
            [item.menu addItem:mi];
        }
        {
            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(menuExit) keyEquivalent:@""];
            mi.enabled = YES;
            
            [item.menu addItem:mi];
        }
        
        item;
    });
    
}

- (void)statusItemAction:(NSStatusItem *)item {NSLog(@"%s", __func__); }
- (void)menuExit { }
- (void)menuShow { }

- (void)setPnrConfig {
    PnrConfig * config = [PnrConfig share];
    //NSImage * image = [NSImage imageNamed:@"icon"];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    config.webIconData = [NSData dataWithContentsOfFile:path];
}

// MARK: 获取manager
- (AFHTTPSessionManager *)managerDic:(NSDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
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
                [[PnrPortEntity share] savePort_get:[NSString stringWithFormat:@"%i", port]];
                
                [[PoporNetRecord share].webServer updatePort];
                [weakSelf freshAction];
            }
        }
    }];
}

- (void)createRequestAction {
    [PoporNetRecord addDic:
     @{@"deviceName":SimulatorName,
       @"title":@"title",
       @"url":@"http://www.baidu.com",
       @"method":@"POST",
       @"path":@"path",
       @"headValue":@{@"headValue":@"headValue"},
       @"parameterValue":@{@"parameterValue":@"parameterValue"},
       @"responseValue":@{@"responseValue":@"responseValue"},
       @"time":[NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"],
     }];
}

- (void)freshAction {
    [self freshWifiName];
    [self startServer];
    [self.view.infoTV reloadData];
}

- (void)freshWifiName {
    CWInterface *wif = [[CWWiFiClient  sharedWiFiClient] interface];
    //当前wifi名称
    //NSLog(@"BSD if name: %@", wif.interfaceName);
    //ssid
    //NSLog(@"SSID: %@", wif.ssid);
    self.view.wifiTF.stringValue = [NSString stringWithFormat:@"WIFI: %@", wif.ssid];
}

- (void)startServer {
    PoporNetRecord * pnr = [PoporNetRecord share];
    self.view.ipTF.stringValue = pnr.webServer.webServer.serverURL.absoluteString;
    
    //if (pnr.webServer.webServer.serverURL) {
    //    NSString * url = pnr.webServer.webServer.serverURL.absoluteString;
    //    self.view.portTF.stringValue = [NSString stringWithFormat:@"%i", (int)pnr.webServer.webServer.port];
    //
    //    [url substringToIndex:url.length - self.view.portTF.stringValue.length - 2];
    //}
}

- (void)webviewAction {
    PoporNetRecord * pnr = [PoporNetRecord share];
    [[NSWorkspace sharedWorkspace] openURL:pnr.webServer.webServer.serverURL];
}

#pragma mark table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return self.pnr.deviceNameArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return CellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //*
    __weak typeof(self) weakSelf = self;
    
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
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.note ? :@"null";
            cell = cellTF;
            
            cellTF.weakEntity = entity;
            __block BOOL startMonitor = NO;
            [cellTF.rac_textSignal subscribeNext:^(id x) {
                if (!startMonitor) {
                    startMonitor = YES;
                }else{
                    if (cellTF.weakEntity == entity) {
                        //[weakSelf.interactor updateEntity:entity originPath:x];
                    }
                }
            }];
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
        int font = 17;
        cellTF = [[EditableTextField alloc] initWithFrame:CGRectMake(0, (CellHeight-font)/2, tableColumn.width, font)];
        cellTF.font            = [NSFont systemFontOfSize:font-2];
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

//// !!!: column 排序
//- (void)tableView:(NSTableView *)tableView didDragTableColumn:(NSTableColumn *)tableColumn {
//    if (tableView.tag == folderTVTag) {
//        //NSLog(@"tv did drag : %@", tableColumn.identifier);
//        for (int i=0; i< tableView.tableColumns.count; i++) {
//            //NSLog(@"i = %i id:%@", i, tableColumn.identifier);
//            NSTableColumn * column = tableView.tableColumns[i];
//            [PDB updateClass:[ColumnEntity class] key:@"sort" equal:@(i) where:@"columnID" equal:column.identifier];
//        }
//    }
//}
//
//// !!!: column resize 系统通知事件,类似delegate.
//- (void)tableViewColumnDidResize:(NSNotification *)notification {
//    if (!self.isAllowColumnUpdateWidth) {
//        return;
//    }
//
//    NSTableColumn * column = notification.userInfo[@"NSTableColumn"];
//    if ([column.identifier hasPrefix:@"folder"]) {
//        // 现在的策略是忽略最后一个NSTableColumn,因为这个会随着window.size变化,忽略即可完美处理.
//        if ([column isEqual:self.view.folderTV.tableColumns.lastObject]) {
//            //NSLog(@"ignore");
//            return;
//        }else{
//            //NSLog(@"notification: %@ \n tableColumn.identifier:%@  width:%i", [notification description], column.identifier,  (int)column.width);
//            //int NSOldWidth = (int)[notification.userInfo[@"NSOldWidth"] intValue];
//            //NSLog(@"folder TV update column width : id:%@,  width:%i", column.identifier,  (int)column.width);
//            NSLog(@"更新 folder TV width");
//            [PDB updateClass:[ColumnEntity class] key:@"width" equal:@(column.width) where:@"columnID" equal:column.identifier];
//        }
//    }else if ([column.identifier hasPrefix:@"tag"]) {
//        //NSLog(@"tag TV update column width : id:%@,  width:%i", column.identifier,  (int)column.width);
//        NSLog(@"更新 tag TV width");
//        [PDB updateClass:[ColumnEntity class] key:@"width" equal:@(column.width) where:@"columnID" equal:column.identifier];
//
//        [self.view.tagTV_CSV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(column.width + 20);
//        }];
//    }
//}
//
//- (void)resetTagTVWidth {
//    int width = 200;
//    [PDB updateClass:[ColumnEntity class] key:@"width" equal:@(width) where:@"columnID" equal:TvColumnId_tag1];
//
//    [self.view.tagTV_CSV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width + 20);
//    }];
//}
//
//// !!!: row 排序模块
//// [tableView registerForDraggedTypes:@[NSPasteboardNameDrag]];
//// https://juejin.im/entry/5795deb90a2b580061c7eb74
//- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
//    if (tableView == self.view.folderTV || tableView == self.view.tagTV) {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
//        //NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        [pboard declareTypes:@[NSPasteboardNameDrag] owner:self];
//
//        [pboard setData:data forType:NSPasteboardNameDrag];
//        [pboard setString:[NSString stringWithFormat:@"%li", [rowIndexes firstIndex]] forType:NSPasteboardNameDrag];
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
//- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
//    if (tableView == self.view.folderTV || tableView == self.view.tagTV) {
//        if (dropOperation == NSTableViewDropAbove) {
//            return NSDragOperationMove;
//        }else{
//            return NSDragOperationNone;
//        }
//    }else{
//        return NSDragOperationNone;
//    }
//}
//
//- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
//    NSString * currencyCode = [info.draggingPasteboard stringForType:NSPasteboardNameDrag];
//    NSInteger from = [currencyCode integerValue];
//    if (tableView == self.view.folderTV) {
//        [self resortTV:tableView form:from to:row array:self.interactor.folderEntityArray];
//        [self updateArray:self.interactor.folderEntityArray key:@"sort" whereKey:@"folderID"];
//        return YES;
//    }else if(tableView == self.view.tagTV){
//        [self resortTV:tableView form:from to:row array:self.interactor.tagEntityArray];
//        [self updateArray:self.interactor.tagEntityArray key:@"sort" whereKey:@"tagID"];
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
//- (void)resortTV:(NSTableView *)tableView form:(NSInteger)from to:(NSInteger)to array:(NSMutableArray *)array {
//    if (array.count > 1 && from != to && (from-to) != -1) {
//        NSLog(@"from: %li, to:%li", from, to);
//        id entity = array[from];
//        [array removeObject:entity];
//        if (from > to) {
//            [array insertObject:entity atIndex:to];
//        }else{
//            [array insertObject:entity atIndex:to-1];
//        }
//        [tableView reloadData];
//    }
//}
//
//- (void)updateArray:(NSMutableArray *)array key:(NSString *)key whereKey:(NSString *)whereKey {
//    for (NSInteger i = 0; i<array.count; i++) {
//        id sortEntity = array[i];
//        [PDB updateEntity:sortEntity key:key equal:@(i) where:whereKey];
//    }
//}
//
//#pragma mark - VC_EventHandler
//- (void)tableViewClick:(NSTableView *)tableView {
//    NSInteger row = tableView.clickedRow;
//    //NSInteger Column = tableView.clickedColumn;
//    //NSLog(@"点击Column: %li row: %li",Column, row);
//
//    if (tableView.tag == TagTVTag) {
//        if (self.interactor.tagEntityArray == 0) {
//            [self.interactor.folderEntityArray removeAllObjects];
//            [self.view.folderTV reloadData];
//        }else{
//            if (row>-1) {
//                MoveTagEntity * entity = self.interactor.tagEntityArray[row];
//                [self.interactor updateMoveFolderArrayWith:entity];
//                [self.view.folderTV reloadData];
//            }
//        }
//    }
//}

- (void)cellMoveBTAction:(NSButton *)cellBT {
    PnrDeviceEntity * entity = (PnrDeviceEntity *)cellBT.weakEntity;
    //cellBT.state = entity.receive ? NSControlStateValueOn:NSControlStateValueOff;
    entity.receive = cellBT.state==NSControlStateValueOn ? YES:NO;
    
}

#pragma mark - Interactor_EventHandler

@end
