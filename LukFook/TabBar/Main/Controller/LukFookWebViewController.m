//
//  LukFookWebViewController.m
//  LukFook
//
//  Created by lin on 16/1/28.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "LukFookWebViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#import "ShareManager.h"

@interface LukFookWebViewController ()<UIWebViewDelegate,ShareManagerDelegate> {
    MBProgressHUD *_mbHUD;
}

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIButton *stopOrReloadButton;

@property(nonatomic,strong)ShareManager *shareManager;

@end

@implementation LukFookWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString showLanguageValue:@"webViewTitle"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    //image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    //image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40)];
    self.webView.delegate = self;
    [self.webView setScalesPageToFit:YES];
    NSURL *url = [NSURL URLWithString:@"http://www.lukfook.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    
    [self buildBottomView];
    
    self.shareManager = [[ShareManager alloc] init];
    self.shareManager.delegate = self;
}

// 返回主页
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 设置底部放四个按钮的 view
- (void)buildBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 44)];
    self.bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar.png"]];
    [self.view addSubview:self.bottomView];
    
    [self buildBottomButton];
}

// 设置底部的四个按钮(返回,前进,刷新,分享)
- (void)buildBottomButton
{
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, SCREENWIDTH/4, 44);
    [backButton setImage:[UIImage imageNamed:@"icon_left.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:backButton];
    // 前进
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 44);
    [forwardButton setImage:[UIImage imageNamed:@"icon_right.png"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(forwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:forwardButton];
    // 分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 44);
    [shareButton setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:shareButton];
    // 停止或刷新
    self.stopOrReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stopOrReloadButton.frame = CGRectMake(SCREENWIDTH/4*2, 0, SCREENWIDTH/4, 44);
    [self.stopOrReloadButton addTarget:self action:@selector(stopOrReloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.stopOrReloadButton];
    
}

- (void)backButtonAction:(UIButton *)button
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)forwardButtonAction:(UIButton *)button
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)stopOrReloadButtonAction:(UIButton *)button
{
    // 如果正在加载,更换图标,并且停止加载
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
        [self.stopOrReloadButton setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
    } else {
        // 刷新
        [self.webView reload];
    }
}

// 开始加载的时候更换刷新按钮的图标
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_mbHUD hide:YES];
    [self.stopOrReloadButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
}

// 加载完成的时候更换刷新按钮的图标
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.stopOrReloadButton setImage:[UIImage imageNamed:@"icon_refresh.png"] forState:UIControlStateNormal];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _mbHUD = [[MBProgressHUD alloc] initWithView:self.webView];
    [self.webView addSubview:_mbHUD];
    _mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [_mbHUD show:YES];
    return YES;
}

// 分享
- (void)shareButtonAction:(UIButton *)button
{
    
    [self.shareManager shareToFriendsWithText:@"六福珠寶" images:[UIImage imageNamed:@"Icon.png"] url:[NSURL URLWithString:@"http://www.lukfook.com"] title:@"六福珠寶" type:SSDKContentTypeAuto];

}

// 分享完成弹出的提示框
-(void)showAlertViewController:(NSString*)tips{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tips message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
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
