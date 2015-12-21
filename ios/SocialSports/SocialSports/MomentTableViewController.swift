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
        var userPhoto: String = ""
        
        var username: String = ""
        
        var userWords: String = ""
        
        init(userPhoto: String, username: String, userWords: String) {
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
                let momentArray = json["content"]["moments"][0].array
                if (momentArray != nil) {
                    for moment in momentArray! {
                        let username = moment["user_id"].stringValue
                        let userPhoto = moment["pic"].stringValue
                        let userWords = moment["text"].stringValue
                        self.moments.append(MomentVO(userPhoto: userPhoto, username: username, userWords: userWords))
                    }
                }
                
            }
            opt.waitUntilFinished()
        }catch let error{
            print("couldn't get comments infomation: \(error)")
        }
        
    }
    
    override func viewDidLoad() {
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
        return moments.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MomentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MomentTableViewCell
        let row = indexPath.row
        cell.usernameLable.text = moments[row].username
        cell.userWordsTextView.text = moments[row].userWords
        // TODO set photo image
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
