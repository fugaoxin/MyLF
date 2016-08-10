//
//  ProductDetailDataManager.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductDetailDataManagerDelegate <NSObject>

- (void)acquireData:(NSArray *)arr;

@end

@interface ProductDetailDataManager : NSObject

@property(nonatomic,weak)id<ProductDetailDataManagerDelegate>delegate;

- (void)getData:(NSString *)language
      productID:(NSString *)productID;

- (void)getData:(NSString *)language
      seriesID:(NSString *)productID;

- (void)getSeriesDataWithProductID:(NSString *)productID;

@end
