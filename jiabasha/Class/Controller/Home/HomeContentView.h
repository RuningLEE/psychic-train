//
//  HomeContentView.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeContentView : UIView

//标题
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (HomeContentView *)instanceTitleView;

//热门活动
@property (weak, nonatomic) IBOutlet UIControl *controlAct;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewAct;
@property (weak, nonatomic) IBOutlet UILabel *labelActName;

+ (HomeContentView *)instanceActiveView;

//家芭莎课堂
@property (weak, nonatomic) IBOutlet UIControl *controlClassRoom;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewClassRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelClassRoom;

+ (HomeContentView *)instanceClassRoomView;

//商品
@property (weak, nonatomic) IBOutlet UIControl *controlPro;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProPic;
@property (weak, nonatomic) IBOutlet UILabel *labelProName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginal;
@property (weak, nonatomic) IBOutlet UIView *viewMark;

+ (HomeContentView *)instanceProductView;

@end
