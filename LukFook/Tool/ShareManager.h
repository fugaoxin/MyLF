//
//  ShareManager.h
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@protocol ShareManagerDelegate <NSObject>

-(void)showAlertViewController:(NSString*)tips;

@end

@interface ShareManager : NSObject

@property(nonatomic,weak)id<ShareManagerDelegate>delegate;

- (void)shareToFriendsWithText:(NSString *)str
                        images:(id)image
                           url:(NSURL *)url
                         title:(NSString *)title
                          type:(SSDKContentType)type;

@end
