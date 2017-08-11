//
//  ViewController.m
//  YYNoticeViewDemo
//
//  Created by ALittleNasty on 2017/8/4.
//  Copyright © 2017年 ALittleNasty. All rights reserved.
//

#import "ViewController.h"

#import "YYNoticeView.h"

@interface ViewController ()<YYNoticeViewDelegate>

/** 通知栏 */
@property (nonatomic, weak) YYNoticeView *noticeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor]; 
    
    
    NSArray *contents = @[@"孤独的人是可耻的",
                          @"召集三千弟子, 就可召唤神龙",
                          @"做坏事要有结局不好的准备"];
    CGRect frame = CGRectMake(0.0, 100.0, [UIScreen mainScreen].bounds.size.width, 50.0);
    YYNoticeView *noticeView = [[YYNoticeView alloc] initWithFrame:frame withContents:contents];
    noticeView.scrollInterval = 3;
    noticeView.leftMargin = 20;
    noticeView.textColor = [UIColor blackColor];
    noticeView.textFont = [UIFont boldSystemFontOfSize:14];
    noticeView.delegate = self;
    [self.view addSubview:noticeView];
    self.noticeView = noticeView;
    [noticeView startScroll];
}


#pragma mark - YYNoticeViewDelegate

- (void)noticeViewClickCloseButton
{
    NSLog(@"%s", __func__);
}

- (void)noticeView:(YYNoticeView *)noticeView tapLabelAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd个文本", index);
}

#pragma mark - Reset Action

- (IBAction)resetButtonAction:(UIButton *)sender
{
    NSArray *titles = @[@"百年孤独", @"巨人的陨落", @"霍乱时期的爱情"];
    [self.noticeView resetContents:titles];
}


@end
