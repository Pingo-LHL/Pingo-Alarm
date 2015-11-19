//
//  AlarmViewController.m
//  ParseStarterProject
//
//  Created by Kelo Akalamudo on 11/18/15.
//
//

#import "AlarmViewController.h"
#import <Parse/Parse.h>

@interface AlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmPicker;

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

 #pragma mark - Alarm Functions
- (IBAction)setAlarm:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateFormat.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormat stringFromDate:self.datePicker.date];
    NSLog(@"%@",dateString);
    
    
    PFObject *alarmObject = [PFObject objectWithClassName:@"AlarmObject"];
    alarmObject[@"dateObj"] = self.datePicker.date;
    
   
    [alarmObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];
    [self alarmNotification:self.datePicker.date];
    
}
- (IBAction)cancelAlarm:(id)sender {
    
    NSLog(@"cancel alarm");
}

-(void)retriveAlarm{
    PFQuery *query = [PFQuery queryWithClassName:@"AlarmObject"];
    [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *alarmObject, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"%@", alarmObject);
    }];

}

- (void)alarmNotification: (NSDate *) alarmDate {
    
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    
    notify.fireDate = alarmDate;
    notify.alertTitle = @"wake up!";
    notify.alertBody = @"TA meeting";
    //    notify.soundName = @""
    
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    
    
//    // get date from NSDatePicker
//    NSDate *date = [datePicker date];
//    
//    // format the NSDate to a NSString
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
//    NSString *dateString = [dateFormat stringFromDate:date];
//    
//    // save to Parse
//    PFObject *addValues= [PFObject objectWithClassName:@"your-class"];
//    [addValues setObject: dateString forKey:@"your-key"];
//    [addValues saveInBackground];
//    
    
}


- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self];
    
//     [logInViewController setSignUpController:signUpViewController];
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
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
