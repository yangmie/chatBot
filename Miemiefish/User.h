//
//  User.h
//  Miemiefish
//
//  Created by 楊育宗 on 2017/11/6.
//  Copyright © 2017年 楊育宗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageName;

- (instancetype)initWithUserName:(NSString *)name image:(NSString *)imageName;

@end
