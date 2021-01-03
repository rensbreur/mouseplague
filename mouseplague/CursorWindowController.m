//
//  CursorWindowController.m
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "CursorView.h"
#import "CursorWindowController.h"

#define kCursorWindowXCalibr 4
#define kCursorWindowYCalibr 20

@implementation CursorWindowController

- (void)showCursorWindow {
    NSView *cursorView = [[CursorView alloc] initWithFrame:NSMakeRect(0, 0, 20, 25)];

    self.cursorWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 20, 25)
                                                    styleMask:NSWindowStyleMaskBorderless
                                                      backing:NSBackingStoreBuffered defer:NO];

    self.cursorWindow.contentView = cursorView;
    [self.cursorWindow makeKeyAndOrderFront:NSApp];
    self.cursorWindow.backgroundColor = [NSColor colorWithWhite:0 alpha:0];

    self.cursorWindow.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient;
    self.cursorWindow.level = ((int)(CGShieldingWindowLevel())) + 1;
    [self.cursorWindow setIgnoresMouseEvents:YES];

    self.cursorWindow.releasedWhenClosed = NO;
}

- (void)moveToX:(float)x Y:(float)y {
    [self.cursorWindow setFrameOrigin:NSMakePoint(x - kCursorWindowXCalibr, y - kCursorWindowYCalibr)];
}

- (void)close {
    [self.cursorWindow close];
}

@end
