//
//  ViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 9/29/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "ViewController.h"
#import "QuestionDetailViewController.h"
#import "QuestionTableViewCell.h"
#import "QuestionsListTableViewCell.h"
#import "EditProfileViewController.h"

@interface ViewController () <PFLogInViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *questionsArray;
@property (weak, nonatomic) IBOutlet UITableView *questionsTableView;
@property (strong, nonatomic) PFObject *currentQuestion;

@property (strong, nonatomic) IBOutlet UIView *addQuestionView;
@property (weak, nonatomic) IBOutlet UITextView *addQuestionTextField;

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *upVotesTotalLabel;
@property (strong, nonatomic) NSArray *sortedQuestionListArray;



@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.addQuestionView.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Question"];
        [query includeKey:@"author"];
        [query orderByDescending:@"upVotes"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                self.questionsArray = [objects mutableCopy];
                [self.questionsTableView reloadData];
            }
        }];
        
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

-(IBAction)saveButtonPressed:(id)sender {
    PFObject *question = [PFObject objectWithClassName:@"Question"];
    question[@"questionText"] = self.addQuestionTextField.text;
    question[@"author"] = [PFUser currentUser];
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Question"];
            [query includeKey:@"author"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (!error) {
                    self.questionsArray = [objects mutableCopy];
                    [self.questionsTableView reloadData];
                }
            }];
        }
        else {
            // Log error
        }
    }];
    
    [self resignFirstResponder];
    self.addQuestionView.alpha = 0.0;
}

-(IBAction)cancelButtonPressed:(id)sender {
    
    self.addQuestionView.alpha = 0.0;
    
}

- (IBAction)newQuestionButtonPressed:(UIBarButtonItem *)sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.addQuestionView.alpha = 1.0;
        
    }];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionsListTableViewCell *cell = [self.questionsTableView dequeueReusableCellWithIdentifier:@"questionCell"];
    
    PFObject *questions = self.questionsArray[indexPath.row];
    
    cell.numberOfUpVotesLabel.text = [NSString stringWithFormat:@"%@", questions[@"upVotes"]];
    [cell.userNameButtonLabel setTitle:questions[@"author"][@"username"] forState:UIControlStateNormal];
    cell.questionTextLabel.text = questions[@"questionText"];;
    cell.userNameButtonLabel.tag = indexPath.row;
    
    return cell; 
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questionsArray count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *questions = self.questionsArray[indexPath.row];
    [questions deleteInBackground];
    [questions saveInBackground];

    [self.questionsArray removeObjectAtIndex:indexPath.row];
    [self.questionsTableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *selectedQuestionText = self.questionsArray[indexPath.row];
    self.currentQuestion = selectedQuestionText;
    
    [self performSegueWithIdentifier:@"selectedQuestion" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if ([segue.identifier isEqualToString:@"selectedQuestion"]) {
        QuestionDetailViewController *questionDetailVC = segue.destinationViewController;
        
        questionDetailVC.title = @"Question";
        questionDetailVC.selectedQuestion = self.currentQuestion;
    }
    else if([segue.identifier isEqualToString:@"viewProfile"]) {
        EditProfileViewController *viewProfileVC = segue.destinationViewController;
        
        viewProfileVC.navigationItem.rightBarButtonItem = nil;
        viewProfileVC.user = self.questionsArray[sender.tag][@"author"];
    }
}

- (IBAction)upVoteButtonPressed:(UIButton *)sender {
}
- (IBAction)userNameButtonPressed:(UIButton *)sender {
    
}


@end