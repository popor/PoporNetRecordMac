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

- (IBAction)keepAtFront:(NSMenuItem *)item;

@end

