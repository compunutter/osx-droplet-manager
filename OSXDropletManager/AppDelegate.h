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
    NSString *clientId;
    NSString *apiKey;
    //
    //
    DigitalOceanAPIClient *apiClient;
    //
    NSMutableArray *droplets;
}

@property (assign) IBOutlet NSWindow *preferencesWindow;
@property (weak) IBOutlet NSTextField *checkServerTimeLabel;
@property (weak) IBOutlet NSTextField *checkPingTimeLabel;
@property (weak) IBOutlet NSSlider *checkPingTimeSlider;
@property (weak) IBOutlet NSTextField *ClientIDTextField;
@property (weak) IBOutlet NSTextField *APIKeyTextField;
@property (weak) IBOutlet NSSlider *checkServerTimeSlider;

- (IBAction)serverSliderValueChanged:(id)sender;
- (IBAction)pingSliderValueChanged:(id)sender;
- (IBAction)saveAndClosePreferncesWindowButtonPushed:(id)sender;

@end
