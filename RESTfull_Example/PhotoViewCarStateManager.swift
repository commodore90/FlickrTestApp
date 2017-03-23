//
//  PhotoViewCarStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/22/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewCarStateManager : FlickrPhotoViewBaseStateManager {
    
    override init () {
        super.init(photoTag: "Car"); // PhotoTagTest
    }
    
    
    /*
     Test if user is logged in
     */
    override func testIfUserIsLoggedIn() {
        self.flickrLoggingAPI.flickrLoginTest() { (loginCompletion) in
            switch loginCompletion {
            case .Success(_):
                print("User is logged in");
            case .Failure(let loginError):
                print("Login error : \(loginError)")
            }
        }
    }
    

    /*
     Search images by photo tag and show it
     */
    
     // override func fetchPhoto() {
     //     super.fetchPhoto();
     // }
}
