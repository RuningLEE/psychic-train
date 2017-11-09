//
//  SendMessageTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SendMessageTableViewCell.h"
#import "Masonry.h"
#import "UIImage+image_stretch.h"
#import "User.h"

@interface SendMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageviewHead;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (strong, nonatomic) UIImageView *imageviewBG;
@end

@implementation SendMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageviewHead.layer.cornerRadius = 20;
    _imageviewHead.layer.masksToBounds = YES;
    _imageviewHead.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置信息内容
- (void)setLetterModel:(SessionLetter *)letterModel{
//    _labelContent.text = [[dictionaryMessage objectForKey:@"content"] description];
    _labelContent.text = letterModel.content;
    //布局背景图
    _imageviewBG = [[UIImageView alloc]initWithImage:[UIImage imageWithStretchableName:@"msg_send_bg"]];
    [self.contentView insertSubview:_imageviewBG belowSubview:_labelContent];
    [_imageviewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelContent.mas_top).offset(-15);
        make.left.mas_equalTo(_labelContent.mas_left).offset(-10);
        make.right.mas_equalTo(_labelContent.mas_right).offset(10);
        make.bottom.mas_equalTo(_labelContent.mas_bottom).offset(15);
    }];
}

//设置头像显示
- (void)setDicUser:(User *)user
{
    _imageviewHead.image = [UIImage imageNamed:NORMALPLACEHOLDERIMG];
}

//返回cell高度
- (CGFloat)countCellHeightWithMessageDictionary:(NSDictionary *)messageDictionary
{
    CGFloat cellHeight = [CommonUtil sizeWithString:[[messageDictionary objectForKey:@"content"] description] fontSize:15 sizewidth:(kScreenWidth-90-16-40-15) sizeheight:0].height;
    return cellHeight;
}
@end
