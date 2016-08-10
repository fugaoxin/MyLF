//
//  ProductsListModel.h
//  LukFook
//
//  Created by lin on 16/1/25.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsListModel : NSObject

@property(nonatomic,strong)NSString *banner_ch;      // 图片url
@property(nonatomic,strong)NSString *show_series;    // 是否有系列
@property(nonatomic,strong)NSString *title_zh;       // 简体中文
@property(nonatomic,strong)NSString *title_ch;       // 繁体
@property(nonatomic,strong)NSString *title_en;       // 英文
@property(nonatomic,strong)NSNumber *productID;      // 下一个接口的id

@end
