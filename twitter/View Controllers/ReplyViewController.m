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
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

- (IBAction)didTapClose:(id)sender;
- (IBAction)didTapReply:(id)sender;

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.replyTextView.delegate = self;
}

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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.replyTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    int remainingCharacters = characterLimit - newText.length;
    if (remainingCharacters >= 0) {
        self.characterCountLabel.text = [NSString stringWithFormat:@"Characters remaining: %d", remainingCharacters];
    }
    
    // The new text should be allowed? True/False
    return newText.length <= characterLimit;
}

@end
