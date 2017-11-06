//
//  Message.h
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject

@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSString *iamgeName;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithMessage:(NSString *)messageString;
- (instancetype)initWithImage:(NSString *)imageString;

@end
