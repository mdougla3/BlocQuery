//
//  QuestionTableViewCell.h
//  BlocQuery
//
//  Created by McCay Barnes on 11/30/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@protocol QuestionWithAnswersTableViewCellDelegate <NSObject>

- (void)upVoteButtonPressed:(PFObject *)answer;
- (void)userNameButtonPressed:(PFObject *)answer;

@end

@interface QuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) PFObject *answer;

@property (nonatomic, weak) id <QuestionWithAnswersTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userProfilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *answerTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerUpVotes;
@property (weak, nonatomic) IBOutlet UIButton *upVoteLabel;

- (IBAction)upVoteButtonPressed:(UIButton *)sender;
- (IBAction)userNameButtonPressed:(UIButton *)sender;



@end
