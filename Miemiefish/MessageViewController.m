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
#import "IQKeyboardManager.h"
#import "UIImage+MENU.h"
#import "UIAlertController+Blocks.h"

@interface MessageViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL finalMessage;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];


    self.title = self.toUser.name;

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backkey"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(dismissVC)];
    backBtn.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backBtn;

    self.automaticallyAdjustsScrollViewInsets = NO;

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLayout) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLayout) name:UIKeyboardDidHideNotification object:nil];

    self.messages = [[NSMutableArray alloc] init];
    [self loadMessages];
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

- (void)loadMessages {

    NSMutableArray *messages = [NSMutableArray new];
    Message *message = [[Message alloc] initWithMessage:@"結餘" user:self.toUser];
    [messages addObject:message];

    message = [[Message alloc] initWithMessage:@"在幹嘛" user:self.toUser];
    [messages addObject:message];

    for (Message *message in messages) {
        MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];
        [self.messages addObject:mInfo];
    }

    self.messages = [[self.messages sortedArrayUsingFunction:recentMessagesSort context:nil] mutableCopy];

    [self.adapter performUpdatesAnimated:NO completion:^(BOOL finished) {
        if (finished) {
            [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
            self.isLoading = NO;
        }
    }];
}

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

    Message *message = ((MessageInfo *)object).message;
    if (message.messageString.length > 0) {
        MessageTextSectionController *messageTextSectionController = [[MessageTextSectionController alloc] init];
        return messageTextSectionController;
    } else {
        MessageImageSectionController *messageImageSectionController = [[MessageImageSectionController alloc] init];
        return messageImageSectionController;
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

    NSString *meesageString = self.textView.text;

    User *miemiefish = [[User alloc] initWithUserName:@"miemiefish" image:@"miemiefish.jpg"];
    Message *message = [[Message alloc] initWithMessage:meesageString user:miemiefish];
    MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];
    [self.messages addObject:mInfo];

    [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
        if (finished) {
            [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];

            [self sendAutuReply:meesageString];
        }
    }];

    self.textView.text = @"";

    self.sendButton.layer.borderWidth = 1.f;
    self.sendButton.layer.borderColor = [UIColor colorWithHex:0x333333 alpha:0.5f].CGColor;
    self.sendButton.layer.cornerRadius = 4.f;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.backgroundColor = [UIColor clearColor];

    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.5] forState:UIControlStateHighlighted];
}

- (void)sendAutuReply:(NSString *)message {

    [NSTimer scheduledTimerWithTimeInterval:1.f repeats:NO block:^(NSTimer * _Nonnull timer) {

        id reply = [self generateReplyFromString:message];
        if ([reply isKindOfClass:[UIImage class]]) {
            Message *message = [[Message alloc] initWithImageFile:reply user:self.toUser];
            MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];
            [self.messages addObject:mInfo];
        } else {
            Message *message = [[Message alloc] initWithMessage:reply user:self.toUser];
            MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];
            [self.messages addObject:mInfo];
        }

        [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }];
    }];
}

- (id)generateReplyFromString:(NSString *)string {

    if (self.messages.count > 100 && !self.finalMessage) {
        self.finalMessage = YES;
        return @"結餘, 想不到你可以跟機器人玩成這樣, 想必以後是不需要密我本人了, 請直接跟機器人對談即可 :)\n\n雖然寫個app這種事情根本就工程師老梗, 但是還沒有用過勢必要用一下\n\n今年就這樣堂堂邁入十週年, 所以卡片也是電子化, 外加可以隨時上傳新版更新卡片內容(但是這件事情理論上不會發生), 節能減碳愛地球, 484很簡單呢?\n\n話說要觸發這一段需要對話超過100則, 而且上一頁以後對話就都自動銷毀, 要再看一次這個簡直困難, 我猜你一定會先上一頁以後才發現對話居然都不見了, 然後又重新累積一次:)\n\n根據我對你的了解, 這一則一定會被截圖, 所以有些東西不能打出來的我也就不增加你修圖的麻煩了, 簡直貼心\n\n28歲生日快樂:)\n28歲生日快樂:)\n28歲生日快樂:)\n28歲生日快樂:)\n28歲生日快樂:)\n28歲生日快樂:)\n";
    }

    if ([string containsString:@"阿胖"]) {
        return [UIImage imageNamed:@"raku2.png"];
    } else if ([string containsString:@"寶貝"] || [string containsString:@"阿咩"]) {
        return [UIImage imageNamed:@"raku1.png"];
    } else if ([string containsString:@"老公"] || [string containsString:@"腦瓜"]) {
        return [UIImage imageNamed:@"raku3.png"];
    } else if ([string containsString:@"老婆"] || [string containsString:@"腦皮"]) {
        return [UIImage imageNamed:@"raku4.png"];
    } else if ([string containsString:@"欸欸"]) {
        return [UIImage imageNamed:@"bird11.png"];
    } else if ([string containsString:@"欸"]) {
        return [UIImage imageNamed:@"bird8.png"];
    } else if ([string containsString:@"天阿"] || [string containsString:@"天啊"]) {
        return [UIImage imageNamed:@"bird5.png"];
    } else if ([string containsString:@"= ="]) {
        return [UIImage imageNamed:@"rabbit3.png"];
    } else if ([string containsString:@"慘"]) {
        return [UIImage imageNamed:@"rabbit5.png"];
    } else if ([string containsString:@"在幹嘛"] || [string containsString:@"你在哪"]) {
        return [UIImage imageNamed:@"bird10.png"];
    } else if ([string containsString:@"我要去"]) {
        return [UIImage imageNamed:@"bird3.png"];
    } else if ([string containsString:@"瘋"]) {
        return [UIImage imageNamed:@"bird9.png"];
    } else if ([string containsString:@"崩潰"]) {
        return [UIImage imageNamed:@"bird11.png"];
    } else if ([string containsString:@"==="]) {
        return [UIImage imageNamed:@"bird1.png"];
    } else if ([string containsString:@"我跟你說"]) {
        return [UIImage imageNamed:@"bird7.png"];
    } else if ([string containsString:@"生氣"]) {
        return [UIImage imageNamed:@"bird4.png"];
    } else if ([string containsString:@"睡"]) {
        return [UIImage imageNamed:@"rabbit1.png"];
    } else {
        int index = arc4random() % 2;
        if (index == 0) {
            NSArray *imageArray = @[@"bird1.png", @"bird2.png", @"bird3.png", @"bird4.png", @"bird5.png", @"bird6.png", @"bird7.png", @"bird8.png", @"rabbit6.png", @"rabbit1.png", @"rabbit2.png", @"rabbit3.png", @"rabbit4.png", @"rabbit5.png", @"cat1.png", @"cat2.png", @"cat3.png", @"cat4.png", @"cat5.png", @"cat6.png", @"cat7.png", @"cat8.png", @"cat9.png", @"cat10.png", @"cat11.png", @"cat12.png"];
            int imageIndex = arc4random() % imageArray.count;
            return [UIImage imageNamed:imageArray[imageIndex]];
        } else {
            NSArray *stringArray = @[@"結餘\n在幹嘛", @"活該", @"可ㄆ", @"結餘 是不是在搞", @"抓到", @"已經沒有那個必要了", @"跟你媽講", @"離ㄆ", @"扯", @"😯", @"喝", @"不行", @"蛤", @"zz", @"不好ㄅ", @"結餘 他媽為什麼還不去睡", @"練琴囉", @"...", @"慘"];
            int imageIndex = arc4random() % stringArray.count;
            return stringArray[imageIndex];
        }
    }
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

    [UIAlertController showAlertInViewController:picker
                                       withTitle:nil
                                         message:@"確定要傳送這張照片嗎? 他其實根本不會傳給yangmie, 這是一個無用的功能."
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@[@"確定"]
                                        tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                                            if ([action.title isEqualToString:@"確定"]) {
                                                [cameraUI dismissViewControllerAnimated:YES completion:nil];

                                                UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                                                originalImage = [UIImage scaleAndRotateImage:originalImage];

                                                User *miemiefish = [[User alloc] initWithUserName:@"miemiefish" image:@"miemiefish.jpg"];
                                                Message *message = [[Message alloc] initWithImageFile:originalImage user:miemiefish];
                                                MessageInfo *mInfo = [[MessageInfo alloc] initWithMessage:message];

                                                [self.messages addObject:mInfo];

                                                [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
                                                    if (finished) {
                                                        [self.adapter scrollToObject:[self.messages lastObject] supplementaryKinds:nil scrollDirection:UICollectionViewScrollDirectionVertical scrollPosition:UICollectionViewScrollPositionTop animated:NO];
                                                    }
                                                }];
                                            }
                                        }];

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
