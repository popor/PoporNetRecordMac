//
//  PnrWebBody.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PnrEntity;

static NSString * ErrorUrl    = @"<html> <head><title>错误</title></head> <body><p> URL异常 </p> </body></html>";
static NSString * ErrorEntity = @"<html> <head><title>错误</title></head> <body><p> 无法找到对应请求 </p> </body></html>";
static NSString * ErrorUnknow = @"<html> <head><title>错误</title></head> <body><p> 未知bug </p> </body></html>";
static NSString * ErrorEmpty  = @"<html> <head><title>错误</title></head> <body><p> 无 </p> </body></html>";

static NSString * ErrorResubmit = @"<pre>\
请设置重新请求Block  \n\
#import &lt;PoporFoundation/NSString+Tool.h&gt;\n\
#import &lt;PoporFoundation/NSDictionary+tool.h&gt;\n\
#import &lt;PoporNetRecord/PoporNetRecord.h&gt;\n\
\n\
// 增加重新请求demo\n\
__block int record = 0;\n\
[PoporNetRecord setPnrBlockResubmit:^(NSDictionary *formDic, PnrBlockFeedback _Nonnull blockFeedback) {\n\
&#9; NSString * title        = formDic[@\"title\"];\n\
&#9; NSString * urlStr       = formDic[@\"url\"];\n\
&#9; NSString * methodStr    = formDic[@\"method\"];\n\
&#9; NSString * headStr      = formDic[@\"head\"];\n\
&#9; NSString * parameterStr = formDic[@\"parameter\"];\n\
&#9; //NSString * extraStr   = formDic[@\"extra\"];\n\
&#9; \n\
&#9; // 将新的网络请求 数据存储到PoporNetRecord \n\
&#9; NSDictionary * resultDic = @{@\"key\": [NSString stringWithFormat:@\"%i: %@\", record++, @\"新的返回数据:\"]};\n\
&#9; [PoporNetRecord addUrl:urlStr title:title method:methodStr head:headStr.toDic parameter:parameterStr.toDic response:resultDic];\n\
&#9; \n\
&#9; // 结果反馈给PoporNetRecord\n\
&#9; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
&#9; &#9; blockFeedback(resultDic.toJsonString);\n\
&#9; });\n\
} extraDic:@{@\"exKey\":@\"exValue\"}]; </pre> \n ";

@interface PnrWebBody : NSObject

+ (NSString *)jsonReadForm:(NSString *)formIdName taIdName:(NSString *)taIdName btName:(NSString *)btName taValue:(NSString *)taValue;

+ (NSString *)rootBodyIndex:(int)index;
+ (NSString *)listH5:(NSString *)body;

+ (void)deatilEntity:(PnrEntity *)pnrEntity index:(NSInteger)index extra:(NSDictionary *)extraDic finish:(void (^ __nullable)(NSString * detail, NSString * resubmit))finish;

// 弃用了
//+ (NSString *)feedbackH5:(NSString *)body;

@end

NS_ASSUME_NONNULL_END
