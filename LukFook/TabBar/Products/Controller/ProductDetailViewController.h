//
//  ProductDetailViewController.h
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsListModel.h"
#import "ProductsSeriesModel.h"

@interface ProductDetailViewController : UIViewController

@property(nonatomic,strong)ProductsListModel *listModel;
@property(nonatomic,strong)ProductsSeriesModel *SeriesModel;

@end
