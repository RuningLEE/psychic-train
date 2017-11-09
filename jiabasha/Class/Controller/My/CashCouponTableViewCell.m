//
//  CashCouponTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CashCouponTableViewCell.h"

@implementation CashCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageviewCover.contentMode = UIViewContentModeScaleAspectFill;
    _imageviewCover.clipsToBounds = YES;
    _viewContent.layer.cornerRadius = 5;
    _viewContent.layer.borderColor = RGB(220, 220, 220).CGColor;
    _viewContent.layer.borderWidth = 0.5;
    _viewContent.layer.masksToBounds = YES;
    // Initialization code
}

- (void)initWithCouponModel:(CouponModel *)couponModel
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:couponModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelTitle.text = couponModel.store.storeName;
    if (![CommonUtil isEmpty:couponModel.meetAmount]) {
        _labelSubtitle.text = [NSString stringWithFormat:@"满%@元可用",couponModel.meetAmount];
    } else {
        _labelSubtitle.text = @"";
    }
    _labelPrice.text = [NSString stringWithFormat:@"%.0f",[couponModel.parValue floatValue]];
    if ([couponModel.setting.forExpp isEqualToString:@"0"]) {
        _labelType.text = @"门店券";
        _labelType.textColor = RGB(251, 181, 33);
    } else {
        _labelType.text = @"展会券";
        _labelType.textColor = RGB(96, 25, 134);
    }
    _labelDeadline.text = [NSString stringWithFormat:@"有效期至:%@",[CommonUtil getDateStringFromtempString:couponModel.validEnd]];
    [self vaildTime:couponModel];
}

//判断是否过期
- (void)vaildTime:(CouponModel *)couponModel{
    long timeStamp = [[NSDate date] timeIntervalSince1970];
    if ([couponModel.status isEqualToString:@"1"] && timeStamp < [couponModel.validEnd longLongValue]) {//正常
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
        _imageViewMark.image = nil;
    } else if ([couponModel.status isEqualToString:@"2"]){//核销
        _imageViewMark.image = [UIImage imageNamed:@"我的现金券已使用"];
        _labelrmb.textColor = RGB(187, 187, 187);
        _labelPrice.textColor = RGB(187, 187, 187);
    } else if ([couponModel.status isEqualToString:@"3"] && timeStamp > [couponModel.validEnd longLongValue]){//过期
        _imageViewMark.image = [UIImage imageNamed:@"time_out_icon"];
        _labelrmb.textColor = RGB(187, 187, 187);
        _labelPrice.textColor = RGB(187, 187, 187);
    } else if ([couponModel.status isEqualToString:@"4"]){//无效
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
        _imageViewMark.image = nil;
    } else {//0 锁定
        _labelrmb.textColor = RGB(255, 59, 48);
        _labelPrice.textColor = RGB(255, 59, 48);
        _imageViewMark.image = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
