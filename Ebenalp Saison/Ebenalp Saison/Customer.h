//
//  Customer.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "DAO.h"

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
 "email": "lolo8304@gmai.com"
 }
 */

@interface Customer : DAO

-(int) id;
-(NSString*) category;
-(NSDate*) dateOfBirth;
-(NSString*) firstname;
-(NSString*) name;
-(NSString*) street;
-(NSString*) zip;
-(NSString*) city;
-(int) userId;
-(NSString*) season;
-(NSString*) device_alias;
-(NSString*) email;

@end
