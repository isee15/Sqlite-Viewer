//
//  OutlineViewDataSource.m
//  MyTool
//
//  Created by isee15 on 14/12/13.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import "OutlineViewDataSource.h"

@implementation OutlineViewDataSource

/* NOTE: it is not acceptable to call reloadData or reloadItem from the implementation of any of the following four methods, and doing so can cause corruption in NSOutlineViews internal structures.
 */
- (NSArray *)childrenForItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = self.topLevelItems;
    }
    else {
        children = (self.childrenDictionary)[item];
    }
    return children;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self childrenForItem:item] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [self childrenForItem:item][(NSUInteger) index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [outlineView parentForItem:item] == nil;
}

/* NOTE: this method is optional for the View Based OutlineView.
 */
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return item;
}
@end
