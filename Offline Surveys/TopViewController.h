//
//  TopViewController.h
//  Offline Surveys
//
//  Created by James Snee on 8/25/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

@interface TopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *subviewBoundsView;
@property (weak, nonatomic) IBOutlet UIButton *nextDoneButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)nextButtonTouched:(id)sender;
- (IBAction)secretAdminButtonTouched:(id)sender;
- (IBAction)touchDown:(id)sender;

@end
