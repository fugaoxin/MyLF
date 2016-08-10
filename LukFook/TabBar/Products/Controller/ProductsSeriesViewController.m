//
//  ProductsSeriesViewController.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsSeriesViewController.h"
#import "ProductsSeriesCell.h"
#import "ProductDetailDataManager.h"
#import "ProductsSeriesModel.h"
#import "ProductDetailViewController.h"

@interface ProductsSeriesViewController () <UITableViewDataSource,UITableViewDelegate,ProductDetailDataManagerDelegate> {
    NSString *_appLanguageStr;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MBProgressHUD *mbHUD;
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation ProductsSeriesViewController

- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *titleStr = [[NSString alloc] init];
    // 根据语言的不同选择不同的字
    _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    NSString *nameStr = [[NSString alloc] showLanguageValueWithSimplified:self.listModel.title_zh traditional:self.listModel.title_ch english:self.listModel.title_en andCurrentLanguage:_appLanguageStr];
    if ([nameStr containsString:@"|"]) {
        NSArray *arr = [nameStr componentsSeparatedByString:@"|"];
        titleStr = arr[1];
    } else {
        titleStr = nameStr;
    }
    self.navigationItem.title = titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"tabBarButton2" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    self.tableView.backgroundColor=[UIColor whiteColor];
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductsSeriesCell" bundle:nil] forCellReuseIdentifier:@"SeriesCell"];
    [self.view addSubview:self.tableView];
    
    // 获取数据
    ProductDetailDataManager *manager = [[ProductDetailDataManager alloc] init];
    manager.delegate = self;
    [manager getSeriesDataWithProductID:[NSString stringWithFormat:@"%@",self.listModel.productID]];
}

- (void)acquireData:(NSArray *)arr
{
    self.dataArr = arr;
    [self.mbHUD hide:YES];
    [self.tableView reloadData];
}


// 返回
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsSeriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeriesCell" forIndexPath:indexPath];
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_background.png"]];
    cell.selectedBackgroundView = view_bg;
    
    [cell setModel:self.dataArr[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsSeriesModel *model = self.dataArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 如果没有下一层分类的话,那就直接推出详情页,如果有的话,那就继续推出分类页面
    if ([model.show_list_table isEqualToString:@"NO"]) {
        ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
        // 获取到对应的model数据,把值传到下一页面
        detailVC.SeriesModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
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
