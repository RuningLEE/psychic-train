//
//  VisionAlterView.h
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Vlterclicktype){
    
    Vclick_blank,//点击空白处
    Vclick_dismiss//点击x按钮
    
};

@interface VisionAlterView : UIView
@property(nonatomic,strong) NSMutableDictionary * QRimage;

@property(nonatomic,copy) void(^ClickBlock)(Vlterclicktype type);


- (void)show;

- (void)dismiss;

@end
