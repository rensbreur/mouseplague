//
//  MouseWindowController.h
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MouseWindowController : NSObject {
@public
    float currentX;
    float currentY;
}

@property (nonatomic, strong) NSWindow *otherWindow;

- (void)showPointerWindow;
- (void)moveToX:(float)x Y:(float)y;

- (void)close;

@end

NS_ASSUME_NONNULL_END
