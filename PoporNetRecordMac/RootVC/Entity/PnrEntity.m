
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
    
    NSString * selectAction   = @"selectRow";    //selectAction = @"parent.detail";
    NSString * textColorLine1 = config.listColorTitleHex;
    NSString * textColorLine2 = config.listColorTimeHex;
    
    [h5 appendFormat:@"\n\n <div id='%@%i' style=' background:%@; width:100%%; height:%ipx; position:relative; ' onclick= '%@(%i);' >"
     , PnrH5_list, (int)index, bgColor, PnrListHeight, selectAction, (int)index];
    
    [h5 appendString:@"\n <div style=' position:relative; width:100%%; top:4px; left:5px; ' >"];
    
    // 第一行
    [h5 appendFormat:@"\n <div class='oneLine' > <font id='%@%i' color='%@'>%i. %@ </font> </div>"
     , PnrH5_listText1, (int)index, textColorLine1, (int)index, entity.title ];
    
    // 第二行
    [h5 appendFormat:@"\n <div class='oneLine' >\n <font style=' opacity:0.0; ' >%i. </font> <font id='%@%i' color='%@'>%@ - %@ </font> </div>"
     , (int)index, PnrH5_listText2, (int)index, textColorLine2, entity.time, entity.deviceName];
    
    [h5 appendString:@"</div></div>"];
    
    return h5;
    
}

@end
