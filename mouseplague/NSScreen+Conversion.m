//
//  NSScreen+Conversion.m
//  CustomDrawing
//
//  Created by Rens Breur on 13.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "NSScreen+Conversion.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation NSScreen (Conversion)

+ (NSScreen *)screenContainingPoint:(NSPoint)point
{
    for (NSScreen *screen in [NSScreen screens]) {
        if (NSPointInRect(point, screen.frame))
            return screen;
    }
    return nil;
}

+ (NSScreen *)mainScreen
{
    return [self screenContainingPoint:NSZeroPoint];
}

+ (CGPoint)pointFromCocoa:(NSPoint)point
{
    return CGPointMake(point.x, NSMaxY([self mainScreen].frame) - point.y);
}

@end
