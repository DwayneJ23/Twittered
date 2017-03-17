//
//  ComposeTweetViewController.swift
//  TwitteredDemo
//
//  Created by Dwayne Johnson on 3/16/17.
//  Copyright © 2017 Dwayne Johnson. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var replyText: UITextView!
    
    var tweet: Tweet!
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendButtonClicked(_ sender: Any) {
        
        let text = replyText.text
        
        let tweetmsg = text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        TwitterClient.sharedInstance?.composeTweet(tweet: tweetmsg!, success: { (tweet: Tweet) in
            self.dismiss(animated: true, completion: nil)
        }) { (error: Error) in
            print(error.localizedDescription)
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
