//
//  ProductDetailCell.h
//  LukFook
//
//  Created by lin on 16/2/3.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

@interface ProductDetailCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *forwardImageView;

@property(nonatomic,strong)ProductDetailModel *model;

@end
