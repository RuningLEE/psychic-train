//
//  ITTTableFooterDragLoadingMoreCell.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/23/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	ITTTableFooterDragLoadingMorePulling = 0,
	ITTTableFooterDragLoadingMoreNormal,
	ITTTableFooterDragLoadingMoreLoading
} ITTTableFooterDragLoadingMoreState;

@protocol ITTTableFooterDragLoadingMoreCellDelegate;

@interface ITTTableFooterDragLoadingMoreCell : UITableViewCell{
    ITTTableFooterDragLoadingMoreState _state;
}

@property(nonatomic,assign) id <ITTTableFooterDragLoadingMoreCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (retain, nonatomic) IBOutlet UILabel *messageLbl;
+ (id)cellWithXib;

- (void)onScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)onScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)onScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end


@protocol ITTTableFooterDragLoadingMoreCellDelegate
- (void)tableHeaderFooterDragLoadingMoreActionTriggered:(ITTTableFooterDragLoadingMoreCell*)view;
- (BOOL)tableHeaderFooterDragViewDataSourceIsLoading:(ITTTableFooterDragLoadingMoreCell*)view;
- (BOOL)tableHeaderFooterDragViewCanLoadMore:(ITTTableFooterDragLoadingMoreCell*)view;
@end
