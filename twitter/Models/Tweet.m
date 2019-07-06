//
//  Tweet.m
//  twitter
//
//  Created by ilanashapiro on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "NSDate+DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    //Your dictionary keys have to match the keys from the API exactly. Reference the Tweet API Documentation to ensure they are correct.
    self = [super init];
    //    NSLog(@"init tweet!");
    if (self) {
        //NSLog(@"%@", dictionary);
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        NSLog(@"name: %@, retweeted is: %@, retweeted status Y/N: %d", dictionary[@"user"][@"name"], dictionary[@"retweeted"], dictionary[@"retweeted_status"] != nil);
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
//         NSLog(@"retweeted is of type %@", NSStringFromClass([dictionary[@"retweeted"] class]));
        NSLog(@"retweeted: %d", self.retweeted);
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            // Change tweet to original tweet
            dictionary = originalTweet;
//            self.retweeted = YES;
            NSLog(@"Retweeted by %@", self.retweetedByUser.name);
        }
        
//        else if (self.retweeted){
//            NSLog(@"is retweeted %@", dictionary[@"user"][@"name"]);
//            NSDictionary *userDictionary = dictionary[@"user"];
//            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
//            self.retweeted = NO;
//        }
        
//        NSLog(@"tweet dict is: %@", dictionary);
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
//        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.inReplyToScreenName = dictionary[@"in_reply_to_screen_name"];
        
        //initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        
        
        
        
        
        
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        self.createdAtString = [NSString stringWithFormat:@"%@", [date shortTimeAgoSinceNow]];
//        NSLog(@"Short time ago since now: %@", [date shortTimeAgoSinceNow]);
//        // Configure output format
//        formatter.dateStyle = NSDateFormatterShortStyle;
//        formatter.timeStyle = NSDateFormatterNoStyle;
//        // Convert Date to String
//        self.createdAtString = [formatter stringFromDate:date];
//        NSLog(@"Created At String : %@", date);
//        NSLog(@"done initializing tweet");
//        NSLog(@"");
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    //A factory method that returns Tweets when initialized with an array of Tweet Dictionaries. This method comes in handy every time you get back a response with an array of Tweet dictionaries.
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}


@end
