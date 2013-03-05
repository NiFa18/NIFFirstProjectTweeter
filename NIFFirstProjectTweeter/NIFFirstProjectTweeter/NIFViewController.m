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

@end

@implementation NIFViewController

- (IBAction)handleTweetButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetVC setInitialText:@"I just finished the first project in iOS SDK Development. #pragios"];
        [self presentViewController:tweetVC animated:YES completion:NULL];
    } else {
        NSLog(@"Can't send tweet");
    }
}
- (IBAction)handleShowMyTweetsTapped:(id)sender {
    [self.twitterWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com/FabiNiedermann"]]];
}

@end
