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
#import "MapFriendsViewController.h"
#import "GLobalDataManager.h"
#import "CityModel.h"
#import "FriendModel.h"
#import "FakeDataGenerator.h"
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
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
//@property (nonatomic, weak) MapAllCityViewController *allCityViewController;
@property (nonatomic, weak) MapFriendsViewController *mapViewController;
@property (nonatomic, copy) NSArray *countryDataArray;
@property (nonatomic, copy) NSArray *friendsDataArray;
// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Data
- (void)initFakeData;
@end

@implementation DetailChartViewController {
    NSMutableArray *_labelArray;
}

- (void)configureContentLabels {
    for (UILabel *label in _labelArray) {
        [label removeFromSuperview];
    }
    [_labelArray removeAllObjects];
    
    CGFloat fontSize = (self.chartData.count == 25) ? 10.0f : 25.0f;
    CGFloat paddingY = (self.chartData.count == 25) ? 17.6f : 100.0f;
    BOOL showCityName = (self.chartData.count == 25) ? YES : NO;
    [self.chartData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = nil;
        if (showCityName) {
            CityModel *model = obj;
            title = model.name;
        }
        else {
            FriendModel *model = obj;
            title = model.name;
        }
        UILabel *label = [UILabel new];
        label.text = title;
        label.font = [UIFont systemFontOfSize:fontSize];
        [label sizeToFit];
        label.frame = (CGRect) {
            .origin.x = 5.0f,
            .size = label.frame.size,
            .origin.y = 10.0f + paddingY * idx
        };
        [_labelArray addObject:label];
        [self.backgroundView addSubview:label];
    }];
}

- (IBAction)segmentDidSelect:(UISegmentedControl *)sender {
    if ([self.rightBarButton.title isEqualToString:@"地图"])
    {
        if (sender.selectedSegmentIndex == 0) {
            self.chartData = self.countryDataArray;
        }
        else {
            self.chartData = self.friendsDataArray;
        }
        [self configureContentLabels];
        [self.barChartView reloadData];
        [self.barChartView setState:JBChartViewStateCollapsed];
        [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
    }
    else
    {
        if (sender.selectedSegmentIndex == 0)
        {
            self.mapViewController.type = MapFriendsViewControllerTypeCity;
            [self.mapViewController refresh];
        }
        else
        {
            self.mapViewController.type = MapFriendsViewControllerTypeFriends;
            [self.mapViewController refresh];
        }
    }
    
}

- (IBAction)rightButtonDidTap:(UIBarButtonItem *)button {
    if ([button.title isEqualToString:@"地图"]) {
        self.backgroundView.hidden = YES;
        self.mapViewController.view.hidden = NO;
        [button setTitle:@"列表"];
    }
    else {
        self.backgroundView.hidden = NO;
        self.mapViewController.view.hidden = YES;
        [button setTitle:@"地图"];
    }
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
        _labelArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Date

- (void)initFakeData
{
    self.friendsDataArray = [FakeDataGenerator getFriends];
    NSArray *cityPM250DataList = [self validateDataArrayFromArray:[GLobalDataManager sharedInstance].cityList];
    NSArray *first24CityDataList = [cityPM250DataList subarrayWithRange:(NSRange){.location = 0, .length = 24}];
    CityModel *cityModel = [self cityModelFromArray:cityPM250DataList WithCityName:@"shanghai"];
    NSArray *dataArray = [first24CityDataList arrayByAddingObject:cityModel];
    self.countryDataArray = dataArray;
    self.chartData = dataArray;
    for (CityModel *model in dataArray) {
        NSLog(@"model en_name %@", model.ename);
        NSLog(@"model PM250 %@", model.pm2_5);
    }
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
    
    [self.backgroundView addSubview:self.barChartView];
    [self.barChartView reloadData];
    
    [self.chartData enumerateObjectsUsingBlock:^(CityModel *cityModel, NSUInteger idx, BOOL *stop) {
        UILabel *label = [UILabel new];
        label.text = cityModel.name;
        label.font = [UIFont systemFontOfSize:10.0f];
        [label sizeToFit];
        label.frame = (CGRect) {
            .origin.x = 5.0f,
            .size = label.frame.size,
            .origin.y = 6.0f + 17.6f * idx
        };
        [_labelArray addObject:label];
        [self.backgroundView addSubview:label];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapViewController.view.hidden = YES;
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
    NSInteger height = 0.0f;
    id data = [self.chartData objectAtIndex:index];
    if ([data isKindOfClass:CityModel.class]) {
        CityModel *cityModel = [self.chartData objectAtIndex:index];
        height = [cityModel.pm2_5 integerValue];
    }
    else {
        FriendModel *friendModel = [self.chartData objectAtIndex:index];
        height = [friendModel.cityModel.pm2_5 integerValue];
    }
    return height;
}

#pragma mark - JBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.chartData.count;
}

- (NSInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    NSInteger padding = (self.chartData.count == 25) ? kDetailChartViewControllerBarPadding : 30.0f;
    return padding;
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
    if ([segue.identifier isEqualToString:@"MapFriendsViewControllerSegue"])
    {
        MapFriendsViewController *vc = segue.destinationViewController;
//        vc.destinations = [GLobalDataManager sharedInstance].cityList;
        self.mapViewController = vc;
    }
}

@end
