//
//  MessageViewController.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageViewController.h"
#import "MessageInfo.h"
#import "MessageTextSectionController.h"
#import "MessageImageSectionController.h"
#import "AppDelegate.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "MessageDateSectionController.h"
#import "UIColor+MENU.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MessageViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL blocked;
@property (nonatomic) BOOL muted;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];


    self.title = self.toUser.name;

//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage @""]
//                                                                style:UIBarButtonItemStylePlain
//                                                               target:self
//                                                               action:@selector(dismissVC)];
//    backBtn.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = backBtn;

    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.delegate = self;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTap.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:singleTap];

    [self.sendButton setTitle:@"送出" forState:UIControlStateNormal];
    self.sendButton.layer.borderWidth = 1.f;
    self.sendButton.layer.borderColor = [UIColor colorWithHex:0x333333 alpha:0.5f].CGColor;
    self.sendButton.layer.cornerRadius = 4.f;
    self.sendButton.layer.masksToBounds = YES;

    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateHighlighted];

    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.textView.delegate = self;
    self.textView.text = @"輸入訊息...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.scrollEnabled = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(4, 0, 0, 0);

    self.unblockButton.layer.cornerRadius = 15.f;
    self.unblockButton.layer.masksToBounds = YES;

    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10.f*mainRatio, 0);

    self.messages = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.textView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dismissKeyboard {
    [self.textView resignFirstResponder];
}

- (void)refreshLayout {
    [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#define MenuMessagesQueryLimit 20

//- (void)loadMessageFromParseWithSkip:(BOOL)isSkip {
//    if (self.isLoading) {
//        return;
//    }
//
//    self.isLoading = YES;
//    PFQuery *fromUserQuery = [PFQuery queryWithClassName:MenuMessageKeyClass];
//    [fromUserQuery whereKey:MenuMessageKeyFromUser equalTo:[PFUser currentUser]];
//    [fromUserQuery whereKey:MenuMessageKeyToUser equalTo:self.toUser];
//
//    PFQuery *toUserQuery = [PFQuery queryWithClassName:MenuMessageKeyClass];
//    [toUserQuery whereKey:MenuMessageKeyToUser equalTo:[PFUser currentUser]];
//    [toUserQuery whereKey:MenuMessageKeyFromUser equalTo:self.toUser];
//
//    PFQuery *settingQuery = [PFQuery queryWithClassName:MenuTalkSettingsKeyClass];
//    [settingQuery whereKey:MenuTalkSettingsKeyFromUser equalTo:[PFUser currentUser]];
//    [settingQuery whereKey:MenuTalkSettingsKeyType equalTo:@"block"];
//
//    PFQuery *query = [PFQuery orQueryWithSubqueries:@[fromUserQuery, toUserQuery]];
//    [query includeKey:MenuMessageKeyFromUser];
//    [query includeKey:MenuMessageKeyToUser];
//    [query setLimit:MenuMessagesQueryLimit];
//    if (self.blocked) {
//        [query whereKey:MenuMessageKeyFromUser doesNotMatchKey:MenuTalkSettingsKeyToUser inQuery:settingQuery];
//        [query whereKey:MenuMessageKeyToUser doesNotMatchKey:MenuTalkSettingsKeyToUser inQuery:settingQuery];
//    }
//    NSInteger skip = 0;
//    for (MessageInfo *m in self.messages) {
//        if (!m.date) {
//            skip += 1;
//        }
//    }
//
//    if (isSkip) query.skip = skip;
//    [query orderByDescending:MenuMessageKeyCreatedAt];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
//        if (!error) {
//            if (messages.count == 0 && !isSkip) {
//                if (self.blocked) {
//                    [self.messages removeAllObjects];
//                    [self.adapter performUpdatesAnimated:YES completion:nil];
//                } else if ([self.toUser.objectId isEqualToString:menuTaiwanID]) {
//                    PFObject *messageObj = [PFObject objectWithClassName:MenuMessageKeyClass];
//                    [messageObj setValue:[PFUser currentUser] forKey:MenuMessageKeyToUser];
//                    [messageObj setValue:self.toUser forKey:MenuMessageKeyFromUser];
//                    [messageObj setValue:kLocaleMenutalkWelcomeMessage forKey:MenuMessageKeyMessage];
//                    [messageObj saveInBackground];
//                }
//                self.isLoading = NO;
//
//
//            } else if (messages.count > 0) {
//
//                NSInteger previousCount = self.messages.count;
//                if (!isSkip) {
//                    [self.messages removeAllObjects];
//                }
//
//                for (PFObject *message in messages) {
//
//                    MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];
//
//                    if (![self isMessageExisted:mInfo]) {
//                        [self.messages addObject:mInfo];
//                    }
//                }
//                self.messages = [[self.messages sortedArrayUsingFunction:recentMessagesSort context:nil] mutableCopy];
//
//                MessageInfo *lastInfo = [self.messages lastObject];
//                PFObject *lastMessage = lastInfo.message;
//                if ([lastMessage[MenuMessageKeyToUser] isEqualToUser:[PFUser currentUser]]) {
//                    [PFCloud callFunctionInBackground:@"setMessageRead" withParameters:@{@"messageId":lastMessage.objectId}];
//                }
//
//                if (self.messages.count > 1) {
//                    for (NSInteger i = self.messages.count - 1; i > 0; i --) {
//                        MessageInfo *previousMessage = self.messages[i-1];
//                        MessageInfo *currentMessage = self.messages[i];
//
//                        if (previousMessage.date || currentMessage.date) {
//                            continue;
//                        }
//
//                        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:currentMessage.message.createdAt];
//                        NSDateComponents *previousComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:previousMessage.message.createdAt];
//
//                        if ([components day] != [previousComponents day]) {
//                            MessageInfo *m = [[MessageInfo alloc] initWithDate:currentMessage.message.createdAt];
//                            [self.messages insertObject:m atIndex:i];
//                        }
//                    }
//                } else if (self.messages.count == 1) {
//                    MessageInfo *currentMessage = self.messages[0];
//                    if (!currentMessage.date) {
//                        MessageInfo *m = [[MessageInfo alloc] initWithDate:currentMessage.message.createdAt];
//
//                        [self.messages insertObject:m atIndex:0];
//
//                    }
//                }
//
//                [self.adapter performUpdatesAnimated:NO completion:^(BOOL finished) {
//                    if (finished) {
//                        if (!isSkip) {
//                            [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
//                        } else {
//                            [self.adapter scrollToObject:self.messages[self.messages.count - previousCount - 1] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionNone animated:NO];
//                        }
//
//                        self.isLoading = NO;
//                    }
//                }];
//            }
//
//        }
//    }];
//}

NSInteger recentMessagesSort(MessageInfo *message1, MessageInfo *message2, void *context) {
    NSDate *date1 = message1.message.createdAt;
    NSDate *date2 = message2.message.createdAt;

    if (message1.date) {
        date1 = message1.date;
    }

    if (message2.date) {
        date2 = message2.date;
    }

    return [date1 compare:date2];
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.messages;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if (((MessageInfo *)object).date) {
        MessageDateSectionController *messageDateSectionController = [[MessageDateSectionController alloc] init];
        return messageDateSectionController;
    } else {
        Message *message = ((MessageInfo *)object).message;
        if (message.messageString.length > 0) {
            MessageTextSectionController *messageTextSectionController = [[MessageTextSectionController alloc] init];
            return messageTextSectionController;
        } else {
            MessageImageSectionController *messageImageSectionController = [[MessageImageSectionController alloc] init];
            return messageImageSectionController;
        }
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListAdapterDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplayObject:(id)object atIndex:(NSInteger)index {

}
- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingObject:(id)object atIndex:(NSInteger)index {

}


#pragma mark - Custom Accessors

- (IGListAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init]
                                           viewController:self
                                         workingRangeSize:15];
    }
    return _adapter;
}

#pragma mark - IBActions 

- (IBAction)sendButtonAction:(id)sender {
    if (self.textView.text.length == 0) {
        return;
    }

//    PFObject *messageObj = [PFObject objectWithClassName:MenuMessageKeyClass];
//    [messageObj setValue:[PFUser currentUser] forKey:MenuMessageKeyFromUser];
//    [messageObj setValue:self.toUser forKey:MenuMessageKeyToUser];
//    [messageObj setValue:self.textView.text forKey:MenuMessageKeyMessage];
//
//    MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:messageObj];
//
//    [self.messages addObject:mInfo];
//
//    [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
//        if (finished) {
//            [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
//
//            [messageObj saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
//                if (!error) {
//
//                    for (NSInteger i = 0; i < self.messages.count; i ++) {
//                        MessageInfo *m = self.messages[i];
//                        if ([m.message isEqualToObject:messageObj]) {
//                            MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:messageObj];
//                            [self.messages replaceObjectAtIndex:i withObject:mInfo];
//                            [self.adapter reloadObjects:@[mInfo]];
//                            break;
//                        }
//                    }
//                }
//            }];
//
//        }
//    }];

    self.textView.text = @"";

    self.sendButton.layer.borderWidth = 1.f;
    self.sendButton.layer.borderColor = [UIColor colorWithHex:0x333333 alpha:0.5f].CGColor;
    self.sendButton.layer.cornerRadius = 4.f;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.backgroundColor = [UIColor clearColor];

    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateHighlighted];
}

- (IBAction)photoButtonAction:(id)sender {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }

    cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {

        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];

    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {

        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];

    }

    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;

    cameraUI.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - UIImagePickerVC delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

//    [UIAlertController showAlertInViewController:picker
//                                       withTitle:nil
//                                         message:kLocaleMenutalkWarning
//                               cancelButtonTitle:kLocaleMenutalkCancel
//                          destructiveButtonTitle:nil
//                               otherButtonTitles:@[@"確定"]
//                                        tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
//                                            if ([action.title isEqualToString:@"確定"]) {
//                                                [cameraUI dismissViewControllerAnimated:YES completion:nil];
//
//                                                UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//                                                originalImage = [UIImage scaleAndRotateImage:originalImage];
//
//                                                PFObject *messageObj = [PFObject objectWithClassName:MenuMessageKeyClass];
//                                                [messageObj setObject:[PFUser currentUser] forKey:MenuMessageKeyFromUser];
//                                                [messageObj setObject:self.toUser forKey:MenuMessageKeyToUser];
//                                                [messageObj setObject:[PFFile fileWithData:UIImagePNGRepresentation(originalImage) contentType:@"image/png"] forKey:MenuMessageKeyImage];
//                                                [messageObj saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
//                                                    if (!error) {
//                                                        MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:messageObj];
//
//                                                        [self.messages addObject:mInfo];
//
//                                                        [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
//                                                            if (finished) {
//                                                                [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
//                                                            }
//                                                        }];
//
//                                                    }
//                                                }];
//                                            }
//                                        }];

}

#pragma mark - textView delegate

- (void)textViewDidChange:(UITextView *)textView {

    if (textView.text.length > 0) {
        self.sendButton.backgroundColor = [UIColor colorWithHex:0x4990E2 alpha:1];
        [self.sendButton setTitleColor:[UIColor colorWithHex:0xffffff alpha:1] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor colorWithHex:0xffffff alpha:0.8] forState:UIControlStateHighlighted];

        self.sendButton.layer.borderWidth = 0.f;
    } else {
        self.sendButton.layer.borderWidth = 1.f;
        self.sendButton.layer.borderColor = [UIColor colorWithHex:0x333333 alpha:0.5f].CGColor;
        self.sendButton.layer.cornerRadius = 4.f;
        self.sendButton.layer.masksToBounds = YES;
        self.sendButton.backgroundColor = [UIColor clearColor];

        [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateHighlighted];
    }
}

- (void)textViewDidBeginEditing:(UITextField *)textView {
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

    if ([textView.text isEqualToString:@"輸入訊息..."]) {
        textView.text = @"";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];
        [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular], NSForegroundColorAttributeName: [UIColor colorWithHex:0x333333 alpha:0.8], NSKernAttributeName:@(0.0f)} range:[textView.text rangeOfString:textView.text]];
        [textView setAttributedText:string];

        textView.textColor = [UIColor colorWithHex:0x333333 alpha:0.8f];
        textView.font = [UIFont systemFontOfSize:16];
    }
}

- (void)textViewDidEndEditing:(UITextField *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"輸入訊息...";
        textView.textColor = [UIColor lightGrayColor];
    }
}

@end
