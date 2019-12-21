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

+ (NSString *)requestTestRootBody {
    
    return nil;
}


+ (NSString *)requestTestListBody {
    
    return nil;
}


+ (NSString *)requestTestDetailBody {
    
    return nil;
}

+ (NSString *)requestTestBody {
    
    static BOOL       isInit;
    static NSString * h5_detail_head;
    static NSString * h5_detail_tail;
    
    if (!isInit) {
        isInit = YES;
        // MARK: detail 头
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>请求测试列表</title></head>"];
            
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
            [h5 appendString:[PnrWebJs jsTestEditStatic]];
            
            [h5 appendFormat:@"\n %@ %@", [PnrWebJs textareaAutoHeightFuntion], [PnrWebJs textareaAuhoHeigtEventClass:PnrJsClassTaAutoH]];
            
            [h5 appendString:[PnrWebJs getQuery]];
            
            
            [h5 appendString:@"\n </script>"];
            
            [h5 appendString:@"</body></html>"];
            h5_detail_tail = h5;
        }
        
    }
    // MARK: 每次都需要拼接的部分
    
    NSMutableString * boby = [NSMutableString new];
    NSArray * array = [PnrRequestTestEntity allEntity];
    for (PnrRequestTestEntity * entity in array) {
        NSString * urlKey      = [NSString stringWithFormat:@"%@_%li", PnrKey_TestUrl,      entity.id];
        NSString * responseKey = [NSString stringWithFormat:@"%@_%li", PnrKey_TestResponse, entity.id];
        
        [boby appendString:[self jsonReadEditUrlForm:urlKey taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:entity.url index:entity.id type:PnrKey_TestUrl]];
        
        [boby appendString:[self jsonReadEditResponseForm:responseKey taIdName:PnrKey_Conent btName:PnrKey_TestResponse taValue:entity.response index:entity.id type:PnrKey_TestResponse]];
    }
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, boby, h5_detail_tail];
    return html;
}

+ (NSString *)jsonReadEditUrlForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    // method='POST' target='_blank'
    // background-color:#3c8877;
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%;  background-color:#336ff9;  ' >\n\
     <form id='%@' name='%@' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Green1\" type='button' \" onclick=\"jsTestEditStatic('%@', '%li', '%@')\" > 保存 </button> \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <input  id='%@' name='%@' style=\" width:100%%; height:28px; font-size:16px; \" value='%@' ></input> \n\
     </div>\n\
     </form>\n\
     </div> <p><p><p>\n"
     , formIdName, formIdName
     , PnrKey_TestSave, formIdName, index, type
     , taIdName, taIdName, taValue
     ];
}

+ (NSString *)jsonReadEditResponseForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue index:(NSInteger)index type:(NSString *)type {
    // background-color:#336ff9;
    // background-color:#ff0000;
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <form id='%@' name='%@' method='POST' target='_blank' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button         class=\"w180Green2\" type='button' \" onclick=\"jsonStatic('%@')\" > %@ 查看 </button> <br> \n\
     <button id='%@' class=\"w180Green2\" type='button' \" onclick=\"jsTestEditStatic('%@', '%li', '%@')\" > 保存 </button>  \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <textarea id='%@' name='%@' class='%@'>%@</textarea> <p><p><p>\n\
     </div>\n\
     </form>\n\
     </div> <p><p><p>\n\n"
     , formIdName, formIdName // form1
     , formIdName, btName     // bt1
     , PnrKey_TestSave, formIdName, index, type  // bt2
     , taIdName, taIdName, PnrJsClassTaAutoH, taValue // ta
     ];
}

@end
