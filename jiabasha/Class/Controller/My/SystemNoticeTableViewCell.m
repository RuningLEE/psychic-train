//
//  SystemNoticeTableViewCell.m
//  jiabasha
//
//  Created by jayhao on 2016/12/31.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "SystemNoticeTableViewCell.h"
#import "Masonry.h"
#import "UIImage+image_stretch.h"

@interface SystemNoticeTableViewCell()
@property (strong, nonatomic) UIImageView  *imageviewHead;
@property (strong, nonatomic) UILabel      *labelTitle;
@property (strong, nonatomic) UILabel      *labelSubtitle;
@property (strong, nonatomic) UILabel      *labelDate;
@property (strong, nonatomic) UIImageView  *imageViewUnread;
@property (strong, nonatomic) UILabel      *labelUnreadCount;
@end

@implementation SystemNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithTableView:(UITableView *)tableView;
{
    static NSString* ID = @"systemcell";
    SystemNoticeTableViewCell *systemCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (systemCell == nil) {
        systemCell = [[SystemNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return systemCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //布局子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setSystemModel:(SystemNotice *)systemModel{
    //头像
    if ([systemModel.isread isEqualToString:@"1"]) {
        _imageviewHead.image = [UIImage imageNamed:@"jiabasha_logo"];
    } else {
        _imageviewHead.image = [UIImage imageNamed:@"unread_system_notice"];
    }
    _systemModel        = systemModel;
    _labelTitle.text    = @"家芭莎小秘书";
    _labelSubtitle.text = _systemModel.content;
    _labelDate.text     = [CommonUtil getDateStringFromtempString:_systemModel.sendTime];
    _imageviewHead.layer.cornerRadius = 0;
    _imageViewUnread.hidden = YES;
    _labelUnreadCount.hidden = YES;
}

- (void)setLetterModel:(Letter *)letterModel
{
    //头像
    if ([letterModel.isread isEqualToString:@"1"]) {
        _imageviewHead.image = [UIImage imageNamed:@"jiabasha_logo"];
    } else {
        _imageviewHead.image = [UIImage imageNamed:@"unread_system_notice"];
    }
    _letterModel = letterModel;
    if ([letterModel.toUser.uid isEqualToString:DATA_ENV.userInfo.user.uid]) {
        _labelTitle.text = letterModel.fromUser.uname;
        [_imageviewHead sd_setImageWithURL:[NSURL URLWithString:letterModel.fromUser.faceUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    } else {
        _labelTitle.text = letterModel.toUser.uname;
        [_imageviewHead sd_setImageWithURL:[NSURL URLWithString:letterModel.toUser.faceUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    }
    _labelSubtitle.text = letterModel.content;
    _labelDate.text     = [CommonUtil getDateStringFromtempString:letterModel.sendTime];
    _imageviewHead.layer.cornerRadius = 25;
    if ([letterModel.unreadCnt isEqualToString:@"0"] || [CommonUtil isEmpty:letterModel.unreadCnt]) {
        _imageViewUnread.hidden = YES;
        _labelUnreadCount.hidden = YES;
    } else {
        _imageViewUnread.hidden = NO;
        _labelUnreadCount.hidden = NO;
        _labelUnreadCount.text = letterModel.unreadCnt;
    }
}

- (void)setupSubViews{
    _imageviewHead = [[UIImageView alloc]init];
    _imageviewHead.contentMode = UIViewContentModeScaleAspectFill;
    _imageviewHead.clipsToBounds = YES;
    _imageviewHead.layer.masksToBounds = YES;

    [self.contentView addSubview:_imageviewHead];
    [_imageviewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    _imageviewHead.userInteractionEnabled = YES;
    
    //主标题
    _labelTitle = [[UILabel alloc]init];
    _labelTitle.font = [UIFont systemFontOfSize:16];
    _labelTitle.textColor = RGB(51, 51, 51);
    [self.contentView addSubview:_labelTitle];
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageviewHead.mas_right).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
    }];
    _labelTitle.userInteractionEnabled = YES;
    
    //内容（副标题）
    _labelSubtitle = [[UILabel alloc]init];
    _labelSubtitle.font = [UIFont systemFontOfSize:13];
    _labelSubtitle.textColor = RGB(102, 102, 102);
    _labelSubtitle.numberOfLines = 0;
    [self.contentView addSubview:_labelSubtitle];
    [_labelSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelTitle.mas_bottom).offset(10);
        make.left.mas_equalTo(_imageviewHead.mas_right).offset(15);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-19);
    }];
    _labelSubtitle.userInteractionEnabled = YES;
    
    //底部分割线
    UIView* line = [[UIView alloc]init];
    line.backgroundColor = RGB(246, 246, 246);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-16);
        make.height.mas_equalTo(1);
    }];
    
    //时间
    _labelDate = [[UILabel alloc]init];
    _labelDate.font = [UIFont systemFontOfSize:13];
    _labelDate.textColor = RGB(102, 102, 102);
    [self.contentView addSubview:_labelDate];
    [_labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(_labelTitle.mas_right).offset(8);
        make.centerY.mas_equalTo(_labelTitle.mas_centerY);
        make.right.mas_equalTo(line.mas_right).offset(-7);
    }];
    _labelDate.userInteractionEnabled = YES;
    
    //未读通知的label
    _labelUnreadCount = [[UILabel alloc]init];
    _labelUnreadCount.font = [UIFont systemFontOfSize:12];
    _labelUnreadCount.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_labelUnreadCount];
    [_labelUnreadCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(60);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
    }];
    
    //未读通知数量
    _imageViewUnread = [[UIImageView alloc]init];
    _imageViewUnread.image = [UIImage unReadimageWithStretchableName:@"unread_count_icon"];
    [self.contentView insertSubview:_imageViewUnread belowSubview:_labelUnreadCount];
    [_imageViewUnread mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(_labelUnreadCount);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
