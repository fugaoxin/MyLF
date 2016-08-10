//
//  ProductDetailDataManager.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductDetailDataManager.h"
#import "AFNetworkingTool.h"
#import "ProductDetailModel.h"
#import "ProductsSeriesModel.h"

#define POSTAPI @"http://lukfook.sinodynamic.com/api/get_items_by_collection_id/?lang="
#define SERIESAPI @"http://lukfook.sinodynamic.com/api/get_series_by_collection_id/"
#define myseriesAPI @"http://lukfook.sinodynamic.com/api/get_items_by_series_id/?lang="

@interface ProductDetailDataManager ()

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ProductDetailDataManager

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark-获取数据
- (void)getData:(NSString *)language
      productID:(NSString *)productID
{
    NSString *currentLanguage;
    if ([language isEqualToString:@"en"]) {
        currentLanguage = @"English";
    } else {
        currentLanguage = language;
    }
    NSString *postHead = [NSString stringWithFormat:@"%@api/get_items_by_collection_id/?lang=%@",LFAPI,currentLanguage];
    NSDictionary *bodyDic = @{@"id":productID};
    [AFNetworkingTool POSTwithURL:postHead params:bodyDic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *objectArr = responseObject[@"payload"];
        for (NSDictionary *dic in objectArr) {
            ProductDetailModel *model = [[ProductDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireData:self.dataArr];
        }
    } failure:^(NSError *error) {
//        NSLog(@"error======%@",error);
    }];
}

- (void)getData:(NSString *)language
      seriesID:(NSString *)productID
{
    NSString *currentLanguage;
    if ([language isEqualToString:@"en"]) {
        currentLanguage = @"English";
    } else {
        currentLanguage = language;
    }
    NSString *postHead = [NSString stringWithFormat:@"%@api/get_items_by_series_id/?lang=%@",LFAPI,currentLanguage];
    NSDictionary *bodyDic = @{@"id":productID};
    [AFNetworkingTool POSTwithURL:postHead params:bodyDic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *objectArr = responseObject[@"payload"];
        for (NSDictionary *dic in objectArr) {
            ProductDetailModel *model = [[ProductDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireData:self.dataArr];
        }
    } failure:^(NSError *error) {
        //        NSLog(@"error======%@",error);
    }];
}

- (void)getSeriesDataWithProductID:(NSString *)productID
{
    NSDictionary *bodyDic = @{@"q":productID};
    [AFNetworkingTool POSTwithURL:[NSString stringWithFormat:@"%@api/get_series_by_collection_id/",LFAPI] params:bodyDic success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        NSArray *objectArr = responseObject[@"series"];
        for (NSDictionary *dic in objectArr) {
            ProductsSeriesModel *model = [[ProductsSeriesModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireData:self.dataArr];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error======%@",error);
    }];
    
}


@end
