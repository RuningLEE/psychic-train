//
//  MessageViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemNotifyViewController.h"
#import "PrivateLetterViewController.h"

@interface MessageViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineLeadingConstant;
@property (weak, nonatomic) IBOutlet UILabel *labelSystemNotice;
@property (weak, nonatomic) IBOutlet UILabel *labelPersonalLetter;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) UIScrollView *scrollViewMain;
@property (strong, nonatomic) SystemNotifyViewController *systemVC;
@property (strong, nonatomic) PrivateLetterViewController *privateLetterVC;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self initUITapGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置子控件
- (void)setUp{
    CGFloat const height = kScreenHeight-64-35;
    
    //设定scrollview
    _scrollViewMain = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 99, kScreenWidth, height)];
    _scrollViewMain.backgroundColor = RGB(246, 246, 246);
    _scrollViewMain.contentSize = CGSizeMake(kScreenWidth, height);
    _scrollViewMain.bounces = NO;
    _scrollViewMain.pagingEnabled = YES;
    _scrollViewMain.showsVerticalScrollIndicator = NO;
    _scrollViewMain.showsHorizontalScrollIndicator = NO;
    _scrollViewMain.delegate = self;
    [self.view addSubview:_scrollViewMain];
    
    //设定scrollview中的视图
    [self labelSystemClicked];
}

- (void)initUITapGestureRecognizer{
    [_labelSystemNotice addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelSystemClicked)]];
    [_labelPersonalLetter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPrivateClicked)]];
}

#pragma mark - labelClick
- (void)labelSystemClicked{
    _labelSystemNotice.textColor = RGB(96, 25, 134);
    _labelPersonalLetter.textColor = RGB(34, 34, 34);
    CGFloat const height = kScreenHeight-64-35;
    [_scrollViewMain removeAllSubviews];
    
    _underLineLeadingConstant.constant = 59;
    
    SystemNotifyViewController* system = [[SystemNotifyViewController alloc]init];
    system.view.frame = self.view.bounds;
    system.view.height = height;
    system.view.width = kScreenWidth;
    [self addChildViewController:system];
    [_scrollViewMain addSubview:system.view];
    _systemVC = system;
}

- (void)labelPrivateClicked{
    _labelSystemNotice.textColor = RGB(34, 34, 34);
    _labelPersonalLetter.textColor = RGB(96, 25, 134);
    CGFloat const height = kScreenHeight-64-35;
    [_scrollViewMain removeAllSubviews];
 
    CGFloat slideWidth = kScreenWidth - 59*2 - 64;
    _underLineLeadingConstant.constant = slideWidth + 59;
    
    PrivateLetterViewController* private = [[PrivateLetterViewController alloc]init];
    private.view.frame = self.view.bounds;
    private.view.height = height;
    private.view.width = kScreenWidth;
    [self addChildViewController:private];
    [_scrollViewMain addSubview:private.view];
    _privateLetterVC = private;
}

#pragma mark - buttonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
