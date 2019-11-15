
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
//#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/NSString+pAtt.h>

@implementation PnrEntity

- (void)createListWebH5:(NSInteger)index {
    PnrConfig * config = [PnrConfig share];

    NSString * bgColor = index%2==1 ? config.listWebColorCell0Hex:config.listWebColorCell1Hex;
    NSMutableString * h5 = [NSMutableString new];
    
    if (self.log) {
        // log 日志模式
        [h5 appendFormat:@"\n\n <div style=\" background:%@; width:100%%; height:%ipx; position:relative; \" onclick= \"parent.detail(%i);\" >", bgColor, PnrListHeight, (int)index];
        
        [h5 appendString:@"\n <div style=\" position:relative; width:100%%; top:4px; left:5px; \" >"];
        
        [h5 appendFormat:@"\n <div class='oneLine' > <font color='%@'>%i. %@ </font> <font color='%@'>%@  </font> </div>",  config.listColorTitleHex, (int)index, @"Log日志" , config.listColorRequestHex, @""];
        [h5 appendFormat:@"\n <div class='oneLine' >\n <font style=\" opacity:0.0; \" >%i. </font> <font color='%@'>%@  </font> <font color='%@'>%@ </font> </div>", (int)index, config.listColorTimeHex, self.time, config.listColorDomainHex, self.log];
        
        [h5 appendString:@"</div></div>"];
    }else{
        // 网络请求模式
        [h5 appendFormat:@"\n\n <div style=\" background:%@; width:100%%; height:%ipx; position:relative; \" onclick= \"parent.detail(%i);\" >", bgColor, PnrListHeight, (int)index];
        
        [h5 appendString:@"\n <div style=\" position:relative; width:100%%; top:4px; left:5px; \" >"];
        
        [h5 appendFormat:@"\n <div class='oneLine' > <font color='%@'>%i. %@ </font> <font color='%@'>%@  </font> </div>",  config.listColorTitleHex, (int)index, self.title , config.listColorRequestHex, [self.path substringToIndex:MIN(self.path.length, 80)]];
        [h5 appendFormat:@"\n <div class='oneLine' >\n <font style=\" opacity:0.0; \" >%i. </font> <font color='%@'>%@  </font> <font color='%@'>%@ </font> </div>", (int)index, config.listColorTimeHex, self.time, config.listColorDomainHex, self.domain];
        
        [h5 appendString:@"</div></div>"];
    }
    self.listWebH5 = [h5 copy];
}

- (NSArray *)titleArray {
    PnrEntity * entity = self;
    if (entity.log) {
        NSArray * titleArray = @[
                                 entity.time,
                                 entity.log,
                                 ];
        return titleArray;
    }else{
        NSString * title;
        if (entity.title) {
            title = [NSString stringWithFormat:@" %@\n%@", entity.title, entity.path];
        }else{
            title = [NSString stringWithFormat:@" \n%@",entity.path];
        }
        NSArray * titleArray = @[[NSString stringWithFormat:@"%@\n%@", PnrRootPath1, title],
                                 [NSString stringWithFormat:@"%@\n%@", PnrRootUrl2, entity.url],
                                 [NSString stringWithFormat:@"%@\n%@", PnrRootTime3, entity.time],
                                 [NSString stringWithFormat:@"%@\n%@", PnrRootMethod4, entity.method],
                                 
                                 [NSString stringWithFormat:@"%@\n", PnrRootHead5],
                                 [NSString stringWithFormat:@"%@\n", PnrRootParameter6],
                                 [NSString stringWithFormat:@"%@\n", PnrRootResponse7],
                                 ];
        return titleArray;
    }
}

- (NSArray *)jsonArray {
    PnrEntity * entity = self;
    if (entity.log) {
        NSArray * jsonArray = @[[NSNull null],
                                [NSNull null],
                                ];
        return jsonArray;
    }else{
        NSArray * jsonArray = @[[NSNull null],
                                [NSNull null],
                                [NSNull null],
                                [NSNull null],
                                
                                entity.headValue ?:[NSNull null],
                                entity.parameterValue ?:[NSNull null],
                                entity.responseValue ?:[NSNull null],
                                ];
        
        return jsonArray;
    }
}

- (void)getJsonArrayBlock:(PnrEntityBlock)finish {
    if (!finish) {
        return;
    }
    PnrConfig * config   = [PnrConfig share];
    NSArray * titleArray = [self titleArray];
    NSArray * jsonArray  = [self jsonArray];
    
    //    NSMutableArray * cellAttArray = [NSMutableArray new];
    //    for (int i = 0; i<jsonArray.count; i++) {
    //        NSDictionary * json = jsonArray[i];
    //
    //        NSMutableAttributedString * cellAtt = [[NSMutableAttributedString alloc] initWithString:titleArray[i] attributes:config.titleAttributes];
    //
    //        if (json) {
    //            if ([json isKindOfClass:[NSDictionary class]]) {
    //                JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:json];
    //                jsh.keyAttributes       = config.keyAttributes;
    //                jsh.stringAttributes    = config.stringAttributes;
    //                jsh.nonStringAttributes = config.nonStringAttributes;
    //                NSAttributedString * jsonAtt = [jsh highlightJSON];
    //                [cellAtt appendAttributedString:jsonAtt];
    //            }else if ([json isKindOfClass:[NSString class]]) {
    //                [cellAtt addString:(NSString *)json font:nil color:[NSColor darkGrayColor]];
    //            }
    //        }
    //
    //        [cellAttArray addObject:cellAtt];
    //    }
    //    finish(titleArray, jsonArray, cellAttArray);
    
    finish(titleArray, jsonArray, nil);
}

@end
