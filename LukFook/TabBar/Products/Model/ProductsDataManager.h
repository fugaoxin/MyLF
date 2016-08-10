//
//  ProductsDataManager.h
//  LukFook
//
//  Created by lin on 16/1/25.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductsDataManagerDelegate <NSObject>

- (void)acquireDataFromAPI:(NSArray *)arr;

@end

@interface ProductsDataManager : NSObject

- (void)getAllDataFromAPI;

@property(nonatomic,weak)id<ProductsDataManagerDelegate>delegate;

@end
