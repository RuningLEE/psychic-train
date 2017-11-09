//
//  KKdialogView.h
//  jiabasha
//
//  Created by zhangzt on 2016/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,Clicktype){
    cancel_click,//点击取消
    camera_click,//点击相机
    photo_library_click,//点击相册
    blank_click//点击空白处
};

@interface KKdialogView : UIView

@property(nonatomic,copy) void(^ClickBlock)(Clicktype type);

- (void)show;

- (void)dismiss;

@end
