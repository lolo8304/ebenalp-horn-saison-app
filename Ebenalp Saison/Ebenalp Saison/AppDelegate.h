//
//  AppDelegate.h
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 29/12/15.
//  Copyright © 2015 Ebenalp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROXIMITYSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ROXIMITYEngineDelegate, ROXBeaconRangeUpdateDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL locationNotUsable;
@property (nonatomic) BOOL notificationsNotPermitted;

-(void) setBeaconRangeDelegate:(id<ROXBeaconRangeUpdateDelegate>)beaconRangeUpdateDelegate;
-(void) setAlias:(NSString*)alias;
-(void) removeAlias;


@end

