//
//  ShareView.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

typedef NS_ENUM(NSUInteger,Clicktype){
    wx_click,     //点击微信
    fcir_click,   //点击朋友圈
    wb_click,     //点击微博
    qqfri_click,  //点击qq好友
    qqsapce_click,//点击qq空间
    copy_click,   //点击复制链接
    cancel_click, //点击取消
    blank_click   //点击空白处
};
@property(nonatomic,copy) void(^ClickBlock)(Clicktype type);
- (void)show;
- (void)dismiss;
@end
