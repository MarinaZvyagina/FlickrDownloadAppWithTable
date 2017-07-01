//
//  NSOCell.h
//  NSOperationProject
//
//  Created by Марина Звягина on 20.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

extern NSString *const FDACellIdentifier;
@protocol FDAViewManager;

@interface FDACell : UITableViewCell
@property (nonatomic, strong) UIImageView * pictureImage;
-(void) loadImage: (NSString *) url andSize:(CGSize)size;
@end
