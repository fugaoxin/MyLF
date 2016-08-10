//
//  ProductDetailCell.m
//  LukFook
//
//  Created by lin on 16/2/3.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.webView.scrollView.scrollEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
}

@end
