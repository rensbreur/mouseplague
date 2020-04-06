//
//  MiceListener.m
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "MiceListener.h"
#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDManager.h>
#import "MouseHandler.h"

static void Handle_DeviceMatchingCallback(void *inContext, IOReturn inResult, void * inSender, IOHIDDeviceRef inIOHIDDeviceRef);

static void Handle_RemovalCallback(void *inContext, IOReturn inResult, void * inSender, IOHIDDeviceRef inIOHIDDeviceRef);

@interface MiceListener ()

@property (strong) NSMutableArray *handlers;
@property IOHIDManagerRef manager;
@property (nonatomic) IOHIDDeviceRef mainMouse;

- (void)addHandlerForDevice:(IOHIDDeviceRef)device;
- (void)removeHandlerForDevice:(IOHIDDeviceRef)device;

@end

@implementation MiceListener

- (instancetype)init {
    if (self = [super init]) {
        _handlers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self startListening];
}

- (void)addHandlerForDevice:(IOHIDDeviceRef)device
{
    MouseHandler *handler = [[MouseHandler alloc] initForMouse:device];
    [_handlers addObject:handler];
}

- (void)removeHandlerForDevice:(IOHIDDeviceRef)device {
    for (MouseHandler *handler in _handlers) {
        if (handler.device == device) {
            [handler close];
            [_handlers removeObject:handler];
            break;
        }
    }
}

- (void)startListening
{
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

static void Handle_DeviceMatchingCallback(void *inContext, IOReturn inResult, void * inSender, IOHIDDeviceRef inIOHIDDeviceRef)
{
    MiceListener *controller = (__bridge MiceListener *)(inContext);
    if (!controller.mainMouse) {
        controller.mainMouse = inIOHIDDeviceRef;
        IOHIDDeviceClose(inIOHIDDeviceRef, 0);
    }
    else {
        [controller addHandlerForDevice:inIOHIDDeviceRef];
    }
}

static void Handle_RemovalCallback(void *inContext, IOReturn inResult, void * inSender, IOHIDDeviceRef inIOHIDDeviceRef)
{
    MiceListener *controller = (__bridge MiceListener *)(inContext);
    [controller removeHandlerForDevice:inIOHIDDeviceRef];
    if (controller.mainMouse == inIOHIDDeviceRef && controller.handlers.count > 0) {
        MouseHandler *successorMouseHandler = controller.handlers.firstObject;
        [successorMouseHandler close];
        [controller.handlers removeObject:successorMouseHandler];
        IOHIDDeviceClose(successorMouseHandler.device, 0);
        controller.mainMouse = successorMouseHandler.device;
    }
}
