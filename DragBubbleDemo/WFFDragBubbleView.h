//
//  WFFDragBubbleView.h
//  QQBubble
//
//  Created by wufeifan on 2017/2/8.
//  Copyright © 2017年 wufeifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFFDragBubbleView;
@protocol WFFDragBubbleViewDelegate <NSObject>

- (void)dragBubbleView:(WFFDragBubbleView *)dragBubbleView didFinishAnimating:(BOOL)isDismiss;

@end

@interface WFFDragBubbleView : UIView

@property (nonatomic, weak) id <WFFDragBubbleViewDelegate> delegate;

// 最长可拖拽并保持的距离。拖拽超过距离后，松手则消失。
@property (nonatomic, assign) CGFloat maxDistance;

// 初始圆的半径
@property (nonatomic, assign) CGFloat circleRadius;

// 初始圆的圆心
@property (nonatomic, assign) CGPoint circlePoint;

// 拖拽出来的圆的半径
@property (nonatomic, assign) CGFloat touchCircleRadius;

// 拖拽时，触摸点与圆心形成的直线，与圆和触摸点形成的圆形成的两个交点。分别向各自圆弧两边偏移固定角度【该变量】后各产生两个点。两对点各自以贝塞尔曲线连接，形成拖拽效果。[0-90°]
@property (nonatomic, assign) CGFloat offsetRadian;

// 显示在圆上的汉字
@property (nonatomic, strong) NSString *info;

// 恢复初始状态
- (void)restore;

@end
