//
//  PnrRequestTestEntity.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrRequestTestEntity.h"
#import "PnrValuePrifix.h"

@implementation PnrRequestTestEntity

+ (BOOL)addEntity:(PnrRequestTestEntity *)entity {
    return [PoporFMDB addEntity:entity];
}

+ (PnrRequestTestEntity *)findUrl:(NSString *)url {
    NSMutableArray * array = [PoporFMDB arrayClass:[PnrRequestTestEntity class] where:@"url" equal:url];
    if (array.count > 0) {
        return array.firstObject;
    } else {
        PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
        entity.url = url;
        entity.response = PnrCN_testDefaultResponse;
        [PoporFMDB addEntity:entity];
        return entity;
    }
}

+ (void)updateEntity:(PnrRequestTestEntity *)entity {
    
    NSString * tableName  = NSStringFromClass([PnrRequestTestEntity class]);
    NSString * futureSQL = [NSString stringWithFormat:@"UPDATE %@ set url = ? , response = ? where id = ?;", tableName];

    PoporFMDB * tool = [PoporFMDB share];
    [tool start];
    [tool.db executeUpdate:futureSQL, entity.url, entity.response, entity.id];
    [tool end];
}

+ (BOOL)updateIndex:(NSInteger)index url:(NSString *)url {
    NSString * tableName  = NSStringFromClass([PnrRequestTestEntity class]);
    NSString * futureSQL = [NSString stringWithFormat:@"UPDATE %@ set url = ? where id = ?;", tableName];

    PoporFMDB * tool = [PoporFMDB share];
    [tool start];
    BOOL success = [tool.db executeUpdate:futureSQL, url, [NSString stringWithFormat:@"%li", index]];
    [tool end];
    return success;
}

+ (BOOL)updateIndex:(NSInteger)index response:(NSString *)response {
    NSString * tableName  = NSStringFromClass([PnrRequestTestEntity class]);
    NSString * futureSQL = [NSString stringWithFormat:@"UPDATE %@ set response = ? where id = ?;", tableName];

    PoporFMDB * tool = [PoporFMDB share];
    [tool start];
    BOOL success = [tool.db executeUpdate:futureSQL, response, [NSString stringWithFormat:@"%li", index]];
    [tool end];
    return success;
}

+ (NSMutableArray *)allEntitySearch:(NSString *)searchWord {
    if (searchWord.length <= 0) {
        return [PoporFMDB arrayClass:[PnrRequestTestEntity class]];
    } else {
        return [PoporFMDB arrayClass:[PnrRequestTestEntity class] where:@"url" like:[NSString stringWithFormat:@"%%%@%%", searchWord]];
    }
}

+ (BOOL)deleteIndex:(NSString *)index {
    return [PoporFMDB deleteClass:[PnrRequestTestEntity class] where:@"id" equal:index];
}

@end
