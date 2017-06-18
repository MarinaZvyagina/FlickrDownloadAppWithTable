//
//  AppDelegate.m
//  FlickrDownloadAppWithTable
//
//  Created by Марина Звягина on 18.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FDAFlickrDataBase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    ViewController *mainVC=[[ViewController alloc] initWithPicturesManager:[FDAFlickrDataBase new]];
    
    window.rootViewController = mainVC;
    
    self.window = window;
    [window makeKeyAndVisible];
    return YES;
}



@end
