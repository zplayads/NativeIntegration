//
//  ZplayViewController.m
//  NativeIntegration
//
//  Created by wzy2010416033@163.com on 03/06/2019.
//  Copyright (c) 2019 wzy2010416033@163.com. All rights reserved.
//

#import "ZplayViewController.h"
#import <YumiMediationSDK/YumiMediationNativeAd.h>
#import <YumiMediationSDK/YumiMediationNativeAdConfiguration.h>
#import "ZplayNativeView.h"

#define YumiNativePlacementID @"atb3ke1i"

@interface ZplayViewController () <YumiMediationNativeAdDelegate>
@property (weak, nonatomic) IBOutlet UIView *nativeAdBackgroundView;
@property (nonatomic) YumiMediationNativeAd *nativeAd;
@property (nonatomic) NSMutableArray<YumiMediationNativeModel *> *nativeAdArray;
@property (nonatomic) ZplayNativeView *zplayNativeView;
@property (nonatomic) UIView *view1;
@end

@implementation ZplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loadAd:(id)sender {
    [self.nativeAd loadAd:1];
}

- (IBAction)registerAndShowAd:(id)sender {
    self.zplayNativeView = [[NSBundle mainBundle] loadNibNamed:@"ZplayNativeView" owner:nil options:nil].firstObject;
    self.zplayNativeView.frame = self.nativeAdBackgroundView.frame;

    if (!self.nativeAdArray || [self.nativeAdArray.firstObject isExpired]) {
        NSLog(@"native ad is invalid");
        return;
    }
    self.zplayNativeView.icon.image = self.nativeAdArray.firstObject.icon.image;
    self.zplayNativeView.title.text = self.nativeAdArray.firstObject.title;
    self.zplayNativeView.coverImage.image = self.nativeAdArray.firstObject.coverImage.image;
    self.zplayNativeView.callToAction.text = self.nativeAdArray.firstObject.callToAction;

    [self.nativeAd registerViewForInteraction:self.zplayNativeView
                              clickableAssetViews:@{
                                                    YumiMediationUnifiedNativeTitleAsset : self.zplayNativeView.title,
                                                    YumiMediationUnifiedNativeCoverImageAsset : self.zplayNativeView.coverImage,
                                                    YumiMediationUnifiedNativeIconAsset : self.zplayNativeView.icon,
                                                    YumiMediationUnifiedNativeCallToActionAsset : self.zplayNativeView.callToAction
                                                    }
                               withViewController:self
                                         nativeAd:self.nativeAdArray.firstObject];
    [self.nativeAd reportImpression:self.nativeAdArray.firstObject view:self.zplayNativeView];

    [self.view addSubview:self.zplayNativeView];
}

- (IBAction)removeAndDestoryAd:(id)sender {
    if (!self.zplayNativeView) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.zplayNativeView removeFromSuperview];
        self.zplayNativeView = nil;
        [self.nativeAdArray removeAllObjects];
        self.nativeAdArray = nil;
    });
}

#pragma mark - YumiMediationNativeAdDelegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)yumiMediationNativeAdDidLoad:(NSArray<YumiMediationNativeModel *> *)nativeAdArray {
    self.nativeAdArray = [NSMutableArray arrayWithArray:nativeAdArray];
    NSLog(@"nativeAd is loaded");
}

/// Tells the delegate that a request failed.
- (void)yumiMediationNativeAd:(YumiMediationNativeAd *)nativeAd didFailWithError:(YumiMediationError *)error {
    NSLog(@"nativeAd is fail to load ");
}

/// Tells the delegate that the Native view has been clicked.
- (void)yumiMediationNativeAdDidClick:(YumiMediationNativeModel *)nativeAd {
    NSLog(@"nativeAd is clicked");
}

- (YumiMediationNativeAd *)nativeAd {
    if (!_nativeAd) {
        YumiMediationNativeAdConfiguration *config = [[YumiMediationNativeAdConfiguration alloc] init];
        _nativeAd = [[YumiMediationNativeAd alloc] initWithPlacementID:YumiNativePlacementID
                                                             channelID:@""
                                                             versionID:@""
                                                         configuration:config];
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

@end
