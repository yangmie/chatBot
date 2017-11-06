//
//  MessageTextCell.h
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import <UIKit/UIKit.h>

@protocol MessageTextCellDelegate;

@interface MessageTextCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UITextView *messageTextView;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, weak) id<MessageTextCellDelegate> delegate;

@end

@protocol MessageTextCellDelegate <NSObject>

- (void)showUserPage;

@end
