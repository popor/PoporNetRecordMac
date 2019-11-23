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
            formIdName, formIdName, formIdName, btName, taIdName, taIdName, PnrJsClassTaAutoH, taValue
            ];
}

+ (NSString *)rootBody {
    PnrConfig * config = [PnrConfig share];
    
    NSMutableString * h5 = [NSMutableString new];
    [h5 appendFormat:@"<html> <head><title>%@</title></head>", config.webRootTitle];
    
    [h5 appendString:@"\n\n<body style=\" TEXT-ALIGN:center; \" >\n"]; // style=\" margin:auto; \"
    // TEXT-ALIGN: center;}
    [h5 appendString:@"\n<script>"];
    
    // MARK: root h5 js
    // 获取query id
    [h5 appendString:[PnrWebJs getQuery]];
    
    // detail()
    [h5 appendFormat:@"\n\
     ;function detail(row) {\n\
     ;    var deviceName = getQueryVariable('%@')\n\
     ;    var src = '/%@' + '?' + '%@=' + deviceName + '&%@=' + row ;\n\
     ;    document.getElementById('%@').src = src;\n\
     ;}",
     PnrKey_DeviceName,
     PnrGet_ViewDetail, PnrKey_DeviceName, PnrKey_index,
     PnrIframeDetail];
    
    // resubmit()
    [h5 appendFormat:@"\n\n\
     ;function resubmit() {\n\
     ;    var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\n\
     ;    form.submit();\n\
     ;}", PnrIframeDetail, PnrFormResubmit];
    
    // freshList()
    [h5 appendFormat:@"\n\n\
     ;function freshList() {\n\
     ;    document.getElementById('%@').contentWindow.location.reload(true);\n\
     ;}", PnrIframeList];
    
    // onload()
    [h5 appendFormat:@"\n\
     ;window.onload=function (){\n\
     ;    var deviceName = getQueryVariable('%@')\n\
     ;    var row        = getQueryVariable('%@')\n\
     ;    var srcList = '/%@' + '?' + '%@=' + deviceName + '&%@=' + row;\n\
     ;    document.getElementById('%@').src = srcList;\n\
     ;    if(row.length>0){\n\
     ;        var srcDetail = '/%@' + '?' + '%@=' + deviceName + '&%@=' + row;\n\
     ;        document.getElementById('%@').src = srcDetail;\n\
     ;    }\n\
     ;}",
     PnrKey_DeviceName,
     PnrKey_index,
     PnrGet_ViewList, PnrKey_DeviceName, PnrKey_index,
     PnrIframeList,
     PnrGet_ViewDetail, PnrKey_DeviceName, PnrKey_index,
     PnrIframeDetail
     ];
    
    // -------------------------------------------------------------------------
    
    [h5 appendString:@"\n\n </script>\n"];
    
    // src='/%@'
    [h5 appendFormat:@"\n <iframe id='%@' name='%@' style=\"width:%i%%; height:97%%; marginwidth:0;  background-color:%@; \" ></iframe>", PnrIframeList, PnrIframeList, config.listWebWidth, config.listWebColorBgHex];
    [h5 appendFormat:@"\n <iframe id='%@' name='%@' style=\"width:%i%%; height:97%%;\" ></iframe>", PnrIframeDetail, PnrIframeDetail, 100 - config.listWebWidth - 4];
    
    [h5 appendString:@"\n\n </body></html>"];
    return h5;
}

// MARK: 列表页面
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
            PnrConfig * config = [PnrConfig share];
            
            // 方便 浏览器查看 代码
            [html appendString:@"\n\nvar selectRowOld = -1;\n"];
            [html appendFormat:@"var listWebColorCell0Hex = '%@';\n", config.listWebColorCell0Hex];
            [html appendFormat:@"var listWebColorCell1Hex = '%@';\n", config.listWebColorCell1Hex];
            
            [html appendString:@"var selectBgColor = '#999999';\n"];
            [html appendString:@"var selectTextColor = '#ffffff';\n"];
            [html appendFormat:@"var defaultTextColor1 = '%@';\n", config.listColorTitleHex];
            [html appendFormat:@"var defaultTextColor2 = '%@';\n", config.listColorTimeHex];
            
            //[html appendString:@"var selectBgColor = 'bbbbbb';\n"];
            //[html appendString:@"var selectBgColor = 'bbbbbb';\n"];
            
            [html appendString:[PnrWebJs clearText]];
            [html appendString:[PnrWebJs getQuery]];
            
            //
            [html appendFormat:
             @"\n\n\
             ;function selectRow(row) {\n\
             ;    if (selectRowOld >= 0){\n\
             ;        var oldId = '%@' + selectRowOld.toString();\n\
             ;        var text1 = '%@' + selectRowOld.toString();\n\
             ;        var text2 = '%@' + selectRowOld.toString();\n\
             ;        if(selectRowOld%%2 == 1){\n\
             ;            document.getElementById(oldId).style.background = listWebColorCell0Hex;\n\
             ;        } else {\n\
             ;            document.getElementById(oldId).style.background = listWebColorCell1Hex;\n\
             ;        }\n\
             ;        document.getElementById(text1).style.color = defaultTextColor1;\n\
             ;        document.getElementById(text2).style.color = defaultTextColor2;\n\
             ;    }\n\
             ;    \n\
             ;    {\n\
             ;        selectRowOld = row;\n\
             ;        var newId = '%@' + row.toString();\n\
             ;        var text1 = '%@' + row.toString();\n\
             ;        var text2 = '%@' + row.toString();\n\
             ;        document.getElementById(newId).style.background = selectBgColor;\n\
             ;        document.getElementById(text1).style.color = selectTextColor;\n\
             ;        document.getElementById(text2).style.color = selectTextColor;\n\
             ;    }\n\
             ;    parent.detail(row);\n\
             ;}\n"
             , PnrH5_list
             , PnrH5_listText1
             , PnrH5_listText2
             , PnrH5_list
             , PnrH5_listText1
             , PnrH5_listText2
             ];
            
            // onload()
            [html appendFormat:@"\n\
             ;window.onload=function (){\n\
             ;    var index = getQueryVariable('%@');\n\
             ;    if (index.length >= 0){\n\
             ;        var oldId = '%@' + selectRowOld.toString();\n\
             ;        var text1 = '%@' + selectRowOld.toString();\n\
             ;        var text2 = '%@' + selectRowOld.toString();\n\
             ;        if(document.getElementById(oldId)){\n\
             ;            selectRowOld = parseInt(index);\n\
             ;            document.getElementById(oldId).style.background = selectBgColor;\n\
             ;            document.getElementById(text1).style.color = selectTextColor;\n\
             ;            document.getElementById(text2).style.color = selectTextColor;\n\
             ;        }\n\
             ;    }\n\
             ;}"
             , PnrKey_index
             , PnrH5_list
             , PnrH5_listText1
             , PnrH5_listText2
             ];
            
        }
        [html appendString:@"\n\n </script>\n"];
        
        
        [html appendFormat:@"\n <div style=\" background-color:%@; height:100%%; width:100%%; float:left; \">", config.listWebColorCellBgHex];
        [html appendString:@"\n <button class='w49p' type='button' onclick='clearAction();' > 清空 </button>"];
        [html appendString:@"\n <button class='w49p_r' type='button' onclick='location.reload();' > 刷新 </button>"];
        
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

// MARK: 详情 重新提交
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
        [html appendString:[PnrWebBody jsonReadForm:formIdName taIdName:PnrKey_Conent btName:btName taValue:taValue]];
    };
    
    void (^ btTaBlock)(NSMutableString*, NSString*, NSString*, NSString*) = ^(NSMutableString* html, NSString* btTitle, NSString* taIdName, NSString* taValue){
        
        [html appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" onclick=\"jsonDynamic('%@', '%@')\" > %@ 查看详情 </button> ",
         PnrFormResubmit, taIdName, btTitle
         ];
        [html appendFormat:@"\n <textarea id='%@' name='%@' class='%@'>%@</textarea> </p>",
         taIdName, taIdName, PnrJsClassTaAutoH, taValue];
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
            [h5 appendString:@"\n<script> \n"];
            [h5 appendString:[PnrWebJs jsJsonStatic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]];
            
            [h5 appendString:[PnrWebJs getRootUrl]];
            [h5 appendString:[PnrWebJs updateShareUrl]];
            [h5 appendString:[PnrWebJs copyInnerText]];
            [h5 appendString:[PnrWebJs getQuery]];
            
            // PnrGet_ViewResubmit()
            [h5 appendFormat:@"\n\n\
             ;function %@() {\n\
             ;    var deviceName = getQueryVariable('%@'); \n\
             ;    var row = getQueryVariable('%@'); \n\
             ;    var src = '/%@' + '?' + '%@=' + deviceName + '&%@=' + row ;\n\
             ;    window.location.href = src;\n\
             ;}\n\
             ",
             PnrGet_ViewResubmit,
             PnrKey_DeviceName,
             PnrKey_index,
             PnrGet_ViewResubmit, PnrKey_DeviceName, PnrKey_index];
            
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
            formBtTaBlock(h5, PnrCN_response, @"--", PnrFormFeedback);
            
            // js
            [h5 appendFormat:@"\n<script> \n%@", [PnrWebJs jsJsonDynamic]];
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]];
            [h5 appendString:[PnrWebJs jsJsonStatic]];
            [h5 appendString:[PnrWebJs ajaxResubmit]];
            [h5 appendString:[PnrWebJs getQuery]];
            
            // PnrGet_ViewDetail()
            [h5 appendFormat:@"\n\n\
             ;function %@() {\n\
             ;    var deviceName = getQueryVariable('%@')\n\
             ;    var row = getQueryVariable('%@')\n\
             ;    var src = '/%@' + '?' + '%@=' + deviceName + '&%@=' + row ;\n\
             ;    window.location.href = src;\n\
             ;}",
             PnrGet_ViewDetail,
             PnrKey_DeviceName,
             PnrKey_index,
             PnrGet_ViewDetail, PnrKey_DeviceName, PnrKey_index];
            
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
        
        //[h5 appendFormat:@"<p> <a style=\"text-decoration: none;\" href='/%i/%@'> <button class=\"w180Red\" type='button' > 重新请求 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>", (int)index, PnrGet_ViewResubmit];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%i.  %@</font>", colorKey, PnrCN_title, colorValue, (int)index, pnrEntity.title];
        [h5 appendFormat:@"<font color='%@'> &nbsp;%@ </font>  <font id='%@' name='%@' color='%@'></font> <button onclick=\"copyInnerText('%@')\" >点击复制</button></p>", colorKey, PnrCN_share, PnrKey_IdShare, PnrKey_IdShare, colorValue,  PnrKey_IdShare];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_time, colorValue, pnrEntity.time];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_log, colorValue, pnrEntity.log];
        
        [detail appendFormat:@"%@ \n %@ \n %@", h5_detail_head, h5, h5_detail_tail];
    }else{
        // 请求详情:网路求情
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a style=\"text-decoration: none;\" > <button class=\"w180Red\" type='button' onclick=\"%@(%i)\" > 重新请求 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>",  PnrGet_ViewResubmit, (int)index];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%i.  %@</font>", colorKey, PnrCN_title, colorValue, (int)index, pnrEntity.title];
        [h5 appendFormat:@"<font color='%@'> &nbsp;%@ </font>  <font id='%@' name='%@' color='%@'></font> <button onclick=\"copyInnerText('%@')\" >点击复制</button></p>", colorKey, PnrCN_share, PnrKey_IdShare, PnrKey_IdShare, colorValue,  PnrKey_IdShare];
        
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_time, colorValue, pnrEntity.time];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_path, colorValue, pnrEntity.path];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_url, colorValue, pnrEntity.url];
        [h5 appendFormat:@"<p><font color='%@'>%@&nbsp;</font><font color='%@'>%@</font></p>", colorKey, PnrCN_method, colorValue, pnrEntity.method];
        
        formBtTaBlock(h5, PnrCN_head,      headStr,      PnrKey_Head);
        formBtTaBlock(h5, PnrCN_parameter, parameterStr, PnrKey_Parameter);
        formBtTaBlock(h5, PnrCN_response,  responseStr,  PnrKey_Response);
        
        [detail appendFormat:@"%@ \n %@ \n %@", h5_detail_head, h5, h5_detail_tail];
    }
    // -------------------------------------------------------------------------
    {
        // 重新提交
        NSMutableString * h5 = [NSMutableString new];
        
        [h5 appendFormat:@"<p> <a style=\"text-decoration: none;\"> <button class=\"w180Red\" type='button'  onclick=\"%@(%i)\" > <==返回 </button> </a> <font color='#d7534a'> 请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。 </font> </p>", PnrGet_ViewDetail, (int)index];
        
        [h5 appendFormat:@"<form id='%@' name='%@' >", PnrFormResubmit, PnrFormResubmit];
        
        btTaBlock(h5, PnrCN_title,     PnrKey_Title,     pnrEntity.title);
        btTaBlock(h5, PnrCN_path,      PnrKey_Url, [NSString stringWithFormat:@"%@/%@", pnrEntity.domain, pnrEntity.path]);
        
        if ([pnrEntity.method.lowercaseString isEqualToString:@"post"]) {
            [h5 appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'          /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST' checked /><label for='methodPost'>POST</label>\n\
             </p>\n ", PnrCN_method];
        }else if ([pnrEntity.method.lowercaseString isEqualToString:@"get"]) {
            [h5 appendFormat:@"\n <p> <button class=\"w180Green\" type='button' \" > %@ </button> \n\
             <input type='radio' name='method' id='methodGet'  value='GET'  checked /><label for='methodGet'>GET</label>\n\
             <input type='radio' name='method' id='methodPost' value='POST'         /><label for='methodPost'>POST</label>\n\
             </p>\n ", PnrCN_method];
        }else{
            btTaBlock(h5, PnrCN_method, PnrKey_Method, pnrEntity.method);
        }
        
        btTaBlock(h5, PnrCN_head,      PnrKey_Head,      headStr);
        btTaBlock(h5, PnrCN_parameter, PnrKey_Parameter, parameterStr);
        btTaBlock(h5, PnrCN_extra,     @"extra",     extraStr);
        
        // 添加一个隐藏的deviceName
        [h5 appendFormat:@"<textarea id='%@\' name=\'%@' style=\"height: 0px; visibility:hidden; \" >%@</textarea>", PnrKey_DeviceName, PnrKey_DeviceName, pnrEntity.deviceName];
        
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


@end
