//
//  AddressDataManager.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AddressDataManager.h"
#import "AFNetworkingTool.h"
#import "AddressModel.h"

#define ADDRESSAPI @"http://lukfook.sinodynamic.com/api/stores/"

@interface AddressDataManager ()

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation AddressDataManager

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData
{
    [AFNetworkingTool GETwithURL:[NSString stringWithFormat:@"%@api/stores/",LFAPI] params:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *listArr = responseObject[@"listings"];
        for (NSDictionary *dic in listArr) {
            AddressModel *model = [[AddressModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (self.delegate != nil) {
            [self.delegate acquireAddressData:self.dataArr];
        }
    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

@end
