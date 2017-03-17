//
//  TwitterClient.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 2/26/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "3RCRql63dIVAtQDU9GIUqoGEz", consumerSecret: "GyAWq2XS4NEDgEKNpRFrC3V2qQSGW5vKzt9XSVXBBgYeIO8ehS")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twittereddemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url)
            
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification) , object: nil)
        
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token"
            , method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
                
                self.currentAccount(success: { (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: Error) -> () in
                    self.loginFailure?(error)
                })
        
                
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })

    }
    
    func homeTimeline (success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            //print("Account: \(response)")
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
           
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
        
    func retweet(id: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            
            //let tweet = Tweet.tweetsWithArray(dictionaries: response as! [NSDictionary])
            success()
            
            
        }) {(task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func unretweet(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func favorited(id: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            
            success()
            
        }) {(task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func unfavorite(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        
        post("1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func composeTweet(tweet: String, success: @escaping(Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/statuses/update.json?status=\(tweet)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet.init(dictionary: tweetDictionary)
            success(tweet)
        }) { (operation: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }

}
