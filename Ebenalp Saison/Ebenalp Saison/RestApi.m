//
//  RestApi.m
//  HuntingCars
//
//  Created by Cédric Wider on 03/10/15.
//  Copyright © 2015 hackZurich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestApi.h"

@implementation RestApi

-(id) initWithBaseUrl: (NSString*) baseUrl token: (NSString*) token
{
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
        self.token = token;
    }
    return self;
}


/*example
 curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{
 \"username\": \"lolo8304@gmail.com\",
 \"password\": \"me2\"
 }" "http://188.165.249.71:3000/api/Users/login"
 
 */

- (NSDictionary*) POST: (NSString*) query data: (NSString*) data error: (NSError **)error {
    NSDictionary *responseBody = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl,query];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    
    // Specify that it will be a POST request
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Convert your data and set your request's HTTPBody property
    NSData *requestBodyData = [data dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: error];
    responseBody = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    return responseBody;
}

- (NSDictionary*) GET: (NSString*) query error: (NSError **)error {
    NSDictionary *responseBody = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl,query];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: error];
    responseBody = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    return responseBody;
}

/*
-(NSDictionary*) GET: (NSString*) query error: (NSError **)error{
    NSDictionary *responseBody = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", self.baseUrl,query];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: error];
    responseBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return responseBody;
}
*/

@end