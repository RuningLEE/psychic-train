//
//  MyOrderTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _buttonEvaluate.layer.cornerRadius = 3;
    _buttonEvaluate.layer.borderColor = RGBFromHexColor(333333).CGColor;
    _buttonEvaluate.layer.borderWidth = 1;
    _buttonEvaluate.layer.masksToBounds = YES;
    // Initialization code
    _fanXian.layer.cornerRadius = 3;
    _fanXian.layer.borderColor = RGBFromHexColor(333333).CGColor;
    _fanXian.layer.borderWidth = 1;
    _fanXian.layer.masksToBounds = YES;
}

- (void)setOrderModel:(OrderModel *)orderModel 

{     _fanXian.hidden=YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _labelOrderNum.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.orderId];
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:orderModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelPrice.text = [NSString stringWithFormat:@"订单金额：%@元",orderModel.orderPrice];
    _labelDate.text = [NSString stringWithFormat:@"订单时间：%@",[CommonUtil getDateStringFromtempString:orderModel.createTime]];
    _labelsubTitle.text = orderModel.store.storeName;
//    _labelsubTitle.text =
    if ([orderModel.orderStatus isEqualToString:@"0"]) {
        _labelState.text = @"无效订单";
        _buttonEvaluate.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"1"]){
        _labelState.text = @"待确认";
        [_buttonEvaluate setTitle:@"已点评" forState:UIControlStateNormal];
        _buttonEvaluate.userInteractionEnabled = NO;
    } else if ([orderModel.orderStatus isEqualToString:@"2"]){
        _labelState.text = @"已确认";
        _buttonEvaluate.hidden = NO;
        _buttonEvaluate.userInteractionEnabled = YES;

            _fanXian.hidden=NO;

    } else if ([orderModel.orderStatus isEqualToString:@"3"]){
        _labelState.text = @"待确认";
        _buttonEvaluate.hidden = NO;
        _buttonEvaluate.userInteractionEnabled = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"4"]){
        _labelState.text = @"退款中";
        _buttonEvaluate.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"5"]){
        _labelState.text = @"已退款";
        _buttonEvaluate.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"6"]){
        _labelState.text = @"已返现";
        _buttonEvaluate.hidden = NO;
        _buttonEvaluate.userInteractionEnabled = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"7"]){
        _labelState.text = @"已点评";
        _buttonEvaluate.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"8"]){
        _labelState.text = @"已退单";
        _buttonEvaluate.hidden = YES;
    } else if ([orderModel.orderStatus isEqualToString:@"9"]){
        _labelState.text = @"已确认";
        _buttonEvaluate.hidden = NO;
        _buttonEvaluate.userInteractionEnabled = YES;
    }
    /*
     无效订单、待确认、已确认、待确认、退款中、已退款、已返现、已点评、已退单、已确认*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
