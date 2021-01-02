//
//  CursorView.m
//  mouseplague
//
//  Created by Rens Breur on 11.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "CursorView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface CursorView() {
    NSImage *image;
}

@end

@implementation CursorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        image = [NSImage imageNamed:@"cursor"];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [image drawAtPoint:NSMakePoint(0,0) fromRect:dirtyRect operation:NSCompositingOperationOverlay fraction:1.0];
}

@end
