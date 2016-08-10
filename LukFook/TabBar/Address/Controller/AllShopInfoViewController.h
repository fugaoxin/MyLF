//
//  AllShopInfoViewController.h
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllShopInfoModel.h"
@interface AllShopInfoViewController : UIViewController

// 判断是国家列表(NO),还是省份列表(YES),获取不同的数据
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,strong)AllShopInfoModel *model;

@end
