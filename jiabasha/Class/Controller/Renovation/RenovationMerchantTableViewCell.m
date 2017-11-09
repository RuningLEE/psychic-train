//
//  RenovationMerchantTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Store.h"
#import "TQStarRatingView.h"
#import "RenovationMerchantTableViewCell.h"

@interface RenovationMerchantTableViewCell ()
@property (strong, nonatomic) TQStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *viewStar; // 显示评分
@property (weak, nonatomic) IBOutlet UILabel *labelCommentNum;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStore;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelStoreNameWidth;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;



@end
@implementation RenovationMerchantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //初始化星级评价
    if (self.ratingView == nil){
        self.ratingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 64, 11) numberOfStar:5 starSpace:1];
        self.ratingView.couldClick = NO;
        [_ratingView changeStarForegroundViewWithPoint:CGPointMake(0.0/5*64, 0)];//设置星级
        [self.viewStar addSubview:self.ratingView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCell:(Store *)store{
    [_ratingView changeStarForegroundViewWithPoint:CGPointMake([store.scoreAvg floatValue]/500*64, 0)];//设置星级
    
    NSString * commmentNum = [NSString stringWithFormat:@"%@预约｜%@订单｜%@点评", store.orderNum,store.dpOrder,store.dpCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(0,store.orderNum.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(store.orderNum.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(store.orderNum.length+3,store.dpOrder.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(store.orderNum.length+3 +store.dpOrder.length,3)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(store.orderNum.length+3 +store.dpOrder.length+3,store.dpCount.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(commmentNum.length -2,2)];
    self.labelCommentNum.attributedText = attrString;

    [self.imageViewStore sd_setImageWithURL:[NSURL URLWithString:store.logo] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
    self.labelStoreName.text = store.storeName;
    self.labelStoreAddress.text = store.address;
    
   // float commentHeight = 100;
    self.labelStoreNameWidth.constant = 60;
    if (store.storeName != nil) {
        CGSize contentSize = [store.storeName boundingRectWithSize:CGSizeMake(kScreenWidth , MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                               attributes:@{NSFontAttributeName:
                                                                                [UIFont systemFontOfSize:15]}
                                                                  context:nil].size;
        if (contentSize.width > 100) {
            self.labelStoreNameWidth.constant = 100;
        }else{
            self.labelStoreNameWidth.constant = contentSize.width + 5;
        }
    }
    self.labelOne.hidden = NO;
    self.labelTwo.hidden = NO;
    self.labelThree.hidden = NO;
    if([store.verifyBrand integerValue] == 1 && [store.verifyCash integerValue] == 1 && [store.cashCount integerValue] > 0){
        self.labelOne.text = @"证";
        self.labelOne.backgroundColor = RGB(112, 192, 235);
        self.labelTwo.text = @"返";
        self.labelTwo.backgroundColor = RGB(252, 193, 78);
        self.labelThree.text = @"券";
        self.labelThree.backgroundColor = RGB(247, 115, 108);
    }else if ([store.verifyBrand integerValue] == 1 && [store.verifyCash integerValue] == 1){
        self.labelThree.hidden = YES;
        self.labelOne.text = @"证";
        self.labelOne.backgroundColor = RGB(112, 192, 235);
        self.labelTwo.text = @"返";
        self.labelTwo.backgroundColor = RGB(252, 193, 78);
    }else if ([store.verifyBrand integerValue] == 1 &&  [store.cashCount integerValue] > 0){
        self.labelOne.text = @"证";
        self.labelOne.backgroundColor = RGB(112, 192, 235);
        self.labelTwo.text = @"券";
        self.labelTwo.backgroundColor = RGB(247, 115, 108);
        self.labelThree.hidden = YES;
    }else if ([store.verifyCash integerValue] == 1 &&  [store.cashCount integerValue] > 0){
        self.labelOne.text = @"返";
        self.labelOne.backgroundColor = RGB(252, 193, 78);
        self.labelTwo.text = @"券";
        self.labelTwo.backgroundColor = RGB(247, 115, 108);
        self.labelThree.hidden = YES;
    } else if ([store.verifyBrand integerValue] == 1){
        self.labelOne.text = @"证";
        self.labelOne.backgroundColor = RGB(112, 192, 235);
        self.labelTwo.hidden = YES;
        self.labelThree.hidden = YES;
    }else if ([store.verifyBrand integerValue] == 1){
        self.labelOne.text = @"返";
        self.labelOne.backgroundColor = RGB(252, 193, 78);
        self.labelTwo.hidden = YES;
        self.labelThree.hidden = YES;
    }else if ([store.verifyBrand integerValue] == 1){
        self.labelOne.text = @"券";
        self.labelOne.backgroundColor = RGB(247, 115, 108);
        self.labelTwo.hidden = YES;
        self.labelThree.hidden = YES;
    }else{
        self.labelOne.hidden = YES;
        self.labelTwo.hidden = YES;
        self.labelThree.hidden = YES;
    }



        
}

@end
