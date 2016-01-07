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
#import "ModelRepository.h"
#import "AppDelegate.h"

#define EMPTY_TOKEN @"0$0"

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
    self.userId = 0;
    self.user = nil;
    self.customer = nil;
    return self;
}

- (void)setToken: (NSString*) token {
    if (token) {
        NSRange range = [token rangeOfString: @"$"];
        if (range.location != NSNotFound) {
            NSString* realToken = [token substringFromIndex: range.location + 1];
            NSString* userId = [token substringToIndex: range.location];
            self.userId = [userId intValue];
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
        [self cleanToken: user];
        return FALSE;
    } else {
        NSString* token = [loginResult valueForKey: @"id"];
        self.userId = [[loginResult valueForKey: @"userId"] intValue];
        NSString* combinedToken = [NSString stringWithFormat: @"%i$%@", self.userId, token ];
        [self setToken: combinedToken];
        [SSKeychain setPassword: combinedToken forService: KEYCHAIN_SERVICE_NAME account: user];
        if ([self user]) {
            AppDelegate* app = [[UIApplication sharedApplication] delegate];
            [app setAlias: [[self user] email]];
            return TRUE;
        } else {
            return FALSE;
        }
    }
}


- (void)logout {
    if ([self hasValidToken]) {
        [self logoutUser];
        [self cleanToken: [self getKeyStoreUser]];
    }
    AppDelegate* app = [[UIApplication sharedApplication] delegate]; [app removeAlias];
    [self setToken: nil];
}

- (BOOL)authenticateKeyStoreToken {
    if (![self hasValidToken]) {
        NSString* keyStoreUser = [self getKeyStoreUser];
        if ([self setValidToken: keyStoreUser]) {
            if ([self user]) {
                AppDelegate* app = [[UIApplication sharedApplication] delegate];
                [app setAlias: [[self user] email]];
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
        if (token && ![EMPTY_TOKEN isEqualToString: token]) {
            [self setToken: token];
            return TRUE;
        }
    } else {
        [self setToken: nil];
    }
    return FALSE;
}
- (void)cleanToken: (NSString*) user {
    if (user) {
        [SSKeychain setPassword: EMPTY_TOKEN forService: KEYCHAIN_SERVICE_NAME account: user];
    }
    [self setToken: nil];
}

- (BOOL) logoutUser {
    NSError *error = nil;
    [self.API GET: [NSString stringWithFormat: @"/Users/%i/logoff", self.userId ] where: nil error: &error];
    return !error;
}


- (User*) user {
    if (_user) { return _user; }
    ModelRepository* repository = [[ModelRepository alloc] init: @"Users" className: @"User"];
    self.user = [repository modelWithId: self.userId];
    return _user;
}
- (Customer*) customer {
    if (_customer) {return _customer; }
    ModelRepository* repository = [[ModelRepository alloc] init: @"customers" className: @"Customer"];
    self.customer = [repository modelWithId: self.userId];
    return _customer;
}


- (BOOL)stateRegistered {
    return ([self user] && ![[self user] emailVerified]
            && ![self customer]);
}
- (BOOL)stateVerified {
    return ([self user] && [[self user] emailVerified]
            && ![self customer]);
}
- (BOOL)stateActivated {
    return ([self user] && [[self user] emailVerified]
            && [self customer] && [[[self customer] season] isEqualToString: CURRENT_SEASON]);
}
- (BOOL)stateOutdated {
    return ([self user] && [[self user] emailVerified]
            && [self customer] && ![[[self customer] season] isEqualToString: CURRENT_SEASON]);
}

- (NSString*) stateAsString {
    if ([self stateRegistered]) return @"registriert";
    if ([self stateVerified]) return @"verifiziert";
    if ([self stateActivated]) return @"aktiviert";
    return @"veraltet";
}

- (void)refreshState {
    self.user = nil;
    self.customer = nil;
    [self user];
    [self customer];
}


@end
