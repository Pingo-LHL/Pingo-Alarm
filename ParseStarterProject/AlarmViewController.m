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
    
    [self registerForPush];
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
    [self registerForPush];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


-(void)registerForPush {
    
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
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
    alarmObject[@"createdBy"] = [PFUser currentUser].username;
    alarmObject[@"createdFor"] = @"sam";
    
    [alarmObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            
            if (alarmObject[@"createdFor"] == [PFUser currentUser].username) {
                [self alarmNotification:self.datePicker.date];
            } else {
                // send a push
                PFQuery *pushAlarm = [PFInstallation query];
                [pushAlarm whereKey:@"username" equalTo:@"sam"]; // Set channel
                
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushAlarm];
                [push setMessage:@"Hey an alarm has been set for you."];
                [push sendPushInBackground];
                
            
            }
        } else {
            // There was a problem, check error.description
        }
    }];
    
    
    
    
}
- (IBAction)cancelAlarm:(id)sender {
    
    NSLog(@"cancel alarm");
}

-(void)retrieveAlarm{
    PFQuery *query = [PFQuery queryWithClassName:@"AlarmObject"];
    
    [query whereKey:@"createdFor" equalTo:[PFUser currentUser].username];
    [query whereKey:@"dateObj" greaterThan:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d alarms.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);

                NSDate *utcTime = object[@"dateObj"];
                NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
                NSLog(@"%f", timeZoneSeconds);
//                NSDate *local = [utcTime dateByAddingTimeInterval:timeZoneSeconds];
                [self alarmNotification:utcTime];
                
                NSLog(@"%@", utcTime);

            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)alarmNotification: (NSDate *) alarmDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM, h:mm:ss a"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    
//    double timeFactor = [alarmDate timeIntervalSinceNow];

        notify.fireDate = alarmDate;
        notify.alertTitle = @"Time: ";
        notify.alertBody = [formatter stringFromDate:alarmDate];
        NSLog(@"%@",notify.alertBody);
        notify.soundName = @"26961__rfriend__divingalarm.wav";
        
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    
}


- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self];
    
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
