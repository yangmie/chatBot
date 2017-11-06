//
//  MessageImageCell.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageImageCell.h"
#import "Constants.h"

@implementation MessageImageCell

- (void)drawRect:(CGRect)rect {
    self.imageView.layer.cornerRadius = 17.5f*mainRatio;
    self.imageView.layer.masksToBounds = YES;

    self.layerView.layer.cornerRadius = 7.f;
    self.layerView.layer.masksToBounds = YES;

    self.photoView.layer.cornerRadius = 7.f;
    self.photoView.layer.masksToBounds = YES;
}

@end
