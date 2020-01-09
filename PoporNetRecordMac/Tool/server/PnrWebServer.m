//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebServer.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrConfig.h"

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
//#import <GCDWebServer/GCDWebServerPrivate.h>
#import <GCDWebServer/GCDWebServerDataRequest.h>
#import <GCDWebServer/GCDWebServerURLEncodedFormRequest.h>

#import <PoporQRCodeMacos/ZwcQRCode.h>

#import "PoporNetRecord.h"

#import "PnrWebBodyRecord.h"
#import "PnrWebBodyTest.h"
#import "PnrRequestTestEntity.h"
#import "PnrWebBodyAdmin.h"
#import "PnrWebBodyYcUrl.h"

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
        instance.h5Root = [PnrWebBodyRecord rootBody];
        instance.config = [PnrConfig share];
        instance.qrUrlImageDataDic = [NSMutableDictionary new];
        // GCDWebServer 这个配置要求在主线程中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [GCDWebServer setLogLevel:2];
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

#pragma mark - start

- (void)startServer {
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        @weakify(self);
        // MARK: get 方法
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            @strongify(self);
            [self analysisGetRequest:request complete:completionBlock];
        }];
        
        // MARK: post 方法
        [self.webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            @strongify(self);
            [self analysisPostRequest:request complete:completionBlock];
        }];
        
        [self startServerPort];
    }
}

- (void)startServerPort {
    PnrPortEntity * port = [PnrPortEntity share];
    if ([self.webServer startWithPort:port.portGetInt bonjourName:nil]) {
        if (self.serverLaunchFinish) {
            self.serverLaunchFinish(YES);
        }
    } else {
        if (self.serverLaunchFinish) {
            self.serverLaunchFinish(NO);
        }
        
        // 如果生成server失败,则更改port参数,重新生成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            port.portGetInt ++;
            // 异常之后只更改本次port,不保存
            //[port savePort_get:[NSString stringWithFormat:@"%i", port.portGetInt]];
            [self updateServerPort];
        });
    }
}

- (void)updateServerPort {
    [self stopServer];
    
    PnrPortEntity * port = [PnrPortEntity share];
    
    if ([self.webServer startWithPort:port.portGetInt bonjourName:nil]) {
        if (self.serverLaunchFinish) {
            self.serverLaunchFinish(YES);
        }
    } else {
        if (self.serverLaunchFinish) {
            self.serverLaunchFinish(NO);
        }
        
        // 如果生成server失败,则更改port参数,重新生成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            port.portGetInt ++;
            // 异常之后只更改本次port,不保存
            //[port savePort_get:[NSString stringWithFormat:@"%i", port.portGetInt]];
            [self updateServerPort];
        });
    }
}

- (void)analysisGetRequest:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)completionBlock {
    
    PoporNetRecord * pnr  = [PoporNetRecord share];
    
    NSString * path      = request.URL.path;
    NSDictionary * query = request.query;
    
    if (path.length >= 1) {
        path = [path substringFromIndex:1];
        NSArray * pathArray = [path componentsSeparatedByString:@"/"];
        NSLog(@"get : %@", path);
        if (pathArray.count == 1){
            // MARK: admin
            if ([path isEqualToString:@""] || [[path lowercaseString] hasPrefix:PnrGet_admin]){
                completionBlock(H5String([PnrWebBodyAdmin html]));
            }
            // MARK: record
            else if ([path isEqualToString:PnrGet_recordRoot]){
                completionBlock(H5String(self.h5Root));
            }
            // MARK: 列表
            else if ([path isEqualToString:PnrGet_recordList]){
                NSString * deviceName = query[PnrKey_DeviceName];
                PnrDeviceEntity * deviceEntity = pnr.deviceNameDic[deviceName];
                
                if (deviceEntity) {
                    completionBlock(H5String([PnrWebBodyRecord listH5:deviceEntity.listWebH5]));
                } else {
                    completionBlock(H5String([PnrWebBodyRecord listH5:pnr.listWebH5]));
                }
                
            }
            // MARK: 详情 重新提交
            else if ([path isEqualToString:PnrGet_recordDetail] || [path isEqualToString:PnrGet_recordResubmit]){
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
                    
                    if ([path isEqualToString:PnrGet_recordDetail]) {
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
            // MARK: 二维码图片
            else if ([path isEqualToString:PnrGet_QrUrlSelf]) {
                NSString * text  = [NSString stringWithFormat:@"%@", request.URL.absoluteURL];
                text = [text substringToIndex:text.length - PnrGet_QrUrlSelf.length];
                NSData * data = self.qrUrlImageDataDic[text];
                
                if (!data) {
                    NSImage  * image = [ZwcQRCode qrImageWithContent:text size:200];
                    
                    NSData *imageData = [image TIFFRepresentation];
                    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];

                    [imageRep setSize:[image size]];
                    
                    // png
                    data = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
                    
                    [self.qrUrlImageDataDic setObject:data forKey:text];
                    
                    // jpg
                    // NSDictionary *imageProps = nil;
                    // NSNumber *quality = [NSNumber numberWithFloat:.85];
                    // imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
                    // NSData * imageData1 = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
                    // ————————————————
                    // 版权声明：本文为CSDN博主「brhave」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
                    // 原文链接：https://blog.csdn.net/bravegogo/article/details/51537140
                }
                
                completionBlock([GCDWebServerDataResponse responseWithData:data contentType:@"image/png"]);
            }
            
            // MARK: 模拟测试_编辑页面
            else if ([path isEqualToString:PnrGet_TestRoot]) {
                completionBlock(H5String([PnrWebBodyTest requestTestBody:query]));
            }
            // MARK: 模拟测试数据
            else if ([[path lowercaseString] hasPrefix:PnrGet_TestHeadAdd]) {
                [self requestTestUrl:path complete:completionBlock];
            }
            
            // MARK: YcUrl部分
            else if ([path isEqualToString:PnrGet_YcUrl]) {
                completionBlock(H5String([PnrWebBodyYcUrl ycUrlBody]));
            }
            else if ([path isEqualToString:Pnrget_YcUrlPsd]) {
                completionBlock(H5String([PnrWebBodyYcUrl getPsd]));
            }
            
            // MARK: other
            else{
                completionBlock(H5String(ErrorUrl));
            }
        
        }
    }
    else {
        completionBlock(H5String(ErrorUrl));
    }
}

- (void)analysisPostRequest:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    NSString * path = request.URL.path;
    if (path.length<1) {
        complete(H5String(ErrorUrl));
        return;
    } else {
        path = [path substringFromIndex:1];
    }
    GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
    
    if ([path isEqualToString:PnrPost_recordAdd]) {
        [PoporNetRecord addDic:formRequest.jsonObject];
        complete([GCDWebServerDataResponse responseWithText:@"{\"status\":1}"]);
    }
    
    else if ([path isEqualToString:PnrPost_commonJsonXml]) {
        NSDictionary * dic = formRequest.arguments;
        NSString * str = dic[PnrKey_Conent];
        if (str) {
            complete(H5String(dic[PnrKey_Conent]));
        }else{
            complete(H5String(ErrorEmpty));
        }
    }
    
    else if ([path isEqualToString:PnrPost_TestEdit]) {
        GCDWebServerDataRequest * dataReq = (GCDWebServerDataRequest *)request;
        //NSString * str = [[NSString alloc] initWithData:dataReq.data encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:dataReq.data options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"测试: %@", dic);
        
        NSString * content = dic[PnrKey_Conent];
        NSString * index   = dic[PnrKey_TestIndex];
        NSString * type    = dic[PnrKey_TestType];
        
        BOOL success = NO;
        if (content && index && type) {
            if ([type isEqualToString:PnrKey_TestUrl]) {
                success = [PnrRequestTestEntity updateIndex:[index integerValue] url:content];
            } else if ([type isEqualToString:PnrKey_TestResponse]) {
                success = [PnrRequestTestEntity updateIndex:[index integerValue] response:content];
            } 
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                complete(H5String(PnrKey_success));
            } else {
                complete(H5String(PnrKey_fail));
            }
        });
    }
    
    else if ([path isEqualToString:PnrPost_TestDelete]) {
        GCDWebServerDataRequest * dataReq = (GCDWebServerDataRequest *)request;
        //NSString * str = [[NSString alloc] initWithData:dataReq.data encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:dataReq.data options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"测试: %@", dic);
        
        NSString * index = dic[PnrKey_TestIndex];
        
        BOOL success = NO;
        if ( index ) {
            success = [PnrRequestTestEntity deleteIndex:index];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                complete(H5String(PnrKey_success));
            } else {
                complete(H5String(PnrKey_fail));
            }
        });
    }
    
    else if([path isEqualToString:PnrPost_recordResubmit]){
        if (self.resubmitBlock) {
            PnrBlockFeedback blockFeedback ;
            blockFeedback = ^(NSString * feedback) {
                if (!feedback) {
                    feedback = @"NULL";
                }
                complete(H5String(feedback));
            };
            self.resubmitBlock(formRequest.arguments, blockFeedback);
        }else{
            complete(H5String(ErrorResubmit));
        }
    }
    else if([path isEqualToString:PnrPost_recordClear]){
        PoporNetRecord * pnr  = [PoporNetRecord share];
        for (PnrDeviceEntity * deviceEntity in pnr.deviceNameArray) {
            [deviceEntity.listWebH5 setString:@""];
            [deviceEntity.array removeAllObjects];
        }
        [self.infoArray removeAllObjects];
        [pnr.listWebH5 setString:@""];
        
        complete(H5String(@"clear finish"));
    }
    
    // MARK: YcUrl部分
    else if ([path hasPrefix:PnrPost_YcUrlPsdEdit]) {
        complete(H5String([PnrWebBodyYcUrl ycUrlBody]));
    }
    else if ([path hasPrefix:PnrPost_YcUrlDecrypt]) {
        complete(H5String([PnrWebBodyYcUrl ycUrlBody]));
    }
    
    // MARK: 模拟测试数据
    else if ([[path lowercaseString] hasPrefix:PnrGet_TestHeadAdd]) {
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
    [PnrWebBodyRecord deatilEntity:pnrEntity index:index extra:self.resubmitExtraDic finish:^(NSString * _Nonnull detail, NSString * _Nonnull resubmit) {
        pnrEntity.h5Detail   = detail;
        pnrEntity.h5Resubmit = resubmit;
    }];
}

- (void)stopServer {
    if ([self.webServer isRunning]) {
        [self.webServer stop];
    }
}

@end
