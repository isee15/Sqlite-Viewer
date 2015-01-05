//
//  OutlineViewDataSource.h
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface OutlineViewDataSource : NSObject <NSOutlineViewDataSource>
//For NSOutlineView Level 1 Items
@property(copy) NSArray *topLevelItems;

//For NSOutlineView child items
@property(copy) NSDictionary *childrenDictionary;
@end
