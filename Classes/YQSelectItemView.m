//
//  YQSelectItemView.m
//  YQSelectItemView
//
//  Created by Wang on 2017/5/23.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "YQSelectItemView.h"

@interface YQSelectItemView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableSet *selSet;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation YQSelectItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)create {
    YQSelectItemView *view = [[[NSBundle mainBundle] loadNibNamed:@"YQSelectItemView" owner:nil options:nil] lastObject];
    return view;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [self reloadData];
}

- (void)hide {
    [self removeFromSuperview];
}

- (IBAction)doneAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectItemViewDone:selectedIndexs:)]) {
        [self.delegate selectItemViewDone:self selectedIndexs:_selSet ? _selSet.allObjects : nil];
    } else {
        !self.doneBlock? : self.doneBlock(_selSet ? _selSet.allObjects : nil);
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.backgroundView = view;
    _contentInsets = UIEdgeInsetsMake(10, 15, 15, 10);
    _widthMultiplier = 0.8;
    _heightMultiplier = 0.6;
    _itemHeight = 50.0f;
    _column = 2;
    _selSet = [NSMutableSet set];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.tapGesture = tap;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 8;
    self.contentView.clipsToBounds = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YQSelectItemCell" bundle:nil] forCellWithReuseIdentifier:@"yq_select_item"];
    self.layout.minimumInteritemSpacing = 10;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = NO;
    
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
    }
}


- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    self.topConstraint.constant = contentInsets.top;
    self.bottomConstraint.constant = contentInsets.bottom;
    self.leadingConstraint.constant = contentInsets.left;
    self.trailingConstraint.constant = contentInsets.right;
}

- (void)setWidthMultiplier:(CGFloat)widthMultiplier {
    _widthMultiplier = widthMultiplier;
    _widthConstraint.constant = CGRectGetWidth(self.bounds) * widthMultiplier;
}

- (void)setHeightMultiplier:(CGFloat)heightMultiplier {
    _heightMultiplier = heightMultiplier;
    _heightConstraint.constant = CGRectGetHeight(self.bounds) * heightMultiplier;
}


- (void)registerNib:(UINib *)nib {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"yq_select_item"];
}
- (void)registerClass:(Class)aClass {
    [self.collectionView registerClass:aClass forCellWithReuseIdentifier:@"yq_select_item"];
}

- (void)reloadData {
    [self.selSet addObjectsFromArray:self.selectedIndexs];
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    _widthConstraint.constant = CGRectGetWidth(self.bounds) * _widthMultiplier;
    _heightConstraint.constant = CGRectGetHeight(self.bounds) * _heightMultiplier;
    self.layout.itemSize = CGSizeMake((_widthConstraint.constant - self.contentInsets.left - self.contentInsets.right) / _column - (self.layout.minimumInteritemSpacing * (_column - 1)), _itemHeight);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGesture) {
        return !CGRectContainsPoint(self.contentView.frame, [touch locationInView:self]);
    }
    return YES;
}

- (void)tapHandlerAction:(UITapGestureRecognizer *)sender {
    if (CGRectContainsPoint(self.contentView.frame, [sender locationInView:sender.view])) return;
    [self hide];
}

#pragma mark collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"yq_select_item" forIndexPath:indexPath];
    NSAssert([cell conformsToProtocol:@protocol(YQSelectItemProtocol)], @"YQSelecteItemView注册的UICollectionViewCell需要实现 YQSelectItemProtocol");
    id<YQSelectItemProtocol> item = (id<YQSelectItemProtocol>)cell;
    [item setTitle:self.titleArray[indexPath.item]];
    item.itemSelected  = [_selSet containsObject:@(indexPath.item)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<YQSelectItemProtocol> item = (id<YQSelectItemProtocol>)[collectionView cellForItemAtIndexPath:indexPath];
   
    if ([_selSet containsObject:@(indexPath.item)]) {
        [_selSet removeObject:@(indexPath.item)];
        if ([self.delegate respondsToSelector:@selector(selectItemView:didDeselectItem:atIndex:)]) {
            [self.delegate selectItemView:self didDeselectItem:[collectionView cellForItemAtIndexPath:indexPath] atIndex:indexPath.item];
        } else {
            !self.didDeselectItemBlock? : self.didDeselectItemBlock([collectionView cellForItemAtIndexPath:indexPath], indexPath.item);
        }
        
        item.itemSelected = NO;
    } else {
        BOOL shouldSelect = YES;
        if ([self.delegate respondsToSelector:@selector(selectItemView:shouldSelectedItemAtIndex:)]) {
            shouldSelect = [self.delegate selectItemView:self shouldSelectedItemAtIndex:indexPath.item];
        } else {
            shouldSelect = self.shouldSelectedItemBlock? self.shouldSelectedItemBlock(indexPath.item) : YES;
        }
        if (shouldSelect) {
            [_selSet addObject:@(indexPath.item)];
            if ([self.delegate respondsToSelector:@selector(selectItemView:didSelectItem:atIndex:)]) {
                [self.delegate selectItemView:self didSelectItem:[collectionView cellForItemAtIndexPath:indexPath] atIndex:indexPath.item];
            } else {
                !self.didSelectItemBlock? : self.didSelectItemBlock([collectionView cellForItemAtIndexPath:indexPath], indexPath.item);
            }
        }
        item.itemSelected = YES;
    }
}


@end
