//
//  EvlauateOrderViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EvlauateOrderViewController.h"
#import "KKdialogView.h"
#import "Masonry.h"
#import "UploadPicRequest.h"
#import "ImgModel.h"
#import "EvaluateOrderRequest.h"
#import "MyOrderViewController.h"
#import "EvaluateOrderUpdateRequest.h"
//#import "GetMallDpCommentListRequest.h"
#import "RequireEvaluateDetailRequest.h"
#define MAXCOUNT 6
#define MAXLENGTH 100

@interface EvlauateOrderViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageStoreHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstant;
@property (weak, nonatomic) IBOutlet UIButton *buttonFir;
@property (weak, nonatomic) IBOutlet UIButton *buttonSec;
@property (weak, nonatomic) IBOutlet UIButton *buttonTir;
@property (weak, nonatomic) IBOutlet UIButton *buttonFor;
@property (weak, nonatomic) IBOutlet UIButton *buttonFif;
@property (assign, nonatomic) NSInteger evlauateCount;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *viewImageContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewImageContentWidth;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectImage;
@property (strong, nonatomic) KKdialogView *dialogview;
@property (strong, nonatomic) NSMutableArray *arrSelectImage;
@property (strong, nonatomic) NSMutableArray *arrImgUrl;
@property (strong, nonatomic) NSMutableArray *arrImgData;
@property (assign, nonatomic) NSInteger countImage;

@end

@implementation EvlauateOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_type isEqualToString:@"2"]){
        [self getBuildingStoreCommentData];
    }

    [_imageStoreHeadIcon sd_setImageWithURL:[NSURL URLWithString:_orderModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    _labelAddress.text = _orderModel.store.address;
    _labelStoreName.text = _orderModel.store.storeName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonFir.tag=1;
    _buttonSec.tag=2;
     _buttonTir.tag=3;
    _buttonFor.tag=4;
     _buttonFif.tag=5;
    if ([_type isEqualToString:@"2"]){
        [self getBuildingStoreCommentData];
    }
    [self setup];
    // Do any additional setup after loading the view from its nib.
}
// 用户评论
- (void)getBuildingStoreCommentData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_remarkID forKey:@"remark_id"];
    // [parameters setValue:@"44017" forKey:@"store_id"];
    //[parameters setValue:[NSNumber numberWithInteger:0] forKey:@"page"];
    //[parameters setValue:@10 forKey:@"size"];
    
    //__weak typeof(self) weakSelf = self;
    [RequireEvaluateDetailRequest requestWithParameters:parameters
                                         withCacheType:DataCacheManagerCacheTypeMemory
                                     withIndicatorView:nil
                                     withCancelSubject:[RequireEvaluateDetailRequest getDefaultRequstName]
                                        onRequestStart:nil
                                     onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                           
                                             NSLog(@"data==%@",request.resultDic);
                                             NSMutableArray *imageArray=request.resultDic[@"data"][@"imgs"];
                                             _textView.text=request.resultDic[@"data"][@"rr_content"];
                                             _labelPlaceHolder.hidden = YES;
                                             NSLog(@"score==%@",request.resultDic[@"data"][@"score"]);
                                             if ([[request.resultDic[@"data"][@"score"] stringValue] isEqualToString:@"1"]) {
                                                 UIButton *but=(UIButton *)[self.view viewWithTag:1];
                                                 [self firButtonClicked:but];
                                             }else if ([[request.resultDic[@"data"][@"score"] stringValue] isEqualToString:@"2"]){
                                                 UIButton *but=(UIButton *)[self.view viewWithTag:2];
                                                 [self secButtonClicked:but];
                                             }else if ([[request.resultDic[@"data"][@"score"] stringValue] isEqualToString:@"3"]){
                                                 UIButton *but=(UIButton *)[self.view viewWithTag:3];
                                                 [self tirButtonClicked:but];
                                             }else if ([[request.resultDic[@"data"][@"score"] stringValue] isEqualToString:@"4"]){
                                                 UIButton *but=(UIButton *)[self.view viewWithTag:4];
                                                 [self fouthButtonClicked:but];
                                             }else if ([[request.resultDic[@"data"][@"score"] stringValue] isEqualToString:@"5"]){
                                                 UIButton *but=(UIButton *)[self.view viewWithTag:5];
                                                 [self fifButtonClicked:but];
                                             }
                                             
                                             NSString *imageStr=[NSString string];
                                             for (int i=0; i<imageArray.count; i++) {
                                                  NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageArray[i]]];
                                                 UIImage *image=[UIImage imageWithData:data];
                                                 [_arrSelectImage addObject:image];
                                                 [self layoutPhotoView];
                                                 
                                             }
//                                             NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
                                             //result = [UIImage imageWithData:data];
                                            
                                             }
                                         
                                     }
                                     onRequestCanceled:^(CIWBaseDataRequest *request) {
                                       
                                         
                                     }
                                       onRequestFailed:^(CIWBaseDataRequest *request) {
                                          
                                       }];
}

- (void)setup{
    _contentViewWidthConstant.constant = kScreenWidth;
    _contentViewHeightConstant.constant = kScreenHeight - 64;
    _viewImageContentWidth.constant = kScreenWidth;
    _evlauateCount = 0;
    _textView.delegate = self;
    //手动设置button防止产生约束依赖
    _buttonSelectImage.frame = CGRectMake(15, 9, 60, 60);
    [_viewImageContent addSubview:_buttonSelectImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)arrSelectImage
{
    if (_arrSelectImage == nil) {
        _arrSelectImage = [NSMutableArray array];
    }
    return _arrSelectImage;
}

- (NSMutableArray *)arrImgUrl
{
    if (_arrImgUrl == nil) {
        _arrImgUrl = [NSMutableArray array];
    }
    return _arrImgUrl;
}

- (NSMutableArray *)arrImgData{
    if (_arrImgData == nil) {
        _arrImgData = [NSMutableArray array];
    }
    return _arrImgData;
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _labelPlaceHolder.hidden = NO;
    } else {
        _labelPlaceHolder.hidden = YES;
    }
    NSString *toBeString = textView.text;
    if (![self isInputRuleAndBlank:toBeString]) {//【注意2】处理在系统输入法简体拼音下可选择表情的情况
        textView.text = [self disable_emoji:toBeString];
        return;
    }
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textView.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textView.text= getStr;
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
    if (length > MAXLENGTH) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, MAXLENGTH)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//【注意4】：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, MAXLENGTH - 1)];
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


#pragma mark - imageViewClick
- (void)deleteImageWithTag:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - [self baseTag];
    [self.arrSelectImage removeObjectAtIndex:index];
    [self layoutPhotoView];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectImage:(id)sender {
    [self.textView resignFirstResponder];
    if (self.arrSelectImage.count == MAXCOUNT) {
        [self.view makeToast:@"最多可选6张"];
        return;
    }
    __weak typeof(self)WeakSelf = self;
    if (self.dialogview == nil) {
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
//                    KKLog(@"点击相册");
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
}

- (IBAction)firButtonClicked:(id)sender {
    [_buttonFir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonSec setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonTir setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonFor setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonFif setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    _evlauateCount = 1;
}

- (IBAction)secButtonClicked:(id)sender {
    [_buttonFir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonSec setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonTir setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonFor setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonFif setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    _evlauateCount = 2;
}

- (IBAction)tirButtonClicked:(id)sender {
    [_buttonFir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonSec setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonTir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonFor setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    [_buttonFif setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    _evlauateCount = 3;
}

- (IBAction)fouthButtonClicked:(id)sender {
    [_buttonFir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonSec setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonTir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonFor setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonFif setImage:[UIImage imageNamed:@"我的订单_未选中"] forState:UIControlStateNormal];
    _evlauateCount = 4;
}

- (IBAction)fifButtonClicked:(id)sender {
    [_buttonFir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonSec setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonTir setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonFor setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    [_buttonFif setImage:[UIImage imageNamed:@"我的订单_选中"] forState:UIControlStateNormal];
    _evlauateCount = 5;
}

#pragma mark - 提交点评接口

- (IBAction)supplyCommit:(id)sender {
    //判断条件填充
    if (_evlauateCount == 0) {
        [self.view makeToast:@"请对订单评分" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (_textView.text.length == 0 || [CommonUtil isEmpty:_textView.text]) {
        [self.view makeToast:@"评论内容不能为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (self.arrSelectImage.count) {
        for (int i=0; i<self.arrSelectImage.count; i++) {
            [self uploadPictureWithImageData:self.arrSelectImage[i]];
        }
    }
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

//先将image裁剪压缩 然后传入服务器 获得urls
- (void)saveImage:(UIImage *)image
{
    //png格式压缩后存入当前图片
    UIImage *compressImg = [self imageCompressForWidth:image];
    [self.arrSelectImage addObject:compressImg];
    //添加视图之后重新布局
    [self layoutPhotoView];
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
        _contentViewWidthConstant.constant = kScreenWidth;
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
             _viewImageContentWidth.constant = maxX;
         } else {
             _viewImageContentWidth.constant = kScreenWidth;
         }
    }
}

- (NSInteger)baseTag{
    return 15;
}

#pragma mark - Request

- (void)uploadPictureWithImageData:(UIImage *)imagePic{
    
    /*
     {"upload":"file对象","city_id":"110900","access_token":"NgDXJv3Ua9Op88l+rHjYaTlLzyq7zGDTpPPAfax4zHNhAMs/u8xz1q7y1ny3eNp6b1+ELqjCNN/6988uqnqRKn4UxHv7lWfQrKPPL68twi15FsM=","client_guid":"979722892","client_timestamp":1486728688687,"app_id":"10013","client_version":"1.0.0","app_usign":"/lWlbjUeoBZwIlZiANp9FkMA/kc="
     */
    //    "client_guid":"979722892"
    //    刘伟  12:38:06601986
    //    "app_id":"10013","client_version":"1.0.0"
    UIImage *compressImg = [self imageCompressForWidth:imagePic];
    NSData *imgData = UIImageJPEGRepresentation(compressImg, 0.75);
    __weak typeof(self) weakSelf = self;
    [UploadPicRequest requestWithParameters:nil
                          withIndicatorView:self.view
                          withCancelSubject:[UploadPicRequest getDefaultRequstName]
                  constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
                     // NSLog(@"")
                      [formData appendPartWithFileData:imgData name:@"upload" fileName:@"filenames.jpg" mimeType:@"image/jpeg"];
                  }
                             onRequestStart:nil
                          onRequestFinished:^(CIWBaseDataRequest *request) {
                              NSLog(@"****==%@",request.resultDic);
                              if ([request.errCode isEqualToString:RESPONSE_OK]) {
                                  ImgModel *img = [[ImgModel alloc]initWithDataDic:[request.resultDic objectForKey:@"data"]];
                                  [weakSelf.arrImgUrl addObject:img.imgUrl];
                                  _countImage++;
                                  if (_countImage == weakSelf.arrSelectImage.count) {
                                      if (_arrImgUrl.count == weakSelf.arrSelectImage.count) {
                                          //如果图片上传成功 进入订单点评接口
                                          NSLog(@"%@",_type);
                                          if([_type isEqualToString:@"1"]){
                                              [self supplyCommitRequest];
                                          }else if ([_type isEqualToString:@"2"]){
                                              [self reBuildOrder];
                                          }

                                          [_arrImgUrl removeAllObjects];
                                          _countImage = 0;
                                      } else {
                                          [self.view makeToast:@"上传图片出错" duration:1 position:CSToastPositionCenter];
                                          [_arrImgUrl removeAllObjects];
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

- (void)supplyCommitRequest{
    NSDictionary *param;
    if (_arrImgUrl.count == 0) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"rr_content",_orderModel.orderId,@"order_id",[NSString stringWithFormat:@"%d",_evlauateCount],@"score",_orderModel.store.storeId,@"store_id",_orderModel.orderPrice,@"money",DATA_ENV.userInfo.user.uid,@"uid",DATA_ENV.userInfo.user.phone,@"phone",@"8",@"type",_orderModel.cateId,@"cate_id", nil];
    } else {
        param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"rr_content",_arrImgUrl,@"rr_imgs",_orderModel.orderId,@"order_id",[NSString stringWithFormat:@"%d",_evlauateCount],@"score",_orderModel.store.storeId,@"store_id",_orderModel.orderPrice,@"money",DATA_ENV.userInfo.user.uid,@"uid",DATA_ENV.userInfo.user.phone,@"phone",@"8",@"type",_orderModel.cateId,@"cate_id", nil];
    }
   
    [EvaluateOrderRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[EvaluateOrderRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"提交成功" duration:1 position:CSToastPositionCenter];
        } else {
            [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
    }];
}
#pragma mark 修改订单
-(void)reBuildOrder{
    NSDictionary *param;
    if (_arrImgUrl.count == 0) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"rr_content",_remarkID,@"remark_id",[NSString stringWithFormat:@"%ld",_evlauateCount],@"score",DATA_ENV.userInfo.user.phone,@"phone", nil];
    } else {
        param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"rr_content",_arrImgUrl,@"rr_imgs",_remarkID,@"remark_id",[NSString stringWithFormat:@"%ld",_evlauateCount],@"score",DATA_ENV.userInfo.user.phone,@"phone", nil];
    }
     NSLog(@"********==%@", param);
    
    [EvaluateOrderUpdateRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[EvaluateOrderUpdateRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[MyOrderViewController class]]) {
                    [self.view makeToast:@"提交成功" duration:1 position:CSToastPositionCenter];
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
                
            }
        } else {
            [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

@end
