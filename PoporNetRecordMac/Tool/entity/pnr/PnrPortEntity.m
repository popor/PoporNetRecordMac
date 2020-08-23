//
//  PnrPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrPortEntity.h"

#import "SqliteCofing.h"

//static NSString * PoporNetRecord_port_get  = @"PoporNetRecord_port_get";

@implementation PnrPortEntity

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self initPort];
    }
    return self;
}

- (void)initPort {
    int portGet  = [self getPort];
    if (portGet != 0) {
        self.portGetInt  = portGet;
    }else{
        self.portGetInt  = PnrPortGet;
        NSString * text  = [NSString stringWithFormat:@"%i", PnrPortGet];
        [SqliteCofing addPort:text];
        //[self savePort:text];
    }
    
    NSString * api = [self getApi];
    if (api) {
        self.api = api;
    } else {
        self.api = @"api";
        [SqliteCofing addApi:self.api];
        //[self saveApi:self.api];
    }
}

#pragma mark - plist
- (void)savePort:(NSString *)port {
    [SqliteCofing updatePort:port];
    self.portGetInt = port.intValue;
}

- (int)getPort {
    NSString * info = [SqliteCofing getPort];
    return info.intValue;
}

- (void)saveApi:(NSString *)api {
    [SqliteCofing updateApi:api];
    self.api = api;
}

- (NSString *)getApi {
    NSString * info = [SqliteCofing getApi];
    return info;
}

@end
