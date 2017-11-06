//
//  MessageViewController.h
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import <IGListKit/IGListKit.h>
#import "User.h"

@interface MessageViewController : UIViewController <IGListAdapterDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IGListAdapterDelegate, UITextViewDelegate> {
    UIImagePickerController *cameraUI;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) User *toUser;

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *photoButton;
@property (nonatomic, weak) IBOutlet UIView *blockedView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *blockedLabel;
@property (nonatomic, weak) IBOutlet UIButton *unblockButton;

@end
