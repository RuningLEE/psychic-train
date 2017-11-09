//
//  CompanyTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "Store.h"
#import "TQStarRatingView.h"
#import "CompanyTableViewCell.h"

@interface CompanyTableViewCell()
@property (strong, nonatomic) TQStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *viewStar; // 显示评分
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentNum;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStore;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end
@implementation CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //初始化星级评价
    if (self.ratingView == nil){
        self.ratingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 64, 11) numberOfStar:5 starSpace:2];
        self.ratingView.couldClick = NO;
          [_ratingView changeStarForegroundViewWithPoint:CGPointMake(0.0/5*64, 0)];//设置星级
        [self.viewStar addSubview:self.ratingView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(Store *)StoreData{
    [_ratingView changeStarForegroundViewWithPoint:CGPointMake([StoreData.scoreAvg floatValue]/500*64, 0)];//设置星级
    self.labelStoreName.text = StoreData.storeName;
    self.labelAddress.text = StoreData.address;
    [self.imageViewStore sd_setImageWithURL:[NSURL URLWithString:StoreData.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    
    self.imageView1.hidden = NO;
    self.imageView2.hidden = NO;
    self.imageView3.hidden = NO;
    self.btnCaseOne.hidden = NO;
    self.btnCaseTwo.hidden = NO;
    self.btnCaseThree.hidden = NO;
    NSArray *images = [NSArray arrayWithObjects:self.imageView1,self.imageView2,self.imageView3, nil];
    NSInteger num = StoreData.albumList.count;
    if (num> 3) {
        num = 3;
    }
    for (int a = 0; a<num ; a++) {
        NSDictionary *albumDic = StoreData.albumList[a];
        UIImageView *image = images[a];
        [image sd_setImageWithURL:[NSURL URLWithString:[albumDic[@"show_img_url"] description]] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    }

    if (num == 1) {
        self.imageView1.hidden = NO;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.btnCaseOne.hidden = NO;
        self.btnCaseTwo.hidden = YES;
        self.btnCaseThree.hidden = YES;
    }else if (num == 2){
        self.imageView1.hidden = NO;
        self.imageView2.hidden = NO;
        self.imageView3.hidden = YES;
        self.btnCaseOne.hidden = NO;
        self.btnCaseTwo.hidden = NO;
        self.btnCaseThree.hidden = YES;
    }else if (num == 0){
        self.imageView1.hidden = YES;
        self.imageView2.hidden = YES;
        self.imageView3.hidden = YES;
        self.btnCaseOne.hidden = YES;
        self.btnCaseTwo.hidden = YES;
        self.btnCaseThree.hidden = YES;
    }
    
    NSString * commmentNum = [NSString stringWithFormat:@"%@预约｜%@订单｜%@点评", StoreData.orderNum,StoreData.dpOrder,StoreData.dpCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(0,StoreData.orderNum.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(StoreData.orderNum.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(StoreData.orderNum.length+3,StoreData.dpOrder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(StoreData.orderNum.length+3 +StoreData.dpOrder.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(StoreData.orderNum.length+3 +StoreData.dpOrder.length+3,StoreData.dpCount.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(commmentNum.length -2,2)];
    self.labelCommentNum.attributedText = attrString;

}
@end
