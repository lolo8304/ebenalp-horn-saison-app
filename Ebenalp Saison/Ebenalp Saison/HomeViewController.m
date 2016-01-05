//
//  HomeViewController.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 02/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "HomeViewController.h"
#import "UserManagement.h"
#import "Customer.h"
#import "AppDelegate.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageBeacons;
@property (weak, nonatomic) IBOutlet UIImageView *imageNotifications;

@end

@implementation HomeViewController

- (IBAction)callLogoff:(id)sender {
    [[UserManagement instance] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Customer* customer =[ [UserManagement instance] customer];
    
    NSString* name = [NSString stringWithFormat: @"%@ %@ %i %@",[customer firstname], [customer name], [customer id], [[UserManagement instance] stateAsString]];
    [[self labelName] setText: name];
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    self.imageLocation.image = [UIImage imageNamed: (delegate.locationNotUsable ? @"red" : @"green")];
    self.imageNotifications.image = [UIImage imageNamed: (delegate.notificationsNotPermitted ? @"red" : @"green")];
    [delegate setBeaconRangeDelegate: self];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate setBeaconRangeDelegate: nil];
    
}


- (void) didUpdateBeaconRanges:(NSArray *)rangedBeacons {
    if ([rangedBeacons count] == 0){
        self.imageBeacons.image = [UIImage imageNamed: @"red"];
        return;
    }else {
        NSLog(@"ROXIMITY %lu found the following beacons: \n", (unsigned long)[rangedBeacons count]);
        for (NSDictionary* beacon in rangedBeacons) {
            if ([[beacon valueForKey: @"proximity_value"] intValue] > 0) {
                self.imageBeacons.image = [UIImage imageNamed: @"green"];
                return;
            }
        }
        self.imageBeacons.image = [UIImage imageNamed: @"red"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
