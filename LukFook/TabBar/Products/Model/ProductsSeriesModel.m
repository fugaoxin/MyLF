//
//  ProductsSeriesModel.m
//  LukFook
//
//  Created by 123 on 16/3/28.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsSeriesModel.h"

@implementation ProductsSeriesModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"productID"];
    }
}

@end
