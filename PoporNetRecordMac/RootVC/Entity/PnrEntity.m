
//
//  PnrEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrEntity.h"
#import "PnrConfig.h"
#import "PnrPortEntity.h"

@implementation PnrEntity

+ (NSMutableString *)createListWebH5:(PnrEntity *)entity index:(NSInteger)index {
    PnrConfig * config = [PnrConfig share];

    NSString * bgColor = index%2==1 ? config.listWebColorCell0Hex:config.listWebColorCell1Hex;
    NSMutableString * h5 = [NSMutableString new];
    
    if (entity.log) {
        // log 日志模式
        [h5 appendFormat:@"\n\n <div style=' background:%@; width:100%%; height:%ipx; position:relative; ' onclick= 'parent.detail(%i);' >", bgColor, PnrListHeight, (int)index];
        
        [h5 appendString:@"\n <div style=' position:relative; width:100%%; top:4px; left:5px; ' >"];
        
        // 第一行
        [h5 appendFormat:@"\n <div class='oneLine' > <font color='%@'>%i. %@ </font> <font color='%@'>%@  </font> </div>",  config.listColorTitleHex, (int)index, @"Log日志" , config.listColorRequestHex, entity.deviceName];
        
        // 第二行
        [h5 appendFormat:@"\n <div class='oneLine' >\n <font style=\" opacity:0.0; \" >%i. </font> <font color='%@'>%@  </font> <font color='%@'>%@ </font> </div>", (int)index, config.listColorTimeHex, entity.time, config.listColorDomainHex, entity.log];
        
        [h5 appendString:@"</div></div>"];
    }else{
        // 网络请求模式
        [h5 appendFormat:@"\n\n <div style=' background:%@; width:100%%; height:%ipx; position:relative; ' onclick= 'parent.detail(%i);' >", bgColor, PnrListHeight, (int)index];
        
        [h5 appendString:@"\n <div style=' position:relative; width:100%%; top:4px; left:5px; ' >"];
        
        // 第一行
        [h5 appendFormat:@"\n <div class='oneLine' > <font color='%@'>%i. %@ </font> </div>",  config.listColorTitleHex, (int)index, entity.title ];
        
        // 第二行
        [h5 appendFormat:@"\n <div class='oneLine' >\n <font style=' opacity:0.0; ' >%i. </font> <font color='%@'>%@ - %@ </font> </div>", (int)index, config.listColorTimeHex, entity.time, entity.deviceName];
        
        [h5 appendString:@"</div></div>"];
    }
    return h5;
    
}

@end
