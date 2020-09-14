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

+ (BOOL)updateUrl:(NSString *)url setResponse:(NSString *)response {
    PnrRequestTestEntity * entity = [self findUrl:url];
    BOOL success;
    if (entity) {
        NSString * tableName  = NSStringFromClass([PnrRequestTestEntity class]);
        NSString * futureSQL = [NSString stringWithFormat:@"UPDATE %@ set response = ? where url = ?;", tableName];
        
        PoporFMDB * tool = [PoporFMDB share];
        [tool start];
        success = [tool.db executeUpdate:futureSQL, response, url];
        [tool end];
    } else {
        PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
        entity.url = url;
        entity.response = response;
        
        success = [self addEntity:entity];
    }
    
    return success;
}


+ (BOOL)deleteAll:(NSString *)url {
    return [PoporFMDB deleteClass:[PnrRequestTestEntity class] where:@"url" like:[NSString stringWithFormat:@"%%%@%%", url]];
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

// https://www.w3school.com.cn/sql/sql_distinct.asp
+ (NSMutableArray *)urlArray {
    NSMutableArray * array = [NSMutableArray new];
    
    PoporFMDB * tool = [PoporFMDB share];
    [tool start];
    
    NSString * futureSQL = [NSString stringWithFormat:@"SELECT distinct url FROM %@", NSStringFromClass([self class])];
    FMResultSet * rs = [tool.db executeQuery:futureSQL];
    
    while ([rs next]) {
        PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
        [NSFMDB setFullEntity:entity withRS:rs];
        
        [array addObject:entity.url];
    }
    [tool end];
    return array;
    
}

@end
