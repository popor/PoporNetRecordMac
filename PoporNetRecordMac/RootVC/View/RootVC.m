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
@synthesize wifiTF;

@synthesize funFirstBT;

@synthesize recordApiL;
@synthesize editRecordApiBT;

@synthesize LeftIfrmeL;
@synthesize editLeftIfrmeBT;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
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
    [self addRecordApiL];
    [self addRecordLeftIframe];
    [self addFunBT];
    [self addTagTVs];
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    [self.present startEvent];
    
}

// MARK: 简化ui
- (void)addTFBT {
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
        NSButton * button = [NSButton buttonWithTitle:@"端口" target:self.present action:@selector(editPortAction)];
        [self.view addSubview:button];
        
        button;
    });
    
    // -------------------------------------------------------------------------
    [self.wifiTF setContentHuggingPriority:NSLayoutPriorityRequired forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.wifiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(40);
        
        make.height.mas_equalTo(22);
    }];
    
    [self.ipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.wifiTF.mas_right).mas_offset(10);
        make.width.mas_greaterThanOrEqualTo(100);
        //make.width.mas_equalTo(200);
        
        make.height.mas_equalTo(self.wifiTF);
    }];
    [self.editPortBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.ipTF.mas_right).mas_offset(10);
        make.right.mas_equalTo(-16);
        
        make.width.mas_equalTo(60);
        
        make.height.mas_equalTo(self.wifiTF);
    }];
}

- (void)addRecordApiL {
    self.recordApiL = ({
        JHLabel * l = [JHLabel new];
        l.backgroundColor    = [NSColor clearColor];
        l.font               = [NSFont systemFontOfSize:13];
        l.textColor          = [NSColor textColor];
        
        [self.view addSubview:l];
        l;
    });
    
    self.editRecordApiBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"接口" target:self.present action:@selector(editApiAction)];
        [self.view addSubview:button];
        
        button;
    });
    
    [self.recordApiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiTF.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.wifiTF);
        make.height.mas_equalTo(self.wifiTF);
        make.right.mas_lessThanOrEqualTo(self.editRecordApiBT.mas_left).mas_offset(-10);
    }];
    
    [self.editRecordApiBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordApiL);
        make.left.mas_equalTo(self.editPortBT);
        make.height.mas_equalTo(self.editPortBT);
        make.right.mas_equalTo(self.editPortBT);
    }];
}

- (void)addRecordLeftIframe {
    self.LeftIfrmeL = ({
        JHLabel * l = [JHLabel new];
        l.backgroundColor    = [NSColor clearColor];
        l.font               = [NSFont systemFontOfSize:13];
        l.textColor          = [NSColor textColor];
        
        [self.view addSubview:l];
        l;
    });
    
    self.editLeftIfrmeBT = ({
        NSButton * button = [NSButton buttonWithTitle:@"宽度" target:self.present action:@selector(editLeftIfrmeAction)];
        [self.view addSubview:button];
        
        button;
    });
    
    [self.LeftIfrmeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordApiL.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.wifiTF);
        make.height.mas_equalTo(self.wifiTF);
        
    }];
    
    [self.editLeftIfrmeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.LeftIfrmeL);
        make.left.mas_equalTo(self.editPortBT);
        make.height.mas_equalTo(self.editPortBT);
        make.right.mas_equalTo(self.editPortBT);
    }];
}

- (void)addFunBT {
    
    int btH = 25;
    NSArray * titleArray = @[FunRecord_Fresh, FunAdmin, FunRecord_RequestAdd, FunRecord_TestAdd];
    NSButton * bt;
    for (int i = 0; i<titleArray.count; i++) {
        
        NSButton * oneBT = ({
            NSButton * button = [NSButton buttonWithTitle:titleArray[i] target:self action:@selector(buttonAction:)];
            [self.view addSubview:button];
            
            button;
        });
        if (!bt) {
            bt = oneBT;
            [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.LeftIfrmeL.mas_bottom).mas_offset(10);
                make.left.mas_equalTo(16);
                make.width.mas_greaterThanOrEqualTo(60);
                
                make.height.mas_equalTo(btH);
            }];
            self.funFirstBT = bt;
        } else {
            [oneBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(bt);
                make.left.mas_equalTo(bt.mas_right).mas_offset(10);
                make.width.mas_greaterThanOrEqualTo(60);
                
                make.height.mas_equalTo(btH);
            }];
            
            bt = oneBT;
        }
    }
    
}

- (void)buttonAction:(NSButton *)button {
    
    if ([button.title isEqualToString:FunRecord_Fresh]) {
        [self.present freshAction];
    }
    else if ([button.title isEqualToString:FunRecord_RequestAdd]) {
        [self.present createRequestAction];
    }
    else if ([button.title isEqualToString:FunRecord_TestAdd]) {
        [self.present createTestAction];
    }
    
    else if ([button.title isEqualToString:FunRecord_View]) {
        [self.present webview_recordAction];
    }
    
    else if ([button.title isEqualToString:FunAdmin]) {
        [self.present webview_adminAction];
    }
    
    else if ([button.title isEqualToString:FunTest_Request]) {
           [self.present webview_testRequstAction];
    }
}

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
        make.top.mas_equalTo(self.funFirstBT.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.infoTV = tableView;
    
    return tableContainer;
}



@end

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
