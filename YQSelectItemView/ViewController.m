//
//  ViewController.m
//  YQSelectItemView
//
//  Created by Wang on 2017/5/23.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "YQSelectItemView.h"


@interface ViewController ()
@property (strong, nonatomic) YQSelectItemView *itemView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YQSelectItemView *view = [YQSelectItemView create];
    view.titleArray = @[@"上官府头", @"西门吹牛", @"二豆", @"汪洋海",@"上官府头", @"西门吹牛", @"二豆", @"汪洋海",@"上官府头", @"西门吹牛", @"二豆", @"汪洋海",@"上官府头", @"西门吹牛", @"二豆", @"汪洋海"];
    
    self.itemView = view;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view show];
    });
    [view setDidSelectItemBlock:^(UICollectionViewCell *item, NSInteger index){
        NSLog(@"item isSelected: %ld", item.isSelected);
    }];
    [view setDidDeselectItemBlock:^(UICollectionViewCell *item, NSInteger index){
        NSLog(@"item isSelected: %ld", item.isSelected);
    }];
    
    [view setSelectedIndexs:@[@(2), @(3)]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
