//
//  MessageListViewCell.h
//  MENU
//
//  Created by 楊育宗 on 2016/7/18.
//
//

#import <UIKit/UIKit.h>

@interface MessageListViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end
