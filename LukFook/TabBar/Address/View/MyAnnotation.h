//
//  MyAnnotation.h
//  MapDemo
//
//  Created by lanou on 15/11/18.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AddressModel.h"

//自定义的需要遵守协议
@interface MyAnnotation : NSObject<MKAnnotation>
//继承的
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

//自己的  为了标注多个视图的不同值,进行区分
@property (nonatomic) NSInteger tag;

@property(nonatomic,strong)AddressModel *model;

@end
