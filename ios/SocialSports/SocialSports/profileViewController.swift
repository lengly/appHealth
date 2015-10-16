//
//  profileViewController.swift
//  SocialSports
//
//  Created by lengly on 15/10/16.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit

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
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
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

}
