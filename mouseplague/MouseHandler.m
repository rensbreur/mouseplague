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
#import "MouseHIDReportReader.h"
#import "MouseClick.h"
#import "MouseWindowController.h"

#define ReportBufferLength 16

static void Handle_InputReportCallback(void * _Nullable context, IOReturn result, void * _Nullable sender, IOHIDReportType type, uint32_t reportID, uint8_t *report, CFIndex reportLength, uint64_t timeStamp);

@interface MouseHandler () {
@public
    uint8_t *report_buffer;

    bool clicked;
    uint64_t last_timestamp;
}

@property (nonatomic, strong) MouseHIDReportReader *reportReader;
@property (nonatomic, strong) MouseWindowController *mouseWindowController;

@end

@implementation MouseHandler

- (id)initForMouse:(IOHIDDeviceRef)device {
    if (self = [super init]) {
        _device = device;

        CFDataRef descriptor = IOHIDDeviceGetProperty(device, CFSTR(kIOHIDReportDescriptorKey));
        const uint8_t *descr_ptr = CFDataGetBytePtr(descriptor);
        self.reportReader = [[MouseHIDReportReader alloc] init];
        [self.reportReader setDescriptor:descr_ptr len:(int)CFDataGetLength(descriptor)];

        report_buffer = malloc(ReportBufferLength);

        IOHIDDeviceRegisterInputReportWithTimeStampCallback(device, report_buffer, ReportBufferLength, Handle_InputReportCallback, (__bridge void *)(self));

        self.mouseWindowController = [[MouseWindowController alloc] init];
        [self.mouseWindowController showPointerWindow];

    }
    return self;
}

- (void)mouseDidClick {
    NSPoint clickPoint = NSMakePoint(self.mouseWindowController->currentX, self.mouseWindowController->currentY + 25);
    CGPoint point = [NSScreen pointFromCocoa:clickPoint];
    [MouseClick performClickAtPoint:point];
}

- (void)dealloc
{
    [self.mouseWindowController close];
}

@end

static void Handle_InputReportCallback(void * _Nullable context, IOReturn result, void * _Nullable sender, IOHIDReportType type, uint32_t reportID, uint8_t *report, CFIndex reportLength, uint64_t timeStamp)
{
    MouseHandler *mouseController = (__bridge MouseHandler *)(context);

    float x = [mouseController.reportReader xInReport:report len:(int)reportLength];
    float y = [mouseController.reportReader yInReport:report len:(int)reportLength];
    x = x > 128 ? (x - 256) : x;
    y = y > 128 ? (y - 256) : y;

    uint64_t dt = timeStamp - mouseController->last_timestamp;
    mouseController -> last_timestamp = timeStamp;

    float v = sqrtf( ( ((pow(x, 2) + pow(y, 2)) * 300) / (float)(dt) ));

    x = x/3.0f + x * v;
    y = y/3.0f + y * v;

    [mouseController.mouseWindowController moveToX:x Y:y];

    if ([mouseController.reportReader clickInReport:report len:(int)reportLength]) {
        if (!mouseController->clicked) {
            mouseController->clicked = true;
            [mouseController mouseDidClick];
        }
    }
    else {
        mouseController->clicked = false;
    }
}
