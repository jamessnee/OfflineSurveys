//
//  TopViewController.m
//  Offline Surveys
//
//  Created by James Snee on 8/25/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "AdminPageViewController.h"
#import "ApplicationsDefaults.h"
#import "MainDetailsViewController.h"
#import "OSQuestion.h"
#import "OSUserResponse.h"
#import "QuestionViewController.h"
#import "SimpleObjectStore.h"
#import "ThankyouViewController.h"
#import "TopViewController.h"

@interface TopViewController ()

@property (weak, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) MainDetailsViewController *mainDetailsViewController;
@property (weak, nonatomic) AdminPageViewController *adminPageViewController;
@property (strong, nonatomic) NSArray *allPages;
@property (nonatomic) NSInteger currPageIdx;
@property (strong, nonatomic) SimpleObjectStore *objectStore;
@property (strong, nonatomic) OSUserResponse *currentUserResponse;

// image cache
@property (strong, nonatomic) UIImage *arrowFG;
@property (strong, nonatomic) UIImage *arrowBG;
@property (strong, nonatomic) UIImage *arrowFG_HL;
@property (strong, nonatomic) UIImage *arrowBG_HL;

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup the next button
    UIView *arrowView = [[[NSBundle mainBundle] loadNibNamed:@"ArrowView" owner:self options:nil] objectAtIndex:0];
    arrowView.userInteractionEnabled = NO;
    arrowView.exclusiveTouch = NO;
    [self.nextDoneButton insertSubview:arrowView atIndex:0];
    [self animateArrow:arrowView];

    // Create the necessary view controllers
    NSMutableArray *pages = [NSMutableArray new];
    self.mainDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainDetailsViewController"];
    self.mainDetailsViewController.pageIndex = 0;
    [pages addObject:self.mainDetailsViewController];

    NSInteger currIdx = 1;
    ApplicationsDefaults *appDefaults = [ApplicationsDefaults getApplicationDefaults];
    for (int i = 0; i < appDefaults.defaultQuestions.count; i++) {
        QuestionViewController *qVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionViewController"];
        qVC.question = appDefaults.defaultQuestions[i];
        qVC.pageIndex = currIdx;
        qVC.questionIndex = i;
        currIdx++;
        [pages addObject:qVC];
    }

    ThankyouViewController *thankyouViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewController"];
    thankyouViewController.pageIndex = currIdx;
    currIdx++;
    [pages addObject:thankyouViewController];

    self.allPages= [pages copy];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    [self.pageViewController setViewControllers:@[self.mainDetailsViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.currPageIdx = 0;
    self.pageViewController.view.frame = CGRectMake(self.subviewBoundsView.frame.origin.x, self.subviewBoundsView.frame.origin.y,
                                                    self.subviewBoundsView.frame.size.width, self.subviewBoundsView.frame.size.height);

    [self addChildViewController:self.pageViewController];
    [self.subviewBoundsView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    // Set up the page control
    self.pageControl.numberOfPages = self.allPages.count;
    self.pageControl.currentPage = self.currPageIdx;

    // Create an object store
    self.objectStore = [SimpleObjectStore getObjectStore];
    [self startNewUserResponse];

    // Setup the image cache
    self.arrowFG = [UIImage imageNamed:@"next_arrow_fg"];
    self.arrowBG = [UIImage imageNamed:@"next_arrow_bg"];
    self.arrowFG_HL = [UIImage imageNamed:@"next_arrow_fg_hl"];
    self.arrowBG_HL = [UIImage imageNamed:@"next_arrow_bg_hl"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* User Response Management */
#pragma mark - User Response Management
- (void) startNewUserResponse {
    self.currentUserResponse = [OSUserResponse new];
    for (UIViewController *vc in self.allPages) {
        if ([vc isKindOfClass:[MainDetailsViewController class]]) {
            MainDetailsViewController *mdvc = (MainDetailsViewController *)vc;
            mdvc.firstnameField.text = @"";
            mdvc.surnameField.text = @"";
            mdvc.emailField.text = @"";
            [mdvc.salutationPicker selectRow:0 inComponent:0 animated:NO];
        } else if ([vc isKindOfClass:[QuestionViewController class]]) {
            QuestionViewController *qvc = (QuestionViewController *) vc;
            qvc.responseText.text = @"";
        }
    }
}

- (void) storeResponse {
    for (UIViewController *vc in self.allPages) {
        if ([vc conformsToProtocol:@protocol(OSViewController)]) {
            UIViewController <OSViewController> *osvc = (UIViewController <OSViewController> *) vc;
            [osvc updateUserResponse:self.currentUserResponse];
        }
    }
    [self.objectStore storeObject:self.currentUserResponse];
    [self.objectStore flushToDisk];
    [self startNewUserResponse];
}

- (void) animateArrow:(UIView *) arrowView {
    // Reset all views to starting state
    UIView *tickView;
    UIView *arrowViewFg;
    for (UIView *v in arrowView.subviews) {
        if (v.tag == 1337)
            arrowViewFg = v;
        else if (v.tag == 1338)
            tickView = v;
    }
    tickView.hidden = YES;
    arrowViewFg.hidden = NO;


    // Push the frame off to the side
    CGRect frame = CGRectMake(0, arrowViewFg.frame.origin.y,
                              arrowViewFg.frame.size.width,
                              arrowViewFg.frame.size.height);
    arrowViewFg.frame = frame;

    [UIView animateWithDuration:1 delay:1
                        options:(UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionCurveEaseInOut |
                                 UIViewAnimationOptionAutoreverse |
                                 UIViewAnimationOptionBeginFromCurrentState |
                                 UIViewAnimationOptionRepeat)
                     animations:^ (void) {
                         arrowViewFg.frame = CGRectMake(arrowViewFg.frame.origin.x + 5,
                                                           arrowViewFg.frame.origin.y,
                                                           arrowViewFg.frame.size.width,
                                                           arrowViewFg.frame.size.height);
                     }completion:nil];
}

- (void) animateTickAppearing:(UIView *)arrowView {
    UIImageView *arrowForeground;
    UIImageView *tickForeground;
    for (UIView *v in arrowView.subviews) {
        if (v.tag == 1337)
            arrowForeground = (UIImageView *)v;
        if (v.tag == 1338)
            tickForeground = (UIImageView *)v;
    }

    arrowForeground.frame = CGRectMake(0, arrowForeground.frame.origin.y, arrowForeground.frame.size.width, arrowForeground.frame.size.height);
    [arrowForeground.layer removeAllAnimations];

    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         arrowForeground.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     }
                     completion:^(BOOL finished){
                         arrowForeground.hidden = YES;
                         arrowForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         tickForeground.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         tickForeground.hidden = NO;
                         [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                                          animations:^(void){
                                              tickForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }completion:^(BOOL finished){
                             arrowForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }];
                     }];
}

- (void)animateTickDisappearing:(UIView *)arrowView {
    UIImageView *arrowForeground;
    UIImageView *tickForeground;
    for (UIView *v in arrowView.subviews) {
        if (v.tag == 1337)
            arrowForeground = (UIImageView *)v;
        if (v.tag == 1338)
            tickForeground = (UIImageView *)v;
    }

    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void){
                         tickForeground.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     } completion:^(BOOL finished){
                         tickForeground.hidden = YES;
                         tickForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         arrowForeground.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         arrowForeground.hidden = NO;
                         [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                                          animations:^(void){
                                              arrowForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          } completion:^(BOOL finished){
                                              tickForeground.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
                     }];
}

- (IBAction)nextButtonTouched:(id)sender {
    UIView *arrowView = [self.nextDoneButton.subviews objectAtIndex:0];
    for (UIView *v in arrowView.subviews) {
        UIImageView *imgV;
        if ([v isKindOfClass:[UIImageView class]]) {
            imgV = (UIImageView *)v;
            if (v.tag == 1337) {
                [imgV setImage:self.arrowFG];
            } else if (v.tag == 1336) {
                [imgV setImage:self.arrowBG];
            }
        }
    }

    if (self.currPageIdx + 1 < self.allPages.count) {
        [self.pageViewController setViewControllers:@[self.allPages[self.currPageIdx + 1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.currPageIdx += 1;
    } else if (self.currPageIdx + 1 >= self.allPages.count) {
        self.currPageIdx = 0;
        [self.pageViewController setViewControllers:@[self.allPages[self.currPageIdx]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        [self storeResponse];
        [self animateArrow:arrowView]; // Start the animation again
    }
    self.pageControl.currentPage = self.currPageIdx;

    // When on the last page, update the arrow to a tick
    if (self.currPageIdx == self.allPages.count - 1) {
        [self animateTickAppearing:arrowView];
    }
}

- (IBAction)touchDown:(id)sender {
    UIView *arrowView = [self.nextDoneButton.subviews objectAtIndex:0];
    for (UIView *v in arrowView.subviews) {
        UIImageView *imgV;
        if ([v isKindOfClass:[UIImageView class]]) {
            imgV = (UIImageView *)v;
            if (v.tag == 1337) {
                [imgV setImage:self.arrowFG_HL];
            } else if (v.tag == 1336) {
                [imgV setImage:self.arrowBG_HL];
            }
        }
    }
}

- (IBAction)secretAdminButtonTouched:(id)sender {
    self.adminPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminPage"];
    self.adminPageViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:self.adminPageViewController animated:YES completion:nil];
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
