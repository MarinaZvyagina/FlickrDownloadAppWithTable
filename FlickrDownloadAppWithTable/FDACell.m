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
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
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
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
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
                                             [self.activityIndicator stopAnimating];
                                             self.activityIndicator.hidden = YES;
                                         });
                                     });
                   });
}

-(void)createSubviews {
    self.pictureImage = [UIImageView new];
    [self addSubview:self.pictureImage];
    
    [self.pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_height);
    }];
    
    self.activityIndicator = [UIActivityIndicatorView new];
    [self.activityIndicator setColor:UIColor.blackColor];
    self.activityIndicator.hidden = NO;
    [self.pictureImage addSubview:self.activityIndicator];

    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.top.equalTo(self.imageView.mas_top);
        make.left.equalTo(self.imageView.mas_left);
    }];
}

-(UIImage *)imageWithImage:(UIImage *)imageToCompress scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToCompress drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
