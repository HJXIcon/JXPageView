//
//  JXPageView.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPageContentView.h"
#import "JXPageStyle.h"
#import "UIColor+pageExtension.h"
#import "JXTitleView.h"

@interface JXPageView : UIView

@property(nonatomic, strong) NSArray <NSString *>*titles;
@property(nonatomic, strong) JXPageStyle *style;
@property(nonatomic, strong) NSArray <UIViewController *>*childVcs;
@property(nonatomic, strong) UIViewController *parentVc;


- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                        style:(JXPageStyle *)style
                     childVcs:(NSArray <UIViewController *>*)childVcs
                     parentVc:(UIViewController *)parentVc;
@end
