//
//  AppDelegate.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import "AppDelegate.h"
#import "SqliteCofing.h"
#import "WindowFrameTool.h"
#import <PoporFMDB/PoporFMDB.h>

#import "PnrRequestTestEntity.h"
#import "PoporAppInfo.h"
#import "PnrValuePrifix.h"

static NSString * keepAtFrontKey = @"keepAtFront";

void UncaughtExceptionHandler(NSException *exception) {
    
    NSString * version = [PoporAppInfo getAppVersion_short];
    NSString * buide   = [PoporAppInfo getAppVersion_build];
    
    NSArray  * arr     = [exception callStackSymbols];
    NSString * reason  = [exception reason];
    NSString * name    = [exception name];
    NSString * content = [arr componentsJoinedByString:@"\r\n"];
    
    NSDictionary * dic =
    @{
        @"appTitle":@"PoporNetRecordMac",
        @"version":version,
        @"buide":buide,
        @"reason":reason,
        @"name":name,
        @"content":content,
    };
    PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
    entity.url      = PnrCN_crashTitle;
    entity.response = dic.toJsonString;
    
    [PnrRequestTestEntity addEntity:entity];
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSButton * bt = [NSButton buttonWithTitle:@"  " target:nil action:nil];
    //        NSString * str = (NSString *)bt;
    //        NSLog(@"str: %li", str.length);
    //    });
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5), dispatch_get_main_queue(), ^{
    //    NSArray * array = @[];
    //    NSButton * bt = (NSButton *)array;
    //    [bt setTitle:@"33"];
    //});
    
    //#ifndef __OPTIMIZE__
    //    NSString * iosInjectionPath = @"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle";
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:iosInjectionPath]) {
    //        [[NSBundle bundleWithPath:iosInjectionPath] load];
    //    }
    //    
    //#else
    //
    //#endif
    
    [SqliteCofing updateTable];
    
    NSWindow * window = [NSApplication sharedApplication].keyWindow;
    window.minSize = CGSizeMake(100, 200);
    
    window.title = @"Record";
    self.window = window;
    
    [self resumeLastFrameOrigin];
    
    WindowFrameTool * tool = [WindowFrameTool share];
    __weak typeof(self) weakSelf = self;
    tool.blockResetWindow = ^(){
        NSScreen * screen = [NSScreen mainScreen];
        int w = MIN(1000, screen.frame.size.width*0.8);
        int h = MIN(600, screen.frame.size.height*0.6);
        w = 500;
        h = 200;
        
        int x = (screen.frame.size.width - w)/2;
        int y = (screen.frame.size.height - h)/2;
        
        CGRect rect = CGRectMake(x, y, w, h);
        
        [SqliteCofing updateWindowFrame:rect];
        [weakSelf.window setFrame:rect display:YES];
    };
    
    [self checkKeepAtFrontStatus];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [SqliteCofing updateWindowFrame:self.window.frame];
}

- (void)resumeLastFrameOrigin {
    NSString * windowFrameString = [SqliteCofing getWindowFrame];
    if (windowFrameString) {
        // 计算合适x.
        CGRect frame      = NSRectFromString(windowFrameString);
        NSPoint point     = frame.origin;
        NSScreen * screen = [NSScreen mainScreen];
        CGFloat x         = MAX(point.x, 150);
        x                 = MIN(x, screen.frame.size.width - 150);
        point             = CGPointMake(x, point.y);
        
        [self.window setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height) display:YES];
        
    }else{
        [SqliteCofing addWindowFrame:self.window.frame];
    }
}

// 当点击了关闭window,再次点击Dock上的icon时候,执行以下代码可以再次显示window.
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    } else{
        [self.window makeKeyAndOrderFront:self];
        return YES;
    }
}

- (IBAction)openDbFolderBTAction:(id)sender {
    [self openPath:[PoporFMDBPath share].DBPath];
}

- (void)openPath:(NSString *)path {
    NSURL * url = [NSURL fileURLWithPath:path];
    NSString * folder = [path substringToIndex:path.length - url.lastPathComponent.length];
    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:folder];
}

- (IBAction)resetWindowFrame:(id)sender {
    WindowFrameTool * tool = [WindowFrameTool share];
    if (tool.blockResetWindow) {
        tool.blockResetWindow();
    }
    if (tool.blockResetTv) {
        tool.blockResetTv();
    }
}

/**
 item的快捷键不能和系统自带的冲突,不然无法触发.
 */
- (IBAction)keepAtFrontAction:(NSMenuItem *)item {
    if (item.state == NSControlStateValueOn) {
        item.state = NSControlStateValueOff;
        [NSApp.windows[0] setLevel:NSNormalWindowLevel];
        [PoporFMDB updatePlistKey:keepAtFrontKey value:@"0"];
    }else{
        item.state = NSControlStateValueOn;
        [NSApp.windows[0] setLevel:NSFloatingWindowLevel];
        [PoporFMDB updatePlistKey:keepAtFrontKey value:@"1"];
    }
}

- (void)checkKeepAtFrontStatus {
    NSString * status = [PoporFMDB getPlistKey:keepAtFrontKey];
    if (!status) {
        [PoporFMDB addPlistKey:keepAtFrontKey value:@"0"];
    } else {
        if ([status isEqualToString:@"1"]) {
            [NSApp.windows[0] setLevel:NSFloatingWindowLevel];
            self.keepAtFrontMenuItem.state = NSControlStateValueOn;
        } else {
            [NSApp.windows[0] setLevel:NSNormalWindowLevel];
            self.keepAtFrontMenuItem.state = NSControlStateValueOff;
        }
    }
}

@end
