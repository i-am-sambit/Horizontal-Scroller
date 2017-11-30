//
//  RegisterViewController.m
//  iOSTask
//
//  Created by Neeraj Sonaro on 29/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserManager.h"
#import "QuizViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1].CGColor, (id)[UIColor blackColor].CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)registerAction:(UIButton *)sender {
    
    NSString *username = _usernameTextfield.text;
    NSString *password = _passwordTextfield.text;
    
    if ([username isEqualToString:@""] && [password isEqualToString:@""]) {
        return;
    }
    
    BOOL isSaved = [UserManager saveUser:@{@"username":username, @"password":password}];
    if (isSaved) {
        [self performSegueWithIdentifier:@"registerSegueId" sender:username];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quiz Contest" message:@"It seems you already have account." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (IBAction)loginAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark : uitextfield delegates
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"registerSegueId"]) {
        QuizViewController *quizVC = [segue destinationViewController];
        quizVC.username = sender;
    }
}

@end
