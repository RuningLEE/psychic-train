//
//  MessageView.h


#import <UIKit/UIKit.h>
#import "PoppingBaseView.h"
@interface MessageView : PoppingBaseView

//增加 根据 err 表示信息
+ (MessageView *)displayMessageByErr:(NSString *)err;

+ (MessageView *)displayMessage:(NSString *)message;
+ (MessageView *)displayMessage:(NSString *)message withView:(UIView *)disPlayView;
+ (MessageView *)displayMessage:(NSString *)message
                       withView:(UIView *)disPlayView
                 withAgterDelay:(NSTimeInterval)delay;

@end
