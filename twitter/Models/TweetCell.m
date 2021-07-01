//
//  TweetCell.m
//  twitter
//
//  Created by Isaac Oluwakuyide on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender {
    
   
    //check whether the tweet was already liked
//    if ((self.likeButton.imageView.image == [UIImage imageNamed:@"favor-icon.png"]))   {
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
    self.likeNumberImageView.text = [NSString stringWithFormat:@"%d", likedNumber];
    
}

-(void) refreshDataUnLike {
    UIImage *liked = [UIImage imageNamed:@"favor-icon.png"];
    [self.likeButton setImage:liked forState:UIControlStateNormal];
    int likedNumber = self.tweet.favoriteCount;
    self.likeNumberImageView.text = [NSString stringWithFormat:@"%d", likedNumber];
    
}

-(void) refreshDataRetweet {
    UIImage *retweeted = [UIImage imageNamed:@"retweet-icon-green.png"];
    [self.retweetButton setImage:retweeted forState:UIControlStateNormal];
    int retweetedNumber = self.tweet.retweetCount;
    self.retweetNumberLabel.text = [NSString stringWithFormat:@"%d", retweetedNumber];
    
}

-(void) refreshDataUnRetweet {
    UIImage *retweeted = [UIImage imageNamed:@"retweet-icon.png"];
    [self.retweetButton setImage:retweeted forState:UIControlStateNormal];
    int retweetedNumber = self.tweet.retweetCount;
    self.retweetNumberLabel.text = [NSString stringWithFormat:@"%d", retweetedNumber];
    
}



@end
