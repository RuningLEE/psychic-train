//
//  ITTTableFooterDragLoadingMoreCell.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 3/23/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTTableFooterDragLoadingMoreCell.h"
#import "CIWXibViewUtils.h"

@implementation ITTTableFooterDragLoadingMoreCell

+ (id)cellWithXib{
    return [CIWXibViewUtils loadViewFromXibNamed:@"ITTTableFooterDragLoadingMoreCell"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _state = ITTTableFooterDragLoadingMoreNormal;
    }
    return self;
}
- (void)dealloc {
    _delegate = nil;
}

- (void)setState:(ITTTableFooterDragLoadingMoreState)aState{	
	switch (aState) {
		case ITTTableFooterDragLoadingMorePulling:{
            _indicatorView.alpha = 0;
			_messageLbl.text = @"松开即可加载更多...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:0.3];
			_arrowImageView.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
        }
		case ITTTableFooterDragLoadingMoreNormal:{
			if (_state == ITTTableFooterDragLoadingMorePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:0.3];
				_arrowImageView.layer.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_messageLbl.text = @"上拉加载更多…";
			[_indicatorView stopAnimating];
            _indicatorView.alpha = 0;
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImageView.alpha = 1;
			_arrowImageView.layer.transform = CATransform3DIdentity;
			[CATransaction commit];
                
			break;
        }
		case ITTTableFooterDragLoadingMoreLoading:{
			_messageLbl.text = @"加载中...";
            _indicatorView.alpha = 1;
			[_indicatorView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImageView.alpha = 0;
			[CATransaction commit];
			
			break;
        }
		default:
			break;
	}
	
	_state = aState;
}
#pragma mark - ScrollView Methods
- (BOOL)canLoadMore{
    
	BOOL canLoadMore = NO;
    
	if (_delegate) {
		canLoadMore = [_delegate tableHeaderFooterDragViewCanLoadMore:self];
	}
    return canLoadMore;
}
- (void)onScrollViewDidScroll:(UIScrollView *)scrollView {	
    if (![self canLoadMore]) {
        return;
    }
    if (_state != ITTTableFooterDragLoadingMoreLoading) {
        CGFloat currentBottomY = scrollView.contentOffset.y + scrollView.bounds.size.height;
        if (currentBottomY > scrollView.contentSize.height + 20) {
            //is pulling
            [self setState:ITTTableFooterDragLoadingMorePulling];
        }else {
            [self setState:ITTTableFooterDragLoadingMoreNormal];
        }
    }
    
}

- (void)onScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (![self canLoadMore]) {
        return;
    }
    
	BOOL isloading = NO;
	if (_delegate) {
		isloading = [_delegate tableHeaderFooterDragViewDataSourceIsLoading:self];
	}
    
    if (isloading) {
        return;
    }
    if (_state == ITTTableFooterDragLoadingMorePulling) {
		if (_delegate) {
            [self setState:ITTTableFooterDragLoadingMoreLoading];
			[_delegate tableHeaderFooterDragLoadingMoreActionTriggered:self];
		}
    }
	
}

- (void)onScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[self setState:ITTTableFooterDragLoadingMoreNormal];
}


@end
