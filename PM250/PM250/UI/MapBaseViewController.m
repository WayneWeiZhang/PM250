//
//  MapBaseViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapBaseViewController.h"

@interface MapBaseViewController ()

@end

@implementation MapBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;
    [self.mapView viewWillDisappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleEnterBackground:(NSNotification *)notification
{
    self.mapView.delegate = nil;
    [self.mapView viewWillDisappear];
}

- (void)handleEnterForeground:(NSNotification *)notification
{
    self.mapView.delegate = self;
    [self.mapView viewWillAppear];
}

@end
