//
//  MouseClick.m
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "MouseClick.h"

@implementation MouseClick

+ (void)performClickAtPoint:(CGPoint)point
{
    CGEventRef event = CGEventCreate(NULL);
    CGPoint temp = CGEventGetLocation(event);

    CGEventRef click1_down = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventRef click1_up = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, click1_down);
    CGEventPost(kCGHIDEventTap, click1_up);

    CGEventRef move1 = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, temp, kCGMouseButtonLeft );
    CGEventPost(kCGHIDEventTap, move1);

    CFRelease(move1);
    CFRelease(click1_up);
    CFRelease(click1_down);
}

@end
