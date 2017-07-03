//
//  ViewController.m
//  FlickrDownloadAppWithTable
//
//  Created by Марина Звягина on 18.06.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "ViewController.h"
#import "FDACell.h"
#import "FDAViewManager.h"
@import Masonry;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, FDAViewManager>
@property (nonatomic, copy) NSArray <NSString *> * pictures;
@property (nonatomic, strong) id<FDADataBase> picturesManager;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
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
    self.imageOperationQueue = [NSOperationQueue new];
    self.imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [NSCache new];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.tableView];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self setDelegates];
    self.searchController.searchBar.placeholder = @"Search Here";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self setDelegates];
    [self.picturesManager getPictures:@"" withViewManager:self];
    [self.tableView registerClass:[FDACell class] forCellReuseIdentifier:FDACellIdentifier];
}

-(void)setDelegates {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (FDACell *)[tableView dequeueReusableCellWithIdentifier:FDACellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FDACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FDACellIdentifier];
    }
    
    NSString *imageUrlString = self.pictures[indexPath.row];
    UIImage *imageFromCache = [self.imageCache objectForKey:imageUrlString];
    
    if (imageFromCache) {
        ((FDACell *)cell).pictureImage.image = imageFromCache;
    } else {
        ((FDACell *)cell).pictureImage.image = [UIImage imageNamed:@"Placeholder"];
        [self.imageOperationQueue addOperationWithBlock:^{
            NSURL *imageurl = [NSURL URLWithString:imageUrlString];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
            if (img != nil) {
                [self.imageCache setObject:img forKey:imageUrlString];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UITableViewCell *updateCell = (FDACell *)[tableView dequeueReusableCellWithIdentifier:FDACellIdentifier forIndexPath:indexPath];
                    if (updateCell) {
                        ((FDACell *)cell).pictureImage.image = img;
                    }
                }];
            }
        }];
    }
    
    return cell;
}

-(void)reloadData:(NSArray<NSString *>*) data {
    self.pictures = data;
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self.picturesManager getPictures:searchString withViewManager:self];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width;
}

@end
