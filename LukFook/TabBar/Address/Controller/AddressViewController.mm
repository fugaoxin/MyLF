//
//  AddressViewController.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AddressViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "ShopDetailViewController.h"
#import "AllShopInfoViewController.h"
#import "AddressDataManager.h"
#import "AddressModel.h"

@interface AddressViewController () <MKMapViewDelegate,AddressDataManagerDelegate> {
    MBProgressHUD *_mbHUD;
    NSString *_appLanguageStr;
}

// 用来存放所有地址的数组
@property(nonatomic,strong)NSArray *addressArr;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,assign)NSInteger annotationTag;
// 记录点击的哪一个tag,然后把对应的model传到下一页面
@property(nonatomic,assign)NSInteger touchTag;

// 用来保存点击的哪个大头针
@property(nonatomic,strong)MyAnnotation *annotationView;

@end

@implementation AddressViewController

- (NSArray *)addressArr
{
    if (_addressArr == nil) {
        self.addressArr = [NSArray array];
    }
    return _addressArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    //image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    //image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton3"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"" title:@"showAll" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:15]} forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"显示全部" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    
    self.annotationTag = 0;
    self.touchTag = 0;
    
    // 初始化地图
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    // 1, 设置地图的显示范围(比例尺)
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15, 0.15);
    
    // 2, 创建一个范围 (在香港的经纬度)
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(22.290664, 114.195304);
    MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
    // 3, 在地图上显示该范围
    [self.mapView setRegion:region];
//    [self.mapView isUserLocationVisible];
    // 设置代理
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    _mbHUD = [[MBProgressHUD alloc] initWithView:self.mapView];
    _mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [self.view addSubview:_mbHUD];
    [_mbHUD show:YES];
    
    // 获取数据
    AddressDataManager *manager = [[AddressDataManager alloc] init];
    manager.delegate = self;
    
    // 放在子线程处理数据
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        [manager getData];
    });
}

#pragma mark-获取数据
- (void)acquireAddressData:(NSArray *)arr
{
    self.addressArr = arr;
    [_mbHUD hide:YES];
    __weak AddressViewController *weakSelf = self;
    for (AddressModel *model in self.addressArr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyAnnotation *annotation = [[MyAnnotation alloc] init];
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([model.myLatitude floatValue], [model.myLongitude floatValue]);
            annotation.coordinate = loc;
            annotation.model = model;
            // 根据语言的不同选择不同的字
            _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
            annotation.title = [[NSString alloc] showLanguageValueWithSimplified:model.title_zh traditional:model.title_ch english:model.title_en andCurrentLanguage:_appLanguageStr];
            annotation.subtitle = [[NSString alloc] showLanguageValueWithSimplified:model.address_zh traditional:model.address_ch english:model.address_en andCurrentLanguage:_appLanguageStr];

            [weakSelf.mapView addAnnotation:annotation];
        });
    }
}

// 返回主页
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 右上角按钮显示所有分店
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    AllShopInfoViewController *allShopInfoVC = [[AllShopInfoViewController alloc] init];
    [self.navigationController pushViewController:allShopInfoVC animated:YES];
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

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 50);
    [rightButton setImage:[UIImage imageNamed:@"button_arrow.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    pin.rightCalloutAccessoryView = rightButton;
    
    return pin;
}

// 点击的哪一个大头针,把信息保存下来
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.annotationView = view.annotation;
}

// 点击大头针气泡右边按钮触发的方法
- (void)rightButtonAction:(UIButton *)button
{
    ShopDetailViewController *shopInfoVC = [[ShopDetailViewController alloc] init];
    shopInfoVC.model = self.annotationView.model;
    [self.navigationController pushViewController:shopInfoVC animated:YES];
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
