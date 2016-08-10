//
//  UIBarButtonItem+Custom.m
//  LukFook
//
//  Created by lin on 16/2/15.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

// 加标题和背景
- (instancetype)initWithImage:(NSString *)imageName
                        title:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action
{
    self = [self initWithTitle:[NSString showLanguageValue:title] style:style target:target action:action];
    if (self != nil) {
        self.tintColor = [UIColor whiteColor];
        if ([title isEqualToString:@"backItem"]) {
            [self setTitlePositionAdjustment:UIOffsetMake(6, -1) forBarMetrics:UIBarMetricsDefault];
        } else {
            [self setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
        }
        [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    }
    return self;
}

// 加图片和背景
- (instancetype)initWithBackgroundImage:(NSString *)backgroundImageName
                                  image:(NSString *)imageName
                                  style:(UIBarButtonItemStyle)style
                                 target:(id)target
                                 action:(SEL)action
{
    self = [self initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:style target:target action:action];
    if (self != nil) {
        [self setImageInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
        [self setTitlePositionAdjustment:UIOffsetMake(7, -1) forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    }
    return self;
}

@end
