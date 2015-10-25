//
//  ViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 9/29/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <PFLogInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        // Display questions
    
    }
    else {
    PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
    logInVC.delegate = self;
    [self presentViewController:logInVC animated:YES completion:nil];
    }
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButton:(UIButton *)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
    PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
    logInVC.delegate = self;
    [self presentViewController:logInVC animated:YES completion:nil];
}


@end
