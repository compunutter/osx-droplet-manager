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
    
    _dropletId = [(NSString *)[droplet objectForKey:@"id"] integerValue];
    _name = (NSString *)[droplet objectForKey:@"name"];
    _imageId = [(NSString *)[droplet objectForKey:@"image_id"] integerValue];
    _sizeId = [(NSString *)[droplet objectForKey:@"size_id"] integerValue];
    
    _regionId = [(NSString *)[droplet objectForKey:@"region_id"] integerValue];
    _backupsActive = [(NSString *)[droplet objectForKey:@"backups_active"] boolValue];
    _ipAddress = (NSString *)[droplet objectForKey:@"ip_address"];
    _locked = [(NSString *)[droplet objectForKey:@"locked"] boolValue];
    _status = (NSString *)[droplet objectForKey:@"status"];
    
    return self;
}

@end
