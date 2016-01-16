//
//  ModelRepository.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserManagement.h"

@interface ModelRepository : NSObject
@property (strong, nonatomic) NSString* modelName;
@property (strong, nonatomic) NSString* className;
@property (strong, nonatomic) UserManagement* access;

-(id) init: (NSString*) modelName className: (NSString*) className;
-(id) modelWithId: (long) id;
-(DAO*) modelWithId: (long) id prefix: (NSString*) prefix;
-(NSArray*) listWithId: (long) id prefix: (NSString*) prefix;

-(DAO*) modelWithDictionary: (NSDictionary*) filterWhereDictionary;
-(NSArray*) listWithDictionary: (NSDictionary*) filterWhereDictionary;



@end
