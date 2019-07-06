//
//  User.m
//  twitter
//
//  Created by ilanashapiro on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageURLHTTPS = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
    }
    return self;
}

+ (NSMutableArray *)usersWithArray:(NSArray *)dictionaries{
    //A factory method that returns Tweets when initialized with an array of Tweet Dictionaries. This method comes in handy every time you get back a response with an array of Tweet dictionaries.
    NSMutableArray *users = [NSMutableArray array];
    NSLog(@"%@", users);
    for (NSDictionary *dictionary in dictionaries) {
        User *user = [[User alloc] initWithDictionary:dictionary];
        [users addObject:user];
    }
    return users;
}

@end
