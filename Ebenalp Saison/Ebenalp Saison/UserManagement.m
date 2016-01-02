//
//  UserManagement.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 02/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "UserManagement.h"
#import "RestApi.h"
#import "Const.h"

@implementation UserManagement

+ (UserManagement*)instance {
    static UserManagement *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}



- (id) init {
    self.API = [[RestApi alloc] initWithBaseUrl: REST_API_BASE_URL token: nil];
    return self;
}

- (void)setToken: (NSString*) token {
    self.API = [[RestApi alloc] initWithBaseUrl: REST_API_BASE_URL token: token];
}

- (BOOL)authenticate: (NSString*)user password: (NSString*) password {
    
    NSError *error = nil;
    
    NSDictionary* loginResult =
        [self.API POST: @"/Users/login"
          data: [
                 NSString stringWithFormat: @"{ \"username\": \"%@\", \"password\": \"%@\"}", user, password] error: &error];
    if (error) {
        return FALSE;
    } else {
        [self setToken: [loginResult valueForKey: @"id"]];
        self.userId = [loginResult valueForKey: @"userId"];
        return TRUE;
    }
}


/* 
 {
 "realm": null,
 "username": "lolo8304@gmail.com",
 "credentials": null,
 "challenges": null,
 "email": "lolo8304@gmail.com",
 "emailVerified": true,
 "verificationToken": "me2",
 "status": "verified",
 "created": "2015-12-31T00:00:00.000Z",
 "lastUpdated": "2016-01-01T00:00:00.000Z",
 "id": 1
 }
 
 */

- (NSDictionary*) getUser {
    NSError *error = nil;
    
    NSDictionary* userResults = [self.API GET: [NSString stringWithFormat: @"/Users/%@", self.userId ] error: &error];
    
    if (error) {
        return nil;
    } else {
        return userResults;
    }
}

/*
 {
 "category": "Erwachsener",
 "dateOfBirth": "1969-04-13T00:00:00.000Z",
 "firstname": "Lorenz",
 "name": "Hanggi",
 "street": null,
 "zip": null,
 "city": null,
 "userId": 1,
 "id": 1,
 "season": "2015-2016",
 "device_alias": null,
 "email": "lolo8304@gmai.com",
 "userid": 1
 }
 */

- (NSDictionary*) getCustomer {
    NSError *error = nil;
    
    NSDictionary* userResults = [self.API GET: [NSString stringWithFormat: @"/customers/%@", self.userId ] error: &error];
    
    if (error) {
        return nil;
    } else {
        return userResults;
    }
}



@end
