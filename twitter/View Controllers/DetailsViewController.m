//
//  DetailsViewController.m
//  twitter
//
//  Created by Isaac Oluwakuyide on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = self.tweet.user.name;
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePictureView.image = [UIImage imageWithData:urlData];
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetContentLabel.text = self.tweet.text;
    self.timeLabel.text = self.tweet.timeH;
    self.dateLabel.text = self.tweet.dayD;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    if (self.tweet.favorited == YES)    {
        self.likeButton.imageView.image = [UIImage imageNamed:@"favor-icon-red.png"];
    }
    if (self.tweet.retweeted == YES)    {
        self.retweetButton.imageView.image = [UIImage imageNamed:@"retweeet-icon-green.png"];
    }
    
}


- (IBAction)didtapFavorite:(id)sender {
    if (self.tweet.favorited == NO)   {
        //update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshDataLike];
        
        //Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }   else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshDataUnLike];
        
        //Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO)   {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshDataRetweet];
        
        //Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        
    }   else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshDataUnRetweet];
        
        //Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
        
    }
}

-(void) refreshDataLike {
    UIImage *liked = [UIImage imageNamed:@"favor-icon-red.png"];
    [self.likeButton setImage:liked forState:UIControlStateNormal];
    int likedNumber = self.tweet.favoriteCount;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likedNumber];
    
}

-(void) refreshDataUnLike {
    UIImage *liked = [UIImage imageNamed:@"favor-icon.png"];
    [self.likeButton setImage:liked forState:UIControlStateNormal];
    int likedNumber = self.tweet.favoriteCount;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", likedNumber];
    
}

-(void) refreshDataRetweet {
    UIImage *retweeted = [UIImage imageNamed:@"retweet-icon-green.png"];
    [self.retweetButton setImage:retweeted forState:UIControlStateNormal];
    int retweetedNumber = self.tweet.retweetCount;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", retweetedNumber];
    
}

-(void) refreshDataUnRetweet {
    UIImage *retweeted = [UIImage imageNamed:@"retweet-icon.png"];
    [self.retweetButton setImage:retweeted forState:UIControlStateNormal];
    int retweetedNumber = self.tweet.retweetCount;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", retweetedNumber];
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
