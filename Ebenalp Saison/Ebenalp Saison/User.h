//
//  User.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "DAO.h"

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

@interface User : DAO


-(int) id;
-(NSString*) username;
-(NSString*) email;
-(BOOL) emailVerified;
-(NSString*) verificationToken;
-(NSDate*) created;
-(NSDate*) lastUpdated;



@end
