//
//  PnrWebServer.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>
#import "PnrPortEntity.h"
#import "PnrEntity.h"
#import "PnrPrefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface PnrWebServer : NSObject

+ (instancetype)share;

@property (nonatomic, weak  ) PnrPortEntity * portEntity;
@property (nonatomic, weak  ) NSMutableArray * infoArray; // PoporNetRecord.infoArray

#pragma mark - server
@property (nonatomic, strong, nullable) GCDWebServer * webServer;

@property (nonatomic, copy  ) PnrBlockResubmit resubmitBlock;
@property (nonatomic, strong) NSDictionary * resubmitExtraDic;

- (void)startListServer:(NSMutableString * _Nullable)listBodyH5;
- (void)stopServer;

- (void)updatePort;

- (void)clearListWeb;

@end

NS_ASSUME_NONNULL_END
