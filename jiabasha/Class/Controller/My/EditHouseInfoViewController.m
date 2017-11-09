//
//  EditHouseInfoViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EditHouseInfoViewController.h"
#import "GetHouseInfoRequest.h"
#import "SaveHouseInfoRequest.h"
#import "HouseInfoModel.h"
#define kMaxLength 18

@interface EditHouseInfoViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewheightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewwidthConstant;
@property (weak, nonatomic) IBOutlet UIView *viewEstate;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEstate;
@property (weak, nonatomic) IBOutlet UIView *viewHouseArea;
@property (weak, nonatomic) IBOutlet UITextField *textfieldArea;
@property (weak, nonatomic) IBOutlet UIView *viewRoom;
@property (weak, nonatomic) IBOutlet UIView *viewBoard;
@property (weak, nonatomic) IBOutlet UIView *viewKitchen;
@property (weak, nonatomic) IBOutlet UIView *viewRestRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelBoard;
@property (weak, nonatomic) IBOutlet UILabel *labelKitchen;
@property (weak, nonatomic) IBOutlet UILabel *labelRestRoom;
@property (weak, nonatomic) IBOutlet UIButton *buttonSupply;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (assign, nonatomic) NSInteger selectTag;
@property (strong, nonatomic) NSMutableArray* arrSelect;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSelect;
@property (strong, nonatomic) HouseInfoModel *houseInfoModel;
@end

@implementation EditHouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self initUIGestureRecognizer];
    [self getHouseInfoRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _contentViewwidthConstant.constant = kScreenWidth;
    _contentViewheightConstant.constant = kScreenHeight;
    
    [_textfieldEstate addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldArea addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldEstate.delegate = self;

    //添加选择器view
    _selectView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_selectView];
    _selectView.hidden = YES;
    
    _pickerSelect.delegate = self;
    _pickerSelect.dataSource = self;
    _pickerSelect.showsSelectionIndicator = YES;
    //设置描边
    _viewEstate.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewEstate.layer.borderWidth = 1;
    _viewHouseArea.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewHouseArea.layer.borderWidth = 1;
    _viewRoom.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewRoom.layer.borderWidth = 1;
    _viewBoard.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewBoard.layer.borderWidth = 1;
    _viewKitchen.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewKitchen.layer.borderWidth = 1;
    _viewRestRoom.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewRestRoom.layer.borderWidth = 1;
    //提交按钮初始状态为灰色
    _buttonSupply.backgroundColor = RGB(96, 25, 134);
    _buttonSupply.layer.opacity = 0.5;
    _buttonSupply.userInteractionEnabled = NO;
    
    _viewRoom.tag     = 1;
    _viewBoard.tag    = 2;
    _viewKitchen.tag  = 3;
    _viewRestRoom.tag = 4;
}

//初始化手势
- (void)initUIGestureRecognizer{
    //选择室
    [_viewRoom addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNum:)]];
    //选择厅
    [_viewBoard addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNum:)]];
    //选择厨
    [_viewKitchen addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNum:)]];
    //选择卫
    [_viewRestRoom addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNum:)]];
}

- (void)recoverKeyboard{
    [self.textfieldArea resignFirstResponder];
    [self.textfieldEstate resignFirstResponder];
}

#pragma mark - lazy init
- (NSMutableArray *)arrSelect
{
    if (_arrSelect == nil) {
        _arrSelect = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            NSString* num = [NSString stringWithFormat:@"%d",i+1];
            [_arrSelect addObject:num];
        }
    }
    return _arrSelect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma Request

- (void)getHouseInfoRequest{
    /*
     "access_token": "NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPPe69/zX1hAMs/u8xz1q7y1ny3eNp6b1+Ed/zEZtatp550qCyVfC5AlXr6z2DW+fGbef0qwH56G8E=","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    [GetHouseInfoRequest requestWithParameters:nil withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetHouseInfoRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            _houseInfoModel = (HouseInfoModel *)[request.resultDic objectForKey:@"HouseModel"];
            _textfieldEstate.text = _houseInfoModel.cell;
            _textfieldArea.text = _houseInfoModel.houseArea;
            _labelBoard.text = _houseInfoModel.houseInfo.hall;
            _labelKitchen.text = _houseInfoModel.houseInfo.kitchen;
            _labelRestRoom.text = _houseInfoModel.houseInfo.bathroom;
            _labelRoom.text = _houseInfoModel.houseInfo.room;
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

- (void)saveHouseInfoRequest{
    if ([CommonUtil isEmpty:_labelRoom.text]) {
        [self.view makeToast:@"请选择卧室数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelBoard.text]) {
        [self.view makeToast:@"请选择客厅数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelKitchen.text]) {
        [self.view makeToast:@"请选择厨房数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelRestRoom.text]) {
        [self.view makeToast:@"请选择卫生间数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_textfieldArea.text]) {
        [self.view makeToast:@"请填写房屋面积" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_textfieldEstate.text]) {
        [self.view makeToast:@"请填写所在小区名称" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    /*
     "access_token": "NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPPe69/zX1hAMs/u8xz1q7y1ny3eNp6b1+Ed/zEZtatp550qCyVfC5AlXr6z2DW+fGbef0qwH56G8E=","city_id":110900,"cell":"xx小区","house_area":"11","house_info":{"room":1,"hall":1,"kitchen":1,"bathroom":1},"app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
     */
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramHouseInfo = [NSMutableDictionary dictionary];
    [paramHouseInfo setValue:_labelRoom.text forKey:@"room"];
    [paramHouseInfo setValue:_labelRestRoom.text forKey:@"bathroom"];
    [paramHouseInfo setValue:_labelKitchen.text forKey:@"kitchen"];
    [paramHouseInfo setValue:_labelBoard.text forKey:@"hall"];
    [param setValue:_textfieldArea.text forKey:@"house_area"];
    [param setValue:_textfieldEstate.text forKey:@"cell"];
    [param setValue:paramHouseInfo forKey:@"house_info"];
    
    [SaveHouseInfoRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[SaveHouseInfoRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"修改成功" duration:1 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:@"修改失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
    
}

//判断空字段
- (BOOL)isAllNoEmpity{
    if (![CommonUtil isEmpty:_textfieldArea.text] && ![CommonUtil isEmpty:_textfieldEstate.text] && ![CommonUtil isEmpty:_labelRoom.text] && ![CommonUtil isEmpty:_labelBoard.text] && ![CommonUtil isEmpty:_labelKitchen.text] && ![CommonUtil isEmpty:_labelRestRoom.text]) {//都不为空
        [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonSupply.layer.opacity = 1;
        _buttonSupply.userInteractionEnabled = YES;
        return YES;
    }else{
        [_buttonSupply setBackgroundColor:RGB(96, 25, 134)];
        _buttonSupply.layer.opacity = 0.5;
        _buttonSupply.userInteractionEnabled = NO;
        return NO;
    }
}


//textfield监听方法
- (void)textFieldChanged:(UITextField *)textField {
    [self isAllNoEmpity];
    
    NSString *toBeString = textField.text;
    if (![self isInputRuleAndBlank:toBeString]) {//【注意2】处理在系统输入法简体拼音下可选择表情的情况
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 *  获得 kMaxLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > kMaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


#pragma mark - UIPickerView
//定义列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//每个列多少个
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrSelect.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrSelect objectAtIndex:row];
}

#pragma mark - UIViewClick
- (void)selectNum:(UITapGestureRecognizer *)tap{
    _selectTag = tap.view.tag;
    _selectView.hidden = NO;
    [self recoverKeyboard];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击提交
- (IBAction)btnSupplyClick:(id)sender {
    [self recoverKeyboard];
    [self saveHouseInfoRequest];
}

- (IBAction)hideSelectView:(id)sender {
    _selectView.hidden = YES;
}

- (IBAction)saveSelectNum:(id)sender {
    NSString* num = [self.arrSelect objectAtIndex:[_pickerSelect selectedRowInComponent:0]];
    if (_selectTag == 1) {
        _labelRoom.text = num;
    }else if (_selectTag == 2){
        _labelBoard.text = num;
    }else if (_selectTag == 3){
        _labelKitchen.text = num;
    }else if (_selectTag == 4){
        _labelRestRoom.text = num;
    }
    [self isAllNoEmpity];
    _selectView.hidden = YES;
}
@end
