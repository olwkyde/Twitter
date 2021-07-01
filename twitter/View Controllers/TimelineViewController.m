//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "NSDate+DateTools.h"
#import "DetailsViewController.h"


@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)logoutButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self loadTweets];
    
    // Get timeline
}

- (void)viewDidAppear:(BOOL)animated    {
    NSLog(@"In view did appear");
    [self loadTweets];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated    {
    NSLog(@"In view will appear");
    [self loadTweets];
    [self.tableView reloadData];
}

-(void) loadTweets  {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
            
//            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation
//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"detailViewSegue"]){
        TweetCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }else{
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}


- (IBAction)logoutButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];

    cell.tweet = tweet;
    NSDate *timeAgoData = [NSDate dateWithTimeInterval:-4 sinceDate:tweet.date];
    cell.handleLabel.text =  [@"@" stringByAppendingString:tweet.user.screenName];
    cell.usernameLabel.text = tweet.user.name;
    cell.dateLabel.text = ((void)(@"Time Ago: %@"), timeAgoData.shortTimeAgoSinceNow);
    cell.tweetTextLabel.text = tweet.text;
    cell.retweetNumberLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    cell.likeNumberImageView.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    if (cell.tweet.favorited == YES)    {
        cell.likeButton.imageView.image = [UIImage imageNamed:@"favor-icon-red.png"];
    }   else {
        cell.likeButton.imageView.image = [UIImage imageNamed:@"favor-icon.png"];
    }
    if (cell.tweet.retweeted == YES)    {
        cell.retweetButton.imageView.image = [UIImage imageNamed:@"retweeet-icon-green.png"];
    }   else{
        cell.retweetButton.imageView.image = [UIImage imageNamed:@"retweeet-icon.png"];
    }
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileImage.image = nil;
    cell.profileImage.image = [UIImage imageWithData:urlData];
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}


- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}


@end
