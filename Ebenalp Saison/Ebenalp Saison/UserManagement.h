//
//  UserManagement.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 02/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestApi.h"
#import "User.h"
#import "Customer.h"


@interface UserManagement : NSObject

@property (strong, nonatomic) RestApi* API;
@property (nonatomic) int userId;
@property (nonatomic) NSString* deviceId;

@property (strong, nonatomic) User* user;
@property (strong, nonatomic) Customer* customer;

+ (UserManagement*) instance; //singleton
- (id) init;


/* authentication */
- (BOOL)authenticate: (NSString*)user password: (NSString*) password;
- (NSString*)getKeyStoreUser;
- (BOOL)authenticateKeyStoreToken;
- (BOOL)hasValidToken;

/* logout */
- (void)logout;

/* registration states 
 
 registered = email registered + but activation mail not verified
 verified = email registered + verified, but not an activated customer, try-before-you-buy, sees points but no vouchers
 activated = registered + activated Saison Abo, points + vouchers
 outdated = registered + activated, but season outdated
 
 */

- (BOOL)stateRegistered;
- (BOOL)stateVerified;
- (BOOL)stateActivated;
- (BOOL)stateOutdated;
- (NSString*) stateAsString;
- (void)refreshState;

@end
