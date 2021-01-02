//
//  CursorWindowController.h
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CursorWindowController : NSObject {
@public
    float currentX;
    float currentY;
}

@property (nonatomic, strong) NSWindow *cursorWindow;

- (void)showCursorWindow;
- (void)moveX:(float)x Y:(float)y;

- (void)close;

@end

NS_ASSUME_NONNULL_END
