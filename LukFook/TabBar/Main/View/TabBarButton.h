//
//  TabBarButton.h
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarButtonDelegate <NSObject>

// 代理方法,当点击的时候让代理推出下一个页面(根据tag值)
- (void)pushViewController:(NSInteger)buttonTag;

@end

@interface TabBarButton : UIView

@property(nonatomic,weak)id<TabBarButtonDelegate>delegate;

@end
