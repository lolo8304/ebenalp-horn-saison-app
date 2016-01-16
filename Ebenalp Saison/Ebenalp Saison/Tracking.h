//
//  Tracking.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 16/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "DAO.h"

@interface Tracking : DAO


-(int) id;
-(NSString*) triggerName;
-(NSString*) event;
-(int) speed;
-(NSDate*) triggeredAtDate;
-(NSString*) triggeredAtString;

@end
