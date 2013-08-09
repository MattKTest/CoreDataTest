//
//  LoginViewController.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginTouch:(id)sender;

- (id)initWithMessage:(NSString *)message;

@end
