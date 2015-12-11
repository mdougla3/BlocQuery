//
//  QuestionTableViewCell.m
//  BlocQuery
//
//  Created by McCay Barnes on 11/30/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (IBAction)userNameButtonPressed:(UIButton *)sender {
    
}

- (IBAction)upVoteButtonPressed:(UIButton *)sender {
    if ([sender.titleLabel.text isEqual: @"UpVote"]) {
        [sender setTitle:@"DownVote" forState:UIControlStateNormal];
        
    }
    else {
        [sender setTitle:@"UpVote" forState:UIControlStateNormal];
        
    }}


@end
