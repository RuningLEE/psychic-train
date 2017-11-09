//
//  CaseTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"
#import "CaseTableViewCell.h"

@implementation CaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelSmallName.layer.cornerRadius = 8.5;
    self.labelSmallName.layer.masksToBounds = YES;
    
    //描边
    self.imageViewSmall.layer.borderWidth = .5;
    self.imageViewSmall.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(BuildingExample *)exampleData{
   //self.imageViewBig.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageViewBig sd_setImageWithURL:[NSURL URLWithString:exampleData.showImgUrl] placeholderImage:[UIImage imageNamed:PLUSPLACEHOLDERIMG]];
    //self.imageViewBig.contentMode = UIViewContentModeScaleAspectFill;
    NSDictionary *store = exampleData.store;
    [self.imageViewSmall sd_setImageWithURL:[NSURL URLWithString:store[@"logo"]] placeholderImage:[UIImage imageNamed:SMALLPALCEHOLDERIMG]];
//    self.labelSmallName;
    self.labelName.text =  [store[@"store_name"] description];
 
    self.labelAddress.text = exampleData.albumText;
    self.labelSmallName.text = exampleData.albumName;
    
    float picWidth = 64;
    if (self.labelSmallName.text != nil) {
        CGSize contentSize = [self.labelSmallName.text  boundingRectWithSize:CGSizeMake(kScreenWidth , MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                               attributes:@{NSFontAttributeName:
                                                                                [UIFont systemFontOfSize:12]}
                                                                  context:nil].size;
//        if (contentSize.width >64) {
            picWidth = contentSize.width + 16;
//        }
        
    }
    self.labelSmallNameWidth.constant =  picWidth;
}

@end
