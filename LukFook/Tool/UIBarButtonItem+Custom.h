//
//  UIBarButtonItem+Custom.h
//  LukFook
//
//  Created by lin on 16/2/15.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

- (instancetype)initWithImage:(NSString *)imageName
                        title:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action;

- (instancetype)initWithBackgroundImage:(NSString *)backgroundImageName
                                  image:(NSString *)imageName
                                  style:(UIBarButtonItemStyle)style
                                 target:(id)target
                                 action:(SEL)action;

@end
