//
//  User.m
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithUserName:(NSString *)name image:(NSString *)imageName {
    self = [super init];
    if (self) {
        _name = name;
        _imageName = imageName;
    }
    return self;
}

@end
