//
//  EditFitmentViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EditFitmentViewController.h"
#import "ReserveFitmentRequest.h"
#define kMaxLength 18

@interface EditFitmentViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstant;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) IBOutlet UIView *viewRoom;
@property (weak, nonatomic) IBOutlet UIView *viewBoard;
@property (weak, nonatomic) IBOutlet UIView *viewKitchen;
@property (weak, nonatomic) IBOutlet UIView *viewRestRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelRoomNum;
@property (weak, nonatomic) IBOutlet UILabel *labelBoardNum;
@property (weak, nonatomic) IBOutlet UILabel *labelKitchenNum;
@property (weak, nonatomic) IBOutlet UILabel *labelRestRoomNum;
@property (weak, nonatomic) IBOutlet UIView *viewEstate;
@property (weak, nonatomic) IBOutlet UIView *viewArea;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEstate;
@property (weak, nonatomic) IBOutlet UITextField *textfieldArea;
@property (strong, nonatomic) IBOutlet UIView *viewSelect;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSelect;
/**
 *选择数量
 */
@property (strong, nonatomic) NSMutableArray* arrSelect;
/**
 *现选择的tag标记
 */
@property (assign, nonatomic) NSInteger selectTag;

@end

@implementation EditFitmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self initUIGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _contentViewWidthConstant.constant  = kScreenWidth;
    _contentViewHeightConstant.constant = kScreenHeight - 64;
    //设置底部button描边
    _buttonCancel.layer.borderColor    = RGBFromHexColor(601986).CGColor;
    _buttonCancel.layer.borderWidth    = 1;
    _buttonCancel.layer.cornerRadius   = 3;
    _buttonCancel.layer.masksToBounds  = YES;
    
    _buttonConfirm.layer.cornerRadius  = 3;
    _buttonConfirm.layer.masksToBounds = YES;
    
    //添加选择器
    _viewSelect.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:_viewSelect];
    _viewSelect.hidden = YES;
    
    _pickerSelect.delegate                = self;
    _pickerSelect.dataSource              = self;
    _pickerSelect.showsSelectionIndicator = YES;
    
    //设置内容视图描边
    _viewEstate.layer.borderColor   = RGB(221, 221, 221).CGColor;
    _viewEstate.layer.borderWidth   = 1;
    _viewArea.layer.borderColor     = RGB(221, 221, 221).CGColor;
    _viewArea.layer.borderWidth     = 1;
    _viewRoom.layer.borderColor     = RGB(221, 221, 221).CGColor;
    _viewRoom.layer.borderWidth     = 1;
    _viewBoard.layer.borderColor    = RGB(221, 221, 221).CGColor;
    _viewBoard.layer.borderWidth    = 1;
    _viewKitchen.layer.borderColor  = RGB(221, 221, 221).CGColor;
    _viewKitchen.layer.borderWidth  = 1;
    _viewRestRoom.layer.borderColor = RGB(221, 221, 221).CGColor;
    _viewRestRoom.layer.borderWidth = 1;
    
    //设置tag识别手势传值
    _viewRoom.tag     = 1;
    _viewBoard.tag    = 2;
    _viewKitchen.tag  = 3;
    _viewRestRoom.tag = 4;
    
    [_textfieldEstate addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldArea addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldEstate.delegate = self;
    
    _textfieldArea.text = _fitMentModel.demandData.area;
    _textfieldEstate.text = _fitMentModel.demandData.block;
    
    //截取 室 厅 厨 卫
    NSString *strOri = _fitMentModel.demandData.houseType;
    NSRange roomRange = [strOri rangeOfString:@"室"];
    NSRange hallRange = [strOri rangeOfString:@"厅"];
    NSRange kitchenRange = [strOri rangeOfString:@"厨"];
    NSRange restRange = [strOri rangeOfString:@"卫"];
    
    _labelRoomNum.text = [strOri substringToIndex:roomRange.location];
    _labelBoardNum.text = [strOri substringWithRange:NSMakeRange(roomRange.location+1, hallRange.location - roomRange.location)];
    _labelKitchenNum.text = [strOri substringWithRange:NSMakeRange(kitchenRange.location, restRange.location - kitchenRange.location)];
    _labelRestRoomNum.text = [strOri substringFromIndex:restRange.location];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断空字段
- (BOOL)isAllNoEmpity{
    if (![CommonUtil isEmpty:_textfieldArea.text] && ![CommonUtil isEmpty:_textfieldEstate.text] && ![CommonUtil isEmpty:_labelRoomNum.text] && ![CommonUtil isEmpty:_labelBoardNum.text] && ![CommonUtil isEmpty:_labelKitchenNum.text] && ![CommonUtil isEmpty:_labelRestRoomNum.text]) {//都不为空
        [_buttonConfirm setBackgroundColor:RGB(96, 25, 134)];
        _buttonConfirm.userInteractionEnabled = YES;
        return YES;
    }else{
        [_buttonConfirm setBackgroundColor:[UIColor lightGrayColor]];
        _buttonConfirm.userInteractionEnabled = NO;
        return NO;
    }
}

//回收键盘
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

#pragma mark - UIViewClick
- (void)selectNum:(UITapGestureRecognizer *)tap{
    _selectTag = tap.view.tag;
    _viewSelect.hidden = NO;
    [self recoverKeyboard];
}

#pragma mark - ButtonClick
- (IBAction)buttonCancelClicked:(id)sender {
    [self.view makeToast:@"取消成功"];
}

- (IBAction)buttonConfrimClicked:(id)sender {
    [self.view endEditing:YES];
    /*
     params - {"city_id": "110900","access_token": "NgDXJv3Ua8Wt98B5oHDGeG8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8ehSWfOTQaIX/p8t1rH/Dcn4Xm3/9x2PWpPXNLfh9lnIsFMR7/5M=","demand_id":"15554","store_name":"测试","block":"测试","house_type":"2室2厅1厨1卫","area":"100","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
     */
    if ([CommonUtil isEmpty:_labelRoomNum.text]) {
        [self.view makeToast:@"请选择卧室数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelBoardNum.text]) {
        [self.view makeToast:@"请选择客厅数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelKitchenNum.text]) {
        [self.view makeToast:@"请选择厨房数量" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelRestRoomNum.text]) {
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
    
    NSString *houseType = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫",_labelRoomNum.text,_labelBoardNum.text,_labelKitchenNum.text,_labelRestRoomNum.text];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_textfieldEstate.text,@"block",houseType,@"house_type",_textfieldArea.text,@"area",_storeName,@"store_name",_demandId,@"demand_id", nil];
    [ReserveFitmentRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ReserveFitmentRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"修改成功" duration:1 position:CSToastPositionCenter];
        } else {
            [self.view makeToast:@"修改失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
    
}
//hide选择数量view
- (IBAction)hideSelectView:(id)sender {
    _viewSelect.hidden = YES;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//保存修改的数量
- (IBAction)saveSelectNum:(id)sender {
    NSString* num = [self.arrSelect objectAtIndex:[_pickerSelect selectedRowInComponent:0]];
    if (_selectTag == 1) {
        _labelRoomNum.text = num;
    }else if (_selectTag == 2){
        _labelBoardNum.text = num;
    }else if (_selectTag == 3){
        _labelKitchenNum.text = num;
    }else if (_selectTag == 4){
        _labelRestRoomNum.text = num;
    }
    [self isAllNoEmpity];
    _viewSelect.hidden = YES;

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

@end
