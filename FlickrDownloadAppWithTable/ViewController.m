//
//  ViewController.m
//  FlickrDownloadAppWithTable
//
//  Created by Марина Звягина on 18.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "ViewController.h"
#import "FDACell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray <NSString *> * pictures;
@property (nonatomic, strong) id<FDADataBase> picturesManager;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ViewController

-(instancetype) initWithPicturesManager:(id<FDADataBase>) picturesManager {
    self = [super init];
    if (self) {
        self.picturesManager = picturesManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.pictures = [self.picturesManager getPictures:@"Cat"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage * compressedImage = [self setImageSizeWithIndex:indexPath.row];
    UITableViewCell *cell = [UITableViewCell new];
    UIImageView * view = [[UIImageView alloc] initWithImage:compressedImage];
    [cell.contentView addSubview:view];
    
    return cell;
}

-(UIImage *)imageWithImage:(UIImage *)imageToCompress scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToCompress drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)setImageSizeWithIndex:(NSInteger) row {
    NSURL * url = [[NSURL alloc] initWithString:self.pictures[row]];
    CIImage * im = [[CIImage alloc] initWithContentsOfURL:url];
    UIImage * image = [[UIImage alloc] initWithCIImage:im scale:1.0 orientation:UIImageOrientationUp];
    CGSize sizeForImage;

    sizeForImage = CGSizeMake (self.view.bounds.size.width/2,self.view.bounds.size.width/2);
    UIImage * compressedImage = [self imageWithImage:image scaledToSize:sizeForImage];
    return compressedImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage * compressedImage = [self setImageSizeWithIndex:indexPath.row];

    return compressedImage.size.height;
}

@end
