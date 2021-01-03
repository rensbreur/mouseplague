//
//  MouseClick.m
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "MouseClick.h"

@implementation MouseClick

+ (void)performClickAtPoint:(CGPoint)point {
    CGEventRef event = CGEventCreate(NULL);
    CGPoint temp = CGEventGetLocation(event);

    CGEventRef click1_down = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventRef click1_up = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
    CGEventPost(kCGSessionEventTap, click1_down);
    CGEventPost(kCGSessionEventTap, click1_up);

    CGWarpMouseCursorPosition(temp);

    CFRelease(click1_up);
    CFRelease(click1_down);
}

@end
