//
//  ProfileViewController.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 3/16/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileBannerImageView: UIImageView!
    @IBOutlet weak var numberOfTweets: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var actualProfileImage: UIImageView!
    
    
    
    var user: User!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.profileBannerImageURL != nil {
            
            profileBannerImageView.setImageWith(user.profileBannerImageURL as! URL)
        }
        actualProfileImage.setImageWith(user?.profileUrl as! URL)
        
        nameLabel.text = user?.name
        screenNameLabel.text = "@" + (user?.screenname)!
        numberOfTweets.text = "\(user.tweetCount)\n Tweets"
        followerLabel.text = "\(user.followerCount)\n Followers"
        followingLabel.text = "\(user.followingCount)\n Following"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onComposeTweet(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ComposeTweetSegue", sender: nil)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ComposeTweetSegue") {
            
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            composeTweetViewController.tweet = tweet
            composeTweetViewController.user = user
        }
    }
}

