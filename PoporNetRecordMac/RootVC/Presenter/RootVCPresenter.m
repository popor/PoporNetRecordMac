//
//  RootVCPresenter.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

#import "EditableTextField.h"

static int CellHeight = 23;

@interface RootVCPresenter ()

@property (nonatomic, weak  ) id<RootVCProtocol> view;
@property (nonatomic, strong) RootVCInteractor * interactor;

@end

@implementation RootVCPresenter

- (id)init {
    if (self = [super init]) {
        
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
    [self.interactor startServer];
    
}

#pragma mark - VC_DataSource
#pragma mark table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return 0;
    //    if (aTableView.tag == folderTVTag) {
    //        //NSLog(@"folderTV %li", self.interactor.moveEntityArray.count);
    //        return self.interactor.folderEntityArray.count;
    //    }else if (aTableView.tag == TagTVTag){
    //        //NSLog(@"tagTV %li", self.interactor.moveTagArray.count);
    //        return self.interactor.tagEntityArray.count;
    //    }else{
    //        //NSLog(@"TV 0");
    //        return 0;
    //    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return CellHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
    /*
    __weak typeof(self) weakSelf = self;
    
    NSInteger column = [[tableColumn.identifier substringFromIndex:tableColumn.identifier.length-1] intValue];
    //NSLog(@"column: %li", column);
    NSView *cell;
    MoveFolderEntity * entity = self.interactor.folderEntityArray[row];
    if (!entity) {
        NSLog(@"self.interactor.moveEntityArray count: %li", self.interactor.folderEntityArray.count);
        return nil;
    }
    // NSLog(@"%li - %li", row, column);
    switch (column) {
        case 0:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:NO initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentCenter;
            }];
            cellTF.stringValue = [NSString stringWithFormat:@"%li", row];
            cell = cellTF;
            break;
        }
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
            cellBT.state = entity.move ? NSControlStateValueOn:NSControlStateValueOff;
            cell = cellBT;
            
            break;
        }
        case 2:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.originPath;
            cell = cellTF;
            
            cellTF.weakEntity = entity;
            __block BOOL startMonitor = NO;
            [cellTF.rac_textSignal subscribeNext:^(id x) {
                if (!startMonitor) {
                    startMonitor = YES;
                }else{
                    if (cellTF.weakEntity == entity) {
                        [weakSelf.interactor updateEntity:entity originPath:x];
                    }
                }
            }];
            break;
        }
        case 3:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.targetPath;
            cell = cellTF;
            
            cellTF.weakEntity = entity;
            __block BOOL startMonitor = NO;
            [cellTF.rac_textSignal subscribeNext:^(id x) {
                if (!startMonitor) {
                    startMonitor = YES;
                }else{
                    if (cellTF.weakEntity == entity) {
                        [weakSelf.interactor updateEntity:entity targetPath:x];
                    }
                }
            }];
            
            break;
        }
        case 4:{
            NSTextField * cellTF = [self tableView:tableView cellTFForColumn:tableColumn row:row edit:YES initBlock:^(NSDictionary *dic) {
                NSTextField * tf = dic[@"tf"];
                tf.alignment = NSTextAlignmentLeft;
            }];
            cellTF.stringValue = entity.tip;
            cell = cellTF;
            
            cellTF.weakEntity = entity;
            __block BOOL startMonitor = NO;
            [cellTF.rac_textSignal subscribeNext:^(id x) {
                if (!startMonitor) {
                    startMonitor = YES;
                }else{
                    if (cellTF.weakEntity == entity) {
                        [weakSelf.interactor updateEntity:entity tip:x];
                    }
                }
            }];
            break;
        }
        default:
            break;
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

#pragma mark - VC_EventHandler

#pragma mark - Interactor_EventHandler

@end
