//
//  ProductsViewController.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductsCell.h"
#import "ProductsDataManager.h"
#import "ProductsListModel.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
#import "ProductsSeriesViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ProductMyFavouriteVC.h"

@interface ProductsViewController () <UITableViewDelegate,UITableViewDataSource,ProductsDataManagerDelegate> {
    MBProgressHUD *_mbHUD;
}

@property(nonatomic,strong)UITableView *tableView;

// 用来接收数据的数组
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)ProductsDataManager *dataManager;
@property(nonatomic,strong)UIView *tipsView;

@end

@implementation ProductsViewController

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    //image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    //image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton2"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_icon_refresh" style:UIBarButtonItemStylePlain target:self action:@selector(updateNewData)];
    
    // 设置tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductsCell" bundle:nil] forCellReuseIdentifier:@"productCell"];
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor=[UIColor whiteColor];
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [self.view addSubview:self.tableView];
    
    // 启动下拉刷新功能
    [self setupRefresh];
    
    // 获取数据
    self.dataManager = [[ProductsDataManager alloc] init];
    self.dataManager.delegate = self;
    
    // 判断网络情况
//    if (![self isInternetConnection]) {
//        [self setNoInternetTipsView];
//    } else {
//        _mbHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
//        [self.tableView addSubview:_mbHUD];
//        _mbHUD.labelText = [NSString showLanguageValue:@"loading"];
//        [_mbHUD show:YES];
//        // 放在子线程处理数据,处理完之后记得实现代理方法,接收数据
//        dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(currentQueue, ^{
//            [self.dataManager getAllDataFromAPI];
//        });
//    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.lukfook.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
           [self setNoInternetTipsView];
        }
        else
        {
            _mbHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
            [self.tableView addSubview:_mbHUD];
            _mbHUD.labelText = [NSString showLanguageValue:@"loading"];
            [_mbHUD show:YES];
            // 放在子线程处理数据,处理完之后记得实现代理方法,接收数据
            dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(currentQueue, ^{
                [self.dataManager getAllDataFromAPI];
            });
        }
    }];
    [manager.reachabilityManager startMonitoring];
}


// 返回主页
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

// 如果没有网络,那就出现没有网络的提醒
- (void)setNoInternetTipsView
{
    self.tipsView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.tipsView.backgroundColor = [UIColor whiteColor];
    UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT/2-60, SCREENWIDTH, 30)];
    tipLabel1.text = @"No Internet Connection";
    tipLabel1.font = [UIFont fontWithName:@"MJNgaiHK-Medium" size:23];
    tipLabel1.textAlignment = NSTextAlignmentCenter;
    tipLabel1.textColor = RGBCOLOR(108,123,130,1);
    [self.tipsView addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT/2, SCREENWIDTH, 20)];
    tipLabel2.text = [NSString showLanguageValue:@"NoInternetConnection"];
    tipLabel2.textAlignment = NSTextAlignmentCenter;
    tipLabel2.textColor = RGBCOLOR(108,123,130,1);
    [self.tipsView addSubview:tipLabel2];
    
    [self.tableView addSubview:self.tipsView];
}

#pragma mark--开始刷新自定义方法
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [header setTitle:@"Pull down to update..." forState:MJRefreshStateIdle];
    [header setTitle:@"Release to update..." forState:MJRefreshStatePulling];
    [header setTitle:@"Updating ..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self.tableView.mj_header beginRefreshing];
    [self updateNewData];
//    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [[self.tableView mj_header] endRefreshing];
}

// 重新刷新数据
- (void)updateNewData
{
//    if ([self isInternetConnection]) {
//        if (self.tipsView) {
//            [self.tipsView removeFromSuperview];
//            self.tipsView = nil;
//        }
//        // 如果数组有值,那先移除掉数组元素,重新获取数据
//        if (self.dataArr.count > 0) {
//            [self.dataArr removeAllObjects];
//            self.dataArr = nil;
//            [self.tableView reloadData];
//        }
//        [_mbHUD show:YES];
//        [self.dataManager getAllDataFromAPI];
//    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.lukfook.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
        }
        else
        {
            if (self.tipsView) {
                [self.tipsView removeFromSuperview];
                self.tipsView = nil;
            }
            // 如果数组有值,那先移除掉数组元素,重新获取数据
            if (self.dataArr.count > 0) {
                [self.dataArr removeAllObjects];
                self.dataArr = nil;
                [self.tableView reloadData];
            }
            [_mbHUD show:YES];
            [self.dataManager getAllDataFromAPI];
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

#pragma mark-tableView 的相关设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count>0) {
        return self.dataArr.count+1;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_background.png"]];
    cell.selectedBackgroundView = view_bg;
    // 获取到对应的model数据,给cell赋值
    
    ProductsListModel *model =[[ProductsListModel alloc] init];
    if (self.dataArr.count == indexPath.row) {
        NSDictionary * dataDic = @{@"banner_ch":@"lf_favourite",
                                   @"show_series":@"NO",
                                   @"title_zh":@"My Favourite｜我的最爱",
                                   @"title_en":@"My Favourite",
                                   @"title_ch":@"My Favourite｜我的最愛",
                                   @"productID":@"9999"};
        [model setValuesForKeysWithDictionary:dataDic];
        cell.ImaView.image=[UIImage imageNamed:model.banner_ch];
    }
    else{
        model = self.dataArr[indexPath.row];
        [cell.ImaView sd_setImageWithURL:[NSURL URLWithString:model.banner_ch] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsListModel *model =[[ProductsListModel alloc] init];
    if (self.dataArr.count == indexPath.row) {
        NSDictionary * dataDic = @{@"banner_ch":@"lf_favourite",
                                   @"show_series":@"NO",
                                   @"title_zh":@"我的最爱",
                                   @"title_en":@"My Favourites",
                                   @"title_ch":@"我的最愛",
                                   @"productID":@"9999"};
        [model setValuesForKeysWithDictionary:dataDic];
    }
    else{
        model = self.dataArr[indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 如果没有下一层分类的话,那就直接推出详情页,如果有的话,那就继续推出分类页面
    if ([model.show_series isEqualToString:@"NO"]) {
        if ([model.banner_ch isEqualToString:@"lf_favourite"]) {
            ProductMyFavouriteVC * MFVC = [[ProductMyFavouriteVC alloc] init];
            [self.navigationController pushViewController:MFVC animated:YES];
        }
        else{
            ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
            // 获取到对应的model数据,把值传到下一页面
            detailVC.listModel = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    } else {
        ProductsSeriesViewController *seriesVC = [[ProductsSeriesViewController alloc] init];
        seriesVC.listModel = model;
        [self.navigationController pushViewController:seriesVC animated:YES];
    }
}

#pragma mark-实现代理方法,接收数据
- (void)acquireDataFromAPI:(NSArray *)arr
{
    self.dataArr = (NSMutableArray *)arr;
    // 接收完数据刷新UI
    __weak ProductsViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mbHUD hide:YES];
        [weakSelf.tableView reloadData];
    });
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
