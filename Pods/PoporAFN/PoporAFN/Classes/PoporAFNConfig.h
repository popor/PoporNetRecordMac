//
//  PoporAFNConfig.h
//  PoporAFN
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporAFNConfig : NSObject

typedef void(^PoporAFNFinishBlock)(NSString *url, NSData * _Nullable data, NSDictionary * _Nullabledic);
typedef void(^PoporAFNFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef NS_ENUM(NSInteger, PoporMethod) {
    PoporMethodGet,
    PoporMethodPost,
    PoporMethodFormData,
};

typedef AFHTTPSessionManager * _Nullable (^PoporAFNSMBlock)(void);

typedef void(^PoporAfnRecordBlock) (NSString *url, NSString *title, PoporMethod method, id head, id parameters, id response);

@property (nonatomic, copy  ) PoporAFNSMBlock afnSMBlock;//APP 需要设置p默认的head block. 假如需要设置单独的head可以自定义,使用PoporAFN的自定义manage接口.
@property (nonatomic, copy  ) PoporAfnRecordBlock recordBlock;

+ (PoporAFNConfig *)share;

// 设置manger,主要用于自定义head.
+ (AFHTTPSessionManager *)createManager;

@end

NS_ASSUME_NONNULL_END
