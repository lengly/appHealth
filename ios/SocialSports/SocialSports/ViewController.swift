//
//  ViewController.swift
//  SocialSports
//
//  Created by lengly on 15/10/14.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTestAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! UIKit.UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)

    }
}

