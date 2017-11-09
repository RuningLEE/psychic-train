//
//  CustomPickerViewController.h
//  jiabasha
//
//  Created by guok on 17/1/19.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerDelegate <NSObject>

@required
//行数
- (NSInteger)numberOfRowsInPickerView:(UIPickerView *)pickerView;

//每行表示的值
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row;

//确认时返回 选择的行数和表示的值
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row;

@end

@interface CustomPickerViewController : UIViewController

@property (nonatomic, copy) NSString *selectTitle;
@property (nonatomic, weak) id<CustomPickerDelegate> delegate;

@end
