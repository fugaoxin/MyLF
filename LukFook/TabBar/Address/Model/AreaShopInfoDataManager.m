//
//  AreaShopInfoDataManager.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AreaShopInfoDataManager.h"
#import "AFNetworkingTool.h"
#import "AddressModel.h"

@interface AreaShopInfoDataManager ()

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation AreaShopInfoDataManager

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getDataWithShopID:(NSString *)shopID
{
//    http://lukfook.sinodynamic.com/api/stores/?p=88
    [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/stores/?p=%@",LFAPI,shopID] params:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *objectArr = responseObject[@"listings"];
        for (NSDictionary *dic in objectArr) {
            AddressModel *model = [[AddressModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireData:self.dataArr];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getAnotherDataWithShopID:(NSString *)shopID
{
    [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/stores/?r=%@",LFAPI,shopID] params:nil success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        NSArray *objectArr = responseObject[@"listings"];
        for (NSDictionary *dic in objectArr) {
            AddressModel *model = [[AddressModel alloc] init];
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
