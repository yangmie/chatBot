//
//  MessageListViewController.m
//  MENU
//
//  Created by 楊育宗 on 2016/5/12.
//
//

#import "MessageListViewController.h"
#import "MessageListViewCell.h"
#import "MessageViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "User.h"
#import "UIColor+MENU.h"

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"聊天列表";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;

    [self loadUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - loading

- (void)loadUsers {

    self.userArray = [[NSMutableArray alloc] init];
    self.recentMessages = [[NSMutableArray alloc] init];
    self.unreadMessages = [[NSMutableArray alloc] init];
    self.dates = [[NSMutableArray alloc] init];

    User *user = [[User alloc] initWithUserName:@"yangmie" image:@"yangmie.jpg"];

    [self.userArray insertObject:user atIndex:0];
    [self.recentMessages insertObject:@"在幹嘛" atIndex:0];
    [self.unreadMessages insertObject:[NSNumber numberWithBool:YES] atIndex:0];
    [self.dates insertObject:@"2017.11.09" atIndex:0];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f * mainRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListViewCell"];
    User *user = self.userArray[indexPath.row];
    cell.usernameLabel.text = user.name;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;

    [cell.userImageView setImage:[UIImage imageNamed:user.imageName]];

    cell.messageLabel.text = [NSString stringWithFormat:@"%@", self.recentMessages[indexPath.row]];
    cell.dateLabel.text = self.dates[indexPath.row];

    cell.messageLabel.font = [UIFont systemFontOfSize:13.f weight:UIFontWeightMedium];
    cell.messageLabel.textColor = [UIColor colorWithHex:0x333333 alpha:0.8f];
    cell.usernameLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    cell.usernameLabel.textColor = [UIColor colorWithHex:0x333333 alpha:0.8f];
    cell.dateLabel.font = [UIFont systemFontOfSize:13.f weight:UIFontWeightMedium];
    cell.dateLabel.textColor = [UIColor colorWithHex:0x333333 alpha:0.8f];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    User *user = self.userArray[indexPath.row];

    UIStoryboard *main = [UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    MessageViewController *messageVC = [main instantiateViewControllerWithIdentifier:@"MessageViewController"];
    messageVC.toUser = user;

    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:messageVC];
    navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navi animated:YES completion:nil];
}

@end
