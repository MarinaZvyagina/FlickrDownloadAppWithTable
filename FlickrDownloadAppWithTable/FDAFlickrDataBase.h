//
//  NSOFlipperDataBase.h
//  NSOperationProject
//
//  Created by Марина Звягина on 20.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDADataBase.h"

@interface FDAFlickrDataBase : NSObject <FDADataBase>
-(void)getPictures: (NSString *)phrase withViewManager:(id<FDAViewManager>) manager;
@end
