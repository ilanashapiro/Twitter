//
//  TweetCell.m
//  twitter
//
//  Created by ilanashapiro on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
                [self.favoriteButton setSelected:YES];
                self.tweet.favoriteCount += 1;
                //NSLog(@"is favorited: %d, favorite count: %d", self.tweet.favorited, self.tweet.favoriteCount);
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
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
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
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
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
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
                //NSLog(@"is favorited: %d, favorite count: %d", self.tweet.favorited, self.tweet.favoriteCount);
                
                //instructions recommend making an update data method that updates ALL views. I don't see the point of this as I'm only updating one button and one label here??????
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
            }
        }];
    }
}

@end
