//
//  AppDelegate.m
//  LukFook
//
//  Created by lin on 16/1/21.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LanguageSelectedViewController.h"

// ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "AFNetworkingTool.h"
//arn:aws:sns:us-east-1:819247114127:app/APNS/LUKFOOK_APNS_UAT
#define APPLICATIONARN @"arn:aws:sns:us-east-1:819247114127:app/APNS/LUKFOOK_APNS_UAT"
#define TOPICARN @"arn:aws:sns:us-east-1:819247114127:LUKFOOK_COMMON_SANDBOX_APS"

#define REGISTERAPI @"http://snsfxuat.sinodynamic.com:9099/sns/register.api"
#define SUBSCRIPTAPI @"http://snsfxuat.sinodynamic.com:9099/sns/subscript.api"

@interface AppDelegate (){
    NSString *_sysVersion;
    NSString *_uuidStr;
    NSString *_currentLanguage;
    NSString *_endpointArn;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 判断是否是第一次登陆,如果是第一次登陆,那就先选择语言
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSelected"]) {
//        MainViewController *mainVC = [[MainViewController alloc] init];
//        self.window.rootViewController = mainVC;
//    } else {
//        LanguageSelectedViewController *languageVC = [[LanguageSelectedViewController alloc] init];
//        self.window.rootViewController = languageVC;
//    }
    
    LanguageSelectedViewController *languageVC = [[LanguageSelectedViewController alloc] init];
    self.window.rootViewController = languageVC;
    
    // 设置最上面导航的style
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar.png"]]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    [self setUpShareSDK];
    
    // 获取 UUID
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]) {
        _uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
//        NSLog(@"%@",uuidStr);
    } else {
        _uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        NSLog(@"%@",uuidStr);
        [[NSUserDefaults standardUserDefaults] setObject:_uuidStr forKey:@"UUID"];
    }

    // 获取当前版本
    _sysVersion = [[UIDevice currentDevice] systemVersion];
    // 获取设备使用的语言
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    _currentLanguage = [languages objectAtIndex:0];
    NSLog(@"languages===%@",languages);
    NSLog(@"currentLanguage===%@",_currentLanguage);
    
    //注册通知
    if ([_sysVersion floatValue] < 8.0) {
        //
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    } else {
        UIUserNotificationSettings* setting =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        [application registerForRemoteNotifications];
    }
    
//    //角标清0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    //清除所有通知(包含本地通知)
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    return YES;
}

//注册成功之后返回deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken>>>>%@",deviceToken);
    NSString *rawDeviceTring = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *noSpaces = [rawDeviceTring stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tmp1 = [noSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *TokenID = [tmp1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:TokenID forKey:@"TokenID"];
    NSDictionary *dic = @{@"applicationArn":APPLICATIONARN,@"deviceId":_uuidStr,@"token":TokenID,@"lang":_currentLanguage,@"systemVersion":_sysVersion,@"platform":@"iOS"};
    NSLog(@"dic>>>>%@",dic);
//    // 注册
//    [AFNetworkingTool POSTwithURL:REGISTERAPI params:dic success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        _endpointArn = responseObject[@"endpointArn"];
////        [self pushPushAPI:_endpointArn];
//        
//        NSDictionary *topicDic = @{@"topicArn":TOPICARN,@"endporintArn":_endpointArn};
//        [AFNetworkingTool POSTwithURL:SUBSCRIPTAPI params:topicDic success:^(id responseObject) {
////            NSLog(@"%@",responseObject);
//        } failure:^(NSError *error) {
////            NSLog(@"%@",error);
//        }];
//    } failure:^(NSError *error) {
////        NSLog(@"%@",error);
//    }];
}

//接收消息
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"asdadasd=====%@",userInfo);
    //application.applicationIconBadgeNumber =0;
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"number=====%lu",number);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushGoldChange" object:nil];
}

//- (void)pushPushAPI:(NSString *)endporintArn{
//    
//    NSString *url = @"http://snsfx.sinodynamic.com:8080/sns/push.api";
//    //NSString *url = @"http://sns_fx_uat.sinodynamic.com:9099/sns/push.api";
//    // 执行请求
//    NSDictionary *param = @{
//                            @"deviceArn" : endporintArn,
//                            @"message" : @"GTAMEMBER Test message",//message would like to push
//                            @"sound" : @"On", ///off (default is On)
//                            @"badge" : @"Badge",
//                            @"otherPayload" : @"{\"aps\":{\"alert\":\"GTA推送测试!\",\"badge\":5,\"sound\":\"beep.wav\"},\"acme1\":\"bar\",\"acme2\":42}",//Other Payload, please use json format
//                            };
//    NSLog(@"param: %@", param);
//    
//    [AFNetworkingTool POSTwithURL:url params:param success:^(id responseObject) {
////        NSLog(@"responseObject=======%@",responseObject);
//    } failure:^(NSError *error) {
////        NSLog(@"error===========%@",error);
//    }];
//    
//}

#pragma mark-注册ShareSDK
- (void)setUpShareSDK
{
    [ShareSDK registerApp:@"f2f8412f0814"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeFacebook)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
//                         case SSDKPlatformTypeSinaWeibo:
//                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                             break;
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
//                         case SSDKPlatformTypeSinaWeibo:
                             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                             [appInfo SSDKSetupSinaWeiboByAppKey:@"2872939915"
//                                                       appSecret:@"9003d64b7b829acd171ba14c8c1b0087"
//                                                     redirectUri:@"http://www.sharesdk.cn"
//                                                        authType:SSDKAuthTypeBoth];
//                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:@"wx045e0fc0cd013b8a"
                                                   appSecret:@"6b40ac60f21a861efc63d22f08eae694"];
                             break;
                         case SSDKPlatformTypeFacebook:
                             //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                             //689963784477875
                             //94e3592a9b4e1497b527e92bc7253600
                             [appInfo SSDKSetupFacebookByApiKey:@"376228282501400"
                                                      appSecret:@"51236e1af3e2cb25f936c7b2e8735ea8"
                                                       authType:SSDKAuthTypeBoth];
                             break;
                     }
                 }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
