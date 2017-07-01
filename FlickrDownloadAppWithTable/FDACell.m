//
//  NSOCell.m
//  NSOperationProject
//
//  Created by Марина Звягина on 20.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "FDACell.h"
#import "FDAViewManager.h"
@import Masonry;

NSString *const FDACellIdentifier = @"FDACellIdentifier";

@interface FDACell ()

@end


@implementation FDACell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self createSubviews];
    }
    return self;
}

-(void) loadImage: (NSString *) url andSize:(CGSize)size {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString:url];
                       __block NSData *imageData;
                       
                       dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                     ^{
                                         imageData = [NSData dataWithContentsOfURL:imageURL];
                                         dispatch_sync(dispatch_get_main_queue(), ^{
                                             __strong typeof(self) strongSelf = weakSelf;
                                             if (strongSelf) {
                                                 UIImage *image = [UIImage imageWithData:imageData];
                                                 strongSelf.pictureImage.image = [self imageWithImage:image scaledToSize:size];
                                             }
                                         });
                                     });
                   });
}

-(void)createSubviews {
    self.pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
    [self addSubview:self.pictureImage];
}

-(UIImage *)imageWithImage:(UIImage *)imageToCompress scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToCompress drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
