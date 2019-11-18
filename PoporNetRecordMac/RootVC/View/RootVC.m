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

@synthesize editPortBT;
@synthesize ipTF;
@synthesize portTF;
@synthesize wifiTF;

@synthesize freshBT;
@synthesize urlBT;
@synthesize startBT;
@synthesize openWebBT;

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
    
    [self addTFBT];
    [self addTagTVs];
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// MARK: 简化ui
- (void)addTFBT {
    int btH = 30;// 不起作用
    self.wifiTF = ({
        EditableTextField * tf = [[EditableTextField alloc] init];
        tf.editable = NO;
        tf.selectable = YES;
        [self.view addSubview:tf];
        
        tf;
    });
    
    self.ipTF = ({
        EditableTextField * tf = [[EditableTextField alloc] init];
        tf.editable = NO;
        tf.selectable = YES;
        [self.view addSubview:tf];
        
        tf;
    });
    
    self.editPortBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"修改" target:self.present action:@selector(editPortAction)];
        [self.view addSubview:button];
        
        button;
    });
    
    self.freshBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"刷新" target:self.present action:@selector(freshAction)];
        [self.view addSubview:button];
        
        button;
    });
    
    self.urlBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"复制URL" target:self.present action:@selector(copyUrlAction)];
        [self.view addSubview:button];
        
        button;
    });
    self.startBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"已开始" target:self.present action:@selector(satrtAction)];
        [self.view addSubview:button];
        
        button;
    });
    self.openWebBT = ({
           NSButton * button = [NSButton buttonWithTitle:@"查看" target:self.present action:@selector(webviewAction)];
           [self.view addSubview:button];
           
           button;
       });
    // -------------------------------------------------------------------------
    [self.wifiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(22);
    }];
    
    [self.ipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.wifiTF.mas_right).mas_offset(15);
        make.width.mas_greaterThanOrEqualTo(200);
        //make.width.mas_equalTo(200);
        
        make.height.mas_equalTo(24);
    }];
    
    [self.editPortBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.ipTF.mas_right).mas_offset(20);
        make.right.mas_equalTo(-16);
        
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(btH);
    }];
    
    // ----------------
    [self.freshBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiTF.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(btH);
    }];
    [self.urlBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.freshBT);
        make.left.mas_equalTo(self.freshBT.mas_right).mas_offset(20);
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(btH);
    }];
    [self.startBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.freshBT);
        make.left.mas_equalTo(self.urlBT.mas_right).mas_offset(20);
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(btH);
    }];
    [self.openWebBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.freshBT);
        make.left.mas_equalTo(self.startBT.mas_right).mas_offset(20);
        make.width.mas_greaterThanOrEqualTo(80);
        
        make.height.mas_equalTo(btH);
    }];
    
}

//- (void)wifi1 {
//    CWInterface *wif = [[CWWiFiClient  sharedWiFiClient] interface];
//    //当前wifi名称
//    NSLog(@"BSD if name: %@", wif.interfaceName);
//    //ssid
//    NSLog(@"SSID: %@", wif.ssid);
//    self.wifiTF.stringValue = [NSString stringWithFormat:@"WIFI: %@", wif.ssid];
//
//
//    //wifi列表  当前可以连接的WIFI
//    for (CWNetwork *newwork in [wif cachedScanResults]) {
//        //遍历WIFI列表
//        if ([newwork.ssid isEqualToString:@"连接的wifi"]) { //选取一个
//            NSError *error = nil;
//            BOOL is =  [wif associateToNetwork:newwork password:@"输入连接的密码" error:&error];
//            if (is && !error) {
//                NSLog(@"连接成功");
//            }  else {
//                NSLog(@"连接失败  %@",error);
//            }
//            break;
//        }
//    }
//}

// MARK: tv
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
        make.top.mas_equalTo(self.freshBT.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.infoTV = tableView;
    
    return tableContainer;
}



@end
