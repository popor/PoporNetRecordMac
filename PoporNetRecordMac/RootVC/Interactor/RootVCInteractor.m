//
//  RootVCInteractor.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVCInteractor.h"

@interface RootVCInteractor ()

@end

@implementation RootVCInteractor

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - VCDataSource

// MARK: 设置状态功能函数
//- (void)setStatusImage {
//    //获取系统单例NSStatusBar对象
//    self.statusItem = ({
//        NSStatusBar * statusBar = [NSStatusBar systemStatusBar];
//        NSStatusItem * item = [statusBar statusItemWithLength:NSVariableStatusItemLength];
//        //NSStatusItem *statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
//        item.button.image = [NSImage imageNamed:@"icon_16x16"];
//
//        [item.button setTarget:self];
//        [item.button setAction:@selector(statusItemAction:)];
//
//        item.menu = [NSMenu new];
//        {
//            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"显示" action:@selector(menuShow) keyEquivalent:@""];
//
//            [item.menu addItem:mi];
//        }
//        {
//            NSMenuItem * mi = [NSMenuItem separatorItem];
//            [item.menu addItem:mi];
//        }
//        {
//            NSMenuItem * mi = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(menuExit) keyEquivalent:@""];
//            mi.enabled = YES;
//
//            [item.menu addItem:mi];
//        }
//
//        item;
//    });
//
//}
//
//- (void)statusItemAction:(NSStatusItem *)item {NSLog(@"%s", __func__); }
//- (void)menuExit { }
//- (void)menuShow { }

@end
