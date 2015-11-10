//
//  QuestionDetailViewController.h
//  BlocQuery
//
//  Created by McCay Barnes on 10/26/15.
//  Copyright © 2015 McCay Barnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>

@interface QuestionDetailViewController : UIViewController

@property (strong, nonatomic) PFObject *selectedQuestion;

@end
