//
//  LoginViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AKAuthenticationManager.h"


@interface AKLoginViewController ()
{
    NSString *_message;
}

@end

@implementation AKLoginViewController

- (id)initWithMessage:(NSString *)message
{
    self = [super initWithNibName:@"AKLoginViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _message = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default460.png"]]];
    [self.containerView.layer setCornerRadius:4];
    
    if (_message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authentication Required"
                                                            message:_message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.alpha = 1.0;
        self.loginButton.alpha  = 1.0;
        [self.usernameTextField becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTouch:(id)sender
{
    [self loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];
    }
    else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [[AKAuthenticationManager sharedManager] loginWithUsername:username andPassword:password success:nil failure:^(NSError *error) {
        self.passwordTextField.text = nil;
        [self.passwordTextField becomeFirstResponder];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.domain message:@"Authentication Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

@end
