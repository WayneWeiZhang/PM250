//
//  AppDelegate.m
//  PM250
//
//  Created by Wayne Zhang on 12/12/13.
//  Copyright (c) 2013 CaoNiMei. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduSocialShare_Internal/BDSocialShareSDK_Internal.h>
#import "CommonConfig.h"
#import "BMapKit.h"

@interface AppDelegate () <BMKGeneralDelegate>

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initShareCenter];
    [self initMapManager];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [BDSocialShareSDK_Internal destroy];
}

- (BOOL)application:(__unused UIApplication *)application openURL:(NSURL *)url sourceApplication:(__unused NSString *)sourceApplication annotation:(__unused id)annotation {
    
    return [BDSocialShareSDK_Internal handleOpenURL:url];
}

- (void)initShareCenter {
    
    [BDSocialShareSDK_Internal registerApiKey:kSocialShareAppKey supportSharePlatforms:@[kBD_SOCIAL_SHARE_PLATFORM_SINAWEIBO, kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_SESSION, kBD_SOCIAL_SHARE_PLATFORM_WEIXIN_TIMELINE, kBD_SOCIAL_SHARE_PLATFORM_EMAIL, kBD_SOCIAL_SHARE_PLATFORM_SMS]];
    
    [BDSocialShareSDK_Internal registerWXApp:kWeiXinAppKey];
}

- (void)initMapManager {
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:@"jpl2MVZZ4SQ0OpMSpdxk2EXw" generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
	}
}

@end
