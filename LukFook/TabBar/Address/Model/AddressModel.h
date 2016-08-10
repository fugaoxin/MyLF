//
//  AddressModel.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property(nonatomic,strong)NSString *myLongitude;       // 经度
@property(nonatomic,strong)NSString *myLatitude;        // 纬度
@property(nonatomic,strong)NSString *show_province;     // 是否有省份分类
@property(nonatomic,strong)NSString *address_zh;        // 简体
@property(nonatomic,strong)NSString *address_ch;        // 繁体
@property(nonatomic,strong)NSString *address_en;        // 英文
@property(nonatomic,strong)NSString *hours_ch;          // 营业时间
@property(nonatomic,strong)NSString *creation_date;     // 开业时间
@property(nonatomic,strong)NSString *title_zh;          // 店名(简体)
@property(nonatomic,strong)NSString *title_ch;          // 店名(繁体)
@property(nonatomic,strong)NSString *title_en;          // 店名(英文)
@property(nonatomic,strong)NSString *phone;             // 电话
@property(nonatomic,strong)NSString *shopID;            // id
@property(nonatomic,strong)NSString *picture_big;       // 图片url

@end
