//
//  TimelineViewController.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface TimelineViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;  //View controller has a tableView as a subview
@property (strong, nonatomic) NSArray *tweetArray;

@end
