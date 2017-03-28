//
//  FlickrPhotoViewBaseStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/23/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

class FlickrPhotoViewBaseStateManager : FlickrPhotoViewStateManagerProtocol {
    
    weak var photoViewDelegate: FlickrPhotoViewControllerProtocol? // internal ?
    
    // class var photoTag:String {
    //     return "";
    // }
    
    // var photoTagTest:String?
    var photoTag:String?
    
    // API instances
    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI:FlickrPhotoAPI         = FlickrPhotoAPI.init();
    
    // init(photoTag:String) {
    //     self.photoTag = photoTag;
    // }
    
    /*
        Initializer
    */
    init () {
    }
    
    init (photoTag: String) { // photoTagTest
        // self.photoTagTest = photoTagTest;
        self.photoTag = photoTag;
    }
    
    /*
     Test if User is Logged in
    */
    func testIfUserIsLoggedIn() {
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

    // func fetchPhoto(photoTag:String) {
    func fetchPhoto(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
        var photoContext:flickrPhotoContext = flickrPhotoContext.init();
        var photoIterator:Int?;
        
        self.flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: self.photoTag!) { (photosSearch) in
            
            switch photosSearch {
                
            case .Success(let photoContextArrayRsp) :
                photoIterator = Int(arc4random_uniform(UInt32(photoContextArrayRsp.count)))
                photoContext = photoContextArrayRsp[photoIterator!];
                /*
                 Download Photo
                 */
                self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoContext: photoContext) { (downloadPhoto) in
                    switch downloadPhoto {
                    case .Success(let data):
                        // Load and show some image
                        self.photoViewDelegate?.showFlickrPhoto(photo: UIImage(data: data)!)
                        completionHandler(AsyncResult.Success(true));
                        break;
                    case .Failure(let downloadPhotoError):
                        print("Download Photo Error: \(downloadPhotoError)");
                        completionHandler(AsyncResult.Failure(downloadPhotoError));
                    }
                }
                
                print("Search Complete!");
                break;
            case .Failure(let photosSearchError):
                print("Photos Search error!: \(photosSearchError)");
                break;
                
            }
        }
    }
}
