//
//  NSButton+pDrawRect.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/11/25.
//  Copyright © 2019 popor. All rights reserved.
//

#import "NSButton+pDrawRect.h"

#import <objc/runtime.h>

@implementation NSButton (pDrawRect)
@dynamic blockPDrawRect;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [objc_getClass("NSButton") methodSwizzlingWithOriginalSelector:@selector(drawRect:) bySwizzledSelector:@selector(drawRect_pBgColor:)];
    });
}


- (void)drawRect_pBgColor:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.blockPDrawRect) {
        self.blockPDrawRect(self);
    }
}
 
// MARK: get set
- (void)setBlockPDrawRect:(BlockPDrawRect)blockPDrawRect {
    objc_setAssociatedObject(self, @"blockPDrawRect", blockPDrawRect, OBJC_ASSOCIATION_COPY);
}

- (BlockPDrawRect)blockPDrawRect {
    return objc_getAssociatedObject(self, @"blockPDrawRect");
}

@end
