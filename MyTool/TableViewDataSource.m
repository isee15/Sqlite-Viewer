//
// Created by isee15 on 14/12/14.
// Copyright (c) 2014 miracle. All rights reserved.
//

#import "TableViewDataSource.h"


@implementation TableViewDataSource
{

}

- (void)dealloc
{

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.tableData.count;
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id obj = (self.tableData)[(NSUInteger) row];
    if (obj == nil)
        return nil;

    if (![obj isKindOfClass:[NSDictionary class]])
        return obj;

    id v = ((NSDictionary *) obj)[[tableColumn identifier]];
    if (v == [NSNull null]) return @"";
    return v;
}

- (NSString *)tableView:(NSTableView *)tableView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation
{
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        if ([[cell attributedStringValue] size].width > rect->size.width) {
            return [cell stringValue];
        }
    }
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}
@end