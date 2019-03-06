//
//  ZplayNativeView.h
//  NativeIntegration_Example
//
//  Created by 王泽永 on 2019/3/6.
//  Copyright © 2019 wzy2010416033@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZplayNativeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *callToAction;

@end

NS_ASSUME_NONNULL_END
