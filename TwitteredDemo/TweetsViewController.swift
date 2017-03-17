//
//  TweetsViewController.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 2/26/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            /*
            for tweet in tweets {
                
                print(tweet.text!)
                
            }
            */
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        // Set delegate for profile tap
        cell.delegate = self
        
        cell.tweet = tweets![indexPath.row]
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }

    @IBAction func onTweetButton(_ sender: Any) {
        self.performSegue(withIdentifier: "ComposeTweetSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
                
        if (segue.identifier == "TweetDetails") {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.tweet = tweet
            
        }
            
        else if (segue.identifier == "ProfileSegue") {
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let navigationcontroller = segue.destination as! UINavigationController
            let viewController = navigationcontroller.topViewController as! ProfileViewController
            viewController.tweet = tweet
            viewController.user = tweet.user
        }
    }
}

extension TweetsViewController: TweetTableViewCellDelegate{
    func profileImageViewTapped(cell: TweetCell, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController" ) as? ProfileViewController {
            profileVC.user = user //set the profile user before your push
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
