//
//  TweetCell.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 2/27/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate: class  {
    
    func profileImageViewTapped(cell: TweetCell, user: User)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView! {
        
        didSet {
            self.userProfileImage.isUserInteractionEnabled = true //make sure this is enabled
            //tap for userImageView
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
            self.userProfileImage.addGestureRecognizer(userProfileTap)
        }
    }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer) {
        if let delegate = delegate{
            
            delegate.profileImageViewTapped(cell: self, user: self.tweet.user!)
        }
    }

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: TweetTableViewCellDelegate?
    
    
    
    var tweet: Tweet! {
        didSet {
            
            userName.text = tweet.user?.name
            userHandle.text = "@ " + (tweet.user?.screenname)!
            tweetText.text = tweet.text as String?
            timeStamp.text = tweet.timeStampStr


            userProfileImage.setImageWith((tweet.user?.profileUrl)! as URL)
            //print("\(tweet.user?.profileUrl)!")
            

            if tweet.retweetCount != 0 && tweet.retweetCount < 1000 {
                retweetLabel.text = String(tweet.retweetCount)
            }
            else if tweet.retweetCount > 1000 {
                retweetLabel.text = "\(Double(tweet.retweetCount/1000)) k"
            }
            
            
            if tweet.favoritesCount != 0 && tweet.favoritesCount < 1000 {
            
                favoriteLabel.text = String(tweet.favoritesCount)
            }
            else if tweet.favoritesCount > 1000 {
                favoriteLabel.text = "\(Double(tweet.favoritesCount/1000)) k"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        
        if tweet.wasRetweeted == false {
            
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.retweet(id: tweet.tweetID!, success: { (tweet) in
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            retweetLabel.text = "\((tweet.retweetCount)+1)"
            tweet.wasRetweeted = true
            
        }
        else if tweet.wasRetweeted == true {
            
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.unretweet(id: "\(tweet.tweetID!)", success: { (tweet) in
                
            }, faliure: { (error: Error) in
                print (error.localizedDescription)
            })
            
            retweetLabel.text = "\((tweet.retweetCount))"
            tweet.wasRetweeted = false
        }
    }

    @IBAction func onFavoriteButton(_ sender: Any) {
        
        if tweet.wasFavorited == false {
            
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            
            TwitterClient.sharedInstance?.favorited(id: tweet.tweetID!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            favoriteLabel.text = "\((tweet.favoritesCount)+1)"
            tweet.wasFavorited = true
            
        }
        else if tweet.wasFavorited == true {
            
            favoriteButton.setImage(UIImage(named: "fav-icon"), for: UIControlState.normal)
            TwitterClient.sharedInstance?.unfavorite(id: "\(tweet.tweetID!)", success: { (Tweet) in
                
            }, faliure: { (error: Error) in
                print(error.localizedDescription)
        
            })
            
            favoriteLabel.text = "\((tweet.favoritesCount))"
            tweet.wasFavorited = false
            
        }
    }
}
