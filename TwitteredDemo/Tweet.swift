//
//  Tweet.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 2/26/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetID: Int?
    var timeStampStr: String?
    var wasRetweeted: Bool
    var wasFavorited: Bool
    var shortTimestampStr: String?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String

        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        tweetID = dictionary["id"] as? Int
        
        
        // Determine whether or not a tweet was retweeted/favorited
        wasRetweeted = dictionary["retweeted"] as! Bool
        wasFavorited = dictionary["favorited"] as! Bool
        
        // Grab time tweet was created from dictionary
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            // Convert string to date
            timestamp = formatter.date(from: timeStampString)
            
            // Convert date back to string object
            formatter.dateFormat = "dd/MM/yyyy, HH:mm"
            shortTimestampStr = formatter.string(from: timestamp!)
            
            timeStampStr = DateUtils.getTimeElapsedSinceDate(sinceDate: timestamp!)

        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    class DateUtils: NSObject {
        static let dateFormatter = DateFormatter()
        static let dateComponentsFormatter = DateComponentsFormatter()
        
        static func getTimeElapsedSinceDate(sinceDate: Date) -> String {
            dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
            dateComponentsFormatter.collapsesLargestUnit = true
            dateComponentsFormatter.maximumUnitCount = 1
            let interval = NSDate().timeIntervalSince(sinceDate as Date)
            return dateComponentsFormatter.string(from: interval)!
        }
    }

}
