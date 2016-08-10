//
//  ProductsSeriesModel.h
//  LukFook
//
//  Created by 123 on 16/3/28.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsSeriesModel : NSObject

@property(nonatomic,strong)NSString *banner_ch;
@property(nonatomic,strong)NSString *banner_en;
@property(nonatomic,strong)NSString *banner_zh;

@property(nonatomic,strong)NSString *collection_title;
@property(nonatomic,strong)NSString *collection_title_ch;
@property(nonatomic,strong)NSString *collection_title_en;
@property(nonatomic,strong)NSString *collection_title_zh;

@property(nonatomic,strong)NSString *title_ch;
@property(nonatomic,strong)NSString *title_en;
@property(nonatomic,strong)NSString *title_zh;

@property(nonatomic,strong)NSString *show_list_table;

@property(nonatomic,strong)NSNumber *productID;      // 下一个接口的id

@end
