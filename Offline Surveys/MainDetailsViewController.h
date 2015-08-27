//
//  MainDetailsViewController.h
//  Offline Surveys
//
//  Created by James Snee on 8/25/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "OSViewController.h"
#import "OSUserResponse.h"

@interface MainDetailsViewController : UIViewController <OSViewController, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIPickerView *salutationPicker;

@end
