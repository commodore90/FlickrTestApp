//
//  PhotoViewBikeStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/22/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

/*
class PhotoViewBikeStateManager:FlickrPhotoViewStateManagerProtocol {
    
    weak var photoViewDelegate: FlickrPhotoViewControllerProtocol? // internal ?
    let photoTag:String = "Bike"
    
    init() {
        
    }
    
    // API instances
    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI:FlickrPhotoAPI         = FlickrPhotoAPI.init();
    
    /*
     Test if user is logged in
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
    func fetchPhoto() {
        // var photoContextArray:[flickrPhotoContext] = [flickrPhotoContext]();
        var photoContext:flickrPhotoContext        = flickrPhotoContext.init();
        var photoIterator:Int?;
        
        self.flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: photoTag) { (photosSearch) in
            
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
                            break;
                        case .Failure(let downloadPhotoError):
                            print("Download Photo Error: \(downloadPhotoError)");
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
*/
