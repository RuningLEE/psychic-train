//
//  CIWHiddenTabBarViewController.m
//

#import "CIWHiddenTabBarViewController.h"
@interface CIWHiddenTabBarViewController()
- (void)hideOriginalTabBar;
@end
@implementation CIWHiddenTabBarViewController
- (void)hideOriginalTabBar{
    UIView *contentView;
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
		contentView = [self.view.subviews objectAtIndex:1];
	}
	else {
		contentView = [self.view.subviews objectAtIndex:0];
	}
	contentView.height = [[[UIApplication sharedApplication].delegate window] height];
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.alpha = 0;
            view.hidden = YES;
			break;
		}
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self hideOriginalTabBar];
}

- (void)setSelectedTabIndex:(NSUInteger)selectedIndex{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.type = kCATransitionFade;
//    transition.subtype = kCATransitionFromTop;
//    UIWindow *window = [AppDelegate GetAppDelegate].window;
//    [window.layer addAnimation:transition forKey:nil];
    [self setSelectedIndex:selectedIndex];
}

@end
