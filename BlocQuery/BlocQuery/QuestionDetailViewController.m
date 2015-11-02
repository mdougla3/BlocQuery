//
//  QuestionDetailViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 10/26/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "QuestionDetailViewController.h"

@interface QuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *answers;
@property (weak, nonatomic) IBOutlet UIView *addAnswerView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) NSString *addedAnswer;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addAnswerView.alpha = 0.0;
    
    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Question"];
    [answerQuery whereKey:@"questionText" equalTo:self.selectedQuestion];
    [answerQuery findObjectsInBackgroundWithBlock:^(NSArray * answers, NSError * _Nullable error) {
        self.answers = [answers mutableCopy];
        [self.answerTableView reloadData];
    }];
    
    //    [answerQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (!error) {
//            self.answers = [objects mutableCopy];
//            [self.answerTableView reloadData];
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = self.selectedQuestion;
        cell.backgroundColor = [UIColor grayColor];
    }
    else {
        PFObject *answerText = self.answers[indexPath.row];
        cell.textLabel.text = answerText[@"answers"];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.answers.count;
}

- (IBAction)giveAnAnswerButtonPressed:(UIBarButtonItem *)sender {
    
    self.addAnswerView.alpha = 1.0;

}

- (IBAction)saveButtonPressed:(UIButton *)sender {

    self.addedAnswer = self.answerTextField.text;
    [self.answers addObject:self.addedAnswer];
    
    PFQuery *questionQuery = [PFQuery queryWithClassName:@"Question"];
    [questionQuery getObjectInBackgroundWithId:self.questionID block:^(PFObject *question, NSError * _Nullable error) {

        [question addUniqueObject:self.addedAnswer forKey:@"answers"];
        [question saveInBackground];
    }];
    
//    PFObject *addNewAnswer = [PFObject objectWithClassName:@"Question"];
//    [addNewAnswer addUniqueObject:self.addedAnswer forKey:@"answers"];
//    [addNewAnswer saveInBackground];
//    
//    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Answer"];
//    [answerQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (!error) {
//            self.answers = [objects mutableCopy];
//            [self.answerTableView reloadData];
//        }
//    }];
    
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
