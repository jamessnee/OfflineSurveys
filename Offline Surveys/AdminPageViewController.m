//
//  AdminPageViewController.m
//  Offline Surveys
//
//  Created by James Snee on 8/26/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "ApplicationsDefaults.h"
#import "OSQuestion.h"
#import "SimpleObjectStore.h"
#import "AdminPageViewController.h"

@interface AdminPageViewController ()

@end

@implementation AdminPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDefaults {

}

- (IBAction)crossButtonTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)emailButtonTouched:(id)sender {
    SimpleObjectStore *simpleObjStore = [SimpleObjectStore getObjectStore];

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Offline Survey Results"];

        NSString *currDate = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle];
        NSString *message = [NSString stringWithFormat:@"Results from a survey gathered at %@", currDate];
        [mailViewController setMessageBody:message isHTML:NO];

        NSString *attachmentFilename = [NSString stringWithFormat:@"surveyresults_%@.csv",currDate];
        NSString *contents = [simpleObjStore getFileContents];
        [mailViewController addAttachmentData:[contents dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:attachmentFilename];
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline Surveys"
                                                        message:@"Your iPad doesn't appear to be setup to send emails..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)clearButtonTouched:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Are you sure you want to clear all current data?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        SimpleObjectStore *objStore = [SimpleObjectStore getObjectStore];
        [objStore clearAll];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
//    switch (result) {
//        case MFMailComposeResultFailed:
//            NSLog(@"Failed to send email: %@", error);
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail sucessfully sent");
//            break;
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail composition was cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail was saved as a draft");
//            break;
//        default:
//            break;
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
