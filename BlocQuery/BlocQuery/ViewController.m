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
    [super viewDidAppear:YES];
    
    PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
    logInVC.delegate = self;
    [self presentViewController:logInVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
