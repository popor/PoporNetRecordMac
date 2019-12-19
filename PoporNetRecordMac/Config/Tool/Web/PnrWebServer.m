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
#import "PnrRequestTestEntity.h"

#define H5String(string) [GCDWebServerDataResponse responseWithHTML:string]

@interface PnrWebServer ()

@property (nonatomic, weak  ) PnrConfig * config;

@property (nonatomic, strong) NSString * h5Root;

@end

@implementation PnrWebServer

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrWebServer * instance;
    dispatch_once(&once, ^{
        instance = [PnrWebServer new];
        instance.h5Root = [PnrWebBody rootBody];
        instance.config = [PnrConfig share];
        
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
    }
    
    [self startWebServer];
}

- (void)startWebServer {
    
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        @weakify(self);
        // MARK: get 方法
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            @strongify(self);
            PoporNetRecord * pnr  = [PoporNetRecord share];
            
            NSString * path      = request.URL.path;
            NSDictionary * query = request.query;
            
            if (path.length >= 1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                
                if (pathArray.count == 1){
                    // MARK: 首页
                    if ([path isEqualToString:@""] || [path isEqualToString:PnrGet_ViewRoot]){
                        completionBlock(H5String(self.h5Root));
                    }
                    // MARK: 列表
                    else if ([path isEqualToString:PnrGet_ViewList]){
                        NSString * deviceName = query[PnrKey_DeviceName];
                        PnrDeviceEntity * deviceEntity = pnr.deviceNameDic[deviceName];
                        
                        if (deviceEntity) {
                            completionBlock(H5String([PnrWebBody listH5:deviceEntity.listWebH5]));
                        } else {
                            completionBlock(H5String([PnrWebBody listH5:pnr.listWebH5]));
                        }
                        
                    }
                    // MARK: 详情 重新提交
                    else if ([path isEqualToString:PnrGet_ViewDetail] || [path isEqualToString:PnrGet_ViewResubmit]){
                        NSString * deviceName = query[PnrKey_DeviceName];
                        NSString * indexStr   = query[PnrKey_index];
                        
                        if (indexStr) {
                            NSInteger index                = indexStr.integerValue;
                            PnrDeviceEntity * deviceEntity = pnr.deviceNameDic[deviceName];
                            PnrEntity * entity;
                            if (deviceEntity) {
                                entity = deviceEntity.array[index];
                            } else {
                                entity = self.infoArray[index];
                            }
                            if (!entity.h5Detail) {
                                [self startServerUnitEntity:entity index:index];
                            }
                            
                            if ([path isEqualToString:PnrGet_ViewDetail]) {
                                if (entity.h5Detail) {
                                    completionBlock(H5String(entity.h5Detail));
                                } else {
                                    completionBlock(H5String(ErrorEntity));
                                }
                            } else {
                                if (entity.h5Resubmit) {
                                    completionBlock(H5String(entity.h5Resubmit));
                                } else {
                                    completionBlock(H5String(ErrorEntity));
                                }
                            }
                                
                        } else {
                            completionBlock(H5String(ErrorEntity));
                        }
                        
                    }
                    // MARK: icon
                    else if ([path isEqualToString:@"favicon.ico"]){
                        if (self.config.webIconData) {
                            completionBlock([GCDWebServerDataResponse responseWithData:self.config.webIconData contentType:@"image/x-icon"]);
                        }
                    }
                    // MARK: 模拟测试数据
                    else if ([[path lowercaseString] hasPrefix:PnrTestHead]) {
                        [self requestTestUrl:path complete:completionBlock];
                    }
                    // other
                    else{
                        completionBlock(H5String(ErrorUrl));
                    }
                
                }
            }
            else {
                completionBlock(H5String(ErrorUrl));
            }
        }];
        
        // MARK: post 方法
        [self.webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            @strongify(self);
            
            NSString * path = request.URL.path;
            if (path.length>=1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 1) {
                    [self analysisPostPath:path request:request complete:completionBlock];
                }
                
                else {
                    completionBlock(H5String(ErrorUrl));
                }
            }
            else{
                completionBlock(H5String(ErrorUrl));
            }
        }];
        
        PnrPortEntity * port = [PnrPortEntity share];
        [server startWithPort:port.portGetInt bonjourName:nil];
    }
}

- (void)updatePort {
    [self.webServer stop];
    self.webServer = nil;
    [self startWebServer];
}

- (void)analysisPostPath:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
    NSDictionary * dic = formRequest.arguments;
    
    if ([path isEqualToString:PnrPost_Add]) {
        [PoporNetRecord addDic:formRequest.jsonObject];
        complete([GCDWebServerDataResponse responseWithText:@"{\"status\":1}"]);
    }
    
    else if ([path isEqualToString:PnrPost_JsonXml]) {
        NSString * str = dic[PnrKey_Conent];
        if (str) {
            complete(H5String(dic[PnrKey_Conent]));
        }else{
            complete(H5String(ErrorEmpty));
        }
    }
    else if([path isEqualToString:PnrPost_Resubmit]){
        if (self.resubmitBlock) {
            PnrBlockFeedback blockFeedback ;
            blockFeedback = ^(NSString * feedback) {
                if (!feedback) {
                    feedback = @"NULL";
                }
                complete(H5String(feedback));
            };
            GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
            self.resubmitBlock(formRequest.arguments, blockFeedback);
        }else{
            complete(H5String(ErrorResubmit));
        }
    }
    else if([path isEqualToString:PnrPost_Clear]){
        PoporNetRecord * pnr  = [PoporNetRecord share];
        for (PnrDeviceEntity * deviceEntity in pnr.deviceNameArray) {
            [deviceEntity.listWebH5 setString:@""];
            [deviceEntity.array removeAllObjects];
        }
        [self.infoArray removeAllObjects];
        [pnr.listWebH5 setString:@""];
        
        complete(H5String(@"clear finish"));
    }
    
    // MARK: 模拟测试数据
    else if ([[path lowercaseString] hasPrefix:PnrTestHead]) {
        [self requestTestUrl:path complete:complete];
    }
    
    // // 一般不会发生
    // else if ([path isEqualToString:@"favicon.ico"]){
    //     if (self.config.webIconData) {
    //         complete([GCDWebServerDataResponse responseWithData:self.config.webIconData contentType:@"image/x-icon"]);
    //     }
    // }
    
    else{
        complete(H5String(ErrorUrl));
    }
}

- (void)requestTestUrl:(NSString *)url complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    PnrRequestTestEntity * entity = [PnrRequestTestEntity findUrl:url];
    complete(H5String(entity.response));
}


#pragma mark - server 某个单独请求
- (void)startServerUnitEntity:(PnrEntity *)pnrEntity index:(NSInteger)index {
    [PnrWebBody deatilEntity:pnrEntity index:index extra:self.resubmitExtraDic finish:^(NSString * _Nonnull detail, NSString * _Nonnull resubmit) {
        pnrEntity.h5Detail   = detail;
        pnrEntity.h5Resubmit = resubmit;
    }];
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

@end
