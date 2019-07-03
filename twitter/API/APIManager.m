//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"5lUJuO5AUpPUCez4ewYDFrtgh";
static NSString * const consumerSecret = @"s5ynGqXzstUZwFPxVyMDkYh197qvHOcVM3kwv1o2TKhS1avCdS";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    //Open APIManager.m. Before, the method in the starter code used the completion block with an array of dictionaries. We want to modify it to pass an array of Tweets instead.
    // Create a GET Request
//    [self GET:@"1.1/statuses/home_timeline.json"
//   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
//       // Success
//       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
//       completion(tweets, nil);
//   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       // There was a problem
//       completion(nil, error);
//   }];
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {

       // Manually cache the tweets. If the request fails, restore from cache if possible.
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
//       NSLog(@"tweets array from getHomeTimelineWithCompletion is: %@", tweets);
//       for (Tweet *tweet in tweets) {
//           //NSString *text = dictionary[@"text"];
//           NSLog(@"Name: %@. Username: %@. Tweet text: %@", tweet.user.name, tweet.user.screenName, tweet.text);
//       }
//       NSLog(@"------------------------------------------------------------------------------------------------------------------------------------------");
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];

       completion(tweets, nil);

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

       NSMutableArray *tweets = nil;

       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweets = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }

       completion(tweets, error);
   }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)toggleButtonTweet:(Tweet *)tweet url:(NSString *)urlString completion:(void (^)(Tweet *, NSError *))completion{
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/create.json";
    [self toggleButtonTweet:tweet url:urlString completion:completion];
}

- (void)unFavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/destroy.json";
    [self toggleButtonTweet:tweet url:urlString completion:completion];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/retweet/:id.json";
    [self toggleButtonTweet:tweet url:urlString completion:completion];
}

- (void)unRetweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/unretweet/:id.json";
    [self toggleButtonTweet:tweet url:urlString completion:completion];
}


@end
