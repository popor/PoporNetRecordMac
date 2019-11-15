//
//  PnrWebCss.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebCss.h"

#import "PnrConfig.h"

@implementation PnrWebCss

+ (NSString *)cssPMarginPadding {
    return @"\n p {\n\
    margin:0;\n\
    padding:0 0 7 0;\n\
    }";
}

+ (NSString *)cssDivWordOneLine {
    return @"\n div.oneLine {\n\
    white-space:nowrap;\n\
    overflow:hidden;\n\
    text-overflow:ellipsis;\n\
    }";
}

+ (NSString *)cssTextarea {
    return @"\n textarea {\n\
    border: 1px solid #909090;\n\
    padding: 5px;\n\
    min-height: 20px;\n\
    width:100%;\n\
    font-size:16px;\n\
    resize:none;\n\
    overflow-y:hidden;\n\
    }";
}

+ (NSString *)cssButton {
    PnrConfig * config  = [PnrConfig share];
    NSString * colorKey = config.rootColorKeyHex;
    
    return [NSString stringWithFormat:@"\n button.w180Green {\n\
            color:%@; width:180px; font-size:16px;\
            }\n\
            \n button.w180Red {\n\
            color:%@; width:180px; font-size:16px;\
            }\n\
            \n button.w100p {\n\
            color:%@; width:100%%; font-size:16px;\
            }\n\
            \n button.w49p {\n\
            color:%@; width:49%%; font-size:16px;\
            }\n\
            "
            , colorKey, @"#d7534a", colorKey, colorKey];
}

@end
