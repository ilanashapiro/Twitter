//
//  ReplyViewController.h
//  twitter
//
//  Created by ilanashapiro on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ReplyViewControllerDelegate <NSObject>

- (void)didReply:(Tweet *)tweet;

@end

@interface ReplyViewController : UIViewController

@property (nonatomic, weak) id<ReplyViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *tweetReplyingTo;

@end

NS_ASSUME_NONNULL_END
