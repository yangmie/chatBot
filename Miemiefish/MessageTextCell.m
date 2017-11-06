//
//  MessageTextCell.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageTextCell.h"
#import "Constants.h"
#import "UIColor+MENU.h"

@implementation MessageTextCell

- (void)drawRect:(CGRect)rect {
    self.imageView.layer.cornerRadius = 17.5f*mainRatio;
    self.imageView.layer.masksToBounds = YES;

    self.layerView.layer.cornerRadius = 7.f;
    self.layerView.layer.masksToBounds = YES;
    self.layerView.layer.borderColor = [UIColor colorWithHex:0x333333 alpha:0.5].CGColor;

    self.messageTextView.selectable = YES;
    self.messageTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHex:0xBA905C alpha:1]};
}

- (IBAction)didTapUserPhotoAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showUserPage)]) {
        [self.delegate showUserPage];
    }
}

@end
