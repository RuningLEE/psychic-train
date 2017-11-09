//
//  MyClusterCollectionViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyClusterCollectionViewCell.h"
#import "Masonry.h"

@implementation MyClusterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderColor = RGB(221, 221, 221).CGColor;
    self.contentView.layer.borderWidth = 1;
    // Initialization code
}

- (void)setClusterProduct:(Product *)clusterProduct
{
    //布局labeldelete
    //进行值设定
    _clusterProduct = clusterProduct;
    NSMutableAttributedString *deleteStr = [[NSMutableAttributedString alloc]initWithString:clusterProduct.price];
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:[NSNumber numberWithInt:1] color:[UIColor lightGrayColor]];
    [deleteStr setYy_textStrikethrough:decoration];
    [deleteStr setYy_color:[UIColor lightGrayColor]];
    [deleteStr setYy_font:[UIFont systemFontOfSize:9]];
    _labelDelete = [[YYLabel alloc]init];
    _labelDelete.attributedText = deleteStr;
    
    //布局labeldelete
    [self.viewInsert addSubview:_labelDelete];
    //如果是iphone5或者se上边贴紧 其他机型按下面的约束
    if (kScreenWidth == 320) {
        [_labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_viewInsert.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        }];
    } else {
        [_labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_viewInsert.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        }];
    }
    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:clusterProduct.productPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    if (![CommonUtil isEmpty:clusterProduct.productName]) {
        _labelTitle.text = clusterProduct.productName;
    } else {
        _labelTitle.text = @"";
    }
    if (![CommonUtil isEmpty:clusterProduct.mallPrice]) {
        _labelPrice.text = clusterProduct.mallPrice;
    } else {
        _labelPrice.text = @"面议";
    }
    
    if ([clusterProduct.tuaning boolValue] == YES) {
        _labelNumFront.hidden = NO;
        _labelNumAfter.hidden = NO;
        _labelNum.hidden = NO;
    } else {
        _labelNumFront.hidden = YES;
        _labelNumAfter.hidden = YES;
        _labelNum.hidden = YES;
    }

    if (![CommonUtil isEmpty:clusterProduct.tuanOrderCnt]) {
        _labelNum.text = clusterProduct.tuanOrderCnt;
    } else {
        _labelNum.text = @"0";
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomePageCollectionCell" owner:self options:nil];
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
@end
