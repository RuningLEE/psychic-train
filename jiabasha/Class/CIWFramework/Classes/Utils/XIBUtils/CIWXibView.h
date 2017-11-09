//
//  CIWXibView.h
//

#import <UIKit/UIKit.h>

@interface CIWXibView : UIView
+ (id)loadFromXib;
+ (id)loadFromXibIndex:(NSInteger)index;
@end

@interface CIWXibCell : UITableViewCell

+ (id)loadFromXib;
+ (id)loadFromXibIndex:(NSInteger)index;
+ (id)loadFromNibWithTable:(UITableView *)tableView;
+ (id)loadFromNibWithTable:(UITableView *)tableView withNibName:(NSString *)NibName;

+ (CGFloat)getCellHeight;
+ (CGFloat)getCellHeightWithObject:(id)object;
+ (CGFloat)getCellAutoHeightWithTableView:(UITableView *)tableView;
+ (CGFloat)getCellAutoHeightWithTableView:(UITableView *)tableView withObject:(id)object;


//可重用加载方式

 /**NSBundle 加载方式*/
+ (instancetype)dequeueReusableTable:(UITableView *)tableView;
/**UINib 加载方式*/
+ (instancetype)dequeueReusableNibCellWithTableView:(UITableView *)tableView;


@end

@interface CIWXibViewController : UIViewController
+ (id)loadFromXib;
@end