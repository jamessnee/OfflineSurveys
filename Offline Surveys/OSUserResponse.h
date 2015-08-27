//
//  OSUserResponse.h
//  Offline Surveys
//
//  Created by James Snee on 7/18/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUserResponse : NSObject

@property (strong, nonatomic, nonnull)  NSString *first_name;
@property (strong, nonatomic, nonnull)  NSString *surname;
@property (strong, nonatomic, nonnull)  NSString *salutation;
@property (strong, nonatomic, nonnull)  NSString *emailAddress;
@property (strong, nonatomic, nonnull)  NSString *q1Answer;
@property (strong, nonatomic, nonnull)  NSString *q2Answer;

@end
