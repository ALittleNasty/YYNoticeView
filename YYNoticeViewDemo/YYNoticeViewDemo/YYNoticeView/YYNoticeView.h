//
//  YYNoticeView.h
//  YYNoticeViewDemo
//
//  Created by ALittleNasty on 2017/8/4.
//  Copyright © 2017年 ALittleNasty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYNoticeView;

@protocol YYNoticeViewDelegate <NSObject>

@optional
/* 点击文本的事件回调 */
- (void)noticeView:(YYNoticeView *)noticeView tapLabelAtIndex:(NSInteger)index;

@optional
/* 点击关闭按钮回调 */
- (void)noticeViewClickCloseButton;

@end

@interface YYNoticeView : UIView

/** 滚动时间间隔(默认3秒) */
@property (nonatomic, assign) NSTimeInterval scrollInterval;

/** 文本控件距离父控件左边间距(默认10.0) */
@property (nonatomic, assign) CGFloat leftMargin;

/** 字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 代理 */
@property (nonatomic, weak) id <YYNoticeViewDelegate> delegate;


/**
 * 初始化方法
 * @param frame 位置大小
 * @param contents 展示的内容
 */
- (instancetype)initWithFrame:(CGRect)frame withContents:(NSArray <NSString *>*)contents;

/**
 *  开始滚动
 */
- (void)startScroll;

@end
