//
//  Customer.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "Customer.h"

@implementation Customer

-(int) id {
    return [self int: @"id"];
}

-(NSString*) category {
    return [self s: @"category"];
}
-(NSDate*) dateOfBirth {
    return [self date: @"dateOfBirth"];
}
-(NSString*) firstname {
    return [self s: @"firstname"];
}
-(NSString*) name {
    return [self s: @"name"];
}
-(NSString*) street {
    return [self s: @"street"];
}
-(NSString*) zip {
    return [self s: @"zip"];
}
-(NSString*) city {
    return [self s: @"city"];
}
-(int) userId {
    return [self int: @"userId"];
}
-(NSString*) season {
    return [self s: @"season"];
}
-(NSString*) device_alias {
    return [self s: @"device_alias"];
}
-(NSString*) email {
    return [self s: @"email"];
}

@end
