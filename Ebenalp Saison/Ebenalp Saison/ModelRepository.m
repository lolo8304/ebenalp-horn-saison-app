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
-(id) createInstances: (NSArray*) listOfDict {
    NSMutableArray* newArray = [NSMutableArray array];
    if (listOfDict) {
        for (NSDictionary* dict in listOfDict) {
            [newArray addObject: [self createInstance: dict]];
        }
    }
    return newArray;
}

-(DAO*) modelWithId: (long) id {
    NSError *error = nil;
    NSDictionary* newObject =[self.access.API GET: [NSString stringWithFormat: @"/%@/%i", self.modelName, id ] where: nil error: &error];
    DAO* object = [self createInstance: newObject];
    if (error) {
        return nil;
    } else {
        return object;
    }
}
-(DAO*) modelWithId: (long) id prefix: (NSString*) prefix {
    NSError *error = nil;
    NSDictionary* newObject =[self.access.API GET: [NSString stringWithFormat: @"/%@/%i/%@", prefix, id, self.modelName ] where: nil error: &error];
    DAO* object = [self createInstance: newObject];
    if (error) {
        return nil;
    } else {
        return object;
    }
}

-(NSArray*) listWithId: (long) id prefix: (NSString*) prefix {
    NSError *error = nil;
    NSArray* newObject =[self.access.API GET: [NSString stringWithFormat: @"/%@/%i/%@", prefix, id, self.modelName ] where: nil error: &error];
    NSArray* list = [self createInstances: newObject];
    if (error) {
        return nil;
    } else {
        return list;
    }
}


-(DAO*) modelWithDictionary: (NSDictionary*) filterWhereDictionary {
    NSArray* objectList = [self listWithDictionary: filterWhereDictionary];
    if (!objectList) {
        return nil;
    } else if ([objectList count] == 1) {
        return objectList[0];
    } else {
        return nil;
    }
}
-(NSArray*) listWithDictionary: (NSDictionary*) filterWhereDictionary {
    NSError *error = nil;
    NSArray* objectList = [self createInstances: [self.access.API GET: [NSString stringWithFormat: @"/%@", self.modelName] where: filterWhereDictionary error: &error]];
    if (error) {
        return nil;
    } else {
        return objectList;
    }
}


@end
