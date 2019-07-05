//
//  InfiniteScrollActivityView.h
//  twitter
//
//  Created by ilanashapiro on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfiniteScrollActivityView : UIView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
