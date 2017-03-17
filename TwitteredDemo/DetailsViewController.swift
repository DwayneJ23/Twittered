//
//  DetailsViewController.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 3/5/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var detailRetweetButton: UIButton!
    @IBOutlet weak var detailFavoriteButton: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userNameLabel.text = tweet.user?.name
        self.userNameLabel.text = "@" + (tweet.user?.screenname)!
        self.tweetTextLabel.text = tweet.text
        self.timestamp.text = tweet.shortTimestampStr
        self.userImage.setImageWith((tweet.user?.profileUrl)! as URL)
        self.retweetCountLabel.text = "\(tweet.retweetCount)"
        self.favoritesCountLabel.text = "\(tweet.favoritesCount)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDetailRetweetButton(_ sender: Any) {
        
        if tweet.wasRetweeted == false {
            
            detailRetweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetID!, success: { (tweet) in
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            retweetCountLabel.text = "\((tweet.retweetCount)+1)"
            tweet.wasRetweeted = true
            
        }
        else {
            
            detailRetweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
            retweetCountLabel.text = "\((tweet.retweetCount))"
            tweet.wasRetweeted = false
            
        }
    }

    @IBAction func onDetailFavoriteButton(_ sender: Any) {
        if tweet.wasFavorited == false {
            
            detailFavoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.favorited(id: tweet.tweetID!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            favoritesCountLabel.text = "\((tweet.favoritesCount)+1)"
            tweet.wasFavorited = true
            
        }
        else {
            detailFavoriteButton.setImage(UIImage(named: "fav-icon"), for: UIControlState.normal)
            favoritesCountLabel.text = "\((tweet.favoritesCount))"
            tweet.wasFavorited = false
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
