# DragBubbleView
类似QQ未读消息拖拽效果


效果图：

![效果](https://github.com/wufeifan890330/DragBubbleView/blob/master/DragBubbleDemo/%E6%95%88%E6%9E%9C.gif)

简略示意图：

![示意图](https://github.com/wufeifan890330/DragBubbleView/blob/master/DragBubbleDemo/%E7%A4%BA%E6%84%8F%E5%9B%BE.png)


接口：


`@protocol WFFDragBubbleViewDelegate <NSObject>`


`- (void)dragBubbleView:(WFFDragBubbleView *)dragBubbleView didFinishAnimating:(BOOL)isDismiss;`


`@end`


`@interface WFFDragBubbleView : UIView`


`@property (nonatomic, weak) id <WFFDragBubbleViewDelegate> delegate;`


`// 最长可拖拽并保持的距离。拖拽超过距离后，松手则消失。`

`@property (nonatomic, assign) CGFloat maxDistance;`

`// 初始圆的半径`

`@property (nonatomic, assign) CGFloat circleRadius;`

`// 初始圆的圆心`

`@property (nonatomic, assign) CGPoint circlePoint;`

`// 拖拽出来的圆的半径`

`@property (nonatomic, assign) CGFloat touchCircleRadius;`

`// 示意图中白色虚线与红色虚线的夹角`

`@property (nonatomic, assign) CGFloat offsetRadian;`


`// 恢复初始状态`

`- (void)restore;`


`@end`
