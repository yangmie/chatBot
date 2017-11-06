//
//  MessageInfo.h
//  MENU
//
//  Created by 楊育宗 on 2017/8/11.
//
//

#import <IGListKit/IGListKit.h>
#import "Message.h"

@interface MessageInfo : NSObject <IGListDiffable>

@property (nonatomic, strong) Message *message;
@property (nonatomic, strong) NSDate *date;
- (instancetype)initWithMessage:(Message *)message;
- (instancetype)initWithDate:(NSDate *)date;

@end
