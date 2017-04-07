//
//  FlickrPhotoViewBaseStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/23/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotoViewBaseStateManager { // : FlickrPhotoViewStateManagerProtocol {
    
//    weak var photoViewDelegate: FlickrPhotoViewControllerProtocol? // internal ?
//    
//    // var photoTagTest:String?
//    var photoTag:String?
//    
//    // API instances
//    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
//    var flickrPhotoAPI:FlickrPhotoAPI         = FlickrPhotoAPI.init();
//
//    /*
//        Initializer
//    */
//    init () {
//        
//    }
//    
//    init (photoTag: String) { // photoTagTest
//        self.photoTag = photoTag;
//    }
//    
//    /*
//     Test if User is Logged in
//    */
//    func testIfUserIsLoggedIn() {
//        self.flickrLoggingAPI.flickrLoginTest() { (loginCompletion) in
//            switch loginCompletion {
//            case .Success(_):
//                print("User is logged in");
//            case .Failure(let loginError):
//                print("Login error : \(loginError)")
//            }
//        }
//    }
//    
//    /*
//     Search images by photo tag and show it
//     */
//
//    func fetchPhoto(photoContext: flickrPhotoContext, completionHandler: @escaping (AsyncResult<Bool>) -> ()) {  // added new argument, photo context
//
//        let photoContext:flickrPhotoContext = flickrPhotoContext.init();
//
//        /*
//         Download Photo
//         */
//        self.flickrPhotoAPI.flickrDownloadPhotoFromURLUsingPhotoContext(photoContext: photoContext) { (downloadPhoto) in
//            switch downloadPhoto {
//            case .Success(let data):
//                // Load and show some image
//                self.photoViewDelegate?.showFlickrPhoto(photo: UIImage(data: data)!)
//                completionHandler(AsyncResult.Success(true));
//                break;
//            case .Failure(let downloadPhotoError):
//                print("Download Photo Error: \(downloadPhotoError)");
//                completionHandler(AsyncResult.Failure(downloadPhotoError));
//            }
//        }
//    }
//    
//    /*
//    Get Photo info
//    */
//    func getPhotoInfo(photoContext: flickrPhotoContext) {
//        self.flickrPhotoAPI.flickrGetPhotoInfo(photoContext: photoContext) { (photoInfo) in
//            switch photoInfo {
//            case .Success(_):
//                break;
//            case .Failure(let photoInfoError):
//                print("Photo Info error \(photoInfoError)");
//                break;
//            }
//        }
//    }
}
