//
//  PnrRequestTestEntity.h
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 popor. All rights reserved.
//

#import <PoporJsonModel/PoporJsonModel.h>
#import <PoporFMDB/PoporFMDB.h>

NS_ASSUME_NONNULL_BEGIN

// 请求测试
@interface PnrRequestTestEntity : PoporJsonModel

@property (nonatomic        ) NSInteger id;
//@property (nonatomic        ) NSNumber<PoporFMDB_primary, PoporFMDB_autoIncrement> * id;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * response;

+ (void)addEntity:(PnrRequestTestEntity *)entity;

+ (PnrRequestTestEntity *)findUrl:(NSString *)url;

+ (void)updateEntity:(PnrRequestTestEntity *)entity;

+ (BOOL)updateIndex:(NSInteger)index url:(NSString *)url;
+ (BOOL)updateIndex:(NSInteger)index response:(NSString *)response;

+ (NSMutableArray *)allEntitySearch:(NSString *)searchWord;

@end

NS_ASSUME_NONNULL_END
