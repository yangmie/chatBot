//
//  UIColor+MENU.m
//  MENU
//
//  Created by cjlin on 2015/4/9.
//
//

#import "UIColor+MENU.h"

@implementation UIColor (MENU)

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
	return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}
+ (UIColor *)themeDark { return [UIColor colorWithR:25 G:25 B:25 A:1]; }
+ (UIColor *)themeWhite { return [UIColor colorWithHex:0xF9F9F9 alpha:1]; }
+ (UIColor *)themeGold { return [UIColor colorWithHex:0xc1961e alpha:1]; }

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
						   green:((float)((hex & 0x00FF00) >>  8))/255.0
							blue:((float)((hex & 0x0000FF) >>  0))/255.0
						   alpha:alpha];
}

@end
