/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "DataManager.h"
#import "Utility.h"

@implementation DataManager
- (void) handleData
{
    NSMutableArray *newEntries = [NSMutableArray array];
    
    for (TreeNode *node in root.children)
        if (STREQ(node.key, @"entry"))
        {
            // Retrieve Name, Artist, Image
            NSString *name = [node leafForKey:@"im:name"];
            NSString *artist = [node leafForKey:@"im:artist"];
            NSString *imageAddress = [node leafForKey:@"im:image"];
            if (!name || !artist || !imageAddress) continue;
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageAddress]];
            UIImage *image = [UIImage imageWithData:data];
            if (!image) continue;
            
            // Store other info
            NSString *address = [node leafForKey:@"id"];
            NSString *price = [node leafForKey:@"im:price"];
            
            NSString *largeImageAddress = nil;
            UIImage  *largeImage = nil;
            NSArray  *images = [node leavesForKey:@"im:image"];
            if (images.count)
            {
                largeImageAddress = [images lastObject];
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:largeImageAddress]];
                largeImage = [UIImage imageWithData:data];
            }
            
            NSDictionary *entry = @{@"name":name, @"artist":artist, @"image":image, @"address":ENTRY(address), @"price":ENTRY(price), @"large image":ENTRY(largeImage)};
            [newEntries addObject:entry];
        }
    
    _entries = newEntries;
    
    if (_delegate && [_delegate respondsToSelector:@selector(dataIsReady:)])
        [_delegate performSelectorOnMainThread:@selector(dataIsReady:) withObject:self waitUntilDone:NO];
}

// Fetch data from iTunes
- (void) loadData
{
    NSString *rss = @"http://itunes.apple.com/us/rss/topalbums/limit=30/xml";
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:
     ^{
         root = [[XMLParser sharedInstance] parseXMLFromURL:[NSURL URLWithString:rss]];
         [[NSOperationQueue currentQueue] addOperationWithBlock:^{
             [self handleData];
         }];
     }];
}
@end
