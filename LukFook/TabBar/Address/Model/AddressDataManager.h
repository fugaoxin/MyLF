//
//  AddressDataManager.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddressDataManagerDelegate <NSObject>

- (void)acquireAddressData:(NSArray *)arr;

@end

@interface AddressDataManager : NSObject

@property(nonatomic,weak)id<AddressDataManagerDelegate>delegate;

- (void)getData;

@end
