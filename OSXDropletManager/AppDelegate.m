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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // TODO: Get preferences
    updateDropletInterval = 3600;
    updatePingInterval = 900;
    
    // Create menu
    [self createMenu];
    
    // Create status bar item
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    
    [statusItem setHighlightMode:TRUE];
    [statusItem setTitle:@"DM"]; //To be changed to image when available
    [statusItem setMenu:dropletMenu];
    
    // Initialise API client
    apiClient = [[DigitalOceanAPIClient alloc] initWithClientID:@"4k1rbNDkuD5nfgnjdwiEY" andApiKey:@"E--VAlAf9qNIKoKyp77IAEXguCjDOKpLbVJb3KAr"];
    
    // Create timers
    serverUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updateDropletInterval target:self selector:@selector(refreshServerList) userInfo:nil repeats:YES];
    pingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updatePingInterval target:self selector:@selector(updateServersPing) userInfo:nil repeats:YES];
    
    [self refreshServerList];
    [self updateServersPing];
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

- (void)showPreferencesWindows
{
    [self.preferencesWindow makeKeyAndOrderFront:self];
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
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(showPreferencesWindows) keyEquivalent:@""]];
    [dropletMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitApplication) keyEquivalent:@""]];
}

@end
