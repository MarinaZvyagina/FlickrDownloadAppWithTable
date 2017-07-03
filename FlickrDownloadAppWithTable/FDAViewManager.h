//
//  FDAViewManager.h
//  FlickrDownloadAppWithTable
//
//  Created by Марина Звягина on 01.07.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FDAViewManager <NSObject>

-(void)reloadData:(NSArray<NSString *>*) data;

@end
