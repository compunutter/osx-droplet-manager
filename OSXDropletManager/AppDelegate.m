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
        [submenu addItemWithTitle:[NSString stringWithFormat:@"Public IP Addr: %@", d.ipAddress] action:nil keyEquivalent:@""];
        [submenu addItemWithTitle:[NSString stringWithFormat:@"Private IP Addr: %@", ([d.privateIp isEqualTo:[NSNull null]] ? @"N/A" : d.privateIp)] action:nil keyEquivalent:@""];
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

- (IBAction)serverSliderValueChanged:(id)sender { // max 144 (every 5 minutes) = 720 (144 * 5) = 12 hours
    NSInteger noOfMinutes = [sender integerValue] * 5;
    if (noOfMinutes == 0) {
        self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"Disabled."];
    } else if (noOfMinutes < 60) {
        self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%ld minutes", noOfMinutes];
    } else {
        double hours = floor(noOfMinutes / 60);
        if (noOfMinutes - hours * 60 == 0) {
            self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours", hours];
        } else {
            self.checkServerTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours & %.0f minutes", hours, noOfMinutes - (hours * 60)];
        }
    }
}

- (IBAction)pingSliderValueChanged:(id)sender { // max 24 (every 5 minutes) = 120 (24 * 5) = 2 hours
    NSInteger noOfMinutes = [sender integerValue] * 5;
    if (noOfMinutes == 0) {
        self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"Disabled."];
    } else if (noOfMinutes < 60) {
        self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%ld minutes", noOfMinutes];
    } else {
        double hours = floor(noOfMinutes / 60);
        if (noOfMinutes - hours * 60 == 0) {
            self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours", hours];
        } else {
            self.checkPingTimeLabel.stringValue = [NSString stringWithFormat:@"%.0f hours & %.0f minutes", hours, noOfMinutes - (hours * 60)];
        }
    }
}

- (IBAction)saveAndClosePreferncesWindowButtonPushed:(id)sender {
    [self savePreferences];
    [preferencesWindow close];
    [self initialiseWithNewPreferences];
}

- (void)savePreferences {
    [self setVariablesFromPreferences];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble:[self.checkServerTimeSlider doubleValue] * 5],@"DropletsInterval",
                              [NSNumber numberWithDouble:[self.checkPingTimeSlider doubleValue] * 5],@"PingInterval",
                              [NSString stringWithString:[self.ClientIDTextField stringValue]],@"clientID",
                              [NSString stringWithString:[self.APIKeyTextField stringValue]],@"apiKey",
                              nil];
    
    if (![self settingsFileExist]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self getSettingsDirectoryPath] isDirectory:NULL]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[self getSettingsDirectoryPath] withIntermediateDirectories:TRUE attributes:nil error:nil];
        }
        NSLog(@"Wrote settings file: %@",
              [[NSFileManager defaultManager] createFileAtPath:[self getSettingsFilePath] contents:nil attributes:nil]
              ? @"yes" : @"no");
    }
    
    bool success = [settings writeToFile:[self getSettingsFilePath] atomically:YES];
    NSLog(@"Settings file write success: %@", success ? @"yes" : @"no");
}

- (void)loadPreferences {
    if ([self settingsFileExist]) {
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[self getSettingsFilePath]];
        
        [self.checkServerTimeSlider setDoubleValue:[[settings objectForKey:@"DropletsInterval"] doubleValue] / 5];
        [self serverSliderValueChanged:self.checkServerTimeSlider];
        [self.checkPingTimeSlider setDoubleValue:[[settings objectForKey:@"PingInterval"] doubleValue] / 5];
        [self pingSliderValueChanged:self.checkPingTimeSlider];
        
        [self.ClientIDTextField setStringValue:[settings objectForKey:@"clientID"]];
        [self.APIKeyTextField setStringValue:[settings objectForKey:@"apiKey"]];
        //[self.ClientIDTextField setStringValue:@"4k1rbNDkuD5nfgnjdwiEY"];
        //[self.APIKeyTextField setStringValue:@"E--VAlAf9qNIKoKyp77IAEXguCjDOKpLbVJb3KAr"];
        
        [self setVariablesFromPreferences];
    }
}

- (bool)settingsFileExist {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getSettingsFilePath] isDirectory:FALSE];
}

- (NSString *)getSettingsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/OSXDropletManager", [paths objectAtIndex:0]];
}

- (NSString *)getSettingsFilePath {
    return [NSString stringWithFormat:@"%@/settings", [self getSettingsDirectoryPath]];
}

- (void)setVariablesFromPreferences {
    clientId = [self.ClientIDTextField stringValue];
    apiKey = [self.APIKeyTextField stringValue];
    updateDropletInterval = [self.checkServerTimeSlider doubleValue] * 60;
    updatePingInterval = [self.checkPingTimeSlider doubleValue] * 60;
}

- (void)initialiseWithNewPreferences {
    if (!clientId || !apiKey) {
        [self showPreferencesWindow];
    } else {
        apiClient = [[DigitalOceanAPIClient alloc] initWithClientID:@"4k1rbNDkuD5nfgnjdwiEY" andApiKey:@"E--VAlAf9qNIKoKyp77IAEXguCjDOKpLbVJb3KAr"];
        
        // Create timers
        if (updateDropletInterval != 0) {
            serverUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updateDropletInterval target:self selector:@selector(refreshServerList) userInfo:nil repeats:YES];
        } else {
            [serverUpdateTimer invalidate];
        }
        if (updatePingInterval != 0) {
            pingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updatePingInterval target:self selector:@selector(updateServersPing) userInfo:nil repeats:YES];
        } else {
            [pingUpdateTimer invalidate];
        }
        
        [self refreshServerList];
        [self updateServersPing];
    }
}

@end
