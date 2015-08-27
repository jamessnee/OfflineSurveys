//
//  MainDetailsViewController.m
//  Offline Surveys
//
//  Created by James Snee on 8/25/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//
#import "ApplicationsDefaults.h"
#import "OSUserResponse.h"
#import "MainDetailsViewController.h"

@interface MainDetailsViewController ()

@end

@implementation MainDetailsViewController

- (OSUserResponse *)updateUserResponse:(OSUserResponse *)userResponse {
    userResponse.first_name = self.firstnameField.text;
    userResponse.surname = self.surnameField.text;
    userResponse.emailAddress = self.emailField.text;
    ApplicationsDefaults *appDefaults = [ApplicationsDefaults getApplicationDefaults];
    userResponse.salutation = appDefaults.defaultSalutations[[self.salutationPicker selectedRowInComponent:0]];
    return userResponse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.firstnameField performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    ApplicationsDefaults *appDefaults = [ApplicationsDefaults getApplicationDefaults];
    return  appDefaults.defaultSalutations.count;
}

#pragma mark - PickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ApplicationsDefaults *appDefaults = [ApplicationsDefaults getApplicationDefaults];
    return appDefaults.defaultSalutations[row];
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
