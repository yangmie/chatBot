//
//  MessageListViewController.h
//  MENU
//
//  Created by 楊育宗 on 2016/5/12.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MessageListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, strong) NSMutableArray *recentMessages;
@property (nonatomic, strong) NSMutableArray *unreadMessages;
@property (nonatomic, strong) NSMutableArray *dates;

@end
