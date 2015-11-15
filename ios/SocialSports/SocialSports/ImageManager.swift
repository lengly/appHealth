//
// Created by 李学兵 on 15/11/7.
// Copyright (c) 2015 lengly. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON

class ImageManager {
    static let instance = ImageManager()

    func uploadImage(imageUrl: NSURL) -> Bool {
        let token = self.loadMeals()!.token
        do {
            let opt = try HTTP.GET("http://isports-1093.appspot.com/upload/get_url", headers: ["Authorization": token])
            opt.start {
                response in
                if let _ = response.error {
                    return
                }
                let json = JSON(data: response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                let postUrl = json["content"].rawString()

                print(postUrl)
                self._uploadImage(imageUrl, postUrl: postUrl!)
            }
        } catch let _ {}
        return true
    }

    func _uploadImage(imageUrl: NSURL, postUrl: String) {
        do {
            let opt = try HTTP.POST(postUrl, parameters: ["pic_file", Upload(fileUrl: imageUrl)])
            opt.start {
                response in
                if let _ = response.error {
                    print("+++")
                    return
                }
                print(response)
                let json = JSON(data: response.text!.dataUsingEncoding(NSUTF8StringEncoding)!)
                let content = json["content"]
                let blob_key = content["blob_key"]
                print(blob_key)
            }
        } catch let _ {}
    }

    func downloadImage() {

    }

    func loadMeals() -> Token? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Token.ArchiveURL.path!) as? Token
    }
}
