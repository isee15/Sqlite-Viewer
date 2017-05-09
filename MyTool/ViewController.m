//
//  ViewController.m
//  MyTool
//
//  Created by isee15 on 14/11/23.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import "ViewController.h"
#import "DbService.h"
#import "TableViewDataSource.h"
#import "QueryWindowController.h"

@interface ViewController ()
@property OutlineViewDataSource *viewDataSource;
@property NSMutableDictionary *sourceDict;
@property NSMutableArray *sqlWindows;
@property dispatch_source_t source;
@end

@implementation ViewController

- (void)awakeFromNib
{
    [self initializeUI];
}

- (void)initializeUI
{
    [self.view setFrame:NSMakeRect(0, 0, 720, 480)];

    NSString *dbPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"path"];
    NSString *dbPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass"];

    self.pathTextField.stringValue = dbPath ?: @"";
    self.passwordTextField.stringValue = dbPass ?: @"";
    self.sourceDict = [NSMutableDictionary dictionary];
    self.sqlWindows = [NSMutableArray array];
    [self redirectNSLog];
}

- (void)redirectNSLog
{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];

    dup2([[pipe fileHandleForWriting] fileDescriptor], fileno(stderr));
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, (uintptr_t) [pipeReadHandle fileDescriptor], 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_event_handler(self.source, ^{
        void *data = malloc(4096);
        ssize_t readResult = 0;
        do {
            errno = 0;
            readResult = read([pipeReadHandle fileDescriptor], data, 4096);
        } while (readResult == -1 && errno == EINTR);

        if (readResult > 0) {
            //AppKit UI should only be updated from the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *stdOutString = [[NSString alloc] initWithBytesNoCopy:data length:(NSUInteger) readResult encoding:NSUTF8StringEncoding freeWhenDone:YES];
                NSAttributedString *stdOutAttributedString = [[NSAttributedString alloc] initWithString:stdOutString];
                [self.outputTextView.textStorage appendAttributedString:stdOutAttributedString];
            });
        } else {free(data);}
    });
    dispatch_resume(self.source);
}

- (IBAction)onExec:(id)sender
{
    NSString *sql = self.sqlTextField.stringValue;

    sql = [sql stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (sql.length > 10) {
//        [self setDataSourceForTable:self.sqlDbTable withSql:sql];
        QueryResult *dataArray = [[DbService sharedInstance] query:sql];

        if (dataArray.columns.count > 0) {
            QueryWindowController *w = [[QueryWindowController alloc] initWithDataSource:dataArray andTitle:sql];
            [self.sqlWindows addObject:w];
            [w showWindow:self];
        }
    }
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)onOk:(id)sender
{
    NSString *key = self.passwordTextField.stringValue;
    NSString *dbPath = self.pathTextField.stringValue;
    NSString *memoryPath = @"file::memory:";
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath isDirectory:NO] && ![dbPath isEqualToString:memoryPath]) {
        NSAlert *alert = [[NSAlert alloc] init];

        [alert addButtonWithTitle:@"OK"];
        [alert setInformativeText:@"db file is not exist"];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dbPath forKey:@"path"];
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"pass"];

    [DbService sharedInstance].dbPath = dbPath;
    [DbService sharedInstance].key = key;

    self.viewDataSource = [[OutlineViewDataSource alloc] init];

    NSArray *tableNames = [[DbService sharedInstance] tablesFromMaster];
    self.viewDataSource.topLevelItems = @[@"Tables"];
    self.viewDataSource.childrenDictionary = @{@"Tables" : tableNames};
    self.dbOutline.dataSource = self.viewDataSource;
    [self.dbOutline reloadData];
    [self.dbOutline deselectAll:self];
    [self.dbOutline expandItem:nil expandChildren:YES];

}

- (void)setDataSourceForTable:(NSTableView *)tableView withSql:(NSString *)sql
{
    TableViewDataSource *dataSource = [[TableViewDataSource alloc] init];
    QueryResult *dataArray = [[DbService sharedInstance] query:sql];

    while ([[tableView tableColumns] count] > 0)
        [tableView removeTableColumn:[[tableView tableColumns] lastObject]];
    self.sourceDict[sql] = dataSource;
    dataSource.tableData = dataArray.result;

    for (NSString *key in dataArray.columns) {
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:key];
        column.title = key;
        [tableView addTableColumn:column];
    }
    tableView.delegate = dataSource;
    tableView.dataSource = dataSource;
    [tableView reloadData];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if ([self.dbOutline selectedRow] > 0) {
        NSString *item = [self.dbOutline itemAtRow:[self.dbOutline selectedRow]];
        [self setDataSourceForTable:self.viewTable withSql:[NSString stringWithFormat:@"select * from %@ limit 100", item]];
        [self setDataSourceForTable:self.structTableView withSql:[NSString stringWithFormat:@"pragma table_info(%@);", item]];
    }
}

@end
