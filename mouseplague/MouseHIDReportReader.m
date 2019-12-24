//
//  MouseHIDReportReader.m
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import "MouseHIDReportReader.h"

#define HIDDescriptorCount 0x95
#define HIDDescriptorSize 0x75
#define HIDDescriptorSend 0x81
#define HIDDescriptorUsage 0x09
#define HIDDescriptorReportID 0x85

#define HIDUsageX 0x30
#define HIDUsageY 0x31
#define HIDUsageMouse 0x01

#define ByteSize 8

static int offsetInReport(const uint8_t *ptr, int descriptor_len, uint8_t usage);

@interface MouseHIDReportReader () {
    int x_report_offset;
    int y_report_offset;
    int click_offset;
}

@end

@implementation MouseHIDReportReader

- (void)setDescriptor:(const uint8_t *)ptr len:(int)len
{
    x_report_offset = offsetInReport(ptr, len, HIDUsageX) / ByteSize;
    y_report_offset = offsetInReport(ptr, len, HIDUsageY) / ByteSize;
    click_offset = offsetInReport(ptr, len, HIDUsageMouse) / ByteSize;
}

- (int)xInReport:(const uint8_t *)ptr len:(int)len {
    return ptr[x_report_offset];
}

- (int)yInReport:(const uint8_t *)ptr len:(int)len {
    return ptr[y_report_offset];
}

- (BOOL)clickInReport:(const uint8_t *)ptr len:(int)len {
    return ptr[click_offset];
}

@end

static int offsetInReport(const uint8_t *ptr, int descriptor_len, uint8_t usage)
{
    int offset = 0;

    bool found = false;

    int size = 0;
    int count = 0;
    int index = 0;

    for (int i = 0; i < descriptor_len; i += 2) {

        if (ptr[i] == HIDDescriptorSize)
            size = ptr[i+1];
        if (ptr[i] == HIDDescriptorCount)
            count = ptr[i+1];

        if (ptr[i] == HIDDescriptorUsage) {
            if (ptr[i+1] == usage) {
                found = true;
            }
            else if (!found) {
                index ++;
            }
        }

        if (ptr[i] == HIDDescriptorReportID) {
            offset += 8;
        }

        if (ptr[i] == HIDDescriptorSend) {
            if (found) {
                return offset + index * size;
            }
            index = 0;
            offset += size * count;
            size = 0;
            count = 0;
        }

    }
    return -1;
}
