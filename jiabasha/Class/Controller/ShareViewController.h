//
//  ShareViewController.h
//  wedding
//
//  Created by Jianyong Duan on 14/12/10.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//

@interface ShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForFriends;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForWeibo;


- (IBAction)shareClick:(UIControl *)sender;

- (IBAction)closeClick:(id)sender;

//input
@property (nonatomic, strong) NSDictionary *shareContent;

@end
