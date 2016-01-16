//
//  Tracking.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 16/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "Tracking.h"

/*
 {
 "id": 1556,
 "event": "immediate",
 "device_alias": "1$lolo8304@gmail.com",
 "application_id": "1819b921b85f4cd697e5008220a7cf92",
 "action_id": "5682aa5f69702d56541d0000",
 "tags": "HornBottom",
 "trigger_name": "Horn-0",
 "trigger_type": "beacon",
 "customer_id": 1,
 "trigger_id": "54ca6c3069702d0c44ab1800",
 "created": "2016-01-12T22:24:00.000Z",
 "triggered_at_date": "2016-01-12T22:23:59.000Z",
 "altitude": 531.2084350585938,
 "age": -595.3520179986954,
 "bearing": -1,
 "h_accuracy": 65,
 "latitude": 47.3658648344875,
 "longitude": 8.7418772936961,
 "speed": -1,
 "triggered_at": 1452637439.611594
 },
 
 */


@implementation Tracking

-(int) id {
    return [self int: @"id"];
}
-(NSString*) triggerName {
    return [self s: @"trigger_name"];
}
-(NSString*) event {
    return [self s: @"event"];
}
-(int) speed {
    return [self int: @"speed"];
}
-(NSDate*) triggeredAtDate {
    return [self date: @"triggered_at_date"];
}
-(NSString*) triggeredAtString {
    return [self s: @"triggered_at_date"];
}



@end
