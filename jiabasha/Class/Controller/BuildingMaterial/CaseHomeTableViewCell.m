//
//  CaseHomeTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//


#import "CaseHomeTableViewCell.h"

@implementation CaseHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCell:(NSDictionary *)exampleDetail{
    self.LabelPicNum.text = [NSString stringWithFormat:@"%@张图片",[exampleDetail[@"pic_count"] description]];
    [self.imageViewBig sd_setImageWithURL:[NSURL URLWithString:[exampleDetail[@"show_img_url"] description]] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
    self.labelIntroduction.text = [exampleDetail[@"desc"] description];
    float commentHeight = 60;
    if (self.labelIntroduction.text != nil) {
        CGSize contentSize = [self.labelIntroduction.text  boundingRectWithSize:CGSizeMake(kScreenWidth - 32, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName:
                                                                 [UIFont systemFontOfSize:12]}
                                                   context:nil].size;
        commentHeight = contentSize.height + 16;
    }
     self.viewIntroductionHeight.constant =  commentHeight;
    
    NSString *title = [exampleDetail[@"title"] description];
    
    float titleHeight = 30;
    if (title != nil) {
        CGSize contentSize = [title  boundingRectWithSize:CGSizeMake(kScreenWidth , MAXFLOAT)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                     attributes:@{NSFontAttributeName:
                                                                                      [UIFont systemFontOfSize:15]}
                                                                        context:nil].size;
        titleHeight = contentSize.width + 4;
    }
    self.labelNameWidth.constant =  titleHeight;
    self.labelAddress.text = title;
}


@end
