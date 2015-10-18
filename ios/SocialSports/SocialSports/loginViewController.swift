//
//  loginViewController.swift
//  SocialSports
//
//  Created by lengly on 15/10/15.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class loginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var token: Token?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func login(sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        // 向服务器发送登陆信息
        let params = ["email": email, "password": password]
        do {
            let opt = try HTTP.POST("http://isports-1093.appspot.com/sign_in", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
//                print("opt finished: \(response.description)")
//                注意 response.text! 是一个string 这里展示了如何讲获取到的string转化为json
//                print("text is: \(response.text!)") //show json
//                可以通过以下方式直接调用json
//                print(json["content"]["token"])
//                print(json["content"]["user_id"])
//                print(json["rc"])
                
                var json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                if json["rc"] == 200 {
                    //一切正常
                    self.token = Token(token: json["content"]["token"].stringValue)
                    self.saveToken()
                    print("Success")
                   // print(json["content"]["user_id"])
                    //登陆成功  跳转到首页
                    // MARK: TODO 跳转后去掉返回登陆的按钮
                    dispatch_async(dispatch_get_main_queue()) {
                        let myStoryBoard = self.storyboard//UIStoryboard(name:"welcome", bundle: nil)
                        let vc = myStoryBoard!.instantiateViewControllerWithIdentifier("index") as! UITabBarController
                        //self.presentViewController(vc, animated: true, completion: nil)
                        self.showViewController(vc, sender: self)
                    }
                }
                else {
                    // MARK: TODO 提示错误信息给用户
                    //有错误
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
    
    // MARK: NSCoding
    func saveToken() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(token!, toFile: Token.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }

    func loadMeals() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }

}
