//
//  MouseHIDReportReader.h
//  mouseplague
//
//  Created by Rens Breur on 24.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MouseHIDReportReader : NSObject

- (void)setDescriptor:(const uint8_t *)ptr len:(int)len;

- (int)xInReport:(const uint8_t *)ptr len:(int)len;
- (int)yInReport:(const uint8_t *)ptr len:(int)len;
- (BOOL)clickInReport:(const uint8_t *)ptr len:(int)len;

@end

NS_ASSUME_NONNULL_END
