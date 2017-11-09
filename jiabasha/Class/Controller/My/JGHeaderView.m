//
//  JGHeaderView.m
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import "JGHeaderView.h"
#import "JGFriendGroup.h"

@interface JGHeaderView ()

@property (nonatomic, weak) UILabel *countView;


@end

@implementation JGHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    JGHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[JGHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        

        
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        
            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(20, 8, 24, 24)];
            //but.backgroundColor=[UIColor redColor];
            [but setImage:[UIImage imageNamed:@"unchoose"] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
            [but addTarget:self  action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
           _nameView=but;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(but.frame.origin.x+but.frame.size.width+5, 8, 200, 24)];
            label.font=[UIFont systemFontOfSize:16];
            label.textColor=[UIColor blackColor];
           _countView=label;
            //label.text=@"推荐：使用银行卡返现";
            but.tag=100;
            [sectionView addSubview:but];
            [sectionView addSubview:label];
        [self.contentView addSubview:sectionView];
    }
    return self;
}

/**
 *  监听组名按钮的点击
 */
- (void)nameViewClick {
    
    //1. 修改数组模型的标记（状态取反）
    self.group.opend = !self.group.isOpend;
    
//    NSLog(@"======= %@",self.group.name);
    
    
    //刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        
        [self.delegate headerViewDidClickedNameView:self];
    }
    
//    if (self.group.isOpend) {
//        self.nameView.selected=YES;
//    }else {
//        self.nameView.selected=NO;
//    }
}

///**
// *  当一个控件被添加到父控件中就会调用
// */
- (void)didMoveToSuperview {
    
    if (self.group.isOpend) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    //设置按钮的frame
//    self.nameView.frame = self.bounds;
//    
//    //设置好友数的frame
//    CGFloat countY = 0;
//    CGFloat countH = self.frame.size.height;
//    CGFloat countW = 150;
//    CGFloat countX = self.frame.size.width - 10 - countW;
//    self.countView.frame = CGRectMake(countX, countY, countW, countH);
//    
//}

- (void)setGroup:(JGFriendGroup *)group {
    
    _group = group;
    
    _countView.text=_group.name;
}


@end
