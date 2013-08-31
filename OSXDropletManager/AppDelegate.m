//
//  AppDelegate.m
//  OSXDropletManager
//
//  Created by George Complin on 30/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create menu
    [self createMenu];
    
    // Create status bar item
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    
    [statusItem setHighlightMode:TRUE];
    [statusItem setTitle:@"DM"]; //To be change to image when avail
    [statusItem setMenu:dropletMenu];
}

- (void) createMenu
{
    dropletMenu = [[NSMenu alloc] initWithTitle:@"DropletMenu"];
    [self resetMenu];
}

- (void)resetMenu
{
    [dropletMenu removeAllItems];
    
    NSMenuItem *dropletsItem = [[NSMenuItem alloc] initWithTitle:@"No droplets available" action:NULL keyEquivalent:@""];
    
    NSMenuItem *sep = [NSMenuItem separatorItem];
    
    NSMenuItem *preferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:NULL keyEquivalent:@""];
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:NULL keyEquivalent:@""];
    
    [dropletMenu addItem:dropletsItem];
    [dropletMenu addItem:sep];
    [dropletMenu addItem:preferencesItem];
    [dropletMenu addItem:quitItem];
}

@end
