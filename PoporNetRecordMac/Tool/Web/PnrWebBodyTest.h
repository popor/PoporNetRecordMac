//
//  PnrWebBodyTest.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PnrWebBodyTest : NSObject

//+ (NSString *)requestTestRootBody;
//+ (NSString *)requestTestListBody;
//+ (NSString *)requestTestDetailBody;

+ (NSString *)requestTestBody:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
