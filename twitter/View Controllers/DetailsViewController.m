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

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *didRetweetButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTweetDetailContents:self.tweet];
}

- (void)setTweetDetailContents:(Tweet *)tweet {
    NSLog(@"%@", tweet.user.name);
    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    //self.tweetContentLabel.text = tweet.text;
    self.dateLabel.text = tweet.createdAtString;
    
    NSString *favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal];
    
    NSString *retweetCountText = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountText forState:UIControlStateNormal];
    //    NSLog(@"retweet count text %@", retweetCountText);
    
    self.favoriteButton.selected = tweet.favorited;
    self.retweetButton.selected = tweet.retweeted;
    //NSLog(@"name of user who posted originally: %@, name of user: %@", self.tweet.user.name, self.tweet.retweetedByUser.name);
    
    //NSLog(@"%@ did retweet: %d the user %@.", tweet.retweetedByUser.name, tweet.retweeted, tweet.retweetedByUser.name);
    if (tweet.retweetedByUser && !tweet.retweeted) {
        //NSLog(@"retweeted! name: %@", tweet.user.name);
        NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"Retweeted"];
        [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
        self.didRetweetButton.hidden = NO;
    }
    
    else if (tweet.retweeted) {
        [self setRetweetLabelNameToAuthUser];
        //        NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", self.tweet.authUserName, @"Retweeted"];
        //        [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
        //        self.didRetweetButton.hidden = NO;
    }
    
    else {
        self.didRetweetButton.hidden = YES;
    }
    
    [self.profileImageView setImageWithURL:tweet.user.profileImageURLHTTPS];
    
}

- (void)setRetweetLabelNameToAuthUser {
    [[APIManager shared] getUserCredentialsWithCompletion:^(NSDictionary *userInfoDict, NSError *error) {
        if(error){
            NSLog(@"Error geting authenticated user credentials: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Auth user info is a %@", NSStringFromClass([userInfoDict class]));
            NSLog(@"Auth user name info in block: %@", userInfoDict[@"name"]);
            NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", userInfoDict[@"name"], @"Retweeted"];
            [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
            self.didRetweetButton.hidden = NO;
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
