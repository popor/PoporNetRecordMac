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

/**
 border颜色 为 #ccc
 */
+ (NSString *)cssTextarea1 {
    // min-height: 20px;\n\
    
    return @"\n textarea {\n\
    border: 1px solid #ccc;\n\
    padding: 5px;\n\
    width:100%;\n\
    font-size:16px;\n\
    resize:none;\n\
    overflow-y:hidden;\n\
    autoHeight:\"true\";\n\
    readonly:\"readonly\";\n\
    scrollTop:0;\n\
    }";
}

+ (NSString *)cssButton {
    static NSString * str;
    if (!str) {
        PnrConfig * config  = [PnrConfig share];
        NSString * colorKey = config.rootColorKeyHex;
        str =
        [NSString stringWithFormat:
         @"\n\
         \n button.w180Green {\n\
         color:%@; width:180px; font-size:16px;\
         }\n\
         \n button.w180Green1 {\n\
         color:%@; width:98%%; height:28px;font-size:16px;\
         }\n\
         \n button.w180Green2 {\n\
         color:%@; width:98%%; height:28px; font-size:16px;\
         }\n\
         \n button.wBlack_80_0 {\n\
         color:%@; width:80; height:28px; font-size:16px;\
         }\n\
         \n\
         \n\
         \n button.w180Red {\n\
         color:%@; width:180px; font-size:16px;\
         }\n\
         \n button.w180Red1 {\n\
         color:%@; background-color:%@; width:100%%; height:28px; font-size:16px;\
         }\n\
         \n\
         \n\
         \n button.w100p {\n\
         color:%@; width:100%%; font-size:16px;\
         }\n\
         \n button.w49p {\n\
         color:%@; width:95px; font-size:16px;\
         }\n\
         \n button.w49p_r {\n\
         color:%@; width:48%%; font-size:16px; float:right;\
         }\n\
         "
         , colorKey, colorKey, colorKey, @"#000000"
         
         // 红色的部分
         , @"#d7534a", @"red", @"wheat"
         
         , colorKey, colorKey, colorKey];
    }
    return str;
}

@end
