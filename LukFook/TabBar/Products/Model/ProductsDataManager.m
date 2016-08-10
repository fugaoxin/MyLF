//
//  ProductsDataManager.m
//  LukFook
//
//  Created by lin on 16/1/25.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsDataManager.h"
#import "ProductsListModel.h"
#import "AFNetworkingTool.h"

@interface ProductsDataManager ()

@property (nonatomic,strong)NSMutableArray *productsDataArr;

@end

@implementation ProductsDataManager

- (NSMutableArray *)productsDataArr
{
    if (_productsDataArr == nil) {
        self.productsDataArr = [NSMutableArray array];
    }
    return _productsDataArr;
}

- (void)getAllDataFromAPI
{
    __weak ProductsDataManager *weakSelf = self;
    //@"http://lukfook.sinodynamic.com/api/get_collection/"
    [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/get_collection/",LFAPI] params:nil success:^(id responseObject) {
        //NSLog(@"responseObject==%@",responseObject);
        NSArray *arr = responseObject[@"collection"];
        for (NSDictionary *dic in arr) {
            ProductsListModel *model = [[ProductsListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.productsDataArr addObject:model];
//            NSLog(@"%ld",self.productsDataArr.count);
        }
        if (weakSelf.delegate != nil) {
            [weakSelf.delegate acquireDataFromAPI:self.productsDataArr];
        }
    } failure:^(NSError *error) {
        NSLog(@"error===%@",error);
    }];
    
}

@end
