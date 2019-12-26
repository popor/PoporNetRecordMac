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

#import <PoporFoundation/NSDictionary+pTool.h>
#import "PoporAppInfo.h"

@implementation PnrWebBodyAdmin

+ (NSString *)html {
    
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    static NSMutableString * body;
    static NSString * html;
    if (!isInit) {
        isInit = YES;
        NSString * divFunList = @"divFunList";
        NSString * divFunItem = @"item";
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
            
            [h5 appendFormat:@"\n\n.%@ a{display: block; text-decoration: none; text-align:center; width:120px;  }\n", divFunList];
            
            [h5 appendFormat:
             @".%@ .%@{\n\
             height: 40px;\n\
             line-height: 40px;\n\
             color: #333333;\n\
             position: relative;\n\
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
             left: 30px;\n\
             background-color: #FD463E;\n\
             } \n"
             , divFunList, divFunItem];
            
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
        [body appendFormat:@"<a href='/%@' class='%@' > 网络请求 </a> <p>", PnrGet_recordRoot, divFunItem];
        [body appendFormat:@"<a href='/%@' class='%@' > 请求测试 </a> <p>", PnrGet_TestRoot,   divFunItem];
        [body appendFormat:@"<a href='/%@?%@=%@' class='%@' > 崩溃日志 </a> <p>", PnrGet_TestRoot, PnrKey_TestSearch, PnrCN_crashTitle,  divFunItem];
        
        // 二维码
        [body appendFormat:@"<img style=' width:100px; height:100px; margin-left:30px; ' src ='/%@' > </img>", PnrGet_QrUrlSelf];
        
        // MARK: 增加注释
        [body appendString:@"<ul>\n"];
        [body appendFormat:@"<li>新增网络请求接口:%@ </li>\n", PnrPost_recordAdd];
        
        [body appendString:@"<li> </li>\n"];
        
        [body appendString:@"</ul>\n"];
        
        
        [body appendFormat:@"<p style=' right:10px; bottom:5px; position:absolute; ' >"];
        [body appendFormat:@"版本: %@(%@) ", [PoporAppInfo getAppVersion_short], [PoporAppInfo getAppVersion_build]];
        [body appendFormat:@"</p>"];
        
        [body appendFormat:@"</div>"];
        
        html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, body, h5_detail_tail];
    }
    
    return html;
}

@end
