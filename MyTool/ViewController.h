//
//  ViewController.h
//  MyTool
//
//  Created by isee15 on 14/11/23.
//  Copyright (c) 2014年 miracle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OutlineViewDataSource.h"

@interface ViewController : NSViewController <NSOutlineViewDelegate>
@property(weak) IBOutlet NSOutlineView *dbOutline;
@property(weak) IBOutlet NSTableView *viewTable;
@property(weak) IBOutlet NSTextField *sqlTextField;
@property(weak) IBOutlet NSTextField *pathTextField;
@property(weak) IBOutlet NSTextField *passwordTextField;
@property(weak) IBOutlet NSTableView *structTableView;
@property(unsafe_unretained) IBOutlet NSTextView *outputTextView;

@end

