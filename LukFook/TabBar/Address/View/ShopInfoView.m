//
//  ShopInfoView.m
//  LukFook
//
//  Created by lin on 16/1/28.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ShopInfoView.h"

#define RIGHTLABELWIDTH (frame.size.width-115-15)

@interface ShopInfoView () {
    NSString *_appLanguageStr;
}

//@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *nameInfoLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *phoneInfoLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *addressInfoLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeInfoLabel;

@property (strong,nonatomic) UIButton *button;

// 保存label的高度
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)CGFloat totalHeight;

@end

@implementation ShopInfoView

- (instancetype)initWithFrame:(CGRect)frame
                        model:(AddressModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth=1.5;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.layer.masksToBounds = YES;
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameInfoLabel = [[UILabel alloc] init];
        self.phoneLabel = [[UILabel alloc] init];
        self.phoneInfoLabel = [[UILabel alloc] init];
        self.addressLabel = [[UILabel alloc] init];
        self.addressInfoLabel = [[UILabel alloc] init];
        self.timeLabel = [[UILabel alloc] init];
        self.timeInfoLabel = [[UILabel alloc] init];
        
        self.height = 0;
        self.totalHeight = 0;
        
//        "shopName" = "Shop Name";
//        "shopPhone" = "Tel";
//        "shopAddress" = "Address";
//        "shopTime" = "Opening Hour";
        NSString *shopName;
        NSString *addressStr;
        // 根据语言的不同选择不同的字
        _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
        if ([_appLanguageStr isEqualToString:@"zh-Hant"]) {
            shopName = model.title_ch;
            addressStr = model.address_ch;
        } else if ([_appLanguageStr isEqualToString:@"zh-Hans"]) {
            shopName = model.title_zh;
            addressStr = model.address_zh;
        } else {
            shopName = model.title_en;
            addressStr = model.address_en;
        }
        
        [self buildLabelStyleWithLabel:self.nameLabel rect:CGRectMake(0, 15, 100, 20) text:[NSString showLanguageValue:@"shopName"] flag:YES lines:1];
        [self buildLabelStyleWithLabel:self.nameInfoLabel rect:CGRectMake(100+15, 15, RIGHTLABELWIDTH, 20) text:shopName flag:NO lines:1];
        
        [self buildLineViewWithRect:CGRectMake(0, 40+8, frame.size.width, 1)];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.button];
        
        [self buildLabelStyleWithLabel:self.phoneLabel rect:CGRectMake(0, 49+10, 100, 20) text:[NSString showLanguageValue:@"shopPhone"] flag:YES lines:1];
        [self buildLabelStyleWithLabel:self.phoneInfoLabel rect:CGRectMake(115, 59, RIGHTLABELWIDTH, 20) text:model.phone flag:NO lines:1];
        self.button.frame = CGRectMake(0, 49, frame.size.width, 13+self.height+11);
        [self.button setBackgroundImage:[UIImage imageNamed:@"button_background.png"] forState:UIControlStateSelected];
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self buildLineViewWithRect:CGRectMake(0, 59+self.height+13, frame.size.width, 1)];
        
        [self buildLabelStyleWithLabel:self.addressLabel rect:CGRectMake(0, 59+self.height+11+13, 100, 20) text:[NSString showLanguageValue:@"shopAddress"] flag:YES lines:1];
        [self buildLabelStyleWithLabel:self.addressInfoLabel rect:CGRectMake(115, 59+self.height+11+13, RIGHTLABELWIDTH, 20) text:addressStr flag:NO lines:0];

        [self buildLineViewWithRect:CGRectMake(0, self.totalHeight+13, frame.size.width, 1)];

        [self buildLabelStyleWithLabel:self.timeLabel rect:CGRectMake(0, self.totalHeight+8+15, 100, 20) text:[NSString showLanguageValue:@"shopTime"] flag:YES lines:1];
        [self buildLabelStyleWithLabel:self.timeInfoLabel rect:CGRectMake(115, self.totalHeight+8+15, RIGHTLABELWIDTH, 20) text:model.hours_ch flag:NO lines:1];
        
        // 添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

// 点击方法
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    // 如果按钮是处于被选中状态,那么改为不被选中,改变字体颜色
    if (self.button.selected) {
        self.button.selected = NO;
        self.phoneInfoLabel.textColor = [UIColor blackColor];
        self.phoneLabel.textColor = RGBCOLOR(40, 60, 130, 1);
    }
}

// 点击拔打电话
- (void)buttonAction:(UIButton *)button
{
    // 让按钮处于被选中状态,改变选中的字体颜色
    button.selected = YES;
    self.phoneInfoLabel.textColor = [UIColor whiteColor];
    self.phoneLabel.textColor = [UIColor whiteColor];
    if (self.delegate != nil) {
        [self.delegate callTheShopPhone];
    }
}

// 设置label
- (void)buildLabelStyleWithLabel:(UILabel *)label
                            rect:(CGRect)rect
                            text:(NSString *)str
                            flag:(BOOL)flag lines:(int)lines;
{
    label.frame = rect;
    label.text = str;
//    label.userInteractionEnabled = YES;
    // 如果 flag 是 yes, 那就是设置左边的格式
    if (flag) {
        label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:16];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = RGBCOLOR(40, 60, 130, 1);
    } else {
        label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:16];
        label.numberOfLines = lines;
        if (lines==0) {
            [label sizeToFit];
        }
        self.height = label.bounds.size.height;
        self.totalHeight = label.frame.origin.y + label.bounds.size.height;
    }
    
    if ([str isEqualToString:@"Opening Hour"]) {
        label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:15];
    }
//
//    if ([str isEqualToString:@"Shop Name"]) {
//        label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:14];
//    }
    
    [self addSubview:label];
}

// 设置中间的分割线
- (void)buildLineViewWithRect:(CGRect)rect
{
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

// 算出整个VIEW的高度
- (CGFloat)getHeightOfView
{
//    NSLog(@"%f",self.totalHeight);
    return self.totalHeight;
}

// 根据自适应改变高度
- (void)layoutSubviews
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.totalHeight+20);
}

@end
