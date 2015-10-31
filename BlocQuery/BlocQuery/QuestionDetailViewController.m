//
//  QuestionDetailViewController.m
//  BlocQuery
//
//  Created by McCay Barnes on 10/26/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import "QuestionDetailViewController.h"

@interface QuestionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) NSString *question;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.answers = @[@"There were too many cheeseburgers",@"There were too many blankets",@"There were not enough blankets",@"She killed the rabbit protecting them"];

    self.question = @"Why are there not enough cholos in the Midwest?";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Answer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.answers = [objects mutableCopy];
        }
    }];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.question;
        cell.backgroundColor = [UIColor grayColor];
    }
    else {
        cell.textLabel.text = self.answers[indexPath.row];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.answers.count;
}

@end
