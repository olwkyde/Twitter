//
//  ComposeViewController.h
//  twitter
//
//  Created by Isaac Oluwakuyide on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *) tweet;
@end


NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
