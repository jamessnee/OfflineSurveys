//
//  QuestionViewController.h
//  Offline Surveys
//
//  Created by James Snee on 8/26/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "OSQuestion.h"
#import "OSViewController.h"
#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController <OSViewController>

@property (strong) OSQuestion *question;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger questionIndex; // The index of the question in the questions array inside App Defaults
@property (weak, nonatomic) IBOutlet UILabel *questionText;
@property (weak, nonatomic) IBOutlet UITextField *responseText;

@end