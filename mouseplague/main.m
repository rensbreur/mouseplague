//
//  main.m
//  mouseplague
//
//  Created by Rens Breur on 12.12.19.
//  Copyright © 2019 Rens Breur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MouseDeviceListener.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *application = [NSApplication sharedApplication];
        MouseDeviceListener *mouseDeviceListener = [[MouseDeviceListener alloc] init];
        application.delegate = mouseDeviceListener;
        [application run];
    }
    return EXIT_SUCCESS;
}
