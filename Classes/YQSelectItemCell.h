//
//  YQSelectItemCell.h
//  YQSelectItemView
//
//  Created by Wang on 2017/5/23.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQSelectItemProtocol <NSObject>

- (void)setTitle:(NSString *)title;
@property (assign, nonatomic) BOOL itemSelected;

@end

@interface YQSelectItemCell : UICollectionViewCell <YQSelectItemProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;
@property (assign, nonatomic) BOOL itemSelected;

@end
