//
//  ShopDetailViewController.m
//  LukFook
//
//  Created by lin on 16/1/27.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ShopDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "ShopInfoView.h"
#import "UIImageView+WebCache.h"

@interface ShopDetailViewController () <MKMapViewDelegate,ShopInfoViewDelegate> {
    NSString *_appLanguageStr;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)ShopInfoView *shopInfoView;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton3"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    [self buildTopImageView];
    [self buildMapView];
    [self buildShopInfoView];
    
}

// 返回
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildTopImageView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, SCREENWIDTH-20, (SCREENWIDTH-20)*0.8)];
    view.layer.cornerRadius = 15;
    view.layer.borderWidth=1.5;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, SCREENWIDTH-40, (SCREENWIDTH-60)*0.8-10)];
    //self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.masksToBounds = YES;
//    self.imageView.image = [UIImage imageNamed:@"lukfook_profile.png"];
    if ([self.model.picture_big isEqualToString:@""] || self.model.picture_big == nil) {
        self.imageView.image = [UIImage imageNamed:@"lukfook.png"];
    } else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.picture_big] placeholderImage:[UIImage imageNamed:@"lukfook.png"]];
    }
    [self.scrollView addSubview:self.imageView];
}

- (void)buildShopInfoView
{
    self.shopInfoView = [[ShopInfoView alloc] initWithFrame:CGRectMake(10, 20+(SCREENWIDTH-20)*0.8+15+(SCREENWIDTH-20)*0.8+15, SCREENWIDTH-20, 400) model:self.model];
    self.shopInfoView.delegate = self;
    [self.scrollView addSubview:self.shopInfoView];
    // 设置滚动范围
    [self scrollViewSetContentSize];
}

#pragma mark-实现代理,拔打电话
- (void)callTheShopPhone
{
    // 去掉号码字符串中的特殊符号
    NSMutableString *phoneNumber = [NSMutableString stringWithString:self.model.phone];
    if ([phoneNumber containsString:@"("]) {
        phoneNumber = (NSMutableString *)[phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([phoneNumber containsString:@")"]) {
        phoneNumber = (NSMutableString *)[phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if ([phoneNumber containsString:@" "]) {
        phoneNumber = (NSMutableString *)[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
}

- (void)scrollViewSetContentSize
{
    CGFloat height = [self.shopInfoView getHeightOfView];
    // 根据获取到的 view 的高度确定滚动范围
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, 20+(SCREENWIDTH-20)*0.8+15+(SCREENWIDTH-20)*0.8+15+height+50);
}

// 创建地图
- (void)buildMapView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 20+(SCREENWIDTH-20)*0.8+15, SCREENWIDTH-20, (SCREENWIDTH-20)*0.8)];
    view.layer.cornerRadius = 15;
    view.layer.borderWidth=1.5;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    // 初始化地图
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, 20+(SCREENWIDTH-20)*0.8+25, SCREENWIDTH-40, (SCREENWIDTH-40)*0.8-5)];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.layer.cornerRadius = 15;
    self.mapView.layer.masksToBounds = YES;
    
    // 1, 设置地图的显示范围(比例尺)
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    
    // 2, 创建一个范围
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.model.myLatitude floatValue], [self.model.myLongitude floatValue]);
    MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
    // 3, 在地图上显示该范围
    [self.mapView setRegion:region];
    [self.scrollView addSubview:self.mapView];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    annotation.coordinate = loc;
    
    // 根据语言的不同选择不同的字
    _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    annotation.title = [[NSString alloc] showLanguageValueWithSimplified:self.model.title_zh traditional:self.model.title_ch english:self.model.title_en andCurrentLanguage:_appLanguageStr];
    annotation.subtitle = [[NSString alloc] showLanguageValueWithSimplified:self.model.address_zh traditional:self.model.address_ch english:self.model.address_en andCurrentLanguage:_appLanguageStr];
    [self.mapView addAnnotation:annotation];
}

#pragma mark--自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 如果是系统的用户位置,我们不做任何操作
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // 1, 创建重用标注符
    static NSString *identifier = @"reuseAnnotation";
    
    // 2, 创建重用队列
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    // 3, 创建标注视图
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    // 设置大头针的一些属性
    // 设置大头针向下坠落的效果
    pin.animatesDrop = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
        pin.pinTintColor = [UIColor redColor];
    } else {
        pin.pinColor = MKPinAnnotationColorRed;
    }
    // 显示大头针的气泡
    pin.canShowCallout = YES;
    
    // 设置大头针的左右附件视图
//    UIImageView *leftView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    leftView.image = [UIImage imageNamed:@"Icon.png"];
//    leftView.userInteractionEnabled = YES;
//    pin.leftCalloutAccessoryView = leftView;
    
    return pin;
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
