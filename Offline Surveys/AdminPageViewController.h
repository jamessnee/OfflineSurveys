//
//  AdminPageViewController.h
//  Offline Surveys
//
//  Created by James Snee on 8/26/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

@interface AdminPageViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

- (IBAction)crossButtonTouched:(id)sender;
- (IBAction)emailButtonTouched:(id)sender;
- (IBAction)clearButtonTouched:(id)sender;

@end
