//
//  mainpageViewController.swift
//  SocialSports
//
//  Created by mushroom12301 on 15/10/17.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class mainpageViewController: UIViewController {
    @IBOutlet weak var headpic: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //测试user_id 5654313976201216
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    //获取用户信息，设置Authorization字段为token值
    func getProfile(){
        let tokenObj = self.loadMeals()
        //print(token!.token)
        let token = tokenObj!.token;
        do{
            let opt = try HTTP.GET("http://isports-1093.appspot.com/profile", headers: ["Authorization": token])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                //响应的内容
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                //print((json))
                //print(json["content"])
                let content = json["content"]
                //头像
                //print(self.nickname.text)
                //let head_pic = content["head_pic"]
                let nick_name = content["nick_name"].string
                self.nickname.text = nick_name
                //TODO:头像显示
                //print(self.nickname.text)
                
            }
        }catch let error{
             print("couldn't get user profile: \(error)")
        }
        
        do{
            //TODO:NTC时间
            var date = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateString = formatter.stringFromDate(date)
            print(dateString)
            
            let optmoments = try HTTP.POST("http://isports-1093.appspot.com//moment/all", parameters:["time_stamp":dateString],headers: ["Authorization": token])
            optmoments.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                //响应的内容
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                //print((json))
                //print(json["content"])
                let content = json["content"]
                print(content)
            }
        }catch let error{
            print("couldn't get user profile: \(error)")
        }
    }
    
    func loadMeals() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }
}
