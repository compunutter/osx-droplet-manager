//
//  DigitalOceanAPIClient.h
//  OSXDropletManager
//
//  Created by George Complin on 31/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DigitalOceanAPIClient : NSObject

- (id)initWithClientID:(NSString*)clientId andApiKey:(NSString*)apiKey;

// Requests //
// Droplets
- (NSMutableArray *)getDroplets;

@end
