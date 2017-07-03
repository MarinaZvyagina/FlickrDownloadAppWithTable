//
//  NSOFlipperDataBase.m
//  NSOperationProject
//
//  Created by Марина Звягина on 20.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "FDAFlickrDataBase.h"
#import "FDAViewManager.h"

@implementation FDAFlickrDataBase

-(void)getPictures: (NSString *)phrase withViewManager:(id<FDAViewManager>) manager;
{
    if (phrase == nil )
        phrase = @"";
    NSString * string = [[NSString alloc] initWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&text=%@&api_key=c55f5a419863413f77af53764f86bd66&format=json&nojsoncallback=1", phrase ];
    NSURLRequest *nsurlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    NSURLSessionConfiguration * defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:nsurlRequest
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSArray * photos = [self getPhotosFromJSONData:data];
                    [manager reloadData:photos];
                    
                }];
    
    [task resume];
}

-(NSArray *)getPhotosFromJSONData:(NSData *)responseData {
    NSMutableArray * result = [NSMutableArray new];
    if (responseData) {
        NSDictionary * JSONObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        NSDictionary * photos = [JSONObject objectForKey:@"photos"];
        NSDictionary * photo = [photos objectForKey:@"photo"];
        
        for (NSDictionary * object in photo ) {
            NSString *farm_id = [object objectForKey:@"farm"];
            NSString *server_id = [object objectForKey:@"server"];
            NSString *photo_id = [object objectForKey:@"id"];
            NSString *secret = [object objectForKey:@"secret"];
            
            NSString *s0 = @"https://farm";
            NSString *s1 = [s0 stringByAppendingString:farm_id.description];
            NSString *s2 = [s1 stringByAppendingString:@".staticflickr.com/"];
            NSString *s3 = [s2 stringByAppendingString:server_id.description];
            NSString *s4 = [s3 stringByAppendingString:@"/"];
            NSString *s5 = [s4 stringByAppendingString:photo_id.description];
            NSString *s6 = [s5 stringByAppendingString:@"_"];
            NSString *s7 = [s6 stringByAppendingString:secret.description];
            
            NSString *photoString = [s7 stringByAppendingString:@".jpg"];
            
            [result addObject:photoString];
        }
    }
    
    return result;
}


@end
