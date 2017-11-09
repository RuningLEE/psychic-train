//
//  VisionAlterView.m
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "VisionAlterView.h"
#import "Masonry.h"
@interface VisionAlterView ()
@property(nonatomic,strong) UIView *viewContent;
@property(nonatomic,strong) UIView *viewBg;
@end
@implementation VisionAlterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始透明度为0
        self.alpha = 0;
    }
    return self;
}

- (void)setQRimage:(NSMutableDictionary *)QRimage
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
    _viewContent.layer.cornerRadius = 10;
    _viewContent.layer.masksToBounds = YES;
    
    [self addSubview:_viewContent];
    
    [_viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@220);
        make.width.mas_equalTo(@290);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-40);
        
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

    //top图片
//    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
//    topImageView.image=[UIImage imageNamed:@"update_dialog_bg"];
    UIImageView *topImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"update_dialog_bg"]];
    [_viewContent addSubview:topImageView];
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 290, 40)];
    topLabel.textAlignment=NSTextAlignmentCenter;
    topLabel.font=[UIFont systemFontOfSize:20];
    topLabel.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    topLabel.text=@"新版本更新";
    [_viewContent addSubview:topLabel];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(0, topLabel.frame.origin.y+topLabel.frame.size.height+10, 290, 0.5)];
    line1.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [_viewContent addSubview:line1];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, topImageView.frame.origin.y+topImageView.frame.size.height+40, 120, 30)];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    titleLabel.text=@"更新内容";
    [_viewContent addSubview:titleLabel];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, titleLabel.frame.origin.y+35, 200, 120)];
    contentLabel.textAlignment=NSTextAlignmentLeft;
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    contentLabel.text=_QRimage[@"popup_content"];
    [_viewContent addSubview:contentLabel];
    
    //bootm Button
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 180, 290, 40)];
    [but setTitle:@"立即更新" forState:UIControlStateNormal];
    but.titleLabel.font=[UIFont systemFontOfSize:17];
    [but setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState: UIControlStateNormal];
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, 178.5, 290, 0.5)];
    line2.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [_viewContent addSubview:line2];
    
    [_viewContent addSubview:but];
    

    
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
