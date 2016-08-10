//
//  NSString+showLanguageValue.m
//  LukFook
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "NSString+showLanguageValue.h"

@interface NSString ()

@end

@implementation NSString (showLanguageValue)

// 根据传进来的 key 返回需要的值
+ (NSString *)showLanguageValue:(NSString *)key
{
    NSString *lanType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]];
    NSString *path = [[NSBundle mainBundle] pathForResource:lanType ofType:@"lproj"];
    NSString *showValue = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Language"];
    return showValue;
}

// 根据语言返回不同的值
- (NSString *)showLanguageValueWithSimplified:(NSString *)simplifiedStr
                                  traditional:(NSString *)traditionalStr
                                      english:(NSString *)englishStr
                           andCurrentLanguage:(NSString *)language
{
    // 根据语言的不同选择不同的字
//    _appLanguageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"zh-Hant"]) {
        return traditionalStr;
    }
    if ([language isEqualToString:@"zh-Hans"]) {
        return simplifiedStr;
    }
    return englishStr;
}

@end
