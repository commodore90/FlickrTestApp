//
//  FlickrPhotoViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/16/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrPhotoViewController: UIViewController {
    
    var flickrLoggingAPI:FlickrLoggingTestAPI = FlickrLoggingTestAPI.init();
    var flickrPhotoAPI  :FlickrPhotoAPI       = FlickrPhotoAPI.init();
    
    var photoContextArray:[flickrPhotoContext] = [flickrPhotoContext.init()];
    var photoContext:flickrPhotoContext        = flickrPhotoContext.init();
    let photoTag:String = "Concorde";
    
    @IBOutlet weak var flickrImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 
            Format image View
        */
        flickrImageView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
            .flexibleBottomMargin,
            .flexibleRightMargin,
            .flexibleLeftMargin,
            .flexibleTopMargin
        ]
        flickrImageView.contentMode   = UIViewContentMode.scaleAspectFit;
        flickrImageView.clipsToBounds = true;
        
        /* 
            Test if user is logged in
        */
        flickrLoggingAPI.flickrLoginTest() { (loginCompletion) in  // accessToken: FlickrSessionAuthorization.sharedInstance.getAccessToken()
            
            switch loginCompletion {
            case .Success(_):
                print("User is logged in");
            case .Failure(let loginError):
                print("Login error : \(loginError)")
            }
        }
        
        /* 
            Search images by photo tag
        */
        flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: photoTag) { (photosSearch) in
            
            switch photosSearch {
                
            case .Success(let photoContextArray) :
                self.photoContextArray = photoContextArray;
                self.photoContext = self.photoContextArray[1];
                /*
                 Download Photo
                 */
                self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoContext: self.photoContext) { (downloadPhoto) in
                    
                    switch downloadPhoto {
                    case .Success(let data):
                        // Load some image
                        self.flickrImageView.image = UIImage(data: data)
                        
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
