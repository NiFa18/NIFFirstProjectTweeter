//
//  NIFViewController.m
//  NIFFirstProjectTweeter
//
//  Created by Niedermann Fabian on 27.02.13.
//  Copyright (c) 2013 NiedermannFabian. All rights reserved.
//

#import "NIFViewController.h"
#import <Social/Social.h>

@interface NIFViewController ()

@property (nonatomic, strong) IBOutlet UITextView *twitterTextView;
-(void)reloadTweets;
-(void)handleTwitterData: (NSData *) data
             urlResponse: (NSHTTPURLResponse *) urlResponse
                   error: (NSError *) error;

@end

@implementation NIFViewController

- (IBAction)handleTweetButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetVC setInitialText:NSLocalizedString(@"I just finished the first project in iOS SDK Development. #pragios", nil)];
        tweetVC.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [self dismissViewControllerAnimated:YES completion:NULL];
                [self reloadTweets];
            }
        };
        [self presentViewController:tweetVC animated:YES completion:NULL];
    } else {
        NSLog(@"Can't send tweet");
    }
}
- (IBAction)handleShowMyTweetsTapped:(id)sender {
    [self reloadTweets];
}

-(void)reloadTweets {
    NSURL *twitterAPIURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json"];
    NSDictionary *twitterParams = @{@"screen_name": @"FabiNiedermann",};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:twitterAPIURL
                                               parameters:twitterParams];
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        [self handleTwitterData:responseData
                    urlResponse:urlResponse
                          error:error];
    }];
}

-(void)handleTwitterData:(NSData *)data urlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error {
    NSError *jsonError = nil;
    NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    NSLog(@"jsonResponse: %@", jsonResponse);
    if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *tweets = (NSArray *) jsonResponse;
            for (NSDictionary *tweetDict in tweets) {
                NSString *tweetText = [NSString stringWithFormat:@"%@ (%@)", [tweetDict valueForKey:@"text"], [tweetDict valueForKey:@"created_at"]];
                self.twitterTextView.text = [NSString stringWithFormat:@"%@%@\n\n", self.twitterTextView.text, tweetText];
            }
        });
    }
}

@end
