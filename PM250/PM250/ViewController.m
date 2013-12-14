//
//  ViewController.m
//  PM250
//
//  Created by Wayne Zhang on 12/12/13.
//  Copyright (c) 2013 CaoNiMei. All rights reserved.
//

#import "ViewController.h"
#import "JBBarChartViewController.h"
#import "JBLineChartViewController.h"
#import "GLobalDataManager.h"
#import "AHHistoryRequest.h"
#import "HistoryRequestModel.h"

@interface ViewController ()
@property (nonatomic, weak) JBBarChartViewController *containerViewController;
@end

@implementation ViewController
- (IBAction)bl_changeData:(id)sender {
    [self.containerViewController reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDictionary *dict = @{@"city": @"shanghai", @"start": @"2013-12-14 08-00-00"};
    AHHistoryRequest *historyRequest = [AHHistoryRequest new];
    [historyRequest request:dict
                     method:@"GET"
                cachePolicy:NO
                    success:^(HistoryRequestModel *model) {
                        NSInteger count = model.historyList.count;
                        NSArray *array = [model.historyList subarrayWithRange:(NSRange) {.location = count - 21, .length = 20}];
                        [GLobalDataManager sharedInstance].historyData = array;
                        self.containerViewController.chartData = [GLobalDataManager sharedInstance].historyData;
                        [self.containerViewController reloadData];
                    }
                    failure:NULL];
/*
    NSString *urlString = @"http://airhit.duapp.com/history?city=shanghai&start=2013-12-14%2007-00-00";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * responseObject = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
        NSData *data = (NSData *)responseObject;
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *historyArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error)
        {
            NSLog(@"service error in %@: %@", NSStringFromClass([self class]), error);
        }
        
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in historyArray)
        {
            CurrentCityRequestModel *model = [[CurrentCityRequestModel alloc] initWithDictionary:dic];
            [resultArray addObject:model];
        }
        
        HistoryRequestModel *model = [[HistoryRequestModel alloc] init];
        model.historyList = resultArray;
        NSLog(@"%@", resultArray);
        NSInteger count = model.historyList.count;
        NSArray *array = [model.historyList subarrayWithRange:(NSRange) {.location = count - 21, .length = 20}];
        [GLobalDataManager sharedInstance].historyData = array;
        self.containerViewController.chartData = [GLobalDataManager sharedInstance].historyData;
        [self.containerViewController reloadData];

    }
  */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"JBBarChartViewController %@", self.containerViewController);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailChartViewControllerSegue"]) {
//        JBBarChartViewController *chartViewController = segue.destinationViewController;
        //TODO: SET chartViewController DATA
    }
    else if ([segue.identifier isEqualToString:@"JBChartListViewControllerSegue"]) {
//        JBLineChartViewController *lineChartController = segue.destinationViewController;
        //TODO: SET lineChartController DATA
        
    }
    else if ([segue.identifier isEqualToString:@"BarChartChildViewControllerSegue"]) {
        JBBarChartViewController *chartViewController = segue.destinationViewController;
        self.containerViewController = chartViewController;
    }
}

@end
