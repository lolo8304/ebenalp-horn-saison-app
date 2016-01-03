//
//  RestApi.h
//  HuntingCars
//
//  Created by Cédric Wider on 03/10/15.
//  Copyright © 2015 hackZurich. All rights reserved.
//

#ifndef RestApi_h
#define RestApi_h

@interface RestApi : NSObject
@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *token;


- (id) initWithBaseUrl: (NSString*) baseUrl token: (NSString*) token;
- (BOOL) hasValidToken;

- (NSDictionary*) POST: (NSString*) query data: (NSString*) data error: (NSError **)error;
- (NSDictionary*) GET: (NSString*) query error: (NSError **)error;

@end

#endif /* RestApi_h */
