//
//  DigitalOceanAPIClient.m
//  OSXDropletManager
//
//  Created by George Complin on 31/08/2013.
//  Copyright (c) 2013 George Complin. All rights reserved.
//

#import "DigitalOceanAPIClient.h"
#import "Droplet.h"

@implementation DigitalOceanAPIClient

// Private properties
NSString *_clientId;
NSString *_apiKey;
NSString *const _apiUrl = @"https://api.digitalocean.com";

// Methods
- (id)initWithClientID:(NSString *)clientId andApiKey:(NSString *)apiKey
{
    self = [super init];
    
    if(self) {
        NSLog(@"client ID: %@, API Key: %@", clientId, apiKey);
        
        _clientId = clientId;
        _apiKey = apiKey;
    }
    
    return(self);
}

- (NSDictionary*)getDataFromService:(NSString*)action
{
    // Construct our URL for request
    NSString *url = [_apiUrl stringByAppendingFormat:@"/%@", action];
    url = [url rangeOfString:@"?"].location == NSNotFound ? [url stringByAppendingString:@"?"] : [url stringByAppendingString:@"&"];
    NSURL *apiURL = [NSURL URLWithString:[url stringByAppendingFormat:@"client_id=%@&api_key=%@", _clientId, _apiKey]];
    
    NSLog(@"%@", apiURL); // Check the URL created is correct
    
    // Make the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:apiURL];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    // Any errors?
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", _apiUrl, (long)[responseCode statusCode]);
        return nil;
    }
    
    // Return the response
    return [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:nil];
}

// Request methods //
// Droplets
-(NSMutableArray*)getDroplets
{
    NSDictionary *response = [self getDataFromService:@"droplets/"];
    
    if ([[response objectForKey:@"status"] isEqual: @"OK"])
    {
        NSMutableArray *droplets = [NSMutableArray new];
        for (NSDictionary *d in [response objectForKey:@"droplets"])
        {
            Droplet *droplet = [[Droplet alloc] initWithArray:d];
            [droplets addObject:droplet];
        }
        return droplets;
    } else {
        // TODO: display error message
        return nil;
    }
}

@end
