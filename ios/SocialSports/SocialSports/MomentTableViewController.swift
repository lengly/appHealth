//
//  SportCircleTableViewController.swift
//  SocialSports
//
//  Created by 何羿宏 on 15/12/19.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class MomentTableViewController: UITableViewController {
    
    class MomentVO {
        var userPhoto: UIImage?
        
        var username: String = ""
        
        var userWords: String = ""
        
        init(userPhoto: UIImage, username: String, userWords: String) {
            self.userPhoto = userPhoto
            self.username = username
            self.userWords = userWords
        }
    }
    
    var moments : [MomentVO] = []
    
    func loadToken() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }
    
    func loadMomentData() {
        let tokenObj = loadToken()
        let token = tokenObj!.token;
        let param = ["time_stamp" : "2014-01-01 00:00:00"]
        do{
            let opt = try HTTP.POST("http://isports-1093.appspot.com/moment/all", parameters : param, headers: ["Authorization": token])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                //响应的内容
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                let momentArray = json["content"]["moments"].array
                print(momentArray)
                if (momentArray != nil) {
                    for moment in momentArray! {
                        let userid = moment["user_id"].stringValue
                        var username: String
                        var userPhoto: UIImage
                        
                        if userid == "5659313586569216" {
                            username = "Test"
                            userPhoto = UIImage(named: "dada")!
                        } else if userid == "5707702298738688" {
                            username = "Alice"
                            userPhoto = UIImage(named: "bing")!
                        } else {
                            username = "Bob"
                            userPhoto = UIImage(named: "Image")!
                        }
                        let userWords = moment["text"].stringValue
                        self.moments.append(MomentVO(userPhoto: userPhoto, username: username, userWords: userWords))
                    }
                }
                print(momentArray)
                
            }
            opt.waitUntilFinished()
        }catch let error{
            print("couldn't get comments infomation: \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        print("111111111111111111111")
        loadMomentData()
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(moments.count)
        print("=========")
        usleep(1000)
        return moments.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MomentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MomentTableViewCell
        let row = indexPath.row
        cell.usernameLable.text = moments[row].username
        cell.userWordsTextView.text = moments[row].userWords
        cell.userPhotoImageView.image = moments[row].userPhoto
        print(indexPath.row)
        print(moments[row])
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
