//
//  PnrWebPortEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

static int PnrPortGet = 9000;

@interface PnrPortEntity : NSObject

@property (nonatomic        ) int portGetInt;
@property (nonatomic, copy  ) NSString * api;

+ (instancetype)share;

#pragma mark - plist
- (void)savePort:(NSString *)port;
- (int)getPort;

- (void)saveApi:(NSString *)api;

- (NSString *)getApi;

@end

NS_ASSUME_NONNULL_END
