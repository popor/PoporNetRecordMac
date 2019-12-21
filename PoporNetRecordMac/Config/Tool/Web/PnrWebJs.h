//
//  PnrWebJs.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PnrWebJs : NSObject

// MARK: 固定的查看json js代码
+ (NSString *)jsJsonStatic;
+ (NSString *)jsTestEditStatic;
+ (NSString *)jsTestSearchStatic;
+ (NSString *)jsTestDeleteStatic;

// MARK: 动态的查看json js代码, 生成新的form,并且submit.
+ (NSString *)jsJsonDynamic;

// MARK: 高度自适应的textarea
/**
 获取所有的ta
 */
+ (NSString *)textareaAuhoHeigtEventClass:(NSString *)className;

/**
 给ta增加监听事件,刷新ta高度.
 */
+ (NSString *)textareaAutoHeightFuntion;


// MARK: ajax 刷新增加
+ (NSString *)ajaxResubmit;

// https://blog.csdn.net/wild46cat/article/details/52718545
+ (NSString *)getRootUrl;

+ (NSString *)updateShareUrl;

+ (NSString *)copyInnerText;

+ (NSString *)clearText;

+ (NSString *)getQuery;

@end

NS_ASSUME_NONNULL_END
