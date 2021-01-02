//
//  MouseDeviceDriver.m
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MouseDeviceDriver.h"
#import "NSScreen+Conversion.h"
#import "MouseClick.h"
#import "CursorWindowController.h"

#define kHIDUsageX 0x30
#define kHIDUsageY 0x31
#define kHIDUsageMouse 0x01

static void Handle_InputValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value);

@interface MouseDeviceDriver ()

@property (nonatomic, strong) CursorWindowController *cursorWindowController;

@end

@implementation MouseDeviceDriver

- (id)initWithDevice:(IOHIDDeviceRef)device {
    if (self = [super init]) {
        _device = device;

        CFArrayRef criteria = (__bridge CFArrayRef)@[@{@kIOHIDElementUsageKey: @kHIDUsageX},
                                                     @{@kIOHIDElementUsageKey: @kHIDUsageY},
                                                     @{@kIOHIDElementUsageKey: @kHIDUsageMouse}];

        IOHIDDeviceSetInputValueMatchingMultiple(device, criteria);

        IOHIDDeviceRegisterInputValueCallback(device, Handle_InputValueCallback, (__bridge void *) self);

        self.cursorWindowController = [[CursorWindowController alloc] init];
        [self.cursorWindowController showCursorWindow];

    }
    return self;
}

- (void)mouseDidClick {
    NSPoint clickPoint = NSMakePoint(self.cursorWindowController->currentX,
                                     self.cursorWindowController->currentY + 25);
    CGPoint point = [NSScreen pointFromCocoa:clickPoint];
    [MouseClick performClickAtPoint:point];
}

- (void)close {
    [self.cursorWindowController close];
}

@end

static void Handle_InputValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
    IOHIDElementRef element = IOHIDValueGetElement(value);
    u_int32_t usage = IOHIDElementGetUsage(element);

    float x = 0;
    float y = 0;

    MouseDeviceDriver *mouseController = (__bridge MouseDeviceDriver *)(context);

    if (usage == kHIDUsageMouse) {
        if (IOHIDValueGetIntegerValue(value) == 1) {
            [mouseController mouseDidClick];
        }
        return;
    }

    if (usage == kHIDUsageX) {
        x = IOHIDValueGetScaledValue(value, kIOHIDValueScaleTypeCalibrated);
    }

    if (usage == kHIDUsageY) {
        y = IOHIDValueGetScaledValue(value, kIOHIDValueScaleTypeCalibrated);
    }

    [mouseController.cursorWindowController moveX:x Y:y];
}
