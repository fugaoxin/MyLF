//
//  AreaShopInfoTableViewCell.h
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AreaShopInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)AddressModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
