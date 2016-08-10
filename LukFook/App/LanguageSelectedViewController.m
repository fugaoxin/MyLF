//
//  LanguageSelectedViewController.m
//  LukFook
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "LanguageSelectedViewController.h"
#import "MainViewController.h"
#import "AFNetworkingTool.h"

@interface LanguageSelectedViewController ()

@property(nonatomic,strong) NSString * sysVersion;
@property(nonatomic,strong) NSString * uuidStr;
@property(nonatomic,strong) NSString * TokenID;

@end

@implementation LanguageSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * line1=[[UILabel alloc] initWithFrame:CGRectMake(((SCREENWIDTH-57)/2-40-57)/2+40+57, SCREENHEIGHT-100-30, 1.5, 25)];
    line1.backgroundColor=RGBCOLOR(80, 43, 21, 1);
    [self.view addSubview:line1];
    UILabel * line2=[[UILabel alloc] initWithFrame:CGRectMake(((SCREENWIDTH-57)/2-40-57)/2+SCREENWIDTH/2+28.5+8, SCREENHEIGHT-100-30, 1.5, 25)];
    line2.backgroundColor=RGBCOLOR(80, 43, 21, 1);
    [self.view addSubview:line2];
}

- (IBAction)TraditionalButtonAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        [self setPush:@"zh-Hant"];
    });
    [self pushNewController];
}

- (IBAction)SimplifiedButtonAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        [self setPush:@"zh-Hans"];
    });
    [self pushNewController];
}

- (IBAction)ENGButtonAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        [self setPush:@"en"];
    });
    [self pushNewController];
}

-(void)setPush:(NSString *)lang{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TokenID"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]) {
            self.uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
        } else {
            self.uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [[NSUserDefaults standardUserDefaults] setObject:_uuidStr forKey:@"UUID"];
        }
        self.sysVersion = [[UIDevice currentDevice] systemVersion];
        self.TokenID=[[NSUserDefaults standardUserDefaults] objectForKey:@"TokenID"];
        NSDictionary *dic = @{@"deviceId":self.uuidStr,@"token":self.TokenID,@"systemVersion":_sysVersion,@"lang":lang};
        NSLog(@">>>>>>>>>>>dic<<<<<<<%@",dic);
        [AFNetworkingTool pushPOSTwithURL:[NSString stringWithFormat:@"%@api/register_device/",LFAPI] params:dic success:^(id responseObject) {
            NSLog(@"responseObject====%@",responseObject);
            NSString *JSONString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"responseJSON====%@",responseJSON);
        } failure:^(NSError *error) {
            NSLog(@"error====%@",error);
        }];
    }
}

// 推出新控制器
- (void)pushNewController
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"isSelected" forKey:@"LanguageSelected"];
    MainViewController *mainVC = [[MainViewController alloc] init];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSelected"]) {
//        // 返回的时候发送通知,让之前加载的页面重新加载
//        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
//        [notification postNotificationName:@"changeLanguage" object:nil];
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:@"isSelected" forKey:@"LanguageSelected"];
//        [self presentViewController:mainVC animated:YES completion:nil];
//    }
    
    [self presentViewController:mainVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
