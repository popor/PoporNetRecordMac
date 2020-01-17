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
#import "AESCrypt.h"

@implementation PnrWebBodyYcUrl

+ (NSString *)ycUrlBody {
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
            [h5 appendString:[PnrWebJs jsYcUrlPsdEditStatic]];
            [h5 appendString:[PnrWebJs jsYcUrlAnalysisStatic]];
            
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
    
    NSString * url    = @"TKYsE4CFAK1N1juhVt9Ab2ywQ28FwppbcgW94oLdoK8=";
    NSString * result =
    @"\
    规则\n\
    1：毫秒时间戳    1579240907000   13位\n\
    2：用户手机号    15267047620     11位\n\
    3：上传来源      0=未知，1=android，2=ios，3=flutter   1位\n\
    4：是否做过压缩   0=未知，1=压缩，2=未压缩               1位\n\
    5：上传前文件大小 0=未获取，其他数值向上取整如 120         x位\n\
    6：文件拓展名    .jpg .mp4\n\
    示例\n\
    TKYsE4CFAK1N1juhVt9Ab2ywQ28FwppbcgW94oLdoK8=\n\
    源码为:15792409070001526704762022120\n\
    ";
    
    [body appendString:[self jsonReadEditPsdForm:PnrKey_ycUrlPsd taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:@""]];
    [body appendString:[self jsonReadEditUrlForm:PnrKey_ycUrlUrl formShowName:PnrKey_ycUrlResult taIdName:PnrKey_Conent btName:PnrKey_TestUrl taValue:url]];
    [body appendString:[self jsonReadEditResponseForm:PnrKey_ycUrlResult taIdName:PnrKey_Conent taValue:result]];
    
    NSString * html = [NSString stringWithFormat:@"%@ \n %@ \n %@", h5_detail_head, body, h5_detail_tail];
    return html;
}

// 密码
+ (NSString *)jsonReadEditPsdForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <p style=' width:100%%; height:6px; background-color:#ccc; float:left; '></p> \n\
     <div style=' width:100%%; height:1px; float:left; '></div> \n\
     <form id='%@' name='%@' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Green1\" type='button' \" onclick=\"jsYcUrlPsdEditStatic('%@')\" > 保存 </button> \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <input  id='%@' name='%@' type='text' style=\" width:calc(100%% - 2px); height:28px; font-size:16px; \" value='%@' onkeydown=\"if(event.keyCode==13){return false;}\" ></input> \n\
     </div>\n\
     </form>\n\
     <p style=' width:100%%; height:1px; float:left; '></p> \n\
     </div> \n"
     , formIdName, formIdName
     , PnrKey_ycUrlBTPsd, formIdName
     , taIdName, taIdName, taValue
     ];
}

// 分析URL
+ (NSString *)jsonReadEditUrlForm:(NSString *)formIdName formShowName:(NSString *)formShowName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue {
    return
    [NSString stringWithFormat:
     @"\n\
     <div style=' width:100%%; ' >\n\
     <p style=' width:100%%; height:6px; background-color:#ccc; float:left; '></p> \n\
     <div style=' width:100%%; height:1px; float:left; '></div> \n\
     <form id='%@' name='%@' > \n\
     <div style=' width:120px; float:left; ' >\n\
     <button id='%@' class=\"w180Green1\" type='button' \" onclick=\"jsYcUrlAnalysisStatic('%@', '%@')\" > 分析 </button> \n\
     </div>\n\
     <div style=' width:calc(100%% - 120px); float:left; ' >\n\
     <input  id='%@' name='%@' type='text' style=\" width:calc(100%% - 2px); height:28px; font-size:16px; \" value='%@' onkeydown=\"if(event.keyCode==13){return false;}\" ></input> \n\
     </div>\n\
     </form>\n\
     <p style=' width:100%%; height:1px; float:left; '></p> \n\
     </div> \n"
     , formIdName, formIdName
     , PnrKey_ycUrlBTUrl, formIdName, formShowName
     , taIdName, taIdName, taValue
     ];
}

+ (NSString *)jsonReadEditResponseForm:(NSString *)formIdName taIdName:(NSString *)taIdName taValue:(NSString *)taValue {
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

+ (BOOL)updatePsd:(NSString *)psd {
    return [PoporFMDB updatePlistKey:YcUrlPsd_saveKey value:psd];
}

+ (NSString *)analysisUrl:(NSString *)url {
    NSString * psd = [PnrWebBodyYcUrl getPsd];
    //return [AESCrypt decrypt:url password:psd];
    // NSString * fileName = @"15784486313091526704762022120";
    // NSInteger  fileInt  = [fileName integerValue];
    // NSString * hexString= [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1lx",fileInt]];
    // NSLog(@"hexString: %@", hexString);
    // NSLog(@"10 String: %@", [self stringToHexWithInt:fileInt]);
    // NSLog(@"16 String: %@", [self stringToDecimalWithString:[NSString stringToHexWithInt:fileInt]]);
    // NSLog(@"16 String: %@", [self stringToDecimalWithString:@"7fffffffffffffff"]);
    
    /*
     文件名字
     
     1、毫秒时间戳   1579240907000   13位
     2、用户手机号   15267047620     11位
     3、上传来源  0=未知，1=android，2=ios，3=flutter      1位
     4、是否做过压缩   0=未知，1=压缩，2=未压缩   1位
     5、上传前文件大小 0=未获取，其他数值向上取整如   _1   _120
     6、文件拓展名   _jpg   _mp4
     
     上述字符串使用aes加密
     15792409070001526704762022120.jpg
     */
    NSString * tar = [AESCrypt decrypt:url password:psd];
    if (tar.length == 0) {
        tar = [AESCrypt encrypt:url password:psd];
    }
    if (tar.length > 0) {
        NSMutableString * text = [NSMutableString new];
        [text appendString:tar];
        int timeL     = 13;
        int phoneL    = 11;
        int sourceL   = 1;
        int compressL = 1;
        int location  = 0;
        
        if (tar.length > timeL) {
            NSString * time = [tar substringWithRange:(NSRange){location, timeL}];
            [text appendFormat:@"\n时间：%@", [NSDate stringFromDate:[NSDate dateFromUnixDate:time.integerValue/1000] formatter:nil]];
            location += timeL;
        }
        if (tar.length > location + phoneL) {
            NSString * phone = [tar substringWithRange:(NSRange){location, phoneL}];
            [text appendFormat:@"\n电话：%@", phone];
            location += phoneL;
        }
        if (tar.length > location + sourceL) {
            NSString * source = [tar substringWithRange:(NSRange){location, sourceL}];
            switch (source.intValue) {
                case 1: {
                    source = @"android";
                    break;
                }
                case 2: {
                    source = @"iOS";
                    break;
                }
                case 3: {
                    source = @"flutter";
                    break;
                }
                default:{
                    source = @"未知";
                    break;
                }
            }
            [text appendFormat:@"\n来源：%@", source];
            location += sourceL;
        }
        if (tar.length > location + compressL) {
            NSString * compress = [tar substringWithRange:(NSRange){location, compressL}];
            switch (compress.intValue) {
                case 1: {
                    compress = @"压缩";
                    break;
                }
                case 2: {
                    compress = @"未压缩";
                    break;
                }
                default:{
                    compress = @"未知";
                    break;
                }
            }
            [text appendFormat:@"\n压缩：%@", compress];
            location += sourceL;
        }
        if (tar.length > location) {
            [text appendFormat:@"\n容量：%@MB", [tar substringFromIndex:location]];
        }
        return text;
    } else{
        return @"异常";
    }
}

//+ (NSString *)stringToHexWithInt:(int)theNumber {
//    return [NSString stringWithFormat:@"%x", (unsigned int) theNumber];
//}
//
//+ (NSString *)stringToDecimalWithString:(NSString * _Nonnull)theNumber {
//    if (!theNumber) {
//        return @"";
//    }
//    return [NSString stringWithFormat:@"%i", (int)strtoul([theNumber UTF8String], 0, 16)];
//}

@end
