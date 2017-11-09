//
//  HelpHeaderTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HelpHeaderTableViewCell.h"
#import "Masonry.h"

@interface HelpHeaderTableViewCell()
@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) NSString *title;
@end

@implementation HelpHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithTableView:(UITableView *)tableView andTitle:(NSString *)title
{
    NSString* ID = @"helpHeaderCell";
    HelpHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"helpHeaderCell"];
    if (headerCell == nil) {
        headerCell = [[HelpHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return headerCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //布局子控件
        UIImageView* imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"问"]];
        [self.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        
        //布局标题
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.numberOfLines = 0;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.font = [UIFont systemFontOfSize:17];
        _labelTitle.textColor = RGB(51, 51, 51);
        _labelTitle.text = @"说一说婚礼的必备婚品有哪些";
        [self.contentView addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageview.mas_right).offset(10);
//            make.top.mas_equalTo(imageview.mas_top);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        //布局底部虚线
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-16, 1)];
        line.image = [self drawLineByImageView:line];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    double lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
//    CGContextSetLineDash(line, 0, lengths], 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, kScreenWidth - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}


@end
