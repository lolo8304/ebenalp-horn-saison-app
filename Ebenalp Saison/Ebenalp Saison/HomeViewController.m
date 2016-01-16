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
@property (weak, nonatomic) IBOutlet UIImageView *imageLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageBeacons;
@property (weak, nonatomic) IBOutlet UILabel *labelNofBeacons;
@property (weak, nonatomic) IBOutlet UIImageView *imageNotifications;
@property (weak, nonatomic) IBOutlet UILabel *labelInfoBeacons;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segHZero;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segHOne;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segHTwo;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segZZero;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segZOne;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segSZero;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSOne;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segHoettli;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Customer* customer =[ [UserManagement instance] customer];
    
    NSString* name = [NSString stringWithFormat: @"%@ %@, %@ [%l]",[customer firstname], [customer name], [[UserManagement instance] stateAsString], [customer id]];
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

- (int)getControlIndex: (NSString*) proximityName {
    if ([proximityName isEqualToString: @"immediate"]) {
        return 0;
    } else if ([proximityName isEqualToString: @"near"]) {
        return 1;
    } else if ([proximityName isEqualToString: @"far"]) {
        return 2;
    } else {
        return -1;
    }
}

- (UISegmentedControl*)getControl: (NSString*) beaconName {
    if ([beaconName isEqualToString: @"Horn-0"]) {
        return self.segHZero;
    } else if ([beaconName isEqualToString: @"Horn-1"]) {
        return self.segHOne;
    } else if ([beaconName isEqualToString: @"Horn-2"]) {
        return self.segHTwo;
    } else if ([beaconName isEqualToString: @"Zauberteppich-0"]) {
        return self.segZZero;
    } else if ([beaconName isEqualToString: @"Zauberteppich-1"]) {
        return self.segZOne;
    } else if ([beaconName isEqualToString: @"Seillift-0"]) {
        return self.segSZero;
    } else if ([beaconName isEqualToString: @"Seillift-1"]) {
        return self.segSOne;
    } else if ([beaconName isEqualToString: @"Höttli-0"]) {
        return self.segHoettli;
    } else {
        return nil;
    }
}


- (void) didUpdateBeaconRanges:(NSArray *)rangedBeacons {
    if ([rangedBeacons count] == 0){
        self.imageBeacons.image = [UIImage imageNamed: @"red"];
        [self noBeacons];
        return;
    }else {
        NSLog(@"ROXIMITY %lu found the following beacons: \n", (unsigned long)[rangedBeacons count]);
        
        unsigned int c = 0;
        NSString* buffer = @"";
        NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beacon_name" ascending:YES];
        NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        NSArray* sortedArray = [rangedBeacons sortedArrayUsingDescriptors:sortDescriptors];
        
        for (NSDictionary* beacon in sortedArray) {
            if ([[beacon valueForKey: @"proximity_value"] intValue] > 0) {
                NSString* beaconName =[beacon valueForKey: @"beacon_name"];
                NSString* proximityName =[beacon valueForKey: @"proximity_string"];
                UISegmentedControl* segment = [self getControl: beaconName];
                int segmentIndex = [self getControlIndex: proximityName];
                    buffer = [NSString stringWithFormat: @"%@%\n@/%@",buffer, beaconName, proximityName];
                    [segment setSelectedSegmentIndex: segmentIndex];
                    [segment setSelected: true];
                c++;
            }
        }
        if (c > 0) {
            self.imageBeacons.image = [UIImage imageNamed: @"green"];
            [self.labelNofBeacons setText: [NSString stringWithFormat: @"%u", c]];
            [self.labelInfoBeacons setText: buffer];
        } else {
            [self noBeacons];
        }
    }
    
}

- (void) noBeacons {
    self.imageBeacons.image = [UIImage imageNamed: @"red"];
    [self.segHZero setSelected: false];
    [self.segHZero setSelectedSegmentIndex: -1];
    [self.segHOne setSelected: false];
    [self.segHOne setSelectedSegmentIndex: -1];
    [self.segHTwo setSelected: false];
    [self.segHTwo setSelectedSegmentIndex: -1];
    [self.segZZero setSelected: false];
    [self.segZZero setSelectedSegmentIndex: -1];
    [self.segZOne setSelected: false];
    [self.segZOne setSelectedSegmentIndex: -1];
    [self.segSZero setSelected: false];
    [self.segSZero setSelectedSegmentIndex: -1];
    [self.segSOne setSelected: false];
    [self.segSOne setSelectedSegmentIndex: -1];
    [self.segHoettli setSelected: false];
    [self.segHoettli setSelectedSegmentIndex: -1];
    
    [self.labelNofBeacons setText: @""];
    [self.labelInfoBeacons setText: @"no beacons"];

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
