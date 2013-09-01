//
//  Droplet.m
//  OSXDropletManager
//
//  Created by George Complin on 31/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import "Droplet.h"

@implementation Droplet

- (id)initWithArray:(NSDictionary *)droplet
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _dropletId = (NSInteger)[droplet objectForKey:@"id"];
    _name = (NSString *)[droplet objectForKey:@"name"];
    _imageId = (NSInteger)[droplet objectForKey:@"image_id"];
    _sizeId = (NSInteger)[droplet objectForKey:@"size_id"];
    
    _regionId = (NSInteger)[droplet objectForKey:@"region_id"];
    _backupsActive = (BOOL)[droplet objectForKey:@"backups_active"];
    _ipAddress = (NSString *)[droplet objectForKey:@"ip_address"];
    _locked = (BOOL)[droplet objectForKey:@"locked"];
    _status = (BOOL)[droplet objectForKey:@"status"];
    
    return self;
}

@end
