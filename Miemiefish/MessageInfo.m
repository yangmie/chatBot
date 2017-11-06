//
//  MessageInfo.m
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import "MessageInfo.h"

@implementation MessageInfo

- (instancetype)initWithMessage:(Message *)message {
    if (self = [super init]) {
        self.message = message;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.message = [[Message alloc] initWithMessage:@"date message"];
        self.date = date;
    }
    return self;
}

#pragma mark - IGListDiffable

- (nonnull id<NSObject>)diffIdentifier {
    return self.date;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self isEqual:object];
}

@end
