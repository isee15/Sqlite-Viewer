//
//  DbHelper.h
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryResult.h"

#ifndef SQLITE_HAS_CODEC
#define SQLITE_HAS_CODEC
#endif

@interface DbHelper : NSObject
+ (QueryResult *)query:(NSString *)sql inDb:(NSString *)dbPath andKey:(NSString *)key;

+ (QueryResult *)execute:(NSString *)sql inDb:(NSString *)dbPath andKey:(NSString *)key;
@end
