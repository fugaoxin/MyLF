//
//  ProductsSeriesCell.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsSeriesCell.h"

@interface ProductsSeriesCell()

@property (nonatomic,strong) UILabel * title1Label;

@end

@implementation ProductsSeriesCell

- (void)awakeFromNib {
    // Initialization code
    //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCell.png"]];
    self.backgroundColor=[UIColor colorWithHexString:@"#e7e6dc"];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, 90-1.5, SCREENWIDTH, 1.5)];
    line.backgroundColor=[UIColor whiteColor];
    [self addSubview:line];
    
    self.title1Label=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREENWIDTH-30, 50)];
    self.title1Label.font=[UIFont fontWithName:@"MJNgaiHK-Medium" size:19];
    self.title1Label.textColor=[UIColor colorWithRed:76/255.0 green:36/255.0 blue:14/255.0 alpha:1];
    [self addSubview:self.title1Label];
}

-(void)setModel:(ProductsSeriesModel *)model
{
    NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    //self.nameLabel.text = [[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:appLanguageStr];
    self.title1Label.text=[[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:appLanguageStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
