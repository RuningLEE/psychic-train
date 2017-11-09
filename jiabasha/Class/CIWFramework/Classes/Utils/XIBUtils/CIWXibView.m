//
//  CIWXibView.m
//

#import "CIWXibView.h"
#import "CIWXibViewUtils.h"


@implementation CIWXibView

+ (id)loadFromXib {
    return [CIWXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

+ (id)loadFromXibIndex:(NSInteger)index {
    return [CIWXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class]) andIndex:index];
}

@end


@implementation CIWXibCell
+ (id)loadFromXib {
    return [CIWXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

+ (id)loadFromXibIndex:(NSInteger)index {
    return [CIWXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class]) andIndex:index];
}

+ (id)loadFromNibWithTable:(UITableView *)tableView {
    return [self loadFromNibWithTable:tableView withNibName:NSStringFromClass([self class])];
}

+ (id)loadFromNibWithTable:(UITableView *)tableView withNibName:(NSString *)NibName{
    UINib *nib = [UINib nibWithNibName:NibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}

+ (CGFloat)getCellHeight
{
    return 0;
}

+ (CGFloat)getCellHeightWithObject:(id)object
{
    return 0;
}


+ (instancetype)dequeueReusableTable:(UITableView *)tableView
{
    NSString *cellIdentify = NSStringFromClass([self class]);
    id cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [self loadFromXib];
    }
    return cell;
}

+ (instancetype)dequeueReusableNibCellWithTableView:(UITableView *)tableView
{
    NSString *cellIdentify = NSStringFromClass([self class]);
    id cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(!cell){
        cell = [self loadFromNibWithTable:tableView];
    }
    return cell;
}

/**autuLayout自动返回高度*/
+ (CGFloat)getCellAutoHeightWithTableView:(UITableView *)tableView
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return UITableViewAutomaticDimension;
    }else{
        
        CIWXibCell *cell = [self dequeueReusableTable:tableView];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        return [cell.contentView
                systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

/**需要开发者重写计算高度方法*/
+ (CGFloat)getCellAutoHeightWithTableView:(UITableView *)tableView withObject:(id)object{
    return 0;
}


@end

@implementation CIWXibViewController
+ (id)loadFromXib{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

@end