//
//  ShopSubscribeTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShopSubscribeTableViewCell.h"

@implementation ShopSubscribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageviewCover.clipsToBounds = YES;
    _imageviewCover.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}

- (void)initWithSubstoreModel:(SubscribeStore *)subscribeStore{
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:subscribeStore.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelTitle.text = subscribeStore.store.storeName;
    if ([CommonUtil isEmpty:subscribeStore.appointTime]) {
        _labelSubtitle.text = @"";
    } else {
        _labelSubtitle.text = [CommonUtil getDateStringFromtempString:subscribeStore.appointTime];
    }
    if ([subscribeStore.reserveStatus isEqualToString:@"0"]) {
        _imageViewRight.image = [UIImage imageNamed:@"已取消"];
    } else if ([subscribeStore.reserveStatus isEqualToString:@"1"]){
        _imageViewRight.image = [UIImage imageNamed:@"待安排"];
    } else if ([subscribeStore.reserveStatus isEqualToString:@"2"]){
        _imageViewRight.image = [UIImage imageNamed:@"已安排"];
    } else if ([subscribeStore.reserveStatus isEqualToString:@"3"]){
        _imageViewRight.image = [UIImage imageNamed:@"已到店"];
    } else if ([subscribeStore.reserveStatus isEqualToString:@"4"]){
        _imageViewRight.image = [UIImage imageNamed:@"未赴约"];
    } else if ([subscribeStore.reserveStatus isEqualToString:@"5"]){
        _imageViewRight.image = [UIImage imageNamed:@"已取消"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
