//
//  DetailsViewController.h
//  twitter
//
//  Created by ilanashapiro on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailsViewControllerDelegate <NSObject>

- (void)updateData:(UIViewController *)viewController;

@end


@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
