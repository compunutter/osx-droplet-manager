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
    
    _dropletId = [[droplet objectForKey:@"id"] integerValue];
    _name = [droplet objectForKey:@"name"];
    _imageId = [[droplet objectForKey:@"image_id"] integerValue];
    _sizeId = [[droplet objectForKey:@"size_id"] integerValue];
    
    _regionId = [[droplet objectForKey:@"region_id"] integerValue];
    _backupsActive = [[droplet objectForKey:@"backups_active"] boolValue];
    _ipAddress = [droplet objectForKey:@"ip_address"];
    _privateIp = [droplet objectForKey:@"private_ip_address"];
    _locked = [[droplet objectForKey:@"locked"] boolValue];
    _status = [droplet objectForKey:@"status"];
    
    return self;
}

@end
