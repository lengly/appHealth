//
//  publishViewController.swift
//  
//
//  Created by mushroom12301 on 15/10/17.
//
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class publishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var text: UITextView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func createMoment(sender: UIBarButtonItem) {
        let tokenObj = self.loadMeals()
        //print(token!.token)
        let token = tokenObj!.token;
        //print(self.text.text)
        let textval = self.text.text
        //TODO:图片、转发
        let params = ["text": textval]
        do{
            let opt = try HTTP.POST("http://isports-1093.appspot.com/moment/create", parameters: params, headers: ["Authorization": token])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print(response.description)
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                print(json["content"])
                let content = json["content"]
                if content["moment_id"] != nil {
                    print("发布状态成功")
                }
            }
        }catch let error{
            print("couldn't get user profile: \(error)")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadMeals() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }
}