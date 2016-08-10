//
//  ShopInfoView.h
//  LukFook
//
//  Created by lin on 16/1/28.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol ShopInfoViewDelegate <NSObject>

- (void)callTheShopPhone;

@end

@interface ShopInfoView : UIView

@property (nonatomic,weak)id<ShopInfoViewDelegate>delegate;

- (CGFloat)getHeightOfView;

- (instancetype)initWithFrame:(CGRect)frame
                        model:(AddressModel *)model;

@end
