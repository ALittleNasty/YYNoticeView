//
//  YYNoticeView.m
//  YYNoticeViewDemo
//
//  Created by ALittleNasty on 2017/8/4.
//  Copyright © 2017年 ALittleNasty. All rights reserved.
//

#import "YYNoticeView.h"

@interface YYLabel : UILabel
/** 是否正在显示 */
@property (nonatomic, assign) BOOL isShowing;
@end
@implementation YYLabel
@end

@interface YYNoticeView ()

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 第一个文本 */
@property (nonatomic, strong) YYLabel *firstLabel;

/** 第二个文本 */
@property (nonatomic, strong) YYLabel *secondLabel;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;

/** 展示的内容数组 */
@property (nonatomic, copy) NSArray *contents;

/** 当前显示的索引 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

static NSTimeInterval defaultScrollInterval = 3;
static CGFloat defaultLeftMargin = 10.0;

@implementation YYNoticeView

- (instancetype)initWithFrame:(CGRect)frame withContents:(NSArray<NSString *> *)contents
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.记录传过来的标题数组
        self.contents = contents;
        // 2.默认初始值
        self.currentIndex = 0;
        self.scrollInterval = defaultScrollInterval;
        self.leftMargin = defaultLeftMargin;
        // 3.初始化子视图
        [self initSubviews]; 
    }
    return self;
}

#pragma mark - Init Subviews

- (void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    // 1.添加关闭按钮
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnWidth = self.bounds.size.height;
    _closeBtn.frame = CGRectMake(self.bounds.size.width - btnWidth, 0.0, btnWidth, btnWidth);
    [_closeBtn setImage:[UIImage imageNamed:@"navi_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    // 2.1初始化第一个文本框
    _firstLabel = [[YYLabel alloc] init];
    _firstLabel.frame = CGRectMake(self.leftMargin, 0.0, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
    _firstLabel.textColor = self.textColor;
    _firstLabel.font = self.textFont;
    _firstLabel.isShowing = YES;
    _firstLabel.text = self.contents.firstObject;
    _firstLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)];
    [_firstLabel addGestureRecognizer:firstTap];
    [self addSubview:_firstLabel];
    
    // 2.2初始化第二个文本框
    if (self.contents.count > 1) {
        
        _secondLabel = [[YYLabel alloc] init];
        _secondLabel.frame = CGRectMake(self.leftMargin, btnWidth, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
        _secondLabel.textColor = self.textColor;
        _secondLabel.font = self.textFont;
        _secondLabel.isShowing = NO;
        _secondLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction:)];
        [_secondLabel addGestureRecognizer:tap];
        [self addSubview:_secondLabel];
    }
}

#pragma mark - Action

- (void)labelTapAction:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(noticeView:tapLabelAtIndex:)]) {
        [self.delegate noticeView:self tapLabelAtIndex:self.currentIndex];
    }
}

- (void)closeButtonAction
{
    [self.timer invalidate];
    self.timer = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(noticeViewClickCloseButton)]) {
        [self.delegate noticeViewClickCloseButton];
    }
    [self removeFromSuperview];
}

#pragma mark - Util

/* 开启定时器 */
- (void)startTimer
{
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf changeLabelFrame];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/* 使用动画改变文本显示位置, 并更新现实的文本 */
- (void)changeLabelFrame
{
    // 获取即将显示的文本内容的索引
    NSInteger willDisplayIndex = self.currentIndex + 1;
    if (willDisplayIndex == self.contents.count) {
        willDisplayIndex = 0;
    }
    YYLabel *willDisplayLabel = _firstLabel.isShowing ? _secondLabel : _firstLabel;
    willDisplayLabel.text = self.contents[willDisplayIndex];
    
    _firstLabel.isShowing = !_firstLabel.isShowing;
    _secondLabel.isShowing = !_secondLabel.isShowing;
    CGFloat btnWidth = self.bounds.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        
        if (self.firstLabel.isShowing) {
            self.firstLabel.frame = CGRectMake(self.leftMargin, 0.0, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
            self.secondLabel.frame = CGRectMake(self.leftMargin, -btnWidth, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
        } else {
            self.secondLabel.frame = CGRectMake(self.leftMargin, 0.0, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
            self.firstLabel.frame = CGRectMake(self.leftMargin, -btnWidth, self.bounds.size.width - btnWidth - self.leftMargin, btnWidth);
        }
    } completion:^(BOOL finished) {
        
        // 拿到不在显示的文本控件
        YYLabel *notDisplayLabel = !self.firstLabel.isShowing ? self.firstLabel : self.secondLabel;
        notDisplayLabel.frame = CGRectMake(self.leftMargin, btnWidth, self.bounds.size.width - btnWidth - 10.0, btnWidth);
        
        _currentIndex += 1;
        if (_currentIndex == self.contents.count) {
            _currentIndex = 0;
        }
    }];
}

#pragma mark - Setter

- (void)setTextFont:(UIFont *)textFont
{
    _firstLabel.font = textFont;
    if (_secondLabel) {
        _secondLabel.font = textFont;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _firstLabel.textColor = textColor;
    if (_secondLabel) {
        _secondLabel.textColor = textColor;
    }
}

-(void)setLeftMargin:(CGFloat)leftMargin
{
    _leftMargin = leftMargin;
    CGRect firstFrame = self.firstLabel.frame;
    firstFrame.origin.x = _leftMargin;
    self.firstLabel.frame = firstFrame;
    
    if (self.secondLabel) {
        
        CGRect secondFrame = self.secondLabel.frame;
        secondFrame.origin.x = _leftMargin;
        self.secondLabel.frame = secondFrame;
    }
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Public Method

- (void)startScroll
{
    if (self.contents.count > 1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.scrollInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTimer];
        });
    }
}

@end