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
    NSLog(@"%@", tweet.user.name);
    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.tweetContentLabel.text = tweet.text;
    self.dateLabel.text = [NSString stringWithFormat:@"· %@", tweet.createdAtString];

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (IBAction)didTapLike:(id)sender {
    //Update the local model (tweet) properties to reflect it’s been favorited by updating the favorited bool and incrementing the favoriteCount.
    //NSLog(@"%@", self.tweet);
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
                //NSLog(@"is favorited: %d, favorite count: %d", self.tweet.favorited, self.tweet.favoriteCount);
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
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
                //NSLog(@"is favorited: %d, favorite count: %d", self.tweet.favorited, self.tweet.favoriteCount);
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
                NSString *favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
                [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    //NSLog(@"%@", self.tweet);
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
                //NSLog(@"is favorited: %d, favorite count: %d", self.tweet.favorited, self.tweet.favoriteCount);
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
                NSString *retweetCountText = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
                [self.retweetButton setTitle:retweetCountText forState:UIControlStateNormal];
                
                NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"Retweeted"];
                [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
                //NSLog(@"retweeted text: %@", retweetedText);
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
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
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

/*- (void)didTapReply {
    [[APIManager shared] replyToTweet:self.tweet withText: completion:^(Tweet *tweet, NSError *error) {
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
            
            //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
            if (self.tweet.retweetedByUser != nil) {
                NSString *retweetedText = [NSString stringWithFormat: @"%@ %@", self.tweet.retweetedByUser.name, @"Retweeted"];
                [self.didRetweetButton setTitle:retweetedText forState:UIControlStateNormal];
            }
            else {
                self.didRetweetButton.hidden = YES;
            }
        }
    }];
}*/

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
 UIImage *redFavoriteImage = [UIImage imageNamed:"favor-icon-red.png"]
 [self.favoriteButton setImage:redFavoriteImage forState:UIControlStateSelected]
 
 NSString favoriteCountText = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
 [self.favoriteButton setTitle:favoriteCountText forState:UIControlStateNormal]
 */

@end
