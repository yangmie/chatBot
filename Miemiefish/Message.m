//
//  Message.m
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithMessage:(NSString *)messageString user:(User *)user {
    self = [super init];
    if (self) {
        _messageString = messageString;
        _createdAt = [NSDate new];
        _user = user;
    }
    return self;
}

- (instancetype)initWithImage:(NSString *)imageString user:(User *)user {
    self = [super init];
    if (self) {
        _iamgeName = imageString;
        _createdAt = [NSDate new];
        _user = user;
    }
    return self;
}

- (instancetype)initWithImageFile:(UIImage *)image user:(User *)user {
    self = [super init];
    if (self) {
        _iamgeFile = image;
        _createdAt = [NSDate new];
        _user = user;
    }
    return self;
}

@end
