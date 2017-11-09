//
//  OrderUploadViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "OrderUploadViewController.h"
#import "Masonry.h"
#import "KKdialogView.h"
#import "ShopSubscribeViewController.h"
#import "AddOrderRequest.h"
#import "UploadPicRequest.h"
#import "ImgModel.h"
#import "ShopStore.h"
#import "GetUserStoreListRequest.h"

#define MAXCOUNT 6

@interface OrderUploadViewController ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantContentHeight;
@property (weak, nonatomic) IBOutlet UIView *viewBankCard;
@property (weak, nonatomic) IBOutlet UIView *viewHomeDisplay;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewBankCard;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewHomeDIsplay;
@property (weak, nonatomic) IBOutlet UIView *viewBankContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBankContentHeight;
@property (weak, nonatomic) IBOutlet UIView *viewHomeDisplayContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHomeDIsplayContentHeight;
@property (strong, nonatomic) IBOutlet UIView *viewBankVue;
@property (strong, nonatomic) IBOutlet UIView *viewDisplayVue;
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic, getter=isspread) BOOL spread;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectImage;
@property (weak, nonatomic) IBOutlet UIView *viewImageContent;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantViewImageContentWidth;
@property (weak, nonatomic) IBOutlet UIView *viewShopName;
@property (weak, nonatomic) IBOutlet UIView *viewOrderPrice;
@property (strong, nonatomic) KKdialogView *dialogview;
@property (strong, nonatomic) NSMutableArray *arrSelectImage;
//textfield textfield在页面中比较多 统一放在一处
@property (weak, nonatomic) IBOutlet UITextField *textfieldOrderPrice;
//自取
@property (weak, nonatomic) IBOutlet UITextField *textfieldHomeDisplayName;
@property (weak, nonatomic) IBOutlet UITextField *textfieldHomeDisplayPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textfieldHomeDisplayIDCard;
@property (weak, nonatomic) IBOutlet UITextView *textviewHomeDisplayAddress;
//银行卡
@property (weak, nonatomic) IBOutlet UITextField *textfieldBankMold;
@property (weak, nonatomic) IBOutlet UITextField *textfieldBankCardNum;
@property (weak, nonatomic) IBOutlet UITextField *textfieldBankName;
@property (weak, nonatomic) IBOutlet UITextField *textfieldBankIDCard;
@property (assign, nonatomic) NSInteger maxLength;
//选择器视图
@property (strong, nonatomic) IBOutlet UIView *viewSelect;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewSelect;
@property (strong, nonatomic) NSMutableArray *arrSelect;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSMutableArray *arrImgId;
@property (strong, nonatomic) NSMutableArray *arrStoreModel;
@property (assign, nonatomic) NSInteger countImage;
@end

@implementation OrderUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initGestureRecognizer];
    _spread = NO;
    _maxLength = 18;
    _textviewHomeDisplayAddress.editable = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)setup{
    _constantContentWidth.constant = kScreenWidth;
    if (kScreenHeight > 603) {
        _constantContentHeight.constant = kScreenHeight;
    } else {
        _constantContentHeight.constant = 603;
    }
    _contentHeight = _constantContentHeight.constant;
    _viewBankContent.clipsToBounds = YES;
    _viewHomeDisplayContent.clipsToBounds = YES;
    [_viewBankContent addSubview:_viewBankVue];
    [_viewBankVue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(_viewBankContent);
    }];
    [_viewHomeDisplayContent addSubview:_viewDisplayVue];
    [_viewDisplayVue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(_viewHomeDisplayContent);
    }];
    [self.view layoutIfNeeded];
    _viewShopName.layer.borderColor = RGB(244, 244, 244).CGColor;
    _viewShopName.layer.borderWidth = 1;
    _viewShopName.layer.cornerRadius = 3;
    _viewShopName.layer.masksToBounds = YES;
    _viewOrderPrice.layer.borderColor = RGB(244, 244, 244).CGColor;
    _viewOrderPrice.layer.cornerRadius = 3;
    _viewOrderPrice.layer.borderWidth = 1;
    _viewOrderPrice.layer.masksToBounds = YES;
    //统一设置textfield代理
    _textfieldOrderPrice.delegate = self;
    _textfieldHomeDisplayName.delegate = self;
    _textfieldHomeDisplayPhoneNum.delegate = self;
    _textfieldHomeDisplayIDCard.delegate = self;
    _textviewHomeDisplayAddress.delegate = self;
    _textfieldBankMold.delegate = self;
    _textfieldBankName.delegate = self;
    _textfieldBankCardNum.delegate = self;
    _textfieldBankIDCard.delegate = self;
    //统一天添加监听
    [_textfieldHomeDisplayPhoneNum addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldHomeDisplayName addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldHomeDisplayIDCard addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldHomeDisplayIDCard.autocorrectionType = UITextAutocorrectionTypeNo;

    
    [_textfieldBankMold addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textfieldBankIDCard addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _textfieldBankIDCard.autocorrectionType = UITextAutocorrectionTypeNo;
    [_textfieldBankName addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //初始化选择器视图
    _pickerViewSelect.delegate   = self;
    _pickerViewSelect.dataSource = self;
    _viewSelect.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewSelect];
    _viewSelect.hidden = YES;
}

- (void)initGestureRecognizer{
    [_viewHomeDisplay addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewHomeDisplayClicked)]];
    _viewHomeDisplay.userInteractionEnabled = YES;
    [_viewBankCard addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBankClicked)]];
    _viewBankCard.userInteractionEnabled = YES;
}

#pragma mark - lazy init
- (NSMutableArray *)arrSelectImage
{
    if (_arrSelectImage == nil) {
        _arrSelectImage = [NSMutableArray array];
    }
    return _arrSelectImage;
}

- (NSMutableArray *)arrSelect
{
    if (_arrSelect == nil) {
        _arrSelect = [NSMutableArray array];
    }
    return _arrSelect;
}

- (NSMutableArray *)arrImgUrl
{
    if (_arrImgId == nil) {
        _arrImgId = [NSMutableArray array];
    }
    return _arrImgId;
}

- (NSMutableArray *)arrStoreModel
{
    if (_arrStoreModel == nil) {
        _arrStoreModel = [NSMutableArray array];
    }
    return _arrStoreModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

//上传图片接口
- (void)uploadPictureWithImageData:(UIImage *)imagePic{
    /*
     {"upload":"file对象","city_id":"110900","access_token":"NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPAfax4zHNhAMs/u8xz1q7y1ny3eNp6b1+ELqjCNN/6988uqnqRKn4UxHv7lWfQrKPPL68twi15FsM=","client_guid":"979722892","client_timestamp":1486728688687,"app_id":"10013","client_version":"1.0.0","app_usign":"/lWlbjUeoBZwIlZiANp9FkMA/kc="
     */
    //    "client_guid":"979722892"
    //    刘伟  12:38:06
    //    "app_id":"10013","client_version":"1.0.0"
    UIImage *compressImg = [self imageCompressForWidth:imagePic];
    NSData *imgData = UIImageJPEGRepresentation(compressImg, 0.75);
    __weak typeof(self) weakSelf = self;
    [UploadPicRequest requestWithParameters:nil
                          withIndicatorView:self.view
                          withCancelSubject:[UploadPicRequest getDefaultRequstName]
                  constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
                      [formData appendPartWithFileData:imgData name:@"upload" fileName:@"filenames.jpg" mimeType:@"image/jpeg"];
                  }
                             onRequestStart:nil
                          onRequestFinished:^(CIWBaseDataRequest *request) {
                              if ([request.errCode isEqualToString:RESPONSE_OK]) {
                                  ImgModel *img = [[ImgModel alloc]initWithDataDic:[request.resultDic objectForKey:@"data"]];
                                  if (_arrImgId == nil) {
                                      _arrImgId = [NSMutableArray array];
                                  }
                                  [weakSelf.arrImgId addObject:img.imgId];
                                  _countImage++;
                                  if (_countImage == weakSelf.arrSelectImage.count) {
                                      if (weakSelf.arrImgId.count == weakSelf.arrSelectImage.count) {
                                          //如果图片上传成功 进入订单点评接口
                                          [self uploadOrderRequest];
                                          [_arrImgId removeAllObjects];
                                          _countImage = 0;
                                      } else {
                                          [self.view makeToast:@"上传图片出错" duration:1 position:CSToastPositionCenter];
                                          [_arrImgId removeAllObjects];
                                          _countImage = 0;
                                      }
                                  }
                                  
                              }
                          }
                          onRequestCanceled:nil
                            onRequestFailed:^(CIWBaseDataRequest *request, NSError * error) {
                                NSLog(@"%@",error);
                            }];
    
}


//上传订单接口
- (void)uploadOrderRequest{
    /*
     "access_token": "NgDXJv3Ua8Wt9899qXHFc28OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihf8d9ehGUfuTQZYSk9cx+rn6XLX8Sk3r/xzPfq/zAL6p/w310EZcsr8E=","store_id":"60967","uid":"12721997","imgIds":["imgId1","imgId2"],"money":"987456","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_storeId,@"store_id",_textfieldOrderPrice.text,@"money",DATA_ENV.userInfo.user.uid,@"uid",self.arrImgId,@"imgs", nil];
    [AddOrderRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[AddOrderRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            if (![CommonUtil isEmpty:[request.resultDic objectForKey:@"data"]]) {
                [self.view makeToast:@"提交成功" duration:1 position:CSToastPositionCenter];
                [self performSelector:@selector(back) withObject:nil afterDelay:1];
            } else {
                [self.view makeToast:@"上传失败" duration:1 position:CSToastPositionCenter];
            }
        } else if ([request.errCode isEqualToString:@"err.addorder.time"]){
            [self.view makeToast:@"不在会员节上传订单时间范围内" duration:1 position:CSToastPositionCenter];
        } else {
            [self.view makeToast:@"上传失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

//获取店铺列表接口
- (void)getShopNameListRequest{
/*
 "access_token": "NgDXJv3Ua8Wt9899qXHFc28OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihf8d9ehGUfuTQZYSk9cx+rn6XLX8Sk3r/xzPfq/zAL6p/w310EZcsr8E=","city_id":"110900","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    __weak typeof(self) weakSelf = self;
    [GetUserStoreListRequest requestWithParameters:nil withCacheType:0 withIndicatorView:weakSelf.view withCancelSubject:[GetUserStoreListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            weakSelf.arrStoreModel = [request.resultDic objectForKey:@"arrStoreModel"];
            if (weakSelf.arrStoreModel.count) {
                _viewSelect.hidden = NO;
                [weakSelf.pickerViewSelect reloadAllComponents];
            } else {
                    weakSelf.viewSelect.hidden = YES;
                    [weakSelf.view makeToast:@"暂无商店可选" duration:1 position:CSToastPositionCenter];
            }
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//textfield监听方法
- (void)textFieldChanged:(UITextField *)textField {
    if (textField == _textfieldHomeDisplayPhoneNum) {
        _maxLength = 11;
    } else {
        _maxLength = 18;
    }
    
    NSString *toBeString = textField.text;
    if (![self isInputRuleAndBlank:toBeString]) {//【注意2】处理在系统输入法简体拼音下可选择表情的情况
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
//    KKLog(@"%@",lang);
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
    if (length > _maxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, _maxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, _maxLength - 1)];
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

#pragma mark - LabelClick

- (void)viewShopNameClicked{
    
}

- (void)viewBankClicked{
    //切换选择图片
    _imageviewBankCard.image = [UIImage imageNamed:@"订单提交_选中对勾图标"];
    _imageviewHomeDIsplay.image = [UIImage imageNamed:@"订单提交_对勾未选中图标"];
    _viewHomeDIsplayContentHeight.constant = 1;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //清空内容
        _textviewHomeDisplayAddress.text = @"";
        _textfieldHomeDisplayIDCard.text = @"";
        _textfieldHomeDisplayPhoneNum.text = @"";
        _textfieldHomeDisplayName.text = @"";
    }];
    if ([self isspread] == NO) {
        _spread = YES;
    }else{
        _contentHeight -= 254;
    }
    //计算内容视图的总高度 用tmp来计算(contentHeight)
    _viewBankContentHeight.constant = 254;
    _contentHeight += 254;
    _constantContentHeight.constant = _contentHeight;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewHomeDisplayClicked{
    _imageviewBankCard.image = [UIImage imageNamed:@"订单提交_对勾未选中图标"];
    _imageviewHomeDIsplay.image = [UIImage imageNamed:@"订单提交_选中对勾图标"];
    _viewBankContentHeight.constant = 1;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //清空内容
        _textfieldBankIDCard.text = @"";
        _textfieldBankName.text = @"";
        _textfieldBankCardNum.text = @"";
        _textfieldBankMold.text = @"";
    }];
    if ([self isspread] == NO) {
        _spread = YES;
    }else{
        _contentHeight -= 254;
    }
    _viewHomeDIsplayContentHeight.constant = 254;
    _contentHeight += 254;
    _constantContentHeight.constant = _contentHeight;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushShopViewController:(id)sender {
        [self getShopNameListRequest];
}

//隐藏选择器视图
- (IBAction)hideViewSelect:(id)sender {
    _viewSelect.hidden = YES;
}

//保存当前选择item
- (IBAction)saveSelectItem:(id)sender {
    ShopStore *shopModel = [self.arrStoreModel objectAtIndex:[_pickerViewSelect selectedRowInComponent:0]];
    _labelShopName.text = shopModel.storeName;
    _storeId = shopModel.storeId;
    _viewSelect.hidden = YES;
}

//提交
- (IBAction)supply:(id)sender {
    //调用上传订单接口
    if ([CommonUtil isEmpty:_textfieldOrderPrice.text]) {
        [self.view makeToast:@"请填写订单价格" duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([CommonUtil isEmpty:_labelShopName.text] || [CommonUtil isEmpty:_storeId]) {
        [self.view makeToast:@"请选择商家" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (self.arrSelectImage.count) {
        for (int i=0; i<self.arrSelectImage.count; i++) {
            [self uploadPictureWithImageData:self.arrSelectImage[i]];
        }
    }
}

- (IBAction)selectImageAction:(id)sender {
    //撤销键盘
    [self.view endEditing:YES];
    if (self.arrSelectImage.count == MAXCOUNT) {
        [self.view makeToast:@"最多可选6张"];
        return;
    }
    __weak typeof(self)WeakSelf = self;
    if (self.dialogview==nil) {
        self.dialogview = [[KKdialogView alloc]init];
        _dialogview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view addSubview:_dialogview];
        [_dialogview setClickBlock:^(Clicktype type) {
            __strong typeof(self)StrongSelf = WeakSelf;
//            KKLog(@"%d",type);
            switch (type) {
                case cancel_click:
                {
                    [StrongSelf.dialogview dismiss];
                    StrongSelf.dialogview = nil;
                }
                    break;
                case photo_library_click:
                {
//                    KKLog(@"点击相机");
                    NSUInteger sourceType = 0;
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.delegate = self;
                        imagePickerController.allowsEditing = YES;
                        imagePickerController.sourceType = sourceType;
                        imagePickerController.allowsImageEditing=YES;
                        [self presentViewController:imagePickerController animated:YES completion:^{
                            [StrongSelf.dialogview dismiss];
                            StrongSelf.dialogview = nil;
                        }];
                    }
                }
                    break;
                case camera_click:
                {
//                    KKLog(@"点击相册");
                    NSUInteger sourceType = 0;
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = YES;
                    imagePickerController.sourceType = sourceType;
                    imagePickerController.allowsImageEditing=YES;
                    //        UIImagePickerControllerEditedImage
                    [self presentViewController:imagePickerController animated:YES completion:^{
                        [StrongSelf.dialogview dismiss];
                        StrongSelf.dialogview = nil;
                    }];
                }
                    break;
                case blank_click:
                {
//                    KKLog(@"点击空白处");
                    [StrongSelf.dialogview dismiss];
                    StrongSelf.dialogview = nil;
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    [_dialogview show];
}

#pragma mark iamgePickerController--Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    //获取图片裁剪的图
    UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:edit];
}

- (void)saveImage:(UIImage *)image
{
    //png格式压缩后存入当前图片
    UIImage *compressImg = [self imageCompressForWidth:image];
    NSData *imgData = UIImageJPEGRepresentation(compressImg, 0.75);
    [self.arrSelectImage addObject:compressImg];
    //添加视图之后重新布局
    [self layoutPhotoView];
    //上传图片
    //    [self upLoadPictureNET:imgData andImage:image];
}

// 图片等比压缩
- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    UIImage* newImage;
    if (width>1800 && height>1800) {
        CGFloat targetWidth = [UIScreen mainScreen].bounds.size.width *3 ;
        CGFloat targetHeight = (targetWidth / width) * height ;
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight)); //创建所要尺寸的上下文环境
        [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)]; //将图片绘制到新的尺寸中，压缩
        newImage = UIGraphicsGetImageFromCurrentImageContext(); //从当前环境中取出img
        UIGraphicsEndImageContext(); //结束环境
    }else{
        newImage = sourceImage;
    }
    return newImage;
}


//选择完图片之后进行布局
- (void)layoutPhotoView{
    //布局之前清空视图
    for (id subview in _viewImageContent.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            [subview removeFromSuperview];
        }
    }
    //设定基本参数
    CGFloat contentLength = 70;
    CGFloat imageLength = 60;
    CGFloat margin = 8;
    CGFloat marginTop = 7.5;
    
    if (self.arrSelectImage.count == 0) {
        //位置不变
        _buttonSelectImage.frame = CGRectMake(15, 12.5, 60, 60);
        [_viewImageContent addSubview:_buttonSelectImage];
        _constantViewImageContentWidth.constant = kScreenWidth;
    } else {
        //位置变更到最后一张图片的右边margin 8
        for (int i=0; i<self.arrSelectImage.count; i++) {
            //先创建一个容器view
            UIView *viewCell = [[UIView alloc]init];
            viewCell.frame = CGRectMake(15+i*(contentLength+margin), marginTop, contentLength, contentLength);
            [self.viewImageContent addSubview:viewCell];
            //图片
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[self.arrSelectImage objectAtIndex:i]];
            imageView.layer.cornerRadius = 3;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake( 5, 5, imageLength, imageLength);
            [viewCell addSubview:imageView];
            //删除image
            UIImageView *imageViewDelete = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"delpic"]];
            imageViewDelete.userInteractionEnabled = YES;
            imageViewDelete.width = 14;
            imageViewDelete.height = 14;
            imageViewDelete.x = contentLength-14;
            imageViewDelete.y = 0;
            [viewCell addSubview:imageViewDelete];
            imageViewDelete.tag = [self baseTag]+i;
            [imageViewDelete addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImageWithTag:)]];
        }
        _buttonSelectImage.frame = CGRectMake(self.arrSelectImage.count*(contentLength+margin)+15, 12.5, 60, 60);
        [_viewImageContent addSubview:_buttonSelectImage];
        CGFloat maxX = CGRectGetMaxX(_buttonSelectImage.frame)+15;
        if (maxX>kScreenWidth) {
            _constantViewImageContentWidth.constant = maxX;
        } else {
            _constantViewImageContentWidth.constant = kScreenWidth;
        }
    }
}

- (NSInteger)baseTag{
    return 15;
}

#pragma mark - imageViewClick
- (void)deleteImageWithTag:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - [self baseTag];
    [self.arrSelectImage removeObjectAtIndex:index];
    [self layoutPhotoView];
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
    return self.arrStoreModel.count;
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
    ShopStore *shopModel = (ShopStore *)[self.arrStoreModel objectAtIndex:row];
    return shopModel.storeName;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
