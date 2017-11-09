//
//  CustomPickerViewController.m
//  jiabasha
//
//  Created by guok on 17/1/19.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CustomPickerViewController.h"

@interface CustomPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    __weak IBOutlet UILabel *_labelTitle;
    __weak IBOutlet UIPickerView *_pickerView;
    
    __weak IBOutlet NSLayoutConstraint *_bottomForContent;
}

@end

@implementation CustomPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _labelTitle.text = self.selectTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _bottomForContent.constant = -256;
    
    [UIView animateWithDuration:.3 animations:^{
        _bottomForContent.constant = 0;
    }];
}

- (IBAction)btnCancelClicked:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.view removeFromSuperview];
    }
}

- (IBAction)btnSaveClicked:(id)sender {
    if (self.delegate) {
        NSInteger row = [_pickerView selectedRowInComponent:0];
        [_delegate pickerView:_pickerView didSelectRow:row];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.view removeFromSuperview];
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.delegate) {
        return [_delegate numberOfRowsInPickerView:pickerView];
    }
    
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (self.delegate) {
        return [_delegate pickerView:pickerView titleForRow:row];
    }
    
    return @"";
}

@end
