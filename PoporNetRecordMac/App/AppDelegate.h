//
//  AppDelegate.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak  ) NSWindow * window;
@property (nonatomic, weak  ) IBOutlet NSMenuItem * keepAtFrontMenuItem;

- (IBAction)openDbFolderBTAction:(id)sender;

- (IBAction)resetWindowFrame:(id)sender;

/**
item的快捷键不能和系统自带的冲突,不然无法触发.
*/
- (IBAction)keepAtFrontAction:(NSMenuItem *)item;

@end

