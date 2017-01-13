//
//  DbHelper.m
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import "DbHelper.h"
#import "FMDB.h"

@implementation DbHelper


+ (QueryResult *)query:(NSString *)sql inDb:(NSString *)dbPath andKey:(NSString *)key
{
    NSString *lowerSql = [[sql stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if ([lowerSql hasPrefix:@"insert"] || [lowerSql hasPrefix:@"update"] || [lowerSql hasPrefix:@"alter"] || [lowerSql hasPrefix:@"delete"]) {
        return [DbHelper execute:sql inDb:dbPath andKey:key];
    }
    QueryResult *queryResult = [[QueryResult alloc] init];
    //select name from sqlite_master where type ='table'
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    db.traceExecution = YES;
    if (![db open]) {
        NSLog(@"Could not open db %@.", dbPath);
        return nil;
    }
    if (key.length > 0)
        [db setKey:key];

    FMResultSet *rs = [db executeQuery:sql];
    NSMutableArray *columns = [NSMutableArray array];
    for (int i = 0; i < rs.columnCount; ++i) {
        [columns addObject:[rs columnNameForIndex:i]];
    }
    queryResult.columns = columns;
    NSMutableArray *result = [NSMutableArray array];
    while ([rs next]) {
        [result addObject:[rs resultDictionary]];
    }
    [db close];
    queryResult.result = result;
    return queryResult;
}

+ (QueryResult *)execute:(NSString *)sql inDb:(NSString *)dbPath andKey:(NSString *)key
{
    QueryResult *queryResult = [[QueryResult alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    db.traceExecution = YES;
    if (![db open]) {
        NSLog(@"Could not open db %@.", dbPath);
        return nil;
    }
    if (key.length > 0)
        [db setKey:key];
    BOOL result = [db executeStatements:sql];
    [db close];
    queryResult.columns = @[@"exec result"];
    queryResult.result = @[@{@"exec result" : @(result)}];
    return queryResult;
}
@end
