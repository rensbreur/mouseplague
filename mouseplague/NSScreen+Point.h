//
//  NSScreen+Conversion.h
//  mouseplague
//
//  Created by Rens Breur on 13.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScreen (Point)

+ (NSScreen *)screenContainingPoint:(NSPoint)point;
+ (CGPoint)pointFromCocoa:(NSPoint)point;

@end

NS_ASSUME_NONNULL_END
