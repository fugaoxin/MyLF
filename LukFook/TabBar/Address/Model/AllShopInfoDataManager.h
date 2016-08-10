//
//  AllShopInfoDataManager.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AllShopInfoDataManagerDelegate <NSObject>

- (void)acquireData:(NSArray *)arr;

@end

@interface AllShopInfoDataManager : NSObject

@property(nonatomic,weak)id<AllShopInfoDataManagerDelegate>delegate;

- (void)getDataWithAPI:(NSString *)url;

@end
