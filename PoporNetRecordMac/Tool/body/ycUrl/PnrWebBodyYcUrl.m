//
//  PnrWebBodyYcUrl.m
//  PoporNetRecordMac
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 popor. All rights reserved.
//

#import "PnrWebBodyYcUrl.h"

#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrWebCss.h"
#import "PnrWebJs.h"

#import "PnrRequestTestEntity.h"
#import <PoporFoundation/NSDictionary+pTool.h>
#import <PoporFMDB/PoporFMDB.h>

@implementation PnrWebBodyYcUrl

+ (NSString *)ycUrlBody {
    NSDictionary    * editDic;
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    
    
    if (!isInit) {
        isInit = YES;
        NSString * h5_title = @"亿车URL分析";
        // MARK: detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>%@</title></head>", h5_title];
            
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
            [h5 appendString:[PnrWebJs jsJsonStatic]];
            [h5 appendString:[PnrWebJs jsTestEditStatic]];
            [h5 appendString:[PnrWebJs jsTestSearchStatic]];
            [h5 appendString:[PnrWebJs jsTestDeleteStatic]];
            
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]];
            
            [h5 appendString:[PnrWebJs getQuery]];
            
            // onload()
            [h5 appendFormat:@"\n\
             ;window.onload=function (){\n\
             ;    var ajax = new XMLHttpRequest();\n\
             ;    ajax.open( 'GET' , '/%@' , true );\n\
             ;    ajax.setRequestHeader( 'Content-Type' , 'application/json;charset=utf-8' );\n\
             ;    ajax.onreadystatechange = function () {\n\
             ;        if( ajax.readyState == 4 ) {\n\
             ;            if( ajax.status == 200 ) {\n\
             ;                 //var response = JSON.parse(ajax.responseText) js 解析json\n\
             ;                 var response = ajax.responseText;\n\
             ;                 response = decodeURIComponent(response);\n\
             ;                 document.forms['%@'].elements['%@'].value = response;\n\
             ;                 //console.log('返回的数据')\n\
             ;                 //console.log(ajax.responseText)\n\
             ;            }\n\
             ;        }\n\
             ;    }\n\
             ;    ajax.send( null );\n\
             ;}"
             , Pnrget_YcUrlPsd
             , PnrKey_ycUrlPsd, PnrKey_Conent
             ];
            
            [h5 appendString:@"\n </script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        
    }
    // MARK: 每次都需要拼接的部分
    
    NSMutableString * body = [NSMutableString new];

    [body appendString:[self jsonReadEditPsdForm:PnrKey_ycUrlPsd taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:@"" index:0 type:PnrKey_TestUrl]];
    [body appendString:[self jsonReadEditUrlForm:@"url" taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:@"a.jpg" index:0 type:PnrKey_TestUrl]];
    [body appendString:[self jsonReadEditResponseForm:@"result" taIdName:PnrKey_Conent btName:PnrKey_TestResponse taValue:@"222" index:0 type:PnrKey_TestResponse]];
    
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, body, h5_detail_tail];
    return html;
}

// 密码
+ (NSString *)jsonReadEditPsdForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <p style=' width:100%%; height:6px; background-color:#ccc; float:left; '></p> \n\
     <div style=' width:100%%; height:1px; float:left; '></div> \n\
     <form id='%@' name='%@' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Green1\" type='button' \" onclick=\"jsTestEditStatic('%@', '%li', '%@')\" > 保存 </button> \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <input  id='%@' name='%@' type='text' style=\" width:calc(100%% - 2px); height:28px; font-size:16px; \" value='%@' onkeydown=\"if(event.keyCode==13){return false;}\" ></input> \n\
     </div>\n\
     </form>\n\
     <p style=' width:100%%; height:1px; float:left; '></p> \n\
     </div> \n"
     , formIdName, formIdName
     , PnrKey_TestSave, formIdName, index, type
     , taIdName, taIdName, taValue
     ];
}

// 分析URL
+ (NSString *)jsonReadEditUrlForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <p style=' width:100%%; height:6px; background-color:#ccc; float:left; '></p> \n\
     <div style=' width:100%%; height:1px; float:left; '></div> \n\
     <form id='%@' name='%@' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Green1\" type='button' \" onclick=\"jsTestEditStatic('%@', '%li', '%@')\" > 分析 </button> \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <input  id='%@' name='%@' type='text' style=\" width:calc(100%% - 2px); height:28px; font-size:16px; \" value='%@' onkeydown=\"if(event.keyCode==13){return false;}\" ></input> \n\
     </div>\n\
     </form>\n\
     <p style=' width:100%%; height:1px; float:left; '></p> \n\
     </div> \n"
     , formIdName, formIdName
     , PnrKey_TestSave, formIdName, index, type
     , taIdName, taIdName, taValue
     ];
}

+ (NSString *)jsonReadEditResponseForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <form id='%@' name='%@' method='POST' target='_blank' > \n\
     <div style=' width:calc(100%% - 0px); float:left; ' >\n\
     <textarea id='%@' name='%@' class='%@'>%@</textarea> <p style=' height:10px; '></p> \n\
     </div>\n\
     </form>\n\
     </div>\n\n"
     , formIdName, formIdName // form1
     , taIdName, taIdName, PnrJsClassTaAutoH, taValue // ta
     ];
    
}


+ (NSString *)getPsd {
    NSString * psd = [PoporFMDB getPlistKey:YcUrlPsd_saveKey];
    if (!psd) {
        psd = @"123456";
        [PoporFMDB addPlistKey:YcUrlPsd_saveKey value:psd];
    }
    return psd;
}

+ (void)updatePsd:(NSString *)psd {
    [PoporFMDB updatePlistKey:YcUrlPsd_saveKey value:psd];
}

@end
