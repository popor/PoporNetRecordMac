//
//  PnrRequestTestEntity.m
//  PoporNetRecordMac
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 popor. All rights reserved.
//

#import "PnrRequestTestEntity.h"
#import <PoporFMDB/PoporFMDB.h>

@implementation PnrRequestTestEntity

+ (void)addEntity:(PnrRequestTestEntity *)entity {
    [PoporFMDB addEntity:entity];
}

+ (PnrRequestTestEntity *)findUrl:(NSString *)url {
    NSMutableArray * array = [PoporFMDB arrayClass:[PnrRequestTestEntity class] where:@"url" equal:url];
    if (array.count > 0) {
        return array.firstObject;
    } else {
        PnrRequestTestEntity * entity = [PnrRequestTestEntity new];
        entity.url = url;
        entity.response = @"{\"status\":200}";
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

@end
