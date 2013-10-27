//
//  AppDelegate.m
//  NEETTableViewPullRefreshDemo
//
//  Created by mtmta on 2013/10/27.
//  Copyright (c) 2013年 The Neet House. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    RootViewController *viewController = [[RootViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
