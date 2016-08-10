//
//  AllShopInfoViewController.m
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AllShopInfoViewController.h"
#import "AllShopInfoTableViewCell.h"
#import "AreaShopInfoViewController.h"
#import "AllShopInfoDataManager.h"
#import "MJRefresh.h"

#define SHOPAPI @"http://lukfook.sinodynamic.com/api/stores/regions/?lang=zh-Hans"
#define PROVINCESAPI @"http://lukfook.sinodynamic.com/api/stores/provinces/1/"

@interface AllShopInfoViewController ()<UITableViewDataSource,UITableViewDelegate,AllShopInfoDataManagerDelegate> {
    MBProgressHUD *_mbHUD;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)AllShopInfoDataManager *dataManager;

@end

@implementation AllShopInfoViewController

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
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton3"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_icon_refresh" style:UIBarButtonItemStylePlain target:self action:@selector(updateNewData)];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AllShopInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"allShopInfoCell"];
    self.tableView.rowHeight = 90;
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _mbHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:_mbHUD];
    _mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [_mbHUD show:YES];
    
    // 获取数据
    self.dataManager = [[AllShopInfoDataManager alloc] init];
    self.dataManager.delegate = self;
    if (self.flag) {
        NSString *url = [NSString stringWithFormat:@"%@api/stores/provinces/%@/",LFAPI,self.model.shopID];
        [self.dataManager getDataWithAPI:url];
    } else {
        NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
        [self.dataManager getDataWithAPI:[NSString stringWithFormat:@"%@api/stores/regions/?lang=%@",LFAPI,appLanguageStr]];
    }
    
    // 启动下拉刷新功能
    [self setupRefresh];
    
//    self.flag = NO;
}

// 返回
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    // 如果数组有值,那先移除掉数组元素,重新获取数据
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
        self.dataArr = nil;
        [self.tableView reloadData];
        [_mbHUD show:YES];
        if (self.flag) {
            NSString *url = [NSString stringWithFormat:@"%@api/stores/provinces/%@/",LFAPI,self.model.shopID];
            [self.dataManager getDataWithAPI:url];
        } else {
            NSString *appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
            [self.dataManager getDataWithAPI:[NSString stringWithFormat:@"%@api/stores/regions/?lang=%@",LFAPI,appLanguageStr]];
        }
    }
}

#pragma mark-实现代理方法,获取数据
- (void)acquireData:(NSArray *)arr
{
    [_mbHUD hide:YES];
    self.dataArr = (NSMutableArray *)arr;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allShopInfoCell" forIndexPath:indexPath];
    AllShopInfoModel *model = self.dataArr[indexPath.row];
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_background.png"]];
    cell.selectedBackgroundView = view_bg;
    cell.model = model;
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllShopInfoModel *model = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([model.show_provinces isEqualToString:@"YES"]) {
        AllShopInfoViewController *shopVC = [[AllShopInfoViewController alloc] init];
        shopVC.flag = YES;
        shopVC.model = model;
        [self.navigationController pushViewController:shopVC animated:YES];
    } else {
        AreaShopInfoViewController *areaShopInfoVC = [[AreaShopInfoViewController alloc] init];
        areaShopInfoVC.model = model;
        [self.navigationController pushViewController:areaShopInfoVC animated:YES];
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
