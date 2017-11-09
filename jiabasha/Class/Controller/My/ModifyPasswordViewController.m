//
//  ModifyPasswordViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ByPhoneNumModifyViewController.h"
#import "ByOldPasswordModifyViewController.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewPasswordCheck;
@property (weak, nonatomic) IBOutlet UIView *viewPhoneCheck;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_viewPhoneCheck addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPhoneClicked)]];
    [_viewPasswordCheck addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewPasswordClicked)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewPhoneClicked{
    ByPhoneNumModifyViewController* phoneModify = [[ByPhoneNumModifyViewController alloc]init];
    [self.navigationController pushViewController:phoneModify animated:YES];
}

- (void)viewPasswordClicked{
    ByOldPasswordModifyViewController* passModify = [[ByOldPasswordModifyViewController alloc]init];
    [self.navigationController pushViewController:passModify
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
