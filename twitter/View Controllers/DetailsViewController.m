//
//  DetailsViewController.m
//  twitter
//
//  Created by ilanashapiro on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "ReplyViewController.h"


@interface DetailsViewController () <ReplyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *didRetweetButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;

- (IBAction)didTapRetweet:(id)sender;
- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapReply:(id)sender;


@end

@implementation DetailsViewController

//@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTweetDetailContents:self.tweet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        [self.delegate updateData:self];
        NSLog(@"Updated parent home timeline views from child detail view.");
    }
}

- (void)setTweetDetailContents:(Tweet *)tweet {
    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.dateLabel.text = tweet.createdAtString;
    self.tweetContentLabel.text = tweet.text;
    
    NSString *favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal];
    
    NSString *retweetCountText = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountText forState:UIControlStateNormal];
    
    self.favoriteButton.selected = tweet.favorited;
    self.retweetButton.selected = tweet.retweeted;
    
    if (tweet.retweetedByUser && !tweet.retweeted) {
        NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"Retweeted"];
        [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
        self.didRetweetButton.hidden = NO;
    }
    
    else if (tweet.retweeted) {
        [self setRetweetLabelNameToAuthUser];
    }
    
    else {
        self.didRetweetButton.hidden = YES;
    }
    
    [self.profileImageView setImageWithURL:tweet.user.profileImageURLHTTPS];
    
}

- (IBAction)didTapLike:(id)sender {
    //Update the local model (tweet) properties to reflect it’s been favorited by updating the favorited bool and incrementing the favoriteCount.
    if (!self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = YES;
                UIImage *redFavoriteImage = [UIImage imageNamed:@"favor-icon-red.png"];
                [self.favoriteButton setImage:redFavoriteImage forState:UIControlStateSelected];
                
                [self.favoriteButton setSelected:YES];
                self.tweet.favoriteCount += 1;
                
                NSString *favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
                [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal];
            }
        }];
    }
    
    else {
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                [self.favoriteButton setSelected:NO];
                self.tweet.favoriteCount -= 1;
    
                NSString *favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
                [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal];
            }
        }];
    }
}


- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = YES;
                [self.retweetButton setSelected:YES];
                self.tweet.retweetCount += 1;
               
                NSString *retweetCountText = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
                [self.retweetButton setTitle:retweetCountText forState:UIControlStateNormal];
                
                NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"Retweeted"];
                [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];

                self.didRetweetButton.hidden = NO;
            }
        }];
    }
    
    else {
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = NO;
                [self.retweetButton setSelected:NO];
                self.tweet.retweetCount -= 1;
                
                NSString *retweetCountText = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
                [self.retweetButton setTitle:retweetCountText forState:UIControlStateNormal];
                NSLog(@"%@ is unretweeted by all: %d, retweet count: %d", self.tweet.text, self.tweet.retweetedByUser != nil, self.tweet.retweetCount);
                NSLog(@"%@", self.tweet.retweetedByUser.name);
                
                if (self.tweet.retweetedByUser != nil) {
                    NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", self.tweet.retweetedByUser.name, @"Retweeted"];
                    [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
                }
                else {
                    self.didRetweetButton.hidden = YES;
                }
            }
        }];
    }
}

- (void)setRetweetLabelNameToAuthUser {
    [[APIManager shared] getUserCredentialsWithCompletion:^(NSDictionary *userInfoDict, NSError *error) {
        if(error){
            NSLog(@"Error geting authenticated user credentials: %@", error.localizedDescription);
        }
        else{
            NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", userInfoDict[@"name"], @"Retweeted"];
            [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
            self.didRetweetButton.hidden = NO;
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToReply"]) {
        NSLog(@"Tweet to reply to is: %@", self.tweet.text);
        UINavigationController *navigationController = [segue destinationViewController];
        ReplyViewController *replyController = (ReplyViewController *)navigationController.topViewController;
        replyController.delegate = self;
        replyController.tweetReplyingTo = self.tweet;
        
    }
}


- (void)didReply:(nonnull Tweet *)tweet {
    
}

@end
