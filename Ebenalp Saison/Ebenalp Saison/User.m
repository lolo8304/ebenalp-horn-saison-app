//
//  User.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "User.h"

@implementation User

-(long) id {
    return [self long: @"id"];
}

-(NSString*) username {
    return [self s: @"username"];
}
-(NSString*) email {
    return [self s: @"email"];
}
-(BOOL) emailVerified {
    return [self b: @"emailVerified"];
}
-(NSString*) verificationToken {
    return [self s: @"verificationToken"];
}
-(NSDate*) created {
    return [self date: @"created"];
}
-(NSDate*) lastUpdated {
    return [self date: @"lastUpdated"];
}


@end
