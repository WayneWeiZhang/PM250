//
//  DetailChartViewController.m
//  PM250
//
//  Created by Wayne Zhang on 12/14/13.
//  Copyright (c) 2013 CaoNiMei. All rights reserved.
//

#import "DetailChartViewController.h"
// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "MapAllCityViewController.h"
#import "MapFriendsViewController.h"
#import "GLobalDataManager.h"
#import "CityModel.h"
// Numerics
CGFloat const kDetailChartViewControllerChartHeight = 300.0f;
CGFloat const kDetailChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kDetailChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kDetailChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kDetailChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kDetailChartViewControllerBarPadding = 5;
NSInteger const kDetailChartViewControllerNumBars = 25;
NSInteger const kDetailChartViewControllerMaxBarHeight = 100; // max random value
NSInteger const kDetailChartViewControllerMinBarHeight = 20;

// Strings
NSString * const kDetailChartViewControllerNavButtonViewKey = @"view";

#define kDetailNumericDefaultPadding -60.0f

@interface DetailChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Data
- (void)initFakeData;
@end

@implementation DetailChartViewController {
    UIView *_backgroundView;
}

- (NSArray *)validateDataArrayFromArray:(NSArray *)dataArray {
    NSIndexSet *indexes = [dataArray indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                                     passingTest:^BOOL(CityModel *model, NSUInteger idx, BOOL *stop) {
                                                         return ([model.pm2_5 integerValue] > 0);
                                                     }];
    NSArray *filteredArray = [dataArray objectsAtIndexes:indexes];
    return filteredArray;
}

- (CityModel *)cityModelFromArray:(NSArray *)dataArray WithCityName:(NSString *)cityName {
    CityModel *cityModel = nil;
    NSIndexSet *indexes = [dataArray indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                                       passingTest:^BOOL(CityModel *model, NSUInteger idx, BOOL *stop) {
                                                           return [model.ename isEqualToString:cityName];
                                                       }];
    NSArray *filteredArray = [dataArray objectsAtIndexes:indexes];
    cityModel = filteredArray.firstObject;
    return cityModel;
}

#pragma mark - Alloc/Init
- (id)init
{
    self = [super init];
    if (self)
    {
        [self initFakeData]; // fake rain data
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initFakeData];
    }
    return self;
}

#pragma mark - Date

- (void)initFakeData
{
    NSArray *cityPM250DataList = [self validateDataArrayFromArray:[GLobalDataManager sharedInstance].cityList];
    NSArray *first24CityDataList = [cityPM250DataList subarrayWithRange:(NSRange){.location = 0, .length = 24}];
    CityModel *cityModel = [self cityModelFromArray:cityPM250DataList WithCityName:@"shanghai"];
    NSArray *dataArray = [first24CityDataList arrayByAddingObject:cityModel];
    self.chartData = dataArray;
    for (CityModel *model in dataArray) {
        NSLog(@"model en_name %@", model.ename);
        NSLog(@"model PM250 %@", model.pm2_5);
    }
    [self.chartData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    }];
}

- (void)reloadData {
    [self initFakeData];
    [self.barChartView reloadData];
    [self.barChartView setState:JBChartViewStateCollapsed];
    [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    _backgroundView = [[UIView alloc] initWithFrame:(CGRect) {.origin.x = 0.0f, .origin.y = 64.0f, .size.width = CGRectGetWidth(self.view.frame), .size.height = CGRectGetHeight(self.view.frame) - 64.0f}];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backgroundView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.barChartView = [[JBBarChartView alloc] initWithFrame:CGRectMake(kDetailNumericDefaultPadding + 20.0f, kDetailNumericDefaultPadding + 134.0f, self.view.bounds.size.width - (kDetailNumericDefaultPadding * 2), kDetailChartViewControllerChartHeight)];
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kDetailChartViewControllerChartHeaderPadding;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kDetailNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kDetailChartViewControllerChartFooterHeight * 0.5) + 0.0f, self.view.bounds.size.width - (kDetailNumericDefaultPadding * 2), kDetailChartViewControllerChartFooterHeight)];
    footerView.padding = kDetailChartViewControllerChartFooterPadding;
//    footerView.leftLabel.text = [kJBStringLabeJanuary uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
//    footerView.rightLabel.text = [kJBStringLabelDecember uppercaseString];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;
    
    self.barChartView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [_backgroundView addSubview:self.barChartView];
    [self.barChartView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    CityModel *cityModel = [self.chartData objectAtIndex:index];
    return [cityModel.pm2_5 integerValue];
}

#pragma mark - JBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return kDetailChartViewControllerNumBars;
}

- (NSInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kDetailChartViewControllerBarPadding;
}

- (UIColor *)barColorForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)selectionBarColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
}

- (void)barChartView:(JBBarChartView *)barChartView didUnselectBarAtIndex:(NSInteger)index
{
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kDetailChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.barChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapAllCityViewControllerSegue"])
    {
        MapAllCityViewController *vc = segue.destinationViewController;
        vc.destinations = [GLobalDataManager sharedInstance].cityList;
    }
}

@end