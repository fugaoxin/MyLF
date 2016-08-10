//
//  CalculatorViewController.m
//  LukFook
//
//  Created by lin on 16/1/25.
//  Copyright © 2016年 JimmyLin. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController () <UITextFieldDelegate>

/*
 nameLabel               产品名称
 unitLabel(unitLabel_2)  计量单位(两)
 weightLabel             货品金重
 costLabel               人工
 commissionLabel         佣金
 totalPriceLabel         货品总价
 
 productPriceLabel       产品价格
 weightTextField         输入货品金重的重量
 costTextField           输入人工的费用
 commissionCostLabel     佣金金额
 totalPriceCostLabel     货品总价金额
 */

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *commissionCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title = [NSString showLanguageValue:@"tabBarButton1"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"MJNgaiHK-Medium" size:17]}];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"button_back.png" title:@"backItem" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBackgroundImage:@"" image:@"common_back_btn" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    UIImage * image=[UIImage imageNamed:@"common_header_bg2"];
    //image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    //image=[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.backgroundImageView.userInteractionEnabled = YES;
    self.weightTextField.delegate = self;
    self.costTextField.delegate = self;
    self.weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self setLabelStrWithDifferentLanguage];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:[self.price floatValue]]];
    self.productPriceLabel.text = [NSString stringWithFormat:@"HK$%@.00 /",priceStr];
    
    // 设置点击空白处回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    // 字体大小自动适应
    self.commissionCostLabel.adjustsFontSizeToFitWidth = YES;
    self.totalPriceCostLabel.adjustsFontSizeToFitWidth = YES;
    [self setShadowStyle:self.weightTextField];
    [self setShadowStyle:self.costTextField];
    self.totalPriceLabel.hidden=YES;
    self.totalPriceCostLabel.hidden=YES;
    
    UIImage * img = [UIImage imageNamed:@"calculator_background"];
    UIImage * Image =[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    self.backgroundImageView.image=Image;
}

- (void)setShadowStyle:(UITextField *)textField
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:textField.bounds];
    textField.layer.masksToBounds = NO;
    textField.layer.shadowColor = [UIColor blackColor].CGColor;
    textField.layer.shadowOffset = CGSizeMake(5.0f, 0.0f);
    textField.layer.shadowOpacity = 0.4f;
    textField.layer.shadowPath = shadowPath.CGPath;
}

// 返回主页
- (void)leftBarButtonItemAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击空白处回收键盘
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

// 设置各个label显示的字(简体,繁体,英文)
- (void)setLabelStrWithDifferentLanguage
{
    /*
     // 饰金计算机页面的 label 显示的文字
     "calculatorName" = "9999金价";
     "calculatorWeight" = "货品金重";
     "calculatorCost" = "人工";
     "calculatorCommission" = "佣金";
     "calculatorTotalPrice" = "货品总价";
     "calculatorUnit" = "两";
     */
    self.nameLabel.text = [NSString showLanguageValue:@"calculatorName"];
    self.weightLabel.text = [NSString showLanguageValue:@"calculatorWeight"];
    self.costLabel.text = [NSString showLanguageValue:@"calculatorCost"];
//    self.commissionLabel.text = [NSString showLanguageValue:@"calculatorCommission"];
//    self.totalPriceLabel.text = [NSString showLanguageValue:@"calculatorTotalPrice"];
    self.commissionLabel.text = [NSString showLanguageValue:@"calculatorTotalPrice"];
    self.unitLabel.text = [NSString showLanguageValue:@"calculatorUnit"];
    self.unitLabel_2.text = [NSString showLanguageValue:@"calculatorUnit"];
    
    // 设置行间距和字间距
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:self.weightLabel.text attributes:@{NSKernAttributeName : @(0.1f)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.weightLabel.text.length)];
    [self.weightLabel setAttributedText:attributedString];
    
    NSMutableAttributedString *attributed =  [[NSMutableAttributedString alloc] initWithString:self.costLabel.text attributes:@{NSKernAttributeName : @(0.1f)}];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:1];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.costLabel.text.length)];
    [self.costLabel setAttributedText:attributed];
}

// 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 结束编辑的时候计算出价格
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 确定输入的数字格式是浮点型的
    if (![self isFloat:self.costTextField.text]) {
        self.costTextField.text = @"";
    }
    if (![self isFloat:self.weightTextField.text]) {
        self.weightTextField.text = @"";
    }
    // 如果其中有个值是空的,那么就不计算,直接返回.
    if (self.weightTextField.text == nil || [self.weightTextField.text isEqualToString:@""] || self.weightTextField.text == NULL || self.costTextField.text == nil || [self.costTextField.text isEqualToString:@""] || self.costTextField.text == NULL) {
        return;
    }
    // 佣金 = 商品现价/100*货品金重*2
    // 总价 = 商品现价*货品金重+佣金+人工
    //float CommissionPrice = [self.price floatValue] / 100 * [self.weightTextField.text floatValue] * 2;
    //float totalPrice = [self.price floatValue] * [self.weightTextField.text floatValue] + CommissionPrice + [self.costTextField.text floatValue];
    float totalPrice = [self.price floatValue] * [self.weightTextField.text floatValue]*1.02 + [self.costTextField.text floatValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    //NSString *commissionPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:CommissionPrice]];
    NSString *totalPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:totalPrice]];
//    NSLog(@"%@",totalPriceStr);
    // 去掉货币符号
    // 获取到货币符号从哪个下标开始,然后截取后面的金额
    if ([totalPriceStr containsString:@"$"]) {
        NSRange range = [totalPriceStr rangeOfString:@"$"];
        //self.commissionCostLabel.text = [commissionPriceStr substringFromIndex:range.location+1];
        self.commissionCostLabel.text = [totalPriceStr substringFromIndex:range.location+1];
        return;
    }
    if ([totalPriceStr containsString:@"￥"]) {
        NSRange range = [totalPriceStr rangeOfString:@"￥"];
        //self.commissionCostLabel.text = [commissionPriceStr substringFromIndex:range.location+1];
        self.commissionCostLabel.text = [totalPriceStr substringFromIndex:range.location+1];
        return;
    }
    //self.commissionCostLabel.text = commissionPriceStr;
    self.commissionCostLabel.text = totalPriceStr;
}

// 判断是否是浮点型
- (BOOL)isFloat:(NSString *)floatStr
{
    NSScanner *scan = [NSScanner scannerWithString:floatStr];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
