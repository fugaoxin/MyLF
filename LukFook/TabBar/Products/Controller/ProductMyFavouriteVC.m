//
//  ProductMyFavouriteVC.m
//  LukFook
//
//  Created by 123 on 16/6/23.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductMyFavouriteVC.h"

@interface ProductMyFavouriteVC ()

@end

@implementation ProductMyFavouriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString * appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    NSString * nameStr = [[NSString alloc] showLanguageValueWithSimplified:@"我的最爱" traditional:@"我的最愛" english:@"My Favourites" andCurrentLanguage:appLanguageStr];
    self.navigationItem.title=nameStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_share_icon" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction:)];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    NSString * labelStr = [[NSString alloc] showLanguageValueWithSimplified:@"没有我的最爱" traditional:@"没有我的最愛" english:@"No favourite" andCurrentLanguage:appLanguageStr];
    UILabel * Label=[[UILabel alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT-50)/2+32, SCREENWIDTH, 50)];
    Label.text=labelStr;
    Label.textColor=[UIColor colorWithRed:76/255.0 green:36/255.0 blue:14/255.0 alpha:1];
    Label.font=[UIFont fontWithName:@"MJNgaiHK-Medium" size:20];
    Label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:Label];
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:Label.text attributes:@{NSKernAttributeName : @(1.5f)}];
    [Label setAttributedText:attributedString];
}

- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAction:(UIButton *)button
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
