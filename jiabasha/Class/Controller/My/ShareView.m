//
//  ShareView.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShareView.h"
#import "Masonry.h"
#define KeyWindow [UIApplication sharedApplication].keyWindow

@interface ShareView ()
@property (strong, nonatomic) UIView *viewContent;
@property (strong, nonatomic) UIView *viewBg;
@property (strong, nonatomic) UIView *viewSubContent;
@property (strong, nonatomic) UILabel *labelCancel;
@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _viewBg = [[UIView alloc]init];
    _viewBg.tag = 8;
    _viewBg.userInteractionEnabled = YES;
    [_viewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)]];
    _viewBg.backgroundColor = [UIColor blackColor];
    _viewBg.alpha = 0;
    [self addSubview:_viewBg];
    [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _viewContent = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 269)];
    _viewContent.backgroundColor = [UIColor whiteColor];
    [self addSubview:_viewContent];
    
    _labelCancel = [[UILabel alloc]init];
    _labelCancel.userInteractionEnabled = YES;
    _labelCancel.tag = 7;
    [_labelCancel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    _labelCancel.text = @"取消";
    _labelCancel.textAlignment = NSTextAlignmentCenter;
    _labelCancel.textColor = RGB(51, 51, 51);
    _labelCancel.font = [UIFont systemFontOfSize:16];
    [_viewContent addSubview:_labelCancel];
    [_labelCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_viewContent.mas_bottom);
        make.left.mas_equalTo(_viewContent.mas_left);
        make.right.mas_equalTo(_viewContent.mas_right);
        make.height.mas_equalTo(49);
    }];
    
    UIView *viewInsert = [[UIView alloc]init];
    viewInsert.backgroundColor = RGB(244, 244, 244);
    [_viewContent addSubview:viewInsert];
    [viewInsert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(_labelCancel.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    //布局分享选项视图
    _viewSubContent = [[UIView alloc]init];
    _viewSubContent.backgroundColor = [UIColor whiteColor];
    _viewSubContent.userInteractionEnabled = YES;
    [_viewContent addSubview:_viewSubContent];
    [_viewSubContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(215);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(viewInsert.mas_top);
    }];
    //微信
    CGFloat kkwidth = kScreenWidth/4;
    CGFloat kkheight = 215/2;
    
    UIView *viewWX = [[UIView alloc]init];
    viewWX.userInteractionEnabled = YES;
    viewWX.tag = 1;
    [viewWX addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewWX];
    [viewWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(_viewSubContent.mas_top);
        make.left.mas_equalTo(_viewSubContent.mas_left);
    }];
    UIImageView *imageviewWX = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信"]];
    [viewWX addSubview:imageviewWX];
    [imageviewWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewWX.mas_centerX);
        make.centerY.mas_equalTo(viewWX.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelWX = [[UILabel alloc]init];
    labelWX.text = @"微信";
    labelWX.textColor = RGBFromHexColor(000000);
    labelWX.font = [UIFont systemFontOfSize:13];
    [viewWX addSubview:labelWX];
    [labelWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewWX.mas_centerX);
        make.top.mas_equalTo(imageviewWX.mas_bottom).offset(10);
    }];
    //朋友圈
    UIView *viewFriCircle = [[UIView alloc]init];
    viewFriCircle.userInteractionEnabled = YES;
    viewFriCircle.tag = 2;
    [viewFriCircle addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewFriCircle];
    [viewFriCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(_viewSubContent.mas_top);
        make.left.mas_equalTo(viewWX.mas_right);
    }];
    UIImageView *imageviewFriCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"朋友圈"]];
    [viewFriCircle addSubview:imageviewFriCircle];
    [imageviewFriCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewFriCircle.mas_centerX);
        make.centerY.mas_equalTo(viewFriCircle.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelFriCircle = [[UILabel alloc]init];
    labelFriCircle.text = @"朋友圈";
    labelFriCircle.textColor = RGBFromHexColor(000000);
    labelFriCircle.font = [UIFont systemFontOfSize:13];
    [viewFriCircle addSubview:labelFriCircle];
    [labelFriCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewFriCircle.mas_centerX);
        make.top.mas_equalTo(imageviewFriCircle.mas_bottom).offset(10);
    }];
    //新浪微博
    UIView *viewWB = [[UIView alloc]init];
    viewWB.userInteractionEnabled = YES;
    viewWB.tag = 3;
    [viewWB addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewWB];
    [viewWB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(_viewSubContent.mas_top);
        make.left.mas_equalTo(viewFriCircle.mas_right);
    }];
    UIImageView *imageviewWB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新浪微博"]];
    [viewFriCircle addSubview:imageviewWB];
    [imageviewWB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewWB.mas_centerX);
        make.centerY.mas_equalTo(viewWB.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelWB = [[UILabel alloc]init];
    labelWB.text = @"新浪微博";
    labelWB.textColor = RGBFromHexColor(000000);
    labelWB.font = [UIFont systemFontOfSize:13];
    [viewWB addSubview:labelWB];
    [labelWB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewWB.mas_centerX);
        make.top.mas_equalTo(imageviewWB.mas_bottom).offset(10);
    }];
    //qq好友
    UIView *viewQFri = [[UIView alloc]init];
    viewQFri.userInteractionEnabled = YES;
    viewQFri.tag = 4;
    [viewQFri addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewQFri];
    [viewQFri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(_viewSubContent.mas_top);
        make.left.mas_equalTo(viewWB.mas_right);
    }];
    UIImageView *imageviewQFri = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QQ好友"]];
    [viewQFri addSubview:imageviewQFri];
    [imageviewQFri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewQFri.mas_centerX);
        make.centerY.mas_equalTo(viewQFri.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelQFri = [[UILabel alloc]init];
    labelQFri.text = @"QQ好友";
    labelQFri.textColor = RGBFromHexColor(000000);
    labelQFri.font = [UIFont systemFontOfSize:13];
    [viewQFri addSubview:labelQFri];
    [labelQFri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewQFri.mas_centerX);
        make.top.mas_equalTo(imageviewQFri.mas_bottom).offset(10);
    }];
    //qq空间
    UIView *viewQSpace = [[UIView alloc]init];
    viewQSpace.userInteractionEnabled = YES;
    viewQSpace.tag = 5;
    [viewQSpace addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewQSpace];
    [viewQSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(viewWX.mas_bottom);
        make.left.mas_equalTo(self.left);
    }];
    UIImageView *imageviewQSpace = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QQ空间"]];
    [viewQSpace addSubview:imageviewQSpace];
    [imageviewQSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewQSpace.mas_centerX);
        make.top.mas_equalTo(viewQSpace.mas_top).offset(17);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelQSpace = [[UILabel alloc]init];
    labelQSpace.text = @"QQ空间";
    labelQSpace.textColor = RGBFromHexColor(000000);
    labelQSpace.font = [UIFont systemFontOfSize:13];
    [viewQSpace addSubview:labelQSpace];
    [labelQSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewQSpace.mas_centerX);
        make.top.mas_equalTo(imageviewQSpace.mas_bottom).offset(10);
    }];
    //复制链接
    UIView *viewCopy = [[UIView alloc]init];
    viewCopy.userInteractionEnabled = YES;
    viewCopy.tag = 6;
    [viewCopy addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod:)]];
    [_viewSubContent addSubview:viewCopy];
    [viewCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kkheight);
        make.width.mas_equalTo(kkwidth);
        make.top.mas_equalTo(viewFriCircle.mas_bottom);
        make.left.mas_equalTo(viewQSpace.mas_right);
    }];
    UIImageView *imageviewCopy = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"复制链接"]];
    [viewCopy addSubview:imageviewCopy];
    [imageviewCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewCopy.mas_centerX);
        make.top.mas_equalTo(viewCopy.mas_top).offset(17);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    UILabel *labelCopy = [[UILabel alloc]init];
    labelCopy.text = @"复制链接";
    labelCopy.textColor = RGBFromHexColor(000000);
    labelCopy.font = [UIFont systemFontOfSize:13];
    [viewCopy addSubview:labelCopy];
    [labelCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(viewCopy.mas_centerX);
        make.top.mas_equalTo(imageviewCopy.mas_bottom).offset(10);
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.5 animations:^{
        _viewBg.alpha = 0.4;
        _viewSubContent.height=YES;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:5.0 animations:^{
            
            
            _viewSubContent.y = kScreenHeight - 269;
        }];
    }];
    
    
//    [UIView animateWithDuration:3.0 animations:^{
//        
//        
//        _viewContent.y = kScreenHeight - 269;
//    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        _viewBg.alpha = 0;
        _viewContent.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickMethod:(UITapGestureRecognizer*)Tapgesture{
    if (self.ClickBlock) {
        self.ClickBlock(Tapgesture.view.tag-1);
    }
}
@end
