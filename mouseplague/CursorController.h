//
//  CursorController.h
//  mouseplague
//
//  Created by Admin on 03.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CursorWindowController;

NS_ASSUME_NONNULL_BEGIN

@interface CursorController : NSObject {
@public
    float currentX;
    float currentY;
}

@property (nonatomic) CursorWindowController *cursorWindowController;

- (void)moveX:(float)x Y:(float)y;

- (void)performClick;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
