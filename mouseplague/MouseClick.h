//
//  MouseClick.h
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface MouseClick : NSObject

+ (void)performClickAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
