//
//  ProductsCell.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsCell.h"

@interface ProductsCell ()

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong)UILabel * NALabel;

@end

@implementation ProductsCell

- (void)awakeFromNib {
    // Initialization code
    //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCell.png"]];
    self.backgroundColor=[UIColor colorWithHexString:@"#e7e6dc"];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, 90-1.5, SCREENWIDTH, 1.5)];
    line.backgroundColor=[UIColor whiteColor];
    [self addSubview:line];
    
    self.NALabel=[[UILabel alloc] initWithFrame:CGRectMake(95, 10, SCREENWIDTH-30-95, 70)];
    self.NALabel.textColor=[UIColor colorWithRed:76/255.0 green:36/255.0 blue:14/255.0 alpha:1];
    //self.NALabel.numberOfLines=2;
    [self addSubview:self.NALabel];
}

- (void)setModel:(ProductsListModel *)model
{
    _model = model;
//    self.NameLabel.text = model.name;
    // 根据语言的不同选择不同的字

    NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([appLanguageStr isEqualToString:@"zh-Hant"]) {
        self.NALabel.font=[UIFont fontWithName:@"MJNgaiHK-Medium" size:SCREENWIDTH/28.84];//17
    }
    else{
        self.NALabel.font=[UIFont fontWithName:@"MJNgaiCN-Medium" size:SCREENWIDTH/28.84];//17
    }
    self.NameLabel.hidden=YES;
    //self.NameLabel.text = [[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:appLanguageStr];
    //self.NALabel.text=[[NSString alloc] showLanguageValueWithSimplified:model.title_ch traditional:model.title_ch english:model.title_en andCurrentLanguage:appLanguageStr];
    NSMutableString * labStr=[NSMutableString stringWithFormat:@"%@",[[NSString alloc] showLanguageValueWithSimplified:model.title_ch traditional:model.title_ch english:model.title_en andCurrentLanguage:appLanguageStr]];
    //换行
//    if([labStr rangeOfString:@"|"].location!=NSNotFound)
//    {
//        for(int i=0; i<labStr.length; i++){
//            unichar ch = [labStr characterAtIndex:i];
//            if ([[NSString stringWithFormat:@"%c",ch] isEqualToString:@"|"]) {
//                [labStr insertString:@"\n" atIndex:i+1];
//                break;
//            }
//        }
//    }
    self.NALabel.text=labStr;
    
    // 设置行间距和字间距
//    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.NALabel.text attributes:nil];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:3];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.NALabel.text.length)];
//    [self.NALabel setAttributedText:attributedString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
