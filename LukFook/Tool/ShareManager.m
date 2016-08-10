//
//  ShareManager.m
//  LukFook
//
//  Created by lin on 16/1/29.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

- (void)shareToFriendsWithText:(NSString *)str
                        images:(id)image
                           url:(NSURL *)url
                         title:(NSString *)title
                          type:(SSDKContentType)type
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:str
                                     images:image
                                        url:url
                                      title:title
                                       type:type];
    
    NSString *currentLanugage = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    __weak ShareManager *weakSelf = self;
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           if (weakSelf.delegate != nil) {
                               NSString *shareStr = [[NSString alloc] showLanguageValueWithSimplified:@"分享成功" traditional:@"分享成功" english:@"Sharing Success" andCurrentLanguage:currentLanugage];
                               [weakSelf.delegate showAlertViewController:shareStr];
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (weakSelf.delegate != nil) {
                               NSString *shareStr = [[NSString alloc] showLanguageValueWithSimplified:@"分享失败" traditional:@"分享失敗" english:@"Sharing Failure" andCurrentLanguage:currentLanugage];
                               [weakSelf.delegate showAlertViewController:shareStr];
                               NSLog(@"error===%@",error);
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           if (weakSelf.delegate != nil) {
                               NSString *shareStr = [[NSString alloc] showLanguageValueWithSimplified:@"分享取消" traditional:@"分享取消" english:@"Sharing Cancelled" andCurrentLanguage:currentLanugage];
                               [weakSelf.delegate showAlertViewController:shareStr];
                           }
                           break;
                       }
                           
                       default:
                           break;
                   }
                   
               }];
}

@end
