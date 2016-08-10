//
//  MainViewController.m
//  LukFook
//
//  Created by lin on 16/1/21.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "MainViewController.h"
#import "TabBarButton.h"
#import "ProductsViewController.h"
#import "AddressViewController.h"
#import "AboutUsViewController.h"
#import "CalculatorViewController.h"
#import "LukFookWebViewController.h"
#import "AFNetworkingTool.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
@interface MainViewController () <TabBarButtonDelegate> 
// 底部的滚动视图
@property(nonatomic,strong)UIScrollView *scrollView;
// 顶部的图片
@property(nonatomic,strong)UIImageView *topImageView;
// 价格的背景图
@property(nonatomic,strong)UIImageView *priceBackImageView;
// 底部的更新说明
@property(nonatomic,strong)UILabel *timeLabel;
// 根据屏幕大小,判断是否需要滚动,把所有view需要的高度跟屏幕高度做对比
@property(nonatomic,assign)CGFloat height;
// 用来存放获取的数据
@property(nonatomic,strong)NSDictionary *dataDic;
// 存档的路径
@property(nonatomic,strong)NSString *filePath;

@property(nonatomic,strong)MBProgressHUD * mbHUD;

@property(nonatomic,strong) UIImageView * headerView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAllViews];
    [self getData];
    //[self promotionImage];
}


#pragma mark-获取数据
- (void)getData
{
    // 归档
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentArr[0];
    self.filePath = [documentPath stringByAppendingPathComponent:@"dataDic.plist"];
//    NSLog(@"%@",self.filePath);
//    if ([self isInternetConnection]) {
//        self.dataDic = [NSDictionary dictionary];
//        [AFNetworkingTool GETwithURL:@"http://lukfook.sinodynamic.com/api/raw_indices/" params:nil success:^(id responseObject) {
//            //        NSLog(@"%@",responseObject);
//            self.dataDic = responseObject;
//            // 把数据写进本地,在无网的时候从本地读取
//            [responseObject writeToFile:self.filePath atomically:YES];
//            
//            [self buildTimeLabel];
//            [self buildPriceLabel];
//            [self setContentSizeForScrollView];
//        } failure:^(NSError *error) {
//            
//        }];
//    } else {
//        // 从本地读取数据
//        self.dataDic = [[NSDictionary alloc] initWithContentsOfFile:self.filePath];
//        [self buildTimeLabel];
//        [self buildPriceLabel];
//        [self setContentSizeForScrollView];
//    }
    self.mbHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_mbHUD];
    self.mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [self.mbHUD show:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.lukfook.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //NSLog(@"目前网络不可用");
            [self.mbHUD hide:YES];
            // 从本地读取数据
            self.dataDic = [[NSDictionary alloc] initWithContentsOfFile:self.filePath];
            [self buildTimeLabel];
            [self buildPriceLabel];
            [self setContentSizeForScrollView];
        }
        else
        {
            //NSLog(@"目前网络可用");
            self.dataDic = [NSDictionary dictionary];
            [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/raw_indices/",LFAPI] params:nil success:^(id responseObject) {
                [self.mbHUD hide:YES];
                //NSLog(@"%@",responseObject);
                self.dataDic = responseObject;
                // 把数据写进本地,在无网的时候从本地读取
                [responseObject writeToFile:self.filePath atomically:YES];
                
                [self buildTimeLabel];
                [self buildPriceLabel];
                [self setContentSizeForScrollView];
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

// 判断是否有网络
- (BOOL)isInternetConnection
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.lukfook.com"];
    NSInteger stateNet = [reachability currentReachabilityStatus];
    if (stateNet == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setAllViews
{
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    self.view.backgroundColor=[UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.headerView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.scrollView addSubview:self.headerView];
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    self.headerView.backgroundColor=[UIColor colorWithPatternImage:image];
    
    [self buildTopImageView];
    [self buildPriceBackImageView];
    
    TabBarButton *tabBarButton = [[TabBarButton alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-32, SCREENWIDTH, 32)];
    tabBarButton.delegate = self;
    [self.view addSubview:tabBarButton];
    
    // 注册通知
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(receiveNotification:) name:@"changeLanguage" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushGoldChange:) name:@"pushGoldChange" object:nil];
}

- (void)receivePushGoldChange:(NSNotification *)notification
{
    // 先移除掉通知,再把之前的控件移除掉,重新加载.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushGoldChange" object:nil];
    NSArray *allViews = self.view.subviews;
    for (UIView *view in allViews) {
        [view removeFromSuperview];
    }
    self.dataDic = nil;
    [self setAllViews];
    [self getData];
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
    self.dataDic = nil;
    [self setAllViews];
    [self getData];
}

// 创建顶部的图片
#pragma mark - 创建顶部的图片
- (void)buildTopImageView
{
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentArr[0];
    NSString * imagePath = [documentPath stringByAppendingPathComponent:@"image.plist"];
    //SCREENWIDTH*0.45
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, SCREENWIDTH, SCREENWIDTH*169/450)];
    self.topImageView.backgroundColor = [UIColor whiteColor];
    NSData * imageData=[NSData dataWithContentsOfFile:imagePath];
    self.topImageView.image=[UIImage imageWithData:imageData];
    // 获取图片的 url
    __block NSString *image_url;
    __weak MainViewController *weakSelf = self;
    [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/get_news/",LFAPI] params:nil success:^(id responseObject) {
        NSArray *arr = responseObject[@"payload"];
        NSDictionary *dic = arr.firstObject;
        image_url = dic[@"image"];
        //placeholderImage:[UIImage imageNamed:@"lukfook_profile.png"]
        [weakSelf.topImageView sd_setImageWithURL:[NSURL URLWithString:image_url]];
        NSData * data=[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]];
        [data writeToFile:imagePath atomically:YES];
    } failure:^(NSError *error) {
        
    }];
    
    self.topImageView.userInteractionEnabled = YES;
    // 添加一个点击事件,点击的时候跳到官网
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.topImageView addGestureRecognizer:tap];
    [self.scrollView addSubview:self.topImageView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    LukFookWebViewController *webVC = [[LukFookWebViewController alloc] init];
    UINavigationController *webNavi = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:webNavi animated:YES completion:nil];
}

- (void)buildPriceBackImageView
{
    // 每一行的高度
    float heightOfLine = (SCREENWIDTH-16)*1.05/8.5;
    self.priceBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.headerView.frame.size.height+SCREENWIDTH*169/450+8, SCREENWIDTH-16, (SCREENWIDTH-16)*1.05-2*heightOfLine)];
    self.priceBackImageView.backgroundColor=RGBCOLOR(240, 239, 236, 1);
    // 根据语言的不同选择不同的背景
    UIImageView * titleImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/37.5, SCREENWIDTH/37.5, (SCREENWIDTH)/3, SCREENWIDTH/7.50)];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    titleImage.image=[UIImage imageNamed:@"00_logo"];
    [self.priceBackImageView addSubview:titleImage];
    
    UIImageView * priceImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.priceBackImageView.frame.size.width-(SCREENWIDTH)/3-SCREENWIDTH/37.5, SCREENWIDTH/18.75, (SCREENWIDTH)/3, SCREENWIDTH/7.50)];
    priceImage.contentMode = UIViewContentModeScaleAspectFit;
    //priceImage.image=[UIImage imageNamed:@"lk_today_price"];
    [self.priceBackImageView addSubview:priceImage];
    
    NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([appLanguageStr isEqualToString:@"zh-Hant"]) {
        priceImage.image=[UIImage imageNamed:@"today_price_tc"];
    } else if ([appLanguageStr isEqualToString:@"zh-Hans"]) {
        priceImage.image=[UIImage imageNamed:@"today_price_sc"];
    } else {
        priceImage.frame=CGRectMake(self.priceBackImageView.frame.size.width-(SCREENWIDTH)/2-SCREENWIDTH/37.5, SCREENWIDTH/18.75, (SCREENWIDTH)/2, SCREENWIDTH/7.50);
        priceImage.image=[UIImage imageNamed:@"today_price_en"];
    }
    
//    UILabel * priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.priceBackImageView.frame.size.width-(SCREENWIDTH)/2-SCREENWIDTH/37.5, SCREENWIDTH/37.5, (SCREENWIDTH)/2, SCREENWIDTH/7.50)];
//    [self.priceBackImageView addSubview:priceLabel];
//    priceLabel.numberOfLines=0;
//    priceLabel.font=[UIFont boldSystemFontOfSize:SCREENWIDTH/20.833];
//    priceLabel.textAlignment=NSTextAlignmentRight;
//    priceLabel.textColor = RGBCOLOR(61, 23, 12, 1);
//    priceLabel.text=[NSString showLanguageValue:@"今日饰金价"];
//    if (![appLanguageStr isEqualToString:@"en"]) {
//        priceLabel.frame=CGRectMake(self.priceBackImageView.frame.size.width-(SCREENWIDTH)/2-SCREENWIDTH/37.5, SCREENWIDTH/18.75, (SCREENWIDTH)/2, SCREENWIDTH/9.375);
//        priceLabel.font=[UIFont boldSystemFontOfSize:SCREENWIDTH/14.423];
//    }
    [self.scrollView addSubview:self.priceBackImageView];
}

- (void)buildTimeLabel
{
    NSString *str = [NSString showLanguageValue:@"bottomLabel3"];
    //NSString *timeStr = [NSString showLanguageValue:@"bottomLabel4"];
    NSString *timeStr1 = [NSString showLanguageValue:@"自"];
    NSString *timeStr2 = [NSString showLanguageValue:@"起未有再变动"];
    //NSString *timeStr1 = [NSString showLanguageValue:@"bottomLabel4.1"];
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+SCREENWIDTH*169/450+8+self.priceBackImageView.frame.size.height+10, SCREENWIDTH, 20)];
    [self.scrollView addSubview:strLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, strLabel.frame.origin.y+20, SCREENWIDTH, 20)];
//    if ([self isInternetConnection]) {
//        NSString *dateTimeStr = [self.dataDic[@"record_date_ch"] substringFromIndex:5];
//        self.timeLabel.text = [NSString stringWithFormat:@"%@%@",timeStr,dateTimeStr];
//    } else {
//        self.timeLabel.text = [NSString showLanguageValue:@"NoInternetConnection"];
//    }
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y+20, SCREENWIDTH, 20)];
    [self.scrollView addSubview:lastLabel];
    
    UILabel *lastLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, lastLabel.frame.origin.y+20, SCREENWIDTH, 20)];
    [self.scrollView addSubview:lastLabel1];
    
    UILabel *lastLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, lastLabel1.frame.origin.y+20, SCREENWIDTH, 20)];
    [self.scrollView addSubview:lastLabel2];
    
    NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([appLanguageStr isEqualToString:@"zh-Hant"]||[appLanguageStr isEqualToString:@"zh-Hans"]) {
        //繁
        strLabel.text = str;
        [self labelStyleWithLabel1:strLabel size:16 textAlignment:NSTextAlignmentCenter];
        
        lastLabel.text = [NSString showLanguageValue:@"bottomLabel5"];
        [self labelStyleWithLabel1:lastLabel size:16 textAlignment:NSTextAlignmentCenter];
    } else {
        strLabel.text = str;
        [self labelStyleWithLabel1:strLabel size:16 textAlignment:NSTextAlignmentCenter];
        
        self.timeLabel.text = [NSString showLanguageValue:@"bottomLabel3.1"];
        [self labelStyleWithLabel1:lastLabel size:16 textAlignment:NSTextAlignmentCenter];
        
        lastLabel1.text = [NSString showLanguageValue:@"bottomLabel4.1"];
        [self labelStyleWithLabel1:lastLabel1 size:16 textAlignment:NSTextAlignmentCenter];
        
        lastLabel2.text = [NSString showLanguageValue:@"bottomLabel5"];
        [self labelStyleWithLabel1:lastLabel2 size:16 textAlignment:NSTextAlignmentCenter];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.lukfook.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            self.timeLabel.text = [NSString showLanguageValue:@"NoInternetConnection"];
        }
        else
        {
            NSString *dateTimeStr = [self.dataDic[@"record_date_ch"] substringFromIndex:5];
            if ([appLanguageStr isEqualToString:@"zh-Hant"]||[appLanguageStr isEqualToString:@"zh-Hans"]) {
                //繁
                self.timeLabel.text = [NSString stringWithFormat:@"%@%@%@，",timeStr1,dateTimeStr,timeStr2];
            } else {
                lastLabel.text = [NSString stringWithFormat:@"%@%@,",[NSString showLanguageValue:@"bottomLabel4"],dateTimeStr];
            }
        }
    }];
    [manager.reachabilityManager startMonitoring];
    [self labelStyleWithLabel1:self.timeLabel size:16 textAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:self.timeLabel];
}

// 根据需要设置可滚动范围
- (void)setContentSizeForScrollView
{
    self.height = self.timeLabel.frame.origin.y+20+42+20;
    if (self.height > SCREENHEIGHT) {
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.height);
    }
}

// 设置买卖价格列表
- (void)buildPriceLabel
{
    // 每一行的高度
    CGFloat heightOfLine = (SCREENWIDTH-16)*1.05/8.5;
    // 第一行Y的起点
    CGFloat Ypoint = self.headerView.frame.size.height+SCREENWIDTH*169/450+8+heightOfLine*1.5;
    
    UILabel * unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, Ypoint, (SCREENWIDTH-16)*5/11, heightOfLine)];
    [self labelStyleWithLabel:unitLabel size:15 textAlignment:NSTextAlignmentCenter];
    unitLabel.text = [NSString showLanguageValue:@"unitLabel"];
    [self.scrollView addSubview:unitLabel];
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-8-(SCREENWIDTH-16)*3/11, Ypoint, (SCREENWIDTH-16)*3/11, heightOfLine)];
    [self labelStyleWithLabel:buyLabel size:15 textAlignment:NSTextAlignmentCenter];
    buyLabel.text = [NSString showLanguageValue:@"buyLabel"];
    [self.scrollView addSubview:buyLabel];
    
    UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-8-(SCREENWIDTH-16)*3/11*2), Ypoint, (SCREENWIDTH-16)*3/11, heightOfLine)];
    [self labelStyleWithLabel:sellLabel size:15 textAlignment:NSTextAlignmentCenter];
    sellLabel.text = [NSString showLanguageValue:@"sellLabel"];
    [self.scrollView addSubview:sellLabel];
    
    UILabel * line1=[[UILabel alloc] initWithFrame:CGRectMake(8 , Ypoint, SCREENWIDTH-16, 1.0)];
    line1.backgroundColor=RGBCOLOR(217, 212, 206, 1);
    line1.alpha=0.8;
    [self.scrollView addSubview:line1];
    
    NSArray *nameLabelArr = @[@"nameLabel1",@"nameLabel3",@"nameLabel5",@"nameLabel6"];
    
    // 设置产品名称和买卖价格的label
    for (int i = 0; i<4; i++) {
        
        UIView *viewOfLine = [[UIView alloc] initWithFrame:CGRectMake(8, Ypoint+heightOfLine*(i+1), SCREENWIDTH-16, heightOfLine)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREENWIDTH-16)*5/11, heightOfLine)];
        nameLabel.numberOfLines=0;
        //nameLabel.backgroundColor=[UIColor redColor];
        [self labelStyleWithLabel:nameLabel size:15 textAlignment:NSTextAlignmentCenter];
        
        UILabel *sellPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewOfLine.frame.size.width-(SCREENWIDTH-16)*3/11*2), 0, (SCREENWIDTH-16)*3/11, heightOfLine)];
        [self labelStyleWithLabel:sellPriceLabel size:15 textAlignment:NSTextAlignmentCenter];
        //sellPriceLabel.backgroundColor=[UIColor greenColor];
        UILabel *buyPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewOfLine.frame.size.width-(SCREENWIDTH-16)*3/11, 0, (SCREENWIDTH-16)*3/11, heightOfLine)];
        [self labelStyleWithLabel:buyPriceLabel size:15 textAlignment:NSTextAlignmentCenter];
        //buyPriceLabel.backgroundColor=[UIColor orangeColor];
        UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0 , 0, viewOfLine.frame.size.width, 1.0)];
        line.backgroundColor=RGBCOLOR(217, 212, 200, 1);
        line.alpha=0.8;
        [viewOfLine addSubview:line];
        switch (i) {
            case 0:
            {
                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
                sellPriceLabel.text = self.dataDic[@"decor_buyout"];
                buyPriceLabel.text = self.dataDic[@"decor_buyin"];
            }
                break;
//            case 1:
//            {
//                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
//                sellPriceLabel.text = self.dataDic[@"decor_buyout_gram"];
//                buyPriceLabel.text = self.dataDic[@"decor_buyin_gram"];
//            }
//                break;
            case 1:
            {
                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
                sellPriceLabel.text = self.dataDic[@"platinum_buyout"];
                buyPriceLabel.text = self.dataDic[@"platinum_buyin"];
            }
                break;
//            case 3:
//            {
//                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
//                sellPriceLabel.text = self.dataDic[@"platinum_buyout_gram"];
//                buyPriceLabel.text = self.dataDic[@"platinum_buyin_gram"];
//            }
//                break;
            case 2:
            {
                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
                sellPriceLabel.text = self.dataDic[@"gold_nugget_buyout"];
                buyPriceLabel.text = self.dataDic[@"gold_nugget_buyin"];
            }
                break;
            case 3:
            {
                nameLabel.text = [NSString showLanguageValue:nameLabelArr[i]];
                sellPriceLabel.text = self.dataDic[@"rmb_buy"];
                buyPriceLabel.text = self.dataDic[@"rmb_in"];
            }
                break;
            default:
                break;
        }
        
        [viewOfLine addSubview:nameLabel];
        [viewOfLine addSubview:sellPriceLabel];
        [viewOfLine addSubview:buyPriceLabel];
        
        [self.scrollView addSubview:viewOfLine];
    }
}

// label的字体大小,颜色,居中等格式
- (void)labelStyleWithLabel:(UILabel *)label
                       size:(NSInteger)size
              textAlignment:(NSTextAlignment)alignment
{
    label.textColor =RGBCOLOR(61, 23, 12, 1);
    label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:size];
    label.textAlignment = alignment;
}

- (void)labelStyleWithLabel1:(UILabel *)label
                       size:(NSInteger)size
              textAlignment:(NSTextAlignment)alignment
{
    label.textColor =[UIColor colorWithHexString:@"#664A2C"];
    label.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:size];
    label.textAlignment = alignment;
}


#pragma mark-当下面按钮被点击时实现代理方法,推出下一页面
- (void)pushViewController:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 10086:
        {
            CalculatorViewController *calculatorVC = [[CalculatorViewController alloc] init];
            UINavigationController *calculatorNavi = [[UINavigationController alloc] initWithRootViewController:calculatorVC];
            calculatorVC.price = self.dataDic[@"decor_buyout"];
            [self presentViewController:calculatorNavi animated:YES completion:nil];
        }
            break;
        case 10087:
        {
            ProductsViewController *productVC = [[ProductsViewController alloc] init];
            UINavigationController *productNavi = [[UINavigationController alloc] initWithRootViewController:productVC];
            [self presentViewController:productNavi animated:YES completion:nil];
        }
            break;
        case 10088:
        {
            AddressViewController *addressVC = [[AddressViewController alloc] init];
            UINavigationController *addressNavi = [[UINavigationController alloc] initWithRootViewController:addressVC];
            [self presentViewController:addressNavi animated:YES completion:nil];
        }
            break;
        case 10089:
        {
            AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
            UINavigationController *aboutNavi = [[UINavigationController alloc] initWithRootViewController:aboutVC];
            [self presentViewController:aboutNavi animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 宣传图片
-(void)promotionImage
{
    UIImageView * bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    bgImage.backgroundColor=[UIColor blackColor];
    bgImage.alpha=0.75;
    bgImage.tag=5;
    bgImage.userInteractionEnabled=YES;
    [self.view addSubview:bgImage];
    
    UIImageView * ImageV=[[UIImageView alloc] initWithFrame:CGRectMake(100, 100, SCREENWIDTH-200, SCREENHEIGHT-200)];
    //ImageV.backgroundColor=[UIColor whiteColor];
    ImageV.userInteractionEnabled=YES;
    ImageV.tag=6;
    ImageV.contentMode = UIViewContentModeScaleAspectFit;
    ImageV.image=[UIImage imageNamed:@"00_bg"];
    [self.view addSubview:ImageV];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageV)];
    [ImageV addGestureRecognizer:tap];
    
    UIButton * XBut=[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, 20, 30, 30)];
    //XBut.backgroundColor=[UIColor redColor];
    [XBut setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [bgImage addSubview:XBut];
    [XBut addTarget:self action:@selector(clickXBut) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickImageV
{
    LukFookWebViewController *webVC = [[LukFookWebViewController alloc] init];
    UINavigationController *webNavi = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:webNavi animated:YES completion:nil];
}

-(void)clickXBut
{
    UIImageView * bgImage=[self.view viewWithTag:5];
    UIImageView * ImageV=[self.view viewWithTag:6];
    [ImageV removeFromSuperview];
    [bgImage removeFromSuperview];
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
