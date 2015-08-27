//
//  QuestionViewController.m
//  Offline Surveys
//
//  Created by James Snee on 8/26/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "OSUserResponse.h"
#import "QuestionViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (OSUserResponse *)updateUserResponse:(OSUserResponse *)userResponse {
    // This is bad because it relies on there being a fixed number of questions, this SHOULD be fixed
    if (self.questionIndex == 0) {
        userResponse.q1Answer = self.responseText.text;
    } else {
        userResponse.q2Answer = self.responseText.text;
    }
    return userResponse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionText.text = self.question.questionText;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.responseText performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
