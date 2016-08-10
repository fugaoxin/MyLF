//
//  ProductsCell.h
//  LukFook
//
//  Created by lin on 16/1/22.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsListModel.h"

@interface ProductsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ImaView;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property(nonatomic,strong)ProductsListModel *model;

@end
