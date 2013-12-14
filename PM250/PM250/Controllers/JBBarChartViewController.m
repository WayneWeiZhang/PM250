//
//  JBBarChartViewController.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBarChartViewController.h"

// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "FriendModel.h"
#import "CityModel.h"
#import "CurrentCityRequestModel.h"
// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 100; // max random value
NSInteger const kJBBarChartViewControllerMinBarHeight = 20;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface JBBarChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Data
- (void)initFakeData;

@end

@implementation JBBarChartViewController

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData]; // fake rain data
        _monthlySymbols = [[[NSDateFormatter alloc] init] monthSymbols];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initFakeData];
        _monthlySymbols = [[[NSDateFormatter alloc] init] monthSymbols];
    }
    return self;
}

#pragma mark - Date

- (void)initFakeData
{
    return;
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        [mutableChartData addObject:[NSNumber numberWithInteger:MAX(kJBBarChartViewControllerMinBarHeight, arc4random() % kJBBarChartViewControllerMaxBarHeight)]]; // fake height
    }
    _chartData = [NSArray arrayWithArray:mutableChartData];
}

- (void)reloadData {
    [self initFakeData];
    [self.barChartView reloadData];
    [self.barChartView setState:JBChartViewStateCollapsed];
    [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
   
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];

    self.barChartView = [[JBBarChartView alloc] initWithFrame:CGRectMake(kJBNumericDefaultPadding, kJBNumericDefaultPadding + 0.0f, self.view.bounds.size.width - (kJBNumericDefaultPadding * 2), kJBBarChartViewControllerChartHeight + 40.0f)];
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.backgroundColor = [UIColor whiteColor];
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartFooterHeight * 0.5) + 0.0f, self.view.bounds.size.width - (kJBNumericDefaultPadding * 2), kJBBarChartViewControllerChartFooterHeight)];
    footerView.padding = kJBBarChartViewControllerChartFooterPadding;
    footerView.backgroundColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;

    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChartView setState:JBChartViewStateCollapsed];
}

#pragma mark - JBBarChartViewDelegate

- (NSInteger)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    return [[self.chartData objectAtIndex:index] intValue];
}

#pragma mark - JBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.chartData.count;
}

- (NSInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

- (UIColor *)barColorForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIColor *barColor = nil;
    NSInteger height = 0.0f;
    CurrentCityRequestModel *data = [self.chartData objectAtIndex:index];
    height = [data.pm2_5 integerValue];
    if (height <= 100) {
        barColor = UIColorFromRGB(0x2BB42A);
    }
    else if (height > 100 && height <= 200) {
        barColor = UIColorFromRGB(0xF5CD00);
    }
    else {
        barColor = UIColorFromRGB(0xF52D00);
    }
    return barColor;
}

- (UIColor *)selectionBarColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:index];
    [self.informationView setValueText:[NSString stringWithFormat:@"%d", [valueNumber intValue]] unitText:kJBStringLabelMm];
    [self.informationView setTitleText:[self.monthlySymbols objectAtIndex:index]];
    [self.informationView setHidden:NO animated:YES];
}

- (void)barChartView:(JBBarChartView *)barChartView didUnselectBarAtIndex:(NSInteger)index
{
    [self.informationView setHidden:YES animated:YES];
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBBarChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.barChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

@end
