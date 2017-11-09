 //
//  PersonDataViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PersonDataViewController.h"
#import "PersonDataTableViewCell.h"
#import "PersonDataHeadiconTableViewCell.h"
#import "ModifyMobilePhonNumViewController.h"
#import "KKdialogView.h"
#import "ModifyPasswordViewController.h"
#import "ModifyPhoneNumFirstStepViewController.h"
#import "UpdateUserDataRequest.h"
#import "UploadPicRequest.h"
#import "ImgModel.h"
#import "GetUserDataRequest.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kMaxLength 18

@interface PersonDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImage* selected_image;
@property(nonatomic,strong) KKdialogView *dialogview;
@end

@implementation PersonDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(246, 246, 246);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-210-64)];
    _tableView.tableFooterView = viewFooter;
    viewFooter.userInteractionEnabled = YES;
    [viewFooter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverKeyboard)]];
    [_tableView registerNib:[UINib nibWithNibName:@"PersonDataHeadiconTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellhead"];
    [_tableView registerNib:[UINib nibWithNibName:@"PersonDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellpserson"];
}

- (void)recoverKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
//        return YES;
//    } else {
//        return NO;
//    }
    return YES;
}

#pragma mark - Request

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /*
     "uid": "12659722","uname": "新用户名","avatar": "http://st.zhy.hapn.cc/static/img/default/user.png","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc
     */
    NSString *uname = textField.text;
    if ([CommonUtil isEmpty:uname]) {
        return NO;
    }
    
    [self.view endEditing:YES];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid",uname,@"uname", nil];
    [UpdateUserDataRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[UpdateUserDataRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"成功修改用户名" duration:1 position:CSToastPositionCenter];
        } else if ([request.errCode isEqualToString:@"user.u_uname_exists"]){
            [self.view makeToast:@"用户名已存在" duration:1 position:CSToastPositionCenter];
        } else {
            [self.view makeToast:@"修改用户名失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [self.view makeToast:@"修改用户名失败" duration:1 position:CSToastPositionCenter];
    }];
    return YES;
}

- (void)uploadPicRequestWithData:(NSData *)picData andPicture:(UIImage *)newImage{
    /*
     {"upload":"file对象","city_id":"110900","access_token":"NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPAfax4zHNhAMs/u8xz1q7y1ny3eNp6b1+ELqjCNN/6988uqnqRKn4UxHv7lWfQrKPPL68twi15FsM=","client_guid":"979722892","client_timestamp":1486728688687,"app_id":"10013","client_version":"1.0.0","app_usign":"/lWlbjUeoBZwIlZiANp9FkMA/kc="
     */
//    "client_guid":"979722892"
//    刘伟  12:38:06
//    "app_id":"10013","client_version":"1.0.0"
    [UploadPicRequest requestWithParameters:nil
                          withIndicatorView:self.view
                          withCancelSubject:[UploadPicRequest getDefaultRequstName]
                  constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
                    [formData appendPartWithFileData:picData name:@"upload" fileName:@"filenames.jpg" mimeType:@"image/jpeg"];
                  }
                             onRequestStart:nil
                          onRequestFinished:^(CIWBaseDataRequest *request) {
                              if ([request.errCode isEqualToString:RESPONSE_OK]) {
                                  ImgModel *img = [[ImgModel alloc]initWithDataDic:[request.resultDic objectForKey:@"data"]];
//                                  UserInfo *userinfoNew = [UserInfo alloc]
                                  [self changeUserHeadIconRequestWithfaceId:img.imgId];
                              }
                          }
                          onRequestCanceled:nil
                            onRequestFailed:^(CIWBaseDataRequest *request, NSError * error) {
                                NSLog(@"%@",error);
                        }];
}

- (void)changeUserHeadIconRequestWithfaceId:(NSString *)faceId{
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid",faceId,@"face_id", nil];
    [UpdateUserDataRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[UpdateUserDataRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [weakSelf.view makeToast:@"成功修改头像"];
            [weakSelf getMineData];
        } else {
            [weakSelf.view makeToast:@"修改用户头像失败"];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [self.view makeToast:@"修改用户头像失败"];
    }];
}

/**
 在进入我的界面时候进行重新取数据以便及时刷新该页面的数据
 */
- (void)getMineData{
    //"uid": "12659722","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid", nil];
    [GetUserDataRequest requestWithParameters:param withIsCacheData:YES withIndicatorView:self.view withCancelSubject:[GetUserDataRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [CommonUtil replaceUserInfoWithUser:request.resultDic];
            [_tableView reloadData];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
    } onRequestFailed:^(CIWBaseDataRequest *request) {
    }];
}


//textfield监听方法
- (void)textFieldChanged:(UITextField *)textField {
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

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60.f;
    }else{
        return 50.f;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PersonDataHeadiconTableViewCell *cellhead = [tableView dequeueReusableCellWithIdentifier:@"cellhead"];
        [cellhead.ImageViewHead sd_setImageWithURL:[NSURL URLWithString:DATA_ENV.userInfo.user.faceUrl] placeholderImage:[UIImage imageNamed:@"未登录头像-1"]];
        cellhead.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellhead;
    } else {
        PersonDataTableViewCell * cellpserson = [tableView dequeueReusableCellWithIdentifier:@"cellpserson"];
        cellpserson.selectionStyle = UITableViewCellSelectionStyleNone;
         if (indexPath.row == 1) {
            cellpserson.labelTitle.text = @"昵称";
            cellpserson.textfiledSubtitle.text = DATA_ENV.userInfo.user.uname;
            cellpserson.textfiledSubtitle.userInteractionEnabled = YES;
            cellpserson.textfiledSubtitle.delegate = self;
            [cellpserson.textfiledSubtitle addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            cellpserson.imageviewRighticon.image = [UIImage imageNamed:@"pencil"];
            cellpserson.constantTrailing.constant = 5;
        } else if (indexPath.row == 2){
            cellpserson.labelTitle.text = @"绑定手机";
            if (![CommonUtil isEmpty:DATA_ENV.userInfo.user.phone]) {
                cellpserson.textfiledSubtitle.text = DATA_ENV.userInfo.user.phone;
            } else {
                cellpserson.textfiledSubtitle.text = @"未绑定";
            }
            cellpserson.textfiledSubtitle.userInteractionEnabled = NO;
            cellpserson.imageviewRighticon.image = [UIImage imageNamed:@"向左箭头"];
            cellpserson.constantTrailing.constant = 11;
        } else if (indexPath.row == 3){
             cellpserson.labelTitle.text = @"密码修改";
            cellpserson.textfiledSubtitle.text = @"";
            cellpserson.imageviewRighticon.image = [UIImage imageNamed:@"向左箭头"];
            cellpserson.textfiledSubtitle.userInteractionEnabled = NO;
            cellpserson.constantTrailing.constant = 11;
        }
        return cellpserson;
    }
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];//recover keyboard
    if (indexPath.row == 0) {
        __weak typeof(self)WeakSelf = self;
        if (self.dialogview==nil) {
            self.dialogview = [[KKdialogView alloc]init];
            _dialogview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [self.view addSubview:_dialogview];
             [_dialogview setClickBlock:^(Clicktype type) {
                __strong typeof(self)StrongSelf = WeakSelf;
                 switch (type) {
                    case cancel_click:
                    {
                        [StrongSelf.dialogview dismiss];
                        StrongSelf.dialogview = nil;
                    }
                        break;
                    case photo_library_click:
                    {
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
                        NSUInteger sourceType = 0;
                        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
                        break;
                    case blank_click:
                    {
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
    }else if (indexPath.row == 2){//修改修改绑定手机
        if ([CommonUtil isEmpty:DATA_ENV.userInfo.user.phone]) {
            ModifyMobilePhonNumViewController *bindPhone = [[ModifyMobilePhonNumViewController alloc]init];
            [self.navigationController pushViewController:bindPhone animated:YES];
        } else {
           ModifyPhoneNumFirstStepViewController* modifyPhoneController = [[ModifyPhoneNumFirstStepViewController alloc]init];
           [self.navigationController pushViewController:modifyPhoneController animated:YES];
        }
    }else if (indexPath.row == 3){//密码修改
        ModifyPasswordViewController* modifypassword = [[ModifyPasswordViewController alloc]init];
        [self.navigationController pushViewController:modifypassword animated:YES];
    }
}

#pragma mark - imagePickerController Delegate
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
    _selected_image = compressImg;
    //上传图片
    [self uploadPicRequestWithData:imgData andPicture:compressImg];
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

#pragma mark - BtnClick Method
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
