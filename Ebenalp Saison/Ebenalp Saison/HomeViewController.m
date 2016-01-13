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
@property (weak, nonatomic) IBOutlet UIStackView *labelLastVisit;
@property (weak, nonatomic) IBOutlet UIStackView *labelRanking;
@property (weak, nonatomic) IBOutlet UIButton *buttonLift1;
@property (weak, nonatomic) IBOutlet UIButton *buttonLift2;
@property (weak, nonatomic) IBOutlet UIButton *buttonLift3;
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageBeacons;
@property (weak, nonatomic) IBOutlet UILabel *labelNofBeacons;
@property (weak, nonatomic) IBOutlet UIImageView *imageNotifications;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Customer* customer =[ [UserManagement instance] customer];
    
    NSString* name = [NSString stringWithFormat: @"%@ %@, %@ [%i]",[customer firstname], [customer name], [[UserManagement instance] stateAsString], [customer id]];
    [[self labelName] setText: name];
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    self.imageLocation.image = [UIImage imageNamed: (delegate.locationNotUsable ? @"red" : @"green")];
    self.imageNotifications.image = [UIImage imageNamed: (delegate.notificationsNotPermitted ? @"red" : @"green")];
    [delegate setBeaconRangeDelegate: self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (void)viewDidDisappear:(BOOL)animated {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate setBeaconRangeDelegate: nil];
    
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    [[UserManagement instance] logout];
    return YES;
}


- (void) didUpdateBeaconRanges:(NSArray *)rangedBeacons {
    if ([rangedBeacons count] == 0){
        self.imageBeacons.image = [UIImage imageNamed: @"red"];
        return;
    }else {
        NSLog(@"ROXIMITY %lu found the following beacons: \n", (unsigned long)[rangedBeacons count]);
        
        unsigned int c = 0;
        for (NSDictionary* beacon in rangedBeacons) {
            if ([[beacon valueForKey: @"proximity_value"] intValue] > 0) {
                c++;
            }
        }
        if (c > 0) {
            self.imageBeacons.image = [UIImage imageNamed: @"green"];
            [self.labelNofBeacons setText: [NSString stringWithFormat: @"%u", c]];
        } else {
            self.imageBeacons.image = [UIImage imageNamed: @"red"];
            [self.labelNofBeacons setText: @""];
        }
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
