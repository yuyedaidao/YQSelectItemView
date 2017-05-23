//
//  YQSelectItemCell.m
//  YQSelectItemView
//
//  Created by Wang on 2017/5/23.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "YQSelectItemCell.h"

@implementation YQSelectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.flagImgView.highlighted = selected;
}

@end
