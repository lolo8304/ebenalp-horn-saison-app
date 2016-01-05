//
//  AppDelegate.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 29/12/15.
//  Copyright © 2015 Ebenalp. All rights reserved.
//

#import "AppDelegate.h"
#import "UserManagement.h"
#import "ROXIMITYEngine.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary * roximityEngineOptions = @{
                                             kROXEngineOptionsUserTargetingLimited : @NO,
                                             kROXEngineOptionsMuteBluetoothOffAlert: @NO,
                                             kROXEngineOptionsMuteLocationPermissionAlert : @NO,
                                             kROXEngineOptionsMuteNotificationPermissionAlert: @NO,
                                             kROXEngineOptionsMuteRequestAlerts: @NO,
                                             kROXEngineOptionsReservedRegions: [NSNumber numberWithInt:5],
                                             kROXEngineOptionsStartLocationDeactivated: @NO
                                             };
    
    
    [ROXIMITYEngine startWithLaunchOptions: launchOptions engineOptions: roximityEngineOptions applicationId:@"1819b921b85f4cd697e5008220a7cf92" andEngineDelegate:self];

    [self setRootViewController];
    return YES;
}

- (void)setRootViewController {
    //Your View Controller Identifiers defined in Interface Builder
    NSString *firstViewControllerIdentifier  = @"LoginController";
    NSString *secondViewControllerIdentifier = @"NavigationController";
    
    BOOL validToken = [[UserManagement instance] authenticateKeyStoreToken];
    if (!validToken) {
        [ROXIMITYEngine removeAlias];
    } else {
    }
    
    //check which view controller identifier should be used
    NSString *viewControllerIdentifier = validToken ? secondViewControllerIdentifier : firstViewControllerIdentifier;
    
    //IF THE STORYBOARD EXISTS IN YOUR INFO.PLIST FILE AND YOU USE A SINGLE STORYBOARD
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    //IF THE STORYBOARD DOESN'T EXIST IN YOUR INFO.PLIST FILE OR IF YOU USE MULTIPLE STORYBOARDS
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"YOUR_STORYBOARD_FILE_NAME" bundle:nil];
    
    //instantiate the view controller
    UIViewController *presentedViewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    //IF YOU DON'T USE A NAVIGATION CONTROLLER:
    [self.window setRootViewController:presentedViewController];

}

-(void) setBeaconRangeDelegate:(id<ROXBeaconRangeUpdateDelegate>)beaconRangeUpdateDelegate  {
    [ROXIMITYEngine setBeaconRangeDelegate: beaconRangeUpdateDelegate withUpdateInterval: kROXBeaconRangeUpdatesFastest];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [ROXIMITYEngine resignActive]; // Place in applicationWillResignActive

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [ROXIMITYEngine background]; // Place in applicationDidEnterBackground

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [ROXIMITYEngine foreground]; // Place in applicationWillEnterForeground
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ROXIMITYEngine active]; // Place in applicationDidBecomeActive
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [ROXIMITYEngine terminate]; // Place in applicationWillTerminate
}


//Adding the following methods for remote notification handling
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [ROXIMITYEngine didFailToRegisterForRemoteNotifications:error];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [ROXIMITYEngine didRegisterForRemoteNotifications:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [ROXIMITYEngine didReceiveRemoteNotification:application userInfo:userInfo fetchCompletionHandler:completionHandler];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [ROXIMITYEngine didReceiveRemoteNotification:application userInfo:userInfo];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [ROXIMITYEngine didReceiveLocalNotification:application notification:(UILocalNotification *)notification];
}




//ROXIMITY Engine Delegate methods

- (void) bluetoothRoximityUsable:(BOOL)usable state:(CBCentralManagerState)state{
    NSLog(@"Bluetooth in usable state for ROXIMITY: %@ State: %zd", usable ? @"YES" : @"NO", state);
}



- (void) locationRoximityUsable:(BOOL)usable status:(CLAuthorizationStatus)authStatus{
    NSLog(@"Location in usable state for ROXIMITY: %@ State: %zd", usable ? @"YES" : @"NO", authStatus);
    // If the user HAS made a determination about location, but it's not usable by ROXIMITY, prompt to adjust in Settings
    
    self.locationNotUsable = !usable && authStatus != kCLAuthorizationStatusNotDetermined;
    if (self.locationNotUsable){
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Adjust Location Permissions"
                                              message:@"This application leverages iBeacon for unique, location-based experiences. Please enable by visiting Settings and selecting \"Always\" for Location."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Visit Settings"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
                                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                             
                                                         }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"No thanks" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:okAction];
        
        [self presentAlertController: alertController];
        
    }
    
}



- (void) notificationsRoximityPermitted:(BOOL)permitted{
    
    NSLog(@"Notifications permitted for ROXIMITY: %@", permitted ? @"YES" : @"NO");
    
    self.notificationsNotPermitted = !permitted;
    if (self.notificationsNotPermitted){
        
        UIAlertController *alertController = [UIAlertController
                                              
                                              alertControllerWithTitle:@"Adjust Notifications Permissions"
                                              
                                              message:@"This application requires allowing notifications to deliver beacon based message."
                                              
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Visit Settings"
                                   
                                                           style:UIAlertActionStyleDefault
                                   
                                                         handler:^(UIAlertAction * action){
                                                             
                                                             [alertController dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                             
                                                         }];
        
        
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"No thanks" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentAlertController: alertController];
        
    }
    
}

-(void) aliasSetResult:(BOOL)success alias:(NSString *)alias error:(NSError *)error{
    if (success){
        NSLog(@"Alias has been set to: %@", [ROXIMITYEngine getAlias]);
    }else{
        NSLog(@"There was an error setting the alias: %@", error);
    }
}

-(void) aliasRemoveResult:(BOOL)success error:(NSError *)error{
    
    if (success){
        NSLog(@"Alias has been removed");
    }else{
        NSLog(@"There was an error removing the alias: %@", error);
    }
}




-(void) presentAlertController: (UIAlertController *) alertController {
    // Bettery safe than sorry with presenting on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        id rootViewController = [self getRootViewController];
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

-(id)getRootViewController {
    id rootViewController=[UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController=[((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    }
    return rootViewController;
}





@end
