//
//  CompanyCommentCell.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "StoreComment.h"
#import "TQStarRatingView.h"
#import "CompanyCommentCell.h"

@interface CompanyCommentCell ()
@property (weak, nonatomic) IBOutlet UIView *viewStar;
@property (strong, nonatomic) TQStarRatingView *ratingView;
@end
@implementation CompanyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _ratingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 64, 11) numberOfStar:5 starSpace:2];
    _ratingView.couldClick = NO;//不可点击
    [_ratingView changeStarForegroundViewWithPoint:CGPointMake(2.3/5*64, 0)];//设置星级
    [self.viewStar addSubview:_ratingView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(StoreComment *)storeComment{
    NSDate  *date = [CommonUtil getDateFromTimeStamp:[storeComment.addTime description]];
    NSString *time = [CommonUtil getStringForDate:date];
    self.labelTime.text = [time substringToIndex:10];
    NSDictionary *user = storeComment.user;
    self.labelUser.text = [user[@"uname"] description];
    self.labelSpendPrice.text = [NSString stringWithFormat:@"消费总金额：￥%@元",storeComment.money];
    self.labelComment.text = storeComment.rrContent;

    self.viewTotalImage.hidden = YES;
    self.viewTotalImageHeight.constant = 0;
    NSArray *imgs = storeComment.imgs;
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
    if (imgs.count >0) {
        self.viewTotalImage.hidden = NO;
        self.viewTotalImageHeight.constant = 80;
        NSArray *imgTotal = [NSArray arrayWithObjects:self.imageView1,self.imageView2,self.imageView3, nil];
        for (int a = 0; a <imgs.count; a++) {
            NSString *imgStr = imgs[a];
            if (a < 3) {
                UIImageView *image = imgTotal[a];
                [image sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
            }
            
        }
        
    }
    
    [_ratingView changeStarForegroundViewWithPoint:CGPointMake([storeComment.score floatValue]/5*64, 0)];//设置星级

}

@end
