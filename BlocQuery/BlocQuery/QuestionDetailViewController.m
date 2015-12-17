//
//  QuestionDetailViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 10/26/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionTableViewCell.h"
#import "EditProfileViewController.h"


@interface QuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate, QuestionWithAnswersTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *answers;
@property (weak, nonatomic) IBOutlet UIView *addAnswerView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;
@property (strong, nonatomic) NSString *addedAnswer;
@property (strong, nonatomic) NSString *numberOfUpVotes;

@property (strong, nonatomic) QuestionTableViewCell *cell;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addAnswerView.alpha = 0.0;
    
    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Answer"];
    [answerQuery whereKey:@"parent" equalTo:self.selectedQuestion];
    [answerQuery includeKey:@"users"];
    [answerQuery includeKey:@"author"];
    [answerQuery findObjectsInBackgroundWithBlock:^(NSArray * answers, NSError * _Nullable error) {
        self.answers = [answers mutableCopy];
        [self.answerTableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"questionCell"];
        
        cell.textLabel.text = self.selectedQuestion[@"questionText"];
        cell.backgroundColor = [UIColor grayColor];
        
        return cell;
    }
    else {
        
        QuestionTableViewCell *cell = [self.answerTableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
        
        PFObject *answerText = self.answers[indexPath.row - 1];
        
        cell.delegate = self;
        cell.answer = answerText; 
        cell.answerTextLabel.text = answerText[@"answerText"];
        cell.answerTextLabel.numberOfLines = 0;
        [cell.answerTextLabel sizeToFit];
        
        cell.userNameLabel.tag = indexPath.row;
        [cell.userNameLabel setTitle:answerText[@"author"][@"username"] forState:UIControlStateNormal];
        
        cell.answerUpVotes.text = [answerText[@"upVotes"] stringValue];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    else {
        return 157;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.answers.count + 1;
}

- (IBAction)giveAnAnswerButtonPressed:(UIBarButtonItem *)sender {
    
    self.addAnswerView.alpha = 1.0;

}

- (IBAction)saveButtonPressed:(UIButton *)sender {

    self.addedAnswer = self.answerTextField.text;
    
    PFObject *addNewAnswer = [PFObject objectWithClassName:@"Answer"];
    addNewAnswer[@"answerText"] = self.addedAnswer;
    addNewAnswer[@"author"] = [PFUser currentUser];

    
    [self.answers addObject:addNewAnswer];
    
    [self.selectedQuestion setObject:self.answers forKey:@"answers"];
    
    PFRelation *relation = [addNewAnswer relationForKey:@"parent"];
    [relation addObject:self.selectedQuestion];
    
    [addNewAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Saved");
        }
    }];
    
    [self.answerTableView reloadData];

    self.addAnswerView.alpha = 0.0;

}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    self.addAnswerView.alpha = 0.0;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *answers = self.answers[indexPath.row];
    [answers deleteInBackground];
    [answers saveInBackground];
    
    [self.answers removeObjectAtIndex:indexPath.row];
    [self.answerTableView reloadData];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)upVoteButtonPressed:(PFObject *)answer{
    
    
    NSMutableArray *users = answer[@"users"];
    
    if (!users) {
        users = [NSMutableArray array];
    }
    if ([users containsObject:[PFUser currentUser]]) {
        [users removeObject:[PFUser currentUser]];
        [answer incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:-1]];
    }
    else {

        [users addObject:[PFUser currentUser]];
        [answer incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:1]];
    }
    
    answer[@"users"] = users;
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.answerTableView reloadData];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if([segue.identifier isEqualToString:@"viewProfile"]) {
        EditProfileViewController *viewProfileVC = segue.destinationViewController;
    
        viewProfileVC.navigationItem.rightBarButtonItem = nil;
        viewProfileVC.user = self.answers[sender.tag - 1][@"author"];
    }
}

- (void)userNameButtonPressed:(PFObject *)answer{
    
}



@end
