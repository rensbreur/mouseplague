//
//  CursorController.m
//  mouseplague
//
//  Created by Admin on 03.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

#import "CursorController.h"
#import "CursorWindowController.h"
#import "NSScreen+Point.h"
#import "MouseClick.h"

@interface CursorController() {
    NSRect currentScreenFrame;
}

@end

@implementation CursorController

- (void)moveX:(float)x Y:(float)y {
    currentY -= y;
    currentX += x;
    
    NSPoint point = NSMakePoint(currentX, currentY);
    if (!NSPointInRect(point, currentScreenFrame)) {
        // Did the cursor move to another screen?
        NSScreen *nextScreen = [NSScreen screenContainingPoint:point];
        if (nextScreen) {
            currentScreenFrame = nextScreen.frame;
        }
        
        // Otherwise, make sure the cursor doesn't go off-screen
        else {
            currentX = MIN(NSMaxX(currentScreenFrame), currentX);
            currentX = MAX(NSMinX(currentScreenFrame), currentX);
            currentY = MIN(NSMaxY(currentScreenFrame), currentY);
            currentY = MAX(NSMinY(currentScreenFrame), currentY);
        }
    }
    
    [self.cursorWindowController moveToX:currentX Y:currentY];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cursorWindowController = [CursorWindowController new];
        [self.cursorWindowController showCursorWindow];
        currentX = 50;
        currentY = 50;
        [self moveX:0 Y:0];
    }
    return self;
}

- (void)performClick {
    NSPoint clickPoint = NSMakePoint(currentX, currentY);
    CGPoint point = [NSScreen pointFromCocoa:clickPoint];
    [MouseClick performClickAtPoint:point];
}

- (void)stop {
    [self.cursorWindowController close];
}

@end
