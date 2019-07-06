//
//  User.h
//  twitter
//
//  Created by ilanashapiro on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSURL *profileImageURLHTTPS;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)usersWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
