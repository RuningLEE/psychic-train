//
//  InvitationDetailViewController.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitaionDetailModel.h"
#import "InvitationQrModel.h"

@interface InvitationDetailViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *arrDetailModel;
@property (strong, nonatomic) InvitationQrModel *qrModel;
@end
