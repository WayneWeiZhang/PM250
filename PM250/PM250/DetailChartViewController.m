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
#import <BaiduSocialShare_Internal/BDSocialShareSDK_Internal.h>
#import "ImageHelper.h"
#import "UIImage+AHRotated.h"
#import "BMapKit.h"

// Numerics
CGFloat const kDetailChartViewControllerChartHeight = 300.0f;
CGFloat const kDetailChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kDetailChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kDetailChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kDetailChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kDetailChartViewControllerBarPadding = 10;
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
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
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
    
    CGFloat fontSize = (self.chartData.count == 13) ? 16.0f : 16.0f;
    CGFloat originY = (self.chartData.count == 13) ? 8.0f : 22.0f;
    CGFloat paddingY = (self.chartData.count == 13) ? 34.5f : 95.0f;
    CGFloat pm250originY = (self.chartData.count == 13) ? 8.0f : 22.0f;
    CGFloat paddingPM250Y = (self.chartData.count == 13) ? 34.5f : 95.0f;
    BOOL showCityName = (self.chartData.count == 13) ? YES : NO;
    [self.chartData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = nil;
        NSString *pm250Value = nil;
        if (showCityName) {
            CityModel *model = obj;
            title = model.name;
            pm250Value = [NSString stringWithFormat:@"%d",[model.pm2_5 integerValue]];
        }
        else {
            FriendModel *model = obj;
            title = model.name;
            pm250Value = [NSString stringWithFormat:@"%d",[model.cityModel.pm2_5 integerValue]];
        }
        UILabel *label = [UILabel new];
        label.text = title;
        label.font = [UIFont systemFontOfSize:fontSize];
        [label sizeToFit];
        label.frame = (CGRect) {
            .origin.x = 5.0f,
            .size = label.frame.size,
            .origin.y = originY + paddingY * idx
        };
        [_labelArray addObject:label];
        [self.backgroundView addSubview:label];
        
        UILabel *pm250Label = [UILabel new];
        pm250Label.text = pm250Value;
        pm250Label.font = [UIFont systemFontOfSize:fontSize];
        pm250Label.textColor = [UIColor whiteColor];
        [pm250Label sizeToFit];
        pm250Label.frame = (CGRect) {
            .origin.x = 60.0f,
            .size = pm250Label.frame.size,
            .origin.y = pm250originY + paddingPM250Y * idx
        };
        [_labelArray addObject:pm250Label];
        [self.backgroundView addSubview:pm250Label];
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
            [self.mapViewController.mapView setRegion: BMKCoordinateRegionMakeWithDistance(self.mapViewController.mapView.centerCoordinate, 300000.0f, 300000.0f) animated: NO];
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
    [self segmentDidSelect:self.segmentedControl];
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
    NSArray *first24CityDataList = [cityPM250DataList subarrayWithRange:(NSRange){.location = 0, .length = 12}];
    CityModel *cityModel = [self cityModelFromArray:cityPM250DataList WithCityName:@"shanghai"];
    NSArray *dataArray = [first24CityDataList arrayByAddingObject:cityModel];
    self.countryDataArray = dataArray;
    self.chartData = dataArray;
}

- (void)reloadData {
    [self initFakeData];
    [self.barChartView reloadData];
    [self.barChartView setState:JBChartViewStateCollapsed];
    [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
    
}

- (IBAction)share:(id)sender {
    BDSocialShareContent *content = [BDSocialShareContent shareContentWithDescription:@"水深火热" url:@"http://www.baidu.com" title:@"AirHit"];
    
    UIImage *shareImage = nil;
    if ([self.rightBarButton.title isEqualToString:@"地图"])
    {
        shareImage = [ImageHelper imageWithView:self.backgroundView];
//        shareImage = [shareImage imageRotatedByDegrees:90];
    }
    else
    {
        UIImage *firstImage = [ImageHelper imageWithView:self.mapViewController.mapView];
        UIImage *secondImage = [ImageHelper glToUIImage];
        shareImage = [ImageHelper mergerImage:firstImage secodImage:secondImage];
//
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        
    }
    else
    {
        if ([self.rightBarButton.title isEqualToString:@"地图"])
        {
            
        }
        else
        {
            
        }
    }
    [content addImageWithImageSource:shareImage imageUrl:nil];
    [BDSocialShareSDK_Internal showShareMenuWithShareContent:content displayPlatforms:@[kBD_SOCIAL_SHARE_PLATFORM_SINAWEIBO, kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION, kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE] supportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait isStatusBarHidden:NO targetViewForPad:nil result:^(BD_SOCIAL_RESULT requestResult, NSString *platformType, id response, NSError *error) {
        
    }];
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
    self.barChartView.backgroundColor = [UIColor whiteColor];
    
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
        label.font = [UIFont systemFontOfSize:16.0f];
        [label sizeToFit];
        label.frame = (CGRect) {
            .origin.x = 5.0f,
            .size = label.frame.size,
            .origin.y = 8.0f + 34.5f * idx
        };
        [_labelArray addObject:label];
        [self.backgroundView addSubview:label];
        
        UILabel *pm250Label = [UILabel new];
        pm250Label.text = [NSString stringWithFormat:@"%d",[cityModel.pm2_5 integerValue]];
        pm250Label.font = [UIFont systemFontOfSize:16.0f];
        pm250Label.textColor = [UIColor whiteColor];
        [pm250Label sizeToFit];
        pm250Label.frame = (CGRect) {
            .origin.x = 60.0f,
            .size = label.frame.size,
            .origin.y = 8.0f + 34.5f * idx
        };
        [_labelArray addObject:pm250Label];
        [self.backgroundView addSubview:pm250Label];
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
    NSInteger padding = (self.chartData.count == 13) ? kDetailChartViewControllerBarPadding : 30.0f;
    return padding;
}

- (UIColor *)barColorForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIColor *barColor = nil;
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
