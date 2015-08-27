//
//  OSViewController.h
//  Offline Surveys
//
//  Created by James Snee on 8/26/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "OSUserResponse.h"

@protocol OSViewController <NSObject>

- (OSUserResponse *) updateUserResponse:(OSUserResponse *)userResponse;

@end
