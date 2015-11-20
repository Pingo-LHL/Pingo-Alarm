//
//  AlarmViewController.h
//  ParseStarterProject
//
//  Created by Kelo Akalamudo on 11/18/15.
//
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "UtilityTableVC.h"

@interface AlarmViewController : UIViewController   <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UtilityVCDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

-(void)retrieveAlarm;

@end
