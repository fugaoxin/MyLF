//
//  ProductDetailViewController.m
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailCell.h"
#import "ProductDetailDataManager.h"
#import "ProductDetailModel.h"
#import "UIImageView+WebCache.h"
#import "ShareManager.h"

@interface ProductDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,ProductDetailDataManagerDelegate,ShareManagerDelegate> {
    NSString *_appLanguageStr;
    ShareManager *_shareManager;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)MBProgressHUD *mbHUD;
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation ProductDetailViewController

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
    NSString *nameStr;
    if (self.listModel) {
        _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
        nameStr = [[NSString alloc] showLanguageValueWithSimplified:self.listModel.title_zh traditional:self.listModel.title_ch english:self.listModel.title_en andCurrentLanguage:_appLanguageStr];
    }
    else
    {
        _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
        nameStr = [[NSString alloc] showLanguageValueWithSimplified:self.SeriesModel.title_zh traditional:self.SeriesModel.title_ch english:self.SeriesModel.title_en andCurrentLanguage:_appLanguageStr];
    }

    if ([nameStr containsString:@"|"]) {
        NSArray *arr = [nameStr componentsSeparatedByString:@"|"];
        titleStr = arr[1];
    } else {
        titleStr = nameStr;
    }
    self.navigationItem.title = titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    _shareManager = [[ShareManager alloc] init];
    _shareManager.delegate = self;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"tabBarButton2" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_share_icon" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction:)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(VIEWWIDTH,VIEWHEIGHT-64);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    // 滚动的方向为横向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 按页滚动
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:nil] forCellWithReuseIdentifier:@"detailCell"];
    [self.view addSubview:self.collectionView];

    self.mbHUD = [[MBProgressHUD alloc] initWithView:self.collectionView];
    [self.collectionView addSubview:self.mbHUD];
    self.mbHUD.labelText = [NSString showLanguageValue:@"loading"];
    [self.mbHUD show:YES];
    
    // 获取数据
    ProductDetailDataManager *manager = [[ProductDetailDataManager alloc] init];
    manager.delegate = self;
    if (self.listModel) {
        [manager getData:_appLanguageStr productID:[NSString stringWithFormat:@"%@",self.listModel.productID]];
    }
    else
    {
        [manager getData:_appLanguageStr seriesID:[NSString stringWithFormat:@"%@",self.SeriesModel.productID]];
    }
    
}

// 返回
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 分享
- (void)shareButtonAction:(UIButton *)button
{
    if (self.dataArr.count>0) {
        NSInteger currentPage = self.collectionView.contentOffset.x/SCREENWIDTH;
        ProductDetailModel *currentModel = self.dataArr[currentPage];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentModel.image]];
        [_shareManager shareToFriendsWithText:currentModel.name images:[UIImage imageWithData:data] url:[NSURL URLWithString:currentModel.url] title:@"六福珠寶" type:SSDKContentTypeAuto];
    }
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

// 实现代理方法获取到处理好的数据
- (void)acquireData:(NSArray *)arr
{
    self.dataArr = arr;
    [self.mbHUD hide:YES];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailCell" forIndexPath:indexPath];
    ProductDetailModel *model = self.dataArr[indexPath.row];
    cell.model = model;
//    NSLog(@"%@",model.url);
//    [cell.webView setScalesPageToFit:YES];
    [cell.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
    // 如果是第一个,那么隐藏左边的箭头,如果是最后一个,隐藏右边的箭头
    if (indexPath.row == 0) {
        cell.backImageView.hidden = YES;
    } else {
        cell.backImageView.hidden = NO;
    }
    if (indexPath.row == self.dataArr.count-1) {
        cell.forwardImageView.hidden = YES;
    } else {
        cell.forwardImageView.hidden = NO;
    }
    return cell;
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
