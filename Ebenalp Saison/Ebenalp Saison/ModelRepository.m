//
//  ModelRepository.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 03/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "ModelRepository.h"
#import "DAO.h"

@implementation ModelRepository

-(id) init: (NSString*) modelName className: (NSString*) className {
    self = [super init];
    if (self) {
        self.modelName = modelName;
        self.className = className;
        self.access = [UserManagement instance];
    }
    return self;
}

-(id) createInstance: (NSDictionary*) dict {
    return [[NSClassFromString(self.className) alloc] initWithDictionary: dict];
}

-(DAO*) modelWithId: (int) id {
    NSError *error = nil;
    NSDictionary* newObject =[self.access.API GET: [NSString stringWithFormat: @"/%@/%i", self.modelName, id ] where: nil error: &error];
    DAO* object = [self createInstance: newObject];
    if (error) {
        return nil;
    } else {
        return object;
    }
}

-(DAO*) modelWithDictionary: (NSDictionary*) filterWhereDictionary {
    NSError *error = nil;
    DAO* object = [self createInstance: [self.access.API GET: [NSString stringWithFormat: @"/%@", self.modelName] where: filterWhereDictionary error: &error]];
    if (error) {
        return nil;
    } else {
        return object;
    }
}


@end
