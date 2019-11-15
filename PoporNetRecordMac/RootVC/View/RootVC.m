//
//  RootVC.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVC.h"
#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

@interface RootVC ()

@property (nonatomic, strong) RootVCPresenter * present;

@end

@implementation RootVC
@synthesize infoTV;
@synthesize infoTV_CSV;
@synthesize infoTVClickMenu;


- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [self assembleViper];
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"网络监控";
    }
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

#pragma mark - VCProtocol
- (NSViewController *)vc {
    return self;
}

#pragma mark - viper views
- (void)assembleViper {
    if (!self.present) {
        RootVCPresenter * present = [RootVCPresenter new];
        RootVCInteractor * interactor = [RootVCInteractor new];
        
        self.present = present;
        [present setMyInteractor:interactor];
        [present setMyView:self];
        
        [self addViews];
        [self startEvent];
    }
}

- (void)addViews {
    [self addTagTVs];
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

- (NSScrollView *)addTagTVs {
    CGFloat width = 100;
    // create a table view and a scroll view
    NSScrollView * tableContainer  = [[NSScrollView alloc] initWithFrame:CGRectZero];
    NSTableView * tableView        = [[NSTableView alloc] initWithFrame:tableContainer.bounds];
    tableView.tag = 0;
    
    NSArray * folderEntityArray = [ColumnTool share].columnTagArray;
    for (int i=0; i<folderEntityArray.count; i++) {
        ColumnEntity * entity = folderEntityArray[i];
        NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:entity.columnID];
        column.width         = entity.width;
        column.minWidth      = entity.miniWidth;
        column.title         = entity.title;
        column.headerToolTip = entity.tip;
        
        [tableView addTableColumn:column];
        
        width = entity.width;
    }
    
    tableView.delegate                   = self.present;
    tableView.dataSource                 = self.present;
    tableContainer.documentView          = tableView;
    tableContainer.hasVerticalScroller   = YES;
    tableContainer.hasHorizontalScroller = YES;
    
    [self.view addSubview:tableContainer];
    [tableView reloadData];
    
    [tableContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    return tableContainer;
}

@end
