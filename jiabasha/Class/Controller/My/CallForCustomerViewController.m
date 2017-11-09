//
//  CallForCustomerViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CallForCustomerViewController.h"

@interface CallForCustomerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;

@end

@implementation CallForCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelCommunicate:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)call:(id)sender {
}

@end
