//
//  InfiniteScrollActivityView.m
//  twitter
//
//  Created by ilanashapiro on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "InfiniteScrollActivityView.h"

@implementation InfiniteScrollActivityView

bool isMoreDataLoading = false;
InfiniteScrollActivityView* loadingMoreView;
UIActivityIndicatorView* activityIndicatorView;
static CGFloat _defaultHeight = 60.0;

+ (CGFloat)defaultHeight{
    return _defaultHeight;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setupActivityIndicator{
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.hidesWhenStopped = true;
    [self addSubview:activityIndicatorView];
}

-(void)stopAnimating{
    [activityIndicatorView stopAnimating];
    self.hidden = true;
}

-(void)startAnimating{
    self.hidden = false;
    [activityIndicatorView startAnimating];
}

@end
