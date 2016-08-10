//
//  AllShopInfoTableViewCell.h
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllShopInfoModel.h"

@interface AllShopInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong)AllShopInfoModel *model;

@end
