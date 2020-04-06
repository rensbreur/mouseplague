//
//  MouseHandler.h
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface MouseHandler : NSObject

- (id)initForMouse:(IOHIDDeviceRef)device;
- (void)close;

@property (assign, readonly) IOHIDDeviceRef device;

@end

NS_ASSUME_NONNULL_END
