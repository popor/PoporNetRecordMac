//
//  PnrConfig.h
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/Block+pPrefix.h>
#import <PoporFoundation/Color+pPrefix.h>

#import "PnrPrefix.h"
NS_ASSUME_NONNULL_BEGIN

//typedef void(^PoporNetRecordNcBlock) (UINavigationController * nc);
typedef void(^PoporNetRecordRecordTypeBlock) (PoporNetRecordType type);

#define PnrColorGreen  PRGB16(0x4BB748)
#define PnrColorRed    PRGB16(0xF76738)
#define PnrListCellGap 7

@interface PnrConfig : NSObject

@property (nonatomic        ) CGFloat   activeAlpha;
@property (nonatomic        ) CGFloat   normalAlpha;
//@property (nonatomic        ) NSInteger recordMaxNum;

#pragma mark - 列表配置参数
// = (listFontTitle+3) + (listFontDomain+3) + PnrListCellGap*3,可以通过updateListCellHeight设置
@property (nonatomic        ) float   listCellHeight;
//------------------------------------------------------------------------------
@property (nonatomic, strong) NSFont  * listFontTitle;// 标题
@property (nonatomic, strong) NSFont  * listFontRequest;// 请求
@property (nonatomic, strong) NSFont  * listFontDomain;// 域名
@property (nonatomic, strong) NSFont  * listFontTime;// 时间

//------------------------------------------------------------------------------
@property (nonatomic, strong) NSColor * listColorTitle;// 标题
@property (nonatomic, strong) NSColor * listColorRequest;// 请求
@property (nonatomic, strong) NSColor * listColorDomain;// 域名
@property (nonatomic, strong) NSColor * listColorTime;// 时间
// ▽
@property (nonatomic, strong) NSString * listColorTitleHex;
@property (nonatomic, strong) NSString * listColorRequestHex;
@property (nonatomic, strong) NSString * listColorDomainHex;
@property (nonatomic, strong) NSString * listColorTimeHex;

// -----
@property (nonatomic, strong) NSColor * listColorCell0;// 列表偶数行背景色
@property (nonatomic, strong) NSColor * listColorCell1;// 列表奇数行背景色

@property (nonatomic        ) int       listWebWidth;// 推荐为 20 - 30 之间
@property (nonatomic, strong) NSColor * listWebColorCellBg;// web列表背景色
@property (nonatomic, strong) NSColor * listWebColorCell0;// web列表偶数行背景色
@property (nonatomic, strong) NSColor * listWebColorCell1;// web列表奇数行背景色
@property (nonatomic, strong) NSColor * listWebColorBg;// web查看页面颜色
// ▽
@property (nonatomic, strong) NSString * listColorCell0Hex;
@property (nonatomic, strong) NSString * listColorCell1Hex;

@property (nonatomic, strong) NSString * listWebColorCellBgHex;
@property (nonatomic, strong) NSString * listWebColorCell0Hex;
@property (nonatomic, strong) NSString * listWebColorCell1Hex;
@property (nonatomic, strong) NSString * listWebColorBgHex;


// -----
@property (nonatomic, strong) NSColor * rootColorKey;
@property (nonatomic, strong) NSColor * rootColorValue;
// ▽
@property (nonatomic, strong) NSString * rootColorKeyHex;
@property (nonatomic, strong) NSString * rootColorValueHex;

//------------------------------------------------------------------------------
#pragma mark - 请求详情配置
// 详情假如 att font 不为15也需要设置.
@property (nonatomic, strong) NSFont       * cellTitleFont;
@property (nonatomic, strong) NSDictionary * titleAttributes;// title值颜色
@property (nonatomic, strong) NSDictionary * keyAttributes;// key值颜色
@property (nonatomic, strong) NSDictionary * stringAttributes;// value string颜色
@property (nonatomic, strong) NSDictionary * nonStringAttributes;// value int颜色
//------------------------------------------------------------------------------

@property (nonatomic, strong) NSString * vcRootTitle;// VC标题
@property (nonatomic, strong) NSString * webRootTitle;// 网页标题
@property (nonatomic, strong) NSData   * webIconData;

//------------------------------------------------------------------------------
@property (nonatomic        ) PoporNetRecordType recordType;//监测类型
@property (nonatomic        ) PoporNetRecordType webType;//网页显示数据

//@property (nonatomic, copy  ) PoporNetRecordNcBlock presentNCBlock;// 用户更新 presentViewController NC的状态

@property (nonatomic        ) PnrListType jsonViewColorBlack;// json详情页面是否使用黑白.
@property (nonatomic        ) PnrListType jsonViewLogDetail;// Log日志是否显示详情.

// 自定义ballBT可见度, 假如为YES,那么ballBT第一次显示会设置为hidden=YES.
@property (nonatomic, getter=isCustomBallBtVisible) BOOL customBallBtVisible;

// 设置重新发起请求
@property (nonatomic, copy  ) PnrBlockPPnrEntity reRequestBlock;

+ (instancetype)share;

- (BOOL)isRecord;
- (BOOL)isShowListWeb;

- (void)updateListCellHeight;

- (void)updateTextColorBlack:(int)color;

- (void)updateLogDetail:(int)detail;

@end

NS_ASSUME_NONNULL_END
