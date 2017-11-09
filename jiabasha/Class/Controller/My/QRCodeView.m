//
//  QRCodeView.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "QRCodeView.h"
#import "Masonry.h"

@interface QRCodeView ()
@property(nonatomic,strong) UIView *viewContent;
@property(nonatomic,strong) UIView *viewBg;
@end

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始透明度为0
        self.alpha = 0;
    }
    return self;
}

//注意：是在设置image的时候进行布局 在此方法后调用show 调用dismiss的时候基地要置空
- (void)setQRimage:(UIImage *)QRimage
{
    _QRimage = QRimage;
    //布局视图
    
    //背景
    _viewBg = [[UIView alloc]init];
    _viewBg.tag = 22;
    _viewBg.alpha=0.6;
    _viewBg.userInteractionEnabled = YES;
    [_viewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)]];
    _viewBg.backgroundColor = RGB(73, 73, 73);
    [self addSubview:_viewBg];
    [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    //容器视图
    _viewContent = [[UIView alloc]init];
    _viewContent.backgroundColor = RGB(255, 255, 255);
    _viewContent.layer.cornerRadius = 2;
    _viewContent.layer.masksToBounds = YES;
    
    [self addSubview:_viewContent];
    
    [_viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(@407);
        make.width.mas_equalTo(@290);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    
    //顶部家芭莎image
    UIImageView* imageviewTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"家芭莎logo"]];
    [_viewContent addSubview:imageviewTop];
    
    [imageviewTop mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_viewContent.mas_top).offset(25);
        make.centerX.mas_equalTo(_viewContent.centerX);
        make.size.mas_equalTo(CGSizeMake(81, 61));
        
    }];
    
    //退出按钮
    UIImageView* imageviewDelete = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"关系按钮"]];
    imageviewDelete.userInteractionEnabled = YES;
    imageviewDelete.tag = 23;
    [imageviewDelete addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)]];
    [_viewContent addSubview:imageviewDelete];
    
    [imageviewDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.mas_equalTo(_viewContent.mas_top);
        make.right.mas_equalTo(_viewContent.mas_right).offset(-15);
    }];
    
    //二维码
    UIImageView* imageviewQrcode = [[UIImageView alloc]initWithImage:_QRimage];
    [_viewContent addSubview:imageviewQrcode];
    
    [imageviewQrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(185, 185));
        make.centerX.mas_equalTo(_viewContent.centerX);
        make.top.mas_equalTo(imageviewTop.mas_bottom).offset(10);
    }];
    
    //底部容器
    UIView* viewBottom = [[UIView alloc]init];
    viewBottom.backgroundColor = RGB(253, 249, 255);
    [_viewContent addSubview:viewBottom];
    
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(@100);
        make.bottom.mas_equalTo(_viewContent.mas_bottom);
        make.right.mas_equalTo(_viewContent.mas_right);
        make.left.mas_equalTo(_viewContent.mas_left);
        
    }];
    
    //四条label
    UILabel* label_fir = [[UILabel alloc]init];
    label_fir.text = @"让商家扫一扫二维码";
    label_fir.font = [UIFont systemFontOfSize:11];
    label_fir.textColor = RGB(102, 102, 102);
    label_fir.textAlignment = NSTextAlignmentCenter;
    [viewBottom addSubview:label_fir];
    [label_fir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewBottom.mas_top).offset(20);
        make.centerX.mas_equalTo(viewBottom.centerX);
    }];
    UILabel* label_sec = [[UILabel alloc]init];
    label_sec.textColor = RGB(153, 153, 153);
    label_sec.font = [UIFont systemFontOfSize:11];
    label_sec.text = @"1、商家确认到展/店，领签到礼！";
    label_sec.textAlignment = NSTextAlignmentCenter;
    [viewBottom addSubview:label_sec];
    [label_sec mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(label_fir.mas_bottom).offset(5);
        make.centerX.mas_equalTo(label_fir.centerX);
    }];
    UILabel* label_tir= [[UILabel alloc]init];
    label_tir.textColor = RGB(153, 153, 153);
    label_tir.font = [UIFont systemFontOfSize:11];
    label_tir.text = @"2、商家核销现金券，享优惠！";
    label_tir.textAlignment = NSTextAlignmentCenter;
    [viewBottom addSubview:label_tir];
     [label_tir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_sec.mas_bottom).offset(5);
        make.centerX.mas_equalTo(viewBottom.centerX);
    }];
    UILabel* label_fourth= [[UILabel alloc]init];
    label_fourth.textColor = RGB(153, 153, 153);
    label_fourth.font = [UIFont systemFontOfSize:11];
    label_fourth.text = @"3、商家核销福利券，拿奖品！";
    label_fourth.textAlignment = NSTextAlignmentCenter;
    
    [viewBottom addSubview:label_fourth];
    [label_fourth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_tir.mas_bottom).offset(5);
        make.centerX.mas_equalTo(viewBottom.centerX);
    }];
}

- (void)show
{
    self.transform = CGAffineTransformMakeScale(1.0, 1.2);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    }];
}


- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//点击事件
- (void)viewClicked:(UITapGestureRecognizer*)tap{
    if (self.ClickBlock) {
        self.ClickBlock(tap.view.tag-22);
    }
}

@end
