//  ITTRefreshTableHeaderView
//  Modified from EGORefreshTableHeaderView.h by Jack
//
//  Thanks to Devin Doty 
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	ITTTableHeaderPullRefreshPulling = 0,
	ITTTableHeaderPullRefreshNormal,
	ITTTableHeaderPullRefreshLoading
} ITTTableHeaderPullRefreshState;

@protocol ITTTableHeaderRefreshViewDelegate;

@interface ITTTableHeaderRefreshView : UIView {
	ITTTableHeaderPullRefreshState _state;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImageLayer;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <ITTTableHeaderRefreshViewDelegate> delegate;

- (void)setState:(ITTTableHeaderPullRefreshState)aState;
- (void)refreshLastUpdatedDate;
- (void)onScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)onScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)onScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)onFirstLoadingStarted:(UIScrollView*)scrollView;
@end
@protocol ITTTableHeaderRefreshViewDelegate
- (void)tableHeaderRefreshViewDidTriggerRefresh:(ITTTableHeaderRefreshView*)view;
- (BOOL)tableHeaderRefreshViewDataSourceIsLoading:(ITTTableHeaderRefreshView*)view;
@optional
- (NSDate*)tableHeaderRefreshViewDataSourceLastUpdated:(ITTTableHeaderRefreshView*)view;
@end
