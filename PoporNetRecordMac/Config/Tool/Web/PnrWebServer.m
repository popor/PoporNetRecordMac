//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebServer.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrWebBody.h"
#import "PnrConfig.h"

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerPrivate.h>

#import "PoporNetRecord.h"

@interface PnrWebServer ()

@property (nonatomic, weak  ) PnrConfig * config;

@property (nonatomic        ) NSInteger lastIndex;

@property (nonatomic, strong) NSString * h5Root;
@property (nonatomic, strong) NSString * h5List;
@property (nonatomic, strong) NSString * h5Detail;
@property (nonatomic, strong) NSString * h5Resubmit;

@end

@implementation PnrWebServer

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrWebServer * instance;
    dispatch_once(&once, ^{
        instance = [PnrWebServer new];
        instance.h5List     = [NSMutableString new];
        instance.h5Root     = [PnrWebBody rootBodyIndex:0];
        instance.lastIndex  = -1;
        instance.config     = [PnrConfig share];
        
        // GCDWebServer 这个配置要求在主线程中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [GCDWebServer setLogLevel:kGCDWebServerLoggingLevel_Error];
        });
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.portEntity = [PnrPortEntity share];
    }
    return self;
}

#pragma mark - list server
- (void)startListServer:(NSMutableString * _Nullable)listBodyH5 {
    [self startListServerAsyn:listBodyH5];
}

// 异步执行, GCDWebServer初始化会和主线程冲突.
- (void)startListServerAsyn:(NSMutableString *)listBodyH5 {
    if (!listBodyH5) {
        listBodyH5 = [NSMutableString new];
        //return;
    }
    self.h5List = [PnrWebBody listH5:listBodyH5];
    __weak typeof(self) weakSelf = self;
    
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            //NSLog(@"__get path :'%@'", path);
            if (path.length >= 1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 2) {
                    [weakSelf analysisGetIndex:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                }else if (pathArray.count == 1){
                    if ([path isEqualToString:@""]) {
                        completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5Root]);
                    }else if ([path isEqualToString:PnrPathList]){
                        completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5List]);
                    }else if ([path isEqualToString:@"favicon.ico"]){
                        if (weakSelf.config.webIconData) {
                            completionBlock([GCDWebServerDataResponse responseWithData:weakSelf.config.webIconData contentType:@"image/x-icon"]);
                        }
                    }
                    else{
                        int index = [path intValue];
                        if ([path isEqualToString:[NSString stringWithFormat:@"%i", index]]) {
                            completionBlock([GCDWebServerDataResponse responseWithHTML:[PnrWebBody rootBodyIndex:index]]);                            
                        }else{
                            completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                        }
                    }
                }
            }
            else {
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        [self.webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            //NSLog(@"__post path :'%@'", path);
            if (path.length>=1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 1) {
                    if ([path isEqualToString:UrlPathLog]) {
                        GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
                        NSDictionary * dic = formRequest.jsonObject;
                        [PoporNetRecord addDic:dic];
                        
                        completionBlock([GCDWebServerDataResponse responseWithText:@"{\"status\":1}"]);
                    } else if ([path isEqualToString:UrlPathUrl]) {
                        GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
                        NSDictionary * dic = formRequest.jsonObject;
                        [PoporNetRecord addDic:dic];
                        
                        completionBlock([GCDWebServerDataResponse responseWithText:@"{\"status\":1}"]);
                    } else {
                        [weakSelf analysisPost1Path:path request:request complete:completionBlock];
                    }
                }
                //else if (pathArray.count == 2) {
                //    [weakSelf analysisPost2Index:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                //}
                else {
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                }
            }
            else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        PnrPortEntity * port = [PnrPortEntity share];
        [server startWithPort:port.portGetInt bonjourName:nil];
    }
}

// 分析 get 请求
- (void)analysisGetIndex:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete
{
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    if (entity) {
        if (index != self.lastIndex) {
            self.lastIndex = index;
            [self startServerUnitEntity:entity index:index];
        }
        NSString * str;
        if ([path isEqualToString:PnrPathList]) {
            str = self.h5List;
        }else if ([path isEqualToString:PnrPathDetail]) {
            str = self.h5Detail;
        }else if([path isEqualToString:PnrPathEdit]){
            str = self.h5Resubmit;
        }
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:str]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
        }
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

- (void)analysisPost1Path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
    NSDictionary * dic = formRequest.arguments;
    if ([path isEqualToString:PnrPathJsonXml]) {
        NSString * str = dic[PnrKeyConent];
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:dic[PnrKeyConent]]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorEmpty]);
        }
    }
    else if([path isEqualToString:PnrPathResubmit]){
        if (self.resubmitBlock) {
            PnrBlockFeedback blockFeedback ;
            blockFeedback = ^(NSString * feedback) {
                if (!feedback) {
                    feedback = @"NULL";
                }
                complete([GCDWebServerDataResponse responseWithHTML:feedback]);
            };
            GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
            self.resubmitBlock(formRequest.arguments, blockFeedback);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorResubmit]);
        }
    }
    else if([path isEqualToString:PnrPathClear]){
        [self.infoArray removeAllObjects];
        [self clearListWeb];
        
        complete([GCDWebServerDataResponse responseWithHTML:@"clear finish"]);
    }
    else if ([path isEqualToString:@"favicon.ico"]){
        if (self.config.webIconData) {
            complete([GCDWebServerDataResponse responseWithData:self.config.webIconData contentType:@"image/x-icon"]);
        }
    }
    
    else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
    }
}

#pragma mark - server 某个单独请求
- (void)startServerUnitEntity:(PnrEntity *)pnrEntity index:(NSInteger)index {
    [PnrWebBody deatilEntity:pnrEntity index:index extra:self.resubmitExtraDic finish:^(NSString * _Nonnull detail, NSString * _Nonnull resubmit) {
        self.h5Detail   = detail;
        self.h5Resubmit = resubmit;
    }];
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

- (void)clearListWeb {
    self.lastIndex = -1;
    self.h5List    = [PnrWebBody listH5:@""];
}

@end


// MARK: 分析 post 多层
//- (void)analysisPost2Index:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
//
//    PnrEntity * entity;
//    if (self.infoArray.count > index) {
//        entity = self.infoArray[index];
//    }
//    if (entity) {
//        if (index != self.lastIndex) {
//            self.lastIndex = index;
//            [self startServerUnitEntity:entity index:index];
//        }
//        if([path isEqualToString:PnrPathResubmit]){
//            if (self.resubmitBlock) {
//                PnrBlockFeedback blockFeedback ;
//                blockFeedback = ^(NSString * feedback) {
//                    if (!feedback) {
//                        feedback = @"NULL";
//                    }
//                    complete([GCDWebServerDataResponse responseWithHTML:feedback]);
//                };
//                GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
//                self.resubmitBlock(formRequest.arguments, blockFeedback);
//            }else{
//                complete([GCDWebServerDataResponse responseWithHTML:ErrorResubmit]);
//            }
//        }else{
//            complete([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
//        }
//
//    }else{
//        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
//    }
//}
