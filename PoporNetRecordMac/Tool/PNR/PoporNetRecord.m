//
//  PoporNetRecord.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporNetRecord.h"
#import "PnrEntity.h"

#import <PoporFoundation/Fun+pPrefix.h>
#import <PoporFoundation/NSDate+pTool.h>

#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PoporNetRecord ()

@end

@implementation PoporNetRecord

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecord * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.allRequestArray     = [NSMutableArray new];
        instance.deviceNameDic       = [NSMutableDictionary new];
        instance.deviceNameArray     = [NSMutableArray new];
        instance.allRequestListWebH5 = [NSMutableString new];
        instance.config              = [PnrConfig share];
        
        // 相关联的关联数组
        instance.webServer = [PnrWebServer share];
        [PnrWebServer share].weakAllRequestArray = instance.allRequestArray;
        //[[PnrWebServer share] startListServer:nil];
    });
    return instance;
}

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic {
    [PnrWebServer share].resubmitBlock    = block;
    [PnrWebServer share].resubmitExtraDic = dic;
}

+ (void)addDic:(NSDictionary *)dic {
    PnrEntity * entity             = [[PnrEntity alloc] initWithDictionary:dic error:nil];
    if (!entity.deviceName) {
        entity.deviceName = @"未知";
    }
    PoporNetRecord * pnr           = [PoporNetRecord share];
    PnrDeviceEntity * deviceEntity = pnr.deviceNameDic[entity.deviceName];
    
    if (!deviceEntity) {
        deviceEntity = [PnrDeviceEntity new];
        deviceEntity.receive    = YES;
        deviceEntity.deviceName = entity.deviceName;
        
        [pnr.deviceNameArray addObject:deviceEntity];
        [pnr.deviceNameDic setObject:deviceEntity forKey:deviceEntity.deviceName];
        
        if (pnr.blockFreshDeviceName) {
            pnr.blockFreshDeviceName();
        }
    }
    
    if (deviceEntity.receive) {
        
        entity.headValue      = dic[PnrKey_Head];
        entity.parameterValue = dic[PnrKey_Parameter];
        entity.responseValue  = dic[PnrKey_Response];
        
        [self addEntity:entity deviceEntity:deviceEntity];
    }
}

+ (void)addEntity:(PnrEntity *)entity deviceEntity:(PnrDeviceEntity *)deviceEntity {
    PoporNetRecord * pnr = [PoporNetRecord share];
    @synchronized (pnr) {
        if (pnr.config.isRecord) {
            
            if (pnr.allRequestArray.count == 0) {
                // 当执行了数组清空之后, h5代码清零一次.
                [pnr.allRequestListWebH5 setString:@""];
            }
            [pnr.allRequestArray addObject:entity];
            [deviceEntity.requestArray addObject:entity];
            
            if (pnr.config.isShowListWeb) {
                // 100%
                NSMutableString * allListH5 = [PnrEntity createListWebH5:entity index:pnr.allRequestArray.count - 1];
                NSMutableString * oneListH5 = [PnrEntity createListWebH5:entity index:deviceEntity.requestArray.count - 1];
                
                [pnr.allRequestListWebH5 insertString:allListH5 atIndex:0];
                [deviceEntity.listWebH5 insertString:oneListH5 atIndex:0];
            }else{
                // 0%
                [[PnrWebServer share] stopServer];
            }
            
        }
    }
}

@end
