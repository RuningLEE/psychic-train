//
//  CIWMaskActivityView.m
//

#import "CIWMaskActivityView.h"

@implementation CIWMaskActivityView

+ (id)loadFromXib{
    CIWMaskActivityView* maskActivityView = nil;
//    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CIWMaskActivityView class]] pathForResource:@"CIWBundle" ofType:@"bundle"]];
    NSBundle *bundle = [NSBundle bundleForClass:[CIWMaskActivityView class]];
    NSArray *xibs =[bundle loadNibNamed:@"CIWMaskActivityView" owner:nil options:nil];
    if(xibs && xibs.count){
        maskActivityView = [xibs objectAtIndex:0];
    }
    return maskActivityView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _bgMaskView.layer.masksToBounds = YES;
    _bgMaskView.layer.cornerRadius = 5;
    UILabel *label = (UILabel *)[_bgMaskView viewWithTag:1234];
    label.text = @"";
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CIWMaskActivityView class]] pathForResource:@"CIWBundle" ofType:@"bundle"]];
    UIImage *loadingImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_pulldown_refresh@2x" ofType:@"png"]];
    [_loadingImage setImage:loadingImage];
    
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = 1000;
    
    rotate.duration = 0.25;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_loadingAnimaView.layer addAnimation:rotate forKey:@"rotateAnimation"];
    
    _loadingAnimaView.progress = 1;
    [_loadingAnimaView setNeedsDisplay];

}

- (void)showInView:(UIView *)parentView withMessage:(NSString *)strMessage
{
    UILabel *label = (UILabel *)[_bgMaskView viewWithTag:1234];
    label.text = strMessage ? : @"";
    [label sizeToFit];
    
    _bgMaskView.width = (label.width < _bgMaskView.width) ? _bgMaskView.width : (label.width);
    _bgMaskView.height += 5;
    label.top = _bgMaskView.height - label.height-5;
    
    [self showInView:parentView];
}

- (void)showInView:(UIView*)parentView{
    
    if(!parentView){
        return;
    }
    
    self.userInteractionEnabled = !self.isTouch;
    [self nextResponder];
    
    UILabel *label = (UILabel *)[_bgMaskView viewWithTag:1234];
    if(label.text.length == 0){
        _titleLabelHeight.constant = 0;
    }
    
    
    self.alpha = 0.1;
    [parentView addSubview:self];

    /**默认平铺整个试图，判断到self.view 会空出导航条位置*/
    CGFloat top = 0;

    if(parentView.tag == kSelf_View_Tag){
         top = ([UIDevice currentDevice].systemVersion.floatValue) >= 7.0 ? 64.:44.;
    }
    NSDictionary *metricsDic = @{@"top":[NSNumber numberWithFloat:top]
                                 };
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    [UIView ciw_AddConstraintsWithParameter:metricsDic
                                   viewsDic:views
                            visualFormatArr:@[@"H:|-0-[self]-0-|",
                                            @"V:|-top-[self]-0-|"]
                           addConstraintsTo:parentView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1;
                     } 
                     completion:^(BOOL finished) {
                         //
                     }];
}


- (void)showInView:(UIView*)parentView withIsTouch:(BOOL)isTouch{
    self.isTouch = isTouch;
    [self showInView:parentView];
}


- (void)hide{
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
- (void)dealloc {
    _bgMaskView = nil;
}
@end
