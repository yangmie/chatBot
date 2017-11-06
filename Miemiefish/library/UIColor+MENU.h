//
//  UIColor+MENU.h
//  MENU
//
//  Created by cjlin on 2015/4/9.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (MENU)

+ (UIColor *)themeDark;
+ (UIColor *)themeWhite;
+ (UIColor *)themeGold;

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

@end
