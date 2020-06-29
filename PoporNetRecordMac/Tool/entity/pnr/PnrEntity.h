//
//  PnrEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <PoporJsonModel/PoporJsonModel.h>
#import "PnrValuePrifix.h"
#import <PoporAFN/PoporAFN.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PnrEntityBlock) (NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray);

@protocol PnrEntity;
@interface PnrEntity : PoporJsonModel

@property (nonatomic, strong) NSString * recordID;

// 日志模式
@property (nonatomic, strong) NSString * log; // 如果此参数不为空,那么就是log模式
@property (nonatomic        ) int      logDetailH;// 详细模式下log cell 高度.

// 网路请求模式
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * path;
@property (nonatomic        ) PoporMethod method;// post get

@property (nonatomic, strong) id<Ignore> headValue;
@property (nonatomic, strong) id<Ignore> parameterValue;
@property (nonatomic, strong) id<Ignore> responseValue;

@property (nonatomic, strong) NSString * time;

//@property (nonatomic, strong) NSString * listWebH5; // 列表网页html5代码

//@property (nonatomic        ) float cellH;
@property (nonatomic, strong) NSString * deviceName;

// h5 代码
@property (nonatomic, strong) NSString * h5Detail;
@property (nonatomic, strong) NSString * h5Resubmit;

+ (NSMutableString *)createListWebH5:(PnrEntity *)entity index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

