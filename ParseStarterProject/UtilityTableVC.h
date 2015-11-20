//
//  UtilityTableVC.h
//  ParseStarterProject
//
//  Created by Samer Rohani on 2015-11-19.
//
//

#import <ParseUI/ParseUI.h>

@protocol UtilityVCDelegate <NSObject>

-(void) usernameSelected:(NSString *)name;

@end

@interface UtilityTableVC : PFQueryTableViewController

@property (nonatomic) NSString *selectedFriend;
@property (nonatomic) id <UtilityVCDelegate> delegate;

@end
