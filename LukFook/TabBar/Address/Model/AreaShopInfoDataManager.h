//
//  AreaShopInfoDataManager.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AreaShopInfoDataManagerDelegate <NSObject>

- (void)acquireData:(NSArray *)arr;

@end

@interface AreaShopInfoDataManager : NSObject

@property(nonatomic,weak)id<AreaShopInfoDataManagerDelegate>delegate;

- (void)getDataWithShopID:(NSString *)shopID;

- (void)getAnotherDataWithShopID:(NSString *)shopID;

@end
