//
//  profileViewController.swift
//  SocialSports
//
//  Created by lengly on 15/10/16.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class profileViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        nicknameTextField.delegate = self
        birthdayTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: Actions
    //点击按钮性别变成男
    @IBAction func maleButton(sender: UIButton) {
        genderTextField.text = "男"
    }
    //点击按钮性别变成女
    @IBAction func femaleButton(sender: UIButton) {
        genderTextField.text = "女"
    }
    //选择头像
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nicknameTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
//    @IBAction func birthdaySelect(sender: UITextField) {
//        let controller = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//        let containerViewWidth = 250
//        let containerViewHeight = 300
//        let containerFrame = CGRectMake(10, 70, CGFloat(containerViewWidth), CGFloat(containerViewHeight));
//        
//        let datePicker = UIDatePicker(frame: containerFrame)
//        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        
//        controller.view.addSubview(datePicker)
//        
//        controller.addAction(cancelAction)
//        
//        
//    }
    
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        let tokenObj = self.loadToken()
        let token = tokenObj!.token;
        do {
            let opt = try HTTP.GET("http://isports-1093.appspot.com/upload/get_url", headers: ["Authorization": token])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                
                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                print(json)
                
                // MARK: TODO
                if json["rc"] == 200 {
                    //获取url成功
                    let imageUrl: String = json["content"].stringValue
                    print(imageUrl)
//                    var params = ["pic_file": self.headImageView.image!]

                    let fileUrl = NSURL(fileURLWithPath: "/Users/dalton/Desktop/testfile")
                    do {
                        let opt = try HTTP.POST("https://domain.com/new", parameters: ["aParam": "aValue", "file": Upload(fileUrl: fileUrl)])
                        opt.start { response in
                            //do things...
                        }
                    } catch let error {
                        print("got an error creating the request: \(error)")
                    }
                    
                }
                else {
                    //获取url失败
                    //                    print(json["content"].stringValue)
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }

        
//        let params = ["nick_name": nicknameTextField.text!,
//                    "birthday": birthdayTextField.text!,
//                    "gender": genderTextField.text!,
//                    "password": passwordTextField.text!,
//                    "head_pic": headImageView.image!]
//        do {
//            let opt = try HTTP.POST("http://isports-1093.appspot.com/profile/edit", parameters: params, headers: ["Authorization": token])
//            opt.start { response in
//                if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                    return //also notify app of failure as needed
//                }
//                print("opt finished: \(response.description)")
//                //                print("data is: \(response.data)") //access the response of the data with response.data
//                let json = JSON(data:response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
//                print(json)
//                
//                // MARK: TODO
//                // 这里检测成功或者失败应该给用户一个提示
//                if json["rc"] == 200 {
//                    //注册成功
////                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//                else {
//                    //注册失败
////                    print(json["content"].stringValue)
//                }
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }

        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }

    var imageUrl: NSURL?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
        print(imageUrl)

        // Set photoImageView to display the selected image.
        headImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        print("nickname: " + nicknameTextField.text!)
//        print("birthday: " + birthdayTextField.text!)
//        print("password: " + passwordTextField.text!)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadToken() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }

    @IBAction func TestAction(sender: UIButton, forEvent event: UIEvent) {
//        let imageManager = ImageManager.instance
//        imageManager.uploadImage(self.imageUrl!)
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! UIKit.UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}
