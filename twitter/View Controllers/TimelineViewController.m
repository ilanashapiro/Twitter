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
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "ReplyViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, ReplyViewControllerDelegate, DetailsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
//@property (assign, nonatomic) BOOL isMoreDataLoading;

- (IBAction)didTapLogout:(id)sender;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //View controller becomes its (the custom table view cell) dataSource and delegate in viewDidLoad
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods
    self.tableView.delegate = self; //set delegate equal to the view controller (self). delegate can help handle touch events, multiselect, swiping, etc if you implement these optional functions
    
    [self getTimeline];
    [self createRefreshControl];
    
}

- (void)getTimeline {
    //Make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            //View controller stores that data passed into the completion handler
            self.tweetArray = tweets;
            
            //Reload the table view
            //Table view asks its dataSource for numberOfRows & cellForRowAt
            [self.tableView reloadData]; //call data source methods again as underlying data (self.tweetArray) may have changed
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //cellForRow returns an instance of the custom cell with that reuse identifier with it’s elements populated with data at the index asked for
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    Tweet *tweet = self.tweetArray[indexPath.row];
    cell.tweet = tweet;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //numberOfRows returns the number of items returned from the API
    return self.tweetArray.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToDetails"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweetArray[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController]; //returns a UIViewController, which DetailsViewController is a subclass of
        detailsViewController.tweet = tweet;
        [self addChildViewController:detailsViewController];
        detailsViewController.delegate = self;
        NSLog(@"Tapping on a tweet!");
    }
    else if ([segue.identifier isEqualToString:@"segueToCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"segueToReply"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ReplyViewController *replyController = (ReplyViewController *)navigationController.topViewController;
        replyController.delegate = self;
        replyController.tweetReplyingTo = self.tweetArray[self.tableView.indexPathForSelectedRow.row];
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    NSArray *newTweetArray = [[NSArray alloc] initWithObjects:tweet, nil]; //create array from tweet object in order to add to the front of self.tweetArray
    self.tweetArray = [newTweetArray arrayByAddingObjectsFromArray:self.tweetArray];

    newTweetArray = nil;

    [self.tableView reloadData];
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)updateData:(nonnull UIViewController *)viewController {
    //delegate protocol method for DetailsViewController
    [self getTimeline];
}

- (void)didReply:(nonnull Tweet *)tweet {
    [self getTimeline];
}

@end
