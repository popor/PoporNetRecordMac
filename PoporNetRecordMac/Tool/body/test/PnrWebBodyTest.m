//
//  PnrWebBodyTest.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrWebBodyTest.h"

#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrWebCss.h"
#import "PnrWebJs.h"

#import "PnrRequestTestEntity.h"
#import <PoporFoundation/NSDictionary+pTool.h>

@implementation PnrWebBodyTest

+ (NSString *)requestTestBody:(NSDictionary *)dic {
    
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    
    
    if (!isInit) {
        isInit = YES;
        NSString * h5_title = @"请求测试";
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
            
            // 搜索栏 
            [h5 appendFormat:
             @"\n<div' style=\" width:100%%; \" >\n\
             <form id='%@' >\n\
             <a href='/'><img src ='favicon.ico' style=' width:28px; height:28px; margin:0 0 -8px 10px; '></img></a>\n\
             <input id='%@' type='text' style=\" width:300px; height:28px; font-size:16px; justify-content: center; margin-left:10px; \"  onkeydown=\"if(event.keyCode==13){ jsTestSearchStatic('%@'); return false;}\"  ></input>\n\
             <button id='%@' class=\"wBlack_80_0\" type='button' \" onclick=\"jsTestSearchStatic('%@')\" style=' margin-left:10px; ' > 搜索 </button> \n\
             <button id='%@' style=' float:right; color:red; background-color:wheat; width:120px; height:28px; font-size:16px;'  type='button' \" onclick=\"jsTestDeleteAllStatic('%@')\" > 全部删除 </button> \n\
             </form>\n\
             </div>\n "
             , PnrKey_TestSearchForm
             , PnrKey_Conent, PnrKey_TestSearchForm
             , PnrKey_TestSearch, PnrKey_TestSearchForm // 搜索按钮
             , PnrKey_TestDeleteAll, PnrKey_TestSearchForm // 删除按钮
             ];
            
            
            //
            // <div style=' width:120px; float:right; ' >\n\
            // </div>
            
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
            [h5 appendString:[PnrWebJs jsTestDeleteOneStatic]];
            [h5 appendString:[PnrWebJs jsTestDeleteAllStatic]];
            
            //[h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]];
            
            [h5 appendString:[PnrWebJs textareaAutoHeightFuntionNew]];
            
            [h5 appendString:[PnrWebJs getQuery]];
            
            // onload()
            [h5 appendFormat:@"\n\
             ;window.onload=function (){\n\
             ;    var searchWord = getQueryVariable('%@')\n\
             ;    if(searchWord.length>0){\n\
             ;    searchWord = decodeURIComponent(searchWord);\n\
             ;        document.forms['%@'].elements['%@'].value = searchWord;\n\
             ;        document.getElementsByTagName('title')[0].innerText = searchWord + '_' + '%@';\n\
             ;    }\n\
             ;}"
             , PnrKey_TestSearch
             , PnrKey_TestSearchForm, PnrKey_Conent
             , h5_title
             ];
            
            [h5 appendString:@"\n </script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        
    }
    // MARK: 每次都需要拼接的部分
    
    NSMutableString * body = [NSMutableString new];
    NSArray * array = [PnrRequestTestEntity allEntitySearch:dic[PnrKey_TestSearch]];
    for (PnrRequestTestEntity * entity in array) {
        NSString * urlKey      = [NSString stringWithFormat:@"%@_%li", PnrKey_TestUrl,      entity.id];
        NSString * responseKey = [NSString stringWithFormat:@"%@_%li", PnrKey_TestResponse, entity.id];
        
        [body appendString:[self jsonReadEditUrlForm:urlKey taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:entity.url index:entity.id type:PnrKey_TestUrl]];
        [body appendString:[self jsonReadEditResponseForm:responseKey taIdName:PnrKey_Conent btName:PnrKey_TestResponse taValue:entity.response index:entity.id type:PnrKey_TestResponse]];
    }
    if (body.length == 0) {
        [body setString:@"<p>暂无内容</p>"];
    }
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, body, h5_detail_tail];
    return html;
}

+ (NSString *)jsonReadEditUrlForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
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
     <div style=' width:calc(100%% - 240px); float:left; ' >\n\
     <input  id='%@' name='%@' type='text' style=\" width:calc(100%% - 2px); height:28px; font-size:16px; \" value='%@' onkeydown=\"if(event.keyCode==13){return false;}\" ></input> \n\
     </div>\n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Red1\" type='button' \" onclick=\"jsTestDeleteOneStatic('%@', '%li')\" > 删除 </button> \n\
     </div>\n\
     </form>\n\
     <p style=' width:100%%; height:1px; float:left; '></p> \n\
     </div> \n"
     , formIdName, formIdName
     , PnrKey_TestSave, formIdName, index, type
     , taIdName, taIdName, taValue
     , PnrKey_TestDeleteOne, formIdName, index
     ];
}

+ (NSString *)jsonReadEditResponseForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <form id='%@' name='%@' method='POST' target='_blank' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button         class=\"w180Green2\" type='button' \" onclick=\"jsonStatic('%@')\" > 查看 </button> \n\
     <div style=' width:100%%; height:1px; float:left; '></div> \n\
     <button id='%@' class=\"w180Green2\" type='button' \" onclick=\"jsTestEditStatic('%@', '%li', '%@')\" > 保存 </button>  \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <textarea id='%@' name='%@' class='content %@'>%@</textarea> <p style=' height:10px; '></p> \n\
     </div>\n\
     </form>\n\
     </div>\n\n"
     , formIdName, formIdName // form1
     , formIdName // bt1
     , PnrKey_TestSave, formIdName, index, type  // bt2
     , taIdName, taIdName, PnrJsClassTaAutoH, taValue // ta
     ];
    
    /**
     <p style=' height:10px; '></p> 是因为textarea和左边2个bt高度不一致, 不增加的,排列有问题.
     */
}

@end
