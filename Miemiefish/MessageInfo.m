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
        _message = message;
        _date = [NSDate new];
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        _message = [[Message alloc] initWithMessage:@"date message" user:nil];
        _date = [NSDate new];
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
