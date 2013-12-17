//
//  JBBarChartViewController.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBaseViewController.h"

@interface JBBarChartViewController : JBBaseViewController
@property (nonatomic, copy) NSArray *chartData;
@property (nonatomic, copy) NSArray *monthlySymbols;
- (void)reloadData;
@end
