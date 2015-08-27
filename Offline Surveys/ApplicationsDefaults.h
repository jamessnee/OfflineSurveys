//
//  ApplicationsDefaults.h
//  Offline Surveys
//
//  Created by James Snee on 8/24/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplicationsDefaults : NSObject

+ (instancetype) getApplicationDefaults;

@property (strong, nonatomic) UIColor *mainBackgroundColor;
@property (strong, nonatomic) NSArray *defaultSalutations;
@property (strong, nonatomic) NSArray *defaultQuestions;

@end
