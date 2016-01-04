//
//  RestApi.h
//  HuntingCars
//
//  Created by Cédric Wider on 03/10/15.
//  Copyright © 2015 hackZurich. All rights reserved.
//
@interface RestApi : NSObject
@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *token;


- (id) initWithBaseUrl: (NSString*) baseUrl token: (NSString*) token;
- (BOOL) hasValidToken;

- (NSDictionary*) POST: (NSString*) query data: (NSString*) data error: (NSError **)error;
- (nullable id) GET: (NSString*) query where: (nullable NSDictionary*) filterWhereDictionary error: (NSError **)error;

@end
