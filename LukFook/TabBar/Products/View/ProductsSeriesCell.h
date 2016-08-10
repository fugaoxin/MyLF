//
//  ProductsSeriesCell.h
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsSeriesModel.h"

@interface ProductsSeriesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setModel:(ProductsSeriesModel *)model;

@end
