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
    int portGet  = [PnrPortEntity getPort_get];
    if (portGet != 0) {
        self.portGetInt  = portGet;
    }else{
        self.portGetInt  = PnrPortGet;
        [PnrPortEntity savePort_get:[NSString stringWithFormat:@"%i", PnrPortGet]];
    }
}

#pragma mark - plist
+ (void)savePort_get:(NSString *)port {
    [SqliteCofing updatePort:port];
}

+ (int)getPort_get {
    NSString * info = [SqliteCofing getPort];
    return info.intValue;
}

@end
