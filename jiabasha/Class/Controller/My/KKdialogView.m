//
//  KKdialogView.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "Masonry.h"
#import "KKdialogView.h"

#define dialogheight 148
#define KeyWindow [UIApplication sharedApplication].keyWindow

@interface KKdialogView()
@property (nonatomic, strong) UILabel *labelCancel;
@property (nonatomic, strong) UILabel *labelPhotoLibrary;
@property (nonatomic, strong) UILabel *labelCamera;
@property (nonatomic, strong) UIView *ViewContent;
@property (nonatomic, strong) UIView *Bgview;
@property (nonatomic, strong) UIView *MainContentView;
@end

@implementation KKdialogView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      //layoutsubviews
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    _Bgview = [[UIView alloc]init];
    _Bgview.backgroundColor = [UIColor blackColor];
    _Bgview.alpha = 0;
    _Bgview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _Bgview.userInteractionEnabled = YES;
    _Bgview.tag = 4;
    [self insertSubview:_Bgview atIndex:0];
    _MainContentView = [[UIView alloc]init];
    _MainContentView.backgroundColor = [UIColor clearColor];
    _MainContentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 148);
    [self addSubview:_MainContentView];
    self.backgroundColor = [UIColor clearColor];
    _labelCancel = [[UILabel alloc]init];
    _labelCancel.tag = 1;
    _labelCancel.text = @"取消";
    _labelCancel.textAlignment = NSTextAlignmentCenter;
    _labelCancel.font = [UIFont systemFontOfSize:16];
    _labelCancel.textColor = RGB(51, 51, 51);
    _labelCancel.backgroundColor = RGB(255, 255, 255);
    _labelCancel.userInteractionEnabled = YES;
    _labelCancel.layer.cornerRadius = 4;
    _labelCancel.layer.masksToBounds = YES;
    [_MainContentView addSubview:_labelCancel];
    [_labelCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(_MainContentView.mas_bottom).offset(-8);
        make.left.mas_equalTo(_MainContentView.mas_left).offset(8);
        make.right.mas_equalTo(_MainContentView.mas_right).offset(-8);
    }];
    //创建上部容器view
    _ViewContent = [[UIView alloc]init];
    _ViewContent.layer.cornerRadius = 4;
    _ViewContent.layer.masksToBounds = YES;
    _ViewContent.clipsToBounds = YES;
    _ViewContent.backgroundColor = RGB(255, 255, 255);
    _ViewContent.userInteractionEnabled = YES;
    [_MainContentView addSubview:_ViewContent];
    [_ViewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@89);
        make.bottom.mas_equalTo(_labelCancel.mas_top).offset(-8);
        make.left.mas_equalTo(_MainContentView.left).offset(8);
        make.right.mas_equalTo(_MainContentView.right).offset(-8);
    }];
    //容器注入相册和相机label
    _labelCamera = [[UILabel alloc]init];
    _labelCamera.tag = 2;
    _labelCamera.textAlignment = NSTextAlignmentCenter;
    _labelCamera.text = @"相册";
    _labelCamera.textColor = RGB(96, 25, 134);
    _labelCamera.font = [UIFont systemFontOfSize:15];
    _labelCamera.userInteractionEnabled = YES;
    [_ViewContent addSubview:_labelCamera];
    [_labelCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ViewContent.mas_top);
        make.left.mas_equalTo(_ViewContent.mas_left);
        make.right.mas_equalTo(_ViewContent.mas_right);
        make.height.mas_equalTo(@44);
    }];
    UIView* line = [[UIView alloc]init];
    line.backgroundColor = RGB(156, 156, 156);
    [_ViewContent addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.top.mas_equalTo(_labelCamera.mas_bottom);
        make.left.mas_equalTo(_ViewContent.left);
        make.right.mas_equalTo(_ViewContent.right);
    }];
    
    _labelPhotoLibrary = [[UILabel alloc]init];
    _labelPhotoLibrary.tag = 3;
    _labelPhotoLibrary.textAlignment = NSTextAlignmentCenter;
    _labelPhotoLibrary.font = [UIFont systemFontOfSize:15];
    _labelPhotoLibrary.text = @"相机";
    _labelPhotoLibrary.textColor = RGB(96, 25, 134);
    _labelPhotoLibrary.userInteractionEnabled = YES;
    
    [_ViewContent addSubview:_labelPhotoLibrary];
    [_labelPhotoLibrary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(_ViewContent.mas_left);
        make.right.mas_equalTo(_ViewContent.mas_right);
        make.bottom.mas_equalTo(_ViewContent.mas_bottom);
    }];
    //初始化手势
    [_labelCancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)]];
    [_labelPhotoLibrary addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)]];
    [_labelCamera addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)]];
    [_Bgview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)]];
}

- (void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        _MainContentView.y = kScreenHeight-dialogheight;
        _Bgview.alpha = 0.4;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        _MainContentView.y = kScreenHeight;
        _Bgview.alpha = 0;
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
