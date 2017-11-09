//
//  WaterWareView.m
//  ios 动画
//
//  Created by JOHN on 16/4/22.
//  Copyright © 2016年 JOHN. All rights reserved.
//

#import "WaterWareView.h"
#define height

@interface WaterWareView()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) UIColor *firstWaveColor;

@end

@implementation WaterWareView
{
    CGFloat waveA;//水纹振幅
    CGFloat waveW ;//水纹周期
    CGFloat currentK; //当前波浪高度Y
    CGFloat waveSpeed;//水纹速度
    CGFloat waterWaveWidth; //水纹宽度
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds  = YES;
    [self setUp];
}

-(void)setUp
{
    //设置波浪的宽度
    waterWaveWidth = kScreenWidth;
    //设置波浪的颜色
    _firstWaveColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    //设置波浪的速度
    waveSpeed = 0.1/M_PI;
    
    //初始化layer
    if (_firstWaveLayer == nil) {
        //初始化
        _firstWaveLayer = [CAShapeLayer layer];
        //设置闭环的颜色
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        //设置边缘线的颜色
        _firstWaveLayer.strokeColor = _firstWaveColor.CGColor;
        //设置边缘线的宽度
        _firstWaveLayer.lineWidth = 1.0;
        _firstWaveLayer.strokeStart = 0.0;
        _firstWaveLayer.strokeEnd = 0.8;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    //设置波浪流动速度
    waveSpeed = 0.05;
    //设置振幅
    waveA = 5;
    //设置周期
    waveW = 1/35.0;
    //设置波浪纵向位置
    currentK = 8;//屏幕居中
    //启动定时器
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    //实时的位移
    _offsetX += waveSpeed;
    [self setCurrentFirstWaveLayerPath];
}

-(void)setCurrentFirstWaveLayerPath
{
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    for (NSInteger x = 0.0f; x<=waterWaveWidth; x++) {
        //正玄波浪公式
        y = waveA * sin(waveW * x+ _offsetX)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, waterWaveWidth, 25);
    CGPathAddLineToPoint(path, nil, 0, 25);
    CGPathCloseSubpath(path);
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)dealloc
{
    [_waveDisplaylink invalidate];
}

@end
