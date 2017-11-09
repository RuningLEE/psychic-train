//
//  MessageView.m


#import "MessageView.h"
#import "PureLayout.h"

@interface MessageView()
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@end

@implementation MessageView
@synthesize messageLabel = _messageLabel;


+ (MessageView *)loadFromNib{
    NSBundle *bundle = [NSBundle bundleForClass:[MessageView class]];
    MessageView *messageView = nil;
    NSArray *xibs = [bundle loadNibNamed:@"MessageView" owner:nil options:nil];
    if(xibs && xibs.count){
        messageView = xibs.firstObject;
    }
    return messageView;
}

- (void)awakeFromNib{
//    [super awakeFromNib];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.8;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:82/255.0 blue:122/255.0 alpha:0.9];

    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8;
}

- (void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview]; 
        }
    }];
}


+ (MessageView *)displayMessageByErr:(NSString *)err {
    NSString *message = err;
    
    if ([@"user.u_uname_exists" isEqualToString:err]) {
        message = @"号码已被注册，换个号码再试试";
    } else if ([@"user.u_not_exists" isEqualToString:err]) {
        message = @"手机号不存在，换个号码再试试";
    } else if ([@"err.catpure.err" isEqualToString:err]) {
        message = @"验证码填写错误~";
    } else if ([@"err.code.err" isEqualToString:err]) {
        message = @"验证码填写错误";
    } else if ([err isEqualToString:@"reserve.u_close"]) {
        message = @"预约时间已截止，换个时间再来";
    } else if ([err isEqualToString:@"reserve.u_month_store_limit"]){
        message = @"您预约次数太多啦，换个行业吧";
    } else if ([err isEqualToString:@"err.phone.isexists"]){
        message = @"手机号码已存在";
    } else if ([err isEqualToString:@"cash_coupon.u_args"]){
        message = @"啊，发生未知错误，一会再来试试";
    } else if ([err isEqualToString:@"cash_coupon.u_cash_coupon_not_found"]){
        message = @"这张券走失了，换个店铺吧";
    } else if ([err isEqualToString:@"cash_coupon.u_receive_not_start"]){
        message = @"还没到领券时间哦";
    } else if ([err isEqualToString:@"cash_coupon.u_receive_end"]){
        message = @"兑换已结束，下次再来吧";
    } else if ([err isEqualToString:@"cash_coupon.u_cash_coupon_is_out"]){
        message = @"没有库存了";
    } else if ([err isEqualToString:@"user.u_phone_not_bind"]){
        message = @"您还未绑定手机号哦";
    } else if ([err isEqualToString:@"cash_coupon.u_exchange_limit"]){
        message = @"领券次数超限啦";
    } else if ([err isEqualToString:@"cash_coupon.u_integral_lack"]){
        message = @"积分余额不足啦";
    } else if ([err isEqualToString:@"cash_coupon.u_for_normal"]){
        message = @"领现金券前需要先预约该店铺哦~~";
    } else if ([err isEqualToString:@"cash_coupon.u_for_expo"]){
        message = @"领现金券前需要先预约该店铺哦！";
    } else if ([err isEqualToString:@"cash_coupon.u_cash_coupon_store_error"]){
        message = @"现金券店铺检查失败";
    } else if ([err isEqualToString:@"cash_coupon.u_for_expo"]){
        message = @"领现金券前需要先预约该店铺哦~";
    } else if ([err isEqualToString:@"order.u_args store null"]){
        message = @"小主，该商家走丢了~";
    } else if ([err isEqualToString:@"appointhbh.u_store_verify"]){
        message = @"小主，该商家暂不支持预约哦~";
    } else if ([err isEqualToString:@"appointhbh.u_repeat"]){
        message = @"小主，您已预约过该商家了~";
    } else if ([err isEqualToString:@"appointhbh.u_close"]){
        message = @"小主，当前还不能预约到婚博会~";
    } else if ([err isEqualToString:@"appointhbh.u_overlimit"]){
        message = @"小主，您预约的太多了，再逛逛吧~";
    } else if ([err isEqualToString:@"hapn.u_login"]){
        message = @"您还未登录，请先登录哦";
    } else if ([err isEqualToString:@"order.u_checkOrderLimit_setting_error"]){
        message = @"预约设置有误";
    } else if ([@"err.catpure" isEqualToString:err]) {
        return nil;
    }

    return [self displayMessage:message];
}

+ (MessageView *)displayMessage:(NSString *)message{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    return [self displayMessage:message withView:window];
}


+ (MessageView *)displayMessage:(NSString *)message withView:(UIView *)disPlayView{
    return [MessageView displayMessage:message withView:disPlayView withAgterDelay:2];
}

+ (MessageView *)displayMessage:(NSString *)message
                       withView:(UIView *)disPlayView
                 withAgterDelay:(NSTimeInterval)delay
{
    
    MessageView *view = [MessageView loadFromNib];
    view.messageLabel.text = message;
    [self cleanOldViewWithSuperView:disPlayView];
    if(disPlayView){
        [view showWithView:disPlayView];
    }else{
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [view showWithView:window];
    }
    [view autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [view autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [view performSelector:@selector(hideView) withObject:nil afterDelay:delay];
    return view;
}

+ (void)cleanOldViewWithSuperView:(UIView *)superView
{
    for (id view in superView.subviews) {
        if([view isKindOfClass:[MessageView class]]){
            [view removeFromSuperview];
        }
    }
}

@end
