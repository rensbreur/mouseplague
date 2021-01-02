//
//  MouseHandler.m
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "MouseHandler.h"
#import "NSScreen+Conversion.h"
#import "MouseClick.h"
#import "CursorWindowController.h"

#define HIDUsageX 0x30
#define HIDUsageY 0x31
#define HIDUsageMouse 0x01

static void Handle_InputValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value);

@interface MouseHandler () {
@public
    uint8_t *report_buffer;

    bool clicked;
    uint64_t last_timestamp;
}

@property (nonatomic, strong) CursorWindowController *cursorWindowController;

@end

@implementation MouseHandler

- (id)initForMouse:(IOHIDDeviceRef)device {
    if (self = [super init]) {
        _device = device;

        CFArrayRef criteria = (__bridge CFArrayRef)@[@{@kIOHIDElementUsageKey: @HIDUsageX},
                                                     @{@kIOHIDElementUsageKey: @HIDUsageY},
                                                     @{@kIOHIDElementUsageKey: @HIDUsageMouse}];

        IOHIDDeviceSetInputValueMatchingMultiple(device, criteria);

        IOHIDDeviceRegisterInputValueCallback(device, Handle_InputValueCallback, (__bridge void *) self);

        self.cursorWindowController = [[CursorWindowController alloc] init];
        [self.cursorWindowController showCursorWindow];

    }
    return self;
}

- (void)mouseDidClick {
    NSPoint clickPoint = NSMakePoint(self.cursorWindowController->currentX, self.cursorWindowController->currentY + 25);
    CGPoint point = [NSScreen pointFromCocoa:clickPoint];
    [MouseClick performClickAtPoint:point];
}

- (void)close
{
    [self.cursorWindowController close];
}

@end

static void Handle_InputValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value)
{
    IOHIDElementRef element = IOHIDValueGetElement(value);
    u_int32_t usage = IOHIDElementGetUsage(element);

    float x = 0;
    float y = 0;

    MouseHandler *mouseController = (__bridge MouseHandler *)(context);

    if (usage == HIDUsageMouse) {
        if (IOHIDValueGetIntegerValue(value) == 1) {
            [mouseController mouseDidClick];
        }
        return;
    }

    if (usage == HIDUsageX) {
        x = IOHIDValueGetScaledValue(value, kIOHIDValueScaleTypeCalibrated);
    }

    if (usage == HIDUsageY) {
        y = IOHIDValueGetScaledValue(value, kIOHIDValueScaleTypeCalibrated);
    }

    [mouseController.cursorWindowController moveX:x Y:y];
}
