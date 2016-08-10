//
//  LanguageSelectedViewController.h
//  LukFook
//
//  Created by lin on 16/1/26.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageSelectedViewControllerDelegate <NSObject>

@end

@interface LanguageSelectedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *textHK;
@property (weak, nonatomic) IBOutlet UIButton *textCN;
@property (weak, nonatomic) IBOutlet UIButton *textEN;

@end
