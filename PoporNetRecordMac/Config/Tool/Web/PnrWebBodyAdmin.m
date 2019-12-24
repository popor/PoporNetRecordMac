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

@implementation PnrWebBodyAdmin

+ (NSString *)html {
    
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    
    if (!isInit) {
        isInit = YES;
        // MARK: detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>admin</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[PnrWebCss cssTextarea1]];
            [h5 appendString:[PnrWebCss cssButton]];
            [h5 appendString:[PnrWebCss cssPMarginPadding]];
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
        
    }
    // MARK: 每次都需要拼接的部分
    NSMutableString * body = [NSMutableString new];
    [body appendFormat:@"<a href='/%@' > 网络请求 </a> <p>", PnrGet_recordRoot];
    [body appendFormat:@"<a href='/%@' > 请求测试列表 </a> <p>", PnrGet_TestRoot];
    
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, body, h5_detail_tail];
    return html;
}

@end
