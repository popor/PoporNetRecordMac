//
//  PnrWebBody.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebBody.h"
#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrWebCss.h"
#import "PnrWebJs.h"

#import <PoporFoundation/NSDictionary+pTool.h>

@implementation PnrWebBody

+ (NSString *)jsonReadForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue {
    return [NSString stringWithFormat:@"\n<form id='%@' name='%@' method='POST' target='_blank' > \n <button class=\"w180Green\" type='button' \" onclick=\"jsonStatic('%@')\" > %@ 查看详情 </button> <br> \n <textarea id='%@' name='%@' class='%@'>%@</textarea> \n</form>",
            formIdName, formIdName, formIdName, btName, taIdName, taIdName, PnrClassTaAutoH, taValue
            ];
}

+ (NSString *)rootBodyIndex:(int)index {
    PnrConfig * config = [PnrConfig share];
    
    NSMutableString * h5 = [NSMutableString new];
    [h5 appendFormat:@"<html> <head><title>%@</title></head>", config.webRootTitle];
    
    [h5 appendString:@"\n\n<body style=\" TEXT-ALIGN:center; \" >\n"]; // style=\" margin:auto; \"
    // TEXT-ALIGN: center;}
    [h5 appendString:@"\n<script>"];
    {
        // 方便 浏览器查看 代码
        [h5 appendFormat:@"\n function detail(row) {\n var src = '/' +row + '/%@';\n  document.getElementById('%@').src = src;\n }", PnrPathDetail, PnrIframeDetail];
        
        [h5 appendFormat:@"\n\n function resubmit() {\n var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\n form.submit();\n }", PnrIframeDetail, PnrFormResubmit];
        
        [h5 appendFormat:@"\n\n function freshList() {\n  document.getElementById('%@').contentWindow.location.reload(true);\n  }", PnrIframeList];
    }
    [h5 appendString:@"\n\n </script>\n"];
    
    if (index == 0) {
        [h5 appendFormat:@"\n <iframe id='%@' name='%@' src='/%@' style=\"width:%i%%; height:97%%; marginwidth:0;  background-color:%@; \" ></iframe>", PnrIframeList, PnrIframeList, PnrPathList, config.listWebWidth, config.listWebColorBgHex];
        [h5 appendFormat:@"\n <iframe id='%@' name='%@' style=\"width:%i%%; height:97%%;\" ></iframe>", PnrIframeDetail, PnrIframeDetail, 100 - config.listWebWidth - 4];
    }else{
        [h5 appendFormat:@"\n <iframe id='%@' name='%@' src='/%@' style=\"width:%i%%; height:97%%; background-color:%@; \" ></iframe>", PnrIframeList, PnrIframeList, PnrPathList, config.listWebWidth, config.listWebColorBgHex];
        [h5 appendFormat:@"\n <iframe id='%@' name='%@' src='/%i/%@'  style=\"width:%i%%; height:97%%;\" ></iframe>", PnrIframeDetail, PnrIframeDetail, index, PnrPathDetail, 100 - config.listWebWidth - 4];
    }
    
    [h5 appendString:@"\n\n </body></html>"];
    return h5;
}

+ (NSString *)listH5:(NSString *)body {
    static NSString * h5_head;
    static NSString * h5_tail;
    if (!h5_head) {
        PnrConfig * config = [PnrConfig share];
        
        NSMutableString * html = [NSMutableString new];
        [html appendString:@"<html> <head><title>网络请求</title></head> \n<body>"];
        // css
        [html appendString:@"\n<style type='text/css'> \n"];
        [html appendString:[PnrWebCss cssDivWordOneLine]];
        [html appendString:[PnrWebCss cssButton]];
        [html appendString:@"\n</style>"];

        // js
        [html appendString:@"\n<script>"];
        {
            // 方便 浏览器查看 代码
            [html appendFormat:@"\n %@ \n", [PnrWebJs clearText]];
        }
        [html appendString:@"\n\n </script>\n"];
        
        
        [html appendFormat:@"\n <div style=\" background-color:%@; height:100%%; width:100%%; float:left; \">", config.listWebColorCellBgHex];
        [html appendString:@"\n <button class='w49p' type='button' onclick='clearAction();' > 清空 </button>"];
        [html appendString:@"\n <button class='w49p' type='button' onclick='location.reload();' > 刷新 </button>"];
        
        h5_head = html;
    }
    if (!h5_tail) {
        NSMutableString * html = [NSMutableString new];
        [html appendString:@"\n </div>"];
        [html appendString:@"\n </body></html>"];
        
        h5_tail = html;
    }
    return [NSString stringWithFormat:@"%@ %@ %@", h5_head, body, h5_tail];
}
// self.resubmitExtraDic
+ (void)deatilEntity:(PnrEntity *)pnrEntity index:(NSInteger)index extra:(NSDictionary *)extraDic finish:(void (^ __nullable)(NSString * detail, NSString * resubmit))finish
{
    static BOOL isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    static NSString * h5_resubmit_head;
    static NSString * h5_resubmit_tail;
    
    PnrConfig * config    = [PnrConfig share];
    NSString * colorKey   = config.rootColorKeyHex;
    NSString * colorValue = config.rootColorValueHex;
    
    
    void (^ formBtTaBlock)(NSMutableString*, NSString*, id, NSString*) = ^(NSMutableString* html, NSString * btName, NSString * taValue, NSString * formIdName){
        [html appendString:[PnrWebBody jsonReadForm:formIdName taIdName:PnrKeyConent btName:btName taValue:taValue]];
    };
    
    void (^ btTaBlock)(NSMutableString*, NSString*, NSString*, NSString*) = ^(NSMutableString* html, NSString* btTitle, NSString* taIdName, NSString* taValue){
        
        [html appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" onclick=\"jsonDynamic('%@', '%@')\" > %@ 查看详情 </button> ",
         PnrFormResubmit, taIdName, btTitle
         ];
        [html appendFormat:@"\n <textarea id='%@' name='%@' class='%@'>%@</textarea> </p>",
         taIdName, taIdName, PnrClassTaAutoH, taValue];
    };
    
    if (!isInit) {
        isInit = YES;
        // MARK: detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>请求详情</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[PnrWebCss cssTextarea]];
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
            [h5 appendFormat:@"\n<script> %@", [PnrWebJs jsJsonStatic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            
            [h5 appendString:[PnrWebJs getRootUrl]];
            [h5 appendString:[PnrWebJs updateShareUrl]];
            [h5 appendString:[PnrWebJs copyInnerText]];
            [h5 appendString:@"\n </script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        // MARK: 重新提交 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>重新提交</title></head>"];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[PnrWebCss cssTextarea]];
            [h5 appendString:[PnrWebCss cssButton]];
            [h5 appendString:[PnrWebCss cssPMarginPadding]];
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            
            h5_resubmit_head = h5;
        }
        // MARK: 重新提交 尾
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<p> <button class=\"w180Red\" type='button' onclick=\"ajaxResubmit(%@)\" > 重新请求 </button> </p>", PnrFormResubmit];
            [h5 appendString:@"</form>"];
            
            // 返回数据
            formBtTaBlock(h5, PnrRootResponse7, @"--", PnrFormFeedback);
            
            // js
            [h5 appendFormat:@"\n<script> \n%@", [PnrWebJs jsJsonDynamic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            [h5 appendString:[PnrWebJs jsJsonStatic]];
            [h5 appendString:[PnrWebJs ajaxResubmit]];
            
            [h5 appendString:@"</script>"];
            
            [h5 appendString:@"\n</body></html>"];
            
            h5_resubmit_tail = h5;
        }
    }
    // MARK: 每次都需要拼接的部分
    NSString * headStr      = [self contentString:pnrEntity.headValue];
    NSString * parameterStr = [self contentString:pnrEntity.parameterValue];
    NSString * responseStr  = [self contentString:pnrEntity.responseValue];
    NSString * extraStr     = extraDic ? extraDic.toJsonString : @"{\"extraKey\":\"extraValue\"}";
    
    NSMutableString * detail   = [NSMutableString new];
    NSMutableString * resubmit = [NSMutableString new];
    if (pnrEntity.log) {
        // 请求详情:log
        NSMutableString * h5 = [NSMutableString new];
        
        //[h5 appendFormat:@"<p> <a style=\"text-decoration: none;\" href='/%i/%@'> <button class=\"w180Red\" type='button' > 重新请求 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>", (int)index, PnrPathEdit];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%i.  %@</font>", colorKey, PnrRootTitle0, colorValue, (int)index, pnrEntity.title];
        [h5 appendFormat:@"<font color='%@'> &nbsp;%@ </font>  <font id='%@' name='%@' color='%@'></font> <a > <button onclick=\"copyInnerText('%@')\" >点击复制</button></p>", colorKey, PnrRootShare9, PnrIdShare, PnrIdShare, colorValue,  PnrIdShare];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootTime3, colorValue, pnrEntity.time];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootLog10, colorValue, pnrEntity.log];
        
        [detail appendFormat:@"%@ \n %@ \n %@", h5_detail_head, h5, h5_detail_tail];
    }else{
        // 请求详情:网路求情
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a style=\"text-decoration: none;\" href='/%i/%@'> <button class=\"w180Red\" type='button' > 重新请求 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>", (int)index, PnrPathEdit];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%i.  %@</font>", colorKey, PnrRootTitle0, colorValue, (int)index, pnrEntity.title];
        [h5 appendFormat:@"<font color='%@'> &nbsp;%@ </font>  <font id='%@' name='%@' color='%@'></font> <a > <button onclick=\"copyInnerText('%@')\" >点击复制</button></p>", colorKey, PnrRootShare9, PnrIdShare, PnrIdShare, colorValue,  PnrIdShare];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootTime3, colorValue, pnrEntity.time];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootPath1, colorValue, pnrEntity.path];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootUrl2, colorValue, pnrEntity.url];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrRootMethod4, colorValue, pnrEntity.method];
        
        formBtTaBlock(h5, PnrRootHead5,      headStr,      PnrPathHead);
        formBtTaBlock(h5, PnrRootParameter6, parameterStr, PnrPathParameter);
        formBtTaBlock(h5, PnrRootResponse7,  responseStr,  PnrPathResponse);
        
        [detail appendFormat:@"%@ \n %@ \n %@", h5_detail_head, h5, h5_detail_tail];
    }
    
    {
        // 重新提交
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a style=\"text-decoration: none;\" href='/%i/%@'> <button class=\"w180Red\" type='button' > <==返回 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>", (int)index, PnrPathDetail];
        
        [h5 appendFormat:@"<form id='%@' name='%@' >", PnrFormResubmit, PnrFormResubmit];
        
        btTaBlock(h5, PnrRootTitle0,     @"title",     pnrEntity.title);
        btTaBlock(h5, PnrRootPath1,      @"url", [NSString stringWithFormat:@"%@/%@", pnrEntity.domain, pnrEntity.path]);
        
        if ([pnrEntity.method.lowercaseString isEqualToString:@"post"]) {
            [h5 appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'          /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST' checked /><label for='methodPost'>POST</label>\n\
             </p>\n ", PnrRootMethod4];
        }else if ([pnrEntity.method.lowercaseString isEqualToString:@"get"]) {
            [h5 appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'  checked /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST'         /><label for='methodPost'>POST</label>\n\
             </p>\n ", PnrRootMethod4];
        }else{
            btTaBlock(h5, PnrRootMethod4, @"method", pnrEntity.method);
        }
        
        btTaBlock(h5, PnrRootHead5,      @"head",      headStr);
        btTaBlock(h5, PnrRootParameter6, @"parameter", parameterStr);
        btTaBlock(h5, PnrRootExtra8,     @"extra",     extraStr);
        
        [resubmit appendFormat:@"%@ \n %@ \n %@", h5_resubmit_head, h5, h5_resubmit_tail];
    }
    finish(detail, resubmit);
}

+ (NSString *)contentString:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)content toJsonString];
    }else if([content isKindOfClass:[NSString class]]) {
        return (NSString *)content;
    }else{
        return @"NULL";
    }
}

// 弃用了
//+ (NSString *)feedbackH5:(NSString *)body {
//    static NSString * h5_head;
//    static NSString * h5_tail;
//    if (!h5_head) {
//        NSMutableString * h5 = [NSMutableString new];
//        [h5 setString:@"<html> <head><title>update</title></head>"];
//
//        // css
//        [h5 appendString:@"\n<style type='text/css'>"];
//        [h5 appendString:[PnrWebCss cssTextarea]];
//        [h5 appendString:[PnrWebCss cssButton]];
//        [h5 appendString:@"\n</style>"];
//
//        // body
//        [h5 appendString:@"\n<body>"];
//        h5_head = h5;
//    }
//    if (!h5_tail) {
//        NSMutableString * h5 = [NSMutableString new];
//        [h5 appendString:@"\n<script>"];
//
//        // js
//        [h5 appendString:@"\n window.onload=function (){\
//         parent.parent.freshList();\
//         } "];
//        [h5 appendFormat:@"\n %@ \n %@ \n", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
//
//        [h5 appendString:[PnrWebJs jsJsonStatic]];
//        [h5 appendString:@"\n </script>"];
//
//        [h5 appendString:@"\n</body></html>"];
//
//        h5_tail = h5;
//    }
//
//    return [NSString stringWithFormat:@"%@ %@ %@", h5_head, [PnrWebBody jsonReadForm:@"feedback" taIdName:PnrKeyConent btName:@"返回数据" taValue:body], h5_tail];
//}

@end
