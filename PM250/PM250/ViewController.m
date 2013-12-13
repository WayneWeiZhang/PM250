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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JBBarChartViewControllerSegue"]) {
        JBBarChartViewController *chartViewController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"JBChartListViewControllerSegue"]) {
        JBLineChartViewController *lineChartController = segue.destinationViewController;
    }
}

@end
