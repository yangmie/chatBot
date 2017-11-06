//
//  Message.h
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject

@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSString *iamgeName;
@property (nonatomic) UIImage *iamgeFile;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithMessage:(NSString *)messageString user:(User *)user;
- (instancetype)initWithImage:(NSString *)imageString user:(User *)user;
- (instancetype)initWithImageFile:(UIImage *)image user:(User *)user;

@end
