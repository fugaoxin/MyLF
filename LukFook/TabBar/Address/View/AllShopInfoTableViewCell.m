//
//  AllShopInfoTableViewCell.m
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AllShopInfoTableViewCell.h"

@interface AllShopInfoTableViewCell () {
    NSString *_appLanguageStr;
}
@property (nonatomic,strong) UILabel * title1Label;

@end

@implementation AllShopInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCell.png"]];
    self.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:238/255.0 alpha:1];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, 90-1.5, SCREENWIDTH, 1.5)];
    line.backgroundColor=[UIColor colorWithRed:212/255.0 green:209/255.0 blue:204/255.0 alpha:1];
    [self addSubview:line];
    
    self.title1Label=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREENWIDTH-55, 50)];
    self.title1Label.font=[UIFont fontWithName:@"MJNgaiHK-Medium" size:19];
    self.title1Label.textColor=[UIColor colorWithRed:76/255.0 green:36/255.0 blue:14/255.0 alpha:1];
    [self addSubview:self.title1Label];
}

- (void)setModel:(AllShopInfoModel *)model
{
    _model = model;
    // 根据语言的不同选择不同的字
    _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    //self.nameLabel.text = [[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:_appLanguageStr];
    self.title1Label.text = [[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:_appLanguageStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
