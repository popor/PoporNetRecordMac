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

@property (nonatomic, strong) NSMutableString * listWebH5;

@end

@implementation PoporNetRecord

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecord * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.infoArray = [NSMutableArray new];
        instance.listWebH5 = [NSMutableString new];
        instance.config    = [PnrConfig share];
        
        // 相关联的关联数组
        instance.webServer = [PnrWebServer share];
        [PnrWebServer share].infoArray = instance.infoArray;
        [[PnrWebServer share] startListServer:nil];
    });
    return instance;
}

+ (void)addRecordID:(NSString *)recordID url:(NSString *)urlString method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue
{
    [self addRecordID:recordID url:urlString title:@"--" method:method head:headValue parameter:parameterValue response:responseValue];
}

+ (void)addRecordID:(NSString *)recordID url:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue
{
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.config.isRecord) {
        PnrEntity * entity = [PnrEntity new];
        entity.recordID       = recordID;
        entity.title          = title;
        entity.url            = urlString;
        entity.method         = method;
        entity.headValue      = headValue;
        entity.parameterValue = parameterValue;
        entity.responseValue  = responseValue;
        entity.time           = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];

        if (urlString.length>0) {
            NSURL * url = [NSURL URLWithString:urlString];
            if (url.baseURL) {
                entity.domain = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
                
                if (entity.domain.length+1 < urlString.length) {
                    entity.path = [urlString substringFromIndex:entity.domain.length+1];
                    NSString * query = url.query;
                    if (query.length > 0) {
                        entity.path = [entity.path substringToIndex:entity.path.length-1-query.length];
                    }
                }
            }else{
                entity.domain = urlString;
                entity.path   = @"";
            }
        }
        if (pnr.infoArray.count == 0) {
            // 当执行了数组清空之后, h5代码清零一次.
            [pnr.listWebH5 setString:@""];
        }
        [pnr.infoArray addObject:entity];
        
        if (pnr.config.isShowListWeb) {
            [entity createListWebH5:pnr.infoArray.count - 1];
            [pnr.listWebH5 insertString:entity.listWebH5 atIndex:0];
            [[PnrWebServer share] startListServer:pnr.listWebH5];
        }else{
            [[PnrWebServer share] stopServer];
        }
        
        // 假如在打开界面的时候收到请求,那么刷新数据
        if (pnr.config.freshBlock) {
            pnr.config.freshBlock();
        }
    }
}

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic {
    [PnrWebServer share].resubmitBlock = block;
    [PnrWebServer share].resubmitExtraDic = dic;
}

// Log 部分

+ (void)addRecordID:(NSString *)recordID log:(NSString *)log {
    [self addRecordID:recordID log:log title:@"日志"];
}

+ (void)addRecordID:(NSString *)recordID log:(NSString *)log title:(NSString *)title {
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.config.isRecord) {
        PnrEntity * entity = [PnrEntity new];
        entity.recordID = recordID;
        entity.log   = log;
        entity.title = title;
        entity.time  = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];
        
        if (pnr.infoArray.count == 0) {
            // 当执行了数组清空之后, h5代码清零一次.
            [pnr.listWebH5 setString:@""];
        }
        [pnr.infoArray addObject:entity];
        
        if (pnr.config.isShowListWeb) {
            [entity createListWebH5:pnr.infoArray.count - 1];
            [pnr.listWebH5 insertString:entity.listWebH5 atIndex:0];
            [[PnrWebServer share] startListServer:pnr.listWebH5];
        }else{
            [[PnrWebServer share] stopServer];
        }
        
        // 假如在打开界面的时候收到请求,那么刷新数据
        if (pnr.config.freshBlock) {
            pnr.config.freshBlock();
        }
    }
}

+ (void)addDic:(NSDictionary *)dic {
    PnrEntity * entity = [[PnrEntity alloc] initWithDictionary:dic error:nil];
    entity.headValue      = dic[@"headValue"];
    entity.parameterValue = dic[@"parameterValue"];
    entity.responseValue  = dic[@"responseValue"];
    
    [self addEntity:entity];
}

+ (void)addEntity:(PnrEntity *)entity {
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.config.isRecord) {
        
        if (pnr.infoArray.count == 0) {
            // 当执行了数组清空之后, h5代码清零一次.
            [pnr.listWebH5 setString:@""];
        }
        [pnr.infoArray addObject:entity];
        
        if (pnr.config.isShowListWeb) {
            [entity createListWebH5:pnr.infoArray.count - 1];
            [pnr.listWebH5 insertString:entity.listWebH5 atIndex:0];
            [[PnrWebServer share] startListServer:pnr.listWebH5];
        }else{
            [[PnrWebServer share] stopServer];
        }
        
        // 假如在打开界面的时候收到请求,那么刷新数据
        if (pnr.config.freshBlock) {
            pnr.config.freshBlock();
        }
    }
}

@end
