//
//  MessageListViewCell.m
//  MENU
//
//  Created by 楊育宗 on 2016/7/18.
//
//

#import "MessageListViewCell.h"
#import "Constants.h"

@implementation MessageListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.userImageView.layer.cornerRadius = 24*mainRatio;
    self.userImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
