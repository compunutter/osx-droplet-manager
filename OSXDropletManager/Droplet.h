//
//  Droplet.h
//  OSXDropletManager
//
//  Created by George Complin on 31/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Droplet : NSObject

- (id)initWithArray:(NSDictionary *)droplet;

@property (readonly) NSInteger dropletId;
@property (readonly) NSString *name;
@property (readonly) NSInteger imageId;
@property (readonly) NSInteger sizeId;
@property (readonly) NSInteger regionId;
@property (readonly) BOOL backupsActive;
@property (readonly) NSString *ipAddress;
@property (readonly) BOOL locked;
@property (readonly) BOOL status;

@end
