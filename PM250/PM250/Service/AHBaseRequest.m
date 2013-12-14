//
//  AHBaseRequest.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "AHBaseRequest.h"

@implementation AHBaseRequest

- (id)init {
	self = [super init];
	if (self) {
		self.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAHServiceBaseUrl]];
		[self.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
	}
    
	return self;
}

- (void)request:(NSDictionary *)parameters method:(NSString *)method cachePolicy:(BOOL)cache success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
	//请设置
	path = [self setRoute];
    
	successBlock = [success copy];
	failureBlock = [failure copy];
    
    //    if(cache)
    //    {
    //        [self getCacheData:[self getIdentity:parameters]];
    //    }
    //
    //    if([self respondsToSelector:@selector(BeforeSendRequest:withMethod:)])
    //    {
    //        parameters = [self BeforeSendRequest:parameters withMethod:method];
    //    }
    
	NSMutableURLRequest *request = [self.client requestWithMethod:method path:path parameters:parameters];
    
	self.operation = [self.client HTTPRequestOperationWithRequest:request success: ^(AFHTTPRequestOperation __unused *operation, id responseObject) {
	    id resObject;
	    if ([self respondsToSelector:@selector(ParseData:)]) {
	        resObject = [self ParseData:responseObject];
		}
	    if (resObject != nil) {
	        if (successBlock) {
	            successBlock(resObject);
			}
		}
	    else {
	        if (failureBlock) {
	            failureBlock(nil);
			}
		}
        
	    successBlock = nil;
	    failureBlock = nil;
	} failure: ^(AFHTTPRequestOperation __unused *operation, NSError *error) {
	    if (failureBlock) {
	        failureBlock(error);
		}
	    successBlock = nil;
	    failureBlock = nil;
	}];
	[self.client enqueueHTTPRequestOperation:self.operation];
}

- (id)ParseData:(id)responseObject {
	return responseObject;
}

- (NSString *)setRoute {
	return @"";
}

- (void)cancel {
	if (self.operation != nil) {
		[self.operation cancel];
		self.operation = nil;
	}
}

@end
