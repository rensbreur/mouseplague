//
//  MouseDeviceListener.m
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "MouseDeviceListener.h"
#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDManager.h>
#import "MouseDeviceDriver.h"

@interface MouseDeviceListener ()

@property IOHIDManagerRef manager;
@property (strong) NSMutableArray *drivers;

/// One mouse will always use the system driver
@property (nonatomic) IOHIDDeviceRef systemMouse;

- (void)addDriverForDevice:(IOHIDDeviceRef)device;
- (void)removeDriverForDevice:(IOHIDDeviceRef)device;

@end

static void Handle_DeviceMatchingCallback(void *inContext,
                                          IOReturn inResult,
                                          void * inSender,
                                          IOHIDDeviceRef inIOHIDDeviceRef);

static void Handle_RemovalCallback(void *inContext,
                                   IOReturn inResult,
                                   void * inSender,
                                   IOHIDDeviceRef inIOHIDDeviceRef);

@implementation MouseDeviceListener

- (instancetype)init {
    if (self = [super init]) {
        _drivers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self startListening];
}

- (void)addDriverForDevice:(IOHIDDeviceRef)device {
    MouseDeviceDriver *driver = [[MouseDeviceDriver alloc] initWithDevice:device];
    [_drivers addObject:driver];
}

- (void)removeDriverForDevice:(IOHIDDeviceRef)device {
    for (MouseDeviceDriver *driver in _drivers) {
        if (driver.device == device) {
            [driver close];
            [_drivers removeObject:driver];
            break;
        }
    }
}

- (void)startListening {
    IOHIDManagerRef manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDManagerOptionNone);

    if (CFGetTypeID(manager) != IOHIDManagerGetTypeID()) {
        exit(1);
    }

    IOHIDManagerSetDeviceMatching(manager, (CFDictionaryRef)@{
        @kIOHIDDeviceUsagePageKey: @(kHIDPage_GenericDesktop),
        @kIOHIDDeviceUsageKey: @(kHIDUsage_GD_Mouse)
    });

    IOHIDManagerRegisterDeviceMatchingCallback(manager, Handle_DeviceMatchingCallback, (__bridge void *)self);
    IOHIDManagerRegisterDeviceRemovalCallback(manager, Handle_RemovalCallback, (__bridge void *)self);

    IOHIDManagerOpen(manager, kIOHIDOptionsTypeSeizeDevice);

    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    self.manager = manager;
}

@end

static void Handle_DeviceMatchingCallback(void *inContext,
                                          IOReturn inResult,
                                          void * inSender,
                                          IOHIDDeviceRef inIOHIDDeviceRef) {
    MouseDeviceListener *controller = (__bridge MouseDeviceListener *)(inContext);
    if (!controller.systemMouse) {
        controller.systemMouse = inIOHIDDeviceRef;
        IOHIDDeviceClose(inIOHIDDeviceRef, 0);
    }
    else {
        [controller addDriverForDevice:inIOHIDDeviceRef];
    }
}

static void Handle_RemovalCallback(void *inContext,
                                   IOReturn inResult,
                                   void * inSender,
                                   IOHIDDeviceRef inIOHIDDeviceRef) {
    MouseDeviceListener *controller = (__bridge MouseDeviceListener *)(inContext);
    [controller removeDriverForDevice:inIOHIDDeviceRef];
    
    /// If the device removed was the system mouse, assign this role to another mouse
    if (controller.systemMouse == inIOHIDDeviceRef && controller.drivers.count > 0) {
        MouseDeviceDriver *successorMouseDriver = controller.drivers.firstObject;
        [successorMouseDriver close];
        [controller.drivers removeObject:successorMouseDriver];
        IOHIDDeviceClose(successorMouseDriver.device, 0);
        controller.systemMouse = successorMouseDriver.device;
    }
}
