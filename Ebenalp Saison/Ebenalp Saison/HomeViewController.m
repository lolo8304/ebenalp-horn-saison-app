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

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation HomeViewController

- (IBAction)callLogoff:(id)sender {
    [[UserManagement instance] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Customer* customer =[ [UserManagement instance] customer];
    
    NSString* name = [NSString stringWithFormat: @"%@ %@ %i",[customer firstname], [customer name], [customer id]];
    [[self labelName] setText: name];
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
