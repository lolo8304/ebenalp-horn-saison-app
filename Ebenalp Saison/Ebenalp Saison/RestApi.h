//
//  RestApi.h
//  HuntingCars
//
//  Created by Cédric Wider on 03/10/15.
//  Copyright © 2015 hackZurich. All rights reserved.
//
@interface RestApi : NSObject
@property (strong, nonatomic, nullable) NSString *baseUrl;
@property (strong, nonatomic, nullable) NSString *token;


- (nonnull id) initWithBaseUrl: (nonnull NSString*) baseUrl token: (nonnull NSString*) token;
- (BOOL) hasValidToken;

- (nullable NSDictionary*) POST: (nonnull NSString*) query data: (nullable NSString*) data error: (NSError **)error;
- (nullable id) GET: (NSString*) query where: (nullable NSDictionary*) filterWhereDictionary error: (NSError **)error;

@end
