//
//  PnrRequestTestEntity.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 popor. All rights reserved.
//

#import <PoporJsonModel/PoporJsonModel.h>

NS_ASSUME_NONNULL_BEGIN

// 请求测试
@interface PnrRequestTestEntity : PoporJsonModel

@property (nonatomic        ) NSInteger  id;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * response;

+ (void)addEntity:(PnrRequestTestEntity *)entity;

+ (PnrRequestTestEntity *)findUrl:(NSString *)url;

+ (void)updateEntity:(PnrRequestTestEntity *)entity;

@end

NS_ASSUME_NONNULL_END
