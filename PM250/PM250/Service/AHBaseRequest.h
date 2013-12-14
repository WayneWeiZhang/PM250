//
//  AHBaseRequest.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AHBaseRequestDelegate <NSObject>

@required
- (id)ParseData:(id)responseObject;
- (NSString *)setRoute;

@end

@interface AHBaseRequest : NSObject <AHBaseRequestDelegate>
{
	NSString *path;
	void (^successBlock)(id responseObject);
	void (^failureBlock)(NSError *error);
}

@property (strong, nonatomic) AFHTTPClient *client;
@property (strong, nonatomic) AFHTTPRequestOperation *operation;

/**@
 *	@brief	请求url对应的数据
 */
- (void)request:(NSDictionary *)parameters
         method:(NSString *)method
    cachePolicy:(BOOL)cache
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;


///**
// *	@brief	解析返回的json数据
// *
// *	@param  responseObject  系统返回的数据格式
// *
// *	@return	返回解析后的model数据
// */
//-(id)ParseData:(id)responseObject;

- (void)cancel;

@end
