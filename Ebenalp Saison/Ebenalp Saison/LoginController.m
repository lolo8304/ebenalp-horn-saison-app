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
    
    if ([[UserManagement instance] authenticateKeyStoreToken]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    } else {
        NSString* keyStoreUser = [[UserManagement instance] getKeyStoreUser];
        if (keyStoreUser) {
            [[self textEmailAddress] setText:keyStoreUser];
            [[self textPassword] setText: @""];
            //[[self textPassword] becomeFirstResponder];
        } else {
            [[self textEmailAddress] setText: @""];
            [[self textPassword] setText: @""];
            //[[self textEmailAddress] resignFirstResponder];
        }
    }
    
    UIToolbar* emailAddressToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    emailAddressToolbar.barStyle = UIBarStyleDefault;
    emailAddressToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(goToPasswordField)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithEmailAddress)]
                            ];
    [emailAddressToolbar sizeToFit];
    self.textEmailAddress.inputAccessoryView = emailAddressToolbar;

    
    UIToolbar* passwordToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    passwordToolbar.barStyle = UIBarStyleDefault;
    passwordToolbar.items = @[
                                  [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToEmailAddressField)],
                                  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                  [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithPassword)]
                                  
/*                                  ,
                                  [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(doneAndLogin)]
*/
                                  ];
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

-(void)doneAndLogin{
    [self.textEmailAddress resignFirstResponder];
    [self performSegueWithIdentifier:@"login" sender:self];
}
-(void)doneWithPassword{
    [self.textPassword resignFirstResponder];
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
    [[self labelError] setText: @""];
    UserManagement* userAPI = [UserManagement instance];
    if ([userAPI hasValidToken]) {
        return YES;
    } else {
        NSString* emailText = [[self textEmailAddress] text];
        NSString* pwdText = [[self textPassword] text];
        if (emailText && [emailText length] == 0) {
            [[self labelError] setText: @"Die Email ist leer"];
            return NO;
        } else if (pwdText && [pwdText length] == 0) {
            [[self labelError] setText: @"Das Passwort ist leer"];
            return NO;
        } else {
            if ([userAPI authenticate: [[self textEmailAddress] text] password: [[self textPassword] text]]) {
                return YES;
            } else {
                [[self labelError] setText: @"Die Email oder das Passwort sind falsch"];
                return NO;
            }
        }
    }
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
