//
//  DecorationPackageCell.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "DecorationPackageCell.h"

@interface DecorationPackageCell()
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@end
@implementation DecorationPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewMain.layer.borderColor = RGB(221, 221, 211).CGColor;
    self.viewMain.layer.borderWidth = 1;
    self.viewMain.layer.cornerRadius = 2;
    
    self.viewMember.layer.cornerRadius = 6;

    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DecorationPackageCell" owner:self options:nil];
        
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
