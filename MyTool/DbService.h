//
//  DbService.h
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryResult.h"

@interface DbService : NSObject
@property NSString *dbPath;
@property NSString *key;

+ (DbService *)sharedInstance;

- (NSArray *)tablesFromMaster;

- (QueryResult *)query:(NSString *)sql;

@end
