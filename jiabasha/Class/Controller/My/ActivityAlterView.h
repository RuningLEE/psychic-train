//
//  ActivityAlterView.h
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Alterclicktype){
    
    Aclick_blank,//点击空白处
    Aclick_dismiss//点击x按钮
    
};

@interface ActivityAlterView : UIView
@property(nonatomic,strong) UIImage* QRimage;

@property(nonatomic,copy) void(^ClickBlock)(Alterclicktype type);


- (void)show;

- (void)dismiss;

@end
