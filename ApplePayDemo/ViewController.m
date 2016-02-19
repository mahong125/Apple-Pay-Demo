//
//  ViewController.m
//  ApplePayDemo
//
//  Created by mahong on 16/2/19.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@property (strong, nonatomic) UILabel *infoLabel;

@property (strong, nonatomic) PKPaymentButton *payButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 100)];
    _infoLabel.text = @"展示商品信息\n价格：$1.99\n其他描述信息";
    _infoLabel.numberOfLines = 0;
    [self.view addSubview:_infoLabel];
    
    _payButton = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleWhiteOutline];
    _payButton.frame = CGRectMake(30, CGRectGetMaxY(_infoLabel.frame)+30, self.view.frame.size.width-60, 40);
    [_payButton addTarget:self action:@selector(applePay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payButton];
}

- (void)applePay
{
     /** 监测当前设备是否支持Apple Pay */
    if ([PKPaymentAuthorizationViewController canMakePayments])
    {
        /** 1 创建 PKPaymentRequest */
        PKPaymentRequest *payReq = [[PKPaymentRequest alloc] init];
        payReq.merchantIdentifier = @"merchant.com.runbey.ybjk";
        payReq.countryCode = @"CH";
        payReq.currencyCode = @"USD";
        payReq.supportedNetworks = @[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay,PKPaymentNetworkMasterCard,PKPaymentNetworkAmex];
        payReq.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit | PKMerchantCapabilityEMV;
        
        /** 2 支付金额列表以及总数 */
        PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"手机" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"电脑" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"总计" amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]];
        
        payReq.paymentSummaryItems = @[item1,item2,total];
        
        /** 3 展示支付鉴权界面 */
        PKPaymentAuthorizationViewController *payVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:payReq];
        payVC.delegate = self;
        [self presentViewController:payVC animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前设备不支持" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark -  PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    
}

/**
 *  支付结束
 */
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
