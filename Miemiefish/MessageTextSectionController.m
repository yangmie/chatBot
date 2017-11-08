//
//  MessageTextSectionController.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageTextSectionController.h"
#import "MessageInfo.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "SVModalWebViewController.h"
#import "Message.h"
#import "User.h"
#import "Constants.h"

@interface MessageTextSectionController () <UITextViewDelegate>

@property (nonatomic, strong) Message *message;

@end

@implementation MessageTextSectionController

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - IGListSectionType

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 375*mainRatio*0.6, 100.f)];
    textView.text = self.message.messageString;
    textView.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightRegular];

    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];

    return CGSizeMake(self.collectionContext.containerSize.width, size.height + 24.f*mainRatio);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {

    MessageTextCell *cell;
    User *user = self.message.user;

    if ([user.name isEqualToString:@"miemiefish"]) {
        cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"FromUserCell" forSectionController:self atIndex:index];
        cell.layerView.layer.borderWidth = 0.f;
    } else {
        cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"ToUserCell" forSectionController:self atIndex:index];
        cell.layerView.layer.borderWidth = 0.5f;
    }
    cell.messageTextView.text = self.message.messageString;
    cell.messageTextView.delegate = self;
    
    [cell.imageView setImage:[UIImage imageNamed:user.imageName]];

    cell.dateLabel.text = [[JSQMessagesTimestampFormatter sharedFormatter] timeForDate:self.message.createdAt];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    return cell;
}

- (void)didUpdateToObject:(MessageInfo *)object {
    self.message = object.message;
}

- (void)didSelectItemAtIndex:(NSInteger)index {

}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {

    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:URL.absoluteString];
    [self.viewController presentViewController:webViewController animated:YES completion:nil];

    return NO;
}

@end
