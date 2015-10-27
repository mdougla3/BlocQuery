//
//  CreateQuestionsViewController.m
//  
//
//  Created by McCay Barnes on 10/1/15.
//
//

#import "CreateQuestionsViewController.h"

@interface CreateQuestionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *questionsArray;
@property (weak, nonatomic) IBOutlet UITextView *questionTextField;

@end

@implementation CreateQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.questionsArray = [objects mutableCopy]        }
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self addNewQuestion];
}

-(void) addNewQuestion {
    PFObject *question = [PFObject objectWithClassName:@"Question"];
    question[@"questionText"] = @"This is the test question text";
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
            NSLog(@"Worked");
        else {
            // CHeck for the error
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questionsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor greenColor];
    
    PFObject *questions = self.questionsArray[indexPath.row];
    
    cell.textLabel.text = questions[@"questionText"];
    
    return cell;
}


@end
