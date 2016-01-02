//
//  LoginController.m
//  Ebenalp Saison
//
//  Created by Lorenz Hänggi on 02/01/16.
//  Copyright © 2016 Ebenalp. All rights reserved.
//

#import "LoginController.h"
#import "UserManagement.h"

/* http://cocoadocs.org/docsets/SSKeychain/1.3.1/ */
#import "SSKeychain.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *textEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonReset;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UILabel *labelError;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self buttonReset] setEnabled:false];
    
    NSArray* accounts = [SSKeychain accountsForService: @"Ebenalp-Horn-Saison-App"];
    if (accounts && [accounts count] > 0) {
        NSDictionary* account = accounts[0];
        [[self textEmailAddress] setText: [account valueForKey: kSSKeychainAccountKey]];
        [[self textPassword] becomeFirstResponder];
    } else {
        //[[self textEmailAddress] becomeFirstResponder];
    }
    
    //[SSKeychain setPassword:@"AnyPassword" forService:@"AnyService" account:@"AnyUser"]
    
    UIToolbar* emailAddressToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    emailAddressToolbar.barStyle = UIBarStyleDefault;
    emailAddressToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(goToPasswordField)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithEmailAddress)]];
    [emailAddressToolbar sizeToFit];
    self.textEmailAddress.inputAccessoryView = emailAddressToolbar;

    
    UIToolbar* passwordToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    passwordToolbar.barStyle = UIBarStyleDefault;
    passwordToolbar.items = @[
                                  [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToEmailAddressField)],
                                  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                  [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithLogin)]];
    [passwordToolbar sizeToFit];
    self.textPassword.inputAccessoryView = passwordToolbar;
    
    
}

-(void)goToPasswordField{
    [self.textPassword becomeFirstResponder];
}
-(void)goToEmailAddressField{
    [self.textEmailAddress becomeFirstResponder];
}

-(void)doneWithEmailAddress{
    [self.textEmailAddress resignFirstResponder];
}

-(void)doneWithLogin{
    [self.textEmailAddress resignFirstResponder];
    [self performSegueWithIdentifier:@"login" sender:self];
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


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    
    UserManagement* userAPI = [UserManagement instance];
    [userAPI authenticate: [[self textEmailAddress] text] password: [[self textPassword] text]];
    return YES;
}

- (IBAction)clickLogin:(id)sender {
}


- (IBAction)emailAdressChanged:(id)sender {
    NSString* email =[[self textEmailAddress] text];
    if (email && [email length] > 0) {
        if ([LoginController validateEmail: email]) {
            [[self buttonReset] setEnabled:true];
            [[self buttonLogin] setEnabled:true];
            [[self labelError] setText: @""];
        } else {
            [[self labelError] setText: @"ungültige Email adresse"];
            [[self buttonReset] setEnabled:false];
            [[self buttonLogin] setEnabled:false];
        }
    } else {
        [[self buttonReset] setEnabled:false];
        [[self buttonLogin] setEnabled:false];
        [[self labelError] setText: @""];
    }
}


+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
