//
//  HistoryRequestModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHBaseModel.h"
#import "CurrentCityRequestModel.h"

@interface HistoryRequestModel : AHBaseModel

@property (strong, nonatomic) NSArray *historyList; //  object is CurrentCityRequestModel;

@end
