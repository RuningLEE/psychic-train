//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ITTTableHeaderRefreshView.h"
#import "NSDate+CIWAdditions.h"
#import <AudioToolbox/AudioToolbox.h>

#define TEXT_COLOR	 [UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0f]
#define FLIP_ANIMATION_DURATION 0.18f
#define ITTRefreshTableHeaderViewContentHeight 60.0f
#define ITTRefreshTableHeaderViewBackToNormalContentOffSetY -65

@interface ITTTableHeaderRefreshView ()
- (void)setState:(ITTTableHeaderPullRefreshState)aState;
- (void)audioPlay:(NSString*)audioFile;
@end

@implementation ITTTableHeaderRefreshView

#pragma mark - private methods
- (void)audioPlay:(NSString*)audioFile {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], audioFile];
    SystemSoundID soundId;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundId);
    AudioServicesPlaySystemSound(soundId);
}

#pragma mark - lifecycle methods

- (void)dealloc {
	
	_delegate=nil;

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		_lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor = TEXT_COLOR;
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		_lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_lastUpdatedLabel];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont systemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
		_arrowImageLayer = [CALayer layer];
		_arrowImageLayer.frame = CGRectMake(25.0f, frame.size.height - 55.0f, 30.0f, 45.0f);
		_arrowImageLayer.contentsGravity = kCAGravityResizeAspect;
		_arrowImageLayer.contents = (id)[UIImage imageNamed:@"loading_arrow_down.png"].CGImage;
		
		[[self layer] addSublayer:_arrowImageLayer];
        
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(25.0f, frame.size.height - 35.0f, 20.0f, 20.0f);
		_activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self addSubview:_activityView];
		
    }
	
    return self;
	
}


#pragma mark - public methods

- (void)refreshLastUpdatedDate {
	if (_delegate) {
        
		NSDate *date = [_delegate tableHeaderRefreshViewDataSourceLastUpdated:self];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
	} else {
		_lastUpdatedLabel.text = nil;
	}

}

- (void)setState:(ITTTableHeaderPullRefreshState)aState{
	_lastUpdatedLabel.hidden = NO;
    
	_activityView.frame = CGRectMake(25.0f, self.frame.size.height - 35.0f, 20.0f, 20.0f);//CGRectMake(25.0f, 337.0f, 20.0f, 20.0f);
	
	switch (aState) {
		case ITTTableHeaderPullRefreshPulling:{
			_statusLabel.text = @"松开即可刷新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImageLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
        }
		case ITTTableHeaderPullRefreshNormal:{
			if (_state == ITTTableHeaderPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImageLayer.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = @"下拉可以刷新…";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImageLayer.hidden = NO;
			_arrowImageLayer.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
        }
		case ITTTableHeaderPullRefreshLoading:{
			_statusLabel.text = @"加载中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImageLayer.hidden = YES;
			[CATransaction commit];
			
			break;
        }
		default:
			break;
	}
	
	_state = aState;
}

- (void)onFirstLoadingStarted:(UIScrollView*)scrollView{
    [self setState:ITTTableHeaderPullRefreshLoading];
    
    scrollView.contentInset = UIEdgeInsetsMake(ITTRefreshTableHeaderViewContentHeight, 0.0f, 0.0f, 0.0f);
    scrollView.contentOffset = CGPointMake(0.0f, -ITTRefreshTableHeaderViewContentHeight);
}

#pragma mark - ScrollView Methods
- (void)onScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == ITTTableHeaderPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, ITTRefreshTableHeaderViewContentHeight);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	}else if (scrollView.isDragging) {
		
		BOOL isloading = NO;
		if (_delegate ) {
			isloading = [_delegate tableHeaderRefreshViewDataSourceIsLoading:self];
		}
		CGFloat backToNormalContentOffSetY = ITTRefreshTableHeaderViewBackToNormalContentOffSetY;
		if (_state == ITTTableHeaderPullRefreshPulling && scrollView.contentOffset.y > backToNormalContentOffSetY && scrollView.contentOffset.y < 0.0f && !isloading) {
			[self setState:ITTTableHeaderPullRefreshNormal];
            [self audioPlay:@"up.wav"];
		} else if (_state ==ITTTableHeaderPullRefreshNormal && scrollView.contentOffset.y < backToNormalContentOffSetY && !isloading) {
			[self setState:ITTTableHeaderPullRefreshPulling];
            [self audioPlay:@"down.wav"];
		}
		
		if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
		}
	}else{
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);	
    }
}

- (void)onScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL isloading = NO;
	if (_delegate) {
		isloading = [_delegate tableHeaderRefreshViewDataSourceIsLoading:self];
	}
    
    CGFloat backToNormalContentOffSetY = ITTRefreshTableHeaderViewBackToNormalContentOffSetY;
	if (scrollView.contentOffset.y <= backToNormalContentOffSetY && !isloading) {
		
		if (_delegate) {
			[_delegate tableHeaderRefreshViewDidTriggerRefresh:self];
		}
		
		[self setState:ITTTableHeaderPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        [self audioPlay:@"end.wav"];
	}
	
}

- (void)onScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:ITTTableHeaderPullRefreshNormal];
}

@end
