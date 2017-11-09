//
//  SearchViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "SearchViewController.h"
#import "PlaceholderColorTextField.h"
#import "FindMoreRequest.h"
#import "SearchStoreRequest.h"
#import "SearchProductRequest.h"
#import "SearchExampleRequest.h"
#import "FindMore.h"
#import "Store.h"
#import "Product.h"
#import "Example.h"
#import "MJRefresh.h"

#import "StoreTableViewCell.h"
#import "HomeExampleTableViewCell.h"
#import "ProductTableViewCell.h"
#import "UIColor-Expanded.h"

#import "GroupProductDetailViewController.h"
#import "RenovationShopDetialViewController.h"
#import "RenovationCompanyHomeViewController.h"
#import "CaseHomeViewController.h"


#import "UIView+GrowingAttributes.h"
#import "Growing.h"
//发现记录保存key
#define RECORD_KEY @"find_record_key"
@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet PlaceholderColorTextField *_textFieldKeyword;
    __weak IBOutlet UIView *_viewRecord;
    __weak IBOutlet UIView *_viewRecordContent;
    __weak IBOutlet NSLayoutConstraint *_heightForRecord;
    
    __weak IBOutlet UIView *_viewFind;
    __weak IBOutlet UIView *_viewFindContent;
    __weak IBOutlet NSLayoutConstraint *_heightForFind;
    
    __weak IBOutlet NSLayoutConstraint *_topForFind;
    __weak IBOutlet NSLayoutConstraint *_topToRecord;
    
    //全部暂无结果
    __weak IBOutlet UIImageView *_imgViewNoData;
    __weak IBOutlet NSLayoutConstraint *_topFindToSuper;
    __weak IBOutlet NSLayoutConstraint *_topFindToImg;
    
    __weak IBOutlet UIView *_viewResult;
    //标题
    __weak IBOutlet UIButton *_btnStore;// 公司
    __weak IBOutlet UIButton *_btnExample;// 案例
    __weak IBOutlet UIButton *_btnProduct;// 商品
    
    //下划线
    __weak IBOutlet UIView *_viewUnderLine;
    
    //没有数据
    __weak IBOutlet UIImageView *_imgViewNoResult;
    __weak IBOutlet UITableView *_tableViewStore;
    __weak IBOutlet UITableView *_tableViewEx;
    __weak IBOutlet UITableView *_tableViewPro;
}

//数据源
@property (nonatomic, strong) NSMutableArray *storeList;
@property (nonatomic, strong) NSMutableArray *exampleList;
@property (nonatomic, strong) NSMutableArray *productList;

//页数 翻页用
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic) NSInteger pageStore;
@property (nonatomic) NSInteger pageExample;
@property (nonatomic) NSInteger pageProduct;

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated{
    _textFieldKeyword.growingAttributesUniqueTag=@"search_ios";
    _textFieldKeyword.growingAttributesDonotTrackValue = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.storeList = [NSMutableArray array];
    self.exampleList = [NSMutableArray array];
    self.productList = [NSMutableArray array];

    _viewResult.hidden = YES;
    
    //历史记录
    NSArray *records = [USER_DEFAULT arrayForKey:RECORD_KEY];
    [self showFindRecord:records];
    
    //发现更多
    _viewFind.hidden = YES;
    [self findMore];
    
    //注册tableViewCell
    [_tableViewStore registerNib:[UINib nibWithNibName:@"StoreTableViewCell" bundle:nil]
          forCellReuseIdentifier:@"StoreTableViewCell"];
    [_tableViewEx registerNib:[UINib nibWithNibName:@"HomeExampleTableViewCell" bundle:nil]
       forCellReuseIdentifier:@"HomeExampleTableViewCell"];
    [_tableViewPro registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil]
          forCellReuseIdentifier:@"ProductTableViewCell"];
    
    //商品的TableView增加20px的表头
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    viewHead.backgroundColor = [UIColor whiteColor];
    _tableViewPro.tableHeaderView = viewHead;
    
    //加载更多
    __weak typeof(self) weakSelf = self;
    _tableViewStore.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachStore:weakSelf.keyword Page:weakSelf.pageStore + 1];
    }];
    _tableViewEx.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachExample:weakSelf.keyword Page:weakSelf.pageExample + 1];
    }];
    _tableViewPro.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachProduct:weakSelf.keyword Page:weakSelf.pageProduct + 1];
    }];
    
//    [_tableViewStore.mj_footer endRefreshingWithNoMoreData];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
//取消
- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//删除历史记录
- (IBAction)deleteRecordClicked:(id)sender {
    [USER_DEFAULT removeObjectForKey:RECORD_KEY];
    [USER_DEFAULT synchronize];
    
    _viewRecord.hidden = YES;
    _topForFind.priority = UILayoutPriorityDefaultHigh;
    _topToRecord.priority = UILayoutPriorityDefaultLow;
}

//历史记录 点击事件
- (void)findRecordClick:(UIButton *)button {
    _textFieldKeyword.text = button.currentTitle;
    [self seachByKeyword:button.currentTitle];
}

//公司 案例 商品 点击事件
- (IBAction)classClicked:(UIButton *)button {
    if (button.isSelected) {
        return;
    }
    
    NSArray *array = @[_btnStore, _btnProduct, _btnExample];
    for (UIButton *btn in array) {
        if (btn == button) {
            [btn setSelected:YES];
        } else {
            [btn setSelected:NO];
        }
    }
    
    [self showSelectedResult];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //特殊字符限制
    NSString *special = @"~￥#&*<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣（）——+|$_€¥";
    if ([string rangeOfString:special].location != NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //检索
    NSString *keyword = textField.text;
    //if ([CommonUtil isNotEmpty:keyword]) {
        [textField resignFirstResponder];
        [self seachByKeyword:keyword];
    //}
    
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableViewStore) {
        return self.storeList.count;
    } else if (tableView == _tableViewEx) {
        //增加灰色行
        if (self.exampleList.count == 0) {
            return 0;
        } else {
//            NSUInteger spacerow = (int)(self.exampleList.count - 1) / 2;
            return self.exampleList.count * 2 - 1;
        }
    } else if (tableView == _tableViewPro) {
        return (self.productList.count + 1) / 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewStore) {
        return 90;
    } else if (tableView == _tableViewEx) {
        if (indexPath.row % 2 == 0) {
            return [HomeExampleTableViewCell getNormalHeight];
        }
    } else if (tableView == _tableViewPro) {
        
        NSInteger row = indexPath.row * 2;
        Product *product = [self.productList objectAtIndex:row];
        NSMutableArray *array = [@[product.productName] mutableCopy];
        if (row + 1 < self.productList.count) {
            Product *product = [self.productList objectAtIndex:row + 1];
            [array addObject:product.productName];
        }
        
        return [ProductTableViewCell getHeightForDevice:array];
    }
    
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableViewStore) {
        StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreTableViewCell"];
        
        Store *store = [self.storeList objectAtIndex:indexPath.row];
        [cell.imgViewLogo sd_setImageWithURL:[NSURL URLWithString:store.logo] placeholderImage:[UIImage imageNamed:@"正小"]];
        cell.labelName.text = store.storeName;
//        cell.labelReser.text = store.orderNum;  //预约数
//        cell.labelOrder.text = store.dpCount;   //订单数
        
        NSString * commmentNum = [NSString stringWithFormat:@"%@预约｜%@订单｜%@点评", store.orderNum,store.dpOrder,store.dpCount];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:commmentNum];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(0,store.orderNum.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(store.orderNum.length,3)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(store.orderNum.length+3,store.dpOrder.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(store.orderNum.length+3 +store.dpOrder.length,3)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(store.orderNum.length+3 +store.dpOrder.length+3,store.dpCount.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(commmentNum.length -2,2)];
        cell.labelOrderInfo.attributedText = attrString;
        
        //"verifyBrand": 1, //1品牌认证 0无认证
        //"verifyCash": 1, //1有返现 0无返现
        //"cashCount" : 2, //优惠券数量
        CGFloat _left = 10;
        //券
        if ([store.cashCount integerValue] > 0) {
            cell.imgViewCert.hidden = NO;
            _left += 20;
        } else {
            cell.imgViewCert.hidden = YES;
        }
        //返
        if ([store.verifyCash integerValue] == 1) {
            cell.imgViewReturn.hidden = NO;
            cell.leftForReturn.constant = _left;
            _left += 20;
        } else {
            cell.imgViewReturn.hidden = YES;
        }
        //证
        if ([store.verifyBrand integerValue] == 1) {
            cell.imgViewCard.hidden = NO;
            cell.leftForCard.constant = _left;
        } else {
            cell.imgViewCard.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    } else if (tableView == _tableViewEx && indexPath.row % 2 == 0) {
        
        
        NSLog(@"cell = %ld -- %ld", indexPath.row, indexPath.row /2);
        
        HomeExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeExampleTableViewCell"];

        cell.viewHead.hidden = YES;
        cell.heightForHead.constant = 0.0;
        cell.controlMore.hidden = YES;
        cell.controlEx.hidden = YES;
        
        Example *example = [self.exampleList objectAtIndex:indexPath.row / 2];
        [cell.imgViewPic sd_setImageWithURL:[NSURL URLWithString:example.showImgUrl] placeholderImage:[UIImage imageNamed:@"长方形"]];
        [cell.imgViewLogo sd_setImageWithURL:[NSURL URLWithString:example.store.logo] placeholderImage:[UIImage imageNamed:@"正小"]];
        if (example.albumName) {
            cell.labelExName.text = example.albumName;
        } else {
            cell.labelExName.text = @"";
        }
        
        if (example.store && example.store.storeName) {
            cell.labelStoreName.text = example.store.storeName;
        } else {
            cell.labelStoreName.text = @"";
        }
        
        if (example.albumText) {
            cell.labelText.text = example.albumText;
        } else {
            cell.labelText.text = @"";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    } else if (tableView == _tableViewPro) {
        
        ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductTableViewCell"];
        
        NSInteger row = indexPath.row * 2;
        
        //第一条
        Product *product = [self.productList objectAtIndex:row];
        
        [cell.imgViewPic sd_setImageWithURL:[NSURL URLWithString:product.productPicUrl] placeholderImage:[UIImage imageNamed:@"正中"]];
        cell.labelName.text = product.productName;
        if ([CommonUtil isEmpty:product.mallPrice]) {
            cell.labelPrice.text = @"面议";
        } else {
            cell.labelPrice.text = [NSString stringWithFormat:@"￥%@", product.mallPrice];
        }

        if ([CommonUtil isEmpty:product.price]) {
            cell.labelOriginal.text = @"";
        } else {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", product.price]
                                                                          attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
                                                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                        NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
            
            cell.labelOriginal.attributedText = attrStr;
        }

        cell.controlPro.tag = row;
        [cell.controlPro addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([product.huiyuanjie boolValue] == YES) {
            cell.viewMark.hidden = NO;
        } else {
            cell.viewMark.hidden = YES;
        }
        
        //第二条
        if (row + 1 < self.productList.count) {
            cell.controlPro1.hidden = NO;
            
            Product *product = [self.productList objectAtIndex:row + 1];
            
            [cell.imgViewPic1 sd_setImageWithURL:[NSURL URLWithString:product.productPicUrl] placeholderImage:[UIImage imageNamed:@"正中"]];
            cell.labelName1.text = product.productName;

            if ([CommonUtil isEmpty:product.mallPrice]) {
                cell.labelPrice1.text = @"面议";
            } else {
                cell.labelPrice1.text = [NSString stringWithFormat:@"￥%@", product.mallPrice];
            }
            
            if ([CommonUtil isEmpty:product.price]) {
                cell.labelOriginal1.text = @"";
            } else {
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", product.price]
                                                                              attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
                                                                                            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                                                                                            NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                            NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
                
                cell.labelOriginal1.attributedText = attrStr;
            }
            
            cell.controlPro1.tag = row + 1;
            [cell.controlPro1 addTarget:self action:@selector(productClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([product.huiyuanjie boolValue] == YES) {
                cell.viewMark1.hidden = NO;
            } else {
                cell.viewMark1.hidden = YES;
            }
            
        } else {
            cell.controlPro1.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"SpaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = RGBFromHexColor(0xf4f4f4);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _tableViewStore) {
        
        //公司点击 去公司详细画面
        Store *store = [self.storeList objectAtIndex:indexPath.row];
        
        RenovationCompanyHomeViewController *view = [[RenovationCompanyHomeViewController alloc] init];
        view.storeId = store.storeId;
        [self.navigationController pushViewController:view animated:YES];
        
    } else if (tableView == _tableViewEx && indexPath.row % 2 == 0) {
        
        NSLog(@"%ld -- %ld", indexPath.row, indexPath.row /2);
        
        //案例点击 去案例详细画面
        Example *example = [self.exampleList objectAtIndex:indexPath.row /2];
        CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
        view.albumId = example.albumId;
        [self.navigationController pushViewController:view animated:YES];
    }
}

// 商品信息点击 去商品详细画面
- (void)productClicked:(UIControl *)control {
    
    Product *product = [self.productList objectAtIndex:control.tag];
    
    //团
    if ([product.tuaning boolValue] == YES) {
        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
        viewControler.productId = product.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    } else {
        RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
        viewControler.productId = product.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    }
}

#pragma mark - private
//搜索框展开-发现更多
- (void)findMore {
    
    __weak typeof(self) weakSelf = self;
    [FindMoreRequest requestWithParameters:nil// 参数
                         withIndicatorView:self.view//网络加载视图加载到某个view
                            onRequestStart:^(CIWBaseDataRequest *request) {}
                         onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if([request.errCode isEqualToString:RESPONSE_OK]){
                                    NSArray *findmoreLst = [request.resultDic objectForKey:@"findmore"];
                                 
                                    if (findmoreLst.count > 0) {
                                        _viewFind.hidden = NO;
                                        
                                        CGFloat maxWidth = kScreenWidth - 20;
                                        CGFloat start_x = 0;
                                        
                                        int row = 0;
                                        
                                        for (int i = 0;i < findmoreLst.count;i++) {
                                            FindMore *more = [findmoreLst objectAtIndex:i];
                                            
                                            CGFloat _width = [more.contentTile getSizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 30.0;
                                            _width = MIN(_width, maxWidth);
                                            
                                            if (_width > maxWidth - start_x) {
                                                row++;
                                                start_x = 0;
                                            }
                                            
                                            UIButton *button = [weakSelf buttonForFindRecord];
                                            button.frame = CGRectMake(start_x, (36 + 12) * row, _width, 36);
                                            [button setTitle:more.contentTile forState:UIControlStateNormal];
                                            [_viewFindContent addSubview:button];
                                            
                                            [button addTarget:weakSelf action:@selector(findRecordClick:) forControlEvents:UIControlEventTouchUpInside];
                                            
                                            start_x = start_x + _width + 10;
                                        }
                                        
                                        _heightForFind.constant = (row + 1) * 48 - 12;
                                        
                                    }
                                }
                            }
     
                         onRequestCanceled:^(CIWBaseDataRequest *request) {}
                           onRequestFailed:^(CIWBaseDataRequest *request) {}];
}

//开始检索
- (void)seachByKeyword:(NSString *)keyword {
    if (keyword == nil) {
        return;
    }
    
    //设置tableview tag 来判断是否检索完成
    _tableViewStore.tag = 0;
    _tableViewEx.tag = 0;
    _tableViewPro.tag = 0;
    
    self.keyword = keyword;
    [self seachStore:keyword Page:0];
    [self seachProduct:keyword Page:0];
    [self seachExample:keyword Page:0];
    
    if ([CommonUtil isEmpty:keyword]) {
        return;
    }
    
    //历史记录保存
    NSMutableArray *records = [USER_DEFAULT mutableArrayValueForKey:RECORD_KEY];
    
    for (NSString *searchKey in records) {
        if ([searchKey isEqualToString:keyword]) {
            [records removeObject:searchKey];
            break;
        }
    }
    if (records == nil) {
        records = [NSMutableArray array];
    }
    [records insertObject:keyword atIndex:0];
    if (records.count > 20) {
        [records removeLastObject];
    }
    
    [self showFindRecord:records];

    [USER_DEFAULT setObject:records forKey:RECORD_KEY];
    [USER_DEFAULT synchronize];
}

//检索店铺
- (void)seachStore:(NSString *)keyword Page:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    [SearchStoreRequest requestWithParameters:@{@"keyword":keyword,@"cate_id":@"2083", @"page":[NSNumber numberWithInteger:page], @"sort_type":@"default_order", @"size":@20}
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:self.view
                            withCancelSubject:[SearchStoreRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                    weakSelf.pageStore = page;
                                    
                                    if (weakSelf.pageStore == 0) {
                                        weakSelf.storeList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"store"];
                                    if (array.count > 0) {
                                        [weakSelf.storeList addObjectsFromArray:array];
                                    }
                                    
                                    [_tableViewStore reloadData];
                                    
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    [_btnStore setTitle:[NSString stringWithFormat:@"公司(%ld)", total] forState:UIControlStateNormal];
                                    
                                    if (weakSelf.storeList.count >= total) {
                                        [_tableViewStore.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_tableViewStore.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_tableViewStore.mj_footer isRefreshing]) {
                                    [_tableViewStore.mj_footer endRefreshing];
                                }
                                _tableViewStore.tag = 1;
                                if (weakSelf.pageStore == 0) {
                                    [weakSelf displayResult];
                                }
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_tableViewStore.mj_footer isRefreshing]) {
                                    [_tableViewStore.mj_footer endRefreshing];
                                }
                                _tableViewStore.tag = 1;
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_tableViewStore.mj_footer isRefreshing]) {
                                      [_tableViewStore.mj_footer endRefreshing];
                                  }
                                  _tableViewStore.tag = 1;
                              }];
}

//检索商品
- (void)seachProduct:(NSString *)keyword Page:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    [SearchProductRequest requestWithParameters:@{@"keyword":keyword, @"cate_pid":@"2083", @"page":[NSNumber numberWithInteger:page], @"sort_type":@"default_order", @"size":@20}
                                  withCacheType:DataCacheManagerCacheTypeMemory
                              withIndicatorView:self.view
                              withCancelSubject:[SearchProductRequest getDefaultRequstName]
                                 onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                    weakSelf.pageProduct = page;
                                    
                                    if (weakSelf.pageProduct == 0) {
                                        weakSelf.productList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"product"];
                                    if (array.count > 0) {
                                        [weakSelf.productList addObjectsFromArray:array];
                                    }
                                    
                                    [_tableViewPro reloadData];
                                    
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    [_btnProduct setTitle:[NSString stringWithFormat:@"商品(%ld)", total] forState:UIControlStateNormal];
                                    _btnProduct.tag = total;
                                    
                                    if (weakSelf.productList.count >= total) {
                                        [_tableViewPro.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_tableViewPro.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_tableViewPro.mj_footer isRefreshing]) {
                                    [_tableViewPro.mj_footer endRefreshing];
                                }
                                _tableViewPro.tag = 1;
                                
                                if (weakSelf.pageProduct == 0) {
                                    [weakSelf displayResult];
                                }
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_tableViewPro.mj_footer isRefreshing]) {
                                    [_tableViewPro.mj_footer endRefreshing];
                                }
                                _tableViewPro.tag = 1;
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_tableViewPro.mj_footer isRefreshing]) {
                                      [_tableViewPro.mj_footer endRefreshing];
                                  }
                                  _tableViewPro.tag = 1;
                              }];
}

//检索案例
- (void)seachExample:(NSString *)keyword Page:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    [SearchExampleRequest requestWithParameters:@{@"keyword":keyword, @"page":[NSNumber numberWithInteger:page], @"sort_type":@"default_order", @"size":@20}
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:self.view
                            withCancelSubject:[SearchExampleRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                    weakSelf.pageExample = page;
                                    
                                    if (weakSelf.pageExample == 0) {
                                        weakSelf.exampleList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"example"];
                                    if (array.count > 0) {
                                        [weakSelf.exampleList addObjectsFromArray:array];
                                    }
                                    
                                    [_tableViewEx reloadData];
                                    
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    [_btnExample setTitle:[NSString stringWithFormat:@"案例(%ld)", total] forState:UIControlStateNormal];
                                    
                                    if (weakSelf.exampleList.count >= total) {
                                        [_tableViewEx.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_tableViewEx.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_tableViewEx.mj_footer isRefreshing]) {
                                    [_tableViewEx.mj_footer endRefreshing];
                                }
                                _tableViewEx.tag = 1;
                                
                                if (weakSelf.pageProduct == 0) {
                                    [weakSelf displayResult];
                                }
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_tableViewEx.mj_footer isRefreshing]) {
                                    [_tableViewEx.mj_footer endRefreshing];
                                }
                                _tableViewEx.tag = 1;
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_tableViewEx.mj_footer isRefreshing]) {
                                      [_tableViewEx.mj_footer endRefreshing];
                                  }
                                  _tableViewEx.tag = 1;
                              }];
}

//表示发现记录
- (void)showFindRecord:(NSArray *)records {
    //历史记录
    //NSArray *records = [USER_DEFAULT arrayForKey:RECORD_KEY];
    if (records.count > 0) {
        _viewRecord.hidden = NO;
        _topForFind.priority = UILayoutPriorityDefaultLow;
        _topToRecord.priority = UILayoutPriorityDefaultHigh;
        
        [_viewRecordContent removeAllSubviews];
        
        CGFloat maxWidth = kScreenWidth - 20;
        CGFloat start_x = 0;

        int row = 0;

        for (int i = 0;i<records.count;i++) {
            NSString *record = [records objectAtIndex:i];
            
            CGFloat _width = [record getSizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 30.0;
            _width = MIN(_width, maxWidth);
            
            if (_width > maxWidth - start_x) {
                
                row++;
                start_x = 0;
            }
            
            //最多5行
            if (row > 4) {
                break;
            }
            
            UIButton *button = [self buttonForFindRecord];
            button.frame = CGRectMake(start_x, (36 + 12) * row, _width, 36);
            [button setTitle:record forState:UIControlStateNormal];
            [_viewRecordContent addSubview:button];
            
            [button addTarget:self action:@selector(findRecordClick:) forControlEvents:UIControlEventTouchUpInside];
            
            start_x = start_x + _width + 10;
        }
        
        _heightForRecord.constant = MIN(row + 1, 5) * 48 - 12;
        
    } else {
        _viewRecord.hidden = YES;
        _topForFind.priority = UILayoutPriorityDefaultHigh;
        _topToRecord.priority = UILayoutPriorityDefaultLow;
    }
    _topFindToImg.priority = UILayoutPriorityDefaultLow;
}

- (UIButton *)buttonForFindRecord {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:RGBFromHexColor(0x333333) forState:UIControlStateNormal];
    [button setBackgroundColor:RGBFromHexColor(0xf4f4f4)];
    button.layer.cornerRadius = 2.0;
    button.layer.masksToBounds = YES;
    return button;
}

//检索结果判断显示记录
- (void)displayResult {
    if (_tableViewStore.tag == 0 || _tableViewPro.tag == 0 || _tableViewEx.tag == 0) {
        //检索中 退出
        return;
    }
    
    //全部无数据
    if (self.storeList.count == 0 && self.productList.count == 0 && self.exampleList.count == 0) {
        _imgViewNoData.hidden = NO;
        
        if (!_viewRecord.isHidden) {
            _viewRecord.hidden = YES;
        }
        
        _topFindToSuper.priority = UILayoutPriorityDefaultLow;
        _topFindToImg.priority = UILayoutPriorityDefaultHigh;
        
        _viewResult.hidden = YES;
    } else {
        _imgViewNoData.hidden = YES;
        _topFindToSuper.priority = UILayoutPriorityDefaultHigh;
        _topFindToImg.priority = UILayoutPriorityDefaultLow;
        
        _viewResult.hidden = NO;
        
        [self showSelectedResult];
    }
}

//显示结果画面
- (void)showSelectedResult {
    if (_btnStore.isSelected) {
        
        _tableViewEx.hidden = YES;
        _tableViewPro.hidden = YES;
        
        if (self.storeList.count > 0) {
            _tableViewStore.hidden = NO;
            _imgViewNoResult.hidden = YES;
        } else {
            _tableViewStore.hidden = YES;
            _imgViewNoResult.hidden = NO;
        }
        
        [UIView animateWithDuration:.3 animations:^(void) {
            [_viewUnderLine setX:_btnStore.x];
            [_viewUnderLine setWidth:_btnStore.width];
        }];
        
    } else if (_btnExample.isSelected) {
        
        _tableViewStore.hidden = YES;
        _tableViewPro.hidden = YES;
        
        if (self.exampleList.count > 0) {
            _tableViewEx.hidden = NO;
            _imgViewNoResult.hidden = YES;
        } else {
            _tableViewEx.hidden = YES;
            _imgViewNoResult.hidden = NO;
        }
        
        [UIView animateWithDuration:.3 animations:^(void) {
            [_viewUnderLine setX:_btnExample.x];
            [_viewUnderLine setWidth:_btnExample.width];
        }];
        
    } else if (_btnProduct.isSelected) {
        
        _tableViewEx.hidden = YES;
        _tableViewStore.hidden = YES;
        
        if (self.productList.count > 0) {
            _tableViewPro.hidden = NO;
            _imgViewNoResult.hidden = YES;
        } else {
            _tableViewPro.hidden = YES;
            _imgViewNoResult.hidden = NO;
        }
        
        [UIView animateWithDuration:.3 animations:^(void) {
            [_viewUnderLine setX:_btnProduct.x];
            [_viewUnderLine setWidth:_btnProduct.width];
        }];
    }
}

@end
