//
//  PnrConfig.m
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import "PnrConfig.h"

#import <PoporFoundation/Fun+pPrefix.h>
#import <PoporFoundation/Color+pPrefix.h>
static NSString * KeyTextColor = @"PoporNetRecord_textColor";
static NSString * KeyLog       = @"PoporNetRecord_logDetail";

@interface PnrConfig ()
// 是否开启监测
@property (nonatomic) BOOL record;
@property (nonatomic) BOOL showListWeb;

@end

@implementation PnrConfig

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrConfig * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        // 基础设置
        instance.activeAlpha         = 1.0;
        instance.normalAlpha         = 0.6;

        instance.recordType          = PoporNetRecordEnable;
        instance.webType             = PoporNetRecordEnable;
        
        instance.vcRootTitle         = @"网络请求";
        instance.webRootTitle        = @"网络请求";
        
        NSFont * font                = [NSFont systemFontOfSize:15];
        //NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //paraStyle.lineSpacing = 1;

        instance.cellTitleFont       = font;
        // instance.titleAttributes     = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x000000], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.keyAttributes       = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0xE46F5C], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.stringAttributes    = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.nonStringAttributes = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        
        // ---
        instance.titleAttributes     = @{NSForegroundColorAttributeName:[NSColor blackColor], NSFontAttributeName:font};
        instance.keyAttributes       = @{NSForegroundColorAttributeName:PnrColorGreen, NSFontAttributeName:font};
        instance.stringAttributes    = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
        instance.nonStringAttributes = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
        
        {
            // instance.listCellHeight = 55;

            instance.listFontTitle      = [NSFont systemFontOfSize:16];
            instance.listFontRequest    = [NSFont systemFontOfSize:14];
            instance.listFontDomain     = [NSFont systemFontOfSize:15];
            instance.listFontTime       = [NSFont systemFontOfSize:15];

            instance.listColorTitle     = PnrColorGreen;
            instance.listColorRequest   = PnrColorRed;
            instance.listColorDomain    = PColorBlack3;
            instance.listColorTime      = PColorBlack6;

            instance.listColorCell0     = [NSColor whiteColor];
            instance.listColorCell1     = [NSColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

            instance.listWebWidth       = 20;
            instance.listWebColorCellBg = PRGB16(0XEEEEEE);
            instance.listWebColorCell0  = PRGB16(0XE2E2E2);
            instance.listWebColorCell1  = PRGB16(0XF2F2F2);
            instance.listWebColorBg     = PRGB16(0XFFFFFF);
            
            instance.rootColorKey       = PnrColorGreen;
            instance.rootColorValue     = PnrColorRed;
            [instance updateListCellHeight];
            
            instance.jsonViewColorBlack = [PnrConfig get__textColor];
            instance.jsonViewLogDetail  = [PnrConfig get__logDetail];
        }
    });
    return instance;
}

// 开关
- (void)setRecordType:(PoporNetRecordType)recordType {
    if (_recordType == 0 || _recordType != recordType) {
        _recordType = recordType;
        
        switch (recordType) {
            case PoporNetRecordAuto:
#if TARGET_IPHONE_SIMULATOR
                _record = YES;
#else
                if (PIsDebugVersion) {
                    _record = YES;
                }else{
                    _record = NO;
                }
#endif
                break;
            case PoporNetRecordEnable:
                _record = YES;
                break;
                
            case PoporNetRecordDisable:
                _record = NO;
                break;
                
            default:
                break;
        }
        
    }
}

- (void)setWebType:(PoporNetRecordType)listWebType {
    if (_webType == 0 || _webType != listWebType) {
        _webType = listWebType;
        
        switch (listWebType) {
            case PoporNetRecordAuto:
#if TARGET_IPHONE_SIMULATOR
                _showListWeb = YES;
#else
                if (PIsDebugVersion) {
                    _showListWeb = YES;
                }else{
                    _showListWeb = NO;
                }
#endif
                break;
            case PoporNetRecordEnable:
                _showListWeb = YES;
                break;
                
            case PoporNetRecordDisable:
                _showListWeb = NO;
                break;
                
            default:
                break;
        }
        
    }
}

- (BOOL)isRecord {
    return _record;
}

- (BOOL)isShowListWeb {
    return _showListWeb;
}

- (void)updateListCellHeight {
    self.listCellHeight = PnrListCellGap*3 + 6 + MAX(self.listFontTitle.pointSize, self.listFontRequest.pointSize) + self.listFontDomain.pointSize;
}

// 设定hexcolor
- (void)setListColorTitle:(NSColor *)listColorTitle {
    _listColorTitle = listColorTitle;
    _listColorTitleHex = [self hexStringColorNoAlpha:listColorTitle];
}

- (void)setListColorparameter:(NSColor *)listColorRequest {
    _listColorRequest = listColorRequest;
    _listColorRequestHex = [self hexStringColorNoAlpha:listColorRequest];
}

- (void)setListColorDomain:(NSColor *)listColorDomain {
    _listColorDomain = listColorDomain;
    _listColorDomainHex = [self hexStringColorNoAlpha:listColorDomain];
}

- (void)setListColorTime:(NSColor *)listColorTime {
    _listColorTime = listColorTime;
    _listColorTimeHex = [self hexStringColorNoAlpha:listColorTime];
}

- (void)setListColorCell0:(NSColor *)listColorCell0 {
    _listColorCell0 = listColorCell0;
    _listColorCell0Hex = [self hexStringColorNoAlpha:listColorCell0];
}

- (void)setListColorCell1:(NSColor *)listColorCell1 {
    _listColorCell1 = listColorCell1;
    _listColorCell1Hex = [self hexStringColorNoAlpha:listColorCell1];
}

- (void)setListWebColorCellBg:(NSColor *)listWebColorCellBg {
    _listWebColorCellBg = listWebColorCellBg;
    _listWebColorCellBgHex = [self hexStringColorNoAlpha:listWebColorCellBg];
}

- (void)setListWebColorCell0:(NSColor *)listWebColorCell0 {
    _listWebColorCell0 = listWebColorCell0;
    _listWebColorCell0Hex = [self hexStringColorNoAlpha:listWebColorCell0];
}

- (void)setListWebColorCell1:(NSColor *)listWebColorCell1 {
    _listWebColorCell1 = listWebColorCell1;
    _listWebColorCell1Hex = [self hexStringColorNoAlpha:listWebColorCell1];
}

- (void)setListWebColorBg:(NSColor *)listWebColorBg {
    _listWebColorBg = listWebColorBg;
    _listWebColorBgHex = [self hexStringColorNoAlpha:listWebColorBg];
}

- (void)setRootColorKey:(NSColor *)rootColorKey {
    _rootColorKey = rootColorKey;
    _rootColorKeyHex = [self hexStringColorNoAlpha:rootColorKey];
}

- (void)setRootColorValue:(NSColor *)rootColorValue {
    _rootColorValue = rootColorValue;
    _rootColorValueHex = [self hexStringColorNoAlpha:rootColorValue];
    
}

// tool
- (NSString *)hexStringColorNoAlpha:(NSColor *)color {
    //颜色值个数，rgb和alpha
    NSInteger cpts = (NSInteger)CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    if (cpts == 2) {
        CGFloat w = components[0];//白色
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(w * 255), lroundf(w * 255), lroundf(w * 255)];
    }else{
        CGFloat r = components[0];//红色
        CGFloat g = components[1];//绿色
        CGFloat b = components[2];//蓝色
        
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    }
}

//- (NSString *)hexStringColor: (NSColor*) color {
//    //颜色值个数，rgb和alpha
//    NSInteger cpts = CGColorGetNumberOfComponents(color.CGColor);
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
//    CGFloat r = components[0];//红色
//    CGFloat g = components[1];//绿色
//    CGFloat b = components[2];//蓝色
//    if (cpts == 4) {
//        CGFloat a = components[3];//透明度
//        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
//    } else {
//        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
//    }
//}

- (void)updateTextColorBlack:(int)color {
    [PnrConfig save__textColor:color];
    self.jsonViewColorBlack = color;
}

+ (void)save__textColor:(int)textColor {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", textColor] forKey:KeyTextColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)get__textColor {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:KeyTextColor];
    if (info) {
        return [info intValue];
    }else{
        return PnrListTypeTextColor;
    }
}

- (void)updateLogDetail:(int)detail {
    [PnrConfig save__logDetail:detail];
    self.jsonViewLogDetail = detail;
}

+ (void)save__logDetail:(int)detail {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", detail] forKey:KeyLog];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)get__logDetail {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:KeyLog];
    if (info) {
        return [info intValue];
    }else{
        return PnrListTypeLogDetail;
    }
}

@end
