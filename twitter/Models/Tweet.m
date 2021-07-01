//
//  Tweet.m
//  twitter
//
//  Created by Isaac Oluwakuyide on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        self.reply_count = [dictionary[@"reply_count"] intValue];

        // TODO: Format and set createdAtString
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
        //Configure input format to parse the date String
        format2.dateFormat = @"HH:mm";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        self.timeH = [format2 stringFromDate: createdAtOriginalString];
        self.date = date;
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.createdAtString = [formatter stringFromDate:date];
        
        NSDateFormatter *format3 = [[NSDateFormatter alloc] init];
        format3.dateFormat = @"MM-dd-yyyy";
        self.dayD = [format3 stringFromDate: createdAtOriginalString];
    
    }
    return self;
    
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
        NSMutableArray *tweets = [NSMutableArray array];
        for (NSDictionary *dictionary in dictionaries) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
            [tweets addObject:tweet];
        }
        return tweets;
    }

@end
