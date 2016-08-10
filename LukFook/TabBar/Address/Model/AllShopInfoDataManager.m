//
//  AllShopInfoDataManager.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AllShopInfoDataManager.h"
#import "AFNetworkingTool.h"
#import "AllShopInfoModel.h"


@interface AllShopInfoDataManager ()

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation AllShopInfoDataManager

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getDataWithAPI:(NSString *)url
{
    [AFNetworkingTool GETwithURL:url params:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *listArr = responseObject[@"listings"];
        for (NSDictionary *dic in listArr) {
            AllShopInfoModel *model = [[AllShopInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireData:self.dataArr];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
