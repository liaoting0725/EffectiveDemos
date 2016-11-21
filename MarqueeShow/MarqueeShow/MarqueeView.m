//
//  MarqueeView.m
//  MarqueeShow
//
//  Created by 廖挺 on 16/11/21.
//  Copyright © 2016年 liaoting. All rights reserved.
//

#import "MarqueeView.h"

static const CGFloat textPadding = 20;
static const CGFloat speed = 70;

@interface MarqueeView () {
    NSMutableArray *_subviewArray;
    CGRect _firstRect;
    CGRect _secondRect;
    CGFloat _timeInv;
}
@end

@implementation MarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _subviewArray = [NSMutableArray array];
        self.isStop = YES;
    }
    return self;
}

- (void)setTextArray:(NSArray *)textArray scrollDirectionType:(ScrollDirectionType)scrollDirectionType {
    self.clipsToBounds = YES;
    CGFloat width = 0;
    UIView *lastView = nil;
    UIView *containView = [UIView new];
    containView.userInteractionEnabled = YES;
    [self addSubview:containView];
    for (NSString *text in textArray) {
        UILabel *label = [UILabel new];
        label.userInteractionEnabled = YES;
        label.text = text;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentLeft;
        CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
        CGFloat labelWidth = rect.size.width + textPadding;
        width += labelWidth;
        [containView addSubview:label];
        label.frame = CGRectMake(lastView?CGRectGetMaxX(lastView.frame):0, 0, labelWidth, CGRectGetHeight(self.frame));
        lastView = label;
    }
     _firstRect = containView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
    if ((width -textPadding) > CGRectGetWidth(self.frame)) {
        _timeInv = width /speed;
        NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:containView];
        UIView* newContainView = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        [self addSubview:newContainView];
        _secondRect = newContainView.frame = CGRectMake(CGRectGetMaxX(containView.frame), 0, width, CGRectGetHeight(self.frame));
        [_subviewArray addObject:containView];
        [_subviewArray addObject:newContainView];
    }
    
}

- (void)action {
    UIView *containView = _subviewArray[0];
    UIView *containViewNew = _subviewArray[1];
    CGRect rect1 = containView.frame;
    rect1.origin.x = -rect1.size.width;
    CGRect rect2 = containViewNew.frame;
    rect2.origin.x = 0;
    [UIView animateWithDuration:_timeInv delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        containView.frame = rect1;
        containViewNew.frame = rect2;
    } completion:^(BOOL finished) {
        containView.frame = _secondRect;
        containViewNew.frame = _firstRect;
        [_subviewArray replaceObjectAtIndex:1 withObject:containView];
        [_subviewArray replaceObjectAtIndex:0 withObject:containViewNew];
        [self action];
    }];
}

- (void)start {
    [self action];
}

- (void)resume{
    UIView *containView = _subviewArray[0];
    UIView *containViewNew = _subviewArray[1];
    [self resumeLayer:containView.layer];
    [self resumeLayer:containViewNew.layer];
    _isStop = NO;
}

- (void)stop{
    UIView *containView = _subviewArray[0];
    UIView *containViewNew = _subviewArray[1];
    [self pauseLayer:containView.layer];
    [self pauseLayer:containViewNew.layer];
    _isStop = YES;
}

- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer {
    //当你是停止状态时，则恢复
    if (_isStop) {
        CFTimeInterval pauseTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pauseTime;
        layer.beginTime = timeSincePause;
    }
}

    @end
