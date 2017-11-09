//
//  GuideViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < 4; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        [imageView setBackgroundColor:[UIColor redColor]];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"引导图%i",i + 1]]];
        [self.scrollView addSubview:imageView];
        if (i==3) {
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight);
            button.alpha = 0.5;
            [button addTarget:appDelegate action:@selector(guideViewBeginClick) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:button];
        }
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>kScreenWidth*3+20) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(guideViewBeginClick)]) {
            [appDelegate guideViewBeginClick];
        }
    }
}

//- (void)beginClick
//{
//    self.view.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//    }];
//}


@end
