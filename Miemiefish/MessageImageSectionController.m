//
//  MessageImageSectionController.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageImageSectionController.h"
#import "MessageImageCell.h"
#import "MessageInfo.h"
#import "JTSImageViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "Message.h"
#import "User.h"
#import "Constants.h"

@interface MessageImageSectionController ()

@property (nonatomic, strong) Message *message;

@end

@implementation MessageImageSectionController

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
    return CGSizeMake(self.collectionContext.containerSize.width, 170*mainRatio);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {

    MessageImageCell *cell;
    User *user = self.message.user;

    if ([user.name isEqualToString:@"miemiefish"]) {
        cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"FromUserImageCell" forSectionController:self atIndex:index];
    } else {
        cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"ToUserImageCell" forSectionController:self atIndex:index];
    }

    [cell.imageView setImage:[UIImage imageNamed:user.imageName]];
    [cell.photoView setImage:[UIImage imageNamed:self.message.iamgeName]];

//    cell.dateLabel.text = [[JSQMessagesTimestampFormatter sharedFormatter] timeForDate:self.message.createdAt];

    return cell;
}

- (void)didUpdateToObject:(MessageInfo *)object {
    self.message = object.message;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    // Create image info
    MessageImageCell *cell = [self.collectionContext cellForItemAtIndex:index sectionController:self];

    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.photoView.image;
    imageInfo.referenceRect = self.viewController.view.frame;
    imageInfo.referenceView = self.viewController.view;

    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];

    // Present the view controller.
    [imageViewer showFromViewController:self.viewController transition:JTSImageViewControllerTransition_FromOffscreen];
}

@end
