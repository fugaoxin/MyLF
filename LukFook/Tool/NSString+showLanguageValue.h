//
//  NSString+showLanguageValue.h
//  LukFook
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (showLanguageValue)

+ (NSString *)showLanguageValue:(NSString *)key;

- (NSString *)showLanguageValueWithSimplified:(NSString *)simplifiedStr
                                  traditional:(NSString *)traditionalStr
                                      english:(NSString *)englishStr
                           andCurrentLanguage:(NSString *)language;

@end
