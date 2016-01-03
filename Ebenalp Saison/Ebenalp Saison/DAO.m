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

+(NSDate*) timestampFromUTCString: (NSString*) timestampUTCString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //The Z at the end of your string represents Zulu which is UTC
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString: timestampUTCString];
}

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


- (NSObject*) o: (NSString*) key {
    return [self dict][key];
}

- (BOOL) b: (NSString*) key {
    return [self dict][key];
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
- (NSDate*) date: (NSString*) key {
    return [ DAO timestampFromUTCString: [self s: key]];
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
