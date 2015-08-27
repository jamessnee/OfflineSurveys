//
//  ApplicationsDefaults.m
//  Offline Surveys
//
//  Created by James Snee on 8/24/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "OSQuestion.h"
#import "ApplicationsDefaults.h"

ApplicationsDefaults *applicationsDefaults;

@implementation ApplicationsDefaults

+ (instancetype) getApplicationDefaults {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationsDefaults = [ApplicationsDefaults new];
        applicationsDefaults.mainBackgroundColor = [UIColor whiteColor];
        applicationsDefaults.defaultSalutations = @[@"Dr", @"Professor", @"Mrs", @"Ms", @"Miss", @"Mr"];

        OSQuestion *q1 = [OSQuestion new];
        q1.questionText = @"Question 1?";
        OSQuestion *q2 = [OSQuestion new];
        q2.questionText = @"Question 2?";
        applicationsDefaults.defaultQuestions = @[q1, q2];
    });
    return applicationsDefaults;
}

@end
