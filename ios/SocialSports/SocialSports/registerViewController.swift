//
//  registerViewController.swift
//  SocialSports
//
//  Created by lengly on 15/10/15.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class registerViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func register(sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let repeatPassword = repeatPasswordTextField.text!
        
        // 验证重复输入的密码是否一致  若不一致则弹出警告
        if password != repeatPassword {
            let alertController = UIAlertController(title: "错误", message: "密码不一致", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // 向服务器发送注册信息
        let params = ["email": email, "name": email, "password": password]
        do {
            let opt = try HTTP.POST("http://isports-1093.appspot.com/sign_up", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
//                print("data is: \(response.data)") //access the response of the data with response.data
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                
                
                // MARK: TODO
                // 这里检测成功或者失败应该给用户一个提示
                if json["rc"] == 200 {
                    //注册成功
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    //注册失败
                    print(json["content"].stringValue)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }
    

    // MARK: - Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
