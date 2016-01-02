//
//  UserManagement.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 02/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestApi.h"

@interface UserManagement : NSObject

@property (strong, nonatomic) RestApi* API;
@property (strong, nonatomic) NSString* userId;

+ (UserManagement*) instance; //singleton
- (id) init;
- (BOOL)authenticate: (NSString*)user password: (NSString*) password;
- (NSDictionary*) getUser;
- (NSDictionary*) getCustomer;

@end