//
//  iGetInvitationInfoRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/21.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "iGetInvitationInfoRequest.h"
#import "InvitationQrModel.h"
#import "InvitaionDetailModel.h"

@implementation iGetInvitationInfoRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/invitation/detail";
}

- (void)processResult{
    if ([self.errCode isEqualToString:@"err.expo.notfound"]) {
       
    } else if([self.errCode isEqualToString:@"err.expo.ticket.notfound"]){
        
    } else {
        if ([[[[self.resultDic objectForKey:@"data"] objectForKey:@"type"] description] isEqualToString:@"3"]) {
            InvitationQrModel *qrModel = [[InvitationQrModel alloc]initWithDataDic:[self.resultDic objectForKey:@"data"]];
            [self.resultDic setValue:qrModel forKey:@"qrModel"];
        } else if ([[[[self.resultDic objectForKey:@"data"] objectForKey:@"type"] description] isEqualToString:@"2"]) {
            InvitationQrModel *qrModel = [[InvitationQrModel alloc]initWithDataDic:[self.resultDic objectForKey:@"data"]];
            [self.resultDic setValue:qrModel forKey:@"qrModel"];
            
            NSDictionary *detailDic = [[self.resultDic objectForKey:@"data"] objectForKey:@"detail"];
            InvitaionDetailModel *detailFir = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"1"]];
            InvitaionDetailModel *detailSec = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"2"]];
            InvitaionDetailModel *detailTir = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"3"]];
            
            NSArray *arrDetail = [NSArray arrayWithObjects:detailFir,detailSec,detailTir, nil];
            
            [self.resultDic setValue:arrDetail forKey:@"arrDetailModel"];
        } else if ([[[[self.resultDic objectForKey:@"data"] objectForKey:@"type"] description]isEqualToString:@"1"]) {
            InvitationQrModel *qrModel = [[InvitationQrModel alloc]initWithDataDic:[self.resultDic objectForKey:@"data"]];
            [self.resultDic setValue:qrModel forKey:@"qrModel"];
            
            NSDictionary *detailDic = [[self.resultDic objectForKey:@"data"] objectForKey:@"detail"];
            InvitaionDetailModel *detailFir = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"1"]];
            InvitaionDetailModel *detailSec = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"2"]];
            InvitaionDetailModel *detailTir = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"3"]];
            InvitaionDetailModel *detailFor = [[InvitaionDetailModel alloc]initWithDataDic:[detailDic objectForKey:@"4"]];
            
            NSArray *arrDetail = [NSArray arrayWithObjects:detailFir,detailSec,detailTir,detailFor, nil];
            
            [self.resultDic setValue:arrDetail forKey:@"arrDetailModel"];
        }
    }
}
@end
