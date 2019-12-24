//
//  MouseWindowController.m
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ArrowView.h"
#import "MouseWindowController.h"

@implementation MouseWindowController

- (void)showPointerWindow
{
    NSView *arrowView = [[ArrowView alloc] initWithFrame:NSMakeRect(0, 0, 20, 25)];

    self.otherWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 20, 25) styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    self.otherWindow.contentView = arrowView;
    [self.otherWindow makeKeyAndOrderFront:NSApp];
    self.otherWindow.backgroundColor = [NSColor colorWithWhite:0 alpha:0];

    self.otherWindow.collectionBehavior = NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient;
    self.otherWindow.level = ((int)(CGShieldingWindowLevel())) + 1;
    [self.otherWindow setIgnoresMouseEvents:YES];

    currentX = 0;
    currentY = 0;
}

- (void)moveToX:(float)x Y:(float)y
{
    currentY -= y;
    currentX += x;
    [self.otherWindow setFrameOrigin:NSMakePoint(currentX, currentY)];
}

- (void)close
{
    [self.otherWindow close];
}

@end
