//
//  AlarmViewController.m
//  ParseStarterProject
//
//  Created by Kelo Akalamudo on 11/18/15.
//
//

#import "AlarmViewController.h"

@interface AlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmPicker;

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setAlarm:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateFormat.timeStyle = NSDateFormatterShortStyle;
    
    
    NSString *dateString = [dateFormat stringFromDate:self.datePicker.date];
    NSLog(@"%@",dateString);
    
    [self alarmNotification:self.datePicker.date];
    
}
- (IBAction)cancelAlarm:(id)sender {
    
    NSLog(@"cancel alarm");
}

- (void)alarmNotification: (NSDate *) alarmDate {
    
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    
    notify.fireDate = alarmDate;
    notify.alertTitle = @"wake up!";
    notify.alertBody = @"TA meeting";
    //    notify.soundName = @""
    
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    
    
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
