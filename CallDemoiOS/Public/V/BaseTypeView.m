//
//  HouseTypeView.m
//  Disaster
//
//  Created by wanghaipeng on 2018/7/3.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "BaseTypeView.h"
#import "UIView+XH.h"

@interface BaseTypeView ()

@property (nonatomic, copy) NSMutableArray *buttons;
@property (nonatomic, weak) UIScrollView *backView;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation BaseTypeView


- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    [self refreshUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [self createUI];
        
        self.hidden = true;
    }
    return self;
}

- (void)createUI {
    UIScrollView *backView = [[UIScrollView alloc] init];
    backView.frame = CGRectMake(0, 0, 260, 50 * self.titles.count);
    backView.center = self.center;
    backView.showsVerticalScrollIndicator = true;
    backView.bounces = false;
    backView.clipsToBounds = true;
    backView.layer.cornerRadius = 8;
    [self addSubview:backView];
    self.backView = backView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = self.backView.bounds;
    [self.backView addSubview:contentView];
    self.contentView = contentView;
}

- (void)refreshUI {
    
    for (UIView *obj in self.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    if (self.titles.count > 6) {
        self.backView.frame = CGRectMake(0, 0, 260, 50 * 6);
    } else {
        self.backView.frame = CGRectMake(0, 0, 260, 50 * self.titles.count);
    }
    self.backView.center = self.center;
    
    self.contentView.frame = CGRectMake(0, 0, 260, 50 * self.titles.count);
    
    for (int i=0; i<self.titles.count; i++) {
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = UIColor.lightGrayColor;
        lineLabel.frame = CGRectMake(0, 50 * i, self.backView.width, 1);
        [self.contentView addSubview:lineLabel];
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(lineLabel.x, lineLabel.bottom, lineLabel.width, 49);
        button.tag = i;
        if (i == 0) {
            [button setBackgroundColor:UIColor.lightGrayColor];
        }
        [button setBackgroundColor:UIColor.whiteColor];
        [button addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        
        [self.buttons addObject:button];
    }
}

- (void)buttonsClick:(UIButton *)button
{
    self.hidden = YES;
    
    for (UIButton *btn in self.buttons) {
        [btn setBackgroundColor:UIColor.whiteColor];
        if (btn == button) {
            [btn setBackgroundColor:UIColor.lightGrayColor];
        }
    }
    
    if (self.buttonsClickBlock) {
        self.buttonsClickBlock(button.tag);
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (!(point.x >= self.backView.x && point.x <= self.backView.right
          && point.y >= self.backView.y && point.y <= self.backView.bottom)) {
        self.hidden = YES;
    }
}


@end
