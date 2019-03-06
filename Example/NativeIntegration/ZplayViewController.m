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
@property (weak, nonatomic) IBOutlet UITextView *console;
@property (nonatomic) YumiMediationNativeAd *nativeAd;
@property (nonatomic) NSMutableArray<YumiMediationNativeModel *> *nativeAdArray;
@property (nonatomic) ZplayNativeView *zplayNativeView;
@property (nonatomic) NSString *nativeLog;
@end

@implementation ZplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.console.editable = NO;
}

- (IBAction)loadAd:(id)sender {
    int adCount = 1;
    [self.nativeAd loadAd:adCount];
    [self showLogConsoleWith:[NSString stringWithFormat:@"native is loading... load number is %d",adCount]];
}

- (IBAction)registerAndShowAd:(id)sender {
    self.zplayNativeView = [[NSBundle mainBundle] loadNibNamed:@"ZplayNativeView" owner:nil options:nil].firstObject;
    self.zplayNativeView.frame = self.nativeAdBackgroundView.frame;

    if (!self.nativeAdArray || [self.nativeAdArray.firstObject isExpired]) {
        [self showLogConsoleWith:@"native ad is invalid"];
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
    [self showLogConsoleWith:@"nativeAd is showing"];
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
        self.nativeLog = nil;
    });
}

#pragma mark - YumiMediationNativeAdDelegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)yumiMediationNativeAdDidLoad:(NSArray<YumiMediationNativeModel *> *)nativeAdArray {
    self.nativeAdArray = [NSMutableArray arrayWithArray:nativeAdArray];
    [self showLogConsoleWith:@"nativeAd is loaded"];
}

/// Tells the delegate that a request failed.
- (void)yumiMediationNativeAd:(YumiMediationNativeAd *)nativeAd didFailWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:@"nativeAd is fail to load"];
}

/// Tells the delegate that the Native view has been clicked.
- (void)yumiMediationNativeAdDidClick:(YumiMediationNativeModel *)nativeAd {
    [self showLogConsoleWith:@"nativeAd is clicked"];
}

- (void)showLogConsoleWith:(NSString *)log {
    NSDate *date = [NSDate date];
    NSDateFormatter *formateDate = [[NSDateFormatter alloc] init];
    [formateDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataString = [formateDate stringFromDate:date];
    NSString *formateLog = [NSString stringWithFormat:@"%@ : %@ \n", dataString, log];
    if (!self.nativeLog) {
        self.nativeLog = @"";
    }
    self.nativeLog = [self.nativeLog stringByAppendingString:formateLog];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.console.text = self.nativeLog;
    });
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
