//
//  QuestionDetailViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 10/26/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionTableViewCell.h"


@interface QuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *answers;
@property (weak, nonatomic) IBOutlet UIView *addAnswerView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) NSString *addedAnswer;
@property (strong, nonatomic) NSArray *numberOfUpVotes;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addAnswerView.alpha = 0.0;
    
    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Answer"];
    [answerQuery whereKey:@"parent" equalTo:self.selectedQuestion];
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
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = self.selectedQuestion[@"questionText"];
        cell.backgroundColor = [UIColor grayColor];
    }
    else {
        
        QuestionTableViewCell *cell = [self.answerTableView dequeueReusableCellWithIdentifier:@"answerCell"];
        
        PFObject *answerText = self.answers[indexPath.row - 1];
        
        cell.answerTextLabel.text = answerText[@"answerText"];
        cell.answerTotalNumberOfUpVotesLabel.text = [NSString stringWithFormat:@"%@", answerText[@"upVotes"]];
    
    }
    return cell;
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
    
    [self.answers addObject:addNewAnswer];
    
    [self.selectedQuestion setObject:self.answers forKey:@"answers"];
    
    PFRelation *relation = [addNewAnswer relationForKey:@"parent"];
    [relation addObject:self.selectedQuestion];
    
    [addNewAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Saved");
        }
    }];
    
    //[self.selectedQuestion save];

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



@end
