//
//  QueryWindowController.m
//  MyTool
//
//  Created by isee15 on 14/12/15.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import "QueryWindowController.h"
#import "TableViewDataSource.h"

@interface QueryWindowController ()
@property QueryResult *result;
@property TableViewDataSource *dataSource;
@end

@implementation QueryWindowController

- (instancetype)initWithDataSource:(QueryResult *)result andTitle:(NSString *)title
{
    if (self = [super initWithWindowNibName:@"QueryWindowController"]) {
        _result = result;
        self.window.title = title;
    }
    return self;
}

- (void)setDataSourceForTable:(NSTableView *)tableView withSql:(QueryResult *)dataArray
{
    self.dataSource = [[TableViewDataSource alloc] init];
    while ([[tableView tableColumns] count] > 0) {
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    }
    self.dataSource.tableData = dataArray.result;

    for (NSString *key in dataArray.columns) {
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:key];
        column.title = key;
        [tableView addTableColumn:column];
    }
    tableView.dataSource = self.dataSource;
    tableView.delegate = self.dataSource;
    [tableView reloadData];

}

- (void)windowDidLoad
{
    [super windowDidLoad];
    if (self.result) {
        [self setDataSourceForTable:self.querySqlTableView withSql:self.result];
    }
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
