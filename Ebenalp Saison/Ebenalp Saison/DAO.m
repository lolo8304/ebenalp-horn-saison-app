//
//  DAO.m
//  HuntingCars
//
//  Created by Cédric Wider on 03/10/15.
//  Copyright © 2015 hackZurich. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DAO : NSObject
@property (strong, nonatomic) NSDictionary *dict;
@end

@implementation DAO

-(id) initWithDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.dict = dict;
    }
    return self;
}

-(NSDictionary*) dictionay {
    return self.dict;
}
-(void)updateDictionary: (NSDictionary*) dictionary {
    self.dict = dictionary;
}


- (NSString*) s: (NSString*) key {
    return [self dict][key];
}
- (NSDictionary*) d: (NSString*) key {
    return [self dict][key];
}
- (NSString*) i: (NSString*) key {
    return [NSString stringWithFormat:@"%i", (int)[self dict][key]];
}
- (int) int: (NSString*) key {
    NSNumber* n = [self dict][key];
    return [n intValue];
}

- (double) double: (NSString*) key {
    NSNumber* n = [self dict][key];
    return [n doubleValue];
}

- (NSString*) s1: (NSString*) string1 and: (NSString*) by s2: (NSString*) string2 {
    return [NSString stringWithFormat:@"%@%@%@", string1, by, string2];
}

- (NSArray*) a: (NSString*) key {
    return [self dictionay][key];
}


@end
