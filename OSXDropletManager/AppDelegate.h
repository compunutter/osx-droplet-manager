//
//  AppDelegate.h
//  OSXDropletManager
//
//  Created by George Complin on 30/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DigitalOceanAPIClient.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    // Timer for periodically updating the menu list of servers
    NSTimer *serverUpdateTimer;
    // Timer for checking the servers are still up
    NSTimer *pingUpdateTimer;
    //
    double updateDropletInterval;
    //
    double updatePingInterval;
    // Status bar item
    NSStatusItem *statusItem;
    //
    NSMenu *dropletMenu;
    //
    DigitalOceanAPIClient *apiClient;
    //
    NSMutableArray *droplets;
}

@property (assign) IBOutlet NSWindow *preferencesWindow;

@end
