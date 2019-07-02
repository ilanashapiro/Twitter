//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweetArray;



@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods
    self.tableView.delegate = self; //set delegate equal to the view controller (self)
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = tweets;
            [self.tableView reloadData]; //call data source methods again as underlying data (self.tweetArray) may have changed
            
            //NSLog(@"%@", tweets);
//            for (Tweet *tweet in tweets) {
////                NSString *name = tweet.user.name;
////                NSLog(@"%@", name);
//                NSLog(@"Name: %@. Username: %@. Tweet text: %@. Image URL: %@", tweet.user.name, tweet.user.screenName, tweet.text, tweet.user.profileImageURL);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    //NSLog(@"%@", tweets);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
//    TweetCell *cell = [[TweetCell alloc] init];

    Tweet *tweet = self.tweetArray[indexPath.row];
    
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.tweetContentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    
    [cell.profileImageView setImageWithURL:tweet.user.profileImageURLHTTPS];
//    NSLog(@"Name: %@. Username: %@. Tweet text: %@", tweet.user.name, tweet.user.screenName, tweet.text);

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"tweetArray is %@", self.tweetArray);
//    NSLog(@"tweetArray is a %@", NSStringFromClass([self.tweetArray class]));
//    NSLog(@"tweetArray.count is %lu", self.tweetArray.count);
    return self.tweetArray.count;
}

@end
