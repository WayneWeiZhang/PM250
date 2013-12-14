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
    
    self.userLocation = [[BMKUserLocation alloc] init];
    self.userLocation.delegate = self;
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.userLocation startUserLocationService];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.userLocation stopUserLocationService];
    
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
    [self.userLocation stopUserLocationService];
    
    self.mapView.delegate = nil;
    [self.mapView viewWillDisappear];
}

- (void)handleEnterForeground:(NSNotification *)notification
{
    [self.userLocation startUserLocationService];
    
    self.mapView.delegate = self;
    [self.mapView viewWillAppear];
}

@end
