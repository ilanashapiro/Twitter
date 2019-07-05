//
//  ReplyViewController.m
//  twitter
//
//  Created by ilanashapiro on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "Tweet.h"
#import "APIManager.h"


@interface ReplyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *replyTextView;

- (IBAction)didTapClose:(id)sender;
- (IBAction)didTapReply:(id)sender;


@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapReply:(id)sender {
    NSLog(@"%@ %@", self.tweetReplyingTo.text, self.replyTextView.text);
    [[APIManager shared]replyToTweet:self.tweetReplyingTo withText:self.replyTextView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didReply:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}
@end


/*postStatusWithText:self.replyTextView.text completion:^(Tweet *tweet, NSError *error) {
 if(error){
 NSLog(@"Error composing Tweet: %@", error.localizedDescription);
 }
 else{
 [self.delegate didTweet:tweet];
 NSLog(@"Compose Tweet Success!");
 }
 [self dismissViewControllerAnimated:true completion:nil];*/
