//
//  MessageDateSectionController.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/14.
//
//

#import "MessageDateSectionController.h"
#import "MessageInfo.h"
#import "MessageDateCell.h"
#import <JSQMessagesViewController/JSQMessages.h>

@interface MessageDateSectionController ()

@property (nonatomic, strong) NSDate *date;

@end

@implementation MessageDateSectionController

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
    return CGSizeMake(self.collectionContext.containerSize.width, 45.f);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {

    MessageDateCell *cell = [self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:@"MessageDateCell" forSectionController:self atIndex:index];

    cell.dateLabel.attributedText = [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:self.date];

    return cell;
}

- (void)didUpdateToObject:(MessageInfo *)object {
    self.date = object.date;
}

- (void)didSelectItemAtIndex:(NSInteger)index {

}

@end
