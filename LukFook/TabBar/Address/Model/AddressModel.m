//
//  AddressModel.m
//  LukFook
//
//  Created by lin on 16/2/4.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"latitude"]) {
        [self setValue:value forKey:@"myLatitude"];
    }
    if ([key isEqualToString:@"longitude"]) {
        [self setValue:value forKey:@"myLongitude"];
    }
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"shopID"];
    }
}

@end
