//
//  Created by Baidu Developer Center on 13-3-10.
//  官网地址:http://developer.baidu.com/soc/share
//  技术支持邮箱:dev_support@baidu.com
//  Copyright (c) 2013年 baidu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum{
    BD_SOCIAL_SHARE_TO_APP_CONTENT_TYPE_WEBPAGE,    //分享内容为网页(适用于直接分享到客户端，如微信，QQ)
    BD_SOCIAL_SHARE_TO_APP_CONTENT_TYPE_IMAGE       //分享内容为图片(适用于直接分享到客户端，如微信，QQ)
} BD_SOCIAL_SHARE_TO_APP_CONTENT_TYPE;

/**
 * BDSocialShareContent是分享的内容类，包括描述、url地址，分享内容的标题，分享附带的图片资源及地理位置信息。
 * BDSocialShareContent提供了方便的接口来生成一个内容类的对象，可以同时设置好描述，url地址，分享内容的标题等信息。BDSocialShareContent还提供了一个添加图片资源的接口。
 * 另外，提供了接口对客户端分享内容的类型进行设置
 */

@interface BDSocialShareContent : NSObject

/** @name 属性 */
/**
 *	@brief	生成分享内容对象分享的文字内容，可以是用户的评论或者对分享内容的描述
 */
@property(nonatomic,retain)NSString *description;

/**
 *	@brief	分享的URL
 */
@property(nonatomic,retain)NSString *url;

/**
 *	@brief	分享内容的标题
 */
@property(nonatomic,retain)NSString *title;

/**
 *	@brief	分享时附带的地理位置信息
 */
@property(nonatomic,retain)CLLocation *location;

/** @name 构造分享内容对象&设置分享内容 */
/**
 *	@brief	生成分享内容对象
 *	@param 	description         分享的描述
 *	@param 	url                 分享的URL
 *	@param 	title               分享的标题
 */
+(BDSocialShareContent *)shareContentWithDescription:(NSString *)description
                                                 url:(NSString *)url
                                               title:(NSString *)title;

/**
 *  @brief	添加图片资源
 *	@param 	imageSource         缩略图/上传的图片
 *	@param 	imageUrl            图片的url地址
 * 
 *  如果两个参数同时为nil，分享内容视为没有图片资源;如果两个参数都有值，分享是优先使用imageUrl进行分享。
 * 
 *  直接使用UI接口完成分享功能时，建议imageUrl和imageSource同时提供(imageSource作为缩略图,image作为分享的图片地址)，否则组件会通过网络加载图片，可能会造成用户网络流量的损耗。
 */

-(void)addImageWithImageSource:(UIImage *)imageSource imageUrl:(NSString *)imageUrl;

/**
 *  @brief	添加地理位置信息
 *	@param 	location         位置信息
 *
 *  定位功能可用的情况下，如果开发者通过此接口传入地理位置信息，分享内容优先使用开发者传入的地理位置信息。如果开发者没有传入地理位置信息，分享内容中默认使用自己缓存的定位信息。
 */

-(void)addLocationInfo:(CLLocation *)location;

/**
 *  @brief	设置分享到客户端的内容的类型
 *	@param 	type         分享类型
 *
 *  分享到客户端，默认的分享类型是网页类型，分享后图片会作为内容的缩略图进行展示。
 *  当分享内容的类型设置为图片类型，分享后图片作为分享内容，可以在客户端会话窗口内展示大图。
 *  如果没有添加图片资源，此方法设置无效，使用默认的网页类型进行分享。
 */
-(void)setShareToAPPContentType:(BD_SOCIAL_SHARE_TO_APP_CONTENT_TYPE)type;

@end
