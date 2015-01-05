//
//  QueryWindowController.h
//  MyTool
//
//  Created by isee15 on 14/12/15.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QueryResult.h"

@interface QueryWindowController : NSWindowController
@property(weak) IBOutlet NSTableView *querySqlTableView;

- (instancetype)initWithDataSource:(QueryResult *)result andTitle:(NSString *)title;
@end
