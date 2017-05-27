//
//  YQSelectItemView.h
//  YQSelectItemView
//
//  Created by Wang on 2017/5/23.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQSelectItemCell.h"

@class YQSelectItemView;
@protocol YQSelectItemViewDelegate <NSObject>

@optional
- (void)selectItemView:(YQSelectItemView *)view didSelectItem:(__kindof UICollectionViewCell *)item atIndex:(NSInteger)index;
- (void)selectItemView:(YQSelectItemView *)view didDeselectItem:(__kindof UICollectionViewCell *)item atIndex:(NSInteger)index;
- (void)selectItemViewDone:(YQSelectItemView *)view selectedIndexs:(NSArray<NSNumber *> *)indexs;
@optional

- (BOOL)selectItemView:(YQSelectItemView *)view shouldSelectedItemAtIndex:(NSInteger)index;

@end

@interface YQSelectItemView : UIView

+ (instancetype)create;
- (void)show;
- (void)hide;

@property (weak, nonatomic) id<YQSelectItemViewDelegate> delegate;
@property (strong, nonatomic) UIView *backgroundView;

@property (assign, nonatomic) CGFloat widthMultiplier;
@property (assign, nonatomic) CGFloat heightMultiplier;
@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) CGFloat itemHeight;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray<NSNumber *> *selectedIndexs;
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (copy, nonatomic) void (^didSelectItemBlock)(__kindof UICollectionViewCell *item, NSInteger index);
@property (copy, nonatomic) void (^didDeselectItemBlock)(__kindof UICollectionViewCell *item, NSInteger index);
@property (copy, nonatomic) BOOL (^shouldSelectedItemBlock)(NSInteger index);
@property (copy, nonatomic) void (^doneBlock)(NSArray<NSNumber *> *indexs);

- (void)registerNib:(UINib *)nib;
- (void)registerClass:(Class)aClass;

- (void)reloadData;

@end
