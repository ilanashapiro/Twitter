//
//  TweetCell.m
//  twitter
//
//  Created by ilanashapiro on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"


@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.tweetContentLabel.text = tweet.text;
    self.dateLabel.text = [NSString stringWithFormat:@"· %@", tweet.createdAtString];

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
    
    if (![tweet.inReplyToScreenName isEqual:[NSNull null]]) {
        self.didReplyLabel.hidden = NO;
        self.didReplyLabel.text = [NSString stringWithFormat:@"%@ %@", @"In reply to @", tweet.inReplyToScreenName];
    }
    else {
        self.didReplyLabel.hidden = YES;
    }

    [self.profileImageView setImageWithURL:tweet.user.profileImageURLHTTPS];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
                
                NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"(You) Retweeted"];
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
        if(error) {
            NSLog(@"Error geting authenticated user credentials: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Successfully got authenticating user name, which is: %@", userInfoDict[@"name"]);
            NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", userInfoDict[@"name"], @"(You) Retweeted"];
            [self.didRetweetButton setTitle:[NSString stringWithFormat:@"%@", retweetedText] forState:UIControlStateNormal];
            self.didRetweetButton.hidden = NO;
        }
    }];
}

@end
