//
//  User.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 2/26/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    var profileBannerImageURL: NSURL?
    var tweetCount = 0
    var followerCount = 0
    var followingCount = 0
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let profileBannerString = dictionary["profile_banner_url"] as? String
        if let profileBannerString = profileBannerString {
            profileBannerImageURL = NSURL(string: profileBannerString)
        }
        
        tagline = dictionary["description"] as? String
        
        tweetCount = dictionary["statuses_count"] as! Int
        followingCount = dictionary["followers_count"] as! Int
        followerCount = dictionary["friends_count"] as! Int
    }

    static let userDidLogoutNotification = "UserDidLogout"

    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUserData") as? Data
            
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
                //defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
            
        }
    }

        
}
