//
//  CursorWindowController.h
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CursorWindowController : NSObject

@property (nonatomic, strong) NSWindow *cursorWindow;

- (void)showCursorWindow;
- (void)moveToX:(float)x Y:(float)y;

- (void)close;

@end

NS_ASSUME_NONNULL_END
