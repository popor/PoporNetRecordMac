//
//  PnrWebBodyAdmin.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrWebBodyAdmin.h"

#import "PnrWebCss.h"
#import "PnrWebJs.h"
#import "PnrValuePrifix.h"
#import "PnrPortEntity.h"

#import <PoporFoundation/NSDictionary+pTool.h>
#import "PoporAppInfo.h"
#import "PoporNetRecord.h"

static NSString * PoporNetRecordReplaceString = @"PoporNetRecordReplaceString";

static NSString * divFunListKey               = @"divFunList";
static NSString * divFunItemKey               = @"item";
static NSString * divFunItem_unitKey          = @"item_unit";

@implementation PnrWebBodyAdmin

+ (NSString *)html {
    
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    static NSMutableString * body;
    
    if (!isInit) {
        isInit = YES;
        NSString * divFunList      = divFunListKey;
        NSString * divFunItem      = divFunItemKey;
        NSString * divFunItem_unit = divFunItem_unitKey;
        // MARK: detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>admin</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            //[h5 appendString:[PnrWebCss cssTextarea1]];
            //[h5 appendString:[PnrWebCss cssButton]];
            //[h5 appendString:[PnrWebCss cssPMarginPadding]];
            
            [h5 appendFormat:@"\n\nbody { background-color:beige; }\n"];
            
            [h5 appendFormat:@"\n\n.%@{ background-color: white; }\n", divFunList];
            
            [h5 appendFormat:@"\n\n.%@ a{\n\
             text-decoration: none;\n\
             text-align:center;\n\
             width:120px;\n\
             }\n", divFunList];
            
            [h5 appendFormat:
             @".%@ .%@{\n\
             height: 40px;\n\
             width: 100px;\n\
             line-height: 40px;\n\
             color: #333333;\n\
             position: relative;\n\
             display: block;\n\
             } \n"
             , divFunList, divFunItem];
            
            [h5 appendFormat:
             @"\n\n.%@ .%@:hover:after{\n\
             content: '';\n\
             display: block;\n\
             position: absolute;\n\
             width: 60px;\n\
             height: 2px;\n\
             bottom: 5px;\n\
             left: 20px;\n\
             background-color: #FD463E;\n\
             } \n"
             , divFunList, divFunItem];
            
            
            [h5 appendFormat:
             @".%@ .%@{\n\
             display: inline-block;\n\
             height: 40px;\n\
             width: 100px;\n\
             text-align: center;\n\
             line-height: 40px;\n\
             color: orange;\n\
             position: relative;\n\
             } \n"
             , divFunList, divFunItem_unit];
            
            [h5 appendFormat:
             @"\n\n.%@ .%@:hover:after{\n\
             content: '';\n\
             display: block;\n\
             position: absolute;\n\
             width: 60px;\n\
             height: 2px;\n\
             bottom: 5px;\n\
             left: 20px;\n\
             background-color: #FD463E;\n\
             } \n"
             , divFunList, divFunItem_unit];
            
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            
            h5_detail_head = h5;
        }
        // MARK: detail 尾
        {
            NSMutableString * h5 = [NSMutableString new];
            // js
            [h5 appendString:@"\n<script> \n"];
            
            [h5 appendString:[PnrWebJs getQuery]];
            
            [h5 appendString:@"\n </script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        
        // MARK: 每次都需要拼接的部分
        body = [NSMutableString new];
        
        // text-align:center;
        // background-color:linen;
        [body appendFormat:@"<div class='%@' style=' width:1000px; height:100%%; margin:0 auto; ' >", divFunList];
        [body appendFormat:@"<p><a href='/%@' class='%@' > 网络请求 </a> </p>", PnrGet_recordRoot, divFunItem];
        
        [body appendString:PoporNetRecordReplaceString];
        
        [body appendFormat:@"<p> <a href='/%@' class='%@' > 请求测试 </a> </p>", PnrGet_TestRoot,   divFunItem];
        [body appendFormat:@"<p> <a href='/%@?%@=%@' class='%@' > 崩溃日志 </a> </p>", PnrGet_TestRoot, PnrKey_TestSearch, PnrCN_crashTitle,  divFunItem];
        [body appendFormat:@"<p> <a href='/%@' class='%@' > MD5Test </a> </p>", PnrGet_YcUrl, divFunItem];
        
        // 二维码
        [body appendFormat:@"<img style=' width:200px; height:200px; margin-left:30px; ' src ='/%@' > </img>", PnrGet_QrUrlSelf];
        
        // MARK: 增加注释
        
        
        [body appendString:@"<ul>\n"];
        [body appendFormat:@"<li>新增网络请求接口:%@ </li>\n", [PnrPortEntity share].api];
        
        [body appendString:@"<li> </li>\n"];
        
        [body appendString:@"</ul>\n"];
        
        
        [body appendFormat:@"<p style=' right:10px; bottom:5px; position:absolute; ' >"];
        [body appendFormat:@"版本: %@(%@) ", [PoporAppInfo getAppVersion_short], [PoporAppInfo getAppVersion_build]];
        [body appendFormat:@"</p>"];
        
        [body appendFormat:@"</div>"];
    }
    
    NSMutableString * recordListBody = [NSMutableString new];
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.deviceNameArray.count > 0) {
        [recordListBody appendString:@"<p>"];
        for (PnrDeviceEntity * deviceEntity in pnr.deviceNameArray) {
            [recordListBody appendFormat:@"<a href='/%@?%@=%@' class='%@' > %@ </a>", PnrGet_recordRoot, PnrKey_DeviceName, deviceEntity.deviceName, divFunItem_unitKey, deviceEntity.deviceName];
        }
        [recordListBody appendString:@"</p>"];
    }
    
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, [body replaceWithREG:PoporNetRecordReplaceString newString:recordListBody], h5_detail_tail];
    
    return html;
}

@end
