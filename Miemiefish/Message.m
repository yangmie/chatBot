//
//  Message.m
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithMessage:(NSString *)messageString {
    self = [super init];
    if (self) {
        _messageString = messageString;
        _createdAt = [NSDate new];
    }
    return self;
}

- (instancetype)initWithImage:(NSString *)imageString {
    self = [super init];
    if (self) {
        _iamgeName = imageString;
        _createdAt = [NSDate new];
    }
    return self;
}

@end
