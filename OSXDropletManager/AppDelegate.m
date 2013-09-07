//
//  AppDelegate.m
//  OSXDropletManager
//
//  Created by George Complin on 30/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import "AppDelegate.h"
#import "DigitalOceanAPIClient.h"
#import "Droplet.h"

@implementation AppDelegate

@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Get and load preferences
    [self loadPreferences];
    
    // Create menu
    [self createMenu];
    
    // Create status bar item
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    
    [statusItem setHighlightMode:TRUE];
    [statusItem setTitle:@"DM"]; //To be changed to image when available
    [statusItem setMenu:dropletMenu];
    
    // Initialise API client
    [self initialiseWithNewPreferences];
}

- (void)updateServersPing
{
    NSLog(@"Ping!");
}

- (void)refreshServerList
{
    // Get the droplets from the API
    droplets = [apiClient getDroplets];
    
    // Clear any existing droplets out of the menu
    NSInteger sepLocation = [dropletMenu indexOfItemWithTitle:@"Refresh"] - 1;
    if (sepLocation != 0)
    {
        for (int i = 0; i <= sepLocation - 1; i++) {
            [dropletMenu removeItemAtIndex:i];
        }
    }
    
    // Add new ones to the menu
    for (Droplet *d in droplets)
    {
        // Submenu
        NSMenu *submenu = [NSMenu new];
        [submenu addItemWithTitle:[NSString stringWithFormat:@"IP Address: %@", d.ipAddress] action:nil keyEquivalent:@""];
        [submenu addItemWithTitle:[NSString stringWithFormat:@"Region: %ld", (long)d.regionId] action:nil keyEquivalent:@""];
        [submenu addItemWithTitle:[NSString stringWithFormat:@"Backups Active: %@", (d.backupsActive) ? @"Yes" : @"No"] action:nil keyEquivalent:@""];
        [submenu addItemWithTitle:[NSString stringWithFormat:@"Status: %@", d.status] action:nil keyEquivalent:@""];
        
        // Main menu
        NSMenuItem *dropletMenuItem = [[NSMenuItem alloc] initWithTitle:d.name action:nil keyEquivalent:@""];
        [dropletMenuItem setSubmenu:submenu];
        
        [dropletMenu insertItem:dropletMenuItem atIndex:0];
    }
}

- (void)showPreferencesWindow
{
    [preferencesWindow makeKeyAndOrderFront:self];
    [preferencesWindow center];
}

- (void)quitApplication
{
    [NSApp terminate:self];
}

- (void)createMenu
{
    dropletMenu = [[NSMenu alloc] initWithTitle:@"DropletMenu"];
    [self resetMenu];
}

- (void)resetMenu
{
    [dropletMenu removeAllItems];
    
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"No droplets available" action:NULL keyEquivalent:@""]];
    
    [dropletMenu addItem:[NSMenuItem separatorItem]];
    
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Refresh" action:@selector(refreshServerList) keyEquivalent:@""]];
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(showPreferencesWindow) keyEquivalent:@""]];
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitApplication) keyEquivalent:@""]];
}

////////////////////////
// Prefernces Window //
//////////////////////

- (IBAction)serverSliderValueChanged:(id)sender { // max 720 = 12 hours
    NSInteger val = [sender integerValue];
    if (val < 60) {
        self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%ld minutes", [sender integerValue]];
    } else {
        double hours = floor(val / 60);
        if (val - hours * 60 == 0) {
            self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours", hours];
        } else {
            self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours & %.0f minutes", hours, val - (hours * 60)];
        }
    }
}

- (IBAction)pingSliderValueChanged:(id)sender { // max 120 = 2 hours
    NSInteger val = [sender integerValue];
    if (val < 60) {
        self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%ld minutes", [sender integerValue]];
    } else {
        double hours = floor(val / 60);
        if (val - hours * 60 == 0) {
            self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours", hours];
        } else {
            self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours & %.0f minutes", hours, val - (hours * 60)];
        }
    }
}

- (IBAction)saveAndClosePreferncesWindowButtonPushed:(id)sender {
    [self savePreferences];
    [preferencesWindow close];
}

- (void)savePreferences {
    [self setVariablesFromPreferences];
    
    //TODO: save to file
}

- (void)loadPreferences {
    //TODO: get preferences from file
    
    [self.checkServerTimeSlider setDoubleValue:60];
    [self serverSliderValueChanged:self.checkServerTimeSlider];
    [self.checkPingTimeSlider setDoubleValue:15];
    [self pingSliderValueChanged:self.checkPingTimeSlider];
    
    [self.ClientIDTextField setStringValue:@"4k1rbNDkuD5nfgnjdwiEY"];
    [self.APIKeyTextField setStringValue:@"E--VAlAf9qNIKoKyp77IAEXguCjDOKpLbVJb3KAr"];
    
    [self setVariablesFromPreferences];
}

- (void)setVariablesFromPreferences {
    clientId = [self.ClientIDTextField stringValue];
    apiKey = [self.APIKeyTextField stringValue];
    updateDropletInterval = [self.checkServerTimeSlider doubleValue];
    updatePingInterval = [self.checkPingTimeSlider doubleValue];
}

- (void)initialiseWithNewPreferences {
    if (!clientId || !apiKey) {
        [self showPreferencesWindow];
    } else {
        apiClient = [[DigitalOceanAPIClient alloc] initWithClientID:@"4k1rbNDkuD5nfgnjdwiEY" andApiKey:@"E--VAlAf9qNIKoKyp77IAEXguCjDOKpLbVJb3KAr"];
        
        // Create timers
        serverUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updateDropletInterval target:self selector:@selector(refreshServerList) userInfo:nil repeats:YES];
        pingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updatePingInterval target:self selector:@selector(updateServersPing) userInfo:nil repeats:YES];
        
        [self refreshServerList];
        [self updateServersPing];
    }
}

@end
