//
//  AdViewController.m
//  jiabasha
//
//  Created by guok on 17/2/25.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "AdViewController.h"
#import "AppDelegate.h"
#import "JZMainTabController.h"
@interface AdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.adContent) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.adContent.contentPicUrl]];
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    _buttonClose.tag = 3;
    [_buttonClose setTitle:@"跳过 3s" forState:UIControlStateNormal];
    _buttonClose.backgroundColor=[UIColor blackColor];
    [_buttonClose addTarget:self action:@selector(GotoNextView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}
-(void)GotoNextView{
    AppDelegate *appDelegate = APP_DELEGATE;
    [appDelegate.MyTabBarController controlHomeClick];
}
- (void)countdown {
   
    NSInteger count = _buttonClose.tag-1;
    if (count <= 0) {
        [_timer invalidate];
        [self btnCloseClicked];
        
    } else {
        _buttonClose.tag = count;
        [_buttonClose setTitle:[NSString stringWithFormat:@"跳过 %ld", count] forState:UIControlStateNormal];
    }
}

- (IBAction)btnCloseClicked {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startAdViewBeginClick:nil];
}

- (IBAction)adImageViewClick {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startAdViewBeginClick:self.adContent.contentUrl];
}

@end
