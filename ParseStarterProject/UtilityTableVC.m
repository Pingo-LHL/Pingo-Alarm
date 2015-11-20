//
//  UtilityTableVC.m
//  ParseStarterProject
//
//  Created by Samer Rohani on 2015-11-19.
//
//

#import "UtilityTableVC.h"
#import <Parse/Parse.h>


@interface UtilityTableVC ()

@end

@implementation UtilityTableVC

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"AlarmObject";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFUser query];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"username"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"username"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [object objectForKey:@"mesage"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    self.selectedFriend = selectedCell.textLabel.text;
    NSLog(@"%@", self.selectedFriend);
    
    [self.delegate usernameSelected:self.selectedFriend];
    [self performSelector:@selector(cancelButtonPressed) withObject:nil afterDelay:0.3];
    
}


-(void) cancelButtonPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
