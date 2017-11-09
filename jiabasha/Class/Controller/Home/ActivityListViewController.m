//
//  ActivityListViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/8.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ConmmonUnSubscibeTableViewCell.h"
#import "GetRenovationTopicRequest.h"
#import "RenovationTopic.h"
#import "WebViewController.h"

@interface ActivityListViewController () {
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic, strong) NSArray *topicList;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册tableViewCell
    [_tableView registerNib:[UINib nibWithNibName:@"ConmmonUnSubscibeTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"ConmmonUnSubscibeTableViewCell"];
    
    [self getTopicList];
}

- (void)getTopicList {
    __weak typeof(self) weakSelf = self;
    [GetRenovationTopicRequest requestWithParameters:@{@"type":@"ACTIVITY", @"product":@"0"}
                                       withCacheType:DataCacheManagerCacheTypeMemory
                                   withIndicatorView:self.view
                                   withCancelSubject:[GetRenovationTopicRequest getDefaultRequstName]
                                      onRequestStart:nil
                                   onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                           
                                           weakSelf.topicList = [request.resultDic objectForKey:@"topic"];
                                           
                                           [_tableView reloadData];
                                       }
                                   }
                                   onRequestCanceled:^(CIWBaseDataRequest *request) {
                                   }
                                     onRequestFailed:^(CIWBaseDataRequest *request) {
                                     }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenWidth - 20)*310/710 + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConmmonUnSubscibeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConmmonUnSubscibeTableViewCell"];
    RenovationTopic *topic = [self.topicList objectAtIndex:indexPath.row];
    
    [cell.imageCover sd_setImageWithURL:[NSURL URLWithString:topic.topicPicUrl] placeholderImage:[UIImage imageNamed:@"长方形"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RenovationTopic *topic = [self.topicList objectAtIndex:indexPath.row];
    
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = topic.topicUrl;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
