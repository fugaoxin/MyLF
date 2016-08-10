//
//  ProductsListModel.m
//  LukFook
//
//  Created by lin on 16/1/25.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ProductsListModel.h"

@implementation ProductsListModel

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
