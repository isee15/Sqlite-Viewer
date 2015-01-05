//
//  DbService.m
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import "DbService.h"
#import "DbHelper.h"

@implementation DbService
+ (DbService *)sharedInstance
{
    static DbService *instance = nil;

    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (NSArray *)tablesFromMaster
{
    QueryResult *result = [DbHelper query:@"select name from sqlite_master where type ='table'" inDb:self.dbPath andKey:self.key];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in result.result) {
        [names addObject:dict[@"name"]];
    }
    return [names copy];
}

- (QueryResult *)query:(NSString *)sql
{
    return [DbHelper query:sql inDb:self.dbPath andKey:self.key];
}

@end
