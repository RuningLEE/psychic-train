//
//  WonderfulCaseTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"
#import "WonderfulCaseTableViewCell.h"

@implementation WonderfulCaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelCompany.layer.cornerRadius = 8.5;
    self.labelCompany.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(BuildingExample *)exampleData{
    
    [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:exampleData.showImgUrl] placeholderImage:[UIImage imageNamed:PLUSPLACEHOLDERIMG]];
    self.labelIntroduce.text = exampleData.albumText;
    self.labelCompany.text = exampleData.albumName;
    
    float picWidth = 64;
    if (self.labelCompany.text != nil) {
        CGSize contentSize = [self.labelCompany.text  boundingRectWithSize:CGSizeMake(kScreenWidth , MAXFLOAT)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                  attributes:@{NSFontAttributeName:
                                                                                   [UIFont systemFontOfSize:12]}
                                                                     context:nil].size;
        if (contentSize.width >64) {
            picWidth = contentSize.width + 4;
        }
        
    }
    self.labelSmallNameWidth.constant =  picWidth;
}

@end
