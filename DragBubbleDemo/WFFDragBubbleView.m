//
//  WFFDragBubbleView.m
//  QQBubble
//
//  Created by wufeifan on 2017/2/8.
//  Copyright © 2017年 wufeifan. All rights reserved.
//

#import "WFFDragBubbleView.h"

@interface WFFDragBubbleView()

@property (nonatomic, assign) BOOL isOutRange;

@property (nonatomic, assign) BOOL isDismiss;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) UIPanGestureRecognizer *panGR;

@property (nonatomic, assign) CGPoint touchPoint;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;// 连接段

@property (nonatomic, strong) CAShapeLayer *subShapeLayer;// 两个圆

@end

@implementation WFFDragBubbleView

#pragma mark - Override
//- (instancetype)init
//{
//    if (self = [super init]) {
//        [self defaultConfig];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self defaultConfig];
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self updateLayer];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview) {
        [self addGR];
        [self defaultInit];
        self.touchPoint = [self circlePoint];
    } else {
        [self removeGR];
        [self removeLayer];
    }
}
#pragma mark End

#pragma mark - Public
- (void)restore
{
    self.touchPoint = [self circlePoint];
    self.isAnimating = NO;
    self.isDismiss = NO;
    self.isOutRange = NO;
    [self setNeedsDisplay];
}
#pragma mark End

#pragma mark - Private
- (void)addGR
{
    if (!self.panGR) {
        self.panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAction:)];
    }
    
    [self addGestureRecognizer:self.panGR];
}

- (void)removeGR
{
    if ([self.gestureRecognizers containsObject:self.panGR]) {
        [self.panGR removeTarget:self action:@selector(panGRAction:)];
    }
}

- (void)createLayer
{
    if (!self.shapeLayer) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.shapeLayer.fillColor = [UIColor redColor].CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, self.circleRadius * 2, self.circleRadius * 2);
        self.shapeLayer.position = [self circlePoint];
        [self.layer addSublayer:self.shapeLayer];
    }
    
    if (!self.subShapeLayer) {
        self.subShapeLayer = [CAShapeLayer layer];
        self.subShapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.subShapeLayer.fillColor = [UIColor redColor].CGColor;
        self.subShapeLayer.frame = self.shapeLayer.bounds;
        [self.shapeLayer addSublayer:self.subShapeLayer];
    }
}

- (void)removeLayer
{
    if (self.subShapeLayer) {
        [self.subShapeLayer removeFromSuperlayer];
        self.subShapeLayer = nil;
    }
    
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
}
// 未设置过的项，设置默认值。
- (void)defaultInit
{
    self.layer.masksToBounds = NO;
    
    if (CGPointEqualToPoint(self.circlePoint, CGPointZero)) {
        self.circlePoint = [self convertPoint:self.center fromView:self.superview];
    }
    
    if (self.circleRadius == 0) {
        self.circleRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    }
    
    if (self.maxDistance == 0) {
        self.maxDistance = self.circleRadius * 6;
    }
    
    if (self.touchCircleRadius == 0) {
        self.touchCircleRadius = self.circleRadius / 3;
    }
    
    if (self.offsetRadian == 0) {
        self.offsetRadian = M_PI / 2;
    }
}

// 顺时针，x正向为0°
// 获取点与圆心形成的直线，与x正向的夹角。【即点在圆上的角度】
- (CGFloat)radianWithPoint:(CGPoint)point onCirclePoint:(CGPoint)circlePoint radius:(CGFloat)radius
{
    CGFloat yOffset = point.y - circlePoint.y;
    CGFloat xOffset = point.x - circlePoint.x;
    CGFloat radian;
    if (xOffset != 0) {
        radian = atan(yOffset / xOffset);
        if (xOffset < 0) {
            radian += M_PI;
        } else {
            if (radian < 0) {
                radian += M_PI * 2;
            }
        }
    } else {
        if (yOffset > 0) {
            radian = M_PI_2;
        } else if (yOffset < 0) {
            radian = M_PI_2 * 3;
        } else {
            radian = 0;
        }
    }
    
    return radian;
}

// 以x正向为0°角，获取圆上指定角度的点
- (CGPoint)pointWithRadian:(CGFloat)radian onCirclePoint:(CGPoint)circlePoint radius:(CGFloat)radius
{
    CGFloat xOffset = cos(radian) * radius;
    CGFloat yOffset = sin(radian) * radius;
    return CGPointMake(circlePoint.x + xOffset, circlePoint.y + yOffset);
}

- (CGFloat)distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    return sqrtf(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
}

- (void)updateLayer
{
    if (!self.isDismiss) {
        [self drawWithTouchPoint:self.touchPoint];
    }
}

- (void)drawWithTouchPoint:(CGPoint)touchP
{
    [self createLayer];
    
    CGPoint circlePoint = [self.shapeLayer convertPoint:[self circlePoint] fromLayer:self.layer];
    CGPoint touchPoint = [self.shapeLayer convertPoint:touchP fromLayer:self.layer];
    
    CGFloat distance = [self distanceFromPoint:circlePoint toPoint:touchPoint];
    float percent = distance / [self maxDistance];
    // 原来的圆，大小随距离增加变小
    float newRadius = [self circleRadius] * (1 - 0.8 * percent);
    
    // 圆上的两个点
    CGFloat radian = [self radianWithPoint:touchPoint onCirclePoint:circlePoint radius:newRadius];// 获取直线与圆的交点。
    CGPoint point1 = [self pointWithRadian:radian + self.offsetRadian onCirclePoint:circlePoint radius:newRadius];
        CGPoint point2 = [self pointWithRadian:radian - self.offsetRadian onCirclePoint:circlePoint radius:newRadius];
    
    // 拖拽产生的圆的对应的两个点【顺序有关】
    CGFloat radianForTouch = radian + M_PI;// 拖拽产生的圆的交点在另一面，+180°
        CGPoint point1ForTouch = [self pointWithRadian:radianForTouch - self.offsetRadian onCirclePoint:touchPoint radius:[self touchCircleRadius]];
    CGPoint point2ForTouch = [self pointWithRadian:radianForTouch + self.offsetRadian onCirclePoint:touchPoint radius:[self touchCircleRadius]];
    
    CGPoint controlPoint = CGPointMake((circlePoint.x + touchPoint.x) / 2, (circlePoint.y + touchPoint.y) / 2);
    
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (!_isOutRange) {
        // 链接段
        [path moveToPoint:point1];
        [path addQuadCurveToPoint:point1ForTouch controlPoint:controlPoint];
        [path addLineToPoint:point2ForTouch];
        [path addQuadCurveToPoint:point2 controlPoint:controlPoint];
        [path closePath];
        
        // 原来的圆
        [circlePath addArcWithCenter:circlePoint radius:newRadius startAngle:0 endAngle:M_PI * 2 clockwise:1];
    }
    
    // 触摸的圆
    [circlePath addArcWithCenter:touchPoint radius:[self touchCircleRadius] startAngle:0 endAngle:M_PI * 2 clockwise:1];
    
    // 两个圆的连接段
    self.shapeLayer.path = path.CGPath;
    self.subShapeLayer.path = circlePath.CGPath;
}
#pragma mark End

#pragma mark - GestureRecognizer
- (void)panGRAction:(UIPanGestureRecognizer *)gr
{
    if (self.isDismiss) {
        return;
    }
    
    CGPoint touchPoint = [gr locationInView:self];
    
    CGFloat distance = [self distanceFromPoint:[self circlePoint] toPoint:touchPoint];
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:// pan，需要拖拽一定距离才能识别到。为了保证点击边缘也可以识别到，因此范围扩大
            if ([self distanceFromPoint:touchPoint toPoint:[self circlePoint]] <= ([self circleRadius] / 3 * 4)) { // 点击圆，开始动画
                self.isAnimating = YES;
                
                if (self.shapeLayer) {// 移除所有动画
                    [self.shapeLayer removeAllAnimations];
                }
            }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.isAnimating) {
                self.isAnimating = NO;
                // 结束时再校验一次是否超出范围
                self.isOutRange = distance > [self maxDistance];
                
                if (self.isOutRange) {
                    self.isDismiss = YES;
                    [self removeLayer];
                } else {
                    self.touchPoint = [self circlePoint];
                    [self setNeedsDisplay];
                    // 阻尼动画
                    [self shakeAnimationFromPoint:touchPoint toPoint:self.circlePoint layer:self.shapeLayer];
                }
                
                if ([self.delegate respondsToSelector:@selector(dragBubbleView:didFinishAnimating:)]) {
                    [self.delegate dragBubbleView:self didFinishAnimating:self.isDismiss];
                }
            }
            
            break;
        case UIGestureRecognizerStateChanged:
            if (self.isAnimating) { // 开始动画
                if (!self.isOutRange) { // 动画中，一旦超出，则动画过程中不再恢复气泡样式。若需要恢复，将该判断去掉即可。
                    self.isOutRange = distance > [self maxDistance];
                }
                
                self.touchPoint = touchPoint;
                [self setNeedsDisplay];
            }
            break;
        default:
            break;
    }
}
#pragma mark END

#pragma mark - Shake Animation
- (void)shakeAnimationFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint layer:(CALayer *)layer
{
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.initialVelocity = 0;
    animation.damping = 0.6;
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = 0.25;
    [layer addAnimation:animation forKey:@"springAnimation"];
}
#pragma mark End

@end
