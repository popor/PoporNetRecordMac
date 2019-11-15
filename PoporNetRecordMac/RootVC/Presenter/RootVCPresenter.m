//
//  RootVCPresenter.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.

#import "RootVCPresenter.h"
#import "RootVCInteractor.h"

#import "EditableTextField.h"
#import "PnrPortEntity.h"

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
    [self freshAction];
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

- (void)copyUrlAction {
    
}

- (void)satrtAction {
    
}

- (void)freshAction {
    [self freshWifiName];
    [self startServer];
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

#pragma mark - Interactor_EventHandler

@end
