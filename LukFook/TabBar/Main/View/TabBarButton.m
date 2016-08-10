//
//  TabBarButton.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p1_menu_bg"]];
        NSArray *nameArr = @[@"tabBarButton1",@"tabBarButton2",@"tabBarButton3",@"tabBarButton4"];
        for (int i = 0; i<4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(frame.size.width/4*i, 0, frame.size.width/4, 32);
            //[button setBackgroundImage:[UIImage imageNamed:@"button-bg.png"] forState:UIControlStateNormal];
            [button setTintColor:[UIColor whiteColor]];
            button.titleLabel.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:14];
            NSString *showValue = [NSString showLanguageValue:nameArr[i]];
            [button setTitle:showValue forState:UIControlStateNormal];
            // 设置 tag,把点击的tag值传过去,好判断要推出哪一个页面
            button.tag = i+10086;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (i!=3) {
                UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width-1.5, 5, 1.5, button.frame.size.height-10)];
                line.backgroundColor=[UIColor whiteColor];
                [button addSubview:line];
            }
        }
    }
    return self;
}

- (void)buttonAction:(UIButton *)button
{
    if (self.delegate != nil) {
        [self.delegate pushViewController:button.tag];
    }
}

@end
