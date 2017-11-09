//
//  QRCodeView.h
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,clicktype){

    click_blank,//点击空白处
    click_dismiss//点击x按钮

};

@interface QRCodeView : UIView

@property(nonatomic,strong) UIImage* QRimage;

@property(nonatomic,copy) void(^ClickBlock)(clicktype type);


- (void)show;

- (void)dismiss;

@end
