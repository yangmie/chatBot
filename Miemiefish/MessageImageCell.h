//
//  MessageImageCell.h
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import <UIKit/UIKit.h>

@interface MessageImageCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end
