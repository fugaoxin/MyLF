//
//  AboutUsViewController.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AboutUsViewController.h"
#import "LanguageSelectedViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#import "ShareManager.h"
#import "AFNetworkingTool.h"

@interface AboutUsViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)NSString * htmlStr;
@property(nonatomic,strong)MBProgressHUD * mbHUD;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    //[self setAllViews];
    [self loadData];
}

-(void)setNavigation{
    self.view.backgroundColor=[UIColor whiteColor];
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton4"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"" title:@"language" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]} forState:UIControlStateNormal];
}

-(void)loadData{
    self.mbHUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.mbHUD];
    self.mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [self.mbHUD show:YES];
    NSString * lang=[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([lang isEqualToString:@"en"]) {
        lang=@"English";
    }
    NSString * url=[NSString stringWithFormat:@"%@api/about/%@",LFAPI,lang];
    [AFNetworkingTool GETwithURL:url params:nil success:^(id responseObject) {
        //NSLog(@"wwww===%@",responseObject);
        [self.mbHUD hide:YES];
        self.htmlStr=responseObject[@"html"];
        [self setAllViews];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setAllViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [self.view addSubview:self.scrollView];
    
    [self buildTopImageView];
    [self buidlInfoLabel];
    
    // 注册通知
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(receiveNotification:) name:@"changeLanguage" object:nil];
}

// 收到通知执行的方法
- (void)receiveNotification:(NSNotification *)notification
{
    // 先移除掉通知,再把之前的控件移除掉,重新加载.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLanguage" object:nil];
    NSArray *allViews = self.view.subviews;
    for (UIView *view in allViews) {
        [view removeFromSuperview];
    }
    [self setAllViews];
    self.scrollView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
}

// 返回主页
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 右上角切换语言
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    LanguageSelectedViewController *languageVC = [[LanguageSelectedViewController alloc] init];
    [self presentViewController:languageVC animated:YES completion:nil];
}

- (void)buildTopImageView
{
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.5)];
    topImageView.image = [UIImage imageNamed:@"lukfook_profile.png"];
    [self.scrollView addSubview:topImageView];
}

- (void)buidlInfoLabel
{
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREENWIDTH*0.5+20, SCREENWIDTH-20, 100)];
    self.infoLabel.textColor = RGBCOLOR(61, 23, 12, 1);
    self.infoLabel.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:18];
    self.infoLabel.text = [NSString showLanguageValue:@"aboutUsLabel"];
    
    // 设置行间距和字间距
//    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.infoLabel.text attributes:@{NSKernAttributeName : @(1.5f)}];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:6];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.infoLabel.text.length)];
//    [self.infoLabel setAttributedText:attributedString];
    
    /////解析图片
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
//    NSArray *result = [regex matchesInString:self.htmlStr options:NSMatchingReportCompletion range:NSMakeRange(0, self.htmlStr.length)];
//    for (NSTextCheckingResult *item in result) {
//        NSString *imgHtml = [self.htmlStr substringWithRange:[item rangeAtIndex:0]];
//        NSArray *tmpArray = nil;
//        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
//            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
//        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
//            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
//        }
//        if (tmpArray.count >= 2) {
//            NSString *src = tmpArray[1];
//            NSUInteger loc = [src rangeOfString:@"\""].location;
//            if (loc != NSNotFound) {
//                src = [src substringToIndex:loc];
//                NSLog(@"正确解析出来的SRC为：%@", src);
//            }
//        }
//    }
    
    ////////
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17] range:NSMakeRange(0, attrStr.mutableString.length)];
//设置了间隔就没空格
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.mutableString.length)];
    self.infoLabel.attributedText = attrStr;

    self.infoLabel.numberOfLines = 0;
    [self.infoLabel sizeToFit];
    [self.scrollView addSubview:self.infoLabel];
    [self setContentSizeForScrollView];

//    UIWebView * wb=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
//    [self.view addSubview:wb];
//    [wb loadHTMLString:self.htmlStr baseURL:nil];
}

// 根据需要设置可滚动范围
- (void)setContentSizeForScrollView
{
    CGFloat height = self.infoLabel.frame.origin.y + self.infoLabel.bounds.size.height + 40;
    if (height > SCREENHEIGHT) {
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, height);
    }
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
