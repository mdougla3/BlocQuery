//
//  QuestionsListTableViewCell.h
//  BlocQuery
//
//  Created by McCay Barnes on 12/5/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@protocol QuestionsTableViewCellDelegate <NSObject>

- (void)upVoteButtonPressed:(PFObject *)answer;
- (void)userNameButtonPressed:(PFObject *)answer;

@end

@interface QuestionsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberOfUpVotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *userNameButtonLabel;


@end
