//
//  ViewController.m
//  iOSTask
//
//  Created by Neeraj Sonaro on 28/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"
#import "QuizViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1].CGColor, (id)[[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *username = _usernameTextfield.text;
    NSString *password = _passwordTextfield.text;
    
    if ([username isEqualToString:@""] && [password isEqualToString:@""]) {
        return;
    }
    
    NSArray *userArray = [UserManager fetchUser:username password:password];
    if (userArray.count == 1) {
        [self performSegueWithIdentifier:@"loginSegueId" sender:username];
    }
    else if (userArray.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quiz Contest" message:@"It seems you do not have account. Please register" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark : uitextfield delegates
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegueId"]) {
        QuizViewController *quizVC = [segue destinationViewController];
        quizVC.username = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
