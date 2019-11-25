//
//  NSButton+pDrawRect.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/25.
//  Copyright © 2019 popor. All rights reserved.
//

#import <AppKit/AppKit.h>
//#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockPDrawRect) (NSButton * button);

@interface NSButton (pDrawRect)

@property (nonatomic, copy  ) BlockPDrawRect blockPDrawRect;

@end

NS_ASSUME_NONNULL_END
