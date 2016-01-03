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
/* http://cocoadocs.org/docsets/SSKeychain/1.3.1/ */
#import "SSKeychain.h"


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
    self.userId = nil;
    self.userData = nil;
    self.customerData = nil;
    return self;
}

- (void)setToken: (NSString*) token {
    if (token) {
        NSRange range = [token rangeOfString: @"$"];
        if (range.location != NSNotFound) {
            NSString* realToken = [token substringFromIndex: range.location + 1];
            NSString* userId = [token substringToIndex: range.location];
            self.userId = userId;
            self.API = [[RestApi alloc] initWithBaseUrl: REST_API_BASE_URL token: realToken];
        }
    } else {
        [self init];
    }
}

- (BOOL)authenticate: (NSString*)user password: (NSString*) password {
    NSError *error = nil;
    NSDictionary* loginResult =
        [self.API POST: @"/Users/login"
          data: [
                 NSString stringWithFormat: @"{ \"username\": \"%@\", \"password\": \"%@\"}", user, password] error: &error];
    if (error) {
        [SSKeychain deletePasswordForService: KEYCHAIN_SERVICE_NAME account: user];
        return FALSE;
    } else {
        NSString* token = [loginResult valueForKey: @"id"];
        self.userId = [loginResult valueForKey: @"userId"];
        NSString* combinedToken = [NSString stringWithFormat: @"%@$%@", self.userId, token ];
        [self setToken: combinedToken];
        [SSKeychain setPassword: combinedToken forService: KEYCHAIN_SERVICE_NAME account: user];
        return TRUE;
    }
}


- (void)logout {
    if ([self hasValidToken]) {
        [self logoutUser];
        NSString* keyStoreUser = [self getKeyStoreUser];
        if (keyStoreUser) {
            [SSKeychain deletePasswordForService: KEYCHAIN_SERVICE_NAME account: keyStoreUser];
        }
    }
    [self setToken: nil];
}

- (BOOL)authenticateKeyStoreToken {
    if (![self hasValidToken]) {
        NSString* keyStoreUser = [self getKeyStoreUser];
        if ([self setValidToken: keyStoreUser]) {
            if ([self getUser]) {
                return TRUE;
            } else {
                [self logout];
                return FALSE;
            }
        }
        return FALSE;
    } else {
        return TRUE;
    }
}

- (BOOL)hasValidToken {
    return [self.API hasValidToken];
}


- (NSString*)getKeyStoreUser {
    NSArray* accounts = [SSKeychain accountsForService: KEYCHAIN_SERVICE_NAME];
    if (accounts) {
        if ([accounts count] == 1) {
            NSDictionary* account = accounts[0];
            return [account valueForKey: kSSKeychainAccountKey];
        } else if ([accounts count] > 1) {
            NSLog(@"found more than 1 keystore account. Will delete them");
            for (NSDictionary* account in accounts) {
                NSString* userId =[account valueForKey: kSSKeychainAccountKey];
                [SSKeychain deletePasswordForService: KEYCHAIN_SERVICE_NAME account: userId];
                NSLog(@"delete keychain for user=%@", userId);
            }
        }
    }
    return nil;
}


- (BOOL)setValidToken: (NSString*) user {
    if (user) {
        NSString* token = [SSKeychain passwordForService: KEYCHAIN_SERVICE_NAME account: user];
        if (token) {
            [self setToken: token];
            return TRUE;
        }
    } else {
        [self setToken: nil];
    }
    return FALSE;
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
        self.userData = nil;
        return nil;
    } else {
        self.userData = userResults;
        return userResults;
    }
}

- (BOOL) logoutUser {
    NSError *error = nil;
    [self.API GET: [NSString stringWithFormat: @"/Users/%@/logoff", self.userId ] error: &error];
    return !error;
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
        self.customerData = nil;
        return nil;
    } else {
        self.customerData = userResults;
        return userResults;
    }
}



@end
