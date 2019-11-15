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

- (void)startServer {
    [PoporNetRecord share];
    
}

@end
